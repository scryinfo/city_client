using UnityEngine;
using System.Collections;
using System.IO;
using LuaInterface;

namespace LuaFramework {
    /// <summary>
    /// Integrated from LuaFileUtils, rewrite the ReadFile inside
    /// </summary>
    public class LuaLoader : LuaFileUtils {
        private ResourceManager m_resMgr;

        ResourceManager resMgr {
            get { 
                if (m_resMgr == null)
                    m_resMgr = AppFacade.Instance.GetManager<ResourceManager>(ManagerName.Resource);
                return m_resMgr;
            }
        }

        // Use this for initialization
        public LuaLoader() {
            instance = this;
            beZip = AppConst.LuaBundleMode;
        }

        /// <summary>
        /// Add AssetBundle into Lua code
        /// </summary>
        /// <param name="bundle"></param>
        public void AddBundle(string bundleName) {
            string url = Util.DataPath + bundleName.ToLower();
            if (File.Exists(url)) {
                var bytes = File.ReadAllBytes(url);
                AssetBundle bundle = AssetBundle.LoadFromMemory(bytes);
                if (bundle != null)
                {
                    bundleName = bundleName.Replace("lua/", "").Replace("lua\\", "").Replace(".unity3d", "");
                    base.AddSearchBundle(bundleName.ToLower(), bundle);
                }
            }
        }

        /// <summary>
        /// When LuaVM loads the Lua file, it will be called here,
        /// The user can customize the loading behavior, as long as it returns byte[].
        /// </summary>
        /// <param name="fileName"></param>
        /// <returns></returns>
        public override byte[] ReadFile(string fileName) {
            return base.ReadFile(fileName);     
        }
    }
}