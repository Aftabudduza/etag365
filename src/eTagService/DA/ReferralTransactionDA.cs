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
    public class ReferralTransactionDA
    {
        TagEntities objTagEntities = null;
        public ReferralTransactionDA(bool isLazyLoadingEnable = true)
        {
            objTagEntities = TagEntity.GetEntity();
            objTagEntities.Configuration.LazyLoadingEnabled = isLazyLoadingEnable;
        }
        public ReferralTransactionDA(bool isNewContext, bool isLazyLoadingEnable = true)
        {
            if (isNewContext)
                objTagEntities = TagEntity.GetFreshEntity();
            else
            {
                objTagEntities = TagEntity.GetEntity();
            }

            objTagEntities.Configuration.LazyLoadingEnabled = isLazyLoadingEnable;
        }
        public ReferralTransaction GetbyID(int id)
        {
            ReferralTransaction objReferralTransaction = null;
            try
            {             
                var empQuery = from b in objTagEntities.ReferralTransaction
                               where b.Id == id
                               select b;

                objReferralTransaction = empQuery.ToList().FirstOrDefault();

                
            }
            catch (Exception ex)
            {
               
            }
            return objReferralTransaction;
        }      
        public bool Insert(ReferralTransaction objReferralTransaction)
        {
            try
            {                
                objTagEntities.ReferralTransaction.Add(objReferralTransaction);
                objTagEntities.SaveChanges();
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }      
        public bool Update(ReferralTransaction obj)
        {
            try
            {
                ReferralTransaction existing = objTagEntities.ReferralTransaction.Find(obj.Id);
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
                objTagEntities.ReferralTransaction.Remove(this.GetbyID(id));
                objTagEntities.SaveChanges();
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }       
        public List<ReferralTransaction> GetAllReferralTransaction()
        {
            List<ReferralTransaction> listReferralTransaction = null;
            try
            {               
                var empQuery = from b in objTagEntities.ReferralTransaction
                               where b.Id > 0
                               select b;

                listReferralTransaction = empQuery.OrderByDescending(x => x.Id).ToList();
               
            }
            catch (Exception ex)
            {
               
            }
            return listReferralTransaction;
        }
        public List<ReferralTransaction> GetByUser(string serial)
        {
            List<ReferralTransaction> listReferralTransaction = null;
            try
            {
                var empQuery = from b in objTagEntities.ReferralTransaction
                               where b.GetterPhone == serial
                               select b;

                listReferralTransaction = empQuery.OrderByDescending(x => x.Id).ToList();

            }
            catch (Exception ex)
            {

            }
            return listReferralTransaction;
        }

        public List<ReferralTransaction> GetUnpaidHistoryByUser(string serial)
        {
            List<ReferralTransaction> listReferralTransaction = null;
            try
            {
                var empQuery = from b in objTagEntities.ReferralTransaction
                               where b.GetterPhone == serial && b.IsPaid == false
                               select b;

                listReferralTransaction = empQuery.OrderBy(x => x.CommissionMonthDate).ToList();

            }
            catch (Exception ex)
            {

            }
            return listReferralTransaction;
        }

        public List<ReferralTransaction> GetBySearch(string sSearchQuery)
        {
            List<ReferralTransaction> contacts = null;
            try
            {
                string sSQL = string.Empty;
                sSQL = " select * from  ReferralTransaction where Id <> -1 ";

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

                var empQuery = objTagEntities.ReferralTransaction.SqlQuery(sSQL).ToList<ReferralTransaction>();
                contacts = empQuery.OrderByDescending(x => x.Id).ToList();

            }
            catch (Exception ex)
            {

            }

            return contacts;
        }
        public List<ReferralTransaction> GetBySearchAndUserId(string sSearchQuery, string sUserID)
        {
            List<ReferralTransaction> contacts = null;
            try
            {
                string sSQL = string.Empty;
                sSQL = " select * from  ReferralTransaction where UserID = '" + sUserID + "' ";

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

                var empQuery = objTagEntities.ReferralTransaction.SqlQuery(sSQL).ToList<ReferralTransaction>();
                contacts = empQuery.OrderByDescending(x => x.Id).ToList();

            }
            catch (Exception ex)
            {

            }

            return contacts;
        }

        public List<usp_GetDueCommissionByUser_Result> GetDueCommissionsByUser(string phone, string type)
        {
            List<usp_GetDueCommissionByUser_Result> obj = new List<usp_GetDueCommissionByUser_Result>();
            try
            {
                obj = objTagEntities.usp_GetDueCommissionByUser(phone, type).ToList();
            }

            catch (Exception ex)
            {


            }
            return obj;
        }
    }
}
