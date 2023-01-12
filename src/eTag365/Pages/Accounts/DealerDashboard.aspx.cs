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


namespace eTag365.Pages.Accounts
{
    public partial class DealerDashboard : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session["Phone"] = null;
                Session["UserType"] = null;

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
                            Session["UserType"] = (objTemp.IsAdmin != null && Convert.ToBoolean(objTemp.IsAdmin) == true? "1" : "0");
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
        public static string GetData()
        {
            SalesPartnerDealerDashboardDA da = new SalesPartnerDealerDashboardDA();
            ViewDealerModel obj = new ViewDealerModel();

            if (HttpContext.Current.Session["Phone"] != null)
            {
                var listOfDealar = da.GetListOfDealerInfo(HttpContext.Current.Session["Phone"].ToString());
                listOfDealar.ForEach(x => x.Password = Utility.base64Decode(x.Password));
                var serial = da.MakeAutoGenerateSerial("1", "Dealer");
                var userType = HttpContext.Current.Session["UserType"].ToString();


                obj.UserType = userType;
                obj.listOfDealer = listOfDealar;
                obj.Serial = serial;
            }
          
            var jsonSerialiser = new JavaScriptSerializer();
            var json = jsonSerialiser.Serialize(obj);
            return json;
        }
        [WebMethod]
        public static string GetDealerDetailsByDealerId(Dealer_SalesPartner Obj)
        {
            SalesPartnerDealerDashboardDA da = new SalesPartnerDealerDashboardDA();
            Dealer_SalesPartner DealerDetailsData = da.getDealerInfo(Obj.id);

            string pass = da.GetUserProfilePassword(DealerDetailsData.primaryPhoneNo);
            ViewDealerModel obj = new ViewDealerModel();
            obj.Dealer_SalesPartner = DealerDetailsData;
            obj.Password = pass;

            var jsonSerialiser = new JavaScriptSerializer();
            var json = jsonSerialiser.Serialize(obj);
            return json;
        }
        [WebMethod]
        public static string AddZipCode(Dealer_SalesPartner_DetailsZipCodeCoverage Obj)
        {
            SalesPartnerDealerDashboardDA da = new SalesPartnerDealerDashboardDA();
            bool isSaved = da.SaveZipCodeCoverage(Obj);           

            var jsonSerialiser = new JavaScriptSerializer();
            var json = jsonSerialiser.Serialize(isSaved);
            return json;
        }
        //AddZipCode
        [WebMethod]
        public static string GetZipCodeCoverage(Dealer_SalesPartner Obj)
        {
            SalesPartnerDealerDashboardDA da = new SalesPartnerDealerDashboardDA();
            List<Dealer_SalesPartner_DetailsZipCodeCoverage> DealerDetailsData = da.getZipCodeDetails(Obj.serialCode);

            var jsonSerialiser = new JavaScriptSerializer();
            var json = jsonSerialiser.Serialize(DealerDetailsData);
            return json;
        }
        [WebMethod]
        public static string DeleteZipCodeData(Dealer_SalesPartner_DetailsZipCodeCoverage Obj)
        {
            SalesPartnerDealerDashboardDA da = new SalesPartnerDealerDashboardDA();
            var  DealerDetailsData = da.DeleteZipCode(Obj.id);

            var jsonSerialiser = new JavaScriptSerializer();
            var json = jsonSerialiser.Serialize(DealerDetailsData);
            return json;
        }
        //DeleteZipCodeData
        //GetZipCodeCoverage
        [WebMethod(EnableSession = true)]
        public static string Save(ViewDealerModel Obj)
        {
            bool isSave = false;
            Dealer_SalesPartner _dealerinfo = new Dealer_SalesPartner();
            SalesPartnerDealerDashboardDA da = new SalesPartnerDealerDashboardDA();          
            if (Obj != null)
            {
                Obj.Dealer_SalesPartner.createDate = DateTime.Now;
                Obj.Password= Utility.base64Encode(Obj.Password);
                 isSave = da.Save(Obj.Dealer_SalesPartner,Obj.Password, HttpContext.Current.Session["Phone"].ToString());
            }
            var jsonSerialiser = new JavaScriptSerializer();
            var json = jsonSerialiser.Serialize(isSave);
            return json;
        }
        [WebMethod(EnableSession = true)]
        public static string GetCommissionData(ViewDealerModel Obj)
        {
            SalesPartnerDealerDashboardDA da = new SalesPartnerDealerDashboardDA();
            var res = da.GetCommission(Obj.id);
            var jsonSerialiser = new JavaScriptSerializer();
            var json = jsonSerialiser.Serialize(res);
            return json;
        }

        [WebMethod(EnableSession = true)]
        public static string GetUserData(string phone)
        {
            SalesPartnerDealerDashboardDA da = new SalesPartnerDealerDashboardDA();
            var res = da.GetUserInfoByDealer(phone);
            var jsonSerialiser = new JavaScriptSerializer();
            var json = jsonSerialiser.Serialize(res);
            return json;
        }
        //GetCommissionDetails
        [WebMethod(EnableSession = true)]
        public static string GetCommissionDetailsData(ViewDealerModel Obj)
        {
            SalesPartnerDealerDashboardDA da = new SalesPartnerDealerDashboardDA();
            var res = da.GetCommissionDetails(Obj.Month,Obj.Year,Obj.IsPaid, Obj.id);
            var jsonSerialiser = new JavaScriptSerializer();
            var json = jsonSerialiser.Serialize(res);
            return json;
        }

        [WebMethod]
        public static string ExistDealer(string phone, string serial)
        {
            bool isFound = false;
            UserProfileDA da = new UserProfileDA();
            UserProfile objUser = da.GetExistingUserByPhoneAndSerial(phone, serial);
         
            if (objUser != null && objUser.Id > 0)
            {
                isFound = true;
            }

            var jsonSerialiser = new JavaScriptSerializer();
            var json = jsonSerialiser.Serialize(isFound);
            return json;
        }
    }
}

//$(".tDate").datepicker().datepicker("setDate", new Date());