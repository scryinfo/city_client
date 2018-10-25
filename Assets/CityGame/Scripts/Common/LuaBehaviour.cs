using UnityEngine;
using LuaInterface;
using System.Collections;
using System.Collections.Generic;
using System;
using UnityEngine.UI;

namespace LuaFramework {
    struct LuaCfunPair
    {
        public LuaFunction _LuaFunction;
        public UnityEngine.Events.UnityAction _CsharpFun;        
    };

    public class LuaBehaviour : View {
        private string data = null;
        private Dictionary<string, LuaCfunPair> buttons = new Dictionary<string, LuaCfunPair>();

        protected void Awake() {
            Util.CallMethod(name, "Awake", gameObject);
        }

        protected void Start() {
            Util.CallMethod(name, "Start");
        }

        protected void OnClick() {
            Util.CallMethod(name, "OnClick");
        }

        protected void OnClickEvent(GameObject go) {
            Util.CallMethod(name, "OnClick", go);
        }

        /// <summary>
        /// 添加单击事件
        /// </summary>
        public void AddClick(GameObject go, LuaFunction luafunc, object obj = null) {
            if (go == null || luafunc == null) return;
            //buttons.Add(go.name, luafunc);
            string eventName = go.name + luafunc.GetHashCode().ToString();
            if (obj != null)
            {
                eventName += obj.GetHashCode().ToString();
            }

            LuaCfunPair pair;
            pair._LuaFunction = luafunc;
            pair._CsharpFun = delegate ()
            {
                luafunc.Call(go, obj);
            };

            buttons.Add(eventName, pair);            
            go.GetComponent<Button>().onClick.AddListener(pair._CsharpFun);
        }
        
        public void RemoveClick(GameObject go, LuaFunction luafuncToDel, object obj = null)
        {
            if (go == null) return;
            string eventName = go.name + luafuncToDel.GetHashCode().ToString();
            if (obj != null)
            {
                eventName += obj.GetHashCode().ToString();
            }
            LuaCfunPair pPair;
            buttons.TryGetValue(eventName, out pPair);
            if (pPair._LuaFunction != null && pPair._CsharpFun != null)
            {
                pPair._LuaFunction.Dispose();
                pPair._LuaFunction = null;
                buttons.Remove(eventName);
                go.GetComponent<Button>().onClick.RemoveListener(pPair._CsharpFun);
            }
        }

        /// <summary>
        /// 清除单击事件
        /// </summary>
        public void ClearClick() {
            foreach (var de in buttons) {
                if (de.Value._LuaFunction != null) {
                    de.Value._LuaFunction.Dispose();                    
                }
            }
            buttons.Clear();
        }

        //-----------------------------------------------------------------
        protected void OnDestroy() {
            ClearClick();
#if ASYNC_MODE && !CLOSE_RES_BUNDELMODE
            string abName = name.ToLower().Replace("panel", "");
            ResManager.UnloadAssetBundle(abName + AppConst.BundleExt);
#endif
            Util.ClearMemory();
            Debug.Log("~" + name + " was destroy!");
        }
    }
}