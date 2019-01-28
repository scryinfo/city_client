
using System;
using UnityEngine;
using UnityEngine.EventSystems;

public class MiniMapDrag : MonoBehaviour , IDragHandler
{
    //自身mRect
    private RectTransform mRect;
    private float mMapPixelSize;

    //
    private Vector2 targetPos;
    private float mMapScale;
    private float NowRangeSize;

    private void Awake()
    {
        mRect = this.gameObject.GetComponent<RectTransform>();
        mMapPixelSize = mRect.sizeDelta.x;
    }


    public void OnDrag(PointerEventData eventData)
    {
        mMapScale = mRect.localScale.x;
        targetPos = mRect.anchoredPosition + eventData.delta;
        //此处做边界计算
        NowRangeSize = (mMapScale - 1) * mMapPixelSize / 2;
        if (targetPos.x > NowRangeSize)
        {
            targetPos.x = NowRangeSize;
        }
        else if(targetPos.x < -NowRangeSize)
        {
            targetPos.x = -NowRangeSize;
        }

        if (targetPos.y > NowRangeSize)
        {
            targetPos.y = NowRangeSize;
        }
        else if (targetPos.y < -NowRangeSize)
        {
            targetPos.y = -NowRangeSize;
        }
        mRect.anchoredPosition = targetPos;
    }

}
