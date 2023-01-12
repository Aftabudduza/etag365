using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TagService.BO;
using TagService.DA;


namespace eTag365.Pages.Admin
{
    public partial class ContactHome : System.Web.UI.Page
    {
        public string sUrl = string.Empty;
        private string strImageFilePath = System.Configuration.ConfigurationManager.AppSettings.Get("ImageFilePath");
        private string strImageURL = System.Configuration.ConfigurationManager.AppSettings.Get("WebUrl");

        #region Events      
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session["ContactSearch"] = null;
                Session["UserId"] = null;
                Session["pagerSQL"] = null;
                string sessionid = System.Web.HttpContext.Current.Session.SessionID;
                if (!string.IsNullOrEmpty(sessionid))
                {
                    int userid = Utility.IntegerData("SELECT TOP 1 UserId FROM UserLog_Data Where SessionId='" + sessionid + "' Order By LogId DESC");

                    if (userid > 0)
                    {                       
                        Session["UserId"] = userid;
                        FillContacts();
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
                Session["ContactSearch"] = null;
                if (sSearch.Trim() != string.Empty)
                {
                    string strWhere = string.Empty;
                    strWhere = search.Value.ToString().Trim();
                    Session["ContactSearch"] = sSearch.Trim();

                    FillContacts();
                }
            }
            catch (Exception ex) { }
        }       

        protected void ddlSortBy_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (Session["pagerSQL"] != null)
            {
                string sSQL = string.Empty;
                string sSearchQuery = string.Empty;
                string sOrder = string.Empty;

                sSQL = Session["pagerSQL"].ToString();

                if (ddlSortBy.SelectedValue != "Id")
                {
                    sOrder = "  order by " + ddlSortBy.SelectedValue + " asc";
                }
                else
                {
                    sOrder = " order by  Id desc";
                }

                sSQL += sOrder;

                SqlDataSource1.SelectCommand = sSQL;

                Pager.PageSize = Convert.ToInt32(ddlPageSize.SelectedValue);
            }
        }
        protected void ddlPageSize_SelectedIndexChanged(object sender, EventArgs e)
        {
            if(Session["pagerSQL"] != null)
            {
                string sSQL = string.Empty;
                string sSearchQuery = string.Empty;
                string sOrder = string.Empty;

                sSQL = Session["pagerSQL"].ToString();

                if (ddlSortBy.SelectedValue != "Id")
                {
                    sOrder = "  order by " + ddlSortBy.SelectedValue + " asc";
                }
                else
                {
                    sOrder = " order by  Id desc";
                }

                sSQL += sOrder;

                SqlDataSource1.SelectCommand = sSQL;

                Pager.PageSize =  Convert.ToInt32(ddlPageSize.SelectedValue);
            }

        }
        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("/home");
        }

        #endregion

        #region Method

        private void FillContacts()
        {
            try
            {
              
                string sSQL = string.Empty;
                string sSearchQuery = string.Empty;
                string sOrder = string.Empty;

                if (ddlSortBy.SelectedValue != "Id")
                {
                    sOrder = "  order by " + ddlSortBy.SelectedValue + " asc";
                }
                else
                {
                    sOrder = " order by  Id desc";
                }

                if (Session["ContactSearch"] != null && Session["UserId"] != null)
                {
                    sSearchQuery = Session["ContactSearch"].ToString();
                    sSQL = " select *, UserImage=isnull((select Top 1 ProfileLogo from UserProfile where UserProfile.Phone = ContactInformation.Phone),''), CompanyLogo=isnull((select Top 1 CompanyLogo from UserProfile where UserProfile.Phone = ContactInformation.Phone),'') from  ContactInformation where UserID =  '" + Session["UserId"].ToString() + "'";
                    sSQL += " and (FirstName like '%" + sSearchQuery + "%' or LastName like '%" + sSearchQuery + "%'  or Companyname like '%" + sSearchQuery + "%'  or Email like '%" + sSearchQuery + "%'  or Phone like '%" + sSearchQuery + "%')";

                }
                else if (Session["UserId"] != null)
                {
                    sSQL = " select *, UserImage=isnull((select Top 1 ProfileLogo from UserProfile where UserProfile.Phone = ContactInformation.Phone),''), CompanyLogo=isnull((select Top 1 CompanyLogo from UserProfile where UserProfile.Phone = ContactInformation.Phone),'') from  ContactInformation where UserID =  '" + Session["UserId"].ToString() + "'";
                }

                Session["pagerSQL"] = sSQL;

                sSQL += sOrder;

                SqlDataSource1.SelectCommand = sSQL;

                Pager.PageSize = Convert.ToInt32(ddlPageSize.SelectedValue);

            }
            catch(Exception ex)
            {

            }
        }
        public string GetImageFileName(string image)
        {
            string sImageName = "";
            try
            {
                string strSQL = "";
                DataSet UserDS = new DataSet();
                string strImg = "";

                if (image.Length > 0)
                {
                    strImg = image.ToString().Trim();
                    string[] imgArray = null;
                    string sStr = "";
                    string sStrFile = "";


                    if (strImg.Length > 0)
                    {
                        if (!string.IsNullOrEmpty(strImageFilePath))
                            sStrFile = strImageFilePath + @"\Uploads\Files\User\" + strImg;
                        else
                            //sStrFile = @"C:\inetpub\wwwroot\Uploads\Files\User\" + strImg;
                            sStrFile = @"E:\Source\etag365\src\eTag365\Uploads\Files\User\" + strImg;

                        //string File = Path.Combine(strImageFilePath, image);                       

                        //if (!string.IsNullOrEmpty(strImg))
                        //    sStr = strImageURL + "/Uploads/Files/User/" + strImg;
                        //else
                        //    sStr = strImageURL + "/Uploads/Files/User/avatar.png";

                        if (System.IO.File.Exists(sStrFile))
                            sImageName = strImageURL + "/Uploads/Files/User/" + strImg;
                        
                           // sImageName = strImageURL + "/Uploads/Files/User/avatar.png";
                    }
                    else
                    {
                        //sImageName = strImageURL + "/Uploads/Files/User/avatar.png";
                    }
                        
                }
                else
                {
                    //sImageName = strImageURL + "/Uploads/Files/User/avatar.png";
                }
            }
            catch (Exception ex)
            {
                //sImageName = strImageURL + "/Uploads/Files/User/avatar.png";
            }

            return sImageName;
        }

        #endregion


    }
}