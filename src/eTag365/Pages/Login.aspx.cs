using eTagService.Enums;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Text.RegularExpressions;
using System.Threading;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TagService.BO;
using TagService.DA;
using Twilio;
using Twilio.Rest.Api.V2010.Account;
using Twilio.Types;

namespace eTag365.Pages
{
    public partial class Login : System.Web.UI.Page
    {
        public string conStr = System.Configuration.ConfigurationManager.ConnectionStrings["eTagDB"].ConnectionString;
        string strLoginID = System.Configuration.ConfigurationManager.AppSettings.Get("TLoginID");
        string strSecureKey = System.Configuration.ConfigurationManager.AppSettings.Get("TProcessingKey");
        string strFromKey = System.Configuration.ConfigurationManager.AppSettings.Get("TFromKey");
        public string sCode = string.Empty;
        public string sPhone = string.Empty;
        public string errStr = string.Empty;
        private Regex rePhone = new Regex("^[0-9-]+$", RegexOptions.Compiled | RegexOptions.ExplicitCapture | RegexOptions.IgnoreCase);
        private System.Net.Mail.SmtpClient objSmtpClient;
        private System.Net.Mail.MailMessage objMailMessage;
        protected void Page_Load(object sender, EventArgs e)
        {
            spanYear.InnerHtml = DateTime.UtcNow.Year.ToString();
            lblError.Text = "";
            if (!IsPostBack)
            {
                lblError.Text = "";
                Session["Phone"] = null;
                Session.Abandon();
                Session.Clear();
                FillDropdowns();
            }
        }
        private void FillDropdowns()
        {
            List<Country> listCountry = null;
            listCountry = new CountryDA().GetAllRefCountries();
           
            try
            {
                ddlCountry.Items.Clear();
                ddlCountry.AppendDataBoundItems = true;
                ddlCountry.Items.Add(new ListItem("Select Country", "-1"));
                if (listCountry != null && listCountry.Count > 0)
                {                   
                    foreach (Country obj in listCountry)
                    {
                        string name = obj.nicename + " (+" + obj.phonecode.ToString() + ")";
                        ddlCountry.Items.Add(new ListItem(name, obj.iso.ToString()));
                    }

                    ddlCountry.DataBind();
                    ddlCountry.SelectedValue = "US";
                }               
               
            }
            catch (Exception ex)
            {

            }

        }
        private UserProfile SetData(UserProfile obj)
        {
            obj = new UserProfile();
            string sCountryCode = "";
            
            if (ddlCountry.SelectedValue != "-1")
            {
                Country objCountry = new CountryDA().GetByShortCode(ddlCountry.SelectedValue);
                sCountryCode = objCountry != null ? objCountry.phonecode.ToString() : "";
                obj.CountryCode = sCountryCode;
            }

            if (string.IsNullOrEmpty(obj.CountryCode))
            {
                sCountryCode = "1";
                obj.CountryCode = "1";
            }

            if (!string.IsNullOrEmpty(txtPhone.Text.ToString()))
            {
                string sPhone = Regex.Replace(txtPhone.Text.ToString().Trim(), @"[^0-9]", "");  

                string sUsername = sCountryCode + sPhone;
                obj.Username = sUsername;

                obj.Phone = sUsername;
                obj.Password = Utility.base64Encode(obj.Phone);
            }
                       
            obj.IsAdmin = false;

            //string tempEmail = obj.Email;
            //char ch = '@';
            //int idx = tempEmail.IndexOf(ch);
            //string username = tempEmail.Substring(0, idx);

            
            obj.DatabaseName = "";
            obj.DatabaseLocation = "";  
            obj.CanLogin = false;
            obj.IsDeleted = false;
            obj.IsActive = true;
            obj.CreatedDate = DateTime.Now;
            obj.IsBillingComplete = false;
            obj.CreatedBy = obj.Username;  
            obj.IsNewUser = true;
            obj.Serial = new UserProfileDA().MakeAutoGenerateSerial("U", "User");
            Random random = new Random();
            long nRandom = random.Next(100000, 999999);

            obj.PhoneVerifyCode = nRandom.ToString();
            obj.IsPhoneVerified = false;

            obj.UserTypeContact = ((Int16)EnumUserType.Normal).ToString();
            obj.Country = ddlCountry.SelectedValue != "-1" ? ddlCountry.SelectedValue : "US";
            obj.Longitude = "";
            obj.Latitude = "";           

            return obj;
        }          
        public string Validate_Control()
        {
            try
            {
                if (txtPhone.Text.ToString() == string.Empty)
                {
                    errStr += "Please Enter Cell Number" + Environment.NewLine;
                }
                else
                {  
                    if(txtPhone.Text.ToString().Trim().Length < 10)
                    {
                        errStr += "Invalid Cell Number" + Environment.NewLine;
                    }
                }

               
            }
            catch (Exception ex)
            {
            }

            return errStr;
        }
        public bool ValidPhone(string value)
        {
            if ((value == null))
                return false;
            return rePhone.IsMatch(value);
        }
        public bool sendSMS(string strPhone, string strMessage)
        {
            bool bIsSend = false;
            try
            {
                //fields are required to be filled in:
                if (strPhone != "" && strMessage != "")
                {
                    if(strPhone.Length == 10)
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
                        messageOptions.Body = strMessage;

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
        public void IsLogin()
        {
            if (!string.IsNullOrEmpty(txtPhone.Text.Trim()))
            {
                TagEntities mEntity = new TagEntities();
                try
                {
                    UserProfile objUser = null;
                    string sCountryCode = "";

                    string sPhone = Regex.Replace(txtPhone.Text.ToString().Trim(), @"[^0-9]", "");

                    if (ddlCountry.SelectedValue != "-1")
                    {
                        Country objCountry = new CountryDA().GetByShortCode(ddlCountry.SelectedValue);
                        sCountryCode = objCountry != null ? objCountry.phonecode.ToString() : "";
                    }

                    if (string.IsNullOrEmpty(sCountryCode))
                    {
                        sCountryCode = "1";
                    }

                    if (!string.IsNullOrEmpty(sCountryCode))
                    {
                        sPhone = sCountryCode + sPhone;
                    }

                    //if (sPhone.Length > 10)
                    //{
                    //    sPhone = sPhone.Substring(sPhone.Length - 10);
                    //}

                    objUser = new UserProfileDA().GetUserByPhone(sPhone);
                    
                    if (objUser != null)
                    {
                        HttpContext.Current.Session["Phone"] = objUser.Phone;

                        if (objUser.Serial == null || objUser.Serial == "" || objUser.Serial == "U00000000000")
                        {
                            objUser.Serial = new UserProfileDA().MakeAutoGenerateSerial("U", "User");
                            if (new UserProfileDA().Update(objUser))
                            {

                            }
                        }


                        if (objUser.IsNewUser != null && objUser.IsNewUser == false)
                        {
                            if (objUser.IsPhoneVerified != null && objUser.IsPhoneVerified == true)
                            {
                                Response.Redirect(Utility.WebUrl + "/password");
                            }
                            else
                            {
                                if (objUser.PhoneVerifyCode != null && objUser.PhoneVerifyCode != "")
                                {
                                    sCode = objUser.PhoneVerifyCode;
                                }
                                else
                                {
                                    Random random = new Random();
                                    long nRandom = random.Next(100000, 999999);

                                    if (sCode == null || sCode == "")
                                    {
                                        sCode = nRandom.ToString();
                                    }
                                }

                                sPhone = HttpContext.Current.Session["Phone"].ToString();

                                if (sPhone != "" && sCode != "")
                                {
                                    string sMessage = "Your eTag365 Verification Code - " + sCode;
                                    if (sendSMS(sPhone, sMessage))
                                    {
                                        objUser.PhoneVerifyCode = sCode;
                                        if (new UserProfileDA().Update(objUser))
                                        {
                                            Session["Phone"] = objUser.Phone;
                                        }

                                        Response.Redirect(Utility.WebUrl + "/phone-verify");
                                    }
                                    else
                                    {
                                        Response.Redirect(Utility.WebUrl + "/phone-verify");
                                    }
                                }
                                else
                                {
                                    Response.Redirect(Utility.WebUrl + "/phone-verify");
                                }

                            }
                        }
                        else
                        {
                            if (objUser.IsPhoneVerified != null && objUser.IsPhoneVerified == true)
                            {
                                Response.Redirect(Utility.WebUrl + "/reset-password");
                            }
                            else
                            {
                                if (objUser.PhoneVerifyCode != null && objUser.PhoneVerifyCode != "")
                                {
                                    sCode = objUser.PhoneVerifyCode;
                                }
                                else
                                {
                                    Random random = new Random();
                                    long nRandom = random.Next(100000, 999999);

                                    if (sCode == null || sCode == "")
                                    {
                                        sCode = nRandom.ToString();
                                    }
                                }

                                sPhone = HttpContext.Current.Session["Phone"].ToString();

                                if (sPhone != "" && sCode != "")
                                {
                                    string sMessage = "Your eTag365 Verification Code - " + sCode;
                                    if (sendSMS(sPhone, sMessage))
                                    {
                                        objUser.PhoneVerifyCode = sCode;
                                        if (new UserProfileDA().Update(objUser))
                                        {
                                            HttpContext.Current.Session["Phone"] = objUser.Phone;
                                            Response.Redirect(Utility.WebUrl + "/phone-verify");
                                        }
                                        else
                                        {
                                            Response.Redirect(Utility.WebUrl + "/phone-verify");
                                        }

                                    }
                                    else
                                    {
                                        Response.Redirect(Utility.WebUrl + "/phone-verify");
                                    }
                                }
                                else
                                {
                                    Response.Redirect(Utility.WebUrl + "/phone-verify");
                                }

                            }

                        }
                    }
                    else
                    {
                        objUser = SetData(objUser);
                        if (new UserProfileDA(true, false).Insert(objUser))
                        {
                            HttpContext.Current.Session["Phone"] = objUser.Phone;
                            sPhone = HttpContext.Current.Session["Phone"].ToString();
                            sCode = objUser.PhoneVerifyCode;

                            if (objUser.IsNewUser != null && objUser.IsNewUser == true)
                            {
                                //string sMessage = "eTag365 has created your very secure contact information manager account. Please complete your profile. Press the following link https://www.etag365.com/deal. Enter this mobile number for Username and Password you want and fill out the rest of the form. Thank you.";
                                string sMessage = "eTag365 has created your very secure contact information manager account. Please complete your profile. Press the following link https://www.etag365.com/deal. Enter this mobile number for Username and Password you want and fill out the rest of the form. Thank you.";
                                if (sendSMS(sPhone, sMessage))
                                {

                                }
                            }

                            //if (SendEmail(objUser.Email))
                            //{
                            //    if (SendEmailToAdmin(objUser.Id))
                            //    {
                            //        string SQLMail = " update UserProfile set IsSentMail = '1'  where Id = " + objUser.Id;
                            //        Utility.RunCMDMain(SQLMail);
                            //    }
                            //}

                            if (SendEmailToAdmin(objUser.Id))
                            {
                                string SQLMail = " update UserProfile set IsSentMail = '1'  where Id = " + objUser.Id;
                                Utility.RunCMDMain(SQLMail);
                            }

                            try
                            {
                                if (sPhone != "" && sCode != "")
                                {
                                    string sMessage = "Your eTag365 Verification Code - " + sCode;
                                    if (sendSMS(sPhone, sMessage))
                                    {
                                        Response.Redirect(Utility.WebUrl + "/phone-verify");
                                    }
                                    else
                                    {
                                        Response.Redirect(Utility.WebUrl + "/reset-password");
                                    }
                                }

                                else if (objUser.IsPhoneVerified != null && objUser.IsPhoneVerified == true)
                                {
                                    Response.Redirect(Utility.WebUrl + "/reset-password");
                                }
                                else
                                {
                                    Response.Redirect(Utility.WebUrl + "/phone-verify");
                                }
                            }
                            catch (Exception)
                            {
                            }

                        }
                        else
                        {
                            lblError.Text = "Technical issues found!";
                        }
                    }
                }
                catch (Exception ex)
                {
                    lblError.Text = "Technical issues found!";
                }

            }
            else
            {
                lblError.Text = "Please enter cell Phone Number !";
            }
        }
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            errStr = string.Empty;
            errStr = Validate_Control();
            if (errStr.Length <= 0)
            {
                IsLogin();
            }
            else
            {
                Utility.DisplayMsg(errStr.ToString(), this);
            }
            
        }

        //public void IsLogin()
        //{
        //    if (!string.IsNullOrEmpty(txtPhone.Text.Trim()))
        //    {
        //        TagEntities mEntity = new TagEntities();
        //        try
        //        {
        //            UserProfile objUser = new UserProfile();
        //            string sCountryCode = "";
        //            string sPhone = Regex.Replace(txtPhone.Text.ToString().Trim(), @"[^0-9]", "");
                   
        //            if (ddlCountry.SelectedValue != "-1")
        //            {
        //                Country objCountry = new CountryDA().GetByShortCode(ddlCountry.SelectedValue);
        //                sCountryCode = objCountry != null ? objCountry.phonecode.ToString() : "";
        //            }

        //            if (string.IsNullOrEmpty(sCountryCode))
        //            {
        //                sCountryCode = "1";
        //            }

        //            if (!string.IsNullOrEmpty(sCountryCode))
        //            {
        //                sPhone = sCountryCode + sPhone;
        //            }

        //            //if (sPhone.Length > 10)
        //            //{
        //            //    sPhone = sPhone.Substring(sPhone.Length - 10);
        //            //}

        //            objUser = new UserProfileDA().GetUserByPhone(sPhone);

        //            if (objUser != null)
        //            {
        //                HttpContext.Current.Session["Phone"] = objUser.Phone;

        //                if (objUser.Serial == null || objUser.Serial == "" || objUser.Serial == "U00000000000")
        //                {
        //                    objUser.Serial = new UserProfileDA().MakeAutoGenerateSerial("U", "User");
        //                    if (new UserProfileDA().Update(objUser))
        //                    {

        //                    }
        //                }

        //                if (objUser.CanLogin != null && objUser.CanLogin == true)
        //                {
        //                    Response.Redirect(Utility.WebUrl + "/password");
        //                }
        //                else
        //                {
        //                    Response.Redirect(Utility.WebUrl + "/reset-password");
        //                }                      
        //            }
        //            else
        //            {
        //                objUser = SetData(objUser);

        //                if (new UserProfileDA(true, false).Insert(objUser))
        //                {
        //                    HttpContext.Current.Session["Phone"] = objUser.Phone; 
        //                    Response.Redirect(Utility.WebUrl + "/reset-password");
        //                }
        //                else
        //                {
        //                    lblError.Text = "Technical issues found!";
        //                }
        //            }
        //        }
        //        catch (Exception ex)
        //        {
        //            lblError.Text = "Technical issues found!";
        //        }

        //    }
        //    else
        //    {
        //        lblError.Text = "Please enter cell Phone Number !";
        //    }
        //}
        public bool SendEmailToAdmin(int nUserId)
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
                objMailMessage.Subject = "New user Registration request from eTag365";
                objMailMessage.IsBodyHtml = true;
                objMailMessage.Body = this.EmailHtmlToAdmin(nUserId).ToString();
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
        public System.Text.StringBuilder EmailHtmlToAdmin(int nUserId)
        {
            System.Text.StringBuilder emailbody = new System.Text.StringBuilder();
            string sWeb = System.Configuration.ConfigurationManager.AppSettings.Get("WebUrl");
            string sUrl = sWeb + "/login";
            //string sSQL = " Select isnull(Password,'') Password,isnull(Email,'') Email,isnull(Phone,'') Phone,isnull(FirstName,'') FirstName,isnull(LastName,'') LastName,isnull(Title,'') Title,isnull(CompanyName,'') CompanyName,isnull(WorkPhone,'') WorkPhone,isnull(Address,'') Address,isnull(Address1,'') Address1,isnull(State,'') State,isnull(City,'') City,isnull(Region,'') Region,isnull(Zip,'') Zip, isnull(Fax,'') Fax, isnull(WorkPhoneExt,'') WorkPhoneExt from UserProfile where Id = " + nUserId.ToString();
            string sSQL = " Select isnull(Password,'') Password, isnull(Phone,'') Phone from UserProfile where Id = " + nUserId.ToString();

            DataTable dtResult = SqlToTbl(sSQL);
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
                emailbody.Append("<tr><td colspan='2'><p>eTag365 has created a new user. </p> </td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                string sCell = "";
                string sPassword = "";
                if (dtResult != null && dtResult.Rows.Count > 0)
                {
                    sCell = (dtResult.Rows[0]["Phone"] != null && dtResult.Rows[0]["Phone"] != DBNull.Value) ? dtResult.Rows[0]["Phone"].ToString() : "";
                    sPassword = (dtResult.Rows[0]["Password"] != null && dtResult.Rows[0]["Password"] != DBNull.Value) ? dtResult.Rows[0]["Password"].ToString() : "";
                    sPassword = sPassword.Length > 0 ? Utility.base64Decode(sPassword) : "";
                }

                emailbody.Append("<tr><td>Cell Number: </td><td> +" + sCell + " </td></tr>");

                emailbody.Append("<tr><td>Password: </td><td> " + sPassword + " </td></tr>");

                emailbody.Append("<tr><td>Transaction Date: </td><td> " + Convert.ToDateTime(DateTime.Now).ToString("MM/dd/yyyy hh:mm:ss tt") + " </td></tr>");

                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'>Best Regards</td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'><p>eTag365 Team</p> </td></tr>");
                emailbody.Append("</table>");
            }
            catch (Exception ex)
            {
            }
            return emailbody;
        }

        //public System.Text.StringBuilder EmailHtmlToAdmin(int nUserId)
        //{
        //    System.Text.StringBuilder emailbody = new System.Text.StringBuilder();
        //    string sWeb = System.Configuration.ConfigurationManager.AppSettings.Get("WebUrl");
        //    string sUrl = sWeb + "/login";
        //    string sSQL = " Select isnull(Email,'') Email,isnull(Phone,'') Phone,isnull(FirstName,'') FirstName,isnull(LastName,'') LastName,isnull(Title,'') Title,isnull(CompanyName,'') CompanyName,isnull(WorkPhone,'') WorkPhone,isnull(Address,'') Address,isnull(Address1,'') Address1,isnull(State,'') State,isnull(City,'') City,isnull(Region,'') Region,isnull(Zip,'') Zip, isnull(Fax,'') Fax from UserProfile where Id = " + nUserId.ToString();

        //    DataTable dtResult = SqlToTbl(sSQL);
        //    try
        //    {
        //        emailbody.Append("<table>");
        //        emailbody.Append("<tr><td colspan='2'></td></tr>");
        //        emailbody.Append("<tr><td colspan='2'><img  alt='eTag365' width='120' src='" + sWeb + "/Images/logo.png'></td></tr>");
        //        emailbody.Append("<tr><td colspan='2'></td></tr>");
        //        emailbody.Append("<tr><td colspan='2'></td></tr>");
        //        emailbody.Append("<tr><td colspan='2' style='text-align:Left;font-size:14px;font-weight:bold;color:0000cc;'>Dear Admin</td></tr>");
        //        emailbody.Append("<tr><td colspan='2'></td></tr>");
        //        emailbody.Append("<tr><td colspan='2'></td></tr>");
        //        emailbody.Append("<tr><td colspan='2'><p>eTag365 has created a new user. </p> </td></tr>");
        //        emailbody.Append("<tr><td colspan='2'></td></tr>");

        //        if (dtResult != null && dtResult.Rows.Count > 0)
        //        {
        //            emailbody.Append("<tr><td>First Name: </td><td> " + ((dtResult.Rows[0]["FirstName"] != null && dtResult.Rows[0]["FirstName"] != DBNull.Value) ? dtResult.Rows[0]["FirstName"].ToString() : "") + " </td></tr>");
        //            emailbody.Append("<tr><td>Last Name: </td><td> " + ((dtResult.Rows[0]["LastName"] != null && dtResult.Rows[0]["LastName"] != DBNull.Value) ? dtResult.Rows[0]["LastName"].ToString() : "") + " </td></tr>");
        //            //  emailbody.Append("<tr><td>Title: </td><td> " + ((dtResult.Rows[0]["Title"] != null && dtResult.Rows[0]["Title"] != DBNull.Value) ? dtResult.Rows[0]["Title"].ToString() : "") + " </td></tr>");
        //            emailbody.Append("<tr><td>Email: </td><td> " + ((dtResult.Rows[0]["Email"] != null && dtResult.Rows[0]["Email"] != DBNull.Value) ? dtResult.Rows[0]["Email"].ToString() : "") + " </td></tr>");
        //            emailbody.Append("<tr><td>Cell Number: </td><td> " + ((dtResult.Rows[0]["Phone"] != null && dtResult.Rows[0]["Phone"] != DBNull.Value) ? dtResult.Rows[0]["Phone"].ToString() : "") + " </td></tr>");
        //            //emailbody.Append("<tr><td>Work Phone: </td><td> " + ((dtResult.Rows[0]["WorkPhone"] != null && dtResult.Rows[0]["WorkPhone"] != DBNull.Value) ? dtResult.Rows[0]["WorkPhone"].ToString() : "") + " </td></tr>");
        //            //emailbody.Append("<tr><td>Fax: </td><td> " + ((dtResult.Rows[0]["Fax"] != null && dtResult.Rows[0]["Fax"] != DBNull.Value) ? dtResult.Rows[0]["Fax"].ToString() : "") + " </td></tr>");
        //            //emailbody.Append("<tr><td>Company Name: </td><td> " + ((dtResult.Rows[0]["CompanyName"] != null && dtResult.Rows[0]["CompanyName"] != DBNull.Value) ? dtResult.Rows[0]["CompanyName"].ToString() : "") + " </td></tr>");
        //            //emailbody.Append("<tr><td>Address: </td><td> " + ((dtResult.Rows[0]["Address"] != null && dtResult.Rows[0]["Address"] != DBNull.Value) ? dtResult.Rows[0]["Address"].ToString() : "") + " </td></tr>");
        //            //emailbody.Append("<tr><td>Address 2: </td><td> " + ((dtResult.Rows[0]["Address1"] != null && dtResult.Rows[0]["Address1"] != DBNull.Value) ? dtResult.Rows[0]["Address1"].ToString() : "") + " </td></tr>");
        //            //emailbody.Append("<tr><td>Region: </td><td> " + ((dtResult.Rows[0]["Region"] != null && dtResult.Rows[0]["Region"] != DBNull.Value) ? dtResult.Rows[0]["Region"].ToString() : "") + " </td></tr>");
        //            //emailbody.Append("<tr><td>City: </td><td> " + ((dtResult.Rows[0]["City"] != null && dtResult.Rows[0]["City"] != DBNull.Value) ? dtResult.Rows[0]["City"].ToString() : "") + " </td></tr>");
        //            //emailbody.Append("<tr><td>State: </td><td> " + ((dtResult.Rows[0]["State"] != null && dtResult.Rows[0]["State"] != DBNull.Value) ? dtResult.Rows[0]["State"].ToString() : "") + " </td></tr>");
        //            //emailbody.Append("<tr><td>Zip: </td><td> " + ((dtResult.Rows[0]["Zip"] != null && dtResult.Rows[0]["Zip"] != DBNull.Value) ? dtResult.Rows[0]["Zip"].ToString() : "") + " </td></tr>");
        //        }

        //        emailbody.Append("<tr><td>Transaction Date: </td><td> " + Convert.ToDateTime(DateTime.Now).ToString("MM/dd/yyyy hh:mm:ss tt") + " </td></tr>");

        //        emailbody.Append("<tr><td colspan='2'></td></tr>");
        //        emailbody.Append("<tr><td colspan='2'></td></tr>");
        //        emailbody.Append("<tr><td colspan='2'></td></tr>");
        //        emailbody.Append("<tr><td colspan='2'>Best Regards</td></tr>");
        //        emailbody.Append("<tr><td colspan='2'></td></tr>");
        //        emailbody.Append("<tr><td colspan='2'><p>eTag365 Team</p> </td></tr>");
        //        emailbody.Append("</table>");
        //    }
        //    catch (Exception ex)
        //    {
        //    }
        //    return emailbody;
        //}
        public DataTable SqlToTbl(string strSqlRec)
        {
            using (SqlDataAdapter Adp = new SqlDataAdapter())
            {
                using (SqlCommand selectCMD = new SqlCommand(strSqlRec, new SqlConnection(conStr)))
                {
                    selectCMD.CommandTimeout = 3600;
                    Adp.SelectCommand = selectCMD;
                    using (DataTable Tbl = new DataTable())
                    {
                        Adp.Fill(Tbl);
                        return Tbl;
                    }
                }
            }
        }

        //public bool SendEmail(string sEmail)
        //{
        //    bool IsSentSuccessful = false;
        //    try
        //    {
        //        String strMailServer = string.Empty;
        //        String strMailUser = string.Empty;
        //        String strMailPassword = string.Empty;
        //        String strMailPort = System.Configuration.ConfigurationManager.AppSettings.Get("strMailPort");
        //        String isMailLive = System.Configuration.ConfigurationManager.AppSettings.Get("isMailLive");

        //        strMailUser = System.Configuration.ConfigurationManager.AppSettings.Get("strMailUser");
        //        strMailPassword = System.Configuration.ConfigurationManager.AppSettings.Get("strMailPassword");
        //        strMailServer = System.Configuration.ConfigurationManager.AppSettings.Get("strMailServer");

        //        if (isMailLive == "true")
        //        {
        //            objSmtpClient = new System.Net.Mail.SmtpClient(strMailServer, Convert.ToInt32(strMailPort));
        //            objSmtpClient.UseDefaultCredentials = false;
        //            objSmtpClient.Credentials = new System.Net.NetworkCredential(strMailUser, strMailPassword);
        //        }
        //        else
        //        {
        //            objSmtpClient = new System.Net.Mail.SmtpClient("smtp.gmail.com", 587);
        //            objSmtpClient.UseDefaultCredentials = false;
        //            objSmtpClient.EnableSsl = true;
        //            objSmtpClient.Credentials = new System.Net.NetworkCredential("info.visaformalaysia@gmail.com", "admin_321");
        //        }

        //        string from_address = "";
        //        string to_address = "";

        //        from_address = System.Configuration.ConfigurationManager.AppSettings.Get("fromAddress");

        //        try
        //        {
        //            to_address = sEmail;
        //        }
        //        catch (Exception e)
        //        {
        //            to_address = System.Configuration.ConfigurationManager.AppSettings.Get("toAddress");
        //        }


        //        objMailMessage = new System.Net.Mail.MailMessage();
        //        objMailMessage.From = new System.Net.Mail.MailAddress(from_address, "eTag365 Support");
        //        objMailMessage.To.Add(new System.Net.Mail.MailAddress(to_address));
        //        objMailMessage.Subject = "New user Registration request from eTag365";
        //        objMailMessage.IsBodyHtml = true;
        //        objMailMessage.Body = this.EmailHtml(sEmail).ToString();
        //        objSmtpClient.Send(objMailMessage);

        //        IsSentSuccessful = true;

        //    }
        //    catch (Exception ex)
        //    {

        //    }

        //    finally
        //    {
        //        if ((objSmtpClient == null) == false)
        //        {
        //            objSmtpClient = null;
        //        }

        //        if ((objMailMessage == null) == false)
        //        {
        //            objMailMessage.Dispose();
        //            objMailMessage = null;
        //        }
        //    }

        //    return IsSentSuccessful;
        //}

        //public System.Text.StringBuilder EmailHtml(string sEmail)
        //{
        //    System.Text.StringBuilder emailbody = new System.Text.StringBuilder();
        //    string sWeb = System.Configuration.ConfigurationManager.AppSettings.Get("WebUrl");
        //    string sUrl = sWeb + "/login";

        //    string sSQL = " Select isnull(Email,'') Email,isnull(Phone,'') Phone,isnull(FirstName,'') FirstName,isnull(LastName,'') LastName,isnull(Title,'') Title,isnull(CompanyName,'') CompanyName,isnull(WorkPhone,'') WorkPhone,isnull(Address,'') Address,isnull(Address1,'') Address1,isnull(State,'') State,isnull(City,'') City,isnull(Region,'') Region,isnull(Zip,'') Zip, isnull(Fax,'') Fax from UserProfile where Email = '" + sEmail + "' ";

        //    DataTable dtResult = SqlToTbl(sSQL);
        //    try
        //    {
        //        emailbody.Append("<table>");
        //        emailbody.Append("<tr><td colspan='2'></td></tr>");
        //        emailbody.Append("<tr><td colspan='2'><img  alt='eTag365' width='120' src='" + sWeb + "/Images/logo.png'></td></tr>");
        //        emailbody.Append("<tr><td colspan='2'></td></tr>");
        //        emailbody.Append("<tr><td colspan='2'></td></tr>");
        //        emailbody.Append("<tr><td colspan='2' style='text-align:Left;font-size:14px;font-weight:bold;color:0000cc;'>Dear User,</td></tr>");
        //        emailbody.Append("<tr><td colspan='2'></td></tr>");
        //        emailbody.Append("<tr><td colspan='2'></td></tr>");
        //        emailbody.Append("<tr><td colspan='2'><p>eTag365 has created your very secure contact information manager account. Please complete your profile. You may view your contacts for free. Press the following link. </p> </td></tr>");
        //        emailbody.Append("<tr><td colspan='2'></td></tr>");
        //        emailbody.Append("<tr><td colspan='2'><p><a style='color:blue;' href='" + sUrl + "' target='_blank'>https://www.etag365.net</a></p> </td></tr>");
        //        emailbody.Append("<tr><td colspan='2'></td></tr>");

        //        if (dtResult != null && dtResult.Rows.Count > 0)
        //        {
        //            emailbody.Append("<tr><td>First Name: </td><td> " + ((dtResult.Rows[0]["FirstName"] != null && dtResult.Rows[0]["FirstName"] != DBNull.Value) ? dtResult.Rows[0]["FirstName"].ToString() : "") + " </td></tr>");
        //            emailbody.Append("<tr><td>Last Name: </td><td> " + ((dtResult.Rows[0]["LastName"] != null && dtResult.Rows[0]["LastName"] != DBNull.Value) ? dtResult.Rows[0]["LastName"].ToString() : "") + " </td></tr>");
        //            emailbody.Append("<tr><td>Email: </td><td> " + ((dtResult.Rows[0]["Email"] != null && dtResult.Rows[0]["Email"] != DBNull.Value) ? dtResult.Rows[0]["Email"].ToString() : "") + " </td></tr>");
        //            emailbody.Append("<tr><td>Cell Number: </td><td> " + ((dtResult.Rows[0]["Phone"] != null && dtResult.Rows[0]["Phone"] != DBNull.Value) ? dtResult.Rows[0]["Phone"].ToString() : "") + " </td></tr>");
        //        }

        //        emailbody.Append("<tr><td>Transaction Date: </td><td> " + Convert.ToDateTime(DateTime.Now).ToString("MM/dd/yyyy hh:mm:ss tt") + " </td></tr>");

        //        emailbody.Append("<tr><td colspan='2'></td></tr>");
        //        emailbody.Append("<tr><td colspan='2'></td></tr>");
        //        emailbody.Append("<tr><td colspan='2'></td></tr>");
        //        emailbody.Append("<tr><td colspan='2'><p>Enter your mobile number for both the User name and Password. You will be prompted to change your password when you login. You can not change your User name.</p></td></tr>");
        //        emailbody.Append("<tr><td colspan='2'></td></tr>");
        //        emailbody.Append("<tr><td colspan='2'></td></tr>");
        //        emailbody.Append("<tr><td colspan='2'></td></tr>");
        //        emailbody.Append("<tr><td colspan='2'>Best Regards</td></tr>");
        //        emailbody.Append("<tr><td colspan='2'></td></tr>");
        //        emailbody.Append("<tr><td colspan='2'><p>eTag365 Team</p> </td></tr>");
        //        emailbody.Append("</table>");
        //    }
        //    catch (Exception ex)
        //    {
        //    }


        //    return emailbody;
        //}

    }
}