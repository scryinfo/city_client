using UnityEngine;
using LuaFramework;
using System.Collections.Generic;

public class AppView : View {
    private string message;

    ///<summary>
    /// Monitored messages
    ///</summary>
    List<string> MessageList {
        get {
            return new List<string>()
            { 
                NotiConst.UPDATE_MESSAGE,
                NotiConst.UPDATE_EXTRACT,
                NotiConst.UPDATE_DOWNLOAD,
                NotiConst.UPDATE_PROGRESS,
            };
        }
    }

    void Awake() {
        RemoveMessage(this, MessageList);
        RegisterMessage(this, MessageList);
    }

    /// <summary>
    /// Handle View messages
    /// </summary>
    /// <param name="message"></param>
    public override void OnMessage(IMessage message) {
        string name = message.Name;
        object body = message.Body;
        switch (name) {
            case NotiConst.UPDATE_MESSAGE:      //Update message
                UpdateMessage(body.ToString());
            break;
            case NotiConst.UPDATE_EXTRACT:      //Update and unzip
                UpdateExtract(body.ToString());
            break;
            case NotiConst.UPDATE_DOWNLOAD:     //Update download
                UpdateDownload(body.ToString());
            break;
            case NotiConst.UPDATE_PROGRESS:     //Update download progress
                UpdateProgress(body.ToString());
            break;
        }
    }

    public void UpdateMessage(string data) {
        this.message = data;
    }

    public void UpdateExtract(string data) {
        this.message = data;
    }

    public void UpdateDownload(string data) {
        this.message = data;
    }

    public void UpdateProgress(string data) {
        this.message = data;
    }

    void OnGUI() {
        GUI.Label(new Rect(10, 120, 960, 50), message);

        GUI.Label(new Rect(10, 0, 500, 50), "(1) 单击 \"Lua/Gen Lua Wrap Files\"。");
        GUI.Label(new Rect(10, 20, 500, 50), "(2) 运行Unity游戏");
        GUI.Label(new Rect(10, 40, 500, 50), "PS: 清除缓存，单击\"Lua/Clear LuaBinder File + Wrap Files\"。");
        GUI.Label(new Rect(10, 60, 900, 50), "PS: 若运行到真机，请设置Const.DebugMode=false，本地调试请设置Const.DebugMode=true");
        GUI.Label(new Rect(10, 80, 500, 50), "PS: 加Unity+ulua技术讨论群：>>341746602");
    }
}
