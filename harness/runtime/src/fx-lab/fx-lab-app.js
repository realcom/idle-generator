import {
  AI_AUTHORING_PROMPT,
  PRESET_RECIPES,
  cloneRecipe,
  formatRecipe,
  normalizeRecipe,
  parseRecipeText,
} from './effect-recipes.js';
import { FxLabScene } from './effect-renderer.js';

const state = {
  scene: null,
  recipe: normalizeRecipe(PRESET_RECIPES[0]),
  status: 'draft',
  lastError: '',
  selectedLayer: { kind: 'emitter', index: 0 },
  controls: {
    intensity: 1.35,
    scale: 1.25,
    speed: 0.9,
    background: 'dark',
    mode: 'loop',
  },
};

const els = {};

boot();

function boot() {
  collectElements();
  installDomHandlers();
  renderPresetList();
  setRecipe(state.recipe);

  if (!globalThis.Phaser) {
    setStatus('Phaser load failed', true);
    return;
  }

  globalThis.addEventListener('phaser-fx-lab-ready', event => {
    state.scene = event.detail.scene;
    exposeHarnessContext();
    replay();
    setStatus('Ready');
    document.documentElement.dataset.uiHarnessReady = 'true';
  }, { once: true });

  new Phaser.Game({
    type: Phaser.WEBGL,
    parent: 'fxCanvas',
    width: 800,
    height: 520,
    backgroundColor: '#17201b',
    scene: FxLabScene,
    scale: {
      mode: Phaser.Scale.FIT,
      autoCenter: Phaser.Scale.CENTER_BOTH,
    },
  });
}

function collectElements() {
  for (const id of [
    'presetList',
    'sampleCount',
    'recipeText',
    'promptText',
    'previewStatus',
    'modalStage',
    'metrics',
    'reviewState',
    'reviewNotes',
    'activeRecipeName',
    'timelineLabel',
    'ideaInput',
    'intensityRange',
    'intensityOut',
    'scaleRange',
    'scaleOut',
    'speedRange',
    'speedOut',
    'layerList',
    'layerCount',
    'selectedLayerBadge',
    'layerIdInput',
    'layerKindInput',
    'layerVariantInput',
    'layerAnchorInput',
    'layerTextureInput',
    'layerBlendInput',
    'layerQuantityInput',
    'layerFrequencyInput',
    'layerDelayInput',
    'layerDurationInput',
    'layerColorInput',
    'sheetStatus',
    'sheetFrameCount',
    'sheetColumns',
    'sheetFps',
    'sheetScale',
  ]) {
    els[id] = document.getElementById(id);
  }
  els.playhead = document.querySelector('.timeline-playhead');
}

function installDomHandlers() {
  bindClick('replayBtn', replay);
  bindClick('topReplayBtn', replay);
  bindClick('loadJsonBtn', loadRecipeFromText);
  bindClick('topLoadBtn', loadRecipeFromText);
  bindClick('copyJsonBtn', () => copyText(formatRecipe(state.recipe), 'JSON copied'));
  bindClick('copyJsonBtnPanel', () => copyText(formatRecipe(state.recipe), 'JSON copied'));
  bindClick('downloadJsonBtn', downloadRecipe);
  bindClick('downloadJsonBtnPanel', downloadRecipe);
  bindClick('addEmitterBtn', addEmitterLayer);
  bindClick('addGraphicBtn', addGraphicLayer);
  bindClick('duplicateLayerBtn', duplicateSelectedLayer);
  bindClick('deleteLayerBtn', deleteSelectedLayer);
  bindClick('moveLayerUpBtn', () => moveSelectedLayer(-1));
  bindClick('moveLayerDownBtn', () => moveSelectedLayer(1));
  bindClick('exportSheetBtn', exportSpriteSheet);
  bindClick('exportSheetTopBtn', exportSpriteSheet);
  bindClick('copySheetMetaBtn', copySpriteSheetMeta);
  bindClick('sheetOneShotBtn', activateOneShot);
  bindClick('copyPromptBtn', () => copyText(composePromptFromIdea({ focus: false }), 'Prompt copied'));
  bindClick('composePromptBtn', () => composePromptFromIdea());
  bindClick('topPromptBtn', () => composePromptFromIdea());
  bindClick('approveBtn', () => setReview('approved'));
  bindClick('needsWorkBtn', () => setReview('needs_work'));
  bindClick('copyFixPromptBtn', copyFixPrompt);

  document.querySelectorAll('[data-modal-id]').forEach(button => {
    button.addEventListener('click', () => selectTab(button.dataset.modalId));
  });

  for (const rangeId of ['intensityRange', 'scaleRange', 'speedRange']) {
    els[rangeId].addEventListener('input', () => updateControlsFromDom({ replayEffect: true }));
  }
  for (const inputId of [
    'layerIdInput',
    'layerQuantityInput',
    'layerFrequencyInput',
    'layerDelayInput',
    'layerDurationInput',
    'layerColorInput',
  ]) {
    els[inputId].addEventListener('input', applyLayerEditorChange);
  }
  for (const inputId of ['layerVariantInput', 'layerAnchorInput', 'layerTextureInput', 'layerBlendInput']) {
    els[inputId].addEventListener('change', applyLayerEditorChange);
  }

  document.querySelectorAll('#backgroundMode [data-bg]').forEach(button => {
    button.addEventListener('click', () => {
      state.controls.background = button.dataset.bg;
      document.querySelectorAll('#backgroundMode [data-bg]').forEach(node => node.classList.remove('active'));
      button.classList.add('active');
      replay();
    });
  });

  document.querySelectorAll('#playMode [data-mode]').forEach(button => {
    button.addEventListener('click', () => {
      state.controls.mode = button.dataset.mode;
      document.querySelectorAll('#playMode [data-mode]').forEach(node => node.classList.remove('active'));
      button.classList.add('active');
      updateTimeline();
      replay();
    });
  });

  els.reviewNotes.addEventListener('input', () => {
    state.recipe.review.notes = els.reviewNotes.value;
    syncRecipeText();
  });
  composePromptFromIdea({ focus: false, silent: true });
  updateControlsFromDom({ replayEffect: false });
}

function renderPresetList() {
  els.presetList.innerHTML = '';
  els.sampleCount.textContent = `${PRESET_RECIPES.length} refs`;
  for (const recipe of PRESET_RECIPES) {
    const button = document.createElement('button');
    button.className = 'preset-button';
    button.type = 'button';
    button.dataset.recipeId = recipe.id;
    const firstColor = recipe.palette?.[0] || '#8be36d';
    const secondColor = recipe.palette?.[1] || '#f7d66a';
    button.innerHTML = `
      <span class="preset-preview" style="--preview-a:${firstColor};--preview-b:${secondColor}"></span>
      <span class="preset-meta"><span class="preset-name">${recipe.name}</span><span class="preset-id">#${recipe.id}</span></span>
      <span class="preset-chip">${recipe.loop ? 'LOOP' : 'SHOT'}</span>
    `;
    button.addEventListener('click', () => setRecipe(cloneRecipe(recipe)));
    els.presetList.appendChild(button);
  }
}

function setRecipe(nextRecipe) {
  state.recipe = normalizeRecipe(nextRecipe);
  state.status = state.recipe.review.status;
  normalizeSelectedLayer();
  els.activeRecipeName.textContent = state.recipe.name;
  els.reviewState.textContent = state.status;
  els.reviewState.dataset.state = state.status;
  els.reviewNotes.value = state.recipe.review.notes || '';
  syncRecipeText();
  updatePresetSelection();
  renderLayerList();
  renderLayerEditor();
  updateTimeline();
  replay();
}

function loadRecipeFromText() {
  try {
    setRecipe(parseRecipeText(els.recipeText.value));
    setStatus('Recipe loaded');
  } catch (error) {
    state.lastError = error?.message || String(error);
    setStatus('JSON parse failed', true);
  }
}

function replay() {
  if (!state.scene) return;
  state.scene.playRecipe(normalizeRecipe(state.recipe), { ...state.controls });
  updateTimeline();
  restartPlayhead();
  updateMetrics();
  setTimeout(updateMetrics, 280);
  setTimeout(updateMetrics, 900);
}

function setReview(status) {
  state.status = status;
  state.recipe.review.status = status;
  els.reviewState.textContent = status;
  els.reviewState.dataset.state = status;
  syncRecipeText();
  setStatus(status === 'approved' ? 'Approved' : 'Needs work');
}

function syncRecipeText() {
  els.recipeText.value = formatRecipe(state.recipe);
}

function updatePresetSelection() {
  document.querySelectorAll('.preset-button').forEach(button => {
    button.classList.toggle('active', button.dataset.recipeId === state.recipe.id);
  });
}

function updateMetrics() {
  if (!state.scene) return;
  const metrics = state.scene.getMetrics();
  els.metrics.innerHTML = `
    <div class="metric"><span>${metrics.liveParticles}</span><b>Particles</b></div>
    <div class="metric"><span>${getLayerEntries().length}</span><b>Layers</b></div>
    <div class="metric"><span>${state.controls.intensity.toFixed(2)}</span><b>Intensity</b></div>
    <div class="metric"><span>${Math.round(displayDurationMs())}</span><b>ms</b></div>
  `;
}

function renderLayerList() {
  normalizeSelectedLayer();
  const entries = getLayerEntries();
  els.layerCount.textContent = `${entries.length} layers`;
  els.layerList.innerHTML = '';

  for (const entry of entries) {
    const button = document.createElement('button');
    button.type = 'button';
    button.className = 'layer-button';
    button.dataset.kind = entry.kind;
    button.dataset.index = String(entry.index);
    const isSelected = entry.kind === state.selectedLayer.kind && entry.index === state.selectedLayer.index;
    const layer = entry.layer;
    const variant = entry.kind === 'emitter' ? layer.mode || 'flow' : layer.type || 'ring';
    const detail = entry.kind === 'emitter'
      ? `${layer.texture || 'soft'} · ${layer.anchor || 'target'} · q${layer.quantity ?? 1}`
      : `${layer.anchor || 'target'} · ${layer.color || '#ffffff'}`;
    button.classList.toggle('active', isSelected);
    button.innerHTML = `
      <span class="layer-kind">${entry.kind === 'emitter' ? 'EM' : 'GR'}</span>
      <span class="layer-meta"><span class="layer-name">${layer.id || `${entry.kind}_${entry.index + 1}`}</span><span class="layer-sub">${detail}</span></span>
      <span class="layer-chip">${variant}</span>
    `;
    button.addEventListener('click', () => selectLayer(entry.kind, entry.index));
    els.layerList.appendChild(button);
  }
}

function renderLayerEditor() {
  const layer = getSelectedLayer();
  const kind = state.selectedLayer.kind;
  const hasLayer = Boolean(layer && kind);
  const inputs = [
    'layerIdInput',
    'layerVariantInput',
    'layerAnchorInput',
    'layerTextureInput',
    'layerBlendInput',
    'layerQuantityInput',
    'layerFrequencyInput',
    'layerDelayInput',
    'layerDurationInput',
    'layerColorInput',
  ];

  for (const id of inputs) els[id].disabled = !hasLayer;

  if (!hasLayer) {
    els.selectedLayerBadge.textContent = 'none';
    els.layerKindInput.value = '';
    els.layerIdInput.value = '';
    els.layerVariantInput.innerHTML = '';
    return;
  }

  const isEmitter = kind === 'emitter';
  els.selectedLayerBadge.textContent = `${kind} ${state.selectedLayer.index + 1}`;
  els.layerKindInput.value = kind;
  els.layerIdInput.value = layer.id || '';
  renderVariantOptions(isEmitter ? ['burst', 'flow'] : ['ring', 'shockwave', 'beam', 'slash', 'glyph', 'pulse']);
  els.layerVariantInput.value = isEmitter ? layer.mode || 'flow' : layer.type || 'ring';
  els.layerAnchorInput.value = layer.anchor || 'target';
  els.layerTextureInput.disabled = !isEmitter;
  els.layerBlendInput.disabled = !isEmitter;
  els.layerTextureInput.value = layer.texture || 'soft';
  els.layerBlendInput.value = layer.blend || 'ADD';
  els.layerQuantityInput.value = isEmitter ? Number(layer.quantity ?? 1) : Number(layer.stroke ?? 3);
  els.layerFrequencyInput.value = isEmitter ? Number(layer.frequency ?? 70) : Number(layer.radius?.end ?? 90);
  els.layerDelayInput.value = Number(layer.delayMs ?? 0);
  els.layerDurationInput.value = Number(layer.durationMs ?? 0);
  els.layerColorInput.value = isEmitter ? (layer.tint || []).join(', ') : layer.color || '#ffffff';
  updateLayerFieldLabels(isEmitter);
}

function renderVariantOptions(options) {
  const current = els.layerVariantInput.value;
  els.layerVariantInput.innerHTML = options.map(option => `<option value="${option}">${option}</option>`).join('');
  if (options.includes(current)) els.layerVariantInput.value = current;
}

function updateLayerFieldLabels(isEmitter) {
  document.querySelector('label[for="layerTextureInput"]').textContent = isEmitter ? 'Texture' : 'Texture';
  document.querySelector('label[for="layerQuantityInput"]').textContent = isEmitter ? 'Quantity' : 'Stroke';
  document.querySelector('label[for="layerFrequencyInput"]').textContent = isEmitter ? 'Frequency' : 'Radius End';
  document.querySelector('label[for="layerColorInput"]').textContent = isEmitter ? 'Tint' : 'Color';
}

function selectLayer(kind, index) {
  state.selectedLayer = { kind, index };
  normalizeSelectedLayer();
  renderLayerList();
  renderLayerEditor();
}

function applyLayerEditorChange() {
  const layer = getSelectedLayer();
  const kind = state.selectedLayer.kind;
  if (!layer || !kind) return;
  const isEmitter = kind === 'emitter';
  layer.id = slugLayerId(els.layerIdInput.value || `${kind}_${state.selectedLayer.index + 1}`);
  layer.anchor = els.layerAnchorInput.value;
  layer.delayMs = clampInt(els.layerDelayInput.value, 0, 8000, 0);
  layer.durationMs = clampInt(els.layerDurationInput.value, 0, 8000, Number(layer.durationMs || 0));

  if (isEmitter) {
    layer.mode = els.layerVariantInput.value;
    layer.texture = els.layerTextureInput.value;
    layer.blend = els.layerBlendInput.value;
    layer.quantity = clampInt(els.layerQuantityInput.value, 1, 240, Number(layer.quantity || 1));
    layer.frequency = clampInt(els.layerFrequencyInput.value, 8, 2000, Number(layer.frequency || 70));
    layer.tint = parseColorList(els.layerColorInput.value);
  } else {
    layer.type = els.layerVariantInput.value;
    layer.stroke = clampFloat(els.layerQuantityInput.value, 1, 40, Number(layer.stroke || 3));
    layer.radius = layer.radius && typeof layer.radius === 'object' ? layer.radius : { start: 16, end: 90 };
    layer.radius.end = clampFloat(els.layerFrequencyInput.value, 2, 360, Number(layer.radius.end || 90));
    layer.color = parseColorList(els.layerColorInput.value)[0] || '#ffffff';
  }

  syncRecipeText();
  renderLayerList();
  replay();
}

function addEmitterLayer() {
  const index = state.recipe.emitters.length;
  state.recipe.emitters.push(defaultEmitterLayer(uniqueLayerId('emitter', index + 1)));
  selectLayer('emitter', index);
  syncAfterLayerMutation('Emitter added');
}

function addGraphicLayer() {
  const index = state.recipe.graphics.length;
  state.recipe.graphics.push(defaultGraphicLayer(uniqueLayerId('graphic', index + 1)));
  selectLayer('graphic', index);
  syncAfterLayerMutation('Graphic added');
}

function duplicateSelectedLayer() {
  const layer = getSelectedLayer();
  const collection = getSelectedCollection();
  if (!layer || !collection) return;
  const copy = cloneRecipe(layer);
  copy.id = uniqueLayerId(`${layer.id || state.selectedLayer.kind}_copy`, collection.length + 1);
  collection.splice(state.selectedLayer.index + 1, 0, copy);
  state.selectedLayer.index += 1;
  syncAfterLayerMutation('Layer duplicated');
}

function deleteSelectedLayer() {
  const collection = getSelectedCollection();
  if (!collection || !collection.length) return;
  collection.splice(state.selectedLayer.index, 1);
  normalizeSelectedLayer();
  syncAfterLayerMutation('Layer deleted');
}

function moveSelectedLayer(direction) {
  const collection = getSelectedCollection();
  if (!collection) return;
  const from = state.selectedLayer.index;
  const to = from + direction;
  if (to < 0 || to >= collection.length) return;
  const [layer] = collection.splice(from, 1);
  collection.splice(to, 0, layer);
  state.selectedLayer.index = to;
  syncAfterLayerMutation('Layer moved');
}

function syncAfterLayerMutation(message) {
  normalizeSelectedLayer();
  syncRecipeText();
  renderLayerList();
  renderLayerEditor();
  replay();
  setStatus(message);
}

function getLayerEntries() {
  return [
    ...state.recipe.emitters.map((layer, index) => ({ kind: 'emitter', index, layer })),
    ...state.recipe.graphics.map((layer, index) => ({ kind: 'graphic', index, layer })),
  ];
}

function getSelectedLayer() {
  const collection = getSelectedCollection();
  if (!collection) return null;
  return collection[state.selectedLayer.index] || null;
}

function getSelectedCollection() {
  if (state.selectedLayer.kind === 'emitter') return state.recipe.emitters;
  if (state.selectedLayer.kind === 'graphic') return state.recipe.graphics;
  return null;
}

function normalizeSelectedLayer() {
  const collection = getSelectedCollection();
  if (collection?.[state.selectedLayer.index]) return;
  if (state.recipe.emitters.length) {
    state.selectedLayer = { kind: 'emitter', index: Math.min(Math.max(0, state.selectedLayer.index), state.recipe.emitters.length - 1) };
  } else if (state.recipe.graphics.length) {
    state.selectedLayer = { kind: 'graphic', index: 0 };
  } else {
    state.selectedLayer = { kind: null, index: -1 };
  }
}

function updateControlsFromDom({ replayEffect } = { replayEffect: true }) {
  state.controls.intensity = readNumber(els.intensityRange, 1.35);
  state.controls.scale = readNumber(els.scaleRange, 1.25);
  state.controls.speed = readNumber(els.speedRange, 0.9);
  els.intensityOut.textContent = state.controls.intensity.toFixed(2);
  els.scaleOut.textContent = state.controls.scale.toFixed(2);
  els.speedOut.textContent = state.controls.speed.toFixed(2);
  updateTimeline();
  if (replayEffect) replay();
}

function updateTimeline() {
  if (!els.timelineLabel) return;
  const seconds = displayDurationMs() / 1000;
  els.timelineLabel.textContent = `0.0s -> ${seconds.toFixed(1)}s | ${state.controls.mode}`;
  if (els.playhead) {
    els.playhead.style.animationDuration = `${Math.max(0.45, seconds)}s`;
  }
}

function displayDurationMs() {
  return Math.max(300, Number(state.recipe.durationMs || 1200) / Math.max(0.35, state.controls.speed));
}

function restartPlayhead() {
  if (!els.playhead) return;
  els.playhead.style.animationName = 'none';
  requestAnimationFrame(() => {
    els.playhead.style.animationName = '';
  });
}

function selectTab(tabId) {
  document.querySelectorAll('[data-modal-id]').forEach(node => {
    node.classList.toggle('active', node.dataset.modalId === tabId);
  });
  if (tabId === 'json') els.recipeText.focus();
  if (tabId === 'prompt') {
    els.promptText.closest('.panel')?.scrollIntoView({ block: 'nearest' });
    els.promptText.focus();
  }
}

function composePromptFromIdea({ focus = true, silent = false } = {}) {
  const idea = els.ideaInput.value.trim();
  els.promptText.value = idea
    ? `${AI_AUTHORING_PROMPT}\n\nUser request:\n${idea}`
    : AI_AUTHORING_PROMPT;
  if (focus) selectTab('prompt');
  if (!silent) setStatus('Prompt ready');
  return els.promptText.value;
}

function copyFixPrompt() {
  const notes = els.reviewNotes.value.trim() || 'The current effect needs improvement. Preserve the intended skill fantasy while improving readability and timing.';
  const selectedLayer = getSelectedLayer();
  const layerHint = selectedLayer
    ? `\n\nSelected layer to inspect first (${state.selectedLayer.kind} ${state.selectedLayer.index + 1}):\n${JSON.stringify(selectedLayer, null, 2)}`
    : '';
  const prompt = `${AI_AUTHORING_PROMPT}

Revision task:
- Start from the current EffectRecipe JSON below.
- Apply the human review notes.
- Return one complete revised EffectRecipe JSON object.
- Keep schemaVersion, id format, anchors, emitter fields, graphics fields, and review.status.
- Prefer small targeted changes over rewriting the whole effect unless the notes require it.

Human review notes:
${notes}${layerHint}

Current EffectRecipe JSON:
${formatRecipe(state.recipe)}`;

  els.promptText.value = prompt;
  selectTab('prompt');
  copyText(prompt, 'Fix prompt copied');
}

function downloadRecipe() {
  const blob = new Blob([formatRecipe(state.recipe)], { type: 'application/json' });
  const url = URL.createObjectURL(blob);
  const anchor = document.createElement('a');
  anchor.href = url;
  anchor.download = `${state.recipe.id}.effect.json`;
  anchor.click();
  setTimeout(() => URL.revokeObjectURL(url), 1000);
}

async function exportSpriteSheet() {
  if (!state.scene) return;
  const sourceCanvas = document.querySelector('#fxCanvas canvas');
  if (!sourceCanvas) {
    setStatus('Canvas missing', true);
    return;
  }

  const options = getSpriteSheetOptions(sourceCanvas);
  const sheetCanvas = document.createElement('canvas');
  sheetCanvas.width = options.frameWidth * options.columns;
  sheetCanvas.height = options.frameHeight * options.rows;
  const sheetCtx = sheetCanvas.getContext('2d');
  sheetCtx.imageSmoothingEnabled = true;
  sheetCtx.imageSmoothingQuality = 'high';
  const previousControls = { ...state.controls };
  const captureControls = { ...state.controls, mode: 'oneshot' };
  setSheetStatus('capturing');
  state.scene.playRecipe(normalizeRecipe(state.recipe), captureControls);
  await waitForAnimationFrame();

  for (let frame = 0; frame < options.frames; frame += 1) {
    if (frame === 0) await sleep(60);
    else await sleep(options.frameInterval);
    const col = frame % options.columns;
    const row = Math.floor(frame / options.columns);
    sheetCtx.drawImage(
      sourceCanvas,
      0,
      0,
      sourceCanvas.width,
      sourceCanvas.height,
      col * options.frameWidth,
      row * options.frameHeight,
      options.frameWidth,
      options.frameHeight,
    );
    setSheetStatus(`${frame + 1}/${options.frames}`);
    await waitForAnimationFrame();
  }

  const blob = await canvasToBlob(sheetCanvas);
  downloadBlob(blob, `${state.recipe.id}.sheet.png`);
  setSheetStatus('saved png');
  state.scene.playRecipe(normalizeRecipe(state.recipe), previousControls);
  setTimeout(() => setSheetStatus('idle'), 1800);
}

function copySpriteSheetMeta() {
  const canvas = document.querySelector('#fxCanvas canvas');
  if (!canvas) return;
  const options = getSpriteSheetOptions(canvas);
  const meta = {
    recipeId: state.recipe.id,
    image: `${state.recipe.id}.sheet.png`,
    frameWidth: options.frameWidth,
    frameHeight: options.frameHeight,
    frames: options.frames,
    columns: options.columns,
    rows: options.rows,
    fps: options.fps,
    scale: options.scale,
  };
  copyText(JSON.stringify(meta, null, 2), 'Sheet meta copied');
  setSheetStatus('meta copied');
}

function activateOneShot() {
  state.controls.mode = 'oneshot';
  document.querySelectorAll('#playMode [data-mode]').forEach(node => {
    node.classList.toggle('active', node.dataset.mode === 'oneshot');
  });
  updateTimeline();
  replay();
}

function getSpriteSheetOptions(sourceCanvas) {
  const frames = clampInt(els.sheetFrameCount.value, 2, 32, 12);
  const columns = clampInt(els.sheetColumns.value, 1, 8, 4);
  const fps = clampInt(els.sheetFps.value, 4, 30, 12);
  const scale = clampFloat(els.sheetScale.value, 0.25, 1, 0.5);
  const rows = Math.ceil(frames / columns);
  return {
    frames,
    columns,
    rows,
    fps,
    scale,
    frameInterval: 1000 / fps,
    frameWidth: Math.max(1, Math.round(sourceCanvas.width * scale)),
    frameHeight: Math.max(1, Math.round(sourceCanvas.height * scale)),
  };
}

function setSheetStatus(text) {
  els.sheetStatus.textContent = text;
}

function setStatus(text, isError = false) {
  els.previewStatus.textContent = text;
  els.previewStatus.classList.toggle('is-error', isError);
}

function bindClick(id, handler) {
  const element = document.getElementById(id);
  if (element) element.addEventListener('click', handler);
}

function readNumber(input, fallback) {
  const number = Number(input?.value);
  return Number.isFinite(number) ? number : fallback;
}

function defaultEmitterLayer(id) {
  return {
    id,
    mode: 'flow',
    anchor: 'target',
    texture: 'soft',
    blend: 'ADD',
    quantity: 2,
    frequency: 48,
    durationMs: 620,
    lifespan: { min: 420, max: 900 },
    speed: { min: 36, max: 128 },
    angle: { min: 0, max: 360 },
    scale: { start: 0.26, end: 0.04 },
    alpha: { start: 0.82, end: 0 },
    tint: ['#ffffff', '#48c8e8'],
    gravity: { x: 0, y: -24 },
  };
}

function defaultGraphicLayer(id) {
  return {
    id,
    type: 'ring',
    anchor: 'target',
    color: '#48c8e8',
    alpha: { start: 0.74, end: 0 },
    radius: { start: 24, end: 96 },
    stroke: 4,
    durationMs: 520,
  };
}

function uniqueLayerId(prefix, seed) {
  const base = slugLayerId(`${prefix}_${seed}`);
  const used = new Set(getLayerEntries().map(entry => entry.layer.id));
  if (!used.has(base)) return base;
  let index = 2;
  while (used.has(`${base}_${index}`)) index += 1;
  return `${base}_${index}`;
}

function slugLayerId(value) {
  return String(value || 'layer')
    .trim()
    .replace(/[^a-z0-9_]+/gi, '_')
    .replace(/^_+|_+$/g, '')
    .toLowerCase() || 'layer';
}

function parseColorList(value) {
  return String(value || '')
    .split(',')
    .map(color => color.trim())
    .filter(Boolean)
    .map(color => (color.startsWith('#') ? color : `#${color}`));
}

function clampInt(value, min, max, fallback) {
  const number = Math.round(Number(value));
  if (!Number.isFinite(number)) return fallback;
  return Math.max(min, Math.min(max, number));
}

function clampFloat(value, min, max, fallback) {
  const number = Number(value);
  if (!Number.isFinite(number)) return fallback;
  return Math.max(min, Math.min(max, number));
}

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

function waitForAnimationFrame() {
  return new Promise(resolve => requestAnimationFrame(resolve));
}

function canvasToBlob(canvas) {
  return new Promise(resolve => canvas.toBlob(resolve, 'image/png'));
}

function downloadBlob(blob, filename) {
  const url = URL.createObjectURL(blob);
  const anchor = document.createElement('a');
  anchor.href = url;
  anchor.download = filename;
  anchor.click();
  setTimeout(() => URL.revokeObjectURL(url), 1000);
}

async function copyText(text, okMessage) {
  try {
    await navigator.clipboard.writeText(text);
    setStatus(okMessage);
  } catch {
    const textarea = document.createElement('textarea');
    textarea.value = text;
    textarea.style.position = 'fixed';
    textarea.style.left = '-9999px';
    document.body.appendChild(textarea);
    textarea.focus();
    textarea.select();
    document.execCommand('copy');
    textarea.remove();
    setStatus(okMessage);
  }
}

function exposeHarnessContext() {
  const context = {
    gameId: 'phaser-fx-lab',
    get recipe() {
      return state.recipe;
    },
    get reviewStatus() {
      return state.status;
    },
    replay,
    setRecipe,
    selectLayer,
    exportSpriteSheet,
    get controls() {
      return state.controls;
    },
    get selectedLayer() {
      return state.selectedLayer;
    },
    getMetrics: () => state.scene?.getMetrics?.() || null,
  };
  globalThis.__idlezPhaserUiHarness = context;
  globalThis.__phaserFxLab = context;
  els.modalStage.classList.add('is-active');
}
