using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;
using Microsoft.Practices.EnterpriseLibrary.Data;

namespace PropertyService
{
   public class CommonDA
    {
        public string ExecProcedureWithTable(string StoreProcedure, List<SqlParameter> paramList, string connectionString,
           out string error,out string Mass)
        {
            System.Data.SqlClient.SqlCommand command = new System.Data.SqlClient.SqlCommand();
            Mass = String.Empty;
            try
            {
               
                error = String.Empty;
                Database db = new Microsoft.Practices.
                    EnterpriseLibrary.Data.Sql.SqlDatabase(connectionString);
                // DbCommand command;
                System.Data.SqlClient.SqlParameter parameter;

                command.CommandText = StoreProcedure;
                command.CommandType = System.Data.CommandType.StoredProcedure;

                command.Parameters.AddRange(paramList.ToArray());
                for (int i = 0; i < paramList.Count; i++)
                {
                    paramList[i].SqlDbType = System.Data.SqlDbType.Structured;
                }
                command.Parameters.Add("@Mass", SqlDbType.VarChar, 200).Direction = ParameterDirection.Output;
                command.Parameters.Add("@error", SqlDbType.VarChar,500).Direction = ParameterDirection.Output;
                
                if (db.ExecuteNonQuery(command) > 0)
                {
                    // pk = int.Parse(command.Parameters[autoId].Value.ToString());
                    Mass = command.Parameters["@Mass"].Value.ToString();
                    error = command.Parameters["@error"].Value.ToString();
                    command.Parameters.Clear();
                    //return true;
                }
                else
                {
                    Mass = command.Parameters["@Mass"].Value.ToString();
                    error = command.Parameters["@error"].Value.ToString();
                    command.Parameters.Clear();
                    //return false;
                }
            }
            catch (Exception ex)
            {
                //string log = AddErrorLog(StoreProcedure, SqlParameterlist, ex.Message, User);
                //try
                //{
                //    int logNum = Int32.Parse(log);
                //    error = "Error occured, error log no=" + log;
                //}
                //catch (Exception e)
                //{
                //    error = log;
                //}
                error = "";
                return Mass;
                //return false;
            }

            return Mass;

        }
    }
}
