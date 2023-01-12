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
    public partial class Checkout : System.Web.UI.Page
    {
        public string api_loginID;
        public string utc_time = DateTime.UtcNow.Ticks.ToString();
        public string pay_now_single_return_string;
        Gateway.Signature cliSignature = new Gateway.Signature();     // This is the worker object that takes the values and performs functions.
       
        string strLoginID = System.Configuration.ConfigurationManager.AppSettings.Get("LoginID");
        string strSecureKey = System.Configuration.ConfigurationManager.AppSettings.Get("ProcessingKey");
        public string sTotal = "0.01";
       
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
                            FillMenu(obj);
                            PaymentHistory objPaymentHistory = null;
                            if (HttpContext.Current.Session["objPayment"] != null)
                            {
                                objPaymentHistory = ((PaymentHistory)HttpContext.Current.Session["objPayment"]);
                                if(objPaymentHistory != null)
                                {
                                    sTotal = !string.IsNullOrEmpty(objPaymentHistory.GrossAmount) ? objPaymentHistory.GrossAmount : "0.01";
                                }
                            }

                        }
                        else
                        {
                           // Response.Redirect(Utility.WebUrl + "/login");
                        }
                    }
                    else
                    {
                       // Response.Redirect(Utility.WebUrl + "/login");
                    }
                }
                else
                {
                   // Response.Redirect(Utility.WebUrl + "/login");
                }

                utc_time = DateTime.UtcNow.Ticks.ToString();
                cliSignature.api_login_id = strLoginID;            //Add your API login ID.
                cliSignature.secure_trans_key = strSecureKey;    //Add your secure transaction key.

                cliSignature.pay_now_single_payment = cliSignature.api_login_id + "|sale|1.0|" + sTotal + "|" + utc_time + "|A1234||";
                api_loginID = cliSignature.api_login_id;
                pay_now_single_return_string = Gateway.EndPoint(cliSignature, "CREATESIGNATUREPAYSINGLEAMOUNT");
            }
        }       
        [WebMethod]
        public static string GetPaymentHistoryData()
        {
            PaymentHistory objPaymentHistory = null;
            if (HttpContext.Current.Session["objPayment"] != null)
            {
                objPaymentHistory = ((PaymentHistory)HttpContext.Current.Session["objPayment"]);
            }

            var jsonSerialiser = new JavaScriptSerializer();
            var json = jsonSerialiser.Serialize(objPaymentHistory);
            return json;
        }
        [WebMethod(EnableSession = true)]
        public static string Save(PaymentHistory obj)
        {
            bool bSuccess = false;
            double nBasic = 0, nYTD = 0, nMTD = 0, nGross = 0;
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

                    if (obj.GrossAmount != null && obj.GrossAmount != "")
                    {
                        nGross = Convert.ToDouble(obj.GrossAmount);
                    }

                    if (nGross > 0)
                    {
                        nYTD = nGross * 0.05;
                        nMTD = nYTD / 12;

                        obj.YTD_Commission = nYTD.ToString("0.00");
                        obj.MTD_Commission = obj.IsBillingCycleMonthly == false ? nMTD.ToString("0.00") : nYTD.ToString("0.00");
                    }
                    else
                    {
                        obj.YTD_Commission = nYTD.ToString("0.00");
                        obj.MTD_Commission = nMTD.ToString("0.00");
                    }
                   
                    if (nGross <= 0)
                    {
                        obj.AccountType = "";
                        obj.AccountNo = "";
                        obj.RoutingNo = "";
                        obj.CheckNo = "";
                        obj.CardNumber = "";
                        obj.LastFourDigitCard = "";
                        obj.CVS = "";
                        obj.Month = "";
                        obj.Year = "";
                    }
                    else
                    {
                        if (obj.AccountType == "Check")
                        {
                            if (obj.AccountNo != string.Empty && obj.AccountNo.Length > 4)
                            {
                                obj.AccountNo = obj.AccountNo.Substring(obj.AccountNo.Length - 4, 4);
                                obj.LastFourDigitCard = obj.AccountNo;
                            }
                            else
                            {
                                obj.AccountNo = "";
                                obj.LastFourDigitCard = "";
                                obj.RoutingNo = "";
                                obj.CheckNo = "";
                            }
                        }
                        else if (obj.AccountType == "Credit")
                        {
                            if (obj.CardNumber != string.Empty && obj.CardNumber.Length > 4)
                            {
                                obj.CardNumber = obj.CardNumber.Substring(obj.CardNumber.Length - 4, 4);
                                obj.LastFourDigitCard = obj.CardNumber;
                            }
                            else
                            {
                                obj.CardNumber = "";
                                obj.LastFourDigitCard = "";
                                obj.CVS = "";
                                obj.Month = "";
                                obj.Year = "";
                            }
                        }
                    }

                    try
                    {
                        if (obj.Id > 0)
                        {                           
                            var existingHistory = new PaymentHistoryDA().GetbyID(Convert.ToInt32(obj.Id));
                            if (existingHistory != null)
                            {
                                if (new PaymentHistoryDA().DeleteByID(Convert.ToInt32(existingHistory.Id)))
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
                string strMailServer = string.Empty;
                string strMailUser = string.Empty;
                string strMailPassword = string.Empty;
                string strMailPort = System.Configuration.ConfigurationManager.AppSettings.Get("strMailPort");
                string isMailLive = System.Configuration.ConfigurationManager.AppSettings.Get("isMailLive");

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
                string bcc_address = System.Configuration.ConfigurationManager.AppSettings.Get("bccAddress");

                from_address = System.Configuration.ConfigurationManager.AppSettings.Get("fromAddress");


                try
                {
                    to_address = System.Configuration.ConfigurationManager.AppSettings.Get("toAddress");
                }
                catch (Exception e)
                {
                    to_address = "sbutcher@etag365.com";
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
                emailbody.Append("<tr><td colspan='2' style='text-align:Left;font-size:14px;font-weight:bold;color:0000cc;'>Dear User</td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'><p>eTag365 has received new Billing payment. </p> </td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td>Transaction Id: </td><td> " + (obj.TransactionCode != null ? obj.TransactionCode.ToString() : "") + " </td></tr>");
                emailbody.Append("<tr><td>Account Name: </td><td> " + (obj.AccountName != null ? obj.AccountName.ToString() : "") + " </td></tr>");
                emailbody.Append("<tr><td>Address: </td><td> " + (obj.Address != null ? obj.Address.ToString() : "") + " </td></tr>");
                emailbody.Append("<tr><td>City: </td><td> " + (obj.City != null ? obj.City.ToString() : "") + " </td></tr>");
                emailbody.Append("<tr><td>State: </td><td> " + ((obj.State != null && obj.State != "-1") ? obj.State.ToString() : "") + " </td></tr>");
                emailbody.Append("<tr><td>Zip: </td><td> " + (obj.Zip != null ? obj.Zip.ToString() : "") + " </td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td>Last 4 Digit: </td><td> " + (obj.LastFourDigitCard != null ? obj.LastFourDigitCard.ToString() : "") + " </td></tr>");
                emailbody.Append("<tr><td>Amount: </td><td> $" + (obj.GrossAmount != null ? obj.GrossAmount.ToString() : "") + " </td></tr>");
                emailbody.Append("<tr><td>Authorization Code: </td><td> " + (obj.AuthorizationCode != null ? obj.AuthorizationCode.ToString() : "") + " </td></tr>");
                emailbody.Append("<tr><td>Transaction Description: </td><td> " + (obj.TransactionDescription != null ? obj.TransactionDescription.ToString() : "") + " </td></tr>");
                emailbody.Append("<tr><td>Transaction Date: </td><td> " + (obj.CreateDate != null ? Convert.ToDateTime(obj.CreateDate).ToString("MM/dd/yyyy hh:mm:ss tt") : "") + " </td></tr>");
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

        private void FillMenu(UserProfile obj)
        {
            try
            {
                if (obj != null)
                {
                    spanAccount.InnerHtml = "<a style='color:#fff;' href='" + Utility.WebUrl + "/user?Top=1&UId=" + obj.Id.ToString() + "'>Account Profile </a>";
                    spanReset.InnerHtml = "<a class='btn btn-default btn-flat' href='" + Utility.WebUrl + "/reset-password'>Reset Password </a>";
                    spanSignOut.InnerHtml = "<a class='btn btn-default btn-flat' href='" + Utility.WebUrl + "/logout'>Sign out</a>";

                    bool bIsAdmin = false;

                    bIsAdmin = (obj.IsAdmin != null && Convert.ToBoolean(obj.IsAdmin) == true) ? true : false;

                    if (obj.UserTypeContact != null)
                    {
                        if (obj.UserTypeContact == Convert.ToInt32(EnumUserType.Admin).ToString())
                        {
                            liHeader.InnerHtml = "User: Admin";
                            lihome.InnerHtml = "<a href='" + Utility.WebUrl + "/home'><i class='fa fa-circle-o'></i>Dashboard </a>";
                            liImport.InnerHtml = "<a href='" + Utility.WebUrl + "/contact-import'><i class='fa fa-circle-o'></i>Import / Export Contacts </a>";

                            liUser.InnerHtml = "<a href='" + Utility.WebUrl + "/users'><i class='fa fa-circle-o'></i>Add/Change User Profile </a>";
                            liPrice.InnerHtml = "<a href='" + Utility.WebUrl + "/user-pricing'><i class='fa fa-circle-o'></i>User Pricing</a>";
                            liBilling.InnerHtml = "<a href='" + Utility.WebUrl + "/billing'><i class='fa fa-circle-o'></i>Billing Payment Options</a>";
                            liReferral.InnerHtml = "<a href='" + Utility.WebUrl + "/referral-report'><i class='fa fa-circle-o'></i>My Referral View & Report </a>";
                            liDealer.InnerHtml = "<a href='" + Utility.WebUrl + "/dealer'><i class='fa fa-circle-o'></i>Dealer Dashboard </a>";
                            liGroupCode.InnerHtml = "<a href='" + Utility.WebUrl + "/group-code'><i class='fa fa-circle-o'></i>Group Code Profile </a>";
                            liSystemData.InnerHtml = "<a href='" + Utility.WebUrl + "/system'><i class='fa fa-circle-o'></i>System Data</a>";
                            liGlobalSystemInfo.InnerHtml = "<a href='" + Utility.WebUrl + "/global-info'><i class='fa fa-circle-o'></i>Global eTag365 System Info</a>";
                            lireset.InnerHtml = "<a href='" + Utility.WebUrl + "/reset-password'><i class='fa fa-circle-o'></i>Reset Password </a>";
                            liApproveBillingTransaction.InnerHtml = "<a href='" + Utility.WebUrl + "/approvetransaction'><i class='fa fa-circle-o'></i>Approve Billing Transactions </a>";

                            liPayCommission.InnerHtml = "<a href='" + Utility.WebUrl + "/pay'><i class='fa fa-circle-o'></i>Pay Commissions</a>";
                            liApproveCommission.InnerHtml = "<a href='" + Utility.WebUrl + "/approve'><i class='fa fa-circle-o'></i>Approve Commissions</a>";

                            liEmailSetup.InnerHtml = "<a href='" + Utility.WebUrl + "/email-setup'><i class='fa fa-circle-o'></i>Email Template Setup </a>";
                            liEmailSchedule.InnerHtml = "<a href='" + Utility.WebUrl + "/email-scheduler'><i class='fa fa-circle-o'></i>Email Scheduler </a>";
                        }
                        else if (obj.UserTypeContact == Convert.ToInt32(EnumUserType.Dealer).ToString())
                        {
                            liHeader.InnerHtml = "User: Dealer";
                            liDealer.InnerHtml = "<a href='" + Utility.WebUrl + "/dealer'><i class='fa fa-circle-o'></i>Dealer Dashboard </a>";
                            liDealerCommission.InnerHtml = "<a href='" + Utility.WebUrl + "/dealer'><i class='fa fa-circle-o'></i>Dealer Commission </a>";
                            liDealerAccounts.InnerHtml = "<a href='" + Utility.WebUrl + "/dealer'><i class='fa fa-circle-o'></i>Dealer Accounts </a>";
                            liDealerProfile.InnerHtml = "<a href='" + Utility.WebUrl + "/dealer'><i class='fa fa-circle-o'></i>Dealer Profile </a>";
                            lireset.InnerHtml = "<a href='" + Utility.WebUrl + "/reset-password'><i class='fa fa-circle-o'></i>Reset Password </a>";
                        }
                        else
                        {
                            liHeader.InnerHtml = "User: Active";
                            lihome.InnerHtml = "<a href='" + Utility.WebUrl + "/home'><i class='fa fa-circle-o'></i>Dashboard </a>";
                            liImport.InnerHtml = "<a href='" + Utility.WebUrl + "/contact-import'><i class='fa fa-circle-o'></i>Import / Export Contacts </a>";
                            liUser.InnerHtml = "<a href='" + Utility.WebUrl + "/users'><i class='fa fa-circle-o'></i>Add/Change User Profile </a>";
                            liPrice.InnerHtml = "<a href='" + Utility.WebUrl + "/user-pricing'><i class='fa fa-circle-o'></i>User Pricing</a>";
                            liBilling.InnerHtml = "<a href='" + Utility.WebUrl + "/billing'><i class='fa fa-circle-o'></i>Billing Payment Options</a>";
                            lireset.InnerHtml = "<a href='" + Utility.WebUrl + "/reset-password'><i class='fa fa-circle-o'></i>Reset Password </a>";
                            liReferral.InnerHtml = "<a href='" + Utility.WebUrl + "/referral-report'><i class='fa fa-circle-o'></i>My Referral View & Report </a>";

                            liEmailSetup.InnerHtml = "<a href='" + Utility.WebUrl + "/email-setup'><i class='fa fa-circle-o'></i>Email Template Setup </a>";
                            liEmailSchedule.InnerHtml = "<a href='" + Utility.WebUrl + "/email-scheduler'><i class='fa fa-circle-o'></i>Email Scheduler </a>";
                        }
                    }

                    if (bIsAdmin == true)
                    {
                        liUser.InnerHtml = "<a href='" + Utility.WebUrl + "/users'><i class='fa fa-circle-o'></i>Add/Change User Profile </a>";
                        liDealer.InnerHtml = "<a href='" + Utility.WebUrl + "/dealer'><i class='fa fa-circle-o'></i>Dealer Dashboard </a>";
                        liGroupCode.InnerHtml = "<a href='" + Utility.WebUrl + "/group-code'><i class='fa fa-circle-o'></i>Group Code Profile </a>";
                        liSystemData.InnerHtml = "<a href='" + Utility.WebUrl + "/system'><i class='fa fa-circle-o'></i>System Data</a>";
                        liGlobalSystemInfo.InnerHtml = "<a href='" + Utility.WebUrl + "/global-info'><i class='fa fa-circle-o'></i>Global eTag365 System Info</a>";
                        liApproveBillingTransaction.InnerHtml = "<a href='" + Utility.WebUrl + "/approvetransaction'><i class='fa fa-circle-o'></i>Approve Billing Transactions </a>";

                        liPayCommission.InnerHtml = "<a href='" + Utility.WebUrl + "/pay'><i class='fa fa-circle-o'></i>Pay Commissions</a>";
                        liApproveCommission.InnerHtml = "<a href='" + Utility.WebUrl + "/approve'><i class='fa fa-circle-o'></i>Approve Commissions</a>";


                    }


                    if (!string.IsNullOrEmpty(obj.ProfileLogo))
                    {
                        imgTopLogo.ImageUrl = Utility.WebUrl + "/Uploads/Files/User/" + obj.ProfileLogo;
                        imgTopIcon.ImageUrl = Utility.WebUrl + "/Uploads/Files/User/" + obj.ProfileLogo;
                    }
                }
            }
            catch (Exception ex)
            {

            }

        }
    }
}