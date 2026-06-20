extends SceneTree

const ContentStore := preload("res://scripts/content_store.gd")
const BattleSim := preload("res://scripts/battle_sim.gd")
const RunState := preload("res://scripts/sim/run_state.gd")


func _init() -> void:
	var store := ContentStore.new()
	var ok := store.load_all()
	if not ok:
		_fail("content store did not load")

	var run_state := RunState.new()
	run_state.reset()
	var sim := BattleSim.new(store, run_state)
	sim.start(500101)

	var player_pos: Vector2 = sim.snapshot().get("player", {}).get("position", Vector2(1500, 1000))
	sim._spawn_exp_pickup(player_pos + Vector2(70, 0), 3)
	sim._spawn_exp_pickup(player_pos + Vector2(90, 8), 4)
	sim.spawn_encounter_for_test("magnet", Vector2.ZERO)
	sim.step(0.08)
	if int(sim.snapshot().get("encounter_collected", 0)) < 1:
		_fail("magnet encounter was not collected")
	if int(sim.snapshot().get("active_pickup_count", 0)) != 0:
		_fail("magnet did not collect exp pickups")
	if int(sim.snapshot().get("exp", 0)) < 7:
		_fail("magnet did not grant exp")

	sim._spawn_enemy(110201, 1)
	sim._spawn_enemy(110202, 1)
	sim.spawn_encounter_for_test("bomb", Vector2.ZERO)
	sim.step(0.08)
	var dead_non_boss := 0
	for entity in sim.entities:
		if typeof(entity) == TYPE_DICTIONARY and str(entity.get("team", "")) == "enemy" and str(entity.get("kind", "")) != "boss" and float(entity.get("hp", 1.0)) <= 0.0:
			dead_non_boss += 1
	if dead_non_boss < 2:
		_fail("bomb did not defeat normal enemies")

	var hp_before := float(sim.player_entity.get("hp", 0.0))
	sim.player_entity["hp"] = max(1.0, hp_before * 0.5)
	sim.spawn_encounter_for_test("potion", Vector2.ZERO)
	sim.step(0.08)
	if float(sim.player_entity.get("hp", 0.0)) <= hp_before * 0.5:
		_fail("potion did not heal player")

	var before_resources: Dictionary = run_state.resources.duplicate(true)
	sim.spawn_encounter_for_test("mine", Vector2.ZERO)
	for _index in range(38):
		sim.step(0.05)
	var after: Dictionary = run_state.resources
	var mined := false
	for key in ["wood", "stone", "soul"]:
		if int(after.get(key, 0)) > int(before_resources.get(key, 0)):
			mined = true
	if not mined:
		_fail("mine did not grant a resource")
	if int(sim.snapshot().get("encounter_mined", 0)) < 1:
		_fail("mine counter did not increment")

	print("godot-ninja2 encounter pickup smoke ok: collected=%d mined=%d exp=%d" % [
		int(sim.snapshot().get("encounter_collected", 0)),
		int(sim.snapshot().get("encounter_mined", 0)),
		int(sim.snapshot().get("exp", 0)),
	])
	quit(0)


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
