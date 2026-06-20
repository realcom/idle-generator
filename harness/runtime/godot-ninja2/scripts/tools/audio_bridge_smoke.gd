extends SceneTree

const PhaserAudioBridge := preload("res://scripts/audio/phaser_audio_bridge.gd")


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var audio = PhaserAudioBridge.new()
	get_root().add_child(audio)
	await process_frame

	audio.load_from_phaser()
	var config: Dictionary = audio.get_config()
	var bgm: Dictionary = config.get("bgm", {})
	var sfx: Dictionary = config.get("sfx", {})
	var warnings: Array = config.get("warnings", [])

	if not warnings.is_empty():
		_fail("audio bridge warnings: %s" % "; ".join(warnings))
		return

	if str(bgm.get("path", "")) != "assets/audio/lantern-grove.mp3":
		_fail("unexpected Phaser BGM path: %s" % str(bgm.get("path", "")))
		return
	if abs(float(bgm.get("volume", 0.0)) - 0.34) > 0.001:
		_fail("unexpected Phaser BGM volume: %s" % str(bgm.get("volume", "")))
		return
	audio.set_mode("expedition")
	config = audio.get_config()
	bgm = config.get("bgm", {})
	if str(bgm.get("path", "")) != "assets/audio/bamboo-shuriken-run.mp3":
		_fail("unexpected expedition BGM path: %s" % str(bgm.get("path", "")))
		return
	for key in ["uiClick", "uiError", "attack", "hit", "monsterDead", "coin", "reward", "levelUp"]:
		if not sfx.has(key):
			_fail("missing Phaser SFX key: %s" % key)
			return

	audio.apply_settings({"bgmEnabled": false, "sfxEnabled": false, "language": "ko"})
	var settings: Dictionary = audio.get_settings()
	if bool(settings.get("bgmEnabled", true)) or bool(settings.get("sfxEnabled", true)):
		_fail("Phaser-style settings did not disable audio")
		return

	audio.apply_settings({"bgm": true, "sfx": true})
	settings = audio.get_settings()
	if not bool(settings.get("bgm", false)) or not bool(settings.get("sfx", false)):
		_fail("Godot-style settings did not enable audio")
		return

	print("godot-ninja2 audio bridge smoke ok: bgm=%s sfx=%d storage=%s" % [
		str(bgm.get("path", "")),
		sfx.size(),
		str(settings.get("storageKey", "")),
	])
	quit(0)


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
