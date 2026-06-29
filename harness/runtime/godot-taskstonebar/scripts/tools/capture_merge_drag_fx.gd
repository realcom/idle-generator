extends SceneTree

const OUTPUT_PATH := "res://screenshots/taskstonebar-merge-drag-fx.png"
const SCENE_PATH := "res://scenes/main.tscn"
const CAPTURE_SIZE := Vector2i(1586, 992)


func _init() -> void:
	call_deferred("_capture")


func _capture() -> void:
	var scene: PackedScene = load(SCENE_PATH)
	if not (scene is PackedScene):
		push_error("failed to load main scene: %s" % SCENE_PATH)
		quit(1)
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
		push_error("GeneratedFullUiOverlay was not added to the main scene")
		quit(1)
		return

	var same_stone_slots := _same_stone_slots(overlay)
	if same_stone_slots.size() < 2:
		push_error("could not find two matching stone slots for merge FX capture")
		quit(1)
		return

	var source_slot := same_stone_slots[0] as Control
	var target_slot := same_stone_slots[1] as Control
	var source_data = source_slot.get_meta("runtime_slot_data", {})
	if typeof(source_data) != TYPE_DICTIONARY:
		push_error("source slot has no runtime data")
		quit(1)
		return

	root_node.generated_action_message = root_node._progression_merge_stones_from_drag(source_data as Dictionary, target_slot)
	root_node._refresh_generated_overlay_now()
	for _i in range(20):
		await process_frame

	var absolute_path := ProjectSettings.globalize_path(OUTPUT_PATH)
	DirAccess.make_dir_recursive_absolute(absolute_path.get_base_dir())
	var image: Image = get_root().get_texture().get_image()
	var error := image.save_png(absolute_path)
	if error != OK:
		push_error("failed to save screenshot %s: %s" % [absolute_path, error_string(error)])
		quit(1)
		return

	print("saved %s" % absolute_path)
	quit(0)


func _same_stone_slots(overlay: Node) -> Array:
	var grid := overlay.get_node_or_null("Section_WindowStack/Panel_HeroInventoryWindowFrame/Grid_StoneInventory")
	if grid == null:
		return []
	var by_item := {}
	for child in grid.get_children():
		if not child is Control:
			continue
		var raw_data = (child as Control).get_meta("runtime_slot_data", {})
		if typeof(raw_data) != TYPE_DICTIONARY:
			continue
		var data: Dictionary = raw_data
		if str(data.get("kind", "")) != "stone" or int(data.get("instance_id", 0)) <= 0:
			continue
		var item_id := int(data.get("item_data_id", 0))
		if not by_item.has(item_id):
			by_item[item_id] = []
		var slots: Array = by_item[item_id]
		slots.append(child)
		if slots.size() >= 2:
			return slots
	return []
