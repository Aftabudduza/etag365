<%@ Page Title="eTag365: Create/Change Email Template" Language="C#" MasterPageFile="~/MasterPage/Site.master" EnableEventValidation="false" AutoEventWireup="true" CodeBehind="EmailTemplateSetup_old.aspx.cs" Inherits="eTag365.Pages.Admin.EmailTemplateSetupOld" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <%--<script type="text/javascript"  src="http://cdn.tinymce.com/4/tinymce.min.js"></script>--%>
    <%--<script type="text/javascript" src="https://www.etag365.net/scripts/tinymce/tinymce.min.js"></script>--%>
    <script type="text/javascript" src="https://cdn.tiny.cloud/1/no-api-key/tinymce/5/tinymce.min.js" ></script>
  

    <script type="text/javascript">
        tinymce.init({
            selector: "#txtOther",
            toolbar: "forecolor",
            color_cols: "3",
            color_map: [
                "993366",
                "Red violet",
                "FFFFFF",
                "White",
                "FF99CC",
                "Pink",
                "FFCC99",
                "Peach",
                "FFFF99",
                "Light yellow",
                "CCFFCC",
                "Pale green",
                "CCFFFF",
                "Pale cyan",
                "99CCFF",
                "Light sky blue",
                "CC99FF",
                "Plum",
            ],
        });
        
    </script>

   
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
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <form id="form1" runat="server" class="form-horizontal">
        <asp:ScriptManager runat="server" ID="sc2">
        </asp:ScriptManager>
        <%-- <asp:UpdatePanel ID="upnlImageVideoUpld" runat="server">
            <ContentTemplate>--%>
        <div class="box">
            <div class="col-md-12">
                <div class="box box-primary">
                    <div class="box-header with-border CommonHeader col-md-12">
                        <h3 class="box-title" id="H1" runat="server">Create/Change Email Template</h3>
                    </div>

                    <div class="box-body">
                        <div class="form-group">
                            <div class="col-md-6">
                                <asp:DropDownList ID="ddlUser" AutoPostBack="true" OnSelectedIndexChanged="ddlUser_SelectedIndexChanged" CssClass="form-control" runat="server">
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

                                        <asp:TemplateField HeaderText="Action" ItemStyle-HorizontalAlign="Left">
                                            <ItemTemplate>
                                                <asp:Label ID="lblId" runat="server" Text='<%# Eval("Id") %>' Visible="false"></asp:Label>
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
                </div>
            </div>

        </div>
        <%-- </ContentTemplate>
        </asp:UpdatePanel>--%>
        <div class="box">
            <div class="col-md-12">
                <div class="box box-primary">
                    <div class="box-header with-border CommonHeader col-md-12">
                        <h3 class="box-title" id="lblHeadline" runat="server">Email Template Setup</h3>
                    </div>
                    <div>
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
                                <label for="ddlType" class="col-sm-6 control-label" style="float: left;">Type of Contact:</label>
                                <div class="col-sm-3">
                                    <asp:DropDownList ID="ddlType" CssClass="form-control" runat="server">
                                        <asp:ListItem Value="-1">None</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <asp:HyperLink ID="HyperLink2" runat="server" class="col-sm-2 btn btn-success" NavigateUrl="~/system?C=1" Text="Add" />
                            </div>
                            <div class="col-md-6">
                                <label for="ddlNo" class="col-sm-6 control-label" style="float: left;">Template No (0-12):</label>
                                <div class="col-sm-3">
                                    <asp:DropDownList ID="ddlNo" CssClass="form-control" runat="server">
                                    </asp:DropDownList>
                                </div>

                            </div>
                        </div>
                        <div class="box-body">
                            <div class="col-md-12">
                                <div class="col-sm-12">
                                    <asp:TextBox ID="txtSubject" placeholder="Subject"  runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        
                        
                        <div class="box-body">
                            <div class="col-md-12">
                                <div class="col-sm-12">
                                    <asp:TextBox ID="txtOther" placeholder="Body" TextMode="MultiLine" Height="200" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                            </div>
                        </div>


                        <!-- /.box-body -->
                        <div class="box-footer">
                            <div class="col-md-12">
                                <div class="col-md-6 btnSubmitDiv">
                                    <asp:Button ID="btnSave33" UseSubmitBehavior="false" runat="server" Text="Save" OnClick="btnSave33_Click" CssClass="btn btn-successNew" />
                                </div>
                                <div class="col-md-6 btnSubmitDiv">
                                    <asp:Button ID="btnBack33" UseSubmitBehavior="false" runat="server" Text="Cancel" OnClick="btnBack33_Click" CssClass="btn btn-success " />
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
        </div>

       <%-- <script type="text/javascript">

            SetEditor();

            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(EndRequestHandler);

            function EndRequestHandler(sender, args) {
                // this will execute on partial postback
                SetEditor();
            }
        </script>--%>
    </form>
</asp:Content>


