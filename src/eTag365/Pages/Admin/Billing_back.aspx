<%@ Page Title="eTag365 Payment Options" Language="C#" AutoEventWireup="true" CodeBehind="Billing_back.aspx.cs" Inherits="eTag365.Pages.Admin.Billing" %>

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
    <title>eTag365 Payment Options</title>

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

    <!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
    <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->
    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
        <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->

    <!-- Google Font -->

    <%-- <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,600,700,300italic,400italic,600italic">--%>

    <!-- Web Fonts -->
    <link href='https://fonts.googleapis.com/css?family=Open+Sans:400italic,700italic,400,700,300&amp;subset=latin,latin-ext' rel='stylesheet' type='text/css' />
    <link href='https://fonts.googleapis.com/css?family=PT+Serif' rel='stylesheet' type='text/css' />
    <link type="text/css" href="../../scripts/notification/notification.css" rel="stylesheet" />
    <link href="../../scripts/select2/dist/css/select2-bootstrap.css" rel="stylesheet" />
    <link href="../../scripts/select2/dist/css/select2.css" rel="stylesheet" />
    <link type="text/css" href="../../AdminLTE/iCheck/all.css" rel="stylesheet" />
    <link href="../../css/Site.css" rel="stylesheet" />
    <%--<link type="text/css" href="../../Content/morris/morris.css" rel="stylesheet" />--%>
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
    <script src="../../AppJs/Admin/Billing.js"></script>
    <script type="text/javascript" src="https://sandbox.forte.net/checkout/v1/js"></script>
    <%--<script type="text/javascript" src="https://checkout.forte.net/v1/js"></script>--%>

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

        /*.auto-style4 {
            width: 60%;
            border: none;
        }*/

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
                            <%-- <li id="liReferral" runat="server"><a href="#"><i class="fa fa-circle-o"></i>My Referral View & Report</a></li>--%>
                            <li id="liDealer" runat="server"></li>
                            <li id="liGroupCode" runat="server"></li>
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
                        <h3 class="box-title" id="lblHeadline" runat="server">eTag365 Payment Options</h3>
                    </div>

                    <!-- left column -->
                    <div class="col-md-12">
                        <!-- general form elements -->
                        <div class="box box-primary">
                            <!-- /.box-header -->
                            <!-- form start -->
                            <div class="box-body">
                                <input type="hidden" id="hdPhone" value="<%=sUserPhone%>" />
                                <input type="hidden" id="hdUserType" value="<%=sUserType%>" />

                                <input type="hidden" id="pg_api_login_id" value="<%=api_loginID%>" />
                                <input type="hidden" id="hdnShow" value="<%=isView%>" />
                                <input type="hidden" id="pg_utc_time" value="<%=utc_time%>" />
                              
                                <input type="hidden" id="hdId" value="0" />
                                <input type="hidden" id="hdPaymentId" value="0" />

                                <input type="hidden" id="hdYTDExportLimit" value="0" />
                                <input type="hidden" id="hdMTDImportLimit" value="0" />
                                <input type="hidden" id="hdStorageLimit" value="0" />

                                <div class="row">
                                    <div class="col-12">
                                        <div class="form-group row">
                                            <div class="col-sm-12" style="font-weight: bold; font-size: 14px;">
                                                <label class="col-form-label">* eTag365 Monthly & Annual User Charges:</label>
                                            </div>
                                        </div>
                                        <div class="form-group row">
                                            <div class="col-sm-3">
                                                <label class="col-form-label">Choose Your Plan:</label>
                                            </div>
                                            <div class="col-sm-6">
                                                <label style="margin-right: 7px">
                                                    <input type="radio" id="B" name="plan" class="flat-red" value="Basic" checked="checked" />
                                                    Basic Plan
                                                </label>

                                                <label style="margin-right: 7px">
                                                    <input type="radio" name="plan" value="Silver" id="S" class="flat-red" />
                                                    Silver Plan
                                                </label>
                                                <label style="margin-right: 7px">
                                                    <input type="radio" name="plan" value="Gold" id="G" class="flat-red" />
                                                    Gold Plan
                                                </label>
                                            </div>

                                        </div>
                                        <div class="form-group row">
                                            <div class="col-sm-3">
                                                <label class="col-form-label">Billing Period:</label>
                                            </div>
                                            <div id="divddl" class="col-sm-6">
                                                <select id="ddlPeriod" class="ddl"></select>
                                            </div>
                                        </div>
                                        <div id="chkStorageDisplay" class="form-group row" style="margin-top: 10px;">
                                            <div class="col-sm-12">
                                                <input type="checkbox" id="chkStorage" value="" />
                                                <label class="control-label">Add Additional Storage</label>
                                            </div>
                                        </div>
                                        <div id="IsStorageDisplay" class="form-group row">
                                            <div class="col-sm-12">
                                                <span>Over </span><span style="width: 30px;" id="NoOfContact">500 </span>  contacts - Total <span style="width: 30px;" id="NoOfContact2">500</span> X 
                                                <input style="width: 20px;" type="text" id="ContactMultiplier" value="1" />
                                                =  <span style="width: 30px;" id="TotalContact">500</span> contacts per month
                                                    $<span style="width: 20px;" id="PerMonthCharge">1.00 </span> X <span style="width: 20px;" id="ContactMultiplier2">1</span>=  $<span style="width: 30px;" id="TotalMonthlyCharge">1.00</span>
                                            </div>
                                        </div>
                                        <div class="form-group row" style="margin-top: 10px;">
                                            <div class="col-sm-12">
                                                <input type="checkbox" id="chkReceive" value="" />
                                                <label for="chkReceive" class="control-label">Click checkbox to receive eTag365 Rewards Referral Commissions.</label>
                                            </div>
                                        </div>
                                        <div class="form-group row">
                                            <div class="col-sm-12">
                                                <p>
                                                    You have already been enroll eTag365 Rewards Referral Commission Program. You will receive the 5% on eTag365 contact services on anyone that you give your etag365 sticker business card to that is not already a registered User of eTag365. You will receive your 5% monthly commissions quarterly via ACH to your bank acount for 12 months  You can extend it for another 12 month by get 20 new User per year and if get a total of 100 or more new Users it's extended to your lifetime. No  more yearly quotas.
                                                </p>
                                            </div>
                                        </div>
                                        <div class="form-group row">
                                            <div class="col-sm-12" style="font-weight: bold; font-size: 12px; text-align: center; font-style: italic;">
                                                <label class="col-form-label">You must fill out Checking Account form below, eTag365 will only pay you by ACH to your bank account.</label>

                                            </div>
                                        </div>
                                        <div class="form-group row" style="margin-top: 10px;">
                                            <div class="col-sm-6">
                                                <input id="groupcode" type="text" placeholder="Group Code" class="form-control" />
                                            </div>
                                            <div class="col-sm-6">
                                                <div style="float: left; width: 100%">
                                                    <span>Plan Charge: $</span>
                                                    <span id="PlanCharge">0.00</span>
                                                </div>
                                                <div style="float: left; width: 100%">
                                                    <span>Storage Charge: $</span>
                                                    <span id="storageCharge">0.00</span>
                                                </div>
                                                <div style="float: left; width: 100%">
                                                    <span>Sub-Total Charge: $</span>
                                                    <span id="subTotalCharge">0.00</span>
                                                </div>
                                                <div style="float: left; width: 100%">
                                                    <span>Discount (</span><span id="percentRatio"></span><span>%): $</span>
                                                    <span id="Discount">0.00</span>
                                                </div>
                                                <div style="float: left; width: 100%">
                                                    <span>Total Charge: $</span>
                                                    <span id="TotalAmountCharge" >0.00</span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group row" style="margin-top: 10px;">
                                            <div class="col-sm-6">
                                                <input type="checkbox" id="chkRecurring" value="" />
                                                <label for="chkAgree" class="control-label">I authorize recurring monthly charges if applicable: </label>
                                            </div>
                                            <div class="col-sm-3">
                                                $<%--<span id="TotalAmountChargeRe">0.00</span>--%>
                                                <input type="text" disabled="disabled" name="total_amount" id="TotalAmountChargeRe" />
                                            </div>
                                        </div>

                                        <div class="form-group row">
                                            <div class="col-sm-12">
                                                <label class=" col-form-label">Accounts on file:</label>

                                            </div>
                                        </div>
                                        <div class="form-group row">
                                            <div class="col-sm-12">
                                                <table id="tblAccount" class="table table-responsive table-bordered table-striped" style="max-height: 300px; overflow-y: scroll; overflow-x: hidden;">
                                                    <thead>
                                                        <tr>
                                                            <th>Name</th>
                                                            <th>Last 4 Digit </th>
                                                            <th>Account No</th>
                                                            <th>Routing No</th>
                                                            <th>Action</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                    </tbody>
                                                </table>

                                            </div>

                                        </div>

                                        <div class="form-group row" style="margin-top: 10px;">
                                            <div class="col-sm-3">
                                                <label style="margin-right: 7px">
                                                    <input type="radio" id="Credit" name="card" class="flat-red" value="Credit" checked="checked" />
                                                    Credit Card
                                                </label>
                                            </div>
                                            <div class="col-sm-3">
                                                <label style="margin-right: 7px">
                                                    <input type="radio" name="card" value="Check" id="Checking" class="flat-red" />
                                                    Checking Account
                                                </label>
                                            </div>

                                        </div>
                                        <div class="form-group row">
                                            <div class="col-sm-12">
                                                <table class="table table-responsive" cellspacing="3" cellpadding="5" style="width: 100%">
                                                    <tbody style="padding: 5px;">
                                                        <tr>
                                                            <td colspan="3">
                                                                <div class="col-md-12">
                                                                    <label class="col-sm-6 control-label">*Name on Account:</label>

                                                                    <input type="text" id="nameAccountapp1Txt" class="nameAccountapp1Txt form-control col-sm-6" />
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="3">
                                                                <div class="col-md-12">
                                                                    <label class="col-sm-6 control-label">*Address:</label>

                                                                    <input type="text" id="addressapp1Txt1" class="form-control col-sm-6" />
                                                                </div>

                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="width:30%;">
                                                                <div class="col-md-12">
                                                                    <label class="col-sm-6 control-label">*City:</label>

                                                                    <input type="text" id="cityapp1Txt" class="form-control col-sm-6" />
                                                                </div>

                                                            </td>
                                                            <td class="width:40%;">
                                                                <div class="col-md-12">
                                                                    <label class="col-sm-6 control-label">*State:</label>
                                                                    <select id="ddlstateapp" class="form-control ddl col-sm-6"></select>
                                                                </div>
                                                            </td>


                                                            <td style="width: 30%;">
                                                                <div class="col-md-12">
                                                                    <label class="col-sm-6 control-label">*Zip code:</label>

                                                                    <input type="text" id="zipcodeapp1Txt" class="form-control col-sm-6" />
                                                                </div>

                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>

                                        </div>
                                        <div class="form-group row">
                                            <div class="col-sm-12">
                                                <table class="table table-responsive" cellspacing="3" cellpadding="5" style="width: 100%" id="tblCredit">
                                                    <tbody style="padding: 5px;">

                                                        <tr>
                                                            <td style="width: 40%;">
                                                                <div class="col-md-12">
                                                                    <label class="col-sm-6 control-label">*Credit Card Number:</label>
                                                                    <input id="creditcardapp1Txt" type="tel" name="ccnumber" placeholder="XXXX XXXX XXXX XXXX" pattern="\d{4} \d{4} \d{4} \d{4}" class="masked form-control col-sm-6" />

                                                                </div>
                                                            </td>


                                                            <td style="width: 30%;">
                                                                <div class="col-md-12">
                                                                    <label class="col-sm-6 control-label">*CVS Number:</label>

                                                                    <input type="text" id="cvsNumber" class="form-control col-sm-6" />
                                                                </div>

                                                            </td>
                                                            <td style="width: 30%;">
                                                                <div class="col-md-12">
                                                                    <label class="col-sm-6 control-label">*Expire Date:</label>

                                                                    <input style="width:100px;" type="tel" placeholder="MM/YYYY" class="masked" pattern="(1[0-2]|0[1-9])\/\d\d" data-valid-example="11/18" class="tDate form-control col-sm-3" id="txtExpire" />
                                                                </div>

                                                            </td>
                                                        </tr>

                                                    </tbody>
                                                </table>
                                            </div>

                                        </div>
                                        <div class="form-group row" style="width: 100%; display: none" id="tblCheck">
                                            <div class="col-sm-12">
                                                <div class="col-md-12">
                                                    <label class="col-sm-6 control-label">*Routing number (2nd from left):</label>

                                                    <input type="text" id="routingnumapp1Txt" class="form-control col-sm-6" />
                                                </div>
                                                <div class="col-md-12">
                                                    <label class="col-sm-6 control-label">*Re-Enter Routing number:</label>

                                                    <input type="text" id="rerountingnumapp1Txt" class="form-control col-sm-6" />
                                                </div>
                                                <div class="col-md-12">
                                                    <label class="col-sm-6 control-label">*Account number (last number from left):</label>

                                                    <input type="text" id="checkacctnumapp1Txt" class="form-control col-sm-6" />
                                                </div>
                                                <div class="col-md-12">
                                                    <label class="col-sm-6 control-label">*Re-Enter Account number:</label>

                                                    <input type="text" id="recheckacctnumapp1Txt" class="form-control col-sm-6" />
                                                </div>

                                            </div>

                                        </div>

                                        <div class="form-group row" style="margin-top:20px; float:left;width:100%;">
                                            <div class="col-sm-12">
                                                <input type="checkbox" id="chkAgree" value="" />
                                                <label for="chkAgree" class="control-label">I am authorize signed on the above information and authorize to debit my Credit Card or Checking account for the above amount.</label>
                                            </div>

                                        </div>
                                    </div>
                                </div>

                            </div>

                            <!-- /.box-body -->
                            <div class="box-footer">
                                <div class="col-md-12">
                                    <div class="col-md-3 btnSubmitDiv">
                                        <input type="button" class="btn btn-success" id="btnExit" style="background-color: #3B5998; float: left; margin-right: 20px;" value="< Back" />
                                    </div>
                                    <div class="col-md-3 btnSubmitDiv">
                                        <input type="button" class="btn btn-success" id="btnAdd" style="background-color: #3B5998; float: left; margin-right: 20px;" value="Add" />
                                    </div>
                                    <div class="col-md-3 btnSubmitDiv">
                                        <button id="btnSubmit"
                                            api_login_id="<%=api_loginID%>"
                                            method="sale"
                                            version_number="1.0"
                                            utc_time="<%=utc_time%>"
                                            card_number=""
                                            account_number=""
                                            expire=""
                                            cvv=""
                                            routing_number=""
                                            account_number2=""
                                            account_type=""
                                            billing_company_name=""
                                            billing_name=""
                                            billing_street_line1=""
                                            billing_street_line2=""
                                            billing_locality=""
                                            billing_region=""
                                            billing_postal_code=""
                                            billing_phone_number=""
                                            billing_email_address=""
                                            allowed_methods=""
                                            total_amount_attr="edit"
                                            signature="<%= pay_now_single_return_string%>"                                            
                                            total_amount="<%= sTotal%>"
                                            callback="oncallback"
                                            order_number="A1234"
                                            button_text="Confirm Payment"
                                            class="btnPaymentGetway">
                                            Pay Now
                                        </button>
                                    </div>
                                    <div class="col-md-3 btnSubmitDiv">
                                        <input type="button" class="btn btn-success" id="btnClear" style="background-color: #3B5998; float: left; margin-right: 20px;" value="Clear" />
                                    </div>
                                </div>
                            </div>
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

    <%--<!--Start of Tawk.to Script-->
    <script type="text/javascript">
        var Tawk_API = Tawk_API || {}, Tawk_LoadStart = new Date();
        (function () {
            var s1 = document.createElement("script"), s0 = document.getElementsByTagName("script")[0];
            s1.async = true;
            s1.src = 'https://embed.tawk.to/5e864cbe35bcbb0c9aad333f/default';
            s1.charset = 'UTF-8';
            s1.setAttribute('crossorigin', '*');
            s0.parentNode.insertBefore(s1, s0);
        })();
    </script>
    <!--End of Tawk.to Script-->--%>
</body>

</html>
