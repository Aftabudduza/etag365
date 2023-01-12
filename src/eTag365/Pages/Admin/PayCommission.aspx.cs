using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using eTagService.Enums;
using TagService.BO;
using TagService.DA;

namespace eTag365.Pages.Admin
{
    public partial class PayCommission : System.Web.UI.Page
    {
        public string sUserPhone = "";
        public string sUserType = "2";
        public string sUserId = "";
        public string strLoginID = System.Configuration.ConfigurationManager.AppSettings.Get("LoginID");
        public string strSecureKey = System.Configuration.ConfigurationManager.AppSettings.Get("ProcessingKey");

        #region Events

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
                            FillMenu(obj);
                            FillUsers(Convert.ToInt32(rdoUserType.SelectedItem.Value));

                            //Set utcTime, store on page in hidden field
                            page_pg_utc_time.Value = DateTime.UtcNow.Ticks.ToString();

                            string sInvoice = new PaymentHistoryDA().MakeAutoGenerateSerial("I", "Billing");

                            page_pg_transaction_order_number.Value = sInvoice;

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
                sUserId = ddlUser.SelectedValue != "-1" ? ddlUser.SelectedValue : "";
                sUserType = rdoUserType.SelectedItem.Value;
                if (sUserId != "")
                {
                    FillAllTransactionList(sUserId, sUserType);
                }
                else
                {
                    gvContactList.DataSource = null;
                    gvContactList.DataBind();
                    txtDue.Text = "";
                    txtPaid.Text = "";
                }

            }
            catch (Exception)
            {

            }
        }

        protected void gvContactList_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvContactList.PageIndex = e.NewPageIndex;

            sUserType = rdoUserType.SelectedItem.Value;
            sUserId = ddlUser.SelectedValue != "-1" ? ddlUser.SelectedValue : "";
            if (sUserId != "")
            {
                FillAllTransactionList(sUserId, sUserType);
            }
            else
            {
                gvContactList.DataSource = null;
                gvContactList.DataBind();
                txtDue.Text = "";
                txtPaid.Text = "";
            }

        }
        protected void gvContactList_Sorting(object sender, GridViewSortEventArgs e)
        {
            sUserType = rdoUserType.SelectedItem.Value;
            sUserId = ddlUser.SelectedValue != "-1" ? ddlUser.SelectedValue : "";
            if (sUserId != "")
            {
                FillAllTransactionList(sUserId, sUserType);
            }
            else
            {
                gvContactList.DataSource = null;
                gvContactList.DataBind();
                txtDue.Text = "";
                txtPaid.Text = "";
            }
        }

        protected void btnCalculate_Click(object sender, EventArgs e)
        {
            sUserType = rdoUserType.SelectedItem.Value;
            sUserId = ddlUser.SelectedValue != "-1" ? ddlUser.SelectedValue : "";
            if (sUserId != "")
            {
                FillAllTransactionList(sUserId, sUserType);
            }
            else
            {
                gvContactList.DataSource = null;
                gvContactList.DataBind();
                txtDue.Text = "";
                txtPaid.Text = "";
            }
        }

        protected void btnPay_Click(object sender, EventArgs e)
        {
            decimal nOwed = 0, nPay = 0;
            nOwed = txtDue.Text.ToString().Trim() != "" ? Convert.ToDecimal(txtDue.Text.ToString().Trim()) : 0;
            nPay = txtPaid.Text.ToString().Trim() != "" ? Convert.ToDecimal(txtPaid.Text.ToString().Trim()) : 0;

            if (nOwed > 0 && nPay > 0)
            {
                if (nPay <= nOwed)
                {
                    SavePayment();
                }
                else
                {
                    Utility.DisplayMsg("Paid amount can not be larger than earned value !", this);
                }
            }
            else
            {
                Utility.DisplayMsg("Amount must have value !", this);
            }
            
        }

        #endregion

        #region Method

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
                            liEmailSchedule.InnerHtml = "<a href='" + Utility.WebUrl + "/email-schedule'><i class='fa fa-circle-o'></i>Email Schedule </a>";
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
                            liPrice.InnerHtml = "<a href='" + Utility.WebUrl + "/user-pricing'><i class='fa fa-circle-o'></i>User Pricing</a>";
                            liBilling.InnerHtml = "<a href='" + Utility.WebUrl + "/billing'><i class='fa fa-circle-o'></i>Billing Payment Options</a>";
                            lireset.InnerHtml = "<a href='" + Utility.WebUrl + "/reset-password'><i class='fa fa-circle-o'></i>Reset Password </a>";
                            liReferral.InnerHtml = "<a href='" + Utility.WebUrl + "/referral-report'><i class='fa fa-circle-o'></i>My Referral View & Report </a>";

                            liEmailSetup.InnerHtml = "<a href='" + Utility.WebUrl + "/email-setup'><i class='fa fa-circle-o'></i>Email Template Setup </a>";
                            liEmailSchedule.InnerHtml = "<a href='" + Utility.WebUrl + "/email-schedule'><i class='fa fa-circle-o'></i>Email Schedule </a>";
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
                       // string sName = obj.FirstName.ToString() + " " + obj.LastName.ToString() + " (" + obj.Phone.ToString() + ")";
                        string sName = (obj.FirstName != null ? obj.FirstName.ToString() : "") + " " + (obj.LastName != null ? obj.LastName.ToString() : "") + " (+" + (obj.Phone != null ? obj.Phone.ToString() : "") + ")";
                        ddlUser.Items.Add(new ListItem(sName, obj.Phone.ToString()));
                    }
                }

                ddlUser.DataBind();
            }
            catch (Exception ex)
            {

            }

        }

        private void FillAllTransactionList(string phone, string type)
        {
            try
            {
                List<usp_GetDueCommissionByUser_Result> obj = null;
                if (type == "2")
                {
                    obj = new ReferralTransactionDA().GetDueCommissionsByUser(phone, "User");
                }
                else
                {
                    obj = new ReferralTransactionDA().GetDueCommissionsByUser(phone, "Dealer");
                }
               
                gvContactList.DataSource = obj;
                gvContactList.DataBind();

                if (obj != null && obj.Count > 0)
                {
                    decimal nDue = 0;
                    nDue = obj[0].CommissionOwed == null ? 0 : obj[0].CommissionOwed;
                    txtDue.Text = nDue.ToString("0.00");
                }
                else
                {
                    txtDue.Text = "";
                    txtPaid.Text = "";
                }
            }
            catch (Exception e)
            {

            }
        }

        public void ProcessTransaction(UserProfile objUser, PaymentInformation objPaymentInfo)
        {
            try
            {
                string apiLoginId;
                string returnURL;
                string continueURL;
                string secTranKey;
                string versionNumber;

                page_pg_utc_time.Value = DateTime.UtcNow.Ticks.ToString();

                string sInvoice = new PaymentHistoryDA().MakeAutoGenerateSerial("I", "Billing");

                page_pg_transaction_order_number.Value = sInvoice;

                //Enter your values here:
                //apiLoginId = "W3nzeYPLfm";  //Login ID from PaymentsGateway SWP admin
                //secTranKey = "nEJytDzj8dHTCKdGKgBgP"; //SecureTransKey in ClearText

                returnURL = Utility.WebUrl + "/thank-you?a=1"; //Optional: must match URL set in PaymentsGateway.net admin settings, page should have script to read http stream
                continueURL = Utility.WebUrl + "/thank-you?a=1"; //Optional: used only if returnURL is not set. Page to return to from SWP confirmation screen

                versionNumber = "1.0"; //SWP version number, per documentation currently 1.0

                apiLoginId = strLoginID;
                secTranKey = strSecureKey;

                //Begin building page stream to post to SWP
                RemotePost myremotepost = new RemotePost();
                myremotepost.Url = "https://swp.paymentsgateway.net/co/default.aspx";
               // myremotepost.Url = "https://sandbox.paymentsgateway.net/swp/co/default.aspx";
                myremotepost.Add("pg_api_login_id", apiLoginId);
                myremotepost.Add("pg_return_url", returnURL);
                myremotepost.Add("pg_utc_time", page_pg_utc_time.Value);
                myremotepost.Add("pg_transaction_order_number", page_pg_transaction_order_number.Value);
                myremotepost.Add("pg_continue_url", continueURL);

                //Generate Hash Value
                string hash;
                hash = generateHash(secTranKey, apiLoginId, "23", versionNumber, txtPaid.Text, page_pg_utc_time.Value, page_pg_transaction_order_number.Value);
                myremotepost.Add("pg_ts_hash", hash);

               
                //Required Values-- from aspx page fields
                //Note- transaction type options are Credit Card Sale or Check Sale only
                //Other types (Credits & Auths) could be added using a control that stores the appropriate values, as listed in the SWP Integration Guide
                //Valid values as of 2009-02-26: 10=CC Sale, 13=CC Credit, 20=eCheck Sale, 23=eCheck Credit, 11=CC Auth, 21=eChech Auth
                myremotepost.Add("pg_transaction_type", "23");
                myremotepost.Add("pg_version_number", versionNumber);
                myremotepost.Add("pg_total_amount", txtPaid.Text);
                myremotepost.Add("ecom_payment_check_account_type", "C");

                myremotepost.Add("ecom_payment_check_trn", objPaymentInfo.RoutingNo);
                myremotepost.Add("ecom_payment_check_account", objPaymentInfo.AccountNo);

                //live 
                myremotepost.Add("pg_billto_postal_name_company", objUser.CompanyName);
                myremotepost.Add("pg_billto_postal_name_first", objUser.FirstName);
                myremotepost.Add("pg_billto_postal_name_last", objUser.LastName);
                myremotepost.Add("pg_billto_postal_street_line1", objPaymentInfo.Address);
                myremotepost.Add("pg_billto_postal_street_line2", objPaymentInfo.Address1);
                myremotepost.Add("pg_billto_postal_city", objPaymentInfo.City);
                myremotepost.Add("pg_billto_postal_stateprov", objPaymentInfo.State);
                myremotepost.Add("pg_billto_postal_postalcode", objPaymentInfo.Zip);
                myremotepost.Add("pg_billto_online_email", objUser.Email);
             //   myremotepost.Add("pg_billto_telecom_phone_number", "215-669-1499");
              //  myremotepost.Add("pg_billto_telecom_phone_number", objUser.Phone);

                myremotepost.Add("pg_shipto_postal_name", objPaymentInfo.AccountName);
                myremotepost.Add("pg_shipto_postal_street_line1", objPaymentInfo.Address);
                myremotepost.Add("pg_shipto_postal_street_line2", objPaymentInfo.Address1);
                myremotepost.Add("pg_shipto_postal_city", objPaymentInfo.City);
                myremotepost.Add("pg_shipto_postal_stateprov", objPaymentInfo.State);
                myremotepost.Add("pg_shipto_postal_postalcode", objPaymentInfo.Zip);

                myremotepost.Post();
            }
            catch (Exception ex3)
            {

            }
        }

        public void ProcessTransactionForDealer(Dealer_SalesPartner objDealer)
        {
            try
            {
                string apiLoginId;
                string returnURL;
                string continueURL;
                string secTranKey;
                string versionNumber;

                page_pg_utc_time.Value = DateTime.UtcNow.Ticks.ToString();

                string sInvoice = new PaymentHistoryDA().MakeAutoGenerateSerial("I", "Billing");

                page_pg_transaction_order_number.Value = sInvoice;

                //Enter your values here:
                //apiLoginId = "W3nzeYPLfm";  //Login ID from PaymentsGateway SWP admin
                //secTranKey = "nEJytDzj8dHTCKdGKgBgP"; //SecureTransKey in ClearText

                returnURL = Utility.WebUrl + "/thank-you?a=1"; //Optional: must match URL set in PaymentsGateway.net admin settings, page should have script to read http stream
                continueURL = Utility.WebUrl + "/thank-you?a=1"; //Optional: used only if returnURL is not set. Page to return to from SWP confirmation screen

                versionNumber = "1.0"; //SWP version number, per documentation currently 1.0

                apiLoginId = strLoginID;
                secTranKey = strSecureKey;

                //Begin building page stream to post to SWP
                RemotePost myremotepost = new RemotePost();
                myremotepost.Url = "https://swp.paymentsgateway.net/co/default.aspx";
               // myremotepost.Url = "https://sandbox.paymentsgateway.net/swp/co/default.aspx";
                myremotepost.Add("pg_api_login_id", apiLoginId);
                myremotepost.Add("pg_return_url", returnURL);
                myremotepost.Add("pg_utc_time", page_pg_utc_time.Value);
                myremotepost.Add("pg_transaction_order_number", page_pg_transaction_order_number.Value);
                myremotepost.Add("pg_continue_url", continueURL);

                //Generate Hash Value
                string hash;
                hash = generateHash(secTranKey, apiLoginId, "23", versionNumber, txtPaid.Text, page_pg_utc_time.Value, page_pg_transaction_order_number.Value);
                myremotepost.Add("pg_ts_hash", hash);


                //Required Values-- from aspx page fields
                //Note- transaction type options are Credit Card Sale or Check Sale only
                //Other types (Credits & Auths) could be added using a control that stores the appropriate values, as listed in the SWP Integration Guide
                //Valid values as of 2009-02-26: 10=CC Sale, 13=CC Credit, 20=eCheck Sale, 23=eCheck Credit, 11=CC Auth, 21=eChech Auth
                myremotepost.Add("pg_transaction_type", "23");
                myremotepost.Add("pg_version_number", versionNumber);
                myremotepost.Add("pg_total_amount", txtPaid.Text);
                myremotepost.Add("ecom_payment_check_account_type", "C");

                myremotepost.Add("ecom_payment_check_trn", objDealer.routingNo);
                myremotepost.Add("ecom_payment_check_account", objDealer.accountNo);

                //live 
                myremotepost.Add("pg_billto_postal_name_company", "eTag365");
                myremotepost.Add("pg_billto_postal_name_first", objDealer.firstName);
                myremotepost.Add("pg_billto_postal_name_last", objDealer.lastName);
                myremotepost.Add("pg_billto_postal_street_line1", objDealer.address1);
                myremotepost.Add("pg_billto_postal_street_line2", objDealer.address2);
                myremotepost.Add("pg_billto_postal_city", objDealer.city);
                myremotepost.Add("pg_billto_postal_stateprov", objDealer.stateId);
                myremotepost.Add("pg_billto_postal_postalcode", objDealer.zipCode);
                myremotepost.Add("pg_billto_online_email", objDealer.email);
                //myremotepost.Add("pg_billto_telecom_phone_number", objDealer.primaryPhoneNo);

                myremotepost.Add("pg_shipto_postal_name", objDealer.firstName + " " + objDealer.lastName);
                myremotepost.Add("pg_shipto_postal_street_line1", objDealer.address1);
                myremotepost.Add("pg_shipto_postal_street_line2", objDealer.address2);
                myremotepost.Add("pg_shipto_postal_city", objDealer.city);
                myremotepost.Add("pg_shipto_postal_stateprov", objDealer.stateId);
                myremotepost.Add("pg_shipto_postal_postalcode", objDealer.zipCode);

                myremotepost.Post();
            }
            catch (Exception ex3)
            {

            }
        }
       
        private string generateHash(string secTranKey, string apiLoginID, string transactionType, string versionNumber, string totalAmount, string utcTime, string transactionOrderNumber)
        {
            //Build Send String
            string send;
            send = apiLoginID + "|" + transactionType + "|" + versionNumber + "|" + totalAmount + "|" + utcTime + "|" + transactionOrderNumber;

            //Generate and return the hash value
            GenerateHashCode.HashCode objHashkey = new GenerateHashCode.HashCode();
            return objHashkey.GenerateHash(send, secTranKey).ToString();

        }

        public class RemotePost
        {
            //Thanks to Jigar Desai's article at C-Sharp Corner for this class 
            //http://www.c-sharpcorner.com/UploadFile/desaijm/ASP.NetPostURL11282005005516AM/ASP.NetPostURL.aspx
            private System.Collections.Specialized.NameValueCollection Inputs = new System.Collections.Specialized.NameValueCollection();

            public string Url = "";
            public string Method = "post";
            public string FormName = "form1";

            public void Add(string name, string value)
            {
                Inputs.Add(name, value);
            }

            public void Post()
            {
                System.Web.HttpContext.Current.Response.Clear();

                System.Web.HttpContext.Current.Response.Write("<html><head>");

                System.Web.HttpContext.Current.Response.Write(string.Format("</head><body onload=\"document.{0}.submit()\">", FormName));
                System.Web.HttpContext.Current.Response.Write(string.Format("<form name=\"{0}\" method=\"{1}\" action=\"{2}\" >", FormName, Method, Url));
                for (int i = 0; i < Inputs.Keys.Count; i++)
                {
                    System.Web.HttpContext.Current.Response.Write(string.Format("<input name=\"{0}\" type=\"hidden\" value=\"{1}\">", Inputs.Keys[i], Inputs[Inputs.Keys[i]]));
                }
                System.Web.HttpContext.Current.Response.Write("</form>");
                System.Web.HttpContext.Current.Response.Write("</body></html>");
                System.Web.HttpContext.Current.Response.Flush();
                System.Web.HttpContext.Current.Response.End();
            }
        }

        private void SavePayment()
        {
            try
            {
                if (rdoUserType.SelectedItem != null)
                {
                    PaymentHistory paymentHistory = null;
                    int nUserType = Convert.ToInt32(rdoUserType.SelectedItem.Value);

                    if (nUserType == 2)
                    {
                        UserProfile objUser = new UserProfileDA().GetUserByPhone(ddlUser.SelectedValue.ToString());

                        PaymentInformation objPaymentInfo = null;

                        if (objUser != null)
                        {
                            objPaymentInfo = new PaymentInformationDA().GetCheckingAccountByUserId(objUser.Id.ToString());
                        }


                        if (objUser != null && objPaymentInfo != null)
                        {
                            paymentHistory = new PaymentHistory()
                            {
                                FromUser = "eTag365",
                                FromUserType = 1,
                                ToUser = ddlUser.SelectedValue.ToString(),
                                ToUserType = nUserType,
                                AccountName = objPaymentInfo.AccountName,
                                Address = objPaymentInfo.Address,
                                Address1 = objPaymentInfo.Address1,
                                City = objPaymentInfo.City,
                                State = objPaymentInfo.State,
                                Zip = objPaymentInfo.Zip,
                                CardNumber = "",
                                CVS = "",
                                Month = "",
                                Year = "",
                                LastFourDigitCard =
                                    objPaymentInfo.AccountNo.Length > 4
                                        ? objPaymentInfo.AccountNo.Substring(objPaymentInfo.AccountNo.Length - 4, 4)
                                        : objPaymentInfo.AccountNo,
                                IsCheckingAccount = true,
                                RoutingNo = objPaymentInfo.RoutingNo,
                                AccountNo =
                                    objPaymentInfo.AccountNo.Length > 4
                                        ? objPaymentInfo.AccountNo.Substring(objPaymentInfo.AccountNo.Length - 4, 4)
                                        : objPaymentInfo.AccountNo,
                                CheckNo = "",
                                AccountType = "Check",
                                CreateDate = DateTime.Now,
                                AuthorizationCode = "",
                                TransactionCode = "",
                                TransactionDescription = "",
                                Getway = "Commission",
                                Status = "pending",
                                Serial = new PaymentHistoryDA().MakeAutoGenerateSerial("I", "Billing"),
                                TransactionType = "Commission",
                                LedgerCode = "4010",
                                Remarks = "User Commission",
                                SubscriptionType = "",
                                IsStorageSubscription = false,
                                IsReceivedCommissions = false,
                                YTD_Commission = "0",
                                MTD_Commission = "0",
                                IsRecurring = false,
                                YTD_Contact_Export_Limit = "0",
                                MTD_Contact_Import_Limit = "0",
                                Contact_Storage_Limit = "0",
                                IsBillingCycleMonthly = false,
                                BasicAmount = txtPaid.Text.ToString(),
                                StorageAmount = "0",
                                SubTotalCharge = txtPaid.Text.ToString(),
                                Promocode = "",
                                DiscountPercentage = "",
                                Discount = "",
                                CheckingAccountProcessingFee = "",
                                GrossAmount = txtPaid.Text.ToString(),
                                NetAmount = txtPaid.Text.ToString(),
                                DebitAmount = Convert.ToDecimal(txtPaid.Text.ToString()),
                                CreditAmount = 0,
                                NoOfContact = "",
                                ContactMultiplier = "",
                                TotalContact = "",
                                PerUnitCharge = "",
                                MonthlyCharge = "",
                                IsAgree = true
                            };

                            Session["paymentHistory"] = paymentHistory;

                            ProcessTransaction(objUser, objPaymentInfo);

                        }
                    }

                    else
                    {

                        var objDealer = new SalesPartnerDealerDashboardDA().GetDealerByPhone(ddlUser.SelectedValue.ToString());

                        if (objDealer != null)
                        {
                            paymentHistory = new PaymentHistory()
                            {
                                FromUser = "eTag365",
                                FromUserType = 1,
                                ToUser = ddlUser.SelectedValue.ToString(),
                                ToUserType = nUserType,
                                AccountName = objDealer.firstName + " " + objDealer.lastName,
                                Address = objDealer.address1,
                                Address1 = objDealer.address2,
                                City = objDealer.city,
                                State = objDealer.stateId,
                                Zip = objDealer.zipCode,
                                CardNumber = "",
                                CVS = "",
                                Month = "",
                                Year = "",
                                LastFourDigitCard =
                                    objDealer.accountNo.Length > 4
                                        ? objDealer.accountNo.Substring(objDealer.accountNo.Length - 4, 4)
                                        : objDealer.accountNo,
                                IsCheckingAccount = true,
                                RoutingNo = objDealer.routingNo,
                                AccountNo =
                                    objDealer.accountNo.Length > 4
                                        ? objDealer.accountNo.Substring(objDealer.accountNo.Length - 4, 4)
                                        : objDealer.accountNo,
                                CheckNo = "",
                                AccountType = "Check",
                                CreateDate = DateTime.Now,
                                AuthorizationCode = "",
                                TransactionCode = "",
                                TransactionDescription = "",
                                Getway = "Commission",
                                Status = "pending",
                                Serial = new PaymentHistoryDA().MakeAutoGenerateSerial("I", "Billing"),
                                TransactionType = "Commission",
                                LedgerCode = "4010",
                                Remarks = "Dealer Commission",
                                SubscriptionType = "",
                                IsStorageSubscription = false,
                                IsReceivedCommissions = false,
                                YTD_Commission = "0",
                                MTD_Commission = "0",
                                IsRecurring = false,
                                YTD_Contact_Export_Limit = "0",
                                MTD_Contact_Import_Limit = "0",
                                Contact_Storage_Limit = "0",
                                IsBillingCycleMonthly = false,
                                BasicAmount = txtPaid.Text.ToString(),
                                StorageAmount = "0",
                                SubTotalCharge = txtPaid.Text.ToString(),
                                Promocode = "",
                                DiscountPercentage = "",
                                Discount = "",
                                CheckingAccountProcessingFee = "",
                                GrossAmount = txtPaid.Text.ToString(),
                                NetAmount = txtPaid.Text.ToString(),
                                DebitAmount = Convert.ToDecimal(txtPaid.Text.ToString()),
                                CreditAmount = 0,
                                NoOfContact = "",
                                ContactMultiplier = "",
                                TotalContact = "",
                                PerUnitCharge = "",
                                MonthlyCharge = "",
                                IsAgree = true
                            };

                            Session["paymentHistory"] = paymentHistory;

                            ProcessTransactionForDealer(objDealer);

                        }
                    }
                }
            }
            catch (Exception ex)
            {

            }

        }

        #endregion

    }
}