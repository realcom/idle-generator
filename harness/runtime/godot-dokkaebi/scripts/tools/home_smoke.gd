extends SceneTree

const MainScene := preload("res://scripts/main.gd")


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var root := get_root()
	root.size = Vector2i(540, 960)
	var main := MainScene.new()
	main.set_anchors_preset(Control.PRESET_FULL_RECT)
	main.set_test_mode(true)
	root.add_child(main)
	await process_frame
	await process_frame
	var home_snapshot: Dictionary = main.debug_snapshot()
	if str(home_snapshot.get("screen_mode", "")) != "home":
		_fail("home screen was not the default mode")
		return
	if not bool(home_snapshot.get("generated_home_loaded", false)):
		_fail("generated home surface was not loaded")
		return
	if not bool(home_snapshot.get("generated_home_visible", false)):
		_fail("generated home surface was not visible")
		return
	if bool(home_snapshot.get("generated_hud_visible", false)):
		_fail("battle HUD was visible on the home screen")
		return
	main.restart_run()
	await process_frame
	var battle_snapshot: Dictionary = main.debug_snapshot()
	if str(battle_snapshot.get("screen_mode", "")) != "battle":
		_fail("sortie did not enter battle mode")
		return
	if bool(battle_snapshot.get("generated_home_visible", true)):
		_fail("home surface stayed visible after sortie")
		return
	if not bool(battle_snapshot.get("generated_hud_visible", false)):
		_fail("battle HUD was not visible after sortie")
		return
	print("godot-dokkaebi home smoke ok: mode=%s battle_enemies=%d" % [
		str(battle_snapshot.get("screen_mode", "")),
		int(battle_snapshot.get("enemy_count", 0)),
	])
	quit(0)


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
