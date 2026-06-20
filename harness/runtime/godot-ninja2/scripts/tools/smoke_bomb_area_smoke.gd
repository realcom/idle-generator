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
	sim.pending_spawns.clear()
	sim.exp_pickups.clear()
	_remove_enemies(sim)

	var skill_def: Dictionary = store.get_skill(300103)
	if skill_def.is_empty():
		_fail("smoke bomb skill 300103 was not loaded")
		return

	sim.skill_slots = [{
		"skill_id": 300103,
		"name": str(skill_def.get("name", "연막 폭탄")),
		"cooldown": 10.0,
		"timer": 0.0,
		"level": 1,
	}]

	var player_position: Vector2 = sim.snapshot().get("player", {}).get("position", Vector2.ZERO)
	var smoke_center := player_position + Vector2(360.0, 0.0)
	var throw_target := _make_enemy(9001, smoke_center)
	sim.entities.append(throw_target)

	for _i in range(10):
		sim.step(1.0 / 30.0)

	var armed_snapshot: Dictionary = sim.snapshot()
	if int(armed_snapshot.get("active_ground_area_count", 0)) < 1:
		_fail("smoke bomb did not create a persistent ground area")
		return

	var late_enemy := _make_enemy(9002, smoke_center + Vector2(24.0, 0.0))
	var late_enemy_hp := float(late_enemy.get("hp", 0.0))
	sim.entities.append(late_enemy)

	for _i in range(22):
		sim.step(1.0 / 30.0)

	if float(late_enemy.get("hp", 0.0)) >= late_enemy_hp:
		_fail("enemy entering smoke after cast did not take damage")
		return
	if not _has_buff(late_enemy, 400102):
		_fail("enemy entering smoke after cast did not receive smoke slow")
		return

	print("godot-ninja2 smoke bomb area smoke ok: late_enemy_hp=%.1f active_areas=%d" % [
		float(late_enemy.get("hp", 0.0)),
		int(sim.snapshot().get("active_ground_area_count", 0)),
	])
	quit(0)


func _remove_enemies(sim) -> void:
	for index in range(sim.entities.size() - 1, -1, -1):
		var entity: Dictionary = sim.entities[index]
		if str(entity.get("team", "")) == "enemy":
			sim.entities.remove_at(index)


func _make_enemy(runtime_id: int, position: Vector2) -> Dictionary:
	return {
		"runtime_id": runtime_id,
		"data_id": 110201,
		"name": "연막 시험 허수",
		"team": "enemy",
		"kind": "enemy",
		"position": position,
		"hp": 1000.0,
		"max_hp": 1000.0,
		"attack": 0.0,
		"defense": 0.0,
		"speed": 0.0,
		"body_radius": 48.0,
		"active_buffs": [],
	}


func _has_buff(entity: Dictionary, buff_id: int) -> bool:
	for buff in entity.get("active_buffs", []):
		if typeof(buff) == TYPE_DICTIONARY and int(buff.get("buff_id", 0)) == buff_id:
			return true
	return false


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
