extends RefCounted

const PLAYER_UNIT_ID := 110111
const BASIC_SKILL_ID := 300101
const ENEMY_UNIT_IDS := [110201, 110202, 110203]
const BOSS_UNIT_ID := 110501
const WORLD_SIZE := Vector2(3000.0, 2000.0)
const CONTACT_RANGE := 46.0
const CONTACT_DAMAGE_SCALE := 0.72
const SPEED_TO_PIXELS := 42.0

var store
var rng := RandomNumberGenerator.new()
var entities: Array = []
var floating_events: Array = []
var resources := {
	"gold": 320,
	"wood": 0,
	"stone": 0,
	"soul": 0,
}

var running := false
var result := ""
var map_id := 500101
var map_def := {}
var player_entity := {}
var elapsed := 0.0
var run_duration := 90.0
var spawn_timer := 0.0
var skill_timer := 0.0
var boss_spawned := false
var kill_count := 0
var wave := 1
var next_runtime_id := 1


func _init(resource_store = null) -> void:
	store = resource_store
	rng.randomize()


func start(new_map_id := 500101) -> void:
	map_id = int(new_map_id)
	map_def = store.get_map(map_id) if store != null else {}
	if map_def.is_empty() and store != null:
		var maps := store.get_main_maps()
		if maps.size() > 0:
			map_def = maps[0]
			map_id = int(map_def.get("id", map_id))

	entities.clear()
	floating_events.clear()
	player_entity.clear()
	elapsed = 0.0
	spawn_timer = 0.1
	skill_timer = 0.15
	boss_spawned = false
	kill_count = 0
	wave = 1
	next_runtime_id = 1
	result = ""
	running = true
	_spawn_player()


func step(delta: float) -> void:
	if not running:
		return

	var capped_delta := min(delta, 0.05)
	elapsed += capped_delta
	wave = int(elapsed / 18.0) + 1
	spawn_timer -= capped_delta
	skill_timer -= capped_delta

	if spawn_timer <= 0.0:
		_spawn_enemy()
		spawn_timer = max(0.28, 1.15 - float(wave) * 0.08)

	if _should_spawn_boss():
		_spawn_enemy(BOSS_UNIT_ID)
		boss_spawned = true

	_update_enemies(capped_delta)
	_update_player_attack()
	_decay_events(capped_delta)
	_collect_dead_enemies()

	if not player_entity.is_empty() and float(player_entity.get("hp", 0.0)) <= 0.0:
		_finish("defeat")
	elif elapsed >= run_duration:
		_finish("clear")


func snapshot() -> Dictionary:
	return {
		"running": running,
		"result": result,
		"map_id": map_id,
		"map_name": str(map_def.get("name", "대나무 영지")),
		"elapsed": elapsed,
		"run_duration": run_duration,
		"wave": wave,
		"kill_count": kill_count,
		"enemy_count": _alive_enemies().size(),
		"player": player_entity,
		"entities": entities,
		"events": floating_events,
		"resources": resources,
	}


func _spawn_player() -> void:
	var unit_def := store.get_unit(PLAYER_UNIT_ID) if store != null else {}
	if unit_def.is_empty() and store != null:
		unit_def = store.get_player_unit()

	var hp := store.stat_value(unit_def, "Hp", 1200.0)
	player_entity = {
		"runtime_id": next_runtime_id,
		"data_id": int(unit_def.get("id", PLAYER_UNIT_ID)),
		"name": str(unit_def.get("name", "그림자 닌자")),
		"team": "player",
		"kind": "player",
		"position": WORLD_SIZE * 0.5,
		"hp": hp,
		"max_hp": hp,
		"attack": store.stat_value(unit_def, "Attack", 80.0),
		"defense": store.stat_value(unit_def, "Defense", 3.0),
		"speed": store.stat_value(unit_def, "MoveSpeed", 3.4),
	}
	next_runtime_id += 1
	entities.append(player_entity)


func _spawn_enemy(forced_unit_id := 0) -> void:
	if _alive_enemies().size() >= 32:
		return

	var unit_id := int(forced_unit_id)
	if unit_id == 0:
		unit_id = ENEMY_UNIT_IDS[rng.randi_range(0, ENEMY_UNIT_IDS.size() - 1)]

	var unit_def := store.get_unit(unit_id) if store != null else {}
	if unit_def.is_empty():
		return

	var is_boss := unit_id == BOSS_UNIT_ID or str(unit_def.get("type", "")) == "Boss"
	var hp_scale := 1.0 + float(wave - 1) * 0.23
	var attack_scale := 1.0 + float(wave - 1) * 0.12
	if is_boss:
		hp_scale *= 3.7
		attack_scale *= 1.8

	var hp := store.stat_value(unit_def, "Hp", 80.0) * hp_scale
	var spawn_position := _random_edge_position()
	var enemy := {
		"runtime_id": next_runtime_id,
		"data_id": unit_id,
		"name": str(unit_def.get("name", "적")),
		"team": "enemy",
		"kind": "boss" if is_boss else "enemy",
		"position": spawn_position,
		"hp": hp,
		"max_hp": hp,
		"attack": store.stat_value(unit_def, "Attack", 6.0) * attack_scale,
		"defense": store.stat_value(unit_def, "Defense", 1.0),
		"speed": store.stat_value(unit_def, "MoveSpeed", 2.8) * (0.75 if is_boss else 1.0),
	}
	next_runtime_id += 1
	entities.append(enemy)


func _update_enemies(delta: float) -> void:
	if player_entity.is_empty():
		return

	var player_pos = player_entity.get("position", WORLD_SIZE * 0.5)
	for entity in entities:
		if entity.get("team", "") != "enemy" or float(entity.get("hp", 0.0)) <= 0.0:
			continue

		var pos = entity.get("position", Vector2.ZERO)
		var to_player := player_pos - pos
		var distance := to_player.length()
		if distance > 1.0:
			pos += to_player.normalized() * float(entity.get("speed", 2.0)) * SPEED_TO_PIXELS * delta
			entity["position"] = pos

		if distance <= CONTACT_RANGE + (42.0 if entity.get("kind", "") == "boss" else 0.0):
			var damage := max(1.0, float(entity.get("attack", 4.0)) - float(player_entity.get("defense", 0.0)))
			player_entity["hp"] = max(0.0, float(player_entity["hp"]) - damage * CONTACT_DAMAGE_SCALE * delta)


func _update_player_attack() -> void:
	if skill_timer > 0.0 or player_entity.is_empty():
		return

	var target := _nearest_enemy()
	var skill_def := store.get_skill(BASIC_SKILL_ID) if store != null else {}
	skill_timer = max(0.18, float(skill_def.get("cooldown", 0.55)))

	if target.is_empty():
		return

	var base_damage := float(player_entity.get("attack", 80.0))
	var damage := max(1.0, base_damage - float(target.get("defense", 0.0)))
	if rng.randf() < 0.14:
		damage *= 1.8
		_add_event(target["position"], "치명 %.0f" % damage, Color(1.0, 0.86, 0.25))
	else:
		_add_event(target["position"], "%.0f" % damage, Color(0.9, 1.0, 0.9))

	target["hp"] = max(0.0, float(target.get("hp", 0.0)) - damage)


func _collect_dead_enemies() -> void:
	for index in range(entities.size() - 1, -1, -1):
		var entity = entities[index]
		if entity.get("team", "") != "enemy" or float(entity.get("hp", 0.0)) > 0.0:
			continue

		var kind := str(entity.get("kind", "enemy"))
		var gold_gain := 45 if kind == "boss" else rng.randi_range(5, 13)
		var wood_gain := rng.randi_range(1, 3)
		resources["gold"] = int(resources["gold"]) + gold_gain
		resources["wood"] = int(resources["wood"]) + wood_gain
		if rng.randf() < 0.18 or kind == "boss":
			resources["soul"] = int(resources["soul"]) + (3 if kind == "boss" else 1)
		if rng.randf() < 0.16:
			resources["stone"] = int(resources["stone"]) + 1

		kill_count += 1
		_add_event(entity["position"], "+%d 골드" % gold_gain, Color(1.0, 0.72, 0.22))
		entities.remove_at(index)


func _alive_enemies() -> Array:
	var enemies := []
	for entity in entities:
		if entity.get("team", "") == "enemy" and float(entity.get("hp", 0.0)) > 0.0:
			enemies.append(entity)
	return enemies


func _nearest_enemy() -> Dictionary:
	var best := {}
	var best_distance := INF
	if player_entity.is_empty():
		return best

	var player_pos = player_entity.get("position", WORLD_SIZE * 0.5)
	for enemy in _alive_enemies():
		var distance := player_pos.distance_to(enemy["position"])
		if distance < best_distance:
			best_distance = distance
			best = enemy
	return best


func _random_edge_position() -> Vector2:
	var player_pos = WORLD_SIZE * 0.5
	if not player_entity.is_empty():
		player_pos = player_entity.get("position", player_pos)

	var angle := rng.randf_range(0.0, TAU)
	var radius := rng.randf_range(430.0, 620.0)
	var pos := player_pos + Vector2(cos(angle), sin(angle)) * radius
	pos.x = clamp(pos.x, 120.0, WORLD_SIZE.x - 120.0)
	pos.y = clamp(pos.y, 120.0, WORLD_SIZE.y - 120.0)
	return pos


func _should_spawn_boss() -> bool:
	if boss_spawned or elapsed < 48.0:
		return false
	var tags = map_def.get("tags", [])
	return tags.has("Boss") or map_id >= 500105


func _add_event(world_position: Vector2, text: String, color: Color) -> void:
	floating_events.append({
		"position": world_position,
		"text": text,
		"color": color,
		"life": 0.72,
	})


func _decay_events(delta: float) -> void:
	for index in range(floating_events.size() - 1, -1, -1):
		var event = floating_events[index]
		event["life"] = float(event.get("life", 0.0)) - delta
		event["position"] = event["position"] + Vector2(0.0, -32.0 * delta)
		if float(event["life"]) <= 0.0:
			floating_events.remove_at(index)


func _finish(new_result: String) -> void:
	running = false
	result = new_result
