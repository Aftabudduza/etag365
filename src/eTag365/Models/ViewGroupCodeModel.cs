using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using TagService.BO;

namespace eTag365.Models
{
    public class ViewGroupCodeModel
    {
        
        public string autocompleteText { get; set; }
        public string GroupCodeFor { get; set; }

        public GroupCode GroupCode { get; set; }


    }
}