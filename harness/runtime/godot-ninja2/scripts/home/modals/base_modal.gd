extends PanelContainer

signal close_requested
signal action_requested(action: String)

const HomeTheme := preload("res://scripts/home/components/home_theme.gd")

var body: Control
var frame_root: Control
var title_label: Label
var subtitle_label: Label
var primary_button: Button
var secondary_button: Button
var built := false


func setup_frame(title: String, subtitle: String, modal_size := Vector2(360, 420)) -> void:
	size = modal_size
	if not built:
		_build_frame()
		built = true
	title_label.text = title
	subtitle_label.text = subtitle


func clear_body() -> void:
	if body == null:
		return
	for child in body.get_children():
		body.remove_child(child)
		child.queue_free()


func set_primary_action(label: String, action: String, disabled := false) -> void:
	primary_button.text = label
	primary_button.disabled = disabled
	primary_button.set_meta("action", action)


func set_secondary_action(label: String, action: String) -> void:
	secondary_button.text = label
	secondary_button.disabled = false
	secondary_button.set_meta("action", action)


func _build_frame() -> void:
	add_theme_stylebox_override("panel", HomeTheme.style(Color(0.90, 0.78, 0.58, 0.98), Color(0.16, 0.10, 0.06, 0.98), 10, 2))

	frame_root = Control.new()
	frame_root.size = size
	add_child(frame_root)

	title_label = Label.new()
	title_label.position = Vector2(18, 15)
	title_label.size = Vector2(size.x - 72, 24)
	title_label.add_theme_font_size_override("font_size", 18)
	title_label.add_theme_color_override("font_color", Color(0.13, 0.08, 0.04))
	frame_root.add_child(title_label)

	subtitle_label = Label.new()
	subtitle_label.position = Vector2(18, 40)
	subtitle_label.size = Vector2(size.x - 72, 18)
	subtitle_label.add_theme_font_size_override("font_size", 11)
	subtitle_label.add_theme_color_override("font_color", Color(0.30, 0.20, 0.11))
	frame_root.add_child(subtitle_label)

	var close_button := Button.new()
	close_button.text = "X"
	close_button.position = Vector2(size.x - 42, 14)
	close_button.size = Vector2(28, 28)
	close_button.focus_mode = Control.FOCUS_NONE
	close_button.add_theme_font_size_override("font_size", 13)
	close_button.add_theme_stylebox_override("normal", HomeTheme.style(Color(0.22, 0.14, 0.08, 0.86), Color(0.92, 0.72, 0.42, 0.65), 7, 1))
	close_button.pressed.connect(func(): close_requested.emit())
	frame_root.add_child(close_button)

	var divider := ColorRect.new()
	divider.color = Color(0.32, 0.21, 0.12, 0.32)
	divider.position = Vector2(16, 66)
	divider.size = Vector2(size.x - 32, 1)
	frame_root.add_child(divider)

	body = Control.new()
	body.position = Vector2(16, 76)
	body.size = Vector2(size.x - 32, size.y - 144)
	frame_root.add_child(body)

	secondary_button = Button.new()
	secondary_button.position = Vector2(18, size.y - 54)
	secondary_button.size = Vector2(112, 38)
	secondary_button.focus_mode = Control.FOCUS_NONE
	secondary_button.add_theme_font_size_override("font_size", 12)
	secondary_button.add_theme_stylebox_override("normal", HomeTheme.style(Color(0.28, 0.22, 0.16, 0.92), Color(0.72, 0.58, 0.38, 0.72), 8, 1))
	secondary_button.pressed.connect(_emit_secondary_action)
	frame_root.add_child(secondary_button)

	primary_button = Button.new()
	primary_button.position = Vector2(size.x - 142, size.y - 54)
	primary_button.size = Vector2(124, 38)
	primary_button.focus_mode = Control.FOCUS_NONE
	primary_button.add_theme_font_size_override("font_size", 12)
	primary_button.add_theme_stylebox_override("normal", HomeTheme.style(Color(0.62, 0.30, 0.08, 0.96), Color(1.0, 0.82, 0.38, 0.82), 8, 1))
	primary_button.add_theme_stylebox_override("hover", HomeTheme.style(Color(0.74, 0.38, 0.10, 0.98), Color(1.0, 0.90, 0.54, 0.92), 8, 1))
	primary_button.add_theme_stylebox_override("disabled", HomeTheme.style(Color(0.24, 0.20, 0.16, 0.84), Color(0.56, 0.48, 0.36, 0.52), 8, 1))
	primary_button.pressed.connect(_emit_primary_action)
	frame_root.add_child(primary_button)

	set_primary_action("확인", "confirm")
	set_secondary_action("닫기", "close")


func _emit_primary_action() -> void:
	var action := str(primary_button.get_meta("action", "confirm"))
	if action == "close":
		close_requested.emit()
	else:
		action_requested.emit(action)


func _emit_secondary_action() -> void:
	var action := str(secondary_button.get_meta("action", "close"))
	if action == "close":
		close_requested.emit()
	else:
		action_requested.emit(action)
