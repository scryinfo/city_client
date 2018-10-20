

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


public class ActiveLoopScrollRect : MonoBehaviour
{
    private LoopScrollRect mLoopScrollRect = null;

    private void Start()
    {
        if (mLoopScrollRect == null)
        {
            mLoopScrollRect = GetComponent<LoopScrollRect>();  //获取组件
        }
    }
    
    /// <summary>
    /// 初始化组件
    /// </summary>
    /// <param name="data">委托方法</param>
    /// <param name="totalCount">总数，默认为0</param>
    public void InitLoopScroll(LoopScrollDataSource data, int totalCount = 0)
    {
        if (mLoopScrollRect == null)
        {
            mLoopScrollRect = GetComponent<LoopScrollRect>();
        }

        mLoopScrollRect.SetInstance(data);
        mLoopScrollRect.totalCount = totalCount;
    }

    /// <summary>
    /// 刷新item
    /// </summary>
    /// <param name="totalCount"></param>
    public void RefreshItems(int totalCount)
    {
        mLoopScrollRect.totalCount = totalCount;
        mLoopScrollRect.RefreshCells();
    }
}
