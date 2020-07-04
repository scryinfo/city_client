

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
            mLoopScrollRect = GetComponent<LoopScrollRect>();  //Get components
        }
    }
    
    /// <summary>
    /// Initialization module
    /// </summary>
    /// <param name="data">Delegate method</param>
    /// <param name="totalCount">Total, default is 0</param>
    public void ActiveLoopScroll(LoopScrollDataSource data, int totalCount = 0, string prefabName = "")
    {
        if (mLoopScrollRect == null)
        {
            mLoopScrollRect = GetComponent<LoopScrollRect>();
        }
        if (prefabName != "")
        {
            mLoopScrollRect.SetLoopNomalPrefabSource(prefabName);
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
    /// There are different prefabricated items in the sliding
    /// </summary>
    /// <param name="data">Delegate method</param>
    /// <param name="diffPrefabNameList">Pre-made name sequence table</param>
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
            mLoopScrollRect.RefreshDiffCells();
        }
    }

    public void RefillCells()
    {
        if (mLoopScrollRect != null)
        {
            mLoopScrollRect.RefillCells();
        }
    }
}
