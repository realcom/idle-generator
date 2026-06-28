extends RefCounted

const ASSET_ROOTS := [
	"export_data/assets/growstone2",
	"../../../assets/growstone2",
	"../../assets/growstone2",
]
const HERO_FRAME_SIZE := Vector2(48.0, 48.0)
const HERO_FRAME_COUNT := 11

const FILES := {
	"hero": "source/taskstone/hero.png",
	"monster_basic": "runtime/units/monsters/mine_worker_0034.png",
	"monster_elite": "runtime/units/monsters/mine_guard_0035.png",
	"monster_boss": "runtime/units/monsters/mine_boss_0036.png",
	"rock": "source/taskstone/rock.png",
	"stone0": "source/taskstone/stone0.png",
	"stone1": "source/taskstone/stone1.png",
	"stone2": "source/taskstone/stone2.png",
	"fx_hit_blue": "effect/Effect_001.png",
	"fx_hit_dust": "effect/Effect_002.png",
	"fx_hit_white": "effect/Effect_003.png",
	"fx_skill_orb": "effect/skill5-Sheet.png",
	"fx_shield": "effect/Shield_Sheet_Up3.png",
	"fx_fireball": "effect/2019.02.26/fireball(112.47).png",
	"fx_fireball_boom": "effect/2019.02.26/fireball_boom(135.166).png",
	"fx_boss_crack_large": "effect/boss skill_effect1.png",
	"fx_boss_crack_small": "effect/boss skill_effect2.png",
	"fx_mob_spawn": "effect/2026/Effect_Mob_Spawn.png",
	"fx_mob_spawn_m": "effect/2026/Effect_Mob_Spawn_M.png",
	"fx_mob_spawn_l": "effect/2026/Effect_Mob_Spawn_L.png",
	"fx_solar_damage": "effect/solarstone_damage_effect4.png",
	"fx_stone_fusion": "effect/2026/Effect_StoneFusion.png",
	"fx_moonslash_cast": "effect/2026/Seluna_MoonSlash_Casting.png",
	"fx_moonslash": "effect/2026/Seluna_MoonSlash_Shoot.png",
	"fx_fullmoon_cast": "effect/2026/Seluna_FullMoon_Casting.png",
	"fx_bloodmoon": "effect/2026/Seluna_BloodMoon_Shoot.png",
	"fx_bloodmoon_cast": "effect/2026/Seluna_BloodMoon_Casting.png",
	"fx_tortoise_tail_normal": "effect/2026/FX_Tortoise_Tail_Normal.png",
	"fx_tortoise_tail_rare": "effect/2026/FX_Tortoise_Tail_Rare.png",
	"fx_tortoise_tail_unique": "effect/2026/FX_Tortoise_Tail_Unique.png",
	"coin": "source/taskstone/coin.png",
	"ruby": "source/taskstone/ruby.png",
	"inner": "source/taskstone/inner.png",
	"bar_frame": "source/taskstone/bar_frame.png",
	"bar_fill": "source/taskstone/bar_fill.png",
}

const EFFECT_FRAMES := {
	"fx_hit_blue": {"size": Vector2(64.0, 64.0), "count": 7},
	"fx_hit_dust": {"size": Vector2(64.0, 64.0), "count": 6},
	"fx_hit_white": {"size": Vector2(64.0, 64.0), "count": 6},
	"fx_skill_orb": {"size": Vector2(70.0, 62.0), "count": 4},
	"fx_shield": {"size": Vector2(43.0, 62.0), "count": 11},
	"fx_fireball": {"size": Vector2(112.0, 47.0), "count": 13},
	"fx_fireball_boom": {"size": Vector2(135.0, 166.0), "count": 15},
	"fx_boss_crack_large": {"size": Vector2(128.0, 128.0), "count": 8},
	"fx_boss_crack_small": {"size": Vector2(64.0, 64.0), "count": 8},
	"fx_mob_spawn": {"size": Vector2(64.0, 64.0), "count": 16},
	"fx_mob_spawn_m": {"size": Vector2(128.0, 128.0), "count": 12},
	"fx_mob_spawn_l": {"size": Vector2(168.0, 128.0), "count": 16},
	"fx_solar_damage": {"size": Vector2(391.0, 390.0), "count": 4},
	"fx_stone_fusion": {"size": Vector2(128.0, 128.0), "count": 8},
	"fx_moonslash_cast": {"size": Vector2(128.0, 128.0), "count": 4},
	"fx_moonslash": {"size": Vector2(128.0, 128.0), "count": 4},
	"fx_fullmoon_cast": {"size": Vector2(128.0, 180.0), "count": 8},
	"fx_bloodmoon": {"size": Vector2(32.0, 104.0), "count": 4},
	"fx_bloodmoon_cast": {"size": Vector2(128.0, 128.0), "count": 4},
	"fx_tortoise_tail_normal": {"size": Vector2(64.0, 128.0), "count": 7},
	"fx_tortoise_tail_rare": {"size": Vector2(64.0, 128.0), "count": 7},
	"fx_tortoise_tail_unique": {"size": Vector2(64.0, 128.0), "count": 7},
}

const UNIT_TEXTURE_KEYS := {
	110111: "hero",
	110201: "monster_basic",
	110202: "monster_elite",
	110501: "monster_boss",
}

const ITEM_TEXTURE_KEYS := {
	3: "ruby",
	4: "ruby",
	5: "coin",
	6: "coin",
	200101: "stone0",
	200102: "stone1",
	200103: "ruby",
	200201: "rock",
	200202: "stone0",
	200203: "stone1",
	200204: "stone2",
	200205: "rock",
	200206: "stone0",
	200207: "stone1",
	200208: "stone2",
	200209: "rock",
	200210: "stone2",
	200211: "rock",
}

const EQUIPMENT_SLOT_TEXTURE_PREFIXES := [
	"head",
	"chest",
	"gloves",
	"boots",
	"necklace",
	"ring",
]

const EQUIPMENT_STAGE_TEXTURE_NAMES := {
	1: "pebble",
	2: "moss",
	3: "crystal",
	4: "rust",
	5: "wraith",
	6: "lava",
	7: "frost",
	8: "border",
	9: "starcore",
	10: "origin",
}

const PLAYER_SKILL_EFFECT_KEYS := {
	300101: "rock",
	300102: "rock",
	300103: "stone0",
	300104: "stone1",
	300105: "stone2",
	300106: "fx_hit_blue",
	300107: "fx_fireball",
	300108: "fx_skill_orb",
	300109: "fx_moonslash",
	300110: "fx_stone_fusion",
	300111: "fx_bloodmoon",
	300301: "fx_hit_dust",
	300302: "fx_skill_orb",
	300303: "fx_moonslash",
	300304: "fx_boss_crack_small",
	300305: "fx_stone_fusion",
	300306: "fx_hit_dust",
	300307: "fx_hit_blue",
	300308: "fx_stone_fusion",
	300309: "fx_fireball_boom",
	300310: "fx_fireball",
	300311: "fx_boss_crack_small",
	300312: "fx_moonslash",
	300313: "fx_boss_crack_large",
	300314: "fx_bloodmoon",
	300315: "fx_bloodmoon_cast",
	300316: "fx_hit_blue",
	300317: "fx_skill_orb",
	300318: "fx_hit_dust",
	300319: "fx_boss_crack_small",
	300320: "fx_fireball_boom",
	300321: "fx_shield",
	300322: "fx_hit_white",
	300323: "fx_shield",
	300324: "fx_boss_crack_small",
	300325: "fx_boss_crack_large",
	300326: "fx_fireball",
	300327: "fx_stone_fusion",
	300328: "fx_skill_orb",
	300329: "fx_fireball_boom",
	300330: "fx_bloodmoon",
}

const SPRITE_REGIONS := {
	"runtime/units/monsters/legacy_monster_0007.png": Rect2(0.0, 0.0, 80.0, 80.0),
	"runtime/units/monsters/legacy_monster_0010.png": Rect2(0.0, 0.0, 64.0, 64.0),
	"runtime/units/monsters/legacy_monster_0013.png": Rect2(0.0, 0.0, 80.0, 80.0),
	"runtime/units/monsters/legacy_monster_0015.png": Rect2(0.0, 0.0, 48.0, 48.0),
	"runtime/units/monsters/legacy_monster_0030.png": Rect2(0.0, 0.0, 48.0, 48.0),
	"runtime/units/monsters/legacy_monster_0031.png": Rect2(0.0, 0.0, 48.0, 48.0),
	"runtime/units/monsters/legacy_monster_0032.png": Rect2(0.0, 0.0, 64.0, 64.0),
	"runtime/units/monsters/stone_mini_b10000.png": Rect2(0.0, 0.0, 32.0, 32.0),
	"runtime/units/monsters/abyss_osuarius.png": Rect2(0.0, 0.0, 128.0, 126.0),
	"runtime/units/monsters/abyss_osuarius_pivot.png": Rect2(0.0, 0.0, 128.0, 126.0),
	"runtime/units/monsters/border_spider_pivot.png": Rect2(0.0, 0.0, 53.0, 52.0),
	"runtime/units/monsters/border_revived_corpse.png": Rect2(0.0, 0.0, 36.0, 48.0),
	"runtime/units/monsters/border_wraith.png": Rect2(0.0, 0.0, 34.0, 58.0),
	"runtime/units/monsters/border_wraith_hound.png": Rect2(0.0, 0.0, 58.0, 59.0),
	"runtime/units/monsters/border_wraith_hound_pivot.png": Rect2(0.0, 0.0, 58.0, 59.0),
	"runtime/units/monsters/border_skeleton_archer.png": Rect2(0.0, 0.0, 39.0, 52.0),
	"runtime/units/monsters/foundation_giant_00204.png": Rect2(0.0, 0.0, 210.0, 210.0),
	"runtime/units/monsters/foundation_giant_00204b.png": Rect2(0.0, 0.0, 210.0, 210.0),
}

var textures := {}
var texture_paths := {}
var errors: Array[String] = []


func load_all() -> bool:
	textures.clear()
	errors.clear()
	for key in FILES.keys():
		var relative_path := str(FILES[key])
		var texture := _load_texture(relative_path)
		if texture != null:
			textures[str(key)] = texture
			texture_paths[str(key)] = relative_path
	return errors.is_empty()


func get_texture(key: String) -> Texture2D:
	return textures.get(key, null)


func texture_for_unit(unit_id: int, sprite_path := "") -> Texture2D:
	var key := str(UNIT_TEXTURE_KEYS.get(int(unit_id), ""))
	if key != "":
		return get_texture(key)

	var relative_path := _normalize_sprite_path(sprite_path)
	if relative_path != "":
		return _texture_for_path(relative_path)
	return get_texture("monster_basic")


func texture_for_item(item_id: int) -> Texture2D:
	var key := str(ITEM_TEXTURE_KEYS.get(int(item_id), ""))
	if key != "":
		return get_texture(key)
	var equipment_path := _equipment_texture_path_for_item(int(item_id))
	if equipment_path != "":
		return _texture_for_path(equipment_path)
	return get_texture("stone0")


func texture_for_item_icon(sprite_path: String) -> Texture2D:
	var relative_path := _normalize_sprite_path(sprite_path)
	if relative_path == "":
		return null
	return _texture_for_path_or_null(relative_path)


func effect_key_for_skill(skill_id: int) -> String:
	return str(PLAYER_SKILL_EFFECT_KEYS.get(int(skill_id), "fx_skill_orb"))


func has_effect_for_skill(skill_id: int) -> bool:
	var key := effect_key_for_skill(skill_id)
	return PLAYER_SKILL_EFFECT_KEYS.has(int(skill_id)) and FILES.has(key)


func region_for_unit(unit_id: int, sprite_path := "") -> Rect2:
	var key := str(UNIT_TEXTURE_KEYS.get(int(unit_id), ""))
	var relative_path := str(texture_paths.get(key, "")) if key != "" else _normalize_sprite_path(sprite_path)
	return SPRITE_REGIONS.get(relative_path, Rect2())


func hero_frame_region(frame: int) -> Rect2:
	var index: int = clamp(frame, 0, HERO_FRAME_COUNT - 1)
	return Rect2(Vector2(HERO_FRAME_SIZE.x * float(index), 0.0), HERO_FRAME_SIZE)


func effect_frame_region(key: String, progress: float) -> Rect2:
	var spec = EFFECT_FRAMES.get(key, {})
	if typeof(spec) != TYPE_DICTIONARY:
		return Rect2()
	var texture: Texture2D = get_texture(key)
	if texture == null:
		return Rect2()
	var frame_size: Vector2 = spec.get("size", Vector2(texture.get_width(), texture.get_height()))
	var frame_count: int = maxi(1, int(spec.get("count", 1)))
	var frame_index: int = clamp(int(floor(clampf(progress, 0.0, 0.9999) * float(frame_count))), 0, frame_count - 1)
	var columns: int = maxi(1, int(floor(float(texture.get_width()) / maxf(1.0, frame_size.x))))
	var row: int = int(floor(float(frame_index) / float(columns)))
	return Rect2(
		Vector2(frame_size.x * float(frame_index % columns), frame_size.y * float(row)),
		frame_size
	)


func asset_path(relative_path: String) -> String:
	for asset_root in ASSET_ROOTS:
		var path := "res://%s/%s" % [str(asset_root), relative_path]
		if ResourceLoader.exists(path) or FileAccess.file_exists(path):
			return path
	return "res://%s/%s" % [str(ASSET_ROOTS[0]), relative_path]


func _normalize_sprite_path(sprite_path: String) -> String:
	var relative_path := sprite_path.strip_edges()
	if relative_path == "":
		return ""
	if relative_path.begins_with("Assets/Taskstonebar/taskstone/"):
		return "source/taskstone/%s" % relative_path.get_file()
	if relative_path.begins_with("Assets/Taskstonebar/equipment/imagegen/icons/"):
		return "generated/equipment/imagegen/icons/%s" % relative_path.get_file()
	if relative_path.begins_with("assets/growstone2/"):
		return relative_path.trim_prefix("assets/growstone2/")
	if relative_path.begins_with("harness/assets/growstone2/"):
		return relative_path.trim_prefix("harness/assets/growstone2/")
	return relative_path


func _equipment_texture_path_for_item(item_id: int) -> String:
	var offset := int(item_id) - 200301
	if offset < 0 or offset >= EQUIPMENT_SLOT_TEXTURE_PREFIXES.size() * 10:
		return ""
	var slot_index := int(floor(float(offset) / 10.0))
	var grade := int(offset % 10) + 1
	var slot_prefix := str(EQUIPMENT_SLOT_TEXTURE_PREFIXES[slot_index])
	var stage_name := str(EQUIPMENT_STAGE_TEXTURE_NAMES.get(grade, ""))
	if stage_name == "":
		return ""
	return "generated/equipment/icon_%s_%02d_%s.png" % [slot_prefix, grade, stage_name]


func _texture_for_path(relative_path: String) -> Texture2D:
	var texture := _texture_for_path_or_null(relative_path)
	if texture != null:
		return texture
	return get_texture("monster_basic")


func _texture_for_path_or_null(relative_path: String) -> Texture2D:
	var key := "path:%s" % relative_path
	if textures.has(key):
		return textures[key]
	var texture := _load_texture(relative_path)
	if texture != null:
		textures[key] = texture
		texture_paths[key] = relative_path
		return texture
	return null


func _load_texture(filename: String) -> Texture2D:
	var path := asset_path(filename)
	if ResourceLoader.exists(path):
		var texture := load(path)
		if texture != null and texture is Texture2D:
			return texture as Texture2D

	if not FileAccess.file_exists(path):
		errors.append("Missing sprite %s" % path)
		return null

	var image := Image.new()
	var load_error := image.load(path)
	if load_error != OK:
		errors.append("Cannot load sprite %s: %s" % [path, error_string(load_error)])
		return null

	return ImageTexture.create_from_image(image)
