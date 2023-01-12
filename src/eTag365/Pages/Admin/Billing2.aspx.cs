using eTagService;
using eTagService.Enums;
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
    public partial class Billing : System.Web.UI.Page
    {
       
        public string isView = "true";
        public string sUserPhone = "";
        public string sUserType = "2";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                HttpContext.Current.Session["objPayment"] = null;

                string sessionid = System.Web.HttpContext.Current.Session.SessionID;
                if (!string.IsNullOrEmpty(sessionid))
                {
                    int userid = Utility.IntegerData("SELECT TOP 1 UserId FROM UserLog_Data Where SessionId='" + sessionid + "' Order By LogId DESC");
                    if (userid > 0)
                    {
                        UserProfile obj = new UserProfileDA().GetUserByUserID(userid);
                        if (obj != null)
                        {
                            Session["Phone"] = obj.Phone;
                            Session["UserId"] = obj.Id;

                            sUserPhone = obj.Phone;

                            spanAccount.InnerHtml = "<a style='color:#fff;' href='" + Utility.WebUrl + "/user?Top=1&UId=" + obj.Id.ToString() + "'>Account Profile </a>";
                            spanReset.InnerHtml = "<a class='btn btn-default btn-flat' href='" + Utility.WebUrl + "/reset-password'>Reset Password </a>";
                            spanSignOut.InnerHtml = "<a class='btn btn-default btn-flat' href='" + Utility.WebUrl + "/logout'>Sign out</a>";

                            if (obj.UserTypeContact != null)
                            {                                 
                                sUserType = obj.UserTypeContact;

                                if (obj.UserTypeContact == Convert.ToInt32(EnumUserType.Admin).ToString())
                                {
                                    liHeader.InnerHtml = "User: Admin";
                                    lihome.InnerHtml = "<a href='" + Utility.WebUrl + "/home'><i class='fa fa-circle-o'></i>Dashboard </a>";
                                    liImport.InnerHtml = "<a href='" + Utility.WebUrl + "/contact-import'><i class='fa fa-circle-o'></i>Import/Export Contact </a>";
                                    liUser.InnerHtml = "<a href='" + Utility.WebUrl + "/users'><i class='fa fa-circle-o'></i>Add/Change User Profile </a>";
                                    liPrice.InnerHtml = "<a href='" + Utility.WebUrl + "/user-pricing'><i class='fa fa-circle-o'></i>User Pricing</a>";
                                    liBilling.InnerHtml = "<a href='" + Utility.WebUrl + "/billing'><i class='fa fa-circle-o'></i>Billing Payment Options</a>";

                                    liDealer.InnerHtml = "<a href='" + Utility.WebUrl + "/dealer'><i class='fa fa-circle-o'></i>Dealer Dashboard </a>";
                                    liGroupCode.InnerHtml = "<a href='" + Utility.WebUrl + "/group-code'><i class='fa fa-circle-o'></i>Group Code Profile </a>";
                                    liSystemData.InnerHtml = "<a href='" + Utility.WebUrl + "/system'><i class='fa fa-circle-o'></i>System Data</a>";
                                    liGlobalSystemInfo.InnerHtml = "<a href='" + Utility.WebUrl + "/global-info'><i class='fa fa-circle-o'></i>Global eTag365 System Info</a>";
                                    lireset.InnerHtml = "<a href='" + Utility.WebUrl + "/reset-password'><i class='fa fa-circle-o'></i>Reset Password </a>";
                                }
                                else if (obj.UserTypeContact == Convert.ToInt32(EnumUserType.Dealer).ToString())
                                {
                                    liHeader.InnerHtml = "User: Dealer";
                                    liDealer.InnerHtml = "<a href='" + Utility.WebUrl + "/dealer'><i class='fa fa-circle-o'></i>Dealer Dashboard </a>";
                                }
                                else
                                {
                                    liHeader.InnerHtml = "User: Active";
                                    lihome.InnerHtml = "<a href='" + Utility.WebUrl + "/home'><i class='fa fa-circle-o'></i>Dashboard </a>";
                                    liPrice.InnerHtml = "<a href='" + Utility.WebUrl + "/user-pricing'><i class='fa fa-circle-o'></i>User Pricing</a>";
                                    liBilling.InnerHtml = "<a href='" + Utility.WebUrl + "/billing'><i class='fa fa-circle-o'></i>Billing Payment Options</a>";
                                    lireset.InnerHtml = "<a href='" + Utility.WebUrl + "/reset-password'><i class='fa fa-circle-o'></i>Reset Password </a>";
                                }
                            }

                            if (obj.IsBillingComplete != null)
                            {
                                isView = Convert.ToBoolean(obj.IsBillingComplete) == true ? "false" : "true";
                            }                          

                            if (!string.IsNullOrEmpty(obj.ProfileLogo))
                            {
                                imgTopLogo.ImageUrl = Utility.WebUrl + "/Uploads/Files/User/" + obj.ProfileLogo;
                                imgTopIcon.ImageUrl = Utility.WebUrl + "/Uploads/Files/User/" + obj.ProfileLogo;
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
                else
                {
                    Response.Redirect(Utility.WebUrl + "/login");
                }
            }
        }

        [WebMethod]
        public static string RewardByGroupCode(string code, string Plan)
       {
            GroupCodeDealerProfileDA da = new GroupCodeDealerProfileDA();
            GroupCode GroupCodeData = da.GetRewardByGroupCode(code, Plan);
            string sReward = string.Empty;
            if(GroupCodeData != null)
            {
                sReward = (GroupCodeData.Rewards != null && GroupCodeData.Rewards != 0) ? GroupCodeData.Rewards.ToString() : "0";
            }
           
            var jsonSerialiser = new JavaScriptSerializer();
            var json = jsonSerialiser.Serialize(sReward);
            return json;
        }

        [WebMethod]
        public static string DeletePaymentInformationById(string id)
        {
            PaymentInformationDA objPaymentInformationDA = new PaymentInformationDA();
            var bSuccess = objPaymentInformationDA.DeleteByID(Convert.ToInt32(id));

            var jsonSerialiser = new JavaScriptSerializer();
            var json = jsonSerialiser.Serialize(bSuccess);
            return json;
        }

        [WebMethod]
        public static string GetPaymentInformationData()
        {
            List<PaymentInformation> objPayments = null;
            if (HttpContext.Current.Session["UserId"] != null)
            {
                objPayments = new PaymentInformationDA().GetByUserId(HttpContext.Current.Session["UserId"].ToString());
            }

            var jsonSerialiser = new JavaScriptSerializer();
            var json = jsonSerialiser.Serialize(objPayments);
            return json;
        }

        [WebMethod]
        public static string GetPaymentInformationById(string id)
        {
            PaymentInformationDA objPaymentInformationDA = new PaymentInformationDA();
            PaymentInformation obj = objPaymentInformationDA.GetByID(Convert.ToInt32(id));          

            var jsonSerialiser = new JavaScriptSerializer();
            var json = jsonSerialiser.Serialize(obj);
            return json;
        }

        [WebMethod(EnableSession = true)]
        public static string SavePaymentInformation(PaymentInformation Obj)
        {
            bool isSaved = false;
            PaymentInformation objPaymentInformation = null;
            PaymentInformationDA objPaymentInformationDA = new PaymentInformationDA();
            if (Obj != null)
            {
                Obj.UserId = HttpContext.Current.Session["UserId"] != null ? HttpContext.Current.Session["UserId"].ToString() : "0";                   

                if(Obj.Id > 0)
                {
                    objPaymentInformation = objPaymentInformationDA.GetByID(Convert.ToInt32(Obj.Id));
                }
                
                if (objPaymentInformation != null && objPaymentInformation.Id > 0)
                {
                    isSaved = objPaymentInformationDA.Update(Obj);
                }
                else
                {                   
                    isSaved = objPaymentInformationDA.Insert(Obj);
                }
               
            }

            var jsonSerialiser = new JavaScriptSerializer();
            var json = jsonSerialiser.Serialize(isSaved);
            return json;
        }

        [WebMethod]
        public static string GetBillingInformationData()
        {
            BillingPayment objBillingPayment = null;
            if (HttpContext.Current.Session["UserId"] != null)
            {
                objBillingPayment = new BillingPaymentDA().GetbyUserID(HttpContext.Current.Session["UserId"].ToString());
            }

            var jsonSerialiser = new JavaScriptSerializer();
            var json = jsonSerialiser.Serialize(objBillingPayment);
            return json;
        }

        [WebMethod(EnableSession = true)]
        public static string Save(PaymentHistory obj)
        {
            bool bSuccess = true;

            if (obj != null)
            {
                try
                {
                  //  obj.Serial = new PaymentHistoryDA().MakeAutoGenerateSerial("I", "Billing");
                  //  obj.Getway = "Billing Payment";
                  //  obj.DebitAmount = 0;
                  //  obj.CreditAmount = Convert.ToDecimal(obj.GrossAmount);
                  ////  obj.CreateDate = DateTime.Now;
                  //  obj.Status = "pending";
                  //  obj.TransactionType = "SubscriptionFee";
                  //  obj.LedgerCode = "4060";
                  //  obj.Remarks = "SubscriptionFee";

                  //  if (obj.AccountType == "Check") 
                  //  {
                  //      if (obj.AccountNo != string.Empty && obj.AccountNo.Length > 4)
                  //      {
                  //          obj.AccountNo = obj.AccountNo.Substring(obj.AccountNo.Length - 4, 4);
                  //          obj.LastFourDigitCard = obj.AccountNo; 
                  //      }
                  //  }
                  //  else if (obj.AccountType == "Credit")
                  //  {
                  //      if (obj.CardNumber != string.Empty && obj.CardNumber.Length > 4)
                  //      {
                  //          obj.CardNumber = obj.CardNumber.Substring(obj.CardNumber.Length - 4, 4);
                  //          obj.LastFourDigitCard = obj.CardNumber;
                  //      }
                  //  }

                  //  double nBasic = 0, nYTD = 0, nMTD = 0;

                  //  if (obj.BasicAmount != null && obj.BasicAmount != "")
                  //  {
                  //      nBasic = Convert.ToDouble(obj.BasicAmount);
                  //      if(nBasic > 0)
                  //      {
                  //          nYTD = nBasic * 0.05;
                  //          nMTD = nYTD / 12;

                  //          obj.YTD_Commission = nYTD.ToString();
                  //          obj.MTD_Commission = nMTD.ToString();
                  //      }
                  //  }

                    HttpContext.Current.Session["objPayment"] = obj;                   

                }
                catch (Exception ex)
                {
                    bSuccess = true;
                }
            }

            var jsonSerialiser = new JavaScriptSerializer();
            var json = jsonSerialiser.Serialize(bSuccess);
            return json;
        }

        
    }
}