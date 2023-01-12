using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eTagService;
using TagService.BO;


namespace TagService.DA
{
    public class ReferralAccountDA
    {
        TagEntities objTagEntities = null;
        public ReferralAccountDA(bool isLazyLoadingEnable = true)
        {
            objTagEntities = TagEntity.GetEntity();
            objTagEntities.Configuration.LazyLoadingEnabled = isLazyLoadingEnable;
        }
        public ReferralAccountDA(bool isNewContext, bool isLazyLoadingEnable = true)
        {
            if (isNewContext)
                objTagEntities = TagEntity.GetFreshEntity();
            else
            {
                objTagEntities = TagEntity.GetEntity();
            }

            objTagEntities.Configuration.LazyLoadingEnabled = isLazyLoadingEnable;
        }
        public ReferralAccount GetbyID(int id)
        {
            ReferralAccount objReferralAccount = null;
            try
            {             
                var empQuery = from b in objTagEntities.ReferralAccount
                               where b.Id == id
                               select b;

                objReferralAccount = empQuery.ToList().FirstOrDefault();

                
            }
            catch (Exception ex)
            {
               
            }
            return objReferralAccount;
        }

        public ReferralAccount GetUserByGiverPhone(string Phone)
        {
            ReferralAccount objUser = null;
            try
            {
                string sSQL = string.Empty;
                sSQL = " select * from  ReferralAccount where Id > 0  ";

                try
                {
                    if (!string.IsNullOrEmpty(Phone))
                    {
                        sSQL += " and GiverPhone = '" + Phone + "'";

                    }
                }
                catch (Exception ex)
                {

                }

                var empQuery = objTagEntities.ReferralAccount.SqlQuery(sSQL).ToList<ReferralAccount>();
                objUser = empQuery.ToList().FirstOrDefault();

            }
            catch (Exception ex)
            {

            }

            return objUser;
        }

        public bool Insert(ReferralAccount objReferralAccount)
        {
            try
            {                
                objTagEntities.ReferralAccount.Add(objReferralAccount);
                objTagEntities.SaveChanges();
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }      
        public bool Update(ReferralAccount obj)
        {
            try
            {
                ReferralAccount existing = objTagEntities.ReferralAccount.Find(obj.Id);
                ((IObjectContextAdapter)objTagEntities).ObjectContext.Detach(existing);
                objTagEntities.Entry(obj).State = System.Data.Entity.EntityState.Modified;
                objTagEntities.SaveChanges();

                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }
        public bool DeleteByID(int id)
        {
            try
            {
                objTagEntities.ReferralAccount.Remove(this.GetbyID(id));
                objTagEntities.SaveChanges();
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }       
        public List<ReferralAccount> GetAllReferralAccount()
        {
            List<ReferralAccount> listReferralAccount = null;
            try
            {               
                var empQuery = from b in objTagEntities.ReferralAccount
                               where b.Id > 0
                               select b;

                listReferralAccount = empQuery.OrderBy(x => x.CreatedDate).ToList();
               
            }
            catch (Exception ex)
            {
               
            }
            return listReferralAccount;
        }
        public List<ReferralAccount> GetByGetterPhone(string Phone)
        {
            List<ReferralAccount> listReferralAccount = null;
            try
            {
                string sSQL = string.Empty;
                sSQL = " select * from  ReferralAccount where Id > 0  ";

                try
                {
                    if (!string.IsNullOrEmpty(Phone))
                    {
                        sSQL += " and GetterPhone = '" + Phone + "'";

                    }
                }
                catch (Exception ex)
                {

                }

                var empQuery = objTagEntities.ReferralAccount.SqlQuery(sSQL).ToList<ReferralAccount>();
                listReferralAccount = empQuery.OrderBy(x => x.CreatedDate).ToList();

            }
            catch (Exception ex)
            {

            }
            return listReferralAccount;
        }
        public List<ReferralAccount> GetBySearch(string sSearchQuery)
        {
            List<ReferralAccount> contacts = null;
            try
            {
                string sSQL = string.Empty;
                sSQL = " select * from  ReferralAccount where Id <> -1 ";

                try
                {
                    if (!string.IsNullOrEmpty(sSearchQuery))
                    {
                        sSQL += " and (FirstName like '%" + sSearchQuery + "%' or LastName like '%" + sSearchQuery + "%'  or Companyname like '%" + sSearchQuery + "%'  or Email like '%" + sSearchQuery + "%'  or Phone like '%" + sSearchQuery + "%')";

                    }


                }
                catch (Exception ex)
                {

                }

                var empQuery = objTagEntities.ReferralAccount.SqlQuery(sSQL).ToList<ReferralAccount>();
                contacts = empQuery.OrderBy(x => x.CreatedDate).ToList();

            }
            catch (Exception ex)
            {

            }

            return contacts;
        }
        public List<ReferralAccount> GetBySearchAndUserId(string sSearchQuery, string sUserID)
        {
            List<ReferralAccount> contacts = null;
            try
            {
                string sSQL = string.Empty;
                sSQL = " select * from  ReferralAccount where UserID = '" + sUserID + "' ";

                try
                {
                    if (!string.IsNullOrEmpty(sSearchQuery))
                    {
                        sSQL += " and (FirstName like '%" + sSearchQuery + "%' or LastName like '%" + sSearchQuery + "%'  or Companyname like '%" + sSearchQuery + "%'  or Email like '%" + sSearchQuery + "%'  or Phone like '%" + sSearchQuery + "%')";

                    }


                }
                catch (Exception ex)
                {

                }

                var empQuery = objTagEntities.ReferralAccount.SqlQuery(sSQL).ToList<ReferralAccount>();
                contacts = empQuery.OrderBy(x => x.CreatedDate).ToList();

            }
            catch (Exception ex)
            {

            }

            return contacts;
        }

    }
}
