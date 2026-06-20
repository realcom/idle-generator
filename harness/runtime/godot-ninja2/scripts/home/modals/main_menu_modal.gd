extends "res://scripts/home/modals/tab_modal_base.gd"

const MENU_ROWS := [
	{"title": "성소", "detail": "건물 강화와 생산 상태", "icon": "home_tab_sanctuary", "action": "open_tab", "payload": {"tab_key": "sanctuary"}},
	{"title": "장비", "detail": "슬롯 장착과 보유 장비", "icon": "home_tab_equipment", "action": "open_tab", "payload": {"tab_key": "equipment"}},
	{"title": "탐험", "detail": "메인/특수 던전 선택", "icon": "home_tab_exploration", "action": "open_tab", "payload": {"tab_key": "exploration"}},
	{"title": "임무", "detail": "진행도와 보상 수령", "icon": "home_tab_mission", "action": "open_tab", "payload": {"tab_key": "missions"}},
	{"title": "상점", "detail": "패키지와 보급 상품", "icon": "home_tab_shop", "action": "open_tab", "payload": {"tab_key": "shop"}},
	{"title": "우편", "detail": "성소 알림과 보상", "icon": "home_icon_mail", "action": "open_quick", "payload": {"view_key": "mail"}},
	{"title": "가방", "detail": "자원과 아이템 목록", "icon": "home_icon_bag", "action": "open_quick", "payload": {"view_key": "bag"}},
	{"title": "패스", "detail": "성장 단계 보상", "icon": "home_icon_pass", "action": "open_quick", "payload": {"view_key": "pass"}},
]


func setup(content_store, housing_store, sanctuary_state, texture_table: Dictionary) -> void:
	setup_context(content_store, housing_store, sanctuary_state, texture_table, "메뉴", "성소 이동 · 시스템", Vector2(390, 520))
	sync_state()


func sync_state() -> void:
	clear_body()
	var left_x := 0.0
	var right_x := 184.0
	for index in range(MENU_ROWS.size()):
		var row: Dictionary = MENU_ROWS[index]
		var x := left_x if index % 2 == 0 else right_x
		var y := float(int(index / 2)) * 70.0
		_render_menu_cell(row, Vector2(x, y))
	_render_system_row()
	set_primary_action("설정", "open_settings")
	set_secondary_action("타이틀", "return_title")


func _render_menu_cell(row: Dictionary, cell_position: Vector2) -> void:
	var cell := _add_panel(body, cell_position, Vector2(174, 62), Color(0.24, 0.16, 0.09, 0.91), Color(0.72, 0.55, 0.32, 0.54), 8)
	_add_icon(cell, str(row.get("icon", "home_icon_menu")), Vector2(8, 12), Vector2(30, 30), "?")
	_add_label(cell, Vector2(46, 9), Vector2(84, 16), str(row.get("title", "")), 12, Color(1.0, 0.92, 0.66))
	_add_label(cell, Vector2(46, 27), Vector2(112, 24), str(row.get("detail", "")), 9, Color(0.80, 0.70, 0.52))
	var action := str(row.get("action", ""))
	var payload: Dictionary = row.get("payload", {})
	var button := Button.new()
	button.position = Vector2.ZERO
	button.size = Vector2(174, 62)
	button.flat = true
	button.focus_mode = Control.FOCUS_NONE
	button.tooltip_text = str(row.get("title", ""))
	button.pressed.connect(func(): modal_action_requested.emit(action, payload))
	cell.add_child(button)


func _render_system_row() -> void:
	var panel := _add_panel(body, Vector2(0, 288), Vector2(358, 54), Color(0.18, 0.13, 0.08, 0.86), Color(0.62, 0.50, 0.34, 0.48), 8)
	_add_icon(panel, "home_icon_settings", Vector2(10, 11), Vector2(30, 30), "S")
	_add_label(panel, Vector2(50, 8), Vector2(210, 16), "시스템", 12, Color(1.0, 0.91, 0.66))
	_add_label(panel, Vector2(50, 26), Vector2(230, 16), "설정은 우측 버튼, 타이틀 복귀는 좌측 버튼으로 처리합니다.", 9, Color(0.78, 0.68, 0.50))


func _on_frame_action_requested(action: String) -> void:
	modal_action_requested.emit(action, {})
