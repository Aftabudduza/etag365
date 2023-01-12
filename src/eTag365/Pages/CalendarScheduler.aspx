<%@ Page Title="eTag365: Free Event Calendar with User" Language="C#" AutoEventWireup="true" EnableEventValidation="false" CodeBehind="CalendarScheduler.aspx.cs" Inherits="eTag365.Pages.CalendarScheduler" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<%@ Register TagPrefix="MyHeader" TagName="HeaderControl" Src="~/UserControls/Header.ascx" %>
<%@ Register TagPrefix="MyMenu" TagName="MenuControl" Src="~/UserControls/Menu.ascx" %>
<%@ Register TagPrefix="MyFooter" TagName="FooterControl" Src="~/UserControls/Footer.ascx" %>
<%@ Register TagPrefix="MyWait" TagName="WaitControl" Src="~/UserControls/Wait.ascx" %>


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
    <title>eTag365</title>

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
        <MyHeader:HeaderControl ID="Header1" runat="server" />
        <!-- =============================================== -->
        <!-- Left side column. contains the sidebar -->
        <MyMenu:MenuControl ID="LeftMenu" runat="server" />
        <!-- =============================================== -->
        <!-- Content Wrapper. Contains page content -->
        <div class="content-wrapper">
            <!-- Main content -->
            <section class="content" style="padding: 5px 0;">
                <form id="form1" runat="server" class="form-horizontal">
                    <asp:ToolkitScriptManager runat="server" ID="sc1">
                    </asp:ToolkitScriptManager>
                    <asp:UpdatePanel runat="server" ID="UpdatePanel8" UpdateMode="Conditional">
                        <ContentTemplate>
                            <div class="box">
                                <!-- left column -->
                                <div class="col-md-12" style="padding-left: 0px; padding-right: 0px">
                                    <!-- general form elements -->
                                    <div class="box box-primary">
                                        <div class="box-header with-border CommonHeader col-md-12">
                                            <h3 class="box-title" id="lblHeadline" runat="server">Free Event Calendar with User</h3>
                                        </div>
                                        <!-- /.box-header -->
                                        <!-- form start -->
                                        <div class="box-body">
                                            <div class="col-md-12" style="padding-left: 5px; padding-bottom: 15px; float: left;">
                                                <label id="Label1" runat="server" class="col-sm-3 control-label">Schedule Appointment with </label>
                                                <label id="lblUserName" runat="server" class="col-sm-3 control-label"></label>
                                                <label id="lblUserEmail" runat="server" class="col-sm-3 control-label"></label>
                                                <asp:HiddenField ID="hdUserId" runat="server" Value="" />
                                            </div>

                                            <div class="col-md-6" style="padding-left: 5px;">
                                                <asp:TextBox ID="txtFName" runat="server" CssClass="form-control" Placeholder="Enter Your First Name" />
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" Display="Dynamic" ControlToValidate="txtFName" ValidationGroup="Contact"
                                                    runat="server" ErrorMessage="First Name Required" ForeColor="Red"></asp:RequiredFieldValidator>
                                            </div>
                                            <div class="col-md-6" style="padding-left: 5px;">
                                                <asp:TextBox ID="txtLName" runat="server" CssClass="form-control" Placeholder="Enter Your Last Name" />
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator7" Display="Dynamic" ControlToValidate="txtLName" ValidationGroup="Contact"
                                                    runat="server" ErrorMessage="Last Name Required" ForeColor="Red"></asp:RequiredFieldValidator>
                                            </div>
                                            <div class="col-md-6" style="padding-left: 5px;">
                                                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" Placeholder="Enter Your Email Address"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" ControlToValidate="txtEmail" ValidationGroup="Contact"
                                                    runat="server" ErrorMessage="Email Address Required" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                                                <asp:RegularExpressionValidator Display="Dynamic" ID="RegularExpressionValidator2" ValidationGroup="Contact"
                                                    runat="server" ErrorMessage="Invalid Email" ForeColor="Red" ControlToValidate="txtEmail" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>

                                            </div>
                                            <div class="col-md-6" style="padding-left: 5px;">
                                                <asp:TextBox ID="txtNumber" runat="server" CssClass="form-control" Placeholder="Enter Your Phone number" MaxLength="20"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" ControlToValidate="txtNumber" ValidationGroup="Contact"
                                                    Display="Dynamic" runat="server" ErrorMessage="Cell Number Required" ForeColor="Red"></asp:RequiredFieldValidator>
                                                <asp:RegularExpressionValidator Display="Dynamic" ID="RegularExpressionValidator26" ValidationGroup="Contact"
                                                    runat="server" ErrorMessage="Invalid Cell Number" ForeColor="Red" ControlToValidate="txtNumber" ValidationExpression="^(?=(?:\D*\d){10,18}\D*$)(?:\(?0?[0-9]{1,3}\)?|\+?[0-9]{1,3})[\s-]?(?:\(0?[0-9]{1,5}\)|[0-9]{1,5})[-\s]?[0-9][\d\s-]{5,7}\s?(?:x[\d-]{0,4})?(?:[-\s]?[0-9]{1,4}|[-\s])$"></asp:RegularExpressionValidator>

                                            </div>
                                            <div class="col-md-6" style="padding-left: 5px;">
                                                <asp:TextBox ID="txtNotes" TextMode="MultiLine" Rows="3" runat="server" CssClass="form-control" Placeholder="Any Comments" />

                                            </div>
                                            <div class="col-md-6" style="padding-left: 5px;">
                                                <asp:TextBox ID="txtCompany" runat="server" CssClass="form-control" Placeholder="Enter Company Name" />

                                            </div>
                                        </div>

                                        <div class="box-body">
                                            <div class="col-md-4" style="float: left; padding-left: 10px;">
                                                <label class="control-label">Enter Date to schedule Meeting or click on the Calendar:</label>
                                            </div>
                                            <div class="col-md-3" style="float: left;">
                                                <asp:TextBox ID="txtDate" runat="server" CssClass="form-control" AutoPostBack="true" OnTextChanged="txtDate_TextChanged" />
                                                <asp:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtDate"
                                                    Format="MM-dd-yyyy">
                                                </asp:CalendarExtender>
                                            </div>


                                            <div class="col-md-9" style="float: left; padding-top: 10px;">
                                                <label class="control-label">Click on checkbox of a (AVL) available time and claim it for your appointment. You can only set up one appointment at a time.</label>
                                            </div>
                                            <div class="col-md-3" style="float: left; padding-top: 10px;">
                                                Timezone: <span id="spanTimezone" style="width: 100px;" runat="server"></span>
                                            </div>

                                        </div>

                                    </div>
                                </div>
                                <div class="col-md-12">
                                    <asp:CheckBoxList ID="chk101" runat="server" RepeatDirection="Horizontal">
                                        <asp:ListItem Text="00:00 am" Value="00:00" />
                                        <asp:ListItem Text="00:15 am" Value="00:15" />
                                        <asp:ListItem Text="00:30 am" Value="00:30" />
                                        <asp:ListItem Text="00:45 am" Value="00:45" />
                                        <asp:ListItem Text="01:00 am" Value="01:00" />
                                        <asp:ListItem Text="01:15 am" Value="01:15" />
                                        <asp:ListItem Text="01:30 am" Value="01:30" />
                                        <asp:ListItem Text="01:45 am" Value="01:45" />
                                        <asp:ListItem Text="02:00 am" Value="02:00" />
                                        <asp:ListItem Text="02:15 am" Value="02:15" />
                                        <asp:ListItem Text="02:30 am" Value="02:30" />
                                        <asp:ListItem Text="02:45 am" Value="02:45" />
                                    </asp:CheckBoxList>
                                    <asp:CheckBoxList ID="chk102" runat="server" RepeatDirection="Horizontal">

                                        <asp:ListItem Text="03:00 am" Value="03:00" />
                                        <asp:ListItem Text="03:15 am" Value="03:15" />
                                        <asp:ListItem Text="03:30 am" Value="03:30" />
                                        <asp:ListItem Text="03:45 am" Value="03:45" />
                                        <asp:ListItem Text="04:00 am" Value="04:00" />
                                        <asp:ListItem Text="04:15 am" Value="04:15" />
                                        <asp:ListItem Text="04:30 am" Value="04:30" />
                                        <asp:ListItem Text="04:45 am" Value="04:45" />
                                        <asp:ListItem Text="05:00 am" Value="05:00" />
                                        <asp:ListItem Text="05:15 am" Value="05:15" />
                                        <asp:ListItem Text="05:30 am" Value="05:30" />
                                        <asp:ListItem Text="05:45 am" Value="05:45" />

                                    </asp:CheckBoxList>

                                    <asp:CheckBoxList ID="chk103" runat="server" RepeatDirection="Horizontal">

                                        <asp:ListItem Text="06:00 am" Value="06:00" />
                                        <asp:ListItem Text="06:15 am" Value="06:15" />
                                        <asp:ListItem Text="06:30 am" Value="06:30" />
                                        <asp:ListItem Text="06:45 am" Value="06:45" />
                                        <asp:ListItem Text="07:00 am" Value="07:00" />
                                        <asp:ListItem Text="07:15 am" Value="07:15" />
                                        <asp:ListItem Text="07:30 am" Value="07:30" />
                                        <asp:ListItem Text="07:45 am" Value="07:45" />
                                        <asp:ListItem Text="08:00 am" Value="08:00" />
                                        <asp:ListItem Text="08:15 am" Value="08:15" />
                                        <asp:ListItem Text="08:30 am" Value="08:30" />
                                        <asp:ListItem Text="08:45 am" Value="08:45" />

                                    </asp:CheckBoxList>
                                    <asp:CheckBoxList ID="chk104" runat="server" RepeatDirection="Horizontal">

                                        <asp:ListItem Text="09:00 am" Value="09:00" />
                                        <asp:ListItem Text="09:15 am" Value="09:15" />
                                        <asp:ListItem Text="09:30 am" Value="09:30" />
                                        <asp:ListItem Text="09:45 am" Value="09:45" />
                                        <asp:ListItem Text="10:00 am" Value="10:00" />
                                        <asp:ListItem Text="10:15 am" Value="10:15" />
                                        <asp:ListItem Text="10:30 am" Value="10:30" />
                                        <asp:ListItem Text="10:45 am" Value="10:45" />
                                        <asp:ListItem Text="11:00 am" Value="11:00" />
                                        <asp:ListItem Text="11:15 am" Value="11:15" />
                                        <asp:ListItem Text="11:30 am" Value="11:30" />
                                        <asp:ListItem Text="11:45 am" Value="11:45" />

                                    </asp:CheckBoxList>

                                    <asp:CheckBoxList ID="chk105" runat="server" RepeatDirection="Horizontal">

                                        <asp:ListItem Text="12:00 pm" Value="12:00" />
                                        <asp:ListItem Text="12:15 pm" Value="12:15" />
                                        <asp:ListItem Text="12:30 pm" Value="12:30" />
                                        <asp:ListItem Text="12:45 pm" Value="12:45" />
                                        <asp:ListItem Text="01:00 pm" Value="13:00" />
                                        <asp:ListItem Text="01:15 pm" Value="13:15" />
                                        <asp:ListItem Text="01:30 pm" Value="13:30" />
                                        <asp:ListItem Text="01:45 pm" Value="13:45" />
                                        <asp:ListItem Text="02:00 pm" Value="14:00" />
                                        <asp:ListItem Text="02:15 pm" Value="14:15" />
                                        <asp:ListItem Text="02:30 pm" Value="14:30" />
                                        <asp:ListItem Text="02:45 pm" Value="14:45" />

                                    </asp:CheckBoxList>

                                    <asp:CheckBoxList ID="chk106" runat="server" RepeatDirection="Horizontal">

                                        <asp:ListItem Text="03:00 pm" Value="15:00" />
                                        <asp:ListItem Text="03:15 pm" Value="15:15" />
                                        <asp:ListItem Text="03:30 pm" Value="15:30" />
                                        <asp:ListItem Text="03:45 pm" Value="15:45" />
                                        <asp:ListItem Text="04:00 pm" Value="16:00" />
                                        <asp:ListItem Text="04:15 pm" Value="16:15" />
                                        <asp:ListItem Text="04:30 pm" Value="16:30" />
                                        <asp:ListItem Text="04:45 pm" Value="16:45" />
                                        <asp:ListItem Text="05:00 pm" Value="17:00" />
                                        <asp:ListItem Text="05:15 pm" Value="17:15" />
                                        <asp:ListItem Text="05:30 pm" Value="17:30" />
                                        <asp:ListItem Text="05:45 pm" Value="17:45" />

                                    </asp:CheckBoxList>

                                    <asp:CheckBoxList ID="chk107" runat="server" RepeatDirection="Horizontal">

                                        <asp:ListItem Text="06:00 pm" Value="18:00" />
                                        <asp:ListItem Text="06:15 pm" Value="18:15" />
                                        <asp:ListItem Text="06:30 pm" Value="18:30" />
                                        <asp:ListItem Text="06:45 pm" Value="18:45" />
                                        <asp:ListItem Text="07:00 pm" Value="19:00" />
                                        <asp:ListItem Text="07:15 pm" Value="19:15" />
                                        <asp:ListItem Text="07:30 pm" Value="19:30" />
                                        <asp:ListItem Text="07:45 pm" Value="19:45" />
                                        <asp:ListItem Text="08:00 pm" Value="20:00" />
                                        <asp:ListItem Text="08:15 pm" Value="20:15" />
                                        <asp:ListItem Text="08:30 pm" Value="20:30" />
                                        <asp:ListItem Text="08:45 pm" Value="20:45" />

                                    </asp:CheckBoxList>

                                    <asp:CheckBoxList ID="chk108" runat="server" RepeatDirection="Horizontal">

                                        <asp:ListItem Text="09:00 pm" Value="21:00" />
                                        <asp:ListItem Text="09:15 pm" Value="21:15" />
                                        <asp:ListItem Text="09:30 pm" Value="21:30" />
                                        <asp:ListItem Text="09:45 pm" Value="21:45" />
                                        <asp:ListItem Text="10:00 pm" Value="22:00" />
                                        <asp:ListItem Text="10:15 pm" Value="22:15" />
                                        <asp:ListItem Text="10:30 pm" Value="22:30" />
                                        <asp:ListItem Text="10:45 pm" Value="22:45" />
                                        <asp:ListItem Text="11:00 pm" Value="23:00" />
                                        <asp:ListItem Text="11:15 pm" Value="23:15" />
                                        <asp:ListItem Text="11:30 pm" Value="23:30" />
                                        <asp:ListItem Text="11:45 pm" Value="23:45" />

                                    </asp:CheckBoxList>

                                </div>
                                <div class="box-footer">
                                    <div class="col-md-6 btnSubmitDiv">
                                        <asp:Button ID="btnSave" runat="server" Text="Click to set the appointment" OnClientClick="CheckVal()" CssClass="btn btn-successNew" OnClick="btnSubmit_Click" />
                                    </div>

                                    <div class="col-md-3 btnSubmitDiv">
                                        <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-success" OnClick="btnClose_Click" />
                                    </div>
                                </div>
                                <div class="col-md-12" style="padding-left: 30px;">
                                    <a href="https://etag365.net/" target="_blank" style="color: red;">Click here to get your own free Event Colander Scheduler to use in your emails, Linkedin and Facebook Posts.
                                        <br />
                                        You must register as eTag365 User. It's free. No Credit Card required.</a>
                                </div>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </form>
            </section>
            <!-- /.content -->
        </div>
        <!-- /.content-wrapper -->
        <MyFooter:FooterControl ID="Footer" runat="server" />

    </div>
    <!-- ./wrapper -->

    <MyWait:WaitControl ID="Wait" runat="server" />


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



    <!--Start of Tawk.to Script-->
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
    <!--End of Tawk.to Script-->

</body>
</html>


