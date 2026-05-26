// main.js — Phaser + Spine 공존 엔트리 (스탯/강화 시스템 포함)
// Phaser: HP바·UI 프레임워크
// Spine WebGL: 별도 캔버스에서 캐릭터 스켈레톤 렌더링
// Board + TriggerEngine: 웨이브/전투 로직
// PlayerStats: 골드, 스탯, 강화

import { DataLoader } from './data-loader.js';
import { Board } from './board.js';
import { TriggerEngine } from './trigger-engine.js';
import { SpineRenderer } from './spine-renderer.js';
import { GameScene } from './scene.js';
import { PlayerStats, UPGRADE_DEFS, SKILL_DEFS, fmt } from './player-stats.js';

const MAP_ID = 500101; // meadow_1

(async () => {
  const statusEl = document.getElementById('status');
  const logEl = document.getElementById('log');
  const stateEl = document.getElementById('state');
  const overlay = document.getElementById('loadingOverlay');

  const log = (msg, level = 'info') => {
    const div = document.createElement('div');
    div.className = `log-entry log-${level}`;
    div.textContent = msg;
    logEl.insertBefore(div, logEl.firstChild);
    while (logEl.children.length > 30) logEl.removeChild(logEl.lastChild);
  };

  try {
    // 1) 데이터 로드
    statusEl.textContent = '데이터 로딩 중...';
    overlay.textContent = '콘텐츠 데이터 로딩...';
    const loader = new DataLoader('../');
    await loader.loadAll('idlez');
    statusEl.textContent = '데이터 로드 완료';

    const map = loader.getMap(MAP_ID);
    if (!map) throw new Error(`Map ${MAP_ID} not found`);
    document.getElementById('mapTitle').textContent = map.name;

    // 2) Spine 에셋 로드
    overlay.textContent = 'Spine 에셋 로딩...';
    const spineRenderer = new SpineRenderer('spineCanvas');
    await spineRenderer.loadAssets();

    // 3) Board + Engine + PlayerStats 생성
    const board = new Board(null, loader);
    board.currentMap = map;
    const engine = new TriggerEngine(board, loader);
    const playerStats = new PlayerStats();

    // SpineRenderer에 Board 참조 연결 (접근→전투 전환용)
    spineRenderer.setBoard(board);

    // 4) Board 이벤트 → HTML UI + Spine 연결
    const updateState = () => {
      const alive = board.units.filter(u => u.alive && u.team === 1);
      stateEl.innerHTML = `
        <div><strong>boardState:</strong> ${board.boardState}</div>
        <div><strong>적 생존:</strong> ${alive.length}</div>
        <div><strong>골드:</strong> ${fmt(playerStats.gold)}</div>
        <div><strong>HP:</strong> ${fmt(playerStats.hp)}/${fmt(playerStats.hpMax)}</div>
      `;
      // HUD
      document.getElementById('hudGold').textContent = fmt(playerStats.gold);
      document.getElementById('hudWave').textContent = alive.length;
      document.getElementById('hudAtk').textContent = fmt(playerStats.atk);
      document.getElementById('hudHp').textContent = fmt(playerStats.hp);
      document.getElementById('hudHpMax').textContent = fmt(playerStats.hpMax);
    };

    board.on('unitSpawned', u => {
      const tag = u.type === 'Boss' ? 'boss' : 'spawn';
      log(`${u.name} 등장 (${u.rank})`, tag);
      spineRenderer.addEnemy(u);
      updateState();
    });
    board.on('unitDied', u => {
      const reward = playerStats.killReward(u);
      log(`${u.name} 처치 (+${fmt(reward)}G)`, 'kill');
      spineRenderer.removeEnemy(u);
      updateState();
    });
    board.on('waveStarted', () => {
      log('웨이브 시작', 'info');
      spineRenderer.resetSpawnSlots();
    });
    board.on('waveQueued', name => log(`다음 웨이브 큐잉: ${name}`, 'info'));
    board.on('gameEnded', result => log(`★ 맵 클리어! (${result})`, 'clear'));
    board.on('boardStateChanged', v => { log(`boardState → ${v}`, 'state'); updateState(); });

    // 5) 강화 UI 빌드
    buildUpgradeUI(playerStats, log, updateState);
    updateStatsDisplay(playerStats);
    playerStats.on('upgraded', () => { updateStatsDisplay(playerStats); updateUpgradeUI(playerStats); updateState(); });
    playerStats.on('skillBought', () => { updateStatsDisplay(playerStats); updateUpgradeUI(playerStats); updateState(); });
    playerStats.on('goldChanged', () => { updateUpgradeUI(playerStats); updateState(); });
    playerStats.on('hpChanged', () => { updateStatsDisplay(playerStats); updateState(); });
    playerStats.on('playerDied', () => { log('플레이어 사망! 5초 후 부활...', 'error'); });
    playerStats.on('playerRevived', () => { log('부활 완료!', 'info'); updateState(); });

    // 6) Phaser 게임 생성
    overlay.textContent = 'Phaser 초기화...';
    const phaserConfig = {
      type: Phaser.CANVAS,
      parent: 'phaserContainer',
      width: 720,
      height: 360,
      transparent: true,
      banner: false,
      audio: { noAudio: true },
      fps: { forceSetTimeOut: true, target: 30 },
      disableVisibilityChange: true,
      scene: GameScene,
    };

    const game = new Phaser.Game(phaserConfig);
    game.scene.start('GameScene', { board, engine, spineRenderer, playerStats });

    overlay.style.display = 'none';
    document.getElementById('hudStage').textContent = map.name;
    log(`[boot] Map "${map.name}" 로드 완료`, 'boot');
    log(`[boot] 트리거 ${map.triggers?.length || 0}개 바인딩`, 'boot');
    log(`[boot] Phaser + Spine + 스탯 시스템 시작`, 'boot');

    // 디버그
    window.__board = board;
    window.__engine = engine;
    window.__spine = spineRenderer;
    window.__stats = playerStats;

  } catch (e) {
    statusEl.textContent = '에러: ' + e.message;
    if (overlay) overlay.textContent = '에러: ' + e.message;
    console.error(e);
    log(`[ERROR] ${e.message}`, 'error');
  }
})();

// ── 강화 UI 빌드 ──

function buildUpgradeUI(stats, log, updateState) {
  const grid = document.getElementById('upgradeGrid');
  grid.innerHTML = '';

  for (const u of UPGRADE_DEFS) {
    const btn = document.createElement('button');
    btn.className = 'upgrade-btn';
    btn.id = `ubtn-${u.key}`;
    btn.innerHTML = `
      <div class="ubtn-icon">${u.icon}</div>
      <div class="ubtn-label">${u.label}</div>
      <div class="ubtn-cost" id="ucost-${u.key}">-</div>
    `;
    btn.addEventListener('click', () => {
      if (stats.upgrade(u.key)) {
        log(`${u.label} 강화 → Lv${stats[u.field]}`, 'gold');
      }
    });
    grid.appendChild(btn);
  }

  // 스킬 버튼
  const skillGrid = document.getElementById('skillGrid');
  skillGrid.innerHTML = '';
  for (const s of SKILL_DEFS) {
    const btn = document.createElement('button');
    btn.className = 'skill-btn';
    btn.id = `sbtn-${s.key}`;
    btn.innerHTML = `${s.icon} ${s.label}<br><span style="font-size:8px;color:var(--text3)">${s.desc} · ${fmt(s.cost)}G</span>`;
    btn.addEventListener('click', () => {
      if (stats.buySkill(s.key)) {
        log(`${s.label} 스킬 해금!`, 'gold');
      }
    });
    skillGrid.appendChild(btn);
  }

  updateUpgradeUI(stats);
}

function updateUpgradeUI(stats) {
  for (const u of UPGRADE_DEFS) {
    const btn = document.getElementById(`ubtn-${u.key}`);
    const costEl = document.getElementById(`ucost-${u.key}`);
    if (!btn || !costEl) continue;
    const c = stats.cost(u.base, u.rate, stats[u.field]);
    costEl.textContent = `${fmt(c)}G`;
    btn.disabled = stats.gold < c;
  }
  for (const s of SKILL_DEFS) {
    const btn = document.getElementById(`sbtn-${s.key}`);
    if (!btn) continue;
    if (stats.hasSkill(s.key)) {
      btn.classList.add('owned');
      btn.disabled = true;
      btn.innerHTML = `${s.icon} ${s.label} ✓`;
    } else {
      btn.disabled = stats.gold < s.cost;
    }
  }
}

function updateStatsDisplay(stats) {
  const set = (id, val) => { const el = document.getElementById(id); if (el) el.textContent = val; };
  set('atkValue', fmt(stats.atk));
  set('atkLevel', `Lv${stats.atkLv}`);
  set('hpValue', fmt(stats.hpMax));
  set('hpLevel', `Lv${stats.hpLv}`);
  set('defValue', fmt(stats.def));
  set('defLevel', `Lv${stats.defLv}`);
  set('spdValue', stats.spd.toFixed(1));
  set('spdLevel', `Lv${stats.spdLv}`);
  set('critValue', `${stats.crit}%`);
  set('critLevel', `Lv${stats.critLv}`);
  set('gpsValue', fmt(stats.gps));
  set('hudAtk', fmt(stats.atk));
}
