using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace eTagService
{
    public static class Gateway
    {

        #region CONSTANTS

        public class Signature
        {
            public string api_login_id { get; set; }
            public string secure_trans_key { get; set; }
            public string pay_now_single_payment { get; set; }
            public string pay_schedule_amount { get; set; }
            public string pay_range_select_amount { get; set; }
            public string pay_range_select_amount_labels { get; set; }
            public string hash_method { get; set; }
            public string utc_time { get; set; }
            public string customer_token { get; set; }
            public string payment_token { get; set; }
        }

        #endregion

        static Signature objSign = new Signature();
        static Operation myoper = new Operation();
        static string mySignature = "Error";

        public static string EndPoint(Signature SignClient, string Operation)
        {
            objSign = SignClient;

            switch (Operation)
            {

                case "CREATESIGNATUREPAYSINGLEAMOUNT":
                    mySignature = myoper.CreateSignature(objSign.pay_now_single_payment, objSign.secure_trans_key);
                    break;

                case "CREATESIGNATURESCHEDULE":
                    mySignature = myoper.CreateSignature(objSign.pay_schedule_amount, objSign.secure_trans_key);
                    break;

                case "CREATESIGNATURERANGE":
                    mySignature = myoper.CreateSignature(objSign.pay_range_select_amount, objSign.secure_trans_key);
                    break;

                case "CREATESIGNATURERANGELABEL":
                    mySignature = myoper.CreateSignature(objSign.pay_range_select_amount_labels, objSign.secure_trans_key);
                    break;
            }

            return mySignature;

        }
    }
    internal class Operation
    {
        public Operation()
        {

        }
        internal string CreateSignature(string strSource, string key)
        {
            string Signature = "error";

            System.Text.ASCIIEncoding encoding = new System.Text.ASCIIEncoding();
            byte[] keyByte = encoding.GetBytes(key);
            byte[] messageBytes = encoding.GetBytes(strSource);
            byte[] hashmessage;


            hashmessage = null;
            Signature = null;
            HMACMD5 hmacmd5 = new HMACMD5(keyByte);
            hashmessage = hmacmd5.ComputeHash(messageBytes);
            Signature = ByteToString(hashmessage);


            return Signature;

        }

        public static string ByteToString(byte[] buff)
        {
            string sbinary = "";

            for (int i = 0; i < buff.Length; i++)
            {
                sbinary += buff[i].ToString("X2"); // hex format
            }
            return (sbinary);
        }

    }
}
