//Sliding multiplexing

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


public class VScrollLoopTool : MonoBehaviour
{
    public GameObject mPrefab;  //Prefab
    public ScrollRect mScrollRect;
    public float mSpaceH = 6;  //interval
    public Vector2 mItemStartPos = new Vector2(-130, -45);  //Starting position
    
    private float mDetailHeight;  //Prefabricated actual height
    private Camera mUICamera;
    private RectTransform mContentRect;
    private Vector2 mScrollTopBottomV2 = Vector2.zero;  //Screen coordinates y at the top and bottom of scroll
    private float mContentHeight;  //content height
    private int mTotalCount;

    ////private List<Vector2> mContentPosList = new List<Vector2>();  //Positioning needs to be used
    private Dictionary<int, RectTransform> mShowItemList = new Dictionary<int, RectTransform>();  //Item displayed on the screen
    private VScrollEventData mEvent = new VScrollEventData();

    //Initialize settings
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

    //Get specific data and start generating
    public void InitData(int totalCount)
    {
        mTotalCount = totalCount;
        float height = 0;
        height += mTotalCount * (mDetailHeight + mSpaceH);
        mContentRect.sizeDelta = new Vector2(mContentRect.sizeDelta.x, height);
        mScrollRect.content.anchoredPosition = Vector2.zero;  //Calculate content height and initialize content position
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

    //Get the top and bottom screen coordinates of Scroll
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
        List<int> ids = GetValuableIds();  //Ids to be displayed on the screen
        Dictionary<int, float> idPosy = new Dictionary<int, float>();  //id height

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
                    CreateItem(item.Key, new Vector2(mItemStartPos.x, item.Value));  //Need to increase
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

    //Add item
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
        float spacingTop = contentPos.y - mScrollTopBottomV2.x;  //The distance from the top of the screen to the top of the current content
        float spacingBottom = contentPos.y - mScrollTopBottomV2.y;
        int firstId = GetRangeId(spacingTop);
        int lastId = GetRangeId(spacingBottom) + 2;  //2 is to prevent wearing

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
    //Get the id corresponding to the location
    private int GetRangeId(float height)
    {
        height -= Mathf.Abs(mItemStartPos.y);
        float index = height / (mDetailHeight + mSpaceH);
        int indexInt = Mathf.CeilToInt(index);
        indexInt = Mathf.Clamp(indexInt, 1, mTotalCount);
        return indexInt - 1;
    }

    #endregion

    #region Coordinate conversion
    /////////////////////////////////////////////////////////////////////////////////////////////////
    private float mScreenRatio = 1;  //Screen coordinate scaling
    //Calculate screen zoom
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
    //World coordinates to screen coordinates
    public Vector3 WorldToScreenPoint(Vector3 wprldPos)
    {
        float offset = mScreenRatio;
        Vector3 screenV3 = mUICamera.WorldToScreenPoint(wprldPos); //RectTransformUtility.WorldToScreenPoint(mUICamera, wprldPos);
        return new Vector3(screenV3.x * offset, screenV3.y * offset);
    }
    #endregion
}
