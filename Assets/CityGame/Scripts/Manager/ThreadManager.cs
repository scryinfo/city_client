using System.Collections;
using System.Threading;
using System.Collections.Generic;
using System.IO;
using System.Diagnostics;
using System.Net;
using System;

public class ThreadEvent {
    public string Key;
    public List<object> evParams = new List<object>();
}

public class NotiData {
    public string evName;
    public object evParam;

    public NotiData(string name, object param) {
        this.evName = name;
        this.evParam = param;
    }
}

namespace LuaFramework {
    /// <summary>
    /// The current thread manager can only do one task at a time
    /// </summary>
    public class ThreadManager : Manager {
        private Thread thread;
        private Action<NotiData> func;
        private Stopwatch sw = new Stopwatch();
        private string currDownFile = string.Empty;

        static readonly object m_lockObject = new object();
        static Queue<ThreadEvent> events = new Queue<ThreadEvent>();

        delegate void ThreadSyncEvent(NotiData data);
        private ThreadSyncEvent m_SyncEvent;

        void Awake() {
            m_SyncEvent = OnSyncEvent;
            thread = new Thread(OnUpdate);
        }

        // Use this for initialization
        void Start() {
            thread.Start();
        }

        /// <summary>
        /// Add to event queue
        /// </summary>
        public void AddEvent(ThreadEvent ev, Action<NotiData> func) {
            lock (m_lockObject) {
                this.func = func;
                events.Enqueue(ev);
            }
        }

        /// <summary>
        /// Notification event
        /// </summary>
        /// <param name="state"></param>
        private void OnSyncEvent(NotiData data) {
            if (this.func != null) func(data);  //Callback logic layer
            facade.SendMessageCommand(data.evName, data.evParam); //Notify the View layer
        }

        // Update is called once per frame
        void OnUpdate() {
            while (true) {
                lock (m_lockObject) {
                    if (events.Count > 0) {
                        ThreadEvent e = events.Dequeue();
                        try {
                            switch (e.Key) {
                                case NotiConst.UPDATE_EXTRACT: {     //unzip files
                                    OnExtractFile(e.evParams);
                                }
                                break;
                                case NotiConst.UPDATE_DOWNLOAD: {    //download file
                                    OnDownloadFile(e.evParams);
                                }
                                break;
                            }
                        } catch (System.Exception ex) {
                            UnityEngine.Debug.LogError(ex.Message);
                        }
                    }
                }
                Thread.Sleep(1);
            }
        }

        /// <summary>
        /// download file
        /// </summary>
        void OnDownloadFile(List<object> evParams) {
            string url = evParams[0].ToString();    
            currDownFile = evParams[1].ToString();

            using (WebClient client = new WebClient()) {
                sw.Start();
                client.DownloadProgressChanged += new DownloadProgressChangedEventHandler(ProgressChanged);
                client.DownloadFileAsync(new System.Uri(url), currDownFile);
            }
        }

        private void ProgressChanged(object sender, DownloadProgressChangedEventArgs e) {
            //UnityEngine.Debug.Log(e.ProgressPercentage);
            /*
            UnityEngine.Debug.Log(string.Format("{0} MB's / {1} MB's",
                (e.BytesReceived / 1024d / 1024d).ToString("0.00"),
                (e.TotalBytesToReceive / 1024d / 1024d).ToString("0.00")));
            */
            //float value = (float)e.ProgressPercentage / 100f;

            string value = string.Format("{0} kb/s", (e.BytesReceived / 1024d / sw.Elapsed.TotalSeconds).ToString("0.00"));
            NotiData data = new NotiData(NotiConst.UPDATE_PROGRESS, value);
            if (m_SyncEvent != null) m_SyncEvent(data);

            if (e.ProgressPercentage == 100 && e.BytesReceived == e.TotalBytesToReceive) {
                sw.Reset();

                data = new NotiData(NotiConst.UPDATE_DOWNLOAD, currDownFile);
                if (m_SyncEvent != null) m_SyncEvent(data);
            }
        }

        /// <summary>
        /// Calling method
        /// </summary>
        void OnExtractFile(List<object> evParams) {
            UnityEngine.Debug.LogWarning("Thread evParams: >>" + evParams.Count);

            ///------------------Notify that the update panel is decompressed--------------------
            NotiData data = new NotiData(NotiConst.UPDATE_DOWNLOAD, null);
            if (m_SyncEvent != null) m_SyncEvent(data);
        }

        /// <summary>
        /// Application exit
        /// </summary>
        void OnDestroy() {
            thread.Abort();
        }
    }
}