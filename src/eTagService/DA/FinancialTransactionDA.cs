using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Core.Objects;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eTagService;
using TagService.BO;


namespace TagService.DA
{
    public class FinancialTransactionDA
    {
        TagEntities objTagEntities = null;
        public FinancialTransactionDA(bool isLazyLoadingEnable = true)
        {
            objTagEntities = TagEntity.GetEntity();
            objTagEntities.Configuration.LazyLoadingEnabled = isLazyLoadingEnable;
        }
        public FinancialTransactionDA(bool isNewContext, bool isLazyLoadingEnable = true)
        {
            if (isNewContext)
                objTagEntities = TagEntity.GetFreshEntity();
            else
            {
                objTagEntities = TagEntity.GetEntity();
            }

            objTagEntities.Configuration.LazyLoadingEnabled = isLazyLoadingEnable;
        }
        public FinancialTransaction GetbyID(int id)
        {
            FinancialTransaction objFinancialTransaction = null;
            try
            {             
                var empQuery = from b in objTagEntities.FinancialTransaction
                               where b.Id == id
                               select b;

                objFinancialTransaction = empQuery.ToList().FirstOrDefault();

                
            }
            catch (Exception ex)
            {
               
            }
            return objFinancialTransaction;
        }      
        public bool Insert(FinancialTransaction objFinancialTransaction)
        {
            try
            {                
                objTagEntities.FinancialTransaction.Add(objFinancialTransaction);
                objTagEntities.SaveChanges();
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }      
        public bool Update(FinancialTransaction obj)
        {
            try
            {
                FinancialTransaction existing = objTagEntities.FinancialTransaction.Find(obj.Id);
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
                objTagEntities.FinancialTransaction.Remove(this.GetbyID(id));
                objTagEntities.SaveChanges();
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }       
        public List<FinancialTransaction> GetAllFinancialTransaction()
        {
            List<FinancialTransaction> listFinancialTransaction = null;
            try
            {               
                var empQuery = from b in objTagEntities.FinancialTransaction
                               where b.Id > 0
                               select b;

                listFinancialTransaction = empQuery.OrderByDescending(x => x.Id).ToList();
               
            }
            catch (Exception ex)
            {
               
            }
            return listFinancialTransaction;
        }
        public List<FinancialTransaction> GetByUser(string serial)
        {
            List<FinancialTransaction> listFinancialTransaction = null;
            try
            {
                var empQuery = from b in objTagEntities.FinancialTransaction
                               where b.RefId == serial
                               select b;

                listFinancialTransaction = empQuery.OrderByDescending(x => x.Id).ToList();

            }
            catch (Exception ex)
            {

            }
            return listFinancialTransaction;
        }
        public List<FinancialTransaction> GetBySearch(string sSearchQuery)
        {
            List<FinancialTransaction> contacts = null;
            try
            {
                string sSQL = string.Empty;
                sSQL = " select * from  FinancialTransaction where Id <> -1 ";

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

                var empQuery = objTagEntities.FinancialTransaction.SqlQuery(sSQL).ToList<FinancialTransaction>();
                contacts = empQuery.OrderByDescending(x => x.Id).ToList();

            }
            catch (Exception ex)
            {

            }

            return contacts;
        }
        public List<FinancialTransaction> GetBySearchAndUserId(string sSearchQuery, string sUserID)
        {
            List<FinancialTransaction> contacts = null;
            try
            {
                string sSQL = string.Empty;
                sSQL = " select * from  FinancialTransaction where Id <> -1  and UserID = '" + sUserID + "' ";

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

                var empQuery = objTagEntities.FinancialTransaction.SqlQuery(sSQL).ToList<FinancialTransaction>();
                contacts = empQuery.OrderByDescending(x => x.Id).ToList();

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
