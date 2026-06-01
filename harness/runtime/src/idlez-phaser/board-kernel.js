import { EventBus } from './event-bus.js';
import {
  TEAM,
  TICK_MS,
  TICKS_PER_SECOND,
  asNumber,
  clamp,
  normalizeTeam,
  ticksFromSeconds,
} from './constants.js';
import { TriggerVM } from './trigger-vm.js';

const GOLD_ITEM_ID = 5;
const EXP_ITEM_ID = 6;
const DEFAULT_SKILL_ID = 300101;
const AUTO_ADVANCE_DELAY_MS = 450;
const BOARD_KEY_WAVE = 601;
const WORLD_ORIGIN_X = 390;
const WORLD_ORIGIN_Y = 610;
const WORLD_SCALE_X = 100;
const WORLD_SCALE_Y = 42;

export class IdlezBoard extends EventBus {
  constructor(store) {
    super();
    this.store = store;
    this.triggerVM = new TriggerVM(this, store);
    this.inventory = new Map();
    this.itemLevels = new Map();
    this.boardVariables = new Map();
    this.warnings = new Set();
    this.reset();
  }

  reset() {
    this.map = null;
    this.tick = 0;
    this.accumulatorMs = 0;
    this.boardState = 0;
    this.nextUnitId = 1;
    this.nextSkillId = 1;
    this.units = new Map();
    this.activeSkills = new Map();
    this.gameEnded = false;
    this.winningTeam = null;
    if (this.autoAdvanceTimer) {
      clearTimeout(this.autoAdvanceTimer);
      this.autoAdvanceTimer = null;
    }
    this.boardVariables.clear();
    this.inventory.clear();
    this.itemLevels.clear();
    this.#seedInitialItems();
    this.triggerVM.reset();
  }

  start(mapId) {
    this.reset();
    this.map = mapId ? this.store.getMap(mapId) : this.store.getFirstMap();
    if (!this.map) throw new Error('No map found in ResourceStore');

    for (const initVariable of this.map.initVariables || []) {
      this.setBoardVariable(initVariable.callerKey, initVariable.value);
    }

    const playerDef = this.store.getPlayerUnit();
    if (playerDef) {
      this.spawnUnit(playerDef.id, {
        team: TEAM.PLAYER,
        x: 190,
        y: 610,
        targetX: 190,
        state: 'combat',
      });
    }

    this.triggerVM.bootstrapMap(this.map);
    this.emit('boardStarted', this.snapshot());
  }

  step(deltaMs) {
    if (!this.map) return;
    this.accumulatorMs += Math.min(deltaMs, 250);

    let loops = 0;
    while (this.accumulatorMs >= TICK_MS && loops < 20) {
      this.accumulatorMs -= TICK_MS;
      this.#updateTick();
      loops += 1;
    }
  }

  snapshot() {
    return {
      map: this.map,
      tick: this.tick,
      boardState: this.boardState,
      gameEnded: this.gameEnded,
      winningTeam: this.winningTeam,
      units: [...this.units.values()],
      activeSkills: [...this.activeSkills.values()],
      inventory: new Map(this.inventory),
      itemLevels: new Map(this.itemLevels),
      boardVariables: new Map(this.boardVariables),
    };
  }

  warn(message) {
    if (this.warnings.has(message)) return;
    this.warnings.add(message);
    console.warn(`[IdlezBoard] ${message}`);
    this.emit('warning', message);
  }

  GetBoardState() {
    return this.boardState;
  }

  SetBoardState({ boardState, value } = {}) {
    const next = asNumber(boardState ?? value, this.boardState);
    if (next === this.boardState) return this.boardState;
    const previous = this.boardState;
    this.boardState = next;
    this.emit('boardStateChanged', { previous, current: next });
    return next;
  }

  getBoardVariable(boardKey) {
    const key = Number(boardKey);
    if (key === BOARD_KEY_WAVE) return this.boardState;
    return this.boardVariables.get(key) || 0;
  }

  setBoardVariable(boardKey, value) {
    const key = Number(boardKey);
    const next = asNumber(value, 0);
    const previous = this.getBoardVariable(key);
    this.boardVariables.set(key, next);
    if (key === BOARD_KEY_WAVE) this.SetBoardState({ value: next });
    if (previous !== next) this.emit('boardVariableChanged', { boardKey: key, previous, current: next });
    return next;
  }

  GetUnitCountByTeam({ team } = {}) {
    const normalized = normalizeTeam(team);
    return [...this.units.values()].filter(unit => unit.alive && unit.team === normalized).length;
  }

  AddUnit({ unitDataId, count = 1, team = TEAM.ENEMY, level = null } = {}) {
    const n = Math.max(1, Math.floor(asNumber(count, 1)));
    const unitLevel = level == null ? Math.max(1, this.boardState || 1) : Math.max(1, Math.floor(asNumber(level, 1)));
    for (let i = 0; i < n; i += 1) {
      this.spawnUnit(unitDataId, { team: normalizeTeam(team), level: unitLevel, spawnIndex: i });
    }
    return n;
  }

  SendWaveStartedEvent() {
    this.emit('waveStarted', { boardState: this.boardState });
    return this.boardState;
  }

  SendWaveQueuedEvent({ name } = {}) {
    this.emit('waveQueued', { name, boardState: this.boardState });
    return this.boardState;
  }

  EndGame({ team, result } = {}) {
    this.gameEnded = true;
    this.winningTeam = asNumber(team ?? result, TEAM.PLAYER);
    const nextMap = this.#resolveAutoAdvanceMap(this.winningTeam === TEAM.PLAYER);
    this.emit('gameEnded', { winningTeam: this.winningTeam, nextMap });
    if (nextMap) this.#scheduleAutoAdvance(nextMap.id, this.map?.id);
    return this.winningTeam;
  }

  #resolveAutoAdvanceMap(playerWon) {
    const map = this.map;
    if (!this.#shouldAutoAdvance(map)) return null;

    if (!playerWon) {
      return this.#mapFromPopupArg(map?.popupArgs?.ClientRetryMapDataId) || map;
    }

    return this.#mapFromPopupArg(map?.popupArgs?.ClientNextMapDataId)
      || this.#mapFromPopupArg(map?.popupArgs?.ClientLoopMapDataId)
      || (map?.tags?.includes('InfiniteWaves') ? map : null);
  }

  #shouldAutoAdvance(map) {
    if (!map) return false;
    const raw = map.popupArgs?.ClientAutoAdvance;
    if (raw != null) return ['true', '1', 'yes', 'on'].includes(String(raw).toLowerCase());
    return map.tags?.includes('InfiniteWaves');
  }

  #mapFromPopupArg(rawValue) {
    if (rawValue == null || rawValue === '') return null;
    const value = String(rawValue).trim();
    if (value.toLowerCase() === 'self') return this.map;
    return this.store.getMap(value) || null;
  }

  #scheduleAutoAdvance(mapId, sourceMapId) {
    this.autoAdvanceTimer = setTimeout(() => {
      this.autoAdvanceTimer = null;
      if (!this.gameEnded || this.map?.id !== sourceMapId) return;
      this.start(mapId);
    }, AUTO_ADVANCE_DELAY_MS);
  }

  spawnUnit(unitDataId, options = {}) {
    const def = this.store.getUnit(unitDataId);
    if (!def) {
      this.warn(`Unknown unitDataId: ${unitDataId}`);
      return null;
    }

    const unit = new BoardUnit(this, def, options);
    this.units.set(unit.id, unit);
    this.emit('unitSpawned', unit);
    this.triggerVM.bootstrapUnit(unit);
    return unit;
  }

  startSkillToTarget(owner, skillDataId, target = null) {
    if (!owner?.alive) return 0;
    const skill = this.store.getSkill(skillDataId);
    if (!skill) {
      this.warn(`Unknown skillDataId: ${skillDataId}`);
      return 0;
    }

    const resolvedTarget = target || owner.targetUnit;
    if (!resolvedTarget?.alive) return 0;
    this.#startSkill(owner, skill, [resolvedTarget]);
    return skill.id;
  }

  addItem(itemDataId, count, reason = 'drop') {
    const id = Number(itemDataId);
    const amount = Math.max(0, Math.floor(asNumber(count, 0)));
    if (!id || amount <= 0) return 0;

    this.inventory.set(id, (this.inventory.get(id) || 0) + amount);
    const item = this.store.getItem(id);
    this.emit('itemGained', { itemDataId: id, item, count: amount, reason });
    return amount;
  }

  spendItem(itemDataId, count, reason = 'spend') {
    const id = Number(itemDataId);
    const amount = Math.max(0, Math.floor(asNumber(count, 0)));
    if (!id || amount <= 0) return 0;
    const current = this.inventory.get(id) || 0;
    const spent = Math.min(current, amount);
    if (spent <= 0) return 0;
    this.inventory.set(id, current - spent);
    const item = this.store.getItem(id);
    this.emit('itemSpent', { itemDataId: id, item, count: spent, reason });
    return spent;
  }

  getItemLevel(itemDataId) {
    const id = Number(itemDataId);
    const item = this.store.getItem(id);
    return Math.max(1, this.itemLevels.get(id) || Number(item?.initialCreateLevel || 1));
  }

  getItemMaxLevel(itemDataId) {
    return this.store.itemMaxLevel(this.store.getItem(itemDataId));
  }

  getItemLevelUpCost(itemDataId) {
    const item = this.store.getItem(itemDataId);
    return this.store.itemLevelUpCost(item, this.getItemLevel(itemDataId), GOLD_ITEM_ID);
  }

  getItemStat(statType) {
    let total = 0;
    for (const [itemDataId, level] of this.itemLevels.entries()) {
      const item = this.store.getItem(itemDataId);
      if (!item) continue;
      total += this.store.itemStatValue(item, statType, level, 0);
    }
    return total;
  }

  levelUpItem(itemDataId) {
    const id = Number(itemDataId);
    const item = this.store.getItem(id);
    if (!item) return { ok: false, reason: 'missing_item', message: `Unknown item ${id}` };

    const level = this.getItemLevel(id);
    const maxLevel = this.getItemMaxLevel(id);
    if (level >= maxLevel) {
      return { ok: false, reason: 'max_level', item, level, maxLevel, message: `${item.name} MAX` };
    }

    const cost = this.getItemLevelUpCost(id);
    if (!Number.isFinite(cost)) {
      return { ok: false, reason: 'missing_cost', item, level, maxLevel, message: `${item.name} cost missing` };
    }
    if (this.gold < cost) {
      return { ok: false, reason: 'not_enough_gold', item, level, cost, message: `골드 부족: ${cost}` };
    }

    this.spendItem(GOLD_ITEM_ID, cost, `levelup:${id}`);
    const nextLevel = level + 1;
    this.itemLevels.set(id, nextLevel);
    this.#refreshPlayerStats();
    this.emit('itemLevelUp', { itemDataId: id, item, previousLevel: level, level: nextLevel, cost });
    return { ok: true, item, previousLevel: level, level: nextLevel, cost, maxLevel };
  }

  get gold() {
    return this.inventory.get(GOLD_ITEM_ID) || 0;
  }

  get exp() {
    return this.inventory.get(EXP_ITEM_ID) || 0;
  }

  #seedInitialItems() {
    for (const item of this.store.items?.values?.() || []) {
      const id = Number(item.id);
      if (!id || !item.initialCreate) continue;

      const count = Math.max(0, Math.floor(asNumber(item.initialCreateCount, 0)));
      if (count > 0) this.inventory.set(id, count);

      if (item.initialCreateLevel != null) {
        this.itemLevels.set(id, Math.max(1, Math.floor(asNumber(item.initialCreateLevel, 1))));
      }
    }
  }

  #refreshPlayerStats() {
    const player = this.playerUnit;
    if (player) player.refreshStatsFromBoard();
  }

  #updateTick() {
    if (this.gameEnded) return;

    this.tick += 1;
    this.#updateRevives();
    this.triggerVM.tick();
    this.#updateMovement();
    this.#updateCombat();
    this.#updateActiveSkills();
    this.emit('tick', this.snapshot());
  }

  #updateMovement() {
    for (const unit of this.units.values()) {
      if (!unit.alive || !['approaching', 'moving'].includes(unit.state)) continue;

      const dx = unit.targetX - unit.x;
      const move = Math.sign(dx) * unit.moveSpeedPx / TICKS_PER_SECOND;
      unit.x += Math.abs(move) < Math.abs(dx) ? move : dx;
      unit.y += (unit.targetY - unit.y) * 0.02;

      if (Math.abs(unit.x - unit.targetX) < 3) {
        unit.x = unit.targetX;
        unit.state = 'combat';
        this.emit('unitEnteredCombat', unit);
      }
    }
  }

  #updateCombat() {
    const player = this.activePlayerUnit;
    if (!player?.alive) return;

    const enemies = this.enemyUnits.filter(unit => unit.state === 'combat');
    if (enemies.length === 0) return;

    player.skillTimer -= 1;
    if (player.skillTimer <= 0) {
      const skill = this.store.getSkill(DEFAULT_SKILL_ID);
      if (skill) this.#startSkill(player, skill, [enemies[0]]);
      player.skillTimer = ticksFromSeconds(skill?.cooldown || 1.5);
    }

    for (const enemy of enemies) {
      enemy.attackTimer -= 1;
      if (enemy.attackTimer > 0) continue;

      const damage = Math.max(1, Math.round(enemy.attack - player.defense));
      this.emit('unitAttack', { unit: enemy, target: player });
      player.takeDamage(damage, enemy);
      enemy.attackTimer = enemy.attackIntervalTicks;
    }
  }

  #startSkill(owner, skillDef, targets) {
    const skill = {
      id: this.nextSkillId++,
      dataId: skillDef.id,
      def: skillDef,
      owner,
      targets: targets.filter(Boolean),
      startTick: this.tick,
      executed: new Set(),
      destroyed: false,
    };
    this.activeSkills.set(skill.id, skill);
    this.emit('unitAttack', { unit: owner, target: skill.targets[0], skill });
    this.emit('skillSpawned', skill);
    return skill;
  }

  #updateActiveSkills() {
    for (const skill of [...this.activeSkills.values()]) {
      if (skill.destroyed || !skill.owner.alive) {
        this.#destroySkill(skill);
        continue;
      }

      const elapsed = (this.tick - skill.startTick) / TICKS_PER_SECOND;
      const timelines = skill.def.timelines || [];
      for (let i = 0; i < timelines.length; i += 1) {
        if (skill.executed.has(i)) continue;
        const timeline = timelines[i];
        if (elapsed < asNumber(timeline.time, 0)) continue;
        skill.executed.add(i);
        this.#executeSkillTimeline(skill, timeline);
      }
    }
  }

  #executeSkillTimeline(skill, timeline) {
    if (timeline.playFx) {
      this.emit('skillFx', { skill, prefab: timeline.playFx.prefab });
    }

    if (timeline.hit) {
      const maxHit = Math.max(1, Math.floor(asNumber(timeline.hit.maxHit, 1)));
      const targets = skill.targets.filter(unit => unit.alive).slice(0, maxHit);
      const ratios = timeline.hit.addDamage?.attackPercentDamages || [1];
      const ratio = ratios.reduce((sum, value) => sum + asNumber(value, 0), 0);

      for (const target of targets) {
        const raw = skill.owner.attack * ratio;
        const damage = Math.max(1, Math.round(raw - target.defense));
        target.takeDamage(damage, skill.owner, skill);
      }
    }

    if (timeline.destroy) {
      this.#destroySkill(skill);
    }
  }

  #destroySkill(skill) {
    if (!this.activeSkills.has(skill.id)) return;
    this.activeSkills.delete(skill.id);
    this.emit('skillDestroyed', skill);
  }

  handleUnitDeath(unit, source, skill) {
    this.emit('unitDied', { unit, source, skill });
    if (unit.team === TEAM.PLAYER) {
      unit.reviveAtTick = this.tick + ticksFromSeconds(5);
      this.emit('playerDefeated', { unit, reviveAtTick: unit.reviveAtTick });
      return;
    }
    this.#grantDrops(unit);
  }

  #updateRevives() {
    for (const unit of this.units.values()) {
      if (unit.team !== TEAM.PLAYER || unit.alive || !unit.reviveAtTick) continue;
      if (this.tick < unit.reviveAtTick) continue;

      unit.alive = true;
      unit.hp = unit.maxHp;
      unit.reviveAtTick = null;
      this.emit('unitRevived', unit);
    }
  }

  #grantDrops(unit) {
    for (const group of unit.def.dropAddItemGroups || []) {
      if (Math.random() * 100 > asNumber(group.probPercent, 100)) continue;
      const addItems = group.addItems || [];
      const chosen = group.shouldAddAll ? addItems : [weightedPick(addItems)];
      for (const addItem of chosen.filter(Boolean)) {
        const count = rollCount(addItem);
        this.addItem(addItem.itemDataId, count, `drop:${unit.dataId}`);
      }
    }
  }

  get playerUnit() {
    return [...this.units.values()].find(unit => unit.team === TEAM.PLAYER);
  }

  get activePlayerUnit() {
    const unit = this.playerUnit;
    return unit?.alive ? unit : null;
  }

  get enemyUnits() {
    return [...this.units.values()].filter(unit => unit.alive && unit.team === TEAM.ENEMY);
  }
}

export class BoardUnit {
  constructor(board, def, options = {}) {
    this.board = board;
    this.def = def;
    this.id = board.nextUnitId++;
    this.dataId = def.id;
    this.name = def.name;
    this.type = def.type || 'Normal';
    this.team = normalizeTeam(options.team, TEAM.ENEMY);
    this.level = Math.max(1, asNumber(options.level, Math.max(1, board.boardState || 1)));

    this.baseMaxHp = Math.round(board.store.statValue(def, 'Hp', this.level, 100));
    this.baseAttack = Math.round(board.store.statValue(def, 'Attack', this.level, 10));
    this.baseDefense = Math.round(board.store.statValue(def, 'Defense', this.level, 0));
    this.baseCriticalPercent = board.store.statValue(def, 'CriticalPercent', this.level, 0);
    this.baseAttackSpeed = Math.max(0.2, board.store.statValue(def, 'AttackSpeed', this.level, 0.8));
    this.moveSpeed = Math.max(0.1, board.store.statValue(def, 'MoveSpeed', this.level, 2));
    this.maxHp = 1;
    this.hp = 1;
    this.attack = 1;
    this.defense = 0;
    this.criticalPercent = 0;
    this.criticalDamagePercent = 0;
    this.attackSpeed = this.baseAttackSpeed;
    this.refreshStatsFromBoard({ healToFull: true });
    this.moveSpeedPx = this.moveSpeed * 28;

    this.alive = true;
    this.state = options.state || (this.team === TEAM.ENEMY ? 'approaching' : 'combat');
    const slot = board.enemyUnits.length + asNumber(options.spawnIndex, 0);
    this.x = asNumber(options.x, this.team === TEAM.PLAYER ? 150 : 760 + slot * 24);
    this.y = asNumber(options.y, this.team === TEAM.PLAYER ? 610 : 560 + (slot % 5) * 42);
    this.targetX = asNumber(options.targetX, this.team === TEAM.PLAYER ? this.x : 630 - (slot % 4) * 42);
    this.targetY = asNumber(options.targetY, this.y);
    this.attackIntervalTicks = ticksFromSeconds(1 / this.attackSpeed, 10);
    this.attackTimer = this.attackIntervalTicks + Math.floor(Math.random() * 20);
    this.skillTimer = ticksFromSeconds(1.0, 1);
  }

  refreshStatsFromBoard({ healToFull = false } = {}) {
    const previousMaxHp = this.maxHp || 0;
    const hpBonus = this.team === TEAM.PLAYER ? this.board.getItemStat('Hp') : 0;
    const attackBonus = this.team === TEAM.PLAYER ? this.board.getItemStat('Attack') : 0;
    const attackSpeedPercent = this.team === TEAM.PLAYER ? this.board.getItemStat('AttackSpeedPercent') : 0;
    const criticalDamagePercent = this.team === TEAM.PLAYER ? this.board.getItemStat('CriticalDamagePercent') : 0;

    this.maxHp = Math.max(1, Math.round(this.baseMaxHp + hpBonus));
    this.attack = Math.max(1, Math.round(this.baseAttack + attackBonus));
    this.defense = Math.max(0, Math.round(this.baseDefense));
    this.criticalPercent = this.baseCriticalPercent;
    this.criticalDamagePercent = criticalDamagePercent;
    this.attackSpeed = Math.max(0.2, this.baseAttackSpeed * (1 + attackSpeedPercent / 100));
    this.attackIntervalTicks = ticksFromSeconds(1 / this.attackSpeed, 10);

    if (healToFull || previousMaxHp <= 0) {
      this.hp = this.maxHp;
    } else {
      const gainedMaxHp = Math.max(0, this.maxHp - previousMaxHp);
      this.hp = clamp(this.hp + gainedMaxHp, this.alive ? 1 : 0, this.maxHp);
    }
  }

  SetMoveRandomDestination({
    positionX,
    positionY,
    positionXrange,
    positionYrange,
  } = {}) {
    const baseX = asNumber(positionX, screenToWorldX(this.targetX));
    const baseY = asNumber(positionY, screenToWorldY(this.targetY));
    const rangeX = Math.max(0, asNumber(positionXrange, 0));
    const rangeY = Math.max(0, asNumber(positionYrange, 0));
    const nextX = baseX + (Math.random() * 2 - 1) * rangeX;
    const nextY = baseY + (Math.random() * 2 - 1) * rangeY;

    this.targetX = worldToScreenX(nextX);
    this.targetY = worldToScreenY(nextY);
    this.state = this.team === TEAM.ENEMY ? 'approaching' : 'moving';
    this.board.emit('unitCommand', { unit: this, command: 'SetMoveRandomDestination' });
    return 0;
  }

  SetMoveDestination({ positionX, positionY } = {}) {
    this.targetX = worldToScreenX(asNumber(positionX, screenToWorldX(this.x)));
    this.targetY = worldToScreenY(asNumber(positionY, screenToWorldY(this.y)));
    this.state = this.team === TEAM.ENEMY ? 'approaching' : 'moving';
    this.board.emit('unitCommand', { unit: this, command: 'SetMoveDestination' });
    return 0;
  }

  Stop() {
    this.targetX = this.x;
    this.targetY = this.y;
    this.state = 'combat';
    this.board.emit('unitCommand', { unit: this, command: 'Stop' });
    return 0;
  }

  UseSkillToTarget({ skillDataId } = {}) {
    return this.board.startSkillToTarget(this, asNumber(skillDataId, DEFAULT_SKILL_ID));
  }

  getVariable(type) {
    if (type === 'HasTarget') return this.targetUnit ? 1 : 0;
    if (type === 'TargetDistance') return this.targetDistance;
    this.board.warn(`Unknown unit variable: ${type}`);
    return 0;
  }

  get targetUnit() {
    const opponents = [...this.board.units.values()]
      .filter(unit => unit.alive && unit.team !== this.team)
      .sort((a, b) => distanceSq(this, a) - distanceSq(this, b));
    return opponents[0] || null;
  }

  get targetDistance() {
    const target = this.targetUnit;
    if (!target) return Infinity;
    return Math.hypot(target.x - this.x, target.y - this.y) / WORLD_SCALE_X;
  }

  IncreaseGold({ count } = {}) {
    return this.board.addItem(GOLD_ITEM_ID, count, 'trigger');
  }

  takeDamage(amount, source, skill) {
    if (!this.alive) return 0;
    const damage = Math.max(1, Math.round(asNumber(amount, 1)));
    this.hp = Math.max(0, this.hp - damage);
    this.board.emit('unitDamaged', { unit: this, source, skill, damage });
    if (this.hp <= 0) {
      this.alive = false;
      this.board.handleUnitDeath(this, source, skill);
    }
    return damage;
  }
}

function rollCount(addItem) {
  if (addItem.count != null) return asNumber(addItem.count, 0);
  const min = asNumber(addItem.minCount, 0);
  const max = asNumber(addItem.maxCount, min);
  return min + Math.floor(Math.random() * (Math.max(min, max) - min + 1));
}

function weightedPick(items) {
  const total = items.reduce((sum, item) => sum + asNumber(item.weight, 1), 0);
  let roll = Math.random() * total;
  for (const item of items) {
    roll -= asNumber(item.weight, 1);
    if (roll <= 0) return item;
  }
  return items[items.length - 1];
}

function worldToScreenX(value) {
  return WORLD_ORIGIN_X + asNumber(value, 0) * WORLD_SCALE_X;
}

function worldToScreenY(value) {
  return clamp(WORLD_ORIGIN_Y - asNumber(value, 0) * WORLD_SCALE_Y, 500, 720);
}

function screenToWorldX(value) {
  return (asNumber(value, WORLD_ORIGIN_X) - WORLD_ORIGIN_X) / WORLD_SCALE_X;
}

function screenToWorldY(value) {
  return (WORLD_ORIGIN_Y - asNumber(value, WORLD_ORIGIN_Y)) / WORLD_SCALE_Y;
}

function distanceSq(a, b) {
  return (a.x - b.x) ** 2 + (a.y - b.y) ** 2;
}
