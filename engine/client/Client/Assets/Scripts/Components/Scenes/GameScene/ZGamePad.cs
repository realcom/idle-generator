using System;
using System.Collections.Generic;
using System.Linq;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Players;
using UnityEngine;
using UnityEngine.Serialization;
using UnityEngine.UI;


public class ZGamePad : MonoBehaviour
{
    [Serializable]
    public class TriggerButton
    {
        public PlayerTriggerType trigger;
        public GameObject go;
        public ZButton bt;
    }

    public enum PlayerTriggerType
    {
        NONE = -1,
        PORTAL = 0,
        DIALOG = 1,
        CLIMB = 2,
    }
    
    public readonly Dictionary<PlayerTriggerType, object> triggers = new ();
    
    public void SetTriggerActive(PlayerTriggerType t, bool active, object obj = null)
    {
        if (active)
            triggers[t] = obj;
        else
            triggers.Remove(t);
        RefreshTriggerButtons();
    }

    [Serializable]
    public class SkillGroup
    {
        public ResourceItem.Types.Type weaponType;
        public int[] ids;
        public int combo;
        public int dash;
        public int change;
        public int parry;
        public int tempWeaponId;
    }

    [Header("Movement Controller")]
    public DpadController dpadController;
    public GameObject goShowTouch;
    
    [Header("Buttons")] 

    public TriggerButton[] triggerButtons;

    [Header("Config")] 
    public SkillGroup[] skillGroups;

    private bool _gamePadEnabled = true;
    private Vector3 _touchMovePosition;
    private double _lastTouchTime;
    
    // settings
    public readonly GamePrefs<int> dpadShowType = new GamePrefs<int>(Constants.Key.PAD_SETTINGS_DPAD_SHOW_TYPE, 0, false, true);
    public readonly GamePrefs<bool> dpadPosFixed = new GamePrefs<bool>(Constants.Key.PAD_SETTINGS_DPAD_POSITION_FIXED, true, false, true);
    public readonly GamePrefs<bool> autoSwapWeapon = new GamePrefs<bool>(Constants.Key.PAD_SETTINGS_AUTO_WEAPON_SWAP, true, false, true);
    private readonly GamePrefs<bool> _autoMode = new(Constants.Key.PAD_SETTINGS_AUTO_MODE, false);
    private readonly GamePrefs<bool> _touchMoveEnabled = new(Constants.Key.PAD_SETTINGS_TOUCHMOVE_ENABLED, false);
    
    public void Initialize()
    {
        // EnableGamePad();
        // InitButtons();
        // RefreshTriggerButtons();
        // RefreshSkillButtons();
        // RefreshItemButton();
    }
    
    private void Update()
    {
        if (_gamePadEnabled) 
        {
            if (!TryManualInput())
                TryAutoCombat();
        }

        if (_useSkillLaterUntilAt <= Utility.GetTime())
            ClearSkillLater();

        if (_useSkillLaterID > 0 && MyPlayer.GameUnit.CanUseSkill(_useSkillLaterID))
        {
            UseSkill(_useSkillLaterID);
            ClearSkillLater();
        }
        
        // if (Input.GetMouseButtonDown(0))
        //     OnComboSkill();
        if (Input.GetKeyDown(KeyCode.Q))
            OnSkill(0);
        if (Input.GetKeyDown(KeyCode.E))
            OnSkill(1);
        if (Input.GetKeyDown(KeyCode.R))
            OnSkill(2);
        // if (Input.GetKeyDown(KeyCode.R))
        //     OnParrySkill();
        if (Input.GetKeyDown(KeyCode.X))
            OnChangeSkill();
        if (Input.GetKeyDown(KeyCode.Space))
            OnDashSkill();
        if (Input.GetKeyDown(KeyCode.Y))
            ToggleTouchMove();
    }

    private bool TryManualInput()
    {
        if (_touchMoveEnabled.Get())
        {
            GetTouchMove();
            // condition for sending path finding action is different from directional movement
            if (_touchMovePosition == Vector3.zero || _touchMovePosition == _lastTouchMovePosition)
                return false;

            GameBoardManager.Get().UpdatePositionMove(_touchMovePosition.XZ());
            _lastTouchMovePosition = _touchMovePosition;
        }
        else
        {
            var dpadDirection = dpadController.direction.XZ();
            if (dpadDirection == Vector2.zero && _lastDpadDirection == Vector2.zero)
                return false;

            GameBoardManager.Get().UpdateDirectionMove(dpadDirection);
            _lastDpadDirection = dpadDirection;
        }
        return true;
    }

    private float _autoAfterSkillBlockTimeDelta = 4f; // TODO: should be set at game data
    private float _autoAfterSkillBlockTime;
    private float _autoAfterComboBlockTimeDelta = 0.0f; // TODO: should be set at game data
    private float _autoAfterComboBlockTime;
    private void TryAutoCombat()
    {
        //if (!MyPlayerSystem.enableAutoAttack)
        //    return;
        //
        //var myUnit = MyPlayer.GameUnit;
        //
        //// TODO: get from mygameunit property
        //var firstComboSkill = ResourceSkill.Get(comboSkillButton.resSkill.Id + 1);
        //var minimalAttackRange = firstComboSkill?.ClientAttackSquaredDistance * 0.7f ?? 0f;
        //var dashRange = minimalAttackRange * 4;
        //var useAutoMode = _autoMode.Get();
        //var validTargetRange = useAutoMode ? dashRange : minimalAttackRange;
        //
        //var targetId = myUnit.TargetUnitId;
        //var target = GameBoardManager.Get().gameBoard?.GetUnitById(targetId);
        //if (target == null)
        //    return;
        //
        //var dir = (Vector2)target.Position - (Vector2)myUnit.Position;
        //var dMag = dir.sqrMagnitude;
        //
        //var skillBlocked = _autoAfterSkillBlockTime > 0f;
        //
        //// Auto attack FSM logic
        //var dashSkillID = dashSkillButton.resSkill.Id;
        //var canDash = useAutoMode && dMag >= dashRange && myUnit.CanUseSkill(ResourceSkill.Get(dashSkillID));
        //if (useAutoMode && canDash)
        //{
        //    Look(dir);
        //    UseSkill(dashSkillID);
        //    _autoAfterSkillBlockTime += _autoAfterSkillBlockTimeDelta;
        //}
        //else if (useAutoMode && dMag > minimalAttackRange)
        //{
        //    GoTo(target.Position);
        //}
        //else if (dMag <= minimalAttackRange)
        //{
        //    var canUseCombo = true;
        //
        //    if (useAutoMode)
        //    {
        //        if (!skillBlocked && myUnit.CanUseSkill(skillButtons[0].resSkill))
        //        {
        //            Look(dir);
        //            OnSkill(0, autoUsed: true);
        //            _autoAfterSkillBlockTime += _autoAfterSkillBlockTimeDelta;
        //            canUseCombo = false;
        //        }
        //        else if (!skillBlocked && myUnit.CanUseSkill(skillButtons[1].resSkill))
        //        {
        //            Look(dir);
        //            OnSkill(1, autoUsed: true);
        //            _autoAfterSkillBlockTime += _autoAfterSkillBlockTimeDelta;
        //            canUseCombo = false;
        //        }
        //        else if (!skillBlocked && myUnit.CanUseSkill(skillButtons[2].resSkill))
        //        {
        //            Look(dir);
        //            OnSkill(2, autoUsed: true);
        //            _autoAfterSkillBlockTime += _autoAfterSkillBlockTimeDelta;
        //            canUseCombo = false;
        //        }
        //        // else if (_autoSwapWeapon && &&!skillBlocked && myUnit.CanUseSkill(changeSkillButton.resSkill))
        //        // {
        //        //     Look(dir);
        //        //     OnChangeSkill();
        //        //     _autoAfterSkillBlockTime += _autoAfterSkillBlockTimeDelta;
        //        //     canUseCombo = false;
        //        // }
        //    }
        //
        //    var isComboBlocked = _autoAfterComboBlockTime > 0f;
        //    if (canUseCombo && !isComboBlocked && myUnit.CanUseSkill(comboSkillButton.resSkill))
        //    {
        //        // if (comboSkillButton.resSkill.type == Old_ResourceSkill.Type.HITSCAN && ZNavMeshAgent.Get().path.corners.Length > 2) // check if wall exists between player and target
        //        // {
        //        //     // moving around wall
        //        //     dir = ZNavMeshAgent.Get().direction;
        //        //     Move(dir);
        //        // }
        //        // else
        //        // {
        //            Look(dir);
        //            OnComboSkill();
        //        // }
        //        
        //        _autoAfterComboBlockTime += _autoAfterComboBlockTimeDelta;
        //    }
        //    
        //    _autoAfterSkillBlockTime = Mathf.Max(0, _autoAfterSkillBlockTime - Time.deltaTime);
        //    _autoAfterComboBlockTime = Mathf.Max(0, _autoAfterComboBlockTime - Time.deltaTime);
        //}
    }

    private Vector3 _lastTouchMovePosition;
    private Vector2 _lastDpadDirection = Vector2.down;

    private void ToggleTouchMove()
    {
        _touchMoveEnabled.Set(!_touchMoveEnabled.Get());
        dpadController.SetActive(!dpadController.gameObject.activeSelf);
        _touchMovePosition = Vector3.zero;
    }

    private void GetTouchMove()
    {
        // temp
        var myUnit = MyGameUnitObject.Get();
        if (!myUnit)
            return;

        var d = _touchMovePosition.XZ() - MyGameUnitObject.Get().transform.position.XZ();
        var sqrMag = d.sqrMagnitude;
        if (sqrMag < 0.1f)
        {
            _touchMovePosition = Vector3.zero;
            goShowTouch.SetActive(false);
        }

        var now = Utility.GetTime();

        if (_lastTouchTime + 0.3f > now)
            return;

        var touchPosition = Vector3.zero;
        if (Input.GetMouseButton(0))
        {
            touchPosition = Input.mousePosition;
        }
        else if (Input.touchCount > 0)
        {
            var touch = Input.GetTouch(0);
            touchPosition = touch.position;
        }

        if (touchPosition != Vector3.zero)
        {
            var ray = GameScene.Get().GetCamera().ScreenPointToRay(touchPosition);
            if (Physics.Raycast(ray, out var hit, Mathf.Infinity, LayerMask.GetMask("Ground")))
            {
                _lastTouchTime = now;
                _touchMovePosition = hit.point;
                goShowTouch.SetActive(true);
                goShowTouch.transform.position = _touchMovePosition + Vector3.up * 0.02f;
                // this.Run(() =>
                // {
                //     goShowTouch.SetActive(false);
                // }, 2f);
                // Debug.Log($"TouchMovePosition: {touchMovePosition}");
            }
        }
    }

    private void InitButtons()
    {
        // btAuto.SetActive(resMap != null && resMap.type != Old_ResourceMap.Type.LOBBY && resMap.autoEnabled);
        //btAuto.SetOnClick(() =>
        //{
        //    _autoMode.Set(!_autoMode.Get());
        //    btAuto.interactable = !_autoMode.Get();
        //});
        //btAuto.SetOnClickDisabled(() =>
        //{
        //    _autoMode.Set(!_autoMode.Get());
        //    btAuto.interactable = !_autoMode.Get();
        //});
    }

    public void RefreshSkillButtons()
    {
        //var myGameUnit = MyPlayer.GameUnit;
        //var weapon = myGameUnit.PlayerAvatar.Weapons[myGameUnit.PlayerAvatarWeaponSlot];
        //var weaponType = weapon.GetData()?.Type;
        //if (weaponType == null)
        //{
        //    Debug.LogError($"Invalid weapon data: {weapon}");
        //    return;
        //}
        //
        //var skillGroup = skillGroups.FirstOrDefault(x => x.weaponType == weaponType);
        //if (skillGroup == null)
        //{
        //    Debug.LogError($"Invalid skill group for weapon category: {weaponType}");
        //    skillGroup = skillGroups.First();
        //}
        //
        //for (var i = 0; i < skillGroup.ids.Length; i++)
        //{
        //    var id = skillGroup.ids.GetSafe(i);
        //    var _i = i;
        //    skillButtons[i].Refresh(ResourceSkill.Get(id), () => OnSkill(_i));
        //}
        //comboSkillButton.Refresh(ResourceSkill.Get(skillGroup.combo), OnComboSkill);
        //altComboSkillButton.Refresh(ResourceSkill.Get(skillGroup.combo), OnComboSkill);
        //parrySkillButton.Refresh(ResourceSkill.Get(skillGroup.parry), OnParrySkill);
        //changeSkillButton.Refresh(ResourceSkill.Get(skillGroup.change), OnChangeSkill);
        //dashSkillButton.Refresh(ResourceSkill.Get(skillGroup.dash), OnDashSkill);
        //altDashSkillButton.Refresh(ResourceSkill.Get(skillGroup.dash), OnDashSkill);
    }
    
    public void RefreshTriggerButtons()
    {
        var selectedTrigger = PlayerTriggerType.NONE;
        object selectedTriggerObj = null;
        
        if (triggers.TryGetValue(PlayerTriggerType.CLIMB, out var obj))
            selectedTrigger = PlayerTriggerType.CLIMB;
        else if (triggers.TryGetValue(PlayerTriggerType.PORTAL, out obj))
            selectedTrigger = PlayerTriggerType.PORTAL;
        else if (triggers.TryGetValue(PlayerTriggerType.DIALOG, out obj))
            selectedTrigger = PlayerTriggerType.DIALOG;
        selectedTriggerObj = obj;
        
        foreach (var tb in triggerButtons)
        {
            tb.go.SetActive(selectedTrigger == tb.trigger);
            if (tb.bt)
            {
                tb.bt.SetOnClick(() =>
                {
                    GameManager.Get().DispatchEvent(GameEventType.MY_PLAYER_TRIGGERED, tb.trigger, selectedTriggerObj);
                });
            }
        }
    }

    public void RefreshItemButton()
    {
        // var myPlayer = MyPlayer.Get();
        // if (myPlayer != null)
        // {
        //     for (var i = 0; i < useItemButtons.Length; ++i)
        //     {
        //         // var slot = i;
        //         // var titem = myPlayer.tplayer.@private.equipItems[i];
        //         // titem = myPlayer.GetItemByDataID(titem.dataID);
        //         var titem = myPlayer.GetOrCreateItem(ItemIDs.POTION);
        //         var useItemButton = useItemButtons[i];
        //         useItemButton.Refresh(titem);
        //         useItemButton.bt.onClick.RemoveAllListeners();
        //         useItemButton.bt.onClick.AddListener(() =>
        //         {
        //             if (useItemButton.resItem == null)
        //             {
        //                 GameManager.Get().PlayClick();
        //                 // GameManager.Get().ShowPopup<Popup_PotionEquip>().Initialize(slot);
        //             }
        //         });
        //     }
        // }
    }

    public void OnSkill(int idx, bool autoUsed = false) 
    {
        //UseSkillOrLater(skillButtons[idx].resSkill.Id, autoUsed: autoUsed);
        ClearSkillLater();
    }

    public void OnParrySkill()
    {
        //UseSkill(parrySkillButton.resSkill.Id);
        ClearSkillLater();
    }

    public void OnComboSkill()
    {
        //UseSkillOrLater(comboSkillButton.resSkill.Id);
    }
    
    public void OnDashSkill()
    {
        UseSkill(1011);
    }
    
    private int _tempWeaponIndex;
    public void OnChangeSkill()
    {
        var weaponIndex = MyPlayer.GameUnit.PlayerAvatarWeaponSlot + 1;
        if (weaponIndex >= PlayerAvatar.WeaponSlot.Size)
            weaponIndex = 0;
        
        if (!NetworkSystem.enableSocketConnection)
        {
            if (_tempWeaponIndex >= skillGroups.Length)
                _tempWeaponIndex = 0;
            
            weaponIndex = 0;
            MyPlayer.GameUnit.PlayerAvatar.Weapons[0] = new PlayerItemMessage { Id = 1, ItemDataId = skillGroups[_tempWeaponIndex++].tempWeaponId  };
            MyPlayer.GameUnit.SetStatDirty();
        }
        
        //if (MyPlayer.GameUnit.CanUseSkill(changeSkillButton.resSkill))
        //{
        //    UseSkill(changeSkillButton.resSkill.Id);
        //    GameBoardManager.Get().UpdateWeaponSlot(weaponIndex);
        //}
    }

    private int _useSkillLaterID;
    private double _useSkillLaterUntilAt;

    public void UseSkillOrLater(int id, bool autoUsed = false)
    {
        var resSkill = ResourceSkill.Get(id);
        if (resSkill == null)
            return;
        if (MyPlayer.GameUnit.CanUseSkill(resSkill.ItemDataId))
        {
            UseSkill(id);
            ClearSkillLater();
        }
        else
        {
            _useSkillLaterID = id;
            _useSkillLaterUntilAt = Utility.GetTime() + 0.333f;
        }
    }

    public bool UseSkill(int id, ushort targetUnitID = 0)
    {
        var resSkill = ResourceSkill.Get(id);
        if (resSkill == null || resSkill.Id == default)
        {
            Debug.LogError($"UseSkill: Invalid skill id: {id}");
            return false;
        }

        switch (resSkill.ProjectileType)
        {
            case ResourceSkill.Types.ProjectileType.Target:
                GameBoardManager.Get().UseTargetSkill(id, targetUnitID);
                break;
            default:
                GameBoardManager.Get().UseSkill(id);
                break;
        }
        return true;
    }

    public void ClearSkillLater()
    {
        _useSkillLaterID = 0;
        _useSkillLaterUntilAt = 0;
    }
    
    public void Look(Vector3 dir)
    {
        GameBoardManager.Get().UpdateDirectionMove(dir.XZ());
    }
    
    public void Look(Vector2 dir)
    {
        GameBoardManager.Get().UpdateDirectionMove(dir);
    }
    
    public void LookAt(Vector3 position)
    {
        var dir = position - MyGameUnitObject.Get().transform.position;
        Look(dir);
    }

    public void GoTo(Vector3 position)
    {
        GameBoardManager.Get().UpdatePositionMove(position.XZ());
    }
    
    public void GoTo(Vector2 position)
    {
        GameBoardManager.Get().UpdatePositionMove(position);
    }
    
    public void DisableGamePad()
    {
        _gamePadEnabled = false;
    }

    public void EnableGamePad()
    {
        _gamePadEnabled = true;
    }
}
