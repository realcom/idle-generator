extends SceneTree

const HousingTechStore := preload("res://scripts/home/housing_tech_store.gd")
const SanctuaryState := preload("res://scripts/home/sanctuary_state.gd")


func _init() -> void:
	var housing = HousingTechStore.new()
	if not housing.load_all():
		_fail("housing data failed: %s" % "; ".join(housing.errors))
		return

	var sanctuary = SanctuaryState.new()
	sanctuary.seed_from_housing(housing)

	sanctuary.select_building("training_yard#1")
	var start_level := sanctuary.selected_building_level()
	var start_gold := int(sanctuary.resources.get("gold", 0))
	var result: Dictionary = sanctuary.try_upgrade_selected(housing)
	if not bool(result.get("ok", false)):
		_fail("training yard upgrade failed: %s" % str(result.get("message", "")))
		return
	if sanctuary.selected_building_level() != start_level + 1:
		_fail("training yard level did not increase")
		return
	if int(sanctuary.resources.get("gold", 0)) >= start_gold:
		_fail("upgrade did not consume gold")
		return
	var training_level_after := sanctuary.selected_building_level()

	sanctuary.select_building("stone_quarry#1")
	var finish_result: Dictionary = sanctuary.try_upgrade_selected(housing)
	if not bool(finish_result.get("ok", false)):
		_fail("construction finish failed: %s" % str(finish_result.get("message", "")))
		return
	if sanctuary.selected_building_status() != "built":
		_fail("construction status did not become built")
		return

	print("godot-ninja2 home smoke ok: training_yard=%d gold=%d quarry=%s" % [
		training_level_after,
		int(sanctuary.resources.get("gold", 0)),
		sanctuary.selected_building_status(),
	])
	quit(0)


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
