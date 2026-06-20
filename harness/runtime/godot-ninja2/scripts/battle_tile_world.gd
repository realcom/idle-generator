extends Node2D

const TILE_SIZE := 48
const ATLAS_COLUMNS := 8
const ATLAS_ROWS := 4
const VISIBLE_MARGIN_TILES := 4
const SOURCE_SALT := 9176
const EMPTY_ATLAS := Vector2i(-1, -1)

var ground_layer: TileMapLayer
var detail_layer: TileMapLayer
var mist_layer: TileMapLayer
var tile_set: TileSet
var source_id := -1
var map_seed := 500101
var rendered_ground := {}
var rendered_detail := {}
var rendered_mist := {}


func _ready() -> void:
	tile_set = _build_tile_set()
	ground_layer = _make_layer("GroundTiles", 0)
	detail_layer = _make_layer("DetailTiles", 1)
	mist_layer = _make_layer("MistTiles", 2)


func reset_for_map(map_id: int) -> void:
	map_seed = maxi(1, map_id)
	for layer in [ground_layer, detail_layer, mist_layer]:
		if layer != null:
			layer.clear()
	rendered_ground.clear()
	rendered_detail.clear()
	rendered_mist.clear()


func sync(camera_world_position: Vector2, viewport_size: Vector2, world_to_screen_scale: float) -> void:
	if ground_layer == null or detail_layer == null or mist_layer == null or source_id < 0:
		return
	if viewport_size.x <= 0.0 or viewport_size.y <= 0.0:
		return

	var scale_value: float = maxf(0.001, world_to_screen_scale)
	scale = Vector2(scale_value, scale_value)
	position = viewport_size * 0.5 - camera_world_position * scale_value
	_update_visible_cells(camera_world_position, viewport_size, scale_value)


func _make_layer(layer_name: String, order: int) -> TileMapLayer:
	var layer := TileMapLayer.new()
	layer.name = layer_name
	layer.tile_set = tile_set
	layer.z_index = order
	add_child(layer)
	return layer


func _update_visible_cells(camera_world_position: Vector2, viewport_size: Vector2, world_to_screen_scale: float) -> void:
	var half_world: Vector2 = viewport_size / maxf(0.001, world_to_screen_scale) * 0.5
	var min_cell: Vector2i = _world_to_cell(camera_world_position - half_world) - Vector2i(VISIBLE_MARGIN_TILES, VISIBLE_MARGIN_TILES)
	var max_cell: Vector2i = _world_to_cell(camera_world_position + half_world) + Vector2i(VISIBLE_MARGIN_TILES, VISIBLE_MARGIN_TILES)
	var keep: Dictionary = {}

	for cell_y in range(min_cell.y, max_cell.y + 1):
		for cell_x in range(min_cell.x, max_cell.x + 1):
			var cell := Vector2i(cell_x, cell_y)
			keep[cell] = true
			_sync_cell(ground_layer, rendered_ground, cell, _ground_atlas_for_cell(cell))
			_sync_cell(detail_layer, rendered_detail, cell, _detail_atlas_for_cell(cell))
			_sync_cell(mist_layer, rendered_mist, cell, _mist_atlas_for_cell(cell))

	_trim_cells(ground_layer, rendered_ground, keep)
	_trim_cells(detail_layer, rendered_detail, keep)
	_trim_cells(mist_layer, rendered_mist, keep)


func _sync_cell(layer: TileMapLayer, rendered: Dictionary, cell: Vector2i, atlas: Vector2i) -> void:
	if atlas == EMPTY_ATLAS:
		if rendered.has(cell):
			layer.erase_cell(cell)
			rendered.erase(cell)
		return
	if not rendered.has(cell) or rendered[cell] != atlas:
		layer.set_cell(cell, source_id, atlas)
		rendered[cell] = atlas


func _trim_cells(layer: TileMapLayer, rendered: Dictionary, keep: Dictionary) -> void:
	for cell in rendered.keys():
		if keep.has(cell):
			continue
		layer.erase_cell(cell)
		rendered.erase(cell)


func _world_to_cell(world_position: Vector2) -> Vector2i:
	return Vector2i(floori(world_position.x / float(TILE_SIZE)), floori(world_position.y / float(TILE_SIZE)))


func _ground_atlas_for_cell(cell: Vector2i) -> Vector2i:
	var canopy: float = _smooth_cell_noise(cell, 0.105, 19)
	var path: float = _smooth_cell_noise(cell + Vector2i(23, -41), 0.072, 37)
	var moss: float = _smooth_cell_noise(cell - Vector2i(31, 17), 0.16, 53)
	var fine := _hash_cell(cell, 71)
	if path > 0.84 and moss < 0.68:
		return Vector2i(4 + fine % 2, 0)
	if moss > 0.74:
		return Vector2i(6 + fine % 2, 0)
	if canopy < 0.28:
		return Vector2i(fine % 4, 1)
	if canopy > 0.76:
		return Vector2i(4 + fine % 4, 1)
	return Vector2i(fine % 4, 0)


func _detail_atlas_for_cell(cell: Vector2i) -> Vector2i:
	var density: float = _smooth_cell_noise(cell, 0.24, 89)
	var value := _hash_cell(cell, 97) % 100
	if density > 0.78 and value < 42:
		return Vector2i(value % 4, 2)
	if density < 0.24 and value < 24:
		return Vector2i(4 + value % 4, 2)
	if value < 9:
		return Vector2i((value / 3) % 4, 2)
	return EMPTY_ATLAS


func _mist_atlas_for_cell(cell: Vector2i) -> Vector2i:
	var mist: float = _smooth_cell_noise(cell + Vector2i(11, 29), 0.13, 131)
	var value := _hash_cell(cell, 149) % 100
	if mist > 0.62 and value < 86:
		return Vector2i(value % 4, 3)
	if mist < 0.34 and value < 38:
		return Vector2i(4 + value % 4, 3)
	if value < 10:
		return Vector2i(value % 4, 3)
	return EMPTY_ATLAS


func _build_tile_set() -> TileSet:
	var image := Image.create(TILE_SIZE * ATLAS_COLUMNS, TILE_SIZE * ATLAS_ROWS, false, Image.FORMAT_RGBA8)
	image.fill(Color(0, 0, 0, 0))

	_paint_ground_tile(image, Vector2i(0, 0), Color(0.135, 0.245, 0.135), Color(0.205, 0.335, 0.175), 0.13)
	_paint_ground_tile(image, Vector2i(1, 0), Color(0.125, 0.228, 0.13), Color(0.19, 0.305, 0.16), 0.13)
	_paint_ground_tile(image, Vector2i(2, 0), Color(0.15, 0.265, 0.135), Color(0.22, 0.35, 0.17), 0.12)
	_paint_ground_tile(image, Vector2i(3, 0), Color(0.118, 0.215, 0.132), Color(0.18, 0.29, 0.17), 0.12)
	_paint_ground_tile(image, Vector2i(4, 0), Color(0.165, 0.205, 0.115), Color(0.235, 0.27, 0.14), 0.10)
	_paint_ground_tile(image, Vector2i(5, 0), Color(0.145, 0.185, 0.108), Color(0.215, 0.245, 0.13), 0.11)
	_paint_ground_tile(image, Vector2i(6, 0), Color(0.112, 0.235, 0.165), Color(0.18, 0.325, 0.215), 0.16)
	_paint_ground_tile(image, Vector2i(7, 0), Color(0.105, 0.215, 0.155), Color(0.165, 0.295, 0.205), 0.15)

	_paint_ground_tile(image, Vector2i(0, 1), Color(0.105, 0.195, 0.125), Color(0.16, 0.255, 0.15), 0.13)
	_paint_ground_tile(image, Vector2i(1, 1), Color(0.112, 0.205, 0.122), Color(0.17, 0.265, 0.145), 0.12)
	_paint_ground_tile(image, Vector2i(2, 1), Color(0.12, 0.21, 0.115), Color(0.18, 0.275, 0.14), 0.11)
	_paint_ground_tile(image, Vector2i(3, 1), Color(0.102, 0.187, 0.122), Color(0.155, 0.24, 0.145), 0.13)
	_paint_ground_tile(image, Vector2i(4, 1), Color(0.16, 0.27, 0.14), Color(0.235, 0.36, 0.18), 0.10)
	_paint_ground_tile(image, Vector2i(5, 1), Color(0.142, 0.25, 0.132), Color(0.215, 0.335, 0.17), 0.11)
	_paint_ground_tile(image, Vector2i(6, 1), Color(0.125, 0.232, 0.143), Color(0.195, 0.315, 0.175), 0.12)
	_paint_ground_tile(image, Vector2i(7, 1), Color(0.148, 0.235, 0.13), Color(0.215, 0.315, 0.155), 0.10)

	_paint_detail_tile(image, Vector2i(0, 2), Color(0.58, 0.70, 0.28, 0.26), 18, 3)
	_paint_detail_tile(image, Vector2i(1, 2), Color(0.45, 0.62, 0.24, 0.24), 22, 2)
	_paint_detail_tile(image, Vector2i(2, 2), Color(0.83, 0.62, 0.32, 0.24), 9, 5)
	_paint_detail_tile(image, Vector2i(3, 2), Color(0.70, 0.82, 0.48, 0.20), 14, 4)
	_paint_detail_tile(image, Vector2i(4, 2), Color(0.35, 0.62, 0.64, 0.22), 9, 6)
	_paint_detail_tile(image, Vector2i(5, 2), Color(0.88, 0.70, 0.34, 0.18), 10, 4)
	_paint_detail_tile(image, Vector2i(6, 2), Color(0.50, 0.76, 0.55, 0.18), 16, 3)
	_paint_detail_tile(image, Vector2i(7, 2), Color(0.80, 0.87, 0.58, 0.16), 12, 5)

	_paint_mist_tile(image, Vector2i(0, 3), Color(0.45, 0.80, 0.72, 0.17), 4)
	_paint_mist_tile(image, Vector2i(1, 3), Color(0.78, 0.61, 0.28, 0.15), 5)
	_paint_mist_tile(image, Vector2i(2, 3), Color(0.36, 0.58, 0.44, 0.16), 5)
	_paint_mist_tile(image, Vector2i(3, 3), Color(0.68, 0.84, 0.76, 0.14), 5)
	_paint_detail_tile(image, Vector2i(4, 3), Color(0.96, 0.73, 0.34, 0.21), 7, 7)
	_paint_detail_tile(image, Vector2i(5, 3), Color(0.42, 0.78, 0.74, 0.20), 6, 8)
	_paint_detail_tile(image, Vector2i(6, 3), Color(0.56, 0.70, 0.28, 0.20), 14, 3)
	_paint_detail_tile(image, Vector2i(7, 3), Color(0.20, 0.31, 0.22, 0.18), 8, 10)

	var texture := ImageTexture.create_from_image(image)
	var atlas := TileSetAtlasSource.new()
	atlas.texture = texture
	atlas.texture_region_size = Vector2i(TILE_SIZE, TILE_SIZE)
	for y in range(ATLAS_ROWS):
		for x in range(ATLAS_COLUMNS):
			atlas.create_tile(Vector2i(x, y))

	var result := TileSet.new()
	result.tile_size = Vector2i(TILE_SIZE, TILE_SIZE)
	source_id = result.add_source(atlas)
	return result


func _paint_ground_tile(image: Image, atlas_cell: Vector2i, base: Color, accent: Color, accent_weight: float) -> void:
	var origin := atlas_cell * TILE_SIZE
	for y in range(TILE_SIZE):
		for x in range(TILE_SIZE):
			var pixel := origin + Vector2i(x, y)
			var shade := float(_hash_pixels(pixel.x, pixel.y, SOURCE_SALT) % 100) / 100.0
			var grain := float(_hash_pixels(pixel.x / 3, pixel.y / 3, SOURCE_SALT + 41) % 100) / 100.0
			var blade := 0.5 + 0.5 * sin(float(x) * 0.42 + float(y) * 0.16 + float(atlas_cell.x * 17 + atlas_cell.y * 31))
			var color := base.lerp(accent, accent_weight * (0.52 * shade + 0.38 * grain + 0.10 * blade))
			color = color.lightened(0.006 * blade).darkened(0.007 * (1.0 - grain))
			image.set_pixel(pixel.x, pixel.y, color)

	for stroke in range(7):
		var cx := int(_hash_pixels(origin.x + stroke * 19, origin.y, 205) % TILE_SIZE)
		var cy := int(_hash_pixels(origin.x, origin.y + stroke * 29, 307) % TILE_SIZE)
		var rx := 12 + int(_hash_pixels(cx, cy, stroke) % 22)
		var ry := 5 + int(_hash_pixels(cy, cx, stroke + 3) % 14)
		var stroke_color := accent if stroke % 2 == 0 else base.lightened(0.06)
		_paint_soft_ellipse(image, origin, Vector2i(cx, cy), Vector2(rx, ry), stroke_color, 0.026)


func _paint_detail_tile(image: Image, atlas_cell: Vector2i, color: Color, count: int, radius: int) -> void:
	var origin := atlas_cell * TILE_SIZE
	for index in range(count):
		var cx := int(_hash_pixels(origin.x + index * 17, origin.y + 11, 24) % TILE_SIZE)
		var cy := int(_hash_pixels(origin.x + 5, origin.y + index * 23, 48) % TILE_SIZE)
		var dot_radius: int = maxi(1, radius + int(_hash_pixels(cx, cy, index) % 5) - 2)
		_paint_soft_ellipse(image, origin, Vector2i(cx, cy), Vector2(dot_radius * 1.6, dot_radius), color, color.a)


func _paint_mist_tile(image: Image, atlas_cell: Vector2i, color: Color, count: int) -> void:
	var origin := atlas_cell * TILE_SIZE
	for index in range(count):
		var cx := int(_hash_pixels(origin.x + index * 31, origin.y + 7, 144) % TILE_SIZE)
		var cy := int(_hash_pixels(origin.x + 13, origin.y + index * 37, 211) % TILE_SIZE)
		var rx := 14 + int(_hash_pixels(cx, cy, index + 19) % 22)
		var ry := 8 + int(_hash_pixels(cy, cx, index + 23) % 14)
		_paint_soft_ellipse(image, origin, Vector2i(cx, cy), Vector2(rx, ry), color, color.a)


func _paint_soft_ellipse(image: Image, origin: Vector2i, center: Vector2i, radius: Vector2, color: Color, alpha_scale: float) -> void:
	var min_x := maxi(0, int(center.x - radius.x))
	var max_x := mini(TILE_SIZE - 1, int(center.x + radius.x))
	var min_y := maxi(0, int(center.y - radius.y))
	var max_y := mini(TILE_SIZE - 1, int(center.y + radius.y))
	for y in range(min_y, max_y + 1):
		for x in range(min_x, max_x + 1):
			var normalized := Vector2(float(x - center.x) / maxf(1.0, radius.x), float(y - center.y) / maxf(1.0, radius.y))
			var distance := normalized.length()
			if distance > 1.0:
				continue
			var alpha := alpha_scale * (1.0 - distance) * (1.0 - distance)
			var px := origin.x + x
			var py := origin.y + y
			image.set_pixel(px, py, image.get_pixel(px, py).lerp(Color(color.r, color.g, color.b, 1.0), alpha))


func _smooth_cell_noise(cell: Vector2i, frequency: float, salt: int) -> float:
	var sample := Vector2(float(cell.x), float(cell.y)) * frequency
	var base := Vector2i(floori(sample.x), floori(sample.y))
	var frac := Vector2(sample.x - float(base.x), sample.y - float(base.y))
	var sx := frac.x * frac.x * (3.0 - 2.0 * frac.x)
	var sy := frac.y * frac.y * (3.0 - 2.0 * frac.y)
	var a := _hash_unit(base, salt)
	var b := _hash_unit(base + Vector2i(1, 0), salt)
	var c := _hash_unit(base + Vector2i(0, 1), salt)
	var d := _hash_unit(base + Vector2i(1, 1), salt)
	return lerpf(lerpf(a, b, sx), lerpf(c, d, sx), sy)


func _hash_unit(cell: Vector2i, salt: int) -> float:
	return float(_hash_pixels(cell.x + map_seed * 17, cell.y - map_seed * 11, salt + map_seed) % 10000) / 10000.0


func _hash_cell(cell: Vector2i, salt: int) -> int:
	return _hash_pixels(cell.x + map_seed * 17, cell.y - map_seed * 11, salt + map_seed)


func _hash_pixels(x: int, y: int, salt: int) -> int:
	var n := int(x) * 374761393 + int(y) * 668265263 + int(salt) * 1442695041
	n = int(n ^ (n >> 13)) * 1274126177
	return int(n ^ (n >> 16)) & 0x7fffffff
