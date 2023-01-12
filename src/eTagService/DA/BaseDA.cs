using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eTagService;
using TagService.BO;


public class BaseDA
    {
        TagEntities objTagEntities = null;
        /// <summary>
        /// isNewNewContext == true, if you need newcontext
        /// isLazyLoadingEnable = true, is you want to load all data e.g. parent + child
        /// </summary>
        /// <param name="isNewContext"></param>
        /// <param name="isLazyLoadingEnable"></param>
        protected BaseDA(bool isNewContext = false, bool isLazyLoadingEnable = true)
        {
            objTagEntities = (isNewContext == false) ? TagEntity.GetEntity() : TagEntity.GetFreshEntity();
            objTagEntities.Configuration.LazyLoadingEnabled = isLazyLoadingEnable;
        }

        protected void Insert(object ob)
        {
            //object entity = ;
        }
    }
