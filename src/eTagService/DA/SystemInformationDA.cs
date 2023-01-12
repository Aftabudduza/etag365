using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eTagService;
using System.Data.Entity;
using System.Data.Entity.Core.Objects;
using TagService.BO;

namespace TagService.DA
{
    public class SystemInformationDA
    {
        TagEntities objTagEntities = null;
        public SystemInformationDA(bool isLazyLoadingEnable = true)
        {
            objTagEntities = TagEntity.GetEntity();
            objTagEntities.Configuration.LazyLoadingEnabled = isLazyLoadingEnable;
        }

        public SystemInformationDA(bool isNewContext, bool isLazyLoadingEnable = true)
        {
            if (isNewContext)
                objTagEntities = TagEntity.GetFreshEntity();
            else
            {
                objTagEntities = TagEntity.GetEntity();
            }

            objTagEntities.Configuration.LazyLoadingEnabled = isLazyLoadingEnable;
        }       
        
        public SystemInformation GetByOwner(string ownerId)
        {
            SystemInformation objPropertyManager = null;
            try
            {
                var empQuery = from b in objTagEntities.SystemInformation
                               where b.UserId == ownerId
                               select b;

                objPropertyManager = empQuery.ToList().FirstOrDefault();


            }
            catch (Exception ex)
            {

            }

            return objPropertyManager;
        }
        public SystemInformation GetByUsername(string username)
        {
            SystemInformation objSystem = null;
            try
            {
                var empQuery = from b in objTagEntities.SystemInformation
                               where b.UserId == username
                               select b;

                objSystem = empQuery.ToList().FirstOrDefault();


            }
            catch (Exception ex)
            {

            }

            return objSystem;
        }
        public SystemInformation GetGlobalInfo()
        {
            SystemInformation objSystem = null;
            try
            {
                var empQuery = from b in objTagEntities.SystemInformation
                               where b.IsGlobalSystem == true
                               select b;

                objSystem = empQuery.ToList().FirstOrDefault();


            }
            catch (Exception ex)
            {

            }

            return objSystem;
        }
        public SystemInformation GetByID(int nID)
        {
            SystemInformation obj = null;
            try
            {         
                var empQuery = from b in objTagEntities.SystemInformation
                               where b.Id == nID
                               select b;

                obj = empQuery.ToList().FirstOrDefault();

                
            }
            catch (Exception ex)
            {
               
            }

            return obj;
        }
    
        public bool Insert(SystemInformation obj)
        {
            try
            {
                objTagEntities.SystemInformation.Add(obj);
                objTagEntities.SaveChanges();
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public bool Update(SystemInformation obj)
        {
            try
            {
                SystemInformation existing = objTagEntities.SystemInformation.Find(obj.Id);
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
                objTagEntities.SystemInformation.Remove(this.GetByID(id));
                objTagEntities.SaveChanges();
                return true;
            }
            catch (Exception ex)
            {
                
            }

            return false;
        }

        public SystemInformation GetUserBySQL(string sql)
        {
            SystemInformation objUser = null;
            try
            {
               
                var empQuery = objTagEntities.SystemInformation.SqlQuery(sql).ToList<SystemInformation>().FirstOrDefault();
                objUser = empQuery;
                return objUser;
            }
            catch (Exception ex)
            {
                
            }

            return objUser;
        }   
       
        public List<SystemInformation> GetAllInfo()
        {
            List<SystemInformation> users = null;

            var empQuery = from b in objTagEntities.SystemInformation
                           where b.Id > 0
                           select b;
            users = empQuery.ToList();
            return users;
        }
        public List<SystemInformation> GetBySearch(string sSearchQuery)
        {
            List<SystemInformation> ListSystem = null;
            try
            {
                string sSQL = string.Empty;
                sSQL = " select * from  SystemInformation where IsActive = 1 and IsDelete = 0 ";

                try
                {
                    if (!string.IsNullOrEmpty(sSearchQuery))
                    {
                        sSQL += " and (Website like '%" + sSearchQuery + "%')";
                    }
                }
                catch (Exception ex)
                {
                }

                var empQuery = objTagEntities.SystemInformation.SqlQuery(sSQL).ToList<SystemInformation>();
                ListSystem = empQuery.OrderBy(x => x.Website).ToList();

            }
            catch (Exception ex)
            {

            }

            return ListSystem;
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
