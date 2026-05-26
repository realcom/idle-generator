using System;
using System.Collections;
using System.Collections.Generic;

public interface IGoodsViewer
{
    public void RefreshGoods();
    public void RefreshGoods(IList<int> goodsIds);
}
