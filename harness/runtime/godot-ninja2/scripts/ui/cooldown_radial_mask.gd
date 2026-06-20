extends Control

const FULL_SWEEP := TAU
const START_ANGLE := -PI * 0.5

var cooldown_progress := 1.0:
	set(value):
		cooldown_progress = clampf(value, 0.0, 1.0)
		visible = cooldown_progress < 0.995
		queue_redraw()

var shadow_color := Color(0.02, 0.026, 0.022, 0.68)
var edge_color := Color(0.42, 0.98, 0.86, 0.58)
var rim_color := Color(0.96, 0.78, 0.46, 0.34)
var sector_steps := 56


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	visible = false


func set_cooldown_progress(value: float) -> void:
	cooldown_progress = value


func _draw() -> void:
	if cooldown_progress >= 0.995:
		return
	var radius: float = min(size.x, size.y) * 0.5
	if radius <= 1.0:
		return
	var center := size * 0.5
	var remaining: float = 1.0 - cooldown_progress
	if remaining >= 0.995:
		draw_circle(center, radius, shadow_color)
	else:
		var start_angle: float = START_ANGLE + cooldown_progress * FULL_SWEEP
		var points := _sector_points(center, radius, start_angle, START_ANGLE + FULL_SWEEP)
		draw_colored_polygon(points, shadow_color)
		var boundary := center + Vector2(cos(start_angle), sin(start_angle)) * radius
		draw_line(center, boundary, edge_color, 2.0, true)
	var clear_end: float = START_ANGLE + cooldown_progress * FULL_SWEEP
	draw_arc(center, radius - 2.0, START_ANGLE, clear_end, max(3, int(sector_steps * cooldown_progress)), edge_color, 2.5, true)
	draw_arc(center, radius - 0.5, START_ANGLE, START_ANGLE + FULL_SWEEP, sector_steps, rim_color, 1.5, true)


func _sector_points(center: Vector2, radius: float, start_angle: float, end_angle: float) -> PackedVector2Array:
	var points := PackedVector2Array()
	points.append(center)
	var sweep: float = maxf(0.0, end_angle - start_angle)
	var steps: int = max(2, int(ceil(float(sector_steps) * sweep / FULL_SWEEP)))
	for index in range(steps + 1):
		var ratio: float = float(index) / float(steps)
		var angle: float = lerpf(start_angle, end_angle, ratio)
		points.append(center + Vector2(cos(angle), sin(angle)) * radius)
	return points
