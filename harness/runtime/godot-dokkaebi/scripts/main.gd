extends Control

const VIEW_SIZE := Vector2(540.0, 960.0)
const WORLD_SIZE := Vector2(3400.0, 3400.0)
const WORLD_CENTER := WORLD_SIZE * 0.5
const PLAYER_SPEED := 292.0
const PLAYER_MAX_HP := 620.0
const BASE_ATTACK_DAMAGE := 43.0
const ATTACK_COOLDOWN := 0.52
const ATTACK_RADIUS := 188.0
const ATTACK_ARC_DEGREES := 138.0
const PICKUP_COLLECT_RADIUS := 34.0
const PICKUP_MAGNET_RADIUS := 182.0
const PICKUP_SPEED := 690.0
const MAX_ENEMIES := 108
const RUN_SECONDS := 180.0

var rng := RandomNumberGenerator.new()
var player := {
	"pos": WORLD_CENTER,
	"hp": PLAYER_MAX_HP,
	"max_hp": PLAYER_MAX_HP,
	"facing": Vector2.RIGHT,
}
var enemies: Array = []
var pickups: Array = []
var fx_events: Array = []
var level_choices: Array = []
var skill_levels := {
	"vortex": 0,
	"wave": 0,
	"spiritfire": 0,
	"ward": 0,
}
var skill_timers := {
	"vortex": 1.3,
	"wave": 2.0,
	"spiritfire": 1.0,
	"ward": 4.2,
}
var elapsed := 0.0
var spawn_timer := 0.0
var attack_timer := 0.0
var run_level := 1
var run_exp := 0
var exp_to_next := 18
var kills := 0
var purified := 0
var next_id := 1
var running := true
var result := ""
var choice_pending := false
var injected_move := Vector2.ZERO
var use_injected_move := false
var test_mode := false
var camera_pos := WORLD_CENTER


func _ready() -> void:
	rng.randomize()
	custom_minimum_size = VIEW_SIZE
	mouse_filter = Control.MOUSE_FILTER_PASS
	restart_run()


func restart_run() -> void:
	player = {
		"pos": WORLD_CENTER,
		"hp": PLAYER_MAX_HP,
		"max_hp": PLAYER_MAX_HP,
		"facing": Vector2.RIGHT,
	}
	enemies.clear()
	pickups.clear()
	fx_events.clear()
	level_choices.clear()
	skill_levels = {
		"vortex": 0,
		"wave": 0,
		"spiritfire": 0,
		"ward": 0,
	}
	skill_timers = {
		"vortex": 1.1,
		"wave": 1.8,
		"spiritfire": 0.8,
		"ward": 3.4,
	}
	elapsed = 0.0
	spawn_timer = 0.0
	attack_timer = 0.12
	run_level = 1
	run_exp = 0
	exp_to_next = 18
	kills = 0
	purified = 0
	next_id = 1
	running = true
	result = ""
	choice_pending = false
	camera_pos = WORLD_CENTER
	for i in range(30):
		_spawn_enemy("japgwi", i * TAU / 30.0, 520.0 + float(i % 5) * 42.0)
	queue_redraw()


func set_test_mode(enabled: bool) -> void:
	test_mode = enabled
	if enabled:
		rng.seed = 47031


func inject_move(vector: Vector2) -> void:
	use_injected_move = true
	injected_move = vector.limit_length(1.0)


func clear_injected_move() -> void:
	use_injected_move = false
	injected_move = Vector2.ZERO


func debug_snapshot() -> Dictionary:
	return {
		"running": running,
		"result": result,
		"elapsed": elapsed,
		"level": run_level,
		"exp": run_exp,
		"exp_to_next": exp_to_next,
		"kills": kills,
		"purified": purified,
		"enemy_count": enemies.size(),
		"pickup_count": pickups.size(),
		"choice_pending": choice_pending,
		"skills": skill_levels.duplicate(true),
		"player_hp": player.get("hp", 0.0),
		"player_pos": player.get("pos", Vector2.ZERO),
	}


func choose_card(index: int) -> bool:
	if not choice_pending:
		return false
	if index < 0 or index >= level_choices.size():
		return false
	var card: Dictionary = level_choices[index]
	var key: String = str(card.get("key", ""))
	if not skill_levels.has(key):
		return false
	skill_levels[key] = int(skill_levels.get(key, 0)) + 1
	choice_pending = false
	level_choices.clear()
	_add_fx(_player_pos(), "choice", str(card.get("name", "스킬 강화")), Color(1.0, 0.86, 0.42))
	return true


func _process(delta: float) -> void:
	var dt: float = min(delta, 1.0 / 30.0)
	if not running:
		if Input.is_action_just_pressed("ui_accept") or Input.is_key_pressed(KEY_R):
			restart_run()
		queue_redraw()
		return
	if choice_pending:
		_handle_choice_input()
		_update_fx(dt)
		queue_redraw()
		return

	_handle_run_input(dt)
	_update_run(dt)
	queue_redraw()


func _handle_run_input(dt: float) -> void:
	if Input.is_key_pressed(KEY_R):
		restart_run()
		return
	var move := Vector2.ZERO
	if use_injected_move:
		move = injected_move
	else:
		move.x = Input.get_axis("ui_left", "ui_right")
		move.y = Input.get_axis("ui_up", "ui_down")
		if Input.is_key_pressed(KEY_A):
			move.x -= 1.0
		if Input.is_key_pressed(KEY_D):
			move.x += 1.0
		if Input.is_key_pressed(KEY_W):
			move.y -= 1.0
		if Input.is_key_pressed(KEY_S):
			move.y += 1.0
	move = move.limit_length(1.0)
	if move.length_squared() > 0.001:
		player["facing"] = move.normalized()
		player["pos"] = _clamp_world(_player_pos() + move * PLAYER_SPEED * dt)


func _handle_choice_input() -> void:
	if Input.is_key_pressed(KEY_1):
		choose_card(0)
	elif Input.is_key_pressed(KEY_2):
		choose_card(1)
	elif Input.is_key_pressed(KEY_3):
		choose_card(2)
	elif Input.is_action_just_pressed("ui_accept"):
		choose_card(0)


func _update_run(dt: float) -> void:
	elapsed += dt
	spawn_timer -= dt
	attack_timer -= dt
	_update_camera(dt)
	_update_spawns()
	_update_enemies(dt)
	_update_player_attack()
	_update_skills(dt)
	_update_pickups(dt)
	_update_fx(dt)
	_check_result()


func _update_camera(dt: float) -> void:
	camera_pos = camera_pos.lerp(_player_pos(), min(1.0, dt * 6.0))


func _update_spawns() -> void:
	if enemies.size() >= MAX_ENEMIES or spawn_timer > 0.0:
		return
	var batch := 6 + int(elapsed / 24.0)
	if elapsed > 85.0:
		batch += 3
	if elapsed > 135.0:
		batch += 4
	for i in range(batch):
		var kind := "japgwi"
		var roll := rng.randf()
		if elapsed > 95.0 and roll > 0.72:
			kind = "talisman_caster"
		elif elapsed > 55.0 and roll > 0.58:
			kind = "ghost"
		elif elapsed > 25.0 and roll > 0.36:
			kind = "grunt"
		if elapsed > 125.0 and i == 0 and not _has_boss():
			kind = "night_ogre"
		_spawn_enemy(kind, rng.randf_range(0.0, TAU), rng.randf_range(560.0, 760.0))
	spawn_timer = max(0.22, 0.78 - elapsed * 0.0024)


func _spawn_enemy(kind: String, angle: float, distance: float) -> void:
	var base := _enemy_stats(kind)
	var pos := _clamp_world(_player_pos() + Vector2(cos(angle), sin(angle)) * distance)
	base["id"] = next_id
	base["pos"] = pos
	base["hit_flash"] = 0.0
	next_id += 1
	enemies.append(base)


func _enemy_stats(kind: String) -> Dictionary:
	match kind:
		"ghost":
			return {"kind": kind, "name": "망령", "hp": 46.0, "max_hp": 46.0, "speed": 112.0, "damage": 9.0, "radius": 22.0, "exp": 2}
		"grunt":
			return {"kind": kind, "name": "도깨비 하수", "hp": 72.0, "max_hp": 72.0, "speed": 92.0, "damage": 15.0, "radius": 27.0, "exp": 3}
		"talisman_caster":
			return {"kind": kind, "name": "부적술사", "hp": 58.0, "max_hp": 58.0, "speed": 84.0, "damage": 12.0, "radius": 24.0, "exp": 4}
		"night_ogre":
			return {"kind": kind, "name": "밤도깨비 장군", "hp": 580.0, "max_hp": 580.0, "speed": 62.0, "damage": 28.0, "radius": 56.0, "exp": 18}
		_:
			return {"kind": "japgwi", "name": "잡귀", "hp": 31.0, "max_hp": 31.0, "speed": 132.0, "damage": 7.0, "radius": 20.0, "exp": 1}


func _update_enemies(dt: float) -> void:
	var p := _player_pos()
	for enemy in enemies:
		var pos: Vector2 = enemy.get("pos", p)
		var dir: Vector2 = p - pos
		var dist: float = max(1.0, dir.length())
		var desired: Vector2 = dir / dist
		var speed: float = float(enemy.get("speed", 90.0))
		enemy["pos"] = _clamp_world(pos + desired * speed * dt)
		enemy["hit_flash"] = max(0.0, float(enemy.get("hit_flash", 0.0)) - dt)
		if dist < float(enemy.get("radius", 24.0)) + 24.0:
			player["hp"] = max(0.0, float(player.get("hp", 0.0)) - float(enemy.get("damage", 10.0)) * dt)
	_separate_enemies()


func _separate_enemies() -> void:
	for pass_index in range(2):
		for i in range(enemies.size()):
			var a: Dictionary = enemies[i]
			var apos: Vector2 = a.get("pos", Vector2.ZERO)
			for j in range(i + 1, enemies.size()):
				var b: Dictionary = enemies[j]
				var bpos: Vector2 = b.get("pos", Vector2.ZERO)
				var diff := apos - bpos
				var min_dist: float = float(a.get("radius", 22.0)) + float(b.get("radius", 22.0)) + 3.0
				var dist: float = diff.length()
				if dist <= 0.01 or dist >= min_dist:
					continue
				var push := diff.normalized() * (min_dist - dist) * 0.25
				a["pos"] = _clamp_world(apos + push)
				b["pos"] = _clamp_world(bpos - push)
				apos = a["pos"]


func _update_player_attack() -> void:
	if attack_timer > 0.0:
		return
	attack_timer = ATTACK_COOLDOWN * max(0.62, 1.0 - _skill_level("ward") * 0.05)
	var target: Dictionary = _nearest_enemy()
	var p := _player_pos()
	if not target.is_empty():
		var dir: Vector2 = target.get("pos", p) - p
		if dir.length_squared() > 0.001:
			player["facing"] = dir.normalized()
	var facing: Vector2 = player.get("facing", Vector2.RIGHT)
	var damage: float = BASE_ATTACK_DAMAGE * (1.0 + float(_skill_level("wave")) * 0.13)
	var hit_count := 0
	for enemy in enemies:
		var offset: Vector2 = enemy.get("pos", p) - p
		var dist: float = offset.length()
		if dist > ATTACK_RADIUS:
			continue
		var angle: float = abs(facing.angle_to(offset.normalized()))
		if angle <= deg_to_rad(ATTACK_ARC_DEGREES * 0.5):
			_damage_enemy(enemy, damage, "slash")
			hit_count += 1
	if hit_count > 0:
		_add_fx(p + facing * 76.0, "water_slash", "수류 창격", Color(0.45, 0.86, 1.0), facing)


func _update_skills(dt: float) -> void:
	for key in skill_timers.keys():
		if _skill_level(key) <= 0:
			continue
		skill_timers[key] = float(skill_timers.get(key, 0.0)) - dt
	if _skill_level("vortex") > 0 and float(skill_timers.get("vortex", 0.0)) <= 0.0:
		_cast_vortex()
		skill_timers["vortex"] = max(1.7, 3.6 - float(_skill_level("vortex")) * 0.32)
	if _skill_level("wave") > 0 and float(skill_timers.get("wave", 0.0)) <= 0.0:
		_cast_wave()
		skill_timers["wave"] = max(2.8, 5.3 - float(_skill_level("wave")) * 0.25)
	if _skill_level("spiritfire") > 0 and float(skill_timers.get("spiritfire", 0.0)) <= 0.0:
		_cast_spiritfire()
		skill_timers["spiritfire"] = max(0.8, 1.7 - float(_skill_level("spiritfire")) * 0.08)
	if _skill_level("ward") > 0 and float(skill_timers.get("ward", 0.0)) <= 0.0:
		_cast_ward()
		skill_timers["ward"] = 6.2


func _cast_vortex() -> void:
	var p := _player_pos()
	var radius := 164.0 + float(_skill_level("vortex")) * 22.0
	for enemy in enemies:
		var offset: Vector2 = enemy.get("pos", p) - p
		if offset.length() <= radius:
			_damage_enemy(enemy, 22.0 + 9.0 * _skill_level("vortex"), "vortex")
			enemy["pos"] = _clamp_world(enemy.get("pos", p).lerp(p, 0.08))
	_add_fx(p, "vortex", "물소용돌이", Color(0.25, 0.74, 1.0))


func _cast_wave() -> void:
	var p := _player_pos()
	var facing: Vector2 = player.get("facing", Vector2.RIGHT)
	for enemy in enemies:
		var offset: Vector2 = enemy.get("pos", p) - p
		var dist := offset.length()
		if dist > 250.0:
			continue
		if abs(facing.angle_to(offset.normalized())) <= deg_to_rad(46.0):
			_damage_enemy(enemy, 32.0 + 10.0 * _skill_level("wave"), "wave")
			enemy["pos"] = _clamp_world(enemy.get("pos", p) + facing * 88.0)
	_add_fx(p + facing * 120.0, "wave", "파도 밀어내기", Color(0.34, 0.82, 1.0), facing)


func _cast_spiritfire() -> void:
	var target := _nearest_enemy()
	if target.is_empty():
		return
	_damage_enemy(target, 36.0 + 12.0 * _skill_level("spiritfire"), "spiritfire")
	_add_fx(target.get("pos", _player_pos()), "spiritfire", "도깨비불", Color(0.26, 0.95, 0.82))


func _cast_ward() -> void:
	player["hp"] = min(float(player.get("max_hp", PLAYER_MAX_HP)), float(player.get("hp", 0.0)) + 22.0 + 8.0 * _skill_level("ward"))
	_add_fx(_player_pos(), "ward", "수호 물결", Color(0.58, 0.94, 1.0))


func _damage_enemy(enemy: Dictionary, amount: float, source: String) -> void:
	enemy["hp"] = float(enemy.get("hp", 1.0)) - amount
	enemy["hit_flash"] = 0.11
	if float(enemy.get("hp", 0.0)) <= 0.0:
		_kill_enemy(enemy, source)


func _kill_enemy(enemy: Dictionary, source: String) -> void:
	if not enemies.has(enemy):
		return
	enemies.erase(enemy)
	kills += 1
	purified += int(enemy.get("exp", 1))
	var pos: Vector2 = enemy.get("pos", _player_pos())
	_spawn_pickup(pos, int(enemy.get("exp", 1)))
	if str(enemy.get("kind", "")) == "night_ogre":
		_add_fx(pos, "boss_down", "요괴 장군 정화", Color(1.0, 0.62, 0.28))
	elif source != "slash":
		_add_fx(pos, "purify", "정화", Color(0.64, 0.96, 1.0))


func _spawn_pickup(pos: Vector2, value: int) -> void:
	pickups.append({
		"id": next_id,
		"pos": pos + Vector2(rng.randf_range(-18.0, 18.0), rng.randf_range(-10.0, 16.0)),
		"value": value,
		"age": 0.0,
	})
	next_id += 1


func _update_pickups(dt: float) -> void:
	var p := _player_pos()
	for pickup in pickups.duplicate():
		pickup["age"] = float(pickup.get("age", 0.0)) + dt
		var pos: Vector2 = pickup.get("pos", p)
		var dist := pos.distance_to(p)
		if dist <= PICKUP_COLLECT_RADIUS:
			_collect_pickup(pickup)
			continue
		if dist <= PICKUP_MAGNET_RADIUS:
			pickup["pos"] = pos.move_toward(p, PICKUP_SPEED * dt)


func _collect_pickup(pickup: Dictionary) -> void:
	if not pickups.has(pickup):
		return
	pickups.erase(pickup)
	run_exp += int(pickup.get("value", 1))
	while run_exp >= exp_to_next and not choice_pending:
		run_exp -= exp_to_next
		run_level += 1
		exp_to_next = 12 + (run_level - 1) * 10 + int(pow(run_level - 1, 2) * 1.4)
		_queue_level_choice()


func _queue_level_choice() -> void:
	choice_pending = true
	level_choices.clear()
	var cards := [
		{"key": "vortex", "name": "물소용돌이", "summary": "주변 요귀를 끌어당기며 반복 피해"},
		{"key": "wave", "name": "파도 밀어내기", "summary": "전방 요귀를 밀어내고 창격 강화"},
		{"key": "spiritfire", "name": "도깨비불", "summary": "가까운 요귀를 추적하는 불꽃"},
		{"key": "ward", "name": "수호 물결", "summary": "회복과 공속 보조"},
	]
	var offset := (run_level + kills) % cards.size()
	for i in range(3):
		var card: Dictionary = cards[(offset + i) % cards.size()].duplicate(true)
		card["next_level"] = _skill_level(str(card.get("key", ""))) + 1
		level_choices.append(card)
	_add_fx(_player_pos(), "level", "영력 각성", Color(1.0, 0.88, 0.48))


func _update_fx(dt: float) -> void:
	for fx in fx_events.duplicate():
		fx["ttl"] = float(fx.get("ttl", 0.0)) - dt
		if float(fx.get("ttl", 0.0)) <= 0.0:
			fx_events.erase(fx)


func _add_fx(pos: Vector2, kind: String, label: String, color: Color, dir := Vector2.RIGHT) -> void:
	fx_events.append({
		"pos": pos,
		"kind": kind,
		"label": label,
		"color": color,
		"dir": dir,
		"ttl": 0.55 if kind != "level" else 1.1,
		"life": 0.55 if kind != "level" else 1.1,
	})
	if fx_events.size() > 42:
		fx_events.pop_front()


func _check_result() -> void:
	if float(player.get("hp", 0.0)) <= 0.0:
		running = false
		result = "defeat"
	elif elapsed >= RUN_SECONDS:
		running = false
		result = "clear"


func _draw() -> void:
	var rect := Rect2(Vector2.ZERO, size)
	if rect.size.x <= 0.0 or rect.size.y <= 0.0:
		rect.size = VIEW_SIZE
	draw_rect(rect, Color(0.035, 0.058, 0.045))
	_draw_world()
	_draw_entities()
	_draw_fx()
	_draw_hud()
	if choice_pending:
		_draw_level_choices()
	if not running:
		_draw_result()


func _draw_world() -> void:
	var bg_rect := Rect2(Vector2.ZERO, size)
	draw_rect(bg_rect, Color(0.075, 0.155, 0.105))
	var grid_color := Color(0.13, 0.23, 0.16, 0.34)
	var tile := 128.0
	var camera_mod := Vector2(fmod(camera_pos.x, tile), fmod(camera_pos.y, tile))
	var start_x := -camera_mod.x
	while start_x < size.x + tile:
		draw_line(Vector2(start_x, 0), Vector2(start_x, size.y), grid_color, 1.0)
		start_x += tile
	var start_y := -camera_mod.y
	while start_y < size.y + tile:
		draw_line(Vector2(0, start_y), Vector2(size.x, start_y), grid_color, 1.0)
		start_y += tile
	_draw_tangtang_props()
	_draw_vignette()


func _draw_environment_props() -> void:
	var props := [
		{"pos": WORLD_CENTER + Vector2(-520, -290), "kind": "bamboo"},
		{"pos": WORLD_CENTER + Vector2(420, -360), "kind": "gate"},
		{"pos": WORLD_CENTER + Vector2(-420, 330), "kind": "stone"},
		{"pos": WORLD_CENTER + Vector2(580, 260), "kind": "lantern"},
		{"pos": WORLD_CENTER + Vector2(120, -520), "kind": "talisman"},
	]
	for prop in props:
		var sp: Vector2 = _world_to_screen(prop.get("pos", WORLD_CENTER))
		match str(prop.get("kind", "")):
			"bamboo":
				for i in range(4):
					var x := sp.x + float(i) * 8.0
					draw_line(Vector2(x, sp.y - 54.0), Vector2(x - 4.0, sp.y + 24.0), Color(0.21, 0.44, 0.25), 3.0)
				draw_circle(sp + Vector2(10, -42), 24.0, Color(0.15, 0.34, 0.19, 0.65))
			"gate":
				draw_rect(Rect2(sp.x - 54, sp.y - 44, 108, 18), Color(0.13, 0.07, 0.04))
				draw_rect(Rect2(sp.x - 46, sp.y - 64, 92, 18), Color(0.09, 0.14, 0.18))
				draw_rect(Rect2(sp.x - 42, sp.y - 26, 12, 58), Color(0.42, 0.12, 0.08))
				draw_rect(Rect2(sp.x + 30, sp.y - 26, 12, 58), Color(0.42, 0.12, 0.08))
			"stone":
				draw_circle(sp, 31, Color(0.25, 0.27, 0.24))
				draw_circle(sp + Vector2(25, 12), 19, Color(0.19, 0.21, 0.19))
			"lantern":
				draw_line(sp + Vector2(0, -50), sp + Vector2(0, 38), Color(0.09, 0.06, 0.04), 4.0)
				draw_circle(sp + Vector2(0, -22), 12, Color(0.92, 0.62, 0.22, 0.92))
			"talisman":
				draw_rect(Rect2(sp.x - 12, sp.y - 36, 24, 64), Color(0.92, 0.78, 0.45))
				draw_line(sp + Vector2(-8, -18), sp + Vector2(8, -18), Color(0.48, 0.09, 0.06), 2.0)


func _draw_tangtang_props() -> void:
	var world_props := [
		{"pos": WORLD_CENTER + Vector2(-520, -360), "kind": "stone"},
		{"pos": WORLD_CENTER + Vector2(540, -300), "kind": "stone"},
		{"pos": WORLD_CENTER + Vector2(-620, 420), "kind": "bamboo"},
		{"pos": WORLD_CENTER + Vector2(620, 510), "kind": "bamboo"},
		{"pos": WORLD_CENTER + Vector2(-220, -620), "kind": "talisman"},
		{"pos": WORLD_CENTER + Vector2(360, 680), "kind": "talisman"},
		{"pos": WORLD_CENTER + Vector2(-760, 80), "kind": "soul"},
		{"pos": WORLD_CENTER + Vector2(760, -40), "kind": "soul"},
	]
	for prop in world_props:
		var sp: Vector2 = _world_to_screen(prop.get("pos", WORLD_CENTER))
		if sp.x < -80 or sp.y < -80 or sp.x > size.x + 80 or sp.y > size.y + 80:
			continue
		match str(prop.get("kind", "")):
			"stone":
				_draw_soft_ellipse(sp + Vector2(0, 18), Vector2(72, 24), Color(0, 0, 0, 0.18))
				draw_circle(sp, 25, Color(0.18, 0.22, 0.19, 0.72))
				draw_circle(sp + Vector2(23, 9), 17, Color(0.12, 0.16, 0.14, 0.72))
			"bamboo":
				for i in range(5):
					var x: float = sp.x + float(i) * 9.0
					draw_line(Vector2(x, sp.y - 46.0), Vector2(x - 4.0, sp.y + 26.0), Color(0.20, 0.44, 0.24, 0.68), 3.0)
				draw_circle(sp + Vector2(14, -38), 24, Color(0.12, 0.31, 0.18, 0.58))
			"talisman":
				draw_rect(Rect2(sp.x - 9, sp.y - 22, 18, 46), Color(0.86, 0.70, 0.38, 0.72))
				draw_line(sp + Vector2(-5, -7), sp + Vector2(5, -7), Color(0.58, 0.11, 0.07, 0.88), 2.0)
			"soul":
				draw_circle(sp, 11, Color(0.18, 0.84, 0.74, 0.42))
				draw_circle(sp, 4, Color(0.66, 1.0, 0.93, 0.78))


func _draw_vignette() -> void:
	draw_rect(Rect2(0.0, 0.0, size.x, 70.0), Color(0.0, 0.0, 0.0, 0.24))
	draw_rect(Rect2(0.0, size.y - 96.0, size.x, 96.0), Color(0.0, 0.0, 0.0, 0.24))
	draw_rect(Rect2(0.0, 0.0, 18.0, size.y), Color(0.0, 0.0, 0.0, 0.12))
	draw_rect(Rect2(size.x - 18.0, 0.0, 18.0, size.y), Color(0.0, 0.0, 0.0, 0.12))


func _draw_ground_decoration() -> void:
	var path_color := Color(0.16, 0.18, 0.15, 0.52)
	var path_shadow := Color(0.02, 0.025, 0.02, 0.18)
	var path_points := PackedVector2Array([
		Vector2(-80, 340),
		Vector2(190, 230),
		Vector2(620, 420),
		Vector2(620, 510),
		Vector2(170, 312),
		Vector2(-80, 428),
	])
	draw_colored_polygon(path_points, path_shadow)
	var inner_path := PackedVector2Array([
		Vector2(-40, 350),
		Vector2(188, 258),
		Vector2(590, 436),
		Vector2(590, 480),
		Vector2(172, 300),
		Vector2(-40, 402),
	])
	draw_colored_polygon(inner_path, path_color)
	for i in range(8):
		var p := Vector2(34.0 + float(i) * 68.0, 356.0 + sin(float(i)) * 28.0)
		_draw_soft_ellipse(p, Vector2(44, 19), Color(0.23, 0.25, 0.22, 0.45))
	for p in [Vector2(70, 205), Vector2(430, 185), Vector2(478, 642), Vector2(108, 676)]:
		_draw_soft_ellipse(p + Vector2(0, 22), Vector2(58, 20), Color(0, 0, 0, 0.18))
		draw_circle(p, 24, Color(0.18, 0.22, 0.19, 0.7))
		draw_circle(p + Vector2(18, 8), 15, Color(0.12, 0.16, 0.14, 0.7))
	for p in [Vector2(55, 285), Vector2(505, 303), Vector2(462, 575)]:
		draw_circle(p, 9, Color(0.18, 0.82, 0.72, 0.45))
		draw_circle(p, 4, Color(0.62, 1.0, 0.92, 0.75))
	for p in [Vector2(142, 166), Vector2(396, 712)]:
		draw_rect(Rect2(p.x - 8, p.y - 22, 16, 43), Color(0.82, 0.68, 0.38, 0.72))
		draw_line(p + Vector2(-5, -9), p + Vector2(5, -9), Color(0.55, 0.10, 0.07, 0.8), 2.0)


func _draw_entities() -> void:
	var drawables := []
	for enemy in enemies:
		drawables.append({"team": "enemy", "data": enemy, "y": _screen_y(enemy.get("pos", Vector2.ZERO))})
	drawables.append({"team": "player", "data": player, "y": _screen_y(_player_pos())})
	drawables.sort_custom(func(a, b): return float(a.get("y", 0.0)) < float(b.get("y", 0.0)))
	for pickup in pickups:
		_draw_pickup(pickup)
	for item in drawables:
		if str(item.get("team", "")) == "enemy":
			_draw_enemy(item.get("data", {}))
		else:
			_draw_player()


func _draw_pickup(pickup: Dictionary) -> void:
	var sp: Vector2 = _world_to_screen(pickup.get("pos", WORLD_CENTER))
	var pulse: float = 1.0 + sin(float(pickup.get("age", 0.0)) * 8.0) * 0.1
	draw_circle(sp, 7.0 * pulse, Color(0.33, 0.91, 1.0, 0.92))
	draw_circle(sp, 3.5 * pulse, Color(0.84, 1.0, 1.0, 1.0))


func _draw_player() -> void:
	var sp := _world_to_screen(_player_pos())
	_draw_soft_ellipse(sp + Vector2(0, 24), Vector2(58, 18), Color(0, 0, 0, 0.28))
	var facing: Vector2 = player.get("facing", Vector2.RIGHT)
	var spear_tip := sp + facing * 54.0 + Vector2(0, -12)
	draw_line(sp + Vector2(0, -10), spear_tip, Color(0.83, 0.86, 0.82), 4.0)
	draw_circle(spear_tip, 5.0, Color(0.94, 0.98, 1.0))
	draw_rect(Rect2(sp.x - 18, sp.y - 23, 36, 44), Color(0.045, 0.095, 0.15))
	draw_rect(Rect2(sp.x - 14, sp.y - 19, 28, 37), Color(0.11, 0.32, 0.52))
	draw_circle(sp + Vector2(0, -37), 19, Color(0.89, 0.68, 0.48))
	draw_arc(sp + Vector2(0, -43), 22, PI * 1.08, PI * 1.92, 18, Color(0.02, 0.04, 0.06), 7.0)
	draw_line(sp + Vector2(-22, -47), sp + Vector2(22, -47), Color(0.03, 0.19, 0.39), 6.0)
	draw_rect(Rect2(sp.x - 7, sp.y - 57, 14, 10), Color(0.83, 0.61, 0.24))
	draw_circle(sp + Vector2(8, -38), 2.4, Color(0.02, 0.02, 0.02))
	draw_circle(sp + Vector2(-8, -38), 2.4, Color(0.02, 0.02, 0.02))
	draw_line(sp + Vector2(15, -8), sp + Vector2(29, 1), Color(0.72, 0.08, 0.06), 6.0)


func _draw_enemy(enemy: Dictionary) -> void:
	var sp: Vector2 = _world_to_screen(enemy.get("pos", WORLD_CENTER))
	var kind: String = str(enemy.get("kind", "japgwi"))
	var flash: bool = float(enemy.get("hit_flash", 0.0)) > 0.0
	var base := Color(0.14, 0.13, 0.12)
	var accent := Color(0.88, 0.23, 0.14)
	var radius: float = float(enemy.get("radius", 22.0))
	match kind:
		"ghost":
			base = Color(0.26, 0.55, 0.58, 0.72)
			accent = Color(0.62, 0.95, 0.94)
		"grunt":
			base = Color(0.35, 0.18, 0.12)
			accent = Color(0.91, 0.42, 0.18)
		"talisman_caster":
			base = Color(0.22, 0.16, 0.27)
			accent = Color(0.92, 0.74, 0.38)
		"night_ogre":
			base = Color(0.28, 0.08, 0.06)
			accent = Color(1.0, 0.46, 0.15)
		_:
			base = Color(0.11, 0.1, 0.1)
			accent = Color(0.85, 0.24, 0.18)
	if flash:
		base = Color(0.95, 0.92, 0.84)
	_draw_soft_ellipse(sp + Vector2(0, radius * 0.65), Vector2(radius * 1.7, radius * 0.46), Color(0, 0, 0, 0.24))
	draw_circle(sp, radius, base)
	if kind == "night_ogre":
		draw_arc(sp, radius + 14.0, 0.0, TAU, 48, Color(1.0, 0.26, 0.12, 0.55), 4.0)
		draw_line(sp + Vector2(-23, -33), sp + Vector2(-38, -58), accent, 5.0)
		draw_line(sp + Vector2(23, -33), sp + Vector2(38, -58), accent, 5.0)
	elif kind == "talisman_caster":
		draw_rect(Rect2(sp.x - 7, sp.y - radius - 17, 14, 26), accent)
	elif kind == "ghost":
		draw_arc(sp + Vector2(0, 12), radius * 0.75, 0.1, PI - 0.1, 16, accent, 3.0)
	else:
		draw_line(sp + Vector2(-10, -radius + 4), sp + Vector2(-18, -radius - 14), accent, 3.0)
		draw_line(sp + Vector2(10, -radius + 4), sp + Vector2(18, -radius - 14), accent, 3.0)
	draw_circle(sp + Vector2(-7, -5), 3.0, accent)
	draw_circle(sp + Vector2(7, -5), 3.0, accent)
	var hp_ratio: float = clamp(float(enemy.get("hp", 1.0)) / max(1.0, float(enemy.get("max_hp", 1.0))), 0.0, 1.0)
	if hp_ratio < 0.98:
		draw_rect(Rect2(sp.x - radius, sp.y - radius - 15, radius * 2.0, 4), Color(0.1, 0.02, 0.02, 0.72))
		draw_rect(Rect2(sp.x - radius, sp.y - radius - 15, radius * 2.0 * hp_ratio, 4), Color(0.9, 0.22, 0.13, 0.92))


func _draw_fx() -> void:
	for fx in fx_events:
		var pos: Vector2 = fx.get("pos", WORLD_CENTER)
		var sp: Vector2 = _world_to_screen(pos)
		var ttl: float = float(fx.get("ttl", 0.0))
		var life: float = max(0.01, float(fx.get("life", 0.55)))
		var t: float = 1.0 - ttl / life
		var color: Color = fx.get("color", Color.WHITE)
		color.a = 0.75 * (1.0 - t)
		match str(fx.get("kind", "")):
			"water_slash":
				var dir_slash: Vector2 = fx.get("dir", Vector2.RIGHT)
				var start: float = dir_slash.angle() - 0.85
				draw_arc(sp, 74.0 + t * 22.0, start, start + 1.7, 24, color, 9.0)
			"vortex":
				draw_arc(sp, 106.0 + t * 30.0, t * TAU, t * TAU + PI * 1.55, 36, color, 6.0)
				draw_arc(sp, 68.0 + t * 20.0, -t * TAU, -t * TAU + PI * 1.2, 28, color, 4.0)
			"wave":
				var dir_wave: Vector2 = fx.get("dir", Vector2.RIGHT)
				draw_arc(sp, 118.0 + t * 42.0, dir_wave.angle() - 0.55, dir_wave.angle() + 0.55, 24, color, 11.0)
			"spiritfire":
				draw_circle(sp, 18.0 + t * 20.0, color)
			"ward", "level":
				draw_arc(sp, 56.0 + t * 46.0, 0.0, TAU, 48, color, 5.0)
			_:
				draw_circle(sp, 18.0 + t * 18.0, color)
		if str(fx.get("label", "")) != "":
			draw_string(ThemeDB.fallback_font, sp + Vector2(-34, -62 - t * 20.0), str(fx.get("label", "")), HORIZONTAL_ALIGNMENT_LEFT, -1.0, 15, Color(color.r, color.g, color.b, max(0.0, 1.0 - t)))


func _draw_hud() -> void:
	_draw_top_hud()
	_draw_wave_track(Rect2(8.0, 106.0, size.x - 16.0, 18.0))
	_draw_controls()
	_draw_exp_bar()


func _draw_top_hud() -> void:
	var left_rect := Rect2(8.0, 8.0, 188.0, 90.0)
	var timer_rect := Rect2(204.0, 8.0, 132.0, 90.0)
	var ledger_rect := Rect2(344.0, 8.0, 142.0, 90.0)
	var pause_rect := Rect2(494.0, 8.0, 38.0, 54.0)
	_draw_panel(left_rect, Color(0.045, 0.038, 0.03, 0.86), Color(0.78, 0.58, 0.28))
	_draw_panel(timer_rect, Color(0.04, 0.035, 0.03, 0.9), Color(0.78, 0.58, 0.28))
	_draw_panel(ledger_rect, Color(0.045, 0.038, 0.032, 0.84), Color(0.61, 0.46, 0.23))
	_draw_panel(pause_rect, Color(0.045, 0.038, 0.032, 0.84), Color(0.71, 0.55, 0.29))

	var portrait := Vector2(45.0, 49.0)
	draw_circle(portrait, 30.0, Color(0.09, 0.18, 0.31))
	draw_circle(portrait + Vector2(0, 4), 22.0, Color(0.88, 0.68, 0.48))
	draw_arc(portrait + Vector2(0, -4), 25.0, PI * 1.03, PI * 1.94, 18, Color(0.02, 0.035, 0.055), 7.0)
	draw_line(portrait + Vector2(-24, -10), portrait + Vector2(24, -10), Color(0.03, 0.19, 0.39), 6.0)
	draw_rect(Rect2(portrait.x - 8, portrait.y - 26, 16, 10), Color(0.84, 0.62, 0.24))
	draw_string(ThemeDB.fallback_font, left_rect.position + Vector2(82, 30), "해일", HORIZONTAL_ALIGNMENT_LEFT, -1.0, 18, Color(0.98, 0.90, 0.68))
	draw_string(ThemeDB.fallback_font, left_rect.position + Vector2(82, 51), "Lv.%d  영력 %d" % [run_level, purified], HORIZONTAL_ALIGNMENT_LEFT, -1.0, 13, Color(0.70, 0.93, 1.0))
	_draw_bar(Rect2(left_rect.position + Vector2(82, 63), Vector2(88, 9)), float(player.get("hp", 0.0)) / PLAYER_MAX_HP, Color(0.88, 0.18, 0.12), Color(0.14, 0.04, 0.035))
	draw_string(ThemeDB.fallback_font, left_rect.position + Vector2(80, 82), "HP %d/%d" % [int(player.get("hp", 0.0)), int(PLAYER_MAX_HP)], HORIZONTAL_ALIGNMENT_LEFT, -1.0, 10, Color(0.80, 0.74, 0.60))

	draw_string(ThemeDB.fallback_font, timer_rect.position + Vector2(0, 31), _format_time(RUN_SECONDS - elapsed), HORIZONTAL_ALIGNMENT_CENTER, timer_rect.size.x, 27, Color(1.0, 0.91, 0.62))
	draw_line(timer_rect.position + Vector2(18, 47), timer_rect.position + Vector2(timer_rect.size.x - 18, 47), Color(0.76, 0.58, 0.30, 0.42), 1.0)
	draw_string(ThemeDB.fallback_font, timer_rect.position + Vector2(0, 67), "STAGE %d/3" % _stage_index(), HORIZONTAL_ALIGNMENT_CENTER, timer_rect.size.x, 15, Color(0.93, 0.74, 0.34))
	_draw_stage_pips(timer_rect.position + Vector2(31, 79))

	_draw_ledger_row(ledger_rect.position + Vector2(12, 24), "처치", kills, Color(1.0, 0.76, 0.28))
	_draw_ledger_row(ledger_rect.position + Vector2(12, 47), "요귀", enemies.size(), Color(0.74, 0.92, 1.0))
	_draw_ledger_row(ledger_rect.position + Vector2(12, 70), "정화", purified, Color(0.55, 0.96, 0.88))
	draw_string(ThemeDB.fallback_font, pause_rect.position + Vector2(0, 36), "Ⅱ", HORIZONTAL_ALIGNMENT_CENTER, pause_rect.size.x, 24, Color(0.98, 0.86, 0.58))


func _draw_controls() -> void:
	var joy := Vector2(88.0, size.y - 134.0)
	draw_circle(joy, 64.0, Color(0.0, 0.0, 0.0, 0.30))
	draw_arc(joy, 64.0, 0.0, TAU, 56, Color(0.92, 0.84, 0.62, 0.50), 2.0)
	for marker in [Vector2(0, -42), Vector2(42, 0), Vector2(0, 42), Vector2(-42, 0)]:
		draw_rect(Rect2(joy + marker - Vector2(4, 4), Vector2(8, 8)), Color(0.88, 0.84, 0.66, 0.26))
	draw_circle(joy, 27.0, Color(0.88, 0.78, 0.58, 0.34))

	_draw_action_button(Vector2(size.x - 76.0, size.y - 144.0), 42.0, "wave", "파", true)
	_draw_action_button(Vector2(size.x - 140.0, size.y - 92.0), 37.0, "vortex", "소", false)
	_draw_action_button(Vector2(size.x - 68.0, size.y - 86.0), 37.0, "spiritfire", "불", false)


func _draw_exp_bar() -> void:
	var rect := Rect2(28.0, size.y - 38.0, size.x - 56.0, 28.0)
	_draw_panel(rect, Color(0.025, 0.035, 0.035, 0.88), Color(0.72, 0.54, 0.27))
	_draw_panel(Rect2(rect.position + Vector2(4, 4), Vector2(84, 20)), Color(0.035, 0.05, 0.05, 0.94), Color(0.98, 0.72, 0.26))
	draw_string(ThemeDB.fallback_font, rect.position + Vector2(4, 18), "영력 Lv.%d" % run_level, HORIZONTAL_ALIGNMENT_CENTER, 84.0, 12, Color(0.70, 0.93, 1.0))
	var track := Rect2(rect.position + Vector2(98, 8), Vector2(rect.size.x - 190.0, 12))
	var exp_ratio: float = clamp(float(run_exp) / max(1.0, float(exp_to_next)), 0.0, 1.0)
	_draw_bar(track, exp_ratio, Color(0.20, 0.68, 1.0), Color(0.035, 0.055, 0.07))
	draw_string(ThemeDB.fallback_font, rect.position + Vector2(rect.size.x - 86, 18), "%d/%d" % [run_exp, exp_to_next], HORIZONTAL_ALIGNMENT_CENTER, 78.0, 12, Color(0.73, 0.92, 1.0))


func _draw_level_choices() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.0, 0.0, 0.0, 0.58))
	var panel := Rect2(14.0, 264.0, size.x - 28.0, 430.0)
	_draw_panel(panel, Color(0.86, 0.72, 0.43, 0.98), Color(0.16, 0.09, 0.04))
	draw_string(ThemeDB.fallback_font, panel.position + Vector2(22, 52), "레벨 업!", HORIZONTAL_ALIGNMENT_LEFT, -1.0, 34, Color(0.11, 0.07, 0.03))
	_draw_panel(Rect2(panel.position + Vector2(panel.size.x - 116, 34), Vector2(88, 52)), Color(0.20, 0.12, 0.05, 0.94), Color(0.82, 0.60, 0.30))
	draw_string(ThemeDB.fallback_font, panel.position + Vector2(panel.size.x - 116, 58), "Lv.%d" % run_level, HORIZONTAL_ALIGNMENT_CENTER, 88.0, 14, Color(1.0, 0.88, 0.62))
	draw_string(ThemeDB.fallback_font, panel.position + Vector2(panel.size.x - 116, 78), "%d 처치" % kills, HORIZONTAL_ALIGNMENT_CENTER, 88.0, 12, Color(0.88, 0.78, 0.58))
	draw_string(ThemeDB.fallback_font, panel.position + Vector2(24, 82), "이번 원정에서 성장할 수련을 선택하세요", HORIZONTAL_ALIGNMENT_LEFT, -1.0, 14, Color(0.20, 0.12, 0.06))
	for i in range(level_choices.size()):
		var card: Dictionary = level_choices[i]
		var rect := Rect2(32.0 + float(i) * 164.0, 366.0, 148.0, 250.0)
		_draw_panel(rect, Color(0.98, 0.78, 0.34, 0.98), Color(0.16, 0.09, 0.04))
		_draw_panel(Rect2(rect.position + Vector2(8, 8), Vector2(rect.size.x - 16, 28)), Color(1.0, 0.74, 0.22, 0.98), Color(0.16, 0.09, 0.04))
		draw_string(ThemeDB.fallback_font, rect.position + Vector2(8, 29), "NEW", HORIZONTAL_ALIGNMENT_CENTER, rect.size.x - 16, 13, Color(0.16, 0.09, 0.04))
		var icon_color: Color = _skill_color(str(card.get("key", "")))
		draw_circle(rect.position + Vector2(rect.size.x * 0.5, 72), 31.0, Color(0.08, 0.07, 0.045))
		draw_circle(rect.position + Vector2(rect.size.x * 0.5, 72), 23.0, icon_color)
		draw_string(ThemeDB.fallback_font, rect.position + Vector2(0, 126), str(card.get("name", "")), HORIZONTAL_ALIGNMENT_CENTER, rect.size.x, 17, Color(0.14, 0.08, 0.03))
		_draw_level_pips(rect.position + Vector2(45, 144), int(card.get("next_level", 1)))
		draw_multiline_string(ThemeDB.fallback_font, rect.position + Vector2(16, 178), str(card.get("summary", "")), HORIZONTAL_ALIGNMENT_CENTER, rect.size.x - 32, 14, 5, Color(0.23, 0.14, 0.07))
		_draw_panel(Rect2(rect.position + Vector2(12, 218), Vector2(rect.size.x - 24, 24)), Color(0.07, 0.14, 0.10, 0.96), Color(0.10, 0.10, 0.06))
		draw_string(ThemeDB.fallback_font, rect.position + Vector2(12, 236), "%d 선택" % (i + 1), HORIZONTAL_ALIGNMENT_CENTER, rect.size.x - 24, 13, Color(0.92, 0.86, 0.62))


func _draw_result() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.0, 0.0, 0.0, 0.62))
	var rect := Rect2(76.0, 216.0, size.x - 152.0, 570.0)
	_draw_panel(rect, Color(0.88, 0.72, 0.43, 0.98), Color(0.15, 0.08, 0.04))
	_draw_panel(Rect2(rect.position + Vector2(24, 38), Vector2(rect.size.x - 48, 92)), Color(0.11, 0.08, 0.055, 0.95), Color(0.70, 0.45, 0.18))
	draw_circle(rect.position + Vector2(rect.size.x * 0.5, 34), 44.0, Color(0.05, 0.12, 0.11))
	draw_circle(rect.position + Vector2(rect.size.x * 0.5, 34), 28.0, Color(0.90, 0.60, 0.22))
	var title := "정화 완료" if result == "clear" else "정화 실패"
	var title_color := Color(1.0, 0.85, 0.42) if result == "clear" else Color(1.0, 0.38, 0.28)
	draw_string(ThemeDB.fallback_font, rect.position + Vector2(0, 104), title, HORIZONTAL_ALIGNMENT_CENTER, rect.size.x, 34, title_color)
	var stat_y := rect.position.y + 160.0
	_draw_stat_chip(Vector2(rect.position.x + 30, stat_y), "시간", _format_time(elapsed))
	_draw_stat_chip(Vector2(rect.position.x + 135, stat_y), "처치", str(kills))
	_draw_stat_chip(Vector2(rect.position.x + 240, stat_y), "진행", "%d/3" % _stage_index())
	_draw_result_reward(rect.position + Vector2(18, 258), "엽전", kills * 9 + purified * 3)
	_draw_result_reward(rect.position + Vector2(18, 306), "영력", purified)
	_draw_result_reward(rect.position + Vector2(18, 354), "부적 조각", max(1, run_level - 1))
	_draw_panel(Rect2(rect.position + Vector2(88, 480), Vector2(rect.size.x - 176, 46)), Color(0.86, 0.27, 0.05, 0.96), Color(0.13, 0.07, 0.03))
	draw_string(ThemeDB.fallback_font, rect.position + Vector2(88, 511), "다시 원정", HORIZONTAL_ALIGNMENT_CENTER, rect.size.x - 176, 18, Color(1.0, 0.88, 0.62))


func _draw_wave_track(rect: Rect2) -> void:
	_draw_panel(rect, Color(0.025, 0.045, 0.04, 0.78), Color(0.70, 0.52, 0.26))
	var label_rect := Rect2(rect.position + Vector2(4, 22), Vector2(154, 18))
	_draw_panel(label_rect, Color(0.05, 0.09, 0.07, 0.76), Color(0.24, 0.46, 0.32))
	draw_string(ThemeDB.fallback_font, label_rect.position + Vector2(8, 14), "도깨비 숲 초입", HORIZONTAL_ALIGNMENT_LEFT, label_rect.size.x - 16, 11, Color(0.92, 0.80, 0.38))
	var fill_width := rect.size.x * _wave_progress_ratio()
	draw_rect(Rect2(rect.position + Vector2(4, 5), Vector2(max(8.0, fill_width - 8.0), 8)), Color(0.24, 0.88, 0.78, 0.86))
	for i in range(8):
		var x := rect.position.x + 4.0 + float(i) * ((rect.size.x - 8.0) / 8.0)
		draw_line(Vector2(x, rect.position.y + 4.0), Vector2(x, rect.position.y + rect.size.y - 4.0), Color(0.02, 0.03, 0.025, 0.70), 1.0)


func _draw_stage_pips(origin: Vector2) -> void:
	for i in range(6):
		var pos := origin + Vector2(float(i) * 12.0, 0.0)
		var filled := i < _stage_index() * 2
		draw_circle(pos, 4.0, Color(0.22, 0.88, 0.82) if filled else Color(0.18, 0.24, 0.22))


func _draw_ledger_row(origin: Vector2, label: String, value: int, icon_color: Color) -> void:
	draw_circle(origin + Vector2(7, -5), 5.0, icon_color)
	draw_string(ThemeDB.fallback_font, origin + Vector2(20, 0), label, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 12, Color(0.78, 0.70, 0.52))
	draw_string(ThemeDB.fallback_font, origin + Vector2(72, 0), str(value), HORIZONTAL_ALIGNMENT_RIGHT, 50.0, 12, Color(0.96, 0.90, 0.72))


func _draw_action_button(pos: Vector2, radius: float, key: String, label: String, primary: bool) -> void:
	var learned := key == "wave" or _skill_level(key) > 0
	var rim_color := Color(0.83, 0.62, 0.30) if primary else Color(0.70, 0.52, 0.28)
	draw_circle(pos, radius + 4.0, Color(0.02, 0.025, 0.025, 0.88))
	draw_arc(pos, radius + 2.0, 0.0, TAU, 54, rim_color, 4.0)
	draw_circle(pos, radius - 8.0, _skill_color(key) if learned else Color(0.20, 0.20, 0.18))
	draw_string(ThemeDB.fallback_font, pos + Vector2(-radius, 7), label, HORIZONTAL_ALIGNMENT_CENTER, radius * 2.0, 22 if primary else 19, Color.WHITE if learned else Color(0.66, 0.60, 0.50))
	if learned:
		var cooldown: float = max(0.0, float(skill_timers.get(key, 0.0)))
		if key != "wave" and cooldown > 0.15:
			draw_circle(pos, radius - 8.0, Color(0.0, 0.0, 0.0, 0.36))
			draw_string(ThemeDB.fallback_font, pos + Vector2(-radius, 6), "%.1f" % cooldown, HORIZONTAL_ALIGNMENT_CENTER, radius * 2.0, 15, Color(1.0, 0.92, 0.72))
		draw_string(ThemeDB.fallback_font, pos + Vector2(-radius, radius - 2.0), "Lv.%d" % max(1, _skill_level(key)), HORIZONTAL_ALIGNMENT_CENTER, radius * 2.0, 10, Color(0.72, 0.92, 1.0))


func _draw_level_pips(origin: Vector2, level: int) -> void:
	for i in range(5):
		var color := Color(0.97, 0.58, 0.18) if i < level else Color(0.50, 0.40, 0.26)
		draw_rect(Rect2(origin + Vector2(float(i) * 12.0, 0.0), Vector2(8, 8)), color)


func _draw_stat_chip(origin: Vector2, label: String, value: String) -> void:
	_draw_panel(Rect2(origin, Vector2(84, 58)), Color(0.22, 0.14, 0.07, 0.94), Color(0.62, 0.42, 0.20))
	draw_string(ThemeDB.fallback_font, origin + Vector2(0, 20), label, HORIZONTAL_ALIGNMENT_CENTER, 84.0, 12, Color(0.84, 0.76, 0.58))
	draw_string(ThemeDB.fallback_font, origin + Vector2(0, 45), value, HORIZONTAL_ALIGNMENT_CENTER, 84.0, 17, Color(1.0, 0.88, 0.62))


func _draw_result_reward(origin: Vector2, label: String, value: int) -> void:
	var rect := Rect2(origin, Vector2(352, 38))
	_draw_panel(rect, Color(0.96, 0.78, 0.38, 0.92), Color(0.36, 0.22, 0.10))
	draw_circle(origin + Vector2(20, 19), 10.0, Color(0.90, 0.52, 0.16))
	draw_string(ThemeDB.fallback_font, origin + Vector2(42, 25), label, HORIZONTAL_ALIGNMENT_LEFT, 190.0, 14, Color(0.18, 0.10, 0.04))
	draw_string(ThemeDB.fallback_font, origin + Vector2(240, 25), "+%d" % value, HORIZONTAL_ALIGNMENT_RIGHT, 92.0, 17, Color(0.14, 0.08, 0.03))


func _skill_color(key: String) -> Color:
	match key:
		"vortex":
			return Color(0.16, 0.58, 0.96)
		"wave":
			return Color(0.12, 0.68, 0.94)
		"spiritfire":
			return Color(0.22, 0.90, 0.78)
		"ward":
			return Color(0.58, 0.94, 1.0)
		_:
			return Color(0.32, 0.48, 0.55)


func _format_time(seconds: float) -> String:
	var total: int = max(0, int(seconds))
	return "%02d:%02d" % [int(total / 60), total % 60]


func _stage_index() -> int:
	return clamp(int(floor(elapsed / max(1.0, RUN_SECONDS / 3.0))) + 1, 1, 3)


func _wave_progress_ratio() -> float:
	var stage_len := RUN_SECONDS / 3.0
	var stage_elapsed := fmod(elapsed, stage_len)
	if elapsed >= RUN_SECONDS:
		stage_elapsed = stage_len
	return clamp((float(_stage_index() - 1) + stage_elapsed / stage_len) / 3.0, 0.0, 1.0)


func _draw_panel(rect: Rect2, fill: Color, stroke: Color) -> void:
	draw_rect(rect, fill)
	draw_rect(rect, stroke, false, 2.0)
	draw_rect(Rect2(rect.position + Vector2(4, 4), rect.size - Vector2(8, 8)), Color(1.0, 0.84, 0.42, 0.08), false, 1.0)


func _draw_bar(rect: Rect2, ratio: float, fill: Color, back: Color) -> void:
	draw_rect(rect, back)
	draw_rect(Rect2(rect.position, Vector2(rect.size.x * clamp(ratio, 0.0, 1.0), rect.size.y)), fill)
	draw_rect(rect, Color(0.92, 0.75, 0.42, 0.65), false, 1.0)


func _nearest_enemy() -> Dictionary:
	var best := {}
	var best_dist := INF
	var p := _player_pos()
	for enemy in enemies:
		var dist := p.distance_squared_to(enemy.get("pos", p))
		if dist < best_dist:
			best_dist = dist
			best = enemy
	return best


func _has_boss() -> bool:
	for enemy in enemies:
		if str(enemy.get("kind", "")) == "night_ogre":
			return true
	return false


func _skill_level(key: String) -> int:
	return int(skill_levels.get(key, 0))


func _player_pos() -> Vector2:
	return player.get("pos", WORLD_CENTER)


func _clamp_world(pos: Vector2) -> Vector2:
	return Vector2(clamp(pos.x, 80.0, WORLD_SIZE.x - 80.0), clamp(pos.y, 80.0, WORLD_SIZE.y - 80.0))


func _world_to_screen(pos: Vector2) -> Vector2:
	var delta := pos - camera_pos
	return size * 0.5 + delta


func _screen_y(pos: Vector2) -> float:
	return _world_to_screen(pos).y


func _draw_soft_ellipse(position: Vector2, ellipse_size: Vector2, color: Color) -> void:
	var points := PackedVector2Array()
	for i in range(28):
		var a := float(i) / 28.0 * TAU
		points.append(position + Vector2(cos(a) * ellipse_size.x * 0.5, sin(a) * ellipse_size.y * 0.5))
	draw_colored_polygon(points, color)
