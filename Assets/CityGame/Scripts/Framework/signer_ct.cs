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
        public void pushHexSting(String str)
        {
            str = str.Replace("-","");
            byte[] bts = Hex.Decode(str);
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
            byte[] bts = BitConverter.GetBytes(ld);  //这里与ccapi服务器不一致， 是大小端不匹配，正好相反      
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
                SHA256 mySHA256 = SHA256.Create();
                byte[] output = mySHA256.ComputeHash(hashOfdData);
                return output;
            }
        }
        

        
        public bool verifyByPbyKey(ref byte[] publicKey, byte[] signature)
        {
            //根据数据计算哈希
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

        public static string ToHexString(byte[] data) {
            return Hex.ToHexString(data);
        }
        public static byte[] HexStringToBytes(string str)
        {
            return Hex.Decode(str);
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

            //签名
            EthECDSASignature signature = ek.Sign(hash);
            byte[] ob = signature.To64ByteArray();
            return signature.To64ByteArray();           //把签名转为64位字符byte数组     
        }

        public bool verify(byte[] publicKey, byte[] sig64)
        {
            byte[] hash = getDataHash();
            EthECKey vk = new EthECKey(publicKey, false);               //使用公钥
            var vsig = CityLuaUtil.sigFrom64ByteArray(sig64);           //使用64byte字符串生成签名 
            return vk.Verify(hash, vsig);                               //验证通过
        }
        public static void test_signer_ct()
        {
            signer_ct sm = new signer_ct();
            var privateKeyStr = "asdfqwper234123412341234lkjlkj2342ghhg5j";
            //公钥私钥
            EthECKey ek = new EthECKey(stringToSHA256(privateKeyStr), true);
            byte[] pk = ek.GetPubKey();
            string pkstr = Hex.ToHexString(pk);

            sm.pushHexSting("0636ba40b4124c9babf8043f91ff9045"); //PurchaseId            
            //sm.pushSha256Hex("asdfqwper234123412341234lkjlkj2342ghhg5j"); //addr
            sm.pushLong(1559911178647); //ts                   
            sm.pushHexSting("123456");   //meta
            sm.pushHexSting(pkstr);

            //计算数据哈希
            var datahash = sm.getDataHash();
            var datahashstr = Hex.ToHexString(datahash);

            
            //测试通过-----------------------------------------------------------------
            //签名
            EthECDSASignature signature = ek.Sign(datahash);
            byte[] sig64 = signature.To64ByteArray();           //把签名转为64位字符串     
            string sig64Str = Hex.ToHexString(sig64);


            //验证
            EthECKey vk = new EthECKey(pk, false);              //使用公钥
            var vsig = CityLuaUtil.sigFrom64ByteArray(sig64);   //使用64byte字符串生成签名 
            var passv = vk.Verify(datahash, vsig);              //验证通过
            //测试通过-----------------------------------------------------------------           

            int t = 1;
        }
    }

}
