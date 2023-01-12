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
    
    public partial class CalendarSchedule
    {
        public long Id { get; set; }
        public Nullable<long> MeetingId { get; set; }
        public string UserName { get; set; }
        public string UserEmail { get; set; }
        public string UserId { get; set; }
        public string ToUserFirstName { get; set; }
        public string ToUserLastName { get; set; }
        public string ToUserEmail { get; set; }
        public string ToUserPhone { get; set; }
        public string ToUserCompany { get; set; }
        public string Notes { get; set; }
        public string Timezone { get; set; }
        public Nullable<int> TimeZoneDifference { get; set; }
        public Nullable<System.DateTime> MeetingDate { get; set; }
        public Nullable<System.DateTime> GMTTimeStart { get; set; }
        public string MeetingStartTime { get; set; }
        public Nullable<System.DateTime> GMTTimeEnd { get; set; }
        public string MeetingEndTime { get; set; }
        public Nullable<int> Duration { get; set; }
        public Nullable<byte> IsBooked { get; set; }
        public Nullable<byte> IsSentEmail { get; set; }
        public string MeetingStartTimeShow { get; set; }
    }
}
