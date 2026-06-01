import { TEAM, clamp, formatNumber } from './constants.js';

const GOLD_ITEM_ID = 5;
const RUBY_ITEM_ID = 3;
const FREE_RUBY_ITEM_ID = 4;
const EXP_ITEM_ID = 6;
const RESOURCE_REACTION_DELAY_MS = 120;
const RESOURCE_REACTION_CLASS_MS = 620;
const UPGRADE_HOLD_START_MS = 280;
const UPGRADE_HOLD_REPEAT_START_MS = 92;
const UPGRADE_HOLD_REPEAT_MIN_MS = 48;
const MISSION_TARGET = 30;
const MONSTER_SOUL_ITEM_ID = 200108;
const EQUIPMENT_SUMMON_PRODUCT_ID = 200503;
const DEFAULT_EQUIPMENT_SUMMON_COST = 10;
const EQUIPMENT_SUMMON_TIER_WEIGHT_BONUS_PER_LEVEL = 0.22;
const SKILL_TREE_MODAL_ID = 'skills';
const ACHIEVEMENT_MODAL_ID = 'achievements';
const GROWTH_CARDS = [
  { id: 1000, levelId: 'attackLevel', valueId: 'attackStatValue', costId: 'attackCost', statType: 'Attack', label: '공격력', fallbackIcon: '⚔' },
  { id: 1001, levelId: 'hpLevel', valueId: 'hpStatValue', costId: 'hpCost', statType: 'Hp', label: '체력', fallbackIcon: '♥' },
  { id: 1002, levelId: 'goldLevel', valueId: 'goldStatValue', costId: 'goldCost', statType: 'AttackSpeedPercent', label: '공격속도', suffix: '%', fallbackIcon: '↯' },
  { id: 1003, levelId: 'speedLevel', valueId: 'speedStatValue', costId: 'speedCost', statType: 'CriticalDamagePercent', label: '치명피해', suffix: '%', fallbackIcon: '✦' },
];
const EQUIPMENT_SLOTS = [
  { type: 'Head', index: 2, icon: '⛑', emptyLabel: '머리' },
  { type: 'Chest', index: 3, icon: '◇', emptyLabel: '갑옷' },
  { type: 'Boots', index: 5, icon: '◈', emptyLabel: '신발' },
  { type: 'Gloves', index: 6, icon: '✦', emptyLabel: '장갑' },
  { type: 'Necklace', index: 7, icon: '◎', emptyLabel: '목걸이' },
  { type: 'Ring', index: [9, 10], icon: '●', emptyLabel: '반지' },
];
const STAT_LABELS = {
  Power: '전투력',
  Attack: '공격',
  Hp: '체력',
  Defense: '방어',
  MoveSpeed: '이속',
  AttackSpeedPercent: '공속',
  CriticalPercent: '치확',
  CriticalDamagePercent: '치피',
  CooldownPercent: '쿨감',
  ItemDropPercent: '드롭',
  ExpPercent: '경험',
  BossDamageEfficiencyPercent: '보스',
  MonsterDamageEfficiencyPercent: '몬스터',
};
const STAT_PRIORITY = [
  'Power',
  'Attack',
  'Hp',
  'Defense',
  'CriticalPercent',
  'CriticalDamagePercent',
  'AttackSpeedPercent',
  'MoveSpeed',
  'CooldownPercent',
  'ItemDropPercent',
  'ExpPercent',
  'BossDamageEfficiencyPercent',
  'MonsterDamageEfficiencyPercent',
];

export function attachHud(board, store, options = {}) {
  const el = id => document.getElementById(id);
  const logEl = el('eventLog');
  const logs = [];
  const resourceGainBatch = new Map();
  const resourceGainTimers = new Map();
  let killCount = 0;
  let localAvatar = null;
  let pendingEquipmentChoice = null;
  const unseenAchievements = new Set();

  function text(id, value) {
    const node = el(id);
    if (node) node.textContent = String(value);
  }

  function width(id, pct) {
    const node = el(id);
    if (node) node.style.width = `${clamp(pct, 0, 1) * 100}%`;
  }

  function playSfx(name, sfxOptions = {}) {
    const audio = options.audio || globalThis.__MUSHROOMER_PHASER_AUDIO__ || globalThis.__IDLEZ_PHASER_AUDIO__;
    return audio?.play?.(name, sfxOptions) ?? false;
  }

  function log(message, type = 'info') {
    logs.unshift({ message, type });
    while (logs.length > 3) logs.pop();
    logEl.innerHTML = logs.map(entry => (
      `<div class="log-entry log-${entry.type}">${escapeHtml(entry.message)}</div>`
    )).join('');
  }

  function queueResourceReaction(itemDataId, count) {
    const id = Number(itemDataId);
    if (id !== GOLD_ITEM_ID && id !== EXP_ITEM_ID) return;

    const amount = Math.max(0, Math.floor(Number(count) || 0));
    if (amount <= 0) return;

    resourceGainBatch.set(id, (resourceGainBatch.get(id) || 0) + amount);
    if (resourceGainTimers.has(id)) return;

    const timer = setTimeout(() => flushResourceReaction(id), RESOURCE_REACTION_DELAY_MS);
    resourceGainTimers.set(id, timer);
  }

  function flushResourceReaction(itemDataId) {
    const id = Number(itemDataId);
    const timer = resourceGainTimers.get(id);
    if (timer) clearTimeout(timer);
    resourceGainTimers.delete(id);

    const amount = resourceGainBatch.get(id) || 0;
    resourceGainBatch.delete(id);
    if (amount <= 0) return;

    reactToResourceGain(id, amount);
  }

  function reactToResourceGain(itemDataId, amount) {
    const host = itemDataId === GOLD_ITEM_ID
      ? document.querySelector('.top-gold')
      : el('expHud');
    if (!host) return;

    host.classList.remove('is-gain');
    void host.offsetWidth;
    host.classList.add('is-gain');
    setTimeout(() => host.classList.remove('is-gain'), RESOURCE_REACTION_CLASS_MS);

    host.querySelectorAll(`.hud-gain-badge[data-resource-id="${itemDataId}"]`).forEach(node => node.remove());
    const badge = document.createElement('span');
    badge.className = `hud-gain-badge ${itemDataId === GOLD_ITEM_ID ? 'hud-gain-gold' : 'hud-gain-exp'}`;
    badge.dataset.resourceId = String(itemDataId);
    badge.textContent = `+${formatNumber(amount)}${itemDataId === EXP_ITEM_ID ? ' XP' : ''}`;
    host.append(badge);
    setTimeout(() => badge.remove(), 940);
  }

  function render() {
    const player = board.playerUnit;
    const enemies = board.enemyUnits;
    const mapName = board.map?.name || '-';
    const mainStageNo = store.getMainStageNumber?.(board.map);
    const mainStageLabel = Number.isFinite(mainStageNo) ? `${String(mainStageNo).padStart(2, '0')}단계` : null;
    const displayMapName = mainStageLabel ? `${mainStageLabel} · ${mapName}` : mapName;
    const state = Math.max(1, board.boardState || 1);
    const waveMax = Math.max(1, Math.floor(Number(board.map?.popupArgs?.ClientWaveCount) || 10));
    const stageStep = clamp(state, 1, waveMax);
    const stageCode = board.map?.tags?.includes('WeekdayDungeon')
      ? `D-${stageStep}`
      : `${mainStageNo || 1}-${stageStep}`;
    const playerLevel = player ? Math.max(player.level, state) : state;
    const exp = board.exp;
    const expPct = (exp % 100) / 100;
    const wavePct = stageStep / waveMax;
    const combatPower = player
      ? Math.round(player.attack * 12 + player.maxHp * 0.42 + player.defense * 18)
      : 0;
    const hpText = player ? `${formatNumber(player.hp)} / ${formatNumber(player.maxHp)}` : '-';
    const missionPct = killCount / MISSION_TARGET;
    const missionDone = killCount >= MISSION_TARGET;

    text('mapName', displayMapName);
    text('levelValue', playerLevel);
    text('stageCode', stageCode);
    text('waveProgress', `${stageStep} / ${waveMax}`);
    text('tickValue', board.tick);
    text('stateValue', board.boardState);
    text('goldValue', formatNumber(board.gold));
    text('dockGoldValue', formatNumber(board.gold));
    text('expValue', `${Math.floor(expPct * 100)}%`);
    text('gemValue', formatNumber((board.inventory.get(RUBY_ITEM_ID) || 0) + (board.inventory.get(FREE_RUBY_ITEM_ID) || 0)));
    text('enemyValue', enemies.length);
    text('hpValue', hpText);
    text('dockHpValue', player ? formatNumber(player.hp) : '-');
    text('atkValue', player ? formatNumber(player.attack) : '-');
    text('defValue', player ? formatNumber(player.defense) : '-');
    text('combatPowerValue', formatNumber(combatPower));
    text('missionTitle', missionDone ? '미션 완료!' : '미션 진행');
    text('missionKill', `${Math.min(killCount, MISSION_TARGET)} / ${MISSION_TARGET}`);
    text('missionRewardGold', formatNumber(100 + killCount * 5));
    text('rewardValue', formatNumber(Math.max(100, board.gold + exp + 100)));

    width('expBarFill', expPct);
    width('waveBarFill', wavePct);

    renderGrowthCards(board, player, store);
    renderSkillQuickbar(board);
    renderAchievementButton(board, store, unseenAchievements);
    renderEquipmentSummon(board, store);
    renderEquipmentSlots(store, currentAvatar());
    renderEquipmentChoice(pendingEquipmentChoice);
    renderUnitTable(board);
    el('missionCard')?.classList.toggle('is-complete', missionDone);
    el('eventLog')?.style.setProperty('--mission-pct', missionPct);
  }

  function currentAvatar() {
    return options.getAvatar?.() || localAvatar;
  }

  function ensureAvatar() {
    const sessionAvatar = options.getAvatar?.();
    if (sessionAvatar) return sessionAvatar;
    localAvatar ||= { equipments: [] };
    return localAvatar;
  }

  board.on('boardStarted', () => {
    killCount = 0;
    log(`${board.map.name} 시작`, 'boot');
    render();
  });
  board.on('waveStarted', ({ boardState }) => log(`웨이브 ${boardState} 시작`, 'wave'));
  board.on('waveQueued', () => log('다음 웨이브 진입', 'wave'));
  board.on('boardStateChanged', ({ current }) => {
    log(`스테이지 ${current}`, 'state');
    render();
  });
  board.on('unitSpawned', unit => {
    if (unit.team === TEAM.ENEMY) log(`${unit.name} 등장`, unit.type === 'Boss' ? 'boss' : 'spawn');
    render();
  });
  board.on('unitDied', ({ unit }) => {
    if (unit.team === TEAM.ENEMY) {
      killCount += 1;
      log(`${unit.name} 처치`, 'kill');
    }
    render();
  });
  board.on('playerDefeated', () => {
    log('플레이어 다운', 'warn');
    render();
  });
  board.on('unitRevived', unit => {
    if (unit.team === TEAM.PLAYER) log('플레이어 부활', 'boot');
    render();
  });
  board.on('itemGained', ({ itemDataId, item, count }) => {
    render();
    queueResourceReaction(itemDataId ?? item?.id, count);
  });
  board.on('itemSpent', render);
  board.on('inventorySynced', render);
  board.on('itemLevelUp', ({ item, level }) => {
    log(`${item.name} Lv.${level}`, 'loot');
    render();
  });
  board.on('skillUnlocked', ({ item }) => {
    log(`${item.name} 해금`, 'loot');
    render();
  });
  board.on('skillEquipped', ({ item, slotIndex }) => {
    log(`${slotIndex + 1}번 슬롯 · ${item.name}`, 'loot');
    render();
  });
  board.on('skillSlotCountChanged', ({ count }) => {
    log(`스킬 슬롯 ${count}개 해금`, 'loot');
    render();
  });
  board.on('achievementCompleted', ({ achievement }) => {
    if (achievement?.tags?.includes('EquipmentSummonPrice')) {
      log(`장비 소환 Lv.${equipmentSummonLevel(board, store.getItem(EQUIPMENT_SUMMON_PRODUCT_ID))} 도달`, 'loot');
    } else if (isVisibleAchievement(achievement)) {
      unseenAchievements.add(Number(achievement.id));
      playSfx('reward', { volume: 0.66 });
      log(`업적 완료 · ${achievement.name}`, 'loot');
    }
    render();
  });
  board.on('autoSkillsChanged', ({ enabled }) => {
    log(enabled ? '자동 스킬 ON' : '자동 스킬 OFF', enabled ? 'boot' : 'warn');
    render();
  });
  board.on('gameEnded', ({ winningTeam }) => {
    log(`전투 종료 · 승리 팀 ${winningTeam}`, 'clear');
    render();
  });
  board.on('warning', message => log(message, 'warn'));
  board.on('tick', render);

  el('equipmentSummonBtn')?.addEventListener('click', () => {
    if (pendingEquipmentChoice) {
      playSfx('uiError');
      log('먼저 장비를 선택해 주세요', 'warn');
      render();
      return;
    }

    const result = summonEquipment(board, store, ensureAvatar());
    if (result.ok) {
      if (result.choice) {
        pendingEquipmentChoice = result.choice;
        log(`${result.item.name} 선택 필요`, 'loot');
      } else {
        log(`${result.item.name} 장착`, 'loot');
      }
    } else {
      playSfx('uiError');
      log(result.message, 'warn');
    }
    render();
  });
  el('equipmentChoiceCards')?.addEventListener('click', event => {
    const button = event.target.closest?.('[data-equipment-choice-action]');
    const action = button?.dataset?.equipmentChoiceAction;
    if (!action || !pendingEquipmentChoice) return;

    const choice = pendingEquipmentChoice;
    pendingEquipmentChoice = null;
    const result = resolveEquipmentChoice(board, choice, action);
    playSfx('reward', { volume: 0.72 });
    log(result.message, 'loot');
    render();
  });
  el('skillQuickbar')?.addEventListener('click', event => {
    const button = event.target.closest?.('[data-skill-slot-index]');
    if (!button) return;
    const slotIndex = Number(button.dataset.skillSlotIndex || 0);
    globalThis.dispatchEvent(new CustomEvent('mushroomer:open-modal', {
      detail: { id: SKILL_TREE_MODAL_ID, payload: { slotIndex } },
    }));
  });
  document.querySelectorAll(`[data-modal-id="${ACHIEVEMENT_MODAL_ID}"]`).forEach(node => {
    node.addEventListener('click', () => {
      unseenAchievements.clear();
      renderAchievementButton(board, store, unseenAchievements);
    });
  });

  const upgrade = options.onUpgradeItem || (id => board.levelUpItem(id));
  document.querySelectorAll('[data-upgrade-item-id]').forEach(node => {
    bindHoldRepeatUpgrade(node, {
      canRepeatUpgrade: () => node.classList.contains('is-affordable') && !node.classList.contains('is-maxed'),
      performUpgrade: async ({ repeat = false } = {}) => {
        const itemDataId = Number(node.dataset.upgradeItemId);
        try {
          const result = await Promise.resolve(upgrade(itemDataId));
          if (isUpgradeFailure(result)) {
            if (!repeat || !isExpectedRepeatStop(result)) {
              playSfx('uiError');
              log(upgradeFailureMessage(result), 'warn');
            }
            render();
            return false;
          }
          render();
          return true;
        } catch (error) {
          playSfx('uiError');
          log(error?.message || String(error), 'warn');
          render();
          return false;
        }
      },
    });
  });
  render();
}

function bindHoldRepeatUpgrade(node, { performUpgrade, canRepeatUpgrade }) {
  let holdTimer = 0;
  let repeatTimer = 0;
  let pointerId = null;
  let pressing = false;
  let holding = false;
  let pending = false;
  let suppressNextClick = false;
  let repeatCount = 0;
  let actionToken = 0;

  const clearTimers = () => {
    if (holdTimer) globalThis.clearTimeout(holdTimer);
    if (repeatTimer) globalThis.clearTimeout(repeatTimer);
    holdTimer = 0;
    repeatTimer = 0;
  };

  const stop = ({ keepClickSuppressed = false } = {}) => {
    actionToken += 1;
    clearTimers();
    pressing = false;
    holding = false;
    pending = false;
    repeatCount = 0;
    node.classList.remove('is-pressing', 'is-holding');
    if (!keepClickSuppressed) suppressNextClick = false;
    if (pointerId !== null && node.hasPointerCapture?.(pointerId)) {
      try {
        node.releasePointerCapture(pointerId);
      } catch {
        // Pointer capture can already be gone after browser-level cancellation.
      }
    }
    pointerId = null;
  };

  const runUpgrade = async ({ repeat = false } = {}) => {
    if (pending) return;
    if (repeat && !canRepeatUpgrade()) {
      stop({ keepClickSuppressed: true });
      return;
    }

    const token = actionToken;
    pending = true;
    const ok = await performUpgrade({ repeat });
    if (token !== actionToken) return;
    pending = false;

    if (!ok) {
      stop({ keepClickSuppressed: true });
      return;
    }

    if (!holding || !pressing) return;
    repeatCount += 1;
    repeatTimer = globalThis.setTimeout(
      () => runUpgrade({ repeat: true }),
      holdRepeatDelay(repeatCount),
    );
  };

  const startHolding = () => {
    if (!pressing || holding) return;
    holding = true;
    suppressNextClick = true;
    repeatCount = 0;
    node.classList.add('is-holding');
    runUpgrade({ repeat: false });
  };

  node.addEventListener('pointerdown', event => {
    if (event.button !== undefined && event.button !== 0) return;
    stop({ keepClickSuppressed: false });
    pressing = true;
    pointerId = event.pointerId;
    node.classList.add('is-pressing');
    node.setPointerCapture?.(event.pointerId);
    holdTimer = globalThis.setTimeout(startHolding, UPGRADE_HOLD_START_MS);
  });

  node.addEventListener('pointerup', event => {
    if (pointerId !== null && event.pointerId !== pointerId) return;
    stop({ keepClickSuppressed: holding || suppressNextClick });
  });

  node.addEventListener('pointercancel', event => {
    if (pointerId !== null && event.pointerId !== pointerId) return;
    stop({ keepClickSuppressed: false });
  });

  node.addEventListener('contextmenu', event => {
    if (!pressing && !holding) return;
    event.preventDefault();
  });

  node.addEventListener('click', event => {
    if (suppressNextClick) {
      suppressNextClick = false;
      event.preventDefault();
      event.stopPropagation();
      return;
    }
    runUpgrade({ repeat: false });
  });

  node.addEventListener('keydown', event => {
    if (event.key !== 'Enter' && event.key !== ' ') return;
    event.preventDefault();
    runUpgrade({ repeat: false });
  });
}

function holdRepeatDelay(repeatCount) {
  return Math.max(
    UPGRADE_HOLD_REPEAT_MIN_MS,
    UPGRADE_HOLD_REPEAT_START_MS - Math.floor(Math.max(0, repeatCount - 1) / 4) * 10,
  );
}

function isUpgradeFailure(result) {
  if (!result) return false;
  if (result.ok === false) return true;
  if (Object.prototype.hasOwnProperty.call(result, 'status')) {
    const status = Number(result.status);
    return Number.isFinite(status) && status !== 0;
  }
  return false;
}

function isExpectedRepeatStop(result) {
  const reason = String(result?.reason || '');
  return reason === 'not_enough_gold' || reason === 'max_level' || reason === 'missing_cost';
}

function upgradeFailureMessage(result) {
  if (result?.message) return result.message;
  const status = Number(result?.status);
  if (Number.isFinite(status)) return `강화 실패: ${status}`;
  return '강화 실패';
}

function renderSkillQuickbar(board) {
  const root = document.getElementById('skillQuickbar');
  if (!root || !board.getSkillSlotStates) return;

  const slots = board.getSkillSlotStates();
  root.classList.toggle('is-auto-off', !board.autoSkillsEnabled);
  root.setAttribute('aria-label', `스킬 슬롯 ${board.skillSlotCount}/${board.maxSkillSlots}`);
  setHtml('skillQuickbar', slots.map(slot => skillSlotHtml(slot)).join(''));
}

function renderAchievementButton(board, store, unseenAchievements = new Set()) {
  const button = document.querySelector(`[data-modal-id="${ACHIEVEMENT_MODAL_ID}"]`);
  if (!button) return;

  const achievements = visibleAchievements(store);
  const total = achievements.length;
  const completed = achievements.filter(achievement => (
    board?.getAchievementProgress?.(achievement)?.completed
  )).length;
  const hasUnseen = [...unseenAchievements].some(id => Number.isFinite(id) && id > 0);

  button.classList.toggle('is-alert', hasUnseen);
  button.setAttribute('aria-label', hasUnseen
    ? `업적 열기 새 완료 ${completed}/${total}`
    : `업적 열기 ${completed}/${total}`);
  button.title = `업적 ${completed}/${total}`;
}

function skillSlotHtml(slot) {
  const locked = !slot.unlocked;
  const item = slot.item;
  const skill = slot.skill;
  const cooldownPct = slot.cooldownTicks > 0 && skill?.cooldown
    ? clamp(slot.cooldownSeconds / Number(skill.cooldown || 1), 0, 1)
    : 0;
  const unlockLevel = slot.unlock?.level || 1;
  const label = locked
    ? `Lv.${unlockLevel}`
    : item
      ? compactSkillName(item.name)
      : '빈 슬롯';
  const meta = locked
    ? '잠김'
    : item
      ? `Lv.${slot.level}`
      : '장착';
  const icon = item ? skillIconHtml(item) : (locked ? '🔒' : '+');

  return `
    <button class="skill-slot${locked ? ' is-locked' : ''}${item ? ' is-equipped' : ' is-empty'}${slot.cooldownTicks > 0 ? ' is-cooldown' : ''}" type="button" data-skill-slot-index="${slot.index}" aria-label="${escapeHtml(label)} ${escapeHtml(meta)}">
      <span class="skill-slot-icon">${icon}</span>
      <span class="skill-slot-copy">
        <b>${escapeHtml(label)}</b>
        <small>${escapeHtml(meta)}</small>
      </span>
      <span class="skill-cooldown-mask" style="transform: scaleY(${cooldownPct})"></span>
    </button>
  `;
}

function compactSkillName(name) {
  const cleaned = String(name || '스킬').replace(/\s+/g, '');
  return cleaned.length > 5 ? cleaned.slice(0, 5) : cleaned;
}

function skillIconHtml(item) {
  const src = itemSpriteUrl(item);
  if (src) return `<img class="skill-icon-img" src="${escapeHtml(src)}" alt="" loading="lazy" decoding="async">`;
  return escapeHtml(skillInitial(item?.name));
}

function skillInitial(name) {
  const chars = String(name || '스').replace(/\s+/g, '');
  return chars.slice(0, 1) || '스';
}

function renderEquipmentSummon(board, store) {
  const souls = board.inventory.get(MONSTER_SOUL_ITEM_ID) || 0;
  const product = store.getItem(EQUIPMENT_SUMMON_PRODUCT_ID);
  const cost = equipmentSummonCost(board, store, product);
  const summonLevel = equipmentSummonLevel(board, product);
  const canSummon = souls >= cost;
  const button = document.getElementById('equipmentSummonBtn');
  const pill = document.getElementById('equipmentSummonPrice');

  setText('equipmentSummonLevel', `Lv.${summonLevel}`);
  setText('monsterSoulValue', formatNumber(souls));
  setText('equipmentSummonCost', formatNumber(cost));
  button?.classList.toggle('is-affordable', canSummon);
  button?.setAttribute('aria-label', `장비 소환 Lv.${summonLevel} ${formatNumber(souls)}/${formatNumber(cost)}`);
  pill?.classList.toggle('is-affordable', canSummon);
}

function summonEquipment(board, store, avatar) {
  const product = store.getItem(EQUIPMENT_SUMMON_PRODUCT_ID);
  if (!product) return { ok: false, message: '장비 소환 상품 없음' };

  const cost = equipmentSummonCost(board, store, product);
  const summonLevel = equipmentSummonLevel(board, product);
  const souls = board.inventory.get(MONSTER_SOUL_ITEM_ID) || 0;
  if (souls < cost) {
    return { ok: false, message: `몬스터의 혼 부족 ${formatNumber(souls)}/${formatNumber(cost)}` };
  }

  const reward = pickEquipmentSummonReward(product, store, summonLevel);
  if (!reward) return { ok: false, message: '소환 가능한 장비 없음' };

  const item = store.getItem(reward.itemDataId);
  const count = Math.max(1, Math.floor(Number(reward.count || 1)));
  const spent = board.spendItem(MONSTER_SOUL_ITEM_ID, cost, `summon:${EQUIPMENT_SUMMON_PRODUCT_ID}`);
  if (spent < cost) return { ok: false, message: `몬스터의 혼 부족 ${formatNumber(souls)}/${formatNumber(cost)}` };

  board.addItem(item.id, count, `summon:${EQUIPMENT_SUMMON_PRODUCT_ID}`);
  board.recordProductBuy?.(EQUIPMENT_SUMMON_PRODUCT_ID, 1);
  const equipResult = equipAvatarItem(avatar, store, item, { deferConflict: true });
  if (equipResult.choice) return { ok: true, item, count, cost, choice: equipResult.choice };
  return { ok: true, item, count, cost };
}

function equipmentSummonLevel(board, product) {
  const targetAchievementDataIds = productTargetAchievementDataIds(product);
  if (targetAchievementDataIds.length > 0) {
    return 1 + board.countCompletedAchievements(targetAchievementDataIds);
  }

  const scaling = product?.summonCostScaling || product?.SummonCostScaling;
  const everyPurchases = Math.floor(Number(scaling?.everyPurchases || scaling?.EveryPurchases || 0));
  if (everyPurchases > 0) {
    const summonCount = board.getProductBuyCount?.(EQUIPMENT_SUMMON_PRODUCT_ID) || 0;
    return 1 + Math.floor(Math.max(0, summonCount) / everyPurchases);
  }

  return 1;
}

function equipmentSummonCost(board, store, product = null) {
  product ??= store.getItem(EQUIPMENT_SUMMON_PRODUCT_ID);
  const material = firstProductMaterial(product, MONSTER_SOUL_ITEM_ID);
  const baseCost = Math.max(1, Math.floor(Number(material?.count || DEFAULT_EQUIPMENT_SUMMON_COST)));
  const scaling = product?.summonCostScaling || product?.SummonCostScaling;
  const everyPurchases = Math.floor(Number(scaling?.everyPurchases || scaling?.EveryPurchases || 0));
  const addMaterialCount = equipmentSummonCostStep(product, scaling);
  const targetAchievementDataIds = productTargetAchievementDataIds(product);

  if (targetAchievementDataIds.length > 0 && addMaterialCount > 0) {
    return baseCost + board.countCompletedAchievements(targetAchievementDataIds) * addMaterialCount;
  }

  if (everyPurchases > 0 && addMaterialCount > 0) {
    const summonCount = board.getProductBuyCount?.(EQUIPMENT_SUMMON_PRODUCT_ID) || 0;
    return baseCost + Math.floor(Math.max(0, summonCount) / everyPurchases) * addMaterialCount;
  }

  return baseCost;
}

function productTargetAchievementDataIds(product) {
  const ids = product?.targetAchievementDataIds || product?.TargetAchievementDataIds || [];
  return Array.isArray(ids) ? ids : [];
}

function equipmentSummonCostStep(product, scaling = null) {
  return Math.max(0, Math.floor(Number(
    product?.regenCount ?? product?.RegenCount ?? scaling?.addMaterialCount ?? scaling?.AddMaterialCount ?? 0
  )));
}

function firstProductMaterial(product, itemDataId) {
  for (const group of product?.productMaterialItemGroups || product?.ProductMaterialItemGroups || []) {
    const material = (group.materialItems || group.MaterialItems || [])
      .find(entry => Number(entry.id ?? entry.itemDataId ?? entry.ItemDataId) === itemDataId);
    if (material) return material;
  }
  return null;
}

function pickEquipmentSummonReward(product, store, summonLevel = 1) {
  const groups = product.addItemGroups || product.AddItemGroups || [];
  const rewardGroups = equipmentSummonRewardGroups(groups, summonLevel);
  const group = rewardGroups.find(entry => Number(entry.probPercent ?? entry.ProbPercent ?? 100) > 0) || rewardGroups[0];
  const rewards = (group?.addItems || group?.AddItems || [])
    .map(entry => ({ ...entry, itemDataId: Number(entry.itemDataId ?? entry.ItemDataId) }))
    .filter(entry => store.getItem(entry.itemDataId)?.category === 'Equipment')
    .map(entry => ({
      ...entry,
      effectiveWeight: equipmentSummonRewardWeight(entry, store.getItem(entry.itemDataId), summonLevel),
    }));

  if (rewards.length === 0) return null;

  const totalWeight = rewards.reduce((sum, entry) => sum + entry.effectiveWeight, 0);
  let roll = Math.random() * (totalWeight || rewards.length);
  for (const reward of rewards) {
    roll -= totalWeight ? reward.effectiveWeight : 1;
    if (roll <= 0) return reward;
  }
  return rewards[rewards.length - 1];
}

function equipmentSummonRewardGroups(groups, summonLevel) {
  const exactLevelGroups = groups.filter(group => Math.floor(Number(group.level ?? group.Level ?? 0)) === summonLevel);
  if (exactLevelGroups.length > 0) return exactLevelGroups;

  const baseGroups = groups.filter(group => Math.floor(Number(group.level ?? group.Level ?? 0)) === 0);
  return baseGroups.length > 0 ? baseGroups : groups;
}

function equipmentSummonRewardWeight(entry, item, summonLevel) {
  const baseWeight = Math.max(0, Number(entry.weight ?? entry.Weight ?? 1));
  const tierLift = Math.max(0, equipmentSummonTierRank(item) - 1);
  const levelLift = Math.max(0, Math.floor(Number(summonLevel || 1)) - 1);
  return baseWeight * (1 + levelLift * tierLift * EQUIPMENT_SUMMON_TIER_WEIGHT_BONUS_PER_LEVEL);
}

function equipmentSummonTierRank(item) {
  return Math.max(1, Math.floor(Number(
    item?.tier || item?.Tier || item?.grade || item?.Grade || item?.rarity || item?.Rarity || 1
  )));
}

function equipAvatarItem(avatar, store, item, { deferConflict = false } = {}) {
  const slotSpec = EQUIPMENT_SLOTS.find(spec => spec.type === item.type);
  if (!slotSpec) return { equipped: false };

  const equipments = writableEquipmentsForAvatar(avatar);
  const slotIndex = pickWritableSlotIndex(equipments, slotSpec.index);
  const currentMessage = equipmentAt(equipments, slotIndex);
  const currentItemDataId = playerItemDataId(currentMessage);
  const currentItem = currentItemDataId ? store.getItem(currentItemDataId) : null;
  const newMessage = createPlayerItemMessage(item.id);

  if (deferConflict && currentItem) {
    return {
      equipped: false,
      choice: {
        avatar,
        slotIndex,
        slotLabel: slotSpec.emptyLabel,
        currentItem,
        currentMessage,
        newItem: item,
        newMessage,
      },
    };
  }

  equipments[slotIndex] = newMessage;
  return { equipped: true, slotIndex };
}

function writableEquipmentsForAvatar(avatar) {
  const source = avatar.equipments || avatar.Equipments;
  if (Array.isArray(source)) {
    avatar.equipments = source;
    avatar.Equipments = source;
    return source;
  }

  const equipments = [];
  if (source && typeof source === 'object') {
    for (const [key, value] of Object.entries(source)) {
      const index = Number(key);
      if (Number.isInteger(index) && index >= 0) equipments[index] = value;
      else equipments.push(value);
    }
  }

  avatar.equipments = equipments;
  avatar.Equipments = equipments;
  return equipments;
}

function pickWritableSlotIndex(equipments, slotIndex) {
  const indices = Array.isArray(slotIndex) ? slotIndex : [slotIndex];
  return indices.find(index => !playerItemDataId(equipmentAt(equipments, index))) || indices[0];
}

function createPlayerItemMessage(itemDataId) {
  return {
    id: Date.now() + Math.floor(Math.random() * 100000),
    itemDataId,
    count: 1,
    level: 1,
  };
}

function renderEquipmentChoice(choice) {
  const root = document.getElementById('equipmentChoice');
  if (!root) return;

  root.hidden = !choice;
  if (!choice) {
    setText('equipmentChoiceSubtitle', '');
    root.dataset.choiceKey = '';
    const cardsNode = document.getElementById('equipmentChoiceCards');
    if (cardsNode?.innerHTML) cardsNode.innerHTML = '';
    return;
  }

  setText('equipmentChoiceSubtitle', `${choice.slotLabel} 슬롯에 이미 장착 중`);
  const choiceKey = equipmentChoiceKey(choice);
  if (root.dataset.choiceKey === choiceKey) return;
  root.dataset.choiceKey = choiceKey;
  setHtml('equipmentChoiceCards', [
    equipmentChoiceCardHtml({
      action: 'current',
      badge: '현재 유지',
      item: choice.currentItem,
      message: choice.currentMessage,
      otherItem: choice.newItem,
      otherMessage: choice.newMessage,
      sellItem: choice.newItem,
      note: '새 장비 판매',
    }),
    equipmentChoiceCardHtml({
      action: 'new',
      badge: '새 장착',
      item: choice.newItem,
      message: choice.newMessage,
      otherItem: choice.currentItem,
      otherMessage: choice.currentMessage,
      sellItem: choice.currentItem,
      note: '현재 장비 판매',
      isNew: true,
    }),
  ].join(''));
}

function equipmentChoiceKey(choice) {
  return [
    choice.slotIndex,
    playerItemDataId(choice.currentMessage),
    choice.currentMessage?.id || choice.currentMessage?.Id || 0,
    playerItemDataId(choice.newMessage),
    choice.newMessage?.id || choice.newMessage?.Id || 0,
  ].join(':');
}

function equipmentChoiceCardHtml({ action, badge, item, message, otherItem, otherMessage, sellItem, note, isNew = false }) {
  const rows = equipmentCompareRows(item, message, otherItem, otherMessage);
  const sellPrice = equipmentSellPrice(sellItem);
  const slotSpec = slotSpecForItem(item);
  return `
    <button class="equipment-choice-card${isNew ? ' is-new' : ''}" type="button" data-equipment-choice-action="${action}">
      <span class="choice-badge">${escapeHtml(badge)}</span>
      <span class="choice-item-row">
        <span class="choice-mini-icon" aria-hidden="true">${iconHtmlForEquipment(item, slotSpec, 'choice-item-img')}</span>
        <span class="choice-name">${escapeHtml(item?.name || '장비')}</span>
      </span>
      <span class="choice-stats">${rows.map(equipmentStatRowHtml).join('')}</span>
      <span class="choice-sell">${escapeHtml(note)} +${formatNumber(sellPrice)}</span>
    </button>
  `;
}

function equipmentStatRowHtml(row) {
  const deltaClass = row.delta > 0 ? 'is-up' : row.delta < 0 ? 'is-down' : 'is-even';
  const deltaText = row.delta === 0 ? '0' : `${row.delta > 0 ? '+' : ''}${formatStatValue(row.delta, row.type)}`;
  return `
    <span class="choice-stat">
      <span>${escapeHtml(statLabel(row.type))}</span>
      <b>${escapeHtml(formatStatValue(row.value, row.type))}</b>
      <em class="${deltaClass}">${escapeHtml(deltaText)}</em>
    </span>
  `;
}

function equipmentCompareRows(item, message, otherItem, otherMessage) {
  const stats = equipmentStatMap(item, message);
  const otherStats = equipmentStatMap(otherItem, otherMessage);
  const types = [...new Set([...stats.keys(), ...otherStats.keys()])];
  const rows = types.map(type => {
    const value = stats.get(type) || 0;
    const otherValue = otherStats.get(type) || 0;
    return { type, value, delta: value - otherValue };
  });

  return rows
    .sort((a, b) => statSortScore(a) - statSortScore(b))
    .slice(0, 4);
}

function statSortScore(row) {
  const priority = STAT_PRIORITY.includes(row.type) ? STAT_PRIORITY.indexOf(row.type) : STAT_PRIORITY.length;
  return priority * 100000 - Math.abs(row.delta);
}

function equipmentStatMap(item, message) {
  const map = new Map();
  if (!item) return map;

  const level = Math.max(1, Number(message?.level || message?.Level || 1));
  addStatValue(map, 'Power', Number(item.power || item.Power || 0));
  for (const stat of item.equipAddStats || item.EquipAddStats || []) {
    addStatValue(map, stat.type || stat.Type || 'Hp', statValueAtLevel(stat.value ?? stat.Value, level));
  }
  return map;
}

function addStatValue(map, type, value) {
  const amount = Number(value || 0);
  if (!Number.isFinite(amount) || amount === 0) return;
  map.set(type, (map.get(type) || 0) + amount);
}

function statValueAtLevel(rawValue, level = 1) {
  if (Array.isArray(rawValue)) {
    return Number(rawValue[Math.min(rawValue.length - 1, Math.max(0, level - 1))] || 0);
  }
  return Number(rawValue || 0);
}

function statLabel(type) {
  return STAT_LABELS[type] || type;
}

function formatStatValue(value, type) {
  const abs = Math.abs(Number(value) || 0);
  const suffix = statSuffix(type);
  if (abs >= 1000) return `${formatNumber(value)}${suffix}`;
  const rounded = Math.round((Number(value) || 0) * 10) / 10;
  return `${Number.isInteger(rounded) ? rounded : rounded.toFixed(1)}${suffix}`;
}

function statSuffix(type) {
  return String(type).includes('Percent') ? '%' : '';
}

function resolveEquipmentChoice(board, choice, action) {
  const keepNew = action === 'new';
  const avatarEquipments = writableEquipmentsForAvatar(choice.avatar);
  const equippedItem = keepNew ? choice.newItem : choice.currentItem;
  const soldItem = keepNew ? choice.currentItem : choice.newItem;
  if (keepNew) avatarEquipments[choice.slotIndex] = choice.newMessage;

  const sellPrice = sellEquipment(board, soldItem, { protectOne: keepNew && soldItem.id === equippedItem.id });
  return {
    message: `${equippedItem.name} 선택 · ${soldItem.name} 판매 +${formatNumber(sellPrice)}`,
    equippedItem,
    soldItem,
    sellPrice,
  };
}

function sellEquipment(board, item, { protectOne = false } = {}) {
  const sellPrice = equipmentSellPrice(item);
  const currentCount = board.inventory.get(item.id) || 0;
  if (currentCount > (protectOne ? 1 : 0)) board.spendItem(item.id, 1, `sell:${item.id}`);
  if (sellPrice > 0) board.addItem(GOLD_ITEM_ID, sellPrice, `sell:${item.id}`);
  return sellPrice;
}

function equipmentSellPrice(item) {
  const explicit = Number(item?.sellPrice ?? item?.SellPrice);
  if (Number.isFinite(explicit) && explicit > 0) return Math.floor(explicit);
  const power = Number(item?.power || item?.Power || 0);
  const tier = Number(item?.tier || item?.Tier || item?.grade || item?.Grade || 1);
  return Math.max(1, Math.round(power * 0.25 + tier * 8));
}

function renderEquipmentSlots(store, avatar) {
  const equipments = avatar?.equipments || avatar?.Equipments || [];
  for (const slotSpec of EQUIPMENT_SLOTS) {
    const node = document.querySelector(`[data-equipment-slot="${slotSpec.type}"]`);
    if (!node) continue;

    const message = firstEquippedMessage(equipments, slotSpec.index);
    const itemDataId = playerItemDataId(message);
    const item = itemDataId ? store.getItem(itemDataId) : null;
    const isEquipped = Boolean(item);
    const iconNode = node.querySelector('.equipment-icon');
    const nameNode = node.querySelector('.equipment-name');
    const level = Math.max(1, Number(message?.level || message?.Level || 1));

    node.classList.toggle('is-equipped', isEquipped);
    node.classList.toggle('is-empty', !isEquipped);
    node.setAttribute('aria-label', isEquipped ? `${item.name} ${level}레벨 장착 중` : `${slotSpec.emptyLabel} 비어 있음`);

    if (iconNode) {
      if (isEquipped) iconNode.innerHTML = iconHtmlForEquipment(item, slotSpec);
      else iconNode.textContent = '＋';
    }
    if (nameNode) nameNode.textContent = isEquipped ? compactEquipmentName(item.name, level) : (node.dataset.emptyLabel || slotSpec.emptyLabel);
  }
}

function firstEquippedMessage(equipments, slotIndex) {
  const indices = Array.isArray(slotIndex) ? slotIndex : [slotIndex];
  return indices
    .map(index => equipmentAt(equipments, index))
    .find(item => playerItemDataId(item) > 0) || null;
}

function equipmentAt(equipments, index) {
  return equipments?.[index] || equipments?.[String(index)] || null;
}

function playerItemDataId(message) {
  return Number(message?.itemDataId || message?.itemDataID || message?.ItemDataId || 0);
}

function iconForEquipment(item, slotSpec) {
  const type = item?.type || slotSpec.type;
  if (item?.category === 'Weapon') return '⚔';
  if (type === 'Head') return '⛑';
  if (type === 'Chest') return '◇';
  if (type === 'Boots') return '◈';
  if (type === 'Gloves') return '✦';
  if (type === 'Necklace') return '◎';
  if (type === 'Ring') return '●';
  return slotSpec.icon;
}

function iconHtmlForEquipment(item, slotSpec, className = 'equipment-icon-img') {
  const src = itemSpriteUrl(item);
  if (src) {
    return `<img class="${escapeHtml(className)}" src="${escapeHtml(src)}" alt="" loading="lazy" decoding="async">`;
  }
  return escapeHtml(iconForEquipment(item, slotSpec));
}

function itemSpriteUrl(item) {
  const path = itemSpritePath(item);
  if (!path) return '';
  if (/^(?:https?:|data:|file:|\/|\.\/|\.\.\/)/i.test(path)) return path;
  return path.startsWith('assets/') ? path : '';
}

function itemSpritePath(item) {
  const spriteGroups = item?.spriteGroups || item?.SpriteGroups || {};
  return String(spriteGroups.Icon || spriteGroups.icon || item?.sprite || item?.Sprite || '').trim();
}

function slotSpecForItem(item) {
  return EQUIPMENT_SLOTS.find(spec => spec.type === item?.type) || { type: item?.type, icon: '◇', emptyLabel: '장비' };
}

function compactEquipmentName(name, level) {
  const cleaned = String(name || '장비').replace(/\s+/g, '');
  const shortName = cleaned.length > 4 ? cleaned.slice(0, 4) : cleaned;
  return level > 1 ? `${shortName} Lv.${level}` : shortName;
}

function renderGrowthCards(board, player, store) {
  for (const spec of GROWTH_CARDS) {
    const level = board.getItemLevel(spec.id);
    const maxLevel = board.getItemMaxLevel(spec.id);
    const cost = board.getItemLevelUpCost(spec.id);
    const statValue = spec.statType === 'Attack'
      ? player?.attack || 0
      : spec.statType === 'Hp'
        ? player?.maxHp || 0
        : board.getItemStat(spec.statType);

    setText(spec.levelId, level >= maxLevel ? 'MAX' : `Lv.${level}`);
    setText(spec.valueId, `${formatNumber(statValue)}${spec.suffix || ''}`);
    setText(spec.costId, Number.isFinite(cost) && level < maxLevel ? formatNumber(cost) : 'MAX');
    renderGrowthCardIcon(spec, store?.getItem(spec.id));
  }

  document.querySelectorAll('[data-upgrade-item-id]').forEach(node => {
    const itemId = Number(node.dataset.upgradeItemId);
    const level = board.getItemLevel(itemId);
    const maxLevel = board.getItemMaxLevel(itemId);
    const cost = board.getItemLevelUpCost(itemId);
    const canUpgrade = level < maxLevel && Number.isFinite(cost) && board.gold >= cost;
    node.classList.toggle('is-affordable', canUpgrade);
    node.classList.toggle('is-maxed', level >= maxLevel);
    node.setAttribute('aria-label', `${GROWTH_CARDS.find(card => card.id === itemId)?.label || '성장'} ${level}레벨`);
  });
}

function renderGrowthCardIcon(spec, item) {
  const iconNode = document.querySelector(`[data-upgrade-item-id="${spec.id}"] .card-icon`);
  if (!iconNode) return;

  const src = itemSpriteUrl(item);
  if (src) {
    if (iconNode.dataset.iconSrc !== src) {
      iconNode.dataset.iconSrc = src;
      iconNode.innerHTML = `<img class="stat-icon-img" src="${escapeHtml(src)}" alt="" loading="lazy" decoding="async">`;
    }
    return;
  }

  if (iconNode.dataset.iconSrc !== '') {
    iconNode.dataset.iconSrc = '';
    iconNode.textContent = spec.fallbackIcon || '';
  }
}

function visibleAchievements(store) {
  return [...(store?.achievements?.values?.() || [])].filter(isVisibleAchievement);
}

function isVisibleAchievement(achievement) {
  return Boolean(achievement?.name && achievement?.condition)
    && !achievementTags(achievement).includes('HideDisplay');
}

function achievementTags(achievement) {
  return Array.isArray(achievement?.tags) ? achievement.tags : [];
}

function renderUnitTable(board) {
  const rows = [...board.units.values()]
    .filter(unit => unit.alive)
    .sort((a, b) => a.team - b.team || a.id - b.id)
    .map(unit => {
      const team = unit.team === TEAM.PLAYER ? 'P' : 'E';
      const hp = `${formatNumber(unit.hp)}/${formatNumber(unit.maxHp)}`;
      return `<tr><td>${team}</td><td>${escapeHtml(unit.name)}</td><td>${unit.state}</td><td>${hp}</td></tr>`;
    })
    .join('');
  setHtml('unitTableBody', rows || '<tr><td colspan="4">-</td></tr>');
}

function setText(id, value) {
  const node = document.getElementById(id);
  if (node) node.textContent = String(value);
}

function setHtml(id, value) {
  const node = document.getElementById(id);
  if (node) node.innerHTML = value;
}

function escapeHtml(value) {
  return String(value).replace(/[&<>"']/g, char => ({
    '&': '&amp;',
    '<': '&lt;',
    '>': '&gt;',
    '"': '&quot;',
    "'": '&#39;',
  }[char]));
}
