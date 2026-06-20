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

	var player: Dictionary = sim.player_entity
	var player_pos: Vector2 = sim._player_position()
	sim.entities = [player]
	for index in range(6):
		var angle: float = TAU * float(index) / 6.0
		sim.entities.append({
			"runtime_id": 1000 + index,
			"data_id": 110201,
			"name": "spacing dummy",
			"team": "enemy",
			"kind": "enemy",
			"position": player_pos + Vector2(cos(angle), sin(angle)) * 16.0,
			"hp": 9999.0,
			"max_hp": 9999.0,
			"attack": 0.0,
			"defense": 0.0,
			"speed": 0.0,
			"level": 1,
			"body_radius": BattleSim.ENEMY_BODY_RADIUS,
			"active_buffs": [],
		})

	for _i in range(10):
		sim._resolve_enemy_spacing()

	var min_player_distance: float = BattleSim.PLAYER_BODY_RADIUS + BattleSim.ENEMY_BODY_RADIUS - 3.0
	for entity in sim._alive_enemies():
		var distance_to_player: float = sim._dict_vec2(entity, "position", player_pos).distance_to(player_pos)
		if distance_to_player < min_player_distance:
			_fail("enemy overlaps player: %.2f < %.2f" % [distance_to_player, min_player_distance])
			return

	var enemies: Array = sim._alive_enemies()
	for left_index in range(enemies.size()):
		for right_index in range(left_index + 1, enemies.size()):
			var left: Dictionary = enemies[left_index]
			var right: Dictionary = enemies[right_index]
			var pair_distance: float = sim._dict_vec2(left, "position", player_pos).distance_to(sim._dict_vec2(right, "position", player_pos))
			var min_pair_distance: float = (sim._entity_body_radius(left) + sim._entity_body_radius(right)) * 0.82
			if pair_distance < min_pair_distance:
				_fail("enemies overlap: %.2f < %.2f" % [pair_distance, min_pair_distance])
				return

	sim.entities = [player]
	sim.set_player_input(Vector2.RIGHT)
	var move_start: Vector2 = sim._player_position()
	for _i in range(30):
		sim._update_player_movement(1.0 / 60.0)
	var move_distance: float = sim._player_position().distance_to(move_start)
	if move_distance < 140.0:
		_fail("player movement still feels slow: %.2f" % move_distance)
		return

	var dead_enemy := {
		"runtime_id": 2000,
		"data_id": 110201,
		"name": "dead dummy",
		"team": "enemy",
		"kind": "enemy",
		"position": sim._player_position() + Vector2(160.0, 0.0),
		"hp": 0.0,
		"max_hp": 10.0,
		"attack": 0.0,
		"defense": 0.0,
		"speed": 0.0,
		"level": 3,
		"active_buffs": [],
	}
	sim.entities = [player, dead_enemy]
	sim.exp_pickups.clear()
	sim._collect_dead_enemies()
	if sim.exp_pickups.is_empty():
		_fail("dead enemy did not drop exp")
		return

	print("godot-ninja2 combat spacing smoke ok: move=%.1f exp_drops=%d" % [
		move_distance,
		sim.exp_pickups.size(),
	])
	quit(0)


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
