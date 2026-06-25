extends SceneTree

const SCENE_PATH := "res://scenes/main.tscn"


func _init() -> void:
	call_deferred("_inspect")


func _inspect() -> void:
	var scene: PackedScene = load(SCENE_PATH)
	if not (scene is PackedScene):
		push_error("failed to load main scene")
		quit(1)
		return
	var root_node := scene.instantiate()
	get_root().add_child(root_node)
	for _i in range(90):
		await process_frame
	var overlay := root_node.get_node_or_null("GeneratedFullUiOverlay")
	if overlay == null:
		push_error("GeneratedFullUiOverlay missing")
		quit(1)
		return
	for path in [
		"Section_WindowStack/Panel_StatusWindowFrame",
		"Section_WindowStack/Panel_HeroInventoryWindowFrame",
		"Section_WindowStack/Panel_PortalWindowFrame",
	]:
		var node := overlay.get_node_or_null(path)
		if node is Control:
			var title_bar := _find_title_bar(node as Control)
			var close_count := _count_named_button_suffix(node as Control, "Close")
			var minimize_count := _count_named_button_suffix(node as Control, "Minimize")
			print("%s visible=%s pos=%s size=%s z=%s drag=%s close=%d minimize=%d" % [
				path,
				(node as Control).visible,
				(node as Control).global_position,
				(node as Control).size,
				(node as Control).z_index,
				title_bar != null and title_bar.has_meta("program_drag_connected"),
				close_count,
				minimize_count,
			])
		else:
			print("%s missing" % path)
	quit(0)


func _find_title_bar(window: Control) -> Control:
	for child in window.get_children():
		if child is Control and str(child.name).ends_with("TitleBar"):
			return child as Control
	return null


func _count_named_button_suffix(window: Control, suffix: String) -> int:
	var count := 0
	for child in window.get_children():
		if child is Button and str(child.name).ends_with(suffix):
			count += 1
	return count
