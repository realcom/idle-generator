extends "res://scripts/home/modals/tab_modal_base.gd"

const VALID_VIEWS := ["mail", "bag", "pass"]
const RESOURCE_KEYS := ["wood", "soul", "gold", "stone", "energy", "companion_shards"]
const MAIL_DEFS := [
	{
		"key": "founder_supply",
		"sender": "성소 관리인",
		"title": "성소 개방 보급",
		"detail": "첫 성소 건설을 위한 목재와 출격 에너지가 도착했습니다.",
		"icon": "mail",
		"expires": 14,
		"available": {},
		"reward": {"wood": 120, "gold": 800, "energy": 20},
	},
	{
		"key": "first_sortie_report",
		"sender": "정찰소",
		"title": "첫 정화 보고",
		"detail": "첫 원정 기록 확인 완료. 영혼불과 석재를 보급합니다.",
		"icon": "exploration",
		"expires": 7,
		"available": {"minStageClears": 1},
		"reward": {"souls": 8, "stone": 30},
	},
	{
		"key": "training_yard_open",
		"sender": "용병 훈련소",
		"title": "훈련소 개방 축하",
		"detail": "동료 모집을 시작할 수 있습니다. 초도 모집 조각을 지급합니다.",
		"icon": "companions",
		"expires": 10,
		"available": {"buildingBuilt": "training_yard"},
		"reward": {"companion_shards": 6, "companion_exp": 80},
	},
	{
		"key": "sanctuary_level_3",
		"sender": "등불 신전",
		"title": "성소 3단계 기록",
		"detail": "등불이 안정화되었습니다. 다음 확장을 위한 보급을 확인하세요.",
		"icon": "sanctuary",
		"expires": 10,
		"available": {"minShrineLevel": 3},
		"reward": {"light": 80, "souls": 10},
	},
	{
		"key": "city_preview_notice",
		"sender": "마을 주민",
		"title": "도시 프리뷰 점검",
		"detail": "하네스 도시 fixture에서 우편함 읽음 상태를 확인하는 공지입니다.",
		"icon": "population",
		"expires": 30,
		"available": {"minStageClears": 3},
		"reward": {},
	},
]
const PASS_TIERS := [
	{"key": "stage_1", "title": "대나무 영지 개방", "icon": "exploration", "metric": "stageClears", "target": 1, "reward": {"wood": 80, "souls": 5}},
	{"key": "stage_3", "title": "안개숲 진입", "icon": "stone", "metric": "stageClears", "target": 3, "reward": {"stone": 70, "gold": 260}},
	{"key": "shrine_3", "title": "성소 기반 확장", "icon": "sanctuary", "metric": "shrineLevel", "target": 3, "reward": {"light": 90, "souls": 8}},
	{"key": "companions_2", "title": "동료 작전조", "icon": "companions", "metric": "companions", "target": 2, "reward": {"companion_exp": 120, "companion_shards": 5}},
]

var view_key := "mail"


func setup(content_store, housing_store, sanctuary_state, texture_table: Dictionary, requested_view_key := "mail") -> void:
	view_key = str(requested_view_key)
	if not VALID_VIEWS.has(view_key):
		view_key = "mail"
	setup_context(content_store, housing_store, sanctuary_state, texture_table, _view_title(), _view_subtitle(), Vector2(390, 530))
	sync_state()


func sync_state() -> void:
	if sanctuary == null or body == null:
		return
	title_label.text = _view_title()
	subtitle_label.text = _view_subtitle()
	clear_body()
	match view_key:
		"bag":
			_render_bag()
			set_primary_action("생산 수집", "collect-all", _production_empty())
		"pass":
			_render_pass()
			set_primary_action("받을 보상", "claim-first-pass", _first_claimable_pass_key() == "")
		_:
			_render_mail()
			set_primary_action("모두 받기", "claim-all-mail", _first_claimable_mail_key() == "")
	set_secondary_action("닫기", "close")


func _on_frame_action_requested(action: String) -> void:
	match action:
		"claim-all-mail":
			_claim_all_mail()
		"collect-all":
			_collect_all()
		"claim-first-pass":
			_claim_pass(_first_claimable_pass_key())
		_:
			modal_action_requested.emit(action, {})


func _render_mail() -> void:
	var entries := _mail_entries()
	var summary := _mail_summary(entries)
	_add_label(body, Vector2(0, 0), Vector2(260, 18), _mail_summary_label(summary), 11, Color(0.24, 0.15, 0.08))
	_add_label(body, Vector2(266, 0), Vector2(92, 18), "%d통" % int(summary.get("total", 0)), 11, Color(0.48, 0.27, 0.10), HORIZONTAL_ALIGNMENT_RIGHT)
	if entries.is_empty():
		_render_empty("우편 없음", "새 알림이나 보급이 도착하면 여기에 표시됩니다.")
		return

	var y := 24.0
	for entry in entries:
		_render_mail_row(entry, y)
		y += 64.0


func _render_mail_row(entry: Dictionary, row_y: float) -> void:
	var status := str(entry.get("status", "unread"))
	var fill := Color(0.26, 0.18, 0.10, 0.90)
	if status == "claimable":
		fill = Color(0.34, 0.22, 0.08, 0.94)
	elif status == "claimed":
		fill = Color(0.17, 0.15, 0.12, 0.84)
	var row := _add_panel(body, Vector2(0, row_y), Vector2(358, 58), fill, Color(0.70, 0.52, 0.30, 0.58), 8)
	_add_icon(row, _feature_icon_key(str(entry.get("icon", "mail"))), Vector2(8, 10), Vector2(32, 32), "!")
	_add_label(row, Vector2(48, 6), Vector2(182, 16), str(entry.get("title", "우편")), 12, Color(1.0, 0.91, 0.66))
	_add_label(row, Vector2(232, 7), Vector2(58, 14), str(entry.get("sender", "")), 9, Color(0.76, 0.66, 0.48), HORIZONTAL_ALIGNMENT_RIGHT)
	_add_label(row, Vector2(48, 23), Vector2(210, 16), str(entry.get("detail", "")), 9, Color(0.92, 0.82, 0.62))
	_add_label(row, Vector2(48, 40), Vector2(196, 14), _reward_bundle_label(entry.get("reward", {})), 9, Color(0.74, 0.96, 0.70))
	var mail_key := str(entry.get("key", ""))
	var disabled := status == "claimed" or status == "read"
	var label := "완료" if status == "claimed" else "받기" if status == "claimable" else "읽음" if status == "read" else "확인"
	_add_local_button(row, Vector2(292, 15), Vector2(56, 28), label, disabled, func(): _claim_mail(mail_key))


func _render_bag() -> void:
	var resource_positions := [
		Vector2(0, 0),
		Vector2(181, 0),
		Vector2(0, 52),
		Vector2(181, 52),
		Vector2(0, 104),
		Vector2(181, 104),
	]
	for index in range(RESOURCE_KEYS.size()):
		_render_resource_chip(str(RESOURCE_KEYS[index]), resource_positions[index])

	_add_label(body, Vector2(0, 168), Vector2(220, 18), "보유 아이템", 12, Color(0.24, 0.15, 0.08))
	var ids: Array = sanctuary.item_inventory.keys()
	ids.sort()
	if ids.is_empty():
		_render_empty_at(Vector2(0, 192), "아이템 없음", "탐험과 상점 보상으로 채워집니다.")
		return

	var y := 192.0
	var count := 0
	for id_key in ids:
		if count >= 4:
			break
		_render_item_row(str(id_key), y)
		y += 46.0
		count += 1


func _render_resource_chip(resource_key: String, chip_position: Vector2) -> void:
	var chip := _add_panel(body, chip_position, Vector2(176, 44), Color(0.24, 0.16, 0.09, 0.91), Color(0.72, 0.55, 0.32, 0.52), 8)
	_add_icon(chip, _resource_icon_key(resource_key), Vector2(8, 9), Vector2(26, 26), _resource_short(resource_key))
	_add_label(chip, Vector2(42, 7), Vector2(76, 14), _resource_label(resource_key), 10, Color(0.90, 0.78, 0.54))
	_add_label(chip, Vector2(42, 21), Vector2(96, 17), _format_number(_resource_value(resource_key)), 14, Color(1.0, 0.93, 0.70))
	_add_label(chip, Vector2(120, 9), Vector2(48, 14), _resource_rate(resource_key), 9, Color(0.70, 0.94, 0.68), HORIZONTAL_ALIGNMENT_RIGHT)


func _render_item_row(id_key: String, row_y: float) -> void:
	var item_id := int(id_key)
	var item: Dictionary = store.get_item(item_id) if store != null else {}
	var row := _add_panel(body, Vector2(0, row_y), Vector2(358, 38), Color(0.22, 0.15, 0.09, 0.88), Color(0.61, 0.48, 0.31, 0.42), 8)
	_add_icon(row, _item_texture_key(item), Vector2(8, 6), Vector2(26, 26), "I")
	_add_label(row, Vector2(42, 5), Vector2(216, 15), str(item.get("name", "아이템 %d" % item_id)), 11, Color(0.98, 0.89, 0.66))
	_add_label(row, Vector2(42, 21), Vector2(130, 12), "ID %d" % item_id, 8, Color(0.68, 0.58, 0.43))
	_add_label(row, Vector2(274, 9), Vector2(66, 16), "x%d" % int(sanctuary.item_inventory.get(id_key, 0)), 13, Color(0.76, 0.96, 0.70), HORIZONTAL_ALIGNMENT_RIGHT)


func _render_pass() -> void:
	var tiers := _pass_entries()
	var y := 0.0
	for tier in tiers:
		_render_pass_row(tier, y)
		y += 76.0
	var claimable := 0
	for tier in tiers:
		if str(tier.get("status", "")) == "claimable":
			claimable += 1
	_add_label(body, Vector2(0, 318), Vector2(358, 28), "받을 보상 %d개 · 메인 정화와 성소 성장으로 단계가 열립니다." % claimable, 10, Color(0.30, 0.20, 0.11), HORIZONTAL_ALIGNMENT_CENTER)


func _render_pass_row(tier: Dictionary, row_y: float) -> void:
	var status := str(tier.get("status", "active"))
	var fill := Color(0.23, 0.16, 0.09, 0.90)
	if status == "claimable":
		fill = Color(0.35, 0.22, 0.08, 0.94)
	elif status == "claimed":
		fill = Color(0.17, 0.15, 0.12, 0.84)
	var row := _add_panel(body, Vector2(0, row_y), Vector2(358, 68), fill, Color(0.72, 0.54, 0.30, 0.55), 8)
	_add_icon(row, _feature_icon_key(str(tier.get("icon", "pass"))), Vector2(8, 12), Vector2(34, 34), "*")
	_add_label(row, Vector2(50, 7), Vector2(188, 16), str(tier.get("title", "패스")), 12, Color(1.0, 0.91, 0.66))
	_add_label(row, Vector2(50, 24), Vector2(190, 14), "%d/%d · %s" % [
		min(int(tier.get("progress", 0)), int(tier.get("target", 1))),
		int(tier.get("target", 1)),
		_reward_bundle_label(tier.get("reward", {})),
	], 9, Color(0.91, 0.82, 0.62))
	_add_progress(row, Vector2(50, 45), Vector2(184, 7), float(tier.get("percent", 0.0)), Color(0.64, 0.86, 0.38))
	var disabled := status != "claimable"
	var label := "완료" if status == "claimed" else "받기" if status == "claimable" else "진행"
	var tier_key := str(tier.get("key", ""))
	_add_local_button(row, Vector2(278, 18), Vector2(62, 30), label, disabled, func(): _claim_pass(tier_key))


func _claim_mail(mail_key: String) -> void:
	var entry := _mail_entry(mail_key)
	if entry.is_empty():
		return
	var reward: Dictionary = entry.get("reward", {})
	if not reward.is_empty() and not sanctuary.is_mail_claimed(mail_key):
		var labels: Array[String] = sanctuary.grant_reward_bundle(reward, store)
		sanctuary.set_mail_claimed(mail_key)
		sanctuary.last_log = "%s 수령 · %s" % [str(entry.get("title", "우편")), " · ".join(labels)]
	else:
		sanctuary.set_mail_read(mail_key)
		sanctuary.last_log = "%s 확인 완료." % str(entry.get("title", "우편"))
	modal_action_requested.emit("home_state_changed", {})
	sync_state()


func _claim_all_mail() -> void:
	var claimed := 0
	var labels: Array[String] = []
	for entry in _mail_entries():
		var mail_key := str(entry.get("key", ""))
		if bool(entry.get("claimable", false)):
			labels.append_array(sanctuary.grant_reward_bundle(entry.get("reward", {}), store))
			sanctuary.set_mail_claimed(mail_key)
			claimed += 1
		elif not bool(entry.get("read", false)):
			sanctuary.set_mail_read(mail_key)
	if claimed > 0:
		sanctuary.last_log = "우편 %d개 수령 · %s" % [claimed, " · ".join(labels)]
	else:
		sanctuary.last_log = "새 우편을 모두 확인했습니다."
	modal_action_requested.emit("home_state_changed", {})
	sync_state()


func _collect_all() -> void:
	var gains: Dictionary = sanctuary.collect_idle_resources(3)
	if gains.is_empty():
		sanctuary.last_log = "수집할 자동 생산품이 없습니다."
	modal_action_requested.emit("home_state_changed", {})
	sync_state()


func _claim_pass(tier_key: String) -> void:
	if tier_key == "":
		return
	var tier := _pass_entry(tier_key)
	if tier.is_empty():
		return
	if str(tier.get("status", "")) != "claimable":
		sanctuary.last_log = "아직 열리지 않은 패스 보상입니다."
		modal_action_requested.emit("home_state_changed", {})
		sync_state()
		return
	var labels: Array[String] = sanctuary.grant_reward_bundle(tier.get("reward", {}), store)
	sanctuary.set_pass_tier_claimed(tier_key)
	sanctuary.last_log = "%s 패스 보상 수령 · %s" % [str(tier.get("title", "패스")), " · ".join(labels)]
	modal_action_requested.emit("home_state_changed", {})
	sync_state()


func _mail_entries() -> Array:
	var entries := []
	for def in MAIL_DEFS:
		var entry: Dictionary = def.duplicate(true)
		if not _is_mail_available(entry):
			continue
		var mail_key := str(entry.get("key", ""))
		var reward: Dictionary = entry.get("reward", {})
		var claimed: bool = sanctuary.is_mail_claimed(mail_key)
		var read: bool = sanctuary.is_mail_read(mail_key)
		var claimable: bool = not claimed and not reward.is_empty()
		var status := "claimed" if claimed else "claimable" if claimable else "read" if read else "unread"
		entry["claimed"] = claimed
		entry["read"] = read
		entry["claimable"] = claimable
		entry["status"] = status
		entries.append(entry)
	entries.sort_custom(func(a, b): return _mail_status_rank(str(a.get("status", ""))) < _mail_status_rank(str(b.get("status", ""))))
	return entries


func _mail_entry(mail_key: String) -> Dictionary:
	for entry in _mail_entries():
		if str(entry.get("key", "")) == mail_key:
			return entry
	return {}


func _mail_summary(entries: Array) -> Dictionary:
	var summary := {"claimable": 0, "unread": 0, "claimed": 0, "total": entries.size()}
	for entry in entries:
		if bool(entry.get("claimable", false)):
			summary["claimable"] = int(summary["claimable"]) + 1
		if not bool(entry.get("read", false)):
			summary["unread"] = int(summary["unread"]) + 1
		if bool(entry.get("claimed", false)):
			summary["claimed"] = int(summary["claimed"]) + 1
	return summary


func _pass_entries() -> Array:
	var entries := []
	for def in PASS_TIERS:
		var entry: Dictionary = def.duplicate(true)
		var progress := _pass_progress(entry)
		var target := int(entry.get("target", 1))
		var claimed: bool = sanctuary.is_pass_tier_claimed(str(entry.get("key", "")))
		var complete: bool = progress >= target
		var status := "claimed" if claimed else "claimable" if complete else "active"
		entry["progress"] = progress
		entry["claimed"] = claimed
		entry["complete"] = complete
		entry["status"] = status
		entry["percent"] = clamp(float(progress) / max(1.0, float(target)), 0.0, 1.0)
		entries.append(entry)
	return entries


func _pass_entry(tier_key: String) -> Dictionary:
	for tier in _pass_entries():
		if str(tier.get("key", "")) == tier_key:
			return tier
	return {}


func _pass_progress(tier: Dictionary) -> int:
	match str(tier.get("metric", "")):
		"shrineLevel":
			return int(sanctuary.shrine_level)
		"companions":
			return _companion_count()
	return int(sanctuary.stage_clears)


func _companion_count() -> int:
	var has_training := false
	for instance in sanctuary.placed_building_instances.values():
		if typeof(instance) == TYPE_DICTIONARY and str(instance.get("buildingKey", "")) == "training_yard" and str(instance.get("status", "")) == "built":
			has_training = true
	if has_training and int(sanctuary.resources.get("companion_shards", 0)) > 0:
		return 2
	return 1 if has_training else 0


func _is_mail_available(entry: Dictionary) -> bool:
	var rules: Dictionary = entry.get("available", {})
	if int(rules.get("minStageClears", 0)) > int(sanctuary.stage_clears):
		return false
	if int(rules.get("minShrineLevel", 0)) > int(sanctuary.shrine_level):
		return false
	var building_key := str(rules.get("buildingBuilt", ""))
	if building_key == "":
		return true
	for instance in sanctuary.placed_building_instances.values():
		if typeof(instance) != TYPE_DICTIONARY:
			continue
		if str(instance.get("buildingKey", "")) == building_key and str(instance.get("status", "")) == "built":
			return true
	return false


func _first_claimable_mail_key() -> String:
	for entry in _mail_entries():
		if bool(entry.get("claimable", false)):
			return str(entry.get("key", ""))
	return ""


func _first_claimable_pass_key() -> String:
	for tier in _pass_entries():
		if str(tier.get("status", "")) == "claimable":
			return str(tier.get("key", ""))
	return ""


func _production_empty() -> bool:
	for rate in sanctuary.resource_rates.values():
		if float(rate) > 0.0:
			return false
	return true


func _mail_status_rank(status: String) -> int:
	var ranks := {"claimable": 0, "unread": 1, "read": 2, "claimed": 3}
	return int(ranks.get(status, 9))


func _mail_summary_label(summary: Dictionary) -> String:
	var claimable := int(summary.get("claimable", 0))
	var unread := int(summary.get("unread", 0))
	if claimable > 0:
		return "수령 가능한 우편 %d개" % claimable
	if unread > 0:
		return "읽지 않은 우편 %d개" % unread
	return "새 우편을 모두 확인했습니다"


func _render_empty(title: String, detail: String) -> void:
	_render_empty_at(Vector2(0, 56), title, detail)


func _render_empty_at(empty_position: Vector2, title: String, detail: String) -> void:
	var panel := _add_panel(body, empty_position, Vector2(358, 92), Color(0.22, 0.15, 0.09, 0.82), Color(0.60, 0.48, 0.30, 0.48), 8)
	_add_label(panel, Vector2(0, 24), Vector2(358, 18), title, 14, Color(1.0, 0.90, 0.66), HORIZONTAL_ALIGNMENT_CENTER)
	_add_label(panel, Vector2(42, 48), Vector2(274, 26), detail, 10, Color(0.78, 0.66, 0.48), HORIZONTAL_ALIGNMENT_CENTER)


func _add_local_button(parent: Control, button_position: Vector2, button_size: Vector2, text: String, disabled: bool, on_pressed: Callable) -> Button:
	var button := Button.new()
	button.text = text
	button.position = button_position
	button.size = button_size
	button.disabled = disabled
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_font_size_override("font_size", 10)
	button.add_theme_stylebox_override("normal", HomeTheme.style(Color(0.60, 0.30, 0.08, 0.96), Color(1.0, 0.78, 0.32, 0.78), 8, 1))
	button.add_theme_stylebox_override("hover", HomeTheme.style(Color(0.72, 0.37, 0.10, 0.98), Color(1.0, 0.88, 0.50, 0.88), 8, 1))
	button.add_theme_stylebox_override("disabled", HomeTheme.style(Color(0.25, 0.21, 0.16, 0.82), Color(0.56, 0.48, 0.36, 0.50), 8, 1))
	button.pressed.connect(on_pressed)
	parent.add_child(button)
	return button


func _reward_bundle_label(reward) -> String:
	if typeof(reward) != TYPE_DICTIONARY or reward.is_empty():
		return "공지"
	var parts: Array[String] = []
	for key in reward.keys():
		parts.append("%s +%s" % [_resource_label(str(key)), _format_number(int(reward[key]))])
	return " · ".join(parts)


func _resource_value(resource_key: String) -> int:
	match resource_key:
		"light":
			return int(sanctuary.shrine_light)
		"souls":
			return int(sanctuary.resources.get("soul", 0))
	return int(sanctuary.resources.get(_normalize_reward_key(resource_key), 0))


func _resource_rate(resource_key: String) -> String:
	var key := _normalize_reward_key(resource_key)
	if not sanctuary.resource_rates.has(key):
		return ""
	return sanctuary.format_rate(key)


func _resource_label(resource_key: String) -> String:
	var labels := {
		"ruby": "루비",
		"free_ruby": "무료 루비",
		"energy": "에너지",
		"gold": "골드",
		"wood": "목재",
		"stone": "석재",
		"soul": "영혼불",
		"souls": "영혼불",
		"light": "등불",
		"companion_exp": "동료 경험치",
		"companion_shards": "동료 조각",
	}
	return str(labels.get(resource_key, resource_key))


func _resource_short(resource_key: String) -> String:
	var labels := {
		"wood": "목",
		"soul": "혼",
		"gold": "G",
		"stone": "석",
		"energy": "E",
		"companion_shards": "조",
	}
	return str(labels.get(resource_key, "?"))


func _normalize_reward_key(resource_key: String) -> String:
	if resource_key == "souls":
		return "soul"
	return resource_key


func _resource_icon_key(resource_key: String) -> String:
	match _normalize_reward_key(resource_key):
		"wood":
			return "res_wood"
		"soul":
			return "res_soul"
		"gold":
			return "res_gold"
		"stone":
			return "res_stone"
		"energy":
			return "home_icon_collect"
		"companion_shards":
			return "home_icon_population"
	return "home_icon_bag"


func _feature_icon_key(icon_key: String) -> String:
	var table := {
		"mail": "home_icon_mail",
		"bag": "home_icon_bag",
		"pass": "home_icon_pass",
		"gift": "home_icon_collect",
		"exploration": "home_tab_exploration",
		"sanctuary": "home_tab_sanctuary",
		"population": "home_icon_population",
		"companions": "home_icon_population",
		"stone": "res_stone",
	}
	return str(table.get(icon_key, "home_icon_mail"))


func _view_title() -> String:
	var titles := {"mail": "우편", "bag": "가방", "pass": "패스"}
	return str(titles.get(view_key, "우편"))


func _view_subtitle() -> String:
	var subtitles := {
		"mail": "성소 알림 · 보상 수령",
		"bag": "보유 자원 · 획득 아이템",
		"pass": "메인 정화 · 성장 보상",
	}
	return str(subtitles.get(view_key, "성소 알림 · 보상 수령"))
