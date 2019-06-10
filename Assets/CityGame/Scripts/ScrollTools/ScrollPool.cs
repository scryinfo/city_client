//简易池

using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class ScrollPool
{
    private static ScrollPool mInstance = null;

    public static ScrollPool GetInstance()
    {
        if (mInstance == null)
        {
            mInstance = new ScrollPool();
        }
        return mInstance;
    }

    private Dictionary<string, ScrollPoolItem> mPoolDic = new Dictionary<string, ScrollPoolItem>();  //

    public void InitPool(GameObject go, int size, Transform parentTran)
    {
        if (mPoolDic.ContainsKey(go.name))
        {
            return;
        }

        ScrollPoolItem pool = new ScrollPoolItem();
        pool.InitPoolItem(go, parentTran, size);
        mPoolDic.Add(go.name, pool);
    }

    public void ReturnToPool(GameObject go)
    {
        if (mPoolDic.ContainsKey(go.name))
        {
            mPoolDic[go.name].ReturnToPool(go);
        }
    }

    public GameObject GetValuableItem(string goName)
    {
        if (mPoolDic.ContainsKey(goName))
        {
            return mPoolDic[goName].GetValuableObj(goName);
        }
        return null;
    }
}
