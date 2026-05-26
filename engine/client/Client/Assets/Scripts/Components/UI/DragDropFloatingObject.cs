using System;
using DG.Tweening;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.EventSystems;
using UnityEngine.UI;


public class DragDropFloatingObject : MonoBehaviour
{
    public int index;
    public DragDropParent parent;

    protected Vector2 offset;

    public virtual void Initialize(int index, DragDropParent parent)
    {
        this.index = index;
        this.parent = parent;
        
        transform.SetParent(parent.transform);

        //
        var inventoryItemImage = gameObject.Get<InventoryItemImage>();
        if (inventoryItemImage)
            Destroy(inventoryItemImage);
        
        var dragDropObject = gameObject.Get<DragDropObject>();
        if (dragDropObject)
            Destroy(dragDropObject);
        
        gameObject.GetOrAdd<LayoutElement>().ignoreLayout = true;
        var cg = gameObject.GetOrAdd<CanvasGroup>();
        cg.interactable = false;
        cg.blocksRaycasts = false;
        
        //
        transform.localScale = Vector3.zero;
        transform.DOScale(1.1f, 0.3f).SetEase(Ease.OutCirc);
        
        var screenPos = Input.mousePosition; // 마우스 화면 좌표
        screenPos.z = 0;

        RectTransformUtility.ScreenPointToLocalPointInRectangle(
            parent.GetComponent<RectTransform>(), // Overlay Canvas의 RectTransform
            screenPos,
            null, // Overlay 모드이므로 camera는 null
            out var localPoint
        );
        
        offset = localPoint - (Vector2)transform.localPosition;
        parent.OnBeginDrag(this);

        GameManager.Get().PlayClick();
    }

    protected virtual void Update()
    {
        if (Input.GetMouseButton(0))
        {
            var screenPos = Input.mousePosition; // 마우스 화면 좌표
            screenPos.z = 0;

            RectTransformUtility.ScreenPointToLocalPointInRectangle(
                parent.GetComponent<RectTransform>(), // Overlay Canvas의 RectTransform
                screenPos,
                null, // Overlay 모드이므로 camera는 null
                out var localPoint
            );

            transform.localPosition = localPoint - offset;

            if (parent.scroll)
            {
                var localPt = localPoint;
                var rect = parent.rectScroll.rect;

                var autoScrollAreaSize = 150;
                var autoScrollAreaTop = rect.yMax - autoScrollAreaSize;
                var autoScrollAreaBottom = rect.yMin + autoScrollAreaSize;

                var scrollPos = parent.scroll.verticalNormalizedPosition;
                if (localPt.y > autoScrollAreaTop)
                    scrollPos += Time.deltaTime * Mathf.Lerp(0f, 3f, Mathf.Clamp(Mathf.Abs(localPt.y - autoScrollAreaTop) / autoScrollAreaSize, 0f, 1f));
                else if (localPt.y < autoScrollAreaBottom)
                    scrollPos -= Time.deltaTime * Mathf.Lerp(0f, 3f, Mathf.Clamp(Mathf.Abs(localPt.y - autoScrollAreaBottom) / autoScrollAreaSize, 0f, 1f));
                parent.scroll.verticalNormalizedPosition = Mathf.Clamp(scrollPos, 0f, 1f);
            }
        }
        else
        {
            parent.OnEndDrag(this);
        }
    }

    public virtual void Destroy()
    {
        parent.floatingObject = null;
        Destroy(gameObject);
    }
}
