extends SceneTree


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var scene: PackedScene = load("res://scenes/main.tscn")
	var root_node: Node = scene.instantiate()
	get_root().add_child(root_node)
	for _i in range(12):
		await process_frame

	if not root_node.has_method("open_portal_window"):
		_fail("main scene does not expose open_portal_window")
		return

	root_node.open_portal_window()
	for _i in range(6):
		await process_frame

	var portal := root_node.get_node_or_null("PortalMapWindow")
	if portal == null:
		_fail("PortalMapWindow was not added to the main scene")
		return
	if not portal.visible:
		_fail("PortalMapWindow did not open")
		return

	var close_button := portal.get_node_or_null("Btn_PortalClose")
	if close_button == null or not close_button is Button:
		_fail("PortalMapWindow has no close button")
		return
	(close_button as Button).pressed.emit()
	for _i in range(6):
		await process_frame
	if portal.visible:
		_fail("PortalMapWindow close button did not close only the portal window")
		return

	var title_label: Variant = root_node.get("title_label")
	if title_label == null:
		_fail("main scene labels disappeared after portal close")
		return

	print("portal map modal smoke ok")
	quit(0)


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
