using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TagService.ViewModel
{
   public class Customer
    {       
        public string FirstName { get; set; }
        public string MiddleName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string Address { get; set; }
        public string Address1 { get; set; }
        public string Region { get; set; }
        public string Country { get; set; }
        public string State { get; set; }
        public string City { get; set; }
        public string Zip { get; set; }
        public string Phone { get; set; }
        public string WorkPhone { get; set; }
        public string WorkPhoneExt { get; set; }
        public string Fax { get; set; }
        public Nullable<bool> IsActive { get; set; }
        public string RefPhone { get; set; }
        public string Title { get; set; }
        public string CreatedBy { get; set; }
        public Nullable<System.DateTime> CreatedDate { get; set; }
        public string TypeOfContact { get; set; }
        public string CompanyName  { get; set; }
        public string Category { get; set; }
        public Nullable<Int16> IsEmailFlow { get; set; }
        public string Website { get; set; }

    }
}
