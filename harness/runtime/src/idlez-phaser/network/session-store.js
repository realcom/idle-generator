import { formatNumber } from '../constants.js';

export class IdlezSessionStore {
  constructor(board, store) {
    this.board = board;
    this.store = store;
    this.reset();
  }

  reset() {
    this.player = null;
    this.world = null;
    this.avatar = null;
    this.achievements = new Map();
    this.itemsById = new Map();
    this.itemsByDataId = new Map();
  }

  applyLoginResponse(response = {}) {
    this.player = response.player || this.player;
    this.world = response.world || this.world;
    this.avatar = response.avatar || this.avatar;
    this.applyAchievements(response.achievements || []);
    this.applyItems(response.items || []);
  }

  applyAchievements(achievements = []) {
    for (const achievement of achievements) {
      const id = toNumber(achievement.achievementDataId ?? achievement.dataId ?? achievement.id);
      if (id) this.achievements.set(id, achievement);
    }
  }

  applyItems(items = []) {
    const changed = [];
    for (const item of items) {
      const itemId = toNumber(item.id);
      const itemDataId = toNumber(item.itemDataId);
      if (!itemDataId) continue;

      if (itemId) this.itemsById.set(itemId, item);
      this.itemsByDataId.set(itemDataId, item);

      const count = toNumber(item.count, 0);
      const level = Math.max(1, toNumber(item.level, 1));
      if (count >= 0) this.board.inventory.set(itemDataId, count);
      this.board.itemLevels.set(itemDataId, level);

      changed.push({ item, itemDataId, count, level });
    }

    if (changed.length > 0) {
      this.board.emit('inventorySynced', { items: changed });
      this.board.emit('tick', this.board.snapshot());
    }

    return changed;
  }

  applyLevelUpResponse(response = {}) {
    const changed = this.applyItems(response.items || []);
    const upgraded = changed.find(entry => entry.level > 1) || changed[0];
    if (upgraded) {
      this.board.emit('itemLevelUp', {
        itemDataId: upgraded.itemDataId,
        item: this.store.getItem(upgraded.itemDataId),
        level: upgraded.level,
        source: 'server',
      });
    }
    return changed;
  }

  getItemInstanceId(itemDataId) {
    const item = this.itemsByDataId.get(Number(itemDataId));
    return item ? toNumber(item.id) : 0;
  }

  describeItem(itemDataId, count = 1) {
    const item = this.store.getItem(itemDataId);
    return `${item?.name || `Item ${itemDataId}`} +${formatNumber(count)}`;
  }
}

export function toNumber(value, fallback = 0) {
  if (value == null) return fallback;
  if (typeof value === 'number') return Number.isFinite(value) ? value : fallback;
  if (typeof value === 'bigint') return Number(value);
  if (typeof value.toNumber === 'function') return value.toNumber();
  const number = Number(value);
  return Number.isFinite(number) ? number : fallback;
}
