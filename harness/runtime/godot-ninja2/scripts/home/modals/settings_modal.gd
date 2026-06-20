extends "res://scripts/home/modals/tab_modal_base.gd"

const SETTING_ROWS := [
	{"key": "bgm", "title": "배경음", "detail": "성소와 전투 배경 음악"},
	{"key": "sfx", "title": "효과음", "detail": "버튼, 보상, 타격 효과"},
	{"key": "low_power", "title": "절전 모드", "detail": "이펙트와 갱신 빈도를 줄이는 모드"},
]


func setup(content_store, housing_store, sanctuary_state, texture_table: Dictionary) -> void:
	setup_context(content_store, housing_store, sanctuary_state, texture_table, "설정", "사운드 · 화면 · 계정", Vector2(360, 420))
	sync_state()


func sync_state() -> void:
	if sanctuary == null:
		return
	clear_body()
	for index in range(SETTING_ROWS.size()):
		_render_setting_row(SETTING_ROWS[index], float(index) * 72.0)
	_render_account_panel()
	set_primary_action("확인", "close")
	set_secondary_action("타이틀", "return_title")


func _render_setting_row(row: Dictionary, row_y: float) -> void:
	var setting_key := str(row.get("key", ""))
	var enabled := bool(sanctuary.settings.get(setting_key, false))
	var panel := _add_panel(body, Vector2(0, row_y), Vector2(328, 58), Color(0.24, 0.16, 0.09, 0.91), Color(0.72, 0.55, 0.32, 0.54), 8)
	_add_icon(panel, "home_icon_settings", Vector2(8, 12), Vector2(30, 30), "S")
	_add_label(panel, Vector2(46, 8), Vector2(150, 16), str(row.get("title", "")), 12, Color(1.0, 0.92, 0.66))
	_add_label(panel, Vector2(46, 27), Vector2(170, 16), str(row.get("detail", "")), 9, Color(0.80, 0.70, 0.52))
	_add_toggle_button(panel, Vector2(238, 13), Vector2(74, 30), enabled, func(): _toggle_setting(setting_key))


func _render_account_panel() -> void:
	var panel := _add_panel(body, Vector2(0, 226), Vector2(328, 58), Color(0.18, 0.13, 0.08, 0.86), Color(0.62, 0.50, 0.34, 0.48), 8)
	_add_icon(panel, "home_icon_menu", Vector2(8, 12), Vector2(30, 30), "M")
	_add_label(panel, Vector2(46, 8), Vector2(180, 16), "계정", 12, Color(1.0, 0.92, 0.66))
	_add_label(panel, Vector2(46, 27), Vector2(230, 16), "현재는 로컬 하네스 데이터로 실행 중입니다.", 9, Color(0.80, 0.70, 0.52))


func _add_toggle_button(parent: Control, button_position: Vector2, button_size: Vector2, enabled: bool, on_pressed: Callable) -> Button:
	var button := Button.new()
	button.text = "ON" if enabled else "OFF"
	button.position = button_position
	button.size = button_size
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_font_size_override("font_size", 11)
	var normal_fill := Color(0.35, 0.62, 0.28, 0.96) if enabled else Color(0.28, 0.22, 0.16, 0.92)
	var normal_stroke := Color(0.78, 0.94, 0.48, 0.78) if enabled else Color(0.70, 0.58, 0.38, 0.72)
	button.add_theme_stylebox_override("normal", HomeTheme.style(normal_fill, normal_stroke, 8, 1))
	button.add_theme_stylebox_override("hover", HomeTheme.style(Color(0.50, 0.72, 0.30, 0.98) if enabled else Color(0.38, 0.28, 0.18, 0.96), Color(0.92, 0.98, 0.58, 0.90), 8, 1))
	button.pressed.connect(on_pressed)
	parent.add_child(button)
	return button


func _toggle_setting(setting_key: String) -> void:
	sanctuary.toggle_setting(setting_key)
	modal_action_requested.emit("home_state_changed", {})
	sync_state()


func _on_frame_action_requested(action: String) -> void:
	modal_action_requested.emit(action, {})
