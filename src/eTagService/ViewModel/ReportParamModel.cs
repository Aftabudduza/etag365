using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PropertyService.ViewModel
{
    public class ReportParamModel
    {
        public string OperationName { get; set; }
        public string ReportId { get; set; }
        public string ReportName { get; set; }
        public string ReportFileName { get; set; }
        public string PrintType { get; set; }
        public string FileExtention { get; set; }
        public string createdate { get; set; }
        public string CompanyName { get; set; }

        public string EndDate { get; set; }
        public string Currency { get; set; }
        public string PrintBy { get; set; }

    }
}
