using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using Commons.Types;
using Commons.Utility;
using UnityEngine;

namespace Commons.Resources
{
    public partial class ResourceMap
    {
        public override int GetId() => id_;
        public override ResourceString.Types.Category StringCategory => ResourceString.Types.Category.Map;
        public override bool CanDisplay => IsValid && !ContainsTag(Tag.HideDisplay);
        

        public override bool HasRelevanceNotice()
        {
            if (ContainsTag(Tag.Meta))
            {
                foreach (var map in GetAllByGroup(group_))
                {
                    if (map.ContainsTag(Tag.Meta))
                        continue;

                    if (map.HasRelevanceNotice())
                        return true;
                }

                return false;
            }

            //Check Enough Ticket
            if (entryMaterialItemGroups_.Count > 0)
            {
                if (MyPlayer.HasEnoughMaterial(entryMaterialItemGroups_.FirstOrDefault(), 1).hasEnoughMaterial)
                {
                    return true;
                }

                //Check Ticket Buyable
                var meta = Get(group_)!;
                if (meta.ProductBuyTicketItemDataId != 0)
                {
                    return ResourceItem.GetAllByParentId(meta.ProductBuyTicketItemDataId).Any(x => x.HasRelevanceNotice());
                }
            }
            
            return false;
        }

        public static ResourceMap Lobby { get; private set; }

        public LazyLoad<Sprite> ClientSprite { get; private set; }
        public bool IsMainMap { get; private set; }

        private Dictionary<string, LazyLoad<Sprite>> _clientSpriteGroups { get; } = new();

        private static readonly Dictionary<string, List<ResourceMap>>  _mapsByPopupArgKey = new();

        static partial void Reload()
        {
            PopupArgsContainer<ResourceMap>.Clear();
            _mapsByPopupArgKey.Clear();
        }

        partial void InitUnity()
        {
            if (Type == Types.Type.Lobby)
            {
                Lobby = this;
            }

            ClientSprite = new LazyLoad<Sprite>(Sprite);
            IsMainMap = Id == Group && ContainsTag(Tag.Main);

            InitEntity(ResourceString.Types.Category.Map, Id);
            
            foreach (var (key, path) in spriteGroups_)
            {
                _clientSpriteGroups[key] = new LazyLoad<Sprite>(path);
            }
            
            PopupArgsContainer<ResourceMap>.Register(this);
        }

        public Sprite GetSpriteByKey(string key, Sprite defaultSprite = null)
        {
            return _clientSpriteGroups.GetValueOrDefault(key) ?? defaultSprite;
        }

        protected override void InitEntity(ResourceString.Types.Category stringCategory, int id)
        {
            base.InitEntity(stringCategory, id);
        }

        private int maxWave = -1;
        public int MaxWave
        {
            get
            {
                if (maxWave == -1)
                    maxWave = GetWaveAchievements().Count();
                
                return maxWave;
            }
        }

        public IEnumerable<int> GetWaveAchievementIds()
        {
            foreach (var achievementDataId in ReferenceAchievementDataIds)
            {
                var resAch = ResourceAchievement.Get(achievementDataId);
                if (resAch != null && resAch.ContainsTag(Tag.Wave))
                    yield return achievementDataId;
            }   
        }

        public IEnumerable<ResourceAchievement> GetWaveAchievements()
        {
            foreach (var achievementDataId in ReferenceAchievementDataIds)
            {
                var resAch = ResourceAchievement.Get(achievementDataId);
                if (resAch != null && resAch.ContainsTag(Tag.Wave))
                    yield return resAch;
            }
        }

        public ResourceAchievement GetClearAchievement()
        {
            var id = ReferenceAchievementDataIds.FirstOrDefault(resAchId =>
                ResourceAchievement.Get(resAchId)?.Condition == ResourceAchievement.Types.Condition.WinGame);
            var resAch = ResourceAchievement.Get(id);
            return resAch;
        }
        
        public bool IsLockedByAchievement(out ResourceAchievement lockedAchievement)
        {
            lockedAchievement = null;

            foreach (var achievementDataId in ReferenceAchievementDataIds)
            {
                var achievement = ResourceAchievement.Get(achievementDataId);
                if (achievement == null)
                    continue;

                if (MyPlayer.GetAchievementByDataID(achievement.Id)?.IsAchievementCompletedOrRewarded() != true)
                {
                    lockedAchievement = achievement;
                    return true;
                }
            }

            return false;
        }

        public ResourceMap GetUnclearedMap()
        {
            if (ContainsTag(Tag.InfiniteWaves))
            {
                return GetAllByGroup(group_).First(x => !x.ContainsTag(Tag.Meta));
            }

            var unClearedMap = GetAllByGroup(group_)
                .FirstOrDefault(x =>
                    !x.ContainsTag(Tag.Meta) &&
                    !MyPlayer.IsAchievementCompletedOrRewarded(x.GetClearAchievement()));
            return unClearedMap ?? GetAllByGroup(group_).Last();
        }

        public ResourceMap GetLastStageMap()
        {
            if (ContainsTag(Tag.InfiniteWaves))
            {
                return GetAllByGroup(group_).First(x => !x.ContainsTag(Tag.Meta));
            }

            return GetAllByGroup(group_).Last();
        }
        public int GetProgressStep()
        {
            if (ContainsTag(Tag.InfiniteWaves))
            {
                var step = referenceAchievementDataIds_.FindIndex(x => !MyPlayer.IsAchievementCompletedOrRewarded(x)) + 1;
                if (step == 0)
                    step = referenceAchievementDataIds_.Count;

                return step;
            }

            return stage_;
        }

        public string GetMapProgressStepString()
        {
            return Get(group_)!.GetLocalizedString("ProgressStepFormat", "{0}").GetParsedString(GetProgressStep());
        }
        
    }
}