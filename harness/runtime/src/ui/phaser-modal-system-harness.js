const params = new URLSearchParams(globalThis.location.search || '');
const requestedTheme = params.get('game') || 'ninja2';
const theme = requestedTheme === 'ninja2' ? requestedTheme : 'ninja2';
const initialVariant = params.get('variant') || params.get('modal') || 'shell';
const initialSize = params.get('size') || 'portrait';

const COLORS = {
  ink: 0x171f18,
  shadow: 0x09100d,
  forest: 0x173224,
  deepForest: 0x102117,
  moss: 0x6f9d48,
  grass: 0x87ad51,
  parchment: 0xf4dfb1,
  parchmentLight: 0xfff1c8,
  parchmentDark: 0xc59d63,
  cream: 0xf8ead1,
  gold: 0xffc64a,
  orange: 0xf47b22,
  teal: 0x36e0d4,
  red: 0xb94e35,
  muted: 0x6b654d,
  row: 0xe5c88f,
  rowDark: 0xa8763c,
};

const ASSETS = {
  panel: `assets/${theme}/ui/panel_parchment_9slice.png`,
  crest: `assets/${theme}/ui/level-choice/frame_crest.png`,
  corner: `assets/${theme}/ui/level-choice/frame_corner_leaf.png`,
  background: `assets/${theme}/home/background_forest_sanctuary.png`,
  guardian: `assets/${theme}/battle/characters/guardian_hero.png`,
  enemyA: `assets/${theme}/battle/characters/enemy_leaf_imp.png`,
  enemyB: `assets/${theme}/battle/characters/enemy_soot_spirit.png`,
  coin: `assets/${theme}/ui/icons/icon_coin.png`,
  soul: `assets/${theme}/ui/icons/icon_soul.png`,
  wood: `assets/${theme}/ui/icons/icon_wood.png`,
  stone: `assets/${theme}/ui/icons/icon_stone.png`,
};

const VARIANTS = {
  shell: {
    title: '모달 쉘',
    kicker: 'COMMON',
    subtitle: '공통 프레임과 슬롯',
    widthRatio: 0.86,
    heightRatio: 0.64,
    minHeight: 370,
    maxHeight: 580,
    actions: [
      { label: '보조', style: 'secondary' },
      { label: '주요', style: 'primary' },
    ],
  },
  confirm: {
    title: '확인',
    kicker: 'CONFIRM',
    subtitle: '선택을 적용할까요?',
    widthRatio: 0.78,
    heightRatio: 0.44,
    minHeight: 300,
    maxHeight: 410,
    actions: [
      { label: '취소', style: 'secondary' },
      { label: '확인', style: 'primary' },
    ],
  },
  reward: {
    title: '보상',
    kicker: 'REWARD',
    subtitle: '획득 결과',
    widthRatio: 0.84,
    heightRatio: 0.52,
    minHeight: 350,
    maxHeight: 470,
    actions: [
      { label: '받기', style: 'primary' },
    ],
  },
  list: {
    title: '임무 목록',
    kicker: 'LIST',
    subtitle: '스크롤 행',
    widthRatio: 0.84,
    heightRatio: 0.64,
    minHeight: 390,
    maxHeight: 560,
    actions: [
      { label: '닫기', style: 'secondary' },
    ],
  },
  settings: {
    title: '설정',
    kicker: 'SETTINGS',
    subtitle: '토글 행',
    widthRatio: 0.82,
    heightRatio: 0.58,
    minHeight: 370,
    maxHeight: 520,
    actions: [
      { label: '저장', style: 'primary' },
    ],
  },
  skillChoice: {
    title: '레벨 업!',
    kicker: 'SKILL CHOICE',
    subtitle: '스킬을 선택하세요',
    widthRatio: 0.92,
    heightRatio: 0.68,
    minHeight: 470,
    maxHeight: 620,
    hideClose: true,
    actions: [],
  },
  notice: {
    title: '알림',
    kicker: 'NOTICE',
    subtitle: '상태 안내',
    widthRatio: 0.72,
    heightRatio: 0.32,
    minHeight: 240,
    maxHeight: 320,
    actions: [
      { label: '확인', style: 'primary' },
    ],
  },
};

const statusEl = document.getElementById('previewStatus');
const logEl = document.getElementById('previewLog');
const stageEl = document.getElementById('modalStage');
const phoneEl = document.getElementById('previewPhone');

let harnessScene = null;

const context = {
  gameId: theme,
  requestedTheme,
  variant: initialVariant,
  openModal: variant => harnessScene?.openVariant(variant),
  setPreviewSize,
  getSnapshot: () => harnessScene?.getSnapshot() || null,
};

globalThis.__idlezPhaserUiHarness = context;

function boot() {
  if (!globalThis.Phaser) {
    setStatus('Phaser missing', true);
    pushLog('Error', 'Phaser CDN failed to load.');
    return;
  }

  phoneEl.dataset.size = initialSize;
  bindControls();
  setActiveSizeButton(initialSize);

  const game = new Phaser.Game({
    type: Phaser.WEBGL,
    parent: 'modalStage',
    width: stageEl.clientWidth || 440,
    height: stageEl.clientHeight || 782,
    backgroundColor: '#102117',
    transparent: false,
    scale: {
      mode: Phaser.Scale.RESIZE ?? Phaser.Scale.FIT,
      autoCenter: Phaser.Scale.CENTER_BOTH,
      width: stageEl.clientWidth || 440,
      height: stageEl.clientHeight || 782,
    },
    scene: ModalHarnessScene,
  });

  context.game = game;
}

class ModalHarnessScene extends Phaser.Scene {
  constructor() {
    super('ModalHarnessScene');
    this.variant = VARIANTS[initialVariant] ? initialVariant : 'shell';
    this.lastSnapshot = null;
  }

  preload() {
    for (const [key, path] of Object.entries(ASSETS)) {
      this.load.image(key, path);
    }
  }

  create() {
    harnessScene = this;
    context.scene = this;
    this.scale.on('resize', () => this.redraw());
    document.documentElement.dataset.uiHarnessReady = 'true';
    document.documentElement.dataset.modalHarnessTheme = theme;
    stageEl.classList.add('is-active');
    setStatus('Ready');
    this.openVariant(this.variant);
  }

  openVariant(variant) {
    this.variant = VARIANTS[variant] ? variant : 'shell';
    context.variant = this.variant;
    stageEl.classList.add('is-active');
    stageEl.setAttribute('aria-hidden', 'false');
    document.documentElement.dataset.modalHarnessVariant = this.variant;
    setActiveVariantButton(this.variant);
    setStatus(labelForVariant(this.variant));
    pushLog('Open', `${labelForVariant(this.variant)} variant`);
    this.redraw();
  }

  closeVariant() {
    stageEl.classList.remove('is-active');
    stageEl.setAttribute('aria-hidden', 'true');
    document.documentElement.dataset.modalHarnessVariant = 'closed';
    setStatus('Closed');
    pushLog('Close', `${labelForVariant(this.variant)} closed`);
    this.drawBackgroundOnly();
  }

  getSnapshot() {
    return this.lastSnapshot;
  }

  redraw() {
    this.children.removeAll(true);
    const width = this.scale.width;
    const height = this.scale.height;
    this.drawBackground(width, height);
    this.drawModal(width, height);
  }

  drawBackgroundOnly() {
    this.children.removeAll(true);
    this.drawBackground(this.scale.width, this.scale.height);
  }

  drawBackground(width, height) {
    this.add.rectangle(0, 0, width, height, COLORS.deepForest).setOrigin(0);

    if (this.textures.exists('background')) {
      const bg = this.add.image(width / 2, height / 2, 'background');
      coverImage(bg, width, height);
      bg.setAlpha(0.62);
    }

    const g = this.add.graphics();
    g.fillStyle(0x24492e, 0.75);
    g.fillRoundedRect(12, 82, width - 24, height - 156, 18);
    g.fillStyle(0x77a951, 0.36);
    for (let i = 0; i < 18; i += 1) {
      const x = (i * 83) % Math.max(1, width);
      const y = 116 + ((i * 137) % Math.max(1, height - 240));
      g.fillRoundedRect(x - 26, y - 13, 70, 28, 18);
    }

    drawMockHud(this, width);
    drawMockCombatSprites(this, width, height);
    this.add.rectangle(0, 0, width, height, 0x09100d, 0.58).setOrigin(0);
  }

  drawModal(stageWidth, stageHeight) {
    const variant = VARIANTS[this.variant];
    const metrics = measureModal(stageWidth, stageHeight, variant);
    this.lastSnapshot = { variant: this.variant, stageWidth, stageHeight, ...metrics };

    drawPanel(this, metrics);
    drawOrnaments(this, metrics, variant);
    if (!variant.hideClose) drawCloseButton(this, metrics);
    drawHeader(this, metrics, variant);

    const body = {
      x: metrics.x + metrics.inset,
      y: metrics.y + metrics.headerHeight,
      width: metrics.width - metrics.inset * 2,
      height: Math.max(64, metrics.height - metrics.headerHeight - metrics.footerHeight - 12),
    };

    if (this.variant === 'shell') drawShellBody(this, body);
    if (this.variant === 'confirm') drawConfirmBody(this, body);
    if (this.variant === 'reward') drawRewardBody(this, body);
    if (this.variant === 'list') drawListBody(this, body);
    if (this.variant === 'settings') drawSettingsBody(this, body);
    if (this.variant === 'skillChoice') drawSkillChoiceBody(this, body);
    if (this.variant === 'notice') drawNoticeBody(this, body);

    drawFooter(this, metrics, variant);
  }
}

function bindControls() {
  document.querySelectorAll('[data-modal-id]').forEach(button => {
    button.addEventListener('click', () => {
      harnessScene?.openVariant(button.dataset.modalId || 'shell');
    });
  });

  document.querySelectorAll('[data-preview-size]').forEach(button => {
    button.addEventListener('click', () => {
      setPreviewSize(button.dataset.previewSize || 'portrait');
    });
  });
}

function setPreviewSize(size = 'portrait') {
  phoneEl.dataset.size = size;
  context.previewSize = size;
  setActiveSizeButton(size);
  requestAnimationFrame(() => {
    const width = stageEl.clientWidth || 440;
    const height = stageEl.clientHeight || 782;
    context.game?.scale?.resize?.(width, height);
    context.game?.scale?.refresh?.();
    harnessScene?.redraw();
    pushLog('Size', size);
  });
}

function measureModal(stageWidth, stageHeight, variant) {
  const safeX = clamp(Math.round(stageWidth * 0.04), 14, 24);
  const safeY = clamp(Math.round(stageHeight * 0.035), 16, 28);
  const maxWidth = Math.min(720, stageWidth - safeX * 2);
  const minWidth = Math.min(312, maxWidth);
  const width = Math.round(clamp(stageWidth * variant.widthRatio, minWidth, maxWidth));
  const maxHeight = Math.min(variant.maxHeight, stageHeight - safeY * 2);
  const minHeight = Math.min(variant.minHeight, maxHeight);
  const height = Math.round(clamp(stageHeight * variant.heightRatio, minHeight, maxHeight));
  const x = Math.round((stageWidth - width) / 2);
  const y = Math.round((stageHeight - height) / 2 + (variant.anchor === 'bottom' ? safeY : 0));
  const inset = clamp(Math.round(width * 0.052), 18, 28);
  const headerHeight = thisHeaderHeight(width, height);
  const footerHeight = variant.actions.length ? 76 : 18;
  return { x, y, width, height, inset, headerHeight, footerHeight };
}

function thisHeaderHeight(width, height) {
  if (height < 310) return 76;
  if (width < 400) return 94;
  return 102;
}

function drawPanel(scene, metrics) {
  const g = scene.add.graphics();
  g.fillStyle(COLORS.shadow, 0.38);
  g.fillRoundedRect(metrics.x + 8, metrics.y + 10, metrics.width, metrics.height, 18);

  const useNineSlice = scene.textures.exists('panel') && typeof scene.add.nineslice === 'function';
  if (useNineSlice) {
    try {
      const panel = scene.add.nineslice(
        metrics.x,
        metrics.y,
        'panel',
        null,
        metrics.width,
        metrics.height,
        28,
        28,
        28,
        28,
      );
      panel.setOrigin?.(0, 0);
      return;
    } catch (error) {
      console.warn('[modal-harness] nineslice fallback', error);
    }
  }

  g.fillStyle(COLORS.ink, 1);
  g.fillRoundedRect(metrics.x, metrics.y, metrics.width, metrics.height, 16);
  g.fillStyle(COLORS.parchment, 1);
  g.fillRoundedRect(metrics.x + 5, metrics.y + 5, metrics.width - 10, metrics.height - 10, 12);
  g.lineStyle(3, COLORS.parchmentDark, 0.55);
  g.strokeRoundedRect(metrics.x + 13, metrics.y + 13, metrics.width - 26, metrics.height - 26, 10);
}

function drawOrnaments(scene, metrics, variant) {
  if (scene.textures.exists('crest')) {
    const crest = scene.add.image(metrics.x + metrics.width / 2, metrics.y - 4, 'crest');
    const crestWidth = clamp(metrics.width * 0.34, 104, 178);
    crest.setDisplaySize(crestWidth, crestWidth * 0.62).setDepth(2);
  } else {
    const g = scene.add.graphics();
    g.fillStyle(COLORS.ink, 1);
    g.fillCircle(metrics.x + metrics.width / 2, metrics.y + 2, 30);
    g.fillStyle(COLORS.gold, 1);
    g.fillCircle(metrics.x + metrics.width / 2, metrics.y + 2, 24);
  }

  if (!scene.textures.exists('corner') || variant.widthRatio < 0.73) return;
  const size = clamp(metrics.width * 0.15, 54, 88);
  const corners = [
    { x: metrics.x + 9, y: metrics.y + 10, flipX: false, flipY: false },
    { x: metrics.x + metrics.width - 9, y: metrics.y + 10, flipX: true, flipY: false },
    { x: metrics.x + 9, y: metrics.y + metrics.height - 10, flipX: false, flipY: true },
    { x: metrics.x + metrics.width - 9, y: metrics.y + metrics.height - 10, flipX: true, flipY: true },
  ];
  for (const corner of corners) {
    scene.add.image(corner.x, corner.y, 'corner')
      .setDisplaySize(size, size)
      .setFlip(corner.flipX, corner.flipY)
      .setDepth(2);
  }
}

function drawCloseButton(scene, metrics) {
  const x = metrics.x + metrics.width - 30;
  const y = metrics.y + 30;
  const g = scene.add.graphics();
  g.fillStyle(COLORS.shadow, 0.24);
  g.fillCircle(x + 3, y + 4, 22);
  g.fillStyle(COLORS.ink, 1);
  g.fillCircle(x, y, 22);
  g.fillStyle(COLORS.parchmentLight, 1);
  g.fillCircle(x, y, 17);
  text(scene, x, y - 1, 'X', 20, '#171f18', 'center').setOrigin(0.5).setDepth(5);
  scene.add.circle(x, y, 24, 0xffffff, 0.001)
    .setInteractive({ useHandCursor: true })
    .on('pointerup', () => scene.closeVariant())
    .setDepth(6);
}

function drawHeader(scene, metrics, variant) {
  const centerX = metrics.x + metrics.width / 2;
  const top = metrics.y + 29;
  text(scene, centerX, top, variant.kicker, 11, '#8b6b36', 'center').setOrigin(0.5, 0);
  text(scene, centerX, top + 19, variant.title, metrics.width < 400 ? 25 : 30, '#2b241c', 'center')
    .setOrigin(0.5, 0);
  if (metrics.height > 300) {
    text(scene, centerX, top + 58, variant.subtitle, 13, '#654726', 'center')
      .setOrigin(0.5, 0);
  }

  const g = scene.add.graphics();
  g.lineStyle(2, COLORS.rowDark, 0.42);
  g.lineBetween(metrics.x + metrics.inset, metrics.y + metrics.headerHeight - 12, metrics.x + metrics.width - metrics.inset, metrics.y + metrics.headerHeight - 12);
}

function drawShellBody(scene, body) {
  const g = scene.add.graphics();
  drawInsetBox(g, body.x, body.y + 4, body.width, Math.max(96, body.height * 0.42));
  drawSlotLabel(scene, body.x + body.width / 2, body.y + 38, 'Header / Body / Footer');

  const cardY = body.y + Math.max(116, body.height * 0.48);
  const cardWidth = Math.floor((body.width - 20) / 3);
  ['Confirm', 'Reward', 'List'].forEach((label, index) => {
    const x = body.x + index * (cardWidth + 10);
    drawMiniCard(scene, x, cardY, cardWidth, Math.min(86, body.height - (cardY - body.y)), label, index);
  });
}

function drawConfirmBody(scene, body) {
  const g = scene.add.graphics();
  drawInsetBox(g, body.x, body.y + 4, body.width, body.height - 4);
  g.fillStyle(COLORS.ink, 1);
  g.fillCircle(body.x + body.width / 2, body.y + 46, 28);
  g.fillStyle(COLORS.gold, 1);
  g.fillCircle(body.x + body.width / 2, body.y + 46, 22);
  text(scene, body.x + body.width / 2, body.y + 37, '!', 25, '#171f18', 'center').setOrigin(0.5, 0);
  text(scene, body.x + body.width / 2, body.y + 88, '진행 상태를 적용합니다.', 16, '#2b241c', 'center').setOrigin(0.5, 0);
  text(scene, body.x + body.width / 2, body.y + 114, '이후 같은 ModalHost lifecycle로 닫힙니다.', 12, '#654726', 'center')
    .setOrigin(0.5, 0)
    .setWordWrapWidth(body.width - 34);
}

function drawRewardBody(scene, body) {
  const rewards = [
    { key: 'coin', label: '골드', value: '452' },
    { key: 'soul', label: '영혼불', value: '32' },
    { key: 'wood', label: '목재', value: '178' },
    { key: 'stone', label: '기와석', value: '96' },
  ];
  const columns = body.width < 340 ? 2 : 4;
  const gap = 9;
  const slotWidth = Math.floor((body.width - gap * (columns - 1)) / columns);
  const slotHeight = body.width < 340 ? 88 : 108;
  rewards.forEach((reward, index) => {
    const col = index % columns;
    const row = Math.floor(index / columns);
    const x = body.x + col * (slotWidth + gap);
    const y = body.y + 8 + row * (slotHeight + gap);
    drawRewardSlot(scene, x, y, slotWidth, slotHeight, reward);
  });
}

function drawListBody(scene, body) {
  const rows = [
    ['!', '오늘의 임무', '서바이벌 1회 완료'],
    ['+', '성소 성장', '등불 신전 업그레이드 가능'],
    ['*', '동료 소식', '새 주민 후보 발견'],
    ['$', '보급품', '목재와 기와석 수령 가능'],
  ];
  rows.forEach((row, index) => {
    drawListRow(scene, body.x, body.y + 4 + index * 64, body.width, 56, row, index);
  });
}

function drawSettingsBody(scene, body) {
  const rows = [
    ['S', '사운드', '효과음', true],
    ['M', '음악', '배경음', false],
    ['V', '진동', '전투 피드백', true],
    ['N', '알림', '보상 준비', true],
  ];
  rows.forEach((row, index) => {
    drawToggleRow(scene, body.x, body.y + 4 + index * 58, body.width, 50, row);
  });
}

function drawSkillChoiceBody(scene, body) {
  const gap = body.width < 390 ? 6 : 10;
  const cardWidth = Math.floor((body.width - gap * 2) / 3);
  const cardHeight = Math.min(body.height - 6, body.width < 390 ? 238 : 272);
  const choices = [
    ['NEW', '그림자 표창', '피해 +20%', '투사체'],
    ['NEW', '연막 폭탄', '감속 -30%', '지속'],
    ['Lv+', '바람 걸음', '쿨타임 -10%', '이동'],
  ];
  choices.forEach((choice, index) => {
    drawSkillCard(scene, body.x + index * (cardWidth + gap), body.y + 4, cardWidth, cardHeight, choice, index);
  });
}

function drawNoticeBody(scene, body) {
  const g = scene.add.graphics();
  drawInsetBox(g, body.x, body.y + 8, body.width, body.height - 12);
  g.fillStyle(COLORS.teal, 1);
  g.fillCircle(body.x + body.width / 2, body.y + 48, 24);
  text(scene, body.x + body.width / 2, body.y + 38, '~', 28, '#12312e', 'center').setOrigin(0.5, 0);
  text(scene, body.x + body.width / 2, body.y + 86, '보상 준비 완료', 17, '#2b241c', 'center').setOrigin(0.5, 0);
}

function drawFooter(scene, metrics, variant) {
  if (!variant.actions.length) return;
  const gap = 12;
  const y = metrics.y + metrics.height - 58;
  const available = metrics.width - metrics.inset * 2;
  const buttonWidth = variant.actions.length === 1
    ? Math.min(220, available)
    : Math.floor((available - gap) / 2);
  const startX = metrics.x + metrics.width / 2 - (variant.actions.length === 1 ? buttonWidth / 2 : (buttonWidth * 2 + gap) / 2);
  variant.actions.forEach((action, index) => {
    drawActionButton(scene, startX + index * (buttonWidth + gap), y, buttonWidth, 46, action);
  });
}

function drawActionButton(scene, x, y, width, height, action) {
  const g = scene.add.graphics();
  const fill = action.style === 'primary' ? COLORS.orange : COLORS.moss;
  g.fillStyle(COLORS.shadow, 0.28);
  g.fillRoundedRect(x + 3, y + 4, width, height, 12);
  g.fillStyle(COLORS.ink, 1);
  g.fillRoundedRect(x, y, width, height, 12);
  g.fillStyle(fill, 1);
  g.fillRoundedRect(x + 4, y + 4, width - 8, height - 8, 8);
  text(scene, x + width / 2, y + height / 2 - 10, action.label, 16, '#fff7dd', 'center')
    .setOrigin(0.5, 0);
  scene.add.rectangle(x, y, width, height, 0xffffff, 0.001)
    .setOrigin(0)
    .setInteractive({ useHandCursor: true })
    .on('pointerup', () => {
      pushLog('Action', action.label);
      scene.openVariant(scene.variant);
    });
}

function drawInsetBox(g, x, y, width, height) {
  g.fillStyle(COLORS.rowDark, 0.2);
  g.fillRoundedRect(x, y + 3, width, height, 12);
  g.fillStyle(COLORS.parchmentLight, 0.78);
  g.fillRoundedRect(x, y, width, height, 12);
  g.lineStyle(2, COLORS.rowDark, 0.45);
  g.strokeRoundedRect(x + 2, y + 2, width - 4, height - 4, 10);
}

function drawSlotLabel(scene, x, y, label) {
  text(scene, x, y, label, 15, '#5a3d20', 'center').setOrigin(0.5, 0);
}

function drawMiniCard(scene, x, y, width, height, label, index) {
  const g = scene.add.graphics();
  g.fillStyle(COLORS.ink, 1);
  g.fillRoundedRect(x, y, width, height, 8);
  g.fillStyle(index === 1 ? COLORS.parchmentLight : COLORS.parchment, 1);
  g.fillRoundedRect(x + 4, y + 4, width - 8, height - 8, 6);
  g.fillStyle([COLORS.gold, COLORS.teal, COLORS.moss][index], 1);
  g.fillCircle(x + width / 2, y + 30, 17);
  text(scene, x + width / 2, y + height - 26, label, 11, '#2b241c', 'center').setOrigin(0.5, 0);
}

function drawRewardSlot(scene, x, y, width, height, reward) {
  const g = scene.add.graphics();
  g.fillStyle(COLORS.ink, 1);
  g.fillRoundedRect(x, y, width, height, 10);
  g.fillStyle(COLORS.parchmentLight, 1);
  g.fillRoundedRect(x + 4, y + 4, width - 8, height - 8, 7);

  if (scene.textures.exists(reward.key)) {
    scene.add.image(x + width / 2, y + 32, reward.key).setDisplaySize(34, 34);
  } else {
    g.fillStyle(COLORS.gold, 1);
    g.fillCircle(x + width / 2, y + 32, 17);
  }
  text(scene, x + width / 2, y + height - 48, reward.value, 19, '#2b241c', 'center').setOrigin(0.5, 0);
  text(scene, x + width / 2, y + height - 23, reward.label, 11, '#654726', 'center').setOrigin(0.5, 0);
}

function drawListRow(scene, x, y, width, height, row, index) {
  const [icon, title, body] = row;
  const g = scene.add.graphics();
  g.fillStyle(COLORS.ink, 0.18);
  g.fillRoundedRect(x, y + 3, width, height, 10);
  g.fillStyle(index % 2 ? COLORS.parchment : COLORS.parchmentLight, 0.92);
  g.fillRoundedRect(x, y, width, height, 10);
  g.fillStyle(COLORS.ink, 1);
  g.fillCircle(x + 25, y + height / 2, 17);
  g.fillStyle(index % 2 ? COLORS.teal : COLORS.gold, 1);
  g.fillCircle(x + 25, y + height / 2, 13);
  text(scene, x + 25, y + height / 2 - 8, icon, 14, '#171f18', 'center').setOrigin(0.5, 0);
  text(scene, x + 52, y + 9, title, 15, '#2b241c', 'left');
  text(scene, x + 52, y + 31, body, 12, '#654726', 'left').setWordWrapWidth(width - 96);
  text(scene, x + width - 20, y + 18, '>', 18, '#654726', 'center').setOrigin(0.5, 0);
}

function drawToggleRow(scene, x, y, width, height, row) {
  const [icon, title, body, enabled] = row;
  const g = scene.add.graphics();
  g.fillStyle(COLORS.parchmentLight, 0.92);
  g.fillRoundedRect(x, y, width, height, 10);
  g.fillStyle(COLORS.ink, 1);
  g.fillCircle(x + 24, y + height / 2, 15);
  text(scene, x + 24, y + height / 2 - 8, icon, 13, '#fff7dd', 'center').setOrigin(0.5, 0);
  text(scene, x + 50, y + 8, title, 14, '#2b241c', 'left');
  text(scene, x + 50, y + 28, body, 11, '#654726', 'left');

  const tx = x + width - 62;
  const ty = y + 12;
  g.fillStyle(enabled ? COLORS.moss : COLORS.muted, 1);
  g.fillRoundedRect(tx, ty, 52, 26, 13);
  g.fillStyle(COLORS.parchmentLight, 1);
  g.fillCircle(tx + (enabled ? 38 : 14), ty + 13, 10);
}

function drawSkillCard(scene, x, y, width, height, choice, index) {
  const [badge, title, stat, category] = choice;
  drawPanel(scene, { x, y, width, height, inset: 8 });
  const g = scene.add.graphics();
  if (index === 0) {
    g.lineStyle(4, COLORS.gold, 0.92);
    g.strokeRoundedRect(x + 2, y + 2, width - 4, height - 4, 14);
  }
  g.fillStyle(COLORS.gold, 1);
  g.fillRoundedRect(x + 10, y + 12, Math.min(46, width - 20), 22, 7);
  text(scene, x + 15, y + 16, badge, 10, '#171f18', 'left');
  g.fillStyle(COLORS.ink, 1);
  g.fillCircle(x + width / 2, y + 70, 34);
  g.fillStyle([COLORS.orange, COLORS.muted, COLORS.teal][index], 1);
  g.fillCircle(x + width / 2, y + 70, 27);
  text(scene, x + width / 2, y + 58, ['/', '~', '>'][index], 30, '#fff7dd', 'center').setOrigin(0.5, 0);
  text(scene, x + width / 2, y + 112, title, width < 118 ? 12 : 14, '#2b241c', 'center')
    .setOrigin(0.5, 0)
    .setWordWrapWidth(width - 16);

  for (let i = 0; i < 5; i += 1) {
    g.fillStyle(i < 3 - Math.min(index, 1) ? COLORS.gold : COLORS.rowDark, 1);
    g.fillRect(x + width / 2 - 30 + i * 14, y + 155, 8, 8);
  }

  g.fillStyle(COLORS.rowDark, 0.26);
  g.fillRoundedRect(x + 10, y + height - 76, width - 20, 34, 7);
  text(scene, x + width / 2, y + height - 70, stat, 11, '#2b241c', 'center').setOrigin(0.5, 0);
  g.fillStyle(COLORS.forest, 1);
  g.fillRoundedRect(x + width / 2 - 34, y + height - 32, 68, 22, 6);
  text(scene, x + width / 2, y + height - 28, category, 11, '#f8ead1', 'center').setOrigin(0.5, 0);
}

function drawMockHud(scene, width) {
  const g = scene.add.graphics();
  g.fillStyle(COLORS.ink, 1);
  g.fillRoundedRect(14, 14, 76, 52, 12);
  g.fillRoundedRect(width / 2 - 64, 10, 128, 64, 16);
  g.fillRoundedRect(width - 112, 14, 98, 92, 13);
  text(scene, 52, 28, '≡', 28, '#f8ead1', 'center').setOrigin(0.5, 0);
  text(scene, width / 2, 23, '00:58', 29, '#f8ead1', 'center').setOrigin(0.5, 0);
  text(scene, width - 64, 26, '452', 17, '#f8ead1', 'center').setOrigin(0.5, 0);
  text(scene, width - 64, 59, '1,278', 17, '#f8ead1', 'center').setOrigin(0.5, 0);
  g.fillStyle(COLORS.teal, 1);
  g.fillRect(24, 118, width - 48, 16);
}

function drawMockCombatSprites(scene, width, height) {
  const positions = [
    [0.22, 0.24, 'enemyA'],
    [0.78, 0.26, 'enemyB'],
    [0.17, 0.61, 'enemyB'],
    [0.84, 0.66, 'enemyA'],
    [0.38, 0.48, 'coin'],
    [0.62, 0.44, 'soul'],
  ];
  for (const [rx, ry, key] of positions) {
    if (!scene.textures.exists(key)) continue;
    scene.add.image(width * rx, height * ry, key).setDisplaySize(44, 44).setAlpha(0.9);
  }
  if (scene.textures.exists('guardian')) {
    scene.add.image(width / 2, height * 0.74, 'guardian').setDisplaySize(72, 72).setAlpha(0.92);
  }
}

function coverImage(image, width, height) {
  const source = image.texture.getSourceImage();
  const scale = Math.max(width / source.width, height / source.height);
  image.setDisplaySize(source.width * scale, source.height * scale);
}

function text(scene, x, y, value, size, color, align) {
  return scene.add.text(x, y, value, {
    fontFamily: 'system-ui, -apple-system, BlinkMacSystemFont, "Apple SD Gothic Neo", "Malgun Gothic", sans-serif',
    fontSize: `${size}px`,
    fontStyle: '700',
    color,
    align,
    letterSpacing: 0,
  });
}

function clamp(value, min, max) {
  return Math.max(min, Math.min(max, value));
}

function setStatus(textValue, isError = false) {
  if (!statusEl) return;
  statusEl.textContent = textValue;
  statusEl.classList.toggle('is-error', isError);
}

function pushLog(title, body) {
  if (!logEl) return;
  const row = document.createElement('div');
  row.className = 'log-row';
  const strong = document.createElement('strong');
  strong.textContent = title;
  const span = document.createElement('span');
  span.textContent = body || '';
  row.append(strong, span);
  logEl.prepend(row);
  while (logEl.children.length > 6) logEl.lastElementChild?.remove();
}

function setActiveVariantButton(variant) {
  document.querySelectorAll('[data-modal-id]').forEach(button => {
    button.classList.toggle('active', button.dataset.modalId === variant);
  });
}

function setActiveSizeButton(size) {
  document.querySelectorAll('[data-preview-size]').forEach(button => {
    button.classList.toggle('active', button.dataset.previewSize === size);
  });
}

function labelForVariant(variant) {
  const labels = {
    shell: 'Shell',
    confirm: 'Confirm',
    reward: 'Reward',
    list: 'List',
    settings: 'Settings',
    skillChoice: 'Skill Choice',
    notice: 'Notice',
  };
  return labels[variant] || 'Shell';
}

boot();
