using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GoodsContainer : MonoBehaviour
{
    [SerializeField] private UIElementContainer<Utility.GoodsCell> _goods = new();

    public void RefreshGoods(IList<int> goodsIds)
    {
        _goods.RefreshGoods(goodsIds);
    }
    
}
