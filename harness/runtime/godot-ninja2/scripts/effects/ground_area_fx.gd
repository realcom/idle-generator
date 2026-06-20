extends Node2D

var progress := 0.0:
	set(value):
		progress = value
		queue_redraw()

var _radius := 42.0
var _tint := Color(1.0, 0.7, 0.25, 0.5)
var _accent := Color(1.0, 0.95, 0.7, 0.7)
var _persistent := false


func setup(texture: Texture2D, center: Vector2, radius: float, tint: Color, accent: Color, visual_scale: float = 1.0, profile: Dictionary = {}) -> void:
	position = center
	_radius = max(16.0, radius)
	_tint = tint
	_accent = accent
	var duration: float = max(0.18, float(profile.get("duration", 0.42)))
	_persistent = bool(profile.get("persistent", false))

	if texture != null:
		var sprite := Sprite2D.new()
		sprite.texture = texture
		sprite.centered = true
		sprite.z_index = 22
		sprite.modulate = Color(tint.r, tint.g, tint.b, min(0.78, tint.a))
		var texture_size := texture.get_size()
		var sprite_size := Vector2(_radius * 2.1, _radius * 2.1)
		if texture_size.x > 0.0 and texture_size.y > 0.0:
			sprite.scale = Vector2(sprite_size.x / texture_size.x, sprite_size.y / texture_size.y)
		add_child(sprite)
		var sprite_tween := sprite.create_tween()
		if _persistent:
			sprite_tween.tween_property(sprite, "scale", sprite.scale * 1.08, duration * 0.72)
			sprite_tween.parallel().tween_property(sprite, "modulate:a", min(0.56, sprite.modulate.a), duration * 0.72)
			sprite_tween.tween_property(sprite, "scale", sprite.scale * 1.18, duration * 0.28)
			sprite_tween.parallel().tween_property(sprite, "modulate:a", 0.0, duration * 0.28)
		else:
			sprite_tween.set_parallel(true)
			sprite_tween.tween_property(sprite, "scale", sprite.scale * 1.22, duration)
			sprite_tween.tween_property(sprite, "modulate:a", 0.0, duration)

	var tween := create_tween()
	tween.tween_property(self, "progress", 1.0, duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_callback(queue_free)


func _draw() -> void:
	var visibility: float = clamp((1.0 - progress) * 3.0, 0.0, 1.0) if _persistent else max(0.0, 1.0 - progress)
	var pulse: float = sin(progress * TAU * 3.0) * 0.025 if _persistent else 0.0
	var outer_alpha: float = max(0.0, (0.62 if _persistent else 0.38) * visibility)
	var inner_alpha: float = max(0.0, (0.28 if _persistent else 0.16) * visibility)
	var field_radius := _radius * (0.92 + pulse + progress * 0.04) if _persistent else _radius * (0.6 + pulse + progress * 0.12)
	draw_circle(Vector2.ZERO, field_radius, Color(_tint.r * 0.55, _tint.g * 0.65, _tint.b * 0.68, inner_alpha * 0.68))
	draw_circle(Vector2.ZERO, field_radius * 0.62, Color(_tint.r, _tint.g, _tint.b, inner_alpha))
	if _persistent:
		for index in range(7):
			var angle := progress * TAU * 0.55 + float(index) * TAU / 7.0
			var knot := Vector2(cos(angle), sin(angle)) * _radius * (0.26 + 0.07 * float(index % 3))
			draw_circle(knot, _radius * (0.11 + 0.015 * float(index % 2)), Color(_accent.r, _accent.g, _accent.b, inner_alpha * 0.55))
	draw_arc(Vector2.ZERO, _radius * (0.96 + pulse + progress * 0.04), 0.0, TAU, 72, Color(_accent.r, _accent.g, _accent.b, outer_alpha), max(2.0, 4.0 * visibility))
	draw_arc(Vector2.ZERO, _radius * (0.78 + pulse + progress * 0.04), PI * 0.12, PI * 1.72, 48, Color(1.0, 0.96, 0.7, outer_alpha * 0.72), max(1.5, 2.4 * visibility))
