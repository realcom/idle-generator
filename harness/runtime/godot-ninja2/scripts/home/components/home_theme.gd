extends RefCounted


static func style(bg: Color, border: Color, radius := 6, border_width := 1) -> StyleBoxFlat:
	return style_corners(bg, border, radius, radius, radius, radius, border_width)


static func style_corners(
	bg: Color,
	border: Color,
	top_left := 6,
	top_right := 6,
	bottom_right := 6,
	bottom_left := 6,
	border_width := 1
) -> StyleBoxFlat:
	var style_box := StyleBoxFlat.new()
	style_box.bg_color = bg
	style_box.border_color = border
	style_box.border_width_left = border_width
	style_box.border_width_right = border_width
	style_box.border_width_top = border_width
	style_box.border_width_bottom = border_width
	style_box.corner_radius_top_left = top_left
	style_box.corner_radius_top_right = top_right
	style_box.corner_radius_bottom_left = bottom_left
	style_box.corner_radius_bottom_right = bottom_right
	style_box.content_margin_left = 8
	style_box.content_margin_right = 8
	style_box.content_margin_top = 6
	style_box.content_margin_bottom = 6
	return style_box


static func tab_dock_style() -> StyleBoxFlat:
	return style(Color(0.10, 0.065, 0.035, 0.92), Color(0.48, 0.36, 0.18, 0.72), 6, 2)


static func tab_segment_style(active: bool, first: bool, last: bool) -> StyleBoxFlat:
	var radius_left := 5 if first else 0
	var radius_right := 5 if last else 0
	if active:
		return style_corners(
			Color(0.96, 0.62, 0.18, 0.94),
			Color(0.22, 0.13, 0.055, 0.92),
			radius_left,
			radius_right,
			radius_right,
			radius_left,
			1
		)
	var style_box := style_corners(
		Color(0.16, 0.10, 0.055, 0.62),
		Color(0, 0, 0, 0),
		radius_left,
		radius_right,
		radius_right,
		radius_left,
		0
	)
	return style_box


static func tab_style(active: bool) -> StyleBoxFlat:
	if active:
		return style(Color(0.95, 0.62, 0.20, 0.92), Color(0.20, 0.13, 0.06, 0.95), 3, 1)
	return style(Color(0.16, 0.10, 0.06, 0.92), Color(0.35, 0.24, 0.14, 0.85), 3, 1)


static func scaled_texture(source: Texture2D, target_size: Vector2i) -> Texture2D:
	if source == null:
		return null
	var image := source.get_image()
	if image == null:
		return source
	image.resize(target_size.x, target_size.y, Image.INTERPOLATE_LANCZOS)
	return ImageTexture.create_from_image(image)
