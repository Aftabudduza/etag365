<%@ Page Title="eTag365: Email Log" Language="C#" MasterPageFile="~/MasterPage/Site.master" ValidateRequest="false" AutoEventWireup="true" CodeBehind="EmailLog.aspx.cs" Inherits="eTag365.Pages.Admin.EmailLog" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="abc" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
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
    <style type="text/css">
        .pagination .current {
            background: #E2DED6;
            font-weight: bold;
        }

        .Pager a {
            color: #000000;
            text-decoration: none;
        }

        .Pager hover {
            color: #AAFF00;
            text-decoration: none;
        }

        .Pager {
            color: #885454;
            text-decoration: none;
            background-color: #FFF7E7;
        }

            .pager span {
                color: #009900;
                font-weight: bold;
                font-size: 14pt;
            }
    </style>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <form id="form1" runat="server" class="form-horizontal">
        <asp:ScriptManager runat="server" ID="sc2">
        </asp:ScriptManager>

        <div class="box">
            <div class="col-md-12">
                <div class="box box-primary">
                    <div class="box-header with-border CommonHeader col-md-12">
                        <h3 class="box-title" id="H1" runat="server">Email Log</h3>
                    </div>

                    <asp:UpdatePanel ID="upnlImageVideoUpld" runat="server">
                        <ContentTemplate>

                            <div class="box-body">
                                <div class="col-md-6">
                                    <label for="ddlUser" class="col-sm-6 control-label">From:</label>
                                    <div class="col-sm-6">
                                        <asp:DropDownList ID="ddlUser" AutoPostBack="true" OnSelectedIndexChanged="ddlUser_SelectedIndexChanged" CssClass="form-control" runat="server">
                                        </asp:DropDownList>
                                    </div>
                                    <asp:HiddenField ID="hdnFrom" runat="server" Value="" />
                                    <asp:HiddenField ID="hdnTo" runat="server" Value="" />

                                </div>
                                <div class="col-md-6">
                                    <label for="ddlUser" class="col-sm-6 control-label">To:</label>
                                    <div class="col-sm-6">
                                        <asp:DropDownList ID="ddlUserTo" AutoPostBack="true" OnSelectedIndexChanged="ddlUserTo_SelectedIndexChanged" CssClass="form-control" runat="server">
                                        </asp:DropDownList>
                                    </div>

                                </div>
                                <div class="col-md-6">
                                    <label for="ddlTemplateNo" class="col-sm-6 control-label" style="float: left;">Template No (0-12):</label>
                                    <div class="col-sm-6">
                                        <asp:DropDownList ID="ddlTemplateNo" AutoPostBack="true" OnSelectedIndexChanged="ddlTemplateNo_SelectedIndexChanged" CssClass="form-control" runat="server">
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="col-md-6 btnSubmitDiv">
                                    <asp:Button ID="btnsearch" Visible="false" runat="server" Text="Show" OnClick="btnsearch_Click" CssClass="btn btn-successNew" />
                                </div>
                            </div>



                            <div class="box-body">
                                <form class="vertical-form">
                                    <fieldset>
                                        <asp:GridView Width="100%" ID="gvContactList" runat="server" AutoGenerateColumns="true" CellPadding="10" ForeColor="#333333" CssClass="table table-responsive table-bordered table-striped"
                                            GridLines="None" AllowPaging="True" OnPageIndexChanging="gvContactList_PageIndexChanging"
                                            OnSorting="gvContactList_Sorting" PageSize="20" Style="float: left; margin-bottom: 10px;" AllowSorting="True">
                                            <PagerSettings Position="TopAndBottom" />
                                            <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />

                                            <FooterStyle BackColor="" Font-Bold="True" ForeColor="White" />
                                            <PagerStyle CssClass="pager" ForeColor="Blue" HorizontalAlign="Center" />
                                            <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                                            <HeaderStyle Font-Bold="True" ForeColor="Black" />
                                            <EditRowStyle BackColor="#999999" />
                                            <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                                        </asp:GridView>
                                    </fieldset>
                                </form>
                            </div>

                            <div class="box-body">
                                <form class="vertical-form">
                                    <fieldset>
                                        <asp:GridView Width="100%" ID="gvUserList" runat="server" AutoGenerateColumns="true" CellPadding="10" ForeColor="#333333" CssClass="table table-responsive table-bordered table-striped"
                                            GridLines="None" AllowPaging="True" OnPageIndexChanging="gvUserList_PageIndexChanging"
                                            OnSorting="gvUserList_Sorting" PageSize="20" Style="float: left; margin-bottom: 10px;" AllowSorting="True">
                                            <PagerSettings Position="TopAndBottom" />
                                            <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                                            <FooterStyle BackColor="" Font-Bold="True" ForeColor="White" />
                                            <PagerStyle CssClass="pager" ForeColor="Blue" HorizontalAlign="Center" />
                                            <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                                            <HeaderStyle Font-Bold="True" ForeColor="Black" />
                                            <EditRowStyle BackColor="#999999" />
                                            <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                                        </asp:GridView>
                                    </fieldset>
                                </form>
                            </div>


                        </ContentTemplate>
                    </asp:UpdatePanel>



                </div>
            </div>
        </div>

    </form>
</asp:Content>
