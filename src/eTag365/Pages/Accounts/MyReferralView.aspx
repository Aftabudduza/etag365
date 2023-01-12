<%@ Page Title="eTag365 :: My Referral View and Report" Language="C#" MasterPageFile="~/MasterPage/Site.master" AutoEventWireup="true" CodeBehind="MyReferralView.aspx.cs" Inherits="eTag365.Pages.Accounts.MyReferralView" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <form id="form1" runat="server" class="form-inline">
        <div class="box">
            <div class="col-md-12">
                <div class="box-header with-border CommonHeader col-md-12">
                    <h3 class="box-title">My Referral View and Report</h3>
                </div>
                <div class="box-body">
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label for="inputEmail4" style="font-weight:bold">View Referral Commission:</label>
                        </div>
                        <div class="form-group col-md-6">
                            <label for="inputPassword4">Quarter to Date Earned Amount: $</label>
                            <label id="lblEarnedAmount">0.00</label>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-3 form-check">
                            <input class="form-check-input" type="checkbox" id="chkAll" checked>
                            <label class="form-check-label" for="gridchkAllCheck">
                                ALL
                            </label>
                        </div>
                        <div class="form-group col-md-3">
                            <label for="txtStartDate">Start Date:</label>
                            <input type="text" class="form-control tDate" id="txtStartDate" disabled />

                        </div>
                        <div class="form-group col-md-3">
                            <label for="txtStartDate" class="col-form-label">End Date:</label>
                            <input type="text" class="form-control tDate" id="txtEndDate" disabled />

                        </div>
                        <div class="form-group col-md-3">
                            <input type="button" disabled class="btn" style="margin-right: 10px; background-color: #66FF00" value="Search" id="btnSearch" />
                            <input type="button" class="btn" style="margin-left: 10px; background-color: #66FF00;cursor:pointer" value="Print" id="btnPrint" />
                        </div>
                    </div>
                    <div class="form-row" style="margin-top: 50px;">
                        
                        <div class="form-group col-md-12">
                            
                            <table  class="col-md-12 panel-body table table-responsive table-bordered" id="tblReferalDetails">
                                <thead>
                                    <tr>
                                        <th>SL</th>
                                        <th>Name</th>
                                        <th>Phone No</th>
                                        <th>Registration Date</th>
                                        <th>Month</th>
                                        <th>Year</th>
                                        <th>Amount ($)</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody id="tblReferalDetails_tbody"></tbody>
                            </table>
                        </div>
                    </div>

                </div>

                <div class="box-footer">
                <div class="form-row">                   
                         <div class="form-group col-md-5">                           
                             <button  class="btnUpdate btn" style="background-color:#3B5998;color:white;display:none" id="btnExisdt" type="button"> Exit </button>       
                        </div>
                        <div class="form-group col-md-4">
                            <button class="btnUpdate btn" style="background-color:#3B5998;color:white" id="btnExit" type="button"> Exit </button>                          
                        </div>
                   
                </div>
            </div>
        </div>

            </div>
            
       
    </form>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server"> 
    <link type="text/css" href="../../scripts/jquery.dataTables.min.css" rel="stylesheet" />
    <script type="text/javascript" src="../../scripts/jquery.dataTables.min.js"></script>
    <script type="text/javascript" src="../../AppJs/CommonJS/DataBaseOperationJs.js"></script>
    <script type="text/javascript" src="../../AppJs/Accounts/MyReferalView.js"></script>
</asp:Content>
