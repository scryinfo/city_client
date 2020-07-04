using UnityEngine;
using City;
using System;
using System.Collections;
using System.Collections.Generic;

namespace City
{
	public enum DEBUGLEVEL : int
	{
		DEBUG = 0,
		INFO,
		WARNING,
		ERROR,

		NOLOG,  // Put it at the end, when using this, it means that no logs will be output (!!!Use with caution!!!)
	}

    public enum SYSEVENT : int
    {
        SYSEVENT_DEFAULT = 0,
        SYSEVENT_DISCONNECT,
        SYSEVENT_NONE,  // Put it at the end, when using this, it means that no logs will be output (!!!Use with caution!!!)
    }

    public class Dbg 
	{
		static public DEBUGLEVEL debugLevel = DEBUGLEVEL.DEBUG;

#if UNITY_EDITOR
		static Dictionary<string, Profile> _profiles = new Dictionary<string, Profile>();
#endif

		public static string getHead()
		{
			return "[" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss fff") + "] ";
		}

		public static void INFO_MSG(object s)
		{
			if (DEBUGLEVEL.INFO >= debugLevel)
				Debug.Log(getHead() + s);
		}

		public static void DEBUG_MSG(object s)
		{
			if (DEBUGLEVEL.DEBUG >= debugLevel)
				Debug.Log(getHead() + s);
		}

		public static void WARNING_MSG(object s)
		{
			if (DEBUGLEVEL.WARNING >= debugLevel)
				Debug.LogWarning(getHead() + s);
		}

		public static void ERROR_MSG(object s)
		{
			if (DEBUGLEVEL.ERROR >= debugLevel)
				Debug.LogError(getHead() + s);
		}

		public static void profileStart(string name)
		{
#if UNITY_EDITOR
			Profile p = null;
			if(!_profiles.TryGetValue(name, out p))
			{
				p = new Profile(name);
				_profiles.Add(name, p);
			}

			p.start();
#endif
		}

		public static void profileEnd(string name)
		{
#if UNITY_EDITOR
			_profiles[name].end();
#endif
		}
		
	}
}
