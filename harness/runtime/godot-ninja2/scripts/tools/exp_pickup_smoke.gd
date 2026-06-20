extends SceneTree

const ContentStore := preload("res://scripts/content_store.gd")
const RunState := preload("res://scripts/sim/run_state.gd")
const BattleSim := preload("res://scripts/battle_sim.gd")


func _init() -> void:
	var store = ContentStore.new()
	if not store.load_all():
		_fail("content load had errors: %s" % "; ".join(store.errors))
		return

	var state = RunState.new()
	state.reset()
	var sim = BattleSim.new(store, state)
	sim.start(500101)

	var player_pos: Vector2 = sim.snapshot().get("player", {}).get("position", Vector2.ZERO)
	sim._spawn_exp_pickup(player_pos + Vector2(96, 0), 4)
	if sim.exp_pickups.size() != 1:
		_fail("exp pickup did not spawn")
		return

	for _i in range(8):
		sim.step(1.0 / 60.0)
	if int(sim.snapshot().get("exp", 0)) != 0:
		_fail("exp pickup was collected before arm delay")
		return
	if sim.exp_pickups.is_empty():
		_fail("exp pickup disappeared before collection")
		return

	for _i in range(80):
		sim.step(1.0 / 60.0)
	if int(sim.snapshot().get("exp", 0)) <= 0:
		_fail("exp pickup did not grant exp after collection")
		return
	if int(sim.snapshot().get("pickup_count", 0)) <= 0:
		_fail("pickup counter did not increment")
		return

	print("godot-ninja2 exp pickup smoke ok: exp=%d pickups=%d" % [
		int(sim.snapshot().get("exp", 0)),
		int(sim.snapshot().get("pickup_count", 0)),
	])
	quit(0)


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
