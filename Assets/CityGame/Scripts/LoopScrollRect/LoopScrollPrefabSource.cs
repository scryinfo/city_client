using UnityEngine;
using System.Collections;
using LuaFramework;

namespace UnityEngine.UI
{
    [System.Serializable]
    public class LoopScrollPrefabSource 
    {
        public string prefabName;
        public int poolSize = 5;

        private bool inited = false;
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

        public virtual void ReleaseObj(Transform go)
        {
            AppFacade.Instance.GetManager<ObjectPoolManager>(ManagerName.ObjectPool).Release(prefabName, go.gameObject);
        }
    }
}
