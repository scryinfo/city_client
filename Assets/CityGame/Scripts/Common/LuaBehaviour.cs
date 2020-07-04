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
        /// Add click event
        /// </summary>
        public void AddClick(GameObject go, LuaFunction luafunc, object obj = null) {
            if (go == null || luafunc == null) return;
            //buttons.Add(go.name, luafunc);
            string eventName = go.GetInstanceID() + luafunc.GetHashCode().ToString();
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

            //Repeat registration and return directly
            if (buttons.ContainsKey(eventName)) {
                return;                    
            }
            buttons.Add(eventName, pair);
            go.GetComponent<Button>().onClick.RemoveAllListeners();
            go.GetComponent<Button>().onClick.AddListener(pair._CsharpFun);
        }
        
        public void RemoveClick(GameObject go, LuaFunction luafuncToDel, object obj = null)
        {
            if (go == null) return;
            string eventName = go.GetInstanceID() + luafuncToDel.GetHashCode().ToString();
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
        /// Clear click event
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
            Util.ClearMemory();
            Debug.Log("~" + name + " was destroy!");
        }
    }
}