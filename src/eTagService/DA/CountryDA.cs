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
    public class CountryDA
    {
        TagEntities objTagEntities = null;
        public CountryDA(bool isLazyLoadingEnable = true)
        {
            objTagEntities = TagEntity.GetEntity();
            objTagEntities.Configuration.LazyLoadingEnabled = isLazyLoadingEnable;
        }
        public CountryDA(bool isNewContext, bool isLazyLoadingEnable = true)
        {
            if (isNewContext)
                objTagEntities = TagEntity.GetFreshEntity();
            else
            {
                objTagEntities = TagEntity.GetEntity();
            }

            objTagEntities.Configuration.LazyLoadingEnabled = isLazyLoadingEnable;
        }
        public Country GetByCode(string sName)
        {
            Country objRefCountries = null;
            try
            {             
                var empQuery = from b in objTagEntities.Country
                               where b.name == sName
                               select b;

                objRefCountries = empQuery.ToList().FirstOrDefault();

                
            }
            catch (Exception ex)
            {
               
            }
            return objRefCountries;
        }
        public Country GetByShortCode(string sCode)
        {
            Country objRefCountries = null;
            try
            {
                var empQuery = from b in objTagEntities.Country
                               where b.iso == sCode
                               select b;

                objRefCountries = empQuery.ToList().FirstOrDefault();


            }
            catch (Exception ex)
            {

            }
            return objRefCountries;
        }
        public bool Insert(Country objRefCountries)
        {
            try
            {                
                objTagEntities.Country.Add(objRefCountries);
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
        public bool Update(Country obj)
        {
            try
            {
                Country existing = objTagEntities.Country.Find(obj.iso);
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
                objTagEntities.Country.Remove(this.GetByCode(code));
                objTagEntities.SaveChanges();
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }
        public List<Country> GetAllRefCountries()
        {
            List<Country> listRefCountries = null;
            try
            {               
                var empQuery = from b in objTagEntities.Country
                               select b;

                listRefCountries = empQuery.OrderBy(x => x.name).ToList();
               
            }
            catch (Exception ex)
            {
               
            }
            return listRefCountries;
        }

    }
}
