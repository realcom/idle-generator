import { ResourceStore } from '../idlez-phaser/resource-store.js?v=ninja2-run-skills1';
import { IdlezBoard } from '../idlez-phaser/board-kernel.js?v=ninja2-run-skills1';
import { TEAM, TICKS_PER_SECOND, clamp, formatNumber } from '../idlez-phaser/constants.js?v=ninja2-run-skills1';
import { HOUSING_TECH } from './housing-tech.js?v=ninja2-run-skills1';
import {
  RUN_PROFILE_SKILL_ROWS,
  SKILL_ICON_PATHS,
  SKILL_VFX_DEMO_IDS,
  getSkillVfxProfile,
  installSkillVfxContract,
  maybeStartSkillVfxDemo,
  spawnSkillCastFx,
  spawnSkillTimelineFx,
} from './skill-vfx.js?v=ninja2-run-skills1';

const PhaserRef = globalThis.Phaser;

if (!PhaserRef) {
  throw new Error('Phaser failed to load');
}

document.documentElement.dataset.survivorBootPhase = 'module-loaded';

const params = new URLSearchParams(globalThis.location?.search || '');
const GAME_ID = params.get('game') || 'ninja2';
const START_MAP_ID = Number(params.get('map') || 500101);
const INITIAL_MODE = params.get('mode') || params.get('screen') || 'home';
const VFX_DEMO_MODE = ['1', 'true', 'demo', 'skills'].includes(String(params.get('vfx') || params.get('skillVfxDemo') || params.get('skillFxDemo') || '').toLowerCase());
const LEVEL_CHOICE_DEMO_MODE = ['1', 'true', 'demo', 'choice'].includes(String(params.get('levelup') || params.get('levelChoiceDemo') || '').toLowerCase());
const FAST_VFX_ASSETS = (VFX_DEMO_MODE || LEVEL_CHOICE_DEMO_MODE) && params.get('fullAssets') !== '1';
const ASSET_VERSION = 'ninja2-nineslice1';
const STAGE = { width: 941, height: 1672 };
const WORLD = { width: 3000, height: 2000, centerX: 1500, centerY: 1000 };
const STORAGE_KEY = 'ninja2.survivorLoopState.v1';
const COLORS = {
  gold: 0xf6c343,
  soul: 0x2ee6ff,
  wood: 0xa96a32,
  stone: 0xd8d8c2,
  leaf: 0x8bd95c,
  cream: 0xfff1c8,
  ink: 0x18241d,
  red: 0xff6b55,
  yellow: 0xffdd57,
  cyan: 0x43e7ff,
};

const STATIC_UNIT_TEXTURES = new Map([
  [110501, 'battleThornBoss'],
]);

const STATIC_UNIT_TEXTURE_FAMILIES = new Map([
  [110501, 'enemy_thorn_boss'],
]);

const DIRECTION_NAMES = ['down', 'left', 'up'];
const HERO_WALK_TEXTURE = 'battleGuardianHeroWalk';
const HERO_WALK_FRAME = { width: 512, height: 512 };
const HERO_WALK_FRAME_COUNT = 8;
const HERO_WALK_DIRECTIONS = ['down', 'left', 'up'];
const HERO_WALK_ANIMS = {
  down: 'battleGuardianHeroWalkDown',
  left: 'battleGuardianHeroWalkSide',
  up: 'battleGuardianHeroWalkUp',
};
const HERO_WALK_FRAME_RATES = {
  down: 7,
  left: 4,
  up: 6,
};
const DIRECTIONAL_TEXTURE_FAMILIES = {
  guardian_hero: 'battleGuardianHero',
  enemy_leaf_imp: 'battleLeafImp',
  enemy_soot_spirit: 'battleSootSpirit',
  enemy_purple_mushroom: 'battleMushroomEnemy',
  enemy_thorn_boss: 'battleThornBoss',
};
const DIRECTIONAL_TEXTURES = Object.fromEntries(
  Object.entries(DIRECTIONAL_TEXTURE_FAMILIES).map(([family, prefix]) => [
    family,
    Object.fromEntries(
      DIRECTION_NAMES.map(direction => [
        direction,
        `${prefix}${direction[0].toUpperCase()}${direction.slice(1)}`,
      ])
    ),
  ])
);
const PLAYER_TEXTURE_FAMILIES = new Map([
  [110111, 'guardian_hero'],
]);
const ENEMY_VARIANT_FAMILIES = ['enemy_leaf_imp', 'enemy_soot_spirit', 'enemy_purple_mushroom'];
const GENERATED_TEXTURE_BY_FAMILY = {
  guardian_hero: 'guardian',
  enemy_leaf_imp: 'leafImp',
  enemy_soot_spirit: 'sootSpirit',
  enemy_purple_mushroom: 'mushroomEnemy',
  enemy_thorn_boss: 'thornBoss',
};
const RUN_RESOURCE_DROPS = [
  { key: 'wood', texture: 'woodCrate', amount: 1 },
  { key: 'stone', texture: 'stoneDrop', amount: 1 },
  { key: 'souls', texture: 'soulFlame', amount: 1 },
  { key: 'gold', texture: 'coinDrop', amount: 1 },
];
const MAX_RUN_SKILL_LEVEL = 5;
const RUN_SKILL_RETRY_TICKS = Math.ceil(TICKS_PER_SECOND * 0.35);
const LEVEL_CHOICE_DEMO_IDS = Object.freeze([300101, 300103, 300115]);
const RUN_LEVEL_CHOICE_SKILL_IDS = Object.freeze(SKILL_VFX_DEMO_IDS);
const SKILL_CHOICE_COPY = Object.freeze({
  300101: '가까운 적을 빠르게 베고 관통합니다.',
  300102: '표창을 흩뿌려 가까운 무리를 끊습니다.',
  300103: '연막을 터뜨려 적 이동을 둔화시킵니다.',
  300104: '호흡을 가다듬어 공속과 쿨타임을 개선합니다.',
  300105: '수리검이 주변을 돌며 접근한 적을 베어냅니다.',
  300106: '번개 쿠나이가 두 대상을 연쇄 타격합니다.',
  300107: '불꽃 두루마리가 바닥에 지속 피해를 남깁니다.',
  300108: '정밀 침술로 단일 대상을 강하게 찌릅니다.',
  300109: '분신이 전방을 함께 베어 빈틈을 만듭니다.',
  300110: '월광 궤적으로 직선상의 적을 절단합니다.',
  300111: '대나무 창비가 넓은 구역에 쏟아집니다.',
  300112: '흑련 폭풍이 화면 주변의 적을 휘감습니다.',
  300113: '살의를 집중해 공격력과 치명 효율을 올립니다.',
  300114: '시간을 접어 쿨타임과 공격 템포를 당깁니다.',
  300115: '질풍 보법으로 이동속도와 공속을 높입니다.',
  300116: '약점을 표식해 받는 피해를 증가시킵니다.',
});
const SKILL_FAMILY_LABELS = Object.freeze({
  slash: { icon: '刃', label: '근접' },
  projectileVolley: { icon: '手', label: '투사체' },
  smokeBomb: { icon: '煙', label: '제어' },
  shadowBreath: { icon: '息', label: '버프' },
  orbitBurst: { icon: '旋', label: '궤도' },
  lightning: { icon: '雷', label: '연쇄' },
  flameGround: { icon: '火', label: '장판' },
  needlePierce: { icon: '針', label: '암살' },
  shadowClone: { icon: '影', label: '분신' },
  moonFlash: { icon: '月', label: '직선' },
  spearRain: { icon: '竹', label: '광역' },
  lotusStorm: { icon: '蓮', label: '폭풍' },
  killingFocus: { icon: '瞳', label: '버프' },
  timeFold: { icon: '刻', label: '버프' },
  galeStep: { icon: '風', label: '기동' },
  weakPointMark: { icon: '的', label: '표식' },
});
const STAT_LABELS = Object.freeze({
  AttackPercent: '공격',
  AttackSpeedPercent: '공속',
  BuffDurationEfficiencyPercent: '지속',
  CooldownPercent: '쿨감',
  CriticalDamagePercent: '치피',
  CriticalPercent: '치명',
  DamageTakenEfficiencyPercent: '받피',
  DefensePercent: '방어',
  MoveSpeed: '이속',
});
const AVAILABLE_HOME_BUILDING_SPRITES = new Set([
  'guard_lantern',
  'herb_garden',
  'shrine',
  'soulflame_well',
  'storage',
  'training_yard',
  'wood_workshop',
]);

const BUILDING_BY_KEY = new Map(HOUSING_TECH.buildings.map(building => [building.key, building]));
const BUILDINGS = HOUSING_TECH.buildings.map(toHomeBuilding);
const TILE_STATE_VERSION = 2;

const HEXES = [
  { id: 1, q: 0, r: -3, state: 'fog', cost: 220, minShrineLevel: 5 },
  { id: 2, q: -1, r: -2, state: 'fog', cost: 180, minShrineLevel: 5 },
  { id: 3, q: 0, r: -2, state: 'fog', cost: 180, minShrineLevel: 5 },
  { id: 4, q: 1, r: -2, state: 'fog', cost: 100, minShrineLevel: 3 },
  { id: 5, q: -2, r: -1, state: 'fog', cost: 180, minShrineLevel: 5 },
  { id: 6, q: -1, r: -1, state: 'empty', cost: 40 },
  { id: 7, q: 0, r: -1, state: 'built' },
  { id: 8, q: 1, r: -1, state: 'fog', cost: 40, minShrineLevel: 2 },
  { id: 9, q: 2, r: -1, state: 'fog', cost: 70, minShrineLevel: 2 },
  { id: 10, q: -2, r: 0, state: 'fog', cost: 150, minShrineLevel: 4 },
  { id: 11, q: -1, r: 0, state: 'built' },
  { id: 12, q: 0, r: 0, state: 'built', selected: true },
  { id: 13, q: 1, r: 0, state: 'fog', cost: 40, minShrineLevel: 2 },
  { id: 14, q: 2, r: 0, state: 'fog', cost: 150, minShrineLevel: 4 },
  { id: 15, q: -2, r: 1, state: 'locked', cost: 0, minShrineLevel: 6 },
  { id: 16, q: -1, r: 1, state: 'empty', cost: 100 },
  { id: 17, q: 0, r: 1, state: 'built' },
  { id: 18, q: 1, r: 1, state: 'fog', cost: 70, minShrineLevel: 2 },
  { id: 19, q: 2, r: 1, state: 'fog', cost: 90, minShrineLevel: 2 },
  { id: -1, q: -1, r: 2, state: 'fog', cost: 200, minShrineLevel: 4 },
  { id: -2, q: 0, r: 2, state: 'fog', cost: 260, minShrineLevel: 4 },
  { id: -3, q: 1, r: 2, state: 'fog', cost: 320, minShrineLevel: 4 },
];
const HEX_BY_ID = new Map(HEXES.map(tile => [tile.id, tile]));
const STARTING_BUILT_TILE_IDS = new Set(
  HOUSING_TECH.buildings
    .filter(building => building.startsBuilt)
    .flatMap(building => building.runtimeTiles || [building.runtimeAnchorTile])
    .filter(tileId => HEX_BY_ID.has(tileId))
);
const HEX_NEIGHBOR_OFFSETS = [
  [1, 0],
  [-1, 0],
  [0, 1],
  [0, -1],
  [1, -1],
  [-1, 1],
];
const HOME_PATHS = HOUSING_TECH.homePaths || [];
const HOME_PROPS = [
  { kind: 'lantern', x: -90, y: -58 },
  { kind: 'lantern', x: 72, y: 12 },
  { kind: 'crate', x: -130, y: -54 },
  { kind: 'crate', x: 154, y: 40 },
  { kind: 'flag', x: 34, y: -108 },
  { kind: 'shrub', x: -138, y: 98 },
  { kind: 'shrub', x: 20, y: 132 },
  { kind: 'stone', x: -26, y: -104 },
];

const dom = {
  shell: document.getElementById('survivorShell'),
  homeScreen: document.getElementById('homeScreen'),
  resultScreen: document.getElementById('resultScreen'),
  gameStage: document.getElementById('gameStage'),
  bootStatus: document.getElementById('bootStatus'),
  levelText: document.getElementById('levelText'),
  killText: document.getElementById('killText'),
  timeText: document.getElementById('timeText'),
  phaseText: document.getElementById('phaseText'),
  objectiveText: document.getElementById('objectiveText'),
  enemyText: document.getElementById('enemyText'),
  pickupText: document.getElementById('pickupText'),
  hpFill: document.getElementById('hpFill'),
  xpFill: document.getElementById('xpFill'),
  profileSkillList: document.getElementById('profileSkillList'),
  stageTrack: document.getElementById('stageTrack'),
  pauseButton: document.getElementById('pauseButton'),
  restartButton: document.getElementById('restartButton'),
  returnButton: document.getElementById('returnButton'),
  sortieButton: document.getElementById('sortieButton'),
  resultReturnButton: document.getElementById('resultReturnButton'),
  homeBoardWrap: document.getElementById('homeBoardWrap'),
  homeHexGrid: document.getElementById('homeHexGrid'),
  homeBuildingPanel: document.getElementById('homeBuildingPanel'),
  homeGoldText: document.getElementById('homeGoldText'),
  homeSoulText: document.getElementById('homeSoulText'),
  homeWoodText: document.getElementById('homeWoodText'),
  homeStoneText: document.getElementById('homeStoneText'),
  shrineLevelText: document.getElementById('shrineLevelText'),
  residentText: document.getElementById('residentText'),
  lightFill: document.getElementById('lightFill'),
  lightText: document.getElementById('lightText'),
  loopLog: document.getElementById('loopLog'),
  resultTitle: document.getElementById('resultTitle'),
  resultSummary: document.getElementById('resultSummary'),
  resultRewards: document.getElementById('resultRewards'),
  homeResetButton: document.getElementById('homeResetButton'),
  levelModal: document.getElementById('levelModal'),
  levelPanel: document.querySelector('#levelModal .level-panel'),
  levelTitle: document.getElementById('levelTitle'),
  levelSubtitle: document.getElementById('levelSubtitle'),
  runSummary: document.getElementById('runSummary'),
  choiceGrid: document.getElementById('choiceGrid'),
};

const RESOURCE_LEDGER_ROWS = Object.fromEntries(
  [...document.querySelectorAll('.ledger-row')].map(row => [row.dataset.resource, row])
);
const HOME_RESOURCE_ROWS = Object.fromEntries(
  [...document.querySelectorAll('.resource-row[data-home-resource]')].map(row => [row.dataset.homeResource, row])
);

const STATE_RESOURCE_KEYS = {
  gold: 'gold',
  wood: 'wood',
  stone: 'stone',
  soulflame: 'souls',
  lantern: 'light',
  exp: 'exp',
  herb: 'herb',
  tool: 'tool',
};
const HOME_RESOURCE_KEYS = Object.freeze(['gold', 'souls', 'wood', 'stone']);
const HOME_RESOURCE_LABELS = Object.freeze({
  gold: '골드',
  souls: '영혼불',
  wood: '목재',
  stone: '석재',
});
const HOME_RESOURCE_RATE_EFFECTS = Object.freeze({
  gold: [['gold_per_min', 1], ['gold_per_hour', 1 / 60]],
  souls: [['soulflame_per_min', 1], ['soulflame_per_hour', 1 / 60], ['souls_per_min', 1], ['souls_per_hour', 1 / 60]],
  wood: [['wood_per_min', 1], ['wood_per_hour', 1 / 60]],
  stone: [['stone_per_min', 1], ['stone_per_hour', 1 / 60]],
});
const HOME_INCOME_MAX_ELAPSED_MS = 60000;
const HOME_INCOME_ANIMATION_MS = 720;

const HOME_MAP_PAN_LIMIT = { x: 118, y: 132 };
const HOME_MAP_PAN_CLICK_THRESHOLD = 8;

function toHomeBuilding(building) {
  return {
    key: building.key,
    name: building.name,
    level: 1,
    tile: building.runtimeAnchorTile,
    tiles: building.runtimeTiles,
    icon: building.icon,
    output: building.output,
    kind: building.kind,
    sprite: building.spriteKey,
    footprint: building.footprint,
    visual: building.visual,
    base: building.base,
    levels: building.levels || [],
    startsBuilt: building.startsBuilt,
    tier: building.tier,
    role: building.role,
    unlock: building.unlock,
    assetStatus: building.assetStatus,
    effectKind: building.effectKind,
    construction: building.construction,
  };
}

function defaultBuildingLevels() {
  return Object.fromEntries(HOUSING_TECH.buildings.map(building => [building.key, 1]));
}

function defaultBuiltBuildings() {
  return Object.fromEntries(HOUSING_TECH.buildings.map(building => [building.key, Boolean(building.startsBuilt)]));
}

function defaultTileStates() {
  const states = Object.fromEntries(HEXES.map(tile => [tile.id, tile.state || 'fog']));
  for (const tileId of STARTING_BUILT_TILE_IDS) {
    states[tileId] = 'built';
  }
  return states;
}

function normalizeTileStates(rawTileStates = {}) {
  const allowed = new Set(['fog', 'locked', 'empty', 'built']);
  const states = defaultTileStates();
  for (const tile of HEXES) {
    const value = rawTileStates[tile.id];
    if (allowed.has(value)) states[tile.id] = value;
  }
  return states;
}

const createInitialState = () => ({
  tileStateVersion: TILE_STATE_VERSION,
  tileStates: defaultTileStates(),
  shrineLevel: 1,
  buildingLevels: defaultBuildingLevels(),
  builtBuildings: defaultBuiltBuildings(),
  constructionJobs: {},
  selectedBuildingKey: 'lantern_shrine',
  residents: 3,
  light: 34,
  lightNeed: 100,
  clearedTiles: 0,
  gold: 320,
  souls: 38,
  wood: 96,
  stone: 22,
  resourceFractions: Object.fromEntries(HOME_RESOURCE_KEYS.map(key => [key, 0])),
  lastIncomeAt: Date.now(),
  sorties: 0,
  lastLog: '등불 신전 주변의 안개가 조금 걷혔습니다.',
});

function normalizeSanctuaryState(rawState = {}) {
  const base = createInitialState();
  const state = { ...base, ...rawState };
  if (rawState.stone == null && rawState.leaf != null) {
    state.stone = Number(rawState.leaf) || 0;
  }
  state.buildingLevels = { ...base.buildingLevels, ...(rawState.buildingLevels || {}) };
  state.builtBuildings = { ...base.builtBuildings, ...(rawState.builtBuildings || {}) };
  state.constructionJobs = { ...(rawState.constructionJobs || {}) };
  state.tileStates = normalizeTileStates(rawState.tileStates);
  state.tileStateVersion = TILE_STATE_VERSION;
  state.shrineLevel = clamp(Number(state.shrineLevel) || 1, 1, 99);
  state.buildingLevels.lantern_shrine = state.shrineLevel;
  state.builtBuildings.lantern_shrine = true;
  syncBuiltTileStates(state);
  state.clearedTiles = countExpandedTiles(state);
  normalizeHomeIncomeState(state, rawState);
  state.selectedBuildingKey = BUILDING_BY_KEY.has(state.selectedBuildingKey)
    ? state.selectedBuildingKey
    : 'lantern_shrine';
  return state;
}

function normalizeHomeIncomeState(state, rawState = {}) {
  state.resourceFractions = {};
  for (const key of HOME_RESOURCE_KEYS) {
    const value = Number(rawState.resourceFractions?.[key]);
    state.resourceFractions[key] = Number.isFinite(value) ? clamp(value, 0, 0.999999) : 0;
    state[key] = Math.max(0, Number(state[key]) || 0);
  }

  const now = Date.now();
  const lastIncomeAt = Number(rawState.lastIncomeAt);
  state.lastIncomeAt = Number.isFinite(lastIncomeAt) && lastIncomeAt > 0 && lastIncomeAt <= now
    ? lastIncomeAt
    : now;
}

function loadSanctuary() {
  try {
    const parsed = JSON.parse(localStorage.getItem(STORAGE_KEY) || '');
    return normalizeSanctuaryState(parsed);
  } catch {
    return normalizeSanctuaryState();
  }
}

function saveSanctuary(state) {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(state));
}

function getTileState(state, tile) {
  if (!tile) return 'locked';
  return state.tileStates?.[tile.id] || tile.state || 'fog';
}

function setTileState(state, tile, value) {
  if (!tile) return;
  state.tileStates = { ...defaultTileStates(), ...(state.tileStates || {}) };
  state.tileStates[tile.id] = value;
}

function isOpenTileState(value) {
  return value === 'empty' || value === 'built';
}

function isTileOpen(state, tile) {
  return isOpenTileState(getTileState(state, tile));
}

function syncBuiltTileStates(state) {
  state.tileStates = { ...defaultTileStates(), ...(state.tileStates || {}) };
  for (const building of BUILDINGS) {
    if (!state.builtBuildings?.[building.key]) continue;
    for (const tileId of building.tiles || [building.tile]) {
      const tile = HEX_BY_ID.get(tileId);
      if (tile) state.tileStates[tile.id] = 'built';
    }
  }
}

function countExpandedTiles(state) {
  return HEXES.filter(tile => !STARTING_BUILT_TILE_IDS.has(tile.id) && isTileOpen(state, tile)).length;
}

function getShrineEffect(state) {
  const shrine = BUILDING_BY_KEY.get('lantern_shrine');
  return getLevelData(shrine, getBuildingLevel(state, shrine))?.effect || {};
}

function getMaxExpandedTiles(state) {
  const effect = getShrineEffect(state);
  const openLimit = Math.max(STARTING_BUILT_TILE_IDS.size, Number(effect.max_open_tiles || STARTING_BUILT_TILE_IDS.size));
  return Math.max(0, openLimit - STARTING_BUILT_TILE_IDS.size);
}

function isTileLevelUnlocked(state, tile) {
  return getBuildingLevel(state, BUILDING_BY_KEY.get('lantern_shrine')) >= Number(tile.minShrineLevel || 1);
}

function hasOpenNeighbor(state, tile) {
  if (STARTING_BUILT_TILE_IDS.has(tile.id)) return true;
  return HEX_NEIGHBOR_OFFSETS.some(([dq, dr]) => {
    const neighbor = HEXES.find(candidate => candidate.q === tile.q + dq && candidate.r === tile.r + dr);
    return neighbor && isTileOpen(state, neighbor);
  });
}

function getExpandableTiles(state) {
  const expandedCount = countExpandedTiles(state);
  if (expandedCount >= getMaxExpandedTiles(state)) return [];
  return HEXES.filter(tile => {
    if (isTileOpen(state, tile)) return false;
    if (getTileState(state, tile) === 'locked') return false;
    if (!Number(tile.cost)) return false;
    if (!isTileLevelUnlocked(state, tile)) return false;
    if (!hasOpenNeighbor(state, tile)) return false;
    return Number(state.light || 0) >= Number(tile.cost || 0);
  });
}

function getNextExpansionCost(state) {
  const expandedCount = countExpandedTiles(state);
  if (expandedCount >= getMaxExpandedTiles(state)) return null;
  const costs = HEXES
    .filter(tile => {
      if (isTileOpen(state, tile)) return false;
      if (getTileState(state, tile) === 'locked') return false;
      if (!Number(tile.cost)) return false;
      if (!isTileLevelUnlocked(state, tile)) return false;
      if (!hasOpenNeighbor(state, tile)) return false;
      return true;
    })
    .map(tile => Number(tile.cost || 0))
    .filter(Boolean);
  return costs.length ? Math.min(...costs) : null;
}

function getTileRenderState(tile, state) {
  const tileState = getTileState(state, tile);
  if (isOpenTileState(tileState)) return tileState;
  if (tileState === 'locked') return 'locked';
  if (!isTileLevelUnlocked(state, tile)) return 'fog';
  if (getExpandableTiles(state).some(candidate => candidate.id === tile.id)) return 'expand';
  return 'fog';
}

function isBuildingFootprintOpen(state, building) {
  return (building.tiles || [building.tile]).every(tileId => {
    const tile = HEX_BY_ID.get(tileId);
    return tile && isTileOpen(state, tile);
  });
}

function setBuildingFootprintState(state, building, tileState) {
  for (const tileId of building.tiles || [building.tile]) {
    const tile = HEX_BY_ID.get(tileId);
    if (tile) setTileState(state, tile, tileState);
  }
  state.clearedTiles = countExpandedTiles(state);
}

class SurvivorScene extends PhaserRef.Scene {
  constructor() {
    super('SurvivorScene');
    globalThis.__IDLEZ_SURVIVOR_SCENE__ = this;
    document.documentElement.dataset.survivorBootPhase = 'scene-constructed';
    this.store = null;
    this.board = null;
    this.unitViews = new Map();
    this.inputVector = new PhaserRef.Math.Vector2();
    this.touchVector = new PhaserRef.Math.Vector2();
    this.pointerActive = false;
    this.ready = false;
    this.paused = false;
    this.mode = 'boot';
    this.runRewards = [];
    this.runDrops = 0;
    this.runLedger = createRunLedger();
    this.ledgerGainTimers = new Map();
    this.homeIncomeTimers = new Map();
    this.sanctuary = loadSanctuary();
    this.orbiters = [];
    this.lastFrameAt = 0;
    this.stopSkillVfxDemo = null;
    this.stopLevelChoiceDemo = null;
    this.runSkillLevels = new Map();
    this.runSkillReadyTicks = new Map();
    this.levelChoiceOpen = false;
    this.levelChoiceChoices = [];
    this.levelChoiceSource = '';
    this.levelChoiceResumePause = false;
    this.levelChoiceCloseTimer = null;
  }

  preload() {
    document.documentElement.dataset.survivorBootPhase = 'preload';
    if (FAST_VFX_ASSETS) {
      document.documentElement.dataset.survivorAssetMode = VFX_DEMO_MODE ? 'generated-vfx-demo' : 'generated-levelup-demo';
      return;
    }
    this.load.image('player', 'assets/player.png');
    this.load.image('battleGuardianHero', `assets/ninja2/battle/characters/guardian_hero.png?v=${ASSET_VERSION}`);
    this.load.image('battleLeafImp', `assets/ninja2/battle/characters/enemy_leaf_imp.png?v=${ASSET_VERSION}`);
    this.load.image('battleSootSpirit', `assets/ninja2/battle/characters/enemy_soot_spirit.png?v=${ASSET_VERSION}`);
    this.load.image('battleMushroomEnemy', `assets/ninja2/battle/characters/enemy_purple_mushroom.png?v=${ASSET_VERSION}`);
    this.load.image('battleThornBoss', `assets/ninja2/battle/characters/enemy_thorn_boss_full.png?v=${ASSET_VERSION}`);
    this.load.image('coinDrop', `assets/ninja2/ui/topbar/icon_coin.png?v=${ASSET_VERSION}`);
    this.load.image('soulFlame', `assets/ninja2/ui/topbar/icon_soul.png?v=${ASSET_VERSION}`);
    this.load.image('woodCrate', `assets/ninja2/ui/topbar/icon_wood.png?v=${ASSET_VERSION}`);
    this.load.image('stoneDrop', `assets/ninja2/ui/topbar/icon_stone.png?v=${ASSET_VERSION}`);
    this.load.spritesheet(
      HERO_WALK_TEXTURE,
      `assets/ninja2/battle/animations/guardian_hero_walk_3x8.png?v=${ASSET_VERSION}`,
      { frameWidth: HERO_WALK_FRAME.width, frameHeight: HERO_WALK_FRAME.height }
    );
    for (const family of Object.keys(DIRECTIONAL_TEXTURE_FAMILIES)) {
      for (const direction of DIRECTION_NAMES) {
        this.load.image(
          DIRECTIONAL_TEXTURES[family][direction],
          `assets/ninja2/battle/directions/${family}/${direction}.png?v=${ASSET_VERSION}`
        );
      }
    }
  }

  create() {
    document.documentElement.dataset.survivorBootPhase = 'create';
    this.createGeneratedTextures();
    this.createUnitAnimations();
    this.createWorld();
    this.installInput();
    this.bootResources().catch(error => {
      console.error(error);
      dom.bootStatus.textContent = error.message;
      dom.bootStatus.style.display = 'block';
    });
  }

  createUnitAnimations() {
    if (!this.textures.exists(HERO_WALK_TEXTURE)) return;
    HERO_WALK_DIRECTIONS.forEach((direction, row) => {
      const key = HERO_WALK_ANIMS[direction];
      if (this.anims.exists(key)) return;
      this.anims.create({
        key,
        frames: this.anims.generateFrameNumbers(HERO_WALK_TEXTURE, {
          start: row * HERO_WALK_FRAME_COUNT,
          end: row * HERO_WALK_FRAME_COUNT + HERO_WALK_FRAME_COUNT - 1,
        }),
        frameRate: HERO_WALK_FRAME_RATES[direction] || 6,
        repeat: -1,
      });
    });
  }

  async bootResources() {
    document.documentElement.dataset.survivorBootPhase = 'boot-resources';
    dom.bootStatus.textContent = 'Loading trigger resources';
    dom.bootStatus.style.display = 'block';

    this.store = new ResourceStore({ basePath: '../build' });
    await this.store.loadGame(GAME_ID);
    this.board = new IdlezBoard(this.store);
    this.bindBoardEvents(this.board);

    this.ready = true;
    this.setMode('home');
    this.installHomeTicker();
    renderHome(this);
    dom.bootStatus.style.display = 'none';

    globalThis.__IDLEZ_SURVIVOR__ = this;
    globalThis.__IDLEZ_SURVIVOR_BOARD__ = this.board;
    document.documentElement.dataset.survivorReady = 'true';
    document.documentElement.dataset.survivorBootPhase = 'ready';
    document.documentElement.dataset.demoName = 'ninja2-phaser-survivor-loop';
    document.documentElement.dataset.demoRuntime = 'phaser';
    document.documentElement.dataset.demoCombatCore = 'ninja2-board-triggers';
    installSkillVfxContract();

    if (['battle', 'combat', 'expedition'].includes(INITIAL_MODE)) {
      requestAnimationFrame(() => this.startExpedition());
    }
  }

  installHomeTicker() {
    if (this.homeTicker) return;
    this.homeTicker = setInterval(() => {
      if (this.mode !== 'home') {
        this.sanctuary.lastIncomeAt = Date.now();
        return;
      }
      const completed = completeFinishedConstructions(this.sanctuary);
      const income = applyHomeResourceIncome(this.sanctuary);
      if (completed.length || income.changed) saveSanctuary(this.sanctuary);
      renderHome(this, { gains: income.gains, animateGains: true });
    }, 1000);
  }

  bindBoardEvents(board) {
    board.on('unitSpawned', unit => this.ensureUnitView(unit));
    board.on('unitDamaged', event => this.onUnitDamaged(event));
    board.on('unitDied', event => this.onUnitDied(event));
    board.on('skillSpawned', event => this.onSkillSpawned(event));
    board.on('skillFx', event => this.onSkillFx(event));
    board.on('playerLevelChanged', event => this.onPlayerLevelChanged(event));
    board.on('warning', message => console.warn(`[SurvivorTrigger] ${message}`));
    board.on('waveStarted', () => {});
    board.on('waveQueued', () => {});
    board.on('playerDefeated', () => {
      if (!board.gameEnded) board.EndGame({ team: TEAM.ENEMY });
    });
    board.on('gameEnded', event => {
      if (this.mode !== 'expedition') return;
      this.finishExpedition(event);
    });
  }

  setMode(mode) {
    this.mode = mode;
    document.documentElement.dataset.survivorMode = mode;
    document.documentElement.dataset.survivorBattleReady = mode === 'expedition' ? 'true' : 'false';
    dom.bootStatus.style.display = 'none';
    dom.homeScreen?.classList.toggle('is-open', mode === 'home');
    dom.resultScreen?.classList.toggle('is-open', mode === 'result');
    dom.pauseButton.disabled = mode !== 'expedition';
    dom.returnButton.disabled = mode !== 'expedition';
  }

  startExpedition() {
    if (!this.ready || !this.board) return;
    this.setMode('expedition');
    this.paused = false;
    this.runRewards = [];
    this.runDrops = 0;
    this.runLedger = createRunLedger();
    this.runSkillLevels = new Map();
    this.runSkillReadyTicks = new Map();
    this.closeLevelChoice({ restorePause: false, clearDataset: true });
    this.clearLedgerGainAnimations();
    this.lastFrameAt = performance.now();
    this.clearUnitViews();
    this.skillFxLayer?.clear();
    this.stopSkillVfxDemo?.();
    this.stopSkillVfxDemo = null;
    this.stopLevelChoiceDemo?.();
    this.stopLevelChoiceDemo = null;
    this.ensureOrbiters();

    this.board.start(START_MAP_ID, { preserveProgress: false });
    if (this.board.map?.popupArgs) {
      this.board.map.popupArgs.ClientAutoAdvance = false;
    }
    document.documentElement.dataset.survivorGameEnded = 'false';
    document.documentElement.dataset.survivorWinningTeam = '';
    document.documentElement.dataset.survivorKills = '0';
    document.documentElement.dataset.survivorRunSkillCount = '0';
    document.documentElement.dataset.survivorRunSkillAutoCasts = '0';
    document.documentElement.dataset.survivorRunSkillLastAuto = '';

    const player = this.board.playerUnit;
    if (player) {
      player.x = WORLD.centerX;
      player.y = WORLD.centerY;
      player.targetX = player.x;
      player.targetY = player.y;
      player.state = 'combat';
    }

    this.syncUnitViews();
    renderHud(this);
    this.stopSkillVfxDemo = maybeStartSkillVfxDemo(this);
    this.stopLevelChoiceDemo = this.maybeStartLevelChoiceDemo();
  }

  finishExpedition(event) {
    this.paused = true;
    this.stopSkillVfxDemo?.();
    this.stopSkillVfxDemo = null;
    this.stopLevelChoiceDemo?.();
    this.stopLevelChoiceDemo = null;
    this.closeLevelChoice({ restorePause: false, clearDataset: true });
    if (this.board?.autoAdvanceTimer) {
      clearTimeout(this.board.autoAdvanceTimer);
      this.board.autoAdvanceTimer = null;
    }

    const won = event.winningTeam === TEAM.PLAYER;
    const kills = this.board?.getUnitKillCount(0) || 0;
    const elapsed = Math.floor((this.board?.tick || 0) / TICKS_PER_SECOND);
    document.documentElement.dataset.survivorGameEnded = 'true';
    document.documentElement.dataset.survivorWinningTeam = String(event.winningTeam ?? '');
    document.documentElement.dataset.survivorKills = String(kills);
    const rewardSummary = applyExpeditionRewards(this.sanctuary, event.rewards || [], {
      won,
      kills,
      drops: this.runDrops,
      ledger: this.runLedger,
      elapsed,
      store: this.store,
    });
    saveSanctuary(this.sanctuary);
    renderResult(this, rewardSummary);
    this.setMode('result');
  }

  returnHome() {
    if (this.mode === 'expedition') {
      this.finishExpedition({
        winningTeam: TEAM.ENEMY,
        rewards: [],
        map: this.board?.map,
      });
      return;
    }
    this.clearUnitViews();
    this.closeLevelChoice({ restorePause: false, clearDataset: true });
    this.stopLevelChoiceDemo?.();
    this.stopLevelChoiceDemo = null;
    this.board?.reset?.({ preserveProgress: true });
    this.setMode('home');
    renderHome(this);
  }

  restartRun() {
    if (this.mode === 'home') {
      this.sanctuary = createInitialState();
      saveSanctuary(this.sanctuary);
      renderHome(this);
      return;
    }
    this.startExpedition();
  }

  update(_, delta) {
    if (!this.ready || !this.board || this.mode !== 'expedition' || this.paused || this.levelChoiceOpen) return;

    const now = performance.now();
    const wallDelta = this.lastFrameAt ? now - this.lastFrameAt : delta;
    this.lastFrameAt = now;
    const simulationDelta = Math.max(delta || 0, wallDelta || 0);

    this.updatePlayerInput(Math.min(simulationDelta, 120));
    this.stepBoardByWallClock(simulationDelta);
    if (!this.levelChoiceOpen) this.updateRunSkillAutos();
    this.syncUnitViews();
    this.drawExpeditionLight(delta);
    this.updateOrbiters();
    renderHud(this);
  }

  stepBoardByWallClock(deltaMs) {
    let remaining = clamp(deltaMs || 0, 0, 1000);
    if (remaining <= 0) remaining = 16;
    while (remaining > 0 && !this.board.gameEnded && !this.levelChoiceOpen) {
      const chunk = Math.min(remaining, 250);
      this.board.step(chunk);
      remaining -= chunk;
    }
  }

  updatePlayerInput(delta) {
    const player = this.board.playerUnit;
    if (!player?.alive || this.board.gameEnded) return;

    this.inputVector.set(0, 0);
    if (this.keys.left.isDown || this.keys.left2.isDown) this.inputVector.x -= 1;
    if (this.keys.right.isDown || this.keys.right2.isDown) this.inputVector.x += 1;
    if (this.keys.up.isDown || this.keys.up2.isDown) this.inputVector.y -= 1;
    if (this.keys.down.isDown || this.keys.down2.isDown) this.inputVector.y += 1;
    if (this.inputVector.lengthSq() > 0) this.inputVector.normalize();
    if (this.inputVector.lengthSq() === 0 && this.pointerActive) this.inputVector.copy(this.touchVector);

    const speed = 245 + this.sanctuary.shrineLevel * 8;
    const dt = delta / 1000;
    player.x = clamp(player.x + this.inputVector.x * speed * dt, 42, WORLD.width - 42);
    player.y = clamp(player.y + this.inputVector.y * speed * dt, 42, WORLD.height - 42);
    player.targetX = player.x;
    player.targetY = player.y;
    player.state = 'combat';
  }

  ensureUnitView(unit) {
    if (this.unitViews.has(unit.id)) return this.unitViews.get(unit.id);
    const family = textureFamilyForUnit(unit);
    const direction = initialDirectionForUnit(unit);
    const texture = textureForUnit(unit, direction, family, this.textures);
    const walkFrame = walkFrameForUnit(unit, direction, family);
    const sprite = walkFrame == null || !this.textures.exists(HERO_WALK_TEXTURE)
      ? this.add.sprite(unit.x, unit.y, texture)
      : this.add.sprite(unit.x, unit.y, HERO_WALK_TEXTURE, walkFrame);
    sprite.setDepth(unit.team === TEAM.PLAYER ? 40 : 22 + unit.y / 1000);
    sprite.setScale(scaleForUnit(unit));
    sprite.setFlipX(shouldMirrorDirection(unit, direction, family));
    if (unit.team === TEAM.PLAYER) {
      this.cameras.main.startFollow(sprite, true, 0.14, 0.14);
      this.cameras.main.setZoom(1.08);
    }
    const hp = this.add.graphics();
    hp.setDepth(sprite.depth + 1);
    const view = {
      sprite,
      hp,
      baseScale: scaleForUnit(unit),
      family,
      direction,
      lastX: unit.x,
      lastY: unit.y,
    };
    this.unitViews.set(unit.id, view);
    return view;
  }

  syncUnitViews() {
    if (!this.board) return;
    const liveIds = new Set();
    for (const unit of this.board.units.values()) {
      liveIds.add(unit.id);
      const view = this.ensureUnitView(unit);
      const direction = facingDirectionForUnit(unit, view, this.board.playerUnit);
      const walkAnimation = this.textures.exists(HERO_WALK_TEXTURE)
        ? walkAnimationForUnit(unit, direction, view.family)
        : null;
      if (walkAnimation && this.anims.exists(walkAnimation)) {
        if (isUnitMovingForAnimation(unit, view)) {
          view.sprite.play(walkAnimation, true);
        } else {
          view.sprite.anims.stop();
          view.sprite.setTexture(HERO_WALK_TEXTURE, walkFrameIndexForDirection(direction, 0));
        }
      } else {
        if (view.sprite.anims?.isPlaying) view.sprite.anims.stop();
        const texture = textureForUnit(unit, direction, view.family, this.textures);
        if (texture && view.sprite.texture.key !== texture && this.textures.exists(texture)) {
          view.sprite.setTexture(texture);
        }
      }
      view.sprite.setPosition(unit.x, unit.y);
      view.sprite.setVisible(unit.alive);
      view.sprite.setFlipX(shouldMirrorDirection(unit, direction, view.family));
      view.sprite.setDepth(unit.team === TEAM.PLAYER ? 44 : 20 + unit.y / 100);
      view.sprite.setScale(view.baseScale * (walkAnimation ? 1 : 1 + Math.sin(this.time.now / 220 + unit.id) * 0.025));
      view.direction = direction;
      view.lastX = unit.x;
      view.lastY = unit.y;
      drawUnitHp(view.hp, unit);
    }

    for (const [unitId, view] of this.unitViews) {
      if (liveIds.has(unitId)) continue;
      view.sprite.destroy();
      view.hp.destroy();
      this.unitViews.delete(unitId);
    }
  }

  clearUnitViews() {
    for (const view of this.unitViews.values()) {
      view.sprite.destroy();
      view.hp.destroy();
    }
    this.unitViews.clear();
    this.orbiters?.forEach(orbiter => orbiter.destroy());
    this.orbiters = [];
  }

  onUnitDamaged({ unit, damage }) {
    const view = this.ensureUnitView(unit);
    view.sprite.setTint(unit.team === TEAM.PLAYER ? COLORS.red : COLORS.cream);
    this.time.delayedCall(70, () => view.sprite.clearTint());
    if (unit.team === TEAM.PLAYER || Math.random() < 0.22) {
      this.floatText(unit.x, unit.y - 32, formatNumber(damage), unit.team === TEAM.PLAYER ? '#ff6b55' : '#fff7dd');
    }
  }

  onUnitDied({ unit }) {
    const view = this.unitViews.get(unit.id);
    if (!view) return;
    if (unit.team !== TEAM.PLAYER) {
      const drop = this.collectRunResourceDrop();
      this.runDrops += drop.amount;
      this.runLedger[drop.key] = (this.runLedger[drop.key] || 0) + drop.amount;
      this.dropFx(unit.x, unit.y, drop.texture);
      this.pulseLedgerGain(drop.key, drop.amount);
      this.burstFx(unit.x, unit.y);
    }
    this.tweens.add({
      targets: view.sprite,
      alpha: 0,
      scaleX: view.sprite.scaleX * 0.65,
      scaleY: view.sprite.scaleY * 0.65,
      duration: 150,
      onComplete: () => {
        view.sprite.destroy();
        view.hp.destroy();
        this.unitViews.delete(unit.id);
      },
    });
  }

  onSkillSpawned(skill) {
    if (spawnSkillCastFx(this, skill)) return;
    if (!skill.targets?.length) return;
    this.skillFxLayer.lineStyle(5, COLORS.gold, 0.42);
    skill.targets.slice(0, 4).forEach((target, index) => {
      const texture = index % 2 === 0 ? 'lanternShot' : 'slashBlade';
      const blade = this.add.sprite(skill.owner.x, skill.owner.y, texture);
      blade.setDepth(62);
      blade.setRotation(PhaserRef.Math.Angle.Between(skill.owner.x, skill.owner.y, target.x, target.y));
      blade.setScale(texture === 'lanternShot' ? 0.72 : 0.58);
      this.skillFxLayer.lineBetween(skill.owner.x, skill.owner.y, target.x, target.y);
      this.tweens.add({
        targets: blade,
        x: target.x,
        y: target.y,
        scaleX: 1.02,
        scaleY: 1.02,
        duration: 110 + index * 18,
        ease: 'Quad.easeOut',
        onComplete: () => blade.destroy(),
      });
    });
    this.time.delayedCall(70, () => this.skillFxLayer.clear());
  }

  onSkillFx(event) {
    if (spawnSkillTimelineFx(this, event)) return;
    const { skill } = event;
    const target = skill.targets?.[0] || skill.owner;
    const marker = this.add.graphics();
    marker.setDepth(44);
    marker.lineStyle(3, COLORS.cyan, 0.8);
    marker.strokeCircle(target.x, target.y, 52);
    this.tweens.add({
      targets: marker,
      alpha: 0,
      scaleX: 1.45,
      scaleY: 1.45,
      duration: 220,
      onComplete: () => marker.destroy(),
    });
  }

  collectRunResourceDrop() {
    const drop = RUN_RESOURCE_DROPS[PhaserRef.Math.Between(0, RUN_RESOURCE_DROPS.length - 1)];
    return { ...drop };
  }

  pulseLedgerGain(key, amount) {
    const row = RESOURCE_LEDGER_ROWS[key];
    if (!row) return;
    const gain = row.querySelector('.ledger-gain');
    if (gain) gain.textContent = `+${formatNumber(amount)}`;
    const existingTimer = this.ledgerGainTimers?.get(key);
    if (existingTimer) clearTimeout(existingTimer);
    row.classList.remove('is-gaining');
    void row.offsetWidth;
    row.classList.add('is-gaining');
    const timer = setTimeout(() => {
      row.classList.remove('is-gaining');
      this.ledgerGainTimers?.delete(key);
    }, 680);
    this.ledgerGainTimers?.set(key, timer);
  }

  pulseHomeResourceGain(key, amount) {
    const row = HOME_RESOURCE_ROWS[key];
    if (!row) return;
    const gain = row.querySelector('.resource-gain');
    if (gain) gain.textContent = `+${formatNumber(amount)}`;
    const existingTimer = this.homeIncomeTimers?.get(key);
    if (existingTimer) clearTimeout(existingTimer);
    row.classList.remove('is-income-gaining');
    void row.offsetWidth;
    row.classList.add('is-income-gaining');
    const timer = setTimeout(() => {
      row.classList.remove('is-income-gaining');
      this.homeIncomeTimers?.delete(key);
    }, HOME_INCOME_ANIMATION_MS);
    this.homeIncomeTimers?.set(key, timer);
  }

  clearLedgerGainAnimations() {
    for (const timer of this.ledgerGainTimers?.values?.() || []) clearTimeout(timer);
    this.ledgerGainTimers = new Map();
    Object.values(RESOURCE_LEDGER_ROWS).forEach(row => row.classList.remove('is-gaining'));
  }

  dropFx(x, y, texture) {
    const gem = this.add.sprite(x + PhaserRef.Math.Between(-16, 16), y + PhaserRef.Math.Between(-16, 16), texture);
    gem.setDepth(18);
    const scaleByTexture = {
      coinDrop: 0.72,
      soulFlame: 0.72,
      woodCrate: 0.76,
      stoneDrop: 0.72,
    };
    gem.setScale(scaleByTexture[texture] || 0.88);
    this.tweens.add({
      targets: gem,
      y: gem.y - 34,
      alpha: 0,
      duration: 620,
      ease: 'Quad.easeOut',
      onComplete: () => gem.destroy(),
    });
  }

  burstFx(x, y) {
    for (let i = 0; i < 5; i += 1) {
      const spark = this.add.sprite(x, y, i % 2 ? 'hitSpark' : 'soulShard');
      spark.setDepth(58);
      spark.setScale(i % 2 ? 0.7 : 0.46);
      const angle = (Math.PI * 2 * i) / 5 + Math.random() * 0.5;
      this.tweens.add({
        targets: spark,
        x: x + Math.cos(angle) * PhaserRef.Math.Between(26, 58),
        y: y + Math.sin(angle) * PhaserRef.Math.Between(18, 44),
        alpha: 0,
        scaleX: 0.12,
        scaleY: 0.12,
        duration: 360,
        ease: 'Quad.easeOut',
        onComplete: () => spark.destroy(),
      });
    }
  }

  drawExpeditionLight(delta) {
    const player = this.board?.playerUnit;
    this.lightLayer.clear();
    if (!player?.alive) return;
    const pulse = 1 + Math.sin(this.time.now / 260) * 0.035;
    const shrine = BUILDING_BY_KEY.get('lantern_shrine');
    const shrineEffect = getLevelData(shrine, getBuildingLevel(this.sanctuary, shrine))?.effect || {};
    const radius = (140 + (shrineEffect.light_radius || 38) * 1.2) * pulse;
    this.lightLayer.fillStyle(0xffdf70, 0.12);
    this.lightLayer.fillCircle(player.x, player.y, radius);
    this.lightLayer.lineStyle(4, 0xffdf70, 0.28);
    this.lightLayer.strokeCircle(player.x, player.y, radius * 0.72);

  }

  ensureOrbiters() {
    if (this.orbiters?.length) return;
    this.orbiters = Array.from({ length: 3 }, (_, index) => {
      const orbiter = this.add.sprite(WORLD.centerX, WORLD.centerY, index === 0 ? 'lanternOrb' : 'slashBlade');
      orbiter.setDepth(60 + index);
      orbiter.setScale(index === 0 ? 0.72 : 0.42);
      return orbiter;
    });
  }

  updateOrbiters() {
    const player = this.board?.playerUnit;
    if (!player?.alive) return;
    this.ensureOrbiters();
    this.orbiters.forEach((orbiter, index) => {
      const angle = this.time.now / (index === 0 ? 420 : 310) + index * 2.1;
      const radius = index === 0 ? 78 : 105;
      orbiter.setPosition(
        player.x + Math.cos(angle) * radius,
        player.y + Math.sin(angle) * radius * 0.58
      );
      orbiter.setRotation(angle + Math.PI / 2);
    });
  }

  onPlayerLevelChanged(event = {}) {
    if (this.mode !== 'expedition' || this.board?.gameEnded || this.levelChoiceOpen) return;
    const previousLevel = Math.max(1, Number(event.previousLevel || 1));
    const level = Math.max(previousLevel + 1, Number(event.level || previousLevel + 1));
    this.openLevelChoice({ level, source: event.source || 'playerLevel' });
  }

  maybeStartLevelChoiceDemo() {
    if (!LEVEL_CHOICE_DEMO_MODE) return null;
    const timer = globalThis.setTimeout(() => this.openLevelChoiceDemo(), 280);
    return () => globalThis.clearTimeout(timer);
  }

  openLevelChoiceDemo() {
    if (!this.ready) return false;
    if (this.mode !== 'expedition') {
      this.startExpedition();
      return true;
    }
    const level = Math.max(2, Number(this.board?.playerLevel || 1) + 1);
    return this.openLevelChoice({ level, source: 'demo' });
  }

  openLevelChoice({ level = 2, source = 'playerLevel' } = {}) {
    if (!dom.levelModal || !dom.choiceGrid || !this.store || this.mode !== 'expedition') return false;
    if (this.levelChoiceOpen) return false;

    const choices = buildLevelChoiceOptions(this, { level, source });
    if (choices.length === 0) return false;

    if (this.levelChoiceCloseTimer) {
      globalThis.clearTimeout(this.levelChoiceCloseTimer);
      this.levelChoiceCloseTimer = null;
    }

    this.levelChoiceChoices = choices;
    this.levelChoiceSource = source;
    this.levelChoiceResumePause = this.paused;
    this.levelChoiceOpen = true;
    this.paused = true;

    document.documentElement.dataset.survivorLevelChoiceOpen = 'true';
    document.documentElement.dataset.survivorLevelChoiceCount = String(choices.length);
    document.documentElement.dataset.survivorLevelChoiceLevel = String(level);
    document.documentElement.dataset.survivorLevelChoiceSelected = '';
    document.documentElement.dataset.survivorLevelChoiceSource = source;
    globalThis.__NINJA2_LEVEL_CHOICE_DEMO__ = {
      level,
      source,
      choices: choices.map(choice => ({
        skillDataId: choice.skillDataId,
        name: choice.name,
        currentRunLevel: choice.currentRunLevel,
        nextRunLevel: choice.nextRunLevel,
        categoryLabel: choice.categoryLabel,
        statChips: choice.statChips,
      })),
      selected: null,
    };

    renderLevelChoice(this, { level });
    dom.levelModal.classList.add('is-open');
    const firstChoice = dom.choiceGrid.querySelector('.choice');
    firstChoice?.focus?.({ preventScroll: true });
    return true;
  }

  chooseLevelChoice(index) {
    if (!this.levelChoiceOpen) return false;
    const choice = this.levelChoiceChoices[index];
    if (!choice || choice.disabled) return false;

    const skillDataId = Number(choice.skillDataId);
    const nextLevel = Math.min(MAX_RUN_SKILL_LEVEL, (this.runSkillLevels.get(skillDataId) || 0) + 1);
    this.runSkillLevels.set(skillDataId, nextLevel);
    document.documentElement.dataset.survivorRunSkillCount = String(this.runSkillLevels.size);
    document.documentElement.dataset.survivorLevelChoiceSelected = String(skillDataId);
    document.documentElement.dataset.survivorLevelChoiceSelectedLevel = String(nextLevel);

    if (globalThis.__NINJA2_LEVEL_CHOICE_DEMO__) {
      globalThis.__NINJA2_LEVEL_CHOICE_DEMO__.selected = {
        skillDataId,
        name: choice.name,
        runLevel: nextLevel,
      };
    }

    [...dom.choiceGrid.querySelectorAll('.choice')].forEach((card, cardIndex) => {
      const selected = cardIndex === index;
      card.classList.toggle('is-selected', selected);
      card.disabled = !selected;
      card.setAttribute('aria-pressed', selected ? 'true' : 'false');
    });
    const usedSkillId = this.castRunChoiceSkill(skillDataId, { source: 'choice' });
    this.setRunSkillCooldown(skillDataId, usedSkillId ? this.runSkillCooldownTicks(skillDataId) : RUN_SKILL_RETRY_TICKS);
    this.floatCenter(`${choice.name} Lv.${nextLevel}`);

    this.levelChoiceCloseTimer = globalThis.setTimeout(() => {
      this.levelChoiceCloseTimer = null;
      this.closeLevelChoice({ restorePause: true });
      renderHud(this);
    }, 180);
    return true;
  }

  updateRunSkillAutos() {
    if (!this.runSkillLevels.size || !this.board || this.board.gameEnded) return;
    const tick = Number(this.board.tick || 0);
    let autoCasts = 0;

    for (const [skillDataId, level] of [...this.runSkillLevels.entries()].sort((a, b) => a[0] - b[0])) {
      if (level <= 0) continue;
      const readyTick = this.runSkillReadyTicks.get(Number(skillDataId)) || 0;
      if (tick < readyTick) continue;
      const usedSkillId = this.castRunChoiceSkill(skillDataId, { source: 'auto' });
      this.setRunSkillCooldown(
        skillDataId,
        usedSkillId ? this.runSkillCooldownTicks(skillDataId) : RUN_SKILL_RETRY_TICKS
      );
      if (usedSkillId) {
        autoCasts += 1;
        document.documentElement.dataset.survivorRunSkillLastAuto = String(skillDataId);
      }
    }

    if (autoCasts > 0) {
      const previous = Number(document.documentElement.dataset.survivorRunSkillAutoCasts || 0);
      document.documentElement.dataset.survivorRunSkillAutoCasts = String(previous + autoCasts);
    }
  }

  setRunSkillCooldown(skillDataId, ticks) {
    this.runSkillReadyTicks.set(Number(skillDataId), Number(this.board?.tick || 0) + Math.max(1, Math.floor(ticks || RUN_SKILL_RETRY_TICKS)));
  }

  runSkillCooldownTicks(skillDataId) {
    const skill = this.store?.getSkill(skillDataId);
    const player = this.board?.playerUnit;
    const cooldownPercent = (this.board?.getItemStat?.('CooldownPercent') || 0) + (player?.getBuffStat?.('CooldownPercent') || 0);
    const seconds = Math.max(0.35, Number(skill?.cooldown || 1.5) * Math.max(0.25, 1 - cooldownPercent / 100));
    return Math.max(1, Math.round(seconds * TICKS_PER_SECOND));
  }

  castRunChoiceSkill(skillDataId, { source = 'manual' } = {}) {
    const player = this.board?.playerUnit;
    const usedSkillId = this.board?.startSkill?.(player, skillDataId, null, {
      runChoice: true,
      skillLevel: this.runSkillLevels.get(Number(skillDataId)) || 1,
    });
    if (usedSkillId) {
      document.documentElement.dataset.survivorLevelChoiceCast = String(usedSkillId);
      document.documentElement.dataset.survivorRunSkillLastCast = String(usedSkillId);
      document.documentElement.dataset.survivorRunSkillLastCastSource = source;
    }
    return usedSkillId;
  }

  closeLevelChoice({ restorePause = true, clearDataset = false } = {}) {
    if (this.levelChoiceCloseTimer) {
      globalThis.clearTimeout(this.levelChoiceCloseTimer);
      this.levelChoiceCloseTimer = null;
    }

    const wasOpen = this.levelChoiceOpen;
    this.levelChoiceOpen = false;
    this.levelChoiceChoices = [];
    this.levelChoiceSource = '';
    dom.levelModal?.classList.remove('is-open');
    if (dom.choiceGrid) dom.choiceGrid.innerHTML = '';

    document.documentElement.dataset.survivorLevelChoiceOpen = 'false';
    document.documentElement.dataset.survivorLevelChoiceCount = '0';
    if (clearDataset) {
      document.documentElement.dataset.survivorLevelChoiceLevel = '';
      document.documentElement.dataset.survivorLevelChoiceSelected = '';
      document.documentElement.dataset.survivorLevelChoiceSelectedLevel = '';
      document.documentElement.dataset.survivorLevelChoiceSource = '';
    }

    if (wasOpen && restorePause && this.mode === 'expedition' && !this.board?.gameEnded) {
      this.paused = this.levelChoiceResumePause;
      this.lastFrameAt = performance.now();
    }
  }

  togglePause() {
    if (!this.ready || this.mode !== 'expedition' || this.board?.gameEnded || this.levelChoiceOpen) return;
    this.paused = !this.paused;
    dom.pauseButton.textContent = this.paused ? '>' : 'II';
    dom.bootStatus.textContent = this.paused ? 'Paused' : '';
    dom.bootStatus.style.display = this.paused ? 'block' : 'none';
  }

  floatCenter(text) {
    const player = this.board?.playerUnit;
    if (!player) return;
    this.floatText(player.x, player.y - 96, text, '#ffe56f');
  }

  floatText(x, y, text, color) {
    const item = this.add.text(x, y, text, {
      color,
      fontFamily: 'system-ui, sans-serif',
      fontSize: '17px',
      fontStyle: 'bold',
      stroke: '#17241d',
      strokeThickness: 4,
    });
    item.setDepth(70);
    this.tweens.add({
      targets: item,
      y: y - 42,
      alpha: 0,
      duration: 680,
      ease: 'Quad.easeOut',
      onComplete: () => item.destroy(),
    });
  }

  installInput() {
    this.keys = this.input.keyboard.addKeys({
      up: 'W',
      down: 'S',
      left: 'A',
      right: 'D',
      up2: 'UP',
      down2: 'DOWN',
      left2: 'LEFT',
      right2: 'RIGHT',
      pause: 'SPACE',
    });
    this.input.keyboard.on('keydown-SPACE', () => this.togglePause());
    this.input.keyboard.on('keydown-ONE', () => this.chooseLevelChoice(0));
    this.input.keyboard.on('keydown-TWO', () => this.chooseLevelChoice(1));
    this.input.keyboard.on('keydown-THREE', () => this.chooseLevelChoice(2));

    this.input.on('pointerdown', pointer => {
      if (this.levelChoiceOpen) {
        this.pointerActive = false;
        return;
      }
      this.pointerActive = this.mode === 'expedition';
      this.updateTouchVector(pointer);
    });
    this.input.on('pointermove', pointer => {
      if (this.pointerActive) this.updateTouchVector(pointer);
    });
    this.input.on('pointerup', () => {
      this.pointerActive = false;
      this.touchVector.set(0, 0);
    });
  }

  updateTouchVector(pointer) {
    const centerX = this.scale.width / 2;
    const centerY = this.scale.height / 2;
    this.touchVector.set(pointer.x - centerX, pointer.y - centerY);
    if (this.touchVector.lengthSq() > 1) this.touchVector.normalize();
  }

  createWorld() {
    this.cameras.main.setBackgroundColor(0x315b33);
    this.cameras.main.setBounds(0, 0, WORLD.width, WORLD.height);
    this.ground = this.add.graphics();
    this.ground.setDepth(-50);
    this.ground.fillStyle(0x5f8d3d, 1);
    this.ground.fillRect(0, 0, WORLD.width, WORLD.height);

    const rng = new PhaserRef.Math.RandomDataGenerator(['ninja2-lantern-expedition']);
    this.ground.fillStyle(0x243f28, 0.72);
    this.ground.fillRect(0, 0, WORLD.width, 150);
    this.ground.fillRect(0, WORLD.height - 170, WORLD.width, 170);
    this.ground.fillRect(0, 0, 170, WORLD.height);
    this.ground.fillRect(WORLD.width - 190, 0, 190, WORLD.height);
    this.ground.fillStyle(0x6d9442, 0.38);
    this.ground.fillRoundedRect(250, 260, 980, 150, 80);
    this.ground.fillRoundedRect(1340, 760, 1060, 138, 80);
    this.ground.fillStyle(0xb7c861, 0.22);
    this.ground.fillCircle(WORLD.centerX + 120, WORLD.centerY + 140, 560);
    this.ground.lineStyle(10, 0xd1d86b, 0.24);
    this.ground.strokeCircle(WORLD.centerX + 120, WORLD.centerY + 140, 420);
    this.ground.lineStyle(3, 0x244d2e, 0.2);
    for (let x = -400; x < WORLD.width + 400; x += 180) {
      this.ground.lineBetween(x, 0, x + 880, WORLD.height);
    }
    for (let i = 0; i < 190; i += 1) {
      const x = rng.between(0, WORLD.width);
      const y = rng.between(0, WORLD.height);
      const w = rng.between(48, 150);
      const h = rng.between(26, 74);
      this.ground.fillStyle(rng.pick([0x476f31, 0x7fa850, 0x315b33, 0x91bb55]), rng.realInRange(0.2, 0.44));
      this.ground.fillRoundedRect(x, y, w, h, 24);
    }
    for (let i = 0; i < 150; i += 1) {
      this.ground.fillStyle(0x284229, 0.18);
      const x = rng.between(0, WORLD.width);
      const y = rng.between(0, WORLD.height);
      this.ground.fillEllipse(x, y, rng.between(18, 42), rng.between(9, 22));
    }
    for (let i = 0; i < 120; i += 1) {
      const x = rng.between(0, WORLD.width);
      const y = rng.between(0, WORLD.height);
      this.ground.fillStyle(0xe3e59a, 0.5);
      this.ground.fillCircle(x, y, rng.between(3, 7));
      this.ground.fillStyle(0x476f31, 0.42);
      this.ground.fillTriangle(x - 10, y + 10, x, y - 12, x + 10, y + 10);
    }
    for (let i = 0; i < 52; i += 1) {
      const x = rng.between(0, WORLD.width);
      const y = rng.between(0, WORLD.height);
      this.ground.fillStyle(0x8b7150, 0.42);
      this.ground.fillRoundedRect(x, y, rng.between(20, 54), rng.between(10, 24), 8);
    }
    this.drawForestProps(rng);

    this.lightLayer = this.add.graphics();
    this.lightLayer.setDepth(12);
    this.skillFxLayer = this.add.graphics();
    this.skillFxLayer.setDepth(48);
  }

  drawForestProps(rng) {
    for (let i = 0; i < 46; i += 1) {
      const edge = rng.pick(['top', 'bottom', 'left', 'right']);
      const x = edge === 'left'
        ? rng.between(80, 260)
        : edge === 'right'
          ? rng.between(WORLD.width - 280, WORLD.width - 90)
          : rng.between(120, WORLD.width - 120);
      const y = edge === 'top'
        ? rng.between(70, 280)
        : edge === 'bottom'
          ? rng.between(WORLD.height - 300, WORLD.height - 90)
          : rng.between(130, WORLD.height - 130);
      this.ground.lineStyle(rng.between(8, 14), rng.pick([0x234b2d, 0x315b33, 0x426a34]), 0.62);
      this.ground.lineBetween(x, y + rng.between(34, 58), x + rng.between(-18, 18), y - rng.between(44, 82));
      this.ground.fillStyle(0x6f9d48, 0.38);
      this.ground.fillEllipse(x + rng.between(-22, 22), y - rng.between(34, 70), rng.between(34, 70), rng.between(14, 28));
    }

    for (let i = 0; i < 12; i += 1) {
      const x = rng.between(360, WORLD.width - 360);
      const y = rng.between(260, WORLD.height - 260);
      this.ground.fillStyle(0x171f18, 0.32);
      this.ground.fillEllipse(x, y + 18, 54, 14);
      this.ground.fillStyle(0x4c2a16, 0.86);
      this.ground.fillRoundedRect(x - 8, y - 22, 16, 42, 5);
      this.ground.fillStyle(0xffc64a, 0.58);
      this.ground.fillCircle(x, y - 28, 16);
      this.ground.fillStyle(0xfff1a2, 0.8);
      this.ground.fillCircle(x, y - 28, 7);
    }
  }

  createGeneratedTextures() {
    this.makeGuardianTexture();
    this.makeLeafImpTexture();
    this.makeSootTexture();
    this.makeThornBushTexture();
    this.makeMushroomTexture();
    this.makeThornBossTexture();
    this.makeDropTextures();
  }

  makeGuardianTexture() {
    const g = this.make.graphics({ add: false });
    g.fillStyle(0x18241d, 0.22);
    g.fillEllipse(48, 92, 70, 18);
    g.fillStyle(0x17241d, 1);
    g.fillRoundedRect(20, 24, 56, 72, 16);
    g.fillStyle(0x6b3f28, 1);
    g.fillCircle(48, 30, 28);
    g.fillStyle(0xf4c28e, 1);
    g.fillCircle(48, 38, 21);
    g.fillStyle(0x6b3f28, 1);
    g.fillTriangle(22, 27, 44, 2, 39, 36);
    g.fillTriangle(41, 9, 73, 19, 58, 38);
    g.fillStyle(0xd95740, 1);
    g.fillCircle(55, 29, 4);
    g.lineStyle(3, 0x9b2d2b, 1);
    g.lineBetween(50, 24, 61, 36);
    g.fillStyle(0x16241e, 1);
    g.fillCircle(40, 39, 3);
    g.fillCircle(56, 39, 3);
    g.fillStyle(0x31533b, 1);
    g.fillRoundedRect(22, 58, 56, 35, 9);
    g.fillStyle(0x1f392a, 1);
    g.fillRect(22, 58, 28, 18);
    g.fillStyle(0xdfe7bf, 1);
    g.fillRect(50, 58, 28, 18);
    g.fillStyle(0xe75a3d, 1);
    g.fillRect(25, 55, 50, 8);
    g.fillStyle(0xffdd62, 1);
    g.fillCircle(78, 76, 10);
    g.lineStyle(5, 0x17241d, 1);
    g.strokeCircle(48, 38, 22);
    g.strokeRoundedRect(22, 58, 56, 35, 9);
    g.strokeCircle(78, 76, 10);
    g.generateTexture('guardian', 100, 112);
    g.destroy();
  }

  makeLeafImpTexture() {
    const g = this.make.graphics({ add: false });
    g.fillStyle(0x18241d, 0.22);
    g.fillEllipse(42, 70, 64, 15);
    g.fillStyle(0xf4e6b1, 1);
    g.fillTriangle(20, 22, 29, 2, 39, 26);
    g.fillTriangle(64, 22, 55, 2, 45, 26);
    g.fillStyle(0xe84f43, 1);
    g.fillRoundedRect(14, 24, 56, 42, 17);
    g.fillStyle(0xffd180, 1);
    g.fillCircle(31, 42, 5);
    g.fillCircle(53, 42, 5);
    g.fillStyle(0x17241d, 1);
    g.fillCircle(31, 42, 2);
    g.fillCircle(53, 42, 2);
    g.fillRoundedRect(34, 54, 16, 4, 2);
    g.lineStyle(5, 0x17241d, 1);
    g.strokeRoundedRect(14, 24, 56, 42, 17);
    g.strokeTriangle(20, 22, 29, 2, 39, 26);
    g.strokeTriangle(64, 22, 55, 2, 45, 26);
    g.generateTexture('leafImp', 84, 82);
    g.destroy();
  }

  makeSootTexture() {
    const g = this.make.graphics({ add: false });
    g.fillStyle(0x18241d, 0.2);
    g.fillEllipse(30, 55, 42, 12);
    g.fillStyle(0x1f2825, 1);
    g.fillCircle(30, 32, 24);
    g.fillStyle(0x9aff6a, 1);
    g.fillCircle(22, 30, 4);
    g.fillCircle(38, 30, 4);
    g.lineStyle(4, 0x0e1712, 1);
    g.strokeCircle(30, 32, 24);
    g.generateTexture('sootSpirit', 64, 64);
    g.destroy();
  }

  makeThornBushTexture() {
    const g = this.make.graphics({ add: false });
    g.fillStyle(0x18241d, 0.22);
    g.fillEllipse(44, 70, 70, 16);
    g.fillStyle(0x476f31, 1);
    g.fillCircle(44, 41, 30);
    g.fillStyle(0x86a85a, 1);
    for (let i = 0; i < 9; i += 1) {
      const a = (Math.PI * 2 * i) / 9;
      g.fillTriangle(
        44 + Math.cos(a) * 20,
        41 + Math.sin(a) * 20,
        44 + Math.cos(a + 0.2) * 39,
        41 + Math.sin(a + 0.2) * 34,
        44 + Math.cos(a - 0.2) * 39,
        41 + Math.sin(a - 0.2) * 34
      );
    }
    g.fillStyle(0xffd66d, 1);
    g.fillCircle(35, 40, 4);
    g.fillCircle(53, 40, 4);
    g.lineStyle(5, 0x171f18, 1);
    g.strokeCircle(44, 41, 30);
    g.generateTexture('thornBush', 88, 84);
    g.destroy();
  }

  makeMushroomTexture() {
    const g = this.make.graphics({ add: false });
    g.fillStyle(0x18241d, 0.22);
    g.fillEllipse(36, 68, 54, 14);
    g.fillStyle(0xf0d2a6, 1);
    g.fillRoundedRect(24, 36, 24, 28, 10);
    g.fillStyle(0x8d64b0, 1);
    g.fillEllipse(36, 33, 58, 34);
    g.fillStyle(0xf8ead1, 1);
    g.fillCircle(24, 29, 5);
    g.fillCircle(44, 22, 4);
    g.fillCircle(51, 34, 4);
    g.fillStyle(0x171f18, 1);
    g.fillCircle(31, 47, 2);
    g.fillCircle(41, 47, 2);
    g.lineStyle(5, 0x171f18, 1);
    g.strokeEllipse(36, 33, 58, 34);
    g.strokeRoundedRect(24, 36, 24, 28, 10);
    g.generateTexture('mushroomEnemy', 76, 80);
    g.destroy();
  }

  makeThornBossTexture() {
    const g = this.make.graphics({ add: false });
    g.fillStyle(0x18241d, 0.2);
    g.fillEllipse(60, 92, 88, 22);
    g.fillStyle(0x41543f, 1);
    g.fillCircle(60, 56, 46);
    g.fillStyle(0xd8d8d8, 1);
    for (let i = 0; i < 8; i += 1) {
      const a = i * Math.PI / 4;
      g.fillTriangle(
        60 + Math.cos(a) * 38,
        56 + Math.sin(a) * 38,
        60 + Math.cos(a + 0.15) * 62,
        56 + Math.sin(a + 0.15) * 62,
        60 + Math.cos(a - 0.15) * 62,
        56 + Math.sin(a - 0.15) * 62
      );
    }
    g.fillStyle(0x18241d, 0.18);
    g.fillCircle(49, 44, 7);
    g.fillCircle(73, 44, 7);
    g.lineStyle(5, 0x17241d, 1);
    g.strokeCircle(60, 56, 46);
    g.generateTexture('thornBoss', 124, 116);
    g.destroy();
  }

  makeDropTextures() {
    const blade = this.make.graphics({ add: false });
    blade.fillStyle(0xfff2b0, 1);
    blade.fillTriangle(4, 18, 54, 4, 44, 24);
    blade.fillStyle(0xff7048, 1);
    blade.fillTriangle(0, 21, 22, 14, 19, 28);
    blade.lineStyle(4, 0x17241d, 1);
    blade.strokeTriangle(4, 18, 54, 4, 44, 24);
    blade.generateTexture('slashBlade', 62, 34);
    blade.destroy();

    const lantern = this.make.graphics({ add: false });
    lantern.fillStyle(0xffe36a, 0.34);
    lantern.fillCircle(24, 24, 24);
    lantern.fillStyle(0xffc13c, 1);
    lantern.fillRoundedRect(10, 12, 28, 34, 9);
    lantern.fillStyle(0xfff1a2, 1);
    lantern.fillCircle(24, 29, 10);
    lantern.lineStyle(4, 0x17241d, 1);
    lantern.strokeRoundedRect(10, 12, 28, 34, 9);
    lantern.generateTexture('lanternOrb', 52, 56);
    lantern.destroy();

    const shot = this.make.graphics({ add: false });
    shot.fillStyle(0xffc64a, 0.35);
    shot.fillEllipse(30, 16, 58, 18);
    shot.fillStyle(0xffd66d, 1);
    shot.fillRoundedRect(16, 7, 30, 18, 9);
    shot.fillStyle(0xfff1a2, 1);
    shot.fillCircle(30, 16, 7);
    shot.lineStyle(4, 0x6d4418, 1);
    shot.strokeRoundedRect(16, 7, 30, 18, 9);
    shot.generateTexture('lanternShot', 64, 34);
    shot.destroy();

    const spark = this.make.graphics({ add: false });
    spark.fillStyle(0xfff1a2, 1);
    spark.fillCircle(12, 12, 9);
    spark.lineStyle(4, 0xff6b55, 1);
    spark.lineBetween(12, 0, 12, 24);
    spark.lineBetween(0, 12, 24, 12);
    spark.generateTexture('hitSpark', 28, 28);
    spark.destroy();

    const exp = this.make.graphics({ add: false });
    exp.fillStyle(0x39a8ff, 1);
    exp.beginPath();
    exp.moveTo(16, 0);
    exp.lineTo(32, 18);
    exp.lineTo(16, 38);
    exp.lineTo(0, 18);
    exp.closePath();
    exp.fillPath();
    exp.fillStyle(0xb7ecff, 0.8);
    exp.fillTriangle(16, 5, 24, 18, 16, 16);
    exp.lineStyle(4, 0x17415c, 1);
    exp.strokePath();
    exp.generateTexture('expGem', 36, 42);
    exp.destroy();

    if (!this.textures.exists('coinDrop')) {
      const coin = this.make.graphics({ add: false });
      coin.fillStyle(0xffc64a, 1);
      coin.fillCircle(18, 18, 15);
      coin.fillStyle(0xffe58a, 1);
      coin.fillCircle(14, 13, 5);
      coin.lineStyle(4, 0x6d4418, 1);
      coin.strokeCircle(18, 18, 15);
      coin.generateTexture('coinDrop', 40, 40);
      coin.destroy();
    }

    if (!this.textures.exists('soulFlame')) {
      const flame = this.make.graphics({ add: false });
      flame.fillStyle(0x36e0d4, 0.95);
      flame.fillCircle(18, 28, 16);
      flame.fillTriangle(5, 25, 18, 2, 31, 25);
      flame.fillTriangle(9, 38, 18, 50, 27, 38);
      flame.fillStyle(0xb9fff4, 0.9);
      flame.fillCircle(18, 29, 8);
      flame.lineStyle(4, 0x126a65, 1);
      flame.strokeCircle(18, 28, 16);
      flame.generateTexture('soulFlame', 42, 52);
      flame.destroy();
    }

    if (!this.textures.exists('woodCrate')) {
      const crate = this.make.graphics({ add: false });
      crate.fillStyle(0xa96a32, 1);
      crate.fillRoundedRect(4, 10, 38, 30, 6);
      crate.fillStyle(0xc88745, 1);
      crate.fillRect(8, 14, 30, 7);
      crate.lineStyle(4, 0x4c2a16, 1);
      crate.strokeRoundedRect(4, 10, 38, 30, 6);
      crate.lineBetween(23, 11, 23, 39);
      crate.generateTexture('woodCrate', 48, 48);
      crate.destroy();
    }

    if (!this.textures.exists('stoneDrop')) {
      const stone = this.make.graphics({ add: false });
      stone.fillStyle(0xd8d8c2, 1);
      stone.fillRoundedRect(7, 12, 28, 22, 8);
      stone.fillStyle(0xf8ead1, 0.5);
      stone.fillRoundedRect(12, 15, 10, 6, 3);
      stone.lineStyle(4, 0x5f665d, 1);
      stone.strokeRoundedRect(7, 12, 28, 22, 8);
      stone.generateTexture('stoneDrop', 44, 44);
      stone.destroy();
    }

    const soul = this.make.graphics({ add: false });
    soul.fillStyle(COLORS.cyan, 1);
    soul.beginPath();
    soul.moveTo(12, 0);
    soul.lineTo(24, 14);
    soul.lineTo(12, 28);
    soul.lineTo(0, 14);
    soul.closePath();
    soul.fillPath();
    soul.lineStyle(3, 0x105766, 1);
    soul.strokePath();
    soul.generateTexture('soulShard', 28, 32);
    soul.destroy();

    const wood = this.make.graphics({ add: false });
    wood.fillStyle(COLORS.wood, 1);
    wood.fillRoundedRect(4, 9, 26, 11, 5);
    wood.fillRoundedRect(12, 2, 26, 11, 5);
    wood.lineStyle(3, 0x4c2a16, 1);
    wood.strokeRoundedRect(4, 9, 26, 11, 5);
    wood.strokeRoundedRect(12, 2, 26, 11, 5);
    wood.generateTexture('woodDrop', 44, 28);
    wood.destroy();
  }
}

function renderHud(scene) {
  const board = scene.board;
  if (!board || scene.mode !== 'expedition') return;

  const player = board.playerUnit;
  const enemies = [...board.units.values()].filter(unit => unit.alive && unit.team !== TEAM.PLAYER);
  const elapsed = board.tick / TICKS_PER_SECOND;
  const kills = board.getUnitKillCount(0);
  const exp = board.exp;
  const expNeed = 40 + board.playerLevel * 18;
  const wave = Math.max(1, board.wave || 1);
  const waveSpawned = Math.max(1, Math.floor(board.getBoardVariable(604)) || (wave === 3 ? 15 : 18));
  const waveProgress = clamp((waveSpawned - enemies.length) / waveSpawned, 0, 1);
  const stageProgress = clamp((wave - 1 + waveProgress) / 3, 0, 1);

  document.documentElement.dataset.survivorTick = String(board.tick);
  document.documentElement.dataset.survivorUnitCount = String(board.units.size);
  document.documentElement.dataset.survivorEnemyCount = String(enemies.length);
  document.documentElement.dataset.survivorPickupCount = String(scene.runDrops);
  document.documentElement.dataset.survivorKills = String(kills);
  document.documentElement.dataset.survivorPlayerX = String(Math.round(player?.x || 0));
  document.documentElement.dataset.survivorPlayerY = String(Math.round(player?.y || 0));
  document.documentElement.dataset.survivorMode = scene.mode;
  document.documentElement.dataset.survivorGameId = GAME_ID;
  document.documentElement.dataset.survivorMapId = String(board.map?.id || '');
  document.documentElement.dataset.survivorTriggers = (board.map?.triggers || []).join(',');
  document.documentElement.dataset.survivorStageProgress = stageProgress.toFixed(3);

  dom.levelText.textContent = String(board.playerLevel);
  dom.killText.textContent = String(kills);
  dom.timeText.textContent = formatTime(elapsed);
  dom.phaseText.textContent = board.gameEnded ? 'Return' : `Stage ${wave}`;
  dom.objectiveText.textContent = wave >= 3 ? '두령 출현' : '대나무 숲 정화';
  dom.enemyText.textContent = String(enemies.length);
  dom.pickupText.textContent = String(scene.runDrops);
  dom.hpFill.style.width = `${player ? clamp((player.hp / player.maxHp) * 100, 0, 100).toFixed(1) : 0}%`;
  dom.xpFill.style.width = `${clamp((exp % expNeed) / expNeed * 100, 0, 100).toFixed(1)}%`;
  renderResourceLedger(scene.runLedger);

  const segments = [...dom.stageTrack.querySelectorAll('i')];
  const activeSegments = clamp(Math.ceil(stageProgress * segments.length), 1, segments.length);
  segments.forEach((segment, index) => {
    segment.classList.toggle('is-active', index < activeSegments);
  });

  renderProfileSkillList(scene);
}

function renderProfileSkillList(scene) {
  if (!dom.profileSkillList) return;
  const runSlots = scene?.runSkillLevels?.size
    ? [...scene.runSkillLevels.entries()]
      .sort((a, b) => a[0] - b[0])
      .slice(0, 3)
      .map(([skillDataId, level]) => toProfileRunSkillSlot(scene, skillDataId, level))
      .filter(Boolean)
    : [];
  const rows = {
    active: runSlots.length ? runSlots : RUN_PROFILE_SKILL_ROWS.active,
    passive: RUN_PROFILE_SKILL_ROWS.passive,
  };

  dom.profileSkillList.innerHTML = Object.entries(rows).map(([kind, slots]) => `
    <div class="profile-skill-row profile-skill-row-${kind}" data-kind="${kind}">
      ${slots.map(slot => `
        <span class="profile-skill-icon" style="--skill-color:${escapeHtml(slot.color)}" title="${escapeHtml(slot.name)}" aria-label="${escapeHtml(slot.name)}">
          ${profileSkillIconHtml(slot)}<em>${slot.level ? `Lv.${slot.level}` : ''}</em>
        </span>
      `).join('')}
    </div>
  `).join('');
}

function toProfileRunSkillSlot(scene, skillDataId, level) {
  const skill = scene.store?.getSkill(skillDataId);
  const profile = getSkillVfxProfile(skillDataId);
  const familyMeta = SKILL_FAMILY_LABELS[profile?.family] || { icon: '術' };
  if (!skill && !profile) return null;
  return {
    id: Number(skillDataId),
    name: `${skill?.name || profile?.name || skillDataId} Lv.${level}`,
    icon: familyMeta.icon,
    iconSrc: skillIconSrcFor(skill, skillDataId),
    color: colorToHex(profile?.color || COLORS.gold),
    level,
  };
}

function buildLevelChoiceOptions(scene, { level = 2, source = 'playerLevel' } = {}) {
  const skillIds = source === 'demo'
    ? LEVEL_CHOICE_DEMO_IDS
    : chooseRunSkillIds(scene, level);

  return skillIds
    .map(skillDataId => toLevelChoice(scene, skillDataId))
    .filter(Boolean)
    .slice(0, 3);
}

function chooseRunSkillIds(scene, level = 2) {
  const availableIds = RUN_LEVEL_CHOICE_SKILL_IDS.filter(skillDataId => {
    const skill = scene.store?.getSkill(skillDataId);
    return skill && (scene.runSkillLevels.get(Number(skillDataId)) || 0) < MAX_RUN_SKILL_LEVEL;
  });
  const offset = (Number(scene.board?.tick || 0) + Number(level || 1) * 7) % Math.max(1, availableIds.length);
  const unowned = availableIds.filter(skillDataId => !scene.runSkillLevels.has(Number(skillDataId)));
  const upgrades = availableIds.filter(skillDataId => scene.runSkillLevels.has(Number(skillDataId)));
  return [...rotateList(unowned, offset), ...rotateList(upgrades, offset)].slice(0, 3);
}

function toLevelChoice(scene, skillDataId) {
  const skill = scene.store?.getSkill(skillDataId);
  if (!skill) return null;

  const id = Number(skill.id || skillDataId);
  const currentRunLevel = clamp(scene.runSkillLevels.get(id) || 0, 0, MAX_RUN_SKILL_LEVEL);
  if (currentRunLevel >= MAX_RUN_SKILL_LEVEL) return null;

  const nextRunLevel = Math.min(MAX_RUN_SKILL_LEVEL, currentRunLevel + 1);
  const profile = getSkillVfxProfile(id);
  const familyMeta = SKILL_FAMILY_LABELS[profile?.family] || {
    icon: skill.damageType ? String(skill.damageType).slice(0, 1) : '術',
    label: skill.damageType || '스킬',
  };

  return {
    skillDataId: id,
    name: skill.name || profile?.name || `Skill ${id}`,
    currentRunLevel,
    nextRunLevel,
    iconFamily: profile?.family || skill.damageType || 'skill',
    icon: familyMeta.icon,
    iconSrc: skillIconSrcFor(skill, id),
    color: colorToHex(profile?.color || COLORS.gold),
    accent: colorToHex(profile?.accent || COLORS.soul),
    categoryLabel: familyMeta.label,
    badgeLabel: currentRunLevel === 0 ? 'NEW' : `Lv.${nextRunLevel}`,
    effectSummary: SKILL_CHOICE_COPY[id] || formatFallbackSkillSummary(skill),
    statChips: formatLevelChoiceStatChips(scene, skill, nextRunLevel, profile),
  };
}

function renderLevelChoice(scene, { level = 2 } = {}) {
  const kills = scene.board?.getUnitKillCount?.(0) || 0;
  const elapsed = Math.floor((scene.board?.tick || 0) / TICKS_PER_SECOND);
  dom.levelTitle.textContent = '레벨 업!';
  dom.levelSubtitle.textContent = '이번 원정에서 성장할 스킬을 선택하세요';
  dom.runSummary.textContent = `Lv.${level} · ${formatNumber(kills)} 처치 · ${formatTime(elapsed)}`;
  dom.choiceGrid.innerHTML = scene.levelChoiceChoices
    .map((choice, index) => renderLevelChoiceCard(choice, index))
    .join('');

  [...dom.choiceGrid.querySelectorAll('.choice')].forEach(card => {
    card.addEventListener('click', () => scene.chooseLevelChoice(Number(card.dataset.choiceIndex)));
  });
}

function renderLevelChoiceCard(choice, index) {
  const levelPips = Array.from({ length: MAX_RUN_SKILL_LEVEL }, (_, pipIndex) => `
    <i class="${pipIndex < choice.nextRunLevel ? 'is-filled' : ''}" aria-hidden="true"></i>
  `).join('');
  const chips = choice.statChips.map(chip => `<span class="choice-chip">${escapeHtml(chip)}</span>`).join('');
  const label = `${choice.name} ${choice.nextRunLevel}레벨 선택`;

  return `
    <button
      class="choice ${choice.currentRunLevel === 0 ? 'is-new' : 'is-upgrade'}"
      type="button"
      data-choice-index="${index}"
      style="--choice-color:${choice.color};--choice-accent:${choice.accent}"
      aria-label="${escapeHtml(label)}"
      aria-pressed="false"
    >
      <span class="choice-badge">${escapeHtml(choice.badgeLabel)}</span>
      <span class="choice-icon" aria-hidden="true">${choiceIconHtml(choice)}</span>
      <span class="choice-name">${escapeHtml(choice.name)}</span>
      <span class="choice-pips" aria-label="선택 후 ${choice.nextRunLevel}레벨">${levelPips}</span>
      <span class="choice-desc">${escapeHtml(choice.effectSummary)}</span>
      <span class="choice-chips">${chips}</span>
      <span class="choice-category">${escapeHtml(choice.categoryLabel)}</span>
    </button>
  `;
}

function formatLevelChoiceStatChips(scene, skill, level, profile) {
  const chips = [];
  const damagePercent = firstAttackDamagePercent(skill, level);
  const buffChip = firstBuffChip(scene, skill, level);
  const cooldown = Number(skill.cooldown || 0);
  const maxHit = firstMaxHit(skill) || profile?.maxTargets || 0;

  if (damagePercent > 0) chips.push(`피해 ${Math.round(damagePercent * 100)}%`);
  if (buffChip) chips.push(buffChip);
  if (chips.length < 2 && cooldown > 0) chips.push(`쿨 ${cooldown.toFixed(1)}초`);
  if (chips.length < 2 && maxHit > 1) chips.push(`대상 ${maxHit}`);

  return chips.slice(0, 2);
}

function firstAttackDamagePercent(skill, level = 1) {
  for (const timeline of skill.timelines || []) {
    const values = timeline.hit?.addDamage?.attackPercentDamages;
    if (Array.isArray(values) && values.length > 0) {
      return Number(levelValue(values, level, values[0])) || 0;
    }
  }
  return 0;
}

function firstMaxHit(skill) {
  for (const timeline of skill.timelines || []) {
    const maxHit = Number(timeline.hit?.maxHit || 0);
    if (maxHit > 0) return maxHit;
  }
  return 0;
}

function firstBuffChip(scene, skill, level = 1) {
  const buffRefs = [
    ...(skill.selfAddBuffs || []),
    ...(skill.addBuffs || []),
    ...(skill.timelines || []).flatMap(timeline => timeline.hit?.addBuffs || []),
  ];
  const buffRef = buffRefs.find(ref => ref?.buffDataId);
  const buff = scene.store?.getBuff(buffRef?.buffDataId);
  const stat = buff?.addStats?.[0];
  if (!stat) {
    return buffRef?.duration ? `지속 ${Number(buffRef.duration).toFixed(1)}초` : '';
  }

  const label = STAT_LABELS[stat.type] || stat.type;
  const value = Number(levelValue(stat.value, level, stat.value));
  const formatted = Math.abs(value) >= 10 || String(stat.type).includes('Percent')
    ? `${value > 0 ? '+' : ''}${Math.round(value)}%`
    : `${value > 0 ? '+' : ''}${value.toFixed(2).replace(/0+$/, '').replace(/\.$/, '')}`;
  return `${label} ${formatted}`;
}

function levelValue(value, level = 1, fallback = 0) {
  if (Array.isArray(value)) {
    return value[clamp(level - 1, 0, value.length - 1)] ?? fallback;
  }
  return value ?? fallback;
}

function formatFallbackSkillSummary(skill) {
  if (skill.selfAddBuffs?.length) return '자신에게 전투 버프를 부여합니다.';
  if ((skill.timelines || []).some(timeline => timeline.hit?.addBuffs?.length)) return '타격한 적에게 약화 효과를 남깁니다.';
  if ((skill.timelines || []).some(timeline => timeline.hit)) return '범위 안의 적에게 피해를 줍니다.';
  return '이번 원정 동안 전투 능력을 강화합니다.';
}

function colorToHex(color) {
  if (typeof color === 'string' && color.startsWith('#')) return color;
  const numeric = Number(color || 0);
  return `#${numeric.toString(16).padStart(6, '0').slice(-6)}`;
}

function choiceIconHtml(choice) {
  if (choice.iconSrc) {
    return `<img class="choice-icon-img" src="${escapeHtml(choice.iconSrc)}" alt="" loading="eager" decoding="async">`;
  }
  return escapeHtml(choice.icon);
}

function profileSkillIconHtml(slot) {
  const src = slot.iconSrc || assetUrlFromSpritePath(slot.sprite);
  if (src) {
    return `<img class="profile-skill-img" src="${escapeHtml(src)}" alt="" loading="eager" decoding="async">`;
  }
  return escapeHtml(slot.icon);
}

function skillIconSrcFor(skill, skillDataId) {
  return assetUrlFromSpritePath(skill?.sprite || skill?.Sprite || SKILL_ICON_PATHS[Number(skillDataId)]);
}

function assetUrlFromSpritePath(spritePath) {
  const path = String(spritePath || '').trim();
  if (!path) return '';
  if (/^(?:https?:|data:|\.\/|\/)/.test(path)) return path;
  if (path.startsWith('assets/')) return `./${path}?v=${ASSET_VERSION}`;
  return `./assets/${path}?v=${ASSET_VERSION}`;
}

function rotateList(list, offset = 0) {
  if (!list.length) return [];
  const start = Math.abs(Math.floor(offset)) % list.length;
  return [...list.slice(start), ...list.slice(0, start)];
}

function escapeHtml(value) {
  return String(value ?? '')
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&#039;');
}

function createRunLedger() {
  return { wood: 0, stone: 0, souls: 0, gold: 0 };
}

function renderResourceLedger(ledger = createRunLedger()) {
  for (const [key, row] of Object.entries(RESOURCE_LEDGER_ROWS)) {
    const value = row.querySelector('.ledger-value');
    if (value) value.textContent = formatNumber(ledger[key] || 0);
  }
}

function getHomeResourceRatesPerMinute(state) {
  const rates = Object.fromEntries(HOME_RESOURCE_KEYS.map(key => [key, 0]));
  let productionPercent = 0;

  for (const building of BUILDINGS) {
    if (!isBuildingBuilt(state, building)) continue;
    const effect = getLevelData(building, getBuildingLevel(state, building))?.effect || {};
    productionPercent += Number(effect.all_production_percent || 0);
    for (const key of HOME_RESOURCE_KEYS) {
      for (const [effectKey, multiplier] of HOME_RESOURCE_RATE_EFFECTS[key] || []) {
        rates[key] += Number(effect[effectKey] || 0) * multiplier;
      }
    }
  }

  const multiplier = Math.max(0, 1 + productionPercent / 100);
  for (const key of HOME_RESOURCE_KEYS) {
    rates[key] = Math.max(0, rates[key] * multiplier);
  }
  return rates;
}

function applyHomeResourceIncome(state, now = Date.now()) {
  const rates = getHomeResourceRatesPerMinute(state);
  const lastIncomeAt = Number(state.lastIncomeAt) || now;
  const elapsedMs = clamp(now - lastIncomeAt, 0, HOME_INCOME_MAX_ELAPSED_MS);
  state.lastIncomeAt = now;
  state.resourceFractions = { ...(state.resourceFractions || {}) };

  const gains = {};
  let changed = false;
  for (const key of HOME_RESOURCE_KEYS) {
    const rate = Number(rates[key] || 0);
    if (rate <= 0 || elapsedMs <= 0) {
      state.resourceFractions[key] = Number(state.resourceFractions[key] || 0);
      continue;
    }

    const accumulated = Number(state.resourceFractions[key] || 0) + rate * elapsedMs / 60000;
    const whole = Math.floor(accumulated);
    state.resourceFractions[key] = accumulated - whole;
    changed = true;
    if (whole <= 0) continue;

    state[key] = Math.max(0, Number(state[key] || 0) + whole);
    gains[key] = whole;
  }

  return { rates, gains, changed };
}

function renderHomeResourceRows(state, rates) {
  for (const key of HOME_RESOURCE_KEYS) {
    const row = HOME_RESOURCE_ROWS[key];
    if (!row) continue;
    const amount = Number(state[key] || 0);
    const rate = Number(rates[key] || 0);
    const value = row.querySelector('b');
    const rateText = row.querySelector('.resource-rate');
    if (value) value.textContent = formatNumber(amount);
    if (rateText) rateText.textContent = formatHomeRate(rate);
    row.classList.toggle('is-income-idle', rate <= 0);
    row.setAttribute('aria-label', `${HOME_RESOURCE_LABELS[key]} ${formatNumber(amount)} · 분당 ${formatHomeRate(rate)}`);
  }
}

function formatHomeRate(rate) {
  const safe = Math.max(0, Number(rate) || 0);
  if (safe <= 0) return '+0/m';
  if (safe < 1) return `+${safe.toFixed(2).replace(/0+$/, '').replace(/\.$/, '')}/m`;
  if (safe < 10 && !Number.isInteger(safe)) return `+${safe.toFixed(1).replace(/\.0$/, '')}/m`;
  return `+${formatEffectNumber(safe)}/m`;
}

function renderHome(scene, options = {}) {
  const state = scene.sanctuary;
  const completedBuildings = completeFinishedConstructions(state);
  if (completedBuildings.length) saveSanctuary(state);
  const resourceRates = getHomeResourceRatesPerMinute(state);
  renderHomeResourceRows(state, resourceRates);
  if (options.animateGains) {
    for (const [key, amount] of Object.entries(options.gains || {})) {
      scene.pulseHomeResourceGain?.(key, amount);
    }
  }
  dom.shrineLevelText.textContent = `Lv.${state.shrineLevel}`;
  dom.residentText.textContent = `${state.residents} / ${state.residents + 3}`;
  const nextExpansionCost = getNextExpansionCost(state) || Number(state.lightNeed || 100);
  dom.lightFill.style.width = `${clamp(state.light / nextExpansionCost * 100, 0, 100)}%`;
  dom.lightText.textContent = `${Math.floor(state.light)} / ${nextExpansionCost}`;
  dom.loopLog.textContent = state.lastLog;

  dom.homeHexGrid.innerHTML = renderHomeSettlement(state)
    + HEXES.map(tile => renderHex(tile, state)).join('')
    + renderHomeBuildings(state);
  dom.homeBuildingPanel.innerHTML = renderBuildingPanel(state);
  document.documentElement.dataset.survivorMode = 'home';
  document.documentElement.dataset.survivorGameId = GAME_ID;
  document.documentElement.dataset.homeResourceRates = HOME_RESOURCE_KEYS
    .map(key => `${key}:${Number(resourceRates[key] || 0).toFixed(3)}`)
    .join(',');
}

function renderHex(tile, state) {
  const building = getVisibleBuildingForTile(tile, state);
  const buildingKey = building?.key || null;
  const buildingStatus = building ? getBuildingStatus(state, building) : null;
  const tileState = getTileRenderState(tile, state);
  const stateClass = buildingKey
    ? `building-slot ${buildingStatus}${buildingStatus === 'built' ? ' built occupied' : ''}`
    : tileState;
  const selected = buildingKey ? state.selectedBuildingKey === buildingKey : tile.selected;
  const buildingClass = building ? ` occupied-${building.kind} occupied-${buildingKey}` : '';
  const style = `--q:${tile.q};--r:${tile.r}`;
  let content = '';
  if (buildingKey && buildingStatus === 'built') {
    content = '';
  } else if (buildingKey && buildingStatus === 'constructing') {
    content = `<div class="hex-cost">${formatRemainingSeconds(getConstructionRemaining(state, building))}</div>`;
  } else if (buildingKey && buildingStatus === 'buildable') {
    content = '<div class="hex-build-marker" aria-hidden="true"></div>';
  } else if (buildingKey) {
    content = '<div class="hex-lock-mark" aria-hidden="true"></div>';
  } else if (stateClass === 'expand') {
    content = `<div class="hex-cost">${tile.cost}</div>`;
  } else if (tileState === 'locked') {
    content = '<div class="hex-lock-mark" aria-hidden="true"></div>';
  } else if (tileState === 'fog') {
    content = '<div class="hex-fog-mark" aria-hidden="true"></div>';
  } else if (tileState === 'empty') {
    content = '<div class="hex-build-marker" aria-hidden="true"></div>';
  }
  const data = buildingKey ? ` data-building-key="${buildingKey}"` : ` data-tile-id="${tile.id}"`;
  return `<div class="home-hex ${stateClass}${buildingClass}${selected ? ' selected' : ''}" style="${style}"${data}>${content}</div>`;
}

function renderHomeSettlement(state) {
  const paths = HOME_PATHS.map(([from, to, size]) => renderHomePath(from, to, size)).join('');
  const foundations = getHomeBuildingEntries(state)
    .map(entry => {
      const base = entry.building.base || { kind: 'yard', w: entry.w, h: 72, dx: 0, dy: 30 };
      const status = getBuildingStatus(state, entry.building);
      const x = entry.tileX + (base.dx || 0);
      const y = entry.tileY + (base.dy || 0);
      const style = `--x:${x.toFixed(1)}px;--y:${y.toFixed(1)}px;--w:${base.w}px;--h:${base.h}px;--z:${Math.round(80 + y)}`;
      return `<div class="home-foundation home-foundation-${base.kind} is-${status}" style="${style}" aria-hidden="true"></div>`;
    })
    .join('');
  const props = HOME_PROPS
    .map(prop => `<div class="home-prop home-prop-${prop.kind}" style="--x:${prop.x}px;--y:${prop.y}px" aria-hidden="true"></div>`)
    .join('');
  return `<div class="home-owned-ground" aria-hidden="true"></div>${paths}${foundations}${props}`;
}

function renderHomePath(fromId, toId, size) {
  const from = HEX_BY_ID.get(fromId);
  const to = HEX_BY_ID.get(toId);
  if (!from || !to) return '';
  const ax = hexCenterX(from);
  const ay = hexCenterY(from);
  const bx = hexCenterX(to);
  const by = hexCenterY(to);
  const dx = bx - ax;
  const dy = by - ay;
  const x = ax + dx / 2;
  const y = ay + dy / 2 + 18;
  const len = Math.hypot(dx, dy);
  const angle = Math.atan2(dy, dx) * 180 / Math.PI;
  const style = `--x:${x.toFixed(1)}px;--y:${y.toFixed(1)}px;--len:${len.toFixed(1)}px;--angle:${angle.toFixed(1)}deg`;
  return `<div class="home-path home-path-${size}" style="${style}" aria-hidden="true"></div>`;
}

function renderHomeBuildings(state) {
  return getHomeBuildingEntries(state)
    .sort((a, b) => a.y - b.y)
    .map(entry => {
      const { building, x, y, w, h } = entry;
      const level = getBuildingLevel(state, building);
      const output = formatBuildingBubble(building, level);
      const status = getBuildingStatus(state, building);
      const selected = state.selectedBuildingKey === building.key;
      const isImageReady = status === 'built'
        && building.assetStatus === 'existing'
        && AVAILABLE_HOME_BUILDING_SPRITES.has(building.sprite);
      const image = isImageReady
        ? `<img src="./assets/ninja2/home/buildings/${building.sprite}.png?v=${ASSET_VERSION}" alt="" loading="eager">`
        : `<div class="building-blueprint"><span>${building.icon || '+'}</span></div>`;
      const badge = status === 'built'
        ? `Lv.${level}`
        : status === 'constructing'
          ? formatRemainingSeconds(getConstructionRemaining(state, building))
          : status === 'buildable'
            ? '건설'
            : '잠금';
      const bubble = status === 'built'
        ? output
        : status === 'constructing'
          ? `${Math.round(getConstructionProgress(state, building) * 100)}%`
          : status === 'buildable'
            ? formatPrimaryCost(building.construction?.cost)
            : formatUnlockShort(building);
      const style = `--x:${x.toFixed(1)}px;--y:${y.toFixed(1)}px;--w:${w}px;--h:${h}px;--z:${Math.round(220 + y)}`;
      return `
        <div class="home-building home-building-${building.kind} is-${status}${selected ? ' selected' : ''}" style="${style}" data-building-key="${building.key}" data-footprint="${building.footprint}" aria-label="${building.name} ${building.footprint}">
          ${image}
          <b>${badge}</b>
          <div class="bubble" aria-label="${building.output} ${bubble}">${bubble}</div>
        </div>
      `;
    })
    .join('');
}

function getHomeBuildingEntries(state) {
  return BUILDINGS.filter(building => isBuildingMapVisible(state, building)).map(building => {
    const tileIds = building.tiles || [building.tile];
    const tiles = tileIds.map(tileId => HEX_BY_ID.get(tileId)).filter(Boolean);
    const tile = HEX_BY_ID.get(building.tile) || tiles[0];
    const visual = building.visual || {};
    const tileX = tiles.length ? tiles.reduce((sum, footprintTile) => sum + hexCenterX(footprintTile), 0) / tiles.length : hexCenterX(tile);
    const tileY = tiles.length ? tiles.reduce((sum, footprintTile) => sum + hexCenterY(footprintTile), 0) / tiles.length : hexCenterY(tile);
    const x = tileX + (visual.dx || 0);
    const y = tileY + (visual.dy || 0);
    return { building, tile, tiles, tileX, tileY, x, y, w: visual.w || 96, h: visual.h || 96 };
  });
}

function renderBuildingPanel(state) {
  const building = BUILDING_BY_KEY.get(state.selectedBuildingKey) || BUILDING_BY_KEY.get('lantern_shrine');
  const status = getBuildingStatus(state, building);
  const level = getBuildingLevel(state, building);
  const currentLevel = getLevelData(building, level);
  const previewLevel = currentLevel || getLevelData(building, 1);
  const nextLevel = getLevelData(building, level + 1);
  const upgrade = status === 'built' ? nextLevel?.levelUp : null;
  const construction = building.construction || { seconds: 0, cost: {} };
  const effectStats = formatEffectStats(previewLevel?.effect || {}).slice(0, 3);
  const title = status === 'built' ? `${building.name} Lv.${level}` : building.name;
  const nextCopy = panelStatusCopy(state, building, status, upgrade);
  const button = panelActionButton(state, building, status, upgrade, construction);
  return `
    <div class="panel-building-icon panel-building-icon-${building.kind}"><span>${building.icon || ''}</span></div>
    <div class="panel-building-copy">
      <strong>${title}</strong>
      <span>${nextCopy}</span>
      <div class="mini-progress"><i style="width:${panelProgress(state, building, status)}%"></i></div>
      <div class="panel-stats">
        ${effectStats.map(stat => `<div class="panel-stat">${stat}</div>`).join('')}
      </div>
    </div>
    ${button}
  `;
}

function panelStatusCopy(state, building, status, upgrade) {
  if (status === 'built') {
    return upgrade
      ? `다음 Lv.${getBuildingLevel(state, building) + 1} · ${formatSecondsShort(upgrade.seconds)}`
      : '최대 레벨 · 효과 유지';
  }
  if (status === 'constructing') {
    return `건설 중 · 남은 ${formatRemainingSeconds(getConstructionRemaining(state, building))}`;
  }
  if (status === 'buildable') {
    const construction = building.construction || {};
    return `${formatSecondsShort(construction.seconds || 0)} · ${formatCost(construction.cost)}`;
  }
  if (isBuildingUnlocked(state, building) && !isBuildingFootprintOpen(state, building)) {
    return '건설 터 확장 필요';
  }
  return `해금 조건 · ${formatUnlockRequirements(building)}`;
}

function panelActionButton(state, building, status, upgrade, construction) {
  if (status === 'built') {
    return `
      <button class="panel-upgrade" type="button" data-upgrade-building="${building.key}" ${upgrade ? '' : 'disabled'}>
        <span>${upgrade ? formatPrimaryCost(upgrade.cost) : 'MAX'}</span>
        <small>${upgrade ? '강화' : '완료'}</small>
      </button>
    `;
  }
  if (status === 'constructing') {
    return `
      <button class="panel-upgrade is-waiting" type="button" disabled>
        <span>${formatRemainingSeconds(getConstructionRemaining(state, building))}</span>
        <small>건설중</small>
      </button>
    `;
  }
  if (status === 'buildable') {
    return `
      <button class="panel-upgrade" type="button" data-build-building="${building.key}">
        <span>${formatPrimaryCost(construction.cost)}</span>
        <small>건설</small>
      </button>
    `;
  }
  if (isBuildingUnlocked(state, building) && !isBuildingFootprintOpen(state, building)) {
    return `
      <button class="panel-upgrade" type="button" disabled>
        <span>확장</span>
        <small>터 필요</small>
      </button>
    `;
  }
  return `
    <button class="panel-upgrade" type="button" disabled>
      <span>잠금</span>
      <small>${formatUnlockShort(building)}</small>
    </button>
  `;
}

function panelProgress(state, building, status) {
  if (status === 'constructing') return (getConstructionProgress(state, building) * 100).toFixed(1);
  if (status === 'built') return clamp(getBuildingLevel(state, building) / Math.max(1, building.levels?.length || 1) * 100, 0, 100).toFixed(1);
  if (status === 'buildable') return canAffordCost(state, building.construction?.cost) ? 100 : 34;
  return 8;
}

function getBuildingLevel(state, building) {
  if (!building) return 1;
  const maxLevel = Math.max(1, building.levels?.length || 1);
  if (building.key === 'lantern_shrine') {
    return clamp(Number(state.shrineLevel) || 1, 1, maxLevel);
  }
  return clamp(Number(state.buildingLevels?.[building.key]) || 1, 1, maxLevel);
}

function getLevelData(building, level) {
  if (!building?.levels?.length) return null;
  return building.levels.find(row => row.level === level) || null;
}

function isBuildingBuilt(state, building) {
  return Boolean(state.builtBuildings?.[building.key]);
}

function getConstructionJob(state, building) {
  return state.constructionJobs?.[building.key] || null;
}

function isBuildingConstructing(state, building) {
  const job = getConstructionJob(state, building);
  return Boolean(job && Number(job.finishAt) > Date.now());
}

function getConstructionRemaining(state, building) {
  const job = getConstructionJob(state, building);
  if (!job) return 0;
  return Math.max(0, Math.ceil((Number(job.finishAt) - Date.now()) / 1000));
}

function getConstructionProgress(state, building) {
  const job = getConstructionJob(state, building);
  if (!job) return 0;
  const startedAt = Number(job.startedAt) || Date.now();
  const finishAt = Number(job.finishAt) || startedAt;
  const duration = Math.max(1, finishAt - startedAt);
  return clamp((Date.now() - startedAt) / duration, 0, 1);
}

function completeFinishedConstructions(state) {
  const completed = [];
  const jobs = state.constructionJobs || {};
  const now = Date.now();
  for (const [key, job] of Object.entries(jobs)) {
    if (Number(job.finishAt) > now) continue;
    const building = BUILDING_BY_KEY.get(key);
    if (!building) {
      delete jobs[key];
      continue;
    }
    state.builtBuildings[key] = true;
    state.buildingLevels[key] = Math.max(1, Number(state.buildingLevels?.[key]) || 1);
    setBuildingFootprintState(state, building, 'built');
    delete jobs[key];
    completed.push(building.name);
  }
  if (completed.length) {
    state.lastLog = `${completed.join(', ')} 건설이 완료되었습니다.`;
  }
  state.constructionJobs = jobs;
  return completed;
}

function hasActiveConstruction(state) {
  return Object.keys(state.constructionJobs || {}).length > 0;
}

function isBuildingUnlocked(state, building) {
  const unlock = building.unlock || {};
  return Object.entries(unlock).every(([condition, required]) => {
    if (!condition.endsWith('_level')) return true;
    const buildingKey = condition.slice(0, -'_level'.length);
    const requiredLevel = Number(required) || 1;
    const requiredBuilding = BUILDING_BY_KEY.get(buildingKey);
    if (!requiredBuilding || !isBuildingBuilt(state, requiredBuilding)) return false;
    return getBuildingLevel(state, requiredBuilding) >= requiredLevel;
  });
}

function getBuildingStatus(state, building) {
  if (isBuildingBuilt(state, building)) return 'built';
  if (isBuildingConstructing(state, building)) return 'constructing';
  if (!isBuildingFootprintOpen(state, building)) return 'locked-slot';
  if (isBuildingUnlocked(state, building)) return 'buildable';
  return 'locked-slot';
}

function isBuildingVisible(state, building) {
  if (isBuildingBuilt(state, building) || getConstructionJob(state, building)) return true;
  if (building.tier === 'core') return true;
  const shrine = BUILDING_BY_KEY.get('lantern_shrine');
  const shrineLevel = getBuildingLevel(state, shrine);
  if (building.tier === 'ring_1') return shrineLevel >= 2;
  if (building.tier === 'ring_2') return shrineLevel >= 4;
  return shrineLevel >= 6;
}

function isBuildingMapVisible(state, building) {
  if (isBuildingBuilt(state, building) || getConstructionJob(state, building)) return true;
  return isBuildingVisible(state, building) && isBuildingFootprintOpen(state, building);
}

function getVisibleBuildingForTile(tile, state) {
  return BUILDINGS.find(building => isBuildingMapVisible(state, building) && (building.tiles || [building.tile]).includes(tile.id));
}

function formatUnlockRequirements(building) {
  const unlock = building.unlock || {};
  const entries = Object.entries(unlock);
  if (!entries.length) return '즉시 가능';
  return entries.map(([condition, required]) => {
    if (!condition.endsWith('_level')) return `${condition} ${required}`;
    const buildingKey = condition.slice(0, -'_level'.length);
    const requiredBuilding = BUILDING_BY_KEY.get(buildingKey);
    return `${requiredBuilding?.name || buildingKey} Lv.${required}`;
  }).join(', ');
}

function formatUnlockShort(building) {
  const unlock = building.unlock || {};
  const first = Object.entries(unlock)[0];
  if (!first) return '조건';
  const [condition, required] = first;
  if (!condition.endsWith('_level')) return String(required);
  const buildingKey = condition.slice(0, -'_level'.length);
  const requiredBuilding = BUILDING_BY_KEY.get(buildingKey);
  const shortName = requiredBuilding?.name?.replace('등불 ', '').replace(' 작업장', '') || 'Lv';
  return `${shortName}${required}`;
}

function formatRemainingSeconds(seconds = 0) {
  const safe = Math.max(0, Math.ceil(seconds));
  if (safe < 60) return `${safe}s`;
  if (safe < 3600) {
    const minutes = Math.floor(safe / 60);
    const rest = safe % 60;
    return rest ? `${minutes}m` : `${minutes}m`;
  }
  return `${Math.ceil(safe / 3600)}h`;
}

function formatBuildingBubble(building, level) {
  const effect = getLevelData(building, level)?.effect || {};
  const priority = [
    ['wood_per_min', value => `+${formatEffectNumber(value)}/m`],
    ['stone_per_min', value => `+${formatEffectNumber(value)}/m`],
    ['exp_per_min', value => `+${formatEffectNumber(value)}/m`],
    ['soulflame_per_hour', value => `+${formatEffectNumber(value)}/h`],
    ['herb_per_min', value => `+${formatEffectNumber(value)}/m`],
    ['boss_damage_percent', value => `+${formatEffectNumber(value)}%`],
    ['resident_cap_bonus', value => `+${formatEffectNumber(value)}`],
    ['light_radius', value => `R${formatEffectNumber(value)}`],
  ];
  const match = priority.find(([key]) => effect[key] != null);
  return match ? match[1](effect[match[0]]) : '+1';
}

function formatEffectStats(effect) {
  const labels = {
    light_radius: ['반경', ''],
    max_open_tiles: ['타일', '칸'],
    resident_cap: ['주민', '명'],
    max_building_level: ['건물Lv', ''],
    wood_per_min: ['목재', '/m'],
    stone_per_min: ['석재', '/m'],
    exp_per_min: ['경험치', '/m'],
    attack_percent: ['공격', '%'],
    soulflame_per_hour: ['영혼불', '/h'],
    herb_per_min: ['허브', '/m'],
    recovery_percent: ['회복', '%'],
    resident_cap_bonus: ['주민+', '명'],
    offline_cap_hours_bonus: ['오프라인+', 'h'],
    all_production_percent: ['생산', '%'],
    tool_per_hour: ['도구', '/h'],
    construction_time_reduction_percent: ['건설단축', '%'],
    boss_damage_percent: ['보스피해', '%'],
    defense_percent: ['방어', '%'],
    resource_expedition_slots: ['파견', '칸'],
    item_drop_percent: ['드롭', '%'],
  };
  return Object.entries(effect)
    .filter(([key]) => key !== 'unlocks' && labels[key])
    .map(([key, value]) => {
      const [label, suffix] = labels[key];
      return `${label} ${formatEffectNumber(value)}${suffix}`;
    });
}

function formatEffectNumber(value) {
  if (Number.isInteger(value)) return formatNumber(value);
  return Number(value).toFixed(1).replace(/\.0$/, '');
}

function formatSecondsShort(seconds = 0) {
  const safe = Math.max(0, Math.floor(seconds));
  if (safe < 60) return `${safe}초`;
  if (safe < 3600) return `${Math.round(safe / 60)}분`;
  return `${Math.round(safe / 3600)}시간`;
}

function formatCost(cost = {}) {
  const entries = Object.entries(cost).filter(([, value]) => Number(value) > 0);
  if (!entries.length) return '무료';
  return entries.map(([key, value]) => `${resourceName(key)} ${formatNumber(value)}`).join(', ');
}

function formatPrimaryCost(cost = {}) {
  const entries = Object.entries(cost).filter(([, value]) => Number(value) > 0);
  if (!entries.length) return '무료';
  const preferredKey = ['gold', 'wood', 'stone', 'soulflame', 'souls'].find(key => Number(cost[key]) > 0);
  const [key, value] = preferredKey ? [preferredKey, cost[preferredKey]] : entries[0];
  return formatNumber(value);
}

function resourceName(key) {
  return HOUSING_TECH.resources[key]?.name || key;
}

function stateResourceKey(resourceKey) {
  return STATE_RESOURCE_KEYS[resourceKey] || resourceKey;
}

function getStateResource(state, resourceKey) {
  return Number(state[stateResourceKey(resourceKey)] || 0);
}

function setStateResource(state, resourceKey, value) {
  state[stateResourceKey(resourceKey)] = value;
}

function canAffordCost(state, cost = {}) {
  return Object.entries(cost).every(([key, value]) => getStateResource(state, key) >= Number(value || 0));
}

function spendCost(state, cost = {}) {
  for (const [key, value] of Object.entries(cost)) {
    setStateResource(state, key, getStateResource(state, key) - Number(value || 0));
  }
}

function formatMissingCost(state, cost = {}) {
  return Object.entries(cost)
    .filter(([key, value]) => getStateResource(state, key) < Number(value || 0))
    .map(([key, value]) => `${resourceName(key)} ${formatNumber(getStateResource(state, key))}/${formatNumber(value)}`)
    .join(', ');
}

function selectBuilding(scene, buildingKey) {
  const building = BUILDING_BY_KEY.get(buildingKey);
  if (!scene || !building) return;
  scene.sanctuary.selectedBuildingKey = building.key;
  saveSanctuary(scene.sanctuary);
  renderHome(scene);
}

function expandTile(scene, tileId) {
  const state = scene?.sanctuary;
  const tile = HEX_BY_ID.get(Number(tileId));
  if (!state || !tile) return;

  const tileState = getTileState(state, tile);
  if (isOpenTileState(tileState)) {
    state.lastLog = '이미 정화된 타일입니다.';
  } else if (tileState === 'locked' || !isTileLevelUnlocked(state, tile)) {
    const neededLevel = Number(tile.minShrineLevel || 1);
    state.lastLog = `등불 신전 Lv.${neededLevel}부터 이 구역을 정화할 수 있습니다.`;
  } else if (!hasOpenNeighbor(state, tile)) {
    state.lastLog = '밝혀진 길과 이어진 타일부터 정화할 수 있습니다.';
  } else if (countExpandedTiles(state) >= getMaxExpandedTiles(state)) {
    state.lastLog = '등불 신전을 강화하면 더 많은 타일을 정화할 수 있습니다.';
  } else if (Number(state.light || 0) < Number(tile.cost || 0)) {
    state.lastLog = `정화에는 등불 ${Math.floor(tile.cost)}이 필요합니다.`;
  } else {
    state.light -= Number(tile.cost || 0);
    setTileState(state, tile, 'empty');
    state.clearedTiles = countExpandedTiles(state);
    const residentCap = Number(getShrineEffect(state).resident_cap || state.residents + 3);
    if (state.clearedTiles > 0 && state.clearedTiles % 2 === 0) {
      state.residents = Math.min(residentCap, Number(state.residents || 0) + 1);
    }
    const nextCost = getNextExpansionCost(state);
    if (nextCost) state.lightNeed = nextCost;
    state.lastLog = nextCost
      ? `안개 타일을 정화했습니다. 다음 확장에는 등불 ${nextCost}이 필요합니다.`
      : '안개 타일을 정화했습니다. 다음 구역은 신전 강화 후 열립니다.';
  }

  saveSanctuary(state);
  renderHome(scene);
}

function startBuildingConstruction(scene, buildingKey) {
  const state = scene?.sanctuary;
  const building = BUILDING_BY_KEY.get(buildingKey);
  if (!state || !building) return;
  state.selectedBuildingKey = building.key;
  completeFinishedConstructions(state);
  if (isBuildingBuilt(state, building)) {
    state.lastLog = `${building.name}은 이미 완공되었습니다.`;
  } else if (getConstructionJob(state, building)) {
    state.lastLog = `${building.name}은 건설 중입니다.`;
  } else if (!isBuildingUnlocked(state, building)) {
    state.lastLog = `${building.name} 해금 조건: ${formatUnlockRequirements(building)}`;
  } else if (!isBuildingFootprintOpen(state, building)) {
    state.lastLog = `${building.name} 터를 먼저 확장해야 합니다.`;
  } else if (!canAffordCost(state, building.construction?.cost)) {
    state.lastLog = `건설에는 ${formatMissingCost(state, building.construction?.cost)}가 필요합니다.`;
  } else {
    const construction = building.construction || { seconds: 0, cost: {} };
    spendCost(state, construction.cost);
    const seconds = Number(construction.seconds || 0);
    if (seconds <= 0) {
      state.builtBuildings[building.key] = true;
      state.buildingLevels[building.key] = Math.max(1, Number(state.buildingLevels?.[building.key]) || 1);
      setBuildingFootprintState(state, building, 'built');
      state.lastLog = `${building.name} 건설이 완료되었습니다.`;
    } else {
      const now = Date.now();
      state.constructionJobs[building.key] = {
        startedAt: now,
        finishAt: now + seconds * 1000,
      };
      setBuildingFootprintState(state, building, 'empty');
      state.lastLog = `${building.name} 건설을 시작했습니다. ${formatSecondsShort(seconds)} 후 완공됩니다.`;
    }
  }
  saveSanctuary(state);
  renderHome(scene);
}

function upgradeBuilding(scene, buildingKey) {
  const state = scene?.sanctuary;
  const building = BUILDING_BY_KEY.get(buildingKey);
  if (!state || !building) return;
  state.selectedBuildingKey = building.key;
  completeFinishedConstructions(state);
  if (!isBuildingBuilt(state, building)) {
    state.lastLog = `${building.name}을 먼저 건설해야 합니다.`;
  } else {
    const level = getBuildingLevel(state, building);
    const next = getLevelData(building, level + 1);
    const upgrade = next?.levelUp;
    if (!upgrade) {
      state.lastLog = `${building.name}은 현재 데이터의 최대 레벨입니다.`;
    } else if (!canAffordCost(state, upgrade.cost)) {
      state.lastLog = `강화에는 ${formatMissingCost(state, upgrade.cost)}가 필요합니다.`;
    } else {
      spendCost(state, upgrade.cost);
      const nextLevel = level + 1;
      state.buildingLevels[building.key] = nextLevel;
      if (building.key === 'lantern_shrine') state.shrineLevel = nextLevel;
      const nextExpansionCost = getNextExpansionCost(state);
      const expansionCopy = nextExpansionCost ? ` · 확장 ${nextExpansionCost}` : '';
      state.lastLog = `${building.name} Lv.${nextLevel}: ${formatEffectStats(next.effect).slice(0, 2).join(' · ')}${expansionCopy}`;
    }
  }
  saveSanctuary(state);
  renderHome(scene);
}

function hexCenterX(tile) {
  if (!tile) return 0;
  return tile.q * 73 + tile.r * 36.5;
}

function hexCenterY(tile) {
  if (!tile) return 0;
  return tile.r * 65;
}

function renderResult(scene, summary) {
  dom.resultTitle.textContent = summary.won ? '안개 정화 성공' : '조기 귀환';
  dom.resultSummary.textContent = summary.message;
  dom.resultRewards.innerHTML = summary.rewards
    .map(reward => `<div class="reward-line"><span>${reward.icon}</span><b>${reward.name}</b><em>+${formatNumber(reward.count)}</em></div>`)
    .join('');
}

function applyExpeditionRewards(state, mapRewards, run, context = {}) {
  const rewardMap = new Map();
  const addReward = (key, name, icon, count) => {
    const safe = Math.max(0, Math.floor(count));
    if (!safe) return;
    const previous = rewardMap.get(key) || { key, name, icon, count: 0 };
    previous.count += safe;
    rewardMap.set(key, previous);
  };

  for (const reward of mapRewards || []) {
    const id = Number(reward.itemDataId);
    if (id === 5) {
      state.gold += reward.count;
      addReward('gold', '코인', '🟡', reward.count);
    } else if (id === 200101) {
      state.wood += reward.count;
      addReward('wood', '목재', '🪵', reward.count);
    } else if (id === 200102) {
      state.stone += reward.count;
      addReward('stone', '석재', '◆', reward.count);
    } else if (id === 200103) {
      state.souls += reward.count;
      addReward('souls', '영혼불', '🔥', reward.count);
    }
  }

  for (const [key, count] of Object.entries(run.ledger || {})) {
    if (key === 'gold') {
      state.gold += count;
      addReward('gold_drops', '코인', '●', count);
    } else if (key === 'wood') {
      state.wood += count;
      addReward('wood_drops', '목재', '▰', count);
    } else if (key === 'stone') {
      state.stone += count;
      addReward('stone_drops', '석재', '◆', count);
    } else if (key === 'souls') {
      state.souls += count;
      addReward('souls_drops', '영혼불', '♨', count);
    }
  }

  const soulGain = (run.won ? 26 : 10) + Math.floor(run.kills * 1.4) + Math.floor(run.drops / 2);
  const woodGain = (run.won ? 14 : 5) + Math.floor(run.kills / 4);
  const lightGain = (run.won ? 42 : 18) + Math.floor(run.kills * 1.1);
  state.souls += soulGain;
  state.wood += woodGain;
  state.light += lightGain;
  state.sorties += 1;
  addReward('souls_bonus', '영혼불', '🔥', soulGain);
  addReward('wood_bonus', '목재', '🪵', woodGain);
  addReward('light', '등불 게이지', '💡', lightGain);

  const nextExpansionCost = getNextExpansionCost(state);
  if (nextExpansionCost) state.lightNeed = nextExpansionCost;
  const expansionReady = getExpandableTiles(state).length > 0;

  state.lastLog = expansionReady
    ? '원정대가 밝힌 길을 따라 정화 가능한 안개 타일이 생겼습니다.'
    : '원정대가 영혼불을 가져왔습니다. 다음 출정으로 성소 반경을 더 넓힐 수 있습니다.';

  return {
    won: run.won,
    rewards: [...rewardMap.values()],
    message: `${run.elapsed}s 동안 ${run.kills}마리를 처리했습니다. ${expansionReady ? '정화할 타일이 준비됐습니다.' : '등불이 더 밝아졌습니다.'}`,
  };
}

function drawUnitHp(graphics, unit) {
  graphics.clear();
  if (!unit.alive || unit.team === TEAM.PLAYER) return;
  const width = unit.type === 'Boss' ? 86 : 46;
  const height = 6;
  const x = unit.x - width / 2;
  const y = unit.y - 48;
  graphics.fillStyle(0x17241d, 0.48);
  graphics.fillRoundedRect(x, y, width, height, 3);
  graphics.fillStyle(unit.type === 'Boss' ? COLORS.red : COLORS.leaf, 0.95);
  graphics.fillRoundedRect(x, y, width * clamp(unit.hp / unit.maxHp, 0, 1), height, 3);
}

function scaleForUnit(unit) {
  if (unit.team === TEAM.PLAYER) return 0.18;
  if (unit.type === 'Boss' || Number(unit.dataId) === 110501) return 0.36;
  return 0.25;
}

function textureFamilyForUnit(unit) {
  const dataId = Number(unit.dataId);
  const staticFamily = STATIC_UNIT_TEXTURE_FAMILIES.get(dataId);
  if (staticFamily) return staticFamily;
  if (STATIC_UNIT_TEXTURES.has(dataId)) return null;
  if (unit.team === TEAM.PLAYER) return PLAYER_TEXTURE_FAMILIES.get(dataId) || 'guardian_hero';
  return ENEMY_VARIANT_FAMILIES[Math.abs(Number(unit.id) || 0) % ENEMY_VARIANT_FAMILIES.length];
}

function initialDirectionForUnit(unit) {
  if (unit.team === TEAM.PLAYER) return 'down';
  return unit.x < WORLD.centerX ? 'right' : 'left';
}

function directionFromVector(dx, dy, fallback = null) {
  if (Math.abs(dx) < 0.35 && Math.abs(dy) < 0.35) return fallback;
  if (Math.abs(dx) > Math.abs(dy)) return dx < 0 ? 'left' : 'right';
  return dy < 0 ? 'up' : 'down';
}

function textureDirectionFor(direction) {
  return direction === 'right' ? 'left' : direction;
}

function unitUsesHeroWalkCycle(unit, family = textureFamilyForUnit(unit)) {
  return unit.team === TEAM.PLAYER && family === 'guardian_hero';
}

function heroWalkDirectionFor(direction) {
  return direction === 'right' ? 'left' : direction;
}

function walkFrameIndexForDirection(direction, frame = 0) {
  const row = HERO_WALK_DIRECTIONS.indexOf(heroWalkDirectionFor(direction));
  return Math.max(0, row) * HERO_WALK_FRAME_COUNT + clamp(frame, 0, HERO_WALK_FRAME_COUNT - 1);
}

function walkFrameForUnit(unit, direction, family = textureFamilyForUnit(unit)) {
  if (!unitUsesHeroWalkCycle(unit, family)) return null;
  return walkFrameIndexForDirection(direction, 0);
}

function walkAnimationForUnit(unit, direction, family = textureFamilyForUnit(unit)) {
  if (!unitUsesHeroWalkCycle(unit, family)) return null;
  return HERO_WALK_ANIMS[heroWalkDirectionFor(direction)] || HERO_WALK_ANIMS.down;
}

function isUnitMovingForAnimation(unit, view) {
  const dx = unit.x - (view.lastX ?? unit.x);
  const dy = unit.y - (view.lastY ?? unit.y);
  return dx * dx + dy * dy > 0.35;
}

function shouldMirrorDirection(unit, direction, family) {
  if (unitUsesHeroWalkCycle(unit, family)) return direction === 'right';
  return Boolean(family) && direction === 'right';
}

function facingDirectionForUnit(unit, view, player) {
  const movement = directionFromVector(
    unit.x - (view.lastX ?? unit.x),
    unit.y - (view.lastY ?? unit.y)
  );
  if (movement) return movement;
  if (unit.team !== TEAM.PLAYER && player) {
    return directionFromVector(player.x - unit.x, player.y - unit.y, view.direction || initialDirectionForUnit(unit));
  }
  return view.direction || initialDirectionForUnit(unit);
}

function textureForUnit(unit, direction = 'down', family = textureFamilyForUnit(unit), textureManager = null) {
  const textureExists = key => !textureManager || textureManager.exists(key);
  const fixed = STATIC_UNIT_TEXTURES.get(Number(unit.dataId));
  const textures = family ? DIRECTIONAL_TEXTURES[family] : null;
  const directional = textures ? textures[textureDirectionFor(direction)] || textures.down : null;
  if (directional && textureExists(directional)) return directional;
  if (fixed && textureExists(fixed)) return fixed;
  const familyFallback = GENERATED_TEXTURE_BY_FAMILY[family];
  if (familyFallback && textureExists(familyFallback)) return familyFallback;
  if (fixed) return 'thornBoss';
  if (unit.team === TEAM.PLAYER && textureExists('battleGuardianHero')) return 'battleGuardianHero';
  if (unit.team !== TEAM.PLAYER && textureExists('battleLeafImp')) return 'battleLeafImp';
  return unit.team === TEAM.PLAYER ? 'guardian' : 'leafImp';
}

function installHomeMapPan() {
  const wrap = dom.homeBoardWrap;
  const grid = dom.homeHexGrid;
  if (!wrap || !grid || wrap.dataset.panInstalled === 'true') return;
  wrap.dataset.panInstalled = 'true';

  const pan = { x: 0, y: 0 };
  const drag = {
    active: false,
    moved: false,
    pointerId: null,
    startX: 0,
    startY: 0,
    startPanX: 0,
    startPanY: 0,
    suppressClick: false,
  };

  const applyPan = () => {
    grid.style.setProperty('--home-pan-x', `${pan.x.toFixed(1)}px`);
    grid.style.setProperty('--home-pan-y', `${pan.y.toFixed(1)}px`);
    document.documentElement.dataset.homeMapPanX = pan.x.toFixed(1);
    document.documentElement.dataset.homeMapPanY = pan.y.toFixed(1);
  };

  const endDrag = event => {
    if (!drag.active || (event?.pointerId != null && event.pointerId !== drag.pointerId)) return;
    drag.active = false;
    drag.pointerId = null;
    wrap.classList.remove('is-panning');
    try {
      if (event?.pointerId != null) wrap.releasePointerCapture(event.pointerId);
    } catch {}
    if (drag.moved) {
      drag.suppressClick = true;
      globalThis.setTimeout(() => {
        drag.suppressClick = false;
      }, 0);
    }
  };

  const moveDrag = event => {
    if (!drag.active || (event.pointerId != null && event.pointerId !== drag.pointerId)) return;
    const dx = event.clientX - drag.startX;
    const dy = event.clientY - drag.startY;
    if (Math.hypot(dx, dy) >= HOME_MAP_PAN_CLICK_THRESHOLD) drag.moved = true;
    pan.x = clamp(drag.startPanX + dx, -HOME_MAP_PAN_LIMIT.x, HOME_MAP_PAN_LIMIT.x);
    pan.y = clamp(drag.startPanY + dy, -HOME_MAP_PAN_LIMIT.y, HOME_MAP_PAN_LIMIT.y);
    applyPan();
    event.preventDefault();
  };

  wrap.addEventListener('pointerdown', event => {
    if (event.button != null && event.button !== 0) return;
    drag.active = true;
    drag.moved = false;
    drag.pointerId = event.pointerId;
    drag.startX = event.clientX;
    drag.startY = event.clientY;
    drag.startPanX = pan.x;
    drag.startPanY = pan.y;
    wrap.classList.add('is-panning');
    if (event.pointerType !== 'mouse') event.preventDefault();
  }, { passive: false });

  globalThis.addEventListener('pointermove', moveDrag, { passive: false });
  globalThis.addEventListener('mousemove', moveDrag, { passive: false });

  globalThis.addEventListener('pointerup', endDrag);
  globalThis.addEventListener('pointercancel', endDrag);
  globalThis.addEventListener('mouseup', endDrag);

  grid.addEventListener('click', event => {
    if (!drag.suppressClick) return;
    event.preventDefault();
    event.stopImmediatePropagation();
  }, true);

  applyPan();
}

function formatTime(seconds) {
  const safe = Math.max(0, Math.floor(seconds));
  return `${String(Math.floor(safe / 60)).padStart(2, '0')}:${String(safe % 60).padStart(2, '0')}`;
}

function start() {
  const game = new PhaserRef.Game({
    type: PhaserRef.WEBGL,
    parent: 'gameStage',
    width: STAGE.width,
    height: STAGE.height,
    backgroundColor: '#6e9b43',
    banner: false,
    pixelArt: false,
    scale: {
      mode: PhaserRef.Scale.RESIZE,
      autoCenter: PhaserRef.Scale.CENTER_BOTH,
    },
    loader: {
      maxParallelDownloads: 4,
    },
    scene: SurvivorScene,
  });

  globalThis.__IDLEZ_SURVIVOR_GAME__ = game;
  const scene = () => game.scene.getScene('SurvivorScene');
  installHomeMapPan();
  dom.sortieButton.addEventListener('click', () => scene()?.startExpedition?.());
  dom.resultReturnButton.addEventListener('click', () => scene()?.returnHome?.());
  dom.returnButton.addEventListener('click', () => scene()?.returnHome?.());
  dom.pauseButton.addEventListener('click', () => scene()?.togglePause?.());
  dom.restartButton.addEventListener('click', () => scene()?.restartRun?.());
  dom.homeResetButton.addEventListener('click', () => scene()?.restartRun?.());
  dom.homeHexGrid.addEventListener('click', event => {
    const buildingTarget = event.target.closest('[data-building-key]');
    if (buildingTarget) {
      selectBuilding(scene(), buildingTarget.dataset.buildingKey);
      return;
    }
    const tileTarget = event.target.closest('[data-tile-id]');
    if (tileTarget) expandTile(scene(), tileTarget.dataset.tileId);
  });
  dom.homeBuildingPanel.addEventListener('click', event => {
    const app = scene();
    if (!app) return;
    const buildTarget = event.target.closest('[data-build-building]');
    const upgradeTarget = event.target.closest('[data-upgrade-building]');
    if (buildTarget) startBuildingConstruction(app, buildTarget.dataset.buildBuilding);
    if (upgradeTarget) upgradeBuilding(app, upgradeTarget.dataset.upgradeBuilding);
  });

  return game;
}

start();
