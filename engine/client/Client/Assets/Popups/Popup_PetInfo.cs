using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types.Players;
using Commons.Types.Units;
using Commons.Utility;
using Components.UI.Toggle;
using Cysharp.Threading.Tasks;
using DG.Tweening;
using Interfaces;
using Sirenix.OdinInspector;
using TMPro;
using UnityEngine;
using UnityEngine.Serialization;
using UnityEngine.UI;
public class Popup_PetInfo : UIPopup, IViewModePopup, IItemModelViewBasedPopup
{
    public ItemCellBehaviourWrapperElement petCell;
    [Range(0, 5)] public float statImprovePlaybackLatency = 1f;
    [Range(0, 1)] public float statCompositePlayback = 0.5f;

    public Image ItemCellAdditiveBlur;
    
    public StatGroup hpGroup;
    public StatGroup attackGroup;
    public StatGroup defenseGroup;
    
    public TextMeshProUGUI txtSkillName;
    public TextMeshProUGUI txtSkillDesc;

    public UITabBar tabBar;


    [Serializable]
    public struct StatGroup
    {
        public HorizontalLayoutGroup txtHLayoutGroup;
        public TextMeshProUGUI txtStatValue;
        public TextMeshProUGUI txtStatImproveValue;
        public Image levelUpVFXImage;
        public Gradient statValueLevelUpGradient;
    }
    
    [Serializable]
    public class UpgradeCell : UIElement
    {
        public Image imgIcn_Star;
        public TextMeshProUGUI txtLevel;
        public TextMeshProUGUI txtAddStatsDesc;
        public CanvasGroup cgCell;
        [ForceCache] public PetInfoUpgradeCellController cellController;
    }

    [Serializable]
    public class UpgradeAddStatsCellTableElement : UITableElement<UpgradeCell>
    {
        
    }

    [FoldoutGroup("Upgrade")] public TextMeshProUGUI txtQuickUpgradeLevel;
    [FoldoutGroup("Upgrade")] public UpgradeAddStatsCellTableElement tableElements = new();
    [FoldoutGroup("Upgrade/Material")] public TextMeshProUGUI txtUpgradeMaterials = new();

    [Serializable]
    public class OptionCell : UIElement
    {
        public Image imgIcon_Grade_Skill;
        public TextMeshProUGUI txtGrade;
        public CustomButton btnCell;
        public CustomToggle toggleLock;
        public TextMeshProUGUI txtDesc;
    }

    [FoldoutGroup("Potential")] public TextMeshProUGUI txtPotentialLevel;
    [FoldoutGroup("Potential")] public TextMeshProUGUI txtPotentialExp;
    [FoldoutGroup("Potential")] public Slider sliderPotentialExpProgress;
    [FoldoutGroup("Potential")] public UIElementContainer<OptionCell> options = new();
    [FoldoutGroup("Potential/Material")] public TextMeshProUGUI txtRerollMaterials = new();

    [FoldoutGroup("Potential/Material/Premium")]
    public RectTransform rtPremiumDiscount;

    [FoldoutGroup("Potential/Material/Premium")]
    public TextMeshProUGUI txtPremiumDiscountPercent;
    
    [FoldoutGroup("VFX")] public LevelStarsWithVFX levelStarsWithVFX;

    public CustomButton btnEquip;
    public CustomButton btnUnEquip;
    public CustomButton btnUpgrade;
    public CustomButton btnQuickUpgrade;
    public CustomButton btnRerollOptions;
    
    [SerializeField] protected GameObject[] viewOnlyExcludeObjects = new GameObject[0];

    private long _petId;
    public IItemModelViewFormatter formatter => petItem ?? _formatter;
    private IItemModelViewFormatter _formatter;
    private PlayerItemMessage petItem => MyPlayer.GetItem(_petId);

    public void Initialize(PlayerItemMessage inPet)
    {
        OnInitialized(inPet);
    }
    
    public void Initialize(IItemModelViewFormatter itemModelViewFormatter)
    {
        viewMode = IViewModePopup.ViewMode.ViewOnly;
        OnInitialized(itemModelViewFormatter);
    }

    public void OnInitialized(IItemModelViewFormatter itemModelViewFormatter)
    {
        _petId = itemModelViewFormatter.Id;
        _formatter = itemModelViewFormatter;
        AddRefreshAll();
    }

    protected override void Start()
    {
        btnEquip.SetOnClick(OnClickEquip);
        btnUnEquip.SetOnClick(OnClickUnEquip);
        btnUpgrade.SetOnClick(OnClickUpgrade);
        btnQuickUpgrade.SetOnClick(OnClickQuickUpgrade);
        btnRerollOptions.SetOnClick(OnClickRerollOptions);

        tabBar.onTabSelected.RemoveAllListeners();
        tabBar.onTabSelected.AddListener((_) => AddRefreshFlag(RefreshFlag.ALL));

        base.Start();
    }

    private void RefreshInfos()
    {
        var formatterItem = formatter;
        petCell.Get<PetCell>().Refresh(formatterItem);
        levelStarsWithVFX.Refresh(formatterItem);
        
        RefreshStats();

        var resPet = formatterItem.GetData()!;
        var level = formatterItem.GetLevel();

        var resSkill = ResourceSkill.Get(resPet.EquipSkillDataIds.GetClamped(level - 1))!;

        txtSkillName.text = resSkill.ClientName;
        txtSkillDesc.text = resSkill.ClientDesc;
    }

    private void FreezeRefreshStats()
    {
        _blockRefreshStats = true;
    }
    
    private void UnfreezeRefreshStats()
    {
        _blockRefreshStats = false;
        RefreshStats();
    }
    
    private bool _blockRefreshStats = false;
    private void RefreshStats()
    {
        if (_blockRefreshStats)
            return;
        
        var formatterItem = formatter;
        
        var resPet = formatterItem.GetData()!;
        var level = formatterItem.GetLevel();
        
        hpGroup.txtStatValue.text = resPet.EquipAddStats.GetStatInfo(UnitStatType.Hp).GetFormatString(level);
        attackGroup.txtStatValue.text = resPet.EquipAddStats.GetStatInfo(UnitStatType.Attack).GetFormatString(level);
        defenseGroup.txtStatValue.text = resPet.EquipAddStats.GetStatInfo(UnitStatType.Defense).GetFormatString(level);
    }

    private void RefreshUpgradeTab()
    {
        var formatterItem = formatter;
        var resPet = formatterItem.GetData()!;
        var petLevel = formatterItem.GetLevel();
        var isMaxLevel = resPet.MaxLevel <= petLevel;

        using (var interactor = new ButtonInteractor(btnUpgrade))
        {
            if (!isMaxLevel)
            {
                var group = resPet.GetMaterialItemGroupByLevel(petLevel);
                interactor.Update(MyPlayer.HasEnoughMaterial(group, resPet.GetPurchaseUnit()).hasEnoughMaterial, "HasNotEnoughMaterial".L());
            }
            else
            {
                interactor.Update(false, "MaxLevel".L());
            }
        }
        
        using (var interactor = new ButtonInteractor(btnQuickUpgrade))
        {
            if (!isMaxLevel)
            {
                var group = resPet.GetMaterialItemGroupByLevel(petLevel);
                interactor.Update(MyPlayer.HasEnoughMaterial(group, resPet.GetPurchaseUnit()).hasEnoughMaterial, "HasNotEnoughMaterial".L());
            }
            else
            {
                interactor.Update(false, "MaxLevel".L());
            }
        }

        if (!isMaxLevel)
        {
            var group = resPet.GetMaterialItemGroupByLevel(petLevel);
            txtUpgradeMaterials.RefreshRequirements(group.MaterialItems);    
        }
        else
        {
            txtUpgradeMaterials.text = "";
        }

        var upgradeableCount = MyPlayer.GetMaxQuickLevelUpCount(resPet, petLevel);
        txtQuickUpgradeLevel.text = "Level".L(petLevel + upgradeableCount);

        RefreshLevelStats();
        RefreshButtons();
        
        return;
        
        void RefreshButtons()
        {
            if (viewMode == IViewModePopup.ViewMode.ViewOnly)
                return;
            
            var isDeployed = petItem.IsDeployed();
            btnEquip.SetActive(!isDeployed);
            btnUnEquip.SetActive(isDeployed);
        }
    }

    private int curFocusIndex = -1; 
    private void RefreshLevelStats(PlayerItemMessage curItem = null, bool isCallByCallback = false)
    {
        var formatterItem = curItem ?? formatter;
        
        var resPet = formatterItem.GetData()!;
        var petLevel = formatterItem.GetLevel();
        
        var focusIndex = resPet.StatChangedLevels.FindLastIndex(x => x <= petLevel); 
        tableElements.table.Initialize<int, UpgradeCell>(resPet.StatChangedLevels, (list, i, cell) =>
        {
            var level = list.GetSafe(i);
            var starSpriteIndex = (level - Constants.STAR_GRADE_UNIT) / (Constants.STAR_GRADE_UNIT * Constants.STAR_GRADE_UNIT);
            cell.imgIcn_Star.sprite = CRC.Get().levelStarSprites.GetClamped(starSpriteIndex);
            cell.txtLevel.text = "Level".L(level);
            cell.txtAddStatsDesc.text = resPet.GetLocalizedString($"PetAddStatsDesc_{i + 1}");

            bool isCellUnlock = petLevel >= level;
            cell.cgCell.alpha = isCellUnlock ? 1f : 0.5f;
            
            // 버튼으로 호출되었고, 현재 실제 레벨이랑 언락된 최근 레벨이 같을 경우.
            if (isCallByCallback && level == petLevel)
            {
                cell.cellController.PlaySequence();
            }
        });

        if (curFocusIndex != focusIndex)
        {
            tableElements.table.DoScrollToIndex(focusIndex, 0.3f).SetEase(Ease.InOutCubic);
        }
        curFocusIndex = focusIndex;

        Debug.Log("Call ScrollToIndex");
    }
    
    private void RefreshPotentialTab()
    {
        if (viewMode == IViewModePopup.ViewMode.ViewOnly)
            return;
        
        var pet = petItem;
        if (pet == null)
            return;
        
        var resPet = pet.GetData()!;
        var potentialLevelItem = MyPlayer.GetItemsByType(ResourceItem.Types.Type.PotentialLevel).FirstOrDefault(x => x.IsValid());
        if (potentialLevelItem == null)
        {
            "Potential_Option_Locked".ToToast();
            tabBar.selectedIndex = 0;
            return;
        }
        
        var resPotentialLevel = potentialLevelItem.GetData()!;
        var potentialBaseLevel = potentialLevelItem.Level;
        var potentialBonusLevel = potentialLevelItem.GetBonusLevel();
        var potentialLevel = potentialBaseLevel + potentialBonusLevel;

        var color = potentialBonusLevel > 0 ? Color.yellow : Color.white;
        var inColorizedText = $"<color=#{color.ToHex()}>{potentialLevel}</color>";
        txtPotentialLevel.text = "PotentialLevel".L(inColorizedText);
        var exp = potentialLevelItem.Exp;
        var requiredExp = resPotentialLevel.RequiredExps.GetClamped(potentialBaseLevel - 1);
        txtPotentialExp.text = resPotentialLevel.MaxLevel > potentialBaseLevel ? $"{exp}/{requiredExp}" : "MAX".L();
        sliderPotentialExpProgress.value = exp / (float)requiredExp;
        
        RefreshOptions();
        RefreshMaterials();
        
        return;
        
        void RefreshOptions()
        {
            var currentOpenOptionCount = resPet.OptionCounts.GetClamped(potentialLevel - 1);
            var maxOptionCount = resPet.OptionCounts.Max();
            foreach (var (cell, i) in options.GetElements(maxOptionCount))
            {
                var option = pet.Option?.RerollOptions?.GetSafe(i);
                var isLocked = i + 1 > currentOpenOptionCount;
                var isEmpty = !isLocked && option?.Id == 0;
                var isValid = option != null && !isEmpty && !isLocked;
                
                var optionGroup = option != null ? resPet.Options.GetClamped(option.PoolId - 1) : null;
                var optionData = optionGroup?.OptionsById.GetValueOrDefault(option.Id);

                var optionGrade = optionData?.Grade ?? 0;
                cell.imgIcon_Grade_Skill.sprite = CRC.Get().gradeSymbolSprites.GetClamped(isValid ? optionGrade : 0);
                cell.txtGrade.text = isLocked ? "ICN_Locked".L() : optionGrade.ToLocalizedPotentialGradeString();

                if (isLocked)
                {
                    cell.txtDesc.text = $"Potential_Option_Locked_{i}".L();
                }
                else if (isEmpty)
                {
                    cell.txtDesc.text = "Potential_Option_Empty".L();
                }
                else
                {
                    var info = optionData!.EquipAddStats.AsSorted().First();
                    cell.txtDesc.text = info.GetInlineFormatString(option.Level, false);
                }
                
                cell.btnCell.interactable = isValid;
                cell.btnCell.SetOnClick(() =>
                {
                    SendPacket(Packet.Pop(0, new UseCashItemRequest()
                    {
                        ItemId = pet.Id,
                        Param2 = cell.toggleLock.isOn ? 2 : 1,
                        Slot = i
                    }), this.GetCancellationTokenOnDestroy()).Forget();
                });

                cell.toggleLock.isOn = pet.Param3.IsBitSet(i);
                //var option = pet.Option.RerollOptions.
            }
        }

        void RefreshMaterials()
        {
            var discountPercent = MyPlayer.GetItemsByTag(Tag.DiscountPetOptionRerollMaterialPrice).Sum(x => x.IsValid() ? x.GetData()!.DiscountMaterialPricePercent : 0f);
            var multiplier = Math.Max(0f, 1f - discountPercent / 100f);

            var materialGroupLevel = Math.Min(potentialLevel, resPet.RerollMaterialItemGroups.Max(x => x.Level));
            var group = resPet.RerollMaterialItemGroups.Where(x => x.Level == materialGroupLevel).ElementAt(pet.Param3.CountBits());
            
            using (var interactor = new ButtonInteractor(btnRerollOptions))
            {
                interactor.Update(MyPlayer.HasEnoughMaterial(group, resPet.GetPurchaseUnit(), multiplier).hasEnoughMaterial, "HasNotEnoughMaterial".L());
            }

            txtRerollMaterials.RefreshRequirements(group.MaterialItems, multiplier);
            
            rtPremiumDiscount.SetActive(discountPercent > 0f);
            txtPremiumDiscountPercent.text = "Popup_PetInfo_Premium_Discount".L($"{discountPercent:00}%");
        }
    }

    public override void Refresh()
    {
        base.Refresh();
        
        RefreshInfos();

        switch (tabBar.selectedIndex)
        {
            case 0:
            {
                RefreshUpgradeTab();
                break;
            }
            case 1:
            {
                RefreshPotentialTab();
                break;
            }
        }
        
        UpdateView();
    }

    protected override void RefreshByFlag()
    {
        if (refreshFlag.ContainsFlag(RefreshFlag.MY_ACHIEVEMENT_UPDATED | RefreshFlag.MY_AVATAR_UPDATED | RefreshFlag.MY_PLAYER_ITEM_UPDATED))
            Refresh();
    }

    public void OnClickLevelDown()
    {
        if (viewMode == IViewModePopup.ViewMode.ViewOnly)
            return;
        
        SendPacket(Packet.Pop(0, new LevelDownItemRequest()
        {
            ItemId = petItem.Id
        }), this.GetCancellationTokenOnDestroy()).Forget();
    }

    public void OnClickSkillDetail()
    {
        GameManager.Get().GetOrShowPopup<Popup_Info_Skill>().Initialize(formatter);
    }
    
    public void OnClickPotentialDetail()
    {
        var potentialLevelItem = MyPlayer.GetItemsByType(ResourceItem.Types.Type.PotentialLevel).First(x => x.IsValid());
        GameManager.Get().ShowPopup<Popup_Info_PotentialLevel>().Initialize(potentialLevelItem.GetData());
    }

    private void OnClickEquip()
    {
        if (viewMode == IViewModePopup.ViewMode.ViewOnly)
            return;
        
        if (!Popup_Pet.QuickDeployPet(petItem))
        {
            var popupPet = GameManager.Get().GetPopup<Popup_Pet>();
            if (popupPet != null)
                popupPet.StartDeploySlotSelect(petItem);
        }
        
        OnCancel();
    }

    private void OnClickUnEquip()
    {
        if (viewMode == IViewModePopup.ViewMode.ViewOnly)
            return;
        
        var slot = MyPlayer.PlayerAvatar?.GetDeployedPetSlot(petItem.Id) ?? -1;
        if (slot > -1)
        {
            SendPacket(Packet.Pop(0, new UseCashItemRequest()
            {
                ItemId = petItem.Id,
                Slot = slot,
                Param1 = 1
            }), this.GetCancellationTokenOnDestroy()).Forget();
        }
    }

    private void OnClickUpgrade()
    {
        if (viewMode == IViewModePopup.ViewMode.ViewOnly)
            return;
                
        RequestLevelUpPet().Forget();
    }

    private async UniTask RequestLevelUpPet()
    {
        var pet = petItem;

        _oldPetItem ??= pet; // 강화 애니메이션 시퀀스가 시작(반복)할 당시의 값
        _curPetItem = pet; // 강화 버튼 누르기 직전의 값
        
        var response = await SendPacket<LevelUpItemRequest.Types.Response>(Packet.Pop(0, new LevelUpItemRequest()
        {
            ItemId = pet.Id,
            Count = 1,
        }), this.GetCancellationTokenOnDestroy());

        if (!response.Status.IsSuccess())
            return;
        
        var newPet = response.Items.First();
        levelStarsWithVFX.UpdateStar(_curPetItem, newPet);
                
        //별 이펙트, 별 강화 능력치 이펙트 재생
        if (LevelStars.IsChanged(_curPetItem.Level, newPet.Level))
        {
            
        }
                
                
        //기존 재생 중인 코루틴 제거
        _petUpgradeSequenceCoroutine?.Dispose();
        _petUpgradeSequenceCoroutine = this.StartCoroutineTree(tree => IPetUpgradeSequence(tree, newPet));
    }
    
    
    private void OnClickQuickUpgrade()
    {
        if (viewMode == IViewModePopup.ViewMode.ViewOnly)
            return;
        
        var item = petItem;
        var levelUpRequestCount = MyPlayer.GetMaxQuickLevelUpCount(item);
        SendPacket(Packet.Pop(0, new LevelUpItemRequest()
        {
            ItemId = item.Id,
            Count = levelUpRequestCount,
        }), this.GetCancellationTokenOnDestroy()).Forget();
    }
    
    private void OnClickRerollOptions()
    {
        if (viewMode == IViewModePopup.ViewMode.ViewOnly)
            return;
        
        SendPacket(Packet.Pop(0, new RerollItemOptionRequest
        {
            ItemId = petItem.Id,
            Slot = -1
        }), this.GetCancellationTokenOnDestroy()).Forget();
    }

    private PlayerItemMessage _oldPetItem = null;
    private PlayerItemMessage _curPetItem = null;
    
    private CoroutineTree _petUpgradeSequenceCoroutine;
    private IEnumerator IPetUpgradeSequence(CoroutineTree tree, PlayerItemMessage newPetItem)
    {
        //1. UI 갱신 막기
        FreezeRefreshStats();
        //FreezeRefreshUpgradeTab();
        
        
        //2. 스탯 업그레이드 + 레벨업 애니메이션 시작
        tree.Start(IStatImproveSequence(UnitStatType.Attack, newPetItem, attackGroup));
        tree.Start(IStatImproveSequence(UnitStatType.Hp, newPetItem, hpGroup));
        tree.Start(IStatImproveSequence(UnitStatType.Defense, newPetItem, defenseGroup));
        tree.Start(IItemCellLevelUpVFX());
        
        //3. 레벨별 스텟강화 연출 시작.
        RefreshLevelStats(newPetItem, true);
        
        //!! 3. 특정 시간(스탯 업그레이드 일정 진행) 이후 인터랙션 막기 (Tween의 종료 조건으로 하면 타이밍 처리가 애매할 것 같음)
        yield return Utility.GetWaitForSeconds(statImprovePlaybackLatency);
        
        FreezeInteraction();
        
        //4. 이후 애니메이션 진행 (합쳐지고, 띠리링)
        tree.Start(IStatCompositeSequence(UnitStatType.Hp, newPetItem, hpGroup));
        tree.Start(IStatCompositeSequence(UnitStatType.Attack, newPetItem, attackGroup));
        tree.Start(IStatCompositeSequence(UnitStatType.Defense, newPetItem, defenseGroup));
        yield return Utility.GetWaitForSeconds(statCompositePlayback);

        //연출이 정상적으로 끝나면 oldPetItem을 null로 초기화하고, 데이터 갱신을 허용
        _oldPetItem = null;
        
        //혹시 남아있을 연출을 삭제하기 위해 변경된 값들을 초기화.
        InitStatElement(UnitStatType.Hp, hpGroup);
        InitStatElement(UnitStatType.Attack, attackGroup);
        InitStatElement(UnitStatType.Defense, defenseGroup);
        
        //시퀀스 모드 명시적으로 종료
        UnfreezeRefreshStats();
        EndSequenceMode();
        
        yield break;
    }
    
    private void InitStatElement(UnitStatType statType, StatGroup statGroup)
    {
        statGroup.txtStatValue.color = statGroup.statValueLevelUpGradient.Evaluate(1f);
        statGroup.txtHLayoutGroup.spacing = 25f;
        statGroup.txtStatImproveValue.SetAlpha(0f);
        statGroup.levelUpVFXImage.SetAlpha(0f);
    }

    private IEnumerator IStatImproveSequence(UnitStatType statType, PlayerItemMessage newItem, StatGroup statGroup)
    {
        if (_oldPetItem == null)
            yield break;
        
        //직전 레벨과 현재 레벨의 해당 스탯 타입 스탯 차이 비교 및 최종 변화량 반환
        if (!IsStatAccumulated(statType, newItem, out var totalAccumulatedValue))
            yield break;
        
        var resPet = _oldPetItem.GetData()!;
        var statInfo = resPet.EquipAddStats.GetStatInfo(statType);

        // 다를 경우 증가값 갱신 연출.
        // 1. 텍스트 스케일링 연출.
        statGroup.txtStatImproveValue.alpha = 1f;
        statGroup.txtHLayoutGroup.spacing = 25f;
        
        statGroup.txtStatImproveValue.text = statInfo.info.Format(totalAccumulatedValue) + "+";
        statGroup.txtStatImproveValue.transform.localScale = new Vector3(1.15f, 1.15f, 1.15f);
        statGroup.txtStatImproveValue.transform.DOKill();
        statGroup.txtStatImproveValue.transform.DOScale(Vector3.one, 0.2f).SetEase(Ease.OutExpo);
        
        // 2. Glow 연출
        Color glowColor = statGroup.levelUpVFXImage.color;
        glowColor.a = 1f;
        
        Color targetColor = statGroup.levelUpVFXImage.color;
        targetColor.a = 0f;
        
        statGroup.levelUpVFXImage.color = glowColor;
        statGroup.levelUpVFXImage.DOKill();
        statGroup.levelUpVFXImage.DOColor(targetColor, 0.2f).SetEase(Ease.OutCubic);
    }

    private IEnumerator IStatCompositeSequence(UnitStatType statType, PlayerItemMessage newPetItem,
        StatGroup statGroup)
    {
        if (_oldPetItem == null)
            yield break;

        IsStatAccumulated(statType, newPetItem, out var totalAccumulatedValue);
        if (totalAccumulatedValue <= 0f)
            yield break;
        
        FreezeRefresh();
        
        var resPet = _oldPetItem.GetData()!;
        var statInfo = resPet.EquipAddStats.GetStatInfo(statType);
        
        var oldPetValue = resPet.EquipAddStats.GetStatInfo(statType).GetValue(_oldPetItem.Level);
        var newPetValue = resPet.EquipAddStats.GetStatInfo(statType).GetValue(newPetItem.Level);
        
        // 1. 증가값 x축 움직임 애니메이션 (멀어진 후 가까워짐 + 
        Sequence spacingSequence = DOTween.Sequence();
        spacingSequence.Append(DOTween.To(() => 25f, x => statGroup.txtHLayoutGroup.spacing = x, 42.5f, 0.125f)
                .SetEase(Ease.OutExpo)) // 멀어짐
            
            .Append(DOTween.To(() => 42.5f, x => statGroup.txtHLayoutGroup.spacing = x, -30f, 0.3f)
                .SetEase(Ease.OutExpo)) // 이후 가까워짐
            
            .Join(DOTween.To(() => 1f, x => statGroup.txtStatImproveValue.alpha = x, 0f, 0.3f)
                .SetEase((Ease.OutQuart))// 동시에 알파값 0으로;
            );
        
        // 최종값 숫자 증가 애니메이션
        Color GetStatTextColor(float t)
        {
            return statGroup.statValueLevelUpGradient.Evaluate(t);
        };
        
        Sequence statImproveValueSequence = DOTween.Sequence();
        statImproveValueSequence.Insert(0.15f, DOTween.To(() => oldPetValue,
            x => statGroup.txtStatValue.text = statInfo.info.Format(x),
            newPetValue, 0.3f).SetEase(Ease.OutQuart));
        statImproveValueSequence.Join(
            DOTween.To(() => 0f, x => statGroup.txtStatValue.color = GetStatTextColor(x), 1f, 0.3f));
        statImproveValueSequence.Join(
            DOTween.To(() => 1.35f, x => statGroup.txtStatValue.transform.localScale = Vector3.one * x, 1f, 0.3f).SetEase(Ease.OutExpo)
            );
    }

    private IEnumerator IItemCellLevelUpVFX()
    {
        if (_oldPetItem == null)
            yield break;

        Color defaultColor = ItemCellAdditiveBlur.color;
        defaultColor.a = 1f;
        
        Color newColor = ItemCellAdditiveBlur.color;
        newColor.a = 0f;

        ItemCellAdditiveBlur.DOKill();
        ItemCellAdditiveBlur.color = defaultColor;
        ItemCellAdditiveBlur.DOColor(newColor, 0.3f).SetEase(Ease.OutCubic);
    }

    private bool IsStatAccumulated(UnitStatType stat, PlayerItemMessage newItem, out float totalAccumulatedValue)
    {
        totalAccumulatedValue = 0f;
        if (_curPetItem == null)
            return false;
        
        var resPet = newItem.GetData()!;

        var oldValue = resPet.EquipAddStats.GetStatInfo(stat).GetValue(_curPetItem.Level);
        var newValue = resPet.EquipAddStats.GetStatInfo(stat).GetValue(newItem.Level);
        
        var oldValueBeforeSequenceEnd = resPet.EquipAddStats.GetStatInfo(stat).GetValue(_oldPetItem.Level);
        totalAccumulatedValue = newValue - oldValueBeforeSequenceEnd;

        return newValue - oldValue > 0f;
    }

    public IViewModePopup.ViewMode viewMode { get; set; }

    public void UpdateView()
    {
        foreach (var viewOnlyExcludeObject in viewOnlyExcludeObjects)
        {
            if (viewOnlyExcludeObject)
                viewOnlyExcludeObject.SetActive(viewOnlyExcludeObject.activeSelf && viewMode != IViewModePopup.ViewMode.ViewOnly);
        }
    }
}
