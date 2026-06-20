extends "res://scripts/home/modals/tab_modal_base.gd"

const CATEGORY_TABS := [
	{"key": "featured", "label": "추천"},
	{"key": "packs", "label": "패키지"},
	{"key": "ruby", "label": "루비"},
	{"key": "energy", "label": "에너지"},
	{"key": "pass", "label": "패스"},
]

var first_available_product_id := 0
var active_category := "featured"
var bonus_chip_shell: Control
var footer_shell: Control


func setup(content_store, housing_store, sanctuary_state, texture_table: Dictionary) -> void:
	setup_context(content_store, housing_store, sanctuary_state, texture_table, "상점", "한정 상품 · 현금 보급", Vector2(390, 690))
	sync_state()


func sync_state() -> void:
	if store == null or sanctuary == null:
		return
	setup_frame("상점", "한정 상품 · 현금 보급", size)
	_clear_shop_chrome()
	_customize_shop_frame()
	clear_body()
	first_available_product_id = 0

	var products: Array = _shop_products()
	var summary: Dictionary = _shop_summary(products)
	_render_category_tabs()
	_render_shop_content(products)
	_render_footer(summary)


func _on_frame_action_requested(action: String) -> void:
	if action == "buy-first" and first_available_product_id > 0:
		modal_action_requested.emit("buy_product", {"product_id": first_available_product_id})
		return
	super._on_frame_action_requested(action)


func _clear_shop_chrome() -> void:
	if is_instance_valid(bonus_chip_shell):
		bonus_chip_shell.queue_free()
	if is_instance_valid(footer_shell):
		footer_shell.queue_free()
	bonus_chip_shell = null
	footer_shell = null


func _customize_shop_frame() -> void:
	if frame_root == null:
		return
	frame_root.size = size
	add_theme_stylebox_override("panel", HomeTheme.style(Color(0.91, 0.77, 0.55, 0.99), Color(0.12, 0.08, 0.05, 0.98), 12, 2))

	title_label.position = Vector2(22, 34)
	title_label.size = Vector2(190, 31)
	title_label.text = "상점"
	title_label.add_theme_font_size_override("font_size", 23)
	title_label.add_theme_color_override("font_color", Color(0.12, 0.07, 0.04))

	subtitle_label.position = Vector2(24, 18)
	subtitle_label.size = Vector2(190, 16)
	subtitle_label.text = "오늘의 특가"
	subtitle_label.add_theme_font_size_override("font_size", 11)
	subtitle_label.add_theme_color_override("font_color", Color(0.47, 0.28, 0.12))

	body.position = Vector2(16, 98)
	body.size = Vector2(size.x - 32.0, size.y - 160.0)
	primary_button.visible = false
	secondary_button.visible = false

	bonus_chip_shell = _add_panel_shell(frame_root, Vector2(size.x - 178.0, 46.0), Vector2(124, 28), Color(0.15, 0.34, 0.24, 0.96), Color(0.95, 0.70, 0.29, 0.74), 14)
	_add_label(bonus_chip_shell, Vector2(8, 5), Vector2(108, 14), "보너스 루비 +60", 10, Color(1.0, 0.87, 0.48), HORIZONTAL_ALIGNMENT_CENTER)


func _render_category_tabs() -> void:
	var tab_bar := _add_panel(body, Vector2(0, 0), Vector2(body.size.x, 50), Color(0.17, 0.12, 0.07, 0.92), Color(0.75, 0.55, 0.28, 0.56), 10)
	var gap := 6.0
	var tab_w: float = floor((body.size.x - 20.0 - gap * float(CATEGORY_TABS.size() - 1)) / float(CATEGORY_TABS.size()))
	for index in range(CATEGORY_TABS.size()):
		var tab: Dictionary = CATEGORY_TABS[index]
		var key := str(tab.get("key", "featured"))
		var button := Button.new()
		button.text = str(tab.get("label", "탭"))
		button.position = Vector2(10.0 + float(index) * (tab_w + gap), 8)
		button.size = Vector2(tab_w, 34)
		button.focus_mode = Control.FOCUS_NONE
		button.add_theme_font_size_override("font_size", 10)
		if key == active_category:
			_apply_button_style(button, Color(0.90, 0.55, 0.18, 0.98), Color(1.0, 0.88, 0.42, 0.86), Color(0.12, 0.06, 0.03), 9)
		else:
			_apply_button_style(button, Color(0.28, 0.20, 0.12, 0.94), Color(0.72, 0.55, 0.30, 0.54), Color(0.96, 0.83, 0.58), 9)
		_connect_category_button(button, key)
		tab_bar.add_child(button)


func _render_shop_content(products: Array) -> void:
	var scroll := ScrollContainer.new()
	scroll.position = Vector2(0, 60)
	scroll.size = Vector2(body.size.x, body.size.y - 60.0)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	body.add_child(scroll)

	var content := Control.new()
	content.size = Vector2(scroll.size.x - 8.0, scroll.size.y + 1.0)
	content.custom_minimum_size = content.size
	scroll.add_child(content)

	var y := 0.0
	var decorated_products := _decorated_products(products)
	var timed_deal := _timed_deal_product(decorated_products)
	if (active_category == "featured" or active_category == "packs") and not timed_deal.is_empty():
		_render_timed_deal(content, timed_deal, y)
		y += 132.0

	_render_section_header(content, y, _category_title(), _category_caption())
	y += 26.0

	var entries := _card_entries_for_category(decorated_products, timed_deal)
	if entries.is_empty():
		_render_empty(content, y)
		y += 86.0
	else:
		var card_gap := 8.0
		var card_w: float = floor((content.size.x - card_gap) / 2.0)
		var card_h := 144.0
		for index in range(entries.size()):
			var column := index % 2
			var row := int(index / 2)
			var card_pos := Vector2(float(column) * (card_w + card_gap), y + float(row) * (card_h + card_gap))
			_render_product_card(content, entries[index], card_pos, Vector2(card_w, card_h))
		var rows := int(ceil(float(entries.size()) / 2.0))
		y += float(rows) * card_h + float(max(0, rows - 1)) * card_gap + 12.0

	if active_category == "featured":
		var quick_entries := _quick_entries(decorated_products)
		if not quick_entries.is_empty():
			y += 18.0
			_render_quick_list(content, quick_entries, y)
			y += 42.0 + float(quick_entries.size()) * 52.0

	content.custom_minimum_size = Vector2(content.size.x, max(y + 12.0, scroll.size.y + 1.0))
	content.size = content.custom_minimum_size


func _render_timed_deal(parent: Control, product: Dictionary, y: float) -> void:
	var card := _add_panel(parent, Vector2(0, y), Vector2(parent.size.x, 126), Color(0.10, 0.25, 0.18, 0.98), Color(0.99, 0.72, 0.30, 0.86), 12)
	var copy_w: float = max(132.0, parent.size.x - 218.0)
	var icon_disc := _add_panel(card, Vector2(14, 18), Vector2(82, 82), Color(0.96, 0.73, 0.24, 0.98), Color(0.17, 0.09, 0.04, 0.62), 41)
	_add_icon(icon_disc, _product_icon_key(product), Vector2(10, 10), Vector2(62, 62), "$")
	_add_badge(card, Vector2(108, 15), "타임특가", Color(0.91, 0.28, 0.12, 0.98), Color(1.0, 0.84, 0.42, 0.70), Color(1.0, 0.93, 0.72), 72)
	_add_label(card, Vector2(108, 41), Vector2(copy_w, 24), str(product.get("name", "상품")), 17, Color(1.0, 0.90, 0.62))
	_add_label(card, Vector2(108, 66), Vector2(copy_w + 12.0, 24), _product_summary(product), 10, Color(0.76, 0.90, 0.72))
	var countdown := _add_panel(card, Vector2(108, 93), Vector2(104, 22), Color(0.07, 0.16, 0.14, 0.92), Color(0.36, 1.0, 0.90, 0.78), 11)
	_add_label(countdown, Vector2(6, 4), Vector2(92, 11), str(product.get("_ui_timer", "02:47:12")), 10, Color(0.42, 1.0, 0.92), HORIZONTAL_ALIGNMENT_CENTER)
	_add_badge(card, Vector2(parent.size.x - 76.0, 0), str(product.get("_ui_discount", "-35%")), Color(0.76, 0.23, 0.15, 1.0), Color(1.0, 0.80, 0.38, 0.70), Color(1.0, 0.92, 0.72), 66)
	_add_action_button(card, Vector2(parent.size.x - 94.0, 75), Vector2(80, 34), _price_label(product), "buy_product", {"product_id": int(product.get("id", 0))}, _is_claimed(product))
	_register_first_available(product)


func _render_section_header(parent: Control, y: float, title: String, caption: String) -> void:
	_add_label(parent, Vector2(2, y), Vector2(120, 18), title, 13, Color(0.17, 0.10, 0.05))
	_add_label(parent, Vector2(122, y + 2.0), Vector2(parent.size.x - 124.0, 15), caption, 9, Color(0.48, 0.31, 0.16), HORIZONTAL_ALIGNMENT_RIGHT)


func _render_product_card(parent: Control, product: Dictionary, card_position: Vector2, card_size: Vector2) -> void:
	var claimed := _is_claimed(product)
	var preview := bool(product.get("_ui_preview", false))
	var card_fill := Color(0.94, 0.80, 0.58, 0.96) if not claimed else Color(0.72, 0.65, 0.55, 0.92)
	var card := _add_panel(parent, card_position, card_size, card_fill, Color(0.28, 0.17, 0.08, 0.62), 10)
	var badge_palette := _badge_palette(product)
	_add_badge(card, Vector2(card_size.x - 64.0, 8), str(product.get("_ui_badge", "추천")), badge_palette.get("fill"), badge_palette.get("stroke"), badge_palette.get("text"), 52)
	var icon_bg := _add_panel(card, Vector2(10, 13), Vector2(58, 58), Color(0.20, 0.14, 0.08, 0.88), Color(0.93, 0.72, 0.38, 0.48), 12)
	_add_icon(icon_bg, _product_icon_key(product), Vector2(6, 6), Vector2(46, 46), "$")
	_add_trimmed_label(card, Vector2(76, 32), Vector2(card_size.x - 86.0, 19), str(product.get("name", "상품")), 13, Color(0.13, 0.08, 0.04))
	_add_label(card, Vector2(10, 71), Vector2(card_size.x - 20.0, 23), _product_summary(product), 9, Color(0.31, 0.22, 0.13))
	_render_reward_chips(card, Vector2(10, 92), _reward_chip_labels(product, 2), card_size.x - 100.0)

	var button_text := "보유" if claimed else _price_label(product)
	var action := str(product.get("_ui_action", "buy_product"))
	var payload: Dictionary = product.get("_ui_payload", {"product_id": int(product.get("id", 0))})
	var disabled := claimed or (preview and action == "")
	_add_action_button(card, Vector2(card_size.x - 82.0, card_size.y - 32.0), Vector2(72, 24), button_text, action, payload, disabled)
	if not preview:
		_register_first_available(product)


func _render_quick_list(parent: Control, products: Array, y: float) -> void:
	_render_section_header(parent, y, "빠른 구매", "자주 쓰는 보급품")
	y += 28.0
	for index in range(products.size()):
		var product: Dictionary = products[index]
		var row := _add_panel(parent, Vector2(0, y + float(index) * 52.0), Vector2(parent.size.x, 44), Color(0.24, 0.17, 0.10, 0.94), Color(0.77, 0.58, 0.31, 0.50), 9)
		_add_icon(row, _product_icon_key(product), Vector2(9, 7), Vector2(30, 30), "$")
		_add_trimmed_label(row, Vector2(48, 8), Vector2(148, 16), str(product.get("name", "상품")), 11, Color(1.0, 0.90, 0.66))
		_add_trimmed_label(row, Vector2(48, 25), Vector2(190, 13), _reward_summary(product), 8, Color(0.78, 0.86, 0.62))
		_add_action_button(row, Vector2(parent.size.x - 82.0, 8), Vector2(70, 28), _price_label(product), "buy_product", {"product_id": int(product.get("id", 0))}, _is_claimed(product))


func _render_footer(summary: Dictionary) -> void:
	footer_shell = _add_panel_shell(frame_root, Vector2(16, size.y - 48.0), Vector2(size.x - 32.0, 36), Color(0.13, 0.27, 0.20, 0.98), Color(0.94, 0.70, 0.34, 0.65), 11)
	var text := "구매 가능 %d종 · 1회 한정 %d종 · 보유 %d/%d" % [
		int(summary.get("available", 0)),
		int(summary.get("limited", 0)),
		int(summary.get("claimed", 0)),
		int(summary.get("total", 0)),
	]
	_add_label(footer_shell, Vector2(14, 10), Vector2(286, 14), text, 10, Color(1.0, 0.88, 0.57))
	_add_label(footer_shell, Vector2(footer_shell.size.x - 82.0, 9), Vector2(68, 15), "구매 복구", 10, Color(0.80, 1.0, 0.79), HORIZONTAL_ALIGNMENT_RIGHT)


func _render_empty(parent: Control, y: float) -> void:
	var empty := _add_panel(parent, Vector2(0, y), Vector2(parent.size.x, 76), Color(0.25, 0.18, 0.11, 0.88), Color(0.75, 0.56, 0.30, 0.42), 10)
	_add_label(empty, Vector2(0, 18), Vector2(parent.size.x, 20), "준비 중인 상품 탭입니다.", 12, Color(0.96, 0.83, 0.58), HORIZONTAL_ALIGNMENT_CENTER)
	_add_label(empty, Vector2(0, 42), Vector2(parent.size.x, 16), "다음 보급 갱신을 기다려 주세요.", 9, Color(0.75, 0.66, 0.48), HORIZONTAL_ALIGNMENT_CENTER)


func _shop_products() -> Array:
	var products := []
	for item in store.get_records("Items"):
		if typeof(item) != TYPE_DICTIONARY:
			continue
		if str(item.get("category", "")) != "Product":
			continue
		var popup_args = item.get("popupArgs", {})
		if typeof(popup_args) == TYPE_DICTIONARY and str(popup_args.get("ShopSection", "")) == "Cash":
			products.append(item)
	products.sort_custom(func(a, b): return int(a.get("id", 0)) < int(b.get("id", 0)))
	return products


func _decorated_products(products: Array) -> Array:
	var entries := []
	for product in products:
		if typeof(product) != TYPE_DICTIONARY:
			continue
		entries.append(_decorate_product(product))
	entries.sort_custom(func(a, b): return int(a.get("_ui_order", 100)) < int(b.get("_ui_order", 100)))
	return entries


func _decorate_product(product: Dictionary) -> Dictionary:
	var entry := product.duplicate(true)
	var key := _product_runtime_key(product)
	entry["_ui_key"] = key
	entry["_ui_category"] = "packs"
	entry["_ui_badge"] = "추천"
	entry["_ui_card_label"] = "보급품"
	entry["_ui_featured"] = true
	entry["_ui_order"] = 50
	entry["_ui_extra_categories"] = []
	entry["_ui_timer"] = "02:47:12"
	entry["_ui_discount"] = "-25%"
	match key:
		"starter_sanctuary_pack":
			entry["_ui_category"] = "packs"
			entry["_ui_badge"] = "1회 한정"
			entry["_ui_card_label"] = "초반 가속"
			entry["_ui_order"] = 10
			entry["_ui_discount"] = "-35%"
		"ruby_pouch":
			entry["_ui_category"] = "ruby"
			entry["_ui_badge"] = "+10%"
			entry["_ui_card_label"] = "루비 충전"
			entry["_ui_order"] = 20
		"energy_refill_pack":
			entry["_ui_category"] = "energy"
			entry["_ui_badge"] = "출격"
			entry["_ui_card_label"] = "에너지"
			entry["_ui_order"] = 30
		"ad_removal_blessing":
			entry["_ui_category"] = "pass"
			entry["_ui_extra_categories"] = ["packs"]
			entry["_ui_badge"] = "영구"
			entry["_ui_card_label"] = "프리미엄"
			entry["_ui_order"] = 40
	return entry


func _pass_teaser() -> Dictionary:
	return {
		"id": -1001,
		"name": "닌자 성장 패스",
		"_ui_key": "season_growth_pass",
		"_ui_preview": true,
		"_ui_category": "pass",
		"_ui_extra_categories": ["featured", "packs"],
		"_ui_featured": true,
		"_ui_badge": "PASS",
		"_ui_card_label": "시즌 보상",
		"_ui_icon_key": "home_icon_pass",
		"_ui_summary": "무료/프리미엄 트랙 보상과 매일 루비",
		"_ui_price": "패스 보기",
		"_ui_action": "open_quick",
		"_ui_payload": {"view_key": "pass"},
		"_ui_order": 60,
	}


func _timed_deal_product(products: Array) -> Dictionary:
	for product in products:
		if typeof(product) == TYPE_DICTIONARY and str(product.get("_ui_key", "")) == "starter_sanctuary_pack":
			return product
	return products[0] if not products.is_empty() and typeof(products[0]) == TYPE_DICTIONARY else {}


func _card_entries_for_category(products: Array, timed_deal: Dictionary) -> Array:
	var entries := []
	var timed_id := int(timed_deal.get("id", -999999))
	for product in products:
		if typeof(product) != TYPE_DICTIONARY:
			continue
		if int(product.get("id", -1)) == timed_id and (active_category == "featured" or active_category == "packs"):
			continue
		if _entry_matches_category(product):
			entries.append(product)
	var pass_entry := _pass_teaser()
	if _entry_matches_category(pass_entry):
		entries.append(pass_entry)
	entries.sort_custom(func(a, b): return int(a.get("_ui_order", 100)) < int(b.get("_ui_order", 100)))
	return entries


func _entry_matches_category(entry: Dictionary) -> bool:
	if active_category == "featured":
		return bool(entry.get("_ui_featured", false)) or _entry_has_extra_category(entry, "featured")
	var category := str(entry.get("_ui_category", ""))
	return category == active_category or _entry_has_extra_category(entry, active_category)


func _entry_has_extra_category(entry: Dictionary, category: String) -> bool:
	var categories = entry.get("_ui_extra_categories", [])
	if typeof(categories) != TYPE_ARRAY:
		return false
	for item in categories:
		if str(item) == category:
			return true
	return false


func _quick_entries(products: Array) -> Array:
	var quick := []
	for key in ["ruby_pouch", "energy_refill_pack", "ad_removal_blessing"]:
		for product in products:
			if typeof(product) == TYPE_DICTIONARY and str(product.get("_ui_key", "")) == key:
				quick.append(product)
				break
	return quick


func _register_first_available(product: Dictionary) -> void:
	if first_available_product_id > 0:
		return
	if bool(product.get("_ui_preview", false)) or _is_claimed(product):
		return
	var product_id := int(product.get("id", 0))
	if product_id > 0:
		first_available_product_id = product_id


func _set_category(category_key: String) -> void:
	if active_category == category_key:
		return
	active_category = category_key
	sync_state()


func _connect_category_button(button: Button, category_key: String) -> void:
	button.pressed.connect(func(): _set_category(category_key))


func _add_panel_shell(parent: Control, panel_position: Vector2, panel_size: Vector2, fill: Color, stroke: Color, radius := 8) -> Control:
	var panel := PanelContainer.new()
	panel.position = panel_position
	panel.size = panel_size
	panel.add_theme_stylebox_override("panel", HomeTheme.style(fill, stroke, radius, 1))
	parent.add_child(panel)

	var content := Control.new()
	content.position = Vector2.ZERO
	content.size = panel_size
	panel.add_child(content)
	return content


func _add_badge(parent: Control, badge_position: Vector2, text: String, fill: Color, stroke: Color, color: Color, badge_width := 48.0) -> void:
	var badge := _add_panel(parent, badge_position, Vector2(badge_width, 20), fill, stroke, 10)
	_add_label(badge, Vector2(4, 3), Vector2(badge_width - 8.0, 11), text, 8, color, HORIZONTAL_ALIGNMENT_CENTER)


func _add_trimmed_label(parent: Control, label_position: Vector2, label_size: Vector2, text: String, font_size := 11, color := Color(0.15, 0.10, 0.06), align := HORIZONTAL_ALIGNMENT_LEFT) -> Label:
	var label := _add_label(parent, label_position, label_size, text, font_size, color, align)
	label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	return label


func _apply_button_style(button: Button, fill: Color, stroke: Color, font_color: Color, radius := 8) -> void:
	button.add_theme_color_override("font_color", font_color)
	button.add_theme_color_override("font_hover_color", font_color)
	button.add_theme_color_override("font_pressed_color", font_color)
	button.add_theme_color_override("font_disabled_color", Color(0.58, 0.50, 0.42))
	button.add_theme_stylebox_override("normal", HomeTheme.style(fill, stroke, radius, 1))
	button.add_theme_stylebox_override("hover", HomeTheme.style(fill.lightened(0.08), stroke.lightened(0.12), radius, 1))
	button.add_theme_stylebox_override("pressed", HomeTheme.style(fill.darkened(0.08), stroke, radius, 1))
	button.add_theme_stylebox_override("disabled", HomeTheme.style(Color(0.30, 0.26, 0.21, 0.86), Color(0.55, 0.48, 0.36, 0.44), radius, 1))


func _badge_palette(product: Dictionary) -> Dictionary:
	match str(product.get("_ui_key", "")):
		"ruby_pouch":
			return {
				"fill": Color(0.74, 0.26, 0.15, 0.96),
				"stroke": Color(1.0, 0.82, 0.40, 0.66),
				"text": Color(1.0, 0.93, 0.72),
			}
		"energy_refill_pack":
			return {
				"fill": Color(0.15, 0.40, 0.26, 0.96),
				"stroke": Color(0.74, 1.0, 0.65, 0.44),
				"text": Color(0.86, 1.0, 0.74),
			}
		"ad_removal_blessing":
			return {
				"fill": Color(0.10, 0.48, 0.44, 0.96),
				"stroke": Color(0.57, 1.0, 0.92, 0.50),
				"text": Color(0.86, 1.0, 0.96),
			}
		"season_growth_pass":
			return {
				"fill": Color(0.94, 0.70, 0.22, 0.98),
				"stroke": Color(0.28, 0.16, 0.05, 0.55),
				"text": Color(0.14, 0.08, 0.03),
			}
	return {
		"fill": Color(0.16, 0.38, 0.28, 0.95),
		"stroke": Color(0.91, 0.68, 0.34, 0.58),
		"text": Color(1.0, 0.91, 0.68),
	}


func _render_reward_chips(parent: Control, chip_position: Vector2, labels: Array, max_width: float) -> void:
	var x := chip_position.x
	for label in labels:
		var text := str(label)
		var chip_w: float = clamp(float(text.length()) * 7.0 + 18.0, 44.0, max_width - (x - chip_position.x))
		if chip_w < 34.0:
			break
		var chip := _add_panel(parent, Vector2(x, chip_position.y), Vector2(chip_w, 18), Color(0.18, 0.35, 0.25, 0.92), Color(0.73, 0.62, 0.35, 0.38), 9)
		_add_trimmed_label(chip, Vector2(5, 3), Vector2(chip_w - 10.0, 10), text, 7, Color(0.86, 1.0, 0.72), HORIZONTAL_ALIGNMENT_CENTER)
		x += chip_w + 5.0
		if x - chip_position.x >= max_width - 24.0:
			break


func _shop_summary(products: Array) -> Dictionary:
	var available := 0
	var claimed := 0
	var limited := 0
	for product in products:
		if typeof(product) != TYPE_DICTIONARY:
			continue
		var once := _product_purchase_limit(product) == "once"
		if once:
			limited += 1
		if once and bool(sanctuary.shop_claims.get(_product_runtime_key(product), false)):
			claimed += 1
		else:
			available += 1
	return {"available": available, "claimed": claimed, "limited": limited, "total": products.size()}


func _is_claimed(product: Dictionary) -> bool:
	if bool(product.get("_ui_preview", false)):
		return false
	var once := _product_purchase_limit(product) == "once"
	return once and bool(sanctuary.shop_claims.get(_product_runtime_key(product), false))


func _category_title() -> String:
	match active_category:
		"packs":
			return "패키지 상품"
		"ruby":
			return "루비 충전"
		"energy":
			return "에너지 보급"
		"pass":
			return "패스/권한"
	return "추천 상품"


func _category_caption() -> String:
	match active_category:
		"packs":
			return "1회 한정과 성장 패키지"
		"ruby":
			return "보너스 루비 포함"
		"energy":
			return "출격 흐름 유지"
		"pass":
			return "시즌 보상과 영구 혜택"
	return "할인과 타임특가 우선"


func _product_runtime_key(product: Dictionary) -> String:
	if product.has("_ui_key"):
		return str(product.get("_ui_key", ""))
	var popup_args = product.get("popupArgs", {})
	if typeof(popup_args) == TYPE_DICTIONARY:
		var key := str(popup_args.get("RuntimeShopKey", ""))
		if key != "":
			return key
	return str(product.get("id", ""))


func _product_purchase_limit(product: Dictionary) -> String:
	var popup_args = product.get("popupArgs", {})
	if typeof(popup_args) == TYPE_DICTIONARY:
		return str(popup_args.get("PurchaseLimit", ""))
	return ""


func _product_icon_key(product: Dictionary) -> String:
	if product.has("_ui_icon_key"):
		return str(product.get("_ui_icon_key", "home_tab_shop"))
	var popup_args = product.get("popupArgs", {})
	if typeof(popup_args) == TYPE_DICTIONARY:
		var icon_key := str(popup_args.get("RuntimeIconKey", ""))
		if icon_key != "":
			return icon_key
	return "home_tab_shop"


func _product_summary(product: Dictionary) -> String:
	if product.has("_ui_summary"):
		return str(product.get("_ui_summary", "상점 상품"))
	var popup_args = product.get("popupArgs", {})
	if typeof(popup_args) == TYPE_DICTIONARY:
		var summary := str(popup_args.get("Summary", ""))
		if summary != "":
			return summary
	return "상점 상품"


func _price_label(product: Dictionary) -> String:
	if product.has("_ui_price"):
		return str(product.get("_ui_price", "보기"))
	var won := int(product.get("priceWon", 0))
	if won > 0:
		return "₩%s" % _format_won(won)
	var usd := float(product.get("priceUsd", 0.0))
	if usd > 0.0:
		return "$%.2f" % usd
	return "무료"


func _format_won(value: int) -> String:
	var raw := str(max(0, value))
	var result := ""
	var count := 0
	for index in range(raw.length() - 1, -1, -1):
		if count > 0 and count % 3 == 0:
			result = "," + result
		result = raw.substr(index, 1) + result
		count += 1
	return result


func _reward_chip_labels(product: Dictionary, max_count := 3) -> Array:
	if bool(product.get("_ui_preview", false)):
		return ["무료 트랙", "프리미엄"]
	var groups = product.get("addItemGroups", [])
	if typeof(groups) != TYPE_ARRAY:
		return ["보상 없음"]
	var labels := []
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
			if labels.size() >= max_count:
				return labels
	return labels if not labels.is_empty() else ["보상 없음"]


func _reward_summary(product: Dictionary) -> String:
	return " · ".join(_reward_chip_labels(product, 3))


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
		201504:
			return "광고 제거"
	var item: Dictionary = store.get_item(item_id)
	return str(item.get("name", "아이템"))
