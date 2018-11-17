using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using LuaFramework;

namespace UnityEngine.UI
{
    [System.Serializable]
    public class LoopScrollPrefabSource 
    {
        public string prefabName;
        public int poolSize = 5;

        private bool inited = false;
        private bool nomalData = true;  //正常的连续的预制信息

        private List<string> mPrefabNameList = new List<string>();
        private Dictionary<string, string> mObjNameDic = new Dictionary<string, string>();

        public virtual GameObject GetObject()
        {
            if(!inited)
            {
                GameObject obj = Resources.Load<GameObject>(prefabName);
                AppFacade.Instance.GetManager<ObjectPoolManager>(ManagerName.ObjectPool).CreatePool(prefabName, poolSize, poolSize, obj);
                inited = true;
            }
            return AppFacade.Instance.GetManager<ObjectPoolManager>(ManagerName.ObjectPool).Get(prefabName);
        }

        //预制相同 初始化
        public virtual void InitPrefabData(string prefabName)
        {
            nomalData = true;
            this.prefabName = prefabName;
        }
        //存在不同的预制 初始化
        public virtual void InitDiffPrefabData(List<string> prefabIndexList)
        {
            nomalData = true;
            if (prefabIndexList != null)
            {
                nomalData = false;
                mPrefabNameList = prefabIndexList;
            }
        }

        public virtual GameObject GetObject(int index)
        {
            if (nomalData)
            {
                //Debug.Log("初始化的时候并没有传入index对应的预制名称");
                return GetObject();
            }

            if (!inited)
            {
                List<string> tempList = new List<string>();
                foreach (var name in mPrefabNameList)
                {
                    if (!tempList.Contains(name))
                    {
                        GameObject obj = Resources.Load<GameObject>(name);
                        AppFacade.Instance.GetManager<ObjectPoolManager>(ManagerName.ObjectPool).CreatePool(name, poolSize, 20, obj);
                        tempList.Add(name);
                    }
                }
                inited = true;
            }

            if (index > mPrefabNameList.Count || index < 0)
            {
                Debug.LogError("index超出数据");
                return null;
            }
            string tempPrefabName = mPrefabNameList[index];
            GameObject go = AppFacade.Instance.GetManager<ObjectPoolManager>(ManagerName.ObjectPool).Get(tempPrefabName);
            if (!mObjNameDic.ContainsKey(go.name))
            {
                mObjNameDic.Add(go.name, tempPrefabName);  //obj名字为key，对应的预制对象为value
            }
            return go;
        }

        public virtual void ReleaseObj(Transform go)
        {
            string tempPrefabName = prefabName;
            if (!nomalData)
            {
                mObjNameDic.TryGetValue(go.name, out tempPrefabName);
            }

            AppFacade.Instance.GetManager<ObjectPoolManager>(ManagerName.ObjectPool).Release(tempPrefabName, go.gameObject);
        }
    }
}
