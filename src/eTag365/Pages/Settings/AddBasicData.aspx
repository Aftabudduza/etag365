<%@ Page Title="eTag365: System Data" Language="C#" MasterPageFile="~/MasterPage/Site.master" AutoEventWireup="true" EnableEventValidation="false" CodeBehind="AddBasicData.aspx.cs" Inherits="eTag365.Pages.Settings.AddBasicData" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <form id="form3" runat="server" class="form-horizontal">
        <asp:ScriptManager runat="server" ID="sc2">
        </asp:ScriptManager>
        <asp:UpdatePanel runat="server" ID="userpanel">
            <ContentTemplate>
                <div class="box">
                    <div class="box-body">
                        <fieldset>
                            <asp:GridView Width="100%" ID="gvDataList" runat="server" AutoGenerateColumns="False" CellPadding="10" ForeColor="#333333" CssClass="table table-bordered table-striped"
                                GridLines="None" AllowPaging="True" OnPageIndexChanging="gvDataList_PageIndexChanging"
                                OnSorting="gvDataList_Sorting" PageSize="20" Style="float: left; margin-bottom: 10px;" AllowSorting="True">
                                <PagerSettings Position="TopAndBottom" />
                                <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                                <Columns>
                                    <asp:TemplateField HeaderText="Code" SortExpression="Data">
                                        <ItemTemplate>
                                            <asp:Label ID="lblCode" runat="server" Text='<%# Eval("Code") %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Name" SortExpression="Data">
                                        <ItemTemplate>
                                            <asp:Label ID="lblDesp1" runat="server" Text='<%# Eval("Description") %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Action" ItemStyle-HorizontalAlign="Left">
                                        <ItemTemplate>
                                            <asp:Label ID="lblId" runat="server" Text='<%# Eval("Id") %>' Visible="false"></asp:Label>
                                            <asp:LinkButton ID="btnEdit" runat="server" Text="Edit" OnClick="btnEdit_Click" Visible='<%#ShowEdit(Eval("Id").ToString())%>'></asp:LinkButton>
                                            <asp:LinkButton ID="btnDelete" runat="server" OnClientClick='return confirm("Are you sure you want to delete?");' Text="Delete" OnClick="btnDelete_Click" Visible='<%#ShowEdit(Eval("Id").ToString())%>'></asp:LinkButton>
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
                    </div>
                    <!-- left column -->
                    <div class="col-md-12">
                        <!-- general form elements -->
                        <div class="box box-primary">
                            <div class="box-header with-border">
                                <h3 class="box-title" id="lblHeadline" runat="server">Add</h3>
                            </div>
                            <!-- /.box-header -->
                            <!-- form start -->
                            <div class="box-body">
                                <div class="col-md-6">
                                    <label for="ddlType" class="col-sm-3 control-label" style="float: left;">Type:</label>
                                    <div class="col-sm-6">
                                        <asp:DropDownList ID="ddlType" CssClass="form-control" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlType_SelectedIndexChanged">
                                        </asp:DropDownList>
                                        <asp:RequiredFieldValidator Display="Dynamic" id-="requsertype" runat="server" ControlToValidate="ddlType" InitialValue="-1" ErrorMessage="Please select Type" ForeColor="Red" ValidationGroup="Basic"></asp:RequiredFieldValidator>
                                    </div>
                                </div>
                            </div>
                            <div class="box-body">
                                <div class="col-md-6">
                                    <label for="txtCode" class="col-sm-3 control-label">Code:</label>
                                    <div class="col-sm-6">
                                        <asp:TextBox ID="txtCode" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label for="txtContactName" class="col-sm-3 control-label">*Name:</label>
                                    <div class="col-sm-6">
                                        <asp:TextBox ID="txtContactName" runat="server" CssClass="form-control"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" Display="Dynamic" ControlToValidate="txtContactName" ValidationGroup="Basic"
                                            runat="server" ErrorMessage="Name Required" ForeColor="Red"></asp:RequiredFieldValidator>
                                    </div>
                                </div>
                            </div>
                            <!-- /.box-body -->
                            <div class="box-footer">
                                <div class="col-md-12">
                                    <div class="col-md-3 btnSubmitDiv">
                                        <asp:Button ID="btnBack" runat="server" Text="< Back" OnClick="btnBack_Click" CssClass="btn btn-success" />
                                    </div>
                                    <div class="col-md-3 btnSubmitDiv">
                                        <asp:Button ID="btnSave" runat="server" Text="Add" OnClientClick="CheckVal()" OnClick="btnSubmit_Click" CssClass="btn btn-success" ValidationGroup="Basic" />
                                    </div>
                                    <div class="col-md-3 btnSubmitDiv">
                                        <asp:Button ID="btnCancel" runat="server" Text="Clear" OnClick="btnClose_Click" CssClass="btn btn-success " />
                                    </div>

                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </form>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
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
</asp:Content>
