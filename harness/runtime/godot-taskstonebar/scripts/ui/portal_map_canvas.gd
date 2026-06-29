extends Control

const PARCHMENT := Color("#cdbb86")
const PARCHMENT_LIGHT := Color("#ead9a5")
const PARCHMENT_DARK := Color("#8c7444")
const ROUTE := Color("#5f4728")
const CURRENT_GREEN := Color("#35d466")
const CURRENT_RING := Color("#eaffcf")
const ROUTE_CURVE_SWAYS := [18.0, -14.0, 20.0, -15.0, 14.0, -22.0, 16.0, -18.0, 12.0]

var route_points: Array[Vector2] = [
	Vector2(104.0, 218.0),
	Vector2(208.0, 196.0),
	Vector2(150.0, 166.0),
	Vector2(276.0, 140.0),
	Vector2(214.0, 112.0),
	Vector2(304.0, 88.0),
	Vector2(166.0, 68.0),
	Vector2(266.0, 50.0),
	Vector2(126.0, 42.0),
	Vector2(296.0, 34.0),
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
	var curve := _route_curve_points(route_points.size())
	if curve.size() >= 2:
		draw_polyline(curve, Color("#2f2212", 0.38), 8.0)
		draw_polyline(curve, ROUTE, 4.0)
	for point in route_points:
		draw_circle(point, 17.0, Color("#4a3219"))
		draw_circle(point, 13.0, Color("#b19155"))
		draw_circle(point, 9.0, Color("#5b3b1d"))


func _route_curve_points(point_count: int) -> PackedVector2Array:
	var count := clampi(point_count, 1, route_points.size())
	var output := PackedVector2Array()
	if count == 1:
		output.append(route_points[0])
		return output
	for index in range(count - 1):
		var start := route_points[index]
		var end := route_points[index + 1]
		var direction := end - start
		var normal := Vector2.ZERO
		if direction.length() > 0.001:
			normal = Vector2(-direction.y, direction.x).normalized()
		var sway := float(ROUTE_CURVE_SWAYS[index % ROUTE_CURVE_SWAYS.size()])
		var control := start.lerp(end, 0.5) + normal * sway
		for step in range(7):
			if index > 0 and step == 0:
				continue
			var t := float(step) / 6.0
			output.append(_quadratic_curve_point(start, control, end, t))
	return output


func _quadratic_curve_point(start: Vector2, control: Vector2, end: Vector2, t: float) -> Vector2:
	var a := start.lerp(control, t)
	var b := control.lerp(end, t)
	return a.lerp(b, t)


func _draw_current_marker() -> void:
	if current_index < 0 or current_index >= route_points.size():
		return
	var point := route_points[current_index]
	draw_circle(point, 21.0, Color(0.82, 0.54, 0.14, 0.14))
	draw_arc(point, 21.0, 0.0, TAU, 40, Color(0.82, 0.54, 0.14, 0.48), 2.0)
	draw_arc(point, 15.0, 0.0, TAU, 40, Color(CURRENT_RING.r, CURRENT_RING.g, CURRENT_RING.b, 0.28), 1.5)
