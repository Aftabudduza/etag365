<%@ WebHandler Language="C#" Class="eTag365.API.Contact" %>

using System.Web;
using System.Data;
using System.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using Twilio;
using Twilio.Rest.Api.V2010.Account;
using Twilio.Types;
using System.Net;
using eTagService.Enums;

namespace eTag365.API
{
    /// <summary>
    /// Summary description for contact
    /// </summary>
    public class Contact : IHttpHandler
    {
        private HttpContext context;
        private string JSN = "{\"status\": false, \"message\": \"Unknown Command\", \"Data\": [{}] }";
        private string strPref = "{\"status\": true, \"message\": \"Data retrieved successfully\", \"Data\":";
        private string strPosf = " }";
        private string json = "";

        public string conStr = System.Configuration.ConfigurationManager.ConnectionStrings["eTagDB"].ConnectionString;

        private string jsonString = "";

        private System.Net.Mail.SmtpClient objSmtpClient;
        private System.Net.Mail.MailMessage objMailMessage;

        string strLoginID = System.Configuration.ConfigurationManager.AppSettings.Get("TLoginID");
        string strSecureKey = System.Configuration.ConfigurationManager.AppSettings.Get("TProcessingKey");
        string strFromKey = System.Configuration.ConfigurationManager.AppSettings.Get("TFromKey");



        public void ProcessRequest(HttpContext context)
        {
            context.Response.AppendHeader("Access-Control-Allow-Credentials", "true");
            context.Response.AppendHeader("Access-Control-Allow-Origin", "*");

           


            // Api for DB Query
            
            // http://173.248.133.199/API/Pest.ashx?datatype=add_data&Data=starttime*2020-05-05 22:12:01.807|endtime*2020-05-05 22:12:01.807|filepath*C:\Users\Mohammad\Downloads\ee\1.jpeg
            if (context.Request.Params["datatype"] == "add_data")
            {
                if (context.Request.Params["Data"] == null)
                {
                    JSN = "{\"status\": false, \"message\":  \"Please enter all mandatory parameters\",  \"Data\": [{}] }";
                }

                else
                {
                    string sData = context.Request.Params["Data"].ToString();

                    int nId = 0;

                    nId = InsertRatHistory(sData);

                    if (nId > 0)
                    {
                        jsonString = "[{\"RatId\":\"" + nId.ToString() + "\"";
                        jsonString += "}]";
                        JSN = strPref + jsonString + strPosf;
                    }
                    else
                    {
                        JSN = "{\"status\": false, \"message\": \"Data not Created\", \"Data\": [{}] }";
                    }

                }
            }
            //// http://173.248.133.199/API/Pest.ashx?datatype=get_ratdata
            else if (context.Request.Params["datatype"] == "get_ratdata")
            {
                string sSQL = "select Id, starttime, endtime, isnull(filepath,'') filepath from rat_transaction order by id desc";
                DataTable dtResult = SqlToTbl(sSQL);
                if (dtResult != null && dtResult.Rows.Count > 0)
                {
                    JSN = strPref + GetJson(dtResult) + strPosf;
                }

                else
                {
                    JSN = "{\"status\": false, \"message\": \"No Data\", \"Data\": [{}] }";
                }
            }
            else
            {
                JSN = "{\"status\": false, \"message\": \"Unknown Command\", \"Data\": [{}] }";
                context.Response.ContentType = "text/json";
            }

            context.Response.ContentType = "text/json";
            context.Response.Write(JSN);
        }

        public string GetJson(DataTable dt)
        {
            // This Function will make json from Sql Query
            System.Web.Script.Serialization.JavaScriptSerializer serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;

            foreach (DataRow dr in dt.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt.Columns)
                    row.Add(col.ColumnName, dr[col]);
                rows.Add(row);
            }
            return serializer.Serialize(rows);
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



       

        public int InsertRatHistory(string sData)
        {
            int M = 0;

            string sInit = "INSERT INTO rat_transaction";
            string sParam = "";
            string sValue = "";
            string[] sDataArray = null;
            string sInsertSQL = "";

            if (sData.Length > 0)
            {
                sDataArray = sData.Split('|');
                foreach (string sCol in sDataArray)
                {
                    if (string.IsNullOrEmpty(sCol))
                    {
                        continue;
                    }
                    else
                    {
                        string tempEmail = sCol;
                        char ch = '*';
                        int idx = tempEmail.IndexOf(ch);
                        string paramname = tempEmail.Substring(0, idx);
                        string paramvalue = tempEmail.Substring(idx + 1);

                        sParam += paramname.ToString().Trim() + ",";
                        sValue += "'" + paramvalue.ToString().Trim() + "',";
                    }
                }

                sParam = sParam.Substring(0, sParam.Length - 1);

                sValue = sValue.Substring(0, sValue.Length - 1);

                sInsertSQL = sInit + "( " + sParam + " ) values ( " + sValue + " ) ";
            }

            if (sInsertSQL.Length > 0)
            {

                SqlConnection conn = new SqlConnection(conStr);
                conn.Open();

                try
                {
                    System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand(sInsertSQL, conn);
                    cmd.ExecuteNonQuery();
                    cmd.Parameters.Clear();
                    cmd.CommandText = "Select @@Identity";
                    M = Convert.ToInt32(cmd.ExecuteScalar().ToString());
                    cmd.Dispose();
                }
                catch (Exception ex)
                {
                }

                conn.Close();
            }


            return M;
        }

      
      

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }

        public bool SendEmail(string sEmail, int nUserId)
        {
            bool IsSentSuccessful = false;
            try
            {
                string strMailServer = string.Empty;
                string strMailUser = string.Empty;
                string strMailPassword = string.Empty;
                string strMailPort = System.Configuration.ConfigurationManager.AppSettings.Get("strMailPort");
                string isMailLive = System.Configuration.ConfigurationManager.AppSettings.Get("isMailLive");

                strMailUser = System.Configuration.ConfigurationManager.AppSettings.Get("strMailUser");
                strMailPassword = System.Configuration.ConfigurationManager.AppSettings.Get("strMailPassword");
                strMailServer = System.Configuration.ConfigurationManager.AppSettings.Get("strMailServer");

                if (isMailLive == "true")
                {
                    objSmtpClient = new System.Net.Mail.SmtpClient(strMailServer, Convert.ToInt32(strMailPort));
                    objSmtpClient.UseDefaultCredentials = false;
                    objSmtpClient.Credentials = new System.Net.NetworkCredential(strMailUser, strMailPassword);
                }
                else
                {
                    objSmtpClient = new System.Net.Mail.SmtpClient("smtp.gmail.com", 587);
                    objSmtpClient.UseDefaultCredentials = false;
                    objSmtpClient.EnableSsl = true;
                    objSmtpClient.Credentials = new System.Net.NetworkCredential("info.visaformalaysia@gmail.com", "admin_321");
                }

                string from_address = "";
                string to_address = "";

                from_address = System.Configuration.ConfigurationManager.AppSettings.Get("fromAddress");

                try
                {
                    to_address = sEmail;
                }
                catch (Exception e)
                {
                    to_address = System.Configuration.ConfigurationManager.AppSettings.Get("toAddress");
                }


                objMailMessage = new System.Net.Mail.MailMessage();
                objMailMessage.From = new System.Net.Mail.MailAddress(from_address, "eTag365 Support");
                objMailMessage.To.Add(new System.Net.Mail.MailAddress(to_address));
                objMailMessage.Subject = "New user Registration request from eTag365";
                objMailMessage.IsBodyHtml = true;
                objMailMessage.Body = this.EmailHtml(nUserId).ToString();
                objSmtpClient.Send(objMailMessage);

                IsSentSuccessful = true;

            }
            catch (Exception ex)
            {

            }

            finally
            {
                if ((objSmtpClient == null) == false)
                {
                    objSmtpClient = null;
                }

                if ((objMailMessage == null) == false)
                {
                    objMailMessage.Dispose();
                    objMailMessage = null;
                }
            }

            return IsSentSuccessful;
        }

        public System.Text.StringBuilder EmailHtml(int nUserId)
        {
            System.Text.StringBuilder emailbody = new System.Text.StringBuilder();
            string sWeb = System.Configuration.ConfigurationManager.AppSettings.Get("WebUrl");
            string sUrl = sWeb + "/login";
            string sSQL = " Select isnull(Email,'') Email,isnull(Phone,'') Phone,isnull(FirstName,'') FirstName,isnull(LastName,'') LastName,isnull(Password,'') Password,isnull(Title,'') Title,isnull(CompanyName,'') CompanyName,isnull(WorkPhone,'') WorkPhone,isnull(Address,'') Address,isnull(Address1,'') Address1,isnull(State,'') State,isnull(City,'') City,isnull(Region,'') Region,isnull(Zip,'') Zip, isnull(Fax,'') Fax, isnull(WorkPhoneExt,'') WorkPhoneExt  from UserProfile where Id = '" + nUserId.ToString() + "' ";
            string sPassword = "";
            DataTable dtResult = SqlToTbl(sSQL);
            try
            {
                emailbody.Append("<table>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'><img  alt='eTag365' width='120' src='" + sWeb + "/Images/logo.png'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2' style='text-align:Left;font-size:14px;font-weight:bold;color:0000cc;'>Dear User</td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'><p>eTag365 has created your very secure contact information manager account. Please complete your profile. You may view your contacts for free. Press the following link. </p> </td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'><p><a style='color:blue;' href='" + sUrl + "' target='_blank'>https://www.etag365.net</a></p> </td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");

                if (dtResult != null && dtResult.Rows.Count > 0)
                {
                    sPassword = (dtResult.Rows[0]["Password"] != null && dtResult.Rows[0]["Password"] != DBNull.Value) ? dtResult.Rows[0]["Password"].ToString() : "";
                    sPassword = sPassword.Length > 0 ? Utility.base64Decode(sPassword) : "";

                    emailbody.Append("<tr><td>First Name: </td><td> " + ((dtResult.Rows[0]["FirstName"] != null && dtResult.Rows[0]["FirstName"] != DBNull.Value) ? dtResult.Rows[0]["FirstName"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>Last Name: </td><td> " + ((dtResult.Rows[0]["LastName"] != null && dtResult.Rows[0]["LastName"] != DBNull.Value) ? dtResult.Rows[0]["LastName"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>Title: </td><td> " + ((dtResult.Rows[0]["Title"] != null && dtResult.Rows[0]["Title"] != DBNull.Value) ? dtResult.Rows[0]["Title"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>Email: </td><td> " + ((dtResult.Rows[0]["Email"] != null && dtResult.Rows[0]["Email"] != DBNull.Value) ? dtResult.Rows[0]["Email"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>Cell Number: </td><td> +" + ((dtResult.Rows[0]["Phone"] != null && dtResult.Rows[0]["Phone"] != DBNull.Value) ? dtResult.Rows[0]["Phone"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>Work Phone: </td><td> " + ((dtResult.Rows[0]["WorkPhone"] != null && dtResult.Rows[0]["WorkPhone"] != DBNull.Value) ? dtResult.Rows[0]["WorkPhone"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>Work Phone Extension: </td><td> " + ((dtResult.Rows[0]["WorkPhoneExt"] != null && dtResult.Rows[0]["WorkPhoneExt"] != DBNull.Value) ? dtResult.Rows[0]["WorkPhoneExt"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>Fax: </td><td> " + ((dtResult.Rows[0]["Fax"] != null && dtResult.Rows[0]["Fax"] != DBNull.Value) ? dtResult.Rows[0]["Fax"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>Company Name: </td><td> " + ((dtResult.Rows[0]["CompanyName"] != null && dtResult.Rows[0]["CompanyName"] != DBNull.Value) ? dtResult.Rows[0]["CompanyName"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>Address: </td><td> " + ((dtResult.Rows[0]["Address"] != null && dtResult.Rows[0]["Address"] != DBNull.Value) ? dtResult.Rows[0]["Address"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>Address 2: </td><td> " + ((dtResult.Rows[0]["Address1"] != null && dtResult.Rows[0]["Address1"] != DBNull.Value) ? dtResult.Rows[0]["Address1"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>Region: </td><td> " + ((dtResult.Rows[0]["Region"] != null && dtResult.Rows[0]["Region"] != DBNull.Value) ? dtResult.Rows[0]["Region"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>City: </td><td> " + ((dtResult.Rows[0]["City"] != null && dtResult.Rows[0]["City"] != DBNull.Value) ? dtResult.Rows[0]["City"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>State: </td><td> " + ((dtResult.Rows[0]["State"] != null && dtResult.Rows[0]["State"] != DBNull.Value) ? dtResult.Rows[0]["State"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>Zip: </td><td> " + ((dtResult.Rows[0]["Zip"] != null && dtResult.Rows[0]["Zip"] != DBNull.Value) ? dtResult.Rows[0]["Zip"].ToString() : "") + " </td></tr>");

                }

                emailbody.Append("<tr><td>Password: </td><td> " + sPassword + " </td></tr>");

                emailbody.Append("<tr><td>Transaction Date: </td><td> " + Convert.ToDateTime(DateTime.Now).ToString("MM/dd/yyyy hh:mm:ss tt") + " </td></tr>");

                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'><p>Enter your mobile number for both the User name and Password. You will be prompted to change your password when you login. You can not change your User name.</p></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'>Best Regards</td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'><p>eTag365 Team</p> </td></tr>");
                emailbody.Append("</table>");
            }
            catch (Exception ex)
            {
            }


            return emailbody;
        }

        public bool SendEmailToAdmin(int nUserId)
        {
            bool IsSentSuccessful = false;
            try
            {
                string strMailServer = string.Empty;
                string strMailUser = string.Empty;
                string strMailPassword = string.Empty;
                string strMailPort = System.Configuration.ConfigurationManager.AppSettings.Get("strMailPort");
                string isMailLive = System.Configuration.ConfigurationManager.AppSettings.Get("isMailLive");

                strMailUser = System.Configuration.ConfigurationManager.AppSettings.Get("strMailUser");
                strMailPassword = System.Configuration.ConfigurationManager.AppSettings.Get("strMailPassword");
                strMailServer = System.Configuration.ConfigurationManager.AppSettings.Get("strMailServer");

                if (isMailLive == "true")
                {
                    objSmtpClient = new System.Net.Mail.SmtpClient(strMailServer, Convert.ToInt32(strMailPort));
                    objSmtpClient.UseDefaultCredentials = false;
                    objSmtpClient.Credentials = new System.Net.NetworkCredential(strMailUser, strMailPassword);
                }
                else
                {
                    objSmtpClient = new System.Net.Mail.SmtpClient("smtp.gmail.com", 587);
                    objSmtpClient.UseDefaultCredentials = false;
                    objSmtpClient.EnableSsl = true;
                    objSmtpClient.Credentials = new System.Net.NetworkCredential("info.visaformalaysia@gmail.com", "admin_321");
                }

                string from_address = "";
                string to_address = "";

                from_address = System.Configuration.ConfigurationManager.AppSettings.Get("fromAddress");


                try
                {
                    to_address = System.Configuration.ConfigurationManager.AppSettings.Get("toAddress");
                }
                catch (Exception e)
                {
                    to_address = "sbutcher@etag365.com";
                }

                objMailMessage = new System.Net.Mail.MailMessage();
                objMailMessage.From = new System.Net.Mail.MailAddress(from_address, "eTag365 Support");
                objMailMessage.To.Add(new System.Net.Mail.MailAddress(to_address));
                objMailMessage.Subject = "New user Registration request from eTag365";
                objMailMessage.IsBodyHtml = true;
                objMailMessage.Body = this.EmailHtmlToAdmin(nUserId).ToString();
                objSmtpClient.Send(objMailMessage);

                IsSentSuccessful = true;

            }
            catch (Exception ex)
            {

            }

            finally
            {
                if ((objSmtpClient == null) == false)
                {
                    objSmtpClient = null;
                }

                if ((objMailMessage == null) == false)
                {
                    objMailMessage.Dispose();
                    objMailMessage = null;
                }
            }

            return IsSentSuccessful;
        }

        public System.Text.StringBuilder EmailHtmlToAdmin(int nUserId)
        {
            System.Text.StringBuilder emailbody = new System.Text.StringBuilder();
            string sWeb = System.Configuration.ConfigurationManager.AppSettings.Get("WebUrl");
            string sUrl = sWeb + "/login";
            string sSQL = " Select isnull(Password,'') Password,isnull(Email,'') Email,isnull(Phone,'') Phone,isnull(FirstName,'') FirstName,isnull(LastName,'') LastName,isnull(Title,'') Title,isnull(CompanyName,'') CompanyName,isnull(WorkPhone,'') WorkPhone,isnull(Address,'') Address,isnull(Address1,'') Address1,isnull(State,'') State,isnull(City,'') City,isnull(Region,'') Region,isnull(Zip,'') Zip, isnull(Fax,'') Fax from UserProfile where Id = " + nUserId.ToString();

            DataTable dtResult = SqlToTbl(sSQL);
            try
            {
                emailbody.Append("<table>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'><img  alt='eTag365' width='120' src='" + sWeb + "/Images/logo.png'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2' style='text-align:Left;font-size:14px;font-weight:bold;color:0000cc;'>Dear Admin</td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'><p>eTag365 has created a new user. </p> </td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");

                string sPassword = "";
                if (dtResult != null && dtResult.Rows.Count > 0)
                {
                    sPassword = (dtResult.Rows[0]["Password"] != null && dtResult.Rows[0]["Password"] != DBNull.Value) ? dtResult.Rows[0]["Password"].ToString() : "";
                    sPassword = sPassword.Length > 0 ? Utility.base64Decode(sPassword) : "";

                    emailbody.Append("<tr><td>First Name: </td><td> " + ((dtResult.Rows[0]["FirstName"] != null && dtResult.Rows[0]["FirstName"] != DBNull.Value) ? dtResult.Rows[0]["FirstName"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>Last Name: </td><td> " + ((dtResult.Rows[0]["LastName"] != null && dtResult.Rows[0]["LastName"] != DBNull.Value) ? dtResult.Rows[0]["LastName"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>Title: </td><td> " + ((dtResult.Rows[0]["Title"] != null && dtResult.Rows[0]["Title"] != DBNull.Value) ? dtResult.Rows[0]["Title"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>Email: </td><td> " + ((dtResult.Rows[0]["Email"] != null && dtResult.Rows[0]["Email"] != DBNull.Value) ? dtResult.Rows[0]["Email"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>Cell Number: </td><td> +" + ((dtResult.Rows[0]["Phone"] != null && dtResult.Rows[0]["Phone"] != DBNull.Value) ? dtResult.Rows[0]["Phone"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>Work Phone: </td><td> " + ((dtResult.Rows[0]["WorkPhone"] != null && dtResult.Rows[0]["WorkPhone"] != DBNull.Value) ? dtResult.Rows[0]["WorkPhone"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>Work Phone Extension: </td><td> " + ((dtResult.Rows[0]["WorkPhoneExt"] != null && dtResult.Rows[0]["WorkPhoneExt"] != DBNull.Value) ? dtResult.Rows[0]["WorkPhoneExt"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>Fax: </td><td> " + ((dtResult.Rows[0]["Fax"] != null && dtResult.Rows[0]["Fax"] != DBNull.Value) ? dtResult.Rows[0]["Fax"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>Company Name: </td><td> " + ((dtResult.Rows[0]["CompanyName"] != null && dtResult.Rows[0]["CompanyName"] != DBNull.Value) ? dtResult.Rows[0]["CompanyName"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>Address: </td><td> " + ((dtResult.Rows[0]["Address"] != null && dtResult.Rows[0]["Address"] != DBNull.Value) ? dtResult.Rows[0]["Address"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>Address 2: </td><td> " + ((dtResult.Rows[0]["Address1"] != null && dtResult.Rows[0]["Address1"] != DBNull.Value) ? dtResult.Rows[0]["Address1"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>Region: </td><td> " + ((dtResult.Rows[0]["Region"] != null && dtResult.Rows[0]["Region"] != DBNull.Value) ? dtResult.Rows[0]["Region"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>City: </td><td> " + ((dtResult.Rows[0]["City"] != null && dtResult.Rows[0]["City"] != DBNull.Value) ? dtResult.Rows[0]["City"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>State: </td><td> " + ((dtResult.Rows[0]["State"] != null && dtResult.Rows[0]["State"] != DBNull.Value) ? dtResult.Rows[0]["State"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>Zip: </td><td> " + ((dtResult.Rows[0]["Zip"] != null && dtResult.Rows[0]["Zip"] != DBNull.Value) ? dtResult.Rows[0]["Zip"].ToString() : "") + " </td></tr>");

                }


                emailbody.Append("<tr><td>Password: </td><td> " + sPassword + " </td></tr>");
                emailbody.Append("<tr><td>Transaction Date: </td><td> " + Convert.ToDateTime(DateTime.Now).ToString("MM/dd/yyyy hh:mm:ss tt") + " </td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'>Best Regards</td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'><p>eTag365 Team</p> </td></tr>");
                emailbody.Append("</table>");
            }
            catch (Exception ex)
            {
            }
            return emailbody;
        }

        public bool SendEmailToAdminOnly(int nUserId)
        {
            bool IsSentSuccessful = false;
            try
            {
                string strMailServer = string.Empty;
                string strMailUser = string.Empty;
                string strMailPassword = string.Empty;
                string strMailPort = System.Configuration.ConfigurationManager.AppSettings.Get("strMailPort");
                string isMailLive = System.Configuration.ConfigurationManager.AppSettings.Get("isMailLive");

                strMailUser = System.Configuration.ConfigurationManager.AppSettings.Get("strMailUser");
                strMailPassword = System.Configuration.ConfigurationManager.AppSettings.Get("strMailPassword");
                strMailServer = System.Configuration.ConfigurationManager.AppSettings.Get("strMailServer");

                if (isMailLive == "true")
                {
                    objSmtpClient = new System.Net.Mail.SmtpClient(strMailServer, Convert.ToInt32(strMailPort));
                    objSmtpClient.UseDefaultCredentials = false;
                    objSmtpClient.Credentials = new System.Net.NetworkCredential(strMailUser, strMailPassword);
                }
                else
                {
                    objSmtpClient = new System.Net.Mail.SmtpClient("smtp.gmail.com", 587);
                    objSmtpClient.UseDefaultCredentials = false;
                    objSmtpClient.EnableSsl = true;
                    objSmtpClient.Credentials = new System.Net.NetworkCredential("info.visaformalaysia@gmail.com", "admin_321");
                }

                string from_address = "";
                string to_address = "";

                from_address = System.Configuration.ConfigurationManager.AppSettings.Get("fromAddress");


                try
                {
                    to_address = System.Configuration.ConfigurationManager.AppSettings.Get("toAddress");
                }
                catch (Exception e)
                {
                    to_address = "sbutcher@etag365.com";
                }

                objMailMessage = new System.Net.Mail.MailMessage();
                objMailMessage.From = new System.Net.Mail.MailAddress(from_address, "eTag365 Support");
                objMailMessage.To.Add(new System.Net.Mail.MailAddress(to_address));
                objMailMessage.Subject = "New user Registration request from eTag365";
                objMailMessage.IsBodyHtml = true;
                objMailMessage.Body = this.EmailHtmlToAdminOnly(nUserId).ToString();
                objSmtpClient.Send(objMailMessage);

                IsSentSuccessful = true;

            }
            catch (Exception ex)
            {

            }

            finally
            {
                if ((objSmtpClient == null) == false)
                {
                    objSmtpClient = null;
                }

                if ((objMailMessage == null) == false)
                {
                    objMailMessage.Dispose();
                    objMailMessage = null;
                }
            }
            return IsSentSuccessful;

        }

        public System.Text.StringBuilder EmailHtmlToAdminOnly(int nUserId)
        {
            System.Text.StringBuilder emailbody = new System.Text.StringBuilder();
            string sWeb = System.Configuration.ConfigurationManager.AppSettings.Get("WebUrl");
            string sUrl = sWeb + "/login";
            string sSQL = " Select isnull(Password,'') Password,isnull(Phone,'') Phone  from UserProfile where Id = " + nUserId.ToString();
            DataTable dtResult = SqlToTbl(sSQL);
            try
            {
                emailbody.Append("<table>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'><img  alt='eTag365' width='120' src='" + sWeb + "/Images/logo.png'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2' style='text-align:Left;font-size:14px;font-weight:bold;color:0000cc;'>Dear Admin</td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'><p>eTag365 has created a new user. </p> </td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                string sCell = "";
                string sPassword = "";
                if (dtResult != null && dtResult.Rows.Count > 0)
                {
                    sCell = (dtResult.Rows[0]["Phone"] != null && dtResult.Rows[0]["Phone"] != DBNull.Value) ? dtResult.Rows[0]["Phone"].ToString() : "";
                    sPassword = (dtResult.Rows[0]["Password"] != null && dtResult.Rows[0]["Password"] != DBNull.Value) ? dtResult.Rows[0]["Password"].ToString() : "";
                    sPassword = sPassword.Length > 0 ? Utility.base64Decode(sPassword) : "";
                }

                emailbody.Append("<tr><td>Cell Number: </td><td> +" + sCell + " </td></tr>");

                emailbody.Append("<tr><td>Password: </td><td> " + sPassword + " </td></tr>");

                emailbody.Append("<tr><td>Transaction Date: </td><td> " + Convert.ToDateTime(DateTime.Now).ToString("MM/dd/yyyy hh:mm:ss tt") + " </td></tr>");

                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'>Best Regards</td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'><p>eTag365 Team</p> </td></tr>");
                emailbody.Append("</table>");
            }
            catch (Exception ex)
            {
            }
            return emailbody;
        }

        public string InsertPaymentHistory(string phone, string sData)
        {
            string sSerial = "";
            sSerial = GenerateSerialForPayment("Billing", "Id", "I");
            string sCountryCode = "";
            string sCellNumber = "";
            if (phone.Length > 10)
            {
                sCellNumber = phone.Substring(phone.Length - 10);
                sCountryCode = phone.Substring(0, phone.Length - 10);
            }
            else
            {
                sCellNumber = phone;
                sCountryCode = "1";
            }

            phone = sCountryCode + sCellNumber;

            string sInit = "INSERT INTO PaymentHistory";
            string sParam = "FromUser,ToUser,FromUserType,ToUserType,CreateDate,TransactionDescription,Getway,Status,Serial,TransactionType,LedgerCode,Remarks,IsStorageSubscription,IsRecurring,IsBillingCycleMonthly,StorageAmount,DiscountPercentage,CheckingAccountProcessingFee,DebitAmount,ContactMultiplier,IsAgree,";
            string sValue = "'" + phone + "','eTag365','2','1',getdate(),'APPROVED','Billing Payment','pending','" + sSerial + "','SubscriptionFee','4060','SubscriptionFee',0,0,0,0,0,0,0,1,1,";
            string[] sDataArray = null;
            string sInsertSQL = "";

            if (sData.Length > 0)
            {
                sDataArray = sData.Split('|');
                foreach (string sCol in sDataArray)
                {
                    if (string.IsNullOrEmpty(sCol))
                    {
                        continue;
                    }
                    else
                    {
                        string tempColumn = sCol;
                        char ch = ':';
                        int idx = tempColumn.IndexOf(ch);
                        string paramname = tempColumn.Substring(0, idx);
                        string paramvalue = tempColumn.Substring(idx + 1);
                        double nYTD = 0, nMTD = 0, nGross = 0;

                        if (paramname.ToUpper().ToString().Trim() == "SUBTOTALCHARGE")
                        {
                            sParam += "BasicAmount,SubTotalCharge" + ",";
                            sValue += "'" + paramvalue.ToString().Trim() + "','" + paramvalue.ToString().Trim() + "',";
                        }

                        else if (paramname.ToUpper().ToString().Trim() == "NETAMOUNT")
                        {
                            if (paramvalue != null && paramvalue != "")
                            {
                                nGross = Convert.ToDouble(paramvalue.ToString().Trim());
                            }

                            if (nGross > 0)
                            {
                                nYTD = nGross * 0.05;
                                nMTD = nYTD / 12;
                            }

                            sParam += "GrossAmount,CreditAmount,NetAmount,YTD_Commission,MTD_Commission" + ",";
                            sValue += "'" + paramvalue.ToString().Trim() + "','" + paramvalue.ToString().Trim() + "','" + paramvalue.ToString().Trim() + "','" + nYTD.ToString("0.00") + "','" + nMTD.ToString("0.00") + "',";
                        }

                        else if (paramname.ToUpper().ToString().Trim() == "SUBSCRIPTIONTYPE")
                        {
                            if (paramvalue.ToUpper().ToString().Trim() == "BASIC")
                            {
                                sParam += "SubscriptionType,YTD_Contact_Export_Limit,MTD_Contact_Import_Limit,Contact_Storage_Limit, NoOfContact,TotalContact,PerUnitCharge,MonthlyCharge" + ",";
                                sValue += "'Basic','250','10','500','500','500','1','1',";
                            }
                            else if (paramvalue.ToUpper().ToString().Trim() == "SILVER")
                            {
                                sParam += "SubscriptionType,YTD_Contact_Export_Limit,MTD_Contact_Import_Limit,Contact_Storage_Limit, NoOfContact,TotalContact,PerUnitCharge,MonthlyCharge" + ",";
                                sValue += "'Silver','500','50','10000','10000','10000','3.99','3.99',";
                            }
                            else if (paramvalue.ToUpper().ToString().Trim() == "GOLD")
                            {
                                sParam += "SubscriptionType,YTD_Contact_Export_Limit,MTD_Contact_Import_Limit,Contact_Storage_Limit, NoOfContact,TotalContact,PerUnitCharge,MonthlyCharge" + ",";
                                sValue += "'Gold','unlimited','unlimited','unlimited','','','0','0',";
                            }
                            else
                            {
                                sParam += "SubscriptionType,YTD_Contact_Export_Limit,MTD_Contact_Import_Limit,Contact_Storage_Limit, NoOfContact,TotalContact,PerUnitCharge,MonthlyCharge" + ",";
                                sValue += "'Basic','250','10','500','500','500','1','1',";
                            }

                            //sParam += paramname + ",";
                            //sValue += "'" + paramvalue + "',";
                        }
                        else
                        {
                            sParam += paramname.ToString().Trim() + ",";
                            sValue += "'" + paramvalue.ToString().Trim() + "',";
                        }
                    }
                }

                sParam = sParam.Substring(0, sParam.Length - 1);

                sValue = sValue.Substring(0, sValue.Length - 1);

                sInsertSQL = sInit + "( " + sParam + " ) values ( " + sValue + " ) ";
            }

            if (sInsertSQL.Length > 0)
            {

                SqlConnection conn = new SqlConnection(conStr);
                conn.Open();

                try
                {
                    System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand(sInsertSQL, conn);
                    cmd.ExecuteNonQuery();
                    cmd.Parameters.Clear();
                    cmd.Dispose();
                }
                catch (Exception ex)
                {
                    sSerial = "";
                }

                conn.Close();
            }


            return sSerial;
        }

        public string GenerateSerialForPayment(string ObjectID, string ItemID, string prefix)
        {
            string sSerial = "";
            string sNumber = "";
            int nID = 0;
            SqlConnection conn = new SqlConnection(conStr);
            conn.Open();

            try
            {
                SqlCommand cmd = new SqlCommand("SP_GetID", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@ObjectID", ObjectID);
                cmd.Parameters.AddWithValue("@ItemID", ItemID);
                cmd.Parameters.AddWithValue("@IDForYear", DateTime.Now.Year);
                cmd.Parameters.AddWithValue("@IDForMonth", null);
                cmd.Parameters.AddWithValue("@IDForDate", null);
                cmd.Parameters.Add("@NewID", SqlDbType.Int);
                cmd.Parameters["@NewID"].Direction = ParameterDirection.Output;
                cmd.ExecuteNonQuery();
                nID = Convert.ToInt32(cmd.Parameters["@NewID"].Value);
                cmd.Dispose();
            }
            catch (Exception ex)
            {

            }

            if (nID <= 0)
            {
                nID = 1;
            }

            sNumber = nID.ToString().PadLeft(11, '0');
            sSerial = string.Concat(prefix, sNumber);


            conn.Close();

            return sSerial;

        }

       
      


    }
}

