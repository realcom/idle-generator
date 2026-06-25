extends SceneTree

const ContentStore := preload("res://scripts/content_store.gd")
const BasicCombatSim := preload("res://scripts/combat/basic_combat_sim.gd")


func _init() -> void:
	var store = ContentStore.new()
	if not store.load_all():
		_fail("content load failed: %s" % "; ".join(store.errors))
		return

	var sim = BasicCombatSim.new(store)
	sim.start(500101)
	sim.player["attack"] = 0.0
	sim.player["hp"] = 999999.0
	sim.player["max_hp"] = 999999.0

	for _i in range(int(15.0 * 30.0)):
		sim.step(1.0 / 30.0)

	var snapshot: Dictionary = sim.snapshot()
	if int(snapshot.get("wave", 0)) < 2:
		_fail("expected wave timeout to advance to wave 2, got %d" % int(snapshot.get("wave", 0)))
		return
	if int(snapshot.get("enemy_count", 0)) <= 0:
		_fail("expected previous wave enemies to remain after timeout")
		return

	print("godot-taskstonebar wave timeout smoke ok: wave=%d enemies=%d pending=%d" % [
		int(snapshot.get("wave", 0)),
		int(snapshot.get("enemy_count", 0)),
		int(snapshot.get("pending_count", 0)),
	])
	quit(0)


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
