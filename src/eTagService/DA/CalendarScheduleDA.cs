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
    public class CalendarScheduleDA
    {
        TagEntities objTagEntities = null;
        public CalendarScheduleDA(bool isLazyLoadingEnable = true)
        {
            objTagEntities = TagEntity.GetEntity();
            objTagEntities.Configuration.LazyLoadingEnabled = isLazyLoadingEnable;
        }
        public CalendarScheduleDA(bool isNewContext, bool isLazyLoadingEnable = true)
        {
            if (isNewContext)
                objTagEntities = TagEntity.GetFreshEntity();
            else
            {
                objTagEntities = TagEntity.GetEntity();
            }

            objTagEntities.Configuration.LazyLoadingEnabled = isLazyLoadingEnable;
        }
        public CalendarSchedule GetbyID(int id)
        {
            CalendarSchedule objCalendarSchedule = null;
            try
            {             
                var empQuery = from b in objTagEntities.CalendarSchedule
                               where b.Id == id
                               select b;

                objCalendarSchedule = empQuery.ToList().FirstOrDefault();

                
            }
            catch (Exception ex)
            {
               
            }
            return objCalendarSchedule;
        }
        public CalendarSchedule GetbyUserID(string userid)
        {
            CalendarSchedule objCalendarSchedule = null;
            try
            {
                var empQuery = from b in objTagEntities.CalendarSchedule
                               where b.UserId == userid
                               select b;

                objCalendarSchedule = empQuery.ToList().FirstOrDefault();


            }
            catch (Exception ex)
            {

            }
            return objCalendarSchedule;
        }
        public bool Insert(CalendarSchedule objCalendarSchedule)
        {
            try
            {                
                objTagEntities.CalendarSchedule.Add(objCalendarSchedule);
                objTagEntities.SaveChanges();
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }      
        public bool Update(CalendarSchedule obj)
        {
            try
            {
                CalendarSchedule existing = objTagEntities.CalendarSchedule.Find(obj.Id);
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
                objTagEntities.CalendarSchedule.Remove(this.GetbyID(id));
                objTagEntities.SaveChanges();
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }       
        public List<CalendarSchedule> GetAllCalendarSchedule()
        {
            List<CalendarSchedule> listCalendarSchedule = null;
            try
            {               
                var empQuery = from b in objTagEntities.CalendarSchedule
                               where b.Id > 0
                               select b;

                listCalendarSchedule = empQuery.OrderByDescending(x => x.Id).ToList();
               
            }
            catch (Exception ex)
            {
               
            }
            return listCalendarSchedule;
        }
        public List<CalendarSchedule> GetByUser(string serial)
        {
            List<CalendarSchedule> listCalendarSchedule = null;
            try
            {
                var empQuery = from b in objTagEntities.CalendarSchedule
                               where b.UserId == serial
                               select b;

                listCalendarSchedule = empQuery.OrderByDescending(x => x.Id).ToList();

            }
            catch (Exception ex)
            {

            }
            return listCalendarSchedule;
        }
        public List<CalendarSchedule> GetBySearch(string sSearchQuery)
        {
            List<CalendarSchedule> contacts = null;
            try
            {
                string sSQL = string.Empty;
                sSQL = " select * from  CalendarSchedule where Id <> -1 ";

                try
                {
                    if (!string.IsNullOrEmpty(sSearchQuery))
                    {
                        sSQL += " and (UserName like '%" + sSearchQuery + "%' or UserEmail like '%" + sSearchQuery + "%' )";

                    }


                }
                catch (Exception ex)
                {

                }

                var empQuery = objTagEntities.CalendarSchedule.SqlQuery(sSQL).ToList<CalendarSchedule>();
                contacts = empQuery.OrderByDescending(x => x.Id).ToList();

            }
            catch (Exception ex)
            {

            }

            return contacts;
        }
        public List<CalendarSchedule> GetBySearchAndUserId(string sSearchQuery, string sUserID)
        {
            List<CalendarSchedule> contacts = null;
            try
            {
                string sSQL = string.Empty;
                sSQL = " select * from  CalendarSchedule where Id <> -1  and UserID = '" + sUserID + "' ";

                try
                {
                    if (!string.IsNullOrEmpty(sSearchQuery))
                    {
                        sSQL += " and (UserName like '%" + sSearchQuery + "%' or UserEmail like '%" + sSearchQuery + "%'  or ToUserFirstName like '%" + sSearchQuery + "%'  or ToUserLastName like '%" + sSearchQuery + "%'  or ToUserEmail like '%" + sSearchQuery + "%')";

                    }


                }
                catch (Exception ex)
                {

                }

                var empQuery = objTagEntities.CalendarSchedule.SqlQuery(sSQL).ToList<CalendarSchedule>();
                contacts = empQuery.OrderByDescending(x => x.Id).ToList();

            }
            catch (Exception ex)
            {

            }

            return contacts;
        }

    }
}
