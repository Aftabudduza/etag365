using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TagService.BO;
using TagService.DA;

namespace eTag365.Pages.Admin
{
    public partial class CommissionList : System.Web.UI.Page
    {
        public String errStr = String.Empty;
        public string sUrl = string.Empty;
        public string sType = "Commission";

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
                        FillUsers(Convert.ToInt32(rdoUserType.SelectedItem.Value));
                        FillAllTransactionList(sType);
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
                string sUserId = "";
                sUserId = ddlUser.SelectedValue != "-1" ? ddlUser.SelectedValue : "";

                if (search.Value.ToString().Trim() != string.Empty)
                {
                    string strWhere = string.Empty;
                    strWhere = search.Value.ToString().Trim();
                    Session["AddSearch"] = strWhere;

                    obj = new PaymentHistoryDA().GetCommissionPaymentHistoryBySearch(strWhere, sType);
                }
                else
                {
                    if (sUserId != "")
                    {
                        obj = new PaymentHistoryDA().GetCommissionPaymentHistoryByUser(sUserId, sType);
                    }
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
           
            string sUserId = "";
            sUserId = ddlUser.SelectedValue != "-1" ? ddlUser.SelectedValue : "";
            if (sUserId != "")
            {
                FillTransactionList(sUserId, sType);
            }
           
        }
        protected void gvContactList_Sorting(object sender, GridViewSortEventArgs e)
        {
            string sUserId = "";
            sUserId = ddlUser.SelectedValue != "-1" ? ddlUser.SelectedValue : "";
            if (sUserId != "")
            {
                FillTransactionList(sUserId, sType);
            }
        }
        protected void btnApprove_Click(object sender, EventArgs e)
        {
            int paymentHistoryId = 0;
            bool bSuccess = false;
            string sUserId = "";
            sUserId = ddlUser.SelectedValue != "-1" ? ddlUser.SelectedValue : "";

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
                        if (sUserId != "")
                        {
                            FillTransactionList(sUserId, sType);
                        }
                        else
                        {
                            FillAllTransactionList(sType);
                        }
                       
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

            string sUserId = "";
            sUserId = ddlUser.SelectedValue != "-1" ? ddlUser.SelectedValue : "";

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
                        if (sUserId != "")
                        {
                            FillTransactionList(sUserId, sType);
                        }
                        else
                        {
                            FillAllTransactionList(sType);
                        }

                        Utility.DisplayMsg("Transaction Rejected !!", this);
                    }
                    else
                    {
                        Utility.DisplayMsg("Transaction failed !!", this);
                    }
                }
            }
        }
        protected void rdoUserType_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rdoUserType.SelectedItem.Value != null)
            {
                FillUsers(Convert.ToInt32(rdoUserType.SelectedItem.Value));
            }
        }
        protected void ddlUser_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                string sUserId = "";
                sUserId = ddlUser.SelectedValue != "-1" ? ddlUser.SelectedValue : "";
                if (sUserId != "")
                {
                    FillTransactionList(sUserId, sType);
                }
                
            }
            catch (Exception)
            {

            }
        }

        #endregion

        #region Method

        private void FillTransactionList(string phone, string type)
        {
            try
            {
                List<PaymentHistory> obj = null;

                if (Session["AddSearch"] != null)
                {
                    obj = new PaymentHistoryDA().GetCommissionPaymentHistoryBySearch(Session["AddSearch"].ToString(), type);
                }
                else
                {
                    obj = new PaymentHistoryDA().GetCommissionPaymentHistoryByUser(phone, type);
                }
                gvContactList.DataSource = obj;
                gvContactList.DataBind();
            }
            catch (Exception e)
            {

            }
        }
        private void FillAllTransactionList(string type)
        {
            try
            {
                List<PaymentHistory> obj = null;
                obj = new PaymentHistoryDA().GetAllPaymentHistoryByTransactionType(sType);
                gvContactList.DataSource = obj;
                gvContactList.DataBind();
            }
            catch (Exception e)
            {

            }
        }
        private bool ApproveUser(PaymentHistory objPaymentHistory)
        {
            bool bSuccessMain = false;

            try
            {
                decimal nAmount = 0;
                decimal nBalance = 0;

                string sLedgerCode = objPaymentHistory.LedgerCode != null ? objPaymentHistory.LedgerCode : "";
                string sNote = objPaymentHistory.Remarks != null ? objPaymentHistory.Remarks : "";
                string sPayeeId = objPaymentHistory.ToUser != null ? objPaymentHistory.ToUser : "";
                string sInvoice = objPaymentHistory.Serial != null ? objPaymentHistory.Serial : "";
                
                string sUserType = "";

                UserProfile objUser = null;
                List<ReferralTransaction> listReferralTransaction = null;

                listReferralTransaction = new ReferralTransactionDA().GetUnpaidHistoryByUser(sPayeeId);

                string sPhone = Regex.Replace(objPaymentHistory.FromUser.Trim(), @"[^0-9]", "");

                //if (sPhone.Length > 10)
                //{
                //    sPhone = sPhone.Substring(sPhone.Length - 10);
                //}

                objUser = new UserProfileDA().GetUserByPhone(sPhone);

                if (objUser != null)
                {
                    sUserType = objUser.UserTypeContact != null ? objUser.UserTypeContact.ToString() : "";
                }

                nAmount = objPaymentHistory.GrossAmount != null ? Convert.ToDecimal(objPaymentHistory.GrossAmount) : 0;

              
                string sTransactionNo = new FinancialTransactionDA().MakeAutoGenerateSerial("F", "Account");
               
              
                if (sLedgerCode == "4010" && nAmount > 0)
                {
                    try
                    {
                        var GlobalFinTranDebit = new FinancialTransaction()
                        {
                            Serial = sTransactionNo,
                            AccountType = "Liab",
                            LedgerCode = sLedgerCode,
                            InvoiceNo = sInvoice,
                            RefId = sPayeeId,
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
                            AccountType = "Asset",
                            LedgerCode = "1010",
                            InvoiceNo = sInvoice,
                            RefId = sPayeeId,
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
                                bSuccessMain = true;
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        bSuccessMain = false;
                    }

                }

                if (bSuccessMain == true && nAmount > 0)
                {
                    nBalance = nAmount;

                    if (listReferralTransaction != null && listReferralTransaction.Count > 0)
                    {
                        foreach (ReferralTransaction objReferralTransaction in listReferralTransaction)
                        {
                            if (nBalance > 0)
                            {
                                decimal nCurrentValue = objReferralTransaction.PayorAmount != null ? Convert.ToDecimal(objReferralTransaction.PayorAmount) : 0;

                                if (nBalance >= nCurrentValue)
                                {
                                    objReferralTransaction.IsPaid = true;
                                    if (new ReferralTransactionDA().Update(objReferralTransaction))
                                    {
                                        nBalance = nBalance - nCurrentValue;

                                        if (sUserType == "2")
                                        {
                                            try
                                            {
                                                string sSQL = "update ReferralAccount set  YTD_CommissionPaid = (select isnull(sum(PayorAmount),0) from ReferralTransaction where CommissionFor='User' and GetterPhone='" + objReferralTransaction.GetterPhone + "' and GiverPhone='" + objReferralTransaction.GiverPhone + "' and IsPaid = 1), LastTransactionDate = GETDATE()  where GetterPhone='" + objReferralTransaction.GetterPhone + "' and GiverPhone='" + objReferralTransaction.GiverPhone + "'";

                                                Utility.RunCMDMain(sSQL);
                                            }
                                            catch (Exception ex)
                                            {

                                            }
                                        }
                                        
                                    } 
                                }
                                else
                                {
                                    objReferralTransaction.PayorAmount = nBalance;
                                    objReferralTransaction.IsPaid = true;
                                    if (new ReferralTransactionDA().Update(objReferralTransaction))
                                    {
                                        //nBalance = 0;
                                        decimal nNewBalance = nCurrentValue - nBalance;
                                        objReferralTransaction.PayorAmount = nNewBalance;
                                        objReferralTransaction.IsPaid = false;
                                        if (new ReferralTransactionDA().Insert(objReferralTransaction))
                                        {
                                           
                                        }

                                        nBalance = nBalance - nCurrentValue;

                                        if (sUserType == "2")
                                        {
                                            try
                                            {
                                                string sSQL = "update ReferralAccount set  YTD_CommissionPaid = (select isnull(sum(PayorAmount),0) from ReferralTransaction where CommissionFor='User' and GetterPhone='" + objReferralTransaction.GetterPhone + "' and GiverPhone='" + objReferralTransaction.GiverPhone + "' and IsPaid = 1), LastTransactionDate = GETDATE()  where GetterPhone='" + objReferralTransaction.GetterPhone + "' and GiverPhone='" + objReferralTransaction.GiverPhone + "'";

                                                Utility.RunCMDMain(sSQL);
                                            }
                                            catch (Exception ex)
                                            {

                                            }
                                        }
                                    }
                                }

                            }
                        }
                    }
                }

            }
            catch (Exception ex)
            {
                bSuccessMain = false;
            }

            return bSuccessMain;

        }

        private void FillUsers(int nType)
        {
            try
            {
                ddlUser.Items.Clear();
                ddlUser.AppendDataBoundItems = true;
                ddlUser.Items.Add(new ListItem("Select User", "-1"));

                List<UserProfile> objUsers = new UserProfileDA().GetAllUsersInfo(nType);
                if (objUsers != null && objUsers.Count > 0)
                {
                    foreach (UserProfile obj in objUsers)
                    {
                        string sName = obj.FirstName.ToString() + " " + obj.LastName.ToString() + " (" + obj.Phone.ToString() + ")";
                        ddlUser.Items.Add(new ListItem(sName, obj.Phone.ToString()));
                    }
                }

                ddlUser.DataBind();
            }
            catch (Exception ex)
            {

            }

        }

        #endregion

    }
}