extends SceneTree

const ModalLayer := preload("res://scripts/home/components/modal_layer.gd")
const BuildingDetailModal := preload("res://scripts/home/modals/building_detail_modal.gd")
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

	var layer = ModalLayer.new()
	get_root().add_child(layer)
	layer.setup(Vector2(440, 800))

	var modal = BuildingDetailModal.new()
	var emitted := {"ok": false, "instance_id": "", "action": ""}
	modal.setup(housing, sanctuary, {})
	modal.building_action_requested.connect(func(instance_id: String, action: String) -> void:
		emitted["ok"] = true
		emitted["instance_id"] = instance_id
		emitted["action"] = action
	)
	layer.open_modal(modal)

	if not layer.has_open_modal():
		_fail("modal layer did not open modal")
		return

	modal.action_requested.emit("confirm")
	if not bool(emitted["ok"]):
		_fail("building modal did not emit confirm action")
		return
	if str(emitted["instance_id"]) != "training_yard#1" or str(emitted["action"]) != "upgrade":
		_fail("building modal emitted wrong action payload")
		return

	layer.close_top()
	if layer.has_open_modal():
		_fail("modal layer did not close modal")
		return

	print("godot-ninja2 modal smoke ok: %s %s" % [str(emitted["instance_id"]), str(emitted["action"])])
	quit(0)


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
