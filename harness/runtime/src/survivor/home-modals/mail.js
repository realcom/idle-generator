const HOME_MAIL_DATA_URL = new URL('../../../scenarios/ninja2/home-mail.json?v=mailbox1', import.meta.url);

export const HOME_MAIL_DEFS = Object.freeze(await loadHomeMailDefs());

const MAIL_UI_COPY = Object.freeze({
  defaultSender: '성소', // data-contract-allow: modal chrome labels are declared by home-modals/mail.yaml.
  defaultTitle: '우편', // data-contract-allow
  notice: '공지', // data-contract-allow
  completed: '완료', // data-contract-allow
  claim: '받기', // data-contract-allow
  read: '읽음', // data-contract-allow
  confirm: '확인', // data-contract-allow
  emptyTitle: '우편 없음', // data-contract-allow
  emptyDetail: '새 알림이나 보급이 도착하면 여기에 표시됩니다.', // data-contract-allow
  listLabel: '성소 우편함', // data-contract-allow
  rewardLabel: '우편 보상', // data-contract-allow
  storageSuffix: '일 보관', // data-contract-allow
  noExpiry: '보관 제한 없음', // data-contract-allow
  claimablePrefix: '수령 가능한 우편', // data-contract-allow
  unreadPrefix: '읽지 않은 우편', // data-contract-allow
  countSuffix: '개', // data-contract-allow
  allRead: '새 우편을 모두 확인했습니다', // data-contract-allow
  claimAll: '모두 받기', // data-contract-allow
  close: '닫기', // data-contract-allow
});

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
  return Array.isArray(value) ? value.map(item => String(item || '').trim()).filter(Boolean) : [];
}

function normalizeClaimMap(value) {
  const normalized = {};
  for (const [key, claimedAt] of Object.entries(value || {})) {
    const safeKey = String(key || '').trim();
    if (!safeKey) continue;
    normalized[safeKey] = String(claimedAt || 'claimed');
  }
  return normalized;
}

async function loadHomeMailDefs(url = HOME_MAIL_DATA_URL) {
  const response = await fetch(url);
  if (!response.ok) {
    throw new Error(`Failed to load home mail data: ${response.status} ${response.statusText}`);
  }
  const raw = await response.json();
  if (!Array.isArray(raw?.entries)) return [];
  return raw.entries.map(normalizeMailDef).filter(def => def.key);
}

function normalizeMailDef(raw) {
  return Object.freeze({
    key: String(raw?.key || '').trim(),
    sender: String(raw?.sender || MAIL_UI_COPY.defaultSender).trim(),
    title: String(raw?.title || raw?.key || MAIL_UI_COPY.defaultTitle).trim(),
    detail: String(raw?.detail || '').trim(),
    iconKey: String(raw?.iconKey || 'mail').trim(),
    availableWhen: raw?.availableWhen && typeof raw.availableWhen === 'object' ? raw.availableWhen : {},
    expiresInDays: Math.max(0, Math.floor(Number(raw?.expiresInDays || 0))),
    reward: normalizeReward(raw?.reward),
  });
}

function normalizeReward(rawReward = {}) {
  const reward = {};
  for (const [key, rawValue] of Object.entries(rawReward || {})) {
    const value = Math.max(0, Math.floor(Number(rawValue || 0)));
    if (!key || !value) continue;
    reward[String(key)] = value;
  }
  return reward;
}

function isMailAvailable(def, state = {}) {
  const rule = def.availableWhen || {};
  if (Number(rule.minStageClears || 0) > Number(state.stageClears || 0)) return false;
  if (Number(rule.minShrineLevel || 0) > Number(state.shrineLevel || 1)) return false;
  if (Number(rule.minSorties || 0) > Number(state.sorties || 0)) return false;
  if (Number(rule.minCompanions || 0) > countUnlockedCompanions(state)) return false;
  if (rule.buildingBuilt && !state.builtBuildings?.[String(rule.buildingBuilt)]) return false;
  return true;
}

function countUnlockedCompanions(state = {}) {
  return Object.values(state.companions || {}).filter(companion => companion?.unlocked).length;
}

export function mailRewardEntries(mail = {}) {
  return Object.entries(mail.reward || {}).filter(([, value]) => Number(value) > 0);
}

export function getHomeMailEntries(state = {}) {
  const claims = normalizeClaimMap(state.mailClaims);
  const readKeys = new Set(normalizeStringList(state.mailReadKeys));
  return HOME_MAIL_DEFS
    .filter(def => isMailAvailable(def, state))
    .map(def => {
      const rewardEntries = mailRewardEntries(def);
      const claimed = Boolean(claims[def.key]);
      const read = claimed || readKeys.has(def.key);
      const claimable = rewardEntries.length > 0 && !claimed;
      const status = claimed ? 'claimed' : claimable ? 'claimable' : read ? 'read' : 'unread';
      return {
        ...def,
        claimable,
        claimed,
        read,
        rewardEntries,
        status,
      };
    })
    .sort(sortMailEntries);
}

function sortMailEntries(a, b) {
  const statusRank = { claimable: 0, unread: 1, read: 2, claimed: 3 };
  return (statusRank[a.status] ?? 9) - (statusRank[b.status] ?? 9)
    || String(a.key).localeCompare(String(b.key));
}

export function getHomeMailSummary(entries = []) {
  const total = entries.length;
  const claimable = entries.filter(entry => entry.claimable).length;
  const unread = entries.filter(entry => !entry.read).length;
  const claimed = entries.filter(entry => entry.claimed).length;
  const notice = entries.filter(entry => !entry.rewardEntries.length && !entry.claimed).length;
  return { claimable, claimed, notice, total, unread };
}

function renderMailRewardChips(entry, ui) {
  const escapeHtml = getUiHelper(ui, 'escapeHtml', defaultEscapeHtml);
  const formatNumber = getUiHelper(ui, 'formatNumber', value => String(value ?? 0));
  const iconHtml = getUiHelper(ui, 'iconHtml', () => '<i aria-hidden="true"></i>');
  if (!entry.rewardEntries.length) {
    return `<span class="home-mail-reward-chip is-empty">${escapeHtml(MAIL_UI_COPY.notice)}</span>`;
  }
  return entry.rewardEntries.map(([key, value]) => `
    <span class="home-mail-reward-chip is-${escapeHtml(key)}">
      ${iconHtml(mailRewardIconKey(key), 'home-mail-reward-icon')}
      <b>+${escapeHtml(formatNumber(value))}</b>
    </span>
  `).join('');
}

function mailRewardIconKey(key) {
  const table = {
    companion_exp: 'companions',
    companion_shards: 'companions',
    energy: 'gift',
    free_ruby: 'shop',
    light: 'sanctuary',
    souls: 'soul',
  };
  return table[key] || key;
}

function mailActionLabel(entry) {
  if (entry.claimed) return MAIL_UI_COPY.completed;
  if (entry.claimable) return MAIL_UI_COPY.claim;
  return entry.read ? MAIL_UI_COPY.read : MAIL_UI_COPY.confirm;
}

export function renderHomeMailModalBody(entries = [], ui = {}) {
  const escapeHtml = getUiHelper(ui, 'escapeHtml', defaultEscapeHtml);
  const iconHtml = getUiHelper(ui, 'iconHtml', () => '<i class="home-quick-row-icon" aria-hidden="true"></i>');
  if (!entries.length) {
    return `
      <div class="home-mail-empty">
        <b>${escapeHtml(MAIL_UI_COPY.emptyTitle)}</b>
        <span>${escapeHtml(MAIL_UI_COPY.emptyDetail)}</span>
      </div>
    `;
  }
  return `
    <div class="home-mail-list" role="list" aria-label="${escapeHtml(MAIL_UI_COPY.listLabel)}">
      ${entries.map(entry => `
        <article class="home-mail-row is-${escapeHtml(entry.status)}" role="listitem" data-mail-key="${escapeHtml(entry.key)}">
          ${iconHtml(entry.iconKey, 'home-mail-icon')}
          <div class="home-mail-copy">
            <div class="home-mail-title-line">
              <b>${escapeHtml(entry.title)}</b>
              <em>${escapeHtml(entry.sender)}</em>
            </div>
            <span>${escapeHtml(entry.detail)}</span>
            <div class="home-mail-rewards" aria-label="${escapeHtml(MAIL_UI_COPY.rewardLabel)}">
              ${renderMailRewardChips(entry, ui)}
            </div>
            <small>${entry.expiresInDays ? `${entry.expiresInDays}${MAIL_UI_COPY.storageSuffix}` : MAIL_UI_COPY.noExpiry}</small>
          </div>
          <button
            class="home-mail-action"
            type="button"
            data-home-mail-action="${entry.claimable ? 'claim' : 'read'}"
            data-home-mail-key="${escapeHtml(entry.key)}"
            ${entry.claimed || (entry.read && !entry.claimable) ? 'disabled' : ''}
          >${escapeHtml(mailActionLabel(entry))}</button>
        </article>
      `).join('')}
    </div>
  `;
}

export function renderHomeMailModalFooter(summary = {}, ui = {}) {
  const escapeHtml = getUiHelper(ui, 'escapeHtml', defaultEscapeHtml);
  const claimable = Number(summary.claimable || 0);
  const unread = Number(summary.unread || 0);
  const status = claimable > 0
    ? `${MAIL_UI_COPY.claimablePrefix} ${claimable}${MAIL_UI_COPY.countSuffix}`
    : unread > 0
      ? `${MAIL_UI_COPY.unreadPrefix} ${unread}${MAIL_UI_COPY.countSuffix}`
      : MAIL_UI_COPY.allRead;
  return `
    <span>${escapeHtml(status)}</span>
    <button class="home-modal-action-button home-mail-claim-all" type="button" data-home-quick-action="claim-all-mail" ${claimable ? '' : 'disabled'}>${escapeHtml(MAIL_UI_COPY.claimAll)}</button>
    <button class="home-modal-action-button" type="button" data-close-home-quick>${escapeHtml(MAIL_UI_COPY.close)}</button>
  `;
}
