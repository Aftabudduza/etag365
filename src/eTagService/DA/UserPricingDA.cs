using System;
using eTagService;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TagService.BO;

namespace TagService.DA
{
    public class UserPricingDA
    {
        TagEntities objTagEntities = null;
        public UserPricingDA(bool isLazyLoadingEnable = true)
        {
            objTagEntities = TagEntity.GetEntity();
            objTagEntities.Configuration.LazyLoadingEnabled = isLazyLoadingEnable;
        }

        public UserPricingDA(bool isNewContext, bool isLazyLoadingEnable = true)
        {
            if (isNewContext)
                objTagEntities = TagEntity.GetFreshEntity();
            else
            {
                objTagEntities = TagEntity.GetEntity();
            }

            objTagEntities.Configuration.LazyLoadingEnabled = isLazyLoadingEnable;
        }
        public List<UserPricing> GetListOfUserPricing()
        {

            List<UserPricing> objUserPricing = new List<UserPricing>();
            objUserPricing = objTagEntities.UserPricing.ToList();

            return objUserPricing;
        }


    }
}
