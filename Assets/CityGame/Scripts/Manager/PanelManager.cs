using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using LuaInterface;
using System;

namespace LuaFramework {
    public class PanelManager : Manager {
        private Transform parent;
        public struct Sync_LoadData
        {
            public AssetBundle _bunldle ;
            public GameObject _asset;
        };

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
            releativePath = releativePath.Replace("/", "_");
            return releativePath.ToLower() + AppConst.BundleExt;
        }

        public Sync_LoadData LoadPrefab_S(string releativePath, System.Type type = null) {
            //1、 根据项目资源bundle命名规则，把传入的资源相对路径转为对应的bundle名字，同步加载bundle
            Sync_LoadData retObj;
            retObj._asset = null;
            retObj._bunldle = null;
            string assetName = releativePath;
            if (type == null)
            {
                type = typeof(GameObject);
            }
#if RES_BUNDEL            
            assetName = GetAssetName(ref releativePath);
#endif
            string abName = GetBundleName(ref releativePath);

            retObj._bunldle = UnityEngine.Resources.Load(abName, type) as AssetBundle;
            
            if (retObj._bunldle != null) {
                //2、 从传入的资源相对路径取出资源名字，从bundle同步加载该资源
                AssetBundleRequest abre = retObj._bunldle.LoadAssetAsync(assetName, type);
                if (abre != null) {
                    retObj._asset = abre.asset as GameObject;
                }
            }
            return retObj;
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