//var currentPagePath = window.location.pathname + "/";
var currentPagePath = "/Pages/Admin/GroupCodeDealerProfile.aspx" + "/";
//var commondata = "CommonData/"

$(document).ready(function () {
    $(".tDate").datepicker({
        dateFormat: "mm-dd-yy",
        changeYear: true,
        changeMonth: true
    });

    LoadAllGroupCode()

});

$(document).on('click', '.rdoGroupCodeForUser', function () {
    $('#tblGroupCodeList tbody').empty();
    ClearField();
    LoadAllGroupCode();

});

$(document).on('click', '.txtDealerGroupPlan', function () {
    $("#txtBasicAmount").val("");
    $("#txtBasicAmount").css({ 'border': '1px solid #d2d6de' });
    $("#txtSilverAmount").val("");
    $("#txtSilverAmount").css({ 'border': '1px solid #d2d6de' });
    $("#txtGoldAmount").val("");
    $("#txtGoldAmount").css({ 'border': '1px solid #d2d6de' });

});

function LoadAllGroupCode() {
   
    var GroupCodeFor = $("input[name=GroupCodeFor]:checked").val();
    var URL = currentPagePath + "GetData";
    var Obj = {
        "GroupCodeFor": GroupCodeFor
    }
    let GetData = makeAjaxCallReturnPromiss(URL, Obj);
    GetData.then((data) => {
       
        let result = $.parseJSON(decodeURIComponentSafe(data.d));
        if (result != null) {
            BindGroupCodeData(result);
        }

    });

};

function decodeURIComponentSafe(s) {
    if (!s) {
        return s;
    }
    return decodeURIComponent(s.replace(/%(?![0-9][0-9a-fA-F]+)/g, '%25'));
}

function BindGroupCodeData(result) {
    var content = " ";
   
    var dat = "";
    if (result.length > 0) {
        $.each(result, function (i, obj) {
           

            content += '<tr>'
            content += '<td>' + obj.BillEvery + '</td>'
            content += '<td>' + obj.GroupCodeNo + '</td>'
            content += '<td>' + obj.GroupName + '</td>'
            content += '<td>' + obj.GroupDescription + '</td>'
            content += '<td> <button class="btnUpdate btn" style="background-color:#3B5998;color:white" data-GroupCodeID=' + obj.Id + ' type = "button"> Edit </button> <button class="btnDelete btn" style = "background-color:red;color:white" data-GroupCodeID=' + obj.Id + ' type = "button"> Delete </button></td>'

            content += '</tr>';
        })


        $('#tblGroupCodeList tbody').empty();
        $('#tblGroupCodeList tbody').append(content);

        $('#tblGroupCodeList').DataTable();
    }

}

$("#txtDealerCreditPhoneNo").autocomplete({
    source: function (request, response) {
       
        var GroupCodeFor = $("input[name=GroupCodeFor]:checked").val();
        var URL = currentPagePath + "SearchPhoneNumber";
        var Obj = {
            "autocompleteText": $("#txtDealerCreditPhoneNo").val(),
            "GroupCodeFor": GroupCodeFor
        };
        let GetData = makeAjaxCallReturnPromiss(URL, Obj);
        GetData.then((data) => {
           
            let result = $.parseJSON(decodeURIComponent(data.d));
            if (result != null) {
                response(result);
            }

        });
        // GetAutoCompleteData(response, aObj);
    },
    delay: 500,
    minLength: 1,
    select: function (event, ui) {
        //$(this).attr('data-value', ui.item.id);
        //$(this).attr('title', ui.item.label);
    }

});


$(document).on('click', '.btnUpdate', function () {
   
    var GroupCodeID = $(this).attr('data-GroupCodeID');
    var URL = currentPagePath + "GetGroupCodeDetailsByGroupCodeId";

    if (GroupCodeID != null || GroupCodeID != "") {
        var obj = {
            "id": GroupCodeID
        };
        let GetData = makeAjaxCallReturnPromiss(URL, obj);
        GetData.then((data) => {
            let result = $.parseJSON(data.d);
            if (result != null) {
                BindGroupCodeInfo(result);
            }
            else {
                
            }
        });
    }
})

function BindGroupCodeInfo(result) {
   
    $("#txtBasicAmount").val("");
    $("#txtSilverAmount").val("");
    $("#txtGoldAmount").val("");
    $("#txtDealerCreditPhoneNo").val("");
    $("#txtDealerRewards").val("");

    var Plan = result.GroupPlan;
    $("input[name=plan][value='" + Plan + "']").prop("checked", true);

    if (Plan == 'Basic') { $("#txtBasicAmount").val(result.Amount); }

    else if (Plan == 'Silver') { $("#txtSilverAmount").val(result.Amount); }

    else { $("#txtGoldAmount").val(result.Amount); }

    if (result.IsForever == true) {
        $("#txtdate").hide();
        $("#chkDealerIsForever").prop("checked", true);
    }
    else {
        $("#txtdate").show();
        $("#chkDealerIsForever").prop("checked", false);
    }

    var bill = result.BillEvery;
    $("input[name=Billvery][value='" + bill + "']").prop("checked", true);


    if (result.IsRequiredACHInfo == true) { $("#chkDealerIsRequiredACHInfo").prop("checked", true); }

    else { $("#chkDealerIsRequiredACHInfo").prop("checked", false); }

    $("#txtDealerGroupCode").attr('data-GroupCodeID', result.Id);
    $("#txtDealerGroupCode").val(result.GroupCodeNo),
        $("#txtDealerGroupName").val(result.GroupName),
        $("#txtDealerGroupDescription").val(result.GroupDescription),
        $("#txtDealerStartDate").val(ConvertJasoDate(result.StartDate)),
        $("#txtDealerEndDate").val(ConvertJasoDate(result.EndDate)),

        $("#txtDealerCreditPhoneNo").val(result.CreditPhoneNo),
        $("#txtDealerRewards").val(result.Rewards),
        $("#txtDealerGroupCodeFor").val(result.GroupCodeFor)
    $("#btnSave").text("Update");


}

function ConvertJasoDate(date) {
    if (date == null) {
        return "";
    }
    var nowDate = new Date(parseInt(date.substr(6)));
    var dat = nowDate.getMonth() + 1 + "-" + nowDate.getDate() + "-" + nowDate.getFullYear();
    return dat;

}

$(document).on('click', '#btnSave', function () {
    var URL = currentPagePath + "Save";
    var isValid = getValid();
    var IsPayable = false;
    var amount = 0.0;
    var Plan = $("input[name=plan]:checked").val();
    if (Plan == 'Basic') {
        amount = $("#txtBasicAmount").val();
    }
    else if (Plan == 'Silver') {
        amount = $("#txtSilverAmount").val();
    }
    else {
        amount = $("#txtGoldAmount").val();
    }

    if (amount === "undefined" || amount === "") {
        IsPayable = false;
    }
    else {
        if (parseFloat(amount) > 0) {
            IsPayable = true;
        }
    }

    if (isValid) {
        if (IsPayable == true) {
            var Obj = SaveData();
            let GetData = makeAjaxCallReturnPromiss(URL, Obj);
            GetData.then((data) => {

                let result = $.parseJSON(decodeURIComponent(data.d));
                if (result == true) {
                    LoadAllGroupCode();
                    ClearField();

                    var saveOrUpdate = $("#btnSave").text();
                    if (saveOrUpdate == 'Update') {
                        notify('success', "Group Code Updated Successfully !!");
                    }
                    else
                    {
                        notify('success', "Group Code Saved Successfully !!");
                    }

                    $("#btnSave").text("Save");
                }
                else {

                    notify("danger", "Group Code Save Failed !!");
                }
            });
        }
        else {
            notify("danger", "Amount should be greater than zero !!");           
        }       
    }
    else
    {
        notify("danger", "Please fill out all mandatory fields !!");
    }

});

function getValid() {
    var isValid = true;
    if ($("#txtDealerGroupCode").val() == "") {
        $("#txtDealerGroupCode").css({ 'border': '1px solid red' });
        isValid = false;
    }
    if ($("#txtDealerGroupName").val() == "") {
        $("#txtDealerGroupName").css({ 'border': '1px solid red' });
        isValid = false;
    }
    var Plan = $("input[name=plan]:checked").val();
    if (Plan == 'Basic') {
        if ($("#txtBasicAmount").val() == "") {
            $("#txtBasicAmount").css({ 'border': '1px solid red' });
            isValid = false;
        }
        else {
            $("#txtSilverAmount").css({ 'border': '1px solid #d2d6de' });
            $("#txtGoldAmount").css({ 'border': '1px solid #d2d6de' });
        }

    }
    else if (Plan == 'Silver') {
        if ($("#txtSilverAmount").val() == "") {
            $("#txtSilverAmount").css({ 'border': '1px solid red' });
            isValid = false;
        }
        else {
            $("#txtBasicAmount").css({ 'border': '1px solid #d2d6de' });
            $("#txtGoldAmount").css({ 'border': '1px solid #d2d6de' });
        }
    }
    else {
        if ($("#txtGoldAmount").val() == "") {
            $("#txtGoldAmount").css({ 'border': '1px solid red' });
            isValid = false;
        }
        else {
            $("#txtSilverAmount").css({ 'border': '1px solid #d2d6de' });
            $("#txtBasicAmount").css({ 'border': '1px solid #d2d6de' });
        }
    }
    if ($("#chkDealerIsForever").is(':checked')) {

    }
    else {
        if ($("#txtDealerStartDate").val() == "" && $("#txtDealerEndDate").val() == "") {
            $("#txtDealerStartDate").css({ 'border': '1px solid red' });
            $("#txtDealerEndDate").css({ 'border': '1px solid red' });
            isValid = false;
        }

    }
    if ($("#txtDealerCreditPhoneNo").val() == "") {
        $("#txtDealerCreditPhoneNo").css({ 'border': '1px solid red' });
        isValid = false;
    }
    if ($("#txtDealerRewards").val() == "") {
        $("#txtDealerRewards").css({ 'border': '1px solid red' });
        isValid = false;
    }   

    if (isValid) {       
        return true;
    } else {
      //  notify("danger", "Please fill out required fields");
        return false;
    }
}

$(document).on('click', '#chkDealerIsForever', function () {
   
    if ($("#chkDealerIsForever").is(':checked')) {
        $("#txtdate").hide();
    } else {
        $("#txtdate").show();
    }
});

function SaveData() {
    var IsForever = false;
    var StartDate = null;
    var EndDate = null;
    var amount = 0.0;
    var Plan = $("input[name=plan]:checked").val();
    if (Plan == 'Basic') {
        amount = $("#txtBasicAmount").val();
    }
    else if (Plan == 'Silver') {
        amount = $("#txtSilverAmount").val();
    }
    else {
        amount = $("#txtGoldAmount").val();
    }
    var bill = $("input[name=Billvery]:checked").val();
    var GroupCodeFor = $("input[name=GroupCodeFor]:checked").val();

    if ($("#chkDealerIsForever").is(':checked')) {
        IsForever = true;
    }
    else {
        StartDate = $("#txtDealerStartDate").val();
        EndDate = $("#txtDealerEndDate").val()
        IsForever = false;
    }
    var phone = $("#txtDealerCreditPhoneNo").val();
    if (phone === "undefined" || phone === "") {
        phone = "";
    }
    else {
        phone = $("#txtDealerCreditPhoneNo").val().split('-')[0];
    }

    var DealerObject = {

        "Id": $("#txtDealerGroupCode").attr('data-GroupCodeID'),
        "GroupCodeNo": $("#txtDealerGroupCode").val(),
        "GroupName": $("#txtDealerGroupName").val(),
        "GroupDescription": $("#txtDealerGroupDescription").val(),
        "GroupPlan": Plan,
        "Amount": amount,
        "BillEvery": bill,
        "IsForever": IsForever,
        "StartDate": StartDate,
        "EndDate": EndDate,
        "IsRequiredACHInfo": $("#chkDealerIsRequiredACHInfo").is(':checked') == true ? true : false,
        "CreditPhoneNo": phone.trim(),
        "Rewards": $("#txtDealerRewards").val(),
        "GroupCodeFor": GroupCodeFor

    }

    return DealerObject;
}

function ClearField(){
   
    $("#txtDealerGroupCode").val("");
    $("#txtDealerGroupCode").css({ 'border': '1px solid #d2d6de' });
    $("#txtDealerGroupName").val("");
    $("#txtDealerGroupName").css({ 'border': '1px solid #d2d6de' });
    $("#txtDealerGroupDescription").val("");
    $("input[name=plan][value='Basic']").prop("checked", true);
    $("#txtBasicAmount").val("");
    $("#txtBasicAmount").css({ 'border': '1px solid #d2d6de' });
    $("#txtSilverAmount").val("");
    $("#txtSilverAmount").css({ 'border': '1px solid #d2d6de' });
    $("#txtGoldAmount").val("");
    $("#txtGoldAmount").css({ 'border': '1px solid #d2d6de' });
    $("input[name=Billvery][value='Monthly']").prop("checked", true);
    $("#chkDealerIsForever").prop("checked", false);
    $("#txtdate").show();
    $("#txtDealerStartDate").val("");
    $("#txtDealerStartDate").css({ 'border': '1px solid #d2d6de' });
    $("#txtDealerEndDate").val("");
    $("#txtDealerEndDate").css({ 'border': '1px solid #d2d6de' });
    $("#chkDealerIsRequiredACHInfo").prop("checked", false);
    $("#txtDealerCreditPhoneNo").val("");
    $("#txtDealerCreditPhoneNo").css({ 'border': '1px solid #d2d6de' });
    $("#txtDealerRewards").val("");
    $("#txtDealerRewards").css({ 'border': '1px solid #d2d6de' });
    $("#txtDealerGroupCodeFor").val($("input[name=GroupCodeFor]:checked").val());
    
}

function showconfirm() {
    var r = confirm("Are You Sure To Delete?");
    if (r) {
        return true;
    }
    else {
        return false;
    }
}

$(document).on('click', '.btnDelete', function () {
   
    var GroupCodeID = $(this).attr('data-GroupCodeID');
    var URL = currentPagePath + "DeleteGroupCodeDetailsByGroupCodeId";

    if (GroupCodeID != null || GroupCodeID != "") {
        var obj = {
            "id": GroupCodeID
        };
       
        if (showconfirm()) {
            let GetData = makeAjaxCallReturnPromiss(URL, obj);
            GetData.then((data) => {               
                let result = $.parseJSON(decodeURIComponent(data.d));
                if (result != null) {
                    LoadAllGroupCode();
                }
                else {
                    
                }
            });
        }
    }

});

$(document).on('click', '#btnClear', function () {
    ClearField();
});
