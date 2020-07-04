//Sliding snap

using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;


[RequireComponent(typeof(ScrollRect))]
public class HorizontalScrollSnap : MonoBehaviour, IBeginDragHandler, IEndDragHandler, IDragHandler
{
    public delegate void DlgPageChange(int targetPage);
    public DlgPageChange OnTurnToNext;
    public DlgPageChange OnTurnToPrev;

    private int mTotalPage = 1;

    private bool fastSwipeTimer = false;
    private int fastSwipeCounter = 0;
    private int fastSwipeTarget = 30;

    private List<Vector2> mContentPos = new List<Vector2>();
    private ScrollRect mScrollRect;
    private Vector2 mtargetPos;
    private bool lerp;

    public Boolean UseFastSwipe = true;
    public int FastSwipeThreshold = 20;

    private bool startDrag = true;
    private Vector2 mStartPosition = Vector2.zero;
    private int mCurrentPage;
    public float mSpeed = 10;
    private bool fastSwipe = false;

    private ScrollPageOptimize mTempPage;
    private RectTransform mContent;

    void Awake()
    {
        mScrollRect = gameObject.GetComponent<ScrollRect>();
        mContent = mScrollRect.content;
        mTempPage = GetComponent<ScrollPageOptimize>();
    }

    public void InitScrollSnap()
    {
        DistributePages();
        ChangeBulletsInfo(0);

        mTotalPage = mTempPage.GetTotalPageCount();
        lerp = false;

        if (mTotalPage > 0)
        {
            for (int i = 0; i < mTotalPage; ++i)
            {
                Debug.Log("value: " + (float)i / (float)(mTotalPage - 1));
                Debug.Log("index: " + mTempPage.GetContentPosXByPage(i));

                mContentPos.Add(new Vector2(-mTempPage.GetContentPosXByPage(i), 0));
            }
        }
    }

    void Update()
    {
        if (lerp)
        {
            mContent.anchoredPosition = Vector2.Lerp(mContent.anchoredPosition, mtargetPos, mSpeed * Time.deltaTime);
            if (Vector2.Distance(mContent.anchoredPosition, mtargetPos) < 0.001f)
            {
                lerp = false;
            }

            //change the info bullets at the bottom of the screen. Just for visual effect
            if (Vector2.Distance(mContent.anchoredPosition, mtargetPos) < 10f)
            {
                ChangeBulletsInfo(CurrentScreen());
            }
        }

        if (fastSwipeTimer)
        {
            fastSwipeCounter++;
        }
    }

    //Next page
    public void NextScreen()
    {
        if (CurrentScreen() < mTotalPage - 1)
        {
            lerp = true;
            mtargetPos = mContentPos[CurrentScreen() + 1];

            ChangeBulletsInfo(CurrentScreen() + 1);
            OnTurnToNext(CurrentScreen() + 1);
        }
    }

    //Previous
    public void PreviousScreen()
    {
        if (CurrentScreen() > 0)
        {
            Debug.Log(CurrentScreen());
            lerp = true;
            mtargetPos = mContentPos[CurrentScreen() - 1];

            ChangeBulletsInfo(CurrentScreen() - 1);
            OnTurnToPrev(CurrentScreen() - 1);
        }
    }

    private void NextScreenCommand()
    {
        if (mCurrentPage < mTotalPage - 1)
        {
            lerp = true;
            mtargetPos = mContentPos[mCurrentPage + 1];

            ChangeBulletsInfo(mCurrentPage + 1);
            OnTurnToNext(CurrentScreen() + 1);
        }
    }
    private void PrevScreenCommand()
    {
        if (mCurrentPage > 0)
        {
            lerp = true;
            mtargetPos = mContentPos[mCurrentPage - 1];

            ChangeBulletsInfo(mCurrentPage - 1);
            OnTurnToPrev(CurrentScreen() - 1);
        }
    }

    //Get the coordinates back to the specified position
    private Vector2 FindClosestFrom(Vector2 start, List<Vector2> positions)
    {
        Vector2 closest = Vector2.zero;
        float distance = Mathf.Infinity;

        foreach (Vector2 item in positions)
        {
            if (Vector2.Distance(start, item) < distance)
            {
                distance = Vector2.Distance(start, item);
                closest = item;
            }
        }

        return closest;
    }

    //Returns the logo index of the current screen
    public int CurrentScreen()
    {
        int index = mTempPage.GetCurrentPageId();
        return index;
    }
    //Change the bottom logo
    private void ChangeBulletsInfo(int currentScreen)
    {

    }

    //Change based on item resolution-coordinates and position of screensContainer sub-object
    private void DistributePages()
    {

    }

    #region Interfaces
    public void OnBeginDrag(PointerEventData eventData)
    {
        mStartPosition = mContent.anchoredPosition;
        mCurrentPage = CurrentScreen();
        fastSwipeCounter = 0;
        fastSwipeTimer = true;
    }

    public void OnEndDrag(PointerEventData eventData)
    {
        startDrag = true;
        if (mScrollRect.horizontal)
        {
            if (UseFastSwipe)
            {
                fastSwipe = false;
                fastSwipeTimer = false;
                if (fastSwipeCounter <= fastSwipeTarget)
                {
                    if (Math.Abs(mStartPosition.x - mContent.anchoredPosition.x) > FastSwipeThreshold)
                    {
                        fastSwipe = true;
                    }
                }
                if (fastSwipe)
                {
                    if (mStartPosition.x - mContent.anchoredPosition.x > 0)
                    {
                        NextScreenCommand();
                    }
                    else
                    {
                        PrevScreenCommand();
                    }
                }
                else
                {
                    lerp = true;
                    mtargetPos = FindClosestFrom(mContent.anchoredPosition, mContentPos);
                }
            }
            else
            {
                lerp = true;
                mtargetPos = FindClosestFrom(mContent.anchoredPosition, mContentPos);
            }
        }
    }

    public void OnDrag(PointerEventData eventData)
    {
        lerp = false;
        if (startDrag)
        {
            OnBeginDrag(eventData);
            startDrag = false;
        }
    }
    #endregion
}
