<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Menu.ascx.cs" Inherits="eTag365.UserControls.Menu" %>
<aside class="main-sidebar" >
    <!-- sidebar: style can be found in sidebar.less -->
    <section class="sidebar">
        <!-- sidebar menu: : style can be found in sidebar.less -->
        <ul class="sidebar-menu" data-widget="tree" id="menu">
            <li id="liHeader" runat="server" class="header"></li>
         
            <li class="treeview menu-open">
                <a href="#">
                    <img alt="" src="https://www.etag365.net/Images/dashboard_icon.png" style="margin-right: 5px;" width="20" class="img img-responsive" />
                    <span>User Profile</span>
                    <span class="pull-right-container">
                        <i class="fa fa-angle-left pull-right"></i>
                    </span>
                </a>

                <ul class="treeview-menu" id="20" style="display: block;">
                    <li id="lihome" runat="server"></li>
                    <li id="liImport" runat="server"></li>
                    <li id="liUser" runat="server"></li>
                    <li id="liPrice" runat="server"></li>
                    <li id="liBilling" runat="server"></li> 
                    <li id="liApproveBillingTransaction" runat="server"></li>
                    <li id="liReferral" runat="server"></li>
                    <li id="liDealer" runat="server"></li>
                    <li id="liDealerCommission" runat="server"></li>
                    <li id="liDealerAccounts" runat="server"></li>
                    <li id="liDealerProfile" runat="server"></li>
                    <li id="liPayCommission" runat="server"></li>
                    <li id="liApproveCommission" runat="server"></li>
                    <li id="liGroupCode" runat="server"></li>
                     <li id="liEmailSetup" runat="server"></li>
                     <li id="liEmailSchedule" runat="server"></li>
                     <li id="liEmailLog" runat="server"></li>

                     <li id="liCalendarEntry" runat="server"></li>
                     <li id="liCalendarScheduler" runat="server"></li>
                     <li id="liCalendarAppointment" runat="server"></li>

                    <li id="liSystemData" runat="server"></li>
                    <li id="liGlobalSystemInfo" runat="server"></li>                    
                    <li id="lireset" runat="server"></li>
                    
                </ul>
            </li>

        </ul>
    </section>
    <!-- /.sidebar -->
</aside>
