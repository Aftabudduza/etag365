//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace TagService.BO
{
    using System;
    using System.Collections.Generic;
    
    public partial class PaymentInformation
    {
        public int Id { get; set; }
        public string UserId { get; set; }
        public string AccountName { get; set; }
        public string Address { get; set; }
        public string Address1 { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string Zip { get; set; }
        public string CardNumber { get; set; }
        public string CVS { get; set; }
        public string Month { get; set; }
        public string Year { get; set; }
        public string LastFourDigitCard { get; set; }
        public Nullable<bool> IsCheckingAccount { get; set; }
        public string RoutingNo { get; set; }
        public string AccountNo { get; set; }
        public string CheckNo { get; set; }
        public Nullable<bool> IsRecurring { get; set; }
        public Nullable<bool> IsAgree { get; set; }
    }
}