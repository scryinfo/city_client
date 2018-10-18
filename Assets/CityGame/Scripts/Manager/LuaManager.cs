using UnityEngine;
using System.Collections;
using System;
using LuaInterface;
using City;

namespace LuaFramework {
    public class LuaManager : Manager {
        private LuaState lua;
        private LuaLoader loader;
        private LuaLooper loop = null;

        // Use this for initialization
        void Awake() {
            loader = new LuaLoader();
            lua = new LuaState();
            LuaComponent.s_luaState = lua;
            this.OpenLibs();
            lua.LuaSetTop(0);
            CityLuaUtil.SetCallLuaFunction(this.CallFunction);
            DelegateFactory.Init();
            LuaBinder.Bind(lua);
            this.CustomBind(lua);
            LuaCoroutine.Register(lua, this);            
        }

        public void CustomBind(LuaState L) {
            L.BeginModule(null);
            L.BeginModule("CityLuaUtilExt");
            L.RegFunction("bufferToString", bufferToString);
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

        public void InitStart() {
            InitLuaPath();
            InitLuaBundle();
            this.lua.Start();    //启动LUAVM
            this.StartMain();
            this.StartLooper();
        }

        void StartLooper() {
            loop = gameObject.AddComponent<LuaLooper>();
            loop.luaState = lua;
        }

        //cjson 比较特殊，只new了一个table，没有注册库，这里注册一下
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
        /// 初始化加载第三方库
        /// </summary>
        void OpenLibs()
        {
            lua.OpenLibs(LuaDLL.luaopen_pb);
                      
            lua.OpenLibs(LuaDLL.luaopen_lpeg);
            lua.OpenLibs(LuaDLL.luaopen_bit);
            lua.OpenLibs(LuaDLL.luaopen_socket_core);

            this.OpenCJson();

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
        /// 初始化Lua代码加载路径
        /// </summary>
        void InitLuaPath() {
            if (AppConst.DebugMode) {
                string rootPath = AppConst.FrameworkRoot;
                lua.AddSearchPath(rootPath + "/Lua");
                lua.AddSearchPath(rootPath + "/ToLua/Lua");                
            } else {
                lua.AddSearchPath(Util.DataPath + "lua");
            }
        }

        /// <summary>
        /// 初始化LuaBundle
        /// </summary>
        void InitLuaBundle() {
            if (loader.beZip) {
                //手动添加 client\Assets\StreamingAssets\lua 中所有.unity3d文件
                loader.AddBundle("lua/lua.unity3d");
                loader.AddBundle("lua/lua_math.unity3d");
                loader.AddBundle("lua/lua_system.unity3d");
                loader.AddBundle("lua/lua_system_reflection.unity3d");
                loader.AddBundle("lua/lua_unityengine.unity3d");
                loader.AddBundle("lua/lua_Common.unity3d");
                loader.AddBundle("lua/lua_Logic.unity3d");
                loader.AddBundle("lua/lua_Logic_GameBubble.unity3d");
                loader.AddBundle("lua/lua_Logic_PieChart.unity3d");
                loader.AddBundle("lua/lua_model.unity3d");
                loader.AddBundle("lua/lua_View.unity3d");
                loader.AddBundle("lua/lua_view_buildinginfo.unity3d");
                loader.AddBundle("lua/lua_Controller.unity3d");
                loader.AddBundle("lua/lua_Misc.unity3d");
                loader.AddBundle("lua/lua_Framework.unity3d");
                loader.AddBundle("lua/lua_Framework_Interface.unity3d");
                loader.AddBundle("lua/lua_FrameworkPlugins.unity3d");
                loader.AddBundle("lua/lua_Framework_ui.unity3d");
                loader.AddBundle("lua/lua_Framework_pbl.unity3d");
                loader.AddBundle("lua/lua_test.unity3d");
                loader.AddBundle("lua/lua_test_pbl.unity3d");
                loader.AddBundle("lua/lua_test_performance.unity3d");
                loader.AddBundle("lua/lua_test_testframework.unity3d");
                loader.AddBundle("lua/lua_protobuf.unity3d");
                loader.AddBundle("lua/lua_3rd_cjson.unity3d");
                loader.AddBundle("lua/lua_3rd_luabitop.unity3d");
                loader.AddBundle("lua/lua_cjson.unity3d");


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