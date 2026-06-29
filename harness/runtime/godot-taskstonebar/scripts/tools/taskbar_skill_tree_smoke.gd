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
	var bottom_strip := overlay.get_node_or_null("Section_BottomCombatStrip")
	if bottom_strip == null or not bottom_strip is CanvasItem:
		_fail("bottom combat strip is missing")
		return

	var skill_button := overlay.get_node_or_null("Section_WindowStack/Panel_HeroInventoryWindowFrame/Dock_KeeperIconDock/Btn_DockFormation")
	if skill_button == null or not skill_button is Button:
		_fail("runtime skill dock button is missing")
		return
	(skill_button as Button).pressed.emit()
	for _i in range(8):
		await process_frame

	var skill_window := overlay.get_node_or_null("Section_WindowStack/RuntimeSkillTreeWindow")
	if skill_window == null or not skill_window is Control:
		_fail("runtime skill tree desktop window was not created")
		return
	if not (skill_window as Control).visible:
		_fail("skill tree window did not open from the skill action")
		return
	if (skill_window as Control).size.x >= 900.0 or (skill_window as Control).size.y >= 650.0:
		_fail("skill tree window is too large for the desktop-window contract")
		return
	if skill_window.get_node_or_null("Text_RuntimeSkillTreeTitle") == null:
		_fail("skill tree window has no title bar label")
		return
	if skill_window.get_node_or_null("Btn_RuntimeSkillTreeClose") == null or skill_window.get_node_or_null("Btn_RuntimeSkillTreeMinimize") == null:
		_fail("skill tree window has no close/minimize affordances")
		return
	var skill_title_bar := skill_window.get_node_or_null("ProgramTitleBar")
	if skill_title_bar == null or str(skill_title_bar.get_meta("window_title_bar_component", "")) != "WindowTitleBarChrome":
		_fail("skill tree window is not using the shared WindowTitleBarChrome component")
		return
	if not _is_visible_control(skill_window.get_node_or_null("Line_ProgramTitleBarBottom")):
		_fail("skill tree window title chrome is missing the clean title bar/bottom line")
		return
	if skill_window.get_node_or_null("Btn_RuntimeSkillTreeMinimize/Icon_Close") != null:
		_fail("skill tree minimize button should not render as a second close button")
		return
	if skill_window.get_node_or_null("Panel_RuntimeSkillTreeBody") == null or skill_window.get_node_or_null("Panel_RuntimeSkillTreeFooter") == null:
		_fail("skill tree window has no framed body/footer")
		return
	for item_id in [200509, 200514, 200519, 200524, 200529, 200534, 200538]:
		var skill_node := skill_window.get_node_or_null("Panel_RuntimeSkillTreeBody/Content_RuntimeSkillTreeBody/Btn_RuntimeSkillNode_%d" % item_id)
		if skill_node == null:
			_fail("skill tree node %d is missing" % item_id)
			return
		var skill_icon := skill_node.get_node_or_null("Tex_RuntimeSkillNodeIcon")
		if skill_icon == null or not skill_icon is TextureRect or (skill_icon as TextureRect).texture == null:
			_fail("skill tree node %d did not bind an icon texture" % item_id)
			return
		var state_label := skill_node.get_node_or_null("Text_RuntimeSkillNodeState")
		if state_label == null or not state_label is Label or str((state_label as Label).text) == "":
			_fail("skill tree node %d did not bind its state label" % item_id)
			return
	(skill_window.get_node_or_null("Btn_RuntimeSkillTreeClose") as Button).pressed.emit()
	for _i in range(4):
		await process_frame
	if (skill_window as Control).visible:
		_fail("skill tree window did not close from its close button")
		return
	var status_search := overlay.get_node_or_null("Section_WindowStack/Panel_StatusWindowFrame/Panel_StatusStatScroll/Btn_StatusSearch")
	if status_search == null or not status_search is Button:
		_fail("status search button is missing")
		return
	(status_search as Button).pressed.emit()
	for _i in range(8):
		await process_frame
	if not (skill_window as Control).visible:
		_fail("status window search button did not open the skill tree")
		return
	var skill_points := overlay.get_node_or_null("Section_WindowStack/Panel_StatusWindowFrame/Panel_SkillPointHeader/Text_SkillPoints")
	if skill_points == null or not skill_points is Label or str((skill_points as Label).text).find("3") == -1:
		_fail("status window skill points are not bound to progression materials")
		return
	var status_stat_scroll := overlay.get_node_or_null("Section_WindowStack/Panel_StatusWindowFrame/Panel_StatusStatScroll/Scroll_StatusRows")
	if status_stat_scroll == null or not status_stat_scroll is ScrollContainer:
		_fail("status window stats are not using a real ScrollContainer")
		return
	(status_stat_scroll as ScrollContainer).scroll_vertical = 999
	for _i in range(4):
		await process_frame
	if (status_stat_scroll as ScrollContainer).scroll_vertical <= 0:
		_fail("status window stat ScrollContainer did not scroll")
		return
	var status_level := overlay.find_child("Text_StatusLevelValue", true, false)
	if status_level == null or not status_level is Label or str((status_level as Label).text).find("Lv.") == -1:
		_fail("status window level value is not bound to the combat player snapshot")
		return
	var status_attack := overlay.find_child("Text_StatusAttackDamageValue", true, false)
	if status_attack == null or not status_attack is Label or str((status_attack as Label).text).find("+") == -1:
		_fail("status window attack value is not including progression equipment bonuses")
		return
	var status_exp := overlay.find_child("Text_StatusExpValue", true, false)
	if status_exp == null or not status_exp is Label or not str((status_exp as Label).text).begins_with("EXP"):
		_fail("status window exp row should show the keeper EXP summary")
		return
	var keeper_exp_bar := overlay.get_node_or_null("Section_WindowStack/Panel_HeroInventoryWindowFrame/Progress_KeeperExp")
	var keeper_exp_label := overlay.get_node_or_null("Section_WindowStack/Panel_HeroInventoryWindowFrame/Text_KeeperExp")
	if keeper_exp_bar == null or not keeper_exp_bar is ProgressBar:
		_fail("keeper window exp bar is missing")
		return
	if (keeper_exp_bar as ProgressBar).value <= 0.0 or (keeper_exp_bar as ProgressBar).value >= 1.0:
		_fail("keeper window exp bar did not receive a bounded real exp ratio")
		return
	if keeper_exp_label == null or not keeper_exp_label is Label or str((keeper_exp_label as Label).text).find("EXP") == -1:
		_fail("keeper window exp label is missing")
		return
	var stone_throw_level := overlay.get_node_or_null("Section_WindowStack/Panel_StatusWindowFrame/Section_SkillTree/Grid_StatusSkillSlots/Panel_SkillStoneThrow/Text_SkillStoneThrowLevel")
	if stone_throw_level == null or not stone_throw_level is Label:
		_fail("status window stone throw skill label is missing")
		return
	var stone_throw_icon := overlay.get_node_or_null("Section_WindowStack/Panel_StatusWindowFrame/Section_SkillTree/Grid_StatusSkillSlots/Panel_SkillStoneThrow/Icon_SkillStoneThrow")
	if stone_throw_icon == null or not stone_throw_icon is TextureRect or (stone_throw_icon as TextureRect).texture == null:
		_fail("status window stone throw skill icon is missing")
		return
	var status_stone_throw_slot := overlay.get_node_or_null("Section_WindowStack/Panel_StatusWindowFrame/Section_SkillTree/Grid_StatusSkillSlots/Panel_SkillStoneThrow")
	if status_stone_throw_slot == null or not status_stone_throw_slot is Control:
		_fail("status window stone throw skill slot is missing")
		return
	if not _slot_children_ignore_mouse(status_stone_throw_slot as Control):
		_fail("status skill slot children still intercept mouse input")
		return
	var before_status_slot_points := _parse_skill_points(str((skill_points as Label).text))
	_emit_left_click(status_stone_throw_slot as Control)
	for _i in range(8):
		await process_frame
	if str((stone_throw_level as Label).text).find("1/") == -1:
		_fail("status window first skill slot spent points before opening the detail modal")
		return
	var skill_detail := overlay.get_node_or_null("ModalHost/Modal_SkillDetail")
	if skill_detail == null or not skill_detail is Control:
		_fail("status window first skill slot did not open the skill detail modal")
		return
	var skill_detail_confirm := skill_detail.get_node_or_null("Footer_SkillDetail/Btn_SkillDetailConfirm")
	if skill_detail_confirm == null or not skill_detail_confirm is Button:
		_fail("skill detail modal has no learn/level-up confirm button")
		return
	if (skill_detail_confirm as Button).disabled:
		_fail("skill detail modal confirm button is disabled for the starter skill")
		return
	(skill_detail_confirm as Button).pressed.emit()
	for _i in range(8):
		await process_frame
	if str((stone_throw_level as Label).text).find("2/") == -1:
		_fail("skill detail modal confirm did not level the starter skill")
		return
	var after_status_slot_points := _parse_skill_points(str((skill_points as Label).text))
	if after_status_slot_points >= before_status_slot_points:
		_fail("skill detail modal confirm did not consume a real skill point")
		return
	var branch_node := skill_window.get_node_or_null("Panel_RuntimeSkillTreeBody/Content_RuntimeSkillTreeBody/Btn_RuntimeSkillNode_200509")
	if branch_node == null or not branch_node is Button:
		_fail("runtime branch skill node 200509 is missing")
		return
	(branch_node as Button).pressed.emit()
	for _i in range(8):
		await process_frame
	var learn_button := skill_window.get_node_or_null("Panel_RuntimeSkillTreeFooter/Content_RuntimeSkillTreeFooter/Btn_RuntimeSkillLearn")
	if learn_button == null or not learn_button is Button:
		_fail("skill tree learn button is missing")
		return
	if not (learn_button as Button).disabled:
		_fail("skill tree learn button should start locked by player/parent-skill requirements")
		return
	var learn_tooltip := str((learn_button as Button).tooltip_text)
	if learn_tooltip.find("Lv.") == -1:
		_fail("skill tree learn button tooltip does not expose the level/skill gate")
		return
	for _level_step in range(14):
		var player: Dictionary = root_node.sim.snapshot().get("player", {})
		var required_exp := int(player.get("required_exp", 0))
		if required_exp <= 0:
			break
		root_node.sim._add_reward_item({"itemDataId": 1, "exp": required_exp})
	root_node.progression.learn_skill(200503, 3)
	for _i in range(8):
		await process_frame
	if int(root_node.sim.snapshot().get("player", {}).get("level", 0)) < 15:
		_fail("skill tree smoke setup did not reach the first branch player level gate")
		return
	if (learn_button as Button).disabled:
		_fail("skill tree learn button did not unlock after meeting player/parent-skill requirements")
		return
	(learn_button as Button).pressed.emit()
	for _i in range(8):
		await process_frame
	if not root_node.progression.skills.has(200509):
		_fail("runtime skill tree learn button did not learn branch skill 200509")
		return
	var learned_skill_ids: Array = root_node.sim.snapshot().get("player_learned_skill_ids", [])
	if not learned_skill_ids.has(300301):
		_fail("learned branch skill 200509 did not auto-equip into combat rotation")
		return
	root_node.sim.start(int(root_node.sim.snapshot().get("map_id", 500101)))
	for _i in range(8):
		await process_frame

	var player_hp_bar := overlay.get_node_or_null("Section_BottomCombatStrip/Progress_RuntimePlayerHp")
	var player_hp_text := overlay.get_node_or_null("Section_BottomCombatStrip/Text_RuntimePlayerHp")
	var enemy_layer := overlay.get_node_or_null("Section_BottomCombatStrip/RuntimeEnemyLayer")
	if player_hp_bar == null or not player_hp_bar is ProgressBar or player_hp_text == null or not player_hp_text is Label:
		_fail("combat strip player hp widgets are missing")
		return
	if enemy_layer == null or not enemy_layer is Control:
		_fail("runtime enemy layer is missing")
		return
	for noisy_panel in [
		"Panel_RuntimeCombatState",
		"Panel_RuntimeCombatSkill",
		"Panel_RuntimeCombatEnemy",
		"Panel_RuntimeCombatLootTicker",
		"Panel_AutoCombatToggle",
		"Panel_AutoSkillToggle",
		"Panel_LootTicker",
	]:
		if _is_visible_canvas(overlay.get_node_or_null("Section_BottomCombatStrip/%s" % noisy_panel)):
			_fail("combat data panel should stay hidden: %s" % noisy_panel)
			return

	var toggle := overlay.get_node_or_null("Section_BottomCombatStrip/Btn_RuntimeWorkshopToggle")
	if toggle == null or not toggle is Button:
		_fail("taskbar companion toggle is missing")
		return
	var before_elapsed := float(root_node.sim.snapshot().get("elapsed", 0.0))
	(toggle as Button).pressed.emit()
	for _i in range(12):
		await process_frame
	if not (bottom_strip as CanvasItem).visible:
		_fail("bottom combat strip was hidden by taskbar mode")
		return
	if (skill_window as Control).visible:
		_fail("skill tree window stayed visible in taskbar mode")
		return
	var hero_frame := overlay.get_node_or_null("Section_WindowStack/Panel_HeroInventoryWindowFrame")
	var status_frame := overlay.get_node_or_null("Section_WindowStack/Panel_StatusWindowFrame")
	if hero_frame == null or status_frame == null or (hero_frame as CanvasItem).visible or (status_frame as CanvasItem).visible:
		_fail("workshop windows were not minimized in taskbar mode")
		return

	var saw_player_hp := false
	var saw_enemy_stack := false
	for _i in range(1400):
		await process_frame
		if (player_hp_bar as ProgressBar).visible and (player_hp_bar as ProgressBar).value > 0.0:
			saw_player_hp = true
		var snapshot: Dictionary = root_node.sim.snapshot()
		if int(snapshot.get("enemy_count", 0)) >= 2 and _visible_runtime_enemy_count(enemy_layer as Control) >= 2:
			saw_enemy_stack = true
		if saw_player_hp and saw_enemy_stack:
			break

	if float(root_node.sim.snapshot().get("elapsed", 0.0)) <= before_elapsed:
		_fail("combat simulation did not advance while windows were hidden")
		return
	if not saw_player_hp:
		var snapshot: Dictionary = root_node.sim.snapshot()
		var player: Dictionary = snapshot.get("player", {})
		_fail("player hp did not become visible on the combat strip: bar_visible=%s value=%.3f player_hp=%.1f max=%.1f running=%s result=%s" % [
			str((player_hp_bar as ProgressBar).visible),
			float((player_hp_bar as ProgressBar).value),
			float(player.get("hp", 0.0)),
			float(player.get("max_hp", 0.0)),
			str(snapshot.get("running", false)),
			str(snapshot.get("result", "")),
		])
		return
	if not saw_enemy_stack:
		_fail("multiple runtime enemies were not visible on the combat strip")
		return
	for noisy_panel in [
		"Panel_RuntimeCombatState",
		"Panel_RuntimeCombatSkill",
		"Panel_RuntimeCombatEnemy",
		"Panel_RuntimeCombatLootTicker",
		"Panel_AutoCombatToggle",
		"Panel_AutoSkillToggle",
		"Panel_LootTicker",
	]:
		if _is_visible_canvas(overlay.get_node_or_null("Section_BottomCombatStrip/%s" % noisy_panel)):
			_fail("combat data panel became visible during taskbar combat: %s" % noisy_panel)
			return

	(toggle as Button).pressed.emit()
	for _i in range(8):
		await process_frame
	if not (hero_frame as CanvasItem).visible or not (status_frame as CanvasItem).visible:
		_fail("workshop windows did not restore from taskbar mode")
		return
	if not (skill_window as Control).visible:
		_fail("skill tree window did not restore with the selected skill action")
		return

	print("taskbar skill tree smoke ok")
	quit(0)


func _fail(message: String) -> void:
	push_error(message)
	quit(1)


func _visible_runtime_enemy_count(layer: Control) -> int:
	var count := 0
	for child in layer.get_children():
		if str(child.name).begins_with("RuntimeEnemy_") and child is CanvasItem and (child as CanvasItem).visible:
			count += 1
	return count


func _is_visible_canvas(node) -> bool:
	return node != null and node is CanvasItem and (node as CanvasItem).visible


func _is_visible_control(node) -> bool:
	return node != null and node is Control and (node as Control).visible


func _emit_left_click(control: Control) -> void:
	var event := InputEventMouseButton.new()
	event.button_index = MOUSE_BUTTON_LEFT
	event.pressed = true
	event.position = control.size * 0.5
	control.emit_signal("gui_input", event)


func _parse_skill_points(text: String) -> int:
	var pieces := text.split(":")
	if pieces.size() >= 2:
		return int(str(pieces[1]).strip_edges())
	return int(text)


func _slot_children_ignore_mouse(slot: Control) -> bool:
	for child in slot.get_children():
		if child is Control:
			var control := child as Control
			if control.mouse_filter != Control.MOUSE_FILTER_IGNORE:
				return false
			if not _slot_children_ignore_mouse(control):
				return false
	return true
