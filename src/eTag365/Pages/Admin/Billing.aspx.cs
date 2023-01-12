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
using System.Text.RegularExpressions;

namespace eTag365.Pages.Admin
{
    public partial class Billing : System.Web.UI.Page
    {
       
        public string isView = "true";
        public string sUserPhone = "";
        public string sUserType = "2";
        private static System.Net.Mail.SmtpClient objSmtpClient;
        private static System.Net.Mail.MailMessage objMailMessage;

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

                            if (obj.IsBillingComplete != null)
                            {
                                isView = Convert.ToBoolean(obj.IsBillingComplete) == true ? "false" : "true";
                            }      

                            FillMenu(obj);                         
                          
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
        public static string RewardByGroupCodeType(string code, string plan, string billtype)
        {
            GroupCodeDealerProfileDA da = new GroupCodeDealerProfileDA();
            GroupCode GroupCodeData = da.GetRewardByGroupCodeType(code, plan, billtype);
            string sReward = string.Empty;
            if (GroupCodeData != null)
            {
                sReward = (GroupCodeData.Amount != null && GroupCodeData.Amount != 0) ? GroupCodeData.Amount.ToString() : "0";
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

        [WebMethod(EnableSession = true)]
        public static string SaveDirect(PaymentHistory obj)
        {
            bool bSuccess = false, bSuccessOther = false;
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
                    obj.Status = "complete";
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

                        bSuccess = new PaymentHistoryDA().Insert(obj);

                        if (bSuccess)
                        {                           
                            bSuccessOther = ApproveUser(obj);
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
        

        private static bool ApproveUser(PaymentHistory objPaymentHistory)
        {
            bool bSuccessBillingMain = false;

            try
            {
                decimal nAmount = 0;
                string sLedgerCode = objPaymentHistory.LedgerCode != null ? objPaymentHistory.LedgerCode : "";
                string sNote = objPaymentHistory.Remarks != null ? objPaymentHistory.Remarks : "";
                string sPayorId = objPaymentHistory.FromUser != null ? objPaymentHistory.FromUser : "";
                string sInvoice = objPaymentHistory.Serial != null ? objPaymentHistory.Serial : "";
                int nUserID = 0;

                bool bIsReferralAmountEligible = false;

                bIsReferralAmountEligible = (objPaymentHistory.IsBillingCycleMonthly != null && objPaymentHistory.IsBillingCycleMonthly == true) ? false : true;

                nAmount = objPaymentHistory.GrossAmount != null ? Convert.ToDecimal(objPaymentHistory.GrossAmount) : 0;

                DateTime nExpiredate = (objPaymentHistory.IsBillingCycleMonthly != null && objPaymentHistory.IsBillingCycleMonthly == true) ? DateTime.Now.AddMonths(1) : DateTime.Now.AddYears(1);

                string sTransactionNo = new FinancialTransactionDA().MakeAutoGenerateSerial("F", "Account");

                UserProfile objUser = null;

                string sPhone = Regex.Replace(objPaymentHistory.FromUser.Trim(), @"[^0-9]", "");

                //if (sPhone.Length > 10)
                //{
                //    sPhone = sPhone.Substring(sPhone.Length - 10);
                //}

                objUser = new UserProfileDA().GetUserByPhone(sPhone);

                try
                {
                    if (objUser != null && objUser.Id > 0)
                    {
                        nUserID = objUser.Id;

                        objUser.IsBillingComplete = true;
                        objUser.IsUserProfileComplete = true;
                        objUser.SubscriptionType = objPaymentHistory.SubscriptionType;
                        objUser.YTD_Contact_Export_Limit = objPaymentHistory.YTD_Contact_Export_Limit;
                        objUser.MTD_Contact_Import_Limit = objPaymentHistory.MTD_Contact_Import_Limit;
                        objUser.Contact_Storage_Limit = objPaymentHistory.Contact_Storage_Limit;
                        objUser.SubscriptionExpiredOn = nExpiredate;

                        if (objPaymentHistory.IsStorageSubscription == true)
                        {
                            objUser.IsStorageSubscription = objPaymentHistory.IsStorageSubscription;
                            objUser.StorageExpiredOn = nExpiredate;
                        }
                        else
                        {
                            objUser.IsStorageSubscription = false;
                            objUser.StorageExpiredOn = nExpiredate;
                        }

                        objUser.UpdatedDate = DateTime.Now;
                       
                    }
                }
                catch (Exception ex)
                {

                }

                try
                {
                    var objBilling = new BillingPayment()
                    {
                        UserId = objUser.Id.ToString(),
                        UserPhone = objPaymentHistory.FromUser,
                        SubscriptionType = objPaymentHistory.SubscriptionType,
                        IsStorageSubscription = objPaymentHistory.IsStorageSubscription,
                        IsReceivedCommissions = objPaymentHistory.IsReceivedCommissions,
                        SubscriptionExpiredOn = nExpiredate,
                        StorageExpiredOn = nExpiredate,
                        YTD_Contact_Export_Limit = objPaymentHistory.YTD_Contact_Export_Limit,
                        MTD_Contact_Import_Limit = objPaymentHistory.MTD_Contact_Import_Limit,
                        Contact_Storage_Limit = objPaymentHistory.Contact_Storage_Limit,
                        IsBillingCycleMonthly = objPaymentHistory.IsBillingCycleMonthly,
                        IsBillingComplete = true,
                        ReferralStartDate = DateTime.Now,
                        ReferralEndDate = DateTime.Now.AddYears(1),
                        IsCommissionMonthly = true,
                        YTD_Commission = objPaymentHistory.YTD_Commission,
                        MTD_Commission = objPaymentHistory.MTD_Commission,
                        CreateDate = DateTime.Now,
                        Status = objPaymentHistory.Status,
                        Remarks = objPaymentHistory.Remarks,
                        YTD_ReferralUser = "0",
                        Total_ReferralUser = "0",
                        ReferralRecycleDate = DateTime.Now,
                        LastReferralCalculatedDate = DateTime.Now,
                        IsRecurring = objPaymentHistory.IsRecurring,
                        BasicAmount = objPaymentHistory.BasicAmount,
                        StorageAmount = objPaymentHistory.StorageAmount,
                        SubTotalCharge = objPaymentHistory.SubTotalCharge,
                        Promocode = objPaymentHistory.Promocode,
                        DiscountPercentage = objPaymentHistory.DiscountPercentage,
                        Discount = objPaymentHistory.Discount,
                        GrossAmount = objPaymentHistory.GrossAmount,
                        CheckingAccountProcessingFee = objPaymentHistory.CheckingAccountProcessingFee,
                        NetAmount = objPaymentHistory.NetAmount.ToString(),
                        NoOfContact = objPaymentHistory.NoOfContact,
                        ContactMultiplier = objPaymentHistory.ContactMultiplier,
                        TotalContact = objPaymentHistory.TotalContact,
                        PerUnitCharge = objPaymentHistory.PerUnitCharge,
                        MonthlyCharge = objPaymentHistory.MonthlyCharge,
                        IsAgree = true
                    };

                    BillingPayment objBillingOld = new BillingPaymentDA().GetbyUserID(nUserID.ToString());

                    if (objBillingOld != null && objBillingOld.Id > 0)
                    {
                        objBilling.Id = objBillingOld.Id;
                        objBilling.ReferralStartDate = objBillingOld.ReferralStartDate;
                       // objBilling.CreateDate = objBillingOld.CreateDate;
                        objBilling.YTD_ReferralUser = objBillingOld.YTD_ReferralUser;
                        objBilling.Total_ReferralUser = objBillingOld.Total_ReferralUser;
                        objBilling.ReferralRecycleDate = objBillingOld.ReferralRecycleDate;
                        objBilling.LastReferralCalculatedDate = objBillingOld.LastReferralCalculatedDate;
                    }

                    if (objBilling.Id > 0)
                    {
                        if (new BillingPaymentDA().Update(objBilling))
                        {
                            bSuccessBillingMain = true;
                        }
                    }
                    else
                    {
                        if (new BillingPaymentDA(true, false).Insert(objBilling))
                        {
                            bSuccessBillingMain = true;
                        }
                    }

                }
                catch (Exception ex)
                {

                }

                if (bSuccessBillingMain == true)
                {
                    if (new UserProfileDA().Update(objUser))
                    {

                    }
                }               

            }
            catch (Exception ex)
            {
                bSuccessBillingMain = false;
            }

            return bSuccessBillingMain;

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
                            //  liUser.InnerHtml = "<a href='" + Utility.WebUrl + "/user?Top=1&UId=" + obj.Id.ToString() + "'><i class='fa fa-circle-o'></i>Add/Change User Profile </a>";
                            liPrice.InnerHtml = "<a href='" + Utility.WebUrl + "/user-pricing'><i class='fa fa-circle-o'></i>User Pricing</a>";
                            liBilling.InnerHtml = "<a href='" + Utility.WebUrl + "/billing'><i class='fa fa-circle-o'></i>Billing Payment Options</a>";
                            lireset.InnerHtml = "<a href='" + Utility.WebUrl + "/reset-password'><i class='fa fa-circle-o'></i>Reset Password </a>";
                            liReferral.InnerHtml = "<a href='" + Utility.WebUrl + "/referral-report'><i class='fa fa-circle-o'></i>My Referral View & Report </a>";
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