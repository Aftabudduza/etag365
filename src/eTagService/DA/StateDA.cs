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
    public class StateDA
    {
        TagEntities objTagEntities = null;
        public StateDA(bool isLazyLoadingEnable = true)
        {
            objTagEntities = TagEntity.GetEntity();
            objTagEntities.Configuration.LazyLoadingEnabled = isLazyLoadingEnable;
        }
        public StateDA(bool isNewContext, bool isLazyLoadingEnable = true)
        {
            if (isNewContext)
                objTagEntities = TagEntity.GetFreshEntity();
            else
            {
                objTagEntities = TagEntity.GetEntity();
            }

            objTagEntities.Configuration.LazyLoadingEnabled = isLazyLoadingEnable;
        }
        public States GetByCode(string sCode)
        {
            States objRefStates = null;
            try
            {             
                var empQuery = from b in objTagEntities.States
                               where b.STATE == sCode
                               select b;

                objRefStates = empQuery.ToList().FirstOrDefault();

                
            }
            catch (Exception ex)
            {
               
            }
            return objRefStates;
        }     
        public bool Insert(States objRefStates)
        {
            try
            {                
                objTagEntities.States.Add(objRefStates);
                objTagEntities.SaveChanges();
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }
        public bool InsertChild(Child objChild)
        {
            try
            {
               
                objTagEntities.Child.Add(objChild);
                objTagEntities.SaveChanges();
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }
        public bool Update(States obj)
        {
            try
            {
                States existing = objTagEntities.States.Find(obj.STATE);
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
        public bool DeleteByID(string code)
        {
            try
            {
                objTagEntities.States.Remove(this.GetByCode(code));
                objTagEntities.SaveChanges();
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }
        public List<States> GetAllRefStates()
        {
            List<States> listRefStates = null;
            try
            {               
                var empQuery = from b in objTagEntities.States
                               select b;

                listRefStates = empQuery.OrderBy(x => x.STATENAME).ToList();
               
            }
            catch (Exception ex)
            {
               
            }
            return listRefStates;
        }
    }
}
