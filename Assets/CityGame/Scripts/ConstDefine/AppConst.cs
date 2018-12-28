//#define CLOSE_RES_BUNDELMODE  //关闭资源的 boundle 模式

using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;

namespace LuaFramework {

    public class AppConst {
        public const bool DebugMode = true;                       //调试模式-用于内部测试

        /// <summary>
        /// 如果开启更新模式，前提必须启动框架自带服务器端。
        /// 否则就需要自己将StreamingAssets里面的所有内容
        /// 复制到自己的Webserver上面，并修改下面的WebUrl。
        /// </summary>
        public const bool UpdateMode = true;                       //更新模式-默认关闭 
        //public const bool UpdateMode = false;                       //更新模式-默认关闭 
        public const bool LuaByteMode = false;                       //Lua字节码模式-默认关闭
#if LUA_BUNDEL
    public const bool LuaBundleMode = true;                    //Lua代码AssetBundle模式          
#else
    public const bool LuaBundleMode = false;                    //Lua代码AssetBundle模式            
#endif

        public const int TimerInterval = 1;
        public const int GameFrameRate = 30;                        //游戏帧频

        public const string AppName = "CityGame";               //应用程序名称
        public const string LuaTempDir = "Lua/";                    //临时目录
        public const string AppPrefix = AppName + "_";              //应用程序前缀
        public const string BundleExt = ".unity3d";                   //bundle扩展名
        public const string AssetDir = "StreamingAssets";           //素材目录 
        //public const string WebUrl = "http://localhost:6688/";      //测试更新地址
        public const string WebUrl = "http://192.168.0.51/CityHotUp/StreamingAssets/";      //测试更新地址
        public const string AssetDir_CloseBundleMode = "View";        //关闭资源 BundleMode 后的资源读取路径
        public static string FrameworkRoot {
            get {
                return Application.dataPath + "/" + AppName;
            }
        }
    }
}