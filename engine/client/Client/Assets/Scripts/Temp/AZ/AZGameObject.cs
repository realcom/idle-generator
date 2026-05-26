using Sirenix.OdinInspector;
using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

namespace Share.AZ
{
    [Serializable]
    public struct AzGameObjectOption
    {
        [TableColumnWidth(100, false)]
        public string Value;
        [ListDrawerSettings(DefaultExpandedState = true)]
        public GameObject[] Panels;
    }

    public class AZGameObject : AZBase
    {
        [TableList(AlwaysExpanded = true)]
        [ValidateInput(nameof(IsValid))]
        [SerializeField] private List<AzGameObjectOption> list;

        protected override void SetValue_(string value)
        {
            var all = list.SelectMany(x => x.Panels);
            var actives = AZExtensions.FindOne(list, value, x => x.Value).Panels;
            var inActives = all.Except(actives);
            foreach (var panel in inActives)
                panel.SetActive(false);
            foreach (var panel in actives)
                panel.SetActive(true);
        }

        protected override bool RequiredUpdateValue()
        {
            var _ = "";
            return !IsValid(list, ref _);
        }

        public bool IsValid(List<AzGameObjectOption> options, ref string errorMessage)
        {
            options ??= new List<AzGameObjectOption>();
            var expected = GetValues();
            var ex = expected.OrderBy(x => x).ToArray();
            var cur = options.Select(x => x.Value).OrderBy(x => x).ToArray();
            var missing = ex.Except(cur).ToArray();
            var over = cur.Except(ex).ToArray();

            var isMissing = missing.Length != 0;
            var isOver = over.Length != 0;

            if (isMissing)
                errorMessage += $"부족함: {AZExtensions.SumAsString(missing)}";
            if (isOver)
                errorMessage += $"\n과도함: {AZExtensions.SumAsString(over)}";
            return !isMissing && !isOver;
        }

        public override void SetOptionValues(string[] values)
        {
            var add = values.Except(list.Select(x => x.Value));

            foreach (var x in add)
            {
                AzGameObjectOption vo;
                vo.Value = x;
                vo.Panels = new GameObject[0];
                list.Add(vo);
            }
        }
    }
}