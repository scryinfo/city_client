

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
    /// 激活滑动组件
    /// </summary>
    /// <param name="data">数据层，传入继承自LoopScrollDataSource 的lua实例</param>
    /// <param name="totalCount">生成的总个数</param>
    public void ActiveScroll(LoopScrollDataSource data, int totalCount)
    {
        if (mLoopScrollRect == null)
        {
            mLoopScrollRect = GetComponent<LoopScrollRect>();
        }

        mLoopScrollRect.SetInstance(data);
        mLoopScrollRect.totalCount = totalCount;
    }

    public void RefillCells(int totalCount)
    {
        mLoopScrollRect.totalCount = totalCount;
        mLoopScrollRect.RefreshCells();
    }
}
