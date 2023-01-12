<%@ Page Title="eTag365: Global System Info" Language="C#" MasterPageFile="~/MasterPage/Site.master" AutoEventWireup="true" EnableEventValidation="false" CodeBehind="AddGlobalSystem.aspx.cs" Inherits="eTag365.Pages.Admin.AddGlobalSystem" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <form id="form1" runat="server" class="form-horizontal">
        <asp:ScriptManager runat="server" ID="sc1">
        </asp:ScriptManager>
        <asp:UpdatePanel runat="server" ID="UpdatePanel8">
            <ContentTemplate>
                <div class="box">
                    <!-- left column -->
                    <div class="col-md-12">
                        <!-- general form elements -->
                        <div class="box box-primary">
                            <div class="box-header with-border CommonHeader col-md-12">
                                <h3 class="box-title" id="lblHeadline" runat="server">eTag365 Global System Information</h3>
                            </div>
                            <!-- /.box-header -->
                            <!-- form start -->
                            <div class="box-body">
                                <div class="col-md-6">
                                    <label for="txtWebUrl" class="col-sm-3 control-label">Web Site Url:</label>
                                    <div class="col-sm-6">
                                        <asp:TextBox ID="txtWebUrl" Enabled="True" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div class="box-body">
                                <div class="col-md-4" style="float: left;">
                                    <label for="txtEmailServer" class="col-sm-6 control-label">Email Server:</label>
                                    <asp:TextBox ID="txtEmailServer" runat="server" CssClass="col-sm-6 form-control"></asp:TextBox>
                                </div>
                                <div class="col-md-4" style="float: left;">
                                    <label for="txtEmailUserName" class="col-sm-6 control-label">Email User Name:</label>
                                    <asp:TextBox ID="txtEmailUserName" runat="server" CssClass="col-sm-6 form-control"></asp:TextBox>
                                </div>

                                <div class="col-md-4" style="float: left;">
                                    <label for="txtEmailPassword" class="col-sm-6 control-label">Email Password:</label>
                                    <asp:TextBox ID="txtEmailPassword" runat="server" TextMode="Password" CssClass="col-sm-6 form-control"></asp:TextBox>
                                </div>
                            </div>
                            <div class="box-body">
                                <div class="col-md-6">
                                    <label class="col-sm-6 control-label">Security Check Link</label>
                                </div>
                            </div>
                            <div class="box-body">
                                <div class="col-md-3">
                                    <label for="txtGateway" class="col-sm-6 control-label">Gateway Link:</label>
                                    <asp:TextBox ID="txtGateway" runat="server" CssClass="col-sm-6  form-control"></asp:TextBox>
                                </div>

                                <div class="col-md-3">
                                    <label for="txtTransactionKey" class="col-sm-6 control-label">Transaction Key:</label>
                                    <asp:TextBox ID="txtTransactionKey" runat="server" CssClass="col-sm-6 form-control"></asp:TextBox>
                                </div>

                                <div class="col-md-3">
                                    <label for="txtUserId" class="col-sm-6 control-label">User Id:</label>
                                    <asp:TextBox ID="txtUserId" runat="server" CssClass="col-sm-6 form-control"></asp:TextBox>
                                </div>
                                <div class="col-md-3">
                                    <label for="txtUserPassword" class="col-sm-6 control-label" style="float: left;">User Password:</label>
                                    <asp:TextBox ID="txtUserPassword" runat="server" TextMode="Password" CssClass="col-sm-6 form-control"></asp:TextBox>
                                </div>
                            </div>
                            <div class="box-body">
                                <div class="col-md-6">
                                    <label class="col-sm-6 control-label">Credit Card Information:</label>
                                </div>
                            </div>
                            <div class="box-body">
                                <div class="col-md-3">
                                    <label for="txtGateway" class="col-sm-6 control-label">Gateway Link:</label>
                                    <asp:TextBox ID="txtGateway1" runat="server" CssClass="col-sm-6 form-control"></asp:TextBox>
                                </div>

                                <div class="col-md-3">
                                    <label for="txtTransactionKey" class="col-sm-6 control-label">Transaction Key:</label>
                                    <asp:TextBox ID="txtTransactionKey1" runat="server" CssClass="col-sm-6 form-control"></asp:TextBox>
                                </div>

                                <div class="col-md-3">
                                    <label for="txtUserId" class="col-sm-6 control-label">User Id:</label>
                                    <asp:TextBox ID="txtUserId1" runat="server" CssClass="col-sm-6 form-control"></asp:TextBox>
                                </div>
                                <div class="col-md-3">
                                    <label for="txtUserPassword" class="col-sm-6 control-label" style="float: left;">User Password:</label>
                                    <asp:TextBox ID="txtUserPassword1" runat="server" TextMode="Password" CssClass="col-sm-6 form-control"></asp:TextBox>
                                </div>
                            </div>

                        </div>
                    </div>


                    <div class="col-md-12">
                        <div class="box-header with-border CommonHeader col-md-12">
                            <h3 class="box-title">Pricing</h3>
                        </div>

                        <div class="box-body">
                            <div class="col-md-12">
                                <label class="col-sm-12 control-label">
                                    Processing Fees
                                </label>
                            </div>

                            <div class="col-md-6">
                                <asp:CheckBox ID="chkTenantPayFee" runat="server" Text="User pays processing fees" CssClass="col-sm-12 form-check-inline" />
                            </div>
                            <div class="col-md-6">
                                <asp:CheckBox ID="chkIncludeFee" runat="server" Text="eTag365 pays processing fees" CssClass="col-sm-12 form-check-inline" />
                            </div>
                        </div>

                        <div class="box-body">
                            <div class="col-md-6">
                                <label class="col-sm-6 control-label">Credit Card Process Fee:</label>
                                <asp:RadioButtonList runat="server" ID="rdoFeeType" CssClass="col-sm-6" RepeatDirection="Horizontal">
                                    <asp:ListItem Value="1">Percentage</asp:ListItem>
                                    <asp:ListItem Value="2">Flat Amount</asp:ListItem>
                                </asp:RadioButtonList>
                            </div>
                            <div class="col-md-6">
                                <asp:TextBox ID="txtFeeAmount" runat="server" CssClass="col-sm-4 form-control"></asp:TextBox>
                            </div>

                            <div class="col-md-6">
                                <label class="col-sm-6 control-label">Checking Account Process Fee:</label>
                                <asp:RadioButtonList runat="server" ID="rdoAccount" CssClass="col-sm-6" RepeatDirection="Horizontal">
                                    <asp:ListItem Value="1">Percentage</asp:ListItem>
                                    <asp:ListItem Value="2">Flat Amount</asp:ListItem>
                                </asp:RadioButtonList>
                            </div>
                            <div class="col-md-6">
                                <asp:TextBox ID="txtCheckAmount" runat="server" CssClass="col-sm-4 form-control"></asp:TextBox>
                            </div>

                        </div>
                       

                        <asp:UpdatePanel runat="server" ID="UpdatePanel1">
                            <ContentTemplate>
                                <div class="box-body">
                                    <div class="col-md-12">
                                        <div class="col-sm-12">
                                            <asp:GridView Width="100%" ID="gvCard" runat="server" AutoGenerateColumns="False" CellPadding="10" ForeColor="#333333" CssClass="table table-responsive table-bordered table-striped"
                                                GridLines="None" AllowPaging="True" PageSize="20" Style="float: left; margin-bottom: 10px;">
                                                <PagerSettings Position="TopAndBottom" />
                                                <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                                                <Columns>
                                                    <asp:TemplateField HeaderText="Name">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblAccountName" runat="server" Text='<%# Eval("AccountName") %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                                                    </asp:TemplateField>
                                                     <asp:TemplateField HeaderText="Address">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblAddress" runat="server" Text='<%# Eval("Address") %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                                                    </asp:TemplateField>
                                                     <asp:TemplateField HeaderText="City">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblCity" runat="server" Text='<%# Eval("City") %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                                                    </asp:TemplateField>
                                                     <asp:TemplateField HeaderText="State">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblState" runat="server" Text='<%# Eval("State") %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                                                    </asp:TemplateField>
                                                     <asp:TemplateField HeaderText="Zip">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblZip" runat="server" Text='<%# Eval("Zip") %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Last 4 Digit">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblLastDigit" runat="server" Text='<%# Eval("LastFourDigitCard") %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                                                    </asp:TemplateField>

                                                    <asp:TemplateField HeaderText="Account No">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblAccountNo" runat="server" Text='<%# Eval("AccountNo") %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Routing No">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblRoutingNo" runat="server" Text='<%# Eval("RoutingNo") %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                                                    </asp:TemplateField>

                                                    <asp:TemplateField HeaderText="Action" ItemStyle-HorizontalAlign="Left">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblCardId" runat="server" Text='<%# Eval("Id") %>' Visible="false"></asp:Label>
                                                            <asp:LinkButton ID="btnEditCard" runat="server" Text="Edit" OnClick="btnEditCard_Click"></asp:LinkButton>
                                                            <asp:LinkButton ID="btnDeleteCard" runat="server" OnClientClick='return confirm("Are you sure you want to delete?");' Text="Delete" OnClick="btnDeleteCard_Click"></asp:LinkButton>
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
                                        </div>
                                    </div>
                                </div>
                                <div class="box-body">
                                    <div class="col-md-6">
                                        <asp:RadioButtonList runat="server" ID="rdoCardType" CssClass="col-sm-8" RepeatDirection="Horizontal">
                                            <asp:ListItem Value="1">Credit Card</asp:ListItem>
                                            <asp:ListItem Value="2">Checking Account</asp:ListItem>
                                        </asp:RadioButtonList>
                                        <label class="col-sm-4 control-label">Name on Account:</label>
                                        <asp:TextBox ID="txtCardAccountName" runat="server" CssClass="col-sm-6 form-control"></asp:TextBox>
                                        <label class="col-sm-4 control-label">Address:</label>
                                        <asp:TextBox ID="txtCardAddress" runat="server" CssClass="col-sm-6 form-control"></asp:TextBox>
                                        <label class="col-sm-4 control-label">City:</label>
                                        <asp:TextBox ID="txtCardCity" runat="server" CssClass="col-sm-6 form-control"></asp:TextBox>
                                        <label class="col-sm-4 control-label">State:</label>
                                        <asp:DropDownList ID="ddlState" CssClass="col-sm-6 form-control" runat="server">
                                        </asp:DropDownList>
                                        <label class="col-sm-4 control-label">Zip:</label>
                                        <asp:TextBox ID="txtCardZip" runat="server" CssClass="col-sm-6 form-control"></asp:TextBox>
                                        <label class="col-sm-4 control-label">Credit Card Number:</label>
                                        <asp:TextBox ID="txtCardNumber" runat="server" CssClass="col-sm-6 form-control"></asp:TextBox>
                                        <label class="col-sm-4 control-label">CVS Number:</label>
                                        <asp:TextBox ID="txtCVS" runat="server" CssClass="col-sm-6 form-control"></asp:TextBox>
                                        <label class="col-sm-4" style="float: left;">Expiry Date:</label>
                                        <asp:DropDownList ID="ddlMonth" CssClass="col-sm-3 form-control" runat="server">
                                        </asp:DropDownList>
                                        <asp:DropDownList ID="ddlYear" CssClass="col-sm-3 form-control" runat="server">
                                        </asp:DropDownList>

                                    </div>

                                    <div class="col-md-6">
                                        <label class="col-sm-12 control-label">Checking Account</label>
                                        <div class="col-sm-12">
                                            <asp:TextBox ID="txtRoutingNo" runat="server" CssClass="col-sm-12 form-control"></asp:TextBox>
                                        </div>
                                        <label class="col-sm-12 control-label">Routing number (2nd from left):</label>
                                        <div class="col-sm-12">
                                            <asp:TextBox ID="txtRoutingNo2" runat="server" CssClass="col-sm-12 form-control"></asp:TextBox>
                                            <asp:CompareValidator ID="CompareValidator1" ControlToValidate="txtRoutingNo2" ForeColor="Red"
                                                ControlToCompare="txtRoutingNo" Display="Dynamic" runat="server" ErrorMessage="Routing number Does Not Match"></asp:CompareValidator>
                                        </div>
                                        <label class="col-sm-12 control-label">Re-enter:</label>

                                        <div class="col-sm-12">
                                            <asp:TextBox ID="txtCheckingAccount" runat="server" CssClass="col-sm-12 form-control"></asp:TextBox>
                                        </div>
                                        <label class="col-sm-12 control-label">Account number (last number from left):</label>
                                        <div class="col-sm-12">
                                            <asp:TextBox ID="txtCheckingAccount2" runat="server" CssClass="col-sm-12 form-control"></asp:TextBox>
                                            <asp:CompareValidator ID="CompareValidator2" ControlToValidate="txtCheckingAccount2" ForeColor="Red"
                                                ControlToCompare="txtCheckingAccount" Display="Dynamic" runat="server" ErrorMessage="Account number Does Not Match"></asp:CompareValidator>
                                        </div>
                                        <label class="col-sm-12 control-label">Re-enter:</label>

                                    </div>
                                </div>
                                <div class="box-body">
                                    <div class="col-md-12 btnSubmitDiv">
                                        <asp:Button ID="btnAddCard" runat="server" Text="Add" OnClick="btnAddCard_Click" CssClass="btn btn-success " />
                                    </div>
                                </div>
                            </ContentTemplate>
                        </asp:UpdatePanel>

                        <div class="box-body">
                            <div class="col-md-12">
                                <label class="col-sm-12 control-label">
                                    <h6>* eTag365 Monthly & Annual Software Charges:</h6>
                                </label>

                            </div>
                            <div class="col-md-3">
                            </div>
                            <div class="col-md-3">
                                <asp:CheckBox ID="chkOneTime" runat="server" Text="Bill me first" CssClass="col-sm-12 form-check-inline" />
                            </div>
                            <div class="col-md-6">
                                <asp:CheckBox ID="chkRecurring" runat="server" Text="I authorize recurring monthly charges" CssClass="col-sm-12 form-check-inline" />
                            </div>
                            <div class="col-md-12">
                                <label class="col-sm-12 control-label">
                                    I am authorize signed on the above information and authorize the Landlord or their agent's
                            to debit my Credit Card or Checking account for the above amount.</label>
                            </div>
                        </div>

                    </div>



                    <div class="box-footer">
                        <div class="col-md-6 btnSubmitDiv">
                            <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnClose_Click" CssClass="btn btn-success " />
                        </div>
                        <div class="col-md-6 btnSubmitDiv">
                            <asp:Button ID="btnSave" runat="server" Text="Save" OnClientClick="CheckVal()" OnClick="btnSubmit_Click" CssClass="btn btn-successNew" ValidationGroup="System" />
                        </div>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </form>
</asp:Content>
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
</asp:Content>
