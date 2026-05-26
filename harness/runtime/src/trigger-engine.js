// trigger-engine.js — Triggers.json 인터프리터
// 입력: 컴파일된 트리거 (statements + type + period). 신뢰 출처는 build/<game>/Triggers.json.
//
// statement 종류:
//   { call: { method, assignments } }           → board/unit/skill 메서드 호출 (액션)
//   { condition: { expression, statements, elseStatements } } → if-then-else
//
// trigger.type: 'OnUpdate' 면 period(초) 마다 주기 실행. 없으면 OnStart.

import { evalPostfix, resolveAssignments } from './expression.js';

export class TriggerEngine {
  constructor(board, loader) {
    this.board = board;
    this.loader = loader;
    this.updateTriggers = [];   // periodic 트리거 [{trigger, periodMs, lastFireMs, vars}]
    this.mapVars = {};          // 맵 단위 vars (현재 미사용 — 향후 확장)
  }

  // 트리거 이름으로 실행 (예: SendWaveQueuedEvent 가 큐잉한 트리거)
  fire(triggerName, extraVars = {}) {
    const trigger = this.loader.getTrigger(triggerName);
    if (!trigger) {
      console.warn(`[TriggerEngine] No trigger: ${triggerName}`);
      return;
    }
    const vars = { ...(trigger.vars || {}), ...extraVars };
    this._executeStatements(trigger.statements || [], vars);
  }

  // 맵 시작 시: triggers[] 분류 — OnStart 는 즉시(큐 대상 제외), OnUpdate 는 주기 등록
  bootstrapMap(map) {
    // 1단계: SendWaveQueuedEvent 의 대상 트리거를 미리 수집 (auto-fire 방지)
    const queuedTargets = new Set();
    for (const triggerName of (map.triggers || [])) {
      const trigger = this.loader.getTrigger(triggerName);
      if (!trigger) continue;
      this._scanQueuedTargets(trigger.statements || [], queuedTargets);
    }

    // 2단계: 분기 실행
    for (const triggerName of (map.triggers || [])) {
      const trigger = this.loader.getTrigger(triggerName);
      if (!trigger) continue;
      const type = trigger.type || 'OnStart';
      const vars = { ...(trigger.vars || {}) };
      if (type === 'OnStart') {
        if (!queuedTargets.has(triggerName)) {
          this._executeStatements(trigger.statements || [], vars);
        }
      } else if (type === 'OnUpdate') {
        this.updateTriggers.push({
          trigger,
          periodMs: (trigger.period || 1) * 1000,
          lastFireMs: performance.now(),
          vars,
        });
      }
    }
  }

  // 매 프레임 호출: 큐잉된 트리거 + 주기 트리거 처리
  tick(nowMs) {
    const queued = this.board.flushQueuedTriggers();
    for (const name of queued) this.fire(name);

    for (const t of this.updateTriggers) {
      if (nowMs - t.lastFireMs >= t.periodMs) {
        this._executeStatements(t.trigger.statements || [], t.vars);
        t.lastFireMs = nowMs;
      }
    }
  }

  // ── 내부 ──

  _scanQueuedTargets(stmts, set) {
    for (const stmt of stmts) {
      if (stmt.call) {
        const methodType = stmt.call.method?.boardMethod?.type;
        if (methodType === 'SendWaveQueuedEvent') {
          // TriggerName 인자 추출
          for (const a of (stmt.call.assignments || [])) {
            if (a.variable?.parameter?.type === 'TriggerName') {
              const v = a.expression?.postfix?.[0]?.operand?.constant?.value;
              if (typeof v === 'string') set.add(v);
            }
          }
        }
      } else if (stmt.condition) {
        this._scanQueuedTargets(stmt.condition.statements || [], set);
        this._scanQueuedTargets(stmt.condition.elseStatements || [], set);
      }
    }
  }

  _executeStatements(stmts, vars) {
    const ctx = { vars, board: this.board, predef: {} };
    const stateBefore = this.board.boardState;
    for (const stmt of stmts) {
      this._executeStatement(stmt, ctx);
      // boardState 가 변경되면 남은 stmt 는 다음 tick 으로 미룬다 (cascade 방지)
      if (this.board.boardState !== stateBefore) break;
    }
  }

  _executeStatement(stmt, ctx) {
    if (stmt.call) {
      this._executeCall(stmt.call, ctx);
    } else if (stmt.condition) {
      const cond = evalPostfix(stmt.condition.expression.postfix, ctx);
      const branch = cond ? stmt.condition.statements : stmt.condition.elseStatements;
      this._executeStatements(branch || [], ctx.vars);
    }
  }

  _executeCall(call, ctx) {
    const method = call.method || {};
    const [receiverKey, methodSpec] = Object.entries(method)[0] || [];
    const methodName = methodSpec?.type;
    const receiver =
      receiverKey === 'boardMethod' ? this.board :
      receiverKey === 'unitMethod'  ? ctx.unit  :
      receiverKey === 'skillMethod' ? ctx.skill :
      receiverKey === 'buffMethod'  ? ctx.buff  : null;
    if (!receiver) {
      console.warn(`[TriggerEngine] receiver 없음: ${receiverKey}`);
      return;
    }
    const fn = receiver[methodName];
    if (typeof fn !== 'function') {
      console.warn(`[TriggerEngine] ${receiverKey}.${methodName} 미구현`);
      return;
    }
    // 액션은 명명 인자 — { paramType: value } 객체로 전달
    const args = resolveAssignments(call.assignments, ctx);
    // Parameter 이름 → camelCase 변환 (UnitDataId → unitDataId)
    const camel = {};
    for (const [k, v] of Object.entries(args)) {
      camel[k.charAt(0).toLowerCase() + k.slice(1)] = v;
    }
    fn.call(receiver, camel);
  }
}
