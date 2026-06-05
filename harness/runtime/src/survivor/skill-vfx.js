const SKILL_VFX_VERSION = 'ninja2-skill-vfx-v1';
const DEMO_INTERVAL_MS = 560;
const DEMO_START_DELAY_MS = 900;

export const SKILL_VFX_DEMO_IDS = Object.freeze([
  300101,
  300102,
  300103,
  300104,
  300105,
  300106,
  300107,
  300108,
  300109,
  300110,
  300111,
  300112,
  300113,
  300114,
  300115,
  300116,
]);

export const SKILL_ICON_PATHS = Object.freeze({
  300101: 'Skills/Ninja2/skill_kunai_slash.png',
  300102: 'Skills/Ninja2/skill_shuriken_barrage.png',
  300103: 'Skills/Ninja2/skill_smoke_bomb.png',
  300104: 'Skills/Ninja2/skill_shadow_breath.png',
  300105: 'Skills/Ninja2/skill_orbit_shuriken.png',
  300106: 'Skills/Ninja2/skill_lightning_kunai.png',
  300107: 'Skills/Ninja2/skill_fire_scroll.png',
  300108: 'Skills/Ninja2/skill_frost_needle.png',
  300109: 'Skills/Ninja2/skill_shadow_clone.png',
  300110: 'Skills/Ninja2/skill_moon_flash.png',
  300111: 'Skills/Ninja2/skill_bamboo_spear_rain.png',
  300112: 'Skills/Ninja2/skill_black_lotus_storm.png',
  300113: 'Skills/Ninja2/skill_killing_focus.png',
  300114: 'Skills/Ninja2/skill_time_fold.png',
  300115: 'Skills/Ninja2/skill_gale_steps.png',
  300116: 'Skills/Ninja2/skill_weakness_mark.png',
});

export const RUN_SKILL_BAR = Object.freeze([
  { id: 300101, name: '쿠나이', icon: '刃', sprite: SKILL_ICON_PATHS[300101], color: '#ffe17a', cooldown: 0.55, offset: 0 },
  { id: 300103, name: '연막', icon: '煙', sprite: SKILL_ICON_PATHS[300103], color: '#8bd8d0', cooldown: 2.1, offset: 0.7 },
  { id: 300115, name: '질풍', icon: '風', sprite: SKILL_ICON_PATHS[300115], color: '#8bd95c', cooldown: 5.4, offset: 1.8 },
]);

export const RUN_PROFILE_SKILL_ROWS = Object.freeze({
  active: RUN_SKILL_BAR.map(({ id, name, icon, sprite, color }) => ({ id, name, icon, sprite, color })),
  passive: Object.freeze([
    { id: 300104, name: '그림자 호흡', icon: '息', sprite: SKILL_ICON_PATHS[300104], color: '#36e0d4' },
    { id: 300113, name: '살의 집중', icon: '瞳', sprite: SKILL_ICON_PATHS[300113], color: '#ff6b55' },
    { id: 300114, name: '시간 접기', icon: '刻', sprite: SKILL_ICON_PATHS[300114], color: '#43e7ff' },
  ]),
});

export const SKILL_VFX_PROFILES = Object.freeze({
  300101: {
    name: '쿠나이 베기',
    family: 'slash',
    color: 0xffe17a,
    accent: 0xff6b55,
    texture: 'slashBlade',
    maxTargets: 4,
    slashCount: 3,
    hitPulse: 0xfff1c8,
  },
  300102: {
    name: '표창 난사',
    family: 'projectileVolley',
    color: 0xd8d8c2,
    accent: 0x43e7ff,
    texture: 'slashBlade',
    maxTargets: 3,
    shotsPerTarget: 3,
    hitPulse: 0xdff7ff,
  },
  300103: {
    name: '연막 폭탄',
    family: 'smokeBomb',
    color: 0x9aa5a5,
    accent: 0x36e0d4,
    maxTargets: 6,
    hitPulse: 0x8bd8d0,
  },
  300104: {
    name: '그림자 호흡',
    family: 'shadowBreath',
    color: 0x2ee6ff,
    accent: 0x17241d,
    selfBuff: true,
    hitPulse: 0x2ee6ff,
  },
  300105: {
    name: '회전 수리검',
    family: 'orbitBurst',
    color: 0xffe17a,
    accent: 0xd8d8c2,
    texture: 'slashBlade',
    maxTargets: 3,
    hitPulse: 0xffe17a,
  },
  300106: {
    name: '번개 쿠나이',
    family: 'lightning',
    color: 0x43e7ff,
    accent: 0xfff1a2,
    maxTargets: 2,
    hitPulse: 0x43e7ff,
  },
  300107: {
    name: '화염 두루마리',
    family: 'flameGround',
    color: 0xff7a32,
    accent: 0xffd66d,
    maxTargets: 8,
    hitPulse: 0xff7a32,
  },
  300108: {
    name: '냉혈 침술',
    family: 'needlePierce',
    color: 0x8fdcff,
    accent: 0xdff7ff,
    maxTargets: 1,
    hitPulse: 0x8fdcff,
  },
  300109: {
    name: '그림자 분신',
    family: 'shadowClone',
    color: 0x21322b,
    accent: 0xffe17a,
    maxTargets: 4,
    hitPulse: 0xffe17a,
  },
  300110: {
    name: '월광 일섬',
    family: 'moonFlash',
    color: 0xeaf7ff,
    accent: 0x8fdcff,
    maxTargets: 2,
    hitPulse: 0xeaf7ff,
  },
  300111: {
    name: '대나무 창비',
    family: 'spearRain',
    color: 0x8bd95c,
    accent: 0xa96a32,
    maxTargets: 8,
    hitPulse: 0x8bd95c,
  },
  300112: {
    name: '흑련 폭풍',
    family: 'lotusStorm',
    color: 0x7c5cff,
    accent: 0x171022,
    maxTargets: 10,
    hitPulse: 0x7c5cff,
  },
  300113: {
    name: '살의 집중',
    family: 'killingFocus',
    color: 0xff6b55,
    accent: 0xffd66d,
    selfBuff: true,
    hitPulse: 0xff6b55,
  },
  300114: {
    name: '시간 접기',
    family: 'timeFold',
    color: 0x43e7ff,
    accent: 0xeaf7ff,
    selfBuff: true,
    hitPulse: 0x43e7ff,
  },
  300115: {
    name: '질풍 보법',
    family: 'galeStep',
    color: 0x8bd95c,
    accent: 0xeaffc8,
    selfBuff: true,
    hitPulse: 0x8bd95c,
  },
  300116: {
    name: '약점 표식',
    family: 'weakPointMark',
    color: 0xff6b55,
    accent: 0xfff1a2,
    maxTargets: 1,
    hitPulse: 0xff6b55,
  },
});

export function getSkillVfxProfile(skillDataId) {
  return SKILL_VFX_PROFILES[Number(skillDataId)] || null;
}

export function installSkillVfxContract(root = document.documentElement) {
  root.dataset.survivorSkillVfxReady = 'true';
  root.dataset.survivorSkillVfxVersion = SKILL_VFX_VERSION;
  root.dataset.survivorSkillVfxCount = String(SKILL_VFX_DEMO_IDS.length);
}

export function spawnSkillCastFx(scene, skill) {
  const profile = getSkillVfxProfile(skill?.dataId || skill?.def?.id);
  if (!profile || !scene?.add || !skill?.owner) return false;

  const root = document.documentElement;
  root.dataset.survivorSkillVfxLast = String(skill.dataId || skill.def?.id || '');
  root.dataset.survivorSkillVfxFamily = profile.family;

  switch (profile.family) {
    case 'slash':
      drawSlashFan(scene, skill, profile);
      break;
    case 'projectileVolley':
      drawProjectileVolley(scene, skill, profile);
      break;
    case 'smokeBomb':
      drawSmokeBomb(scene, skill, profile);
      break;
    case 'shadowBreath':
    case 'killingFocus':
    case 'timeFold':
    case 'galeStep':
      drawSelfAura(scene, skill, profile);
      break;
    case 'orbitBurst':
      drawOrbitBurst(scene, skill, profile);
      break;
    case 'lightning':
      drawLightning(scene, skill, profile);
      break;
    case 'flameGround':
      drawFlameGround(scene, skill, profile);
      break;
    case 'needlePierce':
      drawNeedlePierce(scene, skill, profile);
      break;
    case 'shadowClone':
      drawShadowClone(scene, skill, profile);
      break;
    case 'moonFlash':
      drawMoonFlash(scene, skill, profile);
      break;
    case 'spearRain':
      drawSpearRain(scene, skill, profile);
      break;
    case 'lotusStorm':
      drawLotusStorm(scene, skill, profile);
      break;
    case 'weakPointMark':
      drawWeakPointMark(scene, skill, profile);
      break;
    default:
      drawSlashFan(scene, skill, profile);
      break;
  }

  return true;
}

export function spawnSkillTimelineFx(scene, { skill } = {}) {
  const profile = getSkillVfxProfile(skill?.dataId || skill?.def?.id);
  if (!profile || !scene?.add) return false;

  const target = profile.selfBuff ? pointFromUnit(skill.owner) : targetPoints(skill, 1)[0] || pointFromUnit(skill.owner);
  const pulse = localGraphics(scene, target.x, target.y, 66);
  pulse.lineStyle(3, profile.hitPulse || profile.color, 0.78);
  pulse.strokeCircle(0, 0, profile.selfBuff ? 64 : 42);
  pulse.fillStyle(profile.hitPulse || profile.color, 0.12);
  pulse.fillCircle(0, 0, profile.selfBuff ? 48 : 30);
  fadeAndDestroy(scene, pulse, 210, { scaleX: 1.45, scaleY: 1.45 });
  return true;
}

export function maybeStartSkillVfxDemo(scene) {
  const params = new URLSearchParams(globalThis.location?.search || '');
  const requested = params.get('vfx') || params.get('skillVfxDemo') || params.get('skillFxDemo');
  if (!['1', 'true', 'demo', 'skills'].includes(String(requested).toLowerCase())) return null;
  if (!scene?.board || !scene?.store) return null;

  const root = document.documentElement;
  const board = scene.board;
  const player = board.playerUnit;
  const enemyDef = [...scene.store.units.values()].find(unit => unit.type !== 'Player');
  const previousAuto = board.autoSkillsEnabled;
  const state = { fired: 0, errors: [], skillIds: [] };
  let index = 0;
  let cancelled = false;
  let timer = null;

  root.dataset.survivorSkillVfxDemo = 'ready';
  root.dataset.survivorSkillVfxDemoFired = '0';
  root.dataset.survivorSkillVfxDemoErrors = '0';
  globalThis.__NINJA2_SKILL_VFX_DEMO__ = state;

  if (!player || !enemyDef) {
    root.dataset.survivorSkillVfxDemo = !player ? 'missing-player' : 'missing-enemy';
    return null;
  }

  board.setAutoSkillsEnabled(false);
  player.alive = true;
  player.state = 'combat';
  player.hp = player.maxHp;

  const schedule = delay => {
    timer = scene.time.delayedCall(delay, fireNext);
  };

  const cleanup = () => {
    cancelled = true;
    timer?.remove?.(false);
    if (previousAuto) board.setAutoSkillsEnabled(true);
    root.dataset.survivorSkillVfxDemo = root.dataset.survivorSkillVfxDemo === 'done'
      ? 'done'
      : 'stopped';
  };

  const fireNext = () => {
    if (cancelled) return;
    if (index >= SKILL_VFX_DEMO_IDS.length) {
      root.dataset.survivorSkillVfxDemo = 'done';
      root.dataset.survivorSkillVfxDemoFired = String(state.fired);
      root.dataset.survivorSkillVfxDemoErrors = String(state.errors.length);
      if (previousAuto) board.setAutoSkillsEnabled(true);
      return;
    }

    const skillDataId = SKILL_VFX_DEMO_IDS[index];
    index += 1;
    try {
      const target = ensureDemoTarget(scene, enemyDef, index);
      const fired = board.startSkill(player, skillDataId, target ? [target] : null, { skillLevel: 1 });
      if (fired) {
        state.fired += 1;
        state.skillIds.push(skillDataId);
      } else {
        const def = scene.store.getSkill(skillDataId);
        spawnSkillCastFx(scene, { dataId: skillDataId, def, owner: player, targets: target ? [target] : [] });
        state.errors.push(`${skillDataId}:manual-fallback`);
      }
    } catch (error) {
      state.errors.push(`${skillDataId}:${error.message}`);
    }

    root.dataset.survivorSkillVfxDemo = `${index}/${SKILL_VFX_DEMO_IDS.length}`;
    root.dataset.survivorSkillVfxDemoFired = String(state.fired);
    root.dataset.survivorSkillVfxDemoErrors = String(state.errors.length);
    schedule(DEMO_INTERVAL_MS);
  };

  schedule(DEMO_START_DELAY_MS);
  return cleanup;
}

function ensureDemoTarget(scene, enemyDef, index) {
  const board = scene.board;
  const player = board.playerUnit;
  let target = board.enemyUnits.find(unit => unit.alive && unit.state === 'combat')
    || board.enemyUnits.find(unit => unit.alive);

  if (!target) {
    target = board.spawnUnit(enemyDef.id, {
      team: 'Enemy',
      level: Math.max(1, board.boardState || 1),
      x: player.x + 220,
      y: player.y,
      targetX: player.x + 220,
      targetY: player.y,
      state: 'combat',
    });
  }

  if (!target) return null;

  const angle = index * 0.92;
  const radius = 220 + (index % 4) * 26;
  target.alive = true;
  target.state = 'combat';
  target.x = player.x + Math.cos(angle) * radius;
  target.y = player.y + Math.sin(angle) * radius * 0.64;
  target.targetX = target.x;
  target.targetY = target.y;
  target.maxHp = Math.max(target.maxHp || 1, 99999999);
  target.hp = target.maxHp;
  return target;
}

function drawSlashFan(scene, skill, profile) {
  const points = targetPoints(skill, profile.maxTargets || 3);
  points.forEach((point, pointIndex) => {
    const g = localGraphics(scene, point.x, point.y, 64);
    const count = profile.slashCount || 2;
    for (let i = 0; i < count; i += 1) {
      const angle = -0.8 + i * 0.55 + pointIndex * 0.15;
      const length = 42 + i * 12;
      g.lineStyle(i === 1 ? 7 : 4, i % 2 ? profile.color : profile.accent, i === 1 ? 0.92 : 0.68);
      g.lineBetween(
        Math.cos(angle) * -length,
        Math.sin(angle) * -length,
        Math.cos(angle) * length,
        Math.sin(angle) * length,
      );
    }
    g.lineStyle(2, 0xfff1c8, 0.7);
    g.strokeCircle(0, 0, 38);
    fadeAndDestroy(scene, g, 180, { scaleX: 1.18, scaleY: 1.18 });
  });
}

function drawProjectileVolley(scene, skill, profile) {
  const origin = pointFromUnit(skill.owner);
  const trail = scene.add.graphics();
  trail.setDepth(58);
  const points = targetPoints(skill, profile.maxTargets || 3);
  points.forEach((point, targetIndex) => {
    const shots = profile.shotsPerTarget || 1;
    for (let shot = 0; shot < shots; shot += 1) {
      const jitter = (shot - (shots - 1) / 2) * 18;
      const start = { x: origin.x - 12 + shot * 8, y: origin.y + jitter * 0.35 };
      const end = { x: point.x + jitter, y: point.y - jitter * 0.25 };
      const blade = scene.add.sprite(start.x, start.y, profile.texture || 'slashBlade');
      blade.setDepth(63 + shot);
      blade.setScale(0.42);
      blade.setRotation(angleBetween(start, end));
      trail.lineStyle(2, shot % 2 ? profile.accent : profile.color, 0.34);
      trail.lineBetween(start.x, start.y, end.x, end.y);
      scene.tweens.add({
        targets: blade,
        x: end.x,
        y: end.y,
        alpha: 0.2,
        scaleX: 0.74,
        scaleY: 0.74,
        duration: 130 + targetIndex * 18 + shot * 24,
        ease: 'Quad.easeOut',
        onComplete: () => blade.destroy(),
      });
    }
  });
  fadeAndDestroy(scene, trail, 150);
}

function drawSmokeBomb(scene, skill, profile) {
  const points = targetPoints(skill, 3);
  points.forEach(point => {
    const g = localGraphics(scene, point.x, point.y, 61);
    g.fillStyle(0x111b16, 0.22);
    g.fillCircle(0, 0, 84);
    for (let i = 0; i < 8; i += 1) {
      const angle = i * Math.PI / 4;
      const radius = 18 + (i % 3) * 14;
      g.fillStyle(i % 2 ? profile.color : profile.accent, i % 2 ? 0.2 : 0.13);
      g.fillCircle(Math.cos(angle) * radius, Math.sin(angle) * radius * 0.72, 34 + (i % 3) * 6);
    }
    g.lineStyle(4, profile.accent, 0.38);
    g.strokeCircle(0, 0, 92);
    fadeAndDestroy(scene, g, 520, { scaleX: 1.35, scaleY: 1.35 });
  });
}

function drawSelfAura(scene, skill, profile) {
  const origin = pointFromUnit(skill.owner);
  const g = localGraphics(scene, origin.x, origin.y, 62);
  g.fillStyle(profile.color, 0.08);
  g.fillCircle(0, 0, 96);
  g.lineStyle(5, profile.color, 0.56);
  g.strokeCircle(0, 0, 72);
  g.lineStyle(2, profile.accent, 0.7);
  g.strokeCircle(0, 0, 45);

  if (profile.family === 'timeFold') drawClockTicks(g, profile);
  if (profile.family === 'galeStep') drawWindTrails(g, profile);
  if (profile.family === 'killingFocus') drawFocusSparks(g, profile);
  if (profile.family === 'shadowBreath') drawShadowBreath(g, profile);

  fadeAndDestroy(scene, g, 460, { scaleX: 1.24, scaleY: 1.24 });
}

function drawOrbitBurst(scene, skill, profile) {
  const origin = pointFromUnit(skill.owner);
  for (let i = 0; i < 5; i += 1) {
    const angle = i * Math.PI * 0.4;
    const blade = scene.add.sprite(origin.x + Math.cos(angle) * 80, origin.y + Math.sin(angle) * 44, profile.texture || 'slashBlade');
    blade.setDepth(66 + i);
    blade.setScale(0.52);
    blade.setRotation(angle + Math.PI / 2);
    scene.tweens.add({
      targets: blade,
      x: origin.x + Math.cos(angle + 1.6) * 122,
      y: origin.y + Math.sin(angle + 1.6) * 72,
      rotation: angle + Math.PI * 2.5,
      alpha: 0,
      duration: 430,
      ease: 'Sine.easeOut',
      onComplete: () => blade.destroy(),
    });
  }
  drawSlashFan(scene, skill, { ...profile, slashCount: 2, maxTargets: 3 });
}

function drawLightning(scene, skill, profile) {
  const origin = pointFromUnit(skill.owner);
  const g = scene.add.graphics();
  g.setDepth(67);
  targetPoints(skill, profile.maxTargets || 2).forEach(point => {
    g.lineStyle(6, profile.color, 0.82);
    drawZigzag(g, origin, point, 5, 18);
    g.lineStyle(2, profile.accent, 0.98);
    drawZigzag(g, origin, point, 5, 8);
    const pulse = localGraphics(scene, point.x, point.y, 68);
    pulse.lineStyle(3, profile.color, 0.8);
    pulse.strokeCircle(0, 0, 52);
    fadeAndDestroy(scene, pulse, 230, { scaleX: 1.28, scaleY: 1.28 });
  });
  fadeAndDestroy(scene, g, 190);
}

function drawFlameGround(scene, skill, profile) {
  targetPoints(skill, 3).forEach(point => {
    const g = localGraphics(scene, point.x, point.y, 60);
    g.fillStyle(profile.color, 0.18);
    g.fillCircle(0, 0, 92);
    for (let i = 0; i < 9; i += 1) {
      const angle = i * Math.PI * 2 / 9;
      const x = Math.cos(angle) * (24 + (i % 3) * 12);
      const y = Math.sin(angle) * (18 + (i % 3) * 9);
      g.fillStyle(i % 2 ? profile.accent : profile.color, 0.62);
      g.fillTriangle(x - 10, y + 20, x, y - 32, x + 12, y + 20);
    }
    g.lineStyle(4, profile.accent, 0.5);
    g.strokeCircle(0, 0, 98);
    fadeAndDestroy(scene, g, 620, { scaleX: 1.12, scaleY: 1.12 });
  });
}

function drawNeedlePierce(scene, skill, profile) {
  const origin = pointFromUnit(skill.owner);
  const target = targetPoints(skill, 1)[0] || origin;
  const g = scene.add.graphics();
  g.setDepth(68);
  for (let i = 0; i < 5; i += 1) {
    const offset = (i - 2) * 12;
    const start = { x: origin.x + offset, y: origin.y - 22 - i * 7 };
    const end = { x: target.x + offset * 0.35, y: target.y + offset * 0.18 };
    g.lineStyle(i === 2 ? 5 : 3, i === 2 ? profile.accent : profile.color, 0.86);
    g.lineBetween(start.x, start.y, end.x, end.y);
  }
  const frost = localGraphics(scene, target.x, target.y, 67);
  frost.lineStyle(3, profile.color, 0.72);
  frost.strokeCircle(0, 0, 56);
  frost.lineStyle(2, profile.accent, 0.58);
  frost.lineBetween(-42, 0, 42, 0);
  frost.lineBetween(0, -42, 0, 42);
  fadeAndDestroy(scene, g, 220);
  fadeAndDestroy(scene, frost, 320, { scaleX: 1.22, scaleY: 1.22 });
}

function drawShadowClone(scene, skill, profile) {
  const origin = pointFromUnit(skill.owner);
  const target = targetPoints(skill, 1)[0] || { x: origin.x + 120, y: origin.y };
  const texture = scene.textures.exists('battleGuardianHero') ? 'battleGuardianHero' : 'guardian';
  for (let i = 0; i < 3; i += 1) {
    const angle = -0.45 + i * 0.45;
    const clone = scene.add.sprite(origin.x - Math.cos(angle) * 36, origin.y - 8 + Math.sin(angle) * 28, texture);
    clone.setDepth(62 + i);
    clone.setAlpha(0.34);
    clone.setTint(profile.color);
    clone.setScale(0.18);
    scene.tweens.add({
      targets: clone,
      x: target.x + Math.cos(angle) * 38,
      y: target.y + Math.sin(angle) * 24,
      alpha: 0,
      duration: 260 + i * 40,
      ease: 'Cubic.easeOut',
      onComplete: () => clone.destroy(),
    });
  }
  drawSlashFan(scene, skill, { ...profile, slashCount: 4, maxTargets: 2 });
}

function drawMoonFlash(scene, skill, profile) {
  targetPoints(skill, profile.maxTargets || 2).forEach((point, index) => {
    const g = localGraphics(scene, point.x, point.y, 69);
    g.lineStyle(8, profile.color, 0.9);
    g.lineBetween(-92, 48, 88, -42);
    g.lineStyle(3, profile.accent, 0.9);
    g.strokeEllipse(0, 0, 170, 72);
    g.lineStyle(2, 0xfff1c8, 0.72);
    g.lineBetween(-70, 22, 58, -22);
    g.setRotation(index * 0.2);
    fadeAndDestroy(scene, g, 260, { scaleX: 1.18, scaleY: 1.18 });
  });
}

function drawSpearRain(scene, skill, profile) {
  const points = targetPoints(skill, 2);
  points.forEach(point => {
    const g = scene.add.graphics();
    g.setDepth(66);
    for (let i = 0; i < 9; i += 1) {
      const x = point.x + (i - 4) * 24;
      const y = point.y - 126 - (i % 3) * 18;
      g.lineStyle(5, i % 2 ? profile.accent : profile.color, 0.78);
      g.lineBetween(x, y, x - 20, point.y + 38);
      g.fillStyle(profile.color, 0.76);
      g.fillTriangle(x - 25, point.y + 34, x - 12, point.y + 52, x - 10, point.y + 26);
    }
    fadeAndDestroy(scene, g, 420);
  });
}

function drawLotusStorm(scene, skill, profile) {
  targetPoints(skill, 1).forEach(point => {
    const g = localGraphics(scene, point.x, point.y, 65);
    g.fillStyle(profile.accent, 0.24);
    g.fillCircle(0, 0, 126);
    for (let i = 0; i < 14; i += 1) {
      const angle = i * Math.PI * 2 / 14;
      const radius = 36 + (i % 4) * 16;
      g.fillStyle(i % 2 ? profile.color : 0x211832, i % 2 ? 0.62 : 0.5);
      g.fillEllipse(Math.cos(angle) * radius, Math.sin(angle) * radius * 0.72, 22, 50);
    }
    g.lineStyle(5, profile.color, 0.42);
    g.strokeCircle(0, 0, 134);
    scene.tweens.add({
      targets: g,
      rotation: Math.PI * 1.5,
      alpha: 0,
      duration: 760,
      ease: 'Sine.easeOut',
      onComplete: () => g.destroy(),
    });
  });
}

function drawWeakPointMark(scene, skill, profile) {
  const target = targetPoints(skill, 1)[0] || pointFromUnit(skill.owner);
  const g = localGraphics(scene, target.x, target.y, 70);
  g.lineStyle(4, profile.color, 0.92);
  g.strokeCircle(0, 0, 58);
  g.strokeCircle(0, 0, 28);
  g.lineStyle(3, profile.accent, 0.82);
  g.lineBetween(-72, 0, -36, 0);
  g.lineBetween(36, 0, 72, 0);
  g.lineBetween(0, -72, 0, -36);
  g.lineBetween(0, 36, 0, 72);
  fadeAndDestroy(scene, g, 520, { scaleX: 1.12, scaleY: 1.12 });
}

function drawClockTicks(g, profile) {
  for (let i = 0; i < 12; i += 1) {
    const angle = i * Math.PI * 2 / 12;
    g.lineStyle(i % 3 === 0 ? 4 : 2, i % 3 === 0 ? profile.accent : profile.color, 0.72);
    g.lineBetween(Math.cos(angle) * 82, Math.sin(angle) * 82, Math.cos(angle) * 98, Math.sin(angle) * 98);
  }
}

function drawWindTrails(g, profile) {
  for (let i = 0; i < 5; i += 1) {
    const y = -44 + i * 22;
    g.lineStyle(4, i % 2 ? profile.color : profile.accent, 0.5);
    g.lineBetween(-94 + i * 10, y, 78 - i * 6, y + 8);
  }
}

function drawFocusSparks(g, profile) {
  for (let i = 0; i < 8; i += 1) {
    const angle = i * Math.PI * 2 / 8;
    const x = Math.cos(angle) * 72;
    const y = Math.sin(angle) * 52;
    g.fillStyle(i % 2 ? profile.color : profile.accent, 0.76);
    g.fillCircle(x, y, i % 2 ? 7 : 5);
  }
}

function drawShadowBreath(g, profile) {
  g.fillStyle(0x111b16, 0.22);
  g.fillCircle(0, 0, 62);
  for (let i = 0; i < 5; i += 1) {
    const angle = -0.6 + i * 0.3;
    g.lineStyle(4, i % 2 ? profile.color : profile.accent, 0.52);
    g.lineBetween(Math.cos(angle) * 14, Math.sin(angle) * 10, Math.cos(angle) * 102, Math.sin(angle) * 62);
  }
}

function targetPoints(skill, maxTargets = 4) {
  const targets = Array.isArray(skill?.targets) ? skill.targets : [];
  const points = targets
    .filter(unit => unit && Number.isFinite(unit.x) && Number.isFinite(unit.y))
    .slice(0, maxTargets)
    .map(pointFromUnit);
  if (!points.length && skill?.owner) points.push(pointFromUnit(skill.owner));
  return points;
}

function pointFromUnit(unit) {
  return {
    x: Number(unit?.x) || 0,
    y: Number(unit?.y) || 0,
  };
}

function localGraphics(scene, x, y, depth) {
  const g = scene.add.graphics();
  g.setPosition(x, y);
  g.setDepth(depth);
  return g;
}

function fadeAndDestroy(scene, target, duration = 240, props = {}) {
  scene.tweens.add({
    targets: target,
    alpha: 0,
    duration,
    ease: 'Quad.easeOut',
    ...props,
    onComplete: () => target.destroy(),
  });
}

function drawZigzag(g, start, end, segments = 5, amplitude = 14) {
  const dx = end.x - start.x;
  const dy = end.y - start.y;
  const len = Math.max(1, Math.hypot(dx, dy));
  const nx = -dy / len;
  const ny = dx / len;
  let prev = start;
  for (let i = 1; i <= segments; i += 1) {
    const t = i / segments;
    const offset = i === segments ? 0 : (i % 2 ? amplitude : -amplitude);
    const next = {
      x: start.x + dx * t + nx * offset,
      y: start.y + dy * t + ny * offset,
    };
    g.lineBetween(prev.x, prev.y, next.x, next.y);
    prev = next;
  }
}

function angleBetween(start, end) {
  const PhaserRef = globalThis.Phaser;
  return PhaserRef?.Math?.Angle?.Between
    ? PhaserRef.Math.Angle.Between(start.x, start.y, end.x, end.y)
    : Math.atan2(end.y - start.y, end.x - start.x);
}
