import ast
import json
import re

# TODO: period support
# TODO: string.json support

# Known issues:
# boolean support

COUNT_OFFSET: int = 299
RETURN_OFFSET: int = 400

return_count: int = 0


def key_value_pair(variable: str) -> tuple[str, int]:
  key: str = variable.split('_')[0]
  try:
    value = int(variable.split('_')[1])
  except IndexError:
    value = -1
  except ValueError:  # string value
    value = variable.split('_')[1]
  return key, value


def wrap_variable_lvalue(variable: str) -> dict:
  if variable[:7] == '__count':  # reserved variables for loop
    count: int = int(variable.split('_')[3]) + COUNT_OFFSET
    return {
      'predefinedVariable': {
        'type': count
      }
    }
  if variable[:8] == '__return':  # reserved variables for return
    count: int = int(variable.split('_')[3])
    return {
      'predefinedVariable': {
        'type': count
      }
    }
  if variable.startswith('__'):  # reserved variables (pink)
    if variable[2:20] == 'predefinedVariable' and len(variable.split('__')) > 2: # predefined variables with additional parameter
      keys = variable.split('__')[2]
      offset = int(keys.split('_')[0])
      value = int(keys.split('_')[1])
      return {
        'predefinedVariable': {
          'type': offset + value
        }
      }
    variable = variable[2:]
    if variable.endswith('__caller') or variable.startswith('caller__'):
      variable = re.sub(r'^caller__', '', variable)
      key, value = key_value_pair(variable)
      return {
        'caller': True,
        key: {'type': value}
      }
    key, value = key_value_pair(variable)
    return {
      key: {'type': value}
    }
  if variable.startswith('caller'):
    variable = re.sub(r'^caller__', '', variable)
    key, value = key_value_pair(variable)
    return {
      'caller': True,
      key: value
    }
  key, value = key_value_pair(variable)
  return {key: value}


def wrap_variable_rvalue(variable: str) -> dict:
  if variable[:7] == '__count':  # reserved variables for loop
    count: int = int(variable.split('_')[3]) + COUNT_OFFSET
    return {
      'operand': {
        "variable": {
          'predefinedVariable': {
            'type': count
          }
        }
      }
    }
  if variable[:8] == '__return':  # reserved variables for return
    count: int = int(variable.split('_')[3])
    return {
      'operand': {
        "variable": {
          'predefinedVariable': {
            'type': count
          }
        }
      }
    }
  if variable.startswith('__'):  # reserved variables (pink)
    if variable[2:20] == 'predefinedVariable' and len(variable.split('__')) > 2: # predefined variables with additional parameter
      keys = variable.split('__')[2]
      offset = int(keys.split('_')[0])
      value = int(keys.split('_')[1])
      return {
        'operand': {
          "variable": {
            'predefinedVariable': {
              'type': offset + value
            }
          }
        }
      }
    variable = variable[2:]
    key, value = key_value_pair(variable)
    if variable.endswith('__caller') or variable.startswith('caller__'):
      variable = re.sub(r'^caller__', '', variable)
      key, value = key_value_pair(variable)
      return {
        'operand': {
          'variable': {
            'caller': True,
            key: {'type': value}
          }
        }
      }
    return {
      "operand": {
        "variable": {key: {'type': value}}
      }
    }
  if variable.startswith('caller__'):
    variable = re.sub(r'^caller__', '', variable)
    key, value = key_value_pair(variable)
    return {
      "operand": {
        "variable": {
          'caller': True,
          key: value
        }
      }
    }
  key, value = key_value_pair(variable)
  return {
    "operand": {
      "variable": {key: value}
    }
  }


def wrap_constant(constant: float) -> dict or None:
  if constant is None:
    return None
  if type(constant) is float or type(constant) is int or type(constant) is bool:
    constant: float = float(constant)
  else:
    return constant
  # handle the default value
  if constant == 0:
     return {
        "operand": {
          "constant": {}
        }
      }
  return {
    "operand": {
      "constant": {
        "value": constant,
      }
    }
  }


def wrap_binary_operator(operator: ast.operator) -> dict:
  operator_map: dict[ast.operator, str] = {
    ast.Or: 'Or',
    ast.And: 'And',
    ast.Not: 'Not',
    ast.Eq: 'Equal',
    ast.NotEq: 'NotEqual',
    ast.Gt: 'GreaterThan',
    ast.GtE: 'GreaterThanOrEqual',
    ast.Lt: 'LessThan',
    ast.LtE: 'LessThanOrEqual',
    ast.Add: 'Add',
    ast.Sub: 'Subtract',
    ast.Mult: 'Multiply',
    ast.Div: 'Divide',
    ast.Mod: 'Modulo',
    ast.Pow: 'Exponent',
  }
  if type(operator) not in operator_map:
    operator = 'Unknown'
  else:
    operator = operator_map[type(operator)]
  return wrap_operator_raw(operator)


def wrap_operator_raw(operator: str) -> dict:
  return {
    "operator": {
      "type": operator,
    }
  }


def wrap_call(method: str) -> dict:
  method_name: str = method.split('_')[0]
  try:
    method_type = method.split('_')[1]
  except IndexError:
    return {
      "call": {
        "method": {
          method: {}
        },
        "assignments": []
      }
    }
  return {
    "call": {
      "method": {
        method_name: {
          "type": method_type
        }
      },
      "assignments": []
    }
  }


def wrap_expression(expressions: list) -> dict:
  if not expressions:
    expressions = []
  if type(expressions) is not list:
    expressions = [expressions]
  return {
    'infix': expressions
  }


def append_or_extend(original_list, new_item):
  if isinstance(new_item, list):
    original_list.extend(new_item)
  else:
    original_list.append(new_item)


class NewVisitor():
  def __init__(self) -> None:
    super().__init__()

  def visit(self, node) -> object:
    if isinstance(node, ast.Assign):
      infix = self.visit(node.value)
      return {'assignment': {'variable': self.visit(node.targets[0]),
        'expression': wrap_expression(infix)}}
    elif isinstance(node, ast.Constant):
      return wrap_constant(node.value)
    elif isinstance(node, ast.Name):  # variable assignment and function call
      if isinstance(node.parent, ast.Assign):
        if isinstance(node.ctx, ast.Store):
          return wrap_variable_lvalue(node.id)
        elif isinstance(node.ctx, ast.Load):
          return wrap_variable_rvalue(node.id)
      else: # compare, binop, boolop, unaryop
        return wrap_variable_rvalue(node.id)
    elif isinstance(node, ast.UnaryOp):
      return self.visit_UnaryOp(node)
    elif isinstance(node, ast.BinOp):
      return self.visit_BinOp(node)
    elif isinstance(node, ast.BoolOp):
      return self.visit_BoolOp(node)
    elif isinstance(node, ast.Compare):
      return self.visit_Compare(node)
    elif isinstance(node, ast.If):
      return self.visit_If(node)
    elif isinstance(node, ast.While):
      return self.visit_While(node)
    elif isinstance(node, ast.Call):
      if node.func.id == 'exit':
        return {'return': {}}
      elif node.func.id == 'runTrigger':
        call_wrapped = wrap_call(node.func.id)
        if node.args[0].value != 0:
          call_wrapped['call']['caller'] = True
        call_wrapped['call']['method']['runTrigger']['name'] = node.args[1].value
        del call_wrapped['call']['assignments']
        return call_wrapped
      elif node.func.id == 'debug':
        call_wrapped = wrap_call('debugMethod')
        # handle the default value
        if node.args[0].value != 'Log':
          call_wrapped['call']['method']['debugMethod']['type'] = node.args[0].value
        call_wrapped['call']['method']['debugMethod']['message'] = node.args[1].value
        call_wrapped['call']['method']['debugMethod']['expression'] = wrap_expression(self.visit(node.args[2]))
        del call_wrapped['call']['assignments']
        return call_wrapped
      elif node.func.id == 'ingameMethod':
        call_wrapped = wrap_call('boardMethod')
        if node.args[0].value != '':
          call_wrapped['call']['method']['boardMethod']['type'] = node.args[0].value
        call_wrapped['call']['argumentString'] = node.args[1].value
        call_wrapped['call']['argumentExpressions'] = []
        for argument in node.args[2:]:
          if hasattr(argument, 'value') and argument.value == None:
            call_wrapped['call']['argumentExpressions'].append(wrap_expression(wrap_constant(0)))
          else:
            call_wrapped['call']['argumentExpressions'].append(wrap_expression(self.visit(argument)))
        del call_wrapped['call']['assignments']
        return call_wrapped
      else:
        call_wrapped = wrap_call(node.func.id)
        if node.args[0].value != 0:
          call_wrapped['call']['caller'] = True
        if len(node.args) > 1:
          print(node.args[1].value)
          call_wrapped['call']['argumentString'] = node.args[1].value
        if len(node.args) > 2:
          call_wrapped['call']['argumentExpressions'] = []
          for argument in node.args[2:]:
            if hasattr(argument, 'value') and argument.value == None:
              call_wrapped['call']['argumentExpressions'].append(wrap_expression(wrap_constant(0)))
          else:
            call_wrapped['call']['argumentExpressions'].append(wrap_expression(self.visit(argument)))
        for keyword_arg in node.keywords:
          expression = self.visit(keyword_arg.value)
          if expression is None:
            continue
          call_wrapped['call']['assignments'].append({'variable': {'parameter': {'type': keyword_arg.arg}}, 'expression':  wrap_expression(expression)})
        return call_wrapped
    elif isinstance(node, ast.Break):
      return {'break': {}}
    elif isinstance(node, ast.Continue):
      return {'continue': {}}
    elif isinstance(node, ast.Return):
      return {'return': {}}
    elif isinstance(node, ast.Module):
      result = []
      for statement in node.body:
        result.append(self.visit(statement))
      return result
    elif isinstance(node, ast.Pass):
      return None
    elif isinstance(node, ast.Expr):
      if not isinstance(node.value, ast.Call) and isinstance(node.parent, ast.Module):
        return None
      return self.visit(node.value)
    else:
      for child in ast.iter_child_nodes(node):
        return self.visit(child)

  def visit_BinOp(self, node) -> list:
    result = []
    result.append(wrap_operator_raw('OpenParenthesis'))
    append_or_extend(result, self.visit(node.left))
    result.append(wrap_binary_operator(node.op))
    append_or_extend(result, self.visit(node.right))
    result.append(wrap_operator_raw('CloseParenthesis'))
    return result

  def visit_BoolOp(self, node) -> list:
    result = []
    result.append(wrap_operator_raw('OpenParenthesis'))
    operator: dict = {}
    if isinstance(node.op, ast.And):
      operator = wrap_operator_raw('And')
    elif isinstance(node.op, ast.Or):
      operator = wrap_operator_raw('Or')

    for index, value in enumerate(node.values):
      if index > 0:
        result.append(operator)
      append_or_extend(result, self.visit(value))

    result.append(wrap_operator_raw('CloseParenthesis'))
    return result

  def visit_Compare(self, node) -> list:
    result = []
    result.append(wrap_operator_raw('OpenParenthesis'))
    append_or_extend(result, self.visit(node.left))
    for index, comparator in enumerate(node.comparators):
      result.append(wrap_binary_operator(node.ops[index]))
      append_or_extend(result, self.visit(comparator))
    result.append(wrap_operator_raw('CloseParenthesis'))
    return result

  def visit_UnaryOp(self, node) -> list:
    result = []
    result.append(wrap_operator_raw('OpenParenthesis'))
    if isinstance(node.op, ast.Not):
      result.append(wrap_operator_raw('Not'))
      result.append(wrap_operator_raw('OpenParenthesis'))
      result.append(self.visit(node.operand))
      result.append(wrap_operator_raw('CloseParenthesis'))
    elif isinstance(node.op, ast.USub):
      result.append(wrap_operator_raw('UnaryMinus'))
      result.append(wrap_operator_raw('OpenParenthesis'))
      result.append(self.visit(node.operand))
      result.append(wrap_operator_raw('CloseParenthesis'))
    elif isinstance(node.operand, ast.Constant):
      result.append(wrap_constant(node.operand.value))
    elif isinstance(node.operand, ast.Name):
      append_or_extend(result, self.visit(node.operand))
    result.append(wrap_operator_raw('CloseParenthesis'))
    return result

  def visit_If(self, node) -> dict[str, dict[str, dict]]:
    statements = []
    else_statements = []
    for statement in node.body:
      visit_result = self.visit(statement)
      if visit_result is not None:
        statements.append(visit_result)
    for statement in node.orelse:
      visit_result = self.visit(statement)
      if visit_result is not None:
        else_statements.append(visit_result)
    infix = self.visit(node.test)
    result = {
      'condition': {
        'expression': wrap_expression(infix),
      }
    }
    if len(statements) > 0:
      result['condition']['statements'] = statements
    if len(else_statements) > 0:
      result['condition']['elseStatements'] = else_statements
    return result

  def visit_While(self, node) -> list:
    statements = []
    for statement in node.body:
      visit_result = self.visit(statement)
      if visit_result is not None:
        statements.append(visit_result)
    infix = self.visit(node.test)
    result = {
      'loop': {
        'expression': wrap_expression(infix)
      }
    }
    if len(statements) > 0:
      result['loop']['statements'] = statements
    return result


def in2post(statement: dict) -> int:
  precedence: list[list[str]] = [
    ['Exponent'],
    ['UnaryMinus'],
    ['Multiply', 'Divide', 'Modulo'],
    ['Add', 'Subtract'],
    ['Equal', 'NotEqual', 'GreaterThan', 'GreaterThanOrEqual', 'LessThan', 'LessThanOrEqual'],
    ['Not'],
    ['And'],
    ['Or']
  ]

  infix = statement['infix']
  postfix: list = []
  stack: list = []
  call_replacement: int = 0

  if not infix:
    return 0
  for token in infix:
    if 'operand' in token:
      postfix.append(token)
    elif 'operator' in token:
      operator = token['operator']['type']
      if operator == 'OpenParenthesis':
        stack.append(token)
      elif operator == 'CloseParenthesis':
        while stack and stack[-1]['operator']['type'] != 'OpenParenthesis':
          postfix.append(stack.pop())
        if not stack:
          raise ValueError('Mismatched parentheses')
        stack.pop()
      else:
        for level, operators in enumerate(precedence):
          if operator in operators:
            higher_or_equal_operators = [op for opgroup in precedence[:level + 1] for op in opgroup]
            while stack and stack[-1]['operator']['type'] in higher_or_equal_operators:
              postfix.append(stack.pop())
            stack.append(token)
  while stack:
    postfix.append(stack.pop())
  statement['postfix'] = postfix
  return call_replacement


def evaluate_expressions(statement: object) -> int:
  call_replacement: int = 0
  # evaluate recursively
  if isinstance(statement, list):
    for item in statement:
      call_replacement += evaluate_expressions(item)
  if isinstance(statement, dict):
    if 'infix' in statement:
      call_replacement += in2post(statement)
      del statement['infix']
    for value in statement.values():
      if isinstance(value, list):
        for item in value:
          call_replacement += evaluate_expressions(item)
      if isinstance(value, dict):
        if 'infix' in value:
          call_replacement += in2post(value)
          del value['infix']
        else:
          call_replacement += evaluate_expressions(value)
  return call_replacement


class Parentage(ast.NodeTransformer):
  parent = None

  def visit(self, node) -> ast.AST:
    node.parent = self.parent
    self.parent = node
    node = super().visit(node)
    if isinstance(node, ast.AST):
      self.parent = node.parent
    return node

class FunctionTransformer(ast.NodeTransformer):
  def __init__(self) -> None:
    self.return_index = RETURN_OFFSET
    self.replace_count = 0

  def visit_Call(self, node: ast.AST) -> ast.AST:
    super().generic_visit(node)
    if node.func.id.endswith("_return"):
      function_id = node.func.id[:-7]
      function_call = ast.Call(
        func=ast.Name(id=function_id, ctx=ast.Load()),
        args=node.args,
        keywords=node.keywords
      )

      variable = ast.Name(id=f'__return_{self.return_index}', ctx=ast.Store())
      value = ast.Name(id='__predefinedVariable_Return', ctx=ast.Load())
      variable_assignment = ast.Assign(
        targets=[variable],
        value=value
      )

      variable_in_place = ast.Name(id=f'__return_{self.return_index}', ctx=ast.Load())

      variable_assignment.targets[0].parent = variable_assignment
      variable_assignment.value.parent = variable_assignment

      prev_target = node
      insertion_target = node

      while True:
        prev_target = insertion_target
        insertion_target = insertion_target.parent
        if hasattr(insertion_target, 'body'):
          if prev_target not in insertion_target.body:
            continue
          break
      insertion_position = insertion_target.body.index(prev_target)
      function_call.parent = insertion_target
      function_call.visited = True
      variable_assignment.parent = insertion_target
      temp = insertion_target.body

      insertion_target.body = []
      for i in range(insertion_position):
        insertion_target.body.append(temp[i])
      insertion_target.body.append(function_call)
      insertion_target.body.append(variable_assignment)
      for i in range(insertion_position, len(temp)):
        insertion_target.body.append(temp[i])

      self.return_index += 1
      self.replace_count += 1

      return variable_in_place
    return node

  def visit(self, node):
    if hasattr(node, 'visited'):
      return node
    node = super().visit(node)
    return node

# known issues: floating point errors
def to_json(code: str) -> str:
  ast_tree = ast.parse(code)

  # add parent to each node
  parentage = Parentage()
  ast_tree = parentage.visit(ast_tree)

  # print('=' * 80)
  # print('Parentage')
  # print(ast.dump(ast_tree, indent=2))

  # transform the AST
  function_transformer = FunctionTransformer()
  while True:
    function_transformer.replace_count = 0
    ast_tree = FunctionTransformer().visit(ast_tree)
    if function_transformer.replace_count == 0:
      break

  # print('=' * 80)
  # print('Transformed')
  # print(ast.dump(ast_tree, indent=2))

  parentage = Parentage()
  ast_tree = parentage.visit(ast_tree)

  visitor = NewVisitor()
  result = visitor.visit(ast_tree)
  # print(json.dumps(result, indent=2))

  for statement in result:
    evaluate_expressions(statement)

  final_result = []
  for statement in result:
    if statement != None:
      final_result.append(statement)
  # print(json.dumps(final_result, indent=2))

  return json.dumps(final_result, indent=2, ensure_ascii=False)
