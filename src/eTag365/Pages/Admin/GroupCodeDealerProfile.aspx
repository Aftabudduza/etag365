<%@ Page Title="eTag365: Group Code Profile" Language="C#" MasterPageFile="~/MasterPage/Site.master" AutoEventWireup="true" CodeBehind="GroupCodeDealerProfile.aspx.cs" Inherits="eTag365.Pages.Admin.GroupCodeDealerProfile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <form id="form1" runat="server">
        <div class="box">
            <div class="box-header with-border CommonHeader col-md-12" style="margin-top: 0px;">
                <h3 class="box-title">Group Code</h3>
            </div>

            <div class="box box-primary">
                <div class="box-body">
                    <div class="form-group">
                        <div class="col-md-12">
                            <div class="col-sm-3">
                                <label for="lblGroupCodeFor" class="control-label">Group Code For:</label>
                            </div>
                            <div class="col-sm-3">
                                <input type="radio" name="GroupCodeFor" class="rdoGroupCodeForUser" id="GroupCodeForDealer" value="Dealer">
                                <label for="lblGroupCodeFor" class="control-label">Dealer</label>
                            </div>
                            <div class="col-sm-3">
                                <input type="radio" name="GroupCodeFor" class="rdoGroupCodeForUser" id="GroupCodeForUser" value="User" checked>
                                <label for="lblGroupCodeFor" class="control-label">User</label>
                            </div>
                        </div>
                    </div>

                </div>

                <div class="box-body">
                    <div class="col-md-12" style="max-height: 250px; overflow-x: auto;">
                        <table id="tblGroupCodeList" class="table table-striped table-bordered dataTable" style="margin: 15px 0px 12px 0px;">
                            <thead>
                                <tr>
                                    <th>Month/Year</th>
                                    <th>Group Code</th>
                                    <th>Group name</th>
                                    <th>Description</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="box-body">
                    <div class="col-md-12">
                        <div class="col-sm-6">
                            <input type="text" data-groupcodeid="0" class="form-control" id="txtDealerGroupCode" placeholder="Group Code" maxlength="200" />
                        </div>
                        <div class="col-sm-6">
                            <input type="text" class="form-control" id="txtDealerGroupName" placeholder="Group Name" maxlength="200" />
                        </div>

                    </div>
                </div>
                <div class="box-body">
                    <div class="col-md-12 form-group row">
                        <label style="font-size: 18px;" class="col-sm-12 control-label">Description</label>
                    </div>
                    <div class="col-md-12">
                        <div class="col-sm-12">
                            <textarea class="col-sm-6 form-control" id="txtDealerGroupDescription" rows="5" cols="5" maxlength="200"></textarea>
                        </div>

                    </div>
                </div>
                <div class="box-body">
                    <div class="row">
                        <div class="col-12">
                            <div class="form-group row">
                                <div class="col-sm-2" style="margin: 7px -34px 0px 0px;">
                                    <input type="radio" name="plan" class="txtDealerGroupPlan" value="Basic" checked>
                                    <label for="txtDealerGroupPlan" class=" col-form-label">Basic Plan</label>
                                </div>
                                <div class="col-sm-2" style="margin: 8px 0px 0px -2px;">
                                    <input type="text" class="form-control" id="txtBasicAmount" placeholder="Amount" value="" />
                                </div>
                                <div class="col-sm-2" style="margin: 7px -34px 0px 0px;">
                                    <input type="radio" name="plan" class="txtDealerGroupPlan" value="Silver">
                                    <label for="txtDealerGroupPlan" class=" col-form-label">Silver Plan</label>
                                </div>
                                <div class="col-sm-2" style="margin: 8px 0px 0px -2px;">
                                    <input type="text" class="form-control" id="txtSilverAmount" placeholder="Amount" value="" />
                                </div>
                                <div class="col-sm-2" style="margin: 7px -34px 0px 0px;">
                                    <input type="radio" name="plan" class="txtDealerGroupPlan" value="Gold">
                                    <label for="txtDealerGroupPlan" class=" col-form-label">Gold Plan</label>
                                </div>
                                <div class="col-sm-2" style="margin: 8px 0px 0px -2px;">
                                    <input type="text" class="form-control" id="txtGoldAmount" placeholder="Amount" value="" />
                                </div>
                            </div>
                        </div>
                    </div>
                    <%-- <div class="col-md-12">
                        <div class="col-sm-3">
                            <input type="radio" name="plan" class="col-sm-1 txtDealerGroupPlan" value="Basic" checked>
                            <label for="txtDealerGroupPlan" class="col-sm-3 control-label">Basic Plan</label>
                       
                            <input type="text" class="col-sm-6 form-control" id="txtBasicAmount" placeholder="Amount" value="" />
                        </div>
                        <div class="col-sm-3">
                            <input type="radio" name="plan" class="col-sm-1 txtDealerGroupPlan" value="Silver">
                            <label for="txtDealerGroupPlan" class="col-sm-3 control-label">Silver Plan</label>
                       
                            <input type="text" class="col-sm-6 form-control" id="txtSilverAmount" placeholder="Amount" value="" />
                        </div>
                        <div class="col-sm-3">
                            <input type="radio" name="plan" class="col-sm-1 txtDealerGroupPlan" value="Gold">
                            <label for="txtDealerGroupPlan" class="col-sm-3 control-label">Gold Plan</label>
                       
                            <input type="text" class="col-sm-6 form-control" id="txtGoldAmount" placeholder="Amount" value="" />
                        </div>
                    </div>--%>
                </div>
                <div class="box-body">
                    <div class="col-md-12 form-group row">
                        <div class="col-sm-3">
                            <label for="txtCityDealerProfile" class="control-label">Bill Every:</label>
                        </div>
                        <div class="col-sm-3">
                            <input type="radio" name="Billvery" value="Monthly" checked>
                            <label for="txtDealerBillEvery" class="control-label">Monthly</label>
                        </div>
                        <div class="col-sm-3">
                            <input type="radio" name="Billvery" value="Yearly">
                            <label for="txtDealerBillEvery" class="control-label">Yearly</label>
                        </div>
                    </div>
                </div>
                <div class="box-body">
                    <div class="col-md-12">
                        <div class="col-sm-12">
                            <input type="checkbox" id="chkDealerIsForever" value="">
                            <label for="txtCityDealerProfile" class="control-label">Forever</label>
                        </div>
                    </div>
                    <div class="col-md-12">
                        <div id="txtdate" class="form-group row">
                            <label for="txtDealerStartDate" class="col-sm-2 col-form-label">Start Date:</label>
                            <div class="col-sm-3">
                                <input type="text" class="form-control tDate" id="txtDealerStartDate" />
                            </div>
                            <label for="txtDealerEndDate" class="col-sm-2 col-form-label">End Date:</label>
                            <div class="col-sm-3">
                                <input type="text" class="form-control tDate" id="txtDealerEndDate" />
                            </div>
                        </div>
                    </div>
                    <div class="col-md-12">
                        <div class="col-sm-12">
                            <input type="checkbox" id="chkDealerIsRequiredACHInfo" value="">
                            <label for="chkDealerIsRequiredACHInfo" class=" col-form-label">Do not require credit card or ACH information when sigining up.</label>
                        </div>
                    </div>
                    <div class="col-md-12">
                        <div class="col-sm-12">
                            <label for="lblDealerIsRequiredACHInfo" class=" col-form-label">Assign Promotional Reward Commissions use this Promo code:</label>
                        </div>
                    </div>
                    <div class="col-md-12">
                        <div class="col-sm-6">
                            <input type="text" class="form-control" id="txtDealerCreditPhoneNo" placeholder="Credit Phone number" />
                        </div>
                        <div class="col-sm-3">
                            <input type="text" class="form-control" id="txtDealerRewards" placeholder="Rewards" />
                        </div>
                        <div class="col-sm-3">
                            <label class="control-label">%</label>
                        </div>
                    </div>
                </div>
                <div class="box-footer">
                    <div class="col-md-12">
                        <div class="col-md-4 btnSubmitDiv">
                            <asp:Button ID="btnBack" runat="server" Text="< Back" OnClick="btnBack_Click" CssClass="btn btn-success" />
                        </div>
                        <div class="col-md-4 btnSubmitDiv">
                            <button type="button" class="btn btn-successNew" id="btnSave">Add</button>
                        </div>
                        <div class="col-md-4 btnSubmitDiv">
                            <button type="button" class="btn btn-successNew" id="btnClear">Clear All</button>
                        </div>

                    </div>
                </div>
            </div>

        </div>
    </form>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">

    <link type="text/css" href="../../scripts/jquery.dataTables.min.css" rel="stylesheet" />

    <style type="text/css">
        .nav-tabs-custom {
            background-color: #DFE3EE;
        }

            .nav-tabs-custom > .nav-tabs {
                border-bottom-color: initial;
                padding: 0px 0px 0px 18px;
                background-color: #8B9DC3;
            }

                .nav-tabs-custom > .nav-tabs > li > a, .nav-tabs-custom > .nav-tabs > li > a:hover {
                    background: #ffffff;
                }

                .nav-tabs-custom > .nav-tabs > li > a {
                    border-radius: 10px 10px 0px 0px;
                }

        .nav-tabs {
            border-bottom: none;
        }

        #nav-tab > li > a.active {
            background-color: #98cdfe;
            color: #ffffff;
        }

        .nav-tabs-custom > .tab-content {
            background: none;
            border-bottom-right-radius: 3px;
            border-bottom-left-radius: 3px;
            padding: 10px 10px 10px 5px;
        }

        .nav-tabs-custom > .nav-tabs > li > a, .nav-tabs-custom > .nav-tabs > li > a:hover {
            height: 56px;
            text-align: center;
        }
    </style>
    <script type="text/javascript" src="../../scripts/jquery.dataTables.min.js"></script>
    <script type="text/javascript" src="../../AppJs/CommonJS/DataBaseOperationJs.js"></script>
    <script type="text/javascript" src="../../AppJs/Admin/GroupCodeDealerProfile.js"></script>
</asp:Content>
