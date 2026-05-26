using Commons;
using Commons.Game;
using Commons.Packets;
using Commons.Packets.Updates;
using Commons.Types;
using Commons.Types.Units;
using Commons.Utility;

namespace WorldServer.WorldPlayer;

public partial class WorldPlayer
{
    private void UpdatePower()
    {
        if (!_dirtyPower)
            return;
        
        var prevPower = Power;
        RecalculatePower();
        _dirtyPower = false;

        if (prevPower != Power)
        {
            SendUpdate();
            if (Config.IsDebug)
                Logger.Info($"{this} sent Player Power Update. {prevPower} => {Power}");
        }
    }
    
    private bool _dirtyPower;
    public void MarkPowerDirty()
    {
        _dirtyPower = true;
    }
    
    private void RecalculatePower()
    {
        //PCE => Power Conversion Efficiency
        const float AttackToPCE = 1.0f;
        const float DefenseToPCE = 0.25f;

        const int CountOfDeathHits = 10;
        
        const float MonsterStatToPCE = 0.75f;
        const float BossStatToPCE = 0.25f;
        const float LuckStatToPCE = 2.8f;
        
        var stat = new UnitStat();
        
        //1. 보유 아이템 스탯 합산
        ItemStat.CopyTo(stat);
        Avatar.ApplyAvatarStats(stat);
        Avatar.ApplyAvatarEquipBuffStats(stat);

        //2. 순수 공격 능력치 (순공능)
        var pureAttackStat =
            stat[UnitStatType.Attack]
            * (FixedFloat.One + stat[UnitStatType.AttackPercent] / FixedFloat.Hundred)
            * (FixedFloat.One + stat[UnitStatType.CriticalPercent] / FixedFloat.Hundred * (stat[UnitStatType.CriticalDamagePercent] / FixedFloat.Hundred))
            * (MonsterStatToPCE * (FixedFloat.One + stat[UnitStatType.MonsterDamageEfficiencyPercent] / FixedFloat.Hundred)
               + BossStatToPCE * (FixedFloat.One + stat[UnitStatType.BossDamageEfficiencyPercent] / FixedFloat.Hundred));

        //3. 플레이어 공격 능력치 배수 (플공배)
        var cooldownDenominator = FixedFloat.One - stat[UnitStatType.CooldownPercent] / FixedFloat.Hundred;
        var attackRateMultiplier = cooldownDenominator > FixedFloat.Zero
            ? FixedFloat.One / cooldownDenominator
            : FixedFloat.One;
        var playerAttackPowerMultiplier =
            attackRateMultiplier
            * (FixedFloat.One - stat[UnitStatType.Luck] * GameConstants.LuckScaleFactor 
               + (stat[UnitStatType.Luck] * GameConstants.LuckScaleFactor * LuckStatToPCE));
        playerAttackPowerMultiplier -= FixedFloat.One; //기본 1배는 제외

        //4. 펫, 장비 공격 능력치 배수 (펫공배, 장공배)
        var petAttackPowerMultiplier = Avatar.Pets
            .Where(p => p.Id != 0)
            .Sum(p => p.GetData()!.PowerAttackMultiplyPercents.GetClamped(p.Level - 1)) / FixedFloat.Hundred;
        var equipmentAttackPowerMultiplier = Avatar.Equipments
            .Where(e => e.Id != 0)
            .Sum(e => e.GetData()!.PowerAttackMultiplyPercents.GetClamped(e.Level - 1)) / FixedFloat.Hundred;

        //5. 공격 능력치
        var attackPower = pureAttackStat 
                          + pureAttackStat * playerAttackPowerMultiplier 
                          + pureAttackStat * petAttackPowerMultiplier 
                          + pureAttackStat * equipmentAttackPowerMultiplier;

        //6. 순수 체력 능력치 (순체능)
        var pureHp = stat[UnitStatType.Hp] * (FixedFloat.One + stat[UnitStatType.HpPercent] / FixedFloat.Hundred);
        
        //7. 펫, 장비 체력 능력치 배수 (펫체배, 장체배)
        var petHealthPowerMultiplier = Avatar.Pets
            .Where(p => p.Id != 0)
            .Sum(p => p.GetData()!.PowerHpMultiplyPercents.GetClamped(p.Level - 1)) / FixedFloat.Hundred;
        var equipmentHealthPowerMultiplier = Avatar.Equipments
            .Where(e => e.Id != 0)
            .Sum(e => e.GetData()!.PowerHpMultiplyPercents.GetClamped(e.Level - 1)) / FixedFloat.Hundred;
        
        //8. 최종 체력 능력치
        var healthPower = pureHp 
                          + pureHp * petHealthPowerMultiplier 
                          + pureHp * equipmentHealthPowerMultiplier;

        //9. 방어력 적용 데미지
        var defenseAppliedDamage =
            healthPower / CountOfDeathHits
            - stat[UnitStatType.Defense] * (FixedFloat.One + stat[UnitStatType.DefensePercent] / FixedFloat.Hundred);
       
        //10. 펫, 장비 방어 능력치 배수 (펫방배, 장방배)
        var petDefensePowerMultiplier = Avatar.Pets
            .Where(p => p.Id != 0)
            .Sum(p => p.GetData()!.PowerDefenseMultiplyPercents.GetClamped(p.Level - 1)) / FixedFloat.Hundred;
        var equipmentDefensePowerMultiplier = Avatar.Equipments
            .Where(e => e.Id != 0)
            .Sum(e => e.GetData()!.PowerDefenseMultiplyPercents.GetClamped(e.Level - 1)) / FixedFloat.Hundred;

        //11. 가중 평균 데미지
        var avgDamage =
            (MonsterStatToPCE * (defenseAppliedDamage * (FixedFloat.One - stat[UnitStatType.MonsterDamageTakenEfficiencyPercent] / FixedFloat.Hundred))
             + BossStatToPCE * (defenseAppliedDamage * (FixedFloat.One - stat[UnitStatType.BossDamageTakenEfficiencyPercent] / FixedFloat.Hundred)))
            * (FixedFloat.One - stat[UnitStatType.DamageTakenEfficiencyPercent] / FixedFloat.Hundred)
            * (FixedFloat.One - petDefensePowerMultiplier / FixedFloat.Hundred)
            * (FixedFloat.One - equipmentDefensePowerMultiplier / FixedFloat.Hundred);

        if (healthPower <= FixedFloat.Zero || avgDamage <= FixedFloat.Zero)
        {
            var fallbackPower = (long)(attackPower * AttackToPCE);
            Power = fallbackPower > 0 ? fallbackPower : 0;
            return;
        }
        
        //12. 생존 피격 횟수
        var surviveHitCount = healthPower / avgDamage;

        //13. 방어 능력치
        var defensePower = healthPower * surviveHitCount / CountOfDeathHits;
        
        //14. 최종 전투력
        var calculatedPower = (long)(attackPower * AttackToPCE + defensePower * DefenseToPCE);
        Power = calculatedPower > 0 ? calculatedPower : 0;


    }
}
