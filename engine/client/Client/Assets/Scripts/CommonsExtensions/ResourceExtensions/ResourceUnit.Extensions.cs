using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Commons.Resources
{
    public partial class ResourceUnit
    {
        public override int GetId() => id_;
        public override ResourceString.Types.Category StringCategory => ResourceString.Types.Category.Unit;
        public override bool CanDisplay => IsValid && !ContainsTag(Tag.HideDisplay);
        public override bool HasRelevanceNotice()
        {
            return false;
        }

        public LazyLoad<GameObject> ClientPrefab { get; private set; }
        public LazyLoad<Sprite> ClientSprite { get; private set; }
        
        public float ClientUIScale { get; private set; }
        public Vector2 ClientUIOffset { get; private set; }

        partial void InitUnity()
        {
            InitEntity(ResourceString.Types.Category.Unit, Id);
            
            ClientPrefab = new LazyLoad<GameObject>(Prefab);
            ClientSprite = new LazyLoad<Sprite>(Sprite);

            ClientUIScale = 1f + UiScale;
            ClientUIOffset = UiOffset ?? Vector2.zero;
        }
    }
}