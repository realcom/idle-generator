using System;
using System.Reflection;

public abstract class ZAttribute : Attribute
{
}

[AttributeUsage(AttributeTargets.Class, Inherited = false)]
public class LegacyMarkerAttribute : ZAttribute
{
    public LegacyMarkerAttribute(string desc)
    {
        Description = desc;
    }

    public string Description { get; }

}

[AttributeUsage(AttributeTargets.Field)]
public class ForceCacheAttribute : ZAttribute
{
    
}

[AttributeUsage(AttributeTargets.Field)]
public class ReferenceValidateAttribute : ZAttribute
{
    
}
