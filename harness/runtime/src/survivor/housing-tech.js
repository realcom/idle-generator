const HOUSING_TECH_DATA_URL = new URL('../../data/ninja2/housing-tech.json?v=ninja2-housing-runtime1', import.meta.url);

export const HOUSING_TECH = await loadHousingTech();

export async function loadHousingTech(url = HOUSING_TECH_DATA_URL) {
  const response = await fetch(url);
  if (!response.ok) {
    throw new Error(`Failed to load housing tech data: ${response.status} ${response.statusText}`);
  }
  return normalizeHousingTech(await response.json());
}

function normalizeHousingTech(raw) {
  return {
    version: String(raw?.version || ''),
    game: String(raw?.game || ''),
    source: String(raw?.source || ''),
    sourceUpdatedAt: String(raw?.sourceUpdatedAt || ''),
    generatedBy: String(raw?.generatedBy || ''),
    resources: normalizeResources(raw?.resources || {}),
    homePaths: Array.isArray(raw?.homePaths) ? raw.homePaths : [],
    buildings: Array.isArray(raw?.buildings) ? raw.buildings.map(normalizeBuilding) : [],
  };
}

function normalizeResources(resources) {
  return Object.fromEntries(Object.entries(resources).map(([key, resource]) => [
    key,
    {
      itemId: Number(resource?.itemId) || 0,
      name: String(resource?.name || key),
      icon: String(resource?.icon || ''),
    },
  ]));
}

function normalizeBuilding(building) {
  return {
    ...building,
    contentItemId: Number(building?.contentItemId) || 0,
    runtimeTiles: toNumberList(building?.runtimeTiles),
    runtimeAnchorTile: Number(building?.runtimeAnchorTile) || 0,
    startsBuilt: Boolean(building?.startsBuilt),
    homePreview: Boolean(building?.homePreview),
    construction: normalizeConstruction(building?.construction),
    additionalConstruction: building?.additionalConstruction
      ? normalizeConstruction(building.additionalConstruction)
      : undefined,
    maxInstancesByLanternLevel: normalizeNumberMap(building?.maxInstancesByLanternLevel),
    duplicateScaling: normalizeDuplicateScaling(building?.duplicateScaling),
    production: normalizeProduction(building?.production),
    levels: Array.isArray(building?.levels) ? building.levels.map(normalizeLevel) : [],
  };
}

function normalizeProduction(production = {}) {
  const itemDataId = Number(production?.itemDataId) || 0;
  if (!itemDataId) return null;
  return {
    itemDataId,
    resourceKey: String(production?.resourceKey || ''),
    rateUnit: String(production?.rateUnit || 'per_minute'),
    rateByLevel: toNumberList(production?.rateByLevel),
    storageMinutesByLevel: toNumberList(production?.storageMinutesByLevel),
  };
}

function normalizeLevel(level) {
  return {
    level: Number(level?.level) || 1,
    effect: level?.effect || {},
    ...(level?.levelUp ? { levelUp: normalizeConstruction(level.levelUp) } : {}),
  };
}

function normalizeConstruction(construction = {}) {
  return {
    seconds: Math.max(0, Number(construction?.seconds) || 0),
    cost: normalizeNumberMap(construction?.cost),
  };
}

function normalizeDuplicateScaling(scaling = {}) {
  return {
    costMultiplierPerExtra: Number(scaling?.costMultiplierPerExtra) || 1,
    timeMultiplierPerExtra: Number(scaling?.timeMultiplierPerExtra) || 1,
  };
}

function normalizeNumberMap(raw = {}) {
  return Object.fromEntries(Object.entries(raw).map(([key, value]) => [key, Number(value) || 0]));
}

function toNumberList(raw = []) {
  return Array.isArray(raw)
    ? raw.map(value => Number(value)).filter(Number.isFinite)
    : [];
}
