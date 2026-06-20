import { ResourceStore } from '../idlez-phaser/resource-store.js?v=ninja2-run-skills1';
import { IdlezBoard } from '../idlez-phaser/board-kernel.js?v=ninja2-unit-collision-data1';
import { TEAM, TICKS_PER_SECOND, clamp, formatNumber, pickLevelValue } from '../idlez-phaser/constants.js?v=ninja2-run-skills1';
import {
  getOrCreateLocalPlayerId,
  readSettingsPreference,
  resolveSettings,
  saveSettings,
} from '../idlez-phaser/settings-store.js?v=settings1';
import { HOUSING_TECH } from './housing-tech.js?v=ninja2-housing-runtime1';
import {
  RUN_PROFILE_SKILL_ROWS,
  SKILL_ICON_PATHS,
  SKILL_VFX_ATOMS,
  SKILL_VFX_ATOM_ASSETS,
  getSkillVfxProfile,
  installSkillVfxContract,
  maybeStartSkillVfxDemo,
  spawnSkillCastFx,
  spawnSkillTimelineFx,
} from './skill-vfx.js?v=ninja2-run-skills1';
import {
  HOME_MISSION_MODAL_TAB,
  getHomeMissionEntries,
  getHomeMissionSummary,
  renderHomeMissionModalBody,
  renderHomeMissionModalFooter,
} from './home-modals/mission.js?v=mission-modal1';
import {
  getHomeMailEntries,
  getHomeMailSummary,
  renderHomeMailModalBody,
  renderHomeMailModalFooter,
} from './home-modals/mail.js?v=mailbox1';
import {
  HOME_SHOP_MODAL_TAB,
  HOME_SHOP_PRODUCT_DEFS,
  getHomeShopProductEntries,
  getHomeShopSummary,
  normalizeHomeShopCategoryKey,
  renderHomeShopModalBody,
  renderHomeShopModalFooter,
} from './home-modals/shop.js?v=shop-cash2';

const PhaserRef = globalThis.Phaser;

if (!PhaserRef) {
  throw new Error('Phaser failed to load');
}

document.documentElement.dataset.survivorBootPhase = 'module-loaded';

const params = new URLSearchParams(globalThis.location?.search || '');
const GAME_ID = params.get('game') || 'ninja2';
const START_MAP_ID = Number(params.get('map') || 500101);
const MAIN_MAP_IDS = Object.freeze([
  500101,
  500102,
  500103,
  500104,
  500105,
  500106,
  500107,
  500108,
  500109,
  500110,
]);
const MAIN_MAP_COPY = Object.freeze({
  500101: { region: '대나무 영지', focus: '첫 출격', reward: '목재·골드', unlock: '시작' },
  500102: { region: '대나무 영지', focus: '외곽 정리', reward: '목재+', unlock: '1 클리어' },
  500103: { region: '안개숲', focus: '석재 도입', reward: '석재', unlock: '2 클리어' },
  500104: { region: '안개숲', focus: '깊은길 압박', reward: '석재+', unlock: '3 클리어' },
  500105: { region: '가면 초소', focus: '중간 보스', reward: '영혼불', unlock: '4 클리어' },
  500106: { region: '영혼불 길', focus: '희귀 재료', reward: '영혼불+', unlock: '5 클리어' },
  500107: { region: '그림자 나루', focus: '파밍 선택', reward: '재료+', unlock: '6 클리어' },
  500108: { region: '가시 폐허', focus: '중반 진입', reward: '석재++', unlock: '7 클리어' },
  500109: { region: '가시 폐허', focus: '심층 압박', reward: '영혼불++', unlock: '8 클리어' },
  500110: { region: '가시 제단', focus: '최종 보스', reward: '1장 보상', unlock: '9 클리어' },
});
const SIDE_DUNGEON_IDS = Object.freeze([500201, 500202, 500206]);
const SIDE_DUNGEON_COPY = Object.freeze({
  500201: {
    family: '자원 수집',
    focus: '건설 목재 파밍',
    reward: '목재·골드',
    unlockStageClears: 2,
    unlock: 'Stage 2 클리어',
    icon: '木',
    iconAsset: './assets/ninja2/ui/dungeons/icon_dungeon_woodcutting_trail.png',
  },
  500202: {
    family: '자원 수집',
    focus: '확장 석재 파밍',
    reward: '석재·목재',
    unlockStageClears: 3,
    unlock: 'Stage 3 클리어',
    icon: '石',
    iconAsset: './assets/ninja2/ui/dungeons/icon_dungeon_stone_underpass.png',
  },
  500206: {
    family: '자원 수집',
    focus: '동료 흔적 수집',
    reward: '동료 조각·영혼불',
    unlockStageClears: 6,
    unlock: 'Stage 6 클리어',
    icon: '忍',
    iconAsset: './assets/ninja2/ui/dungeons/icon_dungeon_companion_traces.png',
  },
});
const DUNGEON_DIFFICULTIES = Object.freeze([
  {
    key: 'easy',
    label: '초급',
    badge: '기본',
    unlockOffset: 0,
    rewardRate: 'x1.0',
    threat: '기본 편성',
  },
  {
    key: 'normal',
    label: '중급',
    badge: '추천',
    unlockOffset: 1,
    rewardRate: 'x1.25',
    threat: '정예 추가',
  },
  {
    key: 'hard',
    label: '상급',
    badge: '도전',
    unlockOffset: 4,
    rewardRate: 'x1.6',
    threat: '고위험',
  },
]);
const INITIAL_MODE = params.get('mode') || params.get('screen') || 'home';
const VFX_DEMO_MODE = ['1', 'true', 'demo', 'skills'].includes(String(params.get('vfx') || params.get('skillVfxDemo') || params.get('skillFxDemo') || '').toLowerCase());
const LEVEL_CHOICE_DEMO_MODE = ['1', 'true', 'demo', 'choice'].includes(String(params.get('levelup') || params.get('levelChoiceDemo') || '').toLowerCase());
const BATTLE_VISUAL_FIXTURE_PARAM = String(params.get('battleVisual') || params.get('visualFixture') || params.get('visual') || '').toLowerCase();
const BATTLE_VISUAL_POLISH_FIXTURE = ['1', 'true', 'yes', 'on', 'demo', 'polish', 'runtime-polish-f', 'f'].includes(BATTLE_VISUAL_FIXTURE_PARAM);
const LEVEL_CHOICE_SUPPRESSED = BATTLE_VISUAL_POLISH_FIXTURE
  || ['0', 'false', 'no', 'off', 'skip', 'none'].includes(String(params.get('levelChoice') || params.get('runLevelChoice') || '').toLowerCase())
  || ['1', 'true', 'yes', 'on'].includes(String(params.get('noLevelChoice') || params.get('suppressLevelChoice') || '').toLowerCase());
const HOME_DEMO_PARAM = String(params.get('homeDemo') || params.get('housingDemo') || '').toLowerCase();
const HOME_FIXTURE_PARAM = String(params.get('fixture') || '').toLowerCase();
const HOME_START_DEMO_MODE = ['1', 'true', 'demo', 'city', 'housing', 'start', 'first'].includes(HOME_DEMO_PARAM)
  || ['home', 'start', 'first'].includes(HOME_FIXTURE_PARAM);
const HOME_BUILT_CITY_DEMO_MODE = ['built', 'preview', 'full'].includes(HOME_DEMO_PARAM)
  || ['city', 'built', 'preview', 'full'].includes(HOME_FIXTURE_PARAM);
const ENCOUNTER_DEMO_MODE = ['1', 'true', 'demo', 'encounters'].includes(String(params.get('encounter') || params.get('encounters') || '').toLowerCase());
const FAST_VFX_ASSETS = (VFX_DEMO_MODE || LEVEL_CHOICE_DEMO_MODE) && params.get('fullAssets') !== '1';
const ASSET_VERSION = 'ninja2-nineslice1';
const TITLE_SPLASH_PARAM = String(params.get('splash') || params.get('titleSplash') || '').toLowerCase();
const TITLE_SPLASH_FORCED = ['1', 'true', 'yes', 'on', 'show', 'hold'].includes(TITLE_SPLASH_PARAM);
const TITLE_SPLASH_HOLD = ['hold', 'preview', 'debug'].includes(TITLE_SPLASH_PARAM);
const TITLE_SPLASH_DISABLED = ['0', 'false', 'no', 'off', 'skip'].includes(TITLE_SPLASH_PARAM)
  || (!TITLE_SPLASH_FORCED && ['battle', 'combat', 'expedition'].includes(INITIAL_MODE));
const TITLE_SPLASH_MIN_VISIBLE_MS = 1450;
const ENABLE_AUDIO_VALUES = new Set(['1', 'true', 'yes', 'on']);
const DISABLE_AUDIO_VALUES = new Set(['0', 'false', 'no', 'off']);
const NINJA2_BGM_TRACKS = Object.freeze({
  home: {
    key: 'ninja2-bgm-lantern-grove',
    path: 'assets/audio/lantern-grove.mp3',
    volume: 0.34,
  },
  expedition: {
    key: 'ninja2-bgm-bamboo-shuriken-run',
    path: 'assets/audio/bamboo-shuriken-run.mp3',
    volume: 0.36,
  },
});
const NINJA2_BGM_MODE_TRACKS = Object.freeze({
  boot: 'home',
  home: 'home',
  result: 'home',
  expedition: 'expedition',
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
const BATTLE_VISUAL_POLISH_VERSION = 'runtime-polish-f2';
const BATTLE_CENTER_CLEAR_RADIUS = 360;
const PLAYER_MOVE_SPEED_MULTIPLIER = 0.75;
const PLAYER_DASH_COOLDOWN_MS = 5000;
const PLAYER_DASH_DURATION_MS = 240;
const PLAYER_DASH_DISTANCE = 315;
const PLAYER_DASH_INVULNERABLE_MS = 340;
const PLAYER_LOW_HEALTH_THRESHOLD = 0.2;
const UNIT_WORLD_PIXEL_SCALE = 120;
const UNIT_RENDER_BASE_SCALE = Object.freeze({
  player: 0.311,
  enemy: 0.632,
  elite: 0.614,
  boss: 0.545,
});
const UNIT_HP_BAR_DEFAULTS = Object.freeze({
  enemy: { width: 38, height: 5, yOffset: 32 },
  boss: { width: 74, height: 6, yOffset: 62 },
});
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
const ENCOUNTER_MINE_RADIUS = 88;
const ENCOUNTER_MINE_HOLD_MS = 1500;
const ENCOUNTER_DISPLAY_SIZE = Object.freeze({ normal: 42, mine: 48 });
const RUN_LOOT_PICKUP_RADIUS = 44;
const RUN_LOOT_TTL_MS = 28000;
const RUN_LOOT_SCATTER_RADIUS = 34;
const PICKUP_GLOW_SPEC = Object.freeze({
  coinDrop: { color: COLORS.gold, accent: COLORS.cream, radius: 24 },
  soulFlame: { color: COLORS.soul, accent: COLORS.cream, radius: 27 },
  soulShard: { color: 0x39a8ff, accent: COLORS.cream, radius: 25 },
  woodCrate: { color: COLORS.wood, accent: COLORS.gold, radius: 23 },
  stoneDrop: { color: COLORS.stone, accent: COLORS.cream, radius: 23 },
  default: { color: COLORS.gold, accent: COLORS.cream, radius: 23 },
});
const RANDOM_ENCOUNTERS = Object.freeze([
  { type: 'bomb', texture: 'encounterBomb', weight: 30, label: '폭탄' },
  { type: 'magnet', texture: 'encounterMagnet', weight: 22, label: '자석' },
  { type: 'potion', texture: 'encounterPotion', weight: 24, label: '회복약' },
  { type: 'mine', texture: 'encounterMine', weight: 24, label: '광산', holdMs: ENCOUNTER_MINE_HOLD_MS, radius: ENCOUNTER_MINE_RADIUS },
]);
const BATTLE_FOREST_PROPS = Object.freeze([
  { key: 'battlePropLanternPost', path: 'assets/ninja2/battle/props/prop_lantern_post.png' },
  { key: 'battlePropBambooClump', path: 'assets/ninja2/battle/props/prop_bamboo_clump.png' },
  { key: 'battlePropMossStones', path: 'assets/ninja2/battle/props/prop_moss_stones.png' },
  { key: 'battlePropFallenLog', path: 'assets/ninja2/battle/props/prop_fallen_log.png' },
  { key: 'battlePropSoulShrine', path: 'assets/ninja2/battle/props/prop_soul_shrine.png' },
]);
const MINE_RESOURCE_DROPS = Object.freeze([
  { key: 'wood', texture: 'woodCrate', min: 90, max: 140, label: '목재 광맥' },
  { key: 'stone', texture: 'stoneDrop', min: 70, max: 110, label: '기와석 광맥' },
  { key: 'souls', texture: 'soulFlame', min: 45, max: 75, label: '영혼불 광맥' },
]);
const MAX_RUN_SKILL_LEVEL = 5;
const RUN_SKILL_RETRY_TICKS = Math.ceil(TICKS_PER_SECOND * 0.35);
const NINJA2_SURVIVOR_SKILL_IDS = Object.freeze([
  300101,
  300102,
  300103,
  300104,
  300105,
  300106,
  300107,
  300108,
  300109,
  300110,
  300111,
  300112,
  300113,
  300114,
  300115,
  300116,
]);
const D1_RUN_LEVEL_CHOICE_SKILL_IDS = Object.freeze([
  300102, // 표창 난사: first explicit ranged pickup
  300103, // 연막 폭탄: first control pickup
  300115, // 질풍 보법: first movement/passive-feeling pickup
]);
const LEVEL_CHOICE_DEMO_IDS = D1_RUN_LEVEL_CHOICE_SKILL_IDS;
const RUN_LEVEL_CHOICE_SKILL_IDS = NINJA2_SURVIVOR_SKILL_IDS;
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
const HOME_UI_ICON_PATHS = Object.freeze({
  coin: './assets/ninja2/ui/icons/icon_coin.png',
  collect: './assets/ninja2/ui/icons/icon_collect.png',
  companions: './assets/ninja2/ui/icons/icon_tab_companions.png',
  equipment: './assets/ninja2/ui/icons/icon_tab_equipment.png',
  exploration: './assets/ninja2/ui/icons/icon_tab_exploration.png',
  growth: './assets/ninja2/ui/icons/icon_tab_growth.png',
  herb: './assets/ninja2/ui/icons/icon_plus_cream.png',
  lock: './assets/ninja2/ui/icons/icon_lock.png',
  mission: './assets/ninja2/ui/icons/icon_tab_mission.png',
  population: './assets/ninja2/ui/icons/icon_population.png',
  sanctuary: './assets/ninja2/ui/icons/icon_tab_sanctuary.png',
  shop: './assets/ninja2/ui/icons/icon_tab_shop.png',
  shop_ad_removal: './assets/ninja2/ui/shop/shop_product_ad_removal_charm.png',
  shop_energy_refill: './assets/ninja2/ui/shop/shop_product_energy_refill.png',
  shop_ruby_pouch: './assets/ninja2/ui/shop/shop_product_ruby_pouch.png',
  shop_starter_pack: './assets/ninja2/ui/shop/shop_product_starter_pack.png',
  soul: './assets/ninja2/ui/icons/icon_soul.png',
  stone: './assets/ninja2/ui/icons/icon_stone.png',
  wood: './assets/ninja2/ui/icons/icon_wood.png',
});
const HOME_EQUIPMENT_EMPTY_SLOT_ICON_PATHS = Object.freeze({
  weapon: './assets/ninja2/ui/equipment-slots/icon_empty_weapon.png?v=ninja2-empty-slots-v1',
  head: './assets/ninja2/ui/equipment-slots/icon_empty_head.png?v=ninja2-empty-slots-v1',
  chest: './assets/ninja2/ui/equipment-slots/icon_empty_chest.png?v=ninja2-empty-slots-v1',
  gloves: './assets/ninja2/ui/equipment-slots/icon_empty_gloves.png?v=ninja2-empty-slots-v1',
  boots: './assets/ninja2/ui/equipment-slots/icon_empty_boots.png?v=ninja2-empty-slots-v1',
  necklace: './assets/ninja2/ui/equipment-slots/icon_empty_necklace.png?v=ninja2-empty-slots-v1',
  ring: './assets/ninja2/ui/equipment-slots/icon_empty_ring.png?v=ninja2-empty-slots-v1',
});
const HOME_EQUIPMENT_SLOT_SPECS = Object.freeze([
  { key: 'weapon', label: '무기', category: 'Weapon', types: ['Dagger'], emptyIcon: 'weapon' },
  { key: 'head', label: '머리', category: 'Equipment', types: ['Head'], emptyIcon: 'head' },
  { key: 'chest', label: '갑옷', category: 'Equipment', types: ['Chest'], emptyIcon: 'chest' },
  { key: 'gloves', label: '장갑', category: 'Equipment', types: ['Gloves'], emptyIcon: 'gloves' },
  { key: 'boots', label: '신발', category: 'Equipment', types: ['Boots'], emptyIcon: 'boots' },
  { key: 'necklace', label: '호부', category: 'Equipment', types: ['Necklace'], emptyIcon: 'necklace' },
  { key: 'ring', label: '반지', category: 'Equipment', types: ['Ring'], emptyIcon: 'ring' },
]);
const HOME_EQUIPMENT_SLOT_KEYS = new Set(HOME_EQUIPMENT_SLOT_SPECS.map(slot => slot.key));
const HOME_EQUIPMENT_FILTERS = Object.freeze([
  { key: 'all', label: '전체', slotKey: '', iconSrc: HOME_UI_ICON_PATHS.equipment },
  ...HOME_EQUIPMENT_SLOT_SPECS.map(slot => ({ key: slot.key, label: slot.label, slotKey: slot.key })),
]);
const HOME_QUICK_VIEW_KEYS = new Set(['mail', 'gift', 'bag', 'pass']);
const HOME_FEATURE_TABS = new Set([]);
const HOME_PASS_TIERS = Object.freeze([
  { key: 'stage_1', title: '대나무 영지 개방', iconKey: 'exploration', metric: 'stageClears', target: 1, reward: { wood: 80, souls: 5 } },
  { key: 'stage_3', title: '안개숲 진입', iconKey: 'stone', metric: 'stageClears', target: 3, reward: { stone: 70, gold: 260 } },
  { key: 'shrine_3', title: '성소 기반 확장', iconKey: 'sanctuary', metric: 'shrineLevel', target: 3, reward: { light: 90, souls: 8 } },
  { key: 'companions_2', title: '동료 작전조', iconKey: 'companions', metric: 'companions', target: 2, reward: { companion_exp: 120, companion_shards: 5 } },
]);
const HOME_EQUIPMENT_STAT_LABELS = Object.freeze({
  Attack: '공격',
  Hp: '체력',
  Defense: '방어',
  DefensePercent: '방어%',
  CriticalPercent: '치명',
  CriticalDamagePercent: '치피',
  BossDamageEfficiencyPercent: '보스',
  DamageTakenEfficiencyPercent: '피감',
  AttackSpeedPercent: '공속',
  MoveSpeed: '이속',
  HpPercent: '체력%',
  AttackPercent: '공격%',
});
const HOME_EQUIPMENT_STAT_ORDER = Object.freeze([
  'Attack',
  'Hp',
  'Defense',
  'DefensePercent',
  'CriticalPercent',
  'CriticalDamagePercent',
  'BossDamageEfficiencyPercent',
  'DamageTakenEfficiencyPercent',
  'AttackSpeedPercent',
  'MoveSpeed',
  'HpPercent',
  'AttackPercent',
]);
const RESULT_REWARD_META = Object.freeze({
  companion_exp: { name: '동료 경험', iconSrc: HOME_UI_ICON_PATHS.companions },
  companion_shards: { name: '동료 조각', iconSrc: HOME_UI_ICON_PATHS.companions },
  gold: { name: '코인', iconSrc: './assets/ninja2/ui/topbar/icon_coin.png' },
  light: { name: '등불 게이지', iconSrc: HOME_UI_ICON_PATHS.sanctuary },
  souls: { name: '영혼불', iconSrc: './assets/ninja2/ui/topbar/icon_soul.png' },
  stone: { name: '석재', iconSrc: './assets/ninja2/ui/topbar/icon_stone.png' },
  wood: { name: '목재', iconSrc: './assets/ninja2/ui/topbar/icon_wood.png' },
});
const BUILDING_KIND_ICON_KEYS = Object.freeze({
  bamboo: 'wood',
  guard: 'sanctuary',
  granary: 'collect',
  iron: 'stone',
  leaf: 'herb',
  resident: 'population',
  scout: 'exploration',
  soul: 'soul',
  stone: 'stone',
  training: 'companions',
  wood: 'wood',
  workshop: 'collect',
});
const BUILDING_ROLE_ICON_KEYS = Object.freeze({
  advanced_production: 'collect',
  capacity: 'population',
  combat_bonus: 'sanctuary',
  companion_management: 'companions',
  crafting: 'collect',
  farming_control: 'exploration',
  production: 'collect',
  rare_production: 'soul',
  support_production: 'herb',
  supply_capacity: 'collect',
  town_center: 'sanctuary',
});
const RESOURCE_ICON_KEYS = Object.freeze({
  bamboo: 'wood',
  exp: 'growth',
  food: 'collect',
  gold: 'coin',
  herb: 'herb',
  iron_ore: 'stone',
  lantern: 'sanctuary',
  soulflame: 'soul',
  stone: 'stone',
  tool: 'collect',
  wood: 'wood',
});

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

function renderHomeConstructionSprite() {
  return `<img class="building-construction-img" src="./assets/ninja2/home/buildings/construction_site.png?v=${ASSET_VERSION}" alt="" loading="eager">`;
}

function homeUiIconPath(iconKey) {
  const path = HOME_UI_ICON_PATHS[iconKey];
  return path ? `${path}?v=${ASSET_VERSION}` : '';
}

function renderHexLockIcon() {
  const src = homeUiIconPath('lock');
  return src
    ? `<img class="hex-lock-icon" src="${escapeHtml(src)}" alt="" aria-hidden="true" loading="eager" decoding="async">`
    : '';
}

function getBuildingBadgeIconKey(building) {
  if (!building) return '';
  const output = String(building.output || building.icon || building.name || '');
  if (output.includes('목재') || output.includes('대나무')) return 'wood';
  if (output.includes('석재') || output.includes('철광')) return 'stone';
  if (output.includes('영혼불') || output.includes('등불')) return 'soul';
  if (output.includes('허브') || output.includes('회복')) return 'herb';
  if (output.includes('주민')) return 'population';
  if (output.includes('동료') || output.includes('경험치')) return 'companions';
  if (output.includes('드롭') || output.includes('정찰')) return 'exploration';
  return BUILDING_KIND_ICON_KEYS[building.kind] || BUILDING_ROLE_ICON_KEYS[building.role] || 'sanctuary';
}

function renderHomeBuildingBadgeIcon(building, className = 'home-build-card-icon') {
  const iconKey = getBuildingBadgeIconKey(building);
  const path = homeUiIconPath(iconKey);
  const label = building?.icon || building?.output || building?.name || '건물';
  if (path) {
    return `
      <span class="${className} is-asset" title="${escapeHtml(label)}">
        <img src="${escapeHtml(path)}" alt="" loading="eager">
      </span>
    `;
  }
  return `<span class="${className} is-text">${escapeHtml(buildingBlueprintGlyph(building))}</span>`;
}

function renderResourceCostIcon(resourceKey, fallbackIcon = '•') {
  const path = homeUiIconPath(RESOURCE_ICON_KEYS[resourceKey]);
  if (path) return `<img class="home-build-cost-icon" src="${escapeHtml(path)}" alt="" loading="eager">`;
  return `<i class="home-build-cost-glyph" aria-hidden="true">${escapeHtml(fallbackIcon || '•')}</i>`;
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

const UI_MOTION_TARGET_SELECTOR = [
  'button',
  '[role="button"]',
  '[data-tile-id]',
  '[data-building-key]',
  '[data-equipment-item-id]',
  '[data-dungeon-map-id]',
  '[data-preview-dungeon-map-id]',
  '[data-open-dungeon-detail]',
  '[data-dungeon-difficulty]'
].join(',');

const UI_MOTION_ACTION_SELECTOR = [
  '.sortie-button',
  '.panel-upgrade',
  '.companion-gacha-button',
  '.home-modal-action-button',
  '.home-dungeon-start',
  '.equipment-primary-action',
  '.dash-control-button',
  '.action-button',
  '[data-equipment-action]',
  '[data-equipment-detail-action]',
  '[data-home-quick-action]',
  '[data-buy-home-shop]',
  '[data-claim-home-mission]',
  '[data-claim-home-pass]',
  '[data-start-dungeon-map]'
].join(',');

const UI_MOTION_SELECT_SELECTOR = [
  '.home-tab',
  '.home-side-button',
  '.top-icon-button',
  '.home-dungeon-row',
  '.home-dungeon-map-pin',
  '.home-dungeon-difficulty-row',
  '.home-build-card',
  '.home-building',
  '.home-hex',
  '.equipment-slot',
  '.equipment-card',
  '.equipment-filter',
  '.choice',
  '[data-tile-id]',
  '[data-building-key]',
  '[data-home-tab]',
  '[data-open-home-tab]',
  '[data-equipment-item-id]',
  '[data-equipment-filter]',
  '[data-dungeon-map-id]',
  '[data-preview-dungeon-map-id]',
  '[data-open-dungeon-detail]',
  '[data-dungeon-difficulty]'
].join(',');

const UI_MOTION_CLASS_MS = Object.freeze({
  'is-ui-confirming': 260,
  'is-ui-selecting': 320,
  'is-ui-error': 240
});

const uiMotionTimers = new WeakMap();
let uiMotionPressedTarget = null;

function getUiMotionTarget(event) {
  const target = event?.target?.closest?.(UI_MOTION_TARGET_SELECTOR);
  if (!target || !dom.shell?.contains(target)) return null;
  return target;
}

function isUiMotionDisabled(target) {
  return Boolean(target?.disabled)
    || target?.getAttribute?.('aria-disabled') === 'true'
    || target?.matches?.('[disabled]');
}

function restartUiMotionClass(target, className, durationMs = UI_MOTION_CLASS_MS[className] || 260) {
  if (!target?.classList) return;
  const timers = uiMotionTimers.get(target) || {};
  if (timers[className]) globalThis.clearTimeout(timers[className]);
  target.classList.remove(className);
  void target.offsetWidth;
  target.classList.add(className);
  timers[className] = globalThis.setTimeout(() => {
    target.classList.remove(className);
    delete timers[className];
  }, durationMs);
  uiMotionTimers.set(target, timers);
}

function getUiMotionClickClass(target) {
  if (target?.matches?.(UI_MOTION_ACTION_SELECTOR)) return 'is-ui-confirming';
  if (target?.matches?.(UI_MOTION_SELECT_SELECTOR)) return 'is-ui-selecting';
  return 'is-ui-confirming';
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

function installUiMotionFeedback() {
  if (!dom.shell || dom.shell.dataset.uiMotionBound === 'true') return;
  dom.shell.dataset.uiMotionBound = 'true';

  const clearPressTarget = () => {
    uiMotionPressedTarget?.classList?.remove('is-ui-pressing');
    uiMotionPressedTarget = null;
  };

  dom.shell.addEventListener('pointerdown', event => {
    if (event.button != null && event.button !== 0) return;
    const target = getUiMotionTarget(event);
    if (!target) return;
    if (isUiMotionDisabled(target)) {
      restartUiMotionClass(target, 'is-ui-error');
      return;
    }
    clearPressTarget();
    uiMotionPressedTarget = target;
    target.classList.add('is-ui-pressing');
  }, true);

  dom.shell.addEventListener('pointercancel', clearPressTarget, true);
  dom.shell.addEventListener('pointerleave', clearPressTarget, true);
  globalThis.addEventListener('pointerup', clearPressTarget, true);

  dom.shell.addEventListener('click', event => {
    const target = getUiMotionTarget(event);
    if (!target) return;
    target.classList.remove('is-ui-pressing');
    if (isUiMotionDisabled(target)) {
      restartUiMotionClass(target, 'is-ui-error');
      return;
    }
    restartUiMotionClass(target, getUiMotionClickClass(target));
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
const HOME_PROPS = [];

const dom = {
  shell: document.getElementById('survivorShell'),
  titleSplash: document.getElementById('titleSplash'),
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
  resultCard: document.getElementById('resultCard'),
  resultKicker: document.getElementById('resultKicker'),
  resultStats: document.getElementById('resultStats'),
  resultRewardTitle: document.getElementById('resultRewardTitle'),
  homeBoardWrap: document.getElementById('homeBoardWrap'),
  homeHexGrid: document.getElementById('homeHexGrid'),
  homeDungeonModal: document.getElementById('homeDungeonModal'),
  homeDungeonList: document.getElementById('homeDungeonList'),
  homeDungeonDetailModal: document.getElementById('homeDungeonDetailModal'),
  homeDungeonDetailBody: document.getElementById('homeDungeonDetailBody'),
  homeEquipmentScreen: document.getElementById('homeEquipmentScreen'),
  homeEquipmentDetailModal: document.getElementById('homeEquipmentDetailModal'),
  homeEquipmentDetailKicker: document.getElementById('homeEquipmentDetailKicker'),
  homeEquipmentDetailTitle: document.getElementById('homeEquipmentDetailTitle'),
  homeEquipmentDetailBody: document.getElementById('homeEquipmentDetailBody'),
  homeEquipmentDetailFooter: document.getElementById('homeEquipmentDetailFooter'),
  homeFeatureScreen: document.getElementById('homeFeatureScreen'),
  homeMailBadge: document.getElementById('homeMailBadge'),
  homeMissionModal: document.getElementById('homeMissionModal'),
  homeMissionBody: document.getElementById('homeMissionBody'),
  homeMissionFooter: document.getElementById('homeMissionFooter'),
  homeShopModal: document.getElementById('homeShopModal'),
  homeShopBody: document.getElementById('homeShopBody'),
  homeShopFooter: document.getElementById('homeShopFooter'),
  homeQuickModal: document.getElementById('homeQuickModal'),
  homeQuickTitle: document.getElementById('homeQuickTitle'),
  homeQuickKicker: document.getElementById('homeQuickKicker'),
  homeQuickBody: document.getElementById('homeQuickBody'),
  homeQuickFooter: document.getElementById('homeQuickFooter'),
  homeBuildingPanel: document.getElementById('homeBuildingPanel'),
  homeBuildModal: document.getElementById('homeBuildModal'),
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

const titleSplashState = {
  startedAt: performance.now(),
  ready: false,
  hidden: TITLE_SPLASH_DISABLED,
  hideTimer: null,
};

document.documentElement.dataset.titleSplash = TITLE_SPLASH_DISABLED ? 'disabled' : 'visible';
document.documentElement.dataset.titleSplashSelected = 'ninja2_title_splash_genimage_b_lantern_festival';

function hideTitleSplash({ immediate = false } = {}) {
  if (titleSplashState.hidden) return;
  titleSplashState.hidden = true;
  if (titleSplashState.hideTimer) {
    clearTimeout(titleSplashState.hideTimer);
    titleSplashState.hideTimer = null;
  }
  if (immediate) dom.titleSplash?.classList.add('is-immediate');
  document.documentElement.dataset.titleSplash = 'hidden';
  dom.titleSplash?.setAttribute('aria-hidden', 'true');
}

function scheduleTitleSplashDismiss() {
  if (TITLE_SPLASH_DISABLED || TITLE_SPLASH_HOLD || titleSplashState.hidden) return;
  const elapsed = performance.now() - titleSplashState.startedAt;
  const delay = Math.max(0, TITLE_SPLASH_MIN_VISIBLE_MS - elapsed);
  titleSplashState.hideTimer = globalThis.setTimeout(() => hideTitleSplash(), delay);
}

function markTitleSplashReady() {
  titleSplashState.ready = true;
  if (!TITLE_SPLASH_DISABLED) {
    document.documentElement.dataset.titleSplashReady = 'true';
  }
  if (document.documentElement.dataset.titleSplashPendingDismiss === 'true') {
    hideTitleSplash({ immediate: true });
    return;
  }
  scheduleTitleSplashDismiss();
}

function installTitleSplashController() {
  if (!dom.titleSplash || TITLE_SPLASH_DISABLED) return;
  const requestHide = () => {
    if (titleSplashState.ready) hideTitleSplash({ immediate: true });
    else document.documentElement.dataset.titleSplashPendingDismiss = 'true';
  };
  dom.titleSplash.addEventListener('click', requestHide);
  dom.titleSplash.addEventListener('pointerdown', requestHide);
  globalThis.addEventListener('keydown', event => {
    if (event.key === 'Enter' || event.key === ' ' || event.key === 'Escape') requestHide();
  });
}

let homeSkinGames = [];
let activeHomeTab = 'sanctuary';
let activeEquipmentFilter = 'all';
let activeHomeShopCategory = normalizeHomeShopCategoryKey(params.get('shopCategory'));
let homeEquipmentDetailItemId = 0;
let activeHomeQuickView = '';
let homeBuildTrayOpen = false;
let homeDungeonDetailOpen = false;
const homeBuildGhostPointer = { x: 220, y: 420, ready: false };
const homeBuildHover = { anchorTileId: 0 };

const RESOURCE_LEDGER_ROWS = Object.fromEntries(
  [...document.querySelectorAll('.ledger-row')].map(row => [row.dataset.resource, row])
);
const HOME_RESOURCE_ROWS = Object.fromEntries(
  [...document.querySelectorAll('.resource-row[data-home-resource]')].map(row => [row.dataset.homeResource, row])
);

const STATE_RESOURCE_KEYS = {
  ad_removal: 'adRemoval',
  energy: 'energy',
  free_ruby: 'freeRuby',
  gold: 'gold',
  ruby: 'ruby',
  wood: 'wood',
  stone: 'stone',
  soulflame: 'souls',
  souls: 'souls',
  lantern: 'light',
  exp: 'exp',
  herb: 'herb',
  tool: 'tool',
};
const HOME_RESOURCE_KEYS = Object.freeze(['wood', 'souls', 'gold', 'stone', 'tool', 'food', 'bamboo', 'iron_ore']);
const HOME_RESOURCE_FLY_SIZE = 34;
const HOME_TAB_KEYS = new Set(['sanctuary', 'equipment', 'exploration', 'missions', 'shop']);
const REQUESTED_HOME_TAB = String(params.get('tab') || params.get('homeTab') || '').toLowerCase();
if (REQUESTED_HOME_TAB === 'residents' || REQUESTED_HOME_TAB === 'companions') {
  activeHomeTab = 'equipment';
} else if (HOME_TAB_KEYS.has(REQUESTED_HOME_TAB)) {
  activeHomeTab = REQUESTED_HOME_TAB;
}
const REQUESTED_EQUIPMENT_DETAIL_ID = Math.max(0, Math.floor(Number(params.get('equipmentDetail') || params.get('itemDetail') || 0) || 0));
if (REQUESTED_EQUIPMENT_DETAIL_ID > 0) {
  activeHomeTab = 'equipment';
  homeEquipmentDetailItemId = REQUESTED_EQUIPMENT_DETAIL_ID;
}
const REQUESTED_DUNGEON_DETAIL_ID = Number(params.get('dungeonDetail') || params.get('dungeon') || 0);
const REQUESTED_DUNGEON_DETAIL_OPEN = SIDE_DUNGEON_IDS.includes(REQUESTED_DUNGEON_DETAIL_ID);
const REQUESTED_DUNGEON_DIFFICULTY_KEY = String(params.get('difficulty') || params.get('dungeonDifficulty') || '').toLowerCase();
if (REQUESTED_DUNGEON_DETAIL_OPEN) {
  activeHomeTab = 'exploration';
  homeDungeonDetailOpen = true;
}
const HOME_RESOURCE_LABELS = Object.freeze({
  energy: '에너지',
  free_ruby: '무료 루비',
  gold: '골드',
  ruby: '루비',
  souls: '영혼불',
  wood: '목재',
  stone: '석재',
  soulflame: '영혼불',
  tool: '도구',
  food: '식량',
  bamboo: '대나무',
  iron_ore: '철광석',
});
const HOME_INCOME_MAX_ELAPSED_MS = 8 * 60 * 60 * 1000;
const HOME_INCOME_ANIMATION_MS = 720;

const HOME_HEX_WIDTH = 86;
const HOME_HEX_HEIGHT = 99;
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
    purpose: building.purpose,
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
  const productionStoredAmount = Math.max(0, Number(raw.productionStoredAmount ?? raw.production?.storedAmount ?? 0) || 0);
  const productionLastSettledAt = Number(raw.productionLastSettledAt ?? raw.production?.lastSettledAt ?? raw.lastIncomeAt ?? Date.now());
  return {
    id,
    buildingKey: building.key,
    ordinal,
    level: clamp(Math.floor(Number(raw.level) || 1), 1, maxLevel),
    status,
    placement,
    startedAt: status === 'constructing' ? startedAt || Date.now() : null,
    finishAt: status === 'constructing' ? finishAt : null,
    productionStoredAmount: status === 'built' ? productionStoredAmount : 0,
    productionLastSettledAt: status === 'built' ? productionLastSettledAt || Date.now() : null,
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
  clearedMapIds: [],
  currentMapId: START_MAP_ID,
  highestUnlockedMapId: START_MAP_ID,
  lastPlayedMapId: START_MAP_ID,
  selectedDungeonMapId: SIDE_DUNGEON_IDS[0],
  lastDungeonMapId: SIDE_DUNGEON_IDS[0],
  selectedDungeonDifficultyKey: DUNGEON_DIFFICULTIES[0].key,
  lastDungeonDifficultyKey: DUNGEON_DIFFICULTIES[0].key,
  clearedDungeonIds: [],
  companionExp: 0,
  companionShards: 0,
  companionGachaPulls: 0,
  companions: defaultCompanionState(),
  itemInventory: {},
  equippedItemIds: {},
  selectedEquipmentItemId: 0,
  claimedMissionKeys: [],
  mailClaims: {},
  mailReadKeys: [],
  passClaimedTiers: [],
  shopClaims: {},
  dailyGiftClaimDate: '',
  adRemoval: false,
  energy: 30,
  ruby: 0,
  freeRuby: 0,
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
    clearedMapIds: MAIN_MAP_IDS.slice(0, 3),
    currentMapId: 500104,
    highestUnlockedMapId: 500104,
    lastPlayedMapId: 500103,
    selectedDungeonMapId: 500202,
    lastDungeonMapId: 500201,
    selectedDungeonDifficultyKey: 'easy',
    lastDungeonDifficultyKey: 'normal',
    clearedDungeonIds: [500201],
    companionExp: 380,
    companionShards: 6,
    companionGachaPulls: 9,
    companions: {
      kaede: { unlocked: true, equipped: true, level: 3, exp: 260 },
      mio: { unlocked: true, equipped: true, level: 3, exp: 240 },
      rin: { unlocked: true, equipped: true, level: 2, exp: 180 },
    },
    itemInventory: {
      200201: 1,
      200301: 1,
      200311: 1,
      200321: 1,
      200331: 1,
      200344: 1,
      200351: 1,
      200204: 1,
      200304: 1,
      200314: 1,
      200324: 1,
      200334: 1,
    },
    equippedItemIds: {
      weapon: 200201,
      head: 200301,
      chest: 200311,
      gloves: 200321,
      boots: 200331,
      necklace: 200344,
      ring: 200351,
    },
    selectedEquipmentItemId: 200204,
    adRemoval: false,
    energy: 80,
    ruby: 180,
    freeRuby: 40,
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

function isMainMapId(mapId) {
  return MAIN_MAP_IDS.includes(Number(mapId));
}

function mainMapIndex(mapId) {
  return MAIN_MAP_IDS.indexOf(Number(mapId));
}

function mainMapStageNo(mapId) {
  const index = mainMapIndex(mapId);
  return index >= 0 ? index + 1 : null;
}

function normalizeMainMapId(mapId, fallback = START_MAP_ID) {
  const id = Number(mapId);
  return isMainMapId(id) ? id : normalizeMainMapId(fallback, MAIN_MAP_IDS[0]);
}

function normalizeClearedMapIds(rawState = {}) {
  const rawIds = Array.isArray(rawState.clearedMapIds) ? rawState.clearedMapIds : [];
  const ids = new Set(rawIds.map(Number).filter(isMainMapId));
  if (!ids.size) {
    const legacyClears = clamp(Math.floor(Number(rawState.stageClears || 0)), 0, MAIN_MAP_IDS.length);
    MAIN_MAP_IDS.slice(0, legacyClears).forEach(id => ids.add(id));
  }
  return MAIN_MAP_IDS.filter(id => ids.has(id));
}

function isMainMapCleared(state, mapId) {
  return normalizeClearedMapIds(state).includes(Number(mapId));
}

function highestUnlockedMainMapId(state) {
  const clearedIds = normalizeClearedMapIds(state);
  const clearedHighestIndex = clearedIds.reduce((max, id) => Math.max(max, mainMapIndex(id)), -1);
  const byClearsIndex = clamp(clearedHighestIndex + 1, 0, MAIN_MAP_IDS.length - 1);
  const explicitIndex = Math.max(0, mainMapIndex(state?.highestUnlockedMapId));
  return MAIN_MAP_IDS[Math.max(explicitIndex, byClearsIndex)] || START_MAP_ID;
}

function isMainMapUnlocked(state, mapId) {
  const targetIndex = mainMapIndex(mapId);
  if (targetIndex < 0) return false;
  return targetIndex <= mainMapIndex(highestUnlockedMainMapId(state));
}

function syncMainMapProgress(state) {
  if (!state) return state;
  state.clearedMapIds = normalizeClearedMapIds(state);
  state.highestUnlockedMapId = highestUnlockedMainMapId(state);
  const preferredMapId = normalizeMainMapId(
    state.currentMapId || state.selectedMapId || state.lastPlayedMapId || state.highestUnlockedMapId,
    state.highestUnlockedMapId
  );
  state.currentMapId = isMainMapUnlocked(state, preferredMapId) ? preferredMapId : state.highestUnlockedMapId;
  state.lastPlayedMapId = normalizeMainMapId(state.lastPlayedMapId || state.currentMapId, state.currentMapId);
  state.stageClears = Math.max(
    Math.floor(Number(state.stageClears || 0)),
    state.clearedMapIds.length
  );
  return state;
}

function markMainMapCleared(state, mapId) {
  const id = normalizeMainMapId(mapId, state?.currentMapId || START_MAP_ID);
  if (!state || !isMainMapId(id)) return null;
  const ids = new Set(normalizeClearedMapIds(state));
  ids.add(id);
  state.clearedMapIds = MAIN_MAP_IDS.filter(candidate => ids.has(candidate));
  state.stageClears = Math.max(Math.floor(Number(state.stageClears || 0)), state.clearedMapIds.length);
  state.highestUnlockedMapId = highestUnlockedMainMapId(state);
  const nextId = MAIN_MAP_IDS[mainMapIndex(id) + 1] || null;
  if (nextId && isMainMapUnlocked(state, nextId)) {
    state.currentMapId = nextId;
  } else {
    state.currentMapId = id;
  }
  return {
    clearedMapId: id,
    clearedStageNo: mainMapStageNo(id),
    nextMapId: nextId && isMainMapUnlocked(state, nextId) ? nextId : null,
    completedChapter: !nextId,
  };
}

function isSideDungeonMapId(mapId) {
  return SIDE_DUNGEON_IDS.includes(Number(mapId));
}

function normalizeSideDungeonMapId(mapId, fallback = SIDE_DUNGEON_IDS[0]) {
  const id = Number(mapId);
  if (isSideDungeonMapId(id)) return id;
  const fallbackId = Number(fallback);
  return isSideDungeonMapId(fallbackId) ? fallbackId : SIDE_DUNGEON_IDS[0];
}

function normalizeClearedDungeonIds(rawState = {}) {
  const rawIds = Array.isArray(rawState.clearedDungeonIds) ? rawState.clearedDungeonIds : [];
  const ids = new Set(rawIds.map(Number).filter(isSideDungeonMapId));
  return SIDE_DUNGEON_IDS.filter(id => ids.has(id));
}

function normalizeDungeonDifficultyKey(key, fallback = DUNGEON_DIFFICULTIES[0].key) {
  const raw = String(key || '').toLowerCase();
  if (DUNGEON_DIFFICULTIES.some(difficulty => difficulty.key === raw)) return raw;
  const safeFallback = String(fallback || '').toLowerCase();
  return DUNGEON_DIFFICULTIES.some(difficulty => difficulty.key === safeFallback)
    ? safeFallback
    : DUNGEON_DIFFICULTIES[0].key;
}

function getDungeonUnlockStageClears(scene, dungeonId) {
  const map = scene?.store?.getMap?.(dungeonId);
  const copy = SIDE_DUNGEON_COPY[dungeonId] || {};
  return Math.max(0, Math.floor(Number(
    map?.popupArgs?.ClientUnlockStageClears ?? copy.unlockStageClears ?? 0
  )));
}

function isSideDungeonUnlocked(scene, state, dungeonId) {
  const stageClears = Math.max(0, Number(state?.stageClears || 0));
  return stageClears >= getDungeonUnlockStageClears(scene, Number(dungeonId));
}

function getDungeonDifficultyUnlockStageClears(scene, dungeonId, difficulty) {
  return getDungeonUnlockStageClears(scene, dungeonId) + Math.max(0, Number(difficulty?.unlockOffset || 0));
}

function getDungeonDifficultyEntries(scene, state, dungeonId = state?.selectedDungeonMapId) {
  const safeDungeonId = normalizeSideDungeonMapId(dungeonId, state?.selectedDungeonMapId || SIDE_DUNGEON_IDS[0]);
  const stageClears = Math.max(0, Math.floor(Number(state?.stageClears || 0)));
  const selectedKey = normalizeDungeonDifficultyKey(state?.selectedDungeonDifficultyKey || state?.lastDungeonDifficultyKey);
  return DUNGEON_DIFFICULTIES.map(difficulty => {
    const unlockStageClears = getDungeonDifficultyUnlockStageClears(scene, safeDungeonId, difficulty);
    const unlocked = isSideDungeonUnlocked(scene, state, safeDungeonId) && stageClears >= unlockStageClears;
    return {
      ...difficulty,
      dungeonId: safeDungeonId,
      unlockStageClears,
      unlocked,
      selected: difficulty.key === selectedKey,
      unlock: `Stage ${unlockStageClears} 클리어`,
    };
  });
}

function getSelectedDungeonDifficultyEntry(scene, state, dungeonId = state?.selectedDungeonMapId) {
  const entries = getDungeonDifficultyEntries(scene, state, dungeonId);
  return entries.find(entry => entry.selected && entry.unlocked)
    || entries.find(entry => entry.unlocked)
    || entries[0]
    || DUNGEON_DIFFICULTIES[0];
}

function syncSideDungeonProgress(scene, state) {
  if (!state) return state;
  state.clearedDungeonIds = normalizeClearedDungeonIds(state);
  const preferredId = normalizeSideDungeonMapId(state.selectedDungeonMapId || state.lastDungeonMapId);
  const firstUnlocked = SIDE_DUNGEON_IDS.find(id => isSideDungeonUnlocked(scene, state, id));
  state.selectedDungeonMapId = isSideDungeonUnlocked(scene, state, preferredId)
    ? preferredId
    : firstUnlocked || preferredId;
  state.lastDungeonMapId = normalizeSideDungeonMapId(state.lastDungeonMapId || state.selectedDungeonMapId);
  state.selectedDungeonDifficultyKey = normalizeDungeonDifficultyKey(
    state.selectedDungeonDifficultyKey || state.lastDungeonDifficultyKey
  );
  const selectedDifficulty = getSelectedDungeonDifficultyEntry(scene, state, state.selectedDungeonMapId);
  state.selectedDungeonDifficultyKey = selectedDifficulty?.key || DUNGEON_DIFFICULTIES[0].key;
  state.lastDungeonDifficultyKey = normalizeDungeonDifficultyKey(
    state.lastDungeonDifficultyKey || state.selectedDungeonDifficultyKey,
    state.selectedDungeonDifficultyKey
  );
  return state;
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
  state.clearedMapIds = normalizeClearedMapIds(state);
  state.currentMapId = normalizeMainMapId(rawState.currentMapId || rawState.selectedMapId || state.currentMapId, START_MAP_ID);
  state.highestUnlockedMapId = normalizeMainMapId(rawState.highestUnlockedMapId || state.highestUnlockedMapId, START_MAP_ID);
  state.lastPlayedMapId = normalizeMainMapId(rawState.lastPlayedMapId || state.lastPlayedMapId, state.currentMapId);
  syncMainMapProgress(state);
  state.companionExp = Math.max(0, Math.floor(Number(state.companionExp || 0)));
  state.companionShards = Math.max(0, Math.floor(Number(state.companionShards || 0)));
  state.selectedDungeonMapId = normalizeSideDungeonMapId(rawState.selectedDungeonMapId || state.selectedDungeonMapId);
  state.lastDungeonMapId = normalizeSideDungeonMapId(rawState.lastDungeonMapId || state.lastDungeonMapId);
  if (REQUESTED_DUNGEON_DETAIL_OPEN) {
    state.selectedDungeonMapId = normalizeSideDungeonMapId(REQUESTED_DUNGEON_DETAIL_ID, state.selectedDungeonMapId);
    state.lastDungeonMapId = state.selectedDungeonMapId;
  }
  state.selectedDungeonDifficultyKey = normalizeDungeonDifficultyKey(
    REQUESTED_DUNGEON_DIFFICULTY_KEY || rawState.selectedDungeonDifficultyKey || state.selectedDungeonDifficultyKey
  );
  state.lastDungeonDifficultyKey = normalizeDungeonDifficultyKey(
    rawState.lastDungeonDifficultyKey || state.lastDungeonDifficultyKey,
    state.selectedDungeonDifficultyKey
  );
  state.clearedDungeonIds = normalizeClearedDungeonIds(state);
  state.companionGachaPulls = Math.max(0, Math.floor(Number(state.companionGachaPulls || 0)));
  state.companions = normalizeCompanionState(rawState.companions);
  state.itemInventory = normalizeItemInventory(rawState.itemInventory);
  state.equippedItemIds = normalizeEquippedItemIds(rawState.equippedItemIds);
  state.selectedEquipmentItemId = normalizeEquipmentItemId(rawState.selectedEquipmentItemId);
  state.claimedMissionKeys = normalizeStringList(rawState.claimedMissionKeys);
  state.mailClaims = normalizeClaimMap(rawState.mailClaims);
  state.mailReadKeys = normalizeStringList(rawState.mailReadKeys);
  state.passClaimedTiers = normalizeStringList(rawState.passClaimedTiers);
  state.shopClaims = normalizeClaimMap(rawState.shopClaims);
  state.dailyGiftClaimDate = typeof rawState.dailyGiftClaimDate === 'string' ? rawState.dailyGiftClaimDate : '';
  state.adRemoval = Boolean(rawState.adRemoval || rawState.ad_removal || state.adRemoval);
  state.energy = Math.max(0, Math.floor(Number(state.energy || 0)));
  state.ruby = Math.max(0, Math.floor(Number(state.ruby || 0)));
  state.freeRuby = Math.max(0, Math.floor(Number(state.freeRuby || state.free_ruby || 0)));
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

function normalizeItemInventory(rawInventory = {}) {
  const normalized = {};
  for (const [rawId, rawCount] of Object.entries(rawInventory || {})) {
    const id = Number(rawId);
    const count = Math.max(0, Math.floor(Number(rawCount || 0)));
    if (!Number.isFinite(id) || id <= 0 || !count) continue;
    normalized[String(id)] = count;
  }
  return normalized;
}

function normalizeStringList(rawList = []) {
  const values = Array.isArray(rawList) ? rawList : [];
  return [...new Set(values.map(value => String(value || '').trim()).filter(Boolean))];
}

function normalizeClaimMap(rawMap = {}) {
  const normalized = {};
  for (const [key, value] of Object.entries(rawMap || {})) {
    const safeKey = String(key || '').trim();
    if (!safeKey) continue;
    normalized[safeKey] = String(value || '').trim() || 'claimed';
  }
  return normalized;
}

function normalizeEquipmentItemId(rawId, fallback = 0) {
  const id = Number(rawId);
  return Number.isFinite(id) && id > 0 ? Math.floor(id) : fallback;
}

function normalizeEquippedItemIds(rawEquipped = {}) {
  const normalized = {};
  for (const [rawSlot, rawItemId] of Object.entries(rawEquipped || {})) {
    const slotKey = String(rawSlot || '').toLowerCase();
    if (!HOME_EQUIPMENT_SLOT_KEYS.has(slotKey)) continue;
    const itemId = normalizeEquipmentItemId(rawItemId);
    if (itemId > 0) normalized[slotKey] = itemId;
  }
  return normalized;
}

function addSanctuaryItem(state, itemDataId, count) {
  const id = Number(itemDataId);
  const safe = Math.max(0, Math.floor(Number(count || 0)));
  if (!Number.isFinite(id) || id <= 0 || !safe) return 0;
  state.itemInventory = normalizeItemInventory(state.itemInventory);
  const key = String(id);
  state.itemInventory[key] = Math.max(0, Number(state.itemInventory[key] || 0) + safe);
  return safe;
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

function getHomeBuildPlanBuilding(state) {
  return BUILDING_BY_KEY.get(state?.buildPlanBuildingKey) || null;
}

function getHomePlacementPreview(state) {
  const building = getHomeBuildPlanBuilding(state);
  const anchor = HEX_BY_ID.get(Number(homeBuildHover.anchorTileId));
  if (!state || !building || !anchor) return null;

  const validation = getPlacementValidation(state, building, anchor.id);
  const placement = validation.placement || makeBuildingPlacement(building, anchor.id);
  return {
    building,
    anchorTileId: anchor.id,
    placement,
    tiles: placement?.tiles?.length ? placement.tiles : [anchor.id],
    valid: Boolean(validation.ok),
    reason: validation.reason || '',
  };
}

function getBuildingFootprintMetrics(building) {
  const centers = getBuildingFootprintOffsets(building).map(([dq, dr]) => ({
    x: dq * 73 + dr * 36.5,
    y: dr * 65,
  }));
  const xs = centers.map(center => center.x);
  const ys = centers.map(center => center.y);
  return {
    width: Math.round(Math.max(...xs) - Math.min(...xs) + HOME_HEX_WIDTH),
    height: Math.round(Math.max(...ys) - Math.min(...ys) + HOME_HEX_HEIGHT),
  };
}

function setHomeBuildHoverTile(scene, tileId) {
  const state = scene?.sanctuary;
  const building = getHomeBuildPlanBuilding(state);
  const nextTileId = building && HEX_BY_ID.has(Number(tileId)) ? Number(tileId) : 0;
  if (homeBuildHover.anchorTileId === nextTileId) return;
  homeBuildHover.anchorTileId = nextTileId;
  if (state && building) renderHome(scene);
}

function homeBuildTileIdFromEvent(event) {
  const target = event?.target?.closest?.('[data-tile-id]');
  return target ? Number(target.dataset.tileId || 0) : 0;
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
    this.lastMoveVector = new PhaserRef.Math.Vector2(0, 1);
    this.pointerActive = false;
    this.ready = false;
    this.paused = false;
    this.mode = 'boot';
    this.runRewards = [];
    this.runDrops = 0;
    this.runLedger = createRunLedger();
    this.lootDrops = [];
    this.lootDropSerial = 1;
    this.ledgerGainTimers = new Map();
    this.homeIncomeTimers = new Map();
    this.sanctuary = loadSanctuary();
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
    this.combatCueCount = 0;
    this.skillIntentCueCount = 0;
    this.enemyHitCueCount = 0;
    this.playerThreatCueCount = 0;
    this.enemyThreatCueCount = 0;
    this.lastThreatCueDatasetAt = 0;
    this.lastPlayerThreatCueAt = -Infinity;
    this.lastRunImpactCueWindowAt = 0;
    this.runImpactCueWindowCount = 0;
    this.playerDashState = null;
    this.playerDashReadyAt = 0;
    this.playerDashInvulnerableUntil = 0;
    this.playerDashCount = 0;
    this.playerDashBlockedDamageCount = 0;
    this.lastDashDeniedAt = -Infinity;
    this.lastDashBlockedCueAt = -Infinity;
    const backgroundMusicSuppressed = shouldSuppressNinja2BackgroundMusic();
    const soundEffectsSuppressed = shouldSuppressNinja2SoundEffects();
    const soundEffectsForced = shouldForceNinja2SoundEffects();
    const initialSettings = resolveSettings({
      defaultBgmEnabled: !backgroundMusicSuppressed,
      defaultSfxEnabled: !soundEffectsSuppressed,
    });
    this.backgroundMusic = null;
    this.backgroundMusicStarted = false;
    this.backgroundMusicKey = '';
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
    BATTLE_FOREST_PROPS.forEach(({ key, path }) => {
      this.load.image(key, `${path}?v=${ASSET_VERSION}`);
    });
    SKILL_VFX_ATOM_ASSETS.forEach(({ key, path }) => {
      this.load.image(key, `${path}?v=${ASSET_VERSION}`);
    });
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
    for (const def of Object.values(NINJA2_BGM_TRACKS)) {
      this.load.audio(def.key, [def.path]);
    }
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

  getBackgroundMusicTrack() {
    const trackKey = NINJA2_BGM_MODE_TRACKS[this.mode] || 'home';
    return NINJA2_BGM_TRACKS[trackKey] || NINJA2_BGM_TRACKS.home;
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
      const track = this.getBackgroundMusicTrack();
      try {
        if (this.backgroundMusic && this.backgroundMusicKey !== track.key) {
          this.backgroundMusic.stop?.();
          this.backgroundMusic.destroy?.();
          this.backgroundMusic = null;
          this.backgroundMusicStarted = false;
        }
        if (!this.backgroundMusic) {
          this.backgroundMusic = this.sound.add(track.key, {
            loop: true,
            volume: track.volume,
          });
          this.backgroundMusicKey = track.key;
        } else if (typeof this.backgroundMusic.setVolume === 'function') {
          this.backgroundMusic.setVolume(track.volume);
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
    const track = this.getBackgroundMusicTrack?.();
    root.dataset.bgm = this.backgroundMusicSuppressed ? 'off' : 'on';
    root.dataset.sfx = this.sfxEnabled ? 'on' : 'off';
    root.dataset.ninja2Volume = this.backgroundMusicSuppressed ? 'off' : 'on';
    root.dataset.ninja2Sfx = this.sfxEnabled ? 'on' : 'off';
    if (track) {
      root.dataset.ninja2BgmTrack = track.key;
      root.dataset.ninja2BgmPath = track.path;
    }
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
    markTitleSplashReady();

    if (['battle', 'combat', 'expedition'].includes(INITIAL_MODE)) {
      requestAnimationFrame(() => this.startExpedition({ free: true, mapId: START_MAP_ID }));
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
    board.on('unitDrops', event => this.spawnUnitLootDrops(event));
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
    if (mode !== 'expedition') {
      this.playerDashState = null;
      this.playerDashInvulnerableUntil = 0;
      setPlayerHealthDangerDataset(null);
    }
    this.updatePlayerDashDataset();
    dom.bootStatus.style.display = 'none';
    dom.homeScreen?.classList.toggle('is-open', mode === 'home');
    dom.resultScreen?.classList.toggle('is-open', mode === 'result');
    dom.pauseButton.disabled = mode !== 'expedition';
    dom.returnButton.disabled = mode !== 'expedition';
    this.syncBackgroundMusic();
  }

  startExpedition({ free = false, mapId = null, dungeonDifficulty = null } = {}) {
    if (!this.ready || !this.board) return;
    setHomeSettingsOpen(false);
    syncCompanionUnlocks(this.sanctuary);
    syncSideDungeonProgress(this, this.sanctuary);
    const rawRequestedMapId = Number(mapId || this.sanctuary.currentMapId || this.sanctuary.lastPlayedMapId || START_MAP_ID);
    const isSideDungeonRun = isSideDungeonMapId(rawRequestedMapId);
    const requestedMapId = isSideDungeonRun
      ? normalizeSideDungeonMapId(rawRequestedMapId)
      : normalizeMainMapId(
        rawRequestedMapId,
        this.sanctuary.highestUnlockedMapId || START_MAP_ID
      );
    if (free && !isSideDungeonRun && !isMainMapUnlocked(this.sanctuary, requestedMapId)) {
      this.sanctuary.highestUnlockedMapId = requestedMapId;
    }
    syncMainMapProgress(this.sanctuary);
    const targetMapId = isSideDungeonRun
      ? requestedMapId
      : isMainMapUnlocked(this.sanctuary, requestedMapId)
        ? requestedMapId
        : highestUnlockedMainMapId(this.sanctuary);
    const requestedDifficultyKey = normalizeDungeonDifficultyKey(
      dungeonDifficulty
        || REQUESTED_DUNGEON_DIFFICULTY_KEY
        || this.sanctuary.selectedDungeonDifficultyKey
        || this.sanctuary.lastDungeonDifficultyKey
    );
    const requestedDifficulty = isSideDungeonRun
      ? getDungeonDifficultyEntries(this, this.sanctuary, requestedMapId).find(entry => entry.key === requestedDifficultyKey)
      : null;
    if (!free && isSideDungeonRun && !isSideDungeonUnlocked(this, this.sanctuary, requestedMapId)) {
      const entry = getDungeonEntries(this, this.sanctuary).find(row => row.id === requestedMapId);
      this.sanctuary.lastLog = `${entry?.name || '던전'} 해금 조건: ${entry?.unlock || '메인 진행 필요'}`;
      renderHome(this);
      this.playSfx('uiError', { volume: 0.68 });
      return;
    }
    if (!free && isSideDungeonRun && requestedDifficulty && !requestedDifficulty.unlocked) {
      const entry = getDungeonEntries(this, this.sanctuary).find(row => row.id === requestedMapId);
      this.sanctuary.lastLog = `${entry?.name || '던전'} ${requestedDifficulty.label} 해금 조건: ${requestedDifficulty.unlock}`;
      renderHome(this);
      this.playSfx('uiError', { volume: 0.68 });
      return;
    }
    if (!free && !isSideDungeonRun && !isMainMapUnlocked(this.sanctuary, requestedMapId)) {
      const fallbackStage = mainMapStageNo(targetMapId) || 1;
      this.sanctuary.lastLog = `아직 잠긴 길입니다. 먼저 Stage ${fallbackStage}까지 정화하세요.`;
      renderHome(this);
      this.playSfx('uiError', { volume: 0.68 });
      return;
    }
    if (!free && this.mode === 'home') {
      if (Number(this.sanctuary.light || 0) < 1) {
        this.sanctuary.lastLog = '출전에는 등불 1이 필요합니다. 성소 생산이나 이전 원정 보상으로 등불을 모으세요.';
        renderHome(this);
        this.playSfx('uiError', { volume: 0.68 });
        return;
      }
      if (isSideDungeonRun) {
        this.sanctuary.selectedDungeonMapId = targetMapId;
        this.sanctuary.lastDungeonMapId = targetMapId;
        this.sanctuary.selectedDungeonDifficultyKey = requestedDifficulty?.key || requestedDifficultyKey;
        this.sanctuary.lastDungeonDifficultyKey = this.sanctuary.selectedDungeonDifficultyKey;
      } else {
        this.sanctuary.currentMapId = targetMapId;
        this.sanctuary.lastPlayedMapId = targetMapId;
      }
      this.sanctuary.light = Math.max(0, Number(this.sanctuary.light || 0) - 1);
      this.sanctuary.lastIncomeAt = Date.now();
      saveSanctuary(this.sanctuary);
    }
    if (isSideDungeonRun) {
      this.sanctuary.selectedDungeonMapId = targetMapId;
      this.sanctuary.lastDungeonMapId = targetMapId;
      this.sanctuary.selectedDungeonDifficultyKey = requestedDifficulty?.key || requestedDifficultyKey;
      this.sanctuary.lastDungeonDifficultyKey = this.sanctuary.selectedDungeonDifficultyKey;
    } else {
      this.sanctuary.currentMapId = targetMapId;
      this.sanctuary.lastPlayedMapId = targetMapId;
    }
    this.activeMapId = targetMapId;
    this.setMode('expedition');
    this.syncBackgroundMusic();
    this.paused = false;
    this.runRewards = [];
    this.runDrops = 0;
    this.runLedger = createRunLedger();
    this.clearLootDrops();
    this.lootDropSerial = 1;
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

    this.board.start(targetMapId, { preserveProgress: false });
    if (this.board.map?.popupArgs) {
      this.board.map.popupArgs.ClientAutoAdvance = false;
    }
    const stageNo = this.store?.getMainStageNumber?.(targetMapId) || mainMapStageNo(targetMapId) || 1;
    const waveCount = Math.max(1, Math.floor(Number(this.board.map?.popupArgs?.ClientWaveCount || 0)) || 1);
    document.documentElement.dataset.survivorSelectedMapId = String(targetMapId);
    document.documentElement.dataset.survivorRunMapKind = isSideDungeonRun ? 'side-dungeon' : 'main';
    document.documentElement.dataset.survivorDungeonMapId = isSideDungeonRun ? String(targetMapId) : '';
    document.documentElement.dataset.survivorDungeonDifficulty = isSideDungeonRun
      ? (requestedDifficulty?.key || requestedDifficultyKey)
      : '';
    document.documentElement.dataset.survivorMainStageNo = String(stageNo);
    document.documentElement.dataset.survivorWaveCount = String(waveCount);
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
    document.documentElement.dataset.survivorBattleVisualFixture = BATTLE_VISUAL_POLISH_FIXTURE ? 'pending' : '';
    this.resetPlayerDash();
    this.resetCombatReadabilityCounters();

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
    if (BATTLE_VISUAL_POLISH_FIXTURE) {
      this.applyBattleVisualPolishFixture();
    }

    this.syncUnitViews();
    this.syncBattleCamera({ snap: true });
    this.resetCompanionSkillCooldowns();
    renderHud(this);
    this.stopSkillVfxDemo = maybeStartSkillVfxDemo(this);
    this.stopLevelChoiceDemo = this.maybeStartLevelChoiceDemo();
  }

  applyBattleVisualPolishFixture() {
    if (!this.board || this.mode !== 'expedition') return;
    const player = this.board.playerUnit;
    if (!player?.alive) return;

    const playerX = WORLD.centerX;
    const playerY = WORLD.centerY + 76;
    player.x = playerX;
    player.y = playerY;
    player.targetX = playerX;
    player.targetY = playerY;
    player.state = 'combat';
    player.hp = Math.min(player.maxHp || player.hp || 1, Math.max(player.hp || 1, Math.round((player.maxHp || 1) * 0.92)));
    player.attack = Math.max(3, Math.round((player.attack || 12) * 0.16));

    const fixtureDefs = this.getBattleVisualFixtureUnitDefs();
    const fixtureLevel = Math.max(6, Math.floor(Number(this.board.boardState || player.level || 1)));
    const boss = fixtureDefs.bossDef
      ? this.findOrSpawnFixtureEnemy(fixtureDefs.bossDef.id, {
        level: fixtureLevel + 5,
        x: playerX + 18,
        y: playerY - 285,
        targetX: playerX + 18,
        targetY: playerY - 255,
      })
      : null;
    this.lockFixtureUnitForCapture(boss, { hpMultiplier: 24, target: player, visualScaleMultiplier: 0.56 });

    const ringSlots = [
      { x: -330, y: -220 },
      { x: 320, y: -212 },
      { x: -305, y: 138 },
      { x: 312, y: 152 },
      { x: -390, y: -10 },
      { x: 398, y: 28 },
      { x: -168, y: 286 },
      { x: 190, y: 280 },
    ];
    const enemies = ringSlots
      .map((slot, index) => {
        const enemyDef = fixtureDefs.enemyDefs[index % Math.max(1, fixtureDefs.enemyDefs.length)];
        if (!enemyDef) return null;
        const unit = this.findOrSpawnFixtureEnemy(enemyDef.id, {
          level: fixtureLevel + (index % 3),
          x: playerX + slot.x,
          y: playerY + slot.y,
          targetX: playerX + slot.x * 0.48,
          targetY: playerY + slot.y * 0.48,
        });
        this.lockFixtureUnitForCapture(unit, { hpMultiplier: 10, target: player, visualScaleMultiplier: 0.92 });
        return unit;
      })
      .filter(Boolean);

    this.clearFixtureLootDrops();
    [
      { key: 'exp', count: 8, x: -250, y: -126 },
      { key: 'gold', count: 120, x: 256, y: -100 },
      { key: 'souls', count: 3, x: -350, y: 104 },
      { key: 'wood', count: 5, x: 333, y: 148 },
      { key: 'stone', count: 4, x: -88, y: 284 },
      { key: 'exp', count: 10, x: 120, y: 266 },
    ]
      .map(drop => ({ ...drop, itemDataId: this.fixtureItemIdForRewardKey(drop.key) }))
      .filter(drop => drop.itemDataId)
      .forEach(drop => this.spawnFixtureLootDrop({
        ...drop,
        x: playerX + drop.x,
        y: playerY + drop.y,
      }));

    if (enemies.length) {
      this.board.startSkill(player, 300101, enemies.slice(0, 3), { source: 'battleVisualPolishFixture' });
    }
    document.documentElement.dataset.survivorBattleVisualFixture = BATTLE_VISUAL_POLISH_VERSION;
    document.documentElement.dataset.survivorBattleVisualFixtureEnemyCount = String(enemies.length + (boss ? 1 : 0));
    this.syncLootDropDataset();
  }

  getBattleVisualFixtureUnitDefs() {
    const playerDef = this.store?.getPlayerUnit?.();
    const defs = [...(this.store?.units?.values?.() || [])]
      .filter(def => def && Number(def.id) !== Number(playerDef?.id));
    const bossDef = defs.find(def => def.type === 'Boss') || null;
    const enemyDefs = defs
      .filter(def => def.id !== bossDef?.id)
      .filter(def => def.type !== 'Boss');
    return { bossDef, enemyDefs };
  }

  fixtureItemIdForRewardKey(key) {
    const item = [...(this.store?.items?.values?.() || [])]
      .find(candidate => homeRewardKeyForItemId(candidate?.id) === key);
    return item?.id || 0;
  }

  findOrSpawnFixtureEnemy(unitDataId, options = {}) {
    let unit = [...this.board.units.values()]
      .find(candidate => candidate.alive && Number(candidate.dataId) === Number(unitDataId));
    if (!unit) {
      unit = this.board.spawnUnit(unitDataId, {
        team: TEAM.ENEMY,
        level: options.level,
        x: options.x,
        y: options.y,
        targetX: options.targetX ?? options.x,
        targetY: options.targetY ?? options.y,
        state: 'combat',
      });
    }
    if (!unit) return null;
    unit.alive = true;
    unit.level = Math.max(1, Math.floor(Number(options.level || unit.level || 1)));
    unit.x = clamp(Number(options.x ?? unit.x), 56, WORLD.width - 56);
    unit.y = clamp(Number(options.y ?? unit.y), 56, WORLD.height - 56);
    unit.targetX = clamp(Number(options.targetX ?? unit.x), 56, WORLD.width - 56);
    unit.targetY = clamp(Number(options.targetY ?? unit.y), 56, WORLD.height - 56);
    unit.state = 'combat';
    return unit;
  }

  lockFixtureUnitForCapture(unit, { hpMultiplier = 6, target = null, visualScaleMultiplier = 1 } = {}) {
    if (!unit) return;
    const targetUnit = target || this.board?.playerUnit;
    unit.visualFixtureBaseMaxHp = unit.visualFixtureBaseMaxHp || unit.maxHp || 1;
    unit.maxHp = Math.max(unit.maxHp || 1, Math.round(unit.visualFixtureBaseMaxHp * hpMultiplier));
    unit.hp = Math.max(1, Math.round(unit.maxHp * (unit.type === 'Boss' ? 0.78 : 0.86)));
    unit.visualScaleMultiplier = clamp(Number(visualScaleMultiplier || 1), 0.45, 1.25);
    if (targetUnit) {
      unit.targetX = targetUnit.x;
      unit.targetY = targetUnit.y;
    }
  }

  clearFixtureLootDrops() {
    for (const loot of [...this.lootDrops]) {
      if (loot?.sourceUnitDataId !== 'visual-polish-fixture') continue;
      this.removeLootDrop(loot);
    }
  }

  spawnFixtureLootDrop({ itemDataId, count = 1, x, y }) {
    const id = Number(itemDataId);
    const resourceKey = homeRewardKeyForItemId(id);
    const texture = this.lootTextureForDrop({ itemDataId: id }, resourceKey);
    const sprite = this.add.sprite(x, y, texture);
    const scale = this.lootScaleForTexture(texture);
    sprite.setDepth(29);
    sprite.setScale(scale);
    sprite.setAlpha(0.98);
    const glow = this.createLootDropGlow(texture, x, y + 1);
    const now = performance.now();
    this.lootDrops.push({
      id: this.lootDropSerial++,
      itemDataId: id,
      item: this.store?.getItem?.(id) || null,
      count: Math.max(1, Math.floor(Number(count || 1))),
      resourceKey,
      texture,
      sprite,
      glow,
      sourceUnitDataId: 'visual-polish-fixture',
      spawnedAt: now,
      collectableAt: now + 30000,
      expiresAt: now + RUN_LOOT_TTL_MS * 3,
      collected: false,
    });
  }

  maintainBattleVisualPolishFixture() {
    if (!BATTLE_VISUAL_POLISH_FIXTURE || !this.board || this.mode !== 'expedition') return;
    const player = this.board.playerUnit;
    if (!player?.alive) return;
    const now = performance.now();
    if (this.nextBattleVisualFixtureLayoutAt && now < this.nextBattleVisualFixtureLayoutAt) return;
    this.nextBattleVisualFixtureLayoutAt = now + 280;

    player.x = WORLD.centerX;
    player.y = WORLD.centerY + 76;
    player.targetX = player.x;
    player.targetY = player.y;
    player.state = 'combat';
    player.attack = Math.max(3, Math.round((player.attack || 12) * 0.92));

    const boss = [...this.board.units.values()]
      .find(unit => unit.alive && isBossEnemy(unit));
    if (boss) {
      boss.x = clamp(player.x + 20, 56, WORLD.width - 56);
      boss.y = clamp(player.y - 286, 56, WORLD.height - 56);
      boss.targetX = boss.x;
      boss.targetY = boss.y;
      boss.state = 'combat';
      this.lockFixtureUnitForCapture(boss, { hpMultiplier: 24, target: player, visualScaleMultiplier: 0.54 });
    }

    const edgeSlots = [
      { x: -330, y: -224 },
      { x: 326, y: -214 },
      { x: -378, y: -24 },
      { x: 382, y: -8 },
      { x: -310, y: 158 },
      { x: 318, y: 170 },
      { x: -168, y: 292 },
      { x: 188, y: 286 },
      { x: -418, y: 130 },
      { x: 420, y: 136 },
      { x: -110, y: -304 },
      { x: 134, y: -296 },
      { x: -360, y: 294 },
      { x: 374, y: 298 },
      { x: -18, y: 336 },
      { x: -430, y: -170 },
      { x: 438, y: -164 },
      { x: -252, y: 360 },
      { x: 270, y: 354 },
      { x: 0, y: -334 },
    ];
    const enemies = [...this.board.units.values()]
      .filter(unit => unit.alive && unit.team !== TEAM.PLAYER && !isBossEnemy(unit))
      .sort((a, b) => a.id - b.id);
    enemies.forEach((unit, index) => {
      const slot = edgeSlots[index % edgeSlots.length];
      const orbitX = Math.sin(now / 680 + index * 1.13) * 10;
      const orbitY = Math.cos(now / 720 + index) * 8;
      unit.x = clamp(player.x + slot.x + orbitX, 56, WORLD.width - 56);
      unit.y = clamp(player.y + slot.y + orbitY, 56, WORLD.height - 56);
      unit.targetX = unit.x;
      unit.targetY = unit.y;
      unit.state = 'combat';
      this.lockFixtureUnitForCapture(unit, { hpMultiplier: 10, target: player, visualScaleMultiplier: 0.9 });
    });
    document.documentElement.dataset.survivorBattleVisualFixtureEnemyCount = String(enemies.length + (boss ? 1 : 0));
  }

  finishExpedition(event) {
    this.paused = true;
    this.stopSkillVfxDemo?.();
    this.stopSkillVfxDemo = null;
    this.stopLevelChoiceDemo?.();
    this.stopLevelChoiceDemo = null;
    this.closeLevelChoice({ restorePause: false, clearDataset: true });
    this.clearEncounters();
    this.clearLootDrops();
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
      map: event.map || this.board?.map,
      mapId: event.map?.id || this.activeMapId || this.board?.map?.id || this.sanctuary.currentMapId,
      nextMap: event.nextMap,
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
    this.clearLootDrops();
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

    this.updatePlayerDash(now);
    this.updatePlayerInput(Math.min(simulationDelta, 120));
    this.updatePlayerDash(performance.now());
    this.stepBoardByWallClock(simulationDelta);
    if (!this.levelChoiceOpen) this.updateRunSkillAutos();
    if (!BATTLE_VISUAL_POLISH_FIXTURE) this.updateMapTriggerEncounters(simulationDelta);
    this.updateLootDrops(simulationDelta);
    this.maintainBattleVisualPolishFixture();
    this.syncUnitViews();
    this.syncBattleCamera();
    this.drawExpeditionLight(delta);
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

    if (this.playerDashState) return;

    this.readMovementVector(this.inputVector, { includeTouch: true });
    if (this.inputVector.lengthSq() > 0) this.lastMoveVector.copy(this.inputVector);

    const speed = (245 + this.sanctuary.shrineLevel * 8) * PLAYER_MOVE_SPEED_MULTIPLIER;
    const dt = delta / 1000;
    player.x = clamp(player.x + this.inputVector.x * speed * dt, 42, WORLD.width - 42);
    player.y = clamp(player.y + this.inputVector.y * speed * dt, 42, WORLD.height - 42);
    player.targetX = player.x;
    player.targetY = player.y;
    player.state = 'combat';
  }

  readMovementVector(target, { includeTouch = false } = {}) {
    target.set(0, 0);
    if (this.keys?.left?.isDown || this.keys?.left2?.isDown) target.x -= 1;
    if (this.keys?.right?.isDown || this.keys?.right2?.isDown) target.x += 1;
    if (this.keys?.up?.isDown || this.keys?.up2?.isDown) target.y -= 1;
    if (this.keys?.down?.isDown || this.keys?.down2?.isDown) target.y += 1;
    if (target.lengthSq() > 0) target.normalize();
    if (target.lengthSq() === 0 && includeTouch && this.pointerActive) target.copy(this.touchVector);
    return target;
  }

  resetPlayerDash() {
    const now = performance.now();
    this.playerDashState = null;
    this.playerDashReadyAt = now;
    this.playerDashInvulnerableUntil = 0;
    this.playerDashCount = 0;
    this.playerDashBlockedDamageCount = 0;
    this.lastDashDeniedAt = -Infinity;
    this.lastDashBlockedCueAt = -Infinity;
    this.updatePlayerDashDataset(now);
  }

  requestPlayerDash({ source = 'keyboard' } = {}) {
    const player = this.board?.playerUnit;
    if (!this.ready || this.mode !== 'expedition' || this.paused || this.levelChoiceOpen || this.board?.gameEnded || !player?.alive) {
      return false;
    }

    const now = performance.now();
    this.updatePlayerDash(now);
    if (this.playerDashState) return false;

    const cooldownRemaining = Math.max(0, this.playerDashReadyAt - now);
    if (cooldownRemaining > 0) {
      if (now - this.lastDashDeniedAt > 650) {
        this.lastDashDeniedAt = now;
        this.playSfx('uiError', { volume: 0.32, rate: 1.18 });
      }
      this.updatePlayerDashDataset(now);
      return false;
    }

    const dashVector = new PhaserRef.Math.Vector2();
    this.readMovementVector(dashVector, { includeTouch: true });
    if (dashVector.lengthSq() === 0) dashVector.copy(this.lastMoveVector);
    if (dashVector.lengthSq() === 0) dashVector.set(0, 1);
    dashVector.normalize();
    this.lastMoveVector.copy(dashVector);

    const startX = player.x;
    const startY = player.y;
    const endX = clamp(startX + dashVector.x * PLAYER_DASH_DISTANCE, 42, WORLD.width - 42);
    const endY = clamp(startY + dashVector.y * PLAYER_DASH_DISTANCE, 42, WORLD.height - 42);
    this.playerDashState = {
      source,
      startX,
      startY,
      endX,
      endY,
      vectorX: dashVector.x,
      vectorY: dashVector.y,
      startedAt: now,
      endsAt: now + PLAYER_DASH_DURATION_MS,
    };
    this.playerDashReadyAt = now + PLAYER_DASH_COOLDOWN_MS;
    this.playerDashInvulnerableUntil = now + PLAYER_DASH_INVULNERABLE_MS;
    this.playerDashCount += 1;
    document.documentElement.dataset.survivorDashLastSource = source;
    document.documentElement.dataset.survivorDashLastVector = `${dashVector.x.toFixed(3)},${dashVector.y.toFixed(3)}`;
    this.spawnPlayerDashFx({ startX, startY, endX, endY, vector: dashVector });
    this.playSfx('attack', { volume: 0.38, rate: 1.34, detune: 320 });
    this.cameras.main?.shake?.(70, 0.0026);
    this.updatePlayerDash(now);
    return true;
  }

  updatePlayerDash(now = performance.now()) {
    const state = this.playerDashState;
    const player = this.board?.playerUnit;
    if (!state || !player?.alive) {
      if (state && !player?.alive) this.playerDashState = null;
      this.updatePlayerDashDataset(now);
      return false;
    }

    const rawProgress = clamp((now - state.startedAt) / Math.max(1, PLAYER_DASH_DURATION_MS), 0, 1);
    const easedProgress = 1 - Math.pow(1 - rawProgress, 3);
    player.x = clamp(state.startX + (state.endX - state.startX) * easedProgress, 42, WORLD.width - 42);
    player.y = clamp(state.startY + (state.endY - state.startY) * easedProgress, 42, WORLD.height - 42);
    player.targetX = player.x;
    player.targetY = player.y;
    player.state = 'combat';

    if (rawProgress >= 1) {
      player.x = state.endX;
      player.y = state.endY;
      player.targetX = player.x;
      player.targetY = player.y;
      this.playerDashState = null;
    }
    this.updatePlayerDashDataset(now);
    return true;
  }

  updatePlayerDashDataset(now = performance.now()) {
    const cooldownRemaining = Math.max(0, this.playerDashReadyAt - now);
    const active = Boolean(this.playerDashState);
    const invulnerable = this.isPlayerDashInvulnerable(now);
    const root = document.documentElement;
    root.dataset.survivorDashActive = String(active);
    root.dataset.survivorDashInvulnerable = String(invulnerable);
    root.dataset.survivorDashReady = String(this.mode === 'expedition' && !active && cooldownRemaining <= 0);
    root.dataset.survivorDashCooldownMs = String(Math.ceil(cooldownRemaining));
    root.dataset.survivorDashCooldown = (cooldownRemaining / 1000).toFixed(2);
    root.dataset.survivorDashCooldownProgress = clamp(1 - cooldownRemaining / PLAYER_DASH_COOLDOWN_MS, 0, 1).toFixed(3);
    root.dataset.survivorDashCount = String(this.playerDashCount || 0);
    root.dataset.survivorDashBlockedDamageCount = String(this.playerDashBlockedDamageCount || 0);
  }

  isPlayerDashInvulnerable(now = performance.now()) {
    return this.mode === 'expedition' && (Boolean(this.playerDashState) || now < this.playerDashInvulnerableUntil);
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

  spawnUnitLootDrops({ unit, drops = [] } = {}) {
    if (!unit || this.mode !== 'expedition') return;
    const safeDrops = (drops || [])
      .map(drop => ({
        ...drop,
        itemDataId: Number(drop.itemDataId),
        count: Math.max(0, Math.floor(Number(drop.count || 0))),
      }))
      .filter(drop => drop.itemDataId && drop.count > 0);
    if (!safeDrops.length) return;

    const now = performance.now();
    const spreadStep = (Math.PI * 2) / Math.max(3, safeDrops.length);
    safeDrops.forEach((drop, index) => {
      const resourceKey = homeRewardKeyForItemId(drop.itemDataId);
      const texture = this.lootTextureForDrop(drop, resourceKey);
      const sprite = this.add.sprite(unit.x, unit.y - 4, texture);
      const angle = spreadStep * index - Math.PI / 2 + PhaserRef.Math.FloatBetween(-0.28, 0.28);
      const distance = PhaserRef.Math.Between(16, RUN_LOOT_SCATTER_RADIUS);
      const targetX = clamp(unit.x + Math.cos(angle) * distance, 24, WORLD.width - 24);
      const targetY = clamp(unit.y + Math.sin(angle) * distance, 24, WORLD.height - 24);
      const scale = this.lootScaleForTexture(texture);
      sprite.setDepth(29);
      sprite.setScale(scale);
      sprite.setAlpha(0.98);
      const glow = this.createLootDropGlow(texture, unit.x, unit.y - 2);

      const loot = {
        id: this.lootDropSerial++,
        itemDataId: drop.itemDataId,
        item: drop.item || this.store?.getItem?.(drop.itemDataId) || null,
        count: drop.count,
        resourceKey,
        texture,
        sprite,
        glow,
        sourceUnitDataId: unit.dataId,
        spawnedAt: now,
        collectableAt: now + 140,
        expiresAt: now + RUN_LOOT_TTL_MS,
        collected: false,
      };
      this.lootDrops.push(loot);

      this.tweens.add({
        targets: [sprite, glow].filter(Boolean),
        x: targetX,
        y: targetY,
        duration: 210,
        ease: 'Back.easeOut',
      });
    });
    this.syncLootDropDataset();
  }

  updateLootDrops(deltaMs) {
    const player = this.board?.playerUnit;
    if (!player?.alive || !this.lootDrops.length) {
      this.syncLootDropDataset();
      return;
    }

    const now = performance.now();
    const magnetActive = now < this.magnetUntil;
    for (const loot of [...this.lootDrops]) {
      const sprite = loot.sprite;
      if (!sprite?.active || now > loot.expiresAt) {
        this.removeLootDrop(loot, { fade: true });
        continue;
      }
      this.updateLootDropGlow(loot, now);

      let dx = player.x - sprite.x;
      let dy = player.y - sprite.y;
      let dist = Math.hypot(dx, dy);
      if (magnetActive && loot.resourceKey === 'exp' && now >= loot.collectableAt) {
        this.collectLootDrop(loot, player);
        continue;
      }

      if (now >= loot.collectableAt && dist <= RUN_LOOT_PICKUP_RADIUS) {
        this.collectLootDrop(loot, player);
      }
    }
    this.syncLootDropDataset();
  }

  collectLootDrop(loot, player) {
    if (!loot || loot.collected) return;
    loot.collected = true;
    const granted = this.board?.addItem?.(loot.itemDataId, loot.count, `pickup:${loot.sourceUnitDataId}`) || 0;
    const sprite = loot.sprite;

    if (granted > 0) {
      const ledgerKey = Object.prototype.hasOwnProperty.call(this.runLedger, loot.resourceKey)
        ? loot.resourceKey
        : '';
      if (ledgerKey) {
        this.runLedger[ledgerKey] = (this.runLedger[ledgerKey] || 0) + granted;
        this.pulseLedgerGain(ledgerKey, granted);
      }
      this.runDrops += 1;
      const label = loot.item?.name || rewardDisplayName(loot.resourceKey || `item_${loot.itemDataId}`, this, this.sanctuary);
      this.floatText(sprite?.x || player.x, (sprite?.y || player.y) - 24, `${label} +${formatNumber(granted)}`, '#fff1c8');
      this.playSfx(loot.resourceKey === 'gold' ? 'coin' : 'reward', {
        volume: loot.resourceKey === 'gold' ? 0.68 : 0.42,
      });
    }

    this.removeLootDrop(loot, { animateTo: player });
  }

  removeLootDrop(loot, { fade = false, animateTo = null } = {}) {
    const index = this.lootDrops.indexOf(loot);
    if (index >= 0) this.lootDrops.splice(index, 1);
    const sprite = loot?.sprite;
    const glow = loot?.glow;
    if (loot) loot.sprite = null;
    if (loot) loot.glow = null;
    if (!sprite?.active && !glow?.active) {
      this.syncLootDropDataset();
      return;
    }

    if (animateTo) {
      this.tweens.add({
        targets: [sprite, glow].filter(Boolean),
        x: animateTo.x,
        y: animateTo.y - 30,
        alpha: 0,
        scaleX: 0.45,
        scaleY: 0.45,
        duration: 150,
        ease: 'Quad.easeIn',
        onComplete: () => {
          sprite?.destroy();
          glow?.destroy();
        },
      });
    } else if (fade) {
      this.tweens.add({
        targets: [sprite, glow].filter(Boolean),
        alpha: 0,
        y: (sprite?.y || glow?.y || 0) - 16,
        duration: 220,
        ease: 'Quad.easeOut',
        onComplete: () => {
          sprite?.destroy();
          glow?.destroy();
        },
      });
    } else {
      sprite?.destroy();
      glow?.destroy();
    }
    this.syncLootDropDataset();
  }

  clearLootDrops() {
    for (const loot of this.lootDrops.splice(0)) {
      loot.sprite?.destroy?.();
      loot.glow?.destroy?.();
      loot.sprite = null;
      loot.glow = null;
    }
    this.syncLootDropDataset();
  }

  syncLootDropDataset() {
    document.documentElement.dataset.survivorLootDropActiveCount = String(this.lootDrops?.length || 0);
    document.documentElement.dataset.survivorLootPickupRadius = String(RUN_LOOT_PICKUP_RADIUS);
    document.documentElement.dataset.survivorPickupGlowCount = String((this.lootDrops || []).filter(loot => loot.glow?.active).length);
  }

  createLootDropGlow(texture, x, y) {
    const glow = this.add.graphics();
    glow.setDepth(28);
    glow.setPosition(x, y + 2);
    this.redrawLootDropGlow(glow, texture, 0);
    return glow;
  }

  updateLootDropGlow(loot, now = performance.now()) {
    const glow = loot?.glow;
    const sprite = loot?.sprite;
    if (!glow?.active || !sprite?.active) return;
    const phase = (Math.sin(now / 260 + (loot.id || 0) * 0.77) + 1) / 2;
    glow.setPosition(sprite.x, sprite.y + 2);
    glow.setAlpha(0.74 + phase * 0.18);
    this.redrawLootDropGlow(glow, loot.texture, phase);
  }

  redrawLootDropGlow(glow, texture, phase = 0) {
    if (!glow) return;
    const spec = PICKUP_GLOW_SPEC[texture] || PICKUP_GLOW_SPEC.default;
    const radius = spec.radius + phase * 4;
    glow.clear();
    glow.fillStyle(0x09120e, 0.22);
    glow.fillEllipse(0, 12, radius * 1.6, radius * 0.56);
    glow.fillStyle(spec.color, 0.12 + phase * 0.04);
    glow.fillCircle(0, 0, radius * 1.08);
    glow.lineStyle(3, spec.color, 0.34 + phase * 0.2);
    glow.strokeCircle(0, 0, radius);
    glow.lineStyle(1.5, spec.accent, 0.26 + phase * 0.18);
    glow.strokeCircle(0, 0, radius * 0.58);
  }

  lootTextureForDrop(drop, resourceKey = homeRewardKeyForItemId(drop?.itemDataId)) {
    if (resourceKey === 'gold') return 'coinDrop';
    if (resourceKey === 'exp') return this.textures.exists('soulShard') ? 'soulShard' : 'soulFlame';
    if (resourceKey === 'wood') return 'woodCrate';
    if (resourceKey === 'stone') return 'stoneDrop';
    if (resourceKey === 'souls' || resourceKey === 'soulflame') return 'soulFlame';
    return this.textures.exists('soulShard') ? 'soulShard' : 'coinDrop';
  }

  lootScaleForTexture(texture) {
    const scaleByTexture = {
      coinDrop: 0.33,
      soulFlame: 0.29,
      soulShard: 0.41,
      woodCrate: 0.32,
      stoneDrop: 0.31,
    };
    return scaleByTexture[texture] || 0.33;
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
    const radius = 420;
    let hits = 0;
    enemies.forEach(enemy => {
      if (!enemy?.alive || isBossEnemy(enemy)) return;
      enemy.takeDamage(Math.max(1, Math.ceil(enemy.hp || enemy.maxHp || 1)), player, null);
      hits += 1;
    });
    this.explosionFx(encounter.x, encounter.y, radius);
    this.playSfx('attack', { volume: 1, rate: 0.78, detune: -180 });
    this.floatText(encounter.x, encounter.y - 78, `폭발 ${hits}`, '#ffc64a');
    document.documentElement.dataset.survivorEncounterBombHits = String(hits);
  }

  triggerMagnetEncounter(encounter) {
    this.magnetUntil = performance.now() + 5200;
    const collected = this.collectAllExperienceLootDrops();
    this.magnetFx(encounter.x, encounter.y);
    this.playSfx('reward', { volume: 0.68, rate: 1.08 });
    this.floatText(encounter.x, encounter.y - 72, collected > 0 ? `경험치 회수 ${formatNumber(collected)}` : '경험치 자석', '#9ffcff');
    document.documentElement.dataset.survivorEncounterMagnetExp = String(collected);
  }

  collectAllExperienceLootDrops() {
    const player = this.board?.playerUnit;
    if (!player?.alive || !this.lootDrops?.length) return 0;
    let collected = 0;
    for (const loot of [...this.lootDrops]) {
      if (loot.resourceKey !== 'exp' || loot.collected) continue;
      collected += Math.max(0, Number(loot.count || 0));
      this.collectLootDrop(loot, player);
    }
    return collected;
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
      const hitOffsetX = view.hitOffsetX || 0;
      const hitOffsetY = view.hitOffsetY || 0;
      const hitScale = view.hitScale || 0;
      view.baseScale = scaleForUnit(unit);
      view.sprite.setPosition(unit.x + hitOffsetX, unit.y + hitOffsetY);
      view.sprite.setVisible(unit.alive);
      view.sprite.setFlipX(shouldMirrorDirection(unit, direction, view.family));
      view.sprite.setDepth(unit.team === TEAM.PLAYER ? 44 : 20 + unit.y / 100);
      view.sprite.setAlpha(unit.team === TEAM.PLAYER && this.isPlayerDashInvulnerable()
        ? 0.7 + Math.sin(this.time.now / 32) * 0.18
        : 1);
      view.sprite.setScale(view.baseScale * (1 + hitScale) * (walkAnimation ? 1 : 1 + Math.sin(this.time.now / 220 + unit.id) * 0.025));
      view.hitOffsetX = Math.abs(hitOffsetX) < 0.4 ? 0 : hitOffsetX * 0.58;
      view.hitOffsetY = Math.abs(hitOffsetY) < 0.4 ? 0 : hitOffsetY * 0.58;
      view.hitScale = hitScale < 0.01 ? 0 : hitScale * 0.48;
      view.direction = direction;
      view.lastX = unit.x;
      view.lastY = unit.y;
      drawUnitHp(view.hp, unit);
    }
    this.drawEnemyThreatCues();

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
    this.combatCueLayer?.clear();
  }

  resetCombatReadabilityCounters() {
    this.combatCueCount = 0;
    this.skillIntentCueCount = 0;
    this.enemyHitCueCount = 0;
    this.playerThreatCueCount = 0;
    this.enemyThreatCueCount = 0;
    this.lastThreatCueDatasetAt = 0;
    this.lastPlayerThreatCueAt = -Infinity;
    this.lastRunImpactCueWindowAt = 0;
    this.runImpactCueWindowCount = 0;
    const root = document.documentElement;
    root.dataset.survivorCombatCueCount = '0';
    root.dataset.survivorCombatCueLast = '';
    root.dataset.survivorSkillIntentCueCount = '0';
    root.dataset.survivorSkillIntentCueLast = '';
    root.dataset.survivorEnemyHitCueCount = '0';
    root.dataset.survivorEnemyHitCueLast = '';
    root.dataset.survivorPlayerThreatCueCount = '0';
    root.dataset.survivorEnemyThreatCueCount = '0';
  }

  markCombatCue(kind, detail = '') {
    const root = document.documentElement;
    this.combatCueCount += 1;
    root.dataset.survivorCombatCueCount = String(this.combatCueCount);
    root.dataset.survivorCombatCueLast = detail ? `${kind}:${detail}` : kind;
    if (kind === 'skillIntent') {
      this.skillIntentCueCount += 1;
      root.dataset.survivorSkillIntentCueCount = String(this.skillIntentCueCount);
      root.dataset.survivorSkillIntentCueLast = String(detail || '');
    } else if (kind === 'enemyHit') {
      this.enemyHitCueCount += 1;
      root.dataset.survivorEnemyHitCueCount = String(this.enemyHitCueCount);
      root.dataset.survivorEnemyHitCueLast = String(detail || '');
    } else if (kind === 'playerThreat') {
      this.playerThreatCueCount += 1;
      root.dataset.survivorPlayerThreatCueCount = String(this.playerThreatCueCount);
    } else if (kind === 'enemyThreat') {
      this.enemyThreatCueCount += 1;
      root.dataset.survivorEnemyThreatCueCount = String(this.enemyThreatCueCount);
    }
  }

  drawEnemyThreatCues() {
    const layer = this.combatCueLayer;
    if (!layer || !this.board || this.mode !== 'expedition') return;
    layer.clear();
    const player = this.board.playerUnit;
    if (!player?.alive) return;

    const bossTelegraphs = [...this.board.units.values()]
      .filter(unit => unit.alive && unit.team !== TEAM.PLAYER && (unit.type === 'Boss' || unit.type === 'Elite' || unit.type === 'MidBoss'));
    bossTelegraphs.forEach(unit => this.drawBossTelegraph(layer, unit));
    document.documentElement.dataset.survivorBossTelegraphCount = String(bossTelegraphs.length);

    const threats = [...this.board.units.values()]
      .filter(unit => unit.alive && unit.team !== TEAM.PLAYER)
      .map(unit => ({ unit, distance: Math.hypot(player.x - unit.x, player.y - unit.y) }))
      .filter(entry => entry.distance < 340)
      .sort((a, b) => a.distance - b.distance)
      .slice(0, 6);

    for (const { unit, distance } of threats) {
      const radius = unitCueRadiusPx(unit, unit.type === 'Boss' ? 44 : 24);
      const dx = player.x - unit.x;
      const dy = player.y - unit.y;
      const length = Math.max(1, Math.hypot(dx, dy));
      const nx = dx / length;
      const ny = dy / length;
      const urgency = clamp(1 - distance / 340, 0.16, 0.78);
      const startX = unit.x + nx * Math.max(16, radius * 0.72);
      const startY = unit.y + ny * Math.max(12, radius * 0.54);
      const endX = unit.x + nx * Math.max(36, radius * 1.45);
      const endY = unit.y + ny * Math.max(24, radius * 1.02);
      const headX = endX - nx * 9;
      const headY = endY - ny * 9;
      const sideX = -ny * 7;
      const sideY = nx * 7;

      layer.lineStyle(unit.type === 'Boss' ? 4 : 3, COLORS.red, 0.08 + urgency * 0.22);
      layer.lineBetween(startX, startY, endX, endY);
      layer.lineBetween(endX, endY, headX + sideX, headY + sideY);
      layer.lineBetween(endX, endY, headX - sideX, headY - sideY);
      layer.lineStyle(2, COLORS.yellow, 0.08 + urgency * 0.12);
      layer.strokeCircle(unit.x, unit.y - 8, radius);
    }

    const now = this.time?.now || 0;
    if (threats.length && now - this.lastThreatCueDatasetAt > 480) {
      this.lastThreatCueDatasetAt = now;
      this.markCombatCue('enemyThreat', threats[0].unit.dataId);
    }
    this.drawPlayerLowHealthCue(layer, player);
  }

  drawBossTelegraph(layer, unit) {
    const isBoss = unit.type === 'Boss';
    const now = this.time?.now || performance.now();
    const pulse = (Math.sin(now / (isBoss ? 310 : 260) + unit.id) + 1) / 2;
    const radius = isBoss
      ? clamp(unitCueRadiusPx(unit, 58) * 2.05 + pulse * 10, 96, 144)
      : clamp(unitCueRadiusPx(unit, 36) * 1.9 + pulse * 7, 58, 92);
    const x = unit.x;
    const y = unit.y + (isBoss ? 4 : 0);
    const color = isBoss ? COLORS.red : COLORS.yellow;
    const accent = isBoss ? COLORS.yellow : COLORS.red;
    layer.fillStyle(color, isBoss ? 0.08 : 0.055);
    layer.fillCircle(x, y, radius);
    layer.lineStyle(isBoss ? 5 : 3, color, 0.26 + pulse * 0.18);
    layer.strokeCircle(x, y, radius);
    layer.lineStyle(2, accent, 0.16 + pulse * 0.14);
    layer.strokeCircle(x, y, radius * 0.72);

    const tickCount = isBoss ? 10 : 6;
    const rotation = now / (isBoss ? 620 : 520);
    for (let index = 0; index < tickCount; index += 1) {
      const angle = rotation + index * Math.PI * 2 / tickCount;
      const inner = radius + 4;
      const outer = radius + (isBoss ? 20 : 14);
      layer.lineStyle(isBoss ? 3 : 2, accent, 0.2 + pulse * 0.18);
      layer.lineBetween(
        x + Math.cos(angle) * inner,
        y + Math.sin(angle) * inner,
        x + Math.cos(angle) * outer,
        y + Math.sin(angle) * outer,
      );
    }

    if (isBoss) {
      layer.lineStyle(3, COLORS.red, 0.18 + pulse * 0.12);
      layer.lineBetween(x, y - radius - 12, x, y - radius - 54);
      layer.lineStyle(2, COLORS.cream, 0.12 + pulse * 0.08);
      layer.lineBetween(x - 16, y - radius - 38, x + 16, y - radius - 38);
    }
  }

  drawPlayerLowHealthCue(layer, player) {
    if (!layer || !player?.alive || playerHealthRatio(player) >= PLAYER_LOW_HEALTH_THRESHOLD) return;

    const now = this.time?.now || performance.now();
    const urgency = clamp((PLAYER_LOW_HEALTH_THRESHOLD - playerHealthRatio(player)) / PLAYER_LOW_HEALTH_THRESHOLD, 0, 1);
    const pulse = (Math.sin(now / 112) + 1) / 2;
    const radius = unitCueRadiusPx(player, 34) + 13 + pulse * 10;
    const x = player.x;
    const y = player.y - 3;
    const alpha = 0.28 + urgency * 0.28 + pulse * 0.1;

    layer.lineStyle(3 + urgency * 2, COLORS.red, alpha);
    layer.strokeCircle(x, y, radius);
    layer.lineStyle(2, COLORS.cream, 0.12 + pulse * 0.12);
    layer.strokeCircle(x, y, radius + 9);

    const tick = now / 260;
    for (let index = 0; index < 4; index += 1) {
      const angle = tick + index * Math.PI * 0.5;
      const markRadius = radius + 16;
      const markX = x + Math.cos(angle) * markRadius;
      const markY = y + Math.sin(angle) * markRadius;
      const tangentX = -Math.sin(angle) * 8;
      const tangentY = Math.cos(angle) * 8;
      layer.lineStyle(2, COLORS.red, 0.34 + urgency * 0.24);
      layer.lineBetween(markX - tangentX, markY - tangentY, markX + tangentX, markY + tangentY);
    }
  }

  spawnPlayerDashFx({ startX, startY, endX, endY, vector }) {
    const angle = Math.atan2(vector.y, vector.x);
    const distance = Math.max(1, Math.hypot(endX - startX, endY - startY));
    const midX = (startX + endX) / 2;
    const midY = (startY + endY) / 2;

    if (this.textures.exists(SKILL_VFX_ATOMS.galeTrail)) {
      const trail = this.add.sprite(midX, midY, SKILL_VFX_ATOMS.galeTrail);
      trail.setDepth(62);
      trail.setAlpha(0.82);
      trail.setRotation(angle);
      trail.setScale(clamp(distance / 210, 0.78, 1.55), 0.42);
      this.tweens.add({
        targets: trail,
        alpha: 0,
        scaleX: trail.scaleX * 1.18,
        scaleY: trail.scaleY * 0.72,
        duration: 260,
        ease: 'Quad.easeOut',
        onComplete: () => trail.destroy(),
      });
    } else {
      const trail = this.add.graphics();
      trail.setDepth(62);
      trail.lineStyle(12, COLORS.cyan, 0.34);
      trail.lineBetween(startX, startY - 12, endX, endY - 12);
      trail.lineStyle(5, COLORS.cream, 0.42);
      trail.lineBetween(startX - vector.x * 18, startY - 26, endX, endY - 26);
      this.tweens.add({
        targets: trail,
        alpha: 0,
        duration: 230,
        ease: 'Quad.easeOut',
        onComplete: () => trail.destroy(),
      });
    }

    const player = this.board?.playerUnit;
    const view = player ? this.unitViews.get(player.id) : null;
    if (view?.sprite) {
      for (let index = 0; index < 3; index += 1) {
        const t = index / 3;
        const ghost = this.add.sprite(
          startX + (endX - startX) * t,
          startY + (endY - startY) * t,
          view.sprite.texture.key,
          view.sprite.frame.name
        );
        ghost.setDepth(43 - index);
        ghost.setScale(view.sprite.scaleX, view.sprite.scaleY);
        ghost.setFlipX(view.sprite.flipX);
        ghost.setAlpha(0.28 - index * 0.055);
        ghost.setTint(COLORS.cyan);
        this.tweens.add({
          targets: ghost,
          alpha: 0,
          x: ghost.x - vector.x * 26,
          y: ghost.y - vector.y * 18,
          duration: 210 + index * 36,
          ease: 'Quad.easeOut',
          onComplete: () => ghost.destroy(),
        });
      }
    }

    const burst = this.add.graphics();
    burst.setDepth(63);
    burst.lineStyle(4, COLORS.cyan, 0.66);
    burst.strokeCircle(endX, endY - 14, 36);
    burst.lineStyle(2, COLORS.cream, 0.38);
    burst.strokeCircle(endX, endY - 14, 54);
    this.tweens.add({
      targets: burst,
      alpha: 0,
      scaleX: 1.38,
      scaleY: 1.38,
      duration: 240,
      ease: 'Quad.easeOut',
      onComplete: () => burst.destroy(),
    });
  }

  spawnDashGuardFx(player) {
    if (!player?.alive) return;
    const now = this.time?.now || performance.now();
    if (now - this.lastDashBlockedCueAt < 120) return;
    this.lastDashBlockedCueAt = now;
    const guard = this.add.graphics();
    guard.setDepth(69);
    guard.fillStyle(COLORS.cyan, 0.1);
    guard.fillCircle(player.x, player.y - 10, 48);
    guard.lineStyle(4, COLORS.cyan, 0.72);
    guard.strokeCircle(player.x, player.y - 10, 44);
    guard.lineStyle(2, COLORS.cream, 0.36);
    guard.strokeCircle(player.x, player.y - 10, 62);
    this.tweens.add({
      targets: guard,
      alpha: 0,
      scaleX: 1.24,
      scaleY: 1.24,
      duration: 180,
      ease: 'Quad.easeOut',
      onComplete: () => guard.destroy(),
    });
  }

  drawSkillIntentCue(skill) {
    if (!skill?.owner || skill.owner.team !== TEAM.PLAYER || !skill.targets?.length) return;
    const liveTargets = skill.targets.filter(target => target?.alive);
    if (!liveTargets.length) return;
    const profile = getSkillVfxProfile(skill.dataId) || {};
    const maxTargets = Math.max(1, Math.min(3, profile.visualMaxTargets || profile.maxTargets || 3));
    const targets = liveTargets.slice(0, maxTargets);
    const color = profile.accent || profile.color || COLORS.gold;
    const cue = this.add.graphics();
    cue.setDepth(58);
    const originX = skill.owner.x;
    const originY = skill.owner.y - 28;

    targets.forEach((target, index) => {
      const targetX = target.x;
      const targetY = target.y - 22;
      const targetRadius = unitCueRadiusPx(target, target.type === 'Boss' ? 36 : 20);
      const crossRadius = Math.max(14, targetRadius * 0.9);
      const alpha = Math.max(0.22, 0.48 - index * 0.08);
      cue.lineStyle(3, color, alpha);
      cue.lineBetween(originX, originY, targetX, targetY);
      cue.lineStyle(2, COLORS.cream, 0.22);
      cue.strokeCircle(targetX, targetY, targetRadius);
      cue.lineStyle(2, color, 0.42);
      cue.lineBetween(targetX - crossRadius, targetY, targetX + crossRadius, targetY);
      cue.lineBetween(targetX, targetY - crossRadius, targetX, targetY + crossRadius);
    });

    this.markCombatCue('skillIntent', skill.dataId);
      this.tweens.add({
        targets: cue,
        alpha: 0,
      duration: 260,
      ease: 'Quad.easeOut',
      onComplete: () => cue.destroy(),
    });
  }

  applyHitReaction(unit, source, skill) {
    const view = this.unitViews.get(unit.id) || this.ensureUnitView(unit);
    if (isNormalEnemyContactHit(unit, source, skill)) return;

    const origin = source || skill?.owner || null;
    let dx = origin ? unit.x - origin.x : 1;
    let dy = origin ? unit.y - origin.y : -0.25;
    let length = Math.hypot(dx, dy);
    if (length < 1) {
      dx = unit.team === TEAM.PLAYER ? -1 : 1;
      dy = -0.25;
      length = Math.hypot(dx, dy);
    }
    const force = unit.team === TEAM.PLAYER ? 30 : unit.type === 'Boss' ? 20 : 17;
    view.hitOffsetX = clamp((view.hitOffsetX || 0) + (dx / length) * force, -32, 32);
    view.hitOffsetY = clamp((view.hitOffsetY || 0) + (dy / length) * force * 0.72, -24, 24);
    view.hitScale = Math.max(view.hitScale || 0, unit.team === TEAM.PLAYER ? 0.11 : 0.08);
  }

  spawnDamageInteractionCue({ unit, source, skill }) {
    if (!unit) return;
    const profile = getSkillVfxProfile(skill?.dataId) || {};
    const isPlayerHit = unit.team === TEAM.PLAYER;
    const isNormalContactHit = isNormalEnemyContactHit(unit, source, skill);
    const isRunSkillHit = !isPlayerHit && skill?.owner?.team === TEAM.PLAYER && this.runSkillLevels?.has(Number(skill.dataId));
    const color = isPlayerHit ? COLORS.red : (profile.hitPulse || profile.accent || COLORS.cream);

    if (isPlayerHit) {
      const now = this.time?.now || 0;
      if (now - this.lastPlayerThreatCueAt < 260) return;
      this.lastPlayerThreatCueAt = now;
      if (isNormalContactHit) {
        this.spawnPlayerContactFx(unit, source);
        this.markCombatCue('playerThreat', source?.dataId || '');
        return;
      }
      const marker = this.add.graphics();
      marker.setDepth(68);
      marker.fillStyle(COLORS.red, 0.1);
      marker.fillCircle(unit.x, unit.y - 12, 70);
      marker.lineStyle(7, COLORS.red, 0.82);
      marker.strokeCircle(unit.x, unit.y - 12, unitCueRadiusPx(unit, 42) * 1.35);
      marker.lineStyle(4, COLORS.yellow, 0.46);
      marker.lineBetween(unit.x - 28, unit.y - 54, unit.x + 12, unit.y - 14);
      marker.lineBetween(unit.x + 28, unit.y - 46, unit.x - 12, unit.y - 8);
      if (source) {
        marker.lineStyle(4, COLORS.red, 0.62);
        marker.lineBetween(source.x, source.y - 12, unit.x, unit.y - 18);
      }
      this.cameras.main?.shake?.(80, 0.003);
      this.markCombatCue('playerThreat', source?.dataId || '');
      this.tweens.add({
        targets: marker,
        alpha: 0,
        scaleX: 1.35,
        scaleY: 1.35,
        duration: 380,
        ease: 'Quad.easeOut',
        onComplete: () => marker.destroy(),
      });
      return;
    }

    const shouldShowEnemyCue = isRunSkillHit
      ? this.shouldShowRunImpactCue()
      : Math.random() < 0.22;
    if (!shouldShowEnemyCue) return;

    if (this.textures.exists(SKILL_VFX_ATOMS.impactFlash)) {
      const flash = this.add.sprite(unit.x, unit.y - 22, SKILL_VFX_ATOMS.impactFlash);
      flash.setDepth(64);
      flash.setScale(clamp(unitCueRadiusPx(unit, unit.type === 'Boss' ? 36 : 23) / 88, 0.2, 0.34));
      flash.setAlpha(0.98);
      flash.setRotation(PhaserRef.Math.FloatBetween(-0.25, 0.25));
      this.tweens.add({
        targets: flash,
        alpha: 0,
        scaleX: flash.scaleX * 1.55,
        scaleY: flash.scaleY * 1.55,
        duration: 280,
        ease: 'Quad.easeOut',
        onComplete: () => flash.destroy(),
      });
    }
    const marker = this.add.graphics();
    marker.setDepth(65);
    marker.lineStyle(4, color, 0.86);
    marker.strokeCircle(unit.x, unit.y - 22, unitCueRadiusPx(unit, unit.type === 'Boss' ? 36 : 23));
    marker.lineStyle(4, COLORS.cream, 0.72);
    marker.lineBetween(unit.x - 24, unit.y - 22, unit.x + 24, unit.y - 22);
    marker.lineBetween(unit.x, unit.y - 46, unit.x, unit.y + 2);
    marker.lineStyle(3, COLORS.yellow, 0.5);
    marker.lineBetween(unit.x - 20, unit.y - 40, unit.x + 18, unit.y - 4);
    this.tweens.add({
      targets: marker,
      alpha: 0,
      scaleX: 1.55,
      scaleY: 1.55,
      duration: 330,
      ease: 'Quad.easeOut',
      onComplete: () => marker.destroy(),
    });

    if (isRunSkillHit) this.markCombatCue('enemyHit', skill.dataId);
  }

  spawnPlayerContactFx(unit, source) {
    const originX = source?.x ?? unit.x;
    const originY = source?.y ?? unit.y;
    const angle = PhaserRef.Math.Angle.Between(originX, originY, unit.x, unit.y);
    const x = unit.x - Math.cos(angle) * 16;
    const y = unit.y - 24 - Math.sin(angle) * 10;

    if (this.textures.exists(SKILL_VFX_ATOMS.impactFlash)) {
      const flash = this.add.sprite(x, y, SKILL_VFX_ATOMS.impactFlash);
      flash.setDepth(68);
      flash.setScale(0.18);
      flash.setAlpha(0.72);
      flash.setRotation(PhaserRef.Math.FloatBetween(-0.2, 0.2));
      this.tweens.add({
        targets: flash,
        alpha: 0,
        scaleX: 0.28,
        scaleY: 0.28,
        duration: 190,
        ease: 'Quad.easeOut',
        onComplete: () => flash.destroy(),
      });
    }

    const marker = this.add.graphics();
    marker.setDepth(67);
    marker.lineStyle(3, COLORS.red, 0.62);
    marker.strokeCircle(x, y, 24);
    marker.lineStyle(2, COLORS.cream, 0.44);
    marker.lineBetween(x - 15, y, x + 15, y);
    this.tweens.add({
      targets: marker,
      alpha: 0,
      scaleX: 1.26,
      scaleY: 1.26,
      duration: 210,
      ease: 'Quad.easeOut',
      onComplete: () => marker.destroy(),
    });
  }

  shouldShowRunImpactCue() {
    const now = this.time?.now || 0;
    if (now - this.lastRunImpactCueWindowAt > 90) {
      this.lastRunImpactCueWindowAt = now;
      this.runImpactCueWindowCount = 0;
    }
    if (this.runImpactCueWindowCount >= 3) return false;
    this.runImpactCueWindowCount += 1;
    return true;
  }

  onUnitDamaged({ unit, source, damage, skill }) {
    const isPlayerUnit = unit && (unit === this.board?.playerUnit || unit.team === TEAM.PLAYER || unit.type === 'Player');
    if (isPlayerUnit && this.isPlayerDashInvulnerable()) {
      const restored = Math.min(Number(unit.maxHp || unit.hp || 1), Number(unit.hp || 0) + Number(damage || 0));
      unit.hp = Math.max(1, restored);
      this.playerDashBlockedDamageCount += 1;
      document.documentElement.dataset.survivorDashBlockedDamageCount = String(this.playerDashBlockedDamageCount);
      this.spawnDashGuardFx(unit);
      this.markCombatCue('playerThreat', 'dash-invulnerable');
      return;
    }

    const view = this.ensureUnitView(unit);
    const isRunSkillHit = skill?.dataId && skill.owner?.team === TEAM.PLAYER && this.runSkillLevels?.has(Number(skill.dataId));
    let runSkillDamageCount = Number(document.documentElement.dataset.survivorRunSkillDamageCount || 0);
    view.sprite.setTint(unit.team === TEAM.PLAYER ? COLORS.red : COLORS.cream);
    this.time.delayedCall(70, () => view.sprite.clearTint());
    this.applyHitReaction(unit, source, skill);
    this.spawnDamageInteractionCue({ unit, source, skill });
    if (damage > 0) {
      this.playSfx('hit', {
        volume: unit.team === TEAM.PLAYER ? 0.64 : 0.88,
        rate: unit.team === TEAM.PLAYER ? 0.88 : 1,
        detune: unit.team === TEAM.PLAYER ? -120 : 0,
      });
    }
    if (isRunSkillHit) {
      const count = Number(document.documentElement.dataset.survivorRunSkillDamageCount || 0) + 1;
      const total = Number(document.documentElement.dataset.survivorRunSkillDamageTotal || 0) + Number(damage || 0);
      runSkillDamageCount = count;
      document.documentElement.dataset.survivorRunSkillDamageCount = String(count);
      document.documentElement.dataset.survivorRunSkillDamageTotal = String(total);
      document.documentElement.dataset.survivorRunSkillLastDamage = `${skill.dataId}:${Math.round(Number(damage || 0))}`;
    }
    const showRunSkillDamage = isRunSkillHit && (unit.type === 'Boss' || runSkillDamageCount % 4 === 1);
    if (unit.team === TEAM.PLAYER || showRunSkillDamage || Math.random() < 0.14) {
      const damageText = unit.team === TEAM.PLAYER ? `-${formatNumber(damage)}` : formatNumber(damage);
      this.floatText(unit.x, unit.y - 32, damageText, unit.team === TEAM.PLAYER ? '#ff3f32' : '#fff7dd');
    }
  }

  onUnitDied({ unit }) {
    const view = this.unitViews.get(unit.id);
    if (!view) return;
    if (unit.team !== TEAM.PLAYER) {
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
    this.drawSkillIntentCue(skill);
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
    marker.strokeCircle(target.x, target.y, unitCueRadiusPx(target, 36) * 1.3);
    this.tweens.add({
      targets: marker,
      alpha: 0,
      scaleX: 1.45,
      scaleY: 1.45,
      duration: 220,
      onComplete: () => marker.destroy(),
    });
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

  playHomeResourceFly(fx) {
    return playHomeResourceFlyAnimation(fx, this);
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
    const pulseUnit = (Math.sin(this.time.now / 260) + 1) / 2;
    const pulse = 1 + (pulseUnit - 0.5) * 0.07;
    const shrine = BUILDING_BY_KEY.get('lantern_shrine');
    const shrineEffect = getLevelData(shrine, getBuildingLevel(this.sanctuary, shrine))?.effect || {};
    const radius = (140 + (shrineEffect.light_radius || 38) * 1.2) * pulse;
    this.lightLayer.fillStyle(0xffdf70, 0.11);
    this.lightLayer.fillCircle(player.x, player.y, radius * 1.15);
    this.lightLayer.fillStyle(0xfff1c8, 0.07 + pulseUnit * 0.025);
    this.lightLayer.fillCircle(player.x, player.y, radius * 0.62);
    this.lightLayer.lineStyle(5, 0xffdf70, 0.3 + pulseUnit * 0.08);
    this.lightLayer.strokeCircle(player.x, player.y, radius * 0.74);
    this.lightLayer.lineStyle(2, 0xfff1c8, 0.18 + pulseUnit * 0.08);
    this.lightLayer.strokeCircle(player.x, player.y, radius * 0.42);

    const tickRadius = radius * 0.86;
    const rotation = this.time.now / 720;
    for (let index = 0; index < 8; index += 1) {
      const angle = rotation + index * Math.PI * 0.25;
      const markLength = 13 + (index % 2) * 8;
      this.lightLayer.lineStyle(2, index % 2 ? COLORS.cream : COLORS.gold, 0.14 + pulseUnit * 0.08);
      this.lightLayer.lineBetween(
        player.x + Math.cos(angle) * tickRadius,
        player.y + Math.sin(angle) * tickRadius,
        player.x + Math.cos(angle) * (tickRadius + markLength),
        player.y + Math.sin(angle) * (tickRadius + markLength),
      );
    }
    document.documentElement.dataset.survivorHeroAuraRadius = String(Math.round(radius));

  }

  onPlayerLevelChanged(event = {}) {
    if (this.mode !== 'expedition' || this.board?.gameEnded || this.levelChoiceOpen) return;
    if (LEVEL_CHOICE_SUPPRESSED && !LEVEL_CHOICE_DEMO_MODE) {
      const root = document.documentElement;
      const count = Number(root.dataset.survivorLevelChoiceSuppressedCount || 0) + 1;
      root.dataset.survivorLevelChoiceSuppressedCount = String(count);
      return;
    }
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
    renderDashControl(this);
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
      renderDashControl(this);
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
    renderDashControl(this);
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
      dash: 'SPACE',
    });
    this.input.keyboard.on('keydown-SPACE', event => {
      event?.event?.preventDefault?.();
      this.requestPlayerDash({ source: 'keyboard' });
    });
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
    this.cameras.main.setBackgroundColor(0x223d28);
    this.cameras.main.setBounds(0, 0, WORLD.width, WORLD.height);
    this.ground = this.add.graphics();
    this.ground.setDepth(-50);
    this.ground.fillStyle(0x345f31, 1);
    this.ground.fillRect(0, 0, WORLD.width, WORLD.height);

    const rng = new PhaserRef.Math.RandomDataGenerator(['ninja2-lantern-expedition']);
    const isCombatClearZone = (x, y, radius = BATTLE_CENTER_CLEAR_RADIUS) => (
      PhaserRef.Math.Distance.Between(x, y, WORLD.centerX, WORLD.centerY) < radius
    );

    this.ground.fillStyle(0x16281b, 0.52);
    this.ground.fillRect(0, 0, WORLD.width, 190);
    this.ground.fillRect(0, WORLD.height - 210, WORLD.width, 210);
    this.ground.fillRect(0, 0, 220, WORLD.height);
    this.ground.fillRect(WORLD.width - 230, 0, 230, WORLD.height);
    this.ground.fillStyle(0x203522, 0.34);
    this.ground.fillRect(0, 0, WORLD.width, 70);
    this.ground.fillRect(0, WORLD.height - 78, WORLD.width, 78);

    const groundBands = [
      { x: 170, y: 260, w: 1120, h: 168, r: 84, color: 0x6f9546, alpha: 0.31 },
      { x: 1320, y: 720, w: 1100, h: 150, r: 80, color: 0x9a8050, alpha: 0.16 },
      { x: 510, y: 1290, w: 1250, h: 144, r: 78, color: 0x789f45, alpha: 0.24 },
      { x: 1840, y: 1180, w: 720, h: 120, r: 66, color: 0x3f6c34, alpha: 0.22 },
    ];
    groundBands.forEach(band => {
      this.ground.fillStyle(band.color, band.alpha);
      this.ground.fillRoundedRect(band.x, band.y, band.w, band.h, band.r);
    });

    this.ground.fillStyle(0xb7c861, 0.12);
    this.ground.fillCircle(WORLD.centerX + 60, WORLD.centerY + 96, 560);
    this.ground.fillStyle(0xf4d46a, 0.026);
    this.ground.fillCircle(WORLD.centerX, WORLD.centerY, BATTLE_CENTER_CLEAR_RADIUS + 52);
    this.ground.lineStyle(10, 0xd1d86b, 0.11);
    this.ground.strokeCircle(WORLD.centerX, WORLD.centerY, BATTLE_CENTER_CLEAR_RADIUS + 42);
    this.ground.lineStyle(3, 0xffdf70, 0.09);
    this.ground.strokeCircle(WORLD.centerX, WORLD.centerY, BATTLE_CENTER_CLEAR_RADIUS - 64);

    this.ground.lineStyle(3, 0x244d2e, 0.18);
    for (let x = -460; x < WORLD.width + 420; x += 155) {
      this.ground.lineBetween(x, -40, x + 860, WORLD.height + 40);
    }

    for (let i = 0; i < 132; i += 1) {
      const x = rng.between(0, WORLD.width);
      const y = rng.between(0, WORLD.height);
      if (isCombatClearZone(x, y, 460)) continue;
      const w = rng.between(48, 150);
      const h = rng.between(26, 74);
      this.ground.fillStyle(rng.pick([0x476f31, 0x7fa850, 0x315b33, 0x91bb55]), rng.realInRange(0.12, 0.26));
      this.ground.fillRoundedRect(x, y, w, h, 24);
    }
    for (let i = 0; i < 92; i += 1) {
      const angle = rng.realInRange(0, Math.PI * 2);
      const distance = rng.realInRange(96, 650);
      const x = WORLD.centerX + Math.cos(angle) * distance;
      const y = WORLD.centerY + Math.sin(angle) * distance * 0.68;
      const size = rng.between(3, 9);
      this.ground.fillStyle(rng.pick([0x253820, 0x6b7f39, 0xc2b06a, 0x20311f]), rng.realInRange(0.08, 0.2));
      if (i % 4 === 0) {
        this.ground.fillRoundedRect(x, y, size * 4, size * 1.4, size);
      } else {
        this.ground.fillCircle(x, y, size);
      }
    }
    for (let i = 0; i < 86; i += 1) {
      this.ground.fillStyle(rng.pick([0x1b2d20, 0x284229, 0x4d6934]), rng.realInRange(0.08, 0.15));
      const x = rng.between(0, WORLD.width);
      const y = rng.between(0, WORLD.height);
      if (isCombatClearZone(x, y, 420)) continue;
      this.ground.fillEllipse(x, y, rng.between(18, 42), rng.between(9, 22));
    }
    for (let i = 0; i < 74; i += 1) {
      const x = rng.between(0, WORLD.width);
      const y = rng.between(0, WORLD.height);
      if (isCombatClearZone(x, y, 430)) continue;
      this.ground.fillStyle(0xe3e59a, 0.28);
      this.ground.fillCircle(x, y, rng.between(3, 7));
      this.ground.fillStyle(0x476f31, 0.24);
      this.ground.fillTriangle(x - 10, y + 10, x, y - 12, x + 10, y + 10);
    }
    for (let i = 0; i < 38; i += 1) {
      const x = rng.between(0, WORLD.width);
      const y = rng.between(0, WORLD.height);
      if (isCombatClearZone(x, y, 420)) continue;
      this.ground.fillStyle(0x8b7150, 0.22);
      this.ground.fillRoundedRect(x, y, rng.between(20, 54), rng.between(10, 24), 8);
    }
    this.drawForestProps(rng);

    this.lightLayer = this.add.graphics();
    this.lightLayer.setDepth(12);
    this.combatCueLayer = this.add.graphics();
    this.combatCueLayer.setDepth(42);
    this.skillFxLayer = this.add.graphics();
    this.skillFxLayer.setDepth(48);
    document.documentElement.dataset.survivorBattleVisualPolish = BATTLE_VISUAL_POLISH_VERSION;
  }

  drawForestProps(rng) {
    const addProp = (texture, x, y, options = {}) => {
      if (!this.textures.exists(texture)) return null;
      const sprite = this.add.image(x, y, texture);
      sprite.setOrigin(0.5, 1);
      sprite.setDepth(options.depth ?? -42);
      sprite.setAlpha(options.alpha ?? 0.72);
      if (options.flipX) sprite.setFlipX(true);
      if (options.rotation) sprite.setRotation(options.rotation);
      if (options.displayWidth) {
        const width = options.displayWidth;
        const height = options.displayHeight || (sprite.height * width) / sprite.width;
        sprite.setDisplaySize(width, height);
      } else {
        sprite.setScale(options.scale ?? 0.72);
      }
      return sprite;
    };

    const addPropGlow = (texture, x, y, width) => {
      if (!['battlePropLanternPost', 'battlePropSoulShrine'].includes(texture)) return;
      const glow = this.add.graphics();
      glow.setDepth(-45);
      const color = texture === 'battlePropSoulShrine' ? COLORS.soul : COLORS.gold;
      const radius = texture === 'battlePropSoulShrine' ? width * 0.92 : width * 1.45;
      glow.fillStyle(color, texture === 'battlePropSoulShrine' ? 0.08 : 0.1);
      glow.fillCircle(x, y - width * 0.58, radius);
      glow.lineStyle(2, color, texture === 'battlePropSoulShrine' ? 0.18 : 0.16);
      glow.strokeCircle(x, y - width * 0.58, radius * 0.72);
    };

    for (let i = 0; i < 34; i += 1) {
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
      const texture = rng.pick(['battlePropBambooClump', 'battlePropMossStones', 'battlePropFallenLog']);
      const width = texture === 'battlePropFallenLog'
        ? rng.between(96, 142)
        : texture === 'battlePropBambooClump'
          ? rng.between(62, 104)
          : rng.between(58, 96);
      addProp(texture, x, y, {
        displayWidth: width,
        alpha: rng.realInRange(0.36, 0.58),
        depth: -44,
        flipX: rng.between(0, 1) === 1,
        rotation: texture === 'battlePropFallenLog' ? rng.realInRange(-0.08, 0.08) : 0,
      });
    }

    for (let i = 0; i < 14; i += 1) {
      const x = rng.between(360, WORLD.width - 360);
      const y = rng.between(260, WORLD.height - 260);
      if (PhaserRef.Math.Distance.Between(x, y, WORLD.centerX, WORLD.centerY) < 520) continue;
      const texture = rng.pick([
        'battlePropLanternPost',
        'battlePropLanternPost',
        'battlePropMossStones',
        'battlePropFallenLog',
        'battlePropSoulShrine',
      ]);
      const width = texture === 'battlePropLanternPost'
        ? rng.between(42, 56)
        : texture === 'battlePropSoulShrine'
          ? rng.between(58, 74)
          : texture === 'battlePropFallenLog'
            ? rng.between(70, 104)
            : rng.between(52, 76);
      addPropGlow(texture, x, y, width);
      addProp(texture, x, y, {
        displayWidth: width,
        alpha: texture === 'battlePropLanternPost' ? 0.68 : rng.realInRange(0.4, 0.62),
        depth: -40,
        flipX: rng.between(0, 1) === 1,
        rotation: texture === 'battlePropFallenLog' ? rng.realInRange(-0.1, 0.1) : 0,
      });
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

function playerHealthRatio(player) {
  if (!player) return 0;
  const maxHp = Math.max(1, Number(player.maxHp || 0));
  return clamp(Number(player.hp || 0) / maxHp, 0, 1);
}

function setPlayerHealthDangerDataset(player) {
  const ratio = playerHealthRatio(player);
  document.documentElement.dataset.survivorPlayerHealthRatio = ratio.toFixed(3);
  document.documentElement.dataset.survivorLowHealth = String(Boolean(player?.alive) && ratio < PLAYER_LOW_HEALTH_THRESHOLD);
  document.documentElement.dataset.survivorLowHealthThreshold = PLAYER_LOW_HEALTH_THRESHOLD.toFixed(2);
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
  const waveCount = Math.max(1, Math.floor(Number(board.map?.popupArgs?.ClientWaveCount || 0)) || 3);
  const mainStageNo = scene.store?.getMainStageNumber?.(board.map) || mainMapStageNo(board.map?.id) || 1;
  const waveSpawned = Math.max(1, Math.floor(board.getBoardVariable(604)) || (wave >= waveCount ? 15 : 18));
  const waveProgress = clamp((waveSpawned - enemies.length) / waveSpawned, 0, 1);
  const stageProgress = clamp((wave - 1 + waveProgress) / waveCount, 0, 1);

  document.documentElement.dataset.survivorTick = String(board.tick);
  document.documentElement.dataset.survivorUnitCount = String(board.units.size);
  document.documentElement.dataset.survivorEnemyCount = String(enemies.length);
  document.documentElement.dataset.survivorPickupCount = String(scene.runDrops);
  document.documentElement.dataset.survivorLootDropActiveCount = String(scene.lootDrops?.length || 0);
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
  setPlayerHealthDangerDataset(player);
  scene.updatePlayerDashDataset();
  document.documentElement.dataset.survivorMode = scene.mode;
  document.documentElement.dataset.survivorGameId = GAME_ID;
  document.documentElement.dataset.survivorMapId = String(board.map?.id || '');
  document.documentElement.dataset.survivorMainStageNo = String(mainStageNo);
  document.documentElement.dataset.survivorWave = String(wave);
  document.documentElement.dataset.survivorWaveCount = String(waveCount);
  document.documentElement.dataset.survivorTriggers = (board.map?.triggers || []).join(',');
  document.documentElement.dataset.survivorStageProgress = stageProgress.toFixed(3);

  dom.levelText.textContent = String(board.playerLevel);
  dom.killText.textContent = String(kills);
  dom.timeText.textContent = formatTime(elapsed);
  dom.phaseText.textContent = board.gameEnded ? 'Return' : `S${mainStageNo}-${wave}`;
  dom.objectiveText.textContent = wave >= waveCount ? '두령 출현' : (board.map?.name || '대나무 숲 정화');
  dom.enemyText.textContent = String(enemies.length);
  dom.pickupText.textContent = String(scene.runDrops);
  dom.hpFill.style.width = `${player ? clamp((player.hp / player.maxHp) * 100, 0, 100).toFixed(1) : 0}%`;
  dom.xpFill.style.width = `${clamp((exp % expNeed) / expNeed * 100, 0, 100).toFixed(1)}%`;
  renderResourceLedger(scene.runLedger);
  renderDashControl(scene);

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
  const builtInstances = getAllBuildingInstances(state).filter(instance => instance.status === 'built');

  for (const instance of builtInstances) {
    const building = BUILDING_BY_KEY.get(instance.buildingKey);
    const level = getInstanceBuildingLevel(state, building, instance);
    const snapshot = getBuildingProductionSnapshot(state, building, level, instance);
    if (!snapshot.hasProduction || snapshot.ratePerMinute <= 0) continue;
    rates[snapshot.stateKey] = Number(rates[snapshot.stateKey] || 0) + snapshot.ratePerMinute;
  }
  return rates;
}

function getBuildingResourceRatesPerMinute(state, building, level = getBuildingLevel(state, building), instance = getPrimaryBuildingInstance(state, building)) {
  const rates = Object.fromEntries(HOME_RESOURCE_KEYS.map(key => [key, 0]));
  const snapshot = getBuildingProductionSnapshot(state, building, level, instance);
  if (snapshot.hasProduction && snapshot.ratePerMinute > 0) rates[snapshot.stateKey] = snapshot.ratePerMinute;
  return rates;
}

function getBuildingProduction(building) {
  return building?.production?.itemDataId ? building.production : null;
}

function getProductionResourceKey(production) {
  if (!production) return '';
  if (production.resourceKey) return production.resourceKey;
  const match = Object.entries(HOUSING_TECH.resources || {})
    .find(([, resource]) => Number(resource.itemId) === Number(production.itemDataId));
  return match?.[0] || '';
}

function getProductionStateKey(production) {
  return stateResourceKey(getProductionResourceKey(production));
}

function getProductionLevelValue(values = [], level = 1, fallback = 0) {
  const rows = Array.isArray(values) ? values : [];
  if (!rows.length) return fallback;
  const index = clamp(Math.floor(Number(level) || 1), 1, rows.length) - 1;
  return Number(rows[index] ?? rows[rows.length - 1] ?? fallback) || fallback;
}

function getHomeProductionPercent(state) {
  let productionPercent = getCompanionBonus(state, 'home_production_percent');
  for (const builtInstance of getAllBuildingInstances(state).filter(row => row.status === 'built')) {
    const builtBuilding = BUILDING_BY_KEY.get(builtInstance.buildingKey);
    const builtEffect = getLevelData(builtBuilding, getInstanceBuildingLevel(state, builtBuilding, builtInstance))?.effect || {};
    productionPercent += Number(builtEffect.all_production_percent || 0);
  }
  return productionPercent;
}

function getHomeStorageMinutesBonus(state) {
  return getAllBuildingInstances(state)
    .filter(instance => instance.status === 'built')
    .reduce((sum, instance) => {
      const building = BUILDING_BY_KEY.get(instance.buildingKey);
      const effect = getLevelData(building, getInstanceBuildingLevel(state, building, instance))?.effect || {};
      return sum + Number(effect.storage_minutes_bonus || 0);
    }, 0);
}

function getBuildingProductionSnapshot(state, building, level = getBuildingLevel(state, building), instance = getPrimaryBuildingInstance(state, building)) {
  const production = getBuildingProduction(building);
  const resourceKey = getProductionResourceKey(production);
  const stateKey = getProductionStateKey(production) || 'none';
  const result = {
    hasProduction: Boolean(production && resourceKey),
    production,
    resourceKey,
    stateKey,
    displayRate: 0,
    ratePerMinute: 0,
    storageMinutes: 0,
    cap: 0,
    stored: 0,
    collectable: 0,
    fill: 0,
  };
  if (!result.hasProduction || !instance || instance.status !== 'built') return result;

  const productionPercent = getHomeProductionPercent(state);
  const multiplier = Math.max(0, 1 + productionPercent / 100);
  const baseDisplayRate = getProductionLevelValue(production.rateByLevel, level, 0);
  const displayRate = Math.max(0, baseDisplayRate * multiplier);
  const rateUnit = String(production.rateUnit || 'per_minute');
  const ratePerMinute = rateUnit === 'per_hour' ? displayRate / 60 : displayRate;
  const baseStorageMinutes = getProductionLevelValue(production.storageMinutesByLevel, level, 60);
  const storageMinutes = Math.max(0, baseStorageMinutes + getHomeStorageMinutesBonus(state));
  const cap = Math.max(0, ratePerMinute * storageMinutes);
  const stored = Math.max(0, Math.min(Number(instance.productionStoredAmount || 0), cap || 0));

  result.displayRate = displayRate;
  result.ratePerMinute = ratePerMinute;
  result.storageMinutes = storageMinutes;
  result.cap = cap;
  result.stored = stored;
  result.collectable = Math.floor(stored);
  result.fill = cap > 0 ? clamp(stored / cap, 0, 1) : 0;
  return result;
}

function settleBuildingProduction(state, building, instance, now = Date.now()) {
  if (!state || !building || !instance || instance.status !== 'built' || !getBuildingProduction(building)) return false;
  const lastSettledAt = Number(instance.productionLastSettledAt) || now;
  const elapsedMs = clamp(now - lastSettledAt, 0, HOME_INCOME_MAX_ELAPSED_MS);
  const before = Number(instance.productionStoredAmount || 0);
  const snapshot = getBuildingProductionSnapshot(state, building, getInstanceBuildingLevel(state, building, instance), instance);
  const produced = snapshot.ratePerMinute > 0 && elapsedMs > 0
    ? snapshot.ratePerMinute * elapsedMs / 60000
    : 0;
  const nextStored = snapshot.cap > 0
    ? Math.min(snapshot.cap, before + produced)
    : 0;
  instance.productionStoredAmount = Math.max(0, nextStored);
  instance.productionLastSettledAt = now;
  state.placedBuildingInstances[instance.id] = instance;
  return elapsedMs > 0 || Math.abs(nextStored - before) > 0.0001;
}

function settleHomeBuildingProduction(state, now = Date.now()) {
  let changed = false;
  for (const instance of getAllBuildingInstances(state)) {
    const building = BUILDING_BY_KEY.get(instance.buildingKey);
    if (settleBuildingProduction(state, building, instance, now)) changed = true;
  }
  state.lastIncomeAt = now;
  state.resourceFractions = { ...(state.resourceFractions || {}) };
  return changed;
}

function getPrimaryHomeRateEntry(rates) {
  return HOME_RESOURCE_KEYS
    .map(key => ({ key, rate: Number(rates?.[key] || 0) }))
    .sort((a, b) => b.rate - a.rate)[0] || { key: 'wood', rate: 0 };
}

function applyHomeResourceIncome(state, now = Date.now()) {
  const changed = settleHomeBuildingProduction(state, now);
  return { rates: getHomeResourceRatesPerMinute(state), gains: {}, changed };
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

function normalizeHomeResourceAnimationKey(key) {
  const stateKey = stateResourceKey(key);
  if (HOME_RESOURCE_ROWS[stateKey]) return stateKey;
  if (HOME_RESOURCE_ROWS[key]) return key;
  return stateKey;
}

function getHomeResourceFxLayer() {
  if (!dom.homeScreen) return null;
  let layer = dom.homeScreen.querySelector('.home-resource-fx-layer');
  if (layer) return layer;
  layer = document.createElement('div');
  layer.className = 'home-resource-fx-layer';
  layer.setAttribute('aria-hidden', 'true');
  dom.homeScreen.append(layer);
  return layer;
}

function getHomeResourceFlyStart(sourceElement, event) {
  const homeRect = dom.homeScreen?.getBoundingClientRect();
  if (!homeRect || homeRect.width <= 0 || homeRect.height <= 0) return null;
  const sourceRect = sourceElement?.getBoundingClientRect?.();
  const hasSourceRect = sourceRect && sourceRect.width > 0 && sourceRect.height > 0;
  const centerX = hasSourceRect
    ? sourceRect.left + sourceRect.width * 0.5
    : Number(event?.clientX || 0);
  const centerY = hasSourceRect
    ? sourceRect.top + sourceRect.height * 0.38
    : Number(event?.clientY || 0);
  if (!Number.isFinite(centerX) || !Number.isFinite(centerY)) return null;
  return {
    x: centerX - homeRect.left - HOME_RESOURCE_FLY_SIZE * 0.5,
    y: centerY - homeRect.top - HOME_RESOURCE_FLY_SIZE * 0.5,
  };
}

function prepareHomeResourceFlyGain(gain, sourceElement, event) {
  if (!gain || Number(gain.amount || 0) <= 0) return null;
  const key = normalizeHomeResourceAnimationKey(gain.key || gain.resourceKey);
  if (!HOME_RESOURCE_ROWS[key]) return null;
  const start = getHomeResourceFlyStart(sourceElement, event);
  if (!start) return null;
  return {
    key,
    amount: Number(gain.amount || 0),
    startX: start.x,
    startY: start.y,
  };
}

function playHomeResourceFlyAnimation(fx, scene = null) {
  const key = normalizeHomeResourceAnimationKey(fx?.key || '');
  const row = HOME_RESOURCE_ROWS[key];
  const layer = getHomeResourceFxLayer();
  const homeRect = dom.homeScreen?.getBoundingClientRect();
  if (!row || !layer || !homeRect || homeRect.width <= 0 || homeRect.height <= 0) {
    scene?.pulseHomeResourceGain?.(key, fx?.amount || 0);
    return false;
  }

  const targetIcon = row.querySelector('span:first-child') || row;
  const targetRect = targetIcon.getBoundingClientRect();
  if (targetRect.width <= 0 || targetRect.height <= 0) {
    scene?.pulseHomeResourceGain?.(key, fx?.amount || 0);
    return false;
  }

  const startX = Number(fx.startX || 0);
  const startY = Number(fx.startY || 0);
  const endX = targetRect.left + targetRect.width * 0.5 - homeRect.left - HOME_RESOURCE_FLY_SIZE * 0.5;
  const endY = targetRect.top + targetRect.height * 0.5 - homeRect.top - HOME_RESOURCE_FLY_SIZE * 0.5;
  const distance = Math.hypot(endX - startX, endY - startY);
  const lift = clamp(distance * 0.18, 54, 118);
  const midX = (startX + endX) * 0.5;
  const midY = Math.min(startY, endY) - lift;
  const iconImage = getComputedStyle(targetIcon).backgroundImage;
  const token = document.createElement('i');
  token.className = `home-resource-fly home-resource-fly-${key}`;
  token.style.setProperty('--fx-start-x', `${startX.toFixed(1)}px`);
  token.style.setProperty('--fx-start-y', `${startY.toFixed(1)}px`);
  token.style.setProperty('--fx-mid-x', `${midX.toFixed(1)}px`);
  token.style.setProperty('--fx-mid-y', `${midY.toFixed(1)}px`);
  token.style.setProperty('--fx-end-x', `${endX.toFixed(1)}px`);
  token.style.setProperty('--fx-end-y', `${endY.toFixed(1)}px`);
  if (iconImage && iconImage !== 'none') token.style.setProperty('--fx-icon', iconImage);
  token.dataset.resource = key;
  token.dataset.amount = String(Math.floor(Number(fx.amount || 0)));
  layer.append(token);

  const currentCount = Number(document.documentElement.dataset.homeResourceFlyCount || 0) + 1;
  document.documentElement.dataset.homeResourceFlyCount = String(currentCount);
  document.documentElement.dataset.homeResourceFlyLast = `${key}:${Math.floor(Number(fx.amount || 0))}`;

  const finish = () => {
    token.remove();
    scene?.pulseHomeResourceGain?.(key, fx.amount);
  };
  token.addEventListener('animationend', finish, { once: true });
  setTimeout(() => {
    if (token.isConnected) finish();
  }, 980);
  return true;
}

function syncHomeIntegratedCollectStatus(rates, state = null) {
  const totalRate = HOME_RESOURCE_KEYS.reduce((sum, key) => sum + Number(rates?.[key] || 0), 0);
  document.documentElement.dataset.homeIntegratedCollectStatus = totalRate > 0 ? 'auto' : 'idle';
  if (state) {
    const collectable = getAllBuildingInstances(state).reduce((sum, instance) => {
      const building = BUILDING_BY_KEY.get(instance.buildingKey);
      const snapshot = getBuildingProductionSnapshot(state, building, getInstanceBuildingLevel(state, building, instance), instance);
      return sum + snapshot.collectable;
    }, 0);
    document.documentElement.dataset.homeCollectableProduction = String(collectable);
  }
}

function getActiveHomeProductionSourceCount(state) {
  const activeSources = getAllBuildingInstances(state).filter(instance => {
    if (instance.status !== 'built') return false;
    const building = BUILDING_BY_KEY.get(instance.buildingKey);
    return getBuildingProductionSnapshot(state, building, getInstanceBuildingLevel(state, building, instance), instance).ratePerMinute > 0;
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

function getMainMapEntries(scene, state) {
  const highestIndex = mainMapIndex(highestUnlockedMainMapId(state));
  const selectedId = normalizeMainMapId(state?.currentMapId, highestUnlockedMainMapId(state));
  return MAIN_MAP_IDS.map((id, index) => {
    const map = scene?.store?.getMap?.(id);
    const copy = MAIN_MAP_COPY[id] || {};
    const waveCount = Math.max(1, Math.floor(Number(map?.popupArgs?.ClientWaveCount || 0)) || (index < 4 ? 3 + index : 10));
    return {
      id,
      map,
      stageNo: scene?.store?.getMainStageNumber?.(id) || index + 1,
      name: map?.name || `Stage ${index + 1}`,
      region: copy.region || '안개 숲',
      focus: copy.focus || '정화',
      reward: summarizeMainMapRewards(scene, map, copy.reward),
      unlock: copy.unlock || `${index} 클리어`,
      waveCount,
      unlocked: index <= highestIndex,
      cleared: isMainMapCleared(state, id),
      selected: Number(selectedId) === id,
      current: Number(highestUnlockedMainMapId(state)) === id && !isMainMapCleared(state, id),
    };
  });
}

function summarizeMainMapRewards(scene, map, fallback = '재료') {
  const names = [];
  const push = name => {
    if (name && !names.includes(name)) names.push(name);
  };
  for (const group of map?.rewardAddItemGroups || []) {
    for (const addItem of group.addItems || []) {
      const id = Number(addItem.itemDataId);
      if (id === 5) push('골드');
      else if (id === 6) push('EXP');
      else if (id === 200101) push('목재');
      else if (id === 200102) push('석재');
      else if (id === 200103) push('영혼불');
      else push(scene?.store?.getItem?.(id)?.name);
      if (names.length >= 3) break;
    }
    if (names.length >= 3) break;
  }
  return names.length ? names.join('·') : fallback;
}

function getSelectedMainMapEntry(scene, state = scene?.sanctuary) {
  const entries = getMainMapEntries(scene, state);
  return entries.find(entry => entry.selected)
    || entries.find(entry => entry.unlocked && !entry.cleared)
    || entries.find(entry => entry.unlocked)
    || entries[0]
    || null;
}

function syncHomeSortieButton(scene, state) {
  if (!dom.sortieButton) return;
  const selected = getSelectedMainMapEntry(scene, state);
  const label = dom.sortieButton.querySelector('span');
  const sub = dom.sortieButton.querySelector('small');
  if (label) label.textContent = '탐험';
  if (sub) sub.textContent = `S${selected?.stageNo || 1}`;
  dom.sortieButton.dataset.mainMapId = String(selected?.id || START_MAP_ID);
  dom.sortieButton.disabled = false;
  dom.sortieButton.setAttribute('aria-label', `${selected?.name || '메인 맵'} 출발`);
}

function getDungeonEntries(scene, state) {
  const selectedId = normalizeSideDungeonMapId(state?.selectedDungeonMapId || state?.lastDungeonMapId);
  return SIDE_DUNGEON_IDS.map((id, index) => {
    const map = scene?.store?.getMap?.(id);
    const copy = SIDE_DUNGEON_COPY[id] || {};
    const waveCount = Math.max(1, Math.floor(Number(map?.popupArgs?.ClientWaveCount || 0)) || (index + 4));
    return {
      id,
      map,
      family: copy.family || map?.popupArgs?.ClientDungeonFamily || '기타 던전',
      name: map?.name || `던전 ${index + 1}`,
      focus: copy.focus || '반복 파밍',
      reward: summarizeMainMapRewards(scene, map, copy.reward || '재료'),
      unlock: copy.unlock || `Stage ${getDungeonUnlockStageClears(scene, id)} 클리어`,
      icon: copy.icon || '門',
      iconAsset: copy.iconAsset || '',
      waveCount,
      unlocked: isSideDungeonUnlocked(scene, state, id),
      cleared: normalizeClearedDungeonIds(state).includes(id),
      selected: Number(selectedId) === id,
    };
  });
}

function getSelectedDungeonEntry(scene, state = scene?.sanctuary) {
  const entries = getDungeonEntries(scene, state);
  return entries.find(entry => entry.selected && entry.unlocked)
    || entries.find(entry => entry.unlocked)
    || entries[0]
    || null;
}

function renderHomeDungeonModal(scene, state) {
  if (!dom.homeDungeonModal || !dom.homeDungeonList) return;
  const open = activeHomeTab === 'exploration' && !homeDungeonDetailOpen;
  syncSideDungeonProgress(scene, state);
  dom.homeDungeonModal.hidden = !open;
  dom.homeDungeonModal.setAttribute('aria-hidden', open ? 'false' : 'true');
  const entries = getDungeonEntries(scene, state);
  const selected = getSelectedDungeonEntry(scene, state);
  const difficultyEntries = getDungeonDifficultyEntries(scene, state, selected?.id);
  const selectedDifficulty = getSelectedDungeonDifficultyEntry(scene, state, selected?.id);
  dom.homeDungeonList.innerHTML = renderExplorationContractBoard(entries, selected, difficultyEntries);
  const footerButton = dom.homeDungeonModal.querySelector('[data-start-dungeon-map]');
  const footerCopy = dom.homeDungeonModal.querySelector('[data-dungeon-footer-copy]');
  if (footerButton) {
    footerButton.dataset.startDungeonMap = String(selected?.id || SIDE_DUNGEON_IDS[0]);
    footerButton.dataset.dungeonDifficulty = selectedDifficulty?.key || DUNGEON_DIFFICULTIES[0].key;
    footerButton.disabled = !selected?.unlocked || !selectedDifficulty?.unlocked;
  }
  if (footerCopy) {
    footerCopy.textContent = formatDungeonStartCopy(selected, selectedDifficulty);
  }
}

function dungeonIconHtml(entry, className = 'home-dungeon-icon') {
  const iconSrc = entry.iconAsset ? `${entry.iconAsset}?v=${ASSET_VERSION}` : '';
  if (iconSrc) {
    return `<i class="${className} is-asset" aria-hidden="true"><img src="${escapeHtml(iconSrc)}" alt="" loading="eager"></i>`;
  }
  return `<i class="${className}" aria-hidden="true">${escapeHtml(entry.icon)}</i>`;
}

function renderExplorationContractBoard(entries, selected, difficultyEntries) {
  return `
    <section class="home-dungeon-map-strip">
      <div class="home-dungeon-map-route" aria-hidden="true"></div>
      <div class="home-dungeon-map-pins" role="list">
        ${entries.map((entry, index) => renderDungeonMapPin(entry, index)).join('')}
      </div>
    </section>
    <div class="home-dungeon-card-stack" role="list">
      ${entries.map(entry => renderDungeonListRow(entry)).join('')}
    </div>
    ${selected ? renderDungeonSelectionDrawer(selected, difficultyEntries) : ''}
  `;
}

function renderDungeonMapPin(entry, index) {
  const stateClass = entry.cleared ? 'is-cleared' : entry.unlocked ? 'is-unlocked' : 'is-locked';
  return `
    <button
      class="home-dungeon-map-pin ${stateClass}${entry.selected ? ' is-selected' : ''}"
      type="button"
      role="listitem"
      data-preview-dungeon-map-id="${entry.id}"
      ${entry.unlocked ? '' : 'disabled'}
      aria-pressed="${entry.selected ? 'true' : 'false'}"
      aria-label="${escapeHtml(entry.name)}"
    >
      <span class="home-dungeon-pin-medallion">${dungeonIconHtml(entry, 'home-dungeon-pin-icon')}</span>
      <span class="home-dungeon-pin-index" aria-hidden="true">${index + 1}</span>
      <span class="home-dungeon-pin-copy">${escapeHtml(entry.unlocked ? entry.family : entry.unlock)}</span>
    </button>
  `;
}

function renderDungeonListRow(entry) {
  const stateClass = entry.cleared ? 'is-cleared' : entry.unlocked ? 'is-unlocked' : 'is-locked';
  return `
    <button
      class="home-dungeon-row ${stateClass}${entry.selected ? ' is-selected' : ''}"
      type="button"
      role="listitem"
      data-preview-dungeon-map-id="${entry.id}"
      ${entry.unlocked ? '' : 'disabled'}
      aria-pressed="${entry.selected ? 'true' : 'false'}"
      aria-label="${escapeHtml(entry.name)}"
    >
      ${dungeonIconHtml(entry)}
      <span class="home-dungeon-card-copy">
        <b>${escapeHtml(entry.name)}</b>
        <small>${escapeHtml(entry.family)} · ${escapeHtml(entry.focus)} · ${entry.waveCount}W</small>
      </span>
      <span class="home-dungeon-reward-chips" aria-hidden="true">
        <em>${entry.unlocked ? escapeHtml(entry.reward) : escapeHtml(entry.unlock)}</em>
        <em>${entry.waveCount}W</em>
      </span>
    </button>
  `;
}

function renderDungeonSelectionDrawer(entry, difficultyEntries) {
  return `
    <section class="home-dungeon-drawer" aria-live="polite">
      <div class="home-dungeon-drawer-card">
        <div class="home-dungeon-drawer-icon">${dungeonIconHtml(entry, 'home-dungeon-drawer-icon-asset')}</div>
        <span class="home-dungeon-drawer-copy">
          <b>${escapeHtml(entry.name)}</b>
          <small>${escapeHtml(entry.focus)} · ${escapeHtml(entry.reward)} · ${entry.waveCount}W</small>
        </span>
      </div>
      <div class="home-dungeon-difficulty-list is-compact" role="list">
        ${difficultyEntries.map(renderDungeonDifficultyRow).join('')}
      </div>
    </section>
  `;
}

function renderHomeDungeonDetailModal(scene, state) {
  if (!dom.homeDungeonDetailModal || !dom.homeDungeonDetailBody) return;
  const open = activeHomeTab === 'exploration' && homeDungeonDetailOpen;
  syncSideDungeonProgress(scene, state);
  dom.homeDungeonDetailModal.hidden = !open;
  dom.homeDungeonDetailModal.setAttribute('aria-hidden', open ? 'false' : 'true');
  const selected = getSelectedDungeonEntry(scene, state);
  const difficultyEntries = getDungeonDifficultyEntries(scene, state, selected?.id);
  const selectedDifficulty = getSelectedDungeonDifficultyEntry(scene, state, selected?.id);
  dom.homeDungeonDetailBody.innerHTML = selected
    ? renderDungeonDetail(selected, difficultyEntries)
    : '';
  const footerButton = dom.homeDungeonDetailModal.querySelector('[data-start-dungeon-map]');
  const footerCopy = dom.homeDungeonDetailModal.querySelector('[data-dungeon-detail-footer-copy]');
  if (footerButton) {
    footerButton.dataset.startDungeonMap = String(selected?.id || SIDE_DUNGEON_IDS[0]);
    footerButton.dataset.dungeonDifficulty = selectedDifficulty?.key || DUNGEON_DIFFICULTIES[0].key;
    footerButton.disabled = !selected?.unlocked || !selectedDifficulty?.unlocked;
  }
  if (footerCopy) {
    footerCopy.textContent = formatDungeonStartCopy(selected, selectedDifficulty);
  }
}

function formatDungeonStartCopy(entry, difficulty) {
  if (!entry) return '';
  if (!entry.unlocked) return `${entry.unlock || '메인 진행 필요'} 후 해금`;
  if (!difficulty?.unlocked) return `${difficulty?.unlock || entry.unlock || '메인 진행 필요'} 후 해금`;
  return `${entry.name} · ${difficulty.label} · 보상 ${difficulty.rewardRate}`;
}

function renderDungeonDetail(entry, difficultyEntries) {
  return `
    <section class="home-dungeon-detail-card">
      <div class="home-dungeon-detail-icon">${dungeonIconHtml(entry, 'home-dungeon-detail-icon-asset')}</div>
      <div>
        <span>${escapeHtml(entry.family)}</span>
        <b>${escapeHtml(entry.name)}</b>
        <small>${escapeHtml(entry.focus)} · ${escapeHtml(entry.reward)} · ${entry.waveCount}W</small>
      </div>
    </section>
    <div class="home-dungeon-difficulty-list" role="list" aria-label="난이도 선택">
      ${difficultyEntries.map(renderDungeonDifficultyRow).join('')}
    </div>
  `;
}

function renderDungeonDifficultyRow(entry) {
  return `
    <button
      class="home-dungeon-difficulty-row${entry.selected ? ' is-selected' : ''}${entry.unlocked ? ' is-unlocked' : ' is-locked'}"
      type="button"
      role="listitem"
      data-dungeon-difficulty="${escapeHtml(entry.key)}"
      ${entry.unlocked ? '' : 'disabled'}
      aria-pressed="${entry.selected ? 'true' : 'false'}"
    >
      <span>
        <b>${escapeHtml(entry.label)}</b>
        <small>${escapeHtml(entry.threat)} · 보상 ${escapeHtml(entry.rewardRate)}</small>
      </span>
      <em>${entry.unlocked ? escapeHtml(entry.badge) : escapeHtml(entry.unlock)}</em>
    </button>
  `;
}

function homeFeatureIconPath(iconKey) {
  const sideIconPaths = {
    bag: './assets/ninja2/ui/icons/icon_side_bag.png',
    gift: './assets/ninja2/ui/icons/icon_side_gift.png',
    mail: './assets/ninja2/ui/icons/icon_side_mail.png',
    pass: './assets/ninja2/ui/icons/icon_side_pass.png',
  };
  const path = HOME_UI_ICON_PATHS[iconKey] || sideIconPaths[iconKey];
  return path ? `${path}?v=${ASSET_VERSION}` : '';
}

function homeFeatureIconHtml(iconKey, className = 'home-feature-icon') {
  const path = homeFeatureIconPath(iconKey);
  if (path) {
    return `<i class="${className} is-asset" aria-hidden="true"><img src="${escapeHtml(path)}" alt="" loading="eager"></i>`;
  }
  return `<i class="${className}" aria-hidden="true"></i>`;
}

function getLocalDateKey(date = new Date()) {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  return `${year}-${month}-${day}`;
}

function rewardDisplayName(key, scene = null, state = null) {
  if (key === 'ad_removal') return '광고 제거';
  if (key === 'companion_shards') return '동료 조각';
  if (key === 'companion_exp') return '동료 경험';
  if (key === 'energy') return '에너지';
  if (key === 'exp') return '경험치';
  if (key === 'free_ruby') return '무료 루비';
  if (key === 'light') return '등불';
  if (key === 'ruby') return '루비';
  if (key === 'equipment_item') {
    const item = getStarterShopEquipmentItem(scene, state);
    return item?.name || '장비';
  }
  return HOME_RESOURCE_LABELS[key] || resourceName(key);
}

function formatRewardBundle(reward = {}, scene = null, state = null) {
  const entries = Object.entries(reward).filter(([, value]) => Number(value) > 0);
  if (!entries.length) return '보상 없음';
  return entries.map(([key, value]) => `${rewardDisplayName(key, scene, state)} +${formatNumber(value)}`).join(' · ');
}

function homeRewardKeyForItemId(itemDataId) {
  const id = Number(itemDataId);
  if (id === 3) return 'ruby';
  if (id === 4) return 'free_ruby';
  if (id === 5) return 'gold';
  if (id === 6) return 'exp';
  if (id === 8) return 'energy';
  if (id === 200101) return 'wood';
  if (id === 200102) return 'stone';
  if (id === 200103) return 'souls';
  if (id === 200111) return 'companion_shards';
  if (id === 201504) return 'ad_removal';
  return id ? `item_${id}` : '';
}

function homeRewardBundleFromAchievement(achievement) {
  const reward = {};
  for (const group of achievement?.rewardAddItemGroups || []) {
    for (const addItem of group?.addItems || []) {
      const key = homeRewardKeyForItemId(addItem.itemDataId);
      const count = Math.max(0, Math.floor(Number(addItem.count ?? addItem.minCount ?? addItem.maxCount ?? 0)));
      if (!key || !count) continue;
      reward[key] = (reward[key] || 0) + count;
    }
  }
  return reward;
}

function getHomeMissionAchievements(scene) {
  return [...(scene?.store?.achievements?.values?.() || [])].filter(achievement => (
    achievement?.type === 'Mission'
    && (achievement?.tags || []).includes('HomeUI')
  ));
}

function homeMissionIconKeyForAchievement(achievement) {
  const tags = achievement?.tags || [];
  const group = String(achievement?.popupArgs?.MissionGroup || '');
  const itemId = Number(achievement?.conditionValue1 || 0);
  if (tags.includes('Companion')) return 'companions';
  if (group === 'stage_clear' || group === 'side_dungeon') return 'exploration';
  if (group === 'building') {
    if (itemId === 200601) return 'companions';
    if (itemId === 200602) return 'wood';
    if (itemId === 200603) return 'soul';
    if (itemId === 200604) return 'stone';
    return 'sanctuary';
  }
  if (group === 'currency') return RESOURCE_ICON_KEYS[homeRewardKeyForItemId(itemId)] || homeRewardKeyForItemId(itemId);
  return 'mission';
}

function homeMissionDetailForAchievement(achievement, progress, currentScene = null) {
  const condition = String(achievement?.condition || '');
  const value1 = Number(achievement?.conditionValue1 || 0);
  if (condition === 'WinGame') {
    const map = currentScene?.store?.getMap?.(value1);
    return map?.name ? `${map.name} 정화` : `맵 ${value1} 정화`;
  }
  if (condition === 'AcquireItem') {
    const item = currentScene?.store?.getItem?.(value1);
    return `${item?.name || `아이템 ${value1}`} ${formatNumber(progress.progress)}/${formatNumber(progress.target)}`;
  }
  if (condition === 'BuyItemProduct') {
    const item = currentScene?.store?.getItem?.(value1);
    return `${item?.name || `상품 ${value1}`} 구매`;
  }
  return `${formatNumber(progress.progress)}/${formatNumber(progress.target)}`;
}

function getHomeMissionContext(currentScene = null) {
  return {
    detailForAchievement: (achievement, progress) => homeMissionDetailForAchievement(achievement, progress, currentScene),
    getAchievementProgress: achievement => currentScene?.board?.getAchievementProgress?.(achievement),
    getClaimedMissionKeys: state => normalizeStringList(state?.claimedMissionKeys),
    getMissionAchievements: getHomeMissionAchievements,
    iconKeyForAchievement: homeMissionIconKeyForAchievement,
    rewardForAchievement: homeRewardBundleFromAchievement,
  };
}

function getHomeMissionRenderUi(scene, state) {
  return {
    escapeHtml,
    formatNumber,
    iconHtml: homeFeatureIconHtml,
    scene,
    state,
  };
}

function getHomeMailRenderUi(scene, state) {
  return {
    escapeHtml,
    formatNumber,
    iconHtml: homeFeatureIconHtml,
    scene,
    state,
  };
}

function getHomeShopContext() {
  return {
    canAffordCost,
    getLocalDateKey,
    normalizeClaimMap,
  };
}

function getHomeShopRenderUi(scene, state) {
  return {
    activeCategory: activeHomeShopCategory,
    escapeHtml,
    formatNumber,
    formatRewardBundle,
    iconHtml: homeFeatureIconHtml,
    scene,
    state,
  };
}

function applyHomeRewardBundle(state, reward = {}, scene = null) {
  const labels = [];
  for (const [key, rawValue] of Object.entries(reward || {})) {
    const value = Math.max(0, Math.floor(Number(rawValue || 0)));
    if (!value) continue;
    if (key === 'ad_removal') {
      state.adRemoval = true;
      labels.push('광고 제거 보유');
    } else if (key === 'companion_shards') {
      state.companionShards = Math.max(0, Number(state.companionShards || 0) + value);
      labels.push(`동료 조각 +${formatNumber(value)}`);
    } else if (key === 'companion_exp') {
      const granted = addCompanionExp(state, value);
      labels.push(`동료 경험 +${formatNumber(granted || value)}`);
    } else if (key === 'equipment_item') {
      const item = getStarterShopEquipmentItem(scene, state);
      if (item) {
        addSanctuaryItem(state, item.id, value);
        state.selectedEquipmentItemId = Number(item.id);
        labels.push(`${item.name} +${formatNumber(value)}`);
      }
    } else {
      setStateResource(state, key, getStateResource(state, key) + value);
      labels.push(`${rewardDisplayName(key, scene, state)} +${formatNumber(value)}`);
    }
  }
  return labels;
}

function renderHomeFeatureScreen(scene, state) {
  if (!dom.homeFeatureScreen) return;
  const visible = HOME_FEATURE_TABS.has(activeHomeTab);
  dom.homeFeatureScreen.hidden = !visible;
  dom.homeFeatureScreen.setAttribute('aria-hidden', visible ? 'false' : 'true');
  document.documentElement.dataset.homeFeatureVisible = visible ? activeHomeTab : 'false';
  if (!visible) {
    dom.homeFeatureScreen.innerHTML = '';
    return;
  }

  dom.homeFeatureScreen.innerHTML = '';
}

function renderHomeMissionModal(scene, state) {
  if (!dom.homeMissionModal) return;
  const visible = activeHomeTab === HOME_MISSION_MODAL_TAB;
  dom.homeMissionModal.hidden = !visible;
  dom.homeMissionModal.setAttribute('aria-hidden', visible ? 'false' : 'true');
  document.documentElement.dataset.homeMissionModalOpen = visible ? 'true' : 'false';
  if (!visible) {
    if (dom.homeMissionBody) dom.homeMissionBody.innerHTML = '';
    if (dom.homeMissionFooter) dom.homeMissionFooter.innerHTML = '';
    document.documentElement.dataset.homeMissionClaimableCount = '0';
    document.documentElement.dataset.homeMissionClaimedCount = '0';
    return;
  }

  const entries = getHomeMissionEntries(scene, state, getHomeMissionContext(scene));
  const summary = getHomeMissionSummary(entries);
  document.documentElement.dataset.homeMissionClaimableCount = String(summary.claimable);
  document.documentElement.dataset.homeMissionClaimedCount = String(summary.claimed);
  document.documentElement.dataset.homeMissionTotalCount = String(summary.total);
  if (dom.homeMissionBody) {
    dom.homeMissionBody.innerHTML = renderHomeMissionModalBody(entries, getHomeMissionRenderUi(scene, state));
  }
  if (dom.homeMissionFooter) {
    dom.homeMissionFooter.innerHTML = renderHomeMissionModalFooter(summary, getHomeMissionRenderUi(scene, state));
  }
}

function renderHomeShopModal(scene, state) {
  if (!dom.homeShopModal) return;
  const visible = activeHomeTab === HOME_SHOP_MODAL_TAB;
  dom.homeShopModal.hidden = !visible;
  dom.homeShopModal.setAttribute('aria-hidden', visible ? 'false' : 'true');
  document.documentElement.dataset.homeShopModalOpen = visible ? 'true' : 'false';
  if (!visible) {
    if (dom.homeShopBody) dom.homeShopBody.innerHTML = '';
    if (dom.homeShopFooter) dom.homeShopFooter.innerHTML = '';
    document.documentElement.dataset.homeShopAvailableCount = '0';
    return;
  }

  const products = getHomeShopProductEntries(scene, state, getHomeShopContext());
  const summary = getHomeShopSummary(products);
  document.documentElement.dataset.homeShopAvailableCount = String(summary.available);
  document.documentElement.dataset.homeShopClaimedCount = String(summary.claimed);
  document.documentElement.dataset.homeShopTotalCount = String(summary.total);
  if (dom.homeShopBody) {
    dom.homeShopBody.innerHTML = renderHomeShopModalBody(products, getHomeShopRenderUi(scene, state));
  }
  if (dom.homeShopFooter) {
    dom.homeShopFooter.innerHTML = renderHomeShopModalFooter(summary, getHomeShopRenderUi(scene, state));
  }
}

function syncHomeMailboxState(state = {}) {
  const entries = getHomeMailEntries(state);
  const summary = getHomeMailSummary(entries);
  document.documentElement.dataset.homeMailTotalCount = String(summary.total);
  document.documentElement.dataset.homeMailUnreadCount = String(summary.unread);
  document.documentElement.dataset.homeMailClaimableCount = String(summary.claimable);
  document.documentElement.dataset.homeMailClaimedCount = String(summary.claimed);
  document.documentElement.dataset.homeMailClaimed = Object.keys(normalizeClaimMap(state.mailClaims)).join(',');
  const badgeCount = summary.unread;
  if (dom.homeMailBadge) {
    dom.homeMailBadge.hidden = badgeCount <= 0;
    dom.homeMailBadge.textContent = badgeCount > 9 ? '9+' : String(badgeCount);
  }
  return { entries, summary };
}

function getCollectableHomeProductionEntries(state) {
  return getAllBuildingInstances(state).map(instance => {
    const building = BUILDING_BY_KEY.get(instance.buildingKey);
    if (!building || instance.status !== 'built') return null;
    const snapshot = getBuildingProductionSnapshot(state, building, getInstanceBuildingLevel(state, building, instance), instance);
    if (!snapshot.hasProduction || snapshot.collectable <= 0) return null;
    return { building, instance, snapshot };
  }).filter(Boolean);
}

function renderHomeQuickModal(scene, state) {
  if (!dom.homeQuickModal) return;
  const open = HOME_QUICK_VIEW_KEYS.has(activeHomeQuickView);
  dom.homeQuickModal.hidden = !open;
  dom.homeQuickModal.setAttribute('aria-hidden', open ? 'false' : 'true');
  document.documentElement.dataset.homeQuickView = open ? activeHomeQuickView : 'closed';
  if (!open) return;

  const meta = homeQuickViewMeta(activeHomeQuickView);
  if (dom.homeQuickTitle) dom.homeQuickTitle.textContent = meta.title;
  if (dom.homeQuickKicker) dom.homeQuickKicker.textContent = meta.kicker;
  if (dom.homeQuickBody) dom.homeQuickBody.innerHTML = renderHomeQuickBody(scene, state, activeHomeQuickView);
  if (dom.homeQuickFooter) {
    if (activeHomeQuickView === 'mail') {
      const { summary } = syncHomeMailboxState(state);
      dom.homeQuickFooter.innerHTML = renderHomeMailModalFooter(summary, getHomeMailRenderUi(scene, state));
    } else {
      dom.homeQuickFooter.innerHTML = `
        <span>${escapeHtml(meta.footer)}</span>
        <button class="home-modal-action-button" type="button" data-close-home-quick>닫기</button>
      `;
    }
  }
}

function homeQuickViewMeta(viewKey) {
  const table = {
    mail: { title: '우편', kicker: '성소 알림', footer: '보상과 생산 알림을 한 곳에서 확인합니다' },
    gift: { title: '선물', kicker: '일일 보급', footer: '오늘 받을 수 있는 보급품을 확인합니다' },
    bag: { title: '가방', kicker: '보유 자원', footer: '재화와 획득 아이템은 런타임 저장 상태를 읽습니다' },
    pass: { title: '패스', kicker: '진행 보상', footer: '메인 정화와 성소 성장으로 단계가 열립니다' },
  };
  return table[viewKey] || table.mail;
}

function renderHomeQuickBody(scene, state, viewKey) {
  if (viewKey === 'gift') return renderHomeGiftQuickView(scene, state);
  if (viewKey === 'bag') return renderHomeBagQuickView(scene, state);
  if (viewKey === 'pass') return renderHomePassQuickView(scene, state);
  return renderHomeMailQuickView(scene, state);
}

function renderHomeMailQuickView(scene, state) {
  const { entries } = syncHomeMailboxState(state);
  return renderHomeMailModalBody(entries, getHomeMailRenderUi(scene, state));
}

function renderHomeGiftQuickView(scene, state) {
  const today = getLocalDateKey();
  const claimed = state.dailyGiftClaimDate === today || state.shopClaims?.daily_supply === today;
  document.documentElement.dataset.homeDailyGiftClaimed = claimed ? 'true' : 'false';
  return `
    <div class="home-quick-reward-card is-${claimed ? 'claimed' : 'available'}">
      ${homeFeatureIconHtml('gift', 'home-quick-large-icon')}
      <div>
        <b>오늘의 보급</b>
        <span>${escapeHtml(formatRewardBundle(HOME_SHOP_PRODUCT_DEFS[0].reward, scene, state))}</span>
      </div>
      <button class="home-modal-action-button" type="button" data-home-quick-action="claim-daily-gift" ${claimed ? 'disabled' : ''}>
        ${claimed ? '수령됨' : '받기'}
      </button>
    </div>
  `;
}

function renderHomeBagQuickView(scene, state) {
  const resources = ['wood', 'souls', 'gold', 'stone', 'light', 'companion_shards'];
  const itemRows = Object.entries(normalizeItemInventory(state.itemInventory))
    .map(([id, count]) => {
      const item = scene?.store?.getItem?.(Number(id)) || { id: Number(id), name: `Item ${id}` };
      const src = resultItemIconSrc(item);
      return `
        <div class="home-bag-item-row">
          <i aria-hidden="true">${src ? `<img src="${escapeHtml(resultIconSrc(src))}" alt="" loading="eager">` : ''}</i>
          <span><b>${escapeHtml(item.name || `Item ${id}`)}</b><small>ID ${escapeHtml(id)}</small></span>
          <em>${escapeHtml(formatNumber(count))}</em>
        </div>
      `;
    })
    .join('');
  return `
    <div class="home-bag-resource-grid">
      ${resources.map(key => renderHomeBagResourceChip(state, key)).join('')}
    </div>
    <div class="home-bag-item-list" role="list" aria-label="보유 아이템">
      ${itemRows || '<div class="home-build-empty"><b>아이템 없음</b><span>탐험과 상점 보상으로 채워집니다</span></div>'}
    </div>
  `;
}

function renderHomeBagResourceChip(state, key) {
  const value = key === 'companion_shards'
    ? Number(state.companionShards || 0)
    : getStateResource(state, key);
  const iconKey = key === 'companion_shards' ? 'companions' : RESOURCE_ICON_KEYS[key] || key;
  return `
    <div class="home-bag-resource-chip">
      ${homeFeatureIconHtml(iconKey, 'home-bag-resource-icon')}
      <span>${escapeHtml(rewardDisplayName(key))}</span>
      <b>${escapeHtml(formatNumber(value))}</b>
    </div>
  `;
}

function getHomePassTierEntries(state) {
  const claimed = new Set(normalizeStringList(state.passClaimedTiers));
  return HOME_PASS_TIERS.map(tier => {
    const progress = homePassTierProgress(state, tier);
    const complete = progress >= tier.target;
    const isClaimed = claimed.has(tier.key);
    return {
      ...tier,
      progress,
      complete,
      claimed: isClaimed,
      percent: clamp(progress / Math.max(1, tier.target) * 100, 0, 100),
      status: isClaimed ? 'claimed' : complete ? 'claimable' : 'active',
    };
  });
}

function homePassTierProgress(state, tier) {
  if (tier.metric === 'shrineLevel') return Number(state?.shrineLevel || 1);
  if (tier.metric === 'companions') return getActiveCompanions(state).length;
  return Number(state?.stageClears || 0);
}

function renderHomePassQuickView(scene, state) {
  const tiers = getHomePassTierEntries(state);
  document.documentElement.dataset.homePassClaimableCount = String(tiers.filter(tier => tier.status === 'claimable').length);
  return `<div class="home-quick-list">${tiers.map(tier => renderHomePassTierRow(tier, scene, state)).join('')}</div>`;
}

function renderHomePassTierRow(tier, scene, state) {
  return `
    <div class="home-quick-row is-${tier.status}">
      ${homeFeatureIconHtml(tier.iconKey, 'home-quick-row-icon')}
      <span>
        <b>${escapeHtml(tier.title)}</b>
        <small>${escapeHtml(`${Math.min(tier.progress, tier.target)}/${tier.target} · ${formatRewardBundle(tier.reward, scene, state)}`)}</small>
        <i class="home-feature-progress" aria-hidden="true"><i style="width:${tier.percent.toFixed(1)}%"></i></i>
      </span>
      <button class="home-quick-row-action" type="button" data-claim-home-pass="${escapeHtml(tier.key)}" ${tier.complete && !tier.claimed ? '' : 'disabled'}>
        ${tier.claimed ? '완료' : tier.complete ? '받기' : '진행'}
      </button>
    </div>
  `;
}

function renderHomeQuickActionRow(row) {
  return `
    <div class="home-quick-row">
      ${homeFeatureIconHtml(row.iconKey, 'home-quick-row-icon')}
      <span><b>${escapeHtml(row.title)}</b><small>${escapeHtml(row.detail)}</small></span>
      <button class="home-quick-row-action" type="button" ${row.actionAttr || ''} ${row.disabled ? 'disabled' : ''}>${escapeHtml(row.action)}</button>
    </div>
  `;
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
  const building = getHomeBuildPlanBuilding(state);
  if (!building) {
    homeBuildHover.anchorTileId = 0;
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

  const footprint = getBuildingFootprintMetrics(building);
  const ghostWidth = Math.round(clamp(footprint.width * 0.72, 92, 176));
  const ghostHeight = Math.round(clamp(footprint.height * 0.72 + 28, 112, 174));
  const artWidth = Math.round(clamp(Number(building.visual?.w || ghostWidth - 10), 68, ghostWidth - 8));
  const artHeight = Math.round(clamp(Number(building.visual?.h || ghostHeight - 32), 68, ghostHeight - 30));
  const preview = getHomePlacementPreview(state);

  dom.homeBuildGhost.hidden = false;
  dom.homeBuildGhost.dataset.buildingKey = building.key;
  dom.homeBuildGhost.dataset.footprint = building.footprint || '1x1';
  dom.homeBuildGhost.dataset.placement = preview ? (preview.valid ? 'valid' : 'invalid') : 'pending';
  dom.homeBuildGhost.style.setProperty('--home-build-ghost-w', `${ghostWidth}px`);
  dom.homeBuildGhost.style.setProperty('--home-build-ghost-h', `${ghostHeight}px`);
  dom.homeBuildGhost.style.setProperty('--home-build-ghost-art-w', `${artWidth}px`);
  dom.homeBuildGhost.style.setProperty('--home-build-ghost-art-h', `${artHeight}px`);
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
  syncMainMapProgress(state);
  syncSideDungeonProgress(scene, state);
  syncCompanionUnlocks(state, { announce: false });
  const completedBuildings = completeFinishedConstructions(state);
  const productionChanged = settleHomeBuildingProduction(state);
  if (completedBuildings.length || productionChanged) saveSanctuary(state);
  const resourceRates = getHomeResourceRatesPerMinute(state);
  renderHomeResourceRows(state, resourceRates);
  syncHomeIntegratedCollectStatus(resourceRates, state);
  syncHomeTabs(state);
  renderHomeDungeonModal(scene, state);
  renderHomeDungeonDetailModal(scene, state);
  syncHomeSortieButton(scene, state);
  renderHomeBuildList(state);
  renderHomeEquipment(scene, state);
  renderHomeEquipmentDetailModal(scene, state);
  renderHomeFeatureScreen(scene, state);
  renderHomeMissionModal(scene, state);
  renderHomeShopModal(scene, state);
  syncHomeMailboxState(state);
  renderHomeQuickModal(scene, state);
  if (options.animateGains && !options.flyGains?.length) {
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
  if (options.flyGains?.length) {
    for (const flyGain of options.flyGains) {
      scene.playHomeResourceFly?.(flyGain);
    }
  }
  document.documentElement.dataset.survivorMode = 'home';
  document.documentElement.dataset.survivorGameId = GAME_ID;
  document.documentElement.dataset.homeDemo = HOME_BUILT_CITY_DEMO_MODE ? 'city' : (HOME_START_DEMO_MODE ? 'start' : 'live');
  document.documentElement.dataset.homeResourceRates = HOME_RESOURCE_KEYS
    .map(key => `${key}:${Number(resourceRates[key] || 0).toFixed(3)}`)
    .join(',');
  document.documentElement.dataset.homeResourceAmounts = HOME_RESOURCE_KEYS
    .map(key => `${key}:${Math.floor(Number(state[key] || 0))}`)
    .join(',');
  document.documentElement.dataset.homeBuildingProduction = getAllBuildingInstances(state)
    .map(instance => {
      const building = BUILDING_BY_KEY.get(instance.buildingKey);
      const snapshot = getBuildingProductionSnapshot(state, building, getInstanceBuildingLevel(state, building, instance), instance);
      return snapshot.hasProduction
        ? `${instance.id}:${snapshot.stateKey}:${snapshot.stored.toFixed(2)}:${snapshot.collectable}`
        : `${instance.id}:none:0:0`;
    })
    .join(',');
  document.documentElement.dataset.homeStageClears = String(state.stageClears || 0);
  document.documentElement.dataset.homeMainMapCurrent = String(state.currentMapId || START_MAP_ID);
  document.documentElement.dataset.homeMainMapHighest = String(state.highestUnlockedMapId || START_MAP_ID);
  document.documentElement.dataset.homeMainMapCleared = (state.clearedMapIds || []).join(',');
  document.documentElement.dataset.homeMainMapProgress = `${(state.clearedMapIds || []).length}/${MAIN_MAP_IDS.length}`;
  document.documentElement.dataset.homeDungeonSelected = String(state.selectedDungeonMapId || '');
  document.documentElement.dataset.homeDungeonDetailOpen = homeDungeonDetailOpen ? 'true' : 'false';
  document.documentElement.dataset.homeDungeonDifficultySelected = String(state.selectedDungeonDifficultyKey || '');
  document.documentElement.dataset.homeDungeonUnlocked = SIDE_DUNGEON_IDS
    .filter(id => isSideDungeonUnlocked(scene, state, id))
    .join(',');
  document.documentElement.dataset.homeDungeonCleared = (state.clearedDungeonIds || []).join(',');
  document.documentElement.dataset.homeCompanionUnlockedCount = String(getActiveCompanions(state).length);
  document.documentElement.dataset.homeCompanionSummonableCount = String(getSummonableCompanions(state).length);
  document.documentElement.dataset.homeCompanionGachaPool = getCompanionGachaPool(state).map(companion => companion.key).join(',');
  document.documentElement.dataset.homeCompanionGachaPulls = String(state.companionGachaPulls || 0);
  document.documentElement.dataset.homeCompanionRoster = D1_COMPANIONS
    .map(companion => `${companion.key}:${getCompanionRosterStatus(state, companion)}`)
    .join(',');
  document.documentElement.dataset.homeMissionClaimed = normalizeStringList(state.claimedMissionKeys).join(',');
  document.documentElement.dataset.homeMailClaimed = Object.keys(normalizeClaimMap(state.mailClaims)).join(',');
  document.documentElement.dataset.homeMailRead = normalizeStringList(state.mailReadKeys).join(',');
  document.documentElement.dataset.homePassClaimed = normalizeStringList(state.passClaimedTiers).join(',');
  document.documentElement.dataset.homeShopClaims = Object.entries(normalizeClaimMap(state.shopClaims)).map(([key, value]) => `${key}:${value}`).join(',');
  document.documentElement.dataset.homeBuildPlan = state.buildPlanBuildingKey || '';
  const placementPreview = getHomePlacementPreview(state);
  document.documentElement.dataset.homeBuildPlanFootprint = getHomeBuildPlanBuilding(state)?.footprint || '';
  document.documentElement.dataset.homeBuildPlanHoverTile = placementPreview ? String(placementPreview.anchorTileId) : '';
  document.documentElement.dataset.homeBuildPlanHoverValid = placementPreview ? String(placementPreview.valid) : '';
  document.documentElement.dataset.homeBuildPlanHoverTiles = placementPreview?.tiles?.join(',') || '';
  document.documentElement.dataset.homeBuildListCount = String(getHomeBuildListBuildings(state).length);
  document.documentElement.dataset.homeBuildingInstanceCount = String(getAllBuildingInstances(state).length);
  document.documentElement.dataset.homeRepeatableBuildingCounts = BUILDINGS
    .filter(building => isRepeatableBuilding(building))
    .map(building => `${building.key}:${getBuildingInstanceCount(state, building)}/${getMaxBuildingInstances(state, building)}`)
    .join(',');
  syncHomeBuildGhost(state);
  syncHomeTabs(state);
}

function renderHomeEquipment(scene, state) {
  if (!dom.homeEquipmentScreen) return;
  const visible = activeHomeTab === 'equipment';
  const catalog = getHomeEquipmentCatalog(scene);
  const ownedCatalog = getHomeEquipmentOwnedCatalog(catalog, state);
  state.equippedItemIds = normalizeEquippedItemIds(state.equippedItemIds);
  if (visible && normalizeEquipmentItemId(homeEquipmentDetailItemId) > 0) {
    const detailItem = catalog.find(item => Number(item.id) === normalizeEquipmentItemId(homeEquipmentDetailItemId));
    if (detailItem) state.selectedEquipmentItemId = Number(detailItem.id);
  }
  const filteredCatalog = getFilteredHomeEquipmentCatalog(ownedCatalog);
  const selected = resolveSelectedHomeEquipment(state, ownedCatalog, filteredCatalog);
  const equippedItems = getEquippedHomeEquipmentItems(scene, state);
  const totals = getHomeEquipmentStatTotals(equippedItems, state);
  const emptySlotCount = Math.max(0, HOME_EQUIPMENT_SLOT_SPECS.length - equippedItems.length);

  dom.homeEquipmentScreen.hidden = !visible;
  dom.homeEquipmentScreen.setAttribute('aria-hidden', visible ? 'false' : 'true');
  document.documentElement.dataset.homeEquipmentVisible = visible ? 'true' : 'false';
  document.documentElement.dataset.homeEquipmentCatalogCount = String(catalog.length);
  document.documentElement.dataset.homeEquipmentOwnedCount = String(ownedCatalog.length);
  document.documentElement.dataset.homeEquipmentRenderedCount = String(filteredCatalog.length);
  document.documentElement.dataset.homeEquipmentEquippedCount = String(equippedItems.length);
  document.documentElement.dataset.homeEquipmentEmptySlotCount = String(emptySlotCount);
  document.documentElement.dataset.homeEquipmentEmptySlotIconCount = '0';
  document.documentElement.dataset.homeEquipmentSelected = selected ? String(selected.id) : '';
  document.documentElement.dataset.homeEquipmentFilter = activeEquipmentFilter;

  if (!visible) return;

  dom.homeEquipmentScreen.innerHTML = `
    <header class="equipment-title">
      <b>장비</b>
      <span>장착 ${equippedItems.length}/${HOME_EQUIPMENT_SLOT_SPECS.length}</span>
      <em>보유 ${ownedCatalog.length}/${catalog.length}</em>
      <button class="home-panel-close-button" type="button" data-close-home-tab-panel aria-label="장비 닫기">×</button>
    </header>
    <section class="home-equipment-main" aria-label="장비 장착">
      <div class="equipment-paper-doll-panel">
        <div class="equipment-slot-rail">
          ${HOME_EQUIPMENT_SLOT_SPECS.slice(0, 3).map(slot => renderEquipmentSlotButton(scene, state, slot, selected)).join('')}
        </div>
        <div class="equipment-avatar-stage" aria-hidden="true">
          <i></i>
          <b>수호자</b>
        </div>
        <div class="equipment-slot-rail">
          ${HOME_EQUIPMENT_SLOT_SPECS.slice(3).map(slot => renderEquipmentSlotButton(scene, state, slot, selected)).join('')}
        </div>
      </div>
      ${renderEquipmentStatSummary(selected, totals)}
    </section>
    <nav class="home-equipment-filters" aria-label="장비 분류">
      ${HOME_EQUIPMENT_FILTERS.map(filter => renderEquipmentFilterButton(filter, catalog)).join('')}
    </nav>
    <section class="equipment-inventory-panel" aria-label="장비 목록">
      <header class="equipment-inventory-head">
        <b>장비 목록</b>
        <span>${escapeHtml(homeEquipmentFilterLabel(activeEquipmentFilter))} ${filteredCatalog.length}/${ownedCatalog.length}</span>
      </header>
      <div class="equipment-grid" role="list">
        ${filteredCatalog.map(item => renderEquipmentItemCard(state, item, selected)).join('') || renderEquipmentEmptyState()}
      </div>
    </section>
  `;
  document.documentElement.dataset.homeEquipmentEmptySlotIconCount = String(
    dom.homeEquipmentScreen.querySelectorAll('.equipment-slot.is-empty .equipment-empty-icon').length,
  );
}

function getHomeEquipmentCatalog(scene) {
  const items = [...(scene?.store?.items?.values?.() || [])]
    .filter(isHomeEquipmentItem)
    .map(item => ({ ...item, slotKey: homeEquipmentSlotKeyForItem(item) }))
    .filter(item => item.slotKey);
  const order = new Map(HOME_EQUIPMENT_SLOT_SPECS.map((slot, index) => [slot.key, index]));
  return items.sort((a, b) => {
    const slotDiff = (order.get(a.slotKey) ?? 99) - (order.get(b.slotKey) ?? 99);
    return slotDiff || Number(a.id || 0) - Number(b.id || 0);
  });
}

function getStarterShopEquipmentItem(scene, state) {
  const catalog = getHomeEquipmentCatalog(scene);
  const ownedIds = getHomeEquipmentOwnedIdSet(state);
  return catalog.find(item => !ownedIds.has(String(item.id))) || catalog[0] || null;
}

function getHomeEquipmentOwnedCatalog(catalog, state) {
  const ownedIds = getHomeEquipmentOwnedIdSet(state);
  return catalog.filter(item => ownedIds.has(String(item.id)));
}

function getHomeEquipmentOwnedIdSet(state) {
  return new Set([
    ...Object.keys(normalizeItemInventory(state?.itemInventory)),
    ...Object.values(normalizeEquippedItemIds(state?.equippedItemIds)).map(String),
  ]);
}

function getHomeEquipmentOwnedCount(state, item) {
  const id = normalizeEquipmentItemId(item?.id);
  if (!id) return 0;
  const inventoryCount = Number(normalizeItemInventory(state?.itemInventory)[String(id)] || 0);
  const equippedCount = Object.values(normalizeEquippedItemIds(state?.equippedItemIds))
    .some(itemId => Number(itemId) === id) ? 1 : 0;
  return Math.max(inventoryCount, equippedCount);
}

function isHomeEquipmentOwned(state, item) {
  return getHomeEquipmentOwnedCount(state, item) > 0;
}

function isHomeEquipmentItem(item) {
  const category = String(item?.category || item?.Category || '').toLowerCase();
  if (category !== 'weapon' && category !== 'equipment') return false;
  return Boolean(homeEquipmentSlotKeyForItem(item));
}

function homeEquipmentSlotKeyForItem(item) {
  const category = String(item?.category || item?.Category || '').toLowerCase();
  const type = String(item?.type || item?.Type || '').toLowerCase();
  if (category === 'weapon') return 'weapon';
  return HOME_EQUIPMENT_SLOT_SPECS.find(slot => slot.types.some(slotType => slotType.toLowerCase() === type))?.key || '';
}

function getFilteredHomeEquipmentCatalog(catalog) {
  const filter = HOME_EQUIPMENT_SLOT_KEYS.has(activeEquipmentFilter) ? activeEquipmentFilter : 'all';
  activeEquipmentFilter = filter;
  return filter === 'all'
    ? catalog
    : catalog.filter(item => item.slotKey === filter);
}

function resolveSelectedHomeEquipment(state, catalog, filteredCatalog = catalog) {
  const selectedId = normalizeEquipmentItemId(state.selectedEquipmentItemId);
  let selected = catalog.find(item => Number(item.id) === selectedId) || null;
  if (!selected || (activeEquipmentFilter !== 'all' && selected.slotKey !== activeEquipmentFilter)) {
    selected = filteredCatalog[0] || catalog[0] || null;
  }
  state.selectedEquipmentItemId = selected ? Number(selected.id) : 0;
  return selected;
}

function getEquippedHomeEquipmentItems(scene, state) {
  const equipped = normalizeEquippedItemIds(state.equippedItemIds);
  return HOME_EQUIPMENT_SLOT_SPECS
    .map(slot => scene?.store?.getItem?.(equipped[slot.key]))
    .filter(Boolean)
    .map(item => ({ ...item, slotKey: homeEquipmentSlotKeyForItem(item) }));
}

function renderEquipmentSlotButton(scene, state, slot, selected) {
  const itemId = normalizeEquipmentItemId(state.equippedItemIds?.[slot.key]);
  const item = itemId ? scene?.store?.getItem?.(itemId) : null;
  const level = item ? homeEquipmentItemLevel(item, state) : 0;
  const icon = item ? homeEquipmentIconHtml(item, 'equipment-slot-img') : homeEquipmentEmptyIconHtml(slot);
  const selectedClass = item && selected && Number(item.id) === Number(selected.id) ? ' is-selected' : '';
  const rarityClass = item ? ` rarity-${homeEquipmentRarity(item)}` : '';
  return `
    <button
      class="equipment-slot ${item ? 'is-equipped' : 'is-empty'}${selectedClass}${rarityClass}"
      type="button"
      data-equipment-slot="${escapeHtml(slot.key)}"
      data-equipment-item-id="${item ? Number(item.id) : ''}"
      aria-label="${escapeHtml(item ? `${slot.label} ${item.name} Lv.${level}` : `${slot.label} 비어 있음`)}"
    >
      <span class="equipment-slot-label">${escapeHtml(slot.label)}</span>
      <span class="equipment-slot-art">${icon}</span>
      <small>${item ? `Lv.${level}` : ''}</small>
    </button>
  `;
}

function renderEquipmentStatSummary(selected, totals) {
  const rows = HOME_EQUIPMENT_STAT_ORDER
    .filter(key => Number(totals.stats[key] || 0) > 0)
    .slice(0, 4);
  while (rows.length < 4) rows.push(['Attack', 'Hp', 'CriticalPercent', 'BossDamageEfficiencyPercent'][rows.length]);
  const selectedSlot = selected ? HOME_EQUIPMENT_SLOT_SPECS.find(slot => slot.key === selected.slotKey) : null;
  return `
    <aside class="equipment-stat-summary" aria-label="장비 스탯">
      <div class="equipment-power">
        <span>전투력</span>
        <b>${escapeHtml(formatNumber(totals.power))}</b>
      </div>
      ${rows.map(key => `
        <div class="equipment-stat-row">
          <span>${escapeHtml(HOME_EQUIPMENT_STAT_LABELS[key] || key)}</span>
          <b>${escapeHtml(formatEquipmentStatValue(key, totals.stats[key] || 0))}</b>
        </div>
      `).join('')}
      <div class="equipment-selected-summary">
        <span>${escapeHtml(selectedSlot?.label || '선택')}</span>
        <b>${escapeHtml(selected?.name || '장비 없음')}</b>
      </div>
      <button class="equipment-primary-action" type="button" data-equipment-action="equip" ${selected ? '' : 'disabled'}>장착</button>
    </aside>
  `;
}

function renderEquipmentFilterButton(filter, catalog) {
  const active = activeEquipmentFilter === filter.key;
  const iconSrc = filter.iconSrc || homeEquipmentFilterIconSrc(filter, catalog);
  const icon = iconSrc
    ? `<img src="${escapeHtml(iconSrc)}" alt="" loading="eager" decoding="async">`
    : `<span>${escapeHtml(filter.label.slice(0, 1))}</span>`;
  return `
    <button
      class="equipment-filter${active ? ' is-active' : ''}"
      type="button"
      data-equipment-filter="${escapeHtml(filter.key)}"
      aria-pressed="${active ? 'true' : 'false'}"
      aria-label="${escapeHtml(filter.label)}"
    >${icon}</button>
  `;
}

function homeEquipmentFilterIconSrc(filter, catalog) {
  const representative = catalog.find(item => item.slotKey === filter.slotKey);
  return representative ? homeEquipmentIconSrc(representative) : HOME_UI_ICON_PATHS.equipment;
}

function renderEquipmentItemCard(state, item, selected) {
  const id = Number(item.id || 0);
  const slot = HOME_EQUIPMENT_SLOT_SPECS.find(spec => spec.key === item.slotKey);
  const level = homeEquipmentItemLevel(item, state);
  const equipped = Object.values(state.equippedItemIds || {}).some(itemId => Number(itemId) === id);
  const selectedClass = selected && Number(selected.id) === id ? ' is-selected' : '';
  const ownedCount = getHomeEquipmentOwnedCount(state, item);
  const countSuffix = ownedCount > 1 ? ` x${ownedCount}` : '';
  return `
    <button
      class="equipment-card rarity-${homeEquipmentRarity(item)}${equipped ? ' is-equipped' : ''}${selectedClass}"
      type="button"
      data-equipment-item-id="${id}"
      role="listitem"
      aria-pressed="${selectedClass ? 'true' : 'false'}"
      aria-label="${escapeHtml(`${item.name} ${slot?.label || '장비'} Lv.${level} 보유 ${ownedCount}`)}"
    >
      <em>${escapeHtml(slot?.label || '장비')}</em>
      <span class="equipment-card-art">${homeEquipmentIconHtml(item, 'equipment-card-img')}</span>
      <small>Lv.${level}${countSuffix}</small>
    </button>
  `;
}

function renderEquipmentEmptyState() {
  const filterLabel = homeEquipmentFilterLabel(activeEquipmentFilter);
  const filtered = activeEquipmentFilter !== 'all';
  const title = filtered ? `${filterLabel} 장비 없음` : '장비가 없습니다';
  const body = filtered ? '다른 분류를 선택하거나 탐험 보상을 확인하세요' : '탐험 보상으로 장비를 획득하세요';
  return `
    <div class="home-build-empty equipment-empty-state" role="status" aria-live="polite">
      <i aria-hidden="true">!</i>
      <b>${escapeHtml(title)}</b>
      <span>${escapeHtml(body)}</span>
    </div>
  `;
}

function renderHomeEquipmentDetailModal(scene, state) {
  if (!dom.homeEquipmentDetailModal) return;
  const catalog = getHomeEquipmentCatalog(scene);
  const detailId = normalizeEquipmentItemId(homeEquipmentDetailItemId);
  const item = detailId ? catalog.find(candidate => Number(candidate.id) === detailId) : null;
  const visible = activeHomeTab === 'equipment' && Boolean(item);

  dom.homeEquipmentDetailModal.hidden = !visible;
  dom.homeEquipmentDetailModal.setAttribute('aria-hidden', visible ? 'false' : 'true');
  document.documentElement.dataset.homeEquipmentDetailOpen = visible ? 'true' : 'false';
  document.documentElement.dataset.homeEquipmentDetailItemId = visible ? String(item.id) : '';

  if (!visible) {
    if (detailId && !item) homeEquipmentDetailItemId = 0;
    return;
  }

  state.selectedEquipmentItemId = Number(item.id);
  const slot = HOME_EQUIPMENT_SLOT_SPECS.find(spec => spec.key === item.slotKey);
  const owned = isHomeEquipmentOwned(state, item);
  const equipped = isHomeEquipmentEquipped(state, item);
  const detailRows = getHomeEquipmentDetailStatRows(scene, state, item);
  const rarityLabel = homeEquipmentRarityLabel(item);

  if (dom.homeEquipmentDetailKicker) {
    dom.homeEquipmentDetailKicker.textContent = `${slot?.label || '장비'} · ${rarityLabel}`;
  }
  if (dom.homeEquipmentDetailTitle) {
    dom.homeEquipmentDetailTitle.textContent = item.name || '장비';
  }
  if (dom.homeEquipmentDetailBody) {
    dom.homeEquipmentDetailBody.innerHTML = renderEquipmentDetailBody(scene, state, item, {
      slot,
      owned,
      equipped,
      rows: detailRows,
      rarityLabel,
    });
  }

  const equipButton = dom.homeEquipmentDetailFooter?.querySelector('[data-equipment-detail-action="equip"]');
  if (equipButton) {
    equipButton.disabled = !owned || equipped;
    equipButton.textContent = equipped ? '장착 중' : (owned ? '장착하기' : '미보유');
  }
}

function renderEquipmentDetailBody(scene, state, item, detail = {}) {
  const level = homeEquipmentItemLevel(item, state);
  const maxLevel = Math.max(1, (item?.requiredExps || item?.RequiredExps || []).length || 20);
  const levelWidth = clamp(level / maxLevel * 100, 6, 100);
  const slot = detail.slot || HOME_EQUIPMENT_SLOT_SPECS.find(spec => spec.key === item.slotKey);
  const ownedCount = getHomeEquipmentOwnedCount(state, item);
  const stateLabel = detail.equipped ? '장착 중' : (detail.owned ? '보유' : '미보유');
  const description = homeEquipmentDescription(item, slot, detail.rows || []);
  const stats = (detail.rows || []).slice(0, 4);
  const statRows = stats.length
    ? stats.map(row => renderEquipmentDetailStatRow(row)).join('')
    : `<div class="equipment-detail-stat"><i aria-hidden="true">P</i><span>전투력</span><b>${escapeHtml(formatNumber(item.power || item.Power || 0))}</b></div>`;

  return `
    <section class="equipment-detail-hero">
      <div class="equipment-detail-icon rarity-${homeEquipmentRarity(item)}" aria-hidden="true">
        ${homeEquipmentIconHtml(item, 'equipment-detail-img')}
      </div>
      <div class="equipment-detail-title">
        <div class="equipment-detail-name-row">
          <b>${escapeHtml(item.name || '장비')}</b>
          <span class="equipment-detail-rarity">${escapeHtml(detail.rarityLabel || homeEquipmentRarityLabel(item))}</span>
        </div>
        <div class="equipment-detail-level">
          <span>Lv.${escapeHtml(String(level))} / ${escapeHtml(String(maxLevel))}</span>
          <div class="equipment-detail-level-track" aria-hidden="true" style="--equipment-detail-level-width: ${levelWidth.toFixed(0)}%"><i></i></div>
        </div>
        <div class="equipment-detail-stats">
          ${statRows}
        </div>
      </div>
    </section>
    <section class="equipment-detail-description">
      ${escapeHtml(description)}
    </section>
    <section class="equipment-detail-meta" aria-label="장비 상태">
      <div class="equipment-detail-chip"><span>보유 수</span><b>${escapeHtml(String(ownedCount))}</b></div>
      <div class="equipment-detail-chip"><span>착용 부위</span><b>${escapeHtml(slot?.label || '장비')}</b></div>
      <div class="equipment-detail-chip"><span>상태</span><b>${escapeHtml(stateLabel)}</b></div>
    </section>
  `;
}

function renderEquipmentDetailStatRow(row) {
  const delta = Number(row.delta || 0);
  const deltaCopy = Math.abs(delta) >= 0.01
    ? `<em class="${delta < 0 ? 'is-down' : 'is-up'}">${delta > 0 ? '▲ +' : '▼ -'}${escapeHtml(formatEquipmentStatValue(row.key, Math.abs(delta)))}</em>`
    : '';
  return `
    <div class="equipment-detail-stat">
      <i aria-hidden="true">${escapeHtml(row.icon)}</i>
      <span>${escapeHtml(row.label)}</span>
      <b>${escapeHtml(formatEquipmentStatValue(row.key, row.value))}${deltaCopy}</b>
    </div>
  `;
}

function getHomeEquipmentDetailStatRows(scene, state, item) {
  const itemStats = getHomeEquipmentItemStatMap(item, state);
  const equipped = normalizeEquippedItemIds(state?.equippedItemIds);
  const equippedItemId = normalizeEquipmentItemId(equipped[item.slotKey]);
  const equippedItem = equippedItemId ? scene?.store?.getItem?.(equippedItemId) : null;
  const equippedStats = equippedItem && Number(equippedItem.id) !== Number(item.id)
    ? getHomeEquipmentItemStatMap({ ...equippedItem, slotKey: homeEquipmentSlotKeyForItem(equippedItem) }, state)
    : {};
  const keys = Object.keys(itemStats).sort((a, b) => {
    const orderA = HOME_EQUIPMENT_STAT_ORDER.indexOf(a);
    const orderB = HOME_EQUIPMENT_STAT_ORDER.indexOf(b);
    return (orderA < 0 ? 99 : orderA) - (orderB < 0 ? 99 : orderB);
  });
  return keys.map(key => ({
    key,
    label: HOME_EQUIPMENT_STAT_LABELS[key] || key,
    value: itemStats[key],
    delta: Number(itemStats[key] || 0) - Number(equippedStats[key] || 0),
    icon: homeEquipmentStatIcon(key),
  }));
}

function getHomeEquipmentItemStatMap(item, state) {
  const level = homeEquipmentItemLevel(item, state);
  const map = {};
  for (const stat of item?.equipAddStats || item?.addStats || []) {
    const key = stat.type || stat.Type;
    if (!key) continue;
    map[key] = Number(map[key] || 0) + Number(pickLevelValue(stat.value || stat.Value, level, 0) || 0);
  }
  if (!Object.keys(map).length && Number(item?.power || item?.Power || 0) > 0) {
    map.Power = Number(item.power || item.Power || 0);
  }
  return map;
}

function isHomeEquipmentEquipped(state, item) {
  const id = normalizeEquipmentItemId(item?.id);
  return Object.values(normalizeEquippedItemIds(state?.equippedItemIds))
    .some(itemId => Number(itemId) === id);
}

function homeEquipmentRarityLabel(item) {
  return ['일반', '고급', '희귀', '영웅', '전설'][homeEquipmentRarity(item) - 1] || '장비';
}

function homeEquipmentStatIcon(key) {
  const icons = {
    Attack: '검',
    AttackPercent: '검',
    Hp: '♥',
    HpPercent: '♥',
    Defense: '방',
    DefensePercent: '방',
    CriticalPercent: '★',
    CriticalDamagePercent: '★',
    BossDamageEfficiencyPercent: '보',
    DamageTakenEfficiencyPercent: '↓',
    AttackSpeedPercent: '속',
    MoveSpeed: '발',
    Power: 'P',
  };
  return icons[key] || '•';
}

function homeEquipmentDescription(item, slot, rows = []) {
  const direct = item?.description || item?.Description || item?.desc || item?.Desc || item?.flavor || item?.Flavor || item?.summary || item?.Summary;
  if (direct) return String(direct);
  const primary = rows[0]?.label || '전투력';
  const slotLabel = slot?.label || '장비';
  return `${slotLabel} 슬롯에 장착하는 ${item?.name || '장비'}입니다. ${primary}을 보강해 탐험 전투를 더 안정적으로 만듭니다.`;
}

function homeEquipmentIconHtml(item, className) {
  const src = homeEquipmentIconSrc(item);
  if (src) return `<img class="${escapeHtml(className)}" src="${escapeHtml(src)}" alt="" loading="lazy" decoding="async">`;
  const slot = HOME_EQUIPMENT_SLOT_SPECS.find(spec => spec.key === item?.slotKey);
  return homeEquipmentEmptyIconHtml(slot, `${className} equipment-empty-icon`);
}

function homeEquipmentIconSrc(item) {
  const iconPath = item?.spriteGroups?.Icon || item?.Icon || item?.icon || item?.sprite || item?.Sprite;
  return assetUrlFromSpritePath(iconPath);
}

function homeEquipmentEmptyIconHtml(slot, className = 'equipment-empty-icon') {
  const iconKey = slot?.emptyIcon || slot?.key || '';
  const src = HOME_EQUIPMENT_EMPTY_SLOT_ICON_PATHS[iconKey];
  if (!src) return '<span class="equipment-empty-mark" aria-hidden="true"></span>';
  return `<img class="${escapeHtml(className)}" src="${escapeHtml(src)}" alt="" loading="lazy" decoding="async">`;
}

function homeEquipmentRarity(item) {
  return clamp(Math.floor(Number(item?.rarity || item?.Rarity || item?.grade || item?.Grade || 1)), 1, 5);
}

function homeEquipmentItemLevel(item, state) {
  const id = normalizeEquipmentItemId(item?.id);
  const levels = state?.equipmentLevels || state?.itemLevels || {};
  return clamp(Math.floor(Number(levels[String(id)] || levels[id] || 1)), 1, 20);
}

function getHomeEquipmentStatTotals(items, state) {
  const stats = {};
  let power = 0;
  for (const item of items) {
    const level = homeEquipmentItemLevel(item, state);
    power += Math.floor(Number(item.power || item.Power || 0) * (1 + (level - 1) * 0.08));
    for (const stat of item.equipAddStats || item.addStats || []) {
      const key = stat.type || stat.Type;
      if (!key) continue;
      stats[key] = Number(stats[key] || 0) + pickLevelValue(stat.value || stat.Value, level, 0);
    }
  }
  if (!power && stats.Attack) power = Math.round(Number(stats.Attack || 0) * 9);
  return { power, stats };
}

function formatEquipmentStatValue(statKey, value) {
  const safe = Number(value || 0);
  if (statKey.endsWith('Percent') || statKey.includes('EfficiencyPercent')) {
    return `${safe.toFixed(safe < 10 && safe % 1 ? 1 : 0).replace(/\.0$/, '')}%`;
  }
  return formatNumber(safe);
}

function homeEquipmentFilterLabel(filterKey) {
  return HOME_EQUIPMENT_FILTERS.find(filter => filter.key === filterKey)?.label || '전체';
}

function getHomeBuildListBuildings(state) {
  return getHomeBuildCandidateBuildings(state);
}

function getHomeBuildCandidateBuildings(state) {
  return BUILDINGS
    .filter(building => canBuildAnotherBuilding(state, building))
    .filter(building => isBuildingUnlocked(state, building))
    .filter(building => isBuildingVisible(state, building) || Boolean(getPendingBuildingPlacement(state, building)));
}

function getHomeBuiltBuildingEntries(state) {
  const order = new Map(BUILDINGS.map((building, index) => [building.key, index]));
  return getAllBuildingInstances(state)
    .map(instance => {
      const building = BUILDING_BY_KEY.get(instance.buildingKey);
      return building ? { building, instance } : null;
    })
    .filter(Boolean)
    .sort((a, b) => {
      const orderDiff = (order.get(a.building.key) ?? 999) - (order.get(b.building.key) ?? 999);
      return orderDiff || getBuildingInstanceOrdinal(a.instance) - getBuildingInstanceOrdinal(b.instance);
    });
}

function renderHomeBuildList(state) {
  if (!dom.homeBuildList) return;
  const buildings = getHomeBuildListBuildings(state);
  const builtEntries = getHomeBuiltBuildingEntries(state);
  const open = isHomeBuildTrayOpen(state);
  if (dom.homeBuildModal) {
    dom.homeBuildModal.hidden = !open;
    dom.homeBuildModal.setAttribute('aria-hidden', open ? 'false' : 'true');
  }
  dom.homeBuildList.hidden = false;
  dom.homeBuildList.innerHTML = `
    <section class="home-build-section home-build-candidate-section" aria-label="건설 후보">
      <header class="home-build-section-head">
        <b>건설 후보</b>
        <span>${buildings.length}개</span>
      </header>
      <div class="home-build-cards">
        ${buildings.length
          ? buildings.map(building => renderHomeBuildListCard(state, building)).join('')
          : renderHomeBuildListEmpty(state)}
      </div>
    </section>
    <section class="home-build-section home-built-section" aria-label="보유 건물">
      <header class="home-build-section-head">
        <b>보유 건물</b>
        <span>${builtEntries.length}개</span>
      </header>
      <div class="home-built-list">
        ${builtEntries.length
          ? builtEntries.map(entry => renderHomeBuiltBuildingCard(state, entry)).join('')
          : renderHomeBuiltListEmpty()}
      </div>
    </section>
  `;
}

function renderHomeBuildListEmpty(state) {
  const shrineLevel = Math.max(1, Number(state?.shrineLevel) || 1);
  const stageClears = Math.max(0, Number(state?.stageClears) || 0);
  return `
    <div class="home-build-empty" role="status" aria-live="polite">
      <i aria-hidden="true">!</i>
      <b>건설 후보가 없습니다</b>
      <span>성소 Lv.${shrineLevel} · 탐험 클리어 ${stageClears}회</span>
    </div>
  `;
}

function renderHomeBuiltListEmpty() {
  return `
    <div class="home-built-empty" role="status">
      <b>아직 지어진 건물이 없습니다</b>
    </div>
  `;
}

function renderHomeBuiltBuildingCard(state, { building, instance }) {
  const level = getInstanceBuildingLevel(state, building, instance);
  const status = instance.status === 'constructing' ? '건설 중' : '완료';
  const timer = instance.status === 'constructing'
    ? formatRemainingSeconds(getConstructionRemaining(state, building, instance))
    : '';
  const stats = formatEffectStats(getLevelData(building, level)?.effect || {}).slice(0, 3);
  const title = formatBuildingInstanceName(building, instance);
  return `
    <article class="home-built-card is-${escapeHtml(instance.status || 'built')}" data-owned-building="true" data-building-key="${escapeHtml(building.key)}" data-building-instance-id="${escapeHtml(instance?.id || '')}">
      <div class="home-built-card-art" aria-hidden="true">
        ${renderHomeBuildingBadgeIcon(building, 'home-built-card-icon')}
        ${renderBuildingCatalogImage(building)}
      </div>
      <div class="home-built-card-copy">
        <b>${escapeHtml(title)}</b>
        <div class="home-built-card-meta">
          <span>Lv.${level}</span>
          <span>${escapeHtml(status)}</span>
          ${timer ? `<span>${escapeHtml(timer)}</span>` : ''}
        </div>
        <div class="home-built-card-stats">
          ${stats.map(stat => `<em>${escapeHtml(stat)}</em>`).join('')}
        </div>
      </div>
    </article>
  `;
}

function renderHomeBuildListCard(state, building) {
  const status = getBuildingStatus(state, building, null);
  const selected = state.buildPlanBuildingKey === building.key;
  const locked = status === 'locked-slot' && !isBuildingUnlocked(state, building);
  const constructing = false;
  const detail = formatBuildListDetail(state, building, status);
  const description = formatBuildingPurpose(building);
  const label = `${building.name}. ${description} ${detail}`;
  const construction = getConstructionForNextInstance(state, building);
  const effectStats = formatEffectStats(getLevelData(building, 1)?.effect || {}).slice(0, 3);
  const canAfford = canAffordCost(state, construction.cost);
  return `
    <button
      class="home-build-card is-${status}${selected ? ' is-selected' : ''}${locked ? ' is-locked' : ''}${canAfford ? ' is-affordable' : ' is-missing-resources'}"
      type="button"
      data-select-build-building="${building.key}"
      ${constructing ? 'disabled' : ''}
      aria-pressed="${selected ? 'true' : 'false'}"
      aria-label="${escapeHtml(label)}"
    >
      <div class="home-build-card-art" aria-hidden="true">
        ${renderHomeBuildingBadgeIcon(building, 'home-build-card-icon')}
        ${renderBuildingCatalogImage(building)}
      </div>
      <div class="home-build-card-copy">
        <b>${escapeHtml(building.name)}</b>
        <span class="home-build-card-desc">${escapeHtml(description)}</span>
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

function formatBuildingPurpose(building) {
  if (building?.purpose) return building.purpose;
  if (building?.output) return `${building.output} 성장을 담당하는 성소 건물입니다.`;
  return '성소 성장에 필요한 건물입니다.';
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
        ${renderResourceCostIcon(key, resource.icon)}
        <b>${escapeHtml(formatNumber(value))}</b>
      </span>
    `;
  }).join('');
}

function getBuildCardActionCopy(state, building, status) {
  if (status === 'constructing') return formatRemainingSeconds(getConstructionRemaining(state, building));
  if (status === 'buildable' || status === 'needs-placement') return canAffordCost(state, getConstructionForNextInstance(state, building).cost) ? '선택' : '부족';
  if (status === 'locked-slot') return isBuildingUnlocked(state, building) ? '터 필요' : '잠금';
  if (!isBuildingUnlocked(state, building)) return '잠금';
  return '확인';
}

function formatBuildListDetail(state, building, status) {
  if (status === 'buildable') return getPendingBuildingPlacement(state, building)
    ? '터 선택됨'
    : '빈 터';
  if (status === 'needs-placement') return '터 선택';
  if (isBuildingUnlocked(state, building) && getPendingBuildingPlacement(state, building)) return '터 확인';
  return formatUnlockShort(building);
}

function formatDashCooldownLabel(cooldownRemainingMs) {
  if (cooldownRemainingMs <= 0) return '';
  const seconds = cooldownRemainingMs / 1000;
  return seconds > 2 ? Math.ceil(seconds).toString() : seconds.toFixed(1);
}

function renderDashControl(scene) {
  if (!dom.companionSkillDock) return;
  ensureDashControlButton();
  const now = performance.now();
  const active = Boolean(scene?.playerDashState);
  const cooldownRemaining = Math.max(0, Number(scene?.playerDashReadyAt || 0) - now);
  const unavailable = scene?.mode !== 'expedition'
    || scene?.paused
    || scene?.levelChoiceOpen
    || scene?.board?.gameEnded
    || !scene?.board?.playerUnit?.alive;
  const ready = !unavailable && !active && cooldownRemaining <= 0;
  const progress = ready ? 1 : clamp(1 - cooldownRemaining / PLAYER_DASH_COOLDOWN_MS, 0, 1);
  const label = formatDashCooldownLabel(cooldownRemaining);
  const button = dom.companionSkillDock.querySelector('[data-dash-control]');
  if (!button) return;
  button.classList.toggle('is-ready', ready);
  button.classList.toggle('is-cooling', !ready && cooldownRemaining > 0);
  button.classList.toggle('is-active', active);
  button.classList.toggle('is-unavailable', unavailable);
  button.disabled = unavailable;
  button.style.setProperty('--dash-angle', `${(progress * 360).toFixed(1)}deg`);
  const cooldownText = button.querySelector('.dash-control-cooldown');
  if (cooldownText) {
    cooldownText.textContent = label;
    cooldownText.hidden = !label;
  }

  const root = document.documentElement;
  root.dataset.survivorCompanionSkillCount = '0';
  root.dataset.survivorCompanionReadyCount = '0';
  root.dataset.survivorCompanionRoster = D1_COMPANIONS
    .map(companion => `${companion.key}:${getCompanionRosterStatus(scene?.sanctuary, companion)}`)
    .join(',');
  root.dataset.survivorDashControlReady = String(ready);
  root.dataset.survivorDashControlActive = String(active);
  root.dataset.survivorDashControlCooldownText = label;
  root.dataset.survivorDashControlProgress = progress.toFixed(3);
  root.dataset.survivorDashControlCompanionsHidden = 'true';
}

function ensureDashControlButton() {
  dom.companionSkillDock.classList.remove('companion-skill-dock');
  dom.companionSkillDock.classList.add('battle-dash-dock');
  dom.companionSkillDock.setAttribute('aria-label', '대시');
  if (dom.companionSkillDock.dataset.dashButtonReady === 'true') return;
  dom.companionSkillDock.dataset.dashButtonReady = 'true';
  dom.companionSkillDock.innerHTML = `
    <button
      class="dash-control-button is-ready"
      type="button"
      data-dash-control
      style="--dash-angle:360deg"
      aria-label="대시"
    >
      <span class="dash-control-icon" aria-hidden="true"></span>
      <span class="dash-control-cooldown" aria-hidden="true" hidden></span>
    </button>
  `;
  document.documentElement.dataset.survivorDashControlIconReady = 'true';
}

function renderHex(tile, state) {
  const placementPreview = getHomePlacementPreview(state);
  const entry = getVisibleBuildingEntryForTile(tile, state);
  const building = entry?.building || null;
  const instance = entry?.instance || null;
  const buildingKey = building?.key || null;
  const buildingStatus = building ? getBuildingStatus(state, building, instance) : null;
  const tileState = getTileRenderState(tile, state);
  const tileLevelLocked = !isTileLevelUnlocked(state, tile);
  const plannedBuilding = getHomeBuildPlanBuilding(state);
  const placementCandidate = !buildingKey && plannedBuilding && isPlacementCandidateTile(state, tile);
  const placementFootprint = placementPreview?.tiles?.includes(tile.id);
  const placementAnchor = placementPreview?.anchorTileId === tile.id;
  const stateClass = buildingKey
    ? `building-slot ${buildingStatus}${buildingStatus === 'built' ? ' built occupied' : ''}`
    : tileState;
  const selected = buildingKey
    ? state.selectedBuildingInstanceId === instance?.id || (!state.selectedBuildingInstanceId && state.selectedBuildingKey === buildingKey)
    : tile.selected;
  const buildingClass = building ? ` occupied-${building.kind} occupied-${buildingKey}` : '';
  const placementClass = placementCandidate ? ' placement-candidate' : '';
  const placementPreviewClass = placementFootprint
    ? ` placement-footprint ${placementPreview.valid ? 'placement-valid' : 'placement-invalid'}${placementAnchor ? ' placement-anchor' : ''}`
    : '';
  const railClass = !buildingKey && tileState === 'expand' && tile.q <= -2 ? ' rail-adjacent' : '';
  const style = `--q:${tile.q};--r:${tile.r}`;
  let content = '';
  if (buildingKey && buildingStatus === 'built') {
    content = '';
  } else if (buildingKey && buildingStatus === 'constructing') {
    content = `<div class="hex-cost">${formatRemainingSeconds(getConstructionRemaining(state, building, instance))}</div>`;
  } else if (buildingKey && buildingStatus === 'buildable') {
    content = '';
  } else if (buildingKey) {
    content = buildingStatus === 'locked-slot' ? renderHexLockIcon() : '';
  } else if (stateClass === 'expand') {
    content = `<div class="hex-cost">${tile.cost}</div>`;
  } else if (tileState === 'locked') {
    content = `${renderHexLockIcon()}${renderUnpurifiedTileCost(tile)}`;
  } else if (tileState === 'fog') {
    content = `${tileLevelLocked ? renderHexLockIcon() : ''}${renderUnpurifiedTileCost(tile)}`;
  } else if (placementCandidate) {
    content = !placementPreview || placementAnchor
      ? `<div class="hex-placement-marker" aria-hidden="true">${escapeHtml(buildingBlueprintGlyph(plannedBuilding))}</div>`
      : '';
  } else if (tileState === 'empty') {
    content = '';
  }
  const data = ` data-tile-id="${tile.id}"` + (buildingKey
    ? ` data-building-key="${buildingKey}" data-building-instance-id="${instance?.id || ''}"`
    : '');
  return `<div class="home-hex ${stateClass}${buildingClass}${placementClass}${placementPreviewClass}${railClass}${selected ? ' selected' : ''}" style="${style}"${data}>${content}</div>`;
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
      const status = getBuildingStatus(state, building, entry.instance);
      const constructionProgress = status === 'constructing'
        ? getConstructionProgress(state, building, entry.instance)
        : 0;
      const productionSnapshot = getBuildingProductionSnapshot(state, building, level, entry.instance);
      const collectBadge = renderBuildingCollectBadge(productionSnapshot);
      const output = formatBuildingBubble(state, building, level, entry.instance);
      const selected = state.selectedBuildingInstanceId === entry.instance?.id;
      const isImageReady = status === 'built'
        && ['existing', 'generated'].includes(building.assetStatus)
        && hasHomeBuildingSprite(building);
      const image = status === 'constructing'
        ? renderHomeConstructionSprite()
        : isImageReady
          ? renderHomeBuildingSprite(building)
          : '';
      const blueprint = image
        ? ''
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
          ? `${Math.round(constructionProgress * 100)}%`
          : status === 'buildable'
            ? formatPrimaryCost(building.construction?.cost)
            : formatUnlockShort(building);
      const style = `--x:${x.toFixed(1)}px;--y:${y.toFixed(1)}px;--w:${w}px;--h:${h}px;--z:${Math.round(220 + y)}`;
      const collectableClass = collectBadge ? ' has-collectable' : '';
      const collectableData = productionSnapshot.hasProduction
        ? ` data-production-resource="${escapeHtml(productionSnapshot.stateKey)}" data-collectable-amount="${productionSnapshot.collectable}"`
        : '';
      return `
        <div class="home-building home-building-${building.kind} is-${status}${selected ? ' selected' : ''}${collectableClass}" style="${style}" data-building-key="${building.key}" data-building-instance-id="${entry.instance?.id || ''}" data-footprint="${building.footprint}"${collectableData} aria-label="${formatBuildingInstanceName(building, entry.instance)} ${building.footprint}">
          ${image}
          ${blueprint}
          <b>${badge}</b>
          ${collectBadge || `<div class="bubble" aria-label="${escapeHtml(`${building.output || building.name} ${bubble}`)}">${bubble}</div>`}
        </div>
      `;
    })
    .join('');
}

function renderBuildingCollectBadge(snapshot) {
  if (!snapshot?.hasProduction || snapshot.collectable <= 0) return '';
  const label = `${resourceName(snapshot.resourceKey)} 수집 가능 ${formatNumber(snapshot.collectable)}`;
  return `
    <div
      class="collect-badge collect-badge-${escapeHtml(snapshot.stateKey || 'none')}"
      role="status"
      aria-label="${escapeHtml(label)}"
    >
      <i aria-hidden="true"></i>
      <span>+${escapeHtml(formatHomeResourceAmount(snapshot.collectable))}</span>
    </div>
  `;
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

function formatProductionAmount(value) {
  const safe = Math.max(0, Number(value) || 0);
  if (safe <= 0) return '0';
  if (safe < 1) return safe.toFixed(1).replace(/0+$/, '').replace(/\.$/, '');
  if (safe < 10 && !Number.isInteger(safe)) return safe.toFixed(1).replace(/\.0$/, '');
  return formatNumber(Math.floor(safe));
}

function formatProductionRate(snapshot) {
  const rate = Number(snapshot?.displayRate || 0);
  if (rate <= 0) return '+0/m';
  const unit = snapshot?.production?.rateUnit === 'per_hour' ? '/h' : '/m';
  return `+${formatEffectNumber(rate)}${unit}`;
}

function formatFeatureModalLabel(building) {
  const labels = {
    town_center: '성소',
    companion_management: '용병',
    production: '생산',
    rare_production: '희귀',
    support_bonus: '지원',
    capacity: '수용',
    crafting: '제작',
    combat_bonus: '전투',
    expedition: '정찰',
    storage: '보관',
    resource_bonus: '절감',
    upgrade_gate: '해금',
  };
  return labels[building?.featureModal] || '기능';
}

function renderIntegratedCollectChip(state, building, status, level, instance = getPrimaryBuildingInstance(state, building)) {
  const snapshot = getBuildingProductionSnapshot(state, building, level, instance);
  let resourceKey = 'none';
  let label = status === 'built' ? '기능' : '생산';
  let detail = status === 'built' ? formatFeatureModalLabel(building) : '준비중';
  let stateClass = status === 'built' ? ' is-idle' : ' is-idle';

  if (snapshot.hasProduction && status === 'built') {
    resourceKey = snapshot.stateKey || 'none';
    const ready = snapshot.collectable > 0;
    label = ready ? '수집' : '생산';
    detail = ready
      ? `+${formatNumber(snapshot.collectable)}`
      : `${formatProductionAmount(snapshot.stored)} / ${formatProductionAmount(snapshot.cap)} · ${formatProductionRate(snapshot)}`;
    stateClass = ready ? ' is-ready' : ' is-auto';
  }

  const aria = snapshot.hasProduction && status === 'built'
    ? `${resourceName(snapshot.resourceKey)} 저장 ${formatProductionAmount(snapshot.stored)} / ${formatProductionAmount(snapshot.cap)}`
    : `${building?.name || '건물'} 기능 ${detail}`;
  return `
    <div
      class="panel-collect-chip panel-collect-resource-${resourceKey}${stateClass}"
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
    instance.productionStoredAmount = Math.max(0, Number(instance.productionStoredAmount || 0));
    instance.productionLastSettledAt = now;
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

function formatBuildingBubble(state, building, level, instance = getPrimaryBuildingInstance(state, building)) {
  const snapshot = getBuildingProductionSnapshot(state, building, level, instance);
  if (snapshot.hasProduction && instance?.status === 'built') {
    if (snapshot.collectable > 0) return `+${formatNumber(snapshot.collectable)}`;
    if (snapshot.ratePerMinute > 0) return formatProductionRate(snapshot);
  }
  const effect = getLevelData(building, level)?.effect || {};
  const priority = [
    ['wood_per_min', value => `+${formatEffectNumber(value)}/m`],
    ['stone_per_min', value => `+${formatEffectNumber(value)}/m`],
    ['exp_per_min', value => `+${formatEffectNumber(value)}/m`],
    ['companion_attack_percent', value => `+${formatEffectNumber(value)}%`],
    ['soulflame_per_hour', value => `+${formatEffectNumber(value)}/h`],
    ['herb_per_min', value => `+${formatEffectNumber(value)}/m`],
    ['food_per_hour', value => `+${formatEffectNumber(value)}/h`],
    ['bamboo_per_min', value => `+${formatEffectNumber(value)}/m`],
    ['iron_ore_per_hour', value => `+${formatEffectNumber(value)}/h`],
    ['boss_damage_percent', value => `+${formatEffectNumber(value)}%`],
    ['damage_taken_reduction_percent', value => `-${formatEffectNumber(value)}%`],
    ['resident_cap_bonus', value => `+${formatEffectNumber(value)}`],
    ['storage_minutes_bonus', value => `+${formatEffectNumber(value)}m`],
    ['construction_time_reduction_percent', value => `-${formatEffectNumber(value)}%`],
    ['wood_cost_reduction_percent', value => `-${formatEffectNumber(value)}%`],
    ['resource_expedition_slots', value => `+${formatEffectNumber(value)}`],
    ['item_drop_percent', value => `+${formatEffectNumber(value)}%`],
    ['light_radius', value => `R${formatEffectNumber(value)}`],
  ];
  const match = priority.find(([key]) => effect[key] != null);
  return match ? match[1](effect[match[0]]) : formatFeatureModalLabel(building);
}

function formatEffectStats(effect) {
  const labels = {
    light_radius: ['반경', ''],
    max_open_tiles: ['타일', '칸'],
    resident_cap: ['주민', '명'],
    max_building_level: ['건물Lv', ''],
    gold_per_min: ['골드', '/m'],
    gold_per_hour: ['골드', '/h'],
    wood_per_min: ['목재', '/m'],
    stone_per_min: ['석재', '/m'],
    exp_per_min: ['경험치', '/m'],
    companion_attack_percent: ['용병공격', '%'],
    attack_percent: ['공격', '%'],
    soulflame_per_hour: ['영혼불', '/h'],
    herb_per_min: ['허브', '/m'],
    recovery_percent: ['회복', '%'],
    damage_taken_reduction_percent: ['피해감소', '%'],
    resident_cap_bonus: ['주민+', '명'],
    offline_cap_hours_bonus: ['오프라인+', 'h'],
    storage_minutes_bonus: ['저장+', '분'],
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

function collectBuildingProduction(scene, building, instance) {
  const state = scene?.sanctuary;
  if (!state || !building || !instance || instance.status !== 'built') return null;
  settleBuildingProduction(state, building, instance);
  const level = getInstanceBuildingLevel(state, building, instance);
  const snapshot = getBuildingProductionSnapshot(state, building, level, instance);
  if (!snapshot.hasProduction) return null;
  if (snapshot.collectable <= 0) {
    state.lastLog = `${formatBuildingInstanceName(building, instance)}: ${resourceName(snapshot.resourceKey)} ${formatProductionAmount(snapshot.stored)} / ${formatProductionAmount(snapshot.cap)} 저장 중입니다.`;
    return null;
  }

  const amount = snapshot.collectable;
  instance.productionStoredAmount = Math.max(0, snapshot.stored - amount);
  instance.productionLastSettledAt = Date.now();
  state.placedBuildingInstances[instance.id] = instance;
  setStateResource(state, snapshot.resourceKey, getStateResource(state, snapshot.resourceKey) + amount);
  state.lastLog = `${formatBuildingInstanceName(building, instance)}에서 ${resourceName(snapshot.resourceKey)} +${formatNumber(amount)} 수집했습니다.`;
  return { key: snapshot.stateKey, resourceKey: snapshot.resourceKey, amount };
}

function activateBuilding(scene, buildingKey, instanceId = '', options = {}) {
  const building = BUILDING_BY_KEY.get(buildingKey);
  if (!scene || !building) return;
  const state = scene.sanctuary;
  const instance = instanceId
    ? state.placedBuildingInstances?.[instanceId]
    : getPrimaryBuildingInstance(state, building);
  state.selectedBuildingKey = building.key;
  state.selectedBuildingInstanceId = instance?.buildingKey === building.key ? instance.id : '';
  state.buildPlanBuildingKey = '';
  state.buildPlanPlacement = null;
  homeBuildTrayOpen = false;

  const gain = collectBuildingProduction(scene, building, instance);
  const flyGain = gain
    ? prepareHomeResourceFlyGain(gain, options.sourceElement, options.event)
    : null;
  if (!gain && !getBuildingProduction(building) && building.description && instance?.status === 'built') {
    state.lastLog = building.description;
  }

  saveSanctuary(state);
  renderHome(scene, {
    gains: gain ? { [gain.key]: gain.amount } : {},
    animateGains: Boolean(gain),
    flyGains: flyGain ? [flyGain] : [],
  });
  scene?.playSfx?.(gain ? 'reward' : 'uiClick', { volume: gain ? 0.58 : 0.38 });
}

function selectHomeTab(scene, tabKey) {
  const state = scene?.sanctuary;
  const safeTab = HOME_TAB_KEYS.has(tabKey) ? tabKey : 'sanctuary';
  activeHomeTab = safeTab;
  homeDungeonDetailOpen = false;
  activeHomeQuickView = '';
  if (safeTab !== 'equipment') homeEquipmentDetailItemId = 0;
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
  } else if (safeTab === 'exploration') {
    homeBuildTrayOpen = false;
    state.buildPlanBuildingKey = '';
    state.buildPlanPlacement = null;
    syncSideDungeonProgress(scene, state);
    const selected = getSelectedDungeonEntry(scene, state);
    state.lastLog = selected?.unlocked
      ? `${selected.name} 던전 보상: ${selected.reward}`
      : `${selected?.name || '던전'} 해금 조건: ${selected?.unlock || '메인 진행 필요'}`;
  } else if (safeTab === 'equipment') {
    homeBuildTrayOpen = false;
    state.buildPlanBuildingKey = '';
    state.buildPlanPlacement = null;
    state.lastLog = '장비 슬롯과 보유 장비를 확인하세요.';
  } else if (safeTab === 'missions') {
    homeBuildTrayOpen = false;
    state.buildPlanBuildingKey = '';
    state.buildPlanPlacement = null;
    const claimable = getHomeMissionEntries(scene, state, getHomeMissionContext(scene)).filter(entry => entry.status === 'claimable').length;
    state.lastLog = claimable ? `수령 가능한 임무 보상 ${claimable}개가 있습니다.` : '임무 진행도를 확인하세요.';
  } else if (safeTab === 'shop') {
    homeBuildTrayOpen = false;
    state.buildPlanBuildingKey = '';
    state.buildPlanPlacement = null;
    const available = getHomeShopProductEntries(scene, state, getHomeShopContext()).filter(product => !product.disabled).length;
    state.lastLog = available ? `구매 가능한 현금 상품 ${available}개가 있습니다.` : '현금 상점 상품 구성을 확인하세요.';
  } else {
    homeBuildTrayOpen = false;
    state.buildPlanBuildingKey = '';
    state.buildPlanPlacement = null;
  }

  saveSanctuary(state);
  renderHome(scene);
}

function openHomeQuickView(scene, viewKey) {
  const state = scene?.sanctuary;
  if (!HOME_QUICK_VIEW_KEYS.has(viewKey)) return;
  activeHomeQuickView = viewKey;
  if (state) {
    const meta = homeQuickViewMeta(viewKey);
    state.lastLog = `${meta.title} 패널을 열었습니다.`;
    saveSanctuary(state);
    renderHome(scene);
  } else {
    renderHomeQuickModal(scene, state);
  }
  scene?.playSfx?.('uiClick', { volume: 0.38 });
}

function closeHomeQuickView(scene) {
  activeHomeQuickView = '';
  const state = scene?.sanctuary;
  if (state) renderHome(scene);
  else renderHomeQuickModal(scene, state);
}

function openHomeEquipmentDetail(scene, itemId, options = {}) {
  const state = scene?.sanctuary;
  const safeId = normalizeEquipmentItemId(itemId);
  if (!state || !safeId) return;
  const item = scene?.store?.getItem?.(safeId);
  const slotKey = item ? homeEquipmentSlotKeyForItem(item) : '';
  if (!item || !slotKey) {
    state.lastLog = '확인할 장비를 찾을 수 없습니다.';
    saveSanctuary(state);
    renderHome(scene);
    scene?.playSfx?.('uiError', { volume: 0.42 });
    return;
  }
  activeHomeTab = 'equipment';
  if (options.focusFilter && HOME_EQUIPMENT_SLOT_KEYS.has(slotKey)) activeEquipmentFilter = slotKey;
  homeEquipmentDetailItemId = safeId;
  state.selectedEquipmentItemId = safeId;
  state.lastLog = `${item.name || '장비'} 상세 정보를 확인합니다.`;
  saveSanctuary(state);
  renderHome(scene);
  scene?.playSfx?.('uiClick', { volume: 0.36 });
}

function closeHomeEquipmentDetail(scene, options = {}) {
  homeEquipmentDetailItemId = 0;
  document.documentElement.dataset.homeEquipmentDetailOpen = 'false';
  document.documentElement.dataset.homeEquipmentDetailItemId = '';
  if (dom.homeEquipmentDetailModal) {
    dom.homeEquipmentDetailModal.hidden = true;
    dom.homeEquipmentDetailModal.setAttribute('aria-hidden', 'true');
  }
  if (options.render && scene?.sanctuary) renderHome(scene);
}

function claimHomeMail(scene, mailKey) {
  const state = scene?.sanctuary;
  if (!state) return;
  state.mailClaims = normalizeClaimMap(state.mailClaims);
  state.mailReadKeys = normalizeStringList(state.mailReadKeys);
  const entry = getHomeMailEntries(state).find(mail => mail.key === mailKey);
  if (!entry) {
    state.lastLog = '확인할 우편이 없습니다.';
    saveSanctuary(state);
    renderHome(scene);
    scene?.playSfx?.('uiError', { volume: 0.44 });
    return;
  }
  if (entry.claimed) {
    state.lastLog = '이미 받은 우편입니다.';
    saveSanctuary(state);
    renderHome(scene);
    scene?.playSfx?.('uiError', { volume: 0.44 });
    return;
  }

  if (!entry.claimable) {
    state.mailReadKeys = normalizeStringList([...state.mailReadKeys, entry.key]);
    state.lastLog = `${entry.title} 우편을 확인했습니다.`;
    saveSanctuary(state);
    renderHome(scene);
    scene?.playSfx?.('uiClick', { volume: 0.34 });
    return;
  }

  const rewards = applyHomeRewardBundle(state, entry.reward, scene);
  state.mailClaims[entry.key] = getLocalDateKey();
  state.mailReadKeys = normalizeStringList([...state.mailReadKeys, entry.key]);
  state.lastLog = `${entry.title} 우편 수령: ${rewards.join(', ')}`;
  saveSanctuary(state);
  renderHome(scene, { animateGains: true, gains: rewardGainsForAnimation(entry.reward) });
  scene?.playSfx?.('reward', { volume: 0.58 });
}

function claimAllHomeMail(scene) {
  const state = scene?.sanctuary;
  if (!state) return;
  state.mailClaims = normalizeClaimMap(state.mailClaims);
  state.mailReadKeys = normalizeStringList(state.mailReadKeys);
  const claimable = getHomeMailEntries(state).filter(entry => entry.claimable);
  if (!claimable.length) {
    state.lastLog = '수령 가능한 우편이 없습니다.';
    saveSanctuary(state);
    renderHome(scene);
    scene?.playSfx?.('uiError', { volume: 0.44 });
    return;
  }

  const gains = {};
  const rewardLabels = [];
  const today = getLocalDateKey();
  for (const entry of claimable) {
    rewardLabels.push(...applyHomeRewardBundle(state, entry.reward, scene));
    state.mailClaims[entry.key] = today;
    state.mailReadKeys = normalizeStringList([...state.mailReadKeys, entry.key]);
    for (const [key, value] of Object.entries(rewardGainsForAnimation(entry.reward))) {
      gains[key] = Number(gains[key] || 0) + Number(value || 0);
    }
  }

  state.lastLog = `우편 ${claimable.length}개 수령: ${rewardLabels.join(', ')}`;
  saveSanctuary(state);
  renderHome(scene, { animateGains: true, gains });
  scene?.playSfx?.('reward', { volume: 0.58 });
}

function claimHomeMission(scene, missionKey) {
  const state = scene?.sanctuary;
  if (!state) return;
  state.claimedMissionKeys = normalizeStringList(state.claimedMissionKeys);
  const entry = getHomeMissionEntries(scene, state, getHomeMissionContext(scene)).find(mission => mission.key === missionKey);
  if (!entry || entry.claimed || !entry.complete) {
    state.lastLog = entry?.claimed ? '이미 받은 임무 보상입니다.' : '아직 완료되지 않은 임무입니다.';
    saveSanctuary(state);
    renderHome(scene);
    scene?.playSfx?.('uiError', { volume: 0.46 });
    return;
  }
  const rewards = applyHomeRewardBundle(state, entry.reward, scene);
  state.claimedMissionKeys = normalizeStringList([...state.claimedMissionKeys, entry.key]);
  state.lastLog = `${entry.title} 보상 수령: ${rewards.join(', ')}`;
  saveSanctuary(state);
  renderHome(scene, { animateGains: true, gains: rewardGainsForAnimation(entry.reward) });
  scene?.playSfx?.('reward', { volume: 0.58 });
}

function claimHomePassTier(scene, tierKey) {
  const state = scene?.sanctuary;
  if (!state) return;
  state.passClaimedTiers = normalizeStringList(state.passClaimedTiers);
  const tier = getHomePassTierEntries(state).find(entry => entry.key === tierKey);
  if (!tier || tier.claimed || !tier.complete) {
    state.lastLog = tier?.claimed ? '이미 받은 패스 보상입니다.' : '아직 열리지 않은 패스 보상입니다.';
    saveSanctuary(state);
    renderHome(scene);
    scene?.playSfx?.('uiError', { volume: 0.46 });
    return;
  }
  const rewards = applyHomeRewardBundle(state, tier.reward, scene);
  state.passClaimedTiers = normalizeStringList([...state.passClaimedTiers, tier.key]);
  state.lastLog = `${tier.title} 패스 보상 수령: ${rewards.join(', ')}`;
  saveSanctuary(state);
  renderHome(scene, { animateGains: true, gains: rewardGainsForAnimation(tier.reward) });
  scene?.playSfx?.('reward', { volume: 0.58 });
}

function claimHomeShopProduct(scene, productKey) {
  const state = scene?.sanctuary;
  if (!state) return;
  const product = getHomeShopProductEntries(scene, state, getHomeShopContext()).find(entry => entry.key === productKey);
  if (!product) return;
  if (product.status === 'claimed') {
    state.lastLog = product.once ? `${product.title}은 이미 보유 중입니다.` : '오늘의 보급은 이미 수령했습니다.';
    saveSanctuary(state);
    renderHome(scene);
    scene?.playSfx?.('uiError', { volume: 0.46 });
    return;
  }
  if (!canAffordCost(state, product.cost)) {
    state.lastLog = `${product.title} 구매에는 ${formatMissingCost(state, product.cost)}가 필요합니다.`;
    saveSanctuary(state);
    renderHome(scene);
    scene?.playSfx?.('uiError', { volume: 0.5 });
    return;
  }

  spendCost(state, product.cost);
  const rewards = applyHomeRewardBundle(state, product.reward, scene);
  state.shopClaims = normalizeClaimMap(state.shopClaims);
  if (product.daily) {
    const today = getLocalDateKey();
    state.dailyGiftClaimDate = today;
    state.shopClaims[product.key] = today;
  }
  if (product.once) {
    state.shopClaims[product.key] = 'owned';
  }
  state.lastLog = product.purchaseKind === 'cash'
    ? `${product.title} 테스트 결제 완료: ${rewards.join(', ')}`
    : `${product.title} 획득: ${rewards.join(', ')}`;
  saveSanctuary(state);
  renderHome(scene, { animateGains: true, gains: rewardGainsForAnimation(product.reward) });
  scene?.playSfx?.('reward', { volume: 0.58 });
}

function collectAllHomeProduction(scene) {
  const state = scene?.sanctuary;
  if (!state) return;
  const gains = {};
  let total = 0;
  for (const { building, instance } of getCollectableHomeProductionEntries(state)) {
    const gain = collectBuildingProduction(scene, building, instance);
    if (!gain) continue;
    total += gain.amount;
    gains[gain.key] = Number(gains[gain.key] || 0) + gain.amount;
  }
  state.lastLog = total > 0
    ? `자동 생산품을 모두 수집했습니다: ${Object.entries(gains).map(([key, value]) => `${rewardDisplayName(key)} +${formatNumber(value)}`).join(', ')}`
    : '수집 가능한 생산품이 아직 없습니다.';
  saveSanctuary(state);
  renderHome(scene, { animateGains: total > 0, gains });
  scene?.playSfx?.(total > 0 ? 'reward' : 'uiError', { volume: total > 0 ? 0.58 : 0.44 });
}

function rewardGainsForAnimation(reward = {}) {
  const gains = {};
  for (const [key, value] of Object.entries(reward || {})) {
    const stateKey = key === 'soulflame' ? 'souls' : key;
    if (!HOME_RESOURCE_KEYS.includes(stateKey) && stateKey !== 'light') continue;
    gains[stateKey] = Number(gains[stateKey] || 0) + Number(value || 0);
  }
  return gains;
}

function equipSelectedHomeEquipment(scene) {
  const state = scene?.sanctuary;
  if (!state) return;
  const itemId = normalizeEquipmentItemId(state.selectedEquipmentItemId);
  const item = itemId ? scene?.store?.getItem?.(itemId) : null;
  const slotKey = item ? homeEquipmentSlotKeyForItem(item) : '';
  if (!item || !slotKey) {
    state.lastLog = '장착할 장비를 먼저 선택하세요.';
    renderHome(scene);
    scene?.playSfx?.('uiClick', { volume: 0.3 });
    return;
  }
  if (!isHomeEquipmentOwned(state, item)) {
    state.lastLog = `${item.name}은 아직 보유하지 않은 장비입니다.`;
    document.documentElement.dataset.homeEquipmentLastEquipped = '';
    saveSanctuary(state);
    renderHome(scene);
    scene?.playSfx?.('uiError', { volume: 0.4 });
    return;
  }

  state.equippedItemIds = normalizeEquippedItemIds(state.equippedItemIds);
  state.equippedItemIds[slotKey] = Number(item.id);
  state.lastLog = `${item.name} 장착 완료`;
  document.documentElement.dataset.homeEquipmentLastEquipped = String(item.id);
  saveSanctuary(state);
  renderHome(scene);
  scene?.playSfx?.('reward', { volume: 0.42 });
}

function showDungeonList(scene) {
  const state = scene?.sanctuary;
  activeHomeTab = 'exploration';
  homeDungeonDetailOpen = false;
  homeBuildTrayOpen = false;
  if (state) {
    state.buildPlanBuildingKey = '';
    state.buildPlanPlacement = null;
    saveSanctuary(state);
    renderHome(scene);
  }
}

function selectDungeon(scene, mapId) {
  const state = scene?.sanctuary;
  if (!state) return;
  const id = normalizeSideDungeonMapId(mapId, state.selectedDungeonMapId || SIDE_DUNGEON_IDS[0]);
  activeHomeTab = 'exploration';
  homeBuildTrayOpen = false;
  state.buildPlanBuildingKey = '';
  state.buildPlanPlacement = null;
  const entry = getDungeonEntries(scene, state).find(row => row.id === id);
  if (!isSideDungeonUnlocked(scene, state, id)) {
    handleLockedDungeonSelection(scene, state, entry);
    return;
  }
  homeDungeonDetailOpen = true;
  state.selectedDungeonMapId = id;
  syncSideDungeonProgress(scene, state);
  const selected = getSelectedDungeonEntry(scene, state);
  const difficulty = getSelectedDungeonDifficultyEntry(scene, state, id);
  state.lastLog = `${selected?.name || '던전'} 상세. ${difficulty?.label || '난이도'}를 확인하세요.`;
  saveSanctuary(state);
  renderHome(scene);
  scene?.playSfx?.('uiClick', { volume: 0.48 });
}

function previewDungeon(scene, mapId) {
  const state = scene?.sanctuary;
  if (!state) return;
  const id = normalizeSideDungeonMapId(mapId, state.selectedDungeonMapId || SIDE_DUNGEON_IDS[0]);
  activeHomeTab = 'exploration';
  homeBuildTrayOpen = false;
  state.buildPlanBuildingKey = '';
  state.buildPlanPlacement = null;
  const entry = getDungeonEntries(scene, state).find(row => row.id === id);
  if (!isSideDungeonUnlocked(scene, state, id)) {
    handleLockedDungeonSelection(scene, state, entry);
    return;
  }
  homeDungeonDetailOpen = false;
  state.selectedDungeonMapId = id;
  state.lastDungeonMapId = id;
  syncSideDungeonProgress(scene, state);
  state.lastLog = entry?.name || state.lastLog || '';
  saveSanctuary(state);
  renderHome(scene);
  scene?.playSfx?.('uiClick', { volume: 0.42 });
}

function handleLockedDungeonSelection(scene, state, entry) {
  homeDungeonDetailOpen = false;
  state.lastLog = `${entry?.name || '던전'} 해금 조건: ${entry?.unlock || '메인 진행 필요'}`;
  saveSanctuary(state);
  renderHome(scene);
  scene?.playSfx?.('uiError', { volume: 0.58 });
}

function selectDungeonDifficulty(scene, difficultyKey, options = {}) {
  const state = scene?.sanctuary;
  if (!state) return;
  const id = normalizeSideDungeonMapId(state.selectedDungeonMapId || state.lastDungeonMapId);
  const difficulty = getDungeonDifficultyEntries(scene, state, id)
    .find(entry => entry.key === normalizeDungeonDifficultyKey(difficultyKey));
  if (!difficulty?.unlocked) {
    const entry = getDungeonEntries(scene, state).find(row => row.id === id);
    state.lastLog = `${entry?.name || '던전'} ${difficulty?.label || '난이도'} 해금 조건: ${difficulty?.unlock || '메인 진행 필요'}`;
    saveSanctuary(state);
    renderHome(scene);
    scene?.playSfx?.('uiError', { volume: 0.58 });
    return;
  }
  state.selectedDungeonDifficultyKey = difficulty.key;
  state.lastDungeonDifficultyKey = difficulty.key;
  homeDungeonDetailOpen = options.openDetail !== false;
  state.lastLog = `${difficulty.label} 난이도를 선택했습니다.`;
  saveSanctuary(state);
  renderHome(scene);
  scene?.playSfx?.('uiClick', { volume: 0.46 });
}

function startSelectedDungeon(scene, mapId = null, difficultyKey = null) {
  const state = scene?.sanctuary;
  if (!scene || !state) return;
  const id = normalizeSideDungeonMapId(mapId || state.selectedDungeonMapId, state.selectedDungeonMapId || SIDE_DUNGEON_IDS[0]);
  const entry = getDungeonEntries(scene, state).find(row => row.id === id);
  if (!isSideDungeonUnlocked(scene, state, id)) {
    state.lastLog = `${entry?.name || '던전'} 해금 조건: ${entry?.unlock || '메인 진행 필요'}`;
    renderHome(scene);
    scene.playSfx?.('uiError', { volume: 0.62 });
    return;
  }
  const difficulty = getDungeonDifficultyEntries(scene, state, id)
    .find(row => row.key === normalizeDungeonDifficultyKey(difficultyKey || state.selectedDungeonDifficultyKey));
  if (!difficulty?.unlocked) {
    state.lastLog = `${entry?.name || '던전'} ${difficulty?.label || '난이도'} 해금 조건: ${difficulty?.unlock || '메인 진행 필요'}`;
    renderHome(scene);
    scene.playSfx?.('uiError', { volume: 0.62 });
    return;
  }
  state.selectedDungeonMapId = id;
  state.lastDungeonMapId = id;
  state.selectedDungeonDifficultyKey = difficulty.key;
  state.lastDungeonDifficultyKey = difficulty.key;
  scene.startExpedition({ mapId: id, dungeonDifficulty: difficulty.key });
}

function startSelectedMainMap(scene, mapId = null) {
  const state = scene?.sanctuary;
  if (!scene || !state) return;
  const id = normalizeMainMapId(mapId || state.currentMapId, state.currentMapId || START_MAP_ID);
  if (!isMainMapUnlocked(state, id)) {
    const stageNo = mainMapStageNo(id) || 1;
    state.lastLog = `Stage ${stageNo}는 아직 잠겨 있습니다.`;
    renderHome(scene);
    scene.playSfx?.('uiError', { volume: 0.62 });
    return;
  }
  state.currentMapId = id;
  state.lastPlayedMapId = id;
  scene.startExpedition({ mapId: id });
}

function closeDungeonModal(scene) {
  const state = scene?.sanctuary;
  activeHomeTab = 'sanctuary';
  homeBuildTrayOpen = false;
  homeDungeonDetailOpen = false;
  if (state) {
    state.buildPlanBuildingKey = '';
    state.buildPlanPlacement = null;
    saveSanctuary(state);
    renderHome(scene);
    return;
  }
  if (dom.homeDungeonModal) {
    dom.homeDungeonModal.hidden = true;
    dom.homeDungeonModal.setAttribute('aria-hidden', 'true');
  }
  if (dom.homeDungeonDetailModal) {
    dom.homeDungeonDetailModal.hidden = true;
    dom.homeDungeonDetailModal.setAttribute('aria-hidden', 'true');
  }
}

function closeHomeMissionModal(scene) {
  const state = scene?.sanctuary;
  activeHomeTab = 'sanctuary';
  homeBuildTrayOpen = false;
  homeDungeonDetailOpen = false;
  homeEquipmentDetailItemId = 0;
  activeHomeQuickView = '';
  if (state) {
    state.buildPlanBuildingKey = '';
    state.buildPlanPlacement = null;
    saveSanctuary(state);
    renderHome(scene);
    return;
  }
  if (dom.homeMissionModal) {
    dom.homeMissionModal.hidden = true;
    dom.homeMissionModal.setAttribute('aria-hidden', 'true');
  }
  if (dom.homeShopModal) {
    dom.homeShopModal.hidden = true;
    dom.homeShopModal.setAttribute('aria-hidden', 'true');
  }
  document.documentElement.dataset.homeMissionModalOpen = 'false';
  document.documentElement.dataset.homeShopModalOpen = 'false';
}

function closeHomeShopModal(scene) {
  const state = scene?.sanctuary;
  activeHomeTab = 'sanctuary';
  homeBuildTrayOpen = false;
  homeDungeonDetailOpen = false;
  activeHomeQuickView = '';
  if (state) {
    state.buildPlanBuildingKey = '';
    state.buildPlanPlacement = null;
    saveSanctuary(state);
    renderHome(scene);
    return;
  }
  if (dom.homeShopModal) {
    dom.homeShopModal.hidden = true;
    dom.homeShopModal.setAttribute('aria-hidden', 'true');
  }
  document.documentElement.dataset.homeShopModalOpen = 'false';
}

function closeHomeTabPanel(scene) {
  const state = scene?.sanctuary;
  activeHomeTab = 'sanctuary';
  homeBuildTrayOpen = false;
  homeDungeonDetailOpen = false;
  activeHomeQuickView = '';
  if (state) {
    state.buildPlanBuildingKey = '';
    state.buildPlanPlacement = null;
    saveSanctuary(state);
    renderHome(scene);
    return;
  }
  if (dom.homeEquipmentScreen) {
    dom.homeEquipmentScreen.hidden = true;
    dom.homeEquipmentScreen.setAttribute('aria-hidden', 'true');
  }
  if (dom.homeEquipmentDetailModal) {
    dom.homeEquipmentDetailModal.hidden = true;
    dom.homeEquipmentDetailModal.setAttribute('aria-hidden', 'true');
    document.documentElement.dataset.homeEquipmentDetailOpen = 'false';
    document.documentElement.dataset.homeEquipmentDetailItemId = '';
  }
  if (dom.homeFeatureScreen) {
    dom.homeFeatureScreen.hidden = true;
    dom.homeFeatureScreen.setAttribute('aria-hidden', 'true');
    document.documentElement.dataset.homeFeatureVisible = 'false';
  }
  if (dom.homeShopModal) {
    dom.homeShopModal.hidden = true;
    dom.homeShopModal.setAttribute('aria-hidden', 'true');
    document.documentElement.dataset.homeShopModalOpen = 'false';
  }
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
        productionStoredAmount: 0,
        productionLastSettledAt: seconds <= 0 ? now : null,
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
    settleBuildingProduction(state, building, instance);
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
        const nextSnapshot = getBuildingProductionSnapshot(state, building, nextLevel, instance);
        if (nextSnapshot.hasProduction) {
          instance.productionStoredAmount = Math.min(Number(instance.productionStoredAmount || 0), nextSnapshot.cap);
          instance.productionLastSettledAt = Date.now();
          state.placedBuildingInstances[instance.id] = instance;
        }
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
  dom.resultTitle.textContent = summary.title || (summary.won ? '안개 정화 성공' : '조기 귀환');
  if (dom.resultCard) {
    dom.resultCard.classList.toggle('is-win', Boolean(summary.won));
    dom.resultCard.classList.toggle('is-loss', !summary.won);
  }
  if (dom.resultKicker) dom.resultKicker.textContent = summary.kicker || '';
  dom.resultSummary.textContent = summary.message;
  const stats = summary.stats || [];
  if (dom.resultStats) {
    dom.resultStats.innerHTML = stats
      .map(stat => `
        <span class="result-stat">
          <small>${escapeHtml(stat.label)}</small>
          <b>${escapeHtml(stat.value)}</b>
        </span>
      `)
      .join('');
  }
  const rewards = summary.rewards || [];
  if (dom.resultRewardTitle) dom.resultRewardTitle.textContent = rewards.length ? '획득 보상' : '획득 보상 없음';
  dom.resultRewards.innerHTML = rewards.length
    ? rewards
    .map(reward => `
      <div class="reward-line reward-line--${escapeHtml(reward.key || 'misc')}">
        ${renderResultRewardIcon(reward)}
        <b>${escapeHtml(reward.name)}</b>
        <em>+${formatNumber(reward.count)}</em>
        ${renderResultRewardIcon(reward, 'reward-icon reward-icon--tail')}
      </div>
    `)
      .join('')
    : '<div class="reward-empty">획득한 보상이 없습니다.</div>';
}

function renderResultRewardIcon(reward, className = 'reward-icon') {
  const iconSrc = resultIconSrc(reward.iconSrc);
  if (iconSrc) {
    return `<span class="${escapeHtml(className)}" aria-hidden="true"><img src="${escapeHtml(iconSrc)}" alt="" loading="eager"></span>`;
  }
  return `<span class="${escapeHtml(className)} reward-icon--glyph" aria-hidden="true">${escapeHtml(reward.icon || '*')}</span>`;
}

function resultIconSrc(src) {
  const path = String(src || '').trim();
  if (!path) return '';
  if (/[?&]v=/.test(path)) return path;
  return `${path}${path.includes('?') ? '&' : '?'}v=${ASSET_VERSION}`;
}

function resultItemIconSrc(item) {
  const itemId = Number(item?.id || 0);
  if (itemId === 6) return HOME_UI_ICON_PATHS.growth;
  const iconPath = item?.spriteGroups?.Icon || item?.Icon || item?.icon || item?.sprite || item?.Sprite;
  if (iconPath) return assetUrlFromSpritePath(iconPath);
  const category = String(item?.category || item?.Category || '').toLowerCase();
  if (category === 'weapon' || category === 'equipment') return HOME_UI_ICON_PATHS.collect;
  return HOME_UI_ICON_PATHS.collect;
}

function applyExpeditionRewards(state, mapRewards, run, context = {}) {
  const rewardMap = new Map();
  let woodRewardBase = 0;
  const activeMap = context.map || context.store?.getMap?.(context.mapId) || null;
  const rawActiveMapId = Number(activeMap?.id || context.mapId || state.currentMapId || START_MAP_ID);
  const isMainRun = isMainMapId(rawActiveMapId);
  const isSideDungeonRun = isSideDungeonMapId(rawActiveMapId);
  const activeMapId = isMainRun
    ? normalizeMainMapId(rawActiveMapId, state.currentMapId || START_MAP_ID)
    : isSideDungeonRun
      ? normalizeSideDungeonMapId(rawActiveMapId, state.selectedDungeonMapId || SIDE_DUNGEON_IDS[0])
      : rawActiveMapId;
  const activeStageNo = isMainRun
    ? (context.store?.getMainStageNumber?.(activeMapId) || mainMapStageNo(activeMapId) || 1)
    : null;
  if (isMainRun) state.lastPlayedMapId = activeMapId;
  if (isSideDungeonRun) state.lastDungeonMapId = activeMapId;
  const addReward = (key, count, overrides = {}) => {
    const safe = Math.max(0, Math.floor(count));
    if (!safe) return;
    const meta = RESULT_REWARD_META[key] || {};
    const previous = rewardMap.get(key) || {
      key,
      name: overrides.name || meta.name || key,
      icon: overrides.icon || meta.icon || '',
      iconSrc: overrides.iconSrc || meta.iconSrc || '',
      count: 0,
    };
    previous.count += safe;
    rewardMap.set(key, previous);
  };

  for (const reward of mapRewards || []) {
    const id = Number(reward.itemDataId);
    const count = Math.max(0, Math.floor(Number(reward.count || 0)));
    if (id === 5) {
      state.gold += count;
      addReward('gold', count);
    } else if (id === 200101) {
      state.wood += count;
      woodRewardBase += count;
      addReward('wood', count);
    } else if (id === 200102) {
      state.stone += count;
      addReward('stone', count);
    } else if (id === 200103) {
      state.souls += count;
      addReward('souls', count);
    } else if (id === 200111) {
      state.companionShards = Math.max(0, Number(state.companionShards || 0) + count);
      addReward('companion_shards', count);
    } else {
      const stored = addSanctuaryItem(state, id, count);
      if (stored > 0) {
        const item = reward.item || context.store?.getItem?.(id) || null;
        addReward(`item_${id}`, stored, {
          name: item?.name || `Item ${id}`,
          iconSrc: resultItemIconSrc(item || { id }),
        });
      }
    }
  }

  for (const [key, rawCount] of Object.entries(run.ledger || {})) {
    const count = Math.max(0, Math.floor(Number(rawCount || 0)));
    if (key === 'gold') {
      state.gold += count;
      addReward('gold', count);
    } else if (key === 'wood') {
      state.wood += count;
      woodRewardBase += count;
      addReward('wood', count);
    } else if (key === 'stone') {
      state.stone += count;
      addReward('stone', count);
    } else if (key === 'souls') {
      state.souls += count;
      addReward('souls', count);
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
  const clearProgress = run.won && isMainRun ? markMainMapCleared(state, activeMapId) : null;
  const dungeonCleared = run.won && isSideDungeonRun ? activeMapId : null;
  if (dungeonCleared) {
    const ids = new Set(normalizeClearedDungeonIds(state));
    ids.add(dungeonCleared);
    state.clearedDungeonIds = SIDE_DUNGEON_IDS.filter(id => ids.has(id));
  }
  if (!run.won || !isMainRun) syncMainMapProgress(state);
  addReward('souls', soulGain);
  addReward('wood', woodGain);
  addReward('light', lightGain);

  const woodBonusPercent = getCompanionBonus(state, 'wood_reward_percent');
  const companionWoodGain = Math.floor(woodRewardBase * woodBonusPercent / 100);
  if (companionWoodGain > 0) {
    state.wood += companionWoodGain;
    addReward('wood', companionWoodGain);
  }

  syncCompanionUnlocks(state, { announce: true });
  const activeCompanionCount = getActiveCompanions(state).length;
  const companionExp = activeCompanionCount > 0
    ? addCompanionExp(state, (run.won ? 36 : 14) + Math.floor(run.kills * 1.2))
    : 0;
  if (companionExp > 0) addReward('companion_exp', companionExp);

  const nextExpansionCost = getNextExpansionCost(state);
  if (nextExpansionCost) state.lightNeed = nextExpansionCost;
  const expansionReady = getExpandableTiles(state).length > 0;

  const summonable = getSummonableCompanions(state);
  const summonCopy = summonable.length ? ` ${summonable.map(companion => companion.name).join(', ')}를 용병 훈련소에서 소환할 수 있습니다.` : '';
  const nextMap = clearProgress?.nextMapId ? context.store?.getMap?.(clearProgress.nextMapId) : null;
  const nextStageNo = clearProgress?.nextMapId
    ? (context.store?.getMainStageNumber?.(clearProgress.nextMapId) || mainMapStageNo(clearProgress.nextMapId))
    : null;
  const nextCopy = nextMap
    ? ` 다음은 Stage ${nextStageNo} ${nextMap.name}입니다.`
    : clearProgress?.completedChapter
      ? ' 1장 메인 맵을 모두 정화했습니다.'
      : '';
  const mapName = activeMap?.name || `Stage ${activeStageNo}`;
  const resultKicker = run.won
    ? isMainRun
      ? `Stage ${activeStageNo} 정화 성공`
      : `${mapName} 완료`
    : `${mapName}에서 패배`;
  state.lastLog = run.won
    ? `${mapName} ${isSideDungeonRun ? '완료' : '정화 완료'}.${nextCopy}${expansionReady ? ' 성소에 정화 가능한 안개 타일이 생겼습니다.' : ' 등불이 더 밝아졌습니다.'}${summonCopy}`
    : `${mapName}에서 귀환했습니다. 보상은 유지되고, 같은 Stage에 다시 도전할 수 있습니다.${summonCopy}`;
  const resultMessage = run.won
    ? `${nextCopy ? nextCopy.trim() : ''} ${expansionReady ? '정화할 타일이 준비됐습니다.' : '등불이 더 밝아졌습니다.'}${summonCopy}`.trim()
    : `보상은 유지되고, 같은 Stage에 다시 도전할 수 있습니다.${summonCopy}`;

  return {
    won: run.won,
    title: run.won ? '맵 클리어' : '패배',
    kicker: resultKicker,
    stats: [
      { label: '생존', value: formatTime(run.elapsed) },
      { label: '처치', value: formatNumber(run.kills) },
      { label: '픽업', value: formatNumber(run.drops) },
    ],
    rewards: [...rewardMap.values()],
    message: resultMessage,
    mapId: activeMapId,
    nextMapId: clearProgress?.nextMapId || null,
  };
}

function drawUnitHp(graphics, unit) {
  graphics.clear();
  if (!unit.alive || unit.team === TEAM.PLAYER) return;
  const spec = hpBarSpecForUnit(unit);
  const width = spec.width;
  const height = spec.height;
  const x = unit.x - width / 2;
  const y = unit.y - spec.yOffset;
  graphics.fillStyle(0x17241d, 0.48);
  graphics.fillRoundedRect(x, y, width, height, 3);
  graphics.fillStyle(unit.type === 'Boss' ? COLORS.red : COLORS.leaf, 0.95);
  graphics.fillRoundedRect(x, y, width * clamp(unit.hp / Math.max(1, unit.maxHp), 0, 1), height, 3);
}

function scaleForUnit(unit) {
  const renderClass = renderClassForUnit(unit);
  const baseScale = UNIT_RENDER_BASE_SCALE[renderClass] || UNIT_RENDER_BASE_SCALE.enemy;
  const maxScale = renderClass === 'boss' ? 0.38 : renderClass === 'elite' ? 0.34 : 0.3;
  const artScale = unit?.team === TEAM.PLAYER
    ? 1
    : clamp(numberOr(unit?.def?.uiScale ?? unit?.uiScale, 1), 0.72, 1.28);
  const visualScaleMultiplier = clamp(numberOr(unit?.visualScaleMultiplier, 1), 0.45, 1.25);
  return clamp(baseScale * scaleRatioForUnit(unit) * artScale * visualScaleMultiplier, 0.055, maxScale * visualScaleMultiplier);
}

function hpBarSpecForUnit(unit) {
  const isBoss = unit.type === 'Boss';
  const defaults = isBoss ? UNIT_HP_BAR_DEFAULTS.boss : UNIT_HP_BAR_DEFAULTS.enemy;
  const radiusPx = unitHitRadiusPx(unit, isBoss ? 56 : 25);
  return {
    width: Math.round(isBoss ? clamp(radiusPx * 1.35, 64, 88) : clamp(radiusPx * 1.5, 34, 50)),
    height: defaults.height,
    yOffset: Math.round(isBoss ? clamp(radiusPx * 1.12, 52, 68) : clamp(radiusPx * 1.25, 28, 38)),
  };
}

function unitCueRadiusPx(unit, fallback = 24) {
  const isBoss = unit?.type === 'Boss';
  return clamp(unitHitRadiusPx(unit, fallback), isBoss ? 30 : 16, isBoss ? 54 : 30);
}

function unitHitRadiusPx(unit, fallback = 24) {
  return unitWorldRadius(unit, 'hitSize', fallback / UNIT_WORLD_PIXEL_SCALE) * UNIT_WORLD_PIXEL_SCALE;
}

function unitWorldRadius(unit, field, fallback = 0) {
  const direct = numberOr(unit?.[field], NaN);
  if (Number.isFinite(direct) && direct > 0) return direct;
  const base = numberOr(unit?.def?.[field], 0);
  return base > 0 ? base * scaleRatioForUnit(unit) : Math.max(0, fallback);
}

function scaleRatioForUnit(unit) {
  const direct = numberOr(unit?.scaleRatio, NaN);
  if (Number.isFinite(direct) && direct > 0) return direct;
  const scalePercent = unitStatValue(unit, 'ScalePercent', 0);
  return Math.max(0.05, 1 + scalePercent / 100);
}

function unitStatValue(unit, statType, fallback = 0) {
  const stat = (unit?.def?.addStats || unit?.addStats || []).find(entry => (entry?.type || 'Hp') === statType);
  return pickLevelValue(stat?.value || stat?.Value, unit?.level || 1, fallback);
}

function renderClassForUnit(unit) {
  if (unit?.team === TEAM.PLAYER || unit?.type === 'Player') return 'player';
  if (isBossEnemy(unit)) return 'boss';
  if (unit?.type === 'Elite' || unit?.type === 'MidBoss') return 'elite';
  return 'enemy';
}

function isBossEnemy(unit) {
  return unit?.type === 'Boss' || Number(unit?.dataId) === 110501;
}

function numberOr(value, fallback = 0) {
  if (value == null || value === '') return fallback;
  const n = Number(value);
  return Number.isFinite(n) ? n : fallback;
}

function isNormalEnemyContactHit(unit, source, skill) {
  return unit?.team === TEAM.PLAYER
    && source
    && source.team !== TEAM.PLAYER
    && source.type !== 'Boss'
    && !skill;
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
  installTitleSplashController();
  applyNinja2Settings();
  installUiClickSfx();
  installUiMotionFeedback();
  installHomeMapPan();
  globalThis.addEventListener('pointermove', event => updateHomeBuildGhostPointer(event), { passive: true });
  globalThis.addEventListener('mousemove', event => updateHomeBuildGhostPointer(event), { passive: true });
  dom.homeHexGrid.addEventListener('pointermove', event => {
    updateHomeBuildGhostPointer(event);
    setHomeBuildHoverTile(scene(), homeBuildTileIdFromEvent(event));
  }, { passive: true });
  dom.homeHexGrid.addEventListener('pointerleave', () => setHomeBuildHoverTile(scene(), 0));
  dom.sortieButton.addEventListener('click', event => startSelectedMainMap(scene(), event.currentTarget?.dataset.mainMapId));
  dom.resultReturnButton.addEventListener('click', () => scene()?.returnHome?.());
  dom.returnButton.addEventListener('click', () => scene()?.returnHome?.());
  dom.pauseButton.addEventListener('click', () => scene()?.togglePause?.());
  dom.restartButton.addEventListener('click', () => scene()?.restartRun?.());
  dom.homeResetButton.addEventListener('click', () => scene()?.restartRun?.());
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
    if (event.key === 'Escape') {
      closeHomeEquipmentDetail(scene());
      setHomeSettingsOpen(false);
      closeHomeQuickView(scene());
    }
  });
  dom.homeScreen?.addEventListener('click', event => {
    const quickTarget = event.target.closest('[data-home-quick]');
    if (quickTarget) {
      openHomeQuickView(scene(), quickTarget.dataset.homeQuick);
      return;
    }
    const tabTarget = event.target.closest('[data-open-home-tab]');
    if (tabTarget) {
      selectHomeTab(scene(), tabTarget.dataset.openHomeTab);
    }
  });
  dom.homeQuickModal?.addEventListener('click', event => {
    if (event.target.closest('[data-close-home-quick]') || event.target.closest('.home-modal-scrim')) {
      closeHomeQuickView(scene());
      return;
    }
    const actionTarget = event.target.closest('[data-home-quick-action]');
    if (actionTarget) {
      const action = actionTarget.dataset.homeQuickAction;
      if (action === 'collect-all') collectAllHomeProduction(scene());
      if (action === 'claim-daily-gift') claimHomeShopProduct(scene(), 'daily_supply');
      if (action === 'claim-all-mail') claimAllHomeMail(scene());
      return;
    }
    const mailTarget = event.target.closest('[data-home-mail-key]');
    if (mailTarget) {
      claimHomeMail(scene(), mailTarget.dataset.homeMailKey);
      return;
    }
    const passTarget = event.target.closest('[data-claim-home-pass]');
    if (passTarget) {
      claimHomePassTier(scene(), passTarget.dataset.claimHomePass);
    }
  });
  dom.homeMissionModal?.addEventListener('click', event => {
    if (event.target.closest('[data-close-home-mission]') || event.target.closest('.home-modal-scrim')) {
      closeHomeMissionModal(scene());
      return;
    }
    const missionTarget = event.target.closest('[data-claim-home-mission]');
    if (missionTarget) {
      claimHomeMission(scene(), missionTarget.dataset.claimHomeMission);
    }
  });
  dom.homeShopModal?.addEventListener('click', event => {
    if (event.target.closest('[data-close-home-shop]') || event.target.closest('.home-modal-scrim')) {
      closeHomeShopModal(scene());
      return;
    }
    const categoryTarget = event.target.closest('[data-home-shop-category]');
    if (categoryTarget) {
      activeHomeShopCategory = normalizeHomeShopCategoryKey(categoryTarget.dataset.homeShopCategory);
      renderHome(scene());
      scene()?.playSfx?.('uiClick', { volume: 0.34 });
      return;
    }
    const shopTarget = event.target.closest('[data-buy-home-shop]');
    if (shopTarget) {
      claimHomeShopProduct(scene(), shopTarget.dataset.buyHomeShop);
    }
  });
  dom.homeEquipmentDetailModal?.addEventListener('click', event => {
    if (event.target.closest('[data-close-equipment-detail]') || event.target.closest('.home-modal-scrim')) {
      closeHomeEquipmentDetail(scene());
      return;
    }
    const equipTarget = event.target.closest('[data-equipment-detail-action="equip"]');
    if (equipTarget) {
      equipSelectedHomeEquipment(scene());
    }
  });
  dom.homeFeatureScreen?.addEventListener('click', event => {
    if (event.target.closest('[data-close-home-tab-panel]')) {
      closeHomeTabPanel(scene());
      return;
    }
    const shopTarget = event.target.closest('[data-buy-home-shop]');
    if (shopTarget) {
      claimHomeShopProduct(scene(), shopTarget.dataset.buyHomeShop);
    }
  });
  dom.homeTabs?.addEventListener('click', event => {
    const target = event.target.closest('[data-home-tab]');
    if (!target) return;
    selectHomeTab(scene(), target.dataset.homeTab);
  });
  dom.homeEquipmentScreen?.addEventListener('click', event => {
    if (event.target.closest('[data-close-home-tab-panel]')) {
      closeHomeTabPanel(scene());
      return;
    }
    const filterTarget = event.target.closest('[data-equipment-filter]');
    if (filterTarget) {
      activeEquipmentFilter = HOME_EQUIPMENT_FILTERS.some(filter => filter.key === filterTarget.dataset.equipmentFilter)
        ? filterTarget.dataset.equipmentFilter
        : 'all';
      renderHome(scene());
      scene()?.playSfx?.('uiClick', { volume: 0.36 });
      return;
    }

    const cardTarget = event.target.closest('[data-equipment-item-id]');
    if (cardTarget) {
      const itemId = normalizeEquipmentItemId(cardTarget.dataset.equipmentItemId);
      openHomeEquipmentDetail(scene(), itemId, { focusFilter: Boolean(cardTarget.dataset.equipmentSlot) });
      return;
    }

    const actionTarget = event.target.closest('[data-equipment-action="equip"]');
    if (!actionTarget) return;
    equipSelectedHomeEquipment(scene());
  });
  dom.homeDungeonModal?.addEventListener('click', event => {
    if (event.target.closest('[data-close-dungeon-modal]')) {
      closeDungeonModal(scene());
      return;
    }
    const startTarget = event.target.closest('[data-start-dungeon-map]');
    if (startTarget) {
      startSelectedDungeon(scene(), startTarget.dataset.startDungeonMap, startTarget.dataset.dungeonDifficulty);
      return;
    }
    const difficultyTarget = event.target.closest('[data-dungeon-difficulty]');
    if (difficultyTarget) {
      selectDungeonDifficulty(scene(), difficultyTarget.dataset.dungeonDifficulty, { openDetail: false });
      return;
    }
    const previewTarget = event.target.closest('[data-preview-dungeon-map-id]');
    if (previewTarget) {
      previewDungeon(scene(), previewTarget.dataset.previewDungeonMapId);
      return;
    }
    const detailTarget = event.target.closest('[data-open-dungeon-detail]');
    if (detailTarget) {
      selectDungeon(scene(), detailTarget.dataset.openDungeonDetail);
      return;
    }
    const mapTarget = event.target.closest('[data-dungeon-map-id]');
    if (!mapTarget) return;
    previewDungeon(scene(), mapTarget.dataset.dungeonMapId);
  });
  dom.homeDungeonDetailModal?.addEventListener('click', event => {
    if (event.target.closest('[data-close-dungeon-modal]')) {
      closeDungeonModal(scene());
      return;
    }
    if (event.target.closest('[data-back-dungeon-list]')) {
      showDungeonList(scene());
      return;
    }
    const difficultyTarget = event.target.closest('[data-dungeon-difficulty]');
    if (difficultyTarget) {
      selectDungeonDifficulty(scene(), difficultyTarget.dataset.dungeonDifficulty, { openDetail: true });
      return;
    }
    const startTarget = event.target.closest('[data-start-dungeon-map]');
    if (startTarget) {
      startSelectedDungeon(scene(), startTarget.dataset.startDungeonMap, startTarget.dataset.dungeonDifficulty);
    }
  });
  dom.homeBuildModal?.addEventListener('click', event => {
    if (!event.target.closest('[data-close-build-modal]')) return;
    closeHomeBuildModal(scene());
  });
  dom.homeBuildList?.addEventListener('click', event => {
    const target = event.target.closest('[data-select-build-building]');
    if (target) {
      updateHomeBuildGhostPointer(event);
      selectBuildPlan(scene(), target.dataset.selectBuildBuilding);
      return;
    }
    const ownedTarget = event.target.closest('[data-owned-building]');
    if (!ownedTarget) return;
    activateBuilding(scene(), ownedTarget.dataset.buildingKey, ownedTarget.dataset.buildingInstanceId, {
      sourceElement: ownedTarget,
      event,
    });
  });
  dom.companionSkillDock?.addEventListener('click', event => {
    const target = event.target.closest('[data-dash-control]');
    if (!target) return;
    const dashed = scene()?.requestPlayerDash?.({ source: 'button' });
    if (!dashed) restartUiMotionClass(target, 'is-ui-error');
  });
  dom.homeHexGrid.addEventListener('click', event => {
    const app = scene();
    const tileTarget = event.target.closest('[data-tile-id]');
    if (app?.sanctuary?.buildPlanBuildingKey && tileTarget) {
      updateHomeBuildGhostPointer(event);
      homeBuildHover.anchorTileId = Number(tileTarget.dataset.tileId || 0);
      placeSelectedBuildingAtTile(app, tileTarget.dataset.tileId);
      return;
    }

    const buildingTarget = event.target.closest('[data-building-key]');
    if (buildingTarget) {
      activateBuilding(scene(), buildingTarget.dataset.buildingKey, buildingTarget.dataset.buildingInstanceId, {
        sourceElement: buildingTarget,
        event,
      });
      return;
    }
    if (tileTarget) {
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
