extends Control

signal sortie_requested(map_id: int)
signal title_requested
signal reload_requested
signal state_changed

const HomeTheme := preload("res://scripts/home/components/home_theme.gd")
const HomeTopBar := preload("res://scripts/home/components/home_top_bar.gd")
const HomeSideMenu := preload("res://scripts/home/components/home_side_menu.gd")
const SanctuaryBoard := preload("res://scripts/home/components/sanctuary_board.gd")
const HomeBuildingPanel := preload("res://scripts/home/components/home_building_panel.gd")
const HomeBottomTabs := preload("res://scripts/home/components/home_bottom_tabs.gd")
const HomeTabContent := preload("res://scripts/home/components/home_tab_content.gd")
const ModalLayer := preload("res://scripts/home/components/modal_layer.gd")
const BuildingDetailModal := preload("res://scripts/home/modals/building_detail_modal.gd")
const SanctuaryTabModal := preload("res://scripts/home/modals/sanctuary_tab_modal.gd")
const EquipmentTabModal := preload("res://scripts/home/modals/equipment_tab_modal.gd")
const EquipmentDetailModal := preload("res://scripts/home/modals/equipment_detail_modal.gd")
const ExplorationTabModal := preload("res://scripts/home/modals/exploration_tab_modal.gd")
const MissionTabModal := preload("res://scripts/home/modals/mission_tab_modal.gd")
const ShopTabModal := preload("res://scripts/home/modals/shop_tab_modal.gd")
const QuickViewModal := preload("res://scripts/home/modals/quick_view_modal.gd")
const MainMenuModal := preload("res://scripts/home/modals/main_menu_modal.gd")
const SettingsModal := preload("res://scripts/home/modals/settings_modal.gd")
const BASE_SIZE := Vector2(440, 782)

var store
var housing
var sanctuary
var textures: Dictionary = {}

var shell: Control
var outer_bg: TextureRect
var top_bar
var side_rail: PanelContainer
var side_menu
var board
var building_panel
var tab_content
var bottom_tabs
var modal_layer
var sortie_button: Button
var sortie_stage_label: Label
var log_label: Label
var active_tab := "sanctuary"
var built := false


func setup(content_store, housing_store, sanctuary_state, texture_table: Dictionary) -> void:
	store = content_store
	housing = housing_store
	sanctuary = sanctuary_state
	textures = texture_table
	if sanctuary != null and store != null:
		sanctuary.ensure_starter_equipment(store)
	if not built:
		_build()
		built = true
	sync_state()


func selected_main_map_id() -> int:
	return int(sanctuary.current_map_id) if sanctuary != null else 500101


func set_status_message(message: String) -> void:
	if sanctuary != null:
		sanctuary.last_log = message
	sync_state()


func sync_state() -> void:
	if not built or sanctuary == null:
		return

	if top_bar != null:
		top_bar.sync_state()
	if board != null:
		board.sync_state()
	if building_panel != null:
		building_panel.visible = active_tab == "sanctuary"
		building_panel.sync_state()
	if tab_content != null:
		tab_content.sync_state(active_tab)
	if bottom_tabs != null:
		bottom_tabs.sync_active(active_tab)
	if modal_layer != null:
		modal_layer.sync_current_modal()
	if log_label != null:
		log_label.text = str(sanctuary.last_log)
	if sortie_stage_label != null:
		sortie_stage_label.text = sanctuary.stage_label()


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		_layout_shell()


func _build() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)

	var outer_base := ColorRect.new()
	outer_base.set_anchors_preset(Control.PRESET_FULL_RECT)
	outer_base.color = Color(0.03, 0.10, 0.065, 1.0)
	add_child(outer_base)

	outer_bg = TextureRect.new()
	outer_bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	outer_bg.texture = _texture("home_bg")
	outer_bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	outer_bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	outer_bg.modulate = Color(0.62, 0.72, 0.62, 1.0)
	add_child(outer_bg)

	var outer_vignette := ColorRect.new()
	outer_vignette.set_anchors_preset(Control.PRESET_FULL_RECT)
	outer_vignette.color = Color(0.02, 0.045, 0.03, 0.58)
	add_child(outer_vignette)

	shell = Control.new()
	shell.size = BASE_SIZE
	shell.clip_contents = true
	add_child(shell)

	_build_background()
	_build_board()
	_build_top_bar()
	_build_side_menu()
	_build_log()
	_build_building_panel()
	_build_tab_content()
	_build_sortie_button()
	_build_tabs()
	_build_modal_layer()
	_layout_shell()


func _layout_shell() -> void:
	if shell == null:
		return
	var viewport_size := get_viewport_rect().size
	var scale_value: float = max(viewport_size.x / BASE_SIZE.x, viewport_size.y / BASE_SIZE.y)
	scale_value = min(scale_value, 1.35)
	shell.scale = Vector2(scale_value, scale_value)
	var scaled_size := BASE_SIZE * scale_value
	shell.position = Vector2(
		floor((viewport_size.x - scaled_size.x) * 0.5),
		floor((viewport_size.y - scaled_size.y) * 0.5)
	)
	shell.size = BASE_SIZE


func _build_background() -> void:
	var bg := TextureRect.new()
	bg.texture = _texture("home_bg")
	bg.position = Vector2.ZERO
	bg.size = BASE_SIZE
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	shell.add_child(bg)

	var vignette := ColorRect.new()
	vignette.color = Color(0.03, 0.09, 0.055, 0.20)
	vignette.position = Vector2.ZERO
	vignette.size = BASE_SIZE
	shell.add_child(vignette)


func _build_top_bar() -> void:
	top_bar = HomeTopBar.new()
	shell.add_child(top_bar)
	top_bar.setup(store, sanctuary, textures)
	top_bar.menu_requested.connect(_open_main_menu_modal)
	top_bar.settings_requested.connect(_open_settings_modal)


func _build_side_menu() -> void:
	side_rail = PanelContainer.new()
	side_rail.position = Vector2(4, 182)
	side_rail.size = Vector2(60, 174)
	side_rail.add_theme_stylebox_override("panel", HomeTheme.style(Color(0.03, 0.12, 0.08, 0.58), Color(0.02, 0.05, 0.03, 0.50), 16, 1))
	shell.add_child(side_rail)

	side_menu = HomeSideMenu.new()
	shell.add_child(side_menu)
	side_menu.setup(textures)
	side_menu.quick_requested.connect(_open_quick_modal)


func _build_board() -> void:
	board = SanctuaryBoard.new()
	shell.add_child(board)
	board.setup(housing, sanctuary, textures)
	board.building_selected.connect(_select_building)


func _build_log() -> void:
	var panel := PanelContainer.new()
	panel.position = Vector2(26, 558)
	panel.size = Vector2(388, 28)
	panel.add_theme_stylebox_override("panel", HomeTheme.style(Color(0.05, 0.08, 0.05, 0.72), Color(0.56, 0.48, 0.28, 0.36), 8, 1))
	shell.add_child(panel)

	log_label = Label.new()
	log_label.position = Vector2(10, 3)
	log_label.size = Vector2(368, 22)
	log_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	log_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	log_label.add_theme_font_size_override("font_size", 10)
	log_label.add_theme_color_override("font_color", Color(0.98, 0.92, 0.72))
	panel.add_child(log_label)


func _build_building_panel() -> void:
	building_panel = HomeBuildingPanel.new()
	shell.add_child(building_panel)
	building_panel.setup(housing, sanctuary, textures)
	building_panel.details_requested.connect(_open_building_detail_modal)
	building_panel.action_requested.connect(_request_building_upgrade)


func _build_tab_content() -> void:
	tab_content = HomeTabContent.new()
	shell.add_child(tab_content)
	tab_content.setup(store, housing, sanctuary, textures)
	tab_content.sortie_requested.connect(_request_sortie)


func _build_sortie_button() -> void:
	var sortie_size := Vector2(108, 108)
	var sortie_position := Vector2(326, 591)

	var bg := TextureRect.new()
	bg.texture = HomeTheme.scaled_texture(_texture("home_button_sortie"), Vector2i(int(sortie_size.x), int(sortie_size.y)))
	bg.position = sortie_position
	bg.size = sortie_size
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.stretch_mode = TextureRect.STRETCH_SCALE
	shell.add_child(bg)

	sortie_button = Button.new()
	sortie_button.position = sortie_position + Vector2(11, 18)
	sortie_button.size = Vector2(86, 70)
	sortie_button.flat = true
	sortie_button.focus_mode = Control.FOCUS_NONE
	sortie_button.pressed.connect(_request_sortie)
	shell.add_child(sortie_button)

	var label := Label.new()
	label.text = "출전"
	label.position = sortie_position + Vector2(17, 39)
	label.size = Vector2(74, 24)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 18)
	label.add_theme_color_override("font_color", Color(1.0, 0.96, 0.78))
	shell.add_child(label)

	sortie_stage_label = Label.new()
	sortie_stage_label.position = sortie_position + Vector2(27, 64)
	sortie_stage_label.size = Vector2(54, 16)
	sortie_stage_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sortie_stage_label.add_theme_font_size_override("font_size", 11)
	sortie_stage_label.add_theme_color_override("font_color", Color(0.20, 0.09, 0.04))
	shell.add_child(sortie_stage_label)


func _build_tabs() -> void:
	bottom_tabs = HomeBottomTabs.new()
	shell.add_child(bottom_tabs)
	bottom_tabs.setup(textures)
	bottom_tabs.tab_selected.connect(_select_tab)


func _build_modal_layer() -> void:
	modal_layer = ModalLayer.new()
	shell.add_child(modal_layer)
	modal_layer.setup(BASE_SIZE)
	modal_layer.modal_closed.connect(sync_state)


func _select_tab(tab_key: String) -> void:
	active_tab = tab_key
	if sanctuary == null:
		return

	match tab_key:
		"sanctuary":
			sanctuary.last_log = "건물 선택 후 강화하거나 상세 정보를 확인하세요."
		"equipment":
			sanctuary.last_log = "장비 슬롯과 보유 장비를 확인하세요."
		"exploration":
			sanctuary.last_log = "%s 탐험 준비 상태를 확인하세요." % _current_map_name()
		"missions":
			sanctuary.last_log = "임무 진행도와 받을 보상을 확인하세요."
		"shop":
			sanctuary.last_log = "상점 보급품과 성장 패키지를 확인하세요."
		_:
			sanctuary.last_log = ""
	sync_state()
	_open_tab_modal(tab_key)


func _select_building(instance_id: String) -> void:
	if sanctuary == null:
		return
	sanctuary.select_building(instance_id)
	active_tab = "sanctuary"
	sync_state()


func _open_building_detail_modal(_instance_id: String) -> void:
	if sanctuary == null or housing == null:
		return
	if _instance_id != "":
		sanctuary.select_building(_instance_id)
	var modal = BuildingDetailModal.new()
	modal.setup(housing, sanctuary, textures)
	modal.building_action_requested.connect(_request_building_upgrade)
	modal_layer.open_modal(modal)


func _open_tab_modal(tab_key: String) -> void:
	if modal_layer == null:
		return
	if modal_layer.has_open_modal():
		modal_layer.close_all()

	var modal = null
	match tab_key:
		"sanctuary":
			modal = SanctuaryTabModal.new()
			modal.setup(store, housing, sanctuary, textures)
		"equipment":
			modal = EquipmentTabModal.new()
			modal.setup(store, housing, sanctuary, textures)
		"exploration":
			modal = ExplorationTabModal.new()
			modal.setup(store, housing, sanctuary, textures)
		"missions":
			modal = MissionTabModal.new()
			modal.setup(store, housing, sanctuary, textures)
		"shop":
			modal = ShopTabModal.new()
			modal.setup(store, housing, sanctuary, textures)
		_:
			return
	if modal.has_signal("modal_action_requested"):
		modal.modal_action_requested.connect(_handle_tab_modal_action)
	modal_layer.open_modal(modal)


func _open_quick_modal(requested_view_key: String) -> void:
	if modal_layer == null or sanctuary == null:
		return
	if modal_layer.has_open_modal():
		modal_layer.close_all()
	var modal = QuickViewModal.new()
	modal.setup(store, housing, sanctuary, textures, requested_view_key)
	modal.modal_action_requested.connect(_handle_tab_modal_action)
	modal_layer.open_modal(modal)
	sanctuary.last_log = "%s 패널을 열었습니다." % _quick_view_title(requested_view_key)
	sync_state()


func _open_main_menu_modal() -> void:
	if modal_layer == null or sanctuary == null:
		return
	if modal_layer.has_open_modal():
		modal_layer.close_all()
	var modal = MainMenuModal.new()
	modal.setup(store, housing, sanctuary, textures)
	modal.modal_action_requested.connect(_handle_tab_modal_action)
	modal_layer.open_modal(modal)
	sanctuary.last_log = "메뉴 패널을 열었습니다."
	sync_state()


func _open_settings_modal() -> void:
	if modal_layer == null or sanctuary == null:
		return
	if modal_layer.has_open_modal():
		modal_layer.close_all()
	var modal = SettingsModal.new()
	modal.setup(store, housing, sanctuary, textures)
	modal.modal_action_requested.connect(_handle_tab_modal_action)
	modal_layer.open_modal(modal)
	sanctuary.last_log = "설정 패널을 열었습니다."
	sync_state()


func _open_equipment_detail_modal(item_id: int) -> void:
	if store == null or sanctuary == null:
		return
	var modal = EquipmentDetailModal.new()
	modal.setup(store, sanctuary, textures, int(item_id))
	modal.modal_action_requested.connect(_handle_tab_modal_action)
	modal_layer.open_modal(modal)


func _handle_tab_modal_action(action: String, payload: Dictionary) -> void:
	if sanctuary == null:
		return
	match action:
		"building_detail":
			_open_building_detail_modal(str(payload.get("instance_id", "")))
		"select_equipment":
			sanctuary.selected_equipment_item_id = int(payload.get("item_id", 0))
			sanctuary.last_log = "장비 상세를 확인할 항목을 선택했습니다."
		"equipment_detail":
			sanctuary.selected_equipment_item_id = int(payload.get("item_id", 0))
			_open_equipment_detail_modal(int(payload.get("item_id", 0)))
		"equip_item":
			sanctuary.try_equip_item(store, int(payload.get("item_id", 0)))
		"select_map":
			sanctuary.select_map(int(payload.get("map_id", selected_main_map_id())), store)
		"sortie_map":
			var map_id := int(payload.get("map_id", selected_main_map_id()))
			var result: Dictionary = sanctuary.select_map(map_id, store)
			if bool(result.get("ok", false)):
				if modal_layer != null:
					modal_layer.close_all()
				sortie_requested.emit(map_id)
				return
		"claim_mission":
			sanctuary.try_claim_mission(store, int(payload.get("achievement_id", 0)))
		"buy_product":
			sanctuary.try_claim_shop_product(store, int(payload.get("product_id", 0)))
		"home_state_changed":
			state_changed.emit()
		"open_tab":
			_select_tab(str(payload.get("tab_key", "sanctuary")))
			return
		"open_quick":
			_open_quick_modal(str(payload.get("view_key", "mail")))
			return
		"open_settings":
			_open_settings_modal()
			return
		"return_title":
			if modal_layer != null:
				modal_layer.close_all()
			_request_title()
			return
	sync_state()


func _request_building_upgrade(_instance_id: String, _action: String) -> void:
	if sanctuary == null or housing == null:
		return
	sanctuary.try_upgrade_selected(housing)
	sync_state()


func _request_sortie() -> void:
	sortie_requested.emit(selected_main_map_id())


func _request_title() -> void:
	title_requested.emit()


func _current_map_name() -> String:
	if store == null or sanctuary == null:
		return "대나무 영지"
	var map_def: Dictionary = store.get_map(int(sanctuary.current_map_id))
	return str(map_def.get("name", "대나무 영지"))


func _quick_view_title(requested_view_key: String) -> String:
	var titles := {"mail": "우편", "bag": "가방", "pass": "패스"}
	return str(titles.get(requested_view_key, "우편"))


func _texture(key: String) -> Texture2D:
	return textures.get(key)
