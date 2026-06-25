extends SceneTree

const ContentStore := preload("res://scripts/content_store.gd")
const BasicCombatSim := preload("res://scripts/combat/basic_combat_sim.gd")
const SpriteCatalog := preload("res://scripts/visual/sprite_catalog.gd")

const EXPECTED_500101_WAVES := [
	[111011],
	[111011, 111012],
	[111013, 111014],
	[111014, 111012, 111011],
	[111015, 111013, 111011],
]
const EXPECTED_500101_WAVE_COUNTS := [7, 9, 7, 12, 8]

const EXPECTED_TAG_SKILLS := {
	"Basic": 300201,
	"Fast": 300202,
	"Ranged": 300203,
	"Armored": 300204,
	"MiniBoss": 300205,
}

var failed := false


func _init() -> void:
	var store = ContentStore.new()
	if not store.load_all():
		_fail("content load failed: %s" % "; ".join(store.errors))
		return

	_check_map_500101_plan(store)
	if failed:
		return
	_check_monster_skill_bindings(store)
	if failed:
		return
	_check_runtime_spawn_binding(store)
	if failed:
		return
	_check_stage_scaling_reaches_runtime(store)
	if failed:
		return
	_check_unit_sprite_paths(store)
	if failed:
		return

	print("godot-taskstonebar content mapping smoke ok")
	quit(0)


func _check_map_500101_plan(store) -> void:
	var sim = BasicCombatSim.new(store)
	sim.start(500101)
	var snapshot: Dictionary = sim.snapshot()
	if int(snapshot.get("wave_count", 0)) != EXPECTED_500101_WAVES.size():
		_fail("500101 expected %d trigger waves, got %d" % [EXPECTED_500101_WAVES.size(), int(snapshot.get("wave_count", 0))])
		return
	for i in range(EXPECTED_500101_WAVES.size()):
		var actual := _pending_unique_unit_ids(sim)
		if actual != EXPECTED_500101_WAVES[i]:
			_fail("500101 trigger wave %d expected units %s, got %s" % [
				i + 1,
				str(EXPECTED_500101_WAVES[i]),
				str(actual),
			])
			return
		var actual_count := _pending_spawn_count(sim)
		if actual_count != int(EXPECTED_500101_WAVE_COUNTS[i]):
			_fail("500101 trigger wave %d expected %d pending spawns, got %d" % [
				i + 1,
				int(EXPECTED_500101_WAVE_COUNTS[i]),
				actual_count,
			])
			return
		sim.pending_spawns.clear()
		sim.enemies.clear()
		if i < EXPECTED_500101_WAVES.size() - 1:
			sim._run_map_update_triggers(1.0)


func _check_monster_skill_bindings(store) -> void:
	var sim = BasicCombatSim.new(store)
	for unit in store.get_records("Units"):
		if typeof(unit) != TYPE_DICTIONARY:
			continue
		var tags: Array = unit.get("tags", []) if typeof(unit.get("tags", [])) == TYPE_ARRAY else []
		if not tags.has("Monster"):
			continue
		if tags.has("GiantBoss"):
			var phases: Array = sim._skill_phase_specs_for_unit(unit)
			var phase_skills := []
			for phase in phases:
				if typeof(phase) == TYPE_DICTIONARY:
					phase_skills.append(int(phase.get("skill_id", 0)))
			if phase_skills != [300208, 300207, 300206]:
				_fail("%s expected boss phase skills [300208, 300207, 300206], got %s" % [
					str(unit.get("name", unit.get("id", ""))),
					str(phase_skills),
				])
				return
			continue
		var expected_skill_id := 0
		for tag in EXPECTED_TAG_SKILLS.keys():
			if tags.has(tag):
				expected_skill_id = int(EXPECTED_TAG_SKILLS[tag])
				break
		if expected_skill_id <= 0:
			continue
		var spec: Dictionary = sim._skill_spec_for_unit(unit)
		if int(spec.get("skill_id", 0)) != expected_skill_id:
			_fail("%s expected skill %d, got %d from %s" % [
				str(unit.get("name", unit.get("id", ""))),
				expected_skill_id,
				int(spec.get("skill_id", 0)),
				str(spec.get("trigger_name", "")),
			])
			return


func _check_runtime_spawn_binding(store) -> void:
	var sim = BasicCombatSim.new(store)
	sim.start(500101)
	for _i in range(8):
		sim.step(1.0 / 30.0)
	var snapshot: Dictionary = sim.snapshot()
	var enemies: Array = snapshot.get("enemies", [])
	if enemies.is_empty():
		_fail("500101 did not spawn first enemy")
		return
	var enemy: Dictionary = enemies[0]
	if int(enemy.get("unit_id", 0)) != 111011:
		_fail("500101 first runtime enemy expected unit 111011, got %d" % int(enemy.get("unit_id", 0)))
		return
	if int(enemy.get("skill_id", 0)) != 300201:
		_fail("unit 111011 expected runtime skill 300201, got %d" % int(enemy.get("skill_id", 0)))
		return
	var world_size: Vector2 = snapshot.get("world_size", Vector2(960.0, 160.0))
	var enemy_position: Vector2 = enemy.get("position", Vector2.ZERO)
	if enemy_position.x <= world_size.x:
		_fail("first runtime enemy should enter from outside the right edge, got x=%.1f world_width=%.1f" % [enemy_position.x, world_size.x])
		return
	var saw_spawn_fx := false
	for event in snapshot.get("fx_events", []):
		if typeof(event) == TYPE_DICTIONARY and str(event.get("kind", "")) == "spawn" and str(event.get("fx_key", "")) != "":
			saw_spawn_fx = true
			break
	if not saw_spawn_fx:
		_fail("first runtime enemy did not emit spawn fx")
		return
	if sim.player_skill_rotation.size() != 1 or int(sim.player_skill_rotation[0].get("id", 0)) != 300101:
		_fail("player default skills should be [300101], got %s" % str(_skill_ids(sim.player_skill_rotation)))
		return


func _check_stage_scaling_reaches_runtime(store) -> void:
	var skill_ratio := float(store.skill_damage_total_ratio(store.get_skill(300102), 1))
	if skill_ratio < 1.0 or skill_ratio > 2.0:
		_fail("skill 300102 expected compiled attack ratio near 1.12, got %.3f" % skill_ratio)
		return

	if int(_init_variable(store.get_map(500101), 605)) != 1:
		_fail("500101 enemyLevel init variable should be 1")
		return
	if int(_init_variable(store.get_map(500150), 605)) != 152:
		_fail("500150 enemyLevel init variable should be 152")
		return
	if int(_init_variable(store.get_map(500200), 605)) != 307:
		_fail("500200 enemyLevel init variable should be 307")
		return

	var stage1_enemy := _first_runtime_enemy(store, 500101)
	if failed:
		return
	var stage10_enemy := _first_runtime_enemy(store, 500110)
	if failed:
		return
	var stage50_enemy := _first_runtime_enemy(store, 500150)
	if failed:
		return
	var stage100_enemy := _first_runtime_enemy(store, 500200)
	if failed:
		return

	if int(stage1_enemy.get("level", 0)) != 1:
		_fail("500101 first enemy expected level 1, got %d" % int(stage1_enemy.get("level", 0)))
		return
	if int(stage10_enemy.get("level", 0)) < 28:
		_fail("500110 first enemy expected level >= 28, got %d" % int(stage10_enemy.get("level", 0)))
		return
	if int(stage50_enemy.get("level", 0)) < 152:
		_fail("500150 first enemy expected level >= 152, got %d" % int(stage50_enemy.get("level", 0)))
		return
	if int(stage100_enemy.get("level", 0)) < 307:
		_fail("500200 first enemy expected level >= 307, got %d" % int(stage100_enemy.get("level", 0)))
		return

	var hp1 := float(stage1_enemy.get("max_hp", 0.0))
	var hp10 := float(stage10_enemy.get("max_hp", 0.0))
	var hp50 := float(stage50_enemy.get("max_hp", 0.0))
	var hp100 := float(stage100_enemy.get("max_hp", 0.0))
	if hp1 < 430.0 or hp1 > 450.0:
		_fail("500101 first enemy hp should use early 2-3 hit onboarding hp near 440, got %.1f" % hp1)
		return
	if hp10 <= 372.0:
		_fail("500110 first enemy hp %.1f should survive the starting best stone hit" % hp10)
		return
	if hp50 <= hp1 * 10.0:
		_fail("500150 first enemy hp %.1f did not scale enough from 500101 hp %.1f" % [hp50, hp1])
		return
	if hp100 <= hp1 * 100.0:
		_fail("500200 first enemy hp %.1f did not scale enough from 500101 hp %.1f" % [hp100, hp1])
		return

	var stage1_player := _player_for_map(store, 500101)
	var stage100_player := _player_for_map(store, 500200)
	if int(stage1_player.get("level", 0)) != 1 or int(stage100_player.get("level", 0)) != 1:
		_fail("player level should not inherit map stage: stage1=%d stage100=%d" % [
			int(stage1_player.get("level", 0)),
			int(stage100_player.get("level", 0)),
		])
		return
	if absf(float(stage1_player.get("attack", 0.0)) - float(stage100_player.get("attack", 0.0))) > 0.001:
		_fail("player attack should not inherit map stage: stage1=%.1f stage100=%.1f" % [
			float(stage1_player.get("attack", 0.0)),
			float(stage100_player.get("attack", 0.0)),
		])
		return


func _check_unit_sprite_paths(store) -> void:
	var sprites = SpriteCatalog.new()
	if not sprites.load_all():
		_fail("sprite catalog load failed: %s" % "; ".join(sprites.errors))
		return
	for unit in store.get_records("Units"):
		if typeof(unit) != TYPE_DICTIONARY:
			continue
		var tags: Array = unit.get("tags", []) if typeof(unit.get("tags", [])) == TYPE_ARRAY else []
		if not tags.has("Monster"):
			continue
		var texture: Texture2D = sprites.texture_for_unit(int(unit.get("id", 0)), str(unit.get("sprite", "")))
		if texture == null:
			_fail("%s has no loadable sprite %s" % [str(unit.get("name", unit.get("id", ""))), str(unit.get("sprite", ""))])
			return
	if not sprites.errors.is_empty():
		_fail("sprite mapping errors: %s" % "; ".join(sprites.errors))
		return


func _skill_ids(skills: Array) -> Array:
	var ids := []
	for skill in skills:
		if typeof(skill) == TYPE_DICTIONARY:
			ids.append(int(skill.get("id", 0)))
	return ids


func _pending_unique_unit_ids(sim) -> Array:
	var ids := []
	for entry in sim.pending_spawns:
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		var unit_id := int(entry.get("unit_id", 0))
		if unit_id > 0 and not ids.has(unit_id):
			ids.append(unit_id)
	return ids


func _pending_spawn_count(sim) -> int:
	var count := 0
	for entry in sim.pending_spawns:
		if typeof(entry) == TYPE_DICTIONARY and int(entry.get("unit_id", 0)) > 0:
			count += 1
	return count


func _first_runtime_enemy(store, map_id: int) -> Dictionary:
	var sim = BasicCombatSim.new(store)
	sim.start(map_id)
	if sim.pending_spawns.is_empty():
		_fail("%d did not queue initial enemy spawns" % map_id)
		return {}
	sim._spawn_enemy(sim.pending_spawns.pop_front())
	var enemies: Array = sim.snapshot().get("enemies", [])
	if enemies.is_empty() or typeof(enemies[0]) != TYPE_DICTIONARY:
		_fail("%d did not spawn a runtime enemy" % map_id)
		return {}
	return enemies[0]


func _player_for_map(store, map_id: int) -> Dictionary:
	var sim = BasicCombatSim.new(store)
	sim.start(map_id)
	var player = sim.snapshot().get("player", {})
	return player if typeof(player) == TYPE_DICTIONARY else {}


func _init_variable(map_def: Dictionary, caller_key: int) -> float:
	for variable in map_def.get("initVariables", []):
		if typeof(variable) == TYPE_DICTIONARY and int(variable.get("callerKey", 0)) == int(caller_key):
			return float(variable.get("value", 0.0))
	return 0.0


func _fail(message: String) -> void:
	failed = true
	push_error(message)
	quit(1)
