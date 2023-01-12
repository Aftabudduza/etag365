using eTag365.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using TagService.BO;
using TagService.DA;

namespace eTag365.Pages.Settings
{
    public partial class CommonData : System.Web.UI.Page
    {
        //private static readonly CommonDA da = new CommonDA();
        protected void Page_Load(object sender, EventArgs e)
        {                    
        }
        [WebMethod]
        public static string GetState()
        {
            var lstOfComboData = new List<ComboData>();
            CommonDA da = new CommonDA();
            var lstOfStates = da.GetStateList();
            foreach (States aStates in lstOfStates)
            {
                ComboData c = new ComboData();
                c.Data = aStates.STATENAME;
                c.Id2 = aStates.STATE;
                lstOfComboData.Add(c);

            }
            var jsonSerialiser = new JavaScriptSerializer();
            var json = jsonSerialiser.Serialize(lstOfComboData);
            return json;
        }
    }
}