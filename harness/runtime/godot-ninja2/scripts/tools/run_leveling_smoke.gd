extends SceneTree

const ContentStore := preload("res://scripts/content_store.gd")
const RunState := preload("res://scripts/sim/run_state.gd")
const BattleSim := preload("res://scripts/battle_sim.gd")


func _init() -> void:
	var store = ContentStore.new()
	if not store.load_all():
		_fail("content load had errors: %s" % "; ".join(store.errors))
		return

	var map_def: Dictionary = store.get_map(500101)
	var board_constants: Dictionary = store.map_board_constants(map_def)
	var leveling: Dictionary = board_constants.get("survivalRunLeveling", {})
	if leveling.is_empty():
		_fail("survivalRunLeveling was not loaded from map globals")
		return

	var state = RunState.new()
	state.reset()
	var sim = BattleSim.new(store, state)
	sim.start(500101)
	if sim.skill_slots.size() != 1:
		_fail("expected one starter skill, got %d" % sim.skill_slots.size())
		return
	if int(sim.skill_slots[0].get("skill_id", 0)) != 300101:
		_fail("starter skill should be 300101, got %d" % int(sim.skill_slots[0].get("skill_id", 0)))
		return

	var expected_requirements: Array[int] = [24, 46, 76]
	for index in range(expected_requirements.size()):
		var level: int = index + 1
		var required: int = sim._exp_required_for_level(level)
		if required != expected_requirements[index]:
			_fail("unexpected exp requirement L%d: %d != %d" % [level, required, expected_requirements[index]])
			return

	sim._add_player_exp(expected_requirements[0] - 1)
	if bool(sim.snapshot().get("level_choice", {}).get("pending", false)):
		_fail("level choice opened before first requirement")
		return

	sim._add_player_exp(1)
	var snapshot: Dictionary = sim.snapshot()
	if int(snapshot.get("player_level", 1)) != 2:
		_fail("player did not reach level 2 at first requirement")
		return
	if not bool(snapshot.get("level_choice", {}).get("pending", false)):
		_fail("level choice did not open at first requirement")
		return
	var expected_choices: Array[int] = [300102, 300103, 300115]
	var actual_choices: Array[int] = []
	for choice in snapshot.get("level_choice", {}).get("choices", []):
		if typeof(choice) == TYPE_DICTIONARY:
			actual_choices.append(int(choice.get("skill_id", 0)))
	actual_choices.sort()
	expected_choices.sort()
	if actual_choices != expected_choices:
		_fail("unexpected first choice pool: %s != %s" % [str(actual_choices), str(expected_choices)])
		return

	print("godot-ninja2 run leveling smoke ok: req=%s choice_count=%d max_skill=%d" % [
		str(expected_requirements),
		sim._level_choice_count(),
		sim._max_run_skill_level(),
	])
	quit(0)


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
