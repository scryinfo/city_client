using System.Collections;
using System.Collections.Generic;
using City;
using UnityEngine;

public class CheckAvailability : MonoBehaviour
{
    //检查钱包是否可用
    public void OnActivityResult(string resultData)
    {
        if (resultData == "NoCashBox")
        {
            CityLuaUtil.CallMethod("CityEngineLua", "NoCashBox");
        }
        else if (resultData == "Fail")
        {
            CityLuaUtil.CallMethod("CityEngineLua", "Fail");
        }
        else if (resultData == "Success")
        {
            CityLuaUtil.CallMethod("CityEngineLua", "GotoCashBox");
        }     
    }

}
