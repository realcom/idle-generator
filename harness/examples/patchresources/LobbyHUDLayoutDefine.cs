using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Resources.Interfaces;
using Commons.Types.Players;
using Commons.Utility.Protobuf;
using Cysharp.Threading.Tasks;
using Google.Protobuf.WellKnownTypes;
using Sirenix.OdinInspector;
using Sirenix.Serialization;
using UniLabs.Time;
using UnityEngine;

[CreateAssetMenu(fileName = "LobbyHUDLayoutDefine", menuName = "LobbyHUDLayoutDefine")]
public class LobbyHUDLayoutDefine : ClientScriptableSingleton<LobbyHUDLayoutDefine>
{
    [Serializable]
    public class LobbyHUDContentsDefine : ITimeValidityResource
    {
        [Serializable]
        public struct AchievementCondition
        {
            [LabelWidth(120f)] public int achievementDataId;
            [LabelWidth(120f)] public PlayerAchievementMessage.Types.State state;

            [ShowIf("@state == PlayerAchievementMessage.Types.State.InProgress"), LabelWidth(120f)]
            public int targetProgress;
        }

        [Serializable]
        public struct ItemCondition
        {
            [LabelWidth(120f)] public int itemDateId;
            [LabelWidth(120f)] public bool checkCount;
            [ShowIf("checkCount"), LabelWidth(120f)]
            public int count;
            [LabelWidth(120f)] public bool checkUntilAt;
            
            public bool IsValid()
            {
                var item = MyPlayer.GetItemByDataID(itemDateId, checkCount, checkDeprecated: true, checkTimeValid: checkUntilAt);
                if (item == null)
                    return false;

                if (checkCount && item.Count < count)
                    return false;

                return true;
            }
        }
        
        public enum LogicalOperator
        {
            OR,
            AND,
        }

        [SerializeField, FoldoutGroup("유효 조건 설정"), TabGroup("유효 조건 설정/Tab", "유효 업적")]
        private LogicalOperator _validAchievementConditionsOperator = LogicalOperator.AND;
        [SerializeField, FoldoutGroup("유효 조건 설정"), TabGroup("유효 조건 설정/Tab", "유효 업적"), TableList(AlwaysExpanded = true)]
        private List<AchievementCondition> _validAchievementConditions = new();
        
        [SerializeField, FoldoutGroup("유효 조건 설정"), TabGroup("유효 조건 설정/Tab", "무효 업적")]
        private LogicalOperator _invalidAchievementConditionsOperator = LogicalOperator.OR;
        [SerializeField, FoldoutGroup("유효 조건 설정"), TabGroup("유효 조건 설정/Tab", "무효 업적")]
        private List<AchievementCondition> _invalidAchievementConditions = new();
        
        [SerializeField, FoldoutGroup("유효 조건 설정"), TabGroup("유효 조건 설정/Tab", "유효 아이템")]
        private LogicalOperator _itemConditionsOperator = LogicalOperator.AND;
        [SerializeField, FoldoutGroup("유효 조건 설정"), TabGroup("유효 조건 설정/Tab", "유효 아이템")]
        private List<ItemCondition> _itemConditions = new();
        
        [SerializeField, FoldoutGroup("유효 조건 설정"), TabGroup("유효 조건 설정/DateTime", "시작 시간"), InlineProperty]
        private UDateTime _startAt = DateTime.MinValue;
        [SerializeField, FoldoutGroup("유효 조건 설정"), TabGroup("유효 조건 설정/DateTime", "종료 시간"), InlineProperty]
        private UDateTime _untilAt = DateTime.MaxValue;
        
        private Timestamp startAt_;
        private Timestamp untilAt_;

        public Timestamp StartAt => startAt_;
        public Timestamp UntilAt => untilAt_;

        public virtual void OnLoaded()
        {
            if (_startAt != DateTime.MinValue)
                startAt_ = Timestamp.FromDateTime(_startAt.DateTime.ToUniversalTime());
            if (_untilAt != DateTime.MaxValue)
                untilAt_ = Timestamp.FromDateTime(_untilAt.DateTime.ToUniversalTime());
        }

        public bool IsValidNow(bool checkStartAt = true, bool checkUntilAt = true)
        {
            var now = TimeSystem.time;
            if (checkStartAt && StartAt != null && StartAt.ToSeconds() > now)
                return false;
            if (checkUntilAt && UntilAt != null && UntilAt.ToSeconds() <= now)
                return false;

            return true;
        }

        public virtual bool IsValid()
        {
            if (!IsValidNow())
                return false;

            //유효 처리 업적 체크
            switch (_validAchievementConditionsOperator)
            {
                case LogicalOperator.OR:
                    if (_validAchievementConditions.All(x =>
                        {
                            var achievement = MyPlayer.GetAchievementByDataID(x.achievementDataId);
                            if (x.state == PlayerAchievementMessage.Types.State.InProgress)
                                return achievement.State != PlayerAchievementMessage.Types.State.InProgress || achievement.Progress != x.targetProgress;

                            return achievement.State < x.state;
                        }))
                    {
                        return false;
                    }
                    break;
                case LogicalOperator.AND:
                    if (_validAchievementConditions.Any(x =>
                        {
                            var achievement = MyPlayer.GetAchievementByDataID(x.achievementDataId);
                            if (x.state == PlayerAchievementMessage.Types.State.InProgress)
                                return achievement.State != PlayerAchievementMessage.Types.State.InProgress || achievement.Progress != x.targetProgress;

                            return achievement.State < x.state;
                        }))
                    {
                        return false;
                    }
                    break;
            }

            //무효 처리 업적 체크
            switch (_invalidAchievementConditionsOperator)
            {
                case LogicalOperator.OR:
                    if (_invalidAchievementConditions.Any(x =>
                        {
                            var achievement = MyPlayer.GetAchievementByDataID(x.achievementDataId);
                            if (x.state == PlayerAchievementMessage.Types.State.InProgress)
                                return achievement.State == PlayerAchievementMessage.Types.State.InProgress && 
                                       achievement.Progress == x.targetProgress;

                            return achievement.State >= x.state;
                        }))
                    {
                        return false;
                    }
                    break;
                case LogicalOperator.AND:
                    if (_invalidAchievementConditions.All(x =>
                        {
                            var achievement = MyPlayer.GetAchievementByDataID(x.achievementDataId);
                            if (x.state == PlayerAchievementMessage.Types.State.InProgress)
                                return achievement.State == PlayerAchievementMessage.Types.State.InProgress && 
                                       achievement.Progress == x.targetProgress;

                            return achievement.State >= x.state;
                        }))
                    {
                        return false;
                    }
                    break;
            }

            switch (_itemConditionsOperator)
            {
                case LogicalOperator.OR:
                    if (_itemConditions.All(x => !x.IsValid()))
                        return false;
                    break;
                case LogicalOperator.AND:
                    if (_itemConditions.Any(x => !x.IsValid()))
                        return false;
                    break;
            }

            return true;
        }
    }
    
    [Serializable]
    public class LobbyHUDContentsAutoLandingDefine : LobbyHUDContentsDefine
    {
        [SerializeField] private ZModeManagerLobby.BottomButtonType _validBottomTab = ZModeManagerLobby.BottomButtonType.LOBBY;
        
        [SerializeField] private string _popupArgs;
        [SerializeField] private List<string> _postLandingPopupArgs = new();
        
        [SerializeField] private int _increaseAchievementDataId;
        [SerializeField] private int _claimRewardAchievementDataId;

        public override bool IsValid()
        {
            if (!base.IsValid())
                return false;

            if (_validBottomTab != ZModeManagerLobby.BottomButtonType.NONE && ZModeManagerLobby.Get().currentType != _validBottomTab)
                return false;

            return true;
        }

        public async UniTask DoAutoLanding()
        {
            if (string.IsNullOrEmpty(_popupArgs))
                return;

            var popup = await GameManager.Get().ShowPopupAsync(_popupArgs);

            if (popup)
                popup.blockHide = true;

            var bWaitIncrease = true;
            if (_increaseAchievementDataId != 0)
            {
                var response = await ZWorldClient.Get().SendPacket<IncreaseAchievementRequest.Types.Response>(Packet.Pop(0, new IncreaseAchievementRequest()
                {
                    AchievementDataId = _increaseAchievementDataId
                }));

                if (response.Status.IsSuccess())
                    ZModeManagerLobby.EnqueueAcquiredItems(response.Items);
            }

            bWaitIncrease = false;
            
            var bWaitClaim = true;
            if (_claimRewardAchievementDataId != 0)
            {
                var response = await ZWorldClient.Get().SendPacket<ClaimAchievementRewardRequest.Types.Response>(Packet.Pop(0, new IncreaseAchievementRequest()
                {
                    AchievementDataId = _claimRewardAchievementDataId
                }));

                if (response.Status.IsSuccess())
                    ZModeManagerLobby.EnqueueAcquiredItems(response.Items);
            }

            bWaitClaim = false;

            await UniTask.WaitWhile(() => bWaitIncrease || bWaitClaim);

            if (popup)
                popup.blockHide = false;

            if (popup)
                await UniTask.WaitUntilCanceled(popup.GetCancellationTokenOnDestroy());

        }
        
        public bool TryPostAutoLanding()
        {
            var landingCount = 0;
            foreach (var args in _postLandingPopupArgs)
            {
                if (string.IsNullOrEmpty(args))
                    continue;

                GameManager.Get().ShowPopupAsync(args).Forget();
                landingCount++;
            }

            return landingCount > 0;
        }
        
    }

    [TabGroup("Tab", "팝업 자동 노출")]
    public List<LobbyHUDContentsAutoLandingDefine> contentsAutoLandings = new();

    [Serializable]
    public class LobbyHUDButtonDefine : LobbyHUDContentsDefine
    {
        [Serializable]
        public class UntilAtGetter
        {
            [SerializeField] private List<int> _itemDataIds = new();
            [SerializeField] private List<int> _achievementDataIds = new();
            [SerializeField] private UDateTime _untilAt = DateTime.MaxValue;

            public Timestamp GetUntilAt()
            {
                Timestamp foundUntilAt = null;
                foreach (var itemDataId in _itemDataIds)
                {
                    var item = MyPlayer.GetItemByDataID(itemDataId, checkCount: true, checkDeprecated: true, checkTimeValid: false);
                    if (item == null)
                        continue;

                    foundUntilAt = TimestampExtensions.Min(foundUntilAt, item.UntilAt);
                }
                
                foreach (var achievementDataId in _achievementDataIds)
                {
                    var resAchievement = ResourceAchievement.Get(achievementDataId);
                    if (resAchievement == null)
                        continue;

                    foundUntilAt = TimestampExtensions.Min(foundUntilAt, resAchievement.UntilAt);
                }

                if (_untilAt != DateTime.MaxValue)
                    foundUntilAt = TimestampExtensions.Min(foundUntilAt, Timestamp.FromDateTime(_untilAt.DateTime.ToUniversalTime()));

                return foundUntilAt;
            }
        }
        
        [SerializeField, FoldoutGroup("버튼 유효 기간 설정 (표기 포함)")] private UntilAtGetter _untilAtGetter = new();
        
        [SerializeField] private string _iconPath;
        [SerializeField] private string _nameKey;
        [SerializeField] private List<string> _popupArgsList = new()
        {
            string.Empty,
        };
        
        [InlineProperty] public NoticeEntities noticeEntities = new();
        
        private LazyLoad<Sprite> _icon;
        public Sprite Icon => _icon?.Get();

        public string Name { get; private set; }
        
        public Timestamp DisplayUntilAt => _untilAtGetter?.GetUntilAt();

        public void ShowPopup()
        {
            foreach (var args in _popupArgsList)
            {
                if (string.IsNullOrEmpty(args))
                    continue;

                GameManager.Get().ShowPopupAsync(args).Forget();
            }
        }
        
        public override void OnLoaded()
        {
            base.OnLoaded();

            _icon = new LazyLoad<Sprite>(_iconPath);

            if (!string.IsNullOrEmpty(_nameKey))
                Name = _nameKey.L();
        }

        public override bool IsValid()
        {
            if (_popupArgsList.All(string.IsNullOrEmpty))
                return false;
            
            if (!base.IsValid())
                return false;
            
            var untilAt = _untilAtGetter.GetUntilAt();
            if (untilAt != null && untilAt.ToSeconds() <= TimeSystem.time)
                return false;

            return true;
        }
        
    }

    [TabGroup("Tab", "HUD 버튼 설정", TabLayouting = TabLayouting.MultiRow)]
    public List<LobbyHUDButtonDefine> specialLimitedButtonDefs = new();
    [TabGroup("Tab", "HUD 버튼 설정")]
    public LobbyHUDButtonDefine chapterRewardButtonDef = new();
    [TabGroup("Tab", "HUD 버튼 설정")]
    public LobbyHUDButtonDefine scoutButtonDef = new();
    [TabGroup("Tab", "HUD 버튼 설정")]
    public LobbyHUDButtonDefine conquerButtonDef = new();
    [HorizontalGroup("Tab/HUD 버튼 설정/Grid")]
    public List<LobbyHUDButtonDefine> leftGridButtons = new();
    [HorizontalGroup("Tab/HUD 버튼 설정/Grid")]
    public List<LobbyHUDButtonDefine> rightGridButtons = new();
    
    protected override void OnLoaded()
    {
        foreach (var notice in contentsAutoLandings)
        {
            notice.OnLoaded();
        }
        
        foreach (var button in specialLimitedButtonDefs)
        {
            button.OnLoaded();
        }
        
        foreach (var button in leftGridButtons)
        {
            button.OnLoaded();
        }
        
        foreach (var button in rightGridButtons)
        {
            button.OnLoaded();
        }
        
        chapterRewardButtonDef.OnLoaded();
        scoutButtonDef.OnLoaded();
        conquerButtonDef.OnLoaded();
    }
}
