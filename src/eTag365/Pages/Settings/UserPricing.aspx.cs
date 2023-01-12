using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TagService.BO;
using System.Web.Script.Serialization;
using System.Web.Services;
using TagService.DA;


namespace eTag365.Pages.Settings
{
    public partial class UserPricing : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string sessionid = System.Web.HttpContext.Current.Session.SessionID;
                if (!string.IsNullOrEmpty(sessionid))
                {
                    int userid = Utility.IntegerData("SELECT TOP 1 UserId FROM UserLog_Data Where SessionId='" + sessionid + "' Order By LogId DESC");
                    
                    if (userid > 0)
                    {
                      
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
        public static string GetData()
        {
            UserPricingDA da = new UserPricingDA();
            var lisiofUserPrice = da.GetListOfUserPricing();
            
            var jsonSerialiser = new JavaScriptSerializer();
            var json = jsonSerialiser.Serialize(lisiofUserPrice);
            return json;
        }
        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("/home");
        }
    }
}