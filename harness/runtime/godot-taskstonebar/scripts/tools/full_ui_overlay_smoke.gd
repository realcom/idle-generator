extends SceneTree


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var scene: PackedScene = load("res://scenes/main.tscn")
	var root_node: Node = scene.instantiate()
	get_root().add_child(root_node)
	for _i in range(18):
		await process_frame

	var native_flag_probe := Window.new()
	root_node.add_child(native_flag_probe)
	root_node._apply_native_window_system_flags(native_flag_probe)
	if native_flag_probe.transparent_bg != bool(root_node._native_window_transparency_enabled()):
		_fail("native window transparency flag helper did not set transparent_bg")
		return
	if DisplayServer.get_name() != "headless" and (not native_flag_probe.borderless or not native_flag_probe.always_on_top or not native_flag_probe.unresizable):
		_fail("native window system flag helper did not set chrome flags")
		return
	native_flag_probe.queue_free()

	var overlay := root_node.get_node_or_null("GeneratedFullUiOverlay")
	if overlay == null:
		_fail("GeneratedFullUiOverlay was not added to the main scene")
		return

	var portal_frame := overlay.get_node_or_null("Section_WindowStack/Panel_PortalWindowFrame")
	var hero_frame := overlay.get_node_or_null("Section_WindowStack/Panel_HeroInventoryWindowFrame")
	var status_frame := overlay.get_node_or_null("Section_WindowStack/Panel_StatusWindowFrame")
	if portal_frame == null or hero_frame == null or status_frame == null:
		_fail("generated overlay windows are missing")
		return
	if not hero_frame is Control or not status_frame is Control or not portal_frame is Control:
		_fail("generated overlay windows are not Control nodes")
		return
	var status_rect := (status_frame as Control).get_rect()
	var hero_rect := (hero_frame as Control).get_rect()
	var portal_rect := (portal_frame as Control).get_rect()
	var status_visual_rect := _control_visual_rect(status_frame as Control)
	var hero_visual_rect := _control_visual_rect(hero_frame as Control)
	var portal_visual_rect := _control_visual_rect(portal_frame as Control)
	if absf((hero_frame as Control).scale.x - 0.8) > 0.01 or absf((status_frame as Control).scale.x - 0.8) > 0.01 or absf((portal_frame as Control).scale.x - 0.8) > 0.01:
		_fail("workshop windows should render at 0.8 visual scale, got status=%s hero=%s portal=%s" % [
			str((status_frame as Control).scale),
			str((hero_frame as Control).scale),
			str((portal_frame as Control).scale),
		])
		return
	if hero_visual_rect.size.y > 510.0 or hero_visual_rect.size.y < 490.0:
		_fail("hero inventory window should be visually reduced by 20%%, got logical=%s visual=%s" % [str(hero_rect.size), str(hero_visual_rect.size)])
		return
	if status_visual_rect.size.y > 460.0 or portal_visual_rect.size.y > 460.0:
		_fail("side windows should be visually reduced by 20%%, got status=%s portal=%s" % [str(status_visual_rect.size), str(portal_visual_rect.size)])
		return
	var left_gap := hero_visual_rect.position.x - status_visual_rect.end.x
	var right_gap := portal_visual_rect.position.x - hero_visual_rect.end.x
	if left_gap < 10.0 or left_gap > 24.0 or right_gap < 10.0 or right_gap > 24.0:
		_fail("workshop windows should form a compact cluster with ~16px gaps, got left=%.1f right=%.1f" % [left_gap, right_gap])
		return
	for header_art_path in [
		"Section_WindowStack/Panel_StatusWindowFrame/Tex_StatusWindowOrnament",
		"Section_WindowStack/Panel_HeroInventoryWindowFrame/Tex_HeroInventoryWindowOrnament",
		"Section_WindowStack/Panel_PortalWindowFrame/Tex_PortalWindowOrnament",
		"Section_WindowStack/Panel_StatusWindowFrame/ProgramWindowIcon",
		"Section_WindowStack/Panel_HeroInventoryWindowFrame/ProgramWindowIcon",
		"Section_WindowStack/Panel_PortalWindowFrame/ProgramWindowIcon",
		"Section_WindowStack/Panel_StatusWindowFrame/Panel_StatusTitleBar",
		"Section_WindowStack/Panel_HeroInventoryWindowFrame/Panel_HeroInventoryTitleBar",
		"Section_WindowStack/Panel_PortalWindowFrame/Panel_PortalTitleBar",
	]:
		if _is_visible_control(overlay.get_node_or_null(header_art_path)):
			_fail("legacy header art should be hidden in the reference compact header: %s" % header_art_path)
			return
	for reference_window_path in [
		"Section_WindowStack/Panel_StatusWindowFrame",
		"Section_WindowStack/Panel_HeroInventoryWindowFrame",
		"Section_WindowStack/Panel_PortalWindowFrame",
	]:
		var reference_title_path := "%s/ProgramTitleBar" % reference_window_path
		if not _is_visible_control(overlay.get_node_or_null(reference_title_path)):
			_fail("reference native program title bar is missing: %s" % reference_title_path)
			return
		if str(overlay.get_node(reference_title_path).get_meta("window_title_bar_component", "")) != "WindowTitleBarChrome":
			_fail("reference title bar is not using the shared WindowTitleBarChrome component: %s" % reference_title_path)
			return
		if not _is_visible_control(overlay.get_node_or_null("%s/Rect_ProgramTitleBarBurgundyFill" % reference_window_path)):
			_fail("reference title bar is missing the burgundy fill surface: %s" % reference_window_path)
			return
		if not _is_visible_control(overlay.get_node_or_null("%s/Line_ProgramTitleBarBottom" % reference_window_path)):
			_fail("reference title bar is missing the clean bottom accent line: %s" % reference_window_path)
			return
		for noisy_detail in ["Panel_HeaderLeftPattern", "Panel_HeaderLeftGoldSlash", "Panel_HeaderRightGoldSlash", "Panel_HeaderCenterRivets"]:
			if _is_visible_control(overlay.get_node_or_null("%s/%s" % [reference_title_path, noisy_detail])):
				_fail("reference title bar still shows broken decorative chrome: %s/%s" % [reference_title_path, noisy_detail])
				return
	var hero_title := overlay.get_node_or_null("Section_WindowStack/Panel_HeroInventoryWindowFrame/Text_HeroInventoryTitle")
	if hero_title == null or not hero_title is Label or (hero_title as Label).horizontal_alignment != HORIZONTAL_ALIGNMENT_CENTER:
		_fail("hero title should be centered in the reference title bar")
		return
	for help_path in [
		"Section_WindowStack/Panel_StatusWindowFrame/Btn_ProgramHelp",
		"Section_WindowStack/Panel_HeroInventoryWindowFrame/Btn_ProgramHelp",
		"Section_WindowStack/Panel_PortalWindowFrame/Btn_ProgramHelp",
	]:
		if _is_visible_control(overlay.get_node_or_null(help_path)):
			_fail("reference title bar still shows the crowded help button: %s" % help_path)
			return
	var keeper_dock := overlay.get_node_or_null("Section_WindowStack/Panel_HeroInventoryWindowFrame/Dock_KeeperIconDock")
	if keeper_dock == null or not keeper_dock is HBoxContainer:
		_fail("keeper dock was not created")
		return
	var auto_merge_toggle := overlay.get_node_or_null("Section_WindowStack/Panel_HeroInventoryWindowFrame/Dock_KeeperIconDock/Btn_DockInventory")
	if auto_merge_toggle == null or not auto_merge_toggle is Button:
		_fail("auto stone merge toggle should use keeper dock button 1")
		return
	if (keeper_dock as HBoxContainer).get_child_count() <= 0 or (keeper_dock as HBoxContainer).get_child(0) != auto_merge_toggle:
		_fail("auto stone merge toggle should be keeper dock button 1")
		return
	if not (auto_merge_toggle as Button).toggle_mode:
		_fail("auto stone merge dock button should be a toggle")
		return
	if (auto_merge_toggle as Button).button_pressed:
		_fail("auto stone merge dock button should default to OFF")
		return
	var dock_icon := (auto_merge_toggle as Button).get_node_or_null("Icon_DockInventory")
	if dock_icon == null or not dock_icon is TextureRect or (dock_icon as TextureRect).texture == null:
		_fail("keeper dock auto merge button did not receive a generated icon")
		return
	var auto_merge_badge := (auto_merge_toggle as Button).get_node_or_null("Text_AutoStoneMergeBadge")
	if auto_merge_badge == null or not auto_merge_badge is Label or (auto_merge_badge as Label).text != "OFF":
		_fail("auto stone merge dock button should show OFF state")
		return
	var auto_equipment_toggle := overlay.get_node_or_null("Section_WindowStack/Panel_HeroInventoryWindowFrame/Dock_KeeperIconDock/Btn_DockGrowth")
	if auto_equipment_toggle == null or not auto_equipment_toggle is Button:
		_fail("auto equipment merge toggle should use keeper dock button 2")
		return
	if (keeper_dock as HBoxContainer).get_child_count() <= 1 or (keeper_dock as HBoxContainer).get_child(1) != auto_equipment_toggle:
		_fail("auto equipment merge toggle should be keeper dock button 2")
		return
	if not (auto_equipment_toggle as Button).toggle_mode:
		_fail("auto equipment merge dock button should be a toggle")
		return
	if (auto_equipment_toggle as Button).button_pressed:
		_fail("auto equipment merge dock button should default to OFF")
		return
	var equipment_dock_icon := (auto_equipment_toggle as Button).get_node_or_null("Icon_DockGrowth")
	if equipment_dock_icon == null or not equipment_dock_icon is TextureRect or (equipment_dock_icon as TextureRect).texture == null:
		_fail("keeper dock auto equipment merge button did not receive a generated icon")
		return
	var auto_equipment_badge := (auto_equipment_toggle as Button).get_node_or_null("Text_AutoEquipmentMergeBadge")
	if auto_equipment_badge == null or not auto_equipment_badge is Label or (auto_equipment_badge as Label).text != "OFF":
		_fail("auto equipment merge dock button should show OFF state")
		return

	var close_button := overlay.get_node_or_null("Section_WindowStack/Panel_PortalWindowFrame/Btn_PortalClose")
	if close_button == null or not close_button is Button:
		_fail("generated portal window has no close button")
		return
	if close_button.get_node_or_null("Icon_Close") == null:
		_fail("generated portal close button has no close icon")
		return
	if (close_button as Control).size.x < 40.0 or (close_button as Control).size.y < 40.0:
		_fail("generated portal close button is too small for the window chrome contract")
		return
	for minimize_path in [
		"Section_WindowStack/Panel_StatusWindowFrame/Btn_StatusMinimize",
		"Section_WindowStack/Panel_HeroInventoryWindowFrame/Btn_HeroInventoryMinimize",
		"Section_WindowStack/Panel_PortalWindowFrame/Btn_PortalMinimize",
	]:
		if _is_visible_control(overlay.get_node_or_null(minimize_path)):
			_fail("window title bar still shows a minimize/ellipsis button: %s" % minimize_path)
			return

	(close_button as Button).pressed.emit()
	for _i in range(6):
		await process_frame

	if (portal_frame as CanvasItem).visible:
		_fail("generated portal close button did not hide the portal window")
		return
	if not (hero_frame as CanvasItem).visible or not (status_frame as CanvasItem).visible:
		_fail("generated portal close button hid another window")
		return

	var title_label := overlay.get_node_or_null("Section_WindowStack/Panel_HeroInventoryWindowFrame/Text_HeroInventoryTitle")
	if title_label == null or not title_label is Label or (title_label as Label).text != "돌지기":
		_fail("generated overlay did not bind runtime text values")
		return

	var stone_tab := overlay.get_node_or_null("Section_WindowStack/Panel_HeroInventoryWindowFrame/Tabs_StoneEquipment/Btn_StoneTab")
	var equipment_tab := overlay.get_node_or_null("Section_WindowStack/Panel_HeroInventoryWindowFrame/Tabs_StoneEquipment/Btn_EquipmentTab")
	if stone_tab == null or not stone_tab is Button or not (stone_tab as Button).text.begins_with("돌"):
		_fail("stone inventory tab was not localized")
		return
	if equipment_tab == null or not equipment_tab is Button or not (equipment_tab as Button).text.begins_with("장비"):
		_fail("equipment tab was not localized")
		return
	var equipment_loadout_icon_count := _assert_equipment_loadout_icons(overlay)
	if equipment_loadout_icon_count < 6:
		_fail("equipment loadout should render six real equipment icons, got %d" % equipment_loadout_icon_count)
		return

	var action_bar := overlay.get_node_or_null("Section_WindowStack/Panel_HeroInventoryWindowFrame/RuntimeActionBar")
	var action_status := overlay.get_node_or_null("Section_WindowStack/Panel_HeroInventoryWindowFrame/Text_RuntimeActionStatus")
	if action_status == null or not action_status is Label:
		_fail("runtime action status label was not created")
		return
	if overlay.get_node_or_null("Section_BottomCombatStrip/Btn_AutoStoneMergeToggle") != null:
		_fail("auto stone merge toggle should not be created on the combat strip")
		return
	if _is_visible_control(action_bar):
		_fail("runtime MVP action button row should not be visible")
		return
	for action_button_path in [
		"Section_WindowStack/Panel_HeroInventoryWindowFrame/RuntimeActionBar/Btn_ActionFeed",
		"Section_WindowStack/Panel_HeroInventoryWindowFrame/RuntimeActionBar/Btn_ActionMerge",
		"Section_WindowStack/Panel_HeroInventoryWindowFrame/RuntimeActionBar/Btn_ActionSkill",
		"Section_WindowStack/Panel_HeroInventoryWindowFrame/RuntimeActionBar/Btn_ActionUpgrade",
	]:
		if _is_visible_control(overlay.get_node_or_null(action_button_path)):
			_fail("removed action button is still visible: %s" % action_button_path)
			return

	var first_stone_item_id := _first_stone_item_id(root_node.store)
	if first_stone_item_id <= 0:
		_fail("could not find a stone item for combat inventory reflection")
		return
	if not _probe_equipped_stone_loadout_after_merge(root_node):
		return
	for _i in range(4):
		await process_frame
	var initial_item_count := _snapshot_item_count(root_node.progression.inventory_snapshot())
	var initial_stone_slot_count := _count_inventory_slots_by_kind(overlay, "stone")
	root_node.sim._add_reward_item({"itemDataId": first_stone_item_id, "count": 1})
	root_node._refresh_generated_overlay_now()
	for _i in range(4):
		await process_frame
	if _snapshot_item_count(root_node.progression.inventory_snapshot()) <= initial_item_count:
		_fail("combat stone reward did not reach progression inventory")
		return
	if _count_inventory_slots_by_kind(overlay, "stone") <= initial_stone_slot_count:
		_fail("combat stone reward was not reflected in the visible inventory grid")
		return

	(equipment_tab as Button).pressed.emit()
	for _i in range(4):
		await process_frame
	if (equipment_tab as Button).text.find("/40") == -1:
		_fail("equipment tab did not show storage capacity")
		return
	var inventory_tabs := overlay.get_node_or_null("Section_WindowStack/Panel_HeroInventoryWindowFrame/Tabs_StoneEquipment")
	if inventory_tabs == null or not inventory_tabs is Control:
		_fail("stone/equipment tab panel is missing")
		return
	if (inventory_tabs as Control).size.x > 460.0 or (inventory_tabs as Control).size.y > 54.0:
		_fail("stone/equipment tab panel is too large for the compact inventory switcher: %s" % str((inventory_tabs as Control).size))
		return
	var compact_stone_tab := overlay.get_node_or_null("Section_WindowStack/Panel_HeroInventoryWindowFrame/Tabs_StoneEquipment/Btn_StoneTab")
	if compact_stone_tab == null or not compact_stone_tab is Button or (compact_stone_tab as Button).size.x < 190.0 or (compact_stone_tab as Button).size.y > 38.0:
		_fail("stone tab did not keep compact segmented sizing: %s" % (str((compact_stone_tab as Button).size) if compact_stone_tab is Button else "missing"))
		return
	var inventory_grid := overlay.get_node_or_null("Section_WindowStack/Panel_HeroInventoryWindowFrame/Grid_StoneInventory")
	if inventory_grid == null or not inventory_grid is GridContainer:
		_fail("equipment inventory grid is missing")
		return
	var inventory_well := overlay.get_node_or_null("Section_WindowStack/Panel_HeroInventoryWindowFrame/Panel_InventoryGridWell")
	if inventory_well == null or not inventory_well is Control:
		_fail("equipment inventory grid well is missing")
		return
	var grid_rect := (inventory_grid as Control).get_rect()
	var well_rect := (inventory_well as Control).get_rect()
	if grid_rect.position.x - well_rect.position.x < 8.0 or grid_rect.position.y - well_rect.position.y < 8.0:
		_fail("equipment inventory grid is too tight against the well border")
		return
	if well_rect.end.x - grid_rect.end.x < 8.0 or well_rect.end.y - grid_rect.end.y < 6.0:
		_fail("equipment inventory grid overflows the padded well")
		return
	if (inventory_grid as GridContainer).columns != 8:
		_fail("equipment inventory grid is not 8 columns")
		return
	if (inventory_grid as GridContainer).get_child_count() < 32:
		_fail("equipment inventory grid does not expose 32 visible slots")
		return
	var last_inventory_slot := (inventory_grid as GridContainer).get_child(31)
	if last_inventory_slot == null or not last_inventory_slot is Control:
		_fail("equipment inventory grid does not expose the 32nd slot")
		return
	if (last_inventory_slot as Control).position.x < 340.0 or (last_inventory_slot as Control).position.y < 145.0:
		_fail("equipment inventory grid did not lay out as 8x4")
		return
	var first_equipment_item_id := _first_equipment_item_id(root_node.store)
	if first_equipment_item_id <= 0:
		_fail("could not find equipment item for combat inventory reflection")
		return
	initial_item_count = _snapshot_item_count(root_node.progression.inventory_snapshot())
	var initial_equipment_slot_count := _count_inventory_slots_by_kind(overlay, "equipment")
	root_node.sim._add_reward_item({"itemDataId": first_equipment_item_id, "count": 1})
	root_node._refresh_generated_overlay_now()
	for _i in range(4):
		await process_frame
	if _snapshot_item_count(root_node.progression.inventory_snapshot()) <= initial_item_count:
		_fail("combat equipment reward did not reach progression inventory")
		return
	if _count_inventory_slots_by_kind(overlay, "equipment") <= initial_equipment_slot_count:
		_fail("combat equipment reward was not reflected in the visible inventory grid")
		return

	var first_inventory_slot := overlay.get_node_or_null("Section_WindowStack/Panel_HeroInventoryWindowFrame/Grid_StoneInventory/Panel_StoneSlotPrototype/Text_ItemName")
	if first_inventory_slot == null or not first_inventory_slot is Label:
		_fail("equipment tab did not expose the inventory body")
		return
	var first_equipment_text := (first_inventory_slot as Label).text
	if not ["투구", "갑옷", "장갑", "신발", "목걸", "반지", "장비"].has(first_equipment_text):
		_fail("equipment tab did not switch the inventory body")
		return
	var first_equipment_slot := overlay.get_node_or_null("Section_WindowStack/Panel_HeroInventoryWindowFrame/Grid_StoneInventory/Panel_StoneSlotPrototype")
	if first_equipment_slot == null or not first_equipment_slot is Control:
		_fail("first equipment inventory slot was not clickable")
		return
	if not _slot_has_texture_icon(first_equipment_slot as Control):
		_fail("first equipment inventory slot did not render an item texture icon")
		return
	_click_control(first_equipment_slot as Control)
	for _i in range(4):
		await process_frame
	if (action_status as Label).text.find("장비 선택") == -1:
		_fail("clicking an equipment slot did not select an equipment instance")
		return
	var equipment_detail := overlay.get_node_or_null("ModalHost/Modal_InventoryItemDetail")
	if equipment_detail == null or not equipment_detail is Control:
		_fail("clicking an equipment slot did not open the item detail modal")
		return
	if not _control_rect_is_close(equipment_detail as Control, Vector2(548.0, 126.0), Vector2(490.0, 430.0)):
		_fail("equipment detail modal compact rect mismatch: pos=%s size=%s" % [str((equipment_detail as Control).position), str((equipment_detail as Control).size)])
		return
	var equipment_detail_title := equipment_detail.get_node_or_null("Panel_ItemDetailTitleBar/Text_ItemDetailTitle")
	if equipment_detail_title == null or not equipment_detail_title is Label or (equipment_detail_title as Label).text != "아이템 상세 정보":
		_fail("equipment detail modal title is missing")
		return
	var equipment_detail_body := equipment_detail.get_node_or_null("Panel_ItemDetailBody")
	if equipment_detail_body == null or not equipment_detail_body is Control or not _control_rect_is_close(equipment_detail_body as Control, Vector2(28.0, 68.0), Vector2(434.0, 286.0)):
		_fail("equipment detail modal body does not use compact padding")
		return
	var equipment_detail_combat_strip := overlay.get_node_or_null("Section_BottomCombatStrip")
	if equipment_detail_combat_strip == null or not equipment_detail_combat_strip is CanvasItem or not (equipment_detail_combat_strip as CanvasItem).visible:
		_fail("taskbar combat strip is not visible while item detail modal is open")
		return
	if _is_visible_control(equipment_detail.get_node_or_null("Panel_ItemDetailTitleBar/Btn_ItemDetailMinimize")):
		_fail("equipment detail modal title bar still shows a minimize/ellipsis button")
		return
	var equipment_detail_equip_button := equipment_detail.get_node_or_null("Footer_ItemDetail/Btn_ItemDetailEquip")
	if equipment_detail_equip_button == null or not equipment_detail_equip_button is Button:
		_fail("equipment detail modal did not expose equip/unequip in the footer")
		return
	if not ["장착", "장착해제"].has((equipment_detail_equip_button as Button).text):
		_fail("equipment detail footer equip button has unexpected text: %s" % (equipment_detail_equip_button as Button).text)
		return
	var detail_upgrade_button := equipment_detail.get_node_or_null("Footer_ItemDetail/Btn_ItemDetailUpgrade")
	if detail_upgrade_button == null or not detail_upgrade_button is Button or (detail_upgrade_button as Button).disabled:
		_fail("equipment detail modal did not expose an enabled upgrade action")
		return
	var equipment_outline := (first_equipment_slot as Control).get_node_or_null("Panel_SelectedOutline")
	if equipment_outline == null or not equipment_outline is CanvasItem or not (equipment_outline as CanvasItem).visible:
		_fail("selected equipment slot did not show a selection outline")
		return
	var first_equipment_detail_instance := int((equipment_detail as Control).get_meta("runtime_item_detail_instance_id", 0))
	var inventory_grid_for_equipment := overlay.get_node_or_null("Section_WindowStack/Panel_HeroInventoryWindowFrame/Grid_StoneInventory")
	if inventory_grid_for_equipment == null or not inventory_grid_for_equipment is GridContainer or (inventory_grid_for_equipment as GridContainer).get_child_count() < 2:
		_fail("second equipment inventory slot was not available for detail refresh")
		return
	var second_equipment_slot := (inventory_grid_for_equipment as GridContainer).get_child(1)
	if second_equipment_slot == null or not second_equipment_slot is Control:
		_fail("second equipment inventory slot was not clickable")
		return
	_click_control(second_equipment_slot as Control)
	for _i in range(4):
		await process_frame
	equipment_detail = overlay.get_node_or_null("ModalHost/Modal_InventoryItemDetail")
	if equipment_detail == null or not equipment_detail is Control:
		_fail("clicking another equipment slot closed the item detail modal instead of refreshing it")
		return
	if int((equipment_detail as Control).get_meta("runtime_item_detail_instance_id", 0)) == first_equipment_detail_instance:
		_fail("clicking another equipment slot did not refresh the item detail modal")
		return
	_click_control(first_equipment_slot as Control)
	for _i in range(4):
		await process_frame
	equipment_detail = overlay.get_node_or_null("ModalHost/Modal_InventoryItemDetail")
	if equipment_detail == null or not equipment_detail is Control:
		_fail("clicking the first equipment slot did not refresh the item detail modal back to an upgradeable item")
		return
	if int((equipment_detail as Control).get_meta("runtime_item_detail_instance_id", 0)) != first_equipment_detail_instance:
		_fail("clicking the first equipment slot did not restore the original detail item")
		return
	detail_upgrade_button = equipment_detail.get_node_or_null("Footer_ItemDetail/Btn_ItemDetailUpgrade")
	if detail_upgrade_button == null or not detail_upgrade_button is Button or (detail_upgrade_button as Button).disabled:
		_fail("restored equipment detail modal did not expose an enabled upgrade action")
		return

	(detail_upgrade_button as Button).pressed.emit()
	for _i in range(4):
		await process_frame
	var upgrade_modal := overlay.get_node_or_null("ModalHost/Modal_EquipmentUpgrade")
	if upgrade_modal == null or not upgrade_modal is Control:
		_fail("equipment upgrade modal was not created")
		return
	if not _control_rect_is_close(upgrade_modal as Control, Vector2(574.0, 168.0), Vector2(438.0, 344.0)):
		_fail("equipment upgrade modal compact rect mismatch: pos=%s size=%s" % [str((upgrade_modal as Control).position), str((upgrade_modal as Control).size)])
		return
	var upgrade_body := upgrade_modal.get_node_or_null("Panel_EquipmentUpgradeBody")
	if upgrade_body == null or not upgrade_body is Control or not _control_rect_is_close(upgrade_body as Control, Vector2(28.0, 68.0), Vector2(382.0, 200.0)):
		_fail("equipment upgrade modal body does not use compact padding")
		return
	var combat_strip := overlay.get_node_or_null("Section_BottomCombatStrip")
	if combat_strip == null or not combat_strip is CanvasItem or not (combat_strip as CanvasItem).visible:
		_fail("taskbar combat strip is not visible while equipment upgrade modal is open")
		return
	var combat_strip_control := combat_strip as Control
	var combat_native_size: Vector2i = root_node._native_window_size_for("combat", combat_strip_control.size)
	var combat_native_scale: float = root_node._native_window_scale("combat")
	var combat_native_scale_vector: Vector2 = root_node._native_window_scale_vector("combat")
	if combat_strip_control.size.distance_to(root_node.COMBAT_NATIVE_CROP_SIZE) > 0.5:
		_fail("combat strip should crop unused sides without shrinking art, got size=%s expected=%s" % [str(combat_strip_control.size), str(root_node.COMBAT_NATIVE_CROP_SIZE)])
		return
	if absf(combat_native_scale_vector.x - combat_native_scale_vector.y) > 0.001:
		_fail("combat native window should not be horizontally squeezed, got scale vector %s" % str(combat_native_scale_vector))
		return
	var expected_combat_native_size := Vector2i(
		roundi(combat_strip_control.size.x * combat_native_scale_vector.x),
		roundi(combat_strip_control.size.y * combat_native_scale_vector.y)
	)
	if combat_native_size != expected_combat_native_size:
		_fail("combat native window should render at configured scale, got %s expected %s from strip.size=%s strip.scale=%s native.scale=%s native.scale.vector=%s" % [
			str(combat_native_size),
			str(expected_combat_native_size),
			str(combat_strip_control.size),
			str(combat_strip_control.scale),
			str(combat_native_scale),
			str(combat_native_scale_vector),
		])
		return
	var combat_resize_handle := overlay.get_node_or_null("Section_BottomCombatStrip/RuntimeCombatResizeHandle")
	if combat_resize_handle == null or not combat_resize_handle is Control:
		_fail("combat resize handle is missing")
		return
	if (combat_resize_handle as Control).mouse_filter != Control.MOUSE_FILTER_STOP:
		_fail("combat resize handle does not capture pointer input")
		return
	var opacity_control := overlay.get_node_or_null("Section_BottomCombatStrip/RuntimeCombatOpacityControl")
	if opacity_control == null or not opacity_control is Control:
		_fail("combat opacity control is missing")
		return
	var opacity_slider := opacity_control.get_node_or_null("Slider_CombatOpacity")
	if opacity_slider == null or not opacity_slider is HSlider:
		_fail("combat opacity slider is missing")
		return
	if (opacity_slider as HSlider).mouse_filter != Control.MOUSE_FILTER_STOP:
		_fail("combat opacity slider should capture pointer input")
		return
	var expected_opacity_position := Vector2((combat_strip_control as Control).size.x - (opacity_control as Control).size.x, 0.0)
	if (opacity_control as Control).position.distance_to(expected_opacity_position) > 0.5:
		_fail("combat opacity control should be pinned to top-right, got %s expected %s" % [str((opacity_control as Control).position), str(expected_opacity_position)])
		return
	var map_progress := overlay.get_node_or_null("Section_BottomCombatStrip/RuntimeCombatMapProgress")
	if map_progress == null or not map_progress is Control:
		_fail("combat map progress panel is missing")
		return
	var map_progress_control := map_progress as Control
	var expected_map_progress_position := Vector2(
		combat_strip_control.size.x - map_progress_control.size.x * map_progress_control.scale.x,
		combat_strip_control.size.y - map_progress_control.size.y * map_progress_control.scale.y
	)
	if map_progress_control.position.distance_to(expected_map_progress_position) > 0.5:
		_fail("combat map progress should be pinned to bottom-right, got %s expected %s" % [str(map_progress_control.position), str(expected_map_progress_position)])
		return
	var enemy_layer := overlay.get_node_or_null("Section_BottomCombatStrip/RuntimeEnemyLayer")
	if enemy_layer == null or not enemy_layer is CanvasItem:
		_fail("combat enemy layer is missing")
		return
	if (map_progress as CanvasItem).z_index <= (enemy_layer as CanvasItem).z_index:
		_fail("combat map progress should render above monsters, got map z=%d enemy z=%d" % [(map_progress as CanvasItem).z_index, (enemy_layer as CanvasItem).z_index])
		return
	if (map_progress as CanvasItem).z_index < root_node.COMBAT_MAP_PROGRESS_Z:
		_fail("combat map progress should use the HUD z-index, got %d expected at least %d" % [(map_progress as CanvasItem).z_index, root_node.COMBAT_MAP_PROGRESS_Z])
		return
	for enemy_child in (enemy_layer as Node).get_children():
		if not str(enemy_child.name).begins_with("RuntimeEnemy_") or not enemy_child is CanvasItem:
			continue
		if (map_progress as CanvasItem).z_index <= (enemy_child as CanvasItem).z_index:
			_fail("combat map progress should render above enemy sprites, got map z=%d enemy sprite %s z=%d" % [(map_progress as CanvasItem).z_index, str(enemy_child.name), (enemy_child as CanvasItem).z_index])
			return
	var combat_ground := overlay.get_node_or_null("Section_BottomCombatStrip/Tex_CombatGroundStrip")
	if combat_ground == null or not combat_ground is CanvasItem:
		_fail("combat ground underlay texture node is missing")
		return
	if not (combat_ground as CanvasItem).visible:
		_fail("combat background image should be visible inside the cropped strip")
		return
	if combat_ground is Control and ((combat_ground as Control).size.distance_to(combat_strip_control.size) > 0.5):
		_fail("combat background should cover the cropped strip, got %s expected %s" % [str((combat_ground as Control).size), str(combat_strip_control.size)])
		return
	if absf((combat_ground as CanvasItem).modulate.a - 1.0) > 0.04:
		_fail("combat background should default to fully visible, got alpha %s" % str((combat_ground as CanvasItem).modulate.a))
		return
	var combat_stage_badge := overlay.get_node_or_null("Section_BottomCombatStrip/Text_StageBadge")
	if combat_stage_badge == null or not combat_stage_badge is CanvasItem:
		_fail("combat opacity target stage badge is missing")
		return
	if absf(float(root_node.generated_combat_opacity) - 1.0) > 0.01:
		_fail("combat opacity should default to 100%% visible")
		return
	if absf((combat_stage_badge as CanvasItem).modulate.a - 1.0) > 0.04:
		_fail("combat elements should default to fully visible: %s" % str((combat_stage_badge as CanvasItem).modulate.a))
		return
	(opacity_slider as HSlider).value = 100.0
	for _i in range(2):
		await process_frame
	if absf(float(root_node.generated_combat_opacity) - 1.0) > 0.01:
		_fail("combat opacity slider signal did not map 100%% to full visibility")
		return
	root_node._set_generated_combat_opacity(0.55)
	for _i in range(2):
		await process_frame
	if absf(float(root_node.generated_combat_opacity) - 0.55) > 0.01:
		_fail("combat opacity value did not update")
		return
	if absf(float((opacity_slider as HSlider).value) - 55.0) > 0.1:
		_fail("combat opacity slider did not sync to 55%%, got %.1f%%" % float((opacity_slider as HSlider).value))
		return
	if absf((combat_stage_badge as CanvasItem).modulate.a - 0.55) > 0.04:
		_fail("combat element alpha did not follow opacity: %s" % str((combat_stage_badge as CanvasItem).modulate.a))
		return
	if not (combat_ground as CanvasItem).visible or absf((combat_ground as CanvasItem).modulate.a - 0.55) > 0.04:
		_fail("combat background image should follow element opacity while staying visible, got visible=%s alpha=%s" % [str((combat_ground as CanvasItem).visible), str((combat_ground as CanvasItem).modulate.a)])
		return
	if absf((opacity_control as CanvasItem).modulate.a - 1.0) > 0.01:
		_fail("combat opacity control should remain opaque")
		return
	root_node._set_generated_combat_opacity(1.0)
	var combat_reference_rect: Rect2 = root_node._native_reference_rect("combat", combat_strip_control)
	var expected_combat_position: Vector2 = root_node._combat_native_desktop_position(combat_strip_control.size)
	if combat_reference_rect.position.distance_to(expected_combat_position) > 0.1:
		_fail("combat native window should be centered above taskbar after configured scale, got %s expected %s" % [str(combat_reference_rect.position), str(expected_combat_position)])
		return
	var combat_native: Window = root_node._native_window_for_generated_control(combat_strip_control)
	var strip_start_position := Vector2(combat_native.position) if combat_native != null else combat_strip_control.position
	var drag_start_position := combat_strip_control.get_global_rect().position + Vector2(92.0, 42.0)
	var drag_end_position := drag_start_position + Vector2(46.0, -32.0)
	root_node._handle_generated_combat_strip_drag_input(_mouse_button(drag_start_position, true), combat_strip_control)
	root_node._handle_generated_combat_strip_drag_global_input(_mouse_motion(drag_end_position))
	root_node._handle_generated_combat_strip_drag_global_input(_mouse_button(drag_end_position, false))
	for _i in range(2):
		await process_frame
	var strip_current_position := Vector2(combat_native.position) if combat_native != null else combat_strip_control.position
	if strip_current_position.distance_to(strip_start_position + Vector2(46.0, -32.0)) > 0.5:
		_fail("dragging the combat strip body did not move the combat strip: start=%s current=%s expected=%s native=%s" % [
			str(strip_start_position),
			str(strip_current_position),
			str(strip_start_position + Vector2(46.0, -32.0)),
			str(combat_native != null),
		])
		return
	var strip_after_body_drag := strip_current_position
	var workshop_toggle := overlay.get_node_or_null("Section_BottomCombatStrip/Btn_RuntimeWorkshopToggle")
	if workshop_toggle == null or not workshop_toggle is Button:
		_fail("runtime workshop toggle button is missing from combat strip")
		return
	var button_drag_start := (workshop_toggle as Button).get_global_rect().get_center()
	var button_drag_end := button_drag_start + Vector2(-72.0, 18.0)
	root_node._handle_generated_combat_strip_drag_input(_mouse_button(button_drag_start, true), combat_strip_control)
	root_node._handle_generated_combat_strip_drag_global_input(_mouse_motion(button_drag_end))
	root_node._handle_generated_combat_strip_drag_global_input(_mouse_button(button_drag_end, false))
	for _i in range(2):
		await process_frame
	strip_current_position = Vector2(combat_native.position) if combat_native != null else combat_strip_control.position
	if strip_current_position.distance_to(strip_after_body_drag) > 0.5:
		_fail("dragging a combat strip button moved the combat strip")
		return
	var resize_start_scale: float = root_node.generated_combat_window_scale
	var resize_start_size: Vector2i = root_node._native_window_size_for("combat", combat_strip_control.size)
	var resize_start_position := (combat_resize_handle as Control).get_global_rect().get_center()
	var resize_end_position := resize_start_position + Vector2(240.0, 90.0)
	root_node._handle_generated_combat_strip_resize_input(_mouse_button(resize_start_position, true), combat_strip_control)
	root_node._handle_generated_combat_strip_resize_global_input(_mouse_motion(resize_end_position))
	root_node._handle_generated_combat_strip_resize_global_input(_mouse_button(resize_end_position, false))
	for _i in range(2):
		await process_frame
	var resize_end_scale: float = root_node.generated_combat_window_scale
	var resize_end_size: Vector2i = root_node._native_window_size_for("combat", combat_strip_control.size)
	var width_ratio := float(resize_end_size.x) / maxf(1.0, float(resize_start_size.x))
	var height_ratio := float(resize_end_size.y) / maxf(1.0, float(resize_start_size.y))
	if resize_end_scale <= resize_start_scale or resize_end_size.x <= resize_start_size.x or resize_end_size.y <= resize_start_size.y or absf(width_ratio - height_ratio) > 0.02:
		_fail("dragging the combat resize handle should resize width and height together: start_scale=%.3f end_scale=%.3f start_size=%s end_size=%s width_ratio=%.3f height_ratio=%.3f" % [
			resize_start_scale,
			resize_end_scale,
			str(resize_start_size),
			str(resize_end_size),
			width_ratio,
			height_ratio,
		])
		return
	var shrink_start_position := (combat_resize_handle as Control).get_global_rect().get_center()
	var shrink_end_position := shrink_start_position - Vector2(1800.0, 1800.0)
	root_node._handle_generated_combat_strip_resize_input(_mouse_button(shrink_start_position, true), combat_strip_control)
	root_node._handle_generated_combat_strip_resize_global_input(_mouse_motion(shrink_end_position))
	root_node._handle_generated_combat_strip_resize_global_input(_mouse_button(shrink_end_position, false))
	for _i in range(2):
		await process_frame
	var min_scale: float = root_node.COMBAT_NATIVE_WINDOW_MIN_SCALE
	var shrink_end_scale: float = root_node.generated_combat_window_scale
	if absf(shrink_end_scale - min_scale) > 0.001:
		_fail("combat resize did not clamp to minimum scale: got %.3f expected %.3f" % [shrink_end_scale, min_scale])
		return
	root_node._set_generated_combat_window_scale(0.5, combat_strip_control)
	if combat_native != null:
		combat_native.position = Vector2i(roundi(strip_start_position.x), roundi(strip_start_position.y))
	else:
		combat_strip_control.position = strip_start_position
	var modal_title := upgrade_modal.get_node_or_null("Panel_EquipmentUpgradeTitleBar/Text_EquipmentUpgradeTitle")
	if modal_title == null or not modal_title is Label or (modal_title as Label).text != "장비 승급":
		_fail("equipment upgrade modal has no desktop title bar")
		return
	if _is_visible_control(upgrade_modal.get_node_or_null("Panel_EquipmentUpgradeTitleBar/Btn_EquipmentUpgradeMinimize")):
		_fail("equipment upgrade modal title bar still shows a minimize/ellipsis button")
		return
	var source_1 := upgrade_modal.get_node_or_null("Panel_EquipmentUpgradeBody/Slot_UpgradeSource1/Text_ItemBadge")
	var source_2 := upgrade_modal.get_node_or_null("Panel_EquipmentUpgradeBody/Slot_UpgradeSource2/Text_ItemBadge")
	var source_3 := upgrade_modal.get_node_or_null("Panel_EquipmentUpgradeBody/Slot_UpgradeSource3/Text_ItemBadge")
	var result_slot := upgrade_modal.get_node_or_null("Panel_EquipmentUpgradeBody/Slot_UpgradeResult/Text_ItemBadge")
	if source_1 == null or source_2 == null or source_3 == null or result_slot == null:
		_fail("equipment upgrade modal did not render source/result slots")
		return
	if (source_1 as Label).text != "T1" or (source_2 as Label).text != "T1" or (source_3 as Label).text != "T1":
		_fail("equipment upgrade modal did not show three consumed T1 equipment slots")
		return
	if (result_slot as Label).text != "T2":
		_fail("equipment upgrade modal did not preview the higher tier result")
		return
	var confirm_button := upgrade_modal.get_node_or_null("Footer_EquipmentUpgrade/Btn_EquipmentUpgradeConfirm")
	if confirm_button == null or not confirm_button is Button or (confirm_button as Button).disabled:
		_fail("equipment upgrade modal confirm button is missing or disabled")
		return
	(confirm_button as Button).pressed.emit()
	for _i in range(6):
		await process_frame
	if overlay.get_node_or_null("ModalHost/Modal_EquipmentUpgrade") != null:
		_fail("equipment upgrade modal did not close after confirm")
		return
	if (action_status as Label).text.find("장비 승급") == -1:
		_fail("runtime action status did not update for equipment upgrade")
		return
	if (action_status as Label).text.find("완료") == -1:
		_fail("equipment upgrade confirm did not complete synthesis")
		return

	(stone_tab as Button).pressed.emit()
	for _i in range(4):
		await process_frame
	if (first_inventory_slot as Label).text != "조약":
		_fail("stone tab did not restore stone inventory mock data")
		return
	var first_stone_slot := overlay.get_node_or_null("Section_WindowStack/Panel_HeroInventoryWindowFrame/Grid_StoneInventory/Panel_StoneSlotPrototype")
	if first_stone_slot == null or not first_stone_slot is Control:
		_fail("first stone inventory slot was not clickable")
		return
	if not _slot_has_texture_icon(first_stone_slot as Control):
		_fail("first stone inventory slot did not render an item texture icon")
		return
	_click_control(first_stone_slot as Control)
	for _i in range(4):
		await process_frame
	var stone_detail := overlay.get_node_or_null("ModalHost/Modal_InventoryItemDetail")
	if stone_detail == null or not stone_detail is Control:
		var stone_data = (first_stone_slot as Control).get_meta("runtime_slot_data", {})
		var host := overlay.get_node_or_null("ModalHost")
		var host_children := []
		if host != null:
			for child in host.get_children():
				host_children.append(str(child.name))
		_fail("clicking a stone slot did not open the item detail modal: data=%s action_status=%s host_children=%s" % [str(stone_data), str((action_status as Label).text), str(host_children)])
		return
	if not _control_rect_is_close(stone_detail as Control, Vector2(548.0, 126.0), Vector2(490.0, 430.0)):
		_fail("stone detail modal compact rect mismatch: pos=%s size=%s" % [str((stone_detail as Control).position), str((stone_detail as Control).size)])
		return
	var stone_detail_combat_strip := overlay.get_node_or_null("Section_BottomCombatStrip")
	if stone_detail_combat_strip == null or not stone_detail_combat_strip is CanvasItem or not (stone_detail_combat_strip as CanvasItem).visible:
		_fail("taskbar combat strip is not visible while stone detail modal is open")
		return
	var stone_detail_title := stone_detail.get_node_or_null("Panel_ItemDetailTitleBar/Text_ItemDetailTitle")
	if stone_detail_title == null or not stone_detail_title is Label or (stone_detail_title as Label).text != "아이템 상세 정보":
		_fail("stone detail modal title is missing")
		return
	var stone_detail_name := stone_detail.get_node_or_null("Panel_ItemDetailBody/Text_ItemDetailName")
	if stone_detail_name == null or not stone_detail_name is Label:
		_fail("stone detail modal item name is missing")
		return
	var first_stone_detail_name := (stone_detail_name as Label).text
	var selected_stone_data = (first_stone_slot as Control).get_meta("runtime_slot_data", {})
	var selected_stone_item_id := int((selected_stone_data as Dictionary).get("item_data_id", 0)) if typeof(selected_stone_data) == TYPE_DICTIONARY else 0
	var second_stone_slot := _first_inventory_slot_by_kind_excluding_item(overlay, "stone", selected_stone_item_id)
	if second_stone_slot == null or not second_stone_slot is Control:
		_fail("different stone inventory slot was not available for detail refresh")
		return
	_click_control(second_stone_slot as Control)
	for _i in range(4):
		await process_frame
	stone_detail = overlay.get_node_or_null("ModalHost/Modal_InventoryItemDetail")
	if stone_detail == null or not stone_detail is Control:
		_fail("clicking another stone slot closed the item detail modal instead of refreshing it")
		return
	stone_detail_name = stone_detail.get_node_or_null("Panel_ItemDetailBody/Text_ItemDetailName")
	var second_data = (second_stone_slot as Control).get_meta("runtime_slot_data", {})
	var second_instance_id := int((second_data as Dictionary).get("instance_id", 0)) if typeof(second_data) == TYPE_DICTIONARY else 0
	if stone_detail_name == null or not stone_detail_name is Label or second_instance_id <= 0 or int(root_node.generated_selected_inventory_instance_id) != second_instance_id:
		_fail("clicking another stone slot did not refresh the selected item detail: first=%s current=%s second_data=%s selected_id=%d action_status=%s" % [
			first_stone_detail_name,
			str((stone_detail_name as Label).text) if stone_detail_name != null and stone_detail_name is Label else "<missing>",
			str(second_data),
			int(root_node.generated_selected_inventory_instance_id),
			str((action_status as Label).text),
		])
		return
	if _is_visible_control(stone_detail.get_node_or_null("Panel_ItemDetailTitleBar/Btn_ItemDetailMinimize")):
		_fail("stone detail modal title bar still shows a minimize/ellipsis button")
		return
	var stone_detail_hint := stone_detail.get_node_or_null("Panel_ItemDetailBody/Text_ItemDetailHint")
	if stone_detail_hint == null or not stone_detail_hint is Label:
		_fail("stone detail modal hint is missing")
		return
	if (stone_detail_hint as Label).text.find("장착") != -1:
		_fail("stone detail modal hint should not mention equip")
		return
	for line_index in range(5):
		var stone_detail_line := stone_detail.get_node_or_null("Panel_ItemDetailBody/Text_ItemDetailLine%d" % line_index)
		if stone_detail_line != null and stone_detail_line is Label and (stone_detail_line as Label).text.find("장착") != -1:
			_fail("stone detail modal stat lines should not mention equip")
			return
	var stone_detail_equip_button := stone_detail.get_node_or_null("Footer_ItemDetail/Btn_ItemDetailEquip")
	if stone_detail_equip_button != null:
		_fail("stone detail modal should not expose an equip action")
		return
	var stone_detail_merge_button := stone_detail.get_node_or_null("Footer_ItemDetail/Btn_ItemDetailMerge")
	if stone_detail_merge_button == null or not stone_detail_merge_button is Button:
		_fail("stone detail modal did not expose a merge action")
		return
	if not _inventory_slot_has_visible_selection(overlay, second_instance_id):
		_fail("selected stone slot did not show a selection outline")
		return
	var stone_detail_close_button := stone_detail.get_node_or_null("Footer_ItemDetail/Btn_ItemDetailCancel")
	if stone_detail_close_button == null or not stone_detail_close_button is Button:
		_fail("stone detail modal did not expose a close action")
		return
	(stone_detail_close_button as Button).pressed.emit()
	for _i in range(4):
		await process_frame

	var drag_source_data = (first_stone_slot as Control).get_meta("runtime_slot_data", {})
	if typeof(drag_source_data) != TYPE_DICTIONARY:
		_fail("first stone slot had no runtime drag data")
		return
	var source_item_id := int((drag_source_data as Dictionary).get("item_data_id", 0))
	var same_stone_slots := _inventory_slots_by_kind_and_item(overlay, "stone", source_item_id)
	if same_stone_slots.size() < 2:
		_fail("stone inventory did not expose two same-stone slots for drag merge")
		return
	var drag_source := same_stone_slots[0] as Control
	var drag_target := same_stone_slots[1] as Control
	var combat_was_running := false
	if root_node.sim != null:
		combat_was_running = bool(root_node.sim.running)
		root_node.sim.running = false
	var source_count_before := _count_progression_item_id(root_node.progression.inventory_snapshot(), source_item_id)
	var total_items_before := _snapshot_item_count(root_node.progression.inventory_snapshot())
	var drag_data = drag_source.get_meta("runtime_slot_data", {})
	if typeof(drag_data) != TYPE_DICTIONARY:
		_fail("drag source had no runtime slot data")
		return
	var source_center := drag_source.get_global_rect().get_center()
	var target_center := drag_target.get_global_rect().get_center()
	drag_source.emit_signal("gui_input", _mouse_button(source_center, true))
	for _i in range(2):
		await process_frame
	if overlay.get_node_or_null("ModalHost/Modal_InventoryItemDetail") != null:
		_fail("pressing a stone drag source opened the item detail modal before drag release")
		return
	drag_target.emit_signal("gui_input", _mouse_motion(source_center.lerp(target_center, 0.5)))
	drag_target.emit_signal("gui_input", _mouse_motion(target_center))
	drag_target.emit_signal("gui_input", _mouse_button(target_center, false))
	for _i in range(6):
		await process_frame
	if (action_status as Label).text.find("합성 완료") == -1:
		_fail("dragging a stone onto the same stone did not complete merge synthesis")
		return
	if _count_progression_item_id(root_node.progression.inventory_snapshot(), source_item_id) != source_count_before - 2:
		_fail("drag stone merge did not consume two source stones")
		return
	if _snapshot_item_count(root_node.progression.inventory_snapshot()) != total_items_before - 1:
		_fail("drag stone merge did not replace two stones with one higher stone")
		return
	if root_node.sim != null:
		root_node.sim.running = combat_was_running

	root_node.progression.add_item_instance(source_item_id)
	root_node.progression.add_item_instance(source_item_id)
	root_node._refresh_generated_overlay_now()
	for _i in range(4):
		await process_frame
	var auto_merge_combat_was_running := false
	if root_node.sim != null:
		auto_merge_combat_was_running = bool(root_node.sim.running)
		root_node.sim.running = false
	var auto_count_before := _count_progression_item_id(root_node.progression.inventory_snapshot(), source_item_id)
	var auto_total_before := _snapshot_item_count(root_node.progression.inventory_snapshot())
	(auto_merge_toggle as Button).toggled.emit(true)
	for _i in range(8):
		await process_frame
	if not bool(root_node.generated_auto_stone_merge_enabled):
		_fail("auto stone merge toggle did not enable runtime auto merge")
		return
	if not (auto_merge_toggle as Button).button_pressed:
		_fail("auto stone merge dock button did not stay pressed")
		return
	if (auto_merge_badge as Label).text != "ON":
		_fail("auto stone merge dock button did not show ON state")
		return
	if _count_progression_item_id(root_node.progression.inventory_snapshot(), source_item_id) > auto_count_before - 2:
		_fail("auto stone merge did not consume a two-stone pair")
		return
	if _snapshot_item_count(root_node.progression.inventory_snapshot()) >= auto_total_before:
		_fail("auto stone merge did not replace a pair with a higher stone")
		return
	root_node._set_generated_auto_stone_merge_enabled(false)
	for _i in range(2):
		await process_frame

	for _i in range(3):
		root_node.progression.add_item_instance(first_equipment_item_id)
	root_node._refresh_generated_overlay_now()
	for _i in range(4):
		await process_frame
	var auto_equipment_count_before := _count_progression_item_id(root_node.progression.inventory_snapshot(), first_equipment_item_id)
	var auto_equipment_total_before := _snapshot_item_count(root_node.progression.inventory_snapshot())
	(auto_equipment_toggle as Button).toggled.emit(true)
	for _i in range(8):
		await process_frame
	if not bool(root_node.generated_auto_equipment_merge_enabled):
		_fail("auto equipment merge toggle did not enable runtime auto merge")
		return
	if not (auto_equipment_toggle as Button).button_pressed:
		_fail("auto equipment merge dock button did not stay pressed")
		return
	if (auto_equipment_badge as Label).text != "ON":
		_fail("auto equipment merge dock button did not show ON state")
		return
	if _count_progression_item_id(root_node.progression.inventory_snapshot(), first_equipment_item_id) > auto_equipment_count_before - 3:
		_fail("auto equipment merge did not consume a three-equipment set")
		return
	if _snapshot_item_count(root_node.progression.inventory_snapshot()) > auto_equipment_total_before - 2:
		_fail("auto equipment merge did not replace three equipment pieces with one higher equipment")
		return
	root_node._set_generated_auto_equipment_merge_enabled(false)
	for _i in range(2):
		await process_frame
	if root_node.sim != null:
		root_node.sim.running = auto_merge_combat_was_running

	var combat_layer := overlay.get_node_or_null("Section_BottomCombatStrip/RuntimeCombatLayer")
	if combat_layer == null:
		_fail("runtime combat layer was not created")
		return

	var saw_attack := false
	var saw_skill := false
	var saw_drop := false
	var saw_drop_label := false
	for _i in range(1200):
		await process_frame
		var snapshot: Dictionary = root_node.sim.snapshot()
		for event_text in snapshot.get("events", []):
			if str(event_text).find("돌팔매") != -1:
				saw_attack = true
		var fx_events = snapshot.get("fx_events", [])
		if typeof(fx_events) == TYPE_ARRAY:
			for fx_event in fx_events:
				if typeof(fx_event) == TYPE_DICTIONARY and str(fx_event.get("kind", "")) == "attack":
					saw_attack = true
		if int(snapshot.get("skill_cast_count", 0)) > 0:
			saw_skill = true
		var drop_events = snapshot.get("drop_events", [])
		if typeof(drop_events) == TYPE_ARRAY and drop_events.size() > 0:
			saw_drop = true
		if _combat_layer_has_visible_drop_label(combat_layer as Control):
			saw_drop_label = true
		if saw_attack and saw_skill and saw_drop and saw_drop_label:
			break

	if not saw_attack:
		_fail("combat attack event did not occur")
		return
	if not saw_skill:
		_fail("monster skill feedback event did not occur")
		return
	if not saw_drop:
		_fail("drop event did not occur")
		return
	if not saw_drop_label:
		_fail("drop event occurred but no visible drop label was rendered inside the combat layer")
		return

	var toast_title := overlay.get_node_or_null("Section_BottomCombatStrip/Panel_RareDropToast/Text_RareDropTitle")
	var toast_body := overlay.get_node_or_null("Section_BottomCombatStrip/Panel_RareDropToast/Text_RareDropBody")
	if toast_title == null or not toast_title is Label or (toast_title as Label).text == "전리품 대기":
		_fail("drop toast title was not updated from combat drops")
		return
	if toast_body == null or not toast_body is Label or (toast_body as Label).text.find("획득") == -1:
		_fail("drop toast body did not show Korean acquisition feedback")
		return

	print("full ui overlay smoke ok")
	quit(0)


func _fail(message: String) -> void:
	push_error(message)
	quit(1)


func _combat_layer_has_visible_drop_label(layer: Control) -> bool:
	var layer_width := float(layer.size.x)
	for child in layer.get_children():
		if child == null or not child is Label:
			continue
		var label := child as Label
		if not label.visible or label.text.begins_with("+") == false:
			continue
		if label.position.x < 0.0:
			continue
		if layer_width > 0.0 and label.position.x + label.size.x > layer_width + 1.0:
			continue
		return true
	return false


func _click_control(control: Control) -> void:
	var center := control.get_global_rect().get_center()
	control.emit_signal("gui_input", _mouse_button(center, true))
	control.emit_signal("gui_input", _mouse_button(center, false))


func _is_visible_control(node: Node) -> bool:
	return node != null and node is CanvasItem and (node as CanvasItem).visible


func _control_visual_rect(control: Control) -> Rect2:
	return Rect2(control.position, control.size * control.scale)


func _control_rect_is_close(control: Control, expected_position: Vector2, expected_size: Vector2, tolerance: float = 0.5) -> bool:
	return control.position.distance_to(expected_position) <= tolerance and control.size.distance_to(expected_size) <= tolerance


func _mouse_button(global_position: Vector2, pressed: bool) -> InputEventMouseButton:
	var event := InputEventMouseButton.new()
	event.button_index = MOUSE_BUTTON_LEFT
	event.pressed = pressed
	event.global_position = global_position
	event.position = global_position
	return event


func _mouse_motion(global_position: Vector2) -> InputEventMouseMotion:
	var event := InputEventMouseMotion.new()
	event.global_position = global_position
	event.position = global_position
	return event


func _snapshot_item_count(snapshot: Dictionary) -> int:
	var items = snapshot.get("items", [])
	return items.size() if typeof(items) == TYPE_ARRAY else 0


func _count_inventory_slots_by_kind(overlay: Node, kind: String) -> int:
	var grid := overlay.get_node_or_null("Section_WindowStack/Panel_HeroInventoryWindowFrame/Grid_StoneInventory")
	if grid == null:
		return -1
	var total := 0
	for child in grid.get_children():
		if not child is Control:
			continue
		var raw_data = (child as Control).get_meta("runtime_slot_data", {})
		if typeof(raw_data) != TYPE_DICTIONARY:
			continue
		var data: Dictionary = raw_data
		if str(data.get("kind", "")) == kind and int(data.get("instance_id", 0)) > 0:
			total += 1
	return total


func _slot_has_texture_icon(slot: Control) -> bool:
	var texture_node := slot.get_node_or_null("Panel_ItemIconMark/Tex_ItemIcon")
	return texture_node != null and texture_node is TextureRect and (texture_node as TextureRect).visible and (texture_node as TextureRect).texture != null


func _assert_equipment_loadout_icons(overlay: Node) -> int:
	var total := 0
	for path in [
		"Section_WindowStack/Panel_HeroInventoryWindowFrame/Grid_EquipmentSlotsLeft",
		"Section_WindowStack/Panel_HeroInventoryWindowFrame/Grid_EquipmentSlotsRight",
	]:
		var grid := overlay.get_node_or_null(path)
		if grid == null or not grid is GridContainer:
			_fail("equipment loadout grid is missing: %s" % path)
			return total
		for child in (grid as GridContainer).get_children():
			if not child is Control:
				continue
			var raw_data = (child as Control).get_meta("runtime_slot_data", {})
			if typeof(raw_data) != TYPE_DICTIONARY:
				continue
			var data: Dictionary = raw_data
			if str(data.get("kind", "")) != "equipment" or int(data.get("item_data_id", 0)) <= 0:
				continue
			var icon_path := str(data.get("icon_path", ""))
			if icon_path.find("equipment/imagegen/icons") == -1:
				_fail("equipment loadout did not bind its Items.json spriteGroups.Icon path: %s" % str(data))
				return total
			if not _slot_has_texture_icon(child as Control):
				_fail("equipment loadout slot did not render its item texture: %s" % str(data))
				return total
			var texture_node := (child as Control).get_node_or_null("Panel_ItemIconMark/Tex_ItemIcon")
			var texture: Texture2D = (texture_node as TextureRect).texture
			if texture.get_width() < 64 or texture.get_height() < 64:
				_fail("equipment loadout rendered a low-resolution fallback icon instead of the generated item art: %s" % str(data))
				return total
			total += 1
	return total


func _inventory_slots_by_kind_and_item(overlay: Node, kind: String, item_id: int) -> Array:
	var slots := []
	var grid := overlay.get_node_or_null("Section_WindowStack/Panel_HeroInventoryWindowFrame/Grid_StoneInventory")
	if grid == null:
		return slots
	for child in grid.get_children():
		if not child is Control:
			continue
		var raw_data = (child as Control).get_meta("runtime_slot_data", {})
		if typeof(raw_data) != TYPE_DICTIONARY:
			continue
		var data: Dictionary = raw_data
		if str(data.get("kind", "")) == kind and int(data.get("item_data_id", 0)) == item_id and int(data.get("instance_id", 0)) > 0:
			slots.append(child)
	return slots


func _first_inventory_slot_by_kind_excluding_item(overlay: Node, kind: String, excluded_item_id: int) -> Control:
	var grid := overlay.get_node_or_null("Section_WindowStack/Panel_HeroInventoryWindowFrame/Grid_StoneInventory")
	if grid == null:
		return null
	for child in grid.get_children():
		if not child is Control:
			continue
		var raw_data = (child as Control).get_meta("runtime_slot_data", {})
		if typeof(raw_data) != TYPE_DICTIONARY:
			continue
		var data: Dictionary = raw_data
		if str(data.get("kind", "")) == kind and int(data.get("item_data_id", 0)) != excluded_item_id and int(data.get("instance_id", 0)) > 0:
			return child as Control
	return null


func _inventory_slot_has_visible_selection(overlay: Node, instance_id: int) -> bool:
	var grid := overlay.get_node_or_null("Section_WindowStack/Panel_HeroInventoryWindowFrame/Grid_StoneInventory")
	if grid == null:
		return false
	for child in grid.get_children():
		if not child is Control:
			continue
		var raw_data = (child as Control).get_meta("runtime_slot_data", {})
		if typeof(raw_data) != TYPE_DICTIONARY:
			continue
		var data: Dictionary = raw_data
		if int(data.get("instance_id", 0)) != instance_id:
			continue
		var outline := (child as Control).get_node_or_null("Panel_SelectedOutline")
		return outline != null and outline is CanvasItem and (outline as CanvasItem).visible
	return false


func _count_progression_item_id(snapshot: Dictionary, item_id: int) -> int:
	var total := 0
	var items = snapshot.get("items", [])
	if typeof(items) != TYPE_ARRAY:
		return total
	for instance in items:
		if typeof(instance) == TYPE_DICTIONARY and int(instance.get("item_data_id", 0)) == item_id:
			total += 1
	return total


func _probe_equipped_stone_loadout_after_merge(root_node: Node) -> bool:
	if root_node.progression == null or root_node.sim == null:
		_fail("progression or combat sim is missing for stone loadout probe")
		return false
	root_node.progression.reset()
	root_node.progression.set_seed(20260629)
	var low_ids := []
	for _i in range(3):
		var added: Dictionary = root_node.progression.add_item_instance(200202)
		if not bool(added.get("ok", false)):
			_fail("stone loadout probe could not add source stone")
			return false
		low_ids.append(int(added.get("instance", {}).get("instance_id", 0)))
	for item_id in [200203, 200204, 200205]:
		var added_high: Dictionary = root_node.progression.add_item_instance(int(item_id))
		if not bool(added_high.get("ok", false)):
			_fail("stone loadout probe could not add higher stone")
			return false
	root_node.progression.auto_equip_best_stones()
	var result: Dictionary = root_node.progression.synthesize_stones(low_ids.slice(0, 2))
	if not bool(result.get("ok", false)):
		_fail("stone loadout probe merge failed: %s" % str(result))
		return false
	root_node._apply_progression_loadout_to_sim()
	var sim_snapshot: Dictionary = root_node.sim.snapshot()
	var stone_skill_ids: Array = sim_snapshot.get("player_stone_skill_ids", [])
	if stone_skill_ids.has(300102):
		_fail("combat loadout included an unequipped source stone skill after merge")
		return false
	if int(sim_snapshot.get("player_stone_count", 0)) != 3:
		_fail("combat loadout should use exactly the equipped stone slots after merge")
		return false
	var progression_snapshot: Dictionary = root_node.progression.inventory_snapshot()
	var equipped_ids: Array = progression_snapshot.get("equipped_stone_instance_ids", [])
	for consumed_id in low_ids.slice(0, 2):
		if equipped_ids.has(consumed_id):
			_fail("consumed stone instance remained in equipped slot after merge")
			return false
	root_node._bootstrap_progression_state()
	root_node._refresh_generated_overlay_now()
	return true


func _first_stone_item_id(store) -> int:
	for item in store.get_records("Items"):
		if typeof(item) != TYPE_DICTIONARY:
			continue
		var tags = item.get("tags", [])
		if typeof(tags) == TYPE_ARRAY and tags.has("StoneWeapon"):
			return int(item.get("id", 0))
	return 0


func _first_equipment_item_id(store) -> int:
	for item in store.get_records("Items"):
		if typeof(item) != TYPE_DICTIONARY:
			continue
		if str(item.get("category", "")) == "Equipment" and str(item.get("type", "")) == "Head" and int(item.get("grade", 0)) == 1:
			return int(item.get("id", 0))
	for item in store.get_records("Items"):
		if typeof(item) == TYPE_DICTIONARY and str(item.get("category", "")) == "Equipment":
			return int(item.get("id", 0))
	return 0
