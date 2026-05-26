using System;
using System.IO;
using System.Linq;
using System.Xml;
using System.Text;
using System.Collections.Generic;
using UnityEngine;
using System.Collections;
using System.Collections.Concurrent;
using System.Diagnostics;
using Ionic.Zlib;
using UnityEngine.UI;
using System.Globalization;
using System.Numerics;
using System.Reflection;
using System.Runtime.Serialization.Formatters.Binary;
using System.Security.Cryptography;
using System.Text.RegularExpressions;
using Commons;
using Commons.Types.Players;
using Commons.Types.Units;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types.Geometry;
using Commons.Utility;
using Commons.Utility.ObjectPool;
using Cysharp.Text;
using DG.Tweening;
using DG.Tweening.Core;
using DG.Tweening.Plugins.Options;
using Google.Protobuf.Collections;
using Google.Protobuf.WellKnownTypes;
using ProtoBuf;
using TMPro;
using UnityEngine.Events;
using UnityEngine.EventSystems;
using UnityEngine.Playables;
using UnityEngine.Pool;
using UnityEngine.SceneManagement;
using UnityEngine.Timeline;
using Debug = UnityEngine.Debug;
using Enum = System.Enum;
using Object = UnityEngine.Object;
using Quaternion = UnityEngine.Quaternion;
using Random = UnityEngine.Random;
using UResources = UnityEngine.Resources;
using Type = System.Type;
using Vector2 = UnityEngine.Vector2;
using Vector3 = UnityEngine.Vector3;
using Vector4 = UnityEngine.Vector4;
#if UNITY_EDITOR
using UnityEditor;
#endif

public class EmptyList<T>
{
	private static readonly List<T> _list = new();
	public static List<T> Get()
	{
		return _list;
	}
}

public static partial class Utility
{
	public static GameObject DuplicateGameObject(GameObject original)
	{
#if UNITY_EDITOR
		var previousSelection = Selection.objects;
		Selection.activeGameObject = original;
		Unsupported.DuplicateGameObjectsUsingPasteboard();
		var duplicated = Selection.activeGameObject;
		Selection.objects = previousSelection;
        
		if (duplicated == null)
		{
			Debug.LogError("Failed to duplicate GameObject: " + original.name);
			return null;
		}

		return duplicated;
#else
 		return Object.Instantiate(original);
#endif
	}
	
	public static void SetOnClick(this Button bt, UnityAction call)
	{
		bt.onClick.RemoveAllListeners();
		bt.onClick.AddListener(call);
	}
	
	public static string ToSpriteString(this LazyLoad<Sprite> sprite)
	{
		return sprite?.name?.ToIconSpriteString() ?? string.Empty;
	}
	
	public static string ToIconSpriteString(this string iconPath)
	{
		if (string.IsNullOrEmpty(iconPath))
			return null;
		
		var parts = iconPath.Split('/');
		if (parts.Length < 2)
		{
			return null;
		}
		
		var folderName = parts[^2];
		var fileName = Path.GetFileNameWithoutExtension(parts[^1]);
		
		return $"<sprite=\"{folderName}\" name=\"{fileName}\">";
		
		//var fileName = Path.GetFileNameWithoutExtension(iconPath);
		//return $"<sprite name=\"{fileName}\">";
	}

	public static float MapRangeClamped(this int value, float from1, float to1, float from2 = 0.0f, float to2 = 1.0f) => ((float)value).MapRangeClamped(from1, to1, from2, to2);

	public static float MapRangeClamped(this float value, float from1, float to1, float from2 = 0.0f, float to2 = 1.0f)
	{
		var mappedValue = (value - from1) / (to1 - from1) * (to2 - from2) + from2;
		return Mathf.Clamp(mappedValue, Mathf.Min(from2, to2), Mathf.Max(from2, to2));
	}
	public static double MapRangeClamped(this double value, double from1, double to1, double from2 = 0.0f, double to2 = 1.0f)
	{
		var mappedValue = (value - from1) / (to1 - from1) * (to2 - from2) + from2;
		return Math.Clamp(mappedValue, Math.Min(from2, to2), Math.Max(from2, to2));
	}
	
	public static Vector3 ProjectToXZPlane(this Vector3 vector)
	{
		var v = vector;
		v.y = 0f;
		vector = v;
		return vector;
	}
	
	public static Vector2 PickXY(this Vector3 v)
	{
		return new (v.x, v.y);
	}
	
	public static Vector3 XYZtoXZO(this Vector3 vector)
	{
		var pos = new Vector3(vector.x,  vector.z, 0f);
		return pos;
	}

	public static Vector3 RotateVector2D(this Vector3 pt, Vector3 origin, float angle)
	{
		return Quaternion.AngleAxis(angle, new Vector3(0, 0, 1)) * (pt - origin) + origin;
	}

	public static UInt32 ReverseBytes(UInt32 value)
	{
		return (value & 0x000000FFU) << 24 | (value & 0x0000FF00U) << 8 |
		       (value & 0x00FF0000U) >> 8 | (value & 0xFF000000U) >> 24;
	}

	public static T[] SubArray<T>(this T[] data, int index, int length = -1)
	{
		if (length < 0)
			length = data.Length - index;
		T[] result = new T[length];
		Array.Copy(data, index, result, 0, length);
		return result;
	}


	public static Rect ToRect(this Bounds b)
	{
		return new Rect(
				b.min.x,
				b.min.y,
				b.size.x,
				b.size.y);
	}

	public static int convertEndian(int n)
	{
		return ((n >> 24) & 0xff)
		       | (((n >> 16) & 0xff) << 8)
		       | (((n >> 8) & 0xff) << 16)
		       | (((n >> 0) & 0xff) << 24);
	}

	private static readonly ConcurrentQueue<MemoryStream> MemoryStreamPool = new ConcurrentQueue<MemoryStream>();

	private static MemoryStream PopMemoryStream()
	{
		if (MemoryStreamPool.TryDequeue(out var stream))
			return stream;
		return new MemoryStream();
	}

	private static void ReturnMemoryStream(MemoryStream stream)
	{
		stream.SetLength(0);
		MemoryStreamPool.Enqueue(stream);
	}
	
	public static bool ContainsFlag(this Enum baseEnum, Enum flag)
	{
		if (baseEnum == null || flag == null)
			return false;

		var baseValue = Convert.ToInt64(baseEnum);
		var flagValue = Convert.ToInt64(flag);

		return (baseValue & flagValue) != 0;
	}
	
	public static T ParseEnumWithException<T>(string value)
	{
		return (T)(object)Enum.Parse(typeof(T), value, true);
	}

	public static void SetActive(this MonoBehaviour _this, bool value)
	{
		if (_this.gameObject.activeSelf == value)
			return;
		
		_this.gameObject.SetActive(value);
	}
	
	public static void SetActive(this Component _this, bool value)
	{
		if (_this.gameObject.activeSelf == value)
			return;
		
		_this.gameObject.SetActive(value);
	}

	public static bool IsActive(this MonoBehaviour _this)
	{
		return _this.gameObject.activeSelf;
	}

	public static int RemoveNullReferences<T>(this HashSet<T> set) where T : class
	{
		return set.RemoveWhere((v) =>
		{
			if (v is Object obj)
				return obj == null;

			return v == null;
		});
	}
	
	public static TValue GetOrAdd<TKey, TValue>
	(this IDictionary<TKey, TValue> dictionary,
		TKey key,
		TValue defaultValue = default)
	{
		if (!dictionary.TryGetValue(key, out var value))
			value = dictionary[key] = defaultValue;
		return  value;
	}

	public static float Clamp01(this float value, float NaNReplaceValue = 0f)
	{
		return float.IsNaN(value) ? NaNReplaceValue : Mathf.Clamp01(value);
	}
	
	public static float Clamp01(this double value, float NaNReplaceValue = 0f)
	{
		return float.IsNaN((float)value) ? NaNReplaceValue : Mathf.Clamp01((float)value);
	}
	
	public static float Sqr(this float value)
	{
		return value * value;
	}

	public static Vector2 ToVector2(List<float> lst)
	{
		return new Vector2(lst[0], lst[1]);
	}

	private static readonly HashSet<string> _missingResources = new();
	public static void ResetMissingResources()
	{
		_missingResources.Clear();
	}
	
	public static bool ContainsSpecialOrWhitespace(string input)
	{
		if (string.IsNullOrEmpty(input))
			return false;

		// 정규식: 특수문자 또는 공백이 포함되어 있으면 true
		return Regex.IsMatch(input, @"[!@#$%^&*(),.?""':;{}|<>_\-\+=\[\\\]/`~]");
	}
	
	// 허용 문자 범위 (유니코드 블록)
	// - Latin: U+0000 ~ U+024F + Latin Extended
	// - Cyrillic: U+0400 ~ U+04FF
	// - Hangul: U+AC00 ~ U+D7AF
	// - Hiragana: U+3040 ~ U+309F
	// - Katakana: U+30A0 ~ U+30FF
	// - CJK Unified Ideographs: U+4E00 ~ U+9FFF (중문, 번체/간체 모두 포함)
	private static readonly Regex LettersOnly = new(
		"^[0-9a-zA-Zㄱ-ㅎㅏ-ㅣ가-힣ぁ-んァ-ヶー一-龠]+$",
		RegexOptions.Compiled
	);
	
	public static bool IsValidLettersOnly(string input)
	{
		if (string.IsNullOrEmpty(input)) return false;

		// 결합문자/악센트 안정화를 위해 NFC 정규화 권장
		var normalized = input.Normalize(NormalizationForm.FormC);
		return LettersOnly.IsMatch(normalized);
	}
	
	public static T LoadResource<T>(string path, bool isCommonsResource = false)
	{
		if (string.IsNullOrEmpty(path))
			return default;
		if (_missingResources.Contains(path))
			return default;
#if UNITY_EDITOR
		// Debug.Log($"LoadResource: {path}");
#endif

		//return AssetBundleManager.get().getAsset(Path.GetFileNameWithoutExtension(Path.GetFileName(path)), type);
		object obj = null;
		Type type = typeof(T);

		Type archivedType = type == typeof(byte[]) || type == typeof(string) ? typeof(TextAsset) : type;

		if (isCommonsResource)
		{
#if UNITY_EDITOR
			if (Constants.IGNORE_ASSETBUNDLE)
			{
				var json = File.ReadAllText($"Assets/PatchResources/{path}");
				return (T)(object)json;
			}
// #else
			// var bytes = File.ReadAllBytes($"Assets/Resources/{path}");
			// return (T)(object)bytes;
#endif
		}

#if UNITY_EDITOR && !UNITY_WEBPLAYER
		if (Constants.IGNORE_ASSETBUNDLE)
		{
			if (type == typeof(Texture2D))
			{
				if (!File.Exists($"Assets/PatchResources/{path}"))
					return default(T);

				//
				byte[] bytes = File.ReadAllBytes($"Assets/PatchResources/{path}");
				var tex = new Texture2D(1, 1, TextureFormat.ARGB32, false);
				tex.LoadImage(bytes);
				tex.filterMode = FilterMode.Point;
				tex.wrapMode = TextureWrapMode.Clamp;
				return (T)(object)tex;
			}
			obj = AssetDatabase.LoadAssetAtPath($"Assets/PatchResources/{path}", archivedType);
			
		}

#elif UNITY_STANDALONE_WIN
        if(!path.StartsWith("/")) {
#if UNITY_EDITOR
            path = Path.Combine(Path.Combine(Application.dataPath, "Resources/"), path);
#else
            path = Path.Combine(Path.Combine(Application.dataPath, "../Client/Assets/Resources/"), path);
#endif
        }
        path = path.Replace('\\', '/');

        var www = new WWW("file://" + path);
        CoroutineManager.Perform(PerformLoadResource(www, type));

        while (!www.isDone) {}

        if (type == typeof(byte[]))
            obj = www.bytes;
        else if (type == typeof(string))
            obj = www.text.Replace("\ufeff", "");
        else if (type == typeof(Texture2D))
            obj = www.texture;
        else if (type == typeof(AudioClip))
            obj = www.GetAudioClip();
#endif

		if (obj == null)
		{
			var filename = Path.GetFileName(path);
			// Debug.Log($"Load Asset: {filename}");
			obj = AssetBundleManager.Get().GetAsset(filename, archivedType);
		}

		if (obj == null)
		{
			obj = UResources.Load(Path.Combine(
					"EmbeddedResources", Path.GetDirectoryName(path), Path.GetFileNameWithoutExtension(path)), archivedType);
		}

		if (obj == null)
		{
			obj = UResources.Load(Path.Combine(Path.GetDirectoryName(path) ?? string.Empty, Path.GetFileNameWithoutExtension(path)), archivedType);
		}

		//
		if (obj == null)
		{
			Debug.LogWarning($"Utility::LoadResource() Failed to load {path}");
			_missingResources.Add(path);
		}
		else
		{
			if (obj.GetType() == typeof(TextAsset))
			{
				if (type == typeof(byte[]))
				{
					return (T)(object)((TextAsset)obj).bytes;
				}
				else if (type == typeof(string))
				{
					var text = ((TextAsset)obj).text;
					if (text.StartsWith("GN+"))
					{
						text = Decrypt(text.Substring(3));
						return (T)(object)(text.Replace("\ufeff", ""));
					}
					else if (text.StartsWith("GNF+"))
					{
						return (T)(object)(FastDecrypt(text, 4));
					}
					else
						return (T)(object)(text.Replace("\ufeff", ""));
				}
				else
				{
					Debug.LogWarning($"Utility::LoadResource() Not supported TextAsset. path={path}");
				}
			}
		}

		return (T)(object)obj;
	}

	private static System.Collections.IEnumerator PerformLoadResource(WWW www, Type type)
	{
		yield return www;
	}

	public static T LoadLocalizedResource<T>(string path)
	{
		string basePath = Path.Combine(Path.GetDirectoryName(path), Path.GetFileNameWithoutExtension(path));
		string ext = Path.GetExtension(path);

		T obj = LoadResource<T>($"{basePath}_{PlatformManager.GetLanguage()}{ext}");
		if (obj != null)
			return obj;

		return LoadResource<T>($"{basePath}{ext}");
	}

	public static string MD5(byte[] bytes)
	{
		// encrypt bytes
		System.Security.Cryptography.MD5CryptoServiceProvider md5 = new System.Security.Cryptography.MD5CryptoServiceProvider();
		byte[] hashBytes = md5.ComputeHash(bytes);

		// Convert the encrypted bytes back to a string (base 16)
		string hashString = "";

		for (int i = 0; i < hashBytes.Length; i++)
			hashString += System.Convert.ToString(hashBytes[i], 16).PadLeft(2, '0');

		return hashString.PadLeft(32, '0');
	}

	public static string MD5FromFile(string path)
	{
		// encrypt bytes
		System.Security.Cryptography.MD5CryptoServiceProvider md5 = new System.Security.Cryptography.MD5CryptoServiceProvider();
		using (var fs = new FileStream(path, FileMode.Open))
		{
			byte[] hashBytes = md5.ComputeHash(fs);

			// Convert the encrypted bytes back to a string (base 16)
			string hashString = "";

			for (int i = 0; i < hashBytes.Length; i++)
				hashString += System.Convert.ToString(hashBytes[i], 16).PadLeft(2, '0');

			return hashString.PadLeft(32, '0');
		}
	}


	public static byte[] Compress(this byte[] bytes, Ionic.Zlib.CompressionLevel level = Ionic.Zlib.CompressionLevel.BestCompression)
	{

		using (var memoryStream = new MemoryStream())
		{
			using (var compressor = new ZlibStream(memoryStream, Ionic.Zlib.CompressionMode.Compress, level))
			{
				compressor.Write(bytes, 0, bytes.Length);
			}
			return memoryStream.ToArray();
		}
	}

	public static byte[] Decompress(this byte[] bytes)
	{
		return Ionic.Zlib.ZlibStream.UncompressBuffer(bytes);
	}

	private static readonly ConcurrentDictionary<(Type, string), object> ParseEnumCaches = new();
	public static T ParseEnum<T>(string value, T _default = default) where T : struct
	{
		if (string.IsNullOrEmpty(value))
			return _default;

		if (ParseEnumCaches.TryGetValue((typeof(T), value), out var cached))
			return (T)cached;
		if (Enum.TryParse<T>(value, true, out var parsed))
		{
			ParseEnumCaches[(typeof(T), value)] = parsed;
			return parsed;
		}
		ParseEnumCaches[(typeof(T), value)] = _default;
		
		return _default;
	}

	public static XmlNodeList GetChildren(this XmlNode node, string key)
	{
		return node.SelectNodes(key);
	}
	
	public static string EscapeURL(string url)
	{
		return WWW.EscapeURL(url).Replace("+", "%20");
	}
	

	public static XmlNode GetChild(this XmlNode node, string key)
	{
		return node.SelectSingleNode(key);
	}

	public static string GetChildText(this XmlNode node, string key, string _default = null)
	{
		node = node.SelectSingleNode($".//{key}");
		if (node == null)
			return _default;
		return node.InnerText.Replace("\\n", "\n");
	}

	public static string GetChildLocalizedText(this XmlNode node, string key, string _default = null)
	{
		var text = node.GetChildText($"{key}_{PlatformManager.GetLanguage()}");
		if (string.IsNullOrEmpty(text))
			return node.GetChildText(key, _default);
		return text;
	}

	public static bool GetChildBoolean(this XmlNode node, string key, bool _default = false)
	{
		node = node.SelectSingleNode($".//{key}");
		if (node == null)
			return _default;
		return bool.Parse(node.InnerText);
	}

	public static int GetChildInt(this XmlNode node, string key, int _default = 0)
	{
		node = node.SelectSingleNode($".//{key}");
		if (node == null)
			return _default;
		return int.Parse(node.InnerText);
	}

	public static long GetChildLong(this XmlNode node, string key, long _default = 0)
	{
		node = node.SelectSingleNode($".//{key}");
		if (node == null)
			return _default;
		return long.Parse(node.InnerText);
	}

	public static float GetChildFloat(this XmlNode node, string key, float _default = 0f)
	{
		node = node.SelectSingleNode($".//{key}");
		if (node == null)
			return _default;
		return float.Parse(node.InnerText);
	}

	public static string GetAttributeText(this XmlNode node, string key)
	{
		var att = node.Attributes[key];
		if (att == null)
			return null;
		return att.Value;
	}

	public static int GetAttributeInt(this XmlNode node, string key, int _default = 0)
	{
		var att = node.Attributes[key];
		if (att == null)
			return _default;
		return int.Parse(att.Value);
	}

	public static float GetAttributeFloat(this XmlNode node, string key, float _default = -0)
	{
		var att = node.Attributes[key];
		if (att == null)
			return _default;
		return float.Parse(att.Value);
	}

	public static long GetAttributeLong(this XmlNode node, string key, long _default = 0)
	{
		var att = node.Attributes[key];
		if (att == null)
			return _default;
		return long.Parse(att.Value);
	}

	public static int GetVersionInt(string version)
	{
		var parts = version.Split('.');
		int epoch = int.Parse(parts[0]);
		int major = int.Parse(parts[1]);
		int minor = int.Parse(parts[2]);
		return epoch * 1_000_000 + major * 1_000 + minor;
	}

	public static string GetVersionString(int versionInt)
	{
		int epoch = versionInt / 1_000_000;
		int major = (versionInt / 1_000) % 1_000;
		int minor = versionInt % 1_000;
		return $"{epoch}.{major:D3}.{minor:D3}";
	}
	
	public static float RoundDown(this float number, int decimalPlaces)
	{
		return Mathf.Floor(number * Mathf.Pow(10, decimalPlaces)) / Mathf.Pow(10, decimalPlaces);
	}

	public static string AttachSign(this int number)
	{
		return AttachSign((float)number);
	}
	
	public static string AttachSign(this float number)
	{
		return $"{(number > 0 ? "+" : "")}{number}";
	}

	public static string ToDateString(this Timestamp timestamp, bool appendUTCOffset = false) => timestamp.ToDateTime().ToDateString(appendUTCOffset);

	public static string ToDateString(this DateTime dateTime, bool appendUTCOffset = false)
	{
		var localTime = dateTime.ToLocalTime();
		var formattedTime = localTime.ToString("yyyy-MM-dd HH:mm:ss");

		if (appendUTCOffset)
		{
			var utcOffset = TimeZoneInfo.Local.GetUtcOffset(localTime).Hours;
			return $"{formattedTime} (UTC+{utcOffset})";
		}
		else
		{
			return formattedTime;
		}		
	}

	public static double ToSeconds(this Timestamp timestamp)
	{
		return timestamp?.ToDateTime().ToSeconds() ?? 0.0f;
	}

	public static double ToSeconds(this DateTime dt)
	{
		DateTime UnixEpoch = new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc);
		return (dt.Subtract(UnixEpoch)).TotalSeconds;
	}
	
	public static int ToOffsetSeconds(this Timestamp timestamp)
	{
		return timestamp?.ToDateTime().ToOffsetSeconds() ?? 0;
	}

	public static int ToOffsetSeconds(this DateTime dt)
	{
		DateTime OffsetEpoch = new DateTime(2020, 1, 1, 0, 0, 0, DateTimeKind.Utc);
		return (int)dt.Subtract(OffsetEpoch).TotalSeconds;
	}
	
	public static double OffsetSecondsToSeconds(int offsetTimeSeconds)
	{
		DateTime OffsetEpoch = new DateTime(2020, 1, 1, 0, 0, 0, DateTimeKind.Utc);
		return OffsetEpoch.AddSeconds(offsetTimeSeconds).ToSeconds();
	}

	public static DateTime FromSeconds(double timestamp)
	{
		DateTime dt = new DateTime(1970, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc);
		return dt.AddSeconds(timestamp);
	}

	public static DateTime FromMilliseconds(long timestamp)
	{
		DateTime dt = new DateTime(1970, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc);
		return dt.AddSeconds(timestamp / 1000.0);
	}

	private static double _time = DateTime.UtcNow.ToSeconds();
	public static double GetTime()
	{
		return TimeSystem.time;
	}

	private static int _offsetTime = DateTime.UtcNow.ToOffsetSeconds();
	public static int GetOffsetTime()
	{
		return TimeSystem.offsetTime;
	}

	public static void UpdateTime()
	{
		_time = DateTime.UtcNow.ToSeconds();
		_offsetTime = DateTime.UtcNow.ToOffsetSeconds();
	}

	public static Utf16ValueStringBuilder BeautyTimeSimplify(int seconds)
	{
		var sb = ZString.CreateStringBuilder();

		if (seconds <= 0)
		{
			sb.Append("00");
			return sb;
		}
		
		var timeSpan = new TimeSpan(0, 0, seconds);

		if (timeSpan.Days > 0)
		{
			sb.AppendFormat("{0:00}:{1:00}:{2:00}:{3:00}", timeSpan.Days, timeSpan.Hours, timeSpan.Minutes, timeSpan.Seconds);
			return sb;
		}

		if (timeSpan.Hours > 0)
		{
			sb.AppendFormat("{0:00}:{1:00}:{2:00}", timeSpan.Hours, timeSpan.Minutes, timeSpan.Seconds);
			return sb;
		}

		if (timeSpan.Minutes > 0)
		{
			sb.AppendFormat("{0:00}:{1:00}", timeSpan.Minutes, timeSpan.Seconds);
			return sb;
		}

		sb.AppendFormat("{0:00}", timeSpan.Seconds);
		return sb;
	}
	
	public static Utf16ValueStringBuilder BeautyTimeHHMMSS(int seconds, int count = int.MaxValue, bool showEndText = false, string endTextKey = null)
	{
		var sb = ZString.CreateStringBuilder();

		if (seconds <= 0)
		{
			if (showEndText)
			{
				sb.Append(string.IsNullOrEmpty(endTextKey) ? "TextTimeLeft_End".L() : endTextKey.L());
			}

			sb.AppendFormat("0{0}", "TimeAgo_Second".L());
			return sb;
		}

		if (count <= 0)
			count = int.MaxValue;

		if (seconds >= 86400)
		{
			--count;
			sb.AppendFormat("{0}{1} ", seconds / 86400, "Day".L());
			seconds %= 86400;
		}

		if (seconds >= 3600 && count > 0)
		{
			--count;
			sb.AppendFormat("{0}{1} ", seconds / 3600, "Hour".L());
			seconds %= 3600;
		}

		if (seconds >= 60 && count > 0)
		{
			--count;
			sb.AppendFormat("{0}{1} ", seconds / 60, "Minute".L());
			seconds %= 60;
		}

		if (seconds >= 0 && count > 0)
		{
			--count;
			sb.AppendFormat("{0}{1} ", seconds, "Second".L());
		}

		sb.Remove(sb.Length - 1, 1);
		return sb;
	}
	
	public static Color SetAlpha(this Graphic graphic, float alpha)
	{
		var color = graphic.color;
		color.a = alpha;
		graphic.color = color;
		return color;
	}
	
	public static Color ColorFrom(uint color)
	{
		if (color == 0)
			return Color.black;

		//
		return new Color32(
				(byte)((color >> 16) & 0xff),
				(byte)((color >> 8) & 0xff),
				(byte)(color & 0xff),
				(byte)((color >> 24) & 0xff));
	}
	public static Color ColorFrom(long color) { return ColorFrom((uint)color); }
	public static uint ToColor(this Color32 c)
	{
		return (uint)((c.r << 16)
		              | (c.g << 8)
		              | (c.b)
		              | (c.a << 24));

	}
	public static uint ToColor(this Color c)
	{
		return ((Color32)c).ToColor();

	}

	static void Swap<T>(ref T lhs, ref T rhs)
	{
		T temp;
		temp = lhs;
		lhs = rhs;
		rhs = temp;
	}

	public static string EncodeBase64(this string text)
	{
		return System.Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(text));
	}

	public static string EncodeBase64(this byte[] bytes)
	{
		return System.Convert.ToBase64String(bytes);
	}

	public static string EncodeBase64(this byte[] bytes, int offset, int length)
	{
		return System.Convert.ToBase64String(bytes, offset, length);
	}

	public static byte[] DecodeBase64(this string text)
	{
		return Convert.FromBase64String(text);
	}

	public static byte[] DecodeBase64(this string text, int offset, int length)
	{
		return Convert.FromBase64CharArray(text.ToCharArray(), offset, length);
	}

	public static string ToMoneyNum(this int value)
	{
		return value.ToString("#,##0");
	}

	public static string ToMoneyNum(this long value)
	{
		return value.ToString("#,##0");
	}

	public static string ToComma(this int value)
	{
		return string.Format("{0:n0}", value);
	}

	public static string ColorToHex(Color32 color)
	{
		string hex = $"{color.r:X2}{color.g:X2}{color.b:X2}{color.a:X2}";
		return hex;
	}

	public static Color HexToColor(string hex)
	{
		hex = hex.Replace("#", "");
		byte r = byte.Parse(hex.Substring(0, 2), System.Globalization.NumberStyles.HexNumber);
		byte g = byte.Parse(hex.Substring(2, 2), System.Globalization.NumberStyles.HexNumber);
		byte b = byte.Parse(hex.Substring(4, 2), System.Globalization.NumberStyles.HexNumber);
		byte a = 255;
		if (hex.Length > 6)
			a = byte.Parse(hex.Substring(6, 2), System.Globalization.NumberStyles.HexNumber);

		return new Color32(r, g, b, a);
	}
	
	private static bool? _isDebugMode;
	public static bool isDebugMode
	{
		get
		{
			if (_isDebugMode != null)
				return _isDebugMode.Value;
#if UNITY_EDITOR || DEVELOPMENT_BUILD
			_isDebugMode = PlayerPrefs.GetInt("__HELLO_DEV_WORLD__", 1) == 1;
			return _isDebugMode.Value;
#else
			_isDebugMode = PlayerPrefs.GetInt("__HELLO_DEV_WORLD__", 0) == 1;
			return _isDebugMode.Value;
#endif
		}
		set
		{
			_isDebugMode = value;
			PlayerPrefs.SetInt("__HELLO_DEV_WORLD__", value ? 1 : 0);
			PlayerPrefs.Save();
		}
	}

	public static string GetPatchResourcesPath()
	{

		#if UNITY_STANDALONE_WIN
		return Path.Combine(Application.dataPath, "../PatchResources/").Replace('\\', '/');
		#endif

#if !UNITY_EDITOR && UNITY_STANDALONE_OSX
		return Path.Combine(Application.dataPath, "../../PatchResources");
#endif

		return Path.Combine(Application.dataPath, "PatchResources");
	}

	public static string GetOS()
	{
		#if UNITY_ANDROID
		return "android";
		#elif UNITY_IPHONE
		return "ios";
		#else
		return "unknown";
		#endif
	}

	public static IEnumerable<(Component, TAttribute)> GetComponentsViaAttribute<TAttribute>(this GameObject gameObject) where TAttribute : Attribute
	{
		if (gameObject == null)
			yield break;

		foreach (var component in gameObject.GetComponentsInChildren<Component>(true))
		{
			if (component == null) 
				continue;

			var type = component.GetType();
			foreach (var attribute in type.GetCustomAttributes<TAttribute>())
			{
				yield return (component, attribute);
			}
		}
	}
	
	public static GameObject MakeGameObject(string name, Transform parent = null)
	{
		if (string.IsNullOrEmpty(name))
			return null;

		var gameObject = new GameObject(name);

		if (parent != null)
		{
			gameObject.transform.SetParent(parent);
		}

		return gameObject;
	}

	// Selectors
	public static GameObject Search(this GameObject target, string name)
	{
		if (target.name == name) return target;

		for (int i = 0; i < target.transform.childCount; ++i)
		{
			var result = Search(target.transform.GetChild(i).gameObject, name);

			if (result != null) return result;
		}

		return null;
	}

	private static T Search<T>(this GameObject target, string name) where T : Component
	{
		var obj = target.Search(name);
		return obj != null ? obj.GetComponent<T>() : null;
	}

	private static T Search<T>(this Component target, string name) where T : Component
	{
		var obj = target.Search(name);
		return obj != null ? obj.GetComponent<T>() : null;
	}

	private static GameObject Search(this Component target, string name)
	{
		return target.gameObject.Search(name);
	}

	public static GameObject Get(this GameObject target, string name)
	{
		return target.Search(name);
	}

	public static GameObject Get(this Component target, string name)
	{
		return target.Search(name);
	}

	public static T Get<T>(this GameObject target, string name = null) where T : Component
	{
		if (name != null)
			return target.Search<T>(name);
		return target.GetComponent<T>();
	}

	public static T Get<T>(this Component target, string name = null) where T : Component
	{
		if (name != null)
			return target.Search<T>(name);
		return target.GetComponent<T>();
	}

	public static T GetOrAdd<T>(this GameObject target) where T : Component
	{
		var c = target.GetComponent<T>();
		if (c)
			return c;

		return target.AddComponent<T>();
	}

	public static T GetOrAdd<T>(this Component target) where T : Component
	{
		return target.TryGetComponent<T>(out var component) ? 
			component : 
			target.gameObject.AddComponent<T>();
	}
	
	public static int SetLayer(this GameObject target, int layer, bool includeChildren = true)
	{
		target.layer = layer;
		
		if (includeChildren)
		{
			for (var i = 0; i < target.transform.childCount; ++i)
				target.transform.GetChild(i).gameObject.SetLayer(layer);
		}
		
		return layer;
	}
	
	public static TweenerCore<Vector2, Vector2, VectorOptions> DOMoveXY(
		this Transform target,
		Vector2 endValue,
		float duration,
		bool snapping = false)
	{
		var t = DOTween.To(() => (Vector2)target.position, x => target.position = new Vector3(x.x, x.y, target.position.z), endValue, duration);
		t.SetOptions(snapping).SetTarget(target);
		return t;
	}

	public static float ScalarCubicInterpolate(
			float y0, float y1,
			float y2, float y3,
			float mu)
	{
		float a0, a1, a2, a3;
		float mu2;

		mu2 = mu * mu;
		a0 = -0.5f * y0 + 1.5f * y1 - 1.5f * y2 + 0.5f * y3;
		a1 = y0 - 2.5f * y1 + 2 * y2 - 0.5f * y3;
		a2 = -0.5f * y0 + 0.5f * y2;
		a3 = y1;

		return (a0 * mu * mu2 + a1 * mu2 + a2 * mu + a3);
	}

	public static Vector2 Vector2CubicInterpolate(
			Vector2 y0, Vector2 y1,
			Vector2 y2, Vector2 y3,
			float mu)
	{
		Vector2 a0, a1, a2, a3;
		float mu2;

		mu2 = mu * mu;
		a0 = -0.5f * y0 + 1.5f * y1 - 1.5f * y2 + 0.5f * y3;
		a1 = y0 - 2.5f * y1 + 2 * y2 - 0.5f * y3;
		a2 = -0.5f * y0 + 0.5f * y2;
		a3 = y1;

		return (a0 * mu * mu2 + a1 * mu2 + a2 * mu + a3);
	}

	public static Vector3 Vector3CubicInterpolate(
			Vector3 y0, Vector3 y1,
			Vector3 y2, Vector3 y3,
			float mu)
	{
		Vector3 a0, a1, a2, a3;
		float mu2;

		mu2 = mu * mu;
		a0 = -0.5f * y0 + 1.5f * y1 - 1.5f * y2 + 0.5f * y3;
		a1 = y0 - 2.5f * y1 + 2 * y2 - 0.5f * y3;
		a2 = -0.5f * y0 + 0.5f * y2;
		a3 = y1;

		return (a0 * mu * mu2 + a1 * mu2 + a2 * mu + a3);
	}

	/*
   Tension: 1 is high, 0 normal, -1 is low
   Bias: 0 is even,
         positive is towards first segment,
         negative towards the other
*/
	public static Vector3 HermiteInterpolate(
			Vector3 y0, Vector3 y1,
			Vector3 y2, Vector3 y3,
			float mu,
			float tension,
			float bias)
	{
		Vector3 m0, m1;
		float a0, a1, a2, a3, mu2, mu3;

		mu2 = mu * mu;
		mu3 = mu2 * mu;
		m0 = (y1 - y0) * (1 + bias) * (1 - tension) / 2;
		m0 += (y2 - y1) * (1 - bias) * (1 - tension) / 2;
		m1 = (y2 - y1) * (1 + bias) * (1 - tension) / 2;
		m1 += (y3 - y2) * (1 - bias) * (1 - tension) / 2;
		a0 = 2 * mu3 - 3 * mu2 + 1;
		a1 = mu3 - 2 * mu2 + mu;
		a2 = mu3 - mu2;
		a3 = -2 * mu3 + 3 * mu2;

		return (a0 * y1 + a1 * m0 + a2 * m1 + a3 * y2);
	}
	
	public delegate void RunCallback();
	public static Coroutine Run(this MonoBehaviour behaviour, RunCallback callback, float time = 0f, bool realtime = false)
	{
		if (!behaviour.gameObject.activeSelf)
		{
			callback?.Invoke();
			return null;
		}
		
		return behaviour.StartCoroutine(RunCoroutine(callback, time, realtime));
	}

	public static Coroutine RunRealTime(this MonoBehaviour behaviour, RunCallback callback, float time = 0f)
	{
		return behaviour.StartCoroutine(RunCoroutine(callback, time, true));
	}

	private static IEnumerator RunCoroutine(RunCallback callback, float time, bool realtime)
	{
		if (realtime)
			yield return GetWaitForSecondsRealtime(time);
		else
			yield return GetWaitForSeconds(time);
		callback?.Invoke();
	}

	public static Coroutine RunAfterFrame(this MonoBehaviour behaviour, RunCallback callback, int frames = 1)
	{
		if (behaviour && behaviour.isActiveAndEnabled)
			return behaviour.StartCoroutine(RunAfterFrameCoroutine(callback, frames));
		return null;
	}

	private static IEnumerator RunAfterFrameCoroutine(RunCallback callback, int frames)
	{
		for (int i = 0; i < frames; ++i)
			yield return null;
		callback();
	}
	
	//key: ms
	private static readonly Dictionary<uint, WaitForSeconds> _waitForSecondsMap = new();
	private static readonly Dictionary<uint, WaitForSecondsRealtime> _waitForSecondsRealtimeMap = new();
	public static WaitForSeconds GetWaitForSeconds(float seconds)
	{
		var ms = (uint)(seconds * 1000);
		if (!_waitForSecondsMap.TryGetValue(ms, out var ws))
			ws = _waitForSecondsMap[ms] = new (seconds);

		return ws;
	}
	
	public static WaitForSeconds GetWaitForSeconds(uint ms)
	{
		if (!_waitForSecondsMap.TryGetValue(ms, out var ws))
			ws = _waitForSecondsMap[ms] = new (ms / 1000.0f);

		return ws;
	}	
	
	public static WaitForSecondsRealtime GetWaitForSecondsRealtime(float seconds)
	{
		var ms = (uint)(seconds * 1000);
		if (!_waitForSecondsRealtimeMap.TryGetValue(ms, out var ws))
			ws = _waitForSecondsRealtimeMap[ms] = new (seconds);

		return ws;
	}
	
	public static WaitForSecondsRealtime GetWaitForSecondsRealtime(uint ms)
	{
		if (!_waitForSecondsRealtimeMap.TryGetValue(ms, out var ws))
			ws = _waitForSecondsRealtimeMap[ms] = new (ms / 1000.0f);

		return ws;
	}

	public static void PlayAndThen(this MonoBehaviour behaviour, Animator animator, string name, RunCallback callback)
	{
		behaviour.StartCoroutine(PlayAndThen_Coroutine(name, animator, callback));
	}

	private static IEnumerator PlayAndThen_Coroutine(string name, Animator animator, RunCallback callback)
	{
		animator.Play(name, 0, 0f);
		yield return null;
		yield return null;
		while (animator.GetCurrentAnimatorStateInfo(0).normalizedTime < 0.99f)
		{
			yield return null;
		}

		if (callback != null)
			callback();
	}

	public static T GetOr<T>(T obj, T _default)
	{
		return (obj != null) ? obj : _default;
	}

	public static byte[] ConvertHexStringToByteArray(string hexString)
	{
		if (hexString.Length % 2 != 0)
		{
			throw new ArgumentException(String.Format(CultureInfo.InvariantCulture, "The binary key cannot have an odd number of digits: {0}", hexString));
		}

		byte[] HexAsBytes = new byte[hexString.Length / 2];
		for (int index = 0; index < HexAsBytes.Length; index++)
		{
			string byteValue = hexString.Substring(index * 2, 2);
			HexAsBytes[index] = byte.Parse(byteValue, NumberStyles.HexNumber, CultureInfo.InvariantCulture);
		}

		return HexAsBytes;
	}

	public static string SFormat(this string key, params object[] args)
	{
		return string.Format(key, args);
	}

	//
	public static string FirstLetterToUpper(this string str)
	{
		if (str == null)
			return null;

		if (str.Length > 1)
			return char.ToUpper(str[0]) + str.Substring(1).ToLower();

		return str.ToUpper();
	}
	
	public static T Clone<T>(this Component target, bool active = true) where T : Component
	{
		var newOne = Object.Instantiate(target.gameObject, target.transform.parent, false);
		newOne.SetActive(active);
		return newOne.GetComponent<T>();
	}

	//
	public static GameObject Clone(this GameObject target, Transform parent = null, bool active = true)
	{
		var newOne = Object.Instantiate(target, parent ?? target.transform.parent, false);
		newOne.SetActive(active);
		return newOne;
	}

	//
	public static GameObject PoolClone(this GameObject target, bool active = true)
	{
		var newOne = ObjectPoolController.Instantiate(target);
		newOne.transform.SetParent(target.transform.parent, false);
		newOne.SetActive(active);
		return newOne;
	}

	//
	public static void DestroyAllChildren(this GameObject target, bool onlyActive = true)
	{
		for (int i = 0; i < target.transform.childCount; ++i)
		{
			var obj = target.transform.GetChild(i).gameObject;
			if (!onlyActive || obj.activeSelf)
				GameObject.Destroy(obj);
		}
	}
	
	public static IEnumerable<(GameObject child, int idx)> GetChildren(this Transform transform, bool onlyActive = true)
	{
		for (int i = 0, j = 0; i < transform.childCount; i++)
		{
			var go = transform.GetChild(i).gameObject;
			if (onlyActive && !go.activeSelf)
				continue;

			yield return (go.gameObject, j++);
		}
	}
	
	public static IEnumerable<(GameObject go, int index, T element)> GetRecycleChildren<T>(this GameObject cell, IEnumerable<T> enumerable, Func<T, bool> predicate, GameObject emptyCell = null, bool useTemplateCell = false)
	{
		var list = ListPool<T>.Get();
		list.Clear();
		foreach (var e in enumerable)
		{
			if (predicate(e))
				list.Add(e);
		}
		
		foreach (var (go, index) in cell.GetRecycleChildren(list.Count, emptyCell, useTemplateCell))
		{
			yield return (go, index, list[index]);
		}
		ListPool<T>.Release(list);
	}
	
	public static IEnumerable<(GameObject go, int index, T element)> GetRecycleChildren<T>(this GameObject cell, IEnumerable<T> enumerable, GameObject emptyCell = null, bool useTemplateCell = false)
	{
		var list = ListPool<T>.Get();
		list.Clear();
		list.AddRange(enumerable);
		foreach (var (go, index) in cell.GetRecycleChildren(list.Count, emptyCell, useTemplateCell))
		{
			yield return (go, index, list[index]);
		}
		ListPool<T>.Release(list);
	}
	
	public static IEnumerable<(GameObject, int)> GetRecycleChildren(this GameObject cell, int count, GameObject emptyCell = null, bool useTemplateCell = false)
	{
		var cellTransform = cell.transform;
		var parent = cellTransform.parent;

		var ignoreChildCount = useTemplateCell ? 0 : 1;
		using var toIgnoreList = PooledList<ILayoutIgnorer>.Get();
		foreach (Transform child in parent)
		{
			toIgnoreList.Clear();
			child.GetComponents(toIgnoreList);
			foreach (var layoutIgnorer in toIgnoreList)
			{
				if (layoutIgnorer.ignoreLayout)
				{
					ignoreChildCount++;
					break;
				}
			}
		}

		while (parent.childCount < count + ignoreChildCount)
		{
#if UNITY_EDITOR
			DuplicateGameObject(cell);
#else
            cell.Clone();
#endif
		}

		cell.SetActive(false);

		var i = ignoreChildCount;
		for (; i < count + ignoreChildCount; i++)
		{
			var go = parent.GetChild(i).gameObject;

			go.SetActive(true);
			yield return (go, i - ignoreChildCount);
		}
		
		for (; i < parent.childCount; i++)
		{
			var go = parent.GetChild(i).gameObject;
			go.SetActive(false);
		}

		if (emptyCell)
		{
			i = ignoreChildCount;
			var hasActivatedChild = false;
			for (; i < parent.childCount; i++)
			{
				if (parent.GetChild(i).gameObject.activeSelf)
				{
					hasActivatedChild = true;
					break;
				}
			}
			emptyCell.SetActive(!hasActivatedChild);
		}
		
	}

	//
	public static string ColorText(this string text, uint color)
	{
		return "<color=#{0}>{1}</color>".SFormat(ColorToHex(ColorFrom(color)), text);
	}
	
	public static string ColorText(this string text, Color color)
	{
		return $"<color=#{ColorToHex(color)}>{text}</color>";
	}

	//
	public static void DestroyAllChildren(this Transform tr, bool onlyActive = false)
	{
		for (int i = tr.childCount - 1; i >= 0; --i)
		{
			var child = tr.GetChild(i).gameObject;
			if (onlyActive && !child.activeSelf)
				continue;

			if (Application.isPlaying)
				GameObject.Destroy(child);
			else
				GameObject.DestroyImmediate(child);
		}
	}

	//
	public static void PoolDestroyAllChildren(this Transform tr, bool onlyActive = false)
	{
		for (int i = tr.childCount - 1; i >= 0; --i)
		{
			var child = tr.GetChild(i).gameObject;
			if (onlyActive && !child.activeSelf)
				continue;

			ObjectPoolController.Destroy(child);
		}
	}

	//
	public static GameObject DOMoveCell(this GameObject cell, GameObject target, float duration = 0.5f, TweenCallback onComplete = null,
			Transform parent = null, bool reverse = false)
	{
		if (!cell || !target)
			return null;

		var obj = cell.Clone();
		var group = obj.Get<CanvasGroup>();

		//
		obj.transform.SetParent(parent ? parent : target.transform, true);

		//
		if (!reverse)
			group.DOFade(0f, duration).ChangeStartValue(1f);
		else
			group.DOFade(1f, duration).ChangeStartValue(0f);
		group.interactable = false;
		group.blocksRaycasts = false;

		//
		if (!reverse)
			obj.transform.DOScale(Vector3.zero, duration).ChangeStartValue(Vector3.one);
		else
			obj.transform.DOScale(Vector3.one, duration).ChangeStartValue(Vector3.zero);
		obj.transform.DOMove(target.transform.position, duration).OnComplete(delegate
		{
			GameObject.Destroy(obj);
			if (onComplete != null)
				onComplete.Invoke();
		});

		return obj;
	}
	
	public static void SetDouble(string key, double value)
	{
		PlayerPrefs.SetString(key, DoubleToString(value));
	}
	public static double GetDouble(string key, double defaultValue)
	{
		string defaultVal = DoubleToString(defaultValue);
		return StringToDouble(PlayerPrefs.GetString(key, defaultVal));
	}
	public static double GetDouble(string key)
	{
		return GetDouble(key, 0d);
	}

	private static string DoubleToString(double target)
	{
		return target.ToString("R");
	}
	private static double StringToDouble(string target)
	{
		if (string.IsNullOrEmpty(target))
			return 0d;

		return double.Parse(target);
	}

	public static T GetSafe<T>(this IList<T> data, int id, T _default = default)
	{
		if (id >= 0 && id < data.Count)
			return data[id];
		return _default;
	}

	public static T GetSafe<T>(this List<T> data, int id, T _default = default)
	{
		if (id >= 0 && id < data.Count)
			return data[id];
		return _default;
	}

	public static T GetSafe<T>(this T[] data, int id, T _default = default)
	{
		if (id >= 0 && id < data.Length)
			return data[id];
		return _default;
	}
	
	public static bool GetSafe<T>(this T[] data, int idx, out T result, T _default = default)
	{
		if (idx >= 0 && idx < data.Length)
		{
			result = data[idx];
			return true;
		}

		result = _default;
		return false;
	}
	
	public static T GetSafeLast<T>(this List<T> data, T _default = default)
	{
		return data is { Count: > 0 } ? data[^1] : _default;
	}
	
	public static string ToTitleCase(this string str)
	{
		if (str == null)
			return null;

		if (str.Length > 1)
			return char.ToUpper(str[0]) + str.Substring(1);

		return str.ToUpper();
	}
	
	public static List<T> GetComponentsInChildrenWithSkip<T, TSkip>(this Component component, GameObject root)
		where T : Component
		where TSkip : Component
	{
		var results = new List<T>();

		// 현재 오브젝트에 T 컴포넌트가 있으면 추가
		results.AddRange(component.GetComponents<T>());

		// 만약 현재 오브젝트에 TSkip 컴포넌트가 있다면 하위 탐색을 중단
		if (component.TryGetComponent<TSkip>(out _) && component.gameObject != root)
		{
			return results;
		}

		// 하위 오브젝트들을 순회하며 재귀적으로 탐색
		foreach (Transform child in component.transform)
		{
			results.AddRange(child.GetComponentsInChildrenWithSkip<T, TSkip>(root));
		}

		return results;
	}
	
    public static string Encrypt(string raw)
    {
        using (var aesAlg = Aes.Create())
        {
            aesAlg.KeySize = 256;
            aesAlg.Key = Encoding.ASCII.GetBytes("Cv7WBXAem53GvRWWewqcvwsAx4wLsx5n");
            var iv = new byte[16];
            var rng = new RNGCryptoServiceProvider();
            rng.GetBytes(iv);
            aesAlg.IV = iv;

            var encryptor = aesAlg.CreateEncryptor(aesAlg.Key, aesAlg.IV);

            byte[] encrypted;
            using (MemoryStream msEncrypt = new MemoryStream())
            {
                using (CryptoStream csEncrypt = new CryptoStream(msEncrypt, encryptor, CryptoStreamMode.Write))
                {
                    using (StreamWriter swEncrypt = new StreamWriter(csEncrypt))
                    {
                        swEncrypt.Write(raw);
                    }
                    encrypted = msEncrypt.ToArray();
                }
            }

            var result = new byte[16 + encrypted.Length];
            iv.CopyTo(result, 0);
            encrypted.CopyTo(result, 16);

            return result.EncodeBase64();
        }
    }

    public static string Decrypt(string encrypted)
    {
        using (var aesAlg = Aes.Create())
        {
            aesAlg.KeySize = 256;
            aesAlg.Key = Encoding.ASCII.GetBytes("Cv7WBXAem53GvRWWewqcvwsAx4wLsx5n");
            var iv = new byte[16];
            var enc = encrypted.DecodeBase64();
            Array.Copy(enc, 0, iv, 0, 16);
            aesAlg.IV = iv;

            var decryptor = aesAlg.CreateDecryptor(aesAlg.Key, aesAlg.IV);

            using (var msDecrypt = new MemoryStream(enc, 16, enc.Length - 16))
            {
                using (var csDecrypt = new CryptoStream(msDecrypt, decryptor, CryptoStreamMode.Read))
                {
                    using (var srDecrypt = new StreamReader(csDecrypt))
                    {
                        return srDecrypt.ReadToEnd();
                    }
                }
            }
        }
    }

    private const byte FastEncryptKey = 0xA7;
	
    public static string FastEncrypt(string raw)
    {
	    using (var memoryStream = new MemoryStream())
	    {
		    using (var compressor = new ZlibStream(memoryStream, CompressionMode.Compress, Ionic.Zlib.CompressionLevel.BestCompression))
		    {
			    using (var stream = new StreamWriter(compressor))
			    {
				    stream.Write(raw);
			    }
		    }
		    
		    var buffer = memoryStream.ToArray();
		    for (var i = 0; i < buffer.Length; ++i)
			    buffer[i] ^= FastEncryptKey;
		    return buffer.EncodeBase64(0, buffer.Length);
	    }
    }

    public static string FastDecrypt(string encrypted, int offset = 0)
    {
	    var enc = encrypted.DecodeBase64(offset, encrypted.Length - offset);
	    for (var i = 0; i < enc.Length; ++i)
		    enc[i] ^= FastEncryptKey;
	    
	    using (var memoryStream = new MemoryStream(enc))
	    {
		    using (var decompressor = new ZlibStream(memoryStream, CompressionMode.Decompress, Ionic.Zlib.CompressionLevel.BestCompression))
		    {
			    using (var stream = new StreamReader(decompressor, false))
			    {
				    return stream.ReadToEnd();
			    }
		    }
	    }
    }

	public static void NekoEncrypt(Stream input, Stream output, byte key = 0x95)
	{
		output.WriteByte((byte)'N');
		output.WriteByte((byte)'E');
		output.WriteByte((byte)'K');
		output.WriteByte((byte)'O');

		byte[] buffer = new byte[4096];
		int read;
		while ((read = input.Read(buffer, 0, buffer.Length)) > 0)
		{
			for (int i = 0; i < read; i++)
				buffer[i] ^= key;
			output.Write(buffer, 0, read);
		}
	}

	public static void NekoDecrypt(Stream input, Stream output, byte key = 0x95, bool onlyEncrypt = false)
	{
		byte[] buffer = new byte[4096];
		int read;

		//
		read = input.Read(buffer, 0, 4);
		if (buffer[0] == (byte)'N' && buffer[1] == (byte)'E' && buffer[2] == (byte)'K' && buffer[3] == (byte)'O')
		{
			while ((read = input.Read(buffer, 0, buffer.Length)) > 0)
			{
				for (int i = 0; i < read; i++)
					buffer[i] ^= key;
				output.Write(buffer, 0, read);
			}
		}
		else
		{
			if (onlyEncrypt)
				return;

			//
			output.Write(buffer, 0, read);
			while ((read = input.Read(buffer, 0, buffer.Length)) > 0)
				output.Write(buffer, 0, read);
		}
	}

	public static List<T> FindObjectsOfTypeAll<T>()
	{
		List<T> results = new List<T>();
		for (int i = 0; i < SceneManager.sceneCount; i++)
		{
			var s = SceneManager.GetSceneAt(i);
			if (s.isLoaded)
			{
				var allGameObjects = s.GetRootGameObjects();
				for (int j = 0; j < allGameObjects.Length; j++)
				{
					var go = allGameObjects[j];
					results.AddRange(go.GetComponentsInChildren<T>(true));
				}
			}
		}
		return results;
	}
	
	public static List<T> FindObjectsOfTypeAndLayerAll<T>(int layer)
	{
		List<T> results = new List<T>();
		for (int i = 0; i < SceneManager.sceneCount; i++)
		{
			var s = SceneManager.GetSceneAt(i);
			if (s.isLoaded)
			{
				var allGameObjects = s.GetRootGameObjects();
				for (int j = 0; j < allGameObjects.Length; j++)
				{
					var go = allGameObjects[j];
					FindInChild(go, layer);
				}
			}
		}
		return results;
		
		void FindInChild(GameObject obj, int layer)
		{
			if (obj.layer == layer && obj.activeInHierarchy && obj.GetComponent<T>() != null)
				results.Add(obj.GetComponent<T>());

			foreach (Transform child in obj.transform)
				FindInChild(child.gameObject, layer);
		}
	}

	public static string ToUnitString(this int target, int limit = int.MaxValue, int decimalPlace = 1)
	{
		return ((long) target).ToUnitString(limit, decimalPlace);
	}
	
	public static string ToUnitString(this float target, int limit = int.MaxValue, int decimalPlace = 1)
	{
		if (Mathf.Abs(target) > long.MaxValue)
			return new BigInteger(target).ToUnitString(limit, decimalPlace);
		return ((long) target).ToUnitString(limit, decimalPlace);
	}

	public static string ToUnitString(this double target, int limit = int.MaxValue, int decimalPlace = 1)
	{
		return ((long)target).ToUnitString(limit, decimalPlace);
	}

	public static string ToUnitString(this long target, int limit = int.MaxValue, int decimalPlace = 1)
	{
		var x = ((ulong) Math.Abs(target)).ToUnitString(limit, decimalPlace);
		if (target >= 0)
			return x;
		return  $"-{x}";
	}
	
	public static string ToUnitString(this BigInteger target, int limit = int.MaxValue, int decimalPlace = 1)
	{
		var x = BigInteger.Abs(target)._ToUnitString(limit, decimalPlace);
		if (target >= 0)
			return x;
		return  $"-{x}";
	}

	public static string ToPowerString(this long power)
	{
		return power.ToUnitString(decimalPlace: 2);
	}
	
	public static string ToLevelString(this int level)
	{
		return (level - 1).ToUnitString();
	}
	
	private static readonly Dictionary<int, char> _unitSymbols = new Dictionary<int, char>
	{
		{1, 'K'},
		{2, 'M'},
		{3, 'B'},
		{4, 'T'},
		{5, 'Q'},
	};

	public static string ToShortUnitString(this ulong value, int digitUpperLimit = int.MaxValue, int decimalPlace = 1)
	{
		if (value == 0)
			return "0";

		for (var i = Math.Min(_unitSymbols.Count, digitUpperLimit) - 1; i >= 0; i--)
		{
			var digit = (i + 1) * 3;

			if (Divide(digit, out var str))
				return str;
		}
		
		return value.ToString("#,##0");

		bool Divide(int digit, out string str)
		{
			str = "";

			// 10^digit (정수 연산)
			ulong divisor = 1;
			for (var k = 0; k < digit; k++) divisor *= 10;

			if (value < divisor)
				return false;

			var result = value / divisor;
			var remainder = value % divisor;

			// 소수 자릿수 계산(정수 연산): (remainder * 10^decimalPlace) / divisor
			ulong scale = 1;
			for (var k = 0; k < decimalPlace; k++) scale *= 10;

			var customDecimal = decimalPlace > 0 ? (remainder * scale) / divisor : 0UL;

			using var sb = ZString.CreateStringBuilder();
			sb.AppendFormat("{0:#,##0}", result);

			if (decimalPlace > 0)
			{
				sb.Append('.');

				var tmp = customDecimal;
				var digits = 1;
				while (tmp >= 10)
				{
					tmp /= 10;
					digits++;
				}

				for (var p = digits; p < decimalPlace; p++)
					sb.Append('0');

				sb.Append(customDecimal);
			}

			sb.Append(_unitSymbols[digit / 3]);
			str = sb.ToString();
			return true;
		}
	}
	
	public static string ToShortUnitString(this BigInteger value, int digitUpperLimit = int.MaxValue, int decimalPlace = 1)
	{
		if (value == 0)
			return "0";
		
		for (var i = Math.Min(_unitSymbols.Count - 1, digitUpperLimit); i >= 0; i--)
		{
			var digit = (i + 1) * 3;
			
			if (Divide(digit, out var str))
				return str;
		}
		
		return value.ToString("#,##0");

		bool Divide(int digit, out string str)
		{
			str = "";

			// 10^digit (정수 연산)
			ulong divisor = 1;
			for (var k = 0; k < digit; k++) divisor *= 10;

			if (value < divisor)
				return false;

			var result = value / divisor;
			var remainder = value % divisor;

			// 소수 자릿수 계산(정수 연산): (remainder * 10^decimalPlace) / divisor
			ulong scale = 1;
			for (var k = 0; k < decimalPlace; k++) scale *= 10;

			var customDecimal = decimalPlace > 0 ? (remainder * scale) / divisor : 0UL;

			using var sb = ZString.CreateStringBuilder();
			sb.AppendFormat("{0:#,##0}", result);

			if (decimalPlace > 0)
			{
				sb.Append('.');

				var tmp = customDecimal;
				var digits = 1;
				while (tmp >= 10)
				{
					tmp /= 10;
					digits++;
				}

				for (var p = digits; p < decimalPlace; p++)
					sb.Append('0');

				sb.Append(customDecimal);
			}

			sb.Append(_unitSymbols[digit / 3]);
			str = sb.ToString();
			return true;
		}
	}
	
	public static string ToUnitString(this ulong target, int limit = int.MaxValue, int decimalPlace = 1)
	{
		return ToShortUnitString(target, limit, decimalPlace);
	}
	
	public static string _ToUnitString(this BigInteger target, int limit = int.MaxValue, int decimalPlace = 1)
	{
		return ToShortUnitString(target, limit, decimalPlace);
	}

	private static int prevEventSystemID = -1;
	private static PointerEventData pointerEventDataForOverlappedUI;
	private static List<RaycastResult> raycastResultsForOverlappedUI;
	public static bool HasPointerOverUIObject(Vector2? screenPosition = null) {
		return GetOverlappedUIResults().Count > 0;
	}

	public static List<RaycastResult> GetOverlappedUIResults(Vector2? screenPosition = null)
	{
		var eventSystemID = EventSystem.current.GetInstanceID();
		if (pointerEventDataForOverlappedUI == null || prevEventSystemID != eventSystemID)
		{
			prevEventSystemID = eventSystemID;
			pointerEventDataForOverlappedUI = new PointerEventData(EventSystem.current);
		}

		pointerEventDataForOverlappedUI.position = screenPosition ?? Input.mousePosition;
		
		if (raycastResultsForOverlappedUI == null)
			raycastResultsForOverlappedUI = new List<RaycastResult>();
		else 
			raycastResultsForOverlappedUI.Clear();
		EventSystem.current.RaycastAll(pointerEventDataForOverlappedUI, raycastResultsForOverlappedUI);
		return raycastResultsForOverlappedUI;
	}

	public static bool IncludePoint(this Bounds bounds, Vector3 pos)
	{
		return bounds.min.x <= pos.x && bounds.max.x >= pos.x &&
		       bounds.min.y <= pos.y && bounds.max.y >= pos.y &&
		       bounds.min.z <= pos.z && bounds.max.z >= pos.z;
	}
	
	public static bool IncludePoint2D(this Bounds bounds, Vector3 pos)
	{
		return bounds.min.x <= pos.x && bounds.max.x >= pos.x &&
		       bounds.min.y <= pos.y && bounds.max.y >= pos.y;
	}
	
	public static bool Include(this Bounds bounds, Bounds target)
	{
		return bounds.min.x <= target.min.x && bounds.max.x >= target.max.x &&
		       bounds.min.y <= target.min.y && bounds.max.y >= target.max.y &&
		       bounds.min.z <= target.min.z && bounds.max.z >= target.max.z;
	}
	
	public static bool Include2D(this Bounds bounds, Bounds target)
	{
		return bounds.min.x <= target.min.x && bounds.max.x >= target.max.x &&
		       bounds.min.y <= target.min.y && bounds.max.y >= target.max.y;
	}

	public static Bounds GetWorldBoundOrthographic(this Camera camera)
	{
		var min = camera.ViewportToWorldPoint(new Vector3(0, 0, camera.transform.position.z));
		var max = camera.ViewportToWorldPoint(new Vector3(1, 1, camera.transform.position.z));
		var bounds = new Bounds();
		bounds.SetMinMax(min, max);
		return bounds;
	}

	public static Vector2 PickRandomPosInCameraBound2D(this Camera camera)
	{
		var x = Random.Range(0f, 1f);
		var y = Random.Range(0f, 1f);

		return camera.ViewportToWorldPoint(new Vector3(x, y, camera.transform.position.z));
	}
	
	public static float NormalizeStep(this int[] steps, int value)
	{
		var last = steps.Length - 1;
		if (value <= steps[0]) return 0f;
		if (value >= steps[last]) return 1f;

		var i = Array.BinarySearch(steps, value);
		if (i >= 0) 
			return i / (float)last; // 경계에 정확히 위치

		i = ~i - 1; // value가 속한 구간의 왼쪽 인덱스
		var t = (value - steps[i]) / (float)(steps[i + 1] - steps[i]);
		return (i + t) / last;
	}

	public static bool TryGetValue<T>(this IEnumerable<T> enumerable, Func<T, bool> predicate, out T result, T _default = default)
	{
		foreach (var item in enumerable)
		{
			if (predicate(item))
			{
				result = item;
				return true;
			}
		}

		result = _default;
		return false;
	}

	public static T PickOne<T>(this IEnumerable<T> items, Func<T, bool> predicate = null, T _default = default)
	{
		using var _ = ListPool<T>.Get(out var list);
		
		foreach (var item in items)
		{
			if (predicate?.Invoke(item) != false)
				list.Add(item);
		}
		
		var count = list.Count;

		if (count == 0)
			return _default;

		var idx = Random.Range(0, count);
		return list[idx];
	}

	public static IList<T> Shuffle<T>(this IList<T> list)
	{
		int n = list.Count;
		while (n > 1)
		{
			n--;
			var k = Random.Range(0, n + 1);
			(list[k], list[n]) = (list[n], list[k]);
		}

		return list;
	}

	public static IList<T> Shuffle<T>(this IList<T> list, System.Random random)
	{
		int n = list.Count;
		while (n > 1)
		{
			n--;
			var k = random.Next(n + 1);
			(list[k], list[n]) = (list[n], list[k]);
		}

		return list;
	}
	
	public static string ToCamelCase(this string str)
	{
		if (str == null)
			return null;

		if (str.Length > 1)
			return char.ToUpper(str[0]) + str.Substring(1).ToLower();

		return str.ToUpper();
	}
	
	public static string ToOrdinal(this int number)
	{
		if (number <= 0)
		{
			return number.ToString();
		}

		var lastTwoDigits = number % 100;
		var lastDigit = number % 10;

		//11 ~ 13은 th
		if (lastTwoDigits is >= 11 and <= 13)
		{
			return "th";
		}

		return lastDigit switch
		{
			1 => "st",
			2 => "nd",
			3 => "rd",
			_ => "th"
		};
	}

	public static IEnumerable<T> WhereNonAlloc<T>(this IEnumerable<T> enumerable, Func<T, bool> predicate)
	{
		foreach (var value in enumerable)
		{
			if (predicate(value))
				yield return value;
		}
	}

	public static float MinSliderValue(this float value, float min, float down = .01f) => !(value >= down) ? 0f : Mathf.Max(value, min);
	
	public static void SetSortingLayer(this GameObject go, string layerName)
	{
		var id = SortingLayer.NameToID(layerName);
		foreach (var renderer in go.GetComponentsInChildren<Renderer>())
			renderer.sortingLayerID = id;
	}
	
	public static T DeepClone<T>(this T obj)
	{
		using var ms = new MemoryStream();
		var formatter = new BinaryFormatter();
		formatter.Serialize(ms, obj);
		ms.Position = 0;
		return (T) formatter.Deserialize(ms);
	}

	public static int GetExceptionLine(this Exception ex)
	{
		var st = new System.Diagnostics.StackTrace(ex, true);
		var frame = st.GetFrame(st.FrameCount-1);
		return frame?.GetFileLineNumber() ?? 0;
	}
	
	public static Vector3 ZRotate(this Vector3 v, float angle)
	{
		return Quaternion.Euler(0f, 0f, angle * Mathf.Rad2Deg) * v;
	}
	
	public static Vector3 YRotate(this Vector3 v, float angle)
	{
		return Quaternion.Euler(0f, angle * Mathf.Rad2Deg, 0f) * v;
	}
	
	public static Vector2 WorldToRelativeScreenPoint(this Camera camera, Vector3 worldPosition, Canvas canvas)
	{
		// convert screen coords
		Vector2 adjustedPosition = camera.WorldToScreenPoint(worldPosition) / canvas.scaleFactor;
 
		// set it
		return adjustedPosition;
	}
	
	public static void ResumeDirector(this Playable playable)
	{
		playable.GetPlayableDirector()?.playableGraph.GetRootPlayable(0).SetSpeed(1);
	}

	public static void PauseDirector(this Playable playable)
	{
		playable.GetPlayableDirector()?.playableGraph.GetRootPlayable(0).SetSpeed(0);
	}

	public static PlayableDirector GetPlayableDirector(this Playable playable)
	{
		return playable.GetGraph().GetResolver() as PlayableDirector;
	}

	public static void SetTimeToClipEnd(this Playable playable, TimelineClip clip)
	{
		playable.GetPlayableDirector()?.SetTimeToClipEnd(clip);
	}

	public static void SetTimeToClipEnd(this PlayableDirector director, TimelineClip clip)
	{
		director.SetPlayableTime(clip.end);
	}

	public static void SetPlayableTime(this PlayableDirector director, double time)
	{
		director.time = time;
		director.Evaluate();
	}
	
	public static void GetWorldCornersEx(this RectTransform rt, Vector3[] fourCornersArray, Vector4 padding)
	{
		if (fourCornersArray == null || fourCornersArray.Length < 4)
		{
			Debug.LogError((object) "Calling GetWorldCorners with an array that is null or has less than 4 elements.");
		}
		else
		{
			rt.GetLocalCorners(fourCornersArray);

			fourCornersArray[0] += new Vector3(padding.x, padding.y);
			fourCornersArray[1] += new Vector3(padding.x, -padding.w);
			fourCornersArray[2] += new Vector3(-padding.z, -padding.w);
			fourCornersArray[3] += new Vector3(-padding.z, padding.y);
			
			var localToWorldMatrix = rt.transform.localToWorldMatrix;
			for (var index = 0; index < 4; ++index)
				fourCornersArray[index] = localToWorldMatrix.MultiplyPoint(fourCornersArray[index]);
		}
	}
	
	public static void GetWorldCornersEx(this RectTransform rt, Vector3[] fourCornersArray)
	{
		var padding = rt.TryGetComponent<Image>(out var image) ? image.raycastPadding : Vector4.zero;
		rt.GetWorldCornersEx(fourCornersArray, padding);
	}

	private static readonly Vector3[] _corners = new Vector3[4];
	public static Bounds GetWorldBounds(this RectTransform rt)
	{
		rt.GetWorldCornersEx(_corners);
		var bounds = new Bounds();
		bounds.SetMinMax(_corners[0], _corners[2]);
		return bounds;
	}

	//pivot range [0, 1]
	public static Vector3 GetPointInBounds(this Bounds bounds, Vector3 pivot)
	{
		var x = pivot.x.MapRangeClamped(0f, 1f, bounds.min.x, bounds.max.x);
		var y = pivot.y.MapRangeClamped(0f, 1f, bounds.min.y, bounds.max.y);
		var z = pivot.z.MapRangeClamped(0f, 1f, bounds.min.z, bounds.max.z);

		return new Vector3(x, y, z);
	}

	public static Type GetElementType<T>(List<T> list)
	{
		return typeof(T);
	}
	
	public static Type GetElementType<T>(RepeatedField<T> repeatedField)
	{
		return repeatedField.GetType().GetGenericArguments()[0];
	}
	
	public static object ConvertElement(object element, Type sourceType, Type targetType)
	{
		try
		{
			var implicitOperator = targetType.GetMethod("op_Implicit", new[] { sourceType });
			if (implicitOperator != null)
			{
				return implicitOperator.Invoke(null, new[] { element });
			}
		}
		catch
		{
			// ignored
		}

		return null;
	}
	
	public static string GetCommitHash(string repositoryPath)
    {
        try
        {
            ProcessStartInfo procStartInfo = new ProcessStartInfo("git", "rev-parse HEAD");
            procStartInfo.WorkingDirectory = repositoryPath;
            procStartInfo.RedirectStandardOutput = true;
            procStartInfo.UseShellExecute = false;
            procStartInfo.CreateNoWindow = true;

            using (Process process = new Process())
            {
                process.StartInfo = procStartInfo;
                process.Start();
                
                string commitHash = process.StandardOutput.ReadToEnd().Trim();
                process.WaitForExit();

                if (process.ExitCode != 0 || string.IsNullOrEmpty(commitHash))
                {
					Debug.LogError("Failed to get commit hash from '" + repositoryPath + "'. Make sure it is a valid git repository. Exit Code: " + process.ExitCode);
                    return null;
                }
                return commitHash;
            }
        }
        catch (Exception e)
        {
			Debug.LogError("An error occurred while trying to run git.\n" + e.Message);
            return null;
        }
    }
		
	public static int GetKeyboardHeight()
	{
#if UNITY_EDITOR || UNITY_WEBGL
		return 400;
#elif UNITY_ANDROID
        using (var unityClass = new AndroidJavaClass("com.unity3d.player.UnityPlayer"))
		{
			var unityPlayer = unityClass.GetStatic<AndroidJavaObject>("currentActivity").Get<AndroidJavaObject>("mUnityPlayer");
			var view = unityPlayer.Call<AndroidJavaObject>("getView");
			var dialog = unityPlayer.Get<AndroidJavaObject>("b");
 
			if (view == null || dialog == null)
				return 0;
 
			var decorHeight = 0;
 
			if (true)// (includeInput)
			{
				var decorView = dialog.Call<AndroidJavaObject>("getWindow").Call<AndroidJavaObject>("getDecorView");
 
				if (decorView != null)
					decorHeight = decorView.Call<int>("getHeight");
			}
 
			using (var rect = new AndroidJavaObject("android.graphics.Rect"))
			{
				view.Call("getWindowVisibleDisplayFrame", rect);
				// return Display.main.systemHeight - rect.Call<int>("height") + decorHeight;
				return Screen.height - rect.Call<int>("height") + decorHeight;
			}
		}
#elif UNITY_IOS
        return (int)TouchScreenKeyboard.area.height;
#endif
	}

#if UNITY_EDITOR
		public static Sprite GenerateTextSprite(
		string text, Font font = null, int fontSize = 64,
		Color? textColor = null, Color? backgroundColor = null,
		int padding = 8, float pixelsPerUnit = 100f)
    {
	    font ??= UResources.GetBuiltinResource<Font>("LegacyRuntime.ttf");
	    
        if (string.IsNullOrEmpty(text) || font == null) return null;
        
        var col = textColor ?? Color.black;
        var bg  = backgroundColor ?? Color.white;

        // 폰트 아틀라스에 글자 래스터 요청
        font.RequestCharactersInTexture(text, fontSize, FontStyle.Normal);

        // 1) 크기 산출(advance 합, 상/하단 최대 범위)
        int totalAdvance = 0;
        int top = int.MinValue, bottom = int.MaxValue;
        CharacterInfo ci;
        foreach (var ch in text)
        {
            if (!font.GetCharacterInfo(ch, out ci, fontSize, FontStyle.Normal)) continue;
            totalAdvance += ci.advance;
            if (ci.maxY > top) top = ci.maxY;
            if (ci.minY < bottom) bottom = ci.minY;
        }
        if (top == int.MinValue) { top = 0; bottom = 0; }

        int w = Mathf.Max(2, totalAdvance + padding * 2);
        int h = Mathf.Max(2, (top - bottom) + padding * 2);
        int baseline = -bottom + padding;

        // 2) 오프스크린 RT에 직접 그리기(카메라 X)
        var rt = new RenderTexture(w, h, 0, RenderTextureFormat.ARGB32);
        var prev = RenderTexture.active;
        RenderTexture.active = rt;

        GL.PushMatrix();
        GL.LoadPixelMatrix(0, w, 0, h);
        GL.Clear(true, true, bg);

        float x = padding;
        var mat = font.material;
        mat.color = col;                  // 글자색
        mat.SetPass(0);                   // 폰트 머티리얼 바인딩

        for (int i = 0; i < text.Length; i++)
        {
	        if (!font.GetCharacterInfo(text[i], out ci, fontSize, FontStyle.Normal))
	        {
		        x += fontSize * 0.5f; 
		        continue;
	        }

	        // 화면(픽셀) 공간의 목적 사각형
	        float gx = x + ci.minX;
	        float gy = baseline + ci.minY;
	        float gw = ci.glyphWidth;
	        float gh = ci.glyphHeight;

	        // GL로 쿼드 + 각 꼭짓점에 UV 매핑
	        GL.Begin(GL.QUADS);
	        // 왼-아래
	        GL.TexCoord2(ci.uvBottomLeft.x,  ci.uvBottomLeft.y);
	        GL.Vertex3  (gx,                 gy,                0);
	        // 오-아래
	        GL.TexCoord2(ci.uvBottomRight.x, ci.uvBottomRight.y);
	        GL.Vertex3  (gx + gw,            gy,                0);
	        // 오-위
	        GL.TexCoord2(ci.uvTopRight.x,    ci.uvTopRight.y);
	        GL.Vertex3  (gx + gw,            gy + gh,           0);
	        // 왼-위
	        GL.TexCoord2(ci.uvTopLeft.x,     ci.uvTopLeft.y);
	        GL.Vertex3  (gx,                 gy + gh,           0);
	        GL.End();

	        x += ci.advance; // 다음 글자 위치
        }
        
        GL.PopMatrix();

        // 3) CPU 텍스쳐로 복사 후 스프라이트 생성
        var tex = new Texture2D(w, h, TextureFormat.RGBA32, false);
        tex.ReadPixels(new Rect(0, 0, w, h), 0, 0);
        tex.Apply();

        RenderTexture.active = prev;
        rt.Release();
        Object.Destroy(rt);

        var sp = Sprite.Create(tex, new Rect(0, 0, w, h), new Vector2(0.5f, 0.5f), pixelsPerUnit);
        sp.name = $"PlainText_{text}";
        return sp;
    }
#endif

    // ===== Merged from Utility.Scripts2.cs =====

    public static Vector3 X0Z(this Vector2 v, float yValue = 0f)
    {
        return new Vector3(v.x, v.y);
    }

    public static Vector3 X0Z(this Vector2Message v, float yValue = 0f)
    {
        if (v == null)
            return Vector3.zero;
        return new Vector3(v.X, v.Y);
    }

    public static Vector3 X0Z(this FixedVector2 v, float yValue = 0f)
    {
        return new Vector3((float)v.x, (float)v.y);
    }

    public static Vector2 XZ(this Vector3 v)
    {
        return new Vector2(v.x, v.y);
    }

    public static Quaternion GetRotationAs2D(this Vector3 v)
    {
        //make quaternion from vector.x and vector.y
        return Quaternion.Euler(0, 0, Mathf.Atan2(v.y, v.x) * Mathf.Rad2Deg);
    }

    public static Quaternion GetRotationAs2D(this Vector2 v)
    {
        return ((Vector3)v).GetRotationAs2D();
    }

    public static Vector2 RandomInsideUnitCircle(float radius, float innerRadius = 0f)
    {
        var r = Random.Range(innerRadius, radius);
        var angle = Random.Range(0f, Mathf.PI * 2);

        var x = Mathf.Cos(angle) * r;
        var y = Mathf.Sin(angle) * r;

        return new Vector2(x, y);
    }

    public static Vector2 PickRandomInsideRange(this Vector2 pos, float innerRange, float range)
    {
        return pos + RandomInsideUnitCircle(range, innerRange);
    }

    public static Vector3 PickRandomInsideRange(this Vector3 pos, float innerRange, float range)
    {
        return pos + (Vector3)RandomInsideUnitCircle(range, innerRange);
    }

    public static Vector2 PickRandomInsideRange(this Vector2Message pos, float innerRange, float range)
    {
        return pos + RandomInsideUnitCircle(range, innerRange);
    }

    public static Vector2 PickRandomInsideRange(this Vector2 pos, float range)
    {
        return pos + RandomInsideUnitCircle(0f, range);
    }

    public static Vector3 PickRandomInsideRange(this Vector3 pos, float range)
    {
        return pos + (Vector3)RandomInsideUnitCircle(0f, range);
    }

    public static Vector2 PickRandomInsideRange(this Vector2Message pos, float range)
    {
        return pos + RandomInsideUnitCircle(0f, range);
    }

    public static Vector2 PickRandom(this Vector2 size, Vector2? pivot = null)
    {
        pivot ??= new Vector2(0.5f, 0.5f);
        size *= pivot.Value;
        return new Vector2(Random.Range(-size.x, size.x), Random.Range(-size.y, size.y));
    }

    public static double AppendRandom(this double value, double min, double max = double.MinValue)
    {
        max = Math.Max(max, min);
        return value + Random.Range((float)min, (float)max);
    }

    public static byte[] SerializePacket(Packet packet)
    {
        MemoryStream stream = null;
        try
        {
            stream = PopMemoryStream();
            packet.Dump(stream);

            return stream.ToArray();
        }
        finally
        {
            if (stream != null)
                ReturnMemoryStream(stream);
        }
    }

    public static Packet DeserializePacket(byte[] buf)
    {
        using var stream = new MemoryStream(buf);
        return DeserializePacketFromStream(stream);
    }

    public static Packet DeserializePacketFromStream(Stream input)
    {
        var packet = Packet.PopWithoutInitialize();
        packet.Parse(input);
        return packet;
    }

    public static Vector3 VertexToVector3(this ResourceMap.Types.Terrain.Types.Vertex v)
    {
        return new Vector3(v.Position.X, v.Height, v.Position.Y);
    }

    public enum UnitValueType
    {
        NUM,
        DOT,
        UNIT,
    }
    private static readonly string[] SupportedUnits = { "K", "M", "B" };
    private static readonly List<(UnitValueType, int)> UnitValues = new();
    public static IReadOnlyList<(UnitValueType, int)> ToUnitValues(this ulong number, int minDigit = 3)
    {
        UnitValues.Clear();

        var i = 0;
        while (number > 0)
        {
            UnitValues.Add((UnitValueType.NUM, (int)(number % 10)));
            i++;
            number /= 10;
        }

        if (UnitValues.Count == 0)
            UnitValues.Add((UnitValueType.NUM, 0));

        if (i > minDigit)
        {
            var unitIndex = (int)Math.Min(SupportedUnits.Length, Math.Floor((UnitValues.Count - 1) / 3f)) - 1;
            var truncIndex = (unitIndex + 1) * 3 - 1;
            var trunc = UnitValues[truncIndex];
            UnitValues.RemoveRange(0, truncIndex + 1);
            UnitValues.Reverse();
            if (trunc.Item2 > 0)
            {
                UnitValues.Add((UnitValueType.DOT, 0));
                UnitValues.Add((UnitValueType.NUM, trunc.Item2));
            }
            UnitValues.Add((UnitValueType.UNIT, unitIndex));
        }
        else
        {
            UnitValues.Reverse();
        }

        return UnitValues;
    }

    public static string DyedString(this string s, Color color)
    {
        var hexColor = ColorUtility.ToHtmlStringRGB(color);
        return $"<color=#{hexColor}>{s}</color>";
    }

    public static string DyedString(this string s, string hexColorString)
    {
        return $"<color=#{hexColorString}>{s}</color>";
    }
}

[Serializable]
public struct IntVector3
{
	public int x;
	public int y;
	public int z;

	public IntVector3(int x, int y, int z)
	{
		this.x = x;
		this.y = y;
		this.z = z;
	}

	// otherwise returns dbTrue or dbFalse:
	public static bool operator ==(IntVector3 a, IntVector3 b)
	{
		return a.x == b.x
		       && a.y == b.y
		       && a.z == b.z;
	}

	public static bool operator !=(IntVector3 a, IntVector3 b)
	{
		return a.x != b.x
		       || a.y != b.y
		       || a.z != b.z;
	}
}
