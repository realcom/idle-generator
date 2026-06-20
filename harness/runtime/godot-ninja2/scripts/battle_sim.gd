extends RefCounted

const Catalog := preload("res://scripts/core/ninja2_catalog.gd")
const WavePlanner := preload("res://scripts/sim/wave_planner.gd")

const DEFAULT_WORLD_SIZE := Vector2(3000.0, 2000.0)
const CONTACT_RANGE := 112.0
const CONTACT_DAMAGE_SCALE := 0.72
const SPEED_TO_PIXELS := 56.0
const MAX_ALIVE_ENEMIES := 34
const SPAWN_BATCH_SIZE := 3
const SPAWN_BATCH_DELAY := 0.22
const PLAYER_MOVE_SPEED_MULTIPLIER := 1.55
const PLAYER_EDGE_PADDING := 42.0
const PLAYER_DASH_COOLDOWN := 4.35
const PLAYER_DASH_DURATION := 0.2
const PLAYER_DASH_DISTANCE := 370.0
const PLAYER_DASH_INVULNERABLE := 0.34
const PLAYER_BODY_RADIUS := 70.0
const ENEMY_BODY_RADIUS := 48.0
const BOSS_BODY_RADIUS := 78.0
const ENEMY_SEPARATION_PASSES := 2
const ENEMY_SEPARATION_STRENGTH := 0.78
const ENEMY_ATTACK_RANGE_BUFFER := 8.0
const SKILL_LEVEL_DAMAGE_BONUS := 0.16
const FX_EVENT_LIFETIME := 0.86
const MAX_FX_EVENTS := 96
const DEFAULT_LEVEL_EXP_BASE := 24
const DEFAULT_LEVEL_EXP_LINEAR := 18
const DEFAULT_LEVEL_EXP_QUADRATIC := 4.0
const MAX_RUN_SKILL_LEVEL := 5
const LEVEL_CHOICE_COUNT := 3
const EXP_PICKUP_ARM_DELAY := 0.5
const EXP_PICKUP_TTL := 22.0
const EXP_PICKUP_MAGNET_RADIUS := 170.0
const EXP_PICKUP_COLLECT_RADIUS := 30.0
const EXP_PICKUP_SPEED := 520.0
const ENCOUNTER_SPAWN_INTERVAL := 3.5
const ENCOUNTER_MAX_ACTIVE := 5
const ENCOUNTER_COLLECT_RADIUS := 58.0
const ENCOUNTER_MAGNET_COLLECT_BONUS := 24.0
const ENCOUNTER_MINE_RADIUS := 88.0
const ENCOUNTER_MINE_HOLD := 1.5
const ENCOUNTER_TTL := 15.0
const ENCOUNTER_MINE_TTL := 24.0
const ENCOUNTER_MAGNET_DURATION := 5.2
const SKILL_GEOMETRY_WORLD_SCALE := 120.0
const GROUND_AREA_TICK_INTERVAL := 0.5
const ENCOUNTER_TYPES := ["bomb", "magnet", "potion", "mine"]
const ENCOUNTER_TYPE_LABELS := {
	"bomb": "폭탄",
	"magnet": "자석",
	"potion": "회복약",
	"mine": "광산",
}
const ENCOUNTER_TYPE_WEIGHTS := {
	"bomb": 30,
	"magnet": 22,
	"potion": 24,
	"mine": 24,
}
const MINE_RESOURCE_DROPS := [
	{"key": "wood", "min": 90, "max": 140, "label": "목재 광맥"},
	{"key": "stone", "min": 70, "max": 110, "label": "기와석 광맥"},
	{"key": "soul", "min": 45, "max": 75, "label": "영혼불 광맥"},
]

var store
var run_state
var wave_planner
var rng := RandomNumberGenerator.new()
var entities: Array = []
var floating_events: Array = []
var fx_events: Array = []
var skill_slots: Array = []
var active_skills: Array = []
var wave_plan: Array = []
var pending_spawns: Array = []
var exp_pickups: Array = []
var encounter_pickups: Array = []

var running := false
var result := ""
var map_id := 500101
var map_def := {}
var board_constants := {}
var run_leveling_config := {}
var world_size := DEFAULT_WORLD_SIZE
var player_entity := {}
var elapsed := 0.0
var run_duration := 90.0
var spawn_timer := 0.0
var wave_index := -1
var boss_spawned := false
var kill_count := 0
var player_level := 1
var player_exp := 0
var collected_exp_count := 0
var next_level_choice_level := 2
var level_choice_pending := false
var level_choice := {}
var next_runtime_id := 1
var next_pickup_runtime_id := 1
var next_encounter_runtime_id := 1
var next_skill_runtime_id := 1
var next_fx_event_id := 1
var last_report := {}
var run_start_resources := {}
var player_input_vector := Vector2.ZERO
var last_move_vector := Vector2.DOWN
var dash_active := false
var dash_elapsed := 0.0
var dash_start_position := Vector2.ZERO
var dash_end_position := Vector2.ZERO
var dash_cooldown_remaining := 0.0
var dash_invulnerable_remaining := 0.0
var dash_count := 0
var dash_blocked_damage_count := 0
var last_dash_source := ""
var encounter_spawn_timer := 0.0
var encounter_serial := 0
var encounter_collected_count := 0
var encounter_mined_count := 0
var encounter_last := ""
var magnet_remaining := 0.0
var visual_fixture := false
var visual_fixture_motion := false
var visual_fixture_pickups: Array = []


func _init(resource_store = null, state = null) -> void:
	store = resource_store
	run_state = state
	wave_planner = WavePlanner.new(store)
	rng.randomize()


func set_visual_fixture(enabled: bool) -> void:
	visual_fixture = enabled


func set_visual_fixture_motion(enabled: bool) -> void:
	visual_fixture_motion = enabled


func _world_size_from_board_constants() -> Vector2:
	var width: float = float(board_constants.get("worldWidth", DEFAULT_WORLD_SIZE.x))
	var height: float = float(board_constants.get("worldHeight", DEFAULT_WORLD_SIZE.y))
	return Vector2(maxf(512.0, width), maxf(512.0, height))


func start(new_map_id := 500101) -> void:
	map_id = int(new_map_id)
	map_def = store.get_map(map_id) if store != null else {}
	if map_def.is_empty() and store != null:
		var maps: Array = store.get_main_maps()
		if maps.size() > 0:
			map_def = maps[0]
			map_id = int(map_def.get("id", map_id))

	wave_plan = wave_planner.build_plan(map_def)
	board_constants = store.map_board_constants(map_def) if store != null else map_def.get("boardConstants", {})
	run_leveling_config = board_constants.get("survivalRunLeveling", {})
	world_size = _world_size_from_board_constants()
	run_duration = max(75.0, float(wave_plan.size()) * 22.0)
	entities.clear()
	floating_events.clear()
	fx_events.clear()
	active_skills.clear()
	pending_spawns.clear()
	exp_pickups.clear()
	encounter_pickups.clear()
	player_entity.clear()
	skill_slots = _build_skill_slots()
	elapsed = 0.0
	spawn_timer = 0.0
	wave_index = -1
	boss_spawned = false
	kill_count = 0
	player_level = 1
	player_exp = 0
	collected_exp_count = 0
	next_level_choice_level = 2
	level_choice_pending = false
	level_choice.clear()
	next_runtime_id = 1
	next_pickup_runtime_id = 1
	next_encounter_runtime_id = 1
	next_skill_runtime_id = 1
	next_fx_event_id = 1
	result = ""
	last_report.clear()
	run_start_resources = _resources().duplicate(true)
	player_input_vector = Vector2.ZERO
	last_move_vector = Vector2.DOWN
	dash_active = false
	dash_elapsed = 0.0
	dash_start_position = Vector2.ZERO
	dash_end_position = Vector2.ZERO
	dash_cooldown_remaining = 0.0
	dash_invulnerable_remaining = 0.0
	dash_count = 0
	dash_blocked_damage_count = 0
	last_dash_source = ""
	encounter_spawn_timer = min(1.6, ENCOUNTER_SPAWN_INTERVAL)
	encounter_serial = 0
	encounter_collected_count = 0
	encounter_mined_count = 0
	encounter_last = ""
	magnet_remaining = 0.0
	visual_fixture_pickups.clear()
	running = true
	_spawn_player()
	_start_next_wave()
	if visual_fixture:
		_apply_visual_fixture()


func step(delta: float) -> void:
	if not running:
		return

	var capped_delta: float = min(delta, 0.05)
	if level_choice_pending:
		_decay_events(capped_delta)
		_decay_fx_events(capped_delta)
		return

	elapsed += capped_delta
	spawn_timer -= capped_delta

	if visual_fixture:
		_update_player_attack_pose(capped_delta)
		_update_player_dash(capped_delta)
		if visual_fixture_motion and not dash_active:
			_update_player_movement(capped_delta)
		_maintain_visual_fixture()
		_decay_events(capped_delta)
		_decay_fx_events(capped_delta)
		return

	_spawn_from_pending()
	_update_buffs(capped_delta)
	_update_player_attack_pose(capped_delta)
	_update_player_dash(capped_delta)
	if not dash_active:
		_update_player_movement(capped_delta)
	_update_enemies(capped_delta)
	_update_player_skills(capped_delta)
	_update_active_skills(capped_delta)
	_decay_events(capped_delta)
	_decay_fx_events(capped_delta)
	_collect_dead_enemies()
	_update_exp_pickups(capped_delta)
	_update_encounters(capped_delta)
	_maybe_advance_wave()

	if not player_entity.is_empty() and float(player_entity.get("hp", 0.0)) <= 0.0:
		_finish("defeat")
	elif elapsed > run_duration * 2.0:
		_finish("defeat")


func snapshot() -> Dictionary:
	return {
		"running": running,
		"result": result,
		"map_id": map_id,
		"map_name": str(map_def.get("name", "대나무 영지")),
		"elapsed": elapsed,
		"run_duration": run_duration,
		"wave": max(1, wave_index + 1),
		"wave_count": wave_plan.size(),
		"wave_trigger": _current_wave().get("trigger", ""),
		"objective": _objective_text(),
		"wave_progress": _wave_progress(),
		"stage_progress": _stage_progress(),
		"player_level": _display_player_level(),
		"exp": _display_player_exp(),
		"exp_to_next": _display_exp_to_next(),
		"exp_ratio": _display_exp_ratio(),
		"level_choice": level_choice,
		"kill_count": kill_count,
		"enemy_count": _alive_enemies().size(),
		"pending_count": _pending_count(),
		"pickup_count": _pickup_count(),
		"active_pickup_count": exp_pickups.size(),
		"encounter_pickups": encounter_pickups,
		"encounter_active_count": encounter_pickups.size(),
		"encounter_collected": encounter_collected_count,
		"encounter_mined": encounter_mined_count,
		"encounter_last": encounter_last,
		"encounter_serial": encounter_serial,
		"magnet_active": magnet_remaining > 0.0,
		"magnet_remaining": magnet_remaining,
		"active_ground_area_count": _active_ground_area_count(),
		"active_ground_areas": _active_ground_area_snapshots(),
		"player": player_entity,
		"entities": entities,
		"exp_pickups": exp_pickups,
		"events": floating_events,
		"fx_events": fx_events,
		"resources": _resources(),
		"resource_gains": _resource_gains(),
		"skill_slots": skill_slots,
		"dash": _dash_snapshot(),
		"world_size": world_size,
		"world_width": world_size.x,
		"world_height": world_size.y,
		"last_report": last_report,
		"visual_fixture": visual_fixture,
		"fixture_pickups": visual_fixture_pickups,
		}


func set_player_input(vector: Vector2) -> void:
	player_input_vector = vector.limit_length(1.0)
	if player_input_vector.length_squared() > 0.0001:
		last_move_vector = player_input_vector.normalized()


func request_dash(vector := Vector2.ZERO, source := "unknown") -> bool:
	if not running or player_entity.is_empty():
		return false
	if dash_active or dash_cooldown_remaining > 0.0:
		return false

	var dash_vector: Vector2 = vector.limit_length(1.0)
	if dash_vector.length_squared() <= 0.0001:
		dash_vector = last_move_vector
	if dash_vector.length_squared() <= 0.0001:
		dash_vector = Vector2.DOWN
	dash_vector = dash_vector.normalized()

	dash_active = true
	dash_elapsed = 0.0
	dash_start_position = _player_position()
	dash_end_position = _clamp_world_position(dash_start_position + dash_vector * PLAYER_DASH_DISTANCE)
	dash_cooldown_remaining = PLAYER_DASH_COOLDOWN
	dash_invulnerable_remaining = PLAYER_DASH_INVULNERABLE
	dash_count += 1
	last_move_vector = dash_vector
	last_dash_source = str(source)
	return true


func _spawn_player() -> void:
	var unit_def: Dictionary = store.get_unit(Catalog.PLAYER_UNIT_ID) if store != null else {}
	if unit_def.is_empty() and store != null:
		unit_def = store.get_player_unit()

	var hp: float = store.stat_value(unit_def, "Hp", 1200.0)
	player_entity = {
		"runtime_id": next_runtime_id,
		"data_id": int(unit_def.get("id", Catalog.PLAYER_UNIT_ID)),
		"name": str(unit_def.get("name", "그림자 닌자")),
		"team": "player",
		"kind": "player",
		"position": world_size * 0.5,
		"hp": hp,
		"max_hp": hp,
		"attack": store.stat_value(unit_def, "Attack", 80.0),
			"defense": store.stat_value(unit_def, "Defense", 3.0),
			"speed": store.stat_value(unit_def, "MoveSpeed", 3.4),
			"body_radius": PLAYER_BODY_RADIUS,
			"active_buffs": [],
			"combat_facing_vector": Vector2.DOWN,
			"attack_pose_time": 0.0,
			}
	next_runtime_id += 1
	entities.append(player_entity)


func _build_skill_slots() -> Array:
	var slots := []
	for skill_id in _initial_skill_ids():
		var skill_def: Dictionary = store.get_skill(int(skill_id)) if store != null else {}
		if skill_def.is_empty():
			continue
		var cooldown := float(skill_def.get("cooldown", 1.0))
		slots.append({
			"skill_id": int(skill_id),
			"name": str(skill_def.get("name", "Skill")),
			"cooldown": cooldown,
			"timer": min(0.45, cooldown),
			"level": 1,
		})
	return slots


func apply_level_choice(index: int) -> bool:
	if not level_choice_pending:
		return false
	var choices: Array = level_choice.get("choices", [])
	if index < 0 or index >= choices.size():
		return false
	var choice: Dictionary = choices[index]
	var skill_id := int(choice.get("skill_id", 0))
	var skill_def: Dictionary = store.get_skill(skill_id) if store != null else {}
	if skill_def.is_empty():
		return false

	var next_level := int(choice.get("next_level", 1))
	var slot := _skill_slot_for(skill_id)
	if slot.is_empty():
		var cooldown := float(skill_def.get("cooldown", 1.0))
		skill_slots.append({
			"skill_id": skill_id,
			"name": str(skill_def.get("name", "Skill")),
			"cooldown": cooldown,
			"timer": min(0.35, cooldown * 0.35),
			"level": next_level,
		})
	else:
		slot["level"] = next_level
		slot["cooldown"] = float(skill_def.get("cooldown", slot.get("cooldown", 1.0)))
		slot["timer"] = min(float(slot.get("timer", 0.0)), 0.18)

	level_choice_pending = false
	level_choice.clear()
	_add_event(_player_position(), "%s Lv.%d" % [str(skill_def.get("name", "스킬")), next_level], Color(1.0, 0.86, 0.42))
	_maybe_queue_level_choice()
	return true


func _maybe_queue_level_choice() -> void:
	if visual_fixture or level_choice_pending or not running:
		return
	if player_level < next_level_choice_level:
		return
	_queue_level_choice(next_level_choice_level)


func _queue_level_choice(level: int) -> void:
	var choices := _build_level_choice_options(level)
	next_level_choice_level = level + 1
	if choices.is_empty():
		return
	level_choice_pending = true
	level_choice = {
		"pending": true,
		"level": level,
		"kills": kill_count,
		"elapsed": elapsed,
		"source": "playerLevel",
		"choices": choices,
	}
	_add_event(_player_position(), "레벨 업!", Color(1.0, 0.92, 0.54))


func _build_level_choice_options(level: int) -> Array:
	if store == null:
		return []
	var available_ids: Array[int] = []
	for skill_id in _choice_pool_skill_ids():
		if skill_id < 300101 or skill_id > 300199:
			continue
		if _skill_run_level(skill_id) >= _max_run_skill_level():
			continue
		var skill_def: Dictionary = store.get_skill(skill_id)
		if skill_def.is_empty():
			continue
		available_ids.append(skill_id)
	available_ids.sort()
	if available_ids.is_empty():
		return []

	var unowned: Array[int] = []
	var upgrades: Array[int] = []
	for skill_id in available_ids:
		if _skill_run_level(skill_id) <= 0:
			unowned.append(skill_id)
		else:
			upgrades.append(skill_id)

	var offset := int(kill_count + level * 7)
	var ordered := _rotated_ids(unowned, offset)
	ordered.append_array(_rotated_ids(upgrades, offset))

	var choices := []
	for skill_id in ordered:
		var choice := _level_choice_for_skill(skill_id)
		if choice.is_empty():
			continue
		choices.append(choice)
		if choices.size() >= _level_choice_count():
			break
	return choices


func _rotated_ids(source: Array[int], offset: int) -> Array[int]:
	if source.is_empty():
		return []
	var result: Array[int] = []
	var start := offset % source.size()
	for index in range(source.size()):
		result.append(source[(start + index) % source.size()])
	return result


func _level_choice_for_skill(skill_id: int) -> Dictionary:
	var skill_def: Dictionary = store.get_skill(skill_id) if store != null else {}
	if skill_def.is_empty():
		return {}
	var current_level := _skill_run_level(skill_id)
	if current_level >= _max_run_skill_level():
		return {}
	var next_level: int = min(_max_run_skill_level(), current_level + 1)
	var damage_percent: float = store.skill_damage_percent(skill_def, next_level) if store != null else 1.0
	var max_hit: int = store.skill_hit_max(skill_def) if store != null else 1
	var cooldown := float(skill_def.get("cooldown", 0.0))
	var has_hit := _skill_has_hit(skill_def)
	var stat_chips := []
	if has_hit:
		stat_chips.append("피해 %d%%" % int(round(damage_percent * 100.0)))
	elif _skill_has_self_buff(skill_def):
		stat_chips.append("자신 강화")
	if cooldown > 0.0 and stat_chips.size() < 2:
		stat_chips.append("쿨 %.1fs" % cooldown)
	if max_hit > 1 and stat_chips.size() < 2:
		stat_chips.append("대상 %d" % max_hit)
	if stat_chips.is_empty():
		stat_chips.append("전투 보조")

	return {
		"skill_id": skill_id,
		"name": str(skill_def.get("name", "스킬")),
		"current_level": current_level,
		"next_level": next_level,
		"badge_label": "NEW" if current_level <= 0 else "Lv.%d" % next_level,
		"effect_summary": _level_choice_summary(skill_def, damage_percent, max_hit, has_hit),
		"stat_chips": stat_chips,
		"category_label": _skill_category_label(skill_def),
		"icon_key": _skill_icon_key(skill_id, skill_def),
	}


func _skill_slot_for(skill_id: int) -> Dictionary:
	for slot in skill_slots:
		if typeof(slot) == TYPE_DICTIONARY and int(slot.get("skill_id", 0)) == skill_id:
			return slot
	return {}


func _skill_run_level(skill_id: int) -> int:
	var slot := _skill_slot_for(skill_id)
	if slot.is_empty():
		return 0
	return int(slot.get("level", 1))


func _level_choice_summary(skill_def: Dictionary, damage_percent: float, max_hit: int, has_hit: bool) -> String:
	if _skill_has_self_buff(skill_def):
		return "이번 원정 동안 능력치를 강화합니다."
	var tags = skill_def.get("tags", [])
	if typeof(tags) == TYPE_ARRAY and (tags.has("GroundArea") or tags.has("PersistentTerrain")):
		return "착탄 지점에 2초 연막을 남겨 안의 적에게 피해와 둔화를 줍니다."
	if has_hit:
		if max_hit > 1:
			return "최대 %d명에게 %d%% 피해를 줍니다." % [max_hit, int(round(damage_percent * 100.0))]
		return "가까운 적에게 %d%% 피해를 줍니다." % int(round(damage_percent * 100.0))
	return "전투 흐름을 보조하는 기술입니다."


func _skill_category_label(skill_def: Dictionary) -> String:
	var damage_type := str(skill_def.get("damageType", ""))
	match damage_type:
		"Pierce":
			return "관통"
		"Explosive":
			return "폭발"
		"Spell":
			return "술법"
		"None":
			return "보조"
		_:
			return "스킬" if damage_type == "" else damage_type


func _skill_icon_key(skill_id: int, skill_def: Dictionary) -> String:
	match skill_id:
		300102, 300105, 300106, 300108, 300111:
			return "skill_shuriken"
		300103, 300104, 300109, 300114:
			return "skill_smoke"
		300107, 300112, 300113, 300116:
			return "skill_impact"
		300115:
			return "skill_gale"
		_:
			var damage_type := str(skill_def.get("damageType", ""))
			if damage_type == "Explosive":
				return "skill_impact"
			return "skill"


func _start_next_wave() -> void:
	wave_index += 1
	if wave_index >= wave_plan.size():
		_finish("clear")
		return

	var wave: Dictionary = _current_wave()
	pending_spawns.clear()
	for spec in wave.get("units", []):
		if typeof(spec) != TYPE_DICTIONARY:
			continue
		pending_spawns.append(spec.duplicate(true))
	_add_event(_player_position(), "Wave %d" % int(wave.get("index", wave_index + 1)), Color(1.0, 0.86, 0.42))
	spawn_timer = 0.0


func _spawn_from_pending() -> void:
	if spawn_timer > 0.0 or pending_spawns.is_empty():
		return
	if _alive_enemies().size() >= MAX_ALIVE_ENEMIES:
		return

	var spawned := 0
	while spawned < SPAWN_BATCH_SIZE and not pending_spawns.is_empty() and _alive_enemies().size() < MAX_ALIVE_ENEMIES:
		var spec: Dictionary = pending_spawns[0]
		_spawn_enemy(int(spec.get("unit_id", 0)), int(spec.get("level", 1)))
		spec["count"] = int(spec.get("count", 0)) - 1
		if int(spec["count"]) <= 0:
			pending_spawns.pop_front()
		spawned += 1
	spawn_timer = SPAWN_BATCH_DELAY


func _spawn_enemy(unit_id: int, unit_level := 1) -> void:
	var unit_def: Dictionary = store.get_unit(unit_id) if store != null else {}
	if unit_def.is_empty():
		return

	var is_boss := unit_id == Catalog.BOSS_UNIT_ID or str(unit_def.get("type", "")) == "Boss"
	var hp: float = store.stat_value(unit_def, "Hp", 80.0, unit_level)
	var attack: float = store.stat_value(unit_def, "Attack", 6.0, unit_level)
	var defense: float = store.stat_value(unit_def, "Defense", 1.0, unit_level)
	var speed: float = store.stat_value(unit_def, "MoveSpeed", 2.8, unit_level)
	if is_boss:
		boss_spawned = true

	var enemy: Dictionary = {
		"runtime_id": next_runtime_id,
		"data_id": unit_id,
		"name": str(unit_def.get("name", "적")),
		"team": "enemy",
		"kind": "boss" if is_boss else "enemy",
		"position": _random_edge_position(),
		"hp": hp,
		"max_hp": hp,
		"attack": attack,
			"defense": defense,
			"speed": speed * (0.75 if is_boss else 1.0),
			"level": unit_level,
			"body_radius": BOSS_BODY_RADIUS if is_boss else ENEMY_BODY_RADIUS,
			"active_buffs": [],
		}
	next_runtime_id += 1
	entities.append(enemy)


func _apply_visual_fixture() -> void:
	if player_entity.is_empty():
		return
	pending_spawns.clear()
	floating_events.clear()
	visual_fixture_pickups.clear()
	boss_spawned = true
	kill_count = 0

	var player_pos := Vector2(world_size.x * 0.5, world_size.y * 0.5 + 76.0)
	player_entity["position"] = player_pos
	player_entity["hp"] = max(1.0, float(player_entity.get("max_hp", 1.0)) * 0.94)
	player_entity["attack"] = max(3.0, float(player_entity.get("attack", 24.0)) * 0.16)
	dash_cooldown_remaining = 2.8
	dash_count = 1
	last_dash_source = "visual_fixture"
	for index in range(skill_slots.size()):
		var slot: Dictionary = skill_slots[index]
		slot["timer"] = 1.6 + float(index) * 0.9

	var defs := _visual_fixture_unit_defs()
	var boss_def: Dictionary = defs.get("boss", {})
	if not boss_def.is_empty():
		_spawn_visual_fixture_enemy(boss_def, player_pos + Vector2(20.0, -430.0), 0.72, true)

	var enemy_defs: Array = defs.get("enemies", [])
	var slots := [
		Vector2(-470, -310),
		Vector2(462, -296),
		Vector2(-520, -58),
		Vector2(526, -36),
		Vector2(-430, 218),
		Vector2(438, 232),
		Vector2(-244, 392),
		Vector2(260, 384),
		Vector2(-590, 156),
		Vector2(598, 164),
		Vector2(-172, -420),
		Vector2(196, -408),
		Vector2(-502, 384),
		Vector2(520, 390),
		Vector2(-18, 452),
		Vector2(-610, -240),
		Vector2(618, -232),
		Vector2(-330, 500),
		Vector2(348, 492),
		Vector2(0, -470),
	]
	for index in range(slots.size()):
		if enemy_defs.is_empty():
			break
		var enemy_def: Dictionary = enemy_defs[index % enemy_defs.size()]
		_spawn_visual_fixture_enemy(enemy_def, player_pos + slots[index], 0.9, false)

		visual_fixture_pickups = [
			{"key": "res_gold", "position": player_pos + Vector2(-250, -126), "color": Color(1.0, 0.72, 0.18, 0.2)},
			{"key": "res_soul", "position": player_pos + Vector2(256, -100), "color": Color(0.22, 0.98, 0.92, 0.2)},
			{"key": "res_wood", "position": player_pos + Vector2(-350, 104), "color": Color(0.74, 0.44, 0.18, 0.18)},
			{"key": "res_stone", "position": player_pos + Vector2(333, 148), "color": Color(0.84, 0.84, 0.76, 0.17)},
			{"key": "res_gold", "position": player_pos + Vector2(-88, 284), "color": Color(1.0, 0.72, 0.18, 0.18)},
			{"key": "res_soul", "position": player_pos + Vector2(120, 266), "color": Color(0.22, 0.98, 0.92, 0.18)},
			{"key": "res_gold", "position": player_pos + Vector2(-430, -22), "color": Color(1.0, 0.72, 0.18, 0.16)},
			{"key": "res_stone", "position": player_pos + Vector2(430, -18), "color": Color(0.84, 0.84, 0.76, 0.15)},
			{"key": "res_soul", "position": player_pos + Vector2(-470, 246), "color": Color(0.22, 0.98, 0.92, 0.17)},
			{"key": "res_gold", "position": player_pos + Vector2(470, 242), "color": Color(1.0, 0.72, 0.18, 0.16)},
			{"key": "res_wood", "position": player_pos + Vector2(-116, -250), "color": Color(0.74, 0.44, 0.18, 0.14)},
			{"key": "res_stone", "position": player_pos + Vector2(148, -278), "color": Color(0.84, 0.84, 0.76, 0.14)},
			{"key": "res_gold", "position": player_pos + Vector2(-530, -192), "color": Color(1.0, 0.72, 0.18, 0.14)},
			{"key": "res_soul", "position": player_pos + Vector2(544, -184), "color": Color(0.22, 0.98, 0.92, 0.15)},
			{"key": "res_wood", "position": player_pos + Vector2(-248, 420), "color": Color(0.74, 0.44, 0.18, 0.13)},
			{"key": "res_stone", "position": player_pos + Vector2(282, 414), "color": Color(0.84, 0.84, 0.76, 0.13)},
			{"key": "res_gold", "position": player_pos + Vector2(0, 430), "color": Color(1.0, 0.72, 0.18, 0.13)},
			{"key": "res_soul", "position": player_pos + Vector2(0, -380), "color": Color(0.22, 0.98, 0.92, 0.13)},
		]
	last_report = {"visual_fixture": "runtime-polish-f"}


func _visual_fixture_unit_defs() -> Dictionary:
	var player_def: Dictionary = store.get_player_unit() if store != null else {}
	var boss_def := {}
	var enemy_defs := []
	if store == null:
		return {"boss": boss_def, "enemies": enemy_defs}
	for unit_def in store.get_records("Units"):
		if typeof(unit_def) != TYPE_DICTIONARY:
			continue
		if int(unit_def.get("id", 0)) == int(player_def.get("id", 0)):
			continue
		if str(unit_def.get("type", "")) == "Boss":
			boss_def = unit_def
		else:
			enemy_defs.append(unit_def)
	return {"boss": boss_def, "enemies": enemy_defs}


func _spawn_visual_fixture_enemy(unit_def: Dictionary, position: Vector2, visual_scale: float = 1.0, is_boss := false) -> void:
	if unit_def.is_empty():
		return
	var unit_level: int = max(1, int(wave_index + 6))
	var hp: float = store.stat_value(unit_def, "Hp", 80.0, unit_level)
	var attack: float = store.stat_value(unit_def, "Attack", 6.0, unit_level)
	var defense: float = store.stat_value(unit_def, "Defense", 1.0, unit_level)
	var speed: float = store.stat_value(unit_def, "MoveSpeed", 2.8, unit_level)
	var hp_multiplier: float = 24.0 if is_boss else 10.0
	var enemy: Dictionary = {
		"runtime_id": next_runtime_id,
		"data_id": int(unit_def.get("id", 0)),
		"name": str(unit_def.get("name", "적")),
		"team": "enemy",
		"kind": "boss" if is_boss else "enemy",
		"position": _clamp_world_position(position),
		"hp": hp * hp_multiplier * (0.78 if is_boss else 0.86),
		"max_hp": hp * hp_multiplier,
		"attack": attack,
			"defense": defense,
			"speed": speed * (0.75 if is_boss else 1.0),
			"level": unit_level,
			"visual_scale": visual_scale,
			"body_radius": BOSS_BODY_RADIUS if is_boss else ENEMY_BODY_RADIUS,
			"fixture_slot": position - _player_position(),
			"active_buffs": [],
		}
	next_runtime_id += 1
	entities.append(enemy)


func _maintain_visual_fixture() -> void:
	if player_entity.is_empty():
		return
	var player_pos := _player_position() if visual_fixture_motion else Vector2(world_size.x * 0.5, world_size.y * 0.5 + 76.0)
	player_entity["position"] = player_pos
	player_entity["hp"] = max(1.0, float(player_entity.get("max_hp", 1.0)) * 0.94)

	for entity in entities:
		if entity.get("team", "") != "enemy" or float(entity.get("hp", 0.0)) <= 0.0:
			continue
		var slot: Vector2 = entity.get("fixture_slot", Vector2.ZERO)
		var runtime_id := float(entity.get("runtime_id", 0))
		var orbit := Vector2(sin(elapsed * 1.45 + runtime_id) * 8.0, cos(elapsed * 1.35 + runtime_id * 0.7) * 6.0)
		entity["position"] = _clamp_world_position(player_pos + slot + orbit)
	_resolve_enemy_spacing()


func _update_enemies(delta: float) -> void:
	if player_entity.is_empty():
		return

	var player_pos: Vector2 = _player_position()
	for entity in entities:
		if entity.get("team", "") != "enemy" or float(entity.get("hp", 0.0)) <= 0.0:
			continue

		var pos: Vector2 = _dict_vec2(entity, "position", Vector2.ZERO)
		var to_player: Vector2 = player_pos - pos
		var distance: float = to_player.length()
		var attack_range: float = _attack_range_for_enemy(entity)
		if distance > attack_range and distance > 1.0:
			var move_speed: float = max(0.35, float(entity.get("speed", 2.0)) + _entity_buff_stat(entity, "MoveSpeed"))
			var step_distance: float = min(move_speed * SPEED_TO_PIXELS * delta, max(0.0, distance - attack_range))
			pos += to_player.normalized() * step_distance
			entity["position"] = _clamp_world_position(pos)

	_resolve_enemy_spacing()
	player_pos = _player_position()
	for attacker in entities:
		if attacker.get("team", "") != "enemy" or float(attacker.get("hp", 0.0)) <= 0.0:
			continue

		var attack_pos: Vector2 = _dict_vec2(attacker, "position", Vector2.ZERO)
		var attack_distance: float = attack_pos.distance_to(player_pos)
		if attack_distance <= _attack_range_for_enemy(attacker) + ENEMY_ATTACK_RANGE_BUFFER:
			if dash_invulnerable_remaining > 0.0:
				dash_blocked_damage_count += 1
				continue
			var damage: float = max(1.0, float(attacker.get("attack", 4.0)) - float(player_entity.get("defense", 0.0)))
			player_entity["hp"] = max(0.0, float(player_entity["hp"]) - damage * CONTACT_DAMAGE_SCALE * delta)


func _resolve_enemy_spacing() -> void:
	var enemies: Array = _alive_enemies()
	if enemies.is_empty() or player_entity.is_empty():
		return

	for _pass in range(ENEMY_SEPARATION_PASSES):
		_resolve_enemy_player_spacing(enemies)
		for left_index in range(enemies.size()):
			var left: Dictionary = enemies[left_index]
			var left_pos: Vector2 = _dict_vec2(left, "position", _player_position())
			for right_index in range(left_index + 1, enemies.size()):
				var right: Dictionary = enemies[right_index]
				var right_pos: Vector2 = _dict_vec2(right, "position", _player_position())
				var separation: Vector2 = left_pos - right_pos
				var distance: float = separation.length()
				if distance <= 0.001:
					var seed: float = float(int(left.get("runtime_id", 0)) * 31 + int(right.get("runtime_id", 0)) * 17)
					separation = Vector2(cos(seed), sin(seed))
					distance = 1.0

				var min_distance: float = (_entity_body_radius(left) + _entity_body_radius(right)) * 1.04
				if distance >= min_distance:
					continue

				var push: Vector2 = separation.normalized() * (min_distance - distance) * 0.5 * ENEMY_SEPARATION_STRENGTH
				left_pos = _clamp_world_position(left_pos + push)
				right_pos = _clamp_world_position(right_pos - push)
				left["position"] = left_pos
				right["position"] = right_pos

	_resolve_enemy_player_spacing(enemies)


func _resolve_enemy_player_spacing(enemies: Array) -> void:
	var player_pos: Vector2 = _player_position()
	for entity in enemies:
		var pos: Vector2 = _dict_vec2(entity, "position", player_pos)
		var offset: Vector2 = pos - player_pos
		var distance: float = offset.length()
		var min_distance: float = PLAYER_BODY_RADIUS + _entity_body_radius(entity)
		if distance >= min_distance:
			continue

		if distance <= 0.001:
			var seed: float = float(int(entity.get("runtime_id", 0))) * 1.618
			offset = Vector2(cos(seed), sin(seed))
		else:
			offset = offset.normalized()
		entity["position"] = _clamp_world_position(player_pos + offset * min_distance)


func _attack_range_for_enemy(entity: Dictionary) -> float:
	var contact_range: float = CONTACT_RANGE + (38.0 if str(entity.get("kind", "")) == "boss" else 0.0)
	return max(contact_range, PLAYER_BODY_RADIUS + _entity_body_radius(entity))


func _entity_body_radius(entity: Dictionary) -> float:
	if entity.has("body_radius"):
		return max(8.0, float(entity.get("body_radius", ENEMY_BODY_RADIUS)))
	if str(entity.get("kind", "")) == "player":
		return PLAYER_BODY_RADIUS
	if str(entity.get("kind", "")) == "boss":
		return BOSS_BODY_RADIUS
	return ENEMY_BODY_RADIUS


func _update_player_movement(delta: float) -> void:
	if player_entity.is_empty() or player_input_vector.length_squared() <= 0.0001:
		return

	var movement := player_input_vector.normalized()
	var speed: float = max(0.35, float(player_entity.get("speed", 3.4)) + _entity_buff_stat(player_entity, "MoveSpeed"))
	speed *= SPEED_TO_PIXELS * PLAYER_MOVE_SPEED_MULTIPLIER
	var position: Vector2 = _player_position() + movement * speed * delta
	player_entity["position"] = _clamp_world_position(position)


func _update_player_dash(delta: float) -> void:
	dash_cooldown_remaining = max(0.0, dash_cooldown_remaining - delta)
	dash_invulnerable_remaining = max(0.0, dash_invulnerable_remaining - delta)

	if not dash_active or player_entity.is_empty():
		return

	dash_elapsed += delta
	var ratio: float = clamp(dash_elapsed / PLAYER_DASH_DURATION, 0.0, 1.0)
	var eased: float = 1.0 - pow(1.0 - ratio, 3.0)
	player_entity["position"] = dash_start_position.lerp(dash_end_position, eased)
	if ratio >= 1.0:
		dash_active = false


func _update_player_skills(delta: float) -> void:
	if player_entity.is_empty():
		return

	for slot in skill_slots:
		slot["timer"] = max(0.0, float(slot.get("timer", 0.0)) - delta)
		if float(slot["timer"]) > 0.0:
			continue

		var skill_id := int(slot.get("skill_id", Catalog.BASIC_SKILL_ID))
		var skill_def: Dictionary = store.get_skill(skill_id) if store != null else {}
		if skill_def.is_empty():
			continue

		if _cast_skill(slot, skill_def):
			slot["timer"] = _cooldown_for_skill(skill_def)
		else:
			slot["timer"] = min(0.35, max(0.08, float(slot.get("cooldown", skill_def.get("cooldown", 1.0))) * 0.25))


func _update_player_attack_pose(delta: float) -> void:
	if player_entity.is_empty():
		return
	player_entity["attack_pose_time"] = max(0.0, float(player_entity.get("attack_pose_time", 0.0)) - delta)


func _cast_skill(slot: Dictionary, skill_def: Dictionary) -> bool:
	if player_entity.is_empty() or skill_def.is_empty():
		return false

	var skill_level := int(slot.get("level", 1))
	var skill_id := int(skill_def.get("id", slot.get("skill_id", Catalog.BASIC_SKILL_ID)))
	var targets := _targets_for_skill(skill_def)
	if targets.is_empty() and not _skill_has_self_buff(skill_def):
		return false

	var target_ids := []
	var target_positions := []
	for enemy in targets:
		target_ids.append(int(enemy.get("runtime_id", 0)))
		target_positions.append(_dict_vec2(enemy, "position", _player_position()))

	var source_position := _player_position()
	var aim_position: Vector2 = target_positions[0] if not target_positions.is_empty() and target_positions[0] is Vector2 else source_position + last_move_vector * 90.0
	var aim_vector: Vector2 = aim_position - source_position
	if aim_vector.length_squared() <= 0.0001:
		aim_vector = last_move_vector if last_move_vector.length_squared() > 0.0001 else Vector2.DOWN
	aim_vector = aim_vector.normalized()
	player_entity["combat_facing_vector"] = aim_vector
	player_entity["attack_pose_time"] = 0.22

	var skill_name := str(slot.get("name", skill_def.get("name", "Skill")))
	var active_skill := {
		"runtime_id": next_skill_runtime_id,
		"skill_id": skill_id,
		"name": skill_name,
		"skill_def": skill_def,
		"level": max(1, skill_level),
		"elapsed": 0.0,
		"executed": [],
		"target_ids": target_ids,
		"target_positions": target_positions,
		"source_position": source_position,
		"aim_position": aim_position,
		"aim_vector": aim_vector,
		"destroyed": false,
	}
	next_skill_runtime_id += 1
	active_skills.append(active_skill)

	if _skill_has_self_buff(skill_def):
		_apply_buff_refs(player_entity, skill_def.get("selfAddBuffs", []), active_skill)

	_add_fx_event("cast", source_position, active_skill, {"target_positions": target_positions})
	_add_event(source_position + Vector2(0, -90), skill_name, Color(0.54, 0.95, 1.0))
	return true


func _update_active_skills(delta: float) -> void:
	for index in range(active_skills.size() - 1, -1, -1):
		var active_skill: Dictionary = active_skills[index]
		if bool(active_skill.get("destroyed", false)):
			active_skills.remove_at(index)
			continue

		active_skill["elapsed"] = float(active_skill.get("elapsed", 0.0)) + delta
		var elapsed_time := float(active_skill.get("elapsed", 0.0))
		var timelines: Array = active_skill.get("skill_def", {}).get("timelines", [])
		var executed: Array = active_skill.get("executed", [])
		var last_time := 0.0

		for timeline_index in range(timelines.size()):
			var timeline = timelines[timeline_index]
			if typeof(timeline) != TYPE_DICTIONARY:
				continue
			last_time = max(last_time, float(timeline.get("time", 0.0)))
			if executed.has(timeline_index) or elapsed_time < float(timeline.get("time", 0.0)):
				continue
			executed.append(timeline_index)
			_execute_skill_timeline(active_skill, timeline, timeline_index)

		_update_skill_ground_areas(active_skill, delta)
		active_skill["executed"] = executed
		var ground_areas: Array = active_skill.get("ground_areas", [])
		var has_live_ground_areas: bool = not ground_areas.is_empty()
		if bool(active_skill.get("destroyed", false)) or (not has_live_ground_areas and not timelines.is_empty() and executed.size() >= timelines.size() and elapsed_time > last_time + 0.12):
			active_skills.remove_at(index)


func _execute_skill_timeline(active_skill: Dictionary, timeline: Dictionary, timeline_index: int) -> void:
	if timeline.has("hit") and typeof(timeline.get("hit")) == TYPE_DICTIONARY:
		if _skill_uses_persistent_ground_area(active_skill.get("skill_def", {})):
			_spawn_skill_ground_area(active_skill, timeline.get("hit", {}), timeline_index)
		else:
			_execute_skill_hit(active_skill, timeline.get("hit", {}), timeline_index)

	if timeline.has("destroy"):
		active_skill["destroyed"] = true
		_add_fx_event("destroy", _skill_anchor_position(active_skill), active_skill, {})


func _execute_skill_hit(active_skill: Dictionary, hit: Dictionary, timeline_index: int) -> void:
	var max_hit: int = max(1, int(hit.get("maxHit", 1)))
	var targets: Array = _targets_from_active_skill(active_skill, max_hit)
	if targets.is_empty():
		targets = _targets_for_skill(active_skill.get("skill_def", {}), max_hit)
	if targets.is_empty():
		return

	_apply_skill_hit_to_targets(active_skill, hit, timeline_index, targets, _skill_anchor_position(active_skill))


func _spawn_skill_ground_area(active_skill: Dictionary, hit: Dictionary, timeline_index: int) -> void:
	var center := _skill_anchor_position(active_skill)
	active_skill["aim_position"] = center
	var area_duration: float = _ground_area_duration_for(active_skill, timeline_index)
	var area := {
		"runtime_id": int(active_skill.get("runtime_id", 0)) * 100 + timeline_index,
		"center": center,
		"radius_world": _hit_radius_world(hit),
		"remaining": area_duration,
		"duration": area_duration,
		"tick_timer": 0.0,
		"tick_interval": GROUND_AREA_TICK_INTERVAL,
		"hit": hit,
		"timeline_index": timeline_index,
	}
	var areas: Array = active_skill.get("ground_areas", [])
	areas.append(area)
	active_skill["ground_areas"] = areas
	_add_fx_event("area_start", center, active_skill, {
		"radius": _hit_radius(hit),
		"area_duration": area_duration,
	})


func _update_skill_ground_areas(active_skill: Dictionary, delta: float) -> void:
	var areas: Array = active_skill.get("ground_areas", [])
	if areas.is_empty():
		return

	for area_index in range(areas.size() - 1, -1, -1):
		var area: Dictionary = areas[area_index]
		area["remaining"] = float(area.get("remaining", 0.0)) - delta
		area["tick_timer"] = float(area.get("tick_timer", 0.0)) - delta
		if float(area.get("remaining", 0.0)) <= 0.0:
			areas.remove_at(area_index)
			continue
		if float(area.get("tick_timer", 0.0)) > 0.0:
			continue

		var hit: Dictionary = area.get("hit", {})
		var max_hit: int = max(1, int(hit.get("maxHit", 1)))
		var center_value = area.get("center", _skill_anchor_position(active_skill))
		var center: Vector2 = center_value if typeof(center_value) == TYPE_VECTOR2 else _skill_anchor_position(active_skill)
		var targets: Array = _targets_in_ground_area(center, float(area.get("radius_world", 0.0)), max_hit)
		if not targets.is_empty():
			_apply_skill_hit_to_targets(active_skill, hit, int(area.get("timeline_index", 0)), targets, center, "area_tick")
		area["tick_timer"] = max(0.05, float(area.get("tick_interval", GROUND_AREA_TICK_INTERVAL)))

	active_skill["ground_areas"] = areas


func _apply_skill_hit_to_targets(active_skill: Dictionary, hit: Dictionary, timeline_index: int, targets: Array, event_position: Vector2, event_kind := "hit") -> void:
	var max_hit: int = max(1, int(hit.get("maxHit", targets.size())))
	var skill_level: int = max(1, int(active_skill.get("level", 1)))
	var damage_ratio: float = _hit_damage_ratio(hit, skill_level)
	var attack_bonus: float = 1.0 + _entity_buff_stat(player_entity, "AttackPercent") / 100.0
	var base_damage: float = float(player_entity.get("attack", 80.0)) * attack_bonus * damage_ratio * _skill_power_multiplier(skill_level)
	var hit_positions := []
	var hit_buff_refs: Array = hit.get("addBuffs", [])
	for enemy in targets:
		var damage_taken_multiplier: float = max(0.1, 1.0 + _entity_buff_stat(enemy, "DamageTakenEfficiencyPercent") / 100.0)
		var defense_multiplier: float = max(0.0, 1.0 + _entity_buff_stat(enemy, "DefensePercent") / 100.0)
		var defense: float = float(enemy.get("defense", 0.0)) * defense_multiplier
		var damage: float = max(1.0, base_damage * damage_taken_multiplier - defense)
		var crit_chance: float = 0.14 + _entity_buff_stat(player_entity, "CriticalPercent") / 100.0
		if rng.randf() < crit_chance:
			damage *= 1.8 + _entity_buff_stat(player_entity, "CriticalDamagePercent") / 100.0
			_add_event(_dict_vec2(enemy, "position", _player_position()), "치명 %.0f" % damage, Color(1.0, 0.86, 0.25))
		else:
			_add_event(_dict_vec2(enemy, "position", _player_position()), "%.0f" % damage, Color(0.9, 1.0, 0.9))
		enemy["hp"] = max(0.0, float(enemy.get("hp", 0.0)) - damage)
		_apply_buff_refs(enemy, hit_buff_refs, active_skill)
		hit_positions.append(_dict_vec2(enemy, "position", _player_position()))

	_add_fx_event(event_kind, event_position, active_skill, {
		"hit_index": timeline_index,
		"hit_positions": hit_positions,
		"radius": _hit_radius(hit),
		"max_hit": max_hit,
	})


func _collect_dead_enemies() -> void:
	for index in range(entities.size() - 1, -1, -1):
		var entity = entities[index]
		if entity.get("team", "") != "enemy" or float(entity.get("hp", 0.0)) > 0.0:
			continue

		var gains: Dictionary = _reward_for_enemy(entity)
		if run_state != null:
			run_state.add_resources(gains)

		kill_count += 1
		var death_position: Vector2 = _dict_vec2(entity, "position", _player_position())
		_spawn_exp_pickup(death_position, _exp_for_enemy(entity))
		_add_event(death_position, "+%d 골드" % int(gains.get("gold", 0)), Color(1.0, 0.72, 0.22))
		entities.remove_at(index)


func _spawn_exp_pickup(world_position: Vector2, amount: int) -> void:
	var safe_amount: int = max(1, amount)
	var angle: float = rng.randf_range(0.0, TAU)
	var distance: float = rng.randf_range(18.0, 42.0)
	var pickup: Dictionary = {
		"runtime_id": next_pickup_runtime_id,
		"kind": "exp",
		"key": "exp",
		"amount": safe_amount,
		"position": _clamp_world_position(world_position + Vector2(cos(angle), sin(angle)) * distance),
		"age": 0.0,
		"armed": false,
		"color": Color(0.16, 0.72, 1.0, 0.46),
	}
	next_pickup_runtime_id += 1
	exp_pickups.append(pickup)


func _update_exp_pickups(delta: float) -> void:
	if player_entity.is_empty():
		return
	var player_pos: Vector2 = _player_position()
	for index in range(exp_pickups.size() - 1, -1, -1):
		var pickup: Dictionary = exp_pickups[index]
		pickup["age"] = float(pickup.get("age", 0.0)) + delta
		if float(pickup.get("age", 0.0)) > EXP_PICKUP_TTL:
			exp_pickups.remove_at(index)
			continue

		var armed: bool = float(pickup.get("age", 0.0)) >= EXP_PICKUP_ARM_DELAY
		pickup["armed"] = armed
		if not armed:
			continue

		var position: Vector2 = _dict_vec2(pickup, "position", player_pos)
		var distance: float = position.distance_to(player_pos)
		if distance <= EXP_PICKUP_MAGNET_RADIUS:
			var magnet_ratio: float = 1.0 - clamp(distance / EXP_PICKUP_MAGNET_RADIUS, 0.0, 1.0)
			var speed: float = EXP_PICKUP_SPEED * (0.85 + magnet_ratio * 1.4)
			position = position.move_toward(player_pos, speed * delta)
			pickup["position"] = position
			distance = position.distance_to(player_pos)

		if distance <= EXP_PICKUP_COLLECT_RADIUS:
			_collect_exp_pickup(pickup)
			exp_pickups.remove_at(index)


func _collect_exp_pickup(pickup: Dictionary) -> void:
	var amount: int = max(1, int(pickup.get("amount", 1)))
	collected_exp_count += 1
	_add_player_exp(amount)
	_add_event(_dict_vec2(pickup, "position", _player_position()), "+%d EXP" % amount, Color(0.5, 0.9, 1.0))


func spawn_encounter_for_test(encounter_type: String, offset := Vector2.ZERO) -> Dictionary:
	return _spawn_encounter(encounter_type, _clamp_world_position(_player_position() + offset), true)


func _update_encounters(delta: float) -> void:
	if player_entity.is_empty():
		return
	magnet_remaining = max(0.0, magnet_remaining - delta)
	_update_encounter_spawns(delta)

	var player_pos: Vector2 = _player_position()
	for index in range(encounter_pickups.size() - 1, -1, -1):
		var encounter: Dictionary = encounter_pickups[index]
		encounter["age"] = float(encounter.get("age", 0.0)) + delta
		if float(encounter.get("age", 0.0)) > float(encounter.get("ttl", ENCOUNTER_TTL)):
			encounter_last = "expired:%s" % str(encounter.get("type", ""))
			encounter_pickups.remove_at(index)
			continue

		var position: Vector2 = _dict_vec2(encounter, "position", player_pos)
		var distance: float = position.distance_to(player_pos)
		if str(encounter.get("type", "")) == "mine":
			if distance <= float(encounter.get("radius", ENCOUNTER_MINE_RADIUS)):
				encounter["held"] = min(float(encounter.get("hold_required", ENCOUNTER_MINE_HOLD)), float(encounter.get("held", 0.0)) + delta)
			else:
				encounter["held"] = max(0.0, float(encounter.get("held", 0.0)) - delta * 0.55)
			encounter["progress"] = clamp(float(encounter.get("held", 0.0)) / max(0.01, float(encounter.get("hold_required", ENCOUNTER_MINE_HOLD))), 0.0, 1.0)
			if float(encounter.get("held", 0.0)) >= float(encounter.get("hold_required", ENCOUNTER_MINE_HOLD)):
				_complete_mine_encounter(encounter)
				encounter_pickups.remove_at(index)
			continue

		var collect_radius := ENCOUNTER_COLLECT_RADIUS + (ENCOUNTER_MAGNET_COLLECT_BONUS if magnet_remaining > 0.0 else 0.0)
		if distance <= collect_radius:
			_collect_encounter(encounter)
			encounter_pickups.remove_at(index)


func _update_encounter_spawns(delta: float) -> void:
	if not running or player_entity.is_empty():
		return
	encounter_spawn_timer -= delta
	if encounter_spawn_timer > 0.0:
		return
	encounter_spawn_timer += ENCOUNTER_SPAWN_INTERVAL
	if encounter_pickups.size() >= ENCOUNTER_MAX_ACTIVE:
		encounter_last = "spawn:skip:max"
		return
	_spawn_encounter(_pick_weighted_encounter_type(), _random_encounter_position(), false)


func _spawn_encounter(encounter_type: String, position: Vector2, demo := false) -> Dictionary:
	var safe_type := str(encounter_type)
	if not ENCOUNTER_TYPES.has(safe_type):
		safe_type = _pick_weighted_encounter_type()
	if safe_type == "":
		return {}

	var mine_drop := _pick_mine_drop() if safe_type == "mine" else {}
	var label := str(mine_drop.get("label", ENCOUNTER_TYPE_LABELS.get(safe_type, safe_type)))
	var encounter := {
		"runtime_id": next_encounter_runtime_id,
		"kind": "encounter",
		"type": safe_type,
		"key": "encounter_%s" % safe_type,
		"label": label,
		"position": _clamp_world_position(position),
		"age": 0.0,
		"ttl": ENCOUNTER_MINE_TTL if safe_type == "mine" else ENCOUNTER_TTL,
		"radius": ENCOUNTER_MINE_RADIUS if safe_type == "mine" else ENCOUNTER_COLLECT_RADIUS,
		"held": 0.0,
		"hold_required": ENCOUNTER_MINE_HOLD if safe_type == "mine" else 0.0,
		"progress": 0.0,
		"color": _encounter_color(safe_type),
		"mine_drop": mine_drop,
		"demo": demo,
	}
	next_encounter_runtime_id += 1
	encounter_serial += 1
	encounter_pickups.append(encounter)
	encounter_last = "spawn:%s" % safe_type
	_add_event(_dict_vec2(encounter, "position", _player_position()) + Vector2(0.0, -28.0), label, Color(1.0, 0.95, 0.78))
	return encounter


func _collect_encounter(encounter: Dictionary) -> void:
	var encounter_type := str(encounter.get("type", ""))
	encounter_collected_count += 1
	encounter_last = encounter_type
	match encounter_type:
		"bomb":
			_trigger_bomb_encounter(encounter)
		"magnet":
			_trigger_magnet_encounter(encounter)
		"potion":
			_trigger_potion_encounter(encounter)
		_:
			_add_event(_dict_vec2(encounter, "position", _player_position()), str(encounter.get("label", "획득")), Color(1.0, 0.95, 0.78))


func _trigger_bomb_encounter(encounter: Dictionary) -> void:
	var hits := 0
	for enemy in _alive_enemies():
		if str(enemy.get("kind", "enemy")) == "boss":
			continue
		enemy["hp"] = 0.0
		hits += 1
	var position: Vector2 = _dict_vec2(encounter, "position", _player_position())
	_add_event(position + Vector2(0.0, -42.0), "폭발 %d" % hits, Color(1.0, 0.72, 0.24))
	_add_fx_event("encounter_bomb", position, {}, {"hits": hits, "radius": 420.0})


func _trigger_magnet_encounter(encounter: Dictionary) -> void:
	magnet_remaining = ENCOUNTER_MAGNET_DURATION
	var collected := _collect_all_exp_pickups()
	var position: Vector2 = _dict_vec2(encounter, "position", _player_position())
	var text := "경험치 회수 %d" % collected if collected > 0 else "경험치 자석"
	_add_event(position + Vector2(0.0, -42.0), text, Color(0.62, 1.0, 1.0))
	_add_fx_event("encounter_magnet", position, {}, {"collected": collected, "radius": EXP_PICKUP_MAGNET_RADIUS})


func _trigger_potion_encounter(encounter: Dictionary) -> void:
	if player_entity.is_empty():
		return
	var max_hp: float = max(1.0, float(player_entity.get("max_hp", 1.0)))
	var heal: int = max(1, int(round(max_hp * 0.32)))
	player_entity["hp"] = min(max_hp, float(player_entity.get("hp", 0.0)) + float(heal))
	_add_event(_player_position() + Vector2(0.0, -62.0), "+%d" % heal, Color(0.62, 1.0, 1.0))
	_add_fx_event("encounter_potion", _player_position(), {}, {"heal": heal})


func _complete_mine_encounter(encounter: Dictionary) -> void:
	var drop: Dictionary = encounter.get("mine_drop", {})
	if drop.is_empty():
		drop = _pick_mine_drop()
	var key := str(drop.get("key", "wood"))
	var amount: int = rng.randi_range(int(drop.get("min", 1)), int(drop.get("max", 1)))
	if run_state != null:
		run_state.add_resource(key, amount)
	encounter_mined_count += 1
	encounter_last = "mine:%s" % key
	var position: Vector2 = _dict_vec2(encounter, "position", _player_position())
	_add_event(position + Vector2(0.0, -42.0), "%s +%d" % [str(drop.get("label", "광산")), amount], Color(1.0, 0.9, 0.36))
	_add_fx_event("encounter_mine", position, {}, {"resource_key": key, "amount": amount})


func _collect_all_exp_pickups() -> int:
	var total := 0
	for index in range(exp_pickups.size() - 1, -1, -1):
		var pickup: Dictionary = exp_pickups[index]
		total += max(1, int(pickup.get("amount", 1)))
		_collect_exp_pickup(pickup)
		exp_pickups.remove_at(index)
	return total


func _pick_weighted_encounter_type() -> String:
	var total := 0
	for encounter_type in ENCOUNTER_TYPES:
		total += max(0, int(ENCOUNTER_TYPE_WEIGHTS.get(encounter_type, 0)))
	var roll := rng.randi_range(1, max(1, total))
	for encounter_type in ENCOUNTER_TYPES:
		roll -= max(0, int(ENCOUNTER_TYPE_WEIGHTS.get(encounter_type, 0)))
		if roll <= 0:
			return str(encounter_type)
	return str(ENCOUNTER_TYPES[0]) if not ENCOUNTER_TYPES.is_empty() else ""


func _pick_mine_drop() -> Dictionary:
	if MINE_RESOURCE_DROPS.is_empty():
		return {}
	return (MINE_RESOURCE_DROPS[rng.randi_range(0, MINE_RESOURCE_DROPS.size() - 1)] as Dictionary).duplicate(true)


func _random_encounter_position() -> Vector2:
	var angle := rng.randf_range(0.0, TAU)
	var distance := rng.randf_range(360.0, 720.0)
	return _clamp_world_position(_player_position() + Vector2(cos(angle), sin(angle)) * distance)


func _encounter_color(encounter_type: String) -> Color:
	match encounter_type:
		"bomb":
			return Color(1.0, 0.62, 0.22, 0.24)
		"magnet":
			return Color(0.22, 0.88, 0.84, 0.24)
		"potion":
			return Color(0.62, 1.0, 1.0, 0.24)
		"mine":
			return Color(1.0, 0.84, 0.34, 0.22)
		_:
			return Color(1.0, 0.9, 0.65, 0.2)


func _add_player_exp(amount: int) -> void:
	player_exp = max(0, player_exp + amount)
	while player_exp >= _exp_required_for_level(player_level):
		player_exp -= _exp_required_for_level(player_level)
		player_level += 1
		_maybe_queue_level_choice()
		if level_choice_pending:
			break


func _exp_for_enemy(entity: Dictionary) -> int:
	var level: int = max(1, int(entity.get("level", 1)))
	var enemy_exp: Dictionary = run_leveling_config.get("enemyExp", {})
	if str(entity.get("kind", "enemy")) == "boss":
		var boss_base: int = int(enemy_exp.get("bossBase", 8))
		var boss_per_level: int = int(enemy_exp.get("bossPerLevel", 1))
		return max(1, boss_base + level * boss_per_level)
	var normal_base: int = int(enemy_exp.get("normalBase", 1))
	var normal_level_divisor: int = max(1, int(enemy_exp.get("normalLevelDivisor", 5)))
	return max(1, normal_base + int(max(0, level - 1) / normal_level_divisor))


func _exp_required_for_level(level: int) -> int:
	var requirement: Dictionary = run_leveling_config.get("expRequirement", {})
	var level_index: int = max(0, level - 1)
	var required_by_level: Array = requirement.get("requiredByLevel", [])
	if not required_by_level.is_empty() and level_index < required_by_level.size():
		return max(1, int(required_by_level[level_index]))
	var base: float = float(requirement.get("base", DEFAULT_LEVEL_EXP_BASE))
	var linear: float = float(requirement.get("linear", DEFAULT_LEVEL_EXP_LINEAR))
	var quadratic: float = float(requirement.get("quadratic", DEFAULT_LEVEL_EXP_QUADRATIC))
	return max(1, int(round(base + linear * float(level_index) + quadratic * float(level_index * level_index))))


func _level_choice_count() -> int:
	return max(1, int(run_leveling_config.get("choiceCount", board_constants.get("levelUpChoiceCount", LEVEL_CHOICE_COUNT))))


func _max_run_skill_level() -> int:
	return max(1, int(run_leveling_config.get("maxRunSkillLevel", MAX_RUN_SKILL_LEVEL)))


func _initial_skill_ids() -> Array[int]:
	return _configured_skill_ids("initialSkillIds", Catalog.STARTER_SKILL_IDS)


func _choice_pool_skill_ids() -> Array[int]:
	return _configured_skill_ids("choicePoolSkillIds", Catalog.D1_LEVEL_CHOICE_SKILL_IDS)


func _configured_skill_ids(key: String, fallback: Array) -> Array[int]:
	var ids: Array[int] = []
	var raw = run_leveling_config.get(key, fallback)
	if typeof(raw) == TYPE_ARRAY:
		for value in raw:
			var skill_id: int = int(value)
			if skill_id > 0 and not ids.has(skill_id):
				ids.append(skill_id)
	if ids.is_empty():
		for value in fallback:
			var skill_id: int = int(value)
			if skill_id > 0 and not ids.has(skill_id):
				ids.append(skill_id)
	return ids


func _reward_for_enemy(entity: Dictionary) -> Dictionary:
	var kind := str(entity.get("kind", "enemy"))
	var gains := {
		"gold": 45 if kind == "boss" else rng.randi_range(5, 13),
		"wood": rng.randi_range(1, 3),
		"stone": 0,
		"soul": 0,
	}
	if rng.randf() < 0.18 or kind == "boss":
		gains["soul"] = 3 if kind == "boss" else 1
	if rng.randf() < 0.16:
		gains["stone"] = 1
	return gains


func _maybe_advance_wave() -> void:
	if not pending_spawns.is_empty() or not _alive_enemies().is_empty():
		return
	_start_next_wave()


func _alive_enemies() -> Array:
	var enemies := []
	for entity in entities:
		if entity.get("team", "") == "enemy" and float(entity.get("hp", 0.0)) > 0.0:
			enemies.append(entity)
	return enemies


func _nearest_enemy() -> Dictionary:
	var enemies := _nearest_enemies(1)
	return enemies[0] if enemies.size() > 0 else {}


func _nearest_enemies(limit: int) -> Array:
	var enemies := _alive_enemies()
	var player_pos: Vector2 = _player_position()
	enemies.sort_custom(func(a, b):
		var da := player_pos.distance_squared_to(_dict_vec2(a, "position", player_pos))
		var db := player_pos.distance_squared_to(_dict_vec2(b, "position", player_pos))
		return da < db
	)
	return enemies.slice(0, max(1, limit))


func _targets_for_skill(skill_def: Dictionary, limit_override := -1) -> Array:
	var max_hit: int = max(1, limit_override if limit_override > 0 else _skill_hit_max(skill_def))
	var enemies := _alive_enemies()
	if enemies.is_empty():
		return []

	var player_pos := _player_position()
	var mode := str(skill_def.get("targetRefreshType", "Nearest"))
	if mode == "Random":
		var rolled := []
		for enemy in enemies:
			rolled.append({"enemy": enemy, "roll": rng.randf()})
		rolled.sort_custom(func(a, b): return float(a.get("roll", 0.0)) < float(b.get("roll", 0.0)))
		enemies.clear()
		for entry in rolled:
			enemies.append(entry.get("enemy", {}))
	elif mode == "Furthest":
		enemies.sort_custom(func(a, b):
			var da := player_pos.distance_squared_to(_dict_vec2(a, "position", player_pos))
			var db := player_pos.distance_squared_to(_dict_vec2(b, "position", player_pos))
			return da > db
		)
	elif mode == "LowestHp":
		enemies.sort_custom(func(a, b):
			var ar: float = float(a.get("hp", 0.0)) / max(1.0, float(a.get("max_hp", 1.0)))
			var br: float = float(b.get("hp", 0.0)) / max(1.0, float(b.get("max_hp", 1.0)))
			return ar < br
		)
	elif mode == "HighestHp":
		enemies.sort_custom(func(a, b):
			var ar: float = float(a.get("hp", 0.0)) / max(1.0, float(a.get("max_hp", 1.0)))
			var br: float = float(b.get("hp", 0.0)) / max(1.0, float(b.get("max_hp", 1.0)))
			return ar > br
		)
	else:
		enemies.sort_custom(func(a, b):
			var da := player_pos.distance_squared_to(_dict_vec2(a, "position", player_pos))
			var db := player_pos.distance_squared_to(_dict_vec2(b, "position", player_pos))
			return da < db
		)
	return enemies.slice(0, max_hit)


func _targets_from_active_skill(active_skill: Dictionary, max_hit: int) -> Array:
	var targets := []
	var target_ids: Array = active_skill.get("target_ids", [])
	for runtime_id in target_ids:
		var target := _entity_by_runtime_id(int(runtime_id))
		if target.is_empty() or float(target.get("hp", 0.0)) <= 0.0:
			continue
		targets.append(target)
		if targets.size() >= max_hit:
			break
	return targets


func _targets_in_ground_area(center: Vector2, radius_world: float, max_hit: int) -> Array:
	var candidates := []
	for enemy in _alive_enemies():
		var enemy_position := _dict_vec2(enemy, "position", center)
		var body_radius := float(enemy.get("body_radius", ENEMY_BODY_RADIUS))
		var distance := center.distance_to(enemy_position)
		if distance <= radius_world + body_radius * 0.45:
			candidates.append({"enemy": enemy, "distance": distance})

	candidates.sort_custom(func(a, b): return float(a.get("distance", 0.0)) < float(b.get("distance", 0.0)))
	var targets := []
	for entry in candidates:
		var enemy: Dictionary = entry.get("enemy", {})
		if enemy.is_empty():
			continue
		targets.append(enemy)
		if targets.size() >= max(1, max_hit):
			break
	return targets


func _entity_by_runtime_id(runtime_id: int) -> Dictionary:
	for entity in entities:
		if int(entity.get("runtime_id", 0)) == runtime_id:
			return entity
	return {}


func _skill_has_hit(skill_def: Dictionary) -> bool:
	for timeline in skill_def.get("timelines", []):
		if typeof(timeline) == TYPE_DICTIONARY and timeline.has("hit"):
			return true
	return false


func _skill_has_self_buff(skill_def: Dictionary) -> bool:
	var refs = skill_def.get("selfAddBuffs", [])
	return typeof(refs) == TYPE_ARRAY and not refs.is_empty()


func _skill_uses_persistent_ground_area(skill_def: Dictionary) -> bool:
	var tags = skill_def.get("tags", [])
	return typeof(tags) == TYPE_ARRAY and (tags.has("GroundArea") or tags.has("PersistentTerrain"))


func _skill_hit_max(skill_def: Dictionary) -> int:
	var max_hit := 1
	for timeline in skill_def.get("timelines", []):
		if typeof(timeline) != TYPE_DICTIONARY:
			continue
		var hit = timeline.get("hit", {})
		if typeof(hit) == TYPE_DICTIONARY:
			max_hit = max(max_hit, int(hit.get("maxHit", 1)))
	return max_hit


func _hit_damage_ratio(hit: Dictionary, skill_level: int) -> float:
	var add_damage = hit.get("addDamage", {})
	if typeof(add_damage) != TYPE_DICTIONARY:
		return 1.0
	var ratios = add_damage.get("attackPercentDamages", [])
	return max(0.0, _level_value(ratios, skill_level, 1.0))


func _hit_radius(hit: Dictionary) -> float:
	for geometry in hit.get("geometries", []):
		if typeof(geometry) != TYPE_DICTIONARY:
			continue
		var circle = geometry.get("circle", {})
		if typeof(circle) == TYPE_DICTIONARY:
			return float(circle.get("radius", 1.0))
	return 1.0


func _hit_radius_world(hit: Dictionary) -> float:
	return max(40.0, _hit_radius(hit) * SKILL_GEOMETRY_WORLD_SCALE)


func _ground_area_duration_for(active_skill: Dictionary, timeline_index: int) -> float:
	var timelines: Array = active_skill.get("skill_def", {}).get("timelines", [])
	var start_time := 0.0
	if timeline_index >= 0 and timeline_index < timelines.size():
		var start_timeline = timelines[timeline_index]
		if typeof(start_timeline) == TYPE_DICTIONARY:
			start_time = float(start_timeline.get("time", 0.0))
	for index in range(timeline_index + 1, timelines.size()):
		var timeline = timelines[index]
		if typeof(timeline) == TYPE_DICTIONARY and timeline.has("destroy"):
			return max(0.1, float(timeline.get("time", start_time)) - start_time)
	return 2.0


func _level_value(values, level: int, fallback := 0.0) -> float:
	if typeof(values) == TYPE_ARRAY and not values.is_empty():
		var index: int = clamp(max(1, int(level)) - 1, 0, values.size() - 1)
		return float(values[index])
	if typeof(values) == TYPE_FLOAT or typeof(values) == TYPE_INT:
		return float(values)
	return fallback


func _skill_power_multiplier(skill_level: int) -> float:
	return max(1.0, 1.0 + float(max(1, skill_level) - 1) * SKILL_LEVEL_DAMAGE_BONUS)


func _cooldown_for_skill(skill_def: Dictionary) -> float:
	var cooldown: float = max(0.35, float(skill_def.get("cooldown", 1.0)))
	var cooldown_percent: float = _entity_buff_stat(player_entity, "CooldownPercent")
	var attack_speed_percent: float = _entity_buff_stat(player_entity, "AttackSpeedPercent")
	cooldown *= max(0.25, 1.0 - cooldown_percent / 100.0)
	cooldown /= max(0.4, 1.0 + attack_speed_percent / 100.0)
	return max(0.25, cooldown)


func _skill_anchor_position(active_skill: Dictionary) -> Vector2:
	var positions: Array = active_skill.get("target_positions", [])
	if not positions.is_empty() and positions[0] is Vector2:
		return positions[0]
	var source = active_skill.get("source_position", _player_position())
	return source if source is Vector2 else _player_position()


func _apply_buff_refs(entity: Dictionary, buff_refs: Array, active_skill: Dictionary) -> void:
	if entity.is_empty() or buff_refs.is_empty() or store == null:
		return
	var active_buffs: Array = entity.get("active_buffs", [])
	for buff_ref in buff_refs:
		if typeof(buff_ref) != TYPE_DICTIONARY:
			continue
		var buff_id := int(buff_ref.get("buffDataId", 0))
		var buff_def: Dictionary = store.get_record("Buffs", buff_id)
		if buff_def.is_empty():
			continue
		var duration: float = float(buff_ref.get("duration", buff_def.get("duration", 0.0)))
		if duration <= 0.0:
			continue
		var source_duration_bonus: float = _entity_buff_stat(player_entity, "BuffDurationEfficiencyPercent")
		duration *= max(0.1, 1.0 + source_duration_bonus / 100.0)
		var level: int = max(1, int(buff_ref.get("level", active_skill.get("level", 1))))

		for index in range(active_buffs.size() - 1, -1, -1):
			var existing: Dictionary = active_buffs[index]
			if int(existing.get("buff_id", 0)) == buff_id:
				active_buffs.remove_at(index)

		active_buffs.append({
			"buff_id": buff_id,
			"buff_def": buff_def,
			"level": level,
			"remaining": duration,
			"duration": duration,
			"source_skill_id": int(active_skill.get("skill_id", 0)),
		})
		_add_fx_event("buff", _dict_vec2(entity, "position", _player_position()), active_skill, {
			"buff_id": buff_id,
			"buff_name": str(buff_def.get("name", "")),
			"target_id": int(entity.get("runtime_id", 0)),
		})
	entity["active_buffs"] = active_buffs


func _update_buffs(delta: float) -> void:
	for entity in entities:
		var active_buffs: Array = entity.get("active_buffs", [])
		if active_buffs.is_empty():
			continue
		for index in range(active_buffs.size() - 1, -1, -1):
			var buff: Dictionary = active_buffs[index]
			buff["remaining"] = float(buff.get("remaining", 0.0)) - delta
			if float(buff.get("remaining", 0.0)) <= 0.0:
				active_buffs.remove_at(index)
		entity["active_buffs"] = active_buffs


func _entity_buff_stat(entity: Dictionary, stat_type: String) -> float:
	var total := 0.0
	for active_buff in entity.get("active_buffs", []):
		if typeof(active_buff) != TYPE_DICTIONARY:
			continue
		var buff_def: Dictionary = active_buff.get("buff_def", {})
		var level := int(active_buff.get("level", 1))
		for stat in buff_def.get("addStats", []):
			if typeof(stat) != TYPE_DICTIONARY or str(stat.get("type", "")) != stat_type:
				continue
			total += _level_value(stat.get("value", []), level, 0.0)
	return total


func _add_fx_event(kind: String, world_position: Vector2, active_skill: Dictionary, extra := {}) -> void:
	var event := {
		"id": next_fx_event_id,
		"kind": kind,
		"skill_id": int(active_skill.get("skill_id", 0)),
		"skill_name": str(active_skill.get("name", "")),
		"position": world_position,
		"source_position": active_skill.get("source_position", _player_position()),
		"aim_position": active_skill.get("aim_position", world_position),
		"aim_vector": active_skill.get("aim_vector", Vector2.ZERO),
		"life": FX_EVENT_LIFETIME,
	}
	for key in extra.keys():
		event[key] = extra[key]
	next_fx_event_id += 1
	fx_events.append(event)
	while fx_events.size() > MAX_FX_EVENTS:
		fx_events.pop_front()


func _decay_fx_events(delta: float) -> void:
	for index in range(fx_events.size() - 1, -1, -1):
		var event: Dictionary = fx_events[index]
		event["life"] = float(event.get("life", 0.0)) - delta
		if float(event.get("life", 0.0)) <= 0.0:
			fx_events.remove_at(index)


func _random_edge_position() -> Vector2:
	var player_pos: Vector2 = _player_position()
	var angle := rng.randf_range(0.0, TAU)
	var radius := rng.randf_range(430.0, 620.0)
	var pos: Vector2 = player_pos + Vector2(cos(angle), sin(angle)) * radius
	pos.x = clamp(pos.x, 120.0, world_size.x - 120.0)
	pos.y = clamp(pos.y, 120.0, world_size.y - 120.0)
	return pos


func _current_wave() -> Dictionary:
	if wave_index >= 0 and wave_index < wave_plan.size():
		return wave_plan[wave_index]
	return {}


func _pending_count() -> int:
	var total := 0
	for spec in pending_spawns:
		total += int(spec.get("count", 0))
	return total


func _objective_text() -> String:
	var wave: Dictionary = _current_wave()
	if bool(wave.get("is_boss", false)) or boss_spawned:
		return "두령 출현"
	return str(map_def.get("name", "대나무 숲 정화"))


func _wave_progress() -> float:
	var wave: Dictionary = _current_wave()
	var total: int = int(wave.get("total_count", 1))
	if total < 1:
		total = 1
	var remaining: int = _pending_count() + _alive_enemies().size()
	return clamp(1.0 - float(remaining) / float(total), 0.0, 1.0)


func _stage_progress() -> float:
	if visual_fixture:
		return 0.62
	var count: int = wave_plan.size()
	if count < 1:
		count = 1
	var completed: int = clamp(wave_index, 0, count)
	return clamp((float(completed) + _wave_progress()) / float(count), 0.0, 1.0)


func _display_player_level() -> int:
	if visual_fixture:
		return 18
	return player_level


func _display_player_exp() -> int:
	if visual_fixture:
		return 1280
	return player_exp


func _display_exp_to_next() -> int:
	if visual_fixture:
		return 2100
	return _exp_required_for_level(player_level)


func _display_exp_ratio() -> float:
	if visual_fixture:
		return clamp(float(_display_player_exp()) / float(max(1, _display_exp_to_next())), 0.0, 1.0)
	return clamp(float(player_exp) / float(max(1, _exp_required_for_level(player_level))), 0.0, 1.0)


func _pickup_count() -> int:
	return collected_exp_count + encounter_collected_count + encounter_mined_count


func _active_ground_area_count() -> int:
	var count := 0
	for active_skill in active_skills:
		if typeof(active_skill) != TYPE_DICTIONARY:
			continue
		var areas: Array = active_skill.get("ground_areas", [])
		count += areas.size()
	return count


func _active_ground_area_snapshots() -> Array:
	var snapshots := []
	for active_skill in active_skills:
		if typeof(active_skill) != TYPE_DICTIONARY:
			continue
		var skill_id := int(active_skill.get("skill_id", 0))
		var skill_name := str(active_skill.get("name", ""))
		for area in active_skill.get("ground_areas", []):
			if typeof(area) != TYPE_DICTIONARY:
				continue
			var center_value = area.get("center", _skill_anchor_position(active_skill))
			var center: Vector2 = center_value if typeof(center_value) == TYPE_VECTOR2 else _skill_anchor_position(active_skill)
			var duration: float = max(0.1, float(area.get("duration", 0.1)))
			var remaining: float = max(0.0, float(area.get("remaining", 0.0)))
			snapshots.append({
				"runtime_id": int(area.get("runtime_id", int(active_skill.get("runtime_id", 0)))),
				"skill_id": skill_id,
				"skill_name": skill_name,
				"position": center,
				"radius_world": float(area.get("radius_world", 0.0)),
				"duration": duration,
				"remaining": remaining,
				"progress": clamp(1.0 - remaining / duration, 0.0, 1.0),
			})
	return snapshots


func _player_position() -> Vector2:
	if player_entity.is_empty():
		return world_size * 0.5
	return _dict_vec2(player_entity, "position", world_size * 0.5)


func _clamp_world_position(position: Vector2) -> Vector2:
	return Vector2(
		clamp(position.x, PLAYER_EDGE_PADDING, world_size.x - PLAYER_EDGE_PADDING),
		clamp(position.y, PLAYER_EDGE_PADDING, world_size.y - PLAYER_EDGE_PADDING)
	)


func _dash_snapshot() -> Dictionary:
	return {
		"active": dash_active,
		"ready": running and not dash_active and dash_cooldown_remaining <= 0.0,
		"cooldown": dash_cooldown_remaining,
		"cooldown_progress": clamp(1.0 - dash_cooldown_remaining / PLAYER_DASH_COOLDOWN, 0.0, 1.0),
		"invulnerable": dash_invulnerable_remaining > 0.0,
		"count": dash_count,
		"blocked_damage_count": dash_blocked_damage_count,
		"last_source": last_dash_source,
		"last_vector": last_move_vector,
	}


func _resources() -> Dictionary:
	if run_state != null:
		return run_state.resources
	return {"gold": 0, "wood": 0, "stone": 0, "soul": 0}


func _resource_gains() -> Dictionary:
	var gains := {}
	var current := _resources()
	for key in Catalog.RESOURCE_KEYS:
		gains[key] = max(0, int(current.get(key, 0)) - int(run_start_resources.get(key, 0)))
	return gains


func _dict_vec2(source: Dictionary, key: String, fallback: Vector2) -> Vector2:
	var value = source.get(key, fallback)
	if typeof(value) == TYPE_VECTOR2:
		return value
	return fallback


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
		event["position"] = _dict_vec2(event, "position", Vector2.ZERO) + Vector2(0.0, -32.0 * delta)
		if float(event["life"]) <= 0.0:
			floating_events.remove_at(index)


func _finish(new_result: String) -> void:
	if not running:
		return
	running = false
	result = new_result
	last_report = {
		"result": result,
		"map_id": map_id,
		"map_name": str(map_def.get("name", "")),
		"elapsed": elapsed,
		"wave": max(1, wave_index + 1),
		"wave_count": wave_plan.size(),
		"kill_count": kill_count,
		"resources": _resources().duplicate(true),
		"resource_gains": _resource_gains(),
	}
	if run_state != null:
		run_state.record_run(last_report)
		run_state.save()
