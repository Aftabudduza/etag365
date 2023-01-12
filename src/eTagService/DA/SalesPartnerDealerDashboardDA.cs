using eTagService;
using eTagService.Enums;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Core.Objects;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using TagService.BO;

namespace TagService.DA
{
    public class SalesPartnerDealerDashboardDA
    {

        TagEntities objTagEntities = null;
        public SalesPartnerDealerDashboardDA(bool isLazyLoadingEnable = true)
        {
            objTagEntities = TagEntity.GetEntity();
            objTagEntities.Configuration.LazyLoadingEnabled = isLazyLoadingEnable;
        }

        public SalesPartnerDealerDashboardDA(bool isNewContext, bool isLazyLoadingEnable = true)
        {
            if (isNewContext)
                objTagEntities = TagEntity.GetFreshEntity();
            else
            {
                objTagEntities = TagEntity.GetEntity();
            }

            objTagEntities.Configuration.LazyLoadingEnabled = isLazyLoadingEnable;
        }

        public List<usp_GetDelarInfoByPhoneNo_Result> GetListOfDealerInfo(string PhoneNo)
        {
            List<usp_GetDelarInfoByPhoneNo_Result> objDealerInfo = new List<usp_GetDelarInfoByPhoneNo_Result>();
            try
            {
                objDealerInfo = objTagEntities.usp_GetDelarInfoByPhoneNo(PhoneNo).ToList();
            }
            catch (Exception ex)
            {

                
            }        
            

            return objDealerInfo;
        }

        public Dealer_SalesPartner getDealerInfo(int dealerId)
        {
            Dealer_SalesPartner d = new Dealer_SalesPartner();
            try
            {
                d = objTagEntities.Dealer_SalesPartner.Where(x => x.id == dealerId).FirstOrDefault();
            }
            catch (Exception ex)
            {

                
            }
           

            return d;
        }

        public Dealer_SalesPartner GetDealerByPhone(string phone)
        {
            Dealer_SalesPartner objDealer = null;
            try
            {
                string sSQL = string.Empty;
                sSQL = " select * from  Dealer_SalesPartner where primaryPhoneNo = '" + phone + "'";

                var empQuery = objTagEntities.Dealer_SalesPartner.SqlQuery(sSQL).ToList<Dealer_SalesPartner>();
                objDealer = empQuery.ToList().FirstOrDefault();

            }
            catch (Exception ex)
            {

            }

            return objDealer;
        }
        public bool SaveZipCodeCoverage(Dealer_SalesPartner_DetailsZipCodeCoverage obj)
        {
            try
            {
                objTagEntities.Dealer_SalesPartner_DetailsZipCodeCoverage.Add(obj);
                objTagEntities.SaveChanges();
                return true;
            }
            catch (Exception ex)
            {

                
            }
            return false;
        }
        public string GetUserProfilePassword(string MobileNo)
        {
            string dealerPassword = "";
            try
            {
                string sSQL = string.Empty;
                sSQL = " select * from  UserProfile where Id > 0  ";

                try
                {
                    if (!string.IsNullOrEmpty(MobileNo))
                    {
                        sSQL += " and Phone = '" + MobileNo + "'";

                    }
                }
                catch (Exception ex)
                {

                }

                var empQuery = objTagEntities.UserProfile.SqlQuery(sSQL).ToList<UserProfile>();
                dealerPassword = empQuery.ToList().FirstOrDefault().Password;

              //  dealerPassword = objTagEntities.UserProfile.Where(x => x.Username == MobileNo).FirstOrDefault().Password;
            }
            catch (Exception ex)
            {

               
            }
            dealerPassword = Utility.base64Decode(dealerPassword);
            return dealerPassword;
        }
        public List<Dealer_SalesPartner_DetailsZipCodeCoverage> getZipCodeDetails(string serialCode)
        {
            List<Dealer_SalesPartner_DetailsZipCodeCoverage> dealerdeails = new List<Dealer_SalesPartner_DetailsZipCodeCoverage>();
            try
            {
                dealerdeails = objTagEntities.Dealer_SalesPartner_DetailsZipCodeCoverage.Where(x => x.dealerSalesPartnerId == serialCode).ToList();
            }
            catch (Exception ex)
            {

                
            }
           

            return dealerdeails;
        }
        public bool DeleteZipCode(int id)
        {
            Dealer_SalesPartner_DetailsZipCodeCoverage existing = new Dealer_SalesPartner_DetailsZipCodeCoverage();
            try
            {
                existing = objTagEntities.Dealer_SalesPartner_DetailsZipCodeCoverage.Find(id);
                objTagEntities.Dealer_SalesPartner_DetailsZipCodeCoverage.Remove(existing);
                objTagEntities.SaveChanges();
                return true;
            }
            catch (Exception ex)
            {

                return false;
            }
           
        }
        public string MakeAutoGenerateSerial(string yourPrefix, string objName)
        {
            string serial = "";
            try
            {
                objTagEntities = TagEntity.GetFreshEntity();
                string prefix = "";
                prefix = DateTime.Now.Year.ToString();
               ObjectParameter oupParam = new ObjectParameter("NewID", 0);
                oupParam.Value = DBNull.Value;
                objTagEntities.SP_GetID(objName, "Id", DateTime.Now.Year, null, null, oupParam);
                string sNumber = oupParam.Value.ToString().PadLeft(5, '0');
                serial = string.Concat(yourPrefix, sNumber);

                return serial;
            }
            catch (Exception ex)
            {

            }

            return null;

        }

        public bool Save(Dealer_SalesPartner Obj,string password,string createdBy)
        {
            Dealer_SalesPartner objDealerInfo = new Dealer_SalesPartner();
            var serial = Obj.serialCode;
            bool isSave = false;
            try
            {
                var existing = objTagEntities.Dealer_SalesPartner.Find(Obj.id);
                if (existing !=null)
                {
                    isSave= updateDealerAndUserProfile(Obj, password, createdBy);
                }
                else
                {
                    isSave= SaveDealerAndUserProfile(Obj, password, createdBy);
                }


                return isSave;


            }
            catch (Exception ex)
            {

                
            }
             

            return isSave;
        }
        public bool SaveDealerAndUserProfile(Dealer_SalesPartner Obj, string password, string createdBy)
        {
            Dealer_SalesPartner objDealerInfo = new Dealer_SalesPartner();
            UserProfile objUser = new UserProfile();
            try
            {
                string sPhone = Regex.Replace(Obj.primaryPhoneNo.ToString().Trim(), @"[^0-9]", "");              

                var serial = Obj.serialCode;
                Obj.primaryPhoneNo = sPhone;
                Obj.mobilePhoneNo = Obj.primaryPhoneNo;

                objTagEntities.Dealer_SalesPartner.Add(Obj);
                objTagEntities.SaveChanges();

                //if (sPhone.Length > 10)
                //{
                //    sPhone = sPhone.Substring(sPhone.Length - 10);
                //}

                objUser = new UserProfileDA().GetUserByPhone(sPhone);
              //  objUser = new UserProfileDA().GetUserBySerial(Obj.serialCode);

                if(objUser != null)
                {
                    objUser.Email = Obj.email;
                    objUser.Password = password;
                    objUser.UserTypeContact = ((Int16)EnumUserType.Dealer).ToString();
                    objUser.Phone = sPhone;
                    objUser.Username = sPhone;
                    objUser.Serial = Obj.serialCode;
                    objUser.CanLogin = true;

                    if (new UserProfileDA().Update(objUser))
                    {

                    }
                }
                else
                {
                    sPhone = Regex.Replace(Obj.primaryPhoneNo.ToString().Trim(), @"[^0-9]", "");

                    objUser = new UserProfile();

                    
                    objUser.Serial = Obj.serialCode;
                    objUser.Password = password;
                    objUser.Email = Obj.email;
                    objUser.Phone = sPhone;
                    objUser.FirstName = Obj.firstName;
                    objUser.LastName = Obj.lastName;
                    objUser.WorkPhone = objUser.Phone; //Regex.Replace(Obj.mobilePhoneNo.ToString().Trim(), @"[^0-9]", ""); 
                    objUser.IsNewUser = false;
                    objUser.IsAgree = true;
                    objUser.Address = Obj.address1;
                    objUser.Address1 = Obj.address2;
                    objUser.Country = "US";
                    objUser.State = Obj.stateId;
                    objUser.City = Obj.city;
                    objUser.Zip = Obj.zipCode;
                    objUser.IsAdmin = false;
                    objUser.IsDeleted = false;
                    objUser.IsActive = true;
                    objUser.CanLogin = false;
                    objUser.IsUserProfileComplete = false;
                    objUser.IsBillingComplete = false;
                    objUser.CreatedBy = createdBy;
                    objUser.CreatedDate = Obj.createDate;
                    objUser.IsNewUser = true;
                    objUser.IsPhoneVerified = false;
                    objUser.UserTypeContact = ((Int16)EnumUserType.Dealer).ToString();
                    objUser.Username = objUser.Phone;

                    objTagEntities.UserProfile.Add(objUser);
                    objTagEntities.SaveChanges();
                }
                
                objTagEntities = TagEntity.GetFreshEntity();
                objDealerInfo = objTagEntities.Dealer_SalesPartner.Where(x => x.serialCode == serial).FirstOrDefault();
                return true;
            }
            catch (Exception ex)
            {

               
            }
            return false;
        }
        public bool updateDealerAndUserProfile(Dealer_SalesPartner Obj, string password, string createdBy)
        {
            Dealer_SalesPartner objDealerSalesPartner = new Dealer_SalesPartner();
            UserProfile objUser = new UserProfile();
            try
            {
                string sPhone = Regex.Replace(Obj.primaryPhoneNo.ToString().Trim(), @"[^0-9]", "");
                Obj.primaryPhoneNo = sPhone;

                Obj.mobilePhoneNo = Obj.primaryPhoneNo;

                objDealerSalesPartner = GetObject(Obj);

                var existing = objTagEntities.Dealer_SalesPartner.Find(Obj.id);
                ((IObjectContextAdapter)objTagEntities).ObjectContext.Detach(existing);
                objTagEntities.Entry(objDealerSalesPartner).State = EntityState.Modified;
                objTagEntities.SaveChanges();             
                
                //if (sPhone.Length > 10)
                //{
                //    sPhone = sPhone.Substring(sPhone.Length - 10);
                //}


             //   objUser = new UserProfileDA().GetUserByPhone(sPhone);
                objUser = new UserProfileDA().GetUserBySerial(Obj.serialCode);

                if (objUser != null)
                {
                    objUser.Email = Obj.email;
                    objUser.Password = password;
                    objUser.UserTypeContact = ((Int16)EnumUserType.Dealer).ToString();
                    objUser.Phone = sPhone;
                    objUser.Username = sPhone;
                    objUser.Serial = Obj.serialCode;
                    objUser.CanLogin = true;
                    if (new UserProfileDA().Update(objUser))
                    {

                    }
                }
                else
                {
                    sPhone = Regex.Replace(Obj.primaryPhoneNo.ToString().Trim(), @"[^0-9]", "");

                    objUser = new UserProfile();
                   
                    objUser.Serial = Obj.serialCode;
                    objUser.Password = password;
                    objUser.Email = Obj.email;
                    objUser.Phone = sPhone;
                    objUser.FirstName = Obj.firstName;
                    objUser.LastName = Obj.lastName;
                    objUser.WorkPhone = objUser.Phone; 
                    objUser.IsNewUser = false;
                    objUser.IsAgree = true;
                    objUser.Address = Obj.address1;
                    objUser.Address1 = Obj.address2;
                    objUser.Country = "US";
                    objUser.State = Obj.stateId;
                    objUser.City = Obj.city;
                    objUser.Zip = Obj.zipCode;
                    objUser.IsAdmin = false;
                    objUser.IsDeleted = false;
                    objUser.IsActive = true;
                    objUser.CanLogin = true;
                    objUser.IsUserProfileComplete = false;
                    objUser.IsBillingComplete = false;
                    objUser.CreatedBy = createdBy;
                    objUser.CreatedDate = Obj.createDate;
                    objUser.IsNewUser = true;
                    objUser.IsPhoneVerified = false;
                    objUser.UserTypeContact = ((Int16)EnumUserType.Dealer).ToString();
                    objUser.Username = objUser.Phone;

                    objTagEntities.UserProfile.Add(objUser);
                    objTagEntities.SaveChanges();
                }

               // objTagEntities.usp_UpdateUserProfileEmailAndPassword(password, objDealerSalesPartner.email, objDealerSalesPartner.mobilePhoneNo);

                return true;
            }
            catch (Exception ex)
            {

               
            }
            

            return false;
        }
      
        private Dealer_SalesPartner GetObject(Dealer_SalesPartner obj)
        {
            Dealer_SalesPartner objDealerSalesPartner = new Dealer_SalesPartner()
            {
                id = obj.id,
                address1 = obj.address1,
                address2 = obj.address2,
                city = obj.city,
                commissionRate = obj.commissionRate,                
                createDate = obj.createDate,
                email = obj.email,                
                firstName = obj.firstName,
                lastName = obj.lastName,
                joinDate = obj.joinDate,
                mobilePhoneNo = obj.mobilePhoneNo,
                primaryPhoneNo = obj.primaryPhoneNo,
                userType = 3,
                serialCode = obj.serialCode,
                stateId = obj.stateId,
                zipCode = obj.zipCode,
                routingNo = obj.routingNo,
                accountNo = obj.accountNo
            };
            return objDealerSalesPartner;
        }

        public List<usp_GetCommissionForDealerChange_Result> GetCommission(int id)
        {
            List<usp_GetCommissionForDealerChange_Result> obj = new List<usp_GetCommissionForDealerChange_Result>();
            try
            {
                obj = objTagEntities.usp_GetCommissionForDealerChange(id).ToList();
            }
            catch (Exception ex)
            {

                
            }
            return obj;
        }
        public List<usp_GetUserInfoByDealer_Result> GetUserInfoByDealer(string phone)
        {
            List<usp_GetUserInfoByDealer_Result> obj = new List<usp_GetUserInfoByDealer_Result>();
            try
            {
                obj = objTagEntities.usp_GetUserInfoByDealer(phone).ToList();
            }
            catch (Exception ex)
            {


            }
            return obj;
        }
        public List<usp_GetCommissionDetailsForDealer_Result> GetCommissionDetails(string Month,int Year,bool IsPaid, int Id)
        {
            List<usp_GetCommissionDetailsForDealer_Result> obj = new List<usp_GetCommissionDetailsForDealer_Result>();
            try
            {
                obj = objTagEntities.usp_GetCommissionDetailsForDealer(Month, Year, IsPaid, Id).ToList();
            }
            catch (Exception ex)
            {

                
            }
            return obj;
        }
    }
}
