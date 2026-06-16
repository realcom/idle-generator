export const HOME_SHOP_MODAL_TAB = 'shop';

export const HOME_SHOP_PRODUCT_DEFS = Object.freeze([
  {
    key: 'ruby_pouch',
    itemDataId: 201501,
    title: '루비 주머니',
    iconKey: 'shop_ruby_pouch',
    purchaseKind: 'cash',
    iapIdentifier: 'ninja2.cash.ruby_pouch_0600',
    priceUsd: 4.99,
    priceWon: 5500,
    reward: { ruby: 600, free_ruby: 60 },
    description: '유료 루비와 보너스 무료 루비',
  },
  {
    key: 'starter_sanctuary_pack',
    itemDataId: 201502,
    title: '초심자 성소 팩',
    iconKey: 'shop_starter_pack',
    purchaseKind: 'cash',
    iapIdentifier: 'ninja2.cash.starter_sanctuary_pack',
    priceUsd: 2.99,
    priceWon: 3300,
    reward: { gold: 6000, wood: 220, stone: 80, souls: 12, companion_shards: 8, energy: 40 },
    once: true,
    description: '성소 초반 건설을 당기는 1회 팩',
  },
  {
    key: 'energy_refill_pack',
    itemDataId: 201503,
    title: '에너지 회복 팩',
    iconKey: 'shop_energy_refill',
    purchaseKind: 'cash',
    iapIdentifier: 'ninja2.cash.energy_refill_pack',
    priceUsd: 0.99,
    priceWon: 1100,
    reward: { energy: 120, gold: 1000 },
    description: '출격 에너지 즉시 회복',
  },
  {
    key: 'ad_removal_blessing',
    itemDataId: 201504,
    title: '광고 제거 축복',
    iconKey: 'shop_ad_removal',
    purchaseKind: 'cash',
    iapIdentifier: 'ninja2.cash.remove_ads',
    priceUsd: 5.99,
    priceWon: 6600,
    reward: { ad_removal: 1, ruby: 300 },
    once: true,
    description: '광고 제거와 감사 루비 보너스',
  },
]);

const COST_LABELS = Object.freeze({
  energy: '에너지',
  gold: '골드',
  ruby: '루비',
  souls: '영혼불',
  stone: '석재',
  wood: '목재',
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

export function getHomeShopProductEntries(scene, state, helpers = {}) {
  const getLocalDateKey = helpers.getLocalDateKey || (() => '');
  const normalizeClaimMap = helpers.normalizeClaimMap || (value => value && typeof value === 'object' ? value : {});
  const canAffordCost = helpers.canAffordCost || (() => false);
  const today = getLocalDateKey();
  state.shopClaims = normalizeClaimMap(state.shopClaims);
  return HOME_SHOP_PRODUCT_DEFS.map(def => {
    const claimedToday = def.daily && (state.shopClaims?.[def.key] === today || state.dailyGiftClaimDate === today);
    const claimedOnce = Boolean(def.once && state.shopClaims?.[def.key]);
    const canPay = def.purchaseKind === 'cash' || canAffordCost(state, def.cost);
    return {
      ...def,
      claimedToday,
      claimedOnce,
      canPay,
      disabled: claimedToday || claimedOnce || !canPay,
      status: claimedToday || claimedOnce ? 'claimed' : canPay ? 'available' : 'locked',
    };
  });
}

export function getHomeShopSummary(products = []) {
  const total = products.length;
  const available = products.filter(product => !product.disabled).length;
  const claimed = products.filter(product => product.status === 'claimed').length;
  const locked = products.filter(product => product.status === 'locked').length;
  return { available, claimed, locked, total };
}

export function renderHomeShopModalBody(products = [], ui = {}) {
  const escapeHtml = getUiHelper(ui, 'escapeHtml', defaultEscapeHtml);
  const iconHtml = getUiHelper(ui, 'iconHtml', () => '<i class="home-shop-icon" aria-hidden="true"></i>');
  const formatRewardBundle = getUiHelper(ui, 'formatRewardBundle', () => '보상 없음');
  const formatNumber = getUiHelper(ui, 'formatNumber', value => String(value ?? 0));
  const formatCurrencyNumber = value => String(Math.floor(Number(value) || 0)).replace(/\B(?=(\d{3})+(?!\d))/g, ',');
  const formatCashPrice = product => {
    if (product.priceLabel) return product.priceLabel;
    if (Number(product.priceWon) > 0) return `₩${formatCurrencyNumber(product.priceWon)}`;
    if (Number(product.priceUsd) > 0) return `$${Number(product.priceUsd).toFixed(2)}`;
    return '무료';
  };
  const formatCost = cost => {
    const entries = Object.entries(cost || {}).filter(([, value]) => Number(value) > 0);
    if (!entries.length) return '무료';
    return entries.map(([key, value]) => `${COST_LABELS[key] || key} ${formatNumber(value)}`).join(' · ');
  };
  if (!products.length) {
    return `
      <div class="home-shop-empty">
        <b>보급 없음</b>
        <span>현재 구매 가능한 보급이 없습니다.</span>
      </div>
    `;
  }
  return `
    <div class="home-shop-list" role="list" aria-label="성소 보급품">
      ${products.map(product => {
        const action = product.status === 'claimed' ? '보유' : product.canPay ? '구매' : '부족';
        const priceText = product.purchaseKind === 'cash' ? formatCashPrice(product) : formatCost(product.cost);
        const costClass = product.purchaseKind === 'cash'
          ? 'is-cash'
          : product.canPay || product.status === 'claimed' ? 'is-ready' : 'is-missing';
        return `
          <article class="home-shop-row is-${escapeHtml(product.status)}" role="listitem" data-product-id="${escapeHtml(product.itemDataId || '')}">
            ${iconHtml(product.iconKey, 'home-shop-icon')}
            <div class="home-shop-copy">
              <div class="home-shop-title-line">
                <b>${escapeHtml(product.title)}</b>
                <em class="${costClass}">${escapeHtml(priceText)}</em>
              </div>
              <span>${escapeHtml(product.description)}</span>
              <small>${escapeHtml(formatRewardBundle(product.reward, ui.scene, ui.state))}</small>
            </div>
            <button
              class="home-shop-action"
              type="button"
              data-buy-home-shop="${escapeHtml(product.key)}"
              ${product.disabled ? 'disabled' : ''}
            >${escapeHtml(action)}</button>
          </article>
        `;
      }).join('')}
    </div>
  `;
}

export function renderHomeShopModalFooter(summary = {}, ui = {}) {
  const escapeHtml = getUiHelper(ui, 'escapeHtml', defaultEscapeHtml);
  const available = Number(summary.available || 0);
  const claimed = Number(summary.claimed || 0);
  const total = Number(summary.total || 0);
  const status = available > 0
    ? `구매 가능한 상품 ${available}개`
    : claimed >= total && total > 0
      ? '1회 상품을 모두 보유했습니다'
      : '현금 상품 구성을 확인하세요';
  return `
    <span>${escapeHtml(status)}</span>
    <em>현금 결제 상점</em>
  `;
}
