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
    public class CalendarEntryDA
    {
        TagEntities objTagEntities = null;
        public CalendarEntryDA(bool isLazyLoadingEnable = true)
        {
            objTagEntities = TagEntity.GetEntity();
            objTagEntities.Configuration.LazyLoadingEnabled = isLazyLoadingEnable;
        }
        public CalendarEntryDA(bool isNewContext, bool isLazyLoadingEnable = true)
        {
            if (isNewContext)
                objTagEntities = TagEntity.GetFreshEntity();
            else
            {
                objTagEntities = TagEntity.GetEntity();
            }

            objTagEntities.Configuration.LazyLoadingEnabled = isLazyLoadingEnable;
        }
        public CalendarEntry GetbyID(int id)
        {
            CalendarEntry objCalendarEntry = null;
            try
            {             
                var empQuery = from b in objTagEntities.CalendarEntry
                               where b.Id == id
                               select b;

                objCalendarEntry = empQuery.ToList().FirstOrDefault();

                
            }
            catch (Exception ex)
            {
               
            }
            return objCalendarEntry;
        }
        public CalendarEntry GetbyUserID(string userid)
        {
            CalendarEntry objCalendarEntry = null;
            try
            {
                var empQuery = from b in objTagEntities.CalendarEntry
                               where b.UserId == userid
                               select b;

                objCalendarEntry = empQuery.ToList().FirstOrDefault();


            }
            catch (Exception ex)
            {

            }
            return objCalendarEntry;
        }
        public bool Insert(CalendarEntry objCalendarEntry)
        {
            try
            {                
                objTagEntities.CalendarEntry.Add(objCalendarEntry);
                objTagEntities.SaveChanges();
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }      
        public bool Update(CalendarEntry obj)
        {
            try
            {
                CalendarEntry existing = objTagEntities.CalendarEntry.Find(obj.Id);
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
                objTagEntities.CalendarEntry.Remove(this.GetbyID(id));
                objTagEntities.SaveChanges();
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }       
        public List<CalendarEntry> GetAllCalendarEntry()
        {
            List<CalendarEntry> listCalendarEntry = null;
            try
            {               
                var empQuery = from b in objTagEntities.CalendarEntry
                               where b.Id > 0
                               select b;

                listCalendarEntry = empQuery.OrderByDescending(x => x.Id).ToList();
               
            }
            catch (Exception ex)
            {
               
            }
            return listCalendarEntry;
        }
        public List<CalendarEntry> GetByUser(string serial)
        {
            List<CalendarEntry> listCalendarEntry = null;
            try
            {
                var empQuery = from b in objTagEntities.CalendarEntry
                               where b.UserId == serial
                               select b;

                listCalendarEntry = empQuery.OrderByDescending(x => x.Id).ToList();

            }
            catch (Exception ex)
            {

            }
            return listCalendarEntry;
        }
        public List<CalendarEntry> GetBySearch(string sSearchQuery)
        {
            List<CalendarEntry> contacts = null;
            try
            {
                string sSQL = string.Empty;
                sSQL = " select * from  CalendarEntry where Id <> -1 ";

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

                var empQuery = objTagEntities.CalendarEntry.SqlQuery(sSQL).ToList<CalendarEntry>();
                contacts = empQuery.OrderByDescending(x => x.Id).ToList();

            }
            catch (Exception ex)
            {

            }

            return contacts;
        }
        public List<CalendarEntry> GetBySearchAndUserId(string sSearchQuery, string sUserID)
        {
            List<CalendarEntry> contacts = null;
            try
            {
                string sSQL = string.Empty;
                sSQL = " select * from  CalendarEntry where Id <> -1  and UserID = '" + sUserID + "' ";

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

                var empQuery = objTagEntities.CalendarEntry.SqlQuery(sSQL).ToList<CalendarEntry>();
                contacts = empQuery.OrderByDescending(x => x.Id).ToList();

            }
            catch (Exception ex)
            {

            }

            return contacts;
        }

    }
}
