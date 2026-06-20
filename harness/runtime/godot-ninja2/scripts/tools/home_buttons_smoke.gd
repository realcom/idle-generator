extends SceneTree

const ContentStore := preload("res://scripts/content_store.gd")
const HousingTechStore := preload("res://scripts/home/housing_tech_store.gd")
const SanctuaryState := preload("res://scripts/home/sanctuary_state.gd")
const HomeScreen := preload("res://scripts/home/home_screen.gd")
const QuickViewModal := preload("res://scripts/home/modals/quick_view_modal.gd")
const MainMenuModal := preload("res://scripts/home/modals/main_menu_modal.gd")
const SettingsModal := preload("res://scripts/home/modals/settings_modal.gd")


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var store = ContentStore.new()
	if not store.load_all():
		_fail("content data failed: %s" % "; ".join(store.errors))
		return

	var housing = HousingTechStore.new()
	if not housing.load_all():
		_fail("housing data failed: %s" % "; ".join(housing.errors))
		return

	var sanctuary = SanctuaryState.new()
	sanctuary.seed_from_housing(housing)
	sanctuary.ensure_starter_equipment(store)

	var home = HomeScreen.new()
	get_root().add_child(home)
	await process_frame
	home.setup(store, housing, sanctuary, {})

	var counters := {"sortie": 0, "title": 0}
	home.sortie_requested.connect(func(_map_id: int): counters["sortie"] = int(counters["sortie"]) + 1)
	home.title_requested.connect(func(): counters["title"] = int(counters["title"]) + 1)

	sanctuary.select_building("training_yard#1")
	home.sync_state()
	var start_level := sanctuary.selected_building_level()
	home.building_panel.action_button.emit_signal("pressed")
	if sanctuary.selected_building_level() != start_level + 1:
		_fail("building panel action did not upgrade selected building")
		return

	_press_button(home, "메뉴")
	if not home.modal_layer.current_modal() is MainMenuModal:
		_fail("top menu button did not open main menu modal")
		return

	home._handle_tab_modal_action("open_tab", {"tab_key": "equipment"})
	if home.active_tab != "equipment":
		_fail("menu equipment action did not switch tab")
		return

	_press_button(home, "우편")
	var modal = home.modal_layer.current_modal()
	if not modal is QuickViewModal or str(modal.view_key) != "mail":
		_fail("mail side button did not open mail quick view")
		return

	_press_button(home, "가방")
	modal = home.modal_layer.current_modal()
	if not modal is QuickViewModal or str(modal.view_key) != "bag":
		_fail("bag side button did not open bag quick view")
		return
	var wood_before := int(sanctuary.resources.get("wood", 0))
	modal.primary_button.emit_signal("pressed")
	if int(sanctuary.resources.get("wood", 0)) <= wood_before:
		_fail("bag collect action did not grant idle resources")
		return

	_press_button(home, "패스")
	modal = home.modal_layer.current_modal()
	if not modal is QuickViewModal or str(modal.view_key) != "pass":
		_fail("pass side button did not open pass quick view")
		return
	modal.primary_button.emit_signal("pressed")
	if sanctuary.pass_claimed_tiers.is_empty():
		_fail("pass primary action did not claim a tier")
		return

	_press_button(home, "설정")
	modal = home.modal_layer.current_modal()
	if not modal is SettingsModal:
		_fail("settings button did not open settings modal")
		return
	var bgm_before := bool(sanctuary.settings.get("bgm", false))
	modal._toggle_setting("bgm")
	if bool(sanctuary.settings.get("bgm", false)) == bgm_before:
		_fail("settings toggle did not change state")
		return

	home._handle_tab_modal_action("return_title", {})
	if int(counters["title"]) != 1:
		_fail("return title action did not emit title signal")
		return

	home.sortie_button.emit_signal("pressed")
	if int(counters["sortie"]) != 1:
		_fail("sortie button did not emit sortie signal")
		return

	print("godot-ninja2 home buttons smoke ok: tab=%s pass=%d title=%d sortie=%d" % [
		home.active_tab,
		sanctuary.pass_claimed_tiers.size(),
		int(counters["title"]),
		int(counters["sortie"]),
	])
	quit(0)


func _press_button(root: Node, tooltip: String) -> void:
	var button := _find_button(root, tooltip)
	if button == null:
		_fail("missing button: %s" % tooltip)
		return
	button.emit_signal("pressed")


func _find_button(root: Node, tooltip: String) -> Button:
	for child in root.get_children():
		if child is Button and str(child.tooltip_text) == tooltip:
			return child
		var nested := _find_button(child, tooltip)
		if nested != null:
			return nested
	return null


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
