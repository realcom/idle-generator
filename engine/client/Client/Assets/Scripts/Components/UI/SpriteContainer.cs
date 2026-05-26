using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Utility;
using UnityEngine;

public class SpriteContainer : MonoBehaviour
{
    public List<Sprite> sprites = new();
    public Sprite this[int index] => sprites.GetClamped(index);
    
    public static implicit operator Sprite(SpriteContainer container) => container?.sprites.FirstOrDefault();
    
}
