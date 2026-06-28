extends SceneTree


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var scene: PackedScene = load("res://scenes/main.tscn")
	var root_node: Node = scene.instantiate()
	get_root().add_child(root_node)
	for _i in range(24):
		await process_frame

	var overlay := root_node.get_node_or_null("GeneratedFullUiOverlay")
	if overlay == null:
		_fail("GeneratedFullUiOverlay was not added")
		return

	if root_node.has_method("show_desktop_window"):
		root_node.show_desktop_window("skill")
	for _i in range(8):
		await process_frame

	var cases := [
		{
			"window": "Section_WindowStack/Panel_StatusWindowFrame",
			"title": "Text_StatusTitle",
			"close": "Btn_StatusClose",
		},
		{
			"window": "Section_WindowStack/Panel_HeroInventoryWindowFrame",
			"title": "Text_HeroInventoryTitle",
			"close": "Btn_HeroInventoryClose",
		},
		{
			"window": "Section_WindowStack/Panel_PortalWindowFrame",
			"title": "Text_PortalTitle",
			"close": "Btn_PortalClose",
		},
		{
			"window": "Section_WindowStack/RuntimeSkillTreeWindow",
			"title": "Text_RuntimeSkillTreeTitle",
			"close": "Btn_RuntimeSkillTreeClose",
			"minimize": "Btn_RuntimeSkillTreeMinimize",
		},
	]
	for item in cases:
		var window_path := str(item.get("window", ""))
		var window := overlay.get_node_or_null(window_path)
		if window == null or not window is Control:
			_fail("window is missing: %s" % window_path)
			return
		if not _assert_shared_chrome(window as Control, str(item.get("title", "")), str(item.get("close", "")), str(item.get("minimize", ""))):
			return

	print("window title bar chrome smoke ok")
	quit(0)


func _assert_shared_chrome(window: Control, title_name: String, close_name: String, minimize_name: String) -> bool:
	var title_bar := window.get_node_or_null("ProgramTitleBar")
	if title_bar == null or not title_bar is Control:
		_fail("shared ProgramTitleBar is missing on %s" % str(window.name))
		return false
	if str(title_bar.get_meta("window_title_bar_component", "")) != "WindowTitleBarChrome":
		_fail("ProgramTitleBar does not come from WindowTitleBarChrome on %s" % str(window.name))
		return false
	if not _is_visible_control(window.get_node_or_null("Rect_ProgramTitleBarBurgundyFill")):
		_fail("title fill is missing on %s" % str(window.name))
		return false
	if not _is_visible_control(window.get_node_or_null("Line_ProgramTitleBarBottom")):
		_fail("title bottom line is missing on %s" % str(window.name))
		return false
	var concept_nodes := [
		"Panel_TitleBarIronCap",
		"Line_TitleBarIronCapTopHighlight",
		"Line_TitleBarIronCapBottomShadow",
		"Panel_TitleBarLeftIronEndcap",
		"Panel_TitleBarRightIronEndcap",
		"Rect_ProgramTitleBarBurgundyFill",
		"Line_TitleBarPlateTopHighlight",
		"Line_TitleBarPlateBottomShadow",
		"Panel_TitleBarLeftStoneBadge",
		"Panel_TitleBarLeftStoneBadgeInner",
		"Panel_TitleBarLeftStoneChip",
		"Line_TitleBarLeftStoneChipHighlight",
		"Panel_TitleBarCenterCrest",
		"Panel_TitleBarCenterCrestInner",
		"Line_TitleBarLeftGoldTick",
		"Line_TitleBarRightGoldTick",
		"Panel_TitleBarRubyBeadGlow",
		"Panel_TitleBarRubyBead",
		"Panel_TitleBarMossAccent",
		"Panel_TitleBarMossAccent2",
		"Line_TitleBarGoldRailHighlight",
		"Line_TitleBarGoldRailShadow",
	]
	for concept_node in concept_nodes:
		if not _is_visible_control(window.get_node_or_null(concept_node)):
			_fail("forged rail concept node is missing on %s: %s" % [str(window.name), concept_node])
			return false
	for noisy_detail in ["Panel_HeaderLeftPattern", "Panel_HeaderLeftGoldSlash", "Panel_HeaderRightGoldSlash", "Panel_HeaderCenterRivets"]:
		if _is_visible_control(title_bar.get_node_or_null(noisy_detail)):
			_fail("legacy title decoration is visible on %s: %s" % [str(window.name), noisy_detail])
			return false

	var title := window.get_node_or_null(title_name)
	if title == null or not title is Label or (title as Label).horizontal_alignment != HORIZONTAL_ALIGNMENT_CENTER:
		_fail("title label is missing or not centered on %s" % str(window.name))
		return false

	var close_button := window.get_node_or_null(close_name)
	if close_button == null or not close_button is Button:
		_fail("close button is missing on %s" % str(window.name))
		return false
	if (close_button as Button).size.x < 40.0 or (close_button as Button).size.y < 40.0:
		_fail("close button is too small on %s" % str(window.name))
		return false
	if close_button.get_node_or_null("Icon_Close") == null:
		_fail("close button icon is missing on %s" % str(window.name))
		return false
	if not _has_button_detail(close_button as Button):
		_fail("close button forged detail is missing on %s" % str(window.name))
		return false

	if minimize_name != "":
		var minimize_button := window.get_node_or_null(minimize_name)
		if minimize_button == null or not minimize_button is Button:
			_fail("minimize button is missing on %s" % str(window.name))
			return false
		if (minimize_button as Button).size.x > 44.0 or (minimize_button as Button).size.y > 44.0:
			_fail("minimize button is not fixed to compact title chrome size on %s" % str(window.name))
			return false
		if minimize_button.get_node_or_null("Icon_Close") != null:
			_fail("minimize button is rendering as a second close button on %s" % str(window.name))
			return false
		if not _is_visible_control(minimize_button.get_node_or_null("Line_TitleBarMinimizeGlyph")):
			_fail("minimize button line glyph is missing on %s" % str(window.name))
			return false
		if not _has_button_detail(minimize_button as Button):
			_fail("minimize button forged detail is missing on %s" % str(window.name))
			return false
	return true


func _has_button_detail(button: Button) -> bool:
	return _is_visible_control(button.get_node_or_null("Line_TitleBarButtonTopHighlight")) and _is_visible_control(button.get_node_or_null("Line_TitleBarButtonInnerShadow"))


func _is_visible_control(node) -> bool:
	return node != null and node is Control and (node as Control).visible


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
