extends SceneTree

const ContentStore := preload("res://scripts/content_store.gd")
const BasicCombatSim := preload("res://scripts/combat/basic_combat_sim.gd")
const SpriteCatalog := preload("res://scripts/visual/sprite_catalog.gd")


func _init() -> void:
	var store = ContentStore.new()
	if not store.load_all():
		_fail("content load failed: %s" % "; ".join(store.errors))
		return

	var sprites = SpriteCatalog.new()
	if not sprites.load_all():
		_fail("sprite load failed: %s" % "; ".join(sprites.errors))
		return

	var map_def: Dictionary = store.get_main_map()
	if map_def.is_empty():
		_fail("no main map found")
		return

	var sim = BasicCombatSim.new(store)
	sim.start(int(map_def.get("id", 500101)))
	var boot: Dictionary = sim.snapshot()
	if int(boot.get("wave_count", 0)) < 3:
		_fail("expected trigger graph to expose at least 3 waves, got %d" % int(boot.get("wave_count", 0)))
		return
	if int(boot.get("enemy_count", 0)) + int(boot.get("pending_count", 0)) <= 0:
		_fail("map enter trigger did not queue or spawn enemies")
		return

	for _i in range(60 * 30):
		sim.step(1.0 / 30.0)

	var snapshot: Dictionary = sim.snapshot()
	if int(snapshot.get("kill_count", 0)) <= 0:
		_fail("combat did not kill any enemy after 60 seconds")
		return
	if int(snapshot.get("skill_cast_count", 0)) <= 0:
		_fail("monster skills did not cast during basic smoke")
		return
	if str(snapshot.get("result", "")) == "defeat" and float(snapshot.get("elapsed", 0.0)) < 10.0:
		_fail("player was defeated too early during basic smoke")
		return
		return

	var player: Dictionary = snapshot.get("player", {})
	print("godot-taskstonebar smoke ok: waves=%d elapsed=%.1f hp=%d/%d kills=%d skills=%d enemies=%d pending=%d result=%s" % [
		int(snapshot.get("wave_count", 0)),
		float(snapshot.get("elapsed", 0.0)),
		int(player.get("hp", 0)),
		int(player.get("max_hp", 0)),
		int(snapshot.get("kill_count", 0)),
		int(snapshot.get("skill_cast_count", 0)),
		int(snapshot.get("enemy_count", 0)),
		int(snapshot.get("pending_count", 0)),
		str(snapshot.get("result", "")),
	])
	quit(0)


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
