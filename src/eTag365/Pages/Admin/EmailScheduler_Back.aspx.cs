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
    public partial class EmailSchedulerOld : System.Web.UI.Page
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
                          //  FillUsersByType(2);
                            FillUsers(2);
                            FillDays();
                            FillDropdowns();
                            //FillCategoriesByUserId(sUserId);
                            //FillTypesByUserId(sUserId);
                            FillTemplateList(sUserId);

                            if (Session["ScheduleToUserId"] != null)
                            {
                                ddlUser.SelectedValue = Session["ScheduleToUserId"].ToString();
                            }

                            if (Session["ScheduleToUser"] != null)
                            {
                               hdnTo.Value = Session["ScheduleToUser"].ToString().Trim();
                            }

                            if (hdnFrom.Value != null && hdnFrom.Value != string.Empty && hdnTo.Value != null && hdnTo.Value != string.Empty)
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
                string sToUserId = ddlUser.SelectedValue != "-1" ? ddlUser.SelectedValue : "";

                if (sToUserId != "")
                {
                    UserProfile obj = new UserProfileDA().GetUserByUserID(Convert.ToInt32(sToUserId));
                    if (obj != null)
                    {
                        hdnTo.Value = obj.Email != null ?  obj.Email.Trim() : "";                       
                    }                    
                }
                else
                {
                    hdnTo.Value = "";
                }

               
                string sFromEmail = (hdnFrom.Value != null && hdnFrom.Value != string.Empty) ? hdnFrom.Value.ToString().Trim() : "";

                string sCategory = ddlCategory.SelectedValue != "-1" ? ddlCategory.SelectedValue : "";

                string sType = ddlType.SelectedValue != "-1" ? ddlType.SelectedValue : "";

                if (sFromEmail.Length > 0 && sToUserId.Length > 0)
                {
                    FillControlsBySearch(sFromEmail, sToUserId, sCategory, sType);
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
                string sToUserId = ddlUser.SelectedValue != "-1" ? ddlUser.SelectedValue : "";

                string sFromEmail = (hdnFrom.Value != null && hdnFrom.Value != string.Empty) ? hdnFrom.Value.ToString().Trim() : "";

                string sCategory = ddlCategory.SelectedValue != "-1" ? ddlCategory.SelectedValue : "";

                string sType = ddlType.SelectedValue != "-1" ? ddlType.SelectedValue : "";

                if (sFromEmail.Length > 0 && sToUserId.Length > 0)
                {
                    FillControlsBySearch(sFromEmail, sToUserId, sCategory, sType);
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
                string sToUserId = ddlUser.SelectedValue != "-1" ? ddlUser.SelectedValue : "";

                string sFromEmail = (hdnFrom.Value != null && hdnFrom.Value != string.Empty) ? hdnFrom.Value.ToString().Trim() : "";

                string sCategory = ddlCategory.SelectedValue != "-1" ? ddlCategory.SelectedValue : "";

                string sType = ddlType.SelectedValue != "-1" ? ddlType.SelectedValue : "";

                if (sFromEmail.Length > 0 && sToUserId.Length > 0)
                {
                    FillControlsBySearch(sFromEmail, sToUserId, sCategory, sType);
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
                try
                {
                    EmailSchedule objEmailSchedule = new EmailSchedule();
                    objEmailSchedule = SetData(objEmailSchedule);
                    
                    if (Session["AddScheduleId"] == null || Session["AddScheduleId"] == "0")
                    {
                        if (new EmailScheduleDA(true, false).Insert(objEmailSchedule))
                        {
                            ClearControls();

                            if (hdnFrom.Value != null && hdnFrom.Value != string.Empty && hdnTo.Value != null && hdnTo.Value != string.Empty)
                            {
                                Session["ScheduleToUserId"] = ddlUser.SelectedValue;
                                Session["ScheduleToUser"] = hdnTo.Value;
                                Utility.DisplayMsgAndRedirect("Email Scheduler saved successfully!", this, Utility.WebUrl + "/email-scheduler");
                            }                                              
                            
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
                            if (hdnFrom.Value != null && hdnFrom.Value != string.Empty && hdnTo.Value != null && hdnTo.Value != string.Empty)
                            {
                                Session["ScheduleToUserId"] = ddlUser.SelectedValue;
                                Session["ScheduleToUser"] = hdnTo.Value; 
                                Utility.DisplayMsgAndRedirect("Email Scheduler updated successfully!", this, Utility.WebUrl + "/email-scheduler");
                            }
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

            //if (hdnFrom.Value != null && hdnFrom.Value != string.Empty && hdnTo.Value != null && hdnTo.Value != string.Empty)
            //{
            //    FillControls(hdnFrom.Value.ToString().Trim(), hdnTo.Value.ToString().Trim());
            //}

            string sToUserId = ddlUser.SelectedValue != "-1" ? ddlUser.SelectedValue : "";

            string sFromEmail = (hdnFrom.Value != null && hdnFrom.Value != string.Empty) ? hdnFrom.Value.ToString().Trim() : "";

            string sCategory = ddlCategory.SelectedValue != "-1" ? ddlCategory.SelectedValue : "";

            string sType = ddlType.SelectedValue != "-1" ? ddlType.SelectedValue : "";

            if (sFromEmail.Length > 0 && sToUserId.Length > 0)
            {
                FillControlsBySearch(sFromEmail, sToUserId, sCategory, sType);
            }

        }
        protected void gvContactList_Sorting(object sender, GridViewSortEventArgs e)
        {
            string sToUserId = ddlUser.SelectedValue != "-1" ? ddlUser.SelectedValue : "";

            string sFromEmail = (hdnFrom.Value != null && hdnFrom.Value != string.Empty) ? hdnFrom.Value.ToString().Trim() : "";

            string sCategory = ddlCategory.SelectedValue != "-1" ? ddlCategory.SelectedValue : "";

            string sType = ddlType.SelectedValue != "-1" ? ddlType.SelectedValue : "";

            if (sFromEmail.Length > 0 && sToUserId.Length > 0)
            {
                FillControlsBySearch(sFromEmail, sToUserId, sCategory, sType);
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
                    if (hdnFrom.Value != null && hdnFrom.Value != string.Empty && hdnTo.Value != null && hdnTo.Value != string.Empty)
                    {
                        FillControls(hdnFrom.Value.ToString().Trim(), hdnTo.Value.ToString().Trim());
                    }

                    Utility.DisplayMsg("deleted successfully!", this);
                }
               

                //if (new EmailSetupDA().DeleteByID(Convert.ToInt32(hdId.Text.ToString())))
                //{
                //    if (txtEmail.Text != null && txtEmail.Text != string.Empty && txtToEmail.Text != null && txtToEmail.Text != string.Empty)
                //    {
                //        FillControls(txtEmail.Text, txtToEmail.Text);
                //    }

                //    Utility.DisplayMsg("deleted successfully!", this);

                //}
            }
        }

        #endregion

        #region Method
        private void FillUsers(int nType)
        {
            try
            {
                
                ddlUser.Items.Clear();
                ddlUser.AppendDataBoundItems = true;
                ddlUser.Items.Add(new ListItem("Select User", "-1"));
                List<UserProfile> objUsers = null;

               // objUsers = new UserProfileDA().GetAllUsers();

                objUsers = new UserProfileDA().GetAllUsersInfoForEmailFlow(nType, sUserPhone);

                 objUsers = new UserProfileDA().GetAllUsersInfo(nType);
                if (objUsers != null && objUsers.Count > 0)
                {
                    foreach (UserProfile obj in objUsers)
                    {
                        //string sName = (obj.FirstName != null ? obj.FirstName.ToString() : "") + " " + (obj.LastName != null ? obj.LastName.ToString() : "") + " (+" + (obj.Phone != null ? obj.Phone.ToString() : "") + ")";
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
        private void FillUsersByType(int nType)
        {
            try
            {
                ddlUser.Items.Clear();
                ddlUser.AppendDataBoundItems = true;
                ddlUser.Items.Add(new ListItem("Select User", "-1"));

                bool bIsAdmin = false;
                UserProfile objTemp = null;
                if (Session["UserId"] != null)
                {
                    objTemp = new UserProfileDA().GetUserByUserID(Convert.ToInt32(Session["UserId"].ToString()));
                    if (objTemp != null)
                    {
                        bIsAdmin = (objTemp.IsAdmin != null && Convert.ToBoolean(objTemp.IsAdmin) == true) ? true : false;
                    }
                }


                if (bIsAdmin == true)
                {
                    List<UserProfile> objUsers = new UserProfileDA().GetAllUsers();
                    if (objUsers != null && objUsers.Count > 0)
                    {
                        foreach (UserProfile obj in objUsers)
                        {
                            //  string sName = (obj.FirstName != null ? obj.FirstName.ToString() : "") + " " + (obj.LastName != null ? obj.LastName.ToString() : "") + " (+" + (obj.Phone != null ? obj.Phone.ToString() : "") + ")";
                            string sName = (obj.FirstName != null ? obj.FirstName.ToString() : "") + " " + (obj.LastName != null ? obj.LastName.ToString() : "");
                            ddlUser.Items.Add(new ListItem(sName, obj.Id.ToString()));
                        }
                    }
                }
                else
                {
                    List<UserProfile> objUsers = new UserProfileDA().GetAllUsersInfoForEmailFlow(nType, sUserPhone);
                    if (objUsers != null && objUsers.Count > 0)
                    {
                        foreach (UserProfile obj in objUsers)
                        {
                            //  string sName = (obj.FirstName != null ? obj.FirstName.ToString() : "") + " " + (obj.LastName != null ? obj.LastName.ToString() : "") + " (+" + (obj.Phone != null ? obj.Phone.ToString() : "") + ")";
                            string sName = (obj.FirstName != null ? obj.FirstName.ToString() : "") + " " + (obj.LastName != null ? obj.LastName.ToString() : "");
                            ddlUser.Items.Add(new ListItem(sName, obj.Id.ToString()));
                        }
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
                if (ddlUser.SelectedValue == "-1")
                {
                    errStr += "Please select User" + Environment.NewLine;
                }

                try
                {
                    string sWhere = "";
                    string sCategory = ddlCategory.SelectedValue != "-1" ? ddlCategory.SelectedValue : "";
                    string sType = ddlType.SelectedValue != "-1" ? ddlType.SelectedValue : "";
                    string sTemplateNo = ddlTemplateNo.SelectedValue != "-1" ? ddlTemplateNo.SelectedValue : "";

                    sWhere += "  and e.Category = '" + sCategory + "' and e.Type = '" + sType + "' and e.TemplateNo = '" + sTemplateNo + "' ";

                    if (Session["UserId"] != null && sWhere.Length > 0)
                    {
                        string sSQL = " select e.Id  from EmailSetup e where e.UserId = '" + Session["UserId"].ToString()  + "' " + sWhere;
                        DataTable dtResult = SqlToTbl(sSQL);

                        if (dtResult != null && dtResult.Rows.Count > 0)
                        {                           
                        }
                        else
                        {
                            errStr += "Template Not Found. Please change selection and try again !!" + Environment.NewLine;
                        }
                    }
                }
                catch (Exception e)
                {

                }

            }
            catch (Exception ex)
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
            catch (Exception e)
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

                        //FillCategories();

                        //if (Session["Phone"] != null)
                        //{
                        //    FillCategoryList(ddlTemplateNo.SelectedValue, Session["Phone"].ToString());
                        //}

                        if (obj.Category != null && obj.Category.ToString() != string.Empty)
                        {
                            ddlCategory.SelectedValue = obj.Category.ToString();
                        }

                        if (obj.Type != null && obj.Type.ToString() != string.Empty)
                        {
                            ddlType.SelectedValue = obj.Type.ToString();
                        }

                        btnSave33.Text = "Update";
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

        //private void FillCategories()
        //{
            
        //    List<Child> listCategory = null;

        //    int nUserId = Session["UserId"] != null ? Convert.ToInt32(Session["UserId"].ToString()) : 0;
        //    if (nUserId > 0)
        //    {
        //        listCategory = new ChildDA().GetChildByUserDefinedIDAndUserID(Convert.ToInt32(EnumBasicData.Category), nUserId);
        //    }

        //    try
        //    {
        //        ddlCategory.Items.Clear();
        //        ddlCategory.AppendDataBoundItems = true;
        //        ddlCategory.Items.Add(new ListItem("None", "-1"));
        //        ddlCategory.SelectedValue = "-1";
        //        ddlCategory.DataSource = listCategory;
        //        ddlCategory.DataTextField = "Description";
        //        ddlCategory.DataValueField = "Description";
        //        ddlCategory.DataBind();

        //    }
        //    catch (Exception ex)
        //    {

        //    }
        //}

        //private void FillDropdowns()
        //{
        //    List<Child> listContactType = null;           

        //    int nUserId = Session["UserId"] != null ? Convert.ToInt32(Session["UserId"].ToString()) : 0;
        //    if (nUserId > 0)
        //    {
        //        listContactType = new ChildDA().GetChildByUserDefinedIDAndUserID(Convert.ToInt32(EnumBasicData.ContactType), nUserId);               
        //    }

        //    try
        //    {
        //        ddlType.Items.Clear();
        //        ddlType.AppendDataBoundItems = true;
        //        ddlType.Items.Add(new ListItem("None", "-1"));
        //        ddlType.SelectedValue = "-1";
        //        ddlType.DataSource = listContactType;
        //        ddlType.DataTextField = "Description";
        //        ddlType.DataValueField = "Description";
        //        ddlType.DataBind();

        //    }
        //    catch (Exception ex)
        //    {

        //    }

            
           
        //}
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
        private void FillControls(string From, string To)
        {
            try
            {
                if (From.Length > 0 && To.Length > 0)
                {
                    string sSQL = " select e.Id, isnull(e.LastEmailNumber,0) LastEmailNumber, isnull(e.Days,'') Days, isnull(e.Category,'') Category, isnull(e.Type,'') Type from EmailSchedule e where e.FromEmail = '" + From + "' and e.PersonEmail = '" + To + "'  order by isnull(e.LastEmailNumber,0), isnull(e.Category,''), isnull(e.Type,'')  ";
                    DataTable dtResult = SqlToTbl(sSQL);

                    gvContactList.DataSource = dtResult;
                    gvContactList.DataBind();
                  
                }
            }
            catch (Exception e)
            {

            }
        }

        private void FillControlsBySearch(string From, string ToUserId, string Category, string Type)
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

                if ((!string.IsNullOrEmpty(ToUserId)) && ToUserId != "-1")
                {
                    sWhere += "  and e.PersonName = '" + ToUserId + "'";
                }

                if (From.Length > 0 && sWhere.Length > 0)
                {
                    string sSQL = " select e.Id, isnull(e.LastEmailNumber,0) LastEmailNumber, isnull(e.Days,'') Days, isnull(e.Category,'') Category, isnull(e.Type,'') Type from EmailSchedule e where e.FromEmail = '" + From + "' " + sWhere + "  order by isnull(e.LastEmailNumber,0), isnull(e.Category,''), isnull(e.Type,'')  ";
                    DataTable dtResult = SqlToTbl(sSQL);

                    gvContactList.DataSource = dtResult;
                    gvContactList.DataBind();

                }
            }
            catch (Exception e)
            {

            }
        }
        private void FillCategoriesByUserId(string nUserId)
        {
            try
            {
                ddlCategory.Items.Clear();
                ddlCategory.AppendDataBoundItems = true;
                ddlCategory.Items.Add(new ListItem("N/A", "-1"));

                string sSQL = "SELECT distinct Category  FROM EmailSetup where UserId = '" + nUserId.ToString() + "' and (category is not null and category <> '')  order by category ";

                DataTable dtResult = SqlToTbl(sSQL);

                if (dtResult != null && dtResult.Rows.Count > 0)
                {
                    foreach (DataRow dr in dtResult.Rows)
                    {
                        string cat = (dr["Category"] != null && dr["Category"] != DBNull.Value) ? dr["Category"].ToString() : "";
                        ddlCategory.Items.Add(new ListItem(cat.ToString(), cat.ToString()));
                    }
                }

                ddlCategory.DataBind();
                ddlCategory.SelectedValue = "-1";
            }
            catch (Exception ex)
            {

            }
        }

        private void FillTypesByUserId(string nUserId)
        {
            try
            {
                ddlType.Items.Clear();
                ddlType.AppendDataBoundItems = true;
                ddlType.Items.Add(new ListItem("N/A", "-1"));

                string sSQL = "SELECT distinct Type  FROM EmailSetup where UserId = '" + nUserId.ToString() + "' and (Type is not null and Type <> '')  order by Type ";

                DataTable dtResult = SqlToTbl(sSQL);

                if (dtResult != null && dtResult.Rows.Count > 0)
                {
                    foreach (DataRow dr in dtResult.Rows)
                    {
                        string sType = (dr["Type"] != null && dr["Type"] != DBNull.Value) ? dr["Type"].ToString() : "";
                        ddlType.Items.Add(new ListItem(sType.ToString(), sType.ToString()));
                    }
                }

                ddlType.DataBind();
                ddlType.SelectedValue = "-1";
            }
            catch (Exception ex)
            {

            }
        }

        //private void FillCategoryList(string templateNo, string userphone)
        //{
        //    try
        //    {
        //        ddlCategory.Items.Clear();
        //        ddlCategory.AppendDataBoundItems = true;
        //        ddlCategory.Items.Add(new ListItem("None", "-1"));               

        //        string sSQL = "SELECT Category  FROM EmailSetup where createdBy = '" + userphone + "' and TemplateNo = '" + templateNo + "' and (category is not null and category <> '')  order by category ";

        //        DataTable dtResult = SqlToTbl(sSQL);              

        //        if (dtResult != null && dtResult.Rows.Count > 0)
        //        {
        //            foreach (DataRow dr in dtResult.Rows)
        //            {
        //                string cat = (dr["Category"] != null && dr["Category"] != DBNull.Value) ? dr["Category"].ToString() : "";
        //                ddlCategory.Items.Add(new ListItem(cat.ToString(), cat.ToString()));
        //            }                   
        //        }

        //        ddlCategory.DataBind();
        //        ddlCategory.SelectedValue = "-1";
        //    }
        //    catch (Exception ex)
        //    {

        //    }
        //}

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

        #endregion


    }
}