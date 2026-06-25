extends SceneTree

const OUTPUT_PATH := "res://screenshots/taskstonebar-equipment-upgrade-modal.png"
const CAPTURE_SIZE := Vector2i(1586, 992)


func _init() -> void:
	call_deferred("_capture")


func _capture() -> void:
	get_root().size = CAPTURE_SIZE
	if DisplayServer.get_name() != "headless":
		DisplayServer.window_set_size(CAPTURE_SIZE)
	var scene: PackedScene = load("res://scenes/main.tscn")
	var root_node: Node = scene.instantiate()
	root_node.set("generated_visual_capture_mode", true)
	get_root().add_child(root_node)
	get_root().size = CAPTURE_SIZE
	for _i in range(24):
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
	for _i in range(8):
		await process_frame
	var detail_upgrade := overlay.get_node_or_null("ModalHost/Modal_InventoryItemDetail/Footer_ItemDetail/Btn_ItemDetailUpgrade")
	if detail_upgrade == null or not detail_upgrade is Button:
		_fail("equipment detail upgrade button is missing")
		return
	(detail_upgrade as Button).pressed.emit()
	for _i in range(12):
		await process_frame

	var modal := overlay.get_node_or_null("ModalHost/Modal_EquipmentUpgrade")
	if modal == null:
		_fail("equipment upgrade modal was not opened")
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


func _click_control(control: Control) -> void:
	var event := InputEventMouseButton.new()
	event.button_index = MOUSE_BUTTON_LEFT
	event.pressed = true
	control.emit_signal("gui_input", event)
	var release := InputEventMouseButton.new()
	release.button_index = MOUSE_BUTTON_LEFT
	release.pressed = false
	control.emit_signal("gui_input", release)


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
