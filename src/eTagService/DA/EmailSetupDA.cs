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
    public class EmailSetupDA
    {
        TagEntities objTagEntities = null;
        public EmailSetupDA(bool isLazyLoadingEnable = true)
        {
            objTagEntities = TagEntity.GetEntity();
            objTagEntities.Configuration.LazyLoadingEnabled = isLazyLoadingEnable;
        }

        public EmailSetupDA(bool isNewContext, bool isLazyLoadingEnable = true)
        {
            if (isNewContext)
                objTagEntities = TagEntity.GetFreshEntity();
            else
            {
                objTagEntities = TagEntity.GetEntity();
            }

            objTagEntities.Configuration.LazyLoadingEnabled = isLazyLoadingEnable;
        }             

        public EmailSetup GetByOwner(string userId)
        {
            EmailSetup obj = null;
            try
            {
                var empQuery = from b in objTagEntities.EmailSetup
                               where b.UserId == userId
                               select b;

                obj = empQuery.ToList().FirstOrDefault();


            }
            catch (Exception ex)
            {

            }

            return obj;
        }

      

        public EmailSetup GetByID(int nID)
        {
            EmailSetup obj = null;
            try
            {         
                var empQuery = from b in objTagEntities.EmailSetup
                               where b.Id == nID
                               select b;

                obj = empQuery.ToList().FirstOrDefault();

                
            }
            catch (Exception ex)
            {
               
            }

            return obj;
        }

       

        public bool Insert(EmailSetup obj)
        {
            try
            {
                objTagEntities.EmailSetup.Add(obj);
                ///  objTagEntities.SaveChanges();

                objTagEntities.Database.ExecuteSqlCommand("SET IDENTITY_INSERT [dbo].[EmailSetup] ON;");
                objTagEntities.SaveChanges();
                objTagEntities.Database.ExecuteSqlCommand("SET IDENTITY_INSERT [dbo].[EmailSetup] OFF");
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public bool Update(EmailSetup obj)
        {
            try
            {
                EmailSetup existing = objTagEntities.EmailSetup.Find(obj.Id);
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
                objTagEntities.EmailSetup.Remove(this.GetByID(id));
                objTagEntities.SaveChanges();
                return true;
            }
            catch (Exception ex)
            {
                
            }

            return false;
        }

      
        public EmailSetup GetBySQL(string sql)
        {
            EmailSetup obj = null;
            try
            {
               
                var empQuery = objTagEntities.EmailSetup.SqlQuery(sql).ToList<EmailSetup>().FirstOrDefault();
                obj = empQuery;
                return obj;
            }
            catch (Exception ex)
            {
                
            }

            return obj;
        }   
       
      
        public List<EmailSetup> GetByUserId(string userId)
        {
            List<EmailSetup> listEmailSetups = null;

            var empQuery = from b in objTagEntities.EmailSetup
                           where b.UserId == userId
                           select b;
            listEmailSetups = empQuery.OrderBy(x=>x.TemplateNo).ToList();
            return listEmailSetups;
        }

        public List<EmailSetup> GetByTemplateNo(string userphone, string sTemplateNo)
        {
            List<EmailSetup> listEmailSetups = null;

            var empQuery = from b in objTagEntities.EmailSetup
                           where b.TemplateNo == sTemplateNo && b.CreatedBy == userphone.Trim()
                           select b;
           
            listEmailSetups = empQuery.OrderBy(x => x.TemplateNo).ToList();

            return listEmailSetups;
        }

        public List<EmailSetup> GetAllInfo()
        {
            List<EmailSetup> listEmailSetups = null;

            var empQuery = from b in objTagEntities.EmailSetup
                           where b.Id > 0
                           select b;
            listEmailSetups = empQuery.ToList();
            return listEmailSetups;
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
