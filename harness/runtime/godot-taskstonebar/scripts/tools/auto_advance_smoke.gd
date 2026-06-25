extends SceneTree


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var scene: PackedScene = load("res://scenes/main.tscn")
	var root_node = scene.instantiate()
	get_root().add_child(root_node)

	for _i in range(4):
		await process_frame

	var initial_map_id := int(root_node.sim.snapshot().get("map_id", 0))
	for _wave in range(8):
		root_node.sim.pending_spawns.clear()
		root_node.sim.enemies.clear()
		root_node.sim._run_map_update_triggers(1.0)
		if str(root_node.sim.snapshot().get("result", "")) == "clear":
			break
	var clear_snapshot: Dictionary = root_node.sim.snapshot()
	if str(clear_snapshot.get("result", "")) != "clear":
		_fail("expected map update trigger to EndGame clear, got %s" % str(clear_snapshot.get("result", "")))
		return
	var report: Dictionary = clear_snapshot.get("report", {}) if typeof(clear_snapshot.get("report", {})) == TYPE_DICTIONARY else {}
	if int(report.get("map_id", 0)) != 500101 or int(report.get("next_map_id", 0)) != 500102:
		_fail("trigger clear report did not carry map_id/next_map_id: %s" % str(report))
		return
	root_node._update_auto_transition(0.0)
	root_node._update_auto_transition(1.0)
	await process_frame

	var snapshot: Dictionary = root_node.sim.snapshot()
	var next_map_id := int(snapshot.get("map_id", 0))
	if initial_map_id != 500101:
		_fail("expected initial map 500101, got %d" % initial_map_id)
		return
	if next_map_id != 500102:
		_fail("expected auto advance to 500102, got %d" % next_map_id)
		return
	if not bool(snapshot.get("running", false)):
		_fail("auto advanced map is not running")
		return
	root_node._sync_ui()
	await process_frame
	var overlay := root_node.get_node_or_null("GeneratedFullUiOverlay")
	var stage_label := overlay.get_node_or_null("Section_BottomCombatStrip/Text_StageBadge") if overlay != null else null
	if stage_label == null or not stage_label is Label or str((stage_label as Label).text).find("Stage 1-2") == -1:
		_fail("stage badge did not show advanced stage 1-2")
		return

	print("godot-taskstonebar auto advance smoke ok: %d -> %d" % [initial_map_id, next_map_id])
	quit(0)


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
