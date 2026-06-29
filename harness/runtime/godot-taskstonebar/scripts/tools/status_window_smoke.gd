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
	if stat_value_labels < 12:
		_fail("expected at least 12 separated stat value labels, got %d" % stat_value_labels)
		return

	var stat_scroll := root_node.find_child("Panel_StatusStatScroll", true, false)
	var scroll_container := stat_scroll.find_child("Scroll_StatusRows", true, false) if stat_scroll != null else null
	if scroll_container == null or not scroll_container is ScrollContainer:
		_fail("status stat rows are not inside a real ScrollContainer")
		return
	var rows := (scroll_container as ScrollContainer).get_node_or_null("Group_StatusRows")
	if rows == null:
		_fail("status rows were not moved into Scroll_StatusRows")
		return
	(scroll_container as ScrollContainer).scroll_vertical = 999
	for _i in range(4):
		await process_frame
	if (scroll_container as ScrollContainer).scroll_vertical <= 0:
		_fail("status stat ScrollContainer did not scroll")
		return

	var skill_points_label := root_node.find_child("Text_SkillPoints", true, false)
	if skill_points_label == null or not skill_points_label is Label:
		_fail("skill points label is missing")
		return
	var before_points := _parse_skill_points(str((skill_points_label as Label).text))
	var guard_slot := root_node.find_child("Panel_SkillGuard", true, false)
	var guard_label := root_node.find_child("Text_GuardLevel", true, false)
	if guard_slot == null or not guard_slot is Control or guard_label == null or not guard_label is Label:
		_fail("guard skill slot is missing")
		return
	if not _slot_children_ignore_mouse(guard_slot as Control):
		_fail("status skill slot children still intercept mouse input")
		return
	var before_guard_text := str((guard_label as Label).text)
	_emit_left_click(guard_slot as Control)
	for _i in range(4):
		await process_frame
	if _parse_skill_points(str((skill_points_label as Label).text)) != before_points:
		_fail("status skill slot spent a skill point before opening the detail window")
		return
	if str((guard_label as Label).text) != before_guard_text:
		_fail("status skill slot increased its level before confirmation")
		return
	var detail_window := root_node.find_child("Panel_SkillDetailWindow", true, false)
	if detail_window == null or not detail_window is Control:
		_fail("status skill slot did not open its skill detail window")
		return
	var confirm := detail_window.get_node_or_null("Btn_SkillDetailConfirm")
	if confirm == null or not confirm is Button:
		_fail("skill detail window has no confirm button")
		return
	if (confirm as Button).disabled:
		_fail("skill detail confirm button should be enabled with available points")
		return
	(confirm as Button).pressed.emit()
	for _i in range(4):
		await process_frame
	var after_points := _parse_skill_points(str((skill_points_label as Label).text))
	if after_points >= before_points:
		_fail("skill detail confirm did not spend a skill point")
		return
	if str((guard_label as Label).text) == before_guard_text:
		_fail("skill detail confirm did not increase its level label")
		return

	print("status window smoke ok: skill_slots=%d stat_value_labels=%d scroll=%d sp=%d" % [skill_slots.size(), stat_value_labels, int((scroll_container as ScrollContainer).scroll_vertical), after_points])
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


func _emit_left_click(control: Control) -> void:
	var event := InputEventMouseButton.new()
	event.button_index = MOUSE_BUTTON_LEFT
	event.pressed = true
	event.position = control.size * 0.5
	control.emit_signal("gui_input", event)


func _parse_skill_points(text: String) -> int:
	var pieces := text.split(":")
	if pieces.size() >= 2:
		return int(str(pieces[1]).strip_edges())
	return int(text)


func _slot_children_ignore_mouse(slot: Control) -> bool:
	for child in slot.get_children():
		if child is Control:
			var control := child as Control
			if control.mouse_filter != Control.MOUSE_FILTER_IGNORE:
				return false
			if not _slot_children_ignore_mouse(control):
				return false
	return true


func _fail(message: String) -> void:
	get_root().set_meta("status_window_smoke_failed", true)
	push_error(message)
	quit(1)
