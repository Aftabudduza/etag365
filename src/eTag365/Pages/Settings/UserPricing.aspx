<%@ Page Title="eTag365: User Pricing" Language="C#" MasterPageFile="~/MasterPage/Site.master" AutoEventWireup="true" CodeBehind="UserPricing.aspx.cs" Inherits="eTag365.Pages.Settings.UserPricing" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <form id="form1" runat="server">
        <div class="box">
            <div class="box-header with-border CommonHeader col-md-12">
                <h3 class="box-title">User Pricing</h3>
            </div>
            <div class="box-body">
                <div class="col-md-12">
                    <table style="float: left;" class="table table-responsive table-bordered" id="tblUserPricing"></table>
                </div>

                <div class="col-md-12">
                    <br />
                    <br />
                    <p>
                        For each referral you register you will receive a 5% of their paid monthly eTag365 services as a commission for up to three
                            years. This commission will be applied to your monthly eTag365 services owed first. Any overages will be paid on quarterly
                            bases.
                    </p>
                    <p>
                        If you register over 100 Users we will extend your payment for your lifetime.
                    </p>

                </div>
                <div class="col-md-12">
                    <div class="col-md-6">&nbsp;</div>
                    <div class="col-md-6">
                        <input type="text" id="txtCode" runat="server"  class="col-sm-4 form-control" placeholder="Group Code" />                        
                    </div>
                </div>

               
            </div>
            <div class="col-md-12">
                <!-- general form elements -->
                <div class="box box-primary">
                    <div class="box-footer">
                        <div class="col-md-12">
                            <div class="col-md-4 btnSubmitDiv">
                                <asp:Button ID="btnBack" runat="server" Text="< Back" OnClick="btnBack_Click" CssClass="btn btn-success" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <%--<link rel="stylesheet" type="text/css" href="../../Content/DataTables/css/jquery.dataTables.css" />--%>
    <style type="text/css">
        /*#tblUserPricing {
            border-collapse: collapse;
            width: 100%;
        }

            #tblUserPricing td, #tblUserPricing th {
                border: 1px solid black;
                padding: 2%;
                width: 26%;
            }

            #tblUserPricing tr:hover {
                background-color: #ddd;
            }*/

        /*#tblUserPricing th {
padding-top: 12px;
padding-bottom: 12px;
text-align: left;
color: white;
}*/
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
    </style>
    <script type="text/javascript" src="../../AppJs/CommonJS/DataBaseOperationJs.js"></script>
    <script type="text/javascript" src="../../AppJs/Settings/UserPricing.js"></script>
</asp:Content>
