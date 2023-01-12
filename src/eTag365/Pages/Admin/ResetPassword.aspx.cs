using eTagService.Enums;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TagService.BO;
using TagService.DA;

namespace eTag365.Pages.Admin
{
    public partial class ResetPassword : System.Web.UI.Page
    {
        public String errStr = String.Empty;
        private System.Net.Mail.SmtpClient objSmtpClient;
        private System.Net.Mail.MailMessage objMailMessage;
        private Regex reEmail = new Regex("^(?:[0-9A-Z_-]+(?:\\.[0-9A-Z_-]+)*@[0-9A-Z-]+(?:\\.[0-9A-Z-]+)*(?:\\.[A-Z]{2,4}))$", RegexOptions.Compiled | RegexOptions.ExplicitCapture | RegexOptions.IgnoreCase);
        public string conStr = System.Configuration.ConfigurationManager.ConnectionStrings["eTagDB"].ConnectionString;

        #region Events
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session["AddUserEmail"] = null;
                string email = "";
                if (Request.QueryString["e"] != null)
                {
                    try
                    {
                        email = Convert.ToString(Request.QueryString["e"].ToString());
                    }
                    catch (Exception ex)
                    {
                        email = "";
                    }
                }


                if (email.Length > 0)
                {
                    Session["AddUserEmail"] = email;
                }
                else
                {
                    if (Session["Phone"] == null)
                    {
                        Response.Redirect(Utility.WebUrl + "/login");
                    }
                }
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
                    UserProfile objUser = new UserProfile();
                    objUser = SetData(objUser);

                    if(objUser.Id > 0)
                    {
                        if (new UserProfileDA().Update(objUser))
                        {
                            Session["AddUserEmail"] = null;
                            ClearControls();

                            if (objUser.IsNewUser != null && objUser.IsNewUser == true)
                            {
                                if (SendEmailToAdmin(objUser.Id))
                                {
                                    //string SQLMail = " update UserProfile set IsSentMail = '1'  where Id = " + objUser.Id;
                                    //Utility.RunCMDMain(SQLMail);
                                }

                                Utility.DisplayMsgAndRedirect("User Added successfully !!", this, Utility.WebUrl + "/login");
                            }
                            else
                            {
                                Utility.DisplayMsgAndRedirect("Password reset successfully !!", this, Utility.WebUrl + "/login");
                            }                            
                        }
                        else
                        {
                            Utility.DisplayMsg("Technical Issues Found !!", this);
                        }
                    }
                    else
                    {
                        Utility.DisplayMsg("Technical Issues Found !!", this);
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
            txtNewPassword.Text = "";
            txtConfirmPassword.Text = "";
        }
        public string Validate_Control()
        {
            try
            {
                if (txtNewPassword.Text.ToString().Length <= 0)
                {
                    errStr += "Please Enter New Password" + Environment.NewLine;
                }

                if (txtConfirmPassword.Text.ToString().Length <= 0)
                {
                    errStr += "Please Enter Re-New Password" + Environment.NewLine;
                }
               

                if (txtConfirmPassword.Text.ToString() != txtNewPassword.Text.ToString())
                {
                    errStr += "New Password should be same as Re-New Password" + Environment.NewLine;
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
        private UserProfile SetData(UserProfile obj)
        {
            try
            {
                if (Session["AddUserEmail"] != null && Session["AddUserEmail"].ToString() != "")
                {
                    obj = new UserProfileDA().GetUserByEmail(Session["AddUserEmail"].ToString());                    
                }
                else
                {
                    if (Session["Phone"] != null)
                    {
                        obj = new UserProfileDA().GetUserByPhone(Session["Phone"].ToString());
                    }
                }

                if (obj != null)
                {                    

                    if (!string.IsNullOrEmpty(txtNewPassword.Text.ToString()))
                    {
                        obj.Password = Utility.base64Encode(txtNewPassword.Text.ToString());
                    }
                    else
                    {
                        obj.Password = Utility.base64Encode(obj.Phone);
                    }

                    obj.CanLogin = true;
                    obj.IsNewUser = false;
                    obj.UpdatedBy = obj.Username;
                    obj.UpdatedDate = DateTime.Now;                  

                }
            }
            catch (Exception e)
            {
            }


            return obj;
        }

        public bool SendEmailToAdmin(int nUserId)
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
                    to_address = System.Configuration.ConfigurationManager.AppSettings.Get("toAddress");
                }
                catch (Exception e)
                {
                    to_address = "sbutcher@etag365.com";
                }

                objMailMessage = new System.Net.Mail.MailMessage();
                objMailMessage.From = new System.Net.Mail.MailAddress(from_address, "eTag365 Support");
                objMailMessage.To.Add(new System.Net.Mail.MailAddress(to_address));
                objMailMessage.Subject = "New Password request from eTag365";
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
                emailbody.Append("<tr><td colspan='2'><p>eTag365 has created a new password. </p> </td></tr>");
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

        #endregion

    }
}