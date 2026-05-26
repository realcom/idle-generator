import * as Blockly from "blockly";
import {toolbox} from "./toolbox";
import {BlocklyOptions, Theme} from "blockly";

const fontStyle = {
  family: '"Noto Sans KR", sans-serif',
  weight: '400',
  size: 10,
}

Blockly.Theme.defineTheme('TE', {
  'name': "TE",
  'base': Blockly.Themes.Zelos,
  'startHats': true,
  'componentStyles': {
    //dark mode
    'workspaceBackgroundColour': '#222',
    'toolboxBackgroundColour': '#222',
    'toolboxForegroundColour': '#fff',
    'flyoutBackgroundColour': '#222',
    'flyoutForegroundColour': '#fff',
    'flyoutOpacity': 1,
    'scrollbarColour': '#888',
    'scrollbarOpacity': 0.9,
    'insertionMarkerColour': '#fff',
    'insertionMarkerOpacity': 0.3,
    'markerColour': '#fff',
    'cursorColour': '#fff',
  },
  'blockStyles': {
    'logic_blocks': {
      'colourPrimary': '#2196F3',
      'colourSecondary': '#90CAF9',
      'colourTertiary': '#1976D2',
      'hat': 'cap',
    },
    'loop_blocks': {
      'colourPrimary': '#00BCD4',
      'colourSecondary': '#80DEEA',
      'colourTertiary': '#0097A7',
      'hat': 'cap',
    },
    'math_blocks': {
      'colourPrimary': '#8BC34A',
      'colourSecondary': '#C5E1A5',
      'colourTertiary': '#689F38',
      'hat': 'cap',
    },
    'variable_blocks': {
      'colourPrimary': '#FF9800',
      'colourSecondary': '#FFCC80',
      'colourTertiary': '#F57C00',
      'hat': 'cap',
    },
  },
  'fontStyle': fontStyle
});

export const options: BlocklyOptions = {
  toolbox: toolbox,
  theme: 'TE',
  trashcan: true,
  renderer: 'thrasos',
  zoom: {
    controls: true,
    wheel: true,
    pinch: true,
    startScale: 1.2,
    maxScale: 3,
    minScale: 0.3,
    scaleSpeed: 1.2,
  },
  move: {
    scrollbars: true,
    drag: true,
    wheel: false,
  },
  grid: {
    spacing: 10,
    length: 1.5,
    colour: '#555',
    snap: true,
  },
  comments: true,
};