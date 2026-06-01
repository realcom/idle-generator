// data-loader.js — idlez 콘텐츠 로더
// build/<game>/ 산출물(JSON)만 읽는다. 트리거는 컴파일된 Triggers.json 이 신뢰 출처.

export class DataLoader {
  constructor(basePath = '../') {
    this.basePath = basePath;
    this.maps = new Map();        // id → mapDef
    this.units = new Map();       // id → unitDef
    this.items = new Map();       // id → itemDef
    this.triggers = new Map();    // name → triggerDef (statements + type + period)
  }

  async loadAll(gameId = 'idlez') {
    const buildPath = `${this.basePath}build/${gameId}`;

    const [maps, units, items, triggers] = await Promise.all([
      this._fetchJson(`${buildPath}/Maps.json`),
      this._fetchJson(`${buildPath}/Units.json`),
      this._fetchJson(`${buildPath}/Items.json`),
      this._fetchJson(`${buildPath}/Triggers.json`),
    ]);

    maps.maps.forEach(m => this.maps.set(m.id, m));
    units.units.forEach(u => this.units.set(u.id, u));
    items.items.forEach(i => this.items.set(i.id, i));
    triggers.triggers.forEach(t => this.triggers.set(t.name, t));

    return this;
  }

  async _fetchJson(url) {
    const res = await fetch(url);
    if (!res.ok) throw new Error(`Failed to load ${url}: ${res.status}`);
    return res.json();
  }

  getMap(id)            { return this.maps.get(id); }
  getUnit(id)           { return this.units.get(id); }
  getItem(id)           { return this.items.get(id); }
  getTrigger(name)      { return this.triggers.get(name); }

  // 유닛 raw 스탯 — Units.json 의 addStats 가 신뢰 출처
  getRawStat(unitId, statType) {
    const u = this.units.get(unitId);
    if (!u) return null;
    const found = (u.addStats || []).find(s => (s.type || 'Hp') === statType);
    return found?.value?.[0] ?? null;
  }
}
