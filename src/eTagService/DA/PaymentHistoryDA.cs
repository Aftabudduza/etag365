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
    public class PaymentHistoryDA
    {
        TagEntities objTagEntities = null;
        public PaymentHistoryDA(bool isLazyLoadingEnable = true)
        {
            objTagEntities = TagEntity.GetEntity();
            objTagEntities.Configuration.LazyLoadingEnabled = isLazyLoadingEnable;
        }
        public PaymentHistoryDA(bool isNewContext, bool isLazyLoadingEnable = true)
        {
            if (isNewContext)
                objTagEntities = TagEntity.GetFreshEntity();
            else
            {
                objTagEntities = TagEntity.GetEntity();
            }

            objTagEntities.Configuration.LazyLoadingEnabled = isLazyLoadingEnable;
        }
        public PaymentHistory GetbyID(int id)
        {
            PaymentHistory objPaymentHistory = null;
            try
            {             
                var empQuery = from b in objTagEntities.PaymentHistory
                               where b.Id == id
                               select b;

                objPaymentHistory = empQuery.ToList().FirstOrDefault();

                
            }
            catch (Exception ex)
            {
               
            }
            return objPaymentHistory;
        }      
        public bool Insert(PaymentHistory objPaymentHistory)
        {
            try
            {                
                objTagEntities.PaymentHistory.Add(objPaymentHistory);
                objTagEntities.SaveChanges();
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public long InsertPayment(PaymentHistory objPaymentHistory)
        {
            try
            {
                objTagEntities.PaymentHistory.Add(objPaymentHistory);
                objTagEntities.SaveChanges();
                return objPaymentHistory.Id;
            }
            catch (Exception ex)
            {
                return 0;
            }
        }

        public bool Update(PaymentHistory obj)
        {
            try
            {
                PaymentHistory existing = objTagEntities.PaymentHistory.Find(obj.Id);
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
                objTagEntities.PaymentHistory.Remove(this.GetbyID(id));
                objTagEntities.SaveChanges();
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }       
        public List<PaymentHistory> GetAllPaymentHistoryByTransactionType(string sType)
        {
            List<PaymentHistory> listPaymentHistory = null;
            try
            {
                string sSQL = string.Empty;
                sSQL = " select * from  PaymentHistory where Status = 'pending' and TransactionType = '" + sType + "' ";
                var empQuery = objTagEntities.PaymentHistory.SqlQuery(sSQL).ToList<PaymentHistory>();
                listPaymentHistory = empQuery.OrderByDescending(x => x.Id).ToList();
            }
            catch (Exception ex)
            {

            }
            return listPaymentHistory;
        }

        public List<PaymentHistory> GetByUserAndTransactionType(string serial, string sType)
        {
            List<PaymentHistory> listPaymentHistory = null;
            try
            {
                var empQuery = from b in objTagEntities.PaymentHistory
                               where b.FromUser == serial && b.TransactionType == sType
                               select b;

                listPaymentHistory = empQuery.OrderByDescending(x => x.Id).ToList();

            }
            catch (Exception ex)
            {

            }
            return listPaymentHistory;
        }

        public List<PaymentHistory> GetCommissionPaymentHistoryByUser(string phone, string sType)
        {
            List<PaymentHistory> listPaymentHistory = null;
            try
            {
                var empQuery = from b in objTagEntities.PaymentHistory
                               where b.Status == "pending" && b.ToUser == phone && b.TransactionType == sType
                               select b;

                listPaymentHistory = empQuery.OrderByDescending(x => x.Id).ToList();

            }
            catch (Exception ex)
            {

            }
            return listPaymentHistory;
        }

        public List<PaymentHistory> GetCommissionPaymentHistoryBySearch(string sSearchQuery, string sType)
        {
            List<PaymentHistory> contacts = null;
            try
            {
                string sSQL = string.Empty;
                sSQL = " select * from  PaymentHistory where Status = 'pending' and TransactionType = '" + sType + "' ";

                try
                {
                    if (!string.IsNullOrEmpty(sSearchQuery))
                    {
                        sSQL += " and (TransactionCode like '%" + sSearchQuery + "%' or ToUser like '%" + sSearchQuery + "%')";
                    }
                }
                catch (Exception ex)
                {

                }

                var empQuery = objTagEntities.PaymentHistory.SqlQuery(sSQL).ToList<PaymentHistory>();
                contacts = empQuery.OrderByDescending(x => x.Id).ToList();

            }
            catch (Exception ex)
            {

            }

            return contacts;
        }

        public List<PaymentHistory> GetBySearch(string sSearchQuery, string sType)
        {
            List<PaymentHistory> contacts = null;
            try
            {
                string sSQL = string.Empty;
                sSQL = " select * from  PaymentHistory where Status = 'pending' and TransactionType = '" + sType + "' ";

                try
                {
                    if (!string.IsNullOrEmpty(sSearchQuery))
                    {
                        sSQL += " and (TransactionCode like '%" + sSearchQuery + "%' or FromUser like '%" + sSearchQuery + "%')";
                    }
                }
                catch (Exception ex)
                {

                }

                var empQuery = objTagEntities.PaymentHistory.SqlQuery(sSQL).ToList<PaymentHistory>();
                contacts = empQuery.OrderByDescending(x => x.Id).ToList();

            }
            catch (Exception ex)
            {

            }

            return contacts;
        }
        public List<PaymentHistory> GetBySearchAndUserId(string sSearchQuery, string sUserID)
        {
            List<PaymentHistory> contacts = null;
            try
            {
                string sSQL = string.Empty;
                sSQL = " select * from  PaymentHistory where Id <> -1  and UserID = '" + sUserID + "' ";

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

                var empQuery = objTagEntities.PaymentHistory.SqlQuery(sSQL).ToList<PaymentHistory>();
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
