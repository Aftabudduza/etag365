using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eTagService;
using TagService.BO;


namespace TagService.DA
{
    public class ChildDA
    {
        TagEntities objTagEntities = null;
        public ChildDA(bool isLazyLoadingEnable = true)
        {
            objTagEntities = TagEntity.GetEntity();
            objTagEntities.Configuration.LazyLoadingEnabled = isLazyLoadingEnable;
        }

        public ChildDA(bool isNewContext, bool isLazyLoadingEnable = true)
        {
            if (isNewContext)
                objTagEntities = TagEntity.GetFreshEntity();
            else
            {
                objTagEntities = TagEntity.GetEntity();
            }

            objTagEntities.Configuration.LazyLoadingEnabled = isLazyLoadingEnable;
        }

        public Child GetChildbyID(int id)
        {
            Child objChild = null;
            try
            {             
                var empQuery = from b in objTagEntities.Child
                               where b.Id == id
                               select b;

                objChild = empQuery.ToList().FirstOrDefault();

               
            }
            catch (Exception ex)
            {
                
            }

            return objChild;
        }
        public Child GetChildbyCode(string  code)
        {
            Child objChild = null;
            try
            {
                var empQuery = from b in objTagEntities.Child
                               where b.Code == code
                               select b;

                objChild = empQuery.ToList().FirstOrDefault();


            }
            catch (Exception ex)
            {

            }

            return objChild;
        }
        public bool Insert(Child objChild)
        {
            try
            {                
                objTagEntities.Child.Add(objChild);
                objTagEntities.SaveChanges();
                return true;
            }
            catch (Exception ex)
            {
               
            }

            return false;
        }
        public bool Update(Child obj)
        {
            try
            {

                Child existing = objTagEntities.Child.Find(obj.Id);
                existing.Code = obj.Code;
                existing.Description = obj.Description;
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
                objTagEntities.Child.Remove(this.GetChildbyID(id));
                objTagEntities.SaveChanges();
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }
      
        public List<Child> GetAllChild()
        {
            List<Child> listChilds = null;
            try
            {               
                var empQuery = from b in objTagEntities.Child
                               where b.Id > 0
                               select b;

                listChilds = empQuery.ToList();               
            }
            catch (Exception ex)
            {
                
            }

            return listChilds;
        }      
        public List<Child> GetChildByParentID(int userDefinedID)
        {
            List<Child> listChilds = null;
            try
            {                
                var empQuery = from b in objTagEntities.Child
                               where b.UserDefinedId == userDefinedID
                               select b;

                listChilds = empQuery.OrderBy(x=>x.Description).ToList();
               
            }
            catch (Exception ex)
            {
               
            }
            return listChilds;
        }
        public List<Child> GetChildByUserDefinedID(int userDefinedID)
        {
            List<Child> listChilds = null;
            try
            {               
                var empQuery = from b in objTagEntities.Child
                               where b.UserDefinedId == userDefinedID
                               select b;

                listChilds = empQuery.OrderBy(x => x.Description).ToList();
                
            }
            catch (Exception ex)
            {
                
            }
            return listChilds;
        }

        public List<Child> GetChildByUserDefinedIDAndUserID(int userDefinedID, int userId)
        {
            List<Child> listChilds = null;
            try
            {
                var empQuery = from b in objTagEntities.Child
                               where b.UserDefinedId == userDefinedID && (b.CreatedBy == userId || b.CreatedBy == null)
                               select b;

                listChilds = empQuery.OrderBy(x => x.Description).ToList();

            }
            catch (Exception ex)
            {

            }
            return listChilds;
        }

        public Child GetChildByParent(int userDefinedID)
        {
            Child Child = null;
            try
            {                
                var empQuery = from b in objTagEntities.Child
                               where b.UserDefinedId == userDefinedID
                               select b;

                Child = empQuery.OrderBy(x => x.Description).FirstOrDefault();
               
            }
            catch (Exception ex)
            {
               
            }

            return Child;
        }

    }
}
