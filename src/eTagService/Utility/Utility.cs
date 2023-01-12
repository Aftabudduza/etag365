using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Reflection;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

/// <summary>
/// Summary description for Utility
/// </summary>
public class Utility
{
    //private volatile static TagEntities singleTonObject;

    private static SqlConnection conn = null;
    public static string lastError = "";
    public static string Server = "";
    public static string Database = "";
    public static string Username = "";
    public static string Password = "";
    public static string ModelName = "";
    public static string LoginUser = "";
    public Utility()
	{
		//
		// TODO: Add constructor logic here
		//
	}
    public static IDictionary<int, string> GetAll<TEnum>() where TEnum : struct
    {
        var enumerationType = typeof(TEnum);
        if (!enumerationType.IsEnum)
            throw new ArgumentException("Enumeration type is expected.");

        Array enumArry = Enum.GetValues(enumerationType);
        var dictionary = new Dictionary<int, string>();
        foreach (int value in enumArry)
        {
            string enumDescription = "";
            object enumObj = Enum.Parse(enumerationType, value.ToString());

            string description = GetDescription((Enum)enumObj);
            if (description != null)
                enumDescription = description;
            else
                enumDescription = Enum.GetName(enumerationType, value);
            dictionary.Add(value, enumDescription);
        }
     
        return dictionary;
    }
    public static string GetDescription(Enum value)
    {
        Type type = value.GetType();
        string name = Enum.GetName(type, value);
        if (name != null)
        {
            FieldInfo field = type.GetField(name);
            if (field != null)
            {
                DescriptionAttribute attr =
                       Attribute.GetCustomAttribute(field,
                         typeof(DescriptionAttribute)) as DescriptionAttribute;
                if (attr != null)
                {
                    return attr.Description;
                }
            }
        }
        return null;
    }
    public static string GetMD5Hash(string password)
    {
        UTF8Encoding encoder = new UTF8Encoding();
        byte[] hashedpwd;
        MD5CryptoServiceProvider MD5Hasher = new MD5CryptoServiceProvider();
        hashedpwd = MD5Hasher.ComputeHash(encoder.GetBytes(password));


        string hashAsString;
        hashAsString = HttpUtility.UrlEncode(Convert.ToBase64String(hashedpwd));
        return hashAsString;
    }
    public static void CopyTo( object S, object T)
    {
        foreach (var pS in S.GetType().GetProperties())
        {
            foreach (var pT in T.GetType().GetProperties())
            {
                if (pT.Name != pS.Name) continue;
                (pT.GetSetMethod()).Invoke(T, new object[] { pS.GetGetMethod().Invoke(S, null) });
            }
        };
    }
    public static string base64Encode(string sData)
    {
        try
        {
            byte[] encData_byte = new byte[sData.Length];
            encData_byte = System.Text.Encoding.UTF8.GetBytes(sData);
            string encodedData = Convert.ToBase64String(encData_byte);
            return (encodedData);
        }
        catch (Exception ex)
        {
            throw (new Exception("Error in base64Encode" + ex.Message));
        }
    }
    public static string base64Decode(string sData)
    {
        try
        {
            System.Text.UTF8Encoding encoder = new System.Text.UTF8Encoding();
            System.Text.Decoder utf8Decode = encoder.GetDecoder();
            byte[] todecode_byte = Convert.FromBase64String(sData);
            int charCount = utf8Decode.GetCharCount(todecode_byte, 0, todecode_byte.Length);
            char[] decoded_char = new char[charCount];
            utf8Decode.GetChars(todecode_byte, 0, todecode_byte.Length, decoded_char, 0);
            string result = new String(decoded_char);
            return result;
        }
        catch (Exception ex)
        {
            throw (new Exception("Error in base64Decode" + ex.Message));
        }
       
    }
    public static string WebUrl
    {
        get
        {
            try
            {
                return Convert.ToString(System.Configuration.ConfigurationSettings.AppSettings["WebUrl"].ToString());
            }
            catch (Exception ex)
            {

            }
            return "";
        }
    }
    public static string CONNECTIONSTRING
    {
        get
        {
            try
            {
                return Convert.ToString(System.Configuration.ConfigurationSettings.AppSettings["ConnectionString"].ToString());
            }
            catch (Exception ex)
            {

            }
            return "";
        }
    }        
    private static void connect()
    {
        if (CONNECTIONSTRING == "")
        {
            if (conn == null) throw new Exception("Database not connected");
        }
        else
        {
            conn = new SqlConnection(CONNECTIONSTRING);
            conn.Open();
        }
    }
    private static void disconnect()
    {
        if (!CONNECTIONSTRING.Equals("") && conn != null)
        {
            try
            {
                conn.Close();
                conn.Dispose();
                conn = null;
            }
            catch (Exception ex) { }
        }
    }    
    public static bool BackupDatabase(string filepath, string dbName)
    {
        SqlCommand cmd;
        string sql = " BACKUP DATABASE " + dbName + " TO DISK= '" + filepath + "'";
        try
        {
            connect();
            cmd = new SqlCommand(sql, conn);
            cmd.ExecuteNonQuery();
            disconnect();
            return true;
        }
        catch (SqlException ex)
        {
            lastError = translateException(ex);
            return false;
        }
        catch (Exception ex)
        {          
            lastError = ex.Message;
            return false;
        }

       
    }
    public static bool RunCMDMain(string sql)
    {
        SqlCommand cmd;

        try
        {
            connect();
            cmd = new SqlCommand(sql, conn);
            cmd.ExecuteNonQuery();
            disconnect();
            return true;
        }
        catch (SqlException ex)
        {
            lastError = translateException(ex);
            return false;
        }
        catch (Exception ex)
        {
            lastError = ex.Message;
            return false;
        }
    }
    public static Int32 RunInsertCMD(string sql)
    {
        SqlCommand cmd;
        int data = 0;
        try
        {
            connect();
            cmd = new SqlCommand(sql, conn);
          //  data = Convert.ToInt32(cmd.ExecuteScalar());
            cmd.ExecuteNonQuery();
            cmd.Parameters.Clear();
            cmd.CommandText = "Select @@Identity";
            data = Convert.ToInt32(cmd.ExecuteScalar().ToString());
            cmd.Dispose();           
            disconnect();
            return data;
        }
        catch (SqlException ex)
        {
            lastError = translateException(ex);
            return data;
        }
        catch (Exception ex)
        {
            lastError = ex.Message;
            return data;
        }
    }    
    public static bool RestorDatabase(string dbName, string filepath)
    {
        SqlCommand cmd;
        string sql = " RESTORE DATABASE " + dbName + " FROM= '" + filepath + "'  WITH REPLACE,RECOVERY ";
        
        try
        {
            connect();
            cmd = new SqlCommand(sql, conn);
            cmd.ExecuteNonQuery();
            disconnect();
            return true;
        }
        catch (SqlException ex)
        {
            lastError = translateException(ex);
            return false;
        }
        catch (Exception ex)
        {
            lastError = ex.Message;
            return false;
        }
    }
    private static string translateException(SqlException ex)
    {
        string p = "";
        foreach (SqlError er in ex.Errors)
            p += er.Message + "\r\n";
        return p;
    }
    public static void DisplayMsgAndRedirect(string msg, Page page, string redirectURL)
    {        
        ScriptManager.RegisterStartupScript(page.Page, page.Page.GetType(), "redirect", string.Format("alert('{0}'); window.location='" + redirectURL + "';", msg), true);
    }
    public static void DisplayMsg(string msg, Page page)
    {
        msg = msg.Replace(Environment.NewLine, "\\n");
        string str = string.Format("alert('{0}');", msg);
        ScriptManager.RegisterClientScriptBlock(page.Page, page.Page.GetType(), "alert", str, true);
    }
    public static void CallJSFunction(string functionName, Page page)
    {
        string str = string.Format("{0}();", functionName);
        ScriptManager.RegisterClientScriptBlock(page.Page, page.Page.GetType(), "alert", str, true);
    }
    public static int IntegerData(string sql)
    {
        SqlCommand cmd;
        SqlDataReader reader;
        int data = 0;
        try
        {
            connect();
            cmd = new SqlCommand(sql, conn);
            reader = cmd.ExecuteReader();
            
            if (reader.Read())
            {
                data = System.Convert.ToInt32(reader[0].ToString());
            }               

            disconnect(); 
            reader.Close();
        }
        catch
        {
        }

        return data;
    }
    public static string StringData(string sql)
    {
        SqlCommand cmd;
        SqlDataReader reader;
        string data = "";
        try
        {
            connect();
            cmd = new SqlCommand(sql, conn);
            reader = cmd.ExecuteReader();

            if (reader.Read())
            {
                data = reader[0].ToString();
            }

            disconnect();
            reader.Close();
        }
        catch
        {
        }

        return data;
    }

    public static string md5Encode(string sData)
    {
        try
        {
            //byte[] encData_byte = new byte[sData.Length];
            //encData_byte = System.Text.Encoding.UTF8.GetBytes(sData);
            //string encodedData = Convert.ToBase64String(encData_byte);
            //return (encodedData);

            
            byte[] asciiBytes = ASCIIEncoding.ASCII.GetBytes(sData);
            byte[] hashedBytes = MD5CryptoServiceProvider.Create().ComputeHash(asciiBytes);
            string hashedString = BitConverter.ToString(hashedBytes).Replace("-", "").ToLower();
            return (hashedString);
        }
        catch (Exception ex)
        {
            throw (new Exception("Error in md5Encode" + ex.Message));
        }
    }
}



