using System;
using System.Collections.Generic;
using Commons.Game.Interfaces;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Units;
using Commons.Types.Units.ArmorTypeStat;
using Commons.Types.Units.BuffGroupStat;
using Commons.Types.Units.DamageTypeStat;
using Commons.Types.Units.ItemGroupStat;
using Commons.Types.Units.SkillGroupStat;
using Commons.Types.Units.SlotStat;
using Commons.Utility;

namespace Commons.Game
{
    public partial class GameUnit
    {
        private bool _statDirty;
        public readonly UnitStat Stat = new();
        //todo: don't call collection's Clear() method, reduce GC pressure
        public readonly Dictionary<ArmorType, ArmorTypeStat> ArmorTypeStats = new();
        public readonly Dictionary<DamageType, DamageTypeStat> DamageTypeStats = new();
        public readonly Dictionary<int, ItemGroupStat> ItemGroupStats = new();
        public readonly Dictionary<Slot, SlotStat> SlotStats = new();
        public readonly Dictionary<int, BuffGroupStat> BuffGroupStats = new();
        public readonly Dictionary<int, SkillGroupStat> SkillGroupStats = new();

        public long MaxHp { private set; get; }
        public long HpRegenPerSecond { private set; get; }
        public long MaxMp { private set; get; }
        public long MpRegenPerSecond { private set; get; }
        public long MaxSp { private set; get; }
        public uint SpRegenPeriod { private set; get; }
        public FixedFloat GuardRatio { private set; get; }

        public FixedFloat MoveSpeed { private set; get; }
        public FixedFloat MoveSpeedPerTick { private set; get; }
        public FixedFloat SqrMoveSpeedPerTick { private set; get; }
        
        public FixedFloat AttackSpeed { private set; get; }
        public FixedFloat Weight { private set; get; }
        
        public FixedFloat Attack { private set; get; }
        public FixedFloat Defense { private set; get; }
        public FixedFloat MagicResist { private set; get; }
        
        public FixedFloat SellPriceRatio { private set; get; }
        
        public FixedFloat Scale { private set; get; }
        public FixedFloat SkillScale { private set; get; }
        
        public readonly Dictionary<DamageType, FixedFloat> DamageTypeDamageRatio = new();
        public readonly Dictionary<ArmorType, FixedFloat> ArmorTypeDamageRatio = new();
        public readonly Dictionary<DamageType, FixedFloat> DamageTypeGotDamageRatio = new();
        
        internal void SetHp(long hp, IAttackSource? attackSource = null)
        {
            Hp = Math.Clamp(hp, 0L, MaxHp);
            if (Hp == 0L)
                HandleDead(attackSource);
        }
        
        internal void AddHp(long hp, IAttackSource? attackSource = null)
        {
            Hp = Math.Clamp(LongFixedFloatMath.AddSaturated(Hp, hp), 0L, MaxHp);
            if (Hp == 0L)
                HandleDead(attackSource);
        }
        
        internal void SetMp(long mp)
        {
            Mp = Math.Clamp(mp, 0L, MaxMp);
        }
        
        internal void AddMp(long mp)
        {
            Mp = Math.Clamp(LongFixedFloatMath.AddSaturated(Mp, mp), 0L, MaxMp);
        }

        internal void SetShield(long shield)
        {
            shield_ = shield;
        }
        
        internal void AddShield(long shield)
        {
            shield_ = LongFixedFloatMath.AddSaturated(shield_, shield);
        }
        
        internal void SetGuard(long guard)
        {
            guard_ = guard;
        }
        
        internal void AddGuard(long guard)
        {
            guard_ = LongFixedFloatMath.AddSaturated(guard_, guard);
        }
        
        internal void SetSp(long sp)
        {
            if (MaxSp == 0L)
                return;

            sp_ = Math.Clamp(sp, 0L, MaxSp);
            if (sp_ == 0L)
                HandleExhaustion();
            else
                state_ &= ~StateFlag.Exhaustion;
        }
        
        internal void AddSp(long sp)
        {
            if (MaxSp == 0L)
                return;
            
            sp_ = Math.Clamp(LongFixedFloatMath.AddSaturated(sp_, sp), 0L, MaxSp);
            if (sp_ == 0L)
                HandleExhaustion();
            else
                state_ &= ~StateFlag.Exhaustion;
        }

        private void RegenStat()
        {
            RegenHpMp();
            RegenSp();
        }
        
        private void RegenHpMp()
        {
            if (tick_ % GameBoard.TicksPerSecond != 0)
                return;
            
            if (!HasBuffByTag(Tag.DisableHpRegen))
                AddHp(HpRegenPerSecond);
            if (!HasBuffByTag(Tag.DisableMpRegen))
                AddMp(MpRegenPerSecond);
        }

        private void RegenSp()
        {
            if (MaxSp == 0 || SpRegenPeriod == 0u)
                return;
            if (sp_ == MaxSp || HasBuffByTag(Tag.DisableSpRegen))
            {
                spRegenTick_ = 0;
                return;
            }
            
            if (spRegenTick_ == 0)
            {
                spRegenTick_ = tick_ + SpRegenPeriod;
                return;
            }
            if (spRegenTick_ != tick_)
                return;
            
            AddSp(1L);
            spRegenTick_ = tick_ + SpRegenPeriod;
        }

        public void SetStatDirty()
        {
            _statDirty = true;
        }

        private void RecalculateStat(bool applyMaxHpMpChange = true)
        {
            RecalculateUnitStat(applyMaxHpMpChange);
            RecalculateArmorTypeStat();
            RecalculateDamageTypeStat();
            RecalculateItemGroupStat();
            RecalculateSlotStat();
            RecalculateBuffGroupStat();
            RecalculateSkillGroupStat();
        }

        private void RecalculateUnitStat(bool applyMaxHpMpChange = true)
        {
            RebuildUnitStatFromSources();
            CacheMaxResourceStats(applyMaxHpMpChange);
            CacheResourceRegenStats();
            CacheCombatStats();
            CacheMovementStats();
            CacheEconomyStats();
            CacheScaleStats();
        }

        private void RebuildUnitStatFromSources()
        {
            if (baseStat_.Count == (int)UnitStatType.Count)
                Stat.Clear(baseStat_);
            else
                Stat.Clear();

            if (playerAvatar_ != null)
                playerAvatar_.ApplyAvatarStats(Stat);
            else
                ResUnit.AddStats.Apply(Stat, level_);

            foreach (var buff in buffs_.Values)
            {
                if (!buff.Enabled)
                    continue;
                
                buff.ResBuff.AddStats.Apply(Stat, buff.Level);
            }
        }

        private void CacheMaxResourceStats(bool applyMaxHpMpChange)
        {
            var prevMaxHp = MaxHp;
            MaxHp = LongFixedFloatMath.ToLongSaturated(Stat.MaxHp);
            if (applyMaxHpMpChange)
                Hp = ApplyMaxResourceChange(Hp, prevMaxHp, MaxHp);

            var prevMaxMp = MaxMp;
            MaxMp = LongFixedFloatMath.ToLongSaturated(Stat.MaxMp);
            if (applyMaxHpMpChange)
                Mp = ApplyMaxResourceChange(Mp, prevMaxMp, MaxMp);

            MaxSp = LongFixedFloatMath.ToLongSaturated(Stat.MaxSp);
        }

        private static long ApplyMaxResourceChange(long current, long previousMax, long nextMax)
        {
            if (current >= nextMax)
                return nextMax;
            if (nextMax > previousMax)
                return Math.Clamp(
                    LongFixedFloatMath.AddSaturated(current, LongFixedFloatMath.SubtractSaturated(nextMax, previousMax)),
                    0L,
                    nextMax);
            return Math.Clamp(current, 0L, nextMax);
        }

        private void CacheResourceRegenStats()
        {
            HpRegenPerSecond = LongFixedFloatMath.ToLongSaturated(Stat.HpRegenPerSecond);
            MpRegenPerSecond = LongFixedFloatMath.ToLongSaturated(Stat.MpRegenPerSecond);

            var spRegen = Stat.SpRegenPerSecond;
            SpRegenPeriod = spRegen <= FixedFloat.Zero ? 0u : (uint)(GameBoard.FixedFloatTicksPerSecond / spRegen);
        }

        private void CacheCombatStats()
        {
            GuardRatio = Stat.GuardRatio;

            AttackSpeed = Stat.AttackSpeed;
            Weight = Stat.Weight;
            if (Weight <= FixedFloat.Zero)
                Weight = FixedFloat.One;

            Attack = Stat.Attack;

            Defense = Stat.Defense;
            MagicResist = Stat.MagicResist;
        }

        private void CacheMovementStats()
        {
            MoveSpeed = Stat.MoveSpeed;
            MoveSpeedPerTick = MoveSpeed * GameBoard.FixedFloatTickDuration;
            SqrMoveSpeedPerTick = MoveSpeedPerTick * MoveSpeedPerTick;
        }

        private void CacheEconomyStats()
        {
            SellPriceRatio = Stat.SellPriceRatio;
        }

        private void CacheScaleStats()
        {
            Scale = Stat.Scale;
            
            if (ResUnit.ContainsTag(Tag.ScaleRemappingPossible))
            {
                var remappedScalePercent = Stat.GameplayHpPercent;
                if (remappedScalePercent < FixedFloat.Zero)
                {
                    remappedScalePercent = FixedFloatMath.MapRangeClamped(
                        remappedScalePercent,
                        FixedFloatMath.Min(ResourceUnit.Global.Value.SizeClampMinHpPercent, FixedFloat.Zero),
                        FixedFloat.Zero,
                        FixedFloatMath.Min(ResourceUnit.Global.Value.MinClampedSizePercent, FixedFloat.Zero),
                        FixedFloat.Zero
                    );
                }
                else if (remappedScalePercent > FixedFloat.Zero)
                {
                    remappedScalePercent = FixedFloatMath.MapRangeClamped(
                        remappedScalePercent,
                        FixedFloat.Zero,
                        FixedFloatMath.Max(ResourceUnit.Global.Value.SizeClampMaxHpPercent, FixedFloat.Zero),
                        FixedFloat.Zero,
                        FixedFloatMath.Max(ResourceUnit.Global.Value.MaxClampedSizePercent, FixedFloat.Zero)
                    );
                }
                
                Scale = FixedFloatMath.MultiplySaturated(Scale, FixedFloatMath.RatioFromPercentSaturated(remappedScalePercent));   
            }
            
            SkillScale = Stat.SkillScale;
        }
        
        private void RecalculateArmorTypeStat()
        {
            ArmorTypeStats.Clear();
            
            ResUnit.AddArmorTypeStats.Apply(ArmorTypeStats, level_);
            
            if (playerAvatar_ != null)
            {
                playerAvatar_.Character?.ApplyEquipAddStats(ArmorTypeStats);
                foreach (var weapon in playerAvatar_.Weapons)
                    weapon?.ApplyEquipAddStats(ArmorTypeStats);
                foreach (var equipment in playerAvatar_.Equipments)
                    equipment?.ApplyEquipAddStats(ArmorTypeStats);
                foreach (var pet in playerAvatar_.Pets)
                    pet?.ApplyEquipAddStats(ArmorTypeStats);
            }

            foreach (var buff in buffs_.Values)
            {
                if (!buff.Enabled)
                    continue;
                
                buff.ResBuff.AddArmorTypeStats.Apply(ArmorTypeStats, buff.Level);
            }
            
            ArmorTypeDamageRatio.Clear();
            foreach (var (armorType, armorTypeStat) in ArmorTypeStats)
            {
                ArmorTypeDamageRatio[armorType] = FixedFloatMath.RatioFromPercentSaturated(armorTypeStat[ArmorTypeStatType.DamagePercent]);
            }
        }
        
        private void RecalculateDamageTypeStat()
        {
            DamageTypeStats.Clear();
            
            ResUnit.AddDamageTypeStats.Apply(DamageTypeStats, level_);
            
            if (playerAvatar_ != null)
            {
                playerAvatar_.Character?.ApplyEquipAddStats(DamageTypeStats);
                foreach (var weapon in playerAvatar_.Weapons)
                    weapon?.ApplyEquipAddStats(DamageTypeStats);
                foreach (var equipment in playerAvatar_.Equipments)
                    equipment?.ApplyEquipAddStats(DamageTypeStats);
                foreach (var pet in playerAvatar_.Pets)
                    pet?.ApplyEquipAddStats(DamageTypeStats);
            }

            foreach (var buff in buffs_.Values)
            {
                if (!buff.Enabled)
                    continue;
                
                buff.ResBuff.AddDamageTypeStats.Apply(DamageTypeStats, buff.Level);
            }
            
            DamageTypeDamageRatio.Clear();
            DamageTypeGotDamageRatio.Clear();
            foreach (var (damageType, damageTypeStat) in DamageTypeStats)
            {
                DamageTypeDamageRatio[damageType] = FixedFloatMath.RatioFromPercentSaturated(damageTypeStat[DamageTypeStatType.DamagePercent]);
                DamageTypeGotDamageRatio[damageType] = FixedFloatMath.RatioFromPercentSaturated(damageTypeStat[DamageTypeStatType.GotDamagePercent]);
            }
        }
        
        private void RecalculateItemGroupStat()
        {
            ItemGroupStats.Clear();
            
            ResUnit.AddItemGroupStats.Apply(ItemGroupStats, level_);
            
            if (playerAvatar_ != null)
            {
                playerAvatar_.Character?.ApplyEquipAddStats(ItemGroupStats);
                foreach (var weapon in playerAvatar_.Weapons)
                    weapon?.ApplyEquipAddStats(ItemGroupStats);
                foreach (var equipment in playerAvatar_.Equipments)
                    equipment?.ApplyEquipAddStats(ItemGroupStats);
                foreach (var pet in playerAvatar_.Pets)
                    pet?.ApplyEquipAddStats(ItemGroupStats);
            }

            foreach (var buff in buffs_.Values)
            {
                if (!buff.Enabled)
                    continue;
                
                buff.ResBuff.AddItemGroupStats.Apply(ItemGroupStats, buff.Level);
            }
            
        }

        private void RecalculateSlotStat()
        {
            SlotStats.Clear();
            
            ResUnit.AddSlotStats.Apply(SlotStats, level_);

            if (playerAvatar_ != null)
            {
                playerAvatar_.Character?.ApplyEquipAddStats(SlotStats);
                // must not include weapons
                foreach (var weapon in playerAvatar_.Weapons)
                    weapon?.ApplyEquipAddStats(SlotStats);
                foreach (var equipment in playerAvatar_.Equipments)
                    equipment?.ApplyEquipAddStats(SlotStats);
                foreach (var pet in playerAvatar_.Pets)
                    pet?.ApplyEquipAddStats(SlotStats);
            }
            
            foreach (var buff in buffs_.Values)
            {
                if (!buff.Enabled)
                    continue;
                
                buff.ResBuff.AddSlotStats.Apply(SlotStats, buff.Level);
            }
            
        }
        
        private void RecalculateBuffGroupStat()
        {
            BuffGroupStats.Clear();
            
            ResUnit.AddBuffGroupStats.Apply(BuffGroupStats, level_);
            
            if (playerAvatar_ != null)
            {
                playerAvatar_.Character?.ApplyEquipAddStats(BuffGroupStats);
                foreach (var weapon in playerAvatar_.Weapons)
                    weapon?.ApplyEquipAddStats(BuffGroupStats);
                foreach (var equipment in playerAvatar_.Equipments)
                    equipment?.ApplyEquipAddStats(BuffGroupStats);
                foreach (var pet in playerAvatar_.Pets)
                    pet?.ApplyEquipAddStats(BuffGroupStats);
            }

            foreach (var buff in buffs_.Values)
            {
                if (!buff.Enabled)
                    continue;
                
                buff.ResBuff.AddBuffGroupStats.Apply(BuffGroupStats, buff.Level);
            }
        }

        private void RecalculateSkillGroupStat()
        {
            SkillGroupStats.Clear();
            
            ResUnit.AddSkillGroupStats.Apply(SkillGroupStats, level_);
            
            if (playerAvatar_ != null)
            {
                playerAvatar_.Character?.ApplyEquipAddStats(SkillGroupStats);
                foreach (var weapon in playerAvatar_.Weapons)
                    weapon?.ApplyEquipAddStats(SkillGroupStats);
                foreach (var equipment in playerAvatar_.Equipments)
                    equipment?.ApplyEquipAddStats(SkillGroupStats);
                foreach (var pet in playerAvatar_.Pets)
                    pet?.ApplyEquipAddStats(SkillGroupStats);
            }

            foreach (var buff in buffs_.Values)
            {
                if (!buff.Enabled)
                    continue;
                
                buff.ResBuff.AddSkillGroupStats.Apply(SkillGroupStats, buff.Level);
            }
        }

        private FixedFloat _queuedAddShieldBasePercent;
        internal void QueueAddShield(FixedFloat baseShieldPercent)
        {
            if (baseShieldPercent <= FixedFloat.Zero)
                return;
            
            _queuedAddShieldBasePercent = FixedFloatMath.AddSaturated(_queuedAddShieldBasePercent, baseShieldPercent);
            SetStatDirty();
        }

        private void ApplyAddShield()
        {
            if (_queuedAddShieldBasePercent <= FixedFloat.Zero)
                return;

            var shield = LongFixedFloatMath.ScaleSaturated(MaxHp, _queuedAddShieldBasePercent / 100);
            shield = LongFixedFloatMath.ScaleSaturated(shield, Stat.ShieldEfficiency);
            AddShield(Math.Max(0L, shield));
            _queuedAddShieldBasePercent = FixedFloat.Zero;
        }
        
    }
}
