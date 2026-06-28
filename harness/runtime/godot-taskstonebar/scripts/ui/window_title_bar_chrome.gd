extends RefCounted

const TITLE_BAR_NAME := "ProgramTitleBar"
const FILL_NAME := "Rect_ProgramTitleBarBurgundyFill"
const BOTTOM_LINE_NAME := "Line_ProgramTitleBarBottom"
const IRON_CAP_NAME := "Panel_TitleBarIronCap"
const IRON_CAP_TOP_HIGHLIGHT_NAME := "Line_TitleBarIronCapTopHighlight"
const IRON_CAP_BOTTOM_SHADOW_NAME := "Line_TitleBarIronCapBottomShadow"
const LEFT_IRON_ENDCAP_NAME := "Panel_TitleBarLeftIronEndcap"
const RIGHT_IRON_ENDCAP_NAME := "Panel_TitleBarRightIronEndcap"
const LEFT_BADGE_NAME := "Panel_TitleBarLeftStoneBadge"
const LEFT_BADGE_INNER_NAME := "Panel_TitleBarLeftStoneBadgeInner"
const LEFT_STONE_CHIP_NAME := "Panel_TitleBarLeftStoneChip"
const LEFT_STONE_CHIP_HIGHLIGHT_NAME := "Line_TitleBarLeftStoneChipHighlight"
const CENTER_CREST_NAME := "Panel_TitleBarCenterCrest"
const CENTER_CREST_INNER_NAME := "Panel_TitleBarCenterCrestInner"
const RUBY_BEAD_NAME := "Panel_TitleBarRubyBead"
const RUBY_BEAD_GLOW_NAME := "Panel_TitleBarRubyBeadGlow"
const MOSS_ACCENT_NAME := "Panel_TitleBarMossAccent"
const MOSS_ACCENT_2_NAME := "Panel_TitleBarMossAccent2"
const PLATE_TOP_HIGHLIGHT_NAME := "Line_TitleBarPlateTopHighlight"
const PLATE_BOTTOM_SHADOW_NAME := "Line_TitleBarPlateBottomShadow"
const GOLD_RAIL_HIGHLIGHT_NAME := "Line_TitleBarGoldRailHighlight"
const GOLD_RAIL_SHADOW_NAME := "Line_TitleBarGoldRailShadow"
const LEFT_GOLD_TICK_NAME := "Line_TitleBarLeftGoldTick"
const RIGHT_GOLD_TICK_NAME := "Line_TitleBarRightGoldTick"
const CLOSE_ICON_NAME := "Icon_Close"
const BUTTON_TOP_HIGHLIGHT_NAME := "Line_TitleBarButtonTopHighlight"
const BUTTON_INNER_SHADOW_NAME := "Line_TitleBarButtonInnerShadow"
const MINIMIZE_GLYPH_NAME := "Line_TitleBarMinimizeGlyph"

const TITLE_HEIGHT := 42.0
const TITLE_INSET := Vector2(10.0, 10.0)
const TITLE_LABEL_INSET_X := 82.0
const TITLE_LABEL_OFFSET_Y := 7.0
const TITLE_LABEL_HEIGHT := 28.0
const WINDOW_BUTTON_SIZE := Vector2(42.0, 42.0)
const RIGHT_BUTTON_GAP := 6.0

const COLOR_TITLE_FILL := Color("#551d17")
const COLOR_TITLE_BORDER := Color("#271713")
const COLOR_TITLE_GOLD := Color("#ffcf7a")
const COLOR_TITLE_LINE := Color("#d18a24")
const COLOR_IRON_CAP := Color("#111111")
const COLOR_IRON_RIM := Color("#3b3936")
const COLOR_IRON_HIGHLIGHT := Color("#5d5a55")
const COLOR_CARVED_STONE := Color("#252524")
const COLOR_STONE_LIGHT := Color("#77746d")
const COLOR_MOSS := Color("#6a8f42")
const COLOR_RUBY := Color("#d94b74")
const COLOR_SHADOW := Color("#050302")

static func apply(window: Control, config: Dictionary = {}) -> Control:
	if window == null:
		return null
	_hide_legacy_header_art(window)
	var title_bar := _ensure_title_bar(window)
	_ensure_iron_cap(window, title_bar)
	_ensure_burgundy_fill(window, title_bar)
	_ensure_bottom_line(window, title_bar)
	_ensure_forged_ornaments(window, title_bar)
	_hide_decorations(title_bar)
	_hide_help_button(window)

	var title_label: Label = config.get("title_label", null) as Label
	if title_label != null:
		style_title_label(window, title_label)

	var close_button: Button = config.get("close_button", null) as Button
	if close_button != null:
		style_button(window, close_button, 0, "window_close", "")
		var close_icon: Texture2D = config.get("close_icon", null) as Texture2D
		if close_icon != null:
			ensure_close_icon(close_button, close_icon)

	var minimize_button: Button = config.get("minimize_button", null) as Button
	if minimize_button != null:
		if bool(config.get("show_minimize_button", false)):
			style_button(window, minimize_button, 1, "utility_icon", str(config.get("minimize_text", "-")))
			_remove_close_icon(minimize_button)
			minimize_button.visible = true
			minimize_button.disabled = false
			minimize_button.mouse_filter = Control.MOUSE_FILTER_STOP
		else:
			_hide_optional_button(minimize_button)

	return title_bar


static func ensure_title_label(window: Control, node_name: String, text: String) -> Label:
	var existing := window.get_node_or_null(node_name)
	var label: Label
	if existing != null and existing is Label:
		label = existing as Label
	else:
		label = Label.new()
		label.name = node_name
		label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		window.add_child(label)
	label.text = text
	style_title_label(window, label)
	return label


static func ensure_button(window: Control, node_name: String, text: String, tooltip: String) -> Button:
	var existing := window.get_node_or_null(node_name)
	var button: Button
	if existing != null and existing is Button:
		button = existing as Button
	else:
		button = Button.new()
		button.name = node_name
		window.add_child(button)
	button.text = text
	button.tooltip_text = tooltip
	return button


static func style_title_label(window: Control, label: Label) -> void:
	label.position = TITLE_INSET + Vector2(TITLE_LABEL_INSET_X, TITLE_LABEL_OFFSET_Y)
	label.custom_minimum_size = Vector2(80.0, TITLE_LABEL_HEIGHT)
	label.size = Vector2(maxf(80.0, window.size.x - (TITLE_INSET.x + TITLE_LABEL_INSET_X) * 2.0), TITLE_LABEL_HEIGHT)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.clip_text = true
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_font_size_override("font_size", 16)
	label.add_theme_color_override("font_color", COLOR_TITLE_GOLD)
	label.add_theme_color_override("font_shadow_color", COLOR_SHADOW)
	label.add_theme_constant_override("shadow_offset_x", 1)
	label.add_theme_constant_override("shadow_offset_y", 1)
	label.z_index = 5


static func style_button(window: Control, button: Button, right_index: int, role: String, text: String) -> void:
	button.text = "" if role == "utility_icon" else text
	button.position = Vector2(
		maxf(0.0, window.size.x - TITLE_INSET.x - WINDOW_BUTTON_SIZE.x - float(right_index) * (WINDOW_BUTTON_SIZE.x + RIGHT_BUTTON_GAP)),
		TITLE_INSET.y
	)
	button.size = WINDOW_BUTTON_SIZE
	button.custom_minimum_size = WINDOW_BUTTON_SIZE
	button.z_index = 6
	button.flat = false
	button.mouse_filter = Control.MOUSE_FILTER_STOP
	button.set_meta("button_role", role)

	var fill := Color("#5a1e18")
	var border := COLOR_TITLE_LINE
	var radius := 2
	if role == "utility_icon":
		fill = Color("#151513")
		border = Color("#8a5b24")
		radius = 4
	button.add_theme_stylebox_override("normal", _flat_style(fill, border, 2, radius))
	button.add_theme_stylebox_override("hover", _flat_style(fill.lightened(0.12), COLOR_TITLE_GOLD, 2, radius))
	button.add_theme_stylebox_override("pressed", _flat_style(fill.darkened(0.16), border, 2, radius))
	button.add_theme_stylebox_override("disabled", _flat_style(fill.darkened(0.18), Color("#5a5146"), 1, radius))
	button.add_theme_color_override("font_color", COLOR_TITLE_GOLD)
	button.add_theme_color_override("font_hover_color", Color("#fff0a6"))
	button.add_theme_color_override("font_pressed_color", Color("#f3e6c8"))
	button.add_theme_font_size_override("font_size", 16)
	_ensure_button_detail(button)
	if role == "utility_icon" and text == "-":
		_ensure_minimize_glyph(button)
	else:
		_remove_button_detail_node(button, MINIMIZE_GLYPH_NAME)
	button.size = WINDOW_BUTTON_SIZE


static func ensure_close_icon(button: Button, texture: Texture2D) -> void:
	var icon := button.get_node_or_null(CLOSE_ICON_NAME)
	var texture_rect: TextureRect
	if icon != null and icon is TextureRect:
		texture_rect = icon as TextureRect
	else:
		if icon != null:
			icon.queue_free()
		texture_rect = TextureRect.new()
		texture_rect.name = CLOSE_ICON_NAME
		texture_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		button.add_child(texture_rect)
	texture_rect.texture = texture
	texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	texture_rect.anchor_right = 1.0
	texture_rect.anchor_bottom = 1.0
	texture_rect.offset_left = 3.0
	texture_rect.offset_top = 3.0
	texture_rect.offset_right = -3.0
	texture_rect.offset_bottom = -3.0
	texture_rect.z_index = 2


static func _ensure_title_bar(window: Control) -> Control:
	var existing := window.get_node_or_null(TITLE_BAR_NAME)
	var title_bar: Control
	if existing != null and existing is Control:
		title_bar = existing as Control
	else:
		if existing != null:
			_hide_canvas_node(existing)
			existing.name = "%sDeprecated" % TITLE_BAR_NAME
		title_bar = Panel.new()
		title_bar.name = TITLE_BAR_NAME
		window.add_child(title_bar)
	title_bar.position = TITLE_INSET
	title_bar.size = Vector2(maxf(80.0, window.size.x - TITLE_INSET.x * 2.0), TITLE_HEIGHT)
	title_bar.mouse_filter = Control.MOUSE_FILTER_PASS
	title_bar.visible = true
	title_bar.z_index = 2
	title_bar.set_meta("window_title_bar_component", "WindowTitleBarChrome")
	window.set_meta("window_title_bar_component", "WindowTitleBarChrome")
	if title_bar is Panel:
		(title_bar as Panel).add_theme_stylebox_override("panel", _flat_style(Color(0, 0, 0, 0), COLOR_TITLE_BORDER, 2, 1))
	elif title_bar is PanelContainer:
		(title_bar as PanelContainer).add_theme_stylebox_override("panel", _flat_style(Color(0, 0, 0, 0), COLOR_TITLE_BORDER, 2, 1))
	return title_bar


static func _ensure_burgundy_fill(window: Control, title_bar: Control) -> void:
	var existing := window.get_node_or_null(FILL_NAME)
	var fill: ColorRect
	if existing != null and existing is ColorRect:
		fill = existing as ColorRect
	else:
		fill = ColorRect.new()
		fill.name = FILL_NAME
		fill.mouse_filter = Control.MOUSE_FILTER_IGNORE
		window.add_child(fill)
	fill.color = COLOR_TITLE_FILL
	fill.position = title_bar.position + Vector2(2.0, 2.0)
	fill.size = Vector2(maxf(1.0, title_bar.size.x - 4.0), maxf(1.0, title_bar.size.y - 5.0))
	fill.z_index = 1
	window.move_child(fill, max(0, title_bar.get_index()))

	var top_highlight := _ensure_rect(window, PLATE_TOP_HIGHLIGHT_NAME)
	top_highlight.color = Color("#7a2b22")
	top_highlight.position = fill.position + Vector2(6.0, 4.0)
	top_highlight.size = Vector2(maxf(1.0, fill.size.x - 12.0), 1.0)
	top_highlight.z_index = 2

	var bottom_shadow := _ensure_rect(window, PLATE_BOTTOM_SHADOW_NAME)
	bottom_shadow.color = Color("#2c0c0b")
	bottom_shadow.position = fill.position + Vector2(8.0, fill.size.y - 5.0)
	bottom_shadow.size = Vector2(maxf(1.0, fill.size.x - 16.0), 1.0)
	bottom_shadow.z_index = 2


static func _ensure_iron_cap(window: Control, title_bar: Control) -> void:
	var cap := _ensure_panel(window, IRON_CAP_NAME)
	cap.position = title_bar.position + Vector2(-3.0, -4.0)
	cap.size = title_bar.size + Vector2(6.0, 8.0)
	cap.z_index = 0
	cap.mouse_filter = Control.MOUSE_FILTER_IGNORE
	cap.add_theme_stylebox_override("panel", _flat_style(COLOR_IRON_CAP, COLOR_IRON_RIM, 2, 1))

	var top_highlight := _ensure_rect(window, IRON_CAP_TOP_HIGHLIGHT_NAME)
	top_highlight.color = COLOR_IRON_HIGHLIGHT
	top_highlight.position = cap.position + Vector2(5.0, 3.0)
	top_highlight.size = Vector2(maxf(1.0, cap.size.x - 10.0), 1.0)
	top_highlight.z_index = 1

	var bottom_shadow := _ensure_rect(window, IRON_CAP_BOTTOM_SHADOW_NAME)
	bottom_shadow.color = Color("#050505")
	bottom_shadow.position = cap.position + Vector2(4.0, cap.size.y - 4.0)
	bottom_shadow.size = Vector2(maxf(1.0, cap.size.x - 8.0), 2.0)
	bottom_shadow.z_index = 1

	var left_endcap := _ensure_panel(window, LEFT_IRON_ENDCAP_NAME)
	left_endcap.position = cap.position
	left_endcap.size = Vector2(10.0, cap.size.y)
	left_endcap.z_index = 1
	left_endcap.mouse_filter = Control.MOUSE_FILTER_IGNORE
	left_endcap.add_theme_stylebox_override("panel", _flat_style(Color("#1d1c1a"), Color("#4a453e"), 1, 1))

	var right_endcap := _ensure_panel(window, RIGHT_IRON_ENDCAP_NAME)
	right_endcap.position = cap.position + Vector2(cap.size.x - 10.0, 0.0)
	right_endcap.size = Vector2(10.0, cap.size.y)
	right_endcap.z_index = 1
	right_endcap.mouse_filter = Control.MOUSE_FILTER_IGNORE
	right_endcap.add_theme_stylebox_override("panel", _flat_style(Color("#1d1c1a"), Color("#4a453e"), 1, 1))


static func _ensure_bottom_line(window: Control, title_bar: Control) -> void:
	var existing := window.get_node_or_null(BOTTOM_LINE_NAME)
	var line: ColorRect
	if existing != null and existing is ColorRect:
		line = existing as ColorRect
	else:
		line = ColorRect.new()
		line.name = BOTTOM_LINE_NAME
		line.mouse_filter = Control.MOUSE_FILTER_IGNORE
		window.add_child(line)
	line.color = COLOR_TITLE_LINE
	line.position = title_bar.position + Vector2(12.0, title_bar.size.y - 5.0)
	line.size = Vector2(maxf(1.0, title_bar.size.x - 24.0), 2.0)
	line.z_index = 3

	var highlight := _ensure_rect(window, GOLD_RAIL_HIGHLIGHT_NAME)
	highlight.color = Color("#ffd78a")
	highlight.position = line.position
	highlight.size = Vector2(line.size.x, 1.0)
	highlight.z_index = 4

	var shadow := _ensure_rect(window, GOLD_RAIL_SHADOW_NAME)
	shadow.color = Color("#6f3f13")
	shadow.position = line.position + Vector2(0.0, 2.0)
	shadow.size = Vector2(line.size.x, 1.0)
	shadow.z_index = 3


static func _ensure_forged_ornaments(window: Control, title_bar: Control) -> void:
	var badge := _ensure_panel(window, LEFT_BADGE_NAME)
	badge.position = title_bar.position + Vector2(14.0, 6.0)
	badge.size = Vector2(30.0, 28.0)
	badge.z_index = 4
	badge.mouse_filter = Control.MOUSE_FILTER_IGNORE
	badge.add_theme_stylebox_override("panel", _flat_style(COLOR_CARVED_STONE, Color("#8a5b24"), 2, 2))

	var badge_inner := _ensure_panel(window, LEFT_BADGE_INNER_NAME)
	badge_inner.position = badge.position + Vector2(5.0, 5.0)
	badge_inner.size = badge.size - Vector2(10.0, 10.0)
	badge_inner.z_index = 5
	badge_inner.mouse_filter = Control.MOUSE_FILTER_IGNORE
	badge_inner.add_theme_stylebox_override("panel", _flat_style(Color("#151513"), Color("#3a3226"), 1, 1))

	var stone_chip := _ensure_panel(window, LEFT_STONE_CHIP_NAME)
	stone_chip.position = badge.position + Vector2(8.0, 8.0)
	stone_chip.size = Vector2(13.0, 12.0)
	stone_chip.z_index = 6
	stone_chip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stone_chip.add_theme_stylebox_override("panel", _flat_style(Color("#6f6d67"), Color("#1a1a18"), 1, 2))

	var stone_highlight := _ensure_rect(window, LEFT_STONE_CHIP_HIGHLIGHT_NAME)
	stone_highlight.color = COLOR_STONE_LIGHT
	stone_highlight.position = stone_chip.position + Vector2(3.0, 2.0)
	stone_highlight.size = Vector2(5.0, 2.0)
	stone_highlight.z_index = 7

	var moss := _ensure_panel(window, MOSS_ACCENT_NAME)
	moss.position = badge.position + Vector2(19.0, 5.0)
	moss.size = Vector2(7.0, 5.0)
	moss.z_index = 6
	moss.mouse_filter = Control.MOUSE_FILTER_IGNORE
	moss.add_theme_stylebox_override("panel", _flat_style(COLOR_MOSS, Color("#253716"), 1, 1))

	var moss_2 := _ensure_panel(window, MOSS_ACCENT_2_NAME)
	moss_2.position = badge.position + Vector2(5.0, 17.0)
	moss_2.size = Vector2(6.0, 4.0)
	moss_2.z_index = 6
	moss_2.mouse_filter = Control.MOUSE_FILTER_IGNORE
	moss_2.add_theme_stylebox_override("panel", _flat_style(Color("#4f7130"), Color("#253716"), 1, 1))

	var crest := _ensure_panel(window, CENTER_CREST_NAME)
	crest.size = Vector2(14.0, 14.0)
	crest.position = title_bar.position + Vector2(title_bar.size.x * 0.5 - crest.size.x * 0.5, -1.0)
	crest.pivot_offset = crest.size * 0.5
	crest.rotation = PI * 0.25
	crest.z_index = 4
	crest.mouse_filter = Control.MOUSE_FILTER_IGNORE
	crest.add_theme_stylebox_override("panel", _flat_style(Color("#251c12"), COLOR_TITLE_LINE, 2, 1))

	var crest_inner := _ensure_panel(window, CENTER_CREST_INNER_NAME)
	crest_inner.size = Vector2(6.0, 6.0)
	crest_inner.position = crest.position + Vector2(4.0, 4.0)
	crest_inner.pivot_offset = crest_inner.size * 0.5
	crest_inner.rotation = PI * 0.25
	crest_inner.z_index = 5
	crest_inner.mouse_filter = Control.MOUSE_FILTER_IGNORE
	crest_inner.add_theme_stylebox_override("panel", _flat_style(Color("#d18a24"), Color("#392510"), 1, 1))

	var left_tick := _ensure_rect(window, LEFT_GOLD_TICK_NAME)
	left_tick.color = Color("#9a6b2a")
	left_tick.position = title_bar.position + Vector2(title_bar.size.x * 0.5 - 80.0, title_bar.size.y - 14.0)
	left_tick.size = Vector2(34.0, 1.0)
	left_tick.z_index = 3

	var right_tick := _ensure_rect(window, RIGHT_GOLD_TICK_NAME)
	right_tick.color = Color("#9a6b2a")
	right_tick.position = title_bar.position + Vector2(title_bar.size.x * 0.5 + 46.0, title_bar.size.y - 14.0)
	right_tick.size = Vector2(34.0, 1.0)
	right_tick.z_index = 3

	var ruby_glow := _ensure_panel(window, RUBY_BEAD_GLOW_NAME)
	ruby_glow.size = Vector2(12.0, 12.0)
	ruby_glow.position = title_bar.position + Vector2(title_bar.size.x * 0.5 - ruby_glow.size.x * 0.5, title_bar.size.y - 9.0)
	ruby_glow.pivot_offset = ruby_glow.size * 0.5
	ruby_glow.rotation = PI * 0.25
	ruby_glow.z_index = 3
	ruby_glow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ruby_glow.add_theme_stylebox_override("panel", _flat_style(Color(0.38, 0.04, 0.08, 0.72), Color(0.0, 0.0, 0.0, 0.0), 0, 2))

	var ruby := _ensure_panel(window, RUBY_BEAD_NAME)
	ruby.size = Vector2(8.0, 8.0)
	ruby.position = title_bar.position + Vector2(title_bar.size.x * 0.5 - ruby.size.x * 0.5, title_bar.size.y - 7.0)
	ruby.pivot_offset = ruby.size * 0.5
	ruby.rotation = PI * 0.25
	ruby.z_index = 4
	ruby.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ruby.add_theme_stylebox_override("panel", _flat_style(COLOR_RUBY, Color("#ffcf7a"), 1, 1))


static func _ensure_panel(window: Control, node_name: String) -> Panel:
	var existing := window.get_node_or_null(node_name)
	var panel: Panel
	if existing != null and existing is Panel:
		panel = existing as Panel
	else:
		if existing != null:
			existing.queue_free()
		panel = Panel.new()
		panel.name = node_name
		window.add_child(panel)
	return panel


static func _ensure_rect(window: Control, node_name: String) -> ColorRect:
	var existing := window.get_node_or_null(node_name)
	var rect: ColorRect
	if existing != null and existing is ColorRect:
		rect = existing as ColorRect
	else:
		if existing != null:
			existing.queue_free()
		rect = ColorRect.new()
		rect.name = node_name
		window.add_child(rect)
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return rect


static func _ensure_child_rect(parent: Control, node_name: String) -> ColorRect:
	var existing := parent.get_node_or_null(node_name)
	var rect: ColorRect
	if existing != null and existing is ColorRect:
		rect = existing as ColorRect
	else:
		if existing != null:
			existing.queue_free()
		rect = ColorRect.new()
		rect.name = node_name
		parent.add_child(rect)
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return rect


static func _ensure_button_detail(button: Button) -> void:
	var top_highlight := _ensure_child_rect(button, BUTTON_TOP_HIGHLIGHT_NAME)
	top_highlight.color = Color(1.0, 0.82, 0.48, 0.62)
	top_highlight.position = Vector2(6.0, 5.0)
	top_highlight.size = Vector2(maxf(1.0, button.size.x - 12.0), 1.0)
	top_highlight.z_index = 1

	var inner_shadow := _ensure_child_rect(button, BUTTON_INNER_SHADOW_NAME)
	inner_shadow.color = Color(0.02, 0.015, 0.01, 0.64)
	inner_shadow.position = Vector2(6.0, button.size.y - 7.0)
	inner_shadow.size = Vector2(maxf(1.0, button.size.x - 12.0), 1.0)
	inner_shadow.z_index = 1


static func _ensure_minimize_glyph(button: Button) -> void:
	var glyph := _ensure_child_rect(button, MINIMIZE_GLYPH_NAME)
	glyph.color = COLOR_TITLE_GOLD
	glyph.position = Vector2(14.0, 21.0)
	glyph.size = Vector2(14.0, 2.0)
	glyph.z_index = 2


static func _remove_button_detail_node(button: Button, node_name: String) -> void:
	var node := button.get_node_or_null(node_name)
	if node != null:
		node.queue_free()


static func _hide_optional_button(button: Button) -> void:
	button.visible = false
	button.disabled = true
	button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_remove_close_icon(button)
	_remove_button_detail_node(button, BUTTON_TOP_HIGHLIGHT_NAME)
	_remove_button_detail_node(button, BUTTON_INNER_SHADOW_NAME)
	_remove_button_detail_node(button, MINIMIZE_GLYPH_NAME)


static func _hide_legacy_header_art(window: Control) -> void:
	for child in window.get_children():
		var child_name := str(child.name)
		if child_name == TITLE_BAR_NAME:
			continue
		if child_name.ends_with("TitleBar") or child_name.ends_with("WindowOrnament") or child_name == "ProgramWindowIcon":
			_hide_canvas_node(child)


static func _hide_decorations(title_bar: Control) -> void:
	for node_name in [
		"Rect_HeaderBurgundyFill",
		"Panel_HeaderLeftPattern",
		"Panel_HeaderLeftGoldSlash",
		"Panel_HeaderRightGoldSlash",
		"Panel_HeaderCenterRivets",
	]:
		var node := title_bar.get_node_or_null(node_name)
		if node != null:
			_hide_canvas_node(node)


static func _hide_help_button(window: Control) -> void:
	var help := window.get_node_or_null("Btn_ProgramHelp")
	if help == null:
		return
	_hide_canvas_node(help)
	if help is Button:
		(help as Button).disabled = true


static func _hide_canvas_node(node: Node) -> void:
	if node is CanvasItem:
		(node as CanvasItem).visible = false
	if node is Control:
		(node as Control).mouse_filter = Control.MOUSE_FILTER_IGNORE


static func _remove_close_icon(button: Button) -> void:
	var icon := button.get_node_or_null(CLOSE_ICON_NAME)
	if icon != null:
		icon.queue_free()


static func _flat_style(fill: Color, border: Color, border_width: int, radius: int) -> StyleBoxFlat:
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
