extends "res://scripts/home/modals/tab_modal_base.gd"

var item_id := 0

const STAT_LABELS := {
	"Attack": "공격",
	"Hp": "체력",
	"Defense": "방어",
	"CriticalPercent": "치명",
	"CriticalDamagePercent": "치피",
	"BossDamageEfficiencyPercent": "보스",
	"DamageTakenEfficiencyPercent": "피감",
	"AttackSpeedPercent": "공속",
	"CooldownPercent": "쿨감",
	"Power": "전투력",
}


func setup(content_store, sanctuary_state, texture_table: Dictionary, selected_item_id: int) -> void:
	item_id = int(selected_item_id)
	setup_context(content_store, null, sanctuary_state, texture_table, "장비 상세", "장착 정보", Vector2(370, 430))
	sync_state()


func sync_state() -> void:
	if store == null or sanctuary == null:
		return
	var item: Dictionary = store.get_item(item_id)
	if item.is_empty():
		setup_frame("장비 상세", "아이템 없음", size)
		clear_body()
		_add_label(body, Vector2(0, 80), Vector2(body.size.x, 50), "장비 데이터를 찾을 수 없습니다.", 12, Color(0.22, 0.13, 0.07), HORIZONTAL_ALIGNMENT_CENTER, VERTICAL_ALIGNMENT_CENTER)
		set_secondary_action("닫기", "close")
		set_primary_action("닫기", "close")
		return

	setup_frame(str(item.get("name", "장비")), "장비 상세 · %s" % sanctuary.equipment_slot_label(sanctuary.equipment_slot_key(item)), size)
	clear_body()
	_render_item(item)
	set_secondary_action("닫기", "close")
	var equipped: bool = sanctuary.is_equipment_equipped(item_id)
	var owned: bool = sanctuary.is_equipment_owned(item_id)
	set_primary_action("장착 중" if equipped else "장착하기", "equip-detail", equipped or not owned)


func _on_frame_action_requested(action: String) -> void:
	if action == "equip-detail":
		modal_action_requested.emit("equip_item", {"item_id": item_id})
		return
	super._on_frame_action_requested(action)


func _render_item(item: Dictionary) -> void:
	var slot_key: String = sanctuary.equipment_slot_key(item)
	var level := 1
	var max_level := _max_level(item)
	var grade := int(item.get("grade", 1))
	var hero := _add_panel(body, Vector2(0, 0), Vector2(body.size.x, 112), Color(0.23, 0.15, 0.08, 0.92), Color(0.80, 0.62, 0.34, 0.72), 9)
	_add_icon(hero, _item_texture_key(item), Vector2(12, 14), Vector2(74, 74), "G")
	_add_label(hero, Vector2(98, 14), Vector2(210, 22), str(item.get("name", "장비")), 16, Color(1.0, 0.92, 0.72))
	_add_label(hero, Vector2(98, 39), Vector2(210, 16), "%s · %s · 전투력 %d" % [sanctuary.equipment_slot_label(slot_key), _rarity_label(grade), int(item.get("power", 0))], 10, Color(0.84, 0.76, 0.58))
	_add_label(hero, Vector2(98, 62), Vector2(72, 16), "Lv.%d/%d" % [level, max_level], 10, Color(1.0, 0.88, 0.60))
	_add_progress(hero, Vector2(170, 68), Vector2(130, 7), float(level) / float(max_level), Color(0.42, 0.82, 0.58))
	_add_label(hero, Vector2(98, 82), Vector2(210, 16), "상태 · %s" % ("장착 중" if sanctuary.is_equipment_equipped(item_id) else "보유"), 10, Color(0.62, 0.95, 0.58))

	_add_label(body, Vector2(0, 132), Vector2(120, 18), "장비 효과", 12, Color(0.17, 0.10, 0.05))
	var effects: Array = _effect_entries(item)
	for index in range(min(3, effects.size())):
		var effect: Dictionary = effects[index]
		_render_stat_chip(Vector2(float(index) * 116.0, 158), str(effect.get("label", "효과")), str(effect.get("value", "")))

	var meta := _add_panel(body, Vector2(0, 208), Vector2(body.size.x, 28), Color(0.23, 0.15, 0.08, 0.86), Color(0.78, 0.60, 0.32, 0.45), 7)
	_add_label(meta, Vector2(10, 6), Vector2(96, 14), "보유 %d" % max(1, int(sanctuary.item_inventory.get(str(item_id), 1))), 9, Color(1.0, 0.91, 0.70), HORIZONTAL_ALIGNMENT_CENTER)
	_add_label(meta, Vector2(120, 6), Vector2(96, 14), "부위 %s" % sanctuary.equipment_slot_label(slot_key), 9, Color(1.0, 0.91, 0.70), HORIZONTAL_ALIGNMENT_CENTER)
	_add_label(meta, Vector2(230, 6), Vector2(96, 14), "등급 %s" % _rarity_label(grade), 9, Color(1.0, 0.91, 0.70), HORIZONTAL_ALIGNMENT_CENTER)

	var description := _description(item, slot_key, effects)
	var desc := _add_panel(body, Vector2(0, 246), Vector2(body.size.x, 48), Color(0.95, 0.82, 0.60, 0.92), Color(0.25, 0.16, 0.08, 0.68), 8)
	_add_label(desc, Vector2(12, 8), Vector2(body.size.x - 24, 34), description, 10, Color(0.18, 0.11, 0.06))


func _render_stat_chip(chip_position: Vector2, title: String, value: String) -> void:
	var chip := _add_panel(body, chip_position, Vector2(104, 42), Color(0.96, 0.86, 0.64, 0.94), Color(0.30, 0.20, 0.10, 0.68), 8)
	_add_label(chip, Vector2(6, 5), Vector2(92, 14), title, 9, Color(0.34, 0.23, 0.12), HORIZONTAL_ALIGNMENT_CENTER)
	_add_label(chip, Vector2(6, 20), Vector2(92, 16), value, 11, Color(0.13, 0.08, 0.04), HORIZONTAL_ALIGNMENT_CENTER)


func _effect_entries(item: Dictionary) -> Array:
	var entries := [{"label": "전투력", "value": "+%d" % int(item.get("power", 0))}]
	for stat_group_key in ["equipAddStats", "addStats"]:
		var stat_group = item.get(stat_group_key, [])
		if typeof(stat_group) != TYPE_ARRAY:
			continue
		for stat in stat_group:
			if typeof(stat) != TYPE_DICTIONARY:
				continue
			var key := str(stat.get("type", stat.get("Type", "")))
			if key == "":
				continue
			entries.append({"label": _stat_label(key), "value": "+%s" % _format_stat_value(key, _first_stat_value(stat.get("value", stat.get("Value", 0.0))))})
			if entries.size() >= 3:
				return entries
	return entries


func _first_stat_value(raw_value) -> float:
	if typeof(raw_value) == TYPE_ARRAY:
		if raw_value.is_empty():
			return 0.0
		return float(raw_value[0])
	return float(raw_value)


func _format_stat_value(stat_key: String, value: float) -> String:
	if stat_key.ends_with("Percent") or stat_key.find("EfficiencyPercent") >= 0:
		return "%s%%" % _trim_float(value)
	return _trim_float(value)


func _stat_label(stat_key: String) -> String:
	return str(STAT_LABELS.get(stat_key, stat_key))


func _rarity_label(grade: int) -> String:
	var labels := ["일반", "고급", "희귀", "영웅", "전설"]
	var index: int = clamp(grade - 1, 0, labels.size() - 1)
	return str(labels[index])


func _max_level(item: Dictionary) -> int:
	var required_exps = item.get("requiredExps", [])
	if typeof(required_exps) == TYPE_ARRAY and not required_exps.is_empty():
		return max(1, required_exps.size())
	return 20


func _description(item: Dictionary, slot_key: String, effects: Array) -> String:
	var popup_args = item.get("popupArgs", {})
	if typeof(popup_args) == TYPE_DICTIONARY:
		var direct := str(popup_args.get("ItemDescription", ""))
		if direct != "":
			return direct
	var primary := "전투력"
	if effects.size() > 1 and typeof(effects[1]) == TYPE_DICTIONARY:
		primary = str(effects[1].get("label", "전투력"))
	return "%s 슬롯에 장착해 %s을 보강하는 장비입니다." % [sanctuary.equipment_slot_label(slot_key), primary]


func _trim_float(value: float) -> String:
	if is_equal_approx(value, round(value)):
		return str(int(round(value)))
	return "%.1f" % value
