using System.Collections;
using System.Collections.Generic;
using Commons.Resources;
using UnityEngine;
using UnityEngine.UI;

public class SmartItemIcon : MonoBehaviour
{
    [SerializeField] private Image m_NormalIcon;
    [SerializeField] private BoardWeaponImage m_BoardWeaponIcon;

    public Sprite sprite
    {
        get => m_NormalIcon.sprite;
        set => m_NormalIcon.sprite = value;
    }

    public void Set(ResourceItem resourceItem, float maxScale = BoardWeaponImage.FIT_SCALE_MAX, int baseSize = 128)
    {
        m_NormalIcon.SetActive(resourceItem.Type != ResourceItem.Types.Type.InventorySkill);
        m_BoardWeaponIcon.SetActive(resourceItem.Type == ResourceItem.Types.Type.InventorySkill);
        if (resourceItem.Type == ResourceItem.Types.Type.InventorySkill)
        {
            m_NormalIcon.sprite = null;
            m_BoardWeaponIcon.Refresh(resourceItem);
        }
        else
        {
            m_NormalIcon.sprite = resourceItem.ClientSpriteIcon;
            m_BoardWeaponIcon.sprite = null;
            m_BoardWeaponIcon.material = null;
        }
        
        FitScaleByRatio(maxScale, baseSize);
    }

    public void FitScaleByRatio(float maxScale = BoardWeaponImage.FIT_SCALE_MAX, int baseSize = 128)
    {
        if (m_NormalIcon.sprite)
        {
            var size = m_NormalIcon.sprite.rect.size;
            
            var xScale = size.x / baseSize;
            var yScale = size.y / baseSize;

            if (xScale > maxScale)
            {
                yScale *= maxScale / xScale;
                xScale = maxScale;
            }
            
            if (yScale > maxScale)
            {
                xScale *= maxScale / yScale;
                yScale = maxScale;
            }

            m_NormalIcon.rectTransform.localScale =
                new Vector3(
                    xScale,
                    yScale,
                    1f);
        }
        
        m_BoardWeaponIcon.FitScaleByRatio(maxScale);
    }
    
}
