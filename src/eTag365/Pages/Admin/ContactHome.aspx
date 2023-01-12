<%@ Page Title="eTag365: Contact Information" Language="C#" MasterPageFile="~/MasterPage/Site.master" AutoEventWireup="true" CodeBehind="ContactHome.aspx.cs" Inherits="eTag365.Pages.Admin.ContactHome" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <form id="form1" runat="server" class="form-horizontal">
        <asp:ScriptManager runat="server" ID="sc1">
        </asp:ScriptManager>
        <asp:UpdatePanel runat="server" ID="userpanel">
            <ContentTemplate>
                <div class="box">
                    <div class="box-header with-border CommonHeader col-md-12">
                        <h3 class="box-title" id="lblHeadline" runat="server">Contact Information</h3>
                    </div>
                    <div class="box-body">
                        <div class="form-group">
                            <div class="col-md-6">
                                <input type="text" id="search" name="search" runat="server" class="form-control search-box" placeholder="First Name/Last Name/Email/Phone/Company" />
                            </div>
                            <div class="col-md-6">
                                <asp:Button ID="btnsearch" runat="server" class="col-sm-3" Text="Search" OnClick="btnsearch_Click" CssClass="btn btn-success " />
                            </div>
                            <div class="col-md-6">
                                <label for="ddlSortBy" class="col-sm-3 control-label" style="float: left;">Sort By:</label>
                                <div class="col-sm-6">
                                    <asp:DropDownList ID="ddlSortBy" CssClass="form-control" OnSelectedIndexChanged="ddlSortBy_SelectedIndexChanged" AutoPostBack="true" runat="server">
                                        <asp:ListItem Value="Id">Last Name First In</asp:ListItem>
                                        <asp:ListItem Value="FirstName">First Name</asp:ListItem>
                                        <asp:ListItem Value="LastName">Last Name</asp:ListItem>
                                        <asp:ListItem Value="CompanyName">Company</asp:ListItem>
                                        <asp:ListItem Value="Category">Category</asp:ListItem>
                                        <asp:ListItem Value="TypeOfContact">Types</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label for="ddlPageSize" class="col-sm-3 control-label">Page Size:</label>
                                <div class="col-sm-6">
                                    <asp:DropDownList ID="ddlPageSize" OnSelectedIndexChanged="ddlPageSize_SelectedIndexChanged" AutoPostBack="true" CssClass="form-control" runat="server">
                                        <asp:ListItem Value="25">25</asp:ListItem>
                                        <asp:ListItem Value="50">50</asp:ListItem>
                                        <asp:ListItem Value="100">100</asp:ListItem>
                                        <asp:ListItem Value="500">500</asp:ListItem>
                                        <asp:ListItem Value="1000">1000</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="box-body">
                        
                        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ appSettings:ConnectionString %>"
                            SelectCommand=" select *, UserImage=isnull((select Top 1 ProfileLogo from UserProfile where UserProfile.Phone = ContactInformation.Phone),''), CompanyLogo=isnull((select Top 1 CompanyLogo from UserProfile where UserProfile.Phone = ContactInformation.Phone),'') from  ContactInformation where UserID  = @UserId order by Id desc  ">
                            <SelectParameters>
                                <asp:SessionParameter Name="UserId" SessionField="UserId" Type="String" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                        
                    </div>
                    <div class="box-body">
                        <asp:ListView ID="InventoryItems" DataKeyNames="Id" runat="server" ItemContainerID="layoutTemplate"
                            ItemPlaceholderID="layoutTemplate" DataSourceID="SqlDataSource1">
                            <EmptyDataTemplate>
                            </EmptyDataTemplate>
                            <LayoutTemplate>
                                <table width="80%" cellpadding="0" cellspacing="0">
                                    <tbody id="layoutTemplate" runat="server">
                                    </tbody>
                                </table>
                            </LayoutTemplate>
                            <ItemTemplate>
                                <tr>
                                    <td valign="top">
                                        <div class="col-md-12 box-contact-main">
                                            <div class="col-md-3" style="float:left; margin-top:5px;">
                                                <img style="width: 60px; margin-bottom:10px; border-width: 0px;" alt='' src='<%#GetImageFileName(Eval("UserImage").ToString())%>'><br />
                                                <img style="width: 60px; margin-bottom:10px; border-width: 0px;" alt='' src='<%#GetImageFileName(Eval("CompanyLogo").ToString())%>'>
                                            </div>
                                            <div class="col-md-6" style="float:left;">
                                                <asp:Label ID="lblFirstName" class="col-sm-3 control-label" Style="float: left; padding-left:0px;" runat="server" Text='<%# Eval("FirstName") %>'></asp:Label>
                                                <asp:Label ID="lblLastName" class="col-sm-3 control-label" Style="float: left;padding-left:0px;" runat="server" Text='<%# Eval("LastName") %>'></asp:Label><br />
                                                <asp:Label ID="lblTitle" class="col-sm-12 control-label" Style="float: left;padding-left:0px;" runat="server" Text='<%# Eval("Title") %>'></asp:Label><br />
                                                <asp:Label ID="lblPhone" class="col-sm-12 control-label" Style="float: left;padding-left:0px;" runat="server" Text='<%# Eval("Phone") %>'></asp:Label><br />
                                                <asp:Label ID="lblCompanyName" class="col-sm-12 control-label" Style="float: left;padding-left:0px;" runat="server" Text='<%# Eval("CompanyName") %>'></asp:Label><br />
                                                <asp:Label ID="lblEmail" class="col-sm-12 control-label" Style="float: left;padding-left:0px;" runat="server" Text='<%# Eval("Email") %>'></asp:Label><br />
                                                
                                               <%-- <asp:Label ID="Label1" class="col-sm-12 control-label" Style="float: left;padding-left:0px; font-weight:bold; color:blue;" runat="server" Text="Remember in theory you can have unlimited categories"></asp:Label><br />--%>
                                                 <asp:Label ID="Label2" class="col-sm-3 control-label" Style="float: left;padding-left:0px;" runat="server" Text="Category: "></asp:Label>
                                                <asp:Label ID="lblCategory" class="col-sm-9 control-label" Style="float: left;padding-left:0px;" runat="server" Text='<%# Eval("Category") %>'></asp:Label><br />
                                                 <asp:Label ID="lblType" class="col-sm-12 control-label" Style="float: left;padding-left:0px;" runat="server" Text='<%# Eval("TypeOfContact") %>'></asp:Label><br />
                                            </div>
                                            <div class="col-md-3" style="float:left;">                                                
                                                 <div class="col-sm-12" style="float:left; min-height:50px; padding-bottom: 10px;">
                                                      <asp:Label ID="lblOther" class="control-label" Style="float: left;" runat="server" Text='<%# Eval("Other") %>'></asp:Label>
                                                     </div>
                                                <asp:HyperLink runat="server" class="col-sm-12 control-label" Style="float: left; color:#337ab7;" NavigateUrl='<%# Eval("Id", "~/{0}/contact?CId={0}") %>' Text='View More>>' />
                                                <br /><br />
                                                 <asp:HyperLink runat="server" class="col-sm-12 control-label" Style="float: left; color:#337ab7;" NavigateUrl="~/system?Cat=1" Text="Click to Add Categories" />
                                                <br />
                                              <asp:HyperLink runat="server" class="col-sm-12 control-label" Style="float: left; color:#337ab7;" NavigateUrl="~/system?C=1" Text="Click to Add Type" />
                                                
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:ListView>
                    </div>
                    <div class="box-body">
                        <div class="col-md-12">
                            <asp:DataPager ID="Pager" runat="server" PagedControlID="InventoryItems">
                                <Fields>
                                    <asp:TemplatePagerField>
                                        <PagerTemplate>
                                            <br />
                                            Page:
                                        </PagerTemplate>
                                    </asp:TemplatePagerField>
                                    <asp:NextPreviousPagerField ButtonType="Link" ShowFirstPageButton="false" ShowNextPageButton="false"
                                        ShowPreviousPageButton="true" FirstPageText="First" />
                                    <asp:NumericPagerField ButtonType="Link" ButtonCount="20" NumericButtonCssClass="noteIndex" />
                                    <asp:NextPreviousPagerField ButtonType="Link" ShowLastPageButton="false" ShowNextPageButton="true"
                                        ShowPreviousPageButton="false" LastPageText="Last" />
                                </Fields>
                            </asp:DataPager>
                        </div>

                    </div>
                    <!-- left column -->
                    <div class="col-md-12">
                        <!-- general form elements -->
                        <div class="box box-primary">
                            <div class="box-footer">
                                <div class="col-md-12">
                                    <div class="col-md-4 btnSubmitDiv">
                                        <asp:Button ID="btnBack" runat="server" Text="< Back" OnClick="btnBack_Click" CssClass="btn btn-success" />
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
        $(".nav nav-tabs  li a").on("click", function () {
            $(".nav nav-tabs  li").find(".active").removeClass("active");
            $(this).addClass("active");
        });
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
        .box-contact-main{
            float: left;
            border: 1px solid #808080;
            border-radius: 3px;
            padding: 5px;
            margin: 10px 0;
            display: inline;
        }
    </style>
</asp:Content>
