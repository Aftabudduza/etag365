<%@ Page Title="eTag365: User Listing" Language="C#" MasterPageFile="~/MasterPage/Site.master" AutoEventWireup="true" EnableEventValidation="false" CodeBehind="UserList.aspx.cs" Inherits="eTag365.Pages.Admin.UserList" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
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

        .pager span { color:#009900;font-weight:bold; font-size:14pt; }
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


</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <form id="form1" runat="server" class="form-horizontal">
        <asp:ScriptManager runat="server" ID="sc2">
        </asp:ScriptManager>
        <asp:UpdatePanel ID="upnlImageVideoUpld" runat="server">
            <ContentTemplate>
                <div class="box">
                    <div class="col-md-12">
                        <div class="box box-primary">
                            <div class="box-header with-border CommonHeader col-md-12">
                                <h3 class="box-title" id="lblHeadline" runat="server">User List</h3>
                            </div>

                            <div class="box-body">
                                <div class="form-group">
                                    <div class="col-md-6">
                                        <input type="text" id="search" name="search" runat="server" class="form-control search-box" placeholder="First Name/Last Name/Email/Phone" />
                                    </div>
                                    <div class="col-md-6">
                                        <asp:Button ID="btnsearch" runat="server" Text="Search" OnClick="btnsearch_Click" CssClass="btn btn-success " />
                                        <asp:Button ID="btnAdd" runat="server" Text="Add New User" OnClick="btnAdd_Click" CssClass="btn btn-success " />
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
                                                <asp:HyperLinkField DataNavigateUrlFields="Id" DataNavigateUrlFormatString="~/user?UId={0}" HeaderText="View/Edit" Text="View/Edit" />

                                                <asp:TemplateField HeaderText="Email Flow" SortExpression="Data">
                                                    <ItemTemplate>
                                                        <asp:CheckBox ID="chkapply" runat="server" Enabled="false" Checked='<%# Convert.ToBoolean(Eval("IsEmailFlow"))%>' />
                                                        <%-- <asp:Label ID="Label1" runat="server" Text='<%# Eval("IsEmailFlow") %>'></asp:Label>--%>
                                                    </ItemTemplate>
                                                    <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                                                </asp:TemplateField>

                                                <asp:TemplateField HeaderText="Last Name" SortExpression="Data">
                                                    <ItemTemplate>
                                                        <asp:HyperLink runat="server" NavigateUrl='<%# Eval("Id", "~/user?UId={0}") %>' Text='<%# Eval("Lastname") %>' />
                                                    </ItemTemplate>
                                                    <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                                                </asp:TemplateField>


                                                <asp:TemplateField HeaderText="First Name" SortExpression="Data">
                                                    <ItemTemplate>
                                                        <asp:HyperLink runat="server" NavigateUrl='<%# Eval("Id", "~/user?UId={0}") %>' Text='<%# Eval("Firstname") %>' />
                                                    </ItemTemplate>
                                                    <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                                                </asp:TemplateField>

                                                <asp:TemplateField HeaderText="Phone" SortExpression="Data">
                                                    <ItemTemplate>
                                                        <asp:HyperLink runat="server" NavigateUrl='<%# Eval("Id", "~/user?UId={0}") %>' Text='<%# Eval("Phone") %>' />
                                                    </ItemTemplate>
                                                    <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                                                </asp:TemplateField>

                                                <asp:TemplateField HeaderText="Email" SortExpression="Data">
                                                    <ItemTemplate>
                                                        <asp:HyperLink runat="server" NavigateUrl='<%# Eval("Id", "~/user?UId={0}") %>' Text='<%# Eval("Email") %>' />
                                                    </ItemTemplate>
                                                    <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                                                </asp:TemplateField>

                                                <asp:TemplateField HeaderText="Serial" SortExpression="Data">
                                                    <ItemTemplate>
                                                        <asp:HyperLink runat="server" NavigateUrl='<%# Eval("Id", "~/user?UId={0}") %>' Text='<%# Eval("Serial") %>' />
                                                    </ItemTemplate>
                                                    <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                                                </asp:TemplateField>



                                                <asp:TemplateField HeaderText="Action" ItemStyle-HorizontalAlign="Left">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblId" runat="server" Text='<%# Eval("Id") %>' Visible="false"></asp:Label>
                                                        <asp:LinkButton ID="btnDelete" runat="server" OnClientClick='return confirm("Are you sure you want to delete?");' Text="Delete" OnClick="btnDelete_Click"></asp:LinkButton>
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
                                            <%-- <PagerStyle BackColor="#d1d0d0" ForeColor="Black" HorizontalAlign="Center" />--%>
                                            <PagerStyle CssClass="pager" ForeColor="Blue" HorizontalAlign="Center" />
                                            <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                                            <HeaderStyle Font-Bold="True" ForeColor="Black" />
                                            <EditRowStyle BackColor="#999999" />
                                            <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                                        </asp:GridView>
                                    </fieldset>
                                </form>
                            </div>

                            <div class="box-header with-border CommonHeader col-md-12">
                                <h3 class="box-title" id="H1" runat="server">Contact List</h3>
                            </div>

                            <div class="box-body">
                                <div class="form-group">
                                    <div class="col-md-6">
                                        <label class="col-sm-6 control-label" style="float: left;">User:</label>
                                        <div class="col-sm-6">
                                            <asp:DropDownList ID="ddlUser" AutoPostBack="true" OnSelectedIndexChanged="ddlUser_SelectedIndexChanged" CssClass="form-control" runat="server">
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                    </div>
                                </div>
                            </div>

                            <div class="box-body">
                                <form class="vertical-form">
                                    <fieldset>
                                        <asp:GridView Width="100%" ID="gvUserList" runat="server" AutoGenerateColumns="False" CellPadding="10" ForeColor="#333333" CssClass="table table-responsive table-bordered table-striped"
                                            GridLines="None" AllowPaging="True" OnPageIndexChanging="gvUserList_PageIndexChanging"
                                            OnSorting="gvUserList_Sorting" PageSize="20" Style="float: left; margin-bottom: 10px;" AllowSorting="True">
                                            <PagerSettings Position="TopAndBottom" />
                                            <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                                            <Columns>
                                                <asp:HyperLinkField DataNavigateUrlFields="Id" DataNavigateUrlFormatString="~/{0}/contact?CId={0}" HeaderText="View/Edit" Text="View/Edit" />

                                                <asp:TemplateField HeaderText="Email Flow" SortExpression="Data">
                                                    <ItemTemplate>
                                                        <asp:CheckBox ID="chkapply" runat="server" Enabled="false" Checked='<%# Convert.ToBoolean(Eval("IsEmailFlow"))%>' />
                                                    </ItemTemplate>
                                                    <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                                                </asp:TemplateField>

                                                <asp:TemplateField HeaderText="Last Name" SortExpression="Data">
                                                    <ItemTemplate>
                                                        <asp:HyperLink runat="server" NavigateUrl='<%# Eval("Id", "~/{0}/contact?CId={0}") %>' Text='<%# Eval("Lastname") %>' />
                                                    </ItemTemplate>
                                                    <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                                                </asp:TemplateField>


                                                <asp:TemplateField HeaderText="First Name" SortExpression="Data">
                                                    <ItemTemplate>
                                                        <asp:HyperLink runat="server" NavigateUrl='<%# Eval("Id", "~/{0}/contact?CId={0}") %>' Text='<%# Eval("Firstname") %>' />
                                                    </ItemTemplate>
                                                    <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                                                </asp:TemplateField>

                                                <asp:TemplateField HeaderText="Phone" SortExpression="Data">
                                                    <ItemTemplate>
                                                        <asp:HyperLink runat="server" NavigateUrl='<%# Eval("Id", "~/{0}/contact?CId={0}") %>' Text='<%# Eval("Phone") %>' />
                                                    </ItemTemplate>
                                                    <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                                                </asp:TemplateField>

                                                <asp:TemplateField HeaderText="Email" SortExpression="Data">
                                                    <ItemTemplate>
                                                        <asp:HyperLink runat="server" NavigateUrl='<%# Eval("Id", "~/{0}/contact?CId={0}") %>' Text='<%# Eval("Email") %>' />
                                                    </ItemTemplate>
                                                    <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                                                </asp:TemplateField>



                                                <asp:TemplateField HeaderText="Action" ItemStyle-HorizontalAlign="Left">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblCId" runat="server" Text='<%# Eval("Id") %>' Visible="false"></asp:Label>
                                                        <asp:LinkButton ID="btnCDelete" runat="server" OnClientClick='return confirm("Are you sure you want to delete?");' Text="Delete" OnClick="btnDelete_Click"></asp:LinkButton>
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
                                            <%-- <PagerStyle BackColor="#d1d0d0" ForeColor="Black" HorizontalAlign="Center" />--%>
                                            <PagerStyle CssClass="pager" ForeColor="Blue" HorizontalAlign="Center" />
                                            <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                                            <HeaderStyle Font-Bold="True" ForeColor="Black" />
                                            <EditRowStyle BackColor="#999999" />
                                            <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                                        </asp:GridView>
                                    </fieldset>
                                </form>
                            </div>

                        </div>
                    </div>
                </div>

            </ContentTemplate>
        </asp:UpdatePanel>
    </form>
</asp:Content>

