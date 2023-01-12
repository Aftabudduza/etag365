<%@ page title="eTag365: Phone Number Verify" language="C#" masterpagefile="~/MasterPage/NewUser.master" enableeventvalidation="false" autoeventwireup="true" codebehind="PhoneVerify.aspx.cs" inherits="eTag365.Pages.Admin.PhoneVerify" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <form id="form1" runat="server" class="form-horizontal">
        <asp:ScriptManager runat="server" ID="sc2">
        </asp:ScriptManager>
        <asp:UpdatePanel runat="server" ID="userpanel2">
            <contenttemplate>
                    <div class="box">
                        <div class="col-md-12">
                            <div class="box box-primary">
                                <div class="box-header with-border CommonHeader col-md-12">
                                    <h3 class="box-title" id="lblHeadline" runat="server">eTag365: Phone Number Verify</h3>
                                </div>
                           
                                <!-- /.box-header -->
                                <!-- form start -->
                                <div class="box-body">  
                                   <div class="col-md-6">
                                        <label for="txtNumber" class="col-sm-3 control-label">Verification Code:</label>
                                        <div class="col-sm-6">
                                            <asp:TextBox ID="txtNumber" runat="server" CssClass="form-control"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator4" ControlToValidate="txtNumber" ValidationGroup="Contact"
                                                Display="Dynamic" runat="server" ErrorMessage="Required" ForeColor="Red"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>   
                                     <div class="col-md-6">
                                         <asp:Label  ID="lblError" runat="server" ForeColor="Red" class="col-sm-12 control-label"></asp:Label>
                                     </div>
                                </div>

                                <!-- /.box-body -->
                                <div class="box-footer">
                                    <div class="col-md-6">
                                        <asp:Button ID="btnSave" runat="server" Text="Submit" OnClientClick="CheckVal()" OnClick="btnSubmit_Click" CssClass="btn btn-successNew" ValidationGroup="Contact" />
                                        <asp:Button ID="btnResend" runat="server" Text="Resend Code" CssClass="btn btn-success" OnClick="btnSend_Click" />
                                        <asp:Button ID="btnCancel" runat="server" Text="Skip" OnClick="btnClose_Click" CssClass="btn btn-success " />
                                    </div>
                                </div>

                            </div>

                        </div>
                    </div>
            </contenttemplate>
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
    </style>
</asp:Content>
