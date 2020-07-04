using UnityEngine;
using System.Collections;

public class NotiConst
{
    /// <summary>
    /// Controller layer message notification
    /// </summary>
    public const string START_UP = "StartUp";                       //Start frame
    public const string DISPATCH_MESSAGE = "DispatchMessage";       //Distribute information

    /// <summary>
    /// View layer message notification
    /// </summary>
    public const string UPDATE_MESSAGE = "UpdateMessage";           //Update message
    public const string UPDATE_EXTRACT = "UpdateExtract";           //Update unpack
    public const string UPDATE_DOWNLOAD = "UpdateDownload";         //Update download
    public const string UPDATE_PROGRESS = "UpdateProgress";         //Update progress
}
