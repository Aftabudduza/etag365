<%@ Page Title="eTag365: Billing Transaction Listing" Language="C#" MasterPageFile="~/MasterPage/Site.master" AutoEventWireup="true" EnableEventValidation="false" CodeBehind="BillingTransactionList.aspx.cs" Inherits="eTag365.Pages.Admin.BillingTransactionList" %>
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
                                <h3 class="box-title" id="lblHeadline" runat="server">Billing Transaction Listing</h3>
                            </div>

                            <div class="box-body">
                                <div class="form-group">
                                    <div class="col-md-6">
                                        <input type="text" id="search" name="search" runat="server" class="form-control search-box" placeholder="Enter Transaction Id or Phone" />
                                    </div>
                                    <div class="col-md-6">
                                        <asp:Button ID="btnsearch" runat="server" Text="Search" OnClick="btnsearch_Click" CssClass="btn btn-success " />
                                    </div>
                                </div>
                            </div>

                            <div class="box-body">
                                <form class="vertical-form">
                                    <fieldset>
                                         
                                        <asp:GridView Width="100%" ID="gvContactList" runat="server" AutoGenerateColumns="False" CellPadding="10" ForeColor="#333333" CssClass="table table-bordered table-striped"
                                            GridLines="None" AllowPaging="True" OnPageIndexChanging="gvContactList_PageIndexChanging"
                                            OnSorting="gvContactList_Sorting" PageSize="20" Style="float: left; margin-bottom: 10px;" AllowSorting="True">
                                            <PagerSettings Position="TopAndBottom" />
                                            <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                                            <Columns>                                              

                                               <asp:TemplateField HeaderText="Phone" SortExpression="Data">
                                                    <ItemTemplate>
                                                        <asp:Label runat="server" Text='<%# Eval("FromUser") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                                                </asp:TemplateField>
                                               <asp:TemplateField HeaderText="Last 4" SortExpression="Data">
                                                    <ItemTemplate>
                                                        <asp:Label runat="server" Text='<%# Eval("LastFourDigitCard") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Tran ID" SortExpression="Data">
                                                    <ItemTemplate>
                                                        <asp:Label runat="server" Text='<%# Eval("TransactionCode") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                                                </asp:TemplateField>
                                                  <asp:TemplateField HeaderText="Plan" SortExpression="Data">
                                                    <ItemTemplate>
                                                        <asp:Label runat="server" Text='<%# Eval("SubscriptionType") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                                                </asp:TemplateField>
                                                 <asp:TemplateField HeaderText="Billed Monthly" SortExpression="Data">
                                                    <ItemTemplate>
                                                        <asp:Label runat="server" Text='<%# Eval("IsBillingCycleMonthly") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Promo Code" SortExpression="Data">
                                                    <ItemTemplate>
                                                        <asp:Label runat="server" Text='<%# Eval("Promocode") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                                                </asp:TemplateField>
                                                 <asp:TemplateField HeaderText="Discount ($)" SortExpression="Data">
                                                    <ItemTemplate>
                                                        <asp:Label runat="server" Text='<%# Eval("Discount","{0:c}") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                                                </asp:TemplateField>
                                                 <asp:TemplateField HeaderText="Amount ($)" SortExpression="Data">
                                                    <ItemTemplate>
                                                        <asp:Label runat="server" Text='<%# Eval("GrossAmount","{0:c}") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Date" SortExpression="Data">
                                                    <ItemTemplate>
                                                        <asp:Label runat="server" Text='<%#DataBinder.Eval(Container.DataItem, "CreateDate", "{0:MM/dd/yyyy hh:mm:ss tt}")%>'></asp:Label>
                                                    </ItemTemplate>
                                                    <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                                                </asp:TemplateField>

                                               <asp:TemplateField HeaderText="Storage Limit" SortExpression="Data">
                                                    <ItemTemplate>
                                                        <asp:Label runat="server" Text='<%# Eval("Contact_Storage_Limit") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                                                </asp:TemplateField>
                                                

                                                <asp:TemplateField HeaderText="Status" SortExpression="Data">
                                                    <ItemTemplate>
                                                        <asp:Label runat="server" Text='<%# Eval("TransactionDescription") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                                                </asp:TemplateField>

                                                <asp:TemplateField HeaderText="Action" ItemStyle-HorizontalAlign="Center">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblAppId" runat="server" Visible="False" Text='<%# Eval("Id") %>' />
                                                        <asp:LinkButton CssClass="btn btn-success" ID="btnApprove" OnClick="btnApprove_Click" runat="server" Text="Approve"></asp:LinkButton>
                                                        <asp:LinkButton CssClass="btn btn-success" ID="btnReject" OnClick="btnReject_Click" runat="server" Text="Reject"></asp:LinkButton>
                                                    </ItemTemplate>
                                                    <HeaderStyle HorizontalAlign="Center" ForeColor="Black" />

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

            </ContentTemplate>
        </asp:UpdatePanel>
    </form>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    


</asp:Content>
