using eTag365.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using TagService.BO;
using TagService.DA;

namespace eTag365.Pages.Accounts
{
    public partial class MyReferralView : System.Web.UI.Page
    {
        public static string conStr = System.Configuration.ConfigurationManager.ConnectionStrings["eTagDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session["Phone"] = null;
              //  Session["UserType"] = null;

                string sessionid = System.Web.HttpContext.Current.Session.SessionID;
                if (!string.IsNullOrEmpty(sessionid))
                {
                    int userid = Utility.IntegerData("SELECT TOP 1 UserId FROM UserLog_Data Where SessionId='" + sessionid + "' Order By LogId DESC");

                    if (userid > 0)
                    {
                        UserProfile objTemp = new UserProfileDA().GetUserByUserID(userid);
                        if (objTemp != null)
                        {
                            Session["Phone"] = objTemp.Phone;
                          //  Session["UserType"] = objTemp.UserTypeContact;
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

        [WebMethod]
        public static string GetEarnedMoneyDetails()
        {
            //MyReferralViewDA da = new MyReferralViewDA();
            var currentUser = HttpContext.Current.Session["Phone"].ToString();
            //var amount = da.getTotalEarn(currentUser);
            //getTotalEarn

            var amount = "";

            string sSQL = " select isnull(sum(cast(YTD_CommissionOwed as money)),0) - isnull(sum(cast(YTD_CommissionPaid as money)),0) YTD_CommissionOwed from  ReferralAccount where GetterPhone = '" + currentUser + "'";

            DataTable dtResult = SqlToTbl(sSQL);
            if (dtResult != null && dtResult.Rows.Count > 0)
            {
                amount = (dtResult.Rows[0]["YTD_CommissionOwed"] != null && dtResult.Rows[0]["YTD_CommissionOwed"] != DBNull.Value)
                    ? dtResult.Rows[0]["YTD_CommissionOwed"].ToString()
                    : "";
            }

            var jsonSerialiser = new JavaScriptSerializer();
            var json = jsonSerialiser.Serialize(amount);
            return json;
        }
        [WebMethod]
        public static string GetDetailsCommission(Search Obj)
        {
            MyReferralViewDA da = new MyReferralViewDA();
            var currentUser = HttpContext.Current.Session["Phone"].ToString();
            var res =da.getAllCommissionDetails(Obj.StartDate,Obj.EndDate, currentUser, "User");
            var jsonSerialiser = new JavaScriptSerializer();
            var json = jsonSerialiser.Serialize(res);
            return json;
        }

        public static DataTable SqlToTbl(string strSqlRec)
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