using System;
using System.Net;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Diagnostics;
using System.Text;
using System.Net.Mail;

namespace eTag365
{
    public partial class Test : System.Web.UI.Page  
    {     
        public string conStr = System.Configuration.ConfigurationManager.ConnectionStrings["eTagDB"].ConnectionString;
        private static System.Net.Mail.SmtpClient objSmtpClient;
        private static System.Net.Mail.MailMessage objMailMessage;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {

                // Now Contruct the ICS file using string builder

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


                from_address = "aftab@etag365.com";

                to_address = "aftabudduza@gmail.com";

                objMailMessage = new System.Net.Mail.MailMessage();
                objMailMessage.From = new System.Net.Mail.MailAddress(from_address);
                objMailMessage.To.Add(new System.Net.Mail.MailAddress(to_address));

                objMailMessage.Subject = "eTag365 Send mail with ICS file";
                objMailMessage.Body = "Please Attend the meeting with this schedule";

                DateTime mStart = Convert.ToDateTime("2022-12-25 20:15");
                DateTime mEnd = Convert.ToDateTime("2022-12-25 20:30");

                DateTime now = DateTime.Now;
                //TimeZoneInfo destinationTimeZone = TimeZoneInfo.FindSystemTimeZoneById("UTC");
                //var converted = TimeZoneInfo.ConvertTime(now, destinationTimeZone);

              //  DateTime localTime = TimeZoneInfo.ConvertTime(DateTime.UtcNow, TimeZoneInfo.Local);


                StringBuilder str = new StringBuilder();
                str.AppendLine("BEGIN:VCALENDAR");
                str.AppendLine("PRODID:-//Schedule a Meeting");
                str.AppendLine("VERSION:2.0");
                str.AppendLine("METHOD:REQUEST");
                //str.AppendLine("TZ:-05");
               
                str.AppendLine("BEGIN:VEVENT");
                str.AppendLine(string.Format("DTSTART:{0:yyyyMMddTHHmmssT}", mStart.AddHours(-6)));
                str.AppendLine(string.Format("DTSTAMP:{0:yyyyMMddTHHmmssT}", now));
                //str.AppendLine(string.Format("DTSTAMP:{0:yyyyMMddTHHmmssT}", DateTime.Now));
                str.AppendLine(string.Format("DTEND:{0:yyyyMMddTHHmmssT}", mEnd.AddHours(-6)));

                //str.AppendLine(string.Format("DTSTART:{0:yyyyMMddTHHmmssZ}", DateTime.UtcNow.AddMinutes(+30)));
                //str.AppendLine(string.Format("DTSTAMP:{0:yyyyMMddTHHmmssZ}", DateTime.UtcNow));
                //str.AppendLine(string.Format("DTEND:{0:yyyyMMddTHHmmssZ}", DateTime.UtcNow.AddMinutes(+60)));
                // str.AppendLine("LOCATION: " + "Chittagong");
               
                str.AppendLine(string.Format("UID:{0}", Guid.NewGuid()));
                str.AppendLine(string.Format("DESCRIPTION:{0}", objMailMessage.Body));
                str.AppendLine(string.Format("X-ALT-DESC;FMTTYPE=text/html:{0}", objMailMessage.Body));
                str.AppendLine(string.Format("SUMMARY:{0}", objMailMessage.Subject));
                str.AppendLine(string.Format("ORGANIZER:MAILTO:{0}", objMailMessage.From.Address));

                str.AppendLine(string.Format("ATTENDEE;CN=\"{0}\";RSVP=TRUE:mailto:{1}", objMailMessage.To[0].DisplayName, objMailMessage.To[0].Address));

                str.AppendLine("BEGIN:VALARM");
                str.AppendLine("TRIGGER:-PT15M");
                str.AppendLine("ACTION:DISPLAY");
                str.AppendLine("DESCRIPTION:Reminder");
                str.AppendLine("END:VALARM");
                str.AppendLine("END:VEVENT");
                str.AppendLine("END:VCALENDAR");

                byte[] byteArray = Encoding.ASCII.GetBytes(str.ToString());
                MemoryStream stream = new MemoryStream(byteArray);

                Attachment attach = new Attachment(stream, "a.ics");

                objMailMessage.Attachments.Add(attach);

             
               // objSmtpClient.Send(objMailMessage);

                Utility.DisplayMsg("Ëmail Sent", this);

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