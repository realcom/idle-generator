extends Control

const ContentStore := preload("res://scripts/content_store.gd")
const BasicCombatSim := preload("res://scripts/combat/basic_combat_sim.gd")
const ProgressionState := preload("res://scripts/game/progression_state.gd")
const SpriteCatalog := preload("res://scripts/visual/sprite_catalog.gd")
const PortalMapWindow := preload("res://scripts/ui/portal_map_window.gd")
const PopupSystem := preload("res://scripts/ui/popup_system.gd")
const DesktopWindowManager := preload("res://scripts/ui/desktop_window_manager.gd")
const WindowTitleBarChrome := preload("res://scripts/ui/window_title_bar_chrome.gd")
const GENERATED_UI_OVERLAY_PATH := "res://scenes/generated/full_ui_overlay.tscn"
const GENERATED_UI_REFERENCE_SIZE := Vector2(1586.0, 992.0)
const GENERATED_STYLE_TEXTURES := {
	"taskstonebar.ui.resource_chip_9slice": "res://assets/generated/ui/resource_chip_9slice.png",
	"taskstonebar.ui.window_frame_9slice": "res://assets/generated/ui/window_frame_9slice.png",
	"taskstonebar.ui.window_title_bar_9slice": "res://assets/generated/ui/window_title_bar_9slice.png",
	"taskstonebar.ui.dark_inner_well_9slice": "res://assets/generated/ui/dark_inner_well_9slice.png",
	"taskstonebar.ui.status_stat_card_9slice": "res://assets/generated/ui/status_stat_card_9slice.png",
	"taskstonebar.ui.tab_burgundy_9slice": "res://assets/generated/ui/tab_burgundy_9slice.png",
	"taskstonebar.ui.icon_dock_button_9slice": "res://assets/generated/ui/icon_dock_button_9slice.png",
	"taskstonebar.ui.slot_frame_9slice": "res://assets/generated/ui/slot_frame_9slice.png",
	"taskstonebar.ui.rare_drop_toast_9slice": "res://assets/generated/ui/rare_drop_toast_9slice.png",
}
const GENERATED_STYLE_SLICE_HINTS := {
	"taskstonebar.ui.resource_chip_9slice": {"left": 16.0, "right": 16.0, "top": 14.0, "bottom": 14.0},
	"taskstonebar.ui.window_frame_9slice": {"left": 30.0, "right": 30.0, "top": 34.0, "bottom": 30.0},
	"taskstonebar.ui.window_title_bar_9slice": {"left": 26.0, "right": 26.0, "top": 18.0, "bottom": 18.0},
	"taskstonebar.ui.dark_inner_well_9slice": {"left": 22.0, "right": 22.0, "top": 22.0, "bottom": 22.0},
	"taskstonebar.ui.status_stat_card_9slice": {"left": 14.0, "right": 14.0, "top": 14.0, "bottom": 14.0},
	"taskstonebar.ui.tab_burgundy_9slice": {"left": 18.0, "right": 18.0, "top": 16.0, "bottom": 16.0},
	"taskstonebar.ui.icon_dock_button_9slice": {"left": 18.0, "right": 18.0, "top": 18.0, "bottom": 18.0},
	"taskstonebar.ui.slot_frame_9slice": {"left": 18.0, "right": 18.0, "top": 18.0, "bottom": 18.0},
	"taskstonebar.ui.rare_drop_toast_9slice": {"left": 22.0, "right": 22.0, "top": 18.0, "bottom": 18.0},
}
const GENERATED_CLOSE_ICON_PATH := "res://assets/generated/ui/close_icon.png"
const GENERATED_KEEPER_DOCK_ICON_SET_PATH := "res://assets/generated/ui/keeper_dock_icon_set.png"
const GENERATED_BATTLE_MAP_TEXTURES := {
	1: "res://assets/generated/battle/taskstonebar_battle_map_01.png",
	2: "res://assets/generated/battle/taskstonebar_battle_map_02.png",
	3: "res://assets/generated/battle/taskstonebar_battle_map_03.png",
	4: "res://assets/generated/battle/taskstonebar_battle_map_04.png",
	5: "res://assets/generated/battle/taskstonebar_battle_map_05.png",
	6: "res://assets/generated/battle/taskstonebar_battle_map_06.png",
	7: "res://assets/generated/battle/taskstonebar_battle_map_07.png",
	8: "res://assets/generated/battle/taskstonebar_battle_map_08.png",
	9: "res://assets/generated/battle/taskstonebar_battle_map_09.png",
	10: "res://assets/generated/battle/taskstonebar_battle_map_10.png",
}
const GENERATED_PORTAL_MAP_TEXTURE_FALLBACK := "res://assets/generated/ui/portal_parchment_map.png"
const GENERATED_PORTAL_MAP_TEXTURES := {
	500101: "res://assets/generated/ui/portal_map_500101_taskbar_cave_rounded.png",
}
const PORTAL_FIRST_MAP_ID := 500101
const PORTAL_MAPS_PER_ACT := 10
const PORTAL_TOTAL_ACTS := 10
const PORTAL_STAGE_NODE_SIZE := Vector2(44.0, 30.0)
const PORTAL_STAGE_ROUTE_POSITIONS := [
	Vector2(124.0, 462.0),
	Vector2(230.0, 436.0),
	Vector2(174.0, 398.0),
	Vector2(300.0, 370.0),
	Vector2(224.0, 334.0),
	Vector2(326.0, 304.0),
	Vector2(186.0, 276.0),
	Vector2(284.0, 246.0),
	Vector2(142.0, 236.0),
	Vector2(316.0, 214.0),
]
const PORTAL_ROUTE_CURVE_SWAYS := [24.0, -18.0, 28.0, -20.0, 18.0, -30.0, 22.0, -24.0, 18.0]
const KEEPER_DOCK_ICON_SIZE := Vector2(64.0, 64.0)
const KEEPER_DOCK_ICON_DISPLAY_SIZE := Vector2(38.0, 38.0)
const WORKSHOP_WINDOW_VISUAL_SCALE := 0.8
const COMPACT_STATUS_WINDOW_RECT := Rect2(Vector2(225.0, 72.0), Vector2(438.0, 560.0))
const COMPACT_HERO_WINDOW_RECT := Rect2(Vector2(591.0, 48.0), Vector2(504.0, 624.0))
const COMPACT_PORTAL_WINDOW_RECT := Rect2(Vector2(1010.0, 72.0), Vector2(438.0, 560.0))
const AUTO_TRANSITION_DELAY := 0.9
const OVERLAY_HERO_WINDOW_PATH := "Section_WindowStack/Panel_HeroInventoryWindowFrame"
const OVERLAY_INVENTORY_GRID_PATH := "Section_WindowStack/Panel_HeroInventoryWindowFrame/Grid_StoneInventory"
const OVERLAY_INVENTORY_TABS_PATH := "Section_WindowStack/Panel_HeroInventoryWindowFrame/Tabs_StoneEquipment"
const OVERLAY_STONE_TAB_PATH := "Section_WindowStack/Panel_HeroInventoryWindowFrame/Tabs_StoneEquipment/Btn_StoneTab"
const OVERLAY_EQUIPMENT_TAB_PATH := "Section_WindowStack/Panel_HeroInventoryWindowFrame/Tabs_StoneEquipment/Btn_EquipmentTab"
const OVERLAY_EQUIPMENT_LEFT_PATH := "Section_WindowStack/Panel_HeroInventoryWindowFrame/Grid_EquipmentSlotsLeft"
const OVERLAY_EQUIPMENT_RIGHT_PATH := "Section_WindowStack/Panel_HeroInventoryWindowFrame/Grid_EquipmentSlotsRight"
const OVERLAY_RUNE_GRID_PATH := "Section_WindowStack/Panel_StatusWindowFrame/Grid_RuneMarkTree"
const OVERLAY_COMBAT_STRIP_PATH := "Section_BottomCombatStrip"
const OVERLAY_COMBAT_REFERENCE_RECT := Rect2(Vector2(245.0, 40.0), Vector2(820.0, 128.0))
const OVERLAY_DROP_TOAST_PATH := "Section_BottomCombatStrip/Panel_RareDropToast"
const OVERLAY_ACTION_BAR_NAME := "RuntimeActionBar"
const OVERLAY_ACTION_STATUS_NAME := "Text_RuntimeActionStatus"
const KEEPER_DOCK_ICON_SPECS := [
	{"path": "Section_WindowStack/Panel_HeroInventoryWindowFrame/Dock_KeeperIconDock/Btn_DockInventory", "node": "Icon_DockInventory", "index": 0, "tooltip": "인벤토리"},
	{"path": "Section_WindowStack/Panel_HeroInventoryWindowFrame/Dock_KeeperIconDock/Btn_DockGrowth", "node": "Icon_DockGrowth", "index": 1, "tooltip": "먹이기"},
	{"path": "Section_WindowStack/Panel_HeroInventoryWindowFrame/Dock_KeeperIconDock/Btn_DockFormation", "node": "Icon_DockFormation", "index": 2, "tooltip": "스킬"},
	{"path": "Section_WindowStack/Panel_HeroInventoryWindowFrame/Dock_KeeperIconDock/Btn_DockStorage", "node": "Icon_DockStorage", "index": 3, "tooltip": "합성"},
	{"path": "Section_WindowStack/Panel_HeroInventoryWindowFrame/Dock_KeeperIconDock/Btn_DockSteamAssets", "node": "Icon_DockSteamAssets", "index": 4, "tooltip": "Steam 자산"},
]
const OVERLAY_COMBAT_LAYER_NAME := "RuntimeCombatLayer"
const OVERLAY_ENEMY_LAYER_NAME := "RuntimeEnemyLayer"
const OVERLAY_COMBAT_PROP_LAYER_NAME := "RuntimeCombatPropLayer"
const OVERLAY_COMBAT_SKILL_PANEL_NAME := "RuntimeCombatSkillPanel"
const OVERLAY_COMBAT_DROP_BANNER_NAME := "RuntimeCombatDropBanner"
const OVERLAY_COMBAT_MAP_PROGRESS_NAME := "RuntimeCombatMapProgress"
const OVERLAY_COMBAT_BOSS_PANEL_NAME := "RuntimeCombatBossPanel"
const OVERLAY_WORKSHOP_TOGGLE_NAME := "Btn_RuntimeWorkshopToggle"
const COMBAT_OPACITY_CONTROL_NAME := "RuntimeCombatOpacityControl"
const COMBAT_OPACITY_SLIDER_NAME := "Slider_CombatOpacity"
const COMBAT_OPACITY_VALUE_NAME := "Text_CombatOpacityValue"
const COMBAT_OPACITY_MIN := 0.35
const COMBAT_OPACITY_MAX := 1.0
const KEEPER_EXP_BAR_NAME := "Progress_KeeperExp"
const KEEPER_EXP_LABEL_NAME := "Text_KeeperExp"
const RUNTIME_SKILL_TREE_WINDOW_NAME := "RuntimeSkillTreeWindow"
const RUNTIME_SKILL_TREE_ITEM_IDS := [
	200509, 200510, 200511, 200512, 200513,
	200514, 200515, 200516, 200517, 200518,
	200519, 200520, 200521, 200522, 200523,
	200524, 200525, 200526, 200527, 200528,
	200529, 200530, 200531, 200532, 200533,
	200534, 200535, 200536, 200537, 200538,
]
const INVENTORY_VISIBLE_SLOTS := 32
const INVENTORY_UNLOCKED_SLOTS := 24
const INVENTORY_GRID_COLUMNS := 8
const EQUIPMENT_STORAGE_VISIBLE_SLOTS := INVENTORY_VISIBLE_SLOTS
const EQUIPMENT_STORAGE_UNLOCKED_SLOTS := INVENTORY_UNLOCKED_SLOTS
const EQUIPMENT_STORAGE_CAPACITY := 40
const RUNTIME_SKILL_TREE_LANES := [
	{"title": "투척", "items": [200509, 200510, 200511, 200512, 200513]},
	{"title": "광역", "items": [200514, 200515, 200516, 200517, 200518]},
	{"title": "보스", "items": [200519, 200520, 200521, 200522, 200523]},
	{"title": "파밍", "items": [200524, 200525, 200526, 200527, 200528]},
	{"title": "방어", "items": [200529, 200530, 200531, 200532, 200533]},
	{"title": "제련/편성", "items": [200534, 200535, 200536, 200537, 200538]},
]
const STATUS_SKILL_BINDINGS := [
	{"binding": "skill.stone_throw.level", "item_id": 200509},
	{"binding": "skill.guard.level", "item_id": 200529},
	{"binding": "skill.impact.level", "item_id": 200514},
	{"binding": "skill.crit.level", "item_id": 200519},
	{"binding": "skill.portal.level", "item_id": 200524},
	{"binding": "skill.drop.level", "item_id": 200525},
	{"binding": "skill.boss.level", "item_id": 200520},
	{"binding": "skill.market.level", "item_id": 200534},
	{"binding": "skill.treasure.level", "item_id": 200538},
]
const OVERLAY_MODAL_HOST_NAME := "ModalHost"
const EQUIPMENT_UPGRADE_MODAL_NAME := "Modal_EquipmentUpgrade"
const INVENTORY_ITEM_DETAIL_MODAL_NAME := "Modal_InventoryItemDetail"
const MODAL_SCRIM_RECT := Rect2(Vector2.ZERO, Vector2(1586.0, 704.0))
const EQUIPMENT_UPGRADE_MODAL_RECT := Rect2(Vector2(574.0, 168.0), Vector2(438.0, 344.0))
const INVENTORY_ITEM_DETAIL_MODAL_RECT := Rect2(Vector2(548.0, 126.0), Vector2(490.0, 430.0))
const MODAL_TITLE_INSET := Vector2(14.0, 12.0)
const MODAL_BODY_INSET := Vector2(28.0, 68.0)
const MODAL_FRAME_CONTENT_BOTTOM := 22.0
const MODAL_TITLE_HEIGHT := 42.0
const MODAL_FOOTER_HEIGHT := 46.0
const INVENTORY_SLOT_DRAG_THRESHOLD := 8.0
const NATIVE_WINDOW_IDS := ["status", "keeper", "portal", "combat"]
const RUNTIME_NATIVE_WINDOW_IDS := ["status", "keeper", "portal", "combat", "skill_tree"]
const NATIVE_WINDOW_ROOTS := {
	"status": "Section_WindowStack/Panel_StatusWindowFrame",
	"keeper": "Section_WindowStack/Panel_HeroInventoryWindowFrame",
	"portal": "Section_WindowStack/Panel_PortalWindowFrame",
	"combat": "Section_BottomCombatStrip",
}
const NATIVE_WINDOW_TITLES := {
	"status": "Taskstonebar Status",
	"keeper": "Taskstonebar Keeper",
	"portal": "Taskstonebar Portal",
	"combat": "Taskstonebar Combat Strip",
}
const NATIVE_WINDOW_ORDER := {
	"status": 0,
	"keeper": 1,
	"portal": 2,
	"combat": 3,
}
const COMBAT_NATIVE_WINDOW_SCALE := 0.61
const COMBAT_NATIVE_WINDOW_WIDTH_RATIO := 0.5
const COMBAT_NATIVE_WINDOW_MIN_SCALE := 0.35
const COMBAT_NATIVE_WINDOW_MAX_SCALE := 1.0
const COMBAT_RESIZE_HANDLE_NAME := "RuntimeCombatResizeHandle"
const COMBAT_RESIZE_HANDLE_SIZE := Vector2(30.0, 30.0)
const COMBAT_RESIZE_HANDLE_MARGIN := Vector2(10.0, 10.0)
const COMBAT_ATTACK_IMPACT_START := 0.78
const COMBAT_PROJECTILE_HIDE_PROGRESS := 0.96
const COMBAT_MONSTER_VISUAL_SCALE := 0.75
const COMBAT_ENEMY_VISUAL_SHIFT := Vector2(-190.0, 8.0)
const COMBAT_ENEMY_LANE_STEP := Vector2(28.0, 12.0)
const GOLD_ITEM_ID := 5
const OPAQUE_NATIVE_WINDOW_PLATFORMS := ["Windows"]

var store
var sim
var progression
var sprites
var title_label: Label
var status_label: Label
var resource_label: Label
var event_label: Label
var player_hp_bar: ProgressBar
var wave_bar: ProgressBar
var farm_toggle: CheckButton
var continue_button: Button
var portal_button: Button
var portal_map_window: Control
var popup_system
var desktop_window_manager
var generated_ui_overlay: Control
var generated_native_windows: Dictionary = {}
var generated_native_window_roots: Dictionary = {}
var generated_native_window_ids_by_node: Dictionary = {}
var generated_texture_cache: Dictionary = {}
var generated_runtime_nodes: Dictionary = {}
var generated_inventory_tab := "stone"
var generated_selected_action := "inventory"
var generated_action_message := "돌 인벤토리 준비"
var generated_taskbar_mode := false
var generated_selected_skill_item_id := 200509
var generated_selected_inventory_instance_id := 0
var generated_selected_inventory_kind := ""
var generated_visual_capture_mode := false
var legacy_ui_nodes: Array = []
var generated_drag_window: Control
var generated_drag_native_window: Window
var generated_drag_start_mouse := Vector2.ZERO
var generated_drag_start_position := Vector2.ZERO
var generated_combat_drag_strip: Control
var generated_combat_drag_start_mouse := Vector2.ZERO
var generated_combat_drag_start_position := Vector2.ZERO
var generated_combat_window_scale := COMBAT_NATIVE_WINDOW_SCALE
var generated_combat_opacity := 1.0
var generated_combat_hp_enemy_id := 0
var generated_combat_resize_strip: Control
var generated_combat_resize_start_mouse := Vector2.ZERO
var generated_combat_resize_start_scale := COMBAT_NATIVE_WINDOW_SCALE
var generated_slot_drag_origin: Control
var generated_slot_drag_grid_path := ""
var generated_slot_drag_index := -1
var generated_slot_drag_data: Dictionary = {}
var generated_slot_drag_start_mouse := Vector2.ZERO
var generated_slot_drag_active := false
var generated_slot_drag_preview: Control
var auto_transition_timer := -1.0
var auto_transition_result := ""
var auto_transition_map_id := 0


func _ready() -> void:
	custom_minimum_size = GENERATED_UI_REFERENCE_SIZE
	mouse_filter = Control.MOUSE_FILTER_PASS
	_configure_transparent_desktop_window()
	store = ContentStore.new()
	var ok: bool = store.load_all()
	sprites = SpriteCatalog.new()
	var sprites_ok: bool = sprites.load_all()
	sim = BasicCombatSim.new(store)
	progression = ProgressionState.new(store)
	sim.set_progression_state(progression)
	_build_ui()
	_build_generated_ui_overlay()
	if ok:
		_bootstrap_progression_state()
		sim.start(int(store.get_main_map().get("id", 500101)))
		if not sprites_ok:
			status_label.text = "sprite load warning: %s" % "; ".join(sprites.errors)
	else:
		status_label.text = "content load failed: %s" % "; ".join(store.errors)


func _configure_transparent_desktop_window() -> void:
	get_tree().root.gui_embed_subwindows = false
	if generated_visual_capture_mode:
		get_viewport().transparent_bg = true
		get_window().transparent_bg = true
		RenderingServer.set_default_clear_color(Color(0.0, 0.0, 0.0, 0.0))
		if DisplayServer.get_name() != "headless":
			DisplayServer.window_set_size(Vector2i(roundi(GENERATED_UI_REFERENCE_SIZE.x), roundi(GENERATED_UI_REFERENCE_SIZE.y)))
		get_window().size = Vector2i(roundi(GENERATED_UI_REFERENCE_SIZE.x), roundi(GENERATED_UI_REFERENCE_SIZE.y))
		return
	get_viewport().transparent_bg = true
	get_window().transparent_bg = true
	RenderingServer.set_default_clear_color(Color(0.0, 0.0, 0.0, 0.0))
	if DisplayServer.get_name() == "headless":
		return
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_TRANSPARENT, true)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_ALWAYS_ON_TOP, true)
	var screen_id := DisplayServer.window_get_current_screen()
	var screen_position := DisplayServer.screen_get_position(screen_id)
	DisplayServer.window_set_position(screen_position)
	DisplayServer.window_set_size(Vector2i(1, 1))


func _native_desktop_windows_enabled() -> bool:
	return DisplayServer.get_name() != "headless"


func _native_window_transparency_enabled() -> bool:
	return not OPAQUE_NATIVE_WINDOW_PLATFORMS.has(OS.get_name())


func _process(delta: float) -> void:
	_update_active_native_drags()
	if sim != null:
		sim.step(delta)
		_update_auto_transition(delta)
		_sync_ui()
	queue_redraw()


func _input(event: InputEvent) -> void:
	if _handle_generated_combat_strip_resize_global_input(event):
		get_viewport().set_input_as_handled()
		return
	if _handle_generated_combat_strip_drag_global_input(event):
		get_viewport().set_input_as_handled()
		return
	if _handle_generated_inventory_drag_input(event):
		get_viewport().set_input_as_handled()
		return
	if _handle_reload_shortcut(event):
		get_viewport().set_input_as_handled()


func _shortcut_input(event: InputEvent) -> void:
	if _handle_reload_shortcut(event):
		get_viewport().set_input_as_handled()


func _unhandled_key_input(event: InputEvent) -> void:
	if _handle_reload_shortcut(event):
		get_viewport().set_input_as_handled()


func _handle_reload_shortcut(event: InputEvent) -> bool:
	if not event is InputEventKey:
		return false
	var key := event as InputEventKey
	if not key.pressed or key.echo:
		return false
	var is_r := key.keycode == KEY_R or key.physical_keycode == KEY_R or key.key_label == KEY_R
	if not is_r or not (key.meta_pressed or key.ctrl_pressed):
		return false
	call_deferred("_reload_current_scene_from_shortcut")
	return true


func _reload_current_scene_from_shortcut() -> void:
	get_tree().reload_current_scene()


func _on_native_window_gui_input(event: InputEvent) -> void:
	if _handle_reload_shortcut(event):
		get_viewport().set_input_as_handled()


func _draw() -> void:
	if generated_ui_overlay != null:
		return
	if sim == null:
		return
	var snapshot: Dictionary = sim.snapshot()
	var field := Rect2(Vector2(24.0, 118.0), Vector2(maxf(200.0, size.x - 48.0), 154.0))
	draw_rect(Rect2(Vector2.ZERO, size), Color("#120c08"))
	_draw_battlefield(field)

	var player: Dictionary = snapshot.get("player", {})
	_draw_unit(player, field, Color("#f2c45a"), true)
	for enemy in snapshot.get("enemies", []):
		if typeof(enemy) == TYPE_DICTIONARY and bool(enemy.get("alive", true)):
			_draw_unit(enemy, field, Color("#7fb069"), false)
	_draw_fx(snapshot, field)


func _build_ui() -> void:
	title_label = _label("Taskstonebar / Main 100 Combat", Vector2(24, 18), 30)
	status_label = _label("", Vector2(24, 58), 18)
	resource_label = _label("", Vector2(24, 290), 18)
	event_label = _label("", Vector2(600, 18), 16)

	player_hp_bar = ProgressBar.new()
	player_hp_bar.position = Vector2(24, 88)
	player_hp_bar.size = Vector2(330, 16)
	player_hp_bar.show_percentage = false
	add_child(player_hp_bar)

	wave_bar = ProgressBar.new()
	wave_bar.position = Vector2(370, 88)
	wave_bar.size = Vector2(220, 16)
	wave_bar.show_percentage = false
	add_child(wave_bar)

	var restart := Button.new()
	restart.text = "Retry"
	restart.position = Vector2(840, 306)
	restart.size = Vector2(96, 34)
	restart.pressed.connect(func():
		sim.start(int(sim.snapshot().get("map_id", store.get_main_map().get("id", 500101))))
	)
	add_child(restart)

	continue_button = Button.new()
	continue_button.text = "Continue"
	continue_button.position = Vector2(728, 306)
	continue_button.size = Vector2(104, 34)
	continue_button.pressed.connect(func():
		sim.continue_after_result(farm_toggle.button_pressed)
	)
	add_child(continue_button)

	farm_toggle = CheckButton.new()
	farm_toggle.text = "Farm"
	farm_toggle.position = Vector2(628, 306)
	farm_toggle.size = Vector2(92, 34)
	add_child(farm_toggle)

	portal_button = Button.new()
	portal_button.text = "Portal"
	portal_button.position = Vector2(516, 306)
	portal_button.size = Vector2(104, 34)
	portal_button.pressed.connect(toggle_portal_window)
	add_child(portal_button)

	portal_map_window = PortalMapWindow.new()
	portal_map_window.name = "PortalMapWindow"
	portal_map_window.visible = false
	portal_map_window.z_index = 100
	portal_map_window.close_requested.connect(close_portal_window)
	add_child(portal_map_window)
	_layout_portal_window()


func _build_generated_ui_overlay() -> void:
	if not ResourceLoader.exists(GENERATED_UI_OVERLAY_PATH):
		return
	var packed := load(GENERATED_UI_OVERLAY_PATH)
	if not (packed is PackedScene):
		return
	legacy_ui_nodes.clear()
	generated_runtime_nodes.clear()
	for child in get_children():
		if child is CanvasItem:
			legacy_ui_nodes.append(child)
			child.visible = false
	generated_taskbar_mode = false
	generated_ui_overlay = packed.instantiate()
	generated_ui_overlay.name = "GeneratedFullUiOverlay"
	generated_ui_overlay.mouse_filter = Control.MOUSE_FILTER_PASS
	generated_ui_overlay.z_index = 500
	add_child(generated_ui_overlay)
	_layout_generated_ui_overlay()
	_hydrate_generated_ui_overlay(generated_ui_overlay)
	_style_generated_ui_overlay(generated_ui_overlay)
	_apply_generated_program_window_chrome(generated_ui_overlay)
	_polish_generated_window_contents(generated_ui_overlay)
	_register_generated_desktop_windows()
	_promote_generated_overlay_to_native_windows()


func _label(text: String, pos: Vector2, font_size: int) -> Label:
	var label := Label.new()
	label.text = text
	label.position = pos
	label.add_theme_font_size_override("font_size", font_size)
	add_child(label)
	return label


func _sync_ui() -> void:
	var snapshot: Dictionary = sim.snapshot()
	var player: Dictionary = snapshot.get("player", {})
	var hp: float = float(player.get("hp", 0.0))
	var max_hp: float = maxf(1.0, float(player.get("max_hp", 1.0)))
	player_hp_bar.max_value = max_hp
	player_hp_bar.value = clampf(hp, 0.0, max_hp)

	var wave: int = int(snapshot.get("wave", 1))
	var wave_count: int = maxi(1, int(snapshot.get("wave_count", 1)))
	wave_bar.max_value = wave_count
	wave_bar.value = clamp(wave, 0, wave_count)

	title_label.text = "Taskstonebar / %d %s" % [
		int(snapshot.get("map_id", 0)),
		str(snapshot.get("map_name", "")),
	]
	var wave_time_limit := maxf(1.0, float(snapshot.get("wave_time_limit", 1.0)))
	var wave_time_left := maxf(0.0, wave_time_limit - float(snapshot.get("wave_elapsed", 0.0)))
	status_label.text = "HP %d/%d  Lv %d  Wave %d/%d  T %.0f  Kills %d  Skills %d  Enemies %d  Result %s" % [
		int(hp),
		int(max_hp),
		int(player.get("level", 1)),
		wave,
		wave_count,
		wave_time_left,
		int(snapshot.get("kill_count", 0)),
		int(snapshot.get("skill_cast_count", 0)),
		int(snapshot.get("enemy_count", 0)),
		str(snapshot.get("result", "")),
	]
	var resources: Dictionary = snapshot.get("resources", {})
	resource_label.text = "gold %d   exp %d   pebble %d   ore %d   catalyst %d" % [
		int(resources.get("gold", 0)),
		int(resources.get("exp", 0)),
		int(resources.get("pebble", 0)),
		int(resources.get("ore", 0)),
		int(resources.get("catalyst", 0)),
	]
	event_label.text = "\n".join(snapshot.get("events", []).slice(0, 7))
	if continue_button != null:
		continue_button.disabled = bool(snapshot.get("running", false)) or str(snapshot.get("result", "")) == ""
	if portal_map_window != null:
		portal_map_window.set_snapshot(snapshot)
	if generated_ui_overlay != null:
		_sync_generated_ui_overlay(snapshot)


func toggle_portal_window() -> void:
	if portal_map_window == null:
		return
	portal_map_window.visible = not portal_map_window.visible
	if portal_map_window.visible:
		_layout_portal_window()


func open_portal_window() -> void:
	if portal_map_window == null:
		return
	portal_map_window.visible = true
	_layout_portal_window()


func close_portal_window() -> void:
	if portal_map_window == null:
		return
	portal_map_window.visible = false


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		_layout_portal_window()
		_layout_generated_ui_overlay()


func _layout_portal_window() -> void:
	if portal_map_window == null:
		return
	var modal_size := Vector2(420.0, 500.0)
	var x := maxf(24.0, size.x - modal_size.x - 24.0)
	var y := 24.0
	if size.y > modal_size.y + 72.0:
		y = 54.0
	portal_map_window.position = Vector2(x, y)


func _layout_generated_ui_overlay() -> void:
	if generated_ui_overlay == null:
		return
	if not generated_native_windows.is_empty():
		_layout_generated_native_windows()
		return
	var base := GENERATED_UI_REFERENCE_SIZE
	var layout_size := size
	if layout_size.x < 100.0 or layout_size.y < 100.0:
		layout_size = base
	var scale_factor := minf(layout_size.x / base.x, layout_size.y / base.y)
	if scale_factor <= 0.0:
		scale_factor = 1.0
	scale_factor = minf(scale_factor, 1.0)
	generated_ui_overlay.scale = Vector2.ONE * scale_factor
	generated_ui_overlay.size = layout_size / scale_factor
	generated_ui_overlay.position = Vector2.ZERO


func _promote_generated_overlay_to_native_windows() -> void:
	if generated_ui_overlay == null:
		return
	if generated_visual_capture_mode:
		return
	if not _native_desktop_windows_enabled():
		return
	var scaffold_band := generated_ui_overlay.get_node_or_null("Section_DesktopScaffold/Panel_OsTaskbarBand")
	if scaffold_band != null and scaffold_band is CanvasItem:
		(scaffold_band as CanvasItem).visible = false
	for window_id in NATIVE_WINDOW_IDS:
		_promote_generated_native_window(str(window_id))
	var skill_window: Control = generated_runtime_nodes.get("skill_tree_window", null)
	if skill_window != null:
		_promote_runtime_native_window("skill_tree", "Taskstonebar Skill Tree", skill_window, false)
	generated_ui_overlay.visible = false
	_layout_generated_native_windows()


func _promote_generated_native_window(window_id: String) -> void:
	var source_path := str(NATIVE_WINDOW_ROOTS.get(window_id, ""))
	var source := generated_ui_overlay.get_node_or_null(source_path)
	if source == null or not source is Control:
		return
	var panel := source as Control
	_promote_runtime_native_window(window_id, str(NATIVE_WINDOW_TITLES.get(window_id, "Taskstonebar")), panel, true)


func _promote_runtime_native_window(window_id: String, title: String, panel: Control, visible: bool) -> void:
	var original_rect := panel.get_global_rect()
	var native := Window.new()
	native.name = "Native_%s_Window" % window_id.capitalize()
	native.title = title
	native.transparent_bg = _native_window_transparency_enabled()
	native.borderless = true
	native.always_on_top = true
	native.unresizable = true
	native.visible = visible
	_set_native_window_size(native, _native_window_size_for(window_id, original_rect.size))
	native.position = _native_window_position(original_rect.position)
	add_child(native)
	call_deferred("_configure_native_window_flags", native)
	call_deferred("_set_native_window_size", native, _native_window_size_for(window_id, original_rect.size))

	panel.get_parent().remove_child(panel)
	panel.position = Vector2.ZERO
	panel.scale = _native_window_scale_vector(window_id)
	panel.visible = visible
	panel.mouse_filter = Control.MOUSE_FILTER_PASS
	panel.focus_mode = Control.FOCUS_ALL
	panel.gui_input.connect(_on_native_window_gui_input)
	native.add_child(panel)
	panel.call_deferred("grab_focus")

	generated_native_windows[window_id] = native
	generated_native_window_roots[window_id] = panel
	generated_native_window_ids_by_node[panel.get_instance_id()] = window_id
	_register_desktop_window(window_id, panel, native)


func _configure_native_window_flags(native: Window) -> void:
	native.transparent_bg = _native_window_transparency_enabled()
	native.borderless = true
	native.always_on_top = true
	native.unresizable = true
	if native.visible:
		native.grab_focus()


func _layout_generated_native_windows() -> void:
	for window_id in RUNTIME_NATIVE_WINDOW_IDS:
		var native: Window = generated_native_windows.get(str(window_id), null)
		var root: Control = generated_native_window_roots.get(str(window_id), null)
		if native == null or root == null:
			continue
		var rect := _native_reference_rect(str(window_id), root)
		native.position = _native_window_position(rect.position)
		_set_native_window_size(native, _native_window_size_for(str(window_id), rect.size))
		root.position = Vector2.ZERO
		root.size = rect.size
		root.scale = _native_window_scale_vector(str(window_id))


func _native_reference_rect(window_id: String, root: Control) -> Rect2:
	var order := int(NATIVE_WINDOW_ORDER.get(window_id, 0))
	if window_id == "status":
		return Rect2(COMPACT_STATUS_WINDOW_RECT.position, root.size)
	if window_id == "keeper":
		return Rect2(COMPACT_HERO_WINDOW_RECT.position, root.size)
	if window_id == "portal":
		return Rect2(COMPACT_PORTAL_WINDOW_RECT.position, root.size)
	if window_id == "combat":
		var scale := _native_window_scale_vector(window_id)
		var visual_size := _scaled_native_window_size(root.size, scale)
		var combat_x := maxf(0.0, (GENERATED_UI_REFERENCE_SIZE.x - visual_size.x) * 0.5)
		var combat_y := 704.0 + maxf(0.0, root.size.y - visual_size.y)
		return Rect2(Vector2(combat_x, combat_y), root.size)
	if window_id == "skill_tree":
		return Rect2(Vector2(914.0, 72.0), root.size)
	return Rect2(Vector2(48.0 + float(order) * 120.0, 64.0), root.size)


func _native_window_position(logical_position: Vector2) -> Vector2i:
	var screen_id := DisplayServer.window_get_current_screen()
	var screen_position := DisplayServer.screen_get_position(screen_id)
	return screen_position + Vector2i(roundi(logical_position.x), roundi(logical_position.y))


func _native_window_size(logical_size: Vector2) -> Vector2i:
	return Vector2i(maxi(1, roundi(logical_size.x)), maxi(1, roundi(logical_size.y)))


func _native_window_size_for(window_id: String, logical_size: Vector2) -> Vector2i:
	return _native_window_size(_scaled_native_window_size(logical_size, _native_window_scale_vector(window_id)))


func _scaled_native_window_size(logical_size: Vector2, scale: Vector2) -> Vector2:
	return Vector2(logical_size.x * scale.x, logical_size.y * scale.y)


func _set_native_window_size(native: Window, window_size: Vector2i) -> void:
	if native == null:
		return
	native.size = window_size
	if DisplayServer.get_name() == "headless":
		return
	if native.has_method("get_window_id"):
		var window_id := int(native.call("get_window_id"))
		DisplayServer.window_set_size(window_size, window_id)


func _native_window_scale(window_id: String) -> float:
	if window_id == "combat":
		return generated_combat_window_scale
	if window_id == "status" or window_id == "keeper" or window_id == "portal":
		return WORKSHOP_WINDOW_VISUAL_SCALE
	return 1.0


func _native_window_scale_vector(window_id: String) -> Vector2:
	var scale := _native_window_scale(window_id)
	if window_id == "combat":
		return Vector2(scale * COMBAT_NATIVE_WINDOW_WIDTH_RATIO, scale)
	return Vector2.ONE * scale


func _desktop_screen_scale(screen_id: int) -> float:
	if DisplayServer.get_name() == "headless":
		return 1.0
	var scale_factor := DisplayServer.screen_get_scale(screen_id)
	if scale_factor <= 0.0:
		scale_factor = 1.0
	return scale_factor


func _generated_node_or_null(node_path: String) -> Node:
	if generated_ui_overlay != null:
		var node := generated_ui_overlay.get_node_or_null(node_path)
		if node != null:
			return node
	if node_path.begins_with("Section_WindowStack/"):
		var nested_path := node_path.substr("Section_WindowStack/".length())
		var root_name := nested_path.get_slice("/", 0)
		var root := _generated_native_root_by_name(root_name)
		if root == null:
			return null
		if nested_path == root_name:
			return root
		return root.get_node_or_null(nested_path.substr(root_name.length() + 1))
	if node_path == OVERLAY_COMBAT_STRIP_PATH:
		return generated_native_window_roots.get("combat", null)
	if node_path.begins_with(OVERLAY_COMBAT_STRIP_PATH + "/"):
		var combat_root: Control = generated_native_window_roots.get("combat", null)
		if combat_root == null:
			return null
		return combat_root.get_node_or_null(node_path.substr(OVERLAY_COMBAT_STRIP_PATH.length() + 1))
	return null


func _generated_native_root_by_name(root_name: String) -> Control:
	for root in generated_native_window_roots.values():
		if root is Control and str((root as Control).name) == root_name:
			return root as Control
	return null


func _ensure_desktop_window_manager() -> void:
	if desktop_window_manager == null:
		desktop_window_manager = DesktopWindowManager.new()


func _register_generated_desktop_windows() -> void:
	_ensure_desktop_window_manager()
	for window_id in RUNTIME_NATIVE_WINDOW_IDS:
		var canonical := _normalize_desktop_window_id(str(window_id))
		var control := _desktop_window_control_for_id(canonical)
		if control == null:
			continue
		var native: Window = generated_native_windows.get(canonical, null)
		_register_desktop_window(canonical, control, native)


func _register_desktop_window(window_id: String, control: Control, native: Window = null) -> void:
	if control == null:
		return
	_ensure_desktop_window_manager()
	var canonical := _normalize_desktop_window_id(window_id)
	desktop_window_manager.register_window(canonical, control, native, {
		"title": _generated_window_label(canonical),
		"group": _desktop_window_group_for(canonical),
		"default_visible": _desktop_window_default_visible(canonical),
		"restore_visible": control.visible,
		"base_z": _desktop_window_base_z(canonical),
	})


func _desktop_window_control_for_id(window_id: String) -> Control:
	var canonical := _normalize_desktop_window_id(window_id)
	var native_root: Control = generated_native_window_roots.get(canonical, null)
	if native_root != null and is_instance_valid(native_root):
		return native_root
	if canonical == "skill_tree":
		var skill_window: Control = generated_runtime_nodes.get("skill_tree_window", null)
		if skill_window != null and is_instance_valid(skill_window):
			return skill_window
	if generated_ui_overlay == null:
		return null
	var path := str(NATIVE_WINDOW_ROOTS.get(canonical, ""))
	if path != "":
		var node := generated_ui_overlay.get_node_or_null(path)
		if node != null and node is Control:
			return node as Control
	if canonical == "combat":
		var combat := generated_ui_overlay.get_node_or_null(OVERLAY_COMBAT_STRIP_PATH)
		if combat != null and combat is Control:
			return combat as Control
	return null


func _normalize_desktop_window_id(window_id: String) -> String:
	match window_id:
		"map", "portal_map":
			return "portal"
		"skill", "skills":
			return "skill_tree"
		"hero", "inventory":
			return "keeper"
	return window_id


func _desktop_window_group_for(window_id: String) -> String:
	if window_id == "combat":
		return "combat"
	return "workshop"


func _desktop_window_default_visible(window_id: String) -> bool:
	return window_id != "skill_tree"


func _desktop_window_base_z(window_id: String) -> int:
	if window_id == "combat":
		return 70
	if window_id == "skill_tree":
		return 86
	return 80 + int(NATIVE_WINDOW_ORDER.get(window_id, 0))


func _ensure_desktop_window_registered(window_id: String) -> bool:
	var canonical := _normalize_desktop_window_id(window_id)
	_ensure_desktop_window_manager()
	if canonical == "skill_tree" and not desktop_window_manager.has_window(canonical) and generated_ui_overlay != null:
		_ensure_runtime_skill_tree_window(generated_ui_overlay)
	_register_generated_desktop_windows()
	return desktop_window_manager.has_window(canonical)


func show_desktop_window(window_id: String) -> void:
	var canonical := _normalize_desktop_window_id(window_id)
	if not _ensure_desktop_window_registered(canonical):
		return
	if canonical != "combat" and generated_taskbar_mode:
		generated_taskbar_mode = false
		_restore_generated_workshop_windows()
	desktop_window_manager.show_window(canonical, true)
	generated_action_message = "%s 창 열림" % _generated_window_label(canonical)
	_refresh_generated_overlay_now()


func hide_desktop_window(window_id: String) -> void:
	var canonical := _normalize_desktop_window_id(window_id)
	if not _ensure_desktop_window_registered(canonical):
		return
	desktop_window_manager.hide_window(canonical)
	generated_action_message = "%s 창 숨김 - combat strip은 계속 실행" % _generated_window_label(canonical)
	_refresh_generated_overlay_now()


func toggle_desktop_window(window_id: String) -> void:
	var canonical := _normalize_desktop_window_id(window_id)
	if not _ensure_desktop_window_registered(canonical):
		return
	if desktop_window_manager.is_window_visible(canonical):
		hide_desktop_window(canonical)
	else:
		show_desktop_window(canonical)


func focus_desktop_window(window_id: String) -> void:
	var canonical := _normalize_desktop_window_id(window_id)
	if not _ensure_desktop_window_registered(canonical):
		return
	desktop_window_manager.focus_window(canonical)


func desktop_window_snapshot() -> Dictionary:
	_ensure_desktop_window_manager()
	_register_generated_desktop_windows()
	return desktop_window_manager.snapshot()


func _sync_generated_ui_overlay(snapshot: Dictionary) -> void:
	var model := _generated_runtime_model(snapshot)
	var values := _generated_overlay_values(snapshot, model)
	_apply_generated_overlay_values(generated_ui_overlay, values)
	for native_root in generated_native_window_roots.values():
		if native_root is Node:
			_apply_generated_overlay_values(native_root, values)
	_sync_generated_portal_map_background(snapshot)
	_sync_generated_portal_map_progress(snapshot)
	_sync_desktop_status_bar(snapshot, model)
	_sync_generated_mvp_overlay(model)
	_sync_generated_combat_overlay(snapshot, model)
	_refresh_status_stat_scroll_layouts()
	_apply_generated_combat_opacity()


func _generated_overlay_values(snapshot: Dictionary, model: Dictionary = {}) -> Dictionary:
	var resources: Dictionary = model.get("resources", snapshot.get("resources", {})) if typeof(model.get("resources", snapshot.get("resources", {}))) == TYPE_DICTIONARY else {}
	var player: Dictionary = snapshot.get("player", {})
	var progression_snapshot := _progression_snapshot()
	var skills: Dictionary = progression_snapshot.get("skills", {}) if typeof(progression_snapshot.get("skills", {})) == TYPE_DICTIONARY else {}
	var materials: Dictionary = progression_snapshot.get("materials", {}) if typeof(progression_snapshot.get("materials", {})) == TYPE_DICTIONARY else {}
	var equipped_stats: Dictionary = model.get("equipped_stats", {}) if typeof(model.get("equipped_stats", {})) == TYPE_DICTIONARY else {}
	var attack := float(player.get("attack", 0.0))
	var attack_speed := float(player.get("attack_speed", 1.0))
	var max_hp := float(player.get("max_hp", 0.0))
	var enemy_ratio := 1.0
	var enemies: Array = snapshot.get("enemies", []) if typeof(snapshot.get("enemies", [])) == TYPE_ARRAY else []
	var focus_enemy := _focus_enemy(snapshot)
	for enemy in enemies:
		if typeof(enemy) == TYPE_DICTIONARY and bool(enemy.get("alive", true)):
			enemy_ratio = float(enemy.get("hp", 1.0)) / maxf(1.0, float(enemy.get("max_hp", 1.0)))
			break
	var latest_drop: Dictionary = model.get("latest_drop", {}) if typeof(model.get("latest_drop", {})) == TYPE_DICTIONARY else {}
	var toast_title := str(latest_drop.get("title", "전리품 대기"))
	var toast_body := str(latest_drop.get("body", "자동 전투 중"))
	return {
		"window.status.title": "스테이터스",
		"window.hero_inventory.title": "돌지기",
		"window.portal.title": "포탈",
		"selected_character.class_name": "돌팔매꾼 / 장착 돌 %d개" % _progression_equipped_stone_count(progression_snapshot),
		"resources.gold": _format_count(resources.get("gold", 12800000000)),
		"resources.ruby": _format_count(resources.get("ruby", 3450)),
		"resources.pebble_fragment": _format_count(resources.get("pebble", 28170)),
		"resources.moss_ore": _format_count(resources.get("ore", 5860)),
		"resources.cube_catalyst": _format_count(resources.get("catalyst", 1240)),
			"steam.sync_status": str(model.get("steam_status", "서버 LIVE   Steam SYNC")),
			"selected_character.level": str(model.get("keeper_level", "Lv. %d" % int(player.get("level", 27)))),
			"selected_stone.exp_ratio": float(model.get("stone_exp_ratio", clampf(float(player.get("hp", 1.0)) / maxf(1.0, float(player.get("max_hp", 1.0))), 0.0, 1.0))),
			"stats.level.label": "Level",
			"stats.level.value": "Lv.%d" % int(player.get("level", 1)),
			"stats.exp.label": "Exp",
			"stats.exp.value": _keeper_exp_text(player, resources).replace("EXP ", "").replace(" / ", "/"),
		"stats.basic_attack_dps.label": "DPS",
		"stats.basic_attack_dps.value": _format_stat_value(attack * attack_speed),
		"stats.attack_damage.label": "Attack",
		"stats.attack_damage.value": "%s (+%s)" % [_format_stat_value(attack), _format_stat_value(float(equipped_stats.get("Attack", 0.0)))],
		"stats.max_hp.label": "Max HP",
		"stats.max_hp.value": "%s (+%s)" % [_format_stat_value(max_hp), _format_stat_value(float(equipped_stats.get("Hp", 0.0)))],
		"stats.move_speed.label": "Move Speed",
		"stats.move_speed.value": _format_stat_value(float(player.get("move_speed", 1.0))),
		"stats.attack": "공격력  %d" % int(player.get("attack", 128)),
		"stats.attack_speed": "공격 속도  %.2f" % float(player.get("attack_speed", 2.35)),
		"stats.crit_chance": str(model.get("crit_text", "치명타 확률  12.4%")),
		"stats.gold_gain": "골드 획득  1.85x",
		"stats.drop_bonus": "드롭 보너스  +65%",
		"portal.selected_difficulty": str(model.get("portal_difficulty", "보통 / 자동진행")),
		"current_stage.label": _current_stage_label(snapshot),
		"combat.latest_rare_drop.title": toast_title,
		"combat.latest_rare_drop.body": toast_body,
		"combat.focus_enemy.hp_ratio": clampf(enemy_ratio, 0.0, 1.0),
		"combat.focus_enemy.name": str(focus_enemy.get("name", "적 없음")) if not focus_enemy.is_empty() else "적 없음",
		"combat.focus_enemy.hp_text": _runtime_enemy_hp_text(snapshot),
	}.merged(_status_skill_level_values(skills, materials), true)


func _apply_generated_overlay_values(node: Node, values: Dictionary) -> void:
	if node is Label:
		var binding := str(node.get_meta("text_binding_or_text_key", ""))
		if values.has(binding):
			node.text = str(values[binding])
	elif node is ProgressBar:
		var binding := str(node.get_meta("value_binding", ""))
		if values.has(binding):
			node.value = clampf(float(values[binding]), 0.0, 1.0)
	for child in node.get_children():
		_apply_generated_overlay_values(child, values)


func _style_generated_ui_overlay(node: Node) -> void:
	if node is Label:
		var font_size := int(node.get_meta("font_size", 14))
		var label := node as Label
		var color_token := str(node.get_meta("color_token", "text_cream"))
		label.add_theme_font_size_override("font_size", font_size)
		label.add_theme_color_override("font_color", _overlay_color(color_token))
		if color_token == "shadow":
			label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0))
			label.add_theme_constant_override("shadow_offset_x", 0)
			label.add_theme_constant_override("shadow_offset_y", 0)
		else:
			label.add_theme_color_override("font_shadow_color", Color("#050302"))
			label.add_theme_constant_override("shadow_offset_x", 2)
			label.add_theme_constant_override("shadow_offset_y", 2)
	if node is Button:
		var button_role := str(node.get_meta("button_role", ""))
		var button := node as Button
		_apply_generated_button_style(button, button_role)
		if button_role == "window_close":
			_prepare_generated_close_button(button)
	if node is PanelContainer:
		if not str(node.name).begins_with("Program"):
			var stylebox_key := str(node.get_meta("stylebox_key", ""))
			var panel := node as PanelContainer
			var textured_style: StyleBox = _overlay_texture_style(stylebox_key)
			if textured_style != null:
				panel.add_theme_stylebox_override("panel", textured_style)
			else:
				var token := str(node.get_meta("color_token", "panel_inner"))
				panel.add_theme_stylebox_override("panel", _overlay_style(_overlay_color(token), Color("#6b4a2a"), 2, 3))
	if node is ProgressBar:
		var progress := node as ProgressBar
		progress.min_value = 0.0
		progress.max_value = 1.0
		progress.add_theme_stylebox_override("background", _overlay_style(Color("#1a0f06"), Color("#6b4a2a"), 1, 1))
		progress.add_theme_stylebox_override("fill", _overlay_style(Color("#2e8fd0"), Color("#2e8fd0"), 0, 1))
	if node is TextureRect:
		_prepare_generated_texture_atom(node as TextureRect)
	for child in node.get_children():
		_style_generated_ui_overlay(child)


func _hydrate_generated_ui_overlay(root: Control) -> void:
	_polish_generated_window_contents(root)
	_apply_generated_program_window_chrome(root)
	_populate_generated_slot_grid(root, "Section_WindowStack/Panel_StatusWindowFrame/Grid_RuneMarkTree", 8, 4, 40.0, 6.0)
	_populate_generated_slot_grid(root, "Section_WindowStack/Panel_HeroInventoryWindowFrame/Grid_EquipmentSlotsLeft", 4, 2, 48.0, 6.0)
	_populate_generated_slot_grid(root, "Section_WindowStack/Panel_HeroInventoryWindowFrame/Grid_EquipmentSlotsRight", 4, 2, 48.0, 6.0)
	_populate_generated_slot_grid(root, "Section_WindowStack/Panel_HeroInventoryWindowFrame/Grid_StoneInventory", INVENTORY_VISIBLE_SLOTS, INVENTORY_GRID_COLUMNS, 44.0, 6.0)
	_set_generated_button_text(root, OVERLAY_STONE_TAB_PATH, "돌 활성 0/12")
	_set_generated_button_text(root, OVERLAY_EQUIPMENT_TAB_PATH, "장비 0/40")
	for act in range(1, 4):
		_set_generated_button_text(root, "Section_WindowStack/Panel_PortalWindowFrame/Tabs_Act/Btn_Act%d" % act, "Act %d" % act)
	_set_generated_button_text(root, "Section_WindowStack/Panel_PortalWindowFrame/Btn_CurrentStageNode", "1-1")
	var auto_skill := root.get_node_or_null("Section_BottomCombatStrip/Panel_AutoSkillToggle/Text_AutoSkill")
	if auto_skill != null and auto_skill is Label:
		(auto_skill as Label).text = "ATTACK 돌팔매"
	_ensure_generated_action_bar(root)
	_connect_generated_overlay_buttons(root)
	_ensure_generated_combat_layer(root)
	_ensure_generated_combat_soft_border(root)
	_ensure_generated_combat_readouts(root)
	_ensure_generated_taskbar_controls(root)
	_prepare_generated_combat_strip_drag(root)
	_ensure_runtime_skill_tree_window(root)
	_ensure_generated_modal_host(root)


func _polish_generated_window_chrome_buttons(root: Control) -> void:
	var window_paths := [
		"Section_WindowStack/Panel_StatusWindowFrame",
		"Section_WindowStack/Panel_HeroInventoryWindowFrame",
		"Section_WindowStack/Panel_PortalWindowFrame",
	]
	for path in window_paths:
		var window := root.get_node_or_null(path)
		if window == null or not window is Control:
			continue
		for child in window.get_children():
			if child is Button and str(child.name).ends_with("Minimize"):
				var button := child as Button
				button.text = ""
				button.visible = false
				button.disabled = true
				button.mouse_filter = Control.MOUSE_FILTER_IGNORE
				if button.has_node("Icon_Close"):
					button.get_node("Icon_Close").queue_free()
			elif child is Button and str(child.name).ends_with("Close"):
				(child as Button).text = ""


func _apply_generated_program_window_chrome(root: Control) -> void:
	_prepare_program_window(
		root,
		"Section_WindowStack/Panel_StatusWindowFrame",
		"Text_StatusTitle",
		"Btn_StatusClose",
		"status",
		"res://assets/generated/ui/stone_icon_set.png"
	)
	_prepare_program_window(
		root,
		"Section_WindowStack/Panel_HeroInventoryWindowFrame",
		"Text_HeroInventoryTitle",
		"Btn_HeroInventoryClose",
		"keeper",
		"res://assets/generated/ui/stone_keeper_sheet.png"
	)
	_prepare_program_window(
		root,
		"Section_WindowStack/Panel_PortalWindowFrame",
		"Text_PortalTitle",
		"Btn_PortalClose",
		"portal",
		"res://assets/generated/ui/portal_parchment_map.png"
	)


func _polish_generated_window_contents(root: Control) -> void:
	_polish_generated_window_chrome_buttons(root)
	_polish_desktop_status_bar(root)
	_polish_status_window(root)
	_polish_hero_inventory_window(root)
	_polish_portal_window(root)


func _polish_desktop_status_bar(root: Control) -> void:
	var scaffold := root.get_node_or_null("Section_DesktopScaffold")
	if scaffold == null or not scaffold is Control:
		return
	var band := root.get_node_or_null("Section_DesktopScaffold/Panel_OsTaskbarBand")
	if band == null or not band is PanelContainer:
		return
	var status_bar := band as PanelContainer
	status_bar.position = Vector2(0.0, 948.0)
	status_bar.size = Vector2(GENERATED_UI_REFERENCE_SIZE.x, 44.0)
	status_bar.custom_minimum_size = status_bar.size
	status_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	status_bar.add_theme_stylebox_override("panel", _overlay_style(Color("#080604"), Color("#5a3a20"), 1, 0))
	for child in status_bar.get_children():
		if str(child.name) != "Text_SteamSyncStatus":
			child.queue_free()
		elif child is CanvasItem:
			(child as CanvasItem).visible = false

	var layer := (scaffold as Control).get_node_or_null("RuntimeDesktopStatusBarLayer")
	if layer == null or not layer is Control:
		layer = Control.new()
		layer.name = "RuntimeDesktopStatusBarLayer"
		layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
		(scaffold as Control).add_child(layer)
	var status_layer := layer as Control
	status_layer.position = Vector2(0.0, 948.0)
	status_layer.size = Vector2(GENERATED_UI_REFERENCE_SIZE.x, 44.0)
	status_layer.z_index = 20

	var top_line := status_layer.get_node_or_null("Panel_StatusBarTopLine")
	if top_line == null or not top_line is ColorRect:
		top_line = ColorRect.new()
		top_line.name = "Panel_StatusBarTopLine"
		top_line.mouse_filter = Control.MOUSE_FILTER_IGNORE
		status_layer.add_child(top_line)
	(top_line as ColorRect).position = Vector2.ZERO
	(top_line as ColorRect).size = Vector2(status_layer.size.x, 2.0)
	(top_line as ColorRect).color = Color("#8a5b24")
	(top_line as ColorRect).z_index = 4

	_ensure_status_bar_chip(status_layer, "Panel_StatusBarBrandChip", Vector2(18.0, 8.0), Vector2(188.0, 28.0), Color("#1a1008"), Color("#d18a24"))
	_ensure_status_bar_chip(status_layer, "Panel_StatusBarModeChip", Vector2(222.0, 8.0), Vector2(160.0, 28.0), Color("#251711"), Color("#6b4a2a"))
	_ensure_status_bar_chip(status_layer, "Panel_StatusBarCombatChip", Vector2(398.0, 8.0), Vector2(378.0, 28.0), Color("#10100f"), Color("#6b4a2a"))
	_ensure_status_bar_chip(status_layer, "Panel_StatusBarWindowsChip", Vector2(792.0, 8.0), Vector2(318.0, 28.0), Color("#10100f"), Color("#6b4a2a"))
	_ensure_status_bar_chip(status_layer, "Panel_StatusBarSyncChip", Vector2(1220.0, 8.0), Vector2(340.0, 28.0), Color("#120c08"), Color("#8a5b24"))

	var brand := _ensure_status_bar_label(status_layer, "Text_StatusBarBrand", "TASKSTONEBAR", Vector2(34.0, 11.0), Vector2(156.0, 20.0), 13, Color("#ffcf7a"))
	brand.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_ensure_status_bar_label(status_layer, "Text_StatusBarMode", "WORKSHOP", Vector2(238.0, 11.0), Vector2(128.0, 20.0), 12, Color("#f3e6c8"))
	var combat := _ensure_status_bar_label(status_layer, "Text_StatusBarCombat", "", Vector2(414.0, 11.0), Vector2(346.0, 20.0), 12, Color("#f3e6c8"))
	combat.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	var windows := _ensure_status_bar_label(status_layer, "Text_StatusBarWindows", "", Vector2(808.0, 11.0), Vector2(286.0, 20.0), 12, Color("#b79a72"))
	windows.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_ensure_status_bar_label(status_layer, "Text_StatusBarSync", "", Vector2(1236.0, 11.0), Vector2(308.0, 20.0), 12, Color("#f3e6c8"))


func _ensure_status_bar_chip(parent: Control, node_name: String, pos: Vector2, chip_size: Vector2, fill: Color, border: Color) -> PanelContainer:
	var chip := _ensure_panel(parent, node_name, pos, chip_size, fill, border, 1, 2)
	chip.z_index = 1
	return chip


func _ensure_status_bar_label(parent: Control, node_name: String, text: String, pos: Vector2, label_size: Vector2, font_size: int, color: Color) -> Label:
	var label := _ensure_runtime_label(node_name, pos, label_size, font_size, color, parent)
	label.text = text
	label.z_index = 3
	return label


func _polish_status_window(root: Control) -> void:
	var window := root.get_node_or_null("Section_WindowStack/Panel_StatusWindowFrame")
	if window == null or not window is Control:
		return
	var status := window as Control
	status.position = COMPACT_STATUS_WINDOW_RECT.position
	status.size = COMPACT_STATUS_WINDOW_RECT.size
	status.scale = Vector2.ONE * WORKSHOP_WINDOW_VISUAL_SCALE
	var body_well := status.get_node_or_null("Panel_StatusBodyWell")
	if body_well != null and body_well is Control:
		(body_well as Control).position = Vector2(14.0, 58.0)
		(body_well as Control).size = Vector2(410.0, 486.0)
	var stat_scroll := window.get_node_or_null("Panel_StatusStatScroll")
	if stat_scroll != null and stat_scroll is NinePatchRect:
		(stat_scroll as Control).position = Vector2(20.0, 64.0)
		(stat_scroll as Control).size = Vector2(398.0, 178.0)
		(stat_scroll as NinePatchRect).modulate = Color(1.05, 0.98, 0.84, 1.0)
		_style_labels_under(stat_scroll, Color("#24170d"), Color("#dfcca2"), 1, ["Text_ClassName"])
	_polish_status_stat_scroll(status, stat_scroll)

	var skill_header_root := window.get_node_or_null("Panel_SkillPointHeader")
	if skill_header_root != null and skill_header_root is Control:
		(skill_header_root as Control).position = Vector2(72.0, 254.0)
		(skill_header_root as Control).size = Vector2(294.0, 36.0)
	var skill_header := window.get_node_or_null("Panel_SkillPointHeader/Panel_SkillPointHeaderBg")
	if skill_header != null and skill_header is PanelContainer:
		(skill_header as Control).size = Vector2(294.0, 36.0)
		(skill_header as PanelContainer).add_theme_stylebox_override("panel", _overlay_style(Color("#10100f"), Color("#8a5b24"), 2, 2))

	var skill_tree := window.get_node_or_null("Section_SkillTree")
	if skill_tree == null or not skill_tree is Control:
		return
	(skill_tree as Control).position = Vector2(22.0, 298.0)
	(skill_tree as Control).size = Vector2(396.0, 230.0)
	_polish_status_skill_track(skill_tree as Control)
	var row_specs := [
		{"name": "Panel_SkillTierBack0", "pos": Vector2(64.0, 0.0), "size": Vector2(306.0, 62.0), "arrow_y": 18.0},
		{"name": "Panel_SkillTierBack10", "pos": Vector2(64.0, 76.0), "size": Vector2(306.0, 62.0), "arrow_y": 94.0},
		{"name": "Panel_SkillTierBack30", "pos": Vector2(64.0, 170.0), "size": Vector2(306.0, 62.0), "arrow_y": 188.0},
	]
	for spec in row_specs:
		var back := _ensure_panel((skill_tree as Control), str(spec["name"]), spec["pos"], spec["size"], Color("#242322"), Color("#5d554b"), 2, 3)
		_move_before((skill_tree as Control), back, "Grid_StatusSkillSlots")
		var arrow_name := str(spec["name"]).replace("Panel_", "Text_Arrow_")
		var arrow := _ensure_runtime_label(arrow_name, Vector2(44.0, float(spec["arrow_y"])), Vector2(28.0, 24.0), 18, Color("#b79a72"), skill_tree as Control)
		arrow.text = "<"
		arrow.z_index = 3
	var skill_grid := skill_tree.get_node_or_null("Grid_StatusSkillSlots")
	if skill_grid != null and skill_grid is GridContainer:
		var grid := skill_grid as GridContainer
		grid.position = Vector2(82.0, 3.0)
		grid.size = Vector2(286.0, 226.0)
		grid.add_theme_constant_override("h_separation", 24)
		grid.add_theme_constant_override("v_separation", 18)
		for child in grid.get_children():
			if child is Control:
				_set_generated_slot_size(child as Control, 62.0)
	_set_canvas_z(skill_tree.get_node_or_null("Grid_StatusSkillSlots"), 3)


func _polish_hero_inventory_window(root: Control) -> void:
	var window := root.get_node_or_null("Section_WindowStack/Panel_HeroInventoryWindowFrame")
	if window == null or not window is Control:
		return
	var hero := window as Control
	hero.position = COMPACT_HERO_WINDOW_RECT.position
	hero.size = COMPACT_HERO_WINDOW_RECT.size
	hero.scale = Vector2.ONE * WORKSHOP_WINDOW_VISUAL_SCALE
	var body_well := hero.get_node_or_null("Panel_HeroInventoryBodyWell")
	if body_well != null and body_well is Control:
		(body_well as Control).position = Vector2(14.0, 58.0)
		(body_well as Control).size = Vector2(476.0, 548.0)
	var portrait_well := _ensure_panel(hero, "Panel_KeeperPortraitWell", Vector2(162.0, 72.0), Vector2(180.0, 158.0), Color("#10100f"), Color("#30241a"), 2, 3)
	_move_before(hero, portrait_well, "Tex_StoneKeeperPortrait")
	var portrait := hero.get_node_or_null("Tex_StoneKeeperPortrait")
	if portrait != null and portrait is Control:
		(portrait as Control).position = Vector2(181.0, 76.0)
		(portrait as Control).size = Vector2(142.0, 142.0)
	var level_label := hero.get_node_or_null("Text_KeeperLevel")
	if level_label != null and level_label is Control:
		(level_label as Control).position = Vector2(206.0, 204.0)
		(level_label as Control).size = Vector2(92.0, 28.0)
	_ensure_keeper_exp_bar(hero)
	var left_well := _ensure_panel(hero, "Panel_EquipmentSlotsLeftWell", Vector2(24.0, 72.0), Vector2(116.0, 116.0), Color("#0b0d0c"), Color("#3f2f20"), 1, 2)
	_move_before(hero, left_well, "Grid_EquipmentSlotsLeft")
	var right_well := _ensure_panel(hero, "Panel_EquipmentSlotsRightWell", Vector2(364.0, 72.0), Vector2(116.0, 116.0), Color("#0b0d0c"), Color("#3f2f20"), 1, 2)
	_move_before(hero, right_well, "Grid_EquipmentSlotsRight")
	var left_grid := hero.get_node_or_null("Grid_EquipmentSlotsLeft")
	if left_grid != null and left_grid is Control:
		(left_grid as Control).position = Vector2(30.0, 78.0)
		(left_grid as Control).size = Vector2(110.0, 110.0)
		if left_grid is GridContainer:
			(left_grid as GridContainer).add_theme_constant_override("h_separation", 6)
			(left_grid as GridContainer).add_theme_constant_override("v_separation", 6)
			_resize_grid_slots(left_grid as GridContainer, 52.0)
	var right_grid := hero.get_node_or_null("Grid_EquipmentSlotsRight")
	if right_grid != null and right_grid is Control:
		(right_grid as Control).position = Vector2(370.0, 78.0)
		(right_grid as Control).size = Vector2(110.0, 110.0)
		if right_grid is GridContainer:
			(right_grid as GridContainer).add_theme_constant_override("h_separation", 6)
			(right_grid as GridContainer).add_theme_constant_override("v_separation", 6)
			_resize_grid_slots(right_grid as GridContainer, 52.0)
	var tab_back := _ensure_panel(hero, "Panel_StoneEquipmentTabBackplate", Vector2(38.0, 262.0), Vector2(428.0, 40.0), Color("#0c0d0b"), Color("#3d2b1b"), 1, 3)
	_move_before(hero, tab_back, "Tabs_StoneEquipment")
	_polish_inventory_mode_tabs(hero)
	var grid_well := _ensure_panel(hero, "Panel_InventoryGridWell", Vector2(32.0, 304.0), Vector2(440.0, 230.0), Color("#070909"), Color("#2c2c25"), 1, 2)
	_move_before(hero, grid_well, "Grid_StoneInventory")
	var action_back := hero.get_node_or_null("Panel_RuntimeActionBarWell")
	if action_back != null:
		action_back.queue_free()
	var capacity := _ensure_runtime_label("Text_InventoryCapacity", Vector2(292.0, 280.0), Vector2(154.0, 20.0), 11, Color("#b79a72"), hero)
	capacity.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	capacity.visible = false
	var hint := _ensure_runtime_label("Text_InventoryModeHint", Vector2(48.0, 280.0), Vector2(230.0, 20.0), 11, Color("#f3e6c8"), hero)
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	hint.visible = false
	var grid := hero.get_node_or_null("Grid_StoneInventory")
	if grid != null and grid is Control:
		(grid as Control).position = Vector2(40.0, 314.0)
		(grid as Control).size = Vector2(424.0, 204.0)
		if grid is GridContainer:
			(grid as GridContainer).add_theme_constant_override("h_separation", 5)
			(grid as GridContainer).add_theme_constant_override("v_separation", 5)
			_resize_grid_slots(grid as GridContainer, 48.0)
	var dock := hero.get_node_or_null("Dock_KeeperIconDock")
	if dock != null and dock is Control:
		(dock as Control).position = Vector2(76.0, 542.0)
		(dock as Control).size = Vector2(352.0, 56.0)
		if dock is HBoxContainer:
			(dock as HBoxContainer).add_theme_constant_override("separation", 12)
		for child in dock.get_children():
			if child is Control:
				(child as Control).custom_minimum_size = Vector2(52.0, 52.0)
				(child as Control).size = Vector2(52.0, 52.0)
	for node_name in ["Tex_StoneKeeperPortrait", "Text_KeeperLevel", KEEPER_EXP_BAR_NAME, KEEPER_EXP_LABEL_NAME, "Grid_EquipmentSlotsLeft", "Grid_EquipmentSlotsRight", "Tabs_StoneEquipment", "Text_InventoryCapacity", "Text_InventoryModeHint", "Grid_StoneInventory", "Dock_KeeperIconDock", OVERLAY_ACTION_STATUS_NAME]:
		_set_canvas_z(hero.get_node_or_null(node_name), 3)


func _polish_inventory_mode_tabs(hero: Control) -> void:
	var tabs := hero.get_node_or_null("Tabs_StoneEquipment")
	if tabs != null and tabs is Control:
		var tabs_control := tabs as Control
		tabs_control.position = Vector2(42.0, 266.0)
		tabs_control.size = Vector2(420.0, 34.0)
		tabs_control.custom_minimum_size = Vector2(420.0, 34.0)
		tabs_control.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		if tabs_control is HBoxContainer:
			(tabs_control as HBoxContainer).add_theme_constant_override("separation", 6)
	_prepare_inventory_mode_button(hero.get_node_or_null("Tabs_StoneEquipment/Btn_StoneTab"), "돌 인벤토리 보기")
	_prepare_inventory_mode_button(hero.get_node_or_null("Tabs_StoneEquipment/Btn_EquipmentTab"), "장비 인벤토리 보기")


func _prepare_inventory_mode_button(node: Node, tooltip: String) -> void:
	if node == null or not node is Button:
		return
	var button := node as Button
	button.custom_minimum_size = Vector2(207.0, 34.0)
	button.size = Vector2(207.0, 34.0)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	button.toggle_mode = true
	button.clip_text = true
	button.tooltip_text = tooltip
	button.add_theme_font_size_override("font_size", 13)
	_apply_inventory_mode_button_style(button, button.button_pressed)


func _polish_portal_window(root: Control) -> void:
	var window := root.get_node_or_null("Section_WindowStack/Panel_PortalWindowFrame")
	if window == null or not window is Control:
		return
	var portal := window as Control
	portal.position = COMPACT_PORTAL_WINDOW_RECT.position
	portal.size = COMPACT_PORTAL_WINDOW_RECT.size
	portal.scale = Vector2.ONE * WORKSHOP_WINDOW_VISUAL_SCALE
	var body_well := portal.get_node_or_null("Panel_PortalBodyWell")
	if body_well != null and body_well is Control:
		(body_well as Control).position = Vector2(14.0, 58.0)
		(body_well as Control).size = Vector2(410.0, 486.0)
	var difficulty := portal.get_node_or_null("Panel_DifficultySelect")
	if difficulty != null and difficulty is PanelContainer:
		(difficulty as Control).position = Vector2(98.0, 74.0)
		(difficulty as Control).size = Vector2(242.0, 38.0)
		(difficulty as PanelContainer).add_theme_stylebox_override("panel", _overlay_style(Color("#21140c"), Color("#8a5b24"), 2, 3))
	_ensure_portal_chain(portal)
	var tab_back := _ensure_panel(portal, "Panel_ActTabsBackplate", Vector2(48.0, 116.0), Vector2(342.0, 42.0), Color("#100c09"), Color("#2e251d"), 1, 2)
	_move_before(portal, tab_back, "Tabs_Act")
	var act_tabs := portal.get_node_or_null("Tabs_Act")
	if act_tabs != null and act_tabs is Control:
		(act_tabs as Control).position = Vector2(54.0, 122.0)
		(act_tabs as Control).size = Vector2(330.0, 36.0)
		if act_tabs is HBoxContainer:
			(act_tabs as HBoxContainer).add_theme_constant_override("separation", 6)
		for child in act_tabs.get_children():
			if child is Control:
				(child as Control).custom_minimum_size = Vector2(104.0, 36.0)
				(child as Control).size = Vector2(104.0, 36.0)
	var map_shadow := _ensure_panel(portal, "Panel_ParchmentMapShadow", Vector2(34.0, 176.0), Vector2(376.0, 364.0), Color(0.0, 0.0, 0.0, 0.36), Color(0.0, 0.0, 0.0, 0.0), 0, 12)
	map_shadow.z_index = 1
	_move_before(portal, map_shadow, "Tex_ParchmentRouteMap")
	var map_frame := _ensure_panel(portal, "Panel_ParchmentMapFrame", Vector2(29.0, 169.0), Vector2(380.0, 368.0), Color("#080705"), Color("#221a12"), 1, 8)
	_move_before(portal, map_frame, "Tex_ParchmentRouteMap")
	var map := portal.get_node_or_null("Tex_ParchmentRouteMap")
	if map != null and map is Control:
		(map as Control).position = Vector2(31.0, 171.0)
		(map as Control).size = Vector2(376.0, 364.0)
		(map as CanvasItem).modulate = Color(1.04, 1.0, 0.92, 1.0)
		if map is TextureRect:
			(map as TextureRect).stretch_mode = TextureRect.STRETCH_SCALE
			(map as TextureRect).texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_ensure_portal_map_overlays(portal)
	var stage_node := portal.get_node_or_null("Btn_CurrentStageNode")
	if stage_node != null and stage_node is Control:
		(stage_node as Control).position = Vector2(150.0, 466.0)
		(stage_node as Control).size = Vector2(36.0, 36.0)
		(stage_node as CanvasItem).z_index = 8
		if stage_node is Button:
			(stage_node as Button).text = "1-1"
	for node_name in ["Panel_DifficultySelect", "Tabs_Act", "Tex_ParchmentRouteMap", "Panel_PortalMapBanner", "Panel_PortalCurrentFlag"]:
		_set_canvas_z(portal.get_node_or_null(node_name), 3)
	_set_canvas_z(stage_node, 8)


func _polish_status_stat_scroll(_status: Control, stat_scroll_node: Node) -> void:
	if stat_scroll_node == null or not stat_scroll_node is Control:
		return
	var stat_scroll := stat_scroll_node as Control
	_ensure_rect(stat_scroll, "Line_StatusScrollTopBevel", Vector2(10.0, 8.0), Vector2(378.0, 2.0), Color("#6b4a2a"), 2)
	_ensure_rect(stat_scroll, "Line_StatusScrollBottomBevel", Vector2(12.0, 168.0), Vector2(374.0, 2.0), Color("#5c4525"), 2)
	_ensure_rect(stat_scroll, "Line_StatusScrollLeftBinding", Vector2(16.0, 24.0), Vector2(3.0, 132.0), Color("#6a3b20"), 2)
	_ensure_rect(stat_scroll, "Line_StatusScrollRightBinding", Vector2(362.0, 24.0), Vector2(2.0, 132.0), Color("#6a3b20"), 2)
	var ribbon := stat_scroll.get_node_or_null("Panel_ClassRibbon")
	if ribbon != null and ribbon is Control:
		(ribbon as Control).position = Vector2(86.0, 10.0)
		(ribbon as Control).size = Vector2(226.0, 28.0)
		if ribbon is PanelContainer:
			(ribbon as PanelContainer).add_theme_stylebox_override("panel", _overlay_style(Color("#090705"), Color("#6b4a2a"), 2, 2))
	var row_sheet := _ensure_panel(stat_scroll, "Panel_StatusRowsCleanSheet", Vector2(38.0, 42.0), Vector2(318.0, 128.0), Color("#d1b06d"), Color("#8a5b24"), 1, 1)
	row_sheet.z_index = 1
	_move_before(stat_scroll, row_sheet, "Group_StatusRows")
	var group := stat_scroll.get_node_or_null("Group_StatusRows")
	if group == null or not group is Control:
		return
	var rows := group as Control
	rows.position = Vector2(60.0, 46.0)
	rows.size = Vector2(286.0, 116.0)
	rows.z_index = 4
	var row_specs := [
		{"label": "Text_StatusLevelLabel", "value": "Text_StatusLevelValue", "name": "Level", "display": "", "y": 0.0},
		{"label": "Text_StatusExpLabel", "value": "Text_StatusExpValue", "name": "EXP", "display": "", "y": 15.0},
		{"label": "Text_StatusDpsLabel", "value": "Text_StatusDpsValue", "name": "Basic Attack DPS", "display": "", "y": 30.0},
		{"label": "Text_StatusAttackDamageLabel", "value": "Text_StatusAttackDamageValue", "name": "Attack Damage", "display": "", "y": 45.0},
		{"label": "Text_StatusMaxHpLabel", "value": "Text_StatusMaxHpValue", "name": "Max HP", "display": "", "y": 60.0},
		{"label": "Text_StatusMoveSpeedLabel", "value": "Text_StatusMoveSpeedValue", "name": "Move Speed", "display": "", "y": 75.0},
		{"label": "Text_StatusAttackSpeedExtraLabel", "value": "Text_StatusAttackSpeedExtraValue", "name": "Attack Speed", "display": "2.35", "y": 90.0},
		{"label": "Text_StatusCritExtraLabel", "value": "Text_StatusCritExtraValue", "name": "Critical Rate", "display": "12.4%", "y": 105.0},
	]
	for spec in row_specs:
		_position_status_stat_row(rows, str(spec["label"]), str(spec["value"]), str(spec["name"]), str(spec["display"]), float(spec["y"]))
	var scroll_thumb := stat_scroll.get_node_or_null("Panel_StatusScrollbar")
	if scroll_thumb != null and scroll_thumb is Control:
		(scroll_thumb as Control).position = Vector2(374.0, 48.0)
		(scroll_thumb as Control).size = Vector2(8.0, 82.0)
	_ensure_panel(stat_scroll, "Panel_StatusScrollbarTopCap", Vector2(373.0, 36.0), Vector2(10.0, 10.0), Color("#9f7d49"), Color("#2d1a0f"), 1, 1).z_index = 5
	_ensure_panel(stat_scroll, "Panel_StatusScrollbarBottomCap", Vector2(373.0, 132.0), Vector2(10.0, 10.0), Color("#9f7d49"), Color("#2d1a0f"), 1, 1).z_index = 5


func _refresh_status_stat_scroll_layouts() -> void:
	for root in _status_window_roots():
		if root is Control:
			var stat_scroll := (root as Control).get_node_or_null("Panel_StatusStatScroll")
			if stat_scroll != null:
				_polish_status_stat_scroll(root as Control, stat_scroll)


func _position_status_stat_row(parent: Control, label_name: String, value_name: String, label_text: String, value_text: String, y: float) -> void:
	var label := _ensure_runtime_label(label_name, Vector2(0.0, y), Vector2(158.0, 15.0), 13, Color("#24170d"), parent)
	label.text = label_text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	label.z_index = 5
	label.add_theme_color_override("font_shadow_color", Color("#dfcca2"))
	label.add_theme_constant_override("shadow_offset_x", 1)
	label.add_theme_constant_override("shadow_offset_y", 1)
	var value := _ensure_runtime_label(value_name, Vector2(158.0, y), Vector2(126.0, 15.0), 13, Color("#24170d"), parent)
	if value_text != "":
		value.text = value_text
	value.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	value.z_index = 5
	value.add_theme_color_override("font_shadow_color", Color("#dfcca2"))
	value.add_theme_constant_override("shadow_offset_x", 1)
	value.add_theme_constant_override("shadow_offset_y", 1)


func _polish_status_skill_track(skill_tree: Control) -> void:
	var rail := skill_tree.get_node_or_null("Panel_LevelTrackRail")
	if rail != null and rail is Control:
		(rail as Control).position = Vector2(28.0, 22.0)
		(rail as Control).size = Vector2(10.0, 202.0)
		if rail is PanelContainer:
			(rail as PanelContainer).add_theme_stylebox_override("panel", _overlay_style(Color("#c0392b"), Color("#432018"), 2, 4))
	_ensure_panel(skill_tree, "Panel_LevelTrackTopCap", Vector2(18.0, 4.0), Vector2(30.0, 26.0), Color("#4b3420"), Color("#ffcf7a"), 2, 4).z_index = 3
	_ensure_panel(skill_tree, "Panel_LevelTrackBottomCap", Vector2(20.0, 216.0), Vector2(26.0, 18.0), Color("#4b3420"), Color("#d18a24"), 2, 4).z_index = 3
	var tick_specs := [
		{"label": "Text_LevelTick0", "line": "Panel_LevelTickLine0", "label_y": 12.0, "line_y": 30.0},
		{"label": "Text_LevelTick10", "line": "Panel_LevelTickLine10", "label_y": 88.0, "line_y": 106.0},
		{"label": "Text_LevelTick30", "line": "Panel_LevelTickLine30", "label_y": 182.0, "line_y": 200.0},
	]
	for spec in tick_specs:
		var label := skill_tree.get_node_or_null(str(spec["label"]))
		if label != null and label is Control:
			(label as Control).position = Vector2(0.0, float(spec["label_y"]))
		var line := skill_tree.get_node_or_null(str(spec["line"]))
		if line != null and line is Control:
			(line as Control).position = Vector2(20.0, float(spec["line_y"]))
			(line as Control).size = Vector2(38.0, 3.0)


func _resize_grid_slots(grid: GridContainer, slot_size: float) -> void:
	for child in grid.get_children():
		if child is Control:
			_set_generated_slot_size(child as Control, slot_size)


func _ensure_portal_chain(portal: Control) -> void:
	for index in range(8):
		var left_x := 38.0 + float(index) * 20.0
		var right_x := 260.0 + float(index) * 20.0
		_ensure_panel(portal, "Panel_PortalChainLeft%d" % index, Vector2(left_x, 91.0), Vector2(12.0, 5.0), Color("#4b3624"), Color("#9f7d49"), 1, 2).z_index = 2
		_ensure_panel(portal, "Panel_PortalChainRight%d" % index, Vector2(right_x, 91.0), Vector2(12.0, 5.0), Color("#4b3624"), Color("#9f7d49"), 1, 2).z_index = 2


func _ensure_portal_map_overlays(portal: Control) -> void:
	var banner := _ensure_panel(portal, "Panel_PortalMapBanner", Vector2(126.0, 188.0), Vector2(188.0, 34.0), Color("#d8c18a"), Color("#6e5a34"), 2, 5)
	banner.z_index = 5
	var banner_label := _ensure_runtime_label("Text_PortalMapBanner", Vector2(10.0, 5.0), Vector2(168.0, 24.0), 15, Color("#2d1f12"), banner)
	banner_label.text = "작업표시줄 동굴"
	banner_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	banner_label.add_theme_color_override("font_shadow_color", Color("#ecdcae"))
	_sync_portal_route_lines(portal, 1)
	for index in range(PORTAL_MAPS_PER_ACT):
		var node_name := _portal_stage_node_name(index)
		var node := _ensure_panel(portal, node_name, _portal_stage_position(index), PORTAL_STAGE_NODE_SIZE, Color("#4b3219"), Color("#b19155"), 2, 10)
		node.z_index = 5
		var label := _ensure_runtime_label("Text_%s" % node_name, Vector2(2.0, 5.0), PORTAL_STAGE_NODE_SIZE - Vector2(4.0, 10.0), 10, Color("#f3e6c8"), node)
		label.text = "1-%d" % (index + 1)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.add_theme_color_override("font_shadow_color", Color("#050302"))
	var boss := _ensure_panel(portal, "Panel_PortalBossNode", Vector2(366.0, 202.0), Vector2(30.0, 28.0), Color("#2b1a12"), Color("#ffcf7a"), 2, 10)
	boss.z_index = 5
	var boss_label := _ensure_runtime_label("Text_PortalBossNode", Vector2(3.0, 5.0), Vector2(24.0, 18.0), 11, Color("#ffcf7a"), boss)
	boss_label.text = "B"
	var ring := _ensure_panel(portal, "Panel_PortalCurrentRing", Vector2(144.0, 458.0), Vector2(50.0, 50.0), Color(0.0, 0.0, 0.0, 0.0), Color("#35d466"), 4, 18)
	ring.z_index = 4
	var flag := _ensure_panel(portal, "Panel_PortalCurrentFlag", Vector2(182.0, 428.0), Vector2(34.0, 22.0), Color("#c0392b"), Color("#371311"), 2, 2)
	flag.z_index = 7
	_ensure_rect(portal, "Line_PortalCurrentFlagPole", Vector2(182.0, 430.0), Vector2(4.0, 52.0), Color("#2e1b16"), 7)


func _portal_progress_from_snapshot(snapshot: Dictionary) -> Dictionary:
	var map_id := int(snapshot.get("map_id", PORTAL_FIRST_MAP_ID))
	var linear_index := maxi(0, map_id - PORTAL_FIRST_MAP_ID)
	var act := int(floor(float(linear_index) / float(PORTAL_MAPS_PER_ACT))) + 1
	var stage := int(linear_index % PORTAL_MAPS_PER_ACT) + 1
	return {
		"map_id": map_id,
		"act": clampi(act, 1, PORTAL_TOTAL_ACTS),
		"stage": clampi(stage, 1, PORTAL_MAPS_PER_ACT),
		"map_name": str(snapshot.get("map_name", "작업표시줄 동굴")),
	}


func _portal_stage_node_name(index: int) -> String:
	return "Panel_PortalStage%d" % (21 + index)


func _portal_stage_position(index: int) -> Vector2:
	return PORTAL_STAGE_ROUTE_POSITIONS[clampi(index, 0, PORTAL_STAGE_ROUTE_POSITIONS.size() - 1)]


func _portal_stage_center(index: int) -> Vector2:
	return _portal_stage_position(index) + PORTAL_STAGE_NODE_SIZE * 0.5


func _portal_visible_act_start(active_act: int) -> int:
	return clampi(active_act - 1, 1, maxi(1, PORTAL_TOTAL_ACTS - 2))


func _portal_window_roots() -> Array:
	var roots := []
	var portal_root := _generated_native_root_by_name("Panel_PortalWindowFrame")
	if portal_root != null:
		roots.append(portal_root)
	var overlay_root := _generated_node_or_null("Section_WindowStack/Panel_PortalWindowFrame")
	if overlay_root != null and not roots.has(overlay_root):
		roots.append(overlay_root)
	return roots


func _sync_generated_portal_map_progress(snapshot: Dictionary) -> void:
	var progress := _portal_progress_from_snapshot(snapshot)
	var active_act := int(progress.get("act", 1))
	var active_stage := int(progress.get("stage", 1))
	var map_name := str(progress.get("map_name", "작업표시줄 동굴"))
	for root in _portal_window_roots():
		if root is Control:
			_sync_portal_window_progress(root as Control, active_act, active_stage, map_name)


func _sync_portal_window_progress(portal: Control, active_act: int, active_stage: int, map_name: String) -> void:
	_sync_portal_route_lines(portal, active_stage)
	var banner_label := portal.get_node_or_null("Panel_PortalMapBanner/Text_PortalMapBanner")
	if banner_label != null and banner_label is Label:
		(banner_label as Label).text = map_name
	var difficulty := portal.get_node_or_null("Panel_DifficultySelect/Text_Difficulty")
	if difficulty != null and difficulty is Label:
		(difficulty as Label).text = "보통 / Act %d-%d" % [active_act, active_stage]
	var visible_act_start := _portal_visible_act_start(active_act)
	for index in range(3):
		var visible_act := visible_act_start + index
		var button := portal.get_node_or_null("Tabs_Act/Btn_Act%d" % (index + 1))
		if button != null and button is Button:
			_sync_portal_act_button(button as Button, visible_act, visible_act == active_act)
	for index in range(PORTAL_MAPS_PER_ACT):
		_sync_portal_stage_node(portal, index, active_act, active_stage)
	_sync_portal_current_marker(portal, active_act, active_stage)


func _sync_portal_act_button(button: Button, visible_act: int, selected: bool) -> void:
	button.text = "Act %d" % visible_act
	var fill := Color("#6b2a18") if selected else Color("#2b1a12")
	var border := Color("#d18a24") if selected else Color("#6b4a2a")
	button.add_theme_stylebox_override("normal", _overlay_style(fill, border, 2, 2))
	button.add_theme_stylebox_override("hover", _overlay_style(fill.lightened(0.1), Color("#ffcf7a"), 2, 2))
	button.add_theme_stylebox_override("pressed", _overlay_style(fill.darkened(0.12), border, 2, 2))
	button.add_theme_color_override("font_color", Color("#ffcf7a") if selected else Color("#f3e6c8"))


func _sync_portal_stage_node(portal: Control, index: int, active_act: int, active_stage: int) -> void:
	var stage_number := index + 1
	var completed := stage_number < active_stage
	var current := stage_number == active_stage
	var next_open := stage_number == active_stage + 1
	var locked := stage_number > active_stage + 1
	var node := portal.get_node_or_null(_portal_stage_node_name(index))
	if node == null or not node is PanelContainer:
		return
	var panel := node as PanelContainer
	panel.position = _portal_stage_position(index)
	panel.size = PORTAL_STAGE_NODE_SIZE
	var fill := Color("#241d18")
	var border := Color("#5f5141")
	var font := Color("#b79a72")
	if completed:
		fill = Color("#674522")
		border = Color("#ffcf7a")
		font = Color("#fff0a6")
	elif current:
		fill = Color("#4b3219")
		border = Color("#d18a24")
		font = Color("#fff0a6")
	elif next_open:
		fill = Color("#4b3219")
		border = Color("#b19155")
		font = Color("#f3e6c8")
	panel.add_theme_stylebox_override("panel", _overlay_style(fill, border, 2, 10))
	panel.modulate = Color(1.0, 1.0, 1.0, 0.68 if locked else 1.0)
	var label := panel.get_node_or_null("Text_%s" % _portal_stage_node_name(index))
	if label != null and label is Label:
		(label as Label).text = "%d-%d" % [active_act, stage_number]
		(label as Label).add_theme_color_override("font_color", font)
	if stage_number == PORTAL_MAPS_PER_ACT:
		var boss := portal.get_node_or_null("Panel_PortalBossNode")
		if boss != null and boss is PanelContainer:
			var boss_fill := fill.darkened(0.08) if not current else Color("#213619")
			var boss_border := Color("#ffcf7a") if completed or current else border
			(boss as PanelContainer).add_theme_stylebox_override("panel", _overlay_style(boss_fill, boss_border, 2, 10))


func _sync_portal_current_marker(portal: Control, active_act: int, active_stage: int) -> void:
	var current_index := clampi(active_stage - 1, 0, PORTAL_MAPS_PER_ACT - 1)
	var node_pos := _portal_stage_position(current_index)
	var ring := portal.get_node_or_null("Panel_PortalCurrentRing")
	if ring != null and ring is PanelContainer:
		var ring_panel := ring as PanelContainer
		ring_panel.position = node_pos + Vector2(-4.0, -4.0)
		ring_panel.size = PORTAL_STAGE_NODE_SIZE + Vector2(8.0, 8.0)
		ring_panel.z_index = 4
		ring_panel.add_theme_stylebox_override("panel", _overlay_style(Color(0.0, 0.0, 0.0, 0.0), Color(1.0, 0.76, 0.28, 0.42), 1, 11))
	var flag := portal.get_node_or_null("Panel_PortalCurrentFlag")
	if flag != null and flag is Control:
		(flag as Control).visible = false
	var pole := portal.get_node_or_null("Line_PortalCurrentFlagPole")
	if pole != null and pole is Control:
		(pole as Control).visible = false
	var stage_button := portal.get_node_or_null("Btn_CurrentStageNode")
	if stage_button != null and stage_button is Control:
		var control := stage_button as Control
		control.position = node_pos
		control.size = PORTAL_STAGE_NODE_SIZE
		(control as CanvasItem).z_index = 8
		if stage_button is Button:
			var button := stage_button as Button
			button.text = ""
			button.flat = true
			button.tooltip_text = "Act %d-%d" % [active_act, active_stage]
			var transparent := _overlay_style(Color(0.0, 0.0, 0.0, 0.0), Color(0.0, 0.0, 0.0, 0.0), 0, 10)
			button.add_theme_stylebox_override("normal", transparent)
			button.add_theme_stylebox_override("hover", transparent)
			button.add_theme_stylebox_override("pressed", transparent)
			button.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0, 0.0))


func _sync_portal_route_lines(portal: Control, active_stage: int) -> void:
	var points := _portal_route_curve_points(PORTAL_MAPS_PER_ACT)
	var completed_points := _portal_route_curve_points(clampi(active_stage, 1, PORTAL_MAPS_PER_ACT))
	_ensure_portal_route_line(portal, "Line_PortalRoutePathShadow", points, 9.0, Color(0.03, 0.02, 0.01, 0.58), 3)
	_ensure_portal_route_line(portal, "Line_PortalRoutePath", points, 5.0, Color("#7a5b2c"), 4)
	_ensure_portal_route_line(portal, "Line_PortalRouteProgress", completed_points, 5.0, Color("#d18a24"), 4)


func _portal_route_curve_points(stage_count: int) -> Array:
	var count := clampi(stage_count, 1, PORTAL_MAPS_PER_ACT)
	var output := []
	if count == 1:
		output.append(_portal_stage_center(0))
		return output
	for index in range(count - 1):
		var start := _portal_stage_center(index)
		var end := _portal_stage_center(index + 1)
		var direction := end - start
		var normal := Vector2.ZERO
		if direction.length() > 0.001:
			normal = Vector2(-direction.y, direction.x).normalized()
		var sway := float(PORTAL_ROUTE_CURVE_SWAYS[index % PORTAL_ROUTE_CURVE_SWAYS.size()])
		var control := start.lerp(end, 0.5) + normal * sway
		for step in range(7):
			if index > 0 and step == 0:
				continue
			var t := float(step) / 6.0
			output.append(_quadratic_curve_point(start, control, end, t))
	return output


func _quadratic_curve_point(start: Vector2, control: Vector2, end: Vector2, t: float) -> Vector2:
	var a := start.lerp(control, t)
	var b := control.lerp(end, t)
	return a.lerp(b, t)


func _ensure_portal_route_line(parent: Control, node_name: String, points: Array, width: float, color: Color, z: int) -> Line2D:
	var existing := parent.get_node_or_null(node_name)
	var line: Line2D
	if existing != null and existing is Line2D:
		line = existing as Line2D
	else:
		if existing != null:
			existing.queue_free()
		line = Line2D.new()
		line.name = node_name
		parent.add_child(line)
	var packed := PackedVector2Array()
	for point in points:
		packed.append(point)
	line.points = packed
	line.width = width
	line.default_color = color
	line.joint_mode = Line2D.LINE_JOINT_ROUND
	line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	line.end_cap_mode = Line2D.LINE_CAP_ROUND
	line.z_index = z
	return line


func _sync_generated_portal_map_background(snapshot: Dictionary) -> void:
	var map_node := _generated_node_or_null("Section_WindowStack/Panel_PortalWindowFrame/Tex_ParchmentRouteMap")
	if map_node == null or not map_node is TextureRect:
		return
	var map_id := int(snapshot.get("map_id", 500101))
	var texture_path := str(GENERATED_PORTAL_MAP_TEXTURES.get(map_id, GENERATED_PORTAL_MAP_TEXTURE_FALLBACK))
	var texture := _generated_texture(texture_path)
	if texture == null:
		return
	var map_rect := map_node as TextureRect
	if map_rect.texture != texture:
		map_rect.texture = texture
	map_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	map_rect.stretch_mode = TextureRect.STRETCH_SCALE
	map_rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST


func _ensure_panel(parent: Control, node_name: String, pos: Vector2, panel_size: Vector2, fill: Color, border: Color, border_width: int, radius: int) -> PanelContainer:
	var existing := parent.get_node_or_null(node_name)
	var panel: PanelContainer
	if existing != null and existing is PanelContainer:
		panel = existing as PanelContainer
	else:
		panel = PanelContainer.new()
		panel.name = node_name
		panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
		parent.add_child(panel)
	panel.position = pos
	panel.size = panel_size
	panel.z_index = 1
	panel.add_theme_stylebox_override("panel", _overlay_style(fill, border, border_width, radius))
	return panel


func _ensure_rect(parent: Control, node_name: String, pos: Vector2, rect_size: Vector2, color: Color, z: int) -> ColorRect:
	var existing := parent.get_node_or_null(node_name)
	var rect: ColorRect
	if existing != null and existing is ColorRect:
		rect = existing as ColorRect
	else:
		if existing != null:
			existing.queue_free()
		rect = ColorRect.new()
		rect.name = node_name
		rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		parent.add_child(rect)
	rect.position = pos
	rect.size = rect_size
	rect.color = color
	rect.z_index = z
	return rect


func _move_before(parent: Control, child: Node, before_name: String) -> void:
	var before := parent.get_node_or_null(before_name)
	if before == null:
		return
	parent.move_child(child, before.get_index())


func _ensure_runtime_label(node_name: String, pos: Vector2, label_size: Vector2, font_size: int, color: Color, parent: Control) -> Label:
	var existing := parent.get_node_or_null(node_name)
	var label: Label
	if existing != null and existing is Label:
		label = existing as Label
	else:
		label = Label.new()
		label.name = node_name
		label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		parent.add_child(label)
	label.anchor_left = 0.0
	label.anchor_top = 0.0
	label.anchor_right = 0.0
	label.anchor_bottom = 0.0
	label.position = pos
	label.size = label_size
	label.custom_minimum_size = label_size
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.clip_text = true
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	label.add_theme_color_override("font_shadow_color", Color("#050302"))
	label.add_theme_constant_override("shadow_offset_x", 1)
	label.add_theme_constant_override("shadow_offset_y", 1)
	return label


func _ensure_keeper_exp_bar(hero: Control) -> void:
	var progress := hero.get_node_or_null(KEEPER_EXP_BAR_NAME)
	if progress == null:
		progress = ProgressBar.new()
		progress.name = KEEPER_EXP_BAR_NAME
		progress.mouse_filter = Control.MOUSE_FILTER_IGNORE
		progress.show_percentage = false
		hero.add_child(progress)
	var bar := progress as ProgressBar
	bar.position = Vector2(178.0, 236.0)
	bar.size = Vector2(148.0, 8.0)
	bar.min_value = 0.0
	bar.max_value = 1.0
	bar.add_theme_stylebox_override("background", _overlay_style(Color("#120c08"), Color("#6b4a2a"), 1, 2))
	bar.add_theme_stylebox_override("fill", _overlay_style(Color("#49b7d8"), Color("#49b7d8"), 0, 2))
	var label := _ensure_runtime_label(KEEPER_EXP_LABEL_NAME, Vector2(166.0, 246.0), Vector2(172.0, 14.0), 9, Color("#bde7ff"), hero)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER


func _set_canvas_z(node: Node, z_value: int) -> void:
	if node != null and node is CanvasItem:
		(node as CanvasItem).z_index = z_value


func _style_labels_under(node: Node, font_color: Color, shadow_color: Color, shadow_offset: int, skip_names: Array = []) -> void:
	if node == null:
		return
	if node is Label and not skip_names.has(str(node.name)):
		var label := node as Label
		label.add_theme_color_override("font_color", font_color)
		label.add_theme_color_override("font_shadow_color", shadow_color)
		label.add_theme_constant_override("shadow_offset_x", shadow_offset)
		label.add_theme_constant_override("shadow_offset_y", shadow_offset)
	for child in node.get_children():
		_style_labels_under(child, font_color, shadow_color, shadow_offset, skip_names)


func _prepare_program_window(root: Control, frame_path: String, title_name: String, close_name: String, window_id: String, icon_path: String) -> void:
	var frame := root.get_node_or_null(frame_path)
	if frame == null or not frame is Control:
		return
	var window := frame as Control
	window.set_meta("program_window_id", window_id)
	_ensure_program_window_shadow(window)
	_ensure_program_window_client_area(window)
	var title_label: Label = window.get_node_or_null(title_name) as Label
	var close_button: Button = window.get_node_or_null(close_name) as Button
	var title_bar := WindowTitleBarChrome.apply(window, {
		"title_label": title_label,
		"close_button": close_button,
		"close_icon": _generated_texture(GENERATED_CLOSE_ICON_PATH),
	})
	if title_bar != null:
		_connect_program_window_drag(title_bar, window)
	_hide_program_window_minimize(window)


func _ensure_program_window_shadow(window: Control) -> void:
	var shadow: ColorRect
	if window.has_node("ProgramWindowShadow") and window.get_node("ProgramWindowShadow") is ColorRect:
		shadow = window.get_node("ProgramWindowShadow") as ColorRect
	else:
		shadow = ColorRect.new()
		shadow.name = "ProgramWindowShadow"
		shadow.color = Color(0.0, 0.0, 0.0, 0.42)
		shadow.show_behind_parent = true
		shadow.mouse_filter = Control.MOUSE_FILTER_IGNORE
		window.add_child(shadow)
	shadow.position = Vector2(10.0, 12.0)
	shadow.size = window.size


func _add_modal_window_ornament(window: Control) -> void:
	if window == null:
		return
	var ornament := window.get_node_or_null("ModalWindowOrnament")
	if ornament != null and ornament is CanvasItem:
		(ornament as CanvasItem).visible = false
		if ornament is Control:
			(ornament as Control).mouse_filter = Control.MOUSE_FILTER_IGNORE


func _ensure_program_window_client_area(window: Control) -> void:
	var client: PanelContainer
	if window.has_node("ProgramClientArea") and window.get_node("ProgramClientArea") is PanelContainer:
		client = window.get_node("ProgramClientArea") as PanelContainer
	else:
		client = PanelContainer.new()
		client.name = "ProgramClientArea"
		client.mouse_filter = Control.MOUSE_FILTER_IGNORE
		client.add_theme_stylebox_override("panel", _overlay_style(Color("#21140c"), Color("#0d0805"), 2, 2))
		window.add_child(client)
		window.move_child(client, 0)
	client.position = Vector2(14.0, 56.0)
	client.size = window.size - Vector2(28.0, 72.0)


func _ensure_reference_modal_header_details(title_bar: Control) -> void:
	_ensure_header_burgundy_fill(title_bar)
	_ensure_header_left_pattern(title_bar, Vector2(6.0, 5.0), Vector2(88.0, 31.0))
	_ensure_header_side_slash(title_bar, "Panel_HeaderLeftGoldSlash", Vector2(96.0, 2.0), 1.0)
	_ensure_header_side_slash(title_bar, "Panel_HeaderRightGoldSlash", Vector2(title_bar.size.x - 56.0, 2.0), -1.0)
	_ensure_header_center_rivets(title_bar)


func _ensure_header_burgundy_fill(parent: Control) -> void:
	var existing := parent.get_node_or_null("Rect_HeaderBurgundyFill")
	var fill: ColorRect
	if existing != null and existing is ColorRect:
		fill = existing as ColorRect
	else:
		fill = ColorRect.new()
		fill.name = "Rect_HeaderBurgundyFill"
		fill.mouse_filter = Control.MOUSE_FILTER_IGNORE
		parent.add_child(fill)
	fill.color = Color("#5a191a")
	fill.position = Vector2(2.0, 2.0)
	fill.size = Vector2(maxf(1.0, parent.size.x - 4.0), maxf(1.0, parent.size.y - 4.0))
	fill.z_index = 0
	parent.move_child(fill, 0)


func _ensure_header_left_pattern(parent: Control, pos: Vector2, panel_size: Vector2) -> void:
	var existing := parent.get_node_or_null("Panel_HeaderLeftPattern")
	var panel: Panel
	if existing != null and existing is Panel:
		panel = existing as Panel
	else:
		panel = Panel.new()
		panel.name = "Panel_HeaderLeftPattern"
		panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
		parent.add_child(panel)
	panel.position = pos
	panel.size = panel_size
	panel.z_index = 1
	panel.add_theme_stylebox_override("panel", _overlay_style(Color("#160d0d"), Color("#2d1715"), 1, 0))
	for index in range(4):
		var line_name := "Line_HeaderHatch%d" % index
		var line := panel.get_node_or_null(line_name)
		var hatch: ColorRect
		if line != null and line is ColorRect:
			hatch = line as ColorRect
		else:
			hatch = ColorRect.new()
			hatch.name = line_name
			hatch.mouse_filter = Control.MOUSE_FILTER_IGNORE
			panel.add_child(hatch)
		hatch.color = Color("#491815")
		hatch.position = Vector2(12.0 + float(index) * 22.0, -8.0)
		hatch.size = Vector2(4.0, 50.0)
		hatch.rotation = -0.72
		hatch.z_index = 2


func _ensure_header_side_slash(parent: Control, node_name: String, pos: Vector2, direction: float) -> void:
	var existing := parent.get_node_or_null(node_name)
	var slash: ColorRect
	if existing != null and existing is ColorRect:
		slash = existing as ColorRect
	else:
		slash = ColorRect.new()
		slash.name = node_name
		slash.mouse_filter = Control.MOUSE_FILTER_IGNORE
		parent.add_child(slash)
	slash.color = Color("#c88a2f")
	slash.position = pos
	slash.size = Vector2(4.0, 36.0)
	slash.rotation = 0.54 * direction
	slash.z_index = 3


func _ensure_header_center_rivets(parent: Control) -> void:
	var group := parent.get_node_or_null("Panel_HeaderCenterRivets")
	var panel: Control
	if group != null and group is Control:
		panel = group as Control
	else:
		panel = Control.new()
		panel.name = "Panel_HeaderCenterRivets"
		panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
		parent.add_child(panel)
	panel.position = Vector2((parent.size.x - 78.0) * 0.5, -8.0)
	panel.size = Vector2(78.0, 18.0)
	panel.z_index = 4
	for index in range(5):
		var dot_name := "Panel_HeaderRivet%d" % index
		var dot := panel.get_node_or_null(dot_name)
		var rivet: PanelContainer
		if dot != null and dot is PanelContainer:
			rivet = dot as PanelContainer
		else:
			rivet = PanelContainer.new()
			rivet.name = dot_name
			rivet.mouse_filter = Control.MOUSE_FILTER_IGNORE
			panel.add_child(rivet)
		rivet.position = Vector2(float(index) * 16.0, 2.0 if index % 2 == 0 else 0.0)
		rivet.size = Vector2(14.0, 14.0)
		rivet.add_theme_stylebox_override("panel", _overlay_style(Color("#181310"), Color("#332822"), 2, 7))


func _connect_program_window_drag(title_bar: Control, window: Control) -> void:
	if title_bar.has_meta("program_drag_connected"):
		return
	title_bar.gui_input.connect(func(event: InputEvent):
		_handle_program_window_drag_input(event, window)
	)
	title_bar.set_meta("program_drag_connected", true)


func _handle_program_window_drag_input(event: InputEvent, window: Control) -> void:
	var native_window := _native_window_for_generated_control(window)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			generated_drag_window = window
			generated_drag_native_window = native_window
			generated_drag_start_mouse = _desktop_mouse_position() if native_window != null else get_global_mouse_position()
			generated_drag_start_position = Vector2(native_window.position) if native_window != null else window.position
			_focus_generated_window(window)
			get_viewport().set_input_as_handled()
		elif generated_drag_window == window:
			generated_drag_window = null
			generated_drag_native_window = null
			get_viewport().set_input_as_handled()
	elif event is InputEventMouseMotion and generated_drag_window == window:
		var current_mouse := _desktop_mouse_position() if generated_drag_native_window != null else get_global_mouse_position()
		var next_position := generated_drag_start_position + (current_mouse - generated_drag_start_mouse)
		if generated_drag_native_window != null:
			generated_drag_native_window.position = Vector2i(roundi(next_position.x), roundi(next_position.y))
		else:
			window.position = next_position
		get_viewport().set_input_as_handled()


func _prepare_generated_combat_strip_drag(root: Control) -> void:
	var combat_strip := root.get_node_or_null(OVERLAY_COMBAT_STRIP_PATH)
	if combat_strip == null or not combat_strip is Control:
		return
	var strip := combat_strip as Control
	strip.mouse_filter = Control.MOUSE_FILTER_STOP
	_set_generated_combat_strip_child_mouse_filters(strip)
	if strip.has_meta("combat_strip_drag_connected"):
		return
	strip.gui_input.connect(func(event: InputEvent):
		_handle_generated_combat_strip_drag_input(event, strip)
	)
	strip.set_meta("combat_strip_drag_connected", true)


func _set_generated_combat_strip_child_mouse_filters(node: Node) -> void:
	for child in node.get_children():
		if child is Control:
			var control := child as Control
			if control is Button:
				control.mouse_filter = Control.MOUSE_FILTER_STOP
			elif bool(control.get_meta("combat_resize_handle", false)):
				control.mouse_filter = Control.MOUSE_FILTER_STOP
			else:
				control.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_set_generated_combat_strip_child_mouse_filters(child)


func _handle_generated_combat_strip_drag_input(event: InputEvent, strip: Control) -> void:
	if strip == null or not strip.visible:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_button := event as InputEventMouseButton
		var mouse_position := _combat_strip_drag_mouse_position(event, strip)
		if mouse_button.pressed:
			if _generated_combat_strip_resize_handle_at_position(strip, _input_event_global_position(event)) != null:
				return
			if _generated_combat_strip_button_at_position(strip, _input_event_global_position(event)) != null:
				return
			_begin_generated_combat_strip_drag(strip, mouse_position)
		elif generated_combat_drag_strip == strip:
			_finish_generated_combat_strip_drag()
	elif event is InputEventMouseMotion and generated_combat_drag_strip == strip:
		_update_generated_combat_strip_drag(_combat_strip_drag_mouse_position(event, strip))


func _handle_generated_combat_strip_drag_global_input(event: InputEvent) -> bool:
	if generated_combat_drag_strip == null:
		return false
	if event is InputEventMouseMotion:
		_update_generated_combat_strip_drag(_combat_strip_drag_mouse_position(event, generated_combat_drag_strip))
		return true
	if event is InputEventMouseButton:
		var mouse_button := event as InputEventMouseButton
		if mouse_button.button_index == MOUSE_BUTTON_LEFT and not mouse_button.pressed:
			_finish_generated_combat_strip_drag()
			return true
	return false


func _begin_generated_combat_strip_drag(strip: Control, mouse_position: Vector2) -> void:
	generated_combat_drag_strip = strip
	generated_combat_drag_start_mouse = mouse_position
	var native := _native_window_for_generated_control(strip)
	generated_combat_drag_start_position = Vector2(native.position) if native != null else strip.position
	get_viewport().set_input_as_handled()


func _update_generated_combat_strip_drag(mouse_position: Vector2) -> void:
	if generated_combat_drag_strip == null:
		return
	var next_position := generated_combat_drag_start_position + (mouse_position - generated_combat_drag_start_mouse)
	var native := _native_window_for_generated_control(generated_combat_drag_strip)
	if native != null:
		native.position = Vector2i(roundi(next_position.x), roundi(next_position.y))
	else:
		generated_combat_drag_strip.position = next_position
	get_viewport().set_input_as_handled()


func _finish_generated_combat_strip_drag() -> void:
	generated_combat_drag_strip = null
	get_viewport().set_input_as_handled()


func _handle_generated_combat_strip_resize_input(event: InputEvent, strip: Control) -> void:
	if strip == null or not strip.visible:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_button := event as InputEventMouseButton
		var mouse_position := _combat_strip_resize_mouse_position(event, strip)
		if mouse_button.pressed:
			_begin_generated_combat_strip_resize(strip, mouse_position)
		elif generated_combat_resize_strip == strip:
			_finish_generated_combat_strip_resize()
	elif event is InputEventMouseMotion and generated_combat_resize_strip == strip:
		_update_generated_combat_strip_resize(_combat_strip_resize_mouse_position(event, strip))


func _handle_generated_combat_strip_resize_global_input(event: InputEvent) -> bool:
	if generated_combat_resize_strip == null:
		return false
	if event is InputEventMouseMotion:
		_update_generated_combat_strip_resize(_combat_strip_resize_mouse_position(event, generated_combat_resize_strip))
		return true
	if event is InputEventMouseButton:
		var mouse_button := event as InputEventMouseButton
		if mouse_button.button_index == MOUSE_BUTTON_LEFT and not mouse_button.pressed:
			_finish_generated_combat_strip_resize()
			return true
	return false


func _begin_generated_combat_strip_resize(strip: Control, mouse_position: Vector2) -> void:
	generated_combat_resize_strip = strip
	generated_combat_resize_start_mouse = mouse_position
	generated_combat_resize_start_scale = generated_combat_window_scale
	get_viewport().set_input_as_handled()


func _update_generated_combat_strip_resize(mouse_position: Vector2) -> void:
	if generated_combat_resize_strip == null:
		return
	var base_size := generated_combat_resize_strip.size
	if base_size.x <= 0.0 or base_size.y <= 0.0:
		return
	var start_visual_size := _combat_native_visual_size(base_size, generated_combat_resize_start_scale)
	var next_visual_size := start_visual_size + (mouse_position - generated_combat_resize_start_mouse)
	var next_scale := maxf(
		next_visual_size.x / maxf(1.0, base_size.x * COMBAT_NATIVE_WINDOW_WIDTH_RATIO),
		next_visual_size.y / base_size.y
	)
	_set_generated_combat_window_scale(next_scale, generated_combat_resize_strip)
	get_viewport().set_input_as_handled()


func _combat_native_visual_size(base_size: Vector2, scale: float) -> Vector2:
	return Vector2(base_size.x * scale * COMBAT_NATIVE_WINDOW_WIDTH_RATIO, base_size.y * scale)


func _finish_generated_combat_strip_resize() -> void:
	generated_combat_resize_strip = null
	get_viewport().set_input_as_handled()


func _set_generated_combat_window_scale(next_scale: float, strip: Control = null) -> void:
	generated_combat_window_scale = clampf(next_scale, COMBAT_NATIVE_WINDOW_MIN_SCALE, COMBAT_NATIVE_WINDOW_MAX_SCALE)
	if strip == null:
		strip = generated_native_window_roots.get("combat", null)
	if strip == null:
		strip = generated_runtime_nodes.get("combat_strip", null)
	if strip == null:
		return
	_apply_generated_combat_window_scale(strip)


func _apply_generated_combat_window_scale(strip: Control) -> void:
	var native := _native_window_for_generated_control(strip)
	if native != null:
		_set_native_window_size(native, _native_window_size_for("combat", strip.size))
		strip.scale = _native_window_scale_vector("combat")


func _update_active_native_drags() -> void:
	if DisplayServer.get_name() == "headless":
		return
	if generated_drag_native_window != null:
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			generated_drag_window = null
			generated_drag_native_window = null
		else:
			var next_position := generated_drag_start_position + (_desktop_mouse_position() - generated_drag_start_mouse)
			generated_drag_native_window.position = Vector2i(roundi(next_position.x), roundi(next_position.y))
	if generated_combat_drag_strip != null:
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			_finish_generated_combat_strip_drag()
		else:
			_update_generated_combat_strip_drag(_desktop_mouse_position())
	if generated_combat_resize_strip != null:
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			_finish_generated_combat_strip_resize()
		else:
			_update_generated_combat_strip_resize(_desktop_mouse_position())


func _input_event_global_position(event: InputEvent) -> Vector2:
	if event is InputEventMouse:
		return (event as InputEventMouse).global_position
	return get_global_mouse_position()


func _desktop_mouse_position() -> Vector2:
	if DisplayServer.get_name() == "headless":
		return get_global_mouse_position()
	return Vector2(DisplayServer.mouse_get_position())


func _combat_strip_drag_mouse_position(event: InputEvent, strip: Control) -> Vector2:
	if strip != null and _native_window_for_generated_control(strip) != null and DisplayServer.get_name() != "headless":
		return _desktop_mouse_position()
	return _input_event_global_position(event)


func _combat_strip_resize_mouse_position(event: InputEvent, strip: Control) -> Vector2:
	if strip != null and _native_window_for_generated_control(strip) != null and DisplayServer.get_name() != "headless":
		return _desktop_mouse_position()
	return _input_event_global_position(event)


func _generated_combat_strip_button_at_position(root: Control, mouse_position: Vector2) -> Button:
	for child in root.get_children():
		if child is Button and (child as Button).visible and (child as Button).get_global_rect().has_point(mouse_position):
			return child as Button
		if child is Control:
			var child_match := _generated_combat_strip_button_at_position(child as Control, mouse_position)
			if child_match != null:
				return child_match
	return null


func _generated_combat_strip_resize_handle_at_position(root: Control, mouse_position: Vector2) -> Control:
	for child in root.get_children():
		if child is Control:
			var control := child as Control
			if bool(control.get_meta("combat_resize_handle", false)) and control.visible and control.get_global_rect().has_point(mouse_position):
				return control
			var child_match := _generated_combat_strip_resize_handle_at_position(control, mouse_position)
			if child_match != null:
				return child_match
	return null


func _focus_generated_window(window: Control) -> void:
	if window == null or window.get_parent() == null:
		return
	var window_id := _desktop_window_id_for_control(window)
	if window_id != "" and _ensure_desktop_window_registered(window_id):
		desktop_window_manager.focus_window(window_id)
		return
	var native := _native_window_for_generated_control(window)
	if native != null:
		native.grab_focus()
		return
	window.get_parent().move_child(window, window.get_parent().get_child_count() - 1)


func _native_window_for_generated_control(control: Control) -> Window:
	var current: Node = control
	while current != null:
		for window_id in generated_native_window_roots.keys():
			var root: Control = generated_native_window_roots.get(window_id, null)
			if root != null and current == root:
				return generated_native_windows.get(window_id, null)
		current = current.get_parent()
	return null


func _add_program_window_icon(window: Control, icon_path: String) -> void:
	var icon_back := window.get_node_or_null("ProgramWindowIcon")
	if icon_back != null and icon_back is CanvasItem:
		(icon_back as CanvasItem).visible = false
		if icon_back is Control:
			(icon_back as Control).mouse_filter = Control.MOUSE_FILTER_IGNORE


func _program_window_icon_texture(texture: Texture2D, icon_path: String) -> Texture2D:
	if icon_path.ends_with("stone_keeper_sheet.png"):
		var atlas := AtlasTexture.new()
		atlas.atlas = texture
		atlas.region = Rect2(Vector2.ZERO, Vector2(48.0, 48.0))
		return atlas
	return texture


func _hide_program_window_minimize(window: Control) -> void:
	var button := _find_program_window_minimize_button(window)
	if button == null:
		return
	button.text = ""
	button.visible = false
	button.disabled = true
	button.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _find_program_window_minimize_button(window: Control) -> Button:
	for child in window.get_children():
		if child is Button and str(child.name).ends_with("Minimize"):
			return child as Button
	return null


func _close_generated_window(window_id: String, window: Control) -> void:
	if window == null:
		return
	var canonical := _normalize_desktop_window_id(window_id)
	if canonical == "":
		canonical = _desktop_window_id_for_control(window)
	if canonical != "" and _ensure_desktop_window_registered(canonical):
		desktop_window_manager.hide_window(canonical)
	else:
		window.visible = false
		var native := _native_window_for_generated_control(window)
		if native != null:
			native.visible = false
	generated_action_message = "%s 창 닫힘 - combat strip은 계속 실행" % _generated_window_label(canonical)
	_refresh_generated_overlay_now()


func _desktop_window_id_for_control(control: Control) -> String:
	if control == null:
		return ""
	if control.has_meta("desktop_window_id"):
		return str(control.get_meta("desktop_window_id", ""))
	if control.has_meta("program_window_id"):
		return _normalize_desktop_window_id(str(control.get_meta("program_window_id", "")))
	for window_id in generated_native_window_roots.keys():
		var root: Control = generated_native_window_roots.get(window_id, null)
		if root != null and root == control:
			return str(window_id)
	var name := str(control.name)
	if name == RUNTIME_SKILL_TREE_WINDOW_NAME:
		return "skill_tree"
	if name == "Panel_StatusWindowFrame":
		return "status"
	if name == "Panel_HeroInventoryWindowFrame":
		return "keeper"
	if name == "Panel_PortalWindowFrame":
		return "portal"
	if name == "Section_BottomCombatStrip":
		return "combat"
	return ""


func _generated_window_label(window_id: String) -> String:
	match window_id:
		"status":
			return "스테이터스"
		"keeper":
			return "돌지기"
		"portal":
			return "포탈"
		"combat":
			return "전투 스트립"
		"skill_tree":
			return "스킬 트리"
	return "작업창"


func _populate_generated_slot_grid(root: Control, node_path: String, target_count: int, columns: int, slot_size: float, gap: float) -> void:
	var grid := root.get_node_or_null(node_path)
	if grid == null or not grid is GridContainer:
		return
	var slot_grid := grid as GridContainer
	slot_grid.columns = columns
	slot_grid.add_theme_constant_override("h_separation", int(gap))
	slot_grid.add_theme_constant_override("v_separation", int(gap))
	var prototype: Control = null
	for child in slot_grid.get_children():
		if child is Control:
			prototype = child
			break
	if prototype == null:
		prototype = _make_generated_slot("Panel_SlotPrototype", slot_size)
		slot_grid.add_child(prototype)
	_set_generated_slot_size(prototype, slot_size)
	while slot_grid.get_child_count() < target_count:
		var duplicate := prototype.duplicate()
		duplicate.name = "Panel_Slot%02d" % (slot_grid.get_child_count() + 1)
		slot_grid.add_child(duplicate)
	for child in slot_grid.get_children():
		if child is Control:
			_set_generated_slot_size(child, slot_size)


func _make_generated_slot(node_name: String, slot_size: float) -> NinePatchRect:
	var slot := NinePatchRect.new()
	slot.name = node_name
	slot.texture = _generated_texture("res://assets/generated/ui/slot_frame_9slice.png")
	slot.patch_margin_left = 18
	slot.patch_margin_right = 18
	slot.patch_margin_top = 18
	slot.patch_margin_bottom = 18
	slot.mouse_filter = Control.MOUSE_FILTER_PASS
	_set_generated_slot_size(slot, slot_size)
	return slot


func _set_generated_slot_size(control: Control, slot_size: float) -> void:
	control.custom_minimum_size = Vector2(slot_size, slot_size)
	control.size = Vector2(slot_size, slot_size)


func _set_generated_button_text(root: Control, node_path: String, text: String) -> void:
	var button := root.get_node_or_null(node_path)
	if button != null and button is Button:
		(button as Button).text = text


func _set_generated_button_text_by_path(node_path: String, text: String) -> void:
	var button := _generated_node_or_null(node_path)
	if button != null and button is Button:
		(button as Button).text = text


func _connect_generated_overlay_buttons(root: Control) -> void:
	_connect_generated_button(root, OVERLAY_STONE_TAB_PATH, func():
		_set_generated_inventory_tab("stone")
	)
	_connect_generated_button(root, OVERLAY_EQUIPMENT_TAB_PATH, func():
		_set_generated_inventory_tab("equipment")
	)
	_connect_generated_button(root, "Section_WindowStack/Panel_HeroInventoryWindowFrame/Dock_KeeperIconDock/Btn_DockInventory", func():
		_set_generated_action("inventory")
	)
	_connect_generated_button(root, "Section_WindowStack/Panel_HeroInventoryWindowFrame/Dock_KeeperIconDock/Btn_DockGrowth", func():
		_set_generated_action("feed")
	)
	_connect_generated_button(root, "Section_WindowStack/Panel_HeroInventoryWindowFrame/Dock_KeeperIconDock/Btn_DockFormation", func():
		_set_generated_action("skill")
	)
	_connect_generated_button(root, "Section_WindowStack/Panel_HeroInventoryWindowFrame/Dock_KeeperIconDock/Btn_DockStorage", func():
		_set_generated_action("merge")
	)
	_connect_generated_button(root, "Section_WindowStack/Panel_HeroInventoryWindowFrame/Dock_KeeperIconDock/Btn_DockSteamAssets", func():
		_set_generated_action("steam")
	)
	_connect_generated_button(root, "Section_WindowStack/Panel_PortalWindowFrame/Btn_CurrentStageNode", func():
		_set_generated_action("portal")
	)
	_connect_generated_button(root, "Section_WindowStack/Panel_StatusWindowFrame/Panel_StatusStatScroll/Btn_StatusSearch", func():
		_set_generated_action("skill")
	)
	_ensure_keeper_dock_icons(root)


func _set_generated_button_tooltip(root: Control, node_path: String, tooltip: String) -> void:
	var button := root.get_node_or_null(node_path)
	if button != null and button is Button:
		(button as Button).tooltip_text = tooltip


func _ensure_keeper_dock_icons(root: Control) -> void:
	for spec in KEEPER_DOCK_ICON_SPECS:
		var button := root.get_node_or_null(str(spec.get("path", "")))
		if button == null or not button is Button:
			continue
		var dock_button := button as Button
		dock_button.text = ""
		dock_button.tooltip_text = str(spec.get("tooltip", ""))
		var icon := dock_button.get_node_or_null(str(spec.get("node", "Icon_Dock")))
		if icon == null:
			icon = TextureRect.new()
			icon.name = str(spec.get("node", "Icon_Dock"))
			icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
			dock_button.add_child(icon)
		if icon is TextureRect:
			var icon_rect := icon as TextureRect
			icon_rect.texture = _keeper_dock_icon_texture(int(spec.get("index", 0)))
			icon_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			icon_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			icon_rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			icon_rect.anchor_left = 0.5
			icon_rect.anchor_top = 0.5
			icon_rect.anchor_right = 0.5
			icon_rect.anchor_bottom = 0.5
			icon_rect.offset_left = -KEEPER_DOCK_ICON_DISPLAY_SIZE.x * 0.5
			icon_rect.offset_top = -KEEPER_DOCK_ICON_DISPLAY_SIZE.y * 0.5
			icon_rect.offset_right = KEEPER_DOCK_ICON_DISPLAY_SIZE.x * 0.5
			icon_rect.offset_bottom = KEEPER_DOCK_ICON_DISPLAY_SIZE.y * 0.5


func _keeper_dock_icon_texture(index: int) -> Texture2D:
	var atlas_texture := _generated_texture(GENERATED_KEEPER_DOCK_ICON_SET_PATH)
	if atlas_texture == null:
		return null
	var icon := AtlasTexture.new()
	icon.atlas = atlas_texture
	icon.region = Rect2(Vector2(KEEPER_DOCK_ICON_SIZE.x * float(index), 0.0), KEEPER_DOCK_ICON_SIZE)
	return icon


func _connect_generated_button(root: Control, node_path: String, callback: Callable) -> void:
	var button := root.get_node_or_null(node_path)
	if button == null or not button is Button:
		return
	if button.has_meta("runtime_connected"):
		return
	(button as Button).pressed.connect(callback)
	button.set_meta("runtime_connected", true)


func _set_generated_inventory_tab(tab: String) -> void:
	generated_inventory_tab = tab
	generated_selected_action = "equipment" if tab == "equipment" else "inventory"
	if tab == "equipment":
		generated_action_message = "장비 보관함: 데굴 투석구 승급 재료를 확인 중"
	else:
		generated_action_message = _progression_stone_loadout_message()
	_refresh_generated_overlay_now()


func _set_generated_action(action: String) -> void:
	generated_selected_action = action
	if action == "feed":
		generated_inventory_tab = "stone"
		generated_action_message = _progression_equip_best_stones()
	elif action == "merge":
		generated_inventory_tab = "stone"
		generated_action_message = "돌 합성 모드: 같은 돌을 다른 같은 돌 위에 드래그하면 3개가 머지됩니다"
	elif action == "skill":
		generated_action_message = _runtime_skill_tree_preview_message()
		_open_runtime_skill_tree_window()
	elif action == "equipment":
		generated_inventory_tab = "equipment"
		generated_action_message = "장비: 데굴 투석구 승급 재료 확인"
	elif action == "upgrade":
		generated_inventory_tab = "equipment"
		generated_action_message = "장비 승급: 같은 부위/등급 장비 3개를 확인 중"
		_open_equipment_upgrade_modal()
	elif action == "steam":
		generated_action_message = "Steam 자산: local_sandbox에서는 외부 거래 비활성"
	elif action == "sync":
		generated_action_message = "Steam Inventory 새로고침 요청됨"
	elif action == "portal":
		generated_action_message = "포탈: 현재 스테이지 자동 진행 중"
	else:
		generated_action_message = "인벤토리: 전투 드롭을 먹이기/합성/승급에 사용"
	_refresh_generated_overlay_now()


func _refresh_generated_overlay_now() -> void:
	if generated_ui_overlay == null or sim == null:
		return
	_sync_generated_ui_overlay(sim.snapshot())


func _ensure_generated_action_bar(root: Control) -> void:
	var hero_window := root.get_node_or_null(OVERLAY_HERO_WINDOW_PATH)
	if hero_window == null or not hero_window is Control:
		return
	var hero := hero_window as Control
	var existing_bar := hero.get_node_or_null(OVERLAY_ACTION_BAR_NAME)
	if existing_bar != null:
		existing_bar.queue_free()
	generated_runtime_nodes.erase("action_bar")

	var existing_status := hero.get_node_or_null(OVERLAY_ACTION_STATUS_NAME)
	var status: Label
	if existing_status != null and existing_status is Label:
		status = existing_status as Label
	else:
		if existing_status != null:
			existing_status.queue_free()
		status = Label.new()
		status.name = OVERLAY_ACTION_STATUS_NAME
		hero.add_child(status)
	status.position = Vector2(42.0, 545.0)
	status.size = Vector2(468.0, 18.0)
	status.add_theme_font_size_override("font_size", 12)
	status.add_theme_color_override("font_color", Color("#f3e6c8"))
	status.add_theme_color_override("font_shadow_color", Color("#050302"))
	status.add_theme_constant_override("shadow_offset_x", 1)
	status.add_theme_constant_override("shadow_offset_y", 1)
	status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	status.visible = false
	generated_runtime_nodes["action_status"] = status


func _ensure_generated_action_button(parent: HBoxContainer, node_name: String, text: String, action: String, min_size: Vector2) -> void:
	var button := Button.new()
	button.name = node_name
	button.text = text
	button.custom_minimum_size = min_size
	button.size = min_size
	button.set_meta("button_role", "inventory_tab")
	button.pressed.connect(func():
		_set_generated_action(action)
	)
	_apply_generated_button_style(button, "inventory_tab")
	parent.add_child(button)


func _ensure_generated_combat_layer(root: Control) -> void:
	var combat_strip := root.get_node_or_null(OVERLAY_COMBAT_STRIP_PATH)
	if combat_strip == null or not combat_strip is Control:
		return
	var prop_layer := (combat_strip as Control).get_node_or_null(OVERLAY_COMBAT_PROP_LAYER_NAME)
	if prop_layer == null:
		prop_layer = Control.new()
		prop_layer.name = OVERLAY_COMBAT_PROP_LAYER_NAME
		prop_layer.position = Vector2.ZERO
		prop_layer.size = Vector2(1586.0, 236.0)
		prop_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
		(combat_strip as Control).add_child(prop_layer)
	prop_layer.z_index = 6
	(prop_layer as CanvasItem).z_as_relative = false
	generated_runtime_nodes["combat_prop_layer"] = prop_layer
	var enemy_layer := (combat_strip as Control).get_node_or_null(OVERLAY_ENEMY_LAYER_NAME)
	if enemy_layer == null:
		enemy_layer = Control.new()
		enemy_layer.name = OVERLAY_ENEMY_LAYER_NAME
		enemy_layer.position = Vector2.ZERO
		enemy_layer.size = Vector2(1586.0, 236.0)
		enemy_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
		(combat_strip as Control).add_child(enemy_layer)
	enemy_layer.z_index = 132
	(enemy_layer as CanvasItem).z_as_relative = false
	generated_runtime_nodes["combat_enemy_layer"] = enemy_layer
	var baked_projectile := (combat_strip as Control).get_node_or_null("Layer_Projectile")
	if baked_projectile != null and baked_projectile is CanvasItem:
		(baked_projectile as CanvasItem).visible = false
	var layer := (combat_strip as Control).get_node_or_null(OVERLAY_COMBAT_LAYER_NAME)
	if layer == null:
		layer = Control.new()
		layer.name = OVERLAY_COMBAT_LAYER_NAME
		layer.position = Vector2.ZERO
		layer.size = Vector2(1586.0, 236.0)
		layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
		layer.z_index = 20
		(combat_strip as Control).add_child(layer)
	generated_runtime_nodes["combat_layer"] = layer
	(combat_strip as Control).move_child(enemy_layer, (combat_strip as Control).get_child_count() - 1)


func _ensure_generated_combat_soft_border(root: Control) -> void:
	var combat_strip := root.get_node_or_null(OVERLAY_COMBAT_STRIP_PATH)
	if combat_strip == null or not combat_strip is Control:
		return
	var strip := combat_strip as Control
	_ensure_combat_border_rect(strip, "Rect_CombatTopEdgeShadow", Vector2(0.0, 0.0), Vector2(1586.0, 3.0), Color(0.0, 0.0, 0.0, 0.30), 5)
	_ensure_combat_border_rect(strip, "Rect_CombatTopEdgeWarmLine", Vector2(0.0, 3.0), Vector2(1586.0, 1.0), Color(1.0, 0.80, 0.42, 0.18), 5)
	_ensure_combat_border_rect(strip, "Rect_CombatTopEdgeSoftLight", Vector2(0.0, 4.0), Vector2(1586.0, 2.0), Color(1.0, 1.0, 1.0, 0.06), 5)
	_ensure_combat_border_rect(strip, "Rect_CombatBottomEdgeShadow", Vector2(0.0, 230.0), Vector2(1586.0, 6.0), Color(0.0, 0.0, 0.0, 0.28), 5)
	_ensure_combat_border_rect(strip, "Rect_CombatBottomEdgeWarmLine", Vector2(0.0, 229.0), Vector2(1586.0, 1.0), Color(0.95, 0.62, 0.27, 0.12), 5)
	_ensure_combat_border_rect(strip, "Rect_CombatLeftEdgeSoftShadow", Vector2(0.0, 0.0), Vector2(4.0, 236.0), Color(0.0, 0.0, 0.0, 0.22), 5)
	_ensure_combat_border_rect(strip, "Rect_CombatLeftEdgeWarmLine", Vector2(4.0, 0.0), Vector2(1.0, 236.0), Color(1.0, 0.78, 0.42, 0.10), 5)
	_ensure_combat_border_rect(strip, "Rect_CombatRightEdgeSoftShadow", Vector2(1582.0, 0.0), Vector2(4.0, 236.0), Color(0.0, 0.0, 0.0, 0.22), 5)
	_ensure_combat_border_rect(strip, "Rect_CombatRightEdgeWarmLine", Vector2(1581.0, 0.0), Vector2(1.0, 236.0), Color(1.0, 0.78, 0.42, 0.10), 5)


func _ensure_combat_border_rect(parent: Control, node_name: String, pos: Vector2, rect_size: Vector2, color: Color, z: int) -> ColorRect:
	var existing := parent.get_node_or_null(node_name)
	var rect: ColorRect
	if existing != null and existing is ColorRect:
		rect = existing as ColorRect
	else:
		if existing != null:
			parent.remove_child(existing)
			existing.queue_free()
		rect = ColorRect.new()
		rect.name = node_name
		rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		parent.add_child(rect)
	rect.position = pos
	rect.size = rect_size
	rect.color = color
	rect.z_index = z
	rect.z_as_relative = false
	return rect


func _ensure_generated_combat_readouts(root: Control) -> void:
	var combat_strip := root.get_node_or_null(OVERLAY_COMBAT_STRIP_PATH)
	if combat_strip == null or not combat_strip is Control:
		return
	var strip := combat_strip as Control
	generated_runtime_nodes["combat_strip"] = strip
	_remove_generated_combat_data_panels(strip)
	_ensure_combat_boss_panel(strip)
	_ensure_combat_map_progress_panel(strip)
	generated_runtime_nodes["combat_player_hp_plate"] = _ensure_combat_hp_plate(strip, "Panel_RuntimePlayerHpPlate")
	generated_runtime_nodes["combat_player_hp_bar"] = _ensure_combat_progress(
		strip,
		"Progress_RuntimePlayerHp",
		Vector2(306.0, 24.0),
		Vector2(154.0, 12.0),
		Color("#d85745")
	)
	generated_runtime_nodes["combat_player_hp_text"] = _ensure_combat_label(
		strip,
		"Text_RuntimePlayerHp",
		Vector2(300.0, 4.0),
		Vector2(166.0, 20.0),
		12,
		Color("#f3e6c8")
	)
	generated_runtime_nodes["combat_enemy_hp_plate"] = _ensure_combat_hp_plate(strip, "Panel_RuntimeEnemyHpPlate")
	var enemy_hp := strip.get_node_or_null("Progress_EnemyHp")
	if enemy_hp != null and enemy_hp is ProgressBar:
		generated_runtime_nodes["combat_enemy_hp_bar"] = enemy_hp
		_style_combat_hp_bar(enemy_hp as ProgressBar, Color("#d85745"), 0.0)
	var enemy_name := strip.get_node_or_null("Text_EnemyName")
	if enemy_name != null and enemy_name is Label:
		generated_runtime_nodes["combat_enemy_name"] = enemy_name
		_style_combat_hp_label(enemy_name as Label, 10, HORIZONTAL_ALIGNMENT_LEFT)
	var enemy_hp_text := strip.get_node_or_null("Text_EnemyHpValue")
	if enemy_hp_text != null and enemy_hp_text is Label:
		generated_runtime_nodes["combat_enemy_hp_text"] = enemy_hp_text
		_style_combat_hp_label(enemy_hp_text as Label, 10, HORIZONTAL_ALIGNMENT_RIGHT)


func _ensure_combat_drop_banner(parent: Control) -> void:
	var banner := _ensure_panel(parent, OVERLAY_COMBAT_DROP_BANNER_NAME, Vector2(430.0, 6.0), Vector2(600.0, 42.0), Color("#180b06"), Color("#3a1d12"), 3, 5)
	banner.z_index = 95
	generated_runtime_nodes["combat_drop_banner"] = banner
	for old_child_name in ["Text_DropBannerTitle", "Text_DropBannerBody", "Text_DropBannerIcon"]:
		var old_child := banner.get_node_or_null(old_child_name)
		if old_child != null and old_child is CanvasItem:
			(old_child as CanvasItem).visible = false
	var title := _ensure_runtime_label("Text_RuntimeDropBannerTitle", Vector2(448.0, 13.0), Vector2(124.0, 24.0), 18, Color("#f3e6c8"), parent)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	title.add_theme_color_override("font_outline_color", Color("#050302"))
	title.add_theme_constant_override("outline_size", 4)
	title.z_index = 96
	generated_runtime_nodes["combat_drop_banner_title"] = title
	var body := _ensure_runtime_label("Text_RuntimeDropBannerBody", Vector2(580.0, 13.0), Vector2(340.0, 24.0), 18, Color("#4691ff"), parent)
	body.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	body.add_theme_color_override("font_outline_color", Color("#050302"))
	body.add_theme_constant_override("outline_size", 4)
	body.z_index = 96
	generated_runtime_nodes["combat_drop_banner_body"] = body
	var icon := _ensure_runtime_label("Text_RuntimeDropBannerIcon", Vector2(952.0, -1.0), Vector2(52.0, 52.0), 30, Color("#d8d9dc"), parent)
	icon.text = "◆"
	icon.add_theme_color_override("font_outline_color", Color("#050302"))
	icon.add_theme_constant_override("outline_size", 5)
	icon.z_index = 97
	generated_runtime_nodes["combat_drop_banner_icon"] = icon


func _ensure_combat_skill_panel(parent: Control) -> void:
	var panel := _ensure_panel(parent, OVERLAY_COMBAT_SKILL_PANEL_NAME, Vector2(1178.0, 58.0), Vector2(84.0, 112.0), Color("#17110e"), Color("#453121"), 3, 4)
	panel.z_index = 85
	generated_runtime_nodes["combat_skill_panel"] = panel
	var orb := _ensure_runtime_label("Text_SkillOrb", Vector2(10.0, 8.0), Vector2(50.0, 50.0), 32, Color("#65d7ff"), panel)
	orb.text = "●"
	orb.add_theme_color_override("font_outline_color", Color("#050302"))
	orb.add_theme_constant_override("outline_size", 5)
	var label := _ensure_runtime_label("Text_SkillPanelLabel", Vector2(12.0, 56.0), Vector2(58.0, 20.0), 10, Color("#ffcf7a"), panel)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	generated_runtime_nodes["combat_skill_label"] = label
	var bar := _ensure_combat_progress(panel, "Progress_SkillCooldown", Vector2(12.0, 86.0), Vector2(58.0, 8.0), Color("#a45cff"))
	bar.z_index = 3
	generated_runtime_nodes["combat_skill_cooldown"] = bar


func _ensure_combat_boss_panel(parent: Control) -> void:
	var panel := _ensure_panel(parent, OVERLAY_COMBAT_BOSS_PANEL_NAME, Vector2(1182.0, 28.0), Vector2(112.0, 150.0), Color("#18100c"), Color("#4a3020"), 3, 4)
	panel.z_index = 82
	generated_runtime_nodes["combat_boss_panel"] = panel
	var label := _ensure_runtime_label("Text_BossPanelLabel", Vector2(10.0, 14.0), Vector2(92.0, 24.0), 13, Color("#ffcf7a"), panel)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	generated_runtime_nodes["combat_boss_label"] = label
	var skull := _ensure_runtime_label("Text_BossPanelIcon", Vector2(22.0, 36.0), Vector2(68.0, 68.0), 42, Color("#d6d2c8"), panel)
	skull.text = "◆"
	skull.add_theme_color_override("font_outline_color", Color("#050302"))
	skull.add_theme_constant_override("outline_size", 5)
	var bar := _ensure_combat_progress(panel, "Progress_BossHp", Vector2(18.0, 118.0), Vector2(76.0, 10.0), Color("#d85745"))
	bar.z_index = 3
	generated_runtime_nodes["combat_boss_bar"] = bar


func _ensure_combat_map_progress_panel(parent: Control) -> void:
	var panel := parent.get_node_or_null(OVERLAY_COMBAT_MAP_PROGRESS_NAME)
	var root: Control
	if panel != null and panel is Control:
		root = panel as Control
	else:
		root = Control.new()
		root.name = OVERLAY_COMBAT_MAP_PROGRESS_NAME
		root.mouse_filter = Control.MOUSE_FILTER_IGNORE
		parent.add_child(root)
	root.position = Vector2(1074.0, 144.5)
	root.size = Vector2(264.0, 114.0)
	root.scale = Vector2.ONE * 0.75
	root.z_index = 94
	generated_runtime_nodes["combat_map_progress"] = root
	for child in root.get_children():
		root.remove_child(child)
		child.queue_free()

	var frame := _ensure_panel(root, "Panel_MapProgressFrame", Vector2(0.0, 10.0), Vector2(264.0, 96.0), Color("#080908"), Color("#272625"), 2, 3)
	frame.z_index = 1
	_ensure_combat_map_progress_top(root)

	var mini_tile := _ensure_panel(root, "Panel_MapProgressMiniTile", Vector2(16.0, 82.0), Vector2(31.0, 22.0), Color("#17110c"), Color("#6b4a2a"), 2, 3)
	mini_tile.z_index = 8
	var mini_lid := ColorRect.new()
	mini_lid.name = "Rect_MapProgressMiniLid"
	mini_lid.mouse_filter = Control.MOUSE_FILTER_IGNORE
	mini_lid.position = Vector2(22.0, 87.0)
	mini_lid.size = Vector2(19.0, 4.0)
	mini_lid.color = Color("#c3914c")
	mini_lid.z_index = 9
	root.add_child(mini_lid)
	var mini_body := _ensure_panel(root, "Panel_MapProgressMiniChestBody", Vector2(21.0, 90.0), Vector2(21.0, 10.0), Color("#3c3024"), Color("#967040"), 1, 1)
	mini_body.z_index = 9
	var mini_lock := ColorRect.new()
	mini_lock.name = "Rect_MapProgressMiniLock"
	mini_lock.mouse_filter = Control.MOUSE_FILTER_IGNORE
	mini_lock.position = Vector2(30.0, 92.0)
	mini_lock.size = Vector2(4.0, 5.0)
	mini_lock.color = Color("#e2ba67")
	mini_lock.z_index = 10
	root.add_child(mini_lock)

	var progress_back := _ensure_panel(root, "Panel_MapProgressTrackBack", Vector2(48.0, 80.0), Vector2(206.0, 16.0), Color("#211b24"), Color("#9b6122"), 2, 3)
	progress_back.z_index = 6
	var left_cap := _ensure_panel(root, "Panel_MapProgressTrackCapLeft", Vector2(47.0, 79.0), Vector2(12.0, 18.0), Color("#b97422"), Color("#2d1909"), 1, 2)
	left_cap.z_index = 7
	var right_cap := _ensure_panel(root, "Panel_MapProgressTrackCapRight", Vector2(242.0, 79.0), Vector2(12.0, 18.0), Color("#c78324"), Color("#2d1909"), 1, 2)
	right_cap.z_index = 7
	var progress := _ensure_combat_progress(root, "Progress_MapProgress", Vector2(61.0, 84.0), Vector2(178.0, 8.0), Color("#a14dff"))
	progress.z_index = 8
	generated_runtime_nodes["combat_map_progress_bar"] = progress
	var track_highlight := ColorRect.new()
	track_highlight.name = "Rect_MapProgressTrackHighlight"
	track_highlight.mouse_filter = Control.MOUSE_FILTER_IGNORE
	track_highlight.position = Vector2(63.0, 85.0)
	track_highlight.size = Vector2(174.0, 2.0)
	track_highlight.color = Color(1.0, 1.0, 1.0, 0.12)
	track_highlight.z_index = 9
	root.add_child(track_highlight)
	var pointer := _ensure_runtime_label("Text_MapProgressPointer", Vector2(51.0, 66.0), Vector2(20.0, 18.0), 15, Color("#f3e6c8"), root)
	pointer.text = "▲"
	pointer.add_theme_color_override("font_outline_color", Color("#050302"))
	pointer.add_theme_constant_override("outline_size", 2)
	pointer.z_index = 10
	generated_runtime_nodes["combat_map_progress_pointer"] = pointer

	var tick_back := _ensure_panel(root, "Panel_MapProgressTickBack", Vector2(60.0, 97.0), Vector2(184.0, 9.0), Color("#050403"), Color("#15100c"), 1, 1)
	tick_back.z_index = 5
	for index in range(10):
		var tick_name := "Rect_MapProgressTick%d" % index
		var existing := root.get_node_or_null(tick_name)
		var tick: ColorRect
		if existing != null and existing is ColorRect:
			tick = existing as ColorRect
		else:
			tick = ColorRect.new()
			tick.name = tick_name
			tick.mouse_filter = Control.MOUSE_FILTER_IGNORE
			root.add_child(tick)
		tick.position = Vector2(72.0 + float(index) * 15.0, 99.0)
		tick.size = Vector2(5.0, 5.0)
		tick.color = Color("#1b1b1c")
		tick.z_index = 7


func _ensure_combat_map_progress_top(root: Control) -> void:
	root.set_meta("map_progress_route_overlay_subtle", false)
	root.set_meta("map_progress_portal_atom_crop", false)
	var top_shell := _ensure_panel(root, "Panel_MapProgressTopShell", Vector2(6.0, 6.0), Vector2(252.0, 74.0), Color("#11110f"), Color("#383532"), 2, 4)
	top_shell.z_index = 2
	var top_rail := _ensure_panel(root, "Panel_MapProgressTopRail", Vector2(64.0, 12.0), Vector2(128.0, 8.0), Color("#20201f"), Color("#090807"), 1, 1)
	top_rail.z_index = 3
	var top_shine := _ensure_map_progress_rect(root, "Rect_MapProgressTopRailShine", Vector2(67.0, 13.0), Vector2(122.0, 2.0), Color(1.0, 1.0, 1.0, 0.08), 4)
	top_shine.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var portal_atom_texture := _generated_texture("res://assets/generated/ui/combat_map_progress_portal_atom.png")
	var route_atom_texture := _generated_texture("res://assets/generated/ui/combat_map_progress_route_silhouette.png")
	var next_atom_texture := _generated_texture("res://assets/generated/ui/combat_map_progress_next_marker.png")
	if portal_atom_texture != null and route_atom_texture != null and next_atom_texture != null:
		root.set_meta("map_progress_route_overlay_subtle", true)
		root.set_meta("map_progress_portal_atom_crop", true)
		var portal_atom := _ensure_texture_rect(root, "Tex_MapProgressPortal", Vector2(8.0, 2.0), Vector2(82.0, 78.0), portal_atom_texture, 8)
		portal_atom.modulate = Color(1.04, 1.04, 1.04, 1.0)
		var route_atom := _ensure_texture_rect(root, "Tex_MapProgressRouteSilhouette", Vector2(84.0, 18.0), Vector2(116.0, 54.0), route_atom_texture, 7)
		route_atom.modulate = Color(1.02, 1.0, 0.96, 1.0)
		var next_atom := _ensure_texture_rect(root, "Tex_MapProgressNextNodeMarker", Vector2(199.0, 2.0), Vector2(59.0, 78.0), next_atom_texture, 8)
		next_atom.modulate = Color(1.04, 1.02, 0.98, 1.0)
		_ensure_combat_map_progress_route_state_overlay(root, true)
		return

	var portal_socket := _ensure_panel(root, "Panel_MapProgressPortalSocket", Vector2(15.0, 12.0), Vector2(67.0, 62.0), Color("#0b1010"), Color("#2e342f"), 2, 5)
	portal_socket.z_index = 4
	var portal_glow := _ensure_texture_rect(root, "Tex_MapProgressPortalGlow", Vector2(19.0, 14.0), Vector2(59.0, 59.0), _combat_map_progress_orb_texture(), 5)
	portal_glow.modulate = Color(0.32, 0.85, 1.0, 0.28)
	var portal := _ensure_texture_rect(root, "Tex_MapProgressPortal", Vector2(22.0, 17.0), Vector2(53.0, 53.0), _combat_map_progress_orb_texture(), 8)
	portal.modulate = Color(1.1, 1.1, 1.08, 1.0)
	portal.pivot_offset = portal.size * 0.5
	_ensure_map_progress_rect(root, "Rect_MapProgressPortalTopGem", Vector2(46.0, 4.0), Vector2(7.0, 9.0), Color("#56d8ff"), 10)
	_ensure_map_progress_rect(root, "Rect_MapProgressPortalLeftMoss", Vector2(8.0, 55.0), Vector2(13.0, 15.0), Color("#405328"), 6)
	_ensure_map_progress_rect(root, "Rect_MapProgressPortalRightMoss", Vector2(74.0, 55.0), Vector2(12.0, 14.0), Color("#475b2d"), 6)
	_ensure_map_progress_rect(root, "Rect_MapProgressPortalLeftFoot", Vector2(20.0, 68.0), Vector2(14.0, 4.0), Color("#c79237"), 10)
	_ensure_map_progress_rect(root, "Rect_MapProgressPortalRightFoot", Vector2(61.0, 68.0), Vector2(14.0, 4.0), Color("#c79237"), 10)

	var route_slab := _ensure_panel(root, "Panel_MapProgressRouteSlab", Vector2(86.0, 21.0), Vector2(110.0, 48.0), Color("#4b4035"), Color("#191514"), 2, 5)
	route_slab.z_index = 4
	_ensure_map_progress_rect(root, "Rect_MapProgressRockShard0", Vector2(93.0, 26.0), Vector2(25.0, 36.0), Color("#5d513f"), 5)
	_ensure_map_progress_rect(root, "Rect_MapProgressRockShard1", Vector2(119.0, 23.0), Vector2(28.0, 41.0), Color("#3f382f"), 5)
	_ensure_map_progress_rect(root, "Rect_MapProgressRockShard2", Vector2(148.0, 27.0), Vector2(21.0, 36.0), Color("#665641"), 5)
	_ensure_map_progress_rect(root, "Rect_MapProgressRockShard3", Vector2(170.0, 25.0), Vector2(18.0, 36.0), Color("#3b352e"), 5)

	_ensure_combat_map_progress_route_state_overlay(root, false)

	var next_tile := _ensure_panel(root, "Panel_MapProgressNextTile", Vector2(204.0, 12.0), Vector2(50.0, 60.0), Color("#20140d"), Color("#c78324"), 3, 3)
	next_tile.z_index = 5
	var next_inner := _ensure_panel(root, "Panel_MapProgressNextTileInner", Vector2(211.0, 20.0), Vector2(36.0, 44.0), Color("#2f2114"), Color("#6b3f13"), 1, 1)
	next_inner.z_index = 6
	var next_marker := _ensure_map_progress_rect(root, "Rect_MapProgressNextMarker", Vector2(228.0, 35.0), Vector2(18.0, 18.0), Color("#d9a747"), 10)
	next_marker.rotation = deg_to_rad(45.0)
	next_marker.pivot_offset = next_marker.size * 0.5
	_ensure_map_progress_rect(root, "Rect_MapProgressNextMarkerShine", Vector2(234.0, 33.0), Vector2(3.0, 22.0), Color("#f8d889"), 11)
	_ensure_map_progress_rect(root, "Rect_MapProgressNextTopSpire", Vector2(230.0, 3.0), Vector2(5.0, 14.0), Color("#d99a27"), 10)
	_ensure_map_progress_rect(root, "Rect_MapProgressNextTopCross", Vector2(224.0, 10.0), Vector2(17.0, 3.0), Color("#d99a27"), 10)


func _ensure_combat_map_progress_route_state_overlay(root: Control, subtle: bool) -> void:
	var route_points := [
		Vector2(101.0, 35.0),
		Vector2(127.0, 42.0),
		Vector2(151.0, 57.0),
		Vector2(177.0, 39.0),
		Vector2(193.0, 36.0),
	]
	for index in range(route_points.size() - 1):
		var segment_color := Color(0.0, 0.0, 0.0, 0.0) if subtle else Color("#816f55")
		_ensure_map_progress_segment(root, "Rect_MapProgressRouteSegment%d" % index, route_points[index], route_points[index + 1], segment_color, 12 if subtle else 7)
	for index in range(route_points.size()):
		var node_size := Vector2(7.0, 7.0) if subtle else Vector2(11.0, 11.0)
		if index == route_points.size() - 1:
			node_size = Vector2(9.0, 9.0) if subtle else Vector2(13.0, 13.0)
		var node_fill := Color(0.0, 0.0, 0.0, 0.0) if subtle else (Color("#695e50") if index < route_points.size() - 1 else Color("#d79520"))
		var node_border := Color(0.0, 0.0, 0.0, 0.0) if subtle else Color("#19120a")
		var route_node := _ensure_panel(root, "Panel_MapProgressRouteNode%d" % index, route_points[index] - node_size * 0.5, node_size, node_fill, node_border, 1, 6)
		route_node.z_index = 13 if subtle else 9


func _ensure_map_progress_rect(parent: Control, node_name: String, pos: Vector2, rect_size: Vector2, color: Color, z: int) -> ColorRect:
	var existing := parent.get_node_or_null(node_name)
	var rect: ColorRect
	if existing != null and existing is ColorRect:
		rect = existing as ColorRect
	else:
		if existing != null:
			parent.remove_child(existing)
			existing.queue_free()
		rect = ColorRect.new()
		rect.name = node_name
		rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		parent.add_child(rect)
	rect.position = pos
	rect.size = rect_size
	rect.color = color
	rect.rotation = 0.0
	rect.scale = Vector2.ONE
	rect.z_index = z
	return rect


func _ensure_map_progress_segment(parent: Control, node_name: String, start: Vector2, end: Vector2, color: Color, z: int) -> ColorRect:
	var delta := end - start
	var length := maxf(1.0, delta.length())
	var segment := _ensure_map_progress_rect(parent, node_name, start, Vector2(length, 3.0), color, z)
	segment.rotation = atan2(delta.y, delta.x)
	segment.pivot_offset = Vector2(0.0, 1.5)
	return segment


func _ensure_texture_rect(parent: Control, node_name: String, pos: Vector2, rect_size: Vector2, texture: Texture2D, z: int) -> TextureRect:
	var existing := parent.get_node_or_null(node_name)
	var texture_rect: TextureRect
	if existing != null and existing is TextureRect:
		texture_rect = existing as TextureRect
	else:
		if existing != null:
			parent.remove_child(existing)
			existing.queue_free()
		texture_rect = TextureRect.new()
		texture_rect.name = node_name
		texture_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		parent.add_child(texture_rect)
	texture_rect.position = pos
	texture_rect.size = rect_size
	texture_rect.texture = texture
	texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	texture_rect.stretch_mode = TextureRect.STRETCH_SCALE
	texture_rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	texture_rect.z_index = z
	return texture_rect


func _combat_map_progress_orb_texture() -> Texture2D:
	var cache_key := "runtime.map_progress_portal"
	var cached: Variant = generated_texture_cache.get(cache_key, null)
	if cached != null and cached is Texture2D:
		return cached as Texture2D
	var texture_size := 64
	var image := Image.create(texture_size, texture_size, false, Image.FORMAT_RGBA8)
	var center := Vector2(float(texture_size - 1) * 0.5, float(texture_size - 1) * 0.5)
	var radius := float(texture_size) * 0.44
	for y in range(texture_size):
		for x in range(texture_size):
			var point := Vector2(float(x), float(y))
			var delta := point - center
			var dx := absf(delta.x)
			var dy := absf(delta.y)
			var octagon_distance := (maxf(dx, dy) + minf(dx, dy) * 0.42) / radius
			if octagon_distance > 1.0:
				image.set_pixel(x, y, Color(0.0, 0.0, 0.0, 0.0))
				continue
			var radial_distance := delta.length() / radius
			var angle := atan2(delta.y, delta.x)
			var ring := clampf((octagon_distance - 0.72) / 0.2, 0.0, 1.0)
			var core := clampf(1.0 - radial_distance * 0.9, 0.0, 1.0)
			var swirl := 0.5 + 0.5 * sin(angle * 2.0 + radial_distance * 12.0)
			var glint := clampf(1.0 - point.distance_to(Vector2(24.0, 18.0)) / 10.0, 0.0, 1.0)
			var edge_alpha := clampf((1.0 - octagon_distance) * 10.0, 0.0, 1.0)
			var color := Color("#082138").lerp(Color("#2e8fd0"), core)
			color = color.lerp(Color("#7ce8ff"), swirl * 0.34)
			color = color.lerp(Color("#dffcff"), glint * 0.65)
			color = color.lerp(Color("#06111b"), ring * 0.42)
			color.a = edge_alpha
			image.set_pixel(x, y, color)
	var texture := ImageTexture.create_from_image(image)
	generated_texture_cache[cache_key] = texture
	return texture


func _ensure_pixel_prop(parent: Control, node_name: String, pos: Vector2, prop_size: Vector2, color: Color) -> ColorRect:
	var existing := parent.get_node_or_null(node_name)
	var prop: ColorRect
	if existing != null and existing is ColorRect:
		prop = existing as ColorRect
	else:
		prop = ColorRect.new()
		prop.name = node_name
		prop.mouse_filter = Control.MOUSE_FILTER_IGNORE
		parent.add_child(prop)
	prop.position = pos
	prop.size = prop_size
	prop.color = color
	prop.z_index = 1
	return prop


func _remove_generated_combat_data_panels(strip: Control) -> void:
	for key in ["combat_state", "combat_skill", "combat_skill_panel", "combat_skill_label", "combat_skill_cooldown", "combat_drop_banner", "combat_drop_banner_title", "combat_drop_banner_body", "combat_drop_banner_icon", "combat_enemy", "combat_loot"]:
		generated_runtime_nodes.erase(key)
	for node_name in [
		"Panel_RuntimeCombatState",
		"Panel_RuntimeCombatSkill",
		"Panel_RuntimeCombatEnemy",
		"Panel_RuntimeCombatLootTicker",
		OVERLAY_COMBAT_SKILL_PANEL_NAME,
		OVERLAY_COMBAT_DROP_BANNER_NAME,
		"Text_RuntimeDropBannerTitle",
		"Text_RuntimeDropBannerBody",
		"Text_RuntimeDropBannerIcon",
	]:
		var panel := strip.get_node_or_null(node_name)
		if panel != null:
			panel.queue_free()
	for node_name in ["Panel_AutoCombatToggle", "Panel_AutoSkillToggle", "Panel_LootTicker"]:
		var panel := strip.get_node_or_null(node_name)
		if panel != null and panel is CanvasItem:
			(panel as CanvasItem).visible = false
		if panel != null and panel is Control:
			(panel as Control).mouse_filter = Control.MOUSE_FILTER_IGNORE


func _ensure_combat_hp_plate(parent: Control, node_name: String) -> PanelContainer:
	var existing := parent.get_node_or_null(node_name)
	if existing != null and not existing is PanelContainer:
		existing.free()
		existing = null
	var panel: PanelContainer
	if existing == null:
		panel = PanelContainer.new()
		panel.name = node_name
		panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
		parent.add_child(panel)
	else:
		panel = existing as PanelContainer
	panel.z_index = 21
	panel.add_theme_stylebox_override("panel", _combat_hp_plate_style(Color("#d85745"), 0.0))
	return panel


func _ensure_combat_progress(parent: Control, node_name: String, pos: Vector2, progress_size: Vector2, fill: Color) -> ProgressBar:
	var progress := parent.get_node_or_null(node_name)
	if progress == null:
		progress = ProgressBar.new()
		progress.name = node_name
		progress.mouse_filter = Control.MOUSE_FILTER_IGNORE
		progress.show_percentage = false
		parent.add_child(progress)
	(progress as ProgressBar).position = pos
	(progress as ProgressBar).size = progress_size
	(progress as ProgressBar).min_value = 0.0
	(progress as ProgressBar).max_value = 1.0
	(progress as ProgressBar).z_index = 24
	_style_combat_hp_bar(progress as ProgressBar, fill, 0.0)
	return progress as ProgressBar


func _ensure_combat_label(parent: Control, node_name: String, pos: Vector2, label_size: Vector2, font_size: int, color: Color) -> Label:
	var label := parent.get_node_or_null(node_name)
	if label == null:
		label = Label.new()
		label.name = node_name
		label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.clip_text = true
		label.add_theme_font_size_override("font_size", font_size)
		label.add_theme_color_override("font_color", color)
		label.add_theme_color_override("font_shadow_color", Color("#050302"))
		label.add_theme_constant_override("shadow_offset_x", 1)
		label.add_theme_constant_override("shadow_offset_y", 1)
		parent.add_child(label)
	(label as Label).position = pos
	(label as Label).size = label_size
	(label as Label).z_index = 25
	return label as Label


func _style_combat_hp_bar(progress: ProgressBar, fill: Color, hit_flash: float) -> void:
	var flash := clampf(hit_flash / 0.18, 0.0, 1.0)
	var fill_color := fill.lerp(Color("#fff0a6"), flash * 0.55)
	progress.mouse_filter = Control.MOUSE_FILTER_IGNORE
	progress.show_percentage = false
	progress.min_value = 0.0
	progress.max_value = 1.0
	progress.add_theme_stylebox_override("background", _overlay_style(Color(0.04, 0.026, 0.014, 0.9), Color("#120c08"), 1, 3))
	progress.add_theme_stylebox_override("fill", _overlay_style(fill_color, fill_color, 0, 3))


func _style_combat_hp_label(label: Label, font_size: int, alignment: HorizontalAlignment) -> void:
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.horizontal_alignment = alignment
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.clip_text = true
	label.z_index = 25
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", Color("#fff4d6"))
	label.add_theme_color_override("font_shadow_color", Color("#050302"))
	label.add_theme_constant_override("shadow_offset_x", 1)
	label.add_theme_constant_override("shadow_offset_y", 1)
	label.add_theme_color_override("font_outline_color", Color("#210905"))
	label.add_theme_constant_override("outline_size", 2)


func _combat_hp_plate_style(accent: Color, hit_flash: float) -> StyleBoxFlat:
	var flash := clampf(hit_flash / 0.18, 0.0, 1.0)
	var fill := Color(0.035, 0.024, 0.014, 0.78 + flash * 0.12)
	var border := Color("#6b4a2a").lerp(accent.lightened(0.32), flash)
	var style := _overlay_style(fill, border, 2 if flash > 0.0 else 1, 4)
	style.content_margin_left = 8.0
	style.content_margin_right = 8.0
	style.content_margin_top = 4.0
	style.content_margin_bottom = 4.0
	return style


func _ensure_generated_taskbar_controls(root: Control) -> void:
	var combat_strip := root.get_node_or_null(OVERLAY_COMBAT_STRIP_PATH)
	if combat_strip == null or not combat_strip is Control:
		return
	var strip := combat_strip as Control
	var toggle := strip.get_node_or_null(OVERLAY_WORKSHOP_TOGGLE_NAME)
	if toggle == null:
		toggle = Button.new()
		toggle.name = OVERLAY_WORKSHOP_TOGGLE_NAME
		toggle.position = Vector2(1438.0, 16.0)
		toggle.size = Vector2(104.0, 32.0)
		toggle.toggle_mode = true
		toggle.tooltip_text = "작업창 숨김/복원"
		toggle.set_meta("button_role", "utility_icon")
		(toggle as Button).pressed.connect(func():
			_set_generated_taskbar_mode(not generated_taskbar_mode)
		)
		_apply_generated_button_style(toggle as Button, "utility_icon")
		strip.add_child(toggle)
	generated_runtime_nodes["workshop_toggle"] = toggle
	_ensure_generated_combat_opacity_control(strip)
	_ensure_generated_combat_resize_handle(strip)


func _ensure_generated_combat_opacity_control(strip: Control) -> void:
	var panel_node := strip.get_node_or_null(COMBAT_OPACITY_CONTROL_NAME)
	var panel: Control
	if panel_node != null and panel_node is Control:
		panel = panel_node as Control
	else:
		if panel_node != null:
			strip.remove_child(panel_node)
			panel_node.queue_free()
		var button_panel := Button.new()
		button_panel.text = ""
		button_panel.focus_mode = Control.FOCUS_NONE
		button_panel.add_theme_stylebox_override("normal", _overlay_style(Color(0.04, 0.025, 0.015, 0.92), Color("#6b4a2a"), 1, 4))
		button_panel.add_theme_stylebox_override("hover", _overlay_style(Color(0.07, 0.045, 0.025, 0.94), Color("#9f6b2f"), 1, 4))
		button_panel.add_theme_stylebox_override("pressed", _overlay_style(Color(0.035, 0.022, 0.014, 0.94), Color("#8a5b24"), 1, 4))
		panel = button_panel
		panel.name = COMBAT_OPACITY_CONTROL_NAME
		panel.mouse_filter = Control.MOUSE_FILTER_PASS
		panel.tooltip_text = "전투 화면 투명도"
		strip.add_child(panel)
		var icon := _make_runtime_label("Text_CombatOpacityIcon", Vector2(8.0, 4.0), Vector2(18.0, 18.0), 12, Color("#ffcf7a"))
		icon.text = "◐"
		panel.add_child(icon)
		var slider := HSlider.new()
		slider.name = COMBAT_OPACITY_SLIDER_NAME
		slider.position = Vector2(30.0, 7.0)
		slider.size = Vector2(88.0, 14.0)
		slider.min_value = COMBAT_OPACITY_MIN * 100.0
		slider.max_value = COMBAT_OPACITY_MAX * 100.0
		slider.step = 5.0
		slider.tooltip_text = "전투 화면 투명도"
		slider.mouse_filter = Control.MOUSE_FILTER_STOP
		slider.add_theme_stylebox_override("slider", _overlay_style(Color("#17110c"), Color("#3b2a1a"), 1, 2))
		slider.add_theme_stylebox_override("grabber_area", _overlay_style(Color("#9f6cf5"), Color("#caa6ff"), 0, 2))
		slider.add_theme_stylebox_override("grabber_area_highlight", _overlay_style(Color("#b985ff"), Color("#efd5ff"), 0, 2))
		slider.value_changed.connect(func(value: float):
			_set_generated_combat_opacity(value / 100.0)
		)
		panel.add_child(slider)
		var value_label := _make_runtime_label(COMBAT_OPACITY_VALUE_NAME, Vector2(124.0, 4.0), Vector2(36.0, 18.0), 10, Color("#f3e6c8"))
		value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		panel.add_child(value_label)
	panel.position = Vector2(1088.0, 12.0)
	panel.size = Vector2(168.0, 28.0)
	panel.custom_minimum_size = panel.size
	_layout_generated_combat_opacity_control(panel)
	panel.visible = true
	panel.z_index = 4095
	panel.z_as_relative = false
	panel.move_to_front()
	generated_runtime_nodes["combat_opacity_control"] = panel
	_sync_generated_combat_opacity_control()


func _layout_generated_combat_opacity_control(panel: Control) -> void:
	var icon := panel.get_node_or_null("Text_CombatOpacityIcon")
	if icon != null and icon is Label:
		var label := icon as Label
		label.position = Vector2(8.0, 4.0)
		label.size = Vector2(18.0, 18.0)
		label.add_theme_font_size_override("font_size", 12)
	var slider := panel.get_node_or_null(COMBAT_OPACITY_SLIDER_NAME)
	if slider != null and slider is HSlider:
		var h_slider := slider as HSlider
		h_slider.position = Vector2(30.0, 7.0)
		h_slider.size = Vector2(88.0, 14.0)
	var value_label := panel.get_node_or_null(COMBAT_OPACITY_VALUE_NAME)
	if value_label != null and value_label is Label:
		var label := value_label as Label
		label.position = Vector2(124.0, 4.0)
		label.size = Vector2(36.0, 18.0)
		label.add_theme_font_size_override("font_size", 10)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT


func _ensure_generated_combat_resize_handle(strip: Control) -> void:
	var handle_node := strip.get_node_or_null(COMBAT_RESIZE_HANDLE_NAME)
	var handle: Control = handle_node as Control
	if handle == null:
		handle = Control.new()
		handle.name = COMBAT_RESIZE_HANDLE_NAME
		handle.mouse_filter = Control.MOUSE_FILTER_STOP
		handle.mouse_default_cursor_shape = Control.CURSOR_FDIAGSIZE
		handle.tooltip_text = "전투창 크기 조절"
		handle.z_index = 220
		handle.set_meta("combat_resize_handle", true)
		handle.gui_input.connect(func(event: InputEvent):
			_handle_generated_combat_strip_resize_input(event, strip)
		)
		strip.add_child(handle)
		for i in range(3):
			var grip := ColorRect.new()
			grip.name = "GripLine%d" % (i + 1)
			grip.color = Color(1.0, 0.81, 0.48, 0.78)
			grip.mouse_filter = Control.MOUSE_FILTER_IGNORE
			grip.size = Vector2(6.0 + float(i) * 5.0, 2.0)
			grip.position = Vector2(18.0 - float(i) * 2.0, 10.0 + float(i) * 6.0)
			handle.add_child(grip)
	handle.size = COMBAT_RESIZE_HANDLE_SIZE
	handle.position = strip.size - COMBAT_RESIZE_HANDLE_SIZE - COMBAT_RESIZE_HANDLE_MARGIN
	handle.visible = true
	generated_runtime_nodes["combat_resize_handle"] = handle


func _ensure_runtime_skill_tree_window(root: Control) -> void:
	var window_stack := root.get_node_or_null("Section_WindowStack")
	if window_stack == null or not window_stack is Control:
		return
	if (window_stack as Control).has_node(RUNTIME_SKILL_TREE_WINDOW_NAME):
		generated_runtime_nodes["skill_tree_window"] = (window_stack as Control).get_node(RUNTIME_SKILL_TREE_WINDOW_NAME)
		_register_desktop_window("skill_tree", generated_runtime_nodes["skill_tree_window"] as Control, generated_native_windows.get("skill_tree", null))
		return
	var window := Control.new()
	window.name = RUNTIME_SKILL_TREE_WINDOW_NAME
	window.position = Vector2(914.0, 72.0)
	window.size = Vector2(560.0, 458.0)
	window.custom_minimum_size = window.size
	window.visible = false
	window.z_index = 82
	window.set_meta("program_window_id", "skill_tree")
	(window_stack as Control).add_child(window)
	_ensure_program_window_shadow(window)

	var frame := PanelContainer.new()
	frame.name = "Panel_RuntimeSkillTreeFrame"
	frame.position = Vector2.ZERO
	frame.size = window.size
	frame.mouse_filter = Control.MOUSE_FILTER_PASS
	var frame_style := _overlay_texture_style("taskstonebar.ui.window_frame_9slice")
	if frame_style != null:
		frame.add_theme_stylebox_override("panel", frame_style)
	else:
		frame.add_theme_stylebox_override("panel", _overlay_style(Color("#0a0908"), Color("#d18a24"), 2, 4))
	window.add_child(frame)

	var title := WindowTitleBarChrome.ensure_title_label(window, "Text_RuntimeSkillTreeTitle", "Taskstonebar 스킬 트리")
	var close_button := WindowTitleBarChrome.ensure_button(window, "Btn_RuntimeSkillTreeClose", "", "닫기")
	var minimize_button := WindowTitleBarChrome.ensure_button(window, "Btn_RuntimeSkillTreeMinimize", "-", "최소화")
	var title_bar := WindowTitleBarChrome.apply(window, {
		"title_label": title,
		"close_button": close_button,
		"minimize_button": minimize_button,
		"close_icon": _generated_texture(GENERATED_CLOSE_ICON_PATH),
		"minimize_text": "-",
	})
	if title_bar != null:
		_connect_program_window_drag(title_bar, window)
	close_button.pressed.connect(func():
		_close_generated_window("skill_tree", window)
	)
	minimize_button.pressed.connect(func():
		_close_generated_window("skill_tree", window)
	)

	var body := PanelContainer.new()
	body.name = "Panel_RuntimeSkillTreeBody"
	body.position = Vector2(18.0, 64.0)
	body.size = Vector2(window.size.x - 36.0, 330.0)
	body.add_theme_stylebox_override("panel", _overlay_style(Color("#21140c"), Color("#0d0805"), 2, 2))
	window.add_child(body)
	var body_content := Control.new()
	body_content.name = "Content_RuntimeSkillTreeBody"
	body_content.custom_minimum_size = body.size
	body_content.size = body.size
	body.add_child(body_content)

	var summary := _make_runtime_label("Text_RuntimeSkillTreeSummary", Vector2(16.0, 8.0), Vector2(488.0, 24.0), 13, Color("#f3e6c8"))
	body_content.add_child(summary)
	for lane_index in range(RUNTIME_SKILL_TREE_LANES.size()):
		var lane: Dictionary = RUNTIME_SKILL_TREE_LANES[lane_index]
		var y := 42.0 + float(lane_index) * 45.0
		var lane_label := _make_runtime_label("Text_RuntimeSkillLane%d" % lane_index, Vector2(16.0, y + 4.0), Vector2(72.0, 26.0), 12, Color("#b79a72"))
		lane_label.text = str(lane.get("title", "Lane"))
		lane_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		body_content.add_child(lane_label)
		var items: Array = lane.get("items", [])
		for column in range(items.size()):
			if column > 0:
				var line := ColorRect.new()
				line.name = "Line_RuntimeSkill_%d_%d" % [lane_index, column]
				line.position = Vector2(148.0 + float(column - 1) * 74.0, y + 18.0)
				line.size = Vector2(18.0, 2.0)
				line.color = Color("#8a5b24")
				line.mouse_filter = Control.MOUSE_FILTER_IGNORE
				body_content.add_child(line)
			_make_runtime_skill_node_button(body_content, int(items[column]), Vector2(92.0 + float(column) * 74.0, y), Vector2(58.0, 34.0))

	var footer := PanelContainer.new()
	footer.name = "Panel_RuntimeSkillTreeFooter"
	footer.position = Vector2(18.0, 406.0)
	footer.size = Vector2(window.size.x - 36.0, 36.0)
	footer.add_theme_stylebox_override("panel", _overlay_style(Color("#120c08"), Color("#6b4a2a"), 1, 2))
	window.add_child(footer)
	var footer_content := Control.new()
	footer_content.name = "Content_RuntimeSkillTreeFooter"
	footer_content.custom_minimum_size = footer.size
	footer_content.size = footer.size
	footer.add_child(footer_content)
	var footer_label := _make_runtime_label("Text_RuntimeSkillTreeFooter", Vector2(10.0, 2.0), Vector2(326.0, 30.0), 12, Color("#f3e6c8"))
	footer_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	footer_content.add_child(footer_label)
	var learn_button := _make_runtime_action_button("Btn_RuntimeSkillLearn", "학습", Vector2(344.0, 4.0), Vector2(74.0, 28.0))
	learn_button.pressed.connect(_runtime_learn_selected_skill)
	footer_content.add_child(learn_button)
	var level_button := _make_runtime_action_button("Btn_RuntimeSkillLevelUp", "레벨업", Vector2(428.0, 4.0), Vector2(84.0, 28.0))
	level_button.pressed.connect(_runtime_level_selected_skill)
	footer_content.add_child(level_button)

	generated_runtime_nodes["skill_tree_window"] = window
	generated_runtime_nodes["skill_tree_summary"] = summary
	generated_runtime_nodes["skill_tree_footer"] = footer_label
	generated_runtime_nodes["skill_tree_learn"] = learn_button
	generated_runtime_nodes["skill_tree_level"] = level_button
	_register_desktop_window("skill_tree", window, generated_native_windows.get("skill_tree", null))


func _make_runtime_action_button(node_name: String, text: String, pos: Vector2, button_size: Vector2) -> Button:
	var button := Button.new()
	button.name = node_name
	button.text = text
	button.position = pos
	button.size = button_size
	button.custom_minimum_size = button_size
	button.set_meta("button_role", "inventory_tab")
	_apply_generated_button_style(button, "inventory_tab")
	return button


func _make_runtime_label(node_name: String, pos: Vector2, label_size: Vector2, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.name = node_name
	label.position = pos
	label.size = label_size
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.clip_text = true
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	label.add_theme_color_override("font_shadow_color", Color("#050302"))
	label.add_theme_constant_override("shadow_offset_x", 1)
	label.add_theme_constant_override("shadow_offset_y", 1)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return label


func _make_runtime_skill_node_button(parent: Control, item_id: int, pos: Vector2, button_size: Vector2) -> void:
	var button := Button.new()
	button.name = "Btn_RuntimeSkillNode_%d" % item_id
	button.text = ""
	button.position = pos
	button.size = button_size
	button.custom_minimum_size = button_size
	button.tooltip_text = "SkillItem %d" % item_id
	button.set_meta("button_role", "keeper_dock_icon")
	button.pressed.connect(func():
		_select_runtime_skill_node(item_id)
	)
	_apply_generated_button_style(button, "keeper_dock_icon")
	var icon := TextureRect.new()
	icon.name = "Tex_RuntimeSkillNodeIcon"
	icon.position = Vector2(4.0, 5.0)
	icon.size = Vector2(22.0, 22.0)
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	button.add_child(icon)
	var state_label := Label.new()
	state_label.name = "Text_RuntimeSkillNodeState"
	state_label.position = Vector2(28.0, 3.0)
	state_label.size = Vector2(maxf(24.0, button_size.x - 31.0), button_size.y - 6.0)
	state_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	state_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	state_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	state_label.clip_text = true
	state_label.add_theme_font_size_override("font_size", 9)
	state_label.add_theme_color_override("font_color", Color("#f3e6c8"))
	state_label.add_theme_color_override("font_shadow_color", Color("#050302"))
	state_label.add_theme_constant_override("shadow_offset_x", 1)
	state_label.add_theme_constant_override("shadow_offset_y", 1)
	button.add_child(state_label)
	parent.add_child(button)


func _open_runtime_skill_tree_window() -> void:
	var window: Control = generated_runtime_nodes.get("skill_tree_window", null)
	if window == null:
		if generated_ui_overlay != null:
			_ensure_runtime_skill_tree_window(generated_ui_overlay)
			window = generated_runtime_nodes.get("skill_tree_window", null)
	if window == null:
		return
	generated_taskbar_mode = false
	_restore_generated_workshop_windows()
	if _ensure_desktop_window_registered("skill_tree"):
		desktop_window_manager.show_window("skill_tree", true)
	else:
		window.visible = true
		var native := _native_window_for_generated_control(window)
		if native != null:
			native.visible = true
			native.grab_focus()
		else:
			window.move_to_front()


func _runtime_skill_tree_preview_message() -> String:
	var snapshot := _progression_snapshot()
	var skills: Dictionary = snapshot.get("skills", {}) if typeof(snapshot.get("skills", {})) == TYPE_DICTIONARY else {}
	var points := int(snapshot.get("materials", {}).get(200501, 0))
	return "스킬 트리: 신규 30개 노드, 보유 SP %d, 학습 %d개" % [points, skills.size()]


func _select_runtime_skill_node(item_id: int) -> void:
	generated_selected_skill_item_id = int(item_id)
	var item: Dictionary = store.get_item(generated_selected_skill_item_id) if store != null else {}
	generated_action_message = "스킬 선택: %s" % str(item.get("name", "Skill %d" % generated_selected_skill_item_id))
	_refresh_generated_overlay_now()


func _runtime_learn_selected_skill() -> void:
	if progression == null:
		generated_action_message = "스킬 학습 불가: 진행 상태가 준비되지 않음"
		_refresh_generated_overlay_now()
		return
	var item: Dictionary = store.get_item(generated_selected_skill_item_id) if store != null else {}
	var preview: Dictionary = progression.skill_unlock_preview(generated_selected_skill_item_id, _runtime_player_level())
	if not bool(preview.get("ok", false)):
		generated_action_message = "스킬 학습 불가: %s" % _runtime_skill_preview_reason(preview)
		_refresh_generated_overlay_now()
		return
	var result: Dictionary = progression.unlock_skill(generated_selected_skill_item_id, _runtime_player_level())
	if not bool(result.get("ok", false)):
		generated_action_message = "스킬 학습 실패: %s" % _runtime_skill_preview_reason(result)
		_refresh_generated_overlay_now()
		return
	var skill: Dictionary = result.get("skill", {}) if typeof(result.get("skill", {})) == TYPE_DICTIONARY else {}
	generated_action_message = "스킬 학습: %s Lv.%d | %s" % [
		str(skill.get("name", item.get("name", "스킬"))),
		int(skill.get("level", 1)),
		_runtime_skill_cost_label(result.get("cost", [])),
	]
	_refresh_generated_overlay_now()


func _runtime_level_selected_skill() -> void:
	if progression == null:
		generated_action_message = "스킬 레벨업 불가: 진행 상태가 준비되지 않음"
		_refresh_generated_overlay_now()
		return
	var result: Dictionary = progression.level_up_skill(generated_selected_skill_item_id)
	if not bool(result.get("ok", false)):
		if str(result.get("error", "")) == "skill_not_owned":
			generated_action_message = "스킬 레벨업: 먼저 학습 필요"
		elif str(result.get("error", "")) == "skill_max_level":
			generated_action_message = "스킬 레벨업: 최대 레벨"
		elif str(result.get("error", "")) == "insufficient_materials":
			generated_action_message = "스킬 레벨업 불가: %s" % _runtime_skill_cost_missing_label(result.get("missing", []))
		else:
			generated_action_message = "스킬 레벨업 실패: %s" % str(result.get("message", result.get("error", "")))
		_refresh_generated_overlay_now()
		return
	var skill: Dictionary = result.get("skill", {}) if typeof(result.get("skill", {})) == TYPE_DICTIONARY else {}
	var delta: Dictionary = result.get("effect_delta", {}) if typeof(result.get("effect_delta", {})) == TYPE_DICTIONARY else {}
	generated_action_message = "스킬 레벨업: %s Lv.%d, 피해 +%.2f" % [
		str(skill.get("name", "스킬")),
		int(skill.get("level", 1)),
		float(delta.get("damage_ratio", 0.0)),
	]
	_refresh_generated_overlay_now()


func _set_generated_taskbar_mode(enabled: bool) -> void:
	generated_taskbar_mode = enabled
	if generated_ui_overlay == null:
		return
	if enabled:
		_close_equipment_upgrade_modal()
		_close_inventory_item_detail_modal()
		_hide_generated_workshop_windows()
		generated_action_message = "Taskbar mode: 작업창 숨김, combat strip 계속 실행"
	else:
		_restore_generated_workshop_windows()
		generated_action_message = "Workshop mode: 작업창 복원, combat strip 유지"
	_refresh_generated_overlay_now()


func _hide_generated_workshop_windows() -> void:
	if generated_ui_overlay == null:
		return
	if _ensure_desktop_window_registered("status"):
		desktop_window_manager.hide_group("workshop")
		return
	if not generated_native_windows.is_empty():
		for window_id in ["status", "keeper", "portal", "skill_tree"]:
			var native: Window = generated_native_windows.get(window_id, null)
			if native != null:
				native.visible = false
		return
	var window_stack := generated_ui_overlay.get_node_or_null("Section_WindowStack")
	if window_stack == null:
		return
	for child in window_stack.get_children():
		if child is CanvasItem and _is_runtime_workshop_window(child):
			(child as CanvasItem).visible = false


func _restore_generated_workshop_windows() -> void:
	if generated_ui_overlay == null:
		return
	if _ensure_desktop_window_registered("status"):
		desktop_window_manager.restore_group("workshop", {
			"skill_tree": generated_selected_action == "skill",
		})
		return
	if not generated_native_windows.is_empty():
		for window_id in ["status", "keeper", "portal"]:
			var native: Window = generated_native_windows.get(window_id, null)
			var root: Control = generated_native_window_roots.get(window_id, null)
			if native != null:
				native.visible = true
			if root != null:
				root.visible = true
		var skill_native: Window = generated_native_windows.get("skill_tree", null)
		var skill_root: Control = generated_native_window_roots.get("skill_tree", null)
		if skill_native != null:
			skill_native.visible = generated_selected_action == "skill"
		if skill_root != null:
			skill_root.visible = generated_selected_action == "skill"
		return
	var window_stack := generated_ui_overlay.get_node_or_null("Section_WindowStack")
	if window_stack == null:
		return
	for child in window_stack.get_children():
		if child is CanvasItem and _is_runtime_workshop_window(child):
			(child as CanvasItem).visible = str(child.name) != RUNTIME_SKILL_TREE_WINDOW_NAME
	var selected_window: Control = generated_runtime_nodes.get("skill_tree_window", null)
	if selected_window != null and generated_selected_action == "skill":
		selected_window.visible = true


func _is_runtime_workshop_window(node: Node) -> bool:
	var node_name := str(node.name)
	return node_name.ends_with("WindowFrame") or node_name == RUNTIME_SKILL_TREE_WINDOW_NAME


func _sync_generated_taskbar_controls() -> void:
	var toggle: Variant = generated_runtime_nodes.get("workshop_toggle", null)
	if toggle != null and toggle is Button:
		var button := toggle as Button
		button.button_pressed = generated_taskbar_mode
		button.text = "창 복원" if generated_taskbar_mode else "창 숨김"
		button.tooltip_text = "Workshop mode 복원" if generated_taskbar_mode else "Taskbar mode로 최소화"
	_sync_generated_combat_opacity_control()


func _set_generated_combat_opacity(value: float) -> void:
	generated_combat_opacity = clampf(value, COMBAT_OPACITY_MIN, COMBAT_OPACITY_MAX)
	_sync_generated_combat_opacity_control()
	_apply_generated_combat_opacity()


func _sync_generated_combat_opacity_control() -> void:
	var panel_node = generated_runtime_nodes.get("combat_opacity_control", null)
	if panel_node == null or not panel_node is Control:
		return
	var panel := panel_node as Control
	panel.visible = true
	panel.z_index = 4095
	panel.z_as_relative = false
	panel.move_to_front()
	var percent := roundi(generated_combat_opacity * 100.0)
	var slider := panel.get_node_or_null(COMBAT_OPACITY_SLIDER_NAME)
	if slider != null and slider is HSlider:
		var h_slider := slider as HSlider
		h_slider.set_value_no_signal(float(percent))
	var value_label := panel.get_node_or_null(COMBAT_OPACITY_VALUE_NAME)
	if value_label != null and value_label is Label:
		(value_label as Label).text = "%d%%" % percent


func _apply_generated_combat_opacity() -> void:
	var strip_node := _generated_node_or_null(OVERLAY_COMBAT_STRIP_PATH)
	if strip_node == null or not strip_node is Control:
		return
	var strip := strip_node as Control
	var opacity := clampf(generated_combat_opacity, COMBAT_OPACITY_MIN, COMBAT_OPACITY_MAX)
	for child in strip.get_children():
		if not child is CanvasItem:
			continue
		var child_name := str(child.name)
		var canvas := child as CanvasItem
		if child_name == COMBAT_OPACITY_CONTROL_NAME or child_name == COMBAT_RESIZE_HANDLE_NAME:
			canvas.modulate = Color.WHITE
			continue
		if not canvas.has_meta("combat_opacity_base_alpha"):
			canvas.set_meta("combat_opacity_base_alpha", canvas.modulate.a)
		var base_alpha := float(canvas.get_meta("combat_opacity_base_alpha", 1.0))
		canvas.modulate = Color(canvas.modulate.r, canvas.modulate.g, canvas.modulate.b, base_alpha * opacity)


func _sync_desktop_status_bar(snapshot: Dictionary, model: Dictionary) -> void:
	if generated_ui_overlay == null:
		return
	var layer := generated_ui_overlay.get_node_or_null("Section_DesktopScaffold/RuntimeDesktopStatusBarLayer")
	if layer == null:
		layer = generated_ui_overlay.get_node_or_null("Section_DesktopScaffold/Panel_OsTaskbarBand")
	if layer == null or not layer is Control:
		return
	var status_bar := layer as Control
	var mode_label := status_bar.get_node_or_null("Text_StatusBarMode")
	if mode_label != null and mode_label is Label:
		var label := mode_label as Label
		label.text = "TASKBAR" if generated_taskbar_mode else "WORKSHOP"
		label.add_theme_color_override("font_color", Color("#ffcf7a") if generated_taskbar_mode else Color("#f3e6c8"))

	var player: Dictionary = snapshot.get("player", {}) if typeof(snapshot.get("player", {})) == TYPE_DICTIONARY else {}
	var hp := int(player.get("hp", 0))
	var max_hp := int(player.get("max_hp", 0))
	_set_status_bar_text(status_bar, "Text_StatusBarCombat", "%s · HP %d/%d · 적 %d" % [
		_current_stage_label(snapshot).replace("\n", " "),
		hp,
		max_hp,
		int(snapshot.get("enemy_count", 0)),
	])

	var window_text := "창 준비 중"
	if desktop_window_manager != null:
		var desktop_snapshot: Dictionary = desktop_window_manager.snapshot()
		var visible: Array = desktop_snapshot.get("visible", []) if typeof(desktop_snapshot.get("visible", [])) == TYPE_ARRAY else []
		var registered: Array = desktop_snapshot.get("registered", []) if typeof(desktop_snapshot.get("registered", [])) == TYPE_ARRAY else []
		var focused := _desktop_status_bar_window_label(str(desktop_snapshot.get("focused", "")))
		window_text = "창 %d/%d · 포커스 %s" % [visible.size(), registered.size(), focused]
	_set_status_bar_text(status_bar, "Text_StatusBarWindows", window_text)

	var sync := status_bar.get_node_or_null("Text_StatusBarSync")
	if sync != null and sync is Label:
		var sync_label := sync as Label
		var raw_status := str(model.get("steam_status", "서버 LIVE   Steam SYNC"))
		sync_label.text = raw_status.replace("서버 ", "").replace("   ", " · ")


func _set_status_bar_text(parent: Control, node_name: String, text: String) -> void:
	var node := parent.get_node_or_null(node_name)
	if node != null and node is Label:
		(node as Label).text = text


func _desktop_status_bar_window_label(window_id: String) -> String:
	match _normalize_desktop_window_id(window_id):
		"status":
			return "상태"
		"keeper":
			return "돌지기"
		"portal":
			return "지도"
		"combat":
			return "전투"
		"skill_tree":
			return "스킬"
	return "-"


func _sync_status_window_real_data(model: Dictionary) -> void:
	var progression_snapshot := _progression_snapshot()
	var skills: Dictionary = progression_snapshot.get("skills", {}) if typeof(progression_snapshot.get("skills", {})) == TYPE_DICTIONARY else {}
	var materials: Dictionary = progression_snapshot.get("materials", {}) if typeof(progression_snapshot.get("materials", {})) == TYPE_DICTIONARY else {}
	_set_status_label_text("Panel_SkillPointHeader/Text_SkillPoints", "Skill Points: %d" % int(materials.get(200501, 0)))
	var learned_count := skills.size()
	_set_status_label_text("Panel_SkillPointHeader/Text_SkillPointPlus", "+" if int(materials.get(200501, 0)) > 0 else "")
	for spec in STATUS_SKILL_BINDINGS:
		var item_id := int(spec.get("item_id", 0))
		var item: Dictionary = store.get_item(item_id) if store != null else {}
		var level := _runtime_skill_level(item_id, skills)
		var max_level := _runtime_skill_max_level(item)
		var ready := _runtime_skill_requirements_ready(item, skills)
		var label_text := "잠김"
		if level > 0:
			label_text = "%d/%d" % [level, max_level]
		elif ready:
			label_text = "0/%d" % max_level
		_set_status_skill_binding_text(str(spec.get("binding", "")), label_text)
		_set_status_skill_binding_visual(str(spec.get("binding", "")), item_id, item, level, ready)
	var class_label := _generated_node_or_null("Section_WindowStack/Panel_StatusWindowFrame/Panel_StatusStatScroll/Panel_ClassRibbon/Text_ClassName")
	if class_label != null and class_label is Label:
		(class_label as Label).text = "돌팔매꾼 | 스킬 %d/%d" % [learned_count, RUNTIME_SKILL_TREE_ITEM_IDS.size()]


func _set_status_label_text(local_path: String, text: String) -> void:
	var node := _generated_node_or_null("Section_WindowStack/Panel_StatusWindowFrame/%s" % local_path)
	if node != null and node is Label:
		(node as Label).text = text


func _set_status_skill_binding_text(binding: String, text: String) -> void:
	for root in _status_window_roots():
		_set_binding_label_text_recursive(root, binding, text)


func _set_binding_label_text_recursive(node: Node, binding: String, text: String) -> void:
	if node is Label and str(node.get_meta("text_binding_or_text_key", "")) == binding:
		(node as Label).text = text
	for child in node.get_children():
		_set_binding_label_text_recursive(child, binding, text)


func _set_status_skill_binding_visual(binding: String, item_id: int, item: Dictionary, level: int, ready: bool) -> void:
	for root in _status_window_roots():
		var label := _find_binding_label(root, binding)
		if label == null:
			continue
		var slot := label.get_parent()
		if slot != null and slot is CanvasItem:
			if level > 0:
				(slot as CanvasItem).modulate = Color(0.92, 1.12, 0.92, 1.0)
			elif ready:
				(slot as CanvasItem).modulate = Color(1.0, 0.95, 0.72, 0.96)
			else:
				(slot as CanvasItem).modulate = Color(0.48, 0.48, 0.48, 0.72)
			var icon := _find_first_texture_rect(slot)
			if icon != null:
				var icon_texture := _runtime_skill_icon_texture(item_id, item)
				icon.texture = icon_texture
				icon.visible = icon_texture != null
				if level > 0:
					icon.modulate = Color(1.0, 1.0, 1.0, 1.0)
				elif ready:
					icon.modulate = Color(1.0, 0.94, 0.72, 0.94)
				else:
					icon.modulate = Color(0.7, 0.7, 0.7, 0.72)


func _find_binding_label(node: Node, binding: String) -> Label:
	if node is Label and str(node.get_meta("text_binding_or_text_key", "")) == binding:
		return node as Label
	for child in node.get_children():
		var found := _find_binding_label(child, binding)
		if found != null:
			return found
	return null


func _find_first_texture_rect(node: Node) -> TextureRect:
	if node is TextureRect:
		return node as TextureRect
	for child in node.get_children():
		var found := _find_first_texture_rect(child)
		if found != null:
			return found
	return null


func _status_window_roots() -> Array:
	var roots := []
	var status_root := _generated_native_root_by_name("Panel_StatusWindowFrame")
	if status_root != null:
		roots.append(status_root)
	var overlay_root := _generated_node_or_null("Section_WindowStack/Panel_StatusWindowFrame")
	if overlay_root != null and not roots.has(overlay_root):
		roots.append(overlay_root)
	return roots


func _status_skill_level_values(skills: Dictionary, materials: Dictionary) -> Dictionary:
	var values := {
		"skill_points.plus_icon": "+" if int(materials.get(200501, 0)) > 0 else "",
		"selected_character.skill_points": "Skill Points: %d" % int(materials.get(200501, 0)),
	}
	for spec in STATUS_SKILL_BINDINGS:
		var item_id := int(spec.get("item_id", 0))
		var item: Dictionary = store.get_item(item_id) if store != null else {}
		var level := _runtime_skill_level(item_id, skills)
		var max_level := _runtime_skill_max_level(item)
		var ready := _runtime_skill_requirements_ready(item, skills)
		if level > 0:
			values[str(spec.get("binding", ""))] = "%d/%d" % [level, max_level]
		elif ready:
			values[str(spec.get("binding", ""))] = "0/%d" % max_level
		else:
			values[str(spec.get("binding", ""))] = "잠김"
	return values


func _sync_runtime_skill_tree_window(model: Dictionary) -> void:
	var window: Variant = generated_runtime_nodes.get("skill_tree_window", null)
	if window == null or not window is Control:
		return
	var progression_snapshot := _progression_snapshot()
	var skills: Dictionary = progression_snapshot.get("skills", {}) if typeof(progression_snapshot.get("skills", {})) == TYPE_DICTIONARY else {}
	var materials: Dictionary = progression_snapshot.get("materials", {}) if typeof(progression_snapshot.get("materials", {})) == TYPE_DICTIONARY else {}
	var points := int(materials.get(200501, 0))
	var player_level := _runtime_player_level()
	var summary: Variant = generated_runtime_nodes.get("skill_tree_summary", null)
	if summary != null and summary is Label:
		(summary as Label).text = "SkillTree: Taskstonebar | Lv.%d | SP %d | 신규 노드 %d | %s" % [
			player_level,
			points,
			RUNTIME_SKILL_TREE_ITEM_IDS.size(),
			"Taskbar mode" if generated_taskbar_mode else "Workshop mode",
		]
	for item_id in RUNTIME_SKILL_TREE_ITEM_IDS:
		var button := (window as Control).get_node_or_null("Panel_RuntimeSkillTreeBody/Content_RuntimeSkillTreeBody/Btn_RuntimeSkillNode_%d" % int(item_id))
		if button == null or not button is Button:
			continue
		var item: Dictionary = store.get_item(int(item_id)) if store != null else {}
		var level := _runtime_skill_level(int(item_id), skills)
		var max_level := _runtime_skill_max_level(item)
		var selected := int(item_id) == generated_selected_skill_item_id
		var unlock_preview: Dictionary = _runtime_skill_unlock_preview(int(item_id), player_level)
		var level_preview: Dictionary = _runtime_skill_level_preview(int(item_id))
		_sync_runtime_skill_node_button(button as Button, int(item_id), item, level, max_level, unlock_preview, level_preview, selected, points, player_level)
	_sync_runtime_skill_tree_footer(points, skills)


func _sync_runtime_skill_node_button(button: Button, item_id: int, item: Dictionary, level: int, max_level: int, unlock_preview: Dictionary, level_preview: Dictionary, selected: bool, points: int, player_level: int) -> void:
	button.text = ""
	button.disabled = false
	button.tooltip_text = _runtime_skill_tooltip(item, level, unlock_preview, level_preview, points, player_level)
	button.modulate = _runtime_skill_node_modulate(level, max_level, unlock_preview, level_preview, selected)
	var icon_node := button.get_node_or_null("Tex_RuntimeSkillNodeIcon")
	if icon_node != null and icon_node is TextureRect:
		var icon_texture := _runtime_skill_icon_texture(item_id, item)
		(icon_node as TextureRect).texture = icon_texture
		(icon_node as TextureRect).visible = icon_texture != null
		(icon_node as TextureRect).modulate = Color(1.0, 1.0, 1.0, 1.0) if level > 0 or bool(unlock_preview.get("ok", false)) else Color(0.72, 0.72, 0.72, 0.78)
	var state_node := button.get_node_or_null("Text_RuntimeSkillNodeState")
	if state_node != null and state_node is Label:
		var label := state_node as Label
		label.text = _runtime_skill_node_status_text(item, level, max_level, unlock_preview)
		label.add_theme_color_override("font_color", Color("#fff0a6") if selected else Color("#f3e6c8"))


func _sync_runtime_skill_tree_footer(points: int, skills: Dictionary) -> void:
	var footer: Variant = generated_runtime_nodes.get("skill_tree_footer", null)
	var learn_button: Variant = generated_runtime_nodes.get("skill_tree_learn", null)
	var level_button: Variant = generated_runtime_nodes.get("skill_tree_level", null)
	var item: Dictionary = store.get_item(generated_selected_skill_item_id) if store != null else {}
	var level := _runtime_skill_level(generated_selected_skill_item_id, skills)
	var max_level := _runtime_skill_max_level(item)
	var player_level := _runtime_player_level()
	var unlock_preview: Dictionary = _runtime_skill_unlock_preview(generated_selected_skill_item_id, player_level)
	var level_preview: Dictionary = _runtime_skill_level_preview(generated_selected_skill_item_id)
	if footer != null and footer is Label:
		var skill: Dictionary = store.get_skill(int(item.get("skillDataId", 0))) if store != null else {}
		var label := footer as Label
		label.text = "%s | Lv %d/%d | CD %.1fs | %s" % [
			_runtime_skill_short_name(item),
			level,
			max_level,
			float(skill.get("cooldown", 0.0)),
			_runtime_skill_preview_reason(unlock_preview) if level <= 0 else _runtime_skill_level_status_text(level_preview, level, max_level),
		]
		label.tooltip_text = _runtime_skill_tooltip(item, level, unlock_preview, level_preview, points, player_level)
	if learn_button != null and learn_button is Button:
		(learn_button as Button).disabled = level > 0 or not bool(unlock_preview.get("ok", false))
		(learn_button as Button).tooltip_text = _runtime_skill_preview_reason(unlock_preview)
	if level_button != null and level_button is Button:
		(level_button as Button).disabled = level <= 0 or level >= max_level or not bool(level_preview.get("ok", false)) or not bool(level_preview.get("can_afford", false))
		(level_button as Button).tooltip_text = _runtime_skill_level_status_text(level_preview, level, max_level)


func _runtime_skill_level(item_id: int, skills: Dictionary) -> int:
	if skills.has(int(item_id)):
		var entry: Dictionary = skills[int(item_id)] if typeof(skills[int(item_id)]) == TYPE_DICTIONARY else {}
		return int(entry.get("level", 0))
	return 0


func _runtime_skill_max_level(item: Dictionary) -> int:
	var popup: Dictionary = item.get("popupArgs", {}) if typeof(item.get("popupArgs", {})) == TYPE_DICTIONARY else {}
	if popup.has("MaxSkillLevel"):
		return maxi(1, int(str(popup.get("MaxSkillLevel", "1"))))
	var max_level := 1
	var groups = item.get("levelUpMaterialItemGroups", [])
	if typeof(groups) == TYPE_ARRAY:
		for group in groups:
			if typeof(group) == TYPE_DICTIONARY:
				max_level = maxi(max_level, int(group.get("level", 0)) + 1)
	return max_level


func _runtime_skill_unlock_cost(item: Dictionary) -> int:
	var popup: Dictionary = item.get("popupArgs", {}) if typeof(item.get("popupArgs", {})) == TYPE_DICTIONARY else {}
	return maxi(0, int(str(popup.get("UnlockCostLevelPoint", "0"))))


func _runtime_skill_unlock_point_item_id(item: Dictionary) -> int:
	var popup: Dictionary = item.get("popupArgs", {}) if typeof(item.get("popupArgs", {})) == TYPE_DICTIONARY else {}
	var point_item_id := int(str(popup.get("LevelPointItemDataId", "200501")))
	return 200501 if point_item_id <= 0 else point_item_id


func _runtime_skill_requirements_ready(item: Dictionary, skills: Dictionary, player_level := -1) -> bool:
	var safe_player_level := _runtime_player_level() if int(player_level) < 0 else int(player_level)
	if safe_player_level < _runtime_skill_required_player_level(item):
		return false
	var required_level := _runtime_skill_required_level(item)
	for required_id in _runtime_skill_required_ids(item):
		if _runtime_skill_level(int(required_id), skills) < required_level:
			return false
	return true


func _runtime_skill_required_ids(item: Dictionary) -> Array:
	var popup: Dictionary = item.get("popupArgs", {}) if typeof(item.get("popupArgs", {})) == TYPE_DICTIONARY else {}
	var ids := _parse_int_list(popup.get("RequiredSkillItemDataIds", ""))
	if ids.is_empty():
		ids = _parse_int_list(item.get("requiredItemDataIds", []))
	return ids


func _runtime_skill_required_level(item: Dictionary) -> int:
	var popup: Dictionary = item.get("popupArgs", {}) if typeof(item.get("popupArgs", {})) == TYPE_DICTIONARY else {}
	return maxi(0, int(str(popup.get("RequiredSkillLevel", "0"))))


func _runtime_skill_required_player_level(item: Dictionary) -> int:
	var popup: Dictionary = item.get("popupArgs", {}) if typeof(item.get("popupArgs", {})) == TYPE_DICTIONARY else {}
	return maxi(1, int(str(popup.get("RequiredPlayerLevel", "1"))))


func _runtime_skill_requirement_names(item: Dictionary) -> String:
	var ids := _runtime_skill_required_ids(item)
	var names := []
	var required_level := _runtime_skill_required_level(item)
	for required_id in ids:
		var required_item: Dictionary = store.get_item(int(required_id)) if store != null else {}
		if required_level > 0:
			names.append("%s Lv.%d" % [str(required_item.get("name", str(required_id))), required_level])
		else:
			names.append(str(required_item.get("name", str(required_id))))
	var required_player_level := _runtime_skill_required_player_level(item)
	if required_player_level > 1:
		names.append("플레이어 Lv.%d" % required_player_level)
	if names.is_empty():
		return "없음"
	return ", ".join(names)


func _runtime_skill_short_name(item: Dictionary) -> String:
	var item_name := str(item.get("name", "Skill"))
	if item_name.ends_with("서"):
		item_name = item_name.substr(0, item_name.length() - 1)
	if item_name.length() > 3:
		return item_name.left(3)
	return item_name


func _runtime_skill_unlock_preview(item_id: int, player_level: int) -> Dictionary:
	if progression == null:
		return {
			"ok": false,
			"error": "progression_missing",
			"message": "진행 상태가 준비되지 않음",
			"skill_item_data_id": int(item_id),
		}
	return progression.skill_unlock_preview(int(item_id), player_level)


func _runtime_skill_level_preview(item_id: int) -> Dictionary:
	if progression == null:
		return {"ok": false, "error": "progression_missing", "message": "진행 상태가 준비되지 않음"}
	return progression.skill_level_up_preview(int(item_id))


func _runtime_skill_icon_texture(item_id: int, item: Dictionary) -> Texture2D:
	if sprites == null:
		return null
	var icon_path := _item_icon_path(item)
	if icon_path == "" and item_id > 0:
		icon_path = _progression_item_icon_path(item_id)
	if icon_path != "":
		var icon_texture: Texture2D = sprites.texture_for_item_icon(icon_path)
		if icon_texture != null:
			return icon_texture
	if item_id > 0:
		return sprites.texture_for_item(item_id)
	return null


func _runtime_skill_node_text(item: Dictionary, level: int, max_level: int, unlock_preview: Dictionary) -> String:
	var second_line := "%d/%d" % [level, max_level]
	if level > 0:
		return "%s\n%s" % [_runtime_skill_short_name(item), second_line]
	if bool(unlock_preview.get("ok", false)):
		second_line = "학습"
	else:
		match str(unlock_preview.get("error", "")):
			"player_level_locked":
				second_line = "Lv%d" % int(unlock_preview.get("required_player_level", _runtime_skill_required_player_level(item)))
			"required_skill_missing", "required_skill_level":
				second_line = "선행"
			"insufficient_materials":
				second_line = "SP%d" % _runtime_skill_unlock_cost(item)
			"skill_already_owned":
				second_line = "%d/%d" % [int(unlock_preview.get("level", level)), max_level]
			_:
				second_line = "잠김"
	return "%s\n%s" % [_runtime_skill_short_name(item), second_line]


func _runtime_skill_node_status_text(item: Dictionary, level: int, max_level: int, unlock_preview: Dictionary) -> String:
	var lines := _runtime_skill_node_text(item, level, max_level, unlock_preview).split("\n")
	if lines.size() >= 2:
		return str(lines[1])
	return "%d/%d" % [level, max_level]


func _runtime_skill_node_modulate(level: int, max_level: int, unlock_preview: Dictionary, level_preview: Dictionary, selected: bool) -> Color:
	if selected:
		return Color(1.22, 1.1, 0.72, 1.0)
	if level > 0 and level >= max_level:
		return Color(0.74, 1.02, 0.96, 1.0)
	if level > 0:
		return Color(0.88, 1.12, 0.92, 1.0) if bool(level_preview.get("can_afford", false)) else Color(0.72, 0.92, 0.78, 0.92)
	if bool(unlock_preview.get("ok", false)):
		return Color(1.0, 0.92, 0.72, 0.98)
	match str(unlock_preview.get("error", "")):
		"insufficient_materials":
			return Color(0.78, 0.64, 0.48, 0.86)
		"player_level_locked":
			return Color(0.48, 0.58, 0.68, 0.72)
		_:
			return Color(0.48, 0.48, 0.48, 0.72)


func _runtime_skill_tooltip(item: Dictionary, level: int, unlock_preview: Dictionary, level_preview: Dictionary, points: int, player_level: int) -> String:
	var lines := [
		str(item.get("name", "스킬")),
		"플레이어 Lv.%d / 보유 SP %d" % [player_level, points],
		"요구: %s" % _runtime_skill_requirement_names(item),
	]
	if level > 0:
		lines.append("스킬 Lv.%d/%d" % [level, _runtime_skill_max_level(item)])
		lines.append(_runtime_skill_level_status_text(level_preview, level, _runtime_skill_max_level(item)))
	else:
		lines.append("학습 비용: %s" % _runtime_skill_unlock_cost_label(item))
		lines.append("상태: %s" % _runtime_skill_preview_reason(unlock_preview))
	return "\n".join(lines)


func _runtime_skill_preview_reason(preview: Dictionary) -> String:
	if bool(preview.get("ok", false)):
		return "학습 가능"
	match str(preview.get("error", "")):
		"skill_already_owned":
			return "이미 학습함"
		"player_level_locked":
			return "플레이어 Lv.%d 필요" % int(preview.get("required_player_level", 1))
		"required_skill_missing", "required_skill_level":
			return _runtime_skill_requirement_missing_label(preview)
		"insufficient_materials":
			return _runtime_skill_cost_missing_label(preview.get("missing_cost", []))
		"progression_missing":
			return "진행 상태 준비 중"
	var message := str(preview.get("message", "잠김"))
	return message if message != "" else "잠김"


func _runtime_skill_requirement_missing_label(preview: Dictionary) -> String:
	var missing = preview.get("missing_requirements", [])
	if typeof(missing) == TYPE_ARRAY:
		for entry in missing:
			if typeof(entry) != TYPE_DICTIONARY:
				continue
			if str(entry.get("type", "")) == "player_level":
				return "플레이어 Lv.%d 필요" % int(entry.get("need", 1))
			return "%s Lv.%d 필요" % [
				str(entry.get("name", "선행 스킬")),
				int(entry.get("need", 1)),
			]
	return "선행 조건 필요"


func _runtime_skill_level_status_text(preview: Dictionary, level: int, max_level: int) -> String:
	if level <= 0:
		return "먼저 학습 필요"
	if level >= max_level:
		return "최대 레벨"
	if not bool(preview.get("ok", false)):
		return str(preview.get("message", preview.get("error", "레벨업 불가")))
	if not bool(preview.get("can_afford", false)):
		return _runtime_skill_cost_missing_label(preview.get("missing", []))
	return "레벨업 가능: %s" % _runtime_skill_cost_label(preview.get("cost", []))


func _runtime_skill_unlock_cost_label(item: Dictionary) -> String:
	var cost := _runtime_skill_unlock_cost(item)
	if cost <= 0:
		return "무료"
	var point_item: Dictionary = store.get_item(_runtime_skill_unlock_point_item_id(item)) if store != null else {}
	return "%s %d" % [str(point_item.get("name", "SP")), cost]


func _runtime_skill_cost_label(cost) -> String:
	if typeof(cost) != TYPE_ARRAY or cost.is_empty():
		return "무료"
	var labels := []
	for entry in cost:
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		labels.append("%s %d" % [str(entry.get("name", "재료")), int(entry.get("count", 0))])
	return ", ".join(labels) if not labels.is_empty() else "무료"


func _runtime_skill_cost_missing_label(missing) -> String:
	if typeof(missing) != TYPE_ARRAY or missing.is_empty():
		return "재료 부족"
	var labels := []
	for entry in missing:
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		labels.append("%s %d/%d" % [
			str(entry.get("name", "재료")),
			int(entry.get("have", 0)),
			int(entry.get("need", 0)),
		])
	return "부족: %s" % ", ".join(labels)


func _runtime_player_level() -> int:
	if sim != null:
		var snapshot: Dictionary = sim.snapshot()
		var player: Dictionary = snapshot.get("player", {}) if typeof(snapshot.get("player", {})) == TYPE_DICTIONARY else {}
		return maxi(1, int(player.get("level", 1)))
	return 1


func _parse_int_list(value) -> Array:
	var result := []
	if typeof(value) == TYPE_ARRAY:
		for entry in value:
			var parsed := int(entry)
			if parsed > 0:
				result.append(parsed)
		return result
	var text := str(value).strip_edges()
	if text == "":
		return result
	for token in text.split(",", false):
		var parsed := int(str(token).strip_edges())
		if parsed > 0:
			result.append(parsed)
	return result


func _modal_host_root() -> Control:
	var keeper_root: Control = generated_native_window_roots.get("keeper", null)
	if keeper_root != null and is_instance_valid(keeper_root):
		return keeper_root
	return generated_ui_overlay


func _ensure_generated_modal_host(root: Control) -> void:
	if root == null:
		return
	var host := root.get_node_or_null(OVERLAY_MODAL_HOST_NAME)
	if host == null:
		host = Control.new()
		host.name = OVERLAY_MODAL_HOST_NAME
		root.add_child(host)
	host.position = Vector2.ZERO
	host.size = root.size
	host.mouse_filter = Control.MOUSE_FILTER_IGNORE
	host.z_index = 1000
	host.top_level = false
	root.move_child(host, root.get_child_count() - 1)
	generated_runtime_nodes["modal_host"] = host
	_ensure_popup_system(host)


func _ensure_popup_system(host: Control) -> void:
	if host == null:
		return
	if popup_system == null:
		popup_system = PopupSystem.new()
	popup_system.setup(host)


func show_popup_alert(config: Dictionary = {}) -> Control:
	var host := _active_generated_modal_host()
	if host == null:
		return null
	_ensure_popup_system(host)
	return popup_system.show_alert(config)


func show_popup_confirm(config: Dictionary = {}) -> Control:
	var host := _active_generated_modal_host()
	if host == null:
		return null
	_ensure_popup_system(host)
	return popup_system.show_confirm(config)


func show_popup_toast(config: Dictionary = {}) -> Control:
	var host := _active_generated_modal_host()
	if host == null:
		return null
	_ensure_popup_system(host)
	return popup_system.show_toast(config)


func close_popup() -> void:
	if popup_system == null:
		return
	popup_system.close_popup()


func _active_generated_modal_host() -> Control:
	var root := _modal_host_root()
	if root == null:
		return null
	_ensure_generated_modal_host(root)
	return generated_runtime_nodes.get("modal_host", null)


func _modal_frame_position(host: Control, frame_size: Vector2, preferred_position: Vector2) -> Vector2:
	if host == null:
		return preferred_position
	if host.size.x >= GENERATED_UI_REFERENCE_SIZE.x * 0.75:
		return preferred_position
	var x := maxf(0.0, (host.size.x - frame_size.x) * 0.5)
	var y := maxf(18.0, (host.size.y - frame_size.y) * 0.5)
	return Vector2(x, y)


func _open_inventory_item_detail_modal(instance_id: int, kind: String) -> void:
	if generated_ui_overlay == null:
		return
	var instance := _progression_instance_for_id(instance_id)
	if instance.is_empty():
		generated_action_message = "상세 열기 실패: 선택한 아이템이 사라졌습니다"
		_refresh_generated_overlay_now()
		return
	var host := _active_generated_modal_host()
	if host == null:
		return
	_clear_generated_modal_host(host)
	host.mouse_filter = Control.MOUSE_FILTER_PASS

	var is_stone := kind == "stone" or _progression_has_tag(instance, "StoneWeapon")
	var title_text := "아이템 상세 정보"
	var detail_lines := _progression_inventory_detail_lines(instance, is_stone)

	var scrim := Button.new()
	scrim.name = "Scrim_ItemDetail"
	scrim.position = Vector2.ZERO
	scrim.size = host.size
	scrim.flat = true
	scrim.mouse_filter = Control.MOUSE_FILTER_STOP
	scrim.add_theme_stylebox_override("normal", _overlay_style(Color(0.02, 0.015, 0.01, 0.42), Color(0, 0, 0, 0), 0, 0))
	scrim.add_theme_stylebox_override("hover", _overlay_style(Color(0.02, 0.015, 0.01, 0.38), Color(0, 0, 0, 0), 0, 0))
	scrim.pressed.connect(_close_inventory_item_detail_modal)
	host.add_child(scrim)

	var frame := Panel.new()
	frame.name = INVENTORY_ITEM_DETAIL_MODAL_NAME
	frame.size = INVENTORY_ITEM_DETAIL_MODAL_RECT.size
	frame.position = _modal_frame_position(host, frame.size, INVENTORY_ITEM_DETAIL_MODAL_RECT.position)
	frame.mouse_filter = Control.MOUSE_FILTER_STOP
	frame.set_meta("runtime_item_detail_instance_id", instance_id)
	frame.set_meta("runtime_item_detail_kind", "stone" if is_stone else "equipment")
	frame.add_theme_stylebox_override("panel", _overlay_texture_style("taskstonebar.ui.window_frame_9slice") if _overlay_texture_style("taskstonebar.ui.window_frame_9slice") != null else _overlay_style(Color("#0a0908"), Color("#d18a24"), 3, 4))
	host.add_child(frame)
	_ensure_program_window_shadow(frame)
	_add_modal_window_ornament(frame)

	var title := Panel.new()
	title.name = "Panel_ItemDetailTitleBar"
	title.position = MODAL_TITLE_INSET
	title.size = Vector2(frame.size.x - MODAL_TITLE_INSET.x * 2.0, MODAL_TITLE_HEIGHT)
	title.add_theme_stylebox_override("panel", _overlay_style(Color("#541e17"), Color("#271713"), 2, 2))
	frame.add_child(title)
	_ensure_reference_modal_header_details(title)

	var detail_title := _make_modal_label(title, "Text_ItemDetailTitle", title_text, Vector2(78.0, 7.0), Vector2(title.size.x - 136.0, 28.0), 18, Color("#ffcf7a"))
	detail_title.z_index = 5

	var close_button := Button.new()
	close_button.name = "Btn_ItemDetailClose"
	close_button.position = Vector2(title.size.x - 34.0, 9.0)
	close_button.size = Vector2(24.0, 24.0)
	close_button.tooltip_text = "닫기"
	close_button.pressed.connect(_close_inventory_item_detail_modal)
	_apply_generated_button_style(close_button, "window_close")
	_ensure_generated_close_icon(close_button)
	close_button.z_index = 6
	title.add_child(close_button)

	var body := Panel.new()
	body.name = "Panel_ItemDetailBody"
	body.position = MODAL_BODY_INSET
	body.size = Vector2(frame.size.x - MODAL_BODY_INSET.x * 2.0, frame.size.y - MODAL_BODY_INSET.y - MODAL_FRAME_CONTENT_BOTTOM - MODAL_FOOTER_HEIGHT - 8.0)
	var body_style: StyleBox = _overlay_texture_style("taskstonebar.ui.dark_inner_well_9slice")
	body.add_theme_stylebox_override("panel", body_style if body_style != null else _overlay_style(Color("#080a0a"), Color("#6b4a2a"), 2, 3))
	frame.add_child(body)

	var preview_back := PanelContainer.new()
	preview_back.name = "Panel_ItemDetailPreviewBack"
	preview_back.position = Vector2(16.0, 16.0)
	preview_back.size = Vector2(96.0, 96.0)
	preview_back.mouse_filter = Control.MOUSE_FILTER_IGNORE
	preview_back.add_theme_stylebox_override("panel", _overlay_style(Color("#10100f"), Color("#3f2f20"), 1, 2))
	body.add_child(preview_back)
	var slot_data := _progression_inventory_detail_slot_data(instance, is_stone)
	_make_inventory_detail_slot(body, "Slot_ItemDetailPreview", Vector2(32.0, 32.0), slot_data)

	var item_name := str(instance.get("name", "아이템"))
	var item_title := _make_modal_label(body, "Text_ItemDetailName", item_name, Vector2(128.0, 18.0), Vector2(286.0, 28.0), 18, Color("#ffcf7a"))
	item_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	var sub_text := _progression_inventory_detail_subtitle(instance, is_stone)
	var sub_label := _make_modal_label(body, "Text_ItemDetailSubtitle", sub_text, Vector2(128.0, 50.0), Vector2(286.0, 22.0), 12, Color("#b79a72"))
	sub_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	var hint := "클릭은 상세만, 소모/장착은 버튼으로 실행합니다."
	var hint_label := _make_modal_label(body, "Text_ItemDetailHint", hint, Vector2(128.0, 78.0), Vector2(286.0, 34.0), 11, Color("#f3e6c8"))
	hint_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT

	var list_back := PanelContainer.new()
	list_back.name = "Panel_ItemDetailStatsBack"
	list_back.position = Vector2(16.0, 130.0)
	list_back.size = Vector2(body.size.x - 32.0, 92.0)
	list_back.mouse_filter = Control.MOUSE_FILTER_IGNORE
	list_back.add_theme_stylebox_override("panel", _overlay_style(Color("#10100f"), Color("#30241a"), 1, 2))
	body.add_child(list_back)
	for line_index in range(mini(detail_lines.size(), 5)):
		var line_label := _make_modal_label(body, "Text_ItemDetailLine%d" % line_index, str(detail_lines[line_index]), Vector2(30.0, 136.0 + float(line_index) * 17.0), Vector2(body.size.x - 60.0, 16.0), 11, Color("#f3e6c8"))
		line_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT

	var owned_chip := PanelContainer.new()
	owned_chip.name = "Panel_ItemDetailOwnedChip"
	owned_chip.position = Vector2(16.0, 240.0)
	owned_chip.size = Vector2(190.0, 28.0)
	owned_chip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	owned_chip.add_theme_stylebox_override("panel", _overlay_style(Color("#251711"), Color("#6a3f26"), 1, 2))
	body.add_child(owned_chip)
	var owned_label := _make_modal_label(body, "Text_ItemDetailOwnedChip", "보유 수량 확인", Vector2(28.0, 244.0), Vector2(166.0, 18.0), 11, Color("#f3e6c8"))
	owned_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT

	var warning_chip := PanelContainer.new()
	warning_chip.name = "Panel_ItemDetailWarningChip"
	warning_chip.position = Vector2(222.0, 240.0)
	warning_chip.size = Vector2(196.0, 28.0)
	warning_chip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	warning_chip.add_theme_stylebox_override("panel", _overlay_style(Color("#391615"), Color("#8f4637"), 1, 2))
	body.add_child(warning_chip)
	var warning_text := "소모 시 복구 불가" if is_stone else "승급 재료는 복구 불가"
	var warning_label := _make_modal_label(body, "Text_ItemDetailWarningChip", warning_text, Vector2(234.0, 244.0), Vector2(172.0, 18.0), 11, Color("#ffcf7a"))
	warning_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT

	var footer_back := PanelContainer.new()
	footer_back.name = "Panel_ItemDetailFooterBack"
	footer_back.position = Vector2(42.0, frame.size.y - MODAL_FRAME_CONTENT_BOTTOM - MODAL_FOOTER_HEIGHT)
	footer_back.size = Vector2(frame.size.x - 84.0, MODAL_FOOTER_HEIGHT)
	footer_back.mouse_filter = Control.MOUSE_FILTER_IGNORE
	footer_back.add_theme_stylebox_override("panel", _overlay_style(Color("#120c08"), Color("#3f2f20"), 1, 2))
	frame.add_child(footer_back)

	var footer := HBoxContainer.new()
	footer.name = "Footer_ItemDetail"
	footer.position = footer_back.position + Vector2(10.0, 6.0)
	footer.size = footer_back.size - Vector2(20.0, 12.0)
	footer.add_theme_constant_override("separation", 8)
	frame.add_child(footer)
	var close := _make_modal_button("Btn_ItemDetailCancel", "닫기", Vector2(88.0, 34.0), "utility_icon")
	close.pressed.connect(_close_inventory_item_detail_modal)
	footer.add_child(close)
	if is_stone:
		var equip := _make_modal_button("Btn_ItemDetailEquip", "장착", Vector2(96.0, 34.0), "inventory_tab")
		equip.pressed.connect(_confirm_inventory_detail_equip_stone)
		footer.add_child(equip)
		var merge := _make_modal_button("Btn_ItemDetailMerge", "드래그 합성", Vector2(112.0, 34.0), "inventory_tab")
		merge.disabled = _progression_stone_merge_ids_for_instance(instance_id).size() < ProgressionState.STONE_SYNTHESIS_COUNT
		merge.pressed.connect(_confirm_inventory_detail_merge_stones)
		footer.add_child(merge)
	else:
		var upgrade := _make_modal_button("Btn_ItemDetailUpgrade", "승급 보기", Vector2(124.0, 34.0), "inventory_tab")
		upgrade.disabled = _progression_equipment_upgrade_ids_for_instance(instance_id).size() < ProgressionState.EQUIPMENT_SYNTHESIS_COUNT
		upgrade.pressed.connect(_open_inventory_detail_equipment_upgrade)
		footer.add_child(upgrade)


func _close_inventory_item_detail_modal() -> void:
	var host: Control = generated_runtime_nodes.get("modal_host", null)
	if host == null:
		return
	_clear_generated_modal_host(host)
	host.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _confirm_inventory_detail_equip_stone() -> void:
	generated_inventory_tab = "stone"
	generated_selected_action = "inventory"
	generated_action_message = _progression_equip_stone_instance(generated_selected_inventory_instance_id)
	_close_inventory_item_detail_modal()
	_refresh_generated_overlay_now()


func _confirm_inventory_detail_merge_stones() -> void:
	generated_inventory_tab = "stone"
	generated_selected_action = "merge"
	generated_action_message = "돌 합성: 인벤토리에서 같은 돌 슬롯끼리 드래그앤드롭하세요"
	_close_inventory_item_detail_modal()
	_refresh_generated_overlay_now()


func _open_inventory_detail_equipment_upgrade() -> void:
	generated_inventory_tab = "equipment"
	generated_selected_action = "upgrade"
	generated_action_message = "장비 승급: 상세에서 선택한 재료 확인"
	_refresh_generated_overlay_now()
	_open_equipment_upgrade_modal()


func _open_equipment_upgrade_modal() -> void:
	if generated_ui_overlay == null:
		return
	var host := _active_generated_modal_host()
	if host == null:
		return
	_clear_generated_modal_host(host)
	host.mouse_filter = Control.MOUSE_FILTER_PASS

	var preview := _progression_equipment_upgrade_preview()
	var scrim := Button.new()
	scrim.name = "Scrim_EquipmentUpgrade"
	scrim.position = Vector2.ZERO
	scrim.size = host.size
	scrim.flat = true
	scrim.mouse_filter = Control.MOUSE_FILTER_STOP
	scrim.add_theme_stylebox_override("normal", _overlay_style(Color(0.02, 0.015, 0.01, 0.46), Color(0, 0, 0, 0), 0, 0))
	scrim.add_theme_stylebox_override("hover", _overlay_style(Color(0.02, 0.015, 0.01, 0.42), Color(0, 0, 0, 0), 0, 0))
	scrim.pressed.connect(_close_equipment_upgrade_modal)
	host.add_child(scrim)

	var frame := Panel.new()
	frame.name = EQUIPMENT_UPGRADE_MODAL_NAME
	frame.size = EQUIPMENT_UPGRADE_MODAL_RECT.size
	frame.position = _modal_frame_position(host, frame.size, EQUIPMENT_UPGRADE_MODAL_RECT.position)
	frame.mouse_filter = Control.MOUSE_FILTER_STOP
	frame.add_theme_stylebox_override("panel", _overlay_texture_style("taskstonebar.ui.window_frame_9slice") if _overlay_texture_style("taskstonebar.ui.window_frame_9slice") != null else _overlay_style(Color("#0a0908"), Color("#d18a24"), 3, 4))
	host.add_child(frame)
	_ensure_program_window_shadow(frame)
	_add_modal_window_ornament(frame)

	var title := Panel.new()
	title.name = "Panel_EquipmentUpgradeTitleBar"
	title.position = MODAL_TITLE_INSET
	title.size = Vector2(frame.size.x - MODAL_TITLE_INSET.x * 2.0, MODAL_TITLE_HEIGHT)
	title.add_theme_stylebox_override("panel", _overlay_style(Color("#541e17"), Color("#271713"), 2, 2))
	frame.add_child(title)
	_ensure_reference_modal_header_details(title)
	var upgrade_title := _make_modal_label(title, "Text_EquipmentUpgradeTitle", "장비 승급", Vector2(78.0, 7.0), Vector2(title.size.x - 136.0, 28.0), 18, Color("#ffcf7a"))
	upgrade_title.z_index = 5

	var close_button := Button.new()
	close_button.name = "Btn_EquipmentUpgradeClose"
	close_button.position = Vector2(title.size.x - 34.0, 9.0)
	close_button.size = Vector2(24.0, 24.0)
	close_button.tooltip_text = "닫기"
	close_button.pressed.connect(_close_equipment_upgrade_modal)
	_apply_generated_button_style(close_button, "window_close")
	_ensure_generated_close_icon(close_button)
	close_button.z_index = 6
	title.add_child(close_button)

	var body := Panel.new()
	body.name = "Panel_EquipmentUpgradeBody"
	body.position = MODAL_BODY_INSET
	body.size = Vector2(frame.size.x - MODAL_BODY_INSET.x * 2.0, frame.size.y - MODAL_BODY_INSET.y - MODAL_FRAME_CONTENT_BOTTOM - MODAL_FOOTER_HEIGHT - 8.0)
	var body_style: StyleBox = _overlay_texture_style("taskstonebar.ui.dark_inner_well_9slice")
	body.add_theme_stylebox_override("panel", body_style if body_style != null else _overlay_style(Color("#080a0a"), Color("#6b4a2a"), 2, 3))
	frame.add_child(body)

	_make_modal_label(body, "Text_EquipmentUpgradeSummary", str(preview.get("message", "")), Vector2(18.0, 14.0), Vector2(body.size.x - 36.0, 34.0), 13, Color("#f3e6c8"))
	_make_modal_label(body, "Text_EquipmentUpgradeCost", "소모 장비 3개", Vector2(34.0, 58.0), Vector2(148.0, 20.0), 12, Color("#b79a72"))
	_make_modal_label(body, "Text_EquipmentUpgradeResult", "획득 예정", Vector2(284.0, 58.0), Vector2(82.0, 20.0), 12, Color("#b79a72"))

	var source_back := PanelContainer.new()
	source_back.name = "Panel_EquipmentUpgradeSourceTray"
	source_back.position = Vector2(18.0, 84.0)
	source_back.size = Vector2(178.0, 68.0)
	source_back.mouse_filter = Control.MOUSE_FILTER_IGNORE
	source_back.add_theme_stylebox_override("panel", _overlay_style(Color("#10100f"), Color("#3f2f20"), 1, 2))
	body.add_child(source_back)

	var result_back := PanelContainer.new()
	result_back.name = "Panel_EquipmentUpgradeResultPreview"
	result_back.position = Vector2(296.0, 84.0)
	result_back.size = Vector2(68.0, 68.0)
	result_back.mouse_filter = Control.MOUSE_FILTER_IGNORE
	result_back.add_theme_stylebox_override("panel", _overlay_style(Color("#10100f"), Color("#8a5b24"), 1, 2))
	body.add_child(result_back)

	var source_slots: Array = preview.get("source_slots", []) if typeof(preview.get("source_slots", [])) == TYPE_ARRAY else []
	for index in range(ProgressionState.EQUIPMENT_SYNTHESIS_COUNT):
		var data: Dictionary = source_slots[index] if index < source_slots.size() and typeof(source_slots[index]) == TYPE_DICTIONARY else {"name": "비어", "count": 0, "badge": "", "rarity": "locked"}
		_make_equipment_upgrade_slot(body, "Slot_UpgradeSource%d" % (index + 1), Vector2(26.0 + 56.0 * float(index), 92.0), data)

	_make_modal_label(body, "Text_EquipmentUpgradeArrow", "→", Vector2(214.0, 104.0), Vector2(48.0, 34.0), 24, Color("#ffcf7a"))
	var result_slot: Dictionary = preview.get("result_slot", {}) if typeof(preview.get("result_slot", {})) == TYPE_DICTIONARY else {"name": "상위", "count": 1, "badge": "?", "rarity": "locked"}
	_make_equipment_upgrade_slot(body, "Slot_UpgradeResult", Vector2(304.0, 92.0), result_slot)

	var note_text := "확인 시 선택된 장비는 되돌릴 수 없습니다."
	if not bool(preview.get("ok", false)):
		note_text = "같은 부위와 등급의 장비 3개가 필요합니다."
	_make_modal_label(body, "Text_EquipmentUpgradeWarning", note_text, Vector2(18.0, 164.0), Vector2(body.size.x - 36.0, 24.0), 12, Color("#ffcf7a"))

	var footer_back := PanelContainer.new()
	footer_back.name = "Panel_EquipmentUpgradeFooterBack"
	footer_back.position = Vector2(73.0, frame.size.y - MODAL_FRAME_CONTENT_BOTTOM - MODAL_FOOTER_HEIGHT)
	footer_back.size = Vector2(292.0, MODAL_FOOTER_HEIGHT)
	footer_back.mouse_filter = Control.MOUSE_FILTER_IGNORE
	footer_back.add_theme_stylebox_override("panel", _overlay_style(Color("#120c08"), Color("#3f2f20"), 1, 2))
	frame.add_child(footer_back)

	var footer := HBoxContainer.new()
	footer.name = "Footer_EquipmentUpgrade"
	footer.position = footer_back.position + Vector2(10.0, 6.0)
	footer.size = footer_back.size - Vector2(20.0, 12.0)
	footer.add_theme_constant_override("separation", 10)
	frame.add_child(footer)
	var cancel := _make_modal_button("Btn_EquipmentUpgradeCancel", "취소", Vector2(104.0, 34.0), "utility_icon")
	cancel.pressed.connect(_close_equipment_upgrade_modal)
	footer.add_child(cancel)
	var confirm := _make_modal_button("Btn_EquipmentUpgradeConfirm", "승급", Vector2(124.0, 34.0), "inventory_tab")
	confirm.disabled = not bool(preview.get("ok", false))
	confirm.pressed.connect(_confirm_equipment_upgrade_modal)
	footer.add_child(confirm)


func _clear_generated_modal_host(host: Control) -> void:
	for child in host.get_children():
		host.remove_child(child)
		child.queue_free()


func _close_equipment_upgrade_modal() -> void:
	var host: Control = generated_runtime_nodes.get("modal_host", null)
	if host == null:
		return
	_clear_generated_modal_host(host)
	host.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _confirm_equipment_upgrade_modal() -> void:
	generated_inventory_tab = "equipment"
	generated_selected_action = "upgrade"
	generated_action_message = _progression_upgrade_equipment()
	_close_equipment_upgrade_modal()
	_refresh_generated_overlay_now()


func _make_equipment_upgrade_slot(parent: Control, node_name: String, pos: Vector2, data: Dictionary) -> Control:
	var slot := NinePatchRect.new()
	slot.name = node_name
	slot.position = pos
	slot.size = Vector2(52.0, 52.0)
	slot.texture = _generated_texture("res://assets/generated/ui/slot_frame_9slice.png")
	slot.patch_margin_left = 18
	slot.patch_margin_right = 18
	slot.patch_margin_top = 18
	slot.patch_margin_bottom = 18
	slot.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(slot)
	_apply_generated_slot_data(slot, data)
	return slot


func _make_inventory_detail_slot(parent: Control, node_name: String, pos: Vector2, data: Dictionary) -> Control:
	var slot := NinePatchRect.new()
	slot.name = node_name
	slot.position = pos
	slot.size = Vector2(64.0, 64.0)
	slot.texture = _generated_texture("res://assets/generated/ui/slot_frame_9slice.png")
	slot.patch_margin_left = 18
	slot.patch_margin_right = 18
	slot.patch_margin_top = 18
	slot.patch_margin_bottom = 18
	slot.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(slot)
	_apply_generated_slot_data(slot, data)
	return slot


func _make_modal_label(parent: Control, node_name: String, text: String, pos: Vector2, label_size: Vector2, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.name = node_name
	label.text = text
	label.position = pos
	label.size = label_size
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	label.add_theme_color_override("font_shadow_color", Color("#050302"))
	label.add_theme_constant_override("shadow_offset_x", 2)
	label.add_theme_constant_override("shadow_offset_y", 2)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.clip_text = true
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(label)
	return label


func _make_modal_button(node_name: String, text: String, button_size: Vector2, role: String) -> Button:
	var button := Button.new()
	button.name = node_name
	button.text = text
	button.custom_minimum_size = button_size
	button.size = button_size
	_apply_generated_button_style(button, role)
	return button


func _generated_runtime_model(snapshot: Dictionary) -> Dictionary:
	var player: Dictionary = snapshot.get("player", {})
	var latest_drop: Dictionary = snapshot.get("latest_drop", {}) if typeof(snapshot.get("latest_drop", {})) == TYPE_DICTIONARY else {}
	var resources: Dictionary = snapshot.get("resources", {}) if typeof(snapshot.get("resources", {})) == TYPE_DICTIONARY else {}
	var progression_snapshot := _progression_snapshot()
	var inventory_stones := _progression_inventory_stones(progression_snapshot)
	var inventory_stone_stats := _progression_stone_stat_summary(inventory_stones)
	var display_resources := resources.duplicate(true)
	var materials: Dictionary = progression_snapshot.get("materials", {}) if typeof(progression_snapshot.get("materials", {})) == TYPE_DICTIONARY else {}
	for binding in [
		{"item_id": 5, "key": "gold"},
		{"item_id": 6, "key": "exp"},
		{"item_id": 200101, "key": "pebble"},
		{"item_id": 200102, "key": "ore"},
		{"item_id": 200103, "key": "catalyst"},
	]:
		display_resources[str(binding.get("key", ""))] = int(materials.get(int(binding.get("item_id", 0)), resources.get(str(binding.get("key", "")), 0)))
	_normalize_generated_inventory_selection(progression_snapshot)
	var portal_progress := _portal_progress_from_snapshot(snapshot)
	return {
		"inventory_tab": generated_inventory_tab,
		"selected_action": generated_selected_action,
		"action_message": generated_action_message,
		"steam_status": "서버 LIVE   Steam SYNC   %s" % ("taskbar companion" if generated_taskbar_mode else "workshop windows"),
		"keeper_level": "Lv.%d 돌팔매꾼" % int(player.get("level", 1)),
		"stone_exp_ratio": _keeper_exp_ratio(player, display_resources),
		"keeper_exp_text": _keeper_exp_text(player, display_resources),
		"crit_text": "치명타 12.4%  드롭 +8%",
		"portal_difficulty": "보통 / Act %d-%d" % [int(portal_progress.get("act", 1)), int(portal_progress.get("stage", 1))],
		"latest_drop": latest_drop,
		"resources": display_resources,
		"stone_slots": _progression_stone_slots(snapshot, display_resources, progression_snapshot),
		"equipment_slots": _progression_equipment_slots(display_resources, progression_snapshot),
		"equipment_loadout_slots": _progression_equipment_loadout_slots(progression_snapshot),
		"active_stone_count": _progression_equipped_stone_count(progression_snapshot),
		"stone_capacity": 12,
		"equipment_owned_count": _progression_equipment_owned_count(progression_snapshot),
		"equipment_capacity": EQUIPMENT_STORAGE_CAPACITY,
		"rune_slots": _mock_rune_slots(),
		"equipped_stones": inventory_stones,
		"equipped_stats": inventory_stone_stats,
		"equipped_skill_ids": progression_snapshot.get("equipped_skill_ids", []),
	}


func _keeper_exp_ratio(player: Dictionary, _resources: Dictionary) -> float:
	var level := maxi(1, int(player.get("level", 1)))
	var current_exp := maxi(0, int(player.get("exp", 0)))
	var needed_exp := int(player.get("required_exp", _keeper_exp_needed(level)))
	if needed_exp <= 0:
		return 1.0
	return clampf(float(current_exp) / float(needed_exp), 0.0, 1.0)


func _keeper_exp_text(player: Dictionary, _resources: Dictionary) -> String:
	var level := maxi(1, int(player.get("level", 1)))
	var current_exp := maxi(0, int(player.get("exp", 0)))
	var needed_exp := int(player.get("required_exp", _keeper_exp_needed(level)))
	if needed_exp <= 0:
		return "EXP MAX"
	return "EXP %d / %d" % [current_exp, needed_exp]


func _keeper_exp_needed(level: int) -> int:
	return maxi(100, 100 + maxi(0, int(level) - 1) * 25)


func _bootstrap_progression_state() -> void:
	if progression == null:
		return
	if sim != null:
		sim.set_progression_state(progression)
	progression.reset()
	progression.set_seed(20260624)
	progression.add_material(200101, 120)
	progression.add_material(200102, 36)
	progression.add_material(200103, 5)
	progression.add_material(200501, 3)
	for _i in range(ProgressionState.STONE_SYNTHESIS_COUNT):
		progression.add_item_instance(200202)
	progression.add_item_instance(200203)
	progression.add_item_instance(200204)
	progression.auto_equip_best_stones()
	_apply_progression_loadout_to_sim()
	for equipment_slot in ["Head", "Chest", "Gloves", "Boots", "Necklace", "Ring"]:
		progression.grant_monster_kill_equipment(111011, 1, {"slot": equipment_slot, "grade": 1})
	for _i in range(ProgressionState.EQUIPMENT_SYNTHESIS_COUNT - 1):
		progression.grant_monster_kill_equipment(111011, 1, {"slot": "Head", "grade": 1})
	progression.learn_skill(200502)


func _progression_snapshot() -> Dictionary:
	if progression == null:
		return {"materials": {}, "items": [], "skills": {}}
	return progression.inventory_snapshot()


func _progression_inventory_stones(progression_snapshot: Dictionary) -> Array:
	var stones := []
	for instance in progression_snapshot.get("items", []):
		if typeof(instance) == TYPE_DICTIONARY and _progression_has_tag(instance, "StoneWeapon"):
			stones.append(instance)
	return stones


func _progression_stone_stat_summary(stones: Array) -> Dictionary:
	var result := {}
	for instance in stones:
		if typeof(instance) != TYPE_DICTIONARY:
			continue
		var stats: Dictionary = instance.get("stats", {}) if typeof(instance.get("stats", {})) == TYPE_DICTIONARY else {}
		for stat_type in stats.keys():
			result[str(stat_type)] = float(result.get(str(stat_type), 0.0)) + float(stats[stat_type])
	return result


func _apply_progression_loadout_to_sim() -> void:
	if progression == null or sim == null:
		return
	var snapshot := _progression_snapshot()
	var stones := _progression_inventory_stones(snapshot)
	var stats := _progression_stone_stat_summary(stones)
	sim.set_player_stat_bonuses(stats)
	sim.set_player_stone_loadout(stones)


func _progression_feed_preview() -> String:
	var snapshot := _progression_snapshot()
	var materials: Dictionary = snapshot.get("materials", {}) if typeof(snapshot.get("materials", {})) == TYPE_DICTIONARY else {}
	return "먹이기 준비: 조약돌 파편 %d개 보유, 돌 EXP 재료로 사용" % int(materials.get(200101, 0))


func _progression_equip_best_stones() -> String:
	if progression == null:
		return "장착 불가: 진행 상태가 준비되지 않음"
	var result: Dictionary = progression.auto_equip_best_stones()
	if not bool(result.get("ok", false)):
		return "장착 실패: %s" % str(result.get("message", result.get("error", "")))
	_apply_progression_loadout_to_sim()
	return _progression_stone_loadout_message()


func _progression_stone_loadout_message() -> String:
	var snapshot := _progression_snapshot()
	var equipped := _progression_inventory_stones(snapshot)
	if equipped.is_empty():
		return "돌 자동장착: 인벤토리 돌 없음"
	var names := []
	for instance in equipped:
		if typeof(instance) == TYPE_DICTIONARY:
			names.append("%s T%d" % [
				_short_item_name(str(instance.get("name", "돌"))),
				int(instance.get("stage", 1)),
			])
	var display_names := names.slice(0, 5)
	if names.size() > display_names.size():
		display_names.append("+%d" % (names.size() - display_names.size()))
	var stats := _progression_stone_stat_summary(equipped)
	return "돌 자동장착: %s | 공격 +%d | 공속 +%.1f%% | 독립 쿨 %d개" % [
		", ".join(display_names),
		int(round(float(stats.get("Attack", 0.0)))),
		float(stats.get("AttackSpeedPercent", 0.0)) + float(stats.get("CooldownPercent", 0.0)),
		equipped.size(),
	]


func _progression_equip_stone_instance(instance_id: int) -> String:
	if progression == null:
		return "돌 장착 불가: 진행 상태가 준비되지 않음"
	var instance := _progression_instance_for_id(instance_id)
	if instance.is_empty() or not _progression_has_tag(instance, "StoneWeapon"):
		return "돌 장착 불가: 선택한 슬롯에 장착 가능한 돌이 없음"
	var result: Dictionary = progression.equip_stone(instance_id)
	if not bool(result.get("ok", false)):
		return "돌 장착 실패: %s" % str(result.get("message", result.get("error", "")))
	_apply_progression_loadout_to_sim()
	return "돌 장착 완료: %s T%d | %s" % [
		_short_item_name(str(instance.get("name", "돌"))),
		int(instance.get("stage", 1)),
		_progression_stone_loadout_message(),
	]


func _progression_merge_stones() -> String:
	if progression == null:
		return "합성 불가: 진행 상태가 준비되지 않음"
	var ids := _progression_stone_merge_ids()
	return _progression_merge_stones_with_ids(ids)


func _progression_merge_stones_with_ids(ids: Array) -> String:
	if progression == null:
		return "합성 불가: 진행 상태가 준비되지 않음"
	if ids.size() < ProgressionState.STONE_SYNTHESIS_COUNT:
		return "합성 불가: 같은 티어 돌 3개 필요"
	var result: Dictionary = progression.synthesize_stones(ids)
	if not bool(result.get("ok", false)):
		return "합성 실패: %s" % str(result.get("message", result.get("error", "")))
	_apply_progression_loadout_to_sim()
	var source_name := _progression_item_name(int(result.get("source_item_data_id", 0)))
	var result_name := str(result.get("result", {}).get("name", _progression_item_name(int(result.get("result_item_data_id", 0)))))
	var result_instance: Dictionary = result.get("result", {}) if typeof(result.get("result", {})) == TYPE_DICTIONARY else {}
	generated_selected_inventory_instance_id = int(result_instance.get("instance_id", 0))
	generated_selected_inventory_kind = "stone"
	return "합성 완료: %s 3개 -> %s Lv.1 | %s" % [source_name, result_name, _progression_stone_loadout_message()]


func _progression_upgrade_equipment() -> String:
	if progression == null:
		return "장비 승급 불가: 진행 상태가 준비되지 않음"
	var ids := _progression_equipment_upgrade_ids()
	if ids.size() < ProgressionState.EQUIPMENT_SYNTHESIS_COUNT:
		return "장비 승급 불가: 같은 등급 장비 3개 필요"
	var result: Dictionary = progression.synthesize_equipment(ids)
	if not bool(result.get("ok", false)):
		return "장비 승급 실패: %s" % str(result.get("message", result.get("error", "")))
	var item: Dictionary = result.get("result", {}) if typeof(result.get("result", {})) == TYPE_DICTIONARY else {}
	return "장비 승급 완료: %s T%d 획득" % [str(item.get("name", "상위 장비")), int(result.get("result_grade", item.get("grade", 0)))]


func _progression_equipment_upgrade_preview() -> Dictionary:
	var ids := _progression_equipment_upgrade_ids()
	var source_slots := []
	var consumed := []
	for raw_id in ids:
		var instance := _progression_instance_for_id(int(raw_id))
		if not instance.is_empty():
			consumed.append(instance)
			source_slots.append(_progression_equipment_slot_data(instance))

	while source_slots.size() < ProgressionState.EQUIPMENT_SYNTHESIS_COUNT:
		source_slots.append({"name": "비어", "count": 0, "badge": "", "rarity": "locked"})

	if consumed.size() < ProgressionState.EQUIPMENT_SYNTHESIS_COUNT:
		return {
			"ok": false,
			"message": "승급 재료 부족: 같은 장비 3개를 모아 주세요.",
			"source_slots": source_slots,
			"result_slot": {"name": "상위", "count": 1, "badge": "?", "rarity": "locked"},
		}

	var source: Dictionary = consumed[0]
	var slot := str(source.get("slot", ""))
	var source_grade := int(source.get("grade", 1))
	var result_grade := source_grade + 1
	var target := _progression_equipment_definition(slot, result_grade)
	var source_name := str(source.get("name", _equipment_slot_label(slot)))
	var result_name := str(target.get("name", "상위 %s" % _equipment_slot_label(slot)))
	return {
		"ok": not target.is_empty(),
		"ids": ids,
		"message": "%s T%d 3개 → %s T%d" % [source_name, source_grade, result_name, result_grade],
		"source_slots": source_slots,
		"result_slot": {
			"name": _short_item_name(result_name),
			"count": 1,
			"badge": "T%d" % result_grade,
			"rarity": "rare" if result_grade >= 3 else "notable",
			"item_data_id": int(target.get("id", 0)),
			"icon_path": _progression_item_icon_path(int(target.get("id", 0))),
			"kind": "equipment",
			"slot": slot,
			"glyph": _equipment_slot_glyph(slot),
		},
	}


func _progression_level_skill() -> String:
	if progression == null:
		return "스킬 레벨업 불가: 진행 상태가 준비되지 않음"
	var result: Dictionary = progression.level_up_skill(200502)
	if not bool(result.get("ok", false)):
		if str(result.get("error", "")) == "skill_max_level":
			return "스킬: 돌팔매 수련 최대 레벨"
		if str(result.get("error", "")) == "skill_not_owned":
			var learned: Dictionary = progression.learn_skill(200502)
			return "스킬 학습: %s" % str(learned.get("skill", {}).get("name", "돌팔매 수련"))
		return "스킬 레벨업 실패: %s" % str(result.get("message", result.get("error", "")))
	var skill: Dictionary = result.get("skill", {}) if typeof(result.get("skill", {})) == TYPE_DICTIONARY else {}
	var delta: Dictionary = result.get("effect_delta", {}) if typeof(result.get("effect_delta", {})) == TYPE_DICTIONARY else {}
	return "스킬 레벨업: %s Lv.%d, 피해 +%.2f" % [
		str(skill.get("name", "돌팔매 수련")),
		int(skill.get("level", 1)),
		float(delta.get("damage_ratio", 0.0)),
	]


func _progression_equipment_selection_message(instance_id: int) -> String:
	var instance := _progression_instance_for_id(instance_id)
	if instance.is_empty() or str(instance.get("category", "")) != "Equipment":
		return "장비 선택 실패: 선택한 슬롯에 장비가 없음"
	var ids := _progression_equipment_upgrade_ids_for_instance(instance_id)
	var slot_label := _equipment_slot_label(str(instance.get("slot", "")))
	var grade := int(instance.get("grade", 1))
	var stat_text := _progression_equipment_stat_text(instance)
	if ids.size() >= ProgressionState.EQUIPMENT_SYNTHESIS_COUNT:
		return "장비 선택: %s T%d | 승급 가능 %d/%d | %s" % [slot_label, grade, ids.size(), ProgressionState.EQUIPMENT_SYNTHESIS_COUNT, stat_text]
	return "장비 선택: %s T%d | 승급 재료 %d/%d | %s" % [slot_label, grade, ids.size(), ProgressionState.EQUIPMENT_SYNTHESIS_COUNT, stat_text]


func _progression_stone_merge_ids() -> Array:
	var selected_ids := _progression_stone_merge_ids_for_instance(generated_selected_inventory_instance_id)
	if selected_ids.size() >= ProgressionState.STONE_SYNTHESIS_COUNT:
		return selected_ids
	var snapshot := _progression_snapshot()
	var groups := {}
	for instance in snapshot.get("items", []):
		if typeof(instance) != TYPE_DICTIONARY:
			continue
		if not _progression_has_tag(instance, "StoneWeapon"):
			continue
		var item_id := int(instance.get("item_data_id", 0))
		if not groups.has(item_id):
			groups[item_id] = []
		var ids: Array = groups[item_id]
		ids.append(int(instance.get("instance_id", 0)))
		groups[item_id] = ids
	var best_ids := []
	var best_item_id := 0
	for item_id in groups.keys():
		var ids: Array = groups[item_id]
		if ids.size() >= ProgressionState.STONE_SYNTHESIS_COUNT and (best_ids.is_empty() or int(item_id) < best_item_id):
			best_ids = ids
			best_item_id = int(item_id)
	return best_ids.slice(0, ProgressionState.STONE_SYNTHESIS_COUNT)


func _progression_stone_merge_ids_for_instance(instance_id: int) -> Array:
	var selected := _progression_instance_for_id(instance_id)
	if selected.is_empty() or not _progression_has_tag(selected, "StoneWeapon"):
		return []
	var item_id := int(selected.get("item_data_id", 0))
	var ids := []
	var snapshot := _progression_snapshot()
	for instance in snapshot.get("items", []):
		if typeof(instance) != TYPE_DICTIONARY:
			continue
		if not _progression_has_tag(instance, "StoneWeapon"):
			continue
		if int(instance.get("item_data_id", 0)) == item_id:
			ids.append(int(instance.get("instance_id", 0)))
	return ids.slice(0, ProgressionState.STONE_SYNTHESIS_COUNT)


func _progression_stone_merge_ids_for_drag(source_instance_id: int, target_instance_id: int) -> Array:
	if source_instance_id <= 0 or target_instance_id <= 0 or source_instance_id == target_instance_id:
		return []
	var source := _progression_instance_for_id(source_instance_id)
	var target := _progression_instance_for_id(target_instance_id)
	if source.is_empty() or target.is_empty():
		return []
	if not _progression_has_tag(source, "StoneWeapon") or not _progression_has_tag(target, "StoneWeapon"):
		return []
	var item_id := int(source.get("item_data_id", 0))
	if item_id <= 0 or int(target.get("item_data_id", 0)) != item_id:
		return []
	var ids := [source_instance_id, target_instance_id]
	var snapshot := _progression_snapshot()
	for instance in snapshot.get("items", []):
		if ids.size() >= ProgressionState.STONE_SYNTHESIS_COUNT:
			break
		if typeof(instance) != TYPE_DICTIONARY:
			continue
		var candidate_id := int(instance.get("instance_id", 0))
		if ids.has(candidate_id):
			continue
		if not _progression_has_tag(instance, "StoneWeapon"):
			continue
		if int(instance.get("item_data_id", 0)) != item_id:
			continue
		ids.append(candidate_id)
	return ids.slice(0, ProgressionState.STONE_SYNTHESIS_COUNT)


func _progression_equipment_upgrade_ids() -> Array:
	var selected_ids := _progression_equipment_upgrade_ids_for_instance(generated_selected_inventory_instance_id)
	if selected_ids.size() >= ProgressionState.EQUIPMENT_SYNTHESIS_COUNT:
		return selected_ids
	var snapshot := _progression_snapshot()
	var groups := {}
	for instance in snapshot.get("items", []):
		if typeof(instance) != TYPE_DICTIONARY:
			continue
		if str(instance.get("category", "")) != "Equipment":
			continue
		var key := "%s:%d" % [str(instance.get("slot", "")), int(instance.get("grade", 0))]
		if not groups.has(key):
			groups[key] = []
		var ids: Array = groups[key]
		ids.append(int(instance.get("instance_id", 0)))
		groups[key] = ids
	for key in groups.keys():
		var ids: Array = groups[key]
		if ids.size() >= ProgressionState.EQUIPMENT_SYNTHESIS_COUNT:
			return ids.slice(0, ProgressionState.EQUIPMENT_SYNTHESIS_COUNT)
	return []


func _progression_equipment_upgrade_ids_for_instance(instance_id: int) -> Array:
	var selected := _progression_instance_for_id(instance_id)
	if selected.is_empty() or str(selected.get("category", "")) != "Equipment":
		return []
	var selected_slot := str(selected.get("slot", ""))
	var selected_grade := int(selected.get("grade", 0))
	var ids := []
	var snapshot := _progression_snapshot()
	for instance in snapshot.get("items", []):
		if typeof(instance) != TYPE_DICTIONARY:
			continue
		if str(instance.get("category", "")) != "Equipment":
			continue
		if str(instance.get("slot", "")) != selected_slot:
			continue
		if int(instance.get("grade", 0)) != selected_grade:
			continue
		ids.append(int(instance.get("instance_id", 0)))
	return ids.slice(0, ProgressionState.EQUIPMENT_SYNTHESIS_COUNT)


func _progression_instance_for_id(instance_id: int) -> Dictionary:
	var snapshot := _progression_snapshot()
	for instance in snapshot.get("items", []):
		if typeof(instance) == TYPE_DICTIONARY and int(instance.get("instance_id", 0)) == int(instance_id):
			return instance
	return {}


func _progression_equipment_slot_data(instance: Dictionary) -> Dictionary:
	return {
		"name": _equipment_slot_label(str(instance.get("slot", ""))),
		"count": int(instance.get("level", 1)),
		"count_text": "Lv.%d" % int(instance.get("level", 1)),
		"badge": "T%d" % int(instance.get("grade", 1)),
		"rarity": "rare" if int(instance.get("grade", 1)) >= 3 else "notable",
		"instance_id": int(instance.get("instance_id", 0)),
		"item_data_id": int(instance.get("item_data_id", 0)),
		"icon_path": _progression_item_icon_path(int(instance.get("item_data_id", 0))),
		"kind": "equipment",
		"slot": str(instance.get("slot", "")),
		"glyph": _equipment_slot_glyph(str(instance.get("slot", ""))),
	}


func _progression_inventory_detail_slot_data(instance: Dictionary, is_stone: bool) -> Dictionary:
	if is_stone:
		return {
			"name": _short_item_name(str(instance.get("name", "돌"))),
			"count": int(instance.get("level", 1)),
			"badge": "T%d" % int(instance.get("stage", 1)),
			"rarity": "equipped" if _progression_is_stone_equipped(int(instance.get("instance_id", 0))) else ("rare" if int(instance.get("stage", 1)) >= 3 else "notable"),
			"instance_id": int(instance.get("instance_id", 0)),
			"item_data_id": int(instance.get("item_data_id", 0)),
			"icon_path": _progression_item_icon_path(int(instance.get("item_data_id", 0))),
			"kind": "stone",
		}
	return _progression_equipment_slot_data(instance)


func _progression_inventory_detail_subtitle(instance: Dictionary, is_stone: bool) -> String:
	if is_stone:
		return "StoneWeapon | Stage %d | Lv.%d" % [int(instance.get("stage", 1)), int(instance.get("level", 1))]
	return "%s | Grade T%d | Lv.%d" % [
		_equipment_slot_label(str(instance.get("slot", ""))),
		int(instance.get("grade", 1)),
		int(instance.get("level", 1)),
	]


func _progression_inventory_detail_lines(instance: Dictionary, is_stone: bool) -> Array:
	var lines := []
	var instance_id := int(instance.get("instance_id", 0))
	if is_stone:
		var merge_ids := _progression_stone_merge_ids_for_instance(instance_id)
		lines.append("장착 상태: 자동 활성")
		lines.append("합성 재료: 같은 돌 %d/%d" % [merge_ids.size(), ProgressionState.STONE_SYNTHESIS_COUNT])
		var skill_ids: Array = instance.get("equip_skill_ids", []) if typeof(instance.get("equip_skill_ids", [])) == TYPE_ARRAY else []
		lines.append("공격 스킬: %s" % _progression_skill_names(skill_ids))
	else:
		var upgrade_ids := _progression_equipment_upgrade_ids_for_instance(instance_id)
		lines.append("부위: %s" % _equipment_slot_label(str(instance.get("slot", ""))))
		lines.append("승급 재료: 같은 부위/등급 %d/%d" % [upgrade_ids.size(), ProgressionState.EQUIPMENT_SYNTHESIS_COUNT])
		lines.append("옵션: %s" % _progression_equipment_option_text(instance))
	var stats: Dictionary = instance.get("stats", {}) if typeof(instance.get("stats", {})) == TYPE_DICTIONARY else {}
	for stat_line in _progression_stat_lines(stats, 3):
		lines.append(stat_line)
	while lines.size() < 5:
		lines.append("추가 정보: 전투 드롭과 합성으로 성장")
	return lines


func _progression_is_stone_equipped(instance_id: int) -> bool:
	var instance := _progression_instance_for_id(instance_id)
	return not instance.is_empty() and _progression_has_tag(instance, "StoneWeapon")


func _progression_skill_names(skill_ids: Array) -> String:
	if skill_ids.is_empty():
		return "없음"
	var names := []
	for raw_id in skill_ids:
		var skill: Dictionary = store.get_skill(int(raw_id)) if store != null else {}
		names.append(str(skill.get("name", "Skill %d" % int(raw_id))))
		if names.size() >= 2:
			break
	return ", ".join(names)


func _progression_equipment_option_text(instance: Dictionary) -> String:
	var options: Array = instance.get("options", []) if typeof(instance.get("options", [])) == TYPE_ARRAY else []
	if options.is_empty():
		return "기본 옵션"
	return "랜덤 옵션 %d개" % options.size()


func _progression_stat_lines(stats: Dictionary, limit: int) -> Array:
	var result := []
	for stat_type in stats.keys():
		result.append("%s +%s" % [str(stat_type), _format_stat_value(float(stats[stat_type]))])
		if result.size() >= limit:
			break
	if result.is_empty():
		result.append("스탯: 없음")
	return result


func _format_stat_value(value: float) -> String:
	if absf(value - roundf(value)) < 0.01:
		return str(int(roundf(value)))
	return "%.2f" % value


func _progression_equipment_stat_text(instance: Dictionary) -> String:
	var stats: Dictionary = instance.get("stats", {}) if typeof(instance.get("stats", {})) == TYPE_DICTIONARY else {}
	var parts := []
	for stat_type in stats.keys():
		parts.append("%s +%d" % [str(stat_type), int(round(float(stats[stat_type])))])
		if parts.size() >= 2:
			break
	if parts.is_empty():
		return "옵션 대기"
	return ", ".join(parts)


func _progression_equipment_definition(slot: String, grade: int) -> Dictionary:
	if store == null:
		return {}
	for item in store.get_records("Items"):
		if typeof(item) != TYPE_DICTIONARY:
			continue
		if str(item.get("category", "")) == "Equipment" and str(item.get("type", "")) == slot and int(item.get("grade", 0)) == int(grade):
			return item
	return {}


func _progression_item_icon_path(item_data_id: int) -> String:
	if store == null or item_data_id <= 0:
		return ""
	return _item_icon_path(store.get_item(item_data_id))


func _item_icon_path(item: Dictionary) -> String:
	var icon_keys := ["Icon", "icon", "spritePath", "Sprite", "sprite"]
	var direct_icon := _first_item_icon_value(item, icon_keys)
	if direct_icon != "":
		return direct_icon
	for group_key in ["spriteGroups", "SpriteGroups", "sprites", "assetPaths", "metadata"]:
		var group_value = item.get(str(group_key), {})
		if typeof(group_value) != TYPE_DICTIONARY:
			continue
		var grouped_icon := _first_item_icon_value(group_value, icon_keys)
		if grouped_icon != "":
			return grouped_icon
	return ""


func _first_item_icon_value(values: Dictionary, icon_keys: Array) -> String:
	for key in icon_keys:
		var value := str(values.get(str(key), ""))
		if value != "":
			return value
	return ""


func _progression_stone_slots(snapshot: Dictionary, resources: Dictionary, progression_snapshot: Dictionary) -> Array:
	var slots := []
	var elapsed_time := float(snapshot.get("elapsed", 0.0))
	var active_index := 0
	for instance in progression_snapshot.get("items", []):
		if typeof(instance) != TYPE_DICTIONARY or not _progression_has_tag(instance, "StoneWeapon"):
			continue
		var instance_id := int(instance.get("instance_id", 0))
		var merge_ids := _progression_stone_merge_ids_for_instance(instance_id)
		var is_equipped := true
		var cooldown = fmod(elapsed_time * (1.25 - minf(0.45, float(active_index) * 0.16)), 1.0)
		var slot := {
			"name": _short_item_name(str(instance.get("name", "돌"))),
			"count": int(instance.get("level", 1)),
			"badge": "착" if is_equipped else "T%d" % int(instance.get("stage", 1)),
			"rarity": "equipped" if is_equipped else ("rare" if int(instance.get("stage", 1)) >= 3 else "notable"),
			"instance_id": instance_id,
			"item_data_id": int(instance.get("item_data_id", 0)),
			"icon_path": _progression_item_icon_path(int(instance.get("item_data_id", 0))),
			"kind": "stone",
			"action": "equip_stone",
			"selected": generated_selected_inventory_kind == "stone" and generated_selected_inventory_instance_id == instance_id,
			"tooltip": "클릭 상세 | 드래그 머지 | 같은 돌 %d/%d" % [merge_ids.size(), ProgressionState.STONE_SYNTHESIS_COUNT],
		}
		if cooldown != null:
			slot["cooldown"] = cooldown
		slots.append(slot)
		if is_equipped:
			active_index += 1
	var materials: Dictionary = progression_snapshot.get("materials", {}) if typeof(progression_snapshot.get("materials", {})) == TYPE_DICTIONARY else {}
	slots.append({"name": "파편", "count": int(materials.get(200101, 0)), "badge": "먹", "rarity": "common", "kind": "material", "item_data_id": 200101, "icon_path": _progression_item_icon_path(200101), "action": "inspect_material", "tooltip": "조약돌 파편: 돌 먹이기와 성장 재료"})
	slots.append({"name": "광석", "count": int(materials.get(200102, 0)), "badge": "승", "rarity": "notable", "kind": "material", "item_data_id": 200102, "icon_path": _progression_item_icon_path(200102), "action": "inspect_material", "tooltip": "이끼 광석: 장비 승급 재료"})
	slots.append({"name": "큐브", "count": int(materials.get(200103, 0)), "badge": "희", "rarity": "rare", "kind": "material", "item_data_id": 200103, "icon_path": _progression_item_icon_path(200103), "action": "inspect_material", "tooltip": "큐브 촉매: 희귀 성장 재료"})
	while slots.size() < INVENTORY_VISIBLE_SLOTS:
		var index := slots.size()
		slots.append({"name": "빈칸", "count": 0, "badge": "", "rarity": "empty", "action": "empty"} if index < INVENTORY_UNLOCKED_SLOTS else {"name": "잠김", "count": 0, "badge": "잠", "rarity": "locked", "action": "locked"})
	return slots


func _progression_equipment_slots(resources: Dictionary, progression_snapshot: Dictionary) -> Array:
	var slots := []
	for instance in progression_snapshot.get("items", []):
		if typeof(instance) != TYPE_DICTIONARY or str(instance.get("category", "")) != "Equipment":
			continue
		var instance_id := int(instance.get("instance_id", 0))
		var upgrade_ids := _progression_equipment_upgrade_ids_for_instance(instance_id)
		slots.append({
			"name": _equipment_slot_label(str(instance.get("slot", ""))),
			"count": int(instance.get("level", 1)),
			"count_text": "Lv.%d" % int(instance.get("level", 1)),
			"badge": "T%d" % int(instance.get("grade", 1)),
			"rarity": "rare" if int(instance.get("grade", 1)) >= 3 else "notable",
			"instance_id": instance_id,
			"item_data_id": int(instance.get("item_data_id", 0)),
			"icon_path": _progression_item_icon_path(int(instance.get("item_data_id", 0))),
			"kind": "equipment",
			"slot": str(instance.get("slot", "")),
			"glyph": _equipment_slot_glyph(str(instance.get("slot", ""))),
			"action": "select_equipment",
			"selected": generated_selected_inventory_kind == "equipment" and generated_selected_inventory_instance_id == instance_id,
			"tooltip": "클릭 선택 | 같은 부위/등급 %d/%d" % [upgrade_ids.size(), ProgressionState.EQUIPMENT_SYNTHESIS_COUNT],
		})
	var materials: Dictionary = progression_snapshot.get("materials", {}) if typeof(progression_snapshot.get("materials", {})) == TYPE_DICTIONARY else {}
	slots.append({"name": "광석", "count": int(materials.get(200102, 0)), "count_text": "x%d" % int(materials.get(200102, 0)), "badge": "보유", "rarity": "notable", "kind": "material", "item_data_id": 200102, "icon_path": _progression_item_icon_path(200102), "action": "inspect_material", "tooltip": "이끼 광석: 장비 승급 재료"})
	slots.append({"name": "촉매", "count": int(materials.get(200103, 0)), "count_text": "x%d" % int(materials.get(200103, 0)), "badge": "보유", "rarity": "rare", "kind": "material", "item_data_id": 200103, "icon_path": _progression_item_icon_path(200103), "action": "inspect_material", "tooltip": "큐브 촉매: 장비 옵션/희귀 성장 재료"})
	while slots.size() < EQUIPMENT_STORAGE_VISIBLE_SLOTS:
		var index := slots.size()
		if index < EQUIPMENT_STORAGE_UNLOCKED_SLOTS:
			slots.append({"name": "대기", "count": 0, "badge": "", "rarity": "empty", "kind": "empty", "glyph": "", "action": "empty", "tooltip": "전투에서 획득한 장비가 들어옵니다"})
		else:
			slots.append({"name": "잠김", "count": 0, "badge": "잠", "rarity": "locked", "kind": "locked", "glyph": "잠", "action": "locked", "tooltip": "전투와 성장으로 해금됩니다"})
	return slots


func _progression_equipment_loadout_slots(progression_snapshot: Dictionary) -> Array:
	var best_by_slot := {}
	for instance in progression_snapshot.get("items", []):
		if typeof(instance) != TYPE_DICTIONARY or str(instance.get("category", "")) != "Equipment":
			continue
		var slot_key := str(instance.get("slot", ""))
		if slot_key == "":
			continue
		var current: Dictionary = best_by_slot.get(slot_key, {}) if typeof(best_by_slot.get(slot_key, {})) == TYPE_DICTIONARY else {}
		var candidate_grade := int(instance.get("grade", 0))
		var current_grade := int(current.get("grade", 0))
		var candidate_level := int(instance.get("level", 0))
		var current_level := int(current.get("level", 0))
		if current.is_empty() or candidate_grade > current_grade or (candidate_grade == current_grade and candidate_level > current_level):
			best_by_slot[slot_key] = instance
	var specs := [
		{"slot": "Head", "name": "투구", "glyph": "투"},
		{"slot": "Chest", "name": "갑옷", "glyph": "갑"},
		{"slot": "Gloves", "name": "장갑", "glyph": "장"},
		{"slot": "Boots", "name": "신발", "glyph": "신"},
		{"slot": "Necklace", "name": "목걸", "glyph": "목"},
		{"slot": "Ring", "name": "반지", "glyph": "반"},
		{"slot": "Skill", "name": "스킬", "glyph": "스"},
		{"slot": "Support", "name": "보조", "glyph": "보"},
	]
	var slots := []
	for spec in specs:
		var slot_key := str(spec.get("slot", ""))
		var instance: Dictionary = best_by_slot.get(slot_key, {}) if typeof(best_by_slot.get(slot_key, {})) == TYPE_DICTIONARY else {}
		if not instance.is_empty():
			var data := _progression_equipment_slot_data(instance)
			data["name"] = str(spec.get("name", data.get("name", "")))
			data["glyph"] = str(spec.get("glyph", data.get("glyph", "")))
			data["action"] = "select_equipment"
			data["instance_id"] = int(instance.get("instance_id", 0))
			data["selected"] = generated_selected_inventory_kind == "equipment" and generated_selected_inventory_instance_id == int(instance.get("instance_id", 0))
			slots.append(data)
		else:
			slots.append({
				"name": str(spec.get("name", "장비")),
				"count": 0,
				"badge": "",
				"rarity": "empty",
				"kind": "equipment_slot",
				"slot": slot_key,
				"glyph": str(spec.get("glyph", "")),
				"action": "empty",
				"tooltip": "%s 장착 슬롯" % str(spec.get("name", "장비")),
			})
	return slots


func _progression_equipped_stone_count(progression_snapshot: Dictionary) -> int:
	return _progression_inventory_stones(progression_snapshot).size()


func _progression_equipment_owned_count(progression_snapshot: Dictionary) -> int:
	var total := 0
	for instance in progression_snapshot.get("items", []):
		if typeof(instance) == TYPE_DICTIONARY and str(instance.get("category", "")) == "Equipment":
			total += 1
	return total


func _normalize_generated_inventory_selection(progression_snapshot: Dictionary) -> void:
	if generated_selected_inventory_instance_id <= 0:
		return
	var wanted_kind := generated_selected_inventory_kind
	for instance in progression_snapshot.get("items", []):
		if typeof(instance) != TYPE_DICTIONARY:
			continue
		if int(instance.get("instance_id", 0)) != generated_selected_inventory_instance_id:
			continue
		if wanted_kind == "stone" and not _progression_has_tag(instance, "StoneWeapon"):
			break
		if wanted_kind == "equipment" and str(instance.get("category", "")) != "Equipment":
			break
		return
	generated_selected_inventory_instance_id = 0
	generated_selected_inventory_kind = ""


func _progression_has_tag(instance: Dictionary, tag: String) -> bool:
	var tags = instance.get("tags", [])
	return typeof(tags) == TYPE_ARRAY and tags.has(tag)


func _progression_item_name(item_id: int) -> String:
	var item: Dictionary = store.get_item(item_id) if store != null else {}
	return str(item.get("name", "item %d" % item_id))


func _short_item_name(item_name: String) -> String:
	if item_name.length() <= 2:
		return item_name
	if item_name.ends_with("돌") and item_name.length() <= 4:
		return item_name.substr(0, item_name.length() - 1)
	return item_name.left(2)


func _equipment_slot_label(slot: String) -> String:
	match slot:
		"Weapon":
			return "무기"
		"Stone":
			return "돌"
		"Head":
			return "투구"
		"Chest":
			return "갑옷"
		"Gloves":
			return "장갑"
		"Boots":
			return "신발"
		"Necklace":
			return "목걸"
		"Ring":
			return "반지"
		"Skill":
			return "스킬"
		"Support":
			return "보조"
	return "장비"


func _equipment_slot_glyph(slot: String) -> String:
	match slot:
		"Weapon":
			return "무"
		"Stone":
			return "돌"
		"Head":
			return "투"
		"Chest":
			return "갑"
		"Gloves":
			return "장"
		"Boots":
			return "신"
		"Necklace":
			return "목"
		"Ring":
			return "반"
		"Skill":
			return "스"
		"Support":
			return "보"
	return "장"


func _mock_stone_slots(snapshot: Dictionary, resources: Dictionary) -> Array:
	var elapsed_time := float(snapshot.get("elapsed", 0.0))
	var slots := [
		{"name": "조약", "count": 3, "badge": "활", "cooldown": fmod(elapsed_time * 1.25, 1.0), "rarity": "common"},
		{"name": "이끼", "count": 2, "badge": "활", "cooldown": fmod(elapsed_time * 0.9 + 0.33, 1.0), "rarity": "notable"},
		{"name": "균열", "count": 1, "badge": "활", "cooldown": fmod(elapsed_time * 0.7 + 0.66, 1.0), "rarity": "rare"},
		{"name": "파편", "count": int(resources.get("pebble", 0)), "badge": "먹", "rarity": "common"},
		{"name": "광석", "count": int(resources.get("ore", 0)), "badge": "승", "rarity": "notable"},
		{"name": "큐브", "count": int(resources.get("catalyst", 0)), "badge": "희", "rarity": "rare"},
		{"name": "합성", "count": 2, "badge": "2:1", "rarity": "notable"},
		{"name": "스킬", "count": int(snapshot.get("skill_cast_count", 0)), "badge": "ON", "rarity": "common"},
	]
	while slots.size() < INVENTORY_VISIBLE_SLOTS:
		var index := slots.size()
		if index < INVENTORY_UNLOCKED_SLOTS:
			slots.append({"name": "빈칸", "count": 0, "badge": "", "rarity": "empty"})
		else:
			slots.append({"name": "잠김", "count": 0, "badge": "잠", "rarity": "locked"})
	return slots


func _mock_equipment_slots(resources: Dictionary) -> Array:
	var ore := int(resources.get("ore", 0))
	var catalyst := int(resources.get("catalyst", 0))
	return [
		{"name": "무기", "count": 1, "badge": "T1", "rarity": "notable"},
		{"name": "보조", "count": 1, "badge": "+2", "rarity": "common"},
		{"name": "룬", "count": 3, "badge": "공", "rarity": "rare"},
		{"name": "펫", "count": 0, "badge": "잠", "rarity": "locked"},
		{"name": "투구", "count": 1, "badge": "착", "rarity": "common"},
		{"name": "갑옷", "count": 1, "badge": "착", "rarity": "common"},
		{"name": "승급", "count": ore, "badge": "%d/12" % mini(ore, 12), "rarity": "notable"},
		{"name": "촉매", "count": catalyst, "badge": "%d/1" % mini(catalyst, 1), "rarity": "rare"},
	]


func _mock_rune_slots() -> Array:
	return [
		{"name": "공격", "count": 2, "badge": "+", "rarity": "notable"},
		{"name": "속도", "count": 1, "badge": "+", "rarity": "common"},
		{"name": "치명", "count": 1, "badge": "+", "rarity": "rare"},
		{"name": "드롭", "count": 3, "badge": "+", "rarity": "notable"},
		{"name": "보스", "count": 0, "badge": "잠", "rarity": "locked"},
		{"name": "큐브", "count": 0, "badge": "잠", "rarity": "locked"},
		{"name": "시장", "count": 0, "badge": "잠", "rarity": "locked"},
		{"name": "클랜", "count": 0, "badge": "잠", "rarity": "locked"},
	]


func _sync_generated_mvp_overlay(model: Dictionary) -> void:
	if generated_ui_overlay == null:
		return
	_sync_generated_tabs(model)
	_sync_generated_inventory_header(model)
	_sync_keeper_exp_bar(model)
	_sync_generated_action_status(model)
	_sync_generated_slot_grid(OVERLAY_INVENTORY_GRID_PATH, model.get("equipment_slots", []) if str(model.get("inventory_tab", "stone")) == "equipment" else model.get("stone_slots", []))
	var loadout_slots: Array = model.get("equipment_loadout_slots", []) if typeof(model.get("equipment_loadout_slots", [])) == TYPE_ARRAY else []
	_sync_generated_slot_grid(OVERLAY_EQUIPMENT_LEFT_PATH, loadout_slots.slice(0, 4))
	_sync_generated_slot_grid(OVERLAY_EQUIPMENT_RIGHT_PATH, loadout_slots.slice(4, 8))
	_sync_generated_slot_grid(OVERLAY_RUNE_GRID_PATH, model.get("rune_slots", []))
	_sync_generated_taskbar_controls()
	_sync_status_window_real_data(model)
	_sync_runtime_skill_tree_window(model)


func _sync_generated_tabs(model: Dictionary) -> void:
	var tab := str(model.get("inventory_tab", "stone"))
	var stone_text := "돌 활성 %d/%d" % [int(model.get("active_stone_count", 0)), int(model.get("stone_capacity", 12))]
	var equipment_text := "장비 %d/%d" % [int(model.get("equipment_owned_count", 0)), int(model.get("equipment_capacity", EQUIPMENT_STORAGE_CAPACITY))]
	_set_generated_button_text_by_path(OVERLAY_STONE_TAB_PATH, stone_text)
	_set_generated_button_text_by_path(OVERLAY_EQUIPMENT_TAB_PATH, equipment_text)
	_set_tab_pressed(OVERLAY_STONE_TAB_PATH, tab == "stone")
	_set_tab_pressed(OVERLAY_EQUIPMENT_TAB_PATH, tab == "equipment")


func _sync_generated_inventory_header(model: Dictionary) -> void:
	var tab := str(model.get("inventory_tab", "stone"))
	var capacity := _generated_node_or_null("Section_WindowStack/Panel_HeroInventoryWindowFrame/Text_InventoryCapacity")
	if capacity != null and capacity is Label:
		(capacity as Label).visible = false
		if tab == "equipment":
			(capacity as Label).text = "보관함 %d/%d" % [int(model.get("equipment_owned_count", 0)), int(model.get("equipment_capacity", EQUIPMENT_STORAGE_CAPACITY))]
		else:
			(capacity as Label).text = "활성 %d/%d" % [int(model.get("active_stone_count", 0)), int(model.get("stone_capacity", 12))]
	var hint := _generated_node_or_null("Section_WindowStack/Panel_HeroInventoryWindowFrame/Text_InventoryModeHint")
	if hint != null and hint is Label:
		(hint as Label).visible = false
		(hint as Label).text = "같은 장비 3개 승급" if tab == "equipment" else "드래그로 같은 돌 합성"


func _sync_keeper_exp_bar(model: Dictionary) -> void:
	var bar_node := _generated_node_or_null("Section_WindowStack/Panel_HeroInventoryWindowFrame/%s" % KEEPER_EXP_BAR_NAME)
	var label_node := _generated_node_or_null("Section_WindowStack/Panel_HeroInventoryWindowFrame/%s" % KEEPER_EXP_LABEL_NAME)
	if bar_node != null and bar_node is ProgressBar:
		(bar_node as ProgressBar).value = clampf(float(model.get("stone_exp_ratio", 0.0)), 0.02, 0.98)
	if label_node != null and label_node is Label:
		(label_node as Label).text = str(model.get("keeper_exp_text", "EXP 0 / 100"))


func _set_tab_pressed(node_path: String, pressed: bool) -> void:
	var button := _generated_node_or_null(node_path)
	if button == null or not button is Button:
		return
	(button as Button).button_pressed = pressed
	if node_path == OVERLAY_STONE_TAB_PATH or node_path == OVERLAY_EQUIPMENT_TAB_PATH:
		_apply_inventory_mode_button_style(button as Button, pressed)
	else:
		(button as Button).modulate = Color(1.18, 1.08, 0.82, 1.0) if pressed else Color(1, 1, 1, 0.86)


func _apply_inventory_mode_button_style(button: Button, pressed: bool) -> void:
	var fill := Color("#682817") if pressed else Color("#181512")
	var border := Color("#ffbd54") if pressed else Color("#5c432c")
	var hover_fill := fill.lightened(0.1)
	var pressed_fill := fill.darkened(0.12)
	button.modulate = Color.WHITE
	button.add_theme_stylebox_override("normal", _overlay_style(fill, border, 2 if pressed else 1, 3))
	button.add_theme_stylebox_override("hover", _overlay_style(hover_fill, Color("#ffd783"), 2, 3))
	button.add_theme_stylebox_override("pressed", _overlay_style(pressed_fill, border, 2, 3))
	button.add_theme_stylebox_override("disabled", _overlay_style(Color("#15110e"), Color("#3a2a1d"), 1, 3))
	button.add_theme_color_override("font_color", Color("#ffcf7a") if pressed else Color("#cdbb9b"))
	button.add_theme_color_override("font_hover_color", Color("#fff0a6"))
	button.add_theme_color_override("font_pressed_color", Color("#f8e6bd"))
	button.add_theme_color_override("font_disabled_color", Color("#6d6252"))


func _sync_generated_action_status(model: Dictionary) -> void:
	var status: Variant = generated_runtime_nodes.get("action_status", null)
	if status == null or not status is Label:
		return
	(status as Label).text = str(model.get("action_message", ""))


func _sync_generated_slot_grid(node_path: String, slot_data) -> void:
	var grid := _generated_node_or_null(node_path)
	if grid == null or not grid is GridContainer:
		return
	var slots: Array = slot_data if typeof(slot_data) == TYPE_ARRAY else []
	var index := 0
	for child in (grid as GridContainer).get_children():
		if child is Control:
			var data: Dictionary = slots[index] if index < slots.size() and typeof(slots[index]) == TYPE_DICTIONARY else {}
			_prepare_generated_inventory_slot(child as Control, node_path, index, data)
			_apply_generated_slot_data(child as Control, data)
			index += 1


func _prepare_generated_inventory_slot(slot: Control, node_path: String, index: int, data: Dictionary) -> void:
	slot.mouse_filter = Control.MOUSE_FILTER_STOP
	slot.set_meta("runtime_slot_grid", node_path)
	slot.set_meta("runtime_slot_index", index)
	slot.set_meta("runtime_slot_data", data.duplicate(true))
	slot.tooltip_text = str(data.get("tooltip", _generated_inventory_slot_tooltip(data)))
	if slot.has_meta("runtime_slot_connected"):
		return
	slot.gui_input.connect(func(event: InputEvent):
		_handle_generated_inventory_slot_input(slot, event)
	)
	slot.set_meta("runtime_slot_connected", true)


func _handle_generated_inventory_slot_input(slot: Control, event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if generated_slot_drag_origin != null:
			_update_generated_inventory_slot_drag(_input_event_global_position(event))
			slot.accept_event()
		return
	if not (event is InputEventMouseButton):
		return
	var mouse := event as InputEventMouseButton
	if mouse.button_index != MOUSE_BUTTON_LEFT:
		return
	var data: Dictionary = slot.get_meta("runtime_slot_data", {}) if typeof(slot.get_meta("runtime_slot_data", {})) == TYPE_DICTIONARY else {}
	var mouse_position := _input_event_global_position(event)
	if mouse.pressed and _is_generated_stone_drag_slot(data):
		_begin_generated_inventory_slot_drag(slot, data, str(slot.get_meta("runtime_slot_grid", "")), int(slot.get_meta("runtime_slot_index", -1)), mouse_position)
		slot.accept_event()
		return
	if not mouse.pressed:
		if generated_slot_drag_origin != null:
			_finish_generated_inventory_slot_drag(mouse_position)
			slot.accept_event()
		return
	_activate_generated_inventory_slot(data, str(slot.get_meta("runtime_slot_grid", "")), int(slot.get_meta("runtime_slot_index", -1)))
	slot.accept_event()


func _handle_generated_inventory_drag_input(event: InputEvent) -> bool:
	if generated_slot_drag_origin == null:
		return false
	if event is InputEventMouseMotion:
		_update_generated_inventory_slot_drag(_input_event_global_position(event))
		return generated_slot_drag_active
	if event is InputEventMouseButton:
		var mouse := event as InputEventMouseButton
		if mouse.button_index == MOUSE_BUTTON_LEFT and not mouse.pressed:
			_finish_generated_inventory_slot_drag(_input_event_global_position(event))
			return true
	return false


func _is_generated_stone_drag_slot(data: Dictionary) -> bool:
	return str(data.get("kind", "")) == "stone" and int(data.get("instance_id", 0)) > 0


func _begin_generated_inventory_slot_drag(slot: Control, data: Dictionary, grid_path: String, index: int, mouse_position: Vector2) -> void:
	generated_slot_drag_origin = slot
	generated_slot_drag_grid_path = grid_path
	generated_slot_drag_index = index
	generated_slot_drag_data = data.duplicate(true)
	generated_slot_drag_start_mouse = mouse_position
	generated_slot_drag_active = false
	generated_selected_inventory_instance_id = int(data.get("instance_id", 0))
	generated_selected_inventory_kind = "stone"


func _update_generated_inventory_slot_drag(mouse_position: Vector2) -> void:
	if generated_slot_drag_origin == null:
		return
	if not generated_slot_drag_active and mouse_position.distance_to(generated_slot_drag_start_mouse) < INVENTORY_SLOT_DRAG_THRESHOLD:
		return
	if not generated_slot_drag_active:
		generated_slot_drag_active = true
		generated_inventory_tab = "stone"
		generated_selected_action = "merge"
		generated_action_message = "돌 합성: 같은 돌 슬롯에 드롭하면 3개를 다음 단계로 합성"
		_refresh_generated_overlay_now()
	_ensure_generated_inventory_drag_preview()
	if generated_slot_drag_preview != null and is_instance_valid(generated_slot_drag_preview):
		var drag_root := generated_slot_drag_preview.get_parent()
		var local_mouse := mouse_position
		if drag_root is CanvasItem:
			local_mouse = (drag_root as CanvasItem).get_global_transform().affine_inverse() * mouse_position
		generated_slot_drag_preview.position = local_mouse - generated_slot_drag_preview.size * 0.5


func _finish_generated_inventory_slot_drag(mouse_position: Vector2) -> void:
	if not generated_slot_drag_active and generated_slot_drag_origin != null and mouse_position.distance_to(generated_slot_drag_start_mouse) >= INVENTORY_SLOT_DRAG_THRESHOLD:
		generated_slot_drag_active = true
	var was_dragging := generated_slot_drag_active
	var data := generated_slot_drag_data.duplicate(true)
	var grid_path := generated_slot_drag_grid_path
	var index := generated_slot_drag_index
	_clear_generated_inventory_drag_preview()
	generated_slot_drag_origin = null
	generated_slot_drag_grid_path = ""
	generated_slot_drag_index = -1
	generated_slot_drag_data = {}
	generated_slot_drag_active = false
	if was_dragging:
		var target_slot := _generated_inventory_slot_at_position(mouse_position)
		generated_inventory_tab = "stone"
		generated_selected_action = "merge"
		generated_selected_inventory_instance_id = int(data.get("instance_id", 0))
		generated_selected_inventory_kind = "stone"
		generated_action_message = _progression_merge_stones_from_drag(data, target_slot)
		_refresh_generated_overlay_now()
		return
	_activate_generated_inventory_slot(data, grid_path, index)


func _ensure_generated_inventory_drag_preview() -> void:
	if generated_ui_overlay == null:
		return
	if generated_slot_drag_preview != null and is_instance_valid(generated_slot_drag_preview):
		return
	var preview_parent: Control = generated_native_window_roots.get("keeper", null)
	if preview_parent == null:
		preview_parent = generated_ui_overlay
	var preview := PanelContainer.new()
	preview.name = "Panel_StoneDragPreview"
	preview.size = Vector2(60.0, 60.0)
	preview.custom_minimum_size = preview.size
	preview.mouse_filter = Control.MOUSE_FILTER_IGNORE
	preview.z_index = 900
	preview.add_theme_stylebox_override("panel", _overlay_style(Color(0.08, 0.05, 0.03, 0.86), Color("#ffcf7a"), 2, 4))
	preview_parent.add_child(preview)
	var preview_data := generated_slot_drag_data.duplicate(true)
	preview_data["selected"] = false
	_apply_generated_slot_data(preview, preview_data)
	preview.modulate = Color(1.18, 1.1, 0.82, 0.88)
	generated_slot_drag_preview = preview


func _clear_generated_inventory_drag_preview() -> void:
	if generated_slot_drag_preview != null and is_instance_valid(generated_slot_drag_preview):
		generated_slot_drag_preview.queue_free()
	generated_slot_drag_preview = null


func _generated_inventory_slot_at_position(mouse_position: Vector2) -> Control:
	if generated_ui_overlay == null:
		return null
	var grid := _generated_node_or_null(OVERLAY_INVENTORY_GRID_PATH)
	if grid == null:
		return null
	for child in grid.get_children():
		if not child is Control:
			continue
		var slot := child as Control
		if slot.get_global_rect().has_point(mouse_position):
			return slot
	return null


func _progression_merge_stones_from_drag(source_data: Dictionary, target_slot: Control) -> String:
	if target_slot == null:
		return "합성 취소: 같은 돌 슬롯 위에 드롭해야 합니다"
	var target_data = target_slot.get_meta("runtime_slot_data", {})
	if typeof(target_data) != TYPE_DICTIONARY:
		return "합성 취소: 드롭 대상 슬롯을 찾을 수 없습니다"
	var source_instance_id := int(source_data.get("instance_id", 0))
	var target_instance_id := int((target_data as Dictionary).get("instance_id", 0))
	if source_instance_id <= 0 or target_instance_id <= 0 or source_instance_id == target_instance_id:
		return "합성 취소: 서로 다른 같은 돌 슬롯에 드롭하세요"
	if str((target_data as Dictionary).get("kind", "")) != "stone":
		return "합성 취소: 돌 슬롯끼리만 합성할 수 있습니다"
	if int(source_data.get("item_data_id", 0)) != int((target_data as Dictionary).get("item_data_id", 0)):
		return "합성 불가: 같은 돌끼리만 머지됩니다"
	var ids := _progression_stone_merge_ids_for_drag(source_instance_id, target_instance_id)
	if ids.size() < ProgressionState.STONE_SYNTHESIS_COUNT:
		return "합성 불가: 같은 돌 3개가 필요합니다"
	return _progression_merge_stones_with_ids(ids)


func _activate_generated_inventory_slot(data: Dictionary, grid_path: String, index: int) -> void:
	var action := str(data.get("action", "inspect"))
	var instance_id := int(data.get("instance_id", 0))
	match action:
		"equip_stone":
			generated_inventory_tab = "stone"
			generated_selected_inventory_instance_id = instance_id
			generated_selected_inventory_kind = "stone"
			generated_selected_action = "inventory"
			generated_action_message = "돌 상세: %s" % str(data.get("name", "돌"))
			_refresh_generated_overlay_now()
			_open_inventory_item_detail_modal(instance_id, "stone")
			return
		"select_equipment":
			generated_inventory_tab = "equipment"
			generated_selected_inventory_instance_id = instance_id
			generated_selected_inventory_kind = "equipment"
			generated_selected_action = "equipment"
			generated_action_message = _progression_equipment_selection_message(instance_id)
			_refresh_generated_overlay_now()
			_open_inventory_item_detail_modal(instance_id, "equipment")
			return
		"open_equipment_upgrade":
			generated_inventory_tab = "equipment"
			generated_selected_action = "upgrade"
			generated_action_message = "장비 승급: 같은 부위/등급 장비 3개를 확인 중"
			_refresh_generated_overlay_now()
			_open_equipment_upgrade_modal()
			return
		"inspect_material":
			generated_selected_action = "inventory"
			generated_action_message = "%s: %s" % [str(data.get("name", "재료")), str(data.get("tooltip", "보유 재료"))]
		"locked":
			generated_action_message = "잠긴 슬롯: 전투와 성장으로 해금됩니다"
		"empty":
			generated_action_message = "빈 슬롯: 전투 드롭이나 합성 결과가 들어옵니다"
		_:
			var slot_label := str(data.get("name", "슬롯"))
			generated_action_message = "%s 슬롯 %d 선택" % [slot_label, maxi(0, index) + 1]
	_refresh_generated_overlay_now()


func _apply_generated_slot_data(slot: Control, data: Dictionary) -> void:
	var compact := slot.size.x <= 42.0
	var kind := str(data.get("kind", ""))
	var name_label := _ensure_slot_label(slot, "Text_ItemName", Vector2(2.0, slot.size.y - (15.0 if compact else 17.0)), Vector2(maxf(26.0, slot.size.x - 4.0), 13.0 if compact else 15.0), 8 if compact else 9, Color("#f3e6c8"))
	var count_label := _ensure_slot_label(slot, "Text_ItemCount", Vector2(2.0, slot.size.y - (27.0 if compact else 29.0)), Vector2(maxf(26.0, slot.size.x - 4.0), 12.0), 7 if compact else 8, Color("#ffcf7a"))
	var badge_label := _ensure_slot_label(slot, "Text_ItemBadge", Vector2(slot.size.x - 23.0, 2.0), Vector2(21.0, 11.0), 7, Color("#1a0f06"))
	var cooldown := _ensure_slot_progress(slot, "Progress_Cooldown", Vector2(4.0, slot.size.y - 6.0), Vector2(maxf(18.0, slot.size.x - 8.0), 4.0))
	var selected_outline := _ensure_slot_selection_outline(slot)
	var icon := _ensure_slot_icon_mark(slot)
	var icon_size := 21.0 if compact else 32.0
	if kind == "equipment" or kind == "equipment_slot":
		icon_size = 25.0 if compact else 40.0
	elif kind == "stone" or kind == "material":
		icon_size = 23.0 if compact else 34.0
	icon.position = Vector2((slot.size.x - icon_size) * 0.5, 6.0 if compact else 8.0)
	icon.size = Vector2(icon_size, icon_size)
	var texture_icon := _ensure_slot_texture_icon(icon)
	var glyph_label := _ensure_slot_label(icon, "Text_ItemGlyph", Vector2.ZERO, icon.size, 10 if compact else 13, Color("#f3e6c8"))
	var item_name := str(data.get("name", ""))
	var count := int(data.get("count", 0))
	var badge := str(data.get("badge", ""))
	var rarity := str(data.get("rarity", "empty"))
	var item_texture := _slot_item_texture(data)
	name_label.text = item_name
	count_label.text = str(data.get("count_text", "" if count <= 0 else "x%d" % count))
	badge_label.text = badge
	badge_label.visible = badge != ""
	cooldown.visible = data.has("cooldown")
	cooldown.value = clampf(float(data.get("cooldown", 0.0)), 0.0, 1.0)
	selected_outline.visible = bool(data.get("selected", false))
	texture_icon.position = Vector2(-3.0, -3.0)
	texture_icon.size = icon.size + Vector2(6.0, 6.0)
	texture_icon.texture = item_texture
	texture_icon.visible = item_texture != null
	glyph_label.text = _slot_glyph_text(data)
	glyph_label.size = icon.size
	glyph_label.visible = item_texture == null and glyph_label.text != ""
	glyph_label.z_index = 4
	icon.visible = item_texture != null or glyph_label.visible or kind == "locked"
	icon.add_theme_stylebox_override("panel", _slot_icon_style(data))
	if kind == "empty":
		count_label.visible = false
	elif kind == "locked":
		count_label.visible = false
	else:
		count_label.visible = count_label.text != ""
	name_label.modulate = Color(1, 1, 1, 0.72) if rarity == "empty" else Color(1, 1, 1, 1)
	slot.modulate = _slot_modulate(rarity)


func _generated_inventory_slot_tooltip(data: Dictionary) -> String:
	var action := str(data.get("action", "inspect"))
	match action:
		"equip_stone":
			return "클릭: 상세 | 드래그: 같은 돌 3개 머지"
		"select_equipment":
			return "클릭: 장비 선택, 승급 재료 확인"
		"open_equipment_upgrade":
			return "클릭: 장비 3개 승급 창 열기"
		"inspect_material":
			return "보유 재료"
		"locked":
			return "잠긴 슬롯"
		"empty":
			return "빈 슬롯"
	return "슬롯 선택"


func _ensure_slot_selection_outline(slot: Control) -> PanelContainer:
	var outline := slot.get_node_or_null("Panel_SelectedOutline")
	var panel: PanelContainer
	if outline != null and outline is PanelContainer:
		panel = outline as PanelContainer
	else:
		panel = PanelContainer.new()
		panel.name = "Panel_SelectedOutline"
		panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
		slot.add_child(panel)
	panel.position = Vector2(-3.0, -3.0)
	panel.size = slot.size + Vector2(6.0, 6.0)
	panel.z_index = 20
	panel.add_theme_stylebox_override("panel", _overlay_style(Color(1.0, 0.82, 0.36, 0.13), Color("#ffcf7a"), 2, 2))
	return panel


func _ensure_slot_label(slot: Control, node_name: String, pos: Vector2, label_size: Vector2, font_size: int, color: Color) -> Label:
	var label := slot.get_node_or_null(node_name)
	if label != null and label is Label:
		(label as Label).position = pos
		(label as Label).size = label_size
		return label
	var created := Label.new()
	created.name = node_name
	created.position = pos
	created.size = label_size
	created.add_theme_font_size_override("font_size", font_size)
	created.add_theme_color_override("font_color", color)
	created.add_theme_color_override("font_shadow_color", Color("#050302"))
	created.add_theme_constant_override("shadow_offset_x", 1)
	created.add_theme_constant_override("shadow_offset_y", 1)
	created.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	created.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	created.clip_text = true
	created.mouse_filter = Control.MOUSE_FILTER_IGNORE
	slot.add_child(created)
	return created


func _ensure_slot_icon_mark(slot: Control) -> PanelContainer:
	var icon := slot.get_node_or_null("Panel_ItemIconMark")
	var panel: PanelContainer
	if icon != null and icon is PanelContainer:
		panel = icon as PanelContainer
	else:
		panel = PanelContainer.new()
		panel.name = "Panel_ItemIconMark"
		panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
		slot.add_child(panel)
	panel.z_index = 2
	return panel


func _ensure_slot_texture_icon(icon: Control) -> TextureRect:
	var texture_node := icon.get_node_or_null("Tex_ItemIcon")
	var texture_rect: TextureRect
	if texture_node != null and texture_node is TextureRect:
		texture_rect = texture_node as TextureRect
	else:
		texture_rect = TextureRect.new()
		texture_rect.name = "Tex_ItemIcon"
		texture_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.add_child(texture_rect)
	texture_rect.z_index = 3
	return texture_rect


func _ensure_slot_progress(slot: Control, node_name: String, pos: Vector2, progress_size: Vector2) -> ProgressBar:
	var progress := slot.get_node_or_null(node_name)
	if progress != null and progress is ProgressBar:
		(progress as ProgressBar).position = pos
		(progress as ProgressBar).size = progress_size
		return progress
	var created := ProgressBar.new()
	created.name = node_name
	created.position = pos
	created.size = progress_size
	created.min_value = 0.0
	created.max_value = 1.0
	created.show_percentage = false
	created.mouse_filter = Control.MOUSE_FILTER_IGNORE
	created.add_theme_stylebox_override("background", _overlay_style(Color("#120c08"), Color("#120c08"), 0, 1))
	created.add_theme_stylebox_override("fill", _overlay_style(Color("#ffcf7a"), Color("#ffcf7a"), 0, 1))
	slot.add_child(created)
	return created


func _slot_modulate(rarity: String) -> Color:
	match rarity:
		"equipped":
			return Color(1.24, 1.12, 0.72, 1.0)
		"rare":
			return Color(1.18, 0.92, 1.08, 1.0)
		"notable":
			return Color(1.04, 1.13, 0.94, 1.0)
		"locked":
			return Color(0.45, 0.45, 0.45, 0.72)
		"empty":
			return Color(0.8, 0.8, 0.8, 0.48)
	return Color(1, 1, 1, 1)


func _slot_item_texture(data: Dictionary) -> Texture2D:
	var item_id := int(data.get("item_data_id", 0))
	if item_id <= 0 or sprites == null:
		return null
	var icon_path := str(data.get("icon_path", ""))
	if icon_path == "":
		icon_path = _progression_item_icon_path(item_id)
	if icon_path != "":
		var icon_texture: Texture2D = sprites.texture_for_item_icon(icon_path)
		if icon_texture != null:
			return icon_texture
	return sprites.texture_for_item(item_id)


func _slot_glyph_text(data: Dictionary) -> String:
	var explicit := str(data.get("glyph", ""))
	if explicit != "":
		return explicit
	match str(data.get("kind", "")):
		"stone":
			return "●"
		"equipment", "equipment_slot":
			return _equipment_slot_glyph(str(data.get("slot", "")))
		"material":
			return "◆"
		"action":
			return "↑"
		"locked":
			return "잠"
	return ""


func _slot_icon_style(data: Dictionary) -> StyleBoxFlat:
	var rarity := str(data.get("rarity", "empty"))
	var kind := str(data.get("kind", ""))
	var fill := Color("#1b1711")
	var border := Color("#3f2f20")
	if kind == "stone":
		fill = Color("#38433a")
		border = Color("#7ad36a")
	elif kind == "equipment" or kind == "equipment_slot":
		fill = Color("#2b1c27")
		border = Color("#d18a24")
	elif kind == "material":
		fill = Color("#182530")
		border = Color("#66bce8")
	elif kind == "action":
		fill = Color("#35220d")
		border = Color("#ffcf7a")
	elif kind == "locked":
		fill = Color("#171717")
		border = Color("#4b4b4b")
	elif rarity == "empty":
		fill = Color("#141411")
		border = Color("#32362d")
	match rarity:
		"equipped":
			border = Color("#ffcf7a")
		"rare":
			border = Color("#6cc8ff")
		"notable":
			border = Color("#7ad36a") if kind == "stone" else border
	return _overlay_style(fill, border, 1, 2)


func _sync_generated_combat_overlay(snapshot: Dictionary, model: Dictionary) -> void:
	if generated_ui_overlay == null:
		return
	_sync_generated_combat_map_texture(snapshot)
	_sync_generated_combat_scene_chrome(snapshot, model)
	_sync_generated_drop_toast(snapshot, model)
	_sync_generated_combat_fx(snapshot)
	_sync_generated_combat_units(snapshot)


func _sync_generated_combat_map_texture(snapshot: Dictionary) -> void:
	var ground := _generated_node_or_null("Section_BottomCombatStrip/Tex_CombatGroundStrip")
	if ground == null or not ground is TextureRect or store == null:
		return
	var map_def: Dictionary = store.get_map(int(snapshot.get("map_id", 500101)))
	var map_index := _taskstonebar_map_visual_index(map_def)
	var texture_path := str(GENERATED_BATTLE_MAP_TEXTURES.get(map_index, GENERATED_BATTLE_MAP_TEXTURES[1]))
	var texture := _generated_texture(texture_path)
	if texture == null:
		return
	var texture_rect := ground as TextureRect
	if texture_rect.texture != texture:
		texture_rect.texture = texture
	texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	texture_rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	texture_rect.modulate = Color(1.08, 1.02, 0.92, 1.0)
	texture_rect.z_index = 0


func _sync_generated_combat_scene_chrome(snapshot: Dictionary, model: Dictionary) -> void:
	_sync_generated_combat_props(snapshot)
	_sync_generated_boss_panel(snapshot)
	_sync_generated_map_progress(snapshot)


func _sync_generated_combat_props(snapshot: Dictionary) -> void:
	var layer_node = generated_runtime_nodes.get("combat_prop_layer", null)
	if layer_node == null or not layer_node is Control:
		return
	var layer := layer_node as Control
	var elapsed := float(snapshot.get("elapsed", 0.0))
	var props := [
		{"name": "Prop_ReedLeft", "pos": Vector2(182.0, 140.0), "size": Vector2(34.0, 54.0), "color": Color("#8fb44a"), "phase": 0.0},
		{"name": "Prop_PalmMid", "pos": Vector2(836.0, 90.0), "size": Vector2(52.0, 76.0), "color": Color("#7ca53d"), "phase": 0.7},
		{"name": "Prop_GrassRight", "pos": Vector2(1258.0, 125.0), "size": Vector2(64.0, 46.0), "color": Color("#9bb64c"), "phase": 1.4},
		{"name": "Prop_RubbleA", "pos": Vector2(618.0, 164.0), "size": Vector2(42.0, 24.0), "color": Color("#594435"), "phase": 0.2},
		{"name": "Prop_RubbleB", "pos": Vector2(1160.0, 168.0), "size": Vector2(50.0, 22.0), "color": Color("#4a3d35"), "phase": 1.2},
	]
	for spec in props:
		var node := _ensure_pixel_prop(layer, str(spec["name"]), spec["pos"], spec["size"], spec["color"])
		node.position.y = float((spec["pos"] as Vector2).y) + sin(elapsed * 1.8 + float(spec["phase"])) * 1.5


func _sync_generated_drop_banner(snapshot: Dictionary, model: Dictionary) -> void:
	var banner_node = generated_runtime_nodes.get("combat_drop_banner", null)
	if banner_node == null or not banner_node is PanelContainer:
		return
	var title_node = generated_runtime_nodes.get("combat_drop_banner_title", null)
	var body_node = generated_runtime_nodes.get("combat_drop_banner_body", null)
	if title_node == null or not title_node is Label or body_node == null or not body_node is Label:
		return
	var latest_drop: Dictionary = model.get("latest_drop", {}) if typeof(model.get("latest_drop", {})) == TYPE_DICTIONARY else {}
	var banner := banner_node as PanelContainer
	var title := title_node as Label
	var body := body_node as Label
	var icon_node = generated_runtime_nodes.get("combat_drop_banner_icon", null)
	var icon_label: Label = icon_node as Label if icon_node != null and icon_node is Label else null
	var elapsed := float(snapshot.get("elapsed", 0.0))
	var age := elapsed - float(latest_drop.get("time", elapsed - 99.0))
	var active := not latest_drop.is_empty() and int(latest_drop.get("item_id", 0)) != GOLD_ITEM_ID and age < 3.8
	banner.visible = active
	title.visible = active
	body.visible = active
	if icon_label != null:
		icon_label.visible = active
	if not active:
		return
	var pulse := 1.0 + maxf(0.0, 1.0 - age / 0.6) * 0.16
	banner.modulate = Color(pulse, pulse, pulse, clampf(1.0 - maxf(0.0, age - 2.9) / 0.9, 0.0, 1.0))
	title.text = "Obtained"
	body.text = str(latest_drop.get("title", latest_drop.get("item_name", "전리품")))


func _sync_generated_skill_panel(snapshot: Dictionary) -> void:
	var panel_node = generated_runtime_nodes.get("combat_skill_panel", null)
	if panel_node == null or not panel_node is PanelContainer:
		return
	var bar_node = generated_runtime_nodes.get("combat_skill_cooldown", null)
	var label_node = generated_runtime_nodes.get("combat_skill_label", null)
	if bar_node == null or not bar_node is ProgressBar or label_node == null or not label_node is Label:
		return
	var elapsed := float(snapshot.get("elapsed", 0.0))
	var ratio := 0.5 + 0.5 * sin(elapsed * 1.2)
	(bar_node as ProgressBar).value = clampf(ratio, 0.0, 1.0)
	(label_node as Label).text = "AUTO"


func _sync_generated_boss_panel(snapshot: Dictionary) -> void:
	var panel_node = generated_runtime_nodes.get("combat_boss_panel", null)
	if panel_node == null or not panel_node is PanelContainer:
		return
	var bar_node = generated_runtime_nodes.get("combat_boss_bar", null)
	var label_node = generated_runtime_nodes.get("combat_boss_label", null)
	if bar_node == null or not bar_node is ProgressBar or label_node == null or not label_node is Label:
		return
	var boss := _boss_or_focus_enemy(snapshot)
	var panel := panel_node as PanelContainer
	panel.visible = not boss.is_empty()
	if boss.is_empty():
		return
	var hp := maxf(0.0, float(boss.get("hp", 0.0)))
	var max_hp := maxf(1.0, float(boss.get("max_hp", 1.0)))
	(bar_node as ProgressBar).value = clampf(hp / max_hp, 0.0, 1.0)
	(label_node as Label).text = str(boss.get("name", "BOSS"))


func _sync_generated_map_progress(snapshot: Dictionary) -> void:
	var panel_node = generated_runtime_nodes.get("combat_map_progress", null)
	var bar_node = generated_runtime_nodes.get("combat_map_progress_bar", null)
	var pointer_node = generated_runtime_nodes.get("combat_map_progress_pointer", null)
	if panel_node == null or not panel_node is Control or bar_node == null or not bar_node is ProgressBar:
		return
	var wave := clampi(int(snapshot.get("wave", 1)), 1, maxi(1, int(snapshot.get("wave_count", 1))))
	var wave_count := maxi(1, int(snapshot.get("wave_count", 1)))
	var wave_time_limit := maxf(1.0, float(snapshot.get("wave_time_limit", 1.0)))
	var wave_elapsed := maxf(0.0, float(snapshot.get("wave_elapsed", 0.0)))
	var wave_ratio := clampf(wave_elapsed / wave_time_limit, 0.0, 1.0)
	var progress := clampf((float(wave - 1) + wave_ratio) / float(wave_count), 0.0, 1.0)
	var bar := bar_node as ProgressBar
	bar.value = progress
	bar.add_theme_stylebox_override("background", _overlay_style(Color("#151118"), Color("#080506"), 1, 1))
	bar.add_theme_stylebox_override("fill", _overlay_style(Color("#a855ff"), Color("#c586ff"), 0, 1))
	if pointer_node != null and pointer_node is Label:
		var pointer := pointer_node as Label
		pointer.position.x = 51.0 + progress * 178.0
		pointer.modulate = Color(1.0, 1.0, 1.0, 0.86 + 0.14 * sin(float(snapshot.get("elapsed", 0.0)) * 5.0))
	var root := panel_node as Control
	for index in range(10):
		var tick := root.get_node_or_null("Rect_MapProgressTick%d" % index)
		if tick != null and tick is ColorRect:
			var threshold := float(index + 1) / 10.0
			(tick as ColorRect).color = Color("#8d56ff") if progress >= threshold else Color("#141315")
	var subtle_route_overlay := bool(root.get_meta("map_progress_route_overlay_subtle", false))
	for index in range(5):
		var route_node := root.get_node_or_null("Panel_MapProgressRouteNode%d" % index)
		if route_node != null and route_node is PanelContainer:
			var threshold := float(index) / 4.0
			var active := progress >= threshold
			var fill := Color(0.95, 0.64, 0.12, 0.56) if active else Color(0.0, 0.0, 0.0, 0.0)
			var border := Color(0.05, 0.03, 0.01, 0.5) if active else Color(0.0, 0.0, 0.0, 0.0)
			if not subtle_route_overlay:
				fill = Color("#d69b2f") if active else Color("#5e5a50")
				border = Color("#16120f")
			(route_node as PanelContainer).add_theme_stylebox_override("panel", _overlay_style(fill, border, 1, 6))
	for index in range(4):
		var route_segment := root.get_node_or_null("Rect_MapProgressRouteSegment%d" % index)
		if route_segment != null and route_segment is ColorRect:
			var threshold := (float(index) + 0.55) / 4.0
			if subtle_route_overlay:
				(route_segment as ColorRect).color = Color(1.0, 0.72, 0.22, 0.5) if progress >= threshold else Color(0.0, 0.0, 0.0, 0.0)
			else:
				(route_segment as ColorRect).color = Color("#c58c2f") if progress >= threshold else Color("#816f55")
	var portal_node := root.get_node_or_null("Tex_MapProgressPortal")
	if portal_node != null and portal_node is TextureRect:
		var portal := portal_node as TextureRect
		var pulse := 0.5 + 0.5 * sin(float(snapshot.get("elapsed", 0.0)) * 2.8)
		if bool(root.get_meta("map_progress_portal_atom_crop", false)):
			portal.modulate = Color(1.0 + pulse * 0.05, 1.0 + pulse * 0.05, 1.0 + pulse * 0.07, 1.0)
			portal.scale = Vector2.ONE
		else:
			portal.modulate = Color(1.04 + pulse * 0.12, 1.04 + pulse * 0.12, 1.08 + pulse * 0.1, 1.0)
			portal.scale = Vector2.ONE * (1.0 + pulse * 0.025)


func _taskstonebar_map_visual_index(map_def: Dictionary) -> int:
	var key := "%s %s" % [str(map_def.get("scene", "")), str(map_def.get("prefab", ""))]
	var marker := "Taskstonebar_"
	var marker_index := key.find(marker)
	if marker_index >= 0:
		var start := marker_index + marker.length()
		var digits := ""
		for index in range(start, key.length()):
			var character := key.substr(index, 1)
			if not character.is_valid_int():
				break
			digits += character
		if digits != "":
			return clampi(int(digits), 1, 10)
	var map_id := int(map_def.get("id", 500101))
	return clampi(int((maxi(0, map_id - 500101) / 10) + 1), 1, 10)


func _sync_generated_combat_units(snapshot: Dictionary) -> void:
	var world_size: Vector2 = snapshot.get("world_size", Vector2(960.0, 160.0))
	var player: Dictionary = snapshot.get("player", {})
	var hero := _generated_node_or_null("Section_BottomCombatStrip/Tex_HeroCombatSprite")
	if hero != null and hero is TextureRect and not player.is_empty():
		var hero_rect := hero as TextureRect
		var hero_size := Vector2(112.0, 112.0)
		var hero_pos := _overlay_world_to_combat(player.get("position", Vector2.ZERO), world_size)
		var attack_flash := float(player.get("attack_flash", 0.0))
		var hit_flash := float(player.get("hit_flash", 0.0))
		if attack_flash > 0.0:
			var attack_phase := clampf(1.0 - attack_flash / 0.22, 0.0, 1.0)
			hero_pos.x += sin(attack_phase * PI) * 12.0
		var hero_texture := _unit_display_texture(player, true, _overlay_hero_frame(float(snapshot.get("elapsed", 0.0)), attack_flash))
		if hero_texture != null:
			hero_rect.texture = hero_texture
			hero_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			hero_rect.stretch_mode = TextureRect.STRETCH_SCALE
		hero_rect.flip_h = true
		hero_rect.size = hero_size
		hero_rect.pivot_offset = hero_size * 0.5
		hero_rect.position = hero_pos - hero_size * 0.5
		var attack_pulse := sin(clampf(attack_flash / 0.22, 0.0, 1.0) * PI)
		var hit_pulse := sin(clampf(hit_flash / 0.18, 0.0, 1.0) * PI)
		hero_rect.scale = Vector2.ONE * (1.0 + attack_pulse * 0.09 + hit_pulse * 0.13)
		hero_rect.modulate = Color(1.62, 0.58, 0.48, 1.0) if hit_flash > 0.0 else Color(1, 1, 1, 1)
	_sync_generated_player_hp(player, world_size)

	var enemy := _tracked_combat_hp_enemy(snapshot)
	var enemy_node := _generated_node_or_null("Section_BottomCombatStrip/Tex_EnemyStackPrototype")
	if enemy_node != null and enemy_node is TextureRect:
		(enemy_node as TextureRect).visible = false
	_sync_generated_enemy_stack(snapshot, world_size)
	_sync_generated_enemy_hp(enemy, world_size, snapshot)


func _sync_generated_player_hp(player: Dictionary, world_size: Vector2) -> void:
	var plate_node = generated_runtime_nodes.get("combat_player_hp_plate", null)
	var bar_node = generated_runtime_nodes.get("combat_player_hp_bar", null)
	var label_node = generated_runtime_nodes.get("combat_player_hp_text", null)
	if plate_node == null or not plate_node is PanelContainer or bar_node == null or not bar_node is ProgressBar or label_node == null or not label_node is Label:
		return
	var hp_plate := plate_node as PanelContainer
	var hp_bar := bar_node as ProgressBar
	var hp_label := label_node as Label
	var visible := not player.is_empty()
	hp_plate.visible = visible
	hp_bar.visible = visible
	hp_label.visible = visible
	if not visible:
		return
	var hp := maxf(0.0, float(player.get("hp", 0.0)))
	var max_hp := maxf(1.0, float(player.get("max_hp", 1.0)))
	var hero_pos := _overlay_world_to_combat(player.get("position", Vector2.ZERO), world_size)
	var hit_flash := float(player.get("hit_flash", 0.0))
	var plate_size := Vector2(88.0, 10.0)
	hp_plate.position = _clamp_combat_plate_position(hero_pos + Vector2(-44.0, -66.0), plate_size)
	hp_plate.size = plate_size
	hp_plate.add_theme_stylebox_override("panel", _combat_hp_plate_style(Color("#d85745"), hit_flash))
	hp_bar.position = hp_plate.position + Vector2(4.0, 3.0)
	hp_bar.size = Vector2(80.0, 4.0)
	hp_bar.value = clampf(hp / max_hp, 0.0, 1.0)
	_style_combat_hp_bar(hp_bar, Color("#d85745"), hit_flash)
	hp_label.visible = false


func _sync_generated_enemy_hp(enemy: Dictionary, world_size: Vector2, snapshot: Dictionary) -> void:
	var plate_node = generated_runtime_nodes.get("combat_enemy_hp_plate", null)
	var bar_node = generated_runtime_nodes.get("combat_enemy_hp_bar", null)
	var name_node = generated_runtime_nodes.get("combat_enemy_name", null)
	var text_node = generated_runtime_nodes.get("combat_enemy_hp_text", null)
	if plate_node == null or not plate_node is PanelContainer or bar_node == null or not bar_node is ProgressBar:
		return
	var hp_plate := plate_node as PanelContainer
	var hp_bar := bar_node as ProgressBar
	var name_label: Label = name_node as Label if name_node != null and name_node is Label else null
	var hp_text: Label = text_node as Label if text_node != null and text_node is Label else null
	var visible := not enemy.is_empty()
	hp_plate.visible = visible
	hp_bar.visible = visible
	if name_label != null:
		name_label.visible = false
	if hp_text != null:
		hp_text.visible = false
	if not visible:
		return
	var enemy_id := int(enemy.get("id", 0))
	var pending_damage := _pending_visual_damage_for_enemy(snapshot, enemy_id)
	var hp := maxf(0.0, float(enemy.get("hp", 0.0)) + pending_damage)
	var max_hp := maxf(1.0, float(enemy.get("max_hp", 1.0)))
	var hit_flash := float(enemy.get("hit_flash", 0.0))
	var enemy_size := _overlay_enemy_size(enemy)
	var enemy_pos := _overlay_enemy_center(enemy, world_size, enemy_size)
	var plate_size := Vector2(48.0, 9.0)
	hp_plate.position = _clamp_combat_plate_position(enemy_pos + Vector2(-plate_size.x * 0.5, -enemy_size.y * 0.5 - 9.0), plate_size)
	hp_plate.size = plate_size
	hp_plate.add_theme_stylebox_override("panel", _combat_hp_plate_style(Color("#d85745"), hit_flash))
	hp_bar.position = hp_plate.position + Vector2(3.0, 3.0)
	hp_bar.size = Vector2(42.0, 3.0)
	hp_bar.value = clampf(hp / max_hp, 0.0, 1.0)
	_style_combat_hp_bar(hp_bar, Color("#d85745"), hit_flash)


func _clamp_combat_plate_position(pos: Vector2, plate_size: Vector2) -> Vector2:
	return Vector2(
		clampf(pos.x, 8.0, 1586.0 - plate_size.x - 8.0),
		clampf(pos.y, 6.0, 236.0 - plate_size.y - 6.0)
	)


func _tracked_combat_hp_enemy(snapshot: Dictionary) -> Dictionary:
	var enemies: Array = snapshot.get("enemies", []) if typeof(snapshot.get("enemies", [])) == TYPE_ARRAY else []
	var attack_target_id := _latest_player_attack_target_id(snapshot)
	if attack_target_id > 0:
		var attack_target := _find_entity(enemies, attack_target_id)
		if not attack_target.is_empty() and bool(attack_target.get("alive", true)):
			generated_combat_hp_enemy_id = attack_target_id
			return attack_target
	if generated_combat_hp_enemy_id > 0:
		var tracked := _find_entity(enemies, generated_combat_hp_enemy_id)
		if not tracked.is_empty() and bool(tracked.get("alive", true)):
			return tracked
	var hit_enemy := _latest_hit_flash_enemy(enemies)
	if not hit_enemy.is_empty():
		generated_combat_hp_enemy_id = int(hit_enemy.get("id", 0))
		return hit_enemy
	var focus := _focus_enemy(snapshot)
	generated_combat_hp_enemy_id = int(focus.get("id", 0)) if not focus.is_empty() else 0
	return focus


func _latest_player_attack_target_id(snapshot: Dictionary) -> int:
	var fx_events: Array = snapshot.get("fx_events", []) if typeof(snapshot.get("fx_events", [])) == TYPE_ARRAY else []
	for index in range(fx_events.size() - 1, -1, -1):
		var event = fx_events[index]
		if typeof(event) == TYPE_DICTIONARY and str((event as Dictionary).get("kind", "")) == "attack":
			return int((event as Dictionary).get("target_id", 0))
	return 0


func _latest_hit_flash_enemy(enemies: Array) -> Dictionary:
	var best := {}
	var best_flash := 0.0
	for enemy in enemies:
		if typeof(enemy) != TYPE_DICTIONARY or not bool((enemy as Dictionary).get("alive", true)):
			continue
		var hit_flash := float((enemy as Dictionary).get("hit_flash", 0.0))
		if hit_flash > best_flash:
			best_flash = hit_flash
			best = enemy
	return best


func _pending_visual_damage_for_enemy(snapshot: Dictionary, enemy_id: int) -> float:
	if enemy_id <= 0:
		return 0.0
	var pending := 0.0
	var fx_events: Array = snapshot.get("fx_events", []) if typeof(snapshot.get("fx_events", [])) == TYPE_ARRAY else []
	for event in fx_events:
		if typeof(event) != TYPE_DICTIONARY:
			continue
		var data := event as Dictionary
		if str(data.get("kind", "")) != "attack" or int(data.get("target_id", 0)) != enemy_id:
			continue
		var duration := maxf(0.05, float(data.get("duration", data.get("ttl", 0.7))))
		var progress := clampf(1.0 - float(data.get("ttl", 0.0)) / duration, 0.0, 1.0)
		if progress < COMBAT_ATTACK_IMPACT_START:
			pending += maxf(0.0, float(data.get("amount", 0.0)))
	return pending


func _sync_generated_enemy_stack(snapshot: Dictionary, world_size: Vector2) -> void:
	var layer_node = generated_runtime_nodes.get("combat_enemy_layer", null)
	if layer_node == null or not layer_node is Control:
		layer_node = _generated_node_or_null("%s/%s" % [OVERLAY_COMBAT_STRIP_PATH, OVERLAY_ENEMY_LAYER_NAME])
	if layer_node == null or not layer_node is Control:
		return
	var layer := layer_node as Control
	var active_names := {}
	var enemies: Array = snapshot.get("enemies", []) if typeof(snapshot.get("enemies", [])) == TYPE_ARRAY else []
	for enemy in enemies:
		if typeof(enemy) != TYPE_DICTIONARY or not bool(enemy.get("alive", true)):
			continue
		var runtime_id := int(enemy.get("id", 0))
		if runtime_id <= 0:
			continue
		var node_name := "RuntimeEnemy_%d" % runtime_id
		var shadow_name := "RuntimeEnemyShadow_%d" % runtime_id
		active_names[node_name] = true
		active_names[shadow_name] = true
		var enemy_rect := _runtime_enemy_texture_rect(layer, node_name)
		var enemy_shadow := _runtime_enemy_shadow(layer, shadow_name)
		var enemy_size := _overlay_enemy_size(enemy)
		var enemy_pos := _overlay_enemy_center(enemy, world_size, enemy_size)
		var enemy_texture := _unit_display_texture(enemy, false)
		if enemy_texture != null:
			enemy_rect.texture = enemy_texture
		elif sprites != null:
			enemy_rect.texture = sprites.get_texture("monster_basic")
		enemy_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		enemy_rect.stretch_mode = TextureRect.STRETCH_SCALE
		enemy_rect.visible = true
		enemy_rect.flip_h = _unit_display_flip_h(enemy, false)
		enemy_rect.size = enemy_size
		enemy_rect.pivot_offset = enemy_size * 0.5
		enemy_rect.position = enemy_pos - enemy_size * 0.5
		enemy_rect.z_index = 118 + int(round(enemy_pos.y))
		enemy_rect.z_as_relative = false
		enemy_shadow.visible = true
		enemy_shadow.size = Vector2(enemy_size.x * 0.76, 14.0)
		enemy_shadow.position = enemy_pos + Vector2(-enemy_shadow.size.x * 0.5, enemy_size.y * 0.34)
		enemy_shadow.z_index = enemy_rect.z_index - 2
		enemy_shadow.z_as_relative = false
		var hit_flash := float(enemy.get("hit_flash", 0.0))
		var attack_flash := float(enemy.get("attack_flash", 0.0))
		var hit_pulse := sin(clampf(hit_flash / 0.18, 0.0, 1.0) * PI)
		var attack_pulse := sin(clampf(attack_flash / 0.24, 0.0, 1.0) * PI)
		enemy_rect.scale = Vector2.ONE * (1.0 + maxf(hit_pulse * 0.18, attack_pulse * 0.1))
		enemy_shadow.scale = Vector2.ONE * (1.0 + maxf(hit_pulse * 0.12, attack_pulse * 0.06))
		enemy_rect.modulate = Color(1.75, 0.54, 0.42, 1.0) if hit_flash > 0.0 else Color(1.16, 1.12, 1.04, 1.0)
	for child in layer.get_children():
		if (str(child.name).begins_with("RuntimeEnemy_") or str(child.name).begins_with("RuntimeEnemyShadow_")) and not active_names.has(str(child.name)):
			child.queue_free()


func _runtime_enemy_texture_rect(parent: Control, node_name: String) -> TextureRect:
	var node := parent.get_node_or_null(node_name)
	if node != null and node is TextureRect:
		return node as TextureRect
	var rect := TextureRect.new()
	rect.name = node_name
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	rect.stretch_mode = TextureRect.STRETCH_SCALE
	parent.add_child(rect)
	return rect


func _runtime_enemy_shadow(parent: Control, node_name: String) -> Panel:
	var node := parent.get_node_or_null(node_name)
	if node != null and node is Panel:
		return node as Panel
	var shadow := Panel.new()
	shadow.name = node_name
	shadow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	shadow.add_theme_stylebox_override("panel", _overlay_style(Color(0.03, 0.018, 0.01, 0.62), Color(0.0, 0.0, 0.0, 0.0), 0, 8))
	parent.add_child(shadow)
	return shadow


func _sync_generated_drop_toast(snapshot: Dictionary, model: Dictionary) -> void:
	var toast := _generated_node_or_null(OVERLAY_DROP_TOAST_PATH)
	if toast == null or not toast is CanvasItem:
		return
	if toast is Control:
		var toast_control := toast as Control
		toast_control.position = Vector2(683.0, 20.0)
		toast_control.size = Vector2(220.0, 70.0)
		toast_control.z_index = 98
	var latest_drop: Dictionary = model.get("latest_drop", {}) if typeof(model.get("latest_drop", {})) == TYPE_DICTIONARY else {}
	var canvas := toast as CanvasItem
	if latest_drop.is_empty() or int(latest_drop.get("item_id", 0)) == GOLD_ITEM_ID:
		canvas.visible = false
		return
	canvas.visible = true
	var age := float(snapshot.get("elapsed", 0.0)) - float(latest_drop.get("time", 0.0))
	var pulse := 1.0 + maxf(0.0, 1.0 - age / 1.2) * 0.18
	canvas.modulate = Color(pulse, 1.0, pulse, 1.0)
	var icon := _generated_node_or_null("Section_BottomCombatStrip/Panel_RareDropToast/Icon_RareDrop")
	if icon != null and icon is TextureRect and sprites != null:
			var texture: Texture2D = sprites.texture_for_item(int(latest_drop.get("item_id", 0)))
			if texture != null:
				(icon as TextureRect).texture = texture


func _runtime_enemy_hp_text(snapshot: Dictionary) -> String:
	var enemy := _focus_enemy(snapshot)
	if enemy.is_empty():
		return "ENEMY 대기"
	var hp := maxf(0.0, float(enemy.get("hp", 0.0)))
	var max_hp := maxf(1.0, float(enemy.get("max_hp", 1.0)))
	return "%s HP %d/%d" % [
		str(enemy.get("name", "몬스터")),
		int(round(hp)),
		int(round(max_hp)),
	]


func _sync_generated_combat_fx(snapshot: Dictionary) -> void:
	var layer: Variant = generated_runtime_nodes.get("combat_layer", null)
	if layer == null or not layer is Control:
		return
	for child in (layer as Control).get_children():
		child.free()
	var layer_size := (layer as Control).size
	var world_size: Vector2 = snapshot.get("world_size", Vector2(960.0, 160.0))
	var player: Dictionary = snapshot.get("player", {})
	var player_pos := _overlay_world_to_combat(player.get("position", Vector2.ZERO), world_size)
	var enemies: Array = snapshot.get("enemies", []) if typeof(snapshot.get("enemies", [])) == TYPE_ARRAY else []
	var fx_events: Array = snapshot.get("fx_events", []) if typeof(snapshot.get("fx_events", [])) == TYPE_ARRAY else []
	for event in fx_events:
		if typeof(event) != TYPE_DICTIONARY:
			continue
		var duration := maxf(0.05, float(event.get("duration", event.get("ttl", 0.7))))
		var progress := clampf(1.0 - float(event.get("ttl", 0.0)) / duration, 0.0, 1.0)
		var fade := clampf(float(event.get("ttl", 0.0)) / duration, 0.0, 1.0)
		match str(event.get("kind", "")):
			"gold_drop":
				var gold_position: Vector2 = event.get("position", Vector2(805.0, 80.0))
				var gold_pos := _overlay_world_to_combat(gold_position, world_size) + COMBAT_ENEMY_VISUAL_SHIFT
				var coin_texture: Texture2D = sprites.texture_for_item(GOLD_ITEM_ID) if sprites != null else null
				var count := int(event.get("count", 0))
				for coin_index in range(4):
					var side := float(coin_index) - 1.5
					var coin_progress := clampf(progress + float(coin_index) * 0.06, 0.0, 1.0)
					var coin_center := gold_pos + Vector2(side * 18.0, -18.0 - 42.0 * coin_progress + sin(coin_progress * PI) * -10.0)
					var coin_size := Vector2.ONE * (24.0 + 4.0 * sin(coin_progress * PI))
					_add_runtime_texture(layer as Control, coin_texture, coin_center - coin_size * 0.5, coin_size, Color(1.0, 0.92, 0.45, fade))
				_add_runtime_label(layer as Control, "+%d" % count, gold_pos + Vector2(-48.0, -74.0 - 20.0 * progress), Vector2(112.0, 28.0), 20, Color("#ffcf7a"), fade)
			"spawn":
				var spawn_position: Vector2 = event.get("position", Vector2(980.0, 80.0))
				var spawn_enemy := _find_entity(enemies, int(event.get("target_id", 0)))
				var spawn_pos := _overlay_enemy_center(spawn_enemy, world_size) if not spawn_enemy.is_empty() else _overlay_world_to_combat(spawn_position, world_size) + COMBAT_ENEMY_VISUAL_SHIFT
				var spawn_key := str(event.get("fx_key", "fx_mob_spawn"))
				var spawn_size := Vector2.ONE * float(event.get("size", 58.0))
				_add_runtime_effect(layer as Control, spawn_key, spawn_pos, spawn_size, progress, Color(1, 1, 1, fade))
			"attack":
				var target := _find_entity(enemies, int(event.get("target_id", 0)))
				var target_pos := _overlay_enemy_center(target, world_size) if not target.is_empty() else _overlay_world_to_combat(Vector2(805.0, 80.0), world_size) + COMBAT_ENEMY_VISUAL_SHIFT
				var skill_id := int(event.get("skill_id", 0))
				var style := _enemy_skill_fx_style(skill_id)
				var color: Color = style.get("color", Color("#ffcf7a"))
				var impact_start := float(style.get("impact_start", COMBAT_ATTACK_IMPACT_START))
				var travel_progress := clampf(progress / maxf(0.05, impact_start), 0.0, 1.0)
				var projectile_pos := player_pos.lerp(target_pos, travel_progress)
				projectile_pos.y -= sin(travel_progress * PI) * float(style.get("arc", 18.0))
				var cast_key := str(style.get("cast", ""))
				if cast_key != "" and progress < 0.46:
					_add_runtime_effect(layer as Control, cast_key, player_pos, Vector2.ONE * float(style.get("cast_size", 42.0)), clampf(progress / 0.46, 0.0, 1.0), Color(1, 1, 1, fade))
				var projectile_key := str(style.get("projectile", ""))
				if projectile_key != "" and progress < COMBAT_PROJECTILE_HIDE_PROGRESS:
					var texture_size := Vector2.ONE * float(style.get("projectile_size", 30.0))
					_add_runtime_effect(layer as Control, projectile_key, projectile_pos, texture_size, travel_progress, Color(1, 1, 1, fade))
				var impact_key := str(style.get("impact_texture", ""))
				if impact_key != "" and progress >= impact_start:
					var impact_progress := clampf((progress - impact_start) / maxf(0.05, 1.0 - impact_start), 0.0, 1.0)
					var impact_size := float(style.get("impact_size", 36.0))
					_add_runtime_effect(layer as Control, impact_key, target_pos, Vector2.ONE * impact_size * 0.92, impact_progress, Color(1, 1, 1, fade * 0.52))
					_add_runtime_effect(layer as Control, "fx_hit_white", target_pos + Vector2(0.0, -3.0), Vector2.ONE * maxf(38.0, impact_size * 0.72), impact_progress, Color(1.0, 0.88, 0.68, fade * 0.38))
				var action_text := str(event.get("skill_name", "돌팔매")) if skill_id >= 300101 and skill_id <= 300111 else str(event.get("skill_name", "스킬"))
				_add_runtime_label(layer as Control, action_text, player_pos + Vector2(-48.0, -72.0 - 14.0 * progress), Vector2(120.0, 24.0), 14, color, fade)
				if progress >= impact_start:
					var label_progress := clampf((progress - impact_start) / maxf(0.05, 1.0 - impact_start), 0.0, 1.0)
					var hit_lane := int(event.get("source_stone_instance_id", 0)) % 3
					var hit_pos := target_pos + Vector2(12.0 + float(hit_lane) * 28.0, -70.0 - float(hit_lane) * 10.0 - 24.0 * label_progress)
					_add_runtime_label(layer as Control, "-%d" % int(round(float(event.get("amount", 0.0)))), hit_pos, Vector2(82.0, 30.0), 22, color.lightened(0.38), fade)
			"enemy_skill":
				var source := _find_entity(enemies, int(event.get("source_id", 0)))
				var source_pos := _overlay_enemy_center(source, world_size) if not source.is_empty() else _overlay_world_to_combat(Vector2(805.0, 80.0), world_size) + COMBAT_ENEMY_VISUAL_SHIFT
				var skill_name := str(event.get("skill_name", "스킬"))
				var skill_id := int(event.get("skill_id", 0))
				var style := _enemy_skill_fx_style(skill_id)
				var color: Color = style.get("color", Color("#ff8a3c"))
				var skill_pos := source_pos.lerp(player_pos, progress)
				skill_pos.y -= sin(progress * PI) * float(style.get("arc", 10.0))
				_add_runtime_label(layer as Control, skill_name, source_pos + Vector2(-54.0, -78.0), Vector2(126.0, 24.0), 13, color, fade)
				var cast_key := str(style.get("cast", ""))
				if cast_key != "" and progress < 0.5:
					_add_runtime_effect(layer as Control, cast_key, source_pos, Vector2.ONE * float(style.get("cast_size", 46.0)), clampf(progress / 0.5, 0.0, 1.0), Color(1, 1, 1, fade))
				var projectile_key := str(style.get("projectile", ""))
				if projectile_key != "" and progress < 0.84:
					_add_runtime_effect(layer as Control, projectile_key, skill_pos, Vector2.ONE * float(style.get("projectile_size", 34.0)), progress, Color(1, 1, 1, fade))
				var impact_key := str(style.get("impact_texture", ""))
				if impact_key != "" and progress > 0.34:
					var impact_progress := clampf((progress - 0.34) / 0.66, 0.0, 1.0)
					var impact_size := float(style.get("impact_size", 42.0))
					_add_runtime_effect(layer as Control, impact_key, player_pos, Vector2.ONE * impact_size * 0.94, impact_progress, Color(1, 1, 1, fade * 0.54))
					_add_runtime_effect(layer as Control, "fx_hit_white", player_pos + Vector2(0.0, -4.0), Vector2.ONE * maxf(42.0, impact_size * 0.74), impact_progress, Color(1.0, 0.58, 0.42, fade * 0.42))
				_add_runtime_label(layer as Control, "HIT -%d" % int(round(float(event.get("amount", 0.0)))), player_pos + Vector2(-48.0, -76.0 - 22.0 * progress), Vector2(112.0, 32.0), 22, color.lightened(0.2), fade)
			"hit_player":
				_add_runtime_effect(layer as Control, "fx_hit_dust", player_pos + Vector2(0.0, 2.0), Vector2.ONE * 70.0, progress, Color(1.0, 0.72, 0.48, fade))
				_add_runtime_effect(layer as Control, "fx_hit_white", player_pos + Vector2(0.0, -6.0), Vector2.ONE * 78.0, progress, Color(1.0, 0.46, 0.36, fade * 0.92))
				_add_runtime_label(layer as Control, "HIT -%d" % int(round(float(event.get("amount", 0.0)))), player_pos + Vector2(-46.0, -76.0 - 28.0 * progress), Vector2(112.0, 34.0), 24, Color("#ff6b35"), fade)
			"kill":
				var target := _find_entity(enemies, int(event.get("target_id", 0)))
				var target_pos := _overlay_enemy_center(target, world_size) if not target.is_empty() else _overlay_world_to_combat(Vector2(805.0, 80.0), world_size) + COMBAT_ENEMY_VISUAL_SHIFT
				_add_runtime_label(layer as Control, "처치!", target_pos + Vector2(-30.0, -72.0 - 18.0 * progress), Vector2(86.0, 30.0), 20, Color("#ffcf7a"), fade)
			"drop":
				var label_text := "+%s x%d" % [str(event.get("item_name", "전리품")), int(event.get("count", 1))]
				var drop_label_size := Vector2(minf(240.0, maxf(150.0, layer_size.x - 44.0)), 26.0)
				var drop_x := clampf(layer_size.x - drop_label_size.x - 22.0, 22.0, maxf(22.0, layer_size.x - drop_label_size.x - 22.0))
				_add_runtime_label(layer as Control, label_text, Vector2(drop_x, 34.0 - 18.0 * progress), drop_label_size, 15, Color("#f3e6c8"), fade)
	_add_runtime_enemy_foreground(layer as Control, snapshot, world_size)


func _add_runtime_enemy_foreground(parent: Control, snapshot: Dictionary, world_size: Vector2) -> void:
	var enemies: Array = snapshot.get("enemies", []) if typeof(snapshot.get("enemies", [])) == TYPE_ARRAY else []
	for enemy in enemies:
		if typeof(enemy) != TYPE_DICTIONARY or not bool((enemy as Dictionary).get("alive", true)):
			continue
		var data := enemy as Dictionary
		var enemy_size := _overlay_enemy_size(data)
		var enemy_pos := _overlay_enemy_center(data, world_size, enemy_size)
		var hit_flash := float(data.get("hit_flash", 0.0))
		var attack_flash := float(data.get("attack_flash", 0.0))
		var pulse := 1.0 + maxf(
			sin(clampf(hit_flash / 0.18, 0.0, 1.0) * PI) * 0.18,
			sin(clampf(attack_flash / 0.24, 0.0, 1.0) * PI) * 0.1
		)
		var shadow := Panel.new()
		shadow.name = "RuntimeForegroundEnemyShadow_%d" % int(data.get("id", 0))
		shadow.position = enemy_pos + Vector2(-enemy_size.x * 0.42, enemy_size.y * 0.34)
		shadow.size = Vector2(enemy_size.x * 0.84, 14.0)
		shadow.add_theme_stylebox_override("panel", _overlay_style(Color(0.03, 0.018, 0.01, 0.66), Color(0.0, 0.0, 0.0, 0.0), 0, 8))
		shadow.mouse_filter = Control.MOUSE_FILTER_IGNORE
		shadow.z_index = 118
		parent.add_child(shadow)

		var rect := TextureRect.new()
		rect.name = "RuntimeForegroundEnemy_%d" % int(data.get("id", 0))
		rect.texture = _unit_display_texture(data, false)
		if rect.texture == null and sprites != null:
			rect.texture = sprites.get_texture("monster_basic")
		if rect.texture == null:
			continue
		rect.position = enemy_pos - enemy_size * 0.5
		rect.size = enemy_size
		rect.pivot_offset = enemy_size * 0.5
		rect.scale = Vector2.ONE * pulse
		rect.flip_h = _unit_display_flip_h(data, false)
		rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		rect.stretch_mode = TextureRect.STRETCH_SCALE
		rect.modulate = Color(1.8, 0.62, 0.48, 1.0) if hit_flash > 0.0 else Color(1.22, 1.17, 1.08, 1.0)
		rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		rect.z_index = 122
		parent.add_child(rect)


func _add_runtime_texture(parent: Control, texture: Texture2D, pos: Vector2, texture_size: Vector2, modulate: Color) -> void:
	if texture == null:
		var fallback := ColorRect.new()
		fallback.position = pos
		fallback.size = texture_size
		fallback.color = Color(modulate.r, modulate.g, modulate.b, 0.72 * modulate.a)
		fallback.z_index = 45
		parent.add_child(fallback)
		return
	var texture_rect := TextureRect.new()
	texture_rect.texture = texture
	texture_rect.position = pos
	texture_rect.size = texture_size
	texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	texture_rect.modulate = modulate
	texture_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	texture_rect.z_index = 45
	parent.add_child(texture_rect)


func _add_runtime_effect(parent: Control, key: String, center: Vector2, effect_size: Vector2, progress: float, modulate: Color) -> void:
	if sprites == null or key == "":
		return
	var texture: Texture2D = sprites.get_texture(key)
	if texture == null:
		return
	var render_texture: Texture2D = texture
	var region: Rect2 = sprites.effect_frame_region(key, progress)
	if region.has_area():
		var atlas := AtlasTexture.new()
		atlas.atlas = texture
		atlas.region = region
		render_texture = atlas
	_add_runtime_texture(parent, render_texture, center - effect_size * 0.5, effect_size, modulate)


func _add_runtime_label(parent: Control, text: String, pos: Vector2, label_size: Vector2, font_size: int, color: Color, alpha: float) -> void:
	var label := Label.new()
	label.text = text
	label.position = pos
	label.size = label_size
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	label.add_theme_color_override("font_shadow_color", Color("#050302"))
	label.add_theme_constant_override("shadow_offset_x", 2)
	label.add_theme_constant_override("shadow_offset_y", 2)
	label.add_theme_color_override("font_outline_color", Color("#250704"))
	label.add_theme_constant_override("outline_size", 4)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.modulate = Color(1, 1, 1, alpha)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.z_index = 80
	parent.add_child(label)


func _focus_enemy(snapshot: Dictionary) -> Dictionary:
	var enemies: Array = snapshot.get("enemies", []) if typeof(snapshot.get("enemies", [])) == TYPE_ARRAY else []
	var fallback := {}
	for enemy in enemies:
		if typeof(enemy) != TYPE_DICTIONARY:
			continue
		if bool(enemy.get("alive", true)):
			return enemy
		if fallback.is_empty():
			fallback = enemy
	return fallback


func _boss_or_focus_enemy(snapshot: Dictionary) -> Dictionary:
	var enemies: Array = snapshot.get("enemies", []) if typeof(snapshot.get("enemies", [])) == TYPE_ARRAY else []
	for enemy in enemies:
		if typeof(enemy) != TYPE_DICTIONARY or not bool((enemy as Dictionary).get("alive", true)):
			continue
		var tags: Array = (enemy as Dictionary).get("tags", []) if typeof((enemy as Dictionary).get("tags", [])) == TYPE_ARRAY else []
		var unit_type := str((enemy as Dictionary).get("unit_type", "Normal"))
		if unit_type == "Boss" or unit_type == "MidBoss" or tags.has("GiantBoss") or tags.has("MiniBoss"):
			return enemy
	return {}


func _overlay_world_to_combat(pos: Vector2, world_size: Vector2) -> Vector2:
	return Vector2(
		OVERLAY_COMBAT_REFERENCE_RECT.position.x + (pos.x / maxf(1.0, world_size.x)) * OVERLAY_COMBAT_REFERENCE_RECT.size.x,
		OVERLAY_COMBAT_REFERENCE_RECT.position.y + (pos.y / maxf(1.0, world_size.y)) * OVERLAY_COMBAT_REFERENCE_RECT.size.y
	)


func _overlay_enemy_center(enemy: Dictionary, world_size: Vector2, enemy_size := Vector2.ZERO) -> Vector2:
	if enemy.is_empty():
		return _overlay_world_to_combat(Vector2(805.0, 80.0), world_size) + COMBAT_ENEMY_VISUAL_SHIFT
	var display_size := enemy_size if enemy_size != Vector2.ZERO else _overlay_enemy_size(enemy)
	var enemy_pos := _overlay_world_to_combat(enemy.get("position", Vector2.ZERO), world_size) + COMBAT_ENEMY_VISUAL_SHIFT
	var tags: Array = enemy.get("tags", []) if typeof(enemy.get("tags", [])) == TYPE_ARRAY else []
	var attack_flash := float(enemy.get("attack_flash", 0.0))
	if attack_flash > 0.0 and not tags.has("Ranged"):
		var attack_phase := clampf(1.0 - attack_flash / 0.24, 0.0, 1.0)
		enemy_pos.x -= sin(attack_phase * PI) * 14.0
	var runtime_id := int(enemy.get("id", 0))
	var lane_offset := Vector2(float((runtime_id % 5) - 2) * COMBAT_ENEMY_LANE_STEP.x, float((runtime_id % 3) - 1) * COMBAT_ENEMY_LANE_STEP.y)
	return _clamp_combat_sprite_center(enemy_pos + lane_offset, display_size)


func _overlay_enemy_size(enemy: Dictionary) -> Vector2:
	var tags: Array = enemy.get("tags", []) if typeof(enemy.get("tags", [])) == TYPE_ARRAY else []
	var unit_type := str(enemy.get("unit_type", "Normal"))
	var base_size := Vector2(96.0, 108.0)
	if unit_type == "Boss" or tags.has("GiantBoss"):
		base_size = Vector2(126.0, 140.0)
	elif unit_type == "MidBoss" or tags.has("MiniBoss"):
		base_size = Vector2(112.0, 124.0)
	elif unit_type == "Elite" or tags.has("Armored"):
		base_size = Vector2(104.0, 116.0)
	elif tags.has("Ranged"):
		base_size = Vector2(96.0, 106.0)
	return base_size * COMBAT_MONSTER_VISUAL_SCALE


func _clamp_combat_sprite_center(center: Vector2, sprite_size: Vector2) -> Vector2:
	var half_size := sprite_size * 0.5
	return Vector2(
		clampf(center.x, OVERLAY_COMBAT_REFERENCE_RECT.position.x + half_size.x, OVERLAY_COMBAT_REFERENCE_RECT.end.x - half_size.x),
		clampf(center.y, 24.0 + half_size.y, 212.0 - half_size.y)
	)


func _overlay_hero_frame(elapsed_seconds: float, attack_flash: float) -> int:
	if attack_flash > 0.0:
		var attack_phase := clampf(1.0 - attack_flash / 0.22, 0.0, 1.0)
		if attack_phase < 0.34:
			return 5
		if attack_phase < 0.68:
			return 6
		return 7
	return int(floor(fmod(elapsed_seconds * 3.0, 2.0)))


func _unit_display_texture(unit: Dictionary, is_player: bool, frame := 0) -> Texture2D:
	if sprites == null or unit.is_empty():
		return null
	var unit_id := int(unit.get("unit_id", 0))
	var sprite_path := str(unit.get("sprite", ""))
	var texture: Texture2D = sprites.texture_for_unit(unit_id, sprite_path)
	if texture == null:
		return null
	var elapsed_seconds := float(sim.snapshot().get("elapsed", 0.0)) if sim != null else 0.0
	var region: Rect2 = sprites.hero_frame_region(frame) if is_player else sprites.region_for_unit(unit_id, sprite_path, _unit_display_action(unit, is_player), elapsed_seconds)
	if region.has_area():
		var atlas := AtlasTexture.new()
		atlas.atlas = texture
		atlas.region = region
		return atlas
	return texture


func _unit_display_action(unit: Dictionary, is_player: bool) -> String:
	if is_player:
		return ""
	return "move"


func _unit_display_flip_h(unit: Dictionary, is_player: bool) -> bool:
	if is_player:
		return true
	if sprites == null or unit.is_empty():
		return false
	var unit_id := int(unit.get("unit_id", 0))
	var sprite_path := str(unit.get("sprite", ""))
	return sprites.render_flip_h_for_unit(unit_id, sprite_path, true)


func _enemy_skill_texture(skill_id: int) -> Texture2D:
	if sprites == null:
		return null
	var style := _enemy_skill_fx_style(skill_id)
	var key := str(style.get("projectile", ""))
	if key == "":
		key = str(style.get("impact_texture", "fx_skill_orb"))
	return sprites.get_texture(key)


func _prepare_generated_texture_atom(texture_rect: TextureRect) -> void:
	texture_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var asset_key := str(texture_rect.get_meta("asset_key", ""))
	if asset_key != "taskstonebar.ui.stone_keeper_sheet" or texture_rect.texture == null:
		return
	if texture_rect.texture.get_width() <= texture_rect.texture.get_height() * 2:
		texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		return
	var atlas := AtlasTexture.new()
	atlas.atlas = texture_rect.texture
	atlas.region = Rect2(Vector2.ZERO, Vector2(48.0, 48.0))
	texture_rect.texture = atlas
	texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	texture_rect.stretch_mode = TextureRect.STRETCH_SCALE


func _apply_generated_button_style(button: Button, role: String) -> void:
	var fill := Color("#2a1a10")
	var border := Color("#6b4a2a")
	var radius := 3
	var texture_key := ""
	match role:
		"inventory_tab", "act_tab":
			fill = Color("#6b2a18")
			border = Color("#d18a24")
			radius = 2
			texture_key = "taskstonebar.ui.tab_burgundy_9slice"
		"keeper_dock_icon", "utility_icon", "portal_stage_node":
			fill = Color("#201915")
			border = Color("#8a5b24")
			radius = 4
			texture_key = "taskstonebar.ui.icon_dock_button_9slice"
		"window_close":
			fill = Color("#3a1710")
			border = Color("#d18a24")
			radius = 2
	button.flat = false
	var textured_style: StyleBox = _overlay_texture_style(texture_key)
	if textured_style != null:
		button.add_theme_stylebox_override("normal", textured_style)
		button.add_theme_stylebox_override("hover", _overlay_texture_style(texture_key, Color(1.14, 1.14, 1.14, 1.0)))
		button.add_theme_stylebox_override("pressed", _overlay_texture_style(texture_key, Color(0.82, 0.82, 0.82, 1.0)))
	else:
		button.add_theme_stylebox_override("normal", _overlay_style(fill, border, 2, radius))
		button.add_theme_stylebox_override("hover", _overlay_style(fill.lightened(0.12), Color("#ffcf7a"), 2, radius))
		button.add_theme_stylebox_override("pressed", _overlay_style(fill.darkened(0.16), border, 2, radius))
	button.add_theme_stylebox_override("disabled", _overlay_style(fill.darkened(0.18), Color("#5a5146"), 1, radius))
	button.add_theme_color_override("font_color", Color("#ffcf7a"))
	button.add_theme_color_override("font_pressed_color", Color("#f3e6c8"))
	button.add_theme_color_override("font_hover_color", Color("#fff0a6"))
	button.add_theme_font_size_override("font_size", 14)


func _prepare_generated_close_button(button: Button) -> void:
	button.tooltip_text = "닫기"
	_ensure_generated_close_icon(button)
	if not button.has_meta("generated_close_connected"):
		button.pressed.connect(func():
			_close_generated_window_for_button(button)
		)
		button.set_meta("generated_close_connected", true)


func _ensure_generated_close_icon(button: Button) -> void:
	if button.has_node("Icon_Close"):
		return
	var texture: Texture2D = _generated_texture(GENERATED_CLOSE_ICON_PATH)
	if texture == null:
		return
	var icon := TextureRect.new()
	icon.name = "Icon_Close"
	icon.texture = texture
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.anchor_right = 1.0
	icon.anchor_bottom = 1.0
	icon.offset_left = 3.0
	icon.offset_top = 3.0
	icon.offset_right = -3.0
	icon.offset_bottom = -3.0
	button.add_child(icon)


func _close_generated_window_for_button(button: Button) -> void:
	var cursor: Node = button
	while cursor != null:
		if cursor is CanvasItem and (str(cursor.name).ends_with("WindowFrame") or str(cursor.name) == RUNTIME_SKILL_TREE_WINDOW_NAME):
			var window_id := _desktop_window_id_for_control(cursor as Control)
			_close_generated_window(window_id, cursor as Control)
			return
		cursor = cursor.get_parent()


func _overlay_texture_style(asset_key: String, modulate: Color = Color.WHITE) -> StyleBox:
	if asset_key == "" or not GENERATED_STYLE_TEXTURES.has(asset_key):
		return null
	var texture: Texture2D = _generated_texture(str(GENERATED_STYLE_TEXTURES[asset_key]))
	if texture == null:
		return null
	var hints: Dictionary = GENERATED_STYLE_SLICE_HINTS.get(asset_key, {})
	var style := StyleBoxTexture.new()
	style.texture = texture
	style.modulate_color = modulate
	style.texture_margin_left = float(hints.get("left", 0.0))
	style.texture_margin_right = float(hints.get("right", 0.0))
	style.texture_margin_top = float(hints.get("top", 0.0))
	style.texture_margin_bottom = float(hints.get("bottom", 0.0))
	return style


func _generated_texture(res_path: String) -> Texture2D:
	if generated_texture_cache.has(res_path):
		return generated_texture_cache[res_path]
	var loaded: Resource = load(res_path)
	if loaded is Texture2D:
		generated_texture_cache[res_path] = loaded
		return loaded
	return null


func _overlay_style(fill: Color, border: Color, border_width: int, radius: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = border
	style.border_width_left = border_width
	style.border_width_right = border_width
	style.border_width_top = border_width
	style.border_width_bottom = border_width
	style.corner_radius_top_left = radius
	style.corner_radius_top_right = radius
	style.corner_radius_bottom_left = radius
	style.corner_radius_bottom_right = radius
	return style


func _overlay_color(token: String) -> Color:
	match token:
		"panel_outer":
			return Color("#0a0908")
		"panel_mid":
			return Color("#2a1712")
		"panel_inner":
			return Color("#080a0a")
		"title_gold":
			return Color("#ffcf7a")
		"text_cream":
			return Color("#f3e6c8")
		"text_muted":
			return Color("#b79a72")
		"coin_gold":
			return Color("#ffd877")
		"hp_red":
			return Color("#c0392b")
		"exp_blue":
			return Color("#2e8fd0")
		"ruby_red":
			return Color("#d94b74")
		"moss_green":
			return Color("#6a8f42")
		"taskbar_ground":
			return Color("#3a2a18")
		"shadow":
			return Color("#050302")
	return Color(token) if token.begins_with("#") else Color("#f3e6c8")


func _format_count(value) -> String:
	var number := int(value)
	if number >= 1000000000:
		return "%.1fA" % (float(number) / 1000000000.0)
	if number >= 1000000:
		return "%.1fM" % (float(number) / 1000000.0)
	return "%d" % number


func _current_stage_label(snapshot: Dictionary) -> String:
	var map_id: int = int(snapshot.get("map_id", 500101))
	var linear_index: int = maxi(0, map_id - 500101)
	var set_index: int = int(linear_index / 10) + 1
	var stage_index: int = int(linear_index % 10) + 1
	return "%s\nStage %d-%d" % [
		str(snapshot.get("map_name", "작업굴입구")),
		set_index,
		stage_index,
	]


func _update_auto_transition(delta: float) -> void:
	var snapshot: Dictionary = sim.snapshot()
	if bool(snapshot.get("running", false)):
		auto_transition_timer = -1.0
		auto_transition_result = ""
		auto_transition_map_id = 0
		return

	var current_result := str(snapshot.get("result", ""))
	if current_result == "":
		return

	var current_map_id := int(snapshot.get("map_id", 0))
	if current_result != auto_transition_result or current_map_id != auto_transition_map_id:
		auto_transition_result = current_result
		auto_transition_map_id = current_map_id
		auto_transition_timer = AUTO_TRANSITION_DELAY
		return

	auto_transition_timer -= delta
	if auto_transition_timer > 0.0:
		return

	auto_transition_timer = -1.0
	if current_result == "defeat":
		sim.start(current_map_id)
	elif current_result == "clear" and _client_auto_advance_enabled(current_map_id):
		sim.continue_after_result(farm_toggle != null and farm_toggle.button_pressed)


func _client_auto_advance_enabled(current_map_id: int) -> bool:
	if store == null:
		return false
	var current_map: Dictionary = store.get_map(current_map_id)
	var popup_args = current_map.get("popupArgs", {}) if typeof(current_map.get("popupArgs", {})) == TYPE_DICTIONARY else {}
	var raw_value = popup_args.get("ClientAutoAdvance", "false")
	if typeof(raw_value) == TYPE_BOOL:
		return bool(raw_value)
	return str(raw_value).to_lower() == "true"


func _draw_battlefield(field: Rect2) -> void:
	var inner: Texture2D = sprites.get_texture("inner") if sprites != null else null
	if inner != null:
		draw_texture_rect(inner, field, false, Color(1, 1, 1, 0.78))
	else:
		draw_rect(field, Color("#25180f"))

	var ground := Rect2(field.position + Vector2(0.0, field.size.y - 34.0), Vector2(field.size.x, 34.0))
	draw_rect(ground, Color("#3b2817"))
	draw_rect(Rect2(ground.position, Vector2(ground.size.x, 3.0)), Color("#6d4b2a"))
	_draw_resource_icons(field)


func _draw_resource_icons(field: Rect2) -> void:
	var coin: Texture2D = sprites.get_texture("coin") if sprites != null else null
	var ruby: Texture2D = sprites.get_texture("ruby") if sprites != null else null
	if coin != null:
		draw_texture_rect(coin, Rect2(field.position + Vector2(14.0, field.size.y - 29.0), Vector2(22.0, 22.0)), false)
	if ruby != null:
		draw_texture_rect(ruby, Rect2(field.position + Vector2(108.0, field.size.y - 29.0), Vector2(22.0, 22.0)), false)


func _draw_unit(unit: Dictionary, field: Rect2, color: Color, is_player: bool) -> void:
	var world_size: Vector2 = sim.snapshot().get("world_size", Vector2(960.0, 160.0))
	var pos: Vector2 = unit.get("position", Vector2.ZERO)
	var screen_pos: Vector2 = _world_to_field(pos, field, world_size)
	var unit_id := int(unit.get("unit_id", 0))
	var sprite_path := str(unit.get("sprite", ""))
	var texture: Texture2D = sprites.texture_for_unit(unit_id, sprite_path) if sprites != null else null
	var elapsed_seconds := float(sim.snapshot().get("elapsed", 0.0)) if sim != null else 0.0
	var region: Rect2 = sprites.region_for_unit(unit_id, sprite_path, _unit_display_action(unit, is_player), elapsed_seconds) if sprites != null else Rect2()
	var visual_size := _unit_visual_size(unit, is_player)
	var tags: Array = unit.get("tags", []) if typeof(unit.get("tags", [])) == TYPE_ARRAY else []
	var attack_flash := float(unit.get("attack_flash", 0.0))
	if not is_player and attack_flash > 0.0 and not tags.has("Ranged"):
		var lunge := sin(clampf(attack_flash / 0.24, 0.0, 1.0) * PI) * 11.0
		screen_pos.x -= lunge
		visual_size *= 1.0 + 0.05 * sin(clampf(attack_flash / 0.24, 0.0, 1.0) * PI)
	var hit_flash := float(unit.get("hit_flash", 0.0))
	var unit_rect := Rect2(screen_pos - visual_size * 0.5, visual_size)

	var shadow_size := Vector2(visual_size.x * 0.72, 9.0)
	draw_rect(Rect2(screen_pos + Vector2(-shadow_size.x * 0.5, visual_size.y * 0.35), shadow_size), Color(0, 0, 0, 0.25))
	if hit_flash > 0.0:
		draw_circle(screen_pos, visual_size.x * 0.48, Color(1.0, 0.18, 0.12, 0.18 * clampf(hit_flash / 0.18, 0.0, 1.0)))
	if texture != null and is_player:
		var frame: int = int(floor(fmod(float(sim.snapshot().get("elapsed", 0.0)) * 8.0, float(SpriteCatalog.HERO_FRAME_COUNT))))
		_draw_texture_region_flipped(texture, unit_rect, sprites.hero_frame_region(frame))
	elif texture != null:
		var flip_h := _unit_display_flip_h(unit, is_player)
		if region.has_area():
			if flip_h:
				_draw_texture_region_flipped(texture, unit_rect, region)
			else:
				draw_texture_rect_region(texture, unit_rect, region)
		else:
			if flip_h:
				_draw_texture_flipped(texture, unit_rect)
			else:
				draw_texture_rect(texture, unit_rect, false)
	else:
		draw_circle(screen_pos, 18.0 if is_player else 14.0, color)

	var hp: float = float(unit.get("hp", 0.0))
	var max_hp: float = maxf(1.0, float(unit.get("max_hp", 1.0)))
	var hp_width := 48.0 if is_player else 38.0
	var bar_pos := Vector2(screen_pos.x - hp_width * 0.5, screen_pos.y - visual_size.y * 0.5 - 10.0)
	draw_rect(Rect2(bar_pos, Vector2(hp_width, 4.0)), Color("#120c08"))
	draw_rect(Rect2(bar_pos, Vector2(hp_width * clampf(hp / max_hp, 0.0, 1.0), 4.0)), Color("#d85745"))


func _unit_visual_size(unit: Dictionary, is_player: bool) -> Vector2:
	if is_player:
		return Vector2(58.0, 58.0)
	var tags: Array = unit.get("tags", []) if typeof(unit.get("tags", [])) == TYPE_ARRAY else []
	var unit_type := str(unit.get("unit_type", "Normal"))
	var base_size := Vector2(46.0, 54.0)
	if unit_type == "Boss" or tags.has("GiantBoss"):
		base_size = Vector2(82.0, 92.0)
	elif unit_type == "MidBoss" or tags.has("MiniBoss"):
		base_size = Vector2(66.0, 74.0)
	elif tags.has("Armored"):
		base_size = Vector2(56.0, 62.0)
	elif tags.has("Ranged"):
		base_size = Vector2(50.0, 58.0)
	elif tags.has("Fast"):
		base_size = Vector2(42.0, 50.0)
	return base_size * COMBAT_MONSTER_VISUAL_SCALE


func _draw_texture_flipped(texture: Texture2D, rect: Rect2) -> void:
	draw_set_transform(rect.position + Vector2(rect.size.x, 0.0), 0.0, Vector2(-1.0, 1.0))
	draw_texture_rect(texture, Rect2(Vector2.ZERO, rect.size), false)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


func _draw_texture_region_flipped(texture: Texture2D, rect: Rect2, region: Rect2) -> void:
	draw_set_transform(rect.position + Vector2(rect.size.x, 0.0), 0.0, Vector2(-1.0, 1.0))
	draw_texture_rect_region(texture, Rect2(Vector2.ZERO, rect.size), region)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


func _draw_fx(snapshot: Dictionary, field: Rect2) -> void:
	var world_size: Vector2 = snapshot.get("world_size", Vector2(960.0, 160.0))
	var player: Dictionary = snapshot.get("player", {})
	var player_pos: Vector2 = _world_to_field(player.get("position", Vector2.ZERO), field, world_size)

	for event in snapshot.get("fx_events", []):
		if typeof(event) != TYPE_DICTIONARY:
			continue
		var duration := maxf(0.05, float(event.get("duration", event.get("ttl", 0.7))))
		var t: float = clampf(1.0 - float(event.get("ttl", 0.0)) / duration, 0.0, 1.0)
		match str(event.get("kind", "")):
			"spawn":
				var spawn_pos := _world_to_field(event.get("position", Vector2(980.0, 80.0)), field, world_size)
				_draw_effect_sprite(str(event.get("fx_key", "fx_mob_spawn")), spawn_pos, Vector2.ONE * float(event.get("size", 58.0)), t, Color(1, 1, 1, 1.0 - t * 0.15))
			"attack":
				var target: Dictionary = _find_entity(snapshot.get("enemies", []), int(event.get("target_id", 0)))
				if target.is_empty():
					continue
				var target_pos: Vector2 = _world_to_field(target.get("position", Vector2.ZERO), field, world_size)
				_draw_enemy_skill_fx(event, player_pos, target_pos, t)
			"enemy_skill":
				var source: Dictionary = _find_entity(snapshot.get("enemies", []), int(event.get("source_id", 0)))
				if source.is_empty():
					continue
				var source_pos: Vector2 = _world_to_field(source.get("position", Vector2.ZERO), field, world_size)
				_draw_enemy_skill_fx(event, source_pos, player_pos, t)


func _draw_enemy_skill_fx(event: Dictionary, source_pos: Vector2, target_pos: Vector2, t: float) -> void:
	var style := _enemy_skill_fx_style(int(event.get("skill_id", 0)))
	var color: Color = style.get("color", Color("#ff6b35"))
	var projectile_pos: Vector2 = source_pos.lerp(target_pos, t)
	projectile_pos.y -= sin(t * PI) * float(style.get("arc", 14.0))
	var fade := 1.0 - t
	var cast_key := str(style.get("cast", ""))
	if cast_key != "" and t < 0.5:
		_draw_effect_sprite(cast_key, source_pos, Vector2.ONE * float(style.get("cast_size", 40.0)), clampf(t / 0.5, 0.0, 1.0), Color(1, 1, 1, 0.76 * fade))
	var line_width := float(style.get("line_width", 2.0))
	if line_width > 0.0:
		draw_line(source_pos, target_pos, Color(color.r, color.g, color.b, 0.26 * fade), line_width)

	var projectile_key := str(style.get("projectile", ""))
	if projectile_key != "" and t < 0.86:
		_draw_effect_sprite(projectile_key, projectile_pos, Vector2.ONE * float(style.get("projectile_size", 24.0)), t, Color(1, 1, 1, 0.96))

	var impact_key := str(style.get("impact_texture", ""))
	if impact_key != "" and t > 0.36:
		var impact_progress := clampf((t - 0.36) / 0.64, 0.0, 1.0)
		_draw_effect_sprite(impact_key, target_pos, Vector2.ONE * float(style.get("impact_size", 34.0)), impact_progress, Color(1, 1, 1, 0.9 * fade))
	if int(event.get("skill_id", 0)) == 300201:
		var slash := 14.0 * fade
		draw_line(target_pos + Vector2(-slash, -6.0), target_pos + Vector2(slash, 8.0), Color(color.r, color.g, color.b, 0.65 * fade), 3.0)
		draw_line(target_pos + Vector2(-slash, 8.0), target_pos + Vector2(slash, -6.0), Color(color.r, color.g, color.b, 0.48 * fade), 2.0)
	var impact_radius := float(style.get("impact_ring", 0.0)) * fade
	if impact_radius > 0.0:
		draw_circle(target_pos, impact_radius, Color(color.r, color.g, color.b, 0.18 * fade))


func _draw_effect_sprite(key: String, center: Vector2, size: Vector2, progress: float, modulate: Color) -> void:
	var texture: Texture2D = sprites.get_texture(key) if sprites != null else null
	if texture == null:
		return
	var rect := Rect2(center - size * 0.5, size)
	var region: Rect2 = sprites.effect_frame_region(key, progress) if sprites != null else Rect2()
	if region.has_area():
		draw_texture_rect_region(texture, rect, region, modulate)
	else:
		draw_texture_rect(texture, rect, false, modulate)


func _enemy_skill_fx_style(skill_id: int) -> Dictionary:
	match skill_id:
		300101:
			return {"projectile": "rock", "impact_texture": "fx_hit_dust", "color": Color("#d8b16a"), "projectile_size": 46.0, "impact_size": 34.0, "impact_ring": 12.0, "arc": 42.0, "line_width": 0.0}
		300102:
			return {"projectile": "rock", "impact_texture": "fx_hit_dust", "color": Color("#d8b16a"), "projectile_size": 42.0, "impact_size": 36.0, "impact_ring": 12.0, "arc": 36.0, "line_width": 0.0}
		300103:
			return {"projectile": "stone0", "impact_texture": "fx_hit_dust", "color": Color("#8ed06a"), "projectile_size": 40.0, "impact_size": 38.0, "impact_ring": 14.0, "arc": 34.0, "line_width": 0.0}
		300104:
			return {"projectile": "stone1", "impact_texture": "fx_hit_white", "color": Color("#f2c56f"), "projectile_size": 42.0, "impact_size": 40.0, "impact_ring": 16.0, "arc": 30.0, "line_width": 0.0}
		300105:
			return {"projectile": "stone2", "impact_texture": "fx_fireball_boom", "color": Color("#ffb24f"), "projectile_size": 46.0, "impact_size": 58.0, "impact_ring": 24.0, "arc": 38.0, "line_width": 0.4}
		300106:
			return {"projectile": "fx_hit_blue", "impact_texture": "fx_hit_blue", "color": Color("#8fd3ff"), "projectile_size": 34.0, "impact_size": 42.0, "impact_ring": 18.0, "arc": 28.0, "line_width": 0.6}
		300107:
			return {"projectile": "fx_fireball", "impact_texture": "fx_fireball_boom", "color": Color("#ff7a2f"), "projectile_size": 48.0, "impact_size": 70.0, "impact_ring": 28.0, "arc": 26.0, "line_width": 0.8}
		300108:
			return {"projectile": "fx_skill_orb", "impact_texture": "fx_hit_blue", "color": Color("#78d8ff"), "projectile_size": 38.0, "impact_size": 42.0, "impact_ring": 18.0, "arc": 20.0, "line_width": 1.0}
		300109:
			return {"projectile": "fx_moonslash", "impact_texture": "fx_hit_white", "color": Color("#d8f0ff"), "projectile_size": 46.0, "impact_size": 44.0, "impact_ring": 20.0, "arc": 18.0, "line_width": 1.0}
		300110:
			return {"cast": "fx_stone_fusion", "projectile": "fx_stone_fusion", "impact_texture": "fx_stone_fusion", "color": Color("#d06aff"), "cast_size": 52.0, "projectile_size": 48.0, "impact_size": 64.0, "impact_ring": 26.0, "arc": 22.0, "line_width": 1.0}
		300111:
			return {"cast": "fx_bloodmoon_cast", "projectile": "fx_bloodmoon", "impact_texture": "fx_fireball_boom", "color": Color("#ff3650"), "cast_size": 72.0, "projectile_size": 44.0, "impact_size": 82.0, "impact_ring": 36.0, "arc": 30.0, "line_width": 1.2}
		300201:
			return {"impact_texture": "fx_moonslash", "color": Color("#f4f4f4"), "impact_size": 44.0, "impact_ring": 8.0, "arc": 0.0, "line_width": 0.0}
		300202:
			return {"projectile": "fx_tortoise_tail_normal", "impact_texture": "fx_hit_dust", "color": Color("#d8b16a"), "projectile_size": 44.0, "impact_size": 42.0, "impact_ring": 14.0, "arc": 0.0, "line_width": 0.8}
		300203:
			return {"projectile": "fx_tortoise_tail_rare", "impact_texture": "fx_hit_blue", "color": Color("#8fd3ff"), "projectile_size": 40.0, "impact_size": 40.0, "impact_ring": 14.0, "arc": 4.0, "line_width": 0.8}
		300204:
			return {"cast": "fx_shield", "impact_texture": "fx_hit_white", "color": Color("#d7eef8"), "cast_size": 52.0, "impact_size": 48.0, "impact_ring": 18.0, "arc": 0.0, "line_width": 0.0}
		300205:
			return {"cast": "fx_mob_spawn_m", "impact_texture": "fx_solar_damage", "color": Color("#d8a15f"), "cast_size": 70.0, "impact_size": 76.0, "impact_ring": 24.0, "arc": 0.0, "line_width": 0.0}
		300206:
			return {"cast": "fx_mob_spawn_l", "impact_texture": "fx_boss_crack_large", "color": Color("#ff8a3c"), "cast_size": 104.0, "impact_size": 96.0, "impact_ring": 30.0, "arc": 0.0, "line_width": 0.0}
		300207:
			return {"cast": "fx_fullmoon_cast", "projectile": "fx_moonslash", "impact_texture": "fx_stone_fusion", "color": Color("#ffcf7a"), "cast_size": 84.0, "projectile_size": 54.0, "impact_size": 78.0, "impact_ring": 34.0, "arc": 8.0, "line_width": 1.0}
		300208:
			return {"cast": "fx_bloodmoon_cast", "projectile": "fx_bloodmoon", "impact_texture": "fx_fireball_boom", "color": Color("#ff2e38"), "cast_size": 90.0, "projectile_size": 50.0, "impact_size": 94.0, "impact_ring": 42.0, "arc": 18.0, "line_width": 1.1}
		300301, 300306, 300318:
			return {"projectile": "fx_hit_dust", "impact_texture": "fx_hit_dust", "color": Color("#d8b16a"), "projectile_size": 30.0, "impact_size": 42.0, "impact_ring": 15.0, "arc": 18.0, "line_width": 0.9}
		300302, 300317, 300328:
			return {"projectile": "fx_skill_orb", "impact_texture": "fx_hit_blue", "color": Color("#8fd3ff"), "projectile_size": 34.0, "impact_size": 40.0, "impact_ring": 16.0, "arc": 20.0, "line_width": 1.0}
		300303, 300312:
			return {"projectile": "fx_moonslash", "impact_texture": "fx_hit_white", "color": Color("#d8f0ff"), "projectile_size": 42.0, "impact_size": 42.0, "impact_ring": 18.0, "arc": 10.0, "line_width": 1.4}
		300304, 300311, 300319, 300324:
			return {"projectile": "fx_boss_crack_small", "impact_texture": "fx_boss_crack_small", "color": Color("#d8a15f"), "projectile_size": 36.0, "impact_size": 54.0, "impact_ring": 22.0, "arc": 6.0, "line_width": 1.0}
		300305, 300308, 300327:
			return {"cast": "fx_stone_fusion", "projectile": "fx_skill_orb", "impact_texture": "fx_stone_fusion", "color": Color("#d06aff"), "cast_size": 58.0, "projectile_size": 32.0, "impact_size": 64.0, "impact_ring": 28.0, "arc": 18.0, "line_width": 1.2}
		300307, 300316:
			return {"projectile": "fx_hit_blue", "impact_texture": "fx_hit_blue", "color": Color("#5fc8ff"), "projectile_size": 32.0, "impact_size": 44.0, "impact_ring": 18.0, "arc": 16.0, "line_width": 1.0}
		300309, 300320, 300329:
			return {"cast": "fx_fireball", "projectile": "fx_fireball", "impact_texture": "fx_fireball_boom", "color": Color("#ff7a2f"), "cast_size": 46.0, "projectile_size": 48.0, "impact_size": 76.0, "impact_ring": 34.0, "arc": 16.0, "line_width": 1.2}
		300310:
			return {"cast": "fx_bloodmoon_cast", "projectile": "fx_fireball", "impact_texture": "fx_fireball_boom", "color": Color("#ff4e2f"), "cast_size": 70.0, "projectile_size": 56.0, "impact_size": 88.0, "impact_ring": 40.0, "arc": 30.0, "line_width": 1.3}
		300313, 300325:
			return {"cast": "fx_boss_crack_large", "impact_texture": "fx_boss_crack_large", "color": Color("#f0c078"), "cast_size": 78.0, "impact_size": 84.0, "impact_ring": 34.0, "arc": 2.0, "line_width": 1.2}
		300314, 300330:
			return {"cast": "fx_bloodmoon_cast", "projectile": "fx_bloodmoon", "impact_texture": "fx_fireball_boom", "color": Color("#ff3650"), "cast_size": 80.0, "projectile_size": 44.0, "impact_size": 92.0, "impact_ring": 42.0, "arc": 24.0, "line_width": 1.5}
		300315:
			return {"cast": "fx_bloodmoon_cast", "projectile": "fx_bloodmoon", "impact_texture": "fx_bloodmoon", "color": Color("#f0244a"), "cast_size": 88.0, "projectile_size": 52.0, "impact_size": 82.0, "impact_ring": 44.0, "arc": 18.0, "line_width": 1.5}
		300321, 300323:
			return {"cast": "fx_shield", "projectile": "fx_shield", "impact_texture": "fx_hit_white", "color": Color("#d7eef8"), "cast_size": 54.0, "projectile_size": 34.0, "impact_size": 48.0, "impact_ring": 24.0, "arc": 8.0, "line_width": 0.8}
		300322:
			return {"projectile": "fx_hit_white", "impact_texture": "fx_hit_white", "color": Color("#f4f4f4"), "projectile_size": 34.0, "impact_size": 42.0, "impact_ring": 18.0, "arc": 8.0, "line_width": 1.0}
		300326:
			return {"cast": "fx_fireball", "projectile": "fx_fireball", "impact_texture": "fx_hit_dust", "color": Color("#ffb05a"), "cast_size": 42.0, "projectile_size": 42.0, "impact_size": 46.0, "impact_ring": 20.0, "arc": 14.0, "line_width": 1.0}
		_:
			return {"projectile": "fx_skill_orb", "impact_texture": "fx_hit_blue", "color": Color("#ff6b35"), "projectile_size": 26.0, "impact_size": 34.0, "impact_ring": 13.0, "arc": 12.0, "line_width": 1.0}


func _find_entity(list: Array, runtime_id: int) -> Dictionary:
	for entry in list:
		if typeof(entry) == TYPE_DICTIONARY and int(entry.get("id", -1)) == runtime_id:
			return entry
	return {}


func _world_to_field(pos: Vector2, field: Rect2, world_size: Vector2) -> Vector2:
	return Vector2(
		field.position.x + (pos.x / world_size.x) * field.size.x,
		field.position.y + (pos.y / world_size.y) * field.size.y
	)
