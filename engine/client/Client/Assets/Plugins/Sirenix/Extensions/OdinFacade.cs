//copied from https://gist.github.com/gjroelofs/e46deeba8296f617a3d0e9dc7ec1390c
#if UNITY_EDITOR
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using Sirenix.OdinInspector;
using Sirenix.OdinInspector.Editor;
using UnityEngine;
using TypeCache = UnityEditor.TypeCache;

namespace Sirenix.OdinInspector.Editor
{
        /// <summary>
    /// Allows creating a type that will be used to render the editor in place of the given type.
    /// This allows you to use attributes / normal editor design workflow instead of having to write a custom value drawer.
    /// 
    /// E.g.: Given type `ComplexObject`, create a `ComplexObjectFacade : Facade{ComplexObject}` which has all variables you want to expose and appropriate OdinInspector attributes.
    /// The `ComplexObject` will then be accessible through the `Target` variable.
    ///
    /// E.g.:
    /// <code>
    /// // The below code will only show the name of the ComplexObject, without label and if the CO is not null.
    /// public class ComplexObjectFacade : Facade{ComplexObject} {
    ///
    ///    [HideLabel, ShowIf("@Target != null")]
    ///    public Name {
    ///       get => Target?.Name;
    ///       set => {
    ///             if(Target != null) Target.Name = value;
    ///       }
    ///    }
    ///   
    /// }
    /// </code>
    /// 
    /// </summary>
    public class FacadePropertyResolver : OdinPropertyProcessor
    {

        /// <summary> Contains a mapping of the targeted Type to the concrete Facade. </summary>
        public Lazy<Dictionary< /* Foo */ Type, /* FooFacade (: Facade<Foo>) */ Type>> Facades = new(() =>
        {
            return TypeCache.GetTypesDerivedFrom(typeof(OdinFacade<>))
                .Where(t => !t.IsGenericTypeDefinition)
                .Select(t => Tuple.Create(
                    t.GetInterfaces()
                        .First(i => i.IsGenericType && i.GetGenericTypeDefinition() == typeof(IOdinFacade<>))
                        .GenericTypeArguments.First(), t))
                .ToDictionary(t => t.Item1, t => t.Item2);
        });
        
        /// <summary> Creates a getter setter that forwards the property's getter setter onto the Facade, with concrete type. </summary>
        private Lazy<MethodInfo> GetterSetter = new Lazy<MethodInfo>(() => typeof(FacadePropertyResolver).GetMethod("CreateWrapper", BindingFlags.Public | BindingFlags.Static));
        
        public override void ProcessMemberProperties(List<InspectorPropertyInfo> propertyInfos)
        {
            // TODO: Support inheritance.
            // TODO: Cache the translation instead of doing it on every call.
            // Go through and replace all types for which we have a registered facade.
            for (int i = 0; i < propertyInfos.Count; i++)
            {
                var info = propertyInfos[i];
                if (info.TypeOfValue == null) continue;
                if (!Facades.Value.ContainsKey(info.TypeOfValue)) continue;

                // Create a function that will given a propertyInfo, forward value get/set onto the Facade.
                var creator = GetterSetter.Value.MakeGenericMethod(info.TypeOfOwner, info.TypeOfValue, Facades.Value[info.TypeOfValue]);
                var getterSetter = (IValueGetterSetter) creator.Invoke(null, new object[]{info});
                
                // Draw the facade without a wrapping label.
                var newPI = InspectorPropertyInfo.CreateValue(info.PropertyName, info.Order, info.SerializationBackend, getterSetter);
                
                propertyInfos.RemoveAt(i);
                propertyInfos.Insert(i, newPI);
            }

        }
        
        public static GetterSetter<TParent, TFacade> CreateWrapper<TParent, TWrapped, TFacade>(InspectorPropertyInfo property)
        where TFacade : OdinFacade<TWrapped>, new()
        {
            var facade = new TFacade();
            return new GetterSetter<TParent, TFacade>(
                (ref TParent instance) => {
                    facade.Target = (TWrapped) property.GetGetterSetter().GetValue(instance);
                    return facade;
                }, 
                (ref TParent instance, TFacade value) => property.GetGetterSetter().SetValue(instance, value.Target)
                );
        }
    }

    public interface IOdinFacade
    {
        object UntypedTarget { get; set; }
    }

    public interface IOdinFacade<T> : IOdinFacade
    {
        /// <summary> Strongly typed target we are editing. </summary>
        T Target { get; set; }
    }
    
    /// <summary>
    /// Allows using a different type to construct an editor for a target type.
    /// I.e.: Given type ComplexObject, use ComplexObjectFacade : OdinFacade{ComplexObject} to define the variables & attributes to be used instead of those defined on ComplexObject.
    /// </summary>
    /// <typeparam name="T">The type of object we want to edit.</typeparam>
    [HideLabel, HideReferenceObjectPicker, InlineProperty]
    public class OdinFacade<T> : IOdinFacade<T>
    {
        public T Target { get; set; }

        public object UntypedTarget {
            get => Target;
            set => Target = (T) value;
        }
        
    }
}
#endif