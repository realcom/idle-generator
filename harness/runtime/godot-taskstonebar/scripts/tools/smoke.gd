extends SceneTree

const ContentStore := preload("res://scripts/content_store.gd")
const ProgressionState := preload("res://scripts/game/progression_state.gd")
const BasicCombatSim := preload("res://scripts/combat/basic_combat_sim.gd")
const SpriteCatalog := preload("res://scripts/visual/sprite_catalog.gd")

const ENEMY_SPAWN_LANE_SAMPLE_COUNT := 7


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
	if not _check_enemy_spawn_lane(store, int(map_def.get("id", 500101))):
		return

	var progression = ProgressionState.new(store)
	progression.add_item_instance(200202)
	progression.add_item_instance(200203)
	progression.add_item_instance(200204)
	progression.auto_equip_best_stones()
	var inventory: Dictionary = progression.inventory_snapshot()

	var sim = BasicCombatSim.new(store)
	sim.set_progression_state(progression)
	sim.set_player_stat_bonuses(inventory.get("equipped_stats", {}))
	sim.set_player_stone_loadout(inventory.get("equipped_stones", []))
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
	if int(snapshot.get("player_stone_count", 0)) < 3:
		_fail("starter stone loadout did not reach combat")
		return
	if str(snapshot.get("result", "")) == "defeat":
		_fail("starter loadout was defeated during basic smoke")
		return

	var player: Dictionary = snapshot.get("player", {})
	print("godot-taskstonebar smoke ok: waves=%d elapsed=%.1f hp=%d/%d kills=%d skills=%d stones=%d enemies=%d pending=%d result=%s" % [
		int(snapshot.get("wave_count", 0)),
		float(snapshot.get("elapsed", 0.0)),
		int(player.get("hp", 0)),
		int(player.get("max_hp", 0)),
		int(snapshot.get("kill_count", 0)),
		int(snapshot.get("skill_cast_count", 0)),
		int(snapshot.get("player_stone_count", 0)),
		int(snapshot.get("enemy_count", 0)),
		int(snapshot.get("pending_count", 0)),
		str(snapshot.get("result", "")),
	])
	quit(0)


func _check_enemy_spawn_lane(store, map_id: int) -> bool:
	var map_def: Dictionary = store.get_map(map_id)
	var popup_args: Dictionary = map_def.get("popupArgs", {}) if typeof(map_def.get("popupArgs", {})) == TYPE_DICTIONARY else {}
	for key in [
		"ClientEnemySpawnLaneMinYRatio",
		"ClientEnemySpawnLaneCenterYRatio",
		"ClientEnemySpawnLaneMaxYRatio",
		"ClientEnemySpawnLaneOffsetsY",
	]:
		if not popup_args.has(key):
			_fail("map %d popupArgs.%s missing for enemy spawn lane" % [map_id, key])
			return false

	var sim = BasicCombatSim.new(store)
	sim.start(map_id)
	var spawn_count := 0
	while not sim.pending_spawns.is_empty() and spawn_count < ENEMY_SPAWN_LANE_SAMPLE_COUNT:
		sim._spawn_enemy(sim.pending_spawns.pop_front())
		spawn_count += 1
	if spawn_count <= 0:
		_fail("enemy spawn lane check did not spawn any enemy")
		return false
	var snapshot: Dictionary = sim.snapshot()
	var world_size: Vector2 = snapshot.get("world_size", Vector2(960.0, 160.0))
	var min_y := world_size.y * float(popup_args.get("ClientEnemySpawnLaneMinYRatio", 0.0))
	var max_y := world_size.y * float(popup_args.get("ClientEnemySpawnLaneMaxYRatio", 1.0))
	for enemy in snapshot.get("enemies", []):
		if typeof(enemy) != TYPE_DICTIONARY:
			continue
		var position: Vector2 = enemy.get("position", Vector2.ZERO)
		if position.y < min_y or position.y > max_y:
			_fail("enemy spawn y %.1f escaped ground lane %.1f..%.1f" % [position.y, min_y, max_y])
			return false
	return true


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
