using System;
using UnityEngine;

namespace Share.ABC
{
    [Serializable]
    public class ABCColor : ABCBase
    {
        [NonSerialized] public Color ActiveColor;

        [SerializeField] private Color activeA, activeB, activeC;

        private Color GetColor(ABCType type)
        {
            switch (type)
            {
                case ABCType.A: return activeA;
                case ABCType.B: return activeB;
                case ABCType.C: return activeC;
            }

            Debug.LogError("구현되지 않음. " + type);
            return activeA;
        }

        protected override void SetType_(ABCType type)
        {
            ActiveColor = GetColor(type);
        }
    }
}