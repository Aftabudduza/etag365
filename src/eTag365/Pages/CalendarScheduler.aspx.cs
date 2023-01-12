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

namespace eTag365.Pages
{
    public partial class CalendarScheduler : System.Web.UI.Page
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

                if (Request.QueryString["UId"] != null)
                {
                    try
                    {
                        serial = Request.QueryString["UId"].ToString();
                    }
                    catch (Exception ex)
                    {
                        serial = "";
                    }
                }

                if(serial.Trim().Length > 0)
                {
                    try
                    {
                        UserProfile objTemp = new UserProfileDA().GetUserBySerial(serial);
                        if (objTemp != null)
                        {
                            Session["objUser"] = objTemp;
                            lblUserName.InnerText = objTemp.FirstName + " " + objTemp.LastName;
                            lblUserEmail.InnerText = objTemp.Email;
                            Session["UserSerial"] = objTemp.Serial;
                            Session["UserId"] = objTemp.Id;
                            //txtLink.Text = "http://etag365.net/calendar-scheduler?UId=" + objTemp.Serial;
                            hdUserId.Value = objTemp.Id.ToString();

                            //  FillCalendarEntry();
                        }
                    }
                    catch (Exception ex)
                    {

                    }
                }
                
            }
        }
        public string Validate_Control()
        {
            try
            {
                if (lblUserEmail.InnerText.ToString().Trim() == txtEmail.Text.ToString().Trim())
                {
                    errStr += "Please Enter Different Email Address" + Environment.NewLine;
                }
                
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

                    foreach (ListItem item in chk101.Items)
                    {
                        if (item.Selected)
                        {
                            try
                            {
                                string sMeetingTimeShow = item.Text.ToString().Trim();

                                bool nSuccess = IsSave(sMeetingTimeShow, item.Value);

                                if (nSuccess == true)
                                {
                                    nCount = nCount + 1;
                                }

                            }

                            catch (Exception ex)
                            {

                            }
                        }
                    }

                    foreach (ListItem item in chk102.Items)
                    {
                        if (item.Selected)
                        {
                            try
                            {
                                string sMeetingTimeShow = item.Text.ToString().Trim();

                                bool nSuccess = IsSave(sMeetingTimeShow, item.Value);

                                if (nSuccess == true)
                                {
                                    nCount = nCount + 1;
                                }

                            }

                            catch (Exception ex)
                            {

                            }
                        }
                    }

                    foreach (ListItem item in chk103.Items)
                    {
                        if (item.Selected)
                        {
                            try
                            {
                                string sMeetingTimeShow = item.Text.ToString().Trim();

                                bool nSuccess = IsSave(sMeetingTimeShow, item.Value);

                                if (nSuccess == true)
                                {
                                    nCount = nCount + 1;
                                }

                            }

                            catch (Exception ex)
                            {

                            }
                        }
                    }

                    foreach (ListItem item in chk104.Items)
                    {
                        if (item.Selected)
                        {
                            try
                            {
                                string sMeetingTimeShow = item.Text.ToString().Trim();

                                bool nSuccess = IsSave(sMeetingTimeShow, item.Value);

                                if (nSuccess == true)
                                {
                                    nCount = nCount + 1;
                                }

                            }

                            catch (Exception ex)
                            {

                            }
                        }
                    }

                    foreach (ListItem item in chk105.Items)
                    {
                        if (item.Selected)
                        {
                            try
                            {
                                string sMeetingTimeShow = item.Text.ToString().Trim();

                                bool nSuccess = IsSave(sMeetingTimeShow, item.Value);

                                if (nSuccess == true)
                                {
                                    nCount = nCount + 1;
                                }

                            }

                            catch (Exception ex)
                            {

                            }
                        }
                    }

                    foreach (ListItem item in chk106.Items)
                    {
                        if (item.Selected)
                        {
                            try
                            {
                                string sMeetingTimeShow = item.Text.ToString().Trim();

                                bool nSuccess = IsSave(sMeetingTimeShow, item.Value);

                                if (nSuccess == true)
                                {
                                    nCount = nCount + 1;
                                }

                            }

                            catch (Exception ex)
                            {

                            }
                        }
                    }

                    foreach (ListItem item in chk107.Items)
                    {
                        if (item.Selected)
                        {
                            try
                            {
                                string sMeetingTimeShow = item.Text.ToString().Trim();

                                bool nSuccess = IsSave(sMeetingTimeShow, item.Value);

                                if (nSuccess == true)
                                {
                                    nCount = nCount + 1;
                                }

                            }

                            catch (Exception ex)
                            {

                            }
                        }

                    }

                    foreach (ListItem item in chk108.Items)
                    {
                        if (item.Selected)
                        {
                            try
                            {
                                string sMeetingTimeShow = item.Text.ToString().Trim();

                                bool nSuccess = IsSave(sMeetingTimeShow, item.Value);

                                if (nSuccess == true)
                                {
                                    nCount = nCount + 1;
                                }

                            }

                            catch (Exception ex)
                            {

                            }
                        }
                    }



                    if (nCount > 0)
                    {
                        ClearCheckbox();
                        Utility.DisplayMsg("Calendar Schedule Saved Successfully!", this);
                    }
                    else
                    {
                        Utility.DisplayMsg("Calendar Schedule not Saved!", this);
                    }
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
        
        private bool IsSave(string sText= "", string sValue = "")
        {
            bool bSuccess = false;

            try
            {
                int nCount = 0;
                
                CalendarSchedule obj = new CalendarSchedule();


                DateTime dDate = DateTime.Now.Date;
                try
                {
                    obj.MeetingDate = Convert.ToDateTime(txtDate.Text.ToString()).Date;
                }
                catch (Exception ex)
                {
                    obj.MeetingDate = dDate;
                }

                DateTime dMeetingDate = Convert.ToDateTime(obj.MeetingDate).Date;

                string sMeetingTimeShow = sText;

                string sSQL = "SELECT top 1 *  FROM CalendarEntry  where UserEmail='" + lblUserEmail.InnerText.ToString() + "' and MeetingDate = '" + dMeetingDate.ToString("yyyy-MM-dd") + "' and MeetingStartTimeShow = '" + sMeetingTimeShow + "' and IsAvailable = 1 order by GMTTimeStart";
                DataTable dtResult = SqlToTbl(sSQL);

                if (dtResult != null && dtResult.Rows.Count > 0)
                {
                    obj.MeetingId = Convert.ToInt64(dtResult.Rows[0]["Id"].ToString());
                    obj.TimeZoneDifference = Convert.ToInt16(dtResult.Rows[0]["TimeZoneDifference"].ToString());
                    obj.Timezone = dtResult.Rows[0]["Timezone"].ToString();
                    obj.Duration = Convert.ToInt16(dtResult.Rows[0]["Duration"].ToString());
                }
                else
                {
                    return false;
                }

                obj.UserName = lblUserName.InnerText.ToString();
                obj.UserEmail = lblUserEmail.InnerText.ToString();
                obj.UserId = Session["UserId"].ToString();

                obj.ToUserFirstName = txtFName.Text.ToString().Trim();
                obj.ToUserLastName = txtLName.Text.ToString().Trim();
                obj.ToUserPhone = txtNumber.Text.ToString().Trim();
                obj.ToUserEmail = txtEmail.Text.ToString().Trim();
                obj.ToUserCompany = txtCompany.Text.ToString().Trim();
                obj.Notes = txtNotes.Text.ToString().Trim();

                


                DateTime dMeetingTimeStart = Convert.ToDateTime(dMeetingDate.ToString("yyyy-MM-dd") + " " + sValue);

                DateTime dMeetingTimeEnd = dMeetingTimeStart.AddMinutes(Convert.ToInt16(obj.Duration));

                DateTime dMeetingGMTStart = dMeetingTimeStart.AddHours(Convert.ToInt16(obj.TimeZoneDifference));
                DateTime dMeetingGMTEnd = dMeetingTimeEnd.AddHours(Convert.ToInt16(obj.TimeZoneDifference));

                obj.MeetingStartTimeShow = sMeetingTimeShow;
                obj.MeetingStartTime = dMeetingTimeStart.ToString();
                obj.MeetingEndTime = dMeetingTimeEnd.ToString();
                obj.GMTTimeStart = dMeetingGMTStart;
                obj.GMTTimeEnd = dMeetingGMTEnd;
                obj.IsBooked = 1;

                string sSQL2 = "SELECT *  FROM CalendarSchedule  where UserEmail='" + obj.UserEmail.ToString() + "' and ToUserEmail='" + obj.ToUserEmail.ToString() + "' and MeetingDate = '" + dMeetingDate.ToString("yyyy-MM-dd") + "' and MeetingStartTimeShow = '" + sMeetingTimeShow + "' and IsBooked = 1 order by GMTTimeStart";
                DataTable dtResult2 = SqlToTbl(sSQL2);

                if (dtResult2 != null && dtResult2.Rows.Count <= 0)
                {
                    if (new CalendarScheduleDA(true, false).Insert(obj))
                    {
                        
                    }
                }

                try
                {
                    if (SendEmail(obj))
                    {
                        nCount = nCount + 1;
                        bSuccess = true;
                    }
                }
                catch (Exception ex)
                {

                }

               

            }
            catch (Exception ex)
            {

            }

            return bSuccess;
        }
        private void ClearCheckbox()
        {
            chk101.SelectedValue = null;
            chk102.SelectedValue = null;
            chk103.SelectedValue = null;
            chk104.SelectedValue = null;
            chk105.SelectedValue = null;
            chk106.SelectedValue = null;
            chk107.SelectedValue = null;
            chk108.SelectedValue = null;

           

        }
        private void FillCalendarEntry()
        {
            chk101.SelectedValue = null;
            chk102.SelectedValue = null;
            chk103.SelectedValue = null;
            chk104.SelectedValue = null;
            chk105.SelectedValue = null;
            chk106.SelectedValue = null;
            chk107.SelectedValue = null;
            chk108.SelectedValue = null;

          
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
                    string nDuration = "30";
                    nDuration = dtResult.Rows[0]["Duration"].ToString();
                    string nTimezone = "5";
                    nTimezone = dtResult.Rows[0]["TimeZoneDifference"].ToString();

                    spanTimezone.InnerHtml =  dtResult.Rows[0]["Timezone"].ToString();

                    foreach (DataRow dr in dtResult.Rows)
                    {

                        if (dr["MeetingStartTimeShow"] != null)
                        {
                            


                            //if (dr["MeetingStartTimeShow"].ToString() == "00:00 am")
                            //{
                            //    chk101.Items[0].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk101.Items[0].Enabled = false;
                            //}


                            //if (dr["MeetingStartTimeShow"].ToString() == "00:15 am")
                            //{
                            //    chk101.Items[1].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk101.Items[1].Enabled = false;
                            //}


                            //if (dr["MeetingStartTimeShow"].ToString() == "00:30 am")
                            //{
                            //    chk101.Items[2].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk101.Items[2].Enabled = false;
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "00:45 am")
                            //{
                            //    chk101.Items[3].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk101.Items[3].Enabled = false;
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "01:00 am")
                            //{
                            //   // chk101.Items[4].Selected = true;
                            //    chk101.Items[4].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk101.Items[4].Enabled = false;
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "01:15 am")
                            //{
                            //    chk101.Items[5].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk101.Items[5].Enabled = false;
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "01:30 am")
                            //{
                            //    chk101.Items[6].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk101.Items[6].Enabled = false;
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "01:45 am")
                            //{
                            //    chk101.Items[7].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk101.Items[7].Enabled = false;
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "02:00 am")
                            //{
                            //    chk101.Items[8].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk101.Items[8].Enabled = false;
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "02:15 am")
                            //{
                            //    chk101.Items[9].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk101.Items[9].Enabled = false;
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "02:30 am")
                            //{
                            //    chk101.Items[10].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk101.Items[10].Enabled = false;
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "02:45 am")
                            //{
                            //    chk101.Items[11].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk101.Items[11].Enabled = false;
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "03:00 am")
                            //{
                            //    chk102.Items[0].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk102.Items[0].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "03:15 am")
                            //{
                            //    chk102.Items[1].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk102.Items[1].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "03:30 am")
                            //{
                            //    chk102.Items[2].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk102.Items[2].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "03:45 am")
                            //{
                            //    chk102.Items[3].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk102.Items[3].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "04:00 am")
                            //{
                            //    chk102.Items[4].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk102.Items[4].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "04:15 am")
                            //{
                            //    chk102.Items[5].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk102.Items[5].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "04:30 am")
                            //{
                            //    chk102.Items[6].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk102.Items[6].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "04:45 am")
                            //{
                            //    chk102.Items[7].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk102.Items[7].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "05:00 am")
                            //{
                            //    chk102.Items[8].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk102.Items[8].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "05:15 am")
                            //{
                            //    chk102.Items[9].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk102.Items[9].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "05:30 am")
                            //{
                            //    chk102.Items[10].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk102.Items[10].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "05:45 am")
                            //{
                            //    chk102.Items[11].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk102.Items[11].Attributes.Add("style", "Display:none;");
                            //}


                            //if (dr["MeetingStartTimeShow"].ToString() == "06:00 am")
                            //{
                            //    chk103.Items[0].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk103.Items[0].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "06:15 am")
                            //{
                            //    chk103.Items[1].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk103.Items[1].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "06:30 am")
                            //{
                            //    chk103.Items[2].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk103.Items[2].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "06:45 am")
                            //{
                            //    chk103.Items[3].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk103.Items[3].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "07:00 am")
                            //{
                            //    chk103.Items[4].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk103.Items[4].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "07:15 am")
                            //{
                            //    chk103.Items[5].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk103.Items[5].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "07:30 am")
                            //{
                            //    chk103.Items[6].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk103.Items[6].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "07:45 am")
                            //{
                            //    chk103.Items[7].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk103.Items[7].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "08:00 am")
                            //{
                            //    chk103.Items[8].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk103.Items[8].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "08:15 am")
                            //{
                            //    chk103.Items[9].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk103.Items[9].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "08:30 am")
                            //{
                            //    chk103.Items[10].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk103.Items[10].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "08:45 am")
                            //{
                            //    chk103.Items[11].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk103.Items[11].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "09:00 am")
                            //{
                            //    chk104.Items[0].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk104.Items[0].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "09:15 am")
                            //{
                            //    chk104.Items[1].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk104.Items[1].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "09:30 am")
                            //{
                            //    chk104.Items[2].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk104.Items[2].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "09:45 am")
                            //{
                            //    chk104.Items[3].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk104.Items[3].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "10:00 am")
                            //{
                            //    chk104.Items[4].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk104.Items[4].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "10:15 am")
                            //{
                            //    chk104.Items[5].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk104.Items[5].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "10:30 am")
                            //{
                            //    chk104.Items[6].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk104.Items[6].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "10:45 am")
                            //{
                            //    chk104.Items[7].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk104.Items[7].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "11:00 am")
                            //{
                            //    chk104.Items[8].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk104.Items[8].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "11:15 am")
                            //{
                            //    chk104.Items[9].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk104.Items[9].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "11:30 am")
                            //{
                            //    chk104.Items[10].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk104.Items[10].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "11:45 am")
                            //{
                            //    chk104.Items[11].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk104.Items[11].Attributes.Add("style", "Display:none;");
                            //}


                            //if (dr["MeetingStartTimeShow"].ToString() == "12:00 pm")
                            //{
                            //    chk105.Items[0].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk105.Items[0].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "12:15 pm")
                            //{
                            //    chk105.Items[1].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk105.Items[1].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "12:30 pm")
                            //{
                            //    chk105.Items[2].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk105.Items[2].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "12:45 pm")
                            //{
                            //    chk105.Items[3].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk105.Items[3].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "01:00 pm")
                            //{
                            //    chk105.Items[4].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk105.Items[4].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "01:15 pm")
                            //{
                            //    chk105.Items[5].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk105.Items[5].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "01:30 pm")
                            //{
                            //    chk105.Items[6].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk105.Items[6].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "01:45 pm")
                            //{
                            //    chk105.Items[7].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk105.Items[7].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "02:00 pm")
                            //{
                            //    chk105.Items[8].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk105.Items[8].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "02:15 pm")
                            //{
                            //    chk105.Items[9].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk105.Items[9].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "02:30 pm")
                            //{
                            //    chk105.Items[10].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk105.Items[10].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "02:45 pm")
                            //{
                            //    chk105.Items[11].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk105.Items[11].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "03:00 pm")
                            //{
                            //    chk106.Items[0].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk106.Items[0].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "03:15 pm")
                            //{
                            //    chk106.Items[1].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk106.Items[1].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "03:30 pm")
                            //{
                            //    chk106.Items[2].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk106.Items[2].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "03:45 pm")
                            //{
                            //    chk106.Items[3].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk106.Items[3].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "04:00 pm")
                            //{
                            //    chk106.Items[4].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk106.Items[4].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "04:15 pm")
                            //{
                            //    chk106.Items[5].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk106.Items[5].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "04:30 pm")
                            //{
                            //    chk106.Items[6].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk106.Items[6].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "04:45 pm")
                            //{
                            //    chk106.Items[7].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk106.Items[7].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "05:00 pm")
                            //{
                            //    chk106.Items[8].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk106.Items[8].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "05:15 pm")
                            //{
                            //    chk106.Items[9].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk106.Items[9].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "05:30 pm")
                            //{
                            //    chk106.Items[10].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk106.Items[10].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "05:45 pm")
                            //{
                            //    chk106.Items[11].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk106.Items[11].Attributes.Add("style", "Display:none;");
                            //}


                            //if (dr["MeetingStartTimeShow"].ToString() == "06:00 pm")
                            //{
                            //    chk107.Items[0].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk107.Items[0].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "06:15 pm")
                            //{
                            //    chk107.Items[1].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk107.Items[1].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "06:30 pm")
                            //{
                            //    chk107.Items[2].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk107.Items[2].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "06:45 pm")
                            //{
                            //    chk107.Items[3].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk107.Items[3].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "07:00 pm")
                            //{
                            //    chk107.Items[4].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk107.Items[4].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "07:15 pm")
                            //{
                            //    chk107.Items[5].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk107.Items[5].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "07:30 pm")
                            //{
                            //    chk107.Items[6].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk107.Items[6].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "07:45 pm")
                            //{
                            //    chk107.Items[7].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk107.Items[7].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "08:00 pm")
                            //{
                            //    chk107.Items[8].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk107.Items[8].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "08:15 pm")
                            //{
                            //    chk107.Items[9].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk107.Items[9].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "08:30 pm")
                            //{
                            //    chk107.Items[10].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk107.Items[10].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "08:45 pm")
                            //{
                            //    chk107.Items[11].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk107.Items[11].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "09:00 pm")
                            //{
                            //    chk108.Items[0].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk108.Items[0].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "09:15 pm")
                            //{
                            //    chk108.Items[1].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk108.Items[1].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "09:30 pm")
                            //{
                            //    chk108.Items[2].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk108.Items[2].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "09:45 pm")
                            //{
                            //    chk108.Items[3].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk108.Items[3].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "10:00 pm")
                            //{
                            //    chk108.Items[4].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk108.Items[4].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "10:15 pm")
                            //{
                            //    chk108.Items[5].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk108.Items[5].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "10:30 pm")
                            //{
                            //    chk108.Items[6].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk108.Items[6].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "10:45 pm")
                            //{
                            //    chk108.Items[7].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk108.Items[7].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "11:00 pm")
                            //{
                            //    chk108.Items[8].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk108.Items[8].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "11:15 pm")
                            //{
                            //    chk108.Items[9].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk108.Items[9].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "11:30 pm")
                            //{
                            //    chk108.Items[10].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk108.Items[10].Attributes.Add("style", "Display:none;");
                            //}

                            //if (dr["MeetingStartTimeShow"].ToString() == "11:45 pm")
                            //{
                            //    chk108.Items[11].Enabled = true;
                            //}
                            //else
                            //{
                            //    chk108.Items[11].Attributes.Add("style", "Display:none;");
                            //}

                            if (dr["MeetingStartTimeShow"].ToString() == "00:00 am")
                            {
                                chk101.Items[0].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "00:15 am")
                            {
                                chk101.Items[1].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "00:30 am")
                            {
                                chk101.Items[2].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "00:45 am")
                            {
                                chk101.Items[3].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "01:00 am")
                            {
                                chk101.Items[4].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "01:15 am")
                            {
                                chk101.Items[5].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "01:30 am")
                            {
                                chk101.Items[6].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "01:45 am")
                            {
                                chk101.Items[7].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "02:00 am")
                            {
                                chk101.Items[8].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "02:15 am")
                            {
                                chk101.Items[9].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "02:30 am")
                            {
                                chk101.Items[10].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "02:45 am")
                            {
                                chk101.Items[11].Selected = true;
                            }

                            if (dr["MeetingStartTimeShow"].ToString() == "03:00 am")
                            {
                                chk102.Items[0].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "03:15 am")
                            {
                                chk102.Items[1].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "03:30 am")
                            {
                                chk102.Items[2].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "03:45 am")
                            {
                                chk102.Items[3].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "04:00 am")
                            {
                                chk102.Items[4].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "04:15 am")
                            {
                                chk102.Items[5].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "04:30 am")
                            {
                                chk102.Items[6].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "04:45 am")
                            {
                                chk102.Items[7].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "05:00 am")
                            {
                                chk102.Items[8].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "05:15 am")
                            {
                                chk102.Items[9].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "05:30 am")
                            {
                                chk102.Items[10].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "05:45 am")
                            {
                                chk102.Items[11].Selected = true;
                            }


                            if (dr["MeetingStartTimeShow"].ToString() == "06:00 am")
                            {
                                chk103.Items[0].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "06:15 am")
                            {
                                chk103.Items[1].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "06:30 am")
                            {
                                chk103.Items[2].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "06:45 am")
                            {
                                chk103.Items[3].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "07:00 am")
                            {
                                chk103.Items[4].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "07:15 am")
                            {
                                chk103.Items[5].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "07:30 am")
                            {
                                chk103.Items[6].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "07:45 am")
                            {
                                chk103.Items[7].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "08:00 am")
                            {
                                chk103.Items[8].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "08:15 am")
                            {
                                chk103.Items[9].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "08:30 am")
                            {
                                chk103.Items[10].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "08:45 am")
                            {
                                chk103.Items[11].Selected = true;
                            }

                            if (dr["MeetingStartTimeShow"].ToString() == "09:00 am")
                            {
                                chk104.Items[0].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "09:15 am")
                            {
                                chk104.Items[1].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "09:30 am")
                            {
                                chk104.Items[2].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "09:45 am")
                            {
                                chk104.Items[3].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "10:00 am")
                            {
                                chk104.Items[4].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "10:15 am")
                            {
                                chk104.Items[5].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "10:30 am")
                            {
                                chk104.Items[6].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "10:45 am")
                            {
                                chk104.Items[7].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "11:00 am")
                            {
                                chk104.Items[8].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "11:15 am")
                            {
                                chk104.Items[9].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "11:30 am")
                            {
                                chk104.Items[10].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "11:45 am")
                            {
                                chk104.Items[11].Selected = true;
                            }


                            if (dr["MeetingStartTimeShow"].ToString() == "12:00 pm")
                            {
                                chk105.Items[0].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "12:15 pm")
                            {
                                chk105.Items[1].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "12:30 pm")
                            {
                                chk105.Items[2].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "12:45 pm")
                            {
                                chk105.Items[3].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "01:00 pm")
                            {
                                chk105.Items[4].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "01:15 pm")
                            {
                                chk105.Items[5].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "01:30 pm")
                            {
                                chk105.Items[6].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "01:45 pm")
                            {
                                chk105.Items[7].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "02:00 pm")
                            {
                                chk105.Items[8].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "02:15 pm")
                            {
                                chk105.Items[9].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "02:30 pm")
                            {
                                chk105.Items[10].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "02:45 pm")
                            {
                                chk105.Items[11].Selected = true;
                            }

                            if (dr["MeetingStartTimeShow"].ToString() == "03:00 pm")
                            {
                                chk106.Items[0].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "03:15 pm")
                            {
                                chk106.Items[1].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "03:30 pm")
                            {
                                chk106.Items[2].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "03:45 pm")
                            {
                                chk106.Items[3].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "04:00 pm")
                            {
                                chk106.Items[4].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "04:15 pm")
                            {
                                chk106.Items[5].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "04:30 pm")
                            {
                                chk106.Items[6].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "04:45 pm")
                            {
                                chk106.Items[7].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "05:00 pm")
                            {
                                chk106.Items[8].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "05:15 pm")
                            {
                                chk106.Items[9].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "05:30 pm")
                            {
                                chk106.Items[10].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "05:45 pm")
                            {
                                chk106.Items[11].Selected = true;
                            }


                            if (dr["MeetingStartTimeShow"].ToString() == "06:00 pm")
                            {
                                chk107.Items[0].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "06:15 pm")
                            {
                                chk107.Items[1].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "06:30 pm")
                            {
                                chk107.Items[2].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "06:45 pm")
                            {
                                chk107.Items[3].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "07:00 pm")
                            {
                                chk107.Items[4].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "07:15 pm")
                            {
                                chk107.Items[5].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "07:30 pm")
                            {
                                chk107.Items[6].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "07:45 pm")
                            {
                                chk107.Items[7].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "08:00 pm")
                            {
                                chk107.Items[8].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "08:15 pm")
                            {
                                chk107.Items[9].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "08:30 pm")
                            {
                                chk107.Items[10].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "08:45 pm")
                            {
                                chk107.Items[11].Selected = true;
                            }

                            if (dr["MeetingStartTimeShow"].ToString() == "09:00 pm")
                            {
                                chk108.Items[0].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "09:15 pm")
                            {
                                chk108.Items[1].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "09:30 pm")
                            {
                                chk108.Items[2].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "09:45 pm")
                            {
                                chk108.Items[3].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "10:00 pm")
                            {
                                chk108.Items[4].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "10:15 pm")
                            {
                                chk108.Items[5].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "10:30 pm")
                            {
                                chk108.Items[6].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "10:45 pm")
                            {
                                chk108.Items[7].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "11:00 pm")
                            {
                                chk108.Items[8].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "11:15 pm")
                            {
                                chk108.Items[9].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "11:30 pm")
                            {
                                chk108.Items[10].Selected = true;
                            }
                            else if (dr["MeetingStartTimeShow"].ToString() == "11:45 pm")
                            {
                                chk108.Items[11].Selected = true;
                            }

                        }
                    }
                }
            }
            catch (Exception ex)
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

              // from_address = "aftab@etag365.com";

             //   to_address = "aftabudduza@gmail.com";

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
                objMailMessage.Body =this.EmailHtml(obj).ToString();          

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

            if (obj.TimeZoneDifference  == 5)
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

    }
}