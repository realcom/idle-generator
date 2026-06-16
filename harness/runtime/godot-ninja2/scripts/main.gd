extends Control

const ContentStore := preload("res://scripts/content_store.gd")
const BattleSim := preload("res://scripts/battle_sim.gd")

const UNIT_TEXTURES := {
	110111: "battle/characters/guardian_hero.png",
	110201: "battle/characters/enemy_leaf_imp.png",
	110202: "battle/characters/enemy_soot_spirit.png",
	110203: "battle/characters/enemy_purple_mushroom.png",
	110501: "battle/characters/enemy_thorn_boss_full.png",
}
const RESOURCE_ICONS := {
	"gold": "ui/topbar/icon_coin.png",
	"wood": "ui/topbar/icon_wood.png",
	"stone": "ui/topbar/icon_stone.png",
	"soul": "ui/topbar/icon_soul.png",
}
const EQUIPMENT_ICON_BY_TYPE := {
	"Weapon": "items/flat-equipment/icon_weapon_lantern_kunai.png",
	"Head": "items/flat-equipment/icon_head_guardian_hood.png",
	"Chest": "items/flat-equipment/icon_chest_guardian_mantle.png",
	"Gloves": "items/flat-equipment/icon_gloves_work_gloves.png",
	"Boots": "items/flat-equipment/icon_boots_mist_sandals.png",
	"Necklace": "items/flat-equipment/icon_necklace_soulflame_pendant.png",
	"Ring": "items/flat-equipment/icon_ring_bamboo_ring.png",
}

var store
var sim
var textures := {}
var entity_views := {}
var event_views: Array[Label] = []

var home_screen: Control
var battle_screen: Control
var world_layer: Control
var entity_layer: Control
var event_layer: Control
var result_panel: PanelContainer
var result_label: Label
var stage_select: OptionButton
var home_summary: TextEdit
var home_resource_labels := {}
var battle_resource_labels := {}
var hp_bar: ProgressBar
var timer_label: Label
var kill_label: Label
var enemy_label: Label
var map_label: Label
var status_label: Label


func _ready() -> void:
	store = ContentStore.new()
	var ok: bool = store.load_all()
	sim = BattleSim.new(store)
	_load_textures()
	_build_ui()
	_populate_home()

	if ok:
		status_label.text = "ninja2 JSON 로드 완료"
	else:
		status_label.text = "로드 경고 있음. 데이터 패널 확인"


func _process(delta: float) -> void:
	if battle_screen != null and battle_screen.visible:
		sim.step(delta)
		_sync_battle()


func _load_textures() -> void:
	var paths := {
		"home_bg": "home/background_forest_sanctuary.png",
		"title_logo": "ui/title/title_logo_namutip_maeul_grow_v1.png",
		"profile": "ui/profile_guardian.png",
		"panel": "ui/panel_parchment_9slice.png",
		"button": "ui/button_sortie_orange.png",
		"skill": "battle/skill-vfx/vfx_kunai_slash_arc.png",
		"prop_bamboo": "battle/props/prop_bamboo_clump.png",
		"prop_lantern": "battle/props/prop_lantern_post.png",
		"prop_stones": "battle/props/prop_moss_stones.png",
		"dash": "ui/battle-controls/icon_dash.png",
	}

	for unit_id in UNIT_TEXTURES.keys():
		paths["unit_%d" % unit_id] = UNIT_TEXTURES[unit_id]
	for key in RESOURCE_ICONS.keys():
		paths["res_%s" % key] = RESOURCE_ICONS[key]
	for key in EQUIPMENT_ICON_BY_TYPE.keys():
		paths["equip_%s" % key] = EQUIPMENT_ICON_BY_TYPE[key]

	for key in paths.keys():
		textures[key] = _load_texture(paths[key])


func _build_ui() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	home_screen = Control.new()
	home_screen.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(home_screen)

	battle_screen = Control.new()
	battle_screen.set_anchors_preset(Control.PRESET_FULL_RECT)
	battle_screen.visible = false
	add_child(battle_screen)

	_build_home_screen()
	_build_battle_screen()


func _build_home_screen() -> void:
	_add_fullscreen_texture(home_screen, textures.get("home_bg"), Color(0.05, 0.09, 0.07))
	_add_overlay(home_screen, Color(0.0, 0.0, 0.0, 0.25))

	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_top", 18)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_bottom", 18)
	home_screen.add_child(margin)

	var root := VBoxContainer.new()
	root.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_theme_constant_override("separation", 12)
	margin.add_child(root)

	var top := HBoxContainer.new()
	top.add_theme_constant_override("separation", 8)
	root.add_child(top)
	for resource_key in ["gold", "wood", "stone", "soul"]:
		var chip := _resource_chip(resource_key)
		top.add_child(chip)

	var title_row := HBoxContainer.new()
	title_row.size_flags_vertical = Control.SIZE_EXPAND_FILL
	title_row.add_theme_constant_override("separation", 14)
	root.add_child(title_row)

	var left := VBoxContainer.new()
	left.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left.add_theme_constant_override("separation", 10)
	title_row.add_child(left)

	var logo := TextureRect.new()
	logo.texture = textures.get("title_logo")
	logo.custom_minimum_size = Vector2(250, 108)
	logo.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	logo.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	left.add_child(logo)

	var title := Label.new()
	title.text = "Godot 런타임 프로브"
	title.add_theme_font_size_override("font_size", 24)
	title.add_theme_color_override("font_color", Color(1.0, 0.91, 0.72))
	left.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "harness/build/ninja2 JSON과 런타임 PNG를 직접 읽습니다."
	subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	subtitle.add_theme_font_size_override("font_size", 14)
	subtitle.add_theme_color_override("font_color", Color(0.88, 0.86, 0.76))
	left.add_child(subtitle)

	status_label = Label.new()
	status_label.add_theme_color_override("font_color", Color(0.67, 0.93, 0.76))
	left.add_child(status_label)

	var hero := TextureRect.new()
	hero.texture = textures.get("profile")
	hero.custom_minimum_size = Vector2(180, 260)
	hero.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	hero.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	title_row.add_child(hero)

	var stage_panel := PanelContainer.new()
	stage_panel.add_theme_stylebox_override("panel", _style(Color(0.11, 0.16, 0.13, 0.86), Color(0.67, 0.48, 0.26, 0.8), 8))
	root.add_child(stage_panel)

	var stage_box := VBoxContainer.new()
	stage_box.add_theme_constant_override("separation", 8)
	stage_panel.add_child(stage_box)

	var stage_label := Label.new()
	stage_label.text = "출격 지역"
	stage_label.add_theme_font_size_override("font_size", 18)
	stage_label.add_theme_color_override("font_color", Color(1.0, 0.9, 0.66))
	stage_box.add_child(stage_label)

	stage_select = OptionButton.new()
	stage_box.add_child(stage_select)

	var actions := HBoxContainer.new()
	actions.add_theme_constant_override("separation", 8)
	stage_box.add_child(actions)

	var sortie_button := Button.new()
	sortie_button.text = "출격"
	sortie_button.custom_minimum_size = Vector2(0, 54)
	sortie_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sortie_button.pressed.connect(_start_battle)
	actions.add_child(sortie_button)

	var reload_button := Button.new()
	reload_button.text = "데이터 새로고침"
	reload_button.custom_minimum_size = Vector2(0, 54)
	reload_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	reload_button.pressed.connect(_reload_data)
	actions.add_child(reload_button)

	var equipment := HBoxContainer.new()
	equipment.add_theme_constant_override("separation", 8)
	root.add_child(equipment)
	_build_equipment_strip(equipment)

	home_summary = TextEdit.new()
	home_summary.editable = false
	home_summary.custom_minimum_size = Vector2(0, 168)
	home_summary.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	home_summary.add_theme_font_size_override("font_size", 13)
	root.add_child(home_summary)


func _build_battle_screen() -> void:
	var bg := ColorRect.new()
	bg.color = Color(0.055, 0.095, 0.075)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	battle_screen.add_child(bg)

	world_layer = Control.new()
	world_layer.set_anchors_preset(Control.PRESET_FULL_RECT)
	battle_screen.add_child(world_layer)

	_add_battle_prop("prop_bamboo", Vector2(44, 230), Vector2(130, 115), -0.12)
	_add_battle_prop("prop_lantern", Vector2(392, 246), Vector2(118, 160), 0.08)
	_add_battle_prop("prop_stones", Vector2(356, 705), Vector2(140, 96), 0.03)

	entity_layer = Control.new()
	entity_layer.set_anchors_preset(Control.PRESET_FULL_RECT)
	battle_screen.add_child(entity_layer)

	event_layer = Control.new()
	event_layer.set_anchors_preset(Control.PRESET_FULL_RECT)
	battle_screen.add_child(event_layer)

	var top_margin := MarginContainer.new()
	top_margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	top_margin.add_theme_constant_override("margin_left", 14)
	top_margin.add_theme_constant_override("margin_top", 14)
	top_margin.add_theme_constant_override("margin_right", 14)
	top_margin.add_theme_constant_override("margin_bottom", 14)
	battle_screen.add_child(top_margin)

	var root := VBoxContainer.new()
	root.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_theme_constant_override("separation", 8)
	top_margin.add_child(root)

	var hud := PanelContainer.new()
	hud.add_theme_stylebox_override("panel", _style(Color(0.08, 0.12, 0.11, 0.84), Color(0.64, 0.52, 0.34, 0.72), 8))
	root.add_child(hud)

	var hud_box := VBoxContainer.new()
	hud_box.add_theme_constant_override("separation", 6)
	hud.add_child(hud_box)

	var hud_row := HBoxContainer.new()
	hud_row.add_theme_constant_override("separation", 8)
	hud_box.add_child(hud_row)

	var back_button := Button.new()
	back_button.text = "홈"
	back_button.pressed.connect(_return_home)
	hud_row.add_child(back_button)

	map_label = Label.new()
	map_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	map_label.add_theme_color_override("font_color", Color(1.0, 0.9, 0.7))
	map_label.add_theme_font_size_override("font_size", 17)
	hud_row.add_child(map_label)

	timer_label = Label.new()
	timer_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	hud_row.add_child(timer_label)

	hp_bar = ProgressBar.new()
	hp_bar.show_percentage = false
	hp_bar.max_value = 1.0
	hud_box.add_child(hp_bar)

	var stat_row := HBoxContainer.new()
	stat_row.add_theme_constant_override("separation", 10)
	hud_box.add_child(stat_row)
	kill_label = _battle_stat_label("처치 0")
	enemy_label = _battle_stat_label("적 0")
	stat_row.add_child(kill_label)
	stat_row.add_child(enemy_label)
	for resource_key in ["gold", "wood", "stone", "soul"]:
		stat_row.add_child(_battle_resource_chip(resource_key))

	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(spacer)

	var skill_bar := HBoxContainer.new()
	skill_bar.add_theme_constant_override("separation", 10)
	root.add_child(skill_bar)
	_add_skill_chip(skill_bar, "skill", "쿠나이")
	_add_skill_chip(skill_bar, "dash", "회피")

	result_panel = PanelContainer.new()
	result_panel.visible = false
	result_panel.set_anchors_preset(Control.PRESET_CENTER)
	result_panel.custom_minimum_size = Vector2(320, 180)
	result_panel.add_theme_stylebox_override("panel", _style(Color(0.1, 0.12, 0.1, 0.96), Color(0.95, 0.7, 0.36), 10))
	battle_screen.add_child(result_panel)

	var result_box := VBoxContainer.new()
	result_box.alignment = BoxContainer.ALIGNMENT_CENTER
	result_box.add_theme_constant_override("separation", 10)
	result_panel.add_child(result_box)

	result_label = Label.new()
	result_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	result_label.add_theme_font_size_override("font_size", 24)
	result_label.add_theme_color_override("font_color", Color(1.0, 0.9, 0.68))
	result_box.add_child(result_label)

	var result_button := Button.new()
	result_button.text = "성소로 돌아가기"
	result_button.custom_minimum_size = Vector2(240, 48)
	result_button.pressed.connect(_return_home)
	result_box.add_child(result_button)


func _populate_home() -> void:
	stage_select.clear()
	var maps := store.get_main_maps()
	for map_def in maps:
		var id := int(map_def.get("id", 0))
		stage_select.add_item("%d  %s" % [id, str(map_def.get("name", ""))], id)
	if maps.size() == 0:
		stage_select.add_item("500101  대나무 영지 입구", 500101)

	home_summary.text = store.build_summary()
	_sync_home_resources()


func _reload_data() -> void:
	var ok: bool = store.load_all()
	_populate_home()
	status_label.text = "데이터 새로고침 완료" if ok else "데이터 새로고침 경고"


func _start_battle() -> void:
	var selected_id := stage_select.get_selected_id()
	if selected_id <= 0:
		selected_id = 500101
	sim.start(selected_id)
	result_panel.visible = false
	_clear_entity_views()
	home_screen.visible = false
	battle_screen.visible = true
	_sync_battle()


func _return_home() -> void:
	battle_screen.visible = false
	home_screen.visible = true
	result_panel.visible = false
	_clear_entity_views()
	_sync_home_resources()


func _sync_home_resources() -> void:
	for key in home_resource_labels.keys():
		home_resource_labels[key].text = str(sim.resources.get(key, 0))


func _sync_battle() -> void:
	var snapshot := sim.snapshot()
	map_label.text = str(snapshot.get("map_name", "대나무 영지"))
	var left := max(0.0, float(snapshot.get("run_duration", 90.0)) - float(snapshot.get("elapsed", 0.0)))
	var left_seconds := int(left)
	timer_label.text = "%02d:%02d" % [int(left_seconds / 60.0), left_seconds % 60]
	kill_label.text = "처치 %d" % int(snapshot.get("kill_count", 0))
	enemy_label.text = "적 %d" % int(snapshot.get("enemy_count", 0))

	var player = snapshot.get("player", {})
	var hp := float(player.get("hp", 0.0))
	var max_hp := max(1.0, float(player.get("max_hp", 1.0)))
	hp_bar.value = clamp(hp / max_hp, 0.0, 1.0)

	for key in battle_resource_labels.keys():
		battle_resource_labels[key].text = str(snapshot.get("resources", {}).get(key, 0))

	_sync_entity_views(snapshot.get("entities", []), player)
	_sync_event_views(snapshot.get("events", []), player)

	if not bool(snapshot.get("running", false)) and str(snapshot.get("result", "")) != "" and not result_panel.visible:
		var result := str(snapshot.get("result", ""))
		result_label.text = "정화 성공" if result == "clear" else "후퇴 필요"
		result_panel.visible = true


func _sync_entity_views(entities: Array, player: Dictionary) -> void:
	var live_ids := {}
	for entity in entities:
		if typeof(entity) != TYPE_DICTIONARY:
			continue
		var runtime_id := int(entity.get("runtime_id", 0))
		live_ids[runtime_id] = true
		if not entity_views.has(runtime_id):
			entity_views[runtime_id] = _create_entity_view(entity)

		var view = entity_views[runtime_id]
		var root := view["root"] as Control
		var screen_position := _world_to_screen(entity.get("position", Vector2.ZERO), player)
		root.position = screen_position - root.size * 0.5
		var hp_fill := view["hp"] as ColorRect
		var hp_ratio := clamp(float(entity.get("hp", 0.0)) / max(1.0, float(entity.get("max_hp", 1.0))), 0.0, 1.0)
		hp_fill.size.x = float(view["hp_width"]) * hp_ratio

	for runtime_id in entity_views.keys().duplicate():
		if not live_ids.has(runtime_id):
			var view = entity_views[runtime_id]
			var root := view["root"] as Control
			root.queue_free()
			entity_views.erase(runtime_id)


func _sync_event_views(events: Array, player: Dictionary) -> void:
	while event_views.size() < events.size():
		var label := Label.new()
		label.add_theme_font_size_override("font_size", 15)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		event_layer.add_child(label)
		event_views.append(label)

	for index in range(event_views.size()):
		var label := event_views[index]
		if index >= events.size():
			label.visible = false
			continue
		var event = events[index]
		label.visible = true
		label.text = str(event.get("text", ""))
		label.add_theme_color_override("font_color", event.get("color", Color.WHITE))
		label.size = Vector2(110, 24)
		label.position = _world_to_screen(event.get("position", Vector2.ZERO), player) - Vector2(55, 16)


func _create_entity_view(entity: Dictionary) -> Dictionary:
	var data_id := int(entity.get("data_id", 0))
	var kind := str(entity.get("kind", "enemy"))
	var size := Vector2(90, 108)
	if kind == "player":
		size = Vector2(124, 142)
	elif kind == "boss":
		size = Vector2(156, 176)

	var root := Control.new()
	root.size = size
	entity_layer.add_child(root)

	var sprite := TextureRect.new()
	sprite.texture = textures.get("unit_%d" % data_id)
	sprite.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	sprite.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	sprite.size = Vector2(size.x, size.y - 16)
	root.add_child(sprite)

	var hp_bg := ColorRect.new()
	hp_bg.color = Color(0.09, 0.06, 0.05, 0.82)
	hp_bg.position = Vector2(12, size.y - 13)
	hp_bg.size = Vector2(size.x - 24, 5)
	root.add_child(hp_bg)

	var hp_fill := ColorRect.new()
	hp_fill.color = Color(0.36, 0.9, 0.44) if kind == "player" else Color(0.95, 0.22, 0.16)
	hp_fill.position = hp_bg.position
	hp_fill.size = hp_bg.size
	root.add_child(hp_fill)

	return {
		"root": root,
		"hp": hp_fill,
		"hp_width": hp_bg.size.x,
	}


func _clear_entity_views() -> void:
	for view in entity_views.values():
		view["root"].queue_free()
	entity_views.clear()
	for label in event_views:
		label.queue_free()
	event_views.clear()


func _world_to_screen(world_position: Vector2, player: Dictionary) -> Vector2:
	var viewport_size := get_viewport_rect().size
	var center := viewport_size * 0.5
	var player_pos = Vector2(1500, 1000)
	if not player.is_empty():
		player_pos = player.get("position", player_pos)
	return center + (world_position - player_pos) * 0.62


func _resource_chip(resource_key: String) -> PanelContainer:
	var chip := PanelContainer.new()
	chip.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	chip.add_theme_stylebox_override("panel", _style(Color(0.1, 0.13, 0.1, 0.8), Color(0.65, 0.5, 0.28, 0.76), 7))

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 4)
	chip.add_child(row)

	var icon := TextureRect.new()
	icon.texture = textures.get("res_%s" % resource_key)
	icon.custom_minimum_size = Vector2(24, 24)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	row.add_child(icon)

	var value := Label.new()
	value.text = "0"
	value.add_theme_font_size_override("font_size", 14)
	value.add_theme_color_override("font_color", Color(1.0, 0.92, 0.72))
	row.add_child(value)
	home_resource_labels[resource_key] = value
	return chip


func _battle_resource_chip(resource_key: String) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 3)
	var icon := TextureRect.new()
	icon.texture = textures.get("res_%s" % resource_key)
	icon.custom_minimum_size = Vector2(18, 18)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	row.add_child(icon)
	var label := _battle_stat_label("0")
	row.add_child(label)
	battle_resource_labels[resource_key] = label
	return row


func _battle_stat_label(text: String) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 13)
	label.add_theme_color_override("font_color", Color(0.96, 0.91, 0.76))
	return label


func _build_equipment_strip(parent: HBoxContainer) -> void:
	for item in store.get_equipment_sample(7):
		var slot := PanelContainer.new()
		slot.custom_minimum_size = Vector2(64, 72)
		slot.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		slot.add_theme_stylebox_override("panel", _style(Color(0.09, 0.11, 0.1, 0.84), Color(0.5, 0.39, 0.24, 0.8), 7))
		parent.add_child(slot)

		var box := VBoxContainer.new()
		box.alignment = BoxContainer.ALIGNMENT_CENTER
		slot.add_child(box)

		var icon := TextureRect.new()
		icon.texture = textures.get("equip_%s" % str(item.get("type", "Weapon")))
		icon.custom_minimum_size = Vector2(38, 38)
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		box.add_child(icon)

		var label := Label.new()
		label.text = str(item.get("type", "장비"))
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.add_theme_font_size_override("font_size", 10)
		label.add_theme_color_override("font_color", Color(0.86, 0.78, 0.62))
		box.add_child(label)


func _add_skill_chip(parent: HBoxContainer, texture_key: String, label_text: String) -> void:
	var chip := PanelContainer.new()
	chip.custom_minimum_size = Vector2(94, 74)
	chip.add_theme_stylebox_override("panel", _style(Color(0.08, 0.1, 0.09, 0.86), Color(0.83, 0.63, 0.33, 0.9), 8))
	parent.add_child(chip)

	var box := VBoxContainer.new()
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	chip.add_child(box)

	var icon := TextureRect.new()
	icon.texture = textures.get(texture_key)
	icon.custom_minimum_size = Vector2(36, 36)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	box.add_child(icon)

	var label := Label.new()
	label.text = label_text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 12)
	label.add_theme_color_override("font_color", Color(1.0, 0.9, 0.68))
	box.add_child(label)


func _add_battle_prop(texture_key: String, position: Vector2, size: Vector2, rotation := 0.0) -> void:
	var prop := TextureRect.new()
	prop.texture = textures.get(texture_key)
	prop.position = position
	prop.size = size
	prop.rotation = rotation
	prop.modulate = Color(0.88, 0.9, 0.82, 0.78)
	prop.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	prop.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	world_layer.add_child(prop)


func _add_fullscreen_texture(parent: Control, texture: Texture2D, fallback: Color) -> void:
	if texture == null:
		var color := ColorRect.new()
		color.color = fallback
		color.set_anchors_preset(Control.PRESET_FULL_RECT)
		parent.add_child(color)
		return

	var rect := TextureRect.new()
	rect.texture = texture
	rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	parent.add_child(rect)


func _add_overlay(parent: Control, color: Color) -> void:
	var overlay := ColorRect.new()
	overlay.color = color
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	parent.add_child(overlay)


func _load_texture(relative_path: String) -> Texture2D:
	var image := Image.new()
	var path := store.runtime_asset_path(relative_path)
	var err := image.load(path)
	if err != OK:
		push_warning("Missing ninja2 texture: %s" % path)
		return null
	return ImageTexture.create_from_image(image)


func _style(bg: Color, border: Color, radius := 6) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = bg
	style.border_color = border
	style.border_width_left = 1
	style.border_width_right = 1
	style.border_width_top = 1
	style.border_width_bottom = 1
	style.corner_radius_top_left = radius
	style.corner_radius_top_right = radius
	style.corner_radius_bottom_left = radius
	style.corner_radius_bottom_right = radius
	style.content_margin_left = 10
	style.content_margin_right = 10
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	return style
