import * as Blockly from 'blockly';
import {Block, VariableModel} from 'blockly';
import {Order, pythonGenerator} from 'blockly/python';
import {PythonGenerator} from "blockly/python";
import {Workspace} from "blockly";
import {argumentData} from "../blocks";

const Names = Blockly.Names;
const Variables = Blockly.Variables;
const stringUtils = Blockly.utils.string;
const inputTypes = Blockly.inputs.inputTypes;
const globalData = window.electronAPI.loadData('loadData');

import * as config from '../config';

type ControlFlowInLoopBlock = typeof Blockly.Blocks['controls_flow_statements'];

const variableAPI = 'http://localhost:8090/variables';
const stringsJson = globalData.strings;
import {teamTagKeys} from "../config";

class TriggerIRGenerator extends PythonGenerator {
  private varTable: Map<String, String> = new Map<String, String>();

  init(workspace: Workspace) {
    super.init(workspace);

    this.PASS = this.INDENT + 'pass\n';

    if (!this.nameDB_) {
      this.nameDB_ = new Names(this.RESERVED_WORDS_);
    } else {
      this.nameDB_.reset();
    }

    this.nameDB_.setVariableMap(workspace.getVariableMap());
    this.nameDB_.populateVariables(workspace);
    this.nameDB_.populateProcedures(workspace);

    const defvars = [];
    // Add developer variables (not created or named by the user).
    const devVarList = Variables.allDeveloperVariables(workspace);
    for (let i = 0; i < devVarList.length; i++) {
      defvars.push(
        this.nameDB_.getName(devVarList[i], Names.DEVELOPER_VARIABLE_TYPE) +
        " = 0"
      )
    }

    // Add user variables, but only ones that are being used.

    this.definitions_["variables"] = defvars.join("\n")
    this.isInitialized = true
  }

  allUsedVarModels_(ws: Workspace): VariableModel[] {
    const blocks = ws.getAllBlocks(false);
    const variables = new Set<VariableModel>();
    const strings = globalData.strings.strings;
    // Iterate through every block and add each variable to the set.
    for (let i = 0; i < blocks.length; i++) {
      const blockVariables = blocks[i].getVarModels();
      if (blockVariables) {
        for (let j = 0; j < blockVariables.length; j++) {
          const variable = blockVariables[j];
          const id = variable.getId();

          const varName = blocks[i].getVarModels()[0].name;
          const varType = blocks[i].getFieldValue('TYPE');


          let varNumber = strings.find((element: any) => element.english.replace(/\//g, '_') == varName.replace(/\//g, '_'));

          // user vars
          if (varNumber == undefined) {
            varNumber = 0;
          }
          else varNumber = varNumber.id;

          let fullVarName = varType + 'Key_' + varNumber;
          this.varTable.set(variable.getId(), fullVarName);

          if (id) {
            variables.add(variable);
          }
        }
      }
    }
    // Convert the set into a list.
    return Array.from(variables.values());
  }

  workspaceToCode(workspace: Workspace) {
    const code: string = super.workspaceToCode(workspace);
    return code;
  }

  scrub_(block: Block, code: string, thisOnly = false): string {
    let commentCode = '';
    // Only collect comments for blocks that aren't inline.
    if (!block.outputConnection || !block.outputConnection.targetConnection) {
      // Collect comment for this block.
      let comment = block.getCommentText();
      if (comment) {
        comment = stringUtils.wrap(comment, this.COMMENT_WRAP - 3);
        commentCode += this.prefixLines(comment + '\n', '# ');
      }
      // Collect comments for all value arguments.
      // Don't collect comments for nested statements.
      for (let i = 0; i < block.inputList.length; i++) {
        if (block.inputList[i].type === inputTypes.VALUE) {
          const childBlock = block.inputList[i].connection!.targetBlock();
          if (childBlock) {
            comment = this.allNestedComments(childBlock);
            if (comment) {
              commentCode += this.prefixLines(comment, '# ');
            }
          }
        }
      }
    }
    const nextBlock =
      block.nextConnection && block.nextConnection.targetBlock();
    const nextCode = thisOnly ? '' : this.blockToCode(nextBlock);
    return commentCode + code + nextCode;
  }
}

export const triggerIRGenerator: TriggerIRGenerator = new TriggerIRGenerator();
export {TriggerIRGenerator};

triggerIRGenerator['forBlock']['controls_if'] = pythonGenerator['forBlock']['controls_if'];
triggerIRGenerator['forBlock']['logic_compare'] = pythonGenerator['forBlock']['logic_compare'];
triggerIRGenerator['forBlock']['logic_operation'] = pythonGenerator['forBlock']['logic_operation'];
triggerIRGenerator['forBlock']['logic_negate'] = pythonGenerator['forBlock']['logic_negate'];
triggerIRGenerator['forBlock']['logic_boolean'] = pythonGenerator['forBlock']['logic_boolean'];
//triggerIRGenerator['forBlock']['controls_repeat_ext'] = pythonGenerator['forBlock']['controls_repeat_ext'];
//triggerIRGenerator['forBlock']['controls_whileUntil'] = pythonGenerator['forBlock']['controls_whileUntil'];
triggerIRGenerator['forBlock']['math_number'] = pythonGenerator['forBlock']['math_number'];
triggerIRGenerator['forBlock']['math_arithmetic'] = pythonGenerator['forBlock']['math_arithmetic'];
triggerIRGenerator['forBlock']['math_number_property'] = pythonGenerator['forBlock']['math_number_property'];
triggerIRGenerator['forBlock']['math_modulo'] = pythonGenerator['forBlock']['math_modulo'];


triggerIRGenerator['forBlock']['variables_set'] = (block: Block, generator: TriggerIRGenerator) => {
  // Variable setter.
  const argument0 = generator.valueToCode(block, 'VALUE', Order.NONE) || '0';
  const varName = generator.getVariableName(block.getFieldValue('VAR'));
  const varType = block.getFieldValue('TYPE');

  let strings = stringsJson.strings;

  let varNumber = 0;

  for (const element of strings) {
    if ('english' in element && element.english.replace(/\//g, '_').replace(/@/g, '_') == varName) {
      varNumber = element.id;
    }
  }

  return varType + 'Key_' + varNumber + ' = ' + argument0 + '\n';
}

triggerIRGenerator['forBlock']['variables_get'] = (
  block: Block,
  generator: TriggerIRGenerator,
): [string, Order] => {
  // Variable getter.
  const varName = generator.getVariableName(block.getFieldValue('VAR'));
  const varType = block.getFieldValue('TYPE');
  let strings = stringsJson.strings;

  let varNumber = 0;

  for (const element of strings) {
    if ('english' in element && element.english.replace(/\//g, '_').replace(/@/g, '_') == varName) {
      varNumber = element.id;
    }
  }

  return [varType as String + 'Key_' + varNumber, Order.ATOMIC];
}

triggerIRGenerator['forBlock']['variables_user_set'] = (block: Block, generator: PythonGenerator) => {
  // Variable setter.
  const argument0 = generator.valueToCode(block, 'VALUE', Order.NONE) || '0';
  const varName = generator.getVariableName(block.getFieldValue('VAR'));
  return '__parameter_' + varName + ' = ' + argument0 + '\n';
}

triggerIRGenerator['forBlock']['variables_user_get'] = (
  block: Block,
  generator: PythonGenerator,
): [string, Order] => {
  // Variable getter.
  const code = generator.getVariableName(block.getFieldValue('VAR'));

  return ['__parameter_' + code, Order.ATOMIC];
}

triggerIRGenerator['forBlock']['variables_predefined_set'] = (block: Block, generator: PythonGenerator) => {
  // Variable setter.
  const argument0 = generator.valueToCode(block, 'VALUE', Order.NONE) || '0';
  const varName = generator.getVariableName(block.getFieldValue('VAR'));
  let offsets = '';
  if ((block as any).metadata_) {
    for (const i in (block as any).metadata_) {
      offsets += '__' + ((block as any).metadata_[i].offset + '_' + (generator.valueToCode(block, 'ARG' + i, Order.NONE) || 0));
    }
  }
  return '__predefinedVariable_' + varName + offsets + ' = ' + argument0 + '\n';
}

triggerIRGenerator['forBlock']['variables_predefined_get'] = (
  block: Block,
  generator: PythonGenerator,
): [string, Order] => {
  // Variable getter.
  const code = generator.getVariableName(block.getFieldValue('VAR'));
  let offsets = '';
  if ((block as any).metadata_) {
    for (const i in (block as any).metadata_) {
      offsets += '__' + ((block as any).metadata_[i].offset + '_' + (generator.valueToCode(block, 'ARG' + i, Order.NONE) || 0));
    }
  }
  return ['__predefinedVariable_' + code + offsets, Order.ATOMIC];
}

triggerIRGenerator['forBlock']['locationkeys_get'] = (
  block: Block,
  generator: PythonGenerator,
): [string, Order] => {
  // Variable getter.
  const code = generator.getVariableName(block.getFieldValue('VAR'));
  const originalCode = block.getFieldValue('VAR');
  let value = 0;
  const stringKeys = globalData.strings;
  for (const key of stringKeys.strings) {
    if (('english' in key && key.english.replace('/', '_') === code) || ('key' in key && key.key === originalCode)) {
      if ('id' in key)
        value = key.id;
      else
        value = 0;
    }
  }

  return ['' + value, Order.ATOMIC];
}

triggerIRGenerator['forBlock']['stringkeys_get'] = (
  block: Block,
  generator: PythonGenerator,
): [string, Order] => {
  // Variable getter.
  const code = generator.getVariableName(block.getFieldValue('VAR'));
  const originalCode = block.getFieldValue('VAR');
  let value = 0;
  const stringKeys = globalData.strings;
  for (const key of stringKeys.strings) {
    if ((!('category' in key) || key.category === 'Editor') && ('english' in key && key.english.replace('/', '_') === code) || ('key' in key && key.key === originalCode)) {
      if ('id' in key)
        value = key.id;
      else
        value = 0;
    }
  }

  return ['' + value, Order.ATOMIC];
}

triggerIRGenerator['forBlock']['stringkeysDirectly_get'] = (
  block: Block,
  generator: PythonGenerator,
): [string, Order] => {
  //const code = generator.getVariableName(block.getFieldValue('VAR'));
  const originalCode: string = block.getFieldValue('VAR') || "";
  //const value = generator.valueToCode(block, 'VAR', Order.NONE) || "''";
  return ["'" + originalCode + "'", Order.ATOMIC];
}

triggerIRGenerator['forBlock']['stringkeyToIds_get'] = (
  block: Block,
  generator: PythonGenerator,
): [string, Order] => {
  // Variable getter.
  const code = generator.getVariableName(block.getFieldValue('VAR'));
  const originalCode = block.getFieldValue('VAR');
  let value = 0;
  const stringKeys = globalData.strings;
  for (const key of stringKeys.strings) {
    if ((!('category' in key) || key.category === 'Editor') && ('english' in key && key.english.replace('/', '_') === code) || ('key' in key && key.key === originalCode)) {
      if ('id' in key)
        value = key.id;
      else
        value = 0;
    }
  }

  return ['' + value, Order.ATOMIC];
}

triggerIRGenerator['forBlock']['teamtag_get'] = (
  block: Block,
  generator: PythonGenerator,
): [string, Order] => {
  // Variable getter.
  const code = block.getFieldValue('VAR');
  let value = 0;
  value = teamTagKeys.get(code) || 0;

  return ['' + value, Order.ATOMIC];
}

triggerIRGenerator['forBlock']['weapontypes_get'] = (
  block: Block,
  generator: PythonGenerator,
): [string, Order] => {
  // Variable getter.
  const code = block.getFieldValue('VAR');

  return ['' + code, Order.ATOMIC];
}

triggerIRGenerator['forBlock']['maptypes_get'] = (
  block: Block,
  generator: PythonGenerator,
): [string, Order] => {
  // Variable getter.
  const code = block.getFieldValue('VAR');

  return ['' + code, Order.ATOMIC];
}

triggerIRGenerator['forBlock']['tags_get'] = (
  block: Block,
  generator: PythonGenerator,
): [string, Order] => {
  // Variable getter.
  const code = block.getFieldValue('VAR');

  return ['' + code, Order.ATOMIC];
}

triggerIRGenerator['forBlock']['gameboardstates_get'] = (
  block: Block,
  generator: PythonGenerator,
): [string, Order] => {
  // Variable getter.
  const code = block.getFieldValue('VAR');

  return ['' + code, Order.ATOMIC];
}


triggerIRGenerator['forBlock']['math_change'] = (block: Block, generator: TriggerIRGenerator) => {
  // Add to a variable in place.
  const argument0: string = generator.valueToCode(block, "DELTA", Order.ADDITIVE) || "0"
  let varName: string = generator.getVariableName(block.getFieldValue("VAR"))
  const varType = block.getFieldValue('TYPE');

  let strings = stringsJson.strings;
  let varNumber = 0;

    for (const element of strings) {
    if ('english' in element && element.english.replace(/\//g, '_').replace(/@/g, '_') == varName) {
      varNumber = element.id;
    }
  }

  let varNameReal = varType as String + 'Key_' + varNumber

  return (
    varNameReal +
    " = " +
    varNameReal + " + " +
    argument0 +
    "\n"
  )
}

triggerIRGenerator['forBlock']['return'] = (block: Block, generator: TriggerIRGenerator) => {
  return 'exit(0)\n';
}

triggerIRGenerator['forBlock']['controls_flow_statements'] = (
  block: Block,
  generator: PythonGenerator) => {
  // Flow statements: continue, break.
  let xfix = '';
  if (generator.STATEMENT_PREFIX) {
    // Automatic prefix insertion is switched off for this block.  Add manually.
    xfix += generator.injectId(generator.STATEMENT_PREFIX, block);
  }
  if (generator.STATEMENT_SUFFIX) {
    // Inject any statement suffix here since the regular one at the end
    // will not get executed if the break/continue is triggered.
    xfix += generator.injectId(generator.STATEMENT_SUFFIX, block);
  }
  if (generator.STATEMENT_PREFIX) {
    const loop = (block as ControlFlowInLoopBlock).getSurroundLoop();
    if (loop && !loop.suppressPrefixSuffix) {
      // Inject loop's statement prefix here since the regular one at the end
      // of the loop will not get executed if 'continue' is triggered.
      // In the case of 'break', a prefix is needed due to the loop's suffix.
      xfix += generator.injectId(generator.STATEMENT_PREFIX, loop);
    }
  }
  switch (block.getFieldValue('FLOW')) {
    case 'BREAK':
      return xfix + 'break\n';
    case 'CONTINUE':
      return xfix + 'continue\n';
  }
  throw Error('Unknown flow statement.');
}

triggerIRGenerator['forBlock']['variables_set_reserved'] = (block: Block, generator: TriggerIRGenerator) => {
  const argument0: string = generator.valueToCode(block, 'VALUE', Order.NONE) || '0';
  let varName: string = generator.getVariableName(block.getFieldValue('VAR'));
  const isThis: string = block.getFieldValue('THIS');
  if (varName == Blockly.Msg['UNNAMED_KEY']) {
    varName = 'unnamed';
  }
  if (isThis == 'TRUE') varName += '__caller'
  varName = '__' + varName;
  return varName + ' = ' + argument0 + '\n';
}

triggerIRGenerator['forBlock']['variables_get_reserved'] = (
  block: Block,
  generator: PythonGenerator,
): [string, Order] => {
  // Variable getter.
  let varName = generator.getVariableName(block.getFieldValue('VAR'));
  const varType = block.getFieldValue('TYPE');
  const isThis: string = block.getFieldValue('THIS');
  if (varName == Blockly.Msg['UNNAMED_KEY']) {
    varName = 'unnamed';
  }
  if (isThis == 'TRUE') varName += '__caller'
  varName = '__' + varName;
  return [varName, Order.ATOMIC];
}

triggerIRGenerator['forBlock']['function_call'] = (block: Block, generator: TriggerIRGenerator) => {
  let varName: string = generator.getVariableName(block.getFieldValue('NAME'));
  if (varName === '이름이 없는') varName = 'unnamed';
  const isThis: string = block.getFieldValue('THIS');
  let functionCall = varName + '(';
  if (isThis == 'TRUE') functionCall += '1, ';
  else functionCall += '0, ';
  let argnum = 0;
  let argNames = argumentData[block.getFieldValue('NAME')];
  while (block.getInput('ARG' + argnum)) {
    if (argNames)
      functionCall += Object.keys(argNames).find(key => argNames[key].index == argnum) + '=' + (generator.valueToCode(block, 'ARG' + argnum, Order.NONE) || 'None') + ', ';
    else
      functionCall += (generator.valueToCode(block, 'ARG' + argnum, Order.NONE) || 'None') + ', ';
    argnum++;
  }
  return functionCall.slice(0, -2) + ')\n';
}

triggerIRGenerator['forBlock']['function_call_with_arguments'] = (block: Block, generator: TriggerIRGenerator) => {
  let varName: string = generator.getVariableName(block.getFieldValue('NAME'));
  if (varName === '이름이 없는') varName = 'unnamed';
  const isThis: string = block.getFieldValue('THIS');
  const text: string = generator.valueToCode(block, 'TEXT', Order.NONE) || "''";
  let functionCall = varName + '(';
  functionCall += isThis == 'TRUE' ? '1, ' : '0, ';
  functionCall += text + ', ';

  for (let i = 1; i <= 1; i++) {
    const varName = generator.valueToCode(block, 'VAR' + i, Order.NONE) || 'None';
    functionCall += varName + ', ';
  }

  let argnum = 0;
  let argNames = argumentData[block.getFieldValue('NAME')];
  while (block.getInput('ARG' + argnum)) {
    if (argNames)
      functionCall += Object.keys(argNames).find(key => argNames[key].index == argnum) + '=' + (generator.valueToCode(block, 'ARG' + argnum, Order.NONE) || 'None') + ', ';
    else
      functionCall += (generator.valueToCode(block, 'ARG' + argnum, Order.NONE) || 'None') + ', ';
    argnum++;
  }
  return functionCall.slice(0, -2) + ')\n';
}

triggerIRGenerator['forBlock']['function_call_return'] = (block: Block, generator: TriggerIRGenerator) => {
  let varName: string = generator.getVariableName(block.getFieldValue('NAME'));
  if (varName === '이름이 없는') varName = 'unnamed';
  const isThis: string = block.getFieldValue('THIS');
  let functionCall = varName + '_return' + '(';
  if (isThis == 'TRUE') functionCall += '1, ';
  else functionCall += '0, ';
  let argnum = 0;
  let argNames = argumentData[block.getFieldValue('NAME')];
  while (block.getInput('ARG' + argnum)) {
    if (argNames)
      functionCall += Object.keys(argNames).find(key => argNames[key].index == argnum) + '=' + (generator.valueToCode(block, 'ARG' + argnum, Order.NONE) || 'None') + ', ';
    else
      functionCall += (generator.valueToCode(block, 'ARG' + argnum, Order.NONE) || 'None') + ', ';
    argnum++;
  }
  return [functionCall.slice(0, -2) + ')', Order.ATOMIC];
}

triggerIRGenerator['forBlock']['trigger_call'] = (block: Block, generator: TriggerIRGenerator) => {
  const varName: string = block.getFieldValue('NAME');
  const isThis: string = block.getFieldValue('THIS');
  let functionCall = 'runTrigger(';
  if (isThis == 'TRUE') functionCall += '1, ';
  else functionCall += '0, ';
  functionCall += '"' + varName + '", ';
  let argnum = 0;
  let argNames = argumentData[block.getFieldValue('NAME')];
  while (block.getInput('ARG' + argnum)) {
    if (argNames)
      functionCall += Object.keys(argNames).find(key => argNames[key].index == argnum) + '=' + (generator.valueToCode(block, 'ARG' + argnum, Order.NONE) || 'None') + ', ';
    else
      functionCall += (generator.valueToCode(block, 'ARG' + argnum, Order.NONE) || 'None') + ', ';
    argnum++;
  }
  return functionCall.slice(0, -2) + ')\n';
}

triggerIRGenerator['forBlock']['debug'] = (block: Block, generator: TriggerIRGenerator) => {
  let typeName: string = block.getFieldValue('NAME');
  const text: string = generator.valueToCode(block, 'TEXT', Order.NONE) || "''";
  const varName = generator.valueToCode(block, 'VAR', Order.NONE) || 'None';
  if (typeName === '') typeName = 'Log';
  let functionCall = 'debug(';
  functionCall += '"' + typeName + '", ';
  functionCall += text + ', ';
  functionCall += varName + ', ';
  return functionCall.slice(0, -2) + ')\n';
}

triggerIRGenerator['forBlock']['ingame_methods'] = (block: Block, generator: TriggerIRGenerator) => {
  let typeName: string = block.getFieldValue('NAME');
  const text: string = generator.valueToCode(block, 'TEXT', Order.NONE) || "''";
  if (typeName === '') typeName = '';
  let functionCall = 'ingameMethod(';
  functionCall += '"' + typeName + '", ';
  functionCall += text + ', ';
  for (let i = 1; i <= 5; i++) {
    const varName = generator.valueToCode(block, 'VAR' + i, Order.NONE) || 'None';
    functionCall += varName + ', ';
  }
  return functionCall.slice(0, -2) + ')\n';
}

triggerIRGenerator['forBlock']['controls_repeat_ext'] = (block: Block, generator: TriggerIRGenerator) => {
  // Repeat n times.
  let repeats
  if (block.getField("TIMES")) {
    // Internal number.
    repeats = String(parseInt(block.getFieldValue("TIMES"), 10))
  } else {
    // External number.
    repeats = generator.valueToCode(block, "TIMES", Order.NONE) || "0"
  }
  if (Blockly.utils.string.isNumber(repeats)) {
    repeats = parseInt(repeats, 10)
  } else {
    //repeats = "int(" + repeats + ")" // cannot use internal functions
  }
  let branch: string = generator.statementToCode(block, "DO")
  branch = generator.addLoopTrap(branch, block) || generator.PASS
  let loopVar: string = generator.nameDB_.getDistinctName("__count_", Blockly.Names.NameType.VARIABLE)
  if (loopVar === '__count_') loopVar = '__count_1';
  let code: string = loopVar + " = 0\n"
  code += "while " + loopVar + " < " + repeats + "" + ":\n" + branch + "  " + loopVar + " = " + loopVar + " + 1\n"
  return code
}

triggerIRGenerator['forBlock']['controls_whileUntil'] = (block: Block, generator: TriggerIRGenerator) => {
  // Do while/until loop.
  const until: boolean = block.getFieldValue("MODE") === "UNTIL"
  let argument0: string =
    generator.valueToCode(
      block,
      "BOOL",
      until ? Order.LOGICAL_NOT : Order.NONE
    ) || "False"
  let branch: string = generator.statementToCode(block, "DO")
  branch = generator.addLoopTrap(branch, block) || generator.PASS
  if (until) {
    argument0 = "not " + argument0
  }
  let code: string = "";
  code += "while " + argument0 + "" + ":\n" + branch
  return code
}

triggerIRGenerator['forBlock']['text'] = (block: Block, generator: TriggerIRGenerator): [string, Order] => {
  // Text value.
  const code = generator.quote_(block.getFieldValue('TEXT'));
  return [code, Order.ATOMIC];
}

triggerIRGenerator['forBlock']['fxeventdispatch_get'] = (block: Block, generator: TriggerIRGenerator): [string, Order] => {
  const code = block.getFieldValue('TEXT');
  const result = `"Skills/FxSettings/FxEventDispatch/${code}.asset"`;
  return [result, Order.ATOMIC];
}

