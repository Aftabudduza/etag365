using System;
using System.Net;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Diagnostics;

namespace eTag365
{
    public partial class EmailFlow : System.Web.UI.Page  
    {     
        public string conStr = System.Configuration.ConfigurationManager.ConnectionStrings["eTagDB"].ConnectionString;
        private static System.Net.Mail.SmtpClient objSmtpClient;
        private static System.Net.Mail.MailMessage objMailMessage;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                processEmailFlow();

                Process[] AllProcesses = Process.GetProcesses();
                foreach (var process in AllProcesses)
                {
                    if (process.MainWindowTitle != "")
                    {
                        string s = process.ProcessName.ToLower();

                        if (s == "iexplore" || s == "iexplorer" || s == "chrome" || s == "firefox")
                        {
                            process.Kill();
                        }
                           
                    }
                }
            }
        }
        public bool SendEmail(DataRow dr)
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


                try
                {
                    from_address = (dr["FromEmail"] != null) ? dr["FromEmail"].ToString() : System.Configuration.ConfigurationManager.AppSettings.Get("toAddress");
                }
                catch (Exception e)
                {
                    from_address = "sbutcher@etag365.com";
                }

                try
                {
                    to_address =  (dr["PersonEmail"] != null) ? dr["PersonEmail"].ToString() : System.Configuration.ConfigurationManager.AppSettings.Get("toAddress");
                }
                catch (Exception e)
                {
                   // to_address = "sbutcher@etag365.com";
                }

                objMailMessage = new System.Net.Mail.MailMessage();
                objMailMessage.From = new System.Net.Mail.MailAddress(from_address, "eTag365");
                objMailMessage.To.Add(new System.Net.Mail.MailAddress(to_address));              
                objMailMessage.Subject = dr["Subject"] != null ? dr["Subject"].ToString() : "eTag365 Email Template";
                objMailMessage.IsBodyHtml = true;
                objMailMessage.Body = EmailHtml(dr).ToString();
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
        private void processEmailFlow()
        {
            try
            {
                //string sSQL =   "  select Isnull(T.Id,0) EId, Isnull(c.Id,0) UserId, isnull(C.FirstName,'') FirstName, isnull(C.LastName,'') LastName, isnull(T.PersonEmail,'') PersonEmail  " +
                //                " , isnull(T.FromEmail, '') FromEmail,isnull(T.LastEmailNumber, '') TemplateNo, isnull(ES.Category, '') Category, isnull(ES.Type, '') Type, isnull(ES.Subject, '') Subject, isnull(ES.Content, '') Content, isnull(ES.Greetings, '') Greetings " +
                //                " from(select distinct isnull(e.CreatedBy, '') CreatedBy, isnull(e.FromEmail, '') FromEmail, isnull(e.PersonName, '') PersonName, isnull(max(e.PersonEmail), '') PersonEmail, isnull(min(e.LastEmailNumber), '0') LastEmailNumber, isnull(max(e.Category), '') Category, isnull(max(e.Type), '') Type " +
                //                " , Id = isnull((select max(a.Id) from EmailSchedule a where a.FromEmail = e.FromEmail and a.PersonName = e.PersonName and a.LastEmailNumber = min(e.LastEmailNumber) and a.Category = max(e.Category) and a.Type = max(e.Type) group by a.FromEmail, a.PersonName, a.Category, a.Type), '0') " +
                //                " from EmailSchedule e left join (select distinct CreatedBy,FromEmail, PersonName, MAx(LastEmailSentOn) LastEmailSentOn from EmailSchedule group by CreatedBy, FromEmail, PersonName) u " +
                //                " on u.FromEmail = e.FromEmail and u.PersonName = e.PersonName where((e.LastEmailNumber = 0 and e.LastEmailSentOn is null) " +
                //                "  or(e.LastEmailNumber > 0 and e.LastEmailSentOn is null and u.LastEmailSentOn is null and convert(varchar, DATEADD(dd, cast(e.Days as int), e.CreatedDate), 101) <= convert(varchar, getdate(), 101)) " +
                //                "  or(e.LastEmailNumber > 0 and e.LastEmailSentOn is null and u.LastEmailSentOn is not null and convert(varchar, DATEADD(dd, cast(e.Days as int), u.LastEmailSentOn), 101) <= convert(varchar, getdate(), 101)) " +
                //                "  or(e.LastEmailNumber > 0 and e.IsLoop = 1 and e.LastEmailSentOn is not null and convert(varchar, DATEADD(dd, cast(e.Days as int), u.LastEmailSentOn), 101) <= convert(varchar, getdate(), 101)) " +
                //                "  ) group by e.CreatedBy, e.FromEmail, e.PersonName) T, EmailSetup ES, ContactInformation c where T.CreatedBy = ES.CreatedBy and T.LastEmailNumber = ES.TemplateNo and T.Category = ES.Category and T.Type = ES.Type and c.Id = T.PersonName and c.IsEmailFlow = 1 ";

                string sSQL = "  select Isnull(T.Id,0) EId, Isnull(T.TId,0) TId, Isnull(c.Id,0) UserId, isnull(C.FirstName,'') FirstName, isnull(C.LastName,'') LastName, isnull(T.PersonEmail,'') PersonEmail  " +
                                " , isnull(T.FromEmail, '') FromEmail,isnull(T.LastEmailNumber, '') TemplateNo, isnull(ES.Category, '') Category, isnull(ES.Type, '') Type, isnull(ES.Subject, '') Subject, isnull(ES.Content, '') Content, isnull(ES.Greetings, '') Greetings " +
                                " from(select distinct isnull(e.CreatedBy, '') CreatedBy, isnull(e.FromEmail, '') FromEmail, isnull(e.PersonName, '') PersonName, isnull(max(e.PersonEmail), '') PersonEmail, isnull(min(e.LastEmailNumber), '0') LastEmailNumber, isnull(max(e.Category), '') Category, isnull(max(e.Type), '') Type " +
                                " , Id = isnull((select max(a.Id) from EmailSchedule a where a.FromEmail = e.FromEmail and a.PersonName = e.PersonName and a.LastEmailNumber = min(e.LastEmailNumber) and a.Category = max(e.Category) and a.Type = max(e.Type) group by a.FromEmail, a.PersonName, a.Category, a.Type), '0') " +
                                " , TId = isnull((select max(a.Id) from EmailSetup a where a.Category = max(e.Category) and a.Type = max(e.Type) and a.TemplateNo=min(e.LastEmailNumber) and a.UserId = (select max(Id) Id from userprofile where email= e.FromEmail)), '0') " +
                                " from EmailSchedule e left join (select distinct CreatedBy,FromEmail, PersonName, MAx(LastEmailSentOn) LastEmailSentOn from EmailSchedule group by CreatedBy, FromEmail, PersonName) u " +
                                " on u.FromEmail = e.FromEmail and u.PersonName = e.PersonName where((e.LastEmailNumber = 0 and e.LastEmailSentOn is null) " +
                                "  or(e.LastEmailNumber > 0 and e.LastEmailSentOn is null and u.LastEmailSentOn is null and convert(varchar, DATEADD(dd, cast(e.Days as int), e.CreatedDate), 101) <= convert(varchar, getdate(), 101)) " +
                                "  or(e.LastEmailNumber > 0 and e.LastEmailSentOn is null and u.LastEmailSentOn is not null and convert(varchar, DATEADD(dd, cast(e.Days as int), u.LastEmailSentOn), 101) <= convert(varchar, getdate(), 101)) " +
                                "  or(e.LastEmailNumber > 0 and e.IsLoop = 1 and e.LastEmailSentOn is not null and convert(varchar, DATEADD(dd, cast(e.Days as int), u.LastEmailSentOn), 101) <= convert(varchar, getdate(), 101)) " +
                                "  ) group by e.CreatedBy, e.FromEmail, e.PersonName) T, EmailSetup ES, ContactInformation c where T.CreatedBy = ES.CreatedBy and T.LastEmailNumber = ES.TemplateNo and T.Category = ES.Category and T.Type = ES.Type and c.Id = T.PersonName and c.IsEmailFlow = 1 ";



                DataTable dtResult = SqlToTbl(sSQL);
                if (dtResult != null && dtResult.Rows.Count > 0)
                {
                    foreach (DataRow dr in dtResult.Rows)
                    {
                        if (dr != null)
                        {
                            try
                            {
                                string sTemplateNo = "";
                                string SQLMailSchedule = "";
                                string sEId = "0";

                                sEId = dr["EId"] != null ? dr["EId"].ToString() : "0";

                                string sTemplateId = "0";

                                sTemplateId = dr["TId"] != null ? dr["TId"].ToString() : "0";

                                sTemplateNo = dr["TemplateNo"] != null ? dr["TemplateNo"].ToString() : "0";

                                string sToEmail = dr["PersonEmail"] != null ? dr["PersonEmail"].ToString() : "";
                                string sFromEmail = dr["FromEmail"] != null ? dr["FromEmail"].ToString() : "";

                                string sPersonName = dr["UserId"] != null ? dr["UserId"].ToString() : "";
                                string sCategory = dr["Category"] != null ? dr["Category"].ToString() : "";
                                string sType = dr["Type"] != null ? dr["Type"].ToString() : "";

                                if (sTemplateNo == "" || sTemplateNo == "0")
                                {
                                    SQLMailSchedule = " update EmailSchedule set LastEmailNumber = '" + sTemplateNo + "', LastEmailSentOn = GETDATE(), IsZeroMailSent = 1,  ZeroEmailSentOn = GETDATE()  where PersonName = '" + sPersonName + "' and FromEmail = '" + sFromEmail + "' and LastEmailNumber ='" + sTemplateNo + "' and Category = '" + sCategory + "' and Type = '" + sType + "' ";
                                }
                                else
                                {
                                    SQLMailSchedule = " update EmailSchedule set LastEmailNumber = '" + sTemplateNo + "', LastEmailSentOn = GETDATE()  where PersonName = '" + sPersonName + "' and FromEmail = '" + sFromEmail + "' and LastEmailNumber ='" + sTemplateNo + "' and Category = '" + sCategory + "' and Type = '" + sType + "' ";
                                }


                                //string SQLMailLog = "insert into EmailLog (PersonEmail, FromEmail, EmailNumber, EmailSentOn) values('" + sToEmail + "', '" + sFromEmail + "', '" + sTemplateNo + "', GETDATE() )";

                                string SQLMailLog = "insert into EmailLog (PersonEmail, FromEmail, EmailNumber, EmailSentOn, Status, TemplateId) values('" + sToEmail + "', '" + sFromEmail + "', '" + sTemplateNo + "', GETDATE(), 'Success', '" + sTemplateId + "' )";

                                string SQLMailLogFail = "insert into EmailLog (PersonEmail, FromEmail, EmailNumber, EmailSentOn, Status, TemplateId) values('" + sToEmail + "', '" + sFromEmail + "', '" + sTemplateNo + "', GETDATE(), 'Fail', '" + sTemplateId + "' )";

                                if (SendEmail(dr))
                                {
                                    SqlConnection conn = new SqlConnection(conStr);
                                    conn.Open();

                                    try
                                    {
                                        System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand(SQLMailSchedule, conn);
                                        cmd.ExecuteNonQuery();
                                        cmd.Parameters.Clear();
                                        cmd.Dispose();                                       
                                    }
                                    catch (Exception ex)
                                    {

                                    }

                                    try
                                    {
                                        System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand(SQLMailLog, conn);
                                        cmd.ExecuteNonQuery();
                                        cmd.Parameters.Clear();
                                        cmd.Dispose();
                                    }
                                    catch (Exception ex)
                                    {

                                    }

                                    conn.Close();                                    
                                   
                                }
                                else
                                {
                                    SqlConnection conn = new SqlConnection(conStr);
                                    conn.Open();                                   

                                    try
                                    {
                                        System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand(SQLMailLogFail, conn);
                                        cmd.ExecuteNonQuery();
                                        cmd.Parameters.Clear();
                                        cmd.Dispose();
                                    }
                                    catch (Exception ex)
                                    {

                                    }

                                    conn.Close();
                                }

                            }
                            catch (Exception ex)
                            {

                            }                           
                        }
                    }
                }
            }
            catch(Exception ex)
            {

            }
        }
        public System.Text.StringBuilder EmailHtml(DataRow dr)
        {
            System.Text.StringBuilder emailbody = new System.Text.StringBuilder();
            string sWeb = System.Configuration.ConfigurationManager.AppSettings.Get("WebUrl");
            string sTemplateNo = dr["TemplateNo"] != null ? dr["TemplateNo"].ToString() : "";
            string sEId = "0";
            sEId = dr["TId"] != null ? dr["TId"].ToString() : "0";
            string sUId = dr["UserId"] != null ? dr["UserId"].ToString() : "";
            string sUrl = sWeb + "/email-unsubscribe?TId=" + sTemplateNo + "&EId=" + sUId + "&SId=" + sEId;

            try
            {
                emailbody.Append("<table>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'><img  alt='eTag365' width='120' src='" + sWeb + "/Images/logo.png'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2' style='text-align:Left;font-size:14px;font-weight:bold;color:0000cc;'> " + (dr["Greetings"] != null ? dr["Greetings"].ToString() : "") + "  " + (dr["FirstName"] != null ? dr["FirstName"].ToString() : "") + " </td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'>" + (dr["Content"] != null ? dr["Content"].ToString() : "") + "</td></tr>");               
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'>If you do not want to receive email <a style='color:blue;' href='" + sUrl + "' target='_blank'>Unsubscribe </a> here </td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'><p>Powered by <a target='_blank' href='https://etag365.com/'>eTag365</a></p> </td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("</table>");
            }
            catch (Exception ex)
            {
            }
            return emailbody;
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