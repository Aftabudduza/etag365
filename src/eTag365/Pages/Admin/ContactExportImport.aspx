<%@ Page Title="eTag365: Import / Export Contacts" Language="C#" MasterPageFile="~/MasterPage/Site.master" AutoEventWireup="true" CodeBehind="ContactExportImport.aspx.cs" Inherits="eTag365.Pages.Admin.ContactExportImport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <form id="form1" runat="server">
        <div class="box" style="background-color: #DFE3EE;">
            <div class="box-header with-border CommonHeader col-md-12" style="margin-top: 0px;">
                <h3 class="box-title">Import Contacts</h3>
            </div>
            <div class="col-md-12">
                <div class="row">
                    <div class="col-12">
                        <div class="form-group row">
                            <div class="col-sm-6">
                                <label class=" col-form-label">Import CVS file to Contacts</label>
                            </div>
                            <div class="col-sm-6">
                                <%-- <label class=" col-form-label">Number contacts uploaded: </label>--%>
                                <label class=" col-form-label" id="NumberOfContactUploaded"></label>
                            </div>

                        </div>
                        <div class="form-group row">
                            <div class="col-sm-12" style="float: left; margin: 10px 0;">
                                <a style="color: deepskyblue; font-weight: bold; padding-left: 15px;" target="_blank" href="../../Uploads/Sample/sampleContact.csv">Click here to view sample format</a><br />
                            </div>
                        </div>

                        <div class="form-group row">
                            <div class="col-sm-12 csv"></div>
                        </div>
                        <div class="form-group row" style="margin-bottom: 25px;">
                            <div class="col-sm-7">
                                <input type="file" style="width: 100%;" id="fileMaintenanceImageUpload" />
                            </div>
                            <div class="col-sm-5 col-sm-push-8">
                                <%--<input type="button" class="btn btnNewColor " value="Upload Files" onclick="ImportContacts();" />--%>
                                <input type="button" class="btn btn-successNew" value="Upload Files" id="upload" />
                            </div>

                        </div>
                    </div>
                </div>
            </div>
            
            <div class="box-header with-border CommonHeader col-md-12" style="margin-top: 0px;">
                <h3 class="box-title">Export Contacts</h3>
            </div>
            <div class="col-md-12">
                <div class="box-body">
                    <div class="row">
                        <div class="col-12">
                            <div class="form-group row">
                                <div class="col-sm-6">
                                    <label class=" col-form-label">Export Selected Contacts</label>

                                </div>
                                <div class="col-sm-6">
                                    <label class=" col-form-label">Number Contacts Exported:  </label>
                                    <label class=" col-form-label" id="NumberOfContactExport"></label>
                                </div>
                            </div>
                            <div class="form-group row">
                                <div class="col-sm-12">
                                    <table id="tblExport" class="table table-responsive table-bordered table-striped" style="max-height: 250px; overflow-y: scroll; overflow-x: hidden;">
                                        <thead>
                                            <tr>
                                                <th><span>
                                                    <input type="checkbox" id="chkAll" /></span><span>ALL</span> </th>
                                               <%-- <th>Image</th>--%>
                                                <th>Last Name</th>
                                                <th>First Name</th>
                                                <th>Company</th>
                                                <th>Phone</th>
                                                <th>Email</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        </tbody>
                                    </table>

                                </div>

                            </div>

                            <div class="form-group row">
                                <div class="col-12">
                                    <div class="form-group row">
                                        <div class="col-sm-3">
                                            <input type="radio" name="export" class="txtExport" value="CSV" checked>
                                            <label for="txtDealerGroupPlan" class=" col-form-label">CSV</label>
                                        </div>
                                        <div class="col-sm-3">
                                            <input type="radio" name="export" class="txtExport" value="XMLFormat">
                                            <label for="txtDealerGroupPlan" class=" col-form-label">XML Format</label>
                                        </div>
                                       

                                        <a style="display: none;" href="#" download="../../xml/ContactInfo.xml" id="xmlDownload">XML Download Text</a>
                                    </div>
                                    <div class="form-group row" style="margin:10px 0;">
                                        <div class="col-sm-6">
                                             <input type="button" class="btn btnNewColor " value="< Back" id="btnExit" />
                                        </div>
                                         <div class="col-sm-6">
                                            <input type="button" class="btn btn-successNew " value="Download" id="Download" />
                                        </div>
                                    </div>
                                </div>

                            </div>
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
    <script type="text/javascript" src="../../AppJs/Admin/ContactExportImport.js"></script>
</asp:Content>
