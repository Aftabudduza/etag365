using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TagService.DA
{
   public class ADODBConnection
    {
        protected static string UserId = Convert.ToString(System.Configuration.ConfigurationSettings.AppSettings["UserId"].ToString());
        protected static string Password = Convert.ToString(System.Configuration.ConfigurationSettings.AppSettings["Password"].ToString());
        //protected const string DataSource = @"DESKTOP-Q0SV9IB";
        protected static string DataSource = Convert.ToString(System.Configuration.ConfigurationSettings.AppSettings["Datasource"].ToString());
        //DESKTOP-NVVS1HD
        protected static string GenerateString(string DbName)
        {
            string con = "";
            con = @"data source=" + DataSource + ";Initial Catalog=" + DbName + ";Integrated Security=false; User Id=" + UserId + "; password=" + Password + ";";
            return con;
        }
        public static string GetConnectionStringByDbName(string DbName)
        {
            return GenerateString(DbName);
        }
    }
}
