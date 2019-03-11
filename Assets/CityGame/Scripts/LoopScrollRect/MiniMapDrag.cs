
using LuaFramework;
using System;
using UnityEngine;
using UnityEngine.EventSystems;

public class MiniMapDrag : MonoBehaviour , IDragHandler
{
    public RectTransform mParentRect;
    //自身mRect
    private RectTransform mRect;
    private float mMapPixelSize;
    private float mMapHight;

    //
    private Vector2 targetPos;
    private float mMapScale;
    private float NowRangeSize;
    private float NowRangeSizeY;

    private void Awake()
    {
        mRect = this.gameObject.GetComponent<RectTransform>();
    }

    private void Start()
    {
        float width = mParentRect.rect.width;
        mMapHight = mParentRect.rect.height;
        mRect.sizeDelta = new Vector2(width, width);
        mMapPixelSize = mRect.rect.width;
    }

    public void OnDrag(PointerEventData eventData)
    {
        mMapScale = mRect.localScale.x;
        targetPos = mRect.anchoredPosition + eventData.delta;
        //此处做边界计算
        NowRangeSize = (mMapScale - 1) * mMapPixelSize / 2;
        NowRangeSizeY = (mMapScale - 1) * mMapPixelSize / 2 + (mMapPixelSize - mMapHight) / 2;
        if (targetPos.x > NowRangeSize)
        {
            targetPos.x = NowRangeSize;
        }
        else if(targetPos.x < -NowRangeSize)
        {
            targetPos.x = -NowRangeSize;
        }

        if (targetPos.y > NowRangeSizeY)
        {
            targetPos.y = NowRangeSizeY;
        }
        else if (targetPos.y < -NowRangeSizeY)
        {
            targetPos.y = -NowRangeSizeY;
        }
        mRect.anchoredPosition = targetPos;

        Util.CallMethod("MapBubbleManager", "MapMoveFunc");
    }

}
