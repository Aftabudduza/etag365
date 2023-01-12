using System;
//using System.Linq;
using System.Web.UI;
using System.Web.Compilation;
using System.CodeDom;

/// <summary>
/// Summary description for WebUtility
/// </summary>
public class WebUtility
{
    public WebUtility()
    {
        //
        // TODO: Add constructor logic here
        //
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


    public class LocalizationExpressionBuilder : ExpressionBuilder
    {
        public override CodeExpression GetCodeExpression(System.Web.UI.BoundPropertyEntry entry, object parsedData, ExpressionBuilderContext context)
        {
            CodeExpression[] inputParams = new CodeExpression[] { new CodePrimitiveExpression(entry.Expression.Trim()), 
                                                    new CodeTypeOfExpression(entry.DeclaringType), 
                                                    new CodePrimitiveExpression(entry.PropertyInfo.Name) };

            // Return a CodeMethodInvokeExpression that will invoke the GetRequestedValue method using the specified input parameters 
            return new CodeMethodInvokeExpression(new CodeTypeReferenceExpression(this.GetType()),
                                        "GetRequestedValue",
                                        inputParams);
        }

        public static object GetRequestedValue(string key, Type targetType, string propertyName)
        {
            // If we reach here, no type mismatch - return the value 
            return GetByText(key);
        }

        //Place holder until database is build
        public static string GetByText(string text)
        {
            return text;
        }
    }
}