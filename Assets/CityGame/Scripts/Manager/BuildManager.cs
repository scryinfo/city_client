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
            string assetName = "Assets/CityGame/Resources/View/" + name + ".prefab"; ;
            System.Type tpye = typeof(UnityEngine.GameObject);            

#if ASYNC_MODE
            LuaHelper.GetPanelManager().LoadPrefab_A(assetName, tpye, null, null, delegate (UnityEngine.Object[] objs, AssetBundle ab) {
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