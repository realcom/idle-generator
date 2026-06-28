extends SceneTree

const OUTPUT_PATH := "res://screenshots/taskstonebar-desktop-manager.png"
const SCENE_PATH := "res://scenes/main.tscn"
const CAPTURE_SIZE := Vector2i(1586, 992)


func _init() -> void:
	call_deferred("_capture")


func _capture() -> void:
	var scene: PackedScene = load(SCENE_PATH)
	if not (scene is PackedScene):
		_fail("failed to load main scene: %s" % SCENE_PATH)
		return
	get_root().size = CAPTURE_SIZE
	if DisplayServer.get_name() != "headless":
		DisplayServer.window_set_size(CAPTURE_SIZE)
	var root_node: Node = scene.instantiate()
	root_node.set("generated_visual_capture_mode", true)
	get_root().add_child(root_node)
	get_root().size = CAPTURE_SIZE
	for _i in range(50):
		await process_frame

	if not root_node.has_method("show_desktop_window"):
		_fail("desktop window manager API is missing")
		return
	root_node.show_desktop_window("skill")
	root_node.focus_desktop_window("skill")
	for _i in range(24):
		await process_frame

	var overlay := root_node.get_node_or_null("GeneratedFullUiOverlay")
	if overlay == null:
		_fail("GeneratedFullUiOverlay was not added")
		return
	for node_path in [
		"Section_WindowStack/Panel_StatusWindowFrame",
		"Section_WindowStack/Panel_HeroInventoryWindowFrame",
		"Section_WindowStack/Panel_PortalWindowFrame",
		"Section_WindowStack/RuntimeSkillTreeWindow",
		"Section_BottomCombatStrip",
		"Section_DesktopScaffold/RuntimeDesktopStatusBarLayer",
	]:
		var node := overlay.get_node_or_null(node_path)
		if node == null or not node is CanvasItem or not (node as CanvasItem).visible:
			_fail("expected visible desktop surface is missing: %s" % node_path)
			return
	var status_mode := overlay.get_node_or_null("Section_DesktopScaffold/RuntimeDesktopStatusBarLayer/Text_StatusBarMode")
	var status_windows := overlay.get_node_or_null("Section_DesktopScaffold/RuntimeDesktopStatusBarLayer/Text_StatusBarWindows")
	if status_mode == null or not status_mode is Label or (status_mode as Label).text == "":
		_fail("desktop status bar mode label is missing")
		return
	if status_windows == null or not status_windows is Label or str((status_windows as Label).text).find("창") == -1:
		_fail("desktop status bar window summary is missing")
		return

	var absolute_path := ProjectSettings.globalize_path(OUTPUT_PATH)
	DirAccess.make_dir_recursive_absolute(absolute_path.get_base_dir())
	var image: Image = get_root().get_texture().get_image()
	var error := image.save_png(absolute_path)
	if error != OK:
		_fail("failed to save screenshot %s: %s" % [absolute_path, error_string(error)])
		return

	print("saved %s" % absolute_path)
	quit(0)


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
