const ASSET = "../../assets/taskstonebar/source/taskstone/";

const EVOLUTIONS = [
  { name: "몽돌", sprite: "stone0.png", level: 1 },
  { name: "각돌", sprite: "stone1.png", level: 5 },
  { name: "고대 작업석", sprite: "stone2.png", level: 12 },
];

const STAGES = [
  {
    label: "1-1",
    name: "이끼 틈새",
    enemy: { name: "이끼 진드기", sprite: "stone0.png", hp: 82, reward: 5, exp: 6 },
  },
  {
    label: "1-2",
    name: "광맥 그늘",
    enemy: { name: "광맥 박쥐", sprite: "stone1.png", hp: 138, reward: 10, exp: 10 },
  },
  {
    label: "1-3",
    name: "큐브 제단",
    enemy: { name: "고대 작업석", sprite: "stone2.png", hp: 440, reward: 70, exp: 36, catalyst: 1 },
  },
];

const UPGRADES = {
  atk: { label: "공격력", base: 22, growth: 1.36 },
  hp: { label: "최대 HP", base: 20, growth: 1.3 },
  spd: { label: "공격속도", base: 56, growth: 1.52 },
  gold: { label: "골드 획득", base: 72, growth: 1.48 },
};

const BOARD_SIZE = 20;
const MAX_TIER = EVOLUTIONS.length - 1;
const SAVE_KEY = "taskstonebar.runtime.v1";

const $ = (id) => document.getElementById(id);

let selectedCell = null;
let attackFxClock = 0;

function defaultState() {
  const board = Array(BOARD_SIZE).fill(null);
  board[0] = 0;
  board[1] = 0;
  return {
    gold: 0,
    catalyst: 0,
    kills: 0,
    level: 1,
    exp: 0,
    upgrades: { atk: 0, hp: 0, spd: 0, gold: 0 },
    stage: 0,
    progress: 0,
    board,
    enemyHp: null,
    events: ["작업표시줄 동굴 진입"],
  };
}

let state = loadState();

function loadState() {
  try {
    const saved = JSON.parse(localStorage.getItem(SAVE_KEY));
    if (saved && Array.isArray(saved.board) && saved.board.length === BOARD_SIZE) return saved;
  } catch {
    return defaultState();
  }
  return defaultState();
}

function saveState() {
  localStorage.setItem(SAVE_KEY, JSON.stringify(state));
}

function fmt(value) {
  if (value >= 1_000_000) return `${(value / 1_000_000).toFixed(1)}M`;
  if (value >= 10_000) return `${(value / 1_000).toFixed(1)}K`;
  return `${Math.floor(value)}`;
}

function expToNext() {
  return Math.floor(20 * Math.pow(state.level, 1.55)) + 10;
}

function maxTier() {
  return state.board.reduce((max, cell) => (cell === null ? max : Math.max(max, cell)), 0);
}

function stats() {
  const tier = maxTier();
  const evoMult = 1 + tier * 0.45;
  const hp = Math.floor((52 + state.level * 12) * (1 + state.upgrades.hp * 0.15));
  const atk = Math.floor((6 + state.level * 2.2) * (1 + state.upgrades.atk * 0.12) * evoMult);
  const speed = +(1 + state.upgrades.spd * 0.08).toFixed(2);
  const goldMult = +(1 + state.upgrades.gold * 0.1).toFixed(2);
  return { hp, atk, speed, goldMult, dps: +(atk * speed).toFixed(1) };
}

function currentEnemyTemplate() {
  const stage = STAGES[state.stage];
  const scale = 1 + state.stage * 0.18 + Math.floor(state.kills / 30) * 0.12;
  return {
    ...stage.enemy,
    maxHp: Math.floor(stage.enemy.hp * scale),
    reward: Math.floor(stage.enemy.reward * scale),
    exp: Math.floor(stage.enemy.exp * scale),
  };
}

function ensureEnemy() {
  const enemy = currentEnemyTemplate();
  if (state.enemyHp === null || state.enemyHp <= 0) state.enemyHp = enemy.maxHp;
  return enemy;
}

function upgradeCost(key) {
  const def = UPGRADES[key];
  return Math.floor(def.base * Math.pow(def.growth, state.upgrades[key]));
}

function pushEvent(text) {
  state.events.unshift(text);
  state.events = state.events.slice(0, 9);
  $("tickerText").textContent = text;
}

function spawnStone() {
  const empties = [];
  state.board.forEach((cell, i) => {
    if (cell === null) empties.push(i);
  });
  if (!empties.length) return false;
  const idx = empties[Math.floor(Math.random() * empties.length)];
  state.board[idx] = 0;
  return true;
}

function selectStage(index) {
  state.stage = index;
  state.progress = 0;
  state.enemyHp = null;
  selectedCell = null;
  pushEvent(`${STAGES[index].label} ${STAGES[index].name} 이동`);
  render();
}

function buyUpgrade(key) {
  const cost = upgradeCost(key);
  if (state.gold < cost) return;
  state.gold -= cost;
  state.upgrades[key] += 1;
  pushEvent(`${UPGRADES[key].label} Lv.${state.upgrades[key]}`);
  render();
}

function mergeCells(from, to) {
  if (from === to) return false;
  const a = state.board[from];
  const b = state.board[to];
  if (a === null || b === null || a !== b) return false;
  if (a >= MAX_TIER) {
    const bonus = 500 * Math.pow(3, MAX_TIER);
    state.gold += bonus;
    state.catalyst += 1;
    state.board[from] = null;
    state.board[to] = null;
    pushEvent(`${EVOLUTIONS[MAX_TIER].name} 융합 +${fmt(bonus)} 골드`);
    return true;
  }
  state.board[from] = null;
  state.board[to] = a + 1;
  pushEvent(`진화 ${EVOLUTIONS[a + 1].name}`);
  return true;
}

function onCellClick(index) {
  const cell = state.board[index];
  if (selectedCell === null) {
    if (cell !== null) selectedCell = index;
    renderBoard();
    return;
  }
  if (!mergeCells(selectedCell, index)) {
    selectedCell = cell === null ? null : index;
  } else {
    selectedCell = null;
  }
  render();
}

function tick(dt) {
  const enemy = ensureEnemy();
  const s = stats();
  state.enemyHp -= s.dps * dt;
  attackFxClock += dt;
  if (attackFxClock >= 0.8 / Math.max(1, s.speed)) {
    attackFxClock = 0;
    attackFx(Math.floor(s.atk));
  }

  if (state.enemyHp <= 0) {
    const gold = Math.floor(enemy.reward * s.goldMult);
    state.gold += gold;
    state.exp += enemy.exp;
    state.kills += 1;
    state.progress += 1;
    if (enemy.catalyst) state.catalyst += enemy.catalyst;
    spawnStone();
    rewardFx(gold);

    while (state.exp >= expToNext()) {
      state.exp -= expToNext();
      state.level += 1;
      pushEvent(`레벨 업 Lv.${state.level}`);
    }

    if (state.progress >= 10) {
      state.progress = 0;
      state.stage = Math.min(STAGES.length - 1, state.stage + 1);
      pushEvent(`${STAGES[state.stage].label} 진입`);
    } else {
      pushEvent(`${enemy.name} 처치 +${gold} 골드`);
    }
    state.enemyHp = null;
  }

  renderCombatOnly();
}

function attackFx(amount) {
  const hero = $("hero");
  const enemy = $("enemy");
  const fx = $("fxLayer");
  hero.classList.remove("throw");
  enemy.classList.remove("hit");
  void hero.offsetWidth;
  hero.classList.add("throw");
  enemy.classList.add("hit");
  setTimeout(() => enemy.classList.remove("hit"), 130);

  const rock = document.createElement("i");
  rock.className = "rock-shot";
  rock.style.left = "82px";
  rock.style.bottom = "58px";
  fx.appendChild(rock);

  const dmg = document.createElement("b");
  dmg.className = "damage-pop";
  dmg.textContent = amount;
  dmg.style.right = "108px";
  dmg.style.bottom = "72px";
  fx.appendChild(dmg);

  setTimeout(() => rock.remove(), 320);
  setTimeout(() => dmg.remove(), 760);
}

function rewardFx(gold) {
  const pop = document.createElement("b");
  pop.className = "gold-pop";
  pop.textContent = `+${gold}`;
  pop.style.right = "96px";
  pop.style.bottom = "42px";
  $("fxLayer").appendChild(pop);
  setTimeout(() => pop.remove(), 820);
}

function render() {
  renderStatus();
  renderStone();
  renderBoard();
  renderStages();
  renderEvents();
  renderCombatOnly();
  saveState();
}

function renderStatus() {
  const s = stats();
  $("goldText").textContent = fmt(state.gold);
  $("catalystText").textContent = fmt(state.catalyst);
  $("levelText").textContent = state.level;
  $("atkText").textContent = fmt(s.atk);
  $("speedText").textContent = s.speed.toFixed(2);
  $("dpsText").textContent = s.dps.toFixed(1);
  $("killsText").textContent = fmt(state.kills);
  $("floorGoldText").textContent = fmt(state.gold);

  const list = $("upgradeList");
  list.replaceChildren();
  for (const key of Object.keys(UPGRADES)) {
    const cost = upgradeCost(key);
    const row = document.createElement("div");
    row.className = "upgrade";
    const copy = document.createElement("div");
    copy.innerHTML = `<b>${UPGRADES[key].label} Lv.${state.upgrades[key]}</b><small>${cost} 골드</small>`;
    const button = document.createElement("button");
    button.className = "btn";
    button.type = "button";
    button.textContent = "강화";
    button.disabled = state.gold < cost;
    button.addEventListener("click", () => buyUpgrade(key));
    row.append(copy, button);
    list.appendChild(row);
  }
}

function renderStone() {
  const tier = maxTier();
  const evo = EVOLUTIONS[tier];
  const next = EVOLUTIONS[tier + 1];
  const expNeed = expToNext();
  const enemy = ensureEnemy();
  $("stoneSprite").src = ASSET + evo.sprite;
  $("stoneName").textContent = evo.name;
  $("nextEvoText").textContent = next ? `${next.level}레벨 근처에서 ${next.name} 준비` : "최고 등급 융합 가능";
  $("expBar").style.width = `${Math.min(100, (state.exp / expNeed) * 100)}%`;
  $("expLabel").textContent = `${Math.floor(state.exp)} / ${expNeed}`;
  $("hpBar").style.width = `${Math.max(0, Math.min(100, (state.enemyHp / enemy.maxHp) * 100))}%`;
  $("hpLabel").textContent = `${Math.max(0, Math.floor(state.enemyHp))} / ${enemy.maxHp}`;
}

function renderBoard() {
  const board = $("mergeBoard");
  board.replaceChildren();
  state.board.forEach((tier, index) => {
    const cell = document.createElement("button");
    cell.type = "button";
    cell.className = "stone-cell";
    if (tier === null) {
      cell.classList.add("empty");
      cell.disabled = true;
    } else {
      cell.style.setProperty("--stone-img", `url("${ASSET}${EVOLUTIONS[tier].sprite}")`);
      cell.title = EVOLUTIONS[tier].name;
    }
    if (selectedCell === index) cell.classList.add("selected");
    cell.addEventListener("click", () => onCellClick(index));
    board.appendChild(cell);
  });
}

function renderStages() {
  const list = $("stageList");
  list.replaceChildren();
  STAGES.forEach((stage, index) => {
    const button = document.createElement("button");
    button.type = "button";
    button.className = `stage-button${state.stage === index ? " current" : ""}`;
    button.innerHTML = `<span>${stage.label} ${stage.name}</span><small>${stage.enemy.name}</small>`;
    button.addEventListener("click", () => selectStage(index));
    list.appendChild(button);
  });
}

function renderEvents() {
  const list = $("eventLog");
  list.replaceChildren();
  state.events.forEach((event) => {
    const li = document.createElement("li");
    li.textContent = event;
    list.appendChild(li);
  });
}

function renderCombatOnly() {
  const enemy = ensureEnemy();
  const pct = Math.max(0, Math.min(100, (state.enemyHp / enemy.maxHp) * 100));
  $("enemyHpBar").style.width = `${pct}%`;
  $("enemyHpText").textContent = `${Math.max(0, Math.floor(state.enemyHp))} / ${enemy.maxHp}`;
  $("enemyName").textContent = enemy.name;
  $("enemySprite").src = ASSET + enemy.sprite;
  $("stageBadge").textContent = STAGES[state.stage].label;
  $("floorGoldText").textContent = fmt(state.gold);
}

document.querySelectorAll("[data-action='reset']").forEach((button) => {
  button.addEventListener("click", () => {
    localStorage.removeItem(SAVE_KEY);
    state = defaultState();
    selectedCell = null;
    pushEvent("새 작업표시줄 세션");
    render();
  });
});

render();
setInterval(() => {
  tick(0.2);
  renderStatus();
  renderStone();
  renderEvents();
  saveState();
}, 200);
