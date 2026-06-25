extends SceneTree

const ContentStore := preload("res://scripts/content_store.gd")
const SpriteCatalog := preload("res://scripts/visual/sprite_catalog.gd")


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var store := ContentStore.new()
	if not store.load_all():
		_fail("content load failed: %s" % "; ".join(store.errors))
		return

	var sprites := SpriteCatalog.new()
	if not sprites.load_all():
		_fail("sprite load failed: %s" % "; ".join(sprites.errors))
		return

	for skill_id in range(300301, 300331):
		_check_skill(store, sprites, skill_id)

	_check_parent_children(store, 200503, [200509, 200514, 200524])
	_check_parent_children(store, 200504, [200519, 200529])
	_check_parent_children(store, 200505, [200534])

	print("skill tree fx smoke ok")
	quit(0)


func _check_skill(store, sprites, skill_id: int) -> void:
	var skill: Dictionary = store.get_skill(skill_id)
	if skill.is_empty():
		_fail("missing skill %d" % skill_id)
		return

	var saw_hit := false
	var saw_fx := false
	for timeline in skill.get("timelines", []):
		if typeof(timeline) != TYPE_DICTIONARY:
			continue
		if timeline.has("hit"):
			saw_hit = true
		if timeline.has("playFx"):
			var play_fx: Dictionary = timeline.get("playFx", {})
			if str(play_fx.get("prefab", "")).find("Taskstonebar") != -1:
				saw_fx = true
	if not saw_hit:
		_fail("skill %d has no hit timeline" % skill_id)
		return
	if not saw_fx:
		_fail("skill %d has no Taskstonebar playFx timeline" % skill_id)
		return

	var skill_item_id := 200509 + skill_id - 300301
	var recipe_id := 200539 + skill_id - 300301
	var item: Dictionary = store.get_item(skill_item_id)
	if item.is_empty() or str(item.get("category", "")) != "Skill":
		_fail("missing skill item %d for skill %d" % [skill_item_id, skill_id])
		return
	if int(item.get("skillDataId", 0)) != skill_id:
		_fail("skill item %d points to %d, expected %d" % [skill_item_id, int(item.get("skillDataId", 0)), skill_id])
		return

	var popup: Dictionary = item.get("popupArgs", {})
	if str(popup.get("SkillTree", "")) != "Taskstonebar":
		_fail("skill item %d has wrong SkillTree popupArg" % skill_item_id)
		return
	if str(popup.get("LevelPointItemDataId", "")) != "200501":
		_fail("skill item %d has wrong level point item" % skill_item_id)
		return
	if str(popup.get("UnlockRecipeItemDataId", "")) != str(recipe_id):
		_fail("skill item %d has wrong unlock recipe" % skill_item_id)
		return

	var recipe: Dictionary = store.get_item(recipe_id)
	if recipe.is_empty() or str(recipe.get("category", "")) != "Recipe":
		_fail("missing unlock recipe %d for skill item %d" % [recipe_id, skill_item_id])
		return
	var recipe_popup: Dictionary = recipe.get("popupArgs", {})
	if str(recipe_popup.get("UnlockSkillItemDataId", "")) != str(skill_item_id):
		_fail("recipe %d does not unlock skill item %d" % [recipe_id, skill_item_id])
		return

	if not sprites.has_effect_for_skill(skill_id):
		_fail("missing sprite catalog effect mapping for skill %d" % skill_id)
		return
	var effect_key: String = sprites.effect_key_for_skill(skill_id)
	if sprites.get_texture(effect_key) == null:
		_fail("effect texture %s for skill %d did not load" % [effect_key, skill_id])
		return


func _check_parent_children(store, parent_id: int, expected_children: Array) -> void:
	var parent: Dictionary = store.get_item(parent_id)
	if parent.is_empty():
		_fail("missing parent skill item %d" % parent_id)
		return
	var popup: Dictionary = parent.get("popupArgs", {})
	var raw_children := str(popup.get("ChildrenSkillItemDataIds", ""))
	for child_id in expected_children:
		if raw_children.find(str(child_id)) == -1:
			_fail("parent skill item %d is missing child %d" % [parent_id, int(child_id)])
			return


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
