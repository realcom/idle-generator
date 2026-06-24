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
	main.restart_run()
	if not bool(main.debug_snapshot().get("generated_hud_loaded", false)):
		_fail("generated HUD surface was not loaded by main runtime")
		return
	if not bool(main.debug_snapshot().get("generated_hud_visible", false)):
		_fail("generated HUD surface was not visible during active run")
		return
	main.inject_move(Vector2.RIGHT)
	for _i in range(180):
		main._process(1.0 / 30.0)
	if main.debug_snapshot().get("enemy_count", 0) <= 0:
		_fail("no enemies after startup")
		return
	main.inject_move(Vector2.ZERO)
	for _i in range(500):
		main._process(1.0 / 30.0)
		if bool(main.debug_snapshot().get("choice_pending", false)):
			break
	var snapshot: Dictionary = main.debug_snapshot()
	if int(snapshot.get("kills", 0)) <= 0:
		_fail("Haeil did not purify any enemies")
		return
	if int(snapshot.get("pickup_count", 0)) <= 0 and int(snapshot.get("exp", 0)) <= 0 and int(snapshot.get("level", 1)) <= 1:
		_fail("no spirit energy pickup or exp progress")
		return
	if int(snapshot.get("field_item_count", 0)) <= 0:
		_fail("no Ninja2-style field items spawned during run")
		return
	if bool(snapshot.get("choice_pending", false)):
		if not main.choose_card(0):
			_fail("could not choose first level card")
			return
		var after_choice: Dictionary = main.debug_snapshot()
		var skills: Dictionary = after_choice.get("skills", {})
		var learned := 0
		for key in skills.keys():
			if int(skills.get(key, 0)) > 0:
				learned += 1
		if learned <= 0:
			_fail("card choice did not learn a skill")
			return
	print("godot-dokkaebi smoke ok: kills=%d level=%d exp=%d enemies=%d field_items=%d" % [
		int(snapshot.get("kills", 0)),
		int(snapshot.get("level", 1)),
		int(snapshot.get("exp", 0)),
		int(snapshot.get("enemy_count", 0)),
		int(snapshot.get("field_item_count", 0)),
	])
	quit(0)


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
