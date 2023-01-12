using System;
using System.Net;
using TagService.BO;
using TagService.DA;
using Twilio;
using Twilio.Rest.Api.V2010.Account;
using Twilio.Types;
using System.Text.RegularExpressions;


namespace eTag365.Pages.Admin
{
    public partial class PhoneVerify : System.Web.UI.Page
    {
        public string errStr = string.Empty;
        string strLoginID = System.Configuration.ConfigurationManager.AppSettings.Get("TLoginID");
        string strSecureKey = System.Configuration.ConfigurationManager.AppSettings.Get("TProcessingKey");
        string strFromKey = System.Configuration.ConfigurationManager.AppSettings.Get("TFromKey");
        public string sCode = string.Empty;
        public string sPhone = string.Empty;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["Phone"] == null)
                {
                    Response.Redirect(Utility.WebUrl +"/login");
                }               
            }
        }
        #region Events

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            errStr = string.Empty;
            errStr = Validate_Control();
            if (errStr.Length <= 0)
            {
                verifyPhone();
            }
            else
            {
                Utility.DisplayMsg(errStr.ToString(), this);
            }

        }
        protected void btnClose_Click(object sender, EventArgs e)
        {
            // ClearControls();
            try
            {
                UserProfile objUser = new UserProfile();
                string sPhone = "";
                if (Session["Phone"] != null)
                {
                    sPhone = Session["Phone"].ToString();
                }

                objUser = new UserProfileDA().GetUserByPhone(sPhone);
                if (objUser != null)
                {
                    objUser.IsPhoneVerified = true;
                    objUser.PhoneVerifyCode = "9451";
                    if (new UserProfileDA().Update(objUser))
                    {
                        Response.Redirect(Utility.WebUrl + "/reset-password");
                    }
                    else
                    {
                        Utility.DisplayMsg("Technical issues found !!", this);
                    }
                }
            }
            catch (Exception ex2)
            {
                Utility.DisplayMsg(ex2.Message.ToString(), this);
            }
        }
        protected void btnSend_Click(object sender, EventArgs e)
        {
            resendCode();
        }


        #endregion

        #region Method
        private void ClearControls()
        {
            txtNumber.Text = "";
        }
        public string Validate_Control()
        {
            try
            {
                if (txtNumber.Text.ToString().Length <= 0)
                {
                    errStr += "Please Enter Code" + Environment.NewLine;
                }          

            }
            catch (Exception ex)
            {
            }

            return errStr;
        }            
        public void verifyPhone()
        {
            try
            {
                UserProfile objUser = new UserProfile();
                string sPhone = "";
                if (Session["Phone"] != null)
                {
                    sPhone = Session["Phone"].ToString();
                }

                objUser = new UserProfileDA().GetUserByPhone(sPhone);

                if (objUser != null)
                {
                    if (objUser.PhoneVerifyCode != null && objUser.PhoneVerifyCode == txtNumber.Text.ToString().Trim())
                    {
                        objUser.IsPhoneVerified = true;

                        if (new UserProfileDA().Update(objUser))
                        {
                            Response.Redirect(Utility.WebUrl +"/reset-password");

                            //if (objUser.IsNewUser != null && objUser.IsNewUser == false)
                            //{
                            //    Response.Redirect(Utility.WebUrl +"/password");
                            //}
                            //else
                            //{
                            //    Response.Redirect(Utility.WebUrl +"/reset-password");
                            //}
                        }
                        else
                        {
                            Utility.DisplayMsg("Technical issues found !!", this);
                        }
                    }
                    else
                    {
                        Utility.DisplayMsg("Incorrect Verification code !", this);
                    }
                }
                else
                {
                    Utility.DisplayMsg("User Not Found !", this);
                }
            }
            catch (Exception ex1)
            {
                Utility.DisplayMsg(ex1.Message.ToString(), this);
            }
        }
        public bool sendSMS(string strPhone, string strMessage)
        {
            bool bIsSend = false;
            try
            {
                //fields are required to be filled in:
                if (strPhone != "" && strMessage != "")
                {
                    string sPhone = Regex.Replace(strPhone, @"[^0-9]", "");

                    if (strPhone.Length == 10)
                    {
                        strPhone = "+1" + strPhone;
                    }
                    else
                    {
                        strPhone = "+" + strPhone;
                    }

                    try
                    {
                        ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls
                                                 | SecurityProtocolType.Tls11
                                                 | SecurityProtocolType.Tls12
                                                 | SecurityProtocolType.Ssl3;



                        var accountSid = strLoginID;
                        var authToken = strSecureKey;

                        TwilioClient.Init(accountSid, authToken);

                        var messageOptions = new CreateMessageOptions(
                            new PhoneNumber(strPhone));
                        messageOptions.From = new PhoneNumber(strFromKey);
                        messageOptions.Body = "Your eTag365 Verification Code - " + strMessage;

                        var message = MessageResource.Create(messageOptions);

                        bIsSend = true;


                    }
                    catch (Exception ex)
                    {
                        bIsSend = false;

                    }
                }

            }
            catch (Exception ex)
            {
                bIsSend = false;
            }

            return bIsSend;
        }
        public void resendCode()
        {
            try
            {
                UserProfile objUser = new UserProfile();
                if (Session["Phone"] != null)
                {
                    sPhone = Session["Phone"].ToString();
                }

                Random random = new Random();
                long nRandom = random.Next(100000, 999999);

                if (sCode == null || sCode == "")
                {
                    sCode = nRandom.ToString();
                }

                if (sPhone != "" && sCode != "")
                {
                    if (sendSMS(sPhone, sCode))
                    {                        
                        if (Session["Phone"] != null)
                        {
                            objUser = new UserProfileDA().GetUserByPhone(Session["Phone"].ToString());
                            if (objUser != null)
                            {
                                objUser.PhoneVerifyCode = sCode;
                                if (new UserProfileDA().Update(objUser))
                                {
                                    Session["Phone"] = objUser.Phone;
                                }
                            }
                        }

                        Utility.DisplayMsg("Code sent successfully !!", this);
                        lblError.Text = "Code sent successfully !!";

                    }
                    else
                    {
                        Utility.DisplayMsg("Code not sent !!", this);
                        lblError.Text = "Code not sent !!";
                    }
                }
            }
            catch (Exception)
            {
            }
        }

        #endregion

    }
}