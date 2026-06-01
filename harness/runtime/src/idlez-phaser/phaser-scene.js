import { TEAM, clamp, formatNumber } from './constants.js';
import {
  applyLanguagePreference,
  readSettingsPreference,
  resolveSettings,
  saveSettings,
} from './settings-store.js?v=settings1';

const PhaserScene = globalThis.Phaser?.Scene ?? class {};
const BGM_KEY = 'hamster-garden-hop';
const BGM_PATH = 'assets/audio/hamster-garden-hop.mp3';
const ENABLE_AUDIO_VALUES = new Set(['1', 'true', 'yes', 'on']);
const DISABLE_AUDIO_VALUES = new Set(['0', 'false', 'no', 'off']);
const SPLASH_KEY = 'slimequeen-start-splash';
const SPLASH_PATH = 'assets/ui/splash/slimequeen-start-splash.png';
const SPLASH_DISPLAY_MS = 2200;
const SFX_DEFS = {
  uiClick: { key: 'sfx-ui-click', path: 'assets/audio/sfx/ui_click.wav', volume: 0.42, cooldownMs: 45 },
  uiError: { key: 'sfx-ui-error', path: 'assets/audio/sfx/ui_error.wav', volume: 0.5, cooldownMs: 180 },
  attack: { key: 'sfx-attack-slash', path: 'assets/audio/sfx/attack_slash.wav', volume: 0.34, cooldownMs: 95 },
  hit: { key: 'sfx-hit-monster', path: 'assets/audio/sfx/hit_monster.wav', volume: 0.36, cooldownMs: 85 },
  monsterDead: { key: 'sfx-monster-dead', path: 'assets/audio/sfx/monster_dead.wav', volume: 0.42, cooldownMs: 140 },
  coin: { key: 'sfx-coin-pickup', path: 'assets/audio/sfx/coin_pickup.wav', volume: 0.32, cooldownMs: 95 },
  reward: { key: 'sfx-reward-get', path: 'assets/audio/sfx/reward_get.wav', volume: 0.38, cooldownMs: 160 },
  levelUp: { key: 'sfx-level-up', path: 'assets/audio/sfx/level_up.wav', volume: 0.44, cooldownMs: 220 },
};
const MAP_BACKGROUNDS = {
  meadow_day: {
    colors: [
      { from: 0, to: 0.34, color: 0xa3df9b },
      { from: 0.34, to: 0.56, color: 0xbfe79a },
      { from: 0.56, to: 1, color: 0x7fc65a },
    ],
    backdrop: { color: '#a3df9b', skyLayerKey: 'map-sky' },
    details: 'garden',
    layers: [
      { key: 'map-sky', path: 'assets/maps/meadow_day/sky.png', role: 'sky', mode: 'cover', y: 0.16, heightScale: 0.42, depth: -44 },
      { key: 'map-far', path: 'assets/maps/meadow_day/far.png', mode: 'width', y: 0.38, depth: -30 },
      { key: 'map-mid', path: 'assets/maps/meadow_day/mid.png', mode: 'width', y: 0.52, depth: -20 },
      { key: 'map-near', path: 'assets/maps/meadow_day/near.png', mode: 'width', y: 1.1, originY: 1, depth: -10 },
    ],
  },
  weekday_degul_rock: {
    colors: [
      { from: 0, to: 0.48, color: 0x78c8e8 },
      { from: 0.48, to: 0.72, color: 0x98bf78 },
      { from: 0.72, to: 1, color: 0x6f8d58 },
    ],
    lane: { base: 0x6d4b31, top: 0xa87843, trim: 0x3f2a1d, grassA: 0xbdd969, grassB: 0xd7e783 },
    layers: [
      { key: 'weekday-degul-far', path: 'assets/maps/weekday/degul_rock/Img_Map_DegulRock_Day_FarObject.png', mode: 'width', y: 0.4, widthScale: 1.04, depth: -34 },
      { key: 'weekday-degul-water', path: 'assets/maps/weekday/degul_rock/Img_Map_DegulRock_Day_MidWater.png', mode: 'width', y: 0.57, widthScale: 1.04, depth: -25 },
      { key: 'weekday-degul-ground', path: 'assets/maps/weekday/degul_rock/Img_Map_DegulRock_Day_Ground.png', mode: 'width', y: 0.72, widthScale: 1.04, depth: -18 },
      { key: 'weekday-degul-near', path: 'assets/maps/weekday/degul_rock/Img_Map_DegulRock_Day_NearObj.png', mode: 'width', y: 1.03, originY: 1, widthScale: 1.06, depth: -8 },
    ],
  },
  weekday_hotragon: {
    colors: [
      { from: 0, to: 0.46, color: 0x2b1d27 },
      { from: 0.46, to: 0.72, color: 0x583329 },
      { from: 0.72, to: 1, color: 0x2a1d21 },
    ],
    lane: { base: 0x4a2b26, top: 0x8b4e32, trim: 0x2a1715, grassA: 0xd77745, grassB: 0xffb85f },
    layers: [
      { key: 'weekday-hotragon-far', path: 'assets/maps/weekday/hotragon/Img_Map_Dungeon_Hotragon_Far.png', mode: 'width', y: 0.35, widthScale: 1.08, depth: -36 },
      { key: 'weekday-hotragon-mid', path: 'assets/maps/weekday/hotragon/Img_Map_Dungeon_Hotragon_Mid.png', mode: 'width', y: 0.5, widthScale: 1.08, depth: -26 },
      { key: 'weekday-hotragon-ground', path: 'assets/maps/weekday/hotragon/Img_Map_Dungeon_Hotragon_Ground.png', mode: 'width', y: 0.72, widthScale: 1.08, depth: -17 },
      { key: 'weekday-hotragon-near', path: 'assets/maps/weekday/hotragon/Img_Map_Dungeon_Hotragon_Near.png', mode: 'width', y: 1.04, originY: 1, widthScale: 1.1, depth: -8 },
    ],
  },
  weekday_meadow_dawn: {
    colors: [
      { from: 0, to: 0.46, color: 0xf1b58a },
      { from: 0.46, to: 0.66, color: 0x9fd18a },
      { from: 0.66, to: 1, color: 0x6aa85d },
    ],
    backdrop: { color: '#3a5489', skyLayerKey: 'weekday-meadow-dawn-sky' },
    details: 'garden',
    layers: [
      { key: 'weekday-meadow-dawn-sky', path: 'assets/maps/weekday/meadow_dawn/Img_Map_Meadow_Dawn_Sky.png', role: 'sky', mode: 'cover', y: 0.22, heightScale: 0.56, depth: -44 },
      { key: 'weekday-meadow-dawn-far', path: 'assets/maps/weekday/meadow_dawn/Img_Map_Meadow_Dawn_Far.png', mode: 'width', y: 0.38, widthScale: 1.02, depth: -32 },
      { key: 'weekday-meadow-dawn-mid', path: 'assets/maps/weekday/meadow_dawn/Img_Map_Meadow_Dawn_Mid.png', mode: 'width', y: 0.54, widthScale: 1.02, depth: -22 },
      { key: 'weekday-meadow-dawn-near', path: 'assets/maps/weekday/meadow_dawn/Img_Map_Meadow_Dawn_Near.png', mode: 'width', y: 1.1, originY: 1, widthScale: 1.04, depth: -10 },
    ],
  },
  weekday_jungle_dawn: {
    colors: [
      { from: 0, to: 0.5, color: 0xbdd8ad },
      { from: 0.5, to: 0.72, color: 0x5ca882 },
      { from: 0.72, to: 1, color: 0x306d48 },
    ],
    backdrop: { color: '#656393', skyLayerKey: 'weekday-jungle-sky' },
    lane: { base: 0x385b34, top: 0x739842, trim: 0x1e3d28, grassA: 0xa6df62, grassB: 0x73c655 },
    layers: [
      { key: 'weekday-jungle-sky', path: 'assets/maps/weekday/jungle_dawn/Img_Map_Jungle_Dawn_Sky.png', role: 'sky', mode: 'cover', y: 0.24, heightScale: 0.58, depth: -45 },
      { key: 'weekday-jungle-far1', path: 'assets/maps/weekday/jungle_dawn/Img_Map_Jungle_Dawn_FarObject01.png', mode: 'width', y: 0.38, widthScale: 1.05, depth: -35 },
      { key: 'weekday-jungle-far2', path: 'assets/maps/weekday/jungle_dawn/Img_Map_Jungle_Dawn_FarObject02.png', mode: 'width', y: 0.43, widthScale: 1.06, depth: -31 },
      { key: 'weekday-jungle-water', path: 'assets/maps/weekday/jungle_dawn/Img_Map_Jungle_Dawn_MidWater.png', mode: 'width', y: 0.58, widthScale: 1.05, depth: -25 },
      { key: 'weekday-jungle-ground', path: 'assets/maps/weekday/jungle_dawn/Img_Map_Jungle_Dawn_Ground.png', mode: 'width', y: 0.74, widthScale: 1.06, depth: -18 },
      { key: 'weekday-jungle-near', path: 'assets/maps/weekday/jungle_dawn/Img_Map_Jungle_Dawn_NearObject.png', mode: 'width', y: 1.02, originY: 1, widthScale: 1.08, depth: -8 },
    ],
  },
  weekday_beach_dawn: {
    colors: [
      { from: 0, to: 0.48, color: 0xf3bf89 },
      { from: 0.48, to: 0.7, color: 0x75bed2 },
      { from: 0.7, to: 1, color: 0xdbc772 },
    ],
    backdrop: { color: '#564093', skyLayerKey: 'weekday-beach-sky' },
    lane: { base: 0x8b6a3b, top: 0xcfaa5c, trim: 0x5b4127, grassA: 0xf0dd87, grassB: 0xc6d77a },
    layers: [
      { key: 'weekday-beach-sky', path: 'assets/maps/weekday/beach_dawn/Img_Map_Beach_Dawn_Sky.png', role: 'sky', mode: 'cover', y: 0.23, heightScale: 0.58, depth: -45 },
      { key: 'weekday-beach-far', path: 'assets/maps/weekday/beach_dawn/Img_Map_Beach_Dawn_FarObject.png', mode: 'width', y: 0.4, widthScale: 1.05, depth: -34 },
      { key: 'weekday-beach-sea', path: 'assets/maps/weekday/beach_dawn/Img_Map_Beach_Dawn_Sea.png', mode: 'width', y: 0.54, widthScale: 1.05, depth: -28 },
      { key: 'weekday-beach-mid1', path: 'assets/maps/weekday/beach_dawn/Img_Map_Beach_Dawn_MidObject01.png', mode: 'width', y: 0.55, widthScale: 1.06, depth: -22 },
      { key: 'weekday-beach-mid2', path: 'assets/maps/weekday/beach_dawn/Img_Map_Beach_Dawn_MidObject02.png', mode: 'width', y: 0.57, widthScale: 1.06, depth: -20 },
      { key: 'weekday-beach-ground', path: 'assets/maps/weekday/beach_dawn/Img_Map_Beach_Dawn_Ground.png', mode: 'width', y: 0.8, widthScale: 1.08, depth: -12 },
    ],
  },
  weekday_train_day: {
    colors: [
      { from: 0, to: 0.42, color: 0xb3d8ec },
      { from: 0.42, to: 0.7, color: 0x597288 },
      { from: 0.7, to: 1, color: 0x2f3e4c },
    ],
    lane: { base: 0x24313e, top: 0x586574, trim: 0x17212c, grassA: 0xa4b8c5, grassB: 0xd3dee5 },
    layers: [
      { key: 'weekday-train-main', path: 'assets/maps/weekday/train_day/Img_Map_InfiniteTrain_Day_Main.png', mode: 'cover', y: 0.5, depth: -42 },
      { key: 'weekday-train-lr', path: 'assets/maps/weekday/train_day/Img_Map_InfiniteTrain_Day_LR.png', mode: 'cover', y: 0.5, depth: -28 },
      { key: 'weekday-train-top', path: 'assets/maps/weekday/train_day/Img_Map_InfiniteTrain_Day_Top.png', mode: 'cover', y: 0.5, depth: -24 },
      { key: 'weekday-train-bottom', path: 'assets/maps/weekday/train_day/Img_Map_InfiniteTrain_Day_Bottom.png', mode: 'cover', y: 0.5, depth: -20 },
      { key: 'weekday-train-front', path: 'assets/maps/weekday/train_day/Img_Map_InfiniteTrain_Day_Front.png', mode: 'width', y: 0.95, originY: 1, widthScale: 1.08, depth: -8 },
    ],
  },
  weekday_slime_queen: {
    colors: [
      { from: 0, to: 0.45, color: 0x9fcfe1 },
      { from: 0.45, to: 0.72, color: 0x6fb886 },
      { from: 0.72, to: 1, color: 0x3c6b4f },
    ],
    lane: { base: 0x4b5932, top: 0x8ca454, trim: 0x26331f, grassA: 0xd2dc68, grassB: 0x8ed15d },
    layers: [
      { key: 'weekday-slimequeen-back', path: 'assets/maps/weekday/slime_queen/Img_Map_SlimeQueen_0.png', mode: 'cover', y: 0.48, depth: -40 },
      { key: 'weekday-slimequeen-front', path: 'assets/maps/weekday/slime_queen/Img_Map_SlimeQueen_1.png', mode: 'cover', y: 0.52, depth: -12 },
    ],
  },
};
const SKILL_EFFECTS = {
  300101: { kind: 'seedPop', primary: 0xffd35f, secondary: 0x9be45e, accent: 0x7a4d1e, tertiary: 0xffffff, cast: 'seed', radiusScale: 0.62, duration: 340 },
  300102: { kind: 'cheekBurst', primary: 0xff9cc8, secondary: 0xffd66d, accent: 0x8de875, tertiary: 0x7ae7ff, cast: 'lob', radiusScale: 0.96, duration: 430 },
  300103: { kind: 'toothSlam', primary: 0xfff0b0, secondary: 0xff7c3a, accent: 0x8d3f1f, tertiary: 0xffffff, cast: 'dash', radiusScale: 0.76, duration: 390, shake: 0.003 },
  300104: { kind: 'snackAwakening', primary: 0xa6f29a, secondary: 0xffee8a, accent: 0xff9cc8, tertiary: 0xffffff, cast: 'aura', radiusScale: 0.84, duration: 680 },
  300105: { kind: 'wheelWhirl', primary: 0x72e0ff, secondary: 0xc4f279, accent: 0xffd36a, tertiary: 0xffffff, cast: 'spiral', radiusScale: 1.04, duration: 580 },
  300106: { kind: 'nutCrush', primary: 0xf5d06a, secondary: 0xff7747, accent: 0x5b3420, tertiary: 0xffffff, cast: 'dash', radiusScale: 0.86, duration: 420, shake: 0.004 },
  300107: { kind: 'moonWheel', primary: 0xb9d2ff, secondary: 0xd9b4ff, accent: 0x77f0b0, tertiary: 0xffffff, cast: 'rune', radiusScale: 1.08, duration: 690 },
  300108: { kind: 'sawdustRain', primary: 0xd7a86a, secondary: 0x8d6aff, accent: 0x67e0a3, tertiary: 0xfff0a8, cast: 'rain', radiusScale: 1.14, duration: 700 },
  300109: { kind: 'cheekRage', primary: 0xff6b6b, secondary: 0xffd15b, accent: 0x7a1f1f, tertiary: 0xff9cc8, cast: 'rage', radiusScale: 0.96, duration: 590, shake: 0.005 },
  300110: { kind: 'starCandyMeteor', primary: 0xffb45b, secondary: 0x9ee8ff, accent: 0xff6fcf, tertiary: 0xffffff, cast: 'meteor', radiusScale: 1.05, duration: 720, shake: 0.006 },
  300111: { kind: 'hamsterStampede', primary: 0xa6ff6f, secondary: 0xffc85c, accent: 0x72e0ff, tertiary: 0xffffff, cast: 'wave', radiusScale: 1.2, duration: 760, shake: 0.004 },
  300112: { kind: 'goldCheekUltimate', primary: 0xfff0a8, secondary: 0xc78cff, accent: 0x68f0a2, tertiary: 0xffffff, cast: 'ultimate', radiusScale: 1.36, duration: 980, shake: 0.008 },
};
const DEFAULT_SKILL_EFFECT = {
  kind: 'seedPop',
  primary: 0xffd35f,
  secondary: 0x9be45e,
  accent: 0x7a4d1e,
  tertiary: 0xffffff,
  cast: 'seed',
  radiusScale: 0.72,
  duration: 340,
};
const SKILL_FX_RADIUS_MULTIPLIER = 1.9;
const SKILL_FX_CAST_MULTIPLIER = 1.65;
const SKILL_FX_STROKE_MULTIPLIER = 1.45;
const SKILL_FX_MOTE_MULTIPLIER = 1.45;
const SKILL_FX_DENSITY_MULTIPLIER = 1.25;

function shouldSuppressBackgroundMusic() {
  if (isAudioExplicitlyEnabled() || isParamEnabled('bgm', 'music')) return false;
  if (isAudioExplicitlyDisabled() || isParamDisabled('bgm', 'music')) return true;

  if (globalThis.__IDLEZ_PHASER_ENABLE_BGM__ || globalThis.__MUSHROOMER_PHASER_ENABLE_BGM__) return false;
  if (globalThis.__IDLEZ_PHASER_DISABLE_BGM__ || globalThis.__MUSHROOMER_PHASER_DISABLE_BGM__) return true;

  const params = new URLSearchParams(globalThis.location?.search || '');
  if (params.has('noBgm') || params.has('muteBgm') || params.has('noAudio') || params.has('muteAudio')) return true;
  if (isAutomationBrowser() || isLocalPreviewHost()) return true;

  const preference = readSettingsPreference();
  if (typeof preference.bgmEnabled === 'boolean') return !preference.bgmEnabled;
  return false;
}

function shouldSuppressSoundEffects() {
  if (isAudioExplicitlyEnabled() || isParamEnabled('sfx', 'sound', 'effects')) return false;
  if (isAudioExplicitlyDisabled() || isParamDisabled('sfx', 'sound', 'effects')) return true;

  if (globalThis.__IDLEZ_PHASER_ENABLE_SFX__ || globalThis.__MUSHROOMER_PHASER_ENABLE_SFX__) return false;
  if (globalThis.__IDLEZ_PHASER_DISABLE_SFX__ || globalThis.__MUSHROOMER_PHASER_DISABLE_SFX__) return true;

  const params = new URLSearchParams(globalThis.location?.search || '');
  if (params.has('noSfx') || params.has('muteSfx') || params.has('noAudio') || params.has('muteAudio')) return true;
  if (isAutomationBrowser() || isLocalPreviewHost()) return true;

  const preference = readSettingsPreference();
  if (typeof preference.sfxEnabled === 'boolean') return !preference.sfxEnabled;
  return false;
}

function shouldForceSoundEffects() {
  return isAudioExplicitlyEnabled()
    || isParamEnabled('sfx', 'sound', 'effects')
    || Boolean(globalThis.__IDLEZ_PHASER_ENABLE_SFX__ || globalThis.__MUSHROOMER_PHASER_ENABLE_SFX__);
}

function isAudioExplicitlyEnabled() {
  if (globalThis.__IDLEZ_PHASER_ENABLE_AUDIO__ || globalThis.__MUSHROOMER_PHASER_ENABLE_AUDIO__) return true;
  return isParamEnabled('audio');
}

function isAudioExplicitlyDisabled() {
  if (globalThis.__IDLEZ_PHASER_DISABLE_AUDIO__ || globalThis.__MUSHROOMER_PHASER_DISABLE_AUDIO__) return true;
  const params = new URLSearchParams(globalThis.location?.search || '');
  return isParamDisabled('audio') || params.has('noAudio') || params.has('muteAudio');
}

function isParamEnabled(...keys) {
  const params = new URLSearchParams(globalThis.location?.search || '');
  return keys.some(key => ENABLE_AUDIO_VALUES.has(normalizeParam(params.get(key))));
}

function isParamDisabled(...keys) {
  const params = new URLSearchParams(globalThis.location?.search || '');
  return keys.some(key => DISABLE_AUDIO_VALUES.has(normalizeParam(params.get(key))));
}

function normalizeParam(value) {
  return String(value || '').trim().toLowerCase();
}

function toCssColor(color) {
  if (!Number.isFinite(color)) return null;
  return `#${color.toString(16).padStart(6, '0')}`;
}

function isAutomationBrowser() {
  const nav = globalThis.navigator;
  const ua = nav?.userAgent || '';
  return Boolean(nav?.webdriver) || /HeadlessChrome|Playwright|Puppeteer|Codex/i.test(ua);
}

function isLocalPreviewHost() {
  const { hostname, protocol } = globalThis.location || {};
  return protocol === 'file:'
    || hostname === 'localhost'
    || hostname === '127.0.0.1'
    || hostname === '::1'
    || hostname?.endsWith('.local');
}

export class IdlezPhaserScene extends PhaserScene {
  constructor() {
    super('IdlezPhaserScene');
    const backgroundMusicSuppressed = shouldSuppressBackgroundMusic();
    const soundEffectsSuppressed = shouldSuppressSoundEffects();
    const soundEffectsForced = shouldForceSoundEffects();
    const initialSettings = resolveSettings({
      defaultBgmEnabled: !backgroundMusicSuppressed,
      defaultSfxEnabled: !soundEffectsSuppressed,
    });
    this.unitViews = new Map();
    this.backgroundMusic = null;
    this.backgroundMusicStarted = false;
    this.backgroundMusicSuppressed = backgroundMusicSuppressed;
    this.sfxEnabled = soundEffectsForced || (!soundEffectsSuppressed && initialSettings.sfxEnabled);
    this.language = initialSettings.language;
    this.sfxLastPlayedAt = new Map();
    this.skillImpactFxSeen = new Map();
    this.mapArtObjects = [];
    this.currentBackgroundKey = null;
  }

  preload() {
    const loadedMapImages = new Set();
    for (const background of Object.values(MAP_BACKGROUNDS)) {
      for (const layer of background.layers || []) {
        if (loadedMapImages.has(layer.key)) continue;
        loadedMapImages.add(layer.key);
        this.load.image(layer.key, layer.path);
      }
    }
    this.load.image(SPLASH_KEY, SPLASH_PATH);
    this.load.audio(BGM_KEY, [BGM_PATH]);
    for (const def of Object.values(SFX_DEFS)) {
      this.load.audio(def.key, [def.path]);
    }
  }

  create() {
    const context = globalThis.__MUSHROOMER_PHASER_CONTEXT__ || globalThis.__IDLEZ_PHASER_CONTEXT__;
    if (!context?.board || !context?.store) {
      throw new Error('Phaser context was not initialized before scene create');
    }
    this.board = context.board;
    this.store = context.store;
    this.spineLayer = context.spineLayer;
    applyLanguagePreference(this.language);
    this.#installAudioApi(context);
    this.#startBackgroundMusic();

    this.#redrawMapArt();
    this.#bindBoardEvents();
    this.#showOpeningSplash();

    globalThis.dispatchEvent(new CustomEvent('mushroomer-phaser-ready'));
  }

  #installAudioApi(context) {
    const scene = this;
    const api = {
      get bgmEnabled() {
        return !scene.backgroundMusicSuppressed;
      },
      get sfxEnabled() {
        return scene.sfxEnabled;
      },
      get language() {
        return scene.language;
      },
      getSettings: () => ({
        ...resolveSettings({ defaultBgmEnabled: !scene.backgroundMusicSuppressed }),
        bgmEnabled: !scene.backgroundMusicSuppressed,
        sfxEnabled: scene.sfxEnabled,
        language: scene.language,
      }),
      setBgmEnabled: enabled => scene.#setBgmEnabled(enabled),
      setSfxEnabled: enabled => scene.#setSfxEnabled(enabled),
      setLanguage: language => scene.#setLanguage(language),
      play: (name, options = {}) => scene.#playSfx(name, options),
      playSfx: (name, options = {}) => scene.#playSfx(name, options),
    };

    context.audio = api;
    context.playSfx = api.play;
    globalThis.__MUSHROOMER_PHASER_AUDIO__ = api;
    globalThis.__IDLEZ_PHASER_AUDIO__ = api;
  }

  #startBackgroundMusic() {
    this.#syncBackgroundMusic();
  }

  #syncBackgroundMusic() {
    this.#applyAudioDataset();
    if (this.backgroundMusicSuppressed) {
      if (this.backgroundMusic?.isPlaying) {
        if (typeof this.backgroundMusic.pause === 'function') this.backgroundMusic.pause();
        else this.backgroundMusic.stop?.();
      }
      this.backgroundMusicStarted = false;
      return;
    }
    if (!this.sound) return;

    const play = () => {
      if (this.backgroundMusicSuppressed || this.backgroundMusicStarted || this.sound.locked) return;

      try {
        if (!this.backgroundMusic) {
          this.backgroundMusic = this.sound.add(BGM_KEY, {
            loop: true,
            volume: 0.42,
          });
        }
        if (this.backgroundMusic.isPaused && typeof this.backgroundMusic.resume === 'function') {
          this.backgroundMusic.resume();
          this.backgroundMusicStarted = true;
        } else {
          this.backgroundMusicStarted = this.backgroundMusic.play();
        }
      } catch (error) {
        console.warn('[IdlezPhaserScene] Failed to start background music', error);
      }
    };

    if (this.sound.locked) {
      this.sound.once('unlocked', play);
      this.input.once('pointerdown', play);
      this.input.keyboard?.once('keydown', play);
      return;
    }

    play();
  }

  #setBgmEnabled(enabled) {
    const next = Boolean(enabled);
    this.backgroundMusicSuppressed = !next;
    const settings = saveSettings({
      bgmEnabled: next,
      sfxEnabled: this.sfxEnabled,
      language: this.language,
    }, { defaultBgmEnabled: next });
    this.#syncBackgroundMusic();
    return settings;
  }

  #setSfxEnabled(enabled) {
    this.sfxEnabled = Boolean(enabled);
    this.#applyAudioDataset();
    return saveSettings({
      bgmEnabled: !this.backgroundMusicSuppressed,
      sfxEnabled: this.sfxEnabled,
      language: this.language,
    }, { defaultBgmEnabled: !this.backgroundMusicSuppressed });
  }

  #setLanguage(language) {
    const settings = saveSettings({
      bgmEnabled: !this.backgroundMusicSuppressed,
      sfxEnabled: this.sfxEnabled,
      language,
    }, { defaultBgmEnabled: !this.backgroundMusicSuppressed });
    this.language = settings.language;
    return settings;
  }

  #applyAudioDataset() {
    const root = document.documentElement;
    root.dataset.bgm = this.backgroundMusicSuppressed ? 'off' : 'on';
    root.dataset.sfx = this.sfxEnabled ? 'on' : 'off';
  }

  update(_time, delta) {
    if (!this.board) return;
    this.board.step(delta);
    this.#syncUnits();
  }

  #bindBoardEvents() {
    this.board.on('boardStarted', () => {
      this.#clearUnitViews();
      this.#redrawMapArt();
    });
    this.board.on('unitSpawned', unit => this.#createUnitView(unit));
    this.board.on('unitAttack', event => this.#playAttackSfx(event));
    this.board.on('unitDamaged', event => {
      this.#showSkillImpactFx(event);
      this.#showDamage(event);
      this.#playHitSfx(event);
    });
    this.board.on('unitDied', ({ unit }) => {
      this.#playDeathSfx(unit);
      if (unit.team === TEAM.PLAYER) this.#markPlayerDefeated(unit);
      else this.#removeUnitView(unit);
    });
    this.board.on('unitRevived', unit => this.#markPlayerRevived(unit));
    this.board.on('skillSpawned', skill => this.#showSkillCastFx(skill));
    this.board.on('skillFx', ({ skill }) => this.#showSkillFx(skill));
    this.board.on('itemGained', event => {
      this.#showDropBurst(event);
      this.#playLootSfx(event);
    });
    this.board.on('itemLevelUp', () => this.#playSfx('levelUp'));
    this.board.on('warning', () => this.#playSfx('uiError'));
    this.board.on('waveStarted', () => this.cameras.main.shake(120, 0.003));
    this.board.on('gameEnded', () => this.#showBanner('CLEAR'));
  }

  #playAttackSfx({ unit } = {}) {
    if (!unit) return;
    this.#playSfx('attack', {
      volume: unit.team === TEAM.PLAYER ? 1 : 0.68,
      rate: unit.team === TEAM.PLAYER ? 1 : 0.9,
    });
  }

  #playHitSfx({ unit, damage } = {}) {
    if (!unit || damage <= 0) return;
    this.#playSfx('hit', {
      volume: unit.team === TEAM.PLAYER ? 0.72 : 1,
      rate: unit.team === TEAM.PLAYER ? 0.86 : 1,
      detune: unit.team === TEAM.PLAYER ? -120 : 0,
    });
  }

  #playDeathSfx(unit) {
    if (!unit) return;
    if (unit.team === TEAM.PLAYER) {
      this.#playSfx('uiError', { volume: 0.72 });
      return;
    }
    this.#playSfx('monsterDead');
  }

  #playLootSfx({ itemDataId, item } = {}) {
    const id = Number(itemDataId ?? item?.id);
    if (id === 5 || id === 6) {
      this.#playSfx('coin');
      return;
    }
    this.#playSfx('reward');
  }

  #playSfx(name, options = {}) {
    const def = SFX_DEFS[name];
    if (!def || !this.sound) return false;
    if (!this.sfxEnabled) return false;

    if (this.sound.locked) {
      this.sound.unlock?.();
      if (this.sound.locked) return false;
    }

    const now = this.time?.now ?? performance.now();
    const cooldownMs = options.cooldownMs ?? def.cooldownMs ?? 0;
    const lastPlayedAt = this.sfxLastPlayedAt.get(def.key) ?? -Infinity;
    if (cooldownMs > 0 && now - lastPlayedAt < cooldownMs) return false;

    this.sfxLastPlayedAt.set(def.key, now);
    try {
      return this.sound.play(def.key, {
        volume: clamp((def.volume ?? 1) * (options.volume ?? 1), 0, 1),
        rate: options.rate ?? 1,
        detune: options.detune ?? 0,
      });
    } catch (error) {
      console.warn(`[IdlezPhaserScene] Failed to play SFX: ${name}`, error);
      return false;
    }
  }

  #showOpeningSplash() {
    const width = this.scale.width;
    const height = this.scale.height;
    const layer = this.add.container(0, 0).setDepth(2600).setAlpha(0);
    const combatShell = document.querySelector('.combat-shell');
    combatShell?.classList.add('is-splashing');

    const source = this.textures.get(SPLASH_KEY)?.getSourceImage?.();
    const sourceWidth = source?.width || 3072;
    const sourceHeight = source?.height || 2048;
    const artScale = Math.max(width / sourceWidth, height / sourceHeight);
    const art = this.add.image(width / 2, height / 2, SPLASH_KEY)
      .setOrigin(0.5)
      .setScale(artScale);

    const shade = this.add.graphics();
    shade.fillStyle(0x07140d, 0.22);
    shade.fillRect(0, 0, width, height);
    shade.fillStyle(0x07140d, 0.5);
    shade.fillRect(0, height * 0.72, width, height * 0.28);

    const title = this.add.text(width / 2, height * 0.28, 'MUSHROOMER', {
      fontFamily: 'system-ui, -apple-system, sans-serif',
      fontSize: '54px',
      fontStyle: 'bold',
      color: '#fff7dd',
      stroke: '#2b1206',
      strokeThickness: 10,
    }).setOrigin(0.5);
    const sparkle = this.add.text(width / 2, height * 0.78, 'ADVENTURE BEGINS', {
      fontFamily: 'system-ui, -apple-system, sans-serif',
      fontSize: '22px',
      fontStyle: 'bold',
      color: '#ffe36a',
      stroke: '#2b1206',
      strokeThickness: 5,
      letterSpacing: 0,
    }).setOrigin(0.5);

    layer.add([art, shade, title, sparkle]);
    layer.setSize(width, height);
    layer.setInteractive(new Phaser.Geom.Rectangle(0, 0, width, height), Phaser.Geom.Rectangle.Contains);

    let dismissing = false;
    const dismiss = () => {
      if (dismissing || !layer.active) return;
      dismissing = true;
      combatShell?.classList.remove('is-splashing');
      layer.disableInteractive();
      this.tweens.add({
        targets: layer,
        alpha: 0,
        duration: 520,
        ease: 'Cubic.easeInOut',
        onComplete: () => layer.destroy(),
      });
    };

    layer.once('pointerdown', dismiss);
    this.tweens.add({ targets: layer, alpha: 1, duration: 260, ease: 'Cubic.easeOut' });
    globalThis.setTimeout(dismiss, SPLASH_DISPLAY_MS);
  }

  #redrawMapArt() {
    this.#destroyMapArt();
    const background = this.#currentBackgroundDef();
    this.#syncMapBackdrop(background);
    this.#drawBackground(background);
    this.#drawGardenDetails(background);
    this.#drawBattleLane(background);
  }

  #destroyMapArt() {
    for (const object of this.mapArtObjects) object.destroy?.();
    this.mapArtObjects = [];
  }

  #trackMapArt(object) {
    this.mapArtObjects.push(object);
    return object;
  }

  #currentBackgroundDef() {
    const requestedKey = this.board?.map?.popupArgs?.ClientPhaserBackground || 'meadow_day';
    const key = MAP_BACKGROUNDS[requestedKey] ? requestedKey : 'meadow_day';
    this.currentBackgroundKey = key;
    return MAP_BACKGROUNDS[key];
  }

  #syncMapBackdrop(background) {
    const root = document.querySelector('.app');
    if (!root) return;

    const skyLayer = (background.layers || []).find(layer =>
      layer.key === background.backdrop?.skyLayerKey || layer.role === 'sky'
    );
    root.style.setProperty('--map-sky-color', background.backdrop?.color || toCssColor(background.colors?.[0]?.color) || '#a3df9b');
    root.style.setProperty('--map-sky-image', skyLayer?.path ? `url("${skyLayer.path}")` : 'none');
  }

  #drawBackground(background = this.#currentBackgroundDef()) {
    const width = this.scale.width;
    const height = this.scale.height;

    const sky = this.#trackMapArt(this.add.graphics().setDepth(-55));
    for (const band of background.colors || MAP_BACKGROUNDS.meadow_day.colors) {
      sky.fillStyle(band.color, 1);
      sky.fillRect(0, height * band.from, width, height * (band.to - band.from));
    }

    for (const layer of background.layers || []) {
      this.#drawBackgroundLayer(layer, width, height);
    }
  }

  #drawBackgroundLayer(layer, width, height) {
    if (!this.textures.exists(layer.key)) return null;

    const image = this.#trackMapArt(this.add.image(
      width * (layer.x ?? 0.5) + (layer.offsetX || 0),
      height * (layer.y ?? 0.5) + (layer.offsetY || 0),
      layer.key,
    ));
    image.setOrigin(layer.originX ?? 0.5, layer.originY ?? 0.5);
    image.setDepth(layer.depth ?? -20);

    const source = this.textures.get(layer.key)?.getSourceImage?.();
    const sourceWidth = source?.width || 1;
    const sourceHeight = source?.height || 1;
    if (layer.mode === 'cover') {
      const targetW = width * (layer.widthScale || 1);
      const targetH = height * (layer.heightScale || 1);
      const scale = Math.max(targetW / sourceWidth, targetH / sourceHeight) * (layer.scale || 1);
      image.setDisplaySize(sourceWidth * scale, sourceHeight * scale);
      return image;
    }

    const displayWidth = width * (layer.widthScale || 1);
    const displayHeight = displayWidth * (sourceHeight / sourceWidth) * (layer.heightScale || 1);
    image.setDisplaySize(displayWidth, displayHeight);
    return image;
  }

  #drawGardenDetails(background = this.#currentBackgroundDef()) {
    if (background.details !== 'garden') return;

    const g = this.#trackMapArt(this.add.graphics().setDepth(-6));

    this.#drawBush(g, 96, 520, 1.2, 0x80bd50);
    this.#drawBush(g, 790, 532, 1.05, 0x77b94c);
    this.#drawBush(g, 565, 536, 0.9, 0x6aa946);
    this.#drawMushroom(g, 306, 516, 0.8, 0xd85f45);
    this.#drawMushroom(g, 704, 504, 1.0, 0xf09b3a);
    this.#drawMushroom(g, 818, 480, 0.78, 0xc45050);
    this.#drawMushroom(g, 346, 530, 0.65, 0x7fbf56);

    g.lineStyle(5, 0x8c6936, 0.42);
    g.beginPath();
    g.moveTo(42, 516);
    g.lineTo(270, 500);
    g.moveTo(642, 512);
    g.lineTo(900, 494);
    g.strokePath();

    for (const [x, y, color] of [
      [40, 560, 0xf8e7a1], [74, 548, 0xffb66c], [326, 560, 0xf8e7a1],
      [474, 548, 0xffd36a], [618, 558, 0xf5a0b8], [860, 546, 0xffd36a],
    ]) {
      this.#drawFlower(g, x, y, color);
    }
  }

  #drawBush(g, x, y, scale, color) {
    g.fillStyle(0x3f7c38, 0.36);
    g.fillEllipse(x, y + 14 * scale, 138 * scale, 44 * scale);
    g.fillStyle(color, 0.9);
    for (let i = 0; i < 6; i += 1) {
      const cx = x - 58 * scale + i * 23 * scale;
      g.fillCircle(cx, y - Math.sin(i) * 6 * scale, 24 * scale);
    }
    g.fillRoundedRect(x - 66 * scale, y - 4 * scale, 132 * scale, 34 * scale, 14 * scale);
  }

  #drawMushroom(g, x, y, scale, capColor) {
    g.fillStyle(0x7f5b35, 0.35);
    g.fillEllipse(x, y + 47 * scale, 82 * scale, 18 * scale);
    g.fillStyle(0xf6dca4, 0.94);
    g.fillRoundedRect(x - 18 * scale, y + 3 * scale, 36 * scale, 47 * scale, 14 * scale);
    g.fillStyle(0x6f3b22, 0.5);
    g.fillRect(x - 16 * scale, y + 39 * scale, 32 * scale, 7 * scale);
    g.fillStyle(capColor, 0.95);
    g.fillEllipse(x, y, 96 * scale, 58 * scale);
    g.fillRect(x - 42 * scale, y - 3 * scale, 84 * scale, 16 * scale);
    g.fillStyle(0xffedc7, 0.92);
    g.fillCircle(x - 20 * scale, y - 10 * scale, 8 * scale);
    g.fillCircle(x + 14 * scale, y - 16 * scale, 6 * scale);
    g.fillCircle(x + 28 * scale, y + 4 * scale, 5 * scale);
    g.lineStyle(3 * scale, 0x4c2a18, 0.45);
    g.strokeEllipse(x, y, 96 * scale, 58 * scale);
  }

  #drawFlower(g, x, y, color) {
    g.lineStyle(2, 0x4f8a3b, 0.72);
    g.beginPath();
    g.moveTo(x, y + 12);
    g.lineTo(x, y - 4);
    g.strokePath();
    g.fillStyle(color, 0.95);
    for (let i = 0; i < 5; i += 1) {
      const a = (Math.PI * 2 * i) / 5;
      g.fillCircle(x + Math.cos(a) * 5, y - 6 + Math.sin(a) * 5, 4);
    }
    g.fillStyle(0xf7c849, 1);
    g.fillCircle(x, y - 6, 3);
  }

  #drawBattleLane(background = this.#currentBackgroundDef()) {
    const width = this.scale.width;
    const laneY = 580;
    const laneH = 205;
    const lane = background.lane || {};
    const g = this.#trackMapArt(this.add.graphics().setDepth(4));

    g.fillStyle(lane.shadow || 0x5f351d, 0.45);
    g.fillRoundedRect(-34, laneY + 18, width + 68, laneH + 42, 22);

    g.fillStyle(lane.base || 0x7f4a27, 1);
    g.fillRoundedRect(-28, laneY, width + 56, laneH, 18);
    g.fillStyle(lane.top || 0xb87939, 1);
    g.fillRoundedRect(-22, laneY + 8, width + 44, laneH - 22, 14);
    g.fillStyle(lane.dark || 0x8e552c, 1);
    g.fillRect(-22, laneY + laneH - 22, width + 44, 18);

    for (let x = -10; x < width + 80; x += 92) {
      const shade = x % 184 === 0 ? (lane.plankA || 0x9f6333) : (lane.plankB || 0xc48743);
      g.lineStyle(3, lane.trim || 0x573019, 0.68);
      g.beginPath();
      g.moveTo(x, laneY + 10);
      g.lineTo(x + 16, laneY + laneH - 18);
      g.strokePath();
      g.fillStyle(shade, 0.22);
      g.fillRoundedRect(x + 8, laneY + 14, 70, laneH - 36, 9);
      g.fillStyle(lane.trim || 0x4b2a17, 0.35);
      g.fillCircle(x + 24, laneY + 36, 4);
      g.fillCircle(x + 62, laneY + laneH - 42, 4);
    }

    g.lineStyle(4, lane.trim || 0x3f2414, 0.75);
    g.beginPath();
    g.moveTo(-24, laneY + 12);
    g.lineTo(width + 24, laneY + 8);
    g.moveTo(-24, laneY + laneH - 20);
    g.lineTo(width + 24, laneY + laneH - 18);
    g.strokePath();

    for (const x of [48, 176, 744, 874]) {
      g.fillStyle(lane.base || 0x7a4525, 1);
      g.fillRoundedRect(x - 17, laneY - 12, 34, 52, 12);
      g.fillStyle(lane.top || 0xb98345, 1);
      g.fillEllipse(x, laneY - 12, 38, 16);
      g.lineStyle(2, lane.trim || 0x4b2a17, 0.75);
      g.strokeEllipse(x, laneY - 12, 38, 16);
    }

    const grass = this.#trackMapArt(this.add.graphics().setDepth(5));
    for (let x = 0; x < width; x += 34) {
      grass.fillStyle(x % 68 === 0 ? (lane.grassA || 0x63b741) : (lane.grassB || 0x7bd150), 0.95);
      grass.fillTriangle(x, laneY + 2, x + 9, laneY - 12, x + 18, laneY + 2);
    }
  }

  #createUnitView(unit) {
    if (this.unitViews.has(unit.id)) return;

    const hpBar = this.add.graphics().setDepth(1000);
    const label = this.add.text(unit.x, unit.y + 12, formatNumber(unit.hp), {
      fontFamily: 'system-ui, -apple-system, sans-serif',
      fontSize: unit.type === 'Boss' ? '16px' : '13px',
      fontStyle: 'bold',
      color: '#fff7dd',
      stroke: '#101814',
      strokeThickness: 4,
    }).setOrigin(0.5, 1).setDepth(1001);

    this.unitViews.set(unit.id, { hpBar, label });
    this.#updateUnitView(unit);
  }

  #syncUnits() {
    for (const unit of this.board.units.values()) {
      if (!unit.alive) continue;
      if (!this.unitViews.has(unit.id)) this.#createUnitView(unit);
      this.#updateUnitView(unit);
    }
  }

  #updateUnitView(unit) {
    const view = this.unitViews.get(unit.id);
    if (!view) return;

    const hp = this.#hpBarMetrics(unit);
    view.label
      .setText(formatNumber(unit.hp))
      .setPosition(unit.x, hp.y - 8)
      .setDepth(unit.y + 2);
    view.hpBar.setDepth(unit.y + 1);
    this.#drawHpBar(unit, view, hp);
  }

  #drawHpBar(unit, view, metrics = this.#hpBarMetrics(unit)) {
    const { width, height, x, y, pct, color } = metrics;

    view.hpBar.clear();
    view.hpBar.fillStyle(0x07100c, 0.78);
    view.hpBar.fillRoundedRect(x - 2, y - 2, width + 4, height + 4, 4);
    view.hpBar.fillStyle(color, 1);
    view.hpBar.fillRoundedRect(x, y, width * pct, height, 3);
    view.hpBar.lineStyle(1, 0xffffff, 0.25);
    view.hpBar.strokeRoundedRect(x - 2, y - 2, width + 4, height + 4, 4);
  }

  #hpBarMetrics(unit) {
    const width = unit.type === 'Boss' ? 94 : unit.team === TEAM.PLAYER ? 72 : 58;
    const height = unit.type === 'Boss' ? 8 : 6;
    const bounds = this.spineLayer?.getUnitWorldBounds?.(unit);
    const top = Number.isFinite(bounds?.top)
      ? bounds.top
      : unit.y - (unit.type === 'Boss' ? 124 : unit.team === TEAM.PLAYER ? 64 : 58);
    const gap = unit.type === 'Boss' ? 5 : 4;
    const x = unit.x - width / 2;
    const y = Math.round(top - height - gap);
    const pct = clamp(unit.hp / unit.maxHp, 0, 1);
    const color = unit.team === TEAM.PLAYER ? 0x36d399 : pct < 0.3 ? 0xf97316 : 0xef4444;
    return { width, height, x, y, pct, color };
  }

  #removeUnitView(unit) {
    const view = this.unitViews.get(unit.id);
    if (!view) return;
    this.unitViews.delete(unit.id);

    this.tweens.add({
      targets: [view.label],
      alpha: 0,
      y: '-=24',
      duration: 420,
      ease: 'Cubic.easeOut',
      onComplete: () => {
        view.label.destroy();
        view.hpBar.destroy();
      },
    });
  }

  #clearUnitViews() {
    for (const view of this.unitViews.values()) {
      view.label.destroy();
      view.hpBar.destroy();
    }
    this.unitViews.clear();
  }

  #showDamage({ unit, damage }) {
    const view = this.unitViews.get(unit.id);
    if (!view) return;

    this.#updateUnitView(unit);
    this.#floatText(unit.x, unit.y - 92, `-${formatNumber(damage)}`, unit.team === TEAM.PLAYER ? '#ffb4a8' : '#ff7a1a');
  }

  #markPlayerDefeated(unit) {
    const view = this.unitViews.get(unit.id);
    if (!view) return;
    this.#updateUnitView(unit);
    view.label.setAlpha(0.42);
    view.hpBar.setAlpha(0.42);
    this.#floatText(unit.x, unit.y - 122, 'DOWN', '#ffb4a8');
  }

  #markPlayerRevived(unit) {
    if (!this.unitViews.has(unit.id)) this.#createUnitView(unit);
    const view = this.unitViews.get(unit.id);
    view.label.setAlpha(1);
    view.hpBar.setAlpha(1);
    this.#floatText(unit.x, unit.y - 122, 'REVIVE', '#82f6ac');
    this.#updateUnitView(unit);
  }

  #showSkillFx(skill) {
    const target = skill.targets.find(unit => unit.alive) || skill.targets[0];
    if (!target) return;

    this.#showSkillImpactFx({ unit: target, skill, force: true });
  }

  #showSkillCastFx(skill) {
    if (!skill?.owner) return;

    const target = skill.targets.find(unit => unit.alive) || skill.targets[0];
    const effect = this.#skillEffect(skill);
    const origin = this.#unitFxPoint(skill.owner);
    const destination = target ? this.#unitFxPoint(target) : origin;

    this.#drawCastFlareFx(origin.x, origin.y, effect);

    if (effect.cast === 'aura' || effect.cast === 'rage' || effect.cast === 'ultimate') {
      this.#drawAuraFx(origin.x, origin.y, effect, (effect.cast === 'ultimate' ? 82 : 56) * SKILL_FX_CAST_MULTIPLIER);
      if (effect.cast === 'rage') this.#drawCheekPulseFx(origin.x, origin.y, effect, 42 * SKILL_FX_CAST_MULTIPLIER);
      if (effect.cast === 'ultimate') this.#drawGoldenOrbitFx(origin.x, origin.y, effect, 74 * SKILL_FX_CAST_MULTIPLIER);
      return;
    }

    if (effect.cast === 'rune') {
      this.#drawRuneFx(origin.x, origin.y, effect, 54 * SKILL_FX_CAST_MULTIPLIER);
      this.#drawMoonCrescentFx(origin.x, origin.y, effect, 48 * SKILL_FX_CAST_MULTIPLIER);
      this.#drawTravelFx(origin, destination, effect, { arcs: 2, sparks: 5 });
      return;
    }

    if (effect.cast === 'rain') {
      this.#drawRainCueFx(destination.x, destination.y, effect);
      return;
    }

    if (effect.cast === 'meteor') {
      this.#drawMeteorCueFx(destination.x, destination.y, effect);
      return;
    }

    if (effect.cast === 'spiral') {
      this.#drawSpiralFx(origin.x, origin.y, effect, 48 * SKILL_FX_CAST_MULTIPLIER);
      this.#drawWheelGlyphFx(origin.x, origin.y, effect, 42 * SKILL_FX_CAST_MULTIPLIER);
      this.#drawTravelFx(origin, destination, effect, { arcs: 1, sparks: 4 });
      return;
    }

    this.#drawTravelFx(origin, destination, effect, {
      arcs: effect.cast === 'dash' ? 1 : 0,
      sparks: effect.cast === 'lob' ? 7 : 4,
      heavy: effect.cast === 'dash',
      motif: effect.cast === 'seed' ? 'seed' : effect.cast === 'lob' ? 'bubble' : 'spark',
    });
  }

  #showSkillImpactFx({ unit, skill, force = false } = {}) {
    if (!unit || !skill) return;

    const effect = this.#skillEffect(skill);
    const tags = skill.def?.tags || [];
    const isArea = force || tags.includes('AoE') || tags.includes('Ultimate') || [
      'cheekBurst',
      'wheelWhirl',
      'moonWheel',
      'sawdustRain',
      'starCandyMeteor',
      'hamsterStampede',
      'goldCheekUltimate',
    ].includes(effect.kind);
    if (isArea && !force && !this.#claimSkillImpactFx(skill)) return;

    const point = this.#unitFxPoint(unit);
    const radius = this.#skillRadius(skill, effect);

    if (effect.shake) {
      this.cameras.main.shake(110, effect.shake);
    }

    switch (effect.kind) {
      case 'cheekBurst':
        this.#drawCheekBurstFx(point.x, point.y, effect, radius);
        break;
      case 'toothSlam':
        this.#drawToothSlamFx(point.x, point.y, effect, radius);
        break;
      case 'nutCrush':
        this.#drawSlamFx(point.x, point.y, effect, radius);
        this.#drawMoteBurstFx(point.x, point.y, effect, { count: 14, radius: radius * 0.92, shape: 'shard' });
        break;
      case 'cheekRage':
        this.#drawSlamFx(point.x, point.y, effect, radius);
        this.#drawCheekPulseFx(point.x, point.y, effect, radius * 0.55);
        this.#drawMoteBurstFx(point.x, point.y, effect, { count: 10, radius: radius * 0.84, shape: 'spark' });
        break;
      case 'snackAwakening':
        this.#drawSnackAwakeningFx(skill.owner.x, skill.owner.y - 62, effect, radius * 0.78);
        break;
      case 'wheelWhirl':
        this.#drawWheelWhirlFx(point.x, point.y, effect, radius);
        break;
      case 'moonWheel':
        this.#drawRuneFx(point.x, point.y, effect, radius);
        this.#drawMoonCrescentFx(point.x, point.y, effect, radius * 0.82);
        this.#drawMoteBurstFx(point.x, point.y, effect, { count: 12, radius, shape: 'spark' });
        break;
      case 'sawdustRain':
        this.#drawSawdustRainFx(point.x, point.y, effect, radius);
        break;
      case 'starCandyMeteor':
        this.#drawStarCandyMeteorFx(point.x, point.y, effect, radius);
        break;
      case 'hamsterStampede':
        this.#drawHamsterStampedeFx(point.x, point.y, effect, radius);
        break;
      case 'goldCheekUltimate':
        this.#drawGoldCheekUltimateFx(point.x, point.y, effect, radius);
        break;
      case 'seedPop':
        this.#drawSeedPopFx(point.x, point.y, effect, radius);
        break;
      default:
        this.#drawBurstFx(point.x, point.y, effect, radius, { spores: 7, rings: 1 });
        this.#drawMoteBurstFx(point.x, point.y, effect, { count: 8, radius, shape: 'seed' });
        break;
    }
  }

  #claimSkillImpactFx(skill) {
    const key = `${skill.id}:${this.board?.tick || 0}`;
    if (this.skillImpactFxSeen.has(key)) return false;
    this.skillImpactFxSeen.set(key, true);
    if (this.skillImpactFxSeen.size > 256) this.skillImpactFxSeen.clear();
    return true;
  }

  #skillEffect(skill) {
    const byId = SKILL_EFFECTS[Number(skill?.dataId ?? skill?.def?.id)];
    if (byId) return byId;

    const tags = skill?.def?.tags || [];
    if (tags.includes('Ultimate')) return SKILL_EFFECTS[300112];
    if (tags.includes('Boss')) return SKILL_EFFECTS[300103];
    if (tags.includes('Buff') || tags.includes('Self')) return SKILL_EFFECTS[300104];
    if (tags.includes('AoE')) return SKILL_EFFECTS[300102];
    return DEFAULT_SKILL_EFFECT;
  }

  #skillRadius(skill, effect) {
    const radii = [];
    for (const timeline of skill?.def?.timelines || []) {
      for (const geometry of timeline.hit?.geometries || []) {
        const radius = Number(geometry.circle?.radius);
        if (Number.isFinite(radius)) radii.push(radius);
      }
    }
    const worldRadius = Math.max(1.8, ...radii);
    return clamp(worldRadius * 18 * (effect.radiusScale || 1) * SKILL_FX_RADIUS_MULTIPLIER, 58, 260);
  }

  #unitFxPoint(unit) {
    return { x: unit.x, y: unit.y - (unit.type === 'Boss' ? 78 : 58) };
  }

  #fxLayer(x, y, depth = 1400, { additive = false } = {}) {
    const layer = this.add.container(x, y).setDepth(depth);
    if (additive) layer.setBlendMode?.(globalThis.Phaser?.BlendModes?.ADD ?? 'ADD');
    return layer;
  }

  #drawTravelFx(origin, destination, effect, { arcs = 0, sparks = 4, heavy = false, motif = 'spark' } = {}) {
    const layer = this.#fxLayer(0, 0, 1350, { additive: true });
    const g = this.add.graphics();
    layer.add(g);
    const stroke = SKILL_FX_STROKE_MULTIPLIER;

    g.lineStyle((heavy ? 11 : 7) * stroke, effect.accent, heavy ? 0.24 : 0.2);
    g.beginPath();
    g.moveTo(origin.x, origin.y);
    const midX = (origin.x + destination.x) / 2;
    const midY = (origin.y + destination.y) / 2 - (heavy ? 8 : 32);
    g.lineTo(midX, midY);
    g.lineTo(destination.x, destination.y);
    g.strokePath();

    g.lineStyle((heavy ? 6 : 3) * stroke, effect.primary, 0.88);
    g.beginPath();
    g.moveTo(origin.x, origin.y);
    g.lineTo(midX, midY);
    g.lineTo(destination.x, destination.y);
    g.strokePath();

    g.lineStyle((heavy ? 2 : 1) * stroke, effect.tertiary || 0xffffff, 0.74);
    g.beginPath();
    g.moveTo(origin.x, origin.y - 3);
    g.lineTo(midX, midY - 5);
    g.lineTo(destination.x, destination.y - 3);
    g.strokePath();

    if (arcs > 0) {
      g.lineStyle(2 * stroke, effect.secondary, 0.62);
      for (let i = 0; i < arcs; i += 1) {
        const offset = (i - (arcs - 1) / 2) * 14;
        g.beginPath();
        g.moveTo(origin.x, origin.y + offset);
        g.lineTo(midX, midY + offset - 18);
        g.lineTo(destination.x, destination.y + offset);
        g.strokePath();
      }
    }

    for (let i = 0; i < sparks; i += 1) {
      const t = (i + 1) / (sparks + 1);
      const x = origin.x + (destination.x - origin.x) * t;
      const y = origin.y + (destination.y - origin.y) * t - Math.sin(t * Math.PI) * 28;
      g.fillStyle(i % 2 ? effect.secondary : effect.primary, 0.9);
      g.fillCircle(x, y, (heavy ? 4 : 3) * SKILL_FX_MOTE_MULTIPLIER);
    }

    this.#drawTrailMotesFx(origin, destination, effect, { count: sparks + 2, shape: motif, heavy });

    this.tweens.add({
      targets: layer,
      alpha: 0,
      duration: heavy ? 180 : 260,
      ease: 'Cubic.easeOut',
      onComplete: () => layer.destroy(),
    });
  }

  #drawCastFlareFx(x, y, effect) {
    const layer = this.#fxLayer(x, y, 1365, { additive: true });
    const g = this.add.graphics();
    layer.add(g);
    const s = SKILL_FX_CAST_MULTIPLIER;

    g.lineStyle(3 * SKILL_FX_STROKE_MULTIPLIER, effect.primary, 0.76);
    g.strokeEllipse(0, 0, 46 * s, 20 * s);
    g.lineStyle(2 * SKILL_FX_STROKE_MULTIPLIER, effect.secondary, 0.64);
    g.strokeCircle(0, 0, 20 * s);
    g.fillStyle(effect.accent, 0.18);
    g.fillCircle(0, 0, 18 * s);

    const colors = [effect.primary, effect.secondary, effect.tertiary || 0xffffff];
    for (let i = 0; i < 6; i += 1) {
      const angle = Math.PI * 2 * i / 6;
      const px = Math.cos(angle) * 25 * s;
      const py = Math.sin(angle) * 13 * s;
      this.#drawMoteShape(g, i % 2 ? 'seed' : 'spark', px, py, 5, colors[i % colors.length], effect.accent, 0.86);
    }

    this.tweens.add({
      targets: layer,
      alpha: 0,
      scale: 1.34,
      angle: -12,
      duration: 260,
      ease: 'Cubic.easeOut',
      onComplete: () => layer.destroy(),
    });
  }

  #drawTrailMotesFx(origin, destination, effect, { count = 6, shape = 'spark', heavy = false } = {}) {
    const colors = [effect.primary, effect.secondary, effect.tertiary || 0xffffff, effect.accent];
    const total = Math.ceil(count * SKILL_FX_DENSITY_MULTIPLIER);
    for (let i = 0; i < total; i += 1) {
      const t = (i + 1) / (total + 1);
      const wave = Math.sin(t * Math.PI);
      const x = origin.x + (destination.x - origin.x) * t;
      const y = origin.y + (destination.y - origin.y) * t - wave * (heavy ? 14 : 30);
      const mote = this.add.graphics()
        .setPosition(x, y)
        .setDepth(1375);
      mote.setBlendMode?.(globalThis.Phaser?.BlendModes?.ADD ?? 'ADD');
      this.#drawMoteShape(mote, shape, 0, 0, heavy ? 7 : 5, colors[i % colors.length], effect.accent, 0.92);

      const drift = (i % 2 ? 1 : -1) * (10 + Math.random() * 18);
      this.tweens.add({
        targets: mote,
        x: x + drift,
        y: y - 8 - Math.random() * 18,
        alpha: 0,
        scale: 1.45,
        angle: (i % 2 ? 1 : -1) * (60 + Math.random() * 70),
        delay: i * 12,
        duration: heavy ? 260 : 360,
        ease: 'Cubic.easeOut',
        onComplete: () => mote.destroy(),
      });
    }
  }

  #drawMoteBurstFx(x, y, effect, {
    count = 12,
    radius = 64,
    shape = 'spark',
    duration = effect.duration,
    depth = 1460,
    spreadY = 0.72,
  } = {}) {
    const colors = [effect.primary, effect.secondary, effect.tertiary || 0xffffff, effect.accent];
    const total = Math.ceil(count * SKILL_FX_DENSITY_MULTIPLIER);
    for (let i = 0; i < total; i += 1) {
      const angle = Math.PI * 2 * i / total + Math.random() * 0.32;
      const dist = radius * (0.28 + Math.random() * 0.82);
      const mote = this.add.graphics()
        .setPosition(x, y)
        .setDepth(depth);
      mote.setBlendMode?.(globalThis.Phaser?.BlendModes?.ADD ?? 'ADD');
      this.#drawMoteShape(
        mote,
        shape,
        0,
        0,
        4 + Math.random() * 5,
        colors[i % colors.length],
        effect.accent,
        0.9,
      );

      this.tweens.add({
        targets: mote,
        x: x + Math.cos(angle) * dist,
        y: y + Math.sin(angle) * dist * spreadY,
        alpha: 0,
        scale: 1.1 + Math.random() * 0.55,
        angle: (Math.random() - 0.5) * 170,
        delay: i * 8,
        duration: duration * (0.72 + Math.random() * 0.36),
        ease: 'Cubic.easeOut',
        onComplete: () => mote.destroy(),
      });
    }
  }

  #drawMoteShape(g, shape, x, y, size, color, accent = 0xffffff, alpha = 0.9) {
    size *= SKILL_FX_MOTE_MULTIPLIER;

    if (shape === 'seed') {
      g.fillStyle(color, alpha);
      g.fillEllipse(x, y, size * 1.1, size * 1.7);
      g.lineStyle(Math.max(1, size * 0.16), accent, alpha * 0.5);
      g.strokeEllipse(x, y, size * 1.1, size * 1.7);
      return;
    }

    if (shape === 'bubble') {
      g.fillStyle(color, alpha * 0.28);
      g.fillCircle(x, y, size * 0.95);
      g.lineStyle(Math.max(1, size * 0.18), color, alpha);
      g.strokeCircle(x, y, size);
      g.fillStyle(accent, alpha * 0.72);
      g.fillCircle(x - size * 0.28, y - size * 0.28, size * 0.22);
      return;
    }

    if (shape === 'shard') {
      g.fillStyle(color, alpha);
      g.fillTriangle(x, y - size * 1.1, x + size * 0.72, y + size * 0.62, x - size * 0.64, y + size * 0.42);
      g.lineStyle(1, accent, alpha * 0.45);
      g.strokeTriangle(x, y - size * 1.1, x + size * 0.72, y + size * 0.62, x - size * 0.64, y + size * 0.42);
      return;
    }

    if (shape === 'flake') {
      g.lineStyle(Math.max(1, size * 0.22), color, alpha);
      g.beginPath();
      g.moveTo(x - size, y);
      g.lineTo(x + size, y);
      g.moveTo(x, y - size);
      g.lineTo(x, y + size);
      g.moveTo(x - size * 0.66, y - size * 0.66);
      g.lineTo(x + size * 0.66, y + size * 0.66);
      g.strokePath();
      return;
    }

    if (shape === 'coin') {
      g.fillStyle(color, alpha);
      g.fillCircle(x, y, size);
      g.lineStyle(Math.max(1, size * 0.16), accent, alpha * 0.62);
      g.strokeCircle(x, y, size * 0.76);
      return;
    }

    if (shape === 'paw') {
      g.fillStyle(color, alpha);
      g.fillEllipse(x, y + size * 0.18, size * 1.15, size * 0.86);
      for (let i = 0; i < 3; i += 1) {
        g.fillCircle(x + (i - 1) * size * 0.54, y - size * 0.54, size * 0.28);
      }
      return;
    }

    g.fillStyle(color, alpha);
    this.#drawStarShape(g, x, y, size, size * 0.42, shape === 'star' ? 5 : 4);
  }

  #drawStarShape(g, x, y, outer, inner = outer * 0.45, points = 5, rotation = -Math.PI / 2) {
    g.beginPath();
    for (let i = 0; i < points * 2; i += 1) {
      const radius = i % 2 === 0 ? outer : inner;
      const angle = rotation + Math.PI * i / points;
      const px = x + Math.cos(angle) * radius;
      const py = y + Math.sin(angle) * radius;
      if (i === 0) g.moveTo(px, py);
      else g.lineTo(px, py);
    }
    g.closePath();
    g.fillPath();
  }

  #drawSeedPopFx(x, y, effect, radius) {
    this.#drawBurstFx(x, y, effect, radius, { spores: 10, rings: 2 });
    this.#drawMoteBurstFx(x, y, effect, { count: 16, radius: radius * 0.94, shape: 'seed' });
    this.#drawMoteBurstFx(x, y, effect, { count: 8, radius: radius * 0.72, shape: 'spark', duration: effect.duration * 0.8 });
  }

  #drawCheekBurstFx(x, y, effect, radius) {
    const layer = this.#fxLayer(x, y, 1425, { additive: true });
    const g = this.add.graphics();
    layer.add(g);

    g.fillStyle(effect.primary, 0.26);
    g.fillEllipse(-radius * 0.24, 0, radius * 0.96, radius * 0.58);
    g.fillEllipse(radius * 0.24, 0, radius * 0.96, radius * 0.58);
    g.lineStyle(4, effect.primary, 0.72);
    g.strokeEllipse(-radius * 0.2, 0, radius * 0.9, radius * 0.54);
    g.lineStyle(4, effect.secondary, 0.72);
    g.strokeEllipse(radius * 0.2, 0, radius * 0.9, radius * 0.54);
    g.lineStyle(2, effect.tertiary || 0xffffff, 0.62);
    g.strokeCircle(0, 0, radius * 0.42);

    this.tweens.add({
      targets: layer,
      alpha: 0,
      scaleX: 1.44,
      scaleY: 1.18,
      duration: effect.duration,
      ease: 'Cubic.easeOut',
      onComplete: () => layer.destroy(),
    });

    this.#drawMoteBurstFx(x, y, effect, { count: 18, radius, shape: 'bubble' });
    this.#drawMoteBurstFx(x, y, effect, { count: 10, radius: radius * 0.82, shape: 'seed' });
  }

  #drawToothSlamFx(x, y, effect, radius) {
    this.#drawSlamFx(x, y, effect, radius);

    const layer = this.#fxLayer(x, y, 1435, { additive: true });
    const g = this.add.graphics();
    layer.add(g);
    g.fillStyle(effect.tertiary || 0xffffff, 0.92);
    g.fillTriangle(-radius * 0.28, -radius * 0.48, -radius * 0.02, radius * 0.08, -radius * 0.48, radius * 0.02);
    g.fillTriangle(radius * 0.28, -radius * 0.48, radius * 0.02, radius * 0.08, radius * 0.48, radius * 0.02);
    g.lineStyle(3, effect.secondary, 0.72);
    g.strokeEllipse(0, radius * 0.16, radius * 1.12, radius * 0.28);

    this.tweens.add({
      targets: layer,
      alpha: 0,
      y: y + 12,
      scale: 1.18,
      duration: effect.duration,
      ease: 'Cubic.easeOut',
      onComplete: () => layer.destroy(),
    });

    this.#drawMoteBurstFx(x, y, effect, { count: 12, radius: radius * 0.8, shape: 'shard' });
  }

  #drawSnackAwakeningFx(x, y, effect, radius) {
    this.#drawAuraFx(x, y, effect, radius);
    this.#drawGoldenOrbitFx(x, y, effect, radius * 0.92);
    this.#drawMoteBurstFx(x, y, effect, { count: 14, radius: radius * 0.74, shape: 'seed', spreadY: 0.48 });
  }

  #drawWheelWhirlFx(x, y, effect, radius) {
    this.#drawWhirlwindFx(x, y, effect, radius);
    this.#drawWheelGlyphFx(x, y, effect, radius * 0.66);
    this.#drawMoteBurstFx(x, y, effect, { count: 16, radius, shape: 'spark', spreadY: 0.52 });
  }

  #drawWheelGlyphFx(x, y, effect, radius) {
    const layer = this.#fxLayer(x, y, 1430, { additive: true });
    const g = this.add.graphics();
    layer.add(g);
    g.lineStyle(5 * SKILL_FX_STROKE_MULTIPLIER, effect.primary, 0.78);
    g.strokeCircle(0, 0, radius);
    g.lineStyle(3 * SKILL_FX_STROKE_MULTIPLIER, effect.secondary, 0.72);
    g.strokeCircle(0, 0, radius * 0.58);
    for (let i = 0; i < 8; i += 1) {
      const angle = Math.PI * 2 * i / 8;
      g.beginPath();
      g.moveTo(Math.cos(angle) * radius * 0.18, Math.sin(angle) * radius * 0.18);
      g.lineTo(Math.cos(angle) * radius * 0.92, Math.sin(angle) * radius * 0.92);
      g.strokePath();
    }
    g.fillStyle(effect.accent, 0.92);
    g.fillCircle(0, 0, radius * 0.16);

    this.tweens.add({
      targets: layer,
      alpha: 0,
      angle: 260,
      scale: 1.22,
      duration: effect.duration,
      ease: 'Cubic.easeOut',
      onComplete: () => layer.destroy(),
    });
  }

  #drawMoonCrescentFx(x, y, effect, radius) {
    const layer = this.#fxLayer(x, y, 1440, { additive: true });
    const g = this.add.graphics();
    layer.add(g);
    g.lineStyle(Math.max(4, radius * 0.1), effect.secondary, 0.78);
    g.beginPath();
    g.arc(0, 0, radius * 0.82, -1.25, 1.28);
    g.strokePath();
    g.lineStyle(Math.max(2, radius * 0.045), effect.tertiary || 0xffffff, 0.78);
    g.beginPath();
    g.arc(radius * 0.12, -radius * 0.04, radius * 0.64, -1.12, 1.14);
    g.strokePath();

    this.tweens.add({
      targets: layer,
      alpha: 0,
      angle: -28,
      scale: 1.24,
      duration: effect.duration,
      ease: 'Cubic.easeOut',
      onComplete: () => layer.destroy(),
    });
  }

  #drawSawdustRainFx(x, y, effect, radius) {
    this.#drawRainImpactFx(x, y, effect, radius);
    this.#drawMoteBurstFx(x, y - radius * 0.3, effect, {
      count: 24,
      radius: radius * 0.95,
      shape: 'flake',
      duration: effect.duration * 1.05,
      spreadY: 1.08,
    });
  }

  #drawStarCandyMeteorFx(x, y, effect, radius) {
    this.#drawMeteorImpactFx(x, y, effect, radius);

    const layer = this.#fxLayer(x, y, 1455, { additive: true });
    const g = this.add.graphics();
    layer.add(g);
    g.fillStyle(effect.accent, 0.84);
    this.#drawStarShape(g, 0, 0, radius * 0.42, radius * 0.18, 5);
    g.lineStyle(3 * SKILL_FX_STROKE_MULTIPLIER, effect.secondary, 0.72);
    g.strokeCircle(0, 0, radius * 0.55);

    this.tweens.add({
      targets: layer,
      alpha: 0,
      scale: 1.5,
      angle: 42,
      duration: effect.duration,
      ease: 'Cubic.easeOut',
      onComplete: () => layer.destroy(),
    });

    this.#drawMoteBurstFx(x, y, effect, { count: 18, radius, shape: 'star' });
  }

  #drawHamsterStampedeFx(x, y, effect, radius) {
    this.#drawOverrunFx(x, y, effect, radius);
    const colors = [effect.primary, effect.secondary, effect.accent, effect.tertiary || 0xffffff];
    for (let i = 0; i < 10; i += 1) {
      const px = x - radius * 1.25 + i * radius * 0.28;
      const py = y + (i % 2 ? 1 : -1) * radius * 0.22;
      const paw = this.add.graphics()
        .setPosition(px, py)
        .setDepth(1445)
        .setAlpha(0.95);
      paw.setBlendMode?.(globalThis.Phaser?.BlendModes?.ADD ?? 'ADD');
      this.#drawMoteShape(paw, 'paw', 0, 0, 7, colors[i % colors.length], effect.accent, 0.82);
      this.tweens.add({
        targets: paw,
        x: px + radius * 0.46,
        alpha: 0,
        scale: 1.28,
        delay: i * 22,
        duration: effect.duration * 0.68,
        ease: 'Cubic.easeOut',
        onComplete: () => paw.destroy(),
      });
    }
    this.#drawMoteBurstFx(x, y, effect, { count: 14, radius, shape: 'seed', spreadY: 0.48 });
  }

  #drawGoldCheekUltimateFx(x, y, effect, radius) {
    this.#drawHeartFx(x, y, effect, radius);
    this.#drawGoldenOrbitFx(x, y, effect, radius * 0.9);
    this.#drawMoteBurstFx(x, y, effect, { count: 26, radius: radius * 1.05, shape: 'coin', duration: effect.duration * 0.92 });
    this.#drawMoteBurstFx(x, y, effect, { count: 18, radius: radius * 0.86, shape: 'star', duration: effect.duration * 0.78 });

    const flash = this.add.rectangle(this.scale.width / 2, this.scale.height / 2, this.scale.width, this.scale.height, effect.primary, 0.12)
      .setDepth(1420);
    flash.setBlendMode?.(globalThis.Phaser?.BlendModes?.ADD ?? 'ADD');
    this.tweens.add({
      targets: flash,
      alpha: 0,
      duration: 420,
      ease: 'Cubic.easeOut',
      onComplete: () => flash.destroy(),
    });
  }

  #drawGoldenOrbitFx(x, y, effect, radius) {
    const layer = this.#fxLayer(x, y, 1445, { additive: true });
    const g = this.add.graphics();
    layer.add(g);
    g.lineStyle(3 * SKILL_FX_STROKE_MULTIPLIER, effect.secondary, 0.82);
    g.strokeEllipse(0, 0, radius * 1.55, radius * 0.72);
    g.lineStyle(2 * SKILL_FX_STROKE_MULTIPLIER, effect.primary, 0.62);
    g.strokeEllipse(0, 0, radius * 1.18, radius * 0.52);
    for (let i = 0; i < 8; i += 1) {
      const angle = Math.PI * 2 * i / 8;
      this.#drawMoteShape(
        g,
        i % 2 ? 'coin' : 'spark',
        Math.cos(angle) * radius * 0.74,
        Math.sin(angle) * radius * 0.33,
        5 + (i % 3),
        i % 2 ? effect.primary : effect.secondary,
        effect.tertiary || 0xffffff,
        0.92,
      );
    }

    this.tweens.add({
      targets: layer,
      alpha: 0,
      angle: 36,
      scale: 1.18,
      duration: effect.duration,
      ease: 'Cubic.easeOut',
      onComplete: () => layer.destroy(),
    });
  }

  #drawCheekPulseFx(x, y, effect, radius) {
    const layer = this.#fxLayer(x, y, 1438, { additive: true });
    const g = this.add.graphics();
    layer.add(g);
    g.fillStyle(effect.tertiary || effect.primary, 0.28);
    g.fillEllipse(-radius * 0.42, -radius * 0.02, radius * 0.62, radius * 0.4);
    g.fillEllipse(radius * 0.42, -radius * 0.02, radius * 0.62, radius * 0.4);
    g.lineStyle(3 * SKILL_FX_STROKE_MULTIPLIER, effect.primary, 0.78);
    g.strokeEllipse(-radius * 0.42, -radius * 0.02, radius * 0.72, radius * 0.46);
    g.strokeEllipse(radius * 0.42, -radius * 0.02, radius * 0.72, radius * 0.46);

    this.tweens.add({
      targets: layer,
      alpha: 0,
      scale: 1.36,
      duration: effect.duration * 0.78,
      ease: 'Cubic.easeOut',
      onComplete: () => layer.destroy(),
    });
  }

  #drawAuraFx(x, y, effect, radius) {
    const layer = this.#fxLayer(x, y, 1380);
    const g = this.add.graphics();
    layer.add(g);

    g.lineStyle(4 * SKILL_FX_STROKE_MULTIPLIER, effect.primary, 0.86);
    g.strokeCircle(0, 0, radius);
    g.lineStyle(2 * SKILL_FX_STROKE_MULTIPLIER, effect.secondary, 0.72);
    g.strokeCircle(0, 0, radius * 0.68);
    g.fillStyle(effect.primary, 0.18);
    g.fillCircle(0, 0, radius * 0.92);
    for (let i = 0; i < 10; i += 1) {
      const angle = (Math.PI * 2 * i) / 10;
      g.fillStyle(i % 2 ? effect.secondary : effect.primary, 0.95);
      g.fillCircle(Math.cos(angle) * radius * 0.86, Math.sin(angle) * radius * 0.44, 4 * SKILL_FX_MOTE_MULTIPLIER);
    }

    this.tweens.add({
      targets: layer,
      alpha: 0,
      scale: 1.32,
      angle: 18,
      duration: effect.duration,
      ease: 'Cubic.easeOut',
      onComplete: () => layer.destroy(),
    });
  }

  #drawBurstFx(x, y, effect, radius, { spores = 8, rings = 1 } = {}) {
    const layer = this.#fxLayer(x, y);
    const g = this.add.graphics();
    layer.add(g);

    for (let i = 0; i < rings; i += 1) {
      g.lineStyle((4 - i) * SKILL_FX_STROKE_MULTIPLIER, i % 2 ? effect.secondary : effect.primary, 0.86 - i * 0.2);
      g.strokeCircle(0, 0, radius * (0.48 + i * 0.32));
    }
    g.fillStyle(effect.accent, 0.2);
    g.fillCircle(0, 0, radius * 0.72);

    for (let i = 0; i < spores; i += 1) {
      const angle = (Math.PI * 2 * i) / spores + Math.random() * 0.2;
      const dist = radius * (0.35 + Math.random() * 0.65);
      g.fillStyle(i % 2 ? effect.secondary : effect.primary, 0.92);
      g.fillCircle(Math.cos(angle) * dist, Math.sin(angle) * dist * 0.72, (3 + Math.random() * 3) * SKILL_FX_MOTE_MULTIPLIER);
    }

    this.tweens.add({
      targets: layer,
      alpha: 0,
      scale: 1.42,
      duration: effect.duration,
      ease: 'Cubic.easeOut',
      onComplete: () => layer.destroy(),
    });
  }

  #drawSlamFx(x, y, effect, radius) {
    const layer = this.#fxLayer(x, y);
    const g = this.add.graphics();
    layer.add(g);

    g.lineStyle(7 * SKILL_FX_STROKE_MULTIPLIER, effect.primary, 0.92);
    g.beginPath();
    g.moveTo(-radius * 0.7, radius * 0.22);
    g.lineTo(-radius * 0.18, -radius * 0.34);
    g.lineTo(radius * 0.2, radius * 0.05);
    g.lineTo(radius * 0.74, -radius * 0.44);
    g.strokePath();
    g.lineStyle(3 * SKILL_FX_STROKE_MULTIPLIER, effect.secondary, 0.84);
    for (const dir of [-1, 1]) {
      g.beginPath();
      g.moveTo(0, 0);
      g.lineTo(dir * radius * 0.58, radius * 0.38);
      g.strokePath();
    }
    g.fillStyle(effect.accent, 0.18);
    g.fillEllipse(0, radius * 0.32, radius * 1.25, radius * 0.36);

    this.tweens.add({
      targets: layer,
      alpha: 0,
      scaleX: 1.18,
      scaleY: 1.08,
      duration: effect.duration,
      ease: 'Cubic.easeOut',
      onComplete: () => layer.destroy(),
    });
  }

  #drawWhirlwindFx(x, y, effect, radius) {
    const layer = this.#fxLayer(x, y);
    const g = this.add.graphics();
    layer.add(g);

    for (let i = 0; i < 4; i += 1) {
      const r = radius * (0.35 + i * 0.16);
      g.lineStyle((4 - i * 0.35) * SKILL_FX_STROKE_MULTIPLIER, i % 2 ? effect.secondary : effect.primary, 0.9 - i * 0.12);
      g.beginPath();
      g.arc(0, 0, r, -0.4 + i * 0.8, 2.1 + i * 0.8);
      g.strokePath();
    }
    this.tweens.add({
      targets: layer,
      alpha: 0,
      angle: 115,
      scale: 1.28,
      duration: effect.duration,
      ease: 'Cubic.easeOut',
      onComplete: () => layer.destroy(),
    });
  }

  #drawSpiralFx(x, y, effect, radius) {
    const layer = this.#fxLayer(x, y, 1370);
    const g = this.add.graphics();
    layer.add(g);

    for (let i = 0; i < 3; i += 1) {
      g.lineStyle(3 * SKILL_FX_STROKE_MULTIPLIER, i % 2 ? effect.secondary : effect.primary, 0.82);
      g.beginPath();
      g.arc(0, 0, radius * (0.42 + i * 0.18), i * 1.2, i * 1.2 + 3.9);
      g.strokePath();
    }
    this.tweens.add({
      targets: layer,
      alpha: 0,
      angle: 150,
      scale: 1.22,
      duration: 360,
      ease: 'Cubic.easeOut',
      onComplete: () => layer.destroy(),
    });
  }

  #drawRuneFx(x, y, effect, radius) {
    const layer = this.#fxLayer(x, y);
    const g = this.add.graphics();
    layer.add(g);

    g.lineStyle(4 * SKILL_FX_STROKE_MULTIPLIER, effect.primary, 0.88);
    g.strokeCircle(0, 0, radius);
    g.lineStyle(2 * SKILL_FX_STROKE_MULTIPLIER, effect.secondary, 0.78);
    g.strokeCircle(0, 0, radius * 0.64);
    for (let i = 0; i < 6; i += 1) {
      const angle = (Math.PI * 2 * i) / 6;
      const x1 = Math.cos(angle) * radius * 0.74;
      const y1 = Math.sin(angle) * radius * 0.74;
      g.lineStyle(2 * SKILL_FX_STROKE_MULTIPLIER, effect.accent, 0.7);
      g.beginPath();
      g.moveTo(x1, y1);
      g.lineTo(-x1 * 0.45, -y1 * 0.45);
      g.strokePath();
    }

    this.tweens.add({
      targets: layer,
      alpha: 0,
      angle: -28,
      scale: 1.24,
      duration: effect.duration,
      ease: 'Cubic.easeOut',
      onComplete: () => layer.destroy(),
    });
  }

  #drawRainCueFx(x, y, effect) {
    const s = SKILL_FX_CAST_MULTIPLIER;
    const layer = this.#fxLayer(x, y - 96 * s, 1360);
    const g = this.add.graphics();
    layer.add(g);
    const total = Math.ceil(9 * SKILL_FX_DENSITY_MULTIPLIER);
    for (let i = 0; i < total; i += 1) {
      const px = -72 * s + i * 18 * s;
      g.lineStyle(3 * SKILL_FX_STROKE_MULTIPLIER, i % 2 ? effect.secondary : effect.primary, 0.78);
      g.beginPath();
      g.moveTo(px, (-36 - (i % 3) * 8) * s);
      g.lineTo(px - 12 * s, (8 + (i % 2) * 10) * s);
      g.strokePath();
    }
    this.tweens.add({
      targets: layer,
      y: y - 48 * s,
      alpha: 0,
      duration: 420,
      ease: 'Cubic.easeIn',
      onComplete: () => layer.destroy(),
    });
  }

  #drawRainImpactFx(x, y, effect, radius) {
    this.#drawBurstFx(x, y, effect, radius, { spores: 16, rings: 2 });
    const layer = this.#fxLayer(x, y - 16, 1410);
    const g = this.add.graphics();
    layer.add(g);
    for (let i = 0; i < 8; i += 1) {
      const px = -radius * 0.7 + i * radius * 0.2;
      g.lineStyle(2 * SKILL_FX_STROKE_MULTIPLIER, effect.primary, 0.7);
      g.beginPath();
      g.moveTo(px, -radius * 0.62);
      g.lineTo(px - 16 * SKILL_FX_CAST_MULTIPLIER, radius * 0.28);
      g.strokePath();
    }
    this.tweens.add({
      targets: layer,
      alpha: 0,
      y: y + 20,
      duration: effect.duration,
      ease: 'Cubic.easeOut',
      onComplete: () => layer.destroy(),
    });
  }

  #drawMeteorCueFx(x, y, effect) {
    const s = SKILL_FX_CAST_MULTIPLIER;
    const layer = this.#fxLayer(x - 110 * s, y - 170 * s, 1360);
    const g = this.add.graphics();
    layer.add(g);
    g.lineStyle(8 * SKILL_FX_STROKE_MULTIPLIER, effect.primary, 0.88);
    g.beginPath();
    g.moveTo(0, 0);
    g.lineTo(110 * s, 130 * s);
    g.strokePath();
    g.lineStyle(4 * SKILL_FX_STROKE_MULTIPLIER, effect.secondary, 0.78);
    g.beginPath();
    g.moveTo(-20 * s, -8 * s);
    g.lineTo(118 * s, 128 * s);
    g.strokePath();
    g.fillStyle(effect.primary, 0.96);
    g.fillCircle(122 * s, 138 * s, 10 * SKILL_FX_MOTE_MULTIPLIER);
    this.tweens.add({
      targets: layer,
      x,
      y,
      alpha: 0,
      duration: 360,
      ease: 'Cubic.easeIn',
      onComplete: () => layer.destroy(),
    });
  }

  #drawMeteorImpactFx(x, y, effect, radius) {
    this.#drawSlamFx(x, y, effect, radius);
    this.#drawBurstFx(x, y, effect, radius * 0.92, { spores: 10, rings: 2 });
  }

  #drawOverrunFx(x, y, effect, radius) {
    const layer = this.#fxLayer(x, y);
    const g = this.add.graphics();
    layer.add(g);
    for (let i = 0; i < 3; i += 1) {
      g.lineStyle(4 - i * 0.6, i % 2 ? effect.secondary : effect.primary, 0.9 - i * 0.16);
      g.strokeEllipse(0, 0, radius * (1.8 + i * 0.48), radius * (0.84 + i * 0.22));
    }
    for (let i = 0; i < 18; i += 1) {
      const angle = (Math.PI * 2 * i) / 18;
      g.fillStyle(i % 2 ? effect.secondary : effect.primary, 0.86);
      g.fillCircle(Math.cos(angle) * radius * 0.68, Math.sin(angle) * radius * 0.32, 3);
    }
    this.tweens.add({
      targets: layer,
      alpha: 0,
      scaleX: 1.42,
      scaleY: 1.22,
      duration: effect.duration,
      ease: 'Cubic.easeOut',
      onComplete: () => layer.destroy(),
    });
  }

  #drawHeartFx(x, y, effect, radius) {
    const layer = this.#fxLayer(x, y, 1450);
    const g = this.add.graphics();
    layer.add(g);

    g.fillStyle(effect.accent, 0.2);
    g.fillCircle(0, 0, radius * 0.94);
    g.lineStyle(6, effect.primary, 0.92);
    g.strokeCircle(0, 0, radius);
    g.lineStyle(3, effect.secondary, 0.82);
    g.strokeCircle(0, 0, radius * 0.64);
    for (let i = 0; i < 12; i += 1) {
      const angle = (Math.PI * 2 * i) / 12;
      const inner = radius * 0.26;
      const outer = radius * 0.88;
      g.lineStyle(2, i % 2 ? effect.secondary : effect.accent, 0.72);
      g.beginPath();
      g.moveTo(Math.cos(angle) * inner, Math.sin(angle) * inner);
      g.lineTo(Math.cos(angle) * outer, Math.sin(angle) * outer);
      g.strokePath();
    }
    g.fillStyle(effect.primary, 0.96);
    g.fillCircle(0, 0, 9);

    this.tweens.add({
      targets: layer,
      alpha: 0,
      scale: 1.5,
      angle: 35,
      duration: effect.duration,
      ease: 'Cubic.easeOut',
      onComplete: () => layer.destroy(),
    });
  }

  #showBanner(text) {
    const banner = this.add.text(this.scale.width / 2, 96, text, {
      fontFamily: 'system-ui, -apple-system, sans-serif',
      fontSize: '44px',
      color: '#f7d66d',
      stroke: '#101814',
      strokeThickness: 6,
    }).setOrigin(0.5).setDepth(2000);

    this.tweens.add({
      targets: banner,
      y: 78,
      alpha: 0,
      delay: 900,
      duration: 520,
      onComplete: () => banner.destroy(),
    });
  }

  #showDropBurst({ item, count }) {
    if (!item || count == null) return;

    const amount = Math.max(1, Math.min(5, Math.ceil(Number(count) || 1)));
    const icon = item.id === 6 ? '◆' : '●';
    const color = item.id === 6 ? '#d9b4ff' : '#ffd45b';
    for (let i = 0; i < amount; i += 1) {
      const x = 420 + Math.random() * 220;
      const y = 500 + Math.random() * 120;
      const label = this.add.text(x, y, icon, {
        fontFamily: 'system-ui, -apple-system, sans-serif',
        fontSize: '26px',
        fontStyle: 'bold',
        color,
        stroke: '#4a230b',
        strokeThickness: 5,
      }).setOrigin(0.5).setDepth(1900);

      this.tweens.add({
        targets: label,
        x: x + (Math.random() - 0.5) * 100,
        y: y - 72 - Math.random() * 38,
        alpha: 0,
        scale: 0.72,
        duration: 900,
        ease: 'Cubic.easeOut',
        onComplete: () => label.destroy(),
      });
    }
  }

  #floatText(x, y, text, color) {
    const label = this.add.text(x, y, text, {
      fontFamily: 'system-ui, -apple-system, sans-serif',
      fontSize: '30px',
      fontStyle: 'bold',
      color,
      stroke: '#101814',
      strokeThickness: 6,
    }).setOrigin(0.5).setDepth(2000);

    this.tweens.add({
      targets: label,
      y: y - 54,
      alpha: 0,
      scale: 1.18,
      duration: 760,
      ease: 'Cubic.easeOut',
      onComplete: () => label.destroy(),
    });
  }
}
