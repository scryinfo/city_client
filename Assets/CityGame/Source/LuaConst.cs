using UnityEngine;

public static class LuaConst
{
    public static string luaDir = Application.dataPath + "/CityGame/Lua"; //lua logic code directory
    public static string toluaDir = Application.dataPath + "/CityGame/ToLua/Lua"; //tolua lua file directory

#if UNITY_STANDALONE
    public static string osDir = "Win";
#elif UNITY_ANDROID
    public static string osDir = "Android";            
#elif UNITY_IPHONE
    public static string osDir = "iOS";        
#else
    public static string osDir = "";        
#endif

    public static string luaResDir = string.Format("{0}/{1}/Lua", Application.persistentDataPath, osDir);      //Lua file download directory when the phone is running

#if UNITY_EDITOR_WIN || UNITY_STANDALONE_WIN    
    public static string zbsDir = "D:/ZeroBraneStudio/lualibs/mobdebug";        //ZeroBraneStudio table of Contents     
#elif UNITY_EDITOR_OSX || UNITY_STANDALONE_OSX
	public static string zbsDir = "/Applications/ZeroBraneStudio.app/Contents/ZeroBraneStudio/lualibs/mobdebug";
#else
    public static string zbsDir = luaResDir + "/mobdebug/";
#endif    

    public static bool openLuaSocket = true;            //Whether to open the Lua Socket library
    public static bool openLuaDebugger = false;         //Whether to connect lua debugger
}