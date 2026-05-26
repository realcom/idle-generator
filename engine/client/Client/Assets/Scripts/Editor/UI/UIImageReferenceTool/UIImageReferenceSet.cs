using System;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "UI/Image Reference Set", fileName = "ImageReferenceSet")]
public class UIImageReferenceSet : ScriptableObject
{
    [Serializable]
    public class Entry
    {
        // 프리팹 루트 기준 상대 경로(루트명 제외). 예) "Canvas/Icon" / 루트면 ""
        public string transformPath;

        // 프리팹 에셋 내 동일 컴포넌트를 식별하는 로컬 ID (이름/부모 변경에도 안정적)
        public long localFileId;

        // 참고용
        public string objectName;
        public Sprite sprite;
    }

    public List<Entry> entries = new List<Entry>();
}