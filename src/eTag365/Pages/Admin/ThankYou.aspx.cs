using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TagService.BO;
using TagService.DA;

namespace eTag365.Pages.Admin
{
    public partial class ThankYou : System.Web.UI.Page
    {
        private static System.Net.Mail.SmtpClient objSmtpClient;
        private static System.Net.Mail.MailMessage objMailMessage;

        protected void Page_Load(object sender, EventArgs e)
        {
            int isAdmin = 0;
            bool bSave = false;

            try
            {
                isAdmin = Convert.ToInt32(Request.QueryString["a"].ToString());
            }
            catch (Exception ex)
            {
                isAdmin = 0;
            }

            if (isAdmin > 0)
            {
                PaymentHistory paymentHistory = null;

                if (HttpContext.Current.Session["paymentHistory"] != null)
                {
                    paymentHistory = (PaymentHistory)HttpContext.Current.Session["paymentHistory"];

                    if (paymentHistory.Id > 0)
                    {
                        var existingHistory = new PaymentHistoryDA().GetbyID(Convert.ToInt32(paymentHistory.Id));
                        if (existingHistory != null)
                        {
                            if (new PaymentHistoryDA().DeleteByID(Convert.ToInt32(existingHistory.Id)))
                            {

                            }
                        }
                    }
                }

                if (paymentHistory != null)
                {
                    bSave = new PaymentHistoryDA().Insert(paymentHistory);

                    if (bSave)
                    {
                        if (SendEmailToAdmin(paymentHistory))
                        {

                        }
                    }
                }


                if (bSave == true)
                {
                    HttpContext.Current.Session["paymentHistory"] = null;
                    Utility.DisplayMsg("Commission payment successful !", this);
                }
                else
                {
                    Utility.DisplayMsg("Commission payment successful !", this);
                }

                spanBack.InnerHtml = "<a href='" + Utility.WebUrl + "/home'>Back To Home</a>";
            }

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
                objMailMessage.Subject = "New Commission Payment request from eTag365";
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

            try
            {
                emailbody.Append("<table>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'><img  alt='eTag365' width='120' src='" + sWeb + "/Images/logo.png'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2' style='text-align:Left;font-size:14px;font-weight:bold;color:0000cc;'>Dear Sir</td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'><p>eTag365 has paid new commission payment. </p> </td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td>Account Name: </td><td> " + (obj.AccountName != null ? obj.AccountName.ToString() : "") + " </td></tr>");
                emailbody.Append("<tr><td>Address: </td><td> " + (obj.Address != null ? obj.Address.ToString() : "") + " </td></tr>");
                emailbody.Append("<tr><td>City: </td><td> " + (obj.City != null ? obj.City.ToString() : "") + " </td></tr>");
                emailbody.Append("<tr><td>State: </td><td> " + ((obj.State != null && obj.State != "-1") ? obj.State.ToString() : "") + " </td></tr>");
                emailbody.Append("<tr><td>Zip: </td><td> " + (obj.Zip != null ? obj.Zip.ToString() : "") + " </td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td>Last 4 Digit: </td><td> " + (obj.LastFourDigitCard != null ? obj.LastFourDigitCard.ToString() : "") + " </td></tr>");
                emailbody.Append("<tr><td>Amount: </td><td> $" + (obj.GrossAmount != null ? obj.GrossAmount.ToString() : "") + " </td></tr>");
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

    }
}