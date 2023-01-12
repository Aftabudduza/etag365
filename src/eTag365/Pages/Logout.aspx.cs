using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TagService.BO;

namespace eTag365.Pages
{
    public partial class Logout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {          
            DeleteLog();
            Session.Abandon();
            Session.Clear();

            Response.Redirect(Utility.WebUrl + "/login");
        }
        protected void DeleteLog()
        {
            int nUserID = Utility.IntegerData("SELECT TOP 1 UserId FROM UserLog_Data Where SessionId='" + System.Web.HttpContext.Current.Session.SessionID + "' Order By LogId DESC");
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["eTagDB"].ConnectionString);
            conn.Open();

            try
            {
                var selectString = "DELETE from [UserLog_Data] where UserId=@UserId";
                System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand(selectString, conn);
                cmd.Parameters.Add("UserId", System.Data.SqlDbType.Int).Value = nUserID;
                cmd.CommandText = selectString;
                cmd.ExecuteScalar();
                conn.Close();
            }
            catch (Exception ex)
            {
                conn.Close();
            }

          
        }
    }
}