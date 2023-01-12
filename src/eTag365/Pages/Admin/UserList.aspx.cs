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

namespace eTag365.Pages.Admin
{
    public partial class UserList : System.Web.UI.Page
    {
        public string errStr = string.Empty;
        public string sUrl = string.Empty;

        #region Events

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session["UserId"] = null;
                Session["AddUserSearch"] = null;
                
                string sessionid = System.Web.HttpContext.Current.Session.SessionID;
                if (!string.IsNullOrEmpty(sessionid))
                {
                    int userid = Utility.IntegerData("SELECT TOP 1 UserId FROM UserLog_Data Where SessionId='" + sessionid + "' Order By LogId DESC");
                   
                    if (userid > 0)
                    {
                        Session["UserId"] = userid;
                        FillUsers();
                        FillUsersByType(2);
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
        protected void btnsearch_Click(object sender, EventArgs e)
        {
            try
            {
                string sSearch = search.Value.Replace("-", " ").ToString().Trim();
                Session["AddUserSearch"] = null;               
                if (sSearch.Trim() != string.Empty)
                {
                    //string strWhere = string.Empty;
                    //strWhere = search.Value.ToString().Trim();
                    Session["AddUserSearch"] = sSearch.Trim();                   
                }

                FillUsers();
            }

            catch (Exception ex) 
            { }
        }
        protected void btnDelete_Click(object sender, EventArgs e)
        {
            GridViewRow row = ((LinkButton)sender).Parent.Parent as GridViewRow;
            Label hdId = (Label)gvContactList.Rows[row.RowIndex].FindControl("lblId");

            if (!String.IsNullOrEmpty(hdId.Text))
            {
                if (new UserProfileDA().DeleteByID(Convert.ToInt32(hdId.Text.ToString())))
                {
                    FillUsers();
                    Utility.DisplayMsg("User deleted successfully!", this);   

                    //if (Session["UserId"] != null)
                    //{
                    //    UserProfile objTemp = new UserProfileDA().GetUserByUserID(Convert.ToInt32(Session["UserId"].ToString()));
                    //    if (objTemp != null && objTemp.UserTypeContact == ((Int32)EnumUserType.Admin).ToString())
                    //    {
                    //        FillUsers();
                    //    }
                    //}
                }
            }
        }
        protected void gvContactList_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvContactList.PageIndex = e.NewPageIndex;
            FillUsers();
        }
        protected void gvContactList_Sorting(object sender, GridViewSortEventArgs e)
        {
            FillUsers();
        }
        protected void btnAdd_Click(object sender, EventArgs e)
        {
           // Response.Redirect(Utility.WebUrl + "/Pages/Admin/AddUser.aspx");
            Response.Redirect(Utility.WebUrl + "/user");
        }

        protected void ddlUser_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                FillContacts(ddlUser.SelectedValue);
            }
            catch (Exception)
            {

            }
        }

        protected void btnCDelete_Click(object sender, EventArgs e)
        {
            GridViewRow row = ((LinkButton)sender).Parent.Parent as GridViewRow;
            Label hdId = (Label)gvContactList.Rows[row.RowIndex].FindControl("lblCId");

            if (!string.IsNullOrEmpty(hdId.Text))
            {
                if (new ContactInformationDA().DeleteByID(Convert.ToInt32(hdId.Text.ToString())))
                {
                    FillContacts(ddlUser.SelectedValue);
                    Utility.DisplayMsg("Contact deleted successfully!", this);

                   
                }
            }
        }
        protected void gvUserList_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvUserList.PageIndex = e.NewPageIndex;
            FillContacts(ddlUser.SelectedValue);
        }
        protected void gvUserList_Sorting(object sender, GridViewSortEventArgs e)
        {
            FillContacts(ddlUser.SelectedValue);
        }

        #endregion

        #region Method

        private void FillUsers()
        {
            try
            {
                List<UserProfile> obj = null;
                bool bIsAdmin = false;
                string sPhone = "";

                if (Session["UserId"] != null)
                {
                    UserProfile objTemp = new UserProfileDA().GetUserByUserID(Convert.ToInt32(Session["UserId"].ToString()));
                    if (objTemp != null)
                    {
                        bIsAdmin = (objTemp.IsAdmin != null && Convert.ToBoolean(objTemp.IsAdmin) == true) ? true : false;
                        sPhone = objTemp.Phone;
                    }
                }
               

                if(bIsAdmin == true)
                {
                    if (Session["AddUserSearch"] != null)
                    {
                        obj = new UserProfileDA().GetBySearch(Session["AddUserSearch"].ToString());
                    }
                    else
                    {
                        obj = new UserProfileDA().GetAllUsers();
                    }
                }
                else
                {
                    if (Session["AddUserSearch"] != null)
                    {
                        obj = new UserProfileDA().GetBySearchAndUser(Session["AddUserSearch"].ToString(), sPhone);
                    }
                    else
                    {
                        obj = new UserProfileDA().GetAllUsersInfoByUser(sPhone);
                    }
                }

               
                gvContactList.DataSource = obj;
                gvContactList.DataBind();




            }
            catch (Exception e)
            {

            }
        }

        private void FillContacts(string userId)
        {
            try
            {
                List<ContactInformation> objContacts = null;
                bool bIsAdmin = false;
                string sPhone = "";

                if (Session["UserId"] != null)
                {
                    UserProfile objTemp = new UserProfileDA().GetUserByUserID(Convert.ToInt32(Session["UserId"].ToString()));
                    if (objTemp != null)
                    {
                        bIsAdmin = (objTemp.IsAdmin != null && Convert.ToBoolean(objTemp.IsAdmin) == true) ? true : false;
                        sPhone = objTemp.Phone;
                    }
                }

                string sUserId = ddlUser.SelectedValue != "-1" ? ddlUser.SelectedValue : "";

                if (sUserId != "")
                {
                    objContacts = new ContactInformationDA().GetByUserId(sUserId);
                    gvUserList.DataSource = objContacts;
                    gvUserList.DataBind();
                }
                else
                {
                    if (bIsAdmin == true)
                    {
                        objContacts = new ContactInformationDA().GetAllContactInformation();
                        gvUserList.DataSource = objContacts;
                        gvUserList.DataBind();
                    }
                    else
                    {
                        gvUserList.DataSource = null;
                        gvUserList.DataBind();
                    } 
                }
            }
            catch (Exception e)
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
                    List<UserProfile> objUsers = new UserProfileDA().GetAllUsersInfo(nType);
                    if (objUsers != null && objUsers.Count > 0)
                    {
                        foreach (UserProfile obj in objUsers)
                        {
                            string sName = (obj.FirstName != null ? obj.FirstName.ToString() : "") + " " + (obj.LastName != null ? obj.LastName.ToString() : "") + " (+" + (obj.Phone != null ? obj.Phone.ToString() : "") + ")";
                            ddlUser.Items.Add(new ListItem(sName, obj.Id.ToString()));
                        }
                    }
                }
                else
                {
                    if (objTemp != null)
                    {
                        string sName = (objTemp.FirstName != null ? objTemp.FirstName.ToString() : "") + " " + (objTemp.LastName != null ? objTemp.LastName.ToString() : "") + " (+" + (objTemp.Phone != null ? objTemp.Phone.ToString() : "") + ")";
                        ddlUser.Items.Add(new ListItem(sName, objTemp.Id.ToString()));
                    }
                }                

                ddlUser.DataBind();
            }
            catch (Exception ex)
            {

            }

        }

        #endregion
    }
}