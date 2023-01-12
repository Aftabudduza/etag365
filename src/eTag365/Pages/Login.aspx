<%@ Page Language="C#" AutoEventWireup="true" Title="eTag365: Login" EnableEventValidation="false" CodeBehind="Login.aspx.cs" Inherits="eTag365.Pages.Login" %>

<!DOCTYPE html>
<!--[if lt IE 7]> <html class="lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
<!--[if IE 7]>    <html class="lt-ie9 lt-ie8" lang="en"> <![endif]-->
<!--[if IE 8]>    <html class="lt-ie9" lang="en"> <![endif]-->
<!--[if gt IE 8]><!-->
<html lang="en">
<!--<![endif]-->
<head>
    <style type="text/css">
        #log-header img {
            margin: auto;
            position: relative;
        }

        #log-header {
            margin: autohh;
            position: relative;
            text-align: center;
            width: 100%;
        }

            #log-header p {
                color: #7ac142;
                font-weight: bold;
                line-height: 30px;
                padding: 20px 0;
                text-align: center;
                font-size: 24px;
            }

        body {
            background: none repeat scroll 0 0 #fff !important;
            color: #444 !important;
            padding: 20px 0 100px !important;
        }

        .bg_input {
            clear: both;
            outline: none;
            background: #fff !important;
        }
    </style>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="SKYPE_TOOLBAR" content="SKYPE_TOOLBAR_PARSER_COMPATIBLE" />
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <meta name="description" content="" />
    <meta name="author" content="" />
    <!-- Bootstrap Stylesheet -->
    <link href="../Content/bootstrap.css" rel="stylesheet">
    <!-- Ionicons -->
    <link rel="stylesheet" href="../Content/ionicons/ionicons.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="../AdminLTE/css/AdminLTE.css">
    <link rel="stylesheet" href="../Content/plugins/uniform/css/uniform.default.css" media="screen">
    <!-- Plugin Stylsheets first to ease overrides -->
    <!-- Main Layout Stylesheet -->
    <link rel="stylesheet" href="../css/login.css" media="screen">
    <!-- Font Awesome -->
    <link href="../Content/font-awesome.css" rel="stylesheet">
    <!-- Custom Theme Style -->
    <link href="../Content/custom.min.css" rel="stylesheet">
    <link href="../Content/style.css" rel="stylesheet">
    <title>eTag365 Login</title>

</head>
<body class="login" style="background-color: #fff;">
    <div id="log-header">
        <img alt="Logo" src="../Images/logo.png" id="login-logo" />
    </div>
    <div id="login-wrap">
        <div id="login-buttons">
        </div>
        <div id="login-inner" class="login-inset">
            <div id="login-circle">
                <section id="login-form" class="login-inner-form" data-angle="0">
                    <form id="form1" runat="server" class="form-vertical">
                        <div class="control-group-merged">
                            <div class="control-group" style="background: #fff;">
                                <asp:DropDownList ID="ddlCountry" CssClass="col-sm-6 span12 form-control" runat="server">
                                </asp:DropDownList>
                                <asp:TextBox ID="txtPhone" placeholder="Enter Cell Number e.g 123-456-7890" runat="server" CssClass="col-sm-6 span12 input-username" MaxLength="10" Height="38" ValidationGroup="Login"></asp:TextBox>

                            </div>
                        </div>
                        <div class="control-group" style="text-align: center;">
                            <asp:RequiredFieldValidator Display="Dynamic" ID="countrytype" runat="server" ControlToValidate="ddlCountry" InitialValue="-1"
                                ErrorMessage="Please select Country" ForeColor="Red" ValidationGroup="Login"></asp:RequiredFieldValidator>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator4" ControlToValidate="txtPhone" ValidationGroup="Login"
                                Display="Dynamic" runat="server" ErrorMessage="Phone Number Required" ForeColor="Red"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator Display="Dynamic" ID="RegularExpressionValidator2" ValidationGroup="Login"
                                runat="server" ErrorMessage="Invalid Cell Number" ForeColor="Red" ControlToValidate="txtPhone" ValidationExpression="^(?=(?:\D*\d){10,18}\D*$)(?:\(?0?[0-9]{1,3}\)?|\+?[0-9]{1,3})[\s-]?(?:\(0?[0-9]{1,5}\)|[0-9]{1,5})[-\s]?[0-9][\d\s-]{5,7}\s?(?:x[\d-]{0,4})?(?:[-\s]?[0-9]{1,4}|[-\s])$"></asp:RegularExpressionValidator>

                            <asp:Label ID="lblError" runat="server" ForeColor="Red"></asp:Label>
                        </div>
                        <div class="control-group">
                            <asp:Button ID="btnLogin" runat="server" Text="Next" OnClick="btnLogin_Click" OnClientClick="CheckVal()" CssClass="btn btn-success btn-block btn-large" ValidationGroup="Login" Style="margin-left: 0px; margin-top: 10px; float: left;" />
                        </div>
                        <div class="control-group" style="text-align: center;">
                            <p>For a Free etag365 Account Contact Listing Login <br /><a style="float:left; font-size:10px; margin: 10px 0 0; color:red; font-weight:bold; background-color:lightgrey;" target="_blank" href="https://etag365.com/deal/">ONE PAGE REGISTRATION AND PURCHASE A YEARLY PLAN. CLICK ON THIS LINK</a></p>
                        </div>
                        <div class="clearfix"></div>
                        <div class="separator" style="margin-top: 10px;">
                            <div class="login_footer" style="text-align: center;">
                                <h1 style="margin-bottom: 20px;"><i class="fa fa-paw"></i>eTag365
                                </h1>
                                <p>Copyright &copy; 2019 - <span id="spanYear" runat="server"></span><a style="margin-left: 5px;" target="_blank" href="https://etag365.com/">eTag365</a>. All rights reserved.</p>

                                <div class="clearfix"></div>
                            </div>
                        </div>

                    </form>
                </section>

            </div>
        </div>

    </div>

    <!-- Core Scripts -->
    <script type="text/javascript" src="../scripts/jquery-1.8.3.min.js"></script>
    <script type="text/javascript" src="../scripts/jquery-3.3.1.min.js"></script>
    <script type="text/javascript" src="../scripts/jquery.placeholder.min.js"></script>
    <script type="text/javascript" src="../scripts/bootstrap.js"></script>
    <!-- Login Script -->
    <script type="text/javascript" src="../scripts/login.js"></script>

    <!-- Validation -->

    <script type="text/javascript" src="../scripts/jquery.validate.min.js"></script>
    <script type="text/javascript" src="../Scripts/jquery.validate.unobtrusive.min.js"></script>

    <script type="text/javascript">
        function CheckVal() {
            if (typeof (Page_ClientValidate) == 'function') {
                Page_ClientValidate();
            }
        }

    </script>

</body>
</html>
