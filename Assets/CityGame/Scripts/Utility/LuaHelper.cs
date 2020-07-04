using UnityEngine;
using System.Collections.Generic;
using System.Reflection;
using LuaInterface;
using System;

namespace LuaFramework {
    public static class LuaHelper
    {

        /// <summary>
        /// getType
        /// </summary>
        /// <param name="classname"></param>
        /// <returns></returns>
        public static System.Type GetType(string classname)
        {
            Assembly assb = Assembly.GetExecutingAssembly();  //.GetExecutingAssembly();
            System.Type t = null;
            t = assb.GetType(classname); ;
            if (t == null)
            {
                t = assb.GetType(classname);
            }

            System.Type t1 = System.Reflection.Assembly.Load("UnityEngine").GetType(classname);
            System.Type[] types = assb.GetTypes();            
            System.Type[] types1 = assb.GetExportedTypes();

            return t;
        }

        /// <summary>
        /// Panel Manager
        /// </summary>
        public static PanelManager GetPanelManager()
        {
            return AppFacade.Instance.GetManager<PanelManager>(ManagerName.Panel);
        }

        /// <summary>
        /// Resource manager
        /// </summary>
        public static ResourceManager GetResManager()
        {
            return AppFacade.Instance.GetManager<ResourceManager>(ManagerName.Resource);
        }

        /// <summary>
        /// Music manager
        /// </summary>
        public static SoundManager GetSoundManager()
        {
            return AppFacade.Instance.GetManager<SoundManager>(ManagerName.Sound);
        }

        /// <summary>
        /// Building manager
        /// </summary>
        public static BuildManager GetBuildManager()
        {
            return AppFacade.Instance.GetManager<BuildManager>(ManagerName.Build);
        }

        /// <summary>
        /// Ray Manager
        /// </summary>
        public static RayManager GetRayManager()
        {
            return AppFacade.Instance.GetManager<RayManager>(ManagerName.Ray);
        }

        /// <summary>
        /// pbc/pblua function callback
        /// </summary>
        /// <param name="func"></param>
        public static void OnCallLuaFunc(LuaByteBuffer data, LuaFunction func)
        {
            if (func != null) func.Call(data);
            Debug.LogWarning("OnCallLuaFunc length:>>" + data.buffer.Length);
        }

        /// <summary>
        /// cjson function callback
        /// </summary>
        /// <param name="data"></param>
        /// <param name="func"></param>
        public static void OnJsonCallFunc(string data, LuaFunction func)
        {
            Debug.LogWarning("OnJsonCallback data:>>" + data + " lenght:>>" + data.Length);
            if (func != null) func.Call(data);
        }
    }
}