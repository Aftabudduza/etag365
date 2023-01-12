<%@ Page Title="eTag365: Event Calendar  of User Availability Scheduler" Language="C#" MasterPageFile="~/MasterPage/Site.master" AutoEventWireup="true" EnableEventValidation="false" CodeBehind="CalendarEntryN.aspx.cs" Inherits="eTag365.Pages.CalendarEntryN" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <form id="form1" runat="server" class="form-horizontal">
        <asp:ToolkitScriptManager runat="server" ID="sc1">
        </asp:ToolkitScriptManager>
        <asp:UpdatePanel runat="server" ID="UpdatePanel8"  UpdateMode="Conditional">
            <ContentTemplate>
                <div class="box">
                    <!-- left column -->
                    <div class="col-md-12">
                        <!-- general form elements -->
                        <div class="box box-primary">
                            <div class="box-header with-border CommonHeader col-md-12">
                                <h3 class="box-title" id="lblHeadline" runat="server">Event Calendar of User Availability Scheduler</h3>
                            </div>
                            <!-- /.box-header -->
                            <!-- form start -->
                            <div class="box-body">
                                <div class="col-md-12">
                                    <label id="lblUserName" runat="server" class="col-sm-3 control-label"></label>
                                    <label id="lblUserEmail" runat="server" class="col-sm-3 control-label"></label>
                                </div>
                            </div>
                            <div class="box-body">
                                <div class="col-md-4" style="float: left;">
                                    <label for="txtEmailServer" class="col-sm-12 control-label">Setup Monthly Availability Calendar</label>
                                </div>
                                <div class="col-md-6" style="float: left;">
                                    <asp:RadioButtonList runat="server" ID="rdoLength" CssClass="col-sm-12" RepeatDirection="Horizontal">
                                        <asp:ListItem Selected="True" Value="30">Length of 30 minutes</asp:ListItem>
                                        <asp:ListItem Value="60">Length of 1 Hour</asp:ListItem>
                                    </asp:RadioButtonList>
                                </div>
                                <div class="col-md-12" style="float: left;">
                                    <asp:RadioButtonList runat="server" ID="rdoTimezone" CssClass="col-sm-12" RepeatDirection="Horizontal">
                                        <asp:ListItem Selected="True" Value="5">Eastern Standard</asp:ListItem>
                                        <asp:ListItem Value="6">Central Standard</asp:ListItem>
                                        <asp:ListItem Value="7">Mountain Standard</asp:ListItem>
                                        <asp:ListItem Value="8">Pacific Standard</asp:ListItem>
                                    </asp:RadioButtonList>
                                </div>

                                <div class="col-md-12">
                                    <p style="color: red; float: left">Copy the link below to allow your customer the ability to link to your Event Calendar Availability and to schedule appointment with you. Press Copy button and the link will be place into your computer's clipboard. Place your cursor on your Emails, Linkedin and Facebooks Post where you want the link to show and use Paste function.</p>
                                </div>

                                <div class="col-md-6">
                                    <asp:TextBox ID="txtLink" ReadOnly="true" runat="server" CssClass="form-control js-copytextarea"></asp:TextBox>
                                    <%-- <textarea class="js-copytextarea">Hello I'm some text</textarea>--%>
                                </div>
                                <div class="col-md-1 btnSubmitDiv">
                                    <button class="js-textareacopybtn btn btn-success" style="vertical-align: top;">Copy</button>
                                    <%-- <asp:Button ID="btnCopy" runat="server" Text="Copy" OnClick="btnCopy_Click" CssClass="btn btn-success " />--%>
                                </div>
                            </div>
                            <div class="box-body">
                                <div class="col-md-6" style="float: left;">
                                    <label class="control-label">Enter date or click on calendar date for the week you want show your availability:</label>
                                </div>
                                <div class="col-md-3" style="float: left;">
                                    <asp:TextBox ID="txtDate" runat="server" CssClass="form-control" AutoPostBack="true" OnTextChanged="txtDate_TextChanged" />
                                    <asp:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtDate"
                                        Format="MM-dd-yyyy">
                                    </asp:CalendarExtender>
                                </div>

                                <%--<div class="col-md-1 btnSubmitDiv">                                    
                                     <asp:Button ID="btnGo" runat="server" Text="Go" OnClick="btnGo_Click" CssClass="btn btn-success " />
                                </div>--%>
                                <div class="col-md-6" style="float: left;">
                                    <label class="control-label">Click on the times you will be available for appointments:</label>
                                </div>
                            </div>

                        </div>
                    </div>


                    <div class="col-md-12">
                        <div class="col-md-12">
                            <asp:CheckBoxList ID="chk101" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Text="00:00 am" Value="00:00" />
                                <asp:ListItem Text="00:15 am" Value="00:15" />
                                <asp:ListItem Text="00:30 am" Value="00:30" />
                                <asp:ListItem Text="00:45 am" Value="00:45" />
                                <asp:ListItem Text="01:00 am" Value="01:00" />
                                <asp:ListItem Text="01:15 am" Value="01:15" />
                                <asp:ListItem Text="01:30 am" Value="01:30" />
                                <asp:ListItem Text="01:45 am" Value="01:45" />
                                <asp:ListItem Text="02:00 am" Value="02:00" />
                                <asp:ListItem Text="02:15 am" Value="02:15" />
                                <asp:ListItem Text="02:30 am" Value="02:30" />
                                <asp:ListItem Text="02:45 am" Value="02:45" />
                            </asp:CheckBoxList>
                            <asp:CheckBoxList ID="chk102" runat="server" RepeatDirection="Horizontal">

                                <asp:ListItem Text="03:00 am" Value="03:00" />
                                <asp:ListItem Text="03:15 am" Value="03:15" />
                                <asp:ListItem Text="03:30 am" Value="03:30" />
                                <asp:ListItem Text="03:45 am" Value="03:45" />
                                <asp:ListItem Text="04:00 am" Value="04:00" />
                                <asp:ListItem Text="04:15 am" Value="04:15" />
                                <asp:ListItem Text="04:30 am" Value="04:30" />
                                <asp:ListItem Text="04:45 am" Value="04:45" />
                                <asp:ListItem Text="05:00 am" Value="05:00" />
                                <asp:ListItem Text="05:15 am" Value="05:15" />
                                <asp:ListItem Text="05:30 am" Value="05:30" />
                                <asp:ListItem Text="05:45 am" Value="05:45" />

                            </asp:CheckBoxList>

                            <asp:CheckBoxList ID="chk103" runat="server" RepeatDirection="Horizontal">

                                <asp:ListItem Text="06:00 am" Value="06:00" />
                                <asp:ListItem Text="06:15 am" Value="06:15" />
                                <asp:ListItem Text="06:30 am" Value="06:30" />
                                <asp:ListItem Text="06:45 am" Value="06:45" />
                                <asp:ListItem Text="07:00 am" Value="07:00" />
                                <asp:ListItem Text="07:15 am" Value="07:15" />
                                <asp:ListItem Text="07:30 am" Value="07:30" />
                                <asp:ListItem Text="07:45 am" Value="07:45" />
                                <asp:ListItem Text="08:00 am" Value="08:00" />
                                <asp:ListItem Text="08:15 am" Value="08:15" />
                                <asp:ListItem Text="08:30 am" Value="08:30" />
                                <asp:ListItem Text="08:45 am" Value="08:45" />

                            </asp:CheckBoxList>
                            <asp:CheckBoxList ID="chk104" runat="server" RepeatDirection="Horizontal">

                                <asp:ListItem Text="09:00 am" Value="09:00" />
                                <asp:ListItem Text="09:15 am" Value="09:15" />
                                <asp:ListItem Text="09:30 am" Value="09:30" />
                                <asp:ListItem Text="09:45 am" Value="09:45" />
                                <asp:ListItem Text="10:00 am" Value="10:00" />
                                <asp:ListItem Text="10:15 am" Value="10:15" />
                                <asp:ListItem Text="10:30 am" Value="10:30" />
                                <asp:ListItem Text="10:45 am" Value="10:45" />
                                <asp:ListItem Text="11:00 am" Value="11:00" />
                                <asp:ListItem Text="11:15 am" Value="11:15" />
                                <asp:ListItem Text="11:30 am" Value="11:30" />
                                <asp:ListItem Text="11:45 am" Value="11:45" />

                            </asp:CheckBoxList>

                            <asp:CheckBoxList ID="chk105" runat="server" RepeatDirection="Horizontal">

                                <asp:ListItem Text="12:00 pm" Value="12:00" />
                                <asp:ListItem Text="12:15 pm" Value="12:15" />
                                <asp:ListItem Text="12:30 pm" Value="12:30" />
                                <asp:ListItem Text="12:45 pm" Value="12:45" />
                                <asp:ListItem Text="01:00 pm" Value="13:00" />
                                <asp:ListItem Text="01:15 pm" Value="13:15" />
                                <asp:ListItem Text="01:30 pm" Value="13:30" />
                                <asp:ListItem Text="01:45 pm" Value="13:45" />
                                <asp:ListItem Text="02:00 pm" Value="14:00" />
                                <asp:ListItem Text="02:15 pm" Value="14:15" />
                                <asp:ListItem Text="02:30 pm" Value="14:30" />
                                <asp:ListItem Text="02:45 pm" Value="14:45" />

                            </asp:CheckBoxList>

                             <asp:CheckBoxList ID="chk106" runat="server" RepeatDirection="Horizontal">

                                <asp:ListItem Text="03:00 pm" Value="15:00" />
                                <asp:ListItem Text="03:15 pm" Value="15:15" />
                                <asp:ListItem Text="03:30 pm" Value="15:30" />
                                <asp:ListItem Text="03:45 pm" Value="15:45" />
                                <asp:ListItem Text="04:00 pm" Value="16:00" />
                                <asp:ListItem Text="04:15 pm" Value="16:15" />
                                <asp:ListItem Text="04:30 pm" Value="16:30" />
                                <asp:ListItem Text="04:45 pm" Value="16:45" />
                                <asp:ListItem Text="05:00 pm" Value="17:00" />
                                <asp:ListItem Text="05:15 pm" Value="17:15" />
                                <asp:ListItem Text="05:30 pm" Value="17:30" />
                                <asp:ListItem Text="05:45 pm" Value="17:45" />

                            </asp:CheckBoxList>

                             <asp:CheckBoxList ID="chk107" runat="server" RepeatDirection="Horizontal">

                                <asp:ListItem Text="06:00 pm" Value="18:00" />
                                <asp:ListItem Text="06:15 pm" Value="18:15" />
                                <asp:ListItem Text="06:30 pm" Value="18:30" />
                                <asp:ListItem Text="06:45 pm" Value="18:45" />
                                <asp:ListItem Text="07:00 pm" Value="19:00" />
                                <asp:ListItem Text="07:15 pm" Value="19:15" />
                                <asp:ListItem Text="07:30 pm" Value="19:30" />
                                <asp:ListItem Text="07:45 pm" Value="19:45" />
                                <asp:ListItem Text="08:00 pm" Value="20:00" />
                                <asp:ListItem Text="08:15 pm" Value="20:15" />
                                <asp:ListItem Text="08:30 pm" Value="20:30" />
                                <asp:ListItem Text="08:45 pm" Value="20:45" />

                            </asp:CheckBoxList>

                             <asp:CheckBoxList ID="chk108" runat="server" RepeatDirection="Horizontal">

                                <asp:ListItem Text="09:00 pm" Value="21:00" />
                                <asp:ListItem Text="09:15 pm" Value="21:15" />
                                <asp:ListItem Text="09:30 pm" Value="21:30" />
                                <asp:ListItem Text="09:45 pm" Value="21:45" />
                                <asp:ListItem Text="10:00 pm" Value="22:00" />
                                <asp:ListItem Text="10:15 pm" Value="22:15" />
                                <asp:ListItem Text="10:30 pm" Value="22:30" />
                                <asp:ListItem Text="10:45 pm" Value="22:45" />
                                <asp:ListItem Text="11:00 pm" Value="23:00" />
                                <asp:ListItem Text="11:15 pm" Value="23:15" />
                                <asp:ListItem Text="11:30 pm" Value="23:30" />
                                <asp:ListItem Text="11:45 pm" Value="23:45" />

                            </asp:CheckBoxList>

                        </div>
                      
                    </div>



                    <div class="box-footer">

                        <div class="col-md-3 btnSubmitDiv">
                            <asp:Button ID="btnBack" runat="server" Text="< Back" CssClass="btn btn-success" OnClick="btnBack_Click" />
                            <asp:Button ID="btnSave" runat="server" Text="Save" OnClientClick="CheckVal()" CssClass="btn btn-successNew" OnClick="btnSubmit_Click" />

                            <asp:Button ID="btnCancel" runat="server" Text="Clear" CssClass="btn btn-danger" OnClick="btnClose_Click" />
                        </div>
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
            var copyTextareaBtn = document.querySelector('.js-textareacopybtn');
            copyTextareaBtn.addEventListener('click', function (event) {
                var copyTextarea = document.querySelector('.js-copytextarea');
                copyTextarea.focus();
                copyTextarea.select();

                try {
                    var successful = document.execCommand('copy');
                    var msg = successful ? 'successful' : 'unsuccessful';
                    console.log('Copying text command was ' + msg);
                } catch (err) {
                    console.log('Oops, unable to copy');
                }
            });

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
