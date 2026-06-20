extends RefCounted

const OPS := {
	"Add": "_op_add",
	"Subtract": "_op_subtract",
	"Multiply": "_op_multiply",
	"Divide": "_op_divide",
}

var store


func _init(resource_store = null) -> void:
	store = resource_store


func build_plan(map_def: Dictionary) -> Array:
	var board_vars: Dictionary = store.map_init_variables(map_def) if store != null else {}
	var wave_count: int = store.map_wave_count(map_def) if store != null else 1
	var trigger_names: Array = map_def.get("triggers", [])
	var start_triggers: Array = _ordered_start_triggers(trigger_names, wave_count)
	var waves := []

	for index in range(start_triggers.size()):
		var trigger_name := str(start_triggers[index])
		var trigger: Dictionary = store.get_trigger(trigger_name) if store != null else {}
		var units: Array = _extract_add_units(trigger, board_vars)
		if units.is_empty():
			continue
		waves.append({
			"index": waves.size() + 1,
			"trigger": trigger_name,
			"units": units,
			"total_count": _sum_counts(units),
			"is_boss": trigger_name.contains("BOSS"),
		})

	if waves.is_empty():
		waves.append({
			"index": 1,
			"trigger": "fallback",
			"units": [{"unit_id": 110201, "count": 12, "level": 1}],
			"total_count": 12,
			"is_boss": false,
		})

	return waves


func _ordered_start_triggers(trigger_names: Array, wave_count: int) -> Array:
	var result := []
	var update_triggers := []

	for trigger_name in trigger_names:
		var name := str(trigger_name)
		if name.contains("_ONSTART_"):
			result.append(name)
		elif name.contains("_ONUPDATE_"):
			update_triggers.append(name)

	for update_name in update_triggers:
		var trigger: Dictionary = store.get_trigger(update_name) if store != null else {}
		for run_name in _extract_run_triggers(trigger):
			if not result.has(run_name):
				result.append(run_name)

	result.sort_custom(func(a, b): return _wave_sort_key(str(a), wave_count) < _wave_sort_key(str(b), wave_count))
	return result


func _wave_sort_key(trigger_name: String, wave_count: int) -> int:
	if trigger_name.contains("BOSS"):
		return wave_count * 10 + 9

	var regex := RegEx.new()
	regex.compile("WAVE(\\d+)")
	var hit := regex.search(trigger_name)
	if hit != null:
		return int(hit.get_string(1)) * 10
	return 0


func _extract_run_triggers(trigger: Dictionary) -> Array:
	var names := []
	_walk_statements(trigger.get("statements", []), func(statement):
		if not statement.has("call"):
			return
		var method = statement["call"].get("method", {})
		if typeof(method) == TYPE_DICTIONARY and method.has("runTrigger"):
			names.append(str(method["runTrigger"].get("name", "")))
	)
	return names


func _extract_add_units(trigger: Dictionary, board_vars: Dictionary) -> Array:
	var units := []
	_walk_statements(trigger.get("statements", []), func(statement):
		if not statement.has("call"):
			return
		var call: Dictionary = statement["call"]
		var method = call.get("method", {})
		if typeof(method) != TYPE_DICTIONARY:
			return
		var board_method = method.get("boardMethod", {})
		if typeof(board_method) != TYPE_DICTIONARY or str(board_method.get("type", "")) != "AddUnit":
			return

		var params := {}
		for assignment in call.get("assignments", []):
			if typeof(assignment) != TYPE_DICTIONARY:
				continue
			var variable = assignment.get("variable", {})
			var parameter = variable.get("parameter", {}) if typeof(variable) == TYPE_DICTIONARY else {}
			var parameter_type := str(parameter.get("type", ""))
			if parameter_type == "":
				continue
			params[parameter_type] = _eval_postfix(assignment.get("expression", {}).get("postfix", []), board_vars)

		var unit_id := int(params.get("UnitDataId", 0))
		var count := int(params.get("Count", 0))
		if unit_id <= 0 or count <= 0:
			return
		units.append({
			"unit_id": unit_id,
			"count": count,
			"level": max(1, int(round(float(params.get("Level", 1))))),
			"team": int(params.get("Team", 4)),
		})
	)
	return units


func _walk_statements(statements: Array, visitor: Callable) -> void:
	for statement in statements:
		if typeof(statement) != TYPE_DICTIONARY:
			continue
		visitor.call(statement)
		if statement.has("condition"):
			var condition = statement["condition"]
			if typeof(condition) == TYPE_DICTIONARY:
				_walk_statements(condition.get("statements", []), visitor)
				_walk_statements(condition.get("elseStatements", []), visitor)


func _eval_postfix(postfix: Array, board_vars: Dictionary) -> float:
	var stack := []
	for node in postfix:
		if typeof(node) != TYPE_DICTIONARY:
			continue
		if node.has("operator"):
			var operator_type := str(node["operator"].get("type", ""))
			var b := float(stack.pop_back()) if stack.size() > 0 else 0.0
			var a := float(stack.pop_back()) if stack.size() > 0 else 0.0
			stack.append(_apply_operator(operator_type, a, b))
		elif node.has("operand"):
			stack.append(_eval_operand(node["operand"], board_vars))

	return float(stack.back()) if stack.size() > 0 else 0.0


func _eval_operand(operand: Dictionary, board_vars: Dictionary) -> float:
	if operand.has("constant"):
		return float(operand["constant"].get("value", 0.0))
	if operand.has("variable"):
		var variable = operand["variable"]
		if typeof(variable) == TYPE_DICTIONARY and variable.has("boardKey"):
			return float(board_vars.get(int(variable["boardKey"]), 0.0))
	return 0.0


func _apply_operator(operator_type: String, a: float, b: float) -> float:
	match operator_type:
		"Add":
			return a + b
		"Subtract":
			return a - b
		"Multiply":
			return a * b
		"Divide":
			return a / b if b != 0.0 else 0.0
		_:
			return 0.0


func _sum_counts(units: Array) -> int:
	var total := 0
	for unit in units:
		total += int(unit.get("count", 0))
	return total
