var currentPagePath = "/Pages/Accounts/MyReferralView.aspx" + "/";

var commondata = "CommonData/"
$(document).ready(function () {
    //$(".tDate").datepicker().datepicker("setDate", new Date());
    $(".tDate").datepicker({
        dateFormat: "mm-dd-yy",
        changeYear: true,
        changeMonth: true
    });
    //InitialSalesPartnerProfileLoad();
    LoadEarnedStatus();
    getDetailscommissionAmount();
    //$("#chkAll").prop('checked',t)

});
function LoadEarnedStatus() {
    var URL = currentPagePath + "GetEarnedMoneyDetails";
    var obj = {};
    let GetData = makeAjaxCallReturnPromiss(URL, obj);
    GetData.then((data) => {       
        let result = $.parseJSON(decodeURIComponent(data.d));
        if (result != "") {
            $("#lblEarnedAmount").text(result);
        }

    });

};
$(document).on('change', '#chkAll', function() {
    if ($(this).is(':checked')) {
        $("#txtStartDate").attr('disabled', true);
        $("#txtEndDate").attr('disabled', true);
        $("#btnSearch").attr('disabled', true);

        getDetailscommissionAmount();


    } else {
        $("#txtStartDate").attr('disabled', false);
        $("#txtEndDate").attr('disabled', false);
        $("#btnSearch").attr('disabled', false);
    }
});
$(document).on('click', '#btnSearch', function() {
    getDetailscommissionAmount();
})
function getDetailscommissionAmount() {
    var obj = {};
    if ($("#chkAll").is(':checked')) {
        obj = {
            "StartDate": "NULL",
            "EndDate": "NULL"
        }
    } else {
        obj = {
            "StartDate": $("#txtStartDate").val(),
            "EndDate": $("#txtEndDate").val()
        }
    }
    var URL = currentPagePath + "GetDetailsCommission";
  
    let GetData = makeAjaxCallReturnPromiss(URL, obj);
    GetData.then((data) => {
        let result = $.parseJSON(decodeURIComponent(data.d));       
        if (result.length > 0) {
            BindTable(result);
        }
        else {
            $("#tblReferalDetails_tbody").empty();
            $("#tblReferalDetails_tbody").append(content);
            $("#tblReferalDetails").dataTable();
        }

    });
}
function BindTable(result) {
    var content = "";   
    $.each(result, function (i, obj) {
        var cdate = ConvertJasoDateToNormalDate(obj.RegistrationDate);
        var convdate = getDateFormate_DDMMMYYY(cdate);
        content += "<tr>";
        content += "<td>" + (i+1) + "</td>";
        content += "<td>" + obj.Name + "</td>";
        content += "<td>" + obj.PhoneNo + "</td>";
        content += "<td>" + convdate + "</td>";
        content += "<td>" + obj.Month + "</td>";
        content += "<td>" + obj.Year + "</td>";
        content += "<td>" + obj.ReferalCommissionAmount + "</td>";
        content += "<td>" + obj.Status + "</td>";
        content += "</tr>";
    });
    $("#tblReferalDetails_tbody").empty();
    $("#tblReferalDetails_tbody").append(content);
    $("#tblReferalDetails").dataTable();
}
$(document).on('click', '#btnPrint', function () {
    var divToPrint = document.getElementById('tblReferalDetails');
    PrintDiv(divToPrint.outerHTML);
});

function PrintDiv(data) {
    var mywindow = window.open();
    var is_chrome = Boolean(mywindow.chrome);
    mywindow.document.write(data);

    if (is_chrome) {
        setTimeout(function () { // wait until all resources loaded 
            mywindow.document.close(); // necessary for IE >= 10
            mywindow.focus(); // necessary for IE >= 10
            mywindow.print(); // change window to winPrint
            mywindow.close(); // change window to winPrint
        }, 250);
    } else {
        mywindow.document.close(); // necessary for IE >= 10
        mywindow.focus(); // necessary for IE >= 10

        mywindow.print();
        mywindow.close();
    }

    return true;
}
$(document).on('click', "#btnExit", function () {
    window.location.href = window.location.origin + "/home";
});