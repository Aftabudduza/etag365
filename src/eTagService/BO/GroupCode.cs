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
    
    public partial class GroupCode
    {
        public int Id { get; set; }
        public string GroupCodeNo { get; set; }
        public string GroupName { get; set; }
        public string GroupDescription { get; set; }
        public string GroupPlan { get; set; }
        public Nullable<decimal> Amount { get; set; }
        public string BillEvery { get; set; }
        public Nullable<bool> IsForever { get; set; }
        public Nullable<System.DateTime> StartDate { get; set; }
        public Nullable<System.DateTime> EndDate { get; set; }
        public Nullable<bool> IsRequiredACHInfo { get; set; }
        public string CreditPhoneNo { get; set; }
        public Nullable<decimal> Rewards { get; set; }
        public string GroupCodeFor { get; set; }
        public string CreatedBy { get; set; }
        public Nullable<System.DateTime> CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public Nullable<System.DateTime> UpdatedDate { get; set; }
        public string DeletedBy { get; set; }
        public Nullable<System.DateTime> DeletedDate { get; set; }
    }
}
