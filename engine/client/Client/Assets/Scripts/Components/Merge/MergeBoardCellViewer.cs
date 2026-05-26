using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Resources;
using Commons.Types.Players;
using DG.Tweening;
using UnityEngine;
using UnityEngine.UI;

public class MergeBoardCellViewer : MergeBoardCellBase
{
    protected override bool HideThis(MergeBoardBase parentBoard)
    {
        return false;
    }
}
