using System;
using System.Data.SqlClient;

namespace eTag365
{
    public partial class EventConfirm : System.Web.UI.Page
    {
        public string conStr = System.Configuration.ConfigurationManager.ConnectionStrings["eTagDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int CId = 0;

                if (Request.QueryString["EvId"] != null)
                {

                    try
                    {
                        CId = Convert.ToInt32(Request.QueryString["EvId"].ToString());
                    }
                    catch (Exception ex)
                    {
                        CId = 0;
                    }
                }

               
                if (CId > 0)
                {
                    string SQLEvent = " update CalendarSchedule set IsSentEmail = '1'  where Id = " + CId;
                    SqlConnection conn = new SqlConnection(conStr);
                    conn.Open();
                    try
                    {
                        System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand(SQLEvent, conn);
                        cmd.ExecuteNonQuery();
                        cmd.Parameters.Clear();
                        cmd.Dispose();

                        Utility.DisplayMsg("You are Confirmed - Thank You !!", this);
                    }
                    catch (Exception ex)
                    {
                        Utility.DisplayMsg("Error in confirmation. Please try again !!", this);
                    }

                    conn.Close();
                }

            }

        }

    }
}