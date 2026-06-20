extends SceneTree

const ContentStore := preload("res://scripts/content_store.gd")
const Catalog := preload("res://scripts/core/ninja2_catalog.gd")

const PLAYER_WALK_COLUMNS := 8


func _init() -> void:
	var store := ContentStore.new()
	if not store.load_all():
		_fail("content load had errors: %s" % "; ".join(store.errors))
		return

	var relative_path := str(Catalog.UI_TEXTURES.get("player_walk_sheet", ""))
	if relative_path.is_empty():
		_fail("player walk sheet path is missing")
		return

	var image := Image.new()
	var err := image.load(store.runtime_asset_path(relative_path))
	if err != OK:
		_fail("player walk sheet could not be loaded: %s" % relative_path)
		return

	if image.get_width() <= 0 or image.get_height() <= 0:
		_fail("player walk sheet is empty: %s" % relative_path)
		return

	var cell_width := int(round(float(image.get_width()) / float(PLAYER_WALK_COLUMNS)))
	var row_count := int(round(float(image.get_height()) / float(max(1, cell_width))))
	if row_count != 3:
		_fail("player walk sheet should be the validated three-row source until a better four-direction sheet lands: %s rows" % row_count)
		return

	var cell_height := int(round(float(image.get_height()) / float(row_count)))
	for row in range(row_count):
		if not _row_has_visible_pixels(image, row, cell_width, cell_height):
			_fail("player walk sheet row %d has no visible pixels" % row)
			return

	print("godot-ninja2 player walk sheet smoke ok: path=%s rows=%d columns=%d" % [
		relative_path,
		row_count,
		PLAYER_WALK_COLUMNS,
	])
	quit(0)


func _row_has_visible_pixels(image: Image, row: int, cell_width: int, cell_height: int) -> bool:
	var row_y := row * cell_height
	for column in range(PLAYER_WALK_COLUMNS):
		var cell_x := column * cell_width
		for y in range(cell_height):
			for x in range(cell_width):
				if image.get_pixel(cell_x + x, row_y + y).a > 0.03:
					return true
	return false


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
