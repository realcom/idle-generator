extends Control

const ContentStore := preload("res://scripts/content_store.gd")
const BattleSim := preload("res://scripts/battle_sim.gd")
const Catalog := preload("res://scripts/core/ninja2_catalog.gd")
const RunState := preload("res://scripts/sim/run_state.gd")
const HousingTechStore := preload("res://scripts/home/housing_tech_store.gd")
const SanctuaryState := preload("res://scripts/home/sanctuary_state.gd")
const HomeScreen := preload("res://scripts/home/home_screen.gd")
const GeneratedBattleActionDock := preload("res://scenes/generated/battle_action_dock.tscn")
const BattleTileWorld := preload("res://scripts/battle_tile_world.gd")
const BasicSlashFxScene := preload("res://scenes/effects/basic_slash_fx.tscn")
const ProjectileVolleyFxScene := preload("res://scenes/effects/projectile_volley_fx.tscn")
const GroundAreaFxScene := preload("res://scenes/effects/ground_area_fx.tscn")
const SelfBuffFxScene := preload("res://scenes/effects/self_buff_fx.tscn")
const CooldownRadialMask := preload("res://scripts/ui/cooldown_radial_mask.gd")
const PhaserAudioBridge := preload("res://scripts/audio/phaser_audio_bridge.gd")

const JOYSTICK_CORE_HALF_SIZE := 23.0
const JOYSTICK_CORE_TRAVEL := 28.0
const PLAYER_WALK_COLUMNS := 8
const PLAYER_WALK_FRAME_RATE := 14.0
const PLAYER_DIRECTION_HYSTERESIS := 0.14
const ENEMY_WALK_COLUMNS := 4
const ENEMY_WALK_ROW_COUNT := 3
const ENEMY_WALK_FRAME_RATE := 6.2
const ENEMY_HOP_CYCLE_STEPS := 6.0
const ENEMY_HOP_REST_STEP := 5.0
const BATTLE_CAMERA_FOLLOW := 7.5
const BATTLE_CAMERA_MAX_WORLD_OFFSET := 112.0
const BATTLE_BASE_WORLD_TO_SCREEN_SCALE := 0.62
const BATTLE_WORLD_TO_SCREEN_SCALE := 0.54
const BATTLE_CAMERA_VISUAL_SCALE := BATTLE_WORLD_TO_SCREEN_SCALE / BATTLE_BASE_WORLD_TO_SCREEN_SCALE
const SKILL_FX_SCALE := 0.52

var store
var sim
var run_state
var housing_store
var sanctuary_state
var audio_bridge
var textures := {}
var entity_views := {}
var event_views: Array[Label] = []

var title_screen: Control
var home_screen
var battle_screen: Control
var battle_tile_world
var world_layer: Control
var feedback_layer: Control
var skill_fx_layer: Control
var entity_layer: Control
var event_layer: Control
var level_choice_overlay: Control
var level_choice_panel: PanelContainer
var level_choice_title_label: Label
var level_choice_subtitle_label: Label
var level_choice_summary_label: Label
var level_choice_grid: HBoxContainer
var level_choice_render_key := ""
var result_overlay: Control
var result_panel: PanelContainer
var result_label: Label
var result_kicker_label: Label
var result_title_label: Label
var result_stage_badge_label: Label
var result_summary_label: Label
var result_stats_box: HBoxContainer
var result_rewards_box: VBoxContainer
var result_rewards_scroll: ScrollContainer
var result_status_header: Control
var result_status_art: TextureRect
var result_status_crest: TextureRect
var result_reward_title_brush: TextureRect
var result_return_button_skin: TextureRect
var stage_select: OptionButton
var home_summary: TextEdit
var home_resource_labels := {}
var battle_resource_labels := {}
var battle_gain_labels := {}
var hp_bar: ProgressBar
var exp_bar: ProgressBar
var exp_level_label: Label
var exp_value_label: Label
var timer_label: Label
var wave_label: Label
var kill_label: Label
var enemy_label: Label
var pickup_label: Label
var pending_label: Label
var map_label: Label
var objective_label: Label
var profile_level_label: Label
var profile_hp_label: Label
var title_status_label: Label
var title_start_button: Button
var skill_cooldown_labels := {}
var wave_segments: Array[ColorRect] = []
var timer_stage_pips: Array[ColorRect] = []
var dash_cooldown_label: Label
var dash_cooldown_mask: Control
var joystick_panel: Control
var joystick_core: Control
var dash_button_panel: Control
var battle_action_panels: Array[Control] = []
var battle_action_labels := {}
var battle_action_skill_panels := {}
var hero_aura_outer: PanelContainer
var hero_aura_inner: PanelContainer
var hero_aura_ticks: Array[ColorRect] = []
var boss_telegraph_views := {}
var ground_area_views := {}
var ambient_pickup_views: Array[Control] = []
var skill_slash_views: Array[TextureRect] = []
var skill_fx_nodes: Array[Node] = []
var handled_skill_fx_events := {}
var threat_line_views: Array[ColorRect] = []
var joystick_vector := Vector2.ZERO
var battle_input_vector := Vector2.ZERO
var battle_frame_delta := 0.016
var battle_camera_world_position := Vector2.ZERO
var battle_camera_start_position := Vector2.ZERO
var battle_camera_ready := false
var joystick_active := false
var joystick_pointer_id := -2
var last_battle_input_vector := Vector2.DOWN
var battle_visual_fixture := false
var battle_visual_fixture_motion := false
var player_walk_frames := {}
var enemy_walk_frames := {}
var player_render_motion := Vector2.ZERO
var player_render_facing := Vector2.DOWN
var player_walk_phase := 0.0
var last_audio_snapshot := {}


func _ready() -> void:
	store = ContentStore.new()
	var ok: bool = store.load_all()
	housing_store = HousingTechStore.new()
	var housing_ok: bool = housing_store.load_all()
	sanctuary_state = SanctuaryState.new()
	sanctuary_state.seed_from_housing(housing_store)
	run_state = RunState.new()
	run_state.load()
	sanctuary_state.apply_run_resources(run_state.resources)
	audio_bridge = PhaserAudioBridge.new()
	audio_bridge.name = "PhaserAudioBridge"
	add_child(audio_bridge)
	audio_bridge.load_from_phaser()
	audio_bridge.apply_settings(sanctuary_state.settings)
	audio_bridge.set_mode("boot")
	sim = BattleSim.new(store, run_state)
	sim.set_visual_fixture(battle_visual_fixture)
	sim.set_visual_fixture_motion(battle_visual_fixture_motion)
	_load_textures()
	_build_ui()
	_populate_home()
	_sync_title_status()

	if ok and housing_ok:
		home_screen.set_status_message("ninja2 JSON 로드 완료")
	else:
		home_screen.set_status_message("로드 경고 있음. 데이터 패널 확인")


func set_battle_visual_fixture(enabled: bool) -> void:
	battle_visual_fixture = enabled
	if sim != null:
		sim.set_visual_fixture(enabled)


func set_battle_visual_fixture_motion(enabled: bool) -> void:
	battle_visual_fixture_motion = enabled
	if sim != null:
		sim.set_visual_fixture_motion(enabled)


func _process(delta: float) -> void:
	if battle_screen != null and battle_screen.visible:
		battle_frame_delta = clamp(delta, 0.001, 0.05)
		var move_vector: Vector2 = _current_battle_input_vector()
		sim.set_player_input(move_vector)
		_sync_joystick_visual(move_vector)
		sim.step(delta)
		_sync_battle()


func _input(event: InputEvent) -> void:
	if _handle_refresh_shortcut(event):
		return

	if battle_screen == null or not battle_screen.visible:
		return

	if _level_choice_visible():
		_handle_level_choice_key(event)
		return

	if _result_visible():
		return

	if event is InputEventKey:
		var key_event := event as InputEventKey
		if key_event.pressed and not key_event.echo and key_event.keycode == KEY_SPACE:
			_request_dash("keyboard")
			get_viewport().set_input_as_handled()
		return

	if event is InputEventMouseButton:
		var mouse_button := event as InputEventMouseButton
		if mouse_button.button_index != MOUSE_BUTTON_LEFT:
			return
		if mouse_button.pressed:
			if _control_contains_global(dash_button_panel, mouse_button.position):
				_request_dash("button")
				get_viewport().set_input_as_handled()
			elif _control_contains_global(joystick_panel, mouse_button.position):
				joystick_active = true
				joystick_pointer_id = -1
				_update_joystick_from_global(mouse_button.position)
				get_viewport().set_input_as_handled()
		elif joystick_active and joystick_pointer_id == -1:
			_reset_joystick()
			get_viewport().set_input_as_handled()
		return

	if event is InputEventMouseMotion:
		var mouse_motion := event as InputEventMouseMotion
		if joystick_active and joystick_pointer_id == -1:
			_update_joystick_from_global(mouse_motion.position)
			get_viewport().set_input_as_handled()
		return

	if event is InputEventScreenTouch:
		var touch := event as InputEventScreenTouch
		if touch.pressed:
			if _control_contains_global(dash_button_panel, touch.position):
				_request_dash("touch")
				get_viewport().set_input_as_handled()
			elif _control_contains_global(joystick_panel, touch.position):
				joystick_active = true
				joystick_pointer_id = touch.index
				_update_joystick_from_global(touch.position)
				get_viewport().set_input_as_handled()
		elif joystick_active and joystick_pointer_id == touch.index:
			_reset_joystick()
			get_viewport().set_input_as_handled()
		return

	if event is InputEventScreenDrag:
		var drag := event as InputEventScreenDrag
		if joystick_active and joystick_pointer_id == drag.index:
			_update_joystick_from_global(drag.position)
			get_viewport().set_input_as_handled()


func _handle_refresh_shortcut(event: InputEvent) -> bool:
	if not (event is InputEventKey):
		return false
	var key_event := event as InputEventKey
	if not key_event.pressed or key_event.echo or key_event.keycode != KEY_F5:
		return false

	get_viewport().set_input_as_handled()
	if key_event.shift_pressed:
		print("ninja2 scene reload requested")
		get_tree().reload_current_scene()
	else:
		_reload_data()
	return true


func _load_textures() -> void:
	var paths: Dictionary = Catalog.all_texture_paths()
	if housing_store != null:
		for key in housing_store.all_texture_paths().keys():
			paths[key] = housing_store.all_texture_paths()[key]
	for key in paths.keys():
		textures[key] = _load_texture(paths[key])
	_build_player_walk_frames()
	_build_enemy_walk_frames()


func _build_player_walk_frames() -> void:
	player_walk_frames.clear()
	var sheet := textures.get("player_walk_sheet") as Texture2D
	if sheet == null:
		return
	var sheet_image: Image = sheet.get_image()
	if sheet_image == null or sheet_image.is_empty():
		return
	var cell_width := int(round(float(sheet_image.get_width()) / float(PLAYER_WALK_COLUMNS)))
	var row_count: int = max(1, int(round(float(sheet_image.get_height()) / float(max(1, cell_width)))))
	var directions: Array[String] = _player_walk_directions(row_count)
	var cell_size := Vector2i(
		cell_width,
		int(round(float(sheet_image.get_height()) / float(max(1, directions.size()))))
	)
	for row in range(directions.size()):
		var direction := directions[row]
		var bounds: Rect2i = _walk_row_alpha_bounds(sheet_image, row, cell_size, PLAYER_WALK_COLUMNS)
		var frames: Array[Texture2D] = []
		for column in range(PLAYER_WALK_COLUMNS):
			var frame_origin := Vector2i(
				column * cell_size.x + bounds.position.x,
				row * cell_size.y + bounds.position.y
			)
			var frame_image: Image = sheet_image.get_region(Rect2i(frame_origin, bounds.size))
			frames.append(ImageTexture.create_from_image(frame_image))
		player_walk_frames[direction] = frames


func _player_walk_directions(row_count: int) -> Array[String]:
	if row_count >= 4:
		return ["down", "left", "right", "up"]
	return ["down", "right", "up"]


func _build_enemy_walk_frames() -> void:
	enemy_walk_frames.clear()
	_build_enemy_walk_frames_for(Catalog.LEAF_IMP_UNIT_ID, "enemy_walk_leaf_imp")
	_build_enemy_walk_frames_for(Catalog.SOOT_SPIRIT_UNIT_ID, "enemy_float_soot_spirit")
	_build_enemy_walk_frames_for(Catalog.PURPLE_MUSHROOM_UNIT_ID, "enemy_walk_purple_mushroom")
	_build_enemy_walk_frames_for(Catalog.BOSS_UNIT_ID, "enemy_lumber_thorn_boss")


func _build_enemy_walk_frames_for(unit_id: int, texture_key: String) -> void:
	var sheet := textures.get(texture_key) as Texture2D
	if sheet == null:
		return
	var sheet_image: Image = sheet.get_image()
	if sheet_image == null or sheet_image.is_empty():
		return
	var cell_size := Vector2i(
		int(round(float(sheet_image.get_width()) / float(ENEMY_WALK_COLUMNS))),
		int(round(float(sheet_image.get_height()) / float(ENEMY_WALK_ROW_COUNT)))
	)
	var directions: Array[String] = ["down", "left", "up"]
	for row in range(directions.size()):
		var direction := directions[row]
		var bounds: Rect2i = _walk_row_alpha_bounds(sheet_image, row, cell_size, ENEMY_WALK_COLUMNS)
		var frames: Array[Texture2D] = []
		for column in range(ENEMY_WALK_COLUMNS):
			var frame_origin := Vector2i(
				column * cell_size.x + bounds.position.x,
				row * cell_size.y + bounds.position.y
			)
			var frame_image: Image = sheet_image.get_region(Rect2i(frame_origin, bounds.size))
			frames.append(ImageTexture.create_from_image(frame_image))
		enemy_walk_frames["%d_%s" % [unit_id, direction]] = frames


func _walk_row_alpha_bounds(sheet_image: Image, row: int, cell_size: Vector2i, columns: int) -> Rect2i:
	var min_x := cell_size.x
	var min_y := cell_size.y
	var max_x := -1
	var max_y := -1
	var row_y := row * cell_size.y
	for column in range(columns):
		var cell_x := column * cell_size.x
		for y in range(cell_size.y):
			for x in range(cell_size.x):
				if sheet_image.get_pixel(cell_x + x, row_y + y).a <= 0.03:
					continue
				min_x = min(min_x, x)
				min_y = min(min_y, y)
				max_x = max(max_x, x)
				max_y = max(max_y, y)
	if max_x < min_x or max_y < min_y:
		return Rect2i(Vector2i.ZERO, cell_size)

	var padding := 8
	min_x = max(0, min_x - padding)
	min_y = max(0, min_y - padding)
	max_x = min(cell_size.x - 1, max_x + padding)
	max_y = min(cell_size.y - 1, max_y + padding)
	return Rect2i(Vector2i(min_x, min_y), Vector2i(max_x - min_x + 1, max_y - min_y + 1))


func _build_ui() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	title_screen = Control.new()
	title_screen.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(title_screen)

	home_screen = HomeScreen.new()
	home_screen.set_anchors_preset(Control.PRESET_FULL_RECT)
	home_screen.visible = false
	add_child(home_screen)

	battle_screen = Control.new()
	battle_screen.set_anchors_preset(Control.PRESET_FULL_RECT)
	battle_screen.visible = false
	add_child(battle_screen)

	_build_title_screen()
	_build_home_screen()
	_build_battle_screen()


func _build_title_screen() -> void:
	_add_fullscreen_texture(title_screen, textures.get("title_splash"), Color(0.05, 0.08, 0.07))
	_add_overlay(title_screen, Color(0.0, 0.0, 0.0, 0.34))

	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 22)
	margin.add_theme_constant_override("margin_top", 24)
	margin.add_theme_constant_override("margin_right", 22)
	margin.add_theme_constant_override("margin_bottom", 28)
	title_screen.add_child(margin)

	var root := VBoxContainer.new()
	root.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_theme_constant_override("separation", 16)
	margin.add_child(root)

	var logo := TextureRect.new()
	logo.texture = textures.get("title_logo")
	logo.custom_minimum_size = Vector2(360, 156)
	logo.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	logo.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	root.add_child(logo)

	var tagline := Label.new()
	tagline.text = "Godot client runtime"
	tagline.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	tagline.add_theme_font_size_override("font_size", 16)
	tagline.add_theme_color_override("font_color", Color(0.88, 0.95, 0.82))
	root.add_child(tagline)

	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(spacer)

	var menu := VBoxContainer.new()
	menu.add_theme_constant_override("separation", 10)
	root.add_child(menu)

	title_status_label = Label.new()
	title_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_status_label.add_theme_font_size_override("font_size", 15)
	title_status_label.add_theme_color_override("font_color", Color(1.0, 0.91, 0.72))
	menu.add_child(title_status_label)

	title_start_button = _title_button("시작하기")
	title_start_button.pressed.connect(func():
		_play_sfx("uiClick", {"volume": 0.72})
		_open_home()
	)
	menu.add_child(title_start_button)

	var quick_button := _title_button("바로 출격")
	quick_button.pressed.connect(func():
		_play_sfx("uiClick", {"volume": 0.72})
		_quick_start_battle()
	)
	menu.add_child(quick_button)

	var reset_reload := HBoxContainer.new()
	reset_reload.add_theme_constant_override("separation", 8)
	menu.add_child(reset_reload)

	var reset_button := Button.new()
	reset_button.text = "새 게임"
	reset_button.custom_minimum_size = Vector2(0, 48)
	reset_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	reset_button.pressed.connect(func():
		_play_sfx("uiClick", {"volume": 0.72})
		_reset_progress_from_title()
	)
	reset_reload.add_child(reset_button)

	var reload_button := Button.new()
	reload_button.text = "데이터 새로고침"
	reload_button.custom_minimum_size = Vector2(0, 48)
	reload_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	reload_button.pressed.connect(func():
		_play_sfx("uiClick", {"volume": 0.72})
		_reload_data()
	)
	reset_reload.add_child(reload_button)


func _build_home_screen() -> void:
	home_screen.setup(store, housing_store, sanctuary_state, textures)
	home_screen.sortie_requested.connect(_start_battle)
	home_screen.title_requested.connect(_return_title)
	home_screen.reload_requested.connect(_reload_data)
	home_screen.state_changed.connect(_sync_audio_settings)


func _build_battle_screen() -> void:
	var bg := ColorRect.new()
	bg.color = Color(0.07, 0.12, 0.075)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	battle_screen.add_child(bg)

	battle_tile_world = BattleTileWorld.new()
	battle_tile_world.name = "BattleTileWorld"
	battle_screen.add_child(battle_tile_world)

	world_layer = Control.new()
	world_layer.set_anchors_preset(Control.PRESET_FULL_RECT)
	world_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	battle_screen.add_child(world_layer)

	_add_bottom_battle_depth()

	feedback_layer = Control.new()
	feedback_layer.set_anchors_preset(Control.PRESET_FULL_RECT)
	battle_screen.add_child(feedback_layer)
	_build_battle_feedback_layer()

	entity_layer = Control.new()
	entity_layer.set_anchors_preset(Control.PRESET_FULL_RECT)
	battle_screen.add_child(entity_layer)

	skill_fx_layer = Control.new()
	skill_fx_layer.set_anchors_preset(Control.PRESET_FULL_RECT)
	skill_fx_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	battle_screen.add_child(skill_fx_layer)

	event_layer = Control.new()
	event_layer.set_anchors_preset(Control.PRESET_FULL_RECT)
	battle_screen.add_child(event_layer)
	_add_battle_control_scrim()

	_build_battle_top_hud()
	_build_battle_bottom_controls()
	_build_level_choice_panel()
	_build_result_panel()


func _build_battle_top_hud() -> void:
	var top_margin := MarginContainer.new()
	top_margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	top_margin.add_theme_constant_override("margin_left", 8)
	top_margin.add_theme_constant_override("margin_top", 7)
	top_margin.add_theme_constant_override("margin_right", 8)
	top_margin.add_theme_constant_override("margin_bottom", 0)
	battle_screen.add_child(top_margin)

	var root := VBoxContainer.new()
	root.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root.add_theme_constant_override("separation", 3)
	top_margin.add_child(root)

	var hud_row := Control.new()
	hud_row.custom_minimum_size = Vector2(0, 96)
	hud_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hud_row.clip_contents = false
	root.add_child(hud_row)

	var profile_panel := _battle_profile_hud()
	profile_panel.position = Vector2(0, 0)
	hud_row.add_child(profile_panel)

	var center_panel := _hud_panel(
		Color(0.025, 0.032, 0.028, 0.94),
		Color(0.12, 0.13, 0.1, 0.98),
		5,
		Vector2(122, 86),
		3,
		Vector4(9, 7, 9, 7),
		Color(0.58, 0.47, 0.28, 0.96)
	)
	center_panel.position = Vector2(204, 0)
	center_panel.size = Vector2(122, 86)
	hud_row.add_child(center_panel)

	var center_box := VBoxContainer.new()
	center_box.alignment = BoxContainer.ALIGNMENT_CENTER
	center_box.add_theme_constant_override("separation", 2)
	center_panel.add_child(center_box)

	timer_label = Label.new()
	timer_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	timer_label.add_theme_font_size_override("font_size", 25)
	timer_label.add_theme_color_override("font_color", Color(0.96, 0.95, 0.84))
	timer_label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.75))
	timer_label.add_theme_constant_override("shadow_offset_x", 1)
	timer_label.add_theme_constant_override("shadow_offset_y", 2)
	center_box.add_child(timer_label)

	var divider := ColorRect.new()
	divider.color = Color(0.78, 0.65, 0.44, 0.32)
	divider.custom_minimum_size = Vector2(84, 1)
	center_box.add_child(divider)

	wave_label = Label.new()
	wave_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	wave_label.add_theme_font_size_override("font_size", 13)
	wave_label.add_theme_color_override("font_color", Color(1.0, 0.84, 0.33))
	wave_label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.72))
	wave_label.add_theme_constant_override("shadow_offset_x", 1)
	wave_label.add_theme_constant_override("shadow_offset_y", 1)
	center_box.add_child(wave_label)

	map_label = Label.new()
	map_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	map_label.visible = false
	center_box.add_child(map_label)

	var timer_pip_row := Control.new()
	timer_pip_row.custom_minimum_size = Vector2(84, 14)
	timer_pip_row.size = timer_pip_row.custom_minimum_size
	center_box.add_child(timer_pip_row)
	timer_stage_pips.clear()
	for index in range(7):
		var pip := _add_hud_diamond(timer_pip_row, Vector2(5 + index * 11, 2), index < 3, Color(0.11, 0.82, 0.78, 0.95))
		timer_stage_pips.append(pip)

	var resource_panel := _hud_panel(
		Color(0.026, 0.042, 0.033, 0.78),
		Color(0.12, 0.13, 0.1, 0.9),
		7,
		Vector2(122, 92),
		2,
		Vector4(5, 4, 5, 4),
		Color(0.58, 0.45, 0.22, 0.88)
	)
	resource_panel.position = Vector2(348, 0)
	resource_panel.size = Vector2(122, 92)
	hud_row.add_child(resource_panel)

	var resource_box := VBoxContainer.new()
	resource_box.add_theme_constant_override("separation", 3)
	resource_panel.add_child(resource_box)
	for resource_key in Catalog.RESOURCE_KEYS:
		resource_box.add_child(_battle_resource_chip(resource_key))

	var pause_button := Button.new()
	pause_button.text = "II"
	pause_button.position = Vector2(478, 4)
	pause_button.size = Vector2(46, 46)
	pause_button.custom_minimum_size = Vector2(46, 46)
	pause_button.add_theme_font_size_override("font_size", 20)
	pause_button.add_theme_color_override("font_color", Color(0.98, 0.88, 0.62))
	pause_button.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.72))
	pause_button.add_theme_constant_override("shadow_offset_x", 1)
	pause_button.add_theme_constant_override("shadow_offset_y", 2)
	pause_button.add_theme_stylebox_override("normal", _hud_style(Color(0.025, 0.033, 0.028, 0.94), Color(0.11, 0.12, 0.09, 0.98), 8, 3, Color(0.64, 0.5, 0.28, 0.95)))
	pause_button.add_theme_stylebox_override("hover", _hud_style(Color(0.045, 0.06, 0.046, 0.96), Color(0.14, 0.14, 0.1, 0.98), 8, 3, Color(0.9, 0.72, 0.34, 0.98)))
	pause_button.add_theme_stylebox_override("pressed", _hud_style(Color(0.015, 0.02, 0.018, 0.98), Color(0.12, 0.1, 0.08, 0.98), 8, 3, Color(0.9, 0.72, 0.34, 0.98)))
	hud_row.add_child(pause_button)

	var progress_panel := _hud_panel(Color(0.025, 0.045, 0.034, 0.64), Color(0.08, 0.09, 0.07, 0.86), 7, Vector2(0, 17), 2, Vector4(7, 4, 7, 4), Color(0.62, 0.48, 0.21, 0.78))
	progress_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root.add_child(progress_panel)

	var progress := HBoxContainer.new()
	progress.add_theme_constant_override("separation", 3)
	progress_panel.add_child(progress)
	wave_segments.clear()
	for _index in range(8):
		var segment := ColorRect.new()
		segment.color = Color(0.055, 0.09, 0.075, 0.88)
		segment.custom_minimum_size = Vector2(0, 7)
		segment.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		progress.add_child(segment)
		wave_segments.append(segment)

	var objective := _compact_battle_panel(Color(0.025, 0.04, 0.03, 0.28), Color(0.5, 0.38, 0.16, 0.32), 6, Vector2(0, 18), 1, Vector4(8, 1, 8, 1))
	objective.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root.add_child(objective)

	var objective_row := HBoxContainer.new()
	objective_row.add_theme_constant_override("separation", 5)
	objective.add_child(objective_row)

	objective_label = Label.new()
	objective_label.clip_text = true
	objective_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	objective_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	objective_label.custom_minimum_size = Vector2(130, 0)
	objective_label.add_theme_font_size_override("font_size", 10)
	objective_label.add_theme_color_override("font_color", Color(1.0, 0.86, 0.38))
	objective_row.add_child(objective_label)

	kill_label = _battle_counter_chip("counter_kill", "0")
	enemy_label = _battle_counter_chip("counter_enemy", "0")
	pickup_label = _battle_counter_chip("counter_pickup", "0")
	pending_label = _battle_stat_label("0")
	objective_row.add_child(kill_label.get_parent())
	objective_row.add_child(enemy_label.get_parent())
	objective_row.add_child(pickup_label.get_parent())


func _build_battle_bottom_controls() -> void:
	var joystick := Control.new()
	joystick_panel = joystick
	joystick.anchor_left = 0.0
	joystick.anchor_top = 1.0
	joystick.anchor_right = 0.0
	joystick.anchor_bottom = 1.0
	joystick.offset_left = 20
	joystick.offset_top = -218
	joystick.offset_right = 166
	joystick.offset_bottom = -72
	battle_screen.add_child(joystick)

	var joystick_bg := PanelContainer.new()
	joystick_bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	joystick_bg.add_theme_stylebox_override("panel", _style(Color(0.0, 0.0, 0.0, 0.04), Color(0.83, 0.78, 0.61, 0.64), 64, 2))
	joystick.add_child(joystick_bg)
	_add_joystick_marker(joystick, Vector2(68, 12), Vector2(10, 6))
	_add_joystick_marker(joystick, Vector2(68, 128), Vector2(10, 6))
	_add_joystick_marker(joystick, Vector2(12, 68), Vector2(6, 10))
	_add_joystick_marker(joystick, Vector2(128, 68), Vector2(6, 10))

	var joystick_core := PanelContainer.new()
	self.joystick_core = joystick_core
	joystick_core.anchor_left = 0.5
	joystick_core.anchor_top = 0.5
	joystick_core.anchor_right = 0.5
	joystick_core.anchor_bottom = 0.5
	joystick_core.offset_left = -23
	joystick_core.offset_top = -23
	joystick_core.offset_right = 23
	joystick_core.offset_bottom = 23
	joystick_core.add_theme_stylebox_override("panel", _style(Color(0.72, 0.68, 0.54, 0.58), Color(0.08, 0.08, 0.06, 0.68), 32, 2))
	joystick.add_child(joystick_core)

	_build_battle_action_dock()

	var exp_panel := PanelContainer.new()
	exp_panel.anchor_left = 0.0
	exp_panel.anchor_top = 1.0
	exp_panel.anchor_right = 1.0
	exp_panel.anchor_bottom = 1.0
	exp_panel.offset_left = 28
	exp_panel.offset_top = -55
	exp_panel.offset_right = -28
	exp_panel.offset_bottom = -15
	var exp_shell_style := _style(Color(0.015, 0.032, 0.026, 0.96), Color(0.72, 0.52, 0.25, 0.94), 9, 2)
	exp_shell_style.content_margin_left = 7
	exp_shell_style.content_margin_right = 7
	exp_shell_style.content_margin_top = 5
	exp_shell_style.content_margin_bottom = 5
	exp_shell_style.shadow_color = Color(0.0, 0.0, 0.0, 0.36)
	exp_shell_style.shadow_size = 5
	exp_shell_style.shadow_offset = Vector2(0, 2)
	exp_panel.add_theme_stylebox_override("panel", exp_shell_style)
	battle_screen.add_child(exp_panel)

	var exp_box := HBoxContainer.new()
	exp_box.set_anchors_preset(Control.PRESET_FULL_RECT)
	exp_box.add_theme_constant_override("separation", 7)
	exp_panel.add_child(exp_box)

	var exp_badge := PanelContainer.new()
	exp_badge.custom_minimum_size = Vector2(82, 30)
	var exp_badge_style := _style(Color(0.09, 0.13, 0.09, 0.98), Color(1.0, 0.72, 0.24, 0.96), 8, 2)
	exp_badge_style.content_margin_left = 6
	exp_badge_style.content_margin_right = 6
	exp_badge_style.content_margin_top = 2
	exp_badge_style.content_margin_bottom = 2
	exp_badge.add_theme_stylebox_override("panel", exp_badge_style)
	exp_box.add_child(exp_badge)

	var exp_badge_box := VBoxContainer.new()
	exp_badge_box.alignment = BoxContainer.ALIGNMENT_CENTER
	exp_badge_box.add_theme_constant_override("separation", 0)
	exp_badge.add_child(exp_badge_box)

	var exp_badge_title := Label.new()
	exp_badge_title.text = "EXP"
	exp_badge_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	exp_badge_title.add_theme_font_size_override("font_size", 9)
	exp_badge_title.add_theme_color_override("font_color", Color(0.54, 0.95, 1.0))
	exp_badge_box.add_child(exp_badge_title)

	exp_level_label = Label.new()
	exp_level_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	exp_level_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	exp_level_label.add_theme_font_size_override("font_size", 13)
	exp_level_label.add_theme_color_override("font_color", Color(1.0, 0.9, 0.58))
	exp_badge_box.add_child(exp_level_label)

	var exp_track_shell := PanelContainer.new()
	exp_track_shell.custom_minimum_size = Vector2(0, 24)
	exp_track_shell.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var exp_track_shell_style := _style(Color(0.01, 0.018, 0.018, 0.96), Color(0.06, 0.1, 0.09, 0.9), 8, 1)
	exp_track_shell_style.content_margin_left = 3
	exp_track_shell_style.content_margin_right = 3
	exp_track_shell_style.content_margin_top = 3
	exp_track_shell_style.content_margin_bottom = 3
	exp_track_shell.add_theme_stylebox_override("panel", exp_track_shell_style)
	exp_box.add_child(exp_track_shell)

	var exp_track_stack := Control.new()
	exp_track_stack.custom_minimum_size = Vector2(0, 18)
	exp_track_stack.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	exp_track_stack.size_flags_vertical = Control.SIZE_EXPAND_FILL
	exp_track_shell.add_child(exp_track_stack)

	exp_bar = ProgressBar.new()
	exp_bar.set_anchors_preset(Control.PRESET_FULL_RECT)
	exp_bar.show_percentage = false
	exp_bar.max_value = 1.0
	exp_bar.value = 0.0
	exp_bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var exp_track_bg := _style(Color(0.018, 0.035, 0.038, 0.96), Color(0.12, 0.18, 0.16, 0.74), 6, 1)
	exp_track_bg.content_margin_left = 0
	exp_track_bg.content_margin_right = 0
	exp_track_bg.content_margin_top = 0
	exp_track_bg.content_margin_bottom = 0
	var exp_track_fill := _style(Color(0.13, 0.63, 1.0, 0.96), Color(0.68, 0.95, 1.0, 0.86), 6, 1)
	exp_track_fill.content_margin_left = 0
	exp_track_fill.content_margin_right = 0
	exp_track_fill.content_margin_top = 0
	exp_track_fill.content_margin_bottom = 0
	exp_bar.add_theme_stylebox_override("background", exp_track_bg)
	exp_bar.add_theme_stylebox_override("fill", exp_track_fill)
	exp_track_stack.add_child(exp_bar)

	var exp_sheen := ColorRect.new()
	exp_sheen.color = Color(0.86, 1.0, 1.0, 0.12)
	exp_sheen.anchor_left = 0.0
	exp_sheen.anchor_top = 0.0
	exp_sheen.anchor_right = 1.0
	exp_sheen.anchor_bottom = 0.0
	exp_sheen.offset_left = 5
	exp_sheen.offset_top = 3
	exp_sheen.offset_right = -5
	exp_sheen.offset_bottom = 5
	exp_sheen.mouse_filter = Control.MOUSE_FILTER_IGNORE
	exp_track_stack.add_child(exp_sheen)

	var exp_tick_row := HBoxContainer.new()
	exp_tick_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	exp_tick_row.set_anchors_preset(Control.PRESET_FULL_RECT)
	exp_tick_row.offset_left = 8
	exp_tick_row.offset_right = -8
	exp_tick_row.add_theme_constant_override("separation", 0)
	exp_track_stack.add_child(exp_tick_row)
	for index in range(8):
		var tick_slot := Control.new()
		tick_slot.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		tick_slot.mouse_filter = Control.MOUSE_FILTER_IGNORE
		exp_tick_row.add_child(tick_slot)
		if index >= 7:
			continue
		var tick := ColorRect.new()
		tick.color = Color(0.78, 0.95, 1.0, 0.16)
		tick.anchor_left = 1.0
		tick.anchor_top = 0.22
		tick.anchor_right = 1.0
		tick.anchor_bottom = 0.78
		tick.offset_left = -1
		tick.offset_right = 0
		tick.mouse_filter = Control.MOUSE_FILTER_IGNORE
		tick_slot.add_child(tick)

	exp_value_label = Label.new()
	exp_value_label.custom_minimum_size = Vector2(78, 30)
	exp_value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	exp_value_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	exp_value_label.add_theme_font_size_override("font_size", 12)
	exp_value_label.add_theme_color_override("font_color", Color(0.9, 0.98, 1.0))
	exp_value_label.add_theme_stylebox_override("normal", _style(Color(0.02, 0.045, 0.04, 0.58), Color(0.24, 0.68, 0.78, 0.34), 8, 1))
	exp_box.add_child(exp_value_label)


func _build_battle_action_dock() -> void:
	battle_action_panels.clear()
	battle_action_labels.clear()
	battle_action_skill_panels.clear()

	var dock := GeneratedBattleActionDock.instantiate() as Control
	dock.anchor_left = 1.0
	dock.anchor_top = 1.0
	dock.anchor_right = 1.0
	dock.anchor_bottom = 1.0
	dock.offset_left = -204
	dock.offset_top = -248
	dock.offset_right = -14
	dock.offset_bottom = -70
	dock.mouse_filter = Control.MOUSE_FILTER_PASS
	battle_screen.add_child(dock)

	var primary := dock.get_node_or_null("Btn_PrimaryDash") as Control
	if primary != null:
		_align_primary_dash_to_dock_bottom(dock, primary)
		_configure_generated_action_button(primary, true)
		battle_action_panels.append(primary)
	dash_button_panel = primary
	dash_cooldown_label = primary.find_child("Text_PrimaryDashCooldown", true, false) as Label if primary != null else null
	if dash_cooldown_label != null:
		dash_cooldown_label.text = ""
		dash_cooldown_label.add_theme_font_size_override("font_size", 13)
		dash_cooldown_label.add_theme_color_override("font_color", Color(0.9, 1.0, 0.86))

	var secondary_paths: Array[String] = ["Btn_SecondarySkillLeft", "Btn_SecondarySkillRight"]
	for path in secondary_paths:
		var skill_panel := dock.get_node_or_null(path) as Control
		if skill_panel != null:
			skill_panel.visible = false
			skill_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _align_primary_dash_to_dock_bottom(dock: Control, button: Control) -> void:
	var dock_size := dock.custom_minimum_size
	if dock_size.x <= 0.0 or dock_size.y <= 0.0:
		dock_size = Vector2(188, 178)
	var button_size := button.custom_minimum_size
	if button_size.x <= 0.0 or button_size.y <= 0.0:
		button_size = Vector2(86, 86)
	var right_inset := 2.0
	button.position = Vector2(dock_size.x - button_size.x - right_inset, dock_size.y - button_size.y)
	button.size = button_size


func _configure_generated_action_button(button: Control, primary: bool) -> void:
	button.mouse_filter = Control.MOUSE_FILTER_PASS
	button.clip_contents = false
	var hit_area := button.get_node_or_null("Hit_PrimaryDash" if primary else ("Hit_SecondarySkillLeft" if button.name == "Btn_SecondarySkillLeft" else "Hit_SecondarySkillRight")) as Button
	if hit_area != null:
		hit_area.mouse_filter = Control.MOUSE_FILTER_PASS if primary else Control.MOUSE_FILTER_IGNORE
		hit_area.modulate = Color(1, 1, 1, 0)
	var frame := PanelContainer.new()
	frame.name = "RuntimeFrame"
	frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	frame.set_anchors_preset(Control.PRESET_FULL_RECT)
	button.add_child(frame)
	button.move_child(frame, 0)
	var rim := PanelContainer.new()
	rim.name = "RuntimeRimHighlight"
	rim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	rim.set_anchors_preset(Control.PRESET_FULL_RECT)
	rim.offset_left = 3
	rim.offset_top = 3
	rim.offset_right = -3
	rim.offset_bottom = -3
	button.add_child(rim)
	button.move_child(rim, 1)
	var inner_frame := PanelContainer.new()
	inner_frame.name = "RuntimeInnerFrame"
	inner_frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	inner_frame.set_anchors_preset(Control.PRESET_FULL_RECT)
	inner_frame.offset_left = 8 if primary else 7
	inner_frame.offset_top = 8 if primary else 7
	inner_frame.offset_right = -8 if primary else -7
	inner_frame.offset_bottom = -8 if primary else -7
	button.add_child(inner_frame)
	button.move_child(inner_frame, 2)
	_set_action_button_style(
		button,
		Color(0.02, 0.035, 0.03, 0.94),
		Color(0.92, 0.76, 0.46, 0.96) if primary else Color(0.78, 0.66, 0.44, 0.88),
		48 if primary else 42,
		3 if primary else 2
	)
	var icon := button.get_node_or_null("Icon_PrimaryDash" if primary else ("Icon_SecondarySkillLeft" if button.name == "Btn_SecondarySkillLeft" else "Icon_SecondarySkillRight")) as TextureRect
	if icon != null:
		icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		icon.modulate = Color(1.0, 1.0, 1.0, 0.96)
		icon.position = Vector2(13, 10) if primary else Vector2(13, 11)
		icon.size = Vector2(60, 60) if primary else Vector2(52, 52)
		icon.custom_minimum_size = icon.size
	var progress := button.get_node_or_null("Progress_PrimaryDashCooldown" if primary else ("Progress_SecondarySkillLeftCooldown" if button.name == "Btn_SecondarySkillLeft" else "Progress_SecondarySkillRightCooldown")) as ProgressBar
	if progress != null:
		progress.mouse_filter = Control.MOUSE_FILTER_IGNORE
		progress.show_percentage = false
		progress.max_value = 1.0
		progress.value = 0.0
		progress.visible = false
	if primary:
		dash_cooldown_mask = _add_dash_cooldown_mask(button)
	var label := button.get_node_or_null("Text_PrimaryDashCooldown" if primary else ("Text_SecondarySkillLeftCooldown" if button.name == "Btn_SecondarySkillLeft" else "Text_SecondarySkillRightCooldown")) as Label
	if label != null:
		_configure_action_badge(button, label, primary)


func _add_dash_cooldown_mask(button: Control) -> Control:
	var mask := CooldownRadialMask.new() as Control
	mask.name = "RuntimeCooldownRadialMask"
	mask.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var mask_size := Vector2(64, 64)
	mask.size = mask_size
	mask.position = (button.size - mask_size) * 0.5
	button.add_child(mask)
	return mask


func _configure_action_badge(button: Control, label: Label, primary: bool) -> void:
	var badge := PanelContainer.new()
	badge.name = "RuntimeCooldownBadge"
	badge.mouse_filter = Control.MOUSE_FILTER_IGNORE
	badge.visible = false
	var badge_size := Vector2(44, 28) if primary else Vector2(28, 22)
	badge.size = badge_size
	badge.position = (button.size - badge_size) * 0.5 if primary else Vector2((button.size.x - badge_size.x) * 0.5, button.size.y - 12)
	badge.add_theme_stylebox_override("panel", _style(Color(0.015, 0.018, 0.015, 0.96), Color(0.78, 0.65, 0.42, 0.92), 12, 2))
	button.add_child(badge)

	label.get_parent().remove_child(label)
	label.text = ""
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.set_anchors_preset(Control.PRESET_FULL_RECT)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 15 if primary else 12)
	label.add_theme_color_override("font_color", Color(0.96, 0.9, 0.76))
	badge.add_child(label)


func _set_action_badge_text(label: Label, text: String) -> void:
	if label == null:
		return
	label.text = text
	var badge := label.get_parent() as PanelContainer
	if badge != null and badge.name == "RuntimeCooldownBadge":
		badge.visible = text != ""


func _set_action_button_style(button: Control, bg: Color, border: Color, radius := 44, border_width := 2) -> void:
	if button == null:
		return
	var frame := button.get_node_or_null("RuntimeFrame") as PanelContainer
	if frame != null:
		var outer_style := _style(bg, border, radius, border_width)
		outer_style.shadow_color = Color(0.0, 0.0, 0.0, 0.42)
		outer_style.shadow_size = 7 if border_width >= 3 else 5
		outer_style.shadow_offset = Vector2(0, 3)
		frame.add_theme_stylebox_override("panel", outer_style)
	var rim := button.get_node_or_null("RuntimeRimHighlight") as PanelContainer
	if rim != null:
		var rim_style := _style(Color(1.0, 0.92, 0.58, 0.045), Color(border.r, border.g, border.b, min(1.0, border.a * 0.78)), max(4, radius - 3), 1)
		rim_style.content_margin_left = 0
		rim_style.content_margin_right = 0
		rim_style.content_margin_top = 0
		rim_style.content_margin_bottom = 0
		rim.add_theme_stylebox_override("panel", rim_style)
	var inner_frame := button.get_node_or_null("RuntimeInnerFrame") as PanelContainer
	if inner_frame != null:
		var inner_bg := Color(min(1.0, bg.r + 0.035), min(1.0, bg.g + 0.04), min(1.0, bg.b + 0.035), max(0.0, bg.a - 0.05))
		var inner_border := Color(0.06, 0.09, 0.075, 0.82)
		var inner_style := _style(inner_bg, inner_border, max(4, radius - 9), 1)
		inner_style.content_margin_left = 0
		inner_style.content_margin_right = 0
		inner_style.content_margin_top = 0
		inner_style.content_margin_bottom = 0
		inner_frame.add_theme_stylebox_override("panel", inner_style)
	var panel := button as PanelContainer
	if frame == null and panel != null:
		panel.add_theme_stylebox_override("panel", _style(bg, border, radius, border_width))


func _add_joystick_marker(parent: Control, position: Vector2, size: Vector2) -> void:
	var marker := ColorRect.new()
	marker.color = Color(0.82, 0.78, 0.62, 0.42)
	marker.position = position
	marker.size = size
	marker.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(marker)


func _build_battle_feedback_layer() -> void:
	if feedback_layer == null:
		return
	hero_aura_outer = _feedback_circle(Vector2(270, 270), Color(1.0, 0.76, 0.26, 0.09), Color(1.0, 0.86, 0.42, 0.3), 180, 2)
	feedback_layer.add_child(hero_aura_outer)

	hero_aura_inner = _feedback_circle(Vector2(126, 126), Color(1.0, 0.94, 0.68, 0.08), Color(1.0, 0.92, 0.62, 0.24), 90, 1)
	feedback_layer.add_child(hero_aura_inner)

	hero_aura_ticks.clear()
	for _index in range(8):
		var tick := ColorRect.new()
		tick.color = Color(1.0, 0.86, 0.42, 0.24)
		tick.size = Vector2(3, 18)
		feedback_layer.add_child(tick)
		hero_aura_ticks.append(tick)

	_build_ambient_pickup_views()
	_build_threat_line_views()


func _build_ambient_pickup_views() -> void:
	ambient_pickup_views.clear()
	_sync_pickup_view_count(_default_ambient_pickup_defs().size())


func _build_skill_slash_views() -> void:
	skill_slash_views.clear()
	var slash_keys: Array[String] = ["skill", "skill_shuriken", "skill", "skill_smoke", "skill", "skill_shuriken"]
	for index in range(6):
		var slash := TextureRect.new()
		slash.texture = textures.get(slash_keys[index])
		slash.size = Vector2(102, 64) if index % 2 == 0 else Vector2(84, 54)
		slash.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		slash.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		slash.modulate = Color(1.0, 0.86, 0.34, 0.52) if index % 3 != 1 else Color(0.3, 1.0, 0.92, 0.42)
		slash.mouse_filter = Control.MOUSE_FILTER_IGNORE
		feedback_layer.add_child(slash)
		skill_slash_views.append(slash)


func _build_threat_line_views() -> void:
	threat_line_views.clear()
	for _index in range(5):
		var line := ColorRect.new()
		line.color = Color(1.0, 0.18, 0.12, 0.26)
		line.size = Vector2(3, 100)
		line.mouse_filter = Control.MOUSE_FILTER_IGNORE
		feedback_layer.add_child(line)
		threat_line_views.append(line)


func _sync_pickup_view_count(count: int) -> void:
	while ambient_pickup_views.size() < count:
		var root := Control.new()
		root.size = Vector2(54, 54)
		root.mouse_filter = Control.MOUSE_FILTER_IGNORE
		root.set_meta("phase", float(ambient_pickup_views.size()) * 0.63)

		var glow := _feedback_circle(Vector2(48, 48), Color(1.0, 0.8, 0.35, 0.18), Color(1.0, 0.9, 0.65, 0.22), 32, 1)
		glow.position = Vector2(3, 3)
		root.add_child(glow)

		var icon := TextureRect.new()
		icon.name = "Icon"
		icon.texture = textures.get("res_gold")
		icon.position = Vector2(12, 11)
		icon.size = Vector2(30, 30)
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		root.add_child(icon)

		var exp_diamond := ColorRect.new()
		exp_diamond.name = "ExpDiamond"
		exp_diamond.color = Color(0.28, 0.72, 1.0, 0.96)
		exp_diamond.size = Vector2(20, 20)
		exp_diamond.position = Vector2(17, 15)
		exp_diamond.pivot_offset = exp_diamond.size * 0.5
		exp_diamond.rotation = PI * 0.25
		exp_diamond.mouse_filter = Control.MOUSE_FILTER_IGNORE
		exp_diamond.visible = false
		root.add_child(exp_diamond)

		var exp_core := ColorRect.new()
		exp_core.name = "ExpCore"
		exp_core.color = Color(0.88, 0.98, 1.0, 0.96)
		exp_core.size = Vector2(7, 7)
		exp_core.position = Vector2(23.5, 21.5)
		exp_core.pivot_offset = exp_core.size * 0.5
		exp_core.rotation = PI * 0.25
		exp_core.mouse_filter = Control.MOUSE_FILTER_IGNORE
		exp_core.visible = false
		root.add_child(exp_core)

		var exp_spark := ColorRect.new()
		exp_spark.name = "ExpSpark"
		exp_spark.color = Color(0.72, 0.96, 1.0, 0.86)
		exp_spark.size = Vector2(5, 5)
		exp_spark.position = Vector2(14, 10)
		exp_spark.pivot_offset = exp_spark.size * 0.5
		exp_spark.rotation = PI * 0.25
		exp_spark.mouse_filter = Control.MOUSE_FILTER_IGNORE
		exp_spark.visible = false
		root.add_child(exp_spark)

		var progress_track := ColorRect.new()
		progress_track.name = "MineProgressTrack"
		progress_track.color = Color(0.05, 0.07, 0.05, 0.62)
		progress_track.position = Vector2(8, 46)
		progress_track.size = Vector2(38, 4)
		progress_track.mouse_filter = Control.MOUSE_FILTER_IGNORE
		progress_track.visible = false
		root.add_child(progress_track)

		var progress_fill := ColorRect.new()
		progress_fill.name = "MineProgressFill"
		progress_fill.color = Color(1.0, 0.78, 0.26, 0.92)
		progress_fill.position = Vector2(8, 46)
		progress_fill.size = Vector2(0, 4)
		progress_fill.mouse_filter = Control.MOUSE_FILTER_IGNORE
		progress_fill.visible = false
		root.add_child(progress_fill)

		feedback_layer.add_child(root)
		ambient_pickup_views.append(root)

	while ambient_pickup_views.size() > count:
		var root := ambient_pickup_views.pop_back() as Control
		root.queue_free()


func _default_ambient_pickup_defs() -> Array:
	return [
		{"key": "res_gold", "position": Vector2(1328, 904), "color": Color(1.0, 0.72, 0.18, 0.2)},
		{"key": "res_soul", "position": Vector2(1580, 866), "color": Color(0.22, 0.98, 0.92, 0.2)},
		{"key": "res_wood", "position": Vector2(1712, 1088), "color": Color(0.74, 0.44, 0.18, 0.18)},
		{"key": "res_stone", "position": Vector2(1264, 1134), "color": Color(0.84, 0.84, 0.76, 0.17)},
		{"key": "res_gold", "position": Vector2(1452, 1244), "color": Color(1.0, 0.72, 0.18, 0.18)},
		{"key": "res_soul", "position": Vector2(1840, 960), "color": Color(0.22, 0.98, 0.92, 0.18)},
		{"key": "res_wood", "position": Vector2(1120, 1010), "color": Color(0.74, 0.44, 0.18, 0.16)},
		{"key": "res_gold", "position": Vector2(1660, 1290), "color": Color(1.0, 0.72, 0.18, 0.18)},
	]


func _build_level_choice_panel() -> void:
	level_choice_overlay = Control.new()
	level_choice_overlay.visible = false
	level_choice_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	level_choice_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	level_choice_overlay.z_index = 90
	battle_screen.add_child(level_choice_overlay)

	var scrim := ColorRect.new()
	scrim.color = Color(0.02, 0.04, 0.026, 0.58)
	scrim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	scrim.set_anchors_preset(Control.PRESET_FULL_RECT)
	level_choice_overlay.add_child(scrim)

	var safe_margin := MarginContainer.new()
	safe_margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	safe_margin.add_theme_constant_override("margin_left", 12)
	safe_margin.add_theme_constant_override("margin_top", 26)
	safe_margin.add_theme_constant_override("margin_right", 12)
	safe_margin.add_theme_constant_override("margin_bottom", 86)
	level_choice_overlay.add_child(safe_margin)

	var center := CenterContainer.new()
	center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	center.size_flags_vertical = Control.SIZE_EXPAND_FILL
	safe_margin.add_child(center)

	level_choice_panel = PanelContainer.new()
	var panel_style := _style(Color(0.92, 0.8, 0.5, 0.98), Color(0.16, 0.11, 0.06, 0.96), 12, 2)
	panel_style.content_margin_left = 14
	panel_style.content_margin_right = 14
	panel_style.content_margin_top = 30
	panel_style.content_margin_bottom = 16
	level_choice_panel.add_theme_stylebox_override("panel", panel_style)
	center.add_child(level_choice_panel)

	var root := VBoxContainer.new()
	root.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root.add_theme_constant_override("separation", 9)
	level_choice_panel.add_child(root)

	var header := HBoxContainer.new()
	header.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_theme_constant_override("separation", 10)
	root.add_child(header)

	var title_stack := VBoxContainer.new()
	title_stack.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_stack.add_theme_constant_override("separation", 3)
	header.add_child(title_stack)

	level_choice_title_label = Label.new()
	level_choice_title_label.text = "레벨 업!"
	level_choice_title_label.add_theme_font_size_override("font_size", 31)
	level_choice_title_label.add_theme_color_override("font_color", Color(0.12, 0.08, 0.03))
	title_stack.add_child(level_choice_title_label)

	level_choice_subtitle_label = Label.new()
	level_choice_subtitle_label.text = "이번 원정에서 성장할 스킬을 선택하세요"
	level_choice_subtitle_label.add_theme_font_size_override("font_size", 12)
	level_choice_subtitle_label.add_theme_color_override("font_color", Color(0.28, 0.19, 0.08))
	title_stack.add_child(level_choice_subtitle_label)

	level_choice_summary_label = Label.new()
	level_choice_summary_label.custom_minimum_size = Vector2(108, 42)
	level_choice_summary_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	level_choice_summary_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	level_choice_summary_label.add_theme_font_size_override("font_size", 12)
	level_choice_summary_label.add_theme_color_override("font_color", Color(1.0, 0.9, 0.68))
	level_choice_summary_label.add_theme_stylebox_override("normal", _style(Color(0.16, 0.11, 0.06, 0.92), Color(0.5, 0.34, 0.14, 0.9), 9, 1))
	header.add_child(level_choice_summary_label)

	level_choice_grid = HBoxContainer.new()
	level_choice_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	level_choice_grid.add_theme_constant_override("separation", 7)
	root.add_child(level_choice_grid)
	_sync_level_choice_panel_layout()


func _level_choice_visible() -> bool:
	return level_choice_overlay != null and level_choice_overlay.visible


func _set_level_choice_visible(visible: bool) -> void:
	if level_choice_overlay == null:
		return
	if visible:
		_sync_level_choice_panel_layout()
	level_choice_overlay.visible = visible
	if level_choice_panel != null:
		level_choice_panel.visible = visible
	if not visible:
		level_choice_render_key = ""


func _sync_level_choice_panel_layout() -> void:
	if level_choice_panel == null:
		return
	var viewport_size := get_viewport_rect().size
	var panel_width: float = min(760.0, max(320.0, viewport_size.x - 24.0))
	var panel_height: float = min(viewport_size.y * 0.78, 432.0)
	level_choice_panel.custom_minimum_size = Vector2(panel_width, panel_height)


func _sync_level_choice_panel(level_choice: Dictionary) -> void:
	var pending := bool(level_choice.get("pending", false))
	if not pending or _result_visible():
		_set_level_choice_visible(false)
		return

	var choices: Array = level_choice.get("choices", [])
	if choices.size() < 3:
		_set_level_choice_visible(false)
		return

	var render_key := _level_choice_key(level_choice)
	if render_key != level_choice_render_key:
		level_choice_render_key = render_key
		_populate_level_choice_panel(level_choice)
	_set_level_choice_visible(true)


func _level_choice_key(level_choice: Dictionary) -> String:
	var parts: Array[String] = [str(level_choice.get("level", 0)), str(level_choice.get("kills", 0))]
	for choice in level_choice.get("choices", []):
		if typeof(choice) != TYPE_DICTIONARY:
			continue
		parts.append("%d:%d" % [int(choice.get("skill_id", 0)), int(choice.get("next_level", 0))])
	return "|".join(parts)


func _populate_level_choice_panel(level_choice: Dictionary) -> void:
	if level_choice_grid == null:
		return
	level_choice_title_label.text = "레벨 업!"
	level_choice_subtitle_label.text = "이번 원정에서 성장할 스킬을 선택하세요"
	var elapsed := int(float(level_choice.get("elapsed", 0.0)))
	level_choice_summary_label.text = "Lv.%d\n%d 처치 · %02d:%02d" % [
		int(level_choice.get("level", 2)),
		int(level_choice.get("kills", 0)),
		int(elapsed / 60.0),
		elapsed % 60,
	]

	for child in level_choice_grid.get_children():
		child.queue_free()

	var choices: Array = level_choice.get("choices", [])
	for index in range(min(3, choices.size())):
		var choice: Dictionary = choices[index]
		level_choice_grid.add_child(_level_choice_card(choice, index))


func _level_choice_card(choice: Dictionary, index: int) -> Button:
	var card := Button.new()
	card.text = ""
	card.focus_mode = Control.FOCUS_ALL
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card.custom_minimum_size = Vector2(0, 246)
	card.add_theme_stylebox_override("normal", _style(Color(0.98, 0.86, 0.56, 0.96), Color(0.32, 0.2, 0.08, 0.94), 8, 3))
	card.add_theme_stylebox_override("hover", _style(Color(1.0, 0.9, 0.62, 0.98), Color(1.0, 0.74, 0.2, 0.98), 8, 3))
	card.add_theme_stylebox_override("pressed", _style(Color(0.88, 0.66, 0.3, 0.98), Color(0.18, 0.1, 0.04, 0.98), 8, 3))
	card.add_theme_stylebox_override("focus", _style(Color(1.0, 0.88, 0.58, 0.98), Color(0.24, 0.98, 0.86, 0.98), 8, 3))
	card.pressed.connect(func(): _choose_level_choice(index))

	var box := VBoxContainer.new()
	box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.set_anchors_preset(Control.PRESET_FULL_RECT)
	box.offset_left = 7
	box.offset_top = 8
	box.offset_right = -7
	box.offset_bottom = -8
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.add_theme_constant_override("separation", 7)
	card.add_child(box)

	var badge := Label.new()
	badge.text = str(choice.get("badge_label", "NEW"))
	badge.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	badge.add_theme_font_size_override("font_size", 10)
	badge.add_theme_color_override("font_color", Color(0.1, 0.07, 0.03))
	badge.add_theme_stylebox_override("normal", _style(Color(1.0, 0.76, 0.2, 0.96), Color(0.24, 0.14, 0.04, 0.96), 6, 2))
	box.add_child(badge)

	var icon_frame := _feedback_circle(Vector2(54, 54), Color(0.12, 0.09, 0.06, 0.94), Color(1.0, 0.76, 0.25, 0.94), 32, 3)
	icon_frame.custom_minimum_size = Vector2(54, 54)
	icon_frame.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	box.add_child(icon_frame)
	var icon := TextureRect.new()
	icon.texture = textures.get(str(choice.get("icon_key", "skill")))
	icon.position = Vector2(7, 7)
	icon.size = Vector2(40, 40)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon_frame.add_child(icon)

	var name_label := Label.new()
	name_label.text = str(choice.get("name", "스킬"))
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	name_label.add_theme_font_size_override("font_size", 13)
	name_label.add_theme_color_override("font_color", Color(0.12, 0.08, 0.03))
	box.add_child(name_label)

	box.add_child(_level_pip_row(int(choice.get("next_level", 1))))

	var desc := Label.new()
	desc.text = str(choice.get("effect_summary", "전투 보조"))
	desc.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	desc.custom_minimum_size = Vector2(0, 36)
	desc.add_theme_font_size_override("font_size", 11)
	desc.add_theme_color_override("font_color", Color(0.24, 0.15, 0.06))
	box.add_child(desc)

	var chips := HBoxContainer.new()
	chips.alignment = BoxContainer.ALIGNMENT_CENTER
	chips.add_theme_constant_override("separation", 4)
	box.add_child(chips)
	for chip_text in choice.get("stat_chips", []):
		chips.add_child(_level_choice_chip(str(chip_text)))

	var category := Label.new()
	category.text = str(choice.get("category_label", "스킬"))
	category.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	category.add_theme_font_size_override("font_size", 11)
	category.add_theme_color_override("font_color", Color(0.96, 0.9, 0.76))
	category.add_theme_stylebox_override("normal", _style(Color(0.07, 0.13, 0.09, 0.96), Color(0.28, 0.2, 0.1, 0.9), 6, 1))
	box.add_child(category)
	return card


func _level_pip_row(filled: int) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 5)
	for index in range(5):
		var pip := ColorRect.new()
		pip.custom_minimum_size = Vector2(9, 9)
		pip.color = Color(1.0, 0.75, 0.2, 0.95) if index < filled else Color(0.26, 0.18, 0.1, 0.48)
		pip.rotation = PI * 0.25
		row.add_child(pip)
	return row


func _level_choice_chip(text: String) -> Label:
	var chip := Label.new()
	chip.text = text
	chip.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	chip.add_theme_font_size_override("font_size", 10)
	chip.add_theme_color_override("font_color", Color(0.18, 0.11, 0.04))
	chip.add_theme_stylebox_override("normal", _style(Color(0.68, 0.48, 0.22, 0.26), Color(0.36, 0.23, 0.09, 0.74), 6, 1))
	return chip


func _choose_level_choice(index: int) -> void:
	if sim == null:
		return
	if sim.apply_level_choice(index):
		_play_sfx("uiClick", {"volume": 0.72})
		_set_level_choice_visible(false)
		_sync_battle()


func _handle_level_choice_key(event: InputEvent) -> void:
	if not (event is InputEventKey):
		return
	var key_event := event as InputEventKey
	if not key_event.pressed or key_event.echo:
		return
	match key_event.keycode:
		KEY_1, KEY_KP_1:
			_choose_level_choice(0)
		KEY_2, KEY_KP_2:
			_choose_level_choice(1)
		KEY_3, KEY_KP_3:
			_choose_level_choice(2)
		_:
			return
	get_viewport().set_input_as_handled()


func _build_result_panel() -> void:
	result_overlay = Control.new()
	result_overlay.visible = false
	result_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	result_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	result_overlay.z_index = 100
	battle_screen.add_child(result_overlay)

	var result_backdrop := textures.get("result_backdrop") as Texture2D
	if result_backdrop != null:
		var backdrop := TextureRect.new()
		backdrop.texture = result_backdrop
		backdrop.set_anchors_preset(Control.PRESET_FULL_RECT)
		backdrop.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		backdrop.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		backdrop.mouse_filter = Control.MOUSE_FILTER_IGNORE
		result_overlay.add_child(backdrop)

	var scrim := ColorRect.new()
	scrim.color = Color(0.02, 0.04, 0.026, 0.58)
	scrim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	scrim.set_anchors_preset(Control.PRESET_FULL_RECT)
	result_overlay.add_child(scrim)

	var safe_margin := MarginContainer.new()
	safe_margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	safe_margin.add_theme_constant_override("margin_left", 18)
	safe_margin.add_theme_constant_override("margin_top", 22)
	safe_margin.add_theme_constant_override("margin_right", 18)
	safe_margin.add_theme_constant_override("margin_bottom", 22)
	result_overlay.add_child(safe_margin)

	var center := CenterContainer.new()
	center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	center.size_flags_vertical = Control.SIZE_EXPAND_FILL
	safe_margin.add_child(center)

	result_panel = PanelContainer.new()
	result_panel.custom_minimum_size = Vector2(392, 584)
	var shell_style := _style(Color(0.92, 0.8, 0.5, 0.98), Color(0.16, 0.11, 0.06, 0.96), 12, 2)
	shell_style.content_margin_left = 16
	shell_style.content_margin_right = 16
	shell_style.content_margin_top = 16
	shell_style.content_margin_bottom = 16
	result_panel.add_theme_stylebox_override("panel", shell_style)
	center.add_child(result_panel)

	var result_box := VBoxContainer.new()
	result_box.alignment = BoxContainer.ALIGNMENT_CENTER
	result_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	result_box.add_theme_constant_override("separation", 8)
	result_panel.add_child(result_box)

	result_status_header = Control.new()
	result_status_header.custom_minimum_size = Vector2(348, 218)
	result_status_header.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	result_status_header.clip_contents = false
	result_box.add_child(result_status_header)

	result_status_art = TextureRect.new()
	result_status_art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	result_status_art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	result_status_art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	result_status_header.add_child(result_status_art)

	result_status_crest = TextureRect.new()
	result_status_crest.texture = textures.get("result_clear_crest")
	result_status_crest.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	result_status_crest.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	result_status_crest.mouse_filter = Control.MOUSE_FILTER_IGNORE
	result_status_header.add_child(result_status_crest)

	result_kicker_label = Label.new()
	result_kicker_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	result_kicker_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	result_kicker_label.clip_text = true
	result_kicker_label.add_theme_font_size_override("font_size", 12)
	result_kicker_label.add_theme_color_override("font_color", Color(0.98, 0.86, 0.55))
	result_status_header.add_child(result_kicker_label)

	result_title_label = Label.new()
	result_title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	result_title_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	result_title_label.clip_text = true
	result_title_label.add_theme_font_size_override("font_size", 46)
	result_title_label.add_theme_color_override("font_color", Color(1.0, 0.78, 0.28))
	result_status_header.add_child(result_title_label)

	result_stage_badge_label = Label.new()
	result_stage_badge_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	result_stage_badge_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	result_stage_badge_label.clip_text = true
	result_stage_badge_label.add_theme_font_size_override("font_size", 12)
	result_stage_badge_label.add_theme_color_override("font_color", Color(0.16, 0.09, 0.02))
	result_status_header.add_child(result_stage_badge_label)

	result_summary_label = Label.new()
	result_summary_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	result_summary_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	result_summary_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	result_summary_label.add_theme_font_size_override("font_size", 12)
	result_summary_label.add_theme_color_override("font_color", Color(1.0, 0.91, 0.66))
	result_summary_label.visible = false
	result_status_header.add_child(result_summary_label)

	result_stats_box = HBoxContainer.new()
	result_stats_box.alignment = BoxContainer.ALIGNMENT_CENTER
	result_stats_box.add_theme_constant_override("separation", 6)
	result_status_header.add_child(result_stats_box)

	var reward_title_frame := Control.new()
	reward_title_frame.custom_minimum_size = Vector2(330, 48)
	reward_title_frame.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	result_box.add_child(reward_title_frame)

	result_reward_title_brush = TextureRect.new()
	result_reward_title_brush.texture = textures.get("result_reward_brush")
	result_reward_title_brush.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	result_reward_title_brush.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	result_reward_title_brush.mouse_filter = Control.MOUSE_FILTER_IGNORE
	result_reward_title_brush.position = Vector2(25, -8)
	result_reward_title_brush.size = Vector2(280, 64)
	reward_title_frame.add_child(result_reward_title_brush)

	var reward_title := Label.new()
	reward_title.text = "획득 보상"
	reward_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	reward_title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	reward_title.add_theme_font_size_override("font_size", 18)
	reward_title.add_theme_color_override("font_color", Color(1.0, 0.93, 0.72))
	reward_title.position = Vector2(0, 9)
	reward_title.size = Vector2(330, 30)
	reward_title_frame.add_child(reward_title)

	result_rewards_scroll = ScrollContainer.new()
	result_rewards_scroll.custom_minimum_size = Vector2(330, 126)
	result_rewards_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	result_rewards_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	result_box.add_child(result_rewards_scroll)

	result_rewards_box = VBoxContainer.new()
	result_rewards_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	result_rewards_box.add_theme_constant_override("separation", 4)
	result_rewards_scroll.add_child(result_rewards_box)

	var result_button_frame := Control.new()
	result_button_frame.custom_minimum_size = Vector2(286, 56)
	result_button_frame.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	result_box.add_child(result_button_frame)

	result_return_button_skin = TextureRect.new()
	result_return_button_skin.texture = textures.get("result_return_button")
	result_return_button_skin.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	result_return_button_skin.stretch_mode = TextureRect.STRETCH_SCALE
	result_return_button_skin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	result_return_button_skin.size = Vector2(286, 56)
	result_button_frame.add_child(result_return_button_skin)

	var result_button := Button.new()
	result_button.text = "성소로 귀환"
	result_button.custom_minimum_size = Vector2(286, 56)
	result_button.position = Vector2.ZERO
	result_button.size = Vector2(286, 56)
	result_button.flat = true
	result_button.add_theme_font_size_override("font_size", 18)
	result_button.add_theme_stylebox_override("normal", StyleBoxEmpty.new())
	result_button.add_theme_stylebox_override("hover", StyleBoxEmpty.new())
	result_button.add_theme_stylebox_override("pressed", StyleBoxEmpty.new())
	result_button.add_theme_color_override("font_color", Color(1.0, 0.92, 0.68))
	result_button.add_theme_color_override("font_pressed_color", Color(1.0, 0.86, 0.48))
	result_button.pressed.connect(func():
		_play_sfx("uiClick", {"volume": 0.72})
		_return_home()
	)
	result_button_frame.add_child(result_button)
	_sync_result_panel_layout()


func _result_visible() -> bool:
	return result_overlay != null and result_overlay.visible


func _set_result_visible(visible: bool) -> void:
	if result_overlay == null:
		return
	if visible:
		_sync_result_panel_layout()
	result_overlay.visible = visible
	if result_panel != null:
		result_panel.visible = visible


func _sync_result_panel_layout() -> void:
	if result_panel == null:
		return
	var viewport_size := get_viewport_rect().size
	var panel_width: float = min(392.0, max(320.0, viewport_size.x - 36.0))
	var panel_height: float = min(584.0, max(480.0, viewport_size.y - 44.0))
	var content_width: float = max(270.0, panel_width - 44.0)
	result_panel.custom_minimum_size = Vector2(panel_width, panel_height)
	var header_height: float = 230.0 if viewport_size.y >= 720.0 else 198.0
	if result_status_header != null:
		result_status_header.custom_minimum_size = Vector2(content_width, header_height)
	if result_status_art != null:
		var art_width: float = min(panel_width, content_width + 44.0)
		var art_height: float = 151.0 if viewport_size.y >= 720.0 else 128.0
		result_status_art.position = Vector2((content_width - art_width) * 0.5, -8.0)
		result_status_art.size = Vector2(art_width, art_height)
	if result_status_crest != null:
		var crest_width := 120.0 if viewport_size.y >= 720.0 else 102.0
		var crest_height := 120.0 if viewport_size.y >= 720.0 else 102.0
		result_status_crest.position = Vector2((content_width - crest_width) * 0.5, -66.0)
		result_status_crest.size = Vector2(crest_width, crest_height)
	if result_kicker_label != null:
		result_kicker_label.position = Vector2(14, 66)
		result_kicker_label.size = Vector2(content_width - 28, 20)
	if result_title_label != null:
		result_title_label.position = Vector2(8, 84)
		result_title_label.size = Vector2(content_width - 16, 52)
	if result_stage_badge_label != null:
		result_stage_badge_label.position = Vector2((content_width - 132.0) * 0.5, 142)
		result_stage_badge_label.size = Vector2(132, 24)
	if result_summary_label != null:
		result_summary_label.position = Vector2(20, 164)
		result_summary_label.size = Vector2(content_width - 40, 18)
	if result_stats_box != null:
		result_stats_box.position = Vector2(max(0.0, (content_width - 296.0) * 0.5), 182.0 if viewport_size.y >= 720.0 else 158.0)
		result_stats_box.size = Vector2(min(296.0, content_width), 45.0)
	if result_rewards_scroll != null:
		var reward_height: float = clamp(viewport_size.y - 520.0, 98.0, 150.0)
		result_rewards_scroll.custom_minimum_size = Vector2(content_width, reward_height)


func _populate_home() -> void:
	if home_screen != null:
		home_screen.sync_state()
	if home_summary != null:
		home_summary.text = store.build_summary()
	_sync_home_resources()


func _reload_data() -> void:
	var ok: bool = store.load_all()
	var housing_ok: bool = housing_store.load_all()
	textures.clear()
	_load_textures()
	sanctuary_state.seed_from_housing(housing_store)
	sanctuary_state.apply_run_resources(run_state.resources)
	_populate_home()
	home_screen.set_status_message("데이터 새로고침 완료" if ok and housing_ok else "데이터 새로고침 경고")
	_sync_title_status()
	_sync_audio_settings()


func _start_battle(map_id := 0) -> void:
	_play_sfx("uiClick", {"volume": 0.72})
	_set_audio_mode("expedition")
	var selected_id := int(map_id)
	if selected_id <= 0 and home_screen != null:
		selected_id = home_screen.selected_main_map_id()
	if selected_id <= 0:
		selected_id = 500101
	_reset_joystick()
	battle_input_vector = Vector2.ZERO
	last_battle_input_vector = Vector2.DOWN
	player_render_motion = Vector2.ZERO
	player_render_facing = Vector2.DOWN
	player_walk_phase = 0.0
	battle_camera_ready = false
	_clear_skill_fx_state()
	sim.start(selected_id)
	_reset_battle_audio_snapshot(sim.snapshot())
	if battle_tile_world != null:
		battle_tile_world.reset_for_map(selected_id)
	_set_level_choice_visible(false)
	_set_result_visible(false)
	_clear_entity_views()
	title_screen.visible = false
	home_screen.visible = false
	battle_screen.visible = true
	_sync_battle()


func _return_home() -> void:
	_set_audio_mode("home")
	title_screen.visible = false
	battle_screen.visible = false
	home_screen.visible = true
	_set_level_choice_visible(false)
	_set_result_visible(false)
	_reset_joystick()
	_clear_entity_views()
	_clear_skill_fx_state()
	sanctuary_state.apply_run_resources(run_state.resources)
	_sync_home_resources()
	_sync_title_status()


func _open_home() -> void:
	_set_audio_mode("home")
	title_screen.visible = false
	battle_screen.visible = false
	home_screen.visible = true
	_sync_home_resources()


func _return_title() -> void:
	_set_audio_mode("boot")
	battle_screen.visible = false
	home_screen.visible = false
	title_screen.visible = true
	_set_level_choice_visible(false)
	_set_result_visible(false)
	_reset_joystick()
	_clear_entity_views()
	_clear_skill_fx_state()
	_sync_title_status()


func _quick_start_battle() -> void:
	_open_home()
	_start_battle()


func _reset_progress_from_title() -> void:
	run_state.reset()
	run_state.save()
	sanctuary_state.seed_from_housing(housing_store)
	sanctuary_state.apply_run_resources(run_state.resources)
	_populate_home()
	_sync_title_status()


func _sync_title_status() -> void:
	if title_status_label == null or title_start_button == null:
		return
	title_status_label.text = run_state.title_status_text()
	title_start_button.text = "이어하기" if run_state.has_progress() else "시작하기"


func _sync_home_resources() -> void:
	if home_screen != null:
		home_screen.sync_state()
	for key in home_resource_labels.keys():
		home_resource_labels[key].text = str(run_state.resources.get(key, 0))


func _sync_battle() -> void:
	var snapshot: Dictionary = sim.snapshot()
	map_label.text = str(snapshot.get("map_name", "대나무 영지"))
	var left: float = max(0.0, float(snapshot.get("run_duration", 90.0)) - float(snapshot.get("elapsed", 0.0)))
	var left_seconds := int(left)
	timer_label.text = "%02d:%02d" % [int(left_seconds / 60.0), left_seconds % 60]
	wave_label.text = "STAGE %d/%d" % [int(snapshot.get("wave", 1)), int(snapshot.get("wave_count", 1))]
	kill_label.text = str(int(snapshot.get("kill_count", 0)))
	enemy_label.text = str(int(snapshot.get("enemy_count", 0)))
	pickup_label.text = str(int(snapshot.get("pickup_count", 0)))
	pending_label.text = str(int(snapshot.get("pending_count", 0)))
	objective_label.text = str(snapshot.get("objective", "대나무 숲 정화"))

	var player = snapshot.get("player", {})
	var hp: float = float(player.get("hp", 0.0))
	var max_hp: float = max(1.0, float(player.get("max_hp", 1.0)))
	hp_bar.value = clamp(hp / max_hp, 0.0, 1.0)
	profile_level_label.text = "%d" % int(snapshot.get("player_level", 1))
	profile_hp_label.text = "%d / %d" % [int(round(hp)), int(round(max_hp))]
	var exp_ratio: float = clamp(float(snapshot.get("exp_ratio", 0.0)), 0.0, 1.0)
	exp_bar.value = exp_ratio
	if exp_level_label != null:
		exp_level_label.text = "Lv.%d" % int(snapshot.get("player_level", 1))
	if exp_value_label != null:
		var exp_current: int = int(snapshot.get("exp", 0))
		var exp_max: int = max(1, int(snapshot.get("exp_to_next", 1)))
		exp_value_label.text = "%d / %d" % [exp_current, exp_max]
	_sync_dash_control(snapshot.get("dash", {}))
	_sync_battle_camera(player)

	for key in battle_resource_labels.keys():
		battle_resource_labels[key].text = str(int(round(float(snapshot.get("resources", {}).get(key, 0)))))
	for key in battle_gain_labels.keys():
		var gained := int(snapshot.get("resource_gains", {}).get(key, 0))
		battle_gain_labels[key].text = "+%d" % gained if gained > 0 else ""

	_sync_wave_segments(float(snapshot.get("stage_progress", 0.0)))
	_sync_ground_area_views(snapshot.get("active_ground_areas", []), player)
	_sync_entity_views(snapshot.get("entities", []), player, snapshot)
	_sync_battle_feedback(snapshot, player)
	_sync_skill_fx_events(snapshot.get("fx_events", []), player)
	_sync_battle_audio(snapshot)
	_sync_event_views(snapshot.get("events", []), player)
	_sync_skill_bar(snapshot.get("skill_slots", []))
	_sync_level_choice_panel(snapshot.get("level_choice", {}))

	if not bool(snapshot.get("running", false)) and str(snapshot.get("result", "")) != "" and not _result_visible():
		_set_audio_mode("result")
		_set_level_choice_visible(false)
		_sync_result_panel(snapshot)
		_set_result_visible(true)


func _current_battle_input_vector() -> Vector2:
	var vector: Vector2 = _keyboard_move_vector() + joystick_vector
	vector = vector.limit_length(1.0)
	battle_input_vector = vector
	if vector.length_squared() > 0.0001:
		last_battle_input_vector = vector.normalized()
	return vector


func _keyboard_move_vector() -> Vector2:
	var vector := Vector2.ZERO
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		vector.x -= 1.0
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		vector.x += 1.0
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
		vector.y -= 1.0
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		vector.y += 1.0
	return vector.limit_length(1.0)


func _request_dash(source: String) -> void:
	var vector: Vector2 = _current_battle_input_vector()
	if vector.length_squared() <= 0.0001:
		vector = last_battle_input_vector
	var dashed: bool = sim.request_dash(vector, source)
	if dashed:
		_play_sfx("uiClick", {"volume": 0.58, "cooldownMs": 90})
	elif dash_cooldown_label != null:
		_play_sfx("uiError", {"volume": 0.72})
		_set_action_badge_text(dash_cooldown_label, "...")


func _control_contains_global(control: Control, position: Vector2) -> bool:
	return control != null and control.visible and control.get_global_rect().has_point(position)


func _update_joystick_from_global(position: Vector2) -> void:
	if joystick_panel == null:
		return
	var rect: Rect2 = joystick_panel.get_global_rect()
	var center: Vector2 = rect.position + rect.size * 0.5
	var delta: Vector2 = position - center
	var radius: float = max(1.0, min(rect.size.x, rect.size.y) * 0.5)
	joystick_vector = delta.limit_length(radius) / radius
	_sync_joystick_visual(joystick_vector)


func _reset_joystick() -> void:
	joystick_active = false
	joystick_pointer_id = -2
	joystick_vector = Vector2.ZERO
	_sync_joystick_visual(Vector2.ZERO)
	if sim != null:
		sim.set_player_input(Vector2.ZERO)


func _sync_joystick_visual(vector: Vector2) -> void:
	if joystick_core == null:
		return
	var display_vector: Vector2 = vector.limit_length(1.0)
	var offset: Vector2 = display_vector * JOYSTICK_CORE_TRAVEL
	joystick_core.offset_left = -JOYSTICK_CORE_HALF_SIZE + offset.x
	joystick_core.offset_top = -JOYSTICK_CORE_HALF_SIZE + offset.y
	joystick_core.offset_right = JOYSTICK_CORE_HALF_SIZE + offset.x
	joystick_core.offset_bottom = JOYSTICK_CORE_HALF_SIZE + offset.y


func _sync_dash_control(dash: Dictionary) -> void:
	if dash_cooldown_label == null and dash_cooldown_mask == null:
		return
	var active := bool(dash.get("active", false))
	var ready := bool(dash.get("ready", true))
	var cooldown := float(dash.get("cooldown", 0.0))
	var cooldown_progress: float = clamp(float(dash.get("cooldown_progress", 1.0)), 0.0, 1.0)
	if active:
		if dash_cooldown_label != null:
			_set_action_badge_text(dash_cooldown_label, "")
			dash_cooldown_label.add_theme_color_override("font_color", Color(0.58, 1.0, 0.9))
		_set_dash_cooldown_mask(cooldown_progress)
		_set_action_button_style(dash_button_panel, Color(0.05, 0.13, 0.11, 0.94), Color(0.56, 1.0, 0.86, 0.98), 48, 3)
	elif ready:
		if dash_cooldown_label != null:
			_set_action_badge_text(dash_cooldown_label, "")
			dash_cooldown_label.add_theme_color_override("font_color", Color(0.9, 1.0, 0.86))
		_set_dash_cooldown_mask(1.0)
		_set_action_button_style(dash_button_panel, Color(0.02, 0.035, 0.03, 0.94), Color(0.92, 0.76, 0.46, 0.96), 48, 3)
	else:
		if dash_cooldown_label != null:
			_set_action_badge_text(dash_cooldown_label, "%.1f" % cooldown)
			dash_cooldown_label.add_theme_color_override("font_color", Color(0.74, 0.86, 0.8))
		_set_dash_cooldown_mask(cooldown_progress)
		_set_action_button_style(dash_button_panel, Color(0.025, 0.035, 0.03, 0.82), Color(0.36, 0.34, 0.26, 0.88), 48, 3)


func _set_dash_cooldown_mask(cooldown_progress: float) -> void:
	if dash_cooldown_mask == null:
		return
	dash_cooldown_mask.call("set_cooldown_progress", cooldown_progress)


func _sync_battle_feedback(snapshot: Dictionary, player: Dictionary) -> void:
	if feedback_layer == null or player.is_empty():
		return
	var player_screen := _world_to_screen(player.get("position", Vector2(1500, 1000)), player)
	var dash: Dictionary = snapshot.get("dash", {})
	var invulnerable := bool(dash.get("invulnerable", false))
	var elapsed := float(snapshot.get("elapsed", 0.0))
	var pulse := (sin(elapsed * 4.8) + 1.0) * 0.5
	var camera_scale := BATTLE_CAMERA_VISUAL_SCALE
	var aura_size := (Vector2(286, 286) if invulnerable else Vector2(258 + pulse * 10, 258 + pulse * 10)) * camera_scale
	_set_centered(hero_aura_outer, player_screen, aura_size)
	_set_centered(hero_aura_inner, player_screen, Vector2(124 + pulse * 8, 124 + pulse * 8) * camera_scale)
	if hero_aura_outer != null:
		hero_aura_outer.modulate.a = 1.0 if not invulnerable else 1.0
	if hero_aura_inner != null:
		hero_aura_inner.modulate.a = 0.72 + pulse * 0.24

	var tick_radius := aura_size.x * 0.44
	for index in range(hero_aura_ticks.size()):
		var tick: ColorRect = hero_aura_ticks[index]
		var angle := elapsed * 0.8 + float(index) * TAU / float(max(1, hero_aura_ticks.size()))
		var tick_center := player_screen + Vector2(cos(angle), sin(angle)) * tick_radius
		tick.size = Vector2(3, 18) * camera_scale
		tick.position = tick_center - tick.size * 0.5
		tick.rotation = angle
		tick.modulate.a = 0.42 + pulse * 0.22

	var entities: Array = snapshot.get("entities", [])
	_hide_skill_slashes()
	var pickup_defs: Array = snapshot.get("fixture_pickups", []) if bool(snapshot.get("visual_fixture", false)) else []
	if not bool(snapshot.get("visual_fixture", false)):
		pickup_defs.append_array(snapshot.get("exp_pickups", []))
		pickup_defs.append_array(snapshot.get("encounter_pickups", []))
	_sync_ambient_pickups(pickup_defs, player, elapsed, bool(snapshot.get("visual_fixture", false)))
	_sync_boss_telegraphs(entities, player, elapsed)
	_sync_threat_lines(entities, player, elapsed)


func _sync_skill_slashes(player_screen: Vector2, elapsed: float) -> void:
	var camera_scale := BATTLE_CAMERA_VISUAL_SCALE
	for index in range(skill_slash_views.size()):
		var slash := skill_slash_views[index]
		var angle := elapsed * (1.7 + float(index % 3) * 0.2) + float(index) * TAU / float(max(1, skill_slash_views.size()))
		var offset := Vector2(cos(angle), sin(angle)) * (64.0 + float(index % 4) * 24.0) * camera_scale
		slash.pivot_offset = slash.size * 0.5
		slash.scale = Vector2.ONE * camera_scale
		slash.position = player_screen + offset - slash.size * 0.5
		slash.rotation = angle + 0.45
		slash.modulate.a = 0.18 + ((sin(elapsed * 5.0 + float(index)) + 1.0) * 0.5) * 0.34
		slash.visible = true


func _hide_skill_slashes() -> void:
	for slash in skill_slash_views:
		if slash != null:
			slash.visible = false


func _sync_skill_fx_events(events: Array, player: Dictionary) -> void:
	if feedback_layer == null or player.is_empty():
		return
	for event in events:
		if typeof(event) != TYPE_DICTIONARY:
			continue
		var event_id := int(event.get("id", 0))
		if event_id <= 0 or handled_skill_fx_events.has(event_id):
			continue
		handled_skill_fx_events[event_id] = true
		_play_skill_event_sfx(event)
		_spawn_skill_fx_event(event, player)

	if handled_skill_fx_events.size() > 240:
		var live_ids := {}
		for event in events:
			if typeof(event) == TYPE_DICTIONARY:
				live_ids[int(event.get("id", 0))] = true
		for event_id in handled_skill_fx_events.keys().duplicate():
			if not live_ids.has(event_id):
				handled_skill_fx_events.erase(event_id)


func _sync_audio_settings() -> void:
	if audio_bridge == null or sanctuary_state == null:
		return
	audio_bridge.apply_settings(sanctuary_state.settings)


func _set_audio_mode(mode: String) -> void:
	if audio_bridge == null:
		return
	audio_bridge.set_mode(mode)


func _play_sfx(name: String, options: Dictionary = {}) -> bool:
	if audio_bridge == null:
		return false
	return bool(audio_bridge.play_sfx(name, options))


func _reset_battle_audio_snapshot(snapshot: Dictionary = {}) -> void:
	last_audio_snapshot = {
		"kill_count": int(snapshot.get("kill_count", 0)),
		"pickup_count": int(snapshot.get("pickup_count", 0)),
		"player_level": int(snapshot.get("player_level", 1)),
		"result": str(snapshot.get("result", "")),
	}


func _sync_battle_audio(snapshot: Dictionary) -> void:
	if last_audio_snapshot.is_empty():
		_reset_battle_audio_snapshot(snapshot)
		return

	var kill_count := int(snapshot.get("kill_count", 0))
	var pickup_count := int(snapshot.get("pickup_count", 0))
	var player_level := int(snapshot.get("player_level", 1))
	var result := str(snapshot.get("result", ""))
	var previous_result := str(last_audio_snapshot.get("result", ""))

	if kill_count > int(last_audio_snapshot.get("kill_count", 0)):
		_play_sfx("monsterDead")
	if pickup_count > int(last_audio_snapshot.get("pickup_count", 0)):
		_play_sfx("coin")
	if player_level > int(last_audio_snapshot.get("player_level", 1)):
		_play_sfx("levelUp")
	if result != "" and result != previous_result:
		_play_sfx("reward" if result == "clear" else "uiError", {"volume": 0.72 if result != "clear" else 1.0})

	_reset_battle_audio_snapshot(snapshot)


func _play_skill_event_sfx(event: Dictionary) -> void:
	match str(event.get("kind", "")):
		"cast":
			_play_sfx("attack")
		"hit":
			_play_sfx("hit")


func _spawn_skill_fx_event(event: Dictionary, player: Dictionary) -> void:
	var kind := str(event.get("kind", "hit"))
	var skill_id := int(event.get("skill_id", 0))
	var family := _skill_fx_family(skill_id)
	var color := _skill_fx_color(skill_id)
	var accent := _skill_fx_accent(skill_id)
	var world_position: Vector2 = _as_vec2(event.get("position", Vector2.ZERO), Vector2.ZERO)
	var screen_position: Vector2 = _world_to_screen(world_position, player)
	var radius: float = clamp(float(event.get("radius", 2.0)) * 13.0, 28.0, 108.0) * BATTLE_CAMERA_VISUAL_SCALE * SKILL_FX_SCALE

	if kind == "cast":
		var targets: Array = event.get("target_positions", [])
		if family == "slash":
			return
		if family == "smokeBomb" and not targets.is_empty():
			_spawn_projectile_fx_scene(screen_position, _screen_positions_from_worlds(targets, world_position, player), skill_id, family, color)
			return
		if _skill_fx_is_self_family(family) or targets.is_empty():
			_spawn_self_buff_fx_scene(screen_position, skill_id, family, color, accent)
			return
		if _skill_fx_is_projectile_family(family):
			_spawn_projectile_fx_scene(screen_position, _screen_positions_from_worlds(targets, world_position, player), skill_id, family, color)
			return
		var target_position := _world_to_screen(_as_vec2(targets[0], world_position), player)
		_spawn_skill_projectile(screen_position, target_position, skill_id)
		return

	if kind == "buff":
		_spawn_self_buff_fx_scene(screen_position, skill_id, family, color, accent)
		return

	if kind == "area_start":
		if _skill_fx_is_ground_family(family):
			_spawn_skill_fx_ring(screen_position, radius * 1.25, color, accent, 0.28)
		return

	if kind == "area_tick":
		if not event.get("hit_positions", []).is_empty():
			_spawn_skill_fx_ring(screen_position, radius * 0.62, color, accent, 0.18)
		return

	if kind == "destroy":
		if family == "smokeBomb" or family == "flameGround" or family == "lotusStorm":
			_spawn_skill_fx_ring(screen_position, radius * 0.9, color, accent, 0.28)
		return

	var hit_positions: Array = event.get("hit_positions", [])
	if family == "slash" or family == "moonFlash" or family == "shadowClone":
		var source_screen: Vector2 = _world_to_screen(_as_vec2(event.get("source_position", world_position), world_position), player)
		var target_world: Vector2 = _as_vec2(event.get("aim_position", world_position), world_position)
		if not hit_positions.is_empty():
			target_world = _as_vec2(hit_positions[0], target_world)
		_spawn_basic_slash_fx(source_screen, _world_to_screen(target_world, player), color, skill_id, family)
		return
	if _skill_fx_is_ground_family(family):
		var center_world: Vector2 = _as_vec2(event.get("aim_position", world_position), world_position)
		_spawn_ground_area_fx_scene(_world_to_screen(center_world, player), skill_id, family, radius, color, accent)
		return
	if _skill_fx_is_projectile_family(family):
		var impact_targets := _screen_positions_from_worlds(hit_positions, world_position, player)
		for impact_position in impact_targets.slice(0, 5):
			_spawn_ground_area_fx_scene(impact_position, skill_id, family, max(14.0, radius * 0.42), color, accent)
		return
	if hit_positions.is_empty():
		_spawn_skill_hit_fx(screen_position, skill_id, radius, color, accent)
		return

	for hit_position in hit_positions.slice(0, 8):
		_spawn_skill_hit_fx(_world_to_screen(_as_vec2(hit_position, world_position), player), skill_id, radius, color, accent)


func _screen_positions_from_worlds(values: Array, fallback_world: Vector2, player: Dictionary) -> Array:
	var positions: Array = []
	for value in values:
		positions.append(_world_to_screen(_as_vec2(value, fallback_world), player))
	if positions.is_empty():
		positions.append(_world_to_screen(fallback_world, player))
	return positions


func _spawn_projectile_fx_scene(source: Vector2, targets: Array, skill_id: int, family: String, color: Color) -> void:
	var texture_key := "skill_smoke" if family == "smokeBomb" else _skill_fx_texture_key(skill_id)
	var texture := textures.get(texture_key) as Texture2D
	if texture == null:
		return
	var fx = ProjectileVolleyFxScene.instantiate()
	_skill_fx_parent().add_child(fx)
	skill_fx_nodes.append(fx)
	if fx.has_method("setup"):
		fx.call("setup", texture, source, targets, color, BATTLE_CAMERA_VISUAL_SCALE * SKILL_FX_SCALE, _projectile_fx_profile(skill_id, family))


func _spawn_ground_area_fx_scene(center: Vector2, skill_id: int, family: String, radius: float, color: Color, accent: Color, profile_override := {}) -> void:
	var texture := textures.get(_skill_fx_texture_key(skill_id)) as Texture2D
	var fx = GroundAreaFxScene.instantiate()
	_skill_fx_parent().add_child(fx)
	skill_fx_nodes.append(fx)
	if fx.has_method("setup"):
		var profile := _ground_fx_profile(skill_id, family)
		for key in profile_override.keys():
			profile[key] = profile_override[key]
		fx.call("setup", texture, center, radius * _ground_fx_radius_multiplier(family), color, accent, BATTLE_CAMERA_VISUAL_SCALE * SKILL_FX_SCALE, profile)


func _sync_ground_area_views(areas: Array, player: Dictionary) -> void:
	if feedback_layer == null or player.is_empty():
		return

	var live_ids := {}
	for area in areas:
		if typeof(area) != TYPE_DICTIONARY:
			continue
		var runtime_id := int(area.get("runtime_id", 0))
		if runtime_id <= 0:
			continue
		live_ids[runtime_id] = true

		var skill_id := int(area.get("skill_id", 0))
		var family: String = _skill_fx_family(skill_id)
		var world_position: Vector2 = _as_vec2(area.get("position", Vector2.ZERO), Vector2.ZERO)
		var screen_position: Vector2 = _world_to_screen(world_position, player)
		var radius_world: float = max(24.0, float(area.get("radius_world", 120.0)))
		var screen_radius: float = clamp(radius_world * BATTLE_WORLD_TO_SCREEN_SCALE * 0.82, 48.0, 230.0)
		var remaining: float = max(0.1, float(area.get("remaining", area.get("duration", 2.0))))

		var fx: Node = ground_area_views.get(runtime_id, null) as Node
		if fx == null or not is_instance_valid(fx):
			fx = GroundAreaFxScene.instantiate()
			fx.z_index = 3
			feedback_layer.add_child(fx)
			ground_area_views[runtime_id] = fx
			if fx.has_method("setup"):
				var tint := _skill_fx_color(skill_id)
				var accent := _skill_fx_accent(skill_id)
				var texture := textures.get(_skill_fx_texture_key(skill_id)) as Texture2D
				fx.call("setup", texture, screen_position, screen_radius, tint, accent, 1.0, {
					"duration": remaining,
					"persistent": true,
					"family": family,
				})
		else:
			fx.position = screen_position

	for runtime_id in ground_area_views.keys().duplicate():
		if live_ids.has(runtime_id):
			continue
		var fx = ground_area_views[runtime_id]
		ground_area_views.erase(runtime_id)
		if fx != null and is_instance_valid(fx):
			fx.queue_free()


func _spawn_self_buff_fx_scene(center: Vector2, skill_id: int, family: String, color: Color, accent: Color) -> void:
	var texture := textures.get(_skill_fx_texture_key(skill_id)) as Texture2D
	var fx = SelfBuffFxScene.instantiate()
	_skill_fx_parent().add_child(fx)
	skill_fx_nodes.append(fx)
	if fx.has_method("setup"):
		fx.call("setup", texture, center, color, accent, BATTLE_CAMERA_VISUAL_SCALE, _self_buff_fx_profile(skill_id, family))


func _projectile_fx_profile(skill_id: int, family: String) -> Dictionary:
	match family:
		"projectileVolley":
			return {"count": 3, "duration": 0.2, "stagger": 0.055, "size": Vector2(62, 28), "mode": "direct"}
		"lightning":
			return {"count": 2, "duration": 0.12, "stagger": 0.085, "size": Vector2(78, 24), "mode": "direct"}
		"needlePierce", "weakPointMark":
			return {"count": 1, "duration": 0.16, "stagger": 0.0, "size": Vector2(72, 22), "mode": "direct"}
		"orbitBurst":
			return {"count": 6, "duration": 0.22, "stagger": 0.025, "size": Vector2(54, 24), "mode": "orbit"}
		"spearRain":
			return {"count": 8, "duration": 0.18, "stagger": 0.035, "size": Vector2(58, 26), "mode": "drop"}
		"smokeBomb":
			return {"count": 1, "duration": 0.24, "stagger": 0.0, "size": Vector2(48, 48), "mode": "lob"}
		_:
			return {"count": 1, "duration": 0.18, "stagger": 0.0, "size": Vector2(62, 28), "mode": "direct"}


func _ground_fx_profile(skill_id: int, family: String) -> Dictionary:
	match family:
		"smokeBomb":
			return {"duration": 0.62}
		"flameGround":
			return {"duration": 0.54}
		"lotusStorm":
			return {"duration": 0.72}
		"weakPointMark":
			return {"duration": 0.46}
		_:
			return {"duration": 0.28}


func _self_buff_fx_profile(skill_id: int, family: String) -> Dictionary:
	match family:
		"galeStep":
			return {"duration": 0.46, "radius": 64.0, "style": "gale"}
		"killingFocus":
			return {"duration": 0.5, "radius": 54.0, "style": "focus"}
		"timeFold":
			return {"duration": 0.56, "radius": 58.0, "style": "time"}
		_:
			return {"duration": 0.48, "radius": 52.0}


func _slash_fx_profile(skill_id: int, family: String) -> Dictionary:
	if family == "shadowClone" or skill_id == 300109:
		return {"style": "clone", "duration": 0.34}
	if family == "moonFlash" or skill_id == 300110:
		return {"style": "moon", "duration": 0.28}
	return {"style": "basic", "duration": 0.3}


func _ground_fx_radius_multiplier(family: String) -> float:
	match family:
		"smokeBomb":
			return 1.15
		"flameGround":
			return 1.28
		"lotusStorm":
			return 1.5
		"weakPointMark":
			return 0.82
		_:
			return 0.72


func _spawn_skill_projectile(start: Vector2, target: Vector2, skill_id: int) -> void:
	var texture_key := _skill_fx_texture_key(skill_id)
	var family := _skill_fx_family(skill_id)
	var color := _skill_fx_color(skill_id)
	var size := Vector2(82, 46) * BATTLE_CAMERA_VISUAL_SCALE * SKILL_FX_SCALE
	if family == "projectileVolley" or family == "lightning" or family == "needlePierce" or family == "weakPointMark":
		size = Vector2(72, 32) * BATTLE_CAMERA_VISUAL_SCALE * SKILL_FX_SCALE
	var sprite := _make_skill_fx_sprite(texture_key, size, color)
	if sprite == null:
		return
	var base_scale := sprite.scale
	sprite.position = start
	sprite.rotation = (target - start).angle()
	sprite.modulate.a = 0.82
	_skill_fx_parent().add_child(sprite)
	skill_fx_nodes.append(sprite)
	var tween := sprite.create_tween()
	tween.set_parallel(true)
	tween.tween_property(sprite, "position", target, 0.13)
	tween.tween_property(sprite, "scale", base_scale * 1.14, 0.13)
	tween.tween_property(sprite, "modulate:a", 0.12, 0.16)
	tween.set_parallel(false)
	tween.tween_callback(func(): _free_skill_fx_node(sprite))


func _spawn_basic_slash_fx(source: Vector2, target: Vector2, color: Color, skill_id := 300101, family := "slash") -> void:
	var slash_texture := textures.get(_skill_fx_texture_key(skill_id)) as Texture2D
	if slash_texture == null:
		slash_texture = textures.get("skill") as Texture2D
	if slash_texture == null:
		return
	var fx = BasicSlashFxScene.instantiate()
	_skill_fx_parent().add_child(fx)
	skill_fx_nodes.append(fx)
	if fx.has_method("setup"):
		fx.call("setup", slash_texture, source, target, color, BATTLE_CAMERA_VISUAL_SCALE, _slash_fx_profile(skill_id, family))


func _spawn_skill_hit_fx(center: Vector2, skill_id: int, radius: float, color: Color, accent: Color) -> void:
	var family := _skill_fx_family(skill_id)
	var texture_key := _skill_fx_texture_key(skill_id)
	var sprite_size := Vector2(72, 72)
	var texture_color := color
	var rotation := rng_angle(skill_id)

	if family == "slash" or family == "moonFlash" or family == "shadowClone":
		sprite_size = Vector2(116, 70)
		texture_key = "skill"
	elif family == "smokeBomb":
		sprite_size = Vector2(154, 154)
		texture_key = "skill_smoke"
		texture_color = Color(0.78, 0.86, 0.82, 0.78)
	elif family == "flameGround":
		sprite_size = Vector2(132, 132)
		texture_key = "skill_impact"
	elif family == "orbitBurst" or family == "spearRain":
		sprite_size = Vector2(86, 58)

	_spawn_skill_fx_texture(center, texture_key, texture_color, sprite_size.x, 0.28, rotation)
	_spawn_skill_fx_ring(center, radius, color, accent, 0.24)


func _spawn_skill_fx_texture(center: Vector2, texture_key: String, color: Color, size_px: float, duration: float, rotation := 0.0) -> void:
	var size := Vector2(size_px, size_px) * BATTLE_CAMERA_VISUAL_SCALE * SKILL_FX_SCALE
	if texture_key == "skill" or texture_key == "skill_shuriken" or texture_key == "skill_gale":
		size = Vector2(size_px, size_px * 0.62) * BATTLE_CAMERA_VISUAL_SCALE * SKILL_FX_SCALE
	var sprite := _make_skill_fx_sprite(texture_key, size, color)
	if sprite == null:
		return
	var base_scale := sprite.scale
	sprite.position = center
	sprite.rotation = rotation
	sprite.modulate.a = min(sprite.modulate.a, 0.86)
	_skill_fx_parent().add_child(sprite)
	skill_fx_nodes.append(sprite)
	var tween := sprite.create_tween()
	tween.set_parallel(true)
	tween.tween_property(sprite, "scale", base_scale * 1.34, duration)
	tween.tween_property(sprite, "modulate:a", 0.0, duration)
	tween.set_parallel(false)
	tween.tween_callback(func(): _free_skill_fx_node(sprite))


func _make_skill_fx_sprite(texture_key: String, size: Vector2, color: Color) -> Sprite2D:
	var texture := textures.get(texture_key) as Texture2D
	if texture == null:
		return null
	var sprite := Sprite2D.new()
	sprite.texture = texture
	sprite.centered = true
	sprite.z_index = 24
	var texture_size := texture.get_size()
	if texture_size.x > 0.0 and texture_size.y > 0.0:
		sprite.scale = Vector2(size.x / texture_size.x, size.y / texture_size.y)
	sprite.modulate = color
	return sprite


func _skill_fx_parent() -> Control:
	return skill_fx_layer if skill_fx_layer != null else feedback_layer


func _spawn_skill_fx_ring(center: Vector2, radius: float, color: Color, accent: Color, duration: float) -> void:
	var size := Vector2(radius * 2.0, radius * 2.0)
	var ring := _feedback_circle(size, Color(color.r, color.g, color.b, 0.08), Color(accent.r, accent.g, accent.b, 0.48), max(6, int(radius)), 2)
	ring.position = center - size * 0.5
	ring.pivot_offset = size * 0.5
	ring.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_skill_fx_parent().add_child(ring)
	skill_fx_nodes.append(ring)
	var tween := ring.create_tween()
	tween.set_parallel(true)
	tween.tween_property(ring, "scale", Vector2.ONE * 1.42, duration)
	tween.tween_property(ring, "modulate:a", 0.0, duration)
	tween.set_parallel(false)
	tween.tween_callback(func(): _free_skill_fx_node(ring))


func _free_skill_fx_node(node: Node) -> void:
	if node == null:
		return
	skill_fx_nodes.erase(node)
	if is_instance_valid(node):
		node.queue_free()


func _clear_skill_fx_state() -> void:
	handled_skill_fx_events.clear()
	for node in ground_area_views.values():
		if node != null and is_instance_valid(node):
			node.queue_free()
	ground_area_views.clear()
	for node in skill_fx_nodes:
		if node != null and is_instance_valid(node):
			node.queue_free()
	skill_fx_nodes.clear()


func _skill_fx_family(skill_id: int) -> String:
	match int(skill_id):
		300102:
			return "projectileVolley"
		300103:
			return "smokeBomb"
		300104:
			return "shadowBreath"
		300105:
			return "orbitBurst"
		300106:
			return "lightning"
		300107:
			return "flameGround"
		300108:
			return "needlePierce"
		300109:
			return "shadowClone"
		300110:
			return "moonFlash"
		300111:
			return "spearRain"
		300112:
			return "lotusStorm"
		300113:
			return "killingFocus"
		300114:
			return "timeFold"
		300115:
			return "galeStep"
		300116:
			return "weakPointMark"
		_:
			return "slash"


func _skill_fx_texture_key(skill_id: int) -> String:
	var family := _skill_fx_family(skill_id)
	if skill_id == 300109 or family == "shadowClone":
		return "skill_shadow_clone"
	if skill_id == 300110 or family == "moonFlash":
		return "skill_moon_flash"
	if skill_id == 300113 or family == "killingFocus":
		return "skill_killing_focus"
	if skill_id == 300114 or family == "timeFold":
		return "skill_time_fold"
	if family == "projectileVolley" or family == "orbitBurst" or family == "spearRain" or family == "lightning" or family == "needlePierce":
		return "skill_shuriken"
	if family == "smokeBomb":
		return "skill_smoke"
	if family == "galeStep":
		return "skill_gale"
	if family == "flameGround" or family == "weakPointMark" or family == "lotusStorm":
		return "skill_impact"
	return "skill"


func _skill_fx_color(skill_id: int) -> Color:
	match int(skill_id):
		300102:
			return Color(0.84, 0.84, 0.76, 0.86)
		300103:
			return Color(0.6, 0.66, 0.66, 0.76)
		300104, 300106, 300114:
			return Color(0.18, 0.9, 1.0, 0.86)
		300107:
			return Color(1.0, 0.48, 0.2, 0.82)
		300108:
			return Color(0.56, 0.86, 1.0, 0.84)
		300109:
			return Color(0.18, 0.92, 1.0, 0.7)
		300110:
			return Color(0.82, 0.96, 1.0, 0.92)
		300112:
			return Color(0.49, 0.36, 1.0, 0.82)
		300113, 300116:
			return Color(1.0, 0.42, 0.34, 0.84)
		300115:
			return Color(0.55, 0.85, 0.36, 0.82)
		_:
			return Color(1.0, 0.88, 0.48, 0.86)


func _skill_fx_accent(skill_id: int) -> Color:
	var family := _skill_fx_family(skill_id)
	if family == "smokeBomb" or family == "shadowBreath" or family == "timeFold":
		return Color(0.22, 0.88, 0.82, 0.68)
	if family == "flameGround" or family == "killingFocus" or family == "weakPointMark":
		return Color(1.0, 0.83, 0.42, 0.72)
	if family == "galeStep" or family == "spearRain":
		return Color(0.86, 1.0, 0.72, 0.68)
	return Color(1.0, 0.96, 0.78, 0.7)


func _skill_fx_is_self_family(family: String) -> bool:
	return family == "shadowBreath" or family == "killingFocus" or family == "timeFold" or family == "galeStep"


func _skill_fx_is_projectile_family(family: String) -> bool:
	return family == "projectileVolley" or family == "lightning" or family == "needlePierce" or family == "orbitBurst" or family == "spearRain" or family == "weakPointMark"


func _skill_fx_is_ground_family(family: String) -> bool:
	return family == "smokeBomb" or family == "flameGround" or family == "lotusStorm" or family == "weakPointMark"


func rng_angle(seed_value: int) -> float:
	return sin(float(seed_value) * 12.9898 + float(Time.get_ticks_msec()) * 0.001) * 0.75


func _sync_ambient_pickups(pickup_defs: Array, player: Dictionary, elapsed: float, use_default_when_empty := false) -> void:
	var defs: Array = pickup_defs
	if defs.is_empty() and use_default_when_empty:
		defs = _default_ambient_pickup_defs()
	_sync_pickup_view_count(defs.size())
	var viewport := get_viewport_rect().size
	for index in range(ambient_pickup_views.size()):
		var root := ambient_pickup_views[index]
		var pickup_def: Dictionary = defs[index]
		var world_position: Vector2 = _as_vec2(pickup_def.get("position", Vector2.ZERO), Vector2.ZERO)
		var screen_position := _world_to_screen(world_position, player)
		var phase := (sin(elapsed * 3.2 + float(index) * 0.63) + 1.0) * 0.5
		var pickup_key := str(pickup_def.get("key", ""))
		var pickup_kind := str(pickup_def.get("kind", ""))
		var pickup_type := str(pickup_def.get("type", ""))
		var is_exp: bool = pickup_kind == "exp" or pickup_key == "exp"
		var is_encounter: bool = pickup_kind == "encounter" or pickup_key.begins_with("encounter_")
		var is_mine: bool = pickup_type == "mine" or pickup_key == "encounter_mine"
		root.pivot_offset = root.size * 0.5
		root.position = screen_position - root.size * 0.5 + Vector2(0.0, -phase * 5.0)
		root.scale = Vector2.ONE * (0.98 + phase * 0.08 + (0.08 if is_encounter else 0.0)) * BATTLE_CAMERA_VISUAL_SCALE
		root.modulate.a = (0.72 + phase * 0.26) if is_encounter else (0.46 + phase * 0.34)
		root.visible = screen_position.x > -80 and screen_position.x < viewport.x + 80 and screen_position.y > -80 and screen_position.y < viewport.y + 80
		var icon := root.get_node_or_null("Icon") as TextureRect
		if icon != null:
			icon.visible = not is_exp
			if not is_exp:
				icon.texture = textures.get(pickup_key if pickup_key != "" else "res_gold")
		var exp_diamond := root.get_node_or_null("ExpDiamond") as ColorRect
		if exp_diamond != null:
			exp_diamond.visible = is_exp
			exp_diamond.color = Color(0.24 + phase * 0.1, 0.68 + phase * 0.18, 1.0, 0.92)
		var exp_core := root.get_node_or_null("ExpCore") as ColorRect
		if exp_core != null:
			exp_core.visible = is_exp
			exp_core.color = Color(0.86, 0.98, 1.0, 0.88 + phase * 0.12)
		var exp_spark := root.get_node_or_null("ExpSpark") as ColorRect
		if exp_spark != null:
			exp_spark.visible = is_exp
			exp_spark.position = Vector2(13.0 + phase * 4.0, 9.0 - phase * 3.0)
		var progress_track := root.get_node_or_null("MineProgressTrack") as ColorRect
		if progress_track != null:
			progress_track.visible = is_mine
			var progress_fill := root.get_node_or_null("MineProgressFill") as ColorRect
			if progress_fill != null:
				var mine_progress_value: float = float(pickup_def.get("progress", 0.0))
				var progress: float = clampf(mine_progress_value, 0.0, 1.0)
				progress_fill.visible = is_mine
				progress_fill.size = Vector2(38.0 * progress, 4.0)
		var glow := root.get_child(0) as PanelContainer
		if glow != null:
			var glow_color: Color = Color(0.12, 0.5, 1.0, 0.2 + phase * 0.12) if is_exp else pickup_def.get("color", Color(1.0, 0.8, 0.35, 0.18))
			var glow_border: Color = Color(0.62, 0.92, 1.0, 0.36) if is_exp else (Color(1.0, 0.86, 0.38, 0.42) if is_encounter else Color(1.0, 0.9, 0.65, 0.22))
			glow.add_theme_stylebox_override("panel", _style(glow_color, glow_border, 32, 1))


func _sync_boss_telegraphs(entities: Array, player: Dictionary, elapsed: float) -> void:
	var live_ids := {}
	for entity in entities:
		if typeof(entity) != TYPE_DICTIONARY or str(entity.get("kind", "")) != "boss":
			continue
		var runtime_id := int(entity.get("runtime_id", 0))
		live_ids[runtime_id] = true
		if not boss_telegraph_views.has(runtime_id):
			boss_telegraph_views[runtime_id] = _create_boss_telegraph_view()
			feedback_layer.add_child(boss_telegraph_views[runtime_id])
		var root := boss_telegraph_views[runtime_id] as Control
		var screen_position := _world_to_screen(entity.get("position", Vector2.ZERO), player)
		var pulse := (sin(elapsed * 5.1 + float(runtime_id)) + 1.0) * 0.5
		var size := Vector2(172 + pulse * 16, 172 + pulse * 16) * BATTLE_CAMERA_VISUAL_SCALE
		_set_centered(root, screen_position + Vector2(0, 8), size)
		root.modulate.a = 0.84 + pulse * 0.16
		root.visible = true

	for runtime_id in boss_telegraph_views.keys().duplicate():
		if live_ids.has(runtime_id):
			continue
		var root := boss_telegraph_views[runtime_id] as Control
		root.queue_free()
		boss_telegraph_views.erase(runtime_id)


func _create_boss_telegraph_view() -> Control:
	var root := Control.new()
	root.size = Vector2(210, 210)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var outer := _feedback_circle(Vector2(210, 210), Color(1.0, 0.16, 0.12, 0.08), Color(1.0, 0.26, 0.18, 0.42), 140, 3)
	root.add_child(outer)

	var inner := _feedback_circle(Vector2(142, 142), Color(1.0, 0.72, 0.18, 0.045), Color(1.0, 0.78, 0.24, 0.28), 96, 2)
	inner.position = Vector2(34, 34)
	root.add_child(inner)

	var line := ColorRect.new()
	line.color = Color(1.0, 0.22, 0.16, 0.32)
	line.size = Vector2(4, 56)
	line.position = Vector2(103, 0)
	root.add_child(line)

	var cross := ColorRect.new()
	cross.color = Color(1.0, 0.9, 0.68, 0.22)
	cross.size = Vector2(42, 3)
	cross.position = Vector2(84, 24)
	root.add_child(cross)
	return root


func _sync_threat_lines(entities: Array, player: Dictionary, elapsed: float) -> void:
	var player_screen := _world_to_screen(player.get("position", Vector2(1500, 1000)), player)
	var entries := []
	for entity in entities:
		if typeof(entity) != TYPE_DICTIONARY or entity.get("team", "") != "enemy" or float(entity.get("hp", 0.0)) <= 0.0:
			continue
		var screen_position := _world_to_screen(entity.get("position", Vector2.ZERO), player)
		var distance := screen_position.distance_to(player_screen)
		entries.append({"screen": screen_position, "distance": distance, "kind": str(entity.get("kind", "enemy"))})
	entries.sort_custom(func(a, b): return float(a.get("distance", 0.0)) < float(b.get("distance", 0.0)))

	for index in range(threat_line_views.size()):
		var line := threat_line_views[index]
		if index >= entries.size():
			line.visible = false
			continue
		var entry: Dictionary = entries[index]
		var enemy_screen: Vector2 = entry.get("screen", player_screen)
		var delta: Vector2 = player_screen - enemy_screen
		var length: float = clamp(delta.length(), 34.0, 360.0)
		var alpha: float = 0.16 + clamp(1.0 - length / 360.0, 0.0, 1.0) * 0.22
		line.size = Vector2(3 if str(entry.get("kind", "")) != "boss" else 4, length)
		line.pivot_offset = Vector2(line.size.x * 0.5, line.size.y * 0.5)
		line.position = enemy_screen + delta * 0.5 - line.pivot_offset
		line.rotation = delta.angle() - PI * 0.5
		line.color = Color(1.0, 0.18, 0.12, alpha + sin(elapsed * 4.0 + float(index)) * 0.04)
		line.visible = true


func _set_centered(control: Control, center: Vector2, size: Vector2) -> void:
	if control == null:
		return
	control.size = size
	control.position = center - size * 0.5


func _sync_battle_camera(player: Dictionary) -> void:
	if player.is_empty():
		return
	var target: Vector2 = _as_vec2(player.get("position", Vector2(1500, 1000)), Vector2(1500, 1000))
	if not battle_camera_ready:
		battle_camera_world_position = target
		battle_camera_start_position = target
		battle_camera_ready = true
	else:
		var follow: float = 1.0 - exp(-battle_frame_delta * BATTLE_CAMERA_FOLLOW)
		battle_camera_world_position = battle_camera_world_position.lerp(target, follow)
		var offset: Vector2 = target - battle_camera_world_position
		if offset.length() > BATTLE_CAMERA_MAX_WORLD_OFFSET:
			battle_camera_world_position = target - offset.normalized() * BATTLE_CAMERA_MAX_WORLD_OFFSET

	if battle_tile_world != null:
		battle_tile_world.sync(battle_camera_world_position, get_viewport_rect().size, BATTLE_WORLD_TO_SCREEN_SCALE)
	if world_layer != null:
		world_layer.position = Vector2.ZERO


func _sync_entity_views(entities: Array, player: Dictionary, snapshot: Dictionary) -> void:
	var live_ids := {}
	var dash: Dictionary = snapshot.get("dash", {})
	for entity in entities:
		if typeof(entity) != TYPE_DICTIONARY:
			continue
		var runtime_id := int(entity.get("runtime_id", 0))
		live_ids[runtime_id] = true
		if not entity_views.has(runtime_id):
			entity_views[runtime_id] = _create_entity_view(entity)

		var view = entity_views[runtime_id]
		var root := view["root"] as Control
		var kind := str(entity.get("kind", "enemy"))
		var world_position := _as_vec2(entity.get("position", Vector2.ZERO), Vector2.ZERO)
		var render_world_position := world_position
		if kind != "player":
			render_world_position = _enemy_render_world_position(view, world_position)
		var screen_position := _world_to_screen(render_world_position, player)
		root.pivot_offset = root.size * 0.5
		root.scale = Vector2.ONE * BATTLE_CAMERA_VISUAL_SCALE
		root.position = screen_position - root.size * 0.5
		var fixture_control_zone := bool(snapshot.get("visual_fixture", false)) and kind != "player" and screen_position.y > get_viewport_rect().size.y - 310.0
		root.visible = not fixture_control_zone
		var hp_fill := view["hp"] as ColorRect
		var hp_bg := view["hp_bg"] as ColorRect
		var hp_ratio: float = clamp(float(entity.get("hp", 0.0)) / max(1.0, float(entity.get("max_hp", 1.0))), 0.0, 1.0)
		hp_fill.size.x = float(view["hp_width"]) * hp_ratio
		if hp_bg != null:
			hp_bg.visible = root.visible
		if hp_fill != null:
			hp_fill.visible = root.visible
		if kind == "player":
			_sync_player_entity_sprite(view, dash, entity)
		else:
			_sync_enemy_entity_sprite(view, entity, player)

	for runtime_id in entity_views.keys().duplicate():
		if not live_ids.has(runtime_id):
			var view = entity_views[runtime_id]
			var root := view["root"] as Control
			root.queue_free()
			entity_views.erase(runtime_id)


func _enemy_render_world_position(view: Dictionary, world_position: Vector2) -> Vector2:
	var render_world_position := _as_vec2(view.get("render_world_position", world_position), world_position)
	if render_world_position.distance_to(world_position) > 180.0:
		render_world_position = world_position
	else:
		var follow: float = 1.0 - exp(-battle_frame_delta * 18.0)
		render_world_position = render_world_position.lerp(world_position, follow)
	view["render_world_position"] = render_world_position
	return render_world_position


func _sync_enemy_entity_sprite(view: Dictionary, entity: Dictionary, player: Dictionary) -> void:
	var sprite := view.get("sprite") as TextureRect
	if sprite == null:
		return

	var data_id := int(entity.get("data_id", 0))
	var runtime_id := int(entity.get("runtime_id", 0))
	var world_position := _as_vec2(entity.get("position", Vector2.ZERO), Vector2.ZERO)
	var last_world_position := _as_vec2(view.get("last_world_position", world_position), world_position)
	var movement := world_position - last_world_position
	var moving := movement.length_squared() > 0.35
	var player_position := _as_vec2(player.get("position", world_position), world_position)
	var facing_vector := movement if moving else player_position - world_position
	var previous_direction := str(view.get("direction", "down"))
	var direction := _direction_key_for_vector(facing_vector, previous_direction)
	var texture_direction := "left" if direction == "right" else direction
	var motion_strength: float = clamp(movement.length() / 8.0, 0.0, 1.0)

	var phase: float = float(view.get("walk_phase", float(runtime_id % ENEMY_WALK_COLUMNS)))
	var idle_breath := 0.0
	var profile := _enemy_motion_profile(data_id)
	if moving:
		phase += battle_frame_delta * float(profile.get("rate", ENEMY_WALK_FRAME_RATE)) * (0.72 + motion_strength * 0.32)
	else:
		var now: float = float(Time.get_ticks_msec()) / 1000.0
		phase = _enemy_settle_motion_phase(phase, profile)
		idle_breath = 0.5 + 0.5 * sin(now * TAU * float(profile.get("idle_breath_rate", 0.36)) + float(runtime_id) * 0.47)
		motion_strength = 0.08 + idle_breath * 0.06
	view["walk_phase"] = phase
	view["direction"] = direction
	view["last_world_position"] = world_position

	var frame_index: int = _enemy_motion_frame_index(phase, profile)
	var motion_texture: Texture2D = null
	if bool(profile.get("use_sheet", true)):
		motion_texture = _enemy_motion_texture(data_id, texture_direction, frame_index)
	elif bool(profile.get("use_direction_pose", false)):
		motion_texture = _enemy_motion_texture(data_id, texture_direction, 0)
	if motion_texture != null:
		sprite.texture = motion_texture
	else:
		var fallback := textures.get("unit_%d" % data_id) as Texture2D
		if fallback != null:
			sprite.texture = fallback

	sprite.flip_h = _enemy_should_flip(data_id, direction)
	var step_wave: float = _enemy_motion_wave(phase, profile)
	var lift_y: float = -step_wave * float(profile.get("lift", 2.4)) * motion_strength - idle_breath * float(profile.get("idle_lift", 0.45))
	var lean: float = clamp(movement.x / 12.0, -1.0, 1.0) * float(profile.get("lean", 0.035))
	var squash_x: float = 1.0 + step_wave * float(profile.get("squash_x", 0.018)) * motion_strength + idle_breath * float(profile.get("idle_squash_x", 0.004))
	var squash_y: float = 1.0 - step_wave * float(profile.get("squash_y", 0.012)) * motion_strength - idle_breath * float(profile.get("idle_squash_y", 0.003))
	sprite.position = Vector2(0.0, lift_y)
	sprite.scale = Vector2(squash_x, squash_y)
	sprite.rotation = lean
	sprite.modulate = Color.WHITE
	_sync_enemy_shadow(view, motion_strength, step_wave, profile)


func _enemy_motion_profile(data_id: int) -> Dictionary:
	match data_id:
		Catalog.SOOT_SPIRIT_UNIT_ID:
			return {
				"rate": 4.4,
				"cycle_steps": 4.0,
				"rest_step": 3.2,
				"settle_rate": 0.34,
				"idle_breath_rate": 0.28,
				"lift": 4.8,
				"idle_lift": 1.35,
				"lean": 0.022,
				"squash_x": 0.006,
				"squash_y": 0.005,
				"idle_squash_x": 0.003,
				"idle_squash_y": 0.002,
				"shadow_width": 0.42,
				"shadow_motion": 0.04,
			}
		Catalog.PURPLE_MUSHROOM_UNIT_ID:
			return {
				"use_sheet": false,
				"use_direction_pose": true,
				"rate": 1.8,
				"cycle_steps": 6.0,
				"rest_step": 5.0,
				"settle_rate": 0.18,
				"idle_breath_rate": 0.12,
				"lift": 0.0,
				"idle_lift": 0.02,
				"lean": 0.0,
				"squash_x": 0.0,
				"squash_y": 0.0,
				"idle_squash_x": 0.001,
				"idle_squash_y": 0.001,
				"shadow_width": 0.54,
				"shadow_motion": 0.012,
			}
		Catalog.BOSS_UNIT_ID:
			return {
				"use_sheet": false,
				"rate": 2.1,
				"cycle_steps": 6.0,
				"rest_step": 5.0,
				"settle_rate": 0.22,
				"idle_breath_rate": 0.12,
				"lift": 0.06,
				"idle_lift": 0.03,
				"lean": 0.0,
				"squash_x": 0.002,
				"squash_y": 0.002,
				"idle_squash_x": 0.0015,
				"idle_squash_y": 0.001,
				"shadow_width": 0.6,
				"shadow_motion": 0.015,
			}
		_:
			return {
				"rate": ENEMY_WALK_FRAME_RATE,
				"cycle_steps": ENEMY_HOP_CYCLE_STEPS,
				"rest_step": ENEMY_HOP_REST_STEP,
				"settle_rate": 0.64,
				"idle_breath_rate": 0.36,
				"lift": 2.4,
				"idle_lift": 0.45,
				"lean": 0.035,
				"squash_x": 0.018,
				"squash_y": 0.012,
				"idle_squash_x": 0.004,
				"idle_squash_y": 0.003,
				"shadow_width": 0.48,
				"shadow_motion": 0.08,
			}


func _enemy_should_flip(data_id: int, direction: String) -> bool:
	return direction == "right" and enemy_walk_frames.has("%d_left" % data_id)


func _enemy_settle_motion_phase(phase: float, profile: Dictionary) -> float:
	var cycle_steps := float(profile.get("cycle_steps", ENEMY_HOP_CYCLE_STEPS))
	var rest_step := float(profile.get("rest_step", ENEMY_HOP_REST_STEP))
	var cycle_position := fposmod(phase, cycle_steps)
	if cycle_position >= rest_step:
		return phase - cycle_position + rest_step
	var next_phase := phase + battle_frame_delta * float(profile.get("rate", ENEMY_WALK_FRAME_RATE)) * float(profile.get("settle_rate", 0.64))
	var next_cycle_position := fposmod(next_phase, cycle_steps)
	if next_cycle_position < cycle_position or next_cycle_position >= rest_step:
		return phase - cycle_position + rest_step
	return next_phase


func _enemy_motion_frame_index(phase: float, profile: Dictionary) -> int:
	var step := int(floor(fposmod(phase, float(profile.get("cycle_steps", ENEMY_HOP_CYCLE_STEPS)))))
	match step:
		0:
			return 0
		1:
			return 1
		2:
			return 2
		3, 4:
			return 3
		_:
			return 0


func _enemy_motion_wave(phase: float, profile: Dictionary) -> float:
	var cycle_position: float = fposmod(phase, float(profile.get("cycle_steps", ENEMY_HOP_CYCLE_STEPS)))
	var rest_step: float = min(4.0, float(profile.get("rest_step", ENEMY_HOP_REST_STEP)))
	if cycle_position >= rest_step:
		return 0.0
	return sin(clamp(cycle_position / max(0.001, rest_step), 0.0, 1.0) * PI)


func _enemy_motion_texture(data_id: int, direction: String, frame_index: int) -> Texture2D:
	var frames: Array = enemy_walk_frames.get("%d_%s" % [data_id, direction], [])
	if frames.is_empty():
		return null
	var frame := frames[frame_index % frames.size()] as Texture2D
	return frame


func _sync_enemy_shadow(view: Dictionary, motion_strength: float, step_wave: float, profile: Dictionary) -> void:
	var shadow := view.get("shadow") as PanelContainer
	var root := view.get("root") as Control
	if shadow == null or root == null:
		return
	var shadow_width: float = root.size.x * (float(profile.get("shadow_width", 0.48)) + motion_strength * float(profile.get("shadow_motion", 0.08)))
	var shadow_height: float = 10.0 - step_wave * 1.4
	shadow.size = Vector2(shadow_width, shadow_height)
	shadow.position = Vector2((root.size.x - shadow_width) * 0.5, root.size.y - 21.0 + step_wave * 1.0)
	shadow.modulate = Color(1.0, 1.0, 1.0, 0.54 - step_wave * 0.12)


func _sync_player_entity_sprite(view: Dictionary, dash: Dictionary, player: Dictionary) -> void:
	var sprite := view.get("sprite") as TextureRect
	if sprite == null:
		return

	var dash_active := bool(dash.get("active", false))
	var dash_invulnerable := bool(dash.get("invulnerable", false))
	var attack_pose_time := float(player.get("attack_pose_time", 0.0))
	var target_motion := battle_input_vector
	if dash_active:
		target_motion = _as_vec2(dash.get("last_vector", last_battle_input_vector), last_battle_input_vector)
	if target_motion.length_squared() > 1.0:
		target_motion = target_motion.normalized()

	var moving := target_motion.length_squared() > 0.0001 or dash_active
	var motion_follow: float = 1.0 - exp(-battle_frame_delta * (18.0 if moving else 10.0))
	player_render_motion = player_render_motion.lerp(target_motion if moving else Vector2.ZERO, motion_follow)
	var facing_vector := player_render_facing
	if target_motion.length_squared() > 0.0001:
		facing_vector = target_motion.normalized()
		player_render_facing = facing_vector

	var previous_direction := str(view.get("direction", "down"))
	var direction := _player_move_direction_key_for_vector(facing_vector, previous_direction)
	view["direction"] = direction

	var motion_strength: float = clamp(max(target_motion.length(), player_render_motion.length()), 0.0, 1.0)
	if moving:
		var dash_multiplier := 1.7 if dash_active else 1.0
		var phase_delta := battle_frame_delta * PLAYER_WALK_FRAME_RATE * (0.55 + motion_strength * 0.45) * dash_multiplier
		player_walk_phase += phase_delta
	else:
		player_walk_phase = lerpf(player_walk_phase, 0.0, clamp(battle_frame_delta * 8.0, 0.0, 1.0))
	var frame_index: int = int(floor(player_walk_phase)) % PLAYER_WALK_COLUMNS
	if frame_index < 0:
		frame_index += PLAYER_WALK_COLUMNS

	sprite.texture = _player_motion_texture(direction, moving, frame_index)
	sprite.flip_h = _player_should_flip_direction(direction)
	var step_wave: float = abs(sin(player_walk_phase * PI))
	var lift_y: float = -step_wave * 3.2 * motion_strength if moving else 0.0
	var lean: float = clamp(player_render_motion.x, -1.0, 1.0) * 0.035 * motion_strength
	var stretch_x: float = 1.0 + step_wave * 0.012 * motion_strength
	var stretch_y: float = 1.0 - step_wave * 0.008 * motion_strength
	var attack_pulse: float = clamp(attack_pose_time / 0.22, 0.0, 1.0)
	var attack_offset := player_render_facing * (3.6 * attack_pulse)

	if dash_active:
		stretch_x = 1.045
		stretch_y = 0.972
		lift_y = -5.0
		lean = clamp(player_render_motion.x, -1.0, 1.0) * 0.055

	sprite.position = Vector2(0.0, lift_y) + attack_offset
	sprite.scale = Vector2(stretch_x + attack_pulse * 0.018, stretch_y - attack_pulse * 0.012)
	sprite.rotation = lean
	var now: float = float(Time.get_ticks_msec()) / 1000.0
	sprite.modulate = Color(1.0, 1.0, 1.0, 0.88 + 0.12 * abs(sin(now * TAU * 7.0))) if dash_invulnerable else Color.WHITE
	_sync_player_shadow(view, motion_strength, step_wave, dash_active)
	_sync_player_dash_trails(view, sprite, player_render_motion, dash_active)


func _sync_player_shadow(view: Dictionary, motion_strength: float, step_wave: float, dash_active: bool) -> void:
	var shadow := view.get("shadow") as PanelContainer
	var root := view.get("root") as Control
	if shadow == null or root == null:
		return
	var shadow_width: float = root.size.x * 0.5 + motion_strength * 7.0 + (10.0 if dash_active else 0.0)
	var shadow_height: float = 14.0 - step_wave * 2.0
	shadow.size = Vector2(shadow_width, shadow_height)
	shadow.position = Vector2((root.size.x - shadow_width) * 0.5, root.size.y - 24.0 + step_wave * 1.5)
	shadow.modulate = Color(1.0, 1.0, 1.0, 0.62 - step_wave * 0.12)


func _sync_player_dash_trails(view: Dictionary, sprite: TextureRect, motion_vector: Vector2, dash_active: bool) -> void:
	var trail_sprites: Array = view.get("trail_sprites", [])
	var direction := motion_vector.normalized() if motion_vector.length_squared() > 0.0001 else last_battle_input_vector
	for index in range(trail_sprites.size()):
		var trail := trail_sprites[index] as TextureRect
		if trail == null:
			continue
		if not dash_active:
			trail.visible = false
			continue
		trail.visible = true
		trail.texture = sprite.texture
		trail.flip_h = sprite.flip_h
		trail.size = sprite.size
		trail.pivot_offset = sprite.pivot_offset
		trail.position = sprite.position - direction * (18.0 + float(index) * 16.0)
		trail.scale = sprite.scale * (0.95 - float(index) * 0.09)
		trail.rotation = sprite.rotation
		trail.modulate = Color(0.54, 1.0, 0.86, 0.24 - float(index) * 0.08)


func _player_motion_texture(direction: String, moving: bool, frame_index: int) -> Texture2D:
	var texture_direction := _player_texture_direction_for(direction)
	if player_walk_frames.has(texture_direction):
		var frames: Array = player_walk_frames[texture_direction]
		if not frames.is_empty():
			var frame := frames[frame_index % frames.size()] as Texture2D
			if frame != null:
				return frame
	if player_walk_frames.has("down"):
		var down_frames: Array = player_walk_frames["down"]
		if not down_frames.is_empty():
			var down_frame := down_frames[frame_index % down_frames.size()] as Texture2D
			if down_frame != null:
				return down_frame
	var directional := textures.get("player_dir_%s" % texture_direction) as Texture2D
	if directional != null:
		return directional
	var fallback := textures.get("player_dir_down") as Texture2D
	if fallback != null:
		return fallback
	return textures.get("unit_%d" % Catalog.PLAYER_UNIT_ID) as Texture2D


func _player_should_flip_direction(direction: String) -> bool:
	return (
		(direction == "right" and not player_walk_frames.has("right") and player_walk_frames.has("left"))
		or (direction == "left" and not player_walk_frames.has("left") and player_walk_frames.has("right"))
	)


func _player_texture_direction_for(direction: String) -> String:
	if player_walk_frames.has(direction):
		return direction
	if direction == "right" and player_walk_frames.has("left"):
		return "left"
	if direction == "left" and player_walk_frames.has("right"):
		return "right"
	return direction


func _player_move_direction_key_for_vector(vector: Vector2, fallback: String) -> String:
	var valid: Array[String] = ["up", "down", "left", "right"]
	if vector.length_squared() <= 0.0001:
		return fallback if valid.has(fallback) else "down"
	var abs_x: float = absf(vector.x)
	var abs_y: float = absf(vector.y)
	if abs_x > abs_y:
		return "right" if vector.x >= 0.0 else "left"
	return "down" if vector.y >= 0.0 else "up"


func _direction_key_for_vector(vector: Vector2, fallback: String) -> String:
	var valid: Array[String] = ["up", "down", "left", "right"]
	var direction := fallback if valid.has(fallback) else "down"
	if vector.length_squared() <= 0.0001:
		return direction
	var abs_x: float = absf(vector.x)
	var abs_y: float = absf(vector.y)
	if abs(abs_x - abs_y) < PLAYER_DIRECTION_HYSTERESIS:
		return direction
	if abs_x > abs_y:
		return "right" if vector.x >= 0.0 else "left"
	return "down" if vector.y >= 0.0 else "up"


func _as_vec2(value, fallback: Vector2) -> Vector2:
	return value if value is Vector2 else fallback


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
	var visual_scale: float = clamp(float(entity.get("visual_scale", 1.0)), 0.52, 1.18)
	var size := Vector2(68, 84)
	if kind == "player":
		size = Vector2(69, 82)
	elif kind == "boss":
		size = Vector2(128, 148)
	size *= visual_scale

	var root := Control.new()
	root.size = size
	entity_layer.add_child(root)

	var shadow: PanelContainer = null
	if kind == "player":
		var player_shadow_size := Vector2(size.x * 0.5, 12.0)
		shadow = _feedback_circle(player_shadow_size, Color(0.0, 0.0, 0.0, 0.42), Color(0.0, 0.0, 0.0, 0.0), 24, 0)
		shadow.position = Vector2((size.x - player_shadow_size.x) * 0.5, size.y - 24.0)
		root.add_child(shadow)
	else:
		var enemy_shadow_size := Vector2(size.x * 0.48, 10.0)
		shadow = _feedback_circle(enemy_shadow_size, Color(0.0, 0.0, 0.0, 0.34), Color(0.0, 0.0, 0.0, 0.0), 22, 0)
		shadow.position = Vector2((size.x - enemy_shadow_size.x) * 0.5, size.y - 21.0)
		root.add_child(shadow)

	var trail_sprites: Array[TextureRect] = []
	if kind == "player":
		for index in range(2):
			var trail := TextureRect.new()
			trail.texture = textures.get("unit_%d" % data_id)
			trail.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			trail.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			trail.size = Vector2(size.x, size.y - 16)
			trail.pivot_offset = trail.size * 0.5
			trail.visible = false
			root.add_child(trail)
			trail_sprites.append(trail)

	var sprite := TextureRect.new()
	sprite.texture = textures.get("unit_%d" % data_id)
	sprite.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	sprite.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	sprite.size = Vector2(size.x, size.y - 16)
	sprite.pivot_offset = sprite.size * 0.5
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

	var world_position := _as_vec2(entity.get("position", Vector2.ZERO), Vector2.ZERO)
	return {
		"root": root,
		"sprite": sprite,
		"shadow": shadow,
		"base_sprite_size": sprite.size,
		"trail_sprites": trail_sprites,
		"direction": "down",
		"render_world_position": world_position,
		"last_world_position": world_position,
		"walk_phase": float(int(entity.get("runtime_id", 0)) % max(1, ENEMY_WALK_COLUMNS)),
		"hp_bg": hp_bg,
		"hp": hp_fill,
		"hp_width": hp_bg.size.x,
	}


func _clear_entity_views() -> void:
	for view in entity_views.values():
		view["root"].queue_free()
	entity_views.clear()
	for view in boss_telegraph_views.values():
		view.queue_free()
	boss_telegraph_views.clear()
	for label in event_views:
		label.queue_free()
	event_views.clear()


func _world_to_screen(world_position: Vector2, player: Dictionary) -> Vector2:
	var viewport_size := get_viewport_rect().size
	var center := viewport_size * 0.5
	var player_pos := Vector2(1500, 1000)
	if battle_camera_ready:
		player_pos = battle_camera_world_position
	elif not player.is_empty():
		player_pos = _as_vec2(player.get("position", player_pos), player_pos)
	return center + (world_position - player_pos) * BATTLE_WORLD_TO_SCREEN_SCALE


func _sync_wave_segments(progress: float) -> void:
	var clamped: float = clamp(progress, 0.0, 1.0)
	for index in range(wave_segments.size()):
		var segment: ColorRect = wave_segments[index]
		var filled: bool = float(index + 1) / float(max(1, wave_segments.size())) <= clamped + 0.001
		segment.color = Color(0.13, 0.78, 0.72, 0.95) if filled else Color(0.055, 0.09, 0.075, 0.88)
	for index in range(timer_stage_pips.size()):
		var pip: ColorRect = timer_stage_pips[index]
		var filled: bool = float(index + 1) / float(max(1, timer_stage_pips.size())) <= clamped + 0.001
		pip.color = Color(0.11, 0.82, 0.78, 0.96) if filled else Color(0.055, 0.065, 0.055, 0.9)


func _sync_result_panel(snapshot: Dictionary) -> void:
	var won := str(snapshot.get("result", "")) == "clear"
	var wave_count := int(snapshot.get("wave_count", 1))
	var wave := int(snapshot.get("wave", 1))
	var kills := int(snapshot.get("kill_count", 0))
	var elapsed := int(float(snapshot.get("elapsed", 0.0)))

	var hero_texture := textures.get("result_clear_hero" if won else "result_defeat_hero") as Texture2D
	if hero_texture == null:
		hero_texture = textures.get("result_clear_panel" if won else "result_defeat_panel") as Texture2D
	result_status_art.texture = hero_texture
	if result_status_crest != null:
		result_status_crest.texture = textures.get("result_clear_crest" if won else "result_defeat_crest")
	result_kicker_label.text = str(snapshot.get("map_name", "대나무 영지"))
	result_title_label.text = "맵 클리어" if won else "패배"
	if result_stage_badge_label != null:
		result_stage_badge_label.text = "WAVE %d/%d" % [wave, wave_count]
		result_stage_badge_label.add_theme_color_override("font_color", Color(0.18, 0.09, 0.02) if won else Color(1.0, 0.87, 0.68))
		result_stage_badge_label.add_theme_stylebox_override(
			"normal",
			_style(
				Color(1.0, 0.72, 0.18, 0.96) if won else Color(0.49, 0.1, 0.08, 0.96),
				Color(0.36, 0.19, 0.04, 0.96) if won else Color(0.16, 0.05, 0.04, 0.96),
				5,
				2
			)
		)
	result_summary_label.text = "등불이 더 밝아졌습니다. 획득한 자원을 성소에 반영했습니다." if won else "성소로 돌아가 정비가 필요합니다."
	result_kicker_label.add_theme_color_override("font_color", Color(0.98, 0.86, 0.55) if won else Color(0.27, 0.17, 0.11))
	result_title_label.add_theme_color_override("font_color", Color(1.0, 0.78, 0.28) if won else Color(0.48, 0.12, 0.09))
	result_summary_label.add_theme_color_override("font_color", Color(1.0, 0.91, 0.66) if won else Color(0.28, 0.18, 0.1))

	for child in result_stats_box.get_children():
		child.queue_free()
	result_stats_box.add_child(_result_stat_chip("시간", "%02d:%02d" % [int(elapsed / 60.0), elapsed % 60]))
	result_stats_box.add_child(_result_stat_chip("처치", str(kills)))
	result_stats_box.add_child(_result_stat_chip("진행", "%d/%d" % [wave, wave_count]))

	for child in result_rewards_box.get_children():
		child.queue_free()
	var gains: Dictionary = snapshot.get("resource_gains", {})
	var added := 0
	for key in Catalog.RESOURCE_KEYS:
		var amount := int(gains.get(key, 0))
		if amount <= 0:
			continue
		result_rewards_box.add_child(_result_reward_row(key, amount))
		added += 1
	if added == 0:
		var empty := Label.new()
		empty.text = "이번 전투에서 기록된 보상이 없습니다."
		empty.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		empty.add_theme_font_size_override("font_size", 13)
		empty.add_theme_color_override("font_color", Color(0.3, 0.24, 0.16))
		result_rewards_box.add_child(empty)


func _result_stat_chip(label_text: String, value_text: String) -> PanelContainer:
	var chip := _battle_panel(Color(0.18, 0.13, 0.07, 0.9), Color(0.52, 0.36, 0.16, 0.9), 8, Vector2(92, 45))
	var box := VBoxContainer.new()
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	chip.add_child(box)

	var label := Label.new()
	label.text = label_text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 10)
	label.add_theme_color_override("font_color", Color(0.92, 0.78, 0.52))
	box.add_child(label)

	var value := Label.new()
	value.text = value_text
	value.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	value.add_theme_font_size_override("font_size", 15)
	value.add_theme_color_override("font_color", Color(1.0, 0.94, 0.72))
	box.add_child(value)
	return chip


func _result_reward_row(resource_key: String, amount: int) -> PanelContainer:
	var row := _battle_panel(Color(0.98, 0.87, 0.58, 0.82), Color(0.47, 0.31, 0.13, 0.74), 8, Vector2(330, 40))
	var h := HBoxContainer.new()
	h.add_theme_constant_override("separation", 8)
	row.add_child(h)

	var icon := TextureRect.new()
	icon.texture = textures.get("res_%s" % resource_key)
	icon.custom_minimum_size = Vector2(28, 28)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	h.add_child(icon)

	var label := Label.new()
	label.text = Catalog.RESOURCE_LABELS.get(resource_key, resource_key)
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.add_theme_font_size_override("font_size", 14)
	label.add_theme_color_override("font_color", Color(0.18, 0.12, 0.06))
	h.add_child(label)

	var value := Label.new()
	value.text = "+%d" % amount
	value.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	value.add_theme_font_size_override("font_size", 16)
	value.add_theme_color_override("font_color", Color(0.1, 0.08, 0.04))
	h.add_child(value)
	return row


func _battle_profile_hud() -> Control:
	var root := Control.new()
	root.custom_minimum_size = Vector2(190, 78)
	root.size = root.custom_minimum_size
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var hp_frame := PanelContainer.new()
	hp_frame.position = Vector2(59, 12)
	hp_frame.size = Vector2(128, 25)
	hp_frame.custom_minimum_size = hp_frame.size
	hp_frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hp_frame.add_theme_stylebox_override("panel", _hud_style(Color(0.045, 0.03, 0.028, 0.98), Color(0.08, 0.065, 0.045, 0.98), 5, 3, Color(0.68, 0.49, 0.22, 0.98)))
	root.add_child(hp_frame)

	hp_bar = ProgressBar.new()
	hp_bar.show_percentage = false
	hp_bar.max_value = 1.0
	hp_bar.value = 1.0
	hp_bar.position = Vector2(65, 18)
	hp_bar.size = Vector2(116, 13)
	hp_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hp_bar.add_theme_stylebox_override("background", _style(Color(0.05, 0.022, 0.018, 0.96), Color(0.0, 0.0, 0.0, 0.0), 3, 0))
	hp_bar.add_theme_stylebox_override("fill", _style(Color(0.8, 0.12, 0.1, 0.98), Color(1.0, 0.62, 0.34, 0.5), 3, 1))
	root.add_child(hp_bar)

	profile_hp_label = Label.new()
	profile_hp_label.text = "512 / 512"
	profile_hp_label.position = Vector2(72, 13)
	profile_hp_label.size = Vector2(104, 24)
	profile_hp_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	profile_hp_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	profile_hp_label.add_theme_font_size_override("font_size", 11)
	profile_hp_label.add_theme_color_override("font_color", Color(0.98, 0.9, 0.76))
	profile_hp_label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.76))
	profile_hp_label.add_theme_constant_override("shadow_offset_x", 1)
	profile_hp_label.add_theme_constant_override("shadow_offset_y", 1)
	root.add_child(profile_hp_label)

	var portrait_frame := PanelContainer.new()
	portrait_frame.position = Vector2(0, 0)
	portrait_frame.size = Vector2(67, 67)
	portrait_frame.custom_minimum_size = portrait_frame.size
	portrait_frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	portrait_frame.add_theme_stylebox_override("panel", _hud_style(Color(0.12, 0.085, 0.045, 0.98), Color(0.07, 0.055, 0.035, 1.0), 13, 4, Color(0.74, 0.52, 0.22, 1.0)))
	root.add_child(portrait_frame)

	var portrait := TextureRect.new()
	portrait.texture = _cropped_scaled_texture(textures.get("profile"), Rect2i(0, 0, 190, 182), Vector2i(58, 58))
	portrait.position = Vector2(4, 4)
	portrait.size = Vector2(58, 58)
	portrait.custom_minimum_size = portrait.size
	portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	portrait.stretch_mode = TextureRect.STRETCH_SCALE
	portrait.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(portrait)

	var level_badge := PanelContainer.new()
	level_badge.position = Vector2(50, 50)
	level_badge.size = Vector2(30, 30)
	level_badge.custom_minimum_size = level_badge.size
	level_badge.mouse_filter = Control.MOUSE_FILTER_IGNORE
	level_badge.add_theme_stylebox_override("panel", _hud_style(Color(0.035, 0.035, 0.03, 0.98), Color(0.07, 0.06, 0.04, 1.0), 7, 3, Color(0.76, 0.55, 0.25, 0.96)))
	root.add_child(level_badge)

	profile_level_label = Label.new()
	profile_level_label.text = "1"
	profile_level_label.set_anchors_preset(Control.PRESET_FULL_RECT)
	profile_level_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	profile_level_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	profile_level_label.add_theme_font_size_override("font_size", 16)
	profile_level_label.add_theme_color_override("font_color", Color(1.0, 0.92, 0.72))
	profile_level_label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.78))
	profile_level_label.add_theme_constant_override("shadow_offset_x", 1)
	profile_level_label.add_theme_constant_override("shadow_offset_y", 1)
	level_badge.add_child(profile_level_label)

	return root


func _hud_panel(bg: Color, border: Color, radius: int, min_size := Vector2.ZERO, border_width := 3, content_insets := Vector4(8, 5, 8, 5), accent := Color(0.62, 0.48, 0.24, 0.94)) -> PanelContainer:
	var panel := PanelContainer.new()
	var style := _hud_style(bg, border, radius, border_width, accent)
	style.content_margin_left = content_insets.x
	style.content_margin_top = content_insets.y
	style.content_margin_right = content_insets.z
	style.content_margin_bottom = content_insets.w
	panel.add_theme_stylebox_override("panel", style)
	if min_size != Vector2.ZERO:
		panel.custom_minimum_size = min_size
	return panel


func _hud_style(bg: Color, border: Color, radius := 6, border_width := 3, accent := Color(0.62, 0.48, 0.24, 0.94)) -> StyleBoxFlat:
	var style := _style(bg, accent, radius, border_width)
	style.border_color = accent
	style.shadow_color = Color(0.0, 0.0, 0.0, 0.5)
	style.shadow_size = 5
	style.shadow_offset = Vector2(0, 2)
	style.expand_margin_left = 1
	style.expand_margin_right = 1
	style.expand_margin_top = 1
	style.expand_margin_bottom = 2
	return style


func _add_hud_diamond(parent: Control, position: Vector2, filled: bool, fill_color: Color) -> ColorRect:
	var outer := ColorRect.new()
	outer.position = position
	outer.size = Vector2(12, 12)
	outer.pivot_offset = outer.size * 0.5
	outer.rotation = PI * 0.25
	outer.color = Color(0.02, 0.022, 0.018, 0.96)
	outer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(outer)

	var inner := ColorRect.new()
	inner.position = Vector2(2, 2)
	inner.size = Vector2(8, 8)
	inner.color = fill_color if filled else Color(0.055, 0.065, 0.055, 0.9)
	inner.mouse_filter = Control.MOUSE_FILTER_IGNORE
	outer.add_child(inner)
	return inner


func _battle_panel(bg: Color, border: Color, radius: int, min_size := Vector2.ZERO) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", _style(bg, border, radius))
	if min_size != Vector2.ZERO:
		panel.custom_minimum_size = min_size
	return panel


func _compact_battle_panel(bg: Color, border: Color, radius: int, min_size := Vector2.ZERO, border_width := 1, content_insets := Vector4(8, 5, 8, 5)) -> PanelContainer:
	var panel := PanelContainer.new()
	var style := _style(bg, border, radius, border_width)
	style.content_margin_left = content_insets.x
	style.content_margin_top = content_insets.y
	style.content_margin_right = content_insets.z
	style.content_margin_bottom = content_insets.w
	panel.add_theme_stylebox_override("panel", style)
	if min_size != Vector2.ZERO:
		panel.custom_minimum_size = min_size
	return panel


func _battle_counter_chip(icon_key: String, text: String) -> Label:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 2)

	var icon := TextureRect.new()
	icon.texture = textures.get(icon_key)
	icon.custom_minimum_size = Vector2(14, 14)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	row.add_child(icon)

	var label := _battle_stat_label(text)
	label.add_theme_font_size_override("font_size", 10)
	row.add_child(label)
	return label


func _build_profile_skill_row(parent: HBoxContainer) -> void:
	skill_cooldown_labels.clear()
	var icon_keys: Array[String] = ["skill", "skill_shuriken", "skill_smoke"]
	var index := 0
	for skill_id in Catalog.STARTER_SKILL_IDS:
		var icon_key: String = icon_keys[index] if index < icon_keys.size() else "skill"
		_add_profile_skill_chip(parent, int(skill_id), icon_key)
		index += 1


func _add_profile_skill_chip(parent: HBoxContainer, skill_id: int, texture_key: String) -> void:
	var chip := HBoxContainer.new()
	chip.add_theme_constant_override("separation", 1)
	parent.add_child(chip)

	var icon := TextureRect.new()
	icon.texture = textures.get(texture_key)
	icon.custom_minimum_size = Vector2(14, 14)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	chip.add_child(icon)

	var label := Label.new()
	label.text = ""
	label.custom_minimum_size = Vector2(14, 0)
	label.visible = false
	label.add_theme_font_size_override("font_size", 8)
	label.add_theme_color_override("font_color", Color(0.86, 0.94, 0.78))
	chip.add_child(label)


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


func _battle_resource_chip(resource_key: String) -> PanelContainer:
	var chip := _compact_battle_panel(Color(0.055, 0.07, 0.052, 0.86), Color(0.54, 0.41, 0.2, 0.8), 6, Vector2(112, 18), 1, Vector4(5, 2, 5, 2))
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 4)
	chip.add_child(row)

	var icon := TextureRect.new()
	icon.texture = textures.get("res_%s" % resource_key)
	icon.custom_minimum_size = Vector2(13, 13)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	row.add_child(icon)
	var label := _battle_stat_label("0")
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.add_theme_font_size_override("font_size", 10)
	row.add_child(label)
	battle_resource_labels[resource_key] = label

	var gain := Label.new()
	gain.custom_minimum_size = Vector2(26, 0)
	gain.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	gain.add_theme_font_size_override("font_size", 9)
	gain.add_theme_color_override("font_color", Color(0.55, 1.0, 0.85))
	row.add_child(gain)
	battle_gain_labels[resource_key] = gain
	return chip


func _battle_stat_label(text: String) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 11)
	label.add_theme_color_override("font_color", Color(0.96, 0.91, 0.76))
	return label


func _add_battle_control_scrim() -> void:
	var scrim := ColorRect.new()
	scrim.color = Color(0.012, 0.025, 0.018, 0.28)
	scrim.anchor_left = 0.0
	scrim.anchor_top = 1.0
	scrim.anchor_right = 1.0
	scrim.anchor_bottom = 1.0
	scrim.offset_left = 0
	scrim.offset_top = -286
	scrim.offset_right = 0
	scrim.offset_bottom = 0
	battle_screen.add_child(scrim)


func _add_bottom_battle_depth() -> void:
	var shade := ColorRect.new()
	shade.color = Color(0.018, 0.043, 0.03, 0.14)
	shade.anchor_left = 0.0
	shade.anchor_top = 1.0
	shade.anchor_right = 1.0
	shade.anchor_bottom = 1.0
	shade.offset_left = 0
	shade.offset_top = -292
	shade.offset_right = 0
	shade.offset_bottom = 0
	world_layer.add_child(shade)


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


func _build_skill_bar(parent: HBoxContainer) -> void:
	skill_cooldown_labels.clear()
	for skill_id in Catalog.STARTER_SKILL_IDS:
		var skill_def: Dictionary = store.get_skill(int(skill_id))
		var label_text := str(skill_def.get("name", "Skill"))
		_add_skill_chip(parent, int(skill_id), "skill", label_text)
	_add_skill_chip(parent, -1, "dash", "회피")


func _sync_skill_bar(skill_slots: Array) -> void:
	var live_skill_ids := {}
	for slot in skill_slots:
		if typeof(slot) != TYPE_DICTIONARY:
			continue
		var skill_id := int(slot.get("skill_id", 0))
		live_skill_ids[skill_id] = true
		var timer := float(slot.get("timer", 0.0))
		if skill_cooldown_labels.has(skill_id):
			var label: Label = skill_cooldown_labels[skill_id]
			label.text = "%.0f" % ceil(timer) if timer > 0.05 else ""
		if battle_action_labels.has(skill_id):
			var action_label: Label = battle_action_labels[skill_id]
			_set_action_badge_text(action_label, "%.1f" % timer if timer > 0.05 else "")
			action_label.add_theme_color_override("font_color", Color(0.74, 0.86, 0.8) if timer > 0.05 else Color(1.0, 0.9, 0.68))
	for skill_id in battle_action_skill_panels.keys():
		var panel := battle_action_skill_panels[skill_id] as Control
		if panel != null:
			panel.visible = live_skill_ids.has(skill_id)


func _add_skill_chip(parent: HBoxContainer, skill_id: int, texture_key: String, label_text: String) -> void:
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
	if skill_id > 0:
		skill_cooldown_labels[skill_id] = label


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
	var path: String = store.runtime_asset_path(relative_path)
	var err := image.load(path)
	if err != OK:
		push_warning("Missing ninja2 texture: %s" % path)
		return null
	return ImageTexture.create_from_image(image)


func _scaled_texture(source: Texture2D, target_size: Vector2i) -> Texture2D:
	if source == null:
		return null
	var image := source.get_image()
	if image == null or image.is_empty():
		return source
	image.resize(target_size.x, target_size.y, Image.INTERPOLATE_LANCZOS)
	return ImageTexture.create_from_image(image)


func _cropped_scaled_texture(source: Texture2D, crop_rect: Rect2i, target_size: Vector2i) -> Texture2D:
	if source == null:
		return null
	var image := source.get_image()
	if image == null or image.is_empty():
		return source
	var bounded_position := Vector2i(
		clamp(crop_rect.position.x, 0, max(0, image.get_width() - 1)),
		clamp(crop_rect.position.y, 0, max(0, image.get_height() - 1))
	)
	var bounded_size := Vector2i(
		min(crop_rect.size.x, image.get_width() - bounded_position.x),
		min(crop_rect.size.y, image.get_height() - bounded_position.y)
	)
	var region := image.get_region(Rect2i(bounded_position, bounded_size))
	region.resize(target_size.x, target_size.y, Image.INTERPOLATE_LANCZOS)
	return ImageTexture.create_from_image(region)


func _style(bg: Color, border: Color, radius := 6, border_width := 1) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = bg
	style.border_color = border
	style.border_width_left = border_width
	style.border_width_right = border_width
	style.border_width_top = border_width
	style.border_width_bottom = border_width
	style.corner_radius_top_left = radius
	style.corner_radius_top_right = radius
	style.corner_radius_bottom_left = radius
	style.corner_radius_bottom_right = radius
	style.content_margin_left = 10
	style.content_margin_right = 10
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	return style


func _feedback_circle(size: Vector2, bg: Color, border: Color, radius := 64, border_width := 1) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.size = size
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var style := _style(bg, border, radius)
	style.border_width_left = border_width
	style.border_width_right = border_width
	style.border_width_top = border_width
	style.border_width_bottom = border_width
	style.content_margin_left = 0
	style.content_margin_right = 0
	style.content_margin_top = 0
	style.content_margin_bottom = 0
	panel.add_theme_stylebox_override("panel", style)
	return panel


func _title_button(text: String) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(0, 58)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.add_theme_font_size_override("font_size", 18)
	return button
