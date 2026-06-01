// scene.js — Phaser Scene (Phaser + Spine 공존 모드)
// Phaser 역할: HP바 표시, 게임 루프 (자동 전투 + 트리거 엔진 + 스킬)
// 캐릭터 렌더링은 SpineRenderer가 별도 WebGL 캔버스에서 처리.
// PlayerStats에서 ATK/SPD/CRIT/HP/DEF 가져와 전투 계산.

import { fmt } from './player-stats.js';

export class GameScene extends Phaser.Scene {
  constructor() {
    super('GameScene');
  }

  init(data) {
    this.board = data.board;
    this.engine = data.engine;
    this.spineRenderer = data.spineRenderer;
    this.playerStats = data.playerStats;
    this.hpBars = new Map();
    this.enemyAtkTimers = new Map(); // unit → 남은 공격 쿨다운 (초)
  }

  create() {
    // Board 이벤트 → HP바
    this.board.on('unitSpawned', u => {
      this._createHpBar(u);
      // 적 공격 타이머 초기화 (첫 공격까지 1~2초 랜덤 딜레이)
      this.enemyAtkTimers.set(u, 1.0 + Math.random());
    });
    this.board.on('unitDied', u => {
      this._removeHpBar(u);
      this.enemyAtkTimers.delete(u);
    });

    // 전투 타이머
    this._attackTimer = 0;     // 공격 쿨다운 누적
    this._lastPlayerAtk = 0;   // 공격 애니메이션 시각 제한

    // 방치 골드 타이머
    this._idleGoldTimer = 0;

    // 플레이어 HP바 (Phaser graphics)
    this._playerHpGraphics = this.add.graphics().setDepth(10);
    this._playerHpLabel = this.add.text(0, 0, '', {
      fontSize: '10px', color: '#ffffff',
      stroke: '#000000', strokeThickness: 2,
    }).setOrigin(0.5).setDepth(11);

    // 부활 오버레이 텍스트 (초기 숨김)
    this._defeatText = this.add.text(
      this.sys.game.config.width / 2,
      this.sys.game.config.height / 2 - 20,
      '', {
        fontSize: '18px', color: '#ff4444',
        stroke: '#000000', strokeThickness: 3,
        align: 'center',
      }
    ).setOrigin(0.5).setDepth(20).setAlpha(0);

    this._reviveTimer = 0;
    this._isReviving = false;

    // 맵 부트스트랩
    this.board.boardState = 1;
    this.engine.bootstrapMap(this.board.currentMap);
  }

  update(time, delta) {
    if (this.board.gameEnded) return;

    const now = performance.now();
    const dt = delta / 1000;
    const stats = this.playerStats;

    // 트리거 엔진 tick
    this.engine.tick(now);

    // ── 부활 처리 ──
    if (this._isReviving) {
      this._reviveTimer -= dt;
      const sec = Math.ceil(this._reviveTimer);
      this._defeatText.setText(`패배! ${sec}초 후 부활...`);
      if (this._reviveTimer <= 0) {
        this._isReviving = false;
        this._defeatText.setAlpha(0);
        stats.revive();
      }
      // 부활 중에도 Spine 렌더는 계속
      this.spineRenderer.render(dt);
      this._syncPlayerHpBar();
      return;
    }

    // ── 방치 골드 (30초마다) ──
    this._idleGoldTimer += dt;
    if (this._idleGoldTimer >= 30) {
      const g = stats.gps * 5;
      stats.addGold(g);
      this._idleGoldTimer = 0;
    }

    // ── Player 자동 공격 (combat 상태인 적만 공격) ──
    const combatEnemies = this.board.units.filter(u => u.alive && u.team === 1 && u.state === 'combat');
    if (combatEnemies.length > 0) {
      // 기본 공격 (SPD 기반 쿨다운)
      this._attackTimer += dt;
      const atkInterval = 1.0 / stats.spd;
      if (this._attackTimer >= atkInterval) {
        this._attackTimer -= atkInterval;
        const target = combatEnemies[0];
        this._dealDamage(target, stats.atk, now);
      }

      // 스킬 사용
      for (const sk of stats.skills) {
        sk.t -= dt;
        if (sk.t <= 0) {
          sk.t += sk.cd;
          if (sk.tg === 'all') {
            for (const e of combatEnemies) {
              this._dealDamage(e, Math.round(stats.atk * sk.mult), now);
            }
            this._showSkillFloat(sk.n);
          } else {
            this._dealDamage(combatEnemies[0], Math.round(stats.atk * sk.mult), now);
            this._showSkillFloat(sk.n);
          }
        }
      }

      // ── 적 공격 (combat 상태인 적들이 플레이어를 공격) ──
      for (const enemy of combatEnemies) {
        let timer = this.enemyAtkTimers.get(enemy);
        if (timer === undefined) { timer = 1.5; this.enemyAtkTimers.set(enemy, timer); }

        timer -= dt;
        if (timer <= 0) {
          // 적 공격 실행
          const atkInterval = enemy.type === 'Boss' ? 2.5 : 1.8; // 보스는 느리지만 세게
          this.enemyAtkTimers.set(enemy, atkInterval + (Math.random() - 0.5) * 0.4);

          // 적 공격 애니메이션
          this.spineRenderer.triggerEnemyAttack(enemy);

          // 플레이어에게 데미지
          const rawDmg = enemy.attack || 10;
          const actualDmg = stats.takeDamage(rawDmg);
          this._showPlayerDmgFloat(actualDmg);

          // 플레이어 사망 처리
          if (stats.dead) {
            this._onPlayerDeath();
            break;
          }
        } else {
          this.enemyAtkTimers.set(enemy, timer);
        }
      }
    } else {
      this._attackTimer = 0;
    }

    // Spine 렌더
    this.spineRenderer.render(dt);

    // HP바 동기화
    this._syncHpBars();
    this._syncPlayerHpBar();
  }

  // ── 플레이어 사망 ──

  _onPlayerDeath() {
    this._isReviving = true;
    this._reviveTimer = 5; // 5초 후 부활
    this._defeatText.setAlpha(1);
    this._defeatText.setText('패배! 5초 후 부활...');
  }

  // ── 데미지 처리 ──

  _dealDamage(unit, baseDmg, now) {
    const stats = this.playerStats;
    const isCrit = Math.random() * 100 < stats.crit;
    const dmg = Math.max(1, Math.round(baseDmg * (isCrit ? 1.6 : 1)));
    unit.hp = Math.max(0, unit.hp - dmg);

    // 공격 애니메이션 (200ms 간격 제한)
    if (now - this._lastPlayerAtk > 200) {
      this.spineRenderer.triggerPlayerAttack();
      this._lastPlayerAtk = now;
    }

    // 데미지 플로트
    this._showDmgFloat(unit, dmg, isCrit);

    if (unit.hp <= 0) {
      this.board.removeUnit(unit);
    }
  }

  // ── 플레이어 HP바 ──

  _syncPlayerHpBar() {
    const g = this._playerHpGraphics;
    if (!g) return;
    g.clear();

    const stats = this.playerStats;
    const pos = this.spineRenderer.getPlayerPos();
    if (!pos) return;

    const canvasH = this.spineRenderer.canvas.height;
    const barW = 60;
    const barH = 7;
    const phaserX = pos.x;
    const phaserY = canvasH - pos.y - 80; // 캐릭터 머리 위
    const barX = phaserX - barW / 2;
    const barY = phaserY;

    // 배경
    g.fillStyle(0x000000, 0.7);
    g.fillRoundedRect(barX - 1, barY - 1, barW + 2, barH + 2, 3);

    // HP 바
    const pct = Math.max(0, stats.hp / stats.hpMax);
    const color = pct > 0.5 ? 0x44cc44 : pct > 0.25 ? 0xff9900 : 0xff3333;
    g.fillStyle(color, 1);
    g.fillRoundedRect(barX, barY, barW * pct, barH, 3);

    // 외곽선
    g.lineStyle(1, 0xffffff, 0.3);
    g.strokeRoundedRect(barX - 1, barY - 1, barW + 2, barH + 2, 3);

    // HP 텍스트
    this._playerHpLabel.setPosition(phaserX, barY - 10);
    this._playerHpLabel.setText(`${fmt(stats.hp)}/${fmt(stats.hpMax)}`);
  }

  // ── 적 HP바 ──

  _createHpBar(unit) {
    const g = this.add.graphics().setDepth(10);
    const isBoss = unit.type === 'Boss';
    const label = this.add.text(0, 0, unit.name + (isBoss ? ' ★' : ''), {
      fontSize: isBoss ? '11px' : '10px',
      color: isBoss ? '#ff6699' : '#ffffff',
      stroke: '#000000',
      strokeThickness: 2,
    }).setOrigin(0.5).setDepth(11);
    this.hpBars.set(unit, { graphics: g, label });
  }

  _syncHpBars() {
    for (const [unit, bar] of this.hpBars) {
      if (!unit.alive) continue;
      const pos = this.spineRenderer.getEnemyPos(unit);
      if (!pos) continue;

      const isBoss = unit.type === 'Boss';
      const barW = isBoss ? 80 : 50;
      const barH = 6;
      const canvasH = this.spineRenderer.canvas.height;
      const phaserX = pos.x;
      const phaserY = canvasH - pos.y - (isBoss ? 120 : 70);
      const barX = phaserX - barW / 2;
      const barY = phaserY;

      bar.graphics.clear();
      bar.graphics.fillStyle(0x000000, 0.6);
      bar.graphics.fillRoundedRect(barX - 1, barY - 1, barW + 2, barH + 2, 2);
      const pct = Math.max(0, unit.hp / unit.maxHp);
      const color = pct > 0.5 ? 0x44cc44 : pct > 0.25 ? 0xff9900 : 0xff3333;
      bar.graphics.fillStyle(color, 1);
      bar.graphics.fillRoundedRect(barX, barY, barW * pct, barH, 2);
      bar.label.setPosition(phaserX, barY - 10);
    }
  }

  _removeHpBar(unit) {
    const bar = this.hpBars.get(unit);
    if (!bar) return;
    bar.label.destroy();
    bar.graphics.destroy();
    this.hpBars.delete(unit);
  }

  // ── 플로트 텍스트 ──

  _showDmgFloat(unit, dmg, isCrit) {
    const pos = this.spineRenderer.getEnemyPos(unit);
    if (!pos) return;
    const floatsLayer = document.getElementById('floatsLayer');
    if (!floatsLayer) return;

    const el = document.createElement('div');
    el.className = 'float-text';
    el.textContent = (isCrit ? '★' : '') + `-${fmt(dmg)}`;
    el.style.color = isCrit ? '#fbbf24' : '#ff4444';
    if (isCrit) el.style.fontSize = '18px';

    const canvasH = this.spineRenderer.canvas.height;
    const canvasW = this.spineRenderer.canvas.width;
    const sx = floatsLayer.offsetWidth / canvasW;
    const sy = floatsLayer.offsetHeight / canvasH;
    el.style.left = `${pos.x * sx + (Math.random() - 0.5) * 40}px`;
    el.style.top = `${(canvasH - pos.y) * sy - 60 - Math.random() * 20}px`;
    floatsLayer.appendChild(el);
    setTimeout(() => el.remove(), 1000);
  }

  _showPlayerDmgFloat(dmg) {
    const pos = this.spineRenderer.getPlayerPos();
    if (!pos) return;
    const floatsLayer = document.getElementById('floatsLayer');
    if (!floatsLayer) return;

    const el = document.createElement('div');
    el.className = 'float-text';
    el.textContent = `-${fmt(dmg)}`;
    el.style.color = '#ff6666';
    el.style.fontSize = '15px';

    const canvasH = this.spineRenderer.canvas.height;
    const canvasW = this.spineRenderer.canvas.width;
    const sx = floatsLayer.offsetWidth / canvasW;
    const sy = floatsLayer.offsetHeight / canvasH;
    el.style.left = `${pos.x * sx + (Math.random() - 0.5) * 30}px`;
    el.style.top = `${(canvasH - pos.y) * sy - 80 - Math.random() * 15}px`;
    floatsLayer.appendChild(el);
    setTimeout(() => el.remove(), 1000);
  }

  _showSkillFloat(skillName) {
    const floatsLayer = document.getElementById('floatsLayer');
    if (!floatsLayer) return;
    const el = document.createElement('div');
    el.className = 'float-text';
    el.textContent = skillName + '!';
    el.style.color = '#60a5fa';
    el.style.fontSize = '16px';
    el.style.left = '20%';
    el.style.top = '40%';
    floatsLayer.appendChild(el);
    setTimeout(() => el.remove(), 1000);
  }
}
