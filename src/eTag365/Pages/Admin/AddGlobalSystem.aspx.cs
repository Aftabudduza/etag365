using eTagService;
using eTagService.Enums;
using TagService.BO;
using TagService.DA;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace eTag365.Pages.Admin
{
    public partial class AddGlobalSystem : System.Web.UI.Page
    {
        public String errStr = String.Empty;
        #region Events
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session["AddSystemId"] = null;
                Session["CardId"] = null;                
                Session["UserId"] = null;
                string sessionid = System.Web.HttpContext.Current.Session.SessionID;
                if (!string.IsNullOrEmpty(sessionid))
                {
                    int userid = Utility.IntegerData("SELECT TOP 1 UserId FROM UserLog_Data Where SessionId='" + sessionid + "' Order By LogId DESC");
                    if (userid > 0)
                    {
                        Session["UserId"] = userid;
                        FillDropdowns();
                        FillCardGrid();
                        
                        SystemInformation objSystem = new SystemInformationDA().GetGlobalInfo();
                        if (objSystem != null)
                        {
                            Session["AddSystemId"] = objSystem.Id;
                            FillControls(objSystem);
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

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            errStr = string.Empty;

            if (errStr.Length <= 0)
            {
                try
                {
                    SystemInformation objSystemInformation = new SystemInformation();
                    objSystemInformation = SetData(objSystemInformation);
                    if(objSystemInformation != null)
                    {
                        if (Session["AddSystemId"] == null || Session["AddSystemId"].ToString() == "0")
                        {
                            if (new SystemInformationDA(true, false).Insert(objSystemInformation))
                            {
                                Session["AddSystemId"] = null;
                                ClearControls();
                                Utility.DisplayMsgAndRedirect("System Information Created successfully!", this, Utility.WebUrl + "/home");

                            }
                            else
                            {
                                Utility.DisplayMsg("System Information not Created!", this);
                            }
                        }
                        else
                        {
                            if (new SystemInformationDA().Update(objSystemInformation))
                            {                              
                                Session["AddSystemId"] = null;
                                ClearControls();
                                Utility.DisplayMsgAndRedirect("System Information updated successfully!", this, Utility.WebUrl + "/home");
                            }
                            else
                            {
                                Utility.DisplayMsg("System Information not updated!", this);
                            }
                        }
                    }
                    else
                    {
                        Utility.DisplayMsg("Technical issues found. Please try again !", this);
                    }
                   
                }
                catch (Exception ex1)
                {
                    Utility.DisplayMsg(ex1.Message.ToString(), this);
                }
            }
            else
            {
                Utility.DisplayMsg(errStr.ToString(), this);
            }
        }
        protected void btnClose_Click(object sender, EventArgs e)
        {
            ClearControls();
            Response.Redirect(Utility.WebUrl + "/home", false);
        }      

        protected void btnAddCard_Click(object sender, EventArgs e)
        {
            SaveCardData();
            btnAddCard.Text = "Add";
        }
        protected void btnDeleteCard_Click(object sender, EventArgs e)
        {
            GridViewRow row = ((LinkButton)sender).Parent.Parent as GridViewRow;
            Label hdId = (Label)gvCard.Rows[row.RowIndex].FindControl("lblCardId");

            if (!String.IsNullOrEmpty(hdId.Text))
            {
                PaymentInformation objPayment = new PaymentInformationDA().GetByID(Convert.ToInt32(hdId.Text));
                if (objPayment != null)
                {
                    if (new PaymentInformationDA().DeleteByID(objPayment.Id))
                    {
                        FillCardGrid();
                    }
                }

            }
        }
        protected void btnEditCard_Click(object sender, EventArgs e)
        {
            GridViewRow row = ((LinkButton)sender).Parent.Parent as GridViewRow;
            Label hdId = (Label)gvCard.Rows[row.RowIndex].FindControl("lblCardId");

            if (!String.IsNullOrEmpty(hdId.Text))
            {
                PaymentInformation obj = new PaymentInformationDA().GetByID(Convert.ToInt32(hdId.Text));
                if (obj != null)
                {
                    Session["CardId"] = obj.Id;
                    btnAddCard.Text = "Update";


                    txtCardAccountName.Text = "";
                    txtCardAddress.Text = "";
                    txtCardCity.Text = "";
                    txtCardZip.Text = "";
                    txtCardNumber.Text = "";
                    txtCVS.Text = "";
                    txtRoutingNo.Text = "";
                    txtRoutingNo2.Text = "";
                    txtCheckingAccount.Text = "";
                    txtCheckingAccount2.Text = "";

                    if (obj.AccountName != null && obj.AccountName.ToString() != string.Empty)
                    {
                        txtCardAccountName.Text = obj.AccountName;
                    }

                    if (obj.Address != null && obj.Address.ToString() != string.Empty)
                    {
                        txtCardAddress.Text = obj.Address;
                    }
                    if (obj.State != null && obj.State.ToString() != string.Empty)
                    {
                        ddlState.SelectedValue = obj.State;
                    }
                    if (obj.City != null && obj.City.ToString() != string.Empty)
                    {
                        txtCardCity.Text = obj.City;
                    }

                    if (obj.Zip != null && obj.Zip.ToString() != string.Empty)
                    {
                        txtCardZip.Text = obj.Zip;
                    }

                    if (obj.IsCheckingAccount != null && obj.IsCheckingAccount.ToString() != string.Empty && Convert.ToBoolean(obj.IsCheckingAccount))
                    {
                        rdoCardType.Items[0].Selected = false;
                        rdoCardType.Items[1].Selected = true;

                        if (obj.RoutingNo != null && obj.RoutingNo.ToString() != string.Empty)
                        {
                            txtRoutingNo.Text = obj.RoutingNo;
                            txtRoutingNo2.Text = obj.RoutingNo;
                        }                       

                        if (obj.AccountNo != null && obj.AccountNo.ToString() != string.Empty)
                        {
                            txtCheckingAccount.Text = obj.AccountNo;
                            txtCheckingAccount2.Text = obj.AccountNo;
                        }                        

                    }
                    else
                    {
                        rdoCardType.Items[0].Selected = true;
                        rdoCardType.Items[1].Selected = false;

                       

                        if (obj.CardNumber != null && obj.CardNumber.ToString() != string.Empty)
                        {
                            txtCardNumber.Text = obj.CardNumber;
                        }

                        if (obj.CVS != null && obj.CVS.ToString() != string.Empty)
                        {
                            txtCVS.Text = obj.CVS;
                        }

                       

                        if (obj.Month != null && obj.Month.ToString() != string.Empty)
                        {
                            ddlMonth.SelectedValue = obj.Month;
                        }

                        if (obj.Year != null && obj.Year.ToString() != string.Empty)
                        {
                            ddlYear.SelectedValue = obj.Year;
                        }

                    }                  
                }
            }
        }
        
        #endregion
        #region Method
        private void FillDropdowns()
        {
            try
            {
                ddlState.Items.Clear();
                ddlState.AppendDataBoundItems = true;
                ddlState.DataSource = new StateDA().GetAllRefStates();
                ddlState.DataTextField = "STATENAME";
                ddlState.DataValueField = "STATE";
                ddlState.DataBind();
            }
            catch (Exception ex)
            {

            }

            try
            {
                ddlYear.Items.Clear();
                ddlYear.AppendDataBoundItems = true;
                int nStart = DateTime.UtcNow.Year;
                int nEnd = nStart + 10;

                for (int i = nStart; i <= nEnd; i++)
                {
                    ddlYear.Items.Add(new ListItem(i.ToString(), i.ToString()));
                }

                ddlYear.DataBind();
            }
            catch (Exception ex)
            {

            }

            try
            {
                ddlMonth.Items.Clear();
                ddlMonth.AppendDataBoundItems = true;
                int nStart = 1;
                int nEnd = 12;

                for (int i = nStart; i <= nEnd; i++)
                {
                    ddlMonth.Items.Add(new ListItem(i.ToString(), i.ToString()));
                }

                ddlMonth.DataBind();
            }
            catch (Exception ex)
            {

            }

        }
        private void ClearControls()
        {
            rdoFeeType.SelectedValue = null;
            txtWebUrl.Text = "";
            txtEmailServer.Text = "";
            txtEmailUserName.Text = "";
            txtEmailPassword.Text = "";
            txtGateway.Text = "";
            txtTransactionKey.Text = "";
            txtUserId.Text = "";
            txtUserPassword.Text = "";
            txtGateway1.Text = "";
            txtTransactionKey1.Text = "";
            txtUserId1.Text = "";
            txtUserPassword1.Text = "";
            txtFeeAmount.Text = "";
            rdoAccount.SelectedValue = null;
            txtCheckAmount.Text = "";         
            chkIncludeFee.Checked = false;
            chkOneTime.Checked = false;
            chkRecurring.Checked = false;
            chkTenantPayFee.Checked = false;
        }
        private void ClearControlsCardData()
        {
            rdoCardType.SelectedValue = null;
            txtCardAccountName.Text = "";
            txtCardAddress.Text = "";
            txtCardCity.Text = "";
            txtCardZip.Text = "";
            txtCardNumber.Text = "";
            txtCVS.Text = "";
            txtRoutingNo.Text = "";
            txtRoutingNo2.Text = "";
            txtCheckingAccount.Text = "";
            txtCheckingAccount2.Text = "";
            Session["CardId"] = null;
        }
        private SystemInformation SetData(SystemInformation obj)
        {
            try
            {
                obj = new SystemInformation();

                if (Session["AddSystemId"] != null && Convert.ToInt32(Session["AddSystemId"]) > 0)
                {
                    obj = new SystemInformationDA().GetByID(Convert.ToInt32(Session["AddSystemId"]));
                    obj.Id = Convert.ToInt32(Session["AddSystemId"].ToString());
                }

                if (Session["UserId"] != null)
                {
                    obj.UserId = Session["UserId"].ToString();
                }

                if (!string.IsNullOrEmpty(txtWebUrl.Text.ToString()))
                {
                    obj.Website = txtWebUrl.Text.ToString().ToLower().Trim();
                }
                else
                {
                    obj.Website = "";
                }
                if (!string.IsNullOrEmpty(txtEmailServer.Text.ToString()))
                {
                    obj.EmailServer1 = txtEmailServer.Text.ToString();
                }
                else
                {
                    obj.EmailServer1 = "";
                }
                if (!string.IsNullOrEmpty(txtEmailUserName.Text.ToString()))
                {
                    obj.EmailUser1 = txtEmailUserName.Text.ToString();
                }
                else
                {
                    obj.EmailUser1 = "";
                }
                if (!string.IsNullOrEmpty(txtEmailPassword.Text.ToString()))
                {
                    obj.EmailPassword1 = txtEmailPassword.Text.ToString();
                }
                else
                {
                    obj.EmailPassword1 = "";
                }

                if (!string.IsNullOrEmpty(txtGateway.Text.ToString()))
                {
                    obj.SecurityLink = txtGateway.Text.ToString().ToLower().Trim();
                }
                else
                {
                    obj.SecurityLink = "";
                }
                if (!string.IsNullOrEmpty(txtTransactionKey.Text.ToString()))
                {
                    obj.SecurityKey = txtTransactionKey.Text.ToString();
                }
                else
                {
                    obj.SecurityKey = "";
                }
                if (!string.IsNullOrEmpty(txtUserId.Text.ToString()))
                {
                    obj.SecurityUser = txtUserId.Text.ToString();
                }
                else
                {
                    obj.SecurityUser = "";
                }
                if (!string.IsNullOrEmpty(txtUserPassword.Text.ToString()))
                {
                    obj.SecurityPassword = txtUserPassword.Text.ToString();
                }
                else
                {
                    obj.SecurityPassword = "";
                }
                if (!string.IsNullOrEmpty(txtGateway1.Text.ToString()))
                {
                    obj.CreditCardLink = txtGateway1.Text.ToString().ToLower().Trim();
                }
                else
                {
                    obj.CreditCardLink = "";
                }
                if (!string.IsNullOrEmpty(txtTransactionKey1.Text.ToString()))
                {
                    obj.CreditCardKey = txtTransactionKey1.Text.ToString();
                }
                else
                {
                    obj.CreditCardKey = "";
                }
                if (!string.IsNullOrEmpty(txtUserId1.Text.ToString()))
                {
                    obj.CreditCardUser = txtUserId1.Text.ToString();
                }
                else
                {
                    obj.CreditCardUser = "";
                }
                if (!string.IsNullOrEmpty(txtUserPassword1.Text.ToString()))
                {
                    obj.CreditCardPassword = txtUserPassword1.Text.ToString();
                }
                else
                {
                    obj.CreditCardPassword = "";
                }

                

                obj.CreditCardProcessFees = 0;
                if (chkIncludeFee.Checked)
                {
                    obj.IncludeProcessFees = true;
                }
                else
                {
                    obj.IncludeProcessFees = false;
                }
                if (chkTenantPayFee.Checked)
                {
                    obj.TanentPayFees = true;
                }
                else
                {
                    obj.TanentPayFees = false;
                }

               
                if (chkOneTime.Checked)
                {
                    obj.OneTimePay = true;
                }
                else
                {
                    obj.OneTimePay = false;
                }
                if (chkRecurring.Checked)
                {
                    obj.RecurringPay = true;
                }
                else
                {
                    obj.RecurringPay = false;
                }

                obj.IsGlobalSystem = true;

                if (rdoFeeType.Items[0].Selected == true)
                {
                    obj.FeeType = 1;
                    if (!string.IsNullOrEmpty(txtFeeAmount.Text.ToString()))
                    {
                        obj.FeePercentage = Convert.ToDecimal(txtFeeAmount.Text.ToString());
                        obj.FeeFlatAmount = 0;
                    }
                    else
                    {
                        obj.FeePercentage = 0;
                        obj.FeeFlatAmount = 0;
                    }
                }
                else if (rdoFeeType.Items[1].Selected == true)
                {
                    obj.FeeType = 2;
                    if (!string.IsNullOrEmpty(txtFeeAmount.Text.ToString()))
                    {
                        obj.FeeFlatAmount = Convert.ToDecimal(txtFeeAmount.Text.ToString());
                        obj.FeePercentage = 0;
                    }
                    else
                    {
                        obj.FeeFlatAmount = 0;
                        obj.FeePercentage = 0;
                    }
                }

                if (rdoAccount.Items[0].Selected == true)
                {
                    obj.FeeTypeCheck = 1;
                    if (!string.IsNullOrEmpty(txtCheckAmount.Text.ToString()))
                    {
                        obj.FeePercentageCheck = Convert.ToDecimal(txtCheckAmount.Text.ToString());
                        obj.FeeFlatAmountCheck = 0;
                    }
                    else
                    {
                        obj.FeePercentageCheck = 0;
                        obj.FeeFlatAmountCheck = 0;
                    }
                }
                else if (rdoAccount.Items[1].Selected == true)
                {
                    obj.FeeTypeCheck = 2;
                    if (!string.IsNullOrEmpty(txtCheckAmount.Text.ToString()))
                    {
                        obj.FeeFlatAmountCheck = Convert.ToDecimal(txtCheckAmount.Text.ToString());
                        obj.FeePercentageCheck = 0;
                    }
                    else
                    {
                        obj.FeeFlatAmountCheck = 0;
                        obj.FeePercentageCheck = 0;
                    }
                }

            }
            catch (Exception ex)
            {
            }

            return obj;
        }
        private void FillControls(SystemInformation obj)
        {
            try
            {               
                    if (obj != null)
                    {
                        Session["AddSystemId"] = obj.Id;

                        if (obj.Website != null && obj.Website.ToString() != string.Empty)
                        {
                            txtWebUrl.Text = obj.Website;
                        }
                        else
                        {
                            txtWebUrl.Text = "";
                        }

                        if (obj.EmailServer1 != null && obj.EmailServer1.ToString() != string.Empty)
                        {
                            txtEmailServer.Text = obj.EmailServer1;
                        }
                        else
                        {
                            txtEmailServer.Text = "";
                        }

                        if (obj.EmailUser1 != null && obj.EmailUser1.ToString() != string.Empty)
                        {
                            txtEmailUserName.Text = obj.EmailUser1;
                        }
                        else
                        {
                            txtEmailUserName.Text = "";
                        }

                       
                        if (obj.EmailPassword1 != null && obj.EmailPassword1.ToString() != string.Empty)
                        {
                            txtEmailPassword.Text = obj.EmailPassword1;
                            txtEmailPassword.Attributes.Add("value", obj.EmailPassword1.ToString().Trim());
                            
                        }
                        else
                        {
                            txtEmailPassword.Text = "";
                        }

                        if (obj.SecurityLink != null && obj.SecurityLink.ToString() != string.Empty)
                        {
                            txtGateway.Text = obj.SecurityLink;
                        }
                        else
                        {
                            txtGateway.Text = "";
                        }

                      
                        if (obj.SecurityKey != null && obj.SecurityKey.ToString() != string.Empty)
                        {
                            txtTransactionKey.Text = obj.SecurityKey;
                        }
                        else
                        {
                            txtTransactionKey.Text = "";
                        }                       

                        if (obj.SecurityUser != null && obj.SecurityUser.ToString() != string.Empty)
                        {
                            txtUserId.Text = obj.SecurityUser;
                        }
                        else
                        {
                            txtUserId.Text = "";
                        }
                        if (obj.SecurityPassword != null && obj.SecurityPassword.ToString() != string.Empty)
                        {
                            txtUserPassword.Text = obj.SecurityPassword;
                            txtUserPassword.Attributes.Add("value", obj.SecurityPassword.ToString().Trim());
                        }
                        else
                        {
                            txtUserPassword.Text = "";
                        }

                        if (obj.CreditCardLink != null && obj.CreditCardLink.ToString() != string.Empty)
                        {
                            txtGateway1.Text = obj.CreditCardLink;
                        }
                        else
                        {
                            txtGateway1.Text = "";
                        }

                        if (obj.CreditCardKey != null && obj.CreditCardKey.ToString() != string.Empty)
                        {
                            txtTransactionKey1.Text = obj.CreditCardKey;
                        }
                        else
                        {
                            txtTransactionKey1.Text = "";
                        }

                        if (obj.CreditCardUser != null && obj.CreditCardUser.ToString() != string.Empty)
                        {
                            txtUserId1.Text = obj.CreditCardUser;
                        }
                        else
                        {
                            txtUserId1.Text = "";
                        }
                        if (obj.CreditCardPassword != null && obj.CreditCardPassword.ToString() != string.Empty)
                        {
                            txtUserPassword1.Text = obj.CreditCardPassword;
                            txtUserPassword1.Attributes.Add("value", obj.CreditCardPassword.ToString().Trim());
                        }
                        else
                        {
                            txtUserPassword1.Text = "";
                        }

                       
                        if (obj.FeeType != null)
                        {
                            if (Convert.ToInt32(obj.FeeType) == 1)
                            {
                                rdoFeeType.Items[0].Selected = true;
                                if (obj.FeePercentage != null && obj.FeePercentage.ToString() != string.Empty)
                                {
                                    txtFeeAmount.Text = Convert.ToDecimal(obj.FeePercentage).ToString("#.00");
                                }
                            }
                            else if (Convert.ToInt32(obj.FeeType) == 2)
                            {
                                rdoFeeType.Items[1].Selected = true;
                                if (obj.FeeFlatAmount != null && obj.FeeFlatAmount.ToString() != string.Empty)
                                {
                                    txtFeeAmount.Text = Convert.ToDecimal(obj.FeeFlatAmount).ToString("#.00");
                                }
                            }
                        }
                       
                        if (obj.IncludeProcessFees != null)
                        {
                            chkIncludeFee.Checked = Convert.ToBoolean(obj.IncludeProcessFees);
                        }
                        if (obj.TanentPayFees != null)
                        {
                            chkTenantPayFee.Checked = Convert.ToBoolean(obj.TanentPayFees);
                        }                      
                        if (obj.OneTimePay != null)
                        {
                            chkOneTime.Checked = Convert.ToBoolean(obj.OneTimePay);
                        }
                        if (obj.RecurringPay != null)
                        {
                            chkRecurring.Checked = Convert.ToBoolean(obj.RecurringPay);
                        }

                  

                    if (obj.FeeTypeCheck != null)
                    {
                        if (Convert.ToInt32(obj.FeeTypeCheck) == 1)
                        {
                            rdoAccount.Items[0].Selected = true;
                            if (obj.FeePercentageCheck != null && obj.FeePercentageCheck.ToString() != string.Empty)
                            {
                                txtCheckAmount.Text = Convert.ToDecimal(obj.FeePercentageCheck).ToString("#.00");
                            }
                        }
                        else if (Convert.ToInt32(obj.FeeTypeCheck) == 2)
                        {
                            rdoAccount.Items[1].Selected = true;
                            if (obj.FeeFlatAmountCheck != null && obj.FeeFlatAmountCheck.ToString() != string.Empty)
                            {
                                txtCheckAmount.Text = Convert.ToDecimal(obj.FeeFlatAmountCheck).ToString("#.00");
                            }
                        }
                    }

                   

                    btnSave.Text = "Save";

                    }
               
            }
            catch (Exception ex)
            {
            }

        }     
        private void FillCardGrid()
        {
            try
            {
                List<PaymentInformation> objPayments = null;
                if (Session["UserId"] != null)
                {
                    objPayments = new PaymentInformationDA().GetByUserId(Session["UserId"].ToString());
                }
                gvCard.DataSource = objPayments;
                gvCard.DataBind();

            }
            catch (Exception ex)
            {

            }
        }       
        private void SaveCardData()
        {
            try
            {
                PaymentInformation objPaymentInformation = new PaymentInformation();

                if (Session["CardId"] != null && Convert.ToInt32(Session["CardId"]) > 0)
                {
                    objPaymentInformation.Id = Convert.ToInt32(Session["CardId"].ToString());
                }
               

                if (Session["UserId"] != null)
                {
                    objPaymentInformation.UserId = Session["UserId"].ToString();
                }
                else
                {
                    objPaymentInformation.UserId = "";
                }

                objPaymentInformation.AccountName = txtCardAccountName.Text.ToString();
                objPaymentInformation.Address = txtCardAddress.Text.ToString();
                objPaymentInformation.Address1 = "";
                objPaymentInformation.City = txtCardCity.Text.ToString();
                objPaymentInformation.State = ddlState.SelectedValue;
                objPaymentInformation.Zip = txtCardZip.Text.ToString();

                if (rdoCardType.Items[0].Selected == true)
                {
                    objPaymentInformation.IsCheckingAccount = false;                   
                    objPaymentInformation.CardNumber = txtCardNumber.Text.ToString();
                    objPaymentInformation.CVS = txtCVS.Text.ToString();
                    objPaymentInformation.Month = ddlMonth.SelectedValue;
                    objPaymentInformation.Year = ddlYear.SelectedValue;

                    if (objPaymentInformation.CardNumber.Trim().Length > 4)
                    {
                        objPaymentInformation.LastFourDigitCard = objPaymentInformation.CardNumber.Substring(objPaymentInformation.CardNumber.Length - 4, 4);
                    }
                    else
                    {
                        objPaymentInformation.LastFourDigitCard = "";
                    }

                    objPaymentInformation.AccountNo = "";
                    objPaymentInformation.RoutingNo = "";
                    objPaymentInformation.CheckNo = "";
                }
                else
                {
                    objPaymentInformation.IsCheckingAccount = true;
                    objPaymentInformation.AccountNo = txtCheckingAccount.Text.ToString();
                    objPaymentInformation.RoutingNo = txtRoutingNo.Text.ToString();
                    objPaymentInformation.CheckNo = "";                  
                    objPaymentInformation.CardNumber = "";
                    objPaymentInformation.CVS = "";
                    objPaymentInformation.Month = "";
                    objPaymentInformation.Year = "";
                   
                    if (objPaymentInformation.AccountNo.Trim().Length >= 4)
                    {
                        objPaymentInformation.LastFourDigitCard = objPaymentInformation.AccountNo.Substring(objPaymentInformation.AccountNo.Length - 4, 4);
                    }
                    else
                    {
                        objPaymentInformation.LastFourDigitCard = "";
                    }
                }



                if (Session["CardId"] == null || Session["CardId"] == "0")
                {
                    if (new PaymentInformationDA().Insert(objPaymentInformation))
                    {
                        FillCardGrid();
                        ClearControlsCardData();
                        Utility.DisplayMsg("Successfully saved!", this);
                    }
                    else
                    {
                        Utility.DisplayMsg("Data not saved!", this);
                    }
                }
                else
                {
                    if (new PaymentInformationDA().Update(objPaymentInformation))
                    {
                        FillCardGrid();
                        ClearControlsCardData();
                        Utility.DisplayMsg("Successfully updated!", this);
                    }
                    else
                    {
                        Utility.DisplayMsg("Data not updated!", this);
                    }
                }
            }
            catch (Exception ex1)
            {

            }
        }


        #endregion
    }
}