<%@ Page Title="eTag365: Email Scheduler" Language="C#" MasterPageFile="~/MasterPage/Site.master" ValidateRequest="false" AutoEventWireup="true" Debug="true" CodeBehind="EmailScheduler.aspx.cs" Inherits="eTag365.Pages.Admin.EmailScheduler" %>

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

        .pager span { color:#009900;font-weight:bold; font-size:14pt; }
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
                        <h3 class="box-title" id="H1" runat="server">Email Scheduler</h3>
                    </div>

                    <asp:UpdatePanel ID="upnlImageVideoUpld" runat="server">
                        <ContentTemplate>

                            <div class="box-body">
                                <div class="col-md-6">
                                    <label for="ddlUser" class="col-sm-6 control-label">Contact Name:</label>
                                    <div class="col-sm-6">
                                        <asp:DropDownList ID="ddlUser" AutoPostBack="true" OnSelectedIndexChanged="ddlUser_SelectedIndexChanged" CssClass="form-control" runat="server">
                                        </asp:DropDownList>
                                    </div>
                                    <asp:HiddenField ID="hdnFrom" runat="server" Value="" />
                                    <asp:HiddenField ID="hdnTo" runat="server" Value="" />

                                </div>
                            </div>

                           <%-- <div class="box-body">
                                <div class="col-md-6">
                                    <label for="txtEmail" class="col-sm-6 control-label">*Person Email:</label>
                                    <div class="col-sm-6">
                                        <asp:TextBox ID="txtToEmail" runat="server" CssClass="form-control"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" ControlToValidate="txtToEmail" ValidationGroup="Contact"
                                            runat="server" ErrorMessage="ToEmail Address Required" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                                        <asp:RegularExpressionValidator Display="Dynamic" ID="RegularExpressionValidator1" ValidationGroup="Contact"
                                            runat="server" ErrorMessage="Invalid ToEmail" ControlToValidate="txtToEmail" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label for="txtEmail" class="col-sm-6 control-label">*From Email:</label>
                                    <div class="col-sm-6">
                                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" ControlToValidate="txtEmail" ValidationGroup="Contact"
                                            runat="server" ErrorMessage="From Email Address Required" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                                        <asp:RegularExpressionValidator Display="Dynamic" ID="RegularExpressionValidator2" ValidationGroup="Contact"
                                            runat="server" ErrorMessage="Invalid From Email" ControlToValidate="txtEmail" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
                                    </div>
                                </div>
                            </div>--%>

                            <div class="box-body">
                                <form class="vertical-form">
                                    <fieldset>
                                        <asp:GridView Width="100%" ID="gvContactList" runat="server" AutoGenerateColumns="False" CellPadding="10" ForeColor="#333333" CssClass="table table-responsive table-bordered table-striped"
                                            GridLines="None" AllowPaging="True" OnPageIndexChanging="gvContactList_PageIndexChanging"
                                            OnSorting="gvContactList_Sorting" PageSize="20" Style="float: left; margin-bottom: 10px;" AllowSorting="True">
                                            <PagerSettings Position="TopAndBottom" />
                                            <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                                            <Columns>
                                                <asp:TemplateField HeaderText="First Name" SortExpression="Data">
                                                    <ItemTemplate>
                                                        <asp:Label ID="LabelFirstName" runat="server" Text='<%# Eval("FirstName") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="LastName" SortExpression="Data">
                                                    <ItemTemplate>
                                                        <asp:Label ID="LabelLastName" runat="server" Text='<%# Eval("LastName") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Template Number" SortExpression="Data">
                                                    <ItemTemplate>
                                                        <asp:Label ID="Label1" runat="server" Text='<%# Eval("LastEmailNumber") %>'></asp:Label>
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
                                                        <asp:Label ID="Label41" runat="server" Text='<%# Eval("Type") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                                                </asp:TemplateField>

                                                <asp:TemplateField HeaderText="Days" SortExpression="Data">
                                                    <ItemTemplate>
                                                        <asp:Label ID="Label2" runat="server" Text='<%# Eval("Days") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                                                </asp:TemplateField>

                                                <asp:TemplateField HeaderText="Action" ItemStyle-HorizontalAlign="Left">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblEmailScheduleId" runat="server" Text='<%# Eval("Id") %>' Visible="false"></asp:Label>
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

                            <div class="box-body">
                                <div class="col-md-6">
                                    <label for="ddlCategory" class="col-sm-6 control-label" style="float: left;">Category:</label>
                                    <div class="col-sm-6">
                                        <asp:DropDownList ID="ddlCategory" AutoPostBack="true" OnSelectedIndexChanged="ddlCategory_SelectedIndexChanged"  CssClass="form-control" runat="server">
                                            <asp:ListItem Value="-1">N/A</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                  <div class="col-md-6">
                                        <label for="ddlType" class="col-sm-6 control-label" style="float: left;">Types:</label>
                                        <div class="col-sm-6">
                                            <asp:DropDownList ID="ddlType" AutoPostBack="true" OnSelectedIndexChanged="ddlType_SelectedIndexChanged"  CssClass="form-control" runat="server">
                                                <asp:ListItem Value="-1">N/A</asp:ListItem>
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

                                <div class="col-md-6" id="divDays" runat="server">
                                    <label for="ddlNo" class="col-sm-6 control-label" style="float: left;">Number Days Between Emails (1-30):</label>
                                    <div class="col-sm-6">
                                        <asp:DropDownList ID="ddlNo" CssClass="form-control" runat="server">
                                        </asp:DropDownList>
                                    </div>

                                </div>
                                <div class="col-md-6">
                                    <div class="col-sm-12">
                                        <asp:CheckBox ID="chkLoop" runat="server" Checked="false" Text="Loop send again from 1 to 12" />
                                    </div>
                                </div>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>

                    <div class="box-footer">
                        <div class="col-md-12">
                            <div class="col-md-6 btnSubmitDiv">
                                <asp:Button ID="btnSave33" runat="server" Text="Save" ValidationGroup="Contact" OnClick="btnSave33_Click" CssClass="btn btn-successNew" />
                                <asp:Button ID="btnInactive" runat="server" Text="Stop Schedule" OnClick="btnInactive_Click" CssClass="btn btn-successNew" />
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

                </div>
            </div>
        </div>

    </form>
</asp:Content>
