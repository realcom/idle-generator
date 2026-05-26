using Sirenix.OdinInspector;
using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

namespace Share.AZ
{
    [Serializable]
    public struct AZPreset
    {
        public string Id;
        [ListDrawerSettings(DefaultExpandedState = true)]
        public string[] Values;
    }

    [Serializable]
    public struct AZPresetTable
    {
        public static AZPresetTable Instance => getter(); 

        public static void SetGetter(Func<AZPresetTable> getter)
        {
            AZPresetTable.getter = getter;
        }

        private static Func<AZPresetTable> getter;

        [TableList(AlwaysExpanded = true)]
        [SerializeField] private AZPreset[] presets;

        public IEnumerable<string> Ids => presets.Select(x => x.Id);

        public bool Contains(string id)
        {
            return presets.Any(x => x.Id == id);
        }

        public string[] FindValuesById(string id)
        {
            if (string.IsNullOrEmpty(id) || !Contains(id))
                return new string[0];
            return presets.FirstOrDefault(x => x.Id == id).Values;
        }
    }
}