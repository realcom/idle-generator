extends Node

const NINJA2_PHASER_SCENE_PATH := "../src/survivor/survivor-app.js"
const FALLBACK_PHASER_SCENE_PATH := "../src/idlez-phaser/phaser-scene.js"
const PHASER_SETTINGS_STORAGE_KEY := "idlez.phaser.settings"
const DEFAULT_BGM_TRACKS := {
	"home": {
		"key": "ninja2-bgm-lantern-grove",
		"path": "assets/audio/lantern-grove.mp3",
		"volume": 0.34,
	},
	"expedition": {
		"key": "ninja2-bgm-bamboo-shuriken-run",
		"path": "assets/audio/bamboo-shuriken-run.mp3",
		"volume": 0.36,
	},
}
const DEFAULT_BGM_MODE_TRACKS := {
	"boot": "home",
	"home": "home",
	"result": "home",
	"expedition": "expedition",
}
const DEFAULT_SFX := {
	"uiClick": {"key": "ninja2-sfx-ui-click", "path": "assets/audio/sfx/ui_click.wav", "volume": 0.42, "cooldownMs": 45},
	"uiError": {"key": "ninja2-sfx-ui-error", "path": "assets/audio/sfx/ui_error.wav", "volume": 0.48, "cooldownMs": 180},
	"attack": {"key": "ninja2-sfx-attack-slash", "path": "assets/audio/sfx/attack_slash.wav", "volume": 0.32, "cooldownMs": 92},
	"hit": {"key": "ninja2-sfx-hit-monster", "path": "assets/audio/sfx/hit_monster.wav", "volume": 0.34, "cooldownMs": 82},
	"monsterDead": {"key": "ninja2-sfx-monster-dead", "path": "assets/audio/sfx/monster_dead.wav", "volume": 0.38, "cooldownMs": 135},
	"coin": {"key": "ninja2-sfx-coin-pickup", "path": "assets/audio/sfx/coin_pickup.wav", "volume": 0.32, "cooldownMs": 95},
	"reward": {"key": "ninja2-sfx-reward-get", "path": "assets/audio/sfx/reward_get.wav", "volume": 0.38, "cooldownMs": 150},
	"levelUp": {"key": "ninja2-sfx-level-up", "path": "assets/audio/sfx/level_up.wav", "volume": 0.44, "cooldownMs": 220},
}
const SFX_POOL_SIZE := 8

var bgm_tracks: Dictionary = DEFAULT_BGM_TRACKS.duplicate(true)
var bgm_mode_tracks: Dictionary = DEFAULT_BGM_MODE_TRACKS.duplicate(true)
var sfx_defs: Dictionary = DEFAULT_SFX.duplicate(true)
var settings: Dictionary = {
	"bgm": true,
	"sfx": true,
	"language": "ko",
}
var warnings: Array[String] = []
var current_mode := "home"
var current_bgm_key := ""

var bgm_player: AudioStreamPlayer
var sfx_players: Array[AudioStreamPlayer] = []
var bgm_streams: Dictionary = {}
var sfx_streams: Dictionary = {}
var sfx_last_played_at: Dictionary = {}
var next_sfx_player_index := 0


func _ready() -> void:
	_ensure_players()


func _ensure_players() -> void:
	if bgm_player != null:
		return
	process_mode = Node.PROCESS_MODE_ALWAYS
	bgm_player = AudioStreamPlayer.new()
	bgm_player.name = "BGM"
	add_child(bgm_player)
	for index in range(SFX_POOL_SIZE):
		var player := AudioStreamPlayer.new()
		player.name = "SFX_%02d" % index
		add_child(player)
		sfx_players.append(player)


func load_from_phaser() -> bool:
	warnings.clear()
	bgm_tracks = DEFAULT_BGM_TRACKS.duplicate(true)
	bgm_mode_tracks = DEFAULT_BGM_MODE_TRACKS.duplicate(true)
	sfx_defs = DEFAULT_SFX.duplicate(true)

	var parsed := false
	var source := _read_phaser_source(NINJA2_PHASER_SCENE_PATH)
	if source != "":
		parsed = _parse_ninja2_audio_source(source)
	if not parsed:
		var fallback_source := _read_phaser_source(FALLBACK_PHASER_SCENE_PATH)
		if fallback_source != "":
			parsed = _parse_fallback_audio_source(fallback_source)
	_load_streams()
	_sync_bgm()
	return parsed and warnings.is_empty()


func apply_settings(source_settings: Dictionary) -> Dictionary:
	settings["bgm"] = _setting_bool(source_settings, ["bgm", "bgmEnabled", "volume", "volumeEnabled"], true)
	settings["sfx"] = _setting_bool(source_settings, ["sfx", "sfxEnabled"], true)
	if source_settings.has("language"):
		settings["language"] = str(source_settings.get("language", settings.get("language", "ko")))
	_sync_bgm()
	return get_settings()


func set_bgm_enabled(enabled: bool) -> Dictionary:
	settings["bgm"] = enabled
	_sync_bgm()
	return get_settings()


func set_sfx_enabled(enabled: bool) -> Dictionary:
	settings["sfx"] = enabled
	return get_settings()


func set_mode(mode: String) -> void:
	var next_mode := str(mode)
	if next_mode == "":
		next_mode = "home"
	if current_mode == next_mode:
		return
	current_mode = next_mode
	_sync_bgm()


func get_settings() -> Dictionary:
	return {
		"bgm": bool(settings.get("bgm", true)),
		"sfx": bool(settings.get("sfx", true)),
		"bgmEnabled": bool(settings.get("bgm", true)),
		"volumeEnabled": bool(settings.get("bgm", true)),
		"sfxEnabled": bool(settings.get("sfx", true)),
		"language": str(settings.get("language", "ko")),
		"storageKey": PHASER_SETTINGS_STORAGE_KEY,
	}


func get_config() -> Dictionary:
	return {
		"mode": current_mode,
		"bgm": _background_track_for_mode(current_mode).duplicate(true),
		"bgmTracks": bgm_tracks.duplicate(true),
		"bgmModeTracks": bgm_mode_tracks.duplicate(true),
		"sfx": sfx_defs.duplicate(true),
		"warnings": warnings.duplicate(),
	}


func play_sfx(name: String, options: Dictionary = {}) -> bool:
	if _is_headless() or not bool(settings.get("sfx", true)):
		return false
	if not sfx_defs.has(name) or not sfx_streams.has(name):
		return false

	var def: Dictionary = sfx_defs[name]
	var now_ms := Time.get_ticks_msec()
	var cooldown_ms := int(options.get("cooldownMs", def.get("cooldownMs", 0)))
	var last_played := int(sfx_last_played_at.get(name, -1000000000))
	if cooldown_ms > 0 and now_ms - last_played < cooldown_ms:
		return false
	sfx_last_played_at[name] = now_ms

	var player := _next_sfx_player()
	if player == null:
		return false
	player.stop()
	player.stream = sfx_streams[name]
	var volume := clampf(float(def.get("volume", 1.0)) * float(options.get("volume", 1.0)), 0.0, 1.0)
	player.volume_db = _linear_volume_to_db(volume)
	var detune_scale := pow(2.0, float(options.get("detune", 0.0)) / 1200.0)
	player.pitch_scale = maxf(0.01, float(options.get("rate", 1.0)) * detune_scale)
	player.play()
	return true


func _read_phaser_source(relative_path: String) -> String:
	var path := ProjectSettings.globalize_path("res://%s" % relative_path)
	if not FileAccess.file_exists(path):
		warnings.append("Missing Phaser audio source: %s" % path)
		return ""
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		warnings.append("Cannot read Phaser audio source: %s" % error_string(FileAccess.get_open_error()))
		return ""
	return file.get_as_text()


func _parse_ninja2_audio_source(source: String) -> bool:
	var parsed_any := false
	var parsed_bgm := _parse_named_defs(source, "const NINJA2_BGM_TRACKS")
	if not parsed_bgm.is_empty():
		bgm_tracks = parsed_bgm
		parsed_any = true
	else:
		warnings.append("Could not parse NINJA2_BGM_TRACKS from Phaser survivor runtime; using defaults")

	var parsed_modes := _parse_mode_tracks(source, "const NINJA2_BGM_MODE_TRACKS")
	if not parsed_modes.is_empty():
		bgm_mode_tracks = parsed_modes
		parsed_any = true
	else:
		warnings.append("Could not parse NINJA2_BGM_MODE_TRACKS from Phaser survivor runtime; using defaults")

	var parsed_sfx := _parse_named_defs(source, "const NINJA2_SFX")
	if not parsed_sfx.is_empty():
		sfx_defs = parsed_sfx
		parsed_any = true
	else:
		warnings.append("Could not parse NINJA2_SFX from Phaser survivor runtime; using defaults")
	return parsed_any


func _parse_fallback_audio_source(source: String) -> bool:
	var parsed_any := false
	var bgm_key := _regex_string(source, "const\\s+BGM_KEY\\s*=\\s*['\\\"]([^'\\\"]+)['\\\"]")
	var bgm_path := _regex_string(source, "const\\s+BGM_PATH\\s*=\\s*['\\\"]([^'\\\"]+)['\\\"]")
	if bgm_key != "" or bgm_path != "":
		bgm_tracks = {
			"home": {
				"key": bgm_key if bgm_key != "" else "hamster-garden-hop",
				"path": bgm_path if bgm_path != "" else "assets/audio/hamster-garden-hop.mp3",
				"volume": 0.42,
			}
		}
		bgm_mode_tracks = DEFAULT_BGM_MODE_TRACKS.duplicate(true)
		parsed_any = true

	var parsed_sfx := _parse_named_defs(source, "const SFX_DEFS")
	if not parsed_sfx.is_empty():
		sfx_defs = parsed_sfx
		parsed_any = true
	else:
		warnings.append("Could not parse SFX_DEFS from fallback Phaser scene; using defaults")
	return parsed_any


func _parse_named_defs(source: String, marker: String) -> Dictionary:
	var body := _object_body_after(source, marker)
	if body == "":
		return {}

	var result := {}
	var entry_regex := RegEx.new()
	if entry_regex.compile("([A-Za-z0-9_]+)\\s*:\\s*\\{([^}]*)\\}") != OK:
		return {}

	for entry in entry_regex.search_all(body):
		var name := entry.get_string(1)
		var object_source := entry.get_string(2)
		var path := _property_string(object_source, "path")
		if path == "":
			continue
		var key := _property_string(object_source, "key")
		result[name] = {
			"key": key if key != "" else name,
			"path": path,
			"volume": _property_float(object_source, "volume", 1.0),
			"cooldownMs": int(round(_property_float(object_source, "cooldownMs", 0.0))),
		}
	return result


func _parse_mode_tracks(source: String, marker: String) -> Dictionary:
	var body := _object_body_after(source, marker)
	if body == "":
		return {}
	var result := {}
	var entry_regex := RegEx.new()
	if entry_regex.compile("([A-Za-z0-9_]+)\\s*:\\s*['\\\"]([^'\\\"]+)['\\\"]") != OK:
		return {}
	for entry in entry_regex.search_all(body):
		result[entry.get_string(1)] = entry.get_string(2)
	return result


func _object_body_after(source: String, marker: String) -> String:
	var marker_index := source.find(marker)
	if marker_index < 0:
		return ""
	var open_index := source.find("{", marker_index)
	if open_index < 0:
		return ""

	var depth := 0
	var in_string := ""
	var escaped := false
	for index in range(open_index, source.length()):
		var ch := source.substr(index, 1)
		if in_string != "":
			if escaped:
				escaped = false
			elif ch == "\\":
				escaped = true
			elif ch == in_string:
				in_string = ""
			continue
		if ch == "'" or ch == "\"" or ch == "`":
			in_string = ch
			continue
		if ch == "{":
			depth += 1
		elif ch == "}":
			depth -= 1
			if depth == 0:
				return source.substr(open_index + 1, index - open_index - 1)
	return ""


func _load_streams() -> void:
	_ensure_players()
	bgm_streams.clear()
	sfx_streams.clear()

	for track_name in bgm_tracks.keys():
		var def: Dictionary = bgm_tracks[track_name]
		var stream: AudioStream = _load_audio_stream(str(def.get("path", "")))
		if stream != null:
			bgm_streams[str(def.get("key", track_name))] = stream

	for name in sfx_defs.keys():
		var def: Dictionary = sfx_defs[name]
		var stream: AudioStream = _load_audio_stream(str(def.get("path", "")))
		if stream != null:
			sfx_streams[name] = stream


func _load_audio_stream(relative_path: String) -> AudioStream:
	if relative_path == "":
		return null
	var path := ProjectSettings.globalize_path("res://../%s" % relative_path)
	if not FileAccess.file_exists(path):
		warnings.append("Missing Phaser audio asset: %s" % path)
		return null

	match path.get_extension().to_lower():
		"mp3":
			return AudioStreamMP3.load_from_file(path)
		"wav":
			return AudioStreamWAV.load_from_file(path)
		_:
			warnings.append("Unsupported Phaser audio asset type: %s" % path)
			return null


func _sync_bgm() -> void:
	_ensure_players()
	if bgm_player == null:
		return
	if _is_headless() or not bool(settings.get("bgm", true)):
		if bgm_player.playing:
			bgm_player.stream_paused = true
		return

	var track := _background_track_for_mode(current_mode)
	var track_key := str(track.get("key", ""))
	var stream = bgm_streams.get(track_key)
	if stream == null:
		return

	if current_bgm_key != track_key:
		if bgm_player.playing:
			bgm_player.stop()
		bgm_player.stream = stream
		current_bgm_key = track_key
	bgm_player.volume_db = _linear_volume_to_db(float(track.get("volume", 1.0)))
	if bgm_player.playing:
		bgm_player.stream_paused = false
	else:
		bgm_player.play()


func _background_track_for_mode(mode: String) -> Dictionary:
	var track_name := str(bgm_mode_tracks.get(mode, "home"))
	if bgm_tracks.has(track_name):
		return bgm_tracks[track_name]
	if bgm_tracks.has("home"):
		return bgm_tracks["home"]
	for key in bgm_tracks.keys():
		return bgm_tracks[key]
	return DEFAULT_BGM_TRACKS["home"]


func _next_sfx_player() -> AudioStreamPlayer:
	if sfx_players.is_empty():
		return null
	var player := sfx_players[next_sfx_player_index % sfx_players.size()]
	next_sfx_player_index += 1
	return player


func _setting_bool(source_settings: Dictionary, keys: Array, default_value: bool) -> bool:
	for key in keys:
		if source_settings.has(str(key)):
			return bool(source_settings.get(str(key), default_value))
	return default_value


func _regex_string(source: String, pattern: String) -> String:
	var regex := RegEx.new()
	if regex.compile(pattern) != OK:
		return ""
	var match_result := regex.search(source)
	if match_result == null:
		return ""
	return match_result.get_string(1)


func _property_string(source: String, key: String) -> String:
	return _regex_string(source, "%s\\s*:\\s*['\\\"]([^'\\\"]+)['\\\"]" % key)


func _property_float(source: String, key: String, fallback: float) -> float:
	var value := _regex_string(source, "%s\\s*:\\s*([-0-9.]+)" % key)
	if value == "":
		return fallback
	return float(value)


func _linear_volume_to_db(volume: float) -> float:
	var safe_volume := clampf(volume, 0.0, 1.0)
	if safe_volume <= 0.0001:
		return -80.0
	return linear_to_db(safe_volume)


func _is_headless() -> bool:
	return DisplayServer.get_name().to_lower() == "headless"
