/**
 * @license
 * Copyright 2023 Google LLC
 * SPDX-License-Identifier: Apache-2.0
 */

/*
This toolbox contains nearly every single built-in block that Blockly offers,
in addition to the custom block 'add_text' this sample app adds.
You probably don't need every single block, and should consider either rewriting
your toolbox from scratch, or carefully choosing whether you need each block
listed here.
*/

import {editorStrings} from "./strings";

export const toolbox = {
  'kind': 'categoryToolbox',
  'contents': [
    {
      'kind': 'category',
      'name': editorStrings.logic,
      'categorystyle': 'logic_category',
      'contents': [
        {
          'kind': 'block',
          'type': 'controls_if',
        },
        {
          'kind': 'block',
          'type': 'logic_compare',
        },
        {
          'kind': 'block',
          'type': 'logic_operation',
        },
        {
          'kind': 'block',
          'type': 'logic_negate',
        },
        {
          'kind': 'block',
          'type': 'logic_boolean',
        },
      ],
    },
    {
      'kind': 'category',
      'name': editorStrings.loops,
      'categorystyle': 'loop_category',
      'contents': [
        {
          'kind': 'block',
          'type': 'controls_repeat_ext',
          'inputs': {
            'TIMES': {
              'shadow': {
                'type': 'math_number',
                'fields': {
                  'NUM': 10,
                },
              },
            },
          },
        },
        {
          'kind': 'block',
          'type': 'controls_whileUntil',
        },
        {
          'kind': 'block',
          'type': 'controls_flow_statements',
        },
      ],
    },
    {
      'kind': 'category',
      'name': editorStrings.math,
      'categorystyle': 'math_category',
      'contents': [
        {
          'kind': 'block',
          'type': 'math_number',
          'fields': {
            'NUM': 123,
          },
        },
        {
          'kind': 'block',
          'type': 'math_arithmetic',
          'inputs': {
            'A': {
              'shadow': {
                'type': 'math_number',
                'fields': {
                  'NUM': 1,
                },
              },
            },
            'B': {
              'shadow': {
                'type': 'math_number',
                'fields': {
                  'NUM': 1,
                },
              },
            },
          },
        },
        {
          'kind': 'block',
          'type': 'math_number_property',
          'inputs': {
            'NUMBER_TO_CHECK': {
              'shadow': {
                'type': 'math_number',
                'fields': {
                  'NUM': 0,
                },
              },
            },
          },
        },
        {
          'kind': 'block',
          'type': 'math_modulo',
          'inputs': {
            'DIVIDEND': {
              'shadow': {
                'type': 'math_number',
                'fields': {
                  'NUM': 64,
                },
              },
            },
            'DIVISOR': {
              'shadow': {
                'type': 'math_number',
                'fields': {
                  'NUM': 10,
                },
              },
            },
          },
        },
      ],
    },
    {
      kind: 'category',
      name: editorStrings.text,
      categorystyle: 'text_category',
      contents: [
        {
          kind: 'block',
          type: 'text',
        },
        {
          kind: 'block',
          type: 'fxeventdispatch_get',
        },
      ]
    },
    {
      'kind': 'sep',
    },
    {
      'kind': 'category',
      'name': editorStrings.userVariables,
      'categorystyle': 'variable_category',
      'custom': 'VARIABLE',
    },
    {
      'kind': 'category',
      'name': editorStrings.outputCall,
      'categorystyle': 'procedure_category',
      'contents': [
        {
          'kind': 'block',
          'type': 'variables_set_reserved',
        },
        {
          'kind': 'block',
          'type': 'variables_get_reserved',
        },
        {
          'kind': 'block',
          'type': 'function_call',
        },
        {
          'kind': 'block',
          'type': 'function_call_with_arguments',
        },
        {
          'kind': 'block',
          'type': 'function_call_return',
        },
        {
          'kind': 'block',
          'type': 'trigger_call',
        },
        {
          'kind': 'block',
          'type': 'debug',
        },
        {
          'kind': 'block',
          'type': 'ingame_methods',
        },
        {
          'kind': 'block',
          'type': 'return',
        },
      ],
    },
    {
      'kind': 'category',
      'name': editorStrings.specialVariables,
      'colour': '#26A69A',
      'contents': [
        {
          'kind': 'block',
          'type': 'variables_user_set'
        },
        {
          'kind': 'block',
          'type': 'variables_user_get'
        },
        {
          'kind': 'block',
          'type': 'variables_predefined_set'
        },
        {
          'kind': 'block',
          'type': 'variables_predefined_get'
        },
      ]
    },
    {
      'kind': 'category',
      'name': editorStrings.predefined,
      'categorystyle': 'colour_category',
      'contents': [
        {
          'kind': 'block',
          'type': 'locationkeys_get'
        },
        {
          'kind': 'block',
          'type': 'teamtag_get'
        },
        {
          'kind': 'block',
          'type': 'weapontypes_get'
        },
        {
          'kind': 'block',
          'type': 'stringkeys_get'
        },
        {
          'kind': 'block',
          'type': 'stringkeysDirectly_get'
        },
        {
          'kind': 'block',
          'type': 'stringkeyToIds_get'
        },
        {
          'kind': 'block',
          'type': 'maptypes_get'
        },
        {
          'kind': 'block',
          'type': 'tags_get'
        },
        {
          'kind': 'block',
          'type': 'gameboardstates_get'
        }
      ]
    },
  ],
};
