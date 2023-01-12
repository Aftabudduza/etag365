using System;
using System.Data.SqlClient;

namespace eTag365
{
    public partial class EmailUnsubscribe : System.Web.UI.Page
    {
        public string conStr = System.Configuration.ConfigurationManager.ConnectionStrings["eTagDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int CId = 0, TId = 0, SId = 0;

                if (Request.QueryString["EId"] != null)
                {

                    try
                    {
                        CId = Convert.ToInt32(Request.QueryString["EId"].ToString());
                    }
                    catch (Exception ex)
                    {
                        CId = 0;
                    }
                }

                if (Request.QueryString["TId"] != null)
                {
                    try
                    {
                        TId = Convert.ToInt32(Request.QueryString["TId"].ToString());
                    }
                    catch (Exception ex)
                    {
                        TId = 0;
                    }
                }

                if (Request.QueryString["SId"] != null)
                {

                    try
                    {
                        SId = Convert.ToInt32(Request.QueryString["SId"].ToString());
                    }
                    catch (Exception ex)
                    {
                        SId = 0;
                    }
                }


                if (CId > 0 || TId > 0)
                {
                    string SQLMail = " update ContactInformation set IsEmailFlow = '0'  where Id = " + CId;

                    string SQLMailU = "insert into EmailUnsubscribe(TemplateNo, UserId, TemplateId) values('" + TId.ToString() + "', '" + CId.ToString() + "', '" + SId.ToString() + "')";

                    SqlConnection conn = new SqlConnection(conStr);
                    conn.Open();

                    try
                    {
                        System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand(SQLMailU, conn);
                        cmd.ExecuteNonQuery();
                        cmd.Parameters.Clear();
                        cmd.Dispose();                       
                    }
                    catch (Exception ex)
                    {

                    }

                    try
                    {
                        System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand(SQLMail, conn);
                        cmd.ExecuteNonQuery();
                        cmd.Parameters.Clear();
                        cmd.Dispose();

                        Utility.DisplayMsg("Unsubscribed successfully!", this);
                    }
                    catch (Exception ex)
                    {

                    }

                    conn.Close();
                }

            }

        }

    }
}