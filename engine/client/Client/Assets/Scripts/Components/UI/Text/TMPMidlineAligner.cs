using System;
using System.Text.RegularExpressions;
using TMPro;
using UnityEngine;

[RequireComponent(typeof(TMP_Text))]
public class TMPMidlineAligner : MonoBehaviour, ITextPreprocessor
{
    [SerializeField] private TMP_Text _text;

    private static readonly Regex MidTag = new Regex(
        @"<size\s*=\s*(\d{1,3})\s*%\s*>(.*?)</size>",
        RegexOptions.IgnoreCase | RegexOptions.Singleline | RegexOptions.Compiled);

    private void Awake()
    {
        if (_text)
            _text.textPreprocessor = this;
    }

    private void OnValidate()
    {
        if (!Application.isPlaying)
        {
            if (_text)
                _text.textPreprocessor = this;
        }
        // Auto Size 사용 ok: em 단위가 최종 폰트 크기에 비례해서 적용됨
    }

    public string PreprocessText(string text)
    {
        if (string.IsNullOrEmpty(text) || _text.font == null) return text;

        var face = _text.font.faceInfo;
        // asc/desc를 em으로 정규화 (pointSize로 나눔)
        var ascEm  = face.ascentLine  / face.pointSize;
        var descEm = face.descentLine / face.pointSize; // 보통 음수
        var midEm  = (ascEm + descEm) * 0.5f;           // 줄 중앙(베이스라인 기준 em)

        return MidTag.Replace(text, Repl);

        string Repl(Match m)
        {
            var pct = Mathf.Clamp(int.Parse(m.Groups[1].Value), 1, 400);
            var s = pct / 100f;
            var v = (1f - s) * midEm; // 가운데 정렬처럼 보이도록 올림

            var inner = m.Groups[2].Value;
            return $"<voffset={v:0.###}em><size={pct}%>{inner}</size></voffset>";
        }
    }
}