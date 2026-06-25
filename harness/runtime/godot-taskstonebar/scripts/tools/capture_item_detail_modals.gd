extends SceneTree

const EQUIPMENT_OUTPUT_PATH := "res://screenshots/taskstonebar-equipment-detail-modal.png"
const STONE_OUTPUT_PATH := "res://screenshots/taskstonebar-stone-detail-modal.png"
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
	for _i in range(30):
		await process_frame

	var overlay := root_node.get_node_or_null("GeneratedFullUiOverlay")
	if overlay == null:
		_fail("GeneratedFullUiOverlay was not added")
		return

	var equipment_tab := overlay.get_node_or_null("Section_WindowStack/Panel_HeroInventoryWindowFrame/Tabs_StoneEquipment/Btn_EquipmentTab")
	if equipment_tab == null or not equipment_tab is Button:
		_fail("equipment tab is missing")
		return
	(equipment_tab as Button).pressed.emit()
	for _i in range(4):
		await process_frame
	var equipment_slot := overlay.get_node_or_null("Section_WindowStack/Panel_HeroInventoryWindowFrame/Grid_StoneInventory/Panel_StoneSlotPrototype")
	if equipment_slot == null or not equipment_slot is Control:
		_fail("equipment slot is missing")
		return
	_click_control(equipment_slot as Control)
	for _i in range(12):
		await process_frame
	if overlay.get_node_or_null("ModalHost/Modal_InventoryItemDetail") == null:
		_fail("equipment detail modal was not opened")
		return
	_save_png(EQUIPMENT_OUTPUT_PATH)

	var close_button := overlay.get_node_or_null("ModalHost/Modal_InventoryItemDetail/Panel_ItemDetailTitleBar/Btn_ItemDetailClose")
	if close_button != null and close_button is Button:
		(close_button as Button).pressed.emit()
	for _i in range(4):
		await process_frame

	var stone_tab := overlay.get_node_or_null("Section_WindowStack/Panel_HeroInventoryWindowFrame/Tabs_StoneEquipment/Btn_StoneTab")
	if stone_tab == null or not stone_tab is Button:
		_fail("stone tab is missing")
		return
	(stone_tab as Button).pressed.emit()
	for _i in range(4):
		await process_frame
	var stone_slot := overlay.get_node_or_null("Section_WindowStack/Panel_HeroInventoryWindowFrame/Grid_StoneInventory/Panel_StoneSlotPrototype")
	if stone_slot == null or not stone_slot is Control:
		_fail("stone slot is missing")
		return
	_click_control(stone_slot as Control)
	for _i in range(12):
		await process_frame
	if overlay.get_node_or_null("ModalHost/Modal_InventoryItemDetail") == null:
		_fail("stone detail modal was not opened")
		return
	_save_png(STONE_OUTPUT_PATH)

	print("saved %s and %s" % [
		ProjectSettings.globalize_path(EQUIPMENT_OUTPUT_PATH),
		ProjectSettings.globalize_path(STONE_OUTPUT_PATH),
	])
	quit(0)


func _click_control(control: Control) -> void:
	var event := InputEventMouseButton.new()
	event.button_index = MOUSE_BUTTON_LEFT
	event.pressed = true
	control.emit_signal("gui_input", event)
	var release := InputEventMouseButton.new()
	release.button_index = MOUSE_BUTTON_LEFT
	release.pressed = false
	control.emit_signal("gui_input", release)


func _save_png(resource_path: String) -> void:
	var absolute_path := ProjectSettings.globalize_path(resource_path)
	DirAccess.make_dir_recursive_absolute(absolute_path.get_base_dir())
	var image: Image = get_root().get_texture().get_image()
	var error := image.save_png(absolute_path)
	if error != OK:
		_fail("failed to save screenshot %s: %s" % [absolute_path, error_string(error)])


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
