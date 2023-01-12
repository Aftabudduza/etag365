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
    public class EmailScheduleDA
    {
        TagEntities objTagEntities = null;
        public EmailScheduleDA(bool isLazyLoadingEnable = true)
        {
            objTagEntities = TagEntity.GetEntity();
            objTagEntities.Configuration.LazyLoadingEnabled = isLazyLoadingEnable;
        }

        public EmailScheduleDA(bool isNewContext, bool isLazyLoadingEnable = true)
        {
            if (isNewContext)
                objTagEntities = TagEntity.GetFreshEntity();
            else
            {
                objTagEntities = TagEntity.GetEntity();
            }

            objTagEntities.Configuration.LazyLoadingEnabled = isLazyLoadingEnable;
        }                  
       
        public EmailSchedule GetByID(int nID)
        {
            EmailSchedule obj = null;
            try
            {         
                var empQuery = from b in objTagEntities.EmailSchedule
                               where b.Id == nID
                               select b;

                obj = empQuery.ToList().FirstOrDefault();

                
            }
            catch (Exception ex)
            {
               
            }

            return obj;
        }

        public EmailSchedule GetByEmail(string From, string To)
        {
            EmailSchedule obj = null;
            try
            {
                var empQuery = from b in objTagEntities.EmailSchedule
                               where b.FromEmail == From && b.PersonEmail == To
                               select b;

                obj = empQuery.ToList().FirstOrDefault();


            }
            catch (Exception ex)
            {

            }

            return obj;
        }

        public EmailSchedule GetByTemplate(string From, string To, int TemplateNo)
        {
            EmailSchedule obj = null;
            try
            {
                var empQuery = from b in objTagEntities.EmailSchedule
                               where b.FromEmail == From && b.PersonEmail == To && b.LastEmailNumber == TemplateNo
                               select b;

                obj = empQuery.ToList().FirstOrDefault();


            }
            catch (Exception ex)
            {

            }

            return obj;
        }

        public EmailSchedule GetByTemplateAndCategory(string From, string To, int TemplateNo, string category)
        {
            EmailSchedule obj = null;
            try
            {
                var empQuery = from b in objTagEntities.EmailSchedule
                               where b.FromEmail == From && b.PersonEmail == To && b.LastEmailNumber == TemplateNo && b.Category == category
                               select b;

                obj = empQuery.ToList().FirstOrDefault();


            }
            catch (Exception ex)
            {

            }

            return obj;
        }

        public bool Insert(EmailSchedule obj)
        {
            try
            {
                objTagEntities.EmailSchedule.Add(obj);
                objTagEntities.SaveChanges();
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public bool Update(EmailSchedule obj)
        {
            try
            {
                EmailSchedule existing = objTagEntities.EmailSchedule.Find(obj.Id);
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
                objTagEntities.EmailSchedule.Remove(this.GetByID(id));
                objTagEntities.SaveChanges();
                return true;
            }
            catch (Exception ex)
            {
                
            }

            return false;
        }
      
        public EmailSchedule GetBySQL(string sql)
        {
            EmailSchedule obj = null;
            try
            {
               
                var empQuery = objTagEntities.EmailSchedule.SqlQuery(sql).ToList<EmailSchedule>().FirstOrDefault();
                obj = empQuery;
                return obj;
            }
            catch (Exception ex)
            {
                
            }

            return obj;
        }

        public List<EmailSchedule> GetByUser(string email)
        {
            List<EmailSchedule> listEmailSchedules = null;

            var empQuery = from b in objTagEntities.EmailSchedule
                           where b.FromEmail == email
                           select b;
            listEmailSchedules = empQuery.ToList();
            return listEmailSchedules;
        }
        public List<EmailSchedule> GetByUserId(string userId)
        {
            List<EmailSchedule> listEmailSchedules = null;

            var empQuery = from b in objTagEntities.EmailSchedule
                           where b.CreatedBy == userId
                           select b;
            listEmailSchedules = empQuery.ToList();
            return listEmailSchedules;
        }
        
        public List<EmailSchedule> GetAllInfo()
        {
            List<EmailSchedule> listEmailSchedules = null;

            var empQuery = from b in objTagEntities.EmailSchedule
                           where b.Id > 0
                           select b;
            listEmailSchedules = empQuery.ToList();
            return listEmailSchedules;
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

        public List<EmailSchedule> GetByReceiverEmail(string email, string toEmail)
        {
            List<EmailSchedule> listEmailSchedules = null;

            var empQuery = from b in objTagEntities.EmailSchedule
                           where b.FromEmail == email && b.PersonEmail == toEmail
                           select b;
            listEmailSchedules = empQuery.OrderBy(x => x.LastEmailNumber).ToList();
            return listEmailSchedules;
        }

    }
}
