extends Node2D

const DEFAULT_DURATION := 0.3
const TEXTURE_FORWARD_OFFSET := PI

@onready var slash: Sprite2D = $Slash
@onready var glint: Sprite2D = $Glint
@onready var ember_a: Sprite2D = $EmberA
@onready var ember_b: Sprite2D = $EmberB

var progress := 0.0:
	set(value):
		progress = value
		queue_redraw()

var _direction := Vector2.RIGHT
var _base_scale := 1.0
var _start_position := Vector2.ZERO
var _end_position := Vector2.ZERO
var _style := "basic"
var _duration := DEFAULT_DURATION


func setup(slash_texture: Texture2D, source: Vector2, target: Vector2, tint: Color, visual_scale: float = 1.0, profile: Dictionary = {}) -> void:
	if slash_texture != null:
		slash.texture = slash_texture
		glint.texture = slash_texture
		ember_a.texture = slash_texture
		ember_b.texture = slash_texture

	_style = str(profile.get("style", "basic"))
	_duration = max(0.18, float(profile.get("duration", DEFAULT_DURATION)))
	var delta := target - source
	if delta.length_squared() <= 0.0001:
		delta = Vector2.RIGHT
	_direction = delta.normalized()
	_base_scale = max(0.05, visual_scale)
	var screen_lift := Vector2(0.0, -7.0 * _base_scale)
	_start_position = source + _direction * clamp(delta.length() * 0.18, 18.0, 34.0) + screen_lift
	_end_position = target - _direction * clamp(delta.length() * 0.1, 8.0, 18.0) + screen_lift
	position = _start_position
	rotation = _direction.angle() + TEXTURE_FORWARD_OFFSET

	_apply_style_colors(tint)

	_reset_nodes()
	if _style == "clone":
		_spawn_clone_afterimages(slash_texture)
	_play()


func _apply_style_colors(tint: Color) -> void:
	if _style == "moon":
		slash.modulate = Color(1.0, 1.0, 1.0, 0.86)
		glint.modulate = Color(1.0, 1.0, 0.86, 0.85)
		ember_a.modulate = Color(0.44, 0.82, 1.0, 0.22)
		ember_b.modulate = Color(1.0, 1.0, 1.0, 0.2)
		return
	if _style == "clone":
		slash.modulate = Color(1.0, 1.0, 1.0, 0.82)
		glint.modulate = Color(0.1, 0.26, 0.35, 0.52)
		ember_a.modulate = Color(0.02, 0.08, 0.1, 0.5)
		ember_b.modulate = Color(0.22, 1.0, 0.86, 0.4)
		return
	slash.modulate = tint
	glint.modulate = Color(1.0, 0.94, 0.58, 0.72)
	ember_a.modulate = Color(1.0, 0.42, 0.16, 0.62)
	ember_b.modulate = Color(0.55, 1.0, 0.82, 0.48)


func _reset_nodes() -> void:
	var slash_scale := Vector2(0.16, 0.105)
	if _style == "moon":
		slash_scale = Vector2(0.18, 0.18)
	elif _style == "clone":
		slash_scale = Vector2(0.19, 0.19)
	slash.position = Vector2(-9.0, 0.0) * _base_scale
	slash.scale = slash_scale * _base_scale
	slash.modulate.a = min(slash.modulate.a, 0.95)

	glint.position = Vector2(-3.0, -3.0) * _base_scale
	glint.rotation = 0.08
	glint.scale = Vector2(0.07, 0.025) * _base_scale
	glint.modulate.a = min(glint.modulate.a, 0.65)

	ember_a.position = Vector2(-4.0, -6.0) * _base_scale
	ember_a.rotation = -0.4
	ember_a.scale = Vector2(0.018, 0.018) * _base_scale
	ember_a.modulate.a = min(ember_a.modulate.a, 0.62)

	ember_b.position = Vector2(1.0, 5.0) * _base_scale
	ember_b.rotation = 0.32
	ember_b.scale = Vector2(0.014, 0.014) * _base_scale
	ember_b.modulate.a = min(ember_b.modulate.a, 0.48)


func _spawn_clone_afterimages(texture: Texture2D) -> void:
	if texture == null:
		return
	var offsets := [Vector2(-7.0, -16.0), Vector2(-15.0, 0.0), Vector2(-10.0, 14.0)]
	for index in range(offsets.size()):
		var ghost := Sprite2D.new()
		ghost.texture = texture
		ghost.centered = true
		ghost.z_index = 2
		ghost.position = offsets[index] * _base_scale
		ghost.scale = Vector2(0.13, 0.07) * _base_scale
		ghost.rotation = -0.24 + float(index) * 0.22
		ghost.modulate = Color(0.02, 0.08, 0.1, 0.62)
		add_child(ghost)
		var ghost_tween := ghost.create_tween()
		ghost_tween.set_parallel(true)
		ghost_tween.tween_property(ghost, "position", (offsets[index] + Vector2(-24.0, 0.0)) * _base_scale, _duration * 0.9)
		ghost_tween.tween_property(ghost, "modulate:a", 0.0, _duration * 0.86)


func _play() -> void:
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "progress", 1.0, _duration)
	tween.tween_property(self, "position", _end_position, _duration * 0.72).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	var end_scale := Vector2(0.32, 0.2)
	if _style == "moon":
		end_scale = Vector2(0.26, 0.26)
	elif _style == "clone":
		end_scale = Vector2(0.28, 0.28)
	tween.tween_property(slash, "scale", end_scale * _base_scale, _duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(slash, "position", Vector2(-22.0, 0.0) * _base_scale, _duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(slash, "modulate:a", 0.0, _duration)

	tween.tween_property(glint, "position", Vector2(-30.0 if _style == "moon" else -24.0, -4.0) * _base_scale, _duration * 0.75)
	tween.tween_property(glint, "modulate:a", 0.0, _duration * 0.72)

	tween.tween_property(ember_a, "position", Vector2(-15.0, -12.0) * _base_scale, _duration * 0.9)
	tween.tween_property(ember_a, "modulate:a", 0.0, _duration * 0.85)
	tween.tween_property(ember_b, "position", Vector2(14.0, 9.0) * _base_scale, _duration * 0.82)
	tween.tween_property(ember_b, "modulate:a", 0.0, _duration * 0.78)

	tween.set_parallel(false)
	tween.tween_callback(queue_free)


func _draw() -> void:
	if _style == "moon":
		_draw_moon_flash()
	elif _style == "clone":
		_draw_clone_slashes()


func _draw_moon_flash() -> void:
	var alpha: float = max(0.0, 1.0 - progress)
	var center := Vector2(-10.0, -1.0) * _base_scale
	var outer_radius: float = 38.0 * _base_scale * (1.0 + progress * 0.08)
	var inner_radius: float = 28.0 * _base_scale * (1.0 + progress * 0.06)
	draw_arc(center, outer_radius, PI * 0.06, PI * 0.86, 36, Color(0.78, 0.98, 1.0, alpha * 0.86), max(1.5, 3.0 * _base_scale))
	draw_arc(center + Vector2(2.0, -2.0) * _base_scale, inner_radius, PI * 0.1, PI * 0.76, 28, Color(1.0, 1.0, 0.86, alpha * 0.58), max(1.0, 1.5 * _base_scale))
	draw_line(Vector2(-42.0, 4.0) * _base_scale, Vector2(30.0, -5.0) * _base_scale, Color(0.58, 0.94, 1.0, alpha * 0.36), max(1.0, 1.2 * _base_scale))


func _draw_clone_slashes() -> void:
	var alpha: float = max(0.0, 1.0 - progress)
	var offsets := [Vector2(-7.0, -16.0), Vector2(-16.0, 0.0), Vector2(-9.0, 14.0)]
	for index in range(offsets.size()):
		var offset: Vector2 = offsets[index] * _base_scale
		var tint := Color(0.05, 0.12, 0.13, alpha * 0.7) if index == 1 else Color(0.18, 1.0, 0.86, alpha * 0.48)
		draw_line(offset + Vector2(-34.0, 2.0) * _base_scale, offset + Vector2(20.0, -5.0) * _base_scale, tint, max(1.2, 2.2 * _base_scale))
		draw_arc(offset + Vector2(-2.0, 0.0) * _base_scale, 24.0 * _base_scale, PI * 0.08, PI * 0.78, 24, tint, max(1.0, 1.6 * _base_scale))
