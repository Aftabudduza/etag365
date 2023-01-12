using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;

namespace eTag365
{
    public class Global : System.Web.HttpApplication
    {
        protected void Application_Start(object sender, EventArgs e)
        {
            RegisterRoute(System.Web.Routing.RouteTable.Routes);           
        }
        public void RegisterRoute(System.Web.Routing.RouteCollection routes)
        {
            routes.MapPageRoute("Home", "home", "~/Pages/Admin/ContactHome.aspx");
            routes.MapPageRoute("login", "login", "~/Pages/Login.aspx");            
            routes.MapPageRoute("password", "password", "~/Pages/Login2.aspx");
            routes.MapPageRoute("logout", "logout", "~/Pages/Logout.aspx");
            routes.MapPageRoute("forget-password", "forget-password", "~/Pages/ForgotPassword.aspx");
            routes.MapPageRoute("phone-verify", "phone-verify", "~/Pages/Admin/PhoneVerify.aspx");
            routes.MapPageRoute("reset-password", "reset-password", "~/Pages/Admin/ResetPassword.aspx");
            routes.MapPageRoute("billing", "billing", "~/Pages/Admin/Billing.aspx");
            routes.MapPageRoute("contact-view", "{CId}/contact", "~/Pages/Admin/AddContact.aspx");
            routes.MapPageRoute("users", "users", "~/Pages/Admin/UserList.aspx");
            routes.MapPageRoute("system", "system", "~/Pages/Settings/AddBasicData.aspx");
            routes.MapPageRoute("user-pricing", "user-pricing", "~/Pages/Settings/UserPricing.aspx");
            routes.MapPageRoute("group-code", "group-code", "~/Pages/Admin/GroupCodeDealerProfile.aspx");
            routes.MapPageRoute("dealer", "dealer", "~/Pages/Accounts/DealerDashboard.aspx");
            routes.MapPageRoute("user", "user", "~/Pages/Admin/AddUser.aspx");
            routes.MapPageRoute("global-info", "global-info", "~/Pages/Admin/AddGlobalSystem.aspx");

            routes.MapPageRoute("contact-import", "contact-import", "~/Pages/Admin/ContactExportImport.aspx");
            routes.MapPageRoute("checkout", "checkout", "~/Pages/Admin/Checkout.aspx"); 
            routes.MapPageRoute("approvetransaction", "approvetransaction", "~/Pages/Admin/BillingTransactionList.aspx");
            routes.MapPageRoute("referral-report", "referral-report", "~/Pages/Accounts/MyReferralView.aspx");

            routes.MapPageRoute("pay", "pay", "~/Pages/Admin/PayCommission.aspx");
            routes.MapPageRoute("thank-you", "thank-you", "~/Pages/Admin/ThankYou.aspx");
            routes.MapPageRoute("approve", "approve", "~/Pages/Admin/CommissionList.aspx");

            routes.MapPageRoute("email-setup", "email-setup", "~/Pages/Admin/EmailTemplateSetup.aspx");
            routes.MapPageRoute("email-scheduler", "email-scheduler", "~/Pages/Admin/EmailScheduler.aspx");
            routes.MapPageRoute("email-unsubscribe", "email-unsubscribe", "~/EmailUnsubscribe.aspx");
            routes.MapPageRoute("email-log", "email-log", "~/Pages/Admin/EmailLog.aspx");

            routes.MapPageRoute("calendar-entry", "calendar-entry", "~/Pages/CalendarEntryN.aspx");
            routes.MapPageRoute("calendar-scheduler", "calendar-scheduler", "~/Pages/CalendarScheduler.aspx");
            routes.MapPageRoute("users-appointment", "users-appointment", "~/UserAppointment.aspx");
            routes.MapPageRoute("event-confirm", "event-confirm", "~/EventConfirm.aspx");
        }
    }
}