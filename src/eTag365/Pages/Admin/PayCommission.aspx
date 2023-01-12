<%@ Page Title="eTag365 :: Pay Dealer/User Commissions" Language="C#" EnableEventValidation="false" Debug="true" AutoEventWireup="true" CodeBehind="PayCommission.aspx.cs" Inherits="eTag365.Pages.Admin.PayCommission" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta http-equiv="Page-Enter" content="blendTrans(Duration=0)" />
    <meta http-equiv="Page-Exit" content="blendTrans(Duration=0)" />
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="SKYPE_TOOLBAR" content="SKYPE_TOOLBAR_PARSER_COMPATIBLE" />
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <meta name="description" content="" />
    <meta name="author" content="" />
    <title>eTag365 :: Pay Dealer/User Commissions</title>

    <link rel="stylesheet" href="../../Content/bootstrap.css" />
    <link rel="stylesheet" href="../../Content/jquery-ui.css" />
    <link rel="stylesheet" href="../../Content/toastr.css" />
    <link rel="stylesheet" href="../../Content/font-awesome.css" />
    <link rel="stylesheet" href="../../Content/ionicons/ionicons.css" />
    <link rel="stylesheet" href="../../AdminLTE/css/AdminLTE.css" />
    <link rel="stylesheet" href="../../AdminLTE/css/skins/_all-skins.css" />
    <link rel="stylesheet" href="../../Content/admin.css" />
    <link type="text/css" href="../../scripts/jquery.dataTables.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css" />


    <!-- Web Fonts -->
    <link href='https://fonts.googleapis.com/css?family=Open+Sans:400italic,700italic,400,700,300&amp;subset=latin,latin-ext' rel='stylesheet' type='text/css' />
    <link href='https://fonts.googleapis.com/css?family=PT+Serif' rel='stylesheet' type='text/css' />
    <link type="text/css" href="../../scripts/notification/notification.css" rel="stylesheet" />
    <link href="../../scripts/select2/dist/css/select2-bootstrap.css" rel="stylesheet" />
    <link href="../../scripts/select2/dist/css/select2.css" rel="stylesheet" />
    <link type="text/css" href="../../AdminLTE/iCheck/all.css" rel="stylesheet" />
    <link href="../../css/Site.css" rel="stylesheet" />

    <link href="../../AdminLTE/iCheck/flat/_all.css" rel="stylesheet" />
    <link rel="stylesheet" href="../../plugins/SlickNav/slicknav.css" />


    <script type="text/javascript" src="../../scripts/jquery-3.1.1.js"></script>
    <script type="text/javascript" src="../../scripts/jquery-ui-1.12.1.min.js"></script>
    <script type="text/javascript" src="../../scripts/bootstrap.js"></script>
    <script type="text/javascript" src="../../AdminLTE/js/adminlte.js"></script>
    <script type="text/javascript" src="../../scripts/jquery.validate.min.js"></script>
    <script type="text/javascript" src="../../scripts/jquery.validate.unobtrusive.min.js"></script>
    <script type="text/javascript" src="../../scripts/notification/bootstrap-growl.min.js"></script>
    <script type="text/javascript" src="../../scripts/notification/notification.js"></script>
    <script type="text/javascript" src="../../scripts/select2/dist/js/select2.min.js"></script>
    <script type="text/javascript" src="../../AdminLTE/iCheck/icheck.js"></script>
    <script type="text/javascript" src="../../plugins/SlickNav/jquery.slicknav.min.js"></script>
    <script type="text/javascript" src="../../scripts/jquery.dataTables.min.js"></script>
    <script src="../../AppJs/CommonJS/DataBaseOperationJs.js"></script>
    <%-- <script src="../../AppJs/Admin/Billing.js"></script>--%>

    <style type="text/css">
        @font-face {
            font-family: 'FontAwesome';
            src: url('../fonts/fontawesome-webfont.eot?v=4.7.0');
            src: url('../fonts/fontawesome-webfont.eot?#iefix&v=4.7.0') format('embedded-opentype'), url('../fonts/fontawesome-webfont.woff2?v=4.7.0') format('woff2'), url('../fonts/fontawesome-webfont.woff?v=4.7.0') format('woff'), url('../fonts/fontawesome-webfont.ttf?v=4.7.0') format('truetype'), url('../fonts/fontawesome-webfont.svg?v=4.7.0#fontawesomeregular') format('svg');
            font-weight: normal;
            font-style: normal;
        }

        .fa {
            display: inline-block;
            font: normal normal normal 14px/1 FontAwesome;
        }
    </style>
    <script type="text/javascript">
        $(function () {
            $('#menu').slicknav();
        });

        $(document).ready(function () {
            $(".tDate").datepicker({
                dateFormat: "mm-dd-yy",
                changeYear: true,
                changeMonth: true
            });
        });
    </script>
    <script type="text/javascript">
        if (window.innerWidth <= 350) {
            google_ad_width = 320;
            google_ad_height = 50;
        } else if (window.innerWidth >= 750) {
            google_ad_width = 728;
            google_ad_height = 90;
        } else {
            google_ad_width = 468;
            google_ad_height = 60;
        }
    </script>
    <style type="text/css">
        .nav-tabs-custom {
            background-color: #DFE3EE;
        }

            .nav-tabs-custom > .nav-tabs {
                border-bottom-color: initial;
                padding: 0px 0px 0px 18px;
                background-color: #8B9DC3;
            }

                .nav-tabs-custom > .nav-tabs > li > a, .nav-tabs-custom > .nav-tabs > li > a:hover {
                    background: #ffffff;
                }

                .nav-tabs-custom > .nav-tabs > li > a {
                    border-radius: 10px 10px 0px 0px;
                }

        .nav-tabs {
            border-bottom: none;
        }

        #nav-tab > li > a.active {
            background-color: #98cdfe;
            color: #ffffff;
        }

        .nav-tabs-custom > .tab-content {
            background: none;
            border-bottom-right-radius: 3px;
            border-bottom-left-radius: 3px;
            padding: 10px 10px 10px 5px;
        }

        .nav-tabs-custom > .nav-tabs > li > a, .nav-tabs-custom > .nav-tabs > li > a:hover {
            height: 56px;
            text-align: center;
        }

        .input-validation-error {
            border: 1px solid #ff0000;
            background-color: #ffeeee !important;
        }

        .field-validation-error {
            color: #ff0000 !important;
        }
    </style>
    <style type="text/css">
        .box-header.with-border {
            border-bottom: none;
            text-align: center;
        }

        .box {
            position: relative;
            background: none;
            border-top: none;
            margin-bottom: 20px;
            width: 100%;
            box-shadow: none;
        }

        .skin-blue .sidebar-menu .treeview-menu > li > a.active {
            color: red;
        }

        .slicknav_menu {
            display: none;
        }

        .wrapper {
            background: #F7F7F7;
        }

        @media screen and (max-width: 767px) {
            /* #menu is the original menu */
            #menu {
                display: none;
            }

            .slicknav_menu {
                background: #8B9DC3;
                display: block;
                top: 230px;
                /*top: 10px;
				left: 150px;*/
                position: absolute;
                z-index: 10000;
            }
        }
    </style>
    <style type="text/css">
        .main-footer {
            clear: both;
            float: left !important;
            width: 100% !important;
        }

        .nav > li {
            float: left;
        }

            .nav > li > a {
                float: left;
            }
    </style>
    <style type="text/css">
        .auto-style1 {
            width: 1024px;
            height: 1050px;
        }

        .auto-style2 {
            background-color: #FFFFCC;
            border: none;
        }

        .auto-style5 {
            font-size: medium;
            border: none;
        }

        .auto-style6 {
            font-size: medium;
            font-weight: bold;
            border: none;
        }

        .auto-style7 {
            text-align: center;
            border: none;
        }

        .auto-style8 {
            width: 135px;
            border: none;
        }

        .auto-style9 {
            width: 82px;
            border: none;
        }

        .auto-style10 {
            width: 118px;
            border: none;
        }

        .auto-style16 {
            width: 116px;
            border: none;
        }

        .auto-style17 {
            width: 40%;
            border: none;
            float: left;
        }

        .auto-style18 {
            width: 209px;
            border: none;
        }

        .auto-style19 {
            width: 101px;
        }

        .auto-style21 {
            width: 186px;
            border: none;
        }

        .auto-style22 {
            width: 161px;
            border: none;
        }

        .auto-style24 {
            width: 100%;
            border: none;
        }

        .auto-style25 {
            width: 119px;
            height: 23px;
            border: none;
        }

        .auto-style31 {
            width: 131px;
            border: none;
        }

        .auto-style34 {
            width: 130px;
            border: none;
        }

        .auto-style35 {
            width: 23%;
            height: 23px;
            border-style: none;
            vertical-align: top;
            float: left;
        }

        .auto-style36 {
            width: 22%;
            height: 23px;
            vertical-align: top;
            border-style: none;
            float: left;
        }

        .auto-style37 {
            width: 25%;
            height: 23px;
            vertical-align: top;
            border-style: none;
            float: left;
        }

        .auto-style39 {
            width: 134px;
            border-style: none;
            vertical-align: top;
        }

        .auto-style40 {
            width: 133px;
            border: none;
        }

        .auto-style45 {
            color: #FF0000;
            border-left-color: #C0C0C0;
            border-left-width: medium;
            border-right-color: #A0A0A0;
            border-right-width: medium;
            border-top-color: #C0C0C0;
            border-top-width: medium;
            border-bottom-color: #A0A0A0;
            border-bottom-width: medium;
            padding: 1px;
            background-color: #FFFFCC;
        }

        .auto-style46 {
            height: 23px;
            width: 23%;
            vertical-align: top;
            border-style: none;
            float: left;
        }

        .auto-style47 {
            width: 100%;
            vertical-align: top;
            border-style: none;
        }

        .auto-style48 {
            height: 23px;
            vertical-align: top;
            border-style: none;
        }

        .auto-style49 {
            width: 100%;
            vertical-align: top;
            border-style: none;
        }

        .auto-style50 {
            width: 100%;
        }

        .auto-style51 {
            width: 70px;
        }

        .auto-style52 {
            width: 159px;
        }

        .auto-style53 {
            width: 49px;
        }

        .auto-style54 {
            width: 149px;
        }

        .auto-style55 {
            width: 104px;
        }

        .auto-style56 {
            width: 319px;
        }
    </style>

</head>
<body class="hold-transition skin-blue sidebar-mini fixed">
    <form id="form2" runat="server" class="form-horizontal">
        <!-- Site wrapper -->
        <div class="wrapper">
            <header class="main-header">
                <!-- Logo -->
                <a href="/home" class="logo">
                    <!-- mini logo for sidebar mini 50x50 pixels -->
                    <span class="logo-mini">
                        <img alt="" src="https://www.etag365.net/Images/logo.png" width="80" class="img img-responsive" /></span>
                    <!-- logo for regular state and mobile devices -->
                    <span class="logo-lg">
                        <img alt="" src="https://www.etag365.net/Images/logo.png" width="80" class="img pull-left" /></span>
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
                                        <asp:Image ImageUrl="https://www.etag365.net/AdminLTE/img/avatar.png" ID="imgTopLogo" CssClass="user-image" alt="User Image" runat="server" />
                                    </a>
                                    <ul class="dropdown-menu">
                                        <!-- User image -->
                                        <li class="user-header">
                                            <asp:Image ImageUrl="https://www.etag365.net/AdminLTE/img/avatar.png" ID="imgTopIcon" CssClass="img-circle" alt="User Image" runat="server" />

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
            <!-- =============================================== -->
            <!-- Left side column. contains the sidebar -->
            <aside class="main-sidebar">
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
                                <li id="liSystemData" runat="server"></li>
                                <li id="liGlobalSystemInfo" runat="server"></li>
                                <li id="lireset" runat="server"></li>
                            </ul>
                        </li>

                    </ul>
                </section>
                <!-- /.sidebar -->
            </aside>
            <!-- =============================================== -->
            <!-- Content Wrapper. Contains page content -->
            <div class="content-wrapper">
                <!-- Main content -->
                <section class="content">
                    <div class="box">
                        <div class="box-header with-border CommonHeader col-md-12">
                            <h3 class="box-title" id="lblHeadline" runat="server">eTag365 Commissions </h3>
                            <asp:HiddenField ID="page_pg_utc_time" runat="server" Value="" />
                            <asp:HiddenField ID="page_pg_transaction_order_number" runat="server" Value="" />
                        </div>

                        <!-- left column -->
                        <div class="col-md-12">
                            <!-- general form elements -->
                            <div class="box box-primary">
                                <!-- /.box-header -->
                                <!-- form start -->
                                <div class="box-body">
                                    <div class="form-group">
                                        <div class="col-md-6">
                                            <label class="col-sm-6 control-label">Type of User:</label>
                                            <div class="col-sm-6">
                                                <asp:RadioButtonList runat="server" ID="rdoUserType" CssClass="form-control" AutoPostBack="true" RepeatDirection="Horizontal" OnSelectedIndexChanged="rdoUserType_SelectedIndexChanged">
                                                    <asp:ListItem Value="3">Dealer</asp:ListItem>
                                                    <asp:ListItem Value="2" Selected="True">User</asp:ListItem>
                                                </asp:RadioButtonList>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="col-sm-6 control-label" style="float: left;">User:</label>
                                            <div class="col-sm-6">
                                                <asp:DropDownList ID="ddlUser" AutoPostBack="true" OnSelectedIndexChanged="ddlUser_SelectedIndexChanged" CssClass="form-control" runat="server">
                                                </asp:DropDownList>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="box-body">
                                    <div class="form-group">
                                        <div class="col-md-6">
                                            <label for="txtDue" class="col-sm-6 control-label" style="float: left;">Commission Earned ($):</label>
                                            <div class="col-sm-6">
                                                <asp:TextBox ID="txtDue" Enabled="false" runat="server" CssClass="form-control"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="txtPaid" class="col-sm-6 control-label" style="float: left;">Paid Amount ($):</label>
                                            <div class="col-sm-6">
                                                <asp:TextBox ID="txtPaid" Enabled="true" runat="server" ValidationGroup="Pay" CssClass="form-control"></asp:TextBox>
                                                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtPaid" Display="Dynamic" ForeColor="Red" ErrorMessage="Amount must be in format 0.00."
                                                    ValidationExpression="^\d+(?:\.\d{0,2})?$"></asp:RegularExpressionValidator>
                                                &nbsp;<asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtPaid" Display="Dynamic" ValidationGroup="Pay" ForeColor="Red"
                                                    ErrorMessage="Amount is required."></asp:RequiredFieldValidator>
                                                <asp:RangeValidator ID="RangeValidator1" runat="server" ControlToValidate="txtPaid" ErrorMessage="Must be larger than zero !!"
                                                    MaximumValue="999999999999" MinimumValue="0.01" ForeColor="Red" Type="Double"></asp:RangeValidator>

                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <asp:Button ID="btnCalculate" OnClick="btnCalculate_Click" runat="server" Text="Calculate Commission" CssClass="btn btn-success" />
                                            <asp:Button ID="btnPay" runat="server" OnClick="btnPay_Click" Text="Pay" ValidationGroup="Pay" CssClass="btn btn-successNew" />
                                        </div>
                                        <div class="col-md-6">
                                            <label class="col-sm-12 col-form-label" style="color: red">etag365 does not pay outstanding commission until they are more than $25.00 or it's the end of year.</label>
                                        </div>
                                    </div>
                                </div>

                                <div class="box-body">
                                    <form class="vertical-form">
                                        <fieldset>
                                            <asp:GridView Width="100%" ID="gvContactList" runat="server" AutoGenerateColumns="False" CellPadding="10" ForeColor="#333333" CssClass="table table-bordered table-striped"
                                                GridLines="None" AllowPaging="True" OnPageIndexChanging="gvContactList_PageIndexChanging"
                                                OnSorting="gvContactList_Sorting" PageSize="20" Style="float: left; margin-bottom: 10px;" AllowSorting="True">
                                                <PagerSettings Position="TopAndBottom" />
                                                <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                                                <Columns>

                                                    <asp:TemplateField HeaderText="Year" SortExpression="Data">
                                                        <ItemTemplate>
                                                            <asp:Label ID="Label1" runat="server" Text='<%# Eval("Year") %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Month" SortExpression="Data">
                                                        <ItemTemplate>
                                                            <asp:Label ID="Label2" runat="server" Text='<%# Eval("Month") %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="GiverPhone" SortExpression="Data">
                                                        <ItemTemplate>
                                                            <asp:Label ID="Label3" runat="server" Text='<%# Eval("GiverPhone") %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                                                    </asp:TemplateField>

                                                    <asp:TemplateField HeaderText="Amount ($)" SortExpression="Data">
                                                        <ItemTemplate>
                                                            <asp:Label ID="Label8" runat="server" Text='<%# Eval("Amount","{0:c}") %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                                                    </asp:TemplateField>

                                                    <asp:TemplateField HeaderText="Status" SortExpression="Data">
                                                        <ItemTemplate>
                                                            <asp:Label ID="Label11" runat="server" Text='<%# Eval("Status") %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                                                    </asp:TemplateField>


                                                </Columns>
                                                <EmptyDataTemplate>
                                                    <div>
                                                    </div>
                                                </EmptyDataTemplate>
                                                <FooterStyle BackColor="" Font-Bold="True" ForeColor="White" />
                                                <PagerStyle BackColor="#d1d0d0" ForeColor="Black" HorizontalAlign="Center" />
                                                <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                                                <HeaderStyle Font-Bold="True" ForeColor="Black" />
                                                <EditRowStyle BackColor="#999999" />
                                                <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                                            </asp:GridView>
                                        </fieldset>
                                    </form>
                                </div>
                                <!-- /.box-body -->

                            </div>
                        </div>
                    </div>
                </section>
                <!-- /.content -->
                <ul id="navFooter" class="nav">
                    <li>
                        <a href="/">
                            <img src="https://www.etag365.net/Images/logo.png" width="50" class="img img-responsive" alt="Logo" />
                        </a>
                    </li>

                    <li><a target="_blank" href="https://etag365.com/howitworks">How It Works</a></li>
                    <li><a target="_blank" href="#">Get Started</a></li>
                    <li><a target="_blank" href="https://etag365.com/usertermsconditions">Terms & Conditions</a></li>
                    <li><a target="_blank" href="https://www.etag365.com/Customer/PolicyAndProcedures">Privacy</a></li>
                    <li><a target="_blank" href="https://www.etag365.com/contact">Contact</a></li>
                    <li><a target="_blank" href="https://www.etag365.com">eTag365</a></li>
                </ul>
            </div>
            <!-- /.content-wrapper -->

        </div>

    </form>
</body>

</html>
