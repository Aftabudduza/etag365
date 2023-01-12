using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Data.Entity;
using System.Data.Entity.Core.Objects;
using eTagService;
using eTagService.Enums;
using TagService.BO;

namespace TagService.DA
{
    public class UserProfileDA
    {
        TagEntities objTagEntities = null;
        public UserProfileDA(bool isLazyLoadingEnable = true)
        {
            objTagEntities = TagEntity.GetEntity();
            objTagEntities.Configuration.LazyLoadingEnabled = isLazyLoadingEnable;
        }
        public UserProfileDA(bool isNewContext, bool isLazyLoadingEnable = true)
        {
            if (isNewContext)
                objTagEntities = TagEntity.GetFreshEntity();
            else
            {
                objTagEntities = TagEntity.GetEntity();
            }

            objTagEntities.Configuration.LazyLoadingEnabled = isLazyLoadingEnable;
        }
        public UserProfile GetUserByIDPassword(string userName, string passWord, int nAccountType)
        {
            UserProfile objUser = null;
            try
            {
                passWord = Utility.base64Encode(passWord); 
                var empQuery = from b in objTagEntities.UserProfile
                               where (b.Username == userName || b.Email == userName) && b.Password == passWord && b.IsActive == true && b.UserTypeContact == nAccountType.ToString()
                               select b;

                objUser = empQuery.ToList().FirstOrDefault();

            }
            catch (Exception ex)
            {

            }

            return objUser;
        }
        public UserProfile GetUserBySearch(string userName, string passWord, string Serial, int nAccountType)
        {
            UserProfile objUser = null;
            try
            {
                passWord = Utility.base64Encode(passWord);
                var empQuery = from b in objTagEntities.UserProfile
                               where (b.Username == userName || b.Email == userName) && b.Password == passWord && b.Serial == Serial && b.UserTypeContact == nAccountType.ToString() && b.IsActive == true
                               select b;

                objUser = empQuery.ToList().FirstOrDefault();

            }
            catch (Exception ex)
            {

            }

            return objUser;
        }
        public UserProfile GetUserByEmailPassword(string userName, string password)
        {
            UserProfile objUser = null;
            try
            {       
                password= Utility.base64Encode(password);

                var empQuery = from b in objTagEntities.UserProfile
                                where (b.Username == userName || b.Email == userName) && b.Password == password
                                select b;

                objUser = empQuery.ToList().FirstOrDefault();               
              
            }
            catch (Exception ex)
            {
               
            }

            return objUser;
        }

        public UserProfile GetUserByEmail(string Email)
        {
            UserProfile objUser = null;
            try
            {
                var empQuery = from b in objTagEntities.UserProfile
                               where b.Email == Email
                               select b;

                objUser = empQuery.ToList().FirstOrDefault();


            }
            catch (Exception ex)
            {

            }

            return objUser;
        }

        //public UserProfile GetUserByPhonePassword(string userName, string password)
        //{
        //    UserProfile objUser = null;
        //    try
        //    {
        //        password = Utility.base64Encode(password);

        //        var empQuery = from b in objTagEntities.UserProfile
        //                       where (b.Username == userName || b.Phone == userName) && b.Password == password
        //                       select b;

        //        objUser = empQuery.ToList().FirstOrDefault();

        //    }
        //    catch (Exception ex)
        //    {

        //    }

        //    return objUser;
        //}

        public UserProfile GetUserByPhonePassword(string phone, string password)
        {
            UserProfile objUser = null;          

            string sSQL = string.Empty;
            sSQL = " select * from  UserProfile where Id > 0  ";

            try
            {
                password = Utility.base64Encode(password);

                if (!string.IsNullOrEmpty(phone))
                {
                    sSQL += " and (Username = '" + phone + "' or Phone = '" + phone + "') ";
                    //sSQL += " and (Username = '" + phone + "' or (isnull(CountryCode,'') + isnull(Phone,'')) = '" + phone + "') ";
                }
                if (!string.IsNullOrEmpty(password))
                {
                    sSQL += " and Password = '" + password + "'";

                }

                var empQuery = objTagEntities.UserProfile.SqlQuery(sSQL).ToList<UserProfile>();
                objUser = empQuery.ToList().FirstOrDefault();
            }
            catch (Exception ex)
            {

            }

            return objUser;
        }
        public UserProfile GetUserByPhone(string phone)
        {
            UserProfile objUser = null;
            try
            {
                string sSQL = string.Empty;
                sSQL = " select * from  UserProfile where Id > 0  ";

                try
                {
                    if (!string.IsNullOrEmpty(phone))
                    {
                        sSQL += " and (Username = '" + phone + "' or Phone = '" + phone + "') ";
                      //  sSQL += " and (Username = '" + phone + "' or (isnull(CountryCode,'') + isnull(Phone,'')) = '" + phone + "') ";
                    }
                }
                catch (Exception ex)
                {

                }

                var empQuery = objTagEntities.UserProfile.SqlQuery(sSQL).ToList<UserProfile>();
                objUser = empQuery.ToList().FirstOrDefault();

            }
            catch (Exception ex)
            {

            }

            return objUser;
        }
        public UserProfile GetExistingUserByPhoneAndSerial(string phone, string serial)
        {
            UserProfile objUser = null;
            try
            {
                string sSQL = string.Empty;
                sSQL = " select * from  UserProfile where Id > 0  ";

                try
                {
                    if (!string.IsNullOrEmpty(phone))
                    {
                        sSQL += " and (Username = '" + phone + "' or Phone = '" + phone + "') ";
                       // sSQL += " and (Username = '" + phone + "' or (isnull(CountryCode,'') + isnull(Phone,'')) = '" + phone + "') ";
                    }
                    if (!string.IsNullOrEmpty(serial))
                    {
                        sSQL += " and Serial <> '" + serial + "'";

                    }
                }
                catch (Exception ex)
                {

                }

                var empQuery = objTagEntities.UserProfile.SqlQuery(sSQL).ToList<UserProfile>();
                objUser = empQuery.ToList().FirstOrDefault();

            }
            catch (Exception ex)
            {

            }

            return objUser;
        }
        public UserProfile GetUserBySerial(string Serial)
        {
            UserProfile objUser = null;
            try
            {
                var empQuery = from b in objTagEntities.UserProfile
                               where b.Serial == Serial
                               select b;

                objUser = empQuery.ToList().FirstOrDefault();


            }
            catch (Exception ex)
            {

            }

            return objUser;
        }
        public UserProfile GetByUserName(string userName)
        {
            UserProfile objUser = null;
            try
            {
                var empQuery = from b in objTagEntities.UserProfile
                               where b.Username == userName
                               select b;

                objUser = empQuery.ToList().FirstOrDefault();


            }
            catch (Exception ex)
            {

            }

            return objUser;
        }
        public List<UserProfile> GetUsersByUserName2(string Phone)
        {
            List<UserProfile> objUsers = null;
            try
            {             
                var empQuery = from b in objTagEntities.UserProfile
                               where b.Phone.Contains(Phone)
                               select b;

                objUsers = empQuery.ToList();

                
            }
            catch (Exception ex)
            {
               
            }

            return objUsers;
        }
        public List<UserProfile> GetUsersByUserEmail2(string email, string serial)
        { 
            List<UserProfile> objUsers = null;
            try
            {
                //var empQuery = from b in objTagEntities.UserProfile
                //               where b.Email == email
                //               select b;
                string sSQL = string.Empty;
                sSQL = " select * from  UserProfile where Id > 0  ";

                try
                {
                    if (!string.IsNullOrEmpty(email))
                    {
                        sSQL += " and Email = '" + email.Trim() + "'";

                    }
                    if (!string.IsNullOrEmpty(serial))
                    {
                        sSQL += " and Serial <> '" + serial + "'";

                    }
                }
                catch (Exception ex)
                {

                }

                var empQuery = objTagEntities.UserProfile.SqlQuery(sSQL).ToList<UserProfile>();
                objUsers = empQuery.ToList();


            }
            catch (Exception ex)
            {

            }

            return objUsers;
        }
        public UserProfile GetUserByUserID(int userID)
        {
            UserProfile objUser = null;
            try
            {         
                var empQuery = from b in objTagEntities.UserProfile
                               where b.Id == userID
                               select b;

                objUser = empQuery.ToList().FirstOrDefault();

                
            }
            catch (Exception ex)
            {
               
            }

            return objUser;
        }    
        public bool Insert(UserProfile objUser)
        {
            try
            {
                objTagEntities.UserProfile.Add(objUser);
                objTagEntities.SaveChanges();
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
            
        }
        public bool Update(UserProfile obj)
        {
            try
            {
                UserProfile existing = objTagEntities.UserProfile.Find(obj.Id);
                ((IObjectContextAdapter)objTagEntities).ObjectContext.Detach(existing);
                objTagEntities.Entry(obj).State = System.Data.Entity.EntityState.Modified;               
                objTagEntities.SaveChanges();

                return true;
            }
            catch (Exception ex)
            {
                
            }

            return false;
        }
        public bool DeleteByID(int id)
        {
            try
            {
                objTagEntities.UserProfile.Remove(this.GetUserByUserID(id));
                objTagEntities.SaveChanges();
                return true;
            }
            catch (Exception ex)
            {
                
            }

            return false;
        }
        public UserProfile GetUserBySQL(string sql)
        {
            UserProfile objUser = null;
            try
            {
               
                var empQuery = objTagEntities.UserProfile.SqlQuery(sql).ToList<UserProfile>().FirstOrDefault();
                objUser = empQuery;
                return objUser;
            }
            catch (Exception ex)
            {
                
            }

            return objUser;
        }   
        public List<UserProfile> GetAllUsersByCreatorAndStatus(int nCreatedBy, bool bStatus)
        {
            List<UserProfile> users = null;

            var empQuery = from b in objTagEntities.UserProfile
                           where (b.CreatedBy == nCreatedBy.ToString() && b.IsActive == bStatus)
                           select b;
            users = empQuery.OrderBy(x => x.LastName).ThenBy(x => x.Phone).ToList();
            return users;
        }
        public List<UserProfile> GetAllUsersInfo(int nAccountType)
        {
            List<UserProfile> users = null;


            string sSQL = string.Empty;
            try
            {

                sSQL = " select * from  UserProfile where IsActive = 1 and IsUserProfileComplete = 1 and UserTypeContact = '" + nAccountType.ToString() + "'";

                var empQuery = objTagEntities.UserProfile.SqlQuery(sSQL).ToList<UserProfile>();
                users = empQuery.OrderBy(x => x.LastName).ThenBy(x => x.Phone).ToList();

            }
            catch (Exception ex)
            {

            }


            return users;
        }
        public List<UserProfile> GetAllUsersInfoForEmailFlow(int nAccountType, string sPhone)
        {
            List<UserProfile> users = null;


            string sSQL = string.Empty;
            try
            {
                sSQL = " select * from  UserProfile where IsActive = 1 and UserTypeContact = '" + nAccountType.ToString() + "' and Phone <> '" + sPhone.ToString() + "'";

                var empQuery = objTagEntities.UserProfile.SqlQuery(sSQL).ToList<UserProfile>();
                users = empQuery.OrderBy(x => x.LastName).ThenBy(x => x.Phone).ToList();

            }
            catch (Exception ex)
            {

            }


            return users;
        }
        public List<UserProfile> GetAllUsersInfoByUser(string Phone)
        {
            List<UserProfile> users = null;


            string sSQL = string.Empty;
            try
            {
                if (!string.IsNullOrEmpty(Phone))
                {
                    sSQL = " select * from  UserProfile where IsActive = 1 and UserTypeContact <> 3 and (CreatedBy = '" + Phone + "' or UpdatedBy = '" + Phone + "') ";
                }
                    

                var empQuery = objTagEntities.UserProfile.SqlQuery(sSQL).ToList<UserProfile>();
                users = empQuery.OrderBy(x => x.LastName).ThenBy(x => x.Phone).ToList();

            }
            catch (Exception ex)
            {

            }


            return users;
        }
        public List<UserProfile> GetAllUsers()
        {
            List<UserProfile> users = null;

            var empQuery = from b in objTagEntities.UserProfile
                           where b.Id > 0 && b.IsActive == true && b.UserTypeContact != "3"
                           select b;
            users = empQuery.OrderBy(x => x.LastName).ThenBy(x => x.Phone).ToList();
            return users;
        }
        public List<UserProfile> GetByOwner(string ownerserial)
        {
            List<UserProfile> users = null;

            var empQuery = from b in objTagEntities.UserProfile
                           where b.Id > 0 && b.IsActive == true && b.Username == ownerserial
                           select b;
            users = empQuery.ToList();
            return users;
        }
        public List<UserProfile> GetBySearch(string sSearchQuery)
        {
            List<UserProfile> contacts = null;
            string sSQL = string.Empty;
            try
            {
                
                sSQL = " select * from  UserProfile where IsActive = 1  and UserTypeContact <> 3 ";

                try
                {
                    if (!string.IsNullOrEmpty(sSearchQuery))
                    {
                        sSQL += " and (Serial like '%" + sSearchQuery + "%' or Firstname like '%" + sSearchQuery + "%' or Lastname like '%" + sSearchQuery + "%'  or Email like '%" + sSearchQuery + "%'  or Phone like '%" + sSearchQuery + "%')";

                    }
                }
                catch (Exception ex)
                {

                }

                var empQuery = objTagEntities.UserProfile.SqlQuery(sSQL).ToList<UserProfile>();
                contacts = empQuery.OrderBy(x => x.LastName).ThenBy(x => x.Phone).ToList();

            }
            catch (Exception ex)
            {

            }

            return contacts;
        }
        public List<UserProfile> GetBySearchAndUser(string sSearchQuery, string Phone)
        {
            List<UserProfile> contacts = null;
            string sSQL = string.Empty;
            try
            {
                if (!string.IsNullOrEmpty(Phone))
                {
                    sSQL = " select * from  UserProfile where IsActive = 1  and UserTypeContact <> 3  and  (CreatedBy = '" + Phone + "'  or UpdatedBy = '" + Phone + "') ";

                    if (!string.IsNullOrEmpty(sSearchQuery))
                    {
                        sSQL += " and (Serial like '%" + sSearchQuery + "%' or Firstname like '%" + sSearchQuery + "%' or Lastname like '%" + sSearchQuery + "%'  or Email like '%" + sSearchQuery + "%'  or Phone like '%" + sSearchQuery + "%')";
                    }
                }                
               

                var empQuery = objTagEntities.UserProfile.SqlQuery(sSQL).ToList<UserProfile>();
                contacts = empQuery.OrderBy(x => x.LastName).ThenBy(x=>x.Phone).ToList();

            }
            catch (Exception ex)
            {

            }
           

            return contacts;
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
                string sNumber = oupParam.Value.ToString().PadLeft(11, '0');
                serial = string.Concat(yourPrefix, sNumber);

                return serial;
            }
            catch (Exception ex)
            {

            }

            return null;

        }      

    }
}
