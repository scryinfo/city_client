using UnityEngine;
using System.Collections.Generic;
using System.Reflection;
using LuaInterface;
using System.Runtime.InteropServices;
using System;
using System.IO;
using System.Text;
using City;
using ctSignatures;
using System.Numerics;
using System.Text;
using System.Globalization;
using Org.BouncyCastle.Asn1.Sec;
using Org.BouncyCastle.Crypto;
using Org.BouncyCastle.Crypto.Parameters;
using Org.BouncyCastle.Security;

using LuaFramework;
using Org.BouncyCastle.Crypto.Digests;
using Org.BouncyCastle.Utilities.Encoders;
using System.Security.Cryptography;
using Nethereum.Signer;
using Nethereum.Util;

namespace City
{
    /*
     * Original Source: https://bitcoin.stackexchange.com/a/25039
     */
    class Point
    {
        public static readonly Point INFINITY = new Point(null, default(BigInteger), default(BigInteger));
        public CurveFp Curve { get; private set; }
        public BigInteger X { get; private set; }
        public BigInteger Y { get; private set; }

        public Point(CurveFp curve, BigInteger x, BigInteger y)
        {
            this.Curve = curve;
            this.X = x;
            this.Y = y;
        }
        public Point Double()
        {
            if (this == INFINITY)
                return INFINITY;

            BigInteger p = this.Curve.p;
            BigInteger a = this.Curve.a;
            BigInteger l = ((3 * this.X * this.X + a) * InverseMod(2 * this.Y, p)) % p;
            BigInteger x3 = (l * l - 2 * this.X) % p;
            BigInteger y3 = (l * (this.X - x3) - this.Y) % p;
            return new Point(this.Curve, x3, y3);
        }
        public override string ToString()
        {
            if (this == INFINITY)
                return "infinity";
            return string.Format("({0},{1})", this.X, this.Y);
        }
        public static Point operator +(Point left, Point right)
        {
            if (right == INFINITY)
                return left;
            if (left == INFINITY)
                return right;
            if (left.X == right.X)
            {
                if ((left.Y + right.Y) % left.Curve.p == 0)
                    return INFINITY;
                else
                    return left.Double();
            }

            var p = left.Curve.p;
            var l = ((right.Y - left.Y) * InverseMod(right.X - left.X, p)) % p;
            var x3 = (l * l - left.X - right.X) % p;
            var y3 = (l * (left.X - x3) - left.Y) % p;
            return new Point(left.Curve, x3, y3);
        }
        public static Point operator *(Point left, BigInteger right)
        {
            var e = right;
            if (e == 0 || left == INFINITY)
                return INFINITY;
            var e3 = 3 * e;
            var negativeLeft = new Point(left.Curve, left.X, -left.Y);
            var i = LeftmostBit(e3) / 2;
            var result = left;
            while (i > 1)
            {
                result = result.Double();
                if ((e3 & i) != 0 && (e & i) == 0)
                    result += left;
                if ((e3 & i) == 0 && (e & i) != 0)
                    result += negativeLeft;
                i /= 2;
            }
            return result;
        }

        private static BigInteger LeftmostBit(BigInteger x)
        {
            BigInteger result = 1;
            while (result <= x)
                result = 2 * result;
            return result / 2;
        }
        private static BigInteger InverseMod(BigInteger a, BigInteger m)
        {
            while (a < 0) a += m;
            if (a < 0 || m <= a)
                a = a % m;
            BigInteger c = a;
            BigInteger d = m;

            BigInteger uc = 1;
            BigInteger vc = 0;
            BigInteger ud = 0;
            BigInteger vd = 1;

            while (c != 0)
            {
                BigInteger r;
                //q, c, d = divmod( d, c ) + ( c, );
                var q = BigInteger.DivRem(d, c, out r);
                d = c;
                c = r;

                //uc, vc, ud, vd = ud - q*uc, vd - q*vc, uc, vc;
                var uct = uc;
                var vct = vc;
                var udt = ud;
                var vdt = vd;
                uc = udt - q * uct;
                vc = vdt - q * vct;
                ud = uct;
                vd = vct;
            }
            if (ud > 0) return ud;
            else return ud + m;
        }
    }

    class CurveFp
    {
        public BigInteger p { get; private set; }
        public BigInteger a { get; private set; }
        public BigInteger b { get; private set; }
        public CurveFp(BigInteger p, BigInteger a, BigInteger b)
        {
            this.p = p;
            this.a = a;
            this.b = b;
        }
    }

    public static class CityTest
    {
        public static void Test()
        {
            Debug.Log("测试静态方法");
            List<Byte[]> test = new List<byte[]>();
            //字符串
            //var publicKeyBytes = Hex.Decode(publicKey);
            test.Add(Hex.Decode("he哈哈"));
            //long
            test.Add(Hex.Decode(BitConverter.GetBytes(LuaFramework.Util.GetTime())));
        }

        public static void Test1()
        {
            Debug.Log("测试静态方法1");
        }

        public static void Test2()
        {
            Debug.Log("测试静态方法2");
        }
    }
    public static class CityLuaUtil
    {
        //调用检测钱包是否可用
        public static void CallDetectWall()
        {
            AndroidJavaClass jc = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
            AndroidJavaObject jo = jc.GetStatic<AndroidJavaObject>("currentActivity");
            jo.Call("CheckCashboxCanBeUse");
        }
        public static bool checkLocalCashboxExist() {            
            Dbg.WARNING_MSG(string.Format("c# 调用 checkLocalCashboxExist"));
            if (Application.platform == RuntimePlatform.Android) {
                Dbg.WARNING_MSG(string.Format("c# 调用 checkLocalCashboxExist Application.platform == RuntimePlatform.Android"));
                using (AndroidJavaClass unity_player = new AndroidJavaClass("com.unity3d.player.UnityPlayer")) {
                    AndroidJavaObject intentObject = new AndroidJavaObject("android.content.Intent");
                    intentObject.Call<AndroidJavaObject>("SetClassName", "info.scry.wallet", "info.scry.wallet.utils.AppStateActivityUtil");
                    intentObject.Call<AndroidJavaObject>("putExtra", "version", "1.0");
                    AndroidJavaObject current_activity = unity_player.GetStatic<AndroidJavaObject>("currentActivity");
                    current_activity.Call<Boolean>("startActivityForResult", intentObject, 1);
                    Dbg.WARNING_MSG(string.Format("c# 调用 checkLocalCashboxExist StartActivtyForResult"));
                    /*if (exist == true)
                        Dbg.WARNING_MSG(string.Format("c# 调用 checkLocalCashboxExist StartActivtyForResult return: true"));
                    else
                        Dbg.WARNING_MSG(string.Format("c# 调用 checkLocalCashboxExist StartActivtyForResult return: false"));                    
                    return exist;*/
                    return true;
                }
            }
            return false;
        }

        public static void openCashbox(string amount, string toAddr, string purchaseId)
        {
            if (Application.platform == RuntimePlatform.Android)
            {
                using (AndroidJavaClass unity_player = new AndroidJavaClass("com.unity3d.player.UnityPlayer"))
                {                    
                    Dbg.WARNING_MSG(string.Format("c# 调用 openCashbox"));
                    AndroidJavaObject intentObject = new AndroidJavaObject("android.content.Intent");
                    Dbg.WARNING_MSG(string.Format("c# 调用 SetClassName -----------------------------------"));
                    try
                    {
                        intentObject = intentObject.Call<AndroidJavaObject>("setClassName", "info.scry.wallet", "info.scry.wallet.SendEthActivity");
                        Dbg.WARNING_MSG(string.Format("c# 调用 putExtra isFromOtherApp -----------------------------------"));
                        intentObject.Call<AndroidJavaObject>("putExtra", "isFromOtherApp", true);
                        intentObject.Call<AndroidJavaObject>("putExtra", "value", amount);
                        intentObject.Call<AndroidJavaObject>("putExtra", "toAddress", toAddr);
                        intentObject.Call<AndroidJavaObject>("putExtra", "backup", purchaseId);

                        AndroidJavaObject current_activity = unity_player.GetStatic<AndroidJavaObject>("currentActivity");
                        Dbg.WARNING_MSG(string.Format("c# 调用 startActivity -----------------------------------"));
                        current_activity.Call("startActivity", intentObject);
                        Dbg.WARNING_MSG(string.Format("c# 调用 openCashbox startActivity"));
                    }
                    catch (System.Exception e) {
                        Dbg.WARNING_MSG("Error openCashbox:" + e.Message + " -- " + e.StackTrace );
                    }
                    
                }
            }
        }

        public static string NewGuid()
        {
            return System.Guid.NewGuid().ToString().Replace("-","");
        }        

        public static string scientificNotation2Normal(double number) {
            return number.ToString("f99").TrimEnd('0');
        }
        private static byte[] stringToKeccak256(string inStr)
        {            
            var privateKeyBytes = Encoding.UTF8.GetBytes(inStr);
            SHA256 mySHA256 = SHA256.Create();
            byte[] output = mySHA256.ComputeHash(privateKeyBytes);
            return output;
        }

        public static bool VerifySignature(string message, string publicKey, string signature)
        {
            var curve = SecNamedCurves.GetByName("secp256k1");
            var domain = new ECDomainParameters(curve.Curve, curve.G, curve.N, curve.H);

            var publicKeyBytes = Hex.Decode(publicKey);

            var q = curve.Curve.DecodePoint(publicKeyBytes);

            var keyParameters = new
                    Org.BouncyCastle.Crypto.Parameters.ECPublicKeyParameters(q,
                    domain);

            ISigner signer = SignerUtilities.GetSigner("SHA-256withECDSA");

            signer.Init(false, keyParameters);
            signer.BlockUpdate(Encoding.ASCII.GetBytes(message), 0, message.Length);

            //var signatureBytes = stringToKeccak256(signature);
            var signatureBytes = Hex.Decode(signature);

            return signer.VerifySignature(signatureBytes);
        }

        public static bool Verify(byte[] message, byte[] publicKey, byte[] signature)
        {
            var curve = SecNamedCurves.GetByName("secp256k1");
            var domain = new ECDomainParameters(curve.Curve, curve.G, curve.N, curve.H);

            var q = curve.Curve.DecodePoint(publicKey);

            var keyParameters = new
                    Org.BouncyCastle.Crypto.Parameters.ECPublicKeyParameters(q,
                    domain);

            ISigner signer = SignerUtilities.GetSigner("SHA-256withECDSA");

            signer.Init(false, keyParameters);
            signer.BlockUpdate(message, 0, message.Length);

            //var signatureBytes = stringToKeccak256(signature);
            var signatureBytes = Hex.Decode(signature);

            return signer.VerifySignature(signatureBytes);
        }

        public static string GetSignature(string privateKey, string message)
        {
            var curve = SecNamedCurves.GetByName("secp256k1");
            var domain = new ECDomainParameters(curve.Curve, curve.G, curve.N, curve.H);

            var keyParameters = new
                    ECPrivateKeyParameters(new Org.BouncyCastle.Math.BigInteger(stringToKeccak256(privateKey)),
                    domain);

            ISigner signer = SignerUtilities.GetSigner("SHA-256withECDSA");

            signer.Init(true, keyParameters);
            signer.BlockUpdate(Encoding.ASCII.GetBytes(message), 0, message.Length);
            var signature = signer.GenerateSignature();
            return BitConverter.ToString(signature).Replace("-", string.Empty);
        }

        public static byte[] Sign(string privateKey, byte[] message)
        {
            var curve = SecNamedCurves.GetByName("secp256k1");
            var domain = new ECDomainParameters(curve.Curve, curve.G, curve.N, curve.H);

            var keyParameters = new
                    ECPrivateKeyParameters(new Org.BouncyCastle.Math.BigInteger(stringToKeccak256(privateKey)),
                    domain);

            ISigner signer = SignerUtilities.GetSigner("SHA-256withECDSA");

            signer.Init(true, keyParameters);
            signer.BlockUpdate(message, 0, message.Length);
            var signature = signer.GenerateSignature();
            return signature;
        }

        public static EthECDSASignature sigFrom64ByteArray(byte[] array64)
        {
            byte[] first32 = ByteUtil.Slice(array64, 0, 32);
            byte[] last32 = ByteUtil.Slice(array64, 32, 64);
            EthECDSASignature retsig = new EthECDSASignature(new Org.BouncyCastle.Math.BigInteger(1,first32)
                , new Org.BouncyCastle.Math.BigInteger(1,last32), null);
            return retsig;
        }

        public static byte[] Sign_Eth(string privateKey, byte[] message)
        {
            EthECKey ek = new EthECKey(stringToKeccak256(privateKey), true );
            EthECDSASignature signature = ek.Sign(message);
            return signature.To64ByteArray();            
        }

        public static bool Verify_Eth(byte[] pk , byte[] sig64, byte[] message)
        {
            var sig = sigFrom64ByteArray(sig64);
            EthECKey vk = new EthECKey(pk, false);
            EthECDSASignature vsig = CityLuaUtil.sigFrom64ByteArray(sig64);
            bool passv = vk.Verify(message, vsig);
            return vk.Verify(message, vsig);
        }

        public static string GetPublicKeyFromPrivateKeyEx(string privateKeyStr)
        {
            var curve = SecNamedCurves.GetByName("secp256k1");
            var domain = new ECDomainParameters(curve.Curve, curve.G, curve.N, curve.H);
            var d = new Org.BouncyCastle.Math.BigInteger(stringToKeccak256(privateKeyStr));            
            var q = domain.G.Multiply(d);
            var publicKey = new ECPublicKeyParameters(q, domain);            
            string s2 = BitConverter.ToString(publicKey.Q.GetEncoded()).Replace("-", string.Empty);
            return BitConverter.ToString(publicKey.Q.GetEncoded()).Replace("-", string.Empty); 
        }


        private static string GetPublicKeyFromPrivateKey(string privateKey)
        {
            var p = BigInteger.Parse("0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F", NumberStyles.HexNumber);
            var b = (BigInteger)7;
            var a = BigInteger.Zero;
            var Gx = BigInteger.Parse("79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798", NumberStyles.HexNumber);
            var Gy = BigInteger.Parse("483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8", NumberStyles.HexNumber);

            CurveFp curve256 = new CurveFp(p, a, b);
            Point generator256 = new Point(curve256, Gx, Gy);

            var secret = BigInteger.Parse(privateKey, NumberStyles.HexNumber);
            var pubkeyPoint = generator256 * secret;
            return pubkeyPoint.X.ToString("X") + pubkeyPoint.Y.ToString("X");
        }


        public static System.Type getSpriteType()
        {
            return typeof(UnityEngine.Sprite) ;
        }
        public static UIRoot GetUIRoot()
        {
            return UIRoot.Instance;
        }

        public static Transform getFixedRoot()
        {
            return UIRoot.getFixedRoot();
        }

        public static Transform getBubbleRoot()
        {
            return UIRoot.getBubbleRoot();
        }

        public static bool isWindowsEditor()
        {
            return Application.platform == RuntimePlatform.WindowsEditor;
        }

        public static bool isluaLogEnable()
        {
#if LUA_LOG
            return true;
#else
            return false;
#endif
        }

        public static string getAssetsPath()
        {
            if (Application.platform == RuntimePlatform.Android)
            {
                return UnityEngine.Application.persistentDataPath + "/CityGame";
            }
            else
            {
#if LUA_BUNDEL             
            return "Assets/CityGame";
#else
            return "Assets/CityGame";
                
#endif
            }
        }

        public static string getLuaBundelPath()
        {
            if (Application.platform == RuntimePlatform.Android)
            {
                return UnityEngine.Application.persistentDataPath + "/CityGame";
            }
            else
            {
                return Application.streamingAssetsPath;
            }
        }

        public static string getDataPath()
        {
            return UnityEngine.Application.dataPath;
        }

        public static object getUiCamera()
        {
            return UIRoot.getUiCamera();
        }

        public static Transform getNormalRoot()
        {
            return UIRoot.getNormalRoot();
        }

        public static Transform getPopupRoot()
        {
            return UIRoot.getPopupRoot();
        }

        // go 是脚本要挂到的目标对象，一般是一个prefab实例； luaPath 是要挂到目标对象上的lua脚本的路径
        public static Component AddLuaComponent(GameObject go, string luaPath)
        {
            LuaComponent com = go.AddComponent<LuaComponent>() as LuaComponent;
            com.reAwake(luaPath);
            return com;
        }


        public delegate object[] CallLuaFunction(string funcName, params object[] args);
        private static CallLuaFunction callFunction = null;
        public static byte[] Utf8ToByte(object utf8)
        {
            return System.Text.Encoding.UTF8.GetBytes((string)utf8);
        }

        public static string ByteToUtf8(byte[] bytes)
        {
            return System.Text.Encoding.UTF8.GetString(bytes);
        }

        public static void ArrayCopy(byte[] srcdatas, long srcLen, byte[] dstdatas, long dstLen, long len)
        {
            Array.Copy(srcdatas, srcLen, dstdatas, dstLen, len);
        }

        public static void Log(string str)
        {
            Debug.Log(str);
        }

        public static void LogWarning(string str)
        {
            Debug.LogWarning(str);
        }

        public static void LogError(string str)
        {
            Debug.LogError(str);
        }

        public static void SetCallLuaFunction(CallLuaFunction clf)
        {
            callFunction = clf;
        }

        public static void ClearCallLuaFunction()
        {
            callFunction = null;
        }
        /// <summary>
        /// 执行Lua方法..
        /// </summary>
        public static object[] CallMethod(string module, string func, params object[] args)
        {
            if(callFunction != null)
            {
                return callFunction(module + "." + func, args);
            }
            return null;
        }

        public static object[] CallMethod(string func, params object[] args)
        {
            if (callFunction != null)
            {
                return callFunction(func, args);
            }
            return null;
        }

        public static void createFile(string path, string name, byte[] datas)
        {
            deleteFile(path, name);
            Dbg.DEBUG_MSG("createFile: " + path + "/" + name);
            FileStream fs = new FileStream(path + "/" + name, FileMode.OpenOrCreate, FileAccess.Write);
            fs.Write(datas, 0, datas.Length);
            fs.Close();
            fs.Dispose();
        }

        public static byte[] loadFile(string path, string name, bool printerr)
        {
            FileStream fs;

            try
            {
                fs = new FileStream(path + "/" + name, FileMode.Open, FileAccess.Read);
            }
            catch (Exception e)
            {
                if (printerr)
                {
                    Dbg.ERROR_MSG("loadFile: " + path + "/" + name);
                    Dbg.ERROR_MSG(e.ToString());
                }

                return new byte[0];
            }

            byte[] datas = new byte[fs.Length];
            fs.Read(datas, 0, datas.Length);
            fs.Close();
            fs.Dispose();

            Dbg.DEBUG_MSG("loadFile: " + path + "/" + name + ", datasize=" + datas.Length);
            return datas;
        }

        public static void deleteFile(string path, string name)
        {
            //Dbg.DEBUG_MSG("deleteFile: " + path + "/" + name);

            try
            {
                File.Delete(path + "/" + name);
            }
            catch (Exception e)
            {
                Debug.LogError(e.ToString());
            }
        }
        public static byte[] StringToByteArray(string hexString)
        {
            hexString = hexString.Replace(" ", "");
            if ((hexString.Length % 2) != 0)
                hexString += " ";
            byte[] returnBytes = new byte[hexString.Length / 2];
            for (int i = 0; i < returnBytes.Length; i++)
                returnBytes[i] = Convert.ToByte(hexString.Substring(i * 2, 2), 16);
            return returnBytes;
        }

        public static string ByteArrayToString(byte[] ba)
        {
            StringBuilder hex = new StringBuilder(ba.Length * 2);
            foreach (byte b in ba)
                hex.AppendFormat("{0:x2}", b);
            return hex.ToString();
        }

        public static String convert(byte b)
        {
            StringBuilder str = new StringBuilder(8);
            int[] bl = new int[8];

            for (int i = 0; i < bl.Length; i++)
            {
                bl[bl.Length - 1 - i] = ((b & (1 << i)) != 0) ? 1 : 0;
            }

            foreach (int num in bl) str.Append(num);

            return str.ToString();
        }

        public static string bytesToString(byte[] bytes)
        {

            /* return  ByteArrayToString(bytes);*/
            StringBuilder destString = new StringBuilder(bytes.Length);
            for (int i = 0; i < bytes.Length; i++)
            {
                destString.Append(bytes[i]);
            }
            return destString.ToString();

            //System.Text.ASCIIEncoding encoding = new System.Text.ASCIIEncoding();
            //return encoding.GetString(bytes, 0, bytes.Length);     

        }

        public static byte[] stringToBytes(string str)
        {
            System.Text.ASCIIEncoding encoding = new System.Text.ASCIIEncoding();
            return encoding.GetBytes(str);
        }
    }
}