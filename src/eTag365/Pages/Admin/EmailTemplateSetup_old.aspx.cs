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
    public partial class EmailTemplateSetupOld : System.Web.UI.Page
    {
        public string sUserId = "";
        public string errStr = String.Empty;

        #region Events

        protected void Page_Load(object sender, EventArgs e)
        {

           //// btnSave33.Click += new EventHandler(btnSave33_Click);
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
                            FillUsers(2);

                            bool bIsAdmin = false;
                            //bIsAdmin = (obj.IsAdmin != null && Convert.ToBoolean(obj.IsAdmin) == true) ? true : false;
                            if(bIsAdmin == false)
                            {
                                ddlUser.SelectedValue = sUserId;
                                FillAllTransactionList(sUserId);
                                ddlUser.Enabled = false;
                            }

                            FillDropdowns();
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
            Label hdId = (Label)gvContactList.Rows[row.RowIndex].FindControl("lblId");

            if (!String.IsNullOrEmpty(hdId.Text))
            {
                FillControls(Convert.ToInt32(hdId.Text.ToString()));
            }

        }
        protected void btnDelete_Click(object sender, EventArgs e)
        {
            GridViewRow row = ((LinkButton)sender).Parent.Parent as GridViewRow;
            Label hdId = (Label)gvContactList.Rows[row.RowIndex].FindControl("lblId");

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
        protected void btnSave33_Click(object sender, EventArgs e)
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
                        if (new EmailSetupDA().Insert(objEmailSetup))
                        {                            
                            ClearControls();
                            sUserId = ddlUser.SelectedValue != "-1" ? ddlUser.SelectedValue : "";
                            if (sUserId != "")
                            {
                                FillAllTransactionList(sUserId);
                            }
                            lblMessageNew.Text = "Template saved successfully!";
                            Utility.DisplayMsg("Template saved successfully!", this);
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
                            lblMessageNew.Text = "Template updated successfully!";
                            Utility.DisplayMsg("Template updated successfully!", this);
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
        protected void btnBack33_Click(object sender, EventArgs e)
        {
            ClearControls();
            Response.Redirect(Utility.WebUrl + "/home");
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

                List<UserProfile> objUsers = new UserProfileDA().GetAllUsersInfo(nType);
                if (objUsers != null && objUsers.Count > 0)
                {
                    foreach (UserProfile obj in objUsers)
                    {
                        string sName = (obj.FirstName != null? obj.FirstName.ToString() : "") + " " + (obj.LastName != null ? obj.LastName.ToString() : "") + " (+" + (obj.Phone != null ? obj.Phone.ToString() : "") + ")";
                        ddlUser.Items.Add(new ListItem(sName, obj.Id.ToString()));
                    }
                }

                ddlUser.DataBind();
            }
            catch (Exception ex)
            {

            }

        }
        private void FillAllTransactionList(string nId)
        {
            try
            {
                List<EmailSetup> obj = null;
                obj = new EmailSetupDA().GetByUserId(nId);

                gvContactList.DataSource = obj;
                gvContactList.DataBind();

                
            }
            catch (Exception e)
            {

            }
        }
        private void ClearControls()
        {           
            ddlType.SelectedValue = "-1";
            ddlCategory.SelectedValue = "-1";          
            lblMessageNew.Text = "";          
            txtSubject.Text = "";
            txtOther.Text = "";
            btnSave33.Text = "Save";
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

                if (txtOther.Text.ToString().Length <= 0)
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

                if (txtOther.Text != null && txtOther.Text != string.Empty)
                {
                    obj.Content = txtOther.Text;
                }
                else
                {
                    obj.Content = "";
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

                       
                        if (obj.Subject != null && obj.Subject.ToString() != string.Empty)
                        {
                            txtSubject.Text = obj.Subject;
                        }
                        else
                        {
                            txtSubject.Text = "";
                        }

                        if (obj.Content != null && obj.Content.ToString() != string.Empty)
                        {
                            txtOther.Text = obj.Content;
                        }
                        else
                        {
                            txtOther.Text = "";
                        }
                        

                        if (obj.Type != null && obj.Type.ToString() != string.Empty)
                        {
                            ddlType.SelectedValue = obj.Type.ToString();
                        }
                       
                        if (obj.Category != null && obj.Category.ToString() != string.Empty)
                        {
                            ddlCategory.SelectedValue = obj.Category.ToString();
                        }
                        
                        if (obj.TemplateNo != null && obj.TemplateNo.ToString() != string.Empty)
                        {
                            ddlNo.SelectedValue = obj.TemplateNo.ToString();
                        }
                        btnSave33.Text = "Update";
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
                ddlType.Items.Add(new ListItem("None", "-1"));
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
                ddlCategory.Items.Add(new ListItem("None", "-1"));
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

                for(int i = 0; i <= 12; i++)
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