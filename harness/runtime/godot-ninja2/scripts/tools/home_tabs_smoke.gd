extends SceneTree

const ContentStore := preload("res://scripts/content_store.gd")
const HousingTechStore := preload("res://scripts/home/housing_tech_store.gd")
const SanctuaryState := preload("res://scripts/home/sanctuary_state.gd")
const EquipmentTabModal := preload("res://scripts/home/modals/equipment_tab_modal.gd")
const EquipmentDetailModal := preload("res://scripts/home/modals/equipment_detail_modal.gd")
const ExplorationTabModal := preload("res://scripts/home/modals/exploration_tab_modal.gd")
const MissionTabModal := preload("res://scripts/home/modals/mission_tab_modal.gd")
const ShopTabModal := preload("res://scripts/home/modals/shop_tab_modal.gd")


func _init() -> void:
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

	_smoke_equipment(store, housing, sanctuary)
	_smoke_exploration(store, housing, sanctuary)
	_smoke_missions(store, housing, sanctuary)
	_smoke_shop(store, housing, sanctuary)

	print("godot-ninja2 home tabs smoke ok: equipped=%d map=%d claims=%d shop=%d" % [
		int(sanctuary.selected_equipment_item_id),
		int(sanctuary.current_map_id),
		sanctuary.claimed_mission_keys.size(),
		sanctuary.shop_claims.size(),
	])
	quit(0)


func _smoke_equipment(store, housing, sanctuary) -> void:
	var equipment_modal = EquipmentTabModal.new()
	get_root().add_child(equipment_modal)
	equipment_modal.setup(store, housing, sanctuary, {})
	if int(sanctuary.selected_equipment_item_id) <= 0:
		_fail("equipment modal did not seed selected item")
		return
	var selected_id := int(sanctuary.selected_equipment_item_id)
	var detail_modal = EquipmentDetailModal.new()
	get_root().add_child(detail_modal)
	detail_modal.setup(store, sanctuary, {}, selected_id)
	var result: Dictionary = sanctuary.try_equip_item(store, selected_id)
	if not bool(result.get("ok", false)):
		_fail("equipment equip failed: %s" % str(result.get("message", "")))
		return
	equipment_modal.queue_free()
	detail_modal.queue_free()


func _smoke_exploration(store, housing, sanctuary) -> void:
	var exploration_modal = ExplorationTabModal.new()
	get_root().add_child(exploration_modal)
	exploration_modal.setup(store, housing, sanctuary, {})
	var result: Dictionary = sanctuary.select_map(500103, store)
	if not bool(result.get("ok", false)):
		_fail("map select failed: %s" % str(result.get("message", "")))
		return
	if int(sanctuary.current_map_id) != 500103:
		_fail("map selection did not update current map")
		return
	exploration_modal.queue_free()


func _smoke_missions(store, housing, sanctuary) -> void:
	var mission_modal = MissionTabModal.new()
	get_root().add_child(mission_modal)
	mission_modal.setup(store, housing, sanctuary, {})
	var claim: Dictionary = sanctuary.try_claim_mission(store, 600301)
	if not bool(claim.get("ok", false)):
		_fail("mission claim failed: %s" % str(claim.get("message", "")))
		return
	if not bool(sanctuary.claimed_mission_keys.get("clear_stage_1", false)):
		_fail("mission claim was not recorded")
		return
	mission_modal.queue_free()


func _smoke_shop(store, housing, sanctuary) -> void:
	var shop_modal = ShopTabModal.new()
	get_root().add_child(shop_modal)
	shop_modal.setup(store, housing, sanctuary, {})
	var before_gold := int(sanctuary.resources.get("gold", 0))
	var result: Dictionary = sanctuary.try_claim_shop_product(store, 201502)
	if not bool(result.get("ok", false)):
		_fail("shop claim failed: %s" % str(result.get("message", "")))
		return
	if int(sanctuary.resources.get("gold", 0)) <= before_gold:
		_fail("shop product did not grant gold")
		return
	if not bool(sanctuary.shop_claims.get("starter_sanctuary_pack", false)):
		_fail("shop claim was not recorded")
		return
	shop_modal.queue_free()


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
