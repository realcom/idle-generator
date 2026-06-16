extends Control

const ContentStoreScript := preload("res://scripts/content_store.gd")
const AiBridgeScript := preload("res://scripts/ai_bridge.gd")

var store
var ai

var status_label: Label
var endpoint_edit: LineEdit
var model_edit: LineEdit
var api_key_edit: LineEdit
var summary_box: TextEdit
var prompt_box: TextEdit
var response_box: RichTextLabel
var ask_button: Button


func _ready() -> void:
	store = ContentStoreScript.new()
	ai = AiBridgeScript.new()
	add_child(ai)
	ai.completed.connect(_on_ai_completed)

	_build_ui()
	_load_content()


func _build_ui() -> void:
	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_top", 14)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_bottom", 14)
	add_child(margin)

	var root := VBoxContainer.new()
	root.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_theme_constant_override("separation", 10)
	margin.add_child(root)

	var title := Label.new()
	title.text = "Idlez Godot AI Bridge"
	title.add_theme_font_size_override("font_size", 24)
	root.add_child(title)

	status_label = Label.new()
	status_label.text = "Loading harness data..."
	root.add_child(status_label)

	var config_grid := GridContainer.new()
	config_grid.columns = 2
	config_grid.add_theme_constant_override("h_separation", 10)
	config_grid.add_theme_constant_override("v_separation", 8)
	root.add_child(config_grid)

	_add_config_row(config_grid, "Endpoint", _make_endpoint_edit())
	_add_config_row(config_grid, "Model", _make_model_edit())
	_add_config_row(config_grid, "API key", _make_api_key_edit())

	var split := HSplitContainer.new()
	split.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	split.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(split)

	summary_box = TextEdit.new()
	summary_box.editable = false
	summary_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	summary_box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	summary_box.custom_minimum_size = Vector2(470, 0)
	split.add_child(summary_box)

	var right := VBoxContainer.new()
	right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right.size_flags_vertical = Control.SIZE_EXPAND_FILL
	right.add_theme_constant_override("separation", 8)
	split.add_child(right)

	prompt_box = TextEdit.new()
	prompt_box.text = (
		"현재 Units/Items/Maps를 기준으로 초반 5분 플레이어에게 추천할 성장 액션을 "
		+ "3개만 제안해줘. 반드시 기존 item/map/unit id를 근거로 써줘."
	)
	prompt_box.custom_minimum_size = Vector2(0, 130)
	prompt_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right.add_child(prompt_box)

	var buttons := HBoxContainer.new()
	buttons.add_theme_constant_override("separation", 8)
	right.add_child(buttons)

	var reload_button := Button.new()
	reload_button.text = "Reload Harness JSON"
	reload_button.pressed.connect(_load_content)
	buttons.add_child(reload_button)

	ask_button = Button.new()
	ask_button.text = "Ask AI"
	ask_button.pressed.connect(_ask_ai)
	buttons.add_child(ask_button)

	var copy_button := Button.new()
	copy_button.text = "Copy Response"
	copy_button.pressed.connect(_copy_response)
	buttons.add_child(copy_button)

	response_box = RichTextLabel.new()
	response_box.fit_content = false
	response_box.selection_enabled = true
	response_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	response_box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	response_box.text = "AI response will appear here."
	right.add_child(response_box)


func _make_endpoint_edit() -> LineEdit:
	endpoint_edit = LineEdit.new()
	endpoint_edit.text = ai.endpoint
	endpoint_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return endpoint_edit


func _make_model_edit() -> LineEdit:
	model_edit = LineEdit.new()
	model_edit.text = ai.model
	model_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return model_edit


func _make_api_key_edit() -> LineEdit:
	api_key_edit = LineEdit.new()
	api_key_edit.secret = true
	api_key_edit.placeholder_text = "Optional for local Ollama / LM Studio"
	api_key_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return api_key_edit


func _add_config_row(grid: GridContainer, label_text: String, field: Control) -> void:
	var label := Label.new()
	label.text = label_text
	grid.add_child(label)
	grid.add_child(field)


func _load_content() -> void:
	var ok: bool = store.load_all()
	summary_box.text = store.build_context_summary()

	if ok:
		var counts := store.get_counts()
		status_label.text = (
			"Loaded harness/build/idlez: %d units, %d items, %d maps, %d skills"
			% [counts["Units"], counts["Items"], counts["Maps"], counts["Skills"]]
		)
	else:
		status_label.text = "Loaded with warnings. See summary."


func _ask_ai() -> void:
	ai.endpoint = endpoint_edit.text.strip_edges()
	ai.model = model_edit.text.strip_edges()
	ai.api_key = api_key_edit.text

	if ai.endpoint == "" or ai.model == "":
		response_box.text = "Endpoint and model are required."
		return

	ask_button.disabled = true
	status_label.text = "Sending prompt to AI..."
	response_box.text = "Waiting for response..."

	var err := ai.ask(prompt_box.text, store.build_context_summary(6))
	if err != OK:
		ask_button.disabled = false
		status_label.text = "AI request did not start."
		response_box.text = "Request error: %s" % error_string(err)


func _on_ai_completed(ok: bool, text: String, _raw: Dictionary) -> void:
	ask_button.disabled = false
	status_label.text = "AI response complete." if ok else "AI response failed."
	response_box.text = text


func _copy_response() -> void:
	DisplayServer.clipboard_set(response_box.text)
