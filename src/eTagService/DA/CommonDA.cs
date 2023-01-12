using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eTagService;
using TagService.BO;

using Microsoft.Practices.EnterpriseLibrary.Data;
using Microsoft.Practices.EnterpriseLibrary.Data.Sql;

namespace TagService.DA
{
   public class CommonDA
    {

        private TagEntities _objTagEntities;

        public CommonDA(bool isLazyLoadingEnable = true)
        {
            _objTagEntities = TagEntity.GetEntity();
            _objTagEntities.Configuration.LazyLoadingEnabled = isLazyLoadingEnable;
        }

        public CommonDA(bool isNewContext, bool isLazyLoadingEnable = true)
        {
            if (isNewContext)
                _objTagEntities = TagEntity.GetFreshEntity();
            else
                _objTagEntities = TagEntity.GetEntity();

            _objTagEntities.Configuration.LazyLoadingEnabled = isLazyLoadingEnable;
        }

        public string MakeAutoGenLocation(string yourPrefix, string objName)
        {
            try
            {
                _objTagEntities = TagEntity.GetFreshEntity();
                var oupParam = new ObjectParameter("NewID", 0) { Value = DBNull.Value };
                _objTagEntities.SP_GetID(objName, "Id", DateTime.Now.Year, null, null, oupParam);
                var sNumber = oupParam.Value.ToString().PadLeft(11, '0');
                var serial = string.Concat(yourPrefix, sNumber);

                return serial;
            }
            catch (Exception ex)
            {
                // ignored
            }

            return null;
        }
        public List<Country> GetCountrlList()
        {
            var lstOfCountry = new List<Country>();
            try
            {
                lstOfCountry = _objTagEntities.Country.ToList();
            }
            catch (Exception ex)
            {


            }
            return lstOfCountry;
        }
        public List<States> GetStateList()
        {
            var lstOfStates = new List<States>();
            try
            {
                lstOfStates = _objTagEntities.States.ToList().Distinct().ToList();
            }
            catch (Exception ex)
            {


            }
            return lstOfStates;
        }
        //public List<Cities> GetCityList()
        //{
        //    var lstOfCities = new List<Cities>();
        //    try
        //    {
        //        lstOfCities = _objTagEntities.Cities.ToList().Distinct().ToList();
        //    }
        //    catch (Exception ex)
        //    {


        //    }
        //    return lstOfCities;
        //}

        public string ExecProcedureWithTable(string StoreProcedure, List<SqlParameter> paramList, string createdBy, string TypeOfContact, string balance, string connectionString,
           out string error, out string Mass)
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
                //paramList.Add(new SqlParameter("@createdBy", createdBy));
                command.Parameters.Add(new SqlParameter("@createdBy", createdBy));
                command.Parameters.Add(new SqlParameter("@TypeOfContact", TypeOfContact));
                command.Parameters.Add(new SqlParameter("@balance", balance));
                //command.Parameters.Add("@createdBy",createdBy, SqlDbType.VarChar, 20);
                //command.Parameters.Add("@TypeOfContact", SqlDbType.VarChar, 3);
                //command.Parameters.Add("@balance", SqlDbType.Int);
                command.Parameters.Add("@Mass", System.Data.SqlDbType.VarChar, 200).Direction = System.Data.ParameterDirection.Output;
                command.Parameters.Add("@error", System.Data.SqlDbType.VarChar, 500).Direction = System.Data.ParameterDirection.Output;

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

                error = "";
                return Mass;

            }

            return Mass;

        }

    }
}
