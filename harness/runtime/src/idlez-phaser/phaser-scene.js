import { TEAM, clamp, formatNumber } from './constants.js';

const PhaserScene = globalThis.Phaser?.Scene ?? class {};

export class IdlezPhaserScene extends PhaserScene {
  constructor() {
    super('IdlezPhaserScene');
    this.unitViews = new Map();
  }

  preload() {
    this.load.image('map-sky', 'assets/maps/meadow_day/sky.png');
    this.load.image('map-far', 'assets/maps/meadow_day/far.png');
    this.load.image('map-mid', 'assets/maps/meadow_day/mid.png');
    this.load.image('map-near', 'assets/maps/meadow_day/near.png');
  }

  create() {
    const context = globalThis.__MUSHROOMER_PHASER_CONTEXT__ || globalThis.__IDLEZ_PHASER_CONTEXT__;
    if (!context?.board || !context?.store) {
      throw new Error('Phaser context was not initialized before scene create');
    }
    this.board = context.board;
    this.store = context.store;

    this.#drawBackground();
    this.#drawGardenDetails();
    this.#drawBattleLane();
    this.#bindBoardEvents();

    globalThis.dispatchEvent(new CustomEvent('mushroomer-phaser-ready'));
  }

  update(_time, delta) {
    if (!this.board) return;
    this.board.step(delta);
    this.#syncUnits();
  }

  #bindBoardEvents() {
    this.board.on('boardStarted', () => this.#clearUnitViews());
    this.board.on('unitSpawned', unit => this.#createUnitView(unit));
    this.board.on('unitDamaged', event => this.#showDamage(event));
    this.board.on('unitDied', ({ unit }) => {
      if (unit.team === TEAM.PLAYER) this.#markPlayerDefeated(unit);
      else this.#removeUnitView(unit);
    });
    this.board.on('unitRevived', unit => this.#markPlayerRevived(unit));
    this.board.on('skillFx', ({ skill }) => this.#showSkillFx(skill));
    this.board.on('itemGained', event => this.#showDropBurst(event));
    this.board.on('waveStarted', () => this.cameras.main.shake(120, 0.003));
    this.board.on('gameEnded', () => this.#showBanner('CLEAR'));
  }

  #drawBackground() {
    const width = this.scale.width;
    const height = this.scale.height;

    this.add.image(width / 2, height / 2, 'map-sky')
      .setDisplaySize(width, height)
      .setDepth(-40);

    this.add.image(width / 2, height * 0.38, 'map-far')
      .setDisplaySize(width, Math.round(width * 221 / 2048))
      .setDepth(-30);

    this.add.image(width / 2, height * 0.52, 'map-mid')
      .setDisplaySize(width, Math.round(width * 498 / 2048))
      .setDepth(-20);

    this.add.image(width / 2, height + 86, 'map-near')
      .setOrigin(0.5, 1)
      .setDisplaySize(width, Math.round(width * 1850 / 2048))
      .setDepth(-10);
  }

  #drawGardenDetails() {
    const g = this.add.graphics().setDepth(-6);

    this.#drawBush(g, 96, 520, 1.2, 0x80bd50);
    this.#drawBush(g, 790, 532, 1.05, 0x77b94c);
    this.#drawBush(g, 565, 536, 0.9, 0x6aa946);
    this.#drawMushroom(g, 306, 516, 0.8, 0xd85f45);
    this.#drawMushroom(g, 704, 504, 1.0, 0xf09b3a);
    this.#drawMushroom(g, 818, 480, 0.78, 0xc45050);
    this.#drawMushroom(g, 346, 530, 0.65, 0x7fbf56);

    g.lineStyle(5, 0x8c6936, 0.42);
    g.beginPath();
    g.moveTo(42, 516);
    g.lineTo(270, 500);
    g.moveTo(642, 512);
    g.lineTo(900, 494);
    g.strokePath();

    for (const [x, y, color] of [
      [40, 560, 0xf8e7a1], [74, 548, 0xffb66c], [326, 560, 0xf8e7a1],
      [474, 548, 0xffd36a], [618, 558, 0xf5a0b8], [860, 546, 0xffd36a],
    ]) {
      this.#drawFlower(g, x, y, color);
    }
  }

  #drawBush(g, x, y, scale, color) {
    g.fillStyle(0x3f7c38, 0.36);
    g.fillEllipse(x, y + 14 * scale, 138 * scale, 44 * scale);
    g.fillStyle(color, 0.9);
    for (let i = 0; i < 6; i += 1) {
      const cx = x - 58 * scale + i * 23 * scale;
      g.fillCircle(cx, y - Math.sin(i) * 6 * scale, 24 * scale);
    }
    g.fillRoundedRect(x - 66 * scale, y - 4 * scale, 132 * scale, 34 * scale, 14 * scale);
  }

  #drawMushroom(g, x, y, scale, capColor) {
    g.fillStyle(0x7f5b35, 0.35);
    g.fillEllipse(x, y + 47 * scale, 82 * scale, 18 * scale);
    g.fillStyle(0xf6dca4, 0.94);
    g.fillRoundedRect(x - 18 * scale, y + 3 * scale, 36 * scale, 47 * scale, 14 * scale);
    g.fillStyle(0x6f3b22, 0.5);
    g.fillRect(x - 16 * scale, y + 39 * scale, 32 * scale, 7 * scale);
    g.fillStyle(capColor, 0.95);
    g.fillEllipse(x, y, 96 * scale, 58 * scale);
    g.fillRect(x - 42 * scale, y - 3 * scale, 84 * scale, 16 * scale);
    g.fillStyle(0xffedc7, 0.92);
    g.fillCircle(x - 20 * scale, y - 10 * scale, 8 * scale);
    g.fillCircle(x + 14 * scale, y - 16 * scale, 6 * scale);
    g.fillCircle(x + 28 * scale, y + 4 * scale, 5 * scale);
    g.lineStyle(3 * scale, 0x4c2a18, 0.45);
    g.strokeEllipse(x, y, 96 * scale, 58 * scale);
  }

  #drawFlower(g, x, y, color) {
    g.lineStyle(2, 0x4f8a3b, 0.72);
    g.beginPath();
    g.moveTo(x, y + 12);
    g.lineTo(x, y - 4);
    g.strokePath();
    g.fillStyle(color, 0.95);
    for (let i = 0; i < 5; i += 1) {
      const a = (Math.PI * 2 * i) / 5;
      g.fillCircle(x + Math.cos(a) * 5, y - 6 + Math.sin(a) * 5, 4);
    }
    g.fillStyle(0xf7c849, 1);
    g.fillCircle(x, y - 6, 3);
  }

  #drawBattleLane() {
    const width = this.scale.width;
    const laneY = 580;
    const laneH = 205;
    const g = this.add.graphics().setDepth(4);

    g.fillStyle(0x5f351d, 0.45);
    g.fillRoundedRect(-34, laneY + 18, width + 68, laneH + 42, 22);

    g.fillStyle(0x7f4a27, 1);
    g.fillRoundedRect(-28, laneY, width + 56, laneH, 18);
    g.fillStyle(0xb87939, 1);
    g.fillRoundedRect(-22, laneY + 8, width + 44, laneH - 22, 14);
    g.fillStyle(0x8e552c, 1);
    g.fillRect(-22, laneY + laneH - 22, width + 44, 18);

    for (let x = -10; x < width + 80; x += 92) {
      const shade = x % 184 === 0 ? 0x9f6333 : 0xc48743;
      g.lineStyle(3, 0x573019, 0.68);
      g.beginPath();
      g.moveTo(x, laneY + 10);
      g.lineTo(x + 16, laneY + laneH - 18);
      g.strokePath();
      g.fillStyle(shade, 0.22);
      g.fillRoundedRect(x + 8, laneY + 14, 70, laneH - 36, 9);
      g.fillStyle(0x4b2a17, 0.35);
      g.fillCircle(x + 24, laneY + 36, 4);
      g.fillCircle(x + 62, laneY + laneH - 42, 4);
    }

    g.lineStyle(4, 0x3f2414, 0.75);
    g.beginPath();
    g.moveTo(-24, laneY + 12);
    g.lineTo(width + 24, laneY + 8);
    g.moveTo(-24, laneY + laneH - 20);
    g.lineTo(width + 24, laneY + laneH - 18);
    g.strokePath();

    for (const x of [48, 176, 744, 874]) {
      g.fillStyle(0x7a4525, 1);
      g.fillRoundedRect(x - 17, laneY - 12, 34, 52, 12);
      g.fillStyle(0xb98345, 1);
      g.fillEllipse(x, laneY - 12, 38, 16);
      g.lineStyle(2, 0x4b2a17, 0.75);
      g.strokeEllipse(x, laneY - 12, 38, 16);
    }

    const grass = this.add.graphics().setDepth(5);
    for (let x = 0; x < width; x += 34) {
      grass.fillStyle(x % 68 === 0 ? 0x63b741 : 0x7bd150, 0.95);
      grass.fillTriangle(x, laneY + 2, x + 9, laneY - 12, x + 18, laneY + 2);
    }
  }

  #createUnitView(unit) {
    if (this.unitViews.has(unit.id)) return;

    const hpBar = this.add.graphics().setDepth(1000);
    const label = this.add.text(unit.x, unit.y + 12, formatNumber(unit.hp), {
      fontFamily: 'system-ui, -apple-system, sans-serif',
      fontSize: unit.type === 'Boss' ? '16px' : '13px',
      fontStyle: 'bold',
      color: '#fff7dd',
      stroke: '#101814',
      strokeThickness: 4,
    }).setOrigin(0.5, 1).setDepth(1001);

    this.unitViews.set(unit.id, { hpBar, label });
    this.#updateUnitView(unit);
  }

  #syncUnits() {
    for (const unit of this.board.units.values()) {
      if (!unit.alive) continue;
      if (!this.unitViews.has(unit.id)) this.#createUnitView(unit);
      this.#updateUnitView(unit);
    }
  }

  #updateUnitView(unit) {
    const view = this.unitViews.get(unit.id);
    if (!view) return;

    const hp = this.#hpBarMetrics(unit);
    view.label
      .setText(formatNumber(unit.hp))
      .setPosition(unit.x, hp.y - 8)
      .setDepth(unit.y + 2);
    view.hpBar.setDepth(unit.y + 1);
    this.#drawHpBar(unit, view);
  }

  #drawHpBar(unit, view) {
    const { width, height, x, y, pct, color } = this.#hpBarMetrics(unit);

    view.hpBar.clear();
    view.hpBar.fillStyle(0x07100c, 0.78);
    view.hpBar.fillRoundedRect(x - 2, y - 2, width + 4, height + 4, 4);
    view.hpBar.fillStyle(color, 1);
    view.hpBar.fillRoundedRect(x, y, width * pct, height, 3);
    view.hpBar.lineStyle(1, 0xffffff, 0.25);
    view.hpBar.strokeRoundedRect(x - 2, y - 2, width + 4, height + 4, 4);
  }

  #hpBarMetrics(unit) {
    const width = unit.type === 'Boss' ? 94 : unit.team === TEAM.PLAYER ? 72 : 58;
    const height = unit.type === 'Boss' ? 8 : 6;
    const x = unit.x - width / 2;
    const y = unit.y - (unit.type === 'Boss' ? 150 : unit.team === TEAM.PLAYER ? 92 : 82);
    const pct = clamp(unit.hp / unit.maxHp, 0, 1);
    const color = unit.team === TEAM.PLAYER ? 0x36d399 : pct < 0.3 ? 0xf97316 : 0xef4444;
    return { width, height, x, y, pct, color };
  }

  #removeUnitView(unit) {
    const view = this.unitViews.get(unit.id);
    if (!view) return;
    this.unitViews.delete(unit.id);

    this.tweens.add({
      targets: [view.label],
      alpha: 0,
      y: '-=24',
      duration: 420,
      ease: 'Cubic.easeOut',
      onComplete: () => {
        view.label.destroy();
        view.hpBar.destroy();
      },
    });
  }

  #clearUnitViews() {
    for (const view of this.unitViews.values()) {
      view.label.destroy();
      view.hpBar.destroy();
    }
    this.unitViews.clear();
  }

  #showDamage({ unit, damage }) {
    const view = this.unitViews.get(unit.id);
    if (!view) return;

    this.#updateUnitView(unit);
    this.#floatText(unit.x, unit.y - 92, `-${formatNumber(damage)}`, unit.team === TEAM.PLAYER ? '#ffb4a8' : '#ff7a1a');
  }

  #markPlayerDefeated(unit) {
    const view = this.unitViews.get(unit.id);
    if (!view) return;
    this.#updateUnitView(unit);
    view.label.setAlpha(0.42);
    view.hpBar.setAlpha(0.42);
    this.#floatText(unit.x, unit.y - 122, 'DOWN', '#ffb4a8');
  }

  #markPlayerRevived(unit) {
    if (!this.unitViews.has(unit.id)) this.#createUnitView(unit);
    const view = this.unitViews.get(unit.id);
    view.label.setAlpha(1);
    view.hpBar.setAlpha(1);
    this.#floatText(unit.x, unit.y - 122, 'REVIVE', '#82f6ac');
    this.#updateUnitView(unit);
  }

  #showSkillFx(skill) {
    const target = skill.targets.find(unit => unit.alive) || skill.targets[0];
    if (!target) return;

    const slash = this.add.graphics().setDepth(1200);
    slash.lineStyle(7, 0xd7f3ff, 0.95);
    slash.beginPath();
    slash.arc(target.x, target.y - 62, 42, -0.8, 0.9);
    slash.strokePath();
    slash.lineStyle(4, 0xffb12c, 0.95);
    slash.beginPath();
    slash.moveTo(target.x - 78, target.y - 24);
    slash.lineTo(target.x + 58, target.y - 96);
    slash.moveTo(target.x - 55, target.y - 74);
    slash.lineTo(target.x + 72, target.y - 20);
    slash.strokePath();

    this.tweens.add({
      targets: slash,
      alpha: 0,
      scaleX: 1.35,
      scaleY: 1.35,
      duration: 180,
      ease: 'Cubic.easeOut',
      onComplete: () => slash.destroy(),
    });
  }

  #showBanner(text) {
    const banner = this.add.text(this.scale.width / 2, 96, text, {
      fontFamily: 'system-ui, -apple-system, sans-serif',
      fontSize: '44px',
      color: '#f7d66d',
      stroke: '#101814',
      strokeThickness: 6,
    }).setOrigin(0.5).setDepth(2000);

    this.tweens.add({
      targets: banner,
      y: 78,
      alpha: 0,
      delay: 900,
      duration: 520,
      onComplete: () => banner.destroy(),
    });
  }

  #showDropBurst({ item, count }) {
    if (!item || count == null) return;

    const amount = Math.max(1, Math.min(5, Math.ceil(Number(count) || 1)));
    const icon = item.id === 6 ? '◆' : '●';
    const color = item.id === 6 ? '#d9b4ff' : '#ffd45b';
    for (let i = 0; i < amount; i += 1) {
      const x = 420 + Math.random() * 220;
      const y = 500 + Math.random() * 120;
      const label = this.add.text(x, y, icon, {
        fontFamily: 'system-ui, -apple-system, sans-serif',
        fontSize: '26px',
        fontStyle: 'bold',
        color,
        stroke: '#4a230b',
        strokeThickness: 5,
      }).setOrigin(0.5).setDepth(1900);

      this.tweens.add({
        targets: label,
        x: x + (Math.random() - 0.5) * 100,
        y: y - 72 - Math.random() * 38,
        alpha: 0,
        scale: 0.72,
        duration: 900,
        ease: 'Cubic.easeOut',
        onComplete: () => label.destroy(),
      });
    }
  }

  #floatText(x, y, text, color) {
    const label = this.add.text(x, y, text, {
      fontFamily: 'system-ui, -apple-system, sans-serif',
      fontSize: '30px',
      fontStyle: 'bold',
      color,
      stroke: '#101814',
      strokeThickness: 6,
    }).setOrigin(0.5).setDepth(2000);

    this.tweens.add({
      targets: label,
      y: y - 54,
      alpha: 0,
      scale: 1.18,
      duration: 760,
      ease: 'Cubic.easeOut',
      onComplete: () => label.destroy(),
    });
  }
}
