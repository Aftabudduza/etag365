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
    
    public partial class Version
    {
        public int Id { get; set; }
        public string andVerCode { get; set; }
        public string andVerLabel { get; set; }
        public Nullable<bool> andMustUpdate { get; set; }
        public string andVerNote { get; set; }
        public string andLink { get; set; }
        public string iOsVerCode { get; set; }
        public string iOsVerLabel { get; set; }
        public Nullable<bool> iOsMustUpdate { get; set; }
        public string iOsLink { get; set; }
        public string iOsVerNote { get; set; }
        public Nullable<System.DateTime> CreatedDate { get; set; }
    }
}