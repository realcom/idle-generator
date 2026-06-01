import { pickLevelValue } from './constants.js';

const BUNDLES = [
  ['ResourceGlobals', 'ResourceGlobals.json'],
  ['Maps', 'Maps.json'],
  ['Units', 'Units.json'],
  ['Items', 'Items.json'],
  ['Skills', 'Skills.json'],
  ['Buffs', 'Buffs.json'],
  ['Triggers', 'Triggers.json'],
  ['Strings', 'Strings.json'],
  ['Achievements', 'Achievements.json'],
  ['Audios', 'Audios.json'],
];

export class ResourceStore {
  constructor({ basePath = '../build' } = {}) {
    this.basePath = basePath.replace(/\/$/, '');
    this.gameId = null;
    this.bundles = {};
    this.maps = new Map();
    this.units = new Map();
    this.items = new Map();
    this.skills = new Map();
    this.buffs = new Map();
    this.triggers = new Map();
  }

  async loadGame(gameId = 'mushroomer') {
    this.gameId = gameId;
    const entries = await Promise.all(BUNDLES.map(async ([key, file]) => {
      const url = `${this.basePath}/${gameId}/${file}`;
      const res = await fetch(url);
      if (!res.ok) throw new Error(`Failed to load ${url}: ${res.status}`);
      return [key, await res.json()];
    }));
    this.indexBundles(Object.fromEntries(entries));
    return this;
  }

  indexBundles(bundles) {
    this.bundles = bundles;
    this.maps = this.#indexById(bundles.Maps?.maps);
    this.units = this.#indexById(bundles.Units?.units);
    this.items = this.#indexById(bundles.Items?.items);
    this.skills = this.#indexById(bundles.Skills?.skills);
    this.buffs = this.#indexById(bundles.Buffs?.buffs);
    this.triggers = new Map((bundles.Triggers?.triggers || []).map(t => [t.name, t]));
    return this;
  }

  #indexById(list = []) {
    return new Map(list.map(item => [item.id, item]));
  }

  getMap(id) { return this.maps.get(Number(id)); }
  getUnit(id) { return this.units.get(Number(id)); }
  getItem(id) { return this.items.get(Number(id)); }
  getSkill(id) { return this.skills.get(Number(id)); }
  getBuff(id) { return this.buffs.get(Number(id)); }
  getTrigger(name) { return this.triggers.get(name); }

  getFirstMap() {
    return this.maps.values().next().value;
  }

  getPlayerUnit() {
    return [...this.units.values()].find(unit => unit.type === 'Player');
  }

  statValue(unitDef, statType = 'Hp', level = 1, fallback = 0) {
    const stat = (unitDef?.addStats || []).find(s => (s.type || 'Hp') === statType);
    return pickLevelValue(stat?.value, level, fallback);
  }

  itemStatValue(itemDef, statType = 'Hp', level = 1, fallback = 0) {
    const stat = (itemDef?.addStats || []).find(s => (s.type || 'Hp') === statType);
    return pickLevelValue(stat?.value, level, fallback);
  }

  itemMaxLevel(itemDef) {
    const statMax = Math.max(1, ...(itemDef?.addStats || []).map(stat => stat.value?.length || 1));
    const materialMax = Math.max(1, ...(itemDef?.levelUpMaterialItemGroups || []).map(group => Number(group.level || 0) + 1));
    return Math.max(statMax, materialMax);
  }

  itemLevelUpCost(itemDef, level = 1, materialItemId = 5) {
    const group = (itemDef?.levelUpMaterialItemGroups || []).find(entry => Number(entry.level) === Number(level));
    const material = (group?.materialItems || []).find(item => Number(item.id ?? item.itemDataId) === materialItemId);
    return material ? Number(material.count || 0) : Infinity;
  }
}
