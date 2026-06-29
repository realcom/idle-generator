extends Control

const STAT_ROW_SPECS := [
	{"row": "Row_StatusLevel", "label": "Text_StatusLevelLabel", "value": "Text_StatusLevelValue", "name": "Level", "display": "Lv. 27"},
	{"row": "Row_StatusExp", "label": "Text_StatusExpLabel", "value": "Text_StatusExpValue", "name": "EXP", "display": "3,354,766 / 9,866,299"},
	{"row": "Row_StatusDps", "label": "Text_StatusDpsLabel", "value": "Text_StatusDpsValue", "name": "Basic Attack DPS", "display": "48.3"},
	{"row": "Row_StatusAttackDamage", "label": "Text_StatusAttackDamageLabel", "value": "Text_StatusAttackDamageValue", "name": "Attack Damage", "display": "57"},
	{"row": "Row_StatusMaxHp", "label": "Text_StatusMaxHpLabel", "value": "Text_StatusMaxHpValue", "name": "Max HP", "display": "65"},
	{"row": "Row_StatusMoveSpeed", "label": "Text_StatusMoveSpeedLabel", "value": "Text_StatusMoveSpeedValue", "name": "Move Speed", "display": "0.90"},
	{"row": "Row_StatusAttackSpeed", "label": "Text_StatusAttackSpeedExtraLabel", "value": "Text_StatusAttackSpeedExtraValue", "name": "Attack Speed", "display": "2.35"},
	{"row": "Row_StatusCrit", "label": "Text_StatusCritExtraLabel", "value": "Text_StatusCritExtraValue", "name": "Critical Rate", "display": "12.4%"},
	{"row": "Row_StatusCritDamage", "label": "Text_StatusCritDamageExtraLabel", "value": "Text_StatusCritDamageExtraValue", "name": "Critical Damage", "display": "185%"},
	{"row": "Row_StatusBossDamage", "label": "Text_StatusBossDamageExtraLabel", "value": "Text_StatusBossDamageExtraValue", "name": "Boss Damage", "display": "+14%"},
	{"row": "Row_StatusDropBonus", "label": "Text_StatusDropBonusExtraLabel", "value": "Text_StatusDropBonusExtraValue", "name": "Drop Bonus", "display": "+8.0%"},
	{"row": "Row_StatusGoldGain", "label": "Text_StatusGoldGainExtraLabel", "value": "Text_StatusGoldGainExtraValue", "name": "Gold Gain", "display": "+21%"},
	{"row": "Row_StatusCooldown", "label": "Text_StatusCooldownExtraLabel", "value": "Text_StatusCooldownExtraValue", "name": "Cooldown", "display": "-3.5%"},
	{"row": "Row_StatusLuck", "label": "Text_StatusLuckExtraLabel", "value": "Text_StatusLuckExtraValue", "name": "Luck", "display": "37"},
]

var skill_points := 5
var skill_levels := {}
var skill_max_levels := {}
var selected_skill_binding := ""


func _ready() -> void:
	_prepare_stat_scroll()
	_prepare_skill_slots()
	_sync_skill_slots()


func _prepare_stat_scroll() -> void:
	var stat_scroll := find_child("Panel_StatusStatScroll", true, false)
	if stat_scroll == null or not stat_scroll is Control:
		return
	var scroll_container := _ensure_scroll_container(stat_scroll as Control)
	var rows := _ensure_rows_group(stat_scroll as Control, scroll_container)
	rows.position = Vector2.ZERO
	rows.size = Vector2(284.0, 238.0)
	rows.custom_minimum_size = Vector2(284.0, 238.0)
	for index in range(STAT_ROW_SPECS.size()):
		var spec: Dictionary = STAT_ROW_SPECS[index]
		_ensure_stat_row(rows, spec, float(index) * 17.0)
	for decoration_name in ["Panel_StatusScrollbar", "Panel_StatusScrollbarTopCap", "Panel_StatusScrollbarBottomCap"]:
		var decoration := (stat_scroll as Control).get_node_or_null(decoration_name)
		if decoration != null and decoration is CanvasItem:
			(decoration as CanvasItem).visible = false
		if decoration != null and decoration is Control:
			(decoration as Control).mouse_filter = Control.MOUSE_FILTER_IGNORE


func _ensure_scroll_container(stat_scroll: Control) -> ScrollContainer:
	var existing := stat_scroll.get_node_or_null("Scroll_StatusRows")
	var scroll_container: ScrollContainer
	if existing != null and existing is ScrollContainer:
		scroll_container = existing as ScrollContainer
	else:
		scroll_container = ScrollContainer.new()
		scroll_container.name = "Scroll_StatusRows"
		stat_scroll.add_child(scroll_container)
	scroll_container.position = Vector2(52.0, 48.0)
	scroll_container.size = Vector2(296.0, 112.0)
	scroll_container.custom_minimum_size = Vector2(296.0, 112.0)
	scroll_container.z_index = 4
	scroll_container.clip_contents = true
	scroll_container.mouse_filter = Control.MOUSE_FILTER_STOP
	scroll_container.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll_container.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	return scroll_container


func _ensure_rows_group(stat_scroll: Control, scroll_container: ScrollContainer) -> Control:
	var group := scroll_container.get_node_or_null("Group_StatusRows")
	if group == null:
		group = stat_scroll.find_child("Group_StatusRows", true, false)
	if group == null:
		group = Control.new()
		group.name = "Group_StatusRows"
	if group.get_parent() != scroll_container:
		var previous_parent := group.get_parent()
		if previous_parent != null:
			previous_parent.remove_child(group)
		scroll_container.add_child(group)
	return group as Control


func _ensure_stat_row(rows: Control, spec: Dictionary, y: float) -> void:
	var row_name := str(spec.get("row", "Row_StatusExtra"))
	var row := rows.get_node_or_null(row_name)
	if row == null or not row is Control:
		row = Control.new()
		row.name = row_name
		rows.add_child(row)
	var row_control := row as Control
	row_control.position = Vector2(0.0, y)
	row_control.size = Vector2(270.0, 16.0)
	row_control.custom_minimum_size = Vector2(270.0, 16.0)
	row_control.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row_control.set_meta("component", "StatList")
	var label := _ensure_label(row_control, str(spec.get("label", "")), Vector2.ZERO, Vector2(154.0, 16.0), HORIZONTAL_ALIGNMENT_LEFT)
	label.text = str(spec.get("name", ""))
	var value := _ensure_label(row_control, str(spec.get("value", "")), Vector2(154.0, 0.0), Vector2(116.0, 16.0), HORIZONTAL_ALIGNMENT_RIGHT)
	value.text = str(spec.get("display", ""))


func _ensure_label(parent: Control, label_name: String, pos: Vector2, label_size: Vector2, alignment: HorizontalAlignment) -> Label:
	var existing := parent.get_node_or_null(label_name)
	var label: Label
	if existing != null and existing is Label:
		label = existing as Label
	else:
		label = Label.new()
		label.name = label_name
		parent.add_child(label)
	label.position = pos
	label.size = label_size
	label.custom_minimum_size = label_size
	label.horizontal_alignment = alignment
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.clip_text = true
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_font_size_override("font_size", 13)
	label.add_theme_color_override("font_color", Color("#24170d"))
	label.add_theme_color_override("font_shadow_color", Color("#dfcca2"))
	label.add_theme_constant_override("shadow_offset_x", 1)
	label.add_theme_constant_override("shadow_offset_y", 1)
	label.set_meta("component", "StatList")
	return label


func _prepare_skill_slots() -> void:
	for label in _collect_skill_labels(self):
		var binding := str(label.get_meta("text_binding_or_text_key", ""))
		var slot: Node = label.get_parent()
		if binding == "" or slot == null or not slot is Control:
			continue
		if not skill_levels.has(binding):
			skill_levels[binding] = 0
			skill_max_levels[binding] = _parse_max_level(str(label.text))
		var control := slot as Control
		_prepare_skill_slot_hit_area(control)
		control.tooltip_text = "Click to inspect and level up"
		control.set_meta("status_window_skill_binding", binding)
		if control.has_meta("status_window_skill_connected"):
			continue
		control.gui_input.connect(func(event: InputEvent):
			_handle_skill_slot_input(control, event)
		)
		control.set_meta("status_window_skill_connected", true)


func _prepare_skill_slot_hit_area(slot: Control) -> void:
	slot.mouse_filter = Control.MOUSE_FILTER_STOP
	slot.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	for child in slot.get_children():
		_prepare_skill_slot_child_hit_area(child)


func _prepare_skill_slot_child_hit_area(node: Node) -> void:
	if node is Control:
		var control := node as Control
		control.mouse_filter = Control.MOUSE_FILTER_IGNORE
		control.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	for child in node.get_children():
		_prepare_skill_slot_child_hit_area(child)


func _sync_skill_slots() -> void:
	var points_label := find_child("Text_SkillPoints", true, false)
	if points_label != null and points_label is Label:
		(points_label as Label).text = "Skill Points: %d" % skill_points
	var plus_label := find_child("Text_SkillPointPlus", true, false)
	if plus_label != null and plus_label is Label:
		(plus_label as Label).text = "+" if skill_points > 0 else ""
	for label in _collect_skill_labels(self):
		var binding := str(label.get_meta("text_binding_or_text_key", ""))
		if binding == "" or not skill_levels.has(binding):
			continue
		var level := int(skill_levels.get(binding, 0))
		var max_level := int(skill_max_levels.get(binding, 5))
		label.text = "%d/%d" % [level, max_level]
		var slot: Node = label.get_parent()
		if slot != null and slot is CanvasItem:
			(slot as CanvasItem).modulate = Color(0.92, 1.12, 0.92, 1.0) if level > 0 else Color(1.0, 0.95, 0.72, 0.96)


func _handle_skill_slot_input(slot: Control, event: InputEvent) -> void:
	if not (event is InputEventMouseButton):
		return
	var mouse := event as InputEventMouseButton
	if mouse.button_index != MOUSE_BUTTON_LEFT or not mouse.pressed:
		return
	var binding := str(slot.get_meta("status_window_skill_binding", ""))
	if binding != "":
		_open_skill_detail_window(binding)
	slot.accept_event()


func _open_skill_detail_window(binding: String) -> void:
	selected_skill_binding = binding
	_close_skill_detail_window(false)
	var level := int(skill_levels.get(binding, 0))
	var max_level := int(skill_max_levels.get(binding, 5))
	var can_level := skill_points > 0 and level < max_level
	var panel := Panel.new()
	panel.name = "Panel_SkillDetailWindow"
	panel.position = Vector2(24.0, 82.0)
	panel.size = Vector2(356.0, 220.0)
	panel.z_index = 48
	panel.mouse_filter = Control.MOUSE_FILTER_STOP
	panel.add_theme_stylebox_override("panel", _detail_style(Color("#100b07"), Color("#d18a24"), 2, 3))
	add_child(panel)
	_make_detail_label(panel, "Text_SkillDetailTitle", _skill_display_name(binding), Vector2(18.0, 12.0), Vector2(274.0, 28.0), 16, Color("#ffcf7a"))
	var close := Button.new()
	close.name = "Btn_SkillDetailClose"
	close.text = "X"
	close.position = Vector2(312.0, 14.0)
	close.size = Vector2(26.0, 24.0)
	close.pressed.connect(func():
		_close_skill_detail_window()
	)
	panel.add_child(close)
	_make_detail_label(panel, "Text_SkillDetailLevel", "Lv. %d / %d" % [level, max_level], Vector2(18.0, 54.0), Vector2(112.0, 24.0), 12, Color("#f3e6c8"), HORIZONTAL_ALIGNMENT_LEFT)
	_make_detail_label(panel, "Text_SkillDetailEquip", "학습 시 자동 장착" if level <= 0 else "자동 장착됨", Vector2(148.0, 54.0), Vector2(176.0, 24.0), 12, Color("#d8ffb2"), HORIZONTAL_ALIGNMENT_LEFT)
	_make_detail_label(panel, "Text_SkillDetailPoints", "Skill Points: %d" % skill_points, Vector2(18.0, 88.0), Vector2(150.0, 22.0), 12, Color("#ffcf7a"), HORIZONTAL_ALIGNMENT_LEFT)
	_make_detail_label(panel, "Text_SkillDetailCurrentEffect", "현재: %s" % ("미학습" if level <= 0 else "효과 Lv.%d 적용 중" % level), Vector2(18.0, 118.0), Vector2(318.0, 22.0), 12, Color("#f3e6c8"), HORIZONTAL_ALIGNMENT_LEFT)
	_make_detail_label(panel, "Text_SkillDetailNextEffect", "다음: %s" % ("최대 레벨" if level >= max_level else "Skill Point 1 소모 후 Lv.%d" % (level + 1)), Vector2(18.0, 144.0), Vector2(318.0, 22.0), 12, Color("#f3e6c8"), HORIZONTAL_ALIGNMENT_LEFT)
	var cancel := Button.new()
	cancel.name = "Btn_SkillDetailCancel"
	cancel.text = "닫기"
	cancel.position = Vector2(92.0, 178.0)
	cancel.size = Vector2(78.0, 28.0)
	cancel.pressed.connect(func():
		_close_skill_detail_window()
	)
	panel.add_child(cancel)
	var confirm := Button.new()
	confirm.name = "Btn_SkillDetailConfirm"
	confirm.text = "학습" if level <= 0 else "레벨업"
	confirm.position = Vector2(184.0, 178.0)
	confirm.size = Vector2(94.0, 28.0)
	confirm.disabled = not can_level
	confirm.pressed.connect(_confirm_skill_detail_level_up)
	panel.add_child(confirm)


func _close_skill_detail_window(clear_selection := true) -> void:
	var existing := find_child("Panel_SkillDetailWindow", true, false)
	if existing != null:
		existing.queue_free()
	if clear_selection:
		selected_skill_binding = ""


func _confirm_skill_detail_level_up() -> void:
	var binding := selected_skill_binding
	if binding == "":
		return
	var level := int(skill_levels.get(binding, 0))
	var max_level := int(skill_max_levels.get(binding, 5))
	if skill_points <= 0 or level >= max_level:
		_open_skill_detail_window(binding)
		return
	skill_points -= 1
	skill_levels[binding] = level + 1
	_sync_skill_slots()
	_open_skill_detail_window(binding)


func _make_detail_label(parent: Control, label_name: String, text: String, pos: Vector2, label_size: Vector2, font_size: int, color: Color, alignment := HORIZONTAL_ALIGNMENT_CENTER) -> Label:
	var label := Label.new()
	label.name = label_name
	label.text = text
	label.position = pos
	label.size = label_size
	label.horizontal_alignment = alignment
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.clip_text = true
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	label.add_theme_color_override("font_shadow_color", Color("#050302"))
	label.add_theme_constant_override("shadow_offset_x", 1)
	label.add_theme_constant_override("shadow_offset_y", 1)
	parent.add_child(label)
	return label


func _detail_style(fill: Color, border: Color, border_width: int, radius: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = border
	style.border_width_left = border_width
	style.border_width_right = border_width
	style.border_width_top = border_width
	style.border_width_bottom = border_width
	style.corner_radius_top_left = radius
	style.corner_radius_top_right = radius
	style.corner_radius_bottom_left = radius
	style.corner_radius_bottom_right = radius
	return style


func _skill_display_name(binding: String) -> String:
	var text := binding.replace("skill.", "").replace(".level", "")
	return text.capitalize()


func _collect_skill_labels(root: Node) -> Array:
	var found := []
	_collect_skill_labels_recursive(root, found)
	return found


func _collect_skill_labels_recursive(node: Node, found: Array) -> void:
	if node is Label and str(node.get_meta("component", "")) == "SkillIconSlot":
		var binding := str(node.get_meta("text_binding_or_text_key", ""))
		if binding.begins_with("skill."):
			found.append(node as Label)
	for child in node.get_children():
		_collect_skill_labels_recursive(child, found)


func _parse_max_level(text: String) -> int:
	var parts := text.split("/")
	if parts.size() >= 2:
		return maxi(1, int(parts[1]))
	return 5
