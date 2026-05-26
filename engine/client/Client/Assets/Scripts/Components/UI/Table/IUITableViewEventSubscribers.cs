using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface IUITableViewEventSubscribers
{
    public void OnTableViewContentSizeChanged(Vector2 changedSize);
}
