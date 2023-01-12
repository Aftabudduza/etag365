using eTagService;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.UI.WebControls.Expressions;
using TagService.BO;

namespace TagService.DA
{
   public class MyReferralViewDA
    {
        TagEntities objTagEntities = null;
        public MyReferralViewDA(bool isLazyLoadingEnable = true)
        {
            objTagEntities = TagEntity.GetEntity();
            objTagEntities.Configuration.LazyLoadingEnabled = isLazyLoadingEnable;
        }

        public MyReferralViewDA(bool isNewContext, bool isLazyLoadingEnable = true)
        {
            if (isNewContext)
                objTagEntities = TagEntity.GetFreshEntity();
            else
            {
                objTagEntities = TagEntity.GetEntity();
            }

            objTagEntities.Configuration.LazyLoadingEnabled = isLazyLoadingEnable;
        }

        public string getTotalEarn(string PhoneNo)
        {
            var amount = "";
            string sSQL = string.Empty;
            double nOwed = 0, nPaid = 0, nBalance = 0, nTotal = 0;
            List<ReferralAccount> objReferralAccounts = null;
            try
            {
                sSQL = " select * from  ReferralAccount where GetterPhone = '" + PhoneNo + "'";

                objReferralAccounts = objTagEntities.ReferralAccount.SqlQuery(sSQL).ToList<ReferralAccount>();

                
                if(objReferralAccounts != null && objReferralAccounts.Count > 0)
                {
                    foreach(ReferralAccount obj in objReferralAccounts)
                    {
                        nOwed = (obj.YTD_CommissionOwed == null || obj.YTD_CommissionOwed == "") ? 0 : Convert.ToDouble(obj.YTD_CommissionOwed);
                        nPaid = (obj.YTD_CommissionPaid == null || obj.YTD_CommissionPaid == "") ? 0 : Convert.ToDouble(obj.YTD_CommissionPaid);
                       
                        nBalance = nOwed - nPaid;
                        if (nBalance > 0)
                        {
                            nTotal += nBalance;
                        }
                    }

                  //  nBalance = nOwed - nPaid;
                    if (nTotal > 0)
                    {
                        amount = nTotal.ToString();
                    }
                }

            }
            catch (Exception ex)
            {

            }
            //try
            //{
            //    var re = objTagEntities.ReferralAccount.Where(x => x.GetterPhone == PhoneNo).FirstOrDefault();
            //    amount = re.YTD_CommissionOwed == null ? "" : re.YTD_CommissionOwed;
            //}
            //catch (Exception ex)
            //{

                
            //}
           
            return amount;
        }
        public List<usp_GetCommissionAmount_All_DateWise_Result> getAllCommissionDetails(string StartDate, string EndDate, string PhoneNo, string CommissionFor)
        {
            List<usp_GetCommissionAmount_All_DateWise_Result> res = new List<usp_GetCommissionAmount_All_DateWise_Result>();
            try
            {
                res = objTagEntities.usp_GetCommissionAmount_All_DateWise(StartDate, EndDate, PhoneNo, CommissionFor).ToList();
            }
            catch (Exception ex)
            {

                
            }

            return res;
        }

        
    }
}
