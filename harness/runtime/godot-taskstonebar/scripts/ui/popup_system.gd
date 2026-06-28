extends RefCounted

signal popup_confirmed(popup_id: String)
signal popup_cancelled(popup_id: String)
signal popup_closed(popup_id: String)

const FRAME_TEXTURE := "res://assets/generated/ui/window_frame_9slice.png"
const INNER_TEXTURE := "res://assets/generated/ui/dark_inner_well_9slice.png"
const TITLE_TEXTURE := "res://assets/generated/ui/window_title_bar_9slice.png"
const CLOSE_TEXTURE := "res://assets/generated/ui/close_icon.png"
const TOAST_TEXTURE := "res://assets/generated/ui/rare_drop_toast_9slice.png"

const DEFAULT_ALERT_RECT := Rect2(Vector2(568.0, 168.0), Vector2(450.0, 292.0))
const DEFAULT_CONFIRM_RECT := Rect2(Vector2(548.0, 146.0), Vector2(490.0, 344.0))
const DEFAULT_TOAST_SIZE := Vector2(280.0, 76.0)
const SCRIM_RECT := Rect2(Vector2.ZERO, Vector2(1586.0, 704.0))

var host: Control
var active_popup_id := ""
var active_confirm_callback: Callable
var active_cancel_callback: Callable
var active_toasts: Dictionary = {}


func setup(modal_host: Control) -> void:
	host = modal_host
	if host == null:
		return
	host.mouse_filter = Control.MOUSE_FILTER_IGNORE


func show_alert(config: Dictionary = {}) -> Control:
	return _show_dialog("alert", config)


func show_confirm(config: Dictionary = {}) -> Control:
	return _show_dialog("confirm", config)


func show_toast(config: Dictionary = {}) -> Control:
	if host == null:
		return null
	var popup_id := str(config.get("id", "toast"))
	var title := str(config.get("title", "알림"))
	var message := str(config.get("message", ""))
	var duration := float(config.get("duration", 2.4))
	var toast := _build_toast(popup_id, title, message)
	host.add_child(toast)
	host.move_child(toast, host.get_child_count() - 1)
	active_toasts[popup_id] = toast
	if duration > 0.0:
		var timer := host.get_tree().create_timer(duration)
		timer.timeout.connect(func():
			close_toast(popup_id)
		)
	return toast


func close_popup() -> void:
	if host == null:
		return
	var closing_id := active_popup_id
	for child in host.get_children():
		if child.has_meta("popup_system_primary"):
			host.remove_child(child)
			child.queue_free()
	active_popup_id = ""
	active_confirm_callback = Callable()
	active_cancel_callback = Callable()
	host.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if closing_id != "":
		popup_closed.emit(closing_id)


func close_toast(popup_id: String) -> void:
	var node: Variant = active_toasts.get(popup_id, null)
	active_toasts.erase(popup_id)
	if node != null and is_instance_valid(node):
		(node as Node).queue_free()


func has_active_popup() -> bool:
	return active_popup_id != ""


func _show_dialog(kind: String, config: Dictionary) -> Control:
	if host == null:
		return null
	close_popup()
	host.mouse_filter = Control.MOUSE_FILTER_PASS

	var popup_id := str(config.get("id", kind))
	var title := str(config.get("title", "알림" if kind == "alert" else "확인"))
	var message := str(config.get("message", ""))
	var detail := str(config.get("detail", ""))
	var close_on_backdrop := bool(config.get("close_on_backdrop", kind == "alert"))
	active_popup_id = popup_id
	active_confirm_callback = config.get("on_confirm", Callable()) if config.has("on_confirm") else Callable()
	active_cancel_callback = config.get("on_cancel", Callable()) if config.has("on_cancel") else Callable()

	var scrim := Button.new()
	scrim.name = "Scrim_PopupSystem"
	scrim.position = SCRIM_RECT.position
	scrim.size = _clamped_scrim_size()
	scrim.flat = true
	scrim.mouse_filter = Control.MOUSE_FILTER_STOP
	scrim.set_meta("popup_system_primary", true)
	scrim.add_theme_stylebox_override("normal", _flat_style(Color(0.02, 0.015, 0.01, 0.44), Color.TRANSPARENT, 0, 0))
	scrim.add_theme_stylebox_override("hover", _flat_style(Color(0.02, 0.015, 0.01, 0.40), Color.TRANSPARENT, 0, 0))
	if close_on_backdrop:
		scrim.pressed.connect(_cancel_active_popup)
	host.add_child(scrim)

	var rect: Rect2 = config.get("rect", DEFAULT_ALERT_RECT if kind == "alert" else DEFAULT_CONFIRM_RECT)
	var frame := _build_dialog_frame(popup_id, title, message, detail, rect, kind)
	frame.set_meta("popup_system_primary", true)
	host.add_child(frame)
	return frame


func _build_dialog_frame(popup_id: String, title: String, message: String, detail: String, rect: Rect2, kind: String) -> Panel:
	var frame := Panel.new()
	frame.name = "PopupSystem_%s" % popup_id.capitalize().replace(" ", "")
	frame.position = _frame_position(rect.size, rect.position)
	frame.size = rect.size
	frame.mouse_filter = Control.MOUSE_FILTER_STOP
	frame.add_theme_stylebox_override("panel", _texture_style(FRAME_TEXTURE, 30, 30, 34, 30, Color("#0a0908"), Color("#d18a24")))

	var shadow := ColorRect.new()
	shadow.name = "PopupShadow"
	shadow.position = Vector2(8.0, 9.0)
	shadow.size = frame.size
	shadow.color = Color(0, 0, 0, 0.32)
	shadow.z_index = -1
	shadow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	frame.add_child(shadow)

	var title_bar := Panel.new()
	title_bar.name = "Panel_PopupTitleBar"
	title_bar.position = Vector2(14.0, 12.0)
	title_bar.size = Vector2(frame.size.x - 28.0, 42.0)
	title_bar.add_theme_stylebox_override("panel", _texture_style(TITLE_TEXTURE, 26, 26, 18, 18, Color("#541e17"), Color("#271713")))
	frame.add_child(title_bar)

	var title_label := _make_label("Text_PopupTitle", title, Vector2(44.0, 6.0), Vector2(title_bar.size.x - 92.0, 30.0), 18, Color("#ffcf7a"))
	title_bar.add_child(title_label)

	var close_button := Button.new()
	close_button.name = "Btn_PopupClose"
	close_button.position = Vector2(title_bar.size.x - 35.0, 8.0)
	close_button.size = Vector2(26.0, 26.0)
	close_button.tooltip_text = "닫기"
	close_button.flat = true
	close_button.pressed.connect(_cancel_active_popup)
	title_bar.add_child(close_button)
	_add_close_icon(close_button)

	var body := Panel.new()
	body.name = "Panel_PopupBody"
	body.position = Vector2(28.0, 70.0)
	body.size = Vector2(frame.size.x - 56.0, frame.size.y - 136.0)
	body.add_theme_stylebox_override("panel", _texture_style(INNER_TEXTURE, 22, 22, 22, 22, Color("#080a0a"), Color("#6b4a2a")))
	frame.add_child(body)

	var message_label := _make_label("Text_PopupMessage", message, Vector2(22.0, 18.0), Vector2(body.size.x - 44.0, 56.0), 15, Color("#f3e6c8"))
	message_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	body.add_child(message_label)
	if detail != "":
		var detail_label := _make_label("Text_PopupDetail", detail, Vector2(22.0, 82.0), Vector2(body.size.x - 44.0, body.size.y - 98.0), 12, Color("#b79a72"))
		detail_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		body.add_child(detail_label)

	var footer := HBoxContainer.new()
	footer.name = "Footer_PopupActions"
	footer.position = Vector2(54.0, frame.size.y - 54.0)
	footer.size = Vector2(frame.size.x - 108.0, 34.0)
	footer.alignment = BoxContainer.ALIGNMENT_CENTER
	footer.add_theme_constant_override("separation", 10)
	frame.add_child(footer)

	if kind == "confirm":
		var cancel := _make_button("Btn_PopupCancel", "취소", Vector2(104.0, 34.0), false)
		cancel.pressed.connect(_cancel_active_popup)
		footer.add_child(cancel)
	var confirm := _make_button("Btn_PopupConfirm", str("확인" if kind == "alert" else "진행"), Vector2(124.0, 34.0), true)
	if kind == "alert":
		confirm.pressed.connect(_close_active_popup)
	else:
		confirm.pressed.connect(_confirm_active_popup)
	footer.add_child(confirm)
	return frame


func _build_toast(popup_id: String, title: String, message: String) -> NinePatchRect:
	var toast := NinePatchRect.new()
	toast.name = "Toast_%s" % popup_id.capitalize().replace(" ", "")
	toast.texture = load(TOAST_TEXTURE)
	toast.patch_margin_left = 22
	toast.patch_margin_right = 22
	toast.patch_margin_top = 18
	toast.patch_margin_bottom = 18
	toast.size = DEFAULT_TOAST_SIZE
	toast.position = _toast_position(toast.size)
	toast.mouse_filter = Control.MOUSE_FILTER_IGNORE
	toast.z_index = 1100

	var title_label := _make_label("Text_ToastTitle", title, Vector2(18.0, 10.0), Vector2(toast.size.x - 36.0, 22.0), 14, Color("#ffcf7a"))
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	toast.add_child(title_label)
	var body_label := _make_label("Text_ToastBody", message, Vector2(18.0, 34.0), Vector2(toast.size.x - 36.0, 28.0), 11, Color("#f3e6c8"))
	body_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	toast.add_child(body_label)
	return toast


func _confirm_active_popup() -> void:
	var popup_id := active_popup_id
	if active_confirm_callback.is_valid():
		active_confirm_callback.call()
	popup_confirmed.emit(popup_id)
	close_popup()


func _cancel_active_popup() -> void:
	var popup_id := active_popup_id
	if active_cancel_callback.is_valid():
		active_cancel_callback.call()
	popup_cancelled.emit(popup_id)
	close_popup()


func _close_active_popup() -> void:
	close_popup()


func _clamped_scrim_size() -> Vector2:
	if host == null:
		return SCRIM_RECT.size
	if host.size.x <= 0.0 or host.size.y <= 0.0:
		return SCRIM_RECT.size
	return Vector2(host.size.x, minf(host.size.y, SCRIM_RECT.size.y))


func _frame_position(frame_size: Vector2, preferred: Vector2) -> Vector2:
	if host == null or host.size.x <= 0.0:
		return preferred
	if host.size.x >= 1180.0:
		return preferred
	return Vector2(maxf(0.0, (host.size.x - frame_size.x) * 0.5), maxf(18.0, (host.size.y - frame_size.y) * 0.5))


func _toast_position(toast_size: Vector2) -> Vector2:
	if host == null or host.size.x <= 0.0:
		return Vector2(1260.0, 620.0)
	return Vector2(maxf(20.0, host.size.x - toast_size.x - 36.0), maxf(20.0, minf(host.size.y - toast_size.y - 24.0, 628.0)))


func _make_label(node_name: String, text: String, pos: Vector2, label_size: Vector2, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.name = node_name
	label.text = text
	label.position = pos
	label.size = label_size
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	label.add_theme_color_override("font_shadow_color", Color("#050302"))
	label.add_theme_constant_override("shadow_offset_x", 2)
	label.add_theme_constant_override("shadow_offset_y", 2)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.clip_text = true
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return label


func _make_button(node_name: String, text: String, button_size: Vector2, primary: bool) -> Button:
	var button := Button.new()
	button.name = node_name
	button.text = text
	button.custom_minimum_size = button_size
	button.size = button_size
	var fill := Color("#9b4a1d") if primary else Color("#2d251f")
	var border := Color("#ffcf7a") if primary else Color("#6b4a2a")
	button.add_theme_stylebox_override("normal", _flat_style(fill, border, 2, 3))
	button.add_theme_stylebox_override("hover", _flat_style(fill.lightened(0.12), Color("#ffdf96"), 2, 3))
	button.add_theme_stylebox_override("pressed", _flat_style(fill.darkened(0.16), border, 2, 3))
	button.add_theme_color_override("font_color", Color("#fff0c9"))
	button.add_theme_font_size_override("font_size", 13)
	return button


func _add_close_icon(button: Button) -> void:
	var texture: Texture2D = load(CLOSE_TEXTURE)
	if texture == null:
		button.text = "X"
		return
	var icon := TextureRect.new()
	icon.name = "Icon_PopupClose"
	icon.texture = texture
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.position = Vector2(1.0, 1.0)
	icon.size = button.size - Vector2(2.0, 2.0)
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	button.add_child(icon)


func _texture_style(path: String, left: int, right: int, top: int, bottom: int, fallback_fill: Color, fallback_border: Color) -> StyleBox:
	var texture: Texture2D = load(path)
	if texture == null:
		return _flat_style(fallback_fill, fallback_border, 2, 3)
	var style := StyleBoxTexture.new()
	style.texture = texture
	style.texture_margin_left = left
	style.texture_margin_right = right
	style.texture_margin_top = top
	style.texture_margin_bottom = bottom
	style.content_margin_left = 10
	style.content_margin_right = 10
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	return style


func _flat_style(fill: Color, border: Color, border_width: int, radius: int) -> StyleBoxFlat:
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
