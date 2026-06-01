import { ResourceStore } from './resource-store.js';
import { IdlezBoard } from './board-kernel.js';
import { attachModalSystem } from './modal-system.js';

const DEFAULT_GAME_ID = 'mushroomer';
const START_MAP_ID = 500101;
const GOLD_ITEM_ID = 5;
const EXP_ITEM_ID = 6;
const PLAYER_LEVEL_ITEM_ID = 1;
const LEVEL_POINT_ITEM_ID = 200107;
const EQUIPMENT_SUMMON_PRODUCT_ID = 200503;
const SLOT_ACHIEVEMENT_IDS = [600113, 600115, 600117];

const params = new URLSearchParams(globalThis.location.search || '');
const gameId = params.get('game') || DEFAULT_GAME_ID;
const initialModalId = params.get('modal') || 'skills';
const statusEl = document.getElementById('previewStatus');
const logEl = document.getElementById('previewLog');
const phoneEl = document.getElementById('previewPhone');

boot().catch(error => {
  console.error(error);
  setStatus(error.message || 'Error', true);
  pushLog({
    type: 'warning',
    title: 'Harness error',
    body: error.message || String(error),
  });
});

async function boot() {
  setStatus('Loading');

  const store = new ResourceStore({ basePath: '../build' });
  await store.loadGame(gameId);

  const board = new IdlezBoard(store);
  const messages = createMessageSink();
  seedPreviewBoard(board, store);

  const modals = await attachModalSystem({
    board,
    store,
    messages,
    hostId: 'modalStage',
  });

  bindViewportControls(modals);
  bindModalState(modals);

  const context = {
    gameId,
    store,
    board,
    messages,
    modals,
    openModal: id => openModal(modals, id),
    setPreviewSize: size => setPreviewSize(size, modals),
  };

  globalThis.__idlezPhaserUiHarness = context;
  document.documentElement.dataset.uiHarnessReady = 'true';
  setStatus('Ready');

  await nextFrame();
  openModal(modals, initialModalId);
}

function seedPreviewBoard(board, store) {
  const startMap = store.getMap(START_MAP_ID) || [...store.maps.values()].find(map => map?.tags?.includes('Main')) || store.getFirstMap();
  if (startMap) board.start(startMap.id);

  board.addItem(GOLD_ITEM_ID, 150000, 'ui_preview');
  board.addItem(EXP_ITEM_ID, 2400, 'ui_preview');
  board.itemLevels.set(PLAYER_LEVEL_ITEM_ID, 18);
  board.addItem(LEVEL_POINT_ITEM_ID, 48, 'ui_preview');

  for (const id of SLOT_ACHIEVEMENT_IDS) {
    if (store.getAchievement(id)) board.completedAchievements.add(id);
  }

  board.recordProductBuy(EQUIPMENT_SUMMON_PRODUCT_ID, 8);
  seedSkillItems(board, store);
  seedInventorySamples(board, store, 'Equipment', 9);
  seedInventorySamples(board, store, 'Weapon', 5);
  seedMapProgress(board, store);
  board.getSkillTreeState();
}

function seedSkillItems(board, store) {
  const skills = [...store.items.values()]
    .filter(item => item?.category === 'Skill' && item?.skillDataId)
    .sort((a, b) => (
      asNumber(a.popupArgs?.AutoUsePriority, 999) - asNumber(b.popupArgs?.AutoUsePriority, 999)
      || asNumber(a.order, 9999) - asNumber(b.order, 9999)
      || Number(a.id) - Number(b.id)
    ));

  skills.forEach((item, index) => {
    if (index < 6) {
      board.addItem(item.id, 1, 'ui_preview_skill');
      board.itemLevels.set(item.id, Math.min(store.itemMaxLevel(item), index < 2 ? 4 : 2));
    }

    for (const group of item.levelUpMaterialItemGroups || []) {
      for (const material of group.materialItems || []) {
        const itemDataId = Number(material.id ?? material.itemDataId);
        const count = Math.max(1, asNumber(material.count, 1));
        if (itemDataId) board.addItem(itemDataId, count * 8, 'ui_preview_skill_material');
      }
    }
  });

  board.getSkillTreeState().slots
    .filter(slot => slot.unlocked)
    .forEach((slot, index) => {
      const item = skills[index];
      if (item) board.equipSkill(slot.index, item.id);
    });
}

function seedInventorySamples(board, store, category, count) {
  [...store.items.values()]
    .filter(item => item?.category === category)
    .slice(0, count)
    .forEach((item, index) => {
      board.addItem(item.id, index + 1, `ui_preview_${category.toLowerCase()}`);
      board.itemLevels.set(item.id, Math.min(store.itemMaxLevel(item), index + 2));
    });
}

function seedMapProgress(board, store) {
  [...store.maps.values()]
    .filter(map => map?.tags?.includes('Main') || map?.tags?.includes('WeekdayDungeon'))
    .slice(0, 8)
    .forEach((map, index) => {
      board.mapWinCounts.set(Number(map.id), index + 1);
      board.mapWaveWinCounts.set(Number(map.id), index + 2);
    });
}

function createMessageSink() {
  return {
    push(message = {}) {
      pushLog(message);
      return message;
    },
    handleServerSignal(signal = {}) {
      pushLog({
        type: signal.type || 'info',
        title: signal.title || 'Signal',
        body: signal.body || signal.message || '',
      });
    },
  };
}

function pushLog(message = {}) {
  if (!logEl) return;
  const row = document.createElement('div');
  row.className = 'log-row';
  const title = document.createElement('strong');
  title.textContent = message.title || labelForType(message.type);
  const body = document.createElement('span');
  body.textContent = message.body || message.message || '';
  row.append(title, body);
  logEl.prepend(row);

  while (logEl.children.length > 6) {
    logEl.lastElementChild?.remove();
  }
}

function bindViewportControls(modals) {
  document.querySelectorAll('[data-preview-size]').forEach(button => {
    button.addEventListener('click', () => {
      setPreviewSize(button.dataset.previewSize || 'portrait', modals);
      document.querySelectorAll('[data-preview-size]').forEach(node => {
        node.classList.toggle('active', node === button);
      });
    });
  });
}

function bindModalState(modals) {
  document.querySelectorAll('[data-modal-id]').forEach(button => {
    button.addEventListener('click', () => {
      setStatus(button.textContent || 'Open');
    });
  });

  const originalClose = modals.closeCurrent.bind(modals);
  modals.closeCurrent = options => {
    originalClose(options);
    setStatus('Ready');
  };
}

function openModal(modals, id) {
  const button = document.querySelector(`[data-modal-id="${cssEscape(id)}"]`);
  if (button) {
    button.click();
    return;
  }
  modals.open(id);
}

function setPreviewSize(size, modals) {
  if (!phoneEl) return;
  phoneEl.dataset.size = size;
  requestAnimationFrame(() => {
    modals.closeCurrent({ immediate: true });
    const active = document.querySelector('[data-modal-id].active') || document.querySelector('[data-modal-id]');
    const id = active?.dataset?.modalId || initialModalId;
    openModal(modals, id);
  });
}

function setStatus(text, isError = false) {
  if (!statusEl) return;
  statusEl.textContent = text;
  statusEl.classList.toggle('is-error', Boolean(isError));
}

function labelForType(type) {
  return ({
    loot: 'Loot',
    success: 'Success',
    warning: 'Warning',
    clear: 'Clear',
  })[type] || 'Message';
}

function asNumber(value, fallback = 0) {
  const n = Number(value);
  return Number.isFinite(n) ? n : fallback;
}

function cssEscape(value) {
  return String(value).replace(/\\/g, '\\\\').replace(/"/g, '\\"');
}

function nextFrame() {
  return new Promise(resolve => requestAnimationFrame(resolve));
}
