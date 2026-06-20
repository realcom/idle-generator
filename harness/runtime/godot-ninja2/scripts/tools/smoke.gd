extends SceneTree

const ContentStore := preload("res://scripts/content_store.gd")
const RunState := preload("res://scripts/sim/run_state.gd")
const BattleSim := preload("res://scripts/battle_sim.gd")
const WavePlanner := preload("res://scripts/sim/wave_planner.gd")


func _init() -> void:
	var store = ContentStore.new()
	if not store.load_all():
		_fail("content load had errors: %s" % "; ".join(store.errors))
		return

	var maps: Array = store.get_main_maps()
	if maps.is_empty():
		_fail("no main survival maps found")
		return

	var planner = WavePlanner.new(store)
	var plan: Array = planner.build_plan(maps[0])
	if plan.is_empty():
		_fail("wave planner produced no waves")
		return

	var state = RunState.new()
	state.reset()
	var sim = BattleSim.new(store, state)
	sim.start(int(maps[0].get("id", 500101)))
	var boot_snapshot: Dictionary = sim.snapshot()
	if int(boot_snapshot.get("world_width", 0)) != 9000 or int(boot_snapshot.get("world_height", 0)) != 6000:
		_fail("battle world size mismatch: %sx%s" % [boot_snapshot.get("world_width", "?"), boot_snapshot.get("world_height", "?")])
		return

	var start_position: Vector2 = boot_snapshot.get("player", {}).get("position", Vector2.ZERO)
	sim.set_player_input(Vector2.RIGHT)
	for _i in range(20):
		sim.step(1.0 / 30.0)
	var moved_position: Vector2 = sim.snapshot().get("player", {}).get("position", Vector2.ZERO)
	if moved_position.x <= start_position.x + 8.0:
		_fail("player movement input did not change position")
		return

	var dash_start: Vector2 = moved_position
	if not sim.request_dash(Vector2.DOWN, "smoke"):
		_fail("dash request was rejected while ready")
		return
	for _i in range(10):
		sim.step(1.0 / 30.0)
	var dash_snapshot: Dictionary = sim.snapshot()
	var dash_position: Vector2 = dash_snapshot.get("player", {}).get("position", Vector2.ZERO)
	var dash_state: Dictionary = dash_snapshot.get("dash", {})
	if dash_position.y <= dash_start.y + 60.0:
		_fail("dash did not move the player far enough")
		return
	if int(dash_state.get("count", 0)) < 1 or float(dash_state.get("cooldown", 0.0)) <= 0.0:
		_fail("dash state did not record count/cooldown")
		return

	sim.set_player_input(Vector2.ZERO)
	for _i in range(180):
		sim.step(1.0 / 30.0)

	var snapshot: Dictionary = sim.snapshot()
	var active_or_progress := int(snapshot.get("enemy_count", 0)) + int(snapshot.get("pending_count", 0)) + int(snapshot.get("kill_count", 0))
	if active_or_progress <= 0:
		_fail("battle did not spawn, queue, or kill enemies after startup")
		return
	if int(snapshot.get("wave_count", 0)) != plan.size():
		_fail("snapshot wave count does not match plan")
		return

	print("godot-ninja2 smoke ok: maps=%d waves=%d enemies=%d pending=%d dash=%d" % [
		maps.size(),
		plan.size(),
		int(snapshot.get("enemy_count", 0)),
		int(snapshot.get("pending_count", 0)),
		int(snapshot.get("dash", {}).get("count", 0)),
	])
	quit(0)


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
