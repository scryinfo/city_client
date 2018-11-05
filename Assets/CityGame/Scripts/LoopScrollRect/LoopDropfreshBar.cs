//滑动复用，使用bar的下拉刷新
//未完善，当一只手指滑到限定位置之后，未离开滑动相应区域，另一只手接着滑动
//这种情况在该版本未限制
//xuyafang


using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LoopDropfreshBar : MonoBehaviour
{
    public delegate void DlgOnLoopDropRefresh();
    public DlgOnLoopDropRefresh mOnDropfresh = null;

    public float dropfreshPercent = 0.75f;  //下拉多少百分比算是刷新

    private float mMaxBarSizeValue = -1;

    /// <summary>
    /// 设置bar的size最大值
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
    /// 在scrollrect 结束drag时判断size是否达到预期
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

    //初始化
    public void InitDropFresh(float dropPercent)
    {
        dropfreshPercent = dropPercent;

        //测试
        if (mOnDropfresh != null)
        {
            mOnDropfresh();
        }
    }
}
