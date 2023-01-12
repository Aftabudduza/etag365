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
    public class MasterDA
    {
        TagEntities objTagEntities = null;
        public MasterDA(bool isLazyLoadingEnable = true)
        {
            objTagEntities = TagEntity.GetEntity();
            objTagEntities.Configuration.LazyLoadingEnabled = isLazyLoadingEnable;
        }

        public MasterDA(bool isNewContext, bool isLazyLoadingEnable = true)
        {
            if (isNewContext)
                objTagEntities = TagEntity.GetFreshEntity();
            else
            {
                objTagEntities = TagEntity.GetEntity();
            }

            objTagEntities.Configuration.LazyLoadingEnabled = isLazyLoadingEnable;
        }

        public Master GetParentbyID(int id)
        {
            Master objMaster = null;
            try
            {             
                var empQuery = from b in objTagEntities.Master
                               where b.Id == id
                               select b;

                objMaster = empQuery.ToList().FirstOrDefault();

                
            }
            catch (Exception ex)
            {
               
            }
            return objMaster;
        }

        public Master GetParentbyUserDefinedID(int userdefinedId)
        {
            Master objMaster = null;
            try
            {
                var empQuery = from b in objTagEntities.Master
                               where b.UserDefinedId == userdefinedId
                               select b;

                objMaster = empQuery.ToList().FirstOrDefault();

                
            }
            catch (Exception ex)
            {
               
            }
            return objMaster;
        }

        public bool Insert(Master objMaster)
        {
            try
            {                
                objTagEntities.Master.Add(objMaster);
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

        public bool Update(Master obj)
        {
            try
            {
                Master existing = objTagEntities.Master.Find(obj.Id);
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
                objTagEntities.Master.Remove(this.GetParentbyID(id));
                objTagEntities.SaveChanges();
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }

     
        public List<Master> GetAllMaster()
        {
            List<Master> listMaster = null;
            try
            {               
                var empQuery = from b in objTagEntities.Master
                               where b.Id > 0
                               select b;

                listMaster = empQuery.OrderBy(x => x.UserDefinedId).ToList();
               
            }
            catch (Exception ex)
            {
               
            }
            return listMaster;
        }
    }
}
