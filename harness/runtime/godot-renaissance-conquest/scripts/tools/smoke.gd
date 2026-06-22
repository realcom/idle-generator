extends SceneTree

const MAIN_SCENE := "res://scenes/main.tscn"


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var packed := load(MAIN_SCENE) as PackedScene
	if packed == null:
		_fail("main scene missing")
		return
	var scene: Node = packed.instantiate()
	get_root().add_child(scene)
	await process_frame
	await process_frame

	_require(scene.find_child("TopHud", true, false) != null, "TopHud exists")
	_require(scene.find_child("CommandRail", true, false) != null, "CommandRail exists")
	_require(scene.find_child("CityInspector", true, false) != null, "CityInspector exists")
	_require(scene.find_child("OfficerRoster", true, false) != null, "OfficerRoster exists")
	var audit_button := scene.find_child("Hit_Audit", true, false) as Button
	_require(audit_button != null, "Audit command hit area exists")
	audit_button.emit_signal("pressed")
	await process_frame
	await process_frame
	_require(int(scene.get("ap_current")) == 4, "Audit command spends AP")
	_require(int(scene.get("resources").ducats) > 18000, "Audit command changes ducats")
	_require(scene.find_child("CommandResultPanel", true, false) != null, "CommandResultPanel exists after command")
	var siege_button := scene.find_child("Hit_Siege", true, false) as Button
	_require(siege_button != null, "Siege command hit area exists")
	siege_button.emit_signal("pressed")
	await process_frame
	await process_frame
	_require(int(scene.get("ap_current")) == 3, "Siege command spends AP")
	_require((scene.get("battle_modifiers") as Array).size() > 0, "Siege command adds battle modifier")
	_require(scene.get_meta("battle_tactics_generated_scene", "") == "res://scenes/generated/battle_tactics_stub.tscn", "battle tactics generated scene is wired")

	scene.show_battle()
	await process_frame
	await process_frame
	_require(scene.find_child("PlayerArmyList", true, false) != null, "PlayerArmyList exists")
	_require(scene.find_child("EnemyArmyList", true, false) != null, "EnemyArmyList exists")
	_require(scene.find_child("SelectedOfficerDetail", true, false) != null, "SelectedOfficerDetail exists")
	_require(scene.find_child("BattleFormationBoard", true, false) != null, "BattleFormationBoard exists")
	_require(scene.get("battle_unit_squad_strip_texture") != null, "battle unit squad strip loaded")
	_require(scene.find_child("BattleTurnOrderStrip", true, false) != null, "BattleTurnOrderStrip exists")
	_require(scene.find_child("TurnOrderIcon_Leonardo", true, false) != null, "Leonardo turn order icon exists")
	_require(scene.find_child("TurnOrderRank_Leonardo", true, false) != null, "Leonardo turn order rank exists")
	_require(scene.find_child("FormationUnit_Leonardo", true, false) != null, "Leonardo formation token exists")
	_require(scene.find_child("FormationGround_Leonardo", true, false) != null, "Leonardo formation ground shadow exists")
	_require(scene.find_child("FormationIcon_Leonardo", true, false) != null, "Leonardo formation icon exists")
	_require(scene.find_child("TurnBadge_Leonardo", true, false) != null, "Leonardo turn badge exists")
	_require(scene.find_child("StatusBadge_Leonardo", true, false) != null, "Leonardo status badge exists")
	_require(scene.find_child("TroopChip_Leonardo", true, false) != null, "Leonardo troop chip exists")
	_require(scene.find_child("BattlePredictionPanel", true, false) != null, "BattlePredictionPanel exists")
	_require(scene.find_child("BattleSkillDock", true, false) != null, "BattleSkillDock exists")
	var cannon_button := scene.find_child("SkillButton_Cannon", true, false) as Button
	_require(cannon_button != null, "Cannon skill button exists")
	var enemy_before := float((scene.get("enemy_units") as Array)[0].ratio)
	cannon_button.emit_signal("pressed")
	await process_frame
	await process_frame
	_require(int(scene.get("ap_current")) == 0, "Cannon spends battle AP")
	_require(float((scene.get("enemy_units") as Array)[0].ratio) < enemy_before, "Cannon damages active enemy")
	_require(int(scene.get("battle_action_advantage")) > 0, "battle action advantage increases")
	_require(int(scene.get("battle_capture_pressure")) > 0, "battle capture pressure increases")
	_require((scene.get("aftermath_entries") as Array).size() > 0, "battle aftermath is recorded")

	print("renaissance-conquest smoke ok")
	quit(0)


func _require(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	push_error("renaissance-conquest smoke failed: %s" % message)
	quit(1)
