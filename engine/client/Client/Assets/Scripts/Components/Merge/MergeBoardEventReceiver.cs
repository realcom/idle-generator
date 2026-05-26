using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MergeBoardEventReceiver : MonoBehaviour
{
    [SerializeField] private MergeBoard m_MergeBoard;

    public void RefreshInventory()
    {
    }

    public void RefreshInventoryBySpawn()
    {
        m_MergeBoard.RefreshInventoryBySpawn();
    }

    public void DisappearAllHoldItems()
    {
        //m_MergeBoard.DisappearAllHoldItems();
    }
    
}
