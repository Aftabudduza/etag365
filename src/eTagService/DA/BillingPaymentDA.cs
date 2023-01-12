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
    public class BillingPaymentDA
    {
        TagEntities objTagEntities = null;
        public BillingPaymentDA(bool isLazyLoadingEnable = true)
        {
            objTagEntities = TagEntity.GetEntity();
            objTagEntities.Configuration.LazyLoadingEnabled = isLazyLoadingEnable;
        }
        public BillingPaymentDA(bool isNewContext, bool isLazyLoadingEnable = true)
        {
            if (isNewContext)
                objTagEntities = TagEntity.GetFreshEntity();
            else
            {
                objTagEntities = TagEntity.GetEntity();
            }

            objTagEntities.Configuration.LazyLoadingEnabled = isLazyLoadingEnable;
        }
        public BillingPayment GetbyID(int id)
        {
            BillingPayment objBillingPayment = null;
            try
            {             
                var empQuery = from b in objTagEntities.BillingPayment
                               where b.Id == id
                               select b;

                objBillingPayment = empQuery.ToList().FirstOrDefault();

                
            }
            catch (Exception ex)
            {
               
            }
            return objBillingPayment;
        }
        public BillingPayment GetbyUserID(string userid)
        {
            BillingPayment objBillingPayment = null;
            try
            {
                var empQuery = from b in objTagEntities.BillingPayment
                               where b.UserId == userid
                               select b;

                objBillingPayment = empQuery.ToList().FirstOrDefault();


            }
            catch (Exception ex)
            {

            }
            return objBillingPayment;
        }
        public bool Insert(BillingPayment objBillingPayment)
        {
            try
            {                
                objTagEntities.BillingPayment.Add(objBillingPayment);
                objTagEntities.SaveChanges();
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }      
        public bool Update(BillingPayment obj)
        {
            try
            {
                BillingPayment existing = objTagEntities.BillingPayment.Find(obj.Id);
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
                objTagEntities.BillingPayment.Remove(this.GetbyID(id));
                objTagEntities.SaveChanges();
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }       
        public List<BillingPayment> GetAllBillingPayment()
        {
            List<BillingPayment> listBillingPayment = null;
            try
            {               
                var empQuery = from b in objTagEntities.BillingPayment
                               where b.Id > 0
                               select b;

                listBillingPayment = empQuery.OrderByDescending(x => x.Id).ToList();
               
            }
            catch (Exception ex)
            {
               
            }
            return listBillingPayment;
        }
        public List<BillingPayment> GetByUser(string serial)
        {
            List<BillingPayment> listBillingPayment = null;
            try
            {
                var empQuery = from b in objTagEntities.BillingPayment
                               where b.UserId == serial
                               select b;

                listBillingPayment = empQuery.OrderByDescending(x => x.Id).ToList();

            }
            catch (Exception ex)
            {

            }
            return listBillingPayment;
        }
        public List<BillingPayment> GetBySearch(string sSearchQuery)
        {
            List<BillingPayment> contacts = null;
            try
            {
                string sSQL = string.Empty;
                sSQL = " select * from  BillingPayment where Id <> -1 ";

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

                var empQuery = objTagEntities.BillingPayment.SqlQuery(sSQL).ToList<BillingPayment>();
                contacts = empQuery.OrderByDescending(x => x.Id).ToList();

            }
            catch (Exception ex)
            {

            }

            return contacts;
        }
        public List<BillingPayment> GetBySearchAndUserId(string sSearchQuery, string sUserID)
        {
            List<BillingPayment> contacts = null;
            try
            {
                string sSQL = string.Empty;
                sSQL = " select * from  BillingPayment where Id <> -1  and UserID = '" + sUserID + "' ";

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

                var empQuery = objTagEntities.BillingPayment.SqlQuery(sSQL).ToList<BillingPayment>();
                contacts = empQuery.OrderByDescending(x => x.Id).ToList();

            }
            catch (Exception ex)
            {

            }

            return contacts;
        }

    }
}
