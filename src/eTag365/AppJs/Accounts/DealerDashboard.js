//var currentPagePath = window.location.pathname + "/";
var currentPagePath = "/Pages/Accounts/DealerDashboard.aspx" + "/";
var bExist = false;
$(document).ready(function () {
    $(".tDate").datepicker().datepicker("setDate", new Date());
    $(".tDate").datepicker({
        dateFormat: "mm-dd-yy",
        changeYear: true,
        changeMonth: true
    });
    InitialSalesPartnerProfileLoad();
    LoadAllDealer();
    $("#btnSave").attr('disabled', false);
});

function LoadAllDealer() {
    var URL = currentPagePath + "GetData";
    var obj = {};
    let GetData = makeAjaxCallReturnPromiss(URL, obj);
    GetData.then((data) => {
        $('.nav-item').removeClass('active');
        $('.tab-pane').removeClass('active show');
        $("#tblDealerList").show();
        $("#divE365UseOnlyDealerProfile").show();
        $(".adminUse").show();
        let result = $.parseJSON(decodeURIComponent(data.d));

        if (result != null) {
            if (result.UserType == "1") {
                BindData(result.listOfDealer);
                $("#txtEmailAddressDealerProfile").attr('disabled', false);
                $("#txtReEnterEmailAddressDealerProfile").attr('disabled', false);
                $("#txtPasswordDealerProfile").attr('disabled', false);
                $("#txtReEnterPasswordDealerProfile").attr('disabled', false);
                $("#txtPrimaryPhoneNumberDealerProfile").attr('disabled', false);
                //$('#YourAccounts').hide();
                $('#DealerProfile').addClass('active');
                $('#nav-DealerProfile').addClass('active show');
                $("#h6DealerIdDealerProfile").text(result.Serial);
                $("#commissionCalculationButton").hide();
            } 
            else {
                BindData(result.listOfDealer);
                $("#tblDealerList").hide();
                $("#divE365UseOnlyDealerProfile").hide();
                $(".adminUse").hide();
                // $('#YourCommissions').hide();
                $("#commissionCalculationButton").hide();
                $('#DealerProfile').addClass('active');
                $('#nav-DealerProfile').addClass('active show');
                ShowDealerInfo(result.listOfDealer);
            }

        }

    });

}
$(document).on('click', '.mytab', function () {
    var currentTab = $(this).attr('data-name');
    if (currentTab == 'YourCommissions') {
        $("#btnExit").show();
        $("#btnSave").hide();
        $("#btnCancel").hide();

    } else {
        $("#btnExit").hide();
        $("#btnSave").show();
        $("#btnCancel").show();
    }
});
$(document).on('click', "#btnExit", function () {
    window.location.href = window.location.origin + "/home";
});
function BindData(result) {
    var content = " ";
    BindDealerDropdown(result);
    $('#tblDealerList').removeClass('active');
    $('#nav-DealerProfile').removeClass('active show');
    var dat = "";
    if (result.length > 0) {
        $.each(result, function(i, obj) {
            var name = obj.firstName + " " + obj.lastName;
            content += '<tr>';
            content += '<td>' + obj.serialCode + '</td>';
            content += '<td>' + name + '</td>';
            content += '<td>' + obj.email + '</td>';
            //content += '<td>' + obj.address1 + '</td>'
            content += '<td>' + obj.primaryPhoneNo + '</td>';
            content += '<td>' + obj.commissionRate + '</td>';

            //content += '<td>' + obj.city + '</td>'
            //content += '<td>' + obj.STATENAME + '</td>'
            //content += '<td>' + obj.zipCode + '</td>'
            content += '<td>' + ConvertJasoDate(obj.joinDate) + '</td>';
            content += '<td> <button class="btnEdit btn" style="background-color:#3B5998;color:white" data-DealerID=' + obj.DealerID + ' type = button> Edit </button> </td>';
            content += '</tr>';
        });
        $('#tblDealerList').addClass('active');
        $('#DealerProfile').addClass('active show');
        $('#tblDealerList tbody').empty();
        $('#tblDealerList tbody').append(content);     
       
        //$('.ddlDealer tbody').empty();
        //$('.ddlDealer tbody').append(content); 
        
     }

}
function BindDealerDropdown(data) {
    
    if (data.length>0) {
        var content = '<option value="-1">Select.......</option>';
        var content2 = '<option value="-1">Select.......</option>';
        if (data == undefined || data.length == 0 || data == null) {
            return content;
        }
        else 
        {
            $.each(data, function (i, obj) {
                content += '<option  value="' + obj.DealerID + '">' + obj.firstName + ' ' + obj.lastName + ' (' + obj.primaryPhoneNo + ') </option>';
                content2 += '<option  value="' + obj.primaryPhoneNo + '">' + obj.firstName + ' ' + obj.lastName + ' (' + obj.primaryPhoneNo + ') </option>';
            });
        }

        $('#ddlDealer option').empty();
        $("#ddlDealer").append(content);
        $("#ddlDealer").select2();
        
        if (data.length == 1) {
            $('#ddlDealer').val(data[0].DealerID).trigger('change');
        }

        $('#ddlDealerId option').empty();
        $("#ddlDealerId").append(content2);
        $("#ddlDealerId").select2();

        if (data.length == 1) {
            $('#ddlDealerId').val(data[0].primaryPhoneNo).trigger('change');
        }
    }
}

$(document).on('change', '#ddlDealer', function() {
    var dealerId = $(this).val();
    var URL = currentPagePath + "GetCommissionData";
    if (dealerId != "-1") {
        var Obj = {
            "id": dealerId
        };
        let GetData = makeAjaxCallReturnPromiss(URL, Obj);
        GetData.then((data) => {

            let result = $.parseJSON(decodeURIComponent(data.d));
            
            if (result.length > 0) {
                $("#lblCommissionOwned").text(result[0].CommissionOwned);
                BindYourCommissionGrid(result);
            } else {
                $("#lblCommissionOwned").text("");
                $("#tblCommission_tbody").empty();
                $("#tblCommission_Details_tbody").empty();
                $('#divCommissionDetails').css("display", "none");
            }
        });
    } else {
        $("#lblCommissionOwned").text("");
        $("#tblCommission_tbody").empty();
        $("#tblCommission_Details_tbody").empty();
        $('#divCommissionDetails').css("display", "none");
    }

});
function BindYourCommissionGrid(result) {
    var content = ""
    $.each(result, function (i, obj) {
        var paidStatus = obj.IsPaid == true ? 'Paid' : 'Not Paid';
        content += "<tr>";
        content += "<td>" + (i+1)+ "</td>";
        content += "<td>" + obj.Month+ "</td>";
        content += "<td>" + obj.Year+ "</td>";
        content += "<td>" + obj.amount+ "</td>";
        content += "<td>" + paidStatus + "</td>";
        content += "<td><button type='button' class='btn' style='background-color: #66FF00' id='btnDetails' data-month='" + obj.Month + "' data-year='" + obj.Year + "' data-paid='" + obj.IsPaid + "'>Details</button></td>";
        content += "</tr>";
    })
    $("#tblCommission_tbody").empty();
    $("#tblCommission_tbody").append(content);
     $("#tblCommission_Details_tbody").empty();

}
$(document).on('click', '#btnDetails', function () {
    var month = $(this).attr('data-month');
    var year = $(this).attr('data-year');
    var paid = $(this).attr('data-paid');
    var dealerId = $("#ddlDealer").val();

    var URL = currentPagePath + "GetCommissionDetailsData";
    var Obj = {
        "Month": month,
        "Year": year,
        "IsPaid": paid,
        "id": dealerId
    }
    let GetData = makeAjaxCallReturnPromiss(URL, Obj);
    GetData.then((data) => {

        let result = $.parseJSON(decodeURIComponent(data.d));
        
        if (result.length > 0) {
            //BindYourCommissionGrid(result);
            BindDetailsData(result);
        }
        else {
            //ShowDealerInfo();
        }
    });
});

function BindDetailsData(result) {
   
    var content = ""
    $.each(result, function (i, obj) {
        content += "<tr>";
        content += "<td>" + (i + 1) + "</td>";
        content += "<td>" + obj.Name + "</td>";
        content += "<td>" + obj.Phone + "</td>";
        content += "<td>" + obj.Address + "</td>";
        content += "<td>" + obj.City + "</td>";
        content += "<td>" + obj.State + "</td>";
        content += "<td>" + obj.Zip + "</td>";
        content += "<td>" + obj.Amount + "</td>";        
        content += "</tr>";
    })
    $("#tblCommission_Details_tbody").empty();
    $("#tblCommission_Details_tbody").append(content);
    $('#divCommissionDetails').css("display", "block");
     

}
function ShowDealerInfo(dealerDetails) {
    BindDealerInfo(dealerDetails[0].Password, dealerDetails[0], 'dealer')
}
function ConvertJasoDate(date) {  
    var nowDate = new Date(parseInt(date.substr(6)));
    var dat = nowDate.getMonth() + 1 + "-" + nowDate.getDate() + "-" + nowDate.getFullYear();
    return dat; 
    
}

$(document).on('click', '.btnEdit', function() {

    var DealerID = $(this).attr('data-DealerID');
    var URL = currentPagePath + "GetDealerDetailsByDealerId";

    if (DealerID != null || DealerID != "") {
        var obj = {
            "id": DealerID
        };
        let GetData = makeAjaxCallReturnPromiss(URL, obj);
        GetData.then((data) => {

            let result = $.parseJSON(decodeURIComponent(data.d));
            if (result != null) {
                BindDealerInfo(result.Password, result.Dealer_SalesPartner, 'admin');
            } else {
                //ShowDealerInfo();
            }
        });
    }
});
function BindDealerInfo(Password, data, userType) {
    

    var pass = Password;
    var result = data;
    if (userType == "admin") {
        $("#txtDealerProfileFirstName").attr('data-id', result.id);
    }
    else  {
        $("#txtDealerProfileFirstName").attr('data-id', result.DealerID);
    }
    
    $("#txtDealerProfileFirstName").val(result.firstName);
    $("#txtDealerProfileLastName").val(result.lastName);
    $("#txtAreaAddress1DealerProfile").val(result.address1);
    $("#txtAreaAddress2DealerProfile").val(result.address2);
    $("#txtCityDealerProfile").val(result.city);
    $("#ddlStateDealerProfile").val(result.stateId);
    $("#ddlStateDealerProfile").select2();
    $("#txtZipCodeDealerProfile").val(result.zipCode);
    $("#txtPrimaryPhoneNumberDealerProfile").val(result.primaryPhoneNo);
    $("#txtMobilePhoneNumberDealerProfile").val(result.mobilePhoneNo);
    $("#txtRoutingNoDealerProfile").val(result.routingNo);
    $("#txtAccountNoDealerProfile").val(result.accountNo);
    $("#txtEmailAddressDealerProfile").val(result.email);
    $("#txtReEnterEmailAddressDealerProfile").val(result.email);
    $("#txtPasswordDealerProfile").val(pass);
    $("#txtReEnterPasswordDealerProfile").val(pass);
    $("#txtJoinDateDealerProfile").val(ConvertJasoDate(result.joinDate));
    $("#txtCommissionRateDealerProfile").val(result.commissionRate);
    $("#h6DealerIdDealerProfile").text(result.serialCode);

    if (userType == 'admin') {
        $("#txtEmailAddressDealerProfile").attr('disabled', false);
        $("#txtReEnterEmailAddressDealerProfile").attr('disabled', false);
        $("#txtPasswordDealerProfile").attr('disabled', false);
        $("#txtReEnterPasswordDealerProfile").attr('disabled', false);
        $("#txtPrimaryPhoneNumberDealerProfile").attr('disabled', false);
        var serialcode = result.serialCode;
        if (serialcode != null) {
            LoadZipCode(serialcode);
        }

    }

    $("#btnSave").val("Update");
    


}
function LoadZipCode(serialcode) {
    var URL = currentPagePath + "GetZipCodeCoverage";
    var obj = {
        "serialcode": serialcode
    };
    let GetData = makeAjaxCallReturnPromiss(URL, obj);
    GetData.then((data) => {
        
        let result = $.parseJSON(decodeURIComponent(data.d));
        if (result.length > 0) {
            BindZipCodeDetails(result, serialcode);
        }
        else {
            //ShowDealerInfo();
        }
    });
}
function BindZipCodeDetails(result, serialcode) {
    var content = "";
    if (result.length > 0) {
        $.each(result, function (i, obj) {
            content += "<tr>";
            content += "<td>" + obj.zipCode+"</td>";
            content += "<td>" + obj.commissionRate + "</td>";
            content += "<td><button type='button' data-serialcode=" + serialcode+"  data-id=" + obj.id + " data-dealersalespartnerid=" + obj.dealerSalesPartnerId+" class='btn btn-danger btnRemoveDealerProfile' style='cursor: pointer; '><i class='fa fa-trash'></i></button></td>";
            content += "</tr>";
        });
        $("#tblDealerProfile tbody").empty();
        $("#tblDealerProfile tbody").append(content);
    }
}
$(document).on('click', '.btnRemoveDealerProfile', function () {
    var serialcode = $(this).attr('data-serialcode');
    var id = $(this).attr('data-id');
    var URL = currentPagePath + "DeleteZipCodeData";
    var obj = {
        "id": id
    };
    let GetData = makeAjaxCallReturnPromiss(URL, obj);
    GetData.then((data) => {
        
        let result = $.parseJSON(decodeURIComponent(data.d));
        if (result == true) {
            LoadZipCode(serialcode);
        }
        else {
            //ShowDealerInfo();
        }
    });
});

$(document).on('click', '#btnAddDealerProfile', function () {

    var zipCode = $("#txtTblZipCodeDealerProfile").val();
    var commissionRate = $("#txtTblCommissionPaidDealerProfile").val();
    var dealerSalesPartnerId = $("#h6DealerIdDealerProfile").text();

    if (zipCode != null && commissionRate != null && dealerSalesPartnerId != null) {
        var URL = currentPagePath + "AddZipCode";
        var obj = {
            "zipCode": zipCode,
            "commissionRate": commissionRate,
            "dealerSalesPartnerId": dealerSalesPartnerId
        };
        let GetData = makeAjaxCallReturnPromiss(URL, obj);
        GetData.then((data) => {
            
            let result = $.parseJSON(decodeURIComponent(data.d));
            if (result == true) {
                LoadZipCode(dealerSalesPartnerId);
                $("#txtTblZipCodeDealerProfile").val("");
                $("#txtTblCommissionPaidDealerProfile").val(10);
                notify('success', "Saved successfully");
               
            }
            else {
                //ShowDealerInfo();
                notify('danger', "Save Failed !!");
            }
        });
    }
});
function InitialSalesPartnerProfileLoad() {
    
    //.................. load State ...............//
    var URL = "/Pages/Settings/CommonData.aspx/" + "GetState";
    var obj = {};
    let State = makeAjaxCallReturnPromiss(URL, obj);
    State.then((data) => {
        
        console.log("State Data Loaded");
        let StateData = setCombo($.parseJSON(decodeURIComponent(data.d)), '-1');
        
        $('#ddlStateDealerProfile option').empty();
        //$("#ddlStateSalesPartner option").empty();
        $("#ddlStateDealerProfile").append(StateData);
        $("#ddlStateDealerProfile").select2();
    }).catch((err) => {
        console.log(err);
    });
    //Promise.all([State]).then(function () {
    //    //if (result != undefined) {
    //       // setDataSalesPartnerProfile(result);
    //   // }

    //});
}

$(document).on('click', '#btnSave', function () {
    if (Validate()) {
            var URL = currentPagePath + "Save";
            var Obj = getMyData();
            if (Obj != null) {
                let GetData = makeAjaxCallReturnPromiss(URL, Obj);
                GetData.then((data) => {
                    let result = $.parseJSON(decodeURIComponent(data.d));
                    if (result == true) {
                        // BindDealerInfo(result);
                        LoadAllDealer();
                        ClearCode();
                        $("#txtTblZipCodeDealerProfile").val("");
                        $("#txtTblCommissionPaidDealerProfile").val(10);
                        $("#tblDealerProfile tbody").empty();
                        var saveOrUpdate = $("#btnSave").val();
                        if (saveOrUpdate == 'Update') {
                            notify('success', "Updated successfully");
                        } else {
                            notify('success', "Saved successfully");
                        }

                        $("#btnSave").val("Save");
                    }
                    else {
                        notify('danger', "Save Failed !!");
                    }
            });
        } 
        else 
        {
            notify('danger', "No Data To Save !!");
        }
    }
    else {
        notify("danger", "Please fill out all mandatory fields !!");
    }
   
});

function getMyData() {
    var Obj = null;
    if ($("#txtDealerProfileFirstName").val() != null && $("#txtDealerProfileLastName").val() != null
        && $("#txtJoinDateDealerProfile").val() != null && $("#txtPrimaryPhoneNumberDealerProfile").val() != null
        && $("#txtEmailAddressDealerProfile").val() != null && $("#txtPasswordDealerProfile").val() != null
    ) {
        var DealerObject = {
            "id": $("#txtDealerProfileFirstName").attr('data-id'),
            "serialCode": $("#h6DealerIdDealerProfile").text(),
            "firstName": $("#txtDealerProfileFirstName").val(),
            "lastName": $("#txtDealerProfileLastName").val(),
            "address1": $("#txtAreaAddress1DealerProfile").val(),
            "address2": $("#txtAreaAddress2DealerProfile").val(),
            "city": $("#txtCityDealerProfile").val(),
            "stateId": $("#ddlStateDealerProfile").val(),
            "zipCode": $("#txtZipCodeDealerProfile").val(),
            "primaryPhoneNo": $("#txtPrimaryPhoneNumberDealerProfile").val(),
            "mobilePhoneNo": $("#txtMobilePhoneNumberDealerProfile").val(),
            "routingNo": $("#txtRoutingNoDealerProfile").val(),
            "accountNo": $("#txtAccountNoDealerProfile").val(),
            "email": $("#txtEmailAddressDealerProfile").val(),
            "userType": 3,
            "joinDate": $("#txtJoinDateDealerProfile").val(),
            "commissionRate": $("#txtCommissionRateDealerProfile").val()
        }
        var Obj = {
            "Dealer_SalesPartner": DealerObject,
            "Password": $("#txtPasswordDealerProfile").val(),
        }
    } else {
        notify('danger', "Please add First Name,Last Name, Primary Phone No, Email, Join Date");
    }

    return Obj;
}
function ClearCode() {
    $("#txtDealerProfileFirstName").attr('data-id',0);
    $("#h6DealerIdDealerProfile").text("");
    $("#txtDealerProfileFirstName").val("");
    $("#txtDealerProfileLastName").val("");
    $("#txtAreaAddress1DealerProfile").val("");
    $("#txtAreaAddress2DealerProfile").val("");
    $("#txtCityDealerProfile").val("");
    $("#ddlStateDealerProfile").val("-1");
    $("#txtZipCodeDealerProfile").val("");
    $("#txtPrimaryPhoneNumberDealerProfile").val("");
    $("#txtMobilePhoneNumberDealerProfile").val("");
    $("#txtRoutingNoDealerProfile").val("");
    $("#txtAccountNoDealerProfile").val("");
    $("#txtEmailAddressDealerProfile").val("");    
    $("#txtJoinDateDealerProfile").val("");
    $("#txtCommissionRateDealerProfile").val("");
    //txtReEnterEmailAddressDealerProfile
    $("#txtReEnterEmailAddressDealerProfile").val("");
    $("#txtPasswordDealerProfile").val("");
    $("#txtReEnterPasswordDealerProfile").val("");
}

function Validate(parameters) {
    var isresult = true;
    var accName = $("#txtDealerProfileFirstName").val().trim();
    var accLastName = $("#txtDealerProfileLastName").val().trim();
    var address = $("#txtAreaAddress1DealerProfile").val().trim();
    var city = $("#txtCityDealerProfile").val().trim();
    var state = $("#s2id_ddlStateDealerProfile").val().trim();
    var zip = $("#txtZipCodeDealerProfile").val().trim();

    var phone = $("#txtPrimaryPhoneNumberDealerProfile").val().trim();
    var email = $("#txtEmailAddressDealerProfile").val().trim();
    var password = $("#txtPasswordDealerProfile").val().trim();
    var emailre = $("#txtReEnterEmailAddressDealerProfile").val().trim();
    var passwordre = $("#txtReEnterPasswordDealerProfile").val().trim();

    if (accName === "undefined" || accName === "") {
        $("#txtDealerProfileFirstName").css({ 'border': '1px solid red' });
        isresult = false;
    }
    else {
        $("#txtDealerProfileFirstName").css({ 'border': '1px solid #d2d6de' });
    }

    if (accLastName === "undefined" || accLastName === "") {
        $("#txtDealerProfileLastName").css({ 'border': '1px solid red' });
        isresult = false;
    }
    else {
        $("#txtDealerProfileLastName").css({ 'border': '1px solid #d2d6de' });
    }

    if (address === "undefined" || address === "") {
        $("#txtAreaAddress1DealerProfile").css({ 'border': '1px solid red' });
        isresult = false;
    }
    else {
        $("#txtAreaAddress1DealerProfile").css({ 'border': '1px solid #d2d6de' });
    }

    if (city === "undefined" || city === "") {
        $("#txtCityDealerProfile").css({ 'border': '1px solid red' });
        isresult = false;
    }
    else {
        $("#txtCityDealerProfile").css({ 'border': '1px solid #d2d6de' });
    }

    if (state === "undefined" || state === "-1") {
        $("#s2id_ddlStateDealerProfile").css({ 'border': '1px solid red' });
        isresult = false;
    }
    else {
        $("#s2id_ddlStateDealerProfile").css({ 'border': '1px solid #d2d6de' });
    }


    if (zip === "undefined" || zip === "") {
        $("#txtZipCodeDealerProfile").css({ 'border': '1px solid red' });
        isresult = false;
    }
    else {
        $("#txtZipCodeDealerProfile").css({ 'border': '1px solid #d2d6de' });
    }

    if (phone === "undefined" || phone === "") {
        $("#txtPrimaryPhoneNumberDealerProfile").css({ 'border': '1px solid red' });
        isresult = false;
    }
    else {
        $("#txtPrimaryPhoneNumberDealerProfile").css({ 'border': '1px solid #d2d6de' });
    }

    if (email === "undefined" || email === "") {
        $("#txtEmailAddressDealerProfile").css({ 'border': '1px solid red' });
        isresult = false;
    }
    else {
        $("#txtEmailAddressDealerProfile").css({ 'border': '1px solid #d2d6de' });
    }

    if (email != emailre) {
        $("#txtReEnterEmailAddressDealerProfile").css({ 'border': '1px solid red' });
        isresult = false;
    }
    else {
        $("#txtReEnterEmailAddressDealerProfile").css({ 'border': '1px solid #d2d6de' });
    }

    if (password === "undefined" || password === "") {
        $("#txtPasswordDealerProfile").css({ 'border': '1px solid red' });
        isresult = false;
    }
    else {
        $("#txtPasswordDealerProfile").css({ 'border': '1px solid #d2d6de' });
    }

    if (password != passwordre) {
        $("#txtReEnterPasswordDealerProfile").css({ 'border': '1px solid red' });
        isresult = false;
    }
    else {
        $("#txtReEnterPasswordDealerProfile").css({ 'border': '1px solid #d2d6de' });
    }

   

    if (isresult)
        isresult = true;
    else {
        isresult = false;
    }
    return isresult;
}

function IsExistDealer(parameters) {
   
   
    var phone = $("#txtPrimaryPhoneNumberDealerProfile").val().trim();
    var serial = $("#h6DealerIdDealerProfile").text();

    var URL = currentPagePath + "ExistDealer";

    if (phone != null && phone != "" && phone != " ") {

        $.ajax({
            type: "POST",
            url: URL,
            data: "{ 'phone':'" + phone + "' , 'serial':'" + serial + "'}",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            error:
                function (XMLHttpRequest, textStatus, errorThrown) {
                    bExist = false;
                    $("#txtPrimaryPhoneNumberDealerProfile").css({ 'border': '1px solid #d2d6de' });
                },
            success:
                function (data) {
                    var result = $.parseJSON(decodeURIComponentSafe(data.d));
                    if (result == '' || result == "") {
                        bExist = false;
                        $("#txtPrimaryPhoneNumberDealerProfile").css({ 'border': '1px solid #d2d6de' });
                    }
                    else {
                        if (result != null) {
                            if (result == true) {
                                bExist = true;
                                $("#btnSave").attr('disabled', true);
                                notify('danger', "Primary Phone No Already Exist. Please enter another phone number");
                                $("#txtPrimaryPhoneNumberDealerProfile").css({ 'border': '1px solid red' });
                            } 
                            else 
                            {
                                bExist = false;
                                $("#btnSave").attr('disabled', false);
                                $("#txtPrimaryPhoneNumberDealerProfile").css({ 'border': '1px solid #d2d6de' });
                            }
                        }
                        else {
                            bExist = false;
                            $("#txtPrimaryPhoneNumberDealerProfile").css({ 'border': '1px solid #d2d6de' });
                        }
                    }
                }
        });

    }
    else {
        bExist = false;
    }

   
    return bExist;
}

function decodeURIComponentSafe(s) {
    if (!s) {
        return s;
    }
    return decodeURIComponent(s.replace(/%(?![0-9][0-9a-fA-F]+)/g, '%25'));
}


$(document).on("keyup", "#txtPrimaryPhoneNumberDealerProfile", function (parameters) {
    var isresult = false;
    var $regexname = /^(?=(?:\D*\d){10,18}\D*$)(?:\(?0?[0-9]{1,3}\)?|\+?[0-9]{1,3})[\s-]?(?:\(0?[0-9]{1,5}\)|[0-9]{1,5})[-\s]?[0-9][\d\s-]{5,7}\s?(?:x[\d-]{0,4})?(?:[-\s]?[0-9]{1,4}|[-\s])$/;
    if (!$(this).val().match($regexname)) {
        $("#txtPrimaryPhoneNumberDealerProfile").css({ 'border': '1px solid red' });
		 notify('danger', "Invalid Primary Phone Number. Please enter another Phone Number");
    }
    else {      
       
        isresult = IsExistDealer();
        if (bExist == true) {
            $("#btnSave").attr('disabled', true);
            $("#txtPrimaryPhoneNumberDealerProfile").css({ 'border': '1px solid red' });
            notify('danger', "Primary Phone Number Already Exist. Please enter another Phone Number");
        } else {
            $("#btnSave").attr('disabled', false);
            $("#txtPrimaryPhoneNumberDealerProfile").css({ 'border': '1px solid #d2d6de' });
        }

    }
});

$(document).on('change', '#ddlDealerId', function () {
    
    var phone = $(this).val();
    var URL = currentPagePath + "GetUserData";
    if (phone != null && phone != "" && phone != "-1") {
        $.ajax({
            type: "POST",
            url: URL,
            data: "{ 'phone':'" + phone + "'}",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            error:
                function (XMLHttpRequest, textStatus, errorThrown) {
                    $("#tblYourAccounts_tbody").empty();
                    $('#divTableYourAccounts').css("display", "none");
                },
            success:
                function (data) {
                    var result = $.parseJSON(decodeURIComponent(data.d));
                    if (result == '' || result == "") {
                        $("#tblYourAccounts_tbody").empty();
                        $('#divTableYourAccounts').css("display", "none");
                    }
                    else {
                        if (result != null) {
                            BindUserInfo(result);
                        }
                    }
                }
        });

    }
    else {
        $("#tblYourAccounts_tbody").empty();
        $('#divTableYourAccounts').css("display", "none");
    }

});

function BindUserInfo(result) {
    var content = ""
    $.each(result, function (i, obj) {   
        var cdate = ConvertJasoDateToNormalDate(obj.CreatedDate);
        var convdate = getDateFormate_DDMMMYYY(cdate);
        content += "<tr>";
        content += "<td>" + obj.Name + "</td>";
        content += "<td>" + obj.Phone + "</td>";
        content += "<td>" + obj.Address + "</td>";
        content += "<td>" + obj.City + "</td>";
        content += "<td>" + obj.State + "</td>";
        content += "<td>" + obj.Zip + "</td>";
        //content += '<td>' + ConvertJasoDate(obj.CreatedDate) + '</td>';
        content += '<td>' + convdate + '</td>';
        content += "</tr>";
    })
    $("#tblYourAccounts_tbody").empty();
    $("#tblYourAccounts_tbody").append(content);
    $('#divTableYourAccounts').css("display", "block");
}


function validateEmail(email) {
    var reg = "^[a-zA-Z0-9]+(\.[_a-zA-Z0-9]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,15})$";
    //var address = document.getElementById[email].value;
    if (reg.test(email) == false) {      
        return false;
    }
    else {
        return true;
    }
}

$(document).on("keyup", "#txtEmailAddressDealerProfile", function (parameters) {  
	var email = $("#txtEmailAddressDealerProfile").val().trim();  
    var emailre = $("#txtReEnterEmailAddressDealerProfile").val().trim();
    var $regexname = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;

    if (!$(this).val().match($regexname)) {
        $("#txtEmailAddressDealerProfile").css({ 'border': '1px solid red' });
        notify('danger', "Invalid Email Address");
    }
    else {
        if (email != emailre) {
            $("#txtEmailAddressDealerProfile").css({ 'border': '1px solid red' });     
            notify('danger', "Email Address and Re-Email Address Does not Match");
        }
        else {
			$("#txtEmailAddressDealerProfile").css({ 'border': '1px solid #d2d6de' });
            $("#txtReEnterEmailAddressDealerProfile").css({ 'border': '1px solid #d2d6de' });
        }
		
    }
    
});

$(document).on("keyup", "#txtReEnterEmailAddressDealerProfile", function (parameters) {  
    var $regexname = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
    var email = $("#txtEmailAddressDealerProfile").val().trim();  
    var emailre = $("#txtReEnterEmailAddressDealerProfile").val().trim();

    if (!$(this).val().match($regexname)) {
        $("#txtReEnterEmailAddressDealerProfile").css({ 'border': '1px solid red' });
        notify('danger', "Invalid Re-Email Address");
    }
    else {
        if (email != emailre) {
            $("#txtReEnterEmailAddressDealerProfile").css({ 'border': '1px solid red' });     
            notify('danger', "Email Address and Re-Email Address Does not Match");
        }
        else {
			$("#txtEmailAddressDealerProfile").css({ 'border': '1px solid #d2d6de' });
            $("#txtReEnterEmailAddressDealerProfile").css({ 'border': '1px solid #d2d6de' });
        }
        //$("#txtReEnterEmailAddressDealerProfile").css({ 'border': '1px solid #d2d6de' });
    }

});

$(document).on("keyup", "#txtPasswordDealerProfile", function (parameters) {

    var password = $("#txtPasswordDealerProfile").val().trim();
 
    var passwordre = $("#txtReEnterPasswordDealerProfile").val().trim();

    if (password != passwordre) {
        $("#txtPasswordDealerProfile").css({ 'border': '1px solid red' });
        notify('danger', "Password and Re-Password Does not Match");
    }
    else {
        $("#txtPasswordDealerProfile").css({ 'border': '1px solid #d2d6de' });
        $("#txtReEnterPasswordDealerProfile").css({ 'border': '1px solid #d2d6de' });
    }

});

$(document).on("keyup", "#txtReEnterPasswordDealerProfile", function (parameters) {

    var password = $("#txtPasswordDealerProfile").val().trim();

    var passwordre = $("#txtReEnterPasswordDealerProfile").val().trim();

    if (password != passwordre) {
        $("#txtReEnterPasswordDealerProfile").css({ 'border': '1px solid red' });
        notify('danger', "Password and Re-Password Does not Match");
    }
    else {
        $("#txtPasswordDealerProfile").css({ 'border': '1px solid #d2d6de' });
        $("#txtReEnterPasswordDealerProfile").css({ 'border': '1px solid #d2d6de' });
    }

});

