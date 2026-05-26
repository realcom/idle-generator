/* eslint-disable @typescript-eslint/ban-types */
// See the Electron documentation for details on how to use preload scripts:
// https://www.electronjs.org/docs/latest/tutorial/process-model#preload-scripts

import {contextBridge, ipcRenderer} from "electron";

contextBridge.exposeInMainWorld('electronAPI', {
  loadData: (channel: any) => {
    return ipcRenderer.sendSync(channel);
  },
  showSaveDialog: (filter: object) => ipcRenderer.invoke('show-save-dialog', filter),
  saveFile: (filePath: string, content: string) => ipcRenderer.send('save-file', filePath, content),
  onSaveFileResponse: (callback: Function) => ipcRenderer.on('save-file-response', (event, response) => callback(response)),
  showOpenDialog: (filter: object) => ipcRenderer.invoke('show-open-dialog', filter),
  loadSettings: (channel: any) => ipcRenderer.sendSync(channel),
  saveSettings: (data: object) => ipcRenderer.invoke('saveSettings', data),
  importWorkspacePatchResources: () => ipcRenderer.sendSync('importWorkspacePatchResources'),
})

contextBridge.exposeInMainWorld('menuEvents', {
  openWorkspace: (callback: Function) => ipcRenderer.on('openWorkspace', (event) => callback()),
  saveAll: (callback: Function) => ipcRenderer.on('saveAll', (event) => callback()),
  saveWorkspace: (callback: Function) => ipcRenderer.on('saveWorkspace', (event) => callback()),
  saveAsWorkspace: (callback: Function) => ipcRenderer.on('saveAsWorkspace', (event) => callback()),
  importWorkspacePatchResourcesMenu: (callback: Function) => ipcRenderer.on('importWorkspacePatchResourcesMenu', (event) => callback()),
  exportWorkspacePatchResources: (callback: Function) => ipcRenderer.on('exportWorkspacePatchResources', (event) => callback()),
  exportTriggerJSONLocal: (callback: Function) => ipcRenderer.on('exportTriggerJSONLocal', (event) => callback()),
  exportTriggerJSON: (callback: Function) => ipcRenderer.on('exportTriggerJSON', (event) => callback()),
  clearWorkspace: (callback: Function) => ipcRenderer.on('clearWorkspace', (event) => callback()),
  clearCurrent: (callback: Function) => ipcRenderer.on('clearCurrent', (event) => callback()),
  undo: (callback: Function) => ipcRenderer.on('undo', (event) => callback()),
  redo: (callback: Function) => ipcRenderer.on('redo', (event) => callback()),
  cut: (callback: Function) => ipcRenderer.on('cut', (event) => callback()),
  copy: (callback: Function) => ipcRenderer.on('copy', (event) => callback()),
  paste: (callback: Function) => ipcRenderer.on('paste', (event) => callback()),
  delete: (callback: Function) => ipcRenderer.on('delete', (event) => callback()),
  selectAll: (callback: Function) => ipcRenderer.on('selectAll', (event) => callback()),
})

contextBridge.exposeInMainWorld('otherEvents', {
  alert: (callback: Function) => ipcRenderer.on('alert', (event, message) => callback(message)),
  loadWorkspace: (callback: Function) => ipcRenderer.on('loadWorkspace', (event, data) => callback(data)),
  watchWorkspace: () => ipcRenderer.invoke('watchWorkspace'),
  unwatchWorkspace: () => ipcRenderer.invoke('unwatchWorkspace'),
})