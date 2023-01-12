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
    public class ContactInformationDA
    {
        TagEntities objTagEntities = null;
        public ContactInformationDA(bool isLazyLoadingEnable = true)
        {
            objTagEntities = TagEntity.GetEntity();
            objTagEntities.Configuration.LazyLoadingEnabled = isLazyLoadingEnable;
        }
        public ContactInformationDA(bool isNewContext, bool isLazyLoadingEnable = true)
        {
            if (isNewContext)
                objTagEntities = TagEntity.GetFreshEntity();
            else
            {
                objTagEntities = TagEntity.GetEntity();
            }

            objTagEntities.Configuration.LazyLoadingEnabled = isLazyLoadingEnable;
        }
        public ContactInformation GetbyID(int id)
        {
            ContactInformation objContactInformation = null;
            try
            {             
                var empQuery = from b in objTagEntities.ContactInformation
                               where b.Id == id
                               select b;

                objContactInformation = empQuery.ToList().FirstOrDefault();

                
            }
            catch (Exception ex)
            {
               
            }
            return objContactInformation;
        }      
        public bool Insert(ContactInformation objContactInformation)
        {
            try
            {                
                objTagEntities.ContactInformation.Add(objContactInformation);
                objTagEntities.SaveChanges();
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }      
        public bool Update(ContactInformation obj)
        {
            try
            {
                ContactInformation existing = objTagEntities.ContactInformation.Find(obj.Id);
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
                objTagEntities.ContactInformation.Remove(this.GetbyID(id));
                objTagEntities.SaveChanges();
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }       
        public List<ContactInformation> GetAllContactInformation()
        {
            List<ContactInformation> listContactInformation = null;
            try
            {               
                var empQuery = from b in objTagEntities.ContactInformation
                               where b.Id > 0
                               select b;

                listContactInformation = empQuery.OrderBy(x => x.LastName).ToList();
               
            }
            catch (Exception ex)
            {
               
            }
            return listContactInformation;
        }
        public List<ContactInformation> GetByUser(string sId)
        {
            List<ContactInformation> listContactInformation = null;
            try
            {
                var empQuery = from b in objTagEntities.ContactInformation
                               where b.UserId == sId
                               select b;

                listContactInformation = empQuery.OrderBy(x => x.LastName).ToList();

            }
            catch (Exception ex)
            {

            }
            return listContactInformation;
        }

        public List<ContactInformation> GetByUserId(string sId)
        {
            List<ContactInformation> listContactInformation = null;
            try
            {
                var empQuery = from b in objTagEntities.ContactInformation
                               where b.UserId == sId
                               select b;

                listContactInformation = empQuery.OrderBy(x => x.LastName).ThenBy(x=>x.Phone).ToList();

            }
            catch (Exception ex)
            {

            }
            return listContactInformation;
        }
        public List<ContactInformation> GetBySearch(string sSearchQuery)
        {
            List<ContactInformation> contacts = null;
            try
            {
                string sSQL = string.Empty;
                sSQL = " select * from  ContactInformation where Id <> -1 ";

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

                var empQuery = objTagEntities.ContactInformation.SqlQuery(sSQL).ToList<ContactInformation>();
                contacts = empQuery.OrderBy(x => x.LastName).ToList();

            }
            catch (Exception ex)
            {

            }

            return contacts;
        }
        public List<ContactInformation> GetBySearchAndUserId(string sSearchQuery, string sUserID)
        {
            List<ContactInformation> contacts = null;
            try
            {
                string sSQL = string.Empty;
                sSQL = " select * from  ContactInformation where Id <> -1  and UserID = '" + sUserID + "' ";

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

                var empQuery = objTagEntities.ContactInformation.SqlQuery(sSQL).ToList<ContactInformation>();
                contacts = empQuery.OrderBy(x => x.LastName).ToList();

            }
            catch (Exception ex)
            {

            }

            return contacts;
        }
        public List<ContactInformation> GetAllContactsForSchedulerByUser(string sUserID)
        {
            List<ContactInformation> contacts = null;
            try
            {
                string sSQL = string.Empty;
                sSQL = " select * from  ContactInformation where IsEmailFlow = '1'  and UserID = '" + sUserID + "'";

                var empQuery = objTagEntities.ContactInformation.SqlQuery(sSQL).ToList<ContactInformation>();
                contacts = empQuery.OrderBy(x => x.LastName).ToList();

            }
            catch (Exception ex)
            {

            }

            return contacts;
        }
        public List<ContactInformation> GetContactsForScheduler(string category, string type, string sUserID)
        {
            List<ContactInformation> contacts = null;
            try
            {
                string sSQL = string.Empty;
                sSQL = " select * from  ContactInformation where IsEmailFlow = '1'  and UserID = '" + sUserID + "' ";

                try
                {
                    if (!string.IsNullOrEmpty(category))
                    {
                        sSQL += " and Category = '" + category + "' ";
                    }
                    if (!string.IsNullOrEmpty(type))
                    {
                        sSQL += " and Type = '" + type + "' ";
                    }

                }
                catch (Exception ex)
                {

                }

                var empQuery = objTagEntities.ContactInformation.SqlQuery(sSQL).ToList<ContactInformation>();
                contacts = empQuery.OrderBy(x => x.LastName).ToList();

            }
            catch (Exception ex)
            {

            }

            return contacts;
        }

    }
}
