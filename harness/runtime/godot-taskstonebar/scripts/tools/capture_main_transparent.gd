extends SceneTree

const SCENE_PATH := "res://scenes/main.tscn"
const OUTPUT_PATH := "res://screenshots/taskstonebar-main-transparent.png"


func _init() -> void:
	call_deferred("_capture")


func _capture() -> void:
	get_root().transparent_bg = true
	RenderingServer.set_default_clear_color(Color(0.0, 0.0, 0.0, 0.0))

	var scene: PackedScene = load(SCENE_PATH)
	if not (scene is PackedScene):
		push_error("failed to load main scene: %s" % SCENE_PATH)
		quit(1)
		return

	var root_node := scene.instantiate()
	get_root().add_child(root_node)
	for _i in range(60):
		await process_frame

	var absolute_path := ProjectSettings.globalize_path(OUTPUT_PATH)
	DirAccess.make_dir_recursive_absolute(absolute_path.get_base_dir())
	var image: Image = get_root().get_texture().get_image()
	var error := image.save_png(absolute_path)
	if error != OK:
		push_error("failed to save screenshot %s: %s" % [absolute_path, error_string(error)])
		quit(1)
		return

	print("saved %s" % absolute_path)
	quit(0)
