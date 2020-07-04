

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


public class VScrollEventData
{
    public delegate void DlgInitData(GameObject go, int idx);
    public delegate void DlgClearData(GameObject go);

    public DlgInitData mProvideData = null;
    public DlgClearData mClearData = null;
}

public class FlightScrollTool : MonoBehaviour
{
    public GameObject mLeftPrefab;  //Prefabricated on the left
    public GameObject mLeftTitlePrefab;  //Prefab on the left
    public ScrollRect mScrollRect;
    public ScrollForecast mScrollForecast;

    public float mTitleHeight = 60;
    public float mDetailHeight = 80;
    public float mDetailSpaceH = 6;  //interval
    public Vector2 mItemStartPos = new Vector2(-130, -45);

    private Camera mUICamera;
    private RectTransform mContentRect;
    private Vector2 mScrollTopBottomV2 = Vector2.zero;  //Screen coordinates y at the top and bottom of scroll
    private float mContentHeight;  //content height

    private string[] mTempTitleConfig;  //Index character list
    private Dictionary<string, string[]> mTempDetailConfig = new Dictionary<string, string[]>();  //key is the letter index, list is the specific character
    private List<string> mDetailConfig = new List<string>();  //A collection of all characters, in order
    private List<int> mDetailChangeIdList = new List<int>();  //Need to switch position id
    private List<Vector2> mContentPosList = new List<Vector2>();  //Positioning needs to be used

    private Dictionary<int, RectTransform> mShowItemList = new Dictionary<int, RectTransform>();  //Item displayed on the screen
    private List<GameObject> mTitleObjs = new List<GameObject>();  //title obj
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
        ScrollPool.GetInstance().InitPool(mLeftPrefab, 10, mScrollRect.content.transform);
        ScrollPool.GetInstance().InitPool(mLeftTitlePrefab, 26, mScrollRect.content.transform);
        mScrollRect.onValueChanged.AddListener(OnScrollFunc);
        mContentRect = mScrollRect.content;
        mEvent = func;
    }

    //Get specific data and start generating
    public void InitData(Dictionary<string, string[]> detailDic, string[] titleStr)
    {
        if (titleStr != mTempTitleConfig)
        {
            mTempDetailConfig = detailDic;
            mTempTitleConfig = titleStr;
            mDetailChangeIdList.Add(mDetailConfig.Count);
            for (int i = 0; i < titleStr.Length; i++)
            {
                List<string> temp = new List<string>(detailDic[titleStr[i]]);
                mDetailConfig.AddRange(temp);
                mDetailChangeIdList.Add(mDetailConfig.Count);
            }
            mScrollForecast.InitData(mScreenRatio, titleStr);

            CreateTitleItems();  //Create items on the left
            CalculateShowIds();  //
        }
    }

    public void CleanAll()
    {
        for (int i = 0; i < mTitleObjs.Count; i++)
        {
            ScrollPool.GetInstance().ReturnToPool(mTitleObjs[i]);
        }
        mTitleObjs = new List<GameObject>();
        foreach (var item in mShowItemList)
        {
            ScrollPool.GetInstance().ReturnToPool(item.Value.gameObject);
        }
        mShowItemList = new Dictionary<int, RectTransform>();
        mScrollForecast.CleanAll();
        mDetailConfig = new List<string>();
        mDetailChangeIdList = new List<int>();
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

    private void CreateTitleItems()
    {
        float height = 0;
        for (int i = 0; i < mTempTitleConfig.Length; i++)
        {
            height += mTempDetailConfig[mTempTitleConfig[i]].Length * (mDetailHeight + mDetailSpaceH) + mTitleHeight;
        }
        mContentRect.sizeDelta = new Vector2(mContentRect.sizeDelta.x, height);
        mScrollRect.content.anchoredPosition = Vector2.zero;  //Calculate content height and initialize content position
        mContentHeight = height;

        Vector2 currentPos = mItemStartPos;
        for (int i = 0; i < mTempTitleConfig.Length; i++)
        {
            GameObject go = ScrollPool.GetInstance().GetValuableItem(mLeftTitlePrefab.name);
            go.GetComponent<RectTransform>().anchoredPosition = currentPos;
            go.transform.Find("valueText").GetComponent<Text>().text = mTempTitleConfig[i];
            mContentPosList.Add(currentPos);
            mTitleObjs.Add(go);
            currentPos.y -= mTitleHeight + (mDetailHeight + mDetailSpaceH) * mTempDetailConfig[mTempTitleConfig[i]].Length;
        }
    }

    public void PosTargetIndex(int targetIndex)
    {
        if (targetIndex < 0 || targetIndex > mDetailConfig.Count)
            return;
        mScrollRect.content.anchoredPosition = new Vector2(0, -(mContentPosList[targetIndex].y - mItemStartPos.y));
    }

    #region Each frame determines the required items in the area
    //
    private void CalculateShowIds()
    {
        List<int> ids = GetValuableIds();  //Ids to be displayed on the screen
        Dictionary<int, float> idPosy = new Dictionary<int, float>();  //id height

        float startPosY = GetHeightById(ids[0]);
        idPosy.Add(ids[0], startPosY);
        for (int i = ids[0] + 1; i < ids[ids.Count - 1] + 1; i++)
        {
            if (!mDetailChangeIdList.Contains(i))  //If the first letter is different, you need to add the height of the title
            {
                startPosY -= mDetailHeight + mDetailSpaceH;
            }
            else
            {
                startPosY -= mDetailHeight + mDetailSpaceH + mTitleHeight;
            }
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
        RectTransform rect = ScrollPool.GetInstance().GetValuableItem(mLeftPrefab.name).GetComponent<RectTransform>();
        ////rect.gameObject.name = index.ToString();
        rect.anchoredPosition = currentPos;
        if (mEvent.mProvideData != null)
        {
            mEvent.mProvideData(rect.gameObject, index);
            ////rect.transform.Find("Text").GetComponent<Text>().text = index.ToString();
        }
        mShowItemList.Add(index, rect);
    }

    private float GetHeightById(int finalId)
    {
        float height = 0;
        int id = finalId;
        height -= Mathf.Abs(mItemStartPos.y);
        for (int i = 0; i < mTempTitleConfig.Length; i++)
        {
            height -= mTitleHeight;
            int detailCount = mTempDetailConfig[mTempTitleConfig[i]].Length;
            if (id <= detailCount - 1)  //If id <= detailCount, meet the demand
            {
                height -= id * (mDetailHeight + mDetailSpaceH);
                return height;
            }
            height -= detailCount * (mDetailHeight + mDetailSpaceH);
            id -= detailCount;
        }
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
        if (lastId > mDetailConfig.Count - 1)
        {
            lastId = mDetailConfig.Count - 1;
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
        int id = 0;
        height -= Mathf.Abs(mItemStartPos.y);
        for (int i = 0; i < mTempTitleConfig.Length; i++)
        {
            int detailCount = mTempDetailConfig[mTempTitleConfig[i]].Length;
            height -= mTitleHeight;
            float index = height / (mDetailHeight + mDetailSpaceH);
            int indexInt = Mathf.CeilToInt(index);
            if (indexInt < detailCount)  //If id <detailCount, meet the demand
            {
                if (id + indexInt - 1 < 0)
                    return 0;
                return id + indexInt - 1;
            }
            id += detailCount;
            height -= (mDetailHeight + mDetailSpaceH) * detailCount;
        }

        return id;
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
