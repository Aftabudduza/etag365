using TagService.BO;
using TagService.DA;
using eTagService.Enums;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Web.Services;
using System.Security.AccessControl;

namespace eTag365.Pages.Admin
{
    public partial class BillingTransactionList : System.Web.UI.Page
    {
        public String errStr = String.Empty;
        public string sUrl = string.Empty;
        public string sType = "SubscriptionFee";
        #region Events

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {              
                Session["AddSearch"] = null;

                string sessionid = System.Web.HttpContext.Current.Session.SessionID;
                if (!string.IsNullOrEmpty(sessionid))
                {
                    int userid = Utility.IntegerData("SELECT TOP 1 UserId FROM UserLog_Data Where SessionId='" + sessionid + "' Order By LogId DESC");
                   
                    if (userid > 0)
                    {
                        FillTransactionList(sType);
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
        protected void btnsearch_Click(object sender, EventArgs e)
        {
            try
            {
                Session["AddSearch"] = null;
                List<PaymentHistory> obj = null;
                if (search.Value.ToString().Trim() != string.Empty)
                {
                    string strWhere = string.Empty;
                    strWhere = search.Value.ToString().Trim();
                    Session["AddSearch"] = strWhere;                  

                    obj = new PaymentHistoryDA().GetBySearch(strWhere, sType);                   
                }
                else
                {
                    obj = new PaymentHistoryDA().GetAllPaymentHistoryByTransactionType(sType);
                }

                gvContactList.DataSource = obj;
                gvContactList.DataBind();
            }

            catch (Exception ex) 
            { }
        }       
        protected void gvContactList_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvContactList.PageIndex = e.NewPageIndex;
            FillTransactionList(sType);
        }
        protected void gvContactList_Sorting(object sender, GridViewSortEventArgs e)
        {
            FillTransactionList(sType);
        }
        protected void btnApprove_Click(object sender, EventArgs e)
        {
            int paymentHistoryId = 0;
            bool bSuccess = false;

            var row = ((LinkButton)sender).Parent.Parent as GridViewRow;
            if (row != null)
            {
                Label hdApplicationId = (Label)gvContactList.Rows[row.RowIndex].FindControl("lblAppId");
                if (!string.IsNullOrEmpty(hdApplicationId.Text))
                {
                    paymentHistoryId = Convert.ToInt32(hdApplicationId.Text.ToString());
                }

                var ExistingHistory = new PaymentHistoryDA().GetbyID(paymentHistoryId);

                if (ExistingHistory != null)
                {                   
                    ExistingHistory.Status = "complete";
                    if (new PaymentHistoryDA().Update(ExistingHistory))
                    {
                        bSuccess = ApproveUser(ExistingHistory);                        
                    }

                    if (bSuccess == true)
                    {
                        FillTransactionList(sType);
                        Utility.DisplayMsg("Transaction Approved !!", this);
                    }
                    else
                    {
                        ExistingHistory.Status = "pending";
                        if (new PaymentHistoryDA().Update(ExistingHistory))
                        {
                            Utility.DisplayMsg("Transaction failed !!", this);
                        }
                    }
                }               

            }
        }
        protected void btnReject_Click(object sender, EventArgs e)
        {
            int paymentHistoryId = 0;
            var row = ((LinkButton)sender).Parent.Parent as GridViewRow;
            if (row != null)
            {
                Label hdApplicationId = (Label)gvContactList.Rows[row.RowIndex].FindControl("lblAppId");
                if (!string.IsNullOrEmpty(hdApplicationId.Text))
                {
                    paymentHistoryId = Convert.ToInt32(hdApplicationId.Text.ToString());
                }

                var ExistingHistory = new PaymentHistoryDA().GetbyID(paymentHistoryId);

                if (ExistingHistory != null)
                {
                    ExistingHistory.Status = "decline";
                    if (new PaymentHistoryDA().Update(ExistingHistory))
                    {
                        FillTransactionList(sType);
                        Utility.DisplayMsg("Transaction Rejected !!", this);
                    }
                    else
                    {
                        Utility.DisplayMsg("Transaction failed !!", this);
                    }
                }
            }
        }

        #endregion

        #region Method

        private void FillTransactionList(string Type)
        {
            try
            {
                List<PaymentHistory> obj = null;               

                if (Session["AddSearch"] != null)
                {
                    obj = new PaymentHistoryDA().GetBySearch(Session["AddSearch"].ToString(), Type);
                }
                else
                {
                    obj = new PaymentHistoryDA().GetAllPaymentHistoryByTransactionType(Type);
                }
                gvContactList.DataSource = obj;
                gvContactList.DataBind();
            }
            catch (Exception e)
            {

            }
        }

        private bool ApproveUser(PaymentHistory objPaymentHistory)
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
                     //   objBilling.CreateDate = objBillingOld.CreateDate;
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

                if(bSuccessBillingMain == true)
                {
                    if (new UserProfileDA().Update(objUser))
                    {

                    }
                }

                if (sLedgerCode == "4060" && nAmount > 0 && bSuccessBillingMain == true)
                {
                    try
                    {
                        var GlobalFinTranDebit = new FinancialTransaction()
                        {
                            Serial = sTransactionNo,
                            AccountType = "Asset",
                            LedgerCode = "1010",
                            InvoiceNo = sInvoice,
                            RefId = sPayorId,
                            Amount = nAmount,
                            Debit = nAmount,
                            Credit = 0,
                            CreateDate = DateTime.Now,
                            EntryType = "Debit",
                            Remarks = sNote
                        };

                        var GlobalFinTranCredit = new FinancialTransaction()
                        {
                            Serial = sTransactionNo,
                            AccountType = "Inc",
                            LedgerCode = sLedgerCode,
                            InvoiceNo = sInvoice,
                            RefId = sPayorId,
                            Amount = nAmount,
                            Debit = 0,
                            Credit = nAmount,
                            CreateDate = DateTime.Now,
                            EntryType = "Credit",
                            Remarks = sNote
                        };

                        string sDelFinSQL = "delete from FinancialTransaction where InvoiceNo = '" + sInvoice + "'";
                        Utility.RunCMDMain(sDelFinSQL);

                        if (new FinancialTransactionDA(true, false).Insert(GlobalFinTranDebit))
                        {
                            if (new FinancialTransactionDA(true, false).Insert(GlobalFinTranCredit))
                            {

                            }
                        }
                    }
                    catch (Exception ex)
                    {

                    }

                }

                ReferralAccount objReferralAccount = null;
                UserProfile objReferralUser = null;
                BillingPayment objReferralBilling = null;
                string sReferralPhone = "";
                int nYTDUser = 0, nTotalUser = 0;

                if (bIsReferralAmountEligible == true && bSuccessBillingMain == true && nAmount > 0)
                {
                    try
                    {
                        objReferralAccount = new ReferralAccountDA().GetUserByGiverPhone(sPhone);

                        if (objReferralAccount != null)
                        {
                            sReferralPhone = Regex.Replace(objReferralAccount.GetterPhone.Trim(), @"[^0-9]", "");

                            //if (sReferralPhone.Length > 10)
                            //{
                            //    sReferralPhone = sReferralPhone.Substring(sReferralPhone.Length - 10);
                            //}

                            objReferralUser = new UserProfileDA().GetUserByPhone(sReferralPhone);

                            if (objReferralUser != null)
                            {
                                objReferralBilling = new BillingPaymentDA().GetbyUserID(objReferralUser.Id.ToString());
                            }
                        }
                       

                        if (objReferralBilling != null)
                        {
                            if (objReferralBilling.IsReceivedCommissions == true)
                            {
                                if (objReferralAccount != null && objReferralAccount.StartDate == null)
                                {
                                    objReferralAccount.StartDate = DateTime.Now;
                                    objReferralAccount.EndDate = DateTime.Now.AddYears(1);
                                    objReferralAccount.YTD_Commission = objPaymentHistory.YTD_Commission;
                                    objReferralAccount.MTD_Commission = objPaymentHistory.MTD_Commission;
                                    objReferralAccount.YTD_CommissionOwed = "0";
                                    objReferralAccount.MTD_CommissionOwed = "0";
                                    objReferralAccount.YTD_CommissionPaid = "0";
                                    objReferralAccount.MTD_CommissionPaid = "0";

                                    if (new ReferralAccountDA().Update(objReferralAccount))
                                    {

                                    }
                                }

                                nYTDUser = string.IsNullOrEmpty(objReferralBilling.YTD_ReferralUser) ? 0 : Convert.ToInt32(objReferralBilling.YTD_ReferralUser);
                                nTotalUser = string.IsNullOrEmpty(objReferralBilling.Total_ReferralUser) ? 0 : Convert.ToInt32(objReferralBilling.Total_ReferralUser);

                                nYTDUser = nYTDUser + 1;
                                nTotalUser = nTotalUser + 1;

                                objReferralBilling.YTD_ReferralUser = nYTDUser.ToString();
                                objReferralBilling.Total_ReferralUser = nTotalUser.ToString();

                                if (nYTDUser >= 20 && nTotalUser < 100)
                                {
                                    objReferralBilling.IsBillingComplete = true;
                                    objReferralBilling.SubscriptionExpiredOn = (objReferralBilling.IsBillingComplete == true && objReferralBilling.SubscriptionExpiredOn != null) ? Convert.ToDateTime(objReferralBilling.SubscriptionExpiredOn).AddYears(1) : DateTime.Now.AddYears(1);
                                    objReferralBilling.ReferralEndDate = (objReferralBilling.IsBillingComplete == true && objReferralBilling.ReferralEndDate != null) ? Convert.ToDateTime(objReferralBilling.ReferralEndDate).AddYears(1) : DateTime.Now.AddYears(1);
                                }
                                else if (nTotalUser >= 100)
                                {
                                    objReferralBilling.IsBillingComplete = true;
                                    objReferralBilling.SubscriptionExpiredOn = DateTime.Now.AddYears(100);
                                }

                                if (objReferralUser != null)
                                {
                                    objReferralUser.SubscriptionExpiredOn = objReferralBilling.SubscriptionExpiredOn;
                                    objReferralUser.IsBillingComplete = objReferralBilling.IsBillingComplete;
                                    objReferralUser.UpdatedDate = DateTime.Now;                                    
                                }

                                if (new BillingPaymentDA().Update(objReferralBilling))
                                {
                                    if (new UserProfileDA().Update(objReferralUser))
                                    {

                                    }
                                }
                            }
                        }
                    }
                    catch (Exception ex)
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

        #endregion
    }
}