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
    public partial class EmailLog : System.Web.UI.Page
    {
       
        public string conStr = System.Configuration.ConfigurationManager.ConnectionStrings["eTagDB"].ConnectionString;     
       
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
                string sToUserEmail = (hdnTo.Value != null && hdnTo.Value != string.Empty) ? hdnTo.Value.ToString().Trim() : "";
                string sFromEmail = (hdnFrom.Value != null && hdnFrom.Value != string.Empty) ? hdnFrom.Value.ToString().Trim() : "";
                if (sFromEmail.Length > 0)
                {
                    FillGridEmailLog(sFromEmail, sToUserEmail);
                }

                string sFromUser = ddlUser.SelectedValue != "-1" ? ddlUser.SelectedValue : "";
                if (sFromUser != "")
                {                   
                    FillGridEmailUnsubscribe(sFromUser);
                }

            }

            catch (Exception ex)
            { }
        }      
        protected void gvContactList_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvContactList.PageIndex = e.NewPageIndex;
            string sToUserEmail = (hdnTo.Value != null && hdnTo.Value != string.Empty) ? hdnTo.Value.ToString().Trim() : "";
            string sFromEmail = (hdnFrom.Value != null && hdnFrom.Value != string.Empty) ? hdnFrom.Value.ToString().Trim() : "";
            if (sFromEmail.Length > 0)
            {
                FillGridEmailLog(sFromEmail, sToUserEmail);
            }
        }
        protected void gvContactList_Sorting(object sender, GridViewSortEventArgs e)
        {
            string sToUserEmail = (hdnTo.Value != null && hdnTo.Value != string.Empty) ? hdnTo.Value.ToString().Trim() : "";
            string sFromEmail = (hdnFrom.Value != null && hdnFrom.Value != string.Empty) ? hdnFrom.Value.ToString().Trim() : "";
            if (sFromEmail.Length > 0)
            {
                FillGridEmailLog(sFromEmail, sToUserEmail);
            }
        }
        protected void ddlUserTo_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                string sToUser = ddlUserTo.SelectedValue != "-1" ? ddlUserTo.SelectedValue : "";

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

                if (sFromEmail.Length > 0)
                {
                    FillGridEmailLog(sFromEmail, sToUserEmail);
                }

                string sFromUser = ddlUser.SelectedValue != "-1" ? ddlUser.SelectedValue : "";
                if (sFromUser != "")
                {
                    FillGridEmailUnsubscribe(ddlUser.SelectedValue);
                }
                    

            }
            catch (Exception ex)
            {

            }
        }
        protected void ddlUser_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                string sFromUser = ddlUser.SelectedValue != "-1" ? ddlUser.SelectedValue : "";

                if (sFromUser != "")
                {
                    UserProfile obj = new UserProfileDA().GetUserByUserID(Convert.ToInt32(sFromUser));
                    if (obj != null)
                    {
                        hdnFrom.Value = obj.Email != null ? obj.Email.Trim() : "";
                    }
                    else
                    {
                        hdnFrom.Value = "";
                    }
                   
                    FillContacts(Convert.ToInt32(sFromUser));
                    FillTemplateList(sFromUser);
                    FillGridEmailUnsubscribe(sFromUser);
                }
                else
                {
                    hdnFrom.Value = "";
                }


                string sToUserEmail = (hdnTo.Value != null && hdnTo.Value != string.Empty) ? hdnTo.Value.ToString().Trim() : "";

                string sFromEmail = (hdnFrom.Value != null && hdnFrom.Value != string.Empty) ? hdnFrom.Value.ToString().Trim() : "";

             

                if (sFromEmail.Length > 0)
                {
                    FillGridEmailLog(sFromEmail, sToUserEmail);
                }

            }
            catch (Exception ex)
            {
                hdnFrom.Value = "";
            }
        }
        protected void ddlTemplateNo_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                string sTemplate = ddlTemplateNo.SelectedValue != "-1" ? ddlTemplateNo.SelectedValue : "";

                if (sTemplate != "")
                {
                    string sToUserEmail = (hdnTo.Value != null && hdnTo.Value != string.Empty) ? hdnTo.Value.ToString().Trim() : "";
                    string sFromEmail = (hdnFrom.Value != null && hdnFrom.Value != string.Empty) ? hdnFrom.Value.ToString().Trim() : "";

                    if (sFromEmail.Length > 0)
                    {
                        FillGridEmailLog(sFromEmail, sToUserEmail);
                    }

                    string sFromUser = ddlUser.SelectedValue != "-1" ? ddlUser.SelectedValue : "";
                    if (sFromUser != "")
                    {
                        FillGridEmailUnsubscribe(ddlUser.SelectedValue);
                    }
                }  
            }
            catch (Exception ex)
            {

            }
        }
        protected void gvUserList_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvUserList.PageIndex = e.NewPageIndex;
            
            if (ddlUser.SelectedValue != "-1")
            {
                FillGridEmailUnsubscribe(ddlUser.SelectedValue);
            }
        }
        protected void gvUserList_Sorting(object sender, GridViewSortEventArgs e)
        {
            if (ddlUser.SelectedValue != "-1")
            {
                FillGridEmailUnsubscribe(ddlUser.SelectedValue);
            }
        }

        #endregion

        #region Method

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
        private void FillContacts(int nUserId)
        {
            try
            {
                ddlUserTo.Items.Clear();
                ddlUserTo.AppendDataBoundItems = true;
                ddlUserTo.Items.Add(new ListItem("Select Contact", "-1"));

                List<ContactInformation> objUsers = null;
                objUsers = new ContactInformationDA().GetAllContactsForSchedulerByUser(nUserId.ToString());

                if (objUsers != null && objUsers.Count > 0)
                {
                    Session["ContactList"] = objUsers;
                    foreach (ContactInformation obj in objUsers)
                    {
                        string sName = (obj.FirstName != null ? obj.FirstName.ToString() : "") + " " + (obj.LastName != null ? obj.LastName.ToString() : "");
                        ddlUserTo.Items.Add(new ListItem(sName, obj.Id.ToString()));
                    }
                }

                ddlUserTo.DataBind();
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
                ddlTemplateNo.Items.Add(new ListItem("All", "-1"));
                ddlTemplateNo.Items.Add(new ListItem("0", "0"));

                string sSQL = "select isnull(max(cast(TemplateNo as int)),0) TemplateNo from EmailSetup where UserId = '" + nUserId + "'";
                DataTable dtResult = SqlToTbl(sSQL);
                int nMaxNo = 0;

                if (dtResult != null && dtResult.Rows.Count > 0)
                {
                    nMaxNo = (dtResult.Rows[0]["TemplateNo"] != null && dtResult.Rows[0]["TemplateNo"] != DBNull.Value) ? Convert.ToInt32(dtResult.Rows[0]["TemplateNo"].ToString()) : 0;

                }

                if (nMaxNo > 0)
                {
                    for (int i = 1; i <= nMaxNo; i++)
                    {
                        ddlTemplateNo.Items.Add(new ListItem(i.ToString(), i.ToString()));
                    }
                }

                ddlTemplateNo.DataBind();
               

            }
            catch (Exception ex)
            {

            }
        }
        private void FillGridEmailLog(string From, string To)
        {
            try
            {
                string sWhere = " ";

                if ((!string.IsNullOrEmpty(From)) && From != "-1")
                {
                    sWhere += "  and FromEmail = '" + From + "'";
                }
                if ((!string.IsNullOrEmpty(To)) && To != "-1")
                {                    
                    sWhere += "  and PersonEmail = '" + To + "'";
                }

                if (ddlTemplateNo.SelectedValue  != "-1")
                {
                    sWhere += "  and EmailNumber = '" + ddlTemplateNo.SelectedValue + "'";
                }

                if (sWhere.Length > 0)
                {
                    string sSQL = " select FromEmail [From],PersonEmail [To],  EmailNumber [Template No],CONVERT(varchar, EmailSentOn, 100)  [Sent], Status, Category=(select isnull(max(Category),'') from emailsetup where Id = emaillog.TemplateId), Type=(select isnull(max(Type),'') from emailsetup where Id = emaillog.TemplateId) from EmailLog  where Id <> 0  " + sWhere + "   order by EmailSentOn desc, EmailNumber asc  ";

                    DataTable dtResult = SqlToTbl(sSQL);

                    gvContactList.DataSource = dtResult;
                    gvContactList.DataBind();

                }
            }
            catch (Exception e)
            {

            }
        }
        private void FillGridEmailUnsubscribe(string userId)
        {
            try
            {
                string sWhere = " ";
                string sUser = " ";
                if ((!string.IsNullOrEmpty(userId)) && userId != "-1")
                {
                    sUser  = "  and  userid='" + userId + "'";
                }
                
                if (ddlUserTo.SelectedValue != "-1")
                {
                    sWhere += "  and UserId = '" + ddlUserTo.SelectedValue + "'";
                }

                if (ddlTemplateNo.SelectedValue != "-1")
                {
                    sWhere += "  and TemplateNo = '" + ddlTemplateNo.SelectedValue + "'";
                }

                if (sWhere.Length > 0)
                {
                    string sSQL = " select   A.Name, A.TemplateNo, B.Category, B.Type from (select TemplateId, TemplateNo, Name =(select isnull(max(FirstName),'') + isnull(max(LastName),'') from ContactInformation where Id = EmailUnsubscribe.UserId) from EmailUnsubscribe where Id <> 0  " + sWhere + ") A inner join (select *  from emailsetup where Id <> 0 " + sUser + ") B on A.TemplateId = B.Id  ";

                    DataTable dtResult = SqlToTbl(sSQL);

                    gvUserList.DataSource = dtResult;
                    gvUserList.DataBind();

                }
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

        #endregion
    }
}