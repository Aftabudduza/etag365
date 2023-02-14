<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="rat.aspx.cs" Inherits="eTag365.rat" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<!DOCTYPE html>
<!--[if lt IE 7]> <html class="lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
<!--[if IE 7]>    <html class="lt-ie9 lt-ie8" lang="en"> <![endif]-->
<!--[if IE 8]>    <html class="lt-ie9" lang="en"> <![endif]-->
<!--[if gt IE 8]><!-->
<html lang="en">
<!--<![endif]-->
<head id="Head1" runat="server">
    <meta http-equiv="Page-Enter" content="blendTrans(Duration=0)" />
    <meta http-equiv="Page-Exit" content="blendTrans(Duration=0)" />
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="SKYPE_TOOLBAR" content="SKYPE_TOOLBAR_PARSER_COMPATIBLE" />
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <meta name="description" content="" />
    <meta name="author" content="" />
    <title>Rat Detection - Capture Time</title>

    <link rel="stylesheet" href="../Content/bootstrap.css" />
    <link rel="stylesheet" href="../Content/jquery-ui.css" />
    <link rel="stylesheet" href="../Content/toastr.css" />
    <link rel="stylesheet" href="../Content/font-awesome.css" />
    <link rel="stylesheet" href="../Content/ionicons/ionicons.css" />
    <link rel="stylesheet" href="../AdminLTE/css/AdminLTE.css" />
    <link rel="stylesheet" href="../AdminLTE/css/skins/_all-skins.css" />
    <link rel="stylesheet" href="../Content/admin.css" />
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


    <!-- Web Fonts -->
    <link href='https://fonts.googleapis.com/css?family=Open+Sans:400italic,700italic,400,700,300&amp;subset=latin,latin-ext' rel='stylesheet' type='text/css'>
    <link href='https://fonts.googleapis.com/css?family=PT+Serif' rel='stylesheet' type='text/css'>
    <link type="text/css" href="../scripts/notification/notification.css" rel="stylesheet" />
    <link href="../scripts/select2/dist/css/select2-bootstrap.css" rel="stylesheet" />
    <link href="../scripts/select2/dist/css/select2.css" rel="stylesheet" />
    <link type="text/css" href="../AdminLTE/iCheck/all.css" rel="stylesheet" />
    <link href="../css/Site.css" rel="stylesheet" />
    <link type="text/css" href="../Content/morris/morris.css" rel="stylesheet" />
    <link rel="stylesheet" href="../plugins/SlickNav/slicknav.css" />

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
        .input-validation-error {
            border: 1px solid #ff0000;
            background-color: #ffeeee !important;
        }

        .field-validation-error {
            color: #ff0000 !important;
        }

        .control-label {
            float: left;
        }

        .col-sm-3 {
            padding-left: 0px;
        }

        .col-sm-6 {
            padding-left: 0px;
            padding-right: 0px;
        }

        .col-md-4 {
            padding-left: 0px;
        }

        .col-md-3 {
            float: left;
            padding-left: 10px;
        }

        label {
            margin-bottom: 0px;
        }
    </style>

</head>
<body class="hold-transition skin-blue sidebar-mini fixed">
    <!-- Site wrapper -->
    <div class="wrapper">
        <!-- =============================================== -->
        <!-- Left side column. contains the sidebar -->
        <!-- =============================================== -->
        <!-- Content Wrapper. Contains page content -->
        <div class="content-wrapper">
            <!-- Main content -->
            <section class="content" style="padding: 5px 0;">
                <form id="form1" runat="server" class="form-horizontal">
                    <asp:ScriptManager runat="server" ID="sc1">
                    </asp:ScriptManager>
                    <asp:UpdatePanel runat="server" ID="UpdatePanel8" UpdateMode="Conditional">
                        <ContentTemplate>
                            <div class="box">
                                <div class="box-header with-border CommonHeader col-md-12">
                                    <h3 class="box-title" id="lblHeadline" runat="server">Rat Detect Time</h3>
                                </div>

                                <div class="box-body">

                                    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ appSettings:ConnectionString %>"
                                        SelectCommand=" select Id, CONVERT(varchar,cast(starttime as datetime),20) starttime, CONVERT(varchar,cast(endtime as datetime),20) endtime, isnull(filepath,'') filepath from rat_transaction order by id desc  "></asp:SqlDataSource>

                                </div>


                                <div class="box-body">
                                    <asp:GridView Width="100%" DataSourceID="SqlDataSource1" ID="gvContactList" runat="server" AutoGenerateColumns="False" CellPadding="10" ForeColor="#333333" CssClass="table table-bordered table-striped"
                                        GridLines="None" AllowPaging="True" PageSize="200" Style="float: left; margin-bottom: 10px;" AllowSorting="True">
                                        <PagerSettings Position="TopAndBottom" />
                                        <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                                        <Columns>

                                            <asp:TemplateField HeaderText="Start" SortExpression="Data">
                                                <ItemTemplate>
                                                   <%-- <asp:Label runat="server" Text='<%# Eval("Starttime") %>'></asp:Label>--%>
                                                     <asp:Label runat="server" Text='<%#DataBinder.Eval(Container.DataItem, "Starttime", "{0:MM/dd/yyyy hh:mm:ss tt}")%>'></asp:Label>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" ForeColor="Black" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="End" SortExpression="Data">
                                                <ItemTemplate>
                                                   <%-- <asp:Label runat="server" Text='<%# Eval("EndTime") %>'></asp:Label>--%>
                                                     <asp:Label runat="server" Text='<%#DataBinder.Eval(Container.DataItem, "EndTime", "{0:MM/dd/yyyy hh:mm:ss tt}")%>'></asp:Label>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" ForeColor="Black" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="File" SortExpression="Data">
                                                <ItemTemplate>
                                                    <%--<asp:Label runat="server" Text='<%# Eval("filepath") %>'></asp:Label>--%>
                                                    <asp:Image runat="server" Style="width: 60px; margin-bottom: 10px; border-width: 0px;" alt='' src='<%# Eval("filepath", "../Images/Rat/{0}") %>' />

                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" ForeColor="Black" />
                                            </asp:TemplateField>

                                             <asp:TemplateField HeaderText="Url" SortExpression="Data">
                                                <ItemTemplate>
                                                    <asp:HyperLink Target="_blank" runat="server" class="col-sm-12 control-label" Style="float: left; color:#337ab7;" NavigateUrl='<%# Eval("filepath", "../Images/Rat/{0}") %>' Text='View File' />

                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" ForeColor="Black" />
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
                                </div>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </form>
            </section>
            <!-- /.content -->
        </div>
        <!-- /.content-wrapper -->

    </div>
    <!-- ./wrapper -->



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
        function ShowProgress() {
            setTimeout(function () {
                var Waitmodal = $('<div />');
                Waitmodal.addClass("Waitmodal");
                $('body').append(Waitmodal);
                var Waitloading = $(".Waitloading");
                Waitloading.show();
                var top = Math.max($(window).height() / 2 - Waitloading[0].offsetHeight / 2, 0);
                var left = Math.max($(window).width() / 2 - Waitloading[0].offsetWidth / 2, 0);
                Waitloading.css({ top: top, left: left });
            }, 0);
        }

        function HideProgress() {
            var Waitmodal = $(".Waitmodal");
            Waitmodal.hide();
            var Waitloading = $(".Waitloading");
            Waitloading.hide();
        }

        function ShowMessageT(msg) {

            alert(msg);
        }

    </script>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/themes/smoothness/jquery-ui.css" />
    <script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js"></script>
    <script type="text/javascript">
        $(function () {
            $(".datepicker").datepicker({
                dateFormat: 'dd-MM-yy',
                changeMonth: true,
                changeYear: true
            });
        });

        function CheckVal() {
            if (typeof (Page_ClientValidate) == 'function') {
                Page_ClientValidate();
            }
        }
    </script>



</body>
</html>

