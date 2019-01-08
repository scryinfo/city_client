#if ASYNC_MODE
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;
using System.IO;
using LuaInterface;
using UObject = UnityEngine.Object;
using System.Runtime.Serialization.Formatters.Binary;

public class AssetBundleInfo {
    public AssetBundle m_AssetBundle;
    public int m_ReferencedCount;

    public AssetBundleInfo(AssetBundle assetBundle) {
        m_AssetBundle = assetBundle;
        m_ReferencedCount = 0;
    }
}

namespace LuaFramework {
    public struct Sync_LoadData
    {
        public AssetBundle _bunldle;
        public UnityEngine.Object _asset;
    };

    public class ResourceManager : Manager {
        string m_BaseDownloadingURL = "";
        string[] m_AllManifest = null;
        AssetBundleManifest m_AssetBundleManifest = null;
        static Dictionary<string, string[]> m_Dependencies = new Dictionary<string, string[]>();
        static Dictionary<string, string> m_ResourcesBundleInfo = new Dictionary<string, string>();
        static Dictionary<string, AssetBundleInfo> m_LoadedAssetBundles = new Dictionary<string, AssetBundleInfo>();
        Dictionary<string, List<LoadAssetRequest>> m_LoadRequests = new Dictionary<string, List<LoadAssetRequest>>();
        int resInitCountAll = 0;
        int resInitCountCur = 0;
        class LoadAssetRequest {
            public Type assetType;
            public string[] assetNames;
            public LuaFunction luaFunc;
            public Action<UObject[], AssetBundle> sharpFunc;
        }

        public static void Serialize<Object>(Object dictionary, Stream stream)
        {
            try // try to serialize the collection to a file
            {
                using (stream)
                {
                    // create BinaryFormatter
                    BinaryFormatter bin = new BinaryFormatter();
                    // serialize the collection (EmployeeList1) to file (stream)
                    bin.Serialize(stream, dictionary);
                }
            }
            catch (IOException)
            {
            }
        }

        public static Object Deserialize<Object>(Stream stream) where Object : new()
        {
            Object ret = CreateInstance<Object>();
            try
            {
                using (stream)
                {
                    // create BinaryFormatter
                    BinaryFormatter bin = new BinaryFormatter();
                    // deserialize the collection (Employee) from file (stream)
                    ret = (Object)bin.Deserialize(stream);
                }
            }
            catch (IOException)
            {
            }
            return ret;
        }
        // function to create instance of T
        public static Object CreateInstance<Object>() where Object : new()
        {
            return (Object)Activator.CreateInstance(typeof(Object));
        }

        // Load AssetBundleManifest.
        public void Initialize(string manifestName, Action initOK) {
            m_BaseDownloadingURL = Util.GetRelativePath();
            LoadAsset<AssetBundleManifest>(manifestName, new string[] { "AssetBundleManifest" }, delegate(UObject[] objs, AssetBundle ab) {
                if (objs.Length > 0) {                    
                    m_AssetBundleManifest = objs[0] as AssetBundleManifest;
                    m_AllManifest = m_AssetBundleManifest.GetAllAssetBundles();
                    string[] dependencies0 = m_AssetBundleManifest.GetAllDependencies(manifestName);
                    string resllistPath = City.CityLuaUtil.getLuaBundelPath() + "/assetBundleList.bin";
                    m_ResourcesBundleInfo = Deserialize<Dictionary<string, string>>(File.Open(resllistPath, FileMode.Open));

                    resInitCountAll = m_AllManifest.Length;                    
                }
                if (initOK != null) initOK();
            });
        }

        public static string getBundleName(ref string resName)
        {
            if (m_ResourcesBundleInfo.ContainsKey(resName))
            {
                return m_ResourcesBundleInfo[resName];
            }
            return "";
        }

        public void LoadPrefab(string abName, string assetName, Action<UObject[], AssetBundle> func, System.Type type = null)
        {
            LoadAsset<GameObject>(abName, new string[] { assetName }, func, null, type);
        }

        public void LoadPrefab(string abName, string assetName, Action<UObject[], AssetBundle> func) {
            LoadAsset<GameObject>(abName, new string[] { assetName }, func);
        }

        public void LoadPrefab(string abName, string[] assetNames, Action<UObject[], AssetBundle> func) {
            LoadAsset<GameObject>(abName, assetNames, func);
        }

        public void LoadPrefab(string abName, string[] assetNames, LuaFunction func) {
            LoadAsset<GameObject>(abName, assetNames, null, func);
        }

        string GetRealAssetPath(string abName) {
            if (abName.Equals(AppConst.AssetDir)) {
                return abName;
            }
            abName = abName.ToLower();
            if (!abName.EndsWith(AppConst.BundleExt))
            {
                abName += AppConst.BundleExt;
            }
            if (abName.Contains("/")) {
                return abName;
            }
            //string[] paths = m_AssetBundleManifest.GetAllAssetBundles();  产生GC，需要缓存结果

            if (m_AllManifest == null) {
                return null;
            }

            for (int i = 0; i < m_AllManifest.Length; i++) {
                int index = m_AllManifest[i].LastIndexOf('/');  
                string path = m_AllManifest[i].Remove(0, index + 1);    //字符串操作函数都会产生GC
                if (path.Equals(abName)) {
                    return m_AllManifest[i];
                }
            }
            Debug.LogError("GetRealAssetPath Error:>>" + abName);
            return null;
        }

        IEnumerator NoneBundleLoadRes(string resPath, Action<UObject[], AssetBundle> action = null , System.Type type = null)
        {
            List<UObject> result = new List<UObject>();
            ResourceRequest r = null;
            if (type == null)
                r = Resources.LoadAsync(resPath);
            else
                r = Resources.LoadAsync(resPath, type);
            
            while (!r.isDone)
            {
                yield return null;
            }
            if(r.asset != null)
            {
                result.Add(r.asset);                
            }
            if (action != null) {
                action(result.ToArray(), null);
            }
        }
        /// <summary>
        /// 载入素材
        /// </summary>
        void LoadAsset<T>(string abName, string[] assetNames, Action<UObject[], AssetBundle> action = null, LuaFunction func = null, System.Type type = null) where T : UObject {

#if RES_BUNDEL
            abName = GetRealAssetPath(abName);

            LoadAssetRequest request = new LoadAssetRequest();
            if(type != null)
                request.assetType = type;
            else
                request.assetType = typeof(T);
            request.assetNames = assetNames;
            request.luaFunc = func;
            request.sharpFunc = action;

            List<LoadAssetRequest> requests = null;
            if (!m_LoadRequests.TryGetValue(abName, out requests))
            {
                requests = new List<LoadAssetRequest>();
                requests.Add(request);
                m_LoadRequests.Add(abName, requests);                
            }
            else
            {
                requests.Add(request);
            }
            StartCoroutine(OnLoadAsset<T>(abName, type));
#else
            for (int i = 0; i < assetNames.Length; i++)
            {
                string realpath = assetNames[i];
                //同步加载
                /*GameObject prefab = UnityEngine.Resources.Load<GameObject>(realpath) ;
                if (prefab != null) {                
                    result.Add(prefab);
                }*/
                //异步加载
                StartCoroutine(NoneBundleLoadRes(realpath, action, type));
            }            
#endif
        }
        public static string GetAssetName(ref string releativePath)
        {
            int pos = releativePath.LastIndexOf('/');
            return releativePath.Remove(0, pos + 1);
        }

        public static string GetBundleName(ref string releativePath)
        {
            string outstr = releativePath.Replace("/", "_");
            return outstr.ToLower() + AppConst.BundleExt;
        }

        public static ResourceManager GetResManager()
        {
            return AppFacade.Instance.GetManager<ResourceManager>(ManagerName.Resource);
        }

        public void LoadRes_A(string bundlePath, string assetName, System.Type type = null, object objInstance = null, LuaFunction func = null)
        {
            if (type == null)
            {
                type = typeof(GameObject);
            }
            string abName = GetBundleName(ref bundlePath);

#if ASYNC_MODE
            GetResManager().LoadPrefab(abName, assetName, delegate (UnityEngine.Object[] objs, AssetBundle ab)
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

        public Sync_LoadData LoadRes_S(string releativePath, System.Type type = null) {
            //1、 根据项目资源bundle命名规则，把传入的资源相对路径转为对应的bundle名字，同步加载bundle
            Sync_LoadData retObj;
            retObj._asset = null;
            retObj._bunldle = null;
            string assetName = releativePath;
            if (type == null)
            {
                type = typeof(UnityEngine.Object);
            }

#if RES_BUNDEL            
            assetName = GetAssetName(ref releativePath);
            string abName = GetBundleName(ref releativePath);
            abName = City.CityLuaUtil.getLuaBundelPath() + "/" + abName;
            //同步加载bundle
            AssetBundleInfo bundleInfo = GetLoadedAssetBundle(abName);

            if (bundleInfo == null)
            {
                string[] dependencies = m_AssetBundleManifest.GetAllDependencies(abName);
                if (dependencies.Length > 0)
                {
                    m_Dependencies.Add(abName, dependencies);
                    for (int i = 0; i < dependencies.Length; i++)
                    {
                        string depName = dependencies[i];
                        if (m_LoadedAssetBundles.TryGetValue(depName, out bundleInfo))
                        {
                            bundleInfo.m_ReferencedCount++;
                        }
                        else if (!m_LoadRequests.ContainsKey(depName))
                        {
                            AssetBundle depAb = AssetBundle.LoadFromFile(depName);
                            m_LoadedAssetBundles.Add(depName, new AssetBundleInfo(depAb));
                        }
                    }
                }

                retObj._bunldle = AssetBundle.LoadFromFile(abName);
                m_LoadedAssetBundles.Add(abName, new AssetBundleInfo(retObj._bunldle));
            }
            else {
                retObj._bunldle = bundleInfo.m_AssetBundle;
            }
                
            if (retObj._bunldle != null)
            {
                //2、 从传入的资源相对路径取出资源名字，从bundle同步加载该资源
                AssetBundleRequest abre = retObj._bunldle.LoadAssetAsync(assetName, type);
                if (abre != null)
                {
                    retObj._asset = abre.asset;                    
                }
            }
#else            
            retObj._asset = UnityEngine.Resources.Load("View/"+releativePath);
#endif      
            return retObj;
        }

        IEnumerator OnLoadAsset<T>(string abName, System.Type type) where T : UObject {
            AssetBundleInfo bundleInfo = GetLoadedAssetBundle(abName);
            if (bundleInfo == null) {
                yield return StartCoroutine(OnLoadAssetBundle(abName, typeof(T)));

                bundleInfo = GetLoadedAssetBundle(abName);
                if (bundleInfo == null) {
                    m_LoadRequests.Remove(abName);
                    Debug.LogError("OnLoadAsset--->>>" + abName);
                    List<LoadAssetRequest> list1 = null;
                    if (!m_LoadRequests.TryGetValue(abName, out list1))
                    {
                        m_LoadRequests.Remove(abName);
                        yield break;
                    }
                    yield break;
                }
            }
            List<LoadAssetRequest> list = null;
            if (!m_LoadRequests.TryGetValue(abName, out list)) {
                m_LoadRequests.Remove(abName);
                yield break;
            }
            for (int i = 0; i < list.Count; i++) {
                string[] assetNames = list[i].assetNames;
                type = list[i].assetType;
                List<UObject> result = new List<UObject>();

                AssetBundle ab = bundleInfo.m_AssetBundle;
                if (ab == null) {
                    int xxx = 0;
                }
                for (int j = 0; j < assetNames.Length; j++) {
                    string assetPath = assetNames[j];
                    AssetBundleRequest request = null;
                    if (type != null)
                    {
                        request = ab.LoadAssetAsync(assetPath, type);
                    }
                    else {
                        request = ab.LoadAssetAsync(assetPath, list[i].assetType);
                    }

                    yield return request;
                    result.Add(request.asset);

                    //T assetObj = ab.LoadAsset<T>(assetPath);
                    //result.Add(assetObj);
                }
                if (list[i].sharpFunc != null) {
                    list[i].sharpFunc(result.ToArray(), ab);
                    list[i].sharpFunc = null;
                }
                if (list[i].luaFunc != null) {
                    list[i].luaFunc.Call((object)result.ToArray());
                    list[i].luaFunc.Dispose();
                    list[i].luaFunc = null;
                }
                bundleInfo.m_ReferencedCount++;
            }
            m_LoadRequests.Remove(abName);
        }

        IEnumerator OnLoadAssetBundle(string abName, Type type)
        {
            string url = m_BaseDownloadingURL + abName;

            WWW download = null;
            if (type == typeof(AssetBundleManifest))
                download = new WWW(url);
            else
            {
                string[] dependencies = m_AssetBundleManifest.GetAllDependencies(abName);
                if (dependencies.Length > 0)
                {
                    m_Dependencies.Add(abName, dependencies);
                    for (int i = 0; i < dependencies.Length; i++)
                    {
                        string depName = dependencies[i];
                        AssetBundleInfo bundleInfo = null;
                        if (m_LoadedAssetBundles.TryGetValue(depName, out bundleInfo))
                        {
                            bundleInfo.m_ReferencedCount++;
                        }
                        else if (!m_LoadRequests.ContainsKey(depName))
                        {
                            yield return StartCoroutine(OnLoadAssetBundle(depName, type));
                        }
                    }
                }
                download = WWW.LoadFromCacheOrDownload(url, m_AssetBundleManifest.GetAssetBundleHash(abName), 0);
            }
            yield return download;

            AssetBundle assetObj = download.assetBundle;
            if (assetObj != null)
            {
                m_LoadedAssetBundles.Add(abName, new AssetBundleInfo(assetObj));
            }
            else
            {
                List<LoadAssetRequest> list = null;
                m_LoadRequests.TryGetValue(abName, out list);
                for (int i = 0; i < list.Count; i++)
                {
                    if (list[i].sharpFunc != null)
                    {
                        list[i].sharpFunc(null, null);
                        list[i].sharpFunc = null;
                    }
                    if (list[i].luaFunc != null)
                    {
                        list[i].luaFunc.Call((object)null);
                        list[i].luaFunc.Dispose();
                        list[i].luaFunc = null;
                    }
                }
            }
        }

        static AssetBundleInfo GetLoadedAssetBundle(string abName) {
            AssetBundleInfo bundle = null;
            m_LoadedAssetBundles.TryGetValue(abName, out bundle);
            if (bundle == null) return null;

            // No dependencies are recorded, only the bundle itself is required.
            string[] dependencies = null;
            if (!m_Dependencies.TryGetValue(abName, out dependencies))
                return bundle;

            // Make sure all dependencies are loaded
            foreach (var dependency in dependencies) {
                AssetBundleInfo dependentBundle;
                m_LoadedAssetBundles.TryGetValue(dependency, out dependentBundle);
                if (dependentBundle == null) return null;
            }
            return bundle;
        }

        /// <summary>
        /// 此函数交给外部卸载专用，自己调整是否需要彻底清除AB
        /// </summary>
        /// <param name="abName"></param>
        /// <param name="isThorough"></param>
        public void UnloadAssetBundle(string abName, bool isThorough = false) {
            abName = GetRealAssetPath(abName);
            //Debug.Log(m_LoadedAssetBundles.Count + " assetbundle(s) in memory before unloading " + abName);
            UnloadAssetBundleInternal(abName, isThorough);
            UnloadDependencies(abName, isThorough);
            //Debug.Log(m_LoadedAssetBundles.Count + " assetbundle(s) in memory after unloading " + abName);
        }

        void UnloadDependencies(string abName, bool isThorough) {
            string[] dependencies = null;
            if (!m_Dependencies.TryGetValue(abName, out dependencies))
                return;

            // Loop dependencies.
            foreach (var dependency in dependencies) {
                UnloadAssetBundleInternal(dependency, isThorough);
            }
            m_Dependencies.Remove(abName);
        }

        void UnloadAssetBundleInternal(string abName, bool isThorough) {
            AssetBundleInfo bundle = GetLoadedAssetBundle(abName);
            if (bundle == null) return;

            if (--bundle.m_ReferencedCount <= 0) {
                if (m_LoadRequests.ContainsKey(abName)) {
                    return;     //如果当前AB处于Async Loading过程中，卸载会崩溃，只减去引用计数即可
                }
                bundle.m_AssetBundle.Unload(isThorough);
                m_LoadedAssetBundles.Remove(abName);
                //Debug.Log(abName + " has been unloaded successfully");
            }
        }
    }
}
#else

using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using LuaFramework;
using LuaInterface;
using UObject = UnityEngine.Object;

namespace LuaFramework {
    public class ResourceManager : Manager {
        private string[] m_Variants = { };
        private AssetBundleManifest manifest;
        private AssetBundle shared, assetbundle;
        private Dictionary<string, AssetBundle> bundles;

        void Awake() {
        }

        /// <summary>
        /// 初始化
        /// </summary>
        public void Initialize() {
            byte[] stream = null;
            string uri = string.Empty;
            bundles = new Dictionary<string, AssetBundle>();
            uri = Util.DataPath + AppConst.AssetDir;
            if (!File.Exists(uri)) return;
            stream = File.ReadAllBytes(uri);
            assetbundle = AssetBundle.LoadFromMemory(stream);
            manifest = assetbundle.LoadAsset<AssetBundleManifest>("AssetBundleManifest");
        }

        /// <summary>
        /// 载入素材
        /// </summary>
        public T LoadAsset<T>(string abname, string assetname) where T : UnityEngine.Object {
            abname = abname.ToLower();
            AssetBundle bundle = LoadAssetBundle(abname);
            return bundle.LoadAsset<T>(assetname);
        }

        public void LoadPrefab(string abName, string[] assetNames, LuaFunction func) {
            abName = abName.ToLower();
            List<UObject> result = new List<UObject>();
            for (int i = 0; i < assetNames.Length; i++) {
                UObject go = LoadAsset<UObject>(abName, assetNames[i]);
                if (go != null) result.Add(go);
            }
            if (func != null) func.Call((object)result.ToArray());
        }

        /// <summary>
        /// 载入AssetBundle
        /// </summary>
        /// <param name="abname"></param>
        /// <returns></returns>
        public AssetBundle LoadAssetBundle(string abname) {
            if (!abname.EndsWith(AppConst.BundleExt)) {
                abname += AppConst.BundleExt;
            }
            AssetBundle bundle = null;
            if (!bundles.ContainsKey(abname)) {
                byte[] stream = null;
                string uri = Util.DataPath + abname;
                Debug.LogWarning("LoadFile::>> " + uri);
                LoadDependencies(abname);

                stream = File.ReadAllBytes(uri);
                bundle = AssetBundle.LoadFromMemory(stream); //关联数据的素材绑定
                bundles.Add(abname, bundle);
            } else {
                bundles.TryGetValue(abname, out bundle);
            }
            return bundle;
        }

        /// <summary>
        /// 载入依赖
        /// </summary>
        /// <param name="name"></param>
        void LoadDependencies(string name) {
            if (manifest == null) {
                Debug.LogError("Please initialize AssetBundleManifest by calling AssetBundleManager.Initialize()");
                return;
            }
            // Get dependecies from the AssetBundleManifest object..
            string[] dependencies = manifest.GetAllDependencies(name);
            if (dependencies.Length == 0) return;

            for (int i = 0; i < dependencies.Length; i++)
                dependencies[i] = RemapVariantName(dependencies[i]);

            // Record and load all dependencies.
            for (int i = 0; i < dependencies.Length; i++) {
                LoadAssetBundle(dependencies[i]);
            }
        }

        // Remaps the asset bundle name to the best fitting asset bundle variant.
        string RemapVariantName(string assetBundleName) {
            string[] bundlesWithVariant = manifest.GetAllAssetBundlesWithVariant();

            // If the asset bundle doesn't have variant, simply return.
            if (System.Array.IndexOf(bundlesWithVariant, assetBundleName) < 0)
                return assetBundleName;

            string[] split = assetBundleName.Split('.');

            int bestFit = int.MaxValue;
            int bestFitIndex = -1;
            // Loop all the assetBundles with variant to find the best fit variant assetBundle.
            for (int i = 0; i < bundlesWithVariant.Length; i++) {
                string[] curSplit = bundlesWithVariant[i].Split('.');
                if (curSplit[0] != split[0])
                    continue;

                int found = System.Array.IndexOf(m_Variants, curSplit[1]);
                if (found != -1 && found < bestFit) {
                    bestFit = found;
                    bestFitIndex = i;
                }
            }
            if (bestFitIndex != -1)
                return bundlesWithVariant[bestFitIndex];
            else
                return assetBundleName;
        }

        /// <summary>
        /// 销毁资源
        /// </summary>
        void OnDestroy() {
            if (shared != null) shared.Unload(true);
            if (manifest != null) manifest = null;
            Debug.Log("~ResourceManager was destroy!");
        }
    }
}
#endif
