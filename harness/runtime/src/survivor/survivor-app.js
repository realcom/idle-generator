import { ResourceStore } from '../idlez-phaser/resource-store.js?v=ninja2-run-skills1';
import { IdlezBoard } from '../idlez-phaser/board-kernel.js?v=ninja2-run-skills1';
import { TEAM, TICKS_PER_SECOND, clamp, formatNumber } from '../idlez-phaser/constants.js?v=ninja2-run-skills1';
import {
  getOrCreateLocalPlayerId,
  readSettingsPreference,
  resolveSettings,
  saveSettings,
} from '../idlez-phaser/settings-store.js?v=settings1';
import { HOUSING_TECH } from './housing-tech.js?v=ninja2-shrine-production1';
import {
  RUN_PROFILE_SKILL_ROWS,
  SKILL_ICON_PATHS,
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
const HOME_DEMO_PARAM = String(params.get('homeDemo') || params.get('housingDemo') || '').toLowerCase();
const HOME_FIXTURE_PARAM = String(params.get('fixture') || '').toLowerCase();
const HOME_START_DEMO_MODE = ['1', 'true', 'demo', 'city', 'housing', 'start', 'first'].includes(HOME_DEMO_PARAM)
  || ['home', 'start', 'first'].includes(HOME_FIXTURE_PARAM);
const HOME_BUILT_CITY_DEMO_MODE = ['built', 'preview', 'full'].includes(HOME_DEMO_PARAM)
  || ['city', 'built', 'preview', 'full'].includes(HOME_FIXTURE_PARAM);
const ENCOUNTER_DEMO_MODE = ['1', 'true', 'demo', 'encounters'].includes(String(params.get('encounter') || params.get('encounters') || '').toLowerCase());
const FAST_VFX_ASSETS = (VFX_DEMO_MODE || LEVEL_CHOICE_DEMO_MODE) && params.get('fullAssets') !== '1';
const ASSET_VERSION = 'ninja2-nineslice1';
const ENABLE_AUDIO_VALUES = new Set(['1', 'true', 'yes', 'on']);
const DISABLE_AUDIO_VALUES = new Set(['0', 'false', 'no', 'off']);
const NINJA2_BGM = Object.freeze({
  key: 'ninja2-bgm-default',
  path: 'assets/audio/hamster-garden-hop.mp3',
  volume: 0.34,
});
const NINJA2_SFX = Object.freeze({
  uiClick: { key: 'ninja2-sfx-ui-click', path: 'assets/audio/sfx/ui_click.wav', volume: 0.42, cooldownMs: 45 },
  uiError: { key: 'ninja2-sfx-ui-error', path: 'assets/audio/sfx/ui_error.wav', volume: 0.48, cooldownMs: 180 },
  attack: { key: 'ninja2-sfx-attack-slash', path: 'assets/audio/sfx/attack_slash.wav', volume: 0.32, cooldownMs: 92 },
  hit: { key: 'ninja2-sfx-hit-monster', path: 'assets/audio/sfx/hit_monster.wav', volume: 0.34, cooldownMs: 82 },
  monsterDead: { key: 'ninja2-sfx-monster-dead', path: 'assets/audio/sfx/monster_dead.wav', volume: 0.38, cooldownMs: 135 },
  coin: { key: 'ninja2-sfx-coin-pickup', path: 'assets/audio/sfx/coin_pickup.wav', volume: 0.32, cooldownMs: 95 },
  reward: { key: 'ninja2-sfx-reward-get', path: 'assets/audio/sfx/reward_get.wav', volume: 0.38, cooldownMs: 150 },
  levelUp: { key: 'ninja2-sfx-level-up', path: 'assets/audio/sfx/level_up.wav', volume: 0.44, cooldownMs: 220 },
});
const STAGE = { width: 941, height: 1672 };
const WORLD = { width: 3000, height: 2000, centerX: 1500, centerY: 1000 };
const BATTLE_CAMERA_ZOOM = 1.08;
const LEGACY_STORAGE_KEYS = ['ninja2.survivorLoopState.v1'];
const STORAGE_KEY = 'ninja2.survivorLoopState.v2';
const NINJA2_NICKNAME_KEY = 'ninja2.player.nickname';
const HOME_NINESLICE_TEXTURES = Object.freeze({
  resourceChip: 'homeResourceChipNineslice',
  panel: 'homePanelParchmentNineslice',
});
const HOME_NINESLICE_SLICES = Object.freeze({
  resourceChip: { left: 18, right: 18, top: 14, bottom: 14 },
  panel: { left: 28, right: 28, top: 28, bottom: 28 },
});
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
const BOARD_KEY_ENCOUNTER_SERIAL = 610;
const BOARD_KEY_ENCOUNTER_TYPE = 611;
const BOARD_KEY_ENCOUNTER_DEMO_STEP = 612;
const ENCOUNTER_TYPE_IDS = Object.freeze({ bomb: 1, magnet: 2, potion: 3, mine: 4 });
const ENCOUNTER_TYPE_BY_ID = Object.freeze(Object.fromEntries(
  Object.entries(ENCOUNTER_TYPE_IDS).map(([type, id]) => [id, type])
));
const ENCOUNTER_DEMO_IN_FLIGHT_OFFSET = 100;
const ENCOUNTER_DEMO_NEXT_STEP = Object.freeze({ 101: 2, 102: 3, 103: 4, 104: 5 });
const ENCOUNTER_DEMO_OFFSETS = Object.freeze({
  bomb: { x: -34, y: 0 },
  magnet: { x: 34, y: 0 },
  potion: { x: 0, y: -34 },
  mine: { x: 0, y: 46 },
});
const ENCOUNTER_MAX_ACTIVE = 5;
const ENCOUNTER_COLLECT_RADIUS = 58;
const ENCOUNTER_MAGNET_RADIUS = 430;
const ENCOUNTER_MINE_RADIUS = 88;
const ENCOUNTER_MINE_HOLD_MS = 3000;
const ENCOUNTER_DISPLAY_SIZE = Object.freeze({ normal: 42, mine: 48 });
const RANDOM_ENCOUNTERS = Object.freeze([
  { type: 'bomb', texture: 'encounterBomb', weight: 30, label: '폭탄' },
  { type: 'magnet', texture: 'encounterMagnet', weight: 22, label: '자석' },
  { type: 'potion', texture: 'encounterPotion', weight: 24, label: '회복약' },
  { type: 'mine', texture: 'encounterMine', weight: 24, label: '광산', holdMs: ENCOUNTER_MINE_HOLD_MS, radius: ENCOUNTER_MINE_RADIUS },
]);
const MINE_RESOURCE_DROPS = Object.freeze([
  { key: 'wood', texture: 'woodCrate', min: 7, max: 11, label: '목재 광맥' },
  { key: 'stone', texture: 'stoneDrop', min: 5, max: 8, label: '기와석 광맥' },
  { key: 'souls', texture: 'soulFlame', min: 3, max: 5, label: '영혼불 광맥' },
]);
const MAX_RUN_SKILL_LEVEL = 5;
const RUN_SKILL_RETRY_TICKS = Math.ceil(TICKS_PER_SECOND * 0.35);
const D1_RUN_LEVEL_CHOICE_SKILL_IDS = Object.freeze([
  300102, // 표창 난사: first explicit ranged pickup
  300103, // 연막 폭탄: first control pickup
  300115, // 질풍 보법: first movement/passive-feeling pickup
]);
const LEVEL_CHOICE_DEMO_IDS = D1_RUN_LEVEL_CHOICE_SKILL_IDS;
const RUN_LEVEL_CHOICE_SKILL_IDS = D1_RUN_LEVEL_CHOICE_SKILL_IDS;
const COMPANION_MANAGEMENT_BUILDING_KEY = 'training_yard';
const COMPANION_GACHA_COST = Object.freeze({ soulflame: 8 });
const COMPANION_DUPLICATE_EXP = 80;
const D1_COMPANIONS = Object.freeze([
  {
    key: 'kaede',
    name: '카에데',
    title: '정찰 닌자',
    skillName: '잎부적 투척',
    skillDataId: 300102,
    cooldownSeconds: 4.2,
    icon: '葉',
    color: '#8bd95c',
    unlockLabel: '튜토리얼 동행',
    passiveKey: 'wood_reward_percent',
    passiveValue: 12,
    passiveCopy: '원정 목재 +12%',
    gachaWeight: 60,
    lockedCopy: '용병 훈련소에서 소환',
  },
  {
    key: 'mio',
    name: '미오',
    title: '등불 무녀',
    skillName: '등불 보호막',
    skillDataId: 300104,
    cooldownSeconds: 8,
    icon: '灯',
    color: '#36e0d4',
    unlockLabel: '첫 정화 성공',
    passiveKey: 'home_production_percent',
    passiveValue: 8,
    passiveCopy: '성소 생산 +8%',
    gachaWeight: 25,
    lockedCopy: 'Stage 1 정화 후 합류',
  },
  {
    key: 'rin',
    name: '린',
    title: '공방 기술자',
    skillName: '공방 폭탄',
    skillDataId: 300107,
    cooldownSeconds: 6.4,
    icon: '爆',
    color: '#ffc64a',
    unlockLabel: '등불 신전 Lv.2',
    passiveKey: 'upgrade_cost_reduction_percent',
    passiveValue: 5,
    passiveCopy: '건물 강화 비용 -5%',
    gachaWeight: 15,
    lockedCopy: '등불 신전 Lv.2 달성',
  },
]);
const D1_COMPANION_BY_KEY = new Map(D1_COMPANIONS.map(companion => [companion.key, companion]));
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
  'bamboo_grove',
  'granary',
  'guard_lantern',
  'herb_garden',
  'iron_mine',
  'shrine',
  'scout_post',
  'soulflame_well',
  'stone_quarry',
  'storage',
  'training_yard',
  'wood_workshop',
  'workshop',
]);

function homeBuildingSpriteKey(building) {
  return building?.sprite || building?.spriteKey || '';
}

function hasHomeBuildingSprite(building) {
  const sprite = homeBuildingSpriteKey(building);
  return Boolean(sprite && AVAILABLE_HOME_BUILDING_SPRITES.has(sprite));
}

function renderHomeBuildingSprite(building) {
  const sprite = homeBuildingSpriteKey(building);
  return `<img src="./assets/ninja2/home/buildings/${escapeHtml(sprite)}.png?v=${ASSET_VERSION}" alt="" loading="eager">`;
}

function shouldSuppressNinja2BackgroundMusic() {
  if (isAudioExplicitlyEnabled() || isParamEnabled('bgm', 'music')) return false;
  if (isAudioExplicitlyDisabled() || isParamDisabled('bgm', 'music')) return true;

  if (globalThis.__NINJA2_PHASER_ENABLE_BGM__ || globalThis.__IDLEZ_PHASER_ENABLE_BGM__ || globalThis.__MUSHROOMER_PHASER_ENABLE_BGM__) return false;
  if (globalThis.__NINJA2_PHASER_DISABLE_BGM__ || globalThis.__IDLEZ_PHASER_DISABLE_BGM__ || globalThis.__MUSHROOMER_PHASER_DISABLE_BGM__) return true;
  if (isAutomationBrowser()) return true;

  const preference = readSettingsPreference();
  if (typeof preference.volumeEnabled === 'boolean') return !preference.volumeEnabled;
  if (typeof preference.bgmEnabled === 'boolean') return !preference.bgmEnabled;
  return false;
}

function shouldSuppressNinja2SoundEffects() {
  if (isAudioExplicitlyEnabled() || isParamEnabled('sfx', 'sound', 'effects')) return false;
  if (isAudioExplicitlyDisabled() || isParamDisabled('sfx', 'sound', 'effects')) return true;

  if (globalThis.__NINJA2_PHASER_ENABLE_SFX__ || globalThis.__IDLEZ_PHASER_ENABLE_SFX__ || globalThis.__MUSHROOMER_PHASER_ENABLE_SFX__) return false;
  if (globalThis.__NINJA2_PHASER_DISABLE_SFX__ || globalThis.__IDLEZ_PHASER_DISABLE_SFX__ || globalThis.__MUSHROOMER_PHASER_DISABLE_SFX__) return true;
  if (isAutomationBrowser()) return true;

  const preference = readSettingsPreference();
  if (typeof preference.sfxEnabled === 'boolean') return !preference.sfxEnabled;
  return false;
}

function shouldForceNinja2SoundEffects() {
  return isAudioExplicitlyEnabled()
    || isParamEnabled('sfx', 'sound', 'effects')
    || Boolean(globalThis.__NINJA2_PHASER_ENABLE_SFX__ || globalThis.__IDLEZ_PHASER_ENABLE_SFX__ || globalThis.__MUSHROOMER_PHASER_ENABLE_SFX__);
}

function isAudioExplicitlyEnabled() {
  if (globalThis.__NINJA2_PHASER_ENABLE_AUDIO__ || globalThis.__IDLEZ_PHASER_ENABLE_AUDIO__ || globalThis.__MUSHROOMER_PHASER_ENABLE_AUDIO__) return true;
  return isParamEnabled('audio');
}

function isAudioExplicitlyDisabled() {
  if (globalThis.__NINJA2_PHASER_DISABLE_AUDIO__ || globalThis.__IDLEZ_PHASER_DISABLE_AUDIO__ || globalThis.__MUSHROOMER_PHASER_DISABLE_AUDIO__) return true;
  return isParamDisabled('audio') || params.has('noAudio') || params.has('muteAudio');
}

function isParamEnabled(...keys) {
  return keys.some(key => ENABLE_AUDIO_VALUES.has(normalizeAudioParam(params.get(key))));
}

function isParamDisabled(...keys) {
  return keys.some(key => DISABLE_AUDIO_VALUES.has(normalizeAudioParam(params.get(key))));
}

function normalizeAudioParam(value) {
  return String(value || '').trim().toLowerCase();
}

function isAutomationBrowser() {
  const nav = globalThis.navigator;
  const ua = nav?.userAgent || '';
  return Boolean(nav?.webdriver) || /HeadlessChrome|Playwright|Puppeteer|Codex/i.test(ua);
}

function playSharedSfx(name, options = {}) {
  const audio = globalThis.__NINJA2_PHASER_AUDIO__ || globalThis.__MUSHROOMER_PHASER_AUDIO__ || globalThis.__IDLEZ_PHASER_AUDIO__;
  return audio?.play?.(name, options) ?? false;
}

function installUiClickSfx() {
  if (!dom.shell || dom.shell.dataset.uiSfxBound === 'true') return;
  dom.shell.dataset.uiSfxBound = 'true';
  dom.shell.addEventListener('click', event => {
    const target = event.target.closest('button,[role="button"],[data-tile-id],[data-building-key]');
    if (!target || !dom.shell.contains(target)) return;
    const disabled = target.disabled || target.getAttribute('aria-disabled') === 'true';
    playSharedSfx(disabled ? 'uiError' : 'uiClick', { volume: disabled ? 0.58 : 0.48 });
  }, true);
}

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
  { id: 7, q: 0, r: -1, state: 'empty' },
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
  { id: -4, q: -2, r: 3, state: 'fog', cost: 420, minShrineLevel: 6 },
  { id: -5, q: -1, r: 3, state: 'fog', cost: 460, minShrineLevel: 6 },
  { id: -6, q: 0, r: 3, state: 'fog', cost: 520, minShrineLevel: 6 },
  { id: -7, q: 1, r: 3, state: 'fog', cost: 560, minShrineLevel: 6 },
  { id: -8, q: 2, r: 3, state: 'fog', cost: 620, minShrineLevel: 6 },
  { id: -9, q: -3, r: 2, state: 'fog', cost: 680, minShrineLevel: 6 },
  { id: -10, q: -2, r: 2, state: 'fog', cost: 740, minShrineLevel: 6 },
];
const HEX_BY_ID = new Map(HEXES.map(tile => [tile.id, tile]));
const HEX_BY_COORD = new Map(HEXES.map(tile => [`${tile.q},${tile.r}`, tile]));
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
  homeTopSkinStage: document.getElementById('homeTopSkinStage'),
  homePanelSkinStage: document.getElementById('homePanelSkinStage'),
  homeSettingsSkinStage: document.getElementById('homeSettingsSkinStage'),
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
  skillCastFeed: document.getElementById('skillCastFeed'),
  companionSkillDock: document.getElementById('companionSkillDock'),
  stageTrack: document.getElementById('stageTrack'),
  pauseButton: document.getElementById('pauseButton'),
  restartButton: document.getElementById('restartButton'),
  returnButton: document.getElementById('returnButton'),
  sortieButton: document.getElementById('sortieButton'),
  resultReturnButton: document.getElementById('resultReturnButton'),
  homeBoardWrap: document.getElementById('homeBoardWrap'),
  homeHexGrid: document.getElementById('homeHexGrid'),
  homeBuildingPanel: document.getElementById('homeBuildingPanel'),
  homeBuildModal: document.getElementById('homeBuildModal'),
  homeBuildModalSubtitle: document.getElementById('homeBuildModalSubtitle'),
  homeBuildList: document.getElementById('homeBuildList'),
  homeBuildGhost: document.getElementById('homeBuildGhost'),
  homeSettingsButton: document.getElementById('homeSettingsButton'),
  homeSettingsPanel: document.getElementById('homeSettingsPanel'),
  homeSettingsShell: document.getElementById('homeSettingsShell'),
  homeSettingsNickname: document.getElementById('homeSettingsNickname'),
  homeTabs: document.getElementById('homeTabs'),
  homeGoldText: document.getElementById('homeGoldText'),
  homeSoulText: document.getElementById('homeSoulText'),
  homeWoodText: document.getElementById('homeWoodText'),
  homeStoneText: document.getElementById('homeStoneText'),
  shrineLevelText: document.getElementById('shrineLevelText'),
  residentText: document.getElementById('residentText'),
  lightFill: document.getElementById('lightFill'),
  lightText: document.getElementById('lightText'),
  loopLog: document.getElementById('loopLog'),
  homeCompanions: document.getElementById('homeCompanions'),
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

let homeSkinGames = [];
let activeHomeTab = 'sanctuary';
let homeBuildTrayOpen = false;
const homeBuildGhostPointer = { x: 220, y: 420, ready: false };

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
const HOME_RESOURCE_KEYS = Object.freeze(['wood', 'souls', 'gold', 'stone', 'food', 'bamboo', 'iron_ore']);
const HOME_TAB_KEYS = new Set(['sanctuary', 'residents', 'exploration', 'missions', 'shop']);
const HOME_RESOURCE_LABELS = Object.freeze({
  gold: '골드',
  souls: '영혼불',
  wood: '목재',
  stone: '석재',
  food: '식량',
  bamboo: '대나무',
  iron_ore: '철광석',
});
const HOME_RESOURCE_RATE_EFFECTS = Object.freeze({
  gold: [['gold_per_min', 1], ['gold_per_hour', 1 / 60]],
  souls: [['soulflame_per_min', 1], ['soulflame_per_hour', 1 / 60], ['souls_per_min', 1], ['souls_per_hour', 1 / 60]],
  wood: [['wood_per_min', 1], ['wood_per_hour', 1 / 60]],
  stone: [['stone_per_min', 1], ['stone_per_hour', 1 / 60]],
  food: [['food_per_min', 1], ['food_per_hour', 1 / 60]],
  bamboo: [['bamboo_per_min', 1], ['bamboo_per_hour', 1 / 60]],
  iron_ore: [['iron_ore_per_min', 1], ['iron_ore_per_hour', 1 / 60]],
});
const HOME_INCOME_MAX_ELAPSED_MS = 8 * 60 * 60 * 1000;
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
    additionalConstruction: building.additionalConstruction,
    placementKind: building.placementKind || (building.startsBuilt ? 'singleton' : 'singleton'),
    instanceRole: building.instanceRole || building.role,
    maxInstancesByLanternLevel: building.maxInstancesByLanternLevel || { 1: building.placementKind === 'repeatable' ? 1 : 1 },
    duplicateScaling: building.duplicateScaling || { costMultiplierPerExtra: 1, timeMultiplierPerExtra: 1 },
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

function getDefaultBuildingTileIds(building) {
  return (building?.tiles?.length ? building.tiles : [building?.tile])
    .map(tileId => Number(tileId))
    .filter(tileId => HEX_BY_ID.has(tileId));
}

function getBuildingFootprintOffsets(building) {
  switch (building?.footprint) {
    case '2x2':
      return [[0, 0], [-1, 0], [0, 1], [-1, 1]];
    case '1x3':
      return [[-1, 0], [0, 0], [1, 0]];
    case '1x2':
    case '1x2_storage':
      return [[0, 0], [1, 0]];
    case '1x1':
    default:
      return [[0, 0]];
  }
}

function getBuildingFootprintTileIdsForAnchor(building, anchorTileId) {
  const anchor = HEX_BY_ID.get(Number(anchorTileId));
  if (!anchor) return null;
  const tiles = [];
  for (const [dq, dr] of getBuildingFootprintOffsets(building)) {
    const tile = HEX_BY_COORD.get(`${anchor.q + dq},${anchor.r + dr}`);
    if (!tile) return null;
    tiles.push(tile.id);
  }
  return [...new Set(tiles)];
}

function makeBuildingPlacement(building, anchorTileId) {
  const anchor = Number(anchorTileId);
  const tiles = getBuildingFootprintTileIdsForAnchor(building, anchor);
  if (!tiles?.length) return null;
  return { anchorTile: anchor, tiles };
}

function defaultBuildingPlacement(building) {
  const tiles = getDefaultBuildingTileIds(building);
  if (!tiles.length) return makeBuildingPlacement(building, building?.tile);
  return {
    anchorTile: Number(building?.tile ?? tiles[0]),
    tiles,
  };
}

function normalizeBuildingPlacement(building, rawPlacement) {
  if (!building || !rawPlacement) return null;
  const rawAnchor = rawPlacement.anchorTile ?? rawPlacement.anchor ?? rawPlacement.tile ?? rawPlacement.runtimeAnchorTile;
  const anchor = Number(rawAnchor);
  if (Number.isFinite(anchor)) return makeBuildingPlacement(building, anchor);

  if (Array.isArray(rawPlacement.tiles) && rawPlacement.tiles.length) {
    const tiles = rawPlacement.tiles.map(tileId => Number(tileId));
    if (tiles.every(tileId => HEX_BY_ID.has(tileId))) {
      return { anchorTile: tiles[0], tiles: [...new Set(tiles)] };
    }
  }
  return null;
}

function normalizeBuildingPlacements(rawPlacements = {}, state = {}) {
  const placements = {};
  for (const building of BUILDINGS) {
    const raw = normalizeBuildingPlacement(building, rawPlacements?.[building.key]);
    if (raw) {
      placements[building.key] = raw;
      continue;
    }

    const shouldKeepDefault = Boolean(
      building.startsBuilt
      || state.builtBuildings?.[building.key]
      || state.constructionJobs?.[building.key]
    );
    if (!shouldKeepDefault) continue;

    const fallback = defaultBuildingPlacement(building);
    if (fallback) placements[building.key] = fallback;
  }
  return placements;
}

function getBuildingPlacement(state, building, { fallback = false } = {}) {
  if (!state || !building) return null;
  const instancePlacement = getInstancePlacement(getPrimaryBuildingInstance(state, building));
  if (instancePlacement) return instancePlacement;
  const pending = getPendingBuildingPlacement(state, building);
  if (pending) return pending;
  const raw = normalizeBuildingPlacement(building, state.buildingPlacements?.[building.key]);
  if (raw) return raw;
  return fallback ? defaultBuildingPlacement(building) : null;
}

function hasBuildingPlacement(state, building) {
  return Boolean(getBuildingPlacement(state, building, { fallback: false }));
}

function getBuildingTileIds(state, building, options = {}) {
  return getBuildingPlacement(state, building, options)?.tiles || [];
}

function setBuildingPlacement(state, building, placement) {
  if (!state || !building || !placement) return;
  state.buildingPlacements = { ...(state.buildingPlacements || {}) };
  state.buildingPlacements[building.key] = {
    anchorTile: Number(placement.anchorTile),
    tiles: placement.tiles.map(tileId => Number(tileId)),
  };
}

function isRepeatableBuilding(building) {
  return building?.placementKind === 'repeatable';
}

function buildingInstanceId(buildingKey, ordinal = 1) {
  return `${buildingKey}#${Math.max(1, Math.floor(Number(ordinal) || 1))}`;
}

function getBuildingInstanceOrdinal(instanceOrId) {
  const raw = typeof instanceOrId === 'string' ? instanceOrId : instanceOrId?.id;
  const match = String(raw || '').match(/#(\d+)$/);
  return Math.max(1, Math.floor(Number(match?.[1]) || Number(instanceOrId?.ordinal) || 1));
}

function getAllBuildingInstances(state) {
  return Object.values(state?.placedBuildingInstances || {})
    .filter(instance => BUILDING_BY_KEY.has(instance?.buildingKey))
    .sort((a, b) => {
      if (a.buildingKey !== b.buildingKey) return a.buildingKey.localeCompare(b.buildingKey);
      return getBuildingInstanceOrdinal(a) - getBuildingInstanceOrdinal(b);
    });
}

function getBuildingInstances(state, building, { includeConstructing = true, includeBuilt = true } = {}) {
  if (!state || !building) return [];
  return getAllBuildingInstances(state).filter(instance => {
    if (instance.buildingKey !== building.key) return false;
    if (instance.status === 'constructing') return includeConstructing;
    if (instance.status === 'built') return includeBuilt;
    return false;
  });
}

function getBuiltBuildingInstances(state, building) {
  return getBuildingInstances(state, building, { includeConstructing: false, includeBuilt: true });
}

function getConstructingBuildingInstances(state, building) {
  return getBuildingInstances(state, building, { includeConstructing: true, includeBuilt: false });
}

function getSelectedBuildingInstance(state, building) {
  const id = state?.selectedBuildingInstanceId;
  const instance = id ? state?.placedBuildingInstances?.[id] : null;
  return instance && instance.buildingKey === building?.key ? instance : null;
}

function getPrimaryBuildingInstance(state, building) {
  return getSelectedBuildingInstance(state, building)
    || getBuiltBuildingInstances(state, building)[0]
    || getConstructingBuildingInstances(state, building)[0]
    || null;
}

function getInstancePlacement(instance) {
  if (!instance?.placement?.tiles?.length) return null;
  return {
    anchorTile: Number(instance.placement.anchorTile ?? instance.placement.tiles[0]),
    tiles: instance.placement.tiles.map(tileId => Number(tileId)).filter(tileId => HEX_BY_ID.has(tileId)),
  };
}

function getPendingBuildingPlacement(state, building) {
  if (!state || !building) return null;
  if (state.buildPlanPlacement?.buildingKey === building.key) {
    return normalizeBuildingPlacement(building, state.buildPlanPlacement.placement);
  }
  return normalizeBuildingPlacement(building, state.buildingPlacements?.[building.key]);
}

function getMaxBuildingInstances(state, building) {
  if (!building) return 0;
  const table = building.maxInstancesByLanternLevel || { 1: isRepeatableBuilding(building) ? 1 : 1 };
  const shrineLevel = Math.max(1, Math.floor(Number(state?.shrineLevel) || 1));
  let maxInstances = 0;
  for (const [level, count] of Object.entries(table)) {
    if (shrineLevel >= Number(level)) {
      maxInstances = Math.max(maxInstances, Math.floor(Number(count) || 0));
    }
  }
  return Math.max(isRepeatableBuilding(building) ? 0 : 1, maxInstances || (building.startsBuilt ? 1 : 0));
}

function getBuildingInstanceCount(state, building, options = {}) {
  return getBuildingInstances(state, building, options).length;
}

function canBuildAnotherBuilding(state, building) {
  if (!state || !building) return false;
  return getBuildingInstanceCount(state, building) < getMaxBuildingInstances(state, building);
}

function getNextBuildingInstanceOrdinal(state, building) {
  const existing = getBuildingInstances(state, building);
  const highest = existing.reduce((max, instance) => Math.max(max, getBuildingInstanceOrdinal(instance)), 0);
  return highest + 1;
}

function scaleCost(cost = {}, multiplier = 1) {
  if (multiplier === 1) return { ...(cost || {}) };
  return Object.fromEntries(Object.entries(cost || {}).map(([key, value]) => [
    key,
    Math.max(1, Math.round(Number(value || 0) * multiplier)),
  ]));
}

function getConstructionForNextInstance(state, building) {
  const existingCount = getBuildingInstanceCount(state, building);
  const useAdditionalBase = existingCount > 0 && building?.additionalConstruction;
  const base = useAdditionalBase ? building.additionalConstruction : building?.construction || { seconds: 0, cost: {} };
  const scaling = building?.duplicateScaling || {};
  const scaleSteps = Math.max(0, useAdditionalBase ? existingCount - 1 : existingCount);
  const costMultiplier = Math.pow(Number(scaling.costMultiplierPerExtra || 1), scaleSteps);
  const timeMultiplier = Math.pow(Number(scaling.timeMultiplierPerExtra || 1), scaleSteps);
  return {
    seconds: Math.max(0, Math.round(Number(base.seconds || 0) * timeMultiplier)),
    cost: scaleCost(base.cost || {}, costMultiplier),
  };
}

function normalizePlacedBuildingInstance(raw, building, fallbackOrdinal = 1) {
  if (!raw || !building) return null;
  const ordinal = Math.max(1, Math.floor(Number(raw.ordinal) || getBuildingInstanceOrdinal(raw.id) || fallbackOrdinal));
  const id = String(raw.id || buildingInstanceId(building.key, ordinal));
  const placement = normalizeBuildingPlacement(building, raw.placement || raw);
  if (!placement) return null;
  const finishAt = Number(raw.finishAt || raw.construction?.finishAt || 0);
  const startedAt = Number(raw.startedAt || raw.construction?.startedAt || 0);
  const status = raw.status === 'constructing' && finishAt > Date.now() ? 'constructing' : 'built';
  const maxLevel = Math.max(1, building.levels?.length || 1);
  return {
    id,
    buildingKey: building.key,
    ordinal,
    level: clamp(Math.floor(Number(raw.level) || 1), 1, maxLevel),
    status,
    placement,
    startedAt: status === 'constructing' ? startedAt || Date.now() : null,
    finishAt: status === 'constructing' ? finishAt : null,
  };
}

function normalizePlacedBuildingInstances(rawInstances = {}, state = {}) {
  const instances = {};
  const rows = Array.isArray(rawInstances)
    ? rawInstances
    : Object.entries(rawInstances || {}).map(([id, instance]) => ({ id, ...instance }));
  const addInstance = instance => {
    if (!instance || instances[instance.id]) return;
    instances[instance.id] = instance;
  };

  for (const raw of rows) {
    const building = BUILDING_BY_KEY.get(raw?.buildingKey);
    const normalized = normalizePlacedBuildingInstance(raw, building, getNextBuildingInstanceOrdinal({ placedBuildingInstances: instances }, building));
    addInstance(normalized);
  }

  for (const building of BUILDINGS) {
    const alreadySeeded = Object.values(instances).some(instance => instance.buildingKey === building.key);
    const legacyJob = state.constructionJobs?.[building.key];
    const shouldSeed = Boolean(building.startsBuilt || state.builtBuildings?.[building.key] || legacyJob);
    if (alreadySeeded || !shouldSeed) continue;

    const jobConstructing = legacyJob && Number(legacyJob.finishAt) > Date.now();
    const placement = normalizeBuildingPlacement(building, state.buildingPlacements?.[building.key])
      || defaultBuildingPlacement(building);
    const raw = {
      id: buildingInstanceId(building.key, 1),
      buildingKey: building.key,
      ordinal: 1,
      level: Number(state.buildingLevels?.[building.key]) || 1,
      status: jobConstructing ? 'constructing' : 'built',
      placement,
      startedAt: legacyJob?.startedAt,
      finishAt: legacyJob?.finishAt,
    };
    addInstance(normalizePlacedBuildingInstance(raw, building, 1));
  }

  return instances;
}

function syncLegacyBuildingState(state) {
  state.builtBuildings = Object.fromEntries(BUILDINGS.map(building => [building.key, false]));
  state.buildingLevels = { ...defaultBuildingLevels(), ...(state.buildingLevels || {}) };
  state.constructionJobs = {};

  for (const building of BUILDINGS) {
    const instances = getBuildingInstances(state, building);
    const built = instances.filter(instance => instance.status === 'built');
    const constructing = instances.filter(instance => instance.status === 'constructing');
    state.builtBuildings[building.key] = built.length > 0;
    const aggregateLevel = built.length
      ? built.reduce((max, instance) => Math.max(max, Number(instance.level || 1)), 1)
      : Number(state.buildingLevels?.[building.key]) || 1;
    state.buildingLevels[building.key] = aggregateLevel;
    if (building.key === 'lantern_shrine') {
      state.shrineLevel = clamp(Number(state.shrineLevel) || aggregateLevel || 1, 1, 99);
      state.buildingLevels[building.key] = state.shrineLevel;
      state.builtBuildings[building.key] = true;
    }
    if (constructing[0]) {
      state.constructionJobs[building.key] = {
        instanceId: constructing[0].id,
        startedAt: constructing[0].startedAt,
        finishAt: constructing[0].finishAt,
      };
    }
  }
}

function defaultCompanionState() {
  return Object.fromEntries(D1_COMPANIONS.map(companion => [
    companion.key,
    {
      unlocked: false,
      equipped: true,
      level: 1,
      exp: 0,
    },
  ]));
}

const createInitialState = () => ({
  tileStateVersion: TILE_STATE_VERSION,
  tileStates: defaultTileStates(),
  shrineLevel: 1,
  buildingLevels: defaultBuildingLevels(),
  builtBuildings: defaultBuiltBuildings(),
  buildingPlacements: {},
  placedBuildingInstances: {},
  constructionJobs: {},
  buildPlanBuildingKey: '',
  buildPlanPlacement: null,
  selectedBuildingKey: 'lantern_shrine',
  selectedBuildingInstanceId: 'lantern_shrine#1',
  residents: 3,
  light: 34,
  lightNeed: 100,
  clearedTiles: 0,
  stageClears: 0,
  companionExp: 0,
  companionGachaPulls: 0,
  companions: defaultCompanionState(),
  gold: 320,
  souls: 38,
  wood: 96,
  stone: 22,
  herb: 0,
  food: 0,
  tool: 0,
  bamboo: 0,
  iron_ore: 0,
  resourceFractions: Object.fromEntries(HOME_RESOURCE_KEYS.map(key => [key, 0])),
  lastIncomeAt: Date.now(),
  sorties: 0,
  lastLog: '등불 신전만 세워진 작은 성소입니다. 빈 터에 목재 작업장을 지어보세요.',
});

function createHomeCityDemoState() {
  const now = Date.now();
  const openTiles = [2, 3, 4, 5, 8, 9, 13, 18, 19, -1, -2, -3];
  const builtKeys = [
    'lantern_shrine',
    'wood_workshop',
    'training_yard',
    'soulflame_well',
    'herb_garden',
    'guard_lantern',
  ];
  const state = normalizeSanctuaryState({
    tileStateVersion: TILE_STATE_VERSION,
    tileStates: Object.fromEntries(openTiles.map(tileId => [tileId, 'empty'])),
    shrineLevel: 25,
    buildingLevels: {
      lantern_shrine: 5,
      wood_workshop: 4,
      stone_quarry: 2,
      training_yard: 3,
      soulflame_well: 2,
      herb_garden: 1,
      guard_lantern: 1,
    },
    builtBuildings: Object.fromEntries(builtKeys.map(key => [key, true])),
    buildingPlacements: {},
    placedBuildingInstances: {},
    constructionJobs: {},
    buildPlanBuildingKey: '',
    buildPlanPlacement: null,
    selectedBuildingKey: 'training_yard',
    selectedBuildingInstanceId: 'training_yard#1',
    residents: 21,
    light: 286,
    lightNeed: 320,
    stageClears: 3,
    companionExp: 380,
    companionGachaPulls: 9,
    companions: {
      kaede: { unlocked: true, equipped: true, level: 3, exp: 260 },
      mio: { unlocked: true, equipped: true, level: 3, exp: 240 },
      rin: { unlocked: true, equipped: true, level: 2, exp: 180 },
    },
    gold: 36700,
    souls: 9800,
    wood: 12400,
    stone: 1230,
    herb: 420,
    food: 160,
    tool: 24,
    bamboo: 180,
    iron_ore: 32,
    resourceFractions: Object.fromEntries(HOME_RESOURCE_KEYS.map(key => [key, 0])),
    lastIncomeAt: now,
    sorties: 7,
    lastLog: '도시건설 하네스 프리뷰 · 건물 footprint와 확장 슬롯을 확인 중입니다.',
  });
  const stoneQuarry = BUILDING_BY_KEY.get('stone_quarry');
  if (stoneQuarry) {
    const placement = defaultBuildingPlacement(stoneQuarry);
    const instanceId = buildingInstanceId(stoneQuarry.key, 1);
    state.placedBuildingInstances[instanceId] = {
      id: instanceId,
      buildingKey: stoneQuarry.key,
      ordinal: 1,
      level: 2,
      status: 'constructing',
      placement,
      startedAt: now - 45000,
      finishAt: now + 135000,
    };
    setBuildingFootprintState(state, stoneQuarry, 'empty');
  }
  state.selectedBuildingKey = 'training_yard';
  state.selectedBuildingInstanceId = 'training_yard#1';
  syncLegacyBuildingState(state);
  state.clearedTiles = countExpandedTiles(state);
  return state;
}

function createFirstStartState() {
  return normalizeSanctuaryState(createInitialState());
}

function normalizeSanctuaryState(rawState = {}) {
  const base = createInitialState();
  const state = { ...base, ...rawState };
  if (rawState.stone == null && rawState.leaf != null) {
    state.stone = Number(rawState.leaf) || 0;
  }
  state.buildingLevels = { ...base.buildingLevels, ...(rawState.buildingLevels || {}) };
  state.builtBuildings = { ...base.builtBuildings, ...(rawState.builtBuildings || {}) };
  state.constructionJobs = { ...(rawState.constructionJobs || {}) };
  state.buildingPlacements = normalizeBuildingPlacements(rawState.buildingPlacements, state);
  state.placedBuildingInstances = normalizePlacedBuildingInstances(rawState.placedBuildingInstances, state);
  state.buildPlanBuildingKey = BUILDING_BY_KEY.has(rawState.buildPlanBuildingKey)
    ? rawState.buildPlanBuildingKey
    : '';
  state.buildPlanPlacement = state.buildPlanBuildingKey && rawState.buildPlanPlacement?.buildingKey === state.buildPlanBuildingKey
    ? rawState.buildPlanPlacement
    : null;
  state.tileStates = normalizeTileStates(rawState.tileStates);
  state.tileStateVersion = TILE_STATE_VERSION;
  state.shrineLevel = clamp(Number(state.shrineLevel) || 1, 1, 99);
  state.buildingLevels.lantern_shrine = state.shrineLevel;
  state.builtBuildings.lantern_shrine = true;
  syncLegacyBuildingState(state);
  state.stageClears = Math.max(0, Math.floor(Number(state.stageClears || 0)));
  state.companionExp = Math.max(0, Math.floor(Number(state.companionExp || 0)));
  state.companionGachaPulls = Math.max(0, Math.floor(Number(state.companionGachaPulls || 0)));
  state.companions = normalizeCompanionState(rawState.companions);
  syncCompanionUnlocks(state);
  syncBuiltTileStates(state);
  state.clearedTiles = countExpandedTiles(state);
  normalizeHomeIncomeState(state, rawState);
  state.selectedBuildingKey = BUILDING_BY_KEY.has(state.selectedBuildingKey)
    ? state.selectedBuildingKey
    : 'lantern_shrine';
  const selectedInstance = state.placedBuildingInstances?.[rawState.selectedBuildingInstanceId];
  state.selectedBuildingInstanceId = selectedInstance && selectedInstance.buildingKey === state.selectedBuildingKey
    ? selectedInstance.id
    : getPrimaryBuildingInstance(state, BUILDING_BY_KEY.get(state.selectedBuildingKey))?.id || '';
  return state;
}

function normalizeCompanionState(rawCompanions = {}) {
  const defaults = defaultCompanionState();
  const normalized = {};
  for (const companion of D1_COMPANIONS) {
    const raw = rawCompanions?.[companion.key] || {};
    const base = defaults[companion.key];
    normalized[companion.key] = {
      unlocked: Boolean(raw.unlocked ?? base.unlocked),
      equipped: raw.equipped !== false,
      level: clamp(Math.floor(Number(raw.level || base.level) || 1), 1, 10),
      exp: Math.max(0, Math.floor(Number(raw.exp || base.exp) || 0)),
    };
  }
  return normalized;
}

function syncCompanionUnlocks(state, { announce = false } = {}) {
  if (!state) return [];
  state.companions = normalizeCompanionState(state.companions);
  syncCompanionLevels(state);
  return [];
}

function isCompanionSummonableByProgress(state, companion) {
  if (companion.key === 'kaede') return true;
  if (!state) return false;
  if (companion.key === 'mio') return Number(state.stageClears || 0) >= 1;
  if (companion.key === 'rin') return Number(state.shrineLevel || 1) >= 2;
  return false;
}

function isCompanionManagementBuilt(state) {
  if (!state) return false;
  const building = BUILDING_BY_KEY.get(COMPANION_MANAGEMENT_BUILDING_KEY);
  return building ? isBuildingBuilt(state, building) : false;
}

function getCompanionRosterStatus(state, companion) {
  const row = getCompanionState(state, companion);
  if (row?.unlocked) return 'summoned';
  if (isCompanionSummonableByProgress(state, companion)) {
    return isCompanionManagementBuilt(state) ? 'available' : 'needs_building';
  }
  return 'locked';
}

function getSummonableCompanions(state) {
  return D1_COMPANIONS.filter(companion => getCompanionRosterStatus(state, companion) === 'available');
}

function getCompanionGachaPool(state) {
  if (!isCompanionManagementBuilt(state)) return [];
  return D1_COMPANIONS.filter(companion => isCompanionSummonableByProgress(state, companion));
}

function getCompanionGachaCost(state) {
  return Number(state?.companionGachaPulls || 0) <= 0 ? {} : COMPANION_GACHA_COST;
}

function companionGachaChance(companion, pool) {
  const total = pool.reduce((sum, poolCompanion) => sum + Number(poolCompanion.gachaWeight || 1), 0);
  if (total <= 0) return 0;
  return Math.max(1, Math.round(Number(companion.gachaWeight || 1) / total * 100));
}

function rollCompanionFromPool(pool, random = Math.random()) {
  const total = pool.reduce((sum, companion) => sum + Number(companion.gachaWeight || 1), 0);
  if (total <= 0) return pool[0] || null;
  let cursor = clamp(Number(random) || 0, 0, 0.999999) * total;
  for (const companion of pool) {
    cursor -= Number(companion.gachaWeight || 1);
    if (cursor <= 0) return companion;
  }
  return pool[pool.length - 1] || null;
}

function syncCompanionLevels(state) {
  for (const companion of D1_COMPANIONS) {
    const row = state.companions?.[companion.key];
    if (!row) continue;
    row.level = clamp(1 + Math.floor(Number(row.exp || 0) / 120), 1, 10);
  }
}

function getCompanionState(state, companionOrKey) {
  const key = typeof companionOrKey === 'string' ? companionOrKey : companionOrKey?.key;
  return state?.companions?.[key] || null;
}

function getActiveCompanions(state) {
  syncCompanionUnlocks(state);
  return D1_COMPANIONS.filter(companion => {
    const row = getCompanionState(state, companion);
    return row?.unlocked && row.equipped !== false;
  });
}

function getCompanionBonus(state, passiveKey) {
  return getActiveCompanions(state)
    .filter(companion => companion.passiveKey === passiveKey)
    .reduce((sum, companion) => sum + Number(companion.passiveValue || 0), 0);
}

function addCompanionExp(state, amount) {
  const safe = Math.max(0, Math.floor(Number(amount || 0)));
  if (!safe) return 0;
  state.companionExp = Math.max(0, Number(state.companionExp || 0) + safe);
  for (const companion of getActiveCompanions(state)) {
    const row = getCompanionState(state, companion);
    row.exp = Math.max(0, Number(row.exp || 0) + safe);
  }
  syncCompanionLevels(state);
  return safe;
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
  if (HOME_BUILT_CITY_DEMO_MODE) return createHomeCityDemoState();
  if (HOME_START_DEMO_MODE) return createFirstStartState();
  try {
    for (const key of LEGACY_STORAGE_KEYS) localStorage.removeItem(key);
    const parsed = JSON.parse(localStorage.getItem(STORAGE_KEY) || '');
    return normalizeSanctuaryState(parsed);
  } catch {
    return createFirstStartState();
  }
}

function saveSanctuary(state) {
  if (HOME_START_DEMO_MODE || HOME_BUILT_CITY_DEMO_MODE) return;
  localStorage.setItem(STORAGE_KEY, JSON.stringify(state));
}

function readNinja2Settings() {
  const preference = readSettingsPreference();
  const base = resolveSettings({ defaultBgmEnabled: true, defaultSfxEnabled: true });
  const audio = globalThis.__NINJA2_PHASER_AUDIO__ || globalThis.__MUSHROOMER_PHASER_AUDIO__ || globalThis.__IDLEZ_PHASER_AUDIO__;
  const live = audio?.getSettings?.() || {};
  const bgmEnabled = typeof live.bgmEnabled === 'boolean' ? live.bgmEnabled : base.bgmEnabled;
  const sfxEnabled = typeof live.sfxEnabled === 'boolean' ? live.sfxEnabled : base.sfxEnabled;
  return {
    ...base,
    bgmEnabled,
    sfxEnabled,
    volumeEnabled: typeof live.volumeEnabled === 'boolean'
      ? live.volumeEnabled
      : typeof preference.volumeEnabled === 'boolean'
        ? preference.volumeEnabled
        : Boolean(bgmEnabled),
  };
}

function resolveNinja2Nickname() {
  try {
    const saved = globalThis.localStorage?.getItem(NINJA2_NICKNAME_KEY);
    if (saved && saved.trim()) return saved.trim().slice(0, 18);
  } catch {
    // Settings UI can still derive a local nickname when storage is unavailable.
  }

  const localId = getOrCreateLocalPlayerId();
  const suffix = compactLocalId(localId);
  return `닌자_${suffix}`;
}

function compactLocalId(value) {
  const cleaned = String(value || '')
    .replace(/^Guest_/i, '')
    .replace(/[^a-z0-9]/gi, '')
    .toUpperCase();
  return (cleaned || '0000').slice(-4).padStart(4, '0');
}

function applyNinja2Settings(settings = readNinja2Settings()) {
  const sfxEnabled = Boolean(settings.sfxEnabled);
  const volumeEnabled = Boolean(settings.volumeEnabled);

  if (dom.homeSettingsNickname) dom.homeSettingsNickname.textContent = resolveNinja2Nickname();
  updateHomeSettingRow('sfx', sfxEnabled);
  updateHomeSettingRow('volume', volumeEnabled);

  document.documentElement.dataset.ninja2Sfx = sfxEnabled ? 'on' : 'off';
  document.documentElement.dataset.ninja2Volume = volumeEnabled ? 'on' : 'off';
  return { ...settings, sfxEnabled, volumeEnabled };
}

function updateHomeSettingRow(key, enabled) {
  const row = dom.homeSettingsPanel?.querySelector(`[data-setting-toggle="${key}"]`);
  if (!row) return;
  row.setAttribute('aria-pressed', enabled ? 'true' : 'false');
  row.dataset.enabled = enabled ? 'true' : 'false';
  const state = row.querySelector('[data-setting-state]');
  if (state) state.textContent = enabled ? 'ON' : 'OFF';
}

function setHomeSettingsOpen(open) {
  if (!dom.homeSettingsPanel || !dom.homeSettingsButton) return;
  if (open) applyNinja2Settings();
  dom.homeSettingsPanel.hidden = !open;
  dom.homeSettingsPanel.setAttribute('aria-hidden', open ? 'false' : 'true');
  dom.homeSettingsButton.setAttribute('aria-expanded', open ? 'true' : 'false');
  document.documentElement.dataset.homeSettings = open ? 'open' : 'closed';
  if (open) requestAnimationFrame(() => globalThis.__NINJA2_HOME_SKINS_REFRESH__?.());
}

function toggleNinja2Setting(key) {
  const current = readNinja2Settings();
  if (key === 'sfx') {
    const enabled = !current.sfxEnabled;
    syncSharedAudioSetting('sfx', enabled);
    applyNinja2Settings(saveSettings({
      sfxEnabled: enabled,
      volumeEnabled: current.volumeEnabled,
    }, { defaultBgmEnabled: true, defaultSfxEnabled: true }));
    if (enabled) playSharedSfx('uiClick', { volume: 0.5 });
    return;
  }

  if (key === 'volume') {
    const enabled = !current.volumeEnabled;
    syncSharedAudioSetting('bgm', enabled);
    applyNinja2Settings(saveSettings({
      bgmEnabled: enabled,
      volumeEnabled: enabled,
    }, { defaultBgmEnabled: true, defaultSfxEnabled: true }));
  }
}

function syncSharedAudioSetting(kind, enabled) {
  const audio = globalThis.__NINJA2_PHASER_AUDIO__ || globalThis.__MUSHROOMER_PHASER_AUDIO__ || globalThis.__IDLEZ_PHASER_AUDIO__;
  if (kind === 'sfx') audio?.setSfxEnabled?.(enabled);
  if (kind === 'bgm') audio?.setBgmEnabled?.(enabled);
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
  for (const instance of getAllBuildingInstances(state)) {
    if (instance.status !== 'built') continue;
    for (const tileId of getInstancePlacement(instance)?.tiles || []) {
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

function getReservedBuildingForTile(state, tile, ignoreInstanceId = '') {
  if (!state || !tile) return null;
  for (const instance of getAllBuildingInstances(state)) {
    if (instance.id === ignoreInstanceId) continue;
    if (!getInstancePlacement(instance)?.tiles?.includes(tile.id)) continue;
    const building = BUILDING_BY_KEY.get(instance.buildingKey);
    if (building) return { building, instance };
  }
  return null;
}

function getPlacementValidation(state, building, anchorTileId, { ignoreInstanceId = '' } = {}) {
  if (!state || !building) return { ok: false, reason: '건설할 건물을 먼저 선택하세요.' };
  if (!canBuildAnotherBuilding(state, building)) return { ok: false, reason: `${building.name}은 현재 최대 ${getMaxBuildingInstances(state, building)}개까지 배치할 수 있습니다.` };
  if (!isBuildingUnlocked(state, building)) {
    return { ok: false, reason: `${building.name} 해금 조건: ${formatUnlockRequirements(building)}` };
  }

  const placement = makeBuildingPlacement(building, anchorTileId);
  if (!placement) return { ok: false, reason: `${building.name}의 ${building.footprint || '터'}가 이 위치에 맞지 않습니다.` };

  for (const tileId of placement.tiles) {
    const tile = HEX_BY_ID.get(tileId);
    if (!tile || getTileState(state, tile) !== 'empty') {
      return { ok: false, reason: '정화된 빈 타일에만 건설할 수 있습니다.' };
    }
    const reserved = getReservedBuildingForTile(state, tile, ignoreInstanceId);
    if (reserved) {
      return { ok: false, reason: `${reserved.building.name} 터와 겹칩니다.` };
    }
  }

  return { ok: true, placement };
}

function isPlacementCandidateTile(state, tile) {
  const building = BUILDING_BY_KEY.get(state?.buildPlanBuildingKey);
  if (!building || !tile) return false;
  return getPlacementValidation(state, building, tile.id).ok;
}

function getPlacementCandidateTiles(state, building) {
  if (!state || !building) return [];
  return HEXES.filter(tile => getPlacementValidation(state, building, tile.id).ok);
}

function isBuildingFootprintOpen(state, building, placement = getPendingBuildingPlacement(state, building), options = {}) {
  const tileIds = placement?.tiles || [];
  if (!tileIds.length) return false;
  return tileIds.every(tileId => {
    const tile = HEX_BY_ID.get(tileId);
    return tile && isTileOpen(state, tile) && !getReservedBuildingForTile(state, tile, options.ignoreInstanceId);
  });
}

function setBuildingFootprintState(state, building, tileState, instance = getPrimaryBuildingInstance(state, building)) {
  const tileIds = getInstancePlacement(instance)?.tiles
    || getBuildingTileIds(state, building, { fallback: true });
  for (const tileId of tileIds) {
    const tile = HEX_BY_ID.get(tileId);
    if (tile) setTileState(state, tile, tileState);
  }
  state.clearedTiles = countExpandedTiles(state);
}

class HomeNineSliceScene extends PhaserRef.Scene {
  constructor(section) {
    super(`HomeNineSliceScene:${section}`);
    this.section = section;
    this.skinObjects = [];
    this.refreshQueued = false;
  }

  preload() {
    this.load.image(
      HOME_NINESLICE_TEXTURES.resourceChip,
      `assets/ninja2/ui/topbar/top_resource_chip.png?v=${ASSET_VERSION}`
    );
    this.load.image(
      HOME_NINESLICE_TEXTURES.panel,
      `assets/ninja2/ui/panel_parchment_9slice.png?v=${ASSET_VERSION}`
    );
  }

  create() {
    this.cameras.main.setBackgroundColor('rgba(0,0,0,0)');
    this.scale.on('resize', () => this.scheduleRefresh());
    this.scheduleRefresh();
    registerHomeSkinScene(this);
  }

  scheduleRefresh() {
    if (this.refreshQueued) return;
    this.refreshQueued = true;
    requestAnimationFrame(() => {
      this.refreshQueued = false;
      this.renderSkins();
    });
  }

  renderSkins() {
    const stage = this.getStageElement();
    if (!stage || typeof this.add.nineslice !== 'function') {
      document.documentElement.dataset.homeNineslice = 'fallback';
      return;
    }

    const stageRect = stage.getBoundingClientRect();
    if (stageRect.width <= 0 || stageRect.height <= 0) {
      this.clearSkins();
      this.setSectionCount(0);
      return;
    }

    this.cameras.main.setViewport(0, 0, stageRect.width, stageRect.height);
    this.clearSkins();

    if (this.section === 'top') {
      const resourceRows = [...document.querySelectorAll('.resource-row[data-home-resource]')];
      for (const row of resourceRows) {
        this.addDomNineslice(row, HOME_NINESLICE_TEXTURES.resourceChip, HOME_NINESLICE_SLICES.resourceChip, stageRect, -2, 0);
      }
    } else if (this.section === 'panel') {
      this.addDomNineslice(dom.homeBuildingPanel, HOME_NINESLICE_TEXTURES.panel, HOME_NINESLICE_SLICES.panel, stageRect, -14, 0);
    } else if (this.section === 'modal') {
      this.addDomNineslice(dom.homeSettingsShell, HOME_NINESLICE_TEXTURES.panel, HOME_NINESLICE_SLICES.panel, stageRect, 0, 0);
    }

    this.setSectionCount(this.skinObjects.length);
  }

  getStageElement() {
    if (this.section === 'top') return dom.homeTopSkinStage;
    if (this.section === 'panel') return dom.homePanelSkinStage;
    if (this.section === 'modal') return dom.homeSettingsSkinStage;
    return null;
  }

  setSectionCount(count) {
    if (this.section === 'top') document.documentElement.dataset.homeNinesliceTopCount = String(count);
    if (this.section === 'panel') document.documentElement.dataset.homeNineslicePanelCount = String(count);
    if (this.section === 'modal') {
      document.documentElement.dataset.homeNinesliceModalCount = String(count);
      document.documentElement.dataset.homeNinesliceModal = count >= 1 ? 'phaser' : 'fallback';
    }
    updateHomeNinesliceDataset();
  }

  addDomNineslice(element, textureKey, slices, stageRect, inset = 0, depth = 0) {
    if (!element || !this.textures.exists(textureKey)) return null;
    const rect = element.getBoundingClientRect();
    if (rect.width <= 0 || rect.height <= 0) return null;
    const left = rect.left - stageRect.left + inset;
    const top = rect.top - stageRect.top + inset;
    const width = rect.width - inset * 2;
    const height = rect.height - inset * 2;
    if (width <= slices.left + slices.right || height <= slices.top + slices.bottom) return null;

    const skin = this.add.nineslice(
      left + width / 2,
      top + height / 2,
      textureKey,
      null,
      width,
      height,
      slices.left,
      slices.right,
      slices.top,
      slices.bottom
    );
    skin.setDepth(depth);
    this.skinObjects.push(skin);
    return skin;
  }

  clearSkins() {
    for (const skin of this.skinObjects) skin.destroy();
    this.skinObjects = [];
  }
}

function registerHomeSkinScene(scene) {
  if (!globalThis.__NINJA2_HOME_SKIN_SCENES__) globalThis.__NINJA2_HOME_SKIN_SCENES__ = [];
  globalThis.__NINJA2_HOME_SKIN_SCENES__.push(scene);
  globalThis.__NINJA2_HOME_SKINS_REFRESH__ = () => {
    for (const skinScene of globalThis.__NINJA2_HOME_SKIN_SCENES__ || []) {
      skinScene.scheduleRefresh?.();
    }
  };
}

function updateHomeNinesliceDataset() {
  const topCount = Number(document.documentElement.dataset.homeNinesliceTopCount || 0);
  const panelCount = Number(document.documentElement.dataset.homeNineslicePanelCount || 0);
  const modalCount = Number(document.documentElement.dataset.homeNinesliceModalCount || 0);
  const total = topCount + panelCount + modalCount;
  document.documentElement.dataset.homeNinesliceCount = String(total);
  document.documentElement.dataset.homeNineslice = topCount >= 4 && panelCount >= 1 ? 'phaser' : 'fallback';
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
    this.companionSkillReadyTicks = new Map();
    this.levelChoiceOpen = false;
    this.levelChoiceChoices = [];
    this.levelChoiceSource = '';
    this.levelChoiceResumePause = false;
    this.levelChoiceCloseTimer = null;
    this.encounters = [];
    this.encounterSerial = 1;
    this.lastEncounterTriggerSerial = 0;
    this.encounterCollected = 0;
    this.encounterMined = 0;
    this.encounterDemoAdvanceTimer = null;
    this.magnetUntil = 0;
    const backgroundMusicSuppressed = shouldSuppressNinja2BackgroundMusic();
    const soundEffectsSuppressed = shouldSuppressNinja2SoundEffects();
    const soundEffectsForced = shouldForceNinja2SoundEffects();
    const initialSettings = resolveSettings({
      defaultBgmEnabled: !backgroundMusicSuppressed,
      defaultSfxEnabled: !soundEffectsSuppressed,
    });
    this.backgroundMusic = null;
    this.backgroundMusicStarted = false;
    this.backgroundMusicSuppressed = backgroundMusicSuppressed || !initialSettings.bgmEnabled;
    this.sfxEnabled = soundEffectsForced || (!soundEffectsSuppressed && initialSettings.sfxEnabled);
    this.sfxLastPlayedAt = new Map();
    this.audioUnlockHandlersInstalled = false;
  }

  preload() {
    document.documentElement.dataset.survivorBootPhase = 'preload';
    this.preloadAudio();
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
    this.load.image('encounterBomb', `assets/ninja2/battle/encounters/encounter_bomb.png?v=${ASSET_VERSION}`);
    this.load.image('encounterMagnet', `assets/ninja2/battle/encounters/encounter_magnet.png?v=${ASSET_VERSION}`);
    this.load.image('encounterPotion', `assets/ninja2/battle/encounters/encounter_potion.png?v=${ASSET_VERSION}`);
    this.load.image('encounterMine', `assets/ninja2/battle/encounters/encounter_mine.png?v=${ASSET_VERSION}`);
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
    this.installAudioApi();
    this.startBackgroundMusic();
    this.bootResources().catch(error => {
      console.error(error);
      dom.bootStatus.textContent = error.message;
      dom.bootStatus.style.display = 'block';
    });
  }

  preloadAudio() {
    this.load.audio(NINJA2_BGM.key, [NINJA2_BGM.path]);
    for (const def of Object.values(NINJA2_SFX)) {
      this.load.audio(def.key, [def.path]);
    }
  }

  installAudioApi() {
    const thisScene = this;
    const api = {
      get bgmEnabled() {
        return !thisScene.backgroundMusicSuppressed;
      },
      get sfxEnabled() {
        return thisScene.sfxEnabled;
      },
      getSettings: () => this.getAudioSettings(),
      setBgmEnabled: enabled => this.setBgmEnabled(enabled),
      setSfxEnabled: enabled => this.setSfxEnabled(enabled),
      play: (name, options = {}) => this.playSfx(name, options),
      playSfx: (name, options = {}) => this.playSfx(name, options),
    };

    globalThis.__NINJA2_PHASER_AUDIO__ = api;
    globalThis.__MUSHROOMER_PHASER_AUDIO__ = api;
    globalThis.__IDLEZ_PHASER_AUDIO__ = api;
    this.audio = api;
    this.applyAudioDataset();
  }

  getAudioSettings() {
    return {
      ...resolveSettings({
        defaultBgmEnabled: !this.backgroundMusicSuppressed,
        defaultSfxEnabled: this.sfxEnabled,
      }),
      bgmEnabled: !this.backgroundMusicSuppressed,
      volumeEnabled: !this.backgroundMusicSuppressed,
      sfxEnabled: this.sfxEnabled,
    };
  }

  startBackgroundMusic() {
    this.syncBackgroundMusic();
  }

  syncBackgroundMusic() {
    this.applyAudioDataset();
    if (this.backgroundMusicSuppressed) {
      if (this.backgroundMusic?.isPlaying) {
        if (typeof this.backgroundMusic.pause === 'function') this.backgroundMusic.pause();
        else this.backgroundMusic.stop?.();
      }
      this.backgroundMusicStarted = false;
      return;
    }
    if (!this.sound) return;

    const play = () => {
      if (this.backgroundMusicSuppressed || this.sound.locked) return;
      try {
        if (!this.backgroundMusic) {
          this.backgroundMusic = this.sound.add(NINJA2_BGM.key, {
            loop: true,
            volume: NINJA2_BGM.volume,
          });
        }
        if (this.backgroundMusic.isPaused && typeof this.backgroundMusic.resume === 'function') {
          this.backgroundMusic.resume();
          this.backgroundMusicStarted = true;
        } else if (!this.backgroundMusic.isPlaying) {
          this.backgroundMusicStarted = this.backgroundMusic.play();
        }
      } catch (error) {
        console.warn('[Ninja2Survivor] Failed to start background music', error);
      }
    };

    if (this.sound.locked) {
      this.queueAudioUnlock();
      return;
    }

    play();
  }

  queueAudioUnlock() {
    if (this.audioUnlockHandlersInstalled) return;
    this.audioUnlockHandlersInstalled = true;
    const eventNames = ['pointerdown', 'mousedown', 'touchstart', 'click', 'keydown'];
    const unlock = () => {
      for (const eventName of eventNames) globalThis.removeEventListener(eventName, unlock);
      this.input?.off?.('pointerdown', unlock);
      this.input?.keyboard?.off?.('keydown', unlock);
      this.audioUnlockHandlersInstalled = false;
      try {
        this.sound?.unlock?.();
      } catch {
        // Phaser may unlock implicitly from the same browser gesture.
      }
      this.syncBackgroundMusic();
    };

    for (const eventName of eventNames) {
      globalThis.addEventListener(eventName, unlock, { once: true, passive: true });
    }
    this.input?.once?.('pointerdown', unlock);
    this.input?.keyboard?.once?.('keydown', unlock);
  }

  setBgmEnabled(enabled) {
    const next = Boolean(enabled);
    this.backgroundMusicSuppressed = !next;
    const settings = saveSettings({
      bgmEnabled: next,
      volumeEnabled: next,
      sfxEnabled: this.sfxEnabled,
    }, {
      defaultBgmEnabled: next,
      defaultSfxEnabled: this.sfxEnabled,
    });
    this.syncBackgroundMusic();
    return settings;
  }

  setSfxEnabled(enabled) {
    this.sfxEnabled = Boolean(enabled);
    const current = readSettingsPreference();
    this.applyAudioDataset();
    return saveSettings({
      bgmEnabled: !this.backgroundMusicSuppressed,
      volumeEnabled: typeof current.volumeEnabled === 'boolean' ? current.volumeEnabled : !this.backgroundMusicSuppressed,
      sfxEnabled: this.sfxEnabled,
    }, {
      defaultBgmEnabled: !this.backgroundMusicSuppressed,
      defaultSfxEnabled: this.sfxEnabled,
    });
  }

  applyAudioDataset() {
    const root = document.documentElement;
    root.dataset.bgm = this.backgroundMusicSuppressed ? 'off' : 'on';
    root.dataset.sfx = this.sfxEnabled ? 'on' : 'off';
    root.dataset.ninja2Volume = this.backgroundMusicSuppressed ? 'off' : 'on';
    root.dataset.ninja2Sfx = this.sfxEnabled ? 'on' : 'off';
  }

  playSfx(name, options = {}) {
    const def = NINJA2_SFX[name];
    if (!def || !this.sound || !this.sfxEnabled) return false;

    if (this.sound.locked) {
      try {
        this.sound.unlock?.();
      } catch {
        // Browser gesture policies differ by platform; retry on the next gesture.
      }
      if (this.sound.locked) {
        this.queueAudioUnlock();
        return false;
      }
    }

    const now = this.time?.now ?? performance.now();
    const cooldownMs = options.cooldownMs ?? def.cooldownMs ?? 0;
    const lastPlayedAt = this.sfxLastPlayedAt.get(def.key) ?? -Infinity;
    if (cooldownMs > 0 && now - lastPlayedAt < cooldownMs) return false;

    this.sfxLastPlayedAt.set(def.key, now);
    try {
      return this.sound.play(def.key, {
        volume: clamp((def.volume ?? 1) * (options.volume ?? 1), 0, 1),
        rate: options.rate ?? 1,
        detune: options.detune ?? 0,
      });
    } catch (error) {
      console.warn(`[Ninja2Survivor] Failed to play SFX: ${name}`, error);
      return false;
    }
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
    ensureHomeSkinStages();
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
      requestAnimationFrame(() => this.startExpedition({ free: true }));
    }
  }

  installHomeTicker() {
    if (this.homeTicker) return;
    this.homeTicker = setInterval(() => {
      const completed = completeFinishedConstructions(this.sanctuary);
      const income = applyHomeResourceIncome(this.sanctuary);
      if (completed.length || income.changed) saveSanctuary(this.sanctuary);
      if (this.mode !== 'home') return;
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
    board.on('boardVariableChanged', event => this.onBoardVariableChanged(event));
    board.on('warning', message => {
      console.warn(`[SurvivorTrigger] ${message}`);
      this.playSfx('uiError', { volume: 0.62 });
    });
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

  startExpedition({ free = false } = {}) {
    if (!this.ready || !this.board) return;
    setHomeSettingsOpen(false);
    syncCompanionUnlocks(this.sanctuary);
    if (!free && this.mode === 'home') {
      if (Number(this.sanctuary.light || 0) < 1) {
        this.sanctuary.lastLog = '출전에는 등불 1이 필요합니다. 성소 생산이나 이전 원정 보상으로 등불을 모으세요.';
        renderHome(this);
        this.playSfx('uiError', { volume: 0.68 });
        return;
      }
      this.sanctuary.light = Math.max(0, Number(this.sanctuary.light || 0) - 1);
      this.sanctuary.lastIncomeAt = Date.now();
      saveSanctuary(this.sanctuary);
    }
    this.setMode('expedition');
    this.syncBackgroundMusic();
    this.paused = false;
    this.runRewards = [];
    this.runDrops = 0;
    this.runLedger = createRunLedger();
    this.runSkillLevels = new Map();
    this.runSkillReadyTicks = new Map();
    this.companionSkillReadyTicks = new Map();
    this.clearEncounters();
    this.encounterSerial = 1;
    this.lastEncounterTriggerSerial = 0;
    this.encounterCollected = 0;
    this.encounterMined = 0;
    this.clearEncounterDemoAdvanceTimer();
    this.magnetUntil = 0;
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
    document.documentElement.dataset.survivorRunSkillSpawnCount = '0';
    document.documentElement.dataset.survivorRunSkillLastSpawn = '';
    document.documentElement.dataset.survivorRunSkillDamageCount = '0';
    document.documentElement.dataset.survivorRunSkillDamageTotal = '0';
    document.documentElement.dataset.survivorRunSkillLastDamage = '';
    document.documentElement.dataset.survivorRunSkillFeedbackCount = '0';
    document.documentElement.dataset.survivorRunSkillLastFeedback = '';
    document.documentElement.dataset.survivorRunSkillLastFeedbackName = '';
    this.skillCastFeedItems = [];
    this.skillCastFeedSerial = 0;
    if (dom.skillCastFeed) dom.skillCastFeed.innerHTML = '';
    document.documentElement.dataset.survivorCompanionSkillCasts = '0';
    document.documentElement.dataset.survivorCompanionLastSkill = '';
    document.documentElement.dataset.survivorCompanionLastSkillName = '';
    document.documentElement.dataset.survivorEncounterActiveCount = '0';
    document.documentElement.dataset.survivorEncounterCollected = '0';
    document.documentElement.dataset.survivorEncounterMined = '0';
    document.documentElement.dataset.survivorEncounterLast = '';
    document.documentElement.dataset.survivorEncounterMineProgress = '0.000';
    document.documentElement.dataset.survivorEncounterDemo = ENCOUNTER_DEMO_MODE ? 'pending' : '';
    document.documentElement.dataset.survivorEncounterDemoStep = '0';
    document.documentElement.dataset.survivorEncounterTriggerSerial = '0';
    document.documentElement.dataset.survivorEncounterTriggerType = '0';
    document.documentElement.dataset.survivorMagnetActive = 'false';

    const player = this.board.playerUnit;
    if (player) {
      player.x = WORLD.centerX;
      player.y = WORLD.centerY;
      player.targetX = player.x;
      player.targetY = player.y;
      player.state = 'combat';
    }
    this.lastEncounterTriggerSerial = Number(this.board.getBoardVariable(BOARD_KEY_ENCOUNTER_SERIAL) || 0);
    if (ENCOUNTER_DEMO_MODE) {
      this.board.setBoardVariable(BOARD_KEY_ENCOUNTER_DEMO_STEP, 1);
      document.documentElement.dataset.survivorEncounterDemoStep = '1';
    }

    this.syncUnitViews();
    this.syncBattleCamera({ snap: true });
    this.resetCompanionSkillCooldowns();
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
    this.clearEncounters();
    this.clearEncounterDemoAdvanceTimer();
    if (this.board?.autoAdvanceTimer) {
      clearTimeout(this.board.autoAdvanceTimer);
      this.board.autoAdvanceTimer = null;
    }

    const won = event.winningTeam === TEAM.PLAYER;
    this.playSfx(won ? 'levelUp' : 'uiError', { volume: won ? 0.78 : 0.56 });
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
    this.clearEncounters();
    this.clearEncounterDemoAdvanceTimer();
    this.closeLevelChoice({ restorePause: false, clearDataset: true });
    this.stopLevelChoiceDemo?.();
    this.stopLevelChoiceDemo = null;
    this.board?.reset?.({ preserveProgress: true });
    this.setMode('home');
    renderHome(this);
  }

  restartRun() {
    if (this.mode === 'home') {
      this.sanctuary = HOME_BUILT_CITY_DEMO_MODE ? createHomeCityDemoState() : createFirstStartState();
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
    this.updateMapTriggerEncounters(simulationDelta);
    this.syncUnitViews();
    this.syncBattleCamera();
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

  onBoardVariableChanged(event = {}) {
    const boardKey = Number(event.boardKey);
    if (boardKey === BOARD_KEY_ENCOUNTER_SERIAL) {
      this.handleEncounterTriggerSerial(event.current);
    } else if (boardKey === BOARD_KEY_ENCOUNTER_TYPE || boardKey === BOARD_KEY_ENCOUNTER_DEMO_STEP) {
      this.updateEncounterDataset();
    }
  }

  handleEncounterTriggerSerial(serial) {
    if (this.mode !== 'expedition' || !this.board || this.board.gameEnded) return;
    const nextSerial = Math.floor(Number(serial) || 0);
    if (nextSerial <= 0 || nextSerial === this.lastEncounterTriggerSerial) return;
    this.lastEncounterTriggerSerial = nextSerial;

    const typeId = Math.floor(Number(this.board.getBoardVariable(BOARD_KEY_ENCOUNTER_TYPE)) || 0);
    const type = encounterTypeFromId(typeId) || pickWeightedEncounterType();
    const demoStep = Math.floor(Number(this.board.getBoardVariable(BOARD_KEY_ENCOUNTER_DEMO_STEP)) || 0);
    const demoInFlight = ENCOUNTER_DEMO_MODE && demoStep > ENCOUNTER_DEMO_IN_FLIGHT_OFFSET;

    document.documentElement.dataset.survivorEncounterTriggerSerial = String(nextSerial);
    document.documentElement.dataset.survivorEncounterTriggerType = String(typeId);

    if (this.encounters.length >= ENCOUNTER_MAX_ACTIVE && !demoInFlight) {
      document.documentElement.dataset.survivorEncounterLast = `trigger:skip:${type}`;
      return;
    }

    const options = { type, source: 'mapTrigger' };
    if (demoInFlight) Object.assign(options, this.demoEncounterOptions(type));
    const encounter = this.spawnRandomEncounter(options);
    document.documentElement.dataset.survivorEncounterLast = encounter ? `trigger:${type}` : `trigger:miss:${type}`;
    if (demoInFlight && document.documentElement.dataset.survivorEncounterDemo !== 'done') {
      document.documentElement.dataset.survivorEncounterDemo = 'spawned';
    }
    if (demoInFlight && encounter) this.scheduleEncounterDemoAdvance(demoStep);
  }

  demoEncounterOptions(type) {
    const player = this.board?.playerUnit;
    const offset = ENCOUNTER_DEMO_OFFSETS[type] || { x: 0, y: 0 };
    if (!player) return { demo: true };
    return {
      x: clamp(player.x + offset.x, 80, WORLD.width - 80),
      y: clamp(player.y + offset.y, 80, WORLD.height - 80),
      demo: true,
    };
  }

  scheduleEncounterDemoAdvance(inFlightStep) {
    const nextStep = ENCOUNTER_DEMO_NEXT_STEP[inFlightStep];
    if (!nextStep) return;
    this.clearEncounterDemoAdvanceTimer();
    this.encounterDemoAdvanceTimer = globalThis.setTimeout(() => {
      this.encounterDemoAdvanceTimer = null;
      if (!ENCOUNTER_DEMO_MODE || this.mode !== 'expedition' || !this.board || this.board.gameEnded) return;
      if (Math.floor(Number(this.board.getBoardVariable(BOARD_KEY_ENCOUNTER_DEMO_STEP)) || 0) !== inFlightStep) return;
      this.board.setBoardVariable(BOARD_KEY_ENCOUNTER_DEMO_STEP, nextStep);
      document.documentElement.dataset.survivorEncounterDemoStep = String(nextStep);
    }, 0);
  }

  clearEncounterDemoAdvanceTimer() {
    if (!this.encounterDemoAdvanceTimer) return;
    globalThis.clearTimeout(this.encounterDemoAdvanceTimer);
    this.encounterDemoAdvanceTimer = null;
  }

  updateMapTriggerEncounters(deltaMs) {
    const player = this.board?.playerUnit;
    if (!player?.alive || this.board?.gameEnded) return;

    this.updateEncounterObjects(deltaMs, player);
    this.updateEncounterDataset();
  }

  spawnRandomEncounter(options = {}) {
    const player = this.board?.playerUnit;
    if (!player?.alive) return null;

    const encounterDef = encounterDefinition(options.type || pickWeightedEncounterType());
    if (!encounterDef) return null;
    const mineDrop = encounterDef.type === 'mine'
      ? MINE_RESOURCE_DROPS[PhaserRef.Math.Between(0, MINE_RESOURCE_DROPS.length - 1)]
      : null;
    const position = options.x != null && options.y != null
      ? { x: Number(options.x), y: Number(options.y) }
      : this.randomEncounterPosition(player);
    const id = this.encounterSerial++;
    const sprite = this.add.sprite(position.x, position.y, encounterDef.texture);
    sprite.setDepth(encounterDef.type === 'mine' ? 17 : 32);
    const displaySize = encounterDef.type === 'mine' ? ENCOUNTER_DISPLAY_SIZE.mine : ENCOUNTER_DISPLAY_SIZE.normal;
    sprite.setDisplaySize(displaySize, displaySize);

    const ring = this.add.graphics();
    ring.setDepth(sprite.depth - 1);
    ring.lineStyle(3, encounterColor(encounterDef.type), 0.58);
    ring.strokeCircle(position.x, position.y, encounterDef.type === 'mine' ? ENCOUNTER_MINE_RADIUS : ENCOUNTER_COLLECT_RADIUS);

    const progress = encounterDef.type === 'mine' ? this.add.graphics() : null;
    progress?.setDepth(sprite.depth + 1);

    const encounter = {
      id,
      type: encounterDef.type,
      label: mineDrop?.label || encounterDef.label,
      x: position.x,
      y: position.y,
      sprite,
      ring,
      progress,
      mineDrop,
      holdMs: encounterDef.holdMs || 0,
      heldMs: 0,
      radius: encounterDef.radius || ENCOUNTER_COLLECT_RADIUS,
      demo: Boolean(options.demo),
      spawnedAt: performance.now(),
      expiresAt: performance.now() + (encounterDef.type === 'mine' ? 24000 : 15000),
    };
    this.encounters.push(encounter);
    this.floatText(encounter.x, encounter.y - 46, encounter.label, '#fff1c8');
    document.documentElement.dataset.survivorEncounterLast = `spawn:${encounter.type}`;
    return encounter;
  }

  randomEncounterPosition(player) {
    const angle = Math.random() * Math.PI * 2;
    const distance = PhaserRef.Math.Between(360, 720);
    return {
      x: clamp(player.x + Math.cos(angle) * distance, 90, WORLD.width - 90),
      y: clamp(player.y + Math.sin(angle) * distance, 90, WORLD.height - 90),
    };
  }

  updateEncounterObjects(deltaMs, player) {
    const now = performance.now();
    const magnetActive = now < this.magnetUntil;
    document.documentElement.dataset.survivorMagnetActive = String(magnetActive);

    for (const encounter of [...this.encounters]) {
      if (now > encounter.expiresAt) {
        this.removeEncounter(encounter, { fade: true });
        continue;
      }

      const dx = player.x - encounter.x;
      const dy = player.y - encounter.y;
      const dist = Math.hypot(dx, dy);
      const isMine = encounter.type === 'mine';

      if (magnetActive && !isMine && dist < ENCOUNTER_MAGNET_RADIUS && dist > 2) {
        const pull = Math.min(dist, Math.max(8, (deltaMs || 16) * 0.9));
        encounter.x += (dx / dist) * pull;
        encounter.y += (dy / dist) * pull;
        encounter.sprite.setPosition(encounter.x, encounter.y);
        this.redrawEncounterRing(encounter);
      }

      if (isMine) {
        if (dist <= encounter.radius) {
          encounter.heldMs = Math.min(encounter.holdMs, encounter.heldMs + Math.max(0, deltaMs || 0));
          this.drawMineProgress(encounter);
          if (encounter.heldMs >= encounter.holdMs) this.completeMineEncounter(encounter);
        } else {
          encounter.heldMs = Math.max(0, encounter.heldMs - Math.max(0, deltaMs || 0) * 0.55);
          this.drawMineProgress(encounter);
        }
        continue;
      }

      const collectRadius = magnetActive ? ENCOUNTER_COLLECT_RADIUS + 24 : ENCOUNTER_COLLECT_RADIUS;
      if (dist <= collectRadius) this.collectEncounter(encounter);
    }
  }

  redrawEncounterRing(encounter) {
    encounter.ring.clear();
    encounter.ring.lineStyle(3, encounterColor(encounter.type), 0.58);
    encounter.ring.strokeCircle(encounter.x, encounter.y, encounter.type === 'mine' ? ENCOUNTER_MINE_RADIUS : ENCOUNTER_COLLECT_RADIUS);
  }

  drawMineProgress(encounter) {
    if (!encounter.progress) return;
    const pct = clamp(encounter.heldMs / Math.max(1, encounter.holdMs), 0, 1);
    encounter.progress.clear();
    encounter.progress.lineStyle(5, 0x171f18, 0.58);
    encounter.progress.strokeCircle(encounter.x, encounter.y, ENCOUNTER_MINE_RADIUS + 12);
    encounter.progress.lineStyle(7, COLORS.gold, 0.86);
    encounter.progress.beginPath();
    encounter.progress.arc(
      encounter.x,
      encounter.y,
      ENCOUNTER_MINE_RADIUS + 12,
      -Math.PI / 2,
      -Math.PI / 2 + Math.PI * 2 * pct
    );
    encounter.progress.strokePath();
    document.documentElement.dataset.survivorEncounterMineProgress = pct.toFixed(3);
  }

  collectEncounter(encounter) {
    if (!this.encounters.includes(encounter)) return;
    this.encounterCollected += 1;
    document.documentElement.dataset.survivorEncounterCollected = String(this.encounterCollected);
    document.documentElement.dataset.survivorEncounterLast = encounter.type;

    if (encounter.type === 'bomb') {
      this.triggerBombEncounter(encounter);
    } else if (encounter.type === 'magnet') {
      this.triggerMagnetEncounter(encounter);
    } else if (encounter.type === 'potion') {
      this.triggerPotionEncounter(encounter);
    }
    this.removeEncounter(encounter);
    this.checkEncounterDemoDone();
  }

  triggerBombEncounter(encounter) {
    const player = this.board?.playerUnit;
    const enemies = this.board?.enemyUnits || [];
    const radius = 310;
    const damage = Math.max(180, Math.round((player?.attack || 90) * 3.1));
    let hits = 0;
    enemies.forEach(enemy => {
      if (Math.hypot(enemy.x - encounter.x, enemy.y - encounter.y) > radius) return;
      enemy.takeDamage(damage, player, null);
      hits += 1;
    });
    this.explosionFx(encounter.x, encounter.y, radius);
    this.playSfx('attack', { volume: 1, rate: 0.78, detune: -180 });
    this.floatText(encounter.x, encounter.y - 78, `폭발 ${hits}`, '#ffc64a');
    document.documentElement.dataset.survivorEncounterBombHits = String(hits);
  }

  triggerMagnetEncounter(encounter) {
    this.magnetUntil = performance.now() + 5200;
    this.magnetFx(encounter.x, encounter.y);
    this.playSfx('reward', { volume: 0.68, rate: 1.08 });
    this.floatText(encounter.x, encounter.y - 72, '자력장', '#9ffcff');
  }

  triggerPotionEncounter(encounter) {
    const player = this.board?.playerUnit;
    if (!player?.alive) return;
    const heal = Math.max(1, Math.round(Number(player.maxHp || 1) * 0.32));
    player.hp = Math.min(Number(player.maxHp || player.hp || 1), Number(player.hp || 0) + heal);
    this.floatText(player.x, player.y - 84, `+${formatNumber(heal)}`, '#9ffcff');
    this.spawnCompanionShieldFx(player.x, player.y);
    this.playSfx('reward', { volume: 0.58, rate: 1.12 });
    document.documentElement.dataset.survivorEncounterHeal = String(heal);
  }

  completeMineEncounter(encounter) {
    if (!this.encounters.includes(encounter)) return;
    const drop = encounter.mineDrop || MINE_RESOURCE_DROPS[0];
    const amount = PhaserRef.Math.Between(drop.min, drop.max);
    this.grantRunResourceDrop({ key: drop.key, texture: drop.texture, amount }, encounter.x, encounter.y);
    this.encounterMined += 1;
    document.documentElement.dataset.survivorEncounterMined = String(this.encounterMined);
    document.documentElement.dataset.survivorEncounterLast = `mine:${drop.key}`;
    document.documentElement.dataset.survivorEncounterMineProgress = '1.000';
    this.mineCompleteFx(encounter.x, encounter.y, drop.texture);
    this.playSfx('reward', { volume: 0.72 });
    this.floatText(encounter.x, encounter.y - 78, `${drop.label} +${formatNumber(amount)}`, '#ffe56f');
    this.removeEncounter(encounter);
    this.checkEncounterDemoDone();
  }

  grantRunResourceDrop(drop, x, y) {
    const amount = Math.max(1, Math.floor(Number(drop.amount) || 1));
    this.runDrops += amount;
    this.runLedger[drop.key] = (this.runLedger[drop.key] || 0) + amount;
    this.dropFx(x, y, drop.texture);
    this.pulseLedgerGain(drop.key, amount);
    this.playSfx(drop.key === 'gold' ? 'coin' : 'reward', {
      volume: drop.key === 'gold' ? 0.72 : 0.48,
    });
  }

  checkEncounterDemoDone() {
    if (!ENCOUNTER_DEMO_MODE || document.documentElement.dataset.survivorEncounterDemo === 'done') return;
    if (this.encounterCollected >= 3 && this.encounterMined >= 1) {
      document.documentElement.dataset.survivorEncounterDemo = 'done';
    }
  }

  updateEncounterDataset() {
    document.documentElement.dataset.survivorEncounterActiveCount = String(this.encounters.length);
    document.documentElement.dataset.survivorEncounterCollected = String(this.encounterCollected);
    document.documentElement.dataset.survivorEncounterMined = String(this.encounterMined);
    document.documentElement.dataset.survivorEncounterTriggerSerial = String(this.board?.getBoardVariable(BOARD_KEY_ENCOUNTER_SERIAL) || 0);
    document.documentElement.dataset.survivorEncounterTriggerType = String(this.board?.getBoardVariable(BOARD_KEY_ENCOUNTER_TYPE) || 0);
    document.documentElement.dataset.survivorEncounterDemoStep = String(this.board?.getBoardVariable(BOARD_KEY_ENCOUNTER_DEMO_STEP) || 0);
    if (!this.encounters.some(encounter => encounter.type === 'mine')) {
      document.documentElement.dataset.survivorEncounterMineProgress = '0.000';
    }
  }

  removeEncounter(encounter, { fade = false } = {}) {
    const index = this.encounters.indexOf(encounter);
    if (index >= 0) this.encounters.splice(index, 1);
    const destroy = () => {
      encounter.sprite?.destroy();
      encounter.ring?.destroy();
      encounter.progress?.destroy();
    };
    if (fade) {
      this.tweens.add({
        targets: [encounter.sprite, encounter.ring, encounter.progress].filter(Boolean),
        alpha: 0,
        duration: 220,
        onComplete: destroy,
      });
    } else {
      destroy();
    }
  }

  clearEncounters() {
    for (const encounter of this.encounters || []) {
      encounter.sprite?.destroy();
      encounter.ring?.destroy();
      encounter.progress?.destroy();
    }
    this.encounters = [];
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
      this.cameras.main.setZoom(BATTLE_CAMERA_ZOOM);
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

  syncBattleCamera({ snap = false } = {}) {
    if (!this.board || this.mode !== 'expedition') return;
    const player = this.board.playerUnit;
    const view = player ? this.unitViews.get(player.id) : null;
    if (!player?.alive || !view?.sprite) {
      document.documentElement.dataset.survivorPlayerVisible = 'false';
      return;
    }

    const camera = this.cameras.main;
    if (!camera) return;
    camera.setZoom(BATTLE_CAMERA_ZOOM);

    const viewportWidth = Number(camera.width || this.scale.width || STAGE.width);
    const viewportHeight = Number(camera.height || this.scale.height || STAGE.height);
    const visibleWorldWidth = viewportWidth / BATTLE_CAMERA_ZOOM;
    const visibleWorldHeight = viewportHeight / BATTLE_CAMERA_ZOOM;
    const maxScrollX = Math.max(0, WORLD.width - visibleWorldWidth);
    const maxScrollY = Math.max(0, WORLD.height - visibleWorldHeight);
    const targetScrollX = clamp(view.sprite.x - visibleWorldWidth / 2, 0, maxScrollX);
    const targetScrollY = clamp(view.sprite.y - visibleWorldHeight / 2, 0, maxScrollY);

    const nextScrollX = snap
      ? targetScrollX
      : PhaserRef.Math.Linear(camera.scrollX || 0, targetScrollX, 0.28);
    const nextScrollY = snap
      ? targetScrollY
      : PhaserRef.Math.Linear(camera.scrollY || 0, targetScrollY, 0.28);
    camera.setScroll(nextScrollX, nextScrollY);

    const screenX = Math.round((view.sprite.x - camera.scrollX) * BATTLE_CAMERA_ZOOM);
    const screenY = Math.round((view.sprite.y - camera.scrollY) * BATTLE_CAMERA_ZOOM);
    const margin = 72;
    const visible = screenX >= margin
      && screenX <= viewportWidth - margin
      && screenY >= margin
      && screenY <= viewportHeight - margin;
    document.documentElement.dataset.survivorCameraReady = 'true';
    document.documentElement.dataset.survivorCameraScrollX = String(Math.round(camera.scrollX));
    document.documentElement.dataset.survivorCameraScrollY = String(Math.round(camera.scrollY));
    document.documentElement.dataset.survivorPlayerScreenX = String(screenX);
    document.documentElement.dataset.survivorPlayerScreenY = String(screenY);
    document.documentElement.dataset.survivorPlayerVisible = String(visible);
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

  onUnitDamaged({ unit, damage, skill }) {
    const view = this.ensureUnitView(unit);
    view.sprite.setTint(unit.team === TEAM.PLAYER ? COLORS.red : COLORS.cream);
    this.time.delayedCall(70, () => view.sprite.clearTint());
    if (damage > 0) {
      this.playSfx('hit', {
        volume: unit.team === TEAM.PLAYER ? 0.64 : 0.88,
        rate: unit.team === TEAM.PLAYER ? 0.88 : 1,
        detune: unit.team === TEAM.PLAYER ? -120 : 0,
      });
    }
    if (skill?.dataId && skill.owner?.team === TEAM.PLAYER && this.runSkillLevels?.has(Number(skill.dataId))) {
      const count = Number(document.documentElement.dataset.survivorRunSkillDamageCount || 0) + 1;
      const total = Number(document.documentElement.dataset.survivorRunSkillDamageTotal || 0) + Number(damage || 0);
      document.documentElement.dataset.survivorRunSkillDamageCount = String(count);
      document.documentElement.dataset.survivorRunSkillDamageTotal = String(total);
      document.documentElement.dataset.survivorRunSkillLastDamage = `${skill.dataId}:${Math.round(Number(damage || 0))}`;
    }
    if (unit.team === TEAM.PLAYER || Math.random() < 0.22) {
      this.floatText(unit.x, unit.y - 32, formatNumber(damage), unit.team === TEAM.PLAYER ? '#ff6b55' : '#fff7dd');
    }
  }

  onUnitDied({ unit }) {
    const view = this.unitViews.get(unit.id);
    if (!view) return;
    if (unit.team !== TEAM.PLAYER) {
      const drop = this.collectRunResourceDrop();
      this.grantRunResourceDrop(drop, unit.x, unit.y);
      this.burstFx(unit.x, unit.y);
      this.playSfx('monsterDead');
    } else {
      this.playSfx('uiError', { volume: 0.72 });
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
    if (skill?.owner?.team === TEAM.PLAYER) {
      this.playSfx('attack', { volume: 0.78 });
    }
    if (skill?.dataId && skill.owner?.team === TEAM.PLAYER && this.runSkillLevels?.has(Number(skill.dataId))) {
      const count = Number(document.documentElement.dataset.survivorRunSkillSpawnCount || 0) + 1;
      document.documentElement.dataset.survivorRunSkillSpawnCount = String(count);
      document.documentElement.dataset.survivorRunSkillLastSpawn = String(skill.dataId);
      this.announceRunSkillCast(skill);
    }
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

  explosionFx(x, y, radius) {
    const blast = this.add.graphics();
    blast.setDepth(67);
    blast.fillStyle(0xffa43a, 0.22);
    blast.fillCircle(x, y, radius * 0.52);
    blast.lineStyle(7, 0xffe56f, 0.82);
    blast.strokeCircle(x, y, radius * 0.48);
    blast.lineStyle(3, 0xff6b55, 0.62);
    blast.strokeCircle(x, y, radius * 0.28);
    this.tweens.add({
      targets: blast,
      alpha: 0,
      scaleX: 1.18,
      scaleY: 1.18,
      duration: 360,
      ease: 'Quad.easeOut',
      onComplete: () => blast.destroy(),
    });
  }

  magnetFx(x, y) {
    const ring = this.add.graphics();
    ring.setDepth(66);
    ring.lineStyle(4, COLORS.cyan, 0.72);
    ring.strokeCircle(x, y, 76);
    ring.lineStyle(2, COLORS.cream, 0.5);
    ring.strokeCircle(x, y, 112);
    this.tweens.add({
      targets: ring,
      alpha: 0,
      scaleX: 1.55,
      scaleY: 1.55,
      duration: 620,
      ease: 'Quad.easeOut',
      onComplete: () => ring.destroy(),
    });
  }

  mineCompleteFx(x, y, texture) {
    for (let i = 0; i < 8; i += 1) {
      const chip = this.add.sprite(x, y, texture);
      chip.setDepth(62);
      chip.setScale(0.34);
      const angle = Math.PI * 2 * i / 8;
      this.tweens.add({
        targets: chip,
        x: x + Math.cos(angle) * PhaserRef.Math.Between(38, 84),
        y: y + Math.sin(angle) * PhaserRef.Math.Between(28, 68),
        alpha: 0,
        duration: 520,
        ease: 'Quad.easeOut',
        onComplete: () => chip.destroy(),
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
    this.playSfx('levelUp');
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
    renderHud(this);
    const usedSkillId = this.castRunChoiceSkill(skillDataId, { source: 'choice' });
    this.setRunSkillCooldown(skillDataId, usedSkillId ? this.runSkillCooldownTicks(skillDataId) : RUN_SKILL_RETRY_TICKS);
    this.floatCenter(`${choice.name} Lv.${nextLevel}`);
    this.playSfx('reward', { volume: 0.66 });

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

  announceRunSkillCast(skill) {
    const skillDataId = Number(skill?.dataId || 0);
    if (!skillDataId) return;

    const skillData = this.store?.getSkill?.(skillDataId);
    const profile = getSkillVfxProfile(skillDataId);
    const level = this.runSkillLevels?.get(skillDataId) || 1;
    const name = skillData?.name || profile?.name || `Skill ${skillDataId}`;
    const color = colorToHex(profile?.color || COLORS.gold);
    const count = Number(document.documentElement.dataset.survivorRunSkillFeedbackCount || 0) + 1;
    document.documentElement.dataset.survivorRunSkillFeedbackCount = String(count);
    document.documentElement.dataset.survivorRunSkillLastFeedback = String(skillDataId);
    document.documentElement.dataset.survivorRunSkillLastFeedbackName = name;

    this.flashRunSkillIcon(skillDataId);
    this.renderSkillCastFeed({
      serial: ++this.skillCastFeedSerial,
      skillDataId,
      name,
      level,
      color,
      iconSrc: skillIconSrcFor(skillData, skillDataId),
      icon: (SKILL_FAMILY_LABELS[profile?.family] || { icon: '術' }).icon,
    });

    const owner = skill.owner || this.board?.playerUnit;
    if (owner) this.floatText(owner.x, owner.y - 106, `${name} Lv.${level}`, color);
  }

  flashRunSkillIcon(skillDataId) {
    const icon = dom.profileSkillList?.querySelector(`[data-skill-id="${Number(skillDataId)}"]`);
    if (!icon) return;
    icon.classList.remove('is-casting');
    void icon.offsetWidth;
    icon.classList.add('is-casting');
    globalThis.setTimeout(() => icon.classList.remove('is-casting'), 820);
  }

  renderSkillCastFeed(entry) {
    if (!dom.skillCastFeed) return;
    this.skillCastFeedItems = [entry, ...(this.skillCastFeedItems || [])].slice(0, 2);
    renderSkillCastFeedItems(this.skillCastFeedItems);
    globalThis.setTimeout(() => {
      this.skillCastFeedItems = (this.skillCastFeedItems || []).filter(item => item.serial !== entry.serial);
      renderSkillCastFeedItems(this.skillCastFeedItems);
    }, 1500);
  }

  resetCompanionSkillCooldowns() {
    this.companionSkillReadyTicks = new Map();
    const tick = Number(this.board?.tick || 0);
    for (const companion of getActiveCompanions(this.sanctuary)) {
      this.companionSkillReadyTicks.set(companion.key, tick);
    }
    renderCompanionSkillDock(this);
  }

  castCompanionSkill(companionKey, { source = 'button' } = {}) {
    const companion = D1_COMPANION_BY_KEY.get(companionKey);
    const companionState = getCompanionState(this.sanctuary, companionKey);
    if (!companion || !companionState?.unlocked) {
      this.playSfx('uiError', { volume: 0.58 });
      return false;
    }
    if (this.mode !== 'expedition' || this.paused || this.levelChoiceOpen || this.board?.gameEnded) {
      this.playSfx('uiError', { volume: 0.48 });
      return false;
    }

    const tick = Number(this.board?.tick || 0);
    const readyTick = Number(this.companionSkillReadyTicks.get(companion.key) || 0);
    if (tick < readyTick) {
      this.playSfx('uiError', { volume: 0.44 });
      return false;
    }

    const player = this.board?.playerUnit;
    const usedSkillId = this.board?.startSkill?.(player, companion.skillDataId, null, {
      companionSkill: true,
      companionKey: companion.key,
      skillLevel: companionState.level || 1,
    });
    if (!usedSkillId) {
      this.companionSkillReadyTicks.set(companion.key, tick + RUN_SKILL_RETRY_TICKS);
      renderCompanionSkillDock(this);
      this.playSfx('uiError', { volume: 0.48 });
      return false;
    }

    this.companionSkillReadyTicks.set(
      companion.key,
      tick + Math.max(1, Math.round(Number(companion.cooldownSeconds || 1) * TICKS_PER_SECOND))
    );
    const previous = Number(document.documentElement.dataset.survivorCompanionSkillCasts || 0);
    document.documentElement.dataset.survivorCompanionSkillCasts = String(previous + 1);
    document.documentElement.dataset.survivorCompanionLastSkill = companion.key;
    document.documentElement.dataset.survivorCompanionLastSkillName = companion.skillName;
    document.documentElement.dataset.survivorCompanionLastSkillSource = source;
    this.applyCompanionSkillSideEffect(companion, companionState);
    this.floatCenter(`${companion.name} · ${companion.skillName}`);
    this.playSfx('attack', { volume: 0.62, rate: 1.08 });
    renderCompanionSkillDock(this);
    return true;
  }

  applyCompanionSkillSideEffect(companion, companionState) {
    const player = this.board?.playerUnit;
    if (!player?.alive) return;
    if (companion.key !== 'mio') return;

    const heal = Math.max(1, Math.round(Number(player.maxHp || 0) * (0.08 + Number(companionState.level || 1) * 0.015)));
    player.hp = Math.min(Number(player.maxHp || player.hp || 1), Number(player.hp || 0) + heal);
    document.documentElement.dataset.survivorCompanionMioHeal = String(heal);
    this.floatText(player.x, player.y - 76, `+${formatNumber(heal)}`, '#9ffcff');
    this.spawnCompanionShieldFx(player.x, player.y);
  }

  spawnCompanionShieldFx(x, y) {
    const shield = this.add.graphics();
    shield.setPosition(x, y);
    shield.setDepth(66);
    shield.lineStyle(5, COLORS.cyan, 0.78);
    shield.strokeCircle(0, 0, 66);
    shield.lineStyle(2, COLORS.cream, 0.42);
    shield.strokeCircle(0, 0, 48);
    this.tweens.add({
      targets: shield,
      alpha: 0,
      scaleX: 1.28,
      scaleY: 1.28,
      duration: 520,
      ease: 'Quad.easeOut',
      onComplete: () => shield.destroy(),
    });
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
    this.playSfx('uiClick', { volume: 0.56 });
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
    this.input.keyboard.on('keydown-Q', () => this.castCompanionSkill('kaede', { source: 'keyboard' }));
    this.input.keyboard.on('keydown-E', () => this.castCompanionSkill('mio', { source: 'keyboard' }));
    this.input.keyboard.on('keydown-F', () => this.castCompanionSkill('rin', { source: 'keyboard' }));

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
    this.makeEncounterTextures();
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

  makeEncounterTextures() {
    if (['encounterBomb', 'encounterMagnet', 'encounterPotion', 'encounterMine'].every(key => this.textures.exists(key))) {
      return;
    }

    const bomb = this.make.graphics({ add: false });
    bomb.fillStyle(0x171f18, 0.24);
    bomb.fillEllipse(34, 54, 58, 14);
    bomb.fillStyle(0x2a2d2b, 1);
    bomb.fillCircle(34, 36, 24);
    bomb.fillStyle(0xff7048, 1);
    bomb.fillCircle(28, 30, 7);
    bomb.lineStyle(6, 0x171f18, 1);
    bomb.strokeCircle(34, 36, 24);
    bomb.lineStyle(5, 0xffd66d, 1);
    bomb.lineBetween(49, 20, 60, 7);
    bomb.fillStyle(0xffe56f, 1);
    bomb.fillCircle(62, 6, 6);
    bomb.generateTexture('encounterBomb', 76, 72);
    bomb.destroy();

    const magnet = this.make.graphics({ add: false });
    magnet.fillStyle(0x171f18, 0.2);
    magnet.fillEllipse(36, 60, 60, 14);
    magnet.lineStyle(13, 0xd84b44, 1);
    magnet.beginPath();
    magnet.arc(36, 36, 24, Math.PI * 0.08, Math.PI * 0.92);
    magnet.strokePath();
    magnet.lineStyle(13, 0x36e0d4, 1);
    magnet.beginPath();
    magnet.arc(36, 36, 24, Math.PI * 1.08, Math.PI * 1.92);
    magnet.strokePath();
    magnet.fillStyle(0xf8ead1, 1);
    magnet.fillRoundedRect(8, 36, 14, 16, 4);
    magnet.fillRoundedRect(50, 36, 14, 16, 4);
    magnet.lineStyle(4, 0x171f18, 1);
    magnet.strokeRoundedRect(8, 36, 14, 16, 4);
    magnet.strokeRoundedRect(50, 36, 14, 16, 4);
    magnet.generateTexture('encounterMagnet', 78, 76);
    magnet.destroy();

    const potion = this.make.graphics({ add: false });
    potion.fillStyle(0x171f18, 0.2);
    potion.fillEllipse(34, 62, 54, 12);
    potion.fillStyle(0xf8ead1, 1);
    potion.fillRoundedRect(25, 8, 18, 14, 4);
    potion.fillStyle(0x36e0d4, 1);
    potion.fillRoundedRect(17, 20, 34, 42, 12);
    potion.fillStyle(0xb9fff4, 0.9);
    potion.fillRoundedRect(25, 28, 12, 22, 6);
    potion.lineStyle(5, 0x171f18, 1);
    potion.strokeRoundedRect(17, 20, 34, 42, 12);
    potion.strokeRoundedRect(25, 8, 18, 14, 4);
    potion.lineStyle(4, 0xf8ead1, 1);
    potion.lineBetween(34, 31, 34, 49);
    potion.lineBetween(25, 40, 43, 40);
    potion.generateTexture('encounterPotion', 72, 76);
    potion.destroy();

    const mine = this.make.graphics({ add: false });
    mine.fillStyle(0x171f18, 0.22);
    mine.fillEllipse(48, 72, 78, 16);
    mine.fillStyle(0x5f665d, 1);
    mine.fillRoundedRect(12, 36, 72, 34, 13);
    mine.fillStyle(0xd8d8c2, 1);
    mine.fillRoundedRect(24, 28, 34, 30, 11);
    mine.fillStyle(0x36e0d4, 0.9);
    mine.fillCircle(61, 45, 9);
    mine.fillStyle(0xffc64a, 0.95);
    mine.fillCircle(36, 47, 7);
    mine.lineStyle(5, 0x171f18, 1);
    mine.strokeRoundedRect(12, 36, 72, 34, 13);
    mine.strokeRoundedRect(24, 28, 34, 30, 11);
    mine.generateTexture('encounterMine', 96, 88);
    mine.destroy();
  }
}

function encounterDefinition(type) {
  return RANDOM_ENCOUNTERS.find(encounter => encounter.type === type) || null;
}

function encounterTypeFromId(typeId) {
  return ENCOUNTER_TYPE_BY_ID[Math.floor(Number(typeId) || 0)] || null;
}

function pickWeightedEncounterType() {
  const total = RANDOM_ENCOUNTERS.reduce((sum, encounter) => sum + Math.max(0, Number(encounter.weight || 0)), 0);
  let roll = Math.random() * Math.max(1, total);
  for (const encounter of RANDOM_ENCOUNTERS) {
    roll -= Math.max(0, Number(encounter.weight || 0));
    if (roll <= 0) return encounter.type;
  }
  return RANDOM_ENCOUNTERS[0]?.type || 'bomb';
}

function encounterColor(type) {
  switch (type) {
    case 'bomb': return 0xff9f38;
    case 'magnet': return 0x36e0d4;
    case 'potion': return 0x9ffcff;
    case 'mine': return 0xffd66d;
    default: return COLORS.cream;
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
  document.documentElement.dataset.survivorEncounterActiveCount = String(scene.encounters?.length || 0);
  document.documentElement.dataset.survivorEncounterCollected = String(scene.encounterCollected || 0);
  document.documentElement.dataset.survivorEncounterMined = String(scene.encounterMined || 0);
  document.documentElement.dataset.survivorEncounterTriggerSerial = String(board.getBoardVariable(BOARD_KEY_ENCOUNTER_SERIAL) || 0);
  document.documentElement.dataset.survivorEncounterTriggerType = String(board.getBoardVariable(BOARD_KEY_ENCOUNTER_TYPE) || 0);
  document.documentElement.dataset.survivorEncounterDemoStep = String(board.getBoardVariable(BOARD_KEY_ENCOUNTER_DEMO_STEP) || 0);
  document.documentElement.dataset.survivorMagnetActive = String(performance.now() < Number(scene.magnetUntil || 0));
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
  renderCompanionSkillDock(scene);

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

  dom.profileSkillList.innerHTML = Object.entries(rows).filter(([, slots]) => slots.length > 0).map(([kind, slots]) => `
    <div class="profile-skill-row profile-skill-row-${kind}" data-kind="${kind}">
      ${slots.map(slot => `
        <span
          class="profile-skill-icon"
          data-skill-id="${Number(slot.id || 0)}"
          data-run-level="${Number(slot.level || 0)}"
          style="--skill-color:${escapeHtml(slot.color)}"
          title="${escapeHtml(slot.name)}"
          aria-label="${escapeHtml(slot.name)}"
        >
          ${profileSkillIconHtml(slot)}<em>${slot.level ? `Lv.${slot.level}` : ''}</em>
        </span>
      `).join('')}
    </div>
  `).join('');
}

function renderSkillCastFeedItems(items = []) {
  if (!dom.skillCastFeed) return;
  dom.skillCastFeed.innerHTML = items.map(item => `
    <span class="skill-cast-chip" data-skill-id="${Number(item.skillDataId || 0)}" style="--skill-color:${escapeHtml(item.color || '#ffc64a')}">
      <i aria-hidden="true">${item.iconSrc ? `<img src="${escapeHtml(item.iconSrc)}" alt="" loading="eager" decoding="async">` : escapeHtml(item.icon || '術')}</i>
      <span>${escapeHtml(item.name || 'Skill')} Lv.${Number(item.level || 1)}</span>
    </span>
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
  let productionPercent = getCompanionBonus(state, 'home_production_percent');
  const builtInstances = getAllBuildingInstances(state).filter(instance => instance.status === 'built');

  for (const instance of builtInstances) {
    const building = BUILDING_BY_KEY.get(instance.buildingKey);
    const effect = getLevelData(building, getInstanceBuildingLevel(state, building, instance))?.effect || {};
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

function getBuildingResourceRatesPerMinute(state, building, level = getBuildingLevel(state, building), instance = getPrimaryBuildingInstance(state, building)) {
  const rates = Object.fromEntries(HOME_RESOURCE_KEYS.map(key => [key, 0]));
  if (!building || !instance || instance.status !== 'built') return rates;
  const effect = getLevelData(building, level)?.effect || {};
  let productionPercent = getCompanionBonus(state, 'home_production_percent');
  for (const builtInstance of getAllBuildingInstances(state).filter(row => row.status === 'built')) {
    const builtBuilding = BUILDING_BY_KEY.get(builtInstance.buildingKey);
    const builtEffect = getLevelData(builtBuilding, getInstanceBuildingLevel(state, builtBuilding, builtInstance))?.effect || {};
    productionPercent += Number(builtEffect.all_production_percent || 0);
  }
  for (const key of HOME_RESOURCE_KEYS) {
    for (const [effectKey, multiplier] of HOME_RESOURCE_RATE_EFFECTS[key] || []) {
      rates[key] += Number(effect[effectKey] || 0) * multiplier;
    }
  }
  const multiplier = Math.max(0, 1 + productionPercent / 100);
  for (const key of HOME_RESOURCE_KEYS) {
    rates[key] = Math.max(0, rates[key] * multiplier);
  }
  return rates;
}

function getPrimaryHomeRateEntry(rates) {
  return HOME_RESOURCE_KEYS
    .map(key => ({ key, rate: Number(rates?.[key] || 0) }))
    .sort((a, b) => b.rate - a.rate)[0] || { key: 'wood', rate: 0 };
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
    const amountText = formatHomeResourceAmount(amount);
    const value = row.querySelector('b');
    const rateText = row.querySelector('.resource-rate');
    if (value) value.textContent = amountText;
    if (rateText) rateText.textContent = formatHomeRate(rate);
    row.classList.toggle('is-income-idle', rate <= 0);
    row.setAttribute('aria-label', `${HOME_RESOURCE_LABELS[key]} ${amountText} · 분당 ${formatHomeRate(rate)}`);
  }
}

function syncHomeIntegratedCollectStatus(rates) {
  const totalRate = HOME_RESOURCE_KEYS.reduce((sum, key) => sum + Number(rates?.[key] || 0), 0);
  document.documentElement.dataset.homeIntegratedCollectStatus = totalRate > 0 ? 'auto' : 'idle';
}

function getActiveHomeProductionSourceCount(state) {
  const activeSources = getAllBuildingInstances(state).filter(instance => {
    if (instance.status !== 'built') return false;
    const building = BUILDING_BY_KEY.get(instance.buildingKey);
    const effect = getLevelData(building, getInstanceBuildingLevel(state, building, instance))?.effect || {};
    return HOME_RESOURCE_KEYS.some(key =>
      (HOME_RESOURCE_RATE_EFFECTS[key] || []).some(([effectKey, multiplier]) => Number(effect[effectKey] || 0) * multiplier > 0)
    );
  }).length;
  return activeSources;
}

function formatHomeResourceAmount(amount) {
  const safe = Math.max(0, Number(amount) || 0);
  if (safe >= 2000 && safe < 100000) {
    return `${(safe / 1000).toFixed(1).replace(/\\.0$/, '')}K`;
  }
  return Math.floor(safe).toLocaleString('en-US');
}

function formatHomeRate(rate) {
  const safe = Math.max(0, Number(rate) || 0);
  if (safe <= 0) return '+0/m';
  if (safe < 1) return `+${safe.toFixed(2).replace(/0+$/, '').replace(/\.$/, '')}/m`;
  if (safe < 10 && !Number.isInteger(safe)) return `+${safe.toFixed(1).replace(/\.0$/, '')}/m`;
  return `+${formatEffectNumber(safe)}/m`;
}

function isHomeBuildTrayOpen(state) {
  return activeHomeTab === 'sanctuary' && homeBuildTrayOpen && !state?.buildPlanBuildingKey;
}

function syncHomeTabs(state) {
  const activeTab = HOME_TAB_KEYS.has(activeHomeTab) ? activeHomeTab : 'sanctuary';
  activeHomeTab = activeTab;
  const buildTrayOpen = isHomeBuildTrayOpen(state);
  document.documentElement.dataset.homeActiveTab = activeTab;
  document.documentElement.dataset.homeBuildTray = buildTrayOpen ? 'open' : 'closed';
  dom.homeTabs?.querySelectorAll('[data-home-tab]').forEach(tab => {
    const selected = tab.dataset.homeTab === activeTab;
    tab.classList.toggle('is-active', selected);
    tab.setAttribute('aria-selected', selected ? 'true' : 'false');
  });
}

function updateHomeBuildGhostPointer(event) {
  if (!dom.homeScreen || !event || event.clientX == null || event.clientY == null) return;
  const rect = dom.homeScreen.getBoundingClientRect();
  homeBuildGhostPointer.x = clamp(event.clientX - rect.left, 0, rect.width);
  homeBuildGhostPointer.y = clamp(event.clientY - rect.top, 0, rect.height);
  homeBuildGhostPointer.ready = true;
  if (!dom.homeBuildGhost) return;
  dom.homeBuildGhost.style.setProperty('--home-build-ghost-x', `${homeBuildGhostPointer.x.toFixed(1)}px`);
  dom.homeBuildGhost.style.setProperty('--home-build-ghost-y', `${homeBuildGhostPointer.y.toFixed(1)}px`);
}

function syncHomeBuildGhost(state) {
  if (!dom.homeBuildGhost) return;
  const building = BUILDING_BY_KEY.get(state?.buildPlanBuildingKey);
  if (!building) {
    dom.homeBuildGhost.hidden = true;
    dom.homeBuildGhost.innerHTML = '';
    document.documentElement.dataset.homeBuildGhost = 'hidden';
    return;
  }

  if (!homeBuildGhostPointer.ready && dom.homeScreen) {
    const rect = dom.homeScreen.getBoundingClientRect();
    homeBuildGhostPointer.x = rect.width * 0.5;
    homeBuildGhostPointer.y = rect.height * 0.46;
  }

  dom.homeBuildGhost.hidden = false;
  dom.homeBuildGhost.dataset.buildingKey = building.key;
  dom.homeBuildGhost.style.setProperty('--home-build-ghost-x', `${homeBuildGhostPointer.x.toFixed(1)}px`);
  dom.homeBuildGhost.style.setProperty('--home-build-ghost-y', `${homeBuildGhostPointer.y.toFixed(1)}px`);
  dom.homeBuildGhost.innerHTML = `
    <div class="home-build-ghost-art" aria-hidden="true">${renderBuildingCatalogImage(building)}</div>
    <b>${escapeHtml(building.name)}</b>
  `;
  document.documentElement.dataset.homeBuildGhost = building.key;
}

function renderHome(scene, options = {}) {
  const state = scene.sanctuary;
  syncCompanionUnlocks(state, { announce: false });
  const completedBuildings = completeFinishedConstructions(state);
  if (completedBuildings.length) saveSanctuary(state);
  const resourceRates = getHomeResourceRatesPerMinute(state);
  renderHomeResourceRows(state, resourceRates);
  syncHomeIntegratedCollectStatus(resourceRates);
  renderHomeCompanions(state);
  syncHomeTabs(state);
  renderHomeBuildList(state);
  if (options.animateGains) {
    for (const [key, amount] of Object.entries(options.gains || {})) {
      scene.pulseHomeResourceGain?.(key, amount);
    }
  }
  dom.shrineLevelText.textContent = state.shrineLevel;
  const residentCapacity = HOME_BUILT_CITY_DEMO_MODE ? 28 : state.residents + 3;
  dom.residentText.textContent = `${state.residents}/${residentCapacity}`;
  const nextExpansionCost = getNextExpansionCost(state) || Number(state.lightNeed || 100);
  dom.lightFill.style.width = `${clamp(state.light / nextExpansionCost * 100, 0, 100)}%`;
  dom.lightText.textContent = `${Math.floor(state.light)} / ${nextExpansionCost}`;
  dom.loopLog.textContent = state.lastLog;

  dom.homeHexGrid.innerHTML = renderHomeSettlement(state)
    + HEXES.map(tile => renderHex(tile, state)).join('')
    + renderHomeBuildings(state);
  dom.homeBuildingPanel.innerHTML = renderBuildingPanel(state);
  globalThis.__NINJA2_HOME_SKINS_REFRESH__?.();
  document.documentElement.dataset.survivorMode = 'home';
  document.documentElement.dataset.survivorGameId = GAME_ID;
  document.documentElement.dataset.homeDemo = HOME_BUILT_CITY_DEMO_MODE ? 'city' : (HOME_START_DEMO_MODE ? 'start' : 'live');
  document.documentElement.dataset.homeResourceRates = HOME_RESOURCE_KEYS
    .map(key => `${key}:${Number(resourceRates[key] || 0).toFixed(3)}`)
    .join(',');
  document.documentElement.dataset.homeResourceAmounts = HOME_RESOURCE_KEYS
    .map(key => `${key}:${Math.floor(Number(state[key] || 0))}`)
    .join(',');
  document.documentElement.dataset.homeStageClears = String(state.stageClears || 0);
  document.documentElement.dataset.homeCompanionUnlockedCount = String(getActiveCompanions(state).length);
  document.documentElement.dataset.homeCompanionSummonableCount = String(getSummonableCompanions(state).length);
  document.documentElement.dataset.homeCompanionGachaPool = getCompanionGachaPool(state).map(companion => companion.key).join(',');
  document.documentElement.dataset.homeCompanionGachaPulls = String(state.companionGachaPulls || 0);
  document.documentElement.dataset.homeCompanionRoster = D1_COMPANIONS
    .map(companion => `${companion.key}:${getCompanionRosterStatus(state, companion)}`)
    .join(',');
  document.documentElement.dataset.homeBuildPlan = state.buildPlanBuildingKey || '';
  document.documentElement.dataset.homeBuildListCount = String(getHomeBuildListBuildings(state).length);
  document.documentElement.dataset.homeBuildingInstanceCount = String(getAllBuildingInstances(state).length);
  document.documentElement.dataset.homeRepeatableBuildingCounts = BUILDINGS
    .filter(building => isRepeatableBuilding(building))
    .map(building => `${building.key}:${getBuildingInstanceCount(state, building)}/${getMaxBuildingInstances(state, building)}`)
    .join(',');
  syncHomeBuildGhost(state);
  syncHomeTabs(state);
}

function renderHomeCompanions(state) {
  if (!dom.homeCompanions) return;
  dom.homeCompanions.hidden = true;
  dom.homeCompanions.innerHTML = '';
}

function getHomeBuildListBuildings(state) {
  return BUILDINGS
    .filter(building => canBuildAnotherBuilding(state, building))
    .filter(building => isBuildingVisible(state, building) || Boolean(getPendingBuildingPlacement(state, building)));
}

function renderHomeBuildList(state) {
  if (!dom.homeBuildList) return;
  const buildings = getHomeBuildListBuildings(state);
  const open = isHomeBuildTrayOpen(state);
  if (dom.homeBuildModal) {
    dom.homeBuildModal.hidden = !open;
    dom.homeBuildModal.setAttribute('aria-hidden', open ? 'false' : 'true');
  }
  if (dom.homeBuildModalSubtitle) {
    dom.homeBuildModalSubtitle.textContent = buildings.length
      ? '지을 건물을 고른 뒤 빈 타일을 선택하세요.'
      : '새 후보가 열리면 이 목록에 표시됩니다.';
  }
  dom.homeBuildList.hidden = false;
  dom.homeBuildList.innerHTML = buildings.length
    ? buildings.map(building => renderHomeBuildListCard(state, building)).join('')
    : renderHomeBuildListEmpty(state);
}

function renderHomeBuildListEmpty(state) {
  const shrineLevel = Math.max(1, Number(state?.shrineLevel) || 1);
  const stageClears = Math.max(0, Number(state?.stageClears) || 0);
  return `
    <div class="home-build-empty" role="status" aria-live="polite">
      <i aria-hidden="true">!</i>
      <b>지을 수 있는 건물이 없습니다</b>
      <span>성소 Lv.${shrineLevel} · 탐험 클리어 ${stageClears}회</span>
      <small>성소를 강화하거나 새 타일을 정화하면 다음 건물 후보가 여기에 표시됩니다.</small>
    </div>
  `;
}

function renderHomeBuildListCard(state, building) {
  const status = getBuildingStatus(state, building, null);
  const selected = state.buildPlanBuildingKey === building.key;
  const locked = status === 'locked-slot' && !isBuildingUnlocked(state, building);
  const constructing = false;
  const detail = formatBuildListDetail(state, building, status);
  const label = `${building.name} ${detail}`;
  const construction = getConstructionForNextInstance(state, building);
  const effectStats = formatEffectStats(getLevelData(building, 1)?.effect || {}).slice(0, 3);
  const canAfford = canAffordCost(state, construction.cost);
  const count = getBuildingInstanceCount(state, building);
  const max = getMaxBuildingInstances(state, building);
  return `
    <button
      class="home-build-card is-${status}${selected ? ' is-selected' : ''}${locked ? ' is-locked' : ''}"
      type="button"
      data-select-build-building="${building.key}"
      ${constructing ? 'disabled' : ''}
      aria-pressed="${selected ? 'true' : 'false'}"
      aria-label="${escapeHtml(label)}"
    >
      <div class="home-build-card-art" aria-hidden="true">${renderBuildingCatalogImage(building)}</div>
      <div class="home-build-card-copy">
        <span class="home-build-card-status">${escapeHtml(detail)}</span>
        <b>${escapeHtml(building.name)}</b>
        <small>${escapeHtml(building.output || building.role || '')} · ${escapeHtml(building.footprint || '1x1')}${isRepeatableBuilding(building) ? ` · ${count}/${max}` : ''}</small>
        <div class="home-build-card-stats">
          ${effectStats.map(stat => `<em>${escapeHtml(stat)}</em>`).join('')}
        </div>
        <div class="home-build-card-costs ${canAfford ? 'is-affordable' : 'is-missing'}">
          ${renderBuildCostChips(state, construction.cost)}
        </div>
      </div>
      <span class="home-build-card-action">
        <b>${escapeHtml(getBuildCardActionCopy(state, building, status))}</b>
        <small>${escapeHtml(formatSecondsShort(construction.seconds || 0))}</small>
      </span>
    </button>
  `;
}

function renderBuildingCatalogImage(building) {
  if (hasHomeBuildingSprite(building)) return renderHomeBuildingSprite(building);
  return `<span class="building-blueprint">${escapeHtml(buildingBlueprintGlyph(building))}</span>`;
}

function renderBuildCostChips(state, cost = {}) {
  const entries = Object.entries(cost).filter(([, value]) => Number(value) > 0);
  if (!entries.length) return '<span class="home-build-cost is-free">무료</span>';
  return entries.map(([key, value]) => {
    const available = getStateResource(state, key);
    const missing = available < Number(value || 0);
    const resource = HOUSING_TECH.resources[key] || {};
    return `
      <span class="home-build-cost ${missing ? 'is-missing' : ''}">
        <i aria-hidden="true">${escapeHtml(resource.icon || '•')}</i>
        <b>${escapeHtml(formatNumber(value))}</b>
      </span>
    `;
  }).join('');
}

function getBuildCardActionCopy(state, building, status) {
  if (status === 'constructing') return formatRemainingSeconds(getConstructionRemaining(state, building));
  if (status === 'buildable' || status === 'needs-placement') return canAffordCost(state, getConstructionForNextInstance(state, building).cost) ? '선택' : '부족';
  if (status === 'locked-slot' || !isBuildingUnlocked(state, building)) return '잠금';
  return '확인';
}

function formatBuildListDetail(state, building, status) {
  const count = getBuildingInstanceCount(state, building);
  const max = getMaxBuildingInstances(state, building);
  const construction = getConstructionForNextInstance(state, building);
  const countCopy = isRepeatableBuilding(building) ? ` ${count}/${max}` : '';
  if (status === 'buildable') return getPendingBuildingPlacement(state, building)
    ? `${formatPrimaryCost(construction.cost)} · 터 선택됨${countCopy}`
    : `${formatPrimaryCost(construction.cost)} · 타일${countCopy}`;
  if (status === 'needs-placement') return `${formatPrimaryCost(construction.cost)} · 타일 선택${countCopy}`;
  if (isBuildingUnlocked(state, building) && getPendingBuildingPlacement(state, building)) return `터 확인 필요${countCopy}`;
  return formatUnlockShort(building);
}

function renderCompanionSkillDock(scene) {
  if (!dom.companionSkillDock) return;
  ensureCompanionSkillButtons(scene);
  const tick = Number(scene?.board?.tick || 0);
  let readyCount = 0;
  for (const companion of D1_COMPANIONS) {
    const companionState = getCompanionState(scene?.sanctuary, companion);
    const unlocked = Boolean(companionState?.unlocked);
    const readyTick = Number(scene?.companionSkillReadyTicks?.get(companion.key) || 0);
    const remainingTicks = unlocked ? Math.max(0, readyTick - tick) : 0;
    const ready = unlocked && scene?.mode === 'expedition' && remainingTicks <= 0 && !scene?.levelChoiceOpen && !scene?.paused && !scene?.board?.gameEnded;
    if (ready) readyCount += 1;
    const remainingSeconds = remainingTicks / TICKS_PER_SECOND;
    const label = unlocked
      ? ready
        ? 'READY'
        : remainingSeconds >= 10
          ? Math.ceil(remainingSeconds).toString()
          : remainingSeconds > 0
            ? remainingSeconds.toFixed(1)
            : 'WAIT'
      : '잠금';
    const progress = unlocked && remainingTicks > 0
      ? clamp(1 - remainingTicks / Math.max(1, Number(companion.cooldownSeconds || 1) * TICKS_PER_SECOND), 0, 1)
      : 1;
    const button = dom.companionSkillDock.querySelector(`[data-companion-skill="${companion.key}"]`);
    if (!button) continue;
    button.classList.toggle('is-ready', ready);
    button.classList.toggle('is-unlocked', unlocked);
    button.classList.toggle('is-locked', !unlocked);
    button.disabled = !ready;
    button.style.setProperty('--companion-color', companion.color);
    button.style.setProperty('--cooldown-angle', `${(progress * 360).toFixed(1)}deg`);
    button.querySelector('em').textContent = label;
    button.querySelector('b').textContent = companion.name;
  }
  const activeCount = getActiveCompanions(scene?.sanctuary).length;
  document.documentElement.dataset.survivorCompanionSkillCount = String(activeCount);
  document.documentElement.dataset.survivorCompanionReadyCount = String(readyCount);
  document.documentElement.dataset.survivorCompanionRoster = D1_COMPANIONS
    .map(companion => `${companion.key}:${getCompanionRosterStatus(scene?.sanctuary, companion)}`)
    .join(',');
}

function ensureCompanionSkillButtons(scene) {
  if (dom.companionSkillDock.dataset.buttonsReady === 'true') return;
  dom.companionSkillDock.dataset.buttonsReady = 'true';
  dom.companionSkillDock.innerHTML = D1_COMPANIONS.map(companion => {
    const skill = scene?.store?.getSkill?.(companion.skillDataId);
    const iconSrc = skillIconSrcFor(skill, companion.skillDataId);
    const icon = iconSrc
      ? `<img class="companion-skill-img" src="${escapeHtml(iconSrc)}" alt="" loading="eager" decoding="async">`
      : escapeHtml(companion.icon);
    return `
      <button
        class="companion-skill is-locked"
        type="button"
        data-companion-skill="${companion.key}"
        style="--companion-color:${escapeHtml(companion.color)};--cooldown-angle:360deg"
        disabled
        aria-label="${escapeHtml(`${companion.name} ${companion.skillName}`)}"
      >
        <span class="companion-skill-icon" aria-hidden="true">${icon}</span>
        <b>${escapeHtml(companion.name)}</b>
        <em>잠금</em>
      </button>
    `;
  }).join('');
}

function renderHex(tile, state) {
  const entry = getVisibleBuildingEntryForTile(tile, state);
  const building = entry?.building || null;
  const instance = entry?.instance || null;
  const buildingKey = building?.key || null;
  const buildingStatus = building ? getBuildingStatus(state, building, instance) : null;
  const tileState = getTileRenderState(tile, state);
  const placementCandidate = !buildingKey && isPlacementCandidateTile(state, tile);
  const stateClass = buildingKey
    ? `building-slot ${buildingStatus}${buildingStatus === 'built' ? ' built occupied' : ''}`
    : tileState;
  const selected = buildingKey
    ? state.selectedBuildingInstanceId === instance?.id || (!state.selectedBuildingInstanceId && state.selectedBuildingKey === buildingKey)
    : tile.selected;
  const buildingClass = building ? ` occupied-${building.kind} occupied-${buildingKey}` : '';
  const placementClass = placementCandidate ? ' placement-candidate' : '';
  const railClass = !buildingKey && tileState === 'expand' && tile.q <= -2 ? ' rail-adjacent' : '';
  const style = `--q:${tile.q};--r:${tile.r}`;
  let content = '';
  if (buildingKey && buildingStatus === 'built') {
    content = '';
  } else if (buildingKey && buildingStatus === 'constructing') {
    content = `<div class="hex-cost">${formatRemainingSeconds(getConstructionRemaining(state, building, instance))}</div>`;
  } else if (buildingKey && buildingStatus === 'buildable') {
    content = '<div class="hex-build-marker" aria-hidden="true"></div>';
  } else if (buildingKey) {
    content = '<div class="hex-lock-mark" aria-hidden="true"></div>';
  } else if (stateClass === 'expand') {
    content = `<div class="hex-cost">${tile.cost}</div>`;
  } else if (tileState === 'locked') {
    content = `<div class="hex-lock-mark" aria-hidden="true"></div>${renderUnpurifiedTileCost(tile)}`;
  } else if (tileState === 'fog') {
    content = `<div class="hex-fog-mark" aria-hidden="true"></div>${renderUnpurifiedTileCost(tile)}`;
  } else if (placementCandidate) {
    const plannedBuilding = BUILDING_BY_KEY.get(state.buildPlanBuildingKey);
    content = `<div class="hex-placement-marker" aria-hidden="true">${escapeHtml(buildingBlueprintGlyph(plannedBuilding))}</div>`;
  } else if (tileState === 'empty') {
    content = '<div class="hex-build-marker" aria-hidden="true"></div>';
  }
  const data = buildingKey
    ? ` data-building-key="${buildingKey}" data-building-instance-id="${instance?.id || ''}"`
    : ` data-tile-id="${tile.id}"`;
  return `<div class="home-hex ${stateClass}${buildingClass}${placementClass}${railClass}${selected ? ' selected' : ''}" style="${style}"${data}>${content}</div>`;
}

function renderUnpurifiedTileCost(tile) {
  const cost = Number(tile?.cost || 0);
  return cost > 0 ? `<div class="hex-cost hex-cost-muted">${formatNumber(cost)}</div>` : '';
}

function renderHomeSettlement(state) {
  const paths = HOME_PATHS.map(([from, to, size]) => renderHomePath(from, to, size)).join('');
  const foundations = getHomeBuildingEntries(state)
    .map(entry => {
      const base = entry.building.base || { kind: 'yard', w: entry.w, h: 72, dx: 0, dy: 30 };
      const status = getBuildingStatus(state, entry.building, entry.instance);
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
      const level = getInstanceBuildingLevel(state, building, entry.instance);
      const output = formatBuildingBubble(building, level);
      const status = getBuildingStatus(state, building, entry.instance);
      const selected = state.selectedBuildingInstanceId === entry.instance?.id;
      const isImageReady = status === 'built'
        && ['existing', 'generated'].includes(building.assetStatus)
        && hasHomeBuildingSprite(building);
      const image = isImageReady
        ? renderHomeBuildingSprite(building)
        : `<div class="building-blueprint"><span aria-hidden="true">${buildingBlueprintGlyph(building)}</span></div>`;
      const badge = status === 'built'
        ? `Lv.${level}`
        : status === 'constructing'
          ? formatRemainingSeconds(getConstructionRemaining(state, building, entry.instance))
          : status === 'buildable'
            ? '건설'
            : '잠금';
      const bubble = status === 'built'
        ? output
        : status === 'constructing'
          ? `${Math.round(getConstructionProgress(state, building, entry.instance) * 100)}%`
          : status === 'buildable'
            ? formatPrimaryCost(building.construction?.cost)
            : formatUnlockShort(building);
      const style = `--x:${x.toFixed(1)}px;--y:${y.toFixed(1)}px;--w:${w}px;--h:${h}px;--z:${Math.round(220 + y)}`;
      return `
        <div class="home-building home-building-${building.kind} is-${status}${selected ? ' selected' : ''}" style="${style}" data-building-key="${building.key}" data-building-instance-id="${entry.instance?.id || ''}" data-footprint="${building.footprint}" aria-label="${formatBuildingInstanceName(building, entry.instance)} ${building.footprint}">
          ${image}
          <b>${badge}</b>
          <div class="bubble" aria-label="${building.output} ${bubble}">${bubble}</div>
        </div>
      `;
    })
    .join('');
}

function formatBuildingInstanceName(building, instance) {
  if (!building) return '';
  const ordinal = getBuildingInstanceOrdinal(instance);
  return isRepeatableBuilding(building) && ordinal > 1
    ? `${building.name} #${ordinal}`
    : building.name;
}

function buildingBlueprintGlyph(building) {
  return {
    bamboo: '▥',
    granary: '▤',
    soul: '◌',
    wood: '▰',
    stone: '◆',
    training: '⚔',
    leaf: '✚',
    resident: '●●',
    workshop: '▣',
    guard: '▴',
    scout: '⌖',
    iron: '◆',
  }[building?.kind] || '+';
}

function getHomeBuildingEntries(state) {
  return getAllBuildingInstances(state).map(instance => {
    const building = BUILDING_BY_KEY.get(instance.buildingKey);
    if (!building) return null;
    const tileIds = getInstancePlacement(instance)?.tiles || [];
    const tiles = tileIds.map(tileId => HEX_BY_ID.get(tileId)).filter(Boolean);
    const placement = getInstancePlacement(instance);
    const tile = HEX_BY_ID.get(placement?.anchorTile) || tiles[0];
    const visual = building.visual || {};
    const tileX = tiles.length ? tiles.reduce((sum, footprintTile) => sum + hexCenterX(footprintTile), 0) / tiles.length : hexCenterX(tile);
    const tileY = tiles.length ? tiles.reduce((sum, footprintTile) => sum + hexCenterY(footprintTile), 0) / tiles.length : hexCenterY(tile);
    const x = tileX + (visual.dx || 0);
    const y = tileY + (visual.dy || 0);
    return { building, instance, tile, tiles, tileX, tileY, x, y, w: visual.w || 96, h: visual.h || 96 };
  }).filter(entry => entry && entry.tiles.length);
}

function renderBuildingPanel(state) {
  const building = BUILDING_BY_KEY.get(state.selectedBuildingKey) || BUILDING_BY_KEY.get('lantern_shrine');
  const instance = state.buildPlanBuildingKey === building.key ? null : getPrimaryBuildingInstance(state, building);
  const status = getBuildingStatus(state, building, instance);
  const level = getInstanceBuildingLevel(state, building, instance);
  const currentLevel = getLevelData(building, level);
  const previewLevel = currentLevel || getLevelData(building, 1);
  const nextLevel = getLevelData(building, level + 1);
  const upgrade = status === 'built' ? nextLevel?.levelUp : null;
  const construction = getConstructionForNextInstance(state, building);
  const effectStats = formatEffectStats(previewLevel?.effect || {}).slice(0, 2);
  const title = status === 'built' ? `${formatBuildingInstanceName(building, instance)} Lv.${level}` : building.name;
  const nextCopy = panelStatusCopy(state, building, status, upgrade, instance);
  const button = building.key === COMPANION_MANAGEMENT_BUILDING_KEY && status === 'built'
    ? companionPanelActionButton(state)
    : panelActionButton(state, building, status, upgrade, construction, instance);
  const companionManagement = building.key === COMPANION_MANAGEMENT_BUILDING_KEY
    ? renderCompanionManagementPanel(state, building, status)
    : '';
  const collectChip = renderIntegratedCollectChip(state, building, status, level, instance);
  const imageReady = status === 'built'
    && ['existing', 'generated'].includes(building.assetStatus)
    && hasHomeBuildingSprite(building);
  const icon = imageReady
    ? renderHomeBuildingSprite(building)
    : `<span>${building.icon || ''}</span>`;
  return `
    <div class="panel-building-icon panel-building-icon-${building.kind}">${icon}</div>
    <div class="panel-building-copy">
      <strong>${title}</strong>
      <span>${nextCopy}</span>
      <div class="mini-progress"><i style="width:${panelProgress(state, building, status, instance)}%"></i></div>
      <div class="panel-stats">
        ${effectStats.map(stat => `<div class="panel-stat">${stat}</div>`).join('')}
      </div>
      ${companionManagement}
    </div>
    <div class="panel-action-stack">
      ${collectChip}
      ${button}
    </div>
  `;
}

function renderIntegratedCollectChip(state, building, status, level, instance = getPrimaryBuildingInstance(state, building)) {
  const totalRates = getHomeResourceRatesPerMinute(state);
  const totalRate = HOME_RESOURCE_KEYS.reduce((sum, key) => sum + Number(totalRates[key] || 0), 0);
  const selectedRates = getBuildingResourceRatesPerMinute(state, building, level, instance);
  const selectedEntry = getPrimaryHomeRateEntry(selectedRates);
  const fallbackEntry = getPrimaryHomeRateEntry(totalRates);
  const activeSources = getActiveHomeProductionSourceCount(state);
  const resourceKey = selectedEntry.rate > 0 ? selectedEntry.key : fallbackEntry.rate > 0 ? fallbackEntry.key : 'none';
  const rate = selectedEntry.rate > 0 ? selectedEntry.rate : fallbackEntry.rate;
  const autoCollecting = totalRate > 0 && status === 'built';
  const label = autoCollecting ? '자동' : status === 'built' ? '대기' : '생산';
  const detail = autoCollecting
    ? selectedEntry.rate > 0
      ? formatHomeRate(rate)
      : `${activeSources}곳`
    : status === 'built'
      ? '+0/m'
      : '준비중';
  const aria = autoCollecting
    ? `생산 자원 자동 수집 ${HOME_RESOURCE_LABELS[resourceKey] || ''} ${detail}`
    : `생산 상태 ${label} ${detail}`;
  return `
    <div
      class="panel-collect-chip panel-collect-resource-${resourceKey}${autoCollecting ? ' is-auto' : ' is-idle'}"
      role="status"
      aria-label="${escapeHtml(aria)}"
    >
      <i aria-hidden="true"></i>
      <span>${escapeHtml(label)}</span>
      <small>${escapeHtml(detail)}</small>
    </div>
  `;
}

function companionPanelActionButton(state) {
  const pool = getCompanionGachaPool(state);
  const cost = getCompanionGachaCost(state);
  const canPay = canAffordCost(state, cost);
  const disabled = pool.length === 0 || !canPay;
  const label = disabled
    ? pool.length === 0
      ? '풀 없음'
      : formatMissingCost(state, cost)
    : '랜덤';
  return `
    <button class="panel-upgrade panel-gacha-action" type="button" data-companion-gacha="roll" ${disabled ? 'disabled' : ''}>
      <span>${escapeHtml(label)}</span>
      <small>${escapeHtml(pool.length ? `소환 · ${formatCost(cost)}` : '조건 필요')}</small>
    </button>
  `;
}

function renderCompanionManagementPanel(state, building, status) {
  const built = status === 'built';
  const pool = getCompanionGachaPool(state);
  return `
    <div class="companion-management" data-companion-management="${building.key}">
      ${D1_COMPANIONS.map(companion => renderCompanionGachaPoolRow(state, companion, built, pool)).join('')}
    </div>
  `;
}

function renderCompanionGachaPoolRow(state, companion, managementBuilt, pool) {
  const row = getCompanionState(state, companion);
  const status = getCompanionRosterStatus(state, companion);
  const summoned = status === 'summoned';
  const inPool = pool.some(poolCompanion => poolCompanion.key === companion.key);
  const label = !managementBuilt
    ? '건물 필요'
    : summoned
      ? '중복 가능'
      : inPool
        ? `${companionGachaChance(companion, pool)}%`
        : companion.lockedCopy;
  const detail = summoned
    ? `보유 · Lv.${row?.level || 1}`
    : inPool
      ? '가챠 풀'
      : '미등장';
  return `
    <div
      class="companion-summon-row companion-gacha-row is-${status}"
      style="--companion-color:${escapeHtml(companion.color)}"
      aria-label="${escapeHtml(`${companion.name} ${label}`)}"
    >
      <i aria-hidden="true">${escapeHtml(companion.icon)}</i>
      <span><b>${escapeHtml(companion.name)}</b><em>${escapeHtml(detail)}</em></span>
      <strong>${escapeHtml(label)}</strong>
    </div>
  `;
}

function panelStatusCopy(state, building, status, upgrade, instance = getPrimaryBuildingInstance(state, building)) {
  if (status === 'built') {
    const discount = getCompanionBonus(state, 'upgrade_cost_reduction_percent');
    return upgrade
      ? `다음 Lv.${getInstanceBuildingLevel(state, building, instance) + 1} · ${formatSecondsShort(upgrade.seconds)}${discount ? ` · 린 -${discount}%` : ''}`
      : '최대 레벨 · 효과 유지';
  }
  if (status === 'constructing') {
    return `건설 중 · 남은 ${formatRemainingSeconds(getConstructionRemaining(state, building, instance))}`;
  }
  if (status === 'buildable') {
    const construction = building.construction || {};
    return `${formatSecondsShort(construction.seconds || 0)} · ${formatCost(construction.cost)}`;
  }
  if (status === 'needs-placement') {
    return '건설할 타일 선택 필요';
  }
  if (isBuildingUnlocked(state, building) && !isBuildingFootprintOpen(state, building)) {
    return '건설 터 확장 필요';
  }
  return `해금 조건 · ${formatUnlockRequirements(building)}`;
}

function panelActionButton(state, building, status, upgrade, construction, instance = getPrimaryBuildingInstance(state, building)) {
  if (status === 'built') {
    const upgradeCost = upgrade ? getUpgradeCost(state, upgrade) : null;
    return `
      <button class="panel-upgrade" type="button" data-upgrade-building="${building.key}" data-upgrade-building-instance="${instance?.id || ''}" ${upgrade ? '' : 'disabled'}>
        <span>${upgrade ? formatPrimaryCost(upgradeCost) : 'MAX'}</span>
        <small>${upgrade ? '강화' : '완료'}</small>
      </button>
    `;
  }
  if (status === 'constructing') {
    return `
      <button class="panel-upgrade is-waiting" type="button" disabled>
        <span>${formatRemainingSeconds(getConstructionRemaining(state, building, instance))}</span>
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
  if (status === 'needs-placement') {
    return `
      <button class="panel-upgrade" type="button" data-place-building="${building.key}">
        <span>타일</span>
        <small>선택</small>
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

function panelProgress(state, building, status, instance = getPrimaryBuildingInstance(state, building)) {
  if (status === 'constructing') return (getConstructionProgress(state, building, instance) * 100).toFixed(1);
  if (status === 'built') return clamp(getInstanceBuildingLevel(state, building, instance) / Math.max(1, building.levels?.length || 1) * 100, 0, 100).toFixed(1);
  if (status === 'buildable') return canAffordCost(state, getConstructionForNextInstance(state, building).cost) ? 100 : 34;
  if (status === 'needs-placement') return 18;
  return 8;
}

function getInstanceBuildingLevel(state, building, instance = getPrimaryBuildingInstance(state, building)) {
  if (!building) return 1;
  const maxLevel = Math.max(1, building.levels?.length || 1);
  if (building.key === 'lantern_shrine') {
    return clamp(Number(state.shrineLevel) || 1, 1, maxLevel);
  }
  return clamp(Number(instance?.level) || Number(state.buildingLevels?.[building.key]) || 1, 1, maxLevel);
}

function setInstanceBuildingLevel(state, building, instance, level) {
  if (!state || !building || !instance) return;
  const maxLevel = Math.max(1, building.levels?.length || 1);
  const nextLevel = clamp(Number(level) || 1, 1, maxLevel);
  instance.level = nextLevel;
  state.placedBuildingInstances[instance.id] = instance;
  if (building.key === 'lantern_shrine') state.shrineLevel = nextLevel;
  syncLegacyBuildingState(state);
}

function getBuildingLevel(state, building) {
  if (!building) return 1;
  const maxLevel = Math.max(1, building.levels?.length || 1);
  if (building.key === 'lantern_shrine') {
    return clamp(Number(state.shrineLevel) || 1, 1, maxLevel);
  }
  const builtLevels = getBuiltBuildingInstances(state, building).map(instance => Number(instance.level) || 1);
  const aggregate = builtLevels.length ? Math.max(...builtLevels) : Number(state.buildingLevels?.[building.key]) || 1;
  return clamp(aggregate, 1, maxLevel);
}

function getLevelData(building, level) {
  if (!building?.levels?.length) return null;
  return building.levels.find(row => row.level === level) || null;
}

function isBuildingBuilt(state, building) {
  return getBuiltBuildingInstances(state, building).length > 0 || Boolean(state.builtBuildings?.[building.key]);
}

function getConstructionJob(state, building, targetInstance = null) {
  if (targetInstance?.status === 'constructing') {
    return { instanceId: targetInstance.id, startedAt: targetInstance.startedAt, finishAt: targetInstance.finishAt };
  }
  const selected = getSelectedBuildingInstance(state, building);
  const activeInstance = selected?.status === 'constructing'
    ? selected
    : getConstructingBuildingInstances(state, building)[0];
  if (activeInstance) {
    return { instanceId: activeInstance.id, startedAt: activeInstance.startedAt, finishAt: activeInstance.finishAt };
  }
  return state.constructionJobs?.[building.key] || null;
}

function isBuildingConstructing(state, building, instance = null) {
  const job = getConstructionJob(state, building, instance);
  return Boolean(job && Number(job.finishAt) > Date.now());
}

function getConstructionRemaining(state, building, instance = null) {
  const job = getConstructionJob(state, building, instance);
  if (!job) return 0;
  return Math.max(0, Math.ceil((Number(job.finishAt) - Date.now()) / 1000));
}

function getConstructionProgress(state, building, instance = null) {
  const job = getConstructionJob(state, building, instance);
  if (!job) return 0;
  const startedAt = Number(job.startedAt) || Date.now();
  const finishAt = Number(job.finishAt) || startedAt;
  const duration = Math.max(1, finishAt - startedAt);
  return clamp((Date.now() - startedAt) / duration, 0, 1);
}

function completeFinishedConstructions(state) {
  const completed = [];
  const now = Date.now();
  for (const instance of getAllBuildingInstances(state)) {
    if (instance.status !== 'constructing' || Number(instance.finishAt) > now) continue;
    const building = BUILDING_BY_KEY.get(instance.buildingKey);
    if (!building) continue;
    instance.status = 'built';
    instance.startedAt = null;
    instance.finishAt = null;
    state.placedBuildingInstances[instance.id] = instance;
    setBuildingFootprintState(state, building, 'built', instance);
    completed.push(formatBuildingInstanceName(building, instance));
  }
  if (completed.length) {
    state.lastLog = `${completed.join(', ')} 건설이 완료되었습니다.`;
  }
  syncLegacyBuildingState(state);
  return completed;
}

function hasActiveConstruction(state) {
  return getAllBuildingInstances(state).some(instance => instance.status === 'constructing');
}

function isBuildingUnlocked(state, building) {
  const unlock = building.unlock || {};
  return Object.entries(unlock).every(([condition, required]) => {
    if (!condition.endsWith('_level')) return true;
    const buildingKey = condition.slice(0, -'_level'.length);
    const requiredLevel = Number(required) || 1;
    const requiredBuilding = BUILDING_BY_KEY.get(buildingKey);
    if (!requiredBuilding || !isBuildingBuilt(state, requiredBuilding)) return false;
    if (buildingKey === 'lantern_shrine') {
      return Math.max(getBuildingLevel(state, requiredBuilding), Number(state.shrineLevel || 1)) >= requiredLevel;
    }
    return getBuildingLevel(state, requiredBuilding) >= requiredLevel;
  });
}

function getBuildingStatus(state, building, instance = getPrimaryBuildingInstance(state, building)) {
  if (instance?.status === 'built') return 'built';
  if (instance?.status === 'constructing') return 'constructing';
  if (!isBuildingUnlocked(state, building)) return 'locked-slot';
  if (!canBuildAnotherBuilding(state, building)) return isBuildingBuilt(state, building) ? 'built' : 'locked-slot';
  const pending = getPendingBuildingPlacement(state, building);
  if (!pending) return 'needs-placement';
  if (!isBuildingFootprintOpen(state, building, pending)) return 'locked-slot';
  return 'buildable';
}

function isBuildingVisible(state, building) {
  if (getBuildingInstances(state, building).length) return true;
  if (building.tier === 'core') return true;
  const shrine = BUILDING_BY_KEY.get('lantern_shrine');
  const shrineLevel = Math.max(getBuildingLevel(state, shrine), Number(state.shrineLevel || 1));
  if (building.tier === 'ring_1') return shrineLevel >= 2;
  if (building.tier === 'ring_2') return shrineLevel >= 4;
  return shrineLevel >= 6;
}

function isBuildingMapVisible(state, building) {
  return getBuildingInstances(state, building).length > 0
    || (isBuildingVisible(state, building) && hasBuildingPlacement(state, building));
}

function getVisibleBuildingEntryForTile(tile, state) {
  return getHomeBuildingEntries(state).find(entry => entry.tiles.some(entryTile => entryTile.id === tile.id)) || null;
}

function getVisibleBuildingForTile(tile, state) {
  return getVisibleBuildingEntryForTile(tile, state)?.building || null;
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
    ['food_per_hour', value => `+${formatEffectNumber(value)}/h`],
    ['bamboo_per_min', value => `+${formatEffectNumber(value)}/m`],
    ['iron_ore_per_hour', value => `+${formatEffectNumber(value)}/h`],
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
    food_per_hour: ['식량', '/h'],
    expedition_supply_cap: ['보급', '칸'],
    bamboo_per_min: ['대나무', '/m'],
    wood_cost_reduction_percent: ['목재절감', '%'],
    iron_ore_per_hour: ['철광석', '/h'],
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

function getUpgradeCost(state, upgrade = {}) {
  const cost = upgrade?.cost || {};
  const reduction = clamp(getCompanionBonus(state, 'upgrade_cost_reduction_percent'), 0, 80);
  if (!reduction) return cost;
  return Object.fromEntries(Object.entries(cost).map(([key, value]) => [
    key,
    Math.max(1, Math.floor(Number(value || 0) * (1 - reduction / 100))),
  ]));
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

function selectBuilding(scene, buildingKey, instanceId = '') {
  const building = BUILDING_BY_KEY.get(buildingKey);
  if (!scene || !building) return;
  const instance = instanceId
    ? scene.sanctuary.placedBuildingInstances?.[instanceId]
    : getPrimaryBuildingInstance(scene.sanctuary, building);
  scene.sanctuary.selectedBuildingKey = building.key;
  scene.sanctuary.selectedBuildingInstanceId = instance?.buildingKey === building.key ? instance.id : '';
  scene.sanctuary.buildPlanBuildingKey = '';
  scene.sanctuary.buildPlanPlacement = null;
  homeBuildTrayOpen = false;
  saveSanctuary(scene.sanctuary);
  renderHome(scene);
}

function selectHomeTab(scene, tabKey) {
  const state = scene?.sanctuary;
  const safeTab = HOME_TAB_KEYS.has(tabKey) ? tabKey : 'sanctuary';
  activeHomeTab = safeTab;
  if (!state) {
    homeBuildTrayOpen = false;
    return;
  }

  if (safeTab === 'sanctuary') {
    homeBuildTrayOpen = true;
    const buildCount = getHomeBuildListBuildings(state).length;
    state.lastLog = buildCount > 0
      ? '건설은 선택한 건물 패널에서 진행하세요.'
      : '현재 새로 지을 건물이 없습니다.';
  } else {
    homeBuildTrayOpen = false;
    state.buildPlanBuildingKey = '';
    state.buildPlanPlacement = null;
  }

  saveSanctuary(state);
  renderHome(scene);
}

function closeHomeBuildModal(scene) {
  const state = scene?.sanctuary;
  homeBuildTrayOpen = false;
  if (state) {
    saveSanctuary(state);
    renderHome(scene);
    return;
  }
  if (dom.homeBuildModal) {
    dom.homeBuildModal.hidden = true;
    dom.homeBuildModal.setAttribute('aria-hidden', 'true');
  }
}

function selectBuildPlan(scene, buildingKey) {
  const state = scene?.sanctuary;
  const building = BUILDING_BY_KEY.get(buildingKey);
  if (!state || !building) return;
  activeHomeTab = 'sanctuary';
  state.selectedBuildingKey = building.key;
  state.selectedBuildingInstanceId = '';

  if (!canBuildAnotherBuilding(state, building)) {
    homeBuildTrayOpen = false;
    state.buildPlanBuildingKey = '';
    state.buildPlanPlacement = null;
    state.selectedBuildingInstanceId = getPrimaryBuildingInstance(state, building)?.id || '';
    state.lastLog = `${building.name}은 현재 최대 ${getMaxBuildingInstances(state, building)}개까지 지을 수 있습니다.`;
  } else if (!isBuildingUnlocked(state, building)) {
    homeBuildTrayOpen = false;
    state.buildPlanBuildingKey = '';
    state.buildPlanPlacement = null;
    state.lastLog = `${building.name} 해금 조건: ${formatUnlockRequirements(building)}`;
  } else {
    homeBuildTrayOpen = false;
    state.buildPlanBuildingKey = building.key;
    state.buildPlanPlacement = null;
    const candidates = getPlacementCandidateTiles(state, building);
    state.lastLog = candidates.length
      ? `${building.name}: 지을 빈 타일을 선택하세요.`
      : `${building.name}: 배치 가능한 빈 ${building.footprint || ''} 터가 없습니다.`;
  }

  saveSanctuary(state);
  renderHome(scene);
}

function placeSelectedBuildingAtTile(scene, tileId) {
  const state = scene?.sanctuary;
  const building = BUILDING_BY_KEY.get(state?.buildPlanBuildingKey);
  if (!state || !building) return false;
  activeHomeTab = 'sanctuary';

  const validation = getPlacementValidation(state, building, tileId);
  if (!validation.ok) {
    state.selectedBuildingKey = building.key;
    state.lastLog = validation.reason;
    saveSanctuary(state);
    renderHome(scene);
    scene?.playSfx?.('uiError', { volume: 0.58 });
    return true;
  }

  state.buildPlanPlacement = { buildingKey: building.key, placement: validation.placement };
  setBuildingPlacement(state, building, validation.placement);
  state.selectedBuildingKey = building.key;
  state.selectedBuildingInstanceId = '';
  state.buildPlanBuildingKey = '';
  startBuildingConstruction(scene, building.key);
  return true;
}

function expandTile(scene, tileId) {
  const state = scene?.sanctuary;
  const tile = HEX_BY_ID.get(Number(tileId));
  if (!state || !tile) return;

  const tileState = getTileState(state, tile);
  let success = false;
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
    success = true;
  }

  saveSanctuary(state);
  renderHome(scene);
  scene?.playSfx?.(success ? 'reward' : 'uiError', { volume: success ? 0.58 : 0.52 });
}

function startBuildingConstruction(scene, buildingKey) {
  const state = scene?.sanctuary;
  const building = BUILDING_BY_KEY.get(buildingKey);
  if (!state || !building) return;
  activeHomeTab = 'sanctuary';
  state.selectedBuildingKey = building.key;
  state.selectedBuildingInstanceId = '';
  completeFinishedConstructions(state);

  if (!canBuildAnotherBuilding(state, building)) {
    state.buildPlanBuildingKey = '';
    state.buildPlanPlacement = null;
    state.selectedBuildingInstanceId = getPrimaryBuildingInstance(state, building)?.id || '';
    state.lastLog = `${building.name}은 현재 최대 ${getMaxBuildingInstances(state, building)}개까지 지을 수 있습니다.`;
    scene?.playSfx?.('uiError', { volume: 0.52 });
  } else if (!isBuildingUnlocked(state, building)) {
    state.buildPlanBuildingKey = '';
    state.buildPlanPlacement = null;
    state.lastLog = `${building.name} 해금 조건: ${formatUnlockRequirements(building)}`;
    scene?.playSfx?.('uiError', { volume: 0.52 });
  } else if (!getPendingBuildingPlacement(state, building)) {
    homeBuildTrayOpen = false;
    state.buildPlanBuildingKey = building.key;
    state.buildPlanPlacement = null;
    state.lastLog = `${building.name}: 지을 타일을 선택하세요.`;
  } else if (!isBuildingFootprintOpen(state, building, getPendingBuildingPlacement(state, building))) {
    homeBuildTrayOpen = false;
    state.buildPlanBuildingKey = building.key;
    state.buildPlanPlacement = null;
    state.lastLog = `${building.name} 터를 다시 선택해야 합니다.`;
    scene?.playSfx?.('uiError', { volume: 0.52 });
  } else {
    const construction = getConstructionForNextInstance(state, building);
    if (!canAffordCost(state, construction.cost)) {
      state.buildPlanBuildingKey = '';
      state.lastLog = `건설에는 ${formatMissingCost(state, construction.cost)}가 필요합니다.`;
      scene?.playSfx?.('uiError', { volume: 0.52 });
    } else {
      const placement = getPendingBuildingPlacement(state, building);
      const ordinal = getNextBuildingInstanceOrdinal(state, building);
      const instanceId = buildingInstanceId(building.key, ordinal);
      const now = Date.now();
      const seconds = Number(construction.seconds || 0);
      const instance = {
        id: instanceId,
        buildingKey: building.key,
        ordinal,
        level: 1,
        status: seconds <= 0 ? 'built' : 'constructing',
        placement,
        startedAt: seconds <= 0 ? null : now,
        finishAt: seconds <= 0 ? null : now + seconds * 1000,
      };
      spendCost(state, construction.cost);
      state.placedBuildingInstances[instanceId] = instance;
      state.selectedBuildingInstanceId = instanceId;
      state.buildPlanBuildingKey = '';
      state.buildPlanPlacement = null;
      if (state.buildingPlacements) delete state.buildingPlacements[building.key];
      syncLegacyBuildingState(state);
      if (seconds <= 0) {
        setBuildingFootprintState(state, building, 'built', instance);
        state.lastLog = `${formatBuildingInstanceName(building, instance)} 건설이 완료되었습니다.`;
      } else {
        setBuildingFootprintState(state, building, 'empty', instance);
        state.lastLog = `${formatBuildingInstanceName(building, instance)} 건설을 시작했습니다. ${formatSecondsShort(seconds)} 후 완공됩니다.`;
      }
      scene?.playSfx?.('reward', { volume: 0.64 });
    }
  }
  saveSanctuary(state);
  renderHome(scene);
}

function rollCompanionGacha(scene) {
  const state = scene?.sanctuary;
  if (!state) return;
  state.selectedBuildingKey = COMPANION_MANAGEMENT_BUILDING_KEY;
  state.selectedBuildingInstanceId = getPrimaryBuildingInstance(state, BUILDING_BY_KEY.get(COMPANION_MANAGEMENT_BUILDING_KEY))?.id || '';
  state.buildPlanBuildingKey = '';
  state.buildPlanPlacement = null;
  const managementBuilding = BUILDING_BY_KEY.get(COMPANION_MANAGEMENT_BUILDING_KEY);
  let success = false;
  if (!isCompanionManagementBuilt(state)) {
    state.lastLog = `${managementBuilding?.name || '용병 관리 건물'}을 먼저 건설해야 용병을 소환할 수 있습니다.`;
  } else {
    const pool = getCompanionGachaPool(state);
    if (!pool.length) {
      state.lastLog = '현재 가챠 풀에 등장 가능한 용병이 없습니다. 전투나 성소 성장을 먼저 진행하세요.';
      saveSanctuary(state);
      renderHome(scene);
      return;
    }
    const cost = getCompanionGachaCost(state);
    if (!canAffordCost(state, cost)) {
      state.lastLog = `용병 가챠에는 ${formatMissingCost(state, cost)}가 필요합니다.`;
    } else {
      spendCost(state, cost);
      state.companionGachaPulls = Math.max(0, Number(state.companionGachaPulls || 0) + 1);
      const companion = rollCompanionFromPool(pool);
      const row = getCompanionState(state, companion);
      const duplicate = Boolean(row?.unlocked);
      if (duplicate) {
        row.exp = Math.max(0, Number(row.exp || 0) + COMPANION_DUPLICATE_EXP);
        state.companionExp = Math.max(0, Number(state.companionExp || 0) + COMPANION_DUPLICATE_EXP);
        syncCompanionLevels(state);
        state.lastLog = `용병 가챠 결과: ${companion.name} 중복. 동료 경험 +${COMPANION_DUPLICATE_EXP}`;
      } else {
        row.unlocked = true;
        row.equipped = true;
        syncCompanionLevels(state);
        state.lastLog = `용병 가챠 결과: ${companion.name} 획득. ${companion.skillName}과 ${companion.passiveCopy}가 활성화됩니다.`;
      }
      document.documentElement.dataset.homeCompanionGachaLast = companion.key;
      document.documentElement.dataset.homeCompanionGachaDuplicate = String(duplicate);
      success = true;
    }
  }
  syncCompanionUnlocks(state);
  saveSanctuary(state);
  renderHome(scene);
  scene?.playSfx?.(success ? 'levelUp' : 'uiError', { volume: success ? 0.62 : 0.52 });
}

function upgradeBuilding(scene, buildingKey, instanceId = '') {
  const state = scene?.sanctuary;
  const building = BUILDING_BY_KEY.get(buildingKey);
  if (!state || !building) return;
  const instance = instanceId
    ? state.placedBuildingInstances?.[instanceId]
    : getPrimaryBuildingInstance(state, building);
  state.selectedBuildingKey = building.key;
  state.selectedBuildingInstanceId = instance?.buildingKey === building.key ? instance.id : '';
  state.buildPlanBuildingKey = '';
  state.buildPlanPlacement = null;
  completeFinishedConstructions(state);
  let success = false;
  if (!instance || instance.status !== 'built') {
    state.lastLog = `${building.name}을 먼저 완공해야 합니다.`;
  } else {
    const level = getInstanceBuildingLevel(state, building, instance);
    const next = getLevelData(building, level + 1);
    const upgrade = next?.levelUp;
    if (!upgrade) {
      state.lastLog = `${formatBuildingInstanceName(building, instance)}은 현재 데이터의 최대 레벨입니다.`;
    } else {
      const upgradeCost = getUpgradeCost(state, upgrade);
      if (!canAffordCost(state, upgradeCost)) {
        state.lastLog = `강화에는 ${formatMissingCost(state, upgradeCost)}가 필요합니다.`;
      } else {
        spendCost(state, upgradeCost);
        const nextLevel = level + 1;
        setInstanceBuildingLevel(state, building, instance, nextLevel);
        syncCompanionUnlocks(state, { announce: true });
        const nextExpansionCost = getNextExpansionCost(state);
        const expansionCopy = nextExpansionCost ? ` · 확장 ${nextExpansionCost}` : '';
        const summonable = getSummonableCompanions(state);
        const summonCopy = summonable.length ? ` · ${summonable.map(companion => companion.name).join(', ')} 가챠 등장` : '';
        state.lastLog = `${formatBuildingInstanceName(building, instance)} Lv.${nextLevel}: ${formatEffectStats(next.effect).slice(0, 2).join(' · ')}${expansionCopy}${summonCopy}`;
        success = true;
      }
    }
  }
  saveSanctuary(state);
  renderHome(scene);
  scene?.playSfx?.(success ? 'levelUp' : 'uiError', { volume: success ? 0.58 : 0.52 });
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
  let woodRewardBase = 0;
  const addReward = (key, name, icon, count) => {
    const safe = Math.max(0, Math.floor(count));
    if (!safe) return;
    const previous = rewardMap.get(key) || { key, name, icon, count: 0 };
    previous.count += safe;
    rewardMap.set(key, previous);
  };

  for (const reward of mapRewards || []) {
    const id = Number(reward.itemDataId);
    const count = Math.max(0, Math.floor(Number(reward.count || 0)));
    if (id === 5) {
      state.gold += count;
      addReward('gold', '코인', '🟡', count);
    } else if (id === 200101) {
      state.wood += count;
      woodRewardBase += count;
      addReward('wood', '목재', '🪵', count);
    } else if (id === 200102) {
      state.stone += count;
      addReward('stone', '석재', '◆', count);
    } else if (id === 200103) {
      state.souls += count;
      addReward('souls', '영혼불', '🔥', count);
    }
  }

  for (const [key, rawCount] of Object.entries(run.ledger || {})) {
    const count = Math.max(0, Math.floor(Number(rawCount || 0)));
    if (key === 'gold') {
      state.gold += count;
      addReward('gold_drops', '코인', '●', count);
    } else if (key === 'wood') {
      state.wood += count;
      woodRewardBase += count;
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
  woodRewardBase += woodGain;
  state.light += lightGain;
  state.sorties += 1;
  if (run.won) state.stageClears = Math.max(0, Number(state.stageClears || 0) + 1);
  addReward('souls_bonus', '영혼불', '🔥', soulGain);
  addReward('wood_bonus', '목재', '🪵', woodGain);
  addReward('light', '등불 게이지', '💡', lightGain);

  const woodBonusPercent = getCompanionBonus(state, 'wood_reward_percent');
  const companionWoodGain = Math.floor(woodRewardBase * woodBonusPercent / 100);
  if (companionWoodGain > 0) {
    state.wood += companionWoodGain;
    addReward('wood_companion', '카에데 목재 보너스', '葉', companionWoodGain);
  }

  syncCompanionUnlocks(state, { announce: true });
  const companionExp = addCompanionExp(state, (run.won ? 36 : 14) + Math.floor(run.kills * 1.2));
  if (companionExp > 0) addReward('companion_exp', '동료 경험', '✦', companionExp);

  const nextExpansionCost = getNextExpansionCost(state);
  if (nextExpansionCost) state.lightNeed = nextExpansionCost;
  const expansionReady = getExpandableTiles(state).length > 0;

  const summonable = getSummonableCompanions(state);
  const summonCopy = summonable.length ? ` ${summonable.map(companion => companion.name).join(', ')}를 용병 훈련소에서 소환할 수 있습니다.` : '';
  state.lastLog = expansionReady
    ? `원정대가 밝힌 길을 따라 정화 가능한 안개 타일이 생겼습니다.${summonCopy}`
    : `원정대가 영혼불을 가져왔습니다. 다음 출정으로 성소 반경을 더 넓힐 수 있습니다.${summonCopy}`;

  return {
    won: run.won,
    rewards: [...rewardMap.values()],
    message: `${run.elapsed}s 동안 ${run.kills}마리를 처리했습니다. ${expansionReady ? '정화할 타일이 준비됐습니다.' : '등불이 더 밝아졌습니다.'}${summonCopy}`,
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
    dom.homeScreen?.style.setProperty('--home-bg-pan-x', `${pan.x.toFixed(1)}px`);
    dom.homeScreen?.style.setProperty('--home-bg-pan-y', `${pan.y.toFixed(1)}px`);
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
  globalThis.__NINJA2_HOME_SKINS_GAMES__ = homeSkinGames;
  const scene = () => game.scene.getScene('SurvivorScene');
  applyNinja2Settings();
  installUiClickSfx();
  installHomeMapPan();
  globalThis.addEventListener('pointermove', event => updateHomeBuildGhostPointer(event), { passive: true });
  globalThis.addEventListener('mousemove', event => updateHomeBuildGhostPointer(event), { passive: true });
  dom.sortieButton.addEventListener('click', () => scene()?.startExpedition?.());
  dom.resultReturnButton.addEventListener('click', () => scene()?.returnHome?.());
  dom.returnButton.addEventListener('click', () => scene()?.returnHome?.());
  dom.pauseButton.addEventListener('click', () => scene()?.togglePause?.());
  dom.restartButton.addEventListener('click', () => scene()?.restartRun?.());
  dom.homeResetButton.addEventListener('click', () => scene()?.restartRun?.());
  dom.homeCompanions?.addEventListener('click', () => selectBuilding(scene(), COMPANION_MANAGEMENT_BUILDING_KEY));
  dom.homeSettingsButton?.addEventListener('click', event => {
    event.stopPropagation();
    setHomeSettingsOpen(dom.homeSettingsPanel?.hidden !== false);
  });
  dom.homeSettingsPanel?.addEventListener('click', event => {
    if (event.target.closest('[data-close-settings]')) {
      setHomeSettingsOpen(false);
      return;
    }
    const target = event.target.closest('[data-setting-toggle]');
    if (!target) return;
    toggleNinja2Setting(target.dataset.settingToggle);
  });
  globalThis.addEventListener('keydown', event => {
    if (event.key === 'Escape') setHomeSettingsOpen(false);
  });
  dom.homeTabs?.addEventListener('click', event => {
    const target = event.target.closest('[data-home-tab]');
    if (!target) return;
    selectHomeTab(scene(), target.dataset.homeTab);
  });
  dom.homeBuildModal?.addEventListener('click', event => {
    if (!event.target.closest('[data-close-build-modal]')) return;
    closeHomeBuildModal(scene());
  });
  dom.homeBuildList?.addEventListener('click', event => {
    const target = event.target.closest('[data-select-build-building]');
    if (!target) return;
    updateHomeBuildGhostPointer(event);
    selectBuildPlan(scene(), target.dataset.selectBuildBuilding);
  });
  dom.companionSkillDock?.addEventListener('click', event => {
    const target = event.target.closest('[data-companion-skill]');
    if (!target) return;
    scene()?.castCompanionSkill?.(target.dataset.companionSkill, { source: 'button' });
  });
  dom.homeHexGrid.addEventListener('click', event => {
    const buildingTarget = event.target.closest('[data-building-key]');
    if (buildingTarget) {
      selectBuilding(scene(), buildingTarget.dataset.buildingKey, buildingTarget.dataset.buildingInstanceId);
      return;
    }
    const tileTarget = event.target.closest('[data-tile-id]');
    if (tileTarget) {
      const app = scene();
      updateHomeBuildGhostPointer(event);
      if (!placeSelectedBuildingAtTile(app, tileTarget.dataset.tileId)) {
        expandTile(app, tileTarget.dataset.tileId);
      }
    }
  });
  dom.homeBuildingPanel.addEventListener('click', event => {
    const app = scene();
    if (!app) return;
    const buildTarget = event.target.closest('[data-build-building]');
    const placeTarget = event.target.closest('[data-place-building]');
    const upgradeTarget = event.target.closest('[data-upgrade-building]');
    const gachaTarget = event.target.closest('[data-companion-gacha]');
    if (placeTarget) {
      updateHomeBuildGhostPointer(event);
      selectBuildPlan(app, placeTarget.dataset.placeBuilding);
    }
    if (buildTarget) {
      updateHomeBuildGhostPointer(event);
      startBuildingConstruction(app, buildTarget.dataset.buildBuilding);
    }
    if (upgradeTarget) upgradeBuilding(app, upgradeTarget.dataset.upgradeBuilding, upgradeTarget.dataset.upgradeBuildingInstance);
    if (gachaTarget) rollCompanionGacha(app);
  });

  return game;
}

function ensureHomeSkinStages() {
  if (homeSkinGames.length) {
    globalThis.__NINJA2_HOME_SKINS_REFRESH__?.();
    return homeSkinGames;
  }
  homeSkinGames = startHomeSkinStages();
  globalThis.__NINJA2_HOME_SKINS_GAMES__ = homeSkinGames;
  return homeSkinGames;
}

function startHomeSkinStages() {
  if (!dom.homeTopSkinStage || !dom.homePanelSkinStage) {
    document.documentElement.dataset.homeNineslice = 'missing-stage';
    return [];
  }
  const games = [
    createHomeSkinGame('homeTopSkinStage', new HomeNineSliceScene('top')),
    createHomeSkinGame('homePanelSkinStage', new HomeNineSliceScene('panel')),
  ];
  if (dom.homeSettingsSkinStage) {
    games.push(createHomeSkinGame('homeSettingsSkinStage', new HomeNineSliceScene('modal')));
  }
  return games.filter(Boolean);
}

function createHomeSkinGame(parent, scene) {
  return new PhaserRef.Game({
    type: PhaserRef.WEBGL,
    parent,
    width: 440,
    height: 782,
    transparent: true,
    backgroundColor: 'rgba(0,0,0,0)',
    banner: false,
    scale: {
      mode: PhaserRef.Scale.RESIZE,
      autoCenter: PhaserRef.Scale.NO_CENTER ?? 0,
    },
    scene,
  });
}

start();
