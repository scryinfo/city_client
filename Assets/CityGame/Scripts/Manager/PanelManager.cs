using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using LuaInterface;
using System;

namespace LuaFramework {    
    public class PanelManager : Manager {
        private Transform parent;
        Transform Parent {
            get {
                if (parent == null) {
                    GameObject go = GameObject.FindWithTag("UICanvas");
                    if (go != null) parent = go.transform;
                }
                return parent;
            }
        }

        string GetAssetName(ref string releativePath) {
            int pos = releativePath.LastIndexOf('/');
            return releativePath.Remove(0, pos + 1);
        }
        string GetBundleName(ref string releativePath)
        {
            string outstr = releativePath.Replace("/", "_");
            return outstr.ToLower() + AppConst.BundleExt;
        }

        /// Lua中用的异步加载资源方法，必须传入Lua的回调                
        public void LoadPrefab_A(string releativePath, System.Type type = null, object objInstance = null, LuaFunction func = null)
        {
            string assetName = releativePath ;
            if (type == null) {
                type = typeof(GameObject);
            }
#if RES_BUNDEL            
            assetName = GetAssetName(ref releativePath);
#endif
            string abName = GetBundleName(ref releativePath);

#if ASYNC_MODE
            ResManager.LoadPrefab(abName, assetName, delegate (UnityEngine.Object[] objs, AssetBundle ab)
            {
                if (objs.Length == 0) return;

                if (func != null)
                {
                    func.Call(objInstance, objs[0], ab);                    
                }

            }, type);
#else
            GameObject prefab = ResManager.LoadAsset<GameObject>(releativePath, assetName);
            if (prefab == null) return;

            GameObject go = Instantiate(prefab) as GameObject;
            go.name = assetName;
            go.layer = LayerMask.NameToLayer("Default");
            go.transform.SetParent(Parent);
            go.transform.localScale = Vector3.one;
            go.transform.localPosition = Vector3.zero;
            //
            RectTransform rect = go.GetComponent<RectTransform>();
            rect.sizeDelta = prefab.GetComponent<RectTransform>().sizeDelta;

            go.AddComponent<LuaBehaviour>();

            if (func != null) func.Call(go);
            Debug.LogWarning("CreatePanel::>> " + releativePath + " " + prefab);
#endif
        }

        /// <summary>
        /// �ر����
        /// </summary>
        /// <param name="name"></param>
        public void ClosePanel(string name) {
            var panelName = name + "Panel";
            var panelObj = Parent.Find(panelName);
            if (panelObj == null) return;
            Destroy(panelObj.gameObject);
        }
    }
}