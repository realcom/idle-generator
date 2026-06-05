import { TEAM, clamp, formatNumber } from './constants.js?v=mushroomer';
import {
  PHASER_DESIGN,
  UI_ASSET_PATHS,
  modalTextStyle,
  textureForButtonStyle,
} from './design-system.js?v=modaltext1';
import {
  LANGUAGE_OPTIONS,
  getOrCreateLocalPlayerId,
  resolveSettings,
  saveSettings,
} from './settings-store.js?v=settings1';

const PhaserContainer = globalThis.Phaser?.GameObjects?.Container ?? class {
  constructor() {
    throw new Error('Phaser is required for modal components');
  }
};
const PhaserScene = globalThis.Phaser?.Scene ?? class {};

function makeContainer(scene, x = 0, y = 0) {
  return new globalThis.Phaser.GameObjects.Container(scene, x, y);
}

function makeGraphics(scene) {
  return new globalThis.Phaser.GameObjects.Graphics(scene);
}

function makeImage(scene, x, y, key) {
  return new globalThis.Phaser.GameObjects.Image(scene, x, y, key);
}

function makeRectangle(scene, x, y, width, height, color, alpha = 1) {
  return new globalThis.Phaser.GameObjects.Rectangle(scene, x, y, width, height, color, alpha);
}

function makeText(scene, x, y, text, style) {
  return new globalThis.Phaser.GameObjects.Text(scene, x, y, text, style);
}

const BUTTON_SLICE_SPECS = {
  'ui-button-reward-gold': { left: 94, right: 94, top: 72, bottom: 76, edgeX: 28, edgeY: 18 },
  'ui-button-reward-gold-pressed': { left: 94, right: 94, top: 72, bottom: 74, edgeX: 28, edgeY: 18 },
  'ui-button-green-upgrade': { left: 78, right: 78, top: 52, bottom: 56, edgeX: 25, edgeY: 16 },
  'ui-button-green-upgrade-pressed': { left: 78, right: 78, top: 52, bottom: 54, edgeX: 25, edgeY: 16 },
  'ui-button-tab-wood': { left: 82, right: 82, top: 50, bottom: 54, edgeX: 24, edgeY: 17 },
  'ui-button-side-wood': { left: 52, right: 52, top: 72, bottom: 72, edgeX: 17, edgeY: 18 },
};

function playSfx(name, options = {}) {
  const audio = globalThis.__MUSHROOMER_PHASER_AUDIO__ || globalThis.__IDLEZ_PHASER_AUDIO__;
  return audio?.play?.(name, options) ?? false;
}

const FEATURE_MODAL_ROWS = {
  pass: [
    { icon: 'P', title: '시즌 패스', body: '무료/프리미엄 트랙 보상판 준비 영역', meta: 'Soon' },
    { icon: '$', title: '일일 보상', body: '전투와 성장 행동을 패스 경험치로 연결', meta: '+XP' },
    { icon: '!', title: '알림 배지', body: '보상 받을 단계가 생기면 사이드 버튼에 표시', meta: 'Live' },
  ],
  speed: [
    { icon: '>>', title: '전투 속도', body: '현재 프로토타입 표시는 x1.5 상태입니다.', meta: 'x1.5' },
    { icon: 'T', title: '전투 루프', body: '보드 tick은 계속 진행되고 UI만 상태를 표시합니다.', meta: '30/s' },
  ],
  auto: [
    { icon: 'A', title: '자동 강화', body: '가장 저렴한 성장 스탯부터 순서대로 강화하는 슬롯입니다.', meta: 'Auto' },
    { icon: '$', title: '소비 재화', body: '골드가 부족하면 자동으로 대기 상태가 됩니다.', meta: 'Gold' },
  ],
  growth: [
    { icon: '+', title: '성장 탭', body: '공격력, 체력, 공격속도, 치명피해를 즉시 강화합니다.', meta: '4 Stat' },
    { icon: '$', title: '성장 재화', body: '전투 드롭 골드가 카드 비용과 바로 연결됩니다.', meta: 'Loop' },
  ],
  companion: [
    { icon: 'C', title: '동료 슬롯', body: '햄스터 전투를 보조하는 동료 유닛 목록 자리입니다.', meta: 'Roster' },
    { icon: '+', title: '소환/편성', body: '동료 획득, 배치, 패시브 보너스를 이 모달로 확장합니다.', meta: 'Plan' },
  ],
  equipment: [
    { icon: 'W', title: '장비 가방', body: '무기와 방어구 슬롯을 카드 리스트로 보여줄 수 있습니다.', meta: 'Gear' },
    { icon: '$', title: '장비 소환', body: '램프/상자형 CTA를 같은 버튼 컴포넌트로 재사용합니다.', meta: 'CTA' },
  ],
  pet: [
    { icon: 'P', title: '펫 보유함', body: '전투 보조 펫, 채집 펫, 방치 보너스를 묶는 화면입니다.', meta: 'Pet' },
    { icon: '*', title: '성장 보너스', body: '펫 레벨과 별 등급을 리스트 행으로 표현합니다.', meta: 'Buff' },
  ],
  adventure: [
    { icon: 'M', title: '모험 지도', body: '던전, 이벤트, 랭킹 맵 진입 모달로 확장할 수 있습니다.', meta: 'Map' },
    { icon: '!', title: '입장 조건', body: '티켓/전투력/선행 클리어 조건을 공통 Row로 표시합니다.', meta: 'Gate' },
  ],
};

const SHOP_PRODUCT_IDS = {
  ruby: [201501, 201502, 201503],
  limited: [201504, 201505, 201506],
};

const SHOP_FALLBACK_PRODUCTS = {
  ruby: [
    { id: 201501, title: '루비 400', amount: 400, priceWon: 3300 },
    { id: 201502, title: '루비 1,200', amount: 1200, priceWon: 9900, badge: '20% 추가' },
    { id: 201503, title: '루비 3,000', amount: 3000, priceWon: 22000, badge: '33% 추가' },
  ],
  limited: [
    { id: 201504, icon: 'EQ', title: '장비 부스터 팩', body: '장비와 강화 재료 즉시 지급', priceWon: 11000 },
    { id: 201505, icon: 'AD', title: '광고 제거권', body: '모든 광고 즉시 제거', priceWon: 6600 },
    { id: 201506, icon: '2x', title: '배속권', body: '7일간 전투 속도 2배', priceWon: 5500 },
  ],
};

const SHOP_ICON_PATHS = {
  201501: 'assets/ui/icons/shop/shop_icon_ruby_400.png',
  201502: 'assets/ui/icons/shop/shop_icon_ruby_1200.png',
  201503: 'assets/ui/icons/shop/shop_icon_ruby_3000.png',
  201504: 'assets/ui/icons/shop/shop_icon_equipment_booster.png',
  201505: 'assets/ui/icons/shop/shop_icon_ad_removal.png',
  201506: 'assets/ui/icons/shop/shop_icon_speed_pass.png',
};

const WEEKDAY_BANNER_KEYS = {
  degulRock: 'weekday-banner-degul-rock',
  slimeQueen: 'weekday-banner-slime-queen',
  hotragon: 'weekday-banner-hotragon',
};

const WEEKDAY_BANNER_PATHS = {
  [WEEKDAY_BANNER_KEYS.degulRock]: 'assets/ui/banners/IMG_BANNER_DungeonList_DegulRock.png',
  [WEEKDAY_BANNER_KEYS.slimeQueen]: 'assets/ui/banners/IMG_BANNER_DungeonList_SlimeQueen.png',
  [WEEKDAY_BANNER_KEYS.hotragon]: 'assets/ui/banners/IMG_BANNER_DungeonList_Hotragon.png',
};
const SKILL_ICON_PATHS = [
  'assets/ui/icons/skills/skill_ham_seed_pop.png',
  'assets/ui/icons/skills/skill_ham_cheek_pouch_burst.png',
  'assets/ui/icons/skills/skill_ham_front_teeth_slam.png',
  'assets/ui/icons/skills/skill_ham_snack_awakening.png',
  'assets/ui/icons/skills/skill_ham_wheel_whirlwind.png',
  'assets/ui/icons/skills/skill_ham_walnut_crush.png',
  'assets/ui/icons/skills/skill_ham_moon_wheel.png',
  'assets/ui/icons/skills/skill_ham_bedding_rain.png',
  'assets/ui/icons/skills/skill_ham_cheek_rage.png',
  'assets/ui/icons/skills/skill_ham_star_candy_meteor.png',
  'assets/ui/icons/skills/skill_ham_stampede.png',
  'assets/ui/icons/skills/skill_ham_golden_cheek_pouch.png',
];

const SKILL_TREE_NODE_LAYOUT = {
  Root: { x: 0.5, y: 0.1, tier: 'core' },
  AoE: { x: 0.18, y: 0.27, tier: 'attack' },
  Boss: { x: 0.82, y: 0.27, tier: 'attack' },
  Buff: { x: 0.5, y: 0.4, tier: 'support' },
  AoE2: { x: 0.16, y: 0.52, tier: 'attack' },
  Boss2: { x: 0.84, y: 0.52, tier: 'attack' },
  Merge: { x: 0.5, y: 0.63, tier: 'merge' },
  Rain: { x: 0.22, y: 0.73, tier: 'rare' },
  Rage: { x: 0.78, y: 0.73, tier: 'rare' },
  Meteor: { x: 0.5, y: 0.86, tier: 'ultimate' },
  Overrun: { x: 0.24, y: 1.0, tier: 'rare' },
  Ultimate: { x: 0.76, y: 1.0, tier: 'ultimate' },
};

const SKILL_TREE_FALLBACK_LAYOUT = [
  { x: 0.5, y: 0.1, tier: 'core' },
  { x: 0.2, y: 0.27, tier: 'attack' },
  { x: 0.8, y: 0.27, tier: 'attack' },
  { x: 0.5, y: 0.4, tier: 'support' },
  { x: 0.18, y: 0.52, tier: 'normal' },
  { x: 0.82, y: 0.52, tier: 'normal' },
  { x: 0.5, y: 0.65, tier: 'merge' },
  { x: 0.22, y: 0.76, tier: 'rare' },
  { x: 0.78, y: 0.76, tier: 'rare' },
  { x: 0.5, y: 1.0, tier: 'ultimate' },
];

const SKILL_TREE_PRIMARY_PARENT_NODE = {
  AoE: 'Root',
  Boss: 'Root',
  Buff: 'Root',
  AoE2: 'AoE',
  Boss2: 'Boss',
  Merge: 'Buff',
  Rain: 'Merge',
  Rage: 'Merge',
  Meteor: 'Merge',
  Overrun: 'Meteor',
  Ultimate: 'Rage',
};

const ACHIEVEMENT_STAT_ITEM_IDS = new Set([1000, 1001, 1002, 1003]);
const ACHIEVEMENT_EQUIPMENT_SUMMON_PRODUCT_ID = 200503;
const ACHIEVEMENT_CATEGORIES = [
  { id: 'all', label: '전체', icon: 'A', accent: 0xf5ad25 },
  { id: 'level', label: '레벨', icon: 'LV', accent: 0x72c843 },
  { id: 'stat', label: '스탯', icon: '+', accent: 0xffd65d },
  { id: 'summon', label: '소환', icon: 'S', accent: 0xa967ff },
  { id: 'equipment', label: '장비', icon: 'G', accent: 0x7aa7ff },
  { id: 'weapon', label: '무기', icon: 'W', accent: 0xef4e45 },
  { id: 'combat', label: '전투', icon: '!', accent: 0xff8fb3 },
];

const WEEKDAY_DUNGEONS = [
  {
    day: '월',
    title: '황금광산',
    mapId: 500301,
    group: 500301,
    icon: '$',
    accent: 0xf5ad25,
    enemy: '황금 데굴록',
    focus: '공속·공격',
    feature: '약한 몬스터 다수. 자동전투 처치 속도를 봅니다.',
    description: '황금 데굴록이 짧은 웨이브로 몰려옵니다. 공격력과 공격속도가 높을수록 처치 속도가 빨라지고, 골드 수급이 안정되는 던전입니다.',
    reward: '골드',
    asset: 'DegulRock',
    bannerKey: WEEKDAY_BANNER_KEYS.degulRock,
  },
  {
    day: '화',
    title: '강철제련소',
    mapId: 500302,
    group: 500302,
    icon: 'D',
    accent: 0x9aa7b7,
    enemy: '강철 방패 오니',
    focus: '공격·치피',
    feature: '단단한 몬스터를 상대하며 방어 돌파력을 봅니다.',
    description: '강철 방패 오니는 수는 적지만 체력과 방어가 높습니다. 한 방의 공격력과 치명피해가 충분한지 확인하고, 장비 강화 재료를 챙기는 던전입니다.',
    reward: '강화 재료',
    asset: 'large_melee_oni_shield_red',
    bannerKey: WEEKDAY_BANNER_KEYS.degulRock,
  },
  {
    day: '수',
    title: '비전사격장',
    mapId: 500303,
    group: 500303,
    icon: 'SK',
    accent: 0xa967ff,
    enemy: '비전 유령 궁수',
    focus: '스킬·원거리 대응',
    feature: '화면 중앙권에서 쏘는 원거리 몬스터를 상대합니다.',
    description: '비전 유령 궁수는 가까이 붙기 전부터 공격을 시작합니다. 스킬 화력과 빠른 정리 능력을 확인하고 스킬 성장 재료를 얻는 던전입니다.',
    reward: '스킬 재료',
    asset: 'ranged_ghost_bow_blue',
    bannerKey: WEEKDAY_BANNER_KEYS.slimeQueen,
  },
  {
    day: '목',
    title: '햄찌수련장',
    mapId: 500304,
    group: 500304,
    icon: 'XP',
    accent: 0x72c843,
    enemy: '수련 버섯곰',
    focus: '체력·방어',
    feature: '긴 전투로 생존력과 누적 피해량을 봅니다.',
    description: '수련 버섯곰은 전투를 길게 끌며 꾸준히 피해를 누적시킵니다. 체력과 방어가 버텨주는지, 장기전에서 딜이 밀리지 않는지 보는 경험치 던전입니다.',
    reward: '경험치',
    asset: 'large_melee_bear_brown',
    bannerKey: WEEKDAY_BANNER_KEYS.degulRock,
  },
  {
    day: '금',
    title: '행운젤리굴',
    mapId: 500305,
    group: 500305,
    icon: '*',
    accent: 0xffd96a,
    enemy: '행운 젤리해파리',
    focus: 'Luck·드랍',
    feature: '젤리 보상이 많은 드랍 기대값 던전입니다.',
    description: '행운 젤리해파리는 드랍 보상을 많이 노리는 던전입니다. Luck과 드랍 증가 세팅의 체감 효율을 확인하고 보상 상자를 노리는 날입니다.',
    reward: '슬라임 젤리',
    asset: 'melee_jellyfish_yellow',
    bannerKey: WEEKDAY_BANNER_KEYS.slimeQueen,
  },
  {
    day: '토',
    title: '닌자시험장',
    mapId: 500306,
    group: 500306,
    icon: '>>',
    accent: 0xef4e45,
    enemy: '질주 오니 총잡이',
    focus: '공속·쿨감',
    feature: '고속 원거리 압박으로 대응 속도를 봅니다.',
    description: '질주 오니 총잡이는 빠르게 자리를 잡고 연속 공격으로 전투를 압박합니다. 공격속도, 쿨감, 치명 세팅이 갖춰졌는지 확인하고 공속/치피 성장 보상을 노립니다.',
    reward: '공속/치피 성장',
    asset: 'ranged_oni_cowboy_red',
    bannerKey: WEEKDAY_BANNER_KEYS.hotragon,
  },
  {
    day: '일',
    title: '왕관전',
    mapId: 500307,
    group: 500307,
    icon: 'B',
    accent: 0xff8fb3,
    enemy: '왕관 포자 여왕',
    focus: '보스딜·생존',
    feature: '방패 수호자 뒤에 보스가 나오는 주간 정산전입니다.',
    description: '방패 수호자를 넘어서 왕관 포자 여왕을 쓰러뜨리는 보스전입니다. 보스딜, 생존력, 누적 성장 상태가 모두 필요하며 혼합 보상을 정산합니다.',
    reward: '혼합 보상',
    asset: 'dungeonboss_ranged_SlimeQueen',
    bannerKey: WEEKDAY_BANNER_KEYS.slimeQueen,
  },
];

export function preloadModalAssets(scene) {
  for (const [key, path] of Object.entries(UI_ASSET_PATHS)) {
    if (!scene.textures.exists(key)) scene.load.image(key, path);
  }
  for (const [key, path] of Object.entries(WEEKDAY_BANNER_PATHS)) {
    if (!scene.textures.exists(key)) scene.load.image(key, path);
  }
  for (const [productId, path] of Object.entries(SHOP_ICON_PATHS)) {
    const key = shopIconTextureKey(productId);
    if (!scene.textures.exists(key)) scene.load.image(key, path);
  }
  for (const path of SKILL_ICON_PATHS) {
    const key = textureKeyForAssetPath(path);
    if (!scene.textures.exists(key)) scene.load.image(key, path);
  }
}

export async function attachModalSystem({ board, store, messages, hostId = 'modalStage' }) {
  const { scene, game, element } = await createModalOverlayScene(hostId);
  const manager = new ModalManager(scene, { board, store, messages }, { overlayGame: game, overlayElement: element });
  manager.bindDom(document);
  globalThis.__MUSHROOMER_PHASER_MODALS__ = manager;
  return manager;
}

export class IdlezModalScene extends PhaserScene {
  constructor() {
    super('IdlezModalScene');
  }

  preload() {
    preloadModalAssets(this);
  }

  create() {
    globalThis.dispatchEvent(new CustomEvent('mushroomer-modal-scene-ready', { detail: { scene: this } }));
  }
}

export class ModalManager {
  constructor(scene, context = {}, options = {}) {
    this.scene = scene;
    this.context = context;
    this.overlayGame = options.overlayGame || null;
    this.overlayElement = options.overlayElement || null;
    this.registry = new Map();
    this.instances = new Map();
    this.current = null;

    this.#registerDefaults();

    this.keyHandler = event => {
      if (event.key === 'Escape') this.closeCurrent();
    };
    this.signalHandler = event => {
      const detail = event.detail;
      const id = typeof detail === 'string' ? detail : detail?.id;
      if (id) this.open(id, typeof detail === 'object' ? detail.payload : undefined);
    };

    globalThis.addEventListener('keydown', this.keyHandler);
    globalThis.addEventListener('mushroomer:open-modal', this.signalHandler);
  }

  register(id, ModalType, options = {}) {
    this.registry.set(id, { ModalType, options });
    return this;
  }

  open(id, payload = {}) {
    const modal = this.#modalFor(id);
    if (!modal) return null;

    if (this.current && this.current !== modal) this.current.close({ immediate: true });
    this.current = modal;
    this.#setOverlayActive(true);
    modal.open(payload);
    return modal;
  }

  closeCurrent(options = {}) {
    if (!this.current) return;
    this.current.close(options);
    this.current = null;
  }

  bindDom(root = document) {
    root.querySelectorAll('[data-modal-id]').forEach(node => {
      if (node.dataset.modalBound === 'true') return;
      node.dataset.modalBound = 'true';
      node.addEventListener('click', event => {
        event.preventDefault();
        if (node.classList.contains('tab')) {
          node.parentElement?.querySelectorAll('.tab').forEach(tab => {
            tab.classList.toggle('active', tab === node);
          });
        }
        this.open(node.dataset.modalId, { source: node });
      });
    });
  }

  destroy() {
    this.closeCurrent({ immediate: true });
    for (const modal of this.instances.values()) modal.destroy();
    this.instances.clear();
    this.overlayGame?.destroy(true);
    globalThis.removeEventListener('keydown', this.keyHandler);
    globalThis.removeEventListener('mushroomer:open-modal', this.signalHandler);
  }

  handleModalClosed(modal) {
    if (this.current === modal) this.current = null;
    if (!this.current) this.#setOverlayActive(false);
  }

  #modalFor(id) {
    const entry = this.registry.get(id);
    if (!entry) {
      console.warn(`[ModalManager] Unknown modal id: ${id}`);
      return null;
    }

    if (!this.instances.has(id)) {
      this.instances.set(id, new entry.ModalType(this, entry.options));
    }
    return this.instances.get(id);
  }

  #registerDefaults() {
    this.register('quests', QuestModal, {
      title: '퀘스트',
      kicker: '전투 목표와 현재 진행',
    });
    this.register('rewards', RewardModal, {
      title: '보상',
      kicker: '전투 드롭과 성장 보상',
    });
    this.register('growthReward', RewardModal, {
      title: '성장 보상',
      kicker: '지금 받을 수 있는 누적 보상',
    });
    this.register('weekdayDungeon', WeekdayDungeonModal, {
      title: '요일던전',
      kicker: '오늘 열린 던전',
    });
    this.register('skills', SkillTreeModal, {
      title: '스킬',
      kicker: '',
      variant: 'skillTreeSheet',
      heightRatio: 0.985,
      minHeight: 640,
      maxHeight: 940,
      footerHeight: 10,
      headerBodyOffset: 84,
      verticalMarginMin: 4,
      verticalMarginMax: 10,
    });
    this.register('achievements', AchievementModal, {
      title: '업적',
      kicker: '성장 목표와 자동 보상',
      heightRatio: 0.86,
      minHeight: 560,
      maxHeight: 780,
      verticalMarginMin: 16,
      verticalMarginMax: 32,
    });
    this.register('shop', ShopModal, {
      title: '상점',
      kicker: '',
      variant: 'shopSheet',
      anchor: 'bottom',
      backdropAlpha: 0.28,
      widthRatio: 0.985,
      minSideMargin: 6,
      maxSideMargin: 10,
      contentInsetRatio: 0.042,
      contentInsetMin: 16,
      contentInsetMax: 22,
      heightRatio: 0.66,
      minHeight: 548,
      maxHeight: 590,
      bottomMargin: 76,
      footerHeight: 0,
      headerBodyOffset: 88,
      verticalMarginMin: 8,
      verticalMarginMax: 18,
    });
    this.register('settings', SettingsModal, {
      title: '설정',
      kicker: '사운드 · 언어 · 계정',
    });

    for (const [id, rows] of Object.entries(FEATURE_MODAL_ROWS)) {
      this.register(id, FeatureListModal, {
        title: featureTitle(id),
        kicker: '공통 리스트 모달 컴포넌트',
        rows,
      });
    }
  }

  #setOverlayActive(active) {
    this.overlayElement?.classList.toggle('is-active', active);
    this.overlayElement?.setAttribute('aria-hidden', active ? 'false' : 'true');
  }
}

class DesignButton extends PhaserContainer {
  constructor(scene, {
    x = 0,
    y = 0,
    width = 160,
    height = 52,
    label = 'OK',
    style = 'wood',
    fontSize = null,
    onClick = null,
  } = {}) {
    super(scene, x, y);
    this.buttonWidth = width;
    this.buttonHeight = height;
    this.label = label;
    this.style = style;
    this.fontSize = fontSize;
    this.onClick = onClick;
    this.isPressed = false;

    this.bg = makeGraphics(scene);
    this.imagePieces = [];
    this.labelText = makeText(scene, 0, 0, label, modalTextStyle(style === 'close' ? 'close' : 'button'));
    this.labelText.setOrigin(0.5);
    this.hitTarget = makeRectangle(scene, -width / 2, -height / 2, width, height, 0xffffff, 0.001)
      .setOrigin(0);
    this.add([this.bg, this.labelText, this.hitTarget]);

    this.#bindInput();
    this.redraw();
  }

  setLayout({ x = this.x, y = this.y, width = this.buttonWidth, height = this.buttonHeight } = {}) {
    this.setPosition(x, y);
    this.buttonWidth = width;
    this.buttonHeight = height;
    this.redraw();
    return this;
  }

  redraw() {
    const Phaser = globalThis.Phaser;
    const texture = textureForButtonStyle(this.style, this.isPressed);
    this.setSize(this.buttonWidth, this.buttonHeight);
    this.hitTarget
      .setPosition(-this.buttonWidth / 2, -this.buttonHeight / 2)
      .setSize(this.buttonWidth, this.buttonHeight)
      .setDisplaySize(this.buttonWidth, this.buttonHeight);

    if (texture && this.scene.textures.exists(texture)) {
      this.#drawSlicedTexture(texture);
      this.bg.clear();
    } else {
      this.#clearImagePieces();
      this.#drawFallbackButton();
    }

    this.labelText
      .setText(this.label)
      .setStyle(modalTextStyle(this.style === 'close' ? 'close' : 'button', {
        fontSize: this.fontSize || (this.buttonHeight < 44 ? '14px' : '16px'),
        wordWrap: { width: this.buttonWidth - 26, useAdvancedWrap: true },
      }))
      .setPosition(0, -2);

    if (Phaser?.Geom?.Rectangle) {
      this.hitTarget.setInteractive(
        new Phaser.Geom.Rectangle(0, 0, this.buttonWidth, this.buttonHeight),
        Phaser.Geom.Rectangle.Contains,
      );
    }
  }

  #bindInput() {
    this.hitTarget.on('pointerdown', () => this.#press());
    this.hitTarget.on('pointerout', () => this.#release(false));
    this.hitTarget.on('pointerup', () => this.#release(true));
  }

  #press() {
    if (this.isPressed) return;
    playSfx('uiClick');
    this.isPressed = true;
    this.y += 2;
    this.redraw();
  }

  #release(activate) {
    if (!this.isPressed) return;
    this.isPressed = false;
    this.y -= 2;
    this.redraw();
    if (activate) this.onClick?.();
  }

  #clearImagePieces() {
    for (const piece of this.imagePieces) piece.destroy();
    this.imagePieces = [];
  }

  #drawSlicedTexture(textureKey) {
    this.#clearImagePieces();

    const texture = this.scene.textures.get(textureKey);
    const source = texture?.getSourceImage?.() || texture?.source?.[0]?.image || texture?.frames?.__BASE;
    const sourceWidth = source?.width || texture?.get?.()?.width || 1;
    const sourceHeight = source?.height || texture?.get?.()?.height || 1;
    if (!source || !this.scene.textures.createCanvas) {
      this.#drawFallbackButton();
      return;
    }

    const spec = BUTTON_SLICE_SPECS[textureKey] || {
      left: Math.floor(sourceWidth * 0.24),
      right: Math.floor(sourceWidth * 0.24),
      top: Math.floor(sourceHeight * 0.28),
      bottom: Math.floor(sourceHeight * 0.28),
      edgeX: 22,
      edgeY: 16,
    };

    const width = Math.max(1, Math.round(this.buttonWidth));
    const height = Math.max(1, Math.round(this.buttonHeight));
    const renderKey = `modal-button-${textureKey}-${width}x${height}`;
    if (!this.scene.textures.exists(renderKey)) {
      const trim = {
        x: spec.trimX ?? 8,
        y: spec.trimY ?? 8,
        width: spec.trimWidth ?? Math.max(1, sourceWidth - 16),
        height: spec.trimHeight ?? Math.max(1, sourceHeight - 16),
      };
      const srcLeft = Math.round(clamp(spec.left, 1, Math.floor(trim.width / 2) - 1));
      const srcRight = Math.round(clamp(spec.right, 1, Math.floor(trim.width / 2) - 1));
      const srcTop = Math.round(clamp(spec.top, 1, Math.floor(trim.height / 2) - 1));
      const srcBottom = Math.round(clamp(spec.bottom, 1, Math.floor(trim.height / 2) - 1));
      const dstLeft = Math.round(clamp(spec.edgeX, 8, Math.max(8, width * 0.34)));
      const dstRight = Math.round(clamp(spec.edgeX, 8, Math.max(8, width * 0.34)));
      const dstTop = Math.round(clamp(spec.edgeY, 7, Math.max(7, height * 0.45)));
      const dstBottom = Math.round(clamp(spec.edgeY, 7, Math.max(7, height * 0.45)));
      const srcCenterWidth = Math.max(1, trim.width - srcLeft - srcRight);
      const srcCenterHeight = Math.max(1, trim.height - srcTop - srcBottom);
      const dstCenterWidth = Math.max(1, width - dstLeft - dstRight);
      const dstCenterHeight = Math.max(1, height - dstTop - dstBottom);
      const canvasTexture = this.scene.textures.createCanvas(renderKey, width, height);
      const canvas = canvasTexture.getSourceImage();
      const ctx = canvas.getContext('2d');

      const draw = (sx, sy, sw, sh, dx, dy, dw, dh) => {
        if (sw <= 0 || sh <= 0 || dw <= 0 || dh <= 0) return;
        ctx.drawImage(source, sx, sy, sw, sh, dx, dy, dw, dh);
      };
      const sx0 = trim.x;
      const sy0 = trim.y;
      const sx1 = trim.x + srcLeft;
      const sy1 = trim.y + srcTop;
      const sx2 = trim.x + trim.width - srcRight;
      const sy2 = trim.y + trim.height - srcBottom;

      ctx.clearRect(0, 0, width, height);
      draw(sx0, sy0, srcLeft, srcTop, 0, 0, dstLeft, dstTop);
      draw(sx1, sy0, srcCenterWidth, srcTop, dstLeft, 0, dstCenterWidth, dstTop);
      draw(sx2, sy0, srcRight, srcTop, dstLeft + dstCenterWidth, 0, dstRight, dstTop);
      draw(sx0, sy1, srcLeft, srcCenterHeight, 0, dstTop, dstLeft, dstCenterHeight);
      draw(sx1, sy1, srcCenterWidth, srcCenterHeight, dstLeft, dstTop, dstCenterWidth, dstCenterHeight);
      draw(sx2, sy1, srcRight, srcCenterHeight, dstLeft + dstCenterWidth, dstTop, dstRight, dstCenterHeight);
      draw(sx0, sy2, srcLeft, srcBottom, 0, dstTop + dstCenterHeight, dstLeft, dstBottom);
      draw(sx1, sy2, srcCenterWidth, srcBottom, dstLeft, dstTop + dstCenterHeight, dstCenterWidth, dstBottom);
      draw(sx2, sy2, srcRight, srcBottom, dstLeft + dstCenterWidth, dstTop + dstCenterHeight, dstRight, dstBottom);
      canvasTexture.refresh();
    }

    const image = makeImage(this.scene, 0, 0, renderKey)
      .setOrigin(0.5)
      .setDisplaySize(width, height);
    this.imagePieces.push(image);
    this.addAt(image, 0);
  }

  #drawFallbackButton() {
    const { colors } = PHASER_DESIGN;
    const g = this.bg;
    const x = -this.buttonWidth / 2;
    const y = -this.buttonHeight / 2;
    const radius = Math.min(18, this.buttonHeight / 2);
    const isGreen = this.style === 'green';
    const isPrimary = this.style === 'primary';
    const top = isGreen ? 0xabea62 : isPrimary ? 0xffd65d : colors.woodLight;
    const low = isGreen ? colors.greenDark : isPrimary ? 0xcf6f12 : colors.woodDark;

    g.clear();
    g.fillStyle(colors.shadow, 0.42);
    g.fillRoundedRect(x + 3, y + 5, this.buttonWidth, this.buttonHeight, radius);
    g.fillStyle(colors.outlineBrown, 1);
    g.fillRoundedRect(x, y, this.buttonWidth, this.buttonHeight, radius);
    g.fillStyle(low, 1);
    g.fillRoundedRect(x + 4, y + 4, this.buttonWidth - 8, this.buttonHeight - 8, radius - 3);
    g.fillStyle(top, 0.82);
    g.fillRoundedRect(x + 7, y + 7, this.buttonWidth - 14, Math.max(10, this.buttonHeight * 0.42), radius - 6);
  }
}

class ShopPurchaseButton extends PhaserContainer {
  constructor(scene, {
    x = 0,
    y = 0,
    width = 96,
    height = 34,
    label = '구매',
    fontSize = null,
    onClick = null,
  } = {}) {
    super(scene, x, y);
    this.buttonWidth = width;
    this.buttonHeight = height;
    this.label = label;
    this.fontSize = fontSize;
    this.onClick = onClick;
    this.isPressed = false;

    this.bg = makeGraphics(scene);
    this.medallionText = makeText(scene, 0, 0, '₩', modalTextStyle('button', {
      fontSize: '10px',
      strokeThickness: 2,
    })).setOrigin(0.5);
    this.labelText = makeText(scene, 0, 0, label, modalTextStyle('button')).setOrigin(0.5);
    this.hitTarget = makeRectangle(scene, -width / 2, -height / 2, width, height, 0xffffff, 0.001)
      .setOrigin(0);
    this.add([this.bg, this.medallionText, this.labelText, this.hitTarget]);

    this.#bindInput();
    this.redraw();
  }

  redraw() {
    const Phaser = globalThis.Phaser;
    const { colors } = PHASER_DESIGN;
    const width = this.buttonWidth;
    const height = this.buttonHeight;
    const x = -width / 2;
    const y = -height / 2;
    const radius = Math.min(14, Math.floor(height / 2));
    const showMedallion = false;

    this.bg.clear();
    this.bg.fillStyle(colors.shadow, 0.36);
    this.bg.fillRoundedRect(x + 2, y + 4, width, height, radius);
    this.bg.fillStyle(colors.outlineBrown, 1);
    this.bg.fillRoundedRect(x, y, width, height, radius);
    this.bg.fillStyle(colors.gold, 1);
    this.bg.fillRoundedRect(x + 3, y + 3, width - 6, height - 6, Math.max(1, radius - 2));
    this.bg.fillStyle(colors.greenDark, 1);
    this.bg.fillRoundedRect(x + 6, y + 6, width - 12, height - 12, Math.max(1, radius - 5));
    this.bg.fillStyle(0x73bd36, 1);
    this.bg.fillRoundedRect(x + 8, y + 7, width - 16, height - 16, Math.max(1, radius - 7));
    this.bg.fillStyle(0xb8ef65, 0.78);
    this.bg.fillRoundedRect(x + 13, y + 8, width - 26, Math.max(7, height * 0.28), 8);
    this.bg.lineStyle(2, 0x234f13, 0.85);
    this.bg.strokeRoundedRect(x + 6, y + 6, width - 12, height - 12, Math.max(1, radius - 5));

    if (showMedallion) {
      const cx = x + medallionRadius + 8;
      this.bg.fillStyle(colors.outlineBrown, 1);
      this.bg.fillCircle(cx, -1, medallionRadius + 2);
      this.bg.fillStyle(colors.goldHighlight, 1);
      this.bg.fillCircle(cx, -1, medallionRadius);
      this.bg.fillStyle(colors.gold, 0.72);
      this.bg.fillCircle(cx - 2, -3, Math.max(3, medallionRadius - 4));
      this.medallionText
        .setVisible(true)
        .setPosition(cx, -2);
    } else {
      this.medallionText.setVisible(false);
    }

    this.labelText
      .setText(this.label)
      .setStyle(modalTextStyle('button', {
        fontSize: this.fontSize || (this.label.length > 4 ? '12px' : '14px'),
        strokeThickness: 3,
        wordWrap: { width: width + 20, useAdvancedWrap: false },
      }))
      .setPosition(showMedallion ? 8 : 0, -2);

    this.hitTarget
      .setPosition(-width / 2, -height / 2)
      .setSize(width, height)
      .setDisplaySize(width, height);

    if (Phaser?.Geom?.Rectangle) {
      this.hitTarget.setInteractive(
        new Phaser.Geom.Rectangle(0, 0, width, height),
        Phaser.Geom.Rectangle.Contains,
      );
    }
  }

  #bindInput() {
    this.hitTarget.on('pointerdown', () => this.#press());
    this.hitTarget.on('pointerout', () => this.#release(false));
    this.hitTarget.on('pointerup', () => this.#release(true));
  }

  #press() {
    if (this.isPressed) return;
    playSfx('uiClick');
    this.isPressed = true;
    this.y += 2;
    this.redraw();
  }

  #release(activate) {
    if (!this.isPressed) return;
    this.isPressed = false;
    this.y -= 2;
    this.redraw();
    if (activate) this.onClick?.();
  }
}

class ModalListRow extends PhaserContainer {
  constructor(scene, { x, y, width, height = 62, icon = '*', title = '', body = '', meta = '' }) {
    super(scene, x, y);
    this.rowWidth = width;
    this.rowHeight = height;
    this.data = { icon, title, body, meta };

    this.bg = makeGraphics(scene);
    this.iconText = makeText(scene, 0, 0, icon, modalTextStyle('button', { fontSize: '14px', strokeThickness: 3 }));
    this.titleText = makeText(scene, 0, 0, title, modalTextStyle('rowTitle'));
    this.bodyText = makeText(scene, 0, 0, body, modalTextStyle('rowBody'));
    this.metaText = makeText(scene, 0, 0, meta, modalTextStyle('rowBody', { fontSize: '12px', color: '#fff7dd', align: 'center' }));
    this.add([this.bg, this.iconText, this.titleText, this.bodyText, this.metaText]);
    this.redraw();
  }

  redraw() {
    const { colors } = PHASER_DESIGN;
    const g = this.bg;
    g.clear();
    g.fillStyle(colors.outlineBrown, 0.26);
    g.fillRoundedRect(0, 3, this.rowWidth, this.rowHeight, 15);
    g.fillStyle(colors.cream, 1);
    g.fillRoundedRect(0, 0, this.rowWidth, this.rowHeight, 15);
    g.lineStyle(3, colors.parchmentShadow, 0.75);
    g.strokeRoundedRect(2, 2, this.rowWidth - 4, this.rowHeight - 4, 13);

    g.fillStyle(colors.outlineBrown, 1);
    g.fillCircle(32, this.rowHeight / 2, 20);
    g.fillStyle(colors.gold, 1);
    g.fillCircle(32, this.rowHeight / 2, 16);

    this.iconText.setOrigin(0.5).setPosition(32, this.rowHeight / 2 - 1);
    this.titleText
      .setPosition(62, 10)
      .setWordWrapWidth(Math.max(120, this.rowWidth - 155), true);
    this.bodyText
      .setPosition(62, 33)
      .setWordWrapWidth(Math.max(120, this.rowWidth - 155), true);

    if (this.data.meta) {
      const metaWidth = 62;
      g.fillStyle(colors.woodMid, 1);
      g.fillRoundedRect(this.rowWidth - metaWidth - 12, this.rowHeight / 2 - 15, metaWidth, 30, 15);
      this.metaText
        .setVisible(true)
        .setOrigin(0.5)
        .setPosition(this.rowWidth - metaWidth / 2 - 12, this.rowHeight / 2 - 1)
        .setWordWrapWidth(metaWidth - 8, true);
    } else {
      this.metaText.setVisible(false);
    }
  }
}

class BaseModal extends PhaserContainer {
  constructor(manager, options = {}) {
    super(manager.scene, 0, 0);
    this.manager = manager;
    this.scene = manager.scene;
    this.options = {
      title: '알림',
      kicker: '',
      closeOnBackdrop: true,
      ...options,
    };
    this.payload = {};
    this.metrics = null;

    this.backdrop = makeRectangle(this.scene, 0, 0, 1, 1, 0x120601, 0.58).setOrigin(0);
    this.frame = makeGraphics(this.scene);
    this.titleText = makeText(this.scene, 0, 0, this.options.title, modalTextStyle('title')).setOrigin(0.5);
    this.kickerText = makeText(this.scene, 0, 0, this.options.kicker, modalTextStyle('kicker')).setOrigin(0.5);
    this.body = makeContainer(this.scene, 0, 0);
    this.actions = makeContainer(this.scene, 0, 0);
    this.closeButton = new DesignButton(this.scene, {
      width: 42,
      height: 42,
      label: 'X',
      style: 'wood',
      onClick: () => this.close(),
    });

    this.add([this.backdrop, this.frame, this.titleText, this.kickerText, this.body, this.actions, this.closeButton]);
    this.scene.add.existing(this);
    this.setDepth(PHASER_DESIGN.zOrder.modalPopups).setVisible(false).setAlpha(0);

    this.backdrop.setInteractive().on('pointerup', () => {
      if (this.options.closeOnBackdrop) {
        playSfx('uiClick', { volume: 0.62 });
        this.close();
      }
    });

    this.resizeHandler = () => {
      if (this.visible) this.rebuild();
    };
    this.scene.scale.on('resize', this.resizeHandler);
  }

  open(payload = {}) {
    this.payload = payload || {};
    this.rebuild();
    this.setVisible(true).setAlpha(1);
    this.scene.tweens.killTweensOf(this);
  }

  close({ immediate = false } = {}) {
    if (!this.visible) return;
    this.scene.tweens.killTweensOf(this);

    this.setVisible(false).setAlpha(0);
    this.manager.handleModalClosed(this);
  }

  rebuild() {
    this.metrics = this.#measure();
    this.body.removeAll(true);
    this.actions.removeAll(true);
    this.#drawShell(this.metrics);
    this.buildBody(this.metrics);
    this.buildActions(this.metrics);
  }

  buildBody() {}

  buildActions(metrics) {
    const actions = this.resolveActions();
    if (!actions.length) return;

    const gap = 14;
    const buttonHeight = 54;
    const totalGap = gap * (actions.length - 1);
    const buttonWidth = Math.floor((metrics.innerWidth - totalGap) / actions.length);
    const y = metrics.y + metrics.height - 45;
    let x = metrics.x + metrics.contentInset + buttonWidth / 2;

    for (const action of actions) {
      const button = new DesignButton(this.scene, {
        x,
        y,
        width: buttonWidth,
        height: buttonHeight,
        label: action.label,
        style: action.style || 'primary',
        onClick: action.onClick || (() => this.close()),
      });
      this.actions.add(button);
      x += buttonWidth + gap;
    }
  }

  resolveActions() {
    return [{ label: '확인', style: 'primary', onClick: () => this.close() }];
  }

  destroy(fromScene) {
    this.scene.scale.off('resize', this.resizeHandler);
    super.destroy(fromScene);
  }

  #measure() {
    const width = this.scene.scale.width;
    const height = this.scene.scale.height;
    const config = PHASER_DESIGN.modal;
    const sideMargin = Math.round(clamp(
      width * (this.options.sideMarginRatio ?? 0.055),
      this.options.minSideMargin ?? config.minSideMargin,
      this.options.maxSideMargin ?? config.maxSideMargin,
    ));
    const maxModalWidth = Math.max(1, Math.min(config.maxWidth, width - sideMargin * 2));
    const minModalWidth = Math.min(config.minWidth, maxModalWidth);
    const modalWidth = Math.round(clamp(width * (this.options.widthRatio ?? config.widthRatio), minModalWidth, maxModalWidth));
    const verticalMargin = Math.round(clamp(
      height * (this.options.verticalMarginRatio ?? 0.055),
      this.options.verticalMarginMin ?? 28,
      this.options.verticalMarginMax ?? 48,
    ));
    const bottomMargin = Math.round(this.options.bottomMargin ?? verticalMargin);
    const availableHeight = this.options.anchor === 'bottom'
      ? height - verticalMargin - bottomMargin
      : height - verticalMargin * 2;
    const maxModalHeight = Math.max(1, Math.min(this.options.maxHeight ?? 580, availableHeight));
    const minModalHeight = Math.min(this.options.minHeight ?? 420, maxModalHeight);
    const modalHeight = Math.round(clamp(height * (this.options.heightRatio ?? 0.7), minModalHeight, maxModalHeight));
    const x = Math.round((width - modalWidth) / 2);
    const y = this.options.anchor === 'bottom'
      ? Math.round(height - modalHeight - bottomMargin)
      : Math.round((height - modalHeight) / 2);
    const contentInset = Math.round(clamp(
      modalWidth * (this.options.contentInsetRatio ?? 0.065),
      this.options.contentInsetMin ?? config.contentInsetMin,
      this.options.contentInsetMax ?? config.contentInsetMax,
    ));
    const panelInset = Math.max(16, contentInset - 6);
    const footerHeight = this.options.footerHeight ?? PHASER_DESIGN.modal.footerHeight;
    const headerBottom = y + (this.options.headerBodyOffset ?? 112);
    const footerTop = y + modalHeight - footerHeight - 10;

    return {
      sceneWidth: width,
      sceneHeight: height,
      x,
      y,
      width: modalWidth,
      height: modalHeight,
      contentInset,
      panelInset,
      innerX: x + contentInset,
      innerY: headerBottom,
      innerWidth: modalWidth - contentInset * 2,
      bodyHeight: footerTop - headerBottom,
      footerTop,
    };
  }

  #drawShell(metrics) {
    const { colors } = PHASER_DESIGN;
    const g = this.frame;
    const r = PHASER_DESIGN.modal.radius;

    this.backdrop
      .setFillStyle(0x120601, this.options.backdropAlpha ?? 0.58)
      .setDisplaySize(metrics.sceneWidth, metrics.sceneHeight);
    g.clear();

    if (this.options.variant === 'shopSheet') {
      this.#drawShopSheetShell(metrics, g, colors);
      return;
    }
    if (this.options.variant === 'skillTreeSheet') {
      this.#drawSkillTreeSheetShell(metrics, g, colors);
      return;
    }

    g.fillStyle(colors.shadow, 0.5);
    g.fillRoundedRect(metrics.x + 9, metrics.y + 12, metrics.width, metrics.height, r);
    g.fillStyle(colors.outlineBrown, 1);
    g.fillRoundedRect(metrics.x, metrics.y, metrics.width, metrics.height, r);
    g.fillStyle(colors.woodMid, 1);
    g.fillRoundedRect(metrics.x + 8, metrics.y + 8, metrics.width - 16, metrics.height - 16, r - 5);
    g.fillStyle(colors.woodDark, 0.74);
    g.fillRoundedRect(metrics.x + metrics.panelInset - 6, metrics.y + 74, metrics.width - (metrics.panelInset - 6) * 2, metrics.height - 154, 22);
    g.fillStyle(colors.parchment, 1);
    g.fillRoundedRect(metrics.x + metrics.panelInset, metrics.y + 82, metrics.width - metrics.panelInset * 2, metrics.height - 170, 18);
    g.lineStyle(4, colors.line, 0.55);
    g.strokeRoundedRect(metrics.x + metrics.panelInset, metrics.y + 82, metrics.width - metrics.panelInset * 2, metrics.height - 170, 18);

    const titlePillMax = Math.max(168, Math.min(250, metrics.width - 118));
    const titlePillMin = Math.min(188, titlePillMax);
    const titlePillWidth = Math.round(clamp(metrics.width * 0.58, titlePillMin, titlePillMax));
    const titlePillHeight = 50;
    const titlePillX = Math.round(metrics.x + (metrics.width - titlePillWidth) / 2);
    const titlePillY = metrics.y + 18;
    g.fillStyle(colors.gold, 1);
    g.fillRoundedRect(titlePillX, titlePillY, titlePillWidth, titlePillHeight, 21);
    g.fillStyle(colors.goldHighlight, 0.72);
    g.fillRoundedRect(titlePillX + 15, titlePillY + 7, titlePillWidth - 30, 18, 11);
    g.lineStyle(5, colors.line, 0.75);
    g.strokeRoundedRect(titlePillX, titlePillY, titlePillWidth, titlePillHeight, 21);

    this.titleText
      .setText(this.options.title)
      .setStyle(modalTextStyle('title', { fontSize: '25px', strokeThickness: 5 }))
      .setPosition(metrics.x + metrics.width / 2, titlePillY + titlePillHeight / 2 + 2);
    this.kickerText
      .setText(this.options.kicker || '')
      .setVisible(Boolean(this.options.kicker))
      .setPosition(metrics.x + metrics.width / 2, metrics.y + 91);
    const closeSize = Math.round(clamp(metrics.width * 0.1, 38, 42));
    this.closeButton.setLayout({
      x: metrics.x + metrics.width - Math.max(36, metrics.contentInset + 12),
      y: metrics.y + 42,
      width: closeSize,
      height: closeSize,
    });
  }

  #drawSkillTreeSheetShell(metrics, g, colors) {
    const r = PHASER_DESIGN.modal.radius;
    const panelY = metrics.y + 76;
    const panelHeight = metrics.height - 92;

    g.fillStyle(colors.shadow, 0.5);
    g.fillRoundedRect(metrics.x + 9, metrics.y + 12, metrics.width, metrics.height, r);
    g.fillStyle(colors.outlineBrown, 1);
    g.fillRoundedRect(metrics.x, metrics.y, metrics.width, metrics.height, r);
    g.fillStyle(colors.woodMid, 1);
    g.fillRoundedRect(metrics.x + 8, metrics.y + 8, metrics.width - 16, metrics.height - 16, r - 5);
    g.fillStyle(colors.woodDark, 0.82);
    g.fillRoundedRect(metrics.x + metrics.panelInset - 7, panelY - 3, metrics.width - (metrics.panelInset - 7) * 2, panelHeight + 6, 23);
    g.fillStyle(colors.parchment, 1);
    g.fillRoundedRect(metrics.x + metrics.panelInset, panelY + 5, metrics.width - metrics.panelInset * 2, panelHeight - 8, 19);
    g.fillStyle(0xfff7dd, 0.72);
    g.fillRoundedRect(metrics.x + metrics.panelInset + 10, panelY + 13, metrics.width - metrics.panelInset * 2 - 20, 25, 14);
    g.lineStyle(4, colors.line, 0.55);
    g.strokeRoundedRect(metrics.x + metrics.panelInset, panelY + 5, metrics.width - metrics.panelInset * 2, panelHeight - 8, 19);

    const titlePillWidth = Math.round(clamp(metrics.width * 0.54, 172, 244));
    const titlePillHeight = 50;
    const titlePillX = Math.round(metrics.x + (metrics.width - titlePillWidth) / 2);
    const titlePillY = metrics.y + 18;
    g.fillStyle(colors.outlineBrown, 1);
    g.fillRoundedRect(titlePillX - 7, titlePillY - 5, titlePillWidth + 14, titlePillHeight + 10, 22);
    g.fillStyle(colors.gold, 1);
    g.fillRoundedRect(titlePillX, titlePillY, titlePillWidth, titlePillHeight, 21);
    g.fillStyle(colors.goldHighlight, 0.72);
    g.fillRoundedRect(titlePillX + 15, titlePillY + 7, titlePillWidth - 30, 18, 11);
    g.lineStyle(4, colors.line, 0.72);
    g.strokeRoundedRect(titlePillX, titlePillY, titlePillWidth, titlePillHeight, 21);

    this.titleText
      .setText(this.options.title)
      .setStyle(modalTextStyle('title', { fontSize: '25px', strokeThickness: 5 }))
      .setPosition(metrics.x + metrics.width / 2, titlePillY + titlePillHeight / 2 + 2);
    this.kickerText.setVisible(false);

    const closeSize = Math.round(clamp(metrics.width * 0.1, 38, 42));
    this.closeButton.setLayout({
      x: metrics.x + metrics.width - Math.max(36, metrics.contentInset + 12),
      y: metrics.y + 42,
      width: closeSize,
      height: closeSize,
    });
  }

  #drawShopSheetShell(metrics, g, colors) {
    const r = 20;
    const panelX = metrics.x + 9;
    const panelY = metrics.y + 75;
    const panelWidth = metrics.width - 18;
    const panelHeight = metrics.height - 86;
    const shellY = Math.max(metrics.y, panelY - 36);
    const shellHeight = metrics.y + metrics.height - shellY;
    const topRailHeight = 51;

    g.fillStyle(colors.shadow, 0.42);
    g.fillRoundedRect(metrics.x + 5, shellY + 8, metrics.width, shellHeight, r);
    g.fillStyle(colors.outlineBrown, 1);
    g.fillRoundedRect(metrics.x, shellY, metrics.width, shellHeight, r);
    g.fillStyle(0x4a230c, 1);
    g.fillRoundedRect(metrics.x + 5, shellY + 5, metrics.width - 10, shellHeight - 10, r - 4);

    g.fillStyle(colors.woodMid, 1);
    g.fillRoundedRect(metrics.x + 8, shellY + 8, metrics.width - 16, topRailHeight, 14);
    g.fillStyle(colors.woodLight, 0.52);
    g.fillRoundedRect(metrics.x + 19, shellY + 15, metrics.width - 38, 13, 7);
    g.lineStyle(2, colors.line, 0.5);
    g.strokeRoundedRect(metrics.x + 8, shellY + 8, metrics.width - 16, topRailHeight, 14);

    g.fillStyle(colors.shadow, 0.26);
    g.fillRoundedRect(panelX, panelY + 5, panelWidth, panelHeight, 22);
    g.fillStyle(colors.parchment, 1);
    g.fillRoundedRect(panelX, panelY, panelWidth, panelHeight, 22);
    g.fillStyle(0xfff6dc, 0.82);
    g.fillRoundedRect(panelX + 8, panelY + 7, panelWidth - 16, Math.max(26, panelHeight * 0.07), 14);
    g.lineStyle(3, colors.line, 0.44);
    g.strokeRoundedRect(panelX, panelY, panelWidth, panelHeight, 22);
    g.lineStyle(2, colors.parchmentShadow, 0.66);
    g.strokeRoundedRect(panelX + 7, panelY + 7, panelWidth - 14, panelHeight - 14, 17);

    const shellBottom = shellY + shellHeight;
    const panelBottom = panelY + panelHeight;
    const bottomShelfY = shellBottom - 34;
    g.fillStyle(colors.shadow, 0.46);
    g.fillRoundedRect(metrics.x + 24, shellBottom + 8, metrics.width - 48, 14, 7);
    g.fillStyle(colors.outlineBrown, 1);
    g.fillRoundedRect(metrics.x + 17, bottomShelfY, metrics.width - 34, 29, 12);
    g.fillStyle(0x8a4d20, 1);
    g.fillRoundedRect(metrics.x + 23, bottomShelfY + 4, metrics.width - 46, 20, 9);
    g.fillStyle(colors.woodLight, 0.86);
    g.fillRoundedRect(metrics.x + 31, bottomShelfY + 6, metrics.width - 62, 8, 5);
    g.fillStyle(colors.goldHighlight, 0.62);
    g.fillRoundedRect(metrics.x + 54, bottomShelfY + 8, metrics.width - 108, 4, 2);
    g.lineStyle(3, 0xfff0bd, 0.72);
    g.lineBetween(metrics.x + 35, shellBottom - 10, metrics.x + metrics.width - 35, shellBottom - 10);
    g.lineStyle(2, colors.line, 0.66);
    g.lineBetween(metrics.x + 30, shellBottom - 5, metrics.x + metrics.width - 30, shellBottom - 5);
    g.lineStyle(2, 0xfff0bd, 0.52);
    g.lineBetween(panelX + 28, panelBottom - 9, panelX + panelWidth - 28, panelBottom - 9);
    g.fillStyle(0xffefc7, 0.94);
    g.fillRoundedRect(metrics.x + 24, shellBottom + 1, metrics.width - 48, 6, 4);
    g.fillStyle(colors.goldHighlight, 0.58);
    g.fillRoundedRect(metrics.x + 46, shellBottom + 2, metrics.width - 92, 3, 2);

    const titlePillWidth = Math.round(clamp(metrics.width * 0.42, 188, 228));
    const titlePillHeight = 44;
    const titlePillX = Math.round(metrics.x + (metrics.width - titlePillWidth) / 2);
    const titlePillY = shellY + 8;
    g.fillStyle(colors.shadow, 0.36);
    g.fillRoundedRect(titlePillX + 3, titlePillY + 5, titlePillWidth, titlePillHeight, 17);
    g.fillStyle(0x4a230c, 1);
    g.fillRoundedRect(titlePillX, titlePillY, titlePillWidth, titlePillHeight, 17);
    g.fillStyle(colors.woodMid, 1);
    g.fillRoundedRect(titlePillX + 5, titlePillY + 5, titlePillWidth - 10, titlePillHeight - 10, 13);
    g.fillStyle(colors.woodLight, 0.34);
    g.fillRoundedRect(titlePillX + 18, titlePillY + 9, titlePillWidth - 36, 10, 6);
    g.lineStyle(2, colors.line, 0.62);
    g.strokeRoundedRect(titlePillX + 1, titlePillY + 1, titlePillWidth - 2, titlePillHeight - 2, 16);

    this.titleText
      .setText(this.options.title)
      .setStyle(modalTextStyle('title', { fontSize: '24px', strokeThickness: 3, letterSpacing: 0 }))
      .setPosition(metrics.x + metrics.width / 2, titlePillY + titlePillHeight / 2 + 1);
    this.titleText.setPadding?.(8, 6, 8, 6);
    this.kickerText.setVisible(false);

    const closeSize = 40;
    this.closeButton.setLayout({
      x: metrics.x + metrics.width - 28,
      y: shellY + 30,
      width: closeSize,
      height: closeSize,
    });
  }
}

class ListModal extends BaseModal {
  buildBody(metrics) {
    const rows = this.resolveRows().slice(0, 5);
    const gap = 10;
    const rowHeight = Math.min(66, Math.floor((metrics.bodyHeight - gap * (rows.length - 1)) / Math.max(1, rows.length)));
    rows.forEach((row, index) => {
      this.body.add(new ModalListRow(this.scene, {
        x: metrics.innerX,
        y: metrics.innerY + index * (rowHeight + gap),
        width: metrics.innerWidth,
        height: rowHeight,
        ...row,
      }));
    });
  }

  resolveRows() {
    const rows = this.options.rows;
    return typeof rows === 'function' ? rows(this.manager.context, this.payload) : rows || [];
  }
}

class QuestModal extends ListModal {
  resolveRows() {
    const board = this.manager.context.board;
    const player = board?.playerUnit;
    const stage = Math.max(1, board?.boardState || 1);
    const stageStep = ((stage - 1) % 10) + 1;
    const enemyCount = board?.enemyUnits?.length || 0;
    const mapName = formatMainStageMapName(this.manager.context.store, board?.map, '전장 로딩 중');

    return [
      { icon: '!', title: '메인 퀘스트', body: `웨이브 ${stageStep}/10 진행 중`, meta: 'Live' },
      { icon: 'M', title: mapName, body: `현재 스테이지 ${stage} · 적 ${enemyCount}마리`, meta: 'Map' },
      {
        icon: 'HP',
        title: player?.name || '햄스터',
        body: player ? `HP ${formatNumber(player.hp)} / ${formatNumber(player.maxHp)}` : '플레이어 유닛 대기',
        meta: player?.alive ? 'OK' : 'Down',
      },
      { icon: '$', title: '전투 수익', body: `골드 ${formatNumber(board?.gold || 0)} · EXP ${formatNumber(board?.exp || 0)}`, meta: 'Drop' },
    ];
  }
}

function formatMainStageMapName(store, map, fallback = '-') {
  const mapName = map?.name || fallback;
  const mainStageNo = store?.getMainStageNumber?.(map);
  if (!Number.isFinite(mainStageNo)) return mapName;
  return `${String(mainStageNo).padStart(2, '0')}단계 · ${mapName}`;
}

function resolveShopProducts(store) {
  return {
    ruby: SHOP_PRODUCT_IDS.ruby.map((id, index) => normalizeShopProduct(store?.getItem?.(id), SHOP_FALLBACK_PRODUCTS.ruby[index])),
    limited: SHOP_PRODUCT_IDS.limited.map((id, index) => normalizeShopProduct(store?.getItem?.(id), SHOP_FALLBACK_PRODUCTS.limited[index])),
  };
}

function normalizeShopProduct(item, fallback = {}) {
  const popupArgs = item?.popupArgs || {};
  const amount = firstRewardCount(item, 3) || fallback.amount || 0;
  const priceWon = Number(item?.priceWon || fallback.priceWon || 0);
  const title = amount > 0 ? `루비 ${formatInteger(amount)}` : (item?.name || fallback.title || '상품');

  return {
    ...fallback,
    id: Number(item?.id || fallback.id || 0),
    title,
    amount,
    priceWon,
    badge: popupArgs.BonusBadge || fallback.badge || '',
    body: popupArgs.Summary || fallback.body || '',
    icon: fallback.icon,
  };
}

function firstRewardCount(item, itemDataId) {
  for (const group of item?.addItemGroups || []) {
    for (const addItem of group.addItems || []) {
      if (Number(addItem.itemDataId) === Number(itemDataId)) {
        const count = Number(addItem.count ?? addItem.minCount ?? 0);
        if (Number.isFinite(count) && count > 0) return count;
      }
    }
  }
  return 0;
}

function formatWon(value) {
  const number = Number(value || 0);
  if (!Number.isFinite(number) || number <= 0) return '구매';
  return `₩${number.toLocaleString('ko-KR')}`;
}

function formatInteger(value) {
  const number = Number(value || 0);
  if (!Number.isFinite(number)) return '0';
  return number.toLocaleString('ko-KR');
}

function shopIconTextureKey(productId) {
  const id = String(productId || '').trim();
  return id ? `shop-product-icon-${id}` : '';
}

class FeatureListModal extends ListModal {
  resolveActions() {
    return [
      { label: '닫기', style: 'wood', onClick: () => this.close() },
      { label: '확인', style: 'green', onClick: () => this.close() },
    ];
  }
}

class AchievementModal extends BaseModal {
  constructor(manager, options = {}) {
    super(manager, options);
    this.categoryIndex = 0;
    this.page = 0;
    this.latestPageCount = 1;
  }

  buildBody(metrics) {
    const board = this.manager.context.board;
    const store = this.manager.context.store;
    const all = visibleAchievements(store);
    const category = ACHIEVEMENT_CATEGORIES[this.categoryIndex] || ACHIEVEMENT_CATEGORIES[0];
    const filtered = this.#filterByCategory(all, category.id)
      .map(achievement => ({
        achievement,
        progress: board?.getAchievementProgress?.(achievement) || emptyAchievementProgress(achievement),
        categoryId: achievementCategoryId(achievement),
      }))
      .sort(sortAchievementEntries);

    const { colors } = PHASER_DESIGN;
    const g = makeGraphics(this.scene);
    this.body.add(g);

    const compact = metrics.bodyHeight < 390;
    const summaryHeight = compact ? 46 : 52;
    const stripHeight = compact ? 32 : 36;
    const gap = compact ? 7 : 9;
    const top = metrics.innerY + 2;

    this.#drawSummary(g, {
      x: metrics.innerX,
      y: top,
      width: metrics.innerWidth,
      height: summaryHeight,
      all,
      filtered,
      category,
      board,
      colors,
    });

    this.#drawCategoryStrip(g, {
      x: metrics.innerX,
      y: top + summaryHeight + gap,
      width: metrics.innerWidth,
      height: stripHeight,
      all,
      colors,
    });

    const listTop = top + summaryHeight + gap + stripHeight + gap;
    const available = Math.max(120, metrics.innerY + metrics.bodyHeight - listTop);
    const pageSize = compact ? 4 : 5;
    this.latestPageCount = Math.max(1, Math.ceil(filtered.length / pageSize));
    this.page = clamp(this.page, 0, this.latestPageCount - 1);

    const pageEntries = filtered.slice(this.page * pageSize, this.page * pageSize + pageSize);
    if (!pageEntries.length) {
      this.#drawEmptyState(g, metrics.innerX, listTop, metrics.innerWidth, available, colors);
      return;
    }

    const rowHeight = Math.max(54, Math.min(72, Math.floor((available - gap * (pageEntries.length - 1)) / pageEntries.length)));
    pageEntries.forEach((entry, index) => {
      this.#drawAchievementRow(g, {
        ...entry,
        x: metrics.innerX,
        y: listTop + index * (rowHeight + gap),
        width: metrics.innerWidth,
        height: rowHeight,
        colors,
        store,
      });
    });
  }

  resolveActions() {
    return [
      {
        label: '분류\n이전',
        style: 'wood',
        onClick: () => {
          this.categoryIndex = (this.categoryIndex + ACHIEVEMENT_CATEGORIES.length - 1) % ACHIEVEMENT_CATEGORIES.length;
          this.page = 0;
          this.rebuild();
        },
      },
      {
        label: '분류\n다음',
        style: 'wood',
        onClick: () => {
          this.categoryIndex = (this.categoryIndex + 1) % ACHIEVEMENT_CATEGORIES.length;
          this.page = 0;
          this.rebuild();
        },
      },
      {
        label: this.latestPageCount > 1 ? `페이지\n${this.page + 1}/${this.latestPageCount}` : '닫기',
        style: 'green',
        onClick: () => {
          if (this.latestPageCount <= 1) {
            this.close();
            return;
          }
          this.page = (this.page + 1) % this.latestPageCount;
          this.rebuild();
        },
      },
    ];
  }

  #filterByCategory(achievements, categoryId) {
    if (categoryId === 'all') return achievements;
    return achievements.filter(achievement => achievementCategoryId(achievement) === categoryId);
  }

  #drawSummary(g, { x, y, width, height, all, filtered, category, board, colors }) {
    const totalSummary = summarizeAchievementList(all, board);
    const categorySummary = summarizeAchievementList(filtered, board);
    g.fillStyle(colors.outlineBrown, 0.2);
    g.fillRoundedRect(x, y + 4, width, height, 18);
    g.fillStyle(0xfff8df, 1);
    g.fillRoundedRect(x, y, width, height, 18);
    g.lineStyle(3, colors.parchmentShadow, 0.76);
    g.strokeRoundedRect(x + 1, y + 1, width - 2, height - 2, 17);

    g.fillStyle(colors.outlineBrown, 1);
    g.fillCircle(x + 26, y + height / 2, 19);
    g.fillStyle(category.accent, 1);
    g.fillCircle(x + 26, y + height / 2, 15);

    const iconText = makeText(this.scene, x + 26, y + height / 2 - 1, category.icon, modalTextStyle('button', {
      fontSize: category.icon.length > 1 ? '10px' : '15px',
      strokeThickness: 3,
    })).setOrigin(0.5);
    const titleText = makeText(this.scene, x + 54, y + 9, `${category.label} 업적`, modalTextStyle('rowTitle', {
      fontSize: '15px',
      color: '#3a1b08',
    }));
    const bodyText = makeText(this.scene, x + 54, y + 30, `전체 ${totalSummary.completed}/${totalSummary.total} · 현재 ${categorySummary.completed}/${categorySummary.total}`, modalTextStyle('rowBody', {
      fontSize: '12px',
      color: '#6b3d17',
    }));
    const rightText = makeText(this.scene, x + width - 14, y + height / 2 - 8, `${Math.round(totalSummary.ratio * 100)}%`, modalTextStyle('value', {
      fontSize: '20px',
      strokeThickness: 4,
      align: 'right',
    })).setOrigin(1, 0.5);
    this.body.add([iconText, titleText, bodyText, rightText]);
  }

  #drawCategoryStrip(g, { x, y, width, height, all, colors }) {
    const gap = 5;
    const chipWidth = Math.floor((width - gap * (ACHIEVEMENT_CATEGORIES.length - 1)) / ACHIEVEMENT_CATEGORIES.length);
    ACHIEVEMENT_CATEGORIES.forEach((category, index) => {
      const cx = x + index * (chipWidth + gap);
      const selected = index === this.categoryIndex;
      const count = this.#filterByCategory(all, category.id).length;
      g.fillStyle(colors.outlineBrown, selected ? 0.36 : 0.16);
      g.fillRoundedRect(cx, y + 3, chipWidth, height, 14);
      g.fillStyle(selected ? category.accent : 0xfff1c8, selected ? 1 : 0.92);
      g.fillRoundedRect(cx, y, chipWidth, height, 14);
      g.lineStyle(selected ? 3 : 2, selected ? colors.greenDark : colors.parchmentShadow, selected ? 0.92 : 0.72);
      g.strokeRoundedRect(cx + 1, y + 1, chipWidth - 2, height - 2, 13);

      const hit = makeRectangle(this.scene, cx, y, chipWidth, height, 0xffffff, 0.001)
        .setOrigin(0)
        .setInteractive({ useHandCursor: true })
        .on('pointerup', () => {
          playSfx('uiClick', { volume: 0.72 });
          this.categoryIndex = index;
          this.page = 0;
          this.rebuild();
        });
      const label = makeText(this.scene, cx + chipWidth / 2, y + 6, category.label, modalTextStyle('rowTitle', {
        fontSize: chipWidth < 48 ? '10px' : '11px',
        align: 'center',
        color: selected ? '#2b1606' : '#5d3212',
      })).setOrigin(0.5, 0);
      const meta = makeText(this.scene, cx + chipWidth / 2, y + height - 15, String(count), modalTextStyle('rowBody', {
        fontSize: '9px',
        align: 'center',
        color: selected ? '#2f2106' : '#8a5527',
      })).setOrigin(0.5, 0);
      this.body.add([hit, label, meta]);
    });
  }

  #drawAchievementRow(g, { achievement, progress, categoryId, x, y, width, height, colors, store }) {
    const category = ACHIEVEMENT_CATEGORIES.find(entry => entry.id === categoryId) || ACHIEVEMENT_CATEGORIES[0];
    const completed = progress.completed;
    const fill = completed ? 0xe8ffd6 : 0xfff8e3;
    const line = completed ? colors.greenDark : colors.parchmentShadow;
    g.fillStyle(colors.outlineBrown, completed ? 0.26 : 0.18);
    g.fillRoundedRect(x, y + 4, width, height, 16);
    g.fillStyle(fill, 1);
    g.fillRoundedRect(x, y, width, height, 16);
    g.fillStyle(0xffffff, completed ? 0.22 : 0.16);
    g.fillRoundedRect(x + 8, y + 5, width - 16, Math.max(8, height * 0.25), 9);
    g.lineStyle(completed ? 4 : 3, line, completed ? 0.94 : 0.78);
    g.strokeRoundedRect(x + 1, y + 1, width - 2, height - 2, 15);

    g.fillStyle(colors.outlineBrown, 1);
    g.fillCircle(x + 27, y + height / 2, Math.min(19, height * 0.32));
    g.fillStyle(category.accent, 1);
    g.fillCircle(x + 27, y + height / 2, Math.min(15, height * 0.26));

    const iconText = makeText(this.scene, x + 27, y + height / 2 - 1, achievementIcon(achievement), modalTextStyle('button', {
      fontSize: achievementIcon(achievement).length > 1 ? '10px' : '14px',
      strokeThickness: 3,
    })).setOrigin(0.5);

    const titleText = makeText(this.scene, x + 54, y + 8, achievement.name, modalTextStyle('rowTitle', {
      fontSize: height < 62 ? '13px' : '14px',
      color: '#3a1b08',
    }));
    titleText.setWordWrapWidth(Math.max(110, width - 148), true);

    const reward = achievementRewardLabel(achievement, store);
    const metaText = makeText(this.scene, x + 54, y + height - 25, `${achievementRequirementLabel(achievement, store, progress)} · ${reward}`, modalTextStyle('rowBody', {
      fontSize: height < 62 ? '10px' : '11px',
      color: completed ? '#2f7e20' : '#6b3d17',
    }));
    metaText.setWordWrapWidth(Math.max(120, width - 70), true);

    const badgeWidth = 60;
    const badgeX = x + width - badgeWidth - 12;
    g.fillStyle(completed ? colors.greenDark : colors.woodMid, 1);
    g.fillRoundedRect(badgeX, y + 11, badgeWidth, 24, 12);
    const badgeText = makeText(this.scene, badgeX + badgeWidth / 2, y + 17, completed ? '완료' : `${formatNumber(progress.progress)}/${formatNumber(progress.target)}`, modalTextStyle('button', {
      fontSize: completed ? '12px' : '10px',
      strokeThickness: 3,
      align: 'center',
    })).setOrigin(0.5, 0);

    const barX = x + 54;
    const barY = y + height - 10;
    const barWidth = Math.max(80, width - 72);
    g.fillStyle(0x6b3d17, 0.24);
    g.fillRoundedRect(barX, barY, barWidth, 5, 3);
    const filledWidth = barWidth * progress.ratio;
    if (filledWidth > 0) {
      g.fillStyle(completed ? colors.green : colors.gold, 1);
      g.fillRoundedRect(barX, barY, Math.max(5, filledWidth), 5, 3);
    }

    this.body.add([iconText, titleText, metaText, badgeText]);
  }

  #drawEmptyState(g, x, y, width, height, colors) {
    g.fillStyle(colors.outlineBrown, 0.14);
    g.fillRoundedRect(x, y + 4, width, height, 18);
    g.fillStyle(0xfff8df, 1);
    g.fillRoundedRect(x, y, width, height, 18);
    g.lineStyle(3, colors.parchmentShadow, 0.7);
    g.strokeRoundedRect(x + 2, y + 2, width - 4, height - 4, 16);

    const text = makeText(this.scene, x + width / 2, y + height / 2 - 9, '표시할 업적이 없습니다', modalTextStyle('rowTitle', {
      fontSize: '16px',
      align: 'center',
      color: '#4b250d',
    })).setOrigin(0.5);
    this.body.add(text);
  }
}

class ShopModal extends BaseModal {
  buildBody(metrics) {
    const products = resolveShopProducts(this.manager.context.store);
    const g = makeGraphics(this.scene);
    this.body.add(g);

    const compact = metrics.sceneHeight < 900;
    const segmentHeight = compact ? 34 : 38;
    const segmentY = metrics.innerY;
    this.#drawSegmentedHeader(g, metrics.innerX, segmentY, metrics.innerWidth, segmentHeight);

    const rubyTitleY = segmentY + segmentHeight + (compact ? 15 : 18);
    this.#drawSectionTitle(g, metrics.innerX, rubyTitleY, metrics.innerWidth, '루비');
    const rubyCardsY = rubyTitleY + (compact ? 29 : 32);
    const rubyCardHeight = compact ? 142 : 154;
    this.#drawGroupFrame(g, metrics.innerX - 6, rubyCardsY - 10, metrics.innerWidth + 12, rubyCardHeight + 20);
    this.#drawRubyCards(g, products.ruby, metrics.innerX, rubyCardsY, metrics.innerWidth, rubyCardHeight);

    const limitedY = rubyCardsY + rubyCardHeight + (compact ? 22 : 28);
    this.#drawSectionTitle(g, metrics.innerX, limitedY, metrics.innerWidth, '한정 상품');
    const limitedCardsY = limitedY + (compact ? 31 : 34);
    const availableLimited = Math.max(118, metrics.footerTop - limitedCardsY - 12);
    const limitedCardHeight = Math.round(clamp(availableLimited, compact ? 158 : 164, compact ? 176 : 188));
    this.#drawLimitedProducts(g, products.limited, metrics.innerX, limitedCardsY, metrics.innerWidth, limitedCardHeight);
  }

  resolveActions() {
    return [];
  }

  #drawSegmentedHeader(g, x, y, width, height) {
    const { colors } = PHASER_DESIGN;
    const gap = 10;
    const tabWidth = Math.floor((width - gap) / 2);
    g.fillStyle(colors.outlineBrown, 0.14);
    g.fillRoundedRect(x, y + 2, width, height, 13);
    g.fillStyle(0xfff2cf, 1);
    g.fillRoundedRect(x, y, width, height, 13);
    g.lineStyle(2, colors.parchmentShadow, 0.58);
    g.strokeRoundedRect(x + 1, y + 1, width - 2, height - 2, 12);

    this.#drawSegmentTab(g, x + 5, y + 5, tabWidth - 5, height - 10, '루비', true, 'ruby');
    this.#drawSegmentTab(g, x + tabWidth + gap, y + 5, tabWidth - 5, height - 10, '한정 상품', false, 'clock');
  }

  #drawSegmentTab(g, x, y, width, height, label, active, iconType) {
    const fill = active ? 0xc4332b : 0xf4dba6;
    const highlight = active ? 0xeb5b50 : 0xfff0c8;
    const textColor = active ? '#fff7dd' : '#4b2108';
    g.fillStyle(0x5b2a0e, 0.9);
    g.fillRoundedRect(x, y, width, height, 11);
    g.fillStyle(fill, 1);
    g.fillRoundedRect(x + 2, y + 2, width - 4, height - 4, 9);
    g.fillStyle(highlight, active ? 0.5 : 0.78);
    g.fillRoundedRect(x + 9, y + 6, width - 18, 9, 5);
    g.lineStyle(2, active ? 0x7c1812 : 0xbd853b, active ? 0.62 : 0.52);
    g.strokeRoundedRect(x + 2, y + 2, width - 4, height - 4, 9);

    const iconRadius = 6;
    const textWidthEstimate = iconType === 'clock' ? 66 : 30;
    const groupGap = 8;
    const groupWidth = iconRadius * 2 + groupGap + textWidthEstimate;
    const iconX = Math.round(x + width / 2 - groupWidth / 2 + iconRadius);
    const centerY = Math.round(y + height / 2);
    const textX = iconX + iconRadius + groupGap + textWidthEstimate / 2;
    this.#drawSegmentIcon(g, iconX, centerY, iconRadius, iconType, active);

    const text = makeText(this.scene, textX, centerY, label, modalTextStyle('button', {
      fontSize: '14px',
      color: textColor,
      strokeThickness: active ? 3 : 0,
      letterSpacing: 0,
      align: 'center',
    })).setOrigin(0.5);
    this.body.add(text);
  }

  #drawSegmentIcon(g, cx, cy, radius, iconType, active) {
    if (iconType === 'ruby') {
      g.fillStyle(0x5b1a14, active ? 0.72 : 0.36);
      this.#drawSmallDiamond(g, cx, cy + 1, radius + 3);
      g.fillStyle(active ? 0xfff7dd : 0x8b4f18, 1);
      this.#drawSmallDiamond(g, cx, cy, radius + 1);
      g.fillStyle(active ? 0xffffff : 0xfff0c8, active ? 0.62 : 0.72);
      this.#drawSmallDiamond(g, cx - 1, cy - 2, Math.max(3, radius - 3));
      return;
    }

    g.fillStyle(0x5b2a0e, active ? 0.52 : 0.28);
    g.fillCircle(cx, cy + 1, radius + 2);
    g.fillStyle(active ? 0xfff4cc : 0x8b4f18, 1);
    g.fillCircle(cx, cy, radius + 1);
    g.lineStyle(2, active ? 0x7b1a12 : 0xffedbd, active ? 0.76 : 0.9);
    g.strokeCircle(cx, cy, radius + 1);
    g.lineStyle(2, active ? 0x7b1a12 : 0xffedbd, 1);
    g.beginPath();
    g.moveTo(cx, cy);
    g.lineTo(cx, cy - radius + 2);
    g.moveTo(cx, cy);
    g.lineTo(cx + radius - 1, cy + 2);
    g.strokePath();
  }

  #drawSectionTitle(g, x, y, width, label) {
    const { colors } = PHASER_DESIGN;
    g.fillStyle(colors.parchmentShadow, 1);
    g.fillRect(x + width * 0.17, y + 12, width * 0.66, 3);
    g.fillStyle(colors.woodMid, 1);
    this.#drawSmallDiamond(g, x + width * 0.34, y + 13, 5);
    this.#drawSmallDiamond(g, x + width * 0.66, y + 13, 5);
    const title = makeText(this.scene, x + width / 2, y, label, modalTextStyle('rowTitle', {
      fontSize: '20px',
      align: 'center',
    })).setOrigin(0.5, 0);
    this.body.add(title);
  }

  #drawGroupFrame(g, x, y, width, height) {
    const { colors } = PHASER_DESIGN;
    g.fillStyle(colors.outlineBrown, 0.16);
    g.fillRoundedRect(x, y + 4, width, height, 20);
    g.fillStyle(0xfff6dc, 0.78);
    g.fillRoundedRect(x, y, width, height, 20);
    g.lineStyle(3, colors.parchmentShadow, 0.68);
    g.strokeRoundedRect(x + 2, y + 2, width - 4, height - 4, 18);
  }

  #drawSmallDiamond(g, cx, cy, radius) {
    g.fillTriangle(cx, cy - radius, cx + radius, cy, cx, cy + radius);
    g.fillTriangle(cx, cy - radius, cx - radius, cy, cx, cy + radius);
  }

  #drawRubyCards(g, products, x, y, width, cardHeight) {
    const gap = 10;
    const cardWidth = Math.floor((width - gap * 2) / 3);
    products.slice(0, 3).forEach((product, index) => {
      const cardX = x + index * (cardWidth + gap);
      this.#drawRubyCard(g, product, cardX, y, cardWidth, cardHeight);
    });
  }

  #drawRubyCard(g, product, x, y, width, height) {
    const { colors } = PHASER_DESIGN;
    g.fillStyle(colors.outlineBrown, 0.22);
    g.fillRoundedRect(x, y + 4, width, height, 16);
    g.fillStyle(0xffefc7, 1);
    g.fillRoundedRect(x, y, width, height, 16);
    g.fillStyle(0xffffff, 0.2);
    g.fillRoundedRect(x + 8, y + 7, width - 16, Math.max(14, height * 0.22), 10);
    g.lineStyle(3, colors.parchmentShadow, 0.75);
    g.strokeRoundedRect(x + 2, y + 2, width - 4, height - 4, 14);

    const title = makeText(this.scene, x + width / 2, y + 12, product.title, modalTextStyle('rowTitle', {
      fontSize: width < 120 ? '13px' : '15px',
      align: 'center',
    })).setOrigin(0.5, 0);
    this.body.add(title);

    const compactCard = height < 130;
    const iconX = x + width / 2;
    const iconY = y + Math.round(height * (compactCard ? 0.43 : 0.47));
    const iconSize = compactCard ? 54 : 82;
    const hasIcon = this.#drawProductIcon(product, iconX, iconY, iconSize);
    if (!hasIcon) {
      this.#drawRubyOfferGraphic(
        g,
        product,
        iconX,
        iconY,
        compactCard ? 0.62 : (width < 120 ? 0.78 : 0.9),
      );
    }

    if (product.badge) {
      g.fillStyle(0xb92c25, 1);
      g.fillCircle(x + width - 21, y + 50, 18);
      g.fillStyle(0xf05a42, 1);
      g.fillCircle(x + width - 21, y + 48, 15);
      const badge = makeText(this.scene, x + width - 21, y + 47, product.badge.replace(' ', '\n'), modalTextStyle('button', {
        fontSize: '10px',
        strokeThickness: 2,
        align: 'center',
      })).setOrigin(0.5);
      this.body.add(badge);
    }

    const button = new ShopPurchaseButton(this.scene, {
      x: x + width / 2,
      y: y + height - 23,
      width: width - 16,
      height: 38,
      label: formatWon(product.priceWon),
      fontSize: width < 120 ? '12px' : '14px',
      onClick: () => this.#handleBuy(product),
    });
    this.body.add(button);
  }

  #drawRubyOfferGraphic(g, product, cx, cy, scale = 1) {
    if (product.id === 201502) {
      this.#drawRubyPouch(g, cx, cy + 5 * scale, scale);
      return;
    }
    if (product.id === 201503) {
      this.#drawRubyChest(g, cx, cy + 7 * scale, scale);
      return;
    }
    this.#drawRubyPile(g, cx, cy + 5 * scale, scale);
  }

  #drawRubyPile(g, cx, cy, scale = 1) {
    const offsets = [
      [-21, 10, 14],
      [0, 4, 18],
      [20, 12, 13],
      [-7, 22, 11],
    ];
    for (const [ox, oy, radius] of offsets) {
      this.#drawRuby(g, cx + ox * scale, cy + oy * scale, radius * scale);
    }
  }

  #drawRubyPouch(g, cx, cy, scale = 1) {
    const { colors } = PHASER_DESIGN;
    g.fillStyle(0x5b3518, 1);
    g.fillEllipse(cx, cy + 12 * scale, 54 * scale, 42 * scale);
    g.fillStyle(0x9b642b, 1);
    g.fillEllipse(cx, cy + 8 * scale, 48 * scale, 35 * scale);
    g.fillStyle(0x5b3518, 1);
    g.fillRoundedRect(cx - 20 * scale, cy - 8 * scale, 40 * scale, 12 * scale, 5 * scale);
    g.lineStyle(3 * scale, colors.gold, 0.9);
    g.strokeEllipse(cx, cy + 6 * scale, 38 * scale, 18 * scale);
    this.#drawRuby(g, cx - 16 * scale, cy - 2 * scale, 10 * scale);
    this.#drawRuby(g, cx + 1 * scale, cy - 7 * scale, 12 * scale);
    this.#drawRuby(g, cx + 17 * scale, cy - 1 * scale, 9 * scale);
    this.#drawRuby(g, cx - 30 * scale, cy + 24 * scale, 9 * scale);
  }

  #drawRubyChest(g, cx, cy, scale = 1) {
    const { colors } = PHASER_DESIGN;
    g.fillStyle(colors.outlineBrown, 1);
    g.fillRoundedRect(cx - 33 * scale, cy - 6 * scale, 66 * scale, 42 * scale, 8 * scale);
    g.fillStyle(0x9f651f, 1);
    g.fillRoundedRect(cx - 29 * scale, cy - 2 * scale, 58 * scale, 34 * scale, 6 * scale);
    g.fillStyle(colors.gold, 1);
    g.fillRect(cx - 29 * scale, cy + 7 * scale, 58 * scale, 8 * scale);
    g.fillStyle(0xffd96a, 1);
    g.fillRoundedRect(cx - 8 * scale, cy + 4 * scale, 16 * scale, 16 * scale, 4 * scale);
    this.#drawRuby(g, cx - 22 * scale, cy - 14 * scale, 9 * scale);
    this.#drawRuby(g, cx - 5 * scale, cy - 17 * scale, 11 * scale);
    this.#drawRuby(g, cx + 13 * scale, cy - 13 * scale, 9 * scale);
    this.#drawRuby(g, cx + 29 * scale, cy + 28 * scale, 8 * scale);
    this.#drawRuby(g, cx - 35 * scale, cy + 28 * scale, 8 * scale);
  }

  #drawRuby(g, cx, cy, radius) {
    g.fillStyle(0x5b1d16, 1);
    g.fillTriangle(cx, cy - radius, cx + radius, cy, cx, cy + radius);
    g.fillTriangle(cx, cy - radius, cx - radius, cy, cx, cy + radius);
    g.fillStyle(0xe64048, 1);
    g.fillTriangle(cx, cy - radius * 0.78, cx + radius * 0.74, cy, cx, cy + radius * 0.72);
    g.fillTriangle(cx, cy - radius * 0.78, cx - radius * 0.74, cy, cx, cy + radius * 0.72);
    g.fillStyle(0xff9a92, 0.9);
    g.fillTriangle(cx, cy - radius * 0.7, cx - radius * 0.28, cy - radius * 0.02, cx + radius * 0.24, cy - radius * 0.02);
  }

  #drawLimitedProducts(g, products, x, y, width, cardHeight) {
    const gap = 10;
    const cardWidth = Math.floor((width - gap * 2) / 3);
    products.slice(0, 3).forEach((product, index) => {
      const cardX = x + index * (cardWidth + gap);
      this.#drawLimitedCard(g, product, cardX, y, cardWidth, cardHeight);
    });
  }

  #drawLimitedCard(g, product, x, y, width, height) {
    const { colors } = PHASER_DESIGN;
    g.fillStyle(colors.outlineBrown, 0.22);
    g.fillRoundedRect(x, y + 4, width, height, 16);
    g.fillStyle(0xffedc3, 1);
    g.fillRoundedRect(x, y, width, height, 16);
    g.fillStyle(0xffffff, 0.22);
    g.fillRoundedRect(x + 8, y + 7, width - 16, Math.max(14, height * 0.18), 9);
    g.lineStyle(3, colors.parchmentShadow, 0.7);
    g.strokeRoundedRect(x + 2, y + 2, width - 4, height - 4, 14);

    const title = makeText(this.scene, x + width / 2, y + 11, product.title, modalTextStyle('rowTitle', {
      fontSize: width < 120 ? '12px' : '14px',
      align: 'center',
      wordWrap: { width: width - 14, useAdvancedWrap: true },
    })).setOrigin(0.5, 0);
    this.body.add(title);

    const iconX = x + width / 2;
    const compactCard = height < 150 || width < 120;
    const iconY = y + Math.round(height * (compactCard ? 0.37 : 0.4));
    const iconSize = compactCard ? 74 : 88;
    const hasIcon = this.#drawProductIcon(product, iconX, iconY, iconSize);
    if (!hasIcon) {
      this.#drawLimitedIcon(g, product, iconX, iconY, compactCard ? 0.58 : 0.78);
    }

    const lines = this.#limitedLines(product).slice(0, 2);
    const summaryText = makeText(this.scene, x + 13, y + height - 68, lines.map(line => `• ${line}`).join('\n'), modalTextStyle('rowBody', {
      fontSize: width < 120 ? '8px' : '9px',
      lineSpacing: 1,
      align: 'left',
      color: '#4f2a0d',
      wordWrap: { width: width - 26, useAdvancedWrap: true },
    })).setOrigin(0, 0);
    this.body.add(summaryText);

    const button = new ShopPurchaseButton(this.scene, {
      x: x + width / 2,
      y: y + height - 20,
      width: width - 16,
      height: 36,
      label: formatWon(product.priceWon),
      fontSize: width < 120 ? '11px' : '13px',
      onClick: () => this.#handleBuy(product),
    });
    this.body.add(button);
  }

  #drawLimitedIcon(g, product, cx, cy, scale = 1) {
    if (product.id === 201505) {
      this.#drawAdFreeIcon(g, cx, cy, scale);
      return;
    }
    if (product.id === 201506) {
      this.#drawSpeedIcon(g, cx, cy, scale);
      return;
    }
    this.#drawBoosterIcon(g, cx, cy, scale);
  }

  #drawProductIcon(product, x, y, size) {
    const key = shopIconTextureKey(product.id);
    if (!key || !this.scene.textures.exists(key)) return false;
    const image = makeImage(this.scene, x, y, key)
      .setDisplaySize(size, size)
      .setOrigin(0.5);
    this.body.add(image);
    return true;
  }

  #drawBoosterIcon(g, cx, cy, scale = 1) {
    const { colors } = PHASER_DESIGN;
    this.#drawSpark(g, cx - 37 * scale, cy - 18 * scale, 10 * scale);
    this.#drawSpark(g, cx + 35 * scale, cy - 12 * scale, 8 * scale);
    g.fillStyle(colors.outlineBrown, 1);
    g.fillRoundedRect(cx - 28 * scale, cy - 8 * scale, 56 * scale, 30 * scale, 7 * scale);
    g.fillStyle(0x9f651f, 1);
    g.fillRoundedRect(cx - 24 * scale, cy - 4 * scale, 48 * scale, 23 * scale, 6 * scale);
    g.fillStyle(colors.gold, 1);
    g.fillRect(cx - 24 * scale, cy + 2 * scale, 48 * scale, 6 * scale);
    g.lineStyle(4 * scale, 0xb7bdc8, 1);
    g.lineBetween(cx - 41 * scale, cy + 22 * scale, cx - 17 * scale, cy - 2 * scale);
    g.fillStyle(0xf7f7f7, 1);
    g.fillTriangle(cx - 45 * scale, cy + 26 * scale, cx - 33 * scale, cy + 8 * scale, cx - 24 * scale, cy + 17 * scale);
    g.fillStyle(0x858b96, 1);
    g.fillRoundedRect(cx - 5 * scale, cy + 22 * scale, 22 * scale, 16 * scale, 5 * scale);
    g.fillStyle(colors.gold, 1);
    g.fillCircle(cx + 28 * scale, cy + 28 * scale, 9 * scale);
  }

  #drawAdFreeIcon(g, cx, cy, scale = 1) {
    const { colors } = PHASER_DESIGN;
    this.#drawSpark(g, cx - 36 * scale, cy + 14 * scale, 8 * scale);
    this.#drawSpark(g, cx + 34 * scale, cy + 13 * scale, 7 * scale);
    g.fillStyle(colors.gold, 1);
    g.fillCircle(cx, cy, 38 * scale);
    g.fillStyle(0xfff0bd, 1);
    g.fillCircle(cx, cy, 31 * scale);
    g.lineStyle(5 * scale, colors.outlineBrown, 1);
    g.strokeCircle(cx, cy, 31 * scale);
    g.fillStyle(0xffffff, 1);
    g.fillRoundedRect(cx - 21 * scale, cy - 19 * scale, 42 * scale, 38 * scale, 7 * scale);
    const adText = makeText(this.scene, cx, cy - 11 * scale, 'AD', modalTextStyle('rowTitle', {
      fontSize: `${Math.round(18 * scale)}px`,
      align: 'center',
      color: '#2b1206',
    })).setOrigin(0.5, 0);
    this.body.add(adText);
    g.lineStyle(7 * scale, 0xce271f, 1);
    g.lineBetween(cx - 22 * scale, cy + 21 * scale, cx + 22 * scale, cy - 21 * scale);
  }

  #drawSpeedIcon(g, cx, cy, scale = 1) {
    const { colors } = PHASER_DESIGN;
    g.lineStyle(4 * scale, 0xffffff, 0.72);
    g.lineBetween(cx - 48 * scale, cy - 12 * scale, cx - 20 * scale, cy - 12 * scale);
    g.lineBetween(cx - 54 * scale, cy, cx - 22 * scale, cy);
    g.lineBetween(cx - 48 * scale, cy + 12 * scale, cx - 20 * scale, cy + 12 * scale);
    g.fillStyle(colors.gold, 1);
    g.fillRoundedRect(cx - 7 * scale, cy - 49 * scale, 14 * scale, 11 * scale, 4 * scale);
    g.fillStyle(0xf7e7bf, 1);
    g.fillCircle(cx, cy, 35 * scale);
    g.lineStyle(6 * scale, 0xa56b20, 1);
    g.strokeCircle(cx, cy, 35 * scale);
    g.fillStyle(colors.outlineBrown, 1);
    g.fillTriangle(cx - 7 * scale, cy - 15 * scale, cx - 7 * scale, cy + 15 * scale, cx + 10 * scale, cy);
    g.fillTriangle(cx + 10 * scale, cy - 15 * scale, cx + 10 * scale, cy + 15 * scale, cx + 27 * scale, cy);
  }

  #drawSpark(g, cx, cy, radius) {
    g.fillStyle(0xfff0aa, 0.95);
    g.fillTriangle(cx, cy - radius, cx + radius * 0.22, cy - radius * 0.22, cx + radius, cy);
    g.fillTriangle(cx + radius, cy, cx + radius * 0.22, cy + radius * 0.22, cx, cy + radius);
    g.fillTriangle(cx, cy + radius, cx - radius * 0.22, cy + radius * 0.22, cx - radius, cy);
    g.fillTriangle(cx - radius, cy, cx - radius * 0.22, cy - radius * 0.22, cx, cy - radius);
  }

  #limitedLines(product) {
    if (product.id === 201504) return ['장비 재료 대량 지급', '전설 상자 포함'];
    if (product.id === 201505) return ['모든 광고 즉시 제거', '보상 바로 수령'];
    if (product.id === 201506) return ['게임 속도 2배', '모든 콘텐츠 적용'];
    return [product.body || '한정 혜택 지급'];
  }

  #limitedSummary(product) {
    if (product.id === 201504) return '재료+장비상자';
    if (product.id === 201505) return '광고 없이 보상';
    if (product.id === 201506) return '속도 2배 적용';
    return this.#limitedLines(product)[0] || '한정 혜택';
  }

  #handleBuy(product) {
    playSfx('reward', { volume: 0.58 });
    this.manager.context.messages?.push({
      type: 'loot',
      icon: '◆',
      title: '상점',
      body: `${product.title} 구매 플로우 준비됨`,
      duration: 1900,
    });
  }
}

class SettingsModal extends BaseModal {
  buildBody(metrics) {
    const settings = this.#currentSettings();
    const identity = resolvePlayerIdentity(this.manager.context);
    const g = makeGraphics(this.scene);
    this.body.add(g);

    const compact = metrics.bodyHeight < 300;
    const gap = compact ? 7 : 8;
    const rowHeight = compact ? 50 : 56;
    const languageHeight = compact ? 72 : 82;
    const identityHeight = Math.max(68, metrics.bodyHeight - rowHeight * 2 - languageHeight - gap * 3 - 2);
    let y = metrics.innerY + 2;

    this.#drawToggleRow(g, {
      x: metrics.innerX,
      y,
      width: metrics.innerWidth,
      height: rowHeight,
      icon: 'BGM',
      title: 'BGM',
      body: '배경 음악',
      enabled: settings.bgmEnabled,
      onToggle: enabled => this.#setBgmEnabled(enabled),
    });
    y += rowHeight + gap;

    this.#drawToggleRow(g, {
      x: metrics.innerX,
      y,
      width: metrics.innerWidth,
      height: rowHeight,
      icon: 'SFX',
      title: 'SFX',
      body: '효과음',
      enabled: settings.sfxEnabled,
      onToggle: enabled => this.#setSfxEnabled(enabled),
    });
    y += rowHeight + gap;

    this.#drawLanguagePicker(g, {
      x: metrics.innerX,
      y,
      width: metrics.innerWidth,
      height: languageHeight,
      language: settings.language,
    });
    y += languageHeight + gap;

    this.#drawIdentityCard(g, {
      x: metrics.innerX,
      y,
      width: metrics.innerWidth,
      height: identityHeight,
      identity,
    });
  }

  resolveActions() {
    return [
      { label: '닫기', style: 'wood', onClick: () => this.close() },
      { label: '확인', style: 'green', onClick: () => this.close() },
    ];
  }

  #currentSettings() {
    const audio = globalThis.__MUSHROOMER_PHASER_AUDIO__ || globalThis.__IDLEZ_PHASER_AUDIO__;
    const base = resolveSettings({ defaultBgmEnabled: audio?.bgmEnabled ?? false });
    return {
      ...base,
      bgmEnabled: Boolean(audio?.bgmEnabled ?? base.bgmEnabled),
      sfxEnabled: Boolean(audio?.sfxEnabled ?? base.sfxEnabled),
      language: audio?.language || base.language,
    };
  }

  #setBgmEnabled(enabled) {
    const audio = globalThis.__MUSHROOMER_PHASER_AUDIO__ || globalThis.__IDLEZ_PHASER_AUDIO__;
    if (audio?.setBgmEnabled) audio.setBgmEnabled(enabled);
    else saveSettings({ ...this.#currentSettings(), bgmEnabled: enabled });
  }

  #setSfxEnabled(enabled) {
    const audio = globalThis.__MUSHROOMER_PHASER_AUDIO__ || globalThis.__IDLEZ_PHASER_AUDIO__;
    if (audio?.setSfxEnabled) audio.setSfxEnabled(enabled);
    else saveSettings({ ...this.#currentSettings(), sfxEnabled: enabled });
  }

  #setLanguage(language) {
    const audio = globalThis.__MUSHROOMER_PHASER_AUDIO__ || globalThis.__IDLEZ_PHASER_AUDIO__;
    if (audio?.setLanguage) audio.setLanguage(language);
    else saveSettings({ ...this.#currentSettings(), language });
  }

  #drawToggleRow(g, { x, y, width, height, icon, title, body, enabled, onToggle }) {
    const { colors } = PHASER_DESIGN;
    this.#drawCard(g, x, y, width, height);

    const hit = makeRectangle(this.scene, x, y, width, height, 0xffffff, 0.001)
      .setOrigin(0)
      .setInteractive({ useHandCursor: true })
      .on('pointerup', () => {
        playSfx('uiClick', { volume: 0.72 });
        onToggle(!enabled);
        this.rebuild();
      });

    g.fillStyle(colors.outlineBrown, 1);
    g.fillCircle(x + 28, y + height / 2, 20);
    g.fillStyle(enabled ? colors.green : colors.red, 1);
    g.fillCircle(x + 28, y + height / 2, 16);

    const iconText = makeText(this.scene, x + 28, y + height / 2 - 1, icon, modalTextStyle('button', {
      fontSize: icon.length > 2 ? '10px' : '13px',
      strokeThickness: 3,
      align: 'center',
    })).setOrigin(0.5);
    const titleText = makeText(this.scene, x + 58, y + 11, title, modalTextStyle('rowTitle', {
      fontSize: '15px',
    }));
    const bodyText = makeText(this.scene, x + 58, y + 33, body, modalTextStyle('rowBody', {
      fontSize: '12px',
    }));

    const switchWidth = 68;
    const switchHeight = 28;
    const switchX = x + width - switchWidth - 14;
    const switchY = y + height / 2 - switchHeight / 2;
    g.fillStyle(colors.outlineBrown, 1);
    g.fillRoundedRect(switchX, switchY, switchWidth, switchHeight, 14);
    g.fillStyle(enabled ? colors.greenDark : 0x8f3925, 1);
    g.fillRoundedRect(switchX + 4, switchY + 4, switchWidth - 8, switchHeight - 8, 11);
    g.fillStyle(0xfff7dd, 1);
    g.fillCircle(switchX + (enabled ? switchWidth - 17 : 17), switchY + switchHeight / 2, 10);

    const stateText = makeText(this.scene, switchX + switchWidth / 2, switchY + 5, enabled ? 'ON' : 'OFF', modalTextStyle('button', {
      fontSize: '12px',
      strokeThickness: 3,
      align: 'center',
    })).setOrigin(0.5, 0);

    this.body.add([hit, iconText, titleText, bodyText, stateText]);
  }

  #drawLanguagePicker(g, { x, y, width, height, language }) {
    const { colors } = PHASER_DESIGN;
    this.#drawCard(g, x, y, width, height);

    const titleText = makeText(this.scene, x + 14, y + 10, '언어 변경', modalTextStyle('rowTitle', {
      fontSize: '15px',
    }));
    const currentText = makeText(this.scene, x + width - 14, y + 11, languageLabel(language), modalTextStyle('rowBody', {
      fontSize: '12px',
      align: 'right',
      color: '#2f7e20',
    })).setOrigin(1, 0);
    this.body.add([titleText, currentText]);

    const gap = 6;
    const chipY = y + 38;
    const chipHeight = Math.max(28, height - 48);
    const chipWidth = Math.floor((width - 28 - gap * (LANGUAGE_OPTIONS.length - 1)) / LANGUAGE_OPTIONS.length);

    LANGUAGE_OPTIONS.forEach((option, index) => {
      const selected = option.code === language;
      const cx = x + 14 + index * (chipWidth + gap);
      g.fillStyle(colors.outlineBrown, selected ? 0.34 : 0.2);
      g.fillRoundedRect(cx, chipY + 3, chipWidth, chipHeight, 13);
      g.fillStyle(selected ? colors.goldHighlight : 0xfff7dd, 1);
      g.fillRoundedRect(cx, chipY, chipWidth, chipHeight, 13);
      g.lineStyle(selected ? 3 : 2, selected ? colors.greenDark : colors.parchmentShadow, 0.84);
      g.strokeRoundedRect(cx + 1, chipY + 1, chipWidth - 2, chipHeight - 2, 12);

      const hit = makeRectangle(this.scene, cx, chipY, chipWidth, chipHeight, 0xffffff, 0.001)
        .setOrigin(0)
        .setInteractive({ useHandCursor: true })
        .on('pointerup', () => {
          if (selected) return;
          playSfx('uiClick', { volume: 0.72 });
          this.#setLanguage(option.code);
          this.rebuild();
        });
      const label = makeText(this.scene, cx + chipWidth / 2, chipY + chipHeight / 2 - 1, option.shortLabel, modalTextStyle('rowTitle', {
        fontSize: '13px',
        align: 'center',
        color: selected ? '#2f2106' : '#4b250d',
      })).setOrigin(0.5);
      this.body.add([hit, label]);
    });
  }

  #drawIdentityCard(g, { x, y, width, height, identity }) {
    const { colors } = PHASER_DESIGN;
    this.#drawCard(g, x, y, width, height);

    const titleText = makeText(this.scene, x + 14, y + 10, '내 고유 ID', modalTextStyle('rowTitle', {
      fontSize: '15px',
    }));
    const stateText = makeText(this.scene, x + width - 14, y + 11, identity.networkState, modalTextStyle('rowBody', {
      fontSize: '12px',
      align: 'right',
      color: identity.serverId ? '#2f7e20' : '#8f3925',
    })).setOrigin(1, 0);

    const idText = makeText(this.scene, x + 14, y + 35, wrapIdentity(identity.primary), modalTextStyle('rowBody', {
      fontSize: '12px',
      lineSpacing: 2,
      color: '#4b250d',
    }));
    idText.setWordWrapWidth(width - 28, true);

    const localText = makeText(this.scene, x + 14, y + height - 21, `Local ${compactIdentity(identity.localId)}`, modalTextStyle('rowBody', {
      fontSize: '10px',
      color: '#8a5527',
    }));
    localText.setWordWrapWidth(width - 28, true);
    this.body.add([titleText, stateText, idText, localText]);

    g.lineStyle(2, colors.parchmentShadow, 0.5);
    g.lineBetween(x + 14, y + height - 27, x + width - 14, y + height - 27);
  }

  #drawCard(g, x, y, width, height) {
    const { colors } = PHASER_DESIGN;
    g.fillStyle(colors.outlineBrown, 0.22);
    g.fillRoundedRect(x, y + 4, width, height, 17);
    g.fillStyle(colors.cream, 1);
    g.fillRoundedRect(x, y, width, height, 17);
    g.lineStyle(3, colors.parchmentShadow, 0.76);
    g.strokeRoundedRect(x + 2, y + 2, width - 4, height - 4, 15);
  }
}

class WeekdayDungeonModal extends BaseModal {
  buildBody(metrics) {
    const dungeon = this.#openDungeon();
    const g = makeGraphics(this.scene);
    this.body.add(g);

    const compact = metrics.bodyHeight < 260 || metrics.sceneHeight < 560;
    const gap = compact ? 8 : 12;
    const bannerY = metrics.innerY + 2;
    const availableHeight = Math.max(160, metrics.bodyHeight - 4);
    const stripHeight = compact ? 34 : 42;
    const bannerHeight = compact
      ? Math.min(88, Math.max(76, Math.floor(availableHeight * 0.42)))
      : Math.min(132, Math.round(metrics.innerWidth * 0.31));
    const descriptionY = bannerY + bannerHeight + gap;
    const stripY = metrics.innerY + metrics.bodyHeight - stripHeight - 2;
    const descriptionHeight = Math.max(64, stripY - descriptionY - gap);

    this.#drawBanner(g, dungeon, metrics.innerX, bannerY, metrics.innerWidth, bannerHeight, compact);
    this.#drawDescription(g, dungeon, metrics.innerX, descriptionY, metrics.innerWidth, descriptionHeight, compact);
    this.#drawRewardStrip(g, dungeon, metrics.innerX, stripY, metrics.innerWidth, stripHeight, compact);
  }

  resolveActions() {
    const dungeon = this.#openDungeon();
    return [
      { label: '닫기', style: 'wood', onClick: () => this.close() },
      {
        label: '입장',
        style: 'primary',
        onClick: () => this.#enterDungeon(dungeon),
      },
    ];
  }

  #enterDungeon(dungeon) {
    const { board, messages, store } = this.manager.context;
    const map = store?.getMap?.(dungeon.mapId);

    if (!board?.start || !map) {
      messages?.push({
        type: 'warning',
        icon: dungeon.icon,
        title: `${dungeon.day}요 ${dungeon.title}`,
        body: `map ${dungeon.mapId} 연결 대기 중`,
        duration: 2200,
      });
      return;
    }

    try {
      board.start(map.id, { preserveProgress: true });
      this.close();
      messages?.push({
        type: 'success',
        icon: dungeon.icon,
        title: `${dungeon.title} 입장`,
        body: `${map.name || dungeon.title} 전투를 시작했습니다.`,
        duration: 1800,
      });
    } catch (error) {
      console.warn('[WeekdayDungeonModal] Failed to enter dungeon', error);
      messages?.push({
        type: 'warning',
        icon: dungeon.icon,
        title: `${dungeon.title} 입장 실패`,
        body: error?.message || '던전 전환 중 문제가 발생했습니다.',
        duration: 2600,
      });
    }
  }

  #drawBanner(g, dungeon, x, y, width, height, compact = false) {
    const { colors } = PHASER_DESIGN;
    g.fillStyle(colors.outlineBrown, 0.35);
    g.fillRoundedRect(x, y + 5, width, height, 18);
    g.fillStyle(colors.woodDark, 1);
    g.fillRoundedRect(x, y, width, height, 18);

    if (this.scene.textures.exists(dungeon.bannerKey)) {
      const image = makeImage(this.scene, x + width / 2, y + height / 2, dungeon.bannerKey)
        .setDisplaySize(width - 8, height - 8)
        .setOrigin(0.5);
      this.body.add(image);
    } else {
      g.fillStyle(dungeon.accent, 0.5);
      g.fillRoundedRect(x + 4, y + 4, width - 8, height - 8, 14);
    }

    const overlay = makeGraphics(this.scene);
    overlay.fillStyle(0x120601, 0.22);
    overlay.fillRoundedRect(x + 4, y + 4, width - 8, height - 8, 14);
    overlay.fillStyle(0x120601, 0.42);
    overlay.fillRoundedRect(x + 4, y + 4, Math.round(width * 0.54), height - 8, 14);
    overlay.lineStyle(3, dungeon.accent, 0.92);
    overlay.strokeRoundedRect(x + 4, y + 4, width - 8, height - 8, 14);
    this.body.add(overlay);

    const dayBadgeWidth = compact ? 58 : 76;
    overlay.fillStyle(colors.outlineBrown, 1);
    overlay.fillRoundedRect(x + 14, y + (compact ? 10 : 13), dayBadgeWidth, compact ? 20 : 26, 12);
    overlay.fillStyle(dungeon.accent, 1);
    overlay.fillRoundedRect(x + 17, y + (compact ? 13 : 16), dayBadgeWidth - 6, compact ? 14 : 20, 10);

    const dayText = makeText(this.scene, x + 17 + (dayBadgeWidth - 6) / 2, y + (compact ? 14 : 18), `${dungeon.day}요일`, modalTextStyle('button', {
      fontSize: compact ? '9px' : '11px',
      strokeThickness: 3,
      align: 'center',
    })).setOrigin(0.5, 0);
    const titleText = makeText(this.scene, x + 18, y + (compact ? 35 : 48), dungeon.title, modalTextStyle('title', {
      fontSize: compact ? '20px' : '24px',
      strokeThickness: compact ? 4 : 5,
      align: 'left',
    }));
    const subText = makeText(this.scene, x + 20, y + height - (compact ? 19 : 29), `입장 가능 · 난이도 1`, modalTextStyle('kicker', {
      fontSize: compact ? '10px' : '12px',
      align: 'left',
    }));
    this.body.add([dayText, titleText, subText]);
  }

  #drawDescription(g, dungeon, x, y, width, height, compact = false) {
    const { colors } = PHASER_DESIGN;
    g.fillStyle(colors.outlineBrown, 0.24);
    g.fillRoundedRect(x, y + 4, width, height, 18);
    g.fillStyle(colors.cream, 1);
    g.fillRoundedRect(x, y, width, height, 18);
    g.lineStyle(3, dungeon.accent, 0.85);
    g.strokeRoundedRect(x + 2, y + 2, width - 4, height - 4, 16);

    const titleText = makeText(this.scene, x + 14, y + (compact ? 7 : 10), '던전 설명', modalTextStyle('rowTitle', {
      fontSize: compact ? '11px' : '13px',
    }));
    const bodyText = makeText(this.scene, x + 14, y + (compact ? 25 : 34), dungeon.description, modalTextStyle('rowBody', {
      fontSize: compact ? '10px' : '12px',
      lineSpacing: compact ? 2 : 3,
    }));
    bodyText.setWordWrapWidth(width - 28, true);
    this.body.add([titleText, bodyText]);
  }

  #drawRewardStrip(g, dungeon, x, y, width, height, compact = false) {
    const { colors } = PHASER_DESIGN;
    g.fillStyle(colors.outlineBrown, 0.24);
    g.fillRoundedRect(x, y + 3, width, height, 16);
    g.fillStyle(0xfff4d2, 1);
    g.fillRoundedRect(x, y, width, height, 16);
    g.lineStyle(2, colors.parchmentShadow, 0.8);
    g.strokeRoundedRect(x + 1, y + 1, width - 2, height - 2, 15);

    const leftText = makeText(this.scene, x + 14, y + (compact ? 8 : 11), `보상 ${dungeon.reward}`, modalTextStyle('rowTitle', {
      fontSize: compact ? '10px' : '12px',
    }));
    const centerText = makeText(this.scene, x + width / 2, y + (compact ? 9 : 12), `성장 ${dungeon.focus}`, modalTextStyle('rowBody', {
      fontSize: compact ? '9px' : '11px',
      color: '#7a431d',
      align: 'center',
    })).setOrigin(0.5, 0);
    const rightText = makeText(this.scene, x + width - 14, y + (compact ? 9 : 12), `D2 ${dungeon.mapId + 10}`, modalTextStyle('rowBody', {
      fontSize: compact ? '9px' : '11px',
      align: 'right',
      color: '#754216',
    })).setOrigin(1, 0);

    leftText.setWordWrapWidth(Math.floor(width * 0.34), true);
    centerText.setWordWrapWidth(Math.floor(width * 0.32), true);
    rightText.setWordWrapWidth(Math.floor(width * 0.24), true);
    this.body.add([leftText, centerText, rightText]);
  }

  #openDungeon() {
    return WEEKDAY_DUNGEONS[currentWeekdayIndex()] || WEEKDAY_DUNGEONS[0];
  }
}

class SkillTreeModal extends BaseModal {
  constructor(manager, options = {}) {
    super(manager, options);
    this.selectedSlotIndex = 0;
    this.selectedItemDataId = 0;
    this.latestState = null;
    this.treeScrollY = 0;
    this.treeScrollMax = 0;
    this.treeViewport = null;
    this.treeScrollContent = null;
    this.treeScrollThumb = null;
    this.treeScrollTrack = null;
    this.treeDrag = null;
    this.treeClickSuppressed = false;
    this.activeTreeLayer = null;
    this.treeWheelHandler = (pointer, _gameObjects, _deltaX, deltaY) => this.#handleTreeWheel(pointer, deltaY);
    this.treePointerDownHandler = pointer => this.#handleTreePointerDown(pointer);
    this.treePointerMoveHandler = pointer => this.#handleTreePointerMove(pointer);
    this.treePointerUpHandler = () => this.#handleTreePointerUp();
    this.scene.input.on('wheel', this.treeWheelHandler);
    this.scene.input.on('pointerdown', this.treePointerDownHandler);
    this.scene.input.on('pointermove', this.treePointerMoveHandler);
    this.scene.input.on('pointerup', this.treePointerUpHandler);
  }

  buildBody(metrics) {
    const board = this.manager.context.board;
    const state = board?.getSkillTreeState?.() || emptySkillTreeState();
    this.latestState = state;
    this.#resolveSelection(state);

    const { colors } = PHASER_DESIGN;
    const g = makeGraphics(this.scene);
    this.body.add(g);

    const compact = metrics.bodyHeight < 590;
    const topY = metrics.innerY;
    const sectionGap = compact ? 4 : 6;
    const treeDetailGap = compact ? 9 : 12;
    const summaryHeight = compact ? 32 : 38;
    const slotsHeight = compact ? 50 : 56;
    const detailHeight = Math.round(clamp(metrics.bodyHeight * 0.255, compact ? 142 : 152, compact ? 160 : 174));
    const treeY = topY + summaryHeight + sectionGap + slotsHeight + sectionGap;
    const detailY = metrics.innerY + metrics.bodyHeight - detailHeight;
    const treeHeight = Math.max(1, detailY - treeY - treeDetailGap);

    this.#drawSummary(g, state, metrics.innerX, topY, metrics.innerWidth, summaryHeight);
    this.#drawSlots(g, state, metrics.innerX, topY + summaryHeight + sectionGap, metrics.innerWidth, slotsHeight);
    this.#drawTreeMap(g, state.skills.slice(0, 12), metrics.innerX, treeY, metrics.innerWidth, treeHeight, colors);
    this.#drawDetailPanel(g, state, metrics.innerX, detailY, metrics.innerWidth, detailHeight, colors);
  }

  resolveActions() {
    return [];
  }

  destroy(fromScene) {
    this.scene.input.off('wheel', this.treeWheelHandler);
    this.scene.input.off('pointerdown', this.treePointerDownHandler);
    this.scene.input.off('pointermove', this.treePointerMoveHandler);
    this.scene.input.off('pointerup', this.treePointerUpHandler);
    super.destroy(fromScene);
  }

  #resolveSelection(state) {
    if (this.payload?.slotIndex != null) {
      this.selectedSlotIndex = clamp(Math.floor(Number(this.payload.slotIndex) || 0), 0, Math.max(0, state.maxSlots - 1));
    }

    const selectedExists = state.skills.some(skill => Number(skill.itemDataId) === Number(this.selectedItemDataId));
    if (selectedExists) return;

    const slotItemId = state.slots[this.selectedSlotIndex]?.itemDataId;
    this.selectedItemDataId = slotItemId
      || state.skills.find(skill => skill.owned)?.itemDataId
      || state.skills[0]?.itemDataId
      || 0;
  }

  #drawSummary(g, state, x, y, width, height) {
    const { colors } = PHASER_DESIGN;
    g.fillStyle(colors.outlineBrown, 0.18);
    g.fillRoundedRect(x, y + 4, width, height, 18);
    g.fillStyle(0xfff8df, 1);
    g.fillRoundedRect(x, y, width, height, 18);
    g.lineStyle(3, colors.parchmentShadow, 0.78);
    g.strokeRoundedRect(x + 1, y + 1, width - 2, height - 2, 17);
    g.fillStyle(0xffffff, 0.28);
    g.fillRoundedRect(x + 10, y + 5, width - 20, Math.max(8, height * 0.32), 11);

    const left = makeText(this.scene, x + 14, y + 9, `Lv.${state.playerLevel} · 슬롯 ${state.slotCount}/${state.maxSlots}`, modalTextStyle('rowTitle', {
      fontSize: height < 46 ? '13px' : '14px',
      color: '#3a1b08',
    }));
    const pointText = makeText(this.scene, x + width - 98, y + 9, `잎 ${formatNumber(state.levelPoints)}`, modalTextStyle('rowBody', {
      fontSize: height < 46 ? '12px' : '13px',
      align: 'right',
      color: '#2f7e20',
    })).setOrigin(1, 0);
    const auto = new DesignButton(this.scene, {
      x: x + width - 39,
      y: y + height / 2,
      width: 74,
      height: Math.min(34, height - 8),
      label: state.autoSkillsEnabled ? 'AUTO\nON' : 'AUTO\nOFF',
      style: state.autoSkillsEnabled ? 'green' : 'wood',
      fontSize: '11px',
      onClick: () => {
        const board = this.manager.context.board;
        board?.setAutoSkillsEnabled?.(!state.autoSkillsEnabled);
        this.rebuild();
      },
    });
    this.body.add([left, pointText, auto]);
  }

  #drawSlots(g, state, x, y, width, height) {
    const { colors } = PHASER_DESIGN;
    g.fillStyle(colors.outlineBrown, 0.16);
    g.fillRoundedRect(x, y + 4, width, height, 18);
    g.fillStyle(0xfff3cf, 1);
    g.fillRoundedRect(x, y, width, height, 18);
    g.lineStyle(3, colors.parchmentShadow, 0.72);
    g.strokeRoundedRect(x + 1, y + 1, width - 2, height - 2, 17);

    const label = makeText(this.scene, x + 12, y + 7, '장착', modalTextStyle('rowTitle', {
      fontSize: height < 64 ? '12px' : '13px',
      color: '#5b2a0e',
    }));
    this.body.add(label);

    const gap = 8;
    const railX = x + (width < 330 ? 58 : 70);
    const railWidth = Math.max(1, width - (width < 330 ? 66 : 80));
    const slotWidth = Math.floor((railWidth - gap * (state.maxSlots - 1)) / state.maxSlots);

    state.slots.forEach(slot => {
      const sx = railX + slot.index * (slotWidth + gap);
      const selected = slot.index === this.selectedSlotIndex;
      const locked = !slot.unlocked;
      const fill = locked ? 0x765236 : selected ? 0xffe36a : 0xffefd0;
      const line = selected ? colors.greenDark : locked ? 0x5a351d : colors.parchmentShadow;
      const cardY = y + 8;
      const cardHeight = height - 14;

      g.fillStyle(colors.outlineBrown, selected ? 0.36 : 0.2);
      g.fillRoundedRect(sx, cardY + 4, slotWidth, cardHeight, 15);
      g.fillStyle(fill, 1);
      g.fillRoundedRect(sx, cardY, slotWidth, cardHeight, 15);
      g.lineStyle(selected ? 4 : 3, line, selected ? 0.95 : 0.82);
      g.strokeRoundedRect(sx + 1, cardY + 1, slotWidth - 2, cardHeight - 2, 14);

      const hit = makeRectangle(this.scene, sx, cardY, slotWidth, cardHeight, 0xffffff, 0.001)
        .setOrigin(0)
        .setInteractive({ useHandCursor: true })
        .on('pointerup', () => {
          playSfx('uiClick', { volume: 0.72 });
          this.selectedSlotIndex = slot.index;
          if (slot.itemDataId) this.selectedItemDataId = slot.itemDataId;
          this.rebuild();
        });

      const meta = slot.item && slot.cooldownSeconds > 0 ? `${Math.ceil(slot.cooldownSeconds)}s` : slot.item ? `Lv.${slot.level}` : locked ? `Lv.${slot.unlock?.level || 1}` : '장착';
      const iconY = cardY + Math.round(cardHeight * 0.38);
      const icon = slot.item
        ? this.#makeSkillIcon(slot.item, sx + slotWidth / 2, iconY, height > 56 ? 30 : 26)
        : makeText(this.scene, sx + slotWidth / 2, iconY, locked ? 'L' : '+', modalTextStyle('button', {
          fontSize: locked ? '17px' : '19px',
          strokeThickness: 3,
          color: locked ? '#fff1c8' : '#ffffff',
        })).setOrigin(0.5);
      const metaText = makeText(this.scene, sx + slotWidth / 2, cardY + cardHeight - 14, meta, modalTextStyle('rowBody', {
        fontSize: slotWidth < 74 ? '9px' : '10px',
        align: 'center',
        color: locked ? '#4b250d' : '#8a4f21',
      })).setOrigin(0.5, 0);
      this.body.add([hit, icon, metaText]);
    });
  }

  #drawTreeMap(g, skills, x, y, width, height, colors) {
    this.treeViewport = null;
    this.treeScrollContent = null;
    this.treeScrollThumb = null;
    this.treeScrollTrack = null;
    this.activeTreeLayer = null;

    g.fillStyle(colors.outlineBrown, 0.24);
    g.fillRoundedRect(x, y + 6, width, height, 22);
    g.fillStyle(0x6b3b1a, 0.72);
    g.fillRoundedRect(x - 2, y - 1, width + 4, height + 4, 22);
    g.fillStyle(0xfff2cf, 1);
    g.fillRoundedRect(x + 4, y + 4, width - 8, height - 8, 19);
    g.fillStyle(0xfffbeb, 0.54);
    g.fillRoundedRect(x + 13, y + 12, width - 26, Math.max(24, height * 0.11), 15);
    g.fillStyle(0xd7a563, 0.16);
    for (let i = 0; i < 5; i += 1) {
      const swirlX = x + 34 + i * Math.max(42, width / 5.5);
      const swirlY = y + 58 + (i % 2) * Math.max(30, height * 0.14);
      g.fillCircle(swirlX, swirlY, 12 + (i % 3) * 4);
      g.fillCircle(swirlX + 17, swirlY + 13, 5 + (i % 2) * 3);
    }
    g.lineStyle(5, colors.line, 0.48);
    g.strokeRoundedRect(x + 1, y + 1, width - 2, height - 2, 21);
    g.lineStyle(2, colors.parchmentShadow, 0.44);
    g.strokeRoundedRect(x + 10, y + 10, width - 20, height - 20, 15);

    if (!skills.length) {
      const empty = makeText(this.scene, x + width / 2, y + height / 2 - 10, '스킬 노드가 없습니다', modalTextStyle('rowTitle', {
        fontSize: '16px',
        align: 'center',
        color: '#5b2a0e',
      })).setOrigin(0.5);
      this.body.add(empty);
      return;
    }

    const viewport = {
      x: x + 10,
      y: y + 36,
      width: Math.max(1, width - 34),
      height: Math.max(1, height - 50),
    };
    const contentHeight = Math.round(clamp(viewport.height * 2.35, viewport.height + 330, 920));
    this.treeViewport = viewport;
    this.treeScrollMax = Math.max(0, contentHeight - viewport.height);
    this.treeScrollY = Math.round(clamp(this.treeScrollY, 0, this.treeScrollMax));

    const maskShape = makeGraphics(this.scene);
    maskShape.fillStyle(0xffffff, 1);
    maskShape.fillRoundedRect(viewport.x, viewport.y, viewport.width, viewport.height, 16);
    maskShape.setVisible(false);
    this.body.add(maskShape);

    const contentLayer = makeContainer(this.scene, 0, -this.treeScrollY);
    const mask = maskShape.createGeometryMask?.();
    if (mask) contentLayer.setMask(mask);
    this.body.add(contentLayer);
    this.treeScrollContent = contentLayer;
    this.activeTreeLayer = contentLayer;

    const treeGraphics = makeGraphics(this.scene);
    contentLayer.add(treeGraphics);

    const layouts = this.#resolveTreeLayouts(skills, x, viewport.y, width, contentHeight);
    this.#drawTreeConnectors(treeGraphics, layouts, colors);

    for (const layout of layouts) {
      this.#drawSkillNode(treeGraphics, layout, colors);
    }
    this.activeTreeLayer = null;

    this.#drawTreeScrollSpine(g, x + width - 19, viewport.y, viewport.height, viewport.height, contentHeight, colors);
    this.#drawLaneBadges(g, x + 13, y + 10, width - 50, colors);
  }

  #drawLaneBadges(g, x, y, width, colors) {
    const badges = [
      { x: x + width * 0.18, label: '공격', color: 0xf08a2a },
      { x: x + width * 0.5, label: '보조', color: colors.green },
      { x: x + width * 0.82, label: '궁극', color: colors.purple },
    ];
    for (const badge of badges) {
      const badgeWidth = 42;
      const badgeHeight = 22;
      g.fillStyle(colors.outlineBrown, 0.88);
      g.fillRoundedRect(badge.x - badgeWidth / 2, y, badgeWidth, badgeHeight, 10);
      g.fillStyle(badge.color, 1);
      g.fillRoundedRect(badge.x - badgeWidth / 2 + 3, y + 3, badgeWidth - 6, badgeHeight - 6, 8);
      g.fillStyle(0xffffff, 0.2);
      g.fillRoundedRect(badge.x - badgeWidth / 2 + 7, y + 4, badgeWidth - 14, 6, 4);
      const text = makeText(this.scene, badge.x, y + badgeHeight / 2 + 1, badge.label, modalTextStyle('button', {
        fontSize: '11px',
        strokeThickness: 3,
      })).setOrigin(0.5);
      this.body.add(text);
    }
  }

  #resolveTreeLayouts(skills, x, y, width, height) {
    const compactTree = height < 285;
    const spineWidth = width >= 318 ? 24 : 16;
    const areaX = x + 8;
    const areaY = y + (compactTree ? 34 : 40);
    const areaWidth = Math.max(1, width - spineWidth - 20);
    const areaHeight = Math.max(1, height - (compactTree ? 92 : 108));
    const baseRadius = Math.round(clamp(
      Math.min(areaWidth * 0.058, areaHeight * 0.064),
      compactTree ? 14 : 15,
      compactTree ? 18 : 20,
    ));

    return skills.map((skill, index) => {
      const node = skillNodeKey(skill);
      const spec = SKILL_TREE_NODE_LAYOUT[node] || SKILL_TREE_FALLBACK_LAYOUT[index % SKILL_TREE_FALLBACK_LAYOUT.length];
      const selected = Number(skill.itemDataId) === Number(this.selectedItemDataId);
      const tierBonus = spec.tier === 'core' || spec.tier === 'ultimate'
        ? (compactTree ? 1 : 2)
        : spec.tier === 'rare'
          ? (compactTree ? 0 : 1)
          : 0;
      return {
        skill,
        node,
        x: Math.round(areaX + areaWidth * spec.x),
        y: Math.round(areaY + areaHeight * spec.y),
        radius: baseRadius + tierBonus,
        tier: spec.tier || 'normal',
        showName: areaHeight >= 210 || selected,
      };
    });
  }

  #drawTreeConnectors(g, layouts, colors) {
    const byId = new Map(layouts.map(layout => [Number(layout.skill.itemDataId), layout]));
    const byNode = new Map(layouts.map(layout => [layout.node, layout]));
    const primaryLinks = [];
    const secondaryLinks = [];

    for (const layout of layouts) {
      const required = skillRequiredItemIds(layout.skill);
      const primaryParentNode = SKILL_TREE_PRIMARY_PARENT_NODE[layout.node];
      let primaryFrom = primaryParentNode ? byNode.get(primaryParentNode) : null;
      if (!primaryFrom && required.length) primaryFrom = byId.get(Number(required[0]));
      if (primaryFrom) primaryLinks.push({ from: primaryFrom, to: layout });

      const selected = Number(layout.skill.itemDataId) === Number(this.selectedItemDataId);
      for (const requiredId of required) {
        const from = byId.get(Number(requiredId));
        if (!from) continue;
        const isPrimary = primaryFrom && Number(from.skill.itemDataId) === Number(primaryFrom.skill.itemDataId);
        const selectedPrereq = selected || Number(from.skill.itemDataId) === Number(this.selectedItemDataId);
        if (!isPrimary && selectedPrereq) secondaryLinks.push({ from, to: layout });
      }
    }

    for (const { from, to } of secondaryLinks) {
      this.#drawVinePath(g, from.x, from.y + from.radius * 0.6, to.x, to.y - to.radius * 0.66, {
        color: 0x8f642f,
        alpha: 0.22,
        width: 2,
        shadowColor: colors.outlineBrown,
        decorated: false,
      });
    }

    for (const { from, to } of primaryLinks) {
      const selectedPath = Number(from.skill.itemDataId) === Number(this.selectedItemDataId)
        || Number(to.skill.itemDataId) === Number(this.selectedItemDataId);
      const active = from.skill.owned && to.skill.owned;
      const ready = from.skill.owned && to.skill.canUnlock;
      const color = selectedPath ? colors.goldHighlight : active ? colors.green : ready ? colors.gold : 0x8f642f;
      const alpha = selectedPath ? 0.98 : active ? 0.88 : ready ? 0.72 : 0.34;
      const width = selectedPath ? 6 : active ? 4 : ready ? 4 : 3;

      this.#drawVinePath(g, from.x, from.y + from.radius * 0.68, to.x, to.y - to.radius * 0.72, {
        color,
        alpha,
        width,
        shadowColor: colors.outlineBrown,
      });
    }
  }

  #drawVinePath(g, x1, y1, x2, y2, { color, alpha, width, shadowColor, decorated = true }) {
    const dy = y2 - y1;
    const lateral = x2 - x1;
    const bendSign = lateral === 0 ? (x1 < this.metrics.x + this.metrics.width / 2 ? -1 : 1) : Math.sign(lateral);
    const bend = Math.max(18, Math.min(42, Math.abs(lateral) * 0.32 + 10));
    const c1x = x1 + bend * bendSign;
    const c1y = y1 + dy * 0.28;
    const c2x = x2 - bend * bendSign;
    const c2y = y1 + dy * 0.74;

    g.lineStyle(width + 6, shadowColor, alpha * 0.25);
    this.#drawSegmentedCurve(g, x1, y1, c1x, c1y, c2x, c2y, x2, y2);

    g.lineStyle(width + 4, 0x6f431d, Math.min(0.78, alpha + 0.05));
    this.#drawSegmentedCurve(g, x1, y1, c1x, c1y, c2x, c2y, x2, y2);

    g.lineStyle(Math.max(2, width - 1), color, alpha);
    this.#drawSegmentedCurve(g, x1, y1, c1x, c1y, c2x, c2y, x2, y2);

    if (decorated) {
      g.lineStyle(2, 0xfff3a5, alpha * 0.38);
      this.#drawSegmentedCurve(g, x1 + 1, y1 - 1, c1x + 1, c1y - 1, c2x + 1, c2y - 1, x2 + 1, y2 - 1);

      this.#drawVineLeaves(g, { x1, y1, c1x, c1y, c2x, c2y, x2, y2 }, Math.max(2, width * 0.45), alpha);
    }
  }

  #drawVineLeaves(g, curve, size, alpha) {
    for (const t of [0.34, 0.66]) {
      const point = this.#curvePoint(curve, t);
      const flip = t < 0.5 ? -1 : 1;
      g.fillStyle(0x3f8f2a, alpha * 0.78);
      g.fillCircle(point.x + flip * size * 1.2, point.y - size * 0.5, size);
      g.fillStyle(0xb8ef65, alpha * 0.68);
      g.fillCircle(point.x + flip * size * 1.05, point.y - size * 0.78, Math.max(1.5, size * 0.55));
    }
  }

  #curvePoint({ x1, y1, c1x, c1y, c2x, c2y, x2, y2 }, t) {
    const inv = 1 - t;
    return {
      x: inv * inv * inv * x1
        + 3 * inv * inv * t * c1x
        + 3 * inv * t * t * c2x
        + t * t * t * x2,
      y: inv * inv * inv * y1
        + 3 * inv * inv * t * c1y
        + 3 * inv * t * t * c2y
        + t * t * t * y2,
    };
  }

  #drawSegmentedCurve(g, x1, y1, c1x, c1y, c2x, c2y, x2, y2) {
    let prevX = x1;
    let prevY = y1;
    const steps = 16;
    for (let i = 1; i <= steps; i += 1) {
      const t = i / steps;
      const inv = 1 - t;
      const nextX = inv * inv * inv * x1
        + 3 * inv * inv * t * c1x
        + 3 * inv * t * t * c2x
        + t * t * t * x2;
      const nextY = inv * inv * inv * y1
        + 3 * inv * inv * t * c1y
        + 3 * inv * t * t * c2y
        + t * t * t * y2;
      g.lineBetween(prevX, prevY, nextX, nextY);
      prevX = nextX;
      prevY = nextY;
    }
  }

  #drawTreeScrollSpine(g, x, y, height, viewportHeight, contentHeight, colors) {
    g.fillStyle(colors.outlineBrown, 0.32);
    g.fillRoundedRect(x - 4, y, 8, height, 6);
    g.fillStyle(0xfff3c2, 0.55);
    g.fillRoundedRect(x - 2, y + 5, 4, Math.max(1, height - 10), 4);
    for (let i = 0; i < 5; i += 1) {
      const dotY = y + 8 + (height - 16) * (i / 4);
      g.fillStyle(colors.outlineBrown, 1);
      g.fillCircle(x, dotY, 5);
      g.fillStyle(0xd7a563, 1);
      g.fillCircle(x, dotY, 3);
    }

    this.treeScrollThumb = makeGraphics(this.scene);
    this.body.add(this.treeScrollThumb);
    this.treeScrollTrack = { x, y, height, viewportHeight, contentHeight, colors };
    this.#redrawTreeScrollThumb();
  }

  #redrawTreeScrollThumb() {
    const g = this.treeScrollThumb;
    const track = this.treeScrollTrack;
    if (!g || !track) return;

    const { x, y, height, viewportHeight, contentHeight, colors } = track;
    const maxScroll = Math.max(0, contentHeight - viewportHeight);
    const ratio = contentHeight > 0 ? clamp(viewportHeight / contentHeight, 0.12, 1) : 1;
    const thumbHeight = Math.round(clamp((height - 8) * ratio, 28, Math.max(28, height - 8)));
    const travel = Math.max(0, height - 8 - thumbHeight);
    const thumbY = y + 4 + (maxScroll > 0 ? travel * (this.treeScrollY / maxScroll) : 0);

    g.clear();
    g.fillStyle(colors.outlineBrown, 1);
    g.fillRoundedRect(x - 8, thumbY - 1, 16, thumbHeight + 2, 8);
    g.fillStyle(0x72b943, 1);
    g.fillRoundedRect(x - 5, thumbY + 2, 10, Math.max(1, thumbHeight - 4), 6);
    g.fillStyle(0xb8ef65, 0.72);
    g.fillRoundedRect(x - 3, thumbY + 5, 6, Math.max(5, thumbHeight * 0.3), 4);
  }

  #setTreeScroll(value) {
    const next = Math.round(clamp(value, 0, this.treeScrollMax));
    if (next === this.treeScrollY) return;
    this.treeScrollY = next;
    this.treeScrollContent?.setY?.(-next);
    this.#redrawTreeScrollThumb();
  }

  #handleTreeWheel(pointer, deltaY = 0) {
    if (!this.visible || !this.#isPointerInsideTree(pointer) || this.treeScrollMax <= 0) return;
    this.#setTreeScroll(this.treeScrollY + deltaY * 0.35);
  }

  #handleTreePointerDown(pointer) {
    if (!this.visible || !this.#isPointerInsideTree(pointer) || this.treeScrollMax <= 0) return;
    this.treeDrag = {
      id: pointer.id,
      startY: pointer.y,
      startScroll: this.treeScrollY,
      moved: false,
    };
    this.treeClickSuppressed = false;
  }

  #handleTreePointerMove(pointer) {
    if (!this.treeDrag || pointer.id !== this.treeDrag.id) return;
    const dy = pointer.y - this.treeDrag.startY;
    if (Math.abs(dy) > 4) {
      this.treeDrag.moved = true;
      this.treeClickSuppressed = true;
    }
    this.#setTreeScroll(this.treeDrag.startScroll - dy);
  }

  #handleTreePointerUp() {
    if (this.treeDrag?.moved) {
      this.treeClickSuppressed = true;
      globalThis.setTimeout?.(() => {
        this.treeClickSuppressed = false;
      }, 0);
    }
    this.treeDrag = null;
  }

  #isPointerInsideTree(pointer) {
    const viewport = this.treeViewport;
    if (!viewport || !pointer) return false;
    return pointer.x >= viewport.x
      && pointer.x <= viewport.x + viewport.width
      && pointer.y >= viewport.y
      && pointer.y <= viewport.y + viewport.height;
  }

  #addTreeObject(object) {
    (this.activeTreeLayer || this.body).add(object);
  }

  #addTreeObjects(objects) {
    (this.activeTreeLayer || this.body).add(objects);
  }

  #drawProgressSpine(g, layouts, x, y, height, colors) {
    if (!layouts.length) return;
    const selected = layouts.find(layout => Number(layout.skill.itemDataId) === Number(this.selectedItemDataId)) || layouts[0];
    const minY = Math.min(...layouts.map(layout => layout.y));
    const maxY = Math.max(...layouts.map(layout => layout.y));
    const selectedRatio = maxY > minY ? clamp((selected.y - minY) / (maxY - minY), 0, 1) : 0;

    g.fillStyle(colors.outlineBrown, 0.28);
    g.fillRoundedRect(x - 4, y, 8, height, 6);
    g.fillStyle(0x8bd45c, 0.75);
    g.fillRoundedRect(x - 3, y + 4, 6, Math.max(10, (height - 8) * selectedRatio), 5);
    for (let i = 0; i < 5; i += 1) {
      const dotY = y + 8 + (height - 16) * (i / 4);
      g.fillStyle(colors.outlineBrown, 1);
      g.fillCircle(x, dotY, 5);
      g.fillStyle(i / 4 <= selectedRatio ? colors.goldHighlight : 0xd7a563, 1);
      g.fillCircle(x, dotY, 3);
    }
    g.fillStyle(colors.outlineBrown, 1);
    g.fillCircle(x, y + 4 + (height - 8) * selectedRatio, 9);
    g.fillStyle(colors.green, 1);
    g.fillCircle(x, y + 4 + (height - 8) * selectedRatio, 6);
  }

  #drawSkillNode(g, layout, colors) {
    const { skill, x, y, radius, tier } = layout;
    const selected = Number(skill.itemDataId) === Number(this.selectedItemDataId);
    const equipped = skill.equippedSlotIndex >= 0;
    const locked = !skill.owned && !skill.canUnlock;
    const canUnlock = !skill.owned && skill.canUnlock;
    const accent = skillNodeAccent(skill, colors);
    const fill = locked ? 0x8b6845 : skill.owned ? 0xfff7dd : 0xf0c86f;
    const inner = locked ? 0x5a351d : tier === 'ultimate' ? 0x382064 : 0x214f23;
    const ring = selected ? colors.goldHighlight : equipped ? colors.gold : skill.owned ? colors.green : canUnlock ? colors.gold : 0x8b5c2f;

    if (selected) {
      g.fillStyle(colors.goldHighlight, 0.2);
      g.fillCircle(x, y, radius + 17);
      g.lineStyle(5, colors.goldHighlight, 0.84);
      g.strokeCircle(x, y, radius + 11);
    }

    if (tier === 'ultimate') {
      for (let i = 0; i < 8; i += 1) {
        const angle = (Math.PI * 2 * i) / 8;
        const px = x + Math.cos(angle) * (radius + 7);
        const py = y + Math.sin(angle) * (radius + 7);
        g.fillStyle(colors.goldHighlight, locked ? 0.32 : 0.86);
        g.fillCircle(px, py, i % 2 === 0 ? 4 : 3);
      }
    } else if (tier === 'core') {
      g.fillStyle(0x8bd45c, locked ? 0.22 : 0.55);
      g.fillCircle(x - radius - 5, y - 1, 5);
      g.fillCircle(x + radius + 5, y - 1, 5);
    }

    g.fillStyle(colors.outlineBrown, 0.42);
    g.fillCircle(x + 3, y + 5, radius + 5);
    g.fillStyle(colors.outlineBrown, 1);
    g.fillCircle(x, y, radius + 5);
    g.fillStyle(accent, locked ? 0.62 : 1);
    g.fillCircle(x, y, radius + 1);
    g.fillStyle(fill, locked ? 0.72 : 1);
    g.fillCircle(x, y, radius - 3);
    g.fillStyle(inner, locked ? 0.56 : 0.9);
    g.fillCircle(x, y, Math.max(8, radius - 9));
    g.lineStyle(selected ? 5 : 3, ring, selected ? 1 : 0.86);
    g.strokeCircle(x, y, radius + 1);
    g.fillStyle(0xffffff, locked ? 0.08 : 0.18);
    g.fillCircle(x - radius * 0.25, y - radius * 0.34, Math.max(5, radius * 0.32));

    const hit = makeRectangle(this.scene, x - radius - 24, y - radius - 18, (radius + 24) * 2, (radius + 26) * 2, 0xffffff, 0.001)
      .setOrigin(0)
      .setInteractive({ useHandCursor: true })
      .on('pointerup', () => {
        if (this.treeClickSuppressed) return;
        playSfx('uiClick', { volume: 0.72 });
        this.selectedItemDataId = skill.itemDataId;
        this.rebuild();
      });

    const icon = this.#makeSkillIcon(skill.item, x, y - 2, Math.max(24, radius * 1.36));
    if (locked) icon.setAlpha?.(0.48);

    const levelLabel = skill.owned ? `Lv.${skill.level}/${skill.maxLevel}` : canUnlock ? `잎 ${skill.unlockCost?.count || 0}` : `Lv.${skill.requiredLevel}`;
    const levelPillWidth = Math.round(clamp(levelLabel.length * 6 + 12, 32, 54));
    const levelPillY = y + radius - 12;
    g.fillStyle(colors.outlineBrown, 0.86);
    g.fillRoundedRect(x - levelPillWidth / 2, levelPillY, levelPillWidth, 14, 7);
    g.fillStyle(locked ? 0x8b5c2f : skill.owned ? 0x2f7e20 : 0xf6b331, 1);
    g.fillRoundedRect(x - levelPillWidth / 2 + 2, levelPillY + 2, levelPillWidth - 4, 10, 5);
    const levelText = makeText(this.scene, x, levelPillY + 7, levelLabel, modalTextStyle('rowBody', {
      fontSize: radius < 19 ? '7px' : '8px',
      fontStyle: 'bold',
      color: '#fff7dd',
      stroke: '#2b1206',
      strokeThickness: 2,
      align: 'center',
    })).setOrigin(0.5);

    let nameText = null;
    if (layout.showName) {
      const nameLabel = compactModalName(skillDisplayName(skill.item?.name), radius < 18 ? 4 : 5);
      const nameY = y + radius + 3;
      const nameWidth = Math.round(clamp(nameLabel.length * 10 + 16, 48, 72));
      g.fillStyle(colors.outlineBrown, locked ? 0.6 : 0.82);
      g.fillRoundedRect(x - nameWidth / 2, nameY, nameWidth, 18, 8);
      g.fillStyle(locked ? 0xd7a563 : 0xfff8df, locked ? 0.72 : 0.95);
      g.fillRoundedRect(x - nameWidth / 2 + 2, nameY + 2, nameWidth - 4, 14, 7);
      nameText = makeText(this.scene, x, nameY + 9, nameLabel, modalTextStyle('rowTitle', {
        fontSize: radius < 18 ? '9px' : '10px',
        align: 'center',
        color: locked ? '#3a2416' : '#3a1b08',
        stroke: '#fff3cf',
        strokeThickness: 3,
      })).setOrigin(0.5);
      nameText.setWordWrapWidth(Math.max(40, nameWidth - 4), false);
    }

    if (skill.owned) this.#drawStateBadge(g, x + radius * 0.76, y - radius * 0.74, '✓', colors.green, colors);
    else if (canUnlock) this.#drawStateBadge(g, x + radius * 0.76, y - radius * 0.74, '+', colors.gold, colors);
    else this.#drawLockBadge(g, x + radius * 0.72, y - radius * 0.72, colors);

    this.#addTreeObjects([hit, icon, levelText]);
    if (nameText) this.#addTreeObject(nameText);
  }

  #drawStateBadge(g, x, y, label, fill, colors) {
    g.fillStyle(colors.outlineBrown, 1);
    g.fillCircle(x, y, 9);
    g.fillStyle(fill, 1);
    g.fillCircle(x, y, 6);
    const text = makeText(this.scene, x, y - 1, label, modalTextStyle('button', {
      fontSize: label.length > 1 ? '6px' : '9px',
      strokeThickness: 2,
    })).setOrigin(0.5);
    this.#addTreeObject(text);
  }

  #drawLockBadge(g, x, y, colors) {
    g.fillStyle(colors.outlineBrown, 1);
    g.fillRoundedRect(x - 8, y - 6, 16, 15, 5);
    g.fillStyle(0xd7a563, 1);
    g.fillRoundedRect(x - 5, y - 2, 10, 9, 3);
    g.lineStyle(2, 0xd7a563, 1);
    g.strokeCircle(x, y - 4, 5);
    g.fillStyle(colors.outlineBrown, 1);
    g.fillCircle(x, y + 2, 2);
  }

  #drawDetailPanel(g, state, x, y, width, height, colors) {
    const selected = this.#selectedSkill(state);
    const slot = state.slots[this.selectedSlotIndex];
    const equippedHere = selected && Number(slot?.itemDataId) === Number(selected.itemDataId);
    const compactDetail = height < 144;

    g.fillStyle(colors.outlineBrown, 0.26);
    g.fillRoundedRect(x, y + 5, width, height, 20);
    g.fillStyle(0xfff8df, 1);
    g.fillRoundedRect(x, y, width, height, 20);
    g.fillStyle(0xffffff, 0.24);
    g.fillRoundedRect(x + 10, y + 7, width - 20, Math.max(18, height * 0.22), 13);
    g.lineStyle(4, colors.parchmentShadow, 0.72);
    g.strokeRoundedRect(x + 1, y + 1, width - 2, height - 2, 19);

    if (!selected) {
      const empty = makeText(this.scene, x + width / 2, y + height / 2 - 9, '스킬을 선택하세요', modalTextStyle('rowTitle', {
        fontSize: '16px',
        align: 'center',
      })).setOrigin(0.5);
      this.body.add(empty);
      return;
    }

    const iconX = x + 42;
    const iconY = y + (compactDetail ? 44 : 49);
    g.fillStyle(colors.outlineBrown, 1);
    g.fillCircle(iconX, iconY, compactDetail ? 32 : 34);
    g.fillStyle(skillNodeAccent(selected, colors), 1);
    g.fillCircle(iconX, iconY, compactDetail ? 27 : 29);
    g.fillStyle(0xfff8df, 1);
    g.fillCircle(iconX, iconY, compactDetail ? 21 : 23);
    const icon = this.#makeSkillIcon(selected.item, iconX, iconY, compactDetail ? 38 : 42);

    const title = makeText(this.scene, x + 84, y + 14, skillDisplayName(selected.item?.name), modalTextStyle('rowTitle', {
      fontSize: compactDetail ? '15px' : '18px',
      color: '#3a1b08',
    }));
    title.setWordWrapWidth(Math.max(120, width - 174), true);

    const chip = this.#detailChip(g, x + width - 82, y + 16, 70, compactDetail ? 22 : 24, skillNodeLabel(selected), skillNodeAccent(selected, colors), colors);
    const effect = makeText(this.scene, x + 84, y + (compactDetail ? 38 : 45), skillEffectLabel(selected), modalTextStyle('rowBody', {
      fontSize: compactDetail ? '10px' : '11px',
      color: '#5b3215',
    }));
    effect.setWordWrapWidth(Math.max(120, width - 174), true);

    const pipsY = y + (compactDetail ? 72 : 82);
    this.#drawLevelPips(g, x + 84, pipsY, selected, colors);
    let prereq = null;
    if (!compactDetail) {
      prereq = makeText(this.scene, x + 84, y + 96, selected.requiredSkills?.length ? `선행 ${selected.requiredSkills.slice(0, 2).join(', ')}` : '기본 노드', modalTextStyle('rowBody', {
        fontSize: '10px',
        color: selected.owned || selected.canUnlock ? '#2f7e20' : '#8f3925',
      }));
      prereq.setWordWrapWidth(Math.max(110, width - 184), true);
    }

    const cost = makeText(this.scene, x + width - 16, pipsY - 11, this.#detailCostLabel(selected), modalTextStyle('rowBody', {
      fontSize: compactDetail ? '11px' : '12px',
      color: selected.canLevelUp || selected.canUnlock ? '#2f7e20' : '#8f3925',
      align: 'right',
    })).setOrigin(1, 0);

    const buttonGap = 12;
    const buttonHeight = Math.round(clamp(height * 0.27, 38, 46));
    const buttonWidth = Math.floor((width - 34 - buttonGap) / 2);
    const buttonY = y + height - buttonHeight / 2 - 13;
    const equipButton = new DesignButton(this.scene, {
      x: x + 17 + buttonWidth / 2,
      y: buttonY,
      width: buttonWidth,
      height: buttonHeight,
      label: equippedHere ? '해제' : selected.owned ? '장착하기' : '미습득',
      style: selected.owned ? 'green' : 'wood',
      fontSize: buttonWidth < 145 ? '14px' : '16px',
      onClick: () => this.#handleEquip(),
    });
    const investButton = new DesignButton(this.scene, {
      x: x + 17 + buttonWidth + buttonGap + buttonWidth / 2,
      y: buttonY,
      width: buttonWidth,
      height: buttonHeight,
      label: this.#investLabel(selected),
      style: 'primary',
      fontSize: buttonWidth < 145 ? '14px' : '16px',
      onClick: () => this.#handleInvest(),
    });

    this.body.add([icon, title, chip, effect, cost, equipButton, investButton]);
    if (prereq) this.body.add(prereq);
  }

  #detailChip(g, x, y, width, height, label, fill, colors) {
    g.fillStyle(colors.outlineBrown, 1);
    g.fillRoundedRect(x, y, width, height, 12);
    g.fillStyle(fill, 1);
    g.fillRoundedRect(x + 3, y + 3, width - 6, height - 6, 9);
    return makeText(this.scene, x + width / 2, y + height / 2 + 1, label, modalTextStyle('button', {
      fontSize: label.length > 4 ? '9px' : '11px',
      strokeThickness: 3,
      align: 'center',
    })).setOrigin(0.5);
  }

  #drawLevelPips(g, x, y, skill, colors) {
    const max = Math.max(1, Math.min(5, Number(skill.maxLevel || 5)));
    const level = Math.max(0, Number(skill.level || 0));
    for (let i = 0; i < max; i += 1) {
      const cx = x + i * 17;
      g.fillStyle(colors.outlineBrown, 0.88);
      g.fillCircle(cx, y, 7);
      g.fillStyle(i < level ? colors.green : 0x7d5a34, 1);
      g.fillCircle(cx, y, 5);
      if (i < level) {
        g.fillStyle(0xb8ef65, 0.72);
        g.fillCircle(cx - 2, y - 2, 2);
      }
    }
  }

  #detailCostLabel(skill) {
    if (!skill) return '';
    if (!skill.owned) return skill.canUnlock ? `필요 잎 ${skill.unlockCost?.count || 0}` : (skill.unlock?.message || '잠김');
    if (skill.level >= skill.maxLevel) return '최대 레벨';
    const cost = this.#costLabel(skill.levelUp?.cost);
    return skill.canLevelUp ? `필요 ${cost}` : `부족 ${cost}`;
  }

  #handleInvest() {
    const board = this.manager.context.board;
    const state = board?.getSkillTreeState?.() || emptySkillTreeState();
    const selected = this.#selectedSkill(state);
    if (!selected) return;

    const result = selected.owned
      ? board.levelUpSkillItem(selected.itemDataId)
      : board.unlockSkillItem(selected.itemDataId);
    this.#pushResult(result, selected.owned ? 'upgrade' : 'loot');
    this.rebuild();
  }

  #handleEquip() {
    const board = this.manager.context.board;
    const state = board?.getSkillTreeState?.() || emptySkillTreeState();
    const selected = this.#selectedSkill(state);
    const slot = state.slots[this.selectedSlotIndex];

    let result;
    if (!slot?.unlocked) {
      result = { ok: false, message: `슬롯 ${this.selectedSlotIndex + 1} 잠김` };
    } else if (!selected?.owned) {
      result = { ok: false, message: selected ? `${selected.item?.name} 먼저 해금` : '스킬 선택 필요' };
    } else if (Number(slot.itemDataId) === Number(selected.itemDataId)) {
      result = board.unequipSkill(this.selectedSlotIndex);
    } else {
      result = board.equipSkill(this.selectedSlotIndex, selected.itemDataId);
    }

    this.#pushResult(result, 'loot');
    this.rebuild();
  }

  #selectedSkill(state) {
    return state.skills.find(skill => Number(skill.itemDataId) === Number(this.selectedItemDataId)) || state.skills[0] || null;
  }

  #investLabel(skill) {
    if (!skill) return '선택';
    if (!skill.owned) return skill.canUnlock ? `해금 ${skill.unlockCost?.count || 0}` : '잠김';
    if (skill.level >= skill.maxLevel) return 'MAX';
    if (skill.canLevelUp) return '업그레이드';
    return skill.levelUp?.reason === 'not_enough_material'
      ? `부족 ${this.#costLabel(skill.levelUp?.cost)}`
      : '업그레이드';
  }

  #costLabel(cost = []) {
    const first = cost?.[0];
    const count = Math.max(0, Math.floor(Number(first?.count || 0)));
    return count > 0 ? formatNumber(count) : '0';
  }

  #makeSkillIcon(item, x, y, size = 25) {
    const key = skillIconTextureKey(item);
    if (key && this.scene.textures.exists(key)) {
      return makeImage(this.scene, x, y, key)
        .setDisplaySize(size, size)
        .setOrigin(0.5);
    }

    return makeText(this.scene, x, y, skillInitial(item?.name), modalTextStyle('button', {
      fontSize: `${Math.max(12, Math.floor(size * 0.52))}px`,
      strokeThickness: 3,
    })).setOrigin(0.5);
  }

  #pushResult(result, type = 'info') {
    const ok = result?.ok !== false;
    playSfx(ok ? 'reward' : 'uiError', { volume: ok ? 0.62 : 0.72 });
    this.manager.context.messages?.push({
      type: ok ? type : 'warning',
      icon: ok ? '*' : '!',
      title: ok ? '스킬' : '스킬 실패',
      body: result?.message || (ok ? '완료' : '조건 부족'),
      duration: ok ? 1800 : 2400,
    });
  }
}

class RewardModal extends BaseModal {
  buildBody(metrics) {
    const board = this.manager.context.board;
    const { colors } = PHASER_DESIGN;
    const g = makeGraphics(this.scene);
    const cx = metrics.innerX + metrics.innerWidth / 2;
    const top = metrics.innerY + 12;
    const cardWidth = Math.min(180, (metrics.innerWidth - 28) / 2);

    this.body.add(g);
    this.#drawRewardCard(g, cx - cardWidth / 2 - 12, top, cardWidth, '골드', formatNumber(board?.gold || 0), '$', colors.gold);
    this.#drawRewardCard(g, cx + 12, top, cardWidth, '경험치', formatNumber(board?.exp || 0), 'XP', colors.purple);

    const summaryY = top + 132;
    g.fillStyle(colors.outlineBrown, 0.16);
    g.fillRoundedRect(metrics.innerX, summaryY + 4, metrics.innerWidth, 88, 18);
    g.fillStyle(colors.cream, 1);
    g.fillRoundedRect(metrics.innerX, summaryY, metrics.innerWidth, 88, 18);
    g.lineStyle(3, colors.parchmentShadow, 0.74);
    g.strokeRoundedRect(metrics.innerX + 2, summaryY + 2, metrics.innerWidth - 4, 84, 16);

    const playerWon = board?.winningTeam === TEAM.PLAYER || !board?.gameEnded;
    const title = makeText(this.scene, cx, summaryY + 20, playerWon ? '전투 보상이 준비되었습니다' : '재도전 보상 준비 중', modalTextStyle('rowTitle', {
      fontSize: '20px',
      align: 'center',
    })).setOrigin(0.5, 0);
    const body = makeText(this.scene, cx, summaryY + 50, '골드와 성장 재화 흐름을 이 모달에서 한 번에 정산하도록 확장할 수 있습니다.', modalTextStyle('rowBody', {
      fontSize: '14px',
      align: 'center',
      wordWrap: { width: metrics.innerWidth - 48, useAdvancedWrap: true },
    })).setOrigin(0.5, 0);
    this.body.add([title, body]);
  }

  resolveActions() {
    return [
      { label: '나중에', style: 'wood', onClick: () => this.close() },
      {
        label: '받기',
        style: 'primary',
        onClick: () => {
          this.manager.context.messages?.push({
            type: 'loot',
            icon: '$',
            title: '보상 확인',
            body: '성장 보상 모달 액션',
            duration: 1800,
          });
          this.close();
        },
      },
    ];
  }

  #drawRewardCard(g, x, y, width, label, value, icon, accent) {
    const { colors } = PHASER_DESIGN;
    g.fillStyle(colors.outlineBrown, 0.28);
    g.fillRoundedRect(x, y + 4, width, 112, 20);
    g.fillStyle(colors.woodMid, 1);
    g.fillRoundedRect(x, y, width, 112, 20);
    g.fillStyle(colors.cream, 1);
    g.fillRoundedRect(x + 9, y + 9, width - 18, 94, 15);
    g.fillStyle(colors.outlineBrown, 1);
    g.fillCircle(x + width / 2, y + 34, 25);
    g.fillStyle(accent, 1);
    g.fillCircle(x + width / 2, y + 34, 20);

    const iconText = makeText(this.scene, x + width / 2, y + 33, icon, modalTextStyle('button', {
      fontSize: icon.length > 1 ? '13px' : '18px',
      strokeThickness: 3,
    })).setOrigin(0.5);
    const valueText = makeText(this.scene, x + width / 2, y + 62, value, modalTextStyle('value', {
      fontSize: '26px',
      strokeThickness: 5,
    })).setOrigin(0.5, 0);
    const labelText = makeText(this.scene, x + width / 2, y + 91, label, modalTextStyle('rowBody', {
      fontSize: '13px',
      align: 'center',
    })).setOrigin(0.5, 0);
    this.body.add([iconText, valueText, labelText]);
  }
}

function visibleAchievements(store) {
  return [...(store?.achievements?.values?.() || [])]
    .filter(isVisibleAchievement)
    .sort((a, b) => (
      asFiniteNumber(a.order, Number(a.id) || 999999) - asFiniteNumber(b.order, Number(b.id) || 999999)
      || Number(a.id) - Number(b.id)
    ));
}

function isVisibleAchievement(achievement) {
  return Boolean(achievement?.name && achievement?.condition)
    && !achievementTags(achievement).includes('HideDisplay');
}

function achievementTags(achievement) {
  return Array.isArray(achievement?.tags) ? achievement.tags : [];
}

function achievementCategoryId(achievement) {
  const condition = achievement?.condition;
  const value1 = Number(achievement?.conditionValue1 || 0);
  if (condition === 'HasItemLevel' && value1 === 1) return 'level';
  if (condition === 'HasItemLevel' && ACHIEVEMENT_STAT_ITEM_IDS.has(value1)) return 'stat';
  if (condition === 'BuyItemProduct' && value1 === ACHIEVEMENT_EQUIPMENT_SUMMON_PRODUCT_ID) return 'summon';
  if (condition === 'AcquireEquipmentItemAny') return 'equipment';
  if (condition === 'AcquireWeaponItemAny') return 'weapon';
  if (['WinGame', 'WinWave', 'KillUnitAny', 'UseSkill', 'AcquireItem', 'AcquireItemAny'].includes(condition)) return 'combat';
  return 'all';
}

function sortAchievementEntries(a, b) {
  const doneDelta = Number(a.progress.completed) - Number(b.progress.completed);
  if (doneDelta) return doneDelta;
  const ratioDelta = b.progress.ratio - a.progress.ratio;
  if (Math.abs(ratioDelta) > 0.0001) return ratioDelta;
  return (asFiniteNumber(a.achievement.order, a.achievement.id) - asFiniteNumber(b.achievement.order, b.achievement.id))
    || Number(a.achievement.id) - Number(b.achievement.id);
}

function summarizeAchievementList(achievements, board) {
  const total = achievements.length;
  const completed = achievements.filter(achievement => (
    board?.getAchievementProgress?.(achievement)?.completed
  )).length;
  return {
    total,
    completed,
    remaining: Math.max(0, total - completed),
    ratio: total > 0 ? completed / total : 0,
  };
}

function emptyAchievementProgress(achievement) {
  const target = Math.max(1, Math.floor(asFiniteNumber(
    achievement?.condition === 'HasItemLevel' ? achievement?.conditionValue2 : achievement?.targetProgress,
    1,
  )));
  return { progress: 0, target, completed: false, ratio: 0 };
}

function achievementIcon(achievement) {
  const condition = achievement?.condition;
  if (condition === 'HasItemLevel' && Number(achievement.conditionValue1) === 1) return 'LV';
  if (condition === 'HasItemLevel') return '+';
  if (condition === 'BuyItemProduct') return 'S';
  if (condition === 'AcquireEquipmentItemAny') return 'G';
  if (condition === 'AcquireWeaponItemAny') return 'W';
  if (condition === 'UseSkill') return 'SK';
  if (condition === 'KillUnitAny') return 'K';
  if (condition === 'WinGame' || condition === 'WinWave') return 'M';
  return '*';
}

function achievementRequirementLabel(achievement, store, progress = emptyAchievementProgress(achievement)) {
  const current = `${formatNumber(progress.progress)}/${formatNumber(progress.target)}`;
  const condition = achievement?.condition;
  if (condition === 'HasItemLevel') {
    const item = store?.getItem?.(achievement.conditionValue1);
    return `${item?.name || '레벨'} Lv.${formatNumber(progress.target)}`;
  }
  if (condition === 'BuyItemProduct') return `소환 ${current}`;
  if (condition === 'AcquireEquipmentItemAny') return `장비 ${current}`;
  if (condition === 'AcquireWeaponItemAny') return `무기 ${current}`;
  if (condition === 'AcquireItem') {
    const item = store?.getItem?.(achievement.conditionValue1);
    return `${item?.name || '아이템'} ${current}`;
  }
  if (condition === 'KillUnitAny') return `처치 ${current}`;
  if (condition === 'UseSkill') return `스킬 ${current}`;
  if (condition === 'WinGame') return `클리어 ${current}`;
  if (condition === 'WinWave') return `돌파 ${current}`;
  return `진행 ${current}`;
}

function achievementRewardLabel(achievement, store) {
  const rewards = (achievement?.rewardAddItemGroups || [])
    .flatMap(group => group.addItems || [])
    .slice(0, 2)
    .map(addItem => {
      const item = store?.getItem?.(addItem.itemDataId);
      const count = Math.max(0, Math.floor(asFiniteNumber(addItem.count, addItem.minCount || 1)));
      return `${item?.name || addItem.itemDataId} ${formatNumber(count)}`;
    });
  const extraCount = Math.max(0, (achievement?.rewardAddItemGroups || [])
    .flatMap(group => group.addItems || [])
    .length - rewards.length);
  if (!rewards.length) return '보상 없음';
  return extraCount > 0 ? `보상 ${rewards.join(', ')} +${extraCount}` : `보상 ${rewards.join(', ')}`;
}

function asFiniteNumber(value, fallback = 0) {
  const n = Number(value);
  return Number.isFinite(n) ? n : fallback;
}

function emptySkillTreeState() {
  return {
    treeId: 'Mushroomer',
    playerLevel: 1,
    levelPoints: 0,
    autoSkillsEnabled: true,
    slotCount: 1,
    maxSlots: 4,
    slots: [],
    skills: [],
  };
}

function compactModalName(name, maxLength = 6) {
  const cleaned = String(name || '스킬').replace(/\s+/g, '');
  return cleaned.length > maxLength ? cleaned.slice(0, maxLength) : cleaned;
}

function skillDisplayName(name) {
  return String(name || '스킬').replace(/서$/, '').replace(/학습$/, '');
}

function skillIconTextureKey(item) {
  const path = itemSpritePath(item);
  if (!path || !SKILL_ICON_PATHS.includes(path)) return '';
  return textureKeyForAssetPath(path);
}

function textureKeyForAssetPath(path) {
  return `asset-${String(path || '').replace(/[^a-z0-9]+/gi, '-').replace(/^-|-$/g, '').toLowerCase()}`;
}

function itemSpritePath(item) {
  const spriteGroups = item?.spriteGroups || item?.SpriteGroups || {};
  return String(spriteGroups.Icon || spriteGroups.icon || item?.sprite || item?.Sprite || '').trim();
}

function skillInitial(name) {
  const cleaned = String(name || '스').replace(/\s+/g, '');
  return cleaned.slice(0, 1) || '스';
}

function skillNodeKey(skill) {
  return String(skill?.node || skill?.item?.popupArgs?.SkillTreeNode || '').trim();
}

function skillRequiredItemIds(skill) {
  return String(skill?.item?.popupArgs?.RequiredSkillItemDataIds || '')
    .split(',')
    .map(value => Number(String(value).trim()))
    .filter(value => Number.isFinite(value) && value > 0);
}

function skillNodeAccent(skill, colors) {
  const node = skillNodeKey(skill);
  if (node === 'Root' || node === 'Buff' || node === 'Merge') return colors.green;
  if (node === 'Meteor' || node === 'Ultimate') return colors.purple;
  if (node === 'Rain' || node === 'Rage' || node === 'Overrun') return 0xd86a2a;
  if (skill?.skill?.tags?.includes?.('Buff')) return colors.green;
  if (skill?.skill?.tags?.includes?.('AoE')) return colors.purple;
  return colors.gold;
}

function skillNodeLabel(skill) {
  const node = skillNodeKey(skill);
  if (node === 'Root') return '코어';
  if (node === 'Buff' || node === 'Merge') return '지원';
  if (node === 'Meteor' || node === 'Ultimate') return '궁극';
  if (skill?.skill?.tags?.includes?.('Buff')) return '버프';
  if (skill?.skill?.tags?.includes?.('AoE')) return '광역';
  if (skill?.skill?.tags?.includes?.('Boss')) return '보스';
  return '공격';
}

function skillEffectLabel(skill) {
  const def = skill?.skill;
  const cooldown = Number(def?.cooldown || 0);
  const hits = (def?.timelines || [])
    .map(timeline => timeline?.hit)
    .filter(Boolean);
  const maxHit = Math.max(1, ...hits.map(hit => Number(hit.maxHit || 1)).filter(Number.isFinite));
  const damages = hits.flatMap(hit => (
    hit?.addDamage?.attackPercentDamages
      || hit?.addDamage?.damagePercent
      || []
  ));
  const damage = damages
    .map(value => Number(value))
    .filter(Number.isFinite)
    .map(value => value > 10 ? value : value * 100)
    .sort((a, b) => b - a)[0];
  const target = maxHit > 1 || def?.tags?.includes?.('AoE') ? `광역 ${maxHit}타` : '단일 타격';
  const power = Number.isFinite(damage) ? `${Math.round(damage)}%` : '특수 효과';
  const cool = cooldown > 0 ? `쿨 ${cooldown.toFixed(cooldown >= 10 ? 0 : 1)}초` : '자동 발동';
  return `${target} · ${power} · ${cool}`;
}

async function createModalOverlayScene(hostId) {
  const element = document.getElementById(hostId) || createModalHost(hostId);
  const bounds = element.getBoundingClientRect();
  const width = Math.max(320, Math.round(bounds.width || 420));
  const height = Math.max(520, Math.round(bounds.height || 760));
  const readyEvent = new Promise(resolve => {
    globalThis.addEventListener('mushroomer-modal-scene-ready', event => resolve(event.detail.scene), { once: true });
  });
  const Phaser = globalThis.Phaser;
  const game = new Phaser.Game({
    type: Phaser.WEBGL,
    parent: element,
    width,
    height,
    transparent: true,
    backgroundColor: 'rgba(0, 0, 0, 0)',
    banner: false,
    audio: { noAudio: true },
    scene: IdlezModalScene,
    scale: {
      mode: Phaser.Scale.RESIZE ?? Phaser.Scale.FIT,
      autoCenter: Phaser.Scale.NO_CENTER,
    },
  });
  const scene = await readyEvent;
  return { scene, game, element };
}

function createModalHost(id) {
  const element = document.createElement('div');
  element.id = id;
  element.className = 'modal-stage';
  element.setAttribute('aria-hidden', 'true');
  document.querySelector('.app')?.append(element);
  return element;
}

function currentWeekdayIndex(date = new Date()) {
  const day = date.getDay();
  return day === 0 ? 6 : day - 1;
}

function languageLabel(code) {
  return LANGUAGE_OPTIONS.find(option => option.code === code)?.label || code || '한국어';
}

function resolvePlayerIdentity(context = {}) {
  const player = context.session?.player || {};
  const serverId = firstIdentityValue(
    player.id,
    player.Id,
    player.playerId,
    player.PlayerId,
    player.playerID,
  );
  const localId = getOrCreateLocalPlayerId();
  return {
    primary: serverId || localId,
    localId,
    serverId,
    networkState: serverId ? '서버 ID' : (context.network?.state || '로컬 ID'),
  };
}

function firstIdentityValue(...values) {
  for (const value of values) {
    if (value == null || value === '') continue;
    const text = String(value?.toString?.() ?? value).trim();
    if (text) return text;
  }
  return '';
}

function compactIdentity(value, head = 11, tail = 8) {
  const text = String(value || '');
  if (text.length <= head + tail + 3) return text;
  return `${text.slice(0, head)}...${text.slice(-tail)}`;
}

function wrapIdentity(value, groupSize = 24) {
  const text = String(value || '-');
  const parts = [];
  for (let index = 0; index < text.length; index += groupSize) {
    parts.push(text.slice(index, index + groupSize));
  }
  return parts.join('\n');
}

function featureTitle(id) {
  return ({
    pass: '시즌 패스',
    speed: '전투 속도',
    auto: '자동 강화',
    growth: '성장',
    companion: '동료',
    equipment: '장비',
    pet: '펫',
    adventure: '모험',
    settings: '설정',
  })[id] || '메뉴';
}
