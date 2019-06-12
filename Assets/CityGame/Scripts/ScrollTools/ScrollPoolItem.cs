

using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class ScrollPoolItem
{
    private Transform mParent;
    private GameObject mPrefab;

    private Stack mPoolStack = new Stack();

    public void InitPoolItem(GameObject go, Transform parent, int poolCount)
    {
        mParent = parent;
        mPrefab = go;

        for (int i = 0; i < poolCount; i++)
        {
            GameObject obj = CreateItem();
            obj.name = go.name;
            ReturnToPool(obj);
        }
    }

    public GameObject GetValuableObj(string goName)
    {
        if (mPoolStack.Count == 0)
        {
            GameObject go = CreateItem();
            go.name = goName;
            ReturnToPool(go);
        }
        GameObject obj = mPoolStack.Pop() as GameObject;
        return obj;
    }

    public void ReturnToPool(GameObject go)
    {
        go.transform.position = new Vector3(-9999, -9999, 0);
        mPoolStack.Push(go);
    }

    private GameObject CreateItem()
    {
        GameObject go = GameObject.Instantiate(mPrefab);
        go.transform.SetParent(mParent);
        go.transform.localScale = Vector3.one;
        go.transform.localPosition = Vector3.zero;
        go.SetActive(true);
        return go;
    }
}
