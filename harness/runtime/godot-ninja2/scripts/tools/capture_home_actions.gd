extends SceneTree

const ContentStore := preload("res://scripts/content_store.gd")
const Catalog := preload("res://scripts/core/ninja2_catalog.gd")
const HousingTechStore := preload("res://scripts/home/housing_tech_store.gd")
const SanctuaryState := preload("res://scripts/home/sanctuary_state.gd")
const HomeScreen := preload("res://scripts/home/home_screen.gd")

const VIEW_SIZE := Vector2i(540, 1016)
const CAPTURES := [
	{"action": "menu", "path": "res://screenshots/godot-ninja2-main-menu.png"},
	{"action": "quick:mail", "path": "res://screenshots/godot-ninja2-quick-mail.png"},
	{"action": "quick:bag", "path": "res://screenshots/godot-ninja2-quick-bag.png"},
	{"action": "quick:pass", "path": "res://screenshots/godot-ninja2-quick-pass.png"},
	{"action": "settings", "path": "res://screenshots/godot-ninja2-settings.png"},
]


func _init() -> void:
	call_deferred("_capture")


func _capture() -> void:
	var store = ContentStore.new()
	var content_ok: bool = store.load_all()
	var housing_store = HousingTechStore.new()
	var housing_ok: bool = housing_store.load_all()
	if not content_ok or not housing_ok:
		_fail("capture data load failed")
		return

	var sanctuary_state = SanctuaryState.new()
	sanctuary_state.seed_from_housing(housing_store)
	sanctuary_state.ensure_starter_equipment(store)

	var textures := _load_textures(store, housing_store)
	var root := get_root()
	root.size = VIEW_SIZE
	DisplayServer.window_set_size(VIEW_SIZE)

	var home = HomeScreen.new()
	home.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.add_child(home)
	home.setup(store, housing_store, sanctuary_state, textures)

	await process_frame
	await process_frame

	for capture in CAPTURES:
		var action := str(capture.get("action", ""))
		if home.modal_layer != null:
			home.modal_layer.close_all()
		await process_frame
		if action == "menu":
			home._open_main_menu_modal()
		elif action == "settings":
			home._open_settings_modal()
		elif action.begins_with("quick:"):
			home._open_quick_modal(action.replace("quick:", ""))
		await process_frame
		await process_frame
		_save_viewport(root, str(capture.get("path", "")))

	print("godot-ninja2 home action captures written")
	quit(0)


func _save_viewport(root: Window, output_path: String) -> void:
	var viewport_texture = root.get_texture()
	if viewport_texture == null:
		_fail("capture requires a non-headless renderer")
		return
	var image: Image = viewport_texture.get_image()
	if image == null or image.is_empty():
		_fail("capture produced an empty viewport image")
		return
	var output := ProjectSettings.globalize_path(output_path)
	var err := image.save_png(output)
	if err != OK:
		_fail("capture save failed: %s" % error_string(err))


func _load_textures(store, housing_store) -> Dictionary:
	var textures := {}
	var paths: Dictionary = Catalog.all_texture_paths()
	for key in housing_store.all_texture_paths().keys():
		paths[key] = housing_store.all_texture_paths()[key]
	for key in paths.keys():
		textures[key] = _load_texture(store, paths[key])
	return textures


func _load_texture(store, relative_path: String) -> Texture2D:
	var image := Image.new()
	var path: String = store.runtime_asset_path(relative_path)
	var err := image.load(path)
	if err != OK:
		push_warning("Missing ninja2 texture: %s" % path)
		return null
	return ImageTexture.create_from_image(image)


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
