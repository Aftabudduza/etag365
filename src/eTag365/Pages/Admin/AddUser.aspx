<%@ Page Title="eTag365: Create/Change User Profile" Language="C#" MasterPageFile="~/MasterPage/Site.master" AutoEventWireup="true" EnableEventValidation="false" CodeBehind="AddUser.aspx.cs" Inherits="eTag365.Pages.Admin.AddUser" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

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
                                <h3 class="box-title" id="lblHeadline" runat="server">Create/Change User Profile</h3>
                            </div>
                            <div>
                                <div class="box-body">
                                    <div class="col-md-3" style="min-height: 150px; float: left;">
                                        <div class="col-sm-12" id="imgProfile">
                                            <asp:Image ID="imgProfileLogo" runat="server" Width="125px" />
                                        </div>
                                    </div>
                                    <div class="col-md-9" style="float: left;">
                                        <div class="col-sm-6">
                                            125x125
                                        </div>
                                        <div class="col-sm-6">
                                            Profile Picture
                                        </div>
                                        <br />
                                        <br />
                                        <br />
                                        <div class="col-sm-6">
                                            <input type="file" class="form-control" id="fileProfileImageUpload" />
                                        </div>
                                        <div class="col-sm-3 btnSubmitDiv">
                                            <input type="button" value="Upload" class="btn btn-successnew" id="btnUpload" />
                                        </div>
                                        <br />
                                        <div class="col-sm-12" style="margin-top: 40px; margin-bottom: 0px; text-align: left; float: left;">
                                            <asp:CheckBox ID="chkProfile" runat="server" Text="Do not use photograph to embed into your contact on other accounts contacts." />
                                        </div>
                                    </div>
                                    <div class="box-header with-border CommonHeader col-md-12" style="background-color: #8B9DC3;">
                                        <h3 class="box-title" id="H2" runat="server">&nbsp;</h3>
                                    </div>
                                </div>

                                <div class="box-body">
                                    <div class="col-md-3" style="min-height: 150px; float: left;">
                                        <div class="col-sm-12" id="imgCompany">
                                            <asp:Image ID="imgCompanyLogo" runat="server" Width="125px" />
                                        </div>
                                    </div>
                                    <div class="col-md-9" style="float: left;">
                                        <div class="col-sm-6">
                                            125x125
                                        </div>
                                        <div class="col-sm-6">
                                            Company Logo
                                        </div>
                                        <br />
                                        <br />
                                        <br />
                                        <div class="col-sm-6">
                                            <input type="file" class="form-control" id="fileCompanyImageUpload" />
                                        </div>
                                        <div class="col-sm-3 btnSubmitDiv">
                                            <input type="button" value="Upload" class="btn btn-successnew" id="btnUploadCompany" />
                                        </div>
                                        <br />
                                        <div class="col-sm-12" style="margin-top: 40px; margin-bottom: 0px; text-align: left; float: left;">
                                            <asp:CheckBox ID="chkCompany" runat="server" Text="Do not use photograph to embed into your contact on other accounts contacts." />
                                        </div>
                                    </div>
                                    <div class="box-header with-border CommonHeader col-md-12" style="background-color: #8B9DC3;">
                                        <h3 class="box-title" id="H3" runat="server">&nbsp;</h3>
                                    </div>
                                </div>

                                <div class="box-body">
                                    <div class="col-md-6">
                                        <label for="txtNumber" class="col-sm-6 control-label">*Account ID:</label>
                                        <div class="col-sm-6">
                                            <asp:Label ID="lblSerial" runat="server"></asp:Label>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="col-sm-12">
                                            <asp:Label ID="lblMessage" ForeColor="Green" Font-Bold="true" Font-Size="Large" runat="server"></asp:Label>
                                        </div>
                                    </div>
                                </div>

                                <div class="box-body">
                                    <div class="col-md-6">
                                        <label for="txtContactName" class="col-sm-6 control-label">*First Name:</label>
                                        <div class="col-sm-6">
                                            <asp:TextBox ID="txtContactName" ClientIDMode="Static" runat="server" CssClass="form-control"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" Display="Dynamic" ControlToValidate="txtContactName" ValidationGroup="Contact"
                                                runat="server" ErrorMessage="First Name Required" ForeColor="Red"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="txtLastname" class="col-sm-6 control-label">*Last Name:</label>
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
                                        <label for="txtCompany" class="col-sm-6 control-label">Company Name:</label>
                                        <div class="col-sm-6">
                                            <asp:TextBox ID="txtCompany" runat="server" CssClass="form-control"></asp:TextBox>
                                            <%-- <asp:RequiredFieldValidator ID="RequiredFieldValidator5" ControlToValidate="txtCompany" ValidationGroup="Contact"
                                                runat="server" ErrorMessage="Company Name Required" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>--%>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <label for="txtEmail" class="col-sm-6 control-label">*Email:</label>
                                        <div class="col-sm-6">
                                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" ControlToValidate="txtEmail" ValidationGroup="Contact"
                                                runat="server" ErrorMessage="Email Address Required" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                                            <asp:RegularExpressionValidator Display="Dynamic" ID="RegularExpressionValidator2" ValidationGroup="Contact"
                                                runat="server" ErrorMessage="Invalid Email" ControlToValidate="txtEmail" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="txtReEmail" class="col-sm-6 control-label">*Re-Enter Email:</label>
                                        <div class="col-sm-6">
                                            <asp:TextBox ID="txtReEmail" runat="server" CssClass="form-control"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" ControlToValidate="txtReEmail" ValidationGroup="Contact"
                                                runat="server" ErrorMessage="Re-Enter Email Required" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                                            <asp:RegularExpressionValidator Display="Dynamic" ID="RegularExpressionValidator1" ValidationGroup="Contact"
                                                runat="server" ErrorMessage="Invalid Re-Enter Email" ControlToValidate="txtReEmail" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
                                            <asp:CompareValidator ID="CompareValidator1" ControlToValidate="txtReEmail" ForeColor="Red"
                                                ControlToCompare="txtEmail" Display="Dynamic" runat="server" ErrorMessage="Email Address Does Not Match"></asp:CompareValidator>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="col-sm-6 control-label" id="Label1" runat="server">*Country Code:</label>
                                        <div class="col-sm-6">
                                            <asp:DropDownList ID="ddlCountryCode" CssClass="form-control" runat="server">
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator Display="Dynamic" ID="RequiredFieldValidator5" runat="server" ControlToValidate="ddlCountryCode" InitialValue="-1" ErrorMessage="Please Select Country Code" ForeColor="Red" ValidationGroup="Contact"></asp:RequiredFieldValidator>
                                            <%--  <asp:TextBox ID="txtCC" runat="server" CssClass="form-control" MaxLength="5"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator5" ControlToValidate="txtCC" ValidationGroup="Contact"
                                                Display="Dynamic" runat="server" ErrorMessage="Country Code Required" ForeColor="Red"></asp:RequiredFieldValidator>
                                            <asp:RegularExpressionValidator Display="Dynamic" ID="RegularExpressionValidator6" ValidationGroup="Contact"
                                                runat="server" ErrorMessage="Invalid Country Code" ForeColor="Red" ControlToValidate="txtCC" ValidationExpression="\d+"></asp:RegularExpressionValidator>--%>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="col-sm-6 control-label" id="lblPhone" runat="server">*Cell Number:</label>
                                        <div class="col-sm-6">
                                            <asp:TextBox ID="txtNumber" runat="server" CssClass="form-control" MaxLength="10"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator4" ControlToValidate="txtNumber" ValidationGroup="Contact"
                                                Display="Dynamic" runat="server" ErrorMessage="Cell Number Required" ForeColor="Red"></asp:RequiredFieldValidator>
                                            <asp:RegularExpressionValidator Display="Dynamic" ID="RegularExpressionValidator26" ValidationGroup="Contact"
                                                runat="server" ErrorMessage="Invalid Cell Number" ForeColor="Red" ControlToValidate="txtNumber" ValidationExpression="^(?=(?:\D*\d){10,18}\D*$)(?:\(?0?[0-9]{1,3}\)?|\+?[0-9]{1,3})[\s-]?(?:\(0?[0-9]{1,5}\)|[0-9]{1,5})[-\s]?[0-9][\d\s-]{5,7}\s?(?:x[\d-]{0,4})?(?:[-\s]?[0-9]{1,4}|[-\s])$"></asp:RegularExpressionValidator>

                                        </div>
                                    </div>

                                </div>

                                <div class="box-body">

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
                                            <asp:RegularExpressionValidator Display="Dynamic" ID="RegularExpressionValidator5" ValidationGroup="Contact"
                                                runat="server" ErrorMessage="Invalid Ref Phone Number" ForeColor="Red" ControlToValidate="txtRefPhone" ValidationExpression="^(?=(?:\D*\d){10,18}\D*$)(?:\(?0?[0-9]{1,3}\)?|\+?[0-9]{1,3})[\s-]?(?:\(0?[0-9]{1,5}\)|[0-9]{1,5})[-\s]?[0-9][\d\s-]{5,7}\s?(?:x[\d-]{0,4})?(?:[-\s]?[0-9]{1,4}|[-\s])$"></asp:RegularExpressionValidator>

                                        </div>
                                    </div>



                                    <div class="col-md-6">
                                        <label for="txtAddress" class="col-sm-6 control-label">*Address:</label>
                                        <div class="col-sm-6">
                                            <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator6" Display="Dynamic" ControlToValidate="txtAddress" ValidationGroup="Contact"
                                                runat="server" ErrorMessage="Address Required" ForeColor="Red"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <label for="txtAddress1" class="col-sm-6 control-label">Address 1:</label>
                                        <div class="col-sm-6">
                                            <asp:TextBox ID="txtAddress1" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <label for="ddlCountry" class="col-sm-6 control-label" style="float: left;">*Country:</label>
                                        <div class="col-sm-6">
                                            <asp:DropDownList ID="ddlCountry" CssClass="form-control" runat="server">
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator Display="Dynamic" ID="countrytype" runat="server" ControlToValidate="ddlCountry" InitialValue="-1" ErrorMessage="Please select Country" ForeColor="Red" ValidationGroup="Contact"></asp:RequiredFieldValidator>
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
                                        <label for="ddlState" class="col-sm-6 control-label" style="float: left;">*State:</label>
                                        <div class="col-sm-6">
                                            <asp:DropDownList ID="ddlState" CssClass="form-control" runat="server">
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator Display="Dynamic" ID="RequiredFieldValidator8" runat="server" ControlToValidate="ddlState" InitialValue="-1" ErrorMessage="Please select State/Province" ForeColor="Red" ValidationGroup="Contact"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="txtCity" class="col-sm-6 control-label">*City:</label>
                                        <div class="col-sm-6">
                                            <asp:TextBox ID="txtCity" runat="server" CssClass="form-control"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator9" Display="Dynamic" ControlToValidate="txtCity" ValidationGroup="Contact"
                                                runat="server" ErrorMessage="City Required" ForeColor="Red"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                </div>

                                <div class="box-body">
                                    <div class="col-md-6">
                                        <label for="txtZip" class="col-sm-6 control-label">*Zip Code:</label>
                                        <div class="col-sm-6">
                                            <asp:TextBox ID="txtZip" runat="server" CssClass="form-control"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator10" Display="Dynamic" ControlToValidate="txtZip" ValidationGroup="Contact"
                                                runat="server" ErrorMessage="Zip Code Required" ForeColor="Red"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="txtWebsite" class="col-sm-6 control-label">Website Link:</label>
                                        <div class="col-sm-6">
                                            <asp:TextBox ID="txtWebsite" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                    </div>



                                    <div class="col-md-6">
                                        <label for="ddlCategory" class="col-sm-6 control-label" style="float: left;">Category:</label>
                                        <div class="col-sm-3">
                                            <asp:DropDownList ID="ddlCategory" CssClass="form-control" runat="server">
                                                <asp:ListItem Value="-1">N/A</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>

                                        <asp:HyperLink ID="HyperLink1" runat="server" class="col-sm-2 btn btn-success" NavigateUrl="~/system?Cat=1" Text="Add" />
                                    </div>

                                    <div class="col-md-6">
                                        <label for="ddlType" class="col-sm-6 control-label" style="float: left;">Types:</label>
                                        <div class="col-sm-3">
                                            <asp:DropDownList ID="ddlType" CssClass="form-control" runat="server">
                                                <asp:ListItem Value="-1">N/A</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                        <asp:HyperLink ID="HyperLink2" runat="server" class="col-sm-2 btn btn-success" NavigateUrl="~/system?C=1" Text="Add" />
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
                                        <label for="txtOther" class="col-sm-6 control-label">Other:</label>
                                        <div class="col-sm-6">
                                            <asp:TextBox ID="txtOther" TextMode="MultiLine" Height="100" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                    </div>

                                </div>

                                <div class="box-body">
                                    <div class="col-md-6">
                                        <label class="col-sm-6">
                                            <asp:CheckBox runat="server" ID="chkDealer" Text="Is Dealer" />
                                        </label>

                                        <div class="col-sm-6">
                                            <asp:CheckBox runat="server" Checked="false" ID="chkAdmin" Text="Is Admin" Style="float: left; padding-right: 13px;" />
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="col-sm-6">
                                            <asp:CheckBox runat="server" Checked="false" ID="chkEmailFlow" Text="Receive Email Flow" Style="float: left; padding-right: 13px;" />
                                        </div>
                                    </div>
                                </div>

                                <div class="box-header with-border CommonHeader col-md-12" style="background-color: #8B9DC3;">
                                    <h3 class="box-title" id="H1" runat="server">&nbsp;</h3>
                                </div>

                                <div class="box-body" style="margin-top: 0px; margin-bottom: 0px; text-align: center;">
                                    <div class="col-md-12" style="text-align: center;">
                                        <div class="col-sm-12">
                                            <asp:Button ID="btnAgreement" runat="server" Text="View Terms and Conditions Agreement" OnClick="btnAgreement_Click" CssClass="btn btn-success" />
                                        </div>
                                    </div>
                                    <div class="col-md-12" style="margin-top: 40px; margin-bottom: 0px; text-align: left;">
                                        <div class="col-sm-12">
                                            <asp:CheckBox ID="chkAgree" runat="server" ValidationGroup="Contact" Text="By checking this box I agree to all the terms and conditions within Terms and Conditions Agreement" />
                                            <asp:CustomValidator ID="CustomValidator1" runat="server" ForeColor="Red" ValidationGroup="Contact" ErrorMessage="Please accept the terms and conditions" OnServerValidate="CustomValidator1_ServerValidate"></asp:CustomValidator>
                                        </div>
                                    </div>
                                </div>

                                <!-- /.box-body -->
                                <div class="box-footer">
                                    <div class="col-md-12">
                                        <div class="col-md-4 btnSubmitDiv">
                                            <asp:Button ID="btnBack" runat="server" Text="Cancel" OnClick="btnBack_Click" CssClass="btn btn-success " />
                                        </div>

                                        <div class="col-md-4 btnSubmitDiv">
                                            <asp:Button ID="btnSave" runat="server" Text="Create / Update Account Profile" OnClientClick="CheckVal()" OnClick="btnSubmit_Click" CssClass="btn btn-success" ValidationGroup="Contact" />
                                        </div>
                                        <div class="col-md-4 btnSubmitDiv">
                                            <asp:Button ID="btnDeleteUser" runat="server" Text="Delete Account Profile" OnClientClick='return confirm("Are you sure you want to delete?");' OnClick="btnDeleteUser_Click" CssClass="btn btn-success " />
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
    <script type="text/javascript">
        var G_ImageName = "";
        //----- Web Page & Image -----//
        $("body").on("click", "#btnUpload", function () {
            if (document.getElementById("fileProfileImageUpload").value != "") {
                var file = document.getElementById('fileProfileImageUpload').files[0];
                G_ImageName = file.name;
                var fileName = document.getElementById("fileProfileImageUpload").value;
                var idxDot = fileName.lastIndexOf(".") + 1;
                var extFile = fileName.substr(idxDot, fileName.length).toLowerCase();
                if (extFile == "jpg" || extFile == "jpeg" || extFile == "png" || extFile == 'gif' || extFile == 'tiff') {

                    var reader = new FileReader();
                    reader.readAsDataURL(file);
                    reader.onload = UpdateFiles;
                } else {
                    alert("Only .gif, .jpg, .png, .tiff and .jpeg are allowed!");
                    $("#fileProfileImageUpload").val("");
                }
            }
            else {
                alert('Please select Profile Picture');
            }
        });

        function UpdateFiles(evt) {
            var currentPagePath = "/Pages/Admin/AddUser.aspx" + "/";
            //var pagePath = window.location.pathname + "/uploadprofilepicture";
            var pagePath = currentPagePath + "uploadprofilepicture";

            var result = evt.target.result;
            var fileName = document.getElementById("fileProfileImageUpload").value;
            var idxDot = fileName.lastIndexOf(".") + 1;
            var extFile = fileName.substr(idxDot, fileName.length).toLowerCase();

            var ImageSave = "";
            if (extFile == "jpg" || extFile == "jpeg") {
                ImageSave = result.replace("data:image/jpeg;base64,", "");
            }
            else if (extFile == "png") {
                ImageSave = result.replace("data:image/png;base64,", "");
            }
            else if (extFile == "gif") {
                ImageSave = result.replace("data:image/gif;base64,", "");
            }
            else if (extFile == "tiff") {
                ImageSave = result.replace("data:image/tiff;base64,", "");
            }


            if (G_ImageName === "undefined" || G_ImageName === "") {
                $("#fileProfileImageUpload").css({ 'border': '1px solid red' });
            } else {
                $.ajax({
                    type: "POST",
                    url: pagePath,
                    data: "{ 'Image':'" + ImageSave + "' , 'ImageName':'" + G_ImageName + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    error:
                        function (XMLHttpRequest, textStatus, errorThrown) {
                            alert("Profile Picture Upload failed");
                            G_ImageName = "";
                        },
                    success:
                        function (result) {
                            G_ImageName = "";

                            if (result.d == '') {
                                alert("Profile Picture Upload Failed !!");
                            } else {
                                var content = "";
                                var url = result.d;
                                content += "<a href='" + url + "' target='_blank'><img alt='" + url + "' width='125px' src= '" + url + "' /></a>";

                                $("#imgProfile").empty();
                                $("#imgProfile").append(content);
                                alert("Profile Picture Uploaded Successfully !!");

                            }
                        }

                });
            }
        }

        $("body").on("click", "#btnUploadCompany", function () {
            if (document.getElementById("fileCompanyImageUpload").value != "") {
                var file = document.getElementById('fileCompanyImageUpload').files[0];
                G_ImageName = file.name;
                var fileName = document.getElementById("fileCompanyImageUpload").value;
                var idxDot = fileName.lastIndexOf(".") + 1;
                var extFile = fileName.substr(idxDot, fileName.length).toLowerCase();
                if (extFile == "jpg" || extFile == "jpeg" || extFile == "png" || extFile == 'gif' || extFile == 'tiff') {

                    var reader = new FileReader();
                    reader.readAsDataURL(file);
                    reader.onload = UpdateFilesCompany;
                } else {
                    alert("Only .gif, .jpg, .png, .tiff and .jpeg are allowed!");
                    $("#fileCompanyImageUpload").val("");
                }
            }
            else {
                alert('Please select Company Logo');
            }
        });

        function UpdateFilesCompany(evt) {
            var currentPagePath = "/Pages/Admin/AddUser.aspx" + "/";
            var pagePath = currentPagePath + "uploadcompanypicture";
            //var pagePath = window.location.pathname + "/uploadcompanypicture";

            var result = evt.target.result;
            var fileName = document.getElementById("fileCompanyImageUpload").value;
            var idxDot = fileName.lastIndexOf(".") + 1;
            var extFile = fileName.substr(idxDot, fileName.length).toLowerCase();

            var ImageSave = "";
            if (extFile == "jpg" || extFile == "jpeg") {
                ImageSave = result.replace("data:image/jpeg;base64,", "");
            }
            else if (extFile == "png") {
                ImageSave = result.replace("data:image/png;base64,", "");
            }
            else if (extFile == "gif") {
                ImageSave = result.replace("data:image/gif;base64,", "");
            }
            else if (extFile == "tiff") {
                ImageSave = result.replace("data:image/tiff;base64,", "");
            }


            if (G_ImageName === "undefined" || G_ImageName === "") {
                $("#fileCompanyImageUpload").css({ 'border': '1px solid red' });
            } else {
                $.ajax({
                    type: "POST",
                    url: pagePath,
                    data: "{ 'Image':'" + ImageSave + "' , 'ImageName':'" + G_ImageName + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    error:
                        function (XMLHttpRequest, textStatus, errorThrown) {
                            alert("Company Logo Upload failed");
                            G_ImageName = "";
                        },
                    success:
                        function (result) {
                            G_ImageName = "";

                            if (result.d == '') {
                                alert("Company Logo Upload Failed !!");
                            } else {
                                var content = "";
                                var url = result.d;
                                content += "<a href='" + url + "' target='_blank'><img alt='" + url + "' width='125px' src= '" + url + "' /></a>";

                                $("#imgCompany").empty();
                                $("#imgCompany").append(content);
                                alert("Company Logo Uploaded Successfully !!");

                            }
                        }

                });
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
