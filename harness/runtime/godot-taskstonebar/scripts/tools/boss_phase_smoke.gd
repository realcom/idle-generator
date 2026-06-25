extends SceneTree

const ContentStore := preload("res://scripts/content_store.gd")
const BasicCombatSim := preload("res://scripts/combat/basic_combat_sim.gd")


func _init() -> void:
	var store = ContentStore.new()
	if not store.load_all():
		_fail("content load failed: %s" % "; ".join(store.errors))
		return

	var sim = BasicCombatSim.new(store)
	var boss_unit: Dictionary = store.get_unit(111501)
	if boss_unit.is_empty():
		_fail("boss unit 111501 not found")
		return

	var phases: Array = sim._skill_phase_specs_for_unit(boss_unit)
	if phases.size() != 3:
		_fail("expected 3 boss phases, got %d" % phases.size())
		return

	var checks := [
		{"hp": 100.0, "skill_id": 300206, "phase": "Phase 1"},
		{"hp": 69.0, "skill_id": 300207, "phase": "Phase 2"},
		{"hp": 34.0, "skill_id": 300208, "phase": "Phase 3"},
	]
	for check in checks:
		var enemy := {
			"skill_id": 300206,
			"skill_name": "",
			"skill_damage_ratio": 1.0,
			"skill_phases": phases,
			"hp": float(check["hp"]),
			"max_hp": 100.0,
		}
		var skill_info: Dictionary = sim._current_enemy_skill(enemy)
		if int(skill_info.get("skill_id", 0)) != int(check["skill_id"]):
			_fail("hp %.1f expected skill %d, got %d" % [
				float(check["hp"]),
				int(check["skill_id"]),
				int(skill_info.get("skill_id", 0)),
			])
			return
		if str(skill_info.get("phase_name", "")) != str(check["phase"]):
			_fail("hp %.1f expected %s, got %s" % [
				float(check["hp"]),
				str(check["phase"]),
				str(skill_info.get("phase_name", "")),
			])
			return

	print("godot-taskstonebar boss phase smoke ok: phases=%d" % phases.size())
	quit(0)


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
