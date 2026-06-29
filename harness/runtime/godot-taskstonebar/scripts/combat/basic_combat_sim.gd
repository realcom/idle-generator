extends RefCounted

const WORLD_SIZE := Vector2(960.0, 160.0)
const PLAYER_X := 150.0
const PLAYER_SPAWN_Y_RATIO := 0.8
const ENEMY_SPAWN_X := 995.0
const ENEMY_SPAWN_Y_RATIO := PLAYER_SPAWN_Y_RATIO
const CONTACT_RANGE := 82.0
const ENEMY_SPACING := 30.0
const ENEMY_SPAWN_DELAY := 0.18
const DAMAGE_DEFENSE_SCALE := 0.22
const CONTACT_DAMAGE_MULTIPLIER := 0.95
const ENEMY_ATTACK_INTERVAL := 1.45
const RANGED_ATTACK_RANGE := 320.0
const BOSS_ATTACK_RANGE := 118.0
const MAX_EVENT_LOG := 10
const WAVE_FORCE_ADVANCE_SECONDS := 14.0
const BOSS_WAVE_FORCE_ADVANCE_SECONDS := 24.0
const BOARD_KEY_WAVE := 601
const BOARD_KEY_WAVE_TRANSITION_PENDING := 603
const BOARD_KEY_WAVE_SPAWNED := 604
const BOARD_KEY_ENEMY_LEVEL := 605
const BOARD_KEY_BOSS_LEVEL := 606
const BOARD_STATE_PLAYING := 2001
const TRIGGER_TICKS_PER_SECOND := 30.0
const SKILL_POINT_ITEM_ID := 200501
const STAT_POINT_ITEM_ID := 200569
const SKILL_POINTS_PER_LEVEL_UP := 1
const STAT_POINTS_PER_LEVEL_UP := 3

var store
var rng := RandomNumberGenerator.new()

var map_id := 500101
var map_def := {}
var wave_plan := []
var wave_index := 0
var wave_elapsed := 0.0
var wave_spawn_serial := 0
var pending_spawns := []
var spawn_timer := 0.0
var board_vars := {}
var board_state := 0
var trigger_return := 0.0
var map_update_timers := {}
var active_wave_trigger := ""
var timeout_wave_reported := -1
var enemies := []
var player := {}
var resources := {
	"gold": 0,
	"exp": 0,
	"pebble": 0,
	"ore": 0,
	"catalyst": 0,
}
var events := []
var fx_events := []
var drop_events := []
var latest_drop := {}
var next_runtime_id := 1
var next_fx_id := 1
var elapsed := 0.0
var kill_count := 0
var skill_cast_count := 0
var player_skill_cast_count := 0
var player_learned_skill_cast_count := 0
var running := false
var result := ""
var attack_timer := 0.0
var learned_skill_timer := 0.0
var run_report := {}
var player_skill_rotation := []
var player_skill_index := 0
var player_learned_skill_rotation := []
var player_learned_skill_index := 0
var configured_player_skill_ids := [
	300101,
]
var configured_player_learned_skills := []
var configured_player_stones := []
var player_stone_loadout := []
var player_stat_bonuses := {}
var progression_state = null


func _init(resource_store = null) -> void:
	store = resource_store
	rng.randomize()


func set_progression_state(state) -> void:
	progression_state = state


func start(new_map_id := 500101) -> void:
	map_id = int(new_map_id)
	map_def = store.get_map(map_id) if store != null else {}
	if map_def.is_empty() and store != null:
		map_def = store.get_main_map()
		map_id = int(map_def.get("id", map_id))

	wave_plan = _build_trigger_wave_metadata(map_def)
	wave_index = 0
	wave_elapsed = 0.0
	wave_spawn_serial = 0
	pending_spawns.clear()
	board_vars = _initial_board_vars(map_def)
	board_state = 0
	trigger_return = 0.0
	map_update_timers.clear()
	active_wave_trigger = ""
	timeout_wave_reported = -1
	enemies.clear()
	events.clear()
	fx_events.clear()
	drop_events.clear()
	latest_drop.clear()
	resources = {"gold": 0, "exp": 0, "pebble": 0, "ore": 0, "catalyst": 0}
	next_runtime_id = 1
	next_fx_id = 1
	elapsed = 0.0
	kill_count = 0
	skill_cast_count = 0
	player_skill_cast_count = 0
	player_learned_skill_cast_count = 0
	result = ""
	run_report.clear()
	_build_player_skill_rotation()
	_build_player_learned_skill_rotation()
	_build_player_stone_loadout()
	player_skill_index = 0
	player_learned_skill_index = 0
	_spawn_player()
	running = true
	attack_timer = 0.25
	learned_skill_timer = 0.18
	_push_event("%s 맵 진입" % str(map_def.get("name", "작업표시줄 동굴")))
	_run_map_start_triggers()


func continue_after_result(farming_mode := false) -> void:
	if result == "defeat":
		start(map_id)
		return
	if result != "clear":
		return
	start(map_id if farming_mode else _next_map_id())


func set_player_skill_ids(skill_ids: Array) -> void:
	configured_player_stones.clear()
	player_stone_loadout.clear()
	configured_player_skill_ids.clear()
	for skill_id in skill_ids:
		var safe_id := int(skill_id)
		if safe_id > 0 and not configured_player_skill_ids.has(safe_id):
			configured_player_skill_ids.append(safe_id)
	if configured_player_skill_ids.is_empty():
		configured_player_skill_ids.append(300101)
	if store != null:
		_build_player_skill_rotation()
		player_skill_index = 0


func set_player_learned_skills(skill_entries: Array) -> void:
	var previous_skill_ids := _player_learned_skill_ids()
	var previous_skill_index := player_learned_skill_index
	var previous_skill_timer := learned_skill_timer
	configured_player_learned_skills.clear()
	for entry in skill_entries:
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		var skill_id := int(entry.get("skill_data_id", entry.get("skillDataId", 0)))
		if skill_id <= 0:
			continue
		configured_player_learned_skills.append((entry as Dictionary).duplicate(true))
	if store != null:
		_build_player_learned_skill_rotation()
		var new_skill_ids := _player_learned_skill_ids()
		if running and previous_skill_ids == new_skill_ids:
			player_learned_skill_index = previous_skill_index
			learned_skill_timer = maxf(0.0, previous_skill_timer)
		else:
			player_learned_skill_index = 0
			learned_skill_timer = 0.05
			if running and not player_learned_skill_rotation.is_empty():
				learned_skill_timer = _player_skill_cooldown(player_learned_skill_rotation[0])


func set_player_stone_loadout(stone_instances: Array) -> void:
	var previous_stone_timers := _stone_cooldown_timers_by_key()
	configured_player_stones.clear()
	configured_player_skill_ids.clear()
	for instance in stone_instances:
		if typeof(instance) != TYPE_DICTIONARY:
			continue
		var tags: Array = instance.get("tags", []) if typeof(instance.get("tags", [])) == TYPE_ARRAY else []
		if not tags.has("StoneWeapon"):
			continue
		var copy: Dictionary = instance.duplicate(true)
		configured_player_stones.append(copy)
		for skill_id in _skill_ids_for_stone(copy):
			if int(skill_id) > 0 and not configured_player_skill_ids.has(int(skill_id)):
				configured_player_skill_ids.append(int(skill_id))
	if configured_player_skill_ids.is_empty():
		configured_player_skill_ids.append(300101)
	if store != null:
		_build_player_skill_rotation()
		_build_player_stone_loadout(previous_stone_timers)
		player_skill_index = 0


func set_player_stat_bonuses(stat_bonuses: Dictionary) -> void:
	player_stat_bonuses.clear()
	for stat_type in stat_bonuses.keys():
		player_stat_bonuses[str(stat_type)] = float(stat_bonuses[stat_type])
	if not player.is_empty():
		_refresh_player_stats_from_loadout()


func step(delta: float) -> void:
	if not running:
		_decay_fx(delta)
		return

	var dt: float = clamp(delta, 0.0, 0.05)
	elapsed += dt
	wave_elapsed += dt
	spawn_timer -= dt
	_spawn_from_pending()
	_update_enemies(dt)
	_update_player_attack(dt)
	_update_enemy_attacks(dt)
	_collect_dead_enemies()
	_run_map_update_triggers(dt)
	_spawn_from_pending()
	_decay_fx(dt)
	_decay_combat_state(dt)

	if float(player.get("hp", 0.0)) <= 0.0:
		_finish("defeat")


func snapshot() -> Dictionary:
	return {
		"running": running,
		"result": result,
		"map_id": map_id,
		"map_name": str(map_def.get("name", "작업표시줄 동굴")),
		"next_map_id": _next_map_id(),
		"elapsed": elapsed,
		"wave": _current_wave_number(),
		"wave_count": wave_plan.size(),
		"wave_elapsed": wave_elapsed,
		"wave_time_limit": _current_wave_time_limit(),
		"wave_trigger": active_wave_trigger,
		"pending_count": pending_spawns.size(),
		"kill_count": kill_count,
		"skill_cast_count": skill_cast_count,
		"player_skill_cast_count": player_skill_cast_count,
		"player_learned_skill_cast_count": player_learned_skill_cast_count,
		"player": player,
		"enemies": enemies,
		"enemy_count": _alive_enemies().size(),
		"resources": resources,
		"events": events,
		"fx_events": fx_events,
		"drop_events": drop_events,
		"latest_drop": latest_drop,
		"world_size": WORLD_SIZE,
		"report": run_report,
		"player_skill_ids": configured_player_skill_ids.duplicate(true),
		"player_learned_skill_ids": _player_learned_skill_ids(),
		"player_stone_count": player_stone_loadout.size(),
		"player_stone_skill_ids": _player_stone_skill_ids(),
		"player_stone_cooldowns": _player_stone_cooldown_entries(),
		"player_stat_bonuses": player_stat_bonuses.duplicate(true),
	}


func _spawn_player() -> void:
	var unit: Dictionary = store.get_player_unit() if store != null else {}
	var player_level := _current_player_level()
	var carried_exp := maxi(0, int(player.get("exp", 0)))
	var carried_total_exp := maxi(carried_exp, int(player.get("total_exp", carried_exp)))
	var required_exp := _player_required_exp(player_level)
	var max_hp := _player_max_hp(unit, player_level)
	player = {
		"id": next_runtime_id,
		"unit_id": int(unit.get("id", 110111)),
		"name": str(unit.get("name", "작업돌지기")),
		"unit_type": str(unit.get("type", "Player")),
		"sprite": str(unit.get("sprite", "")),
		"team": 1,
		"level": player_level,
		"position": Vector2(PLAYER_X, WORLD_SIZE.y * PLAYER_SPAWN_Y_RATIO),
		"hp": max_hp,
		"max_hp": max_hp,
		"attack": _player_attack(unit, player_level),
		"defense": _player_defense(unit, player_level),
		"attack_speed": _player_attack_speed(unit, player_level),
		"loadout_stats": player_stat_bonuses.duplicate(true),
		"exp": carried_exp,
		"total_exp": carried_total_exp,
		"required_exp": required_exp,
	}
	player["exp_ratio"] = _player_exp_ratio()
	next_runtime_id += 1


func _refresh_player_stats_from_loadout() -> void:
	if player.is_empty():
		return
	var unit: Dictionary = store.get_player_unit() if store != null else {}
	var player_level := _current_player_level()
	var old_max_hp := maxf(1.0, float(player.get("max_hp", 1.0)))
	var old_hp := maxf(0.0, float(player.get("hp", old_max_hp)))
	var hp_ratio := clampf(old_hp / old_max_hp, 0.0, 1.0)
	var new_max_hp := _player_max_hp(unit, player_level)
	player["max_hp"] = new_max_hp
	player["hp"] = 0.0 if old_hp <= 0.0 else maxf(1.0, new_max_hp * hp_ratio)
	player["attack"] = _player_attack(unit, player_level)
	player["defense"] = _player_defense(unit, player_level)
	player["attack_speed"] = _player_attack_speed(unit, player_level)
	player["loadout_stats"] = player_stat_bonuses.duplicate(true)
	player["required_exp"] = _player_required_exp(player_level)
	player["exp_ratio"] = _player_exp_ratio()


func _current_player_level() -> int:
	if player.is_empty():
		return maxi(1, int(map_def.get("initLevel", 1)))
	return maxi(1, int(player.get("level", 1)))


func _player_required_exp(level: int) -> int:
	var required_exps = map_def.get("requiredExps", [])
	if typeof(required_exps) != TYPE_ARRAY:
		return 0
	var index := maxi(0, int(level) - 1)
	if index >= required_exps.size():
		return 0
	return maxi(0, int(required_exps[index]))


func _player_exp_ratio() -> float:
	var required_exp := int(player.get("required_exp", _player_required_exp(_current_player_level())))
	if required_exp <= 0:
		return 1.0
	return clampf(float(player.get("exp", 0)) / float(required_exp), 0.0, 1.0)


func _player_max_hp(unit: Dictionary, level: int) -> float:
	var base_hp: float = store.stat_value(unit, "Hp", 520.0, level) if store != null else 520.0
	return maxf(1.0, base_hp + _stat_bonus("Hp"))


func _player_attack(unit: Dictionary, level: int) -> float:
	var base_attack: float = store.stat_value(unit, "Attack", 42.0, level) if store != null else 42.0
	return maxf(1.0, base_attack + _stat_bonus("Attack"))


func _player_defense(unit: Dictionary, level: int) -> float:
	var base_defense: float = store.stat_value(unit, "Defense", 8.0, level) if store != null else 8.0
	return maxf(0.0, base_defense + _stat_bonus("Defense"))


func _player_attack_speed(unit: Dictionary, level: int) -> float:
	var base_speed: float = store.stat_value(unit, "AttackSpeed", 1.0, level) if store != null else 1.0
	var speed_percent := _stat_bonus("AttackSpeedPercent") + _stat_bonus("CooldownPercent")
	return maxf(0.1, base_speed * (1.0 + speed_percent / 100.0))


func _stat_bonus(stat_type: String) -> float:
	return float(player_stat_bonuses.get(stat_type, 0.0))


func _initial_board_vars(source_map: Dictionary) -> Dictionary:
	var vars := {
		BOARD_KEY_WAVE: 1.0,
		BOARD_KEY_WAVE_TRANSITION_PENDING: 0.0,
		BOARD_KEY_WAVE_SPAWNED: 0.0,
		BOARD_KEY_ENEMY_LEVEL: float(maxi(1, int(source_map.get("initLevel", 1)))),
		BOARD_KEY_BOSS_LEVEL: float(maxi(1, int(source_map.get("initLevel", 1)))),
	}
	for variable in source_map.get("initVariables", []):
		if typeof(variable) != TYPE_DICTIONARY:
			continue
		var key := int(variable.get("callerKey", 0))
		if key != 0:
			vars[key] = float(variable.get("value", 0.0))
	return vars


func _run_map_start_triggers() -> void:
	var ran := false
	for trigger_name in _map_trigger_names_by_type("OnStart"):
		ran = true
		_run_trigger_by_name(trigger_name)
	if not ran:
		_push_event("맵 시작 트리거 없음")


func _run_map_update_triggers(delta: float) -> void:
	for trigger_name in _map_trigger_names_by_type("OnUpdate"):
		var trigger: Dictionary = store.get_trigger(trigger_name) if store != null else {}
		if trigger.is_empty():
			continue
		var period := maxf(0.0, float(trigger.get("period", 0.0)) / TRIGGER_TICKS_PER_SECOND)
		if period <= 0.0:
			_run_trigger(trigger_name, trigger)
			continue
		var elapsed_for_trigger := float(map_update_timers.get(trigger_name, 0.0)) + delta
		if elapsed_for_trigger + 0.0001 < period:
			map_update_timers[trigger_name] = elapsed_for_trigger
			continue
		map_update_timers[trigger_name] = fmod(elapsed_for_trigger, period)
		_run_trigger(trigger_name, trigger)


func _map_trigger_names_by_type(trigger_type: String) -> Array:
	var names := []
	var trigger_names = map_def.get("triggers", [])
	if typeof(trigger_names) != TYPE_ARRAY:
		return names
	for raw_name in trigger_names:
		var name := str(raw_name)
		var trigger: Dictionary = store.get_trigger(name) if store != null else {}
		var current_type := str(trigger.get("type", "OnStart"))
		if current_type == trigger_type:
			names.append(name)
	return names


func _run_trigger_by_name(trigger_name: String, depth := 0) -> void:
	if depth > 12 or store == null:
		return
	var trigger: Dictionary = store.get_trigger(trigger_name)
	if trigger.is_empty():
		_push_event("트리거 누락: %s" % trigger_name)
		return
	_run_trigger(trigger_name, trigger, depth)


func _run_trigger(trigger_name: String, trigger: Dictionary, depth := 0) -> void:
	if str(trigger.get("type", "OnStart")) == "OnStart" and trigger_name.contains("WAVE"):
		active_wave_trigger = trigger_name
	_run_trigger_statements(trigger.get("statements", []), depth)


func _run_trigger_statements(statements: Array, depth := 0) -> void:
	for statement in statements:
		if typeof(statement) != TYPE_DICTIONARY:
			continue
		if statement.has("assignment"):
			_run_trigger_assignment(statement["assignment"])
		elif statement.has("call"):
			_run_trigger_call(statement["call"], depth)
		elif statement.has("condition"):
			var condition = statement["condition"]
			if typeof(condition) != TYPE_DICTIONARY:
				continue
			if _truthy(_eval_trigger_postfix(condition.get("expression", {}).get("postfix", []))):
				_run_trigger_statements(condition.get("statements", []), depth)
			else:
				_run_trigger_statements(condition.get("elseStatements", []), depth)


func _run_trigger_assignment(assignment: Dictionary) -> void:
	var variable = assignment.get("variable", {})
	if typeof(variable) != TYPE_DICTIONARY:
		return
	if variable.has("boardKey"):
		_set_board_var(int(variable.get("boardKey", 0)), _eval_trigger_postfix(assignment.get("expression", {}).get("postfix", [])))


func _run_trigger_call(call: Dictionary, depth := 0) -> void:
	var method = call.get("method", {})
	if typeof(method) != TYPE_DICTIONARY:
		return
	if method.has("runTrigger"):
		var run_trigger = method["runTrigger"]
		if typeof(run_trigger) == TYPE_DICTIONARY:
			_run_trigger_by_name(str(run_trigger.get("name", "")), depth + 1)
		return

	var board_method = method.get("boardMethod", {})
	if typeof(board_method) != TYPE_DICTIONARY:
		return
	var method_type := str(board_method.get("type", ""))
	var params := _trigger_call_params(call.get("assignments", []))
	match method_type:
		"AddUnit":
			_queue_trigger_add_unit(params)
		"GetUnitCountByTeam":
			trigger_return = float(_board_unit_count_by_team(int(params.get("Team", 4))))
		"SetBoardState":
			board_state = int(params.get("BoardState", 0))
		"SendWaveStartedEvent":
			_on_trigger_wave_started()
		"SendWaveQueuedEvent":
			pass
		"EndGame":
			_finish("clear" if int(params.get("Team", 1)) == 1 else "defeat")


func _trigger_call_params(assignments: Array) -> Dictionary:
	var params := {}
	for assignment in assignments:
		if typeof(assignment) != TYPE_DICTIONARY:
			continue
		var variable = assignment.get("variable", {})
		var parameter = variable.get("parameter", {}) if typeof(variable) == TYPE_DICTIONARY else {}
		if typeof(parameter) != TYPE_DICTIONARY:
			continue
		var parameter_type := str(parameter.get("type", ""))
		if parameter_type == "":
			continue
		params[parameter_type] = _eval_trigger_postfix(assignment.get("expression", {}).get("postfix", []))
	return params


func _queue_trigger_add_unit(params: Dictionary) -> void:
	var unit_id := int(params.get("UnitDataId", 0))
	var count := maxi(1, int(params.get("Count", 1)))
	if unit_id <= 0:
		return
	var entry := {
		"unit_id": unit_id,
		"level": maxi(1, int(round(float(params.get("Level", board_vars.get(BOARD_KEY_ENEMY_LEVEL, 1.0)))))),
		"team": int(params.get("Team", 4)),
		"location_id": int(params.get("LocationId", 0)),
		"position_x": float(params.get("PositionX", INF)),
		"position_y": float(params.get("PositionY", INF)),
		"trigger_name": active_wave_trigger,
	}
	for _i in range(count):
		pending_spawns.append(entry.duplicate(true))


func _on_trigger_wave_started() -> void:
	wave_elapsed = 0.0
	wave_spawn_serial = 0
	timeout_wave_reported = -1
	var wave_number := _current_wave_number()
	wave_index = max(0, wave_number - 1)
	_push_event("Wave %d 시작" % wave_number)


func _set_board_var(key: int, value: float) -> void:
	var old_wave := _current_wave_number()
	board_vars[key] = value
	if key == BOARD_KEY_WAVE:
		var new_wave := maxi(1, int(round(value)))
		wave_index = max(0, new_wave - 1)
		if new_wave != old_wave:
			wave_elapsed = 0.0
			wave_spawn_serial = 0
			timeout_wave_reported = -1


func _board_unit_count_by_team(team: int) -> int:
	if _should_force_wave_timeout(team):
		var wave_number := _current_wave_number()
		if timeout_wave_reported != wave_number:
			timeout_wave_reported = wave_number
			_push_event("Wave %d 시간 초과" % wave_number)
		return 0
	var total := 0
	for enemy in enemies:
		if typeof(enemy) == TYPE_DICTIONARY and bool(enemy.get("alive", true)) and int(enemy.get("team", 4)) == team:
			total += 1
	for spawn in pending_spawns:
		if typeof(spawn) == TYPE_DICTIONARY and int(spawn.get("team", 4)) == team:
			total += 1
	return total


func _should_force_wave_timeout(team: int) -> bool:
	if team != 4:
		return false
	if _current_wave_number() >= max(1, wave_plan.size()):
		return false
	if wave_elapsed < _current_wave_time_limit():
		return false
	return not _alive_enemies().is_empty() or not pending_spawns.is_empty()


func _spawn_from_pending() -> void:
	if pending_spawns.is_empty() or spawn_timer > 0.0:
		return
	var entry: Dictionary = pending_spawns.pop_front()
	_spawn_enemy(entry)
	spawn_timer = ENEMY_SPAWN_DELAY


func _spawn_enemy(entry: Dictionary) -> void:
	var unit_id := int(entry.get("unit_id", 0))
	var level := int(entry.get("level", 1))
	var unit: Dictionary = store.get_unit(unit_id) if store != null else {}
	var tags: Array = unit.get("tags", []) if typeof(unit.get("tags", [])) == TYPE_ARRAY else []
	var unit_type := _unit_type(unit)
	var skill_spec := _skill_spec_for_unit(unit)
	var skill_phases := _skill_phase_specs_for_unit(unit)
	var skill_id := int(skill_spec.get("skill_id", 0))
	if not skill_phases.is_empty():
		skill_id = int(_phase_for_percent(skill_phases, 100.0).get("skill_id", skill_id))
	var skill: Dictionary = store.get_skill(skill_id) if store != null and skill_id > 0 else {}
	var spawn_slot := wave_spawn_serial
	wave_spawn_serial += 1
	var spawn_position := _spawn_position_for_entry(entry, spawn_slot)
	var max_hp: float = store.stat_value(unit, "Hp", 80.0, level) if store != null else 80.0
	var attack_speed: float = store.stat_value(unit, "AttackSpeed", 1.0, level) if store != null else 1.0
	var attack_range := _enemy_attack_range(unit_type, tags)
	var attack_interval := float(skill_spec.get("period", 0.0))
	if attack_interval <= 0.0:
		attack_interval = maxf(0.42, ENEMY_ATTACK_INTERVAL / maxf(0.25, attack_speed))
	var enemy := {
		"id": next_runtime_id,
		"unit_id": unit_id,
		"name": str(unit.get("name", "광맥 몬스터")),
		"unit_type": unit_type,
		"tags": tags,
		"sprite": str(unit.get("sprite", "")),
		"team": int(entry.get("team", 4)),
		"level": level,
		"position": spawn_position,
		"hp": max_hp,
		"max_hp": max_hp,
		"attack": store.stat_value(unit, "Attack", 8.0, level) if store != null else 8.0,
		"defense": store.stat_value(unit, "Defense", 2.0, level) if store != null else 2.0,
		"move_speed": store.stat_value(unit, "MoveSpeed", 2.5, level) if store != null else 2.5,
		"attack_range": attack_range,
		"attack_interval": maxf(0.42, attack_interval),
		"damage_multiplier": _enemy_damage_multiplier(unit_type, tags),
		"skill_id": skill_id,
		"skill_name": str(skill.get("name", "")),
		"skill_damage_ratio": store.skill_damage_total_ratio(skill, 1) if store != null and not skill.is_empty() else 1.0,
		"skill_source_trigger": str(skill_spec.get("trigger_name", "")),
		"skill_phases": skill_phases,
		"skill_phase": str(_phase_for_percent(skill_phases, 100.0).get("phase_name", "")),
		"attack_flash": 0.0,
		"attack_timer": maxf(0.42, attack_interval),
		"alive": true,
	}
	next_runtime_id += 1
	enemies.append(enemy)
	_fx("spawn", {
		"target_id": int(enemy.get("id", 0)),
		"target_name": str(enemy.get("name", "몬스터")),
		"position": enemy.get("position", spawn_position),
		"fx_key": _spawn_fx_key(unit_type, tags),
		"size": _spawn_fx_size(unit_type, tags),
		"ttl": 0.72,
	})


func _update_enemies(delta: float) -> void:
	var target_pos: Vector2 = player.get("position", Vector2.ZERO)
	for enemy in enemies:
		if typeof(enemy) != TYPE_DICTIONARY or not bool(enemy.get("alive", true)):
			continue
		var pos: Vector2 = enemy.get("position", Vector2.ZERO)
		var distance := pos.distance_to(target_pos)
		var attack_range := float(enemy.get("attack_range", CONTACT_RANGE))
		if distance > attack_range:
			var dir := (target_pos - pos).normalized()
			pos += dir * float(enemy.get("move_speed", 2.5)) * 42.0 * delta
			enemy["position"] = pos


func _update_player_attack(delta: float) -> void:
	if not player_stone_loadout.is_empty():
		_update_player_stone_attacks(delta)
		_update_player_learned_skill_attacks(delta)
		return
	if not player_learned_skill_rotation.is_empty():
		_update_player_learned_skill_attacks(delta)
		return

	attack_timer -= delta
	if attack_timer > 0.0:
		return

	var target: Dictionary = _front_enemy()
	if target.is_empty():
		attack_timer = 0.12
		return

	var attack_speed: float = maxf(0.25, float(player.get("attack_speed", 1.0)))
	var skill: Dictionary = _next_player_skill()
	var skill_id := int(skill.get("id", 0))
	var cooldown: float = maxf(0.25, float(skill.get("cooldown", 1.2)) / attack_speed)
	attack_timer = cooldown

	_cast_player_skill(skill, target, {})


func _update_player_stone_attacks(delta: float) -> void:
	for stone in player_stone_loadout:
		if typeof(stone) != TYPE_DICTIONARY:
			continue
		stone["cooldown_timer"] = float(stone.get("cooldown_timer", 0.0)) - delta
		if float(stone.get("cooldown_timer", 0.0)) > 0.0:
			continue
		var skill: Dictionary = stone.get("skill", {}) if typeof(stone.get("skill", {})) == TYPE_DICTIONARY else {}
		var target := _player_skill_primary_target(skill)
		if target.is_empty():
			stone["cooldown_timer"] = 0.05
			continue
		if _cast_player_skill(skill, target, stone):
			stone["cooldown_timer"] = _player_skill_cooldown(skill)
		else:
			stone["cooldown_timer"] = 0.05


func _update_player_learned_skill_attacks(delta: float) -> void:
	if player_learned_skill_rotation.is_empty():
		return
	learned_skill_timer -= delta
	if learned_skill_timer > 0.0:
		return
	var skill: Dictionary = _next_player_learned_skill()
	var target := _player_skill_primary_target(skill)
	if target.is_empty():
		learned_skill_timer = 0.12
		return
	if _cast_player_skill(skill, target, {}, true):
		player_learned_skill_cast_count += 1
		learned_skill_timer = _player_skill_cooldown(skill)
	else:
		learned_skill_timer = 0.05


func _cast_player_skill(skill: Dictionary, primary_target: Dictionary, source_stone: Dictionary = {}, is_learned_skill := false) -> bool:
	if skill.is_empty() or primary_target.is_empty():
		return false
	var skill_id := int(skill.get("id", 0))
	var skill_name := str(skill.get("name", "돌팔매"))
	var targets := _player_skill_targets(skill, primary_target)
	if targets.is_empty():
		return false
	var damage_ratio: float = float(skill.get("runtime_damage_ratio", 0.0))
	if damage_ratio <= 0.0:
		damage_ratio = store.skill_damage_total_ratio(skill, int(skill.get("runtime_skill_level", 1))) if store != null else 1.0
	var raw_damage: float = float(player.get("attack", 1.0)) * damage_ratio
	var total_damage := 0.0
	for target in targets:
		if typeof(target) != TYPE_DICTIONARY or not bool(target.get("alive", true)):
			continue
		var damage: float = maxf(1.0, raw_damage - float(target.get("defense", 0.0)) * DAMAGE_DEFENSE_SCALE)
		target["hp"] = float(target.get("hp", 0.0)) - damage
		target["hit_flash"] = 0.18
		total_damage += damage
	if total_damage <= 0.0:
		return false
	player["attack_flash"] = 0.22
	if skill_id > 0:
		skill_cast_count += 1
		player_skill_cast_count += 1
	var stone_name := str(source_stone.get("name", ""))
	var prefix := "%s: " % stone_name if stone_name != "" else ""
	_push_event("%s%s! x%d -%d" % [prefix, skill_name, targets.size(), int(round(total_damage))])
	var fx_ttl := 1.05 if skill_id == 300101 else 0.82
	if is_learned_skill:
		fx_ttl = maxf(fx_ttl, 1.18)
	_fx("attack", {
		"source_id": int(player.get("id", 0)),
		"source_name": str(player.get("name", "작업돌지기")),
		"source_position": player.get("position", Vector2.ZERO),
		"source_stone_instance_id": int(source_stone.get("instance_id", 0)),
		"source_stone_item_id": int(source_stone.get("item_data_id", 0)),
		"source_stone_name": stone_name,
		"target_id": int(primary_target.get("id", 0)),
		"target_name": str(primary_target.get("name", "몬스터")),
		"target_position": primary_target.get("position", Vector2(805.0, 80.0)),
		"skill_id": skill_id,
		"skill_name": skill_name,
		"skill_level": int(skill.get("runtime_skill_level", 1)),
		"skill_item_data_id": int(skill.get("runtime_skill_item_data_id", 0)),
		"is_learned_skill": is_learned_skill,
		"is_stone_skill": not source_stone.is_empty(),
		"amount": total_damage,
		"ttl": fx_ttl,
	})
	return true


func _build_player_skill_rotation() -> void:
	player_skill_rotation.clear()
	if store == null:
		return
	var skill_ids := configured_player_skill_ids.duplicate()
	if skill_ids.is_empty():
		skill_ids.append(300101)
	for skill_id in skill_ids:
		var skill: Dictionary = store.get_skill(int(skill_id))
		if skill.is_empty():
			continue
		player_skill_rotation.append(skill)


func _build_player_learned_skill_rotation() -> void:
	player_learned_skill_rotation.clear()
	if store == null:
		return
	for entry in configured_player_learned_skills:
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		var skill_id := int(entry.get("skill_data_id", entry.get("skillDataId", 0)))
		var skill: Dictionary = store.get_skill(skill_id)
		if skill.is_empty():
			continue
		var runtime_skill := skill.duplicate(true)
		runtime_skill["runtime_skill_item_data_id"] = int(entry.get("skill_item_data_id", entry.get("id", 0)))
		runtime_skill["runtime_skill_level"] = maxi(1, int(entry.get("level", 1)))
		var effect: Dictionary = entry.get("effect", {}) if typeof(entry.get("effect", {})) == TYPE_DICTIONARY else {}
		var damage_ratio := float(effect.get("damage_ratio", 0.0))
		if damage_ratio > 0.0:
			runtime_skill["runtime_damage_ratio"] = damage_ratio
		player_learned_skill_rotation.append(runtime_skill)


func _build_player_stone_loadout(previous_timers: Dictionary = {}) -> void:
	player_stone_loadout.clear()
	if store == null:
		return
	for instance in configured_player_stones:
		if typeof(instance) != TYPE_DICTIONARY:
			continue
		var skill_ids := _skill_ids_for_stone(instance)
		if skill_ids.is_empty():
			continue
		for raw_skill_id in skill_ids:
			var skill_id := int(raw_skill_id)
			var skill: Dictionary = store.get_skill(skill_id)
			if skill.is_empty():
				continue
			var loadout_index := player_stone_loadout.size()
			var timer_key := _stone_loadout_timer_key(int(instance.get("instance_id", 0)), skill_id)
			var cooldown_timer := minf(0.24, 0.045 * float(loadout_index))
			if running:
				cooldown_timer = _player_skill_cooldown(skill)
				if previous_timers.has(timer_key):
					cooldown_timer = maxf(0.0, float(previous_timers[timer_key]))
			player_stone_loadout.append({
				"instance_id": int(instance.get("instance_id", 0)),
				"item_data_id": int(instance.get("item_data_id", 0)),
				"name": str(instance.get("name", "돌")),
				"stage": int(instance.get("stage", 1)),
				"skill_id": skill_id,
				"skill": skill,
				"cooldown_timer": cooldown_timer,
			})


func _stone_cooldown_timers_by_key() -> Dictionary:
	var result := {}
	for stone in player_stone_loadout:
		if typeof(stone) != TYPE_DICTIONARY:
			continue
		var key := _stone_loadout_timer_key(int(stone.get("instance_id", 0)), int(stone.get("skill_id", 0)))
		result[key] = float(stone.get("cooldown_timer", 0.0))
	return result


func _stone_loadout_timer_key(instance_id: int, skill_id: int) -> String:
	return "%d:%d" % [int(instance_id), int(skill_id)]


func _skill_ids_for_stone(stone: Dictionary) -> Array:
	var result := []
	var skill_ids = stone.get("equip_skill_ids", [])
	if typeof(skill_ids) != TYPE_ARRAY or skill_ids.is_empty():
		skill_ids = stone.get("equipSkillDataIds", [])
	if typeof(skill_ids) != TYPE_ARRAY:
		return result
	for raw_id in skill_ids:
		var skill_id := int(raw_id)
		if skill_id > 0:
			result.append(skill_id)
	return result


func _player_stone_skill_ids() -> Array:
	var result := []
	for stone in player_stone_loadout:
		if typeof(stone) == TYPE_DICTIONARY:
			result.append(int(stone.get("skill_id", 0)))
	return result


func _player_stone_cooldown_entries() -> Array:
	var result := []
	for stone in player_stone_loadout:
		if typeof(stone) != TYPE_DICTIONARY:
			continue
		var skill: Dictionary = stone.get("skill", {}) if typeof(stone.get("skill", {})) == TYPE_DICTIONARY else {}
		var cooldown_total := _player_skill_cooldown(skill)
		var cooldown_remaining := clampf(float(stone.get("cooldown_timer", 0.0)), 0.0, cooldown_total)
		var ready_ratio := 1.0
		if cooldown_total > 0.0:
			ready_ratio = clampf(1.0 - cooldown_remaining / cooldown_total, 0.0, 1.0)
		result.append({
			"instance_id": int(stone.get("instance_id", 0)),
			"item_data_id": int(stone.get("item_data_id", 0)),
			"skill_id": int(stone.get("skill_id", 0)),
			"cooldown_ratio": ready_ratio,
			"cooldown_remaining": cooldown_remaining,
			"cooldown_total": cooldown_total,
		})
	return result


func _player_learned_skill_ids() -> Array:
	var result := []
	for skill in player_learned_skill_rotation:
		if typeof(skill) == TYPE_DICTIONARY:
			var skill_id := int(skill.get("id", 0))
			if skill_id > 0:
				result.append(skill_id)
	return result


func _next_player_skill() -> Dictionary:
	if player_skill_rotation.is_empty():
		return store.first_skill() if store != null else {}
	var index := player_skill_index % player_skill_rotation.size()
	player_skill_index = (player_skill_index + 1) % player_skill_rotation.size()
	var skill = player_skill_rotation[index]
	return skill if typeof(skill) == TYPE_DICTIONARY else {}


func _next_player_learned_skill() -> Dictionary:
	if player_learned_skill_rotation.is_empty():
		return {}
	var index := player_learned_skill_index % player_learned_skill_rotation.size()
	player_learned_skill_index = (player_learned_skill_index + 1) % player_learned_skill_rotation.size()
	var skill = player_learned_skill_rotation[index]
	return skill if typeof(skill) == TYPE_DICTIONARY else {}


func _player_skill_cooldown(skill: Dictionary) -> float:
	var attack_speed: float = maxf(0.25, float(player.get("attack_speed", 1.0)))
	return maxf(0.25, float(skill.get("cooldown", 1.2)) / attack_speed)


func _player_skill_primary_target(skill: Dictionary) -> Dictionary:
	var alive := _alive_enemies()
	if alive.is_empty():
		return {}
	return _best_player_skill_target(alive, str(skill.get("targetRefreshType", "Nearest")))


func _player_skill_targets(skill: Dictionary, primary_target: Dictionary) -> Array:
	var result := []
	if primary_target.is_empty() or not bool(primary_target.get("alive", true)):
		return result
	result.append(primary_target)
	var max_targets := maxi(1, _skill_max_hit_count(skill))
	if max_targets <= 1:
		return result
	var candidates := _alive_enemies()
	var mode := str(skill.get("targetRefreshType", "Nearest"))
	while result.size() < max_targets:
		var remaining := []
		for enemy in candidates:
			if typeof(enemy) == TYPE_DICTIONARY and not _has_enemy_id(result, int(enemy.get("id", 0))):
				remaining.append(enemy)
		if remaining.is_empty():
			break
		var target := _best_player_skill_target(remaining, mode)
		if target.is_empty():
			break
		result.append(target)
	return result


func _skill_max_hit_count(skill: Dictionary) -> int:
	var max_hit := 1
	for timeline in skill.get("timelines", []):
		if typeof(timeline) != TYPE_DICTIONARY:
			continue
		var hit = timeline.get("hit", {})
		if typeof(hit) != TYPE_DICTIONARY:
			continue
		max_hit = maxi(max_hit, int(hit.get("maxHit", 1)))
	return max_hit


func _best_player_skill_target(candidates: Array, mode: String) -> Dictionary:
	if candidates.is_empty():
		return {}
	if mode == "Random":
		return candidates[rng.randi_range(0, candidates.size() - 1)] if candidates.size() > 1 else candidates[0]
	var best := {}
	var player_pos: Vector2 = player.get("position", Vector2.ZERO)
	for enemy in candidates:
		if typeof(enemy) != TYPE_DICTIONARY:
			continue
		if best.is_empty():
			best = enemy
			continue
		if mode == "HighestHp":
			if float(enemy.get("hp", 0.0)) > float(best.get("hp", 0.0)):
				best = enemy
		else:
			var enemy_distance := player_pos.distance_to(enemy.get("position", Vector2.ZERO))
			var best_distance := player_pos.distance_to(best.get("position", Vector2.ZERO))
			if enemy_distance < best_distance:
				best = enemy
	return best


func _has_enemy_id(enemies_to_check: Array, enemy_id: int) -> bool:
	for enemy in enemies_to_check:
		if typeof(enemy) == TYPE_DICTIONARY and int(enemy.get("id", 0)) == int(enemy_id):
			return true
	return false


func _update_enemy_attacks(delta: float) -> void:
	var player_pos: Vector2 = player.get("position", Vector2.ZERO)
	for enemy in enemies:
		if typeof(enemy) != TYPE_DICTIONARY or not bool(enemy.get("alive", true)):
			continue
		var pos: Vector2 = enemy.get("position", Vector2.ZERO)
		var distance: float = pos.distance_to(player_pos)
		if distance > float(enemy.get("attack_range", CONTACT_RANGE)) + 8.0:
			continue
		enemy["attack_timer"] = float(enemy.get("attack_timer", 0.0)) - delta
		if float(enemy.get("attack_timer", 0.0)) > 0.0:
			continue
		enemy["attack_timer"] = float(enemy.get("attack_interval", ENEMY_ATTACK_INTERVAL))
		var raw_damage: float = maxf(1.0, float(enemy.get("attack", 1.0)) - float(player.get("defense", 0.0)) * DAMAGE_DEFENSE_SCALE)
		var skill_info := _current_enemy_skill(enemy)
		var skill_id := int(skill_info.get("skill_id", 0))
		var is_skill := skill_id > 0
		var damage_ratio := float(skill_info.get("damage_ratio", 1.0)) if is_skill else 1.0
		var damage: float = maxf(1.0, raw_damage * damage_ratio * float(enemy.get("damage_multiplier", CONTACT_DAMAGE_MULTIPLIER)))
		player["hp"] = float(player.get("hp", 0.0)) - damage
		player["hit_flash"] = 0.18
		enemy["attack_flash"] = 0.24
		if is_skill:
			skill_cast_count += 1
			var phase_name := str(skill_info.get("phase_name", ""))
			if phase_name != "" and phase_name != str(enemy.get("skill_phase", "")):
				enemy["skill_phase"] = phase_name
				_push_event("%s: %s" % [str(enemy.get("name", "몬스터")), phase_name])
			enemy["skill_id"] = skill_id
			enemy["skill_name"] = str(skill_info.get("skill_name", "스킬"))
			enemy["skill_damage_ratio"] = damage_ratio
			_push_event("%s: %s" % [str(enemy.get("name", "몬스터")), str(skill_info.get("skill_name", "스킬"))])
			_fx("enemy_skill", {
				"source_id": int(enemy.get("id", 0)),
				"source_name": str(enemy.get("name", "몬스터")),
				"source_position": enemy.get("position", Vector2(805.0, 80.0)),
				"target_position": player.get("position", Vector2.ZERO),
				"skill_id": skill_id,
				"skill_name": str(skill_info.get("skill_name", "스킬")),
				"amount": damage,
				"ttl": 0.92,
			})
		else:
			_push_event("%s 공격 -%d" % [str(enemy.get("name", "몬스터")), int(round(damage))])
			_fx("hit_player", {
				"source_id": int(enemy.get("id", 0)),
				"source_name": str(enemy.get("name", "몬스터")),
				"source_position": enemy.get("position", Vector2(805.0, 80.0)),
				"target_position": player.get("position", Vector2.ZERO),
				"amount": damage,
				"ttl": 0.72,
			})


func _collect_dead_enemies() -> void:
	var removed_any := false
	for enemy in enemies:
		if typeof(enemy) != TYPE_DICTIONARY or not bool(enemy.get("alive", true)):
			continue
		if float(enemy.get("hp", 0.0)) > 0.0:
			continue
		enemy["alive"] = false
		removed_any = true
		kill_count += 1
		var unit: Dictionary = {}
		if store != null:
			unit = store.get_unit(int(enemy.get("unit_id", 0)))
		_apply_unit_rewards(unit, enemy)
		_push_event("%s 처치" % str(enemy.get("name", "몬스터")))
		_fx("kill", {
			"target_id": int(enemy.get("id", 0)),
			"target_name": str(enemy.get("name", "몬스터")),
			"position": enemy.get("position", Vector2(805.0, 80.0)),
			"ttl": 1.0,
		})
	if removed_any:
		_compact_alive_enemies()


func _compact_alive_enemies() -> void:
	var alive_enemies: Array = []
	for enemy in enemies:
		if typeof(enemy) == TYPE_DICTIONARY and bool(enemy.get("alive", true)):
			alive_enemies.append(enemy)
	enemies = alive_enemies


func _apply_unit_rewards(unit: Dictionary, reward_origin := {}) -> void:
	for group in unit.get("dropAddItemGroups", []):
		if typeof(group) != TYPE_DICTIONARY:
			continue
		var prob := float(group.get("probPercent", 100.0))
		if prob < 100.0 and rng.randf() * 100.0 > prob:
			continue
		var add_items = group.get("addItems", [])
		if typeof(add_items) != TYPE_ARRAY:
			continue
		if bool(group.get("shouldAddAll", false)):
			for add_item in add_items:
				_add_reward_item(add_item, reward_origin)
		else:
			_add_reward_item(_pick_weighted_item(add_items), reward_origin)


func _pick_weighted_item(add_items: Array) -> Dictionary:
	var total := 0.0
	for add_item in add_items:
		if typeof(add_item) == TYPE_DICTIONARY:
			total += float(add_item.get("weight", 1.0))
	var roll := rng.randf() * maxf(1.0, total)
	var cursor := 0.0
	for add_item in add_items:
		if typeof(add_item) != TYPE_DICTIONARY:
			continue
		cursor += float(add_item.get("weight", 1.0))
		if roll <= cursor:
			return add_item
	return add_items[0] if add_items.size() > 0 and typeof(add_items[0]) == TYPE_DICTIONARY else {}


func _add_reward_item(add_item, reward_origin := {}) -> void:
	if typeof(add_item) != TYPE_DICTIONARY:
		return
	var exp_amount := _reward_exp_amount(add_item)
	if exp_amount > 0:
		_grant_player_exp(exp_amount)
		return
	var item_id := int(add_item.get("itemDataId", 0))
	var count := int(add_item.get("count", 0))
	if count <= 0:
		count = rng.randi_range(int(add_item.get("minCount", 1)), int(add_item.get("maxCount", 1)))
	var item: Dictionary = store.get_item(item_id) if store != null else {}
	if _is_instance_drop_item(item):
		for _i in range(count):
			if progression_state == null:
				break
			var added: Dictionary = progression_state.add_item_instance(item_id)
			if bool(added.get("ok", false)):
				_push_instance_drop_event(added.get("instance", {}), "instance")
		return
	match item_id:
		5:
			resources["gold"] = int(resources.get("gold", 0)) + count
		6:
			resources["exp"] = int(resources.get("exp", 0)) + count
		200101:
			resources["pebble"] = int(resources.get("pebble", 0)) + count
		200102:
			resources["ore"] = int(resources.get("ore", 0)) + count
		200103:
			resources["catalyst"] = int(resources.get("catalyst", 0)) + count
	if progression_state != null:
		progression_state.add_material(item_id, count)
	_push_drop_event(item_id, count, reward_origin)


func _reward_exp_amount(add_item: Dictionary) -> int:
	var exp_amount := int(add_item.get("exp", 0))
	if exp_amount <= 0 and (add_item.has("minExp") or add_item.has("maxExp")):
		exp_amount = rng.randi_range(int(add_item.get("minExp", 0)), int(add_item.get("maxExp", 0)))
	return maxi(0, exp_amount)


func _grant_player_exp(amount: int) -> void:
	var gained := maxi(0, int(amount))
	if gained <= 0:
		return
	resources["exp"] = int(resources.get("exp", 0)) + gained
	if player.is_empty():
		return
	var level := _current_player_level()
	var exp := maxi(0, int(player.get("exp", 0))) + gained
	var level_ups := 0
	while true:
		var required_exp := _player_required_exp(level)
		if required_exp <= 0 or exp < required_exp:
			break
		exp -= required_exp
		level += 1
		level_ups += 1
	player["level"] = level
	player["exp"] = exp
	player["total_exp"] = maxi(0, int(player.get("total_exp", 0))) + gained
	player["required_exp"] = _player_required_exp(level)
	player["exp_ratio"] = _player_exp_ratio()
	if level_ups > 0:
		_grant_level_up_points(level_ups)
		_refresh_player_stats_from_loadout()
		_push_event("Lv.%d 달성" % level)
	else:
		_push_event("+EXP %d" % gained)


func _grant_level_up_points(level_ups: int) -> void:
	var safe_level_ups := maxi(0, int(level_ups))
	if safe_level_ups <= 0 or progression_state == null:
		return
	progression_state.add_material(SKILL_POINT_ITEM_ID, safe_level_ups * SKILL_POINTS_PER_LEVEL_UP)
	progression_state.add_material(STAT_POINT_ITEM_ID, safe_level_ups * STAT_POINTS_PER_LEVEL_UP)


func _finish(new_result: String) -> void:
	if not running and result != "":
		return
	running = false
	result = new_result
	run_report = {
		"result": result,
		"map_id": map_id,
		"map_name": str(map_def.get("name", "")),
		"next_map_id": _next_map_id(),
		"elapsed": elapsed,
		"kills": kill_count,
		"skill_casts": skill_cast_count,
		"player_skill_casts": player_skill_cast_count,
		"resources": resources.duplicate(true),
	}
	_push_event("전투 종료: %s" % result)


func _skill_spec_for_unit(unit: Dictionary) -> Dictionary:
	for trigger_name in unit.get("triggers", []):
		var trigger: Dictionary = store.get_trigger(str(trigger_name)) if store != null else {}
		if trigger.is_empty():
			continue
		var skill_id := _extract_skill_id_from_trigger(trigger)
		if skill_id <= 0:
			continue
		var period: float = float(trigger.get("period", 0.0)) / 30.0
		return {"skill_id": skill_id, "period": period, "trigger_name": str(trigger_name)}
	return {}


func _skill_phase_specs_for_unit(unit: Dictionary) -> Array:
	var tags: Array = unit.get("tags", []) if typeof(unit.get("tags", [])) == TYPE_ARRAY else []
	if str(unit.get("type", "")) != "Boss" and not tags.has("GiantBoss"):
		return []

	var phases := []
	for trigger_name in unit.get("triggers", []):
		var trigger: Dictionary = store.get_trigger(str(trigger_name)) if store != null else {}
		if trigger.is_empty():
			continue
		phases.append_array(_extract_skill_phases_from_statements(trigger.get("statements", [])))

	var sorted := _sort_skill_phases(phases)
	if sorted.size() < 2:
		return []
	for i in range(sorted.size()):
		sorted[i]["phase_name"] = "Phase %d" % int(sorted.size() - i)
	return sorted


func _extract_skill_phases_from_statements(statements: Array) -> Array:
	var phases := []
	for statement in statements:
		if typeof(statement) != TYPE_DICTIONARY:
			continue
		if not statement.has("condition"):
			continue
		var condition = statement["condition"]
		if typeof(condition) != TYPE_DICTIONARY:
			continue
		var max_hp_percent := _hp_percent_upper_bound(condition.get("expression", {}))
		var skill_id := _extract_skill_id_from_statements(condition.get("statements", []))
		if max_hp_percent > 0.0 and skill_id > 0:
			phases.append({"max_hp_percent": max_hp_percent, "skill_id": skill_id})
		phases.append_array(_extract_skill_phases_from_statements(condition.get("statements", [])))
		phases.append_array(_extract_skill_phases_from_statements(condition.get("elseStatements", [])))
	return phases


func _hp_percent_upper_bound(expression: Dictionary) -> float:
	var postfix = expression.get("postfix", []) if typeof(expression) == TYPE_DICTIONARY else []
	var has_return := false
	var has_upper_bound := false
	var has_lower_bound := false
	var max_constant := -1.0
	for node in postfix:
		if typeof(node) != TYPE_DICTIONARY:
			continue
		if node.has("operator"):
			var operator_type := str(node["operator"].get("type", ""))
			if operator_type == "LessThan" or operator_type == "LessThanOrEqual":
				has_upper_bound = true
			elif operator_type == "GreaterThan" or operator_type == "GreaterThanOrEqual":
				has_lower_bound = true
		elif node.has("operand"):
			var operand = node["operand"]
			if typeof(operand) != TYPE_DICTIONARY:
				continue
			var variable = operand.get("variable", {})
			if typeof(variable) == TYPE_DICTIONARY:
				var predefined = variable.get("predefinedVariable", {})
				if typeof(predefined) == TYPE_DICTIONARY and str(predefined.get("type", "")) == "Return":
					has_return = true
			var constant = operand.get("constant", {})
			if typeof(constant) == TYPE_DICTIONARY:
				max_constant = maxf(max_constant, float(constant.get("value", -1.0)))
	if not has_return:
		return -1.0
	if has_upper_bound and max_constant >= 0.0:
		return max_constant
	if has_lower_bound:
		return 100.0
	return -1.0


func _sort_skill_phases(phases: Array) -> Array:
	var sorted := []
	for phase in phases:
		if typeof(phase) != TYPE_DICTIONARY:
			continue
		var inserted := false
		for i in range(sorted.size()):
			if float(phase.get("max_hp_percent", 100.0)) < float(sorted[i].get("max_hp_percent", 100.0)):
				sorted.insert(i, phase)
				inserted = true
				break
		if not inserted:
			sorted.append(phase)
	return sorted


func _phase_for_percent(phases: Array, hp_percent: float) -> Dictionary:
	for phase in phases:
		if typeof(phase) == TYPE_DICTIONARY and hp_percent <= float(phase.get("max_hp_percent", 100.0)):
			return phase
	return {}


func _current_enemy_skill(enemy: Dictionary) -> Dictionary:
	var skill_id := int(enemy.get("skill_id", 0))
	var phase_name := ""
	var phases = enemy.get("skill_phases", [])
	if typeof(phases) == TYPE_ARRAY and not phases.is_empty():
		var max_hp := maxf(1.0, float(enemy.get("max_hp", 1.0)))
		var hp_percent := clampf(float(enemy.get("hp", 0.0)) / max_hp * 100.0, 0.0, 100.0)
		var phase := _phase_for_percent(phases, hp_percent)
		if not phase.is_empty():
			skill_id = int(phase.get("skill_id", skill_id))
			phase_name = str(phase.get("phase_name", ""))

	var skill: Dictionary = store.get_skill(skill_id) if store != null and skill_id > 0 else {}
	return {
		"skill_id": skill_id,
		"skill_name": str(skill.get("name", enemy.get("skill_name", ""))),
		"damage_ratio": store.skill_damage_total_ratio(skill, 1) if store != null and not skill.is_empty() else float(enemy.get("skill_damage_ratio", 1.0)),
		"phase_name": phase_name,
	}


func _extract_skill_id_from_trigger(trigger: Dictionary) -> int:
	return _extract_skill_id_from_statements(trigger.get("statements", []))


func _extract_skill_id_from_statements(statements: Array) -> int:
	for statement in statements:
		if typeof(statement) != TYPE_DICTIONARY:
			continue
		if statement.has("call"):
			var call: Dictionary = statement["call"]
			var method = call.get("method", {})
			if typeof(method) != TYPE_DICTIONARY:
				continue
			var unit_method = method.get("unitMethod", {})
			if typeof(unit_method) != TYPE_DICTIONARY:
				continue
			var method_type := str(unit_method.get("type", ""))
			if method_type != "UseSkill" and method_type != "UseSkillToTarget":
				continue
			for assignment in call.get("assignments", []):
				if typeof(assignment) != TYPE_DICTIONARY:
					continue
				var variable = assignment.get("variable", {})
				var parameter = variable.get("parameter", {}) if typeof(variable) == TYPE_DICTIONARY else {}
				if str(parameter.get("type", "")) != "SkillDataId":
					continue
				return int(round(_eval_trigger_postfix(assignment.get("expression", {}).get("postfix", []))))
		if statement.has("condition"):
			var condition = statement["condition"]
			if typeof(condition) == TYPE_DICTIONARY:
				var found := _extract_skill_id_from_statements(condition.get("statements", []))
				if found > 0:
					return found
				found = _extract_skill_id_from_statements(condition.get("elseStatements", []))
				if found > 0:
					return found
	return 0


func _eval_trigger_postfix(postfix: Array) -> float:
	var stack := []
	for node in postfix:
		if typeof(node) != TYPE_DICTIONARY:
			continue
		if node.has("operator"):
			var operator_type := str(node["operator"].get("type", ""))
			var b = stack.pop_back() if stack.size() > 0 else 0.0
			var a = stack.pop_back() if stack.size() > 0 else 0.0
			stack.append(_apply_trigger_operator(operator_type, a, b))
		elif node.has("operand"):
			stack.append(_eval_trigger_operand(node["operand"]))
	return float(stack.back()) if stack.size() > 0 else 0.0


func _eval_trigger_operand(operand) -> float:
	if typeof(operand) != TYPE_DICTIONARY:
		return 0.0
	if operand.has("constant"):
		return float(operand["constant"].get("value", 0.0))
	var variable = operand.get("variable", {})
	if typeof(variable) != TYPE_DICTIONARY:
		return 0.0
	if variable.has("boardKey"):
		return float(board_vars.get(int(variable.get("boardKey", 0)), 0.0))
	var predefined = variable.get("predefinedVariable", {})
	if typeof(predefined) == TYPE_DICTIONARY:
		match str(predefined.get("type", "")):
			"Return":
				return trigger_return
			"Tick":
				return float(int(round(elapsed * TRIGGER_TICKS_PER_SECOND)))
			"Timer":
				return elapsed
	return 0.0


func _apply_trigger_operator(operator_type: String, a, b) -> float:
	var left := float(a)
	var right := float(b)
	match operator_type:
		"Add":
			return left + right
		"Subtract":
			return left - right
		"Multiply":
			return left * right
		"Divide":
			return left / right if right != 0.0 else 0.0
		"Modulo":
			return fmod(left, right) if right != 0.0 else 0.0
		"Equal":
			return 1.0 if is_equal_approx(left, right) else 0.0
		"NotEqual":
			return 0.0 if is_equal_approx(left, right) else 1.0
		"LessThan":
			return 1.0 if left < right else 0.0
		"LessThanOrEqual":
			return 1.0 if left <= right or is_equal_approx(left, right) else 0.0
		"GreaterThan":
			return 1.0 if left > right else 0.0
		"GreaterThanOrEqual":
			return 1.0 if left >= right or is_equal_approx(left, right) else 0.0
		"And":
			return 1.0 if _truthy(left) and _truthy(right) else 0.0
		"Or":
			return 1.0 if _truthy(left) or _truthy(right) else 0.0
		_:
			return 0.0


func _truthy(value) -> bool:
	return absf(float(value)) > 0.0001


func _next_map_id() -> int:
	var popup_args: Dictionary = map_def.get("popupArgs", {}) if typeof(map_def.get("popupArgs", {})) == TYPE_DICTIONARY else {}
	var raw_next := str(popup_args.get("ClientNextMapDataId", "self"))
	if raw_next == "" or raw_next == "self":
		return map_id
	return int(raw_next)


func _enemy_attack_range(unit_type: String, tags: Array) -> float:
	if tags.has("Ranged"):
		return RANGED_ATTACK_RANGE
	if unit_type == "Boss" or tags.has("GiantBoss"):
		return BOSS_ATTACK_RANGE
	if unit_type == "MidBoss" or tags.has("MiniBoss"):
		return CONTACT_RANGE + 18.0
	return CONTACT_RANGE


func _unit_type(unit: Dictionary) -> String:
	var raw_type = unit.get("type", "Normal")
	if raw_type == null:
		return "Normal"
	var text := str(raw_type)
	return "Normal" if text == "" else text


func _spawn_position_for_entry(entry: Dictionary, spawn_slot: int) -> Vector2:
	var base := Vector2(ENEMY_SPAWN_X, WORLD_SIZE.y * ENEMY_SPAWN_Y_RATIO)
	if int(entry.get("location_id", 0)) != 0:
		base = _world_position_for_map_location(int(entry.get("location_id", 0)), base)
	elif is_finite(float(entry.get("position_x", INF))) and is_finite(float(entry.get("position_y", INF))):
		base = _world_position_from_map_coords(float(entry.get("position_x", 0.0)), float(entry.get("position_y", 0.0)))
	base.x += _spawn_depth_offset(spawn_slot)
	base.y += _spawn_lane_offset(spawn_slot)
	return base


func _world_position_for_map_location(location_id: int, fallback: Vector2) -> Vector2:
	for location in map_def.get("locations", []):
		if typeof(location) != TYPE_DICTIONARY or int(location.get("id", 0)) != location_id:
			continue
		var position = location.get("position", {})
		if typeof(position) != TYPE_DICTIONARY:
			return fallback
		return _world_position_from_map_coords(float(position.get("x", 3.1)), float(position.get("y", 0.0)))
	return fallback


func _world_position_from_map_coords(x: float, y: float) -> Vector2:
	var player_location := _map_location_position(-1, Vector2(-2.8, 0.0))
	var enemy_location := _map_location_position(101, Vector2(3.1, 0.0))
	var map_span := maxf(0.1, enemy_location.x - player_location.x)
	var world_scale := (ENEMY_SPAWN_X - PLAYER_X) / map_span
	var world_x := PLAYER_X + (x - player_location.x) * world_scale
	var world_y := WORLD_SIZE.y * ENEMY_SPAWN_Y_RATIO + (y - player_location.y) * world_scale * 0.45
	return Vector2(world_x, world_y)


func _map_location_position(location_id: int, fallback: Vector2) -> Vector2:
	for location in map_def.get("locations", []):
		if typeof(location) != TYPE_DICTIONARY or int(location.get("id", 0)) != location_id:
			continue
		var position = location.get("position", {})
		if typeof(position) == TYPE_DICTIONARY:
			return Vector2(float(position.get("x", fallback.x)), float(position.get("y", fallback.y)))
	return fallback


func _spawn_lane_offset(spawn_slot: int) -> float:
	var lane_pattern := [0.0, -34.0, 34.0, -58.0, 58.0, -17.0, 17.0]
	return float(lane_pattern[int(spawn_slot) % lane_pattern.size()])


func _spawn_depth_offset(spawn_slot: int) -> float:
	var depth_pattern := [0.0, 34.0, 68.0, 18.0, 52.0, 86.0, 104.0]
	return float(depth_pattern[int(spawn_slot) % depth_pattern.size()])


func _spawn_fx_key(unit_type: String, tags: Array) -> String:
	if unit_type == "Boss" or tags.has("GiantBoss"):
		return "fx_mob_spawn_l"
	if unit_type == "MidBoss" or tags.has("MiniBoss") or tags.has("Armored"):
		return "fx_mob_spawn_m"
	return "fx_mob_spawn"


func _spawn_fx_size(unit_type: String, tags: Array) -> float:
	if unit_type == "Boss" or tags.has("GiantBoss"):
		return 108.0
	if unit_type == "MidBoss" or tags.has("MiniBoss") or tags.has("Armored"):
		return 82.0
	return 58.0


func _is_instance_drop_item(item: Dictionary) -> bool:
	if item.is_empty():
		return false
	return str(item.get("category", "")) == "Equipment" or _item_has_tag(item, "StoneWeapon")


func _item_has_tag(item: Dictionary, tag: String) -> bool:
	var tags = item.get("tags", [])
	return typeof(tags) == TYPE_ARRAY and tags.has(tag)


func _enemy_damage_multiplier(unit_type: String, tags: Array) -> float:
	if tags.has("Ranged"):
		return 0.9
	if tags.has("Fast"):
		return 1.05
	if tags.has("Armored"):
		return 1.25
	if unit_type == "Boss" or tags.has("GiantBoss"):
		return 2.0
	if unit_type == "MidBoss" or tags.has("MiniBoss"):
		return 1.55
	return CONTACT_DAMAGE_MULTIPLIER


func _front_enemy() -> Dictionary:
	var best := {}
	var best_distance := INF
	var player_pos: Vector2 = player.get("position", Vector2.ZERO)
	for enemy in enemies:
		if typeof(enemy) != TYPE_DICTIONARY or not bool(enemy.get("alive", true)):
			continue
		var distance := player_pos.distance_to(enemy.get("position", Vector2.ZERO))
		if distance < best_distance:
			best_distance = distance
			best = enemy
	return best


func _alive_enemies() -> Array:
	var alive := []
	for enemy in enemies:
		if typeof(enemy) == TYPE_DICTIONARY and bool(enemy.get("alive", true)):
			alive.append(enemy)
	return alive


func _build_trigger_wave_metadata(source_map: Dictionary) -> Array:
	var waves := []
	var seen := {}
	for trigger_name in _trigger_wave_start_names(source_map):
		if seen.has(trigger_name):
			continue
		seen[trigger_name] = true
		waves.append({
			"index": waves.size() + 1,
			"trigger": trigger_name,
			"is_boss": trigger_name.contains("BOSS"),
		})
	return waves


func _trigger_wave_start_names(source_map: Dictionary) -> Array:
	var names := []
	var trigger_names = source_map.get("triggers", [])
	if typeof(trigger_names) != TYPE_ARRAY:
		return names
	for raw_name in trigger_names:
		var trigger_name := str(raw_name)
		var trigger: Dictionary = store.get_trigger(trigger_name) if store != null else {}
		var trigger_type := str(trigger.get("type", "OnStart"))
		if trigger_type == "OnStart" and trigger_name.contains("WAVE"):
			names.append(trigger_name)
		elif trigger_type == "OnUpdate":
			for run_name in _extract_run_trigger_names(trigger.get("statements", [])):
				if run_name.contains("WAVE") or run_name.contains("BOSS"):
					names.append(run_name)
	return names


func _extract_run_trigger_names(statements: Array) -> Array:
	var names := []
	for statement in statements:
		if typeof(statement) != TYPE_DICTIONARY:
			continue
		if statement.has("call"):
			var method = statement["call"].get("method", {})
			if typeof(method) == TYPE_DICTIONARY and method.has("runTrigger"):
				var run_trigger = method["runTrigger"]
				if typeof(run_trigger) == TYPE_DICTIONARY:
					names.append(str(run_trigger.get("name", "")))
		if statement.has("condition"):
			var condition = statement["condition"]
			if typeof(condition) == TYPE_DICTIONARY:
				names.append_array(_extract_run_trigger_names(condition.get("statements", [])))
				names.append_array(_extract_run_trigger_names(condition.get("elseStatements", [])))
	return names


func _current_wave() -> Dictionary:
	var index: int = int(clamp(_current_wave_number() - 1, 0, max(0, wave_plan.size() - 1)))
	if index >= 0 and index < wave_plan.size():
		return wave_plan[index]
	return {}


func _current_wave_number() -> int:
	return maxi(1, int(round(float(board_vars.get(BOARD_KEY_WAVE, 1.0)))))


func _current_wave_time_limit() -> float:
	var wave := _current_wave()
	if bool(wave.get("is_boss", false)):
		return BOSS_WAVE_FORCE_ADVANCE_SECONDS
	return WAVE_FORCE_ADVANCE_SECONDS


func _push_event(text: String) -> void:
	events.push_front(text)
	while events.size() > MAX_EVENT_LOG:
		events.pop_back()


func _push_drop_event(item_id: int, count: int, reward_origin := {}) -> void:
	if item_id <= 0 or count <= 0:
		return
	var item_name := _item_display_name(item_id)
	if item_name == "":
		return
	if item_id == 5:
		var origin_position: Vector2 = reward_origin.get("position", Vector2(805.0, 80.0)) if typeof(reward_origin) == TYPE_DICTIONARY else Vector2(805.0, 80.0)
		_push_event("+%s x%d" % [item_name, count])
		_fx("gold_drop", {
			"item_id": item_id,
			"item_name": item_name,
			"count": count,
			"position": origin_position,
			"time": elapsed,
			"ttl": 1.35,
		})
		return
	var rarity := _drop_rarity(item_id)
	var drop := {
		"item_id": item_id,
		"item_name": item_name,
		"count": count,
		"rarity": rarity,
		"title": "%s x%d" % [item_name, count],
		"body": _drop_body(item_id, rarity),
		"time": elapsed,
	}
	latest_drop = drop
	drop_events.push_front(drop)
	while drop_events.size() > 8:
		drop_events.pop_back()
	_push_event("+%s x%d" % [item_name, count])
	_fx("drop", drop.merged({"ttl": 1.5}, true))


func _push_instance_drop_event(instance: Dictionary, source_type := "instance") -> void:
	if instance.is_empty():
		return
	var item_id := int(instance.get("item_data_id", 0))
	if item_id <= 0:
		return
	var item_name := str(instance.get("name", _item_display_name(item_id)))
	if item_name == "":
		return
	var rarity := _drop_rarity(item_id)
	var stage := int(instance.get("stage", 0))
	var grade := int(instance.get("grade", 0))
	var badge := "S%d" % stage if stage > 0 else "T%d" % grade
	var drop := {
		"item_id": item_id,
		"item_name": item_name,
		"count": 1,
		"rarity": rarity,
		"title": "%s %s" % [item_name, badge],
		"body": _instance_drop_body(instance, source_type),
		"time": elapsed,
		"instance_id": int(instance.get("instance_id", 0)),
		"category": str(instance.get("category", "")),
		"grade": grade,
		"stage": stage,
	}
	latest_drop = drop
	drop_events.push_front(drop)
	while drop_events.size() > 8:
		drop_events.pop_back()
	_push_event("+%s" % str(drop.get("title", item_name)))
	_fx("drop", drop.merged({"ttl": 1.8}, true))


func _item_display_name(item_id: int) -> String:
	var item: Dictionary = store.get_item(item_id) if store != null else {}
	if not item.is_empty():
		return str(item.get("name", ""))
	match item_id:
		3, 4:
			return "루비"
		5:
			return "골드"
		6:
			return "경험치"
		200101:
			return "조약돌 파편"
		200102:
			return "이끼 광석"
		200103:
			return "큐브 촉매"
	return ""


func _drop_rarity(item_id: int) -> String:
	var item: Dictionary = store.get_item(item_id) if store != null else {}
	if not item.is_empty():
		var rarity_value := int(item.get("rarity", item.get("grade", 1)))
		if str(item.get("category", "")) == "Equipment" or _item_has_tag(item, "StoneWeapon"):
			if rarity_value >= 5:
				return "rare"
			if rarity_value >= 3:
				return "notable"
			return "minor"
	match item_id:
		200103:
			return "rare"
		200102:
			return "notable"
		200101:
			return "minor"
		5, 6:
			return "minor"
	return "notable"


func _drop_body(item_id: int, rarity: String) -> String:
	var item: Dictionary = store.get_item(item_id) if store != null else {}
	if not item.is_empty():
		if str(item.get("category", "")) == "Equipment":
			return "장비 인스턴스 획득!"
		if _item_has_tag(item, "StoneWeapon"):
			return "돌 인스턴스 획득!"
	if item_id == 200103:
		return "온라인 희귀 재료 획득!"
	if item_id == 200102:
		return "장비 승급 재료 획득"
	if item_id == 200101:
		return "먹이기/합성 재료 획득"
	if rarity == "rare":
		return "희귀 전리품 획득!"
	return "획득!"


func _instance_drop_body(instance: Dictionary, source_type: String) -> String:
	if source_type == "equipment" or str(instance.get("category", "")) == "Equipment":
		return "장비 인스턴스 획득!"
	if source_type == "stone" or int(instance.get("stage", 0)) > 0:
		return "돌 인스턴스 획득!"
	return "전리품 인스턴스 획득!"


func _fx(kind: String, payload: Dictionary) -> void:
	var event := payload.duplicate(true)
	event["kind"] = kind
	event["ttl"] = float(payload.get("ttl", 0.7))
	event["duration"] = float(event["ttl"])
	event["fx_id"] = next_fx_id
	next_fx_id += 1
	fx_events.append(event)


func _decay_fx(delta: float) -> void:
	for event in fx_events:
		if typeof(event) == TYPE_DICTIONARY:
			event["ttl"] = float(event.get("ttl", 0.0)) - delta
	fx_events = fx_events.filter(func(event): return typeof(event) == TYPE_DICTIONARY and float(event.get("ttl", 0.0)) > 0.0)


func _decay_combat_state(delta: float) -> void:
	player["hit_flash"] = maxf(0.0, float(player.get("hit_flash", 0.0)) - delta)
	player["attack_flash"] = maxf(0.0, float(player.get("attack_flash", 0.0)) - delta)
	for enemy in enemies:
		if typeof(enemy) == TYPE_DICTIONARY:
			enemy["attack_flash"] = maxf(0.0, float(enemy.get("attack_flash", 0.0)) - delta)
			enemy["hit_flash"] = maxf(0.0, float(enemy.get("hit_flash", 0.0)) - delta)
