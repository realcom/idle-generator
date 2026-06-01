// expression.js — ResourceTrigger Expression postfix(RPN) 평가기
// 입력: Triggers.json 의 expression.postfix 배열
// 출력: 평가된 값 (number/bool/string)
//
// 노드 종류:
//   { operator: { type: "Equal" } }                          이항 연산자
//   { operand: { constant: { value: ... } } }                상수
//   { operand: { variable: { triggerVariable: { name } } } } 트리거 vars 참조
//   { operand: { variable: { predefinedVariable: { type } } } } 사전정의 변수
//   { operand: { call: { method: { boardMethod|unitMethod: { type } },
//                        assignments: [{ expression, variable }, ...] } } }
//   ※ method call 은 우리 자체 확장 (idlez 컴파일러 idlez_compile.py 와 페어).

const OPS = {
  Or: (a, b) => !!a || !!b,
  And: (a, b) => !!a && !!b,
  Equal:    (a, b) => +a === +b,
  NotEqual: (a, b) => +a !== +b,
  GreaterThan:        (a, b) => +a >  +b,
  GreaterThanOrEqual: (a, b) => +a >= +b,
  LessThan:           (a, b) => +a <  +b,
  LessThanOrEqual:    (a, b) => +a <= +b,
  Add:      (a, b) => +a + +b,
  Subtract: (a, b) => +a - +b,
  Multiply: (a, b) => +a * +b,
  Divide:   (a, b) => +a / +b,
  Modulo:   (a, b) => +a % +b,
};

// ─────────────────────────────────────────────────────────────
// 공개 API
// ─────────────────────────────────────────────────────────────

/** postfix 식을 평가한다. */
export function evalPostfix(postfix, ctx) {
  const stack = [];
  for (const node of postfix) {
    if (node.operator) {
      const fn = OPS[node.operator.type];
      if (!fn) throw new Error(`Unknown operator: ${node.operator.type}`);
      const b = stack.pop(), a = stack.pop();
      stack.push(fn(a, b));
    } else if (node.operand) {
      stack.push(evalOperand(node.operand, ctx));
    } else {
      throw new Error(`Unknown expression node: ${JSON.stringify(node)}`);
    }
  }
  return stack.pop();
}

/** assignments(여러 명명 인자)를 평가하여 { paramType: value } 맵으로 변환 */
export function resolveAssignments(assignments, ctx) {
  const out = {};
  for (const a of assignments || []) {
    const pt = a.variable?.parameter?.type;
    if (!pt) continue;
    out[pt] = evalPostfix(a.expression.postfix, ctx);
  }
  return out;
}

// ─────────────────────────────────────────────────────────────
// 내부
// ─────────────────────────────────────────────────────────────

function evalOperand(operand, ctx) {
  if (operand.constant !== undefined) {
    return operand.constant.value;
  }
  if (operand.variable) {
    const v = operand.variable;
    if (v.triggerVariable) {
      const name = v.triggerVariable.name;
      const val = ctx.vars?.[name];
      if (val === undefined) {
        console.warn(`[expression] $${name} 미정의 → 0 fallback`);
        return 0;
      }
      return val;
    }
    if (v.predefinedVariable) {
      const t = v.predefinedVariable.type;
      const map = ctx.predef || {};
      return map[t] ?? 0;
    }
  }
  if (operand.call) {
    return evalCall(operand.call, ctx);
  }
  throw new Error(`Unknown operand: ${JSON.stringify(operand)}`);
}

function evalCall(call, ctx) {
  const method = call.method || {};
  // method 노드 한 키만 있음 (boardMethod / unitMethod / skillMethod / buffMethod)
  const [receiverKey, methodSpec] = Object.entries(method)[0] || [];
  const methodName = methodSpec?.type;
  const receiver =
    receiverKey === 'boardMethod' ? ctx.board :
    receiverKey === 'unitMethod'  ? ctx.unit  :
    receiverKey === 'skillMethod' ? ctx.skill :
    receiverKey === 'buffMethod'  ? ctx.buff  : null;

  if (!receiver) {
    console.warn(`[expression] receiver 없음: ${receiverKey}`);
    return 0;
  }
  const fn = receiver[methodName];
  if (typeof fn !== 'function') {
    console.warn(`[expression] ${receiverKey}.${methodName} 미구현`);
    return 0;
  }
  // 위치 인자: assignments 의 Value 들을 모아 함수 인자로 넘김
  const args = (call.assignments || []).map(a => evalPostfix(a.expression.postfix, ctx));
  return fn.apply(receiver, args);
}
