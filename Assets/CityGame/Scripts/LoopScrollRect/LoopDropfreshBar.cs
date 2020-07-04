//Slide multiplexing, use bar to pull down to refresh
//Not perfect, when one finger slides to a limited position, it does not leave the corresponding area of the slide, the other hand then slides
//This situation is not restricted in this version


using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LoopDropfreshBar : MonoBehaviour
{
    public delegate void DlgOnLoopDropRefresh();
    public DlgOnLoopDropRefresh mOnDropfresh = null;

    public float dropfreshPercent = 0.75f;  //What percentage of the drop down is considered refresh

    private float mMaxBarSizeValue = -1;

    /// <summary>
    /// Set the maximum size of bar
    /// </summary>
    /// <param name="barSizeValue"></param>
    public void SetBarMaxSizeValue(float barSizeValue)
    {
        if (mMaxBarSizeValue == -1)
        {
            mMaxBarSizeValue = barSizeValue;
            Debug.Log("初始化bar value：" + mMaxBarSizeValue);
        }
    }

    /// <summary>
    /// Determine whether the size reaches the expected value when the scrollrect ends the drag
    /// </summary>
    public void JudgeDropfreshOnEndDrag(float barValue, float barSize)
    {
        if (barValue == 0 && barSize < mMaxBarSizeValue * dropfreshPercent)
        {
            if (mOnDropfresh != null)
            {
                mOnDropfresh();
            }
        }
    }

    //initialization
    public void InitDropFresh(float dropPercent)
    {
        dropfreshPercent = dropPercent;

        //test
        if (mOnDropfresh != null)
        {
            mOnDropfresh();
        }
    }
}
