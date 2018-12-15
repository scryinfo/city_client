using UnityEngine;
using System.Collections.Generic;
using System.Reflection;
using LuaInterface;
using System.Runtime.InteropServices;
using System;
using System.IO;
using System.Text;
using City;
using LuaFramework;

namespace City
{
    public struct Sync_LoadData
    {
        public AssetBundle _bunldle;
        public UnityEngine.Object _asset;
    };
    public static class CityTest
    {
        public static void Test()
        {
            Debug.Log("测试静态方法");
        }

        public static void Test1()
        {
            Debug.Log("测试静态方法1");
        }

        public static void Test2()
        {
            Debug.Log("测试静态方法2");
        }
    }
    public static class CityLuaUtil
    {
        static string GetAssetName(ref string releativePath)
        {
            int pos = releativePath.LastIndexOf('/');
            return releativePath.Remove(0, pos + 1);
        }
        static string GetBundleName(ref string releativePath)
        {
            string outstr = releativePath.Replace("/", "_");
            return outstr.ToLower() + AppConst.BundleExt;
        }

        public static ResourceManager GetResManager()
        {
            return AppFacade.Instance.GetManager<ResourceManager>(ManagerName.Resource);
        }

        public static Sync_LoadData LoadRes_S(string releativePath, System.Type type = null)
        {
            //1、 根据项目资源bundle命名规则，把传入的资源相对路径转为对应的bundle名字，同步加载bundle
            Sync_LoadData retObj;
            retObj._asset = null;
            retObj._bunldle = null;
            string assetName = releativePath;
            if (type == null)
            {
                type = typeof(GameObject);
            }

#if RES_BUNDEL            
            assetName = GetAssetName(ref releativePath);
            string abName = GetBundleName(ref releativePath);
            abName = City.CityLuaUtil.getLuaBundelPath() + "/" + abName;
            //同步加载bundle
            retObj._bunldle = AssetBundle.LoadFromFile(abName);
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
            retObj._asset = UnityEngine.Resources.Load(releativePath);
#endif      
            return retObj;
        }

        public static void LoadRes_A(string bundlePath, string assetName, System.Type type = null, object objInstance = null, LuaFunction func = null)
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

        public static System.Type getSpriteType()
        {
            return typeof(UnityEngine.Sprite) ;
        }
        public static UIRoot GetUIRoot()
        {
            return UIRoot.Instance;
        }

        public static Transform getFixedRoot()
        {
            return UIRoot.getFixedRoot();
        }

        public static bool isWindowsEditor()
        {
            return Application.platform == RuntimePlatform.WindowsEditor;
        }

        public static bool isluaLogEnable()
        {
#if LUA_LOG
            return true;
#else
            return false;
#endif
        }

        public static string getAssetsPath()
        {
            if (Application.platform == RuntimePlatform.Android)
            {
                return UnityEngine.Application.persistentDataPath + "/CityGame";
            }
            else
            {
#if LUA_BUNDEL             
            return "Assets/CityGame";
#else
            return "Assets/CityGame";
                
#endif
            }
        }

        public static string getLuaBundelPath()
        {
            if (Application.platform == RuntimePlatform.Android)
            {
                return UnityEngine.Application.persistentDataPath + "/CityGame";
            }
            else
            {
                return Application.streamingAssetsPath;
            }
        }

        public static string getDataPath()
        {
            return UnityEngine.Application.dataPath;
        }

        public static object getUiCamera()
        {
            return UIRoot.getUiCamera();
        }

        public static Transform getNormalRoot()
        {
            return UIRoot.getNormalRoot();
        }

        public static Transform getPopupRoot()
        {
            return UIRoot.getPopupRoot();
        }

        // go 是脚本要挂到的目标对象，一般是一个prefab实例； luaPath 是要挂到目标对象上的lua脚本的路径
        public static Component AddLuaComponent(GameObject go, string luaPath)
        {
            LuaComponent com = go.AddComponent<LuaComponent>() as LuaComponent;
            com.reAwake(luaPath);
            return com;
        }


        public delegate object[] CallLuaFunction(string funcName, params object[] args);
        private static CallLuaFunction callFunction = null;
        public static byte[] Utf8ToByte(object utf8)
        {
            return System.Text.Encoding.UTF8.GetBytes((string)utf8);
        }

        public static string ByteToUtf8(byte[] bytes)
        {
            return System.Text.Encoding.UTF8.GetString(bytes);
        }

        public static void ArrayCopy(byte[] srcdatas, long srcLen, byte[] dstdatas, long dstLen, long len)
        {
            Array.Copy(srcdatas, srcLen, dstdatas, dstLen, len);
        }

        public static void Log(string str)
        {
            Debug.Log(str);
        }

        public static void LogWarning(string str)
        {
            Debug.LogWarning(str);
        }

        public static void LogError(string str)
        {
            Debug.LogError(str);
        }

        public static void SetCallLuaFunction(CallLuaFunction clf)
        {
            callFunction = clf;
        }

        public static void ClearCallLuaFunction()
        {
            callFunction = null;
        }
        /// <summary>
        /// 执行Lua方法..
        /// </summary>
        public static object[] CallMethod(string module, string func, params object[] args)
        {
            if(callFunction != null)
            {
                return callFunction(module + "." + func, args);
            }
            return null;
        }

        public static object[] CallMethod(string func, params object[] args)
        {
            if (callFunction != null)
            {
                return callFunction(func, args);
            }
            return null;
        }

        public static void createFile(string path, string name, byte[] datas)
        {
            deleteFile(path, name);
            Dbg.DEBUG_MSG("createFile: " + path + "/" + name);
            FileStream fs = new FileStream(path + "/" + name, FileMode.OpenOrCreate, FileAccess.Write);
            fs.Write(datas, 0, datas.Length);
            fs.Close();
            fs.Dispose();
        }

        public static byte[] loadFile(string path, string name, bool printerr)
        {
            FileStream fs;

            try
            {
                fs = new FileStream(path + "/" + name, FileMode.Open, FileAccess.Read);
            }
            catch (Exception e)
            {
                if (printerr)
                {
                    Dbg.ERROR_MSG("loadFile: " + path + "/" + name);
                    Dbg.ERROR_MSG(e.ToString());
                }

                return new byte[0];
            }

            byte[] datas = new byte[fs.Length];
            fs.Read(datas, 0, datas.Length);
            fs.Close();
            fs.Dispose();

            Dbg.DEBUG_MSG("loadFile: " + path + "/" + name + ", datasize=" + datas.Length);
            return datas;
        }

        public static void deleteFile(string path, string name)
        {
            //Dbg.DEBUG_MSG("deleteFile: " + path + "/" + name);

            try
            {
                File.Delete(path + "/" + name);
            }
            catch (Exception e)
            {
                Debug.LogError(e.ToString());
            }
        }
        public static byte[] StringToByteArray(string hexString)
        {
            hexString = hexString.Replace(" ", "");
            if ((hexString.Length % 2) != 0)
                hexString += " ";
            byte[] returnBytes = new byte[hexString.Length / 2];
            for (int i = 0; i < returnBytes.Length; i++)
                returnBytes[i] = Convert.ToByte(hexString.Substring(i * 2, 2), 16);
            return returnBytes;
        }

        public static string ByteArrayToString(byte[] ba)
        {
            StringBuilder hex = new StringBuilder(ba.Length * 2);
            foreach (byte b in ba)
                hex.AppendFormat("{0:x2}", b);
            return hex.ToString();
        }

        public static String convert(byte b)
        {
            StringBuilder str = new StringBuilder(8);
            int[] bl = new int[8];

            for (int i = 0; i < bl.Length; i++)
            {
                bl[bl.Length - 1 - i] = ((b & (1 << i)) != 0) ? 1 : 0;
            }

            foreach (int num in bl) str.Append(num);

            return str.ToString();
        }

        public static string bytesToString(byte[] bytes)
        {

            /* return  ByteArrayToString(bytes);*/
            StringBuilder destString = new StringBuilder(bytes.Length);
            for (int i = 0; i < bytes.Length; i++)
            {
                destString.Append(bytes[i]);
            }
            return destString.ToString();

            //System.Text.ASCIIEncoding encoding = new System.Text.ASCIIEncoding();
            //return encoding.GetString(bytes, 0, bytes.Length);     

        }

        public static byte[] stringToBytes(string str)
        {
            System.Text.ASCIIEncoding encoding = new System.Text.ASCIIEncoding();
            return encoding.GetBytes(str);
        }
    }
}