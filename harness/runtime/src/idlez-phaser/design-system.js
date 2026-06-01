export const UI_ASSETS = {
  rewardButton: 'ui-button-reward-gold',
  rewardButtonPressed: 'ui-button-reward-gold-pressed',
  greenButton: 'ui-button-green-upgrade',
  greenButtonPressed: 'ui-button-green-upgrade-pressed',
  woodButton: 'ui-button-tab-wood',
  sideWoodButton: 'ui-button-side-wood',
};

export const UI_ASSET_PATHS = {
  [UI_ASSETS.rewardButton]: 'assets/ui/buttons/btn_reward_gold.png',
  [UI_ASSETS.rewardButtonPressed]: 'assets/ui/buttons/btn_reward_gold_pressed.png',
  [UI_ASSETS.greenButton]: 'assets/ui/buttons/btn_upgrade_green.png',
  [UI_ASSETS.greenButtonPressed]: 'assets/ui/buttons/btn_upgrade_green_pressed.png',
  [UI_ASSETS.woodButton]: 'assets/ui/buttons/btn_tab_wood_inactive.png',
  [UI_ASSETS.sideWoodButton]: 'assets/ui/buttons/btn_side_wood_vertical.png',
};

export const PHASER_DESIGN = {
  colors: {
    outlineBrown: 0x3a2416,
    ink: 0x2b1206,
    line: 0x211005,
    woodDark: 0x321708,
    woodMid: 0x7a431d,
    woodLight: 0xa8652a,
    parchment: 0xffeac0,
    parchmentShadow: 0xd7a563,
    cream: 0xfff1c8,
    gold: 0xf6b331,
    goldHighlight: 0xffd96a,
    green: 0x72b943,
    greenDark: 0x2f7e20,
    red: 0xef4e45,
    purple: 0xa967ff,
    shadow: 0x120601,
  },
  css: {
    ink: '#2b1206',
    cream: '#fff1c8',
    text: '#fff7dd',
    gold: '#ffd96a',
    greenText: '#f0ffe0',
    muted: '#6b3a18',
  },
  font: {
    family: 'system-ui, -apple-system, BlinkMacSystemFont, "Apple SD Gothic Neo", "Malgun Gothic", sans-serif',
  },
  zOrder: {
    modalPopups: 4100,
  },
  modal: {
    radius: 28,
    framePadding: 22,
    minWidth: 320,
    maxWidth: 720,
    widthRatio: 0.9,
    minSideMargin: 18,
    maxSideMargin: 28,
    contentInsetMin: 22,
    contentInsetMax: 34,
    titleHeight: 58,
    footerHeight: 82,
  },
  modalText: {
    title: '26px',
    kicker: '12px',
    rowTitle: '15px',
    rowBody: '12px',
    button: '16px',
    close: '18px',
    value: '24px',
  },
};

export function modalTextStyle(role, overrides = {}) {
  const styles = {
    title: {
      fontFamily: PHASER_DESIGN.font.family,
      fontSize: PHASER_DESIGN.modalText.title,
      fontStyle: 'bold',
      color: PHASER_DESIGN.css.text,
      stroke: '#2b1206',
      strokeThickness: 5,
      align: 'center',
    },
    kicker: {
      fontFamily: PHASER_DESIGN.font.family,
      fontSize: PHASER_DESIGN.modalText.kicker,
      fontStyle: 'bold',
      color: '#ffe7aa',
      stroke: '#2b1206',
      strokeThickness: 3,
      align: 'center',
    },
    rowTitle: {
      fontFamily: PHASER_DESIGN.font.family,
      fontSize: PHASER_DESIGN.modalText.rowTitle,
      fontStyle: 'bold',
      color: '#3a1b08',
      align: 'left',
    },
    rowBody: {
      fontFamily: PHASER_DESIGN.font.family,
      fontSize: PHASER_DESIGN.modalText.rowBody,
      fontStyle: 'bold',
      color: '#6b3a18',
      align: 'left',
    },
    button: {
      fontFamily: PHASER_DESIGN.font.family,
      fontSize: PHASER_DESIGN.modalText.button,
      fontStyle: 'bold',
      color: '#ffffff',
      stroke: '#2b1206',
      strokeThickness: 4,
      align: 'center',
    },
    close: {
      fontFamily: PHASER_DESIGN.font.family,
      fontSize: PHASER_DESIGN.modalText.close,
      fontStyle: 'bold',
      color: '#fff7dd',
      stroke: '#2b1206',
      strokeThickness: 4,
      align: 'center',
    },
    value: {
      fontFamily: PHASER_DESIGN.font.family,
      fontSize: PHASER_DESIGN.modalText.value,
      fontStyle: 'bold',
      color: '#fff7dd',
      stroke: '#2b1206',
      strokeThickness: 5,
      align: 'center',
    },
  };

  return { ...(styles[role] || styles.rowBody), ...overrides };
}

export function textureForButtonStyle(style = 'wood', pressed = false) {
  if (style === 'primary') return pressed ? UI_ASSETS.rewardButtonPressed : UI_ASSETS.rewardButton;
  if (style === 'green') return pressed ? UI_ASSETS.greenButtonPressed : UI_ASSETS.greenButton;
  return UI_ASSETS.sideWoodButton;
}
