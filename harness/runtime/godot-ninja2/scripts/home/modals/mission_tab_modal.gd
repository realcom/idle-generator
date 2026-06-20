extends "res://scripts/home/modals/tab_modal_base.gd"

var first_claimable_id := 0


func setup(content_store, housing_store, sanctuary_state, texture_table: Dictionary) -> void:
	setup_context(content_store, housing_store, sanctuary_state, texture_table, "임무", "진행도 · 보상 수령", Vector2(390, 550))
	sync_state()


func sync_state() -> void:
	if store == null or sanctuary == null:
		return
	setup_frame("임무", "진행도 · 보상 수령", size)
	clear_body()
	first_claimable_id = 0
	var entries: Array = _mission_entries()
	var summary: Dictionary = _mission_summary(entries)
	_render_summary(summary)
	_render_entries(entries)
	set_secondary_action("닫기", "close")
	set_primary_action("받을 보상" if first_claimable_id > 0 else "진행 중", "claim-first", first_claimable_id <= 0)


func _on_frame_action_requested(action: String) -> void:
	if action == "claim-first" and first_claimable_id > 0:
		modal_action_requested.emit("claim_mission", {"achievement_id": first_claimable_id})
		return
	super._on_frame_action_requested(action)


func _render_summary(summary: Dictionary) -> void:
	var panel := _add_panel(body, Vector2(0, 0), Vector2(body.size.x, 66), Color(0.95, 0.82, 0.60, 0.94), Color(0.25, 0.16, 0.08, 0.70), 9)
	_add_icon(panel, "home_tab_mission", Vector2(12, 11), Vector2(42, 42), "M")
	_add_label(panel, Vector2(66, 10), Vector2(150, 20), "오늘의 임무", 15, Color(0.13, 0.08, 0.04))
	_add_label(panel, Vector2(66, 34), Vector2(200, 16), "수령 가능 %d · 완료 %d/%d" % [int(summary.get("claimable", 0)), int(summary.get("claimed", 0)), int(summary.get("total", 0))], 10, Color(0.30, 0.20, 0.11))
	_add_label(panel, Vector2(body.size.x - 96, 22), Vector2(82, 20), "HomeUI", 12, Color(0.18, 0.36, 0.18), HORIZONTAL_ALIGNMENT_CENTER)


func _render_entries(entries: Array) -> void:
	var y := 82.0
	var rendered := 0
	for achievement in entries:
		if typeof(achievement) != TYPE_DICTIONARY:
			continue
		if rendered >= 6:
			break
		_render_mission_row(achievement, y)
		y += 54.0
		rendered += 1
	if rendered == 0:
		_add_label(body, Vector2(0, 122), Vector2(body.size.x, 50), "등록된 홈 임무가 없습니다.", 12, Color(0.28, 0.19, 0.10), HORIZONTAL_ALIGNMENT_CENTER, VERTICAL_ALIGNMENT_CENTER)


func _render_mission_row(achievement: Dictionary, y: float) -> void:
	var progress_info: Dictionary = sanctuary.mission_progress(achievement)
	var achievement_id := int(achievement.get("id", 0))
	var key: String = sanctuary.mission_key(achievement)
	var claimed: bool = bool(sanctuary.claimed_mission_keys.get(key, false))
	var complete: bool = bool(progress_info.get("complete", false))
	var claimable: bool = complete and not claimed
	if claimable and first_claimable_id <= 0:
		first_claimable_id = achievement_id

	var row := _add_panel(body, Vector2(0, y), Vector2(body.size.x, 50), Color(0.23, 0.15, 0.08, 0.91), Color(0.78, 0.60, 0.32, 0.72), 8)
	_add_icon(row, _mission_icon(achievement), Vector2(8, 7), Vector2(32, 32), "!")
	_add_label(row, Vector2(48, 5), Vector2(150, 17), str(achievement.get("name", "임무")), 12, Color(1.0, 0.91, 0.70))
	_add_label(row, Vector2(48, 22), Vector2(170, 10), _mission_detail(achievement), 8, Color(0.82, 0.74, 0.56))
	var progress := int(progress_info.get("progress", 0))
	var target := int(progress_info.get("target", 1))
	_add_label(row, Vector2(218, 6), Vector2(48, 13), "%d/%d" % [progress, target], 9, Color(1.0, 0.88, 0.58), HORIZONTAL_ALIGNMENT_CENTER)
	_add_progress(row, Vector2(218, 23), Vector2(48, 6), float(progress) / max(1.0, float(target)), Color(0.36, 0.80, 0.54))
	_add_reward_chips(row, Vector2(48, 35), _reward_summary(achievement))
	var button_text := "완료" if claimed else ("받기" if claimable else "진행")
	_add_action_button(row, Vector2(body.size.x - 58, 9), Vector2(48, 28), button_text, "claim_mission", {"achievement_id": achievement_id}, not claimable)


func _mission_entries() -> Array:
	var entries := []
	for achievement in store.get_records("Achievements"):
		if typeof(achievement) != TYPE_DICTIONARY:
			continue
		if str(achievement.get("type", "")) != "Mission":
			continue
		var tags = achievement.get("tags", [])
		var popup_args = achievement.get("popupArgs", {})
		var is_home := false
		if typeof(tags) == TYPE_ARRAY:
			is_home = tags.has("HomeUI")
		if typeof(popup_args) == TYPE_DICTIONARY and str(popup_args.get("MissionGroup", "")) != "":
			is_home = true
		if is_home:
			entries.append(achievement)
	entries.sort_custom(func(a, b): return int(a.get("order", a.get("id", 0))) < int(b.get("order", b.get("id", 0))))
	return entries


func _add_reward_chips(parent: Control, chip_position: Vector2, text: String) -> void:
	_add_label(parent, chip_position, Vector2(158, 12), text, 7, Color(0.76, 1.0, 0.58))


func _mission_summary(entries: Array) -> Dictionary:
	var claimable := 0
	var claimed := 0
	for achievement in entries:
		if typeof(achievement) != TYPE_DICTIONARY:
			continue
		var key: String = sanctuary.mission_key(achievement)
		var progress_info: Dictionary = sanctuary.mission_progress(achievement)
		if bool(sanctuary.claimed_mission_keys.get(key, false)):
			claimed += 1
		elif bool(progress_info.get("complete", false)):
			claimable += 1
	return {"claimable": claimable, "claimed": claimed, "total": entries.size()}


func _mission_icon(achievement: Dictionary) -> String:
	var popup_args = achievement.get("popupArgs", {})
	var group := ""
	if typeof(popup_args) == TYPE_DICTIONARY:
		group = str(popup_args.get("MissionGroup", ""))
	match group:
		"stage_clear":
			return "home_tab_exploration"
		"side_dungeon":
			return "dungeon_stone"
		"building":
			return "home_tab_sanctuary"
		"currency":
			return "home_icon_collect"
	return "home_tab_mission"


func _mission_detail(achievement: Dictionary) -> String:
	var condition := str(achievement.get("condition", ""))
	var value1 := int(achievement.get("conditionValue1", 0))
	if condition == "WinGame":
		var map_def: Dictionary = store.get_map(value1)
		return "%s 정화" % str(map_def.get("name", "맵"))
	if condition == "AcquireItem":
		var item: Dictionary = store.get_item(value1)
		return "%s 수집" % str(item.get("name", "아이템"))
	if condition == "BuyItemProduct":
		var product: Dictionary = store.get_item(value1)
		return "%s 구매" % str(product.get("name", "상품"))
	return "진행 조건 확인"


func _reward_summary(achievement: Dictionary) -> String:
	var groups = achievement.get("rewardAddItemGroups", [])
	if typeof(groups) != TYPE_ARRAY:
		return "보상 없음"
	var labels: Array[String] = []
	for group in groups:
		if typeof(group) != TYPE_DICTIONARY:
			continue
		var add_items = group.get("addItems", [])
		if typeof(add_items) != TYPE_ARRAY:
			continue
		for reward in add_items:
			if typeof(reward) != TYPE_DICTIONARY:
				continue
			var item_id := int(reward.get("itemDataId", 0))
			var amount := int(float(str(reward.get("count", "0"))))
			labels.append("%s +%s" % [_reward_name(item_id), _format_number(amount)])
			if labels.size() >= 2:
				return " · ".join(labels)
	return " · ".join(labels) if not labels.is_empty() else "보상 없음"


func _reward_name(item_id: int) -> String:
	match int(item_id):
		3:
			return "루비"
		4:
			return "무료 루비"
		5:
			return "골드"
		8:
			return "에너지"
		200101:
			return "목재"
		200102:
			return "석재"
		200103:
			return "영혼불"
		200111:
			return "동료 조각"
	var item: Dictionary = store.get_item(item_id)
	return str(item.get("name", "아이템"))
