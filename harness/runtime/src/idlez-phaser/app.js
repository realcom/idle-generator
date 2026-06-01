import { ResourceStore } from './resource-store.js';
import { IdlezBoard } from './board-kernel.js';
import { attachHud } from './hud.js?v=stat-icons1';
import { attachMessageSystem } from './message-system.js?v=resource-react3';
import { IdlezWsClient, shouldAutoConnectNetwork } from './network/idlez-ws-client.js?v=mushroomer2';
import { IdlezSessionStore } from './network/session-store.js?v=mushroomer2';
import { IdlezPhaserScene } from './phaser-scene.js?v=runtime-assets1';
import { IdlezSpineLayer } from './spine-layer.js';
import { attachModalSystem } from './modal-system.js?v=mushroomer';

const GAME_ID = 'mushroomer';
const START_MAP_ID = 500101;
const statusEl = document.getElementById('bootStatus');

boot().catch(error => {
  console.error(error);
  statusEl.textContent = error.message;
  statusEl.classList.add('is-error');
});

async function boot() {
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
  network.on('signal', signal => messages.handleServerSignal(signal));
  network.on('state', ({ state }) => {
    document.documentElement.dataset.networkState = state;
    if (state === 'Connecting') statusEl.textContent = 'Connecting server';
    if (state === 'Loginned') statusEl.textContent = 'Running';
  });

  if (!globalThis.Phaser) {
    throw new Error('Phaser failed to load');
  }

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
    backgroundColor: '#142319',
    banner: false,
    audio: { noAudio: true },
    scene: IdlezPhaserScene,
    scale: {
      mode: Phaser.Scale.FIT,
      autoCenter: Phaser.Scale.CENTER_BOTH,
    },
  });

  await phaserReady;

  const modals = await attachModalSystem({ board, store, messages });

  board.start(START_MAP_ID);
  spineLayer.start();
  statusEl.textContent = 'Running';

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
