using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Resources;
using Commons.Types.Geometry;
using Commons.Types.Units;
using Sirenix.OdinInspector;
using Sirenix.Serialization;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Serialization;
using Object = UnityEngine.Object;

#if UNITY_EDITOR
using Commons.Game;
using UnityEditor.Timeline;
#endif

[Serializable]
public class AttackBehaviour : ZSkillPlayableBehaviour
{
    [TitleGroup("타격 설정")]
    [NonSerialized, SerializeReference, OdinSerialize]
    [LabelText("타격 범위")]
    public List<IGeometry> geometries = new();
    
    [TitleGroup("타격 설정")]
    [Tooltip("같은 팀 타격 가능 여부")]
    public bool hitAlly;
    [TitleGroup("타격 설정")]
    [Tooltip("Sender 무시 여부")]
    public bool ignoreSender;
    [TitleGroup("타격 설정")]
    [Tooltip("타격 한 틱 당 최대 히트 수, 0 이면 무제한")]
    public int maxHitPerTick = 0;
    [TitleGroup("타격 설정")]
    [Tooltip("타격 간격 (틱 단위), 0 이면 1회만 타격")]
    [LabelText("Hit Interval (틱)")]
    public uint hitInterval = 0;
#if UNITY_EDITOR
    [TitleGroup("타격 설정")]
    [ReadOnly]
    [ShowInInspector]
    [LabelText("타격 클립 시간 (틱)")]
    public uint hitDurationInTick => TimelineEditor.selectedClip != null ? (uint)(TimelineEditor.selectedClip.duration /  GameBoard.TickDuration) : 0;
    [TitleGroup("타격 설정")]
    [ReadOnly]
    [ShowInInspector]
    [LabelText("발생 타격 횟수")]
    [Tooltip("타격 횟수 계산 시 클립 첫 틱 포함, 마지막 틱 미포함 주의")]
    public uint hitCount => hitInterval == 0 ? 1 : (uint)((float)(hitDurationInTick - 1) / hitInterval) + 1;
    [TitleGroup("타격 설정")]
    [ReadOnly]
    [ShowInInspector]
    [LabelText("풀히트 시 1렙/1몹 기준 총 대미지")]
    [PropertySpace(SpaceBefore = 0, SpaceAfter = 10)]
    public long hitDamageTotal => damages.Count == 0 ? 0 : hitCount * damages[0];
#endif
    
    [TitleGroup("타격 넉백 설정")]
    [Tooltip("넉백 지속 시간 (시간)")]
    [LabelText("Knockback Duration (시간)")]
    public float knockbackDuration = 0;
    [TitleGroup("타격 넉백 설정")]
    [PropertySpace(SpaceBefore = 0, SpaceAfter = 10)]
    [Tooltip("넉백 거리")]
    public float knockbackDistance = 0;
    [TitleGroup("타격 넉백 설정")]
    public OnHitFxSettings onKnockbackFxSettings;
    
    [TitleGroup("경직 설정 (임시)")] 
    public float disableMoveDuration;
    [TitleGroup("경직 설정 (임시)")]
    [PropertySpace(SpaceBefore = 0, SpaceAfter = 10)]
    public float disableActionDuration;
    
    [Serializable]
    public struct UseSkillSettings
    {
        public int skillID;
        public bool atTarget;
        public Vector2 position;
        public float angle;
        
        public UseSkill ToUseSkill()
        {
            return new UseSkill
            {
                SkillDataId = skillID,
                AtTarget = atTarget,
                Position = (Vector2Message)position,
                Rotation = angle
            };
        }
    }
    
    [TitleGroup("온힛 UseSkill 설정")] 
    public bool useOnHitSkill;
    [TitleGroup("온힛 UseSkill 설정"), ShowIf(nameof(useOnHitSkill))] 
    [PropertySpace(SpaceBefore = 0, SpaceAfter = 10)]
    public UseSkillSettings onHitSkill;
    
    [Serializable]
    public struct AddBuffSettings
    {
        public int buffDataId;
        public int duration;
    }
    [TitleGroup("온힛 AddBuff 설정")]
    [PropertySpace(SpaceBefore = 0, SpaceAfter = 25)]
    public List<AddBuffSettings> onHitAddBuffs = new();
    
    // 대미지 설정 탭
    [Title("대미지 Value 설정")]
    [TabGroup("대미지 설정")]
    [Tooltip("레벨 1부터 최대 레벨까지의 데미지, 0번째가 레벨 1")]
    public List<long> damages = new();
    [TabGroup("대미지 설정")]
    public DamageKey damage;
    
    [Title("온대미지 UseSkill 설정"), PropertySpace(SpaceBefore = 10, SpaceAfter = 0)]
    [TabGroup("대미지 설정")]
    public bool useOnDamageSkill;
    [TabGroup("대미지 설정"), ShowIf(nameof(useOnDamageSkill))] 
    public UseSkillSettings onDamageSkill;
    
    [Title("온대미지 히트 FX 세팅"), PropertySpace(SpaceBefore = 10, SpaceAfter = 0)]
    [FormerlySerializedAs("onHitFxSettings")] 
    [TabGroup("대미지 설정")]
    public OnHitFxSettings onDamageFxSettings;
    
    // 힐 설정 탭
    [Title("힐 Value 설정")]
    [TabGroup("힐 설정")]
    public List<long> heals = new();
    [TabGroup("힐 설정")]
    public HealKey heal;
    
    [Title("온힐 UseSkill 설정"), PropertySpace(SpaceBefore = 10, SpaceAfter = 0)]
    [TabGroup("힐 설정")] 
    public bool useOnHealSkill;
    [TabGroup("힐 설정"), ShowIf(nameof(useOnHealSkill))] 
    public UseSkillSettings onHealSkill;
    
    [Title("온힐 히트 FX 세팅"), PropertySpace(SpaceBefore = 10, SpaceAfter = 0)]
    [TabGroup("힐 설정")]
    public OnHitFxSettings onHealFxSettings;    
    
    
    // 힐 설정 탭
    [Title("Sender 힐 Value 설정")]
    [TabGroup("Sender 힐 설정")]
    public List<long> senderHeals = new();
    [TabGroup("Sender 힐 설정")]
    public SenderAddHealKey senderHeal;
    
    [Title("온 Sender 힐 UseSkill 설정"), PropertySpace(SpaceBefore = 10, SpaceAfter = 0)]
    [TabGroup("Sender 힐 설정")] 
    public bool useOnSenderHealSkill;
    [TabGroup("Sender 힐 설정"), ShowIf(nameof(useOnSenderHealSkill))] 
    public UseSkillSettings onSenderHealSkill;
    
    [Title("온힐 히트 FX 세팅"), PropertySpace(SpaceBefore = 10, SpaceAfter = 0)]
    [TabGroup("Sender 힐 설정")]
    public OnHitFxSettings onSenderHealFxSettings;
    
}
