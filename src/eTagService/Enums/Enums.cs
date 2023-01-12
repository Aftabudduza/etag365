using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eTagService.Enums
{
    public enum EnumUserType
    {
        [Description("Admin")]
        Admin = 1,
        [Description("Normal")]
        Normal = 2,
        [Description("Dealer")]
        Dealer = 3
    }

    public enum EnumOp
    {
        Equals,
        GreaterThan,
        LessThan,
        GreaterThanOrEqual,
        LessThanOrEqual,
        Contains,
        StartsWith,
        EndsWith
    }

    public enum EnumBasicData
    {
        //[Description("Country")]
        //Country = 1,
        //[Description("Currency")]
        //Currency = 2,
        //[Description("State")]
        //State = 3,
        [Description("Contact Type")]
        ContactType = 4,
        //[Description("No Order Reason")]
        //NoOrderReason = 5,
        //[Description("Month")]
        //Month = 6,       
        //[Description("Ledger Code")]
        //LedgerCode = 7,
        //[Description("PaymentMode")]
        //PaymentMode = 8,
        [Description("Category")]
        Category = 9
    }
    public enum EnumGlobalData
    {
        [Description("Contact Type")]
        ContactType = 4,
        [Description("Ledger Code")]
        Ledger = 7,
        [Description("Payment Mode")]
        Payment = 8
    }

    public enum ItemStaus : short
    {
        NoFilter = 0,
        Active = 1,
        Inactive = 2
    }

}
