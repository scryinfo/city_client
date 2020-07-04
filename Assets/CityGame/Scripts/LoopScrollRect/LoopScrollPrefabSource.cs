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
        private bool nomalData = true;  //Normal continuous pre-made information

        private List<string> mPrefabNameList = new List<string>();
        private Dictionary<string, string> mObjNameDic = new Dictionary<string, string>();

        public virtual GameObject GetObject()
        {
            if(!inited)
            {
                GameObject obj = Resources.Load<GameObject>(prefabName);
                if (AppFacade.Instance.GetManager<ObjectPoolManager>(ManagerName.ObjectPool).GetPool(prefabName) == null)
                {
                    AppFacade.Instance.GetManager<ObjectPoolManager>(ManagerName.ObjectPool).CreatePool(prefabName, poolSize, poolSize, obj);
                }
                inited = true;
            }
            return AppFacade.Instance.GetManager<ObjectPoolManager>(ManagerName.ObjectPool).Get(prefabName);
        }

        //The same prefabrication
        public virtual void InitPrefabData(string prefabName)
        {
            nomalData = true;
            this.prefabName = prefabName;
        }
        //There are different pre-made initializations
        public virtual void InitDiffPrefabData(List<string> prefabIndexList)
        {
            nomalData = true;
            if (prefabIndexList != null)
            {
                nomalData = false;
                ////mObjNameDic.Clear();
                mPrefabNameList = prefabIndexList;
            }
        }

        public virtual GameObject GetObject(int index)
        {
            if (nomalData)
            {
                //Debug.Log("During initialization, no pre-made name corresponding to index is passed in");
                return GetObject();
            }

            if (!inited)
            {
                List<string> tempList = new List<string>();
                foreach (var name in mPrefabNameList)
                {
                    if (!tempList.Contains(name))
                    {
                        if (AppFacade.Instance.GetManager<ObjectPoolManager>(ManagerName.ObjectPool).GetPool(name) == null)
                        {
                            GameObject obj = Resources.Load<GameObject>(name);
                            AppFacade.Instance.GetManager<ObjectPoolManager>(ManagerName.ObjectPool).CreatePool(name, poolSize, poolSize, obj);
                        }
                        ////AppFacade.Instance.GetManager<ObjectPoolManager>(ManagerName.ObjectPool).CreatePool(name, poolSize, 20, obj);
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
            if (AppFacade.Instance.GetManager<ObjectPoolManager>(ManagerName.ObjectPool).GetPool(tempPrefabName) == null)
            {
                GameObject obj = Resources.Load<GameObject>(tempPrefabName);
                AppFacade.Instance.GetManager<ObjectPoolManager>(ManagerName.ObjectPool).CreatePool(tempPrefabName, poolSize, poolSize, obj);
            }
            GameObject go = AppFacade.Instance.GetManager<ObjectPoolManager>(ManagerName.ObjectPool).Get(tempPrefabName);
            if (!mObjNameDic.ContainsKey(go.name))
            {
                mObjNameDic.Add(go.name, tempPrefabName);  //The obj name is key, and the corresponding prefabricated object is value
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
