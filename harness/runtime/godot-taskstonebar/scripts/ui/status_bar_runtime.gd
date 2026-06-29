extends RefCounted

const LAYER_NAME := "RuntimeDesktopStatusBarLayer"
const TOP_LINE_NAME := "Panel_StatusBarTopLine"
const TOP_SHADOW_NAME := "Panel_StatusBarTopInsetShadow"


static func ensure_desktop_status_bar(scaffold: Control, band: PanelContainer, reference_width: float) -> Control:
	if scaffold == null or band == null:
		return null
	band.position = Vector2(0.0, 948.0)
	band.size = Vector2(reference_width, 44.0)
	band.custom_minimum_size = band.size
	band.mouse_filter = Control.MOUSE_FILTER_IGNORE
	band.add_theme_stylebox_override("panel", _style(Color("#080604"), Color(0.0, 0.0, 0.0, 0.0), 0, 0))
	for child in band.get_children():
		if str(child.name) != "Text_SteamSyncStatus":
			child.queue_free()
		elif child is CanvasItem:
			(child as CanvasItem).visible = false

	var layer := scaffold.get_node_or_null(LAYER_NAME)
	if layer == null or not layer is Control:
		layer = Control.new()
		layer.name = LAYER_NAME
		layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
		scaffold.add_child(layer)
	var status_layer := layer as Control
	status_layer.position = Vector2(0.0, 948.0)
	status_layer.size = Vector2(reference_width, 44.0)
	status_layer.z_index = 20

	_ensure_rect(status_layer, TOP_LINE_NAME, Vector2.ZERO, Vector2(status_layer.size.x, 1.0), Color(0.82, 0.54, 0.20, 0.42), 4)
	_ensure_rect(status_layer, TOP_SHADOW_NAME, Vector2(0.0, 1.0), Vector2(status_layer.size.x, 1.0), Color(0.0, 0.0, 0.0, 0.38), 4)

	_ensure_chip(status_layer, "Panel_StatusBarBrandChip", Vector2(0.0, 8.0), Vector2(206.0, 28.0), Color("#1a1008"), Color("#d18a24"))
	_ensure_chip(status_layer, "Panel_StatusBarModeChip", Vector2(222.0, 8.0), Vector2(160.0, 28.0), Color("#251711"), Color("#6b4a2a"))
	_ensure_chip(status_layer, "Panel_StatusBarCombatChip", Vector2(398.0, 8.0), Vector2(378.0, 28.0), Color("#10100f"), Color("#6b4a2a"))
	_ensure_chip(status_layer, "Panel_StatusBarWindowsChip", Vector2(792.0, 8.0), Vector2(318.0, 28.0), Color("#10100f"), Color("#6b4a2a"))
	_ensure_chip(status_layer, "Panel_StatusBarSyncChip", Vector2(1210.0, 8.0), Vector2(376.0, 28.0), Color("#120c08"), Color("#8a5b24"))

	var brand := _ensure_label(status_layer, "Text_StatusBarBrand", "TASKSTONEBAR", Vector2(16.0, 11.0), Vector2(174.0, 20.0), 13, Color("#ffcf7a"))
	brand.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_ensure_label(status_layer, "Text_StatusBarMode", "WORKSHOP", Vector2(238.0, 11.0), Vector2(128.0, 20.0), 12, Color("#f3e6c8"))
	var combat := _ensure_label(status_layer, "Text_StatusBarCombat", "", Vector2(414.0, 11.0), Vector2(346.0, 20.0), 12, Color("#f3e6c8"))
	combat.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	var windows := _ensure_label(status_layer, "Text_StatusBarWindows", "", Vector2(808.0, 11.0), Vector2(286.0, 20.0), 12, Color("#b79a72"))
	windows.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_ensure_label(status_layer, "Text_StatusBarSync", "", Vector2(1226.0, 11.0), Vector2(344.0, 20.0), 12, Color("#f3e6c8"))
	return status_layer


static func set_mode(status_bar: Control, taskbar_mode: bool) -> void:
	var mode_label := status_bar.get_node_or_null("Text_StatusBarMode") if status_bar != null else null
	if mode_label == null or not mode_label is Label:
		return
	var label := mode_label as Label
	label.text = "TASKBAR" if taskbar_mode else "WORKSHOP"
	label.add_theme_color_override("font_color", Color("#ffcf7a") if taskbar_mode else Color("#f3e6c8"))


static func set_text(parent: Control, node_name: String, text: String) -> void:
	var node := parent.get_node_or_null(node_name) if parent != null else null
	if node != null and node is Label:
		(node as Label).text = text


static func _ensure_rect(parent: Control, node_name: String, pos: Vector2, rect_size: Vector2, color: Color, z: int) -> ColorRect:
	var node := parent.get_node_or_null(node_name)
	var rect: ColorRect
	if node != null and node is ColorRect:
		rect = node as ColorRect
	else:
		rect = ColorRect.new()
		rect.name = node_name
		rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		parent.add_child(rect)
	rect.position = pos
	rect.size = rect_size
	rect.color = color
	rect.z_index = z
	return rect


static func _ensure_chip(parent: Control, node_name: String, pos: Vector2, chip_size: Vector2, fill: Color, border: Color) -> PanelContainer:
	var soft_fill := fill
	soft_fill.a = minf(fill.a, 0.94)
	var soft_border := border
	soft_border.a = minf(border.a, 0.58)
	var panel := _ensure_panel(parent, node_name, pos, chip_size, soft_fill, soft_border, 1, 1)
	panel.z_index = 1
	return panel


static func _ensure_panel(parent: Control, node_name: String, pos: Vector2, panel_size: Vector2, fill: Color, border: Color, border_width: int, radius: int) -> PanelContainer:
	var node := parent.get_node_or_null(node_name)
	var panel: PanelContainer
	if node != null and node is PanelContainer:
		panel = node as PanelContainer
	else:
		panel = PanelContainer.new()
		panel.name = node_name
		panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
		parent.add_child(panel)
	panel.position = pos
	panel.size = panel_size
	panel.custom_minimum_size = panel_size
	panel.add_theme_stylebox_override("panel", _style(fill, border, border_width, radius))
	return panel


static func _ensure_label(parent: Control, node_name: String, text: String, pos: Vector2, label_size: Vector2, font_size: int, color: Color) -> Label:
	var node := parent.get_node_or_null(node_name)
	var label: Label
	if node != null and node is Label:
		label = node as Label
	else:
		label = Label.new()
		label.name = node_name
		label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		parent.add_child(label)
	label.text = text
	label.position = pos
	label.size = label_size
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	label.add_theme_color_override("font_shadow_color", Color("#050302"))
	label.add_theme_constant_override("shadow_offset_x", 1)
	label.add_theme_constant_override("shadow_offset_y", 1)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.clip_text = true
	label.z_index = 3
	return label


static func _style(fill: Color, border: Color, border_width: int, radius: int) -> StyleBoxFlat:
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
