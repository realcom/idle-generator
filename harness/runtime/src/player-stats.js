// player-stats.js — 플레이어 스탯, 골드, 강화 시스템
// full-spine-runtime.html에서 포팅. Board/Scene과 독립적으로 동작.

export class PlayerStats {
  constructor() {
    this.gold = 0;
    this.atkLv = 0;
    this.hpLv = 0;
    this.defLv = 0;
    this.spdLv = 0;
    this.critLv = 0;
    this.stage = 1;
    this.best = 1;
    this.skills = []; // 해금된 스킬
    this._listeners = [];
    this._hp = this.hpMax; // 현재 HP
    this._dead = false;
  }

  // ── 계산된 스탯 ──
  get atk()   { return Math.round(34 + this.atkLv * 9 * Math.pow(1.07, this.atkLv)); }
  get hpMax() { return Math.round(340 + this.hpLv * 80 * Math.pow(1.07, this.hpLv)); }
  get def()   { return Math.round(5 + this.defLv * 3); }
  get spd()   { return +(1.0 + this.spdLv * 0.12).toFixed(2); }
  get crit()  { return Math.min(85, 5 + this.critLv * 4); }
  get gps()   { return Math.round(3 * Math.pow(1.12, this.best - 1)); }
  get hp()     { return this._hp; }
  get dead()   { return this._dead; }

  // ── 강화 비용 ──
  cost(baseCost, rate, level) {
    return Math.round(baseCost * Math.pow(rate, level));
  }

  // ── 강화 구매 ──
  upgrade(key) {
    const defs = {
      atk:  { base: 12, rate: 1.16, field: 'atkLv' },
      hp:   { base: 10, rate: 1.16, field: 'hpLv' },
      def:  { base: 15, rate: 1.19, field: 'defLv' },
      spd:  { base: 40, rate: 1.35, field: 'spdLv' },
      crit: { base: 30, rate: 1.3,  field: 'critLv' },
    };
    const d = defs[key];
    if (!d) return false;
    const c = this.cost(d.base, d.rate, this[d.field]);
    if (this.gold < c) return false;
    this.gold -= c;
    const prevMax = this.hpMax;
    this[d.field]++;
    if (key === 'hp') this._syncHpOnUpgrade(prevMax);
    this._emit('upgraded', key);
    return true;
  }

  // ── 스킬 구매 ──
  buySkill(key) {
    const skillDefs = {
      spin:  { cost: 800,  name: '회전베기', cd: 3.0, mult: 1.8, tg: 'all' },
      smash: { cost: 3000, name: '강타',     cd: 5.0, mult: 2.5, tg: 'one' },
    };
    const s = skillDefs[key];
    if (!s || this.gold < s.cost) return false;
    if (this.skills.find(sk => sk.key === key)) return false; // 이미 보유
    this.gold -= s.cost;
    this.skills.push({ key, n: s.name, cd: s.cd, t: s.cd, mult: s.mult, tg: s.tg });
    this._emit('skillBought', key);
    return true;
  }

  hasSkill(key) { return this.skills.some(s => s.key === key); }

  // ── 골드 수입 ──
  addGold(amount) {
    this.gold += amount;
    this._emit('goldChanged', this.gold);
  }

  // ── 킬 보상 ──
  killReward(unit) {
    const isBoss = unit.type === 'Boss';
    const base = isBoss ? 50 : 8;
    const reward = Math.round(base * Math.pow(1.16, this.stage - 1));
    this.addGold(reward);
    return reward;
  }

  // ── HP 관련 ──
  takeDamage(rawDmg) {
    if (this._dead) return 0;
    const dmg = Math.max(1, rawDmg - this.def);
    this._hp = Math.max(0, this._hp - dmg);
    this._emit('hpChanged', { hp: this._hp, max: this.hpMax, dmg });
    if (this._hp <= 0) {
      this._dead = true;
      this._emit('playerDied');
    }
    return dmg;
  }

  healToFull() {
    this._hp = this.hpMax;
    this._dead = false;
    this._emit('hpChanged', { hp: this._hp, max: this.hpMax, dmg: 0 });
  }

  revive() {
    this._dead = false;
    this._hp = this.hpMax;
    this._emit('hpChanged', { hp: this._hp, max: this.hpMax, dmg: 0 });
    this._emit('playerRevived');
  }

  // HP 레벨업 시 maxHp 증가만큼 현재 HP도 증가
  _syncHpOnUpgrade(prevMax) {
    const diff = this.hpMax - prevMax;
    if (diff > 0) {
      this._hp = Math.min(this.hpMax, this._hp + diff);
      this._emit('hpChanged', { hp: this._hp, max: this.hpMax, dmg: 0 });
    }
  }

  // ── 이벤트 ──
  on(event, fn) { this._listeners.push({ event, fn }); }
  _emit(event, payload) {
    this._listeners.filter(l => l.event === event).forEach(l => l.fn(payload));
  }
}

// ── 강화 정의 (UI용 export) ──
export const UPGRADE_DEFS = [
  { key: 'atk',  label: 'ATK',  base: 12, rate: 1.16, field: 'atkLv', icon: '⚔️' },
  { key: 'hp',   label: 'HP',   base: 10, rate: 1.16, field: 'hpLv',  icon: '❤️' },
  { key: 'def',  label: 'DEF',  base: 15, rate: 1.19, field: 'defLv', icon: '🛡️' },
  { key: 'spd',  label: 'SPD',  base: 40, rate: 1.35, field: 'spdLv', icon: '⚡' },
  { key: 'crit', label: 'CRIT', base: 30, rate: 1.3,  field: 'critLv',icon: '💥' },
];

export const SKILL_DEFS = [
  { key: 'spin',  label: '회전베기', cost: 800,  icon: '🌀', desc: '전체 공격' },
  { key: 'smash', label: '강타',     cost: 3000, icon: '💫', desc: '단일 강타' },
];

// ── 숫자 포맷 ──
export function fmt(n) {
  n = Math.floor(n);
  if (n < 1000) return '' + n;
  const u = ['', 'K', 'M', 'B', 'T'];
  let i = 0;
  while (n >= 1000 && i < u.length - 1) { n /= 1000; i++; }
  return n.toFixed(1) + u[i];
}
