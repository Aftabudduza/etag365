<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Header.ascx.cs" Inherits="eTag365.UserControls.Header" %>
<header class="main-header">
    <!-- Logo -->
    <a href="/home" class="logo">
        <!-- mini logo for sidebar mini 50x50 pixels -->
        <span class="logo-mini">
            <img alt="" src="http://173.248.133.199/Images/logo.png" width="80" class="img img-responsive" /></span>
        <!-- logo for regular state and mobile devices -->
        <span class="logo-lg">
            <img alt="" src="http://173.248.133.199/Images/logo.png" width="80" class="img pull-left" /></span>
    </a>
    <!-- Header Navbar: style can be found in header.less -->
    <nav class="navbar navbar-static-top">
        <div class="col-md-12" style="float: left; margin: 10px 0;">
            <h6>World Leaders in making business easier by moving data  using eTag365 NFC sticker and eTag365 Software Solutions</h6>
        </div>
        <div class="col-md-12" style="float: left; margin: 10px 0;">

            <div class="col-md-10 adBoxHeader ad-code-container">
            </div>
            <div class="navbar-custom-menu">
                <ul class="nav navbar-nav">
                    <!-- User Account: style can be found in dropdown.less -->
                    <li class="dropdown user user-menu">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                            <asp:Image ImageUrl="http://173.248.133.199/AdminLTE/img/avatar.png" ID="imgTopLogo" CssClass="user-image" alt="User Image" runat="server" />
                        </a>
                        <ul class="dropdown-menu">
                            <!-- User image -->
                            <li class="user-header">
                                <asp:Image ImageUrl="http://173.248.133.199/AdminLTE/img/avatar.png" ID="imgTopIcon" CssClass="img-circle" alt="User Image" runat="server" />

                                <% if (Session["Phone"] != null) %>
                                <% { %>
                                <p>
                                    <%=Session["Phone"]%>
                                    <br />
                                    <span id="spanAccount" runat="server"></span>
                                </p>
                                <% } %>                               
                            </li>

                            <!-- Menu Footer-->
                            <li class="user-footer">
                                <div class="pull-left">
                                    <span id="spanReset" runat="server"></span>
                                </div>
                                <div class="pull-right">
                                    <span id="spanSignOut" runat="server"></span>
                                </div>
                            </li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
</header>
