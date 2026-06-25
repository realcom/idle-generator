extends SceneTree

const SCENE_PATH := "res://scenes/generated/status_window.tscn"


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var packed: PackedScene = load(SCENE_PATH)
	if not (packed is PackedScene):
		_fail("status window scene is not a PackedScene")
		return

	var root_node := packed.instantiate()
	get_root().add_child(root_node)
	for _i in range(6):
		await process_frame

	_require_node(root_node, "Panel_StatusWindowFrame")
	_require_node(root_node, "Panel_StatusStatScroll")
	_require_node(root_node, "Panel_SkillPointHeader")
	_require_node(root_node, "Section_SkillTree")
	_require_node(root_node, "Panel_LevelTrackRail")
	_require_node(root_node, "Btn_StatusSearch")
	if get_root().get_meta("status_window_smoke_failed", false):
		return

	if _has_component(root_node, "StonePortraitPanel"):
		_fail("status window must not contain StonePortraitPanel")
		return
	if _has_component(root_node, "RuneMarkTree"):
		_fail("status window must not contain RuneMarkTree")
		return
	if root_node.find_child("Tex_StatusStonePortrait", true, false) != null:
		_fail("status window still contains old stone portrait texture node")
		return

	var skill_slots := _collect_component(root_node, "SkillIconSlot")
	if skill_slots.size() < 9:
		_fail("expected at least 9 SkillIconSlot nodes, got %d" % skill_slots.size())
		return

	var stat_value_labels := _count_status_value_labels(root_node)
	if stat_value_labels < 6:
		_fail("expected at least 6 separated stat value labels, got %d" % stat_value_labels)
		return

	print("status window smoke ok: skill_slots=%d stat_value_labels=%d" % [skill_slots.size(), stat_value_labels])
	quit(0)


func _require_node(root_node: Node, node_name: String) -> void:
	if root_node.find_child(node_name, true, false) == null:
		_fail("missing node: %s" % node_name)


func _has_component(root_node: Node, component_name: String) -> bool:
	return not _collect_component(root_node, component_name).is_empty()


func _collect_component(root_node: Node, component_name: String) -> Array[Node]:
	var found: Array[Node] = []
	_collect_component_recursive(root_node, component_name, found)
	return found


func _collect_component_recursive(node: Node, component_name: String, found: Array[Node]) -> void:
	if str(node.get_meta("component", "")) == component_name:
		found.append(node)
	for child in node.get_children():
		_collect_component_recursive(child, component_name, found)


func _count_status_value_labels(root_node: Node) -> int:
	var count := 0
	for node in _collect_component(root_node, "StatList"):
		if node is Label and str(node.name).begins_with("Text_Status") and str(node.name).ends_with("Value"):
			count += 1
	return count


func _fail(message: String) -> void:
	get_root().set_meta("status_window_smoke_failed", true)
	push_error(message)
	quit(1)
