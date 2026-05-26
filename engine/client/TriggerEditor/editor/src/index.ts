/* eslint-disable @typescript-eslint/no-var-requires */
import * as Blockly from 'blockly';

import {triggerIRGenerator} from './generators/triggerir';

import {AutocompleteField} from './fields/autocomplete';
import {NextAutocompleteField} from './fields/nextautocomplete';
import './index.css';
import {customBlocks} from './blocks';
import {options} from './options';

import hljs from 'highlight.js/lib/core';
import python from 'highlight.js/lib/languages/python';
import json from 'highlight.js/lib/languages/json';
import 'highlight.js/styles/monokai-sublime.css';

import {editorStrings} from './strings';
import {Workspace, WorkspaceSvg} from "blockly";

import * as keys from './keysloader'

import * as Ko from 'blockly/msg/ko';
//import {array} from "blockly/core/utils";
Blockly.setLocale(Ko);

const smalltalk = require('smalltalk');

// define clearWorkspace and clearCurrent functions as fast as possible
// because these functions are emergency functions
window.menuEvents.clearWorkspace(() => {
  clearWorkspace();
});

window.menuEvents.clearCurrent(() => {
  clearCurrent();
});

const globalData = window.electronAPI.loadData('loadData');
const globalSettings = window.electronAPI.loadSettings('loadSettings');

let stringsJson: { strings: any[] };
stringsJson = {strings: []};
export {stringsJson};

// Then register the languages you need
hljs.registerLanguage('python', python);
hljs.registerLanguage('json', json);

const scriptName = 'Trigger';
const compilerAPI = 'http://localhost:8090/compile';
const batchCompilerAPI = 'http://localhost:8090/compile_batch';
const uploadDataAPI = 'http://localhost:8090/upload/data';
const uploadPatchResourcesAPI = 'http://localhost:8090/upload/patchresources';
const variableAPI = 'http://localhost:8090/variables';

interface triggerTypeI {
  option: string,
  value: number
}

let triggerTypes: triggerTypeI[] = [];

const DIVIDER = ':';

document.title = scriptName + ' ' + editorStrings.editorTitle;
document.getElementById('title').innerText = scriptName + ' ' + editorStrings.editorTitle;

const dropdown = document.createElement('div');
dropdown.className = 'dropdown';
const dropdownButton = document.createElement('button');
dropdownButton.className = 'dropdown-button';
dropdownButton.id = 'dropdown';
dropdownButton.innerText = editorStrings.file;
const dropdownContent = document.createElement('div');
dropdownContent.className = 'dropdown-content';
const dropdownItems = [editorStrings.openWorkspace, editorStrings.saveWorkspace, editorStrings.saveAsWorkspace, '--', editorStrings.importWorkspacePatchResources, editorStrings.exportWorkspacePatchResources, '--', editorStrings.exportTriggerJSONLocal, editorStrings.exportTriggerJSON, '--', editorStrings.clearWorkspace, editorStrings.clearCurrent];

const ingameMethods = parseIngameMethods();

//createDropdownMenu();

addDatalist(loadVariables(), 'variables');

class AutocompleteFieldVariables extends NextAutocompleteField {
  constructor() {
    super();
    this.validOptions_ = 'variables';
  }
}

addDatalist(loadMethods(), 'methods');

class AutocompleteFieldMethods extends NextAutocompleteField {
  constructor() {
    super();
    this.validOptions_ = 'methods';
  }
}

addDatalist(loadMethodsReturn(), 'methodsReturn');

class AutocompleteFieldMethodsReturn extends NextAutocompleteField {
  constructor() {
    super();
    this.validOptions_ = 'methodsReturn';
  }
}

addDatalist(loadUserVariables(), 'userVariables');

class AutocompleteFieldUserVariables extends NextAutocompleteField {
  constructor() {
    super();
    this.validOptions_ = 'userVariables';
  }
}

addDatalist([], 'triggers');

class AutocompleteFieldTriggers extends NextAutocompleteField {
  constructor() {
    super();
    this.validOptions_ = 'triggers';
  }
}

addDatalist(loadDebugs(), 'debugs');

class AutocompleteFieldDebugs extends NextAutocompleteField {
  constructor() {
    super();
    this.validOptions_ = 'debugs';
  }
}

addDatalist(ingameMethods, 'ingameMethods');

class AutocompleteFieldIngameMethods extends NextAutocompleteField {
  constructor() {
    super();
    this.validOptions_ = 'ingameMethods';
  }
}

addDatalist(keys.toSingleList(keys.loadLocationIdKeys()), 'locationKeys');

class AutocompleteFieldLocationKeys extends NextAutocompleteField {
  constructor() {
    super();
    this.validOptions_ = 'locationKeys';
  }
}

addDatalist(keys.toSingleList(keys.loadStringKeys()), 'stringKeys');

class AutocompleteFieldStringKeys extends NextAutocompleteField {
  constructor() {
    super();
    this.validOptions_ = 'stringKeys';
  }
}

Blockly.fieldRegistry.register('field_autocomplete_variables', AutocompleteFieldVariables);
Blockly.fieldRegistry.register('field_autocomplete_methods', AutocompleteFieldMethods);
Blockly.fieldRegistry.register('field_autocomplete_methods_return', AutocompleteFieldMethodsReturn);
Blockly.fieldRegistry.register('field_autocomplete_uservariables', AutocompleteFieldUserVariables);
Blockly.fieldRegistry.register('field_autocomplete_debugs', AutocompleteFieldDebugs);
Blockly.fieldRegistry.register('field_autocomplete_ingamemethods', AutocompleteFieldIngameMethods);
Blockly.fieldRegistry.register('field_autocomplete_locationkeys', AutocompleteFieldLocationKeys);
Blockly.fieldRegistry.register('field_autocomplete_stringkeys', AutocompleteFieldStringKeys);

// Register the blocks and generator with Blockly
Blockly.defineBlocksWithJsonArray(customBlocks);
// override default if block to remove else if and else mutators
Blockly.Blocks['controls_if_elseif'] = {};

Blockly.dialog.setAlert(function (message, callback) {
  smalltalk.alert(message, '', {buttons: {'ok': editorStrings.ok}}).catch(() => { /* empty */ });
});

Blockly.dialog.setConfirm(function (message, callback) {
  smalltalk.confirm(message, '', {
    buttons: {ok: editorStrings.confirm, cancel: editorStrings.cancel}
  }).then(() => {
    callback(true);
  }).catch(() => {
    callback(false);
  });
});

Blockly.dialog.setPrompt(function (message, defaultValue, callback) {
  smalltalk.prompt(message, '', defaultValue, {
    buttons: {ok: editorStrings.confirm, cancel: editorStrings.cancel}
  }).then((value: string) => {
    callback(value);
  }).catch(() => {
    callback(null);
  });
});

Blockly.serialization.registry.register(
  'scroll',  // Name
  {
    save: saveScroll,      // Save function
    load: loadScroll,      // Load function
    clear: clearScroll,    // Clear function
    priority: 10,      // Priority
  });

function saveScroll(workspace: Workspace) {
  const workspaceSvg = workspace as WorkspaceSvg;

  return {
    //scrollX: workspaceSvg.scrollX,
    //scrollY: workspaceSvg.scrollY
  };
}

function loadScroll(workspace: Workspace, saved: any) {
  const workspaceSvg = workspace as WorkspaceSvg;
  //workspaceSvg.scrollX = saved.scrollX;
  //workspaceSvg.scrollY = saved.scrollY;
}

function clearScroll(workspace: Workspace) {
  /* empty */
}

// Set up UI elements and inject Blockly
const codeDiv = document.getElementById('generatedCode').firstChild as HTMLElement;
const outputDiv = document.getElementById('output').firstChild as HTMLElement;
const blocklyDiv = document.getElementById('blocklyDiv') as HTMLElement;
const ws = Blockly.inject(blocklyDiv, options);

let activeTriggerNow = JSON.parse(localStorage.getItem('activeTrigger')) || 0;

loadTriggerList();
loadTrigger(ws, activeTriggerNow);
runCode().then();

ws.addChangeListener((e) => {
  if (e.isUiEvent) return;
  saveTrigger(ws, activeTriggerNow);
});

ws.addChangeListener((e) => {
  if (e.isUiEvent || e.type == Blockly.Events.FINISHED_LOADING ||
    ws.isDragging()) {
    return;
  }
  runCode().then();
});

const file = document.createElement('input');
file.type = 'file';
file.id = 'file-selector-workspace';
file.accept = '.triggerws';
file.style.display = 'none';
document.body.appendChild(file);

document.getElementById('previewTitle').innerText = editorStrings.previewTriggerIR;
document.getElementById('outputTitle').innerText = editorStrings.previewTriggerJSON;

ws.addChangeListener(async (e) => {
  if (e.type === 'var_create') {
    await fetch(variableAPI + '/create', {
      method: 'POST',
      cache: 'no-cache',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({name: (e as Blockly.Events.VarCreate).varName})
    }).then(data => {
      data.json().then(result => {
        if (result.success) { /* empty */ } else {
          console.log(result.error);
        }
      });
    });
    fetch(variableAPI + '/list', {
      method: 'GET',
      cache: 'no-cache'
    }).then(data => {
      data.json().then(result => {
        stringsJson = result.variables;
      });
    }).catch(() => {/* empty */});
  } else if (e.type == 'var_rename') {
    await fetch(variableAPI + '/rename', {
      method: 'POST',
      cache: 'no-cache',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({oldName: (e as Blockly.Events.VarRename).oldName, newName: (e as Blockly.Events.VarRename).newName})
    }).then(data => {
      data.json().then(result => {
        if (result.success) { /* empty */ } else {
          console.log(result.error);
        }
      });
    }).catch(error => {
      console.log(error);
    });
    fetch(variableAPI + '/list', {
      method: 'GET',
      cache: 'no-cache'
    }).then(data => {
      data.json().then(result => {
        stringsJson = result.variables;
      });
    }).catch(() => {/* empty */});
  } else if (e.type == 'var_delete') {
    /* empty */
  }
});

let leftPanelProportion = 0.75;
setLeftPanelWidth(globalSettings.leftPanelWidth);

const config = JSON.parse(localStorage.getItem('config') || '{}');
if ('leftWidth' in config) {
  document.getElementById('blocklyDiv').style.width = config.leftWidth + 'px';
  document.getElementById('outputPane').style.width = (document.getElementById('horizontal').clientWidth - config.leftWidth - 20) + 'px';
  leftPanelProportion = config.leftWidth / document.getElementById('horizontal').clientWidth;
  Blockly.svgResize(ws);
}

document.getElementById('file-selector-workspace').addEventListener('change', (event) => {
  const files = (event.target as HTMLInputElement).files;
  readFileWorkspace(files[0]);
});

// capture Ctrl + S keyboard event
document.addEventListener('keydown', async (e) => {
  if ((e.ctrlKey && e.key === 's') || (e.metaKey && e.key === 's')) {
    e.preventDefault();
    await saveAll();
  }
});

// capture PageUp and PageDown keyboard event
document.addEventListener('keydown', (e) => {
  if (e.key === 'PageUp') {
    e.preventDefault();
    if (activeTriggerNow > 0) {
      activeTriggerNow--;
      loadTrigger(ws, activeTriggerNow);
    }
  } else if (e.key === 'PageDown') {
    e.preventDefault();
    const triggers = JSON.parse(localStorage.getItem('triggers'));
    if (activeTriggerNow < triggers.length - 1) {
      activeTriggerNow++;
      loadTrigger(ws, activeTriggerNow);
    }
  }
});

// capture Ctrl + F keyboard event
document.addEventListener('keydown', (e) => {
  if ((e.ctrlKey && e.key === 'f') || (e.metaKey && e.key === 'f')) {
    e.preventDefault();
    if (document.getElementsByClassName('modal').length && (document.getElementsByClassName('modal')[0] as HTMLElement).style.display === 'block') {
      const search = document.getElementById('searchTriggerModal');
      search.focus();
    } else {
      const search = document.getElementById('searchTrigger');
      search.focus();
    }
  }
});

//onresize
window.addEventListener('resize', (e: Event) => {
  const leftPanelWidth = leftPanelProportion * document.getElementById('horizontal').clientWidth;
  setLeftPanelWidth(leftPanelWidth);
  Blockly.svgResize(ws);
});

function setLeftPanelWidth(leftPanelWidth: number) {
  const divider = document.getElementById('divider');
  const container = document.getElementById('horizontal');
  const leftPanel = document.getElementById('blocklyDiv');
  const rightPanel = document.getElementById('outputPane');

  const containerRect = container.getBoundingClientRect();
  const leftPanelWidthBound = Math.max(leftPanelWidth, 200);
  const rightPanelWidth = containerRect.width - leftPanelWidthBound - divider.offsetWidth;

  if (rightPanelWidth >= 200) {
    leftPanelProportion = leftPanelWidthBound / containerRect.width;
    leftPanel.style.width = `${leftPanelWidthBound}px`;
    rightPanel.style.width = `${rightPanelWidth}px`;
    const config = JSON.parse(localStorage.getItem('config') || '{}');
    config.leftWidth = leftPanelWidth;
    localStorage.setItem('config', JSON.stringify(config));
    Blockly.svgResize(ws);
    try {
      window.electronAPI.saveSettings({leftPanelWidth: leftPanelWidth}).catch(() => { /* empty */ });
    } catch (e) {
      console.log(e);
    }
  }
}

// resizing events
document.addEventListener('DOMContentLoaded', () => {
  const divider = document.getElementById('divider');
  const container = document.getElementById('horizontal');
  const leftPanel = document.getElementById('blocklyDiv');
  const rightPanel = document.getElementById('outputPane');

  let isDragging = false;

  divider.addEventListener('mousedown', (e) => {
    isDragging = true;
  });

  document.addEventListener('mousemove', (e) => {
    if (!isDragging) return;
    const containerRect = container.getBoundingClientRect();
    const offset = e.clientX - containerRect.left;
    setLeftPanelWidth(offset);
  });

  document.addEventListener('mouseup', () => {
    if (isDragging) {
      isDragging = false;
    }
  });
});


async function openWorkspace() {
  document.getElementById('file-selector-workspace').click();
}

async function saveAsWorkspace() {
  const filePath = await window.electronAPI.showSaveDialog({
    name: editorStrings.triggerWSfile,
    extensions: ['triggerws']
  });
  if (filePath) {
    const content = wsToJSON();
    window.electronAPI.saveFile(filePath, content);
  }
}

async function saveAll() {
  const isWindowFocused = document.hasFocus();
  if (!isWindowFocused) {
    return;
  }
  await exportTriggerJSONLocal(false);
  await exportWorkspacePatchResources(false);
  smalltalk.alert(editorStrings.uploadAllSuccess, '', {buttons: {'ok': editorStrings.ok}}).catch(() => { /* empty */ });
}

async function importWorkspacePatchResources(displayAlert = true) {
  const data = window.electronAPI.importWorkspacePatchResources();
  wsFromJSON(data);
  if (displayAlert)
    smalltalk.alert(editorStrings.importWorkspacePatchResourcesSuccess, '', {buttons: {'ok': editorStrings.ok}}).catch(() => { /* empty */ });
}

async function exportWorkspacePatchResources(displayAlert = true) {
  const data = wsToJSON();
  await window.otherEvents.unwatchWorkspace();
  fetch(uploadPatchResourcesAPI, {
    method: 'POST',
    cache: 'no-cache',
    headers: {
      'Content-Type': 'application/json'
    },
    body: data
  }).then(data => {
    data.json().then(result => {
      if (result.success) {
        if (displayAlert)
          smalltalk.alert(editorStrings.uploadPatchResourcesSuccess, '', {buttons: {'ok': editorStrings.ok}}).catch(() => { /* empty */ });
      } else {
        smalltalk.alert(editorStrings.uploadPatchResourcesFail, '', {buttons: {'ok': editorStrings.ok}}).catch(() => { /* empty */ });
      }
    });
    window.otherEvents.watchWorkspace();
  }).catch((e) => {
    console.log('fetch error: exportWorkspacePatchResources');
    console.log(e);
  });
}

async function exportTriggerJSONLocal(displayAlert = true) {
  let compiledResult = null;
  let retryCount = 1;
  while (!(compiledResult = await wsToTriggerJSON())){
    if (retryCount-- <= 0) {
      smalltalk.alert(editorStrings.failedToCompile, '', {buttons: {'ok': editorStrings.ok}}).catch(() => { /* empty */ });
      return;
    }
  }

  fetch(uploadDataAPI, {
    method: 'POST',
    cache: 'no-cache',
    headers: {
      'Content-Type': 'application/json'
    },
    body: compiledResult
  }).then(data => {
    data.json().then(result => {
      if (result.success) {
        if (displayAlert)
          smalltalk.alert(editorStrings.uploadSuccess, '', {buttons: {'ok': editorStrings.ok}}).catch(() => { /* empty */ });
      } else {
        smalltalk.alert(editorStrings.uploadFail, '', {buttons: {'ok': editorStrings.ok}}).catch(() => { /* empty */ });
      }
    });
  }).catch((e) => {
    console.log('fetch error: exportTriggerJSONLocal')
    console.log(e)
  });
}

async function exportTriggerJSON() {
  let compiledResult = null;
  let retryCount = 20;
  while (!(compiledResult = await wsToTriggerJSON())){
    if (retryCount-- <= 0) {
      smalltalk.alert(editorStrings.failedToCompile, '', {buttons: {'ok': editorStrings.ok}}).catch(() => { /* empty */ });
      return;
    }
  }
  download('Triggers.json', compiledResult).then();
}

async function clearWorkspace() {
  smalltalk.confirm(editorStrings.clearAllConfirm, '', {
    buttons: {ok: editorStrings.confirm, cancel: editorStrings.cancel}
  }).then(() => {
    localStorage.clear();
    location.reload();
  }).catch(() => { /* empty */ });
}

async function clearCurrent() {
  smalltalk.confirm(editorStrings.clearCurrentConfirm, '', {
    buttons: {ok: editorStrings.confirm, cancel: editorStrings.cancel}
  }).then(() => {
    ws.clear();
  }).catch(() => { /* empty */ });
}

async function openWorkspaceElectron() {
  const data = await window.electronAPI.showOpenDialog({
    name: editorStrings.triggerWSfile,
    extensions: ['triggerws']
  });
  if ('filePath' in data && data.filePath.length > 0) {
    wsFromJSON(data.content);
  }
}

window.menuEvents.openWorkspace(async () => {
  try {
    window.otherEvents.unwatchWorkspace();
    await openWorkspaceElectron();
    window.otherEvents.watchWorkspace();
  } catch (e) { /* empty */ }
});

window.menuEvents.saveAll(() => {
  saveAll();
});

window.menuEvents.saveWorkspace(() => {
  saveWorkspaceToFile();
});

window.menuEvents.saveAsWorkspace(() => {
  saveAsWorkspace();
});

window.menuEvents.importWorkspacePatchResourcesMenu(() => {
  importWorkspacePatchResources(true);
});

window.menuEvents.exportWorkspacePatchResources(() => {
  exportWorkspacePatchResources(true);
});

window.menuEvents.exportTriggerJSONLocal(() => {
  exportTriggerJSONLocal();
});

window.menuEvents.exportTriggerJSON(() => {
  exportTriggerJSON();
});

window.menuEvents.undo(() => {
  ws.undo(false);
});

window.menuEvents.redo(() => {
  ws.undo(true);
});

window.otherEvents.alert(async (message: string) => {
  await smalltalk.alert(message, '', {buttons: {'ok': editorStrings.ok}}).catch(() => { /* empty */ });
});

window.otherEvents.loadWorkspace((data: string) => {
  wsFromJSON(data);
});


function createDropdownMenu() {
  dropdownItems.forEach((item) => {
    if (item == '--') {
      const hr = document.createElement('hr');
      dropdownContent.appendChild(hr);
      return;
    }
    const button = document.createElement('button');
    button.innerText = item;
    button.className = 'dropdown-item';
    button.addEventListener('click', async () => {
      switch (item) {
        case editorStrings.openWorkspace:
          openWorkspace();
          break;
        case editorStrings.saveWorkspace:
          saveWorkspaceToFile();
          break;
        case editorStrings.saveAsWorkspace:
          saveAsWorkspace();
          break;
        case editorStrings.importWorkspacePatchResources:
          importWorkspacePatchResources();
          break;
        case editorStrings.exportWorkspacePatchResources:
          exportWorkspacePatchResources();
          break;
        case editorStrings.exportTriggerJSONLocal:
          exportTriggerJSONLocal();
          break;
        case editorStrings.exportTriggerJSON:
          exportTriggerJSON();
          break;
        case editorStrings.clearWorkspace:
          clearWorkspace();
          break;
        case editorStrings.clearCurrent:
          clearCurrent();
          break;
      }
    });
    dropdownContent.appendChild(button);
  });

  dropdownButton.addEventListener('click', () => {
    if (dropdownContent.style.display === "block") {
      dropdownContent.style.display = "none";
    } else {
      dropdownContent.style.display = "block";
    }
  });


  document.addEventListener('click', (e) => {
    if (!dropdown.contains(e.target as HTMLElement)) {
      dropdownContent.style.display = "none";
    }
  });

  dropdown.appendChild(dropdownButton);
  dropdown.appendChild(dropdownContent);
  dropdownContent.setAttribute('style', 'z-index: 99; display: none;')
  document.getElementById('navbar').appendChild(dropdown);
}

function addDatalist(variables: string[], datalistId: string) {
  const existingDatalist = document.getElementById(datalistId);
  if (existingDatalist) {
    existingDatalist.remove();
  }
  const dataList = document.createElement('datalist');
  dataList.id = datalistId;
  variables.forEach((variable) => {
    const option = document.createElement('option');
    option.value = variable;
    dataList.appendChild(option);
  });
  document.body.appendChild(dataList);
  return variables;
}

function loadVariables() {
  const variables = [];
  const variableNameTable = new Map<string, string>();
  const resourceTrigger = globalData.protobuf.resourceTrigger as any;
  for (const variableName in resourceTrigger.nested.Commons.nested.Resources.nested.ResourceTrigger.nested.Expression.nested.Operand.nested.Variable.fields) {
    variableNameTable.set(resourceTrigger.nested.Commons.nested.Resources.nested.ResourceTrigger.nested.Expression.nested.Operand.nested.Variable.fields[variableName].type, variableName);
  }
  for (const variableGroup in resourceTrigger.nested.Commons.nested.Resources.nested.ResourceTrigger.nested.Expression.nested.Operand.nested.Variable.nested) {
    if (variableGroup !== 'Parameter' && variableGroup !== 'PredefinedVariable') {
      for (const variable in resourceTrigger.nested.Commons.nested.Resources.nested.ResourceTrigger.nested.Expression.nested.Operand.nested.Variable.nested[variableGroup].nested.Type.values) {
        variables.push(variableNameTable.get(variableGroup) + DIVIDER + variable);
      }
    }
  }
  return variables;
}

function loadUserVariables() {
  const variables = [];
  const variableNameTable = new Map<string, string>();
  const resourceTrigger = globalData.protobuf.resourceTrigger as any;
  for (const variableName in resourceTrigger.nested.Commons.nested.Resources.nested.ResourceTrigger.nested.Expression.nested.Operand.nested.Variable.fields) {
    variableNameTable.set(resourceTrigger.nested.Commons.nested.Resources.nested.ResourceTrigger.nested.Expression.nested.Operand.nested.Variable.fields[variableName].type, variableName);
  }
  for (const variableGroup in resourceTrigger.nested.Commons.nested.Resources.nested.ResourceTrigger.nested.Expression.nested.Operand.nested.Variable.nested) {
    if (variableGroup === 'Parameter') {
      for (const variable in resourceTrigger.nested.Commons.nested.Resources.nested.ResourceTrigger.nested.Expression.nested.Operand.nested.Variable.nested[variableGroup].nested.Type.values) {
        variables.push(variableNameTable.get(variableGroup) + DIVIDER + variable);
      }
    }
  }
  return variables;
}

function parseMethods() {
  const methodMetadata = globalData.json.methodMetadata as any;
  const methods = new Map<string, any>();
  for (const method of methodMetadata) {
    const methodGroup = method;
    for (const key in methodGroup) {
      if (key.toLowerCase().includes('method')) {
        methods.set((key + '/' + methodGroup[key].type).toLowerCase(), method);
        break;
      }
    }
  }
  return methods;
}

function parseIngameMethods() {
  const methodMetadata = globalData.json.methodMetadata as any;
  const methods: string[] = [];
  for (const method of methodMetadata) {
    const methodGroup = method;
    if ('isClientMethod' in method && method.isClientMethod) {
      for (const key in methodGroup) {
        if (key.toLowerCase().includes('method')) {
          methods.push(methodGroup[key].type);
          break;
        }
      }
    }
  }
  return methods;
}

function loadMethods() {
  const methods = [];
  const methodNameTable = new Map<string, string>();
  const resourceTrigger = globalData.protobuf.resourceTrigger as any;
  const methodMetadataParsed = parseMethods();
  for (const methodName in resourceTrigger.nested.Commons.nested.Resources.nested.ResourceTrigger.nested.Call.nested.Method.fields) {
    methodNameTable.set(resourceTrigger.nested.Commons.nested.Resources.nested.ResourceTrigger.nested.Call.nested.Method.fields[methodName].type, methodName);
  }
  for (const methodGroup in resourceTrigger.nested.Commons.nested.Resources.nested.ResourceTrigger.nested.Call.nested) {
    if (methodGroup === 'DebugMethod') continue;
    if (resourceTrigger.nested.Commons.nested.Resources.nested.ResourceTrigger.nested.Call.nested[methodGroup].nested && 'Type' in resourceTrigger.nested.Commons.nested.Resources.nested.ResourceTrigger.nested.Call.nested[methodGroup].nested) {
      for (const method in resourceTrigger.nested.Commons.nested.Resources.nested.ResourceTrigger.nested.Call.nested[methodGroup].nested.Type.values) {
        if (ingameMethods.includes(method)) continue; // ingameMethod는 보이지 않게 함
        if (methodMetadataParsed.get((methodGroup + '/' + method).toLowerCase()) && methodMetadataParsed.get((methodGroup + '/' + method).toLowerCase()).hasReturn) continue;
        methods.push(methodNameTable.get(methodGroup) + DIVIDER + method);
      }
    } else if (!('oneofs' in resourceTrigger.nested.Commons.nested.Resources.nested.ResourceTrigger.nested.Call.nested[methodGroup])) {
      methods.push(methodNameTable.get(methodGroup));
    }
  }
  return methods;
}

function loadMethodsReturn() {
  const methods = [];
  const methodNameTable = new Map<string, string>();
  const resourceTrigger = globalData.protobuf.resourceTrigger as any;
  const methodMetadataParsed = parseMethods();
  for (const methodName in resourceTrigger.nested.Commons.nested.Resources.nested.ResourceTrigger.nested.Call.nested.Method.fields) {
    methodNameTable.set(resourceTrigger.nested.Commons.nested.Resources.nested.ResourceTrigger.nested.Call.nested.Method.fields[methodName].type, methodName);
  }
  for (const methodGroup in resourceTrigger.nested.Commons.nested.Resources.nested.ResourceTrigger.nested.Call.nested) {
    if (methodGroup == 'DebugMethod') continue;
    if (resourceTrigger.nested.Commons.nested.Resources.nested.ResourceTrigger.nested.Call.nested[methodGroup].nested && 'Type' in resourceTrigger.nested.Commons.nested.Resources.nested.ResourceTrigger.nested.Call.nested[methodGroup].nested) {
      for (const method in resourceTrigger.nested.Commons.nested.Resources.nested.ResourceTrigger.nested.Call.nested[methodGroup].nested.Type.values) {
        if (ingameMethods.includes(method)) continue; // ingameMethod는 보이지 않게 함
        if ((!methodMetadataParsed.get((methodGroup + '/' + method).toLowerCase())) || (!methodMetadataParsed.get((methodGroup + '/' + method).toLowerCase()).hasReturn)) continue;
        methods.push(methodNameTable.get(methodGroup) + DIVIDER + method);
      }
    } else if (!('oneofs' in resourceTrigger.nested.Commons.nested.Resources.nested.ResourceTrigger.nested.Call.nested[methodGroup])) {
      methods.push(methodNameTable.get(methodGroup));
    }
  }
  return methods;
}

function loadDebugs() {
  const variables = [];
  const resourceTrigger = globalData.protobuf.resourceTrigger as any;
  for (const type of Object.keys(resourceTrigger.nested.Commons.nested.Resources.nested.ResourceTrigger.nested.Call.DebugMethod.Type)) {
    variables.push(type);
  }
  return variables;
}

async function runCode() {
  const code = triggerIRGenerator.workspaceToCode(ws);
  codeDiv.innerHTML = hljs.highlight(code, {language: 'python'}).value;

  //const codeJson = triggerScriptGenerator.workspaceToCode(ws);
  //outputDiv.innerHTML = hljs.highlight(codeJson, {language: 'json'}).value;

  // if CORS in enabled, the server should respond with Access-Control-Allow-Origin: * for OPTIONS method.
  // if CORS header for OPTIONS is not enabled, the browser will throw an error.
  try {
    await fetch(compilerAPI, {
      method: 'POST',
      cache: 'no-cache',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({code: code})
    }).then(data => {
      data.json().then(result => {

        if (result.success == false) {
          outputDiv.innerHTML = result.error;
          return;
        }

        outputDiv.innerHTML = hljs.highlight(result.code, {language: 'json'}).value;
      });
    });
  } catch (error) {
    outputDiv.innerHTML = editorStrings.compilerNotRunning;
    setTimeout(() => {
      runCode();
    }, 1000);
  }
}

function addButtonToBar(bar: string, text: string, id: string, callback: EventListener) {
  const button = document.createElement('button');
  button.innerHTML = text;
  button.id = id;
  button.className = 'button';
  document.getElementById(bar).appendChild(button);
  button.addEventListener('click', callback);
}

function loadTriggerList() {
  const searchText = (document.getElementById('searchTrigger') as HTMLInputElement)?.value ?? '';
  clearSelectorBar();
  clearSubBar();
  const triggers = JSON.parse(localStorage.getItem('triggers') || '[]');
  const options: any[] = [];
  triggers.forEach((trigger: any) => {
    options.push({value: trigger.name, option: trigger.name, index: triggers.indexOf(trigger)});
  });

  let optionsFiltered = options;
  if (searchText !== '') optionsFiltered = options.filter((option) => option.option.toLowerCase().includes(searchText.toLowerCase()));

  let activeTrigger = activeTriggerNow;
  if (activeTrigger === null) {
    activeTrigger = 0;
  }
  addInputToBar('selectorbar', editorStrings.searchTrigger, 'searchTrigger', 'text', searchText, (e: Event) => {
    const value = (e.target as HTMLInputElement).value;
    const optionsFiltered = options.filter((option) => option.option.toLowerCase().includes(value.toLowerCase()));
    const element = document.getElementById('trigger') as HTMLSelectElement;
    element.innerHTML = '';
    optionsFiltered.forEach((option) => {
      const opt = document.createElement('option');
      opt.value = option.index;
      opt.innerHTML = option.option;
      element.appendChild(opt);
    });
  });
  addIndexSelectorToBar('selectorbar', editorStrings.selectTrigger, 'trigger', optionsFiltered, activeTrigger, (e: Event) => {
    const index = parseInt((e.target as HTMLSelectElement).value);
    changeActiveTrigger(ws, index);
  });
  addButtonToBar('selectorbar', editorStrings.addTrigger, 'createTrigger', (_: Event) => {
    smalltalk.prompt(editorStrings.promptTriggerName, '', '', {
      buttons: {ok: editorStrings.confirm, cancel: editorStrings.cancel}
    }).then((newName: string) => {
      newName = newName.trim();
      if (newName === null) return;
      addTriggerItem(newName);
    }).catch(() => { /* empty */ });
  });
  addButtonToBar('selectorbar', editorStrings.editTriggerList, 'editTriggerList', (_: Event) => {
    openTriggerListModal();
  });
  const resourceTrigger = globalData.protobuf.resourceTrigger as any;
  const types = resourceTrigger.nested.Commons.nested.Resources.nested.ResourceTrigger.nested.Type.values;
  const typesArray = Object.keys(types).map((key) => {
    return {option: key, value: types[key]}
  });
  typesArray.unshift({option: 'None', value: 'None'});
  triggerTypes = typesArray;
  addButtonToBar('subbar', editorStrings.refresh, 'refresh', (_: Event) => {
    location.reload();
  });
  addSelectorToBar('subbar', editorStrings.type, 'triggerType', typesArray, 0, (e: Event) => {
    updateTriggerOption('triggerType', (e.target as HTMLSelectElement).value);
  });
  addNumericInputToBar('subbar', editorStrings.period, 'period', 'number', 0, 1000, 0, (e: Event) => {
    updateTriggerOption('period', (e.target as HTMLSelectElement).value);
  });


  const triggersArray = triggers.map((trigger: any) => {
   return trigger.name
  });

  document.getElementById('triggers').remove();
  addDatalist(triggersArray, 'triggers');

  Blockly.fieldRegistry.unregister('field_autocomplete_triggers');
  Blockly.fieldRegistry.register('field_autocomplete_triggers', AutocompleteFieldTriggers);

  loadTriggerTypeAndPeriod();
}

function addTriggerItem(triggerName: string) {
  const triggers = JSON.parse(localStorage.getItem('triggers') || '[]');
  triggers.push({name: triggerName, triggerType: editorStrings.selectUndefined, period: '0'});
  localStorage.setItem('triggers', JSON.stringify(triggers));
  const workspaces = JSON.parse(localStorage.getItem('workspaces') || '[]');
  workspaces.push({});
  localStorage.setItem('workspaces', JSON.stringify(workspaces));
  activeTriggerNow = triggers.length - 1;
  loadTriggerList();
  loadTrigger(ws, activeTriggerNow);
}

function loadDefaultVariables() {
  // add default blockly variables
  const callbackVariables = (data: Response) => {
    data.json().then(result => {
      stringsJson = result.variables;
      if (result.success) {
        const variables = [];
        for (const i of result.variables.strings) {
          if ((!('category' in i) || i.category === 'Editor') && 'english' in i && !i.english.startsWith('Location/')) {
            variables.push(i.english);
          }
        }
        const variablesUsed = ws.getAllVariables();
        for (const i of variablesUsed) {
          if (!variables.includes(i.name)) {
            // 08-24: remove function of variable deletion
            // confirm dialog will appear otherwise.
            //ws.deleteVariableById(i.getId());
          } else {
            variables.splice(variables.indexOf(i.name), 1);
          }
        }
        for (const i of variables) {
          ws.createVariable(i);
        }
      }
    });
  }
  fetch(variableAPI + '/list', {
    method: 'GET',
    cache: 'no-cache'
  }).then(callbackVariables).catch((e) => {
    // retry after 3 seconds
    setTimeout(() => {
      fetch(variableAPI + '/list', {
        method: 'GET',
        cache: 'no-cache'
      }).then(callbackVariables).catch(() => {
        console.log('fetch error: loadDefaultVariables');
      });
    }, 3000);
  });
}

function refreshVariables() {
  loadDefaultVariables();
  addDatalist(loadUserVariables(), 'userVariables');
}

function updateTriggerOption(option: string, value: any) {
  const triggers = JSON.parse(localStorage.getItem('triggers') || '[]');
  triggers[activeTriggerNow][option] = value;
  localStorage.setItem('triggers', JSON.stringify(triggers));
}

function loadTrigger(workspace: Workspace, index: number) {
  const data = JSON.parse(localStorage.getItem('workspaces') || '[]');

  if (!data || data.length === 0) {
    addTriggerItem('default/defaultTrigger')
    return;
  }
  if (index == null) {
    index = 0;
  }

  if (!data[index]) {
    ws.clear();
    return;
  }

  Blockly.Events.disable();
  Blockly.serialization.workspaces.load(data[index], workspace);
  Blockly.Events.enable();

  loadDefaultVariables();
  loadTriggerList();
  runCode().then();
}

function loadTriggerTypeAndPeriod() {
  const triggers = JSON.parse(localStorage.getItem('triggers') || '[]');
  if (triggers.length === 0) {
    return;
  }
  const trigger = triggers[activeTriggerNow];
  if (trigger && 'triggerType' in trigger && trigger.triggerType !== editorStrings.selectUndefined) {
    (document.getElementById('triggerType') as HTMLSelectElement).value = trigger.triggerType;
  }
  if (trigger && 'period' in trigger && trigger.period !== 0) {
    (document.getElementById('period') as HTMLInputElement).value = trigger.period;
  }
  if (!trigger) {
    console.log(trigger);
  }
}

function saveTrigger(workspace: Workspace, index: number) {
  const data = Blockly.serialization.workspaces.save(workspace);
  const workspaces = JSON.parse(localStorage.getItem('workspaces') || '[]');
  if (index == null || index >= workspaces.length) {
    console.log('error on saveTrigger');
    return;
  }
  workspaces[index] = data;
  localStorage.setItem('workspaces', JSON.stringify(workspaces));
}

function changeActiveTrigger(workspace: Workspace, newIndex: number) {
  saveTrigger(workspace, activeTriggerNow);
  activeTriggerNow = newIndex;
  localStorage.setItem('activeTrigger', JSON.stringify(newIndex));
  loadTrigger(workspace, newIndex);
  activeTriggerNow = newIndex;
}

function clearSelectorBar() {
  const bar = document.getElementById('selectorbar');
  while (bar.firstChild) {
    bar.removeChild(bar.firstChild);
  }
}

function clearSubBar() {
  const bar = document.getElementById('subbar');
  while (bar.firstChild) {
    bar.removeChild(bar.firstChild);
  }
}

function addIndexSelectorToBar(bar: string, label: string, id: string, options: {
  value: string,
  option: string,
  index: number
}[], selectedIndex: number, callback: EventListener) {
  const labelElement = document.createElement('label');
  labelElement.innerHTML = label;
  labelElement.htmlFor = id;
  document.getElementById(bar).appendChild(labelElement);

  const select = document.createElement('select');
  select.id = id;
  select.className = 'select';

  let index = 0;
  let setIndex = 0;

  options.forEach((option) => {
    const optionElement = document.createElement('option');
    optionElement.value = '' + option.index;
    optionElement.innerText = option.option;
    select.appendChild(optionElement);
    if (option.index === selectedIndex) {
      setIndex = index;
    }
    index += 1;
  });
  select.selectedIndex = setIndex;

  document.getElementById(bar).appendChild(select);
  select.addEventListener('change', callback);
}

function addSelectorToBar(bar: string, label: string, id: string, options: {
  value: string,
  option: string
}[], selectedIndex: number, callback: EventListener) {
  const labelElement = document.createElement('label');
  labelElement.innerHTML = label;
  labelElement.htmlFor = id;
  document.getElementById(bar).appendChild(labelElement);

  const select = document.createElement('select');
  select.id = id;
  select.className = 'select';

  options.forEach((option) => {
    const optionElement = document.createElement('option');
    optionElement.value = option.value;
    optionElement.innerText = option.option;
    select.appendChild(optionElement);
  });

  select.selectedIndex = selectedIndex;

  document.getElementById(bar).appendChild(select);
  select.addEventListener('change', callback);
}

function addNumericInputToBar(bar: string, label: string, id: string, type: string, minimum: number, maximum: number, value: number, callback: EventListener) {
  const labelElement = document.createElement('label');
  labelElement.innerHTML = label;
  labelElement.htmlFor = id;
  document.getElementById(bar).appendChild(labelElement);

  const input = document.createElement('input');
  input.id = id;
  input.className = 'input';
  input.type = type;

  input.value = value.toString();
  input.min = minimum.toString();
  input.max = maximum.toString();
  document.getElementById(bar).appendChild(input);
  input.addEventListener('change', callback);
  input.setAttribute('autocomplete', 'off');
}

function addInputToBar(bar: string, label: string, id: string, type: string, value: string, callback: EventListener) {
  const labelElement = document.createElement('label');
  labelElement.innerHTML = label;
  labelElement.htmlFor = id;
  document.getElementById(bar).appendChild(labelElement);

  const input = document.createElement('input');
  input.id = id;
  input.className = 'input';
  input.type = type;

  input.value = value;
  document.getElementById(bar).appendChild(input);
  input.addEventListener('change', callback);
  input.setAttribute('autocomplete', 'off');
}

function wsFromJSON(data: string) {
  const parsedData = JSON.parse(data);
  localStorage.setItem('workspaces', JSON.stringify(parsedData.workspaces));
  localStorage.setItem('activeTrigger', JSON.stringify(parsedData.activeTrigger));
  localStorage.setItem('triggers', JSON.stringify(parsedData.triggers));
  loadTrigger(ws, parsedData.activeTrigger);
  activeTriggerNow = parsedData.activeTrigger;
  if (activeTriggerNow == null) activeTriggerNow = 0;
  loadTriggerList();
  runCode().then();
}

function sortKeys(obj: any): any {
  if (typeof obj !== 'object' || obj === null) {
    return obj;
  }

  if (Array.isArray(obj)) {
    return obj.map(sortKeys);
  }

  const sortedKeys = Object.keys(obj).sort();
  const result: { [key: string]: any } = {};

  for (const key of sortedKeys) {
    result[key] = sortKeys(obj[key]);
  }

  return result;
}

function sortedStringify(obj: any, space = 2): string {
  return JSON.stringify(sortKeys(obj), null, space);
}

function wsToJSON() {
  saveTrigger(ws, activeTriggerNow);
  let data = JSON.parse(localStorage.getItem('workspaces'));
  const index = JSON.parse(localStorage.getItem('activeTrigger'));
  const triggers = JSON.parse(localStorage.getItem('triggers'));
  if (triggers.length < data.length) {
    data = data.slice(0, triggers.length);
  }
  let json = sortedStringify({workspaces: data, activeTrigger: index, triggers: triggers}, 2);
  json  = json.replace(/[\u007F-\uFFFF]/g, function(chr) {
    return "\\u" + ("0000" + chr.charCodeAt(0).toString(16)).substr(-4)
  })
  return json;
}

async function wsToTriggerJSON() {
  saveTrigger(ws, activeTriggerNow);
  const workspaces = JSON.parse(localStorage.getItem('workspaces'));
  const triggers = JSON.parse(localStorage.getItem('triggers'));

  const codes = [];

  const alertPopup = smalltalk.alert(editorStrings.saving, '', {buttons: {}}).catch(() => { /* empty */ });
  document.querySelectorAll('.close-button').forEach((element) => {
    element.remove();
  });

  for (let i = 0; i < workspaces.length; i++) {
    loadTrigger(ws, i);
    const code = triggerIRGenerator.workspaceToCode(ws);
    codes.push(code);
  }
  loadTrigger(ws, activeTriggerNow);

  console.log('Compiling triggers in batch...');
  const result = await fetch(batchCompilerAPI, {
    method: 'POST',
    cache: 'no-cache',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({codes: codes})
  }).then(async data => {
    const result1 = await data.json();
    const resultCodes: any[] = [];
    if (result1.success == false) {
      return;
    }
    const len = Math.min(workspaces.length, triggers.length);
    for (let i = 0; i < len; i++) {
      resultCodes.push({
        name: triggers[i].name,
        statements: JSON.parse(result1.codes[i]),
      });
      if (triggers[i].triggerType !== editorStrings.selectUndefined) {
        resultCodes[i].type = triggerTypes.find((element) => element.value === parseInt(triggers[i].triggerType)).option;
        // handle the default value
        if (resultCodes[i].type == 'OnStart') {
          delete resultCodes[i].type;
        }
      }
      if (triggers[i].period !== 0) {
        resultCodes[i].period = parseInt(triggers[i].period);
        // handle the default value
        if (resultCodes[i].period == 0) {
          delete resultCodes[i].period;
        }
      }
    }
    return resultCodes;
  }).catch(error => {
    console.log(error);
    return null;
  });

  document.querySelectorAll('.smalltalk').forEach((element) => {
    element.remove();
  });

  changeActiveTrigger(ws, activeTriggerNow);

  return JSON.stringify(result, null, 2);
}

async function download(filename: string, text: string) {
  const blob = new Blob([text], {type: 'text/plain'});
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = filename;
  a.click();
}

function saveWorkspaceToFile(filename = 'workspace.triggerws') {
  const data = wsToJSON();
  download(filename, data).then();
}

async function saveWorkspaceToFilePrompt() {
  const content = wsToJSON();
  try {
    const filePath = await window.electronAPI.showSaveDialog({
      name: editorStrings.triggerWSfile,
      extensions: ['triggerws']
    });
    if (filePath) {
      window.electronAPI.saveFile(filePath, content);
    }
  } catch (e) {
    // user aborted
    return;
  }
}

function readFileWorkspace(path: Blob) {
  const reader = new FileReader();
  reader.onload = function (e) {
    try {
      const data = e.target.result;
      wsFromJSON(data as string);
    } catch (error) {
      console.log(error);
    }
  };
  reader.readAsText(path);
}

let triggerBeingDragged: HTMLElement;

function openTriggerListModal() {
  // draw a modal to show the trigger list
  const modal = document.createElement('div');
  let searchText = '';
  modal.className = 'modal';
  modal.innerHTML = `
    <div class="modal-content">
      <div class="modal-title"><h4>` + editorStrings.editTriggerList + `</h4>
        <input id="searchTriggerModal" type="text" class="input" placeholder="` + editorStrings.search + `">
        <select class="dropdown-modal">
          <option value="default" selected>` + editorStrings.sort + `</option>
          <option value="name_asc">` + editorStrings.sortNameAsc + `</option>
          <option value="name_desc">` + editorStrings.sortNameDesc + `</option>
          <option value="random">` + editorStrings.sortRandom + `</option>
        </select>
      </div>
      <div class="modal-body" id="trigger-list"></div>
      <div class="modal-footer">
        <button id="closeModal" class="button button-modal">` + editorStrings.close + `</button>
      </div>
    </button>
  `;
  const select = modal.querySelector('.dropdown-modal');
  select.addEventListener('change', sortModal);
  document.body.appendChild(modal);
  modal.style.display = 'block';
  const backdrop = document.createElement('div');
  backdrop.className = 'modal-backdrop';
  document.body.appendChild(backdrop);
  const search = modal.querySelector('input');
  search.addEventListener('input', (e: Event) => {
    searchText = (e.target as HTMLInputElement).value;
    const triggers = JSON.parse(localStorage.getItem('triggers') || '[]');
    const triggerList = document.getElementById('trigger-list');
    const filteredTriggers = triggers.filter((trigger: any) => trigger.name.toLowerCase().includes(searchText.toLowerCase()));
    displayTriggerList(filteredTriggers, triggerList, triggers);
  });

  function deleteTrigger(e: Event) {
    e.stopPropagation();
    smalltalk.confirm(editorStrings.deleteTriggerConfirm, '', {
      buttons: {ok: editorStrings.confirm, cancel: editorStrings.cancel}
    }).then(() => {
      const triggers = JSON.parse(localStorage.getItem('triggers') || '[]');
      const workspaces = JSON.parse(localStorage.getItem('workspaces') || '[]');
      triggers.splice(parseInt((e.target as Element).getAttribute('data-index')), 1);
      workspaces.splice(parseInt((e.target as Element).getAttribute('data-index')), 1);
      localStorage.setItem('triggers', JSON.stringify(triggers));
      localStorage.setItem('workspaces', JSON.stringify(workspaces));
      activeTriggerNow = 0;
      loadTriggerList();
      loadTrigger(ws, activeTriggerNow);
      (e.target as Element).parentElement.parentElement.remove();

      // order the trigger list in ascending order
      const newTriggers = JSON.parse(localStorage.getItem('triggers') || '[]');
      const triggerList = document.getElementById('trigger-list');

      for (const i of newTriggers) {
        i.index = newTriggers.indexOf(i);
      }
      newTriggers.sort((a: any, b: any) => a.name > b.name ? 1 : -1);
      displayTriggerList(newTriggers, triggerList, newTriggers);
      const triggerItems = triggerList.querySelectorAll('.trigger-item');
      for (const i of triggerItems) {
        i.setAttribute('data-index', newTriggers[parseInt(i.getAttribute('data-index'))].index);
      }
      saveTriggerList();

      const triggersArray = newTriggers.map((trigger: any) => {
        return trigger.name
      });

      document.getElementById('triggers').remove();
      addDatalist(triggersArray, 'triggers');
    }).catch(() => { /* empty */ });
  }

  function renameTrigger(event: Event) {
    // launch a prompt box to change name
    event.stopPropagation();
    let target = event.target as HTMLElement;
    while (target.className !== 'trigger-item') {
      target = target.parentElement;
    }
    smalltalk.prompt(editorStrings.promptTriggerName, '', target.querySelector('.trigger-name').innerHTML, {
      buttons: {ok: editorStrings.confirm, cancel: editorStrings.cancel}
    }).then((newName: string) => {
      newName = newName.trim();
      if (newName === null) return;
      if (newName === '') return;
      const triggers = JSON.parse(localStorage.getItem('triggers') || '[]');
      const index = parseInt(target.getAttribute('data-index'));
      triggers[index].name = newName;
      localStorage.setItem('triggers', JSON.stringify(triggers));
      loadTriggerList();

      const newTriggerDiv = singleTriggerItem(null, newName, index.toString());

      target.innerHTML = newTriggerDiv.innerHTML;

      const triggersArray = triggers.map((trigger: any) => {
        return trigger.name
      });

      document.getElementById('triggers').remove();
      addDatalist(triggersArray, 'triggers');

    }).catch(() => { /* empty */
    });
  }

  function closeModal() {
    modal.style.display = 'none';
    document.body.removeChild(modal);
    document.body.removeChild(backdrop);
    loadTriggerList();
  }

  function sortModal(e: Event) {
    const triggers = JSON.parse(localStorage.getItem('triggers') || '[]');
    const triggerList = document.getElementById('trigger-list');

    for (const i of triggers) {
      i.index = triggers.indexOf(i);
    }

    switch ((e.target as HTMLSelectElement).value) {
      case 'name_asc':
        triggers.sort((a: any, b: any) => a.name > b.name ? 1 : -1);
        break;
      case 'name_desc':
        triggers.sort((a: any, b: any) => a.name < b.name ? 1 : -1);
        break;
      case 'random':
        for (let i = triggers.length - 1; i > 0; i--) {
          const j = Math.floor(Math.random() * (i + 1));
          [triggers[i], triggers[j]] = [triggers[j], triggers[i]];
        }
        break;
    }

    displayTriggerList(triggers, triggerList, triggers);
    const triggerItems = triggerList.querySelectorAll('.trigger-item');
    for (const i of triggerItems) {
      i.setAttribute('data-index', triggers[parseInt(i.getAttribute('data-index'))].index);
    }
    saveTriggerList();
  }

  backdrop.addEventListener('click', () => {
    closeModal();
  });

  document.getElementById('closeModal').addEventListener('click', () => {
    closeModal();
  });

  // capture esc keypress
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
      if (modal.style.display === 'block') {
        closeModal();
      }
    }
  });

  const triggers = JSON.parse(localStorage.getItem('triggers') || '[]');
  const triggerList = document.getElementById('trigger-list');

  displayTriggerList(triggers, triggerList, triggers);

  function displayTriggerList(triggers: any[], target: HTMLElement, triggersOrderReference: any[]) {
    target.innerHTML = '';
    for (const i in triggers) {
      const trigger = triggers[i];

      const triggerDiv = singleTriggerItem(null, trigger.name, triggersOrderReference.indexOf(trigger).toString());
      target.appendChild(triggerDiv);

      triggerDiv.addEventListener('click', () => {
        changeActiveTrigger(ws, parseInt(triggerDiv.getAttribute('data-index')));
        closeModal();
      });
    }
  }

  function saveTriggerList() {
    const triggers = JSON.parse(localStorage.getItem('triggers') || '[]');
    const workspaces = JSON.parse(localStorage.getItem('workspaces') || '[]');
    const triggerItems = document.querySelectorAll('.trigger-item');
    const triggersNew = [];
    const workspacesNew = [];

    for (let i = 0; i < triggerItems.length; i++) {
      const index = parseInt(triggerItems[i].getAttribute('data-index'));
      triggersNew.push(triggers[index]);
      workspacesNew.push(workspaces[index]);
      triggerItems[i].setAttribute('data-index', i.toString());
    }
    localStorage.setItem('triggers', JSON.stringify(triggersNew));
    localStorage.setItem('workspaces', JSON.stringify(workspacesNew));

    loadTriggerList();
    loadTrigger(ws, activeTriggerNow);
  }

  // triggerList.ondragstart = (e) => {
  //   if (searchText !== '') return; // disable drag when searching
  //   triggerBeingDragged = e.target as HTMLElement;
  //   (e.target as HTMLElement).classList.add('trigger-item-dragging');
  // };
  // triggerList.ondragend = (e) => {
  //   if (searchText !== '') return; // disable drag when searching
  //   (e.target as HTMLElement).classList.remove('trigger-item-dragging');
  //   saveTriggerList();
  //   activeTriggerNow = parseInt(triggerBeingDragged.getAttribute('data-index'));
  //
  //   triggerBeingDragged = null;
  // };
  // triggerList.ondragover = (e) => {
  //   if (searchText !== '') return; // disable drag when searching
  //   e.preventDefault();
  //   const afterElement = getDragAfterElement(triggerList, e.clientY);
  //   if (afterElement == null) {
  //     triggerList.appendChild(triggerBeingDragged);
  //   } else {
  //     triggerList.insertBefore(triggerBeingDragged, afterElement);
  //   }
  // };


  function duplicateTrigger(e: Event) {
    e.stopPropagation();
    smalltalk.confirm(editorStrings.duplicateTriggerConfirm, '', {
      buttons: {ok: editorStrings.confirm, cancel: editorStrings.cancel}
    }).then(() => {
      const triggers = JSON.parse(localStorage.getItem('triggers') || '[]');
      const workspaces = JSON.parse(localStorage.getItem('workspaces') || '[]');
      const selectedIndex = parseInt((e.target as Element).getAttribute('data-index'));
      const newName = triggers[selectedIndex].name + ' - ' + editorStrings.copy;
      const newTrigger = {name: newName, triggerType: triggers[selectedIndex].triggerType, period: triggers[selectedIndex].period};
      triggers.push(newTrigger);      // sort the trigger list in ascending order
      localStorage.setItem('triggers', JSON.stringify(triggers));
      workspaces.push(workspaces[selectedIndex]);
      localStorage.setItem('workspaces', JSON.stringify(workspaces));
      activeTriggerNow = triggers.length - 1;

      // order the trigger list in ascending order
      const newTriggers = JSON.parse(localStorage.getItem('triggers') || '[]');
      const triggerList = document.getElementById('trigger-list');

      for (const i of newTriggers) {
        i.index = newTriggers.indexOf(i);
      }
      newTriggers.sort((a: any, b: any) => a.name > b.name ? 1 : -1);
      displayTriggerList(newTriggers, triggerList, newTriggers);
      const triggerItems = triggerList.querySelectorAll('.trigger-item');
      for (const i of triggerItems) {
        i.setAttribute('data-index', newTriggers[parseInt(i.getAttribute('data-index'))].index);
      }
      saveTriggerList();

      const triggersArray = newTriggers.map((trigger: any) => {
        return trigger.name
      });

      document.getElementById('triggers').remove();
      addDatalist(triggersArray, 'triggers');
    }).catch(() => { /* empty */ });
  }

  function singleTriggerItem(triggerDiv: HTMLElement, triggerName: string, index: string): HTMLElement {
    if (triggerDiv == null) triggerDiv = document.createElement('div');
    triggerDiv.className = 'trigger-item';
    triggerDiv.innerHTML = `
      <div class="trigger-name">` + triggerName + `</div>
    `;

    const buttonContainer = document.createElement('div');
    buttonContainer.className = 'trigger-edit-container';
    triggerDiv.appendChild(buttonContainer);

    const buttonDuplicate = document.createElement('div');
    buttonDuplicate.className = 'trigger-edit';
    buttonDuplicate.innerText = editorStrings.duplicate;
    buttonContainer.appendChild(buttonDuplicate);
    buttonDuplicate.setAttribute('data-index', index);
    buttonDuplicate.addEventListener('click', duplicateTrigger);

    const buttonChangeName = document.createElement('div');
    buttonChangeName.className = 'trigger-edit';
    buttonChangeName.innerText = editorStrings.changeName;
    buttonChangeName.addEventListener('click', renameTrigger);
    buttonContainer.appendChild(buttonChangeName);

    const buttonDelete = document.createElement('div');
    buttonDelete.className = 'trigger-edit';
    buttonDelete.innerText = editorStrings.deleteTrigger;
    buttonContainer.appendChild(buttonDelete);
    buttonDelete.setAttribute('data-index', index);

    buttonDelete.addEventListener('click', deleteTrigger);

    triggerDiv.setAttribute('data-index', index);
    // make triggerDiv draggable to change the order
    //triggerDiv.draggable = true;
    return triggerDiv;
  }

  // function getDragAfterElement(draglist: Element, Y: number) {
  //   const draggableElements = [...document.querySelectorAll('.trigger-item:not(.trigger-item-dragging)')];
  //   return draggableElements.reduce((closest, child) => {
  //     const box = child.getBoundingClientRect();
  //     const offset = Y - box.top - box.height / 2;
  //     if (offset < 0 && offset > closest.offset) {
  //       return {offset: offset, element: child};
  //     } else {
  //       return closest;
  //     }
  //   }, {offset: Number.NEGATIVE_INFINITY, element: null}).element;
  // }
}