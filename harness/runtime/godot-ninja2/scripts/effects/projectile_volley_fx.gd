extends Node2D

const DEFAULT_SIZE := Vector2(64.0, 30.0)


func setup(projectile_texture: Texture2D, source: Vector2, targets: Array, tint: Color, visual_scale: float = 1.0, profile: Dictionary = {}) -> void:
	if projectile_texture == null:
		queue_free()
		return

	var safe_targets: Array = _safe_targets(source, targets)
	var count: int = max(1, int(profile.get("count", safe_targets.size())))
	var mode := str(profile.get("mode", "direct"))
	var duration: float = max(0.08, float(profile.get("duration", 0.18)))
	var stagger: float = max(0.0, float(profile.get("stagger", 0.045)))
	var requested_size = profile.get("size", DEFAULT_SIZE)
	var size: Vector2 = (requested_size if requested_size is Vector2 else DEFAULT_SIZE) * max(0.05, visual_scale)
	var max_delay: float = 0.0

	for index in range(count):
		var target: Vector2 = safe_targets[index % safe_targets.size()]
		var start: Vector2 = _start_position_for(mode, source, target, index, visual_scale)
		var delay: float = float(index) * stagger
		max_delay = max(max_delay, delay)
		_spawn_projectile(projectile_texture, start, target, size, tint, mode, delay, duration, index)

	var cleanup := create_tween()
	cleanup.tween_interval(max_delay + duration + 0.18)
	cleanup.tween_callback(queue_free)


func _safe_targets(source: Vector2, targets: Array) -> Array:
	var result: Array = []
	for target in targets:
		if target is Vector2:
			result.append(target)
	if result.is_empty():
		result.append(source + Vector2(96.0, 0.0))
	return result


func _start_position_for(mode: String, source: Vector2, target: Vector2, index: int, visual_scale: float) -> Vector2:
	match mode:
		"drop":
			var side: float = -1.0 if index % 2 == 0 else 1.0
			return target + Vector2(side * (18.0 + float(index % 3) * 9.0), -126.0 - float(index % 4) * 12.0) * visual_scale
		"orbit":
			var angle: float = float(index) * TAU / 6.0
			return source + Vector2(cos(angle), sin(angle)) * 34.0 * visual_scale
		"lob":
			return source + Vector2(0.0, -18.0 * visual_scale)
		_:
			return source


func _spawn_projectile(texture: Texture2D, start: Vector2, target: Vector2, size: Vector2, tint: Color, mode: String, delay: float, duration: float, index: int) -> void:
	var sprite := Sprite2D.new()
	sprite.texture = texture
	sprite.centered = true
	sprite.position = start
	sprite.z_index = 24
	sprite.modulate = Color(tint.r, tint.g, tint.b, 0.0)
	var texture_size: Vector2 = texture.get_size()
	if texture_size.x > 0.0 and texture_size.y > 0.0:
		sprite.scale = Vector2(size.x / texture_size.x, size.y / texture_size.y)

	var travel: Vector2 = target - start
	if travel.length_squared() <= 0.0001:
		travel = Vector2.RIGHT
	sprite.rotation = travel.angle() + (PI * 0.5 if mode == "drop" else 0.0)
	add_child(sprite)

	var final_scale: Vector2 = sprite.scale * (1.1 if mode == "drop" else 1.0)
	var tween := sprite.create_tween()
	tween.set_parallel(true)
	tween.tween_property(sprite, "modulate:a", tint.a, 0.03).set_delay(delay)
	tween.tween_property(sprite, "position", target, duration).set_delay(delay).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite, "scale", final_scale, duration).set_delay(delay)
	tween.tween_property(sprite, "modulate:a", 0.0, 0.08).set_delay(delay + duration * 0.78)

	var spark := Sprite2D.new()
	spark.texture = texture
	spark.centered = true
	spark.position = target
	spark.z_index = 25
	spark.rotation = sprite.rotation + 0.4
	spark.modulate = Color(1.0, 0.94, 0.58, 0.0)
	if texture_size.x > 0.0 and texture_size.y > 0.0:
		spark.scale = Vector2(size.x / texture_size.x, size.y / texture_size.y) * 0.34
	add_child(spark)

	var spark_tween := spark.create_tween()
	spark_tween.set_parallel(true)
	spark_tween.tween_property(spark, "modulate:a", 0.75, 0.03).set_delay(delay + duration * 0.72)
	spark_tween.tween_property(spark, "scale", spark.scale * 1.9, 0.12).set_delay(delay + duration * 0.72)
	spark_tween.tween_property(spark, "modulate:a", 0.0, 0.12).set_delay(delay + duration * 0.78)
