extends SceneTree

const OUTPUT_PATH := "res://screenshots/taskstonebar-portal-map-modal.png"


func _init() -> void:
	call_deferred("_capture")


func _capture() -> void:
	Engine.time_scale = 2.0
	var scene: PackedScene = load("res://scenes/main.tscn")
	var root_node: Node = scene.instantiate()
	get_root().add_child(root_node)
	for _i in range(60):
		await process_frame

	if root_node.has_method("open_portal_window"):
		root_node.open_portal_window()
	for _i in range(40):
		await process_frame

	var absolute_path := ProjectSettings.globalize_path(OUTPUT_PATH)
	DirAccess.make_dir_recursive_absolute(absolute_path.get_base_dir())
	var image: Image = get_root().get_texture().get_image()
	var error := image.save_png(absolute_path)
	Engine.time_scale = 1.0
	if error != OK:
		push_error("failed to save screenshot %s: %s" % [absolute_path, error_string(error)])
		quit(1)
		return

	print("saved %s" % absolute_path)
	quit(0)
