extends Control

const VIEW_SIZE := Vector2(540.0, 960.0)
const WORLD_SIZE := Vector2(3400.0, 3400.0)
const WORLD_CENTER := WORLD_SIZE * 0.5
const PLAYER_SPEED := 292.0
const PLAYER_MAX_HP := 620.0
const BASE_ATTACK_DAMAGE := 43.0
const ATTACK_COOLDOWN := 0.52
const ATTACK_RADIUS := 188.0
const ATTACK_ARC_DEGREES := 138.0
const PICKUP_COLLECT_RADIUS := 34.0
const PICKUP_MAGNET_RADIUS := 182.0
const PICKUP_SPEED := 690.0
const PICKUP_ARM_DELAY := 0.48
const PICKUP_TTL := 22.0
const MAX_ENEMIES := 108
const RUN_SECONDS := 180.0
const CONTACT_DAMAGE_SCALE := 0.72
const ENEMY_SEPARATION_STRENGTH := 0.78
const FIELD_ITEM_SPAWN_INTERVAL := 3.5
const FIELD_ITEM_MAX_ACTIVE := 5
const FIELD_ITEM_COLLECT_RADIUS := 56.0
const FIELD_ITEM_TTL := 15.0
const FIELD_ITEM_MINE_TTL := 24.0
const FIELD_ITEM_MINE_RADIUS := 88.0
const FIELD_ITEM_MINE_HOLD := 1.5
const FIELD_ITEM_MAGNET_DURATION := 5.2
const PLAYER_SPRITE_HEIGHT := 86.0
const THREAT_RING_RADIUS := 118.0
const FIELD_ITEM_TYPES := ["bomb", "magnet", "potion", "mine"]
const FIELD_ITEM_WEIGHTS := {
	"bomb": 30,
	"magnet": 22,
	"potion": 24,
	"mine": 24,
}
const MODE_HOME := "home"
const MODE_BATTLE := "battle"
const GENERATED_HOME_SCENE_PATH := "res://scenes/generated/outgame_home.tscn"
const GENERATED_HUD_SCENE_PATH := "res://scenes/generated/tangtang_battle_hud.tscn"
const GeneratedHudPrimitives := preload("res://scripts/generated_hud_primitives.gd")
const TEX_HAEIL_DOWN := preload("res://assets/generated/units/haeil_down.png")
const TEX_HAEIL_DOWN_WALK_B := preload("res://assets/generated/units/haeil_down_walk_b.png")
const TEX_HAEIL_LEFT := preload("res://assets/generated/units/haeil_left.png")
const TEX_HAEIL_LEFT_WALK_B := preload("res://assets/generated/units/haeil_left_walk_b.png")
const TEX_HAEIL_RIGHT := preload("res://assets/generated/units/haeil_right.png")
const TEX_HAEIL_RIGHT_WALK_B := preload("res://assets/generated/units/haeil_right_walk_b.png")
const TEX_HAEIL_UP := preload("res://assets/generated/units/haeil_up.png")
const TEX_HAEIL_UP_WALK_B := preload("res://assets/generated/units/haeil_up_walk_b.png")
const TEX_HAEIL_LOBBY_V2 := preload("res://assets/generated/units/haeil_lobby_v2.png")
const TEX_MONSTER_JAPGWI := preload("res://assets/generated/units/monster_japgwi.png")
const TEX_MONSTER_JAPGWI_WALK_B := preload("res://assets/generated/units/monster_japgwi_walk_b.png")
const TEX_MONSTER_GRUNT := preload("res://assets/generated/units/monster_grunt.png")
const TEX_MONSTER_GRUNT_WALK_B := preload("res://assets/generated/units/monster_grunt_walk_b.png")
const TEX_MONSTER_GHOST := preload("res://assets/generated/units/monster_ghost.png")
const TEX_MONSTER_GHOST_WALK_B := preload("res://assets/generated/units/monster_ghost_walk_b.png")
const TEX_MONSTER_TALISMAN_CASTER := preload("res://assets/generated/units/monster_talisman_caster.png")
const TEX_MONSTER_TALISMAN_CASTER_WALK_B := preload("res://assets/generated/units/monster_talisman_caster_walk_b.png")
const TEX_MONSTER_NIGHT_OGRE := preload("res://assets/generated/units/monster_night_ogre.png")
const TEX_MONSTER_NIGHT_OGRE_WALK_B := preload("res://assets/generated/units/monster_night_ogre_walk_b.png")
const TEX_OUTGAME_CARD := preload("res://assets/generated/ui/outgame_parchment_card_9slice.png")
const TEX_OUTGAME_CHIP := preload("res://assets/generated/ui/outgame_resource_chip_9slice.png")
const TEX_OUTGAME_CTA := preload("res://assets/generated/ui/outgame_sortie_cta_9slice.png")
const TEX_OUT_TAB_CELL := preload("res://assets/generated/ui/outgame_bottom_tab_cell_9slice.png")
const TEX_OUTGAME_TAB_SELECTED := preload("res://assets/generated/ui/outgame_tab_selected_9slice.png")
const TEX_OUT_ICON_STAMINA := preload("res://assets/generated/ui/outgame_icon_stamina.png")
const TEX_OUT_ICON_COIN := preload("res://assets/generated/ui/outgame_icon_coin.png")
const TEX_OUT_ICON_GEM := preload("res://assets/generated/ui/outgame_icon_gem.png")
const TEX_OUT_ICON_MAIL := preload("res://assets/generated/ui/outgame_icon_mail.png")
const TEX_OUT_ICON_HOME := preload("res://assets/generated/ui/outgame_icon_home.png")
const TEX_OUT_ICON_YOKAI := preload("res://assets/generated/ui/outgame_icon_yokai.png")
const TEX_OUT_ICON_WEAPON := preload("res://assets/generated/ui/outgame_icon_weapon.png")
const TEX_OUT_ICON_TALISMAN := preload("res://assets/generated/ui/outgame_icon_talisman.png")
const TEX_OUT_ICON_SHOP := preload("res://assets/generated/ui/outgame_icon_shop.png")
const TEX_OUT_ICON_CHEST := preload("res://assets/generated/ui/outgame_icon_chest.png")
const TEX_OUT_ICON_TRAINING := preload("res://assets/generated/ui/outgame_icon_training.png")
const TEX_OUT_ICON_RELIC := preload("res://assets/generated/ui/outgame_icon_relic.png")
const TEX_OUT_ICON_BOSS := preload("res://assets/generated/ui/outgame_icon_boss.png")
const TEX_OUT_EVENT_DAILY_V2 := preload("res://assets/generated/ui/outgame_event_daily_v2.png")
const TEX_OUT_EVENT_RELIC_V2 := preload("res://assets/generated/ui/outgame_event_relic_v2.png")
const TEX_OUT_EVENT_BOSS_V2 := preload("res://assets/generated/ui/outgame_event_boss_v2.png")
const TEX_OUT_EVENT_LOCKED_V2 := preload("res://assets/generated/ui/outgame_event_locked_v2.png")
const TEX_OUT_EVENT_CHEST_V2 := preload("res://assets/generated/ui/outgame_event_chest_v2.png")
const TEX_OUT_COMMAND_REWARD_V2 := preload("res://assets/generated/ui/outgame_command_reward_v2.png")
const TEX_OUT_COMMAND_TRAINING_V2 := preload("res://assets/generated/ui/outgame_command_training_v2.png")
const TEX_OUT_SORTIE_CTA_V2 := preload("res://assets/generated/ui/outgame_sortie_cta_v2.png")
const TEX_OUT_TAB_HOME_V2 := preload("res://assets/generated/ui/outgame_tab_home_v2.png")
const TEX_OUT_TAB_YOKAI_V2 := preload("res://assets/generated/ui/outgame_tab_yokai_v2.png")
const TEX_OUT_TAB_WEAPON_V2 := preload("res://assets/generated/ui/outgame_tab_weapon_v2.png")
const TEX_OUT_TAB_TALISMAN_V2 := preload("res://assets/generated/ui/outgame_tab_talisman_v2.png")
const TEX_OUT_TAB_SHOP_V2 := preload("res://assets/generated/ui/outgame_tab_shop_v2.png")
const TEX_OUT_TOP_PROFILE_CHIP_V2 := preload("res://assets/generated/ui/outgame_top_profile_chip_v2.png")
const TEX_OUT_TOP_RESOURCE_CHIP_V2 := preload("res://assets/generated/ui/outgame_top_resource_chip_v2.png")
const TEX_OUT_TOP_MAIL_BUTTON_V2 := preload("res://assets/generated/ui/outgame_top_mail_button_v2.png")
const TEX_OUT_RESOURCE_STAMINA_V2 := preload("res://assets/generated/ui/outgame_resource_stamina_v2.png")
const TEX_OUT_RESOURCE_COIN_V2 := preload("res://assets/generated/ui/outgame_resource_coin_v2.png")
const TEX_OUT_RESOURCE_GEM_V2 := preload("res://assets/generated/ui/outgame_resource_gem_v2.png")
const TEX_OUT_COURTYARD_BG_V2 := preload("res://assets/generated/backgrounds/outgame_courtyard_bg_v2.png")

var rng := RandomNumberGenerator.new()
var player := {
	"pos": WORLD_CENTER,
	"hp": PLAYER_MAX_HP,
	"max_hp": PLAYER_MAX_HP,
	"facing": Vector2.RIGHT,
}
var enemies: Array = []
var pickups: Array = []
var field_items: Array = []
var fx_events: Array = []
var level_choices: Array = []
var skill_levels := {
	"vortex": 0,
	"wave": 0,
	"spiritfire": 0,
	"ward": 0,
}
var skill_timers := {
	"vortex": 1.3,
	"wave": 2.0,
	"spiritfire": 1.0,
	"ward": 4.2,
}
var elapsed := 0.0
var spawn_timer := 0.0
var field_item_timer := 0.0
var magnet_remaining := 0.0
var attack_timer := 0.0
var run_level := 1
var run_exp := 0
var exp_to_next := 18
var kills := 0
var purified := 0
var next_id := 1
var next_pickup_id := 1
var next_field_item_id := 1
var running := true
var result := ""
var choice_pending := false
var injected_move := Vector2.ZERO
var use_injected_move := false
var test_mode := false
var camera_pos := WORLD_CENTER
var screen_mode := MODE_HOME
var generated_home_surface: Control
var generated_hud_surface: Control
var generated_hud_primitives: Control
var use_generated_hud := false
var player_moving := false
var player_walk_phase := 0.0


func _ready() -> void:
	rng.randomize()
	custom_minimum_size = VIEW_SIZE
	mouse_filter = Control.MOUSE_FILTER_PASS
	_attach_generated_hud_surface()
	_attach_generated_home_surface()
	show_home()


func restart_run() -> void:
	screen_mode = MODE_BATTLE
	player = {
		"pos": WORLD_CENTER,
		"hp": PLAYER_MAX_HP,
		"max_hp": PLAYER_MAX_HP,
		"facing": Vector2.RIGHT,
	}
	enemies.clear()
	pickups.clear()
	field_items.clear()
	fx_events.clear()
	level_choices.clear()
	skill_levels = {
		"vortex": 0,
		"wave": 0,
		"spiritfire": 0,
		"ward": 0,
	}
	skill_timers = {
		"vortex": 1.1,
		"wave": 1.8,
		"spiritfire": 0.8,
		"ward": 3.4,
	}
	elapsed = 0.0
	spawn_timer = 0.0
	field_item_timer = min(1.6, FIELD_ITEM_SPAWN_INTERVAL)
	magnet_remaining = 0.0
	attack_timer = 0.12
	run_level = 1
	run_exp = 0
	exp_to_next = 18
	kills = 0
	purified = 0
	next_id = 1
	next_pickup_id = 1
	next_field_item_id = 1
	running = true
	result = ""
	choice_pending = false
	camera_pos = WORLD_CENTER
	player_moving = false
	player_walk_phase = 0.0
	if generated_home_surface != null:
		generated_home_surface.visible = false
	for i in range(30):
		_spawn_enemy("japgwi", i * TAU / 30.0, 520.0 + float(i % 5) * 42.0)
	_sync_generated_hud()
	queue_redraw()


func show_home() -> void:
	screen_mode = MODE_HOME
	running = false
	result = ""
	choice_pending = false
	if generated_hud_surface != null:
		generated_hud_surface.visible = false
	if generated_hud_primitives != null:
		generated_hud_primitives.visible = false
	_sync_generated_home()
	queue_redraw()


func set_test_mode(enabled: bool) -> void:
	test_mode = enabled
	if enabled:
		rng.seed = 47031


func inject_move(vector: Vector2) -> void:
	use_injected_move = true
	injected_move = vector.limit_length(1.0)


func clear_injected_move() -> void:
	use_injected_move = false
	injected_move = Vector2.ZERO


func debug_snapshot() -> Dictionary:
	return {
		"running": running,
		"result": result,
		"elapsed": elapsed,
		"level": run_level,
		"exp": run_exp,
		"exp_to_next": exp_to_next,
		"kills": kills,
		"purified": purified,
		"enemy_count": enemies.size(),
		"pickup_count": pickups.size(),
		"field_item_count": field_items.size(),
		"choice_pending": choice_pending,
		"skills": skill_levels.duplicate(true),
		"screen_mode": screen_mode,
		"generated_home_loaded": generated_home_surface != null,
		"generated_home_visible": generated_home_surface != null and generated_home_surface.visible,
		"generated_hud_loaded": generated_hud_surface != null,
		"generated_hud_visible": generated_hud_surface != null and generated_hud_surface.visible,
		"player_hp": player.get("hp", 0.0),
		"player_pos": player.get("pos", Vector2.ZERO),
		"nearest_enemy_distance": _nearest_enemy_distance(),
		"magnet_remaining": magnet_remaining,
		"boss_present": _has_boss(),
	}


func _attach_generated_hud_surface() -> void:
	if not ResourceLoader.exists(GENERATED_HUD_SCENE_PATH):
		return
	var packed := load(GENERATED_HUD_SCENE_PATH)
	if not (packed is PackedScene):
		return
	generated_hud_surface = (packed as PackedScene).instantiate() as Control
	if generated_hud_surface == null:
		return
	generated_hud_surface.name = "GeneratedHudSurface"
	generated_hud_surface.visible = true
	generated_hud_surface.mouse_filter = Control.MOUSE_FILTER_IGNORE
	generated_hud_surface.set_anchors_preset(Control.PRESET_FULL_RECT)
	_set_mouse_filter_recursive(generated_hud_surface, Control.MOUSE_FILTER_IGNORE)
	add_child(generated_hud_surface)
	generated_hud_primitives = GeneratedHudPrimitives.new()
	generated_hud_primitives.name = "GeneratedHudPrimitiveLayer"
	generated_hud_primitives.set_anchors_preset(Control.PRESET_FULL_RECT)
	generated_hud_primitives.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(generated_hud_primitives)
	use_generated_hud = true
	_style_generated_hud_surface()
	_sync_generated_hud()


func _attach_generated_home_surface() -> void:
	if not ResourceLoader.exists(GENERATED_HOME_SCENE_PATH):
		return
	var packed := load(GENERATED_HOME_SCENE_PATH)
	if not (packed is PackedScene):
		return
	generated_home_surface = (packed as PackedScene).instantiate() as Control
	if generated_home_surface == null:
		return
	generated_home_surface.name = "GeneratedHomeSurface"
	generated_home_surface.visible = false
	generated_home_surface.mouse_filter = Control.MOUSE_FILTER_PASS
	generated_home_surface.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(generated_home_surface)
	_style_generated_home_surface()
	_sync_generated_home()


func _set_mouse_filter_recursive(node: Node, filter: int) -> void:
	if node is Control:
		(node as Control).mouse_filter = filter
	for child in node.get_children():
		_set_mouse_filter_recursive(child, filter)


func _style_generated_home_surface() -> void:
	if generated_home_surface == null:
		return
	var dark_panel := Color(0.055, 0.042, 0.030, 0.88)
	var dark_border := Color(0.72, 0.55, 0.28, 0.92)
	for path in ["Section_TopResourceBar/Panel_Profile", "Section_TopResourceBar/Panel_StaminaChip", "Section_TopResourceBar/Panel_CoinChip", "Section_TopResourceBar/Panel_GemChip"]:
		_configure_home_panel_texture(path, TEX_OUTGAME_CHIP, Vector4(18, 18, 18, 18))
	for path in [
		"Section_EventRail/Panel_EventDaily",
		"Section_EventRail/Panel_EventRelic",
		"Section_EventRail/Panel_EventBoss",
		"Section_EventRail/Panel_EventLocked",
		"Section_EventRail/Panel_EventChest",
		"Section_ProgressionCards/Panel_IdleReward",
		"Section_ProgressionCards/Panel_Training",
	]:
		_configure_home_panel_texture(path, TEX_OUTGAME_CARD, Vector4(24, 24, 24, 24))
	_configure_home_button_texture("Section_SortieCta/Btn_Sortie", TEX_OUTGAME_CTA, Vector4(24, 24, 24, 24))
	_configure_home_button("Section_TopResourceBar/Btn_Mail", dark_panel, dark_border, 4)
	_set_home_button_text("Section_TopResourceBar/Btn_Mail", "")
	var tabs := [
		["Section_BottomNav/Btn_TabHome", "홈", true],
		["Section_BottomNav/Btn_TabYokai", "요괴", false],
		["Section_BottomNav/Btn_TabWeapon", "무기", false],
		["Section_BottomNav/Btn_TabTalisman", "부적", false],
		["Section_BottomNav/Btn_TabShop", "상점", false],
	]
	for item in tabs:
		_configure_home_tab_button(str(item[0]), bool(item[2]))
		_set_home_button_text(str(item[0]), "")
		_ensure_label_child(str(item[0]), "Text_TabLabel", str(item[1]), Rect2(0, 58, 108, 20), 12, Color(0.96, 0.86, 0.62), HORIZONTAL_ALIGNMENT_CENTER)
	_add_home_icons()
	_style_home_top_bar_overlays()
	_style_home_quick_bar_overlays()
	_style_home_command_bar_overlays()
	_style_home_bottom_bar_overlays()
	_style_home_hero_stage_overlays()
	_configure_home_label("Section_SortieCta/Btn_Sortie/Text_SortieTitle", 23, Color(1.0, 0.88, 0.62), HORIZONTAL_ALIGNMENT_CENTER)
	_configure_home_label("Section_SortieCta/Btn_Sortie/Text_SortieStage", 13, Color(0.20, 0.075, 0.025), HORIZONTAL_ALIGNMENT_CENTER)
	var sortie := generated_home_surface.get_node_or_null("Section_SortieCta/Btn_Sortie") as Button
	if sortie != null:
		sortie.position = Vector2(0, 8)
		sortie.size = Vector2(168, 116)
		sortie.disabled = false
		sortie.mouse_filter = Control.MOUSE_FILTER_STOP
		if not sortie.pressed.is_connected(Callable(self, "restart_run")):
			sortie.pressed.connect(Callable(self, "restart_run"))


func _style_home_top_bar_overlays() -> void:
	_hide_home_node("Section_TopResourceBar/Panel_Profile/Text_ProfileName")
	_hide_home_node("Section_TopResourceBar/Panel_Profile/Text_ProfileRank")
	_hide_home_node("Section_TopResourceBar/Panel_Profile/Progress_ProfileStamina")
	_hide_home_node("Section_TopResourceBar/Panel_StaminaChip/Text_StaminaValue")
	_hide_home_node("Section_TopResourceBar/Panel_CoinChip/Text_CoinValue")
	_hide_home_node("Section_TopResourceBar/Panel_GemChip/Text_GemValue")
	_hide_home_node("Section_TopResourceBar/Btn_Mail/Icon_Mail")
	_ensure_texture_child("Section_TopResourceBar", "Skin_ProfileChip", TEX_OUT_TOP_PROFILE_CHIP_V2, Rect2(0, 0, 150, 50), 2)
	_ensure_texture_child("Section_TopResourceBar", "Skin_StaminaChip", TEX_OUT_TOP_RESOURCE_CHIP_V2, Rect2(158, 4, 92, 42), 2)
	_ensure_texture_child("Section_TopResourceBar", "Skin_CoinChip", TEX_OUT_TOP_RESOURCE_CHIP_V2, Rect2(254, 4, 96, 42), 2)
	_ensure_texture_child("Section_TopResourceBar", "Skin_GemChip", TEX_OUT_TOP_RESOURCE_CHIP_V2, Rect2(354, 4, 96, 42), 2)
	_ensure_texture_child("Section_TopResourceBar/Btn_Mail", "Skin_MailButton", TEX_OUT_TOP_MAIL_BUTTON_V2, Rect2(0, 0, 48, 48), 2)
	_ensure_texture_child("Section_TopResourceBar", "Icon_ProfileMask", TEX_OUT_TAB_YOKAI_V2, Rect2(8, 7, 36, 36), 4)
	_ensure_label_child("Section_TopResourceBar", "Text_ProfileNameOverlay", "해일", Rect2(66, 8, 66, 18), 15, Color(0.98, 0.88, 0.64), HORIZONTAL_ALIGNMENT_LEFT)
	_ensure_label_child("Section_TopResourceBar", "Text_ProfileRankOverlay", "도깨비 Lv.12", Rect2(66, 25, 76, 15), 11, Color(0.66, 0.92, 1.0), HORIZONTAL_ALIGNMENT_LEFT)
	_ensure_bar_child("Section_TopResourceBar", "Progress_ProfileStaminaOverlay", Rect2(66, 42, 58, 6), 0.72, Color(0.20, 0.68, 1.0), Color(0.035, 0.055, 0.07))
	_ensure_label_child("Section_TopResourceBar", "Text_StaminaOverlay", "48/60", Rect2(190, 14, 40, 18), 13, Color(0.98, 0.90, 0.68), HORIZONTAL_ALIGNMENT_CENTER)
	_ensure_label_child("Section_TopResourceBar", "Text_CoinOverlay", "12.4K", Rect2(286, 14, 42, 18), 13, Color(0.98, 0.90, 0.68), HORIZONTAL_ALIGNMENT_CENTER)
	_ensure_label_child("Section_TopResourceBar", "Text_GemOverlay", "820", Rect2(386, 14, 38, 18), 13, Color(0.98, 0.90, 0.68), HORIZONTAL_ALIGNMENT_CENTER)
	_ensure_dot_child("Section_TopResourceBar", "Dot_MailAlert", Vector2(512, 10), 5.0, Color(1.0, 0.42, 0.10, 0.96))


func _style_home_quick_bar_overlays() -> void:
	var entries := [
		["Daily", 0.0, "일일 수련", TEX_OUT_EVENT_DAILY_V2, true, 0.76],
		["Relic", 100.0, "법기 강화", TEX_OUT_EVENT_RELIC_V2, false, 0.48],
		["Boss", 200.0, "밤도깨비", TEX_OUT_EVENT_BOSS_V2, true, 0.34],
		["Locked", 300.0, "문파 준비중", TEX_OUT_EVENT_LOCKED_V2, false, 0.18],
		["Chest", 400.0, "보물 상자", TEX_OUT_EVENT_CHEST_V2, true, 0.62],
	]
	for item in entries:
		var key := str(item[0])
		var y := float(item[1])
		_hide_home_node("Section_EventRail/Panel_Event%s/Text_Event%s" % [key, key])
		_hide_home_node("Section_EventRail/Icon_Event%s" % key)
		_ensure_texture_child("Section_EventRail", "Skin_Event%s" % key, item[3] as Texture2D, Rect2(4, y, 150, 90), 2)
		_ensure_color_rect_child("Section_EventRail", "LabelBack_Event%s" % key, Rect2(24, y + 59.0, 110, 18), Color(0.04, 0.025, 0.012, 0.58), 3)
		_ensure_label_child("Section_EventRail", "Text_Event%sOverlay" % key, str(item[2]), Rect2(24, y + 58.0, 110, 20), 12, Color(0.98, 0.86, 0.60), HORIZONTAL_ALIGNMENT_CENTER)
		_ensure_pip_row_child("Section_EventRail", "Pips_Event%s" % key, Vector2(51, y + 80.0), 5, int(round(float(item[5]) * 5.0)), Color(0.22, 0.70, 1.0, 0.96), Color(0.33, 0.27, 0.17, 0.72))
		if bool(item[4]):
			_ensure_dot_child("Section_EventRail", "Dot_Event%sAlert" % key, Vector2(144, y + 10.0), 7.0, Color(1.0, 0.42, 0.10, 0.98))


func _style_home_command_bar_overlays() -> void:
	_hide_home_node("Section_ProgressionCards/Panel_IdleReward/Text_IdleRewardTitle")
	_hide_home_node("Section_ProgressionCards/Panel_IdleReward/Progress_IdleReward")
	_hide_home_node("Section_ProgressionCards/Panel_Training/Text_TrainingTitle")
	_hide_home_node("Section_ProgressionCards/Panel_Training/Progress_Training")
	_hide_home_node("Section_ProgressionCards/Icon_IdleChest")
	_hide_home_node("Section_ProgressionCards/Icon_Training")
	_ensure_texture_child("Section_ProgressionCards", "Skin_IdleRewardV2", TEX_OUT_COMMAND_REWARD_V2, Rect2(0, 0, 164, 164), 2)
	_ensure_texture_child("Section_ProgressionCards", "Skin_TrainingV2", TEX_OUT_COMMAND_TRAINING_V2, Rect2(174, 0, 164, 164), 2)
	_ensure_texture_child("Section_SortieCta/Btn_Sortie", "Skin_SortieCtaV2", TEX_OUT_SORTIE_CTA_V2, Rect2(0, 0, 168, 116), 2)
	_ensure_label_child("Section_ProgressionCards", "Text_IdleRewardOverlay", "방치 보상", Rect2(18, 86, 128, 20), 13, Color(0.10, 0.055, 0.025), HORIZONTAL_ALIGNMENT_CENTER)
	_ensure_color_rect_child("Section_ProgressionCards", "Chip_IdleRewardClaimBack", Rect2(43, 115, 78, 16), Color(0.15, 0.065, 0.025, 0.42), 3)
	_ensure_label_child("Section_ProgressionCards", "Text_IdleRewardClaimOverlay", "수령 가능", Rect2(38, 113, 88, 18), 11, Color(0.96, 0.82, 0.52), HORIZONTAL_ALIGNMENT_CENTER)
	_ensure_bar_child("Section_ProgressionCards", "Bar_IdleRewardOverlay", Rect2(32, 134, 100, 7), 0.82, Color(0.97, 0.58, 0.16), Color(0.17, 0.09, 0.04))
	_ensure_label_child("Section_ProgressionCards", "Text_TrainingOverlay", "수련 현황", Rect2(192, 86, 128, 20), 13, Color(0.10, 0.055, 0.025), HORIZONTAL_ALIGNMENT_CENTER)
	_ensure_color_rect_child("Section_ProgressionCards", "Chip_TrainingSubBack", Rect2(217, 115, 78, 16), Color(0.15, 0.065, 0.025, 0.36), 3)
	_ensure_label_child("Section_ProgressionCards", "Text_TrainingSubOverlay", "창술 Lv.3", Rect2(212, 113, 88, 18), 11, Color(0.96, 0.82, 0.52), HORIZONTAL_ALIGNMENT_CENTER)
	_ensure_bar_child("Section_ProgressionCards", "Bar_TrainingOverlay", Rect2(206, 134, 100, 7), 0.46, Color(0.20, 0.68, 1.0), Color(0.17, 0.09, 0.04))
	_set_home_control_rect("Section_SortieCta/Btn_Sortie/Text_SortieTitle", Rect2(6, 34, 156, 32))
	_set_home_control_rect("Section_SortieCta/Btn_Sortie/Text_SortieStage", Rect2(6, 65, 156, 18))
	_ensure_texture_child("Section_SortieCta/Btn_Sortie", "Icon_SortieStamina", TEX_OUT_ICON_STAMINA, Rect2(33, 86, 18, 18))
	_ensure_label_child("Section_SortieCta/Btn_Sortie", "Text_SortieCost", "기력 5", Rect2(50, 85, 68, 20), 11, Color(0.18, 0.065, 0.02), HORIZONTAL_ALIGNMENT_CENTER)


func _style_home_bottom_bar_overlays() -> void:
	_ensure_color_rect_child("Section_BottomNav", "Back_DockShadow", Rect2(0, 5, 540, 107), Color(0.018, 0.012, 0.007, 0.72), -4)
	_ensure_color_rect_child("Section_BottomNav", "Rail_DockTopDark", Rect2(0, 6, 540, 5), Color(0.035, 0.022, 0.012, 0.90), -3)
	_ensure_color_rect_child("Section_BottomNav", "Rail_DockBottomDark", Rect2(0, 105, 540, 7), Color(0.025, 0.016, 0.009, 0.92), -3)
	_ensure_color_rect_child("Section_BottomNav", "Rail_DockGoldHairline", Rect2(0, 10, 540, 1), Color(0.74, 0.50, 0.22, 0.72), 0)
	var tabs := [
		["Section_BottomNav/Btn_TabHome", "홈", true],
		["Section_BottomNav/Btn_TabYokai", "요괴", false],
		["Section_BottomNav/Btn_TabWeapon", "무기", false],
		["Section_BottomNav/Btn_TabTalisman", "부적", false],
		["Section_BottomNav/Btn_TabShop", "상점", false],
	]
	for i in range(tabs.size()):
		var path := str(tabs[i][0])
		var label := str(tabs[i][1])
		var selected := bool(tabs[i][2])
		_set_home_control_rect(path, Rect2(float(i) * 108.0, 8.0, 108.0, 96.0))
		_ensure_texture_child(path, "Skin_TabCellNormal", TEX_OUT_TAB_CELL, Rect2(0, 0, 108, 96), 1)
		_ensure_label_child(path, "Text_TabLabel", label, Rect2(0, 65, 108, 20), 12, Color(0.62, 0.92, 1.0) if selected else Color(0.96, 0.86, 0.62), HORIZONTAL_ALIGNMENT_CENTER)
	_ensure_texture_child("Section_BottomNav/Btn_TabHome", "Skin_TabSelected", TEX_OUTGAME_TAB_SELECTED, Rect2(0, 0, 108, 96), 2)
	_ensure_bar_child("Section_BottomNav", "Bar_SelectedTabGlow", Rect2(29, 103, 50, 4), 1.0, Color(0.20, 0.68, 1.0, 0.94), Color(0.20, 0.68, 1.0, 0.12))
	_ensure_pip_row_child("Section_BottomNav", "Marker_SelectedTabDiamond", Vector2(50, 100), 1, 1, Color(0.25, 0.76, 1.0, 0.96), Color(0.20, 0.68, 1.0, 0.28))
	_ensure_dot_child("Section_BottomNav/Btn_TabYokai", "Dot_TabYokaiAlert", Vector2(88, 13), 5.0, Color(1.0, 0.42, 0.10, 0.96))
	_ensure_dot_child("Section_BottomNav/Btn_TabTalisman", "Dot_TabTalismanAlert", Vector2(88, 13), 5.0, Color(1.0, 0.42, 0.10, 0.96))


func _style_home_hero_stage_overlays() -> void:
	_hide_home_node("Section_HeroStage/Tex_HaeilLobby")
	_ensure_texture_child("Section_HeroStage", "Tex_HaeilLobbyV2", TEX_HAEIL_LOBBY_V2, Rect2(0, 124, 320, 498), 2)


func _add_home_icons() -> void:
	_ensure_texture_child("Section_TopResourceBar", "Icon_Stamina", TEX_OUT_RESOURCE_STAMINA_V2, Rect2(173, 14, 28, 28), 4)
	_ensure_texture_child("Section_TopResourceBar", "Icon_Coin", TEX_OUT_RESOURCE_COIN_V2, Rect2(273, 14, 28, 28), 4)
	_ensure_texture_child("Section_TopResourceBar", "Icon_Gem", TEX_OUT_RESOURCE_GEM_V2, Rect2(377, 14, 28, 28), 4)
	_ensure_texture_child("Section_TopResourceBar/Btn_Mail", "Icon_Mail", TEX_OUT_ICON_MAIL, Rect2(9, 9, 30, 30), 4)
	_ensure_texture_child("Section_EventRail", "Icon_EventDaily", TEX_OUT_ICON_TRAINING, Rect2(60, 12, 42, 42))
	_ensure_texture_child("Section_EventRail", "Icon_EventRelic", TEX_OUT_ICON_RELIC, Rect2(60, 112, 42, 42))
	_ensure_texture_child("Section_EventRail", "Icon_EventBoss", TEX_OUT_ICON_BOSS, Rect2(60, 212, 42, 42))
	_ensure_texture_child("Section_EventRail", "Icon_EventLocked", TEX_OUT_ICON_TALISMAN, Rect2(60, 312, 42, 42))
	_ensure_texture_child("Section_EventRail", "Icon_EventChest", TEX_OUT_ICON_CHEST, Rect2(60, 412, 42, 42))
	_ensure_texture_child("Section_ProgressionCards", "Icon_IdleChest", TEX_OUT_ICON_CHEST, Rect2(56, 28, 52, 52))
	_ensure_texture_child("Section_ProgressionCards", "Icon_Training", TEX_OUT_ICON_TRAINING, Rect2(230, 28, 52, 52))
	_ensure_texture_child("Section_BottomNav/Btn_TabHome", "Icon_TabHome", TEX_OUT_TAB_HOME_V2, Rect2(29, 10, 50, 50), 4)
	_ensure_texture_child("Section_BottomNav/Btn_TabYokai", "Icon_TabYokai", TEX_OUT_TAB_YOKAI_V2, Rect2(30, 12, 48, 48), 4)
	_ensure_texture_child("Section_BottomNav/Btn_TabWeapon", "Icon_TabWeapon", TEX_OUT_TAB_WEAPON_V2, Rect2(30, 12, 48, 48), 4)
	_ensure_texture_child("Section_BottomNav/Btn_TabTalisman", "Icon_TabTalisman", TEX_OUT_TAB_TALISMAN_V2, Rect2(30, 12, 48, 48), 4)
	_ensure_texture_child("Section_BottomNav/Btn_TabShop", "Icon_TabShop", TEX_OUT_TAB_SHOP_V2, Rect2(30, 12, 48, 48), 4)


func _ensure_texture_child(parent_path: String, node_name: String, texture: Texture2D, rect: Rect2, z_index: int = 3) -> void:
	var parent := generated_home_surface.get_node_or_null(parent_path) as Control
	if parent == null:
		return
	var texture_rect := parent.get_node_or_null(node_name) as TextureRect
	if texture_rect == null:
		texture_rect = TextureRect.new()
		texture_rect.name = node_name
		parent.add_child(texture_rect)
	texture_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	texture_rect.texture = texture
	texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	texture_rect.set_offsets_preset(Control.PRESET_TOP_LEFT)
	texture_rect.position = rect.position
	texture_rect.size = rect.size
	texture_rect.z_index = z_index


func _ensure_label_child(parent_path: String, node_name: String, text: String, rect: Rect2, font_size: int, color: Color, alignment: HorizontalAlignment) -> void:
	var parent := generated_home_surface.get_node_or_null(parent_path) as Control
	if parent == null:
		return
	var label := parent.get_node_or_null(node_name) as Label
	if label == null:
		label = Label.new()
		label.name = node_name
		label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		parent.add_child(label)
	label.text = text
	label.position = rect.position
	label.size = rect.size
	label.horizontal_alignment = alignment
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.clip_text = true
	label.z_index = 6
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)


func _ensure_color_rect_child(parent_path: String, node_name: String, rect: Rect2, color: Color, z_index: int = 3) -> void:
	var parent := generated_home_surface.get_node_or_null(parent_path) as Control
	if parent == null:
		return
	var color_rect := parent.get_node_or_null(node_name) as ColorRect
	if color_rect == null:
		color_rect = ColorRect.new()
		color_rect.name = node_name
		color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		parent.add_child(color_rect)
	color_rect.position = rect.position
	color_rect.size = rect.size
	color_rect.color = color
	color_rect.z_index = z_index


func _ensure_pip_row_child(parent_path: String, node_name: String, origin: Vector2, count: int, active_count: int, active_color: Color, inactive_color: Color) -> void:
	var parent := generated_home_surface.get_node_or_null(parent_path) as Control
	if parent == null:
		return
	var group := parent.get_node_or_null(node_name) as Control
	if group == null:
		group = Control.new()
		group.name = node_name
		group.mouse_filter = Control.MOUSE_FILTER_IGNORE
		parent.add_child(group)
	group.position = origin
	group.size = Vector2(max(1, count) * 14, 12)
	group.z_index = 4
	for i in range(count):
		var pip_name := "Pip%d" % i
		var pip := group.get_node_or_null(pip_name) as Panel
		if pip == null:
			pip = Panel.new()
			pip.name = pip_name
			pip.mouse_filter = Control.MOUSE_FILTER_IGNORE
			group.add_child(pip)
		var style := StyleBoxFlat.new()
		style.bg_color = active_color if i < active_count else inactive_color
		style.border_color = Color(0.92, 0.72, 0.36, 0.86)
		style.set_border_width_all(1)
		style.set_corner_radius_all(1)
		pip.add_theme_stylebox_override("panel", style)
		pip.position = Vector2(float(i) * 14.0, 1.0)
		pip.size = Vector2(8, 8)
		pip.pivot_offset = Vector2(4, 4)
		pip.rotation = PI / 4.0
		pip.z_index = 1


func _ensure_dot_child(parent_path: String, node_name: String, center: Vector2, radius: float, color: Color) -> void:
	var parent := generated_home_surface.get_node_or_null(parent_path) as Control
	if parent == null:
		return
	var dot := parent.get_node_or_null(node_name) as Panel
	if dot == null:
		dot = Panel.new()
		dot.name = node_name
		dot.mouse_filter = Control.MOUSE_FILTER_IGNORE
		parent.add_child(dot)
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.border_color = Color(1.0, 0.86, 0.42, 0.95)
	style.set_border_width_all(1)
	style.set_corner_radius_all(int(radius))
	dot.add_theme_stylebox_override("panel", style)
	dot.position = center - Vector2(radius, radius)
	dot.size = Vector2(radius * 2.0, radius * 2.0)
	dot.z_index = 5


func _ensure_bar_child(parent_path: String, node_name: String, rect: Rect2, ratio: float, fill_color: Color, background_color: Color) -> void:
	var parent := generated_home_surface.get_node_or_null(parent_path) as Control
	if parent == null:
		return
	var background := parent.get_node_or_null(node_name) as ColorRect
	if background == null:
		background = ColorRect.new()
		background.name = node_name
		background.mouse_filter = Control.MOUSE_FILTER_IGNORE
		parent.add_child(background)
	var fill := background.get_node_or_null("Fill") as ColorRect
	if fill == null:
		fill = ColorRect.new()
		fill.name = "Fill"
		fill.mouse_filter = Control.MOUSE_FILTER_IGNORE
		background.add_child(fill)
	background.position = rect.position
	background.size = rect.size
	background.color = background_color
	background.z_index = 4
	fill.position = Vector2.ZERO
	fill.size = Vector2(rect.size.x * clamp(ratio, 0.0, 1.0), rect.size.y)
	fill.color = fill_color
	fill.z_index = 1


func _set_home_control_rect(path: String, rect: Rect2) -> void:
	var control := generated_home_surface.get_node_or_null(path) as Control
	if control != null:
		control.position = rect.position
		control.size = rect.size


func _hide_home_node(path: String) -> void:
	var node := generated_home_surface.get_node_or_null(path) as CanvasItem
	if node != null:
		node.visible = false


func _configure_home_panel_texture(path: String, texture: Texture2D, margins: Vector4) -> void:
	var panel := generated_home_surface.get_node_or_null(path) as PanelContainer
	if panel == null:
		return
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_theme_stylebox_override("panel", _make_texture_stylebox(texture, margins))


func _configure_home_button_texture(path: String, texture: Texture2D, margins: Vector4) -> void:
	var button := generated_home_surface.get_node_or_null(path) as Button
	if button == null:
		return
	button.flat = false
	button.focus_mode = Control.FOCUS_NONE
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	var normal := _make_texture_stylebox(texture, margins)
	var pressed := _make_texture_stylebox(texture, margins)
	var hover := _make_texture_stylebox(texture, margins)
	button.add_theme_stylebox_override("normal", normal)
	button.add_theme_stylebox_override("pressed", pressed)
	button.add_theme_stylebox_override("hover", hover)
	button.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	button.add_theme_color_override("font_color", Color(1.0, 0.88, 0.62))
	button.add_theme_font_size_override("font_size", 13)


func _configure_home_tab_button(path: String, selected: bool) -> void:
	var button := generated_home_surface.get_node_or_null(path) as Button
	if button == null:
		return
	button.flat = false
	button.focus_mode = Control.FOCUS_NONE
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	if selected:
		button.add_theme_stylebox_override("normal", StyleBoxEmpty.new())
		button.add_theme_stylebox_override("hover", StyleBoxEmpty.new())
		button.add_theme_stylebox_override("pressed", StyleBoxEmpty.new())
	else:
		button.add_theme_stylebox_override("normal", StyleBoxEmpty.new())
		button.add_theme_stylebox_override("hover", _make_flat_stylebox(Color(0.16, 0.09, 0.04, 0.46), Color(0.70, 0.52, 0.27, 0.80), 4))
		button.add_theme_stylebox_override("pressed", _make_flat_stylebox(Color(0.08, 0.04, 0.02, 0.72), Color(0.90, 0.65, 0.28, 0.90), 4))
	button.add_theme_stylebox_override("focus", StyleBoxEmpty.new())


func _make_texture_stylebox(texture: Texture2D, margins: Vector4) -> StyleBoxTexture:
	var style := StyleBoxTexture.new()
	style.texture = texture
	style.set_texture_margin(SIDE_LEFT, margins.x)
	style.set_texture_margin(SIDE_TOP, margins.y)
	style.set_texture_margin(SIDE_RIGHT, margins.z)
	style.set_texture_margin(SIDE_BOTTOM, margins.w)
	style.draw_center = true
	return style


func _make_flat_stylebox(fill_color: Color, border_color: Color, radius: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill_color
	style.border_color = border_color
	style.set_border_width_all(1)
	style.set_corner_radius_all(radius)
	return style


func _outline_color_for_label(color: Color) -> Color:
	var luminance := color.r * 0.299 + color.g * 0.587 + color.b * 0.114
	if luminance > 0.52:
		return Color(0.02, 0.012, 0.0, 0.78)
	return Color(1.0, 0.78, 0.36, 0.42)


func _configure_home_panel(path: String, fill_color: Color, border_color: Color, radius: int) -> void:
	var panel := generated_home_surface.get_node_or_null(path) as PanelContainer
	if panel == null:
		return
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var style := StyleBoxFlat.new()
	style.bg_color = fill_color
	style.border_color = border_color
	style.set_border_width_all(2)
	style.set_corner_radius_all(radius)
	panel.add_theme_stylebox_override("panel", style)


func _configure_home_button(path: String, fill_color: Color, border_color: Color, radius: int) -> void:
	var button := generated_home_surface.get_node_or_null(path) as Button
	if button == null:
		return
	button.flat = false
	button.focus_mode = Control.FOCUS_NONE
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	button.add_theme_font_size_override("font_size", 13)
	button.add_theme_color_override("font_color", Color(0.96, 0.86, 0.62))
	var normal := StyleBoxFlat.new()
	normal.bg_color = fill_color
	normal.border_color = border_color
	normal.set_border_width_all(2)
	normal.set_corner_radius_all(radius)
	var pressed := StyleBoxFlat.new()
	pressed.bg_color = fill_color.darkened(0.16)
	pressed.border_color = Color(0.96, 0.76, 0.38, 1.0)
	pressed.set_border_width_all(2)
	pressed.set_corner_radius_all(radius)
	var hover := StyleBoxFlat.new()
	hover.bg_color = fill_color.lightened(0.08)
	hover.border_color = Color(0.96, 0.76, 0.38, 1.0)
	hover.set_border_width_all(2)
	hover.set_corner_radius_all(radius)
	button.add_theme_stylebox_override("normal", normal)
	button.add_theme_stylebox_override("pressed", pressed)
	button.add_theme_stylebox_override("hover", hover)
	button.add_theme_stylebox_override("focus", StyleBoxEmpty.new())


func _configure_home_label(path: String, font_size: int, color: Color, alignment: HorizontalAlignment) -> void:
	var label := generated_home_surface.get_node_or_null(path) as Label
	if label == null:
		return
	label.horizontal_alignment = alignment
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_OFF
	label.clip_text = true
	label.z_index = 6
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	label.add_theme_color_override("font_outline_color", _outline_color_for_label(color))
	label.add_theme_constant_override("outline_size", 2)


func _configure_home_progress(path: String, fill_color: Color, background_color: Color) -> void:
	var progress := generated_home_surface.get_node_or_null(path) as ProgressBar
	if progress == null:
		return
	progress.show_percentage = false
	progress.min_value = 0.0
	progress.max_value = 1.0
	var bg := StyleBoxFlat.new()
	bg.bg_color = background_color
	bg.set_corner_radius_all(2)
	var fill := StyleBoxFlat.new()
	fill.bg_color = fill_color
	fill.set_corner_radius_all(2)
	progress.add_theme_stylebox_override("background", bg)
	progress.add_theme_stylebox_override("fill", fill)


func _set_home_button_text(path: String, text: String) -> void:
	var button := generated_home_surface.get_node_or_null(path) as Button
	if button != null:
		button.text = text


func _style_generated_hud_surface() -> void:
	if generated_hud_surface == null:
		return
	_configure_hud_label("Section_TopHud/Panel_Hero/Text_HeroStatusTab", 10, Color(0.94, 0.72, 0.34), HORIZONTAL_ALIGNMENT_CENTER)
	_configure_hud_label("Section_TopHud/Panel_Hero/Text_HaeilName", 18, Color(0.98, 0.90, 0.68), HORIZONTAL_ALIGNMENT_LEFT)
	_configure_hud_label("Section_TopHud/Panel_Hero/Text_HaeilLevel", 13, Color(0.70, 0.93, 1.0), HORIZONTAL_ALIGNMENT_LEFT)
	_configure_hud_label("Section_TopHud/Panel_Timer/Text_TimerStatusTab", 10, Color(0.70, 0.93, 1.0), HORIZONTAL_ALIGNMENT_CENTER)
	_configure_hud_label("Section_TopHud/Panel_Timer/Text_RunTimer", 27, Color(1.0, 0.91, 0.62), HORIZONTAL_ALIGNMENT_CENTER)
	_configure_hud_label("Section_TopHud/Panel_Timer/Text_RunStage", 13, Color(0.93, 0.74, 0.34), HORIZONTAL_ALIGNMENT_CENTER)
	_configure_hud_label("Section_TopHud/Panel_RunLedger/Text_LedgerStatusTab", 10, Color(0.94, 0.72, 0.34), HORIZONTAL_ALIGNMENT_CENTER)
	_configure_hud_label("Section_TopHud/Panel_RunLedger/Text_LedgerKills", 12, Color(0.96, 0.90, 0.72), HORIZONTAL_ALIGNMENT_LEFT)
	_configure_hud_label("Section_TopHud/Panel_RunLedger/Text_LedgerEnemies", 12, Color(0.96, 0.90, 0.72), HORIZONTAL_ALIGNMENT_LEFT)
	_configure_hud_label("Section_TopHud/Panel_RunLedger/Text_LedgerPurified", 12, Color(0.96, 0.90, 0.72), HORIZONTAL_ALIGNMENT_LEFT)
	_configure_hud_label("Section_WaveTrack/Text_WaveLabel", 11, Color(0.92, 0.80, 0.38), HORIZONTAL_ALIGNMENT_LEFT)
	_configure_hud_label("Section_BattleControls/Section_ActionDock/Btn_PrimaryWave/Text_PrimaryWaveCooldown", 12, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER)
	_configure_hud_label("Section_BattleControls/Section_ActionDock/Btn_SecondaryVortex/Text_SecondaryVortexCooldown", 11, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER)
	_configure_hud_label("Section_BattleControls/Section_ActionDock/Btn_SecondarySpiritfire/Text_SecondarySpiritfireCooldown", 11, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER)
	_configure_hud_label("Section_ExpBar/Panel_ExpFrame/Text_RunLevel", 12, Color(0.70, 0.93, 1.0), HORIZONTAL_ALIGNMENT_CENTER)
	_configure_hud_label("Section_ExpBar/Panel_ExpFrame/Text_RunExpValue", 12, Color(0.73, 0.92, 1.0), HORIZONTAL_ALIGNMENT_CENTER)
	_configure_hud_button("Section_TopHud/Btn_Pause")
	_configure_hud_progress("Section_TopHud/Panel_Hero/Progress_HaeilHp", Color(0.88, 0.18, 0.12), Color(0.14, 0.04, 0.035))
	_configure_hud_progress("Section_WaveTrack/Panel_WaveTrack/Progress_Wave", Color(0.24, 0.88, 0.78), Color(0.02, 0.03, 0.025))
	_configure_hud_progress("Section_ExpBar/Panel_ExpFrame/Progress_RunExp", Color(0.20, 0.68, 1.0), Color(0.035, 0.055, 0.07))
	_style_survivor_top_status_tabs()
	for path in [
		"Section_BattleControls/Section_ActionDock/Btn_PrimaryWave/Progress_PrimaryWaveCooldown",
		"Section_BattleControls/Section_ActionDock/Btn_SecondaryVortex/Progress_SecondaryVortexCooldown",
		"Section_BattleControls/Section_ActionDock/Btn_SecondarySpiritfire/Progress_SecondarySpiritfireCooldown",
	]:
		var progress := generated_hud_surface.get_node_or_null(path) as ProgressBar
		if progress != null:
			progress.visible = false


func _configure_hud_label(path: String, font_size: int, color: Color, alignment: HorizontalAlignment) -> void:
	var label := generated_hud_surface.get_node_or_null(path) as Label
	if label == null:
		return
	label.horizontal_alignment = alignment
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.clip_text = true
	label.z_index = 4
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	label.add_theme_color_override("font_outline_color", _outline_color_for_label(color))
	label.add_theme_constant_override("outline_size", 2)


func _configure_hud_button(path: String) -> void:
	var button := generated_hud_surface.get_node_or_null(path) as Button
	if button == null:
		return
	button.flat = true
	button.disabled = true
	button.text = ""
	button.add_theme_font_size_override("font_size", 24)
	button.add_theme_color_override("font_color", Color(0.98, 0.86, 0.58))


func _configure_hud_progress(path: String, fill_color: Color, background_color: Color) -> void:
	var progress := generated_hud_surface.get_node_or_null(path) as ProgressBar
	if progress == null:
		return
	progress.show_percentage = false
	progress.min_value = 0.0
	progress.max_value = 1.0
	var bg := StyleBoxFlat.new()
	bg.bg_color = background_color
	bg.set_corner_radius_all(1)
	var fill := StyleBoxFlat.new()
	fill.bg_color = fill_color
	fill.set_corner_radius_all(1)
	progress.add_theme_stylebox_override("background", bg)
	progress.add_theme_stylebox_override("fill", fill)


func _style_survivor_top_status_tabs() -> void:
	if _configure_hud_tab_skin("Section_TopHud/Panel_Hero/Panel_HeroStatusTabSkin") \
			and _configure_hud_tab_skin("Section_TopHud/Panel_Timer/Panel_TimerStatusTabSkin") \
			and _configure_hud_tab_skin("Section_TopHud/Panel_RunLedger/Panel_LedgerStatusTabSkin"):
		return
	_ensure_hud_color_rect_child("Section_TopHud/Panel_Hero", "Back_HeroStatusTab", Rect2(76, 7, 94, 17), Color(0.08, 0.06, 0.035, 0.78), 2)
	_ensure_hud_color_rect_child("Section_TopHud/Panel_Hero", "Line_HeroStatusTab", Rect2(84, 23, 58, 2), Color(0.22, 0.76, 1.0, 0.88), 3)
	_ensure_hud_color_rect_child("Section_TopHud/Panel_Timer", "Back_TimerStatusTab", Rect2(14, 7, 104, 17), Color(0.04, 0.11, 0.13, 0.82), 2)
	_ensure_hud_color_rect_child("Section_TopHud/Panel_Timer", "Line_TimerStatusTab", Rect2(32, 23, 68, 2), Color(0.24, 0.88, 0.78, 0.94), 3)
	_ensure_hud_color_rect_child("Section_TopHud/Panel_RunLedger", "Back_LedgerStatusTab", Rect2(10, 7, 116, 17), Color(0.08, 0.06, 0.035, 0.78), 2)
	_ensure_hud_color_rect_child("Section_TopHud/Panel_RunLedger", "Line_LedgerStatusTab", Rect2(18, 23, 78, 2), Color(0.94, 0.68, 0.25, 0.88), 3)


func _configure_hud_tab_skin(path: String) -> bool:
	var skin := generated_hud_surface.get_node_or_null(path) as Control
	if skin == null:
		return false
	skin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	skin.z_index = 1
	return true


func _ensure_hud_color_rect_child(parent_path: String, node_name: String, rect: Rect2, color: Color, z: int) -> void:
	var parent := generated_hud_surface.get_node_or_null(parent_path) as Control
	if parent == null:
		return
	var color_rect := parent.get_node_or_null(node_name) as ColorRect
	if color_rect == null:
		color_rect = ColorRect.new()
		color_rect.name = node_name
		color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		parent.add_child(color_rect)
	color_rect.position = rect.position
	color_rect.size = rect.size
	color_rect.color = color
	color_rect.z_index = z


func _sync_generated_hud() -> void:
	if generated_hud_surface == null:
		return
	var hud_visible := screen_mode == MODE_BATTLE and use_generated_hud and running and not choice_pending
	generated_hud_surface.visible = hud_visible
	if generated_hud_primitives != null:
		generated_hud_primitives.visible = hud_visible
	if not hud_visible:
		return
	_set_hud_label("Section_TopHud/Panel_Hero/Text_HeroStatusTab", "해일")
	_set_hud_label("Section_TopHud/Panel_Hero/Text_HaeilName", "해일")
	_set_hud_label("Section_TopHud/Panel_Hero/Text_HaeilLevel", "Lv.%d  영력 %d" % [run_level, purified])
	_set_hud_label("Section_TopHud/Panel_Timer/Text_TimerStatusTab", "생존")
	_set_hud_label("Section_TopHud/Panel_Timer/Text_RunTimer", _format_time(RUN_SECONDS - elapsed))
	_set_hud_label("Section_TopHud/Panel_Timer/Text_RunStage", "STAGE %d/3" % _stage_index())
	_set_hud_label("Section_TopHud/Panel_RunLedger/Text_LedgerStatusTab", "전황")
	_set_hud_label("Section_TopHud/Panel_RunLedger/Text_LedgerKills", "처치      %d" % kills)
	_set_hud_label("Section_TopHud/Panel_RunLedger/Text_LedgerEnemies", "요귀      %d" % enemies.size())
	_set_hud_label("Section_TopHud/Panel_RunLedger/Text_LedgerPurified", "정화      %d" % purified)
	_set_hud_label("Section_WaveTrack/Text_WaveLabel", "")
	_set_hud_label("Section_ExpBar/Panel_ExpFrame/Text_RunLevel", "영력 Lv.%d" % run_level)
	_set_hud_label("Section_ExpBar/Panel_ExpFrame/Text_RunExpValue", "%d/%d" % [run_exp, exp_to_next])
	_set_hud_label("Section_BattleControls/Section_ActionDock/Btn_PrimaryWave/Text_PrimaryWaveCooldown", "")
	_set_hud_label("Section_BattleControls/Section_ActionDock/Btn_SecondaryVortex/Text_SecondaryVortexCooldown", "")
	_set_hud_label("Section_BattleControls/Section_ActionDock/Btn_SecondarySpiritfire/Text_SecondarySpiritfireCooldown", "")
	_set_hud_progress("Section_TopHud/Panel_Hero/Progress_HaeilHp", float(player.get("hp", 0.0)) / PLAYER_MAX_HP)
	_set_hud_progress("Section_WaveTrack/Panel_WaveTrack/Progress_Wave", _wave_progress_ratio())
	_set_hud_progress("Section_ExpBar/Panel_ExpFrame/Progress_RunExp", float(run_exp) / max(1.0, float(exp_to_next)))
	if generated_hud_primitives != null and generated_hud_primitives.has_method("set_hud_state"):
		generated_hud_primitives.call("set_hud_state", {
			"visible": hud_visible,
			"stage_index": _stage_index(),
			"skills": skill_levels.duplicate(true),
			"skill_timers": skill_timers.duplicate(true),
			"magnet_remaining": magnet_remaining,
		})


func _sync_generated_home() -> void:
	if generated_home_surface == null:
		return
	var home_visible := screen_mode == MODE_HOME
	generated_home_surface.visible = home_visible
	if not home_visible:
		return
	_set_home_label("Section_TopResourceBar/Text_ProfileNameOverlay", "해일")
	_set_home_label("Section_TopResourceBar/Text_ProfileRankOverlay", "도력 12")
	_set_home_label("Section_TopResourceBar/Panel_StaminaChip/Text_StaminaValue", "32/40")
	_set_home_label("Section_TopResourceBar/Panel_CoinChip/Text_CoinValue", "12.4K")
	_set_home_label("Section_TopResourceBar/Panel_GemChip/Text_GemValue", "340")
	_set_home_label("Section_EventRail/Text_EventDailyOverlay", "일일 수련")
	_set_home_label("Section_EventRail/Text_EventRelicOverlay", "법기 강화")
	_set_home_label("Section_EventRail/Text_EventBossOverlay", "밤도깨비")
	_set_home_label("Section_EventRail/Text_EventLockedOverlay", "문파 준비중")
	_set_home_label("Section_EventRail/Text_EventChestOverlay", "보물 상자")
	_set_home_label("Section_ProgressionCards/Text_IdleRewardOverlay", "방치 보상")
	_set_home_label("Section_ProgressionCards/Text_TrainingOverlay", "수련 진도")
	_set_home_label("Section_SortieCta/Btn_Sortie/Text_SortieTitle", "원정 출발")
	_set_home_label("Section_SortieCta/Btn_Sortie/Text_SortieStage", "가을 폐촌 1-1")
	_set_home_label("Section_SortieCta/Btn_Sortie/Text_SortieCost", "기력 5")
	_set_home_progress("Section_TopResourceBar/Progress_ProfileStaminaOverlay", 0.72)
	_set_home_progress("Section_ProgressionCards/Bar_IdleRewardOverlay", 0.82)
	_set_home_progress("Section_ProgressionCards/Bar_TrainingOverlay", 0.46)
	_set_home_progress("Section_EventRail/Bar_EventDailyProgress", 0.76)
	_set_home_progress("Section_EventRail/Bar_EventRelicProgress", 0.48)
	_set_home_progress("Section_EventRail/Bar_EventBossProgress", 0.34)
	_set_home_progress("Section_EventRail/Bar_EventLockedProgress", 0.18)
	_set_home_progress("Section_EventRail/Bar_EventChestProgress", 0.62)


func _set_hud_label(path: String, text: String) -> void:
	var label := generated_hud_surface.get_node_or_null(path) as Label
	if label != null:
		label.text = text


func _set_hud_progress(path: String, ratio: float) -> void:
	var progress := generated_hud_surface.get_node_or_null(path) as ProgressBar
	if progress != null:
		progress.value = clamp(ratio, 0.0, 1.0)


func _set_home_label(path: String, text: String) -> void:
	var label := generated_home_surface.get_node_or_null(path) as Label
	if label != null:
		label.text = text


func _set_home_progress(path: String, ratio: float) -> void:
	var progress := generated_home_surface.get_node_or_null(path) as ProgressBar
	if progress != null:
		progress.value = clamp(ratio, 0.0, 1.0)
		return
	var background := generated_home_surface.get_node_or_null(path) as ColorRect
	if background != null:
		var fill := background.get_node_or_null("Fill") as ColorRect
		if fill != null:
			fill.size.x = background.size.x * clamp(ratio, 0.0, 1.0)


func choose_card(index: int) -> bool:
	if not choice_pending:
		return false
	if index < 0 or index >= level_choices.size():
		return false
	var card: Dictionary = level_choices[index]
	var key: String = str(card.get("key", ""))
	if not skill_levels.has(key):
		return false
	skill_levels[key] = int(skill_levels.get(key, 0)) + 1
	choice_pending = false
	level_choices.clear()
	_add_fx(_player_pos(), "choice", str(card.get("name", "스킬 강화")), Color(1.0, 0.86, 0.42))
	_sync_generated_hud()
	return true


func _process(delta: float) -> void:
	if screen_mode == MODE_HOME:
		_handle_home_input()
		_sync_generated_home()
		queue_redraw()
		return
	var dt: float = min(delta, 1.0 / 30.0)
	if not running:
		if Input.is_action_just_pressed("ui_accept") or Input.is_key_pressed(KEY_R):
			restart_run()
		_sync_generated_hud()
		queue_redraw()
		return
	if choice_pending:
		_handle_choice_input()
		_update_fx(dt)
		_sync_generated_hud()
		queue_redraw()
		return

	_handle_run_input(dt)
	_update_run(dt)
	_sync_generated_hud()
	queue_redraw()


func _handle_home_input() -> void:
	if Input.is_action_just_pressed("ui_accept") or Input.is_key_pressed(KEY_SPACE) or Input.is_key_pressed(KEY_ENTER):
		restart_run()


func _handle_run_input(dt: float) -> void:
	if Input.is_key_pressed(KEY_R):
		restart_run()
		return
	var move := Vector2.ZERO
	if use_injected_move:
		move = injected_move
	else:
		move.x = Input.get_axis("ui_left", "ui_right")
		move.y = Input.get_axis("ui_up", "ui_down")
		if Input.is_key_pressed(KEY_A):
			move.x -= 1.0
		if Input.is_key_pressed(KEY_D):
			move.x += 1.0
		if Input.is_key_pressed(KEY_W):
			move.y -= 1.0
		if Input.is_key_pressed(KEY_S):
			move.y += 1.0
	move = move.limit_length(1.0)
	player_moving = move.length_squared() > 0.001
	if player_moving:
		player["facing"] = move.normalized()
		player["pos"] = _clamp_world(_player_pos() + move * PLAYER_SPEED * dt)
		player_walk_phase += dt * 10.8


func _handle_choice_input() -> void:
	if Input.is_key_pressed(KEY_1):
		choose_card(0)
	elif Input.is_key_pressed(KEY_2):
		choose_card(1)
	elif Input.is_key_pressed(KEY_3):
		choose_card(2)
	elif Input.is_action_just_pressed("ui_accept"):
		choose_card(0)


func _update_run(dt: float) -> void:
	elapsed += dt
	spawn_timer -= dt
	field_item_timer -= dt
	magnet_remaining = max(0.0, magnet_remaining - dt)
	attack_timer -= dt
	_update_camera(dt)
	_update_spawns()
	_update_enemies(dt)
	_update_player_attack()
	_update_skills(dt)
	_update_field_items(dt)
	_update_pickups(dt)
	_update_fx(dt)
	_check_result()


func _update_camera(dt: float) -> void:
	camera_pos = camera_pos.lerp(_player_pos(), min(1.0, dt * 6.0))


func _update_spawns() -> void:
	if enemies.size() >= MAX_ENEMIES or spawn_timer > 0.0:
		return
	var batch := 6 + int(elapsed / 24.0)
	if elapsed > 85.0:
		batch += 3
	if elapsed > 135.0:
		batch += 4
	for i in range(batch):
		var kind := "japgwi"
		var roll := rng.randf()
		if elapsed > 95.0 and roll > 0.72:
			kind = "talisman_caster"
		elif elapsed > 55.0 and roll > 0.58:
			kind = "ghost"
		elif elapsed > 25.0 and roll > 0.36:
			kind = "grunt"
		if elapsed > 125.0 and i == 0 and not _has_boss():
			kind = "night_ogre"
		_spawn_enemy(kind, rng.randf_range(0.0, TAU), rng.randf_range(560.0, 760.0))
	spawn_timer = max(0.22, 0.78 - elapsed * 0.0024)


func _spawn_enemy(kind: String, angle: float, distance: float) -> void:
	var base := _enemy_stats(kind)
	var pos := _clamp_world(_player_pos() + Vector2(cos(angle), sin(angle)) * distance)
	base["id"] = next_id
	base["pos"] = pos
	base["hit_flash"] = 0.0
	next_id += 1
	enemies.append(base)


func _enemy_stats(kind: String) -> Dictionary:
	match kind:
		"ghost":
			return {"kind": kind, "name": "망령", "hp": 46.0, "max_hp": 46.0, "speed": 112.0, "damage": 9.0, "radius": 22.0, "exp": 2}
		"grunt":
			return {"kind": kind, "name": "도깨비 하수", "hp": 72.0, "max_hp": 72.0, "speed": 92.0, "damage": 15.0, "radius": 27.0, "exp": 3}
		"talisman_caster":
			return {"kind": kind, "name": "부적술사", "hp": 58.0, "max_hp": 58.0, "speed": 84.0, "damage": 12.0, "radius": 24.0, "exp": 4}
		"night_ogre":
			return {"kind": kind, "name": "밤도깨비 장군", "hp": 580.0, "max_hp": 580.0, "speed": 62.0, "damage": 28.0, "radius": 56.0, "exp": 18}
		_:
			return {"kind": "japgwi", "name": "잡귀", "hp": 31.0, "max_hp": 31.0, "speed": 132.0, "damage": 7.0, "radius": 20.0, "exp": 1}


func _update_enemies(dt: float) -> void:
	var p := _player_pos()
	for enemy in enemies:
		var pos: Vector2 = enemy.get("pos", p)
		var dir: Vector2 = p - pos
		var dist: float = max(1.0, dir.length())
		var desired: Vector2 = dir / dist
		var speed: float = float(enemy.get("speed", 90.0))
		enemy["pos"] = _clamp_world(pos + desired * speed * dt)
		enemy["hit_flash"] = max(0.0, float(enemy.get("hit_flash", 0.0)) - dt)
		if dist < float(enemy.get("radius", 24.0)) + 24.0:
			player["hp"] = max(0.0, float(player.get("hp", 0.0)) - float(enemy.get("damage", 10.0)) * CONTACT_DAMAGE_SCALE * dt)
	_separate_enemies()


func _separate_enemies() -> void:
	for pass_index in range(2):
		for i in range(enemies.size()):
			var a: Dictionary = enemies[i]
			var apos: Vector2 = a.get("pos", Vector2.ZERO)
			for j in range(i + 1, enemies.size()):
				var b: Dictionary = enemies[j]
				var bpos: Vector2 = b.get("pos", Vector2.ZERO)
				var diff := apos - bpos
				var min_dist: float = float(a.get("radius", 22.0)) + float(b.get("radius", 22.0)) + 3.0
				var dist: float = diff.length()
				if dist <= 0.01 or dist >= min_dist:
					continue
				var push := diff.normalized() * (min_dist - dist) * 0.25 * ENEMY_SEPARATION_STRENGTH
				a["pos"] = _clamp_world(apos + push)
				b["pos"] = _clamp_world(bpos - push)
				apos = a["pos"]


func _update_player_attack() -> void:
	if attack_timer > 0.0:
		return
	attack_timer = ATTACK_COOLDOWN * max(0.62, 1.0 - _skill_level("ward") * 0.05)
	var target: Dictionary = _nearest_enemy()
	var p := _player_pos()
	if not target.is_empty():
		var dir: Vector2 = target.get("pos", p) - p
		if dir.length_squared() > 0.001:
			player["facing"] = dir.normalized()
	var facing: Vector2 = player.get("facing", Vector2.RIGHT)
	var damage: float = BASE_ATTACK_DAMAGE * (1.0 + float(_skill_level("wave")) * 0.13)
	var hit_count := 0
	for enemy in enemies:
		var offset: Vector2 = enemy.get("pos", p) - p
		var dist: float = offset.length()
		if dist > ATTACK_RADIUS:
			continue
		var angle: float = abs(facing.angle_to(offset.normalized()))
		if angle <= deg_to_rad(ATTACK_ARC_DEGREES * 0.5):
			_damage_enemy(enemy, damage, "slash")
			hit_count += 1
	if hit_count > 0:
		_add_fx(p + facing * 76.0, "water_slash", "", Color(0.45, 0.86, 1.0), facing)


func _update_skills(dt: float) -> void:
	for key in skill_timers.keys():
		if _skill_level(key) <= 0:
			continue
		skill_timers[key] = float(skill_timers.get(key, 0.0)) - dt
	if _skill_level("vortex") > 0 and float(skill_timers.get("vortex", 0.0)) <= 0.0:
		_cast_vortex()
		skill_timers["vortex"] = max(1.7, 3.6 - float(_skill_level("vortex")) * 0.32)
	if _skill_level("wave") > 0 and float(skill_timers.get("wave", 0.0)) <= 0.0:
		_cast_wave()
		skill_timers["wave"] = max(2.8, 5.3 - float(_skill_level("wave")) * 0.25)
	if _skill_level("spiritfire") > 0 and float(skill_timers.get("spiritfire", 0.0)) <= 0.0:
		_cast_spiritfire()
		skill_timers["spiritfire"] = max(0.8, 1.7 - float(_skill_level("spiritfire")) * 0.08)
	if _skill_level("ward") > 0 and float(skill_timers.get("ward", 0.0)) <= 0.0:
		_cast_ward()
		skill_timers["ward"] = 6.2


func _cast_vortex() -> void:
	var p := _player_pos()
	var radius := 164.0 + float(_skill_level("vortex")) * 22.0
	for enemy in enemies:
		var offset: Vector2 = enemy.get("pos", p) - p
		if offset.length() <= radius:
			_damage_enemy(enemy, 22.0 + 9.0 * _skill_level("vortex"), "vortex")
			enemy["pos"] = _clamp_world(enemy.get("pos", p).lerp(p, 0.08))
	_add_fx(p, "vortex", "물소용돌이", Color(0.25, 0.74, 1.0))


func _cast_wave() -> void:
	var p := _player_pos()
	var facing: Vector2 = player.get("facing", Vector2.RIGHT)
	for enemy in enemies:
		var offset: Vector2 = enemy.get("pos", p) - p
		var dist := offset.length()
		if dist > 250.0:
			continue
		if abs(facing.angle_to(offset.normalized())) <= deg_to_rad(46.0):
			_damage_enemy(enemy, 32.0 + 10.0 * _skill_level("wave"), "wave")
			enemy["pos"] = _clamp_world(enemy.get("pos", p) + facing * 88.0)
	_add_fx(p + facing * 120.0, "wave", "파도 밀어내기", Color(0.34, 0.82, 1.0), facing)


func _cast_spiritfire() -> void:
	var target := _nearest_enemy()
	if target.is_empty():
		return
	_damage_enemy(target, 36.0 + 12.0 * _skill_level("spiritfire"), "spiritfire")
	_add_fx(target.get("pos", _player_pos()), "spiritfire", "도깨비불", Color(0.26, 0.95, 0.82))


func _cast_ward() -> void:
	player["hp"] = min(float(player.get("max_hp", PLAYER_MAX_HP)), float(player.get("hp", 0.0)) + 22.0 + 8.0 * _skill_level("ward"))
	_add_fx(_player_pos(), "ward", "수호 물결", Color(0.58, 0.94, 1.0))


func _damage_enemy(enemy: Dictionary, amount: float, source: String) -> void:
	enemy["hp"] = float(enemy.get("hp", 1.0)) - amount
	enemy["hit_flash"] = 0.11
	if float(enemy.get("hp", 0.0)) <= 0.0:
		_kill_enemy(enemy, source)


func _kill_enemy(enemy: Dictionary, source: String) -> void:
	if not enemies.has(enemy):
		return
	enemies.erase(enemy)
	kills += 1
	purified += int(enemy.get("exp", 1))
	var pos: Vector2 = enemy.get("pos", _player_pos())
	_spawn_pickup(pos, int(enemy.get("exp", 1)))
	if int(enemy.get("exp", 1)) >= 3 or kills % 8 == 0:
		_add_fx(pos + Vector2(0.0, -34.0), "reward", "+%d 정화" % int(enemy.get("exp", 1)), Color(0.54, 0.96, 0.88))
	if str(enemy.get("kind", "")) == "night_ogre":
		_add_fx(pos, "boss_down", "요괴 장군 정화", Color(1.0, 0.62, 0.28))
	elif source != "slash":
		_add_fx(pos, "purify", "정화", Color(0.64, 0.96, 1.0))


func _spawn_pickup(pos: Vector2, value: int) -> void:
	pickups.append({
		"id": next_pickup_id,
		"kind": "exp",
		"pos": _clamp_world(pos + Vector2(rng.randf_range(-28.0, 28.0), rng.randf_range(-16.0, 24.0))),
		"value": value,
		"age": 0.0,
		"armed": false,
	})
	next_pickup_id += 1


func _update_pickups(dt: float) -> void:
	var p := _player_pos()
	for pickup in pickups.duplicate():
		pickup["age"] = float(pickup.get("age", 0.0)) + dt
		if float(pickup.get("age", 0.0)) > PICKUP_TTL:
			pickups.erase(pickup)
			continue
		var armed := float(pickup.get("age", 0.0)) >= PICKUP_ARM_DELAY
		pickup["armed"] = armed
		if not armed:
			continue
		var pos: Vector2 = pickup.get("pos", p)
		var dist := pos.distance_to(p)
		if dist <= PICKUP_COLLECT_RADIUS:
			_collect_pickup(pickup)
			continue
		var magnet_radius := PICKUP_MAGNET_RADIUS * (1.85 if magnet_remaining > 0.0 else 1.0)
		if dist <= magnet_radius:
			var magnet_ratio: float = 1.0 - clamp(dist / magnet_radius, 0.0, 1.0)
			var speed: float = PICKUP_SPEED * (0.85 + magnet_ratio * 1.4)
			pickup["pos"] = pos.move_toward(p, speed * dt)


func _collect_pickup(pickup: Dictionary) -> void:
	if not pickups.has(pickup):
		return
	pickups.erase(pickup)
	run_exp += int(pickup.get("value", 1))
	while run_exp >= exp_to_next and not choice_pending:
		run_exp -= exp_to_next
		run_level += 1
		exp_to_next = 12 + (run_level - 1) * 10 + int(pow(run_level - 1, 2) * 1.4)
		_queue_level_choice()


func _update_field_items(dt: float) -> void:
	if field_item_timer <= 0.0:
		field_item_timer += FIELD_ITEM_SPAWN_INTERVAL
		if field_items.size() < FIELD_ITEM_MAX_ACTIVE:
			_spawn_field_item(_pick_field_item_type(), _random_field_item_position())
	var p := _player_pos()
	for item in field_items.duplicate():
		item["age"] = float(item.get("age", 0.0)) + dt
		if float(item.get("age", 0.0)) > float(item.get("ttl", FIELD_ITEM_TTL)):
			field_items.erase(item)
			continue
		var pos: Vector2 = item.get("pos", p)
		var dist := pos.distance_to(p)
		if str(item.get("type", "")) == "mine":
			if dist <= FIELD_ITEM_MINE_RADIUS:
				item["held"] = min(FIELD_ITEM_MINE_HOLD, float(item.get("held", 0.0)) + dt)
			else:
				item["held"] = max(0.0, float(item.get("held", 0.0)) - dt * 0.55)
			item["progress"] = clamp(float(item.get("held", 0.0)) / FIELD_ITEM_MINE_HOLD, 0.0, 1.0)
			if float(item.get("held", 0.0)) >= FIELD_ITEM_MINE_HOLD:
				_complete_mine_item(item)
				field_items.erase(item)
			continue
		var collect_radius := FIELD_ITEM_COLLECT_RADIUS + (24.0 if magnet_remaining > 0.0 else 0.0)
		if dist <= collect_radius:
			_collect_field_item(item)
			field_items.erase(item)


func _spawn_field_item(item_type: String, pos: Vector2) -> void:
	var safe_type := item_type if FIELD_ITEM_TYPES.has(item_type) else "potion"
	field_items.append({
		"id": next_field_item_id,
		"type": safe_type,
		"pos": _clamp_world(pos),
		"age": 0.0,
		"ttl": FIELD_ITEM_MINE_TTL if safe_type == "mine" else FIELD_ITEM_TTL,
		"held": 0.0,
		"progress": 0.0,
	})
	next_field_item_id += 1
	_add_fx(pos + Vector2(0.0, -26.0), "item_spawn", _field_item_label(safe_type), _field_item_color(safe_type))


func _collect_field_item(item: Dictionary) -> void:
	var item_type := str(item.get("type", ""))
	var pos: Vector2 = item.get("pos", _player_pos())
	match item_type:
		"bomb":
			_trigger_bomb_item(pos)
		"magnet":
			_trigger_magnet_item(pos)
		"potion":
			_trigger_potion_item(pos)
		_:
			_add_fx(pos, "field_item", _field_item_label(item_type), _field_item_color(item_type))


func _trigger_bomb_item(pos: Vector2) -> void:
	var hits := 0
	for enemy in enemies.duplicate():
		if str(enemy.get("kind", "")) == "night_ogre":
			continue
		_damage_enemy(enemy, 9999.0, "bomb")
		hits += 1
	_add_fx(pos, "encounter_bomb", "폭발 %d" % hits, Color(1.0, 0.66, 0.24))


func _trigger_magnet_item(pos: Vector2) -> void:
	magnet_remaining = FIELD_ITEM_MAGNET_DURATION
	var collected := _collect_all_pickups()
	var label := "영력 회수 %d" % collected if collected > 0 else "영력 자석"
	_add_fx(pos, "encounter_magnet", label, Color(0.62, 1.0, 1.0))


func _trigger_potion_item(pos: Vector2) -> void:
	var max_hp: float = float(player.get("max_hp", PLAYER_MAX_HP))
	var heal: float = max(1.0, max_hp * 0.32)
	player["hp"] = min(max_hp, float(player.get("hp", 0.0)) + heal)
	_add_fx(pos, "ward", "+%d" % int(round(heal)), Color(0.62, 1.0, 1.0))


func _complete_mine_item(item: Dictionary) -> void:
	var pos: Vector2 = item.get("pos", _player_pos())
	var amount := rng.randi_range(5, 9)
	purified += amount
	_add_fx(pos, "field_item", "영석 +%d" % amount, Color(1.0, 0.90, 0.36))


func _collect_all_pickups() -> int:
	var total := 0
	for pickup in pickups.duplicate():
		total += max(1, int(pickup.get("value", 1)))
		_collect_pickup(pickup)
	return total


func _pick_field_item_type() -> String:
	var total := 0
	for item_type in FIELD_ITEM_TYPES:
		total += max(0, int(FIELD_ITEM_WEIGHTS.get(item_type, 0)))
	var roll := rng.randi_range(1, max(1, total))
	for item_type in FIELD_ITEM_TYPES:
		roll -= max(0, int(FIELD_ITEM_WEIGHTS.get(item_type, 0)))
		if roll <= 0:
			return str(item_type)
	return "potion"


func _random_field_item_position() -> Vector2:
	var angle := rng.randf_range(0.0, TAU)
	var distance := rng.randf_range(360.0, 720.0)
	return _clamp_world(_player_pos() + Vector2(cos(angle), sin(angle)) * distance)


func _field_item_label(item_type: String) -> String:
	match item_type:
		"bomb":
			return "폭발 부적"
		"magnet":
			return "흡령 자석"
		"potion":
			return "회복 약수"
		"mine":
			return "영석 광맥"
		_:
			return "필드 보급"


func _field_item_color(item_type: String) -> Color:
	match item_type:
		"bomb":
			return Color(1.0, 0.62, 0.22)
		"magnet":
			return Color(0.22, 0.88, 0.84)
		"potion":
			return Color(0.62, 1.0, 1.0)
		"mine":
			return Color(1.0, 0.84, 0.34)
		_:
			return Color(1.0, 0.90, 0.65)


func _queue_level_choice() -> void:
	choice_pending = true
	level_choices.clear()
	var cards := [
		{"key": "vortex", "name": "물소용돌이", "summary": "주변 요귀를 끌어당기며 반복 피해"},
		{"key": "wave", "name": "파도 밀어내기", "summary": "전방 요귀를 밀어내고 창격 강화"},
		{"key": "spiritfire", "name": "도깨비불", "summary": "가까운 요귀를 추적하는 불꽃"},
		{"key": "ward", "name": "수호 물결", "summary": "회복과 공속 보조"},
	]
	var offset := (run_level + kills) % cards.size()
	for i in range(3):
		var card: Dictionary = cards[(offset + i) % cards.size()].duplicate(true)
		card["next_level"] = _skill_level(str(card.get("key", ""))) + 1
		level_choices.append(card)
	_add_fx(_player_pos(), "level", "영력 각성", Color(1.0, 0.88, 0.48))


func _update_fx(dt: float) -> void:
	for fx in fx_events.duplicate():
		fx["ttl"] = float(fx.get("ttl", 0.0)) - dt
		if float(fx.get("ttl", 0.0)) <= 0.0:
			fx_events.erase(fx)


func _add_fx(pos: Vector2, kind: String, label: String, color: Color, dir := Vector2.RIGHT) -> void:
	fx_events.append({
		"pos": pos,
		"kind": kind,
		"label": label,
		"color": color,
		"dir": dir,
		"ttl": 0.55 if kind != "level" else 1.1,
		"life": 0.55 if kind != "level" else 1.1,
	})
	if fx_events.size() > 30:
		fx_events.pop_front()


func _check_result() -> void:
	if float(player.get("hp", 0.0)) <= 0.0:
		running = false
		result = "defeat"
	elif elapsed >= RUN_SECONDS:
		running = false
		result = "clear"


func _draw() -> void:
	var rect := Rect2(Vector2.ZERO, size)
	if rect.size.x <= 0.0 or rect.size.y <= 0.0:
		rect.size = VIEW_SIZE
	if screen_mode == MODE_HOME:
		_draw_home_background(rect)
		return
	draw_rect(rect, Color(0.035, 0.058, 0.045))
	_draw_world()
	_draw_entities()
	_draw_fx()
	if not use_generated_hud:
		_draw_hud()
	if choice_pending:
		_draw_level_choices()
	if not running:
		_draw_result()


func _draw_home_background(rect: Rect2) -> void:
	draw_texture_rect(TEX_OUT_COURTYARD_BG_V2, rect, false)
	draw_rect(Rect2(0, 0, rect.size.x, 116), Color(0.0, 0.0, 0.0, 0.20))
	draw_rect(Rect2(0, rect.size.y - 190, rect.size.x, 190), Color(0.0, 0.0, 0.0, 0.24))
	draw_rect(Rect2(0, 0, 18, rect.size.y), Color(0.0, 0.0, 0.0, 0.08))
	draw_rect(Rect2(rect.size.x - 18, 0, 18, rect.size.y), Color(0.0, 0.0, 0.0, 0.08))
	return
	draw_rect(rect, Color(0.075, 0.064, 0.072))
	draw_rect(Rect2(0, 0, rect.size.x, 190), Color(0.13, 0.10, 0.16))
	draw_rect(Rect2(0, 120, rect.size.x, 300), Color(0.20, 0.115, 0.075, 0.52))
	var dusk := PackedVector2Array([
		Vector2(0, 94),
		Vector2(rect.size.x, 60),
		Vector2(rect.size.x, 220),
		Vector2(0, 242),
	])
	draw_colored_polygon(dusk, Color(0.47, 0.19, 0.11, 0.38))
	_draw_home_roofs()
	_draw_home_courtyard_floor(rect)
	_draw_home_lantern(Vector2(72, 252), 1.0)
	_draw_home_lantern(Vector2(318, 212), 0.72)
	_draw_home_spirit_well(Vector2(310, 424))
	_draw_home_side_banner(Vector2(34, 158))
	_draw_home_talisman_posts()
	for i in range(42):
		var seed := float(i)
		var x := fmod(seed * 83.0 + 18.0, rect.size.x + 64.0) - 32.0
		var y := fmod(seed * 127.0 + 170.0, 706.0) + 92.0
		var color := Color(0.70, 0.25, 0.08, 0.50) if i % 3 == 0 else Color(0.86, 0.46, 0.14, 0.38)
		_draw_autumn_leaf(Vector2(x, y), seed * 0.82, color)
	draw_rect(Rect2(0, 0, rect.size.x, 98), Color(0, 0, 0, 0.18))
	draw_rect(Rect2(0, 828, rect.size.x, 132), Color(0, 0, 0, 0.32))
	draw_rect(Rect2(0, 0, 22, rect.size.y), Color(0, 0, 0, 0.12))
	draw_rect(Rect2(rect.size.x - 22, 0, 22, rect.size.y), Color(0, 0, 0, 0.12))


func _draw_home_roofs() -> void:
	var left_roof := PackedVector2Array([
		Vector2(-50, 124),
		Vector2(210, 92),
		Vector2(248, 148),
		Vector2(-30, 184),
	])
	draw_colored_polygon(left_roof, Color(0.035, 0.045, 0.052, 0.95))
	var right_roof := PackedVector2Array([
		Vector2(250, 116),
		Vector2(552, 86),
		Vector2(588, 148),
		Vector2(224, 184),
	])
	draw_colored_polygon(right_roof, Color(0.040, 0.052, 0.057, 0.96))
	for i in range(12):
		var x := -20.0 + float(i) * 27.0
		draw_line(Vector2(x, 128), Vector2(x + 20.0, 178), Color(0.16, 0.17, 0.17, 0.36), 2.0)
	for i in range(14):
		var x := 252.0 + float(i) * 27.0
		draw_line(Vector2(x, 120), Vector2(x + 18.0, 176), Color(0.16, 0.17, 0.17, 0.34), 2.0)
	draw_rect(Rect2(38, 180, 172, 170), Color(0.15, 0.075, 0.04, 0.58))
	draw_rect(Rect2(278, 176, 190, 132), Color(0.14, 0.070, 0.035, 0.54))


func _draw_home_courtyard_floor(rect: Rect2) -> void:
	var floor_rect := Rect2(0, 318, rect.size.x, 526)
	draw_rect(floor_rect, Color(0.17, 0.115, 0.078))
	var path := PackedVector2Array([
		Vector2(196, 318),
		Vector2(386, 318),
		Vector2(428, 840),
		Vector2(142, 840),
	])
	draw_colored_polygon(path, Color(0.27, 0.22, 0.155, 0.66))
	for i in range(9):
		var y := 352.0 + float(i) * 58.0
		var x := 262.0 + sin(float(i) * 0.9) * 28.0
		_draw_soft_ellipse(Vector2(x, y + 24.0), Vector2(150.0, 28.0), Color(0.04, 0.025, 0.018, 0.15))
		draw_rect(Rect2(x - 72.0, y - 17.0, 144.0, 38.0), Color(0.42, 0.34, 0.24, 0.22))
	for p in [Vector2(64, 520), Vector2(330, 570), Vector2(64, 742), Vector2(496, 604)]:
		_draw_soft_ellipse(p + Vector2(0, 20), Vector2(72, 22), Color(0, 0, 0, 0.18))
		draw_circle(p, 24, Color(0.30, 0.25, 0.20, 0.62))
		draw_circle(p + Vector2(24, 8), 16, Color(0.20, 0.17, 0.14, 0.62))


func _draw_home_lantern(origin: Vector2, scale: float) -> void:
	draw_line(origin + Vector2(0, -42) * scale, origin + Vector2(0, 42) * scale, Color(0.06, 0.035, 0.02, 0.82), 4.0 * scale)
	draw_circle(origin, 20.0 * scale, Color(0.92, 0.47, 0.15, 0.24))
	draw_circle(origin, 12.0 * scale, Color(1.0, 0.66, 0.28, 0.88))
	draw_rect(Rect2(origin.x - 13.0 * scale, origin.y - 18.0 * scale, 26.0 * scale, 36.0 * scale), Color(0.84, 0.36, 0.13, 0.28))


func _draw_home_spirit_well(center: Vector2) -> void:
	_draw_soft_ellipse(center + Vector2(0, 54), Vector2(138, 34), Color(0, 0, 0, 0.23))
	draw_circle(center + Vector2(0, 34), 48, Color(0.09, 0.07, 0.06, 0.86))
	draw_circle(center + Vector2(0, 34), 35, Color(0.05, 0.09, 0.10, 0.92))
	for i in range(4):
		var phase := float(i) * 1.42
		var flame_center := center + Vector2(sin(phase) * 16.0, -16.0 - float(i) * 7.0)
		draw_circle(flame_center, 22.0 - float(i) * 2.5, Color(0.12, 0.66, 1.0, 0.26))
		draw_arc(flame_center, 18.0 - float(i), -1.9, 1.1, 18, Color(0.42, 0.92, 1.0, 0.76), 4.0)
	draw_circle(center + Vector2(0, -8), 8, Color(0.78, 1.0, 1.0, 0.88))


func _draw_home_side_banner(origin: Vector2) -> void:
	draw_line(origin + Vector2(0, -24), origin + Vector2(0, 88), Color(0.09, 0.045, 0.025, 0.92), 4.0)
	var banner := PackedVector2Array([
		origin + Vector2(12, -6),
		origin + Vector2(72, 12),
		origin + Vector2(58, 92),
		origin + Vector2(38, 74),
		origin + Vector2(16, 92),
	])
	draw_colored_polygon(banner, Color(0.13, 0.11, 0.08, 0.90))
	draw_arc(origin + Vector2(44, 38), 23, 0, TAU, 24, Color(0.72, 0.52, 0.24, 0.82), 2.4)
	draw_line(origin + Vector2(28, 24), origin + Vector2(58, 52), Color(0.88, 0.28, 0.13, 0.72), 3.0)
	draw_line(origin + Vector2(58, 24), origin + Vector2(28, 52), Color(0.88, 0.28, 0.13, 0.72), 3.0)


func _draw_home_talisman_posts() -> void:
	for p in [Vector2(182, 226), Vector2(456, 238), Vector2(114, 610)]:
		draw_line(p + Vector2(0, -38), p + Vector2(0, 46), Color(0.12, 0.065, 0.03, 0.78), 3.0)
		draw_rect(Rect2(p.x - 9, p.y - 36, 18, 42), Color(0.82, 0.64, 0.34, 0.68))
		draw_line(p + Vector2(-5, -21), p + Vector2(5, -21), Color(0.54, 0.10, 0.06, 0.80), 1.5)
		draw_line(p + Vector2(-4, -8), p + Vector2(5, -2), Color(0.54, 0.10, 0.06, 0.80), 1.5)


func _draw_world() -> void:
	var bg_rect := Rect2(Vector2.ZERO, size)
	draw_rect(bg_rect, Color(0.19, 0.125, 0.078))
	draw_rect(bg_rect, Color(0.33, 0.20, 0.105, 0.18))
	var grid_color := Color(0.42, 0.30, 0.18, 0.19)
	var tile := 128.0
	var camera_mod := Vector2(fmod(camera_pos.x, tile), fmod(camera_pos.y, tile))
	var start_x := -camera_mod.x
	while start_x < size.x + tile:
		draw_line(Vector2(start_x, 0), Vector2(start_x, size.y), grid_color, 1.0)
		start_x += tile
	var start_y := -camera_mod.y
	while start_y < size.y + tile:
		draw_line(Vector2(0, start_y), Vector2(size.x, start_y), grid_color, 1.0)
		start_y += tile
	_draw_autumn_ground_detail()
	_draw_tangtang_props()
	_draw_vignette()


func _draw_environment_props() -> void:
	var props := [
		{"pos": WORLD_CENTER + Vector2(-520, -290), "kind": "bamboo"},
		{"pos": WORLD_CENTER + Vector2(420, -360), "kind": "gate"},
		{"pos": WORLD_CENTER + Vector2(-420, 330), "kind": "stone"},
		{"pos": WORLD_CENTER + Vector2(580, 260), "kind": "lantern"},
		{"pos": WORLD_CENTER + Vector2(120, -520), "kind": "talisman"},
	]
	for prop in props:
		var sp: Vector2 = _world_to_screen(prop.get("pos", WORLD_CENTER))
		match str(prop.get("kind", "")):
			"bamboo":
				for i in range(4):
					var x := sp.x + float(i) * 8.0
					draw_line(Vector2(x, sp.y - 54.0), Vector2(x - 4.0, sp.y + 24.0), Color(0.21, 0.44, 0.25), 3.0)
				draw_circle(sp + Vector2(10, -42), 24.0, Color(0.15, 0.34, 0.19, 0.65))
			"gate":
				draw_rect(Rect2(sp.x - 54, sp.y - 44, 108, 18), Color(0.13, 0.07, 0.04))
				draw_rect(Rect2(sp.x - 46, sp.y - 64, 92, 18), Color(0.09, 0.14, 0.18))
				draw_rect(Rect2(sp.x - 42, sp.y - 26, 12, 58), Color(0.42, 0.12, 0.08))
				draw_rect(Rect2(sp.x + 30, sp.y - 26, 12, 58), Color(0.42, 0.12, 0.08))
			"stone":
				draw_circle(sp, 31, Color(0.25, 0.27, 0.24))
				draw_circle(sp + Vector2(25, 12), 19, Color(0.19, 0.21, 0.19))
			"lantern":
				draw_line(sp + Vector2(0, -50), sp + Vector2(0, 38), Color(0.09, 0.06, 0.04), 4.0)
				draw_circle(sp + Vector2(0, -22), 12, Color(0.92, 0.62, 0.22, 0.92))
			"talisman":
				draw_rect(Rect2(sp.x - 12, sp.y - 36, 24, 64), Color(0.92, 0.78, 0.45))
				draw_line(sp + Vector2(-8, -18), sp + Vector2(8, -18), Color(0.48, 0.09, 0.06), 2.0)


func _draw_tangtang_props() -> void:
	var world_props := [
		{"pos": WORLD_CENTER + Vector2(-820, -480), "kind": "cart"},
		{"pos": WORLD_CENTER + Vector2(760, -430), "kind": "roof"},
		{"pos": WORLD_CENTER + Vector2(-720, 430), "kind": "fence"},
		{"pos": WORLD_CENTER + Vector2(720, 475), "kind": "barrels"},
		{"pos": WORLD_CENTER + Vector2(-525, -210), "kind": "stone"},
		{"pos": WORLD_CENTER + Vector2(535, -125), "kind": "stone"},
		{"pos": WORLD_CENTER + Vector2(-355, -670), "kind": "talisman_post"},
		{"pos": WORLD_CENTER + Vector2(350, 660), "kind": "talisman_post"},
		{"pos": WORLD_CENTER + Vector2(-805, 90), "kind": "red_tree"},
		{"pos": WORLD_CENTER + Vector2(835, 70), "kind": "red_tree"},
	]
	for prop in world_props:
		var sp: Vector2 = _world_to_screen(prop.get("pos", WORLD_CENTER))
		if sp.x < -140 or sp.y < -140 or sp.x > size.x + 140 or sp.y > size.y + 140:
			continue
		match str(prop.get("kind", "")):
			"stone":
				_draw_soft_ellipse(sp + Vector2(0, 18), Vector2(72, 24), Color(0, 0, 0, 0.18))
				draw_circle(sp, 25, Color(0.30, 0.285, 0.235, 0.78))
				draw_circle(sp + Vector2(23, 9), 17, Color(0.21, 0.205, 0.17, 0.78))
			"cart":
				_draw_soft_ellipse(sp + Vector2(2, 28), Vector2(116, 28), Color(0, 0, 0, 0.21))
				draw_rect(Rect2(sp.x - 52, sp.y - 16, 92, 34), Color(0.31, 0.16, 0.075, 0.90))
				draw_rect(Rect2(sp.x - 45, sp.y - 10, 80, 7), Color(0.56, 0.31, 0.13, 0.82))
				draw_line(sp + Vector2(38, -8), sp + Vector2(78, -28), Color(0.27, 0.13, 0.06), 5.0)
				draw_circle(sp + Vector2(-34, 23), 12, Color(0.08, 0.055, 0.035))
				draw_circle(sp + Vector2(28, 23), 12, Color(0.08, 0.055, 0.035))
			"barrels":
				_draw_soft_ellipse(sp + Vector2(0, 26), Vector2(92, 24), Color(0, 0, 0, 0.19))
				for i in range(3):
					var barrel_pos := sp + Vector2(float(i - 1) * 26.0, float(i % 2) * 8.0)
					draw_circle(barrel_pos, 17, Color(0.42, 0.22, 0.10, 0.92))
					draw_line(barrel_pos + Vector2(-12, -6), barrel_pos + Vector2(12, -6), Color(0.68, 0.48, 0.24, 0.70), 2.0)
					draw_line(barrel_pos + Vector2(-12, 7), barrel_pos + Vector2(12, 7), Color(0.13, 0.07, 0.035, 0.74), 2.0)
			"fence":
				_draw_soft_ellipse(sp + Vector2(6, 28), Vector2(132, 24), Color(0, 0, 0, 0.17))
				for i in range(6):
					var x := sp.x - 58.0 + float(i) * 23.0
					draw_line(Vector2(x, sp.y - 28), Vector2(x + 4.0, sp.y + 36), Color(0.25, 0.115, 0.055, 0.90), 5.0)
				draw_line(sp + Vector2(-65, -7), sp + Vector2(67, -16), Color(0.39, 0.19, 0.08, 0.88), 5.0)
				draw_line(sp + Vector2(-61, 17), sp + Vector2(69, 9), Color(0.32, 0.15, 0.07, 0.88), 5.0)
			"roof":
				var roof_poly := PackedVector2Array([
					sp + Vector2(-72, -24),
					sp + Vector2(72, -34),
					sp + Vector2(94, 18),
					sp + Vector2(-92, 25),
				])
				draw_colored_polygon(roof_poly, Color(0.075, 0.105, 0.125, 0.94))
				for i in range(8):
					var x := sp.x - 70.0 + float(i) * 22.0
					draw_line(Vector2(x, sp.y - 23), Vector2(x + 16.0, sp.y + 20), Color(0.18, 0.22, 0.24, 0.55), 2.0)
				draw_rect(Rect2(sp.x - 60, sp.y + 22, 120, 44), Color(0.36, 0.105, 0.055, 0.82))
			"talisman_post":
				draw_line(sp + Vector2(0, -54), sp + Vector2(0, 40), Color(0.14, 0.075, 0.035, 0.90), 4.0)
				draw_rect(Rect2(sp.x - 12, sp.y - 50, 24, 48), Color(0.86, 0.70, 0.38, 0.78))
				draw_line(sp + Vector2(-7, -34), sp + Vector2(7, -34), Color(0.58, 0.11, 0.07, 0.90), 2.0)
				draw_line(sp + Vector2(-6, -18), sp + Vector2(6, -10), Color(0.58, 0.11, 0.07, 0.90), 2.0)
			"red_tree":
				draw_line(sp + Vector2(0, 36), sp + Vector2(10, -38), Color(0.18, 0.095, 0.045, 0.80), 9.0)
				for i in range(7):
					var leaf_pos := sp + Vector2(sin(float(i) * 2.1) * 34.0, -44.0 + cos(float(i) * 1.7) * 18.0)
					draw_circle(leaf_pos, 21.0 - float(i % 3) * 3.0, Color(0.48, 0.13, 0.07, 0.52))


func _draw_autumn_ground_detail() -> void:
	var path_points := PackedVector2Array([
		Vector2(size.x * 0.39, 126.0),
		Vector2(size.x * 0.63, 126.0),
		Vector2(size.x * 0.58, size.y - 116.0),
		Vector2(size.x * 0.35, size.y - 116.0),
	])
	draw_colored_polygon(path_points, Color(0.26, 0.205, 0.145, 0.42))
	var slab_offset := fmod(camera_pos.y * 0.46, 118.0)
	for i in range(-1, 10):
		var y := 136.0 + float(i) * 118.0 - slab_offset
		var x := size.x * 0.50 + sin((camera_pos.y * 0.005) + float(i) * 0.9) * 22.0
		var width := 126.0 + sin(float(i) * 1.4) * 16.0
		_draw_soft_ellipse(Vector2(x, y + 22), Vector2(width, 34), Color(0.04, 0.025, 0.018, 0.16))
		var slab := Rect2(x - width * 0.5, y - 22.0, width, 54.0)
		draw_rect(slab, Color(0.35, 0.315, 0.245, 0.36))
		draw_rect(Rect2(slab.position + Vector2(5, 5), slab.size - Vector2(10, 10)), Color(0.49, 0.405, 0.285, 0.20), false, 2.0)
	for i in range(62):
		var seed := float(i)
		var x := fmod(seed * 97.0 - camera_pos.x * 0.18, size.x + 72.0) - 36.0
		var y := fmod(seed * 151.0 - camera_pos.y * 0.22, size.y + 118.0) - 28.0
		if y < 128.0:
			continue
		var warm := Color(0.55, 0.17, 0.07, 0.58) if i % 3 == 0 else Color(0.76, 0.42, 0.13, 0.44)
		_draw_autumn_leaf(Vector2(x, y), seed * 0.73, warm)
	for i in range(12):
		var x := fmod(float(i) * 173.0 - camera_pos.x * 0.12, size.x + 46.0) - 23.0
		var y := fmod(float(i) * 229.0 - camera_pos.y * 0.11, size.y + 92.0) - 18.0
		if y < 140.0:
			continue
		var sp := Vector2(x, y)
		draw_rect(Rect2(sp.x - 5, sp.y - 12, 10, 24), Color(0.86, 0.68, 0.36, 0.34))
		draw_line(sp + Vector2(-3, -3), sp + Vector2(3, -3), Color(0.55, 0.10, 0.06, 0.48), 1.0)
	_draw_autumn_edge_props()


func _draw_autumn_edge_props() -> void:
	var roof := PackedVector2Array([
		Vector2(size.x - 112.0, 150.0),
		Vector2(size.x + 18.0, 138.0),
		Vector2(size.x + 42.0, 190.0),
		Vector2(size.x - 132.0, 202.0),
	])
	draw_colored_polygon(roof, Color(0.055, 0.075, 0.09, 0.66))
	for i in range(7):
		var x := size.x - 108.0 + float(i) * 22.0
		draw_line(Vector2(x, 153.0), Vector2(x + 16.0, 198.0), Color(0.18, 0.22, 0.24, 0.36), 2.0)
	draw_line(Vector2(16.0, 760.0), Vector2(162.0, 744.0), Color(0.34, 0.16, 0.075, 0.50), 5.0)
	draw_line(Vector2(18.0, 785.0), Vector2(158.0, 770.0), Color(0.28, 0.13, 0.06, 0.48), 5.0)
	for i in range(6):
		var x := 28.0 + float(i) * 25.0
		draw_line(Vector2(x, 728.0), Vector2(x + 4.0, 806.0), Color(0.22, 0.10, 0.05, 0.50), 5.0)
	for i in range(2):
		var barrel_pos := Vector2(size.x - 34.0 - float(i) * 28.0, 610.0 + float(i) * 16.0)
		draw_circle(barrel_pos, 17.0, Color(0.42, 0.22, 0.10, 0.58))
		draw_line(barrel_pos + Vector2(-12, -6), barrel_pos + Vector2(12, -6), Color(0.68, 0.48, 0.24, 0.46), 2.0)


func _draw_autumn_leaf(pos: Vector2, angle: float, color: Color) -> void:
	var dir := Vector2(cos(angle), sin(angle))
	var side := Vector2(-dir.y, dir.x)
	var leaf := PackedVector2Array([
		pos + dir * 7.0,
		pos + side * 3.0,
		pos - dir * 6.0,
		pos - side * 3.0,
	])
	draw_colored_polygon(leaf, color)
	draw_line(pos - dir * 5.0, pos + dir * 5.0, Color(color.r * 0.65, color.g * 0.55, color.b * 0.45, color.a), 1.0)


func _draw_vignette() -> void:
	draw_rect(Rect2(0.0, 0.0, size.x, 118.0), Color(0.0, 0.0, 0.0, 0.30))
	draw_rect(Rect2(0.0, 118.0, size.x, 34.0), Color(0.0, 0.0, 0.0, 0.10))
	draw_rect(Rect2(0.0, size.y - 96.0, size.x, 96.0), Color(0.0, 0.0, 0.0, 0.24))
	draw_rect(Rect2(0.0, 0.0, 18.0, size.y), Color(0.0, 0.0, 0.0, 0.12))
	draw_rect(Rect2(size.x - 18.0, 0.0, 18.0, size.y), Color(0.0, 0.0, 0.0, 0.12))


func _draw_ground_decoration() -> void:
	var path_color := Color(0.16, 0.18, 0.15, 0.52)
	var path_shadow := Color(0.02, 0.025, 0.02, 0.18)
	var path_points := PackedVector2Array([
		Vector2(-80, 340),
		Vector2(190, 230),
		Vector2(620, 420),
		Vector2(620, 510),
		Vector2(170, 312),
		Vector2(-80, 428),
	])
	draw_colored_polygon(path_points, path_shadow)
	var inner_path := PackedVector2Array([
		Vector2(-40, 350),
		Vector2(188, 258),
		Vector2(590, 436),
		Vector2(590, 480),
		Vector2(172, 300),
		Vector2(-40, 402),
	])
	draw_colored_polygon(inner_path, path_color)
	for i in range(8):
		var p := Vector2(34.0 + float(i) * 68.0, 356.0 + sin(float(i)) * 28.0)
		_draw_soft_ellipse(p, Vector2(44, 19), Color(0.23, 0.25, 0.22, 0.45))
	for p in [Vector2(70, 205), Vector2(430, 185), Vector2(478, 642), Vector2(108, 676)]:
		_draw_soft_ellipse(p + Vector2(0, 22), Vector2(58, 20), Color(0, 0, 0, 0.18))
		draw_circle(p, 24, Color(0.18, 0.22, 0.19, 0.7))
		draw_circle(p + Vector2(18, 8), 15, Color(0.12, 0.16, 0.14, 0.7))
	for p in [Vector2(55, 285), Vector2(505, 303), Vector2(462, 575)]:
		draw_circle(p, 9, Color(0.18, 0.82, 0.72, 0.45))
		draw_circle(p, 4, Color(0.62, 1.0, 0.92, 0.75))
	for p in [Vector2(142, 166), Vector2(396, 712)]:
		draw_rect(Rect2(p.x - 8, p.y - 22, 16, 43), Color(0.82, 0.68, 0.38, 0.72))
		draw_line(p + Vector2(-5, -9), p + Vector2(5, -9), Color(0.55, 0.10, 0.07, 0.8), 2.0)


func _draw_entities() -> void:
	var drawables := []
	for enemy in enemies:
		drawables.append({"team": "enemy", "data": enemy, "y": _screen_y(enemy.get("pos", Vector2.ZERO))})
	drawables.append({"team": "player", "data": player, "y": _screen_y(_player_pos())})
	drawables.sort_custom(func(a, b): return float(a.get("y", 0.0)) < float(b.get("y", 0.0)))
	for pickup in pickups:
		_draw_pickup(pickup)
	for item in field_items:
		_draw_field_item(item)
	for item in drawables:
		if str(item.get("team", "")) == "enemy":
			_draw_enemy(item.get("data", {}))
		else:
			_draw_player()


func _draw_pickup(pickup: Dictionary) -> void:
	var sp: Vector2 = _world_to_screen(pickup.get("pos", WORLD_CENTER))
	var age: float = float(pickup.get("age", 0.0))
	var armed: bool = bool(pickup.get("armed", false))
	var pulse: float = 1.0 + sin(age * 8.0) * 0.1
	var alpha: float = 0.92 if armed else 0.42
	if armed and magnet_remaining > 0.0:
		var player_screen := _world_to_screen(_player_pos())
		var pull_alpha: float = clamp(1.0 - sp.distance_to(player_screen) / (PICKUP_MAGNET_RADIUS * 1.85), 0.0, 0.48)
		if pull_alpha > 0.02:
			draw_line(sp, player_screen, Color(0.62, 1.0, 1.0, pull_alpha), 1.2)
	var shard := PackedVector2Array([
		sp + Vector2(0, -8.0 * pulse),
		sp + Vector2(6.0 * pulse, 0),
		sp + Vector2(0, 8.0 * pulse),
		sp + Vector2(-6.0 * pulse, 0),
	])
	draw_circle(sp, 12.0 * pulse, Color(0.18, 0.78, 1.0, alpha * 0.24))
	draw_colored_polygon(shard, Color(0.33, 0.91, 1.0, alpha))
	draw_circle(sp, 2.8 * pulse, Color(0.84, 1.0, 1.0, min(1.0, alpha + 0.08)))


func _draw_field_item(item: Dictionary) -> void:
	var sp: Vector2 = _world_to_screen(item.get("pos", WORLD_CENTER))
	var item_type := str(item.get("type", ""))
	var pulse: float = 1.0 + sin(float(item.get("age", 0.0)) * 5.8 + float(int(item.get("id", 0)))) * 0.08
	var color := _field_item_color(item_type)
	var glow := color
	glow.a = 0.24
	draw_circle(sp, 24.0 * pulse, glow)
	draw_circle(sp, 14.0 * pulse, Color(0.055, 0.045, 0.035, 0.92))
	draw_arc(sp, 18.0 * pulse, 0.0, TAU, 28, color, 2.0)
	var ttl_ratio: float = 1.0 - clamp(float(item.get("age", 0.0)) / max(0.1, float(item.get("ttl", FIELD_ITEM_TTL))), 0.0, 1.0)
	draw_arc(sp, 23.0 * pulse, -PI * 0.5, -PI * 0.5 + TAU * ttl_ratio, 28, Color(color.r, color.g, color.b, 0.62), 2.4)
	_draw_small_world_label(sp + Vector2(0, -28.0), _short_field_item_label(item_type), color)
	match item_type:
		"bomb":
			draw_line(sp + Vector2(-8, 5), sp + Vector2(8, -7), color, 4.0)
			draw_line(sp + Vector2(-7, -6), sp + Vector2(8, 7), color, 4.0)
		"magnet":
			draw_arc(sp + Vector2(0, 1), 9.0, PI * 0.12, PI * 0.88, 16, color, 4.0)
			draw_line(sp + Vector2(-9, 1), sp + Vector2(-9, 8), color, 3.0)
			draw_line(sp + Vector2(9, 1), sp + Vector2(9, 8), color, 3.0)
		"potion":
			draw_rect(Rect2(sp.x - 6, sp.y - 9, 12, 18), Color(color.r, color.g, color.b, 0.72))
			draw_rect(Rect2(sp.x - 4, sp.y - 14, 8, 5), Color(0.92, 0.96, 0.82, 0.82))
		"mine":
			var progress: float = clamp(float(item.get("progress", 0.0)), 0.0, 1.0)
			draw_circle(sp, 11.0, Color(0.43, 0.31, 0.16, 0.92))
			draw_circle(sp + Vector2(4, -4), 4.0, color)
			if progress > 0.0:
				draw_arc(sp, 25.0, -PI * 0.5, -PI * 0.5 + TAU * progress, 24, Color(1.0, 0.94, 0.55, 0.95), 4.0)
		_:
			draw_circle(sp, 7.0, color)


func _draw_player() -> void:
	var sp := _world_to_screen(_player_pos())
	var facing: Vector2 = player.get("facing", Vector2.RIGHT)
	var bob: float = sin(player_walk_phase) * 2.6 if player_moving else 0.0
	var stride: float = abs(sin(player_walk_phase)) if player_moving else 0.0
	var step_b: bool = player_moving and sin(player_walk_phase) >= 0.0
	var threat: float = _nearest_enemy_distance()
	if threat < THREAT_RING_RADIUS:
		var danger_ratio: float = 1.0 - clamp(threat / THREAT_RING_RADIUS, 0.0, 1.0)
		draw_arc(sp + Vector2(0, 12), 52.0 + danger_ratio * 10.0, 0.0, TAU, 46, Color(1.0, 0.34, 0.16, 0.22 + danger_ratio * 0.28), 3.0)
	if magnet_remaining > 0.0:
		draw_arc(sp + Vector2(0, 10), 70.0 + sin(elapsed * 8.0) * 4.0, -elapsed * 2.8, -elapsed * 2.8 + PI * 1.6, 44, Color(0.62, 1.0, 1.0, 0.45), 3.0)
	_draw_soft_ellipse(sp + Vector2(0, 31), Vector2(51 + stride * 6.0, 15 + stride * 2.0), Color(0, 0, 0, 0.28))
	if player_moving:
		_draw_player_step_feedback(sp + Vector2(0, 39), facing)
	_draw_unit_texture(_player_direction_texture(facing, step_b), sp + Vector2(0, 43 + bob), PLAYER_SPRITE_HEIGHT + stride * 1.2)


func _player_direction_texture(facing: Vector2, step_b: bool) -> Texture2D:
	if abs(facing.x) > abs(facing.y):
		if facing.x >= 0.0:
			return TEX_HAEIL_RIGHT_WALK_B if step_b else TEX_HAEIL_RIGHT
		return TEX_HAEIL_LEFT_WALK_B if step_b else TEX_HAEIL_LEFT
	if facing.y < 0.0:
		return TEX_HAEIL_UP_WALK_B if step_b else TEX_HAEIL_UP
	return TEX_HAEIL_DOWN_WALK_B if step_b else TEX_HAEIL_DOWN


func _draw_player_step_feedback(foot: Vector2, facing: Vector2) -> void:
	var direction := facing.normalized()
	if direction.length_squared() <= 0.001:
		direction = Vector2.DOWN
	var side := Vector2(-direction.y, direction.x)
	var step_side := side * (9.0 if sin(player_walk_phase) >= 0.0 else -9.0)
	var step_pos := foot - direction * 8.0 + step_side
	draw_circle(step_pos, 3.2, Color(0.42, 0.94, 1.0, 0.58))
	draw_circle(step_pos + direction * 5.0 - step_side * 0.32, 2.1, Color(0.90, 1.0, 1.0, 0.42))


func _draw_player_fallback(sp: Vector2, facing: Vector2) -> void:
	_draw_soft_ellipse(sp + Vector2(0, 24), Vector2(58, 18), Color(0, 0, 0, 0.28))
	var spear_tip := sp + facing * 54.0 + Vector2(0, -12)
	draw_line(sp + Vector2(0, -12), spear_tip, Color(0.78, 0.80, 0.76), 4.0)
	draw_line(sp + Vector2(0, -12), spear_tip, Color(0.95, 0.98, 1.0), 1.5)
	draw_circle(spear_tip, 5.0, Color(0.94, 0.98, 1.0))
	var coat := PackedVector2Array([
		sp + Vector2(-19, -24),
		sp + Vector2(18, -24),
		sp + Vector2(23, 18),
		sp + Vector2(0, 28),
		sp + Vector2(-23, 18),
	])
	draw_colored_polygon(coat, Color(0.045, 0.088, 0.14))
	var vest := PackedVector2Array([
		sp + Vector2(-13, -19),
		sp + Vector2(13, -19),
		sp + Vector2(12, 15),
		sp + Vector2(0, 23),
		sp + Vector2(-12, 15),
	])
	draw_colored_polygon(vest, Color(0.10, 0.31, 0.52))
	draw_line(sp + Vector2(-14, -10), sp + Vector2(14, 10), Color(0.88, 0.84, 0.72), 4.0)
	draw_line(sp + Vector2(14, -10), sp + Vector2(-12, 11), Color(0.06, 0.13, 0.18), 3.0)
	draw_line(sp + Vector2(-16, 1), sp + Vector2(19, 3), Color(0.74, 0.08, 0.055), 5.0)
	draw_line(sp + Vector2(-12, 28), sp + Vector2(-9, 43), Color(0.035, 0.04, 0.045), 5.0)
	draw_line(sp + Vector2(11, 28), sp + Vector2(14, 43), Color(0.035, 0.04, 0.045), 5.0)
	var head := sp + Vector2(0, -38)
	draw_circle(head, 18.5, Color(0.89, 0.68, 0.49))
	draw_circle(head + Vector2(-13, -9), 7.0, Color(0.018, 0.026, 0.04))
	draw_circle(head + Vector2(14, -11), 8.5, Color(0.018, 0.026, 0.04))
	draw_arc(head + Vector2(0, -5), 22, PI * 1.08, PI * 1.95, 20, Color(0.018, 0.026, 0.04), 7.0)
	draw_line(head + Vector2(-23, -10), head + Vector2(23, -10), Color(0.03, 0.19, 0.39), 6.0)
	draw_line(head + Vector2(8, -27), head + Vector2(23, -40), Color(0.03, 0.19, 0.39), 5.0)
	draw_line(head + Vector2(12, -27), head + Vector2(18, -48), Color(0.03, 0.19, 0.39), 4.0)
	draw_rect(Rect2(head.x - 7, head.y - 20, 14, 10), Color(0.83, 0.61, 0.24))
	draw_rect(Rect2(head.x - 2.5, head.y - 17, 5, 5), Color(0.96, 0.78, 0.36))
	draw_line(head + Vector2(-9, -1), head + Vector2(-3, -2), Color(0.025, 0.02, 0.018), 2.0)
	draw_line(head + Vector2(5, -2), head + Vector2(11, -1), Color(0.025, 0.02, 0.018), 2.0)
	draw_arc(head + Vector2(2, 7), 6.5, 0.16, 1.35, 8, Color(0.28, 0.075, 0.035), 1.4)


func _draw_enemy(enemy: Dictionary) -> void:
	var sp: Vector2 = _world_to_screen(enemy.get("pos", WORLD_CENTER))
	var kind: String = str(enemy.get("kind", "japgwi"))
	var flash: bool = float(enemy.get("hit_flash", 0.0)) > 0.0
	var radius: float = float(enemy.get("radius", 22.0))
	var step_b: bool = _enemy_step_b(enemy)
	var texture := _enemy_texture(kind, step_b)
	if texture != null:
		var height := _enemy_sprite_height(kind, radius)
		var modulate := Color(1.0, 0.76, 0.62, 1.0) if flash else Color.WHITE
		var stride: float = _enemy_stride(enemy)
		var bob: float = _enemy_bob(enemy, kind)
		if kind == "night_ogre":
			_draw_boss_presence_ring(sp, radius)
		_draw_soft_ellipse(sp + Vector2(0, radius * 0.72), Vector2(radius * 1.75 + stride * 4.0, radius * 0.48 + stride * 1.2), Color(0, 0, 0, 0.26))
		_draw_unit_texture(texture, sp + Vector2(0, radius * 1.16 + bob), height + stride * 1.2, false, modulate)
		_draw_enemy_hp_bar(sp, radius, enemy)
		return
	_draw_enemy_fallback(enemy, sp, kind, flash, radius)


func _draw_enemy_fallback(enemy: Dictionary, sp: Vector2, kind: String, flash: bool, radius: float) -> void:
	var base := Color(0.14, 0.13, 0.12)
	var accent := Color(0.88, 0.23, 0.14)
	match kind:
		"ghost":
			base = Color(0.64, 0.66, 0.56, 0.68)
			accent = Color(0.35, 0.90, 0.78)
		"grunt":
			base = Color(0.32, 0.26, 0.13)
			accent = Color(0.92, 0.42, 0.16)
		"talisman_caster":
			base = Color(0.30, 0.22, 0.16)
			accent = Color(0.90, 0.72, 0.38)
		"night_ogre":
			base = Color(0.36, 0.12, 0.06)
			accent = Color(1.0, 0.46, 0.15)
		_:
			base = Color(0.18, 0.18, 0.11)
			accent = Color(0.86, 0.28, 0.13)
	if flash:
		base = Color(0.95, 0.92, 0.84)
	_draw_soft_ellipse(sp + Vector2(0, radius * 0.65), Vector2(radius * 1.7, radius * 0.46), Color(0, 0, 0, 0.24))
	draw_circle(sp, radius, base)
	if kind == "night_ogre":
		draw_arc(sp, radius + 14.0, 0.0, TAU, 48, Color(1.0, 0.26, 0.12, 0.55), 4.0)
		draw_line(sp + Vector2(-23, -33), sp + Vector2(-38, -58), accent, 5.0)
		draw_line(sp + Vector2(23, -33), sp + Vector2(38, -58), accent, 5.0)
	elif kind == "talisman_caster":
		draw_rect(Rect2(sp.x - 10, sp.y - radius - 19, 20, 32), Color(0.86, 0.68, 0.36, 0.92))
		draw_line(sp + Vector2(-6, -radius - 8), sp + Vector2(6, -radius - 8), Color(0.58, 0.11, 0.07, 0.92), 2.0)
	elif kind == "ghost":
		draw_rect(Rect2(sp.x - radius * 0.45, sp.y - radius * 1.08, radius * 0.9, radius * 1.22), Color(0.82, 0.72, 0.47, 0.56))
		draw_arc(sp + Vector2(0, 12), radius * 0.75, 0.1, PI - 0.1, 16, accent, 3.0)
	else:
		draw_line(sp + Vector2(-radius * 0.82, -radius * 0.55), sp + Vector2(radius * 0.82, -radius * 0.63), Color(0.76, 0.55, 0.27, 0.72), 4.0)
		draw_arc(sp + Vector2(0, -radius * 0.62), radius * 0.66, PI * 1.05, PI * 1.95, 18, Color(0.64, 0.44, 0.20, 0.62), 4.0)
		draw_line(sp + Vector2(-10, -radius + 4), sp + Vector2(-18, -radius - 14), accent, 3.0)
		draw_line(sp + Vector2(10, -radius + 4), sp + Vector2(18, -radius - 14), accent, 3.0)
	draw_circle(sp + Vector2(-7, -5), 3.0, accent)
	draw_circle(sp + Vector2(7, -5), 3.0, accent)
	_draw_enemy_hp_bar(sp, radius, enemy)


func _draw_enemy_hp_bar(sp: Vector2, radius: float, enemy: Dictionary) -> void:
	var hp_ratio: float = clamp(float(enemy.get("hp", 1.0)) / max(1.0, float(enemy.get("max_hp", 1.0))), 0.0, 1.0)
	if hp_ratio < 0.98:
		draw_rect(Rect2(sp.x - radius, sp.y - radius - 15, radius * 2.0, 4), Color(0.1, 0.02, 0.02, 0.72))
		draw_rect(Rect2(sp.x - radius, sp.y - radius - 15, radius * 2.0 * hp_ratio, 4), Color(0.9, 0.22, 0.13, 0.92))


func _enemy_texture(kind: String, step_b: bool) -> Texture2D:
	match kind:
		"ghost":
			return TEX_MONSTER_GHOST_WALK_B if step_b else TEX_MONSTER_GHOST
		"grunt":
			return TEX_MONSTER_GRUNT_WALK_B if step_b else TEX_MONSTER_GRUNT
		"talisman_caster":
			return TEX_MONSTER_TALISMAN_CASTER_WALK_B if step_b else TEX_MONSTER_TALISMAN_CASTER
		"night_ogre":
			return TEX_MONSTER_NIGHT_OGRE_WALK_B if step_b else TEX_MONSTER_NIGHT_OGRE
		_:
			return TEX_MONSTER_JAPGWI_WALK_B if step_b else TEX_MONSTER_JAPGWI


func _enemy_step_b(enemy: Dictionary) -> bool:
	return sin(_enemy_walk_phase(enemy)) >= 0.0


func _enemy_stride(enemy: Dictionary) -> float:
	return abs(sin(_enemy_walk_phase(enemy)))


func _enemy_bob(enemy: Dictionary, kind: String) -> float:
	var stride: float = _enemy_stride(enemy)
	if kind == "ghost":
		return sin(elapsed * 4.6 + float(int(enemy.get("id", 0))) * 0.4) * 2.2
	return -stride * 2.0


func _enemy_walk_phase(enemy: Dictionary) -> float:
	var kind: String = str(enemy.get("kind", "japgwi"))
	var seed: float = float(int(enemy.get("id", 0))) * 0.61
	return elapsed * _enemy_walk_speed(kind) + seed


func _enemy_walk_speed(kind: String) -> float:
	match kind:
		"ghost":
			return 4.4
		"talisman_caster":
			return 4.8
		"night_ogre":
			return 3.2
		"grunt":
			return 5.5
		_:
			return 6.4


func _enemy_sprite_height(kind: String, radius: float) -> float:
	match kind:
		"ghost":
			return 58.0
		"grunt":
			return 56.0
		"talisman_caster":
			return 64.0
		"night_ogre":
			return 116.0
		_:
			return max(44.0, radius * 2.35)


func _draw_boss_presence_ring(sp: Vector2, radius: float) -> void:
	var pulse := 1.0 + sin(elapsed * 4.0) * 0.05
	var center := sp + Vector2(0, radius * 0.58)
	draw_circle(center, radius * 1.55 * pulse, Color(0.82, 0.22, 0.08, 0.13))
	draw_arc(center, radius * 1.55 * pulse, 0.0, TAU, 48, Color(1.0, 0.45, 0.18, 0.42), 3.0)
	_draw_small_world_label(sp + Vector2(0, -radius - 54.0), "장군", Color(1.0, 0.55, 0.20))


func _draw_unit_texture(texture: Texture2D, foot: Vector2, display_height: float, flip_h := false, modulate := Color.WHITE) -> void:
	if texture == null:
		return
	var texture_size := texture.get_size()
	if texture_size.x <= 0.0 or texture_size.y <= 0.0:
		return
	var display_width := display_height * texture_size.x / texture_size.y
	var rect := Rect2(foot.x - display_width * 0.5, foot.y - display_height, display_width, display_height)
	if not flip_h:
		draw_texture_rect(texture, rect, false, modulate)
		return
	draw_set_transform(Vector2(rect.position.x + rect.size.x, rect.position.y), 0.0, Vector2(-1.0, 1.0))
	draw_texture_rect(texture, Rect2(Vector2.ZERO, rect.size), false, modulate)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


func _draw_fx() -> void:
	for fx in fx_events:
		var pos: Vector2 = fx.get("pos", WORLD_CENTER)
		var sp: Vector2 = _world_to_screen(pos)
		var ttl: float = float(fx.get("ttl", 0.0))
		var life: float = max(0.01, float(fx.get("life", 0.55)))
		var t: float = 1.0 - ttl / life
		var color: Color = fx.get("color", Color.WHITE)
		color.a = 0.75 * (1.0 - t)
		match str(fx.get("kind", "")):
			"water_slash":
				var dir_slash: Vector2 = fx.get("dir", Vector2.RIGHT)
				var start: float = dir_slash.angle() - 0.85
				draw_arc(sp, 74.0 + t * 22.0, start, start + 1.7, 24, color, 9.0)
			"vortex":
				draw_arc(sp, 106.0 + t * 30.0, t * TAU, t * TAU + PI * 1.55, 36, color, 6.0)
				draw_arc(sp, 68.0 + t * 20.0, -t * TAU, -t * TAU + PI * 1.2, 28, color, 4.0)
			"wave":
				var dir_wave: Vector2 = fx.get("dir", Vector2.RIGHT)
				draw_arc(sp, 118.0 + t * 42.0, dir_wave.angle() - 0.55, dir_wave.angle() + 0.55, 24, color, 11.0)
			"spiritfire":
				draw_circle(sp, 18.0 + t * 20.0, color)
			"ward", "level":
				draw_arc(sp, 56.0 + t * 46.0, 0.0, TAU, 48, color, 5.0)
			"encounter_bomb":
				draw_circle(sp, 56.0 + t * 220.0, Color(color.r, color.g, color.b, 0.18 * (1.0 - t)))
				draw_arc(sp, 64.0 + t * 250.0, 0.0, TAU, 64, color, 8.0)
			"encounter_magnet":
				draw_arc(sp, 48.0 + t * 118.0, PI * 0.12, PI * 0.88, 28, color, 7.0)
				draw_arc(sp, 76.0 + t * 98.0, PI * 0.12, PI * 0.88, 28, Color(color.r, color.g, color.b, color.a * 0.64), 4.0)
			"item_spawn", "field_item", "reward":
				draw_circle(sp, 15.0 + t * 28.0, Color(color.r, color.g, color.b, 0.24 * (1.0 - t)))
				draw_arc(sp, 20.0 + t * 34.0, 0.0, TAU, 32, color, 3.0)
			_:
				draw_circle(sp, 18.0 + t * 18.0, color)
		if str(fx.get("label", "")) != "":
			var text_pos := sp + Vector2(-34, -62 - t * 20.0)
			var text_alpha: float = max(0.0, 1.0 - t)
			draw_string(ThemeDB.fallback_font, text_pos + Vector2(1, 1), str(fx.get("label", "")), HORIZONTAL_ALIGNMENT_LEFT, -1.0, 13, Color(0.02, 0.015, 0.01, text_alpha * 0.82))
			draw_string(ThemeDB.fallback_font, text_pos, str(fx.get("label", "")), HORIZONTAL_ALIGNMENT_LEFT, -1.0, 13, Color(color.r, color.g, color.b, text_alpha))


func _draw_hud() -> void:
	_draw_top_hud()
	_draw_wave_track(Rect2(8.0, 106.0, size.x - 16.0, 18.0))
	_draw_controls()
	_draw_exp_bar()


func _draw_top_hud() -> void:
	var left_rect := Rect2(8.0, 8.0, 188.0, 90.0)
	var timer_rect := Rect2(204.0, 8.0, 132.0, 90.0)
	var ledger_rect := Rect2(344.0, 8.0, 142.0, 90.0)
	var pause_rect := Rect2(494.0, 8.0, 38.0, 54.0)
	_draw_panel(left_rect, Color(0.045, 0.038, 0.03, 0.86), Color(0.78, 0.58, 0.28))
	_draw_panel(timer_rect, Color(0.04, 0.035, 0.03, 0.9), Color(0.78, 0.58, 0.28))
	_draw_panel(ledger_rect, Color(0.045, 0.038, 0.032, 0.84), Color(0.61, 0.46, 0.23))
	_draw_panel(pause_rect, Color(0.045, 0.038, 0.032, 0.84), Color(0.71, 0.55, 0.29))

	var portrait := Vector2(45.0, 49.0)
	draw_circle(portrait, 30.0, Color(0.09, 0.18, 0.31))
	draw_circle(portrait + Vector2(0, 4), 22.0, Color(0.88, 0.68, 0.48))
	draw_arc(portrait + Vector2(0, -4), 25.0, PI * 1.03, PI * 1.94, 18, Color(0.02, 0.035, 0.055), 7.0)
	draw_line(portrait + Vector2(-24, -10), portrait + Vector2(24, -10), Color(0.03, 0.19, 0.39), 6.0)
	draw_rect(Rect2(portrait.x - 8, portrait.y - 26, 16, 10), Color(0.84, 0.62, 0.24))
	draw_string(ThemeDB.fallback_font, left_rect.position + Vector2(82, 30), "해일", HORIZONTAL_ALIGNMENT_LEFT, -1.0, 18, Color(0.98, 0.90, 0.68))
	draw_string(ThemeDB.fallback_font, left_rect.position + Vector2(82, 51), "Lv.%d  영력 %d" % [run_level, purified], HORIZONTAL_ALIGNMENT_LEFT, -1.0, 13, Color(0.70, 0.93, 1.0))
	_draw_bar(Rect2(left_rect.position + Vector2(82, 63), Vector2(88, 9)), float(player.get("hp", 0.0)) / PLAYER_MAX_HP, Color(0.88, 0.18, 0.12), Color(0.14, 0.04, 0.035))
	draw_string(ThemeDB.fallback_font, left_rect.position + Vector2(80, 82), "HP %d/%d" % [int(player.get("hp", 0.0)), int(PLAYER_MAX_HP)], HORIZONTAL_ALIGNMENT_LEFT, -1.0, 10, Color(0.80, 0.74, 0.60))

	draw_string(ThemeDB.fallback_font, timer_rect.position + Vector2(0, 31), _format_time(RUN_SECONDS - elapsed), HORIZONTAL_ALIGNMENT_CENTER, timer_rect.size.x, 27, Color(1.0, 0.91, 0.62))
	draw_line(timer_rect.position + Vector2(18, 47), timer_rect.position + Vector2(timer_rect.size.x - 18, 47), Color(0.76, 0.58, 0.30, 0.42), 1.0)
	draw_string(ThemeDB.fallback_font, timer_rect.position + Vector2(0, 67), "STAGE %d/3" % _stage_index(), HORIZONTAL_ALIGNMENT_CENTER, timer_rect.size.x, 15, Color(0.93, 0.74, 0.34))
	_draw_stage_pips(timer_rect.position + Vector2(31, 79))

	_draw_ledger_row(ledger_rect.position + Vector2(12, 24), "처치", kills, Color(1.0, 0.76, 0.28))
	_draw_ledger_row(ledger_rect.position + Vector2(12, 47), "요귀", enemies.size(), Color(0.74, 0.92, 1.0))
	_draw_ledger_row(ledger_rect.position + Vector2(12, 70), "정화", purified, Color(0.55, 0.96, 0.88))
	draw_string(ThemeDB.fallback_font, pause_rect.position + Vector2(0, 36), "Ⅱ", HORIZONTAL_ALIGNMENT_CENTER, pause_rect.size.x, 24, Color(0.98, 0.86, 0.58))


func _draw_controls() -> void:
	var joy := Vector2(88.0, size.y - 134.0)
	draw_circle(joy, 64.0, Color(0.0, 0.0, 0.0, 0.30))
	draw_arc(joy, 64.0, 0.0, TAU, 56, Color(0.92, 0.84, 0.62, 0.50), 2.0)
	for marker in [Vector2(0, -42), Vector2(42, 0), Vector2(0, 42), Vector2(-42, 0)]:
		draw_rect(Rect2(joy + marker - Vector2(4, 4), Vector2(8, 8)), Color(0.88, 0.84, 0.66, 0.26))
	draw_circle(joy, 27.0, Color(0.88, 0.78, 0.58, 0.34))

	_draw_action_button(Vector2(size.x - 76.0, size.y - 144.0), 42.0, "wave", "파", true)
	_draw_action_button(Vector2(size.x - 140.0, size.y - 92.0), 37.0, "vortex", "소", false)
	_draw_action_button(Vector2(size.x - 68.0, size.y - 86.0), 37.0, "spiritfire", "불", false)


func _draw_exp_bar() -> void:
	var rect := Rect2(28.0, size.y - 38.0, size.x - 56.0, 28.0)
	_draw_panel(rect, Color(0.025, 0.035, 0.035, 0.88), Color(0.72, 0.54, 0.27))
	_draw_panel(Rect2(rect.position + Vector2(4, 4), Vector2(84, 20)), Color(0.035, 0.05, 0.05, 0.94), Color(0.98, 0.72, 0.26))
	draw_string(ThemeDB.fallback_font, rect.position + Vector2(4, 18), "영력 Lv.%d" % run_level, HORIZONTAL_ALIGNMENT_CENTER, 84.0, 12, Color(0.70, 0.93, 1.0))
	var track := Rect2(rect.position + Vector2(98, 8), Vector2(rect.size.x - 190.0, 12))
	var exp_ratio: float = clamp(float(run_exp) / max(1.0, float(exp_to_next)), 0.0, 1.0)
	_draw_bar(track, exp_ratio, Color(0.20, 0.68, 1.0), Color(0.035, 0.055, 0.07))
	draw_string(ThemeDB.fallback_font, rect.position + Vector2(rect.size.x - 86, 18), "%d/%d" % [run_exp, exp_to_next], HORIZONTAL_ALIGNMENT_CENTER, 78.0, 12, Color(0.73, 0.92, 1.0))


func _draw_level_choices() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.0, 0.0, 0.0, 0.52))
	var panel := Rect2(14.0, 264.0, size.x - 28.0, 430.0)
	_draw_panel(panel, Color(0.78, 0.61, 0.30, 0.98), Color(0.12, 0.07, 0.035))
	draw_rect(Rect2(panel.position + Vector2(8, 8), Vector2(panel.size.x - 16, 88)), Color(0.13, 0.085, 0.045, 0.94))
	draw_rect(Rect2(panel.position + Vector2(14, 92), Vector2(panel.size.x - 28, 2)), Color(0.94, 0.70, 0.28, 0.72))
	draw_string(ThemeDB.fallback_font, panel.position + Vector2(22, 52), "레벨 업!", HORIZONTAL_ALIGNMENT_LEFT, -1.0, 34, Color(1.0, 0.86, 0.44))
	_draw_panel(Rect2(panel.position + Vector2(panel.size.x - 116, 34), Vector2(88, 52)), Color(0.20, 0.12, 0.05, 0.94), Color(0.82, 0.60, 0.30))
	draw_string(ThemeDB.fallback_font, panel.position + Vector2(panel.size.x - 116, 58), "Lv.%d" % run_level, HORIZONTAL_ALIGNMENT_CENTER, 88.0, 14, Color(1.0, 0.88, 0.62))
	draw_string(ThemeDB.fallback_font, panel.position + Vector2(panel.size.x - 116, 78), "%d 처치" % kills, HORIZONTAL_ALIGNMENT_CENTER, 88.0, 12, Color(0.88, 0.78, 0.58))
	draw_string(ThemeDB.fallback_font, panel.position + Vector2(24, 82), "이번 원정에서 성장할 수련을 선택하세요", HORIZONTAL_ALIGNMENT_LEFT, -1.0, 14, Color(0.95, 0.84, 0.58))
	for i in range(level_choices.size()):
		var card: Dictionary = level_choices[i]
		var rect := Rect2(32.0 + float(i) * 164.0, 366.0, 148.0, 250.0)
		draw_rect(Rect2(rect.position + Vector2(4, 5), rect.size), Color(0.05, 0.035, 0.02, 0.30))
		_draw_panel(rect, Color(0.96, 0.76, 0.34, 0.98), Color(0.12, 0.07, 0.035))
		_draw_panel(Rect2(rect.position + Vector2(8, 8), Vector2(rect.size.x - 16, 28)), Color(0.16, 0.10, 0.045, 0.96), Color(0.88, 0.62, 0.24))
		draw_string(ThemeDB.fallback_font, rect.position + Vector2(8, 29), "NEW", HORIZONTAL_ALIGNMENT_CENTER, rect.size.x - 16, 13, Color(1.0, 0.84, 0.42))
		var icon_color: Color = _skill_color(str(card.get("key", "")))
		var icon_center := rect.position + Vector2(rect.size.x * 0.5, 72)
		draw_circle(icon_center, 34.0, Color(0.05, 0.045, 0.032, 0.98))
		draw_arc(icon_center, 34.0, 0.0, TAU, 42, Color(0.96, 0.72, 0.28, 0.75), 2.5)
		draw_circle(icon_center, 22.0, icon_color)
		draw_string(ThemeDB.fallback_font, rect.position + Vector2(0, 126), str(card.get("name", "")), HORIZONTAL_ALIGNMENT_CENTER, rect.size.x, 17, Color(0.14, 0.08, 0.03))
		_draw_level_pips(rect.position + Vector2(45, 144), int(card.get("next_level", 1)))
		draw_multiline_string(ThemeDB.fallback_font, rect.position + Vector2(16, 178), str(card.get("summary", "")), HORIZONTAL_ALIGNMENT_CENTER, rect.size.x - 32, 14, 5, Color(0.23, 0.14, 0.07))
		_draw_panel(Rect2(rect.position + Vector2(12, 218), Vector2(rect.size.x - 24, 24)), Color(0.04, 0.12, 0.10, 0.96), Color(0.38, 0.78, 0.58))
		draw_string(ThemeDB.fallback_font, rect.position + Vector2(12, 236), "%d 선택" % (i + 1), HORIZONTAL_ALIGNMENT_CENTER, rect.size.x - 24, 13, Color(0.92, 0.86, 0.62))


func _draw_result() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.0, 0.0, 0.0, 0.62))
	var rect := Rect2(76.0, 216.0, size.x - 152.0, 570.0)
	_draw_panel(rect, Color(0.88, 0.72, 0.43, 0.98), Color(0.15, 0.08, 0.04))
	_draw_panel(Rect2(rect.position + Vector2(24, 38), Vector2(rect.size.x - 48, 92)), Color(0.11, 0.08, 0.055, 0.95), Color(0.70, 0.45, 0.18))
	draw_circle(rect.position + Vector2(rect.size.x * 0.5, 34), 44.0, Color(0.05, 0.12, 0.11))
	draw_circle(rect.position + Vector2(rect.size.x * 0.5, 34), 28.0, Color(0.90, 0.60, 0.22))
	var title := "정화 완료" if result == "clear" else "정화 실패"
	var title_color := Color(1.0, 0.85, 0.42) if result == "clear" else Color(1.0, 0.38, 0.28)
	draw_string(ThemeDB.fallback_font, rect.position + Vector2(0, 104), title, HORIZONTAL_ALIGNMENT_CENTER, rect.size.x, 34, title_color)
	var stat_y := rect.position.y + 160.0
	_draw_stat_chip(Vector2(rect.position.x + 30, stat_y), "시간", _format_time(elapsed))
	_draw_stat_chip(Vector2(rect.position.x + 135, stat_y), "처치", str(kills))
	_draw_stat_chip(Vector2(rect.position.x + 240, stat_y), "진행", "%d/3" % _stage_index())
	_draw_result_reward(rect.position + Vector2(18, 258), "엽전", kills * 9 + purified * 3)
	_draw_result_reward(rect.position + Vector2(18, 306), "영력", purified)
	_draw_result_reward(rect.position + Vector2(18, 354), "부적 조각", max(1, run_level - 1))
	_draw_panel(Rect2(rect.position + Vector2(88, 480), Vector2(rect.size.x - 176, 46)), Color(0.86, 0.27, 0.05, 0.96), Color(0.13, 0.07, 0.03))
	draw_string(ThemeDB.fallback_font, rect.position + Vector2(88, 511), "다시 원정", HORIZONTAL_ALIGNMENT_CENTER, rect.size.x - 176, 18, Color(1.0, 0.88, 0.62))


func _draw_wave_track(rect: Rect2) -> void:
	_draw_panel(rect, Color(0.025, 0.045, 0.04, 0.78), Color(0.70, 0.52, 0.26))
	var label_rect := Rect2(rect.position + Vector2(4, 22), Vector2(154, 18))
	_draw_panel(label_rect, Color(0.05, 0.09, 0.07, 0.76), Color(0.24, 0.46, 0.32))
	draw_string(ThemeDB.fallback_font, label_rect.position + Vector2(8, 14), "가을 폐촌 마당", HORIZONTAL_ALIGNMENT_LEFT, label_rect.size.x - 16, 11, Color(0.92, 0.80, 0.38))
	var fill_width := rect.size.x * _wave_progress_ratio()
	draw_rect(Rect2(rect.position + Vector2(4, 5), Vector2(max(8.0, fill_width - 8.0), 8)), Color(0.24, 0.88, 0.78, 0.86))
	for i in range(8):
		var x := rect.position.x + 4.0 + float(i) * ((rect.size.x - 8.0) / 8.0)
		draw_line(Vector2(x, rect.position.y + 4.0), Vector2(x, rect.position.y + rect.size.y - 4.0), Color(0.02, 0.03, 0.025, 0.70), 1.0)


func _draw_stage_pips(origin: Vector2) -> void:
	for i in range(6):
		var pos := origin + Vector2(float(i) * 12.0, 0.0)
		var filled := i < _stage_index() * 2
		draw_circle(pos, 4.0, Color(0.22, 0.88, 0.82) if filled else Color(0.18, 0.24, 0.22))


func _draw_ledger_row(origin: Vector2, label: String, value: int, icon_color: Color) -> void:
	draw_circle(origin + Vector2(7, -5), 5.0, icon_color)
	draw_string(ThemeDB.fallback_font, origin + Vector2(20, 0), label, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 12, Color(0.78, 0.70, 0.52))
	draw_string(ThemeDB.fallback_font, origin + Vector2(72, 0), str(value), HORIZONTAL_ALIGNMENT_RIGHT, 50.0, 12, Color(0.96, 0.90, 0.72))


func _draw_action_button(pos: Vector2, radius: float, key: String, label: String, primary: bool) -> void:
	var learned := key == "wave" or _skill_level(key) > 0
	var rim_color := Color(0.83, 0.62, 0.30) if primary else Color(0.70, 0.52, 0.28)
	draw_circle(pos, radius + 4.0, Color(0.02, 0.025, 0.025, 0.88))
	draw_arc(pos, radius + 2.0, 0.0, TAU, 54, rim_color, 4.0)
	draw_circle(pos, radius - 8.0, _skill_color(key) if learned else Color(0.20, 0.20, 0.18))
	draw_string(ThemeDB.fallback_font, pos + Vector2(-radius, 7), label, HORIZONTAL_ALIGNMENT_CENTER, radius * 2.0, 22 if primary else 19, Color.WHITE if learned else Color(0.66, 0.60, 0.50))
	if learned:
		var cooldown: float = max(0.0, float(skill_timers.get(key, 0.0)))
		if key != "wave" and cooldown > 0.15:
			draw_circle(pos, radius - 8.0, Color(0.0, 0.0, 0.0, 0.36))
			draw_string(ThemeDB.fallback_font, pos + Vector2(-radius, 6), "%.1f" % cooldown, HORIZONTAL_ALIGNMENT_CENTER, radius * 2.0, 15, Color(1.0, 0.92, 0.72))
		draw_string(ThemeDB.fallback_font, pos + Vector2(-radius, radius - 2.0), "Lv.%d" % max(1, _skill_level(key)), HORIZONTAL_ALIGNMENT_CENTER, radius * 2.0, 10, Color(0.72, 0.92, 1.0))


func _draw_level_pips(origin: Vector2, level: int) -> void:
	for i in range(5):
		var color := Color(0.97, 0.58, 0.18) if i < level else Color(0.50, 0.40, 0.26)
		draw_rect(Rect2(origin + Vector2(float(i) * 12.0, 0.0), Vector2(8, 8)), color)


func _draw_stat_chip(origin: Vector2, label: String, value: String) -> void:
	_draw_panel(Rect2(origin, Vector2(84, 58)), Color(0.22, 0.14, 0.07, 0.94), Color(0.62, 0.42, 0.20))
	draw_string(ThemeDB.fallback_font, origin + Vector2(0, 20), label, HORIZONTAL_ALIGNMENT_CENTER, 84.0, 12, Color(0.84, 0.76, 0.58))
	draw_string(ThemeDB.fallback_font, origin + Vector2(0, 45), value, HORIZONTAL_ALIGNMENT_CENTER, 84.0, 17, Color(1.0, 0.88, 0.62))


func _draw_result_reward(origin: Vector2, label: String, value: int) -> void:
	var rect := Rect2(origin, Vector2(352, 38))
	_draw_panel(rect, Color(0.96, 0.78, 0.38, 0.92), Color(0.36, 0.22, 0.10))
	draw_circle(origin + Vector2(20, 19), 10.0, Color(0.90, 0.52, 0.16))
	draw_string(ThemeDB.fallback_font, origin + Vector2(42, 25), label, HORIZONTAL_ALIGNMENT_LEFT, 190.0, 14, Color(0.18, 0.10, 0.04))
	draw_string(ThemeDB.fallback_font, origin + Vector2(240, 25), "+%d" % value, HORIZONTAL_ALIGNMENT_RIGHT, 92.0, 17, Color(0.14, 0.08, 0.03))


func _skill_color(key: String) -> Color:
	match key:
		"vortex":
			return Color(0.16, 0.58, 0.96)
		"wave":
			return Color(0.12, 0.68, 0.94)
		"spiritfire":
			return Color(0.22, 0.90, 0.78)
		"ward":
			return Color(0.58, 0.94, 1.0)
		_:
			return Color(0.32, 0.48, 0.55)


func _format_time(seconds: float) -> String:
	var total: int = max(0, int(seconds))
	return "%02d:%02d" % [int(total / 60), total % 60]


func _stage_index() -> int:
	return clamp(int(floor(elapsed / max(1.0, RUN_SECONDS / 3.0))) + 1, 1, 3)


func _wave_progress_ratio() -> float:
	var stage_len := RUN_SECONDS / 3.0
	var stage_elapsed := fmod(elapsed, stage_len)
	if elapsed >= RUN_SECONDS:
		stage_elapsed = stage_len
	return clamp((float(_stage_index() - 1) + stage_elapsed / stage_len) / 3.0, 0.0, 1.0)


func _draw_panel(rect: Rect2, fill: Color, stroke: Color) -> void:
	draw_rect(rect, fill)
	draw_rect(rect, stroke, false, 2.0)
	draw_rect(Rect2(rect.position + Vector2(4, 4), rect.size - Vector2(8, 8)), Color(1.0, 0.84, 0.42, 0.08), false, 1.0)


func _draw_bar(rect: Rect2, ratio: float, fill: Color, back: Color) -> void:
	draw_rect(rect, back)
	draw_rect(Rect2(rect.position, Vector2(rect.size.x * clamp(ratio, 0.0, 1.0), rect.size.y)), fill)
	draw_rect(rect, Color(0.92, 0.75, 0.42, 0.65), false, 1.0)


func _nearest_enemy() -> Dictionary:
	var best := {}
	var best_dist := INF
	var p := _player_pos()
	for enemy in enemies:
		var dist := p.distance_squared_to(enemy.get("pos", p))
		if dist < best_dist:
			best_dist = dist
			best = enemy
	return best


func _nearest_enemy_distance() -> float:
	var best := INF
	var p := _player_pos()
	for enemy in enemies:
		best = min(best, p.distance_to(enemy.get("pos", p)))
	return best


func _short_field_item_label(item_type: String) -> String:
	match item_type:
		"bomb":
			return "폭발"
		"magnet":
			return "흡령"
		"potion":
			return "회복"
		"mine":
			return "영석"
		_:
			return "보급"


func _draw_small_world_label(pos: Vector2, label: String, color: Color) -> void:
	if label == "":
		return
	var rect := Rect2(pos.x - 22.0, pos.y - 11.0, 44.0, 15.0)
	draw_rect(rect, Color(0.02, 0.018, 0.014, 0.72))
	draw_rect(rect, Color(color.r, color.g, color.b, 0.58), false, 1.0)
	draw_string(ThemeDB.fallback_font, rect.position + Vector2(0, 11), label, HORIZONTAL_ALIGNMENT_CENTER, rect.size.x, 10, Color(0.96, 0.90, 0.72))


func _has_boss() -> bool:
	for enemy in enemies:
		if str(enemy.get("kind", "")) == "night_ogre":
			return true
	return false


func _skill_level(key: String) -> int:
	return int(skill_levels.get(key, 0))


func _player_pos() -> Vector2:
	return player.get("pos", WORLD_CENTER)


func _clamp_world(pos: Vector2) -> Vector2:
	return Vector2(clamp(pos.x, 80.0, WORLD_SIZE.x - 80.0), clamp(pos.y, 80.0, WORLD_SIZE.y - 80.0))


func _world_to_screen(pos: Vector2) -> Vector2:
	var delta := pos - camera_pos
	return size * 0.5 + delta


func _screen_y(pos: Vector2) -> float:
	return _world_to_screen(pos).y


func _draw_soft_ellipse(position: Vector2, ellipse_size: Vector2, color: Color) -> void:
	var points := PackedVector2Array()
	for i in range(28):
		var a := float(i) / 28.0 * TAU
		points.append(position + Vector2(cos(a) * ellipse_size.x * 0.5, sin(a) * ellipse_size.y * 0.5))
	draw_colored_polygon(points, color)
