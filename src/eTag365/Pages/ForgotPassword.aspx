<%@ page title="eTag365: Forgotten Password" language="C#" masterpagefile="~/MasterPage/NewUser.master" autoeventwireup="true" codebehind="ForgotPassword.aspx.cs" inherits="eTag365.Pages.ForgotPassword" %>


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
                                    <h3 class="box-title" id="lblHeadline" runat="server">Reset Password</h3>
                                </div>
                           
                                <!-- /.box-header -->
                                <!-- form start -->
                                <div class="box-body">  
                                   <div class="col-md-6">
                                        <label for="txtNumber" class="col-sm-3 control-label">Enter New Cell Number:</label>
                                        <div class="col-sm-6">
                                            <asp:TextBox ID="txtNumber" runat="server" CssClass="form-control"></asp:TextBox>
                                           <%-- <asp:RequiredFieldValidator ID="RequiredFieldValidator4" ControlToValidate="txtNumber" ValidationGroup="Contact"
                                                Display="Dynamic" runat="server" ErrorMessage="Phone Number Required" ForeColor="Red"></asp:RequiredFieldValidator>--%>
                                             <asp:RegularExpressionValidator Display="Dynamic" ID="RegularExpressionValidator1"  ValidationGroup="Contact"
                                                runat="server" ErrorMessage="Invalid Cell Number" ForeColor="Red" ControlToValidate="txtNumber" 
                                                 ValidationExpression="^(?=(?:\D*\d){10,18}\D*$)(?:\(?0?[0-9]{1,3}\)?|\+?[0-9]{1,3})[\s-]?(?:\(0?[0-9]{1,5}\)|[0-9]{1,5})[-\s]?[0-9][\d\s-]{5,7}\s?(?:x[\d-]{0,4})?(?:[-\s]?[0-9]{1,4}|[-\s])$"></asp:RegularExpressionValidator>
                                        </div>
                                    </div>
                                     <div class="col-md-6">
                                    <label for="txtEmail" class="col-sm-3 control-label">Enter Email Address:</label>
                                    <div class="col-sm-6">
                                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control"></asp:TextBox>
                                       <%-- <asp:RequiredFieldValidator ID="RequiredFieldValidator2" ControlToValidate="txtEmail" ValidationGroup="Contact"
                                            runat="server" ErrorMessage="Email Address Required" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>--%>
                                        <asp:RegularExpressionValidator Display="Dynamic" ID="RegularExpressionValidator2" ValidationGroup="Contact"
                                            runat="server" ErrorMessage="Invalid Email Address" ForeColor="Red" ControlToValidate="txtEmail" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
                                    </div>
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
