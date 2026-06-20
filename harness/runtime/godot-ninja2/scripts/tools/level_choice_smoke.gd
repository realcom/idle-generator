extends SceneTree

const ContentStore := preload("res://scripts/content_store.gd")
const RunState := preload("res://scripts/sim/run_state.gd")
const BattleSim := preload("res://scripts/battle_sim.gd")


func _init() -> void:
	var store = ContentStore.new()
	if not store.load_all():
		_fail("content load had errors: %s" % "; ".join(store.errors))
		return

	var state = RunState.new()
	state.reset()
	var sim = BattleSim.new(store, state)
	sim.start(500101)
	sim._add_player_exp(sim._exp_required_for_level(1))

	var snapshot: Dictionary = sim.snapshot()
	var level_choice: Dictionary = snapshot.get("level_choice", {})
	if not bool(level_choice.get("pending", false)):
		_fail("level choice did not open at the level threshold")
		return

	var choices: Array = level_choice.get("choices", [])
	if choices.size() != 3:
		_fail("level choice expected 3 options, got %d" % choices.size())
		return

	var first_choice: Dictionary = choices[0]
	var skill_id := int(first_choice.get("skill_id", 0))
	var next_level := int(first_choice.get("next_level", 0))
	if skill_id <= 0 or next_level <= 0:
		_fail("level choice missing skill id or next level")
		return

	if not sim.apply_level_choice(0):
		_fail("level choice apply failed")
		return

	var after_choice: Dictionary = sim.snapshot().get("level_choice", {})
	if bool(after_choice.get("pending", false)):
		_fail("level choice remained pending after selection")
		return

	var applied := false
	for slot in sim.skill_slots:
		if typeof(slot) == TYPE_DICTIONARY and int(slot.get("skill_id", 0)) == skill_id and int(slot.get("level", 0)) == next_level:
			applied = true
			break
	if not applied:
		_fail("selected skill level was not applied")
		return

	print("godot-ninja2 level choice smoke ok: skill=%d level=%d choices=%d" % [skill_id, next_level, choices.size()])
	quit(0)


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
