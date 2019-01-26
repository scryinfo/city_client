using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using LuaFramework;


public class CityBuild : Editor
{
    static void BuildResourceBundle()
    {
        AppFacade.createGameManager();
        AppFacade.Instance.AddManager<PanelManager>(ManagerName.Panel);
        AppFacade.Instance.AddManager<SoundManager>(ManagerName.Sound);
        AppFacade.Instance.AddManager<BuildManager>(ManagerName.Build);
        AppFacade.Instance.AddManager<RayManager>(ManagerName.Ray);
        AppFacade.Instance.AddManager<TimerManager>(ManagerName.Timer);
        ResourceManager resmgr = AppFacade.Instance.AddManager<ResourceManager>(ManagerName.Resource);
        AppFacade.Instance.AddManager<ThreadManager>(ManagerName.Thread);
        AppFacade.Instance.AddManager<ObjectPoolManager>(ManagerName.ObjectPool);
        GameManager gmgr = AppFacade.Instance.GetManager<GameManager>(ManagerName.Game);
        AppFacade.Instance.AddManager<GameManager>(ManagerName.Game);
        LuaManager luemgr = AppFacade.Instance.AddManager<LuaManager>(ManagerName.Lua);
        AssetDatabase.Refresh(ImportAssetOptions.ForceSynchronousImport);
        Packager.BuildAndroidResource();
        AssetDatabase.Refresh();
    }

    static void _genWrapFiles()
    {
        //ToLuaMenu.GenLuaAll();
        //AssetDatabase.Refresh();
        ToLuaMenu.GenLuaWrapBinder();
        AssetDatabase.Refresh();
        //ToLuaMenu.autoGen();
        //AssetDatabase.Refresh();
    }

    [MenuItem("Tool/APKBuild")]
    public static void Build()
    {        
        Debug.Log("Unit start Build");       

        BuildTarget buildTarget = BuildTarget.Android;
        // 切换到 Android 平台        
        EditorUserBuildSettings.SwitchActiveBuildTarget(BuildTargetGroup.Android, buildTarget);

        // keystore 路径, G:\keystore\one.keystore
        //PlayerSettings.Android.keystoreName = "G:\\keystore\\one.keystore";
        // one.keystore 密码
        //PlayerSettings.Android.keystorePass = "123456";

        // one.keystore 别名
        //PlayerSettings.Android.keyaliasName = "bieming1";
        // 别名密码
        //PlayerSettings.Android.keyaliasPass = "123456";
        System.Threading.Thread.Sleep(5);

        List<string> levels = new List<string>();
        foreach (EditorBuildSettingsScene scene in EditorBuildSettings.scenes)
        {
            if (!scene.enabled) continue;
            // 获取有效的 Scene
            levels.Add(scene.path);
        }

        // 打包出 APK 名
        string buildTime = System.DateTime.Now.ToString("yyyyMMddHHmm", System.Globalization.DateTimeFormatInfo.InvariantInfo);
        string apkName = string.Format("./Apk/{0}.apk", "city_"+ buildTime);
        // 执行打包
        string res = BuildPipeline.BuildPlayer(levels.ToArray(), apkName, buildTarget, BuildOptions.None);
        Debug.Log("apk build successfully, file location = "+res);

    }
}