using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using LuaInterface;

namespace LuaFramework
{
    public class BuildManager : Manager
    {
        //创建建筑
        public void CreateBuild(string name, LuaFunction func = null, object luaObj = null)
        {
            string assetName = name;            
#if RES_BUNDEL
            int pos = assetName.LastIndexOf('/');
            assetName = assetName.Remove(0, pos + 1);
#endif
            name = name.Replace("/", "_");
            string abName = name.ToLower() + AppConst.BundleExt;

#if ASYNC_MODE
            ResManager.LoadPrefab(abName, assetName, delegate (UnityEngine.Object[] objs) {
                if (objs.Length == 0) return;
                GameObject prefab = objs[0] as GameObject;
                if (prefab == null) return;
                GameObject go = Instantiate(prefab) as GameObject;
                go.name = assetName;
                if (func != null) func.Call(go , luaObj);
            });
#else
            GameObject prefab = ResManager.LoadAsset<GameObject>(name, assetName);
            if (prefab == null) return;
            GameObject go = Instantiate(prefab) as GameObject;
            go.name = assetName;
            if (func != null) func.Call(go, luaObj);
#endif
        }

    }
}