extends SceneTree

const MainScene := preload("res://scripts/main.gd")
const Catalog := preload("res://scripts/core/ninja2_catalog.gd")

const OUTPUT_PATH := "res://screenshots/godot-ninja2-basic-skill.png"
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

	_prepare_basic_skill_fixture(main)
	for _index in range(14):
		await process_frame

	var viewport_texture = root.get_texture()
	if viewport_texture == null:
		_fail("basic skill capture requires a non-headless renderer")
		return

	var image: Image = viewport_texture.get_image()
	if image == null or image.is_empty():
		_fail("basic skill capture produced an empty viewport image")
		return

	var output := ProjectSettings.globalize_path(OUTPUT_PATH)
	var err := image.save_png(output)
	if err != OK:
		_fail("basic skill capture save failed: %s" % error_string(err))
		return

	print("godot-ninja2 basic skill capture: %s" % output)
	quit(0)


func _prepare_basic_skill_fixture(main: Control) -> void:
	if main.sim == null or main.store == null:
		return
	var player: Dictionary = main.sim.player_entity
	if player.is_empty():
		return

	var player_position := Vector2(1500.0, 1120.0)
	player["position"] = player_position
	player["combat_facing_vector"] = Vector2(1.0, -0.78).normalized()
	player["attack_pose_time"] = 0.0

	var target: Dictionary = {}
	for entity in main.sim.entities:
		if typeof(entity) == TYPE_DICTIONARY and str(entity.get("team", "")) == "enemy":
			target = entity
			break
	if target.is_empty():
		main.sim._spawn_enemy(110201, 1)
		for entity in main.sim.entities:
			if typeof(entity) == TYPE_DICTIONARY and str(entity.get("team", "")) == "enemy":
				target = entity
				break
	if target.is_empty():
		return

	target["position"] = player_position + Vector2(118.0, -96.0)
	target["hp"] = max(1.0, float(target.get("max_hp", 80.0)))
	main.sim.entities = [player, target]

	var skill_def: Dictionary = main.store.get_skill(Catalog.BASIC_SKILL_ID)
	var slot := {
		"skill_id": Catalog.BASIC_SKILL_ID,
		"name": str(skill_def.get("name", "쿠나이 베기")),
		"cooldown": 0.55,
		"timer": 0.01,
		"level": 1,
	}
	main.sim.skill_slots = [slot]


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
