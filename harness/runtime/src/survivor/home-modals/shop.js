export const HOME_SHOP_MODAL_TAB = 'shop';

export const HOME_SHOP_CATEGORY_TABS = Object.freeze([
  { key: 'featured', label: '추천' },
  { key: 'packs', label: '패키지' },
  { key: 'ruby', label: '루비' },
  { key: 'energy', label: '에너지' },
  { key: 'pass', label: '패스' },
]);

export const HOME_SHOP_PRODUCT_DEFS = Object.freeze([
  {
    key: 'ruby_pouch',
    itemDataId: 201501,
    title: '루비 주머니',
    cardLabel: '루비 주머니',
    iconKey: 'shop_ruby_pouch',
    category: 'ruby',
    badge: '-20%',
    quick: true,
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
    cardLabel: '초심자 성소 팩',
    iconKey: 'shop_starter_pack',
    category: 'packs',
    badge: '-45%',
    featured: true,
    timedDeal: true,
    countdownLabel: '02:14:33',
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
    cardLabel: '에너지 팩',
    iconKey: 'shop_energy_refill',
    category: 'energy',
    badge: '오늘',
    quick: true,
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
    cardLabel: '광고 제거',
    iconKey: 'shop_ad_removal',
    category: 'packs',
    badge: '영구',
    quick: true,
    purchaseKind: 'cash',
    iapIdentifier: 'ninja2.cash.remove_ads',
    priceUsd: 5.99,
    priceWon: 6600,
    reward: { ad_removal: 1, ruby: 300 },
    once: true,
    description: '광고 제거와 감사 루비 보너스',
  },
]);

const HOME_SHOP_PASS_TEASER = Object.freeze({
  key: 'sanctuary_pass_preview',
  title: '성소 패스',
  cardLabel: '성소 패스',
  iconKey: 'pass',
  category: 'pass',
  badge: 'NEW',
  priceLabel: '₩9,900',
  purchaseKind: 'preview',
  reward: { ruby: 300, energy: 40, companion_shards: 10 },
  description: '일일 보급 + 성장권',
  canPay: true,
  disabled: false,
  status: 'preview',
  previewOnly: true,
});

const COST_LABELS = Object.freeze({
  energy: '에너지',
  gold: '골드',
  ruby: '루비',
  souls: '영혼불',
  stone: '석재',
  wood: '목재',
});

const REWARD_CHIP_LABELS = Object.freeze({
  ad_removal: '광고',
  companion_shards: '조각',
  energy: 'EN',
  free_ruby: '보너스',
  gold: '골드',
  ruby: '루비',
  souls: '혼불',
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

export function normalizeHomeShopCategoryKey(value) {
  const key = String(value || '').trim().toLowerCase();
  return HOME_SHOP_CATEGORY_TABS.some(tab => tab.key === key) ? key : HOME_SHOP_CATEGORY_TABS[0].key;
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
  const once = products.filter(product => product.once).length;
  return { available, claimed, locked, once, total };
}

export function renderHomeShopModalBody(products = [], ui = {}) {
  const escapeHtml = getUiHelper(ui, 'escapeHtml', defaultEscapeHtml);
  const iconHtml = getUiHelper(ui, 'iconHtml', () => '<i class="home-shop-icon" aria-hidden="true"></i>');
  const formatRewardBundle = getUiHelper(ui, 'formatRewardBundle', () => '보상 없음');
  const formatNumber = getUiHelper(ui, 'formatNumber', value => String(value ?? 0));
  const activeCategory = normalizeHomeShopCategoryKey(ui.activeCategory);
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
  const priceText = product => product.purchaseKind === 'cash' || product.purchaseKind === 'preview'
    ? formatCashPrice(product)
    : formatCost(product.cost);
  const cardProductsForCategory = () => {
    const realProducts = activeCategory === 'featured'
      ? products.filter(product => !product.featured)
      : products.filter(product => product.category === activeCategory);
    const withPass = activeCategory === 'featured' || activeCategory === 'pass'
      ? [...realProducts, HOME_SHOP_PASS_TEASER]
      : realProducts;
    return withPass.slice(0, activeCategory === 'featured' ? 4 : 6);
  };
  const featured = products.find(product => product.featured) || products[0] || null;
  const cardProducts = cardProductsForCategory();
  const quickProducts = products.filter(product => product.quick && (activeCategory === 'featured' || product.category === activeCategory)).slice(0, 3);
  const renderRewardChips = product => Object.entries(product.reward || {})
    .filter(([, value]) => Number(value) > 0)
    .slice(0, 3)
    .map(([key]) => `<span class="home-shop-reward-chip">${escapeHtml(REWARD_CHIP_LABELS[key] || key)}</span>`)
    .join('');
  const renderActionButton = (product, className = 'home-shop-action') => {
    const claimed = product.status === 'claimed';
    const preview = product.previewOnly || product.status === 'preview';
    const label = claimed ? '보유' : preview ? priceText(product) : product.canPay ? priceText(product) : '부족';
    const dataAttr = preview ? '' : ` data-buy-home-shop="${escapeHtml(product.key)}"`;
    const disabledAttr = product.disabled && !preview ? ' disabled' : '';
    const previewAttr = preview ? ' aria-disabled="true"' : '';
    return `<button class="${className}" type="button"${dataAttr}${disabledAttr}${previewAttr}>${escapeHtml(label)}</button>`;
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
    <div class="home-shop-layout" aria-label="성소 보급품">
      <nav class="home-shop-category-tabs" aria-label="상점 분류">
        ${HOME_SHOP_CATEGORY_TABS.map(tab => `
          <button
            class="home-shop-category-tab${tab.key === activeCategory ? ' is-active' : ''}"
            type="button"
            data-home-shop-category="${escapeHtml(tab.key)}"
            aria-pressed="${tab.key === activeCategory ? 'true' : 'false'}"
          >${escapeHtml(tab.label)}</button>
        `).join('')}
      </nav>
      ${featured && (activeCategory === 'featured' || activeCategory === 'packs') ? `
        <section class="home-shop-timed-deal is-${escapeHtml(featured.status)}" aria-label="타임특가">
          <div class="home-shop-deal-icon">${iconHtml(featured.iconKey, 'home-shop-hero-icon')}</div>
          <div class="home-shop-deal-copy">
            <span class="home-shop-deal-kicker">타임특가</span>
            <b>${escapeHtml(featured.cardLabel || featured.title)}</b>
            <small>${escapeHtml(featured.description)}</small>
            <em>${escapeHtml(featured.countdownLabel || '02:14:33')}</em>
          </div>
          <strong class="home-shop-discount-badge">${escapeHtml(featured.badge || '-45%')}</strong>
          ${renderActionButton(featured, 'home-shop-deal-action')}
        </section>
      ` : ''}
      <section class="home-shop-section-head">
        <b>${activeCategory === 'featured' ? '추천 상품' : HOME_SHOP_CATEGORY_TABS.find(tab => tab.key === activeCategory)?.label || '상품'}</b>
        <span>${escapeHtml(`${cardProducts.filter(product => !product.disabled).length}개 구매 가능`)}</span>
      </section>
      <div class="home-shop-card-grid" role="list" aria-label="추천 상품">
        ${cardProducts.map(product => `
          <article class="home-shop-card is-${escapeHtml(product.status)}" role="listitem" data-product-id="${escapeHtml(product.itemDataId || product.key || '')}">
            <span class="home-shop-card-badge">${escapeHtml(product.badge || (product.previewOnly ? 'NEW' : ''))}</span>
            ${iconHtml(product.iconKey, 'home-shop-card-icon')}
            <div class="home-shop-card-copy">
              <b>${escapeHtml(product.cardLabel || product.title)}</b>
              <small>${escapeHtml(product.description)}</small>
            </div>
            <div class="home-shop-reward-chips" aria-hidden="true">${renderRewardChips(product)}</div>
            ${renderActionButton(product, 'home-shop-card-action')}
          </article>
        `).join('') || `
          <div class="home-shop-empty is-compact">
            <b>상품 준비 중</b>
            <span>이 분류의 상품은 다음 패스에서 추가합니다.</span>
          </div>
        `}
      </div>
      ${quickProducts.length ? `
        <section class="home-shop-quick-list" aria-label="빠른 구매">
          <header><b>빠른 구매</b></header>
          ${quickProducts.map(product => `
            <article class="home-shop-quick-row is-${escapeHtml(product.status)}" data-product-id="${escapeHtml(product.itemDataId || '')}">
              ${iconHtml(product.iconKey, 'home-shop-quick-icon')}
              <span><b>${escapeHtml(product.cardLabel || product.title)}</b><small>${escapeHtml(formatRewardBundle(product.reward, ui.scene, ui.state))}</small></span>
              ${renderActionButton(product, 'home-shop-quick-action')}
            </article>
          `).join('')}
        </section>
      ` : ''}
    </div>
  `;
}

export function renderHomeShopModalFooter(summary = {}, ui = {}) {
  const escapeHtml = getUiHelper(ui, 'escapeHtml', defaultEscapeHtml);
  const available = Number(summary.available || 0);
  const claimed = Number(summary.claimed || 0);
  const total = Number(summary.total || 0);
  const status = available > 0
    ? `구매 가능 ${available}종 · 1회 한정 ${Number(summary.once || 0)}종`
    : claimed >= total && total > 0
      ? '1회 상품을 모두 보유했습니다'
      : '현금 상품 구성을 확인하세요';
  return `
    <span>${escapeHtml(status)}</span>
    <em>i</em>
  `;
}
