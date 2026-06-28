extends SceneTree


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var scene: PackedScene = load("res://scenes/main.tscn")
	var root_node: Node = scene.instantiate()
	get_root().add_child(root_node)
	for _i in range(24):
		await process_frame

	var overlay := root_node.get_node_or_null("GeneratedFullUiOverlay")
	if overlay == null:
		_fail("GeneratedFullUiOverlay was not added")
		return

	for method_name in ["desktop_window_snapshot", "show_desktop_window", "hide_desktop_window", "toggle_desktop_window", "focus_desktop_window"]:
		if not root_node.has_method(method_name):
			_fail("main scene does not expose %s" % method_name)
			return

	var snapshot: Dictionary = root_node.desktop_window_snapshot()
	for window_id in ["status", "keeper", "portal", "combat", "skill_tree"]:
		if not _array_has_string(snapshot.get("registered", []), window_id):
			_fail("desktop manager did not register %s" % window_id)
			return
	for visible_id in ["status", "keeper", "portal", "combat"]:
		if not _array_has_string(snapshot.get("visible", []), visible_id):
			_fail("desktop manager initial visible set is missing %s" % visible_id)
			return
	if _array_has_string(snapshot.get("visible", []), "skill_tree"):
		_fail("skill tree should start registered but hidden")
		return

	root_node.show_desktop_window("skill")
	for _i in range(6):
		await process_frame
	var skill_window := overlay.get_node_or_null("Section_WindowStack/RuntimeSkillTreeWindow")
	if skill_window == null or not skill_window is Control or not (skill_window as Control).visible:
		_fail("show_desktop_window('skill') did not open the skill tree")
		return
	snapshot = root_node.desktop_window_snapshot()
	if str(snapshot.get("focused", "")) != "skill_tree":
		_fail("skill tree did not become the focused desktop window")
		return
	for background_path in [
		"Section_WindowStack/Panel_StatusWindowFrame",
		"Section_WindowStack/Panel_HeroInventoryWindowFrame",
		"Section_WindowStack/Panel_PortalWindowFrame",
	]:
		var background_window := overlay.get_node_or_null(background_path)
		if background_window == null or not background_window is Control:
			_fail("background desktop window is missing for z-order check: %s" % background_path)
			return
		if (skill_window as Control).z_index <= (background_window as Control).z_index + 10:
			_fail("focused skill tree does not have enough z-order separation above %s" % background_path)
			return

	root_node.hide_desktop_window("map")
	for _i in range(4):
		await process_frame
	var portal := overlay.get_node_or_null("Section_WindowStack/Panel_PortalWindowFrame")
	var status := overlay.get_node_or_null("Section_WindowStack/Panel_StatusWindowFrame")
	var combat := overlay.get_node_or_null("Section_BottomCombatStrip")
	if portal == null or not portal is CanvasItem or (portal as CanvasItem).visible:
		_fail("hide_desktop_window('map') did not hide the portal/map window")
		return
	if status == null or not status is CanvasItem or not (status as CanvasItem).visible:
		_fail("hiding map should not hide status")
		return
	if combat == null or not combat is CanvasItem or not (combat as CanvasItem).visible:
		_fail("hiding map should not hide combat strip")
		return

	root_node.show_desktop_window("map")
	for _i in range(4):
		await process_frame
	if not (portal as CanvasItem).visible:
		_fail("show_desktop_window('map') did not restore the portal/map window")
		return

	root_node.focus_desktop_window("status")
	for _i in range(2):
		await process_frame
	snapshot = root_node.desktop_window_snapshot()
	if str(snapshot.get("focused", "")) != "status":
		_fail("focus_desktop_window('status') did not update focus")
		return

	root_node.toggle_desktop_window("status")
	for _i in range(4):
		await process_frame
	if (status as CanvasItem).visible:
		_fail("toggle_desktop_window('status') did not hide status")
		return
	root_node.toggle_desktop_window("status")
	for _i in range(4):
		await process_frame
	if not (status as CanvasItem).visible:
		_fail("toggle_desktop_window('status') did not restore status")
		return

	print("desktop window manager smoke ok")
	quit(0)


func _array_has_string(values, needle: String) -> bool:
	if typeof(values) != TYPE_ARRAY:
		return false
	for value in values:
		if str(value) == needle:
			return true
	return false


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
