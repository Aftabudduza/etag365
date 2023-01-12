<%@ Page Language="C#" Title="eTag365: Login" AutoEventWireup="true" EnableEventValidation="false" CodeBehind="Login2.aspx.cs" Inherits="eTag365.Pages.Login2" %>


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
            margin: auto;
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

    <link rel="stylesheet" href="../Content/plugins/uniform/css/uniform.default.css"
        media="screen">
    <!-- Plugin Stylsheets first to ease overrides -->
    <!-- End Plugin Stylesheets -->
    <!-- Main Layout Stylesheet -->
    <link rel="stylesheet" href="../css/login.css" media="screen">
    <!-- Font Awesome -->
    <link href="../Content/font-awesome.css" rel="stylesheet">
    <!-- Custom Theme Style -->
    <link href="../Content/custom.min.css" rel="stylesheet">
    <link href="../Content/style.css" rel="stylesheet">

    <!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
<script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
<![endif]-->
    <!-- Google Font -->
  <%--  <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,600,700,300italic,400italic,600italic">--%>

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
                    <%--<h5 style="text-align: center;">Welcome To Eproperty365</h5>--%>
                    <form id="form1" runat="server" class="form-vertical">
                        <div class="control-group-merged">
                             <div class="control-group">
                                <asp:TextBox ID="txtPassword" placeholder="Enter Password" TextMode="Password" runat="server" CssClass="span12 required input-password bg_input"  ValidationGroup="Login"></asp:TextBox>
                            </div>
                        </div>
                         <div style="text-align: center;">
                           <a style="margin-left: 5px;" href="https://etag365.net/forget-password">Forgot Your Password?</a>
                        </div>
                        <div style="text-align: center;">
                            <asp:Label ID="lblError" runat="server" ForeColor="Red"></asp:Label>
                        </div>
                        <div class="control-group">
                            <asp:Button ID="btnLogin2" runat="server" Text="Login" OnClick="btnLogin2_Click"  OnClientClick="CheckVal()"  CssClass="btn btn-success btn-block btn-large"  ValidationGroup="Login" Style="margin-left: 0px;"  />
                        </div>
                    
                        <div class="clearfix"></div>
                        <div class="separator" style="margin-top: 20px;">
                            <div class="login_footer" style="text-align:center;">
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
    <script src="../scripts/jquery-1.8.3.min.js"></script>
    <script src="../scripts/jquery-3.3.1.min.js"></script>
    <script src="../scripts/jquery.placeholder.min.js"></script>
    <script src="../scripts/bootstrap.js"></script>
    <!-- Login Script -->
    <script src="../scripts/login.js"></script>

    <!-- Validation -->

    <script src="../scripts/jquery.validate.min.js"></script>
    <script src="../Scripts/jquery.validate.unobtrusive.min.js"></script>

    <!-- Uniform Script -->

  <%--  <script src="../Content/plugins/uniform/jquery.uniform.min.js"></script>--%>

   <script type="text/javascript">
       function CheckVal() {
           if (typeof (Page_ClientValidate) == 'function') {
               Page_ClientValidate();
           }           
       }    

   </script>

    <!--Start of Tawk.to Script-->
   <%-- <script type="text/javascript">
        var Tawk_API = Tawk_API || {}, Tawk_LoadStart = new Date();
        (function () {
            var s1 = document.createElement("script"), s0 = document.getElementsByTagName("script")[0];
            s1.async = true;
            s1.src = 'https://embed.tawk.to/5e864cbe35bcbb0c9aad333f/default';
            s1.charset = 'UTF-8';
            s1.setAttribute('crossorigin', '*');
            s0.parentNode.insertBefore(s1, s0);
        })();
    </script>--%>
    <!--End of Tawk.to Script-->

</body>
</html>
