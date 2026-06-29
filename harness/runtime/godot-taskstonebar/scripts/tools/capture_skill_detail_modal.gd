extends SceneTree

const OUTPUT_PATH := "res://screenshots/taskstonebar-skill-detail-modal.png"
const CAPTURE_SIZE := Vector2i(1586, 992)


func _init() -> void:
	call_deferred("_capture")


func _capture() -> void:
	get_root().size = CAPTURE_SIZE
	if DisplayServer.get_name() != "headless":
		DisplayServer.window_set_size(CAPTURE_SIZE)
	var scene: PackedScene = load("res://scenes/main.tscn")
	if not (scene is PackedScene):
		_fail("failed to load main scene")
		return
	var root_node: Node = scene.instantiate()
	root_node.set("generated_visual_capture_mode", true)
	get_root().add_child(root_node)
	get_root().size = CAPTURE_SIZE
	for _i in range(30):
		await process_frame

	var overlay := root_node.get_node_or_null("GeneratedFullUiOverlay")
	if overlay == null:
		_fail("GeneratedFullUiOverlay was not added")
		return
	var skill_slot := overlay.get_node_or_null("Section_WindowStack/Panel_StatusWindowFrame/Section_SkillTree/Grid_StatusSkillSlots/Panel_SkillStoneThrow")
	if skill_slot == null or not skill_slot is Control:
		_fail("status stone throw skill slot is missing")
		return
	_click_control(skill_slot as Control)
	for _i in range(12):
		await process_frame

	var modal := overlay.get_node_or_null("ModalHost/Modal_SkillDetail")
	if modal == null:
		_fail("skill detail modal was not opened")
		return
	var confirm := modal.get_node_or_null("Footer_SkillDetail/Btn_SkillDetailConfirm")
	if confirm == null or not confirm is Button:
		_fail("skill detail confirm button is missing")
		return

	var absolute_path := ProjectSettings.globalize_path(OUTPUT_PATH)
	DirAccess.make_dir_recursive_absolute(absolute_path.get_base_dir())
	var viewport_texture := get_root().get_texture()
	if viewport_texture == null:
		_fail("viewport capture texture is unavailable; run without --headless for screenshot QA")
		return
	var image: Image = viewport_texture.get_image()
	if image == null or image.is_empty():
		_fail("viewport capture image is unavailable; run without --headless for screenshot QA")
		return
	var error := image.save_png(absolute_path)
	if error != OK:
		_fail("failed to save screenshot %s: %s" % [absolute_path, error_string(error)])
		return

	print("saved %s" % absolute_path)
	quit(0)


func _click_control(control: Control) -> void:
	var event := InputEventMouseButton.new()
	event.button_index = MOUSE_BUTTON_LEFT
	event.pressed = true
	event.position = control.size * 0.5
	control.emit_signal("gui_input", event)
	var release := InputEventMouseButton.new()
	release.button_index = MOUSE_BUTTON_LEFT
	release.pressed = false
	release.position = control.size * 0.5
	control.emit_signal("gui_input", release)


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
