namespace Commons.Resources
{
    public enum ResourceType
    {
        Item,
        Achievement,
        Buff,
        Skill,
        Unit,
        Map,
        Audio,
        Trigger,
    }
    
    public abstract partial class ResourceEntity
    {
        public abstract ResourceType ResourceType { get; }
        public abstract bool IsValid { get; }
    }
}