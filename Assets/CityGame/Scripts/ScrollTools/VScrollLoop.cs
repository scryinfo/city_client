

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

public class VScrollLoop : MonoBehaviour
{
    public GameObject mLeftPrefab;  //左侧预制
    public GameObject mLeftTitlePrefab;  //左侧标题预制
    public ScrollRect mScrollRect;
    public ScrollForecast mScrollForecast;

    public float mTitleHeight = 60;
    public float mDetailHeight = 80;
    public float mDetailSpaceH = 6;  //间隔
    public Vector2 mItemStartPos = new Vector2(-130, -45);

    private Camera mUICamera;
    private RectTransform mContentRect;
    private Vector2 mScrollTopBottomV2 = Vector2.zero;  //scroll顶部底部的屏幕坐标y
    private float mContentHeight;  //content的高度

    private string[] mTempTitleConfig;  //索引字符list
    private Dictionary<string, string[]> mTempDetailConfig = new Dictionary<string, string[]>();  //key 为字母索引，list为具体字符
    private List<string> mDetailConfig = new List<string>();  //包含所有字符的集合，按顺序排列
    private List<Vector2> mContentPosList = new List<Vector2>();  //定位需要用到

    private Dictionary<int, RectTransform> mShowItemList = new Dictionary<int, RectTransform>();  //在屏幕显示的item
    private List<GameObject> mTitleObjs = new List<GameObject>();  //title obj
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
        ScrollPool.GetInstance().InitPool(mLeftPrefab, 10, mScrollRect.content.transform);
        ScrollPool.GetInstance().InitPool(mLeftTitlePrefab, 26, mScrollRect.content.transform);
        mScrollRect.onValueChanged.AddListener(OnScrollFunc);
        mContentRect = mScrollRect.content;
        mEvent = func;
    }

    //拿到具体数据开始生成
    public void InitData(Dictionary<string, string[]> detailDic, string[] titleStr)
    {
        if (titleStr != mTempTitleConfig)
        {
            mTempDetailConfig = detailDic;
            mTempTitleConfig = titleStr;
            for (int i = 0; i < titleStr.Length; i++)
            {
                List<string> temp = new List<string>(detailDic[titleStr[i]]);
                mDetailConfig.AddRange(temp);
            }
            mScrollForecast.InitData(mScreenRatio, titleStr);

            CreateTitleItems();  //创建左侧items
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

    private void CreateTitleItems()
    {
        float height = 0;
        for (int i = 0; i < mTempTitleConfig.Length; i++)
        {
            height += mTempDetailConfig[mTempTitleConfig[i]].Length * (mDetailHeight + mDetailSpaceH) + mTitleHeight;
        }
        mContentRect.sizeDelta = new Vector2(mContentRect.sizeDelta.x, height);
        mScrollRect.content.anchoredPosition = Vector2.zero;  //计算content高度以及初始化content位置
        mContentHeight = height;

        Vector2 currentPos = mItemStartPos;
        for (int i = 0; i < mTempTitleConfig.Length; i++)
        {
            GameObject go = ScrollPool.GetInstance().GetValuableItem(mLeftTitlePrefab.name);
            go.GetComponent<RectTransform>().anchoredPosition = currentPos;
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
            if (mDetailConfig[i - 1][0] == mDetailConfig[i][0])  //如果首字母不一样，则需要加上title的高度
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
        RectTransform rect = ScrollPool.GetInstance().GetValuableItem(mLeftPrefab.name).GetComponent<RectTransform>();
        ////rect.gameObject.name = index.ToString();
        rect.anchoredPosition = currentPos;
        if (mEvent.mProvideData != null)
        {
            mEvent.mProvideData(rect.gameObject, index);
            rect.transform.Find("Text").GetComponent<Text>().text = index.ToString();
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
            if (id <= detailCount - 1)  //如果id <= detailCount，则满足需求
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
        float spacingTop = contentPos.y - mScrollTopBottomV2.x;  //屏幕顶部到当前content顶部的间距
        float spacingBottom = contentPos.y - mScrollTopBottomV2.y;
        int firstId = GetRangeId(spacingTop);
        int lastId = GetRangeId(spacingBottom) + 2;  //2是为了防止穿帮
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
    //获取位置对应的id
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
            if (indexInt < detailCount)  //如果id < detailCount，则满足需求
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

    #region 坐标转换
    /////////////////////////////////////////////////////////////////////////////////////////////////
    private float mScreenRatio = 1;  //屏幕坐标缩放尺寸
    //计算屏幕缩放
    private void InitScreenRatio()
    {
        float screenRatio = Screen.width / Screen.height;
        float targetRatio = 1920 / 1080;
        if (mScreenRatio < targetRatio)
        {
            mScreenRatio = 1920 / Screen.width;
        }
        else
        {
            mScreenRatio = 1080 / Screen.height;
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
