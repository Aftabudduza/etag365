using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Practices.EnterpriseLibrary.Data;

namespace TagService.DA
{
  public class ADONetDataConnection
    {
        public DataTable GetDataByDataTable(string StoreProcedure, List<SqlParameter> SqlParameterlist, string DataBaseName)
        {
            try
            {
                DataTable dataContain = new DataTable();
                Database db = new Microsoft.Practices.
                                   EnterpriseLibrary.Data.Sql.SqlDatabase(ADODBConnection.GetConnectionStringByDbName(DataBaseName));
                DbCommand dbCommand;
                dbCommand = db.GetStoredProcCommand(StoreProcedure);
                dbCommand.CommandTimeout = 1200;
                dbCommand.Parameters.Clear();
                dbCommand.Parameters.AddRange(SqlParameterlist.ToArray());
                dataContain = db.ExecuteDataSet(dbCommand).Tables[0];
                dbCommand.Parameters.Clear();
                return dataContain;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public DataSet GetDataByDataSet(string StoreProcedure, List<SqlParameter> SqlParameterlist, string DataBaseName)
        {
            try
            {
                DataSet ds = new DataSet();
                Database db = new Microsoft.Practices.
                                   EnterpriseLibrary.Data.Sql.SqlDatabase(ADODBConnection.GetConnectionStringByDbName(DataBaseName));
                DbCommand dbCommand;
                dbCommand = db.GetStoredProcCommand(StoreProcedure);
                dbCommand.Parameters.Clear();
                dbCommand.Parameters.AddRange(SqlParameterlist.ToArray());

                ds = db.ExecuteDataSet(dbCommand);
                dbCommand.Parameters.Clear();
                return ds;

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
