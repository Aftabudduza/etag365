using System;
using System.Net;
using System.Collections.Generic;
using Twilio;
using Twilio.Rest.Api.V2010.Account;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Diagnostics;

namespace eTag365
{
    public partial class SMSCOMMS : System.Web.UI.Page  
    {
        public string errStr = string.Empty;
        public string sCode = string.Empty;
        public string sPhone = string.Empty;
        public string conStr = System.Configuration.ConfigurationManager.ConnectionStrings["eTagDB"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string sMessage = "eTag365 has created your very secure contact information manager account. Please complete your profile. Press the following link https://www.etag365.com/deal. Enter this mobile number for Username and Password you want and fill out the rest of the form. Thank you.";

                var numbersToMessage = new List<string>();

                string sSQL = "Select Phone from UserProfile where DATEDIFF(day, createdDate, getdate()) = 3 or DATEDIFF(day, createdDate, getdate()) = 6";
                DataTable dtResult = SqlToTbl(sSQL);
                if(dtResult != null && dtResult.Rows.Count > 0)
                {
                    foreach(DataRow dr in dtResult.Rows)
                    {
                        if(dr != null)
                        {
                            numbersToMessage.Add(dr[0].ToString());
                        }
                    }
                }

                if (numbersToMessage != null)
                {
                    ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls
                                                | SecurityProtocolType.Tls11
                                                | SecurityProtocolType.Tls12
                                                | SecurityProtocolType.Ssl3;



                    var accountSid = "AC9b28b772a5b48e027934f1822f9af829";
                    var authToken = "34c311a38737d1a567398b442d7eea4d";
                    string strFromKey = "+16106386455";
                   
                    TwilioClient.Init(accountSid, authToken);

                   
                  
                    string sSuccess = "";
                    string sFail = "";
                    if(numbersToMessage != null && numbersToMessage.Count > 0)
                    {
                        foreach (var number in numbersToMessage)
                        {
                            string sToPhone = "";
                            try
                            {                               
                                if (number.Length == 10)
                                {
                                    sToPhone = "+1" + number;
                                }
                                else
                                {
                                    sToPhone = "+" + number;
                                }

                                var message = MessageResource.Create(
                                    body: sMessage,
                                    from: new Twilio.Types.PhoneNumber(strFromKey),
                                    to: new Twilio.Types.PhoneNumber(sToPhone)
                                );

                                sSuccess += sToPhone + ",";
                            }
                            catch(Exception ex)
                            {
                                sFail += sToPhone + ",";
                            }
                        }

                       
                    }

                    try
                    {
                        if (sSuccess.Length > 0)
                        {
                            string logFilePath = Path.Combine(Request.PhysicalApplicationPath, "Data\\Files\\");

                            if (!Directory.Exists(logFilePath))
                            {
                                Directory.CreateDirectory(logFilePath);
                            }

                            string fileName = "PhoneLog.txt";
                            string logFile = Path.Combine(logFilePath, fileName);

                            if (!File.Exists(logFile))
                            {
                                File.Create(logFile);
                            }

                            using (StreamWriter writer = new StreamWriter(logFile, true))
                            {
                                writer.WriteLine(DateTime.Now.ToString() + " -  eTag365 SMS sent successfully To following numbers:  " + "\n");
                            }

                            sSuccess = sSuccess.Trim();
                            sSuccess = sSuccess.Substring(0, sSuccess.Length - 1);
                            // Append line to the file.
                            using (StreamWriter writer = new StreamWriter(logFile, true))
                            {
                                writer.WriteLine(sSuccess + "\n");
                            }
                        }
                    }
                    catch (Exception ex)
                    {

                    }

                    try
                    {
                        if (sFail.Length > 0)
                        {
                            string errorlogFilePath = Path.Combine(Request.PhysicalApplicationPath, "Data\\ErrorFiles\\");

                            if (!Directory.Exists(errorlogFilePath))
                            {
                                Directory.CreateDirectory(errorlogFilePath);
                            }

                            string errorfileName = "PhoneLogError.txt";
                            string errorlogFile = Path.Combine(errorlogFilePath, errorfileName);

                            if (!File.Exists(errorlogFile))
                            {
                                File.Create(errorlogFile);
                            }

                            sFail = sFail.Trim();
                            sFail = sFail.Substring(0, sFail.Length - 1);

                            using (StreamWriter writer = new StreamWriter(errorlogFile, true))
                            {
                                writer.WriteLine(DateTime.Now.ToString() + " - eTag365 SMS sending failed To following numbers:" + "\n");
                            }

                            // Append line to the file.
                            using (StreamWriter writer = new StreamWriter(errorlogFile, true))
                            {
                                writer.WriteLine(sFail + "\n");
                            }
                        }
                    }
                    catch (Exception ex)
                    {

                    }

                }

                Process[] AllProcesses = Process.GetProcesses();
                foreach (var process in AllProcesses)
                {
                    if (process.MainWindowTitle != "")
                    {
                        string s = process.ProcessName.ToLower();
                        //if (s == "iexplore" || s == "iexplorer")
                        if (s == "iexplore" || s == "iexplorer" || s == "chrome" || s == "firefox")
                        {
                            process.Kill();
                        }
                           
                            
                    }
                }
            }

        }
        public DataTable SqlToTbl(string strSqlRec)
        {
            using (SqlDataAdapter Adp = new SqlDataAdapter())
            {
                using (SqlCommand selectCMD = new SqlCommand(strSqlRec, new SqlConnection(conStr)))
                {
                    selectCMD.CommandTimeout = 3600;
                    Adp.SelectCommand = selectCMD;
                    using (DataTable Tbl = new DataTable())
                    {
                        Adp.Fill(Tbl);
                        return Tbl;
                    }
                }
            }
        }
    }
}