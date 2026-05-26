using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Commons.Resources
{
    public partial class ResourceBuff
    {
        public override int GetId() => id_;
        public override ResourceString.Types.Category StringCategory => ResourceString.Types.Category.Buff;
        public override bool CanDisplay => IsValid && !ContainsTag(Tag.HideDisplay);
        
        public override bool HasRelevanceNotice()
        {
            return false;
        }

        public LazyLoad<GameObject> ClientPrefab { get; private set; }
        
        public LazyLoad<Sprite> ClientSpriteIcon { get; private set; }
        public LazyLoad<Sprite> ClientSpriteContentsIcon { get; private set; }
        public LazyLoad<Sprite> ClientSpriteFrame { get; private set; }
        public LazyLoad<Sprite> ClientSpriteBackground { get; private set; }

        partial void InitUnity()
        {
            InitEntity(ResourceString.Types.Category.Buff, Id);
            
            ClientPrefab = new LazyLoad<GameObject>(Prefab);
            
            ClientSpriteIcon = new LazyLoad<Sprite>(SpriteGroups.GetValueOrDefault("Icon"));
            ClientSpriteContentsIcon = new LazyLoad<Sprite>(SpriteGroups.GetValueOrDefault("ContentsIcon"));
            ClientSpriteFrame = new LazyLoad<Sprite>(SpriteGroups.GetValueOrDefault("Frame"));
            ClientSpriteBackground = new LazyLoad<Sprite>(SpriteGroups.GetValueOrDefault("Background"));
        }
    }   
}
