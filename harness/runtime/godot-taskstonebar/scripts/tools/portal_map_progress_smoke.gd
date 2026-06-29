extends SceneTree


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var scene: PackedScene = load("res://scenes/main.tscn")
	if not (scene is PackedScene):
		_fail("main scene could not be loaded")
		return
	var root_node: Node = scene.instantiate()
	root_node.set("generated_visual_capture_mode", true)
	get_root().add_child(root_node)
	for _i in range(24):
		await process_frame

	await _check_map(root_node, 500105, "보통 / Act 1-5", "1-5", "res://assets/generated/ui/portal_map_500101_taskbar_cave_rounded.png")
	await _check_map(root_node, 500111, "보통 / Act 2-1", "2-1", "res://assets/generated/ui/portal_map_02_moss_grotto_rounded.png")

	print("portal map progress smoke ok")
	quit(0)


func _check_map(root_node: Node, map_id: int, expected_difficulty: String, expected_stage: String, expected_texture: String) -> void:
	var sim: Variant = root_node.get("sim")
	if sim == null or not sim.has_method("start"):
		_fail("main scene has no combat sim")
		return
	sim.start(map_id)
	if root_node.has_method("_refresh_generated_overlay_now"):
		root_node.call("_refresh_generated_overlay_now")
	for _i in range(18):
		await process_frame
	var portal := _find_generated_portal_window(root_node)
	if portal == null:
		_fail("generated portal window was not found")
		return
	var map_texture := portal.get_node_or_null("Tex_ParchmentRouteMap")
	if map_texture == null or not map_texture is TextureRect or (map_texture as TextureRect).texture == null:
		_fail("portal map texture was not found")
		return
	var texture_path := str((map_texture as TextureRect).texture.resource_path)
	if texture_path != expected_texture:
		_fail("map %d expected portal texture '%s', got '%s'" % [map_id, expected_texture, texture_path])
		return
	var difficulty := portal.get_node_or_null("Panel_DifficultySelect/Text_Difficulty")
	if difficulty == null or not difficulty is Label:
		_fail("portal difficulty label was not found")
		return
	if (difficulty as Label).text != expected_difficulty:
		_fail("map %d expected difficulty '%s', got '%s'" % [map_id, expected_difficulty, (difficulty as Label).text])
		return
	var stage_index := int(expected_stage.get_slice("-", 1))
	var current_stage_label := portal.get_node_or_null("Panel_PortalStage%d/Text_Panel_PortalStage%d" % [20 + stage_index, 20 + stage_index])
	if current_stage_label == null or not current_stage_label is Label:
		_fail("portal current stage label was not found")
		return
	if (current_stage_label as Label).text != expected_stage:
		_fail("map %d expected current stage '%s', got '%s'" % [map_id, expected_stage, (current_stage_label as Label).text])
		return
	var first_stage := portal.get_node_or_null("Panel_PortalStage21/Text_Panel_PortalStage21")
	if first_stage == null or not first_stage is Label:
		_fail("portal first stage node label was not found")
		return
	if not (first_stage as Label).text.begins_with(expected_stage.get_slice("-", 0) + "-"):
		_fail("map %d first stage label did not follow active act: %s" % [map_id, (first_stage as Label).text])


func _find_generated_portal_window(root: Node) -> Node:
	if root.name == "Panel_PortalWindowFrame" and root.get_node_or_null("Panel_DifficultySelect/Text_Difficulty") != null:
		return root
	for child in root.get_children():
		var found := _find_generated_portal_window(child)
		if found != null:
			return found
	return null


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
