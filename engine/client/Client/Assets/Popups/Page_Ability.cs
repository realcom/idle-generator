using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Coffee.UIExtensions;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Packets.Updates;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Players;
using Commons.Utility;
using Commons.Utility.ObjectPool;
using Cysharp.Threading.Tasks;
using DG.Tweening;
using Spine;
using TMPro;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.Pool;
using UnityEngine.UI;
using Random = UnityEngine.Random;

public class Page_Ability : ZModePage
{
    public const int AbilityStatItemTab = -1;
    
    public struct AbilityStepInfo
    {
        public ResourceAchievement resAchievement;
        public int level;
    }
    
    [Serializable]
    public class AbilityGradeCell : UIElement
    {
        public RectTransform rtBubbleParent;
        public GameObject goBubble;
        public GameObject goRewarded;

        public Image imgIcon;
        public Image imgBubble;
        
        public TextMeshProUGUI txtAmount;
        public TextMeshProUGUI txtLevel;
        
        public CustomButton btnBubble;
        
        public void Refresh(PlayerAchievementMessage achievement, int inCompleteLevel)
        {
            txtLevel.text = inCompleteLevel.ToString();
            
            var resAchievement = achievement.GetData()!;
            
            var isSpecial = resAchievement.ContainsTag(Tag.Main);
            rtBubbleParent.localScale = isSpecial ? Vector3.one * 1.5f : Vector3.one;
            goRewarded.SetActive(achievement.IsAchievementRewarded());
            
            var reward = resAchievement.RewardAddItemGroups.GetAddItem();
            var resItem = reward.GetData();
            imgIcon.sprite = resItem.GetSpriteByKey($"UnitTrainingRank_{reward.Level}", resItem.ClientSpriteIcon);
            txtAmount.text = reward.FormatCount(resItem.GetLocalizedString($"UnitTrainingRank_{reward.Level}", resItem.ClientName), int.MaxValue);

            btnBubble.SetOnClick(() => resItem.ShowInfoPopup());
        }
        
    }

    public UnitUIRenderer unitUIRenderer;
    public ParticleSystem psUnitLevelUp;
    public AbilityGradeCell cell1;
    public AbilityGradeCell cell2;
    public Slider sliderAbilityProgress;
    public TextMeshProUGUI txtAbilityProgress;
    public TextMeshProUGUI txtTrainingRank;
    public UIParticleAttractor attractor;
    public SpriteContainer spriteMaxLevelStatCell;

    [Serializable]
    public class StatCell : UIElement
    {
        public GameObject goCheckMark;
        
        public CustomButton btnCell;
        public CanvasGroup cgCell;
        public Animator animCell;
        
        public Image imgIcon;
        public Image imgCell;
        
        public TextMeshProUGUI txtLevel;
        public TextMeshProUGUI txtValue;
        public TextMeshProUGUI txtName;
        public TextMeshProUGUI txtMaterialPrice;

        public ParticleSystem psBurstParticle;

        private bool bSentRequest;
        
        public void Refresh(PlayerItemMessage statItem, int inFakeLevel, int inFakeMaxLevel)
        {
            var resItem = statItem.GetData()!;
            
            var isMaxLevel = inFakeLevel >= inFakeMaxLevel;
            //imgCell.highlighted = isMaxLevel;
            goCheckMark.SetActive(isMaxLevel);
            txtMaterialPrice.SetActive(!isMaxLevel);
            
            imgIcon.sprite = resItem.ClientSpriteIcon;
            
            var material = resItem.GetMaterialItemGroupByLevel(statItem.Level).MaterialItems.First()!;
            txtMaterialPrice.text = material.ToStringWithIcon();

            txtName.text = resItem.ClientName;
            txtLevel.text = isMaxLevel ? "MAX" : "Level_F".L(inFakeLevel);
            var originValue = resItem.AddStats.First().Value.GetClamped(statItem.Level);
            var fakeValue = originValue - resItem.AddStats.First().Value.GetClamped(statItem.Level - inFakeLevel);
            txtValue.text = fakeValue.ToUnitString();

            var hasEnoughMaterial = MyPlayer.HasEnoughMaterial(material, resItem.GetPurchaseUnit());
            using (var obj = new ButtonInteractor(btnCell))
            {
                obj.Update(hasEnoughMaterial, "HasNotEnoughMaterial".L());
                obj.Update(!isMaxLevel, "MaxLevel".L());
            }

            cgCell.alpha = isMaxLevel || hasEnoughMaterial ? 1f : 0.5f;
            
            btnCell.SetOnClick(() =>
            {
                DoLevelUp(statItem).Forget();
            });
        }
        
        private async UniTask DoLevelUp(PlayerItemMessage statItem)
        {
            animCell.SetTrigger(AnimatorHash.Glow);
                
            if (bSentRequest)
                return;

            var response = await ZWorldClient.Get().SendPacket(Packet.Pop(0, new LevelUpItemRequest()
            {
                ItemId = statItem.Id,
                Count = 1,
            }));

            bSentRequest = false;

            if (response.Status.IsSuccess())
                psBurstParticle.Emit(1);

        }
    }
    
    public UIElementContainer<StatCell> statCellContainer = new();

    public override void Awake()
    {
        base.Awake();

        statCellContainer.Elements.ForEach(x => attractor.AddParticleSystem(x.psBurstParticle));
    }

    public override void InitializeUsingToken(string[] tokens)
    {
        
    }

    public override void OnVisible()
    {
        var resItem = MyPlayer.PlayerAvatar.Character.GetData();
        unitUIRenderer.Initialize(resItem, "Walk");
        
        Refresh();
    }

    public override void OnHide()
    {
    }

    public override void Refresh()
    {
        if (!isActiveAndEnabled)
            return;
        
        base.Refresh();
        
        RefreshStatCells();
    }

    private void RefreshStatCells()
    {
        using var stats = PooledList<PlayerItemMessage>.Get();
        foreach (var itemMessage in MyPlayer.GetItemsByCategory(ResourceItem.Types.Category.Stat))
        {
            if (!itemMessage.IsValid(checkRequiredAndExclusive: true))
                continue;
            
            var resItem = itemMessage.GetData();
            if (resItem?.Tab != AbilityStatItemTab)
                continue;

            stats.Add(itemMessage);
        }

        stats.Sort((x, y) => x.ItemDataId.CompareTo(y.ItemDataId));

        var resAbilityRootAchievement = ResourceAchievement.Get(ResourceAchievement.Global.DataId.AbilityRoot);
        var abilityLevel = 0;
        var i = 0;

        const int n = 1;

        var idx1 = -1;
        var idx2 = -1;

        using var achievements = PooledList<AbilityStepInfo>.Get();
        for (var resAchievement = resAbilityRootAchievement; resAchievement != null; i++)
        {
            abilityLevel += resAchievement.TargetProgress;
            achievements.Add(new AbilityStepInfo()
            {
                resAchievement = resAchievement,
                level = abilityLevel
            });

            var achievement = MyPlayer.GetAchievementByDataID(resAchievement.Id);
            if (!achievement.IsAchievementCompletedOrRewarded())
            {
                idx2 = i;
                idx1 = idx2 - 1;
                break;
            }
            
            resAchievement = ResourceAchievement.Get(resAchievement.ChildAchievementDataIds.FirstOrDefault());
        }

        //최대 레벨 도달 시 Fallback
        if (idx2 == -1)
        {
            idx2 = i - 1;
            idx1 = idx2 - 1;
        }

        //order 값에서 시작 분기 레벨 지정
        var fakeStartLevel = achievements.GetClamped(idx2).resAchievement.Order;

        var currentLevel = 0;
        foreach (var (cell, index, item) in statCellContainer.GetElements(stats))
        {
            var fakeLevel = item.Level - fakeStartLevel - 1;
            currentLevel += item.Level - 1;
            var fakeMaxLevel = achievements.GetClamped(idx1).resAchievement.TargetProgress;
            cell.Refresh(item, fakeLevel, fakeMaxLevel);
            var isMaxLevel = fakeLevel >= fakeMaxLevel;
            cell.imgCell.overrideSprite = isMaxLevel ? spriteMaxLevelStatCell : null;
        }

        var minLevel = idx1 == -1 ? 0 : achievements.GetClamped(idx1).level;
        var maxLevel = achievements.GetClamped(idx2).level;
        sliderAbilityProgress.DOValue(currentLevel.MapRangeClamped(minLevel, maxLevel), 0.2f);
        txtAbilityProgress.text = currentLevel.ToString();

        if (idx1 == -1)
        {
            cell1.elementRoot.SetActive(false);
        }
        else
        {
            var achievement1 = achievements.GetClamped(idx1);
            cell1.elementRoot.SetActive(true);
            cell1.Refresh(MyPlayer.GetAchievementByDataID(achievement1.resAchievement.Id), achievement1.level);
        }
        
        if (idx2 == -1)
        {
            cell2.elementRoot.SetActive(false);
        }
        else
        {
            var achievement2 = achievements.GetClamped(idx2);
            cell2.elementRoot.SetActive(true);
            cell2.Refresh(MyPlayer.GetAchievementByDataID(achievement2.resAchievement.Id), achievement2.level);
        }
        
        var trainingRank = GlobalResourceItem.TrainingRankItem;
        var trainingRankItem = MyPlayer.GetItemByDataID(trainingRank.Id);
        txtTrainingRank.text = trainingRank.GetLocalizedString($"UnitTrainingRank_{trainingRankItem.Level}");
        
    }

    public void OnClickAttackCell()
    {
        statCellContainer.RefreshElements(0, (cell, i) =>
        {
            cell.btnCell.OnPointerClick(new PointerEventData(EventSystem.current)
            {
                button = PointerEventData.InputButton.Left
            });
        });
    }

    public void OnClickCell()
    {
        foreach (var statCell in statCellContainer.Elements)
        {
            var rt = (RectTransform)statCell.elementRoot.transform;
            if (rt.GetWorldBounds().IncludePoint2D(Input.mousePosition))
            {
                statCell.btnCell.OnPointerClick(new PointerEventData(EventSystem.current)
                {
                    button = PointerEventData.InputButton.Left
                });
            }
        }
    }

    public void OnClickAbilityPreview()
    {
        GameManager.Get().ShowPopup<Popup_Ability_Preview>();
    }

    public override async UniTask HandleEvent(GameEvent e)
    {
        await base.HandleEvent(e);
        
        if (!gameObject.activeInHierarchy)
            return;

        switch (e.type)
        {
            case GameEventType.MyPlayerItemLevelUp:
            {
                //var rand = Random.Range(0, 3);
                //var animString =  "Attack" + (rand == 0 ? "" : rand.ToString()); 
                var animString =  "Win";
                unitUIRenderer.SetAnimation(animString, false, afterAnimationName: "Walk");
                psUnitLevelUp.Stop(true, ParticleSystemStopBehavior.StopEmittingAndClear);
                psUnitLevelUp.Play();
                
                Refresh();
                break;
            }
            case GameEventType.MyPlayerAchievementUpdated:
            {
                Refresh();
                break;
            }
        }
    }
}
