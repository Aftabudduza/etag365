using eTag365.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using TagService.BO;
using TagService.DA;
using TagService.ViewModel;

namespace eTag365.Pages.Admin
{
    public partial class ContactExportImport : System.Web.UI.Page
    {       
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session["Phone"] = null;

                string sessionid = System.Web.HttpContext.Current.Session.SessionID;
                if (!string.IsNullOrEmpty(sessionid))
                {
                    int userid = Utility.IntegerData("SELECT TOP 1 UserId FROM UserLog_Data Where SessionId='" + sessionid + "' Order By LogId DESC");

                    if (userid > 0)
                    {
                        UserProfile objTemp = new UserProfileDA().GetUserByUserID(userid);
                        if (objTemp != null)
                        {
                            Session["Phone"] = objTemp.Phone;
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

        [WebMethod]

        public static string ImportContact(List<Customer> Obj)
        {
            var res = "";
            List<Customer> ObjNew = new List<Customer>();
            var myCon = ConfigurationSettings.AppSettings["ConnectionString"].ToString();
            var createdBy = HttpContext.Current.Session["Phone"].ToString();
            var createdDate = DateTime.Now;
            var TypeOfContact = "2";

            if (Obj != null && Obj.Count > 0)
            {             
                foreach  (Customer objcustomer  in Obj)
                {
                    objcustomer.CreatedBy = createdBy;
                    objcustomer.CreatedDate = createdDate;
                    if (objcustomer.Phone != null && objcustomer.Phone != string.Empty)
                    {
                        ObjNew.Add(objcustomer);
                    }
                }
            }

            if (ObjNew != null && ObjNew.Count > 0)
            {
                ObjNew.ForEach(x => x.CreatedBy = createdBy);
                ObjNew.ForEach(x => x.CreatedDate = createdDate);

                ContactExportImportDA _da = new ContactExportImportDA();
                res = _da.SaveImportData(ObjNew, myCon, createdBy, TypeOfContact);
            }

            var jsonSerialiser = new JavaScriptSerializer();
            var json = jsonSerialiser.Serialize(res);
            return json;
        }

        //public static string ImportContact(List<Customer> Obj)
        //{
        //    var res = "";
        //    List<Customer> ObjNew = null;

        //    if (Obj != null && Obj.Count >0)
        //    {
        //        var createdBy = HttpContext.Current.Session["Phone"].ToString();
        //        var createdDate = DateTime.Now;
        //        var TypeOfContact = "2";
        //        Obj.ForEach(x => x.CreatedBy = createdBy);
        //        Obj.ForEach(x => x.CreatedDate = createdDate);
        //       /// Obj.ForEach(x => x.UserTypeContact = TypeOfContact);
        //        var myCon = ConfigurationSettings.AppSettings["ConnectionString"].ToString();
        //        ContactExportImportDA _da = new ContactExportImportDA();
        //         res = _da.SaveImportData(Obj, myCon, createdBy, TypeOfContact);
        //    }
        //    var jsonSerialiser = new JavaScriptSerializer();
        //    var json = jsonSerialiser.Serialize(res);
        //    return json;
        //}
        [WebMethod]
        public static string ExportLimit()
        {
            var createdBy = HttpContext.Current.Session["Phone"].ToString();
            ContactExportImportDA _da = new ContactExportImportDA();
            var res = _da.getExportLimit(createdBy);
            var jsonSerialiser = new JavaScriptSerializer();
            var json = jsonSerialiser.Serialize(res);
            return json;
        }
        [WebMethod]
        public static string getExportList()
        {
            var createdBy = HttpContext.Current.Session["Phone"].ToString();
            ContactExportImportDA _da = new ContactExportImportDA();
            var res = _da.getContactExportList(createdBy);
            var jsonSerialiser = new JavaScriptSerializer();
            var json = jsonSerialiser.Serialize(res);
            return json;
        }
        [WebMethod]
        public static string SaveXMLFile(List<ContactInformation> Obj)
        {
            var result = true;
            var createdBy = HttpContext.Current.Session["Phone"].ToString();
            ContactExportImportDA _da = new ContactExportImportDA();
            List<ContactInformation> xmlResultObject = new List<ContactInformation>();

            try
            {
                xmlResultObject = _da.getContactList(Obj);


                XmlDocument doc = new XmlDocument();
                XmlNode docNode = doc.CreateXmlDeclaration("1.0", "UTF-8", null);
                doc.AppendChild(docNode);
                XmlNode ContactsNode = doc.CreateElement("Contacts");
                doc.AppendChild(ContactsNode);
                foreach (ContactInformation item in xmlResultObject)
                {
                    XmlNode contactNode = doc.CreateElement("contact");

                    XmlNode FirstName = doc.CreateElement("FirstName");
                    FirstName.AppendChild(doc.CreateTextNode(item.FirstName != null ? item.FirstName : ""));
                    contactNode.AppendChild(FirstName);

                    XmlNode MiddleName = doc.CreateElement("MiddleName");
                    MiddleName.AppendChild(doc.CreateTextNode(item.MiddleName != null ? item.MiddleName : ""));
                    contactNode.AppendChild(MiddleName);

                    XmlNode LastName = doc.CreateElement("LastName");
                    LastName.AppendChild(doc.CreateTextNode(item.LastName != null ? item.LastName : ""));
                    contactNode.AppendChild(LastName);

                    XmlNode Title = doc.CreateElement("Title");
                    Title.AppendChild(doc.CreateTextNode(item.Title != null ? item.Title : ""));
                    contactNode.AppendChild(Title);

                    XmlNode CompanyName = doc.CreateElement("CompanyName");
                    CompanyName.AppendChild(doc.CreateTextNode(item.CompanyName != null ? item.CompanyName : ""));
                    contactNode.AppendChild(CompanyName);

                    XmlNode Phone = doc.CreateElement("Phone");
                    Phone.AppendChild(doc.CreateTextNode(item.Phone != null ? item.Phone : ""));
                    contactNode.AppendChild(Phone);

                    XmlNode Email = doc.CreateElement("Email");
                    Email.AppendChild(doc.CreateTextNode(item.Email != null ? item.Email : ""));
                    contactNode.AppendChild(Email);

                    XmlNode Address = doc.CreateElement("Address");
                    Address.AppendChild(doc.CreateTextNode(item.Address != null ? item.Address : ""));
                    contactNode.AppendChild(Address);

                    XmlNode Address1 = doc.CreateElement("Address1");
                    Address1.AppendChild(doc.CreateTextNode(item.Address1 != null ? item.Address1 : ""));
                    contactNode.AppendChild(Address1);                    

                    XmlNode City = doc.CreateElement("City");
                    City.AppendChild(doc.CreateTextNode(item.City != null ? item.City : ""));
                    contactNode.AppendChild(City);

                    XmlNode State = doc.CreateElement("State");
                    State.AppendChild(doc.CreateTextNode(item.State != null ? item.State : ""));
                    contactNode.AppendChild(State);

                    XmlNode Zip = doc.CreateElement("Zip");
                    Zip.AppendChild(doc.CreateTextNode(item.Zip != null ? item.Zip : ""));
                    contactNode.AppendChild(Zip);

                    XmlNode Region = doc.CreateElement("Region");
                    Region.AppendChild(doc.CreateTextNode(item.Region != null ? item.Region : ""));
                    contactNode.AppendChild(Region);

                    XmlNode Country = doc.CreateElement("Country");
                    Country.AppendChild(doc.CreateTextNode(item.Country != null ? item.Country : ""));
                    contactNode.AppendChild(Country);

                    XmlNode WorkPhone = doc.CreateElement("WorkPhone");
                    WorkPhone.AppendChild(doc.CreateTextNode(item.WorkPhone != null ? item.WorkPhone : ""));
                    contactNode.AppendChild(WorkPhone);

                    XmlNode WorkPhoneExt = doc.CreateElement("WorkPhoneExt");
                    WorkPhoneExt.AppendChild(doc.CreateTextNode(item.WorkPhoneExt != null ? item.WorkPhoneExt : ""));
                    contactNode.AppendChild(WorkPhoneExt);

                    XmlNode Fax = doc.CreateElement("Fax");
                    Fax.AppendChild(doc.CreateTextNode(item.Fax != null ? item.Fax : ""));
                    contactNode.AppendChild(Fax);

                    XmlNode IsActive = doc.CreateElement("IsActive");
                    IsActive.AppendChild(doc.CreateTextNode(item.IsActive != null ? item.IsActive.ToString() : ""));
                    contactNode.AppendChild(IsActive);

                    XmlNode RefPhone = doc.CreateElement("RefPhone");
                    RefPhone.AppendChild(doc.CreateTextNode(item.RefPhone != null ? item.RefPhone : ""));
                    contactNode.AppendChild(RefPhone);
                    ContactsNode.AppendChild(contactNode);

                    XmlNode Category = doc.CreateElement("Category");
                    Category.AppendChild(doc.CreateTextNode(item.Category != null ? item.Category : ""));
                    contactNode.AppendChild(Category);
                    ContactsNode.AppendChild(contactNode);

                    XmlNode TypeOfContact = doc.CreateElement("TypeOfContact");
                    TypeOfContact.AppendChild(doc.CreateTextNode(item.TypeOfContact != null ? item.TypeOfContact : ""));
                    contactNode.AppendChild(TypeOfContact);
                    ContactsNode.AppendChild(contactNode);

                    XmlNode EmailDrip = doc.CreateElement("IsEmailFlow");
                    EmailDrip.AppendChild(doc.CreateTextNode(item.IsEmailFlow != null ? item.IsEmailFlow.ToString() : ""));
                    contactNode.AppendChild(EmailDrip);
                    ContactsNode.AppendChild(contactNode);

                    
                    XmlNode Website = doc.CreateElement("Website");
                    Website.AppendChild(doc.CreateTextNode(item.Website != null ? item.Website.ToString() : ""));
                    contactNode.AppendChild(Website);
                    ContactsNode.AppendChild(contactNode);
                }
                result = true;
                string path1 = @"~/xml/ContactInfo.xml";
                doc.Save(HttpContext.Current.Server.MapPath(path1));
                _da.updateUserProfileForExport(createdBy, xmlResultObject.Count);

            }
            catch (Exception)
            {

                result = false;
            }
            
           // doc.Save(Console.Out);
            var jsonSerialiser = new JavaScriptSerializer();
            var json = jsonSerialiser.Serialize(result);
            return json;
        }
        [WebMethod]
        public static string UpdateUserProfileForCSVExport(ExportCSVOrXML Obj)
        {
            var createdBy = HttpContext.Current.Session["Phone"].ToString();
            ContactExportImportDA _da = new ContactExportImportDA();
             _da.updateUserProfileForExport(createdBy,Obj.count);
            var jsonSerialiser = new JavaScriptSerializer();
            var json = jsonSerialiser.Serialize(true);
            return json;
        }
    }
}