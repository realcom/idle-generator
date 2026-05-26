using Sirenix.OdinInspector;
using UnityEditor;
using UnityEngine;

namespace Share.AZ
{
    [Required]
    [CreateAssetMenu]
    public class AZTable : ScriptableObject
    {
        [InlineProperty]
        [HideLabel]
        [SerializeField] private AZPresetTable table;

        private static AZTable instance;

        public static AZTable Get()
        {
            if (instance == null)
                instance = Resources.Load<AZTable>("AZTable");
            return instance;
        }

#if UNITY_EDITOR
        [InitializeOnLoadMethod]
        private static void Initialize()
        {
            AZPresetTable.SetGetter(() => Get().table);
        }
#endif
    }
}