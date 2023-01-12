
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using eTagService;
using eTagService.Enums;
using TagService.BO;
using TagService.DA;

namespace eTag365.Pages.Admin
{
    public partial class AddContact : System.Web.UI.Page
    {
        public String errStr = String.Empty;
        private Regex reEmail = new Regex("^(?:[0-9A-Z_-]+(?:\\.[0-9A-Z_-]+)*@[0-9A-Z-]+(?:\\.[0-9A-Z-]+)*(?:\\.[A-Z]{2,4}))$", RegexOptions.Compiled | RegexOptions.ExplicitCapture | RegexOptions.IgnoreCase);
        public string sUrl = string.Empty;

        #region Events      
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session["ContactId"] = null;
                Session["UserId"] = null;
                string sessionid = System.Web.HttpContext.Current.Session.SessionID;
                if (!string.IsNullOrEmpty(sessionid))
                {
                    int userid = Utility.IntegerData("SELECT TOP 1 UserId FROM UserLog_Data Where SessionId='" + sessionid + "' Order By LogId DESC");

                    if (userid > 0)
                    {
                        Session["UserId"] = userid;
                        FillDropdowns();
                        
                        int CId = 0;
                        try
                        {
                            CId = Convert.ToInt32(Request.QueryString["CId"].ToString());
                        }
                        catch(Exception ex)
                        {
                            CId = 0;
                        }
                        if (CId > 0)
                        {
                            lblHeadline.InnerText = "Edit Contact";
                            Session["ContactId"] = CId;
                            FillControls(CId);
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
                    ContactInformation obj = new ContactInformation();
                    obj = SetData(obj);

                    if (Session["ContactId"] == null || Session["ContactId"] == "0")
                    {
                        if (new ContactInformationDA(true, false).Insert(obj))
                        {
                            Session["ContactId"] = null;
                            ClearControls();
                            Utility.DisplayMsgAndRedirect("Contact saved successfully!", this, Utility.WebUrl + "/home");
                        }
                        else
                        {
                            Utility.DisplayMsg("Contact not saved!", this);
                        }
                    }
                    else
                    {
                        if (new ContactInformationDA().Update(obj))
                        {
                            ClearControls();
                            Utility.DisplayMsgAndRedirect("Contact updated successfully!", this, Utility.WebUrl + "/home");
                        }
                        else
                        {
                            Utility.DisplayMsg("Contact not updated!", this);
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
        protected void btnBack_Click(object sender, EventArgs e)
        {
            ClearControls();
            Response.Redirect("/home");
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            if (Session["ContactId"] != null)
            {
                if (new ContactInformationDA().DeleteByID(Convert.ToInt32(Session["ContactId"])))
                {
                    ClearControls();
                    Utility.DisplayMsgAndRedirect("Contact deleted successfully!", this, Utility.WebUrl + "/home");
                }
            }
        }

        #endregion

        #region Method

        private void ClearControls()
        {

            txtContactName.Text = "";
            txtContactTitle.Text = "";
            //txtNumber.Text = "";
            txtEmail.Text = "";
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
            txtWebsite.Text = "";
            txtRefPhone.Text = "";
            ddlType.SelectedValue = "-1";
            ddlCategory.SelectedValue = "-1";
            txtOther.Text = "";
            txtMemo.Text = "";
            //txtCC.Text = "";
            txtLongitude.Text = "";
            txtLatitude.Text = "";
            btnSave.Text = "Update";
            lblHeadline.InnerText = "View / Change Contact Information";
            chkEmailFlow.Checked = false;
        }
        private void FillDropdowns()
        {
            List<Child> listContactType = null;
            List<Child> listCategory = null;

            int nUserId = Session["UserId"] != null ? Convert.ToInt32(Session["UserId"].ToString()) : 0;
            if(nUserId > 0)
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

            //try
            //{
            //    ddlCountry.Items.Clear();
            //    ddlCountry.AppendDataBoundItems = true;
            //    ddlCountry.Items.Add(new ListItem("Select Country", "-1"));
            //    ddlCountry.DataSource = new CountryDA().GetAllRefCountries();
            //    ddlCountry.DataTextField = "Nicename";
            //    ddlCountry.DataValueField = "iso";
            //    ddlCountry.DataBind();
            //    ddlCountry.SelectedValue = "US";
            //}
            //catch (Exception ex)
            //{

            //}

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
                        ddlCountryCode.Items.Add(new ListItem(name, obj.iso.ToString()));
                        // ddlCountryCode.Items.Add(new ListItem(name, obj.phonecode.ToString()));
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

        }
        private ContactInformation SetData(ContactInformation obj)
        {
            try
            {
                obj = new ContactInformation();

                if (Session["ContactId"] != null && Convert.ToInt32(Session["ContactId"]) > 0)
                {
                    obj = new ContactInformationDA().GetbyID(Convert.ToInt32(Session["ContactId"]));
                    obj.Id = Convert.ToInt32(Session["ContactId"].ToString());
                }

                if (Session["UserId"] != null)
                {
                    obj.UserId = obj.UserId == null ? Session["UserId"].ToString() : obj.UserId;
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
                string sCountryCode = "";

                //if (ddlCountryCode.SelectedValue != "-1")
                //{
                //    obj.CountryCode = ddlCountryCode.SelectedValue.Trim();
                //    sCountryCode = obj.CountryCode;
                //}
                //else
                //{
                //    obj.CountryCode = "1";
                //    sCountryCode = "1";
                //}

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

                if (ddlCountry.SelectedValue != "-1")
                {
                    obj.Country = ddlCountry.SelectedValue.ToString();
                }
                else
                {
                    obj.Country = "US";
                }

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

                if (!string.IsNullOrEmpty(txtMemo.Text.ToString()))
                {
                    obj.Memo = txtMemo.Text.ToString();
                }
                else
                {
                    obj.Memo = "";
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


                if (Session["ContactId"] != null)
                {
                    obj.UpdatedDate = DateTime.Now;
                    if (Session["UserId"] != null)
                    {
                        UserProfile objTemp = new UserProfileDA().GetUserByUserID(Convert.ToInt32(Session["UserId"].ToString()));
                        if (objTemp != null)
                        {
                            obj.UpdatedBy = objTemp.Phone;
                        }
                       // obj.UpdatedBy = Session["UserId"].ToString();
                    }
                }
                else
                {
                    if (Session["UserId"] != null)
                    {
                        UserProfile objTemp = new UserProfileDA().GetUserByUserID(Convert.ToInt32(Session["UserId"].ToString()));
                        if (objTemp != null)
                        {
                            obj.CreatedBy = objTemp.Phone;
                        }
                       // obj.CreatedBy = Session["UserId"].ToString();
                    }

                    obj.CreatedDate = DateTime.Now;                  
                    obj.IsDeleted = false;
                    obj.IsActive = true;
                }

                if (chkEmailFlow.Checked)
                {
                    obj.IsEmailFlow = 1;
                    
                }
                else
                {
                    obj.IsEmailFlow = 0;
                }
            }
            catch (Exception ex)
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
                    ContactInformation obj = new ContactInformationDA().GetbyID(nId);
                    if (obj != null)
                    {
                        Session["ContactId"] = obj.Id;
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
                            txtEmail.Enabled = false;
                        }
                        else
                        {
                            txtEmail.Text = "";
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
                        if (obj.Other != null && obj.Other.ToString() != string.Empty)
                        {
                            txtOther.Text = obj.Other;
                        }
                        else
                        {
                            txtOther.Text = "";
                        }

                        if (obj.Memo != null && obj.Memo.ToString() != string.Empty)
                        {
                            txtMemo.Text = obj.Memo;
                        }
                        else
                        {
                            txtMemo.Text = "";
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

                        btnSave.Text = "Update";

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
            catch(Exception ex)
            {

            }
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

                if (Session["UserId"] != null)
                {
                    string sCountryCode = "";
                    string sPhone = "";
                    int nId = 0;

                    if (Session["ContactId"] != null)
                    {
                        nId = Convert.ToInt32(Session["ContactId"].ToString());
                    }

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

                    if (!string.IsNullOrEmpty(txtNumber.Text.ToString()))
                    {
                        sPhone = Regex.Replace(txtNumber.Text.ToString().Trim(), @"[^0-9]", "");
                        sPhone = sCountryCode + sPhone;                       
                    }
                   
                    string sSQLContact = "Select Id from ContactInformation where UserId = " + Session["UserId"].ToString() + "  and Phone = '" + sPhone + "' and Id <> " + nId;

                    DataTable dtResultContact = SqlToTbl(sSQLContact);

                    if (dtResultContact != null && dtResultContact.Rows.Count > 0)
                    {
                        errStr += "Cell Number Already Exist for this user. Please enter another Cell Number. " + Environment.NewLine;
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

        public static DataTable SqlToTbl(string strSqlRec)
        {
            using (SqlDataAdapter Adp = new SqlDataAdapter())
            {
                using (SqlCommand selectCMD = new SqlCommand(strSqlRec, new SqlConnection(ConfigurationManager.ConnectionStrings["eTagDB"].ConnectionString)))
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

        #endregion
    }
}