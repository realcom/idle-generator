import * as Blockly from "blockly";

import * as keys from "./keysloader";

export interface predefinedVariablesDataInterface {
  [key: string]: any;
}

import * as config from './config';

interface parameterInterface {
  optional: boolean,
  defaultValue: number,
  comment: string,
  index: number,
}

interface parametersInterface {
  [key: string]: parameterInterface;
}

interface argumentDataInterface {
  [key: string]: parametersInterface;
}

export const argumentData: argumentDataInterface = {};

const globalData = window.electronAPI.loadData('loadData');

const methodMetadata = globalData.json.methodMetadata as any;
const resourceTrigger = globalData.protobuf.resourceTrigger as any;
const resourceItemTypes = globalData.protobuf.resourceItemTypes as any;
const resourceMapTypes = globalData.protobuf.resourceMapTypes as any;

const methods = resourceTrigger.nested.Commons.nested.Resources.nested.ResourceTrigger.nested.Call.nested.Method.fields;

for (const metadata in methodMetadata) {
  const currentMetadata = methodMetadata[metadata];
  let methodName = null;
  let methodNow = null;
  for (const method in methods) {
    if (method in currentMetadata) {
      methodName = method;
      methodNow = currentMetadata[method];
      break;
    }
  }

  if (methodName == null) continue;

  if ('type' in methodNow) {
    methodName += ':' + methodNow.type;
  }

  const parameters = currentMetadata.parameters
  const parameterArray: parametersInterface = {};
  let argnum = 0;
  for (const parameter in parameters) {
    parameterArray[parameters[parameter].parameter.type] = {
      optional: parameters[parameter].optional,
      defaultValue: parameters[parameter].defaultValue,
      comment: parameters[parameter].comment,
      index: argnum,
    }
    argnum++;
  }
  argumentData[methodName] = parameterArray;
}

const weaponTypes = resourceItemTypes.nested.Type.values;
const weaponTypesArray: any[] = [];
Object.entries(weaponTypes).forEach(([key, value]) => {weaponTypesArray.push([key, '' + value])});

const mapTypes = resourceMapTypes.nested.Type.values;
const mapTypesArray: any[] = [];
Object.entries(mapTypes).forEach(([key, value]) => {mapTypesArray.push([key, '' + value])});

const tags = globalData.protobuf.eTags.values;
const tagsArray: any[] = [];
Object.entries(tags).forEach(([key, value]) => {tagsArray.push([key, '' + value])});

const boardStates = globalData.protobuf.eGameBoardStates.values;
const boardStatesArray: any[] = [];
Object.entries(boardStates).forEach(([key, value]) => {boardStatesArray.push([key, '' + value])});

import {editorStrings} from './strings';

const Align = Blockly.inputs.Align;

function loadUserVariables() {
  const variables = [];
  for (const variableGroup in resourceTrigger.nested.Commons.nested.Resources.nested.ResourceTrigger.nested.Expression.nested.Operand.nested.Variable.nested) {
    if (variableGroup === 'Parameter') {
      for (const variable in resourceTrigger.nested.Commons.nested.Resources.nested.ResourceTrigger.nested.Expression.nested.Operand.nested.Variable.nested[variableGroup].nested.Type.values) {
        variables.push([variable, variable]);
      }
    }
  }
  return variables;
}

function loadPredefinedVariables() {
  const variables = [];
  for (const variableGroup in resourceTrigger.nested.Commons.nested.Resources.nested.ResourceTrigger.nested.Expression.nested.Operand.nested.Variable.nested) {
    if (variableGroup === 'PredefinedVariable') {
      for (const variable in resourceTrigger.nested.Commons.nested.Resources.nested.ResourceTrigger.nested.Expression.nested.Operand.nested.Variable.nested[variableGroup].nested.Type.values) {
        variables.push([variable, variable]);
      }
    }
  }
  return variables;
}

const userVariables = loadUserVariables();
const predefinedVariables = loadPredefinedVariables();
const locationIdKeys = keys.loadLocationIdKeys();
const stringKeys = keys.loadStringKeys();

const CALL_MUTATOR_MIXIN = {
  mutationToDom: function () {
    // You *must* create a <mutation></mutation> element.
    // This element can have children.
    const container = Blockly.utils.xml.createElement('mutation');
    container.setAttribute('itemCount', String(this.itemCount_));
    if (this.metadata_)
      container.setAttribute('metadata', JSON.stringify(this.metadata_));
    return container;
  },

  domToMutation: function (xmlElement: Element) {
    const itemCount = xmlElement.getAttribute('itemCount');
    if (!itemCount) throw new TypeError('element did not have items');
    this.itemCount_ = parseInt(itemCount, 10) || 0;
    if (xmlElement.getAttribute('metadata'))
      this.metadata_ = JSON.parse(xmlElement.getAttribute('metadata'));
    this.updateShape_(this.itemCount_);
  },

  updateShape_: function (this: any, itemCount: number) {
    let i;
    for (i = 0; i < itemCount; i++) {
      if (!this.getInput('ARG' + i)) {
        const input = this.appendValueInput('ARG' + i);
        if (config.argumentTypes.has(this.metadata_[i].name)) {
          input.setCheck(config.argumentTypes.get(this.metadata_[i].name));
        } else
          input.setCheck('Number');
        let fieldName = this.metadata_[i].comment ?? this.metadata_[i].name;
        input.appendField(fieldName);
        input.setAlign(Align.RIGHT);
      }
    }
    while (this.getInput('ARG' + i)) {
      try {
        this.removeInput('ARG' + i);
      } catch (e) {
        break;
      }
      i++;
    }
  }
};

const CALL_MUTATOR_EXTENSION = function (this: any) {
  this.getField('NAME').setValidator(function (option: string) {
    let itemCount = 0;
    if (option in argumentData) {
      itemCount = Object.keys(argumentData[option]).length;
    } else itemCount = 0;

    this.sourceBlock_.metadata_ = [];
    for (const i in argumentData[option]) {
      this.sourceBlock_.metadata_.push({
        comment: argumentData[option][i].comment,
        name: i,
      });
    }

    this.sourceBlock_.itemCount_ = itemCount;
    this.sourceBlock_.updateShape_(itemCount);
    return option;
  });
};

const VARIABLE_MUTATOR_MIXIN = {
  mutationToDom: function () {
    // You *must* create a <mutation></mutation> element.
    // This element can have children.
    const container = Blockly.utils.xml.createElement('mutation');
    return container;
  },

  domToMutation: function (xmlElement: Element) {
    // Set the shape of the block
    this.updateShape_();
  },

  updateShape_: function (this: any) {
    // TODO: mutator
  },
};

const VARIABLE_MUTATOR_EXTENSION = function (this: any) {
  this.getField('VAR').setValidator(function (option: string) {
    this.sourceBlock_.updateShape_();
    return option;
  });
};

const PREDEFINEDVARIABLE_MUTATOR_MIXIN = {
  mutationToDom: function () {
    // You *must* create a <mutation></mutation> element.
    // This element can have children.
    const container = Blockly.utils.xml.createElement('mutation');
    container.setAttribute('itemCount', String(this.itemCount_));
    if (this.metadata_)
      container.setAttribute('metadata', JSON.stringify(this.metadata_));
    return container;
  },

  domToMutation: function (xmlElement: Element) {
    const itemCount = xmlElement.getAttribute('itemCount');
    if (!itemCount) throw new TypeError('element did not have items');
    this.itemCount_ = parseInt(itemCount, 10) || 0;
    if (xmlElement.getAttribute('metadata'))
      this.metadata_ = JSON.parse(xmlElement.getAttribute('metadata'));
    this.updateShape_(this.itemCount_);
  },

  updateShape_: function (this: any, itemCount: number) {
    let i;

    for (i = 0; i < itemCount; i++) {
      if (!this.getInput('ARG' + i)) {
        const input = this.appendValueInput('ARG' + i);
        input.setAlign(Align.RIGHT);
        input.setCheck('Number');
        input.appendField(this.metadata_[i].variable);
      }
    }
    while (this.getInput('ARG' + i)) {
      try {
        this.removeInput('ARG' + i);
      } catch (e) {
        break;
      }
      i++;
    }
  },
};

const PREDEFINEDVARIABLE_MUTATOR_EXTENSION = function (this: any) {
  this.getField('VAR').setValidator(function (option: string) {
    let itemCount = 0;

    if (config.predefinedVariablesData.has(option)) {
      itemCount = config.predefinedVariablesData.get(option).length;

      this.sourceBlock_.metadata_ = [];
      for (const i in config.predefinedVariablesData.get(option)) {
        this.sourceBlock_.metadata_.push({
          variable: config.predefinedVariablesData.get(option)[i].variable,
          offset: config.predefinedVariablesData.get(option)[i].offset,
        });
      }

      this.sourceBlock_.itemCount_ = itemCount;
      this.sourceBlock_.updateShape_(itemCount);
    } else {
      this.sourceBlock_.itemCount_ = 0;
      this.sourceBlock_.updateShape_(0);
      this.sourceBlock_.metadata_ = [];
    }
    return option;
  });
};

const teamTagKeys: any[] = [];
Array.from(config.teamTagKeys.keys()).forEach((key) => teamTagKeys.push([key, key]));

Blockly.Extensions.registerMutator('call_mutator', CALL_MUTATOR_MIXIN, CALL_MUTATOR_EXTENSION);
Blockly.Extensions.registerMutator('variable_mutator', VARIABLE_MUTATOR_MIXIN, VARIABLE_MUTATOR_EXTENSION);
Blockly.Extensions.registerMutator('predefinedvariable_mutator', PREDEFINEDVARIABLE_MUTATOR_MIXIN, PREDEFINEDVARIABLE_MUTATOR_EXTENSION);

export const customBlocks = [
  {
    'type': 'controls_if',
    'message0': editorStrings.if,
    'args0': [
      {
        'type': 'input_value',
        'name': 'IF0',
        'check': ['Boolean', 'Number'],
      },
    ],
    'message1': editorStrings.do,
    'args1': [
      {
        'type': 'input_statement',
        'name': 'DO0',
      },
    ],
    'previousStatement': null as any,
    'nextStatement': null as any,
    'style': 'logic_blocks',
    'helpUrl': '%{BKY_CONTROLS_IF_HELPURL}',
    'suppressPrefixSuffix': true,
    'mutator': 'controls_if_mutator',
    'extensions': ['controls_if_tooltip'],
  },
  {
    'type': 'variables_set_reserved',
    'message0': editorStrings.setVariableReserved,
    'args0': [
      {
        'type': 'field_autocomplete_variables',
        'name': 'VAR',
      },
      {
        'type': 'input_value',
        'name': 'VALUE',
        'check': 'Number',
      },
      {
        'type': 'field_checkbox',
        'name': 'THIS',
        'checked': false,
      },
    ],
    'previousStatement': null as any,
    'nextStatement': null as any,
    'colour': '#5C6BC0',
    'tooltip': '%{BKY_VARIABLES_SET_TOOLTIP}',
    'helpUrl': '%{BKY_VARIABLES_SET_HELPURL}',
    'extensions': ['contextMenu_variableSetterGetter'],
  },
  {
    'type': 'variables_get_reserved',
    'message0': 'caller%2 %1',
    'args0': [
      {
        'type': 'field_autocomplete_variables',
        'name': 'VAR',
      },
      {
        'type': 'field_checkbox',
        'name': 'THIS',
        'checked': false,
      },
    ],
    'output': 'Number',
    'colour': '#5C6BC0',
    'tooltip': '%{BKY_VARIABLES_GET_TOOLTIP}',
    'helpUrl': '%{BKY_VARIABLES_GET_HELPURL}',
    'extensions': ['contextMenu_variableSetterGetter'],
  },
  {
    'type': 'function_call',
    'message0': editorStrings.call,
    'args0': [
      {
        'type': 'field_autocomplete_methods',
        'name': 'NAME',
      },
      {
        'type': 'field_checkbox',
        'name': 'THIS',
        'checked': false,
      },
    ],
    'previousStatement': null as any,
    'nextStatement': null as any,
    'colour': 'rgb(255, 102, 128)',
    'tooltip': '%{BKY_FUNCTION_CALL_TOOLTIP}',
    'helpUrl': '%{BKY_FUNCTION_CALL_HELPURL}',
    'mutator': 'call_mutator',
  },
  {
    'type': 'function_call_with_arguments',
    'message0': editorStrings.callWithArguments,
    'args0': [
      {
        'type': 'field_autocomplete_methods',
        'name': 'NAME',
      },
      {
        'type': 'field_checkbox',
        'name': 'THIS',
        'checked': false,
      },
      {
        'type': 'input_value',
        'name': 'TEXT',
        'check': 'String',
      }
    ],
    'message1': '인자 (Number) %1',
    'args1': [
      {
        'type': 'input_value',
        'name': 'VAR1',
        'check': 'Number',
        'align': 'RIGHT',
      },
    ],
    'previousStatement': null as any,
    'nextStatement': null as any,
    'colour': 'rgb(255, 102, 128)',
    'tooltip': '%{BKY_FUNCTION_CALL_TOOLTIP}',
    'helpUrl': '%{BKY_FUNCTION_CALL_HELPURL}',
    'mutator': 'call_mutator',
  },
  {
    'type': 'function_call_return',
    'message0': editorStrings.callReturn,
    'args0': [
      {
        'type': 'field_autocomplete_methods_return',
        'name': 'NAME',
      },
      {
        'type': 'field_checkbox',
        'name': 'THIS',
        'checked': false,
      },
    ],
    'output': 'Number',
    'colour': 'rgb(255, 102, 128)',
    'tooltip': '%{BKY_FUNCTION_CALL_TOOLTIP}',
    'helpUrl': '%{BKY_FUNCTION_CALL_HELPURL}',
    'mutator': 'call_mutator',
  },
  {
    'type': 'trigger_call',
    'message0': editorStrings.callTrigger,
    'args0': [
      {
        'type': 'field_autocomplete_triggers',
        'name': 'NAME',
      },
      {
        'type': 'field_checkbox',
        'name': 'THIS',
        'checked': false,
      },
    ],
    'previousStatement': null as any,
    'nextStatement': null as any,
    'colour': 'rgb(255, 87, 34)',
    'tooltip': '%{BKY_FUNCTION_CALL_TOOLTIP}',
    'helpUrl': '%{BKY_FUNCTION_CALL_HELPURL}',
  },
  {
    'type': 'debug',
    'message0': editorStrings.blockDebug0,
    'args0': [
      {
        'type': 'field_autocomplete_debugs',
        'name': 'NAME',
      },
      {
        'type': 'input_value',
        'name': 'TEXT',
        'check': 'String',
      }
    ],
    'message1': editorStrings.blockDebug1,
    'args1': [
      {
        'type': 'input_value',
        'name': 'VAR',
        'check': 'Number',
        'align': 'RIGHT',
      },
    ],
    'previousStatement': null as any,
    'nextStatement': null as any,
    'style': 'list_blocks',
    'tooltip': '%{BKY_FUNCTION_CALL_TOOLTIP}',
    'helpUrl': '%{BKY_FUNCTION_CALL_HELPURL}',
  },
  {
    'type': 'ingame_methods',
    'message0': editorStrings.blockIngame0,
    'args0': [
      {
        'type': 'field_autocomplete_ingamemethods',
        'name': 'NAME',
      },
      {
        'type': 'input_value',
        'name': 'TEXT',
        'check': 'String',
      }
    ],
    'message1': editorStrings.blockIngame1,
    'args1': [
      {
        'type': 'input_value',
        'name': 'VAR1',
        'check': 'Number',
        'align': 'RIGHT',
      },
    ],
    'message2': editorStrings.blockIngame2,
    'args2': [
      {
        'type': 'input_value',
        'name': 'VAR2',
        'check': 'Number',
        'align': 'RIGHT',
      },
    ],
    'message3': editorStrings.blockIngame3,
    'args3': [
      {
        'type': 'input_value',
        'name': 'VAR3',
        'check': 'Number',
        'align': 'RIGHT',
      },
    ],
    'message4': editorStrings.blockIngame4,
    'args4': [
      {
        'type': 'input_value',
        'name': 'VAR4',
        'check': 'Number',
        'align': 'RIGHT',
      },
    ],
    'message5': editorStrings.blockIngame5,
    'args5': [
      {
        'type': 'input_value',
        'name': 'VAR5',
        'check': 'Number',
        'align': 'RIGHT',
      },
    ],
    'previousStatement': null as any,
    'nextStatement': null as any,
    'style': 'list_blocks',
    'tooltip': '%{BKY_FUNCTION_CALL_TOOLTIP}',
    'helpUrl': '%{BKY_FUNCTION_CALL_HELPURL}',
  },
  {
    'type': 'return',
    'message0': editorStrings.return,
    'previousStatement': null as any,
    'nextStatement': null as any,
    'colour': 'rgb(255, 102, 128)',
    'tooltip': '%{BKY_RETURN_TOOLTIP}',
    'helpUrl': '%{BKY_RETURN_HELPURL}',
  },
  {
    'type': 'variables_get',
    'message0': '%2 %1',
    'args0': [
      {
        'type': 'field_variable',
        'name': 'VAR',
        'variable': '%{BKY_VARIABLES_DEFAULT_NAME}',
      },
      {
        'type': 'field_dropdown',
        'name': 'TYPE',
        'options': config.variableTypes
      },
    ],
    'output': 'Number',
    'style': 'variable_blocks',
    'helpUrl': '%{BKY_VARIABLES_GET_HELPURL}',
    'tooltip': '%{BKY_VARIABLES_GET_TOOLTIP}',
    'mutator': 'variable_mutator',
    'extensions': ['contextMenu_variableSetterGetter'],
  },
  // Block for variable setter.
  {
    'type': 'variables_set',
    'message0': editorStrings.setVariable,
    'args0': [
      {
        'type': 'field_variable',
        'name': 'VAR',
        'variable': '%{BKY_VARIABLES_DEFAULT_NAME}',
      },
      {
        'type': 'input_value',
        'name': 'VALUE',
      },
      {
        'type': 'field_dropdown',
        'name': 'TYPE',
        'options': config.variableTypes
      },
    ],
    'previousStatement': null as any,
    'nextStatement': null as any,
    'style': 'variable_blocks',
    'tooltip': '%{BKY_VARIABLES_SET_TOOLTIP}',
    'helpUrl': '%{BKY_VARIABLES_SET_HELPURL}',
    'extensions': ['contextMenu_variableSetterGetter'],
  },
  {
    'type': 'math_change',
    'message0': editorStrings.change,
    'args0': [
      {
        'type': 'field_variable',
        'name': 'VAR',
        'variable': '%{BKY_MATH_CHANGE_TITLE_ITEM}',
      },
      {
        'type': 'input_value',
        'name': 'DELTA',
        'check': 'Number',
      },
      {
        'type': 'field_dropdown',
        'name': 'TYPE',
        'options': config.variableTypes
      },
    ],
    'previousStatement': null as any,
    'nextStatement': null as any,
    'style': 'variable_blocks',
    'helpUrl': '%{BKY_MATH_CHANGE_HELPURL}',
    'extensions': ['math_change_tooltip'],
  },
  {
    'type': 'variables_user_get',
    'message0': 'Parameter:%1',
    'args0': [
      {
        'type': 'field_dropdown',
        'name': 'VAR',
        'options': userVariables,
      },
    ],
    'output': 'Number',
    //'style': 'variable_blocks',
    'colour': '#26A69A',
    'helpUrl': '%{BKY_VARIABLES_GET_HELPURL}',
    'tooltip': '%{BKY_VARIABLES_GET_TOOLTIP}',
    'extensions': ['contextMenu_variableSetterGetter'],
  },
  {
    'type': 'variables_user_set',
    'message0': editorStrings.setVariableUser,
    'args0': [
      {
        'type': 'field_dropdown',
        'name': 'VAR',
        'options': userVariables,
      },
      {
        'type': 'input_value',
        'name': 'VALUE',
        'check': 'Number',
      },
    ],
    'previousStatement': null as any,
    'nextStatement': null as any,
    //'style': 'variable_blocks',
    'colour': '#26A69A',
    'tooltip': '%{BKY_VARIABLES_SET_TOOLTIP}',
    'helpUrl': '%{BKY_VARIABLES_SET_HELPURL}',
    'extensions': ['contextMenu_variableSetterGetter'],
  },
  // Block for boolean data type: true and false.
  {
    'type': 'logic_boolean',
    'message0': '%1',
    'args0': [
      {
        'type': 'field_dropdown',
        'name': 'BOOL',
        'options': [
          ['%{BKY_LOGIC_BOOLEAN_TRUE}', 'TRUE'],
          ['%{BKY_LOGIC_BOOLEAN_FALSE}', 'FALSE'],
        ],
      },
    ],
    'output': 'Number',
    'style': 'logic_blocks',
    'tooltip': '%{BKY_LOGIC_BOOLEAN_TOOLTIP}',
    'helpUrl': '%{BKY_LOGIC_BOOLEAN_HELPURL}',
  },
  // Block for logical operations: 'and', 'or'.
  {
    'type': 'logic_operation',
    'message0': '%1 %2 %3',
    'args0': [
      {
        'type': 'input_value',
        'name': 'A',
        'check': ['Boolean', 'Number'],
      },
      {
        'type': 'field_dropdown',
        'name': 'OP',
        'options': [
          [editorStrings.and, 'AND'],
          [editorStrings.or, 'OR'],
        ],
      },
      {
        'type': 'input_value',
        'name': 'B',
        'check': ['Boolean', 'Number'],
      },
    ],
    'inputsInline': true,
    'output': 'Boolean',
    'style': 'logic_blocks',
    'helpUrl': '%{BKY_LOGIC_OPERATION_HELPURL}',
    'extensions': ['logic_op_tooltip'],
  },
  // Block for negation.
  {
    'type': 'logic_negate',
    'message0': editorStrings.not,
    'args0': [
      {
        'type': 'input_value',
        'name': 'BOOL',
        'check': ['Boolean', 'Number'],
      },
    ],
    'output': 'Boolean',
    'style': 'logic_blocks',
    'tooltip': '%{BKY_LOGIC_NEGATE_TOOLTIP}',
    'helpUrl': '%{BKY_LOGIC_NEGATE_HELPURL}',
  },
  // Block for repeat n times (external number).
  {
    'type': 'controls_repeat_ext',
    'message0': editorStrings.repeat0,
    'args0': [
      {
        'type': 'input_value',
        'name': 'TIMES',
        'check': 'Number',
      },
    ],
    'message1': editorStrings.repeat1,
    'args1': [
      {
        'type': 'input_statement',
        'name': 'DO',
      },
    ],
    'previousStatement': null as any,
    'nextStatement': null as any,
    'style': 'loop_blocks',
    'tooltip': '%{BKY_CONTROLS_REPEAT_TOOLTIP}',
    'helpUrl': '%{BKY_CONTROLS_REPEAT_HELPURL}',
  },
  // Block for 'do while/until' loop.
  {
    'type': 'controls_whileUntil',
    'message0': editorStrings.whileUntil,
    'args0': [
      {
        'type': 'field_dropdown',
        'name': 'MODE',
        'options': [
          [editorStrings.while, 'WHILE'],
          [editorStrings.until, 'UNTIL'],
        ],
      },
      {
        'type': 'input_value',
        'name': 'BOOL',
        'check': ['Boolean', 'Number'],
      },
    ],
    'message1': editorStrings.repeat1,
    'args1': [
      {
        'type': 'input_statement',
        'name': 'DO',
      },
    ],
    'previousStatement': null as any,
    'nextStatement': null as any,
    'style': 'loop_blocks',
    'helpUrl': '%{BKY_CONTROLS_WHILEUNTIL_HELPURL}',
    'extensions': ['controls_whileUntil_tooltip'],
  },
  // Block for flow statements: continue, break.
  {
    'type': 'controls_flow_statements',
    'message0': '%1',
    'args0': [
      {
        'type': 'field_dropdown',
        'name': 'FLOW',
        'options': [
          [editorStrings.break, 'BREAK'],
          [editorStrings.continue, 'CONTINUE'],
        ],
      },
    ],
    'previousStatement': null as any,
    'style': 'loop_blocks',
    'helpUrl': '%{BKY_CONTROLS_FLOW_STATEMENTS_HELPURL}',
    'suppressPrefixSuffix': true,
    'extensions': ['controls_flow_tooltip', 'controls_flow_in_loop_check'],
  },
  // Block for checking if a number is even, odd, prime, whole, positive,
  // negative or if it is divisible by certain number.
  {
    'type': 'math_number_property',
    'message0': '%1 %2',
    'args0': [
      {
        'type': 'input_value',
        'name': 'NUMBER_TO_CHECK',
        'check': 'Number',
      },
      {
        'type': 'field_dropdown',
        'name': 'PROPERTY',
        'options': [
          [editorStrings.isEven, 'EVEN'],
          [editorStrings.isOdd, 'ODD'],
          [editorStrings.isPositive, 'POSITIVE'],
          [editorStrings.isNegative, 'NEGATIVE'],
        ],
      },
    ],
    'inputsInline': true,
    'output': 'Boolean',
    'style': 'math_blocks',
    'tooltip': '%{BKY_MATH_IS_TOOLTIP}',
    'mutator': 'math_is_divisibleby_mutator',
  },
  // Block for remainder of a division.
  {
    'type': 'math_modulo',
    'message0': editorStrings.modulo,
    'args0': [
      {
        'type': 'input_value',
        'name': 'DIVIDEND',
        'check': 'Number',
      },
      {
        'type': 'input_value',
        'name': 'DIVISOR',
        'check': 'Number',
      },
    ],
    'inputsInline': true,
    'output': 'Number',
    'style': 'math_blocks',
    'tooltip': '%{BKY_MATH_MODULO_TOOLTIP}',
    'helpUrl': '%{BKY_MATH_MODULO_HELPURL}',
  },
  {
    'type': 'variables_predefined_get',
    'message0': 'Predefined:%1',
    'args0': [
      {
        'type': 'field_dropdown',
        'name': 'VAR',
        'options': predefinedVariables,
      },
    ],
    'output': 'Number',
    //'style': 'variable_blocks',
    'colour': '#26A69A',
    'helpUrl': '%{BKY_VARIABLES_GET_HELPURL}',
    'tooltip': '%{BKY_VARIABLES_GET_TOOLTIP}',
    'extensions': ['contextMenu_variableSetterGetter'],
    'mutator': 'predefinedvariable_mutator',
  },
  {
    'type': 'variables_predefined_set',
    'message0': editorStrings.setVariablePredefined,
    'args0': [
      {
        'type': 'field_dropdown',
        'name': 'VAR',
        'options': predefinedVariables,
      },
      {
        'type': 'input_value',
        'name': 'VALUE',
        'check': 'Number',
      },
    ],
    'previousStatement': null as any,
    'nextStatement': null as any,
    //'style': 'variable_blocks',
    'colour': '#26A69A',
    'tooltip': '%{BKY_VARIABLES_SET_TOOLTIP}',
    'helpUrl': '%{BKY_VARIABLES_SET_HELPURL}',
    'extensions': ['contextMenu_variableSetterGetter'],
    'mutator': 'predefinedvariable_mutator',
  },
  {
    'type': 'locationkeys_get',
    'message0': editorStrings.setLocation,
    'args0': [
      {
        'type': 'field_autocomplete_locationkeys',
        'name': 'VAR',
        'options': locationIdKeys,
      },
    ],
    'output': 'StringKey',
    'style': 'colour_blocks',
    'helpUrl': '%{BKY_VARIABLES_GET_HELPURL}',
    'tooltip': '%{BKY_VARIABLES_GET_TOOLTIP}',
  },
  {
    'type': 'stringkeys_get',
    'message0': editorStrings.setString,
    'args0': [
      {
        'type': 'field_autocomplete_stringkeys',
        'name': 'VAR',
        'options': stringKeys,
      },
    ],
    'output': 'StringKey',
    'style': 'colour_blocks',
    'helpUrl': '%{BKY_VARIABLES_GET_HELPURL}',
    'tooltip': '%{BKY_VARIABLES_GET_TOOLTIP}',
  },
  {
    'type': 'stringkeysDirectly_get',
    'message0': editorStrings.getStringDirectly,
    'args0': [
      {
        'type': 'field_autocomplete_stringkeys',
        'name': 'VAR',
        'options': stringKeys,
      },
    ],
    'output': 'String',
    'style': 'colour_blocks',
    'helpUrl': '%{BKY_VARIABLES_GET_HELPURL}',
    'tooltip': '%{BKY_VARIABLES_GET_TOOLTIP}',
  },
  {
    'type': 'stringkeyToIds_get',
    'message0': editorStrings.getStringToId,
    'args0': [
      {
        'type': 'field_autocomplete_stringkeys',
        'name': 'VAR',
        'options': stringKeys,
      },
    ],
    'output': 'Number',
    'style': 'colour_blocks',
    'helpUrl': '%{BKY_VARIABLES_GET_HELPURL}',
    'tooltip': '%{BKY_VARIABLES_GET_TOOLTIP}',
  },
  {
    'type': 'teamtag_get',
    'message0': editorStrings.setTeamTag,
    'args0': [
      {
        'type': 'field_dropdown',
        'name': 'VAR',
        'options': teamTagKeys,
      },
    ],
    'output': 'Number',
    'style': 'colour_blocks',
    'helpUrl': '%{BKY_VARIABLES_GET_HELPURL}',
    'tooltip': '%{BKY_VARIABLES_GET_TOOLTIP}',
  },
  {
    'type': 'weapontypes_get',
    'message0': editorStrings.setWeaponType,
    'args0': [
      {
        'type': 'field_dropdown',
        'name': 'VAR',
        'options': weaponTypesArray,
      },
    ],
    'output': 'Number',
    'style': 'colour_blocks',
    'helpUrl': '%{BKY_VARIABLES_GET_HELPURL}',
    'tooltip': '%{BKY_VARIABLES_GET_TOOLTIP}',
  },
  {
    'type': 'maptypes_get',
    'message0': editorStrings.setMapType,
    'args0': [
      {
        'type': 'field_dropdown',
        'name': 'VAR',
        'options': mapTypesArray,
      },
    ],
    'output': 'Number',
    'style': 'colour_blocks',
    'helpUrl': '%{BKY_VARIABLES_GET_HELPURL}',
    'tooltip': '%{BKY_VARIABLES_GET_TOOLTIP}',
  },
  {
    'type': 'tags_get',
    'message0': editorStrings.setTag,
    'args0': [
      {
        'type': 'field_dropdown',
        'name': 'VAR',
        'options': tagsArray,
      },
    ],
    'output': 'Number',
    'style': 'colour_blocks',
    'helpUrl': '%{BKY_VARIABLES_GET_HELPURL}',
    'tooltip': '%{BKY_VARIABLES_GET_TOOLTIP}',
  },
  {
    'type': 'gameboardstates_get',
    'message0': editorStrings.setGameBoardState,
    'args0': [
      {
        'type': 'field_dropdown',
        'name': 'VAR',
        'options': boardStatesArray,
      },
    ],
    'output': 'Number',
    'style': 'colour_blocks',
    'helpUrl': '%{BKY_VARIABLES_GET_HELPURL}',
    'tooltip': '%{BKY_VARIABLES_GET_TOOLTIP}',
  },
  {
    'type': 'fxeventdispatch_get',
    'message0': editorStrings.textBlock_FxEventDispatchAssetPath,
    'args0': [
      {
        'type': 'field_input',
        'name': 'TEXT',
        'check': 'String',
      },
    ],
    'output': 'String',
    'style': 'text_blocks',
    'helpUrl': '%{BKY_VARIABLES_GET_HELPURL}',
    'tooltip': '%{BKY_VARIABLES_GET_TOOLTIP}',
  },
];