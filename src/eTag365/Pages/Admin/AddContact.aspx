<%@ Page Title="eTag365: View/Edit Contact" Language="C#" MasterPageFile="~/MasterPage/Site.master" AutoEventWireup="true" EnableEventValidation="false" CodeBehind="AddContact.aspx.cs" Inherits="eTag365.Pages.Admin.AddContact" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <form id="form1" runat="server" class="form-horizontal">
        <asp:ScriptManager runat="server" ID="sc1">
        </asp:ScriptManager>
        <asp:UpdatePanel runat="server" ID="userpanel">
            <ContentTemplate>
                <div class="box">
                    <div class="box-header with-border CommonHeader col-md-12">
                        <h3 class="box-title" id="lblHeadline" runat="server">View/Change Contact Information</h3>
                    </div>
                    <!-- left column -->
                    <div class="col-md-12">
                        <!-- general form elements -->
                        <div class="box box-primary">
                            <!-- /.box-header -->
                            <!-- form start -->
                            <div class="box-body">
                                <div class="col-md-6">
                                    <label class="col-sm-6 control-label" id="Label1" runat="server">*Country Code:</label>
                                    <div class="col-sm-6">
                                        <asp:DropDownList ID="ddlCountryCode" CssClass="form-control" runat="server">
                                        </asp:DropDownList>
                                        <asp:RequiredFieldValidator Display="Dynamic" ID="RequiredFieldValidator5" runat="server" ControlToValidate="ddlCountryCode" InitialValue="-1" ErrorMessage="Please Select Country Code" ForeColor="Red" ValidationGroup="Contact"></asp:RequiredFieldValidator>

                                        <%-- <asp:TextBox ID="txtCC" runat="server" CssClass="form-control" MaxLength="5"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" ControlToValidate="txtCC" ValidationGroup="Contact"
                                            Display="Dynamic" runat="server" ErrorMessage="Country Code Required" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <asp:RegularExpressionValidator Display="Dynamic" ID="RegularExpressionValidator6" ValidationGroup="Contact"
                                            runat="server" ErrorMessage="Invalid Country Code" ForeColor="Red" ControlToValidate="txtCC" ValidationExpression="\d+"></asp:RegularExpressionValidator>--%>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label for="txtNumber" class="col-sm-6 control-label">*Cell Number:</label>
                                    <div class="col-sm-6">
                                        <asp:TextBox ID="txtNumber" runat="server" CssClass="form-control" MaxLength="20"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" ControlToValidate="txtNumber" ValidationGroup="Contact"
                                            Display="Dynamic" runat="server" ErrorMessage="Cell Number Required" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <asp:RegularExpressionValidator Display="Dynamic" ID="RegularExpressionValidator26" ValidationGroup="Contact"
                                            runat="server" ErrorMessage="Invalid Cell Number" ForeColor="Red" ControlToValidate="txtNumber" ValidationExpression="^(?=(?:\D*\d){10,18}\D*$)(?:\(?0?[0-9]{1,3}\)?|\+?[0-9]{1,3})[\s-]?(?:\(0?[0-9]{1,5}\)|[0-9]{1,5})[-\s]?[0-9][\d\s-]{5,7}\s?(?:x[\d-]{0,4})?(?:[-\s]?[0-9]{1,4}|[-\s])$"></asp:RegularExpressionValidator>

                                    </div>
                                </div>
                            </div>
                            <div class="box-body">
                                <div class="col-md-6">
                                    <label for="txtContactName" class="col-sm-6 control-label">*First Name:</label>
                                    <div class="col-sm-6">
                                        <asp:TextBox ID="txtContactName" runat="server" CssClass="form-control"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" Display="Dynamic" ControlToValidate="txtContactName" ValidationGroup="Contact"
                                            runat="server" ErrorMessage="First Name Required" ForeColor="Red"></asp:RequiredFieldValidator>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label for="txtLastName" class="col-sm-6 control-label">*Last Name:</label>
                                    <div class="col-sm-6">
                                        <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator7" Display="Dynamic" ControlToValidate="txtLastName" ValidationGroup="Contact"
                                            runat="server" ErrorMessage="Last Name Required" ForeColor="Red"></asp:RequiredFieldValidator>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label for="txtContactTitle" class="col-sm-6 control-label">Title:</label>
                                    <div class="col-sm-6">
                                        <asp:TextBox ID="txtContactTitle" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label for="txtCompany" class="col-sm-6 control-label">Company:</label>
                                    <div class="col-sm-6">
                                        <asp:TextBox ID="txtCompany" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>



                                <div class="col-md-6">
                                    <label for="txtAddress" class="col-sm-6 control-label">Address :</label>
                                    <div class="col-sm-6">
                                        <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control"></asp:TextBox>
                                        <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator3" Display="Dynamic" ControlToValidate="txtAddress" ValidationGroup="Contact"
                                            runat="server" ErrorMessage="Address 1 Required" ForeColor="Red"></asp:RequiredFieldValidator>--%>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label for="txtAddress1" class="col-sm-6 control-label">Address 1:</label>
                                    <div class="col-sm-6">
                                        <asp:TextBox ID="txtAddress1" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label for="ddlCountry" class="col-sm-6 control-label" style="float: left;">Country:</label>
                                    <div class="col-sm-6">
                                        <asp:DropDownList ID="ddlCountry" CssClass="form-control" runat="server">
                                        </asp:DropDownList>
                                        <%-- <asp:RequiredFieldValidator Display="Dynamic" ID="countrytype" runat="server" ControlToValidate="ddlCountry" InitialValue="-1" ErrorMessage="Please select Country" ForeColor="Red" ValidationGroup="Contact"></asp:RequiredFieldValidator>--%>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label for="txtRegion" class="col-sm-6 control-label">Region:</label>
                                    <div class="col-sm-6">
                                        <asp:TextBox ID="txtRegion" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div class="box-body">
                                <div class="col-md-6">
                                    <label for="ddlState" class="col-sm-6 control-label" style="float: left;">State:</label>
                                    <div class="col-sm-6">
                                        <asp:DropDownList ID="ddlState" CssClass="form-control" runat="server">
                                        </asp:DropDownList>
                                        <%--<asp:RequiredFieldValidator Display="Dynamic" ID="RequiredFieldValidator8" runat="server" ControlToValidate="ddlState" InitialValue="-1" ErrorMessage="Please select State/Province" ForeColor="Red" ValidationGroup="Contact"></asp:RequiredFieldValidator>--%>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label for="txtCity" class="col-sm-6 control-label">City:</label>
                                    <div class="col-sm-6">
                                        <asp:TextBox ID="txtCity" runat="server" CssClass="form-control"></asp:TextBox>
                                        <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator5" Display="Dynamic" ControlToValidate="txtCity" ValidationGroup="Contact"
                                            runat="server" ErrorMessage="City Required" ForeColor="Red"></asp:RequiredFieldValidator>--%>
                                    </div>
                                </div>
                            </div>
                            <div class="box-body">
                                <div class="col-md-6">
                                    <label for="txtZip" class="col-sm-6 control-label">Zip Code:</label>
                                    <div class="col-sm-6">
                                        <asp:TextBox ID="txtZip" runat="server" CssClass="form-control"></asp:TextBox>
                                        <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator6" Display="Dynamic" ControlToValidate="txtZip" ValidationGroup="Contact"
                                            runat="server" ErrorMessage="Zip Code Required" ForeColor="Red"></asp:RequiredFieldValidator>--%>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label for="txtEmail" class="col-sm-6 control-label">*Email Address:</label>
                                    <div class="col-sm-6">
                                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" ControlToValidate="txtEmail" ValidationGroup="Contact"
                                            runat="server" ErrorMessage="Email Address Required" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                                        <asp:RegularExpressionValidator Display="Dynamic" ID="RegularExpressionValidator2" ValidationGroup="Contact"
                                            runat="server" ErrorMessage="Invalid Email" ControlToValidate="txtEmail" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>

                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label for="txtWorkNumber" class="col-sm-6 control-label">Work Number:</label>
                                    <div class="col-sm-6">
                                        <asp:TextBox ID="txtWorkNumber" runat="server" CssClass="form-control" MaxLength="20"></asp:TextBox>
                                        <asp:RegularExpressionValidator Display="Dynamic" ID="RegularExpressionValidator3" ValidationGroup="Contact"
                                            runat="server" ErrorMessage="Invalid Work Number" ForeColor="Red" ControlToValidate="txtWorkNumber" ValidationExpression="^(?=(?:\D*\d){10,18}\D*$)(?:\(?0?[0-9]{1,3}\)?|\+?[0-9]{1,3})[\s-]?(?:\(0?[0-9]{1,5}\)|[0-9]{1,5})[-\s]?[0-9][\d\s-]{5,7}\s?(?:x[\d-]{0,4})?(?:[-\s]?[0-9]{1,4}|[-\s])$"></asp:RegularExpressionValidator>

                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label for="txtWorkNumberExt" class="col-sm-6 control-label">Work Number Extension:</label>
                                    <div class="col-sm-6">
                                        <asp:TextBox ID="txtWorkNumberExt" runat="server" CssClass="form-control" MaxLength="10"></asp:TextBox>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label for="txtFaxNumber" class="col-sm-6 control-label">Fax Number:</label>
                                    <div class="col-sm-6">
                                        <asp:TextBox ID="txtFaxNumber" runat="server" CssClass="form-control" MaxLength="20"></asp:TextBox>
                                        <asp:RegularExpressionValidator Display="Dynamic" ID="RegularExpressionValidator4" ValidationGroup="Contact"
                                            runat="server" ErrorMessage="Invalid Fax Number" ForeColor="Red" ControlToValidate="txtFaxNumber" ValidationExpression="^(?=(?:\D*\d){10,18}\D*$)(?:\(?0?[0-9]{1,3}\)?|\+?[0-9]{1,3})[\s-]?(?:\(0?[0-9]{1,5}\)|[0-9]{1,5})[-\s]?[0-9][\d\s-]{5,7}\s?(?:x[\d-]{0,4})?(?:[-\s]?[0-9]{1,4}|[-\s])$"></asp:RegularExpressionValidator>

                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label for="txtRefPhone" class="col-sm-6 control-label">Ref Phone Number:</label>
                                    <div class="col-sm-6">
                                        <asp:TextBox ID="txtRefPhone" runat="server" CssClass="form-control" MaxLength="20"></asp:TextBox>
                                        <asp:RegularExpressionValidator Display="Dynamic" ID="RegularExpressionValidator1" ValidationGroup="Contact"
                                            runat="server" ErrorMessage="Invalid Ref Phone Number" ForeColor="Red" ControlToValidate="txtRefPhone" ValidationExpression="^(?=(?:\D*\d){10,18}\D*$)(?:\(?0?[0-9]{1,3}\)?|\+?[0-9]{1,3})[\s-]?(?:\(0?[0-9]{1,5}\)|[0-9]{1,5})[-\s]?[0-9][\d\s-]{5,7}\s?(?:x[\d-]{0,4})?(?:[-\s]?[0-9]{1,4}|[-\s])$"></asp:RegularExpressionValidator>

                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label for="txtWebsite" class="col-sm-6 control-label">Website Link:</label>
                                    <div class="col-sm-6">
                                        <asp:TextBox ID="txtWebsite" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>

                            </div>
                            <div class="box-body">

                                <div class="col-md-6">
                                    <label for="ddlCategory" class="col-sm-6 control-label" style="float: left;">Category:</label>
                                    <div class="col-sm-3">
                                        <asp:DropDownList ID="ddlCategory" CssClass="form-control" runat="server">
                                            <asp:ListItem Value="-1">N/A</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>

                                    <asp:HyperLink runat="server" class="col-sm-2 btn btn-success" NavigateUrl="~/system?Cat=1" Text="Add" />
                                </div>

                                <div class="col-md-6">
                                    <label for="ddlType" class="col-sm-6 control-label" style="float: left;">Types:</label>
                                    <div class="col-sm-3">
                                        <asp:DropDownList ID="ddlType" CssClass="form-control" runat="server">
                                            <asp:ListItem Value="-1">N/A</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                    <asp:HyperLink runat="server" class="col-sm-2 btn btn-success" NavigateUrl="~/system?C=1" Text="Add" />
                                </div>


                                <div class="col-md-6">
                                    <label for="txtLongitude" class="col-sm-6 control-label">Longitude:</label>
                                    <div class="col-sm-6">
                                        <asp:TextBox ID="txtLongitude" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label for="txtLatitude" class="col-sm-6 control-label">Latitude:</label>
                                    <div class="col-sm-6">
                                        <asp:TextBox ID="txtLatitude" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label for="txtOther" class="col-sm-6 control-label">Other Info/ Backside:</label>
                                    <div class="col-sm-6">
                                        <asp:TextBox ID="txtOther" TextMode="MultiLine" Height="100" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label for="txtMemo" class="col-sm-6 control-label">Memo:</label>
                                    <div class="col-sm-6">
                                        <asp:TextBox ID="txtMemo" TextMode="MultiLine" Height="100" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="col-sm-6">
                                        <asp:CheckBox runat="server" Checked="false" ID="chkEmailFlow" Text="Receive Email Flow" Style="float: left; padding-right: 13px;" />
                                    </div>
                                </div>
                            </div>
                            <!-- /.box-body -->
                            <div class="box-footer">
                                <div class="col-md-12">
                                    <div class="col-md-3 btnSubmitDiv">
                                        <asp:Button ID="btnBack" runat="server" Text="Cancel" OnClick="btnBack_Click" CssClass="btn btn-success" />
                                    </div>
                                    <div class="col-md-3 btnSubmitDiv">
                                        <asp:Button ID="btnSave" runat="server" Text="Update" OnClientClick="CheckVal()" OnClick="btnSubmit_Click" CssClass="btn btn-successNew" ValidationGroup="Contact" />
                                    </div>
                                    <div class="col-md-3 btnSubmitDiv">
                                        <asp:Button ID="btnDelete" runat="server" Text="Delete" OnClientClick='return confirm("Are you sure you want to delete?");' OnClick="btnDelete_Click" CssClass="btn btn-success" />
                                    </div>
                                    <div class="col-md-3 btnSubmitDiv">
                                        <asp:Button ID="btnCancel" runat="server" Text="Clear Form" OnClick="btnClose_Click" CssClass="btn btn-success" />
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

        .box-header.with-border {
            border-bottom: none;
            text-align: center;
        }

        .box {
            position: relative;
            background: none;
            border-top: none;
            margin-bottom: 20px;
            width: 100%;
            box-shadow: none;
        }
    </style>
</asp:Content>
