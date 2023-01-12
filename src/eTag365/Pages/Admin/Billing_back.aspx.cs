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
        public string api_loginID;
        public string utc_time = DateTime.UtcNow.Ticks.ToString();
        public string pay_now_single_return_string;
        Gateway.Signature cliSignature = new Gateway.Signature();     // This is the worker object that takes the values and performs functions.
        public string return_string = "Initial";
        public string source = "";
        string strLoginID = System.Configuration.ConfigurationManager.AppSettings.Get("LoginID");
        string strSecureKey = System.Configuration.ConfigurationManager.AppSettings.Get("ProcessingKey");
        public string sTotal = "{11.88, 4.99, 54.00, 9.99, 110.00,0|Basic (1 Year), Silver (1 Month), Silver (1 Year), Gold (1 Month), Gold (1 Year), Other}";
        //public string sTotal = "11.88";
        public string sBillingComplete = "0";
        public bool isView = true;

        public string sUserPhone = "";
        public string sUserType = "2";

        private static System.Net.Mail.SmtpClient objSmtpClient;
        private static System.Net.Mail.MailMessage objMailMessage;

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
                                isView = Convert.ToBoolean(obj.IsBillingComplete) == true ? false : true;
                            }

                            //if (obj.IsBillingComplete != null)
                            //{
                            //    if(Convert.ToBoolean(obj.IsBillingComplete) == true)
                            //    {
                            //        if (obj.SubscriptionExpiredOn != null)n[[
                            //        {
                            //            sBillingComplete = Convert.ToDateTime(obj.SubscriptionExpiredOn).Date >= DateTime.Now.Date ? "1" : "0";
                            //        }
                            //    }
                            //}


                            if (!string.IsNullOrEmpty(obj.ProfileLogo))
                            {
                                imgTopLogo.ImageUrl = Utility.WebUrl + "/Uploads/Files/User/" + obj.ProfileLogo;
                                imgTopIcon.ImageUrl = Utility.WebUrl + "/Uploads/Files/User/" + obj.ProfileLogo;
                            }

                            utc_time = DateTime.UtcNow.Ticks.ToString();
                            cliSignature.api_login_id = strLoginID;            //Add your API login ID.
                            cliSignature.secure_trans_key = strSecureKey;    //Add your secure transaction key.

                            cliSignature.pay_now_single_payment = cliSignature.api_login_id + "|sale|1.0|" + sTotal + "|" + utc_time + "|A1234||";
                            api_loginID = cliSignature.api_login_id;
                            pay_now_single_return_string = Gateway.EndPoint(cliSignature, "CREATESIGNATUREPAYSINGLEAMOUNT");
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
            bool bSuccess = false;

            if (obj != null)
            {
                try
                {
                    obj.Serial = new PaymentHistoryDA().MakeAutoGenerateSerial("I", "Billing");
                    obj.Getway = "Billing Payment";
                    obj.DebitAmount = 0;
                    obj.CreditAmount = Convert.ToDecimal(obj.GrossAmount);
                    obj.CreateDate = DateTime.Now;
                    obj.Status = "pending";
                    obj.TransactionType = "SubscriptionFee";
                    obj.LedgerCode = "4060";
                    obj.Remarks = "SubscriptionFee";

                    if (obj.AccountType == "Check") 
                    {
                        if (obj.AccountNo != string.Empty && obj.AccountNo.Length > 4)
                        {
                            obj.AccountNo = obj.AccountNo.Substring(obj.AccountNo.Length - 4, 4);
                            obj.LastFourDigitCard = obj.AccountNo; 
                        }
                    }
                    else if (obj.AccountType == "Credit")
                    {
                        if (obj.CardNumber != string.Empty && obj.CardNumber.Length > 4)
                        {
                            obj.CardNumber = obj.CardNumber.Substring(obj.CardNumber.Length - 4, 4);
                            obj.LastFourDigitCard = obj.CardNumber;
                        }
                    }

                    double nBasic = 0, nYTD = 0, nMTD = 0;

                    if (obj.BasicAmount != null && obj.BasicAmount != "")
                    {
                        nBasic = Convert.ToDouble(obj.BasicAmount);
                        if(nBasic > 0)
                        {
                            nYTD = nBasic * 0.05;
                            nMTD = nYTD / 12;

                            obj.YTD_Commission = nYTD.ToString();
                            obj.MTD_Commission = nMTD.ToString();
                        }
                    }

                    try
                    {
                        if (obj.Id > 0)
                        {                           
                            var ExistingHistory = new PaymentHistoryDA().GetbyID(Convert.ToInt32(obj.Id));
                            if (ExistingHistory != null)
                            {
                                if (new PaymentHistoryDA().DeleteByID(Convert.ToInt32(ExistingHistory.Id)))
                                {
                                   
                                }
                            }                            
                        }
                       
                        bSuccess =  new PaymentHistoryDA().Insert(obj);

                        if (bSuccess)
                        {
                            if (SendEmailToAdmin(obj))
                            {

                            }
                        }
                    }
                    catch (Exception ex)
                    {

                    }

                }
                catch (Exception ex)
                {
                    bSuccess = false;
                }
            }

            var jsonSerialiser = new JavaScriptSerializer();
            var json = jsonSerialiser.Serialize(bSuccess);
            return json;
        }
        public static bool SendEmailToAdmin(PaymentHistory obj)
        {
            bool IsSentSuccessful = false;
            try
            {
                String strMailServer = string.Empty;
                String strMailUser = string.Empty;
                String strMailPassword = string.Empty;
                String strMailPort = System.Configuration.ConfigurationManager.AppSettings.Get("strMailPort");
                String isMailLive = System.Configuration.ConfigurationManager.AppSettings.Get("isMailLive");

                strMailUser = System.Configuration.ConfigurationManager.AppSettings.Get("strMailUser");
                strMailPassword = System.Configuration.ConfigurationManager.AppSettings.Get("strMailPassword");
                strMailServer = System.Configuration.ConfigurationManager.AppSettings.Get("strMailServer");

                if (isMailLive == "true")
                {
                    objSmtpClient = new System.Net.Mail.SmtpClient(strMailServer, Convert.ToInt32(strMailPort));
                    objSmtpClient.UseDefaultCredentials = false;
                    objSmtpClient.Credentials = new System.Net.NetworkCredential(strMailUser, strMailPassword);
                }
                else
                {
                    objSmtpClient = new System.Net.Mail.SmtpClient("smtp.gmail.com", 587);
                    objSmtpClient.UseDefaultCredentials = false;
                    objSmtpClient.EnableSsl = true;
                    objSmtpClient.Credentials = new System.Net.NetworkCredential("info.visaformalaysia@gmail.com", "admin_321");
                }

                string from_address = "";
                string to_address = "";
                string bcc_address = "aftabudduza@gmail.com";

                from_address = System.Configuration.ConfigurationManager.AppSettings.Get("fromAddress");


                try
                {
                    to_address = System.Configuration.ConfigurationManager.AppSettings.Get("ccAddress");
                }
                catch (Exception e)
                {
                    to_address = "info@etag365.com";
                }

                objMailMessage = new System.Net.Mail.MailMessage();
                objMailMessage.From = new System.Net.Mail.MailAddress(from_address, "eTag365 Support");
                objMailMessage.To.Add(new System.Net.Mail.MailAddress(to_address));
                objMailMessage.Bcc.Add(new System.Net.Mail.MailAddress(bcc_address));
                objMailMessage.Subject = "New Billing Payment request from eTag365";
                objMailMessage.IsBodyHtml = true;
                objMailMessage.Body = EmailHtmlToAdmin(obj).ToString();
                objSmtpClient.Send(objMailMessage);

                IsSentSuccessful = true;

            }
            catch (Exception ex)
            {

            }

            finally
            {
                if ((objSmtpClient == null) == false)
                {
                    objSmtpClient = null;
                }

                if ((objMailMessage == null) == false)
                {
                    objMailMessage.Dispose();
                    objMailMessage = null;
                }
            }

            return IsSentSuccessful;
        }
        public static System.Text.StringBuilder EmailHtmlToAdmin(PaymentHistory obj)
        {
            System.Text.StringBuilder emailbody = new System.Text.StringBuilder();
            string sWeb = System.Configuration.ConfigurationManager.AppSettings.Get("WebUrl");
            string sUrl = sWeb + "/login";
           
            try
            {
                emailbody.Append("<table>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'><img  alt='eTag365' width='120' src='" + sWeb + "/Images/logo.png'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2' style='text-align:Left;font-size:14px;font-weight:bold;color:0000cc;'>Dear Admin</td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'><p>eTag365 has received Billing payment. </p> </td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td>Transaction Id: </td><td> " + (obj.TransactionCode != null ? obj.TransactionCode.ToString() : "") + " </td></tr>");
                emailbody.Append("<tr><td>Account Name: </td><td> " + (obj.AccountName != null ? obj.AccountName.ToString() : "") + " </td></tr>");
                emailbody.Append("<tr><td>Address: </td><td> " + (obj.Address != null ? obj.Address.ToString() : "") + " </td></tr>");
                emailbody.Append("<tr><td>City: </td><td> " + (obj.City != null ? obj.City.ToString() : "") + " </td></tr>");
                emailbody.Append("<tr><td>State: </td><td> " + (obj.State != null ? obj.State.ToString() : "") + " </td></tr>");
                emailbody.Append("<tr><td>Zip: </td><td> " + (obj.Zip != null ? obj.Zip.ToString() : "") + " </td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td>Last 4 Digit: </td><td> " + (obj.LastFourDigitCard != null ? obj.LastFourDigitCard.ToString() : "") + " </td></tr>");
                emailbody.Append("<tr><td>Amount: </td><td> " + (obj.GrossAmount != null ? obj.GrossAmount.ToString() : "") + " </td></tr>");
                emailbody.Append("<tr><td>Authorization Code: </td><td> " + (obj.AuthorizationCode != null ? obj.AuthorizationCode.ToString() : "") + " </td></tr>");
                emailbody.Append("<tr><td>Transaction Description: </td><td> " + (obj.TransactionDescription != null ? obj.TransactionDescription.ToString() : "") + " </td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'>Best regards</td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'><p>eTag365 Team</p> </td></tr>");
                emailbody.Append("</table>");
            }
            catch (Exception ex)
            {
            }
            return emailbody;
        }

        //[WebMethod]
        //public static string GetTotalAmount(string id)
        //{

        //    sTotal = Convert.ToDouble(id).ToString();

        //    var jsonSerialiser = new JavaScriptSerializer();
        //    var json = jsonSerialiser.Serialize(sTotal);
        //    return json;
        //}
    }
}