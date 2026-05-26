using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System.Runtime.CompilerServices;
using System.Text;
using Commons.Types;
using Commons.Types.Geometry;
using Google.Protobuf;

namespace Commons.Utility
{
    public static class DebugExtensions
    {
        private static readonly HashSet<Type> EmptyOmitTypes = new HashSet<Type>();
        
        private static void PutIndent(StringBuilder sb, int indent)
        {
            for (var i = 2 * indent; i > 0; --i)
                sb.Append(' ');
        }

        private static void DebugDump(StringBuilder sb, string name, object? obj,
            HashSet<Type> omitTypes, HashSet<int> iteratedObjects, int indent = 0)
        {
            if (obj == null)
            {
                if (string.IsNullOrEmpty(name))
                    sb.Append("null");
                else
                    sb.Append($"{name}: null");
                return;
            }

            var type = obj.GetType();
            if (omitTypes.Contains(type))
            {
                if (string.IsNullOrEmpty(name))
                    sb.Append($"{type.Name}");
                else
                    sb.Append($"{name}: {type.Name}");
                return;
            }
            if (type == typeof(float))
            {
                if (string.IsNullOrEmpty(name))
                    sb.Append($"{(float)obj:F4}");
                else
                    sb.Append($"{name}: {(float)obj:F4}");
                return;
            }
            if (type == typeof(FixedFloat))
            {
                if (string.IsNullOrEmpty(name))
                    sb.Append($"{(float)(FixedFloat)obj:F4}");
                else
                    sb.Append($"{name}: {(float)(FixedFloat)obj:F4}");
                return;
            }
            if (type.IsValueType
                || type == typeof(string) || type == typeof(FixedVector2)
                || type.Namespace?.StartsWith("System") == true)
            {
                if (string.IsNullOrEmpty(name))
                    sb.Append(obj);
                else
                    sb.Append($"{name}: {obj}");
                return;
            }
            
            if (obj is ByteString byteString)
            {
                if (string.IsNullOrEmpty(name))
                    sb.Append(byteString.ToBase64());
                else
                    sb.Append($"{name}: {byteString.ToBase64()}");
                return;
            }
            
            if (type.IsArray)
            {
                if (!string.IsNullOrEmpty(name))
                    sb.Append($"{name}: ");
                var array = (Array)obj;
                if (array.Length == 0)
                {
                    sb.Append("Empty");
                    return;
                }
                foreach (var item in array)
                {
                    sb.AppendLine();
                    PutIndent(sb, indent + 1);
                    DebugDump(sb, "", item, omitTypes, iteratedObjects, indent + 1);
                }

                return;
            }
            
            if (obj is IDictionary dictionary)
            {
                if (!string.IsNullOrEmpty(name))
                    sb.Append($"{name}: ");
                if (dictionary.Count == 0)
                {
                    sb.Append("Empty");
                    return;
                }
                foreach (DictionaryEntry entry in dictionary)
                {
                    sb.AppendLine();
                    PutIndent(sb, indent + 1);
                    sb.Append($"{entry.Key}: ");
                    DebugDump(sb, "", entry.Value, omitTypes, iteratedObjects, indent + 1);
                }
                
                return;
            }
            
            if (obj is IList list)
            {
                if (!string.IsNullOrEmpty(name))
                    sb.Append($"{name}: ");
                if (list.Count == 0)
                {
                    sb.Append("Empty");
                    return;
                }
                foreach (var item in list)
                {
                    sb.AppendLine();
                    PutIndent(sb, indent + 1);
                    DebugDump(sb, "", item, omitTypes, iteratedObjects, indent + 1);
                }
                
                return;
            }

            var objId = RuntimeHelpers.GetHashCode(obj);
            if (iteratedObjects.Contains(objId))
            {
                if (string.IsNullOrEmpty(name))
                    sb.Append("[Circular]");
                else
                    sb.Append($"{name}: [Circular]");
                return;
            }
            iteratedObjects.Add(objId);

            if (string.IsNullOrEmpty(name))
                sb.Append($"[{type.Name}]");
            else
                sb.Append($"{name}");
            
            var properties = type.GetProperties(BindingFlags.NonPublic | BindingFlags.Public | BindingFlags.Instance);
            foreach (var property in properties)
            {
                if (property.GetMethod == null)
                    continue;
                if (property.GetMethod.GetParameters().Length > 0)
                    continue;
                if (property.GetMethod.ReturnType.IsByRef)
                    continue;
                sb.AppendLine();
                PutIndent(sb, indent + 1);
                DebugDump(sb, property.Name, property.GetValue(obj), omitTypes, iteratedObjects, indent + 1);
            }
            
            var fields = type.GetFields(BindingFlags.NonPublic | BindingFlags.Public | BindingFlags.Instance);
            foreach (var field in fields)
            {
                sb.AppendLine();
                PutIndent(sb, indent + 1);
                DebugDump(sb, field.Name, field.GetValue(obj), omitTypes, iteratedObjects, indent + 1);
            }
        }

        public static string DebugDump(this object? obj, HashSet<Type> omitTypes)
        {
            var sb = new StringBuilder();
            DebugDump(sb, "", obj, omitTypes, new HashSet<int>());
            return sb.ToString();
        }

        public static string DebugDump(this object? obj)
        {
            return DebugDump(obj, EmptyOmitTypes);
        }
    }
}
