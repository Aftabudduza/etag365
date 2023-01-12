using eTagService.Enums;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TagService.BO;
using TagService.DA;

namespace eTag365.UserControls
{
    public partial class Menu : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string sessionid = System.Web.HttpContext.Current.Session.SessionID;

                if (!string.IsNullOrEmpty(sessionid))
                {
                    int userid = Utility.IntegerData("SELECT TOP 1 UserId FROM UserLog_Data Where SessionId='" + sessionid + "' Order By LogId DESC");

                    if (userid > 0)
                    {
                        UserProfile objTemp = new UserProfileDA().GetUserByUserID(userid);
                        bool bIsAdmin = false;

                        if (objTemp != null)
                        {
                            bIsAdmin = (objTemp.IsAdmin != null && Convert.ToBoolean(objTemp.IsAdmin) == true) ? true : false;

                            if(objTemp.UserTypeContact != null)
                            {
                                if (objTemp.UserTypeContact == Convert.ToInt32(EnumUserType.Admin).ToString())
                                {
                                    liHeader.InnerHtml = "User: Admin";
                                    lihome.InnerHtml = "<a href='" + Utility.WebUrl + "/home'><i class='fa fa-circle-o'></i>Dashboard </a>";
                                    liImport.InnerHtml = "<a href='" + Utility.WebUrl + "/contact-import'><i class='fa fa-circle-o'></i>Import / Export Contacts </a>";

                                    liUser.InnerHtml = "<a href='" + Utility.WebUrl + "/users'><i class='fa fa-circle-o'></i>Add/Change User Profile </a>";
                                    liPrice.InnerHtml = "<a href='" + Utility.WebUrl + "/user-pricing'><i class='fa fa-circle-o'></i>User Pricing</a>";
                                    liBilling.InnerHtml = "<a href='" + Utility.WebUrl + "/billing'><i class='fa fa-circle-o'></i>Billing Payment Options</a>";
                                    liReferral.InnerHtml = "<a href='" + Utility.WebUrl + "/referral-report'><i class='fa fa-circle-o'></i>My Referral View & Report </a>";
                                    liDealer.InnerHtml = "<a href='" + Utility.WebUrl + "/dealer'><i class='fa fa-circle-o'></i>Dealer Dashboard </a>";
                                    liGroupCode.InnerHtml = "<a href='" + Utility.WebUrl + "/group-code'><i class='fa fa-circle-o'></i>Group Code Profile </a>";
                                    liSystemData.InnerHtml = "<a href='" + Utility.WebUrl + "/system'><i class='fa fa-circle-o'></i>System Data</a>";
                                    liGlobalSystemInfo.InnerHtml = "<a href='" + Utility.WebUrl + "/global-info'><i class='fa fa-circle-o'></i>Global eTag365 System Info</a>";
                                    lireset.InnerHtml = "<a href='" + Utility.WebUrl + "/reset-password'><i class='fa fa-circle-o'></i>Reset Password </a>";
                                    liApproveBillingTransaction.InnerHtml = "<a href='" + Utility.WebUrl + "/approvetransaction'><i class='fa fa-circle-o'></i>Approve Billing Transactions </a>";

                                    liPayCommission.InnerHtml = "<a href='" + Utility.WebUrl + "/pay'><i class='fa fa-circle-o'></i>Pay Commissions</a>";
                                    liApproveCommission.InnerHtml = "<a href='" + Utility.WebUrl + "/approve'><i class='fa fa-circle-o'></i>Approve Commissions</a>";

                                    liEmailSetup.InnerHtml = "<a href='" + Utility.WebUrl + "/email-setup'><i class='fa fa-circle-o'></i>Email Template Setup </a>";
                                    liEmailSchedule.InnerHtml = "<a href='" + Utility.WebUrl + "/email-scheduler'><i class='fa fa-circle-o'></i>Email Scheduler </a>";
                                    liEmailLog.InnerHtml = "<a href='" + Utility.WebUrl + "/email-log'><i class='fa fa-circle-o'></i>Email Drip Log </a>";

                                    liCalendarEntry.InnerHtml = "<a href='" + Utility.WebUrl + "/calendar-entry'><i class='fa fa-circle-o'></i>Event Calendar Setup </a>";
                                    liCalendarScheduler.InnerHtml = "<a href='" + Utility.WebUrl + "/calendar-scheduler'><i class='fa fa-circle-o'></i>Event Calendar Scheduler with User </a>";
                                    liCalendarAppointment.InnerHtml = "<a href='" + Utility.WebUrl + "/users-appointment'><i class='fa fa-circle-o'></i>Event Calendar Users Appointments </a>";


                                }
                                else if(objTemp.UserTypeContact == Convert.ToInt32(EnumUserType.Dealer).ToString())
                                {
                                    liHeader.InnerHtml = "User: Dealer";
                                    liDealer.InnerHtml = "<a href='" + Utility.WebUrl + "/dealer'><i class='fa fa-circle-o'></i>Dealer Dashboard </a>";
                                    liDealerCommission.InnerHtml = "<a href='" + Utility.WebUrl + "/dealer'><i class='fa fa-circle-o'></i>Dealer Commission </a>";
                                    liDealerAccounts.InnerHtml = "<a href='" + Utility.WebUrl + "/dealer'><i class='fa fa-circle-o'></i>Dealer Accounts </a>";
                                    liDealerProfile.InnerHtml = "<a href='" + Utility.WebUrl + "/dealer'><i class='fa fa-circle-o'></i>Dealer Profile </a>";
                                    lireset.InnerHtml = "<a href='" + Utility.WebUrl + "/reset-password'><i class='fa fa-circle-o'></i>Reset Password </a>";
                                }
                                else
                                {
                                    liHeader.InnerHtml = "User: Active";
                                    lihome.InnerHtml = "<a href='" + Utility.WebUrl + "/home'><i class='fa fa-circle-o'></i>Dashboard </a>";
                                    liImport.InnerHtml = "<a href='" + Utility.WebUrl + "/contact-import'><i class='fa fa-circle-o'></i>Import / Export Contacts </a>";
                                    liUser.InnerHtml = "<a href='" + Utility.WebUrl + "/users'><i class='fa fa-circle-o'></i>Add/Change User Profile </a>";
                                    liPrice.InnerHtml = "<a href='" + Utility.WebUrl + "/user-pricing'><i class='fa fa-circle-o'></i>User Pricing</a>";
                                    liBilling.InnerHtml = "<a href='" + Utility.WebUrl + "/billing'><i class='fa fa-circle-o'></i>Billing Payment Options</a>";
                                    lireset.InnerHtml = "<a href='" + Utility.WebUrl + "/reset-password'><i class='fa fa-circle-o'></i>Reset Password </a>";
                                    liReferral.InnerHtml = "<a href='" + Utility.WebUrl + "/referral-report'><i class='fa fa-circle-o'></i>My Referral View & Report </a>";

                                    liEmailSetup.InnerHtml = "<a href='" + Utility.WebUrl + "/email-setup'><i class='fa fa-circle-o'></i>Email Template Setup </a>";
                                    liEmailSchedule.InnerHtml = "<a href='" + Utility.WebUrl + "/email-scheduler'><i class='fa fa-circle-o'></i>Email Scheduler </a>";
                                    liEmailLog.InnerHtml = "<a href='" + Utility.WebUrl + "/email-log'><i class='fa fa-circle-o'></i>Email Drip Log </a>";

                                    liCalendarEntry.InnerHtml = "<a href='" + Utility.WebUrl + "/calendar-entry'><i class='fa fa-circle-o'></i>Event Calendar Setup </a>";
                                    liCalendarScheduler.InnerHtml = "<a href='" + Utility.WebUrl + "/calendar-scheduler'><i class='fa fa-circle-o'></i>Event Calendar Scheduler with User </a>";
                                    liCalendarAppointment.InnerHtml = "<a href='" + Utility.WebUrl + "/users-appointment'><i class='fa fa-circle-o'></i>Event Calendar Users Appointments </a>";
                                }
                            }

                            if (bIsAdmin == true)
                            {
                                liUser.InnerHtml = "<a href='" + Utility.WebUrl + "/users'><i class='fa fa-circle-o'></i>Add/Change User Profile </a>";
                                liDealer.InnerHtml = "<a href='" + Utility.WebUrl + "/dealer'><i class='fa fa-circle-o'></i>Dealer Dashboard </a>";
                                liGroupCode.InnerHtml = "<a href='" + Utility.WebUrl + "/group-code'><i class='fa fa-circle-o'></i>Group Code Profile </a>";
                                liSystemData.InnerHtml = "<a href='" + Utility.WebUrl + "/system'><i class='fa fa-circle-o'></i>System Data</a>";
                                liGlobalSystemInfo.InnerHtml = "<a href='" + Utility.WebUrl + "/global-info'><i class='fa fa-circle-o'></i>Global eTag365 System Info</a>";
                                liApproveBillingTransaction.InnerHtml = "<a href='" + Utility.WebUrl + "/approvetransaction'><i class='fa fa-circle-o'></i>Approve Billing Transactions </a>";
                                liPayCommission.InnerHtml = "<a href='" + Utility.WebUrl + "/pay'><i class='fa fa-circle-o'></i>Pay Commissions</a>";
                                liApproveCommission.InnerHtml = "<a href='" + Utility.WebUrl + "/approve'><i class='fa fa-circle-o'></i>Approve Commissions</a>";
                                 
                            }
                            
                        }
                       
                    }
                   
                }                      

            }
        }
    }
}