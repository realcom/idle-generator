using Commons.Resources;
using Google.Protobuf;

namespace Server.Tests.TestSupport;

internal sealed class TestResourceScope : IDisposable
{
    public TestResourceScope(
        IEnumerable<ResourceItem>? items = null,
        IEnumerable<ResourceMap>? maps = null,
        IEnumerable<ResourceUnit>? units = null,
        IEnumerable<ResourceSkill>? skills = null,
        IEnumerable<ResourceBuff>? buffs = null,
        IEnumerable<ResourceAchievement>? achievements = null,
        IEnumerable<ResourceString>? strings = null,
        IEnumerable<ResourceTrigger>? triggers = null,
        IEnumerable<ResourceTrigger.Types.MethodMetadata>? triggerMethods = null)
    {
        Load(items, maps, units, skills, buffs, achievements, strings, triggers, triggerMethods);
    }

    public void Dispose()
    {
        Load();
    }

    private static void Load(
        IEnumerable<ResourceItem>? items = null,
        IEnumerable<ResourceMap>? maps = null,
        IEnumerable<ResourceUnit>? units = null,
        IEnumerable<ResourceSkill>? skills = null,
        IEnumerable<ResourceBuff>? buffs = null,
        IEnumerable<ResourceAchievement>? achievements = null,
        IEnumerable<ResourceString>? strings = null,
        IEnumerable<ResourceTrigger>? triggers = null,
        IEnumerable<ResourceTrigger.Types.MethodMetadata>? triggerMethods = null)
    {
        var resources = new Resources
        {
            ItemGlobal = new ResourceItem.Types.Global(),
            MapGlobal = new ResourceMap.Types.Global(),
            UnitGlobal = new ResourceUnit.Types.Global(),
            SkillGlobal = new ResourceSkill.Types.Global(),
            BuffGlobal = CreateBuffGlobal(),
            AchievementGlobal = new ResourceAchievement.Types.Global(),
            StringGlobal = new ResourceString.Types.Global(),
        };

        if (items != null)
            resources.Items.Add(items);
        if (maps != null)
            resources.Maps.Add(maps);
        if (units != null)
            resources.Units.Add(units);
        if (skills != null)
            resources.Skills.Add(skills);
        if (buffs != null)
            resources.Buffs.Add(buffs);
        if (achievements != null)
            resources.Achievements.Add(achievements);
        if (strings != null)
            resources.Strings.Add(strings);
        if (triggers != null)
            resources.Triggers.Add(triggers);
        if (triggerMethods != null)
            resources.TriggerMethods.Add(triggerMethods);

        var bytes = resources.ToByteArray();
        ResourceTrigger.ReloadBinary(bytes);
        ResourceItem.ReloadBinary(bytes);
        ResourceMap.ReloadBinary(bytes);
        ResourceUnit.ReloadBinary(bytes);
        ResourceSkill.ReloadBinary(bytes);
        ResourceBuff.ReloadBinary(bytes);
        ResourceAchievement.ReloadBinary(bytes);
        ResourceString.ReloadBinary(bytes);
    }

    private static ResourceBuff.Types.Global CreateBuffGlobal()
    {
        var global = new ResourceBuff.Types.Global();
        global.BuffApplyProbabilities.Add(0, new ResourceBuff.Types.Global.Types.BuffApplyProbability
        {
            Probabilities = { 100f },
        });
        return global;
    }
}
