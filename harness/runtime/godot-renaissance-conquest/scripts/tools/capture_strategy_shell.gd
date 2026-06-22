extends SceneTree

const MAIN_SCENE := "res://scenes/main.tscn"
const VIEW_SIZE := Vector2i(1280, 720)
const CAMPAIGN_OUT := "res://screenshots/strategy-shell-campaign.png"
const BATTLE_OUT := "res://screenshots/strategy-shell-battle.png"
const BATTLE_ACTION_OUT := "res://screenshots/strategy-shell-battle-action.png"


func _init() -> void:
	call_deferred("_capture")


func _capture() -> void:
	var packed := load(MAIN_SCENE) as PackedScene
	if packed == null:
		_fail("main scene missing")
		return
	var root := get_root()
	root.size = VIEW_SIZE
	DisplayServer.window_set_size(VIEW_SIZE)
	var scene: Node = packed.instantiate()
	root.add_child(scene)
	await process_frame
	await process_frame
	_save_view(root, CAMPAIGN_OUT)
	scene.show_battle()
	await process_frame
	await process_frame
	_save_view(root, BATTLE_OUT)
	var cannon_button := scene.find_child("SkillButton_Cannon", true, false) as Button
	if cannon_button == null:
		_fail("Cannon skill button missing for action capture")
		return
	cannon_button.emit_signal("pressed")
	await process_frame
	await process_frame
	_save_view(root, BATTLE_ACTION_OUT)
	print("renaissance-conquest captures: %s, %s, %s" % [ProjectSettings.globalize_path(CAMPAIGN_OUT), ProjectSettings.globalize_path(BATTLE_OUT), ProjectSettings.globalize_path(BATTLE_ACTION_OUT)])
	quit(0)


func _save_view(root: Window, path: String) -> void:
	var texture := root.get_texture()
	if texture == null:
		_fail("capture requires a non-headless renderer")
		return
	var image := texture.get_image()
	if image == null or image.is_empty():
		_fail("capture produced an empty image")
		return
	var err := image.save_png(ProjectSettings.globalize_path(path))
	if err != OK:
		_fail("capture save failed: %s" % error_string(err))


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
