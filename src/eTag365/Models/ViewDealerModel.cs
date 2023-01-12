using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using TagService.BO;

namespace eTag365.Models
{
    public class ViewDealerModel
    {
        public string UserType { get; set; }
        public List<usp_GetDelarInfoByPhoneNo_Result> listOfDealer { get; set; }
        public string Serial { get; set; }
        public Dealer_SalesPartner Dealer_SalesPartner { get; set; }

        public string Password { get; set; }
        public int id { get; set; }
        public string Month { get; set; }
        public int Year { get; set; }
        public bool IsPaid { get; set; }
        
    }
}