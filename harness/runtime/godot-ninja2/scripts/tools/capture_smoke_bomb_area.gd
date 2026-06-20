extends SceneTree

const MainScene := preload("res://scripts/main.gd")

const OUTPUT_PATH := "res://screenshots/godot-ninja2-smoke-bomb-area.png"
const VIEW_SIZE := Vector2i(540, 1016)


func _init() -> void:
	call_deferred("_capture")


func _capture() -> void:
	var root := get_root()
	root.size = VIEW_SIZE
	DisplayServer.window_set_size(VIEW_SIZE)

	var main := MainScene.new()
	main.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.add_child(main)

	await process_frame
	await process_frame
	main._start_battle(500101)
	await process_frame

	_prepare_smoke_fixture(main)
	for _index in range(26):
		await process_frame

	var viewport_texture = root.get_texture()
	if viewport_texture == null:
		_fail("smoke bomb area capture requires a non-headless renderer")
		return

	var image: Image = viewport_texture.get_image()
	if image == null or image.is_empty():
		_fail("smoke bomb area capture produced an empty viewport image")
		return

	var output := ProjectSettings.globalize_path(OUTPUT_PATH)
	var err := image.save_png(output)
	if err != OK:
		_fail("smoke bomb area capture failed: %s" % error_string(err))
		return

	print("godot-ninja2 smoke bomb area capture: %s" % output)
	quit(0)


func _prepare_smoke_fixture(main: Control) -> void:
	var sim = main.sim
	if sim == null:
		return
	sim.pending_spawns.clear()
	sim.exp_pickups.clear()
	for index in range(sim.entities.size() - 1, -1, -1):
		var entity: Dictionary = sim.entities[index]
		if str(entity.get("team", "")) == "enemy":
			sim.entities.remove_at(index)

	var skill_def: Dictionary = main.store.get_skill(300103)
	sim.skill_slots = [{
		"skill_id": 300103,
		"name": str(skill_def.get("name", "연막 폭탄")),
		"cooldown": 10.0,
		"timer": 0.0,
		"level": 1,
	}]

	var player_position: Vector2 = sim.snapshot().get("player", {}).get("position", Vector2.ZERO)
	var smoke_center := player_position + Vector2(360.0, 0.0)
	sim.entities.append(_make_enemy(9001, smoke_center))
	sim.entities.append(_make_enemy(9002, smoke_center + Vector2(70.0, 42.0)))
	main._sync_battle()


func _make_enemy(runtime_id: int, position: Vector2) -> Dictionary:
	return {
		"runtime_id": runtime_id,
		"data_id": 110201,
		"name": "연막 캡처 허수",
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


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
