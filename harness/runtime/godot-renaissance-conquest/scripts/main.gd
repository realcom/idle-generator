extends Control

const VIEW_SIZE := Vector2(1280, 720)
const MODE_CAMPAIGN := "campaign"
const MODE_BATTLE := "battle"
const CampaignMapTexture := preload("res://assets/generated/campaign/italy_campaign_map_v1.png")
const FlorenceCityTexture := preload("res://assets/generated/city/florence_city_card_v1.png")
const OfficerPortraitStripTexture := preload("res://assets/generated/officers/officer_portrait_strip_v1.png")
const BattleBackgroundTexture := preload("res://assets/generated/battle/florence_siege_battlefield_v1.png")
const BattleSkillIconStripTexture := preload("res://assets/generated/skills/battle_skill_icon_strip_v1.png")
const BattleUnitIconStripTexture := preload("res://assets/generated/units/battle_unit_icon_strip_v2.png")
const BattleUnitSquadStripTexture := preload("res://assets/generated/units/battle_unit_ground_squad_strip_v3.png")
const CommandIconStripTexture := preload("res://assets/generated/icons/command_icon_strip_v1.png")
const HudResourceIconStripTexture := preload("res://assets/generated/icons/hud_resource_icon_strip_v1.png")
const TopActionIconStripTexture := preload("res://assets/generated/icons/top_action_icon_strip_v1.png")
const CityStatIconStripTexture := preload("res://assets/generated/icons/city_stat_icon_strip_v1.png")
const FactionCrestStripTexture := preload("res://assets/generated/factions/faction_crest_strip_v1.png")
const CampaignMinimapTexture := preload("res://assets/generated/minimap/campaign_minimap_v1.png")
const UiSkinAtlasTexture := preload("res://assets/generated/skins/ui_skin_atlas_v1.png")
const CommandButtonFrameAtlasTexture := preload("res://assets/generated/skins/command_button_frame_atlas_v1.png")
const CommandMedallionIconAtlasTexture := preload("res://assets/generated/icons/command_medallion_icon_atlas_v1.png")
const BattleTacticsRecipeScene := preload("res://scenes/generated/battle_tactics_stub.tscn")
const BattleTacticsTheme := preload("res://themes/generated/battle_tactics.tres")

const ACTIVE_OFFICER_INDEX := 3
const BATTLE_PLAYER_ARMY_RECT := Rect2(16, 78, 160, 470)
const BATTLE_BOARD_RECT := Rect2(188, 78, 758, 470)
const BATTLE_ENEMY_ARMY_RECT := Rect2(958, 78, 306, 470)
const BATTLE_OFFICER_DETAIL_RECT := Rect2(16, 560, 360, 148)
const BATTLE_SKILL_DOCK_RECT := Rect2(388, 560, 558, 148)
const BATTLE_FORECAST_RECT := Rect2(958, 560, 306, 148)

const C := {
	"bg": Color("#101724"),
	"sea": Color("#284E68"),
	"land": Color("#506C4F"),
	"land_2": Color("#637A56"),
	"road": Color("#C8A15D"),
	"panel": Color("#202C3E"),
	"panel_2": Color("#2B3B50"),
	"selected": Color("#344A65"),
	"border": Color("#6F7F8F"),
	"text": Color("#F2EAD6"),
	"muted": Color("#B9C2C9"),
	"dim": Color("#718091"),
	"brass": Color("#C9A452"),
	"war": Color("#D35D4B"),
	"success": Color("#69C37B"),
	"intrigue": Color("#8A78D6"),
	"battle": Color("#243247")
}

const FACTIONS := {
	"Milan": Color("#4A6FB4"),
	"Venice": Color("#3EA6A0"),
	"Florence": Color("#B84A4A"),
	"Papal States": Color("#D8BF6A"),
	"Naples": Color("#7B5BA8"),
	"Genoa": Color("#E8E6DC")
}

const FACTION_CREST_INDEX := {
	"Milan": 0,
	"Venice": 1,
	"Florence": 2,
	"Papal States": 3,
	"Naples": 4,
	"Genoa": 5
}

var mode := MODE_CAMPAIGN
var selected_city := 2
var selected_skill := 0
var selected_command := 0
var turn_number := 7
var ap_current := 5
var ap_max := 9
var command_sequence := 0
var resources := {
	"ducats": 18000,
	"grain": 7000,
	"troops": 32000,
	"prestige": 42,
	"faith": 68,
	"tech": 3,
	"intel": 2
}
var battle_modifiers: Array[Dictionary] = []
var event_candidates: Array[String] = []
var battle_round := 2
var battle_action_advantage := 0
var enemy_morale := 72
var battle_capture_pressure := 0
var active_enemy_index := 0
var aftermath_entries: Array[String] = []
var last_command_result := {
	"title": "Awaiting council order",
	"result": "READY",
	"detail": "Select a Florence command from the left rail.",
	"effects": "AP 5/9",
	"tone": "neutral"
}
var root_layer: Control
var campaign_map_texture: Texture2D
var florence_city_texture: Texture2D
var officer_strip_texture: Texture2D
var battle_background_texture: Texture2D
var battle_skill_icon_strip_texture: Texture2D
var battle_unit_icon_strip_texture: Texture2D
var battle_unit_squad_strip_texture: Texture2D
var command_icon_strip_texture: Texture2D
var hud_resource_icon_strip_texture: Texture2D
var top_action_icon_strip_texture: Texture2D
var city_stat_icon_strip_texture: Texture2D
var faction_crest_strip_texture: Texture2D
var campaign_minimap_texture: Texture2D
var ui_skin_atlas_texture: Texture2D
var command_button_frame_atlas_texture: Texture2D
var command_medallion_icon_atlas_texture: Texture2D
var battle_tactics_recipe_scene: PackedScene
var battle_tactics_theme: Theme

var cities := [
	{"name": "Milano", "faction": "Milan", "pos": Vector2(307, 123), "level": 4, "income": 720, "grain": 420, "garrison": 5800, "fort": 3, "order": 71, "faith": 58, "trade": 64, "slots": "Forge / Bank / Academy", "officer": "Leonardo"},
	{"name": "Venezia", "faction": "Venice", "pos": Vector2(579, 121), "level": 5, "income": 930, "grain": 380, "garrison": 6200, "fort": 4, "order": 77, "faith": 63, "trade": 91, "slots": "Arsenal / Market / Dock", "officer": "Admiral Valeria"},
	{"name": "Florence", "faction": "Florence", "pos": Vector2(411, 231), "level": 4, "income": 820, "grain": 460, "garrison": 3900, "fort": 2, "order": 82, "faith": 52, "trade": 78, "slots": "Guild / Chapel / Salon", "officer": "Lorenza de Medici"},
	{"name": "Roma", "faction": "Papal States", "pos": Vector2(440, 340), "level": 5, "income": 760, "grain": 520, "garrison": 7100, "fort": 4, "order": 68, "faith": 95, "trade": 70, "slots": "Basilica / Court / Reliquary", "officer": "Cesara Borgia"},
	{"name": "Napoli", "faction": "Naples", "pos": Vector2(590, 400), "level": 4, "income": 680, "grain": 640, "garrison": 6400, "fort": 3, "order": 64, "faith": 72, "trade": 74, "slots": "Granary / Port / Barracks", "officer": "Sir Aurelio"},
	{"name": "Genova", "faction": "Genoa", "pos": Vector2(250, 177), "level": 3, "income": 610, "grain": 310, "garrison": 3100, "fort": 2, "order": 70, "faith": 49, "trade": 83, "slots": "Counting House / Dock", "officer": "Nico Machiavelli"}
]

var officers := [
	{"name": "Lorenza", "role": "Banker / Duelist", "troops": "2.4k", "hp": "88%", "stamina": 7, "bond": 61, "status": "Trust"},
	{"name": "Cesara", "role": "Schemer / Cavalry", "troops": "3.1k", "hp": "74%", "stamina": 5, "bond": 42, "status": "Wound"},
	{"name": "Nico", "role": "Advisor / Spy", "troops": "1.2k", "hp": "91%", "stamina": 8, "bond": 55, "status": "Quest"},
	{"name": "Leonardo", "role": "Engineer / Cannon", "troops": "1.8k", "hp": "83%", "stamina": 6, "bond": 69, "status": "Oath"},
	{"name": "Valeria", "role": "Admiral / Volley", "troops": "2.8k", "hp": "79%", "stamina": 6, "bond": 47, "status": "Encounter"},
	{"name": "Aurelio", "role": "Cathedral Knight", "troops": "3.4k", "hp": "92%", "stamina": 4, "bond": 58, "status": "Trust"}
]

var skills := [
	{"name": "Strike", "ap": 1, "cd": 0, "damage": 420, "morale": -3, "adv": 4, "risk": "Low"},
	{"name": "Guard", "ap": 1, "cd": 1, "damage": 80, "morale": 5, "adv": 1, "risk": "None"},
	{"name": "Volley", "ap": 2, "cd": 2, "damage": 620, "morale": -6, "adv": 7, "risk": "Medium"},
	{"name": "Rally", "ap": 2, "cd": 2, "damage": 0, "morale": 12, "adv": 3, "risk": "None"},
	{"name": "Scheme", "ap": 2, "cd": 3, "damage": 260, "morale": -10, "adv": 11, "risk": "Counterspy"},
	{"name": "Cannon", "ap": 3, "cd": 4, "damage": 940, "morale": -8, "adv": 9, "risk": "High"}
]

var city_commands := [
	{"id": "cmd_audit_ledgers", "name": "Audit", "full": "Audit Ledgers", "category": "develop", "icon": 1, "ap": 1, "costs": {}, "power": 10, "difficulty": 8, "summary": "Collect ducats and expose guild irregularities.", "effects": {"ducats": 700, "income": 40, "trade": 1}, "critical": {"intel": 1}, "event": "ledger_secret"},
	{"id": "cmd_develop_district", "name": "Develop", "full": "Develop District", "category": "develop", "icon": 1, "ap": 1, "costs": {"ducats": 800}, "power": 9, "difficulty": 9, "summary": "Raise city income and trade capacity.", "effects": {"income": 65, "trade": 2}, "critical": {"order": 1}, "event": "new_district_request"},
	{"id": "cmd_fortify_walls", "name": "Fortify", "full": "Fortify Walls", "category": "military", "icon": 0, "ap": 1, "costs": {"ducats": 650, "grain": 80}, "power": 9, "difficulty": 8, "summary": "Improve fort level and next defense advantage.", "effects": {"fort": 1}, "modifier": {"id": "mod_defender_wall_bonus_small", "name": "Wall Bonus", "adv": 5, "wall": 10}, "event": "engineer_wall_event"},
	{"id": "cmd_recruit_company", "name": "Recruit", "full": "Recruit Company", "category": "military", "icon": 2, "ap": 1, "costs": {"ducats": 900}, "power": 8, "difficulty": 8, "summary": "Hire a compact company into the selected garrison.", "effects": {"garrison": 320, "troops": 320}, "critical": {"prestige": 1}, "event": "veteran_company_offer"},
	{"id": "cmd_scout_neighbor", "name": "Scout", "full": "Scout Neighbor", "category": "intrigue", "icon": 5, "ap": 1, "costs": {"intel": 1}, "power": 9, "difficulty": 8, "summary": "Reveal enemy slots and gain starting advantage.", "effects": {}, "modifier": {"id": "mod_scouted_enemy_small", "name": "Scouted Enemy", "adv": 4, "reveal": 3}, "event": "spy_report"},
	{"id": "cmd_prepare_siege", "name": "Siege", "full": "Prepare Siege", "category": "military", "icon": 0, "ap": 1, "costs": {"ducats": 600, "grain": 180}, "power": 10, "difficulty": 9, "summary": "Stock ladders, maps, and gunpowder for next attack.", "effects": {}, "modifier": {"id": "mod_siege_prep_standard", "name": "Siege Prep", "adv": 8, "wall_bonus": 25}, "event": "engineer_inspiration"},
	{"id": "cmd_sponsor_workshop", "name": "Workshop", "full": "Sponsor Workshop", "category": "patronage", "icon": 3, "ap": 1, "costs": {"ducats": 900}, "power": 10, "difficulty": 9, "summary": "Convert money into tech and prototype events.", "effects": {"tech": 2}, "critical": {"prestige": 1}, "event": "workshop_prototype"},
	{"id": "cmd_rest_officer", "name": "Rest", "full": "Rest Officer", "category": "recovery", "icon": 4, "ap": 1, "costs": {"ducats": 250}, "power": 8, "difficulty": 6, "summary": "Recover the assigned officer's stamina and bond.", "effects": {"stamina": 1, "bond": 2}, "critical": {"faith": 1}, "event": "quiet_recovery_scene"}
]

var enemy_units := [
	{"name": "Papal Guard", "role": "Pike / Front", "troops": "2.0k", "hp": "91%", "ratio": 0.91, "status": "Wall", "routed": false},
	{"name": "Milan Guard", "role": "Sword / Back", "troops": "1.7k", "hp": "78%", "ratio": 0.78, "status": "Cover", "routed": false},
	{"name": "Borgia Agent", "role": "Spy / Mid", "troops": "0.9k", "hp": "69%", "ratio": 0.69, "status": "Hex", "routed": false},
	{"name": "Bombardier", "role": "Cannon / Back", "troops": "1.1k", "hp": "84%", "ratio": 0.84, "status": "Aim", "routed": false},
	{"name": "Knight Host", "role": "Cavalry / Front", "troops": "2.6k", "hp": "72%", "ratio": 0.72, "status": "Charge", "routed": false},
	{"name": "Swiss Pike", "role": "Pike / Guard", "troops": "2.3k", "hp": "88%", "ratio": 0.88, "status": "Brace", "routed": false}
]

var ally_formation := [
	[
		{"name": "Nico", "role": "SPY", "troops": "1200", "hp": 0.91, "turn": 3, "icon": 0, "pips": 4, "state": "Mark"},
		{"name": "Lorenza", "role": "DUEL", "troops": "2400", "hp": 0.88, "turn": 2, "icon": 1, "pips": 5, "state": "Guard"}
	],
	[
		{"name": "Valeria", "role": "VOLLEY", "troops": "2800", "hp": 0.79, "turn": 6, "icon": 2, "pips": 4, "state": "Aim"},
		{"name": "Aurelio", "role": "KNIGHT", "troops": "3400", "hp": 0.92, "turn": 1, "icon": 3, "pips": 5, "state": "Front"}
	],
	[
		{"name": "Leonardo", "role": "CANNON", "troops": "1800", "hp": 0.83, "turn": 4, "icon": 4, "pips": 3, "state": "Skill"},
		{"name": "Cesara", "role": "SCHEME", "troops": "3100", "hp": 0.74, "turn": 5, "icon": 5, "pips": 4, "state": "Hex"}
	]
]

var enemy_formation := [
	[
		{"name": "Condottiere", "role": "FRONT", "troops": "1700", "hp": 0.82, "turn": 8, "icon": 3, "pips": 4, "state": "Brace"},
		{"name": "Milan Guard", "role": "BACK", "troops": "1700", "hp": 0.78, "turn": 9, "icon": 1, "pips": 4, "state": "Cover"}
	],
	[
		{"name": "Borgia Agent", "role": "MID", "troops": "900", "hp": 0.69, "turn": 10, "icon": 5, "pips": 3, "state": "Hex"},
		{"name": "Papal Pike", "role": "MID", "troops": "2000", "hp": 0.91, "turn": 7, "icon": 3, "pips": 5, "state": "Wall"}
	],
	[
		{"name": "Bombardier", "role": "BACK", "troops": "1100", "hp": 0.84, "turn": 11, "icon": 4, "pips": 3, "state": "Aim"},
		{"name": "Knight Host", "role": "FRONT", "troops": "2600", "hp": 0.72, "turn": 12, "icon": 3, "pips": 4, "state": "Charge"}
	]
]

var battle_turn_order := [
	{"name": "Aurelio", "side": "ally", "rank": 1, "icon": 3},
	{"name": "Lorenza", "side": "ally", "rank": 2, "icon": 1},
	{"name": "Nico", "side": "ally", "rank": 3, "icon": 0},
	{"name": "Leonardo", "side": "ally", "rank": 4, "icon": 4},
	{"name": "Cesara", "side": "ally", "rank": 5, "icon": 5},
	{"name": "Valeria", "side": "ally", "rank": 6, "icon": 2},
	{"name": "Papal Pike", "side": "enemy", "rank": 7, "icon": 3},
	{"name": "Condottiere", "side": "enemy", "rank": 8, "icon": 3},
	{"name": "Milan Guard", "side": "enemy", "rank": 9, "icon": 1},
	{"name": "Borgia Agent", "side": "enemy", "rank": 10, "icon": 5},
	{"name": "Bombardier", "side": "enemy", "rank": 11, "icon": 4},
	{"name": "Knight Host", "side": "enemy", "rank": 12, "icon": 3}
]


func _ready() -> void:
	custom_minimum_size = VIEW_SIZE
	campaign_map_texture = CampaignMapTexture
	florence_city_texture = FlorenceCityTexture
	officer_strip_texture = OfficerPortraitStripTexture
	battle_background_texture = BattleBackgroundTexture
	battle_skill_icon_strip_texture = BattleSkillIconStripTexture
	battle_unit_icon_strip_texture = BattleUnitIconStripTexture
	battle_unit_squad_strip_texture = BattleUnitSquadStripTexture
	command_icon_strip_texture = CommandIconStripTexture
	hud_resource_icon_strip_texture = HudResourceIconStripTexture
	top_action_icon_strip_texture = TopActionIconStripTexture
	city_stat_icon_strip_texture = CityStatIconStripTexture
	faction_crest_strip_texture = FactionCrestStripTexture
	campaign_minimap_texture = CampaignMinimapTexture
	ui_skin_atlas_texture = UiSkinAtlasTexture
	command_button_frame_atlas_texture = CommandButtonFrameAtlasTexture
	command_medallion_icon_atlas_texture = CommandMedallionIconAtlasTexture
	battle_tactics_recipe_scene = BattleTacticsRecipeScene
	battle_tactics_theme = BattleTacticsTheme
	theme = battle_tactics_theme
	set_meta("battle_tactics_recipe", "renaissance-conquest-battle-tactics")
	set_meta("battle_tactics_generated_scene", battle_tactics_recipe_scene.resource_path)
	_build_ui()


func show_campaign() -> void:
	mode = MODE_CAMPAIGN
	_build_ui()


func show_battle() -> void:
	mode = MODE_BATTLE
	_build_ui()


func _build_ui() -> void:
	for child in get_children():
		child.queue_free()
	root_layer = Control.new()
	root_layer.name = "RootLayer"
	root_layer.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(root_layer)

	_build_top_hud()
	if mode == MODE_CAMPAIGN:
		_build_campaign()
		_build_roster()
		_build_minimap()
	else:
		_build_battle()
	queue_redraw()


func _can_pay_command(command: Dictionary) -> bool:
	if ap_current < int(command.get("ap", 0)):
		return false
	var costs: Dictionary = command.get("costs", {})
	for key in costs.keys():
		if int(resources.get(str(key), 0)) < int(costs[key]):
			return false
	return true


func _run_city_command(index: int) -> void:
	if index < 0 or index >= city_commands.size():
		return
	selected_command = index
	var command: Dictionary = city_commands[index]
	if not _can_pay_command(command):
		last_command_result = {
			"title": str(command.full),
			"result": "BLOCKED",
			"detail": "Council lacks AP or required resources.",
			"effects": _command_cost_text(command),
			"tone": "failure"
		}
		_build_ui()
		return

	ap_current -= int(command.ap)
	_pay_command_costs(command)
	var roll := command_sequence % 6 + 1
	command_sequence += 1
	var margin := int(command.power) + roll - int(command.difficulty)
	var tier := "success"
	var tone := "success"
	var multiplier := 1.0
	if margin <= -5:
		tier = "failure"
		tone = "failure"
		multiplier = 0.0
	elif margin <= 0:
		tier = "partial"
		tone = "partial"
		multiplier = 0.5
	elif margin >= 6:
		tier = "critical"
		tone = "success"
		multiplier = 1.0

	var effects_text := _apply_command_effects(command, multiplier)
	if tier == "critical":
		var critical_text := _apply_critical_effects(command)
		if critical_text != "":
			effects_text = "%s, %s" % [effects_text, critical_text] if effects_text != "" else critical_text
	if tier == "success" or tier == "critical":
		_apply_command_modifier(command)
		_add_event_candidate(str(command.get("event", "")))
	elif tier == "partial":
		_add_event_candidate("%s_partial" % str(command.id))
	else:
		_apply_command_failure(command)

	last_command_result = {
		"title": str(command.full),
		"result": tier.to_upper(),
		"detail": "Roll %d, margin %+d. %s" % [roll, margin, str(command.summary)],
		"effects": effects_text if effects_text != "" else "No direct gains",
		"tone": tone
	}
	_build_ui()


func _pay_command_costs(command: Dictionary) -> void:
	var costs: Dictionary = command.get("costs", {})
	for key in costs.keys():
		var resource_key := str(key)
		resources[resource_key] = max(0, int(resources.get(resource_key, 0)) - int(costs[key]))


func _apply_command_effects(command: Dictionary, multiplier: float) -> String:
	if multiplier <= 0.0:
		return "No gain"
	var city: Dictionary = cities[selected_city]
	var effects: Dictionary = command.get("effects", {})
	var summaries: Array[String] = []
	for key in effects.keys():
		var effect_key := str(key)
		var amount := int(round(float(effects[key]) * multiplier))
		if amount == 0:
			continue
		if resources.has(effect_key):
			resources[effect_key] = max(0, int(resources.get(effect_key, 0)) + amount)
			summaries.append("%s %+d" % [effect_key.capitalize(), amount])
		elif city.has(effect_key):
			var next_value := int(city[effect_key]) + amount
			if effect_key in ["order", "faith", "trade"]:
				next_value = clampi(next_value, 0, 100)
			elif effect_key == "fort":
				next_value = clampi(next_value, 0, 9)
			cities[selected_city][effect_key] = next_value
			summaries.append("%s %+d" % [effect_key.capitalize(), amount])
		elif effect_key == "stamina" or effect_key == "bond":
			var officer: Dictionary = officers[ACTIVE_OFFICER_INDEX]
			var cap := 10 if effect_key == "stamina" else 100
			officers[ACTIVE_OFFICER_INDEX][effect_key] = clampi(int(officer[effect_key]) + amount, 0, cap)
			summaries.append("%s %+d" % [effect_key.capitalize(), amount])
	return ", ".join(summaries)


func _apply_critical_effects(command: Dictionary) -> String:
	var critical: Dictionary = command.get("critical", {})
	var summaries: Array[String] = []
	for key in critical.keys():
		var resource_key := str(key)
		var amount := int(critical[key])
		if resources.has(resource_key):
			resources[resource_key] = max(0, int(resources.get(resource_key, 0)) + amount)
			summaries.append("%s %+d" % [resource_key.capitalize(), amount])
	return ", ".join(summaries)


func _apply_command_modifier(command: Dictionary) -> void:
	if not command.has("modifier"):
		return
	var modifier: Dictionary = command.modifier.duplicate(true)
	modifier["source"] = str(command.full)
	battle_modifiers.append(modifier)
	if battle_modifiers.size() > 4:
		battle_modifiers.pop_front()


func _apply_command_failure(command: Dictionary) -> void:
	var city: Dictionary = cities[selected_city]
	cities[selected_city]["order"] = clampi(int(city.order) - 3, 0, 100)
	_add_event_candidate("%s_failure" % str(command.id))


func _add_event_candidate(event_id: String) -> void:
	if event_id == "":
		return
	event_candidates.append(event_id)
	if event_candidates.size() > 5:
		event_candidates.pop_front()


func _battle_advantage_bonus() -> int:
	var total := 0
	for modifier in battle_modifiers:
		total += int(modifier.get("adv", 0))
	return total


func _current_battle_advantage() -> int:
	return 18 + _battle_advantage_bonus() + battle_action_advantage


func _battle_wall_bonus() -> int:
	var total := 0
	for modifier in battle_modifiers:
		total += int(modifier.get("wall_bonus", 0))
		total += int(modifier.get("wall", 0))
	return total


func _battle_modifier_names() -> String:
	var names: Array[String] = []
	for modifier in battle_modifiers:
		names.append(str(modifier.get("name", "Prep")))
	return ", ".join(names)


func _battle_damage_ratio(skill: Dictionary) -> float:
	if str(skill.name) == "Rally":
		return 0.0
	var advantage: int = _current_battle_advantage()
	if advantage < 0:
		advantage = 0
	var pressure: int = int(skill.damage) + advantage * 8
	if str(skill.name) == "Cannon":
		pressure += _battle_wall_bonus() * 4
	return clampf(float(pressure) / 2600.0, 0.0, 0.72)


func _battle_capture_gain(skill: Dictionary) -> int:
	if str(skill.name) == "Rally":
		return 0
	var advantage: int = _current_battle_advantage()
	if advantage < 0:
		advantage = 0
	return clampi(8 + int(skill.damage) / 180 + advantage / 4 + _battle_wall_bonus() / 5, 0, 42)


func _append_aftermath(text: String) -> void:
	aftermath_entries.append(text)
	if aftermath_entries.size() > 5:
		aftermath_entries.pop_front()


func _after_battle_summary() -> String:
	if aftermath_entries.is_empty():
		return ""
	var start: int = aftermath_entries.size() - 2
	if start < 0:
		start = 0
	var parts: Array[String] = []
	for i in range(start, aftermath_entries.size()):
		parts.append(aftermath_entries[i])
	return "Aftermath: %s" % " | ".join(parts)


func _slugify(value: String) -> String:
	return value.to_lower().replace(" ", "_").replace("/", "_").replace(".", "")


func _enemy_formation_coords(index: int) -> Vector2i:
	var coords := [
		Vector2i(1, 1),
		Vector2i(0, 1),
		Vector2i(1, 0),
		Vector2i(2, 0),
		Vector2i(2, 1),
		Vector2i(0, 0)
	]
	return coords[clampi(index, 0, coords.size() - 1)]


func _enemy_board_center(index: int) -> Vector2:
	var coords := _enemy_formation_coords(index)
	return BATTLE_BOARD_RECT.position + Vector2(458 + coords.y * 118 + 54, 72 + coords.x * 118 + 41)


func _sync_active_enemy_formation(index: int, ratio: float, state: String) -> void:
	var coords := _enemy_formation_coords(index)
	enemy_formation[coords.x][coords.y]["hp"] = ratio
	enemy_formation[coords.x][coords.y]["state"] = state
	enemy_formation[coords.x][coords.y]["pips"] = clampi(int(ceil(ratio * 5.0)), 0, 5)


func _advance_active_enemy() -> void:
	for step in range(enemy_units.size()):
		var next_index := (active_enemy_index + 1 + step) % enemy_units.size()
		if not bool(enemy_units[next_index].get("routed", false)):
			active_enemy_index = next_index
			return
	_append_aftermath("Enemy line collapsed; Florence can resolve the siege.")


func _run_battle_action(index: int) -> void:
	if index < 0 or index >= skills.size():
		return
	selected_skill = index
	var skill: Dictionary = skills[index]
	var cost := int(skill.ap)
	if ap_current < cost:
		_append_aftermath("No AP for %s." % str(skill.name))
		_build_ui()
		return

	ap_current -= cost
	battle_round += 1
	if str(skill.name) == "Rally":
		battle_action_advantage += int(skill.adv) + int(skill.morale) / 4
		var officer: Dictionary = officers[ACTIVE_OFFICER_INDEX]
		officers[ACTIVE_OFFICER_INDEX]["stamina"] = clampi(int(officer.stamina) + 1, 0, 10)
		_append_aftermath("Rally steadies Florence; advantage %+d." % _current_battle_advantage())
		_build_ui()
		return

	var target_index := active_enemy_index
	var target: Dictionary = enemy_units[target_index]
	var was_routed := bool(target.get("routed", false))
	var damage_ratio := _battle_damage_ratio(skill)
	var old_ratio := float(target.ratio)
	var next_ratio := clampf(old_ratio - damage_ratio, 0.0, 1.0)
	enemy_morale = clampi(enemy_morale + min(0, int(skill.morale)), 0, 100)
	battle_capture_pressure = clampi(battle_capture_pressure + _battle_capture_gain(skill), 0, 95)
	battle_action_advantage += int(skill.adv)

	var next_state := "Hit"
	if next_ratio <= 0.0:
		next_state = "Routed"
	elif enemy_morale <= 45 or next_ratio < 0.4:
		next_state = "Shaken"
	enemy_units[target_index]["ratio"] = next_ratio
	enemy_units[target_index]["hp"] = "%d%%" % int(round(next_ratio * 100.0))
	enemy_units[target_index]["status"] = next_state
	enemy_units[target_index]["routed"] = next_ratio <= 0.0
	_sync_active_enemy_formation(target_index, next_ratio, next_state)

	_append_aftermath("%s hits %s for %d%% HP; capture %d%%." % [str(skill.name), str(target.name), int(round(damage_ratio * 100.0)), battle_capture_pressure])
	if next_ratio <= 0.0 and not was_routed:
		resources["prestige"] = int(resources.prestige) + 1
		_add_event_candidate("capture_%s" % _slugify(str(target.name)))
		_append_aftermath("%s routed; capture event opened." % str(target.name))
		_advance_active_enemy()
	_build_ui()


func _command_cost_text(command: Dictionary) -> String:
	var parts: Array[String] = ["AP %d" % int(command.get("ap", 0))]
	var costs: Dictionary = command.get("costs", {})
	for key in costs.keys():
		parts.append("%s %d" % [str(key).capitalize(), int(costs[key])])
	return ", ".join(parts)


func _compact_number(value: int) -> String:
	if abs(value) >= 1000:
		return "%dk" % int(round(float(value) / 1000.0))
	return str(value)


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, VIEW_SIZE), C.bg)
	if mode == MODE_CAMPAIGN:
		_draw_campaign_map()
	else:
		_draw_battle_board()


func _build_top_hud() -> void:
	var panel := _panel("TopHud", Rect2(16, 12, 1248, 54), C.panel)
	var campaign_btn := _mode_button("Campaign", MODE_CAMPAIGN)
	campaign_btn.position = Vector2(8, 10)
	panel.add_child(campaign_btn)
	var battle_btn := _mode_button("Battle", MODE_BATTLE)
	battle_btn.position = Vector2(126, 10)
	panel.add_child(battle_btn)
	var line := _vline()
	line.position = Vector2(248, 10)
	panel.add_child(line)
	var chips: Array[String]
	var chip_w := 82.0
	if mode == MODE_CAMPAIGN:
		chip_w = 67.0
		chips = [
			"YR 1503",
			"T %02d" % turn_number,
			"SPR",
			"AP %d/%d" % [ap_current, ap_max],
			"G %s" % _compact_number(int(resources.ducats)),
			"GR %s" % _compact_number(int(resources.grain)),
			"TR %s" % _compact_number(int(resources.troops)),
			"PR %d" % int(resources.prestige),
			"FA %d" % int(resources.faith),
			"TE %d" % int(resources.tech),
			"IN %d" % int(resources.intel)
		]
	else:
		chip_w = 104.0
		chips = ["BATTLE", "FIRENZE", "ROUND %d" % battle_round, "WEATHER CLR", "WALLS", "EN MORALE %d" % enemy_morale, "SUPPLY 64", "AP %d" % ap_current, "ADV %+d" % _current_battle_advantage()]
	for i in range(chips.size()):
		var chip := _chip(chips[i], C.panel_2, C.text, _hud_icon_texture(i) if mode == MODE_CAMPAIGN else null)
		chip.position = Vector2(264 + i * (chip_w + 4), 12)
		chip.custom_minimum_size = Vector2(chip_w, 28)
		chip.size = Vector2(chip_w, 28)
		panel.add_child(chip)
	if mode == MODE_CAMPAIGN:
		for i in range(5):
			var action_btn := _button("", Vector2(34, 34), C.panel_2)
			action_btn.name = "TopAction_%d" % i
			action_btn.position = Vector2(1050 + i * 39, 10)
			action_btn.icon = _top_action_icon_texture(i)
			action_btn.expand_icon = true
			action_btn.add_theme_constant_override("icon_max_width", 24)
			panel.add_child(action_btn)


func _build_campaign() -> void:
	_build_command_rail()
	_build_map_buttons()
	_build_city_inspector()
	_build_command_feedback_panel()


func _build_command_rail() -> void:
	var panel := _panel("CommandRail", Rect2(16, 78, 150, 470), C.panel)
	var box := _vbox(panel, 4, 5)
	for i in range(city_commands.size()):
		var command: Dictionary = city_commands[i]
		var command_button := _command_button(str(command.name), int(command.icon), str(command.ap))
		command_button.modulate = Color(1.08, 1.08, 1.08, 1.0) if i == selected_command else Color.WHITE
		var hit := command_button.find_child("Hit_%s" % str(command.name), true, false) as Button
		if hit != null:
			hit.disabled = not _can_pay_command(command)
			hit.pressed.connect(func(index := i) -> void:
				_run_city_command(index)
			)
		box.add_child(command_button)


func _build_map_buttons() -> void:
	var map_panel := _panel("CampaignMapPanel", Rect2(178, 78, 706, 470), Color(0, 0, 0, 0))
	map_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	for i in range(cities.size()):
		var city: Dictionary = cities[i]
		var pos: Vector2 = Vector2(city.pos.x, city.pos.y)
		var btn := _button(str(city.name), Vector2(94, 30), C.panel if i != selected_city else C.selected)
		btn.name = "CityButton_%s" % str(city.name)
		btn.position = Vector2(178, 78) + pos + Vector2(-47, 16)
		btn.pressed.connect(func(index := i) -> void:
			selected_city = index
			_build_ui()
		)
		root_layer.add_child(btn)


func _build_city_inspector() -> void:
	var city: Dictionary = cities[selected_city]
	var faction_color: Color = FACTIONS.get(str(city.faction), C.brass)
	var panel := _panel("CityInspector", Rect2(896, 78, 368, 470), C.panel)
	var box := _vbox(panel, 5, 12)
	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 8)
	var crest := TextureRect.new()
	crest.name = "FactionCrest"
	crest.texture = _faction_crest_texture(str(city.faction))
	crest.custom_minimum_size = Vector2(42, 42)
	crest.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	crest.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	header.add_child(crest)
	var title_box := VBoxContainer.new()
	title_box.custom_minimum_size = Vector2(240, 44)
	title_box.add_child(_label(str(city.name), 22, C.text))
	title_box.add_child(_label("%s  /  City Lv.%d" % [str(city.faction), int(city.level)], 13, C.muted))
	header.add_child(title_box)
	box.add_child(header)
	box.add_child(_separator())
	var preview := TextureRect.new()
	preview.name = "CityPreviewImage"
	preview.texture = florence_city_texture
	preview.custom_minimum_size = Vector2(344, 76)
	preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	box.add_child(preview)
	box.add_child(_separator())
	var rows := [
		["Income", "%d G / turn" % int(city.income)],
		["Grain", "%d grain" % int(city.grain)],
		["Garrison", "%d troops" % int(city.garrison)],
		["Fort / Order", "Lv.%d / %d" % [int(city.fort), int(city.order)]],
		["Faith / Trade", "%d / %d" % [int(city.faith), int(city.trade)]]
	]
	for i in range(rows.size()):
		var row: Array = rows[i]
		box.add_child(_stat_row_icon(_city_stat_icon_texture(i), str(row[0]), str(row[1])))
	box.add_child(_separator())
	box.add_child(_small_label("Development slots", C.muted, false))
	var slot_row := HBoxContainer.new()
	slot_row.add_theme_constant_override("separation", 6)
	for slot_index in [5, 6, 7, 9]:
		slot_row.add_child(_development_slot(slot_index, "Lv.%d" % int(city.level) if slot_index != 9 else "LOCK"))
	box.add_child(slot_row)
	box.add_child(_small_label("Assigned officer", C.muted, false))
	box.add_child(_label(str(city.officer), 15, faction_color))
	var grid := GridContainer.new()
	grid.columns = 3
	grid.add_theme_constant_override("h_separation", 6)
	grid.add_theme_constant_override("v_separation", 6)
	var actions := [["Attack", 0, -1], ["Develop", 1, 1], ["Recruit", 2, 3], ["Spy", 5, 4], ["Workshop", 3, 6], ["Rest", 4, 7]]
	for action in actions:
		var action_bg := C.panel_2
		if str(action[0]) == "Attack":
			action_bg = C.war
		elif str(action[0]) == "Develop":
			action_bg = C.success
		elif str(action[0]) == "Spy":
			action_bg = C.intrigue
		var action_btn := _button(str(action[0]), Vector2(104, 28), action_bg)
		action_btn.icon = _command_icon_texture(int(action[1]))
		action_btn.expand_icon = true
		action_btn.icon_alignment = HORIZONTAL_ALIGNMENT_LEFT
		action_btn.add_theme_constant_override("icon_max_width", 18)
		action_btn.add_theme_constant_override("h_separation", 6)
		action_btn.pressed.connect(func(command_index := int(action[2])) -> void:
			if command_index < 0:
				show_battle()
			else:
				_run_city_command(command_index)
		)
		grid.add_child(action_btn)
	box.add_child(grid)


func _build_command_feedback_panel() -> void:
	var panel := _panel("CommandResultPanel", Rect2(178, 498, 706, 50), Color(C.panel.r, C.panel.g, C.panel.b, 0.94))
	var row := _hbox(panel, 10, 10)
	var tone_color := C.brass
	if str(last_command_result.tone) == "success":
		tone_color = C.success
	elif str(last_command_result.tone) == "failure":
		tone_color = C.war
	elif str(last_command_result.tone) == "partial":
		tone_color = C.muted
	var status := _label(str(last_command_result.result), 12, tone_color)
	status.custom_minimum_size = Vector2(76, 28)
	status.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	row.add_child(status)
	var text_box := VBoxContainer.new()
	text_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	text_box.add_theme_constant_override("separation", 0)
	row.add_child(text_box)
	text_box.add_child(_label(str(last_command_result.title), 13, C.text))
	text_box.add_child(_small_label("%s  /  %s" % [str(last_command_result.detail), str(last_command_result.effects)], C.muted, false))
	var mod_label := "Mods %+d" % _battle_advantage_bonus()
	if event_candidates.size() > 0:
		mod_label = "Event %d" % event_candidates.size()
	var chip := _chip(mod_label, C.panel_2, C.brass)
	chip.custom_minimum_size = Vector2(92, 28)
	row.add_child(chip)


func _build_battle() -> void:
	_build_player_army_panel()
	_build_enemy_army_panel()
	_build_officer_detail_panel()
	_build_prediction_panel()
	_build_skill_dock()
	_build_formation_labels()


func _build_player_army_panel() -> void:
	var panel := _panel("PlayerArmyList", BATTLE_PLAYER_ARMY_RECT, C.panel)
	var box := _vbox(panel, 5, 8)
	box.add_child(_label("PLAYER ARMY  6/6", 11, C.brass))
	box.add_child(_separator())
	for i in range(officers.size()):
		var officer: Dictionary = officers[i]
		box.add_child(_army_row(
			str(officer.name),
			str(officer.role),
			"%s  HP %s" % [str(officer.troops), str(officer.hp)],
			_hp_ratio(str(officer.hp)),
			FACTIONS.Florence,
			i == ACTIVE_OFFICER_INDEX,
			_officer_portrait_texture(i),
			str(officer.status)
		))


func _build_enemy_army_panel() -> void:
	var panel := _panel("EnemyArmyList", BATTLE_ENEMY_ARMY_RECT, C.panel)
	var box := _vbox(panel, 5, 8)
	box.add_child(_label("ENEMY ARMY  6/6", 12, C.brass))
	box.add_child(_separator())
	for i in range(enemy_units.size()):
		var unit: Dictionary = enemy_units[i]
		box.add_child(_army_row(
			str(unit.name),
			str(unit.role),
			"%s  HP %s" % [str(unit.troops), str(unit.hp)],
			float(unit.ratio),
			FACTIONS.get("Papal States"),
			i == active_enemy_index,
			null,
			str(unit.status)
		))


func _build_officer_detail_panel() -> void:
	var officer: Dictionary = officers[ACTIVE_OFFICER_INDEX]
	var panel := _panel("SelectedOfficerDetail", BATTLE_OFFICER_DETAIL_RECT, C.panel)
	var row := _hbox(panel, 10, 8)
	var portrait := TextureRect.new()
	portrait.name = "SelectedOfficerPortrait"
	portrait.texture = _officer_portrait_texture(ACTIVE_OFFICER_INDEX)
	portrait.custom_minimum_size = Vector2(92, 118)
	portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	row.add_child(portrait)

	var box := VBoxContainer.new()
	box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.add_theme_constant_override("separation", 3)
	row.add_child(box)
	box.add_child(_label("SELECTED COMMANDER", 10, C.brass))
	box.add_child(_label(str(officer.name), 20, C.text))
	box.add_child(_small_label(str(officer.role), C.muted, false))
	box.add_child(_stat_bar(224, 6, _hp_ratio(str(officer.hp)), C.success))
	box.add_child(_small_label("%s troops  /  HP %s  /  STA %d  /  BND %d" % [str(officer.troops), str(officer.hp), int(officer.stamina), int(officer.bond)], C.text, false))
	box.add_child(_small_label("Oath active: siege engines gain wall pressure and turn preview clarity.", C.muted, true))


func _build_prediction_panel() -> void:
	var skill: Dictionary = skills[selected_skill]
	var panel := _panel("BattlePredictionPanel", BATTLE_FORECAST_RECT, C.panel)
	var box := _vbox(panel, 2, 6)
	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 8)
	var title := _label("Forecast", 16, C.text)
	title.custom_minimum_size = Vector2(126, 22)
	header.add_child(title)
	var skill_name := _label(str(skill.name), 13, C.brass)
	skill_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	skill_name.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(skill_name)
	box.add_child(header)
	var projected_capture := clampi(battle_capture_pressure + _battle_capture_gain(skill), 0, 95)
	var rows := [
		["Damage", "0%" if str(skill.name) == "Rally" else "-%d%%" % int(round(_battle_damage_ratio(skill) * 100.0))],
		["Morale", "%+d" % min(0, int(skill.morale))],
		["Advantage", "%+d" % (int(skill.adv) + _current_battle_advantage())],
		["Risk", str(skill.risk)],
		["Wall", "+%d%%" % (18 + _battle_wall_bonus()) if str(skill.name) == "Cannon" else "+%d%%" % (4 + _battle_wall_bonus())],
		["Capture", "0%" if str(skill.name) == "Rally" else "%d%%" % projected_capture]
	]
	var grid := GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 6)
	grid.add_theme_constant_override("v_separation", 2)
	for row in rows:
		grid.add_child(_compact_stat(str(row[0]), str(row[1])))
	box.add_child(grid)
	var modifier_names := _battle_modifier_names()
	var footer := "City prep active: %s" % modifier_names if modifier_names != "" else "Commit spends AP and advances turn order."
	var aftermath := _after_battle_summary()
	if aftermath != "":
		footer = aftermath
	var footer_label := _small_label(footer, C.muted, true)
	footer_label.add_theme_font_size_override("font_size", 9)
	footer_label.custom_minimum_size = Vector2(286, 28)
	box.add_child(footer_label)


func _build_skill_dock() -> void:
	var panel := _panel("BattleSkillDock", BATTLE_SKILL_DOCK_RECT, C.panel)
	var box := _vbox(panel, 6, 8)
	box.add_child(_label("Skill Dock", 16, C.text))
	var grid := GridContainer.new()
	grid.columns = 3
	grid.add_theme_constant_override("h_separation", 8)
	grid.add_theme_constant_override("v_separation", 8)
	for i in range(skills.size()):
		var skill: Dictionary = skills[i]
		var btn := _button("%s   AP %d\nDMG %d  CD %d" % [str(skill.name), int(skill.ap), int(skill.damage), int(skill.cd)], Vector2(172, 44), C.selected if i == selected_skill else C.panel_2)
		btn.name = "SkillButton_%s" % str(skill.name)
		btn.icon = _skill_icon_texture(i)
		btn.expand_icon = true
		btn.icon_alignment = HORIZONTAL_ALIGNMENT_LEFT
		btn.add_theme_constant_override("icon_max_width", 28)
		btn.add_theme_constant_override("h_separation", 7)
		btn.disabled = ap_current < int(skill.ap)
		btn.pressed.connect(func(index := i) -> void:
			_run_battle_action(index)
		)
		grid.add_child(btn)
	box.add_child(grid)


func _build_formation_labels() -> void:
	var board := Control.new()
	board.name = "BattleFormationBoard"
	board.position = BATTLE_BOARD_RECT.position
	board.size = BATTLE_BOARD_RECT.size
	board.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root_layer.add_child(board)

	_add_turn_order_strip(board)
	for lane in range(3):
		var y := 72 + lane * 118
		for col in range(2):
			var ally_x := 72 + col * 118
			_add_formation_token(board, ally_formation[lane][col], Vector2(ally_x, y), FACTIONS.Florence, false)
			var enemy_x := 458 + col * 118
			_add_formation_token(board, enemy_formation[lane][col], Vector2(enemy_x, y), FACTIONS.get("Papal States"), true)


func _add_turn_order_strip(parent: Control) -> void:
	var strip := Control.new()
	strip.name = "BattleTurnOrderStrip"
	strip.position = Vector2(254, 1)
	strip.size = Vector2(494, 36)
	strip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(strip)

	var title := _label("TURN ORDER", 10, C.muted)
	title.position = Vector2(0, 9)
	title.size = Vector2(98, 16)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	strip.add_child(title)

	for i in range(battle_turn_order.size()):
		var entry: Dictionary = battle_turn_order[i]
		_add_turn_order_token(strip, entry, Vector2(118 + i * 31, 2), i == 0)


func _add_turn_order_token(parent: Control, entry: Dictionary, pos: Vector2, active: bool) -> void:
	var enemy := str(entry.side) == "enemy"
	var tint: Color = FACTIONS.get("Papal States") if enemy else FACTIONS.Florence
	var token := Panel.new()
	token.name = "TurnOrderIcon_%s" % str(entry.name).replace(" ", "_")
	token.position = pos
	token.size = Vector2(32, 32)
	token.clip_contents = true
	token.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var bg := Color(tint.r, tint.g, tint.b, 0.36 if active else 0.22)
	token.add_theme_stylebox_override("panel", _flat_style(bg, C.brass if active else tint, 999))
	parent.add_child(token)

	var icon := TextureRect.new()
	icon.name = "TurnOrderGlyph_%s" % str(entry.name).replace(" ", "_")
	icon.texture = _unit_squad_texture(int(entry.icon))
	icon.position = Vector2(-5, -7)
	icon.size = Vector2(42, 42)
	icon.custom_minimum_size = Vector2(42, 42)
	icon.modulate = Color(1.18, 1.14, 1.08, 1.0)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	token.add_child(icon)

	var badge := Panel.new()
	badge.name = "TurnOrderRank_%s" % str(entry.name).replace(" ", "_")
	badge.position = pos + Vector2(20, -5)
	badge.size = Vector2(14, 14)
	badge.mouse_filter = Control.MOUSE_FILTER_IGNORE
	badge.add_theme_stylebox_override("panel", _flat_style(C.brass if active else C.panel_2, C.brass, 999))
	parent.add_child(badge)
	var label := _label(str(entry.rank), 8, C.bg if active else C.text)
	label.set_anchors_preset(Control.PRESET_FULL_RECT)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	badge.add_child(label)


func _add_formation_token(parent: Control, slot: Dictionary, pos: Vector2, tint: Color, enemy: bool) -> void:
	var token := Panel.new()
	token.name = "FormationUnit_%s" % str(slot.name).replace(" ", "_")
	token.position = pos
	token.size = Vector2(108, 82)
	token.clip_contents = false
	token.mouse_filter = Control.MOUSE_FILTER_IGNORE
	token.add_theme_stylebox_override("panel", _flat_style(Color(C.panel.r, C.panel.g, C.panel.b, 0.22), tint, 5))
	parent.add_child(token)

	var ground := Panel.new()
	ground.name = "FormationGround_%s" % str(slot.name).replace(" ", "_")
	ground.position = Vector2(4, 45)
	ground.size = Vector2(66, 10)
	ground.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ground.add_theme_stylebox_override("panel", _flat_style(Color(0, 0, 0, 0.34), Color(tint.r, tint.g, tint.b, 0.0), 999))
	token.add_child(ground)

	var thumb := Control.new()
	thumb.name = "FormationThumb_%s" % str(slot.name).replace(" ", "_")
	thumb.position = Vector2(-6, -22)
	thumb.size = Vector2(76, 74)
	thumb.custom_minimum_size = Vector2(76, 74)
	thumb.clip_contents = false
	token.add_child(thumb)
	var icon := TextureRect.new()
	icon.name = "FormationIcon_%s" % str(slot.name).replace(" ", "_")
	icon.texture = _unit_squad_texture(int(slot.icon))
	icon.position = Vector2.ZERO
	icon.size = Vector2(76, 76)
	icon.custom_minimum_size = Vector2(76, 76)
	icon.modulate = Color(1.14, 1.10, 1.06, 1.0)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	thumb.add_child(icon)

	var turn := Panel.new()
	turn.name = "TurnBadge_%s" % str(slot.name).replace(" ", "_")
	turn.position = Vector2(5, 4)
	turn.size = Vector2(19, 19)
	turn.add_theme_stylebox_override("panel", _flat_style(tint, C.brass if not enemy else C.text, 999))
	token.add_child(turn)
	var turn_label := _label(str(slot.turn), 10, C.bg if not enemy else C.panel)
	turn_label.set_anchors_preset(Control.PRESET_FULL_RECT)
	turn_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	turn_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	turn.add_child(turn_label)

	var name_plate := Panel.new()
	name_plate.name = "FormationNamePlate_%s" % str(slot.name).replace(" ", "_")
	name_plate.position = Vector2(63, 5)
	name_plate.size = Vector2(40, 30)
	name_plate.mouse_filter = Control.MOUSE_FILTER_IGNORE
	name_plate.add_theme_stylebox_override("panel", _flat_style(Color(0, 0, 0, 0.28), Color(tint.r, tint.g, tint.b, 0.22), 4))
	token.add_child(name_plate)

	var name_label := _label(str(slot.name), 10, C.text)
	name_label.position = Vector2(2, 1)
	name_label.size = Vector2(36, 14)
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_plate.add_child(name_label)
	var role_label := _label(str(slot.role), 8, C.muted)
	role_label.position = Vector2(2, 15)
	role_label.size = Vector2(36, 12)
	role_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_plate.add_child(role_label)

	var status_color := C.intrigue if str(slot.state) == "Hex" else C.brass
	token.add_child(_token_badge("StatusBadge_%s" % str(slot.name).replace(" ", "_"), str(slot.state), Rect2(6, 48, 45, 15), Color(status_color.r, status_color.g, status_color.b, 0.24), status_color, 8))
	token.add_child(_token_badge("TroopChip_%s" % str(slot.name).replace(" ", "_"), str(slot.troops), Rect2(56, 48, 46, 15), Color(0, 0, 0, 0.26), C.text, 9))

	var bar := _stat_bar(90, 5, float(slot.hp), C.success if float(slot.hp) >= 0.8 else C.brass)
	bar.position = Vector2(9, 65)
	token.add_child(bar)
	_add_status_pips(token, Vector2(25, 73), int(slot.pips), tint)


func _token_badge(name: String, text: String, rect: Rect2, bg: Color, fg: Color, font_size: int) -> Panel:
	var badge := Panel.new()
	badge.name = name
	badge.position = rect.position
	badge.size = rect.size
	badge.mouse_filter = Control.MOUSE_FILTER_IGNORE
	badge.add_theme_stylebox_override("panel", _flat_style(bg, fg, 4))
	var label := _label(text, font_size, fg)
	label.set_anchors_preset(Control.PRESET_FULL_RECT)
	label.offset_left = 2
	label.offset_right = -2
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	badge.add_child(label)
	return badge


func _add_status_pips(parent: Control, pos: Vector2, count: int, tint: Color) -> void:
	for i in range(5):
		var pip := ColorRect.new()
		pip.name = "StatusPip_%d" % i
		pip.position = pos + Vector2(i * 10, 0)
		pip.size = Vector2(7, 4)
		pip.color = C.success if i < count else Color(tint.r, tint.g, tint.b, 0.22)
		parent.add_child(pip)


func _build_roster() -> void:
	var panel := _panel("OfficerRoster", Rect2(16, 560, 1010, 148), C.panel)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 6)
	row.set_anchors_preset(Control.PRESET_FULL_RECT)
	row.offset_left = 10
	row.offset_top = 10
	row.offset_right = -10
	row.offset_bottom = -10
	panel.add_child(row)
	for i in range(officers.size()):
		row.add_child(_officer_card(i))


func _officer_card(index: int) -> Control:
	var officer: Dictionary = officers[index]
	var panel := PanelContainer.new()
	panel.name = "OfficerCard_%s" % str(officer.name)
	panel.custom_minimum_size = Vector2(158, 118)
	panel.add_theme_stylebox_override("panel", _style(C.panel_2 if index != selected_skill else C.selected, C.border, 6))
	var h := HBoxContainer.new()
	h.add_theme_constant_override("separation", 6)
	h.add_theme_constant_override("margin_left", 6)
	panel.add_child(h)
	var portrait := TextureRect.new()
	portrait.name = "Portrait_%s" % str(officer.name)
	portrait.texture = _officer_portrait_texture(index)
	portrait.custom_minimum_size = Vector2(62, 100)
	portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	h.add_child(portrait)
	var box := VBoxContainer.new()
	box.custom_minimum_size = Vector2(72, 96)
	box.add_theme_constant_override("separation", 2)
	box.add_child(_label(str(officer.name), 14, C.text))
	box.add_child(_label(str(officer.role).replace(" / ", "/"), 9, C.muted))
	box.add_child(_label("%s  HP %s" % [str(officer.troops), str(officer.hp)], 9, C.text))
	box.add_child(_label("STA %d  BND %d" % [int(officer.stamina), int(officer.bond)], 9, C.muted))
	box.add_child(_label(str(officer.status), 11, C.brass))
	h.add_child(box)
	return panel


func _army_row(unit_name: String, role: String, state: String, hp_ratio: float, tint: Color, selected: bool, portrait: Texture2D = null, badge_text: String = "") -> Control:
	var panel := PanelContainer.new()
	panel.name = "ArmyRow_%s" % unit_name.replace(" ", "_")
	panel.custom_minimum_size = Vector2(0, 56)
	panel.add_theme_stylebox_override("panel", _style(C.selected if selected else C.panel_2, C.brass if selected else C.border, 5))

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 5)
	panel.add_child(row)

	if portrait != null:
		var portrait_rect := TextureRect.new()
		portrait_rect.name = "ArmyPortrait_%s" % unit_name.replace(" ", "_")
		portrait_rect.texture = portrait
		portrait_rect.custom_minimum_size = Vector2(34, 42)
		portrait_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		portrait_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		row.add_child(portrait_rect)
	else:
		var marker := ColorRect.new()
		marker.name = "ArmyMarker_%s" % unit_name.replace(" ", "_")
		marker.color = Color(tint.r, tint.g, tint.b, 0.85)
		marker.custom_minimum_size = Vector2(10, 42)
		row.add_child(marker)

	var text_box := VBoxContainer.new()
	text_box.add_theme_constant_override("separation", 1)
	text_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(text_box)
	text_box.add_child(_label(unit_name, 12, C.text))
	text_box.add_child(_label(role.replace(" / ", "/"), 9, C.muted))
	text_box.add_child(_label(state, 9, C.text))
	text_box.add_child(_stat_bar(76, 4, hp_ratio, C.success if hp_ratio >= 0.8 else C.brass))

	if badge_text != "":
		var badge := _label(badge_text, 9, C.brass if selected else C.muted)
		badge.custom_minimum_size = Vector2(40, 42)
		badge.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		badge.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		row.add_child(badge)
	return panel


func _stat_bar(width: float, height: float, ratio: float, color: Color) -> Control:
	var bar := Control.new()
	bar.custom_minimum_size = Vector2(width, height)
	var bg := ColorRect.new()
	bg.color = Color(1, 1, 1, 0.16)
	bg.size = Vector2(width, height)
	bar.add_child(bg)
	var fill := ColorRect.new()
	fill.color = color
	fill.size = Vector2(width * clampf(ratio, 0.0, 1.0), height)
	bar.add_child(fill)
	return bar


func _compact_stat(left: String, right: String) -> Control:
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(136, 18)
	panel.add_theme_stylebox_override("panel", _style(C.panel_2, C.border, 4))
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 4)
	panel.add_child(row)
	var l := _label(left, 9, C.muted)
	l.custom_minimum_size = Vector2(58, 16)
	var r := _label(right, 9, C.text)
	r.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	r.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(l)
	row.add_child(r)
	return panel


func _hp_ratio(hp: String) -> float:
	return clampf(hp.replace("%", "").to_float() / 100.0, 0.0, 1.0)


func _build_minimap() -> void:
	var panel := _panel("CampaignMiniMap", Rect2(1038, 560, 226, 148), C.panel)
	var map := TextureRect.new()
	map.name = "MiniMapImage"
	map.texture = campaign_minimap_texture
	map.position = Vector2(8, 14)
	map.size = Vector2(168, 98)
	map.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	map.stretch_mode = TextureRect.STRETCH_SCALE
	panel.add_child(map)
	var controls := VBoxContainer.new()
	controls.position = Vector2(184, 8)
	controls.size = Vector2(34, 132)
	controls.add_theme_constant_override("separation", 6)
	panel.add_child(controls)
	var zoom_in := _button("+", Vector2(34, 34), C.panel_2)
	var zoom_mid := _button("-", Vector2(34, 34), C.panel_2)
	var gear := _button("", Vector2(34, 34), C.panel_2)
	gear.icon = _top_action_icon_texture(4)
	gear.expand_icon = true
	gear.add_theme_constant_override("icon_max_width", 22)
	controls.add_child(zoom_in)
	controls.add_child(zoom_mid)
	controls.add_child(gear)


func _officer_portrait_texture(index: int) -> Texture2D:
	return _atlas_cell(officer_strip_texture, index, 6, false)


func _skill_icon_texture(index: int) -> Texture2D:
	return _atlas_cell(battle_skill_icon_strip_texture, index, 6, true)


func _unit_type_icon_texture(index: int) -> Texture2D:
	return _atlas_cell(battle_unit_icon_strip_texture, index, 6, true)


func _unit_squad_texture(index: int) -> Texture2D:
	return _atlas_cell(battle_unit_squad_strip_texture, index, 6, true)


func _command_icon_texture(index: int) -> Texture2D:
	return _atlas_cell(command_icon_strip_texture, index, 10, true)


func _hud_icon_texture(index: int) -> Texture2D:
	return _atlas_cell(hud_resource_icon_strip_texture, index, 11, true)


func _top_action_icon_texture(index: int) -> Texture2D:
	return _atlas_cell(top_action_icon_strip_texture, index, 5, true)


func _city_stat_icon_texture(index: int) -> Texture2D:
	return _atlas_cell(city_stat_icon_strip_texture, index, 10, true)


func _faction_crest_texture(faction: String) -> Texture2D:
	return _atlas_cell(faction_crest_strip_texture, int(FACTION_CREST_INDEX.get(faction, 0)), 6, true)


func _atlas_cell(texture: Texture2D, index: int, columns: int, square_crop: bool) -> Texture2D:
	if texture == null or columns <= 0:
		return null
	var source_size: Vector2 = texture.get_size()
	var cell_width: float = source_size.x / float(columns)
	var cell_height: float = cell_width if square_crop else source_size.y
	var cell_y: float = maxf(0.0, (source_size.y - cell_height) * 0.5)
	var cell_x: float = cell_width * clampi(index, 0, columns - 1)
	var atlas := AtlasTexture.new()
	atlas.atlas = texture
	atlas.region = Rect2(cell_x, cell_y, cell_width, cell_height)
	return atlas


func _draw_campaign_map() -> void:
	var map_rect := Rect2(178, 78, 706, 470)
	if campaign_map_texture != null:
		draw_texture_rect(campaign_map_texture, map_rect, false)
	else:
		draw_rect(map_rect, C.sea)
		_draw_grid(map_rect, Color(1, 1, 1, 0.055), 42.0)
	var offset := Vector2(178, 78)

	for i in range(cities.size()):
		var city: Dictionary = cities[i]
		var p: Vector2 = offset + Vector2(city.pos.x, city.pos.y)
		var color: Color = FACTIONS.get(str(city.faction), C.brass)
		var crest := _faction_crest_texture(str(city.faction))
		if crest != null:
			draw_texture_rect(crest, Rect2(p - Vector2(17, 17), Vector2(34, 34)), false)
		else:
			draw_circle(p, 9, color)
			draw_circle(p, 4, C.text)
		draw_arc(p, 20, 0, TAU, 32, Color("#58D8FF") if i == selected_city else C.border, 2.6)
		if i > 0:
			var prev: Dictionary = cities[i - 1]
			draw_dashed_line(offset + Vector2(prev.pos.x, prev.pos.y), p, C.road, 2.0, 8.0)
	draw_rect(map_rect, Color(C.brass.r, C.brass.g, C.brass.b, 0.65), false, 2.0)


func _draw_battle_board() -> void:
	var rect := BATTLE_BOARD_RECT
	if battle_background_texture != null:
		draw_texture_rect(battle_background_texture, rect, false)
		draw_rect(rect, Color(0.05, 0.07, 0.10, 0.32))
	else:
		draw_rect(rect, C.battle)
	_draw_grid(rect, Color(1, 1, 1, 0.05), 34.0)
	_draw_turn_order_strip(rect)
	draw_line(Vector2(rect.position.x + 379, rect.position.y + 34), Vector2(rect.position.x + 379, rect.end.y - 34), C.brass, 2.0)
	draw_string(ThemeDB.fallback_font, Vector2(rect.position.x + 68, rect.position.y + 48), "ALLY: BACK  |  FRONT", HORIZONTAL_ALIGNMENT_LEFT, -1, 15, C.muted)
	draw_string(ThemeDB.fallback_font, Vector2(rect.position.x + 442, rect.position.y + 48), "ENEMY: FRONT  |  BACK", HORIZONTAL_ALIGNMENT_LEFT, -1, 15, C.muted)
	var lanes := ["TOP", "MID", "BOTTOM"]
	for lane in range(3):
		var y := rect.position.y + 72 + lane * 118
		draw_string(ThemeDB.fallback_font, Vector2(rect.position.x + 16, y + 36), lanes[lane], HORIZONTAL_ALIGNMENT_LEFT, -1, 12, C.dim)
		draw_line(Vector2(rect.position.x + 44, y + 74), Vector2(rect.end.x - 24, y + 74), Color(1, 1, 1, 0.12), 1.0)
		for col in range(2):
			_draw_battle_slot(Vector2(rect.position.x + 72 + col * 118, y), FACTIONS.Florence, col == 1)
			_draw_battle_slot(Vector2(rect.position.x + 458 + col * 118, y), FACTIONS.get("Papal States"), col == 0)
	var skill: Dictionary = skills[selected_skill]
	var source := rect.position + Vector2(72 + 54, 72 + 2 * 118 + 41)
	var target := _enemy_board_center(active_enemy_index)
	var splash := target + Vector2(96, 82)
	_draw_target_vector(source, target, Color("#64BDF4"))
	_draw_target_vector(target, splash, C.war if str(skill.name) != "Rally" else C.success)
	draw_string(ThemeDB.fallback_font, target + Vector2(-52, -22), "%s preview" % str(skill.name), HORIZONTAL_ALIGNMENT_LEFT, -1, 12, C.text)


func _draw_turn_order_strip(rect: Rect2) -> void:
	var track := Rect2(rect.position + Vector2(362, 8), Vector2(386, 30))
	draw_rect(track, Color(0, 0, 0, 0.18))
	draw_rect(track, Color(C.brass.r, C.brass.g, C.brass.b, 0.22), false, 1.0)
	draw_line(track.position + Vector2(8, 15), track.end - Vector2(8, 15), Color(C.brass.r, C.brass.g, C.brass.b, 0.26), 1.0)


func _draw_battle_slot(pos: Vector2, tint: Color, front: bool) -> void:
	var rect := Rect2(pos, Vector2(108, 82))
	draw_rect(rect, Color(tint.r, tint.g, tint.b, 0.10))
	draw_rect(rect, tint if front else Color(tint.r, tint.g, tint.b, 0.46), false, 1.5)
	draw_circle(pos + Vector2(54, 41), 24, Color(tint.r, tint.g, tint.b, 0.10))
	draw_arc(pos + Vector2(54, 41), 26, 0, TAU, 32, Color(tint.r, tint.g, tint.b, 0.35), 1.2)


func _draw_target_vector(start_pos: Vector2, end_pos: Vector2, color: Color) -> void:
	draw_line(start_pos, end_pos, Color(color.r, color.g, color.b, 0.82), 3.0)
	draw_circle(start_pos, 4, color)
	draw_circle(end_pos, 5, color)
	var direction := (end_pos - start_pos).normalized()
	var side := Vector2(-direction.y, direction.x)
	var tip := end_pos
	var left := end_pos - direction * 13 + side * 6
	var right := end_pos - direction * 13 - side * 6
	draw_colored_polygon(PackedVector2Array([tip, left, right]), color)


func _draw_grid(rect: Rect2, color: Color, step: float) -> void:
	var x := rect.position.x
	while x <= rect.end.x:
		draw_line(Vector2(x, rect.position.y), Vector2(x, rect.end.y), color, 1.0)
		x += step
	var y := rect.position.y
	while y <= rect.end.y:
		draw_line(Vector2(rect.position.x, y), Vector2(rect.end.x, y), color, 1.0)
		y += step


func _panel(name: String, rect: Rect2, color: Color) -> Panel:
	var panel := Panel.new()
	panel.name = name
	panel.position = rect.position
	panel.size = rect.size
	panel.add_theme_stylebox_override("panel", _style(color, C.border, 6))
	root_layer.add_child(panel)
	return panel


func _style(bg: Color, border: Color, radius: int) -> StyleBox:
	var skin_index := _skin_index_for_bg(bg, radius)
	if skin_index >= 0:
		return _skin_style(skin_index)
	return _flat_style(bg, border, radius)


func _flat_style(bg: Color, border: Color, radius: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = bg
	style.border_color = border
	style.set_border_width_all(1)
	style.set_corner_radius_all(radius)
	style.content_margin_left = 8
	style.content_margin_right = 8
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	return style


func _transparent_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0, 0, 0, 0)
	style.border_color = Color(0, 0, 0, 0)
	style.set_border_width_all(0)
	style.content_margin_left = 0
	style.content_margin_right = 0
	style.content_margin_top = 0
	style.content_margin_bottom = 0
	return style


func _skin_index_for_bg(bg: Color, radius: int) -> int:
	if ui_skin_atlas_texture == null or bg.a < 0.05 or radius >= 100:
		return -1
	if _same_color(bg, C.panel):
		return 0
	if _same_color(bg, C.war):
		return 3
	if _same_color(bg, C.success):
		return 4
	if _same_color(bg, C.intrigue):
		return 5
	if _same_color(bg, C.selected) or _same_color(bg, C.brass):
		return 2
	if _same_color(bg, C.panel_2):
		return 1
	return -1


func _skin_style(index: int) -> StyleBoxTexture:
	var style := StyleBoxTexture.new()
	style.texture = _skin_texture(index)
	style.set_texture_margin(SIDE_LEFT, 12.0)
	style.set_texture_margin(SIDE_RIGHT, 12.0)
	style.set_texture_margin(SIDE_TOP, 12.0)
	style.set_texture_margin(SIDE_BOTTOM, 12.0)
	style.axis_stretch_horizontal = StyleBoxTexture.AXIS_STRETCH_MODE_STRETCH
	style.axis_stretch_vertical = StyleBoxTexture.AXIS_STRETCH_MODE_STRETCH
	style.content_margin_left = 8
	style.content_margin_right = 8
	style.content_margin_top = 7
	style.content_margin_bottom = 7
	return style


func _skin_texture(index: int) -> Texture2D:
	return _atlas_cell(ui_skin_atlas_texture, index, 6, true)


func _command_button_frame_texture(index: int) -> Texture2D:
	return _atlas_cell(command_button_frame_atlas_texture, index, 10, false)


func _command_medallion_texture(index: int) -> Texture2D:
	return _atlas_cell(command_medallion_icon_atlas_texture, index, 10, false)


func _same_color(a: Color, b: Color) -> bool:
	return absf(a.r - b.r) < 0.002 and absf(a.g - b.g) < 0.002 and absf(a.b - b.b) < 0.002 and absf(a.a - b.a) < 0.002


func _hbox(parent: Control, gap: int, margin: int) -> HBoxContainer:
	var box := HBoxContainer.new()
	box.add_theme_constant_override("separation", gap)
	box.set_anchors_preset(Control.PRESET_FULL_RECT)
	box.offset_left = margin
	box.offset_right = -margin
	box.offset_top = margin
	box.offset_bottom = -margin
	parent.add_child(box)
	return box


func _vbox(parent: Control, gap: int, margin: int) -> VBoxContainer:
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", gap)
	box.set_anchors_preset(Control.PRESET_FULL_RECT)
	box.offset_left = margin
	box.offset_right = -margin
	box.offset_top = margin
	box.offset_bottom = -margin
	parent.add_child(box)
	return box


func _label(text: String, size_px: int, color: Color) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_color_override("font_color", color)
	label.add_theme_font_size_override("font_size", size_px)
	label.autowrap_mode = TextServer.AUTOWRAP_OFF
	label.clip_text = true
	label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	return label


func _small_label(text: String, color: Color, wrap: bool) -> Label:
	var label := _label(text, 11, color)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART if wrap else TextServer.AUTOWRAP_OFF
	return label


func _mode_button(text: String, target_mode: String) -> Button:
	var btn := _button(text, Vector2(112, 34), C.selected if mode == target_mode else C.panel_2)
	btn.name = "Mode_%s" % text
	btn.pressed.connect(func() -> void:
		mode = target_mode
		_build_ui()
	)
	return btn


func _button(text: String, min_size: Vector2, bg: Color) -> Button:
	var btn := Button.new()
	btn.text = text
	btn.custom_minimum_size = min_size
	btn.add_theme_stylebox_override("normal", _style(bg, C.border, 5))
	btn.add_theme_stylebox_override("hover", _style(C.selected, C.brass, 5))
	btn.add_theme_stylebox_override("pressed", _style(C.brass, C.brass, 5))
	btn.add_theme_stylebox_override("disabled", _style(Color(C.panel_2.r, C.panel_2.g, C.panel_2.b, 0.54), C.dim, 5))
	btn.add_theme_color_override("font_color", C.text)
	btn.add_theme_color_override("font_hover_color", C.text)
	btn.add_theme_color_override("font_pressed_color", C.bg)
	btn.add_theme_color_override("font_disabled_color", C.dim)
	btn.add_theme_font_size_override("font_size", 12)
	return btn


func _command_button(command: String, icon_index: int, badge_text: String = "") -> Control:
	var wrapper := Control.new()
	wrapper.name = "Command_%s" % command
	wrapper.custom_minimum_size = Vector2(140, 38)
	var skin := TextureRect.new()
	skin.name = "Skin_%s" % command
	skin.texture = _command_button_frame_texture(icon_index)
	skin.position = Vector2.ZERO
	skin.size = Vector2(140, 38)
	skin.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	skin.stretch_mode = TextureRect.STRETCH_SCALE
	skin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	wrapper.add_child(skin)

	var medallion := TextureRect.new()
	medallion.name = "Medallion_%s" % command
	medallion.texture = _command_medallion_texture(icon_index)
	medallion.position = Vector2(3, 1)
	medallion.size = Vector2(36, 36)
	medallion.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	medallion.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	medallion.mouse_filter = Control.MOUSE_FILTER_IGNORE
	wrapper.add_child(medallion)

	var label := _label(command, 12, C.text)
	label.position = Vector2(56, 1)
	label.size = Vector2(78, 35)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	wrapper.add_child(label)

	var hit := Button.new()
	hit.name = "Hit_%s" % command
	hit.text = ""
	hit.position = Vector2.ZERO
	hit.size = Vector2(140, 38)
	hit.custom_minimum_size = Vector2(140, 38)
	hit.add_theme_stylebox_override("normal", _transparent_style())
	hit.add_theme_stylebox_override("hover", _transparent_style())
	hit.add_theme_stylebox_override("pressed", _transparent_style())
	wrapper.add_child(hit)
	if badge_text != "":
		_add_command_badge(wrapper, badge_text)
	return wrapper


func _add_command_badge(parent: Control, text: String) -> void:
	var badge := Panel.new()
	badge.name = "CommandBadge"
	badge.position = Vector2(115, -4)
	badge.size = Vector2(18, 18)
	badge.custom_minimum_size = Vector2(18, 18)
	badge.mouse_filter = Control.MOUSE_FILTER_IGNORE
	badge.add_theme_stylebox_override("panel", _flat_style(Color("#8F2D24"), C.brass, 999))
	var label := _label(text, 11, C.text)
	label.set_anchors_preset(Control.PRESET_FULL_RECT)
	label.offset_left = 0
	label.offset_top = -1
	label.offset_right = 0
	label.offset_bottom = 0
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	badge.add_child(label)
	parent.add_child(badge)


func _chip(text: String, bg: Color, color: Color, icon: Texture2D = null) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", _style(bg, C.border, 5))
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 3)
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	panel.add_child(row)
	if icon != null:
		var icon_rect := TextureRect.new()
		icon_rect.texture = icon
		icon_rect.custom_minimum_size = Vector2(17, 17)
		icon_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		row.add_child(icon_rect)
	var label := _label(text, 10, color)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(label)
	return panel


func _stat_row(left: String, right: String) -> Control:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 6)
	var l := _label(left, 12, C.muted)
	l.custom_minimum_size = Vector2(90, 18)
	var r := _label(right, 12, C.text)
	r.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	r.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(l)
	row.add_child(r)
	return row


func _stat_row_icon(icon: Texture2D, left: String, right: String) -> Control:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 6)
	var icon_rect := TextureRect.new()
	icon_rect.texture = icon
	icon_rect.custom_minimum_size = Vector2(18, 18)
	icon_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	row.add_child(icon_rect)
	var l := _label(left, 12, C.muted)
	l.custom_minimum_size = Vector2(82, 18)
	var r := _label(right, 12, C.text)
	r.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	r.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(l)
	row.add_child(r)
	return row


func _development_slot(icon_index: int, caption: String) -> Control:
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(78, 44)
	panel.add_theme_stylebox_override("panel", _style(C.panel_2, C.border, 5))
	var box := HBoxContainer.new()
	box.add_theme_constant_override("separation", 4)
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	panel.add_child(box)
	var icon := TextureRect.new()
	icon.texture = _city_stat_icon_texture(icon_index)
	icon.custom_minimum_size = Vector2(24, 24)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	box.add_child(icon)
	var label := _label(caption, 10, C.text if icon_index != 9 else C.dim)
	label.custom_minimum_size = Vector2(30, 18)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(label)
	return panel


func _separator() -> ColorRect:
	var line := ColorRect.new()
	line.custom_minimum_size = Vector2(1, 1)
	line.color = Color(1, 1, 1, 0.14)
	return line


func _vline() -> ColorRect:
	var line := ColorRect.new()
	line.custom_minimum_size = Vector2(1, 30)
	line.color = Color(1, 1, 1, 0.18)
	return line
