using System;
using UnityEngine;
using UnityEngine.UI;
using System.Collections;
using System.Threading;
using Commons.Packets;
using Commons.Packets.Requests;
using Cysharp.Threading.Tasks;
using UnityEngine.EventSystems;
using DG.Tweening;
using Interfaces;
using Sirenix.OdinInspector;
using UnityEngine.Events;
using UnityEngine.Serialization;

public abstract class UIPopup : ZUIBehaviour, EventListener, IPacketSender
{
	public virtual bool listenWorldEvents => true;

	public RectTransform backgroundDimTransform;
	public GameObject contents;

	public int priority;
    public bool cancelable = false;
    public float animDuration = .15f;
    public bool faded = false;
	public bool animated = false;
	public Animator popupAnimator = null;
	[HideInInspector]
	public bool blockHide = false;
	[FormerlySerializedAs("clearEventSystemOnAwake")] public bool clearEventSystemOnActive = true;
	public bool hideHudUI = false;
	public virtual bool contentsActiveManually => false;
	public float ignoreInteractDuration = 0f;
	
	[SerializeField] protected string popupOpenSfxKey = "popup_open";
	[SerializeField] protected string popupCloseSfxKey = "popup_close";
	
	public UnityEvent onHide = new UnityEvent();
	
	private CanvasGroup _rootCanvasGroup;
	public CanvasGroup rootCanvasGroup => _rootCanvasGroup ??= this.GetOrAdd<CanvasGroup>(); 

	protected override void Awake () {
		GameManager.Get().AddListener(this);
		// if(listenEdgeEvents)
			// EdgeClient.Get().AddListener(this);
		if (listenWorldEvents)
			ZWorldClient.Get().AddListener(this);
		
	}

	protected override void OnDestroy () {
		GameManager.Get().HandlePopupSiblingIndexChange();
		
		ZWorldClient.Get().RemoveListener(this);
		GameManager.Get().RemoveListener(this);
		// EdgeClient.Get().RemoveListener(this);
	}
	
	public bool IsLastSiblingPopup()
	{
		if (transform == null)
			return false;
		
		var parent = transform.parent;
		if (parent == null)
			return false;
		
		return GetPopupSiblingIndex() == GameManager.Get().GetActivationChildPopupCount(parent) - 1;
	}
	
	public int activationSiblingIndex { get; set; }
	public int GetPopupSiblingIndex()
	{
		return activationSiblingIndex;
	}

	public virtual void OnSiblingIndexChanged()
	{
		if (backgroundDimTransform != null)
			backgroundDimTransform.SetActive(IsLastSiblingPopup());
	}

	protected virtual void PreloadPopups(params Type[] popupTypes)
	{
		var gameScene = GameScene.Get();
		if (gameScene != null)
			gameScene.PreloadPopups(popupTypes);
	}
	
	private bool? _isActive;
	public void SetContentActive(bool isActive)
	{
		SetHudUIActive(isActive);
		
		if (contents == false || _isActive == isActive)
			return;
		
		contents.SetActive(isActive);

		AudioManager.Get().PlayFX(isActive ? popupOpenSfxKey : popupCloseSfxKey);
		
		if (isActive && animated)
		{
			contents.transform.localScale = Vector3.one * .7f;
			contents.transform.DOKill();
			contents.transform.DOScale(1f, animDuration);
		}

		if (isActive && faded)
		{
			var canvasGroup = contents.GetOrAdd<CanvasGroup>();
			canvasGroup.DOKill();
			canvasGroup.alpha = 0f;
			canvasGroup.DOFade(1f, animDuration);
		}

		if (isActive && popupAnimator)
		{
			popupAnimator.Play(AnimatorHash.Start, -1, 0.0f);
		}
		
		if (isActive && ignoreInteractDuration > 0f)
		{
			var canvasGroup = rootCanvasGroup;
			canvasGroup.interactable = false;
			this.Run(() =>
			{
				canvasGroup.interactable = true;
			}, ignoreInteractDuration);
		}
		
		_isActive = isActive;

		if (!isActive)
		{
			StopAllCoroutines();
		}
	}
	
	private bool _isHudActive;
	private void SetHudUIActive(bool bActive)
	{
		if (!hideHudUI || _isHudActive == bActive)
			return;
		_isHudActive = bActive;
		HUDManager.Get().SetHUDActive(!bActive);
	}

	// Use this for initialization
	protected override void Start () {
		base.Start();
		
		Refresh ();
		LogEvent();
	}

	protected override void OnEnable()
	{
		base.OnEnable();

		if (clearEventSystemOnActive && EventSystem.current)
			EventSystem.current.SetSelectedGameObject(null);

		if (!contentsActiveManually && contents)
			SetContentActive(true);
	}

	protected override void OnDisable()
	{
		if (!contentsActiveManually && contents)
			SetContentActive(false);
		
		GameManager.Get().HandlePopupSiblingIndexChange();
		
		base.OnDisable();
	}

	protected override void LateUpdate()
	{
		base.LateUpdate();

		if (blockRefresh)
			return;

		if (refreshFlag != RefreshFlag.NONE)
		{
			try
			{
				RefreshByFlag();
			}
			catch (Exception e)
			{
				Debug.LogError(e);
			}
		}
		
		refreshFlag = RefreshFlag.NONE;
	}

	protected abstract void RefreshByFlag();

	public virtual void InitializeUsingToken(string[] tokens)
	{
		
	}

	[Button]
	public virtual void OnCancel() {
		PlayClick ();
		Hide();
	}
	
	public void FreezeInteraction()
	{
		blockHide = true;
		//rootCanvasGroup.interactable = false;
		rootCanvasGroup.blocksRaycasts = false;
	}
	
	public void UnfreezeInteraction()
	{
		blockHide = false;
		//rootCanvasGroup.interactable = true;
		rootCanvasGroup.blocksRaycasts = true;
	}

	private Coroutine _hideCoroutine;
	internal virtual void Hide()
	{
		if (blockHide)
			return;

		if (_hideCoroutine != null)
			return;

		if (popupAnimator != null && gameObject.activeInHierarchy)
		{
			_hideCoroutine = popupAnimator.PlayForward(this, AnimatorHash.End, OnEnd: HideInternal);
		}
		else
		{
			HideInternal();
		}
	}

	private void HideInternal()
	{
		StopAllCoroutines();
		
		LogEventEnd();
		onHide.Invoke();
		
		GameManager.Get().HandlePopupRemoved(this);
		GameManager.Get().DispatchEvent(GameEventType.PopupHidden, this);

		if (this)
			OnHideImpl();
	}
	
	protected virtual void OnHideImpl()
	{
		Destroy(gameObject);
	}

	// Add flag for each GameEvent that needs handling
	[Flags]
	protected enum RefreshFlag : uint
	{
		NONE = 0,
		MY_UNIT_UPDATED = 1 << 0,
		MY_STATS_UPDATED = 1 << 1,
		MY_PLAYER_ITEM_UPDATED = 1 << 2,
		MY_ACHIEVEMENT_UPDATED = 1 << 3,
		MY_AVATAR_UPDATED = 1 << 5,
		ALL = ~NONE,
	}

	protected RefreshFlag refreshFlag = RefreshFlag.ALL;

	protected void AddRefreshFlag(RefreshFlag flag)
	{
		refreshFlag |= flag;
	}
	
	protected void RemoveRefreshFlag(RefreshFlag flag)
	{
		refreshFlag &= ~flag;
	}

	public void AddRefreshAll()
	{
		AddRefreshFlag(RefreshFlag.ALL);
	}

	private bool blockRefresh = false;
	public void FreezeRefresh()
	{
		blockRefresh = true;
	}

	public void UnfreezeRefresh()
	{
		blockRefresh = false;
	}

	public virtual async UniTask HandleEvent(GameEvent e) {
		switch (e.type)
		{
			case GameEventType.MY_UNIT_UPDATED:
				AddRefreshFlag(RefreshFlag.MY_UNIT_UPDATED);
				break;
			case GameEventType.MY_PLAYER_AVATAR_UPDATED:
				AddRefreshFlag(RefreshFlag.MY_AVATAR_UPDATED);
				break;
			case GameEventType.MY_STATS_UPDATED:
				AddRefreshFlag(RefreshFlag.MY_STATS_UPDATED);
				break;
			case GameEventType.MyPlayerItemUpdated:
				AddRefreshFlag(RefreshFlag.MY_PLAYER_ITEM_UPDATED);
				break;
			case GameEventType.MyPlayerAchievementUpdated:
				AddRefreshFlag(RefreshFlag.MY_ACHIEVEMENT_UPDATED);
				break;
			case GameEventType.MY_PLAYER_LEVEL_UP:
				AddRefreshFlag(RefreshFlag.MY_STATS_UPDATED);
				break;
		}
	}
	
	// protected void PlayMusic(string name) {
	// 	if(AudioController.GetCurrentMusic() == null
	// 	   || AudioController.GetCurrentMusic().audioID != name)
	// 		AudioController.PlayMusic(name);
	// }

	public void EndSequenceMode()
	{
		UnfreezeInteraction();
		UnfreezeRefresh();
		AddRefreshAll();
	}
	
	public void PlayFX(string name) {
		GameManager.Get().PlayFX(name);
	}
	
	protected void PlayClick() {
		PlayFX ("click");
	}
	
	public virtual void OnOK() {
		PlayClick ();
		Hide ();
	}

	public virtual void Refresh() {

	}

	public virtual void LogEvent()
	{
		PlatformManager.Get().LogEvent("popup_open", ("Name", GetType().Name));
	}

	public virtual void LogEventEnd()
	{
		PlatformManager.Get().LogEvent("popup_close", ("Name", GetType().Name));
	}

	public void HideIfClickedOutside(GameObject go)
	{
		if (Input.GetMouseButtonDown(0) && go.activeSelf &&
		    !RectTransformUtility.RectangleContainsScreenPoint(go.GetComponent<RectTransform>(),
			    Input.mousePosition,
			    GameManager.Get().scene.GetCamera()))
			Hide();
	}

	public async UniTask<IPacketResponse> SendPacket(Packet packet, CancellationToken cancellationToken, bool withLoading = false, bool freezeInteraction = true)
	{
		if (freezeInteraction)
			FreezeInteraction();

		var response = await ZWorldClient.Get().SendPacket(packet, cancellationToken: cancellationToken, withLoading: withLoading);

		if (this && freezeInteraction)
			UnfreezeInteraction();

		if (this)
			AddRefreshAll();

		return response;
	}

	public async UniTask<TPacketResponse> SendPacket<TPacketResponse>(Packet packet, CancellationToken cancellationToken, bool withLoading = false, bool freezeInteraction = true) where TPacketResponse : class, IPacketResponse, new()
	{
		if (freezeInteraction)
			FreezeInteraction();

		var response = await ZWorldClient.Get().SendPacket<TPacketResponse>(packet, cancellationToken: cancellationToken, withLoading: withLoading);

		if (this && freezeInteraction)
			UnfreezeInteraction();

		if (this)
			AddRefreshAll();

		return response;
	}
	
}
