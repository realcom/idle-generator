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
const PLAYER_LEVEL_ITEM_ID = 1;
const LEVEL_POINT_ITEM_ID = 200107;
const DEFAULT_SKILL_ID = 300101;
const SKILL_TREE_ID = 'Mushroomer';
const SKILL_LEVEL_DAMAGE_BONUS = 0.16;
const SKILL_SLOT_UNLOCKS = [
  { slots: 1, level: 1, achievementId: 0 },
  { slots: 2, level: 5, achievementId: 600113 },
  { slots: 3, level: 12, achievementId: 600115 },
  { slots: 4, level: 40, achievementId: 600117 },
];
const AUTO_ADVANCE_DELAY_MS = 450;
const BOARD_KEY_WAVE = 601;
const WORLD_ORIGIN_X = 390;
const WORLD_ORIGIN_Y = 610;
const WORLD_SCALE_X = 100;
const WORLD_SCALE_Y = 42;
const SURVIVOR_WORLD_ORIGIN_X = 1500;
const SURVIVOR_WORLD_ORIGIN_Y = 1000;
const SURVIVOR_WORLD_SCALE_X = 120;
const SURVIVOR_WORLD_SCALE_Y = 120;
const SURVIVOR_WORLD_WIDTH = 3000;
const SURVIVOR_WORLD_HEIGHT = 2000;

export class IdlezBoard extends EventBus {
  constructor(store) {
    super();
    this.store = store;
    this.triggerVM = new TriggerVM(this, store);
    this.inventory = new Map();
    this.itemLevels = new Map();
    this.boardVariables = new Map();
    this.warnings = new Set();
    this.completedAchievements = new Set();
    this.productBuyCounts = new Map();
    this.productBuyActions = new Map();
    this.itemAcquireCounts = new Map();
    this.unitKillCounts = new Map();
    this.mapWinCounts = new Map();
    this.mapWaveWinCounts = new Map();
    this.skillUseCounts = new Map();
    this.skillSlots = [];
    this.skillCooldownTimers = new Map();
    this.autoSkillsEnabled = true;
    this.lastGrantedPlayerLevel = 1;
    this.lastSkillSlotCount = 1;
    this.refreshingAchievements = false;
    this.progressInitialized = false;
    this.reset();
  }

  reset({ preserveProgress = false } = {}) {
    const savedInventory = preserveProgress ? new Map(this.inventory) : null;
    const savedItemLevels = preserveProgress ? new Map(this.itemLevels) : null;
    const savedAchievements = preserveProgress ? new Set(this.completedAchievements) : null;
    const savedProductBuyCounts = preserveProgress ? new Map(this.productBuyCounts) : null;
    const savedProductBuyActions = preserveProgress ? new Map(this.productBuyActions) : null;
    const savedItemAcquireCounts = preserveProgress ? new Map(this.itemAcquireCounts) : null;
    const savedUnitKillCounts = preserveProgress ? new Map(this.unitKillCounts) : null;
    const savedMapWinCounts = preserveProgress ? new Map(this.mapWinCounts) : null;
    const savedMapWaveWinCounts = preserveProgress ? new Map(this.mapWaveWinCounts) : null;
    const savedSkillUseCounts = preserveProgress ? new Map(this.skillUseCounts) : null;
    const savedSkillSlots = preserveProgress ? [...this.skillSlots] : null;
    const savedLastGrantedPlayerLevel = preserveProgress ? this.lastGrantedPlayerLevel : 1;
    const savedLastSkillSlotCount = preserveProgress ? this.lastSkillSlotCount : 1;

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
    this.completedAchievements = savedAchievements || new Set();
    this.productBuyCounts = savedProductBuyCounts || new Map();
    this.productBuyActions = savedProductBuyActions || new Map();
    this.itemAcquireCounts = savedItemAcquireCounts || new Map();
    this.unitKillCounts = savedUnitKillCounts || new Map();
    this.mapWinCounts = savedMapWinCounts || new Map();
    this.mapWaveWinCounts = savedMapWaveWinCounts || new Map();
    this.skillUseCounts = savedSkillUseCounts || new Map();
    this.skillSlots = savedSkillSlots || new Array(this.maxSkillSlots).fill(null);
    this.skillCooldownTimers.clear();
    this.lastGrantedPlayerLevel = savedLastGrantedPlayerLevel;
    this.lastSkillSlotCount = savedLastSkillSlotCount;
    if (this.autoAdvanceTimer) {
      clearTimeout(this.autoAdvanceTimer);
      this.autoAdvanceTimer = null;
    }
    this.boardVariables.clear();
    this.inventory = savedInventory || new Map();
    this.itemLevels = savedItemLevels || new Map();
    this.#seedInitialItems({ preserveExisting: preserveProgress });
    this.#syncPlayerLevelProgress({ silent: true });
    this.#refreshAchievements({ silent: true });
    this.#refreshSkillSlots({ silent: true });
    this.triggerVM.reset();
    if (!preserveProgress) this.progressInitialized = false;
  }

  start(mapId, options = {}) {
    const preserveProgress = options.preserveProgress ?? this.progressInitialized;
    this.reset({ preserveProgress });
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
        level: this.playerLevel,
        state: 'combat',
      });
    }

    this.triggerVM.bootstrapMap(this.map);
    this.progressInitialized = true;
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
      completedAchievements: new Set(this.completedAchievements),
      productBuyCounts: new Map(this.productBuyCounts),
      productBuyActions: new Map(this.productBuyActions),
      itemAcquireCounts: new Map(this.itemAcquireCounts),
      unitKillCounts: new Map(this.unitKillCounts),
      mapWinCounts: new Map(this.mapWinCounts),
      mapWaveWinCounts: new Map(this.mapWaveWinCounts),
      skillUseCounts: new Map(this.skillUseCounts),
      skillSlots: [...this.skillSlots],
      skillCooldownTimers: new Map(this.skillCooldownTimers),
      skillSlotCount: this.skillSlotCount,
      autoSkillsEnabled: this.autoSkillsEnabled,
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

  RandomBetween({ min = 0, max = 1 } = {}) {
    const low = asNumber(min, 0);
    const high = asNumber(max, 1);
    const from = Math.min(low, high);
    const to = Math.max(low, high);
    return from + Math.random() * (to - from);
  }

  RandomIntBetween({ min = 0, max = 1 } = {}) {
    const low = Math.ceil(asNumber(min, 0));
    const high = Math.floor(asNumber(max, 1));
    const from = Math.min(low, high);
    const to = Math.max(low, high);
    return Math.floor(from + Math.random() * (to - from + 1));
  }

  GetUnitCountByTeam({ team } = {}) {
    const normalized = normalizeTeam(team);
    return [...this.units.values()].filter(unit => unit.alive && unit.team === normalized).length;
  }

  GetUnitCount({ unitDataId } = {}) {
    const dataId = Number(unitDataId);
    if (!Number.isFinite(dataId)) return 0;
    return [...this.units.values()].filter(unit => unit.alive && Number(unit.dataId) === dataId).length;
  }

  AddUnit({
    unitDataId,
    count = 1,
    team = TEAM.ENEMY,
    level = null,
    locationId = null,
    positionX = null,
    positionY = null,
    angle = null,
    offset = null,
  } = {}) {
    const n = Math.max(1, Math.floor(asNumber(count, 1)));
    const unitLevel = level == null ? Math.max(1, this.boardState || 1) : Math.max(1, Math.floor(asNumber(level, 1)));
    for (let i = 0; i < n; i += 1) {
      this.spawnUnit(unitDataId, {
        team: normalizeTeam(team),
        level: unitLevel,
        spawnIndex: i,
        locationId,
        positionX,
        positionY,
        angle,
        offset,
      });
    }
    return n;
  }

  SendWaveStartedEvent() {
    this.emit('waveStarted', { boardState: this.boardState });
    return this.boardState;
  }

  SendWaveQueuedEvent({ name } = {}) {
    const mapDataId = this.map?.id;
    this.#recordMapWaveWin(mapDataId);
    this.#refreshAchievements();
    this.emit('waveQueued', { name, boardState: this.boardState });
    this.emit('waveWon', { mapDataId, name, boardState: this.boardState });
    return this.boardState;
  }

  EndGame({ team, result } = {}) {
    if (this.gameEnded) return this.winningTeam ?? TEAM.PLAYER;

    this.gameEnded = true;
    this.winningTeam = asNumber(team ?? result, TEAM.PLAYER);
    if (this.winningTeam === TEAM.PLAYER) {
      this.#recordMapWin(this.map?.id);
      this.#recordMapWaveWin(this.map?.id);
      this.#refreshAchievements();
    }
    const clearRewards = this.winningTeam === TEAM.PLAYER
      ? this.#grantMapRewards(this.map)
      : [];
    const nextMap = this.#resolveAutoAdvanceMap(this.winningTeam === TEAM.PLAYER);
    this.emit('gameEnded', {
      winningTeam: this.winningTeam,
      nextMap,
      map: this.map,
      rewards: clearRewards,
    });
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
      this.start(mapId, { preserveProgress: true });
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

  startSkill(owner, skillDataId, targets = null, metadata = {}) {
    if (!owner?.alive) return 0;
    const skill = this.store.getSkill(skillDataId);
    if (!skill) {
      this.warn(`Unknown skillDataId: ${skillDataId}`);
      return 0;
    }

    const resolvedTargets = Array.isArray(targets) && targets.length
      ? targets.filter(unit => unit?.alive)
      : (skillHasSelfBuff(skill) && !skillHasHit(skill) ? [owner] : this.#targetsForSkill(skill, this.enemyUnits, owner));
    if (!resolvedTargets.length && !skillHasSelfBuff(skill)) return 0;

    this.#startSkill(owner, skill, resolvedTargets, metadata);
    return skill.id;
  }

  UseSkill({ skillDataId, team = TEAM.PLAYER } = {}) {
    const normalizedTeam = normalizeTeam(team, TEAM.PLAYER);
    const owner = [...this.units.values()].find(unit => unit.alive && unit.team === normalizedTeam);
    return this.startSkill(owner, asNumber(skillDataId, DEFAULT_SKILL_ID));
  }

  get playerLevel() {
    const player = this.playerUnit;
    return Math.max(
      1,
      Math.floor(asNumber(this.itemLevels.get(PLAYER_LEVEL_ITEM_ID), 1)),
      Math.floor(asNumber(player?.level, 1)),
      Math.floor(asNumber(this.boardState, 1)),
    );
  }

  get maxSkillSlots() {
    return Math.max(...SKILL_SLOT_UNLOCKS.map(entry => entry.slots));
  }

  get skillSlotCount() {
    let count = 1;
    for (const unlock of SKILL_SLOT_UNLOCKS) {
      if (!unlock.achievementId || this.hasAchievement(unlock.achievementId)) count = Math.max(count, unlock.slots);
    }
    return clamp(count, 1, this.maxSkillSlots);
  }

  setAutoSkillsEnabled(enabled) {
    const next = Boolean(enabled);
    if (this.autoSkillsEnabled === next) return this.autoSkillsEnabled;
    this.autoSkillsEnabled = next;
    this.emit('autoSkillsChanged', { enabled: next });
    this.emit('tick', this.snapshot());
    return next;
  }

  hasAchievement(achievementDataId) {
    const id = Number(achievementDataId);
    if (!id) return true;
    if (this.completedAchievements.has(id)) return true;
    const achievement = this.store.getAchievement?.(id);
    return achievement ? this.#isAchievementSatisfied(achievement) : false;
  }

  countCompletedAchievements(achievementDataIds = []) {
    return achievementDataIds.reduce((count, achievementDataId) => (
      this.hasAchievement(achievementDataId) ? count + 1 : count
    ), 0);
  }

  getProductBuyCount(productItemDataId) {
    return this.productBuyCounts.get(Number(productItemDataId)) || 0;
  }

  getItemAcquireCount(itemDataId) {
    const id = Number(itemDataId);
    if (!id) return [...this.itemAcquireCounts.values()].reduce((sum, count) => sum + count, 0);
    return this.itemAcquireCounts.get(id) || 0;
  }

  getUnitKillCount(unitDataId) {
    const id = Number(unitDataId);
    if (!id) return [...this.unitKillCounts.values()].reduce((sum, count) => sum + count, 0);
    return this.unitKillCounts.get(id) || 0;
  }

  getMapWinCount(mapDataId) {
    const id = Number(mapDataId);
    if (!id) return [...this.mapWinCounts.values()].reduce((sum, count) => sum + count, 0);
    return this.mapWinCounts.get(id) || 0;
  }

  getMapWaveWinCount(mapDataId) {
    const id = Number(mapDataId);
    if (!id) return [...this.mapWaveWinCounts.values()].reduce((sum, count) => sum + count, 0);
    return this.mapWaveWinCounts.get(id) || 0;
  }

  getSkillUseCount(skillDataId) {
    const id = Number(skillDataId);
    if (!id) return [...this.skillUseCounts.values()].reduce((sum, count) => sum + count, 0);
    return this.skillUseCounts.get(id) || 0;
  }

  getAchievementProgress(achievement) {
    const target = this.#achievementProgressTarget(achievement);
    const completed = this.completedAchievements.has(Number(achievement?.id));
    const rawProgress = completed ? target : this.#achievementProgressValue(achievement);
    const progress = clamp(Math.floor(asNumber(rawProgress, 0)), 0, target);
    return {
      progress,
      target,
      completed: completed || progress >= target,
      ratio: target > 0 ? clamp(progress / target, 0, 1) : 0,
    };
  }

  getAchievementSummary({ predicate = null } = {}) {
    const achievements = [...(this.store.achievements?.values?.() || [])]
      .filter(achievement => (predicate ? predicate(achievement) : true));
    const total = achievements.length;
    const completed = achievements.filter(achievement => this.getAchievementProgress(achievement).completed).length;
    return { total, completed, remaining: Math.max(0, total - completed) };
  }

  recordProductBuy(productItemDataId, count = 1) {
    const id = Number(productItemDataId);
    const amount = Math.max(1, Math.floor(asNumber(count, 1)));
    if (!id) return { ok: false, reason: 'missing_product' };

    const previousCount = this.getProductBuyCount(id);
    const nextCount = previousCount + amount;
    this.productBuyCounts.set(id, nextCount);
    this.productBuyActions.set(id, (this.productBuyActions.get(id) || 0) + 1);
    this.#refreshAchievements();
    this.emit('productBought', { productItemDataId: id, count: amount, previousCount, totalCount: nextCount });
    this.emit('tick', this.snapshot());
    return { ok: true, productItemDataId: id, count: amount, previousCount, totalCount: nextCount };
  }

  getSkillTreeState(treeId = SKILL_TREE_ID) {
    this.#syncPlayerLevelProgress({ silent: true });
    this.#refreshAchievements({ silent: true });
    this.#refreshSkillSlots({ silent: true });

    const slots = this.getSkillSlotStates();
    const skillItems = this.#skillTreeItems(treeId).map(item => this.#skillItemState(item, slots));
    const selectedLevelPointItemId = skillItems.find(entry => entry.levelPointItemDataId)?.levelPointItemDataId || LEVEL_POINT_ITEM_ID;
    return {
      treeId,
      playerLevel: this.playerLevel,
      levelPointItemDataId: selectedLevelPointItemId,
      levelPoints: this.inventory.get(selectedLevelPointItemId) || 0,
      autoSkillsEnabled: this.autoSkillsEnabled,
      slotCount: this.skillSlotCount,
      maxSlots: this.maxSkillSlots,
      slotUnlocks: SKILL_SLOT_UNLOCKS.map(entry => ({
        ...entry,
        unlocked: entry.slots <= this.skillSlotCount,
        achieved: !entry.achievementId || this.hasAchievement(entry.achievementId),
      })),
      slots,
      skills: skillItems,
    };
  }

  getSkillSlotStates() {
    this.#refreshSkillSlots({ silent: true });
    return Array.from({ length: this.maxSkillSlots }, (_, index) => {
      const itemDataId = Number(this.skillSlots[index] || 0);
      const item = itemDataId ? this.store.getItem(itemDataId) : null;
      const skill = item?.skillDataId ? this.store.getSkill(item.skillDataId) : null;
      const cooldown = this.skillCooldownTimers.get(itemDataId) || 0;
      return {
        index,
        unlocked: index < this.skillSlotCount,
        unlock: SKILL_SLOT_UNLOCKS.find(entry => entry.slots === index + 1) || null,
        itemDataId,
        item,
        skill,
        level: item ? this.getItemLevel(item.id) : 0,
        cooldownTicks: cooldown,
        cooldownSeconds: cooldown / TICKS_PER_SECOND,
        ready: itemDataId > 0 && cooldown <= 0,
      };
    });
  }

  equipSkill(slotIndex, itemDataId) {
    const index = Math.floor(asNumber(slotIndex, -1));
    if (index < 0 || index >= this.maxSkillSlots) {
      return { ok: false, reason: 'bad_slot', message: '스킬 슬롯이 올바르지 않습니다' };
    }
    if (index >= this.skillSlotCount) {
      return { ok: false, reason: 'locked_slot', message: `Lv.${this.#slotUnlockLevel(index)} 슬롯 잠김` };
    }

    const item = this.store.getItem(itemDataId);
    if (!this.#isSkillTreeSkill(item)) {
      return { ok: false, reason: 'not_skill', message: '장착 가능한 스킬이 아닙니다' };
    }
    if (!this.#ownsItem(item.id)) {
      return { ok: false, reason: 'not_owned', message: `${item.name} 미습득` };
    }

    this.skillSlots = this.skillSlots.map(id => Number(id) === Number(item.id) ? null : id);
    this.skillSlots[index] = Number(item.id);
    this.emit('skillEquipped', { slotIndex: index, itemDataId: item.id, item });
    this.emit('skillSlotsChanged', { slots: this.getSkillSlotStates() });
    this.emit('tick', this.snapshot());
    return { ok: true, slotIndex: index, itemDataId: item.id, item };
  }

  unequipSkill(slotIndex) {
    const index = Math.floor(asNumber(slotIndex, -1));
    if (index < 0 || index >= this.maxSkillSlots) {
      return { ok: false, reason: 'bad_slot', message: '스킬 슬롯이 올바르지 않습니다' };
    }

    const itemDataId = Number(this.skillSlots[index] || 0);
    if (!itemDataId) return { ok: false, reason: 'empty_slot', message: '비어 있는 슬롯입니다' };

    const item = this.store.getItem(itemDataId);
    this.skillSlots[index] = null;
    this.emit('skillUnequipped', { slotIndex: index, itemDataId, item });
    this.emit('skillSlotsChanged', { slots: this.getSkillSlotStates() });
    this.emit('tick', this.snapshot());
    return { ok: true, slotIndex: index, itemDataId, item };
  }

  unlockSkillItem(itemDataId) {
    const item = this.store.getItem(itemDataId);
    const check = this.canUnlockSkillItem(item);
    if (!check.ok) return check;

    const cost = this.#skillUnlockCost(item);
    if (cost.count > 0) this.spendItem(cost.itemDataId, cost.count, `skill_unlock:${item.id}`);
    this.addItem(item.id, 1, `skill_unlock:${item.id}`);
    this.itemLevels.set(item.id, Math.max(1, asNumber(item.initialCreateLevel, 1)));
    this.#refreshSkillSlots();

    const emptySlot = this.getSkillSlotStates().find(slot => slot.unlocked && !slot.itemDataId);
    if (emptySlot) this.equipSkill(emptySlot.index, item.id);

    this.emit('skillUnlocked', { itemDataId: item.id, item, cost });
    this.emit('tick', this.snapshot());
    return { ok: true, itemDataId: item.id, item, cost, message: `${item.name} 해금` };
  }

  canUnlockSkillItem(itemOrId) {
    const item = typeof itemOrId === 'object' ? itemOrId : this.store.getItem(itemOrId);
    if (!this.#isSkillTreeSkill(item)) return { ok: false, reason: 'not_skill', message: '스킬 아이템이 아닙니다' };
    if (this.#ownsItem(item.id)) return { ok: false, reason: 'owned', item, message: `${item.name} 이미 습득` };

    const missingAchievement = (item.requiredAchievementDataIds || []).find(id => !this.hasAchievement(id));
    if (missingAchievement) {
      return { ok: false, reason: 'achievement', item, achievementDataId: missingAchievement, message: `업적 ${missingAchievement} 필요` };
    }

    const requiredLevel = this.#popupInt(item, 'RequiredPlayerLevel', 1);
    if (this.playerLevel < requiredLevel) {
      return { ok: false, reason: 'player_level', item, requiredLevel, message: `플레이어 Lv.${requiredLevel} 필요` };
    }

    const requiredSkillLevel = this.#popupInt(item, 'RequiredSkillLevel', 0);
    const requiredSkills = parseCsvNumbers(item.popupArgs?.RequiredSkillItemDataIds);
    for (const requiredItemDataId of requiredSkills) {
      if (!this.#ownsItem(requiredItemDataId)) {
        const requiredItem = this.store.getItem(requiredItemDataId);
        return { ok: false, reason: 'required_skill', item, requiredItemDataId, message: `${requiredItem?.name || requiredItemDataId} 필요` };
      }
      if (requiredSkillLevel > 0 && this.getItemLevel(requiredItemDataId) < requiredSkillLevel) {
        const requiredItem = this.store.getItem(requiredItemDataId);
        return { ok: false, reason: 'required_skill_level', item, requiredItemDataId, requiredSkillLevel, message: `${requiredItem?.name || requiredItemDataId} Lv.${requiredSkillLevel} 필요` };
      }
    }

    const cost = this.#skillUnlockCost(item);
    if ((this.inventory.get(cost.itemDataId) || 0) < cost.count) {
      return { ok: false, reason: 'cost', item, cost, message: `레벨 포인트 ${cost.count} 필요` };
    }

    return { ok: true, item, cost, message: `${item.name} 해금 가능` };
  }

  levelUpSkillItem(itemDataId) {
    const item = this.store.getItem(itemDataId);
    if (!this.#isSkillTreeSkill(item)) return { ok: false, reason: 'not_skill', message: '스킬 아이템이 아닙니다' };
    if (!this.#ownsItem(item.id)) return { ok: false, reason: 'not_owned', item, message: `${item.name} 미습득` };

    const level = this.getItemLevel(item.id);
    const maxLevel = this.getItemMaxLevel(item.id);
    if (level >= maxLevel) return { ok: false, reason: 'max_level', item, level, maxLevel, message: `${item.name} MAX` };

    const group = this.#levelUpGroup(item, level);
    if (!group) return { ok: false, reason: 'missing_cost', item, level, maxLevel, message: `${item.name} 비용 없음` };

    const missing = this.#missingMaterials(group.materialItems || []);
    if (missing) return { ok: false, reason: 'not_enough_material', item, level, missing, cost: group.materialItems || [], message: `${missing.item?.name || missing.itemDataId} 부족 ${missing.current}/${missing.count}` };

    for (const material of group.materialItems || []) {
      this.spendItem(material.id ?? material.itemDataId, material.count, `skill_levelup:${item.id}`);
    }

    const nextLevel = level + 1;
    this.itemLevels.set(item.id, nextLevel);
    this.#refreshAchievements();
    this.#refreshSkillSlots();
    this.emit('skillLevelUp', { itemDataId: item.id, item, previousLevel: level, level: nextLevel, cost: group.materialItems || [] });
    this.emit('itemLevelUp', { itemDataId: item.id, item, previousLevel: level, level: nextLevel, cost: 0, source: 'skillTree' });
    this.emit('tick', this.snapshot());
    return { ok: true, item, previousLevel: level, level: nextLevel, maxLevel, cost: group.materialItems || [], message: `${item.name} Lv.${nextLevel}` };
  }

  addItem(itemDataId, count, reason = 'drop') {
    const id = Number(itemDataId);
    const amount = Math.max(0, Math.floor(asNumber(count, 0)));
    if (!id || amount <= 0) return 0;

    this.inventory.set(id, (this.inventory.get(id) || 0) + amount);
    this.itemAcquireCounts.set(id, (this.itemAcquireCounts.get(id) || 0) + amount);
    const item = this.store.getItem(id);
    this.emit('itemGained', { itemDataId: id, item, count: amount, reason });
    if (!this.refreshingAchievements) this.#refreshAchievements();
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
    this.#syncPlayerLevelProgress();
    this.#refreshAchievements();
    this.#refreshSkillSlots();
    this.emit('itemLevelUp', { itemDataId: id, item, previousLevel: level, level: nextLevel, cost });
    return { ok: true, item, previousLevel: level, level: nextLevel, cost, maxLevel };
  }

  get gold() {
    return this.inventory.get(GOLD_ITEM_ID) || 0;
  }

  get exp() {
    return this.inventory.get(EXP_ITEM_ID) || 0;
  }

  #seedInitialItems({ preserveExisting = false } = {}) {
    for (const item of this.store.items?.values?.() || []) {
      const id = Number(item.id);
      if (!id || !item.initialCreate) continue;

      const count = Math.max(0, Math.floor(asNumber(item.initialCreateCount, 0)));
      if (count > 0 && (!preserveExisting || !this.inventory.has(id))) {
        this.inventory.set(id, count);
      }

      if (item.initialCreateLevel != null && (!preserveExisting || !this.itemLevels.has(id))) {
        this.itemLevels.set(id, Math.max(1, Math.floor(asNumber(item.initialCreateLevel, 1))));
      }
    }
  }

  #syncPlayerLevelProgress({ silent = false } = {}) {
    const nextLevel = Math.max(1, Math.floor(Math.max(
      asNumber(this.itemLevels.get(PLAYER_LEVEL_ITEM_ID), 1),
      asNumber(this.playerUnit?.level, 1),
      asNumber(this.boardState, 1),
    )));
    const previousLevel = Math.max(1, Math.floor(asNumber(this.itemLevels.get(PLAYER_LEVEL_ITEM_ID), 1)));
    if (nextLevel <= previousLevel) return previousLevel;

    this.itemLevels.set(PLAYER_LEVEL_ITEM_ID, nextLevel);
    const grantFrom = Math.max(this.lastGrantedPlayerLevel, previousLevel);
    for (let level = grantFrom + 1; level <= nextLevel; level += 1) {
      this.addItem(LEVEL_POINT_ITEM_ID, 1, `player_level:${level}`);
    }
    this.lastGrantedPlayerLevel = Math.max(this.lastGrantedPlayerLevel, nextLevel);

    if (!silent) {
      this.emit('playerLevelChanged', { previousLevel, level: nextLevel });
      this.emit('itemLevelUp', {
        itemDataId: PLAYER_LEVEL_ITEM_ID,
        item: this.store.getItem(PLAYER_LEVEL_ITEM_ID),
        previousLevel,
        level: nextLevel,
        cost: 0,
        source: 'playerLevel',
      });
    }

    return nextLevel;
  }

  #refreshAchievements({ silent = false } = {}) {
    if (this.refreshingAchievements) return false;

    this.refreshingAchievements = true;
    let changed = false;
    try {
      for (const achievement of this.store.achievements?.values?.() || []) {
        const id = Number(achievement.id);
        if (!id || this.completedAchievements.has(id)) continue;
        if (!this.#isAchievementSatisfied(achievement)) continue;

        this.completedAchievements.add(id);
        changed = true;
        if (!silent) {
          this.emit('achievementCompleted', { achievementDataId: id, achievement });
          this.#grantAchievementRewards(achievement);
        }
      }
    } finally {
      this.refreshingAchievements = false;
    }

    if (changed) this.#refreshSkillSlots({ silent });
    return changed;
  }

  #isAchievementSatisfied(achievement) {
    const condition = achievement?.condition;
    if (condition === 'HasItemLevel') {
      return this.getItemLevel(achievement.conditionValue1) >= asNumber(achievement.conditionValue2, 1);
    }
    if (condition === 'HasItem') {
      return (this.inventory.get(Number(achievement.conditionValue1)) || 0) >= asNumber(achievement.conditionValue2, achievement.targetProgress || 1);
    }
    if (condition === 'WinGame') {
      return this.getMapWinCount(achievement.conditionValue1) >= asNumber(achievement.targetProgress, 1);
    }
    if (condition === 'WinWave') {
      return this.getMapWaveWinCount(achievement.conditionValue1) >= asNumber(achievement.targetProgress, 1);
    }
    if (condition === 'KillUnitAny') {
      return this.getUnitKillCount(achievement.conditionValue1) >= asNumber(achievement.targetProgress, 1);
    }
    if (condition === 'UseSkill') {
      return this.getSkillUseCount(achievement.conditionValue1) >= asNumber(achievement.targetProgress, 1);
    }
    if (condition === 'BuyItemProduct') {
      return this.getProductBuyCount(achievement.conditionValue1) >= asNumber(achievement.targetProgress, 1);
    }
    if (condition === 'BuyItemProductAction') {
      return (this.productBuyActions.get(Number(achievement.conditionValue1)) || 0) >= asNumber(achievement.targetProgress, 1);
    }
    if (condition === 'AcquireItemAny') {
      return this.getItemAcquireCount(0) >= asNumber(achievement.targetProgress, 1);
    }
    if (condition === 'AcquireItem') {
      return this.#acquireCountForItem(achievement.conditionValue1) >= asNumber(achievement.targetProgress, 1);
    }
    if (condition === 'AcquireWeaponItemAny') {
      return this.#acquireCountByItemMatch(item => item?.category === 'Weapon') >= asNumber(achievement.targetProgress, 1);
    }
    if (condition === 'AcquireEquipmentItemAny') {
      return this.#acquireCountByItemMatch(item => item?.category === 'Equipment') >= asNumber(achievement.targetProgress, 1);
    }
    return false;
  }

  #achievementProgressValue(achievement) {
    const condition = achievement?.condition;
    if (condition === 'HasItemLevel') return this.getItemLevel(achievement.conditionValue1);
    if (condition === 'HasItem') return this.inventory.get(Number(achievement.conditionValue1)) || 0;
    if (condition === 'WinGame') return this.getMapWinCount(achievement.conditionValue1);
    if (condition === 'WinWave') return this.getMapWaveWinCount(achievement.conditionValue1);
    if (condition === 'KillUnitAny') return this.getUnitKillCount(achievement.conditionValue1);
    if (condition === 'UseSkill') return this.getSkillUseCount(achievement.conditionValue1);
    if (condition === 'BuyItemProduct') return this.getProductBuyCount(achievement.conditionValue1);
    if (condition === 'BuyItemProductAction') return this.productBuyActions.get(Number(achievement.conditionValue1)) || 0;
    if (condition === 'AcquireItemAny') return this.getItemAcquireCount(0);
    if (condition === 'AcquireItem') return this.#acquireCountForItem(achievement.conditionValue1);
    if (condition === 'AcquireWeaponItemAny') return this.#acquireCountByItemMatch(item => item?.category === 'Weapon');
    if (condition === 'AcquireEquipmentItemAny') return this.#acquireCountByItemMatch(item => item?.category === 'Equipment');
    return 0;
  }

  #achievementProgressTarget(achievement) {
    if (achievement?.condition === 'HasItemLevel') {
      return Math.max(1, Math.floor(asNumber(achievement.conditionValue2, 1)));
    }
    if (achievement?.condition === 'HasItem') {
      return Math.max(1, Math.floor(asNumber(achievement.conditionValue2, achievement.targetProgress || 1)));
    }
    return Math.max(1, Math.floor(asNumber(achievement?.targetProgress, 1)));
  }

  #acquireCountForItem(itemDataId) {
    const target = Number(itemDataId);
    if (!target) return 0;
    return this.#acquireCountByItemMatch(item => this.#achievementItemDataId(item) === target);
  }

  #acquireCountByItemMatch(match) {
    let count = 0;
    for (const [itemDataId, amount] of this.itemAcquireCounts.entries()) {
      const item = this.store.getItem(itemDataId);
      if (match(item)) count += amount;
    }
    return count;
  }

  #achievementItemDataId(item) {
    return Number(item?.achievementItemDataId || item?.id || 0);
  }

  #recordUnitKill(unitDataId) {
    const id = Number(unitDataId);
    if (!id) return;
    this.unitKillCounts.set(id, (this.unitKillCounts.get(id) || 0) + 1);
  }

  #recordMapWin(mapDataId) {
    const id = Number(mapDataId);
    if (!id) return;
    this.mapWinCounts.set(id, (this.mapWinCounts.get(id) || 0) + 1);
  }

  #recordMapWaveWin(mapDataId) {
    const id = Number(mapDataId);
    if (!id) return;
    this.mapWaveWinCounts.set(id, (this.mapWaveWinCounts.get(id) || 0) + 1);
  }

  #recordSkillUse(skillDataId) {
    const id = Number(skillDataId);
    if (!id) return;
    this.skillUseCounts.set(id, (this.skillUseCounts.get(id) || 0) + 1);
  }

  #grantAchievementRewards(achievement) {
    if (!achievement?.autoReward) return;
    for (const group of achievement.rewardAddItemGroups || []) {
      if (Math.random() * 100 > asNumber(group.probPercent, 100)) continue;
      for (const addItem of group.addItems || []) {
        this.addItem(addItem.itemDataId, addItem.count ?? 1, `achievement:${achievement.id}`);
      }
    }
  }

  #refreshSkillSlots({ silent = false } = {}) {
    const previousCount = this.lastSkillSlotCount || 1;
    while (this.skillSlots.length < this.maxSkillSlots) this.skillSlots.push(null);
    if (this.skillSlots.length > this.maxSkillSlots) this.skillSlots.length = this.maxSkillSlots;

    const ownedSkills = this.#ownedSkillTreeItems();
    const equipped = new Set(this.skillSlots.filter(Boolean).map(Number));
    for (let i = 0; i < this.skillSlotCount; i += 1) {
      const currentItem = this.store.getItem(this.skillSlots[i]);
      if (currentItem && this.#ownsItem(currentItem.id)) continue;

      const next = ownedSkills.find(item => !equipped.has(Number(item.id)));
      this.skillSlots[i] = next?.id || null;
      if (next) equipped.add(Number(next.id));
    }

    for (let i = this.skillSlotCount; i < this.maxSkillSlots; i += 1) {
      if (this.skillSlots[i] && !this.#ownsItem(this.skillSlots[i])) this.skillSlots[i] = null;
    }

    const nextCount = this.skillSlotCount;
    this.lastSkillSlotCount = nextCount;
    if (!silent && nextCount !== previousCount) {
      this.emit('skillSlotCountChanged', { previousCount, count: nextCount });
    }
    if (!silent) this.emit('skillSlotsChanged', { slots: this.getSkillSlotStates() });
  }

  #ownedSkillTreeItems() {
    return this.#skillTreeItems().filter(item => this.#ownsItem(item.id));
  }

  #skillTreeItems(treeId = SKILL_TREE_ID) {
    return [...(this.store.items?.values?.() || [])]
      .filter(item => this.#isSkillTreeSkill(item, treeId))
      .sort((a, b) => (
        this.#popupInt(a, 'AutoUsePriority', 999) - this.#popupInt(b, 'AutoUsePriority', 999)
        || asNumber(a.order, 9999) - asNumber(b.order, 9999)
        || Number(a.id) - Number(b.id)
      ));
  }

  #skillItemState(item, slots = this.getSkillSlotStates()) {
    const level = this.getItemLevel(item.id);
    const maxLevel = this.getItemMaxLevel(item.id);
    const owned = this.#ownsItem(item.id);
    const equippedSlot = slots.find(slot => Number(slot.itemDataId) === Number(item.id));
    const unlock = this.canUnlockSkillItem(item);
    const levelUp = owned ? this.#canLevelUpSkillItem(item) : { ok: false, reason: 'not_owned', message: `${item.name} 미습득` };
    const requiredLevel = this.#popupInt(item, 'RequiredPlayerLevel', 1);
    const requiredSkills = parseCsvNumbers(item.popupArgs?.RequiredSkillItemDataIds)
      .map(id => this.store.getItem(id)?.name || String(id));
    return {
      itemDataId: item.id,
      item,
      skill: this.store.getSkill(item.skillDataId),
      owned,
      level: owned ? level : 0,
      maxLevel,
      equippedSlotIndex: equippedSlot?.index ?? -1,
      unlock,
      levelUp,
      canUnlock: unlock.ok,
      canLevelUp: levelUp.ok,
      requiredLevel,
      requiredSkills,
      node: item.popupArgs?.SkillTreeNode || '',
      priority: this.#popupInt(item, 'AutoUsePriority', 999),
      levelPointItemDataId: this.#popupInt(item, 'LevelPointItemDataId', LEVEL_POINT_ITEM_ID),
      unlockCost: this.#skillUnlockCost(item),
    };
  }

  #canLevelUpSkillItem(item) {
    const level = this.getItemLevel(item.id);
    const maxLevel = this.getItemMaxLevel(item.id);
    if (level >= maxLevel) return { ok: false, reason: 'max_level', item, level, maxLevel, message: 'MAX' };
    const group = this.#levelUpGroup(item, level);
    if (!group) return { ok: false, reason: 'missing_cost', item, level, maxLevel, message: '비용 없음' };
    const missing = this.#missingMaterials(group.materialItems || []);
    if (missing) return { ok: false, reason: 'not_enough_material', item, level, missing, cost: group.materialItems || [], message: `${missing.item?.name || missing.itemDataId} 부족` };
    return { ok: true, item, level, maxLevel, cost: group.materialItems || [], message: `Lv.${level + 1}` };
  }

  #levelUpGroup(item, level) {
    return (item?.levelUpMaterialItemGroups || []).find(entry => Number(entry.level) === Number(level));
  }

  #missingMaterials(materials) {
    for (const material of materials || []) {
      const itemDataId = Number(material.id ?? material.itemDataId);
      const count = Math.max(0, Math.floor(asNumber(material.count, 0)));
      const current = this.inventory.get(itemDataId) || 0;
      if (current < count) {
        return { itemDataId, item: this.store.getItem(itemDataId), count, current };
      }
    }
    return null;
  }

  #skillUnlockCost(item) {
    return {
      itemDataId: this.#popupInt(item, 'LevelPointItemDataId', LEVEL_POINT_ITEM_ID),
      count: Math.max(0, this.#popupInt(item, 'UnlockCostLevelPoint', 0)),
    };
  }

  #isSkillTreeSkill(item, treeId = SKILL_TREE_ID) {
    return item?.category === 'Skill'
      && item?.skillDataId
      && (item.popupArgs?.SkillTree || SKILL_TREE_ID) === treeId;
  }

  #ownsItem(itemDataId) {
    return (this.inventory.get(Number(itemDataId)) || 0) > 0;
  }

  #popupInt(item, key, fallback = 0) {
    return Math.floor(asNumber(item?.popupArgs?.[key], fallback));
  }

  #slotUnlockLevel(slotIndex) {
    const unlock = SKILL_SLOT_UNLOCKS.find(entry => entry.slots === slotIndex + 1);
    return unlock?.level || 1;
  }

  #refreshPlayerStats() {
    const player = this.playerUnit;
    if (player) player.refreshStatsFromBoard();
  }

  #updateTick() {
    if (this.gameEnded) return;

    this.tick += 1;
    this.#syncPlayerLevelProgress();
    this.#refreshAchievements();
    this.#refreshSkillSlots();
    this.#updateRevives();
    this.#updateBuffs();
    this.triggerVM.tick();
    this.#updateMovement();
    this.#updateCombat();
    this.#updateActiveSkills();
    this.emit('tick', this.snapshot());
  }

  #updateMovement() {
    const survivorBoard = isSurvivorBoard(this);
    for (const unit of this.units.values()) {
      if (!unit.alive || !['approaching', 'moving'].includes(unit.state)) continue;
      if (survivorBoard && unit.team !== TEAM.PLAYER && unit.state === 'approaching') {
        unit.refreshChaseDestination();
      }

      const dx = unit.targetX - unit.x;
      const dy = unit.targetY - unit.y;
      if (survivorBoard) {
        const dist = Math.hypot(dx, dy);
        const move = unit.moveSpeedPx / TICKS_PER_SECOND;
        if (dist > move && dist > 0) {
          unit.x += (dx / dist) * move;
          unit.y += (dy / dist) * move;
        } else {
          unit.x = unit.targetX;
          unit.y = unit.targetY;
        }

        if (Math.hypot(unit.x - unit.targetX, unit.y - unit.targetY) < 4) {
          unit.state = 'combat';
          this.emit('unitEnteredCombat', unit);
        }
        continue;
      }

      const move = Math.sign(dx) * unit.moveSpeedPx / TICKS_PER_SECOND;
      unit.x += Math.abs(move) < Math.abs(dx) ? move : dx;
      unit.y += dy * 0.02;

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

    this.#updateAutoSkills(player, enemies);

    for (const enemy of enemies) {
      if (isSurvivorBoard(this) && enemy.targetDistance > enemy.chaseResumeRange) {
        enemy.state = 'approaching';
        enemy.refreshChaseDestination();
        continue;
      }

      enemy.attackTimer -= 1;
      if (enemy.attackTimer > 0) continue;

      const damage = Math.max(1, Math.round(enemy.attack - player.defense));
      this.emit('unitAttack', { unit: enemy, target: player });
      player.takeDamage(damage, enemy);
      enemy.attackTimer = enemy.attackIntervalTicks;
    }
  }

  #updateAutoSkills(player, enemies) {
    for (const [itemDataId, ticks] of [...this.skillCooldownTimers.entries()]) {
      if (ticks <= 1) this.skillCooldownTimers.delete(itemDataId);
      else this.skillCooldownTimers.set(itemDataId, ticks - 1);
    }

    if (!this.autoSkillsEnabled) return;

    const equipped = this.getSkillSlotStates()
      .filter(slot => slot.unlocked && slot.item && slot.skill && slot.cooldownTicks <= 0)
      .sort((a, b) => a.index - b.index);

    for (const slot of equipped) {
      const targets = this.#targetsForSkill(slot.skill, enemies, player);
      if (targets.length === 0) continue;

      this.#startSkill(player, slot.skill, targets, {
        slotIndex: slot.index,
        skillItemDataId: slot.item.id,
        skillItem: slot.item,
        skillLevel: slot.level,
      });

      this.skillCooldownTimers.set(slot.item.id, this.#cooldownTicksForSkill(slot.skill, player));
      this.emit('skillAutoUsed', {
        slotIndex: slot.index,
        itemDataId: slot.item.id,
        item: slot.item,
        skillDataId: slot.skill.id,
        skill: slot.skill,
        level: slot.level,
      });
    }
  }

  #targetsForSkill(skillDef, enemies, owner = null) {
    const maxHit = Math.max(1, ...((skillDef.timelines || [])
      .map(timeline => asNumber(timeline.hit?.maxHit, 1))));
    const candidates = enemies.filter(unit => unit.alive);
    const mode = skillDef?.targetRefreshType || 'Nearest';

    if (mode === 'Random') {
      return candidates
        .map(unit => ({ unit, roll: Math.random() }))
        .sort((a, b) => a.roll - b.roll)
        .slice(0, maxHit)
        .map(entry => entry.unit);
    }

    if (mode === 'Furthest') {
      return candidates
        .sort((a, b) => distanceSq(owner || b, b) - distanceSq(owner || a, a))
        .slice(0, maxHit);
    }

    if (mode === 'LowestHp') {
      return candidates
        .sort((a, b) => (a.hp / Math.max(1, a.maxHp)) - (b.hp / Math.max(1, b.maxHp)))
        .slice(0, maxHit);
    }

    if (mode === 'HighestHp') {
      return candidates
        .sort((a, b) => (b.hp / Math.max(1, b.maxHp)) - (a.hp / Math.max(1, a.maxHp)))
        .slice(0, maxHit);
    }

    return candidates
      .sort((a, b) => distanceSq(owner || a, a) - distanceSq(owner || b, b))
      .slice(0, maxHit);
  }

  #cooldownTicksForSkill(skillDef, owner = this.playerUnit) {
    const cooldownPercent = this.getItemStat('CooldownPercent') + (owner?.getBuffStat?.('CooldownPercent') || 0);
    const seconds = Math.max(0.45, asNumber(skillDef?.cooldown, 1.5) * Math.max(0.25, 1 - cooldownPercent / 100));
    return ticksFromSeconds(seconds, 1);
  }

  #startSkill(owner, skillDef, targets, metadata = {}) {
    const skill = {
      id: this.nextSkillId++,
      dataId: skillDef.id,
      def: skillDef,
      owner,
      targets: targets.filter(Boolean),
      startTick: this.tick,
      slotIndex: metadata.slotIndex ?? null,
      skillItemDataId: metadata.skillItemDataId ?? null,
      skillItem: metadata.skillItem || null,
      skillLevel: Math.max(1, asNumber(metadata.skillLevel, 1)),
      powerMultiplier: Math.max(1, 1 + (Math.max(1, asNumber(metadata.skillLevel, 1)) - 1) * SKILL_LEVEL_DAMAGE_BONUS),
      executed: new Set(),
      destroyed: false,
    };
    this.activeSkills.set(skill.id, skill);
    if (skillHasSelfBuff(skillDef)) this.#applyBuffRefs(owner, skillDef.selfAddBuffs, skill);
    this.#recordSkillUse(skillDef.id);
    this.#refreshAchievements();
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
      const ratio = asNumber(levelValue(ratios, skill.skillLevel, ratios[0] ?? 1), 1);
      const hitBuffRefs = [
        ...(timeline.hit.addBuffs || []),
        ...(skill.def.addBuffs || []),
      ];

      for (const target of targets) {
        const damageTakenMultiplier = Math.max(0.1, 1 + (target.getBuffStat?.('DamageTakenEfficiencyPercent') || 0) / 100);
        const raw = skill.owner.attack * ratio * (skill.powerMultiplier || 1) * damageTakenMultiplier;
        const damage = Math.max(1, Math.round(raw - target.defense));
        target.takeDamage(damage, skill.owner, skill);
        this.#applyBuffRefs(target, hitBuffRefs, skill);
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

  #applyBuffRefs(unit, buffRefs = [], skill = null) {
    if (!unit?.alive || !Array.isArray(buffRefs) || buffRefs.length === 0) return 0;
    let applied = 0;
    for (const buffRef of buffRefs) {
      const buff = this.store.getBuff(buffRef?.buffDataId);
      if (!buff) continue;
      const sourceDurationBonus = skill?.owner?.getBuffStat?.('BuffDurationEfficiencyPercent') || 0;
      const duration = asNumber(buffRef.duration, 0) * Math.max(0.1, 1 + sourceDurationBonus / 100);
      const level = Math.max(1, Math.floor(asNumber(buffRef.level ?? skill?.skillLevel, skill?.skillLevel || 1)));
      if (unit.addBuff({ buff, level, duration, source: skill?.owner || null, skill })) applied += 1;
    }
    return applied;
  }

  #updateBuffs() {
    for (const unit of this.units.values()) {
      if (unit.removeExpiredBuffs(this.tick)) {
        this.emit('buffsChanged', { unit, activeBuffs: unit.activeBuffs });
      }
    }
  }

  handleUnitDeath(unit, source, skill) {
    this.emit('unitDied', { unit, source, skill });
    if (unit.team === TEAM.PLAYER) {
      unit.reviveAtTick = this.tick + ticksFromSeconds(5);
      this.emit('playerDefeated', { unit, reviveAtTick: unit.reviveAtTick });
      return;
    }
    this.#recordUnitKill(unit.dataId);
    this.#refreshAchievements();
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

  #grantMapRewards(map) {
    const rewards = [];
    for (const group of map?.rewardAddItemGroups || []) {
      if (Math.random() * 100 > asNumber(group.probPercent, 100)) continue;
      const addItems = group.addItems || [];
      const chosen = group.shouldAddAll ? addItems : [weightedPick(addItems)];
      for (const addItem of chosen.filter(Boolean)) {
        const count = rollCount(addItem);
        const itemDataId = Number(addItem.itemDataId);
        const granted = this.addItem(itemDataId, count, `map_clear:${map.id}`);
        if (granted <= 0) continue;
        rewards.push({
          itemDataId,
          item: this.store.getItem(itemDataId),
          count: granted,
          isCore: Boolean(addItem.isCore),
        });
      }
    }
    return rewards;
  }

  get playerUnit() {
    return [...this.units.values()].find(unit => unit.team === TEAM.PLAYER);
  }

  get activePlayerUnit() {
    const unit = this.playerUnit;
    return unit?.alive ? unit : null;
  }

  get enemyUnits() {
    return [...this.units.values()].filter(unit => unit.alive && unit.team !== TEAM.PLAYER);
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
    this.baseMoveSpeed = Math.max(0.1, board.store.statValue(def, 'MoveSpeed', this.level, 2));
    this.moveSpeed = this.baseMoveSpeed;
    this.maxHp = 1;
    this.hp = 1;
    this.attack = 1;
    this.defense = 0;
    this.criticalPercent = 0;
    this.criticalDamagePercent = 0;
    this.attackSpeed = this.baseAttackSpeed;
    this.activeBuffs = [];
    this.refreshStatsFromBoard({ healToFull: true });
    this.moveSpeedPx = this.moveSpeed * 28;

    this.alive = true;
    this.state = options.state || (this.team === TEAM.ENEMY ? 'approaching' : 'combat');
    const slot = board.enemyUnits.length + asNumber(options.spawnIndex, 0);
    const spawn = resolveSpawnPosition(board, options, slot, this.team);
    this.x = spawn.x;
    this.y = spawn.y;
    this.targetX = asNumber(options.targetX, this.team === TEAM.PLAYER ? this.x : boardWorldToScreenX(board, 0));
    this.targetY = asNumber(options.targetY, this.team === TEAM.PLAYER ? this.y : boardWorldToScreenY(board, 0));
    this.attackIntervalTicks = ticksFromSeconds(1 / this.attackSpeed, 10);
    this.attackTimer = this.attackIntervalTicks + Math.floor(Math.random() * 20);
    this.skillTimer = ticksFromSeconds(1.0, 1);
    this.followTargetId = null;
    this.followOffsetX = 0;
    this.followOffsetY = 0;
    this.followJitterX = 0;
    this.followJitterY = 0;
    this.chaseResumeRange = this.type === 'Boss' ? 1.65 : 1.35;
  }

  refreshStatsFromBoard({ healToFull = false } = {}) {
    const previousMaxHp = this.maxHp || 0;
    const hpBonus = (this.team === TEAM.PLAYER ? this.board.getItemStat('Hp') : 0) + this.getBuffStat('Hp');
    const attackBonus = this.team === TEAM.PLAYER ? this.board.getItemStat('Attack') : 0;
    const attackPercent = this.getBuffStat('AttackPercent');
    const defensePercent = this.getBuffStat('DefensePercent');
    const attackSpeedPercent = (this.team === TEAM.PLAYER ? this.board.getItemStat('AttackSpeedPercent') : 0)
      + this.getBuffStat('AttackSpeedPercent');
    const criticalPercent = this.getBuffStat('CriticalPercent');
    const criticalDamagePercent = (this.team === TEAM.PLAYER ? this.board.getItemStat('CriticalDamagePercent') : 0)
      + this.getBuffStat('CriticalDamagePercent');
    const moveSpeedBonus = this.getBuffStat('MoveSpeed');

    this.maxHp = Math.max(1, Math.round(this.baseMaxHp + hpBonus));
    this.attack = Math.max(1, Math.round((this.baseAttack + attackBonus) * Math.max(0.1, 1 + attackPercent / 100)));
    this.defense = Math.max(0, Math.round(this.baseDefense * Math.max(0.1, 1 + defensePercent / 100)));
    this.criticalPercent = this.baseCriticalPercent + criticalPercent;
    this.criticalDamagePercent = criticalDamagePercent;
    this.attackSpeed = Math.max(0.2, this.baseAttackSpeed * (1 + attackSpeedPercent / 100));
    this.attackIntervalTicks = ticksFromSeconds(1 / this.attackSpeed, 10);
    this.moveSpeed = Math.max(0.1, this.baseMoveSpeed + moveSpeedBonus);
    this.moveSpeedPx = this.moveSpeed * 28;

    if (healToFull || previousMaxHp <= 0) {
      this.hp = this.maxHp;
    } else {
      const gainedMaxHp = Math.max(0, this.maxHp - previousMaxHp);
      this.hp = clamp(this.hp + gainedMaxHp, this.alive ? 1 : 0, this.maxHp);
    }
  }

  addBuff({ buff, level = 1, duration = 0, source = null, skill = null } = {}) {
    if (!buff?.id || duration <= 0) return false;
    const buffDataId = Number(buff.id);
    const buffLevel = Math.max(1, Math.floor(asNumber(level, 1)));
    const expiresAtTick = this.board.tick + ticksFromSeconds(duration, 1);

    this.activeBuffs = this.activeBuffs.filter(active => Number(active.buffDataId) !== buffDataId);
    const activeBuff = {
      buffDataId,
      buff,
      level: buffLevel,
      expiresAtTick,
      source,
      skill,
    };
    this.activeBuffs.push(activeBuff);
    this.refreshStatsFromBoard();
    this.board.emit('buffApplied', {
      unit: this,
      buff,
      buffDataId,
      level: buffLevel,
      duration,
      expiresAtTick,
      source,
      skill,
    });
    return true;
  }

  removeExpiredBuffs(tick = this.board.tick) {
    if (!this.activeBuffs.length) return false;
    const before = this.activeBuffs.length;
    this.activeBuffs = this.activeBuffs.filter(active => active.expiresAtTick > tick);
    if (this.activeBuffs.length === before) return false;
    this.refreshStatsFromBoard();
    return true;
  }

  getBuffStat(statType) {
    return this.activeBuffs.reduce((total, active) => {
      const stat = (active.buff?.addStats || []).find(entry => entry.type === statType);
      if (!stat) return total;
      return total + asNumber(levelValue(stat.value, active.level, 0), 0);
    }, 0);
  }

  SetMoveRandomDestination({
    positionX,
    positionY,
    positionXrange,
    positionYrange,
  } = {}) {
    const target = isSurvivorBoard(this.board) && this.team !== TEAM.PLAYER ? this.targetUnit : null;
    const rangeX = Math.max(0, asNumber(positionXrange, 0));
    const rangeY = Math.max(0, asNumber(positionYrange, 0));

    if (target) {
      this.followTargetId = target.id;
      this.followOffsetX = positionX == null ? 0 : asNumber(positionX, 0);
      this.followOffsetY = positionY == null ? 0 : asNumber(positionY, 0);
      this.followJitterX = (Math.random() * 2 - 1) * rangeX;
      this.followJitterY = (Math.random() * 2 - 1) * rangeY;
      this.refreshChaseDestination();
    } else {
      this.followTargetId = null;
      const fallbackX = boardScreenToWorldX(this.board, this.targetX);
      const fallbackY = boardScreenToWorldY(this.board, this.targetY);
      const baseX = asNumber(positionX, fallbackX);
      const baseY = asNumber(positionY, fallbackY);
      const nextX = baseX + (Math.random() * 2 - 1) * rangeX;
      const nextY = baseY + (Math.random() * 2 - 1) * rangeY;
      this.targetX = boardWorldToScreenX(this.board, nextX);
      this.targetY = boardWorldToScreenY(this.board, nextY);
    }

    this.state = this.team === TEAM.ENEMY ? 'approaching' : 'moving';
    this.board.emit('unitCommand', { unit: this, command: 'SetMoveRandomDestination' });
    return 0;
  }

  refreshChaseDestination() {
    if (!isSurvivorBoard(this.board) || this.team === TEAM.PLAYER || this.followTargetId == null) return false;
    const target = this.board.units.get(this.followTargetId);
    if (!target?.alive) {
      this.followTargetId = null;
      return false;
    }

    const nextX = boardScreenToWorldX(this.board, target.x) + this.followOffsetX + this.followJitterX;
    const nextY = boardScreenToWorldY(this.board, target.y) + this.followOffsetY + this.followJitterY;
    this.targetX = boardWorldToScreenX(this.board, nextX);
    this.targetY = boardWorldToScreenY(this.board, nextY);
    return true;
  }

  SetMoveDestination({ positionX, positionY } = {}) {
    this.followTargetId = null;
    this.targetX = boardWorldToScreenX(this.board, asNumber(positionX, boardScreenToWorldX(this.board, this.x)));
    this.targetY = boardWorldToScreenY(this.board, asNumber(positionY, boardScreenToWorldY(this.board, this.y)));
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

  UseSkill({ skillDataId } = {}) {
    return this.board.startSkill(this, asNumber(skillDataId, DEFAULT_SKILL_ID));
  }

  getVariable(type) {
    if (type === 'HasTarget') return this.targetUnit ? 1 : 0;
    if (type === 'TargetDistance') return this.targetDistance;
    this.board.warn(`Unknown unit variable: ${type}`);
    return 0;
  }

  get targetUnit() {
    const opponents = [...this.board.units.values()]
      .filter(unit => unit.alive)
      .filter(unit => this.team === TEAM.PLAYER ? unit.team !== TEAM.PLAYER : unit.team === TEAM.PLAYER)
      .sort((a, b) => distanceSq(this, a) - distanceSq(this, b));
    return opponents[0] || null;
  }

  get targetDistance() {
    const target = this.targetUnit;
    if (!target) return Infinity;
    return Math.hypot(target.x - this.x, target.y - this.y) / boardWorldScaleX(this.board);
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

function parseCsvNumbers(value) {
  if (Array.isArray(value)) return value.map(Number).filter(Number.isFinite);
  return String(value || '')
    .split(',')
    .map(part => Number(part.trim()))
    .filter(Number.isFinite);
}

function levelValue(value, level = 1, fallback = 0) {
  if (Array.isArray(value)) {
    return value[clamp(Math.max(1, Math.floor(asNumber(level, 1))) - 1, 0, value.length - 1)] ?? fallback;
  }
  return value ?? fallback;
}

function skillHasHit(skillDef) {
  return (skillDef?.timelines || []).some(timeline => timeline.hit);
}

function skillHasSelfBuff(skillDef) {
  return Array.isArray(skillDef?.selfAddBuffs) && skillDef.selfAddBuffs.length > 0;
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

function isSurvivorBoard(board) {
  return String(board?.map?.popupArgs?.ClientRuntimePrototype || '').toLowerCase() === 'survivor';
}

function boardWorldScaleX(board) {
  return isSurvivorBoard(board) ? SURVIVOR_WORLD_SCALE_X : WORLD_SCALE_X;
}

function boardWorldToScreenX(board, value) {
  if (!isSurvivorBoard(board)) return worldToScreenX(value);
  return clamp(
    SURVIVOR_WORLD_ORIGIN_X + asNumber(value, 0) * SURVIVOR_WORLD_SCALE_X,
    40,
    SURVIVOR_WORLD_WIDTH - 40,
  );
}

function boardWorldToScreenY(board, value) {
  if (!isSurvivorBoard(board)) return worldToScreenY(value);
  return clamp(
    SURVIVOR_WORLD_ORIGIN_Y - asNumber(value, 0) * SURVIVOR_WORLD_SCALE_Y,
    40,
    SURVIVOR_WORLD_HEIGHT - 40,
  );
}

function boardScreenToWorldX(board, value) {
  if (!isSurvivorBoard(board)) return screenToWorldX(value);
  return (asNumber(value, SURVIVOR_WORLD_ORIGIN_X) - SURVIVOR_WORLD_ORIGIN_X) / SURVIVOR_WORLD_SCALE_X;
}

function boardScreenToWorldY(board, value) {
  if (!isSurvivorBoard(board)) return screenToWorldY(value);
  return (SURVIVOR_WORLD_ORIGIN_Y - asNumber(value, SURVIVOR_WORLD_ORIGIN_Y)) / SURVIVOR_WORLD_SCALE_Y;
}

function distanceSq(a, b) {
  return (a.x - b.x) ** 2 + (a.y - b.y) ** 2;
}

function resolveSpawnPosition(board, options, slot, team) {
  if (options.x != null || options.y != null) {
    return {
      x: asNumber(options.x, team === TEAM.PLAYER ? 150 : 760 + slot * 24),
      y: asNumber(options.y, team === TEAM.PLAYER ? 610 : 560 + (slot % 5) * 42),
    };
  }

  if (options.positionX != null || options.positionY != null) {
    return {
      x: boardWorldToScreenX(board, options.positionX),
      y: boardWorldToScreenY(board, options.positionY),
    };
  }

  const location = findMapLocation(board.map, options.locationId);
  if (location) {
    const point = randomPointInLocation(location);
    return {
      x: boardWorldToScreenX(board, point.x),
      y: boardWorldToScreenY(board, point.y),
    };
  }

  return {
    x: team === TEAM.PLAYER ? (isSurvivorBoard(board) ? SURVIVOR_WORLD_ORIGIN_X : 150) : 760 + slot * 24,
    y: team === TEAM.PLAYER ? (isSurvivorBoard(board) ? SURVIVOR_WORLD_ORIGIN_Y : 610) : 560 + (slot % 5) * 42,
  };
}

function findMapLocation(map, locationId) {
  const id = Number(locationId);
  if (!Number.isFinite(id) || id === 0) return null;
  return (map?.locations || []).find(location => Number(location.id) === id) || null;
}

function randomPointInLocation(location) {
  const base = location.position || {};
  const geometry = (location.geometries || [])[0] || {};
  const circle = geometry.circle || {};
  const center = circle.center || {};
  const radius = Math.max(0, asNumber(circle.radius, 0));
  const angle = Math.random() * Math.PI * 2;
  const distance = Math.sqrt(Math.random()) * radius;
  return {
    x: asNumber(base.x, 0) + asNumber(center.x, 0) + Math.cos(angle) * distance,
    y: asNumber(base.y, 0) + asNumber(center.y, 0) + Math.sin(angle) * distance,
  };
}
