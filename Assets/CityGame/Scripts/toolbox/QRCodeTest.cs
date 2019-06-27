using UnityEngine;
using System.Collections;
using ZXing;
using UnityEngine.UI;
using System.Threading;
using System.IO;

namespace UnityEngine
{
    public class QRCodeTest : MonoBehaviour
    {
        public InputField qrStingText;
        public RawImage cameraTexture;
        //private Thread qrThread;
        private float time = 2f;
        private WebCamTexture webCamTexture;
        //二维码读取内容
        private BarcodeReader barcodeReader;
        //二维码写入内容
        private BarcodeWriter barcodeWriter;
        private string QRTexturePath ;
        //扫描二维码界面
        public RectTransform codePanel;
        private void Awake()
        {
            //QRTexturePath = Application.dataPath + "/CityGame/Resources/Atlas/Wallet";
            if (Application.platform == RuntimePlatform.Android)
            {
                QRTexturePath = UnityEngine.Application.persistentDataPath + "/CityGame";
            }
            else
            {
#if LUA_BUNDEL
            return "Assets/CityGame";
#else
                QRTexturePath = "Assets/CityGame";

#endif
            }

        }
        public void StartScanQRCode()
        {
            if (Application.HasUserAuthorization(UserAuthorization.WebCam))
            {
                DeviceInit();
            }
        }
        void DeviceInit()
        {
            WebCamDevice[] devices = WebCamTexture.devices;
            if (devices.Length == 0)
            {
                return;
            }
            string deviceName = devices[0].name;
            webCamTexture = new WebCamTexture(deviceName, Screen.currentResolution.height, Screen.currentResolution.width);
            cameraTexture.texture = webCamTexture;
            webCamTexture.Play();

            barcodeReader = new BarcodeReader();
            InvokeRepeating("ScanQRCode", 2.5f, time);
        }
        //扫描二维码
        public void ScanQRCode()
        {
            Color32[] data = webCamTexture.GetPixels32();
            var result = barcodeReader.Decode(data, webCamTexture.width, webCamTexture.height);
            if (result != null)
            {
                data = null;
                webCamTexture.Stop();
                CancelInvoke("ScanQRCode");
                cameraTexture.texture = null;
                qrStingText.text = result.Text;
                if (codePanel != null)
                {
                    codePanel.transform.localScale = Vector3.one;
                }
            }
        }
        //创建二维码
        public void CreateQRCode(string str /*,Image RQCodeImg*/)
        {
            //定义texture2d并填充
            Texture2D tTexture = new Texture2D(256, 256);
            tTexture.SetPixels32(GetnQRCode(str, 256, 256));
            tTexture.Apply();
            string fullpath = QRTexturePath + "/QRCode.png";
            var bytes = tTexture.EncodeToPNG();
            if (!Directory.Exists(QRTexturePath))
            {
                Directory.CreateDirectory(QRTexturePath);
            }
            File.WriteAllBytes(fullpath, bytes);
        }
        //返回Color32图片颜色的方法
        Color32[] GetnQRCode(string formatStr, int width, int height)
        {
            ZXing.QrCode.QrCodeEncodingOptions options = new ZXing.QrCode.QrCodeEncodingOptions();
            //options.CharacterSet = "UTF-8";
            options.Width = width;
            options.Height = height;
            options.Margin = 1;//二维码距离边缘的空白

            //重置写二维码变量类   （参数:码格式，编码格式）
            barcodeWriter = new BarcodeWriter { Format = ZXing.BarcodeFormat.QR_CODE, Options = options };
            return barcodeWriter.Write(formatStr);
        }
        //线程解码不会卡顿
        //private void Start()
        //{
        //    barcodeReader = new BarcodeReader();
        //    WebCamDevice[] devices = WebCamTexture.devices;
        //    string deviceName = devices[0].name;
        //    webCamTexture = new WebCamTexture(deviceName, Screen.currentResolution.height, Screen.currentResolution.width);
        //    cameraTexture.texture = webCamTexture;
        //    webCamTexture.Play();

        //    qrThread = new Thread(DecodeQrCode);
        //    qrThread.Start();
        //}

        //private void Update()
        //{
        //    time += Time.deltaTime;
        //    if (time > 3f)
        //    {
        //        if (data == null)
        //        {
        //            data = webCamTexture.GetPixels32();
        //        }
        //    }
        //}
        ////解码
        //private void DecodeQrCode()
        //{
        //    while (true)
        //    {
        //        try
        //        {
        //            //当前帧解码
        //            var result = barcodeReader.Decode(data, webCamTexture.width, webCamTexture.height);
        //            if (result != null)
        //            {
        //                qrStingText.text = result.Text;
        //                cameraTexture.texture = null;
        //                webCamTexture.Stop();
        //                data = null;
        //                //关闭线程
        //                qrThread.Abort();
        //            }
        //        }
        //        catch
        //        {

        //        }
        //    }
        //}
    }
}