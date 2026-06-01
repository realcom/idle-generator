import { TEAM, clamp, formatNumber } from './constants.js?v=mushroomer';
import {
  PHASER_DESIGN,
  UI_ASSET_PATHS,
  modalTextStyle,
  textureForButtonStyle,
} from './design-system.js?v=mushroomer';

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
  guild: [
    { icon: 'G', title: '길드', body: '잠긴 기능도 같은 모달 껍데기로 미리보기 처리합니다.', meta: 'Lock' },
    { icon: '+', title: '협동 보상', body: '기여도, 출석, 레이드 보상 리스트를 재사용합니다.', meta: 'Plan' },
  ],
};

export function preloadModalAssets(scene) {
  for (const [key, path] of Object.entries(UI_ASSET_PATHS)) {
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
  constructor(scene, { x = 0, y = 0, width = 160, height = 52, label = 'OK', style = 'wood', onClick = null } = {}) {
    super(scene, x, y);
    this.buttonWidth = width;
    this.buttonHeight = height;
    this.label = label;
    this.style = style;
    this.onClick = onClick;
    this.isPressed = false;

    this.bg = makeGraphics(scene);
    this.image = null;
    this.labelText = makeText(scene, 0, 0, label, modalTextStyle(style === 'close' ? 'close' : 'button'));
    this.labelText.setOrigin(0.5);
    this.add([this.bg, this.labelText]);

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
    this.input?.hitArea?.setTo?.(-this.buttonWidth / 2, -this.buttonHeight / 2, this.buttonWidth, this.buttonHeight);

    if (texture && this.scene.textures.exists(texture)) {
      if (!this.image) {
        this.image = makeImage(this.scene, 0, 0, texture);
        this.addAt(this.image, 0);
      }
      this.image
        .setTexture(texture)
        .setDisplaySize(this.buttonWidth, this.buttonHeight)
        .setVisible(true);
      this.bg.clear();
    } else {
      this.image?.setVisible(false);
      this.#drawFallbackButton();
    }

    this.labelText
      .setText(this.label)
      .setStyle(modalTextStyle(this.style === 'close' ? 'close' : 'button', {
        fontSize: this.buttonHeight < 44 ? '16px' : '18px',
        wordWrap: { width: this.buttonWidth - 26, useAdvancedWrap: true },
      }))
      .setPosition(0, -1);

    if (Phaser?.Geom?.Rectangle) {
      this.setInteractive(
        new Phaser.Geom.Rectangle(-this.buttonWidth / 2, -this.buttonHeight / 2, this.buttonWidth, this.buttonHeight),
        Phaser.Geom.Rectangle.Contains,
      );
    }
  }

  #bindInput() {
    this.on('pointerdown', () => this.#press());
    this.on('pointerout', () => this.#release(false));
    this.on('pointerup', () => this.#release(true));
  }

  #press() {
    if (this.isPressed) return;
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
      if (this.options.closeOnBackdrop) this.close();
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
    let x = metrics.x + PHASER_DESIGN.modal.contentInset + buttonWidth / 2;

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
    const modalWidth = Math.round(clamp(width * 0.76, 420, 720));
    const modalHeight = Math.round(clamp(height * 0.68, 420, 580));
    const x = Math.round((width - modalWidth) / 2);
    const y = Math.round((height - modalHeight) / 2);
    const contentInset = PHASER_DESIGN.modal.contentInset;
    const headerBottom = y + 112;
    const footerTop = y + modalHeight - PHASER_DESIGN.modal.footerHeight - 10;

    return {
      sceneWidth: width,
      sceneHeight: height,
      x,
      y,
      width: modalWidth,
      height: modalHeight,
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

    this.backdrop.setDisplaySize(metrics.sceneWidth, metrics.sceneHeight);
    g.clear();
    g.fillStyle(colors.shadow, 0.5);
    g.fillRoundedRect(metrics.x + 9, metrics.y + 12, metrics.width, metrics.height, r);
    g.fillStyle(colors.outlineBrown, 1);
    g.fillRoundedRect(metrics.x, metrics.y, metrics.width, metrics.height, r);
    g.fillStyle(colors.woodMid, 1);
    g.fillRoundedRect(metrics.x + 8, metrics.y + 8, metrics.width - 16, metrics.height - 16, r - 5);
    g.fillStyle(colors.woodDark, 0.74);
    g.fillRoundedRect(metrics.x + 18, metrics.y + 74, metrics.width - 36, metrics.height - 154, 22);
    g.fillStyle(colors.parchment, 1);
    g.fillRoundedRect(metrics.x + 24, metrics.y + 82, metrics.width - 48, metrics.height - 170, 18);
    g.lineStyle(4, colors.line, 0.55);
    g.strokeRoundedRect(metrics.x + 24, metrics.y + 82, metrics.width - 48, metrics.height - 170, 18);

    g.fillStyle(colors.gold, 1);
    g.fillRoundedRect(metrics.x + 74, metrics.y + 18, metrics.width - 148, 62, 23);
    g.fillStyle(colors.goldHighlight, 0.72);
    g.fillRoundedRect(metrics.x + 88, metrics.y + 25, metrics.width - 176, 20, 12);
    g.lineStyle(5, colors.line, 0.75);
    g.strokeRoundedRect(metrics.x + 74, metrics.y + 18, metrics.width - 148, 62, 23);

    this.titleText.setText(this.options.title).setPosition(metrics.x + metrics.width / 2, metrics.y + 43);
    this.kickerText
      .setText(this.options.kicker || '')
      .setVisible(Boolean(this.options.kicker))
      .setPosition(metrics.x + metrics.width / 2, metrics.y + 91);
    this.closeButton.setLayout({ x: metrics.x + metrics.width - 42, y: metrics.y + 42, width: 42, height: 42 });
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
    const mapName = board?.map?.name || '전장 로딩 중';

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

class FeatureListModal extends ListModal {
  resolveActions() {
    return [
      { label: '닫기', style: 'wood', onClick: () => this.close() },
      { label: '확인', style: 'green', onClick: () => this.close() },
    ];
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
    type: Phaser.CANVAS,
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
    guild: '길드',
  })[id] || '메뉴';
}
