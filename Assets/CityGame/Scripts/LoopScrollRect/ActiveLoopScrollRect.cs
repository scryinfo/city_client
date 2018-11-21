

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
    public void ActiveLoopScroll(LoopScrollDataSource data, int totalCount = 0)
    {
        if (mLoopScrollRect == null)
        {
            mLoopScrollRect = GetComponent<LoopScrollRect>();
        }

        if (mLoopScrollRect.GetInstance() == null)
        {
            mLoopScrollRect.SetInstance(data);
            mLoopScrollRect.totalCount = totalCount;
        }
        else
        {
            mLoopScrollRect.totalCount = totalCount;
            mLoopScrollRect.RefreshCells();
        }
    }

    /// <summary>
    /// 初始化 滑动中存在不同预制的item
    /// </summary>
    /// <param name="data">委托方法</param>
    /// <param name="diffPrefabNameList">预制名字顺序表</param>
    //public void ActiveDiffItemLoop(LoopScrollDataSource data, List<string> diffPrefabNameList = null)
    //{
    //    if (mLoopScrollRect == null)
    //    {
    //        mLoopScrollRect = GetComponent<LoopScrollRect>();
    //    }
    //    if (diffPrefabNameList != null)
    //    {
    //        mLoopScrollRect.SetLoopDiffPrefabSource(diffPrefabNameList);
    //    }
    //    if (mLoopScrollRect.GetInstance() == null)
    //    {
    //        mLoopScrollRect.SetInstance(data);
    //        mLoopScrollRect.totalCount = diffPrefabNameList.Count;
    //    }
    //    else
    //    {
    //        mLoopScrollRect.totalCount = diffPrefabNameList.Count;
    //        mLoopScrollRect.RefreshCells();
    //    }
    //}

    public void ActiveDiffItemLoop(LoopScrollDataSource data, string[] diffPrefabNameList = null)
    {
        if (mLoopScrollRect == null)
        {
            mLoopScrollRect = GetComponent<LoopScrollRect>();
        }
        if (diffPrefabNameList != null)
        {
            List<string> tempList = new List<string>();
            for (int i = 0; i < diffPrefabNameList.Length; i++)
            {
                tempList.Add(diffPrefabNameList[i]);
            }
            mLoopScrollRect.SetLoopDiffPrefabSource(tempList);
        }
        if (mLoopScrollRect.GetInstance() == null)
        {
            mLoopScrollRect.SetInstance(data);
            mLoopScrollRect.totalCount = diffPrefabNameList.Length;
        }
        else
        {
            mLoopScrollRect.totalCount = diffPrefabNameList.Length;
            mLoopScrollRect.RefreshCells();
        }
    }
}
