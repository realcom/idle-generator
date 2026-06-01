const SETTINGS_STORAGE_KEY = 'idlez.phaser.settings';
const LOCAL_PLAYER_ID_KEY = 'idlez.phaser.guestSnsId';
const LOCAL_DEVICE_ID_KEY = 'idlez.phaser.deviceId';
const DEFAULT_LANGUAGE = 'ko';

export const SETTINGS_CHANGED_EVENT = 'mushroomer:settings-changed';

export const LANGUAGE_OPTIONS = [
  { code: 'ko', label: '한국어', shortLabel: 'KO' },
  { code: 'en', label: 'English', shortLabel: 'EN' },
  { code: 'ja', label: '日本語', shortLabel: 'JA' },
  { code: 'zh', label: '中文', shortLabel: 'ZH' },
];

export function readSettingsPreference() {
  try {
    const raw = globalThis.localStorage?.getItem(SETTINGS_STORAGE_KEY);
    if (!raw) return {};
    const parsed = JSON.parse(raw);
    return parsed && typeof parsed === 'object' ? parsed : {};
  } catch {
    return {};
  }
}

export function resolveSettings({ defaultBgmEnabled = true, defaultSfxEnabled = true } = {}) {
  const preference = readSettingsPreference();
  return {
    bgmEnabled: typeof preference.bgmEnabled === 'boolean'
      ? preference.bgmEnabled
      : Boolean(defaultBgmEnabled),
    sfxEnabled: typeof preference.sfxEnabled === 'boolean'
      ? preference.sfxEnabled
      : Boolean(defaultSfxEnabled),
    language: normalizeLanguage(preference.language) || browserLanguage(),
  };
}

export function saveSettings(patch = {}, options = {}) {
  const next = {
    ...resolveSettings(options),
    ...patch,
  };
  next.bgmEnabled = Boolean(next.bgmEnabled);
  next.sfxEnabled = Boolean(next.sfxEnabled);
  next.language = normalizeLanguage(next.language) || DEFAULT_LANGUAGE;

  try {
    globalThis.localStorage?.setItem(SETTINGS_STORAGE_KEY, JSON.stringify(next));
  } catch {
    // Private browsing or file previews can reject storage. Runtime state still updates.
  }

  applyLanguagePreference(next.language);
  dispatchSettingsChanged(next);
  return next;
}

export function applyLanguagePreference(language) {
  const code = normalizeLanguage(language) || DEFAULT_LANGUAGE;
  const doc = globalThis.document;
  if (!doc?.documentElement) return code;
  doc.documentElement.lang = code;
  doc.documentElement.dataset.language = code;
  return code;
}

export function preferredLanguage() {
  return resolveSettings().language;
}

export function getOrCreateLocalPlayerId() {
  return getOrCreateLocalId(LOCAL_PLAYER_ID_KEY, 'Guest_');
}

export function getOrCreateDeviceId() {
  return getOrCreateLocalId(LOCAL_DEVICE_ID_KEY, 'Web_');
}

export function normalizeLanguage(language) {
  const code = String(language || '').trim().toLowerCase().split(/[-_]/)[0];
  return LANGUAGE_OPTIONS.some(option => option.code === code) ? code : '';
}

function browserLanguage() {
  return normalizeLanguage(globalThis.navigator?.language) || DEFAULT_LANGUAGE;
}

function getOrCreateLocalId(key, prefix) {
  try {
    const existing = globalThis.localStorage?.getItem(key);
    if (existing) return existing;

    const value = `${prefix}${randomId()}`;
    globalThis.localStorage?.setItem(key, value);
    return value;
  } catch {
    return `${prefix}${randomId()}`;
  }
}

function randomId() {
  const uuid = globalThis.crypto?.randomUUID?.();
  if (uuid) return uuid.replace(/-/g, '');
  return Math.random().toString(16).slice(2);
}

function dispatchSettingsChanged(settings) {
  globalThis.dispatchEvent?.(new CustomEvent(SETTINGS_CHANGED_EVENT, {
    detail: { settings },
  }));
}
