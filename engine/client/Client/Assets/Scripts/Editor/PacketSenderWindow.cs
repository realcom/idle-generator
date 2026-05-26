using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using UnityEditor;
using UnityEngine;
using Commons.Packets;
using Commons.Packets.Requests;
using Cysharp.Threading.Tasks;

public class PacketSenderWindow : EditorWindow
{
    [MenuItem("Tools/IdleZ/Packet Sender")]
    public static void ShowWindow()
    {
        GetWindow<PacketSenderWindow>("Packet Sender");
    }

    private Vector2 _scroll;
    private string _selectedRequestType;
    private Dictionary<string, object> _parameterValues = new();
    private Type _currentRequestType;
    private List<PropertyInfo> _currentProperties = new();

    private void OnGUI()
    {
        _scroll = EditorGUILayout.BeginScrollView(_scroll);

        // Request type selection dropdown
        var requestTypes = GetRequestTypes();
        var requestTypeNames = requestTypes.Select(t => t.Name).ToArray();
        var currentIndex = Array.IndexOf(requestTypeNames, _selectedRequestType);
        var newIndex = EditorGUILayout.Popup("Request Type", currentIndex, requestTypeNames);
        
        if (newIndex != currentIndex)
        {
            _selectedRequestType = requestTypeNames[newIndex];
            _currentRequestType = requestTypes[newIndex];
            _currentProperties = _currentRequestType.GetProperties(BindingFlags.Public | BindingFlags.Instance)
                .Where(p => p.CanRead && p.CanWrite && !p.Name.Equals("Response", StringComparison.OrdinalIgnoreCase))
                .ToList();
            _parameterValues.Clear();
        }

        if (_currentRequestType != null)
        {
            EditorGUILayout.Space(10);
            EditorGUILayout.LabelField("Parameters", EditorStyles.boldLabel);

            // Draw parameter fields
            foreach (var property in _currentProperties)
            {
                DrawParameterField(property);
            }

            EditorGUILayout.Space(10);
            if (GUILayout.Button("Send Packet"))
            {
                SendPacket().Forget();
            }
        }

        EditorGUILayout.EndScrollView();
    }

    private void DrawParameterField(PropertyInfo property)
    {
        var propertyType = property.PropertyType;
        var currentValue = _parameterValues.ContainsKey(property.Name) ? _parameterValues[property.Name] : GetDefaultValue(propertyType);

        if (propertyType == typeof(int))
        {
            _parameterValues[property.Name] = EditorGUILayout.IntField(property.Name, (int)currentValue);
        }
        else if (propertyType == typeof(long))
        {
            _parameterValues[property.Name] = EditorGUILayout.LongField(property.Name, (long)currentValue);
        }
        else if (propertyType == typeof(float))
        {
            _parameterValues[property.Name] = EditorGUILayout.FloatField(property.Name, (float)currentValue);
        }
        else if (propertyType == typeof(string))
        {
            _parameterValues[property.Name] = EditorGUILayout.TextField(property.Name, (string)currentValue);
        }
        else if (propertyType == typeof(bool))
        {
            _parameterValues[property.Name] = EditorGUILayout.Toggle(property.Name, (bool)currentValue);
        }
        else if (propertyType.IsEnum)
        {
            _parameterValues[property.Name] = EditorGUILayout.EnumPopup(property.Name, (Enum)currentValue);
        }
    }

    private object GetDefaultValue(Type type)
    {
        if (type.IsValueType)
            return Activator.CreateInstance(type);
        return null;
    }

    private Type[] GetRequestTypes()
    {
        var types = Assembly.GetAssembly(typeof(Request)).GetTypes(); 
        return types.Where(t => t.IsClass && !t.IsAbstract && t.Namespace != null && t.Namespace.Contains(nameof(Commons.Packets.Requests)) && t.Name.EndsWith("Request")).ToArray();
    }

    private async UniTask SendPacket()
    {
        if (_currentRequestType == null) return;

        try
        {
            var request = Activator.CreateInstance(_currentRequestType);
            foreach (var property in _currentProperties)
            {
                if (_parameterValues.TryGetValue(property.Name, out var value))
                {
                    property.SetValue(request, value);
                }
            }

            // Find the correct Packet.Pop overload for this request type
            var popMethod = typeof(Packet).GetMethods(BindingFlags.Public | BindingFlags.Static)
                .FirstOrDefault(m => m.Name == "Pop" && m.GetParameters().Length > 1 && 
                                   m.GetParameters()[1].ParameterType == _currentRequestType);

            if (popMethod == null)
            {
                EditorUtility.DisplayDialog("Error", 
                    $"No matching Packet.Pop method found for request type {_currentRequestType.Name}", 
                    "OK");
                return;
            }

            var packet = (Packet)popMethod.Invoke(null, new object[] { (byte)0, request });
            var response = await ZWorldClient.Get().SendPacket(packet);
            if (!response.Status.IsSuccess())
            {
                EditorUtility.DisplayDialog("Error", 
                    $"Failed to send packet. Status: {response.Status}", 
                    "OK");
            }
        }
        catch (Exception e)
        {
            EditorUtility.DisplayDialog("Error", 
                $"Error sending packet: {e.Message}", 
                "OK");
        }
    }
}