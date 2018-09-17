using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;

class GameServerInfo
{
    public Int32 serverId = 210;
}

public class AppFacade : Facade
{
    private static AppFacade _instance;

    public AppFacade() : base()
    {
    }

    public static AppFacade Instance
    {
        get{
            if (_instance == null) {
                _instance = new AppFacade();
            }
            return _instance;
        }
    }

    override protected void InitFramework()
    {
        base.InitFramework();
        RegisterCommand(NotiConst.START_UP, typeof(StartUpCommand));
    }

    /// <summary>
    /// 启动框架
    /// </summary>
    public void StartUp() {
        SendMessageCommand(NotiConst.START_UP);
        RemoveMultiCommand(NotiConst.START_UP);

        //pb test
        //GameServerInfo.Builder newContact = GameServerInfo.CreateBuilder();

        /*GameServerInfo pGameServerInfo;
        pGameServerInfo.serverId = 210;

        var gameServerInfo = new GameServerInfo
        {
            serverId = 210;
        };
        using (var file = File.Create("person.bin"))
        {
            Serializer.Serialize(file, person);
        }*/

    }
}

