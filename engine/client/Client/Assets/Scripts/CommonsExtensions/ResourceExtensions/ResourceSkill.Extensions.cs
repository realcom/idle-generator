using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Types.Geometry;
using UnityEngine;

namespace Commons.Resources
{
    public partial class ResourceSkill
    {
        public override int GetId() => id_;
        public override ResourceString.Types.Category StringCategory => ResourceString.Types.Category.Skill;
        public override bool CanDisplay => IsValid && !ContainsTag(Tag.HideDisplay);
        
        public override bool HasRelevanceNotice()
        {
            return false;
        }

        public LazyLoad<GameObject> ClientPrefab { get; private set; }
        public LazyLoad<Sprite> ClientSprite { get; private set; }
        public float ClientAttackSquaredDistance { get; private set; }
        
        public HashSet<int> RelatedUseSkillIds { get; private set; }

        partial void InitUnity()
        {
            InitEntity(ResourceString.Types.Category.Skill, Id);
            
            ClientPrefab = new LazyLoad<GameObject>(Prefab);
            
            ClientSprite = new LazyLoad<Sprite>(Sprite);
            
            RelatedUseSkillIds = new ();
            var skillBoundingBox = BoundingBox.Empty;
            foreach (var timeline in Timelines)
            {
                if (timeline.ActionCase == Types.Timeline.ActionOneofCase.Hit)
                {
                    var hit = timeline.Hit;
                    skillBoundingBox = BoundingBox.Merge(hit.IGeometries.Select(g => g.GetBoundingBox()));
                }
                if (timeline.ActionCase == Types.Timeline.ActionOneofCase.AddSkill)
                {
                    var addSkill = timeline.AddSkill;
                    RelatedUseSkillIds.Add(addSkill.UseSkill.SkillDataId);
                }
                if (timeline.ActionCase == Types.Timeline.ActionOneofCase.UnitUseSkill)
                {
                    var unitUseSkill = timeline.UnitUseSkill;
                    RelatedUseSkillIds.Add(unitUseSkill.UseSkill.SkillDataId);
                }
            }
            if (ConsecutiveUseSkill != null && ConsecutiveUseSkill.SkillDataId != 0)
                RelatedUseSkillIds.Add(ConsecutiveUseSkill.SkillDataId);
            
            var attackDistance = (float)skillBoundingBox.Max.x; // would be shorter if the direction is not diagonal 
            ClientAttackSquaredDistance = attackDistance * attackDistance;
        }
    }
}
