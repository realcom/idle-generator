/* eslint-disable @typescript-eslint/ban-types */
interface IFile {
  filePath: string,
  content: string
}

export interface IElectronAPI {
  loadData: (channel: string) => Function<void>,
  showSaveDialog: (filter: object) => Promise<string>,
  saveFile: (filePath: string, content: string) => Function<void>,
  onSaveFileResponse: (callback: Function) => Function<void>,
  showOpenDialog: (filter: object) => Promise<IFile>,
  loadSettings: (channel: string) => Function<void>,
  saveSettings: (data: object) => Promise<void>,
  importWorkspacePatchResources: () => Function<void>,
}

declare global {
  interface Window {
    electronAPI: IElectronAPI
    menuEvents: {
      openWorkspace: (callback: Function) => Function<void>,
      saveAll: (callback: Function) => Function<void>,
      saveWorkspace: (callback: Function) => Function<void>,
      saveAsWorkspace: (callback: Function) => Function<void>,
      importWorkspacePatchResourcesMenu: (callback: Function) => Function<void>,
      exportWorkspacePatchResources: (callback: Function) => Function<void>,
      exportTriggerJSONLocal: (callback: Function) => Function<void>,
      exportTriggerJSON: (callback: Function) => Function<void>,
      clearWorkspace: (callback: Function) => Function<void>,
      clearCurrent: (callback: Function) => Function<void>,
      undo: (callback: Function) => Function<void>,
      redo: (callback: Function) => Function<void>,
      cut: (callback: Function) => Function<void>,
      copy: (callback: Function) => Function<void>,
      paste: (callback: Function) => Function<void>,
      delete: (callback: Function) => Function<void>,
      selectAll: (callback: Function) => Function<void>
    },
    otherEvents: {
      alert: (callback: Function) => Function<string>,
      loadWorkspace: (callback: Function) => Function<string>,
      watchWorkspace: () => Function<void>,
      unwatchWorkspace: () => Function<void>
    }
  }
}