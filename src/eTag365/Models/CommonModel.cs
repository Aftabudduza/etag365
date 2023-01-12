using System.Collections.Generic;

namespace eTag365.Models
{
    public class CommonModel
    {

    }

    public class Feature
    {
        public string id { get; set; }
    }

    public class FeatureItem
    {
        public List<Feature> Feature { get; set; }
    }

    public class ComboData
    {
        public int Id { get; set; }
        public string Data { get; set; }
        public int SelectedValue { get; set; }
        public string Id2 { get; set; }
        public string Id3 { get; set; }        
        public string SelectedField { get; set; }
    }

    public class MessageSearch
    {
        public string MonthName { get; set; }
        public string RequestType { get; set; }
    }
    public class ExportCSVOrXML
    {
        public int count { get; set; }
    }
    public class Search
    {
        public string StartDate { get; set; }
        public string EndDate { get; set; }
    }
}