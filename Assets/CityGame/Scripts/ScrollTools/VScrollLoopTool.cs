//滑动复用

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


public class VScrollLoopTool : MonoBehaviour
{
    public GameObject mPrefab;  //预制
    public ScrollRect mScrollRect;
    public float mSpaceH = 6;  //间隔
    public Vector2 mItemStartPos = new Vector2(-130, -45);  //开始的位置
    
    private float mDetailHeight;  //预制的实际高度
    private Camera mUICamera;
    private RectTransform mContentRect;
    private Vector2 mScrollTopBottomV2 = Vector2.zero;  //scroll顶部底部的屏幕坐标y
    private float mContentHeight;  //content的高度
    private int mTotalCount;

    ////private List<Vector2> mContentPosList = new List<Vector2>();  //定位需要用到
    private Dictionary<int, RectTransform> mShowItemList = new Dictionary<int, RectTransform>();  //在屏幕显示的item
    private VScrollEventData mEvent = new VScrollEventData();

    //初始化设置
    public void InitComponent(VScrollEventData func)
    {
        if (mUICamera == null)
        {
            mUICamera = City.UIRoot.getUiCamera();
        }
        InitScreenRatio();
        GetContentTopBottonScreenPos();
        ScrollPool.GetInstance().InitPool(mPrefab, 10, mScrollRect.content.transform);
        mScrollRect.onValueChanged.AddListener(OnScrollFunc);
        mContentRect = mScrollRect.content;
        mEvent = func;

        mDetailHeight = mPrefab.GetComponent<RectTransform>().rect.size.y;
    }

    //拿到具体数据开始生成
    public void InitData(int totalCount)
    {
        mTotalCount = totalCount;
        float height = 0;
        height += mTotalCount * (mDetailHeight + mSpaceH);
        mContentRect.sizeDelta = new Vector2(mContentRect.sizeDelta.x, height);
        mScrollRect.content.anchoredPosition = Vector2.zero;  //计算content高度以及初始化content位置
        mContentHeight = height;

        CalculateShowIds();  //
    }

    public void CleanAll()
    {
        foreach (var item in mShowItemList)
        {
            ScrollPool.GetInstance().ReturnToPool(item.Value.gameObject);
        }
        mShowItemList = new Dictionary<int, RectTransform>();
    }

    private void OnScrollFunc(Vector2 value)
    {
        CalculateShowIds();
    }

    //获取Scroll的顶部底部屏幕坐标
    private void GetContentTopBottonScreenPos()
    {
        Vector2 pos = WorldToScreenPoint(mScrollRect.transform.position);
        float top = pos.y + mScrollRect.GetComponent<RectTransform>().rect.size.y / 2;
        float bottom = pos.y - mScrollRect.GetComponent<RectTransform>().rect.size.y / 2;
        mScrollTopBottomV2 = new Vector2(top, bottom);
    }

    ////public void PosTargetIndex(int targetIndex)
    ////{
    ////    if (targetIndex < 0 || targetIndex > mTotalCount)
    ////        return;
    ////    mScrollRect.content.anchoredPosition = new Vector2(0, -(mContentPosList[targetIndex].y - mItemStartPos.y));
    ////}

    #region 每帧判断区域内所需items
    //
    private void CalculateShowIds()
    {
        List<int> ids = GetValuableIds();  //屏幕内需要显示的ids
        Dictionary<int, float> idPosy = new Dictionary<int, float>();  //id对应的高度

        float startPosY = GetHeightById(ids[0]);
        idPosy.Add(ids[0], startPosY);
        for (int i = ids[0] + 1; i < ids[ids.Count - 1] + 1; i++)
        {
            startPosY -= mDetailHeight + mSpaceH;
            idPosy.Add(i, startPosY);
        }

        if (mShowItemList.Count != 0)
        {
            foreach (var item in idPosy)
            {
                if (!mShowItemList.ContainsKey(item.Key))
                {
                    CreateItem(item.Key, new Vector2(mItemStartPos.x, item.Value));  //需要增加的
                }
            }
            List<int> needRemove = new List<int>();
            foreach (var item in mShowItemList)
            {
                if (!idPosy.ContainsKey(item.Key))
                {
                    needRemove.Add(item.Key);
                }
            }
            for (int i = 0; i < needRemove.Count; i++)
            {
                ScrollPool.GetInstance().ReturnToPool(mShowItemList[needRemove[i]].gameObject);
                mShowItemList.Remove(needRemove[i]);
            }
        }
        else
        {
            foreach (var item in idPosy)
            {
                CreateItem(item.Key, new Vector2(mItemStartPos.x, item.Value));
            }
        }
    }

    //新增item
    private void CreateItem(int index, Vector2 currentPos)
    {
        RectTransform rect = ScrollPool.GetInstance().GetValuableItem(mPrefab.name).GetComponent<RectTransform>();
        ////rect.gameObject.name = index.ToString();
        rect.anchoredPosition = currentPos;
        if (mEvent.mProvideData != null)
        {
            mEvent.mProvideData(rect.gameObject, index);
        }
        mShowItemList.Add(index, rect);
    }

    private float GetHeightById(int finalId)
    {
        float height = 0;
        int id = finalId;
        height -= Mathf.Abs(mItemStartPos.y);
        height -= id * (mDetailHeight + mSpaceH);
        return height;
    }

    //
    private List<int> GetValuableIds()
    {
        Vector2 contentPos = WorldToScreenPoint(mScrollRect.content.position);
        float spacingTop = contentPos.y - mScrollTopBottomV2.x;  //屏幕顶部到当前content顶部的间距
        float spacingBottom = contentPos.y - mScrollTopBottomV2.y;
        int firstId = GetRangeId(spacingTop);
        int lastId = GetRangeId(spacingBottom) + 2;  //2是为了防止穿帮

        if (lastId > mTotalCount - 1)
        {
            lastId = mTotalCount - 1;
        }
        List<int> list = new List<int>();
        for (int i = firstId; i < lastId + 1; i++)
        {
            list.Add(i);
        }
        return list;
    }
    //获取位置对应的id
    private int GetRangeId(float height)
    {
        height -= Mathf.Abs(mItemStartPos.y);
        float index = height / (mDetailHeight + mSpaceH);
        int indexInt = Mathf.CeilToInt(index);
        indexInt = Mathf.Clamp(indexInt, 1, mTotalCount);
        return indexInt - 1;
    }

    #endregion

    #region 坐标转换
    /////////////////////////////////////////////////////////////////////////////////////////////////
    private float mScreenRatio = 1;  //屏幕坐标缩放尺寸
    //计算屏幕缩放
    private void InitScreenRatio()
    {
        float screenRatio = (float)Screen.width / (float)Screen.height;
        float targetRatio = (float)1920 / (float)1080;
        if (mScreenRatio < targetRatio)
        {
            mScreenRatio = (float)1920 / (float)Screen.width;
        }
        else
        {
            mScreenRatio = (float)1080 / (float)Screen.height;
        }
    }
    //世界坐标转屏幕坐标
    public Vector3 WorldToScreenPoint(Vector3 wprldPos)
    {
        float offset = mScreenRatio;
        Vector3 screenV3 = mUICamera.WorldToScreenPoint(wprldPos); //RectTransformUtility.WorldToScreenPoint(mUICamera, wprldPos);
        return new Vector3(screenV3.x * offset, screenV3.y * offset);
    }
    #endregion
}
