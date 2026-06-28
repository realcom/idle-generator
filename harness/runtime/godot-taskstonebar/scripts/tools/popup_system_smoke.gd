extends SceneTree


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var scene: PackedScene = load("res://scenes/main.tscn")
	var root_node: Node = scene.instantiate()
	root_node.set("generated_visual_capture_mode", true)
	get_root().add_child(root_node)
	for _i in range(16):
		await process_frame

	var overlay := root_node.get_node_or_null("GeneratedFullUiOverlay")
	if overlay == null:
		_fail("GeneratedFullUiOverlay was not added")
		return

	if not root_node.has_method("show_popup_alert"):
		_fail("main scene does not expose show_popup_alert")
		return
	if not root_node.has_method("show_popup_confirm"):
		_fail("main scene does not expose show_popup_confirm")
		return
	if not root_node.has_method("show_popup_toast"):
		_fail("main scene does not expose show_popup_toast")
		return

	var alert: Control = root_node.show_popup_alert({
		"id": "offline_reward",
		"title": "오프라인 보상",
		"message": "전리품 정산이 완료되었습니다.",
		"detail": "하단 전투 스트립은 팝업 뒤에서도 계속 읽을 수 있어야 합니다.",
	})
	for _i in range(4):
		await process_frame
	if alert == null or overlay.get_node_or_null("ModalHost/PopupSystem_OfflineReward") == null:
		_fail("alert popup did not open under ModalHost")
		return
	var combat_strip := overlay.get_node_or_null("Section_BottomCombatStrip")
	if combat_strip == null or not combat_strip is CanvasItem or not (combat_strip as CanvasItem).visible:
		_fail("combat strip is not visible while popup is open")
		return
	var alert_title := alert.get_node_or_null("Panel_PopupTitleBar/Text_PopupTitle")
	if alert_title == null or not alert_title is Label or (alert_title as Label).text != "오프라인 보상":
		_fail("alert popup title did not render")
		return
	var alert_close := alert.get_node_or_null("Panel_PopupTitleBar/Btn_PopupClose")
	if alert_close == null or not alert_close is Button:
		_fail("alert popup has no close button")
		return
	(alert_close as Button).pressed.emit()
	for _i in range(4):
		await process_frame
	if overlay.get_node_or_null("ModalHost/PopupSystem_OfflineReward") != null:
		_fail("alert popup did not close")
		return

	var confirmed := {"value": false}
	var confirm_callback := func():
		confirmed["value"] = true
	var confirm: Control = root_node.show_popup_confirm({
		"id": "boss_gate",
		"title": "보스 입장",
		"message": "포탈 보스전에 입장할까요?",
		"detail": "권장 레벨과 소모 티켓을 확인한 뒤 진행합니다.",
		"on_confirm": confirm_callback,
	})
	for _i in range(4):
		await process_frame
	if confirm == null:
		_fail("confirm popup did not open")
		return
	var confirm_button := confirm.get_node_or_null("Footer_PopupActions/Btn_PopupConfirm")
	if confirm_button == null or not confirm_button is Button:
		_fail("confirm popup has no confirm button")
		return
	(confirm_button as Button).pressed.emit()
	for _i in range(4):
		await process_frame
	if not bool(confirmed["value"]):
		_fail("confirm popup callback did not run")
		return
	if overlay.get_node_or_null("ModalHost/PopupSystem_BossGate") != null:
		_fail("confirm popup did not close after confirm")
		return

	var toast: Control = root_node.show_popup_toast({
		"id": "rare_drop",
		"title": "희귀 전리품",
		"message": "제련 촉매 1개 획득",
		"duration": 0.0,
	})
	for _i in range(4):
		await process_frame
	if toast == null or overlay.get_node_or_null("ModalHost/Toast_RareDrop") == null:
		_fail("toast popup did not open")
		return
	var toast_body := toast.get_node_or_null("Text_ToastBody")
	if toast_body == null or not toast_body is Label or (toast_body as Label).text.find("획득") == -1:
		_fail("toast body did not render acquisition text")
		return

	print("popup system smoke ok")
	quit(0)


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
