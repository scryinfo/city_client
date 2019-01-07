﻿using UnityEngine;
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
        /// 面板管理器
        /// </summary>
        public static PanelManager GetPanelManager()
        {
            return AppFacade.Instance.GetManager<PanelManager>(ManagerName.Panel);
        }

        /// <summary>
        /// 资源管理器
        /// </summary>
        public static ResourceManager GetResManager()
        {
            return AppFacade.Instance.GetManager<ResourceManager>(ManagerName.Resource);
        }

        /// <summary>
        /// 音乐管理器
        /// </summary>
        public static SoundManager GetSoundManager()
        {
            return AppFacade.Instance.GetManager<SoundManager>(ManagerName.Sound);
        }

        /// <summary>
        /// 建筑管理器
        /// </summary>
        public static BuildManager GetBuildManager()
        {
            return AppFacade.Instance.GetManager<BuildManager>(ManagerName.Build);
        }

        /// <summary>
        /// 射线管理器
        /// </summary>
        public static RayManager GetRayManager()
        {
            return AppFacade.Instance.GetManager<RayManager>(ManagerName.Ray);
        }

        /// <summary>
        /// pbc/pblua函数回调
        /// </summary>
        /// <param name="func"></param>
        public static void OnCallLuaFunc(LuaByteBuffer data, LuaFunction func)
        {
            if (func != null) func.Call(data);
            Debug.LogWarning("OnCallLuaFunc length:>>" + data.buffer.Length);
        }

        /// <summary>
        /// cjson函数回调
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