using System;
using Org.BouncyCastle.Asn1.Sec;
using Org.BouncyCastle.Crypto;
using Org.BouncyCastle.Crypto.Parameters;
using Org.BouncyCastle.Security;
using Org.BouncyCastle.Crypto.Digests;
using Org.BouncyCastle.Utilities.Encoders;
using System.Security.Cryptography;
using System.Collections.Generic;
using System.Text;
using System;
using Nethereum.Signer;
using Org.BouncyCastle.Asn1.Pkcs;
using Org.BouncyCastle.Asn1.X509;
using Org.BouncyCastle.Crypto.Generators;
using Org.BouncyCastle.Math;
using Org.BouncyCastle.Pkcs;
using Org.BouncyCastle.Crypto.Engines;
using Org.BouncyCastle.X509;
using Org.BouncyCastle.Asn1;
using Org.BouncyCastle.Crypto.Encodings;
using System.IO;
using System.Text.RegularExpressions;
namespace City {
    public class signer_ct
    {
        private List<byte[]> _datas;
        private int _dataLen = 0;
        private byte[] _dataHash;
        public signer_ct()
        {
            _datas = new List<byte[]>();
            _dataHash = null;

        }

        public void reset()
        {
            _datas.Clear();
            _dataLen = 0;
            _dataHash = null;
        }

        static string CleanInput(string strIn)
        {
            // Replace invalid characters with empty strings.
            try
            {
                return Regex.Replace(strIn, @"[^\w\.@-]", "",
                                     RegexOptions.None, TimeSpan.FromSeconds(1.5));
            }
            // If we timeout when replacing invalid characters, 
            // we should return Empty.
            catch (RegexMatchTimeoutException)
            {
                return String.Empty;
            }
        }
        public static string RemoveSpecialCharacters(string str)
        {
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < str.Length; i++)
            {
                if ((str[i] >= '0' && str[i] <= '9')
                    || (str[i] >= 'A' && str[i] <= 'z'))
                {
                    sb.Append(str[i]);
                }
            }

            return sb.ToString();
        }

        public static string getHexStringHash(string str)
        {
            return LuaFramework.Util.md5(str);
            //str = formatAmount(str);
            //string validstr = RemoveSpecialCharacters(str);
            //byte[] buffer = getDataHashIntenal(Encoding.UTF8.GetBytes(validstr));
            //string tt = buffer.ToString();
            //tt = CityLuaUtil.bytesToString(buffer);
            //return CityLuaUtil.bytesToString(buffer);
        }

        public static String formatAmount(String count)
        {
            if (count.Length % 2 == 1) count = "0" + count;
            return count;
        }

        public void pushHexSting(String str)
        {
            str = str.Replace("-","");
            str = formatAmount(str);
            byte[] bts = Hex.Decode(str);
            _datas.Add(bts);
            _dataLen += bts.Length;
        }
        public void pushSting(String str)
        {
            byte[] bts = Encoding.UTF8.GetBytes(str);                
            _datas.Add(bts);
            _dataLen += bts.Length;
        }

        public void pushSha256Hex(String str)
        {
            var strBytes = Encoding.UTF8.GetBytes(str);
            SHA256 mySHA256 = SHA256.Create();
            byte[] bts = mySHA256.ComputeHash(strBytes);
            _datas.Add(bts);
            _dataLen += bts.Length;
        }
        public void pushBtyes(byte[] data)
        {
            _datas.Add(data);
            _dataLen += data.Length;
        }

        public void pushLong(long ld)
        {
            byte[] bts = BitConverter.GetBytes(ld);  //This is inconsistent with the ccapi server, it is the size end does not match, just the opposite    
            Array.Reverse(bts);
            _datas.Add(bts);
            _dataLen += bts.Length;
        }
        private static byte[] stringToSHA256(string inStr)
        {
            var privateKeyBytes = Encoding.UTF8.GetBytes(inStr);
            SHA256 mySHA256 = SHA256.Create();
            byte[] output = mySHA256.ComputeHash(privateKeyBytes);
            return output;
        }

        public static byte[] GetPublicKeyFromPrivateKeyOld(string privateKeyStr)
        {
            var curve = SecNamedCurves.GetByName("secp256k1");
            var domain = new ECDomainParameters(curve.Curve, curve.G, curve.N, curve.H);
            var d = new Org.BouncyCastle.Math.BigInteger(stringToSHA256(privateKeyStr));
            var q = domain.G.Multiply(d);
            var publicKey = new ECPublicKeyParameters(q, domain);
            string s2 = BitConverter.ToString(publicKey.Q.GetEncoded()).Replace("-", string.Empty);
            //return BitConverter.ToString(publicKey.Q.GetEncoded()).Replace("-", string.Empty);
            return publicKey.Q.GetEncoded();
        }

        private static byte[] getDataHashIntenal(byte[] hashOfdData)
        {
            SHA256 mySHA256 = SHA256.Create();
            byte[] output = mySHA256.ComputeHash(hashOfdData);
            return output;
        }

        public byte[] getDataHash()
        {
            if (_dataHash != null)
            {
                return _dataHash;
            }
            else
            {
                byte[] hashOfdData = new byte[this._dataLen];
                int pos = 0;
                foreach (byte[] bts in _datas)
                {
                    Array.Copy(bts, 0, hashOfdData, pos, bts.Length);
                    pos += bts.Length;
                }
                return getDataHashIntenal(hashOfdData);                
            }
        }
        

        
        public bool verifyByPbyKey(ref byte[] publicKey, byte[] signature)
        {
            //Calculate the hash based on the data
            byte[] datahash = getDataHash();

            var curve = SecNamedCurves.GetByName("secp256k1");
            var domain = new ECDomainParameters(curve.Curve, curve.G, curve.N, curve.H);

            var q = curve.Curve.DecodePoint(publicKey);

            var keyParameters = new
                    Org.BouncyCastle.Crypto.Parameters.ECPublicKeyParameters(q,
                    domain);

            ISigner signer = SignerUtilities.GetSigner("SHA-256withECDSA");

            signer.Init(false, keyParameters);
            signer.BlockUpdate(datahash, 0, datahash.Length);

            return signer.VerifySignature(signature);
        }
        public static string ByteArrayToString(byte[] bts)
        {
            return Encoding.ASCII.GetString(bts);            
        }
        public static byte[] StringToByteArray(string str)
        {
            return Encoding.ASCII.GetBytes(str);
        }
        public static bool checkKeyEqual(byte[] a, byte[] b)
        {
            return a.Equals(b);
        }

        public static string ToHexString(byte[] data) {
            return Hex.ToHexString(data);
        }
        public static byte[] HexStringToBytes(string str)
        {
            return Hex.Decode(str);
        }

        public static string GetPrivateKeyFromString(string privateKeyStr)
        {
            EthECKey ek = new EthECKey(stringToSHA256(privateKeyStr), true);
            return Hex.ToHexString(ek.GetPrivateKeyAsBytes()) ;
        }

        public static byte[] GetPublicKeyFromPrivateKey(string privateKeyStr) {
            EthECKey ek = new EthECKey(stringToSHA256(privateKeyStr), true);             
            return ek.GetPubKey(); 
        }

        public byte[] sign(String privateKeyStr)
        {
            byte[] hash = getDataHash();
            EthECKey ek = new EthECKey(stringToSHA256(privateKeyStr), true);
            byte[] pk = ek.GetPubKey();

            //signature
            EthECDSASignature signature = ek.Sign(hash);
            byte[] ob = signature.To64ByteArray();
            return signature.To64ByteArray();           //Convert the signature to a 64-bit character byte array    
        }

        public bool verify(byte[] publicKey, byte[] sig64)
        {
            byte[] hash = getDataHash();
            EthECKey vk = new EthECKey(publicKey, false);               //Use public key
            var vsig = CityLuaUtil.sigFrom64ByteArray(sig64);           //Use 64byte string to generate signature
            return vk.Verify(hash, vsig);                               //Verified
        }

        static readonly string SaltKey = "S@LT&KEY";
        static readonly string VIKey = "@1B2c3D4e5F6g7H8";

        public static string Encrypt(string Password, string plainText)
        {
            byte[] plainTextBytes = Encoding.UTF8.GetBytes(plainText);

            byte[] keyBytes = new Rfc2898DeriveBytes(Password, Encoding.ASCII.GetBytes(SaltKey)).GetBytes(256 / 8);
            var symmetricKey = new RijndaelManaged() { Mode = CipherMode.CBC, Padding = PaddingMode.Zeros };
            var encryptor = symmetricKey.CreateEncryptor(keyBytes, Encoding.ASCII.GetBytes(VIKey));

            byte[] cipherTextBytes;

            using (var memoryStream = new System.IO.MemoryStream())
            {
                using (var cryptoStream = new CryptoStream(memoryStream, encryptor, CryptoStreamMode.Write))
                {
                    cryptoStream.Write(plainTextBytes, 0, plainTextBytes.Length);
                    cryptoStream.FlushFinalBlock();
                    cipherTextBytes = memoryStream.ToArray();
                    cryptoStream.Close();
                }
                memoryStream.Close();
            }
            return Convert.ToBase64String(cipherTextBytes);
        }

        public static string Decrypt(string Password, string encryptedText)
        {
            byte[] cipherTextBytes = Convert.FromBase64String(encryptedText);
            byte[] keyBytes = new Rfc2898DeriveBytes(Password, Encoding.ASCII.GetBytes(SaltKey)).GetBytes(256 / 8);
            var symmetricKey = new RijndaelManaged() { Mode = CipherMode.CBC, Padding = PaddingMode.None };

            var decryptor = symmetricKey.CreateDecryptor(keyBytes, Encoding.ASCII.GetBytes(VIKey));
            var memoryStream = new System.IO.MemoryStream(cipherTextBytes);
            var cryptoStream = new CryptoStream(memoryStream, decryptor, CryptoStreamMode.Read);
            byte[] plainTextBytes = new byte[cipherTextBytes.Length];

            int decryptedByteCount = cryptoStream.Read(plainTextBytes, 0, plainTextBytes.Length);
            memoryStream.Close();
            cryptoStream.Close();
            return Encoding.UTF8.GetString(plainTextBytes, 0, decryptedByteCount).TrimEnd("\0".ToCharArray());
        }

        public static void test_signer_ct()
        {
            signer_ct sm = new signer_ct();
            var privateKeyStr = "asdfqwper234123412341234lkjlkj2342ghhg5j";
            //Public key & private key
            EthECKey ek = new EthECKey(stringToSHA256(privateKeyStr), true);
            byte[] pk = ek.GetPubKey();
            string pkstr = Hex.ToHexString(pk);

            sm.pushHexSting("0636ba40b4124c9babf8043f91ff9045"); //PurchaseId            
            //sm.pushSha256Hex("asdfqwper234123412341234lkjlkj2342ghhg5j"); //addr
            sm.pushLong(1559911178647); //ts                   
            sm.pushHexSting("123456");   //meta
            sm.pushHexSting(pkstr);

            //Calculate data hashes
            var datahash = sm.getDataHash();
            var datahashstr = Hex.ToHexString(datahash);

            
            //Test passed-----------------------------------------------------------------
            //signature
            EthECDSASignature signature = ek.Sign(datahash);
            byte[] sig64 = signature.To64ByteArray();           //Convert the signature to a 64-bit string    
            string sig64Str = Hex.ToHexString(sig64);


            //verification
            EthECKey vk = new EthECKey(pk, false);              //Use public key
            var vsig = CityLuaUtil.sigFrom64ByteArray(sig64);   //Use 64byte string to generate signature 
            var passv = vk.Verify(datahash, vsig);              //Verified
            //Test passed-----------------------------------------------------------------       

            byte[] sig64_1 = sm.sign(privateKeyStr);
            bool pass = sm.verify(pk,sig64_1);

            //Local private key protection-------------------------------------------------------------The test has not passed            
            //1、 Generate the original string of the private key. With this string, you can generate the private key, so you only need to protect this string.
            string privateKeyToProtect = GetPrivateKeyFromString(System.Guid.NewGuid().ToString().Replace("-", ""));
            //2、 Use a 6-digit password to protect the private key string
            string password = "123456";            
            string Encryptedkey = signer_ct.Encrypt(password,privateKeyToProtect);

            string privateKeyDecrypted = signer_ct.Decrypt(password, Encryptedkey);
            string privateKeyDecryptedWrong = signer_ct.Decrypt("123123", Encryptedkey);

            //Local private key protection-------------------------------------------------------------
            int t = 1;
        }
    }

}
