

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;


public class ScrollForecast : MonoBehaviour, IPointerDownHandler, IDragHandler, IBeginDragHandler
{
    [SerializeField]
    private float mDragMoveHeight = 50;

    [SerializeField]
    private GameObject mTempRightPrefab;
    [SerializeField]
    private FlightScrollTool mScrollPos;
    private RectTransform mRect;

    private List<string> mTempRightConfig;
    private List<Vector3> mRightTempPos;  //UGUI coordinates of the item on the right

    private float mScreenRatio = 1;  //Screen coordinate scaling
    private int mRightSelectId = 0;  //Id selected in the right navigation bar

    private float mDragDir = 0;  //Sliding direction
    private Vector2 mCurrentPointPos = Vector2.zero;  //current position
    private List<GameObject> mObjList = new List<GameObject>();

    //delta is the distance moved in a period of time, + represents upward movement,-represents downward movement, the faster the stroke, the greater the absolute value of delta
    void IBeginDragHandler.OnBeginDrag(PointerEventData eventData)
    {
        mCurrentPointPos = eventData.position;
    }
    void IDragHandler.OnDrag(PointerEventData eventData)
    {
        DragFunc(eventData);
    }
    void IPointerDownHandler.OnPointerDown(PointerEventData eventData)
    {
        PointDownFunc(eventData);
    }

    private bool mInitFinish = false;
    private void InitComponent()
    {
        ScrollPool.GetInstance().InitPool(mTempRightPrefab, 26, transform);
    }

    public void InitData(float screenRatio, string[] value)
    {
        if (mInitFinish == false)
        {
            InitComponent();
            mInitFinish = true;
        }

        if (mRect == null)
        {
            mRect = transform.GetComponent<RectTransform>();
        }
        mScreenRatio = screenRatio;
        mTempRightConfig = new List<string>(value);
        CreateRight(mTempRightConfig, mRect.rect.size.y);
    }

    public void CleanAll()
    {
        foreach (var item in mObjList)
        {
            ScrollPool.GetInstance().ReturnToPool(item);
        }
    }

    //Create right navigation
    private void CreateRight(List<string> list, float totalHeight)
    {
        if (mTempRightPrefab == null)
            return;

        float elmH = totalHeight / list.Count;  //The height of a single elm
        float pos = elmH / 2;
        mRightTempPos = new List<Vector3>();

        for (int i = 0; i < list.Count; i++)
        {
            ////GameObject go = Instantiate(mTempRightPrefab);  //Use the object pool to do it, or destroy it when exiting the page
            GameObject go = ScrollPool.GetInstance().GetValuableItem(mTempRightPrefab.name);
            go.transform.SetParent(transform);
            go.transform.localScale = Vector3.one;
            mObjList.Add(go);
            Text temp = go.GetComponent<Text>();
            temp.rectTransform.anchoredPosition = new Vector3(0, -pos, 0);
            temp.text = list[i];
            pos += elmH;
            Vector3 uiPos = mScrollPos.WorldToScreenPoint(go.transform.position);
            mRightTempPos.Add(uiPos);
        }
    }

    //Press
    private void PointDownFunc(PointerEventData eventData)
    {
        float min = 1000;
        int selectIndex = 0;
        for (int i = 0; i < mRightTempPos.Count; i++)
        {
            float temp = Mathf.Abs(Mathf.Abs(eventData.position.y) - Mathf.Abs(mRightTempPos[i].y));
            if (temp < min)
            {
                selectIndex = i;
                min = temp;
            }
        }
        mRightSelectId = selectIndex;
        PosIndexOnce(mRightSelectId);
    }

    //slide
    private void DragFunc(PointerEventData eventData)
    {
        if (eventData.delta.y == 0)
        {
            mDragDir = 0;
            mCurrentPointPos = eventData.position;
            return;
        }
        float currentDir = eventData.delta.y > 0 ? 1 : -1;
        //In the same direction
        if ((currentDir > 0 && mDragDir >= 0) || (currentDir < 0 && mDragDir <= 0))
        {
            Vector2 pos = eventData.position;
            float moveSpacing = Mathf.Abs(Mathf.Abs(mCurrentPointPos.y) - Mathf.Abs(pos.y));
            if (moveSpacing > mDragMoveHeight)
            {
                int step = (int)(moveSpacing / mDragMoveHeight);
                step = currentDir > 0 ? step : -step;
                GoIndex(-step);
                mCurrentPointPos = eventData.position;
            }
        }
        else
        {
            mCurrentPointPos = eventData.position;  //If the direction is different, reset the initial value
        }
        mDragDir = currentDir;
    }

    private void GoIndex(int step)
    {
        if (step == 0)
            return;
        int once = step > 0 ? 1 : -1;
        float targetIndex = mRightSelectId + step;
        while (targetIndex != mRightSelectId)
        {
            mRightSelectId += once;
            if (mRightSelectId < 0 || mRightSelectId > mTempRightConfig.Count - 1)
            {
                return;
            }
            PosIndexOnce(mRightSelectId);
        }
    }

    //Position, move to a certain value
    private void PosIndexOnce(int targetIndex)
    {
        if (mScrollPos != null)
        {
            mScrollPos.PosTargetIndex(targetIndex);
        }
    }
}
