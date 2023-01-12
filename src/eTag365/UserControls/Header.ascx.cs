using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TagService.BO;
using TagService.DA;

namespace eTag365.UserControls
{
    public partial class Header : System.Web.UI.UserControl
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
                        UserProfile obj = new UserProfileDA().GetUserByUserID(userid);
                        if (obj != null)
                        {
                            spanAccount.InnerHtml = "<a style='color:#fff;' href='" + Utility.WebUrl + "/user?Top=1&UId=" + userid.ToString() + "'>Account Profile </a>";
                            spanReset.InnerHtml = "<a class='btn btn-default btn-flat' href='" + Utility.WebUrl + "/reset-password'>Reset Password </a>";
                            spanSignOut.InnerHtml = "<a class='btn btn-default btn-flat' href='" + Utility.WebUrl + "/logout'>Sign out</a>";

                            if (!string.IsNullOrEmpty(obj.ProfileLogo))
                            {
                                imgTopLogo.ImageUrl = Utility.WebUrl + "/Uploads/Files/User/" + obj.ProfileLogo;
                                imgTopIcon.ImageUrl = Utility.WebUrl + "/Uploads/Files/User/" + obj.ProfileLogo;
                            }
                        }
                    }                    
                }
            }
        }
    }
}