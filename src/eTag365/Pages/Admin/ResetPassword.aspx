<%@ Page Title="eTag365: Password Reset" Language="C#" MasterPageFile="~/MasterPage/Site.master" AutoEventWireup="true" EnableEventValidation="false" CodeBehind="ResetPassword.aspx.cs" Inherits="eTag365.Pages.Admin.ResetPassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <form id="form1" runat="server" class="form-horizontal">
        <asp:ScriptManager runat="server" ID="sc1">
        </asp:ScriptManager>
        <asp:UpdatePanel runat="server" ID="userpanel">
            <ContentTemplate>
                <div class="box">
                    <div class="col-md-12">
                        <div class="box box-primary">
                            <div class="box-header with-border CommonHeader col-md-12">
                                <h3 class="box-title" id="lblHeadline" runat="server">Reset Password</h3>
                            </div>
                           
                            <!-- /.box-header -->
                            <!-- form start -->
                            <div class="box-body">  
                                <div class="col-md-6">
                                    <label for="txtNewPassword" class="col-sm-6 control-label">*Enter New Password:</label>
                                    <div class="col-sm-6">
                                        <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" CssClass="form-control"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" ControlToValidate="txtNewPassword" ValidationGroup="Contact"
                                            runat="server" ErrorMessage="Password Required" ForeColor="Red" Display="Dynamic">
                                        </asp:RequiredFieldValidator>

                                    </div>
                                </div>
                                
                                <div class="col-md-6">
                                    <label for="txtConfirmPassword" class="col-sm-6 control-label">*Enter Re-New Password:</label>
                                    <div class="col-sm-6">
                                        <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="form-control"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" ControlToValidate="txtConfirmPassword" ValidationGroup="Contact"
                                            runat="server" ErrorMessage="Confirm Password Required" ForeColor="Red" Display="Dynamic">
                                        </asp:RequiredFieldValidator>
                                        <asp:CompareValidator runat="server" ID="cvPassword" Display="Dynamic" ControlToValidate="txtConfirmPassword" ControlToCompare ="txtNewPassword" ForeColor="Red" ErrorMessage="New Password Does not Match" ></asp:CompareValidator>
                                    </div>
                                </div>
								 </div>
								 <div class="box-body">  
                                 <div class="col-md-12">
                                     <label class="col-sm-12 control-label" style="color:red;">We create a temporary password to create your account. We need you to change it to your own password.</label>
                                     </div>
                            </div>
                            <!-- /.box-body -->
                            <div class="box-footer">
                                <div class="col-md-6">
                                    <asp:Button ID="btnSave" runat="server" Text="Reset" OnClientClick="CheckVal()" OnClick="btnSubmit_Click" CssClass="btn btn-successNew" ValidationGroup="Contact" />

                                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnClose_Click" CssClass="btn btn-success " />
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
