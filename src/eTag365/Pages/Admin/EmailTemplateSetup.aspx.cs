using TagService.BO;
using TagService.DA;
using eTagService.Enums;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Web.Services;
using System.Security.AccessControl;
using System.Data;

namespace eTag365.Pages.Admin
{
    public partial class EmailTemplateSetup : System.Web.UI.Page
    {
        public string sUserId = "";
        public string errStr = String.Empty;
        public string sUserPhone = "";
        public string conStr = System.Configuration.ConfigurationManager.ConnectionStrings["eTagDB"].ConnectionString;

        #region Events
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session["AddTemplateId"] = null;
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
                            FillUsers(obj);
                            FillMenu(obj);
                            FillDropdowns();
                            //FillUsers(2, sUserPhone);
                            FillAllTransactionList(sUserId);
                          

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

        //protected void ddlUser_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        sUserId = ddlUser.SelectedValue != "-1" ? ddlUser.SelectedValue : "";

        //        if (sUserId != "")
        //        {
        //            FillAllTransactionList(sUserId);
        //        }
        //        else
        //        {
        //            gvContactList.DataSource = null;
        //            gvContactList.DataBind();

        //        }

        //    }
        //    catch (Exception)
        //    {

        //    }
        //}
        protected void ddlNo_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                string sTemplateNo = ddlNo.SelectedValue != "-1" ? ddlNo.SelectedValue : "-1";

                if (sTemplateNo != "-1")
                {
                    ddlType.SelectedValue = "-1";
                    ddlCategory.SelectedValue = "-1";
                    lblMessageNew.Text = "";
                    txtSubject.Text = "";
                    txtGreetings.Text = "";
                    txtContent.Text = "";


                   // FillAllTransactionList(ddlUser.SelectedValue);
                }
                
            }
            catch (Exception)
            {

            }
        }
        protected void gvContactList_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvContactList.PageIndex = e.NewPageIndex;

            sUserId = ddlUser.SelectedValue != "-1" ? ddlUser.SelectedValue : "";

            if (sUserId != "")
            {
                FillAllTransactionList(sUserId);
            }
            else
            {
                gvContactList.DataSource = null;
                gvContactList.DataBind();

            }

        }
        protected void gvContactList_Sorting(object sender, GridViewSortEventArgs e)
        {
            sUserId = ddlUser.SelectedValue != "-1" ? ddlUser.SelectedValue : "";

            if (sUserId != "")
            {
                FillAllTransactionList(sUserId);
            }
            else
            {
                gvContactList.DataSource = null;
                gvContactList.DataBind();

            }
        }
        protected void btnEdit_Click(object sender, EventArgs e)
        {
            GridViewRow row = ((LinkButton)sender).Parent.Parent as GridViewRow;
            Label hdId = (Label)gvContactList.Rows[row.RowIndex].FindControl("lblTemplateId");

            if (!String.IsNullOrEmpty(hdId.Text))
            {
                ClearControls();
                FillControls(Convert.ToInt32(hdId.Text.ToString()));
            }

        }
        protected void btnDelete_Click(object sender, EventArgs e)
        {
            GridViewRow row = ((LinkButton)sender).Parent.Parent as GridViewRow;
            Label hdId = (Label)gvContactList.Rows[row.RowIndex].FindControl("lblTemplateId");

            if (!String.IsNullOrEmpty(hdId.Text))
            {
                if (new EmailSetupDA().DeleteByID(Convert.ToInt32(hdId.Text.ToString())))
                {
                    sUserId = ddlUser.SelectedValue != "-1" ? ddlUser.SelectedValue : "";
                    if (sUserId != "")
                    {
                        FillAllTransactionList(sUserId);
                    }
                    else
                    {
                        gvContactList.DataSource = null;
                        gvContactList.DataBind();

                    }

                    Utility.DisplayMsg("Template deleted successfully!", this);

                }
            }
        }
        protected void btnSaveEmail_Click(object sender, EventArgs e)
        {
            save();
        }        
        protected void btnBack33_Click(object sender, EventArgs e)
        {
            ClearControls();
            Response.Redirect(Utility.WebUrl + "/home");
        }

        #endregion

        #region Method      

        private void save()
        {
            errStr = string.Empty;
            errStr = Validate_Control();
            if (errStr.Length <= 0)
            {
                try
                {
                    EmailSetup objEmailSetup = new EmailSetup();
                    objEmailSetup = SetData(objEmailSetup);

                    if (Session["AddTemplateId"] == null || Session["AddTemplateId"] == "0")
                    {
                        if (new EmailSetupDA(true, false).Insert(objEmailSetup))
                        {
                            ClearControls();
                            sUserId = ddlUser.SelectedValue != "-1" ? ddlUser.SelectedValue : "";
                            if (sUserId != "")
                            {
                                FillAllTransactionList(sUserId);
                            }

                            Utility.DisplayMsgAndRedirect("Template saved successfully!", this, Utility.WebUrl + "/email-setup");

                        }
                        else
                        {
                            lblMessageNew.Text = "Template not saved!!";
                            Utility.DisplayMsg("Template not saved!", this);

                        }
                    }
                    else
                    {
                        if (new EmailSetupDA().Update(objEmailSetup))
                        {
                            Session["AddTemplateId"] = null;
                            ClearControls();
                            sUserId = ddlUser.SelectedValue != "-1" ? ddlUser.SelectedValue : "";
                            if (sUserId != "")
                            {
                                FillAllTransactionList(sUserId);
                            }

                            Utility.DisplayMsgAndRedirect("Template updated successfully!", this, Utility.WebUrl + "/email-setup");
                            
                        }
                        else
                        {
                            Utility.DisplayMsg("Template not updated!", this);
                            lblMessageNew.Text = "Template not updated!!";
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
        private void FillMenu(UserProfile obj)
        {
            try
            {
                if (obj != null)
                {
                    spanAccount.InnerHtml = "<a style='color:#fff;' href='" + Utility.WebUrl + "/user?Top=1&UId=" + obj.Id.ToString() + "'>Account Profile </a>";
                    spanReset.InnerHtml = "<a class='btn btn-default btn-flat' href='" + Utility.WebUrl + "/reset-password'>Reset Password </a>";
                    spanSignOut.InnerHtml = "<a class='btn btn-default btn-flat' href='" + Utility.WebUrl + "/logout'>Sign out</a>";

                    bool bIsAdmin = false;

                    bIsAdmin = (obj.IsAdmin != null && Convert.ToBoolean(obj.IsAdmin) == true) ? true : false;

                    if (obj.UserTypeContact != null)
                    {
                        if (obj.UserTypeContact == Convert.ToInt32(EnumUserType.Admin).ToString())
                        {
                            liHeader.InnerHtml = "User: Admin";
                            lihome.InnerHtml = "<a href='" + Utility.WebUrl + "/home'><i class='fa fa-circle-o'></i>Dashboard </a>";
                            liImport.InnerHtml = "<a href='" + Utility.WebUrl + "/contact-import'><i class='fa fa-circle-o'></i>Import / Export Contacts </a>";

                            liUser.InnerHtml = "<a href='" + Utility.WebUrl + "/users'><i class='fa fa-circle-o'></i>Add/Change User Profile </a>";
                            liPrice.InnerHtml = "<a href='" + Utility.WebUrl + "/user-pricing'><i class='fa fa-circle-o'></i>User Pricing</a>";
                            liBilling.InnerHtml = "<a href='" + Utility.WebUrl + "/billing'><i class='fa fa-circle-o'></i>Billing Payment Options</a>";
                            liReferral.InnerHtml = "<a href='" + Utility.WebUrl + "/referral-report'><i class='fa fa-circle-o'></i>My Referral View & Report </a>";
                            liDealer.InnerHtml = "<a href='" + Utility.WebUrl + "/dealer'><i class='fa fa-circle-o'></i>Dealer Dashboard </a>";
                            liGroupCode.InnerHtml = "<a href='" + Utility.WebUrl + "/group-code'><i class='fa fa-circle-o'></i>Group Code Profile </a>";
                            liSystemData.InnerHtml = "<a href='" + Utility.WebUrl + "/system'><i class='fa fa-circle-o'></i>System Data</a>";
                            liGlobalSystemInfo.InnerHtml = "<a href='" + Utility.WebUrl + "/global-info'><i class='fa fa-circle-o'></i>Global eTag365 System Info</a>";
                            lireset.InnerHtml = "<a href='" + Utility.WebUrl + "/reset-password'><i class='fa fa-circle-o'></i>Reset Password </a>";
                            liApproveBillingTransaction.InnerHtml = "<a href='" + Utility.WebUrl + "/approvetransaction'><i class='fa fa-circle-o'></i>Approve Billing Transactions </a>";

                            liPayCommission.InnerHtml = "<a href='" + Utility.WebUrl + "/pay'><i class='fa fa-circle-o'></i>Pay Commissions</a>";
                            liApproveCommission.InnerHtml = "<a href='" + Utility.WebUrl + "/approve'><i class='fa fa-circle-o'></i>Approve Commissions</a>";

                            liEmailSetup.InnerHtml = "<a href='" + Utility.WebUrl + "/email-setup'><i class='fa fa-circle-o'></i>Email Template Setup </a>";
                            liEmailSchedule.InnerHtml = "<a href='" + Utility.WebUrl + "/email-scheduler'><i class='fa fa-circle-o'></i>Email Scheduler </a>";
                        }
                        else if (obj.UserTypeContact == Convert.ToInt32(EnumUserType.Dealer).ToString())
                        {
                            liHeader.InnerHtml = "User: Dealer";
                            liDealer.InnerHtml = "<a href='" + Utility.WebUrl + "/dealer'><i class='fa fa-circle-o'></i>Dealer Dashboard </a>";
                            liDealerCommission.InnerHtml = "<a href='" + Utility.WebUrl + "/dealer'><i class='fa fa-circle-o'></i>Dealer Commission </a>";
                            liDealerAccounts.InnerHtml = "<a href='" + Utility.WebUrl + "/dealer'><i class='fa fa-circle-o'></i>Dealer Accounts </a>";
                            liDealerProfile.InnerHtml = "<a href='" + Utility.WebUrl + "/dealer'><i class='fa fa-circle-o'></i>Dealer Profile </a>";
                            lireset.InnerHtml = "<a href='" + Utility.WebUrl + "/reset-password'><i class='fa fa-circle-o'></i>Reset Password </a>";
                        }
                        else
                        {
                            liHeader.InnerHtml = "User: Active";
                            lihome.InnerHtml = "<a href='" + Utility.WebUrl + "/home'><i class='fa fa-circle-o'></i>Dashboard </a>";
                            liImport.InnerHtml = "<a href='" + Utility.WebUrl + "/contact-import'><i class='fa fa-circle-o'></i>Import / Export Contacts </a>";
                            liPrice.InnerHtml = "<a href='" + Utility.WebUrl + "/user-pricing'><i class='fa fa-circle-o'></i>User Pricing</a>";
                            liBilling.InnerHtml = "<a href='" + Utility.WebUrl + "/billing'><i class='fa fa-circle-o'></i>Billing Payment Options</a>";
                            lireset.InnerHtml = "<a href='" + Utility.WebUrl + "/reset-password'><i class='fa fa-circle-o'></i>Reset Password </a>";
                            liReferral.InnerHtml = "<a href='" + Utility.WebUrl + "/referral-report'><i class='fa fa-circle-o'></i>My Referral View & Report </a>";

                            liEmailSetup.InnerHtml = "<a href='" + Utility.WebUrl + "/email-setup'><i class='fa fa-circle-o'></i>Email Template Setup </a>";
                            liEmailSchedule.InnerHtml = "<a href='" + Utility.WebUrl + "/email-scheduler'><i class='fa fa-circle-o'></i>Email Scheduler </a>";
                        }
                    }

                    if (bIsAdmin == true)
                    {
                        liUser.InnerHtml = "<a href='" + Utility.WebUrl + "/users'><i class='fa fa-circle-o'></i>Add/Change User Profile </a>";
                        liDealer.InnerHtml = "<a href='" + Utility.WebUrl + "/dealer'><i class='fa fa-circle-o'></i>Dealer Dashboard </a>";
                        liGroupCode.InnerHtml = "<a href='" + Utility.WebUrl + "/group-code'><i class='fa fa-circle-o'></i>Group Code Profile </a>";
                        liSystemData.InnerHtml = "<a href='" + Utility.WebUrl + "/system'><i class='fa fa-circle-o'></i>System Data</a>";
                        liGlobalSystemInfo.InnerHtml = "<a href='" + Utility.WebUrl + "/global-info'><i class='fa fa-circle-o'></i>Global eTag365 System Info</a>";
                        liApproveBillingTransaction.InnerHtml = "<a href='" + Utility.WebUrl + "/approvetransaction'><i class='fa fa-circle-o'></i>Approve Billing Transactions </a>";

                        liPayCommission.InnerHtml = "<a href='" + Utility.WebUrl + "/pay'><i class='fa fa-circle-o'></i>Pay Commissions</a>";
                        liApproveCommission.InnerHtml = "<a href='" + Utility.WebUrl + "/approve'><i class='fa fa-circle-o'></i>Approve Commissions</a>";
                    }


                    if (!string.IsNullOrEmpty(obj.ProfileLogo))
                    {
                        imgTopLogo.ImageUrl = Utility.WebUrl + "/Uploads/Files/User/" + obj.ProfileLogo;
                        imgTopIcon.ImageUrl = Utility.WebUrl + "/Uploads/Files/User/" + obj.ProfileLogo;
                    }
                }
            }
            catch (Exception ex)
            {

            }

        }

        private void FillUsers(UserProfile obj)
        {
            try
            {
                ddlUser.Items.Clear();
                ddlUser.AppendDataBoundItems = true;

                string sName = (obj.FirstName != null ? obj.FirstName.ToString() : "") + " " + (obj.LastName != null ? obj.LastName.ToString() : "") + " (+" + (obj.Phone != null ? obj.Phone.ToString() : "") + ")";
                ddlUser.Items.Add(new ListItem(sName, obj.Id.ToString()));
                ddlUser.DataBind();

                ddlUser.SelectedValue = obj.Id.ToString();
                ddlUser.Enabled = false;
            }
            catch (Exception ex)
            {

            }

        }

        //private void FillUsers(int nType, string sPhone)
        //{
        //    try
        //    {
        //        ddlUser.Items.Clear();
        //        ddlUser.AppendDataBoundItems = true;
        //        ddlUser.Items.Add(new ListItem("Select User", "-1"));
                
        //        //List<UserProfile> objUsers = new UserProfileDA().GetAllUsersInfo(nType);
        //        List<UserProfile> objUsers = null;
        //        //objUsers = new UserProfileDA().GetAllUsersInfoForEmailFlow(nType, sPhone);
        //        objUsers = new UserProfileDA().GetAllUsersInfo(nType);

        //        if (objUsers != null && objUsers.Count > 0)
        //        {
        //            foreach (UserProfile obj in objUsers)
        //            {
        //                string sName = (obj.FirstName != null ? obj.FirstName.ToString() : "") + " " + (obj.LastName != null ? obj.LastName.ToString() : "") + " (+" + (obj.Phone != null ? obj.Phone.ToString() : "") + ")";
        //                ddlUser.Items.Add(new ListItem(sName, obj.Id.ToString()));
        //            }
        //        }

        //        ddlUser.DataBind();
        //        ddlUser.SelectedValue = sUserId;
        //    }
        //    catch (Exception ex)
        //    {

        //    }

        //}
        private void FillAllTransactionList(string nUserId)
        {
            try
            {
                //List<EmailSetup> obj = null;
                //obj = new EmailSetupDA().GetByUserId(nId);

                //gvContactList.DataSource = obj;
                //gvContactList.DataBind();

                string sSQL = "select e.Id, isnull(cast(e.TemplateNo as int),0) TemplateNo, isnull(e.Subject,'') Subject, isnull(e.Category,'') Category, isnull(e.Type,'') Type from EmailSetup e where e.UserId = '" + nUserId + "' order by isnull(cast(e.TemplateNo as int),0), isnull(e.Category,'') ";
                DataTable dtResult = SqlToTbl(sSQL);

                gvContactList.DataSource = dtResult;
                gvContactList.DataBind();
            }
            catch (Exception e)
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

        private void ClearControls()
        {
            ddlType.SelectedValue = "-1";
            ddlCategory.SelectedValue = "-1";
            lblMessageNew.Text = "";
            txtSubject.Text = "";
            txtGreetings.Text = "";
            txtContent.Text = ""; 
            btnSaveEmail.Text = "Save";
        }
        public string Validate_Control()
        {
            try
            {
                if (ddlUser.SelectedValue == "-1")
                {
                    errStr += "Please select User" + Environment.NewLine;
                }

                if (txtSubject.Text.ToString().Length <= 0)
                {
                    errStr += "Please enter Subject" + Environment.NewLine;
                }

                if (txtContent.Text.ToString().Length <= 0)
                {
                    errStr += "Please enter body content" + Environment.NewLine;
                }


            }
            catch (Exception ex)
            {
            }

            return errStr;
        }
        private EmailSetup SetData(EmailSetup obj)
        {
            try
            {
                obj = new EmailSetup();

                if (Session["AddTemplateId"] != null && Convert.ToInt32(Session["AddTemplateId"]) > 0)
                {
                    obj = new EmailSetupDA().GetByID(Convert.ToInt32(Session["AddTemplateId"]));
                    obj.Id = Convert.ToInt32(Session["AddTemplateId"].ToString());
                }

                if (Session["AddTemplateId"] != null)
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
                if (ddlUser.SelectedValue != "-1")
                {
                    obj.UserId = ddlUser.SelectedValue.ToString();
                }
                else
                {
                    obj.UserId = "";
                }

                if (ddlNo.SelectedValue != "-1")
                {
                    obj.TemplateNo = ddlNo.SelectedValue.ToString();
                }
                else
                {
                    obj.TemplateNo = "";
                }

                if (txtSubject.Text != null && txtSubject.Text != string.Empty)
                {
                    obj.Subject = txtSubject.Text;
                }
                else
                {
                    obj.Subject = "";
                }

                if (txtContent.Text != null && txtContent.Text != string.Empty)
                {
                    obj.Content = txtContent.Text;
                }
                else
                {
                    obj.Content = "";
                }
                if (txtGreetings.Text != null && txtGreetings.Text != string.Empty)
                {
                    obj.Greetings = txtGreetings.Text;
                }
                else
                {
                    obj.Greetings = "";
                }
              
            }
            catch (Exception e)
            {
            }


            return obj;
        }
        private void FillControls(int nId)
        {
            try
            {
                if (nId > 0)
                {
                    EmailSetup obj = new EmailSetupDA().GetByID(nId);
                    if (obj != null)
                    {
                        Session["AddTemplateId"] = obj.Id;

                        if (obj.TemplateNo != null && obj.TemplateNo.ToString() != string.Empty)
                        {
                            ddlNo.SelectedValue = obj.TemplateNo.ToString();
                        }

                        if (obj.Subject != null && obj.Subject.ToString() != string.Empty)
                        {
                            txtSubject.Text = obj.Subject;
                        }
                        else
                        {
                            txtSubject.Text = "";
                        }

                        if (obj.Greetings != null && obj.Greetings.ToString() != string.Empty)
                        {
                            txtGreetings.Text = obj.Greetings;
                        }
                        else
                        {
                            txtGreetings.Text = "";
                        }

                        if (obj.Content != null && obj.Content.ToString() != string.Empty)
                        {
                            txtContent.Text = obj.Content;
                        }
                        else
                        {
                            txtContent.Text = "";
                        }                        

                        if (obj.Category != null && obj.Category.ToString() != string.Empty)
                        {
                            ddlCategory.SelectedValue = obj.Category.ToString();
                        }
                        else
                        {
                            ddlCategory.SelectedValue = "-1";
                        }
                       
                        btnSaveEmail.Text = "Update";

                        if (obj.Type != null && obj.Type.ToString() != string.Empty)
                        {
                            ddlType.SelectedValue = obj.Type.ToString();
                        }
                        else
                        {
                            ddlType.SelectedValue = "-1";
                        }
                    }
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

            try
            {
                ddlNo.Items.Clear();
                ddlNo.AppendDataBoundItems = true;
                ddlNo.Items.Add(new ListItem("N/A", "-1"));

                for (int i = 0; i <= 12; i++)
                {
                    ddlNo.Items.Add(new ListItem(i.ToString(), i.ToString()));
                }

                ddlNo.DataBind();
                ddlNo.SelectedValue = "0";
            }
            catch (Exception ex)
            {

            }
        }

        #endregion

    }
}