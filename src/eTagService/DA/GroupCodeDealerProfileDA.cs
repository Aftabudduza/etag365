using eTagService;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using TagService.BO;

namespace TagService.DA
{
    public class GroupCodeDealerProfileDA
    {
        TagEntities objTagEntities = null;
        public GroupCodeDealerProfileDA(bool isLazyLoadingEnable = true)
        {
            objTagEntities = TagEntity.GetEntity();
            objTagEntities.Configuration.LazyLoadingEnabled = isLazyLoadingEnable;
        }

        public GroupCodeDealerProfileDA(bool isNewContext, bool isLazyLoadingEnable = true)
        {
            if (isNewContext)
                objTagEntities = TagEntity.GetFreshEntity();
            else
            {
                objTagEntities = TagEntity.GetEntity();
            }

            objTagEntities.Configuration.LazyLoadingEnabled = isLazyLoadingEnable;
        }

      

        public List<GroupCode> GetListOfGroupCode(string Dealer)
        {
            List<GroupCode> obj = new List<GroupCode>();
            try
            {
                obj = objTagEntities.GroupCode.Where(x=>x.GroupCodeFor == Dealer && x.DeletedBy==null).ToList();
            }
            catch (Exception ex)
            {


            }


            return obj;
        }
        public List<usp_getPhoneNoByAutoComplete_Result> GetListOfDealerUserPhoneNo(string autotext,string Dealer)
        {
            List<usp_getPhoneNoByAutoComplete_Result> objPhone = new List<usp_getPhoneNoByAutoComplete_Result>();
            try
            {
                objPhone = objTagEntities.usp_getPhoneNoByAutoComplete(autotext,Dealer).ToList();
            }
            catch (Exception ex)
            {


            }
            return objPhone;
        }

        public List<usp_GetGroupCodeByUserType_Result> GetGroupCodeByUserType(string GroupCodeFor, string PhoneNo)
        {
            List<usp_GetGroupCodeByUserType_Result> objGroupCode = new List<usp_GetGroupCodeByUserType_Result>();
            try
            {
                objGroupCode = objTagEntities.usp_GetGroupCodeByUserType(GroupCodeFor, PhoneNo).ToList();
            }
            catch (Exception ex)
            {


            }


            return objGroupCode;
        }

        public GroupCode GetRewardByGroupCode(string code, string Plan)
        {
            GroupCode objGroupCode = null;
            try
            {
                string sSQL = string.Empty;
                sSQL = " select * from GroupCode where deletedBy is null and (((CONVERT(VARCHAR(26), EndDate, 23) >= CONVERT(VARCHAR(26), getdate(), 23) and IsForever <> 1) or IsForever = 1))  ";

                try
                {
                    if (!string.IsNullOrEmpty(Plan))
                    {
                        sSQL += " and GroupPlan = '" + Plan + "'";

                    }
                    if (!string.IsNullOrEmpty(code))
                    {
                        sSQL += " and GroupCodeNo = '" + code + "'";

                    }
                }
                catch (Exception ex)
                {

                }

                var empQuery = objTagEntities.GroupCode.SqlQuery(sSQL).ToList<GroupCode>();
                objGroupCode = empQuery.ToList().FirstOrDefault();

            }
            catch (Exception ex)
            {

            }

            return objGroupCode;
        }

        public GroupCode GetRewardByGroupCodeType(string code, string Plan, string BillingType)
        {
            GroupCode objGroupCode = null;
            try
            {
                string sSQL = string.Empty;
                sSQL = " select * from GroupCode where deletedBy is null and (((CONVERT(VARCHAR(26), EndDate, 23) >= CONVERT(VARCHAR(26), getdate(), 23) and IsForever <> 1) or IsForever = 1))  ";

                try
                {
                    if (!string.IsNullOrEmpty(Plan))
                    {
                        sSQL += " and GroupPlan = '" + Plan + "'";

                    }
                    if (!string.IsNullOrEmpty(code))
                    {
                        sSQL += " and GroupCodeNo = '" + code + "'";

                    }
                    if (!string.IsNullOrEmpty(BillingType))
                    {
                        sSQL += " and BillEvery = '" + BillingType + "'";
                    }
                }
                catch (Exception ex)
                {

                }

                var empQuery = objTagEntities.GroupCode.SqlQuery(sSQL).ToList<GroupCode>();
                objGroupCode = empQuery.ToList().FirstOrDefault();

            }
            catch (Exception ex)
            {

            }

            return objGroupCode;
        }

        public GroupCode getGroupCodeInfo(int Id)
        {
            GroupCode d = new GroupCode();
            try
            {
                d = objTagEntities.GroupCode.Where(x => x.Id == Id).FirstOrDefault();
            }
            catch (Exception ex)
            {


            }
            
            return d;
        }
        public GroupCode DeleteGroupCodeInfo(int Id,string PhoneNo)
        {
            GroupCode d = new GroupCode();          
            try
            {
                // get the object from database to modify
                d = objTagEntities.GroupCode.Find(Id);
                d.DeletedBy = PhoneNo;
                d.DeletedDate = DateTime.Now;  
                
                var existing = objTagEntities.GroupCode.Find(Id);
                ((IObjectContextAdapter)objTagEntities).ObjectContext.Detach(existing);
                objTagEntities.Entry(d).State = EntityState.Modified;
                objTagEntities.SaveChanges();
            }
            catch (Exception ex)
            {


            }

            return d;
        }    
        
        
        public bool Save(GroupCode Obj, string PhoneNo)
        {

            GroupCode objGC = new GroupCode();
            bool isSave = false;
            try
            {
                var existing = objTagEntities.GroupCode.Find(Obj.Id);
                if (existing != null)
                {
                    Obj.UpdatedBy = HttpContext.Current.Session["Phone"].ToString();
                    Obj.UpdatedDate = DateTime.Now;
                    isSave = updateDealerAndUserProfile(Obj);
                }
                else
                {
                    Obj.CreatedBy = HttpContext.Current.Session["Phone"].ToString();
                    Obj.CreatedDate = DateTime.Now;
                    isSave = SaveDealerAndUserProfile(Obj);
                }
                return isSave;


            }
            catch (Exception ex)
            {


            }


            return isSave;
        }
        public bool SaveDealerAndUserProfile(GroupCode Obj)
        {
            GroupCode objGCInfo = new GroupCode();
            try
            {
                
                

                objGCInfo = Obj;
                objTagEntities.GroupCode.Add(Obj);
                objTagEntities.SaveChanges();
                
                objTagEntities = TagEntity.GetFreshEntity();
                
                return true;
            }
            catch (Exception ex)
            {


            }
            return false;
        }
        public bool updateDealerAndUserProfile(GroupCode Obj)
        {
            GroupCode objGroupCode = new GroupCode();
            try
            {
                var existing = objTagEntities.GroupCode.Find(Obj.Id);
                ((IObjectContextAdapter)objTagEntities).ObjectContext.Detach(existing);                
                objTagEntities.Entry(Obj).State = EntityState.Modified;                
                objTagEntities.SaveChanges();
                
                return true;
            }
            catch (Exception ex)
            {


            }


            return false;
        }
        
    }
}
