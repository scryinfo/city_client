//#define CLOSE_RES_BUNDELMODE  //Turn off the resource's boundle mode

using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;

namespace LuaFramework {

    public class AppConst {
        public const bool DebugMode = true;                       //Debug mode-for internal testing

        /// <summary>
        /// If the update mode is enabled, the premise must start the server that comes with the framework.
        /// Otherwise, you will need to copy everything in StreamingAssets
        /// Copy it to your own Webserver and modify the following WebUrl.
        /// </summary>
#if HOTUP
        public const bool UpdateMode = true;                       //Update Mode-Open
#else
        public const bool UpdateMode = false;                       //Update mode-off
#endif
        //public const bool UpdateMode = false;                       //Update mode-off by default
        public const bool LuaByteMode = false;                       //Lua bytecode mode-off by default
#if LUA_BUNDEL
    public const bool LuaBundleMode = true;                    //Lua code AssetBundle mode         
#else
    public const bool LuaBundleMode = false;                    //Lua code AssetBundle mode          
#endif

        public const int TimerInterval = 1;
        public const int GameFrameRate = 30;                        //Game frame rate
        public const int vSyncCount = 0;                            //Vertical synchronization, 0 is off

        public const string AppName = "CityGame";               //Application name
        public const string LuaTempDir = "Lua/";                    //Temporary directory
        public const string AppPrefix = AppName + "_";              //Application prefix
        public const string BundleExt = ".unity3d";                   //bundle extension
        public const string AssetDir = "StreamingAssets";           //Material catalog
#if PUB_BUILD
        public const string asServerIp = "139.217.115.231";                   //domestic
                                                                              //public const string asServerIp = "52.177.192.219";                  //foreign 
#elif PUB_BUILD0
        public const string asServerIp = "42.159.89.63";
#elif PUB_BUILD_209
        public const string asServerIp = "47.110.156.209";  //For pressure testing
#elif PUB_BUILD_242
        public const string asServerIp = "47.97.249.242";   //Used for new function development and testing
#elif PUB_BUILD_42
        public const string asServerIp = "47.96.97.42";   //Used for new function development and testing
#elif PUB_BUILD_99
        public const string asServerIp = "47.111.11.99";   //Server for planning deduction
#elif PUB_BUILD_188
        public const string asServerIp = "192.168.0.188";   //Server for planning deduction
#else
        public const string asServerIp = "192.168.0.191";
        //public const string WebUrl = "http://192.168.0.191:8080/CityHotUp/";      //Test update address
#endif

#if HOT_CATA1
        public const string WebUrl = "http://40.73.5.184:8080/HotFixed01/";       //Test update address
#elif HOT_CATA2
        public const string WebUrl = "http://40.73.5.184:8080/HotFixed02/";       //Test update address
#elif HOT_CATA3
        public const string WebUrl = "http://40.73.5.184:8080/HotFixed03/";       //Test update address
#elif HOT_CATA4
        public const string WebUrl = "http://192.168.0.191:8080/CityHotUp/";      //Test update address
#elif HOT_42
        public const string WebUrl = "http://192.168.0.191:8080/42/";      //Test update address
#else
        public const string WebUrl = "http://40.73.5.184:8080/city/";       //Test update address
#endif

        public const string AssetDir_CloseBundleMode = "View";        //Resource read path after closing resource BundleMode
        public static string FrameworkRoot {
            get {
                return Application.dataPath + "/" + AppName;
            }
        }
    }
}