using UnityEditor;
using UnityEngine;
using System.IO;
using System.Text;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using LuaFramework;

public class Packager {
    public static string platform = string.Empty;
    static List<string> paths = new List<string>();
    static List<string> files = new List<string>();
    static List<AssetBundleBuild> maps = new List<AssetBundleBuild>();

    ///-----------------------------------------------------------
    static string[] exts = { ".txt", ".xml", ".lua", ".assetbundle", ".json" };
    static bool CanCopy(string ext) {   //能不能复制
        foreach (string e in exts) {
            if (ext.Equals(e)) return true;
        }
        return false;
    }

    [MenuItem("LuaFramework/Build iPhone Resource", false, 100)]
    public static void BuildiPhoneResource() {
        BuildTarget target;
#if UNITY_5
        target = BuildTarget.iOS;
#else
        target = BuildTarget.iOS;
#endif
        BuildAssetResource(target);
    }

    [MenuItem("LuaFramework/Build Android Resource", false, 101)]
    public static void BuildAndroidResource() {        
        BuildAssetResource(BuildTarget.Android);
    }
    [MenuItem("LuaFramework/Build Android Resource Only", false, 101)]
    public static void BuildAndroidResourceOnly()
    {
        BuildAssetResourceOnly(BuildTarget.Android);
    }
    //新增的Lua文件必须执行 BuildAndroidResource，非新增的Lua改动执行 BuildAndroidLua 即可 
    [MenuItem("LuaFramework/Update Android LuaBundle Only", false, 102)]
    public static void BuildAndroidLua()
    {
        BuildLuaBundel(BuildTarget.Android);
    }

    [MenuItem("LuaFramework/Build Windows Resource", false, 103)]
    public static void BuildWindowsResource() {
        BuildAssetResource(BuildTarget.StandaloneWindows);
    }

    public static void CopyDir(string fromDir, string toDir)
    {
        if (!Directory.Exists(fromDir))
            return;

        if (!Directory.Exists(toDir))
        {
            Directory.CreateDirectory(toDir);
        }

        string[] files = Directory.GetFiles(fromDir);
        foreach (string formFileName in files)
        {
            string fileName = Path.GetFileName(formFileName);
            string toFileName = Path.Combine(toDir, fileName);
            File.Copy(formFileName, toFileName);
        }
        string[] fromDirs = Directory.GetDirectories(fromDir);
        foreach (string fromDirName in fromDirs)
        {
            string dirName = Path.GetFileName(fromDirName);
            string toDirName = Path.Combine(toDir, dirName);
            CopyDir(fromDirName, toDirName);
        }
    }

    public static void MoveDir(string fromDir, string toDir)
    {
        if (!Directory.Exists(fromDir))
            return;

        CopyDir(fromDir, toDir);
        Directory.Delete(fromDir, true);
    }

    public static void BuildLuaBundel(BuildTarget target)
    {
        files.Clear();
        string luaPath = "Assets/" + AppConst.AssetDir + "/lua";

        //生成 Require_RunTime.lua        
        if (LuaFramework.LuaManager.generate_RequireRT() == false)
            return;

        if (AppConst.LuaBundleMode)
        {
            HandleLuaBundle();
        }
        else
        {
            HandleLuaFile();
        }   

        string resPath = "Assets/luaUpdate";
        if (!Directory.Exists(resPath))
        {
            Directory.CreateDirectory(resPath);
        }

        BuildAssetBundleOptions options = BuildAssetBundleOptions.DeterministicAssetBundle |
                                          BuildAssetBundleOptions.UncompressedAssetBundle;        

        BuildPipeline.BuildAssetBundles(resPath, maps.ToArray(), options, target);

        MoveDir(resPath+"/lua", luaPath);
        string streamDir = Application.dataPath + "/" + AppConst.LuaTempDir;
        if (Directory.Exists(streamDir)) Directory.Delete(streamDir, true);
        if (Directory.Exists(resPath)) Directory.Delete(resPath, true);
        AssetDatabase.Refresh();
        HandleNoneLuaBundleInLua();
    }

    /// <summary>
    /// 生成绑定素材
    /// </summary>
    public static void BuildAssetResourceOnly(BuildTarget target, bool buildLuaOnly = false)
    {
        if (Directory.Exists(Util.DataPath))
        {
            Directory.Delete(Util.DataPath, true);
        }
        string streamPath = Application.streamingAssetsPath;
        if (Directory.Exists(streamPath))
        {
            Directory.Delete(streamPath, true);
        }
        Directory.CreateDirectory(streamPath);
        AssetDatabase.Refresh();

        maps.Clear();
        files.Clear();

        HandleResBundle();//资源打包

        string resPath = "Assets/" + AppConst.AssetDir;
        BuildAssetBundleOptions options = BuildAssetBundleOptions.DeterministicAssetBundle |
                                          BuildAssetBundleOptions.UncompressedAssetBundle;

        BuildPipeline.BuildAssetBundles(resPath, maps.ToArray(), options, target);

        BuildFileIndex();

        string streamDir = Application.dataPath + "/" + AppConst.LuaTempDir;
        if (Directory.Exists(streamDir)) Directory.Delete(streamDir, true);

        //HandleNoneLuaBundleInLua();
        string streamResPath = AppDataPath + "/StreamingAssets/";
        ///----------------------创建文件列表-----------------------
        string newFilePath = streamResPath + "/files.txt";
        if (File.Exists(newFilePath)) File.Delete(newFilePath);

        FileStream fs = new FileStream(newFilePath, FileMode.CreateNew);
        StreamWriter sw = new StreamWriter(fs);
        for (int i = 0; i < files.Count; i++)
        {
            string file = files[i];
            string ext = Path.GetExtension(file);
            //if (file.EndsWith(".meta") || file.Contains(".DS_Store")) continue;            
            if (file.Contains(".DS_Store")) continue;

            string md5 = Util.md5file(file);
            string value = file.Replace(streamResPath, string.Empty);
            sw.WriteLine(value + "|" + md5);
        }
        sw.Close(); fs.Close();

        //AssetDatabase.Refresh();
    }

    /// <summary>
    /// 生成绑定素材
    /// </summary>
    public static void BuildAssetResource(BuildTarget target, bool buildLuaOnly = false) {
        if (Directory.Exists(Util.DataPath))
        {
            Directory.Delete(Util.DataPath, true);
        }
        string streamPath = Application.streamingAssetsPath;
        if (Directory.Exists(streamPath))
        {
            Directory.Delete(streamPath, true);
        }
        Directory.CreateDirectory(streamPath);
        AssetDatabase.Refresh();

        maps.Clear();
        files.Clear();

        //生成 Require_RunTime.lua        
        if (LuaFramework.LuaManager.generate_RequireRT() == false)
            return;

        if (AppConst.LuaBundleMode) {
            HandleLuaBundle();
        } else {
            HandleLuaFile();
        }        
        HandleResBundle();//资源打包
        
        string resPath = "Assets/" + AppConst.AssetDir;
        BuildAssetBundleOptions options = BuildAssetBundleOptions.DeterministicAssetBundle | 
                                          BuildAssetBundleOptions.UncompressedAssetBundle;

        BuildPipeline.BuildAssetBundles(resPath, maps.ToArray(), options, target);
        AssetDatabase.Refresh();

        BuildFileIndex();

        string streamDir = Application.dataPath + "/" + AppConst.LuaTempDir;
        if (Directory.Exists(streamDir)) Directory.Delete(streamDir, true);
        
        HandleNoneLuaBundleInLua();
    }

    static void AutoAddBuildMap(string pattern, string path, string rootPath)
    {
        string temp = "";
        string subdir = path.Replace(rootPath, "");
        subdir = subdir.Replace("\\", "");
        if (subdir.Length > 0)
            subdir += "_";

        string[] files = Directory.GetFiles(path, pattern, SearchOption.TopDirectoryOnly);
        int pos = -1;
        for (int i = 0; i < files.Length; i++)
        {
            files[i] = files[i].Replace('\\', '/');
            pos = files[i].LastIndexOf('/');
            if (pos >= 0)
            {
                string bundleName = subdir + files[i].Remove(0, pos + 1);
                string oldExt = pattern.Remove(0,1);
                bundleName = bundleName.Replace(oldExt, "");
                bundleName += AppConst.BundleExt;
                AssetBundleBuild build = new AssetBundleBuild();
                build.assetBundleName = bundleName;
                build.assetNames = new string[] { files[i] };
                maps.Add(build);
            }
        }
    }

    static void AddBuildMapOp(ref string path, ref string[] patterns)
    {
        for (int i = 0; i < patterns.Length; ++i)
        {
            AutoAddBuildMap(patterns[i], path, path);            
        }

        string[] dirs = Directory.GetDirectories(path);
        for (int i = 0; i < dirs.Length; ++i)
        {
            AddBuildMapOp(ref dirs[i], ref patterns);
        }
    }

    static void AddBuildMap(string bundleName, string pattern, string path) {
        string[] files = Directory.GetFiles(path, pattern, SearchOption.TopDirectoryOnly);
        if (files.Length == 0) return;

        for (int i = 0; i < files.Length; i++) {
            files[i] = files[i].Replace('\\', '/');
        }
        AssetBundleBuild build = new AssetBundleBuild();
        build.assetBundleName = bundleName;
        build.assetNames = files;
        maps.Add(build);
    }

    /// <summary>
    /// 处理Lua代码包
    /// </summary>
    static void HandleLuaBundle() {
        string streamDir = Application.dataPath + "/" + AppConst.LuaTempDir;
        if (!Directory.Exists(streamDir)) Directory.CreateDirectory(streamDir);

        //string[] srcDirs = { CustomSettings.luaDir, CustomSettings.cityLuaDir, CustomSettings.FrameworkPath + "/ToLua/Lua" };
        string[] srcDirs = { CustomSettings.cityLuaDir, CustomSettings.FrameworkPath + "/ToLua/Lua" };
        for (int i = 0; i < srcDirs.Length; i++) {
            if (AppConst.LuaByteMode) {
                string sourceDir = srcDirs[i];
                string[] files = Directory.GetFiles(sourceDir, "*.lua", SearchOption.AllDirectories);
                int len = sourceDir.Length;                
                if (sourceDir[len - 1] == '/' || sourceDir[len - 1] == '\\') {
                    --len;
                }
                for (int j = 0; j < files.Length; j++) {
                    if (files[j].EndsWith(".meta") || files[j].Contains(".DS_Store")) continue;

                    string str = files[j].Remove(0, len);
                    string dest = streamDir + str + ".bytes";
                    string dir = Path.GetDirectoryName(dest);
                    Directory.CreateDirectory(dir);
                    EncodeLuaFile(files[j], dest);
                }    
            } else {
                ToLuaMenu.CopyLuaBytesFiles(srcDirs[i], streamDir);
            }
        }
        string[] dirs = Directory.GetDirectories(streamDir, "*", SearchOption.AllDirectories);
        for (int i = 0; i < dirs.Length; i++) {
            string name = dirs[i].Replace(streamDir, string.Empty);
            name = name.Replace('\\', '_').Replace('/', '_');
            name = "lua/lua_" + name.ToLower() + AppConst.BundleExt;

            string path = "Assets" + dirs[i].Replace(Application.dataPath, "");
            AddBuildMap(name, "*.bytes", path);
        }
        AddBuildMap("lua/lua" + AppConst.BundleExt, "*.bytes", "Assets/" + AppConst.LuaTempDir);
        AssetDatabase.Refresh();
        //HandleNoneLuaBundleInLua();
    }

    static void HandleNoneLuaBundleInLua()
    {
        string streamDir = Application.dataPath + "/" + AppConst.LuaTempDir;
        if (!Directory.Exists(streamDir)) Directory.CreateDirectory(streamDir);

        string[] srcDirs = { CustomSettings.cityLuaDir+ "3rd", CustomSettings.cityLuaDir + "pb", CustomSettings.FrameworkPath + "/ToLua/Lua" };
        //-------------------------------处理Lua文件夹中非Lua文件----------------------------------
        string luaPath = AppDataPath + "/StreamingAssets/lua/";
        for (int i = 0; i < srcDirs.Length; i++)
        {
            string luaDataPath = srcDirs[i].ToLower();
            int pos = luaDataPath.LastIndexOf("/");
            
            if (pos < 0) {
                continue;
            }
            string luaPathRoot = luaDataPath.Remove(pos+1); 
            List<string> NLfiles = new List<string>();
            List<string> NLpaths = new List<string>();
            Recursive(luaDataPath, ref NLfiles, ref NLpaths, true);
            foreach (string f in NLfiles)
            {
                if (f.EndsWith(".lua")) continue;
                string newfile = f.Replace(luaPathRoot, "");
                if (i == 2)
                {
                    newfile = f.Replace(luaDataPath, "");
                }
                
                
                string path = Path.GetDirectoryName(luaPath + newfile);
                if (!Directory.Exists(path)) Directory.CreateDirectory(path);
                string dirname = Path.GetDirectoryName(path);
                string destfile = path + "/" + Path.GetFileName(f);
                File.Copy(f, destfile, true);                
                files.Add(destfile.Replace('\\', '/'));
            }
        }

        string resPath = AppDataPath + "/StreamingAssets/";
        ///----------------------创建文件列表-----------------------
        string newFilePath = resPath + "/files.txt";
        if (File.Exists(newFilePath)) File.Delete(newFilePath);

        FileStream fs = new FileStream(newFilePath, FileMode.CreateNew);
        StreamWriter sw = new StreamWriter(fs);
        for (int i = 0; i < files.Count; i++)
        {
            string file = files[i];
            string ext = Path.GetExtension(file);
            //if (file.EndsWith(".meta") || file.Contains(".DS_Store")) continue;            
            if (file.Contains(".DS_Store")) continue;

            string md5 = Util.md5file(file);
            string value = file.Replace(resPath, string.Empty);
            sw.WriteLine(value + "|" + md5);
        }
        sw.Close(); fs.Close();

        AssetDatabase.Refresh();
    }

    static void AddBuildMapInOne(ref string path, ref string[] patterns)
    {
        AssetBundleBuild build = new AssetBundleBuild();
        int pos = -1;
        path = path.Replace('\\', '/');
        pos = path.LastIndexOf('/');
        if (pos >= 0)
        {
            string bundleName = path.Remove(0, pos + 1);
            build.assetBundleName = bundleName;
            build.assetBundleName += AppConst.BundleExt;
            List<string> reslist = new List<string>();

            for (int i = 0; i < patterns.Length; ++i)
            {
                string[] files = Directory.GetFiles(path, patterns[i], SearchOption.AllDirectories);
                for(int j = 0; j < files.Length; ++j)
                {
                    files[j] = files[j].Replace('\\', '/');
                }
                reslist.AddRange(files);
            }

            build.assetNames = reslist.ToArray();

            maps.Add(build);
        }
    }

    /// <summary>
    /// 处理自定义框架实例包
    /// </summary>
    static void HandleResBundle()
    {
        string resPath = AppDataPath + "/" + AppConst.AssetDir + "/";
        if (!Directory.Exists(resPath)) Directory.CreateDirectory(resPath);
        string curPath = "Assets/CityGame/Resources/Share";
        string[] patterns = { "*.png", "*.otf", "*.prefab" };
        AssetBundleBuild pkginfo;
        pkginfo.assetBundleName = null;
        AddBuildMapOp(ref curPath, ref patterns);
        curPath = "Assets/CityGame/Resources/Share1";
        AddBuildMapInOne(ref curPath, ref patterns);

        curPath = "Assets/CityGame/Resources/Atlas";
        AddBuildMapInOne(ref curPath, ref patterns);

        curPath = "Assets/CityGame/Resources/Building";
        AddBuildMapInOne(ref curPath, ref patterns);

        curPath = "Assets/CityGame/Resources/testPng";
        AddBuildMapInOne(ref curPath, ref patterns);

        curPath = "Assets/CityGame/Resources/View";
        AddBuildMapOp(ref curPath, ref patterns);

        //AddBuildMapOp("Assets/CityGame/Resources/Atlas");
        //AddBuildMapOp("Assets/CityGame/Resources/testPng");
        //AddBuildMapOp("Assets/CityGame/Resources/View");

        return;

        AddBuildMap("CreateAvatar" + AppConst.BundleExt, "CreateAvatarPanel.prefab", "Assets/CityGame/Resources/View");
        AddBuildMap("Login" + AppConst.BundleExt, "LoginPanel.prefab", "Assets/CityGame/Resources/View");
        AddBuildMap("SelectAvatar" + AppConst.BundleExt, "SelectAvatarPanel.prefab", "Assets/CityGame/Resources/View");
        AddBuildMap("GameWorld" + AppConst.BundleExt, "GameWorldPanel.prefab", "Assets/CityGame/Resources/View");
        AddBuildMap("PlayerHead" + AppConst.BundleExt, "PlayerHeadPanel.prefab", "Assets/CityGame/Resources/View");
        AddBuildMap("TargetHead" + AppConst.BundleExt, "TargetHeadPanel.prefab", "Assets/CityGame/Resources/View");
        AddBuildMap("GroundAuction" + AppConst.BundleExt, "GroundAuctionPanel.prefab", "Assets/CityGame/Resources/View");
        AddBuildMap("BuildingInfo" + AppConst.BundleExt, "BuildingInfoPanel.prefab", "Assets/CityGame/Resources/View");
        AddBuildMap("BuildingInfoRight" + AppConst.BundleExt, "BuildingInfoRightPanel.prefab", "Assets/CityGame/Resources/View");
        AddBuildMap("BuildingTransfer" + AppConst.BundleExt, "BuildingTransferPanel.prefab", "Assets/CityGame/Resources/View");
        AddBuildMap("House" + AppConst.BundleExt, "HousePanel.prefab", "Assets/CityGame/Resources/View");
        AddBuildMap("BtnDialogPage" + AppConst.BundleExt, "BtnDialogPagePanel.prefab", "Assets/CityGame/Resources/View/Common");
        AddBuildMap("InputDialogPage" + AppConst.BundleExt, "InputDialogPagePanel.prefab", "Assets/CityGame/Resources/View/Common");
        AddBuildMap("HouseChangeRent" + AppConst.BundleExt, "HouseChangeRentPanel.prefab", "Assets/CityGame/Resources/View");
        AddBuildMap("Exchange" + AppConst.BundleExt, "ExchangePanel.prefab", "Assets/CityGame/Resources/View");
        AddBuildMap("WagesAdjustBox" + AppConst.BundleExt, "WagesAdjustBoxPanel.prefab", "Assets/CityGame/Resources/View");

        //测试滑动--交易所
        AddBuildMap("TestExchange" + AppConst.BundleExt, "TestExchangePanel.prefab", "Assets/CityGame/Resources/View/TestCycle");
        AddBuildMap("ScorllTestPrefab" + AppConst.BundleExt, "ScorllTestPrefab.prefab", "Assets/CityGame/Resources/View/TestCycle");

        AddBuildMap("UIRoot" + AppConst.BundleExt, "UIRootPanel.prefab", "Assets/CityGame/Resources/View");
        AddBuildMap("TopBar" + AppConst.BundleExt, "TopBarPanel.prefab", "Assets/CityGame/Resources/View");

        AddBuildMap("Notice" + AppConst.BundleExt, "NoticePanel.prefab", "Assets/CityGame/Resources/View");
        AddBuildMap("Battle" + AppConst.BundleExt, "BattlePanel.prefab", "Assets/CityGame/Resources/View");
        AddBuildMap("SkillPage" + AppConst.BundleExt, "SkillPagePanel.prefab", "Assets/CityGame/Resources/View");
        AddBuildMap("MainPage" + AppConst.BundleExt, "MainPagePanel.prefab", "Assets/CityGame/Resources/View");

        AddBuildMap("Model" + AppConst.BundleExt, "*.prefab", "Assets/CityGame/Resources/Model");
        AddBuildMap("Skill" + AppConst.BundleExt, "*.prefab", "Assets/CityGame/Resources/Effect/Prefab");
        //AddBuildMap("Terrain" + AppConst.BundleExt, "*.prefab", "Assets/CityGame/Resources/Terrain");

        //饼图
        AddBuildMap("PieCanvas" + AppConst.BundleExt, "PieCanvas.prefab", "Assets/CityGame/Resources/Prefab/PieChart");
        //曲线图
        AddBuildMap("LineChart" + AppConst.BundleExt, "LineChartPanel.prefab", "Assets/CityGame/Resources/View");

        //游戏主界面
        AddBuildMap("GameMainInterface" + AppConst.BundleExt, "GameMainInterfacePanel.prefab", "Assets/CityGame/Resources/View");
        //角色管理面板
        AddBuildMap("RoleManager" + AppConst.BundleExt, "RoleManagerPanel.prefab", "Assets/CityGame/Resources/View");
        //选服页面
        AddBuildMap("ServerList" + AppConst.BundleExt, "ServerListPanel.prefab", "Assets/CityGame/Resources/View");
        //创角页面
        AddBuildMap("CreateRole" + AppConst.BundleExt, "CreateRolePanel.prefab", "Assets/CityGame/Resources/View");

        //原料厂主页
        AddBuildMap("Material" + AppConst.BundleExt, "MaterialPanel.prefab", "Assets/CityGame/Resources/View");
        //仓库面板
        AddBuildMap("Warehouse" + AppConst.BundleExt, "WarehousePanel.prefab", "Assets/CityGame/Resources/View");
        //货架面板
        AddBuildMap("Shelf" + AppConst.BundleExt,"ShelfPanel.prefab", "Assets/CityGame/Resources/View");
        //调整生产线
        AddBuildMap("AdjustProductionLine" + AppConst.BundleExt, "AdjustProductionLinePanel.prefab","Assets/CityGame/Resources/View");
        //选择仓库
        AddBuildMap("ChooseWarehousePanel" + AppConst.BundleExt, "ChooseWarehousePanel.prefab", "Assets/CityGame/Resources/View");

        //中心仓库
        AddBuildMap("CenterWareHouse" + AppConst.BundleExt, "CenterWareHousePanel.prefab", "Assets/CityGame/Resources/View");
        //玩家信息提示框
        AddBuildMap("MessageTooltip" + AppConst.BundleExt, "MessageTooltipPanel.prefab", "Assets/CityGame/Resources/View");
    }

    /// <summary>
    /// 处理Lua文件
    /// </summary>
    static void HandleLuaFile() {
        string resPath = AppDataPath + "/StreamingAssets/";
        string luaPath = resPath + "lua/";

        //----------复制Lua文件----------------
        if (!Directory.Exists(luaPath)) {
            Directory.CreateDirectory(luaPath); 
        }
        string[] luaPaths = { AppDataPath + "/CityGame/lua/",                               
                              AppDataPath + "/CityGame/Tolua/Lua/" };

        for (int i = 0; i < luaPaths.Length; i++) {
            string luaDataPath = luaPaths[i].ToLower();
            List<string> NLfiles = new List<string>();
            List<string> NLpaths = new List<string>();
            Recursive(luaDataPath, ref NLfiles, ref NLpaths,true);
            int n = 0;
            foreach (string f in NLfiles) {
                if (f.EndsWith(".meta")) continue;
                string newfile = f.Replace(luaDataPath, "");
                string newpath = luaPath + newfile;
                string path = Path.GetDirectoryName(newpath);
                if (!Directory.Exists(path)) Directory.CreateDirectory(path);

                if (File.Exists(newpath)) {
                    File.Delete(newpath);
                }
                if (AppConst.LuaByteMode) {
                    EncodeLuaFile(f, newpath);
                } else {
                    File.Copy(f, newpath, true);
                    files.Add(newpath.Replace('\\', '/'));
                }
                UpdateProgress(n++, files.Count, newpath);
            } 
        }
        EditorUtility.ClearProgressBar();
        AssetDatabase.Refresh();
    }

    static void BuildFileIndex() {
        string resPath = AppDataPath + "/StreamingAssets/";
        ///----------------------创建文件列表-----------------------        
        paths.Clear(); 
        Recursive(resPath, false);
    }

    /// <summary>
    /// 数据目录
    /// </summary>
    static string AppDataPath {
        get { return Application.dataPath.ToLower(); }
    }

    /// <summary>
    /// 遍历目录及其子目录
    /// </summary>
    static void Recursive(string path, bool excludeMata = true) {
        Recursive(path, ref files, ref paths, excludeMata);        
    }

    static void Recursive(string path, ref List<string> infiles, ref List<string> inpaths, bool excludeMata)
    {
        string[] names = Directory.GetFiles(path);
        string[] dirs = Directory.GetDirectories(path);
        foreach (string filename in names)
        {
            if (excludeMata)
            {
                if (filename.EndsWith(".meta")) continue;
            }
            string ext = Path.GetExtension(filename);
            infiles.Add(filename.Replace('\\', '/'));
        }
        foreach (string dir in dirs)
        {
            inpaths.Add(dir.Replace('\\', '/'));
            if (dir.Equals("lua"))
            {
                Recursive(dir, ref infiles, ref inpaths, true);
            }
            else {
                Recursive(dir, ref infiles, ref inpaths, excludeMata);
            }
            
        }
    }
    static void UpdateProgress(int progress, int progressMax, string desc) {
        string title = "Processing...[" + progress + " - " + progressMax + "]";
        float value = (float)progress / (float)progressMax;
        EditorUtility.DisplayProgressBar(title, desc, value);
    }

    public static void EncodeLuaFile(string srcFile, string outFile) {
        if (!srcFile.ToLower().EndsWith(".lua")) {
            File.Copy(srcFile, outFile, true);
            return;
        }
        bool isWin = true;
        string luaexe = string.Empty;
        string args = string.Empty;
        string exedir = string.Empty;
        string currDir = Directory.GetCurrentDirectory();
        if (Application.platform == RuntimePlatform.WindowsEditor) {
            isWin = true;
            luaexe = "luajit.exe";
            args = "-b " + srcFile + " " + outFile;
            exedir = AppDataPath.Replace("assets", "") + "LuaEncoder/luajit/";
        } else if (Application.platform == RuntimePlatform.OSXEditor) {
            isWin = false;
            luaexe = "./luac";
            args = "-o " + outFile + " " + srcFile;
            exedir = AppDataPath.Replace("assets", "") + "LuaEncoder/luavm/";
        }
        Directory.SetCurrentDirectory(exedir);
        ProcessStartInfo info = new ProcessStartInfo();
        info.FileName = luaexe;
        info.Arguments = args;
        info.WindowStyle = ProcessWindowStyle.Hidden;
        info.ErrorDialog = true;
        info.UseShellExecute = isWin;
        Util.Log(info.FileName + " " + info.Arguments);

        Process pro = Process.Start(info);
        pro.WaitForExit();
        Directory.SetCurrentDirectory(currDir);
    }

    [MenuItem("Lua/Attach Profiler", false, 151)]
    static void AttachProfiler()
    {
        if (!Application.isPlaying)
        {
            EditorUtility.DisplayDialog("警告", "请在运行时执行此功能", "确定");
            return;
        }

        LuaClient.Instance.AttachProfiler();
    }

    [MenuItem("Lua/Detach Profiler", false, 152)]
    static void DetachProfiler()
    {
        if (!Application.isPlaying)
        {
            return;
        }

        LuaClient.Instance.DetachProfiler();
    }
}