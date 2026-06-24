extends SceneTree

const MainScene := preload("res://scripts/main.gd")
const HOME_OUTPUT_PATH := "res://screenshots/dokkaebi-outgame-home.png"


func _init() -> void:
	call_deferred("_capture")


func _capture() -> void:
	var root := get_root()
	root.size = Vector2i(540, 960)
	DisplayServer.window_set_size(Vector2i(540, 960))
	var main := MainScene.new()
	main.set_anchors_preset(Control.PRESET_FULL_RECT)
	main.set_test_mode(true)
	root.add_child(main)
	await process_frame
	await process_frame
	main.show_home()
	await process_frame
	await process_frame
	if not _save_viewport(HOME_OUTPUT_PATH):
		return
	quit(0)


func _save_viewport(output_path: String) -> bool:
	var texture := get_root().get_texture()
	if texture == null:
		_fail("capture requires a non-headless renderer")
		return false
	var image := texture.get_image()
	if image == null or image.is_empty():
		_fail("empty capture image")
		return false
	var output := ProjectSettings.globalize_path(output_path)
	var err := image.save_png(output)
	if err != OK:
		_fail("capture save failed: %s" % error_string(err))
		return false
	print("godot-dokkaebi home capture: %s" % output)
	return true


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
