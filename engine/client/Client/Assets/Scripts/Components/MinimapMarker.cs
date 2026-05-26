using UnityEngine;
using UnityEngine.UI;


public class MinimapMarker : MonoBehaviour
{
    public GameObject objBubble;
    public GameObject objBubbleArrow;
    public Image imgIcon;
    public Image imgBubble;

    public void Initialize(Sprite sprite)
    {
        imgIcon.sprite = sprite;
    }

    public void SetBubble(bool isBubble, Vector3 dir = default)
    {
        objBubble.SetActive(isBubble);
        if (isBubble)
        {
            var angle = Mathf.Atan2(dir.y, dir.x) * Mathf.Rad2Deg - 90f;
            objBubbleArrow.transform.rotation = Quaternion.Euler(0f, 0f, angle);
            imgBubble.maskable = false;
            imgIcon.maskable = false;
        }
        else
        {
            imgBubble.maskable = true;
            imgIcon.maskable = true;
        }
    }
}