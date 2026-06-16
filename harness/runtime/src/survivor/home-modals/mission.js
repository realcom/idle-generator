const REWARD_ICON_KEYS = Object.freeze({
  companion_exp: 'companions',
  companion_shards: 'companions',
  equipment_item: 'equipment',
  exp: 'growth',
  free_ruby: 'shop',
  gold: 'coin',
  light: 'sanctuary',
  souls: 'soul',
});

export const HOME_MISSION_MODAL_TAB = 'missions';

function clampNumber(value, min, max) {
  return Math.min(max, Math.max(min, Number(value) || 0));
}

function defaultEscapeHtml(value) {
  return String(value ?? '').replace(/[&<>"']/g, char => ({
    '&': '&amp;',
    '<': '&lt;',
    '>': '&gt;',
    '"': '&quot;',
    "'": '&#039;',
  }[char]));
}

function getUiHelper(ui, key, fallback) {
  return typeof ui?.[key] === 'function' ? ui[key] : fallback;
}

function normalizeStringList(value) {
  return Array.isArray(value) ? value.map(String).filter(Boolean) : [];
}

function missionKey(achievement) {
  return String(achievement?.popupArgs?.RuntimeMissionKey || achievement?.id || '').trim();
}

function missionGroup(achievement) {
  return String(achievement?.popupArgs?.MissionGroup || 'mission').trim() || 'mission';
}

function defaultIconKeyForAchievement(achievement) {
  const group = missionGroup(achievement);
  if (group === 'building') return 'sanctuary';
  if (group === 'currency') return rewardIconKey(defaultRewardKeyForItemId(achievement?.conditionValue1));
  if (group === 'side_dungeon') return achievement?.tags?.includes('Companion') ? 'companions' : 'stone';
  if (group === 'stage_clear') return 'exploration';
  return 'mission';
}

function defaultRewardKeyForItemId(itemDataId) {
  const id = Number(itemDataId);
  if (id === 4) return 'free_ruby';
  if (id === 5) return 'gold';
  if (id === 6) return 'exp';
  if (id === 200101) return 'wood';
  if (id === 200102) return 'stone';
  if (id === 200103) return 'souls';
  if (id === 200111) return 'companion_shards';
  return id ? `item_${id}` : 'mission';
}

export function rewardIconKey(key) {
  return REWARD_ICON_KEYS[key] || key;
}

export function rewardEntries(reward = {}) {
  return Object.entries(reward).filter(([, value]) => Number(value) > 0);
}

function defaultAchievementProgress(achievement) {
  const target = Math.max(1, Number(achievement?.targetProgress || achievement?.conditionValue2 || 1));
  return { progress: 0, target, completed: false, ratio: 0 };
}

function isHomeMissionAchievement(achievement) {
  if (!achievement || String(achievement.type || '') !== 'Mission') return false;
  const tags = Array.isArray(achievement.tags) ? achievement.tags : [];
  return tags.includes('HomeUI') || Boolean(achievement.popupArgs?.MissionGroup);
}

function sortMissionAchievements(a, b) {
  return (Number(a?.order || a?.id || 0) - Number(b?.order || b?.id || 0))
    || String(a?.name || '').localeCompare(String(b?.name || ''));
}

export function getHomeMissionEntries(scene, state, helpers = {}) {
  const achievements = (helpers.getMissionAchievements?.(scene, state) || [])
    .filter(isHomeMissionAchievement)
    .sort(sortMissionAchievements);
  const claimed = new Set(normalizeStringList(helpers.getClaimedMissionKeys?.(state)));

  return achievements.map(achievement => {
    const key = missionKey(achievement);
    const progressInfo = helpers.getAchievementProgress?.(achievement) || defaultAchievementProgress(achievement);
    const target = Math.max(1, Number(progressInfo.target || achievement.targetProgress || 1));
    const progress = clampNumber(progressInfo.progress, 0, target);
    const complete = Boolean(progressInfo.completed) || progress >= target;
    const isClaimed = claimed.has(key) || claimed.has(String(achievement.id));
    return {
      achievement,
      achievementId: Number(achievement.id || 0),
      key,
      group: missionGroup(achievement),
      title: String(achievement.name || key || '임무'),
      iconKey: helpers.iconKeyForAchievement?.(achievement) || defaultIconKeyForAchievement(achievement),
      target,
      reward: helpers.rewardForAchievement?.(achievement) || {},
      progress,
      complete,
      claimed: isClaimed,
      percent: clampNumber(progress / target * 100, 0, 100),
      status: isClaimed ? 'claimed' : complete ? 'claimable' : 'active',
      detail: helpers.detailForAchievement?.(achievement, { progress, target, complete }) || '',
    };
  });
}

export function getHomeMissionSummary(entries = []) {
  const total = entries.length;
  const claimed = entries.filter(entry => entry.claimed).length;
  const claimable = entries.filter(entry => entry.status === 'claimable').length;
  const active = entries.filter(entry => entry.status === 'active').length;
  return { active, claimable, claimed, total };
}

function formatMissionProgress(entry, ui) {
  const formatNumber = getUiHelper(ui, 'formatNumber', value => String(value ?? 0));
  return `${formatNumber(entry.progress)}/${formatNumber(entry.target)}`;
}

function renderRewardChips(entry, ui) {
  const escapeHtml = getUiHelper(ui, 'escapeHtml', defaultEscapeHtml);
  const iconHtml = getUiHelper(ui, 'iconHtml', () => '<i aria-hidden="true"></i>');
  const formatNumber = getUiHelper(ui, 'formatNumber', value => String(value ?? 0));
  const entries = rewardEntries(entry.reward);
  if (!entries.length) {
    return '<div class="home-mission-rewards"><span class="home-mission-reward-chip is-empty">보상 없음</span></div>';
  }
  return `
    <div class="home-mission-rewards" aria-label="임무 보상">
      ${entries.map(([key, value]) => `
        <span class="home-mission-reward-chip is-${escapeHtml(key)}">
          ${iconHtml(rewardIconKey(key), 'home-mission-reward-icon')}
          <b>+${escapeHtml(formatNumber(value))}</b>
        </span>
      `).join('')}
    </div>
  `;
}

export function renderHomeMissionModalBody(entries = [], ui = {}) {
  const escapeHtml = getUiHelper(ui, 'escapeHtml', defaultEscapeHtml);
  const iconHtml = getUiHelper(ui, 'iconHtml', () => '<i class="home-feature-icon" aria-hidden="true"></i>');
  if (!entries.length) {
    return `
      <div class="home-mission-empty">
        <b>임무 없음</b>
        <span>등록된 임무 데이터가 없습니다.</span>
      </div>
    `;
  }
  return `
    <div class="home-mission-list" role="list" aria-label="오늘의 임무">
      ${entries.map(entry => {
        const buttonLabel = entry.claimed ? '완료' : entry.complete ? '받기' : '진행중';
        return `
          <article class="home-mission-row is-${escapeHtml(entry.status)}" role="listitem" data-achievement-id="${escapeHtml(entry.achievementId)}">
            ${iconHtml(entry.iconKey, 'home-mission-icon')}
            <div class="home-mission-copy">
              <div class="home-mission-title-line">
                <b>${escapeHtml(entry.title)}</b>
                <em>${escapeHtml(formatMissionProgress(entry, ui))}</em>
              </div>
              <span>${escapeHtml(entry.detail)}</span>
              <div class="home-mission-progress" aria-hidden="true"><i style="width:${entry.percent.toFixed(1)}%"></i></div>
              ${renderRewardChips(entry, ui)}
            </div>
            <button
              class="home-mission-action"
              type="button"
              data-claim-home-mission="${escapeHtml(entry.key)}"
              ${entry.complete && !entry.claimed ? '' : 'disabled'}
            >${escapeHtml(buttonLabel)}</button>
          </article>
        `;
      }).join('')}
    </div>
  `;
}

export function renderHomeMissionModalFooter(summary = {}, ui = {}) {
  const escapeHtml = getUiHelper(ui, 'escapeHtml', defaultEscapeHtml);
  const claimable = Number(summary.claimable || 0);
  const claimed = Number(summary.claimed || 0);
  const total = Number(summary.total || 0);
  const status = claimable > 0
    ? `받을 수 있는 보상 ${claimable}개`
    : claimed >= total && total > 0
      ? '임무 보상을 모두 받았습니다'
      : '진행 중인 임무를 완료해 보상을 받으세요';
  return `
    <span>${escapeHtml(status)}</span>
    <em>업적 데이터 기준</em>
  `;
}
