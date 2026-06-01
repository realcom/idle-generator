import { formatNumber } from './constants.js';

const DEFAULT_DURATION_MS = 2800;
const MAX_VISIBLE_MESSAGES = 2;
const MESSAGE_EVENTS = ['mushroomer:server-signal', 'mushroomer:message'];
const CURRENCY_ITEM_IDS = new Set([5, 6]);

export function attachMessageSystem(board, store, options = {}) {
  const layer = resolveLayer(options.layerId || 'messageLayer');
  const messages = new MessageSystem({ layer, store });

  const handleSignal = event => messages.handleServerSignal(event.detail);
  for (const eventName of MESSAGE_EVENTS) {
    globalThis.addEventListener(eventName, handleSignal);
  }

  messages.destroy = () => {
    for (const eventName of MESSAGE_EVENTS) {
      globalThis.removeEventListener(eventName, handleSignal);
    }
    messages.clear();
  };

  globalThis.__MUSHROOMER_PHASER_MESSAGES__ = messages;
  return messages;
}

export class MessageSystem {
  constructor({ layer, store }) {
    this.layer = layer;
    this.store = store;
    this.pending = [];
    this.visible = [];
  }

  push(rawMessage) {
    const message = normalizeMessage(rawMessage, this.store);
    if (!message) return null;

    if (message.type === 'warning') this.pending.unshift(message);
    else this.pending.push(message);
    this.#pump();
    return message;
  }

  handleServerSignal(signal) {
    return this.push(normalizeServerSignal(signal, this.store));
  }

  clear() {
    for (const entry of this.visible) {
      clearTimeout(entry.timer);
      entry.node.remove();
    }
    this.visible = [];
    this.pending = [];
  }

  #pump() {
    while (this.visible.length < MAX_VISIBLE_MESSAGES && this.pending.length > 0) {
      this.#show(this.pending.shift());
    }
  }

  #show(message) {
    const node = createToast(message);
    this.layer.prepend(node);

    requestAnimationFrame(() => node.classList.add('is-visible'));

    const timer = setTimeout(() => this.#dismiss(node), message.duration);
    this.visible.push({ node, timer });
  }

  #dismiss(node) {
    const entry = this.visible.find(item => item.node === node);
    if (entry) clearTimeout(entry.timer);

    this.visible = this.visible.filter(item => item.node !== node);
    node.classList.add('is-leaving');
    node.classList.remove('is-visible');

    setTimeout(() => {
      node.remove();
      this.#pump();
    }, 220);
  }
}

function resolveLayer(layerId) {
  let layer = document.getElementById(layerId);
  if (layer) return layer;

  layer = document.createElement('div');
  layer.id = layerId;
  layer.className = 'message-layer';
  layer.setAttribute('aria-live', 'polite');
  document.body.append(layer);
  return layer;
}

function normalizeServerSignal(signal, store) {
  if (!signal) return null;
  if (typeof signal === 'string') return { type: 'info', title: '알림', body: signal };

  const type = signal.type || signal.kind || signal.event || 'info';
  const hasItemId = signal.itemDataId != null || signal.itemId != null || signal.id != null;
  if (type === 'itemGained' || type === 'reward:item' || (type === 'loot' && hasItemId)) {
    const itemDataId = signal.itemDataId ?? signal.itemId ?? signal.id;
    if (CURRENCY_ITEM_IDS.has(Number(itemDataId))) return null;

    const item = signal.item || store?.getItem?.(itemDataId);
    return toItemGainMessage({
      itemDataId,
      item,
      count: signal.count ?? signal.amount ?? 1,
      reason: signal.reason || 'server',
    });
  }

  return signal;
}

function normalizeMessage(rawMessage, store) {
  if (!rawMessage) return null;
  if (typeof rawMessage === 'string') {
    return {
      type: 'info',
      icon: 'i',
      title: '알림',
      body: rawMessage,
      duration: DEFAULT_DURATION_MS,
    };
  }

  if (rawMessage.itemDataId != null || rawMessage.itemId != null) {
    const itemDataId = rawMessage.itemDataId ?? rawMessage.itemId;
    if (CURRENCY_ITEM_IDS.has(Number(itemDataId))) return null;

    return toItemGainMessage({
      itemDataId,
      item: rawMessage.item || store?.getItem?.(itemDataId),
      count: rawMessage.count ?? rawMessage.amount ?? 1,
      reason: rawMessage.reason || 'message',
    });
  }

  return {
    type: rawMessage.type || rawMessage.kind || 'info',
    icon: rawMessage.icon || iconForType(rawMessage.type || rawMessage.kind),
    title: rawMessage.title || rawMessage.heading || '알림',
    body: rawMessage.body || rawMessage.message || rawMessage.text || '',
    meta: rawMessage.meta || '',
    duration: Number(rawMessage.duration) || DEFAULT_DURATION_MS,
  };
}

function toItemGainMessage({ itemDataId, item, count }) {
  const id = Number(itemDataId ?? item?.id);
  const amount = Math.max(1, Math.floor(Number(count) || 1));
  const name = item?.name || `Item ${id || '?'}`;

  return {
    type: CURRENCY_ITEM_IDS.has(id) ? 'currency' : 'loot',
    icon: iconForItem(id),
    title: `${name} 획득`,
    body: `+${formatNumber(amount)}`,
    meta: id ? `ID ${id}` : '',
    duration: CURRENCY_ITEM_IDS.has(id) ? 1900 : 2800,
  };
}

function createToast(message) {
  const node = document.createElement('article');
  node.className = `message-toast message-${message.type}`;
  node.setAttribute('role', 'status');

  const icon = document.createElement('span');
  icon.className = 'message-icon';
  icon.textContent = message.icon || iconForType(message.type);

  const copy = document.createElement('span');
  copy.className = 'message-copy';

  const title = document.createElement('b');
  title.className = 'message-title';
  title.textContent = message.title;

  const body = document.createElement('span');
  body.className = 'message-body';
  body.textContent = message.body;

  copy.append(title, body);
  node.append(icon, copy);

  if (message.meta) {
    const meta = document.createElement('span');
    meta.className = 'message-meta';
    meta.textContent = message.meta;
    node.append(meta);
  }

  return node;
}

function iconForItem(itemDataId) {
  const id = Number(itemDataId);
  if (id === 5) return '$';
  if (id === 6) return 'XP';
  if (id >= 200000) return '+';
  return '*';
}

function iconForType(type = 'info') {
  return ({
    clear: 'OK',
    currency: '$',
    info: 'i',
    loot: '+',
    upgrade: 'UP',
    warning: '!',
  })[type] || 'i';
}
