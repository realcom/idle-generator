import { ResourceStore } from './resource-store.js?v=main-stage1';
import { TEAM, asNumber, formatNumber } from './constants.js';
import { IdlezBoard } from './board-kernel.js?v=achievement-ui1';
import { attachHud } from './hud.js?v=weekday4';
import { attachMessageSystem } from './message-system.js?v=resource-react3';
import { IdlezWsClient, shouldAutoConnectNetwork } from './network/idlez-ws-client.js?v=settings1';
import { IdlezSessionStore } from './network/session-store.js?v=mushroomer2';
import { IdlezPhaserScene } from './phaser-scene.js?v=map-sky1';
import { IdlezSpineLayer } from './spine-layer.js?v=weekday4';
import { attachModalSystem } from './modal-system.js?v=modaltext1';
import { applyLanguagePreference, resolveSettings } from './settings-store.js?v=settings1';

const GAME_ID = 'mushroomer';
const START_MAP_ID = 500101;
const SKILL_FX_DEMO_IDS = [
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
];
const statusEl = document.getElementById('bootStatus');

boot().catch(error => {
  console.error(error);
  statusEl.textContent = error.message;
  statusEl.classList.add('is-error');
});

async function boot() {
  applyLanguagePreference(resolveSettings({ defaultBgmEnabled: false }).language);
  statusEl.textContent = 'Loading resources';

  const store = new ResourceStore({ basePath: '../build' });
  await store.loadGame(GAME_ID);

  const board = new IdlezBoard(store);
  const session = new IdlezSessionStore(board, store);
  const network = new IdlezWsClient({ session, store });
  attachHud(board, store, {
    getAvatar: () => session.avatar,
    onUpgradeItem: itemDataId => {
      if (network.state === 'Loginned') {
        return network.levelUpItemDataId(itemDataId);
      }
      return board.levelUpItem(itemDataId);
    },
  });
  const messages = attachMessageSystem(board, store);
  installWeekdayDungeonClearFlow({ board, store, messages });
  network.on('signal', signal => messages.handleServerSignal(signal));
  network.on('state', ({ state }) => {
    document.documentElement.dataset.networkState = state;
    if (state === 'Connecting') statusEl.textContent = 'Connecting server';
    if (state === 'Loginned') statusEl.textContent = 'Running';
  });

  if (!globalThis.Phaser) {
    throw new Error('Phaser failed to load');
  }

  const modals = await attachModalSystem({ board, store, messages, session, network });

  if (!globalThis.spine) {
    throw new Error('Spine WebGL runtime failed to load');
  }

  statusEl.textContent = 'Loading Spine assets';
  const spineLayer = new IdlezSpineLayer('spineCanvas', board);
  const phaserContext = { store, board, spineLayer, gameId: GAME_ID };
  globalThis.__MUSHROOMER_PHASER_CONTEXT__ = phaserContext;
  globalThis.__IDLEZ_PHASER_CONTEXT__ = phaserContext;
  await spineLayer.loadAssets();

  const phaserReady = new Promise(resolve => {
    globalThis.addEventListener('mushroomer-phaser-ready', resolve, { once: true });
  });

  const game = new Phaser.Game({
    type: Phaser.AUTO,
    parent: 'gameStage',
    width: 920,
    height: 840,
    backgroundColor: 'rgba(0,0,0,0)',
    transparent: true,
    banner: false,
    scene: IdlezPhaserScene,
    scale: {
      mode: Phaser.Scale.FIT,
      autoCenter: Phaser.Scale.CENTER_BOTH,
    },
  });

  await phaserReady;
  attachDomSfx();

  board.start(START_MAP_ID);
  spineLayer.start();
  statusEl.textContent = 'Running';
  maybeStartSkillFxDemo({ board, store });

  if (shouldAutoConnectNetwork()) {
    network.connectAndLoginGuest().catch(error => {
      console.warn('[IdlezWsClient] Server connection failed', error);
      statusEl.textContent = 'Server offline';
      document.documentElement.dataset.networkError = error.message;
      messages.handleServerSignal({
        type: 'warning',
        title: '서버 연결 실패',
        body: error.message,
        duration: 6500,
      });
      setTimeout(() => {
        if (statusEl.textContent === 'Server offline') statusEl.textContent = 'Running';
      }, 6500);
    });
  }

  const context = {
    gameId: GAME_ID,
    store,
    board,
    game,
    spineLayer,
    messages,
    modals,
    session,
    network,
    connectServer: options => network.connectAndLoginGuest(options),
    openModal: (id, payload) => modals.open(id, payload),
    serverSignal: signal => messages.handleServerSignal(signal),
  };
  globalThis.__mushroomerPhaser = context;
  globalThis.__idlezPhaser = context;
}

function attachDomSfx(root = document) {
  if (root.documentElement?.dataset.idlezSfxBound === 'true') return;
  root.documentElement.dataset.idlezSfxBound = 'true';

  root.addEventListener('click', event => {
    const target = event.target?.closest?.([
      'button',
      '[role="button"]',
      '[data-modal-id]',
      '[data-upgrade-item-id]',
      '[data-equipment-choice-action]',
      '[data-skill-slot-index]',
    ].join(','));
    if (!target || target.disabled || target.getAttribute('aria-disabled') === 'true') return;
    playGlobalSfx('uiClick');
  }, { capture: true });
}

function playGlobalSfx(name, options = {}) {
  const audio = globalThis.__MUSHROOMER_PHASER_AUDIO__ || globalThis.__IDLEZ_PHASER_AUDIO__;
  return audio?.play?.(name, options) ?? false;
}

function installWeekdayDungeonClearFlow({ board, store, messages }) {
  const timers = new Map();

  board.on('boardStarted', ({ map }) => {
    for (const [mapId, timer] of timers) {
      if (Number(map?.id) === Number(mapId)) continue;
      globalThis.clearTimeout(timer);
      timers.delete(mapId);
    }
  });

  board.on('gameEnded', event => {
    const map = event.map || board.map;
    if (!map?.tags?.includes('WeekdayDungeon')) return;
    if (event.winningTeam !== TEAM.PLAYER) return;

    const delayMs = Math.max(0, asNumber(map.popupArgs?.ClientClearReturnDelayMs, 3000));
    const homeMapId = map.popupArgs?.ClientHomeMapDataId || START_MAP_ID;
    const rewards = summarizeRewards(event.rewards || [], store);
    messages?.push({
      type: 'clear',
      icon: 'OK',
      title: `${map.name || '요일 던전'} 클리어`,
      body: `${rewards || '보상 정산 완료'} · ${Math.ceil(delayMs / 1000)}초 후 메인맵`,
      duration: Math.max(2200, delayMs),
    });

    if (timers.has(map.id)) globalThis.clearTimeout(timers.get(map.id));
    const timer = globalThis.setTimeout(() => {
      timers.delete(map.id);
      if (board.map?.id !== map.id || !board.gameEnded) return;
      board.start(homeMapId, { preserveProgress: true });
    }, delayMs);
    timers.set(map.id, timer);
  });
}

function summarizeRewards(rewards, store) {
  return rewards
    .slice(0, 4)
    .map(reward => {
      const item = reward.item || store?.getItem?.(reward.itemDataId);
      return `${item?.name || `Item ${reward.itemDataId}`} +${formatNumber(reward.count)}`;
    })
    .join(' · ');
}

function maybeStartSkillFxDemo({ board, store }) {
  const params = new URLSearchParams(globalThis.location?.search || '');
  if (!params.has('skillFxDemo')) return;

  const root = document.documentElement;
  const player = board.playerUnit;
  const enemyDef = [...store.units.values()].find(unit => unit.type !== 'Player');
  const previousAuto = board.autoSkillsEnabled;
  const state = { fired: 0, errors: [], skillIds: [] };
  root.dataset.skillFxDemo = 'ready';
  root.dataset.skillFxDemoFired = '0';
  root.dataset.skillFxDemoErrors = '0';

  if (!player || !enemyDef) {
    root.dataset.skillFxDemo = !player ? 'missing-player' : 'missing-enemy';
    return;
  }

  board.setAutoSkillsEnabled(false);
  player.alive = true;
  player.state = 'combat';
  player.hp = player.maxHp;

  const ensureTarget = () => {
    let target = board.enemyUnits.find(unit => unit.alive && unit.state === 'combat')
      || board.enemyUnits.find(unit => unit.alive);
    if (!target) {
      target = board.spawnUnit(enemyDef.id, {
        team: 'Enemy',
        level: Math.max(1, board.boardState || 1),
        x: 640,
        y: 560,
        targetX: 640,
        state: 'combat',
      });
    }
    if (!target) return null;
    target.alive = true;
    target.state = 'combat';
    target.maxHp = Math.max(target.maxHp || 1, 9999999);
    target.hp = target.maxHp;
    return target;
  };

  let index = 0;
  const fireNext = () => {
    if (index >= SKILL_FX_DEMO_IDS.length) {
      root.dataset.skillFxDemo = 'done';
      root.dataset.skillFxDemoFired = String(state.fired);
      root.dataset.skillFxDemoErrors = String(state.errors.length);
      if (previousAuto) board.setAutoSkillsEnabled(true);
      return;
    }

    const skillDataId = SKILL_FX_DEMO_IDS[index];
    index += 1;
    try {
      const target = ensureTarget();
      const skillInstanceId = target ? board.startSkillToTarget(player, skillDataId, target) : 0;
      if (skillInstanceId) {
        state.fired += 1;
        state.skillIds.push(skillDataId);
      } else {
        state.errors.push(`${skillDataId}:not-fired`);
      }
    } catch (error) {
      state.errors.push(`${skillDataId}:${error.message}`);
    }

    root.dataset.skillFxDemo = `${index}/${SKILL_FX_DEMO_IDS.length}`;
    root.dataset.skillFxDemoFired = String(state.fired);
    root.dataset.skillFxDemoErrors = String(state.errors.length);
    globalThis.setTimeout(fireNext, 520);
  };

  globalThis.__MUSHROOMER_SKILL_FX_DEMO__ = state;
  globalThis.setTimeout(fireNext, 2600);
}
