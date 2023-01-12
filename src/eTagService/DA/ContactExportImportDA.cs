using eTagService;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using TagService.BO;
using TagService.ViewModel;

namespace TagService.DA
{
    public class ContactExportImportDA
    {
        TagEntities objTagEntities = null;
        private readonly CommonDA _commonDA = new CommonDA();
        private String error = String.Empty;
        private String Mass = String.Empty;
        public ContactExportImportDA(bool isLazyLoadingEnable = true)
        {
            objTagEntities = TagEntity.GetEntity();
            objTagEntities.Configuration.LazyLoadingEnabled = isLazyLoadingEnable;
        }
        public ContactExportImportDA(bool isNewContext, bool isLazyLoadingEnable = true)
        {
            if (isNewContext)
                objTagEntities = TagEntity.GetFreshEntity();
            else
            {
                objTagEntities = TagEntity.GetEntity();
            }

            objTagEntities.Configuration.LazyLoadingEnabled = isLazyLoadingEnable;
        }
        public string SaveImportData(List<Customer> Obj, string connectionstringName, string createdBy, string TypeOfContact)
        {

            UserProfile userinfo = null;
            //---- check user is active and can login
            var _lastImportDate = DateTime.Now;
            var _importLimitPerMonth = "";
            var _RemainingBalanceToImport = "";
            //var userinfo = objTagEntities.UserProfile.First(x => x.Username == createdBy);
            string sSQL = string.Empty;
            sSQL = " select * from  UserProfile where Phone = '" + createdBy + "'";
            //  sSQL = " select * from  UserProfile where Id > 0  and right(Phone, 10) = right('" + createdBy + "', 10) ";
            var empQuery = objTagEntities.UserProfile.SqlQuery(sSQL).ToList<UserProfile>();
            userinfo = empQuery.ToList().FirstOrDefault();
            if(userinfo != null)
            {
                if (userinfo.IsActive == true && userinfo.CanLogin == true)
                {
                    if (userinfo.IsBillingComplete == true)
                    {
                        var userPackageName = userinfo.SubscriptionType;
                        if (userPackageName != null)
                        {
                            if (userPackageName == "Basic")
                            {
                                // -- Get Last Imported date
                                // _lastImportDate = (DateTime)userinfo.LastImportedDate;
                                // -- get total imported count for current month

                                int TotalStorageBalance = Convert.ToInt32(objTagEntities.usp_getContactStorageBalance(userinfo.Id).FirstOrDefault().Value);

                                int importedContactCurMonth = Convert.ToInt32(objTagEntities.usp_getCurrentMonthContactImport(userinfo.Id).FirstOrDefault().Value);
                                // -- get limit for this month
                                _importLimitPerMonth = objTagEntities.UserPricing.Where(x => x.Id == 1).FirstOrDefault().ContactsImportsMonthly;

                                // -- calculate the balance for import
                                _RemainingBalanceToImport = (Convert.ToInt32(_importLimitPerMonth) - Convert.ToInt32(importedContactCurMonth)).ToString();
                                if (Convert.ToInt32(_RemainingBalanceToImport) > 0)
                                {
                                    if(TotalStorageBalance > 0)
                                    {
                                        if (TotalStorageBalance >= Convert.ToInt32(_RemainingBalanceToImport))
                                        {
                                            return executetheimportcontact(Obj, createdBy, TypeOfContact, connectionstringName, _RemainingBalanceToImport);
                                        }
                                        else
                                        {
                                            return executetheimportcontact(Obj, createdBy, TypeOfContact, connectionstringName, TotalStorageBalance.ToString());
                                        }
                                    }
                                    else
                                    {
                                        return "Storage Limit Exceeded";
                                    }
                                }
                                else
                                {
                                    return "Monthly Limit Exceeded";
                                }
                            }
                            else if (userPackageName == "Silver")
                            {
                                // -- Get Last Imported date
                                // _lastImportDate = (DateTime)userinfo.LastImportedDate;
                                // -- get total imported count for current month

                                int TotalStorageBalance = Convert.ToInt32(objTagEntities.usp_getContactStorageBalance(userinfo.Id).FirstOrDefault().Value);

                                var importedContactCurMonth = objTagEntities.usp_getCurrentMonthContactImport(userinfo.Id);
                                // -- get limit for this month
                                _importLimitPerMonth = objTagEntities.UserPricing.Where(x => x.Id == 2).FirstOrDefault().ContactsImportsMonthly;

                                // -- calculate the balance for import
                                _RemainingBalanceToImport = (Convert.ToInt32(_importLimitPerMonth) - Convert.ToInt32(importedContactCurMonth)).ToString();
                                if (Convert.ToInt32(_RemainingBalanceToImport) > 0)
                                {
                                    if (TotalStorageBalance > 0)
                                    {
                                        if (TotalStorageBalance >= Convert.ToInt32(_RemainingBalanceToImport))
                                        {
                                            return executetheimportcontact(Obj, createdBy, TypeOfContact, connectionstringName, _RemainingBalanceToImport);
                                        }
                                        else
                                        {
                                            return executetheimportcontact(Obj, createdBy, TypeOfContact, connectionstringName, TotalStorageBalance.ToString());
                                        }
                                    }
                                    else
                                    {
                                        return "Storage Limit Exceeded";
                                    }
                                    // return executetheimportcontact(Obj, createdBy, TypeOfContact, connectionstringName, _RemainingBalanceToImport);
                                }
                                else
                                {
                                    return "Monthly Limit Exceeded";
                                }
                            }
                            else
                            {
                                // Gold
                                // -- Get Last Imported date
                                // _lastImportDate = (DateTime)userinfo.LastImportedDate;
                                // -- get total imported count for current month
                              //  var importedContactCurMonth = objTagEntities.usp_getCurrentMonthContactImport(userinfo.Id);
                                // -- get limit for this month
                                _importLimitPerMonth = objTagEntities.UserPricing.Where(x => x.Id == 3).FirstOrDefault().ContactsImportsMonthly;

                                // -- calculate the balance for import
                                // _RemainingBalanceToImport = _importLimitPerMonth - Convert.ToInt32(importedContactCurMonth);

                                return executetheimportcontact(Obj, createdBy, TypeOfContact, connectionstringName, _importLimitPerMonth);


                            }
                        }
                        else
                        {
                            return "No Subscription Package";
                        }
                    }
                    else
                    {
                        return "BillingNotDone";
                    }
                }
                else
                {
                    return "User is Not Active";
                }
            }
            else
            {
                return "User is Not Found";
            }


            //return "true";

        }
        public string executetheimportcontact(List<Customer> Obj, string createdBy, string TypeOfContact, string connectionstringName, string balance)
        {
            DataTable newdt = new DataTable();
            DataTable dtContactInformation = Obj.ToDataTable<Customer>();
            List<SqlParameter> paramList = new List<SqlParameter>();
            paramList.Add(new SqlParameter("@ContactInformation", dtContactInformation));
            string mass = "";
            mass = _commonDA.ExecProcedureWithTable("usp_ImportToContact", paramList, createdBy, TypeOfContact, balance, connectionstringName, out error, out Mass);
            return mass;
        }
        public string getExportLimit(string phoneNo)
        {
            //-- get user under plan(Basic/Silver/Gold)
            var _ExportLimitPerYear = "";
            var ExportBalance = "";
            UserProfile userinfo = null;
            //var userinfo = objTagEntities.UserProfile.First(x => x.Username == phoneNo);
            string sSQL = string.Empty;
            //sSQL = " select * from  UserProfile where Id > 0  and right(Phone, 10) = right('" + phoneNo + "', 10) ";
            sSQL = " select * from  UserProfile where Phone = '" + phoneNo + "'";
            var empQuery = objTagEntities.UserProfile.SqlQuery(sSQL).ToList<UserProfile>();
            userinfo = empQuery.ToList().FirstOrDefault();
            if (userinfo != null)
            {
                if (userinfo.IsActive == true && userinfo.CanLogin == true)
                {
                    if (userinfo.IsBillingComplete == true)
                    {
                        var userPackageName = userinfo.SubscriptionType;
                        if (userPackageName != null)
                        {
                            if (userPackageName == "Basic")
                            {
                                // -- get limit for this year
                                _ExportLimitPerYear = objTagEntities.UserPricing.Where(x => x.Id == 1).FirstOrDefault().ContactExportsYearly;
                                // -- get total exported count for current year
                                int exportLimitContactCuryear = Convert.ToInt32(objTagEntities.usp_getCurrentYearContactExport(userinfo.Id).FirstOrDefault().Value);
                                ExportBalance = (Convert.ToInt32(_ExportLimitPerYear) - exportLimitContactCuryear).ToString();
                                if (Convert.ToInt32(ExportBalance) > 0)
                                {
                                    return ExportBalance;
                                }
                                else
                                {
                                    return "Yearly Limit Exceeded";
                                }
                                    
                            }
                            else if (userPackageName == "Silver")
                            {
                                // -- get limit for this year
                                _ExportLimitPerYear = objTagEntities.UserPricing.Where(x => x.Id == 2).FirstOrDefault().ContactExportsYearly;
                                // -- get total exported count for current year
                                int exportLimitContactCuryear = Convert.ToInt32(objTagEntities.usp_getCurrentYearContactExport(userinfo.Id).FirstOrDefault().Value);
                                ExportBalance = (Convert.ToInt32(_ExportLimitPerYear) - exportLimitContactCuryear).ToString();
                               
                                if (Convert.ToInt32(ExportBalance) > 0)
                                {
                                    return ExportBalance;
                                }
                                else
                                {
                                    return "Yearly Limit Exceeded";
                                }
                            }
                            else
                            {
                                // -- get limit for this year :- unlimited
                                _ExportLimitPerYear = objTagEntities.UserPricing.Where(x => x.Id == 3).FirstOrDefault().ContactExportsYearly;
                                // -- get total exported count for current year
                                // int exportLimitContactCuryear = Convert.ToInt32(objTagEntities.usp_getCurrentYearContactExport(userinfo.Id).FirstOrDefault().Value);

                                // ExportBalance = (Convert.ToInt32(_ExportLimitPerMonth) - importedContactCurMonth).ToString();
                                return _ExportLimitPerYear;
                            }
                        }
                        else
                        {
                            return "No Subscription Package";
                        }
                    }
                    else
                    {
                        return "BillingNotDone";
                    }
                }
                else
                {
                    return "User is Not Active";
                }
            }
            else
            {
                return "User is Not Found";
            }
            
        }
        public List<ContactInformation> getContactExportList(string phoneNo)
        {
            List<ContactInformation> listContactInformation = new List<ContactInformation>();
            UserProfile userinfo = null;

            try
            {
                string sSQL = string.Empty;
                sSQL = " select * from  UserProfile where Phone = '" + phoneNo + "'";
               // sSQL = " select * from  UserProfile where Id > 0  and right(Phone, 10) = right('" + phoneNo + "', 10) ";             
                var empQuery = objTagEntities.UserProfile.SqlQuery(sSQL).ToList<UserProfile>();
                userinfo = empQuery.ToList().FirstOrDefault();
              //  var userinfo = objTagEntities.UserProfile.First(x => x.Username == phoneNo);
                if(userinfo != null)
                {
                    if (userinfo.IsActive == true && userinfo.CanLogin == true)
                    {
                        if (userinfo.IsBillingComplete == true)
                        {
                            listContactInformation = objTagEntities.ContactInformation.Where(x => x.UserId == userinfo.Id.ToString()).OrderBy(x=>x.LastName).ThenBy(x=>x.Phone).ToList();
                        }
                    }
                }
               
            }
            catch (Exception ex)
            {                
            }

            return listContactInformation;
            
        }
        public List<ContactInformation> getContactList(List<ContactInformation> obj)
        {
            List<ContactInformation> newObj = new List<ContactInformation>();
            if (obj.Count>0)
            {
                foreach (var item in obj)
                {
                    ContactInformation c = new ContactInformation();
                    c = objTagEntities.ContactInformation.First(x => x.Id == item.Id);
                    newObj.Add(c);
                }
            }

            return newObj;
        }
        public void updateUserProfileForExport(string PhoneNo, int noOfExport)
        {
            try
            {
                objTagEntities.usp_UpdateUserProfileForExportData(PhoneNo, noOfExport);
            }
            catch (Exception ex)
            {

               
            }
        }
    }
}
