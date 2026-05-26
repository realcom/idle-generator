using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TempFieldMapSettings : MonoBehaviour
{
    // [Serializable]
    // public class FieldSettings
    // {
    //     public int mapId;
    //     public CheckUnitCountSettings[] checkUnitCountSettings;
    //     public int goToMapId;
    //     public int goToDelay;
    // }
    //
    // [Serializable]
    // public struct CheckUnitCountSettings
    // {
    //     public int unitDataId;
    //     public uint count;
    // }
    //
    // public FieldSettings[] fieldSettings;
    // private bool _completed;
    //
    // private FieldSettings _fieldSettingToUse;
    //
    // private void Start()
    // {
    //     foreach (var fieldSetting in fieldSettings)
    //     {
    //         if (fieldSetting.mapId == GameBoardManager.Get().gameBoard.DataId)
    //             _fieldSettingToUse = fieldSetting;
    //     }
    // }
    //
    // private void Update()
    // {
    //     if(_fieldSettingToUse == null)
    //         return;
    //     
    //     if (_fieldSettingToUse.checkUnitCountSettings.Length == 0 || _completed)
    //         return;
    //     
    //     var isAllUnitCountSatisfied = true;
    //     foreach (var checkUnitCountSetting in _fieldSettingToUse.checkUnitCountSettings)
    //     {
    //         var unitDataId = checkUnitCountSetting.unitDataId;
    //         var thresholdCount = checkUnitCountSetting.count;
    //
    //         var unitCount = GameBoardManager.Get().gameBoard.GetUnitCountByDataId(unitDataId);
    //         isAllUnitCountSatisfied &= unitCount <= thresholdCount;
    //     }
    //
    //     if (isAllUnitCountSatisfied && MyPlayer.GameUnit.IsAlive)
    //     {
    //         _completed = true;
    //         //GameManager.Get().ShowCenterLabel("처치 조건 달성!", Color.white);
    //         TempDB.completedMapIds.Add(GameBoardManager.Get().gameBoard.DataId);
    //
    //         GameScene.Get().StartCoroutine(GoToMap(_fieldSettingToUse.goToMapId, _fieldSettingToUse.goToDelay));
    //     }
    // }
    //
    // private IEnumerator GoToMap(int mapId, int delay)
    // {
    //     while (delay >= 0)
    //     {
    //         GameManager.Get().ShowToast($"맵 이동 {delay}초 전...");
    //         yield return new WaitForSeconds(1f);
    //         delay--;
    //     }
    //
    //     GameBoardManager.Get().GoToMap(mapId, TempDB.previousPosition, TempDB.previousDirection);
    // }
}

public static class TempDB
{
    // public static int previousMapId;
    // public static Vector2 previousPosition;
    // public static Vector2 previousDirection;
    // public static List<int> completedMapIds = new ();
}