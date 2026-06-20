extends Control

signal modal_closed

var dim: ColorRect
var outside_button: Button
var modal_root: Control
var stack: Array[Control] = []
var built := false


func setup(layer_size: Vector2) -> void:
	size = layer_size
	if not built:
		_build()
		built = true
	_sync_visibility()


func open_modal(modal: Control) -> void:
	if stack.size() > 0:
		stack[stack.size() - 1].visible = false
	stack.append(modal)
	modal_root.add_child(modal)
	_center_modal(modal)
	if modal.has_signal("close_requested"):
		modal.close_requested.connect(close_top)
	_sync_visibility()


func close_top() -> void:
	if stack.is_empty():
		return
	var modal: Control = stack.pop_back()
	if is_instance_valid(modal):
		modal.queue_free()
	if stack.size() > 0:
		var previous: Control = stack[stack.size() - 1]
		previous.visible = true
		_center_modal(previous)
	_sync_visibility()
	modal_closed.emit()


func close_all() -> void:
	while not stack.is_empty():
		var modal: Control = stack.pop_back()
		if is_instance_valid(modal):
			modal.queue_free()
	_sync_visibility()
	modal_closed.emit()


func current_modal() -> Control:
	if stack.is_empty():
		return null
	return stack[stack.size() - 1]


func has_open_modal() -> bool:
	return not stack.is_empty()


func sync_current_modal() -> void:
	var modal: Control = current_modal()
	if modal != null and modal.has_method("sync_state"):
		modal.sync_state()


func _build() -> void:
	position = Vector2.ZERO
	visible = false
	mouse_filter = Control.MOUSE_FILTER_STOP

	dim = ColorRect.new()
	dim.position = Vector2.ZERO
	dim.size = size
	dim.color = Color(0.02, 0.015, 0.01, 0.58)
	add_child(dim)

	outside_button = Button.new()
	outside_button.position = Vector2.ZERO
	outside_button.size = size
	outside_button.flat = true
	outside_button.focus_mode = Control.FOCUS_NONE
	outside_button.pressed.connect(close_top)
	add_child(outside_button)

	modal_root = Control.new()
	modal_root.position = Vector2.ZERO
	modal_root.size = size
	modal_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(modal_root)


func _input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_cancel"):
		close_top()
		get_viewport().set_input_as_handled()


func _sync_visibility() -> void:
	visible = not stack.is_empty()
	if dim != null:
		dim.visible = visible
	if outside_button != null:
		outside_button.visible = visible


func _center_modal(modal: Control) -> void:
	modal.position = (size - modal.size) * 0.5
