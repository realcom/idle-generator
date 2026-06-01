// board.js — 보드 상태 (현재 맵, 유닛, boardState)
// action-vocabulary.md의 boardMethod 호출이 이 객체를 통해 이뤄진다.

export class Board {
  constructor(scene, loader) {
    this.scene = scene;
    this.loader = loader;
    this.currentMap = null;
    this.boardState = 0;
    this.units = [];
    this.gameEnded = false;
    this.endResult = null;
    this.eventListeners = [];
    this.queuedTriggers = [];

    // 플레이어 기준 위치 (Spine 좌표 — 좌하단 원점)
    this.playerX = 0; // spine-renderer에서 설정
  }

  // ─────── boardMethod 어휘 구현 ───────

  GetBoardState() { return this.boardState; }
  SetBoardState({ value }) { this.boardState = value; this._emit('boardStateChanged', value); }

  GetUnitCountByTeam(team) {
    return this.units.filter(u => u.team === team && u.alive).length;
  }

  GetUnitCountInCombat(team) {
    return this.units.filter(u => u.team === team && u.alive && u.state === 'combat').length;
  }

  AddUnit({ unitDataId, count = 1, rank = 'Normal', spawnDelay = 0,
            approach = false, moveSpeed = 80, attackRange = 150 }) {
    const unitDef = this.loader.getUnit(unitDataId);
    if (!unitDef) {
      console.warn(`[Board] Unknown unit ${unitDataId}`);
      return;
    }
    for (let n = 0; n < count; n++) {
      const delay = (typeof spawnDelay === 'number' ? spawnDelay : 0) * n * 1000;
      setTimeout(() => this._spawnUnit(unitDef, rank, { approach, moveSpeed, attackRange }), delay);
    }
  }

  _spawnUnit(unitDef, rank, movement) {
    const unit = {
      id: unitDef.id,
      name: unitDef.name,
      type: unitDef.type,
      rank,
      team: 1,
      hp: this._getStatValue(unitDef, 'Hp', 100),
      maxHp: this._getStatValue(unitDef, 'Hp', 100),
      attack: this._getStatValue(unitDef, 'Attack', 10),
      defense: this._getStatValue(unitDef, 'Defense', 0),
      alive: true,
      sprite: null,
      // 이동 관련 (behavior YAML에서 설정)
      approach: movement.approach,
      moveSpeed: movement.moveSpeed,        // px/sec
      attackRange: movement.attackRange,     // px (플레이어로부터 거리)
      state: movement.approach ? 'approaching' : 'combat',  // approaching → combat
    };
    this.units.push(unit);
    if (this.scene?.onUnitSpawned) this.scene.onUnitSpawned(unit);
    this._emit('unitSpawned', unit);
  }

  _getStatValue(unitDef, statType, defaultV) {
    const raw = this.loader.getRawStat(unitDef.id, statType);
    if (raw != null) return raw;
    const stats = unitDef.addStats || [];
    const found = stats.find(s => (s.type || 'Hp') === statType);
    return found?.value?.[0] ?? defaultV;
  }

  SendWaveStartedEvent() { this._emit('waveStarted'); }

  SendWaveQueuedEvent({ name }) {
    this.queuedTriggers.push(name);
    this._emit('waveQueued', name);
  }

  EndGame({ result }) {
    this.gameEnded = true;
    this.endResult = result;
    this._emit('gameEnded', result);
  }

  // ─────── 유틸 ───────

  removeUnit(unit) {
    unit.alive = false;
    this._emit('unitDied', unit);
  }

  // 유닛이 combat 상태로 전환될 때 호출
  unitEnteredCombat(unit) {
    if (unit.state === 'approaching') {
      unit.state = 'combat';
      this._emit('unitEnteredCombat', unit);
    }
  }

  on(event, fn) { this.eventListeners.push({ event, fn }); }
  _emit(event, payload) {
    this.eventListeners.filter(l => l.event === event).forEach(l => l.fn(payload));
  }

  flushQueuedTriggers() {
    const triggers = this.queuedTriggers.slice();
    this.queuedTriggers.length = 0;
    return triggers;
  }
}
