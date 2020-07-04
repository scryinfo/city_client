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
        private GameObject startPanel;  //Loading interface
        private CanvasGroup startGroup; //Loading interface BG development
        private GameObject Loadcanvas;
        /// <summary>
        /// Initialize the game manager
        /// </summary>
        void Awake()
        {
            Loadcanvas = GameObject.Find("LoadCanvas");
            Loadcanvas.SetActive(true);
            if (AppConst.UpdateMode)
            {
                StartLoadPanel();
            }
            else
            {
                Init();
            }
        }
        //Game loading interface
        void StartLoadPanel()
        {
            startPanel = Instantiate(Resources.Load<GameObject>("View/GameStartPanel"));
            startGroup = startPanel.transform.Find("bg").GetComponent<CanvasGroup>();
            StartCoroutine(GroupFade());
        }
        //Loading interface fades in and out
        IEnumerator GroupFade()
        {
            startGroup.DOFade(1, 5);
            yield return new WaitForSeconds(5);
            Destroy(startPanel);
            LoadHotFixPanel();
            Init();
        }
       
        /// <summary>
        /// Initialize the game manager
        /// </summary>
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
            slider = panel.transform.Find("HotfixPanel/contentBg/Slider").GetComponent<Slider>();
        }

        /// <summary>
        /// initialization
        /// </summary>
        void Init()
        {
            DontDestroyOnLoad(gameObject);  //Prevent destroying yourself

            CheckExtractResource(); //Free up resources
            Screen.sleepTimeout = SleepTimeout.NeverSleep;
            QualitySettings.vSyncCount = 0;//Turn off vertical sync
            Application.targetFrameRate = AppConst.GameFrameRate;
        }

        /// <summary>
        /// Free up resources
        /// </summary>
        public void CheckExtractResource()
        {
            bool isExists = Directory.Exists(Util.DataPath) &&
              Directory.Exists(Util.DataPath + "lua/") && File.Exists(Util.DataPath + "files.txt");
            if (isExists || AppConst.DebugMode)
            {
                StartCoroutine(OnUpdateResource());
                return;   //The file has been decompressed, you can add the check file list logic
            }
            StartCoroutine(OnExtractResource());    //Start release co-production 
        }

        IEnumerator OnExtractResource()
        {
            string dataPath = Util.DataPath;  //Data directory
            string resPath = Util.AppContentPath(); //Game package resource directory

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

            //Free all files to the data directory
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
            //After the release is complete, start to update resources
            StartCoroutine(OnUpdateResource());
        }
        List<m_boject> m_ojects = new List<m_boject>();
        /// <summary>
        /// Start the update download, here is just a demo of the idea, here you can start the thread to download the update
        /// </summary>
        IEnumerator OnUpdateResource()
        {
            if (!AppConst.UpdateMode)
            {
                OnResourceInited();
                yield break;
            }
            string dataPath = Util.DataPath;  //Data directory
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
                {   //Local missing files
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
                    //Here are resource files
                    m_ojects.Add(new m_boject(fileUrl, localfile));
                    // BeginDownload(fileUrl, localfile);

                    // while (!(IsDownOK(m_ojects[i].localfile))) { yield return new WaitForEndOfFrame(); }
                }
            }
            yield return new WaitForEndOfFrame();
            // Here are resource files, download with threads

            //Determine if it needs to be updated
            if (m_ojects.Count >= 1)
            {
                //StartLoadReminderPanel();
                contentBg.localScale = Vector3.one;
                StartCoroutine(StartDownLoad(m_ojects));
            }
            else
            {
                OnResourceInited();
                yield return new WaitForSeconds(1.2f);
                Destroy(panel);
                Loadcanvas.SetActive(true);
            }
        }
        //Game loading prompt interface
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
            contentText.text = "The "+ "<color=#546BCB>414M</color>" + " resources need to be updated" ;
            cancel.onClick.AddListener(OnCancel);
            confirm.onClick.AddListener(OnConfirm);
        }
        void OnUpdateFailed(string file)
        {
            string message = "更新失败!>" + file;
            facade.SendMessageCommand(NotiConst.UPDATE_MESSAGE, message);
        }
        //Click to cancel
        void OnCancel()
        {
            print("退出游戏");
            Application.Quit();

        }
        //Click ok
        void OnConfirm()
        {
            confirm.enabled = false;
            if (isDown)
            {
                if (Application.internetReachability == NetworkReachability.NotReachable)
                {
                    //Debug.Log("No internet connection! ! !");
                }
                if (Application.internetReachability == NetworkReachability.ReachableViaLocalAreaNetwork)
                {
                    Destroy(reminder);
                    contentBg.localScale = Vector3.one;
                    //Debug.Log("Use Wi-Fi! !！");
                    StartCoroutine(StartDownLoad(m_ojects));
                }
                if (Application.internetReachability == NetworkReachability.ReachableViaCarrierDataNetwork)
                {
                    //Debug.Log("Use the mobile network! ! !");
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
        //start download
        IEnumerator StartDownLoad(List<m_boject> m_ojects)
        {
            float num = 0;
            for (int i = m_ojects.Count - 1; i >= 0; --i)
            {

                BeginDownload(m_ojects[i].fileUrl, m_ojects[i].localfile);
                //print("downloading" + ">>>" + m_ojects[i].localfile);

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
            Destroy(panel);
            Loadcanvas.SetActive(true);
        }
        /// <summary>
        /// Whether the download is complete
        /// </summary>
        bool IsDownOK(string file)
        {
            return downloadFiles.Contains(file);
        }

        /// <summary>
        /// Thread download
        /// </summary>
        void BeginDownload(string url, string file)
        {     //Thread download
            object[] param = new object[2] { url, file };

            ThreadEvent ev = new ThreadEvent();
            ev.Key = NotiConst.UPDATE_DOWNLOAD;
            ev.evParams.AddRange(param);
            ThreadManager.AddEvent(ev, OnThreadCompleted);   //Thread download
        }

        /// <summary>
        /// Thread completion
        /// </summary>
        /// <param name="data"></param>
        void OnThreadCompleted(NotiData data)
        {
            switch (data.evName)
            {
                case NotiConst.UPDATE_EXTRACT:  //Unzip a complete
                                                //
                    break;
                case NotiConst.UPDATE_DOWNLOAD: //Download one complete
                    downloadFiles.Add(data.evParam.ToString());
                    break;
            }
        }

        /// <summary>
        /// End of resource initialization
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
            //LuaManager.DoFile("Logic/Game");         //Load game
            LuaManager.DoFile("Game");         //Load game
            Util.CallMethod("Game", "OnInitOK");     //Load game

            CityMain km = GameObject.Find("ClientApp").GetComponent<CityMain>();
            if (km != null)
            {
                km.initCityEngine();
            }

            Debug.Log("GameManager:OnInitialize CallMethod Game OnPostInitOK !!!");
            Util.CallMethod("Game", "OnPostInitOK");     //Load game
            //Destroy(GameObject.Find("LoadCanvas"));
            initialize = true;
        }

        /// <summary>
        /// Destructor
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

