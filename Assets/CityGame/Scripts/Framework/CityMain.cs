using UnityEngine;
using System;
using System.Collections;
using City;

/*
	Can be understood as the entry module of the plugin
*/
	
public class CityMain : MonoBehaviour 
{	
	// Options visible in unity3d interface
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
        // Handle events thrown in the outer layer
        City.Event.processInEvents();
        City.Event.processOutEvents();
	}

}
