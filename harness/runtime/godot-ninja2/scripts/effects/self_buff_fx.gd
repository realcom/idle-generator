extends Node2D

var progress := 0.0:
	set(value):
		progress = value
		queue_redraw()

var _radius := 46.0
var _tint := Color(0.4, 1.0, 0.85, 0.5)
var _accent := Color(1.0, 0.95, 0.7, 0.7)
var _style := "default"


func setup(texture: Texture2D, center: Vector2, tint: Color, accent: Color, visual_scale: float = 1.0, profile: Dictionary = {}) -> void:
	position = center + Vector2(0.0, -18.0 * visual_scale)
	_tint = tint
	_accent = accent
	_style = str(profile.get("style", "default"))
	_radius = max(28.0, float(profile.get("radius", 54.0)) * visual_scale)
	var duration: float = max(0.22, float(profile.get("duration", 0.5)))

	if texture != null:
		var sprite := Sprite2D.new()
		sprite.texture = texture
		sprite.centered = true
		sprite.z_index = 26
		sprite.modulate = _sprite_color_for_style(tint)
		var texture_size := texture.get_size()
		var sprite_size := _sprite_size_for_style() * visual_scale
		if texture_size.x > 0.0 and texture_size.y > 0.0:
			sprite.scale = Vector2(sprite_size.x / texture_size.x, sprite_size.y / texture_size.y)
		sprite.rotation = PI * 0.5 if _style == "time" else 0.0
		add_child(sprite)
		var sprite_tween := sprite.create_tween()
		sprite_tween.set_parallel(true)
		sprite_tween.tween_property(sprite, "position:y", (-8.0 if _style == "focus" else -12.0) * visual_scale, duration)
		sprite_tween.tween_property(sprite, "rotation", sprite.rotation + (PI * 1.5 if _style == "time" else 0.18), duration)
		sprite_tween.tween_property(sprite, "scale", sprite.scale * (1.12 if _style == "focus" else 1.3), duration)
		sprite_tween.tween_property(sprite, "modulate:a", 0.0, duration)

	var tween := create_tween()
	tween.tween_property(self, "progress", 1.0, duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_callback(queue_free)


func _sprite_color_for_style(tint: Color) -> Color:
	match _style:
		"focus":
			return Color(1.0, 1.0, 1.0, 0.82)
		"time":
			return Color(1.0, 1.0, 1.0, 0.82)
		"gale":
			return Color(0.58, 1.0, 0.32, 0.58)
		_:
			return Color(tint.r, tint.g, tint.b, min(0.72, tint.a))


func _sprite_size_for_style() -> Vector2:
	match _style:
		"focus":
			return Vector2(92.0, 92.0)
		"time":
			return Vector2(104.0, 104.0)
		"gale":
			return Vector2(82.0, 46.0)
		_:
			return Vector2(72.0, 46.0)


func _draw() -> void:
	var alpha: float = max(0.0, 0.48 * (1.0 - progress))
	match _style:
		"focus":
			_draw_focus(alpha)
		"time":
			_draw_time(alpha)
		"gale":
			_draw_gale(alpha)
		_:
			draw_arc(Vector2.ZERO, _radius * (0.6 + progress * 0.26), -PI * 0.15, PI * 1.8, 48, Color(_accent.r, _accent.g, _accent.b, alpha), 2.0)
			draw_arc(Vector2.ZERO, _radius * (0.34 + progress * 0.14), PI * 0.35, PI * 2.1, 36, Color(_tint.r, _tint.g, _tint.b, alpha * 0.8), 2.0)
			draw_circle(Vector2.ZERO, _radius * (0.14 + progress * 0.08), Color(_tint.r, _tint.g, _tint.b, alpha * 0.26))


func _draw_focus(alpha: float) -> void:
	var red := Color(1.0, 0.16, 0.1, alpha)
	var gold := Color(1.0, 0.72, 0.24, alpha * 0.68)
	draw_circle(Vector2.ZERO, _radius * (0.1 + progress * 0.08), Color(1.0, 0.08, 0.04, alpha * 0.3))
	for index in range(8):
		var angle := float(index) * TAU / 8.0 + progress * 0.35
		var inner := Vector2(cos(angle), sin(angle)) * _radius * 0.28
		var outer := Vector2(cos(angle), sin(angle)) * _radius * (0.68 + progress * 0.18)
		draw_line(inner, outer, red if index % 2 == 0 else gold, 2.0)
	draw_arc(Vector2.ZERO, _radius * (0.42 + progress * 0.22), -PI * 0.85, PI * 0.18, 24, red, 2.5)


func _draw_time(alpha: float) -> void:
	var cyan := Color(0.1, 1.0, 0.92, alpha)
	var blue := Color(0.22, 0.55, 1.0, alpha * 0.72)
	draw_arc(Vector2.ZERO, _radius * (0.38 + progress * 0.16), 0.0, TAU, 64, cyan, 1.8)
	draw_arc(Vector2.ZERO, _radius * (0.64 + progress * 0.18), PI * 0.18, PI * 1.7, 64, blue, 2.0)
	for index in range(12):
		var angle := float(index) * TAU / 12.0
		var inner := Vector2(cos(angle), sin(angle)) * _radius * 0.48
		var outer := Vector2(cos(angle), sin(angle)) * _radius * 0.58
		draw_line(inner, outer, cyan, 1.2)


func _draw_gale(alpha: float) -> void:
	var green := Color(0.58, 1.0, 0.32, alpha)
	draw_arc(Vector2.ZERO, _radius * (0.42 + progress * 0.24), -PI * 0.2, PI * 1.25, 48, green, 2.2)
	draw_arc(Vector2.ZERO + Vector2(10.0, 0.0), _radius * (0.26 + progress * 0.14), PI * 0.8, PI * 2.1, 32, Color(0.9, 1.0, 0.6, alpha * 0.7), 1.6)
