using eTag365.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using TagService.BO;
using TagService.DA;

namespace eTag365.Pages.Admin
{
    public partial class GroupCodeDealerProfile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session["Phone"] = null;

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
        public static string GetData(GroupCode Obj)
        {
            GroupCodeDealerProfileDA da = new GroupCodeDealerProfileDA();
           // var lisiofGC = da.GetListOfGroupCode(Obj.GroupCodeFor);

            var lisiofGC = da.GetGroupCodeByUserType(Obj.GroupCodeFor, HttpContext.Current.Session["Phone"].ToString());

            var jsonSerialiser = new JavaScriptSerializer();
            var json = jsonSerialiser.Serialize(lisiofGC);
            return json;
        }
        [WebMethod]
        public static string SearchPhoneNumber(ViewGroupCodeModel Obj)
        {
            GroupCodeDealerProfileDA da = new GroupCodeDealerProfileDA();           
            var lisiofDlar = da.GetListOfDealerUserPhoneNo(Obj.autocompleteText, Obj.GroupCodeFor);
            
            var jsonSerialiser = new JavaScriptSerializer();
            var json = jsonSerialiser.Serialize(lisiofDlar);
            return json;
        }
        [WebMethod]
        public static string GetGroupCodeDetailsByGroupCodeId(GroupCode Obj)
        {
            GroupCodeDealerProfileDA da = new GroupCodeDealerProfileDA();
            GroupCode GroupCodeData = da.getGroupCodeInfo(Obj.Id);
            
            var jsonSerialiser = new JavaScriptSerializer();
            var json = jsonSerialiser.Serialize(GroupCodeData);
            return json;
        }
        [WebMethod]
        public static string DeleteGroupCodeDetailsByGroupCodeId(GroupCode Obj)
        {
            GroupCodeDealerProfileDA da = new GroupCodeDealerProfileDA();
            GroupCode DeleteGroupCodeData = da.DeleteGroupCodeInfo(Obj.Id, HttpContext.Current.Session["Phone"].ToString());

            var jsonSerialiser = new JavaScriptSerializer();
            var json = jsonSerialiser.Serialize(DeleteGroupCodeData);
            return json;
        }
        
        [WebMethod(EnableSession = true)]
        public static string Save(GroupCode Obj)
        {
            
            bool isSaved = false;
            GroupCode _GroupCodeInfo = new GroupCode();
            GroupCodeDealerProfileDA da = new GroupCodeDealerProfileDA();
            if (Obj != null)
            {
                isSaved = da.Save(Obj, HttpContext.Current.Session["Phone"].ToString());
            }
            var jsonSerialiser = new JavaScriptSerializer();
            var json = jsonSerialiser.Serialize(isSaved);
            return json;
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("/home");
        }
    }

}