extends SceneTree

const ContentStore := preload("res://scripts/content_store.gd")
const ProgressionState := preload("res://scripts/game/progression_state.gd")
const BasicCombatSim := preload("res://scripts/combat/basic_combat_sim.gd")


func _init() -> void:
	var store = ContentStore.new()
	if not store.load_all():
		push_error("content load failed: %s" % "; ".join(store.errors))
		quit(1)
		return

	var state = ProgressionState.new(store)
	for _i in range(ProgressionState.STONE_SYNTHESIS_COUNT):
		state.add_item_instance(200202)
	state.add_item_instance(200203)
	state.add_item_instance(200204)
	state.auto_equip_best_stones()
	state.learn_skill(200502)

	var sim = BasicCombatSim.new(store)
	sim.set_progression_state(state)
	_apply_state_to_sim(state, sim)
	sim.start(500101)
	_run_seconds(sim, 1.0)
	_print_window("before_merge_warm", sim, 0.30)

	var source_ids := []
	for instance in state.inventory_snapshot().get("items", []):
		if typeof(instance) == TYPE_DICTIONARY and int(instance.get("item_data_id", 0)) == 200202:
			source_ids.append(int(instance.get("instance_id", 0)))
	var merge_result: Dictionary = state.synthesize_stones(source_ids.slice(0, 2))
	if not bool(merge_result.get("ok", false)):
		push_error("merge failed: %s" % str(merge_result))
		quit(1)
		return
	_apply_state_to_sim(state, sim)
	_print_window("after_merge_first_0_10", sim, 0.10)
	_print_window("after_merge_next_0_20", sim, 0.20)
	_print_window("after_merge_next_1_00", sim, 1.00)
	quit(0)


func _apply_state_to_sim(state, sim) -> void:
	var snapshot: Dictionary = state.inventory_snapshot()
	sim.set_player_stat_bonuses(snapshot.get("equipped_stats", {}))
	sim.set_player_learned_skills(snapshot.get("learned_skills", []))
	sim.set_player_stone_loadout(snapshot.get("equipped_stones", []))


func _run_seconds(sim, seconds: float) -> void:
	var ticks := int(round(seconds * 30.0))
	for _i in range(ticks):
		sim.step(1.0 / 30.0)


func _print_window(label: String, sim, seconds: float) -> void:
	var before: Dictionary = sim.snapshot()
	var cast_before := int(before.get("player_skill_cast_count", 0))
	var learned_before := int(before.get("player_learned_skill_cast_count", 0))
	_run_seconds(sim, seconds)
	var after: Dictionary = sim.snapshot()
	var cast_after := int(after.get("player_skill_cast_count", 0))
	var learned_after := int(after.get("player_learned_skill_cast_count", 0))
	print("%s seconds=%.2f player_cast_delta=%d learned_delta=%d total_player_cast=%d learned_total=%d stones=%s learned=%s" % [
		label,
		seconds,
		cast_after - cast_before,
		learned_after - learned_before,
		cast_after,
		learned_after,
		str(after.get("player_stone_skill_ids", [])),
		str(after.get("player_learned_skill_ids", [])),
	])
