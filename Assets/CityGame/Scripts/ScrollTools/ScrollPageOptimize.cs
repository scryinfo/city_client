//滑动翻页优化，场景中只有固定页的item存在，实现复用

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;


public class ScrollPageEventData
{
    public delegate void DlgInitData(GameObject go, int idx);
    public delegate void DlgClearData(GameObject go);
    public delegate void DlgLeftEnd();
    public delegate void DlgRightEnd();
    public delegate void DlgBtnNomal();

    public DlgInitData mProvideData = null;
    public DlgClearData mClearData = null;
    public DlgLeftEnd mLeftEndFunc = null;
    public DlgRightEnd mRightEndFunc = null;
    public DlgBtnNomal mBtnNomalFunc = null;  //左右按钮正常状态
}

public class ScrollPageOptimize : MonoBehaviour
{
    public GameObject mPageItemPrefab;  //page中的详细item预制
    public ScrollRect mScrollRect;  //

    public int mGridCount = 4;  //每页需要显示的个数
    public Vector2Int mPageRowColV2 = Vector2Int.zero;  //行列数
    public Vector2 mPageHVSpacingV2 = Vector2.zero;  //item在page的左上间距
    public Vector2 mItemSizeData = Vector2.zero;  //item的宽高

    private Dictionary<int, List<GameObject>> mCurrentPageDic = new Dictionary<int, List<GameObject>>();  //当前生成的page
    private int mTotalPageCount = 0;  //总的页数
    private int mTotalItemCount = 0;  //总的item数

    private Vector2 mItemSpacingV2 = Vector2.zero;  //item之间的横纵间隔
    private Vector2 mPageTotalHVV2 = Vector2.zero;  //page的宽高
    private Vector2 mContentPos = Vector2.zero;  //content的位置

    private int mCurrentPageId = 0;  //当前页的Id
    private bool mNeedReuse = false;  //是否需要复用
    private int mInitCreatePage = 3;  //预加载page个数

    private List<int> mShowPageIds = new List<int>();  //应该显示的ids

    private HorizontalScrollSnap mScrollSnap;
    private ScrollPageEventData mEvent = new ScrollPageEventData();

    public int GetTotalPageCount()
    {
        return mTotalPageCount;
    }

    public float GetContentPosXByPage(int pageId)
    {
        return mPageTotalHVV2.x * pageId;
    }

    public int GetCurrentPageId()
    {
        return mCurrentPageId;
    }

    public void InitData(ScrollPageEventData data, int dataCount)
    {
        if (mScrollSnap == null)
        {
            InitGetCompont();
        }

        mEvent = data;
        mTotalItemCount = dataCount;
        InitShowPage();
    }

    public void NextPage()
    {
        SnapNext(mCurrentPageId + 1);
    }

    public void PrevPage()
    {
        SnapPrev(mCurrentPageId - 1);
    }

    private void InitGetCompont()
    {
        mScrollSnap = GetComponent<HorizontalScrollSnap>();
        mScrollSnap.OnTurnToNext = SnapNext;
        mScrollSnap.OnTurnToPrev = SnapPrev;
        mPageTotalHVV2 = mScrollRect.content.sizeDelta;
        mContentPos = new Vector2(0, mPageTotalHVV2.y / 2);
    }

    //初始化数据
    private void InitShowPage()
    {
        mTotalPageCount = Mathf.CeilToInt((float)mTotalItemCount / (float)mGridCount);
        mScrollRect.content.sizeDelta = new Vector2(mPageTotalHVV2.x * mTotalPageCount, mPageTotalHVV2.y);
        mScrollRect.horizontalNormalizedPosition = 0;
        mScrollSnap.InitScrollSnap();

        ScrollPool.GetInstance().InitPool(mPageItemPrefab, mInitCreatePage * mGridCount, mScrollRect.content.transform);
        GetItemSpacing();

        mCurrentPageId = 0;
        int initPage = mTotalPageCount > mInitCreatePage ? mInitCreatePage : mTotalItemCount;
        for (int i = 0; i < initPage; i++)
        {
            CreateItemsByPage(i);
        }
        if (mTotalPageCount > mInitCreatePage)
        {
            mNeedReuse = true;  //需要复用
            for (int i = 0; i < mInitCreatePage; i++)
            {
                mShowPageIds.Add(i);  //需要显示的id
            }
        }

        if (mEvent.mLeftEndFunc != null)
        {
            mEvent.mLeftEndFunc();  //已经到达最左侧
        }
    }

    //计算每个item的间距
    private void GetItemSpacing()
    {
        float x = mPageTotalHVV2.x - mPageHVSpacingV2.x * 2 - mItemSizeData.x;
        float y = mPageTotalHVV2.y - mPageHVSpacingV2.y * 2 - mItemSizeData.y;
        mItemSpacingV2 = new Vector2(x, y);
    }

    //根据页数Id生成page
    private void CreateItemsByPage(int pageIndex)
    {
        if (pageIndex > mTotalPageCount - 1 || pageIndex < 0)
        {
            return;
        }
        if (mCurrentPageDic.ContainsKey(pageIndex))
        {
            return;
        }

        int remainCount = mTotalItemCount - (pageIndex + 1) * mGridCount;
        if (remainCount < 0)
        {
            remainCount = mTotalItemCount % mGridCount;
        }
        else
        {
            remainCount = mGridCount;
        }

        List<GameObject> list = new List<GameObject>();
        int dataIndex = pageIndex * mGridCount;  //起始id
        Vector2 startPos = new Vector2(mPageTotalHVV2.x * pageIndex + mPageHVSpacingV2.x, -mPageHVSpacingV2.y);
        int row = Mathf.CeilToInt((float)remainCount / (float)mPageRowColV2.x);  //行
        int col = remainCount >= mPageRowColV2.y ? mPageRowColV2.y : remainCount;  //列
        for (int i = 0; i < row; i++)
        {
            float posy = startPos.y - mItemSpacingV2.y * i;
            for (int j = 0; j < col; j++)
            {
                if (dataIndex >= mTotalItemCount)
                {
                    break;
                }

                float posx = startPos.x + mItemSpacingV2.x * j;
                RectTransform rect = ScrollPool.GetInstance().GetValuableItem(mPageItemPrefab.name).GetComponent<RectTransform>();
                if (mEvent.mProvideData != null)
                {
                    mEvent.mProvideData(rect.gameObject, dataIndex);
                    list.Add(rect.gameObject);
                }

                rect.anchoredPosition = new Vector2(posx, posy);
                dataIndex++;
            }
        }
        mCurrentPageDic.Add(pageIndex, list);
    }

    private void MoveToPage(int pageIndex)
    {
        if (pageIndex > mTotalPageCount - 1 || pageIndex < 0)
        {
            return;
        }
        mScrollRect.content.DOAnchorPosX(-mPageTotalHVV2.x * pageIndex, 0.5f);
    }

    //匹配Snap下一页
    private void SnapNext(int targetPage)
    {
        if (mEvent.mBtnNomalFunc != null)
        {
            mEvent.mBtnNomalFunc();
        }
        if (targetPage == mTotalPageCount - 1 && mEvent.mRightEndFunc != null)
        {
            mEvent.mRightEndFunc();  //已经到达最右侧
        }

        targetPage = targetPage > mTotalPageCount - 1 ? mTotalPageCount - 1 : targetPage;  //判断是否是尾部
        CreateItemsByPage(targetPage);
        MoveToPage(targetPage);  //移动定位

        if (mNeedReuse)
        {
            int first = targetPage - 1;
            if (first < 0)
            {
                for (int i = 0; i < mInitCreatePage; i++)
                {
                    mShowPageIds.Add(i);
                }
                CheckDicAndShowList();
                mCurrentPageId = targetPage;
                return;
            }

            int end = targetPage + 1;
            if (end > mTotalPageCount - 1)
            {
                end = targetPage - 2;
            }
            mShowPageIds = new List<int>() { first, targetPage, end };
            CheckDicAndShowList();
        }
        mCurrentPageId = targetPage;
    }
    //匹配Snap上一页
    private void SnapPrev(int targetPage)
    {
        if (mEvent.mBtnNomalFunc != null)
        {
            mEvent.mBtnNomalFunc();
        }
        if (targetPage == 0 && mEvent.mLeftEndFunc != null)
        {
            mEvent.mLeftEndFunc();  //已经到达最左侧
        }

        targetPage = targetPage > 0 ? targetPage : 0;
        CreateItemsByPage(targetPage);
        MoveToPage(targetPage);

        if (mNeedReuse)
        {
            int first = targetPage - 1;
            if (first < 0)
            {
                for (int i = 0; i < mInitCreatePage; i++)
                {
                    mShowPageIds.Add(i);
                }
                CheckDicAndShowList();
                mCurrentPageId = targetPage;
                return;
            }

            int end = targetPage + 1;
            if (end > mTotalItemCount - 1)
            {
                end = targetPage - 2;
            }
            mShowPageIds = new List<int>() { first, targetPage, end };
            CheckDicAndShowList();
        }
        mCurrentPageId = targetPage;
    }

    private void CheckDicAndShowList()
    {
        List<int> ids = new List<int>();
        foreach (var item in mCurrentPageDic)
        {
            if (!mShowPageIds.Contains(item.Key))
            {
                ids.Add(item.Key);
            }
        }
        for (int i = 0; i < ids.Count; i++)
        {
            ItemsReturnToPool(mCurrentPageDic[ids[i]]);
            mCurrentPageDic.Remove(ids[i]);
        }
        for (int i = 0; i < mShowPageIds.Count; i++)
        {
            if (!mCurrentPageDic.ContainsKey(mShowPageIds[i]))
            {
                CreateItemsByPage(mShowPageIds[i]);
            }
        }
    }

    private void ItemsReturnToPool(List<GameObject> list)
    {
        for (int i = 0; i < list.Count; i++)
        {
            ScrollPool.GetInstance().ReturnToPool(list[i].gameObject);
            if (mEvent.mClearData != null)
            {
                mEvent.mClearData(list[i]);
            }
        }
        list = new List<GameObject>();
    }
}
