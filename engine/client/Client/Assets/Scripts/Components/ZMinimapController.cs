using UnityEngine;
using System.Collections;
using UnityEngine.UI;
using System;
using System.Collections.Generic;
using Commons.Resources;

using TMPro;
using UnityEngine.Serialization;


public class ZMinimapController : MonoBehaviour
{
	[Serializable]
	public class MinimapMarkerSprites
	{
		public Sprite spritePlayer;
		public Sprite spriteEnemy;
		public Sprite spriteBoss;
		public Sprite spriteNPC;
		public Sprite spritePortal;
		public Sprite spriteQuestNew;
		public Sprite spriteQuestCompleted;
		public Sprite spriteSpawner;
		public Sprite spriteSpawner2;
	}
	
	public class MinimapUnitQueues
	{
		public Queue<MinimapMarker> queuePlayer = new(20);
		public Queue<MinimapMarker> queueEnemy = new(50);
		public Queue<MinimapMarker> queueNPC = new(15);
		public Queue<MinimapMarker> queueBoss = new(10);
	}
	
	public Image imgMap;
	public RectTransform maskMap;
	public GameObject markerPrefab;
	public GameObject minimapMyPlayerUnit;
	public MinimapMarkerSprites minimapMarkerSprites;
	
	public TextMeshProUGUI txtMapName;
	
	private Vector2 mapImageRadius;
	private Vector2 mapMaskRadius;
	private float mapSizeFitter = 0.25f;
	
	private MinimapUnitQueues minimapUnitQueues = new();
	private Dictionary<long, MinimapMarker> markerPool = new();

	// public AnimatedButton btSetFlag;

	private void Start()
	{
		mapMaskRadius = new Vector2(maskMap.rect.width / 2, maskMap.rect.height / 2);
	}

	// private void OnSetFlag()
	// {
	// 	var currentMapID = GameContainer.Get().resMap.id;
	// 	var targetMapID = MyPlayer.Get().GetItemByDataID(ItemIDs.MAP_FLAG).param1;
	//
	// 	var currentPosition = MyPlayerUnit.Get().transform.position.XYZtoXZO();
	// 	
	// 	var resMap = ResourceMap.Get(targetMapID);
	// 	var warningText = targetMapID > 0
	// 		? "Popup_GoFlag_Warning".L() + "\n" + "Popup_GoFlag_Current".L(resMap.name)
	// 		: "Popup_GoFlag_Warning".L();
	// 	
	// 	GameManager.Get().ShowPopup<Popup_Alert>().Initialize(Popup_Alert.Type.YES_NO,
	// 		warningText,
	// 		alertResult =>
	// 		{
	// 			if (alertResult == 1)
	// 			{
	// 				WorldClient.Get().SendPacket(Packet.Type.UseCashItem, new UseCashItem
	// 				{
	// 					itemID = MyPlayer.Get().GetItemByDataID(ItemIDs.MAP_FLAG).id,
	// 					param1 = currentMapID,
	// 					param2 = (int)currentPosition.x,
	// 					param3 = (int)currentPosition.y,
	// 				}, (p) =>
	// 				{
	// 					var l = p.Get<UseCashItem.Result>();
	// 					if (GameManager.HandleCommonStatus(l.status, l.message))
	// 						GameManager.Get().ShowPopup<Popup_Toast>().Initialize("Popup_GoFlag_New".L());
	// 				}, withLoading: true, skipRefreshEdge: true);
	// 			}
	// 		});
	// }

	private int _resMapIdCache;

	private IEnumerator InitMinimapAfterFrame(ResourceMap resMap)
	{
		markerPool.Clear();
		_mapInitialized = false;
		// btSetFlag.SetActive(GameContainer.Get().resMap.type == ResourceMap.Type.DUNGEON);
		txtMapName.text = resMap.Name;
		// btSetFlag.SetOnClick(OnSetFlag);
		
		yield return null;

		var mapTexture = GameBoardManager.Get().mapRootOld.minimapTexture;
		if (mapTexture == null)
		{
			Debug.LogError("Minimap texture is missing! Please export minimap texture from current map scene.");
			yield break;
		}

		var imgMapWidth = mapTexture.width / mapSizeFitter;
		var imgMapHeight = mapTexture.height / mapSizeFitter;
		imgMap.rectTransform.sizeDelta = new Vector2(imgMapWidth, imgMapHeight);
		imgMap.sprite = Sprite.Create(mapTexture, new Rect(0.0f, 0.0f, mapTexture.width, mapTexture.height), new Vector2(0.5f, 0.5f), 100.0f);
		mapImageRadius = new Vector2(imgMapWidth / 2, imgMapHeight / 2);

		if (resMap.Id != _resMapIdCache)
		{
			var oldMarkers = imgMap.transform.GetComponentsInChildren<MinimapMarker>();
			foreach (var oldMarker in oldMarkers)
				Destroy(oldMarker.gameObject);
		}
		
		
		if (resMap.Id != _resMapIdCache)
		{
			_resMapIdCache = resMap.Id;
			var mapObjects = GameBoardManager.Get().mapRootOld.minimapObjects;
			
			foreach (var mapObj in mapObjects)
			{
				if (mapObj.target == null)
				{
					Debug.LogError($"Missing Target for minimap object at Map = {resMap.Id}! Please check \"MapRoot\"-\"Minimap Objects\" settings in map scene.");
					continue;
				}
				if (mapObj.minimapObjectTag == MapRoot_Old.MinimapObjectTag.SPAWNER)
				{
					var marker = InstantiateMarker(minimapMarkerSprites.spriteSpawner);
					var markerTransform = marker.transform;
					marker.GetComponent<MinimapMarker>().imgIcon.SetAlpha(0.45f);
					// TODO: get spawner size
					marker.gameObject.GetComponent<RectTransform>().sizeDelta = new Vector2(63 * 48 * 10 * 1.8f / (1.5f * 100), 63 *48 * 10 * 1.8f / (1.5f * 100));
					markerTransform.localPosition = AdjustedPosition(mapObj.target.transform.position.XYZtoXZO());
					var rotationEulerAngles = markerTransform.rotation.eulerAngles;
					markerTransform.rotation = Quaternion.Euler(0f, rotationEulerAngles.y, rotationEulerAngles.z); 
				}
				// if (mapObj.minimapObjectTag == MapRoot.MinimapObjectTag.SPAWNER_BLUE)
				// {
				// 	var marker = InstantiateMarker(minimapMarkerSprites.spriteSpawner2);
				// 	marker.GetComponent<MinimapMarker>().imgIcon.SetAlpha(0.50f);
				// 	// TODO: get spawner size
				// 	marker.gameObject.GetComponent<RectTransform>().sizeDelta = new Vector2(63 * 48 * 10 * 1.8f / (1.5f * 100), 63 *48 * 10 * 1.8f / (1.5f * 100));
				// 	marker.transform.localPosition = AdjustedPosition(mapObj.target.transform.position.XYZtoXZO());
				// }
				else if (mapObj.minimapObjectTag == MapRoot_Old.MinimapObjectTag.PORTAL)
				{
					var marker = InstantiateMarker(minimapMarkerSprites.spritePortal);
					var markerTransform = marker.transform;
					marker.gameObject.GetComponent<RectTransform>().sizeDelta *= 1.5f;
					markerTransform.localPosition = AdjustedPosition(mapObj.target.transform.position.XYZtoXZO());
					var rotationEulerAngles = markerTransform.rotation.eulerAngles;
					markerTransform.rotation = Quaternion.Euler(0f, rotationEulerAngles.y, rotationEulerAngles.z); 
				}
			}
			
		}
		_mapInitialized = true;
	}

	private bool _mapInitialized;
	
	public void InitMinimap(ResourceMap resMap)
	{
		GameScene.Get().StartCoroutine(InitMinimapAfterFrame(resMap));
	}

	private readonly List<GameObject> _markerSiblingCache = new();
	
	private void UpdateMinimap()
	{
		if (!_mapInitialized)
			return;
		
		_markerSiblingCache.Clear();

		//
		// TODO: set to camera movement?
		var target = MyGameUnitObject.Get();
		if (target == null)
		// if (!target || PowerSavingManager.enabled)
			return;
		
		var relativePosition = AdjustedPosition(target.transform.position.XYZtoXZO());

		var mapPos = new Vector3(0,0,0);
		if (mapImageRadius.x >= mapMaskRadius.x)
			mapPos.x = Mathf.Clamp(-relativePosition.x, -mapImageRadius.x + mapMaskRadius.x, mapImageRadius.x - mapMaskRadius.x);
		else
			relativePosition.x += mapMaskRadius.x - mapImageRadius.x;
        
		if (mapImageRadius.y >= mapMaskRadius.y)
			mapPos.y = Mathf.Clamp(-relativePosition.y, -mapImageRadius.y + mapMaskRadius.y, mapImageRadius.y - mapMaskRadius.y);
		else
			relativePosition.y -= mapMaskRadius.y - mapImageRadius.y;

		// imgMap.rectTransform.localPosition = Rotate45Degrees(mapPos);
		// imgMap.rectTransform.localPosition = mapPos;
		var transformedMapPos = imgMap.transform.localRotation * mapPos;
		imgMap.rectTransform.localPosition = transformedMapPos;
		
		// MyPlayerUnit
		minimapMyPlayerUnit.transform.localPosition = new Vector3(relativePosition.x, relativePosition.y, 0);
		// var angle = Mathf.Atan2(MyPlayerUnit.Get().moveDirection.z, MyPlayerUnit.Get().moveDirection.x) * Mathf.Rad2Deg - 90f;
		// minimapMyPlayerUnit.transform.localRotation = Quaternion.Euler(0f, 0f, angle);
		var yRotation = target.transform.localRotation.eulerAngles.y;
		minimapMyPlayerUnit.transform.localRotation =  Quaternion.Euler(0, 0, -yRotation);
		var rotationEulerAngles = minimapMyPlayerUnit.transform.rotation.eulerAngles;
		minimapMyPlayerUnit.transform.rotation = Quaternion.Euler(0f, rotationEulerAngles.y, rotationEulerAngles.z);

		// Unit
		foreach (var unit in GameBoardManager.Get().UnitObjectById.Values)
		{
			var tid = unit.syncId;

			// TODO: refactor after Tag is added
			// if (!unit.ResUnit.ContainsTag(Tag.ENEMY) && !unit.ResUnit.ContainsTag(Tag.NPC) &&
			//     !unit.ResUnit.ContainsTag(Tag.AVATAR) && !unit.ResUnit.ContainsTag(Tag.BOSS) ||
			//     unit.syncId == MyPlayerUnit.Get().tunit.id || unit.ResUnit.ContainsTag(Tag.NOT_SHOW_MINIMAP))
			// 	continue;
			
			if (unit.syncId == MyGameUnitObject.Get().syncId)
				continue;
			//
			// if (!markerPool.ContainsKey(tid))
			// {
			// 	if (unit.ResUnit.ContainsTag(Tag.ENEMY) && !unit.ResUnit.ContainsTag(Tag.BOSS))
			// 		markerPool[tid] = minimapUnitQueues.queueEnemy.TryDequeue(out var markerEnemy) ? markerEnemy : InstantiateMarker(minimapMarkerSprites.spriteEnemy);
   //              
			// 	if (unit.ResUnit.ContainsTag(Tag.NPC))
			// 		markerPool[tid] = minimapUnitQueues.queueNPC.TryDequeue(out var markerNPC) ? markerNPC : InstantiateMarker(minimapMarkerSprites.spriteNPC);
			//
			// 	if (unit.ResUnit.ContainsTag(Tag.AVATAR) && unit.syncId != MyPlayerUnit.Get().tunit.id)
			// 	{
			// 		markerPool[tid] = minimapUnitQueues.queuePlayer.TryDequeue(out var markerPlayer) ? markerPlayer : InstantiateMarker(minimapMarkerSprites.spritePlayer);
			// 		_markerSiblingCache.Add(markerPool[tid].gameObject);
			// 	}
			//
			// 	if (unit.ResUnit.ContainsTag(Tag.BOSS))
			// 	{
			// 		if (minimapUnitQueues.queueBoss.TryDequeue(out var markerBoss))
			// 			markerPool[tid] = markerBoss;
			// 		else
			// 		{
			// 			markerPool[tid] = InstantiateMarker(minimapMarkerSprites.spriteBoss);
			// 			markerPool[tid].gameObject.GetComponent<RectTransform>().sizeDelta *= 1.5f;
			// 			_markerSiblingCache.Add(markerPool[tid].gameObject);
			// 		}
			// 	}
			// 		
			// }


			if (!markerPool.ContainsKey(tid))
			{
				// Debug.LogError(unit.ResUnit.Id);
			}
			else
			{
				var marker = markerPool[tid];
				var markerTransform = marker.transform;
				marker.SetActive(true);
				// TODO: refactor after Tag is added
				// if (unit.ResUnit.ContainsTag(Tag.BOSS))
				// {
				// 	// Boss, Bubble
				// 	markerTransform.localPosition = AdjustedPosition(unit.transform.position.XYZtoXZO(), true);
				// 	var markerEulerAngles = unit.transform.rotation.eulerAngles;
				// 	markerTransform.rotation = Quaternion.Euler(0f, 0f, markerEulerAngles.y);
				// 	if(IsOutsideMap(unit.transform.position.XYZtoXZO()))
				// 		marker.SetBubble(true, target.position.XYZtoXZO() - unit.transform.position.XYZtoXZO());
				// 	else
				// 		marker.SetBubble(false);
				// }
				// else if (unit.resUnit.ContainsTag(Tag.NPC) && unit.gameObject.GetComponentInChildren<UnitSkin>()?.GetComponentInChildren<Mission_NPC>())
				// {
				// 	marker.transform.localPosition = AdjustedPosition(unit.transform.position.XYZtoXZO());
				// 	// Quest, Bubble
				// 	var (completed, inProgress, ready) = Popup_Mission.HasNew();
				// 	if (completed || inProgress)
				// 	{
				// 		if (markerPool.ContainsKey(-tid))
				// 		{
				// 			markerPool[-tid].SetActive(false);
				// 			Destroy(markerPool[-tid].gameObject);
				// 		}
				// 	}
				// 	else if (ready)
				// 	{
				// 		markerPool[tid].SetActive(false);
				// 		if (!markerPool.ContainsKey(-tid))
				// 			markerPool[-tid] = InstantiateMarker(minimapMarkerSprites.spriteQuestNew);
				// 		
				// 		markerPool[-tid].transform.localPosition = AdjustedPosition(unit.transform.position.XYZtoXZO(), true);
				// 		if(IsOutsideMap(unit.transform.position.XYZtoXZO()))
				// 			markerPool[-tid].SetBubble(true, target.position.XYZtoXZO() - unit.transform.position.XYZtoXZO());
				// 		else
				// 			markerPool[-tid].SetBubble(false);
				// 	}
				// }
				// else
				// {
					marker.transform.localPosition = AdjustedPosition(unit.transform.position.XYZtoXZO());
					var markerEulerAngles = markerTransform.rotation.eulerAngles;
					markerTransform.rotation = Quaternion.Euler(0f, 0f, markerEulerAngles.y);
				// }
			}

			foreach (var obj in _markerSiblingCache)
			{
				obj.transform.SetAsLastSibling();
			}
			minimapMyPlayerUnit.transform.SetAsLastSibling();
		}
	}

	public void ClearMarker(GameUnitObject unit)
	{
		if (!markerPool.ContainsKey(unit.syncId))
			return;
		if (!markerPool[unit.syncId])
			return;
		markerPool[unit.syncId].SetActive(false);
		// TODO: refactor after Tag is added
		// if (unit.resUnit.ContainsTag(Tag.ENEMY) && !unit.resUnit.ContainsTag(Tag.BOSS))
		// 	minimapUnitQueues.queueEnemy.Enqueue(markerPool[unit.tunit.id]);
		// if (unit.resUnit.ContainsTag(Tag.NPC))
		// 	minimapUnitQueues.queueNPC.Enqueue(markerPool[unit.tunit.id]);
		// if (unit.resUnit.ContainsTag(Tag.AVATAR) && unit.tunit.id != MyPlayerUnit.Get()?.tunit.id)
		// 	minimapUnitQueues.queuePlayer.Enqueue(markerPool[unit.tunit.id]);
		// if (unit.resUnit.ContainsTag(Tag.BOSS))
		// 	minimapUnitQueues.queueBoss.Enqueue(markerPool[unit.tunit.id]);
	}

	private Vector3 AdjustedPosition(Vector3 position, bool isBubble = false)
	{
		var mapRoot = MapRoot_Old.Get();
		if (isBubble)
		{
			var pos = AdjustedPosition(position);
			var bubblePos = new Vector2(0,0);
			var playerPosition = AdjustedPosition(MyGameUnitObject.Get().transform.position.XYZtoXZO());
			
			// rect
			bubblePos.x = Mathf.Clamp(pos.x, playerPosition.x - mapMaskRadius.x+1, playerPosition.x + mapMaskRadius.x-1);
			bubblePos.y = Mathf.Clamp(pos.y, playerPosition.y - mapMaskRadius.y+1, playerPosition.y + mapMaskRadius.y-1);
			
			// circle
			// var direction = new Vector2(pos.x, pos.y) - new Vector2(playerPosition.x, playerPosition.y);
   //      
			// if (direction.magnitude > mapMaskRadius.x)
			// {
			// 	direction = direction.normalized * (mapMaskRadius.x - 1);
			// 	bubblePos = new Vector2(playerPosition.x, playerPosition.y) + direction;
			// }
			// else
			// {
			// 	bubblePos = new Vector2(pos.x, pos.y);
			// }

			return bubblePos;
		}
		
		var c = (position - (Vector3)mapRoot.boundsOffset.X0Z());
		return c * mapRoot.minimapMagnifier / mapSizeFitter;
	}

	private bool IsOutsideMap(Vector3 position)
	{
		return AdjustedPosition(position) != AdjustedPosition(position, true);
	}

	private MinimapMarker InstantiateMarker(Sprite sprite)
	{
		var obj = Instantiate(markerPrefab, imgMap.transform);
		var marker = obj.GetComponent<MinimapMarker>();
		if (marker)
			marker.Initialize(sprite);

		return marker;
	}

	public void LateUpdate()
	{
		UpdateMinimap();
	}
	
}
