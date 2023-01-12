using eTag365.Models;
using Ical.Net.CalendarComponents;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Reflection;

using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using TagService.BO;
using TagService.DA;

namespace eTag365
{
    public partial class UserAppointment : System.Web.UI.Page
    {
        public string errStr = String.Empty;
        public string sUrl = string.Empty;
        private System.Net.Mail.SmtpClient objSmtpClient;
        private System.Net.Mail.MailMessage objMailMessage;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session["objUser"] = null;
                Session["UserSerial"] = null;
                Session["UserId"] = null;
                hdUserId.Value = "";
                txtDate.Text = DateTime.Now.ToString("MM-dd-yyyy");
                string serial = string.Empty;

                txtDate.Text = DateTime.Now.ToString("MM-dd-yyyy");
                string sessionid = System.Web.HttpContext.Current.Session.SessionID;
                if (!string.IsNullOrEmpty(sessionid))
                {
                    int userid = Utility.IntegerData("SELECT TOP 1 UserId FROM UserLog_Data Where SessionId='" + sessionid + "' Order By LogId DESC");

                    if (userid > 0)
                    {
                        UserProfile objTemp = new UserProfileDA().GetUserByUserID(userid);
                        if (objTemp != null)
                        {
                            Session["objUser"] = objTemp;
                            Session["Phone"] = objTemp.Phone;
                            Session["UserType"] = (objTemp.IsAdmin != null && Convert.ToBoolean(objTemp.IsAdmin) == true ? "1" : "0");
                            lblUserName.InnerText = objTemp.FirstName + " " + objTemp.LastName;
                            lblUserEmail.InnerText = objTemp.Email;
                            Session["UserSerial"] = objTemp.Serial;
                            Session["UserId"] = objTemp.Id;
                            hdUserId.Value = objTemp.Id.ToString();

                        }
                    }
                    else
                    {
                        Response.Redirect(Utility.WebUrl + "/login");
                    }
                }
                else
                {
                    Response.Redirect(Utility.WebUrl + "/login");
                }



            }
        }
        public string Validate_Control()
        {
            try
            {
                //if (lblUserEmail.InnerText.ToString().Trim() == txtEmail.Text.ToString().Trim())
                //{
                //    errStr += "Please Enter Different Email Address" + Environment.NewLine;
                //}

            }
            catch (Exception ex)
            {
            }

            return errStr;
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            int nCount = 0;
            errStr = string.Empty;
            errStr = Validate_Control();
            if (errStr.Length <= 0)
            {
                try
                {


                }
                catch (Exception ex)
                {

                }
            }
            else
            {
                Utility.DisplayMsg(errStr.ToString(), this);
            }
        }

        protected void btnClose_Click(object sender, EventArgs e)
        {
            ClearCheckbox();
            Response.Redirect("/home");
        }

       

        private void ClearCheckbox()
        {
            gvContactList.DataSource = null;
            gvContactList.DataBind();

            gvSchedule.DataSource = null;
            gvSchedule.DataBind();

        }

        protected void btnDetails_Click(object sender, EventArgs e)
        {
            GridViewRow row = ((LinkButton)sender).Parent.Parent as GridViewRow;
            Label hdId = (Label)gvContactList.Rows[row.RowIndex].FindControl("lblId");

            if (!String.IsNullOrEmpty(hdId.Text))
            {
                string sSQL = "SELECT *  FROM CalendarSchedule  where MeetingId = " + hdId.Text + " order by ToUserLastName, ToUserFirstName";
                DataTable dtResult = SqlToTbl(sSQL);

                if (dtResult != null && dtResult.Rows.Count > 0)
                {
                    lblMeetingTime.InnerHtml = dtResult.Rows[0]["MeetingStartTimeShow"].ToString();
                    gvSchedule.DataSource = dtResult;
                    gvSchedule.DataBind();
                }
            }
        }

        protected void gvContactList_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvContactList.PageIndex = e.NewPageIndex;
            FillCalendarEntry();
        }
        protected void gvContactList_Sorting(object sender, GridViewSortEventArgs e)
        {
            FillCalendarEntry();
        }

        private void FillCalendarEntry()
        {
            try
            {
                DateTime dDate = DateTime.Now.Date;
                try
                {
                    dDate = Convert.ToDateTime(txtDate.Text.ToString()).Date;
                }
                catch (Exception ex)
                {

                }

                DateTime dMeetingDate = Convert.ToDateTime(dDate).Date;

                string sSQL = "SELECT *  FROM CalendarEntry  where UserId='" + Session["UserId"].ToString() + "' and MeetingDate = '" + dMeetingDate.ToString("yyyy-MM-dd") + "' and IsAvailable = 1 order by GMTTimeStart";
                DataTable dtResult = SqlToTbl(sSQL);

                if (dtResult != null && dtResult.Rows.Count > 0)
                {
                    spanTimezone.InnerHtml = dtResult.Rows[0]["Timezone"].ToString();
                    gvContactList.DataSource = dtResult;
                    gvContactList.DataBind();
                }

            }
            catch (Exception e)
            {

            }
        }

        public static DataTable SqlToTbl(string strSqlRec)
        {
            using (SqlDataAdapter Adp = new SqlDataAdapter())
            {
                using (SqlCommand selectCMD = new SqlCommand(strSqlRec, new SqlConnection(ConfigurationManager.ConnectionStrings["eTagDB"].ConnectionString)))
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

        protected void txtDate_TextChanged(object sender, EventArgs e)
        {
            ClearCheckbox();
            FillCalendarEntry();
        }

        public bool SendEmail(CalendarSchedule obj)
        {
            bool IsSentSuccessful = false;
            try
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

                string from_address = obj.UserEmail;
                string to_address = obj.ToUserEmail;
                string to_username = obj.ToUserFirstName + " " + obj.ToUserLastName;

               //  from_address = "aftab@etag365.com";

               // to_address = "aftabudduza@gmail.com";

                string sTimezone = "Eastern";

                if (obj.TimeZoneDifference == 5)
                {
                    sTimezone = "Eastern";
                }
                else if (obj.TimeZoneDifference == 6)
                {
                    sTimezone = "Central";
                }
                else if (obj.TimeZoneDifference == 7)
                {
                    sTimezone = "Mountain";
                }
                else if (obj.TimeZoneDifference == 8)
                {
                    sTimezone = "Pacific";
                }
                else
                {
                    sTimezone = "Eastern";
                }

                sTimezone = sTimezone + " Standard Time";
                string srem = "Reminder you have scheduled appointment " + Convert.ToDateTime(obj.MeetingStartTime).ToString("ddd MMM d, yyyy hh:mm tt") + sTimezone + " with " + obj.UserName;
                string sFile = "v" + Convert.ToDateTime(DateTime.Now).ToString("yyMMddhhmmss") + ".ics";

                string mailSubject = "Meeting  with " + obj.UserName + " on " + Convert.ToDateTime(obj.MeetingStartTime).ToString("ddd MMM d, yyyy hh:mm tt") + " - " + Convert.ToDateTime(obj.MeetingEndTime).ToString("hh:mm tt") + " " + sTimezone;

                string mailBody = "You have requested an appointment with " + obj.UserName + " on  " + Convert.ToDateTime(obj.MeetingStartTime).ToString("ddd MMM d, yyyy hh:mm tt") + " - " + Convert.ToDateTime(obj.MeetingEndTime).ToString("hh:mm tt") + " " + sTimezone + ". \n\n Please click on the confirm button to confirm your appointment.";


                objMailMessage = new System.Net.Mail.MailMessage();
                objMailMessage.From = new System.Net.Mail.MailAddress(from_address, obj.UserName);
                objMailMessage.To.Add(new System.Net.Mail.MailAddress(to_address, to_username));

                objMailMessage.Subject = mailSubject;
                objMailMessage.IsBodyHtml = true;
                objMailMessage.Body = this.EmailHtml(obj).ToString();

                DateTime mStart = Convert.ToDateTime(obj.MeetingStartTime);
                DateTime mEnd = Convert.ToDateTime(obj.MeetingStartTime);

                DateTime now = DateTime.Now;


                StringBuilder str = new StringBuilder();
                str.AppendLine("BEGIN:VCALENDAR");
                str.AppendLine("PRODID:-//Schedule a Meeting");
                str.AppendLine("VERSION:2.0");
                str.AppendLine("METHOD:REQUEST");

                str.AppendLine("BEGIN:VEVENT");               

                DateTime endTime = DateTime.UtcNow;

                TimeSpan span = endTime.Subtract(now);


                str.AppendLine(string.Format("DTSTART:{0:yyyyMMddTHHmmssT}", mStart.AddHours(span.Hours)));
                str.AppendLine(string.Format("DTSTAMP:{0:yyyyMMddTHHmmssT}", now));
                str.AppendLine(string.Format("DTEND:{0:yyyyMMddTHHmmssT}", mEnd.AddHours(span.Hours)));

                str.AppendLine(string.Format("UID:{0}", Guid.NewGuid()));
                str.AppendLine(string.Format("DESCRIPTION:{0}", objMailMessage.Body));
                str.AppendLine(string.Format("X-ALT-DESC;FMTTYPE=text/html:{0}", objMailMessage.Body));
                str.AppendLine(string.Format("SUMMARY:{0}", objMailMessage.Subject));
                str.AppendLine(string.Format("ORGANIZER:MAILTO:{0}", objMailMessage.From.Address));

                str.AppendLine(string.Format("ATTENDEE;CN=\"{0}\";RSVP=TRUE:mailto:{1}", objMailMessage.To[0].DisplayName, objMailMessage.To[0].Address));

                str.AppendLine("BEGIN:VALARM");
                str.AppendLine("TRIGGER:-PT240M");
                str.AppendLine("ACTION:DISPLAY");
                str.AppendLine(string.Format("DESCRIPTION:{0}", srem));
                str.AppendLine("END:VALARM");
                str.AppendLine("END:VEVENT");
                str.AppendLine("END:VCALENDAR");

                byte[] byteArray = Encoding.ASCII.GetBytes(str.ToString());
                MemoryStream stream = new MemoryStream(byteArray);

                Attachment attach = new Attachment(stream, sFile);

                objMailMessage.Attachments.Add(attach);

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

        public System.Text.StringBuilder EmailHtml(CalendarSchedule obj)
        {
            System.Text.StringBuilder emailbody = new System.Text.StringBuilder();
            string sWeb = System.Configuration.ConfigurationManager.AppSettings.Get("WebUrl");
            string sUrl = "";

            string to_username = obj.ToUserFirstName + " " + obj.ToUserLastName;

            string sTimezone = "Eastern";

            if (obj.TimeZoneDifference == 5)
            {
                sTimezone = "Eastern";
            }
            else if (obj.TimeZoneDifference == 6)
            {
                sTimezone = "Central";
            }
            else if (obj.TimeZoneDifference == 7)
            {
                sTimezone = "Mountain";
            }
            else if (obj.TimeZoneDifference == 8)
            {
                sTimezone = "Pacific";
            }
            else
            {
                sTimezone = "Eastern";
            }

            sTimezone = sTimezone + " Standard Time";

            string sSQL2 = "SELECT *  FROM CalendarSchedule  where UserEmail='" + obj.UserEmail.ToString() + "' and ToUserEmail='" + obj.ToUserEmail.ToString() + "' and MeetingDate = '" + Convert.ToDateTime(obj.MeetingDate).ToString("yyyy-MM-dd") + "' and MeetingStartTimeShow = '" + obj.MeetingStartTimeShow + "'";
            DataTable dtResult2 = SqlToTbl(sSQL2);
            long nScheduleId = 0;
            if (dtResult2 != null && dtResult2.Rows.Count > 0)
            {
                nScheduleId = Convert.ToInt32(dtResult2.Rows[0][0]);
                sUrl = sWeb + "/event-confirm?EvId=" + nScheduleId;
            }

            emailbody.Append("<html><body>");

            try
            {
                emailbody.Append("<table>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
               // emailbody.Append("<tr><td colspan='2'><img  alt='eTag365' width='120' src='http://etag365.net/Images/logo.png'></td></tr>");
                //emailbody.Append("<tr><td colspan='2'><img  alt='eTag365' width='120' src='" + sWeb + "/Images/logo.png'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2' style='text-align:Left;font-size:14px;font-weight:bold;color:0000cc;'>Dear " + to_username + "</td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'><p>You have requested an appointment with " + obj.UserName + " on " + Convert.ToDateTime(obj.MeetingStartTime).ToString("ddd MMM d, yyyy hh:mm tt") + " - " + Convert.ToDateTime(obj.MeetingEndTime).ToString("hh:mm tt") + " " + sTimezone + " </p> </td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");

                emailbody.Append("<tr><td colspan='2'><p> Please click on the confirm button to confirm your appointment. </p> </td></tr>");

                emailbody.Append("<tr><td colspan='2'></td></tr>");

                emailbody.Append("<tr><td colspan='2'><p><a style='background-color: #66FF00;-webkit-appearance: button; cursor: pointer; border-color: #66FF00;border-radius: 3px;-webkit-box-shadow: none; box-shadow: none; border: 1px solid transparent; display: inline-block; font-weight: 400;text-align: center; white-space: nowrap;  vertical-align: middle; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none;border: 1px solid transparent;padding: 0.375rem 0.75rem; font-size: 1rem;line-height: 1.5; border-radius: 0.25rem; transition: color 0.15s ease-in-out, background-color 0.15s ease-in-out, border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out; color:#000; text-decoration:none;'  href='" + sUrl + "' target='_blank'>Confirm Appointment</a></p> </td></tr>");
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
            emailbody.Append("</body></html>");


            return emailbody;
        }

        protected void btnInvite_Click(object sender, EventArgs e)
        {
            GridViewRow row = ((LinkButton)sender).Parent.Parent as GridViewRow;
            Label hdId = (Label)gvSchedule.Rows[row.RowIndex].FindControl("lblInId");

            if (!String.IsNullOrEmpty(hdId.Text))
            {
                if (IsSave(hdId.Text))
                {
                    ClearCheckbox();
                    Utility.DisplayMsg("Invite Sent Successfully!", this);
                }
                else
                {
                    Utility.DisplayMsg("Invite not Sent!", this);
                }
            }
        }

        private bool IsSave(string sId = "")
        {
            bool bSuccess = false;

            try
            {
                int nCount = 0;

                CalendarSchedule obj = new CalendarSchedule();
                string sSQL = "SELECT *  FROM CalendarSchedule  where Id = " + sId;
                DataTable dtResult = SqlToTbl(sSQL);

                if (dtResult != null && dtResult.Rows.Count > 0)
                {
                    obj.MeetingId = Convert.ToInt64(dtResult.Rows[0]["MeetingId"].ToString());
                    obj.TimeZoneDifference = Convert.ToInt16(dtResult.Rows[0]["TimeZoneDifference"].ToString());
                    obj.Timezone = dtResult.Rows[0]["Timezone"].ToString();
                    obj.Duration = Convert.ToInt16(dtResult.Rows[0]["Duration"].ToString());

                    obj.UserName = dtResult.Rows[0]["UserName"].ToString();
                    obj.UserEmail = dtResult.Rows[0]["UserEmail"].ToString();
                    obj.UserId = dtResult.Rows[0]["UserId"].ToString();

                    obj.ToUserFirstName = dtResult.Rows[0]["ToUserFirstName"].ToString();
                    obj.ToUserLastName = dtResult.Rows[0]["ToUserLastName"].ToString();
                    obj.ToUserPhone = dtResult.Rows[0]["ToUserPhone"].ToString();
                    obj.ToUserEmail = dtResult.Rows[0]["ToUserEmail"].ToString();
                    obj.ToUserCompany = dtResult.Rows[0]["ToUserCompany"].ToString();
                    obj.Notes = dtResult.Rows[0]["Notes"].ToString();


                    obj.MeetingStartTimeShow = dtResult.Rows[0]["MeetingStartTimeShow"].ToString();
                    obj.MeetingStartTime = dtResult.Rows[0]["MeetingStartTime"].ToString();
                    obj.MeetingEndTime = dtResult.Rows[0]["MeetingEndTime"].ToString();
                    obj.GMTTimeStart = Convert.ToDateTime(dtResult.Rows[0]["GMTTimeStart"].ToString());
                    obj.GMTTimeEnd = Convert.ToDateTime(dtResult.Rows[0]["GMTTimeEnd"].ToString());
                    obj.IsBooked = 1;
                    obj.MeetingDate = Convert.ToDateTime(dtResult.Rows[0]["MeetingDate"].ToString());

                    if (SendEmail(obj))
                    {
                        bSuccess = true;
                    }

                }
                else
                {
                    return false;
                }
            }
            catch (Exception ex)
            {

            }

            return bSuccess;
        }

    }
}