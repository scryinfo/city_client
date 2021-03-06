﻿using UnityEngine;
using System.Collections;
using System;
using System.IO;
using LuaInterface;
using City;
using System.Text;

namespace LuaFramework {
    public class LuaManager : Manager {
        private LuaState lua;
        private LuaLoader loader;
        private LuaLooper loop = null;

        // Use this for initialization
        void Awake() {
            loader = new LuaLoader();
            lua = new LuaState();
            Debug.Log("LuaManager:Awake new LuaState !!!");
            LuaComponent.s_luaState = lua;
            this.OpenLibs();
            lua.LuaSetTop(0);
            CityLuaUtil.SetCallLuaFunction(this.CallFunction);
            DelegateFactory.Init();
            LuaBinder.Bind(lua);
            this.CustomBind(lua);
            LuaCoroutine.Register(lua, this);            
        }
        void setLuaBundleMode(bool bundle) {
            loader.beZip = bundle;
        }

        public static bool generate_RequireRT()
        {
            AppFacade.Instance.RemoveManager(ManagerName.Lua);
            AppFacade.Instance.AddManager<LuaManager>(ManagerName.Lua);            
            LuaManager luaMgr = AppFacade.Instance.GetManager<LuaManager>(ManagerName.Lua);
            if(luaMgr == null)
            {
                return false;
            }

            luaMgr.Awake();
            luaMgr.setLuaBundleMode(false);

            luaMgr.InitStart();

            luaMgr.DoFile("Require_Editor");         //load Require_Editor
            LuaFunction Genfun = luaMgr.lua.GetFunction("Genfun");
            Genfun.Call();
            Genfun.Dispose();
            Genfun = null;
            luaMgr = null;
            AppFacade.Instance.RemoveManager(ManagerName.Lua); //Can't execute this, otherwise there will be problems          
            return true;
            // return  Util.CallMethod("Require_Editor", "Genfun");     //Perform Require_RunTime generation        
        }
        public void CustomBind(LuaState L) {
            L.BeginModule(null);
            L.BeginModule("CityLuaUtilExt");
            L.RegFunction("bufferToString", bufferToString);
            L.RegFunction("charsToString", charsToString);
            L.EndModule();
            L.EndModule();
        }

        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int bufferToString(IntPtr L)
        {
            try
            {
                ToLua.CheckArgsCount(L, 2);
                City.MemoryStream obj = (City.MemoryStream)ToLua.CheckObject<City.MemoryStream>(L, 1);
                int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
                byte[] o = obj.readBytesString(arg0);
                LuaDLL.lua_pushlstring(L, o, o.Length);
                return 1;
            }
            catch (Exception e)
            {
                return LuaDLL.toluaL_exception(L, e);
            }
        }

        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int charsToString(IntPtr L)
        {
            try
            {
                ToLua.CheckArgsCount(L, 2);
                int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
                //char[] chars = (char[])ToLua.CheckObject<char[]>(L, 1);
                //char[] arg1 = ToLua.CheckParamsChar(L, 1, arg0 - 1);
                //string[] arg1 = ToLua.CheckParamsString(L, 1, arg0 - 1);
                string arg1 = ToLua.CheckString(L, 1);
                StringBuilder sb = new StringBuilder();
                /*foreach (char c in arg1)
                {
                    sb.Append(c);
                }
                string s = sb.ToString();
                LuaDLL.lua_pushstring(L, s);*/
                return 1;
            }
            catch (Exception e)
            {
                return LuaDLL.toluaL_exception(L, e);
            }
        }

        public void InitStart() {
            InitLuaPath();
            InitLuaBundle();
            this.lua.Start();    //Start LUAVM
            this.StartMain();
            this.StartLooper();
        }

        void StartLooper() {
            loop = gameObject.AddComponent<LuaLooper>();
            loop.luaState = lua;
        }

        //cjson is special, only a new table, no registration library, register here
        protected void OpenCJson() {
            lua.LuaGetField(LuaIndexes.LUA_REGISTRYINDEX, "_LOADED");
            lua.OpenLibs(LuaDLL.luaopen_cjson);
            lua.LuaSetField(-2, "cjson");

            lua.OpenLibs(LuaDLL.luaopen_cjson_safe);
            lua.LuaSetField(-2, "cjson.safe");
        }

        void StartMain() {
            lua.DoFile("Main.lua");

            LuaFunction main = lua.GetFunction("Main");
            main.Call();
            main.Dispose();
            main = null;    
        }
      
        /// <summary>
        /// Initially load third-party libraries
        /// </summary>
        void OpenLibs()
        {
            lua.OpenLibs(LuaDLL.luaopen_pb);            
                      
            lua.OpenLibs(LuaDLL.luaopen_lpeg);
            lua.OpenLibs(LuaDLL.luaopen_bit);
            lua.OpenLibs(LuaDLL.luaopen_socket_core);

            this.OpenCJson();

            lua.OpenLibs(LuaDLL.luaopen_lfs);
            lua.LuaSetGlobal("lfs");

            lua.OpenLibs(LuaDLL.luaopen_pbl);
            lua.LuaSetGlobal("pbl");

            lua.OpenLibs(LuaDLL.luaopen_pbl_io);
            lua.LuaSetGlobal("pbl_io");

            lua.OpenLibs(LuaDLL.luaopen_pbl_conv);
            lua.LuaSetGlobal("pbl_conv");            
            
            lua.OpenLibs(LuaDLL.luaopen_pbl_buffer);
            lua.LuaSetGlobal("pbl_buffer");
                        
            lua.OpenLibs(LuaDLL.luaopen_pbl_slice);
            lua.LuaSetGlobal("pbl_slice");
        }

        /// <summary>
        /// Initialize Lua code loading path
        /// </summary>
        void InitLuaPath() {
            Debug.Log("LuaManager:InitLuaPath Invoked !!!");
            if(lua == null)
            {
                Debug.Log("LuaManager:InitLuaPath lua == null !!!");
            }

            if (AppConst.DebugMode) {
                string rootPath = AppConst.FrameworkRoot;
                lua.AddSearchPath(rootPath + "/Lua");
                lua.AddSearchPath(rootPath + "/ToLua/Lua");                
            } else {
                lua.AddSearchPath(Util.DataPath + "lua");
            }
        }

        /// <summary>
        /// Initialize LuaBundle
        /// </summary>
        void InitLuaBundle() {
            if (loader.beZip) {
                //Autoload
                string assertDir = CityLuaUtil.getLuaBundelPath();
                Debug.Log("InitLuaBundle: "+ assertDir);
                string srcDir = assertDir + "/lua";
                int pathLen = assertDir.Length;
                string[] files = Directory.GetFiles(srcDir, "*.unity3d", SearchOption.AllDirectories);
                Debug.Log("Directory.GetFiles: from " + srcDir+ ", files count = "+ files.Length.ToString());
                for (int i = 0; i < files.Length; ++i) {

                    string file = files[i].Remove(0, pathLen+1);
                    Debug.Log("loader.AddBundle " + file);
                    loader.AddBundle(file);
                }
                //add manully all .unity3d files in client\Assets\StreamingAssets\lua 
                /*loader.AddBundle("lua/lua.unity3d");
                loader.AddBundle("lua/lua_math.unity3d");
                loader.AddBundle("lua/lua_system.unity3d");
                loader.AddBundle("lua/lua_system_reflection.unity3d");
                loader.AddBundle("lua/lua_unityengine.unity3d");
                loader.AddBundle("lua/lua_Common.unity3d");
                loader.AddBundle("lua/lua_Logic.unity3d");
                loader.AddBundle("lua/lua_Logic_GameBubble.unity3d");
                loader.AddBundle("lua/lua_Logic_PieChart.unity3d");
                loader.AddBundle("lua/lua_Logic_ExchangeAbout.unity3d");
                loader.AddBundle("lua/lua_model.unity3d");
                loader.AddBundle("lua/lua_View.unity3d");
                loader.AddBundle("lua/lua_view_buildinginfo.unity3d");
                loader.AddBundle("lua/lua_view_Logic.unity3d");
                loader.AddBundle("lua/lua_Controller.unity3d");
                loader.AddBundle("lua/lua_Misc.unity3d");
                loader.AddBundle("lua/lua_Framework.unity3d");
                loader.AddBundle("lua/lua_Framework_Interface.unity3d");
                loader.AddBundle("lua/lua_FrameworkPlugins.unity3d");
                loader.AddBundle("lua/lua_Framework_ui.unity3d");
                loader.AddBundle("lua/lua_Framework_pbl.unity3d");
                loader.AddBundle("lua/lua_test.unity3d");
                loader.AddBundle("lua/lua_test_group.unity3d");
                loader.AddBundle("lua/lua_test_testmain.unity3d");
                loader.AddBundle("lua/lua_test_pbl.unity3d");
                loader.AddBundle("lua/lua_test_performance.unity3d");
                loader.AddBundle("lua/lua_test_testframework.unity3d");
                loader.AddBundle("lua/lua_test_testframework_memory.unity3d");
                loader.AddBundle("lua/lua_protobuf.unity3d");
                loader.AddBundle("lua/lua_3rd_cjson.unity3d");
                loader.AddBundle("lua/lua_3rd_luabitop.unity3d");
                loader.AddBundle("lua/lua_cjson.unity3d");*/

            }
        }

        public void DoFile(string filename) {
            lua.DoFile(filename);
        }

        // Update is called once per frame
        public object[] CallFunction(string funcName, params object[] args) {
            LuaFunction func = lua.GetFunction(funcName);
            if (func != null) {
                return func.LazyCall(args);
            }
            return null;
        }

        public void LuaGC() {
            lua.LuaGC(LuaGCOptions.LUA_GCCOLLECT);
        }

        public void Close() {
            if (loop) {
                loop.Destroy();
                loop = null;
            }
            lua.Dispose();
            lua = null;
            loader = null;
        }
    }
}