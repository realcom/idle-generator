export const TICKS_PER_SECOND = 30;
export const TICK_MS = 1000 / TICKS_PER_SECOND;

export const TEAM = {
  PLAYER: 1,
  ENEMY: 4,
};

export function ticksFromSeconds(seconds, minTicks = 1) {
  return Math.max(minTicks, Math.round(Number(seconds || 0) * TICKS_PER_SECOND));
}

export function clamp(value, min, max) {
  return Math.max(min, Math.min(max, value));
}

export function asNumber(value, fallback = 0) {
  if (value == null || value === '') return fallback;
  const n = Number(value);
  return Number.isFinite(n) ? n : fallback;
}

export function normalizeTeam(team, fallback = TEAM.ENEMY) {
  if (team == null || team === '') return fallback;
  if (team === 'Player') return TEAM.PLAYER;
  if (team === 'Enemy') return TEAM.ENEMY;
  return asNumber(team, fallback);
}

export function formatNumber(value) {
  let n = Math.floor(asNumber(value, 0));
  if (Math.abs(n) < 1000) return String(n);

  const units = ['', 'K', 'M', 'B', 'T', 'aa', 'ab'];
  let i = 0;
  while (Math.abs(n) >= 1000 && i < units.length - 1) {
    n /= 1000;
    i += 1;
  }
  return `${n.toFixed(n < 10 ? 1 : 0)}${units[i]}`;
}

export function pickLevelValue(values, level = 1, fallback = 0) {
  if (!Array.isArray(values) || values.length === 0) return fallback;
  const index = clamp(Math.floor(level) - 1, 0, values.length - 1);
  return asNumber(values[index], fallback);
}
