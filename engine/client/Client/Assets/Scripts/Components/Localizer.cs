using System;
using System.Xml;
using System.Collections;
using System.Collections.Generic;
using Commons.Resources;
using UnityEngine;
using UnityEngine.Pool;

public class Localizer
{
    public static bool INITIALIZED = false;
	
	private Dictionary<String, String> _stringMap = new Dictionary<String, String>();

	public void Initialize(bool forced = false) {
		if (INITIALIZED && forced == false)
			return;

        try {
			var fileName = "Strings.xml";
			var text = Utility.LoadResource<string>(fileName);
			if (string.IsNullOrEmpty(text))
				return;
            var doc = new XmlDocument(); 
            doc.LoadXml(text);

			//
			_stringMap.Clear();
			foreach (XmlNode node in doc.SelectNodes("//String")) {
                var key = node.Attributes["Key"].InnerText;
                if (_stringMap.ContainsKey(key))
                    continue;

                _stringMap.Add(key, node.InnerText.Replace("\\n", "\n").Trim());
            }

            INITIALIZED = true;
            Debug.Log(string.Format("Loaded {0} strings", _stringMap.Count));
        } catch (Exception e) {
            Debug.LogException(e);
        }
    }

	public bool ContainsString(string key) => _stringMap.ContainsKey(key);

	public bool TryGetString(string key, out string _value) => 
		_stringMap.TryGetValue($"{key}_{PlatformManager.GetLanguage()}", out _value) || _stringMap.TryGetValue(key, out _value);
	
	public void AddString (string key, string value)
	{
		_stringMap.Remove(key);

		if(string.IsNullOrEmpty(value))
			return;

		_stringMap.Add (key, value);
	}
	
	public string []GetList(string key) {
		var lst = new List<string>();
		for(int i = 1;true;++i) {
			var realKey = key + "_" + i;
			string value;
			
			if(!_stringMap.TryGetValue(realKey, out value))
				break; 	
			
			lst.Add (realKey.L ());
		}
		
		return lst.ToArray();
	}
	
	public string []GetRawList(string key) {
		var lst = new List<string>();
		for(int i = 1;true;++i) {
			var realKey = key + "_" + i;
			string value;
			
			if(!_stringMap.TryGetValue(realKey, out value))
				break; 	
			
			lst.Add (value);
		}
		
		return lst.ToArray();
	}

	public Color32[] GetColorList(string key) {
		var lst = new List<Color32> ();

		foreach(var c in GetList (key))
			lst.Add (Utility.HexToColor(c));

		return lst.ToArray();
	}

	public static string GetById(int Id,params object[] args)
	{
		return GetById(Id, ResourceString.Types.Category.Client, args);
	}

	public static string GetById(int Id, ResourceString.Types.Category category, params object[] args)
	{
		if (Id == 0)
			return string.Empty;
		
		var localized = ResourceString.Get(category, Id, ResourceEntity.Language);
		return localized.GetParsedString(args);
	}
	
}

public static class LocalizerUtility {
	
	public static IEnumerable<string> GetLocalizationList(this string key, int startIndex = 1, int endIndex = int.MaxValue)
	{
		for (var i = startIndex; i <= endIndex; i++)
		{
			var realKey = key + "_" + i;
			var localized = realKey.L();
			
			if (ReferenceEquals(realKey, localized))
				break;

			yield return localized;
		}
	}

	public static string L(this string key, ResourceString.Types.Category category, params object[] args)
	{
		if (string.IsNullOrEmpty(key))
			return string.Empty;
		try
		{
			var localized = ResourceString.Get(category, key, ResourceEntity.Language);
			if (ReferenceEquals(localized, key))
				return key.GetParsedString(args);
			
			return localized.GetParsedString(args);
		}
		catch (Exception ex)
		{
#if UNITY_EDITOR
			Debug.LogError($"Localizer failed: {key}");
			Debug.LogException(ex);
#endif
			return string.Empty;
		}
	}
	
	public static string GetParsedString(this string inString, params object[] args)
	{
		var origin = inString;
		if (args.Length > 0)
			inString = string.Format(inString, args);

		if (!string.IsNullOrEmpty(inString) && inString[0] == '$')
		{
			while (true)
			{
				var parsed = ParsePredefinedSigns(origin, inString, args);
				if (parsed == inString)
					break;
				inString = parsed;
			}

			inString = inString[1..];
		}

		return inString;
	}

	private static string ParsePredefinedSigns(string origin, string localized, params object[] args)
	{
		var ordinalTagIndex = origin.IndexOf("[:ordinal]", StringComparison.OrdinalIgnoreCase);
		if (ordinalTagIndex != -1)
		{
			//{n}[:ordinal] => n
			var argumentIndex = origin[ordinalTagIndex - 2] - '0';
			return localized.Replace("[:ordinal]", ((int)args[argumentIndex]).ToOrdinal());
		}

		return localized;
	}
	
	public static string L(this string key, params object[] args)
	{
		return L(key, ResourceString.Types.Category.Client, args);
	}
	
}