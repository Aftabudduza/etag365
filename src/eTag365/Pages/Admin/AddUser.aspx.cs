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
using System.Data;

namespace eTag365.Pages.Admin
{
    public partial class AddUser : System.Web.UI.Page
    {
        public string conStr = System.Configuration.ConfigurationManager.ConnectionStrings["eTagDB"].ConnectionString;
        public string errStr = String.Empty;
        private Regex reEmail = new Regex("^(?:[0-9A-Z_-]+(?:\\.[0-9A-Z_-]+)*@[0-9A-Z-]+(?:\\.[0-9A-Z-]+)*(?:\\.[A-Z]{2,4}))$", RegexOptions.Compiled | RegexOptions.ExplicitCapture | RegexOptions.IgnoreCase);
        public string sUrl = string.Empty;
        private System.Net.Mail.SmtpClient objSmtpClient;
        private System.Net.Mail.MailMessage objMailMessage;

        #region Events

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session["UserId"] = null;
                Session["AddUserId"] = null;
                Session["LogoFileName"] = null;
                Session["CompanyFileName"] = null;

                string sessionid = System.Web.HttpContext.Current.Session.SessionID;
                if (!string.IsNullOrEmpty(sessionid))
                {
                    int userid = Utility.IntegerData("SELECT TOP 1 UserId FROM UserLog_Data Where SessionId='" + sessionid + "' Order By LogId DESC");
                  
                    bool bIsAdmin = false;

                    if (userid > 0)
                    {
                        Session["UserId"] = userid;
                        FillDropdowns();
                        
                        UserProfile objU = new UserProfileDA().GetUserByUserID(userid);
                        if (objU != null)
                        {
                            bIsAdmin = objU.IsAdmin != null ? Convert.ToBoolean(objU.IsAdmin) : false; 
                        }

                        int CId = 0;

                        if(Request.QueryString["UId"] != null)
                        {
                            try
                            {
                                CId = Convert.ToInt32(Request.QueryString["UId"].ToString());
                            }
                            catch (Exception ex)
                            {
                                CId = 0;
                            }
                        }
                       
                        if (CId > 0)
                        {
                            UserProfile objTemp = new UserProfileDA().GetUserByUserID(CId);
                            if (objTemp != null)
                            {
                                Session["AddUserId"] = objTemp.Id;
                                // nUserType = Convert.ToInt32(objTemp.UserTypeContact); 
                                FillControls(objTemp.Id);
                            }
                        }
                        else
                        {
                            lblSerial.Text = new UserProfileDA().MakeAutoGenerateSerial("U", "User"); 
                        }

                        int IsTopMenu = 0;
                        if(Request.QueryString["Top"] != null)
                        {
                            try
                            {
                                IsTopMenu = Convert.ToInt32(Request.QueryString["Top"].ToString());

                            }
                            catch (Exception ex)
                            {
                                IsTopMenu = 0;
                            }
                        }
                       

                        if (IsTopMenu == 0 && bIsAdmin == true)
                        {
                            chkAdmin.Visible = true;
                            chkDealer.Visible = true;
                        }
                        else if(IsTopMenu == 1)
                        {                           
                            chkAdmin.Visible = false;
                            chkDealer.Visible = false;
                            txtNumber.Enabled = false;
                        }
                        else
                        {
                            chkAdmin.Visible = false;
                            chkDealer.Visible = false;
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
            errStr = Validate_Control();
            if (errStr.Length <= 0)
            {
                try
                {
                    UserProfile objUser = new UserProfile();
                    objUser = SetData(objUser);                  

                    if (Session["AddUserId"] == null || Session["AddUserId"] == "0")
                    {
                        if (new UserProfileDA(true, false).Insert(objUser))
                        {
                            if (SendEmail(objUser.Email, objUser.Id))
                            {
                                if (SendEmailToAdmin(objUser.Id))
                                {
                                    string SQLMail = " update UserProfile set IsSentMail = '1'  where Id = " + objUser.Id;
                                    Utility.RunCMDMain(SQLMail);
                                }
                            }
                           
                            Session["LogoFileName"] = null;
                            Session["CompanyFileName"] = null;
                            ClearControls();                           
                           
                            lblMessage.Text = "User saved successfully!";
                            lblMessageNew.Text = "User saved successfully!";
                            Utility.DisplayMsg("User saved successfully!", this);                            
                        }
                        else
                        {
                            lblMessage.Text = "User not saved!!";
                            lblMessageNew.Text = "User not saved!!";
                            Utility.DisplayMsg("User not saved!", this);
                        }
                    }
                    else
                    {
                        if (new UserProfileDA().Update(objUser))
                        {
                            if(objUser.IsBillingComplete != true)
                            {
                                if (SendEmail(objUser.Email, objUser.Id))
                                {
                                    if (SendEmailToAdmin(objUser.Id))
                                    {
                                        string SQLMail = " update UserProfile set IsSentMail = '1'  where Id = " + objUser.Id;
                                        Utility.RunCMDMain(SQLMail);
                                    }
                                }
                            }
                            
                            Session["AddUserId"] = null;
                            Session["LogoFileName"] = null;
                            Session["CompanyFileName"] = null;
                            ClearControls();

                            if (objUser.IsNewUser != null && objUser.IsNewUser == true)
                            {
                                if (Session["UserId"] != null)
                                {
                                    if (Convert.ToInt32(Session["UserId"].ToString()) == objUser.Id)
                                    {
                                        string SQLMail = " update UserProfile set IsNewUser = '0'  where Id = " + objUser.Id;
                                        Utility.RunCMDMain(SQLMail);
                                        Utility.DisplayMsgAndRedirect("User updated successfully !!", this, Utility.WebUrl + "/billing");
                                    }
                                    //UserProfile objTemp = new UserProfileDA().GetUserByUserID(Convert.ToInt32(Session["UserId"].ToString()));
                                    //if (objTemp != null)
                                    //{
                                    //    if (objTemp.Phone == objUser.Phone)
                                    //    {
                                    //        string SQLMail = " update UserProfile set IsNewUser = '0'  where Id = " + objUser.Id;
                                    //        Utility.RunCMDMain(SQLMail);
                                    //        Utility.DisplayMsgAndRedirect("User updated successfully !!", this, Utility.WebUrl + "/billing");
                                    //    }                                        
                                    //}                                   
                                }
                            }

                            lblMessage.Text = "User updated successfully!";
                            lblMessageNew.Text = "User updated successfully!";
                            Utility.DisplayMsg("User updated successfully!", this);
                        }
                        else
                        {
                            Utility.DisplayMsg("User not updated!", this);
                            lblMessage.Text = "User not updated!!";
                            lblMessageNew.Text = "User not updated!!";
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
        protected void btnBack_Click(object sender, EventArgs e)
        {
            ClearControls();
            Response.Redirect(Utility.WebUrl + "/home");
        }
        protected void btnDeleteUser_Click(object sender, EventArgs e)
        {
            if (!String.IsNullOrEmpty(lblSerial.Text))
            {
                UserProfile obj = new UserProfileDA().GetUserBySerial(lblSerial.Text.ToString().Trim());
                if(obj != null)
                {
                    if (new UserProfileDA().DeleteByID(obj.Id))
                    {
                        ClearControls();
                        Utility.DisplayMsgAndRedirect("User Deleted successfully !!", this, Utility.WebUrl + "/home");
                    }
                }
                
            }          
          
        }
        protected void btnAgreement_Click(object sender, EventArgs e)
        {
            Response.Redirect("http://www.etag365.com/elements/termsandconditions/", false);
        }
        protected void CustomValidator1_ServerValidate(object source, ServerValidateEventArgs args)
        {
            args.IsValid = chkAgree.Checked;
        }
        //protected void ddlCountry_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    string sCountryCode = "";

        //    if (ddlCountry.SelectedValue != "-1")
        //    {
        //        Country objCountry = new CountryDA().GetByShortCode(ddlCountry.SelectedValue);
        //        sCountryCode = objCountry != null ? objCountry.phonecode.ToString() : "";
        //        if (!string.IsNullOrEmpty(sCountryCode))
        //        {                    
        //           txtCC.Text = sCountryCode;
        //        }
        //    }
        //    else
        //    {
        //     //   txtCC.Text = "";
        //    }


        //}
        #endregion

        #region Method
        private void ClearControls()
        {
            txtContactName.Text = "";
            txtContactTitle.Text = "";
            txtNumber.Text = "";
            txtEmail.Text = "";
            txtReEmail.Text = "";
            txtLastName.Text = "";
            txtCompany.Text = "";
            txtAddress.Text = "";
            txtAddress1.Text = "";
            txtRegion.Text = "";
            txtCity.Text = "";
            txtZip.Text = "";

            txtWorkNumber.Text = "";
            txtWorkNumberExt.Text = "";
            txtFaxNumber.Text = "";
            txtOther.Text = "";
            txtWebsite.Text = "";
            txtRefPhone.Text = "";
            ddlType.SelectedValue = "-1";
            ddlCategory.SelectedValue = "-1";
          
            chkAdmin.Checked = false;
            chkDealer.Checked = false;
            chkAgree.Checked = false;
            chkProfile.Checked = false;
            chkCompany.Checked = false;
            chkEmailFlow.Checked = false;
            lblSerial.Text = "";
            imgProfileLogo.ImageUrl = "";
            imgCompanyLogo.ImageUrl = "";

            lblMessage.Text = "";
            lblMessageNew.Text = "";
            ddlState.SelectedValue = "-1";

           // txtCC.Text = "";
            txtLongitude.Text = "";
            txtLatitude.Text = "";
        }
        public string Validate_Control()
        {
            try
            {
                if (txtContactName.Text.ToString().Length <= 0)
                {
                    errStr += "Please enter First Name" + Environment.NewLine;
                }
                if (txtLastName.Text.ToString().Length <= 0)
                {
                    errStr += "Please enter Last Name" + Environment.NewLine;
                }
                //if ((txtCompany.Text.ToString().Length) <= 0)
                //{
                //    errStr += "Please enter Company Name" + Environment.NewLine;
                //}

                if (txtEmail.Text.ToString().Length <= 0)
                {
                    errStr += "Please enter email address" + Environment.NewLine;
                }
                else
                {
                    if (!ValidEmail(txtEmail.Text.ToString().Trim()))
                    {
                        errStr += "Invalid email address" + Environment.NewLine;
                    }
                }

                //if (txtCC.Text.ToString().Trim().Length <= 0)
                //{
                //    errStr += "Please enter Country Code" + Environment.NewLine;
                //}
                
                if (ddlCountryCode.SelectedValue == "-1")
                {
                    errStr += "Please select Country Code" + Environment.NewLine;
                }
                if (txtNumber.Text.ToString().Length <= 0)
                {
                    errStr += "Please enter Cell Number" + Environment.NewLine;
                }
                else
                {
                    if (txtNumber.Text.ToString().Trim().Length < 10)
                    {
                        errStr += "Invalid Cell Number" + Environment.NewLine;
                    }
                }

                if (txtAddress.Text.ToString().Trim().Length <= 0)
                {
                    errStr += "Please enter Address" + Environment.NewLine;
                }
                if (ddlCountry.SelectedValue == "-1")
                {
                    errStr += "Please select Country" + Environment.NewLine;
                }
                if (txtCity.Text.ToString().Trim().Length <= 0)
                {
                    errStr += "Please enter City" + Environment.NewLine;
                }
                if (txtZip.Text.ToString().Trim().Length <= 0)
                {
                    errStr += "Please enter Zip Code" + Environment.NewLine;
                }

                List<UserProfile> objUsers2 = new UserProfileDA().GetUsersByUserEmail2(txtEmail.Text.ToString(), lblSerial.Text.ToString());

                if (objUsers2 != null && objUsers2.Count > 0)
                {
                    errStr += "Email already exist !! Please enter different Email." + Environment.NewLine;                   
                }

                string sCountryCode = "";

                //if (ddlCountryCode.SelectedValue.ToString().Trim() != "-1")
                //{
                //    sCountryCode = ddlCountryCode.SelectedValue.ToString().Trim();
                //}
                //else
                //{
                //    sCountryCode = "1";
                //}

                if (ddlCountryCode.SelectedValue != "-1")
                {
                    Country objCountry = new CountryDA().GetByShortCode(ddlCountryCode.SelectedValue);
                    sCountryCode = objCountry != null ? objCountry.phonecode.ToString() : "";
                }

                if (string.IsNullOrEmpty(sCountryCode))
                {
                    sCountryCode = "1";
                }

                string sPhone = Regex.Replace(txtNumber.Text.ToString().Trim(), @"[^0-9]", "");
                sPhone = sCountryCode + sPhone;

                UserProfile objUser = new UserProfileDA().GetExistingUserByPhoneAndSerial(sPhone, lblSerial.Text.ToString());

                if (objUser != null && objUser.Id > 0)
                {
                    errStr += "Cell Number already exist !! Please enter different Cell Number." + Environment.NewLine;
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
                obj = new UserProfile();

                if (Session["AddUserId"] != null && Convert.ToInt32(Session["AddUserId"]) > 0)
                {
                    obj = new UserProfileDA().GetUserByUserID(Convert.ToInt32(Session["AddUserId"]));
                    obj.Id = Convert.ToInt32(Session["AddUserId"].ToString());
                }

                string sCountryCode = "";

                if (ddlCountry.SelectedValue != "-1")
                {
                    obj.Country = ddlCountry.SelectedValue.ToString();
                }
                else
                {
                    obj.Country = "US";
                }

                if (ddlCountryCode.SelectedValue != "-1")
                {
                    Country objCountry = new CountryDA().GetByShortCode(ddlCountryCode.SelectedValue);
                    sCountryCode = objCountry != null ? objCountry.phonecode.ToString() : "";
                    obj.CountryCode = sCountryCode;
                  //  obj.CountryCode = ddlCountryCode.SelectedValue.Trim();
                    sCountryCode = obj.CountryCode;
                }

                if (string.IsNullOrEmpty(obj.CountryCode))
                {
                    sCountryCode = "1";
                    obj.CountryCode = "1";
                }

                if (!string.IsNullOrEmpty(txtNumber.Text.ToString()))
                {
                    string sPhone = Regex.Replace(txtNumber.Text.ToString().Trim(), @"[^0-9]", "");
                    sPhone = sCountryCode + sPhone;
                    obj.Phone = sPhone;
                }
                else
                {
                    obj.Phone = "";
                }

                if (!string.IsNullOrEmpty(txtContactName.Text.ToString()))
                {
                    obj.FirstName = txtContactName.Text.ToString();
                }
                else
                {
                    obj.FirstName = "";
                }

                if (!string.IsNullOrEmpty(txtLastName.Text.ToString()))
                {
                    obj.LastName = txtLastName.Text.ToString();
                }
                else
                {
                    obj.LastName = "";
                }

                if (!string.IsNullOrEmpty(txtContactTitle.Text.ToString()))
                {
                    obj.Title = txtContactTitle.Text.ToString();
                }
                else
                {
                    obj.Title = "";
                }

                if (!string.IsNullOrEmpty(txtCompany.Text.ToString()))
                {
                    obj.CompanyName = txtCompany.Text.ToString();
                }
                else
                {
                    obj.CompanyName = "";
                }

                //if (!string.IsNullOrEmpty(txtNumber.Text.ToString()))
                //{
                //    obj.Phone = txtNumber.Text.ToString();
                //}
                //else
                //{
                //    obj.Phone = "";
                //}

                if (!string.IsNullOrEmpty(txtEmail.Text.ToString()))
                {
                    obj.Email = txtEmail.Text.ToString().ToLower().Trim();
                }
                else
                {
                    obj.Email = "";
                }

                if (!string.IsNullOrEmpty(txtAddress.Text.ToString()))
                {
                    obj.Address = txtAddress.Text.ToString();
                }
                else
                {
                    obj.Address = "";
                }

                if (!string.IsNullOrEmpty(txtAddress1.Text.ToString()))
                {
                    obj.Address1 = txtAddress1.Text.ToString();
                }
                else
                {
                    obj.Address1 = "";
                }

                //if (ddlCountry.SelectedValue != "-1")
                //{
                //    obj.Country = ddlCountry.SelectedValue.ToString();
                //}
                //else
                //{
                //    obj.Country = "";
                //}

                if (!string.IsNullOrEmpty(txtRegion.Text.ToString()))
                {
                    obj.Region = txtRegion.Text.ToString();
                }
                else
                {
                    obj.Region = "";
                }

                if (ddlState.SelectedValue != "-1")
                {
                    obj.State = ddlState.SelectedValue.ToString();
                }
                else
                {
                    obj.State = "";
                }

                if (!string.IsNullOrEmpty(txtCity.Text.ToString()))
                {
                    obj.City = txtCity.Text.ToString();
                }
                else
                {
                    obj.City = "";
                }

                if (!string.IsNullOrEmpty(txtZip.Text.ToString()))
                {
                    obj.Zip = txtZip.Text.ToString();
                }
                else
                {
                    obj.Zip = "";
                }

                if (!string.IsNullOrEmpty(txtWorkNumber.Text.ToString()))
                {
                    obj.WorkPhone = txtWorkNumber.Text.ToString();
                }
                else
                {
                    obj.WorkPhone = "";
                }

                if (!string.IsNullOrEmpty(txtWorkNumberExt.Text.ToString()))
                {
                    obj.WorkPhoneExt = txtWorkNumberExt.Text.ToString();
                }
                else
                {
                    obj.WorkPhoneExt = "";
                }

                if (!string.IsNullOrEmpty(txtFaxNumber.Text.ToString()))
                {
                    obj.Fax = txtFaxNumber.Text.ToString();
                }
                else
                {
                    obj.Fax = "";
                }

                if (!string.IsNullOrEmpty(txtOther.Text.ToString()))
                {
                    obj.Other = txtOther.Text.ToString();
                }
                else
                {
                    obj.Other = "";
                }

               

                if (chkAdmin.Checked)
                {
                    obj.IsAdmin = true;
                   // obj.UserTypeContact = Convert.ToInt32(EnumUserType.Admin).ToString();
                }
                else
                {
                    obj.IsAdmin = false;
                }

               

                if (chkProfile.Checked)
                {
                    obj.DoNotEmbedProfile = true;
                }
                else
                {
                    obj.DoNotEmbedProfile = false;
                }

                if (chkCompany.Checked)
                {
                    obj.DoNotEmbedCompany = true;
                }
                else
                {
                    obj.DoNotEmbedCompany = false;
                }
                if (chkAgree.Checked)
                {
                    obj.IsAgree = true;
                }
                else
                {
                    obj.IsAgree = false;
                }

                if (obj.Serial == null || obj.Serial == "" || obj.Serial == "U00000000000")
                {
                    obj.Serial = new UserProfileDA().MakeAutoGenerateSerial("U", "User");
                }

                if (Session["AddUserId"] != null)
                {
                    obj.UpdatedDate = DateTime.Now;
                    //obj.IsNewUser = false;

                    if (Session["UserId"] != null)
                    {
                        UserProfile objTemp = new UserProfileDA().GetUserByUserID(Convert.ToInt32(Session["UserId"].ToString()));
                        if (objTemp != null)
                        {
                            obj.UpdatedBy = objTemp.Phone;
                        }
                    }
                }
                else
                { 
                    if(Session["UserId"] != null)
                    {
                        UserProfile objTemp = new UserProfileDA().GetUserByUserID(Convert.ToInt32(Session["UserId"].ToString()));
                        if (objTemp != null)
                        {
                            obj.CreatedBy = objTemp.Phone;
                        }
                    }

                    obj.CreatedDate = DateTime.Now;                  
                    obj.CanLogin = false;
                    obj.IsDeleted = false;
                    obj.IsActive = true;
                    obj.DatabaseName = "";
                    obj.DatabaseLocation = "";                  
                   
                    obj.IsBillingComplete = false;                  
                    obj.IsNewUser = true;
                    Random random = new Random();
                    long nRandom = random.Next(100000, 999999);

                    obj.PhoneVerifyCode = nRandom.ToString();
                    obj.IsPhoneVerified = false;
                    obj.UserTypeContact = ((Int16)EnumUserType.Normal).ToString();

                    obj.Username = obj.Phone;
                    obj.Password = Utility.base64Encode(obj.Phone);
                }

                if (string.IsNullOrEmpty(obj.Username))
                {
                    obj.Username = obj.Phone;
                }

                if (string.IsNullOrEmpty(obj.Password))
                {
                    obj.Password = Utility.base64Encode(obj.Phone);
                }

                if (chkDealer.Checked)
                {
                    obj.UserTypeContact = Convert.ToInt32(EnumUserType.Dealer).ToString();
                }

                if (Session["LogoFileName"] != null)
                {
                    obj.ProfileLogo = Session["LogoFileName"].ToString();
                }

                if (Session["CompanyFileName"] != null)
                {
                    obj.CompanyLogo = Session["CompanyFileName"].ToString();
                }

                if (!string.IsNullOrEmpty(txtWebsite.Text.ToString()))
                {
                    obj.Website = txtWebsite.Text.ToString();
                }
                else
                {
                    obj.Website = "";
                }

                if (!string.IsNullOrEmpty(txtRefPhone.Text.ToString()))
                {
                    obj.RefPhone = txtRefPhone.Text.ToString();
                }
                else
                {
                    obj.RefPhone = "";
                }

                if (ddlType.SelectedValue != "-1")
                {
                    obj.TypeOfContact = ddlType.SelectedValue.ToString();
                }
                else
                {
                    obj.TypeOfContact = "";
                }

                if (ddlCategory.SelectedValue != "-1")
                {
                    obj.Category = ddlCategory.SelectedValue.ToString();
                }
                else
                {
                    obj.Category = "";
                }

                if (!string.IsNullOrEmpty(txtLongitude.Text.ToString()))
                {
                    obj.Longitude = txtLongitude.Text.ToString().Trim();
                }
                else
                {
                    obj.Longitude = "";
                }

                if (!string.IsNullOrEmpty(txtLatitude.Text.ToString()))
                {
                    obj.Latitude = txtLatitude.Text.ToString().Trim();
                }
                else
                {
                    obj.Latitude = "";
                }

                if (chkEmailFlow.Checked)
                {
                    obj.IsEmailFlow = true;
                    obj.EmailFlowCreatedOn = DateTime.Now;
                }
                else
                {
                    obj.IsEmailFlow = false;
                }

            }
            catch (Exception e)
            {
            }


            return obj;
        }     
        private void FillControls(int nId)
        {
            try
            {
                if (nId > 0)
                {
                    UserProfile obj = new UserProfileDA().GetUserByUserID(nId);
                    if (obj != null)
                    {
                        Session["AddUserId"] = obj.Id;

                        if (obj.Serial != null && obj.Serial.ToString() != string.Empty)
                        {
                            lblSerial.Text = obj.Serial;
                        }
                        else
                        {
                            lblSerial.Text = "";
                        }

                        if (obj.FirstName != null && obj.FirstName.ToString() != string.Empty)
                        {
                            txtContactName.Text = obj.FirstName;
                        }
                        else
                        {
                            txtContactName.Text = "";
                        }
                        if (obj.LastName != null && obj.LastName.ToString() != string.Empty)
                        {
                            txtLastName.Text = obj.LastName;
                        }
                        else
                        {
                            txtLastName.Text = "";
                        }
                        if (obj.Title != null && obj.Title.ToString() != string.Empty)
                        {
                            txtContactTitle.Text = obj.Title;

                        }
                        else
                        {
                            txtContactTitle.Text = "";
                        }
                        if (obj.CompanyName != null && obj.CompanyName.ToString() != string.Empty)
                        {
                            txtCompany.Text = obj.CompanyName;
                        }
                        else
                        {
                            txtCompany.Text = "";
                        }

                        if (obj.Address != null && obj.Address.ToString() != string.Empty)
                        {
                            txtAddress.Text = obj.Address;
                        }
                        else
                        {
                            txtAddress.Text = "";
                        }
                        if (obj.Address1 != null && obj.Address1.ToString() != string.Empty)
                        {
                            txtAddress1.Text = obj.Address1;
                        }
                        else
                        {
                            txtAddress1.Text = "";
                        }

                        if (obj.Country != null && obj.Country.ToString() != string.Empty)
                        {
                            ddlCountry.SelectedValue = obj.Country.ToString();
                        }

                        if (obj.Region != null && obj.Region.ToString() != string.Empty)
                        {
                            txtRegion.Text = obj.Region;
                        }
                        else
                        {
                            txtRegion.Text = "";
                        }


                        if (obj.State != null && obj.State.ToString() != string.Empty)
                        {
                            ddlState.SelectedValue = obj.State.ToString();
                        }

                        if (obj.City != null && obj.City.ToString() != string.Empty)
                        {
                            txtCity.Text = obj.City;
                        }
                        else
                        {
                            txtCity.Text = "";
                        }
                        if (obj.Zip != null && obj.Zip.ToString() != string.Empty)
                        {
                            txtZip.Text = obj.Zip;
                        }
                        else
                        {
                            txtZip.Text = "";
                        }



                        if (obj.Phone != null && obj.Phone.ToString() != string.Empty)
                        {
                            string sPhone = obj.Phone.ToString();
                            if (sPhone.Length >= 10)
                            {
                                sPhone = sPhone.Substring(sPhone.Length - 10);
                            }

                            txtNumber.Text = sPhone;
                            txtNumber.Enabled = false;
                        }
                        else
                        {
                            txtNumber.Text = "";
                        }

                        if (obj.Email != null && obj.Email.ToString() != string.Empty)
                        {
                            txtEmail.Text = obj.Email;
                            txtReEmail.Text = obj.Email;

                            txtEmail.Enabled = false;
                            txtReEmail.Enabled = false;
                        }
                        else
                        {
                            txtEmail.Text = "";
                            txtReEmail.Text = "";
                        }


                        if (obj.WorkPhone != null && obj.WorkPhone.ToString() != string.Empty)
                        {
                            txtWorkNumber.Text = obj.WorkPhone;
                        }
                        else
                        {
                            txtWorkNumber.Text = "";
                        }
                        if (obj.WorkPhoneExt != null && obj.WorkPhoneExt.ToString() != string.Empty)
                        {
                            txtWorkNumberExt.Text = obj.WorkPhoneExt;
                        }
                        else
                        {
                            txtWorkNumberExt.Text = "";
                        }
                        if (obj.Fax != null && obj.Fax.ToString() != string.Empty)
                        {
                            txtFaxNumber.Text = obj.Fax;
                        }
                        else
                        {
                            txtFaxNumber.Text = "";
                        }
                        
                        if (obj.Other != null && obj.Other.ToString() != string.Empty)
                        {
                            txtOther.Text = obj.Other;
                        }
                        else
                        {
                            txtOther.Text = "";
                        }

                        if (obj.IsAdmin != null && obj.IsAdmin.ToString() != string.Empty)
                        {
                            chkAdmin.Checked = Convert.ToBoolean(obj.IsAdmin);
                        }
                        else
                        {
                            chkAdmin.Checked = false;
                        }

                        if (obj.UserTypeContact != null && obj.UserTypeContact.ToString() != string.Empty)
                        {
                            chkDealer.Checked = Convert.ToInt16(obj.UserTypeContact) == ((Int16)EnumUserType.Dealer) ? true : false;
                        }
                        else
                        {
                            chkDealer.Checked = false;
                        }
                        if (obj.IsAgree != null && obj.IsAgree.ToString() != string.Empty)
                        {
                            chkAgree.Checked = Convert.ToBoolean(obj.IsAgree);
                        }
                        else
                        {
                            chkAgree.Checked = false;
                        }
                        if (obj.DoNotEmbedProfile != null && obj.DoNotEmbedProfile.ToString() != string.Empty)
                        {
                            chkProfile.Checked = Convert.ToBoolean(obj.DoNotEmbedProfile);
                        }
                        else
                        {
                            chkProfile.Checked = false;
                        }
                        if (obj.DoNotEmbedCompany != null && obj.DoNotEmbedCompany.ToString() != string.Empty)
                        {
                            chkCompany.Checked = Convert.ToBoolean(obj.DoNotEmbedCompany);
                        }
                        else
                        {
                            chkCompany.Checked = false;
                        }


                        if (obj.ProfileLogo != null && obj.ProfileLogo != string.Empty)
                        {
                            imgProfileLogo.ImageUrl = Utility.WebUrl + "/Uploads/Files/User/" + obj.ProfileLogo;
                            Session["LogoFileName"] = obj.ProfileLogo;
                        }

                        if (obj.CompanyLogo != null && obj.CompanyLogo != string.Empty)
                        {
                            imgCompanyLogo.ImageUrl = Utility.WebUrl + "/Uploads/Files/User/" + obj.CompanyLogo;
                            Session["CompanyFileName"] = obj.CompanyLogo;
                        }

                        if (obj.Website != null && obj.Website.ToString() != string.Empty)
                        {
                            txtWebsite.Text = obj.Website;
                        }
                        else
                        {
                            txtWebsite.Text = "";
                        }

                        if (obj.TypeOfContact != null && obj.TypeOfContact.ToString() != string.Empty)
                        {
                            ddlType.SelectedValue = obj.TypeOfContact.ToString();
                        }
                        else
                        {
                            ddlType.SelectedValue = "-1";
                        }

                        if (obj.Category != null && obj.Category.ToString() != string.Empty)
                        {
                            ddlCategory.SelectedValue = obj.Category.ToString();
                        }
                        else
                        {
                            ddlCategory.SelectedValue = "-1";
                        }

                        if (obj.RefPhone != null && obj.RefPhone.ToString() != string.Empty)
                        {
                            txtRefPhone.Text = obj.RefPhone;
                        }
                        else
                        {
                            txtRefPhone.Text = "";
                        }

                        if (obj.Country != null && obj.Country.ToString() != string.Empty)
                        {
                            ddlCountryCode.SelectedValue = obj.Country;
                        }

                        if (obj.Longitude != null && obj.Longitude.ToString() != string.Empty)
                        {
                            txtLongitude.Text = obj.Longitude;
                        }
                        else
                        {
                            txtLongitude.Text = "";
                        }

                        if (obj.Latitude != null && obj.Latitude.ToString() != string.Empty)
                        {
                            txtLatitude.Text = obj.Latitude;
                        }
                        else
                        {
                            txtLatitude.Text = "";
                        }
                        if (obj.IsEmailFlow != null && obj.IsEmailFlow.ToString() != string.Empty)
                        {
                            chkEmailFlow.Checked = Convert.ToBoolean(obj.IsEmailFlow);
                        }
                        else
                        {
                            chkEmailFlow.Checked = false;
                        }
                        

                    }
                }
            }
            catch (Exception e)
            {

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
                        ddlCountry.Items.Add(new ListItem(obj.nicename.ToString(), obj.iso.ToString()));
                    }

                    ddlCountry.DataBind();
                    ddlCountry.SelectedValue = "US";
                }

            }
            catch (Exception ex)
            {

            }

            try
            {
                ddlCountryCode.Items.Clear();
                ddlCountryCode.AppendDataBoundItems = true;
                ddlCountryCode.Items.Add(new ListItem("Select Country Code", "-1"));
                if (listCountry != null && listCountry.Count > 0)
                {
                    foreach (Country obj in listCountry)
                    {
                        string name = obj.nicename + " (+" + obj.phonecode.ToString() + ")";
                       // ddlCountryCode.Items.Add(new ListItem(name, obj.phonecode.ToString()));
                        ddlCountryCode.Items.Add(new ListItem(name, obj.iso.ToString()));
                    }

                    ddlCountryCode.DataBind();
                    ddlCountryCode.SelectedValue = "US";
                }

            }
            catch (Exception ex)
            {

            }


            try
            {
                ddlState.Items.Clear();
                ddlState.AppendDataBoundItems = true;
                ddlState.Items.Add(new ListItem("Select State", "-1"));
                ddlState.DataSource = new StateDA().GetAllRefStates();
                ddlState.DataTextField = "STATENAME";
                ddlState.DataValueField = "STATE";
                ddlState.DataBind();

            }
            catch (Exception ex)
            {

            }

            List<Child> listContactType = null;
            List<Child> listCategory = null;

            int nUserId = Session["UserId"] != null ? Convert.ToInt32(Session["UserId"].ToString()) : 0;
            if (nUserId > 0)
            {
                listContactType = new ChildDA().GetChildByUserDefinedIDAndUserID(Convert.ToInt32(EnumBasicData.ContactType), nUserId);
                listCategory = new ChildDA().GetChildByUserDefinedIDAndUserID(Convert.ToInt32(EnumBasicData.Category), nUserId);
            }

            try
            {
                ddlType.Items.Clear();
                ddlType.AppendDataBoundItems = true;
                ddlType.Items.Add(new ListItem("N/A", "-1"));
                ddlType.SelectedValue = "-1";
                ddlType.DataSource = listContactType;
                ddlType.DataTextField = "Description";
                ddlType.DataValueField = "Description";
                ddlType.DataBind();

            }
            catch (Exception ex)
            {

            }

            try
            {
                ddlCategory.Items.Clear();
                ddlCategory.AppendDataBoundItems = true;
                ddlCategory.Items.Add(new ListItem("N/A", "-1"));
                ddlCategory.SelectedValue = "-1";
                ddlCategory.DataSource = listCategory;
                ddlCategory.DataTextField = "Description";
                ddlCategory.DataValueField = "Description";
                ddlCategory.DataBind();

            }
            catch (Exception ex)
            {

            }

        }
        [WebMethod(EnableSession = true)]
        public static string uploadprofilepicture(string Image, string ImageName)
        {
            string sImage = string.Empty;

            try
            {
                if (HttpContext.Current.Session["AddUserId"] == null || string.IsNullOrEmpty(HttpContext.Current.Session["AddUserId"].ToString()))
                    return "";
                var obj = new UserProfile();
                if (HttpContext.Current.Session["AddUserId"] != null && Convert.ToInt32(HttpContext.Current.Session["AddUserId"]) > 0)
                {
                    obj = new UserProfileDA().GetUserByUserID(Convert.ToInt32(HttpContext.Current.Session["AddUserId"].ToString()));
                    obj.Id = Convert.ToInt32(HttpContext.Current.Session["AddUserId"].ToString());
                }



                byte[] getImageData = Convert.FromBase64String(Image);
                string sfile = obj.Serial + "_P_" + ImageName;
                string direc = "~/Uploads/";
                string uploadPath = "~/Uploads/Files/User";
                var filepath = HttpContext.Current.Server.MapPath(uploadPath);
                if (!Directory.Exists(filepath))
                {
                    string spath = HttpContext.Current.Server.MapPath(direc);
                    DirectorySecurity ds = Directory.GetAccessControl(spath);
                    ds.AddAccessRule(new FileSystemAccessRule("Everyone", FileSystemRights.FullControl, AccessControlType.Allow));
                    Directory.SetAccessControl(spath, ds);
                    Directory.CreateDirectory(HttpContext.Current.Server.MapPath(uploadPath));
                }

                string sfullpath = Path.Combine(filepath, sfile);
                if (!File.Exists(sfullpath))
                {
                    File.WriteAllBytes(sfullpath, getImageData);
                }
                else
                {
                    if (File.Exists(sfullpath))
                    {
                        File.Delete(sfullpath);
                        File.WriteAllBytes(sfullpath, getImageData);
                    }
                }

                obj.ProfileLogo = sfile;


                try
                {
                    if (new UserProfileDA().Update(obj))
                    {
                        HttpContext.Current.Session["LogoFileName"] = sfile;
                        sImage = "../../Uploads/Files/User/" + sfile;
                    }
                }
                catch (Exception)
                {

                }

            }
            catch (Exception)
            {

            }            

            return sImage;

        }

        [WebMethod(EnableSession = true)]
        public static string uploadcompanypicture(string Image, string ImageName)
        {
            string sImage = string.Empty;

            try
            {
                if (HttpContext.Current.Session["AddUserId"] == null || string.IsNullOrEmpty(HttpContext.Current.Session["AddUserId"].ToString()))
                    return "";
                var obj = new UserProfile();
                if (HttpContext.Current.Session["AddUserId"] != null && Convert.ToInt32(HttpContext.Current.Session["AddUserId"]) > 0)
                {
                    obj = new UserProfileDA().GetUserByUserID(Convert.ToInt32(HttpContext.Current.Session["AddUserId"].ToString()));
                    obj.Id = Convert.ToInt32(HttpContext.Current.Session["AddUserId"].ToString());
                }



                byte[] getImageData = Convert.FromBase64String(Image);
                string sfile = obj.Serial + "_C_" + ImageName;
                string direc = "~/Uploads/";
                string uploadPath = "~/Uploads/Files/User";
                var filepath = HttpContext.Current.Server.MapPath(uploadPath);
                if (!Directory.Exists(filepath))
                {
                    string spath = HttpContext.Current.Server.MapPath(direc);
                    DirectorySecurity ds = Directory.GetAccessControl(spath);
                    ds.AddAccessRule(new FileSystemAccessRule("Everyone", FileSystemRights.FullControl, AccessControlType.Allow));
                    Directory.SetAccessControl(spath, ds);
                    Directory.CreateDirectory(HttpContext.Current.Server.MapPath(uploadPath));
                }

                string sfullpath = Path.Combine(filepath, sfile);
                if (!File.Exists(sfullpath))
                {
                    File.WriteAllBytes(sfullpath, getImageData);
                }
                else
                {
                    if (File.Exists(sfullpath))
                    {
                        File.Delete(sfullpath);
                        File.WriteAllBytes(sfullpath, getImageData);
                    }
                }

                obj.CompanyLogo = sfile;


                try
                {
                    if (new UserProfileDA().Update(obj))
                    {
                        HttpContext.Current.Session["CompanyFileName"] = sfile;
                        sImage = "../../Uploads/Files/User/" + sfile;
                    }
                }
                catch (Exception)
                {

                }

            }
            catch (Exception)
            {

            }

            return sImage;

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
        //         //   emailbody.Append("<tr><td>Title: </td><td> " + ((dtResult.Rows[0]["Title"] != null && dtResult.Rows[0]["Title"] != DBNull.Value) ? dtResult.Rows[0]["Title"].ToString() : "") + " </td></tr>");
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
        public System.Text.StringBuilder EmailHtmlToAdmin(int nUserId)
        {
            System.Text.StringBuilder emailbody = new System.Text.StringBuilder();
            string sWeb = System.Configuration.ConfigurationManager.AppSettings.Get("WebUrl");
            string sUrl = sWeb + "/login";
            string sSQL = " Select isnull(Password,'') Password,isnull(Email,'') Email,isnull(Phone,'') Phone,isnull(FirstName,'') FirstName,isnull(LastName,'') LastName,isnull(Title,'') Title,isnull(CompanyName,'') CompanyName,isnull(WorkPhone,'') WorkPhone,isnull(Address,'') Address,isnull(Address1,'') Address1,isnull(State,'') State,isnull(City,'') City,isnull(Region,'') Region,isnull(Zip,'') Zip, isnull(Fax,'') Fax, isnull(WorkPhoneExt,'') WorkPhoneExt from UserProfile where Id = " + nUserId.ToString();
          //  string sSQL = " Select isnull(Password,'') Password,isnull(Phone,'') Phone  from UserProfile where Id = " + nUserId.ToString();
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
                  //  sCell = (dtResult.Rows[0]["Phone"] != null && dtResult.Rows[0]["Phone"] != DBNull.Value) ? dtResult.Rows[0]["Phone"].ToString() : "";
                    sPassword = (dtResult.Rows[0]["Password"] != null && dtResult.Rows[0]["Password"] != DBNull.Value) ? dtResult.Rows[0]["Password"].ToString() : "";
                    sPassword = sPassword.Length > 0 ? Utility.base64Decode(sPassword) : "";

                    emailbody.Append("<tr><td>First Name: </td><td> " + ((dtResult.Rows[0]["FirstName"] != null && dtResult.Rows[0]["FirstName"] != DBNull.Value) ? dtResult.Rows[0]["FirstName"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>Last Name: </td><td> " + ((dtResult.Rows[0]["LastName"] != null && dtResult.Rows[0]["LastName"] != DBNull.Value) ? dtResult.Rows[0]["LastName"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>Title: </td><td> " + ((dtResult.Rows[0]["Title"] != null && dtResult.Rows[0]["Title"] != DBNull.Value) ? dtResult.Rows[0]["Title"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>Email: </td><td> " + ((dtResult.Rows[0]["Email"] != null && dtResult.Rows[0]["Email"] != DBNull.Value) ? dtResult.Rows[0]["Email"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>Cell Number: </td><td> +" + ((dtResult.Rows[0]["Phone"] != null && dtResult.Rows[0]["Phone"] != DBNull.Value) ? dtResult.Rows[0]["Phone"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>Work Phone: </td><td> " + ((dtResult.Rows[0]["WorkPhone"] != null && dtResult.Rows[0]["WorkPhone"] != DBNull.Value) ? dtResult.Rows[0]["WorkPhone"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>Work Phone Extension: </td><td> " + ((dtResult.Rows[0]["WorkPhoneExt"] != null && dtResult.Rows[0]["WorkPhoneExt"] != DBNull.Value) ? dtResult.Rows[0]["WorkPhoneExt"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>Fax: </td><td> " + ((dtResult.Rows[0]["Fax"] != null && dtResult.Rows[0]["Fax"] != DBNull.Value) ? dtResult.Rows[0]["Fax"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>Company Name: </td><td> " + ((dtResult.Rows[0]["CompanyName"] != null && dtResult.Rows[0]["CompanyName"] != DBNull.Value) ? dtResult.Rows[0]["CompanyName"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>Address: </td><td> " + ((dtResult.Rows[0]["Address"] != null && dtResult.Rows[0]["Address"] != DBNull.Value) ? dtResult.Rows[0]["Address"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>Address 2: </td><td> " + ((dtResult.Rows[0]["Address1"] != null && dtResult.Rows[0]["Address1"] != DBNull.Value) ? dtResult.Rows[0]["Address1"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>Region: </td><td> " + ((dtResult.Rows[0]["Region"] != null && dtResult.Rows[0]["Region"] != DBNull.Value) ? dtResult.Rows[0]["Region"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>City: </td><td> " + ((dtResult.Rows[0]["City"] != null && dtResult.Rows[0]["City"] != DBNull.Value) ? dtResult.Rows[0]["City"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>State: </td><td> " + ((dtResult.Rows[0]["State"] != null && dtResult.Rows[0]["State"] != DBNull.Value) ? dtResult.Rows[0]["State"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>Zip: </td><td> " + ((dtResult.Rows[0]["Zip"] != null && dtResult.Rows[0]["Zip"] != DBNull.Value) ? dtResult.Rows[0]["Zip"].ToString() : "") + " </td></tr>");

                }

                //  emailbody.Append("<tr><td>Cell Number: </td><td> +" + sCell + " </td></tr>");

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
        public bool SendEmail(string sEmail, int nUserId)
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
                    to_address = sEmail;
                }
                catch (Exception e)
                {
                    to_address = System.Configuration.ConfigurationManager.AppSettings.Get("toAddress");
                }


                objMailMessage = new System.Net.Mail.MailMessage();
                objMailMessage.From = new System.Net.Mail.MailAddress(from_address, "eTag365 Support");
                objMailMessage.To.Add(new System.Net.Mail.MailAddress(to_address));
                objMailMessage.Subject = "New user Registration request from eTag365";
                objMailMessage.IsBodyHtml = true;
                objMailMessage.Body = this.EmailHtml(nUserId).ToString();
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
        public System.Text.StringBuilder EmailHtml(int nUserId)
        {
            System.Text.StringBuilder emailbody = new System.Text.StringBuilder();
            string sWeb = System.Configuration.ConfigurationManager.AppSettings.Get("WebUrl");
            string sUrl = sWeb + "/login";
            string sSQL = " Select isnull(Email,'') Email,isnull(Phone,'') Phone,isnull(FirstName,'') FirstName,isnull(LastName,'') LastName,isnull(Password,'') Password,isnull(Title,'') Title,isnull(CompanyName,'') CompanyName,isnull(WorkPhone,'') WorkPhone,isnull(Address,'') Address,isnull(Address1,'') Address1,isnull(State,'') State,isnull(City,'') City,isnull(Region,'') Region,isnull(Zip,'') Zip, isnull(Fax,'') Fax, isnull(WorkPhoneExt,'') WorkPhoneExt  from UserProfile where Id = " + nUserId.ToString();
            string sPassword = "";
            DataTable dtResult = SqlToTbl(sSQL);
            try
            {
                emailbody.Append("<table>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'><img  alt='eTag365' width='120' src='" + sWeb + "/Images/logo.png'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2' style='text-align:Left;font-size:14px;font-weight:bold;color:0000cc;'>Dear User</td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'><p>eTag365 has created your very secure contact information manager account. Please complete your profile. You may view your contacts for free. Press the following link. </p> </td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'><p><a style='color:blue;' href='" + sUrl + "' target='_blank'>https://www.etag365.net</a></p> </td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");

                if (dtResult != null && dtResult.Rows.Count > 0)
                {
                    //emailbody.Append("<tr><td>First Name: </td><td> " + ((dtResult.Rows[0]["FirstName"] != null && dtResult.Rows[0]["FirstName"] != DBNull.Value) ? dtResult.Rows[0]["FirstName"].ToString() : "") + " </td></tr>");
                    //emailbody.Append("<tr><td>Last Name: </td><td> " + ((dtResult.Rows[0]["LastName"] != null && dtResult.Rows[0]["LastName"] != DBNull.Value) ? dtResult.Rows[0]["LastName"].ToString() : "") + " </td></tr>");
                    //emailbody.Append("<tr><td>Email: </td><td> " + ((dtResult.Rows[0]["Email"] != null && dtResult.Rows[0]["Email"] != DBNull.Value) ? dtResult.Rows[0]["Email"].ToString() : "") + " </td></tr>");
                    //emailbody.Append("<tr><td>Cell Number: </td><td> " + ((dtResult.Rows[0]["Phone"] != null && dtResult.Rows[0]["Phone"] != DBNull.Value) ? dtResult.Rows[0]["Phone"].ToString() : "") + " </td></tr>");

                    sPassword = (dtResult.Rows[0]["Password"] != null && dtResult.Rows[0]["Password"] != DBNull.Value) ? dtResult.Rows[0]["Password"].ToString() : "";
                    sPassword = sPassword.Length > 0 ? Utility.base64Decode(sPassword) : "";

                    emailbody.Append("<tr><td>First Name: </td><td> " + ((dtResult.Rows[0]["FirstName"] != null && dtResult.Rows[0]["FirstName"] != DBNull.Value) ? dtResult.Rows[0]["FirstName"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>Last Name: </td><td> " + ((dtResult.Rows[0]["LastName"] != null && dtResult.Rows[0]["LastName"] != DBNull.Value) ? dtResult.Rows[0]["LastName"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>Title: </td><td> " + ((dtResult.Rows[0]["Title"] != null && dtResult.Rows[0]["Title"] != DBNull.Value) ? dtResult.Rows[0]["Title"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>Email: </td><td> " + ((dtResult.Rows[0]["Email"] != null && dtResult.Rows[0]["Email"] != DBNull.Value) ? dtResult.Rows[0]["Email"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>Cell Number: </td><td> +" + ((dtResult.Rows[0]["Phone"] != null && dtResult.Rows[0]["Phone"] != DBNull.Value) ? dtResult.Rows[0]["Phone"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>Work Phone: </td><td> " + ((dtResult.Rows[0]["WorkPhone"] != null && dtResult.Rows[0]["WorkPhone"] != DBNull.Value) ? dtResult.Rows[0]["WorkPhone"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>Work Phone Extension: </td><td> " + ((dtResult.Rows[0]["WorkPhoneExt"] != null && dtResult.Rows[0]["WorkPhoneExt"] != DBNull.Value) ? dtResult.Rows[0]["WorkPhoneExt"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>Fax: </td><td> " + ((dtResult.Rows[0]["Fax"] != null && dtResult.Rows[0]["Fax"] != DBNull.Value) ? dtResult.Rows[0]["Fax"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>Company Name: </td><td> " + ((dtResult.Rows[0]["CompanyName"] != null && dtResult.Rows[0]["CompanyName"] != DBNull.Value) ? dtResult.Rows[0]["CompanyName"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>Address: </td><td> " + ((dtResult.Rows[0]["Address"] != null && dtResult.Rows[0]["Address"] != DBNull.Value) ? dtResult.Rows[0]["Address"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>Address 2: </td><td> " + ((dtResult.Rows[0]["Address1"] != null && dtResult.Rows[0]["Address1"] != DBNull.Value) ? dtResult.Rows[0]["Address1"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>Region: </td><td> " + ((dtResult.Rows[0]["Region"] != null && dtResult.Rows[0]["Region"] != DBNull.Value) ? dtResult.Rows[0]["Region"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>City: </td><td> " + ((dtResult.Rows[0]["City"] != null && dtResult.Rows[0]["City"] != DBNull.Value) ? dtResult.Rows[0]["City"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>State: </td><td> " + ((dtResult.Rows[0]["State"] != null && dtResult.Rows[0]["State"] != DBNull.Value) ? dtResult.Rows[0]["State"].ToString() : "") + " </td></tr>");
                    emailbody.Append("<tr><td>Zip: </td><td> " + ((dtResult.Rows[0]["Zip"] != null && dtResult.Rows[0]["Zip"] != DBNull.Value) ? dtResult.Rows[0]["Zip"].ToString() : "") + " </td></tr>");

                }

                emailbody.Append("<tr><td>Password: </td><td> " + sPassword + " </td></tr>");

                emailbody.Append("<tr><td>Transaction Date: </td><td> " + Convert.ToDateTime(DateTime.Now).ToString("MM/dd/yyyy hh:mm:ss tt") + " </td></tr>");

                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'></td></tr>");
                emailbody.Append("<tr><td colspan='2'><p>Enter your mobile number for both the User name and Password. You will be prompted to change your password when you login. You can not change your User name.</p></td></tr>");
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