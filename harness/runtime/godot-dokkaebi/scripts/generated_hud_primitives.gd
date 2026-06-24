extends Control

var hud_state: Dictionary = {}


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func set_hud_state(next_state: Dictionary) -> void:
	hud_state = next_state.duplicate(true)
	visible = bool(hud_state.get("visible", true))
	queue_redraw()


func _draw() -> void:
	if not visible:
		return
	_draw_timer_pips(Vector2(235.0, 87.0), int(hud_state.get("stage_index", 1)))
	_draw_ledger_dots()
	_draw_pause_icon(Rect2(494.0, 8.0, 38.0, 54.0))
	_draw_wave_label(Rect2(12.0, 128.0, 154.0, 18.0))
	_draw_joystick(Vector2(88.0, 824.0))
	_draw_action_buttons()


func _draw_haeil_portrait(center: Vector2) -> void:
	draw_circle(center, 29.0, Color(0.018, 0.052, 0.085, 0.96))
	draw_circle(center + Vector2(0, 7), 20.0, Color(0.89, 0.69, 0.50))
	draw_circle(center + Vector2(-16, -4), 8.0, Color(0.018, 0.026, 0.04))
	draw_circle(center + Vector2(15, -7), 9.0, Color(0.018, 0.026, 0.04))
	draw_arc(center + Vector2(0, -5), 24.0, PI * 1.03, PI * 1.98, 22, Color(0.018, 0.026, 0.04), 8.0)
	draw_line(center + Vector2(-25, -11), center + Vector2(25, -11), Color(0.035, 0.19, 0.39), 6.0)
	draw_line(center + Vector2(10, -29), center + Vector2(26, -41), Color(0.035, 0.19, 0.39), 5.0)
	draw_line(center + Vector2(14, -29), center + Vector2(20, -50), Color(0.035, 0.19, 0.39), 4.0)
	draw_rect(Rect2(center.x - 8, center.y - 27, 16, 10), Color(0.84, 0.62, 0.24))
	draw_rect(Rect2(center.x - 3, center.y - 24, 6, 5), Color(0.95, 0.78, 0.38))
	draw_line(center + Vector2(-8, 3), center + Vector2(-2, 2), Color(0.05, 0.035, 0.025), 2.0)
	draw_line(center + Vector2(6, 2), center + Vector2(12, 3), Color(0.05, 0.035, 0.025), 2.0)
	draw_arc(center + Vector2(3, 8), 8.0, 0.18, 1.45, 8, Color(0.24, 0.08, 0.04), 1.4)


func _draw_timer_pips(origin: Vector2, stage_index: int) -> void:
	for i in range(6):
		var pos := origin + Vector2(float(i) * 12.0, 0.0)
		var filled := i < stage_index * 2
		draw_circle(pos, 4.0, Color(0.22, 0.88, 0.82) if filled else Color(0.18, 0.24, 0.22))


func _draw_ledger_dots() -> void:
	var rows := [
		{"origin": Vector2(356.0, 31.0), "color": Color(1.0, 0.76, 0.28)},
		{"origin": Vector2(356.0, 53.0), "color": Color(0.74, 0.92, 1.0)},
		{"origin": Vector2(356.0, 73.0), "color": Color(0.55, 0.96, 0.88)},
	]
	for row in rows:
		var origin: Vector2 = row.get("origin", Vector2.ZERO)
		draw_circle(origin + Vector2(7, -5), 5.0, row.get("color", Color.WHITE))


func _draw_pause_icon(rect: Rect2) -> void:
	_draw_panel(rect, Color(0.045, 0.038, 0.032, 0.80), Color(0.71, 0.55, 0.29))
	draw_string(ThemeDB.fallback_font, rect.position + Vector2(0, 36), "Ⅱ", HORIZONTAL_ALIGNMENT_CENTER, rect.size.x, 24, Color(0.98, 0.86, 0.58))


func _draw_wave_label(rect: Rect2) -> void:
	_draw_panel(rect, Color(0.05, 0.09, 0.07, 0.76), Color(0.24, 0.46, 0.32))
	draw_string(ThemeDB.fallback_font, rect.position + Vector2(8, 14), "가을 폐촌 마당", HORIZONTAL_ALIGNMENT_LEFT, rect.size.x - 16, 11, Color(0.92, 0.80, 0.38))


func _draw_joystick(center: Vector2) -> void:
	draw_circle(center, 64.0, Color(0.0, 0.0, 0.0, 0.20))
	draw_arc(center, 64.0, 0.0, TAU, 56, Color(0.92, 0.84, 0.62, 0.42), 2.0)
	for marker in [Vector2(0, -42), Vector2(42, 0), Vector2(0, 42), Vector2(-42, 0)]:
		draw_rect(Rect2(center + marker - Vector2(4, 4), Vector2(8, 8)), Color(0.88, 0.84, 0.66, 0.20))
	draw_circle(center, 27.0, Color(0.88, 0.78, 0.58, 0.28))


func _draw_action_buttons() -> void:
	_draw_action_button_overlay(Vector2(485.0, 785.0), 43.0, "wave")
	_draw_action_button_overlay(Vector2(395.0, 859.0), 39.0, "vortex")
	_draw_action_button_overlay(Vector2(477.0, 867.0), 39.0, "spiritfire")


func _draw_action_button_overlay(center: Vector2, radius: float, key: String) -> void:
	var skills: Dictionary = hud_state.get("skills", {})
	var timers: Dictionary = hud_state.get("skill_timers", {})
	var learned: bool = key == "wave" or int(skills.get(key, 0)) > 0
	var cooldown: float = max(0.0, float(timers.get(key, 0.0)))
	var inner_radius: float = radius - 13.0
	if not learned:
		draw_circle(center, inner_radius, Color(0.0, 0.0, 0.0, 0.42))
		draw_line(center + Vector2(-12, 12), center + Vector2(12, -12), Color(0.68, 0.60, 0.44, 0.72), 3.0)
		draw_line(center + Vector2(-8, 16), center + Vector2(16, -8), Color(0.05, 0.04, 0.03, 0.72), 1.5)
		return
	if learned and key != "wave" and cooldown > 0.15:
		draw_circle(center, inner_radius, Color(0.0, 0.0, 0.0, 0.40))
		draw_arc(center, radius - 6.0, -PI * 0.5, -PI * 0.5 + TAU * min(1.0, cooldown / 4.0), 36, Color(0.74, 0.91, 1.0, 0.72), 4.0)
		draw_string(ThemeDB.fallback_font, center + Vector2(-radius, 6), "%.1f" % cooldown, HORIZONTAL_ALIGNMENT_CENTER, radius * 2.0, 15, Color(1.0, 0.92, 0.72))
	elif key == "wave":
		draw_string(ThemeDB.fallback_font, center + Vector2(-radius, -18), "AUTO", HORIZONTAL_ALIGNMENT_CENTER, radius * 2.0, 10, Color(0.80, 0.94, 1.0, 0.82))
	draw_string(ThemeDB.fallback_font, center + Vector2(-radius, radius - 5.0), "Lv.%d" % max(1, int(skills.get(key, 0))), HORIZONTAL_ALIGNMENT_CENTER, radius * 2.0, 10, Color(0.72, 0.92, 1.0))


func _skill_color(key: String) -> Color:
	match key:
		"vortex":
			return Color(0.16, 0.58, 0.96)
		"wave":
			return Color(0.12, 0.68, 0.94)
		"spiritfire":
			return Color(0.22, 0.90, 0.78)
		_:
			return Color(0.32, 0.48, 0.55)


func _draw_panel(rect: Rect2, fill: Color, stroke: Color) -> void:
	draw_rect(rect, fill)
	draw_rect(rect, stroke, false, 2.0)
