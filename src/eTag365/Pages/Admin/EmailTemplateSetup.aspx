<%@ Page Title="eTag365: Create/Change Email Template" Language="C#" AutoEventWireup="true" ValidateRequest="false" Debug="true" EnableEventValidation="false" CodeBehind="EmailTemplateSetup.aspx.cs" Inherits="eTag365.Pages.Admin.EmailTemplateSetup" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

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
    <title>eTag365: Create/Change Email Template</title>

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
    <link href="../../css/Site.css" rel="stylesheet" />
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
    <script type="text/javascript" src="../../plugins/SlickNav/jquery.slicknav.min.js"></script>
    <script type="text/javascript" src="../../scripts/jquery.dataTables.min.js"></script>
    <script type="text/javascript" src="../../AppJs/CommonJS/DataBaseOperationJs.js"></script>

    <script type="text/javascript" src="https://cdn.tiny.cloud/1/71tq2hslv54vdkev75azit8669a7c86rk1b49hxelnj7cbpd/tinymce/5/tinymce.min.js" referrerpolicy="origin"></script>
    <script type="text/javascript">
        tinymce.init({
            selector: "#txtContent",
            plugins: 'print preview paste importcss searchreplace autolink autosave save directionality code visualblocks visualchars fullscreen image link media template codesample table charmap hr pagebreak nonbreaking anchor toc insertdatetime advlist lists wordcount imagetools textpattern noneditable help charmap quickbars emoticons',
            //  plugins: 'a11ychecker advcode casechange formatpainter linkchecker autolink lists checklist media mediaembed pageembed permanentpen powerpaste table advtable tinycomments tinymcespellchecker',
            //  toolbar: 'a11ycheck addcomment showcomments casechange checklist code formatpainter pageembed permanentpen table',
            toolbar: 'undo redo | bold italic underline strikethrough | fontselect fontsizeselect formatselect | alignleft aligncenter alignright alignjustify | outdent indent |  numlist bullist | forecolor backcolor removeformat | pagebreak | charmap emoticons | fullscreen  preview save print | insertfile image media template link anchor codesample | ltr rtl',
            toolbar_mode: 'floating',
            tinycomments_mode: 'embedded',
            tinycomments_author: 'Author name',
        });
    </script>
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
    <script type="text/javascript">
        function show_confirm() {
            var r = confirm("Are You Sure To Delete?");
            if (r) {
                return true;
            }
            else {
                return false;
            }
        }

        function CheckVal() {
            if (typeof (Page_ClientValidate) == 'function') {
                Page_ClientValidate();
            }
        }

    </script>
    <style type="text/css">
        .input-validation-error {
            border: 1px solid #ff0000;
            background-color: #ffeeee !important;
        }

        .field-validation-error {
            color: #ff0000 !important;
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
                            <h3 class="box-title" id="lblHeadline" runat="server">Create/Change Email Template </h3>
                        </div>
                        <asp:ScriptManager runat="server" ID="sc2">
                        </asp:ScriptManager>

                        <!-- left column -->
                        <div class="col-md-12">
                            <!-- general form elements -->
                            <div class="box box-primary">
                                <!-- /.box-header -->
                                <%--<asp:UpdatePanel ID="upnlImageVideoUp" runat="server">
                                    <ContentTemplate>--%>
                                <!-- form start -->
                                <div class="box-body">
                                    <div class="form-group">
                                        <div class="col-md-6">
                                            <asp:DropDownList ID="ddlUser" CssClass="form-control" runat="server">
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                </div>

                                <div class="box-body">
                                    <form class="vertical-form">
                                        <fieldset>
                                            <asp:GridView Width="100%" ID="gvContactList" runat="server" AutoGenerateColumns="False" CellPadding="10" ForeColor="#333333" CssClass="table table-responsive table-bordered table-striped"
                                                GridLines="None" AllowPaging="True" OnPageIndexChanging="gvContactList_PageIndexChanging"
                                                OnSorting="gvContactList_Sorting" PageSize="20" Style="float: left; margin-bottom: 10px;" AllowSorting="True">
                                                <PagerSettings Position="TopAndBottom" />
                                                <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                                                <Columns>
                                                    <asp:TemplateField HeaderText="Template Number" SortExpression="Data">
                                                        <ItemTemplate>
                                                            <asp:Label ID="Label1" runat="server" Text='<%# Eval("TemplateNo") %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                                                    </asp:TemplateField>

                                                    <asp:TemplateField HeaderText="Subject" SortExpression="Data">
                                                        <ItemTemplate>
                                                            <asp:Label ID="Label2" runat="server" Text='<%# Eval("Subject") %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                                                    </asp:TemplateField>

                                                    <asp:TemplateField HeaderText="Category" SortExpression="Data">
                                                        <ItemTemplate>
                                                            <asp:Label ID="Label4" runat="server" Text='<%# Eval("Category") %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Types" SortExpression="Data">
                                                        <ItemTemplate>
                                                            <asp:Label ID="Label14" runat="server" Text='<%# Eval("Type") %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Action" ItemStyle-HorizontalAlign="Left">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblTemplateId" runat="server" Text='<%# Eval("Id") %>' Visible="false"></asp:Label>
                                                            <asp:LinkButton ID="btnDelete" runat="server" OnClientClick='return confirm("Are you sure you want to delete?");' Text="Delete" OnClick="btnDelete_Click"></asp:LinkButton>
                                                            <asp:LinkButton ID="btnEdit" runat="server" Text="Edit" OnClick="btnEdit_Click"></asp:LinkButton>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />

                                                        <ItemStyle HorizontalAlign="Left"></ItemStyle>
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

                                <div class="box-body">
                                    <div class="col-md-6">
                                        <label for="ddlNo" class="col-sm-6 control-label" style="float: left;">Template No (0-12):</label>
                                        <div class="col-sm-6">
                                            <asp:DropDownList ID="ddlNo" AutoPostBack="true" OnSelectedIndexChanged="ddlNo_SelectedIndexChanged" CssClass="form-control" runat="server">
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="col-sm-12 control-label" style="float: left;">&nbsp;</label>
                                    </div>
                                </div>
                                <div class="box-body">
                                    <div class="col-md-6">
                                        <label for="ddlCategory" class="col-sm-6 control-label" style="float: left;">Category:</label>
                                        <div class="col-sm-3">
                                            <asp:DropDownList ID="ddlCategory" CssClass="form-control" runat="server">
                                                <asp:ListItem Value="-1">None</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                        <asp:HyperLink ID="HyperLink1" runat="server" class="col-sm-2 btn btn-success" NavigateUrl="~/system?Cat=1" Text="Add" />
                                    </div>

                                    <div class="col-md-6">
                                        <label for="ddlType" class="col-sm-6 control-label" style="float: left;">Types:</label>
                                        <div class="col-sm-3">
                                            <asp:DropDownList ID="ddlType" CssClass="form-control" runat="server">
                                                <asp:ListItem Value="-1">N/A</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                        <asp:HyperLink ID="HyperLink2" runat="server" class="col-sm-2 btn btn-success" NavigateUrl="~/system?C=1" Text="Add" />
                                    </div>

                                </div>
                                <div class="box-body">
                                    <div class="col-md-6">
                                        <div class="col-sm-12">
                                            <asp:TextBox ID="txtSubject" placeholder="Subject" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="col-sm-6">
                                            <asp:TextBox ID="txtGreetings" placeholder="e.g Hi, Hey, Dear" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>


                                <div class="box-body">
                                    <div class="col-md-12">
                                        <div class="col-sm-12">
                                            <asp:TextBox ID="txtContent" placeholder="Body" TextMode="MultiLine" Height="400" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                    </div>

                                    <%-- <script type="text/javascript">

                                        SetEditor();

                                        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(EndRequestHandler);

                                        function EndRequestHandler(sender, args) {
                                            // this will execute on partial postback
                                            SetEditor();
                                        }
                                    </script>--%>
                                </div>

                                <div class="box-body">
                                    <div class="col-md-12">
                                        <div class="col-md-6 btnSubmitDiv">
                                            <asp:Button ID="btnSaveEmail" runat="server" Text="Save" OnClick="btnSaveEmail_Click" CssClass="btn btn-successNew" />
                                        </div>
                                        <div class="col-md-6 btnSubmitDiv">
                                            <asp:Button ID="btnBack33" runat="server" Text="Cancel" OnClick="btnBack33_Click" CssClass="btn btn-success " />
                                        </div>
                                    </div>
                                    <div class="col-md-12">
                                        <div class="col-sm-12">
                                            <asp:Label ID="lblMessageNew" ForeColor="Green" Font-Bold="true" Font-Size="Large" runat="server"></asp:Label>
                                        </div>
                                    </div>
                                </div>

                                <%--</ContentTemplate>
                                </asp:UpdatePanel>--%>
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

