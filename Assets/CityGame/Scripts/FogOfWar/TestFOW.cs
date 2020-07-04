using UnityEngine;
using System.Collections;
using Battle;

public class TestFOW : MonoBehaviour
{
    GameObject debugUI = null;
    public bool IsRefresh;

	// Use this for initialization
	void Start () {
        IsRefresh = true;
        // fow system start
        FOWLogic.instance.Startup();
        // Notify the character is born
        Messenger.Broadcast(MessageName.MN_CHARACTOR_BORN, 1);
    }
	
	void Update () {
        int deltaMS = (int)(Time.deltaTime * 1000f);
        if (IsRefresh)
        {
            FOWLogic.instance.Update(deltaMS);
        }
        
	}

    void OnDistory()
    {
        FOWLogic.instance.Dispose();
    }
}
