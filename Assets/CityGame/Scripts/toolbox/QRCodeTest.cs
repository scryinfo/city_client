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
        private float time = 2.5f;
        private WebCamTexture webCamTexture;
        //QR code reading content
        private BarcodeReader barcodeReader;
        //QR code content
        private BarcodeWriter barcodeWriter;
        private string QRTexturePath ;
        //Scan QR code interface
        public RectTransform codePanel;
        public void StartScanQRCode()
        {
            StartCoroutine(OpenPermissions());
        }
        IEnumerator OpenPermissions()
        {
            yield return Application.RequestUserAuthorization(UserAuthorization.WebCam );
            if (!Application.HasUserAuthorization(UserAuthorization.WebCam ))
            {
                yield break;            
            }
            DeviceInit();

        }
        void DeviceInit()
        {
            WebCamDevice[] devices = WebCamTexture.devices;
            Debug.Log("devices     " + devices.Length);
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
        //Scan QR code
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
                    codePanel.transform.localScale = Vector3.zero;
                }
            }
        }
        //Scan QR code
        public void CreateQRCode(string str, RawImage RQCodeImg)
        {
            //Define texture2d and fill
            Texture2D tTexture = new Texture2D(256, 256);
            tTexture.SetPixels32(GetnQRCode(str, 256, 256));
            tTexture.Apply();
            RQCodeImg.texture = tTexture;
        }
        //Method to return Color32 image color
        Color32[] GetnQRCode(string formatStr, int width, int height)
        {
            ZXing.QrCode.QrCodeEncodingOptions options = new ZXing.QrCode.QrCodeEncodingOptions();
            //options.CharacterSet = "UTF-8";
            options.Width = width;
            options.Height = height;
            options.Margin = 1;//The margin of the QR code from the edge

            //Reset to write the QR code variable class (parameter: code format, encoding format)
            barcodeWriter = new BarcodeWriter { Format = ZXing.BarcodeFormat.QR_CODE, Options = options };
            return barcodeWriter.Write(formatStr);
        }
        //Thread decoding will not freeze
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
        ////decoding
        //private void DecodeQrCode()
        //{
        //    while (true)
        //    {
        //        try
        //        {
        //            //Current frame decoding
        //            var result = barcodeReader.Decode(data, webCamTexture.width, webCamTexture.height);
        //            if (result != null)
        //            {
        //                qrStingText.text = result.Text;
        //                cameraTexture.texture = null;
        //                webCamTexture.Stop();
        //                data = null;
        //                //Close thread
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