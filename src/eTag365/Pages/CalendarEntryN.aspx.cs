using eTag365.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using TagService.BO;
using TagService.DA;

namespace eTag365.Pages
{
    public partial class CalendarEntryN : System.Web.UI.Page
    {
        public string errStr = String.Empty;
        public string sUrl = string.Empty;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session["Phone"] = null;
                Session["UserType"] = null;
                Session["objUser"] = null;
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
                            txtLink.Text = "http://etag365.net/calendar-scheduler?UId=" + objTemp.Serial;

                            FillCalendarEntry();
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
        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            int nCount = 0;
            CalendarEntry obj = new CalendarEntry();
            obj.UserName = lblUserName.InnerText.ToString();
            obj.UserEmail = lblUserEmail.InnerText.ToString();
            obj.UserId = Session["UserId"].ToString();
            obj.UserCode = Session["UserSerial"].ToString();
            obj.IsAvailable = 1;
            obj.CreatedBy = obj.UserId;
            obj.CreatedDate = DateTime.Now;

            if (rdoLength.Items[0].Selected == true)
            {
                obj.Duration = 30;
            }
            else if (rdoTimezone.Items[1].Selected == true)
            {
                obj.Duration = 60;
            }
            else
            {
                obj.Duration = 30;
            }

            if (rdoTimezone.Items[0].Selected == true)
            {
                obj.TimeZoneDifference = 5;
                obj.Timezone = "Eastern";
            }
            else if (rdoTimezone.Items[1].Selected == true)
            {
                obj.TimeZoneDifference = 6;
                obj.Timezone = "Central";
            }
            else if(rdoTimezone.Items[2].Selected == true)
            {
                obj.TimeZoneDifference = 7;
                obj.Timezone = "Mountain";
            }
            else if (rdoTimezone.Items[3].Selected == true)
            {
                obj.TimeZoneDifference = 8;
                obj.Timezone = "Pacific";
            }
            else
            {
                obj.TimeZoneDifference = 5;
                obj.Timezone = "Eastern";
            }

           
            DateTime dDate = DateTime.Now.Date;
            try
            {
                obj.MeetingDate = Convert.ToDateTime(txtDate.Text.ToString()).Date;
            }
            catch(Exception ex)
            {
                obj.MeetingDate = dDate;
            }

            DateTime dMeetingDate = Convert.ToDateTime(obj.MeetingDate).Date;
            string message = "";
            string[] spamArray = null;

            foreach (ListItem item in chk101.Items)
            {
                if (item.Selected)
                {
                    try
                    {
                        string sMeetingTimeShow = item.Text;
                        DateTime dMeetingTimeStart = Convert.ToDateTime(dMeetingDate.ToString("yyyy-MM-dd") + " " + item.Value);

                        DateTime dMeetingTimeEnd = dMeetingTimeStart.AddMinutes(Convert.ToInt16(obj.Duration));

                        DateTime dMeetingGMTStart = dMeetingTimeStart.AddHours(Convert.ToInt16(obj.TimeZoneDifference));
                        DateTime dMeetingGMTEnd = dMeetingTimeEnd.AddHours(Convert.ToInt16(obj.TimeZoneDifference));

                        obj.MeetingStartTimeShow = sMeetingTimeShow;
                        obj.MeetingStartTime = dMeetingTimeStart.ToString();
                        obj.MeetingEndTime = dMeetingTimeEnd.ToString();
                        obj.GMTTimeStart = dMeetingGMTStart;
                        obj.GMTTimeEnd = dMeetingGMTEnd;

                        if (new CalendarEntryDA(true, false).Insert(obj))
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
                        string sMeetingTimeShow = item.Text;
                        DateTime dMeetingTimeStart = Convert.ToDateTime(dMeetingDate.ToString("yyyy-MM-dd") + " " + item.Value);

                        DateTime dMeetingTimeEnd = dMeetingTimeStart.AddMinutes(Convert.ToInt16(obj.Duration));

                        DateTime dMeetingGMTStart = dMeetingTimeStart.AddHours(Convert.ToInt16(obj.TimeZoneDifference));
                        DateTime dMeetingGMTEnd = dMeetingTimeEnd.AddHours(Convert.ToInt16(obj.TimeZoneDifference));

                        obj.MeetingStartTimeShow = sMeetingTimeShow;
                        obj.MeetingStartTime = dMeetingTimeStart.ToString();
                        obj.MeetingEndTime = dMeetingTimeEnd.ToString();
                        obj.GMTTimeStart = dMeetingGMTStart;
                        obj.GMTTimeEnd = dMeetingGMTEnd;

                        if (new CalendarEntryDA(true, false).Insert(obj))
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
                        string sMeetingTimeShow = item.Text;
                        DateTime dMeetingTimeStart = Convert.ToDateTime(dMeetingDate.ToString("yyyy-MM-dd") + " " + item.Value);

                        DateTime dMeetingTimeEnd = dMeetingTimeStart.AddMinutes(Convert.ToInt16(obj.Duration));

                        DateTime dMeetingGMTStart = dMeetingTimeStart.AddHours(Convert.ToInt16(obj.TimeZoneDifference));
                        DateTime dMeetingGMTEnd = dMeetingTimeEnd.AddHours(Convert.ToInt16(obj.TimeZoneDifference));

                        obj.MeetingStartTimeShow = sMeetingTimeShow;
                        obj.MeetingStartTime = dMeetingTimeStart.ToString();
                        obj.MeetingEndTime = dMeetingTimeEnd.ToString();
                        obj.GMTTimeStart = dMeetingGMTStart;
                        obj.GMTTimeEnd = dMeetingGMTEnd;

                        if (new CalendarEntryDA(true, false).Insert(obj))
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
                        string sMeetingTimeShow = item.Text;
                        DateTime dMeetingTimeStart = Convert.ToDateTime(dMeetingDate.ToString("yyyy-MM-dd") + " " + item.Value);

                        DateTime dMeetingTimeEnd = dMeetingTimeStart.AddMinutes(Convert.ToInt16(obj.Duration));

                        DateTime dMeetingGMTStart = dMeetingTimeStart.AddHours(Convert.ToInt16(obj.TimeZoneDifference));
                        DateTime dMeetingGMTEnd = dMeetingTimeEnd.AddHours(Convert.ToInt16(obj.TimeZoneDifference));

                        obj.MeetingStartTimeShow = sMeetingTimeShow;
                        obj.MeetingStartTime = dMeetingTimeStart.ToString();
                        obj.MeetingEndTime = dMeetingTimeEnd.ToString();
                        obj.GMTTimeStart = dMeetingGMTStart;
                        obj.GMTTimeEnd = dMeetingGMTEnd;

                        if (new CalendarEntryDA(true, false).Insert(obj))
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
                        string sMeetingTimeShow = item.Text;
                        DateTime dMeetingTimeStart = Convert.ToDateTime(dMeetingDate.ToString("yyyy-MM-dd") + " " + item.Value);

                        DateTime dMeetingTimeEnd = dMeetingTimeStart.AddMinutes(Convert.ToInt16(obj.Duration));

                        DateTime dMeetingGMTStart = dMeetingTimeStart.AddHours(Convert.ToInt16(obj.TimeZoneDifference));
                        DateTime dMeetingGMTEnd = dMeetingTimeEnd.AddHours(Convert.ToInt16(obj.TimeZoneDifference));

                        obj.MeetingStartTimeShow = sMeetingTimeShow;
                        obj.MeetingStartTime = dMeetingTimeStart.ToString();
                        obj.MeetingEndTime = dMeetingTimeEnd.ToString();
                        obj.GMTTimeStart = dMeetingGMTStart;
                        obj.GMTTimeEnd = dMeetingGMTEnd;

                        if (new CalendarEntryDA(true, false).Insert(obj))
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
                        string sMeetingTimeShow = item.Text;
                        DateTime dMeetingTimeStart = Convert.ToDateTime(dMeetingDate.ToString("yyyy-MM-dd") + " " + item.Value);

                        DateTime dMeetingTimeEnd = dMeetingTimeStart.AddMinutes(Convert.ToInt16(obj.Duration));

                        DateTime dMeetingGMTStart = dMeetingTimeStart.AddHours(Convert.ToInt16(obj.TimeZoneDifference));
                        DateTime dMeetingGMTEnd = dMeetingTimeEnd.AddHours(Convert.ToInt16(obj.TimeZoneDifference));

                        obj.MeetingStartTimeShow = sMeetingTimeShow;
                        obj.MeetingStartTime = dMeetingTimeStart.ToString();
                        obj.MeetingEndTime = dMeetingTimeEnd.ToString();
                        obj.GMTTimeStart = dMeetingGMTStart;
                        obj.GMTTimeEnd = dMeetingGMTEnd;

                        if (new CalendarEntryDA(true, false).Insert(obj))
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
                        string sMeetingTimeShow = item.Text;
                        DateTime dMeetingTimeStart = Convert.ToDateTime(dMeetingDate.ToString("yyyy-MM-dd") + " " + item.Value);

                        DateTime dMeetingTimeEnd = dMeetingTimeStart.AddMinutes(Convert.ToInt16(obj.Duration));

                        DateTime dMeetingGMTStart = dMeetingTimeStart.AddHours(Convert.ToInt16(obj.TimeZoneDifference));
                        DateTime dMeetingGMTEnd = dMeetingTimeEnd.AddHours(Convert.ToInt16(obj.TimeZoneDifference));

                        obj.MeetingStartTimeShow = sMeetingTimeShow;
                        obj.MeetingStartTime = dMeetingTimeStart.ToString();
                        obj.MeetingEndTime = dMeetingTimeEnd.ToString();
                        obj.GMTTimeStart = dMeetingGMTStart;
                        obj.GMTTimeEnd = dMeetingGMTEnd;

                        if (new CalendarEntryDA(true, false).Insert(obj))
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
                        string sMeetingTimeShow = item.Text;
                        DateTime dMeetingTimeStart = Convert.ToDateTime(dMeetingDate.ToString("yyyy-MM-dd") + " " + item.Value);

                        DateTime dMeetingTimeEnd = dMeetingTimeStart.AddMinutes(Convert.ToInt16(obj.Duration));

                        DateTime dMeetingGMTStart = dMeetingTimeStart.AddHours(Convert.ToInt16(obj.TimeZoneDifference));
                        DateTime dMeetingGMTEnd = dMeetingTimeEnd.AddHours(Convert.ToInt16(obj.TimeZoneDifference));

                        obj.MeetingStartTimeShow = sMeetingTimeShow;
                        obj.MeetingStartTime = dMeetingTimeStart.ToString();
                        obj.MeetingEndTime = dMeetingTimeEnd.ToString();
                        obj.GMTTimeStart = dMeetingGMTStart;
                        obj.GMTTimeEnd = dMeetingGMTEnd;

                        if (new CalendarEntryDA(true, false).Insert(obj))
                        {
                            nCount = nCount + 1;
                        }
                    }

                    catch (Exception ex)
                    {

                    }
                }
            }

           

            if (nCount  > 0)
            {
                ClearCheckbox();
                Utility.DisplayMsg("Calendar Entry Saved Successfully!", this);
            }
            else
            {
                Utility.DisplayMsg("Calendar Entry not Saved!", this);
            }

        }
        protected void btnClose_Click(object sender, EventArgs e)
        {
            ClearCheckbox();
        }
        protected void btnBack_Click(object sender, EventArgs e)
        {
            ClearCheckbox();
            Response.Redirect("/home");
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

            rdoLength.Items[0].Selected = true;
            rdoTimezone.Items[0].Selected = true;

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

                    if (nDuration == "60")
                    {
                        rdoLength.Items[1].Selected = true;
                    }
                    else
                    {
                        rdoLength.Items[0].Selected = true;
                    }

                    if (nTimezone == "5")
                    {
                        rdoTimezone.Items[0].Selected = true;
                    }
                    else if (nTimezone == "6")
                    {
                        rdoTimezone.Items[1].Selected = true;
                    }
                    else if (nTimezone == "7")
                    {
                        rdoTimezone.Items[2].Selected = true;
                    }
                    else if (nTimezone == "8")
                    {
                        rdoTimezone.Items[3].Selected = true;
                    }
                    else
                    {
                        rdoTimezone.Items[0].Selected = true;
                    }

                    foreach (DataRow dr in dtResult.Rows)
                    {

                        if (dr["MeetingStartTimeShow"] != null)
                        {
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
            FillCalendarEntry();
        }
    }
}