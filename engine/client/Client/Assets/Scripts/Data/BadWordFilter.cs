using System;
using System.Text;
using UnityEngine;

public class BadWordFilter
{
	private static bool mInited = false;
	private static string []mBadWords;
	
	public static void Init() {
		if(mInited)
			return;

		var text = Utility.LoadResource<string> ("BannedKeywords.txt");
		if(text == null) {
			Debug.LogWarning("Failed to load banned keywords");
			return;
		}
		mBadWords = text.Split(',');
		for(int i = 0;i < mBadWords.Length;++i)
			mBadWords[i] = mBadWords[i].ToLower().Trim();

		mInited = true;
		Debug.Log(string.Format ("Loaded {0} bad words", mBadWords.Length));
	}
	
	public static string FilterString(string str) {
		if(!mInited) {
			Debug.LogWarning("BadWordFilter not initialized!");
			return str;
		}

		var builder = new StringBuilder(str);
		foreach (var word in mBadWords)
		{
			if(word.Length == 0)
				continue;
			while (true)
			{
				var idx = builder.ToString().IndexOf(word, StringComparison.OrdinalIgnoreCase);
				if (idx < 0)
					break;
				builder.Remove(idx, word.Length);
				builder.Insert(idx, new string('*', word.Length));
			}
		}
		
		return builder.ToString();
	}

	public static bool ContainsBadWord(string str) {
		if(!mInited) {
			Debug.LogWarning("BadWordFilter not initialized!");
			return false;
		}

		str = str.ToLower();
		foreach (var word in mBadWords)
		{
			if(word.Length == 0)
				continue;
			if(str.Contains(word.ToLower()))
				return true;
		}
		
		return false;
	}

}

