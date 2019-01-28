using UnityEngine;
using System;
using System.Collections;
using City;

/*
	可以理解为插件的入口模块
*/
	
public class CityMain : MonoBehaviour 
{	
	// 在unity3d界面中可见选项
	public DEBUGLEVEL debugLevel = DEBUGLEVEL.DEBUG;
    static public bool isStartEngine = false;

	void Awake() 
	 {
		DontDestroyOnLoad(transform.gameObject);
	 }
 
	// Use this for initialization
	void Start () 
	{
		MonoBehaviour.print("clientapp::start()");
	}
	
	public virtual void initCityEngine()
	{
        isStartEngine = true;
		Dbg.debugLevel = debugLevel;

        City.Event.registerIn("_closeNetwork", this, "_closeNetwork");

        CityLuaUtil.CallMethod("CityEngineLua", "InitEngine");
	}

    public void _closeNetwork(NetworkInterface networkInterface)
    {
        networkInterface.close();
        networkInterface._onConnectionState(networkInterface._ConnectState);
    }	

	void OnDestroy()
	{
		MonoBehaviour.print("clientapp::OnDestroy(): begin");

        Dbg.WARNING_MSG("City::destroy()");
        City.Event.deregisterIn(this);

		MonoBehaviour.print("clientapp::OnDestroy(): end");
	}
	
	void FixedUpdate () 
	{
        // 处理外层抛入的事件
        City.Event.processInEvents();
        City.Event.processOutEvents();
	}

}
