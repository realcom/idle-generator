extends "res://scripts/home/modals/tab_modal_base.gd"

const SLOT_ORDER := ["weapon", "head", "chest", "gloves", "boots", "necklace", "ring"]
const FILTERS := [
	{"key": "all", "label": "전체"},
	{"key": "weapon", "label": "무기"},
	{"key": "head", "label": "머리"},
	{"key": "chest", "label": "갑옷"},
	{"key": "gloves", "label": "장갑"},
	{"key": "boots", "label": "신발"},
	{"key": "necklace", "label": "목걸이"},
	{"key": "ring", "label": "반지"},
]
const STAT_ORDER := ["Attack", "Hp", "Defense", "CriticalPercent", "CriticalDamagePercent", "BossDamageEfficiencyPercent", "DamageTakenEfficiencyPercent", "AttackSpeedPercent"]
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
const MODAL_SIZE := Vector2(398, 568)
const LOADOUT_PANEL_SIZE := Vector2(208, 172)
const STAT_PANEL_POSITION := Vector2(216, 0)
const STAT_PANEL_SIZE := Vector2(150, 172)
const SLOT_BUTTON_SIZE := Vector2(48, 38)
const EQUIPPED_SLOT_ICON_POSITION := Vector2(11, 12)
const EQUIPPED_SLOT_ICON_SIZE := Vector2(26, 21)
const EMPTY_SLOT_ICON_POSITION := Vector2(14, 14)
const EMPTY_SLOT_ICON_SIZE := Vector2(20, 20)
const FILTER_TITLE_Y := 188.0
const FILTER_BUTTON_Y := 208.0
const INVENTORY_TITLE_Y := 244.0
const INVENTORY_CARD_Y := 270.0
const INVENTORY_CARD_SIZE := Vector2(66, 66)
const INVENTORY_CARD_GAP := 9.0
const INVENTORY_COLUMNS := 5

var active_filter := "all"


func setup(content_store, housing_store, sanctuary_state, texture_table: Dictionary) -> void:
	setup_context(content_store, housing_store, sanctuary_state, texture_table, "장비", "슬롯 · 보유 장비 · 상세", MODAL_SIZE)
	if sanctuary != null:
		sanctuary.ensure_starter_equipment(store)
	sync_state()


func sync_state() -> void:
	if sanctuary == null or store == null:
		return
	sanctuary.ensure_starter_equipment(store)
	_normalize_selected_equipment()
	setup_frame("장비", "슬롯 · 보유 장비 · 상세", MODAL_SIZE)
	clear_body()
	var selected: Dictionary = store.get_item(int(sanctuary.selected_equipment_item_id))
	_render_loadout(selected)
	_render_filters()
	_render_inventory_grid()
	var equipped: bool = not selected.is_empty() and sanctuary.is_equipment_equipped(int(selected.get("id", 0)))
	var owned: bool = not selected.is_empty() and sanctuary.is_equipment_owned(int(selected.get("id", 0)))
	set_secondary_action("닫기", "close")
	set_primary_action("장착 중" if equipped else "장착", "equip-selected", selected.is_empty() or equipped or not owned)


func _on_frame_action_requested(action: String) -> void:
	if action == "equip-selected":
		var selected_id := int(sanctuary.selected_equipment_item_id)
		if selected_id > 0:
			sanctuary.try_equip_item(store, selected_id)
			sync_state()
		return
	super._on_frame_action_requested(action)


func _render_loadout(selected: Dictionary) -> void:
	var doll := _add_panel(body, Vector2(0, 0), LOADOUT_PANEL_SIZE, Color(0.20, 0.13, 0.08, 0.91), Color(0.78, 0.60, 0.32, 0.70), 9)
	_add_label(doll, Vector2(10, 7), Vector2(90, 14), "장착 슬롯", 10, Color(1.0, 0.91, 0.70))
	_render_slot_button(doll, "weapon", Vector2(8, 28))
	_render_slot_button(doll, "head", Vector2(8, 72))
	_render_slot_button(doll, "chest", Vector2(8, 116))
	_render_avatar_stage(doll)
	_render_slot_button(doll, "gloves", Vector2(154, 12))
	_render_slot_button(doll, "boots", Vector2(154, 51))
	_render_slot_button(doll, "necklace", Vector2(154, 90))
	_render_slot_button(doll, "ring", Vector2(154, 129))
	_render_stat_summary(selected, STAT_PANEL_POSITION)


func _render_avatar_stage(parent: Control) -> void:
	var stage := _add_panel(parent, Vector2(58, 30), Vector2(92, 118), Color(0.12, 0.08, 0.05, 0.70), Color(0.92, 0.72, 0.38, 0.45), 8)
	_add_icon(stage, "home_profile", Vector2(16, 9), Vector2(60, 60), "N")
	_add_label(stage, Vector2(8, 73), Vector2(76, 15), "수호자", 10, Color(1.0, 0.91, 0.70), HORIZONTAL_ALIGNMENT_CENTER)
	_add_label(stage, Vector2(8, 93), Vector2(76, 14), "장착 %d/%d" % [_equipped_count(), SLOT_ORDER.size()], 8, Color(0.82, 0.74, 0.56), HORIZONTAL_ALIGNMENT_CENTER)


func _render_slot_button(parent: Control, slot_key: String, slot_position: Vector2) -> void:
	var item_id := int(sanctuary.equipped_item_ids.get(slot_key, 0))
	var item: Dictionary = store.get_item(item_id) if item_id > 0 else {}
	var selected: bool = item_id > 0 and item_id == int(sanctuary.selected_equipment_item_id)
	var fill: Color = Color(0.34, 0.23, 0.11, 0.98) if selected else Color(0.16, 0.10, 0.06, 0.92)
	var stroke: Color = Color(1.0, 0.78, 0.34, 0.88) if selected else Color(0.76, 0.58, 0.30, 0.66)
	var slot := _add_panel(parent, slot_position, SLOT_BUTTON_SIZE, fill, stroke, 7)
	slot.clip_contents = true
	_add_label(slot, Vector2(3, 2), Vector2(42, 9), sanctuary.equipment_slot_label(slot_key), 6, Color(1.0, 0.90, 0.67), HORIZONTAL_ALIGNMENT_CENTER)
	var texture_key := _item_texture_key(item) if not item.is_empty() else _empty_slot_texture_key(slot_key)
	var icon_position := EQUIPPED_SLOT_ICON_POSITION if item_id > 0 else EMPTY_SLOT_ICON_POSITION
	var icon_size := EQUIPPED_SLOT_ICON_SIZE if item_id > 0 else EMPTY_SLOT_ICON_SIZE
	_add_cropped_icon(slot, texture_key, icon_position, icon_size, sanctuary.equipment_slot_label(slot_key).left(1))
	if item_id > 0:
		_add_label(slot, Vector2(3, 29), Vector2(42, 8), "Lv.1", 6, Color(0.82, 0.74, 0.56), HORIZONTAL_ALIGNMENT_CENTER)
		_add_item_hitbox(slot, Vector2.ZERO, SLOT_BUTTON_SIZE, item_id)


func _render_stat_summary(selected: Dictionary, panel_position: Vector2) -> void:
	var totals: Dictionary = _equipment_totals()
	var panel := _add_panel(body, panel_position, STAT_PANEL_SIZE, Color(0.95, 0.82, 0.60, 0.94), Color(0.26, 0.16, 0.08, 0.70), 9)
	_add_label(panel, Vector2(10, 8), Vector2(62, 15), "전투력", 10, Color(0.28, 0.19, 0.10))
	_add_label(panel, Vector2(10, 24), Vector2(76, 24), _format_number(int(totals.get("power", 0))), 20, Color(0.12, 0.07, 0.04))
	_add_label(panel, Vector2(88, 15), Vector2(50, 18), "보유", 8, Color(0.34, 0.23, 0.12), HORIZONTAL_ALIGNMENT_CENTER)
	_add_label(panel, Vector2(88, 31), Vector2(50, 16), "%d/%d" % [_owned_equipment().size(), _equipment_catalog().size()], 10, Color(0.13, 0.08, 0.04), HORIZONTAL_ALIGNMENT_CENTER)

	var y := 58.0
	for row in _summary_stat_rows(totals):
		if typeof(row) != TYPE_DICTIONARY:
			continue
		_render_stat_row(panel, row, y)
		y += 18.0

	if selected.is_empty():
		_add_label(panel, Vector2(10, 146), Vector2(130, 18), "장비를 선택하세요.", 8, Color(0.30, 0.20, 0.11), HORIZONTAL_ALIGNMENT_CENTER)
		return
	var slot_key: String = sanctuary.equipment_slot_key(selected)
	_add_label(panel, Vector2(10, 136), Vector2(40, 12), sanctuary.equipment_slot_label(slot_key), 7, Color(0.34, 0.23, 0.12), HORIZONTAL_ALIGNMENT_CENTER)
	_add_label(panel, Vector2(52, 136), Vector2(88, 12), _short_name(str(selected.get("name", "장비")), 8), 7, Color(0.13, 0.08, 0.04), HORIZONTAL_ALIGNMENT_RIGHT)
	_add_label(panel, Vector2(10, 151), Vector2(130, 12), "상태 · %s" % ("장착 중" if sanctuary.is_equipment_equipped(int(selected.get("id", 0))) else "보유"), 7, Color(0.18, 0.36, 0.18), HORIZONTAL_ALIGNMENT_CENTER)


func _render_stat_row(parent: Control, row: Dictionary, y: float) -> void:
	var strip := _add_panel(parent, Vector2(10, y), Vector2(130, 16), Color(0.22, 0.14, 0.07, 0.84), Color(0.82, 0.64, 0.34, 0.40), 5)
	_add_label(strip, Vector2(7, 2), Vector2(64, 12), str(row.get("label", "")), 7, Color(0.82, 0.74, 0.56))
	_add_label(strip, Vector2(76, 2), Vector2(48, 12), str(row.get("value", "")), 7, Color(1.0, 0.91, 0.70), HORIZONTAL_ALIGNMENT_RIGHT)


func _render_filters() -> void:
	_add_label(body, Vector2(0, FILTER_TITLE_Y), Vector2(110, 16), "분류", 11, Color(0.17, 0.10, 0.05))
	var x := 0.0
	for filter in FILTERS:
		if typeof(filter) != TYPE_DICTIONARY:
			continue
		_render_filter_button(str(filter.get("key", "all")), str(filter.get("label", "전체")), Vector2(x, FILTER_BUTTON_Y))
		x += 46.0


func _render_filter_button(filter_key: String, label: String, button_position: Vector2) -> void:
	var active: bool = active_filter == filter_key
	var button := Button.new()
	button.text = label
	button.position = button_position
	button.size = Vector2(40, 28)
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_font_size_override("font_size", 8)
	button.add_theme_stylebox_override("normal", HomeTheme.style(Color(0.56, 0.30, 0.10, 0.96) if active else Color(0.20, 0.13, 0.08, 0.91), Color(1.0, 0.78, 0.32, 0.78) if active else Color(0.76, 0.58, 0.30, 0.58), 7, 1))
	button.add_theme_stylebox_override("hover", HomeTheme.style(Color(0.64, 0.34, 0.11, 0.98), Color(1.0, 0.84, 0.44, 0.84), 7, 1))
	button.pressed.connect(func() -> void:
		active_filter = filter_key
		sync_state()
	)
	body.add_child(button)


func _render_inventory_grid() -> void:
	var owned: Array = _owned_equipment()
	var filtered: Array = _filtered_equipment(owned)
	_add_label(body, Vector2(0, INVENTORY_TITLE_Y), Vector2(120, 18), "장비 목록", 12, Color(0.17, 0.10, 0.05))
	_add_label(body, Vector2(body.size.x - 146, INVENTORY_TITLE_Y), Vector2(146, 18), "%s %d/%d" % [_filter_label(active_filter), filtered.size(), owned.size()], 9, Color(0.30, 0.20, 0.11), HORIZONTAL_ALIGNMENT_RIGHT)
	if filtered.is_empty():
		_add_label(body, Vector2(0, INVENTORY_CARD_Y + 18.0), Vector2(body.size.x, 52), "해당 분류의 보유 장비가 없습니다.", 12, Color(0.28, 0.19, 0.10), HORIZONTAL_ALIGNMENT_CENTER, VERTICAL_ALIGNMENT_CENTER)
		return
	for index in range(min(INVENTORY_COLUMNS * 2, filtered.size())):
		var item: Dictionary = filtered[index]
		var col: int = index % INVENTORY_COLUMNS
		var row: int = int(index / INVENTORY_COLUMNS)
		var card_x := float(col) * (INVENTORY_CARD_SIZE.x + INVENTORY_CARD_GAP)
		var card_y := INVENTORY_CARD_Y + float(row) * (INVENTORY_CARD_SIZE.y + 8.0)
		_render_inventory_card(item, Vector2(card_x, card_y))


func _render_inventory_card(item: Dictionary, card_position: Vector2) -> void:
	var item_id := int(item.get("id", 0))
	var selected: bool = item_id == int(sanctuary.selected_equipment_item_id)
	var equipped: bool = sanctuary.is_equipment_equipped(item_id)
	var rarity: int = int(clamp(int(item.get("rarity", item.get("grade", 1))), 1, 5))
	var fill: Color = Color(0.34, 0.23, 0.11, 0.98) if selected else Color(0.23, 0.15, 0.08, 0.91)
	var stroke: Color = Color(1.0, 0.78, 0.32, 0.86) if selected else _rarity_stroke(rarity)
	var card := _add_panel(body, card_position, INVENTORY_CARD_SIZE, fill, stroke, 8)
	var slot_key: String = sanctuary.equipment_slot_key(item)
	_add_label(card, Vector2(5, 4), Vector2(28, 10), sanctuary.equipment_slot_label(slot_key), 6, Color(1.0, 0.91, 0.70))
	_add_label(card, Vector2(32, 4), Vector2(30, 10), "장착" if equipped else "Lv.1", 6, Color(0.66, 0.95, 0.58) if equipped else Color(0.82, 0.74, 0.56), HORIZONTAL_ALIGNMENT_RIGHT)
	_add_cropped_icon(card, _item_texture_key(item), Vector2(15, 16), Vector2(36, 31), "G")
	_add_label(card, Vector2(4, 51), Vector2(58, 11), _short_name(str(item.get("name", "장비")), 7), 7, Color(1.0, 0.91, 0.70), HORIZONTAL_ALIGNMENT_CENTER)
	_add_item_hitbox(card, Vector2.ZERO, INVENTORY_CARD_SIZE, item_id)


func _add_cropped_icon(parent: Control, texture_key: String, icon_position: Vector2, icon_size: Vector2, fallback_text := "") -> void:
	var texture: Texture2D = _texture(texture_key)
	if texture != null:
		var icon := TextureRect.new()
		icon.texture = _alpha_cropped_texture(texture, Vector2i(int(round(icon_size.x)), int(round(icon_size.y))), 4)
		icon.position = icon_position
		icon.size = icon_size
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.stretch_mode = TextureRect.STRETCH_SCALE
		icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		parent.add_child(icon)
		return
	_add_label(parent, icon_position, icon_size, fallback_text, 12, Color(1.0, 0.88, 0.58), HORIZONTAL_ALIGNMENT_CENTER, VERTICAL_ALIGNMENT_CENTER)


func _alpha_cropped_texture(texture: Texture2D, target_size: Vector2i, padding: int) -> Texture2D:
	var image := texture.get_image()
	if image == null or image.is_empty() or target_size.x <= 0 or target_size.y <= 0:
		return texture
	var used := image.get_used_rect()
	if used.size.x <= 0 or used.size.y <= 0:
		return texture
	var image_size := Vector2i(image.get_width(), image.get_height())
	var left: int = int(max(0, used.position.x - padding))
	var top: int = int(max(0, used.position.y - padding))
	var right: int = int(min(image_size.x, used.position.x + used.size.x + padding))
	var bottom: int = int(min(image_size.y, used.position.y + used.size.y + padding))
	var crop := Rect2i(Vector2i(left, top), Vector2i(max(1, right - left), max(1, bottom - top)))
	var cropped := image.get_region(crop)
	var scale: float = min(float(target_size.x) / float(crop.size.x), float(target_size.y) / float(crop.size.y))
	var resized_size := Vector2i(max(1, int(round(float(crop.size.x) * scale))), max(1, int(round(float(crop.size.y) * scale))))
	cropped.resize(resized_size.x, resized_size.y, Image.INTERPOLATE_LANCZOS)
	var output := Image.create(target_size.x, target_size.y, false, Image.FORMAT_RGBA8)
	output.fill(Color(0, 0, 0, 0))
	var paste_position := Vector2i(int((target_size.x - resized_size.x) / 2), int((target_size.y - resized_size.y) / 2))
	output.blit_rect(cropped, Rect2i(Vector2i.ZERO, resized_size), paste_position)
	return ImageTexture.create_from_image(output)


func _add_item_hitbox(parent: Control, hit_position: Vector2, hit_size: Vector2, item_id: int) -> void:
	var button := Button.new()
	button.text = ""
	button.position = hit_position
	button.size = hit_size
	button.focus_mode = Control.FOCUS_NONE
	button.flat = true
	var empty_style := StyleBoxEmpty.new()
	button.add_theme_stylebox_override("normal", empty_style)
	button.add_theme_stylebox_override("hover", empty_style)
	button.add_theme_stylebox_override("pressed", empty_style)
	button.pressed.connect(func() -> void:
		_open_equipment_detail(item_id)
	)
	parent.add_child(button)


func _open_equipment_detail(item_id: int) -> void:
	if item_id <= 0:
		return
	sanctuary.selected_equipment_item_id = item_id
	sanctuary.last_log = "장비 상세를 확인할 항목을 선택했습니다."
	modal_action_requested.emit("equipment_detail", {"item_id": item_id})


func _normalize_selected_equipment() -> void:
	var selected_id := int(sanctuary.selected_equipment_item_id)
	if selected_id > 0 and sanctuary.is_equipment_owned(selected_id):
		return
	var owned: Array = _owned_equipment()
	if owned.is_empty():
		sanctuary.selected_equipment_item_id = 0
		return
	var first: Dictionary = owned[0]
	sanctuary.selected_equipment_item_id = int(first.get("id", 0))


func _filtered_equipment(owned: Array) -> Array:
	if active_filter == "all":
		return owned
	var filtered := []
	for item in owned:
		if typeof(item) == TYPE_DICTIONARY and sanctuary.equipment_slot_key(item) == active_filter:
			filtered.append(item)
	return filtered


func _owned_equipment() -> Array:
	var owned := []
	for item in _equipment_catalog():
		if typeof(item) != TYPE_DICTIONARY:
			continue
		var item_id := int(item.get("id", 0))
		if item_id > 0 and sanctuary.is_equipment_owned(item_id):
			owned.append(item)
	owned.sort_custom(func(a, b):
		var slot_a := _slot_order_index(sanctuary.equipment_slot_key(a))
		var slot_b := _slot_order_index(sanctuary.equipment_slot_key(b))
		if slot_a == slot_b:
			return int(a.get("id", 0)) < int(b.get("id", 0))
		return slot_a < slot_b
	)
	return owned


func _equipment_catalog() -> Array:
	var items := []
	for item in store.get_records("Items"):
		if typeof(item) == TYPE_DICTIONARY and _is_equipment_item(item):
			items.append(item)
	items.sort_custom(func(a, b):
		var slot_a := _slot_order_index(sanctuary.equipment_slot_key(a))
		var slot_b := _slot_order_index(sanctuary.equipment_slot_key(b))
		if slot_a == slot_b:
			return int(a.get("id", 0)) < int(b.get("id", 0))
		return slot_a < slot_b
	)
	return items


func _is_equipment_item(item: Dictionary) -> bool:
	var category := str(item.get("category", "")).to_lower()
	if category != "weapon" and category != "equipment":
		return false
	return sanctuary.equipment_slot_key(item) != ""


func _equipment_totals() -> Dictionary:
	var stats := {}
	var power := 0
	for item_id in sanctuary.equipped_item_ids.values():
		var item: Dictionary = store.get_item(int(item_id))
		if item.is_empty():
			continue
		power += int(item.get("power", 0))
		var item_stats: Dictionary = _item_stat_map(item)
		for key in item_stats.keys():
			stats[key] = float(stats.get(key, 0.0)) + float(item_stats[key])
	if power <= 0 and stats.has("Attack"):
		power = int(round(float(stats.get("Attack", 0.0)) * 9.0))
	return {"power": power, "stats": stats}


func _item_stat_map(item: Dictionary) -> Dictionary:
	var stats := {}
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
			stats[key] = float(stats.get(key, 0.0)) + _first_stat_value(stat.get("value", stat.get("Value", 0.0)))
	return stats


func _first_stat_value(raw_value) -> float:
	if typeof(raw_value) == TYPE_ARRAY:
		if raw_value.is_empty():
			return 0.0
		return float(raw_value[0])
	return float(raw_value)


func _summary_stat_rows(totals: Dictionary) -> Array:
	var stats: Dictionary = totals.get("stats", {})
	var rows := []
	for key in STAT_ORDER:
		if float(stats.get(key, 0.0)) <= 0.0:
			continue
		rows.append({"key": key, "label": _stat_label(key), "value": _format_stat_value(key, float(stats.get(key, 0.0)))})
		if rows.size() >= 4:
			return rows
	for fallback in ["Attack", "Hp", "CriticalPercent", "BossDamageEfficiencyPercent"]:
		if _rows_have_key(rows, fallback):
			continue
		rows.append({"key": fallback, "label": _stat_label(fallback), "value": _format_stat_value(fallback, float(stats.get(fallback, 0.0)))})
		if rows.size() >= 4:
			break
	return rows


func _rows_have_key(rows: Array, key: String) -> bool:
	for row in rows:
		if typeof(row) == TYPE_DICTIONARY and str(row.get("key", "")) == key:
			return true
	return false


func _format_stat_value(stat_key: String, value: float) -> String:
	if stat_key.ends_with("Percent") or stat_key.find("EfficiencyPercent") >= 0:
		return "%s%%" % _trim_float(value)
	return _format_number(int(round(value)))


func _stat_label(stat_key: String) -> String:
	return str(STAT_LABELS.get(stat_key, stat_key))


func _filter_label(filter_key: String) -> String:
	for filter in FILTERS:
		if typeof(filter) == TYPE_DICTIONARY and str(filter.get("key", "")) == filter_key:
			return str(filter.get("label", "전체"))
	return "전체"


func _equipped_count() -> int:
	var count := 0
	for item_id in sanctuary.equipped_item_ids.values():
		if int(item_id) > 0:
			count += 1
	return count


func _slot_order_index(slot_key: String) -> int:
	var index := SLOT_ORDER.find(slot_key)
	return index if index >= 0 else 999


func _empty_slot_texture_key(slot_key: String) -> String:
	match slot_key:
		"weapon":
			return "equip_empty_weapon"
		"head":
			return "equip_empty_head"
		"chest":
			return "equip_empty_chest"
		"gloves":
			return "equip_empty_gloves"
		"boots":
			return "equip_empty_boots"
		"necklace":
			return "equip_empty_necklace"
		"ring":
			return "equip_empty_ring"
	return "equip_empty_weapon"


func _rarity_stroke(rarity: int) -> Color:
	match rarity:
		2:
			return Color(0.45, 0.88, 0.54, 0.78)
		3:
			return Color(0.42, 0.72, 1.0, 0.78)
		4:
			return Color(0.78, 0.55, 1.0, 0.78)
		5:
			return Color(1.0, 0.70, 0.26, 0.88)
	return Color(0.78, 0.60, 0.32, 0.72)


func _short_name(value: String, max_chars: int) -> String:
	if value.length() <= max_chars:
		return value
	return "%s…" % value.left(max(1, max_chars - 1))


func _trim_float(value: float) -> String:
	if is_equal_approx(value, round(value)):
		return str(int(round(value)))
	return "%.1f" % value
