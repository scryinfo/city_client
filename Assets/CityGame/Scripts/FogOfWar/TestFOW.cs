using UnityEngine;
using System.Collections;
using Battle;

public class TestFOW : MonoBehaviour
{
    GameObject debugUI = null;

	// Use this for initialization
	void Start () {
        // fow系统启动
        FOWLogic.instance.Startup();
        // 通知角色出生
        Messenger.Broadcast(MessageName.MN_CHARACTOR_BORN, 1);
    }
	
	void Update () {
        int deltaMS = (int)(Time.deltaTime * 1000f);
        FOWLogic.instance.Update(deltaMS);
	}

    void OnDistory()
    {
        FOWLogic.instance.Dispose();
    }
}
