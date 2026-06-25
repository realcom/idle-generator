extends SceneTree

const OUTPUT_PATH := "res://screenshots/taskstonebar-equipment-inventory-tab.png"
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
	for _i in range(12):
		await process_frame

	var grid := overlay.get_node_or_null("Section_WindowStack/Panel_HeroInventoryWindowFrame/Grid_StoneInventory")
	if grid == null or not grid is GridContainer:
		_fail("equipment inventory grid is missing")
		return
	if _equipment_icon_count(grid as GridContainer) < 3:
		_fail("equipment inventory did not render generated item art")
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


func _equipment_icon_count(grid: GridContainer) -> int:
	var total := 0
	for child in grid.get_children():
		if not child is Control:
			continue
		var data = (child as Control).get_meta("runtime_slot_data", {})
		if typeof(data) != TYPE_DICTIONARY:
			continue
		if str(data.get("kind", "")) != "equipment":
			continue
		if str(data.get("icon_path", "")).find("equipment/imagegen/icons") == -1:
			continue
		var texture_node := (child as Control).get_node_or_null("Panel_ItemIconMark/Tex_ItemIcon")
		if texture_node == null or not texture_node is TextureRect:
			continue
		var texture: Texture2D = (texture_node as TextureRect).texture
		if texture != null and texture.get_width() >= 64 and texture.get_height() >= 64:
			total += 1
	return total


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
