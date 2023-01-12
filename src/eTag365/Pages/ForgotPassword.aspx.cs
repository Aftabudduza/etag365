using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text.RegularExpressions;
using System.Net;
using Twilio;
using Twilio.Rest.Api.V2010.Account;
using Twilio.Types;
using TagService.BO;
using TagService.DA;

namespace eTag365.Pages
{
    public partial class ForgotPassword : System.Web.UI.Page
    {
        private System.Net.Mail.SmtpClient objSmtpClient;
        private System.Net.Mail.MailMessage objMailMessage;
        public String errStr = String.Empty;
        private Regex reEmail = new Regex("^(?:[0-9A-Z_-]+(?:\\.[0-9A-Z_-]+)*@[0-9A-Z-]+(?:\\.[0-9A-Z-]+)*(?:\\.[A-Z]{2,4}))$", RegexOptions.Compiled | RegexOptions.ExplicitCapture | RegexOptions.IgnoreCase);
       
        string strLoginID = System.Configuration.ConfigurationManager.AppSettings.Get("TLoginID");
        string strSecureKey = System.Configuration.ConfigurationManager.AppSettings.Get("TProcessingKey");
        string strFromKey = System.Configuration.ConfigurationManager.AppSettings.Get("TFromKey");

        public string sCode = string.Empty;
        public string sPhone = string.Empty;

        #region Events
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {

            }
        }
        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            errStr = string.Empty;
            errStr = Validate_Control();
            if (errStr.Length <= 0)
            {
                try
                {
                    Random random = new Random();
                    long nRandom = random.Next(100000, 999999);
                    bool bIsSent = false;
                    sCode = nRandom.ToString();                   

                    if (SendEmail(txtEmail.Text.ToString()))
                    {
                        bIsSent = true;
                    }
                    
                    if(sendSMS(txtNumber.Text.ToString().Trim(), sCode))
                    {
                        string sPhone = Regex.Replace(txtNumber.Text.ToString().Trim(), @"[^0-9]", "");

                        UserProfile objUser = new UserProfileDA().GetUserByPhone(sPhone);

                        if (objUser != null)
                        {
                            objUser.PhoneVerifyCode = sCode;
                            if (new UserProfileDA().Update(objUser))
                            {
                                Session["Phone"] = objUser.Phone;
                            }
                        }

                        Utility.DisplayMsgAndRedirect("Code sent successfully !!", this, Utility.WebUrl + "/phone-verify");
                    }
                    else
                    {
                        if (bIsSent)
                        {
                            Utility.DisplayMsgAndRedirect("Email sent successfully !!", this, Utility.WebUrl + "/login");
                        }
                        else
                        {
                            Response.Redirect(Utility.WebUrl +"/login");
                        }
                        
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
        }
        #endregion

        #region Method
        private void ClearControls()
        {
            txtNumber.Text = "";
            txtEmail.Text = "";
        }
        public string Validate_Control()
        {
            try
            {
                if (txtEmail.Text.ToString() != string.Empty)
                {
                    if (!ValidEmail(txtEmail.Text.ToString().Trim()))
                    {
                        errStr += "Invalid email address" + Environment.NewLine;
                    }
                    else
                    {
                        UserProfile objUser = new UserProfileDA().GetUserByEmail(txtEmail.Text.ToString().Trim());

                        if (objUser == null)
                        {
                            errStr += "Email Address does not exist !! Please enter different Email Address. " + Environment.NewLine;
                        }
                    }                    
                    
                }

                if (txtNumber.Text.ToString() != string.Empty)
                {
                    if (txtNumber.Text.ToString().Trim().Length < 10)
                    {
                        errStr += "Invalid Cell Number" + Environment.NewLine;
                    }
                    else
                    {
                        string sPhone = Regex.Replace(txtNumber.Text.ToString().Trim(), @"[^0-9]", "");

                        UserProfile objUser = new UserProfileDA().GetUserByPhone(sPhone);

                        if (objUser == null)
                        {
                            errStr += "Cell Number does not exist !! Please enter different Cell Number. " + Environment.NewLine;
                        }
                        else
                        {
                            Session["Phone"] = objUser.Phone;
                        }
                    }                   
                    
                }
               

            }
            catch (Exception ex)
            {
            }

            return errStr;
        }
        public bool ValidEmail(string value)
        {
            if ((value == null))
                return false;
            return reEmail.IsMatch(value);
        }
        public bool SendEmail(string sEmail)
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

                from_address = System.Configuration.ConfigurationManager.AppSettings.Get("fromAddress");

                try
                {
                    to_address = sEmail;
                }
                catch (Exception e)
                {
                    to_address = System.Configuration.ConfigurationManager.AppSettings.Get("bcc_address");
                }               

                objMailMessage = new System.Net.Mail.MailMessage();
                objMailMessage.From = new System.Net.Mail.MailAddress(from_address, "eTag365 Support");
                objMailMessage.To.Add(new System.Net.Mail.MailAddress(to_address));
                objMailMessage.Subject = "Forgot Password Request from eTag365";
                objMailMessage.IsBodyHtml = true;
                objMailMessage.Body = this.EmailHtml(sEmail).ToString();
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
        public System.Text.StringBuilder EmailHtml(string sEmail)
        {
            System.Text.StringBuilder emailbody = new System.Text.StringBuilder();
            string sWeb = System.Configuration.ConfigurationManager.AppSettings.Get("WebURL");
            string sUrl = Utility.WebUrl + "/reset-password?e=" + sEmail;
            try
            {
                emailbody.Append("<table>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'><img  alt='eTag365' width='120' src='" + sWeb + "/Images/logo.png'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2' style='text-align:Left;font-size:14px;font-weight:bold;color:0000cc;'>Dear User,</td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'><p><a style='color:blue;' href='" + sUrl + "' target='_blank'>Click here to reset your password  </a>. Thank you.</p> </td></tr>");
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

        #endregion
    }
}