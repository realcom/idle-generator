extends RefCounted

const PLAYER_UNIT_ID := 110111
const LEAF_IMP_UNIT_ID := 110201
const SOOT_SPIRIT_UNIT_ID := 110202
const PURPLE_MUSHROOM_UNIT_ID := 110203
const BASIC_SKILL_ID := 300101
const STARTER_SKILL_IDS := [300101]
const D1_LEVEL_CHOICE_SKILL_IDS := [300102, 300103, 300115]
const BOSS_UNIT_ID := 110501

const RESOURCE_KEYS := ["gold", "wood", "stone", "soul"]
const RESOURCE_LABELS := {
	"gold": "골드",
	"wood": "목재",
	"stone": "석재",
	"soul": "영혼불",
}
const RESOURCE_ITEM_IDS := {
	"ruby": 3,
	"free_ruby": 4,
	"gold": 5,
	"energy": 8,
	"wood": 200101,
	"stone": 200102,
	"soul": 200103,
	"companion_shards": 200111,
}

const UNIT_TEXTURES := {
	110111: "battle/characters/guardian_hero.png",
	110201: "battle/characters/enemy_leaf_imp.png",
	110202: "battle/characters/enemy_soot_spirit.png",
	110203: "battle/characters/enemy_purple_mushroom.png",
	110501: "battle/characters/enemy_thorn_boss_full.png",
}

const RESOURCE_ICONS := {
	"gold": "ui/topbar/icon_coin.png",
	"wood": "ui/topbar/icon_wood.png",
	"stone": "ui/topbar/icon_stone.png",
	"soul": "ui/topbar/icon_soul.png",
}

const EQUIPMENT_ICON_BY_TYPE := {
	"Weapon": "items/flat-equipment/icon_weapon_lantern_kunai.png",
	"Head": "items/flat-equipment/icon_head_guardian_hood.png",
	"Chest": "items/flat-equipment/icon_chest_guardian_mantle.png",
	"Gloves": "items/flat-equipment/icon_gloves_work_gloves.png",
	"Boots": "items/flat-equipment/icon_boots_mist_sandals.png",
	"Necklace": "items/flat-equipment/icon_necklace_soulflame_pendant.png",
	"Ring": "items/flat-equipment/icon_ring_bamboo_ring.png",
}

const EQUIPMENT_EMPTY_SLOT_ICON_BY_SLOT := {
	"weapon": "ui/equipment-slots/icon_empty_weapon.png",
	"head": "ui/equipment-slots/icon_empty_head.png",
	"chest": "ui/equipment-slots/icon_empty_chest.png",
	"gloves": "ui/equipment-slots/icon_empty_gloves.png",
	"boots": "ui/equipment-slots/icon_empty_boots.png",
	"necklace": "ui/equipment-slots/icon_empty_necklace.png",
	"ring": "ui/equipment-slots/icon_empty_ring.png",
}

const UI_TEXTURES := {
	"home_bg": "home/background_forest_sanctuary.png",
	"title_splash": "ui/title/title_splash_selected.png",
	"title_logo": "ui/title/title_logo_namutip_maeul_grow_v1.png",
	"profile": "ui/profile_guardian.png",
	"player_walk_sheet": "battle/animations/guardian_hero_walk_3x8.png",
	"player_dir_down": "battle/directions/guardian_hero/down.png",
	"player_dir_left": "battle/directions/guardian_hero/left.png",
		"player_dir_right": "battle/directions/guardian_hero/right.png",
		"player_dir_up": "battle/directions/guardian_hero/up.png",
		"enemy_walk_leaf_imp": "battle/animations/enemy_leaf_imp_hop_3x4_v1.png",
		"enemy_float_soot_spirit": "battle/animations/enemy_soot_spirit_float_3x4_v1.png",
		"enemy_walk_purple_mushroom": "battle/animations/enemy_purple_mushroom_waddle_3x4_v2.png",
		"enemy_lumber_thorn_boss": "battle/animations/enemy_thorn_boss_lumber_3x4_v1.png",
		"panel": "ui/panel_parchment_9slice.png",
	"button": "ui/button_sortie_orange.png",
	"skill": "battle/skill-vfx/vfx_kunai_slash_arc.png",
	"skill_shuriken": "battle/skill-vfx/vfx_shuriken_streak.png",
	"skill_smoke": "battle/skill-vfx/vfx_smoke_burst.png",
	"skill_gale": "battle/skill-vfx/vfx_gale_trail.png",
	"skill_impact": "battle/skill-vfx/vfx_impact_flash.png",
	"skill_shadow_clone": "battle/skill-vfx/vfx_shadow_clone_blades.png",
	"skill_moon_flash": "battle/skill-vfx/vfx_moon_flash_arc.png",
	"skill_killing_focus": "battle/skill-vfx/vfx_killing_focus_sigil.png",
	"skill_time_fold": "battle/skill-vfx/vfx_time_fold_ring.png",
	"prop_bamboo": "battle/props/prop_bamboo_clump.png",
	"prop_lantern": "battle/props/prop_lantern_post.png",
	"prop_stones": "battle/props/prop_moss_stones.png",
	"prop_log": "battle/props/prop_fallen_log.png",
	"prop_shrine": "battle/props/prop_soul_shrine.png",
	"dash": "ui/battle-controls/icon_dash.png",
	"counter_time": "ui/battle-counters/counter_time.png",
	"counter_kill": "ui/battle-counters/counter_kill.png",
	"counter_enemy": "ui/battle-counters/counter_enemy.png",
	"counter_pickup": "ui/battle-counters/counter_pickup.png",
	"counter_boss": "ui/battle-counters/counter_boss.png",
	"encounter_bomb": "battle/encounters/encounter_bomb.png",
	"encounter_magnet": "battle/encounters/encounter_magnet.png",
	"encounter_potion": "battle/encounters/encounter_potion.png",
	"encounter_mine": "battle/encounters/encounter_mine.png",
	"result_backdrop": "ui/run-result/result_battle_backdrop.png",
		"result_clear_panel": "ui/run-result/result_status_clear_panel.png",
		"result_defeat_panel": "ui/run-result/result_status_defeat_panel.png",
		"result_clear_hero": "ui/run-result/result_hero_clear_overlay.png",
		"result_defeat_hero": "ui/run-result/result_hero_defeat_overlay.png",
		"result_clear_crest": "ui/run-result/result_crest_clear.png",
		"result_defeat_crest": "ui/run-result/result_crest_defeat.png",
		"result_crest": "ui/sanctuary-build/frame_crest.png",
		"result_reward_brush": "ui/run-result/result_reward_header_brush.png",
	"result_return_button": "ui/run-result/result_return_button_9slice.png",
	"shop_ruby_pouch": "ui/shop/shop_product_ruby_pouch.png",
	"shop_starter_pack": "ui/shop/shop_product_starter_pack.png",
	"shop_energy_refill": "ui/shop/shop_product_energy_refill.png",
	"shop_ad_removal": "ui/shop/shop_product_ad_removal_charm.png",
	"dungeon_wood": "ui/dungeons/icon_dungeon_woodcutting_trail.png",
	"dungeon_stone": "ui/dungeons/icon_dungeon_stone_underpass.png",
	"dungeon_companion": "ui/dungeons/icon_dungeon_companion_traces.png",
}


static func all_texture_paths() -> Dictionary:
	var paths := UI_TEXTURES.duplicate()
	for unit_id in UNIT_TEXTURES.keys():
		paths["unit_%d" % int(unit_id)] = UNIT_TEXTURES[unit_id]
	for key in RESOURCE_ICONS.keys():
		paths["res_%s" % key] = RESOURCE_ICONS[key]
	for key in EQUIPMENT_ICON_BY_TYPE.keys():
		paths["equip_%s" % key] = EQUIPMENT_ICON_BY_TYPE[key]
	for key in EQUIPMENT_EMPTY_SLOT_ICON_BY_SLOT.keys():
		paths["equip_empty_%s" % key] = EQUIPMENT_EMPTY_SLOT_ICON_BY_SLOT[key]
	return paths


static func resource_key_for_item_id(item_id: int) -> String:
	for key in RESOURCE_ITEM_IDS.keys():
		if int(RESOURCE_ITEM_IDS[key]) == int(item_id):
			return key
	return ""
