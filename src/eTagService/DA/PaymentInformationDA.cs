using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TagService.BO;
using eTagService;
using System.Data.Entity;
using System.Data.Entity.Core.Objects;

namespace TagService.DA
{
    public class PaymentInformationDA
    {
        TagEntities objTagEntities = null;
        public PaymentInformationDA(bool isLazyLoadingEnable = true)
        {
            objTagEntities = TagEntity.GetEntity();
            objTagEntities.Configuration.LazyLoadingEnabled = isLazyLoadingEnable;
        }

        public PaymentInformationDA(bool isNewContext, bool isLazyLoadingEnable = true)
        {
            if (isNewContext)
                objTagEntities = TagEntity.GetFreshEntity();
            else
            {
                objTagEntities = TagEntity.GetEntity();
            }

            objTagEntities.Configuration.LazyLoadingEnabled = isLazyLoadingEnable;
        }             

        public PaymentInformation GetByOwner(string userId)
        {
            PaymentInformation obj = null;
            try
            {
                var empQuery = from b in objTagEntities.PaymentInformation
                               where b.UserId == userId
                               select b;

                obj = empQuery.ToList().FirstOrDefault();


            }
            catch (Exception ex)
            {

            }

            return obj;
        }

        public PaymentInformation GetCheckingAccountByUserId(string userId)
        {
            PaymentInformation obj = null;
            try
            {
                var empQuery = from b in objTagEntities.PaymentInformation
                               where b.UserId == userId && b.IsCheckingAccount == true
                               select b;

                obj = empQuery.ToList().FirstOrDefault();


            }
            catch (Exception ex)
            {

            }

            return obj;
        }

        public PaymentInformation GetByID(int nID)
        {
            PaymentInformation obj = null;
            try
            {         
                var empQuery = from b in objTagEntities.PaymentInformation
                               where b.Id == nID
                               select b;

                obj = empQuery.ToList().FirstOrDefault();

                
            }
            catch (Exception ex)
            {
               
            }

            return obj;
        }

       

        public bool Insert(PaymentInformation obj)
        {
            objTagEntities.PaymentInformation.Add(obj);
            objTagEntities.SaveChanges();

            return true;
        }

        public bool Update(PaymentInformation obj)
        {
            try
            {
                PaymentInformation existing = objTagEntities.PaymentInformation.Find(obj.Id);
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
                objTagEntities.PaymentInformation.Remove(this.GetByID(id));
                objTagEntities.SaveChanges();
                return true;
            }
            catch (Exception ex)
            {
                
            }

            return false;
        }

        public bool DeleteByOwnerCardAndCheckingAccount(string userId, string card, string account)
        {
            try
            {
                objTagEntities.PaymentInformation.Remove(this.GetByOwnerCardAndCheckingAccount(userId, card, account));
                objTagEntities.SaveChanges();
                return true;
            }
            catch (Exception ex)
            {

            }

            return false;
        }
        public PaymentInformation GetByOwnerCardAndCheckingAccount(string userId, string card, string account)
        {
            PaymentInformation obj = null;
            try
            {
                var empQuery = from b in objTagEntities.PaymentInformation
                               where b.UserId == userId && b.CardNumber == card && b.AccountNo == account
                               select b;

                obj = empQuery.ToList().FirstOrDefault();


            }
            catch (Exception ex)
            {

            }

            return obj;
        }
        public PaymentInformation GetBySQL(string sql)
        {
            PaymentInformation obj = null;
            try
            {
               
                var empQuery = objTagEntities.PaymentInformation.SqlQuery(sql).ToList<PaymentInformation>().FirstOrDefault();
                obj = empQuery;
                return obj;
            }
            catch (Exception ex)
            {
                
            }

            return obj;
        }   
       
        public List<PaymentInformation> GetByOwnerId(string userId)
        {
            List<PaymentInformation> listPaymentInformations = null;

            var empQuery = from b in objTagEntities.PaymentInformation
                           where b.UserId == userId
                           select b;
            listPaymentInformations = empQuery.ToList();
            return listPaymentInformations;
        }
        public List<PaymentInformation> GetByUserId(string userId)
        {
            List<PaymentInformation> listPaymentInformations = null;

            var empQuery = from b in objTagEntities.PaymentInformation
                           where b.UserId == userId
                           select b;
            listPaymentInformations = empQuery.ToList();
            return listPaymentInformations;
        }
        
        public List<PaymentInformation> GetAllInfo()
        {
            List<PaymentInformation> listPaymentInformations = null;

            var empQuery = from b in objTagEntities.PaymentInformation
                           where b.Id > 0
                           select b;
            listPaymentInformations = empQuery.ToList();
            return listPaymentInformations;
        }
        public string MakeAutoGenSerial(string yourPrefix, string objName)
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
                string sNumber = oupParam.Value.ToString().PadLeft(9, '0');
                serial = string.Concat(yourPrefix + prefix , sNumber);

                return serial;
            }
            catch (Exception ex)
            {

            }


            return null;

        }

    }
}
