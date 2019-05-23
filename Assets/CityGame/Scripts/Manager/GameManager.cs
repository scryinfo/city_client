using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
using LuaInterface;
using System.Reflection;
using System.IO;
using UnityEngine.UI;
using DG.Tweening;

namespace LuaFramework
{
    public class GameManager : Manager
    {
        protected static bool initialize = false;
        private List<string> downloadFiles = new List<string>();
        private GameObject startPanel;  //加载界面
        private CanvasGroup startGroup; //加载界面BG显影
        /// <summary>
        /// 初始化游戏管理器
        /// </summary>
        void Awake()
        {
            if (AppConst.UpdateMode)
            {
                StartLoadPanel();
            }
            else
            {
                Init();
            }
          
            //if (AppConst.UpdateMode)
            //{
            //    LoadHotFixPanel();
            //}
        }
        //游戏加载界面
        void StartLoadPanel()
        {
            startPanel = Instantiate(Resources.Load<GameObject>("View/GameStartPanel"));
            startGroup = startPanel.transform.Find("bg").GetComponent<CanvasGroup>();
            StartCoroutine(GroupFade());
        }
        //加载界面淡入淡出
        IEnumerator GroupFade()
        {
            startGroup.DOFade(1, 5);
            yield return new WaitForSeconds(5);
            Destroy(startPanel);
            Init();
            if (AppConst.UpdateMode)
            {
                LoadHotFixPanel();
            }
        }
        private Text content;
        private Text progress;
        private Text speed;
        private RectTransform contentBg;
        private Slider slider;
        private GameObject panel;

        void LoadHotFixPanel()
        {
            panel = Instantiate(Resources.Load<GameObject>("View/HotfixPanel"));
            contentBg = panel.transform.Find("HotfixPanel/contentBg").GetComponent<RectTransform>();
            content = panel.transform.Find("HotfixPanel/contentBg/textBG/Text").GetComponent<Text>();
            progress = panel.transform.Find("HotfixPanel/contentBg/Slider/progress").GetComponent<Text>();
            speed = panel.transform.Find("HotfixPanel/contentBg/Slider/progress/speed").GetComponent<Text>();
            slider = FindObjectOfType<Slider>();
        }

        /// <summary>
        /// 初始化
        /// </summary>
        void Init()
        {
            DontDestroyOnLoad(gameObject);  //防止销毁自己

            CheckExtractResource(); //释放资源
            Screen.sleepTimeout = SleepTimeout.NeverSleep;
            QualitySettings.vSyncCount = 0;//关闭垂直同步
            Application.targetFrameRate = AppConst.GameFrameRate;
        }

        /// <summary>
        /// 释放资源
        /// </summary>
        public void CheckExtractResource()
        {
            bool isExists = Directory.Exists(Util.DataPath) &&
              Directory.Exists(Util.DataPath + "lua/") && File.Exists(Util.DataPath + "files.txt");
            if (isExists || AppConst.DebugMode)
            {
                StartCoroutine(OnUpdateResource());
                return;   //文件已经解压过了，自己可添加检查文件列表逻辑
            }
            StartCoroutine(OnExtractResource());    //启动释放协成 
        }

        IEnumerator OnExtractResource()
        {
            string dataPath = Util.DataPath;  //数据目录
            string resPath = Util.AppContentPath(); //游戏包资源目录

            if (Directory.Exists(dataPath)) Directory.Delete(dataPath, true);
            Directory.CreateDirectory(dataPath);

            string infile = resPath + "files.txt";
            string outfile = dataPath + "files.txt";
            if (File.Exists(outfile)) File.Delete(outfile);

            string message = "正在解包文件:>files.txt";
            Debug.Log(infile);
            Debug.Log(outfile);
            if (Application.platform == RuntimePlatform.Android)
            {
                WWW www = new WWW(infile);
                yield return www;

                if (www.isDone)
                {
                    File.WriteAllBytes(outfile, www.bytes);
                }
                yield return 0;
            }
            else File.Copy(infile, outfile, true);
            yield return new WaitForEndOfFrame();

            //释放所有文件到数据目录
            string[] files = File.ReadAllLines(outfile);
            foreach (var file in files)
            {
                string[] fs = file.Split('|');
                infile = resPath + fs[0];  //
                outfile = dataPath + fs[0];

                message = "正在解包文件:>" + fs[0];
                Debug.Log("正在解包文件:>" + infile);
                facade.SendMessageCommand(NotiConst.UPDATE_MESSAGE, message);

                string dir = Path.GetDirectoryName(outfile);
                if (!Directory.Exists(dir)) Directory.CreateDirectory(dir);

                if (Application.platform == RuntimePlatform.Android)
                {
                    WWW www = new WWW(infile);
                    yield return www;

                    if (www.isDone)
                    {
                        File.WriteAllBytes(outfile, www.bytes);
                    }
                    yield return 0;
                }
                else
                {
                    if (File.Exists(outfile))
                    {
                        File.Delete(outfile);
                    }
                    File.Copy(infile, outfile, true);
                }
                yield return new WaitForEndOfFrame();
            }
            message = "解包完成!!!";
            facade.SendMessageCommand(NotiConst.UPDATE_MESSAGE, message);
            yield return new WaitForSeconds(0.1f);

            message = string.Empty;
            //释放完成，开始启动更新资源
            StartCoroutine(OnUpdateResource());
        }
        List<m_boject> m_ojects = new List<m_boject>();
        /// <summary>
        /// 启动更新下载，这里只是个思路演示，此处可启动线程下载更新
        /// </summary>
        IEnumerator OnUpdateResource()
        {
            if (!AppConst.UpdateMode)
            {
                OnResourceInited();
                yield break;
            }
            string dataPath = Util.DataPath;  //数据目录
            string url = AppConst.WebUrl;
            string message = string.Empty;
            //string random = DateTime.Now.ToString("yyyymmddhhmmss");
            string random = "v=20181227";
            //string listUrl = url + "files.txt?v=" + random;
            string listUrl = url + "files.txt";
            Debug.LogWarning("LoadUpdate---->>>" + listUrl);

            WWW www = new WWW(listUrl); yield return www;
            if (www.error != null)
            {
                OnUpdateFailed(string.Empty);
                yield break;
            }
            if (!Directory.Exists(dataPath))
            {
                Directory.CreateDirectory(dataPath);
            }
            File.WriteAllBytes(dataPath + "files.txt", www.bytes);
            string filesText = www.text;
            string[] files = filesText.Split('\n');
            for (int i = 0; i < files.Length; i++)
            {
                if (string.IsNullOrEmpty(files[i])) continue;
                string[] keyValue = files[i].Split('|');
                string f = keyValue[0];
                string localfile = (dataPath + f).Trim();
                string path = Path.GetDirectoryName(localfile);
                if (!Directory.Exists(path))
                {
                    Directory.CreateDirectory(path);
                }
                string fileUrl = url + f;
                bool canUpdate = !File.Exists(localfile);
                if (!canUpdate)
                {
                    string remoteMd5 = keyValue[1].Trim();
                    string localMd5 = Util.md5file(localfile);
                    canUpdate = !remoteMd5.Equals(localMd5);
                    if (canUpdate) File.Delete(localfile);
                }
                if (canUpdate)
                {   //本地缺少文件
                    // Debug.Log(fileUrl);
                    message = "downloading>>" + fileUrl;
                    facade.SendMessageCommand(NotiConst.UPDATE_MESSAGE, message);
                    /*
                    www = new WWW(fileUrl); yield return www;
                    if (www.error != null) {
                        OnUpdateFailed(path);   //
                        yield break;
                    }
                    File.WriteAllBytes(localfile, www.bytes);
                     */
                    //这里都是资源文件
                    m_ojects.Add(new m_boject(fileUrl, localfile));
                    // BeginDownload(fileUrl, localfile);

                    // while (!(IsDownOK(m_ojects[i].localfile))) { yield return new WaitForEndOfFrame(); }
                }
            }
            yield return new WaitForEndOfFrame();
            // 这里都是资源文件，用线程下载

            //判断是否需要更新
            if (m_ojects.Count >= 1)
            {
                StartLoadReminderPanel();
            }
            else
            {
                OnResourceInited();
                yield return new WaitForSeconds(1.2f);
            }
        }
        //游戏加载提示界面
        private GameObject reminder;
        private Button cancel;
        private Button confirm;
        private Text contentText;
        private bool isDown = true;
        void StartLoadReminderPanel()
        {
            reminder = Instantiate(Resources.Load<GameObject>("View/LoadReminderPanel"));
            cancel = reminder.transform.Find("reninder/cancel").GetComponent<Button>();
            confirm = reminder.transform.Find("reninder/confirm").GetComponent<Button>();
            contentText = reminder.transform.Find("reninder/content").GetComponent<Text>();
            contentText.text = "The "+ "<color=#546BCB>100M</color>" + " resources need to be updated" ;
            cancel.onClick.AddListener(OnCancel);
            confirm.onClick.AddListener(OnConfirm);
        }
        void OnUpdateFailed(string file)
        {
            string message = "更新失败!>" + file;
            facade.SendMessageCommand(NotiConst.UPDATE_MESSAGE, message);
        }
        //点击取消
        void OnCancel()
        {
            print("退出游戏");
            Application.Quit();

        }
        //点击确定
        void OnConfirm()
        {
            confirm.enabled = false;
            if (isDown)
            {
                if (Application.internetReachability == NetworkReachability.NotReachable)
                {
                    //Debug.Log("没有联网！！！");
                }
                if (Application.internetReachability == NetworkReachability.ReachableViaLocalAreaNetwork)
                {
                    Destroy(reminder);
                    contentBg.localScale = Vector3.one;
                    //Debug.Log("使用Wi-Fi！！！");
                    StartCoroutine(StartDownLoad(m_ojects));
                }
                if (Application.internetReachability == NetworkReachability.ReachableViaCarrierDataNetwork)
                {
                    //Debug.Log("使用移动网络！！！");
                    contentText.text = "Detected that you are not connected to wifi.Do you want to continue downloading?";
                    confirm.enabled = true;
                }
            }
            else
            {
                Destroy(reminder);
                contentBg.localScale = Vector3.one;
                StartCoroutine(StartDownLoad(m_ojects));
            }
            isDown = false;
        }
        //开始下载
        IEnumerator StartDownLoad(List<m_boject> m_ojects)
        {
            float num = 0;
            for (int i = m_ojects.Count - 1; i >= 0; --i)
            {

                BeginDownload(m_ojects[i].fileUrl, m_ojects[i].localfile);
                //print("下载中" + ">>>" + m_ojects[i].localfile);

                while (!(IsDownOK(m_ojects[i].localfile)))
                {
                    yield return new WaitForEndOfFrame();
                }

                num = m_ojects.Count - i;
                content.text = m_ojects[i].localfile.Replace(Util.DataPath, "");
                slider.value = num / m_ojects.Count;
                progress.text = Mathf.Floor((num / m_ojects.Count) * 100) + "%";
            }
            yield return new WaitForEndOfFrame();


            facade.SendMessageCommand(NotiConst.UPDATE_MESSAGE, "更新完成!!");
            slider.value = 1;

            OnResourceInited();
            yield return new WaitForSeconds(1.2f);
        }
        /// <summary>
        /// 是否下载完成
        /// </summary>
        bool IsDownOK(string file)
        {
            return downloadFiles.Contains(file);
        }

        /// <summary>
        /// 线程下载
        /// </summary>
        void BeginDownload(string url, string file)
        {     //线程下载
            object[] param = new object[2] { url, file };

            ThreadEvent ev = new ThreadEvent();
            ev.Key = NotiConst.UPDATE_DOWNLOAD;
            ev.evParams.AddRange(param);
            ThreadManager.AddEvent(ev, OnThreadCompleted);   //线程下载
        }

        /// <summary>
        /// 线程完成
        /// </summary>
        /// <param name="data"></param>
        void OnThreadCompleted(NotiData data)
        {
            switch (data.evName)
            {
                case NotiConst.UPDATE_EXTRACT:  //解压一个完成
                                                //
                    break;
                case NotiConst.UPDATE_DOWNLOAD: //下载一个完成
                    downloadFiles.Add(data.evParam.ToString());
                    break;
            }
        }

        /// <summary>
        /// 资源初始化结束
        /// </summary>
        public void OnResourceInited()
        {
#if ASYNC_MODE
            ResManager.Initialize(AppConst.AssetDir, delegate () {
                Debug.Log("Initialize OK!!!");
                this.OnInitialize();
            });
#else
            ResManager.Initialize();
            this.OnInitialize();
#endif
        }

        void OnInitialize()
        {
            Debug.Log("GameManager:OnInitialize Invoked !!!");
            LuaManager.InitStart();
            //LuaManager.DoFile("Logic/Game");         //加载游戏
            LuaManager.DoFile("Game");         //加载游戏
            Util.CallMethod("Game", "OnInitOK");     //初始化完成

            CityMain km = GameObject.Find("ClientApp").GetComponent<CityMain>();
            if (km != null)
            {
                km.initCityEngine();
            }

            Debug.Log("GameManager:OnInitialize CallMethod Game OnPostInitOK !!!");
            Util.CallMethod("Game", "OnPostInitOK");     //初始化完成
            Destroy(GameObject.Find("LoadCanvas"));
            initialize = true;
        }

        /// <summary>
        /// 析构函数
        /// </summary>
        void OnDestroy()
        {
            if (LuaManager != null)
            {
                LuaFramework.Util.CallMethod("CityEngineLua", "Destroy");
                LuaManager.Close();
            }
            Debug.Log("~GameManager was destroyed");
        }
    }
}

class m_boject
{

    public string fileUrl;
    public string localfile;
    public m_boject(string f, string l)
    {
        fileUrl = f;
        localfile = l;

    }

}

