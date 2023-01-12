using eTagService.Enums;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TagService.BO;
using TagService.DA;

namespace eTag365.Pages.Admin
{
    public partial class EmailScheduler : System.Web.UI.Page
    {
        public string conStr = System.Configuration.ConfigurationManager.ConnectionStrings["eTagDB"].ConnectionString;
        public string sUserId = "";
        public string errStr = string.Empty;
        public string sUserPhone = "";

        #region Events

        protected void Page_Load(object sender, EventArgs e)
        {            
            if (!IsPostBack)
            {
                Session["AddScheduleId"] = null;
                Session["ContactList"] = null;
                string sessionid = System.Web.HttpContext.Current.Session.SessionID;
                if (!string.IsNullOrEmpty(sessionid))
                {
                    int userid = Utility.IntegerData("SELECT TOP 1 UserId FROM UserLog_Data Where SessionId='" + sessionid + "' Order By LogId DESC");
                    if (userid > 0)
                    {
                        UserProfile obj = new UserProfileDA().GetUserByUserID(userid);
                        if (obj != null)
                        {
                            Session["Phone"] = obj.Phone;
                            Session["UserId"] = obj.Id;
                            sUserId = obj.Id.ToString();
                            sUserPhone = obj.Phone.ToString();
                            hdnFrom.Value = obj.Email;                         
                            
                            FillUsers(obj.Id);
                            FillDays();
                            FillDropdowns();
                         
                            FillTemplateList(sUserId);

                            if (Session["ScheduleToUserId"] != null)
                            {
                                ddlUser.SelectedValue = Session["ScheduleToUserId"].ToString();
                            }

                            if (Session["ScheduleToUser"] != null)
                            {
                               hdnTo.Value = Session["ScheduleToUser"].ToString().Trim();
                            }

                            if (hdnFrom.Value != null && hdnFrom.Value != string.Empty)
                            {
                                FillControls(hdnFrom.Value.ToString().Trim(), hdnTo.Value.ToString().Trim());
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
                else
                {
                    Response.Redirect(Utility.WebUrl + "/login");
                }
            }
        }       
        protected void ddlUser_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                string sToUser = ddlUser.SelectedValue != "-1" ? ddlUser.SelectedValue : "";

                if (sToUser != "")
                {
                    ContactInformation obj = new ContactInformationDA().GetbyID(Convert.ToInt32(sToUser));
                    if (obj != null)
                    {
                        hdnTo.Value = obj.Email != null ? obj.Email.Trim() : "";
                    }
                    else
                    {
                        hdnTo.Value = "";
                    }
                }
                else
                {
                    hdnTo.Value = "";
                }

              

                string sToUserEmail = (hdnTo.Value != null && hdnTo.Value != string.Empty) ? hdnTo.Value.ToString().Trim() : "";

                string sFromEmail = (hdnFrom.Value != null && hdnFrom.Value != string.Empty) ? hdnFrom.Value.ToString().Trim() : "";

                string sCategory = ddlCategory.SelectedValue != "-1" ? ddlCategory.SelectedValue : "";

                string sType = ddlType.SelectedValue != "-1" ? ddlType.SelectedValue : "";

                if (sFromEmail.Length > 0)
                {
                    FillControlsBySearch(sFromEmail, sToUser, sCategory, sType);
                }                

            }
            catch (Exception ex)
            {

            }
        }

        protected void ddlCategory_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                Session["ContactList"] = null;

                string sCategory = ddlCategory.SelectedValue != "-1" ? ddlCategory.SelectedValue : "";

                string sType = ddlType.SelectedValue != "-1" ? ddlType.SelectedValue : "";
                if (Session["UserId"] != null)
                {
                    FillUsersByCategoryAndType(sCategory, sType, Session["UserId"].ToString());
                }               

                string sFromEmail = (hdnFrom.Value != null && hdnFrom.Value != string.Empty) ? hdnFrom.Value.ToString().Trim() : "";

                string sToUser = ddlUser.SelectedValue != "-1" ? ddlUser.SelectedValue : "";

                if (sToUser != "")
                {
                    ContactInformation obj = new ContactInformationDA().GetbyID(Convert.ToInt32(sToUser));
                    if (obj != null)
                    {
                        hdnTo.Value = obj.Email != null ? obj.Email.Trim() : "";
                    }
                    else
                    {
                        hdnTo.Value = "";
                    }
                }
                else
                {
                    hdnTo.Value = "";
                }
                string sToUserEmail = (hdnTo.Value != null && hdnTo.Value != string.Empty) ? hdnTo.Value.ToString().Trim() : "";

                if (sFromEmail.Length > 0)
                {
                    FillControlsBySearch(sFromEmail, sToUser, sCategory, sType);
                }               

            }
            catch (Exception ex)
            {

            }
        }
        protected void ddlType_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {               

                string sCategory = ddlCategory.SelectedValue != "-1" ? ddlCategory.SelectedValue : "";

                string sType = ddlType.SelectedValue != "-1" ? ddlType.SelectedValue : "";               

                //if (Session["UserId"] != null)
                //{
                //    FillUsersByCategoryAndType(sCategory, sType, Session["UserId"].ToString());
                //}

                string sFromEmail = (hdnFrom.Value != null && hdnFrom.Value != string.Empty) ? hdnFrom.Value.ToString().Trim() : "";

                string sToUser = ddlUser.SelectedValue != "-1" ? ddlUser.SelectedValue : "";

                if (sToUser != "")
                {
                    ContactInformation obj = new ContactInformationDA().GetbyID(Convert.ToInt32(sToUser));
                    if (obj != null)
                    {
                        hdnTo.Value = obj.Email != null ? obj.Email.Trim() : "";
                    }
                    else
                    {
                        hdnTo.Value = "";
                    }
                    //  hdnTo.Value = sToUser != null ? sToUser.Trim() : "";
                }
                else
                {
                    hdnTo.Value = "";
                }
               
                string sToUserEmail = (hdnTo.Value != null && hdnTo.Value != string.Empty) ? hdnTo.Value.ToString().Trim() : "";

                if (sFromEmail.Length > 0)
                {
                    FillControlsBySearch(sFromEmail, sToUser, sCategory, sType);
                }
            }
            catch (Exception ex)
            {

            }
        }
        protected void btnSave33_Click(object sender, EventArgs e)
        {
            errStr = string.Empty;
            errStr = Validate_Control();
            if (errStr.Length <= 0)
            {
                saveSchedule();                        
            }
            else
            {
                Utility.DisplayMsg(errStr.ToString(), this);
            }

        }
        protected void btnBack33_Click(object sender, EventArgs e)
        {
            ClearControls();
            Response.Redirect(Utility.WebUrl + "/home");
        }
        protected void ddlTemplateNo_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                string sTemplateNo = ddlTemplateNo.SelectedValue != "-1" ? ddlTemplateNo.SelectedValue : "0";

                if (sTemplateNo != "0")
                {
                    chkLoop.Visible = true;

                    divDays.Visible = true;
                }
                else
                {
                    chkLoop.Visible = false;

                    divDays.Visible = false;
                }

                //if(Session["Phone"] != null)
                //{
                //    FillCategoryList(sTemplateNo, Session["Phone"].ToString());
                //}
                
            }
            catch (Exception)
            {

            }
        }
        protected void gvContactList_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvContactList.PageIndex = e.NewPageIndex;

            string sToUser = ddlUser.SelectedValue != "-1" ? ddlUser.SelectedValue : "";

            string sToUserEmail = (hdnTo.Value != null && hdnTo.Value != string.Empty) ? hdnTo.Value.ToString().Trim() : "";

            string sFromEmail = (hdnFrom.Value != null && hdnFrom.Value != string.Empty) ? hdnFrom.Value.ToString().Trim() : "";

            string sCategory = ddlCategory.SelectedValue != "-1" ? ddlCategory.SelectedValue : "";

            string sType = ddlType.SelectedValue != "-1" ? ddlType.SelectedValue : "";

            if (sFromEmail.Length > 0)
            {
                FillControlsBySearch(sFromEmail, sToUser, sCategory, sType);
            }

        }
        protected void gvContactList_Sorting(object sender, GridViewSortEventArgs e)
        {
            string sToUser = ddlUser.SelectedValue != "-1" ? ddlUser.SelectedValue : "";

            string sToUserEmail = (hdnTo.Value != null && hdnTo.Value != string.Empty) ? hdnTo.Value.ToString().Trim() : "";

            string sFromEmail = (hdnFrom.Value != null && hdnFrom.Value != string.Empty) ? hdnFrom.Value.ToString().Trim() : "";

            string sCategory = ddlCategory.SelectedValue != "-1" ? ddlCategory.SelectedValue : "";

            string sType = ddlType.SelectedValue != "-1" ? ddlType.SelectedValue : "";

            if (sFromEmail.Length > 0)
            {
                FillControlsBySearch(sFromEmail, sToUser, sCategory, sType);
            }
        }
        protected void btnEdit_Click(object sender, EventArgs e)
        {
            GridViewRow row = ((LinkButton)sender).Parent.Parent as GridViewRow;
            Label hdId = (Label)gvContactList.Rows[row.RowIndex].FindControl("lblEmailScheduleId");

            if (!String.IsNullOrEmpty(hdId.Text))
            {
                //ClearControls();
                FillControlsById(Convert.ToInt32(hdId.Text.ToString()));
            }

        }
        protected void btnDelete_Click(object sender, EventArgs e)
        {
            GridViewRow row = ((LinkButton)sender).Parent.Parent as GridViewRow;
            Label hdId = (Label)gvContactList.Rows[row.RowIndex].FindControl("lblEmailScheduleId");

            if (!String.IsNullOrEmpty(hdId.Text))
            {
                string SQLMail = " delete from emailschedule where  Id = " + hdId.Text.ToString();
                bool bIsDeleted =  Utility.RunCMDMain(SQLMail);

                if(bIsDeleted)
                {
                    string sToUser = ddlUser.SelectedValue != "-1" ? ddlUser.SelectedValue : "";

                    if (hdnFrom.Value != null && hdnFrom.Value != string.Empty)
                    {
                        FillControls(hdnFrom.Value.ToString().Trim(), sToUser);
                    }

                    Utility.DisplayMsg("Email Scheduler deleted successfully!", this);
                }

            }
        }

        protected void btnInactive_Click(object sender, EventArgs e)
        {
            try
            { 
                string sCategory = ddlCategory.SelectedValue != "-1" ? ddlCategory.SelectedValue : "";

                string sType = ddlType.SelectedValue != "-1" ? ddlType.SelectedValue : ""; 

                string sToUser = ddlUser.SelectedValue != "-1" ? ddlUser.SelectedValue : "";

                string sUserId = Session["UserId"] != null ? Session["UserId"].ToString() : "";

                string sFromEmail = (hdnFrom.Value != null && hdnFrom.Value != string.Empty) ? hdnFrom.Value.ToString().Trim() : "";

                string sWhere = " ";

                string sWhereContact = " ";

                if ((!string.IsNullOrEmpty(sCategory)) && sCategory != "-1")
                {
                    sWhere += "  and Category = '" + sCategory + "'";

                    sWhereContact += "  and Category = '" + sCategory + "'";
                }

                if ((!string.IsNullOrEmpty(sType)) && sType != "-1")
                {
                    sWhere += "  and Type = '" + sType + "'";

                    sWhereContact += "  and TypeOfContact = '" + sType + "'";
                }

                if ((!string.IsNullOrEmpty(sToUser)) && sToUser != "-1")
                {
                    sWhere += "  and PersonName = '" + sToUser + "'";

                    sWhereContact += "  and Id = '" + sToUser + "'";

                }

                if (sFromEmail.Length > 0)
                {
                    string SQLDelSchedule = " delete from emailschedule where Id > 0  " + sWhere;
                    bool bIsDeleted = Utility.RunCMDMain(SQLDelSchedule);

                    if (bIsDeleted)
                    {
                        if (sUserId.Length > 0)
                        {
                            sWhereContact += "  and UserId = '" + sUserId + "'";
                            string SQL = " update ContactInformation set IsEmailFlow = 0 where Id > 0  " + sWhereContact;
                            Utility.RunCMDMain(SQL);
                        }

                        if (hdnFrom.Value != null && hdnFrom.Value != string.Empty)
                        {
                            FillControls(hdnFrom.Value.ToString().Trim(), sToUser);
                        }

                        Utility.DisplayMsg("Email Scheduler Stopped successfully !!", this);
                    }
                    else
                    {
                        Utility.DisplayMsg("Email Scheduler not Stopped !!", this);
                    }

                }

            }
            catch (Exception ex)
            {

            }
        }

        #endregion

        #region Method        

        private void FillUsers(int nUserId)
        {
            try
            {
                ddlUser.Items.Clear();
                ddlUser.AppendDataBoundItems = true;
                ddlUser.Items.Add(new ListItem("Selected User", "-1"));

                List<ContactInformation> objUsers = null;
                objUsers = new ContactInformationDA().GetAllContactsForSchedulerByUser(nUserId.ToString());

                if (objUsers != null && objUsers.Count > 0)
                {
                    Session["ContactList"] = objUsers;
                    foreach (ContactInformation obj in objUsers)
                    {                       
                        string sName = (obj.FirstName != null ? obj.FirstName.ToString() : "") + " " + (obj.LastName != null ? obj.LastName.ToString() : "");
                        ddlUser.Items.Add(new ListItem(sName, obj.Id.ToString()));
                    }
                }

                ddlUser.DataBind();
            }
            catch (Exception ex)
            {

            }

        }
        private void FillUsersByCategoryAndType(string category, string type, string sUserID)
        {
            try
            {
                ddlUser.Items.Clear();
                ddlUser.AppendDataBoundItems = true;
                ddlUser.Items.Add(new ListItem("Selected User", "-1"));

                List<ContactInformation> objUsers = null;
                objUsers = new ContactInformationDA().GetContactsForScheduler(category, type, sUserID);

                if (objUsers != null && objUsers.Count > 0)
                {
                    Session["ContactList"] = objUsers;
                    foreach (ContactInformation obj in objUsers)
                    {
                        string sName = (obj.FirstName != null ? obj.FirstName.ToString() : "") + " " + (obj.LastName != null ? obj.LastName.ToString() : "");
                        ddlUser.Items.Add(new ListItem(sName, obj.Id.ToString()));
                    }
                }

                ddlUser.DataBind();
            }
            catch (Exception ex)
            {

            }
        }
        private void ClearControls()
        {            
            lblMessageNew.Text = "";           
            btnSave33.Text = "Save";
            chkLoop.Checked = false;
            ddlTemplateNo.SelectedValue = "0";
            divDays.Visible = false;
            chkLoop.Visible = false;

            //FillCategories();
        }
        public string Validate_Control()
        {
            try
            {
                string sWhere = "";
                string sCategory = ddlCategory.SelectedValue != "-1" ? ddlCategory.SelectedValue : "";
                string sType = ddlType.SelectedValue != "-1" ? ddlType.SelectedValue : "";
                string sTemplateNo = ddlTemplateNo.SelectedValue != "-1" ? ddlTemplateNo.SelectedValue : "";

                sWhere += "  and e.Category = '" + sCategory + "' and e.Type = '" + sType + "' and e.TemplateNo = '" + sTemplateNo + "' ";

                if (Session["UserId"] != null && sWhere.Length > 0)
                {
                    string sSQL = " select e.Id  from EmailSetup e where e.UserId = '" + Session["UserId"].ToString() + "' " + sWhere;
                    DataTable dtResult = SqlToTbl(sSQL);

                    if (dtResult != null && dtResult.Rows.Count > 0)
                    {
                    }
                    else
                    {
                        errStr += "Template Setup Not Found. Please change selection and try again !!" + Environment.NewLine;
                    }
                }

                if (ddlUser.SelectedValue == "-1")
                {
                    if (Session["ContactList"] == null)
                    {
                        errStr += "User List is empty. Please change Category selection !!" + Environment.NewLine;
                    }
                }
            }
            catch (Exception e)
            {

            }

            return errStr;
        }
        private EmailSchedule SetData(EmailSchedule obj)
        {
            try
            {
                obj = new EmailSchedule();

                if (Session["AddScheduleId"] != null && Convert.ToInt32(Session["AddScheduleId"]) > 0)
                {
                    obj = new EmailScheduleDA().GetByID(Convert.ToInt32(Session["AddScheduleId"]));
                    obj.Id = Convert.ToInt32(Session["AddScheduleId"].ToString());
                }

                if (Session["AddScheduleId"] != null)
                {
                    obj.UpdatedDate = DateTime.Now;

                    if (Session["UserId"] != null)
                    {
                        UserProfile objTemp = new UserProfileDA().GetUserByUserID(Convert.ToInt32(Session["UserId"].ToString()));
                        if (objTemp != null)
                        {
                            obj.UpdatedBy = objTemp.Phone;
                        }
                    }
                }
                else
                {
                    if (Session["UserId"] != null)
                    {
                        UserProfile objTemp = new UserProfileDA().GetUserByUserID(Convert.ToInt32(Session["UserId"].ToString()));
                        if (objTemp != null)
                        {
                            obj.CreatedBy = objTemp.Phone;
                        }
                    }

                    obj.CreatedDate = DateTime.Now;
                }

               
                if (ddlUser.SelectedValue != "-1")
                {
                    obj.PersonName = ddlUser.SelectedValue.ToString();
                }
                else
                {
                    obj.PersonName = "";
                }

                if (ddlNo.SelectedValue != "-1")
                {
                    obj.Days = ddlNo.SelectedValue.ToString();
                }
                else
                {
                    obj.Days = "";
                }

                if (chkLoop.Checked)
                {
                    obj.IsLoop = true;
                }
                else
                {
                    obj.IsLoop = false;
                }

               
                if (hdnFrom.Value != null && hdnFrom.Value != string.Empty)
                {
                    obj.FromEmail = hdnFrom.Value;
                }
                else
                {
                    obj.FromEmail = "";
                }

                if (hdnTo.Value != null && hdnTo.Value != string.Empty)
                {
                    obj.PersonEmail = hdnTo.Value;
                }
                else
                {
                    obj.PersonEmail = "";
                }

                if (ddlTemplateNo.SelectedValue != "-1")
                {
                    obj.LastEmailNumber = Convert.ToInt16(ddlTemplateNo.SelectedValue.ToString());
                }
                else
                {
                    obj.LastEmailNumber = 0;
                }

                if (ddlCategory.SelectedValue != "-1")
                {
                    obj.Category = ddlCategory.SelectedValue.ToString();
                }
                else
                {
                    obj.Category = "";
                }

                if (ddlType.SelectedValue != "-1")
                {
                    obj.Type = ddlType.SelectedValue.ToString();
                }
                else
                {
                    obj.Type = "";
                }

            }
            catch (Exception ex)
            {
            }


            return obj;
        }
        private void FillControlsById(int nId)
        {
            try
            {
                if (nId > 0)
                {
                    EmailSchedule obj = new EmailScheduleDA().GetByID(nId);
                    if (obj != null)
                    {
                        Session["AddScheduleId"] = obj.Id;

                        if (obj.LastEmailNumber != null && obj.LastEmailNumber.ToString() != string.Empty)
                        {
                            ddlTemplateNo.SelectedValue = obj.LastEmailNumber.ToString();
                        }

                        if (obj.Days != null && obj.Days.ToString() != string.Empty)
                        {
                            ddlNo.SelectedValue = obj.Days.ToString();
                        }

                        if (obj.IsLoop != null && obj.IsLoop.ToString() != string.Empty)
                        {
                            chkLoop.Checked = Convert.ToBoolean(obj.IsLoop);
                        }
                        else
                        {
                            chkLoop.Checked = false;
                        }

                       
                        if (obj.Category != null && obj.Category.ToString() != string.Empty)
                        {
                            ddlCategory.SelectedValue = obj.Category.ToString();
                        }                        

                        btnSave33.Text = "Update";

                        if (obj.PersonName != null && obj.PersonName.ToString() != string.Empty)
                        {
                            ddlUser.SelectedValue = obj.PersonName.ToString();
                        }
                        if (obj.Type != null && obj.Type.ToString() != string.Empty)
                        {
                            ddlType.SelectedValue = obj.Type.ToString();
                        }
                    }
                }
            }
            catch (Exception e)
            {

            }
        }
        private void FillDays()
        {
            try
            {
                for (int i = 1; i <= 30; i++)
                {
                    ddlNo.Items.Add(new ListItem(i.ToString(), i.ToString()));
                }

                ddlNo.DataBind();
                ddlNo.SelectedValue = "1";
            }
            catch (Exception ex)
            {

            }

           
         
        }        
        private void FillTemplateList(string nUserId)
        {
            try
            {
                ddlTemplateNo.Items.Clear();
                ddlTemplateNo.AppendDataBoundItems = true;
                ddlTemplateNo.Items.Add(new ListItem("0", "0"));

                string sSQL = "select isnull(max(cast(TemplateNo as int)),0) TemplateNo from EmailSetup where UserId = '" + nUserId + "'";
                DataTable dtResult = SqlToTbl(sSQL);
                int nMaxNo = 0;

                if (dtResult != null && dtResult.Rows.Count > 0)
                {
                    nMaxNo = (dtResult.Rows[0]["TemplateNo"] != null && dtResult.Rows[0]["TemplateNo"] != DBNull.Value) ? Convert.ToInt32(dtResult.Rows[0]["TemplateNo"].ToString()) : 0;
                   
                }

                if(nMaxNo > 0)
                {
                    for (int i = 1; i <= nMaxNo; i++)
                    {
                        ddlTemplateNo.Items.Add(new ListItem(i.ToString(), i.ToString()));
                    }
                }               

                ddlTemplateNo.DataBind();
                ddlTemplateNo.SelectedValue = "1";

               

                if (nMaxNo > 0)
                {
                    chkLoop.Visible = true;
                    divDays.Visible = true;
                }
                else
                {
                    chkLoop.Visible = false;
                    divDays.Visible = false;
                }

            }
            catch (Exception ex)
            {

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
        private void FillControls(string From, string sTo)
        {
            try
            {
                if (From.Length > 0)
                {
                    string sWhere = " ";
                   
                    if ((!string.IsNullOrEmpty(sTo)) && sTo != "-1")
                    {
                        //sWhere += "  and e.PersonEmail = '" + To + "'";
                        sWhere += "  and e.PersonName = '" + sTo + "'";
                    }

                    string sSQL = " select e.Id, isnull(c.FirstName,'') FirstName, isnull(c.LastName,'') LastName, isnull(e.LastEmailNumber,0) LastEmailNumber, isnull(e.Days,'') Days, isnull(e.Category,'') Category, isnull(e.Type,'') Type from EmailSchedule e left join ContactInformation c on c.Id = e.PersonName where e.FromEmail = '" + From + "' " + sWhere + "   order by isnull(c.LastName,'')+isnull(c.FirstName,''), isnull(e.LastEmailNumber,0), isnull(e.Category,''), isnull(e.Type,'')  ";
                    DataTable dtResult = SqlToTbl(sSQL);

                    gvContactList.DataSource = dtResult;
                    gvContactList.DataBind();
                  
                }
            }
            catch (Exception e)
            {

            }
        }
        private void FillControlsBySearch(string From, string ToUser, string Category, string Type)
        {
            try
            {
                string sWhere = " ";
                if ((!string.IsNullOrEmpty(Category)) && Category != "-1")
                {
                    sWhere += "  and e.Category = '" + Category + "'";
                }               

                if ((!string.IsNullOrEmpty(Type)) && Type != "-1")
                {
                    sWhere += "  and e.Type = '" + Type + "'";
                }

                if ((!string.IsNullOrEmpty(ToUser)) && ToUser != "-1")
                {
                    //sWhere += "  and e.PersonEmail = '" + ToUser + "'";
                    sWhere += "  and e.PersonName = '" + ToUser + "'";
                }

                if (From.Length > 0)
                {
                    //  string sSQL = " select e.Id, isnull(e.LastEmailNumber,0) LastEmailNumber, isnull(e.Days,'') Days, isnull(e.Category,'') Category, isnull(e.Type,'') Type from EmailSchedule e where e.FromEmail = '" + From + "' " + sWhere + "  order by isnull(e.LastEmailNumber,0), isnull(e.Category,''), isnull(e.Type,'')  ";
                    string sSQL = " select e.Id, isnull(c.FirstName,'') FirstName, isnull(c.LastName,'') LastName, isnull(e.LastEmailNumber,0) LastEmailNumber, isnull(e.Days,'') Days, isnull(e.Category,'') Category, isnull(e.Type,'') Type from EmailSchedule e left join ContactInformation c on c.Id = e.PersonName where  e.FromEmail = '" + From + "' " + sWhere + "   order by isnull(c.LastName,'')+isnull(c.FirstName,''), isnull(e.LastEmailNumber,0), isnull(e.Category,''), isnull(e.Type,'')  ";

                    DataTable dtResult = SqlToTbl(sSQL);

                    gvContactList.DataSource = dtResult;
                    gvContactList.DataBind();

                }
            }
            catch (Exception e)
            {

            }
        }       
        private void FillDropdowns()
        {
            List<Child> listContactType = null;
            List<Child> listCategory = null;

            int nUserId = Session["UserId"] != null ? Convert.ToInt32(Session["UserId"].ToString()) : 0;
            if (nUserId > 0)
            {
                listContactType = new ChildDA().GetChildByUserDefinedIDAndUserID(Convert.ToInt32(EnumBasicData.ContactType), nUserId);
                listCategory = new ChildDA().GetChildByUserDefinedIDAndUserID(Convert.ToInt32(EnumBasicData.Category), nUserId);
            }

            try
            {
                ddlType.Items.Clear();
                ddlType.AppendDataBoundItems = true;
                ddlType.Items.Add(new ListItem("N/A", "-1"));
                ddlType.SelectedValue = "-1";
                ddlType.DataSource = listContactType;
                ddlType.DataTextField = "Description";
                ddlType.DataValueField = "Description";
                ddlType.DataBind();

            }
            catch (Exception ex)
            {

            }

            try
            {
                ddlCategory.Items.Clear();
                ddlCategory.AppendDataBoundItems = true;
                ddlCategory.Items.Add(new ListItem("N/A", "-1"));
                ddlCategory.SelectedValue = "-1";
                ddlCategory.DataSource = listCategory;
                ddlCategory.DataTextField = "Description";
                ddlCategory.DataValueField = "Description";
                ddlCategory.DataBind();

            }
            catch (Exception ex)
            {

            }

          
        }
        private void saveSchedule()
        {
            if (ddlUser.SelectedValue != "-1")
            {
                try
                {
                    EmailSchedule objEmailSchedule = new EmailSchedule();
                    objEmailSchedule = SetData(objEmailSchedule);

                    if (Session["AddScheduleId"] == null || Session["AddScheduleId"] == "0")
                    {
                        if (new EmailScheduleDA(true, false).Insert(objEmailSchedule))
                        {
                            ClearControls();
                            if (hdnTo.Value != null && hdnTo.Value != string.Empty)
                            {
                                Session["ScheduleToUserId"] = ddlUser.SelectedValue;
                                Session["ScheduleToUser"] = hdnTo.Value;
                            }
                            string sToUser = ddlUser.SelectedValue != "-1" ? ddlUser.SelectedValue : "";
                            if (hdnFrom.Value != null && hdnFrom.Value != string.Empty)
                            {
                                FillControls(hdnFrom.Value.ToString().Trim(), sToUser);
                            }

                            Utility.DisplayMsg("Email Scheduler saved successfully!", this);

                        }
                        else
                        {
                            lblMessageNew.Text = "Email Scheduler not saved!!";
                            Utility.DisplayMsg("Email Scheduler not saved!", this);
                        }
                    }
                    else
                    {
                        if (new EmailScheduleDA().Update(objEmailSchedule))
                        {
                            Session["AddScheduleId"] = null;
                            ClearControls();
                            if (hdnTo.Value != null && hdnTo.Value != string.Empty)
                            {
                                Session["ScheduleToUserId"] = ddlUser.SelectedValue;
                                Session["ScheduleToUser"] = hdnTo.Value;
                            }
                            string sToUser = ddlUser.SelectedValue != "-1" ? ddlUser.SelectedValue : "";
                            if (hdnFrom.Value != null && hdnFrom.Value != string.Empty)
                            {
                                FillControls(hdnFrom.Value.ToString().Trim(), sToUser);
                            }

                            Utility.DisplayMsg("Email Scheduler updated successfully!", this);
                        }
                        else
                        {
                            Utility.DisplayMsg("Email Scheduler not updated!", this);
                            lblMessageNew.Text = "Email Scheduler not updated!!";
                        }
                    }
                }
                catch (Exception ex1)
                {
                    Utility.DisplayMsg(ex1.Message.ToString(), this);
                }
            }
            else
            {
                string sCategory = ddlCategory.SelectedValue != "-1" ? ddlCategory.SelectedValue : "";
                string sType = ddlType.SelectedValue != "-1" ? ddlType.SelectedValue : "";
                string sTemplate = ddlTemplateNo.SelectedValue != "0" ? ddlTemplateNo.SelectedValue : "0";
                string sDay = ddlNo.SelectedValue != "0" ? ddlNo.SelectedValue : "1";
                string sLoop = chkLoop.Checked ? "1" : "0";
                string sFrom = (hdnFrom.Value != null && hdnFrom.Value != string.Empty) ? hdnFrom.Value : "";
                string sCreatedBy = Session["Phone"] != null ? Session["Phone"].ToString() : "";
                int nCount = 0;
                List <ContactInformation> objContacts = null;

                if (Session["ContactList"] != null)
                {
                    objContacts = (List<ContactInformation>)Session["ContactList"];
                    if (objContacts != null && objContacts.Count > 0)
                    {
                        foreach(ContactInformation objC in objContacts)
                        {
                            try
                            {
                                string sTo = objC.Email != null ? objC.Email : "";
                                if (sTo.Length > 0 && Convert.ToBoolean(objC.IsEmailFlow) == true)
                                {
                                    //string sSQL = " select * from EmailSchedule where FromEmail = '" + sFrom + "' and PersonEmail = '" + sTo + "' and LastEmailNumber = '" + sTemplate + "' and Category = '" + sCategory + "' and Type = '" + sType + "' ";
                                    string sSQL = " select * from EmailSchedule where FromEmail = '" + sFrom + "' and PersonName = '" + objC.Id.ToString() + "' and LastEmailNumber = '" + sTemplate + "' and Category = '" + sCategory + "' and Type = '" + sType + "' ";

                                    DataTable dtResult = SqlToTbl(sSQL);
                                    if (dtResult != null && dtResult.Rows.Count > 0)
                                    {
                                        nCount = nCount + 1;
                                        int nId = (dtResult.Rows[0]["Id"] != null && dtResult.Rows[0]["Id"] != DBNull.Value) ? Convert.ToInt32(dtResult.Rows[0]["Id"].ToString()) : 0;
                                        string sSQLUpdate = " update EmailSchedule set UpdatedDate = getdate(), UpdatedBy = '" + sCreatedBy + "', PersonEmail = '" + sTo + "'  where  Id  = '" + nId + "' ";
                                        Utility.RunCMDMain(sSQLUpdate);
                                    }
                                    else
                                    {
                                        ///   string sSQLDel = " delete from EmailSchedule where FromEmail = '" + sFrom + "' and PersonEmail = '" + sTo + "' and LastEmailNumber = '" + sTemplate + "' and Category = '" + sCategory + "' and Type = '" + sType + "' ";
                                        string sInit = "INSERT INTO EmailSchedule";
                                        string sParams = "PersonName,PersonEmail,FromEmail,IsLoop,Days,LastEmailNumber,CreatedBy,CreatedDate,Category,Type";
                                        string sValues = "'" + objC.Id.ToString() + "','" + sTo + "','" + sFrom + "','" + sLoop + "','" + sDay + "','" + sTemplate + "','" + sCreatedBy + "',getdate(), '" + sCategory + "','" + sType + "'";
                                        string sInsertSQL = sInit + "( " + sParams + " ) values ( " + sValues + " ) ";

                                        //   Utility.RunCMDMain(sSQLDel);
                                        Utility.RunCMDMain(sInsertSQL);
                                        nCount = nCount + 1;
                                    }                                   
                                }

                            }
                            catch (Exception ex1)
                            {
                               
                            }
                           
                        }
                    }
                }

                if (nCount > 0)
                {
                    ClearControls();
                    if (hdnFrom.Value != null && hdnFrom.Value != string.Empty)
                    {
                        string sToUser = ddlUser.SelectedValue != "-1" ? ddlUser.SelectedValue : "";
                        FillControls(hdnFrom.Value.ToString().Trim(), sToUser);
                    }

                    Utility.DisplayMsg("Email Scheduler saved successfully!", this);
                  //  Utility.DisplayMsgAndRedirect("Email Scheduler Saved successfully!", this, Utility.WebUrl + "/email-scheduler");
                }
                else
                {
                    Utility.DisplayMsg("Email Scheduler not saved!", this);
                    lblMessageNew.Text = "Email Scheduler not saved!!";
                }

            }
        }
        
        #endregion

    }
}