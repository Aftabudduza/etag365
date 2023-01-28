<%@ Page Title="eTag365: Event Calendar  Master of Users Appointments" Language="C#" MasterPageFile="~/MasterPage/Site.master" AutoEventWireup="true" Debug="true" CodeBehind="UserAppointment.aspx.cs" Inherits="eTag365.UserAppointment" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <form id="form11" runat="server" class="form-horizontal">
        <asp:ScriptManager runat="server" ID="sc1">
        </asp:ScriptManager>
        <asp:UpdatePanel ID="upnlImageVideoUpld" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <!-- left column -->
                <div class="col-md-12" style="padding-left: 0px; padding-right: 0px">
                    <!-- general form elements -->
                    <div class="box box-primary">
                        <div class="box-header with-border CommonHeader col-md-12">
                            <h3 class="box-title" id="lblHeadline" runat="server">Event Calendar  Master of Users Appointments</h3>

                        </div>
                        <!-- /.box-header -->
                        <!-- form start -->
                        <div class="box-body">
                            <div class="col-md-6">
                                <asp:HiddenField ID="hdUserId" runat="server" Value="" />
                                <label visible="false" id="lblUserEmail" runat="server" class="col-sm-3 control-label">&nbsp;</label>
                            </div>
                            <div class="col-md-6" style="text-align: center">

                                <label id="lblUserName" runat="server" class="control-label"></label>


                            </div>
                        </div>

                        <div class="box-body">
                            <div class="col-md-6">
                                <label class="control-label">Enter or click on calendar date for the week:</label>
                            </div>

                            <div class="col-md-3" style="float: left;">
                                <asp:TextBox ID="txtDate" runat="server" CssClass="form-control" AutoPostBack="true" OnTextChanged="txtDate_TextChanged" />
                                <asp:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtDate"
                                    Format="MM-dd-yyyy">
                                </asp:CalendarExtender>
                            </div>


                            <div class="col-md-6">
                                <label class="control-label">click on the times you will be available for appointments:</label>
                            </div>

                            <div class="col-md-3" style="float: left; padding-top: 10px;">
                                Timezone: <span id="spanTimezone" style="width: 100px;" runat="server"></span>
                            </div>

                        </div>

                    </div>
                </div>

                <div class="col-md-12">
                    <asp:GridView Width="100%" ID="gvContactList" runat="server" AutoGenerateColumns="False" CellPadding="10" ForeColor="#333333" CssClass="table table-responsive table-bordered table-striped"
                        GridLines="None" OnPageIndexChanging="gvContactList_PageIndexChanging"
                        OnSorting="gvContactList_Sorting" AllowPaging="True" PageSize="20" Style="float: left; margin-bottom: 10px;" AllowSorting="True">
                        <PagerSettings Position="TopAndBottom" />
                        <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                        <Columns>
                            <asp:TemplateField HeaderText="Timezone" SortExpression="Data">
                                <ItemTemplate>
                                    <asp:Label runat="server" Text='<%# Eval("Timezone") %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Duration" SortExpression="Data">
                                <ItemTemplate>
                                    <asp:Label runat="server" Text='<%# Eval("Duration") %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Start On" SortExpression="Data">
                                <ItemTemplate>
                                    <asp:Label runat="server" Text='<%# Eval("MeetingStartTimeShow") %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Action" ItemStyle-HorizontalAlign="Left">
                                <ItemTemplate>
                                    <asp:Label ID="lblId" runat="server" Text='<%# Eval("Id") %>' Visible="false"></asp:Label>
                                    <asp:LinkButton ID="btnDetails" runat="server" Text="View Details" CssClass="btn btn-success" OnClick="btnDetails_Click"></asp:LinkButton>
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
                        <PagerStyle CssClass="pager" ForeColor="Blue" HorizontalAlign="Center" />
                        <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                        <HeaderStyle Font-Bold="True" ForeColor="Black" />
                        <EditRowStyle BackColor="#999999" />
                        <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                    </asp:GridView>
                </div>

                <div class="col-md-12">
                    <label class="control-label col-sm-6">double click on time  to get detail information</label>
                    <label id="lblMeetingTime" runat="server" class="col-sm-3 control-label">&nbsp;</label>
                </div>

                <div class="col-md-12" style="margin-top:10px; float:left;">
                    <asp:GridView Width="100%" ID="gvSchedule" runat="server" AutoGenerateColumns="False" CellPadding="10" ForeColor="#333333" CssClass="table table-responsive table-bordered table-striped"
                        GridLines="None"  AllowPaging="True" PageSize="20" Style="float: left; margin-bottom: 10px;" AllowSorting="True">
                        <PagerSettings Position="TopAndBottom" />
                        <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                        <Columns>
                            <asp:TemplateField HeaderText="First Name" SortExpression="Data">
                                <ItemTemplate>
                                    <asp:Label runat="server" Text='<%# Eval("ToUserFirstName") %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Last Name" SortExpression="Data">
                                <ItemTemplate>
                                    <asp:Label runat="server" Text='<%# Eval("ToUserLastName") %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Company" SortExpression="Data">
                                <ItemTemplate>
                                    <asp:Label runat="server" Text='<%# Eval("ToUserCompany") %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                            </asp:TemplateField>
                             <asp:TemplateField HeaderText="Email" SortExpression="Data">
                                <ItemTemplate>
                                    <asp:Label runat="server" Text='<%# Eval("ToUserEmail") %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Phone" SortExpression="Data">
                                <ItemTemplate>
                                    <asp:Label runat="server" Text='<%# Eval("ToUserPhone") %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Left" ForeColor="Black" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Action" ItemStyle-HorizontalAlign="Left">
                                <ItemTemplate>
                                    <asp:Label ID="lblInId" runat="server" Text='<%# Eval("Id") %>' Visible="false"></asp:Label>
                                    <asp:LinkButton ID="btnInvite" runat="server" Text="re-send invite" CssClass="btn btn-success" OnClick="btnInvite_Click"></asp:LinkButton>
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
                        <PagerStyle CssClass="pager" ForeColor="Blue" HorizontalAlign="Center" />
                        <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                        <HeaderStyle Font-Bold="True" ForeColor="Black" />
                        <EditRowStyle BackColor="#999999" />
                        <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                    </asp:GridView>
                </div>

                <div class="box-footer">
                    <div class="col-md-3 btnSubmitDiv">
                        <asp:Button Visible="false" ID="btnSave" runat="server" Text="Save" OnClientClick="CheckVal()" CssClass="btn btn-successNew" OnClick="btnSubmit_Click" />
                    </div>

                    <div class="col-md-3 btnSubmitDiv">
                        <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-success" OnClick="btnClose_Click" />
                    </div>
                </div>

            </ContentTemplate>
        </asp:UpdatePanel>
    </form>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/themes/smoothness/jquery-ui.css" />
    <script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js"></script>
    <script type="text/javascript">
        $(function () {       

            $(".datepicker").datepicker({
                dateFormat: 'dd-MM-yy',
                changeMonth: true,
                changeYear: true
            });
        });

    </script>
    <script type="text/javascript">
        function CheckVal() {
            if (typeof (Page_ClientValidate) == 'function') {
                Page_ClientValidate();
            }
        }
    </script>
    <style type="text/css">
        .pagination .current {
            background: #E2DED6;
            font-weight: bold;
        }

        .Pager a {
            color: #000000;
            text-decoration: none;
        }

        .Pager hover {
            color: #AAFF00;
            text-decoration: none;
        }

        .Pager {
            color: #885454;
            text-decoration: none;
            background-color: #FFF7E7;
        }

            .pager span {
                color: #009900;
                font-weight: bold;
                font-size: 14pt;
            }
    </style>
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
