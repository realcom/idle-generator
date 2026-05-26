import {app, shell, dialog} from 'electron';
import {editorStrings} from './strings';

const isMac = process.platform === 'darwin';

import {mainWindow} from './main';

export const template = [
  // { role: 'appMenu' }
  ...(isMac
    ? [{
      label: 'Trigger Editor',
      submenu: [
        {role: 'about'},
        {type: 'separator'},
        {role: 'services'},
        {type: 'separator'},
        {role: 'hide'},
        {role: 'hideOthers'},
        {role: 'unhide'},
        {type: 'separator'},
        {role: 'quit'}
      ]
    }]
    : []),
  // { role: 'fileMenu' }
  {
    label: editorStrings.file,
    submenu: [
      /*{
        role: 'openWorkspace', label: editorStrings.openWorkspace, click: async () => {
          mainWindow.webContents.send('openWorkspace');
        }
      },
      {
        role: 'saveWorkspace', label: editorStrings.saveWorkspace, click: async () => {
          mainWindow.webContents.send('saveWorkspace');
        }
      },*/
      {
        role: 'importWorkspacePatchResourcesMenu', label: editorStrings.importWorkspacePatchResources, click: async () => {
          mainWindow.webContents.send('importWorkspacePatchResourcesMenu');
        }
      },
      {type: 'separator'},
      {
        role: 'exportWorkspacePatchResources', label: editorStrings.exportWorkspacePatchResources, click: async () => {
          mainWindow.webContents.send('exportWorkspacePatchResources');
        }
      },
      {
        role: 'exportTriggerJSONLocal', label: editorStrings.exportTriggerJSONLocal, click: async () => {
          mainWindow.webContents.send('exportTriggerJSONLocal');
        }
      },
      {
        role: 'saveAll', label: editorStrings.saveAll, click: async () => {
          mainWindow.webContents.send('saveAll');
        }
      },
      /*{
        role: 'exportTriggerJSON', label: editorStrings.exportTriggerJSON, click: async () => {
          mainWindow.webContents.send('exportTriggerJSON');
        }
      },*/
      {type: 'separator'},
      {
        role: 'clearWorkspace', label: editorStrings.clearWorkspace, click: async () => {
          mainWindow.webContents.send('clearWorkspace');
        }
      },
      {
        role: 'clearCurrent', label: editorStrings.clearCurrent, click: async () => {
          mainWindow.webContents.send('clearCurrent');
        }
      },
      {type: 'separator'},
      {
        role: 'killCompiler', label: editorStrings.killCompiler, click: async () => {
          /* empty */
        }
      }
    ]
  },
  // { role: 'editMenu' }
  {
    label: editorStrings.edit,
    submenu: [
      {
        role: 'undo', label: editorStrings.undo, click: async () => {
          /* empty */
        }
      },
      {
        role: 'redo', label: editorStrings.redo, click: async () => {
          /* empty */
        }
      },
      /*{type: 'separator'},
      {
        role: 'cut', label: editorStrings.cut, click: async () => {
          mainWindow.webContents.send('cut');
        }
      },
      {
        role: 'copy', label: editorStrings.copy, click: async () => {
          mainWindow.webContents.send('copy');
        }
      },
      {
        role: 'paste', label: editorStrings.paste, click: async () => {
          mainWindow.webContents.send('paste');
        }
      },
      {
        role: 'delete', label: editorStrings.delete, click: async () => {
          mainWindow.webContents.send('delete');
        }
      },
      {type: 'separator'},
      {
        role: 'selectAll', label: editorStrings.selectAll, click: async () => {
          mainWindow.webContents.send('selectAll');
        }
      }*/
    ]
  },
  // { role: 'viewMenu' }
  {
    label: editorStrings.view,
    submenu: [
      {role: 'reload', label: editorStrings.reload},
      {role: 'toggleDevTools', label: editorStrings.toggleDevTools},
      {type: 'separator'},
      {role: 'resetZoom', label: editorStrings.resetZoom},
      {role: 'zoomIn', label: editorStrings.zoomIn},
      {role: 'zoomOut', label: editorStrings.zoomOut},
      {type: 'separator'},
      {role: 'togglefullscreen', label: editorStrings.toggleFullscreen}
    ]
  },
  // { role: 'windowMenu' }
  {
    label: editorStrings.window,
    submenu: [
      {role: 'minimize', label: editorStrings.minimize},
      {role: 'zoom', label: editorStrings.zoom},
      ...(isMac
        ? [
          {type: 'separator'},
          {role: 'front', label: editorStrings.front},
          {type: 'separator'},
          {role: 'window', label: editorStrings.window},
        ]
        : [
          {role: 'close', label: editorStrings.close}
        ])
    ]
  },
  {
    role: 'help',
    label: editorStrings.help,
    submenu: [
      {
        label: editorStrings.help,
        click: async () => {
          await shell.openExternal('https://github.com/puzzlemonsters/commons/wiki/Editor')
        }
      }
    ]
  }
];
