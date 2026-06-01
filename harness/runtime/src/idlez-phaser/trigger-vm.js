const OPS = {
  Or: (a, b) => !!a || !!b,
  And: (a, b) => !!a && !!b,
  Equal: (a, b) => Number(a) === Number(b),
  NotEqual: (a, b) => Number(a) !== Number(b),
  GreaterThan: (a, b) => Number(a) > Number(b),
  GreaterThanOrEqual: (a, b) => Number(a) >= Number(b),
  LessThan: (a, b) => Number(a) < Number(b),
  LessThanOrEqual: (a, b) => Number(a) <= Number(b),
  Add: (a, b) => Number(a) + Number(b),
  Subtract: (a, b) => Number(a) - Number(b),
  Multiply: (a, b) => Number(a) * Number(b),
  Divide: (a, b) => Number(a) / Number(b),
  Modulo: (a, b) => Number(a) % Number(b),
};

export class TriggerVM {
  constructor(board, store) {
    this.board = board;
    this.store = store;
    this.updateBindings = [];
  }

  reset() {
    this.updateBindings.length = 0;
  }

  bootstrapMap(map) {
    this.bindTriggerNames(map.triggers || [], () => ({ board: this.board }));
  }

  bootstrapUnit(unit) {
    this.bindTriggerNames(unit.def.triggers || [], () => ({ board: this.board, unit }));
  }

  bindTriggerNames(triggerNames, contextFactory) {
    for (const name of triggerNames) {
      const trigger = this.store.getTrigger(name);
      if (!trigger) {
        this.board.warn(`Unknown trigger: ${name}`);
        continue;
      }

      const type = trigger.type || 'OnStart';
      if (type === 'OnUpdate') {
        this.updateBindings.push({ name, trigger, contextFactory });
      } else if (type === 'OnStart') {
        this.fire(name, contextFactory());
      }
    }
  }

  tick() {
    for (const binding of this.updateBindings) {
      const period = Math.max(1, Number(binding.trigger.period || 1));
      if (this.board.tick % period !== 0) continue;

      const context = binding.contextFactory();
      if (context.unit && !context.unit.alive) continue;
      this.fire(binding.name, context);
    }
  }

  fire(triggerName, context = {}) {
    const trigger = this.store.getTrigger(triggerName);
    if (!trigger) {
      this.board.warn(`Unknown trigger: ${triggerName}`);
      return 0;
    }

    const ctx = {
      board: this.board,
      unit: context.unit,
      skill: context.skill,
      buff: context.buff,
      vars: { ...(trigger.vars || {}), ...(context.vars || {}) },
      predef: context.predef || {},
    };

    this.#executeStatements(trigger.statements || [], ctx);
    return ctx.predef.Return ?? 0;
  }

  #executeStatements(statements, ctx) {
    for (const statement of statements || []) {
      if (statement.call) {
        this.#executeCallStatement(statement.call, ctx);
      } else if (statement.assignment) {
        this.#executeAssignment(statement.assignment, ctx);
      } else if (statement.condition) {
        const result = this.#evalPostfix(statement.condition.expression?.postfix || [], ctx);
        const branch = result ? statement.condition.statements : statement.condition.elseStatements;
        this.#executeStatements(branch || [], ctx);
      }
    }
  }

  #executeCallStatement(call, ctx) {
    const method = call.method || {};
    if (method.runTrigger) {
      const result = this.fire(method.runTrigger.name, ctx);
      ctx.predef.Return = result;
      return result;
    }

    const result = this.#invokeMethod(call, ctx, true);
    ctx.predef.Return = result ?? 0;
    return result;
  }

  #executeAssignment(assignment, ctx) {
    const value = this.#evalPostfix(assignment.expression?.postfix || [], ctx);
    const variable = assignment.variable || {};

    if (variable.boardKey !== undefined) {
      ctx.board.setBoardVariable(variable.boardKey, value);
      ctx.predef.Return = value;
      return value;
    }

    if (variable.triggerVariable?.name) {
      ctx.vars[variable.triggerVariable.name] = value;
      ctx.predef.Return = value;
      return value;
    }

    if (variable.predefinedVariable?.type) {
      ctx.predef[variable.predefinedVariable.type] = value;
      return value;
    }

    this.board.warn(`Unknown trigger assignment: ${JSON.stringify(assignment.variable)}`);
    return 0;
  }

  #evalPostfix(postfix, ctx) {
    const stack = [];
    for (const node of postfix || []) {
      if (node.operator) {
        const op = OPS[node.operator.type];
        if (!op) throw new Error(`Unknown trigger operator: ${node.operator.type}`);
        const b = stack.pop();
        const a = stack.pop();
        stack.push(op(a, b));
      } else if (node.operand) {
        stack.push(this.#evalOperand(node.operand, ctx));
      }
    }
    return stack.pop() ?? 0;
  }

  #evalOperand(operand, ctx) {
    if (operand.constant !== undefined) return operand.constant.value;

    const variable = operand.variable;
    if (variable?.triggerVariable) return ctx.vars[variable.triggerVariable.name] ?? 0;
    if (variable?.predefinedVariable) return ctx.predef[variable.predefinedVariable.type] ?? 0;
    if (variable?.boardKey !== undefined) return ctx.board.getBoardVariable(variable.boardKey);
    if (variable?.unitVariable?.type) return this.#evalUnitVariable(variable.unitVariable.type, ctx);

    if (operand.call) {
      return this.#invokeMethod(operand.call, ctx, false) ?? 0;
    }

    throw new Error(`Unknown trigger operand: ${JSON.stringify(operand)}`);
  }

  #evalUnitVariable(type, ctx) {
    if (ctx.unit && typeof ctx.unit.getVariable === 'function') {
      return ctx.unit.getVariable(type);
    }
    this.board.warn(`Unknown unit variable: ${type}`);
    return 0;
  }

  #invokeMethod(call, ctx, shouldWarn) {
    const [receiverKey, methodSpec] = Object.entries(call.method || {})[0] || [];
    const methodName = methodSpec?.type;
    const receiver =
      receiverKey === 'boardMethod' ? ctx.board :
      receiverKey === 'unitMethod' ? ctx.unit :
      receiverKey === 'skillMethod' ? ctx.skill :
      receiverKey === 'buffMethod' ? ctx.buff :
      null;

    if (!receiver || typeof receiver[methodName] !== 'function') {
      if (shouldWarn) this.board.warn(`Unimplemented trigger call: ${receiverKey}.${methodName}`);
      return 0;
    }

    return receiver[methodName](this.#resolveAssignments(call.assignments || [], ctx));
  }

  #resolveAssignments(assignments, ctx) {
    const args = {};
    for (const assignment of assignments || []) {
      const name = assignment.variable?.parameter?.type;
      if (!name) continue;
      args[name.charAt(0).toLowerCase() + name.slice(1)] =
        this.#evalPostfix(assignment.expression?.postfix || [], ctx);
    }
    return args;
  }
}
