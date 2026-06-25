extends Control

const PARCHMENT := Color("#cdbb86")
const PARCHMENT_LIGHT := Color("#ead9a5")
const PARCHMENT_DARK := Color("#8c7444")
const ROUTE := Color("#5f4728")
const CURRENT_GREEN := Color("#35d466")
const CURRENT_RING := Color("#eaffcf")

var route_points: Array[Vector2] = [
	Vector2(78.0, 218.0),
	Vector2(132.0, 188.0),
	Vector2(194.0, 152.0),
	Vector2(232.0, 112.0),
	Vector2(224.0, 72.0),
	Vector2(292.0, 48.0),
]
var current_index := 2


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_PASS


func set_current_index(value: int) -> void:
	current_index = clampi(value, 0, route_points.size() - 1)
	queue_redraw()


func _draw() -> void:
	var rect := Rect2(Vector2.ZERO, size)
	draw_rect(rect, PARCHMENT)
	draw_rect(Rect2(Vector2(8.0, 8.0), size - Vector2(16.0, 16.0)), PARCHMENT_LIGHT)
	_draw_map_marks(rect)
	_draw_route()
	_draw_current_marker()
	draw_rect(rect, PARCHMENT_DARK, false, 3.0)
	draw_rect(Rect2(Vector2(8.0, 8.0), size - Vector2(16.0, 16.0)), Color("#6e5a34"), false, 2.0)


func _draw_map_marks(rect: Rect2) -> void:
	var marks := [
		Rect2(Vector2(46.0, 86.0), Vector2(34.0, 42.0)),
		Rect2(Vector2(282.0, 120.0), Vector2(28.0, 48.0)),
		Rect2(Vector2(72.0, 206.0), Vector2(58.0, 36.0)),
		Rect2(Vector2(244.0, 210.0), Vector2(44.0, 28.0)),
	]
	for mark in marks:
		draw_rect(mark, Color("#a58b54", 0.26))
		draw_line(mark.position, mark.position + mark.size, Color("#6d5832", 0.32), 2.0)
		draw_line(mark.position + Vector2(mark.size.x, 0.0), mark.position + Vector2(0.0, mark.size.y), Color("#6d5832", 0.22), 1.0)

	for x in [34.0, 330.0]:
		draw_line(Vector2(x, 58.0), Vector2(x, rect.size.y - 44.0), Color("#6d5832", 0.18), 2.0)
	for y in [64.0, 154.0, 222.0]:
		draw_line(Vector2(26.0, y), Vector2(rect.size.x - 24.0, y + 12.0), Color("#6d5832", 0.16), 1.0)


func _draw_route() -> void:
	for i in range(route_points.size() - 1):
		draw_line(route_points[i], route_points[i + 1], Color("#2f2212", 0.38), 8.0)
		draw_line(route_points[i], route_points[i + 1], ROUTE, 4.0)
	for point in route_points:
		draw_circle(point, 17.0, Color("#4a3219"))
		draw_circle(point, 13.0, Color("#b19155"))
		draw_circle(point, 9.0, Color("#5b3b1d"))


func _draw_current_marker() -> void:
	if current_index < 0 or current_index >= route_points.size():
		return
	var point := route_points[current_index]
	draw_circle(point, 26.0, Color(CURRENT_GREEN.r, CURRENT_GREEN.g, CURRENT_GREEN.b, 0.22))
	draw_arc(point, 25.0, 0.0, TAU, 40, CURRENT_GREEN, 5.0)
	draw_arc(point, 18.0, 0.0, TAU, 40, CURRENT_RING, 3.0)
	var flag_base := point + Vector2(14.0, -36.0)
	draw_line(flag_base, flag_base + Vector2(0.0, 46.0), Color("#2e1b16"), 4.0)
	var flag := PackedVector2Array([
		flag_base,
		flag_base + Vector2(28.0, 7.0),
		flag_base + Vector2(4.0, 18.0),
	])
	draw_colored_polygon(flag, Color("#c0392b"))
	draw_polyline(flag, Color("#371311"), 2.0, true)
