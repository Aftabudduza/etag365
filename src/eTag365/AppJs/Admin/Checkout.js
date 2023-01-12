
var currentPagePath = "/Pages/Admin/Checkout.aspx" + "/";
var isCheckoutSuccessful = false;
var sResponseCode = "";
var sResponseDetails = "";
var sApplicationFee = "";
var sLast4 = "";
var sExpMonth = "";
var sExpYear = "";
var sMethod = "";
var objBilling = "";
var bShow = true;
var strace_number = "";

$(document).ready(function () {
    LoadBillingInformation();   
    $(".btnPaymentGetway").attr("allowed_methods", "visa, mast, disc, amex, dine, jcb, echeck");  
    
});

// Combo SetUp
function setCombo(data, selectedvalue) {
    var content = '<option value="-1">Select.......</option>';
    if (data == undefined || data.length == 0 || data == null) {
        return content;
    }
    else {
        if (selectedvalue == undefined || selectedvalue == null) {
            $.each(data, function (i, obj) {
                content += '<option data_Id="' + obj.Id + '" value="' + obj.Id2 + '">' + obj.Data + '</option>';
            });
        }

        else {
            $.each(data, function (i, obj) {
                if (obj.Id2 == selectedvalue) {
                    content += '<option data_Id="' + obj.Id + '" value="' + obj.Id2 + '" selected>' + obj.Data + '</option>';
                } else {
                    content += '<option data_Id="' + obj.Id + '" value="' + obj.Id2 + '">' + obj.Data + '</option>';
                }
            });
        }

    }

    return content;
}

function setComboWithIntValue(data, selectedvalue) {
    var content = '<option value="-1">Select.......</option>';
    if (data == undefined || data.length == 0 || data == null) {
        return content;
    }
    else {
        if (selectedvalue == undefined || selectedvalue == null) {
            $.each(data, function (i, obj) {
                content += '<option data_Id="' + obj.Id2 + '" value="' + obj.Id + '">' + obj.Data + '</option>';
            });
        }

        else {
            $.each(data, function (i, obj) {
                if (obj.Id == selectedvalue) {
                    content += '<option data_Id="' + obj.Id2 + '" value="' + obj.Id + '" selected>' + obj.Data + '</option>';
                } else {
                    content += '<option data_Id="' + obj.Id2 + '" value="' + obj.Id + '">' + obj.Data + '</option>';
                }
            });
        }

    }

    return content;
}

function decodeURIComponentSafe(s) {
    if (!s) {
        return s;
    }
    return decodeURIComponent(s.replace(/%(?![0-9][0-9a-fA-F]+)/g, '%25'));
}

function oncallback(e) {  
   
   
    var IsPayable = false;   

    var nTotal = $("#TotalAmountChargeRe").val();

    if (nTotal === "undefined" || nTotal === "") {
        IsPayable = false;
    }
    else {
        if (parseFloat(nTotal) > 0) {
            IsPayable = true;
        }
    }

    if (IsPayable == true) {

        var response = JSON.parse(e.data);
        switch (response.event) {

            case 'begin':

                //call to forte checkout is successful
                break;

            case 'success':

                //transaction successful

                isCheckoutSuccessful = true;
                sResponseCode = response.authorization_code;
                sResponseDetails = response.response_description;
                sApplicationFee = response.total_amount;
                sLast4 = response.last_4;
                strace_number = response.trace_number;
                
                if (response.method_used == "echeck") {
                    sExpMonth = "";
                    sExpYear = "";
                    sMethod = "Check";
                }
                else {
                    sExpMonth = response.expire_month;
                    sExpYear = response.expire_year;
                    sMethod = "Credit";
                }                

                SaveTransaction(sMethod);

                alert('Transaction Successful. TranId - ' + response.trace_number);

                break;

            case 'failure':

                //handle failed transaction

                alert('sorry, transaction failed due to ' + response.response_description + '. TranId -  ' + response.trace_number);

                isCheckoutSuccessful = false;
                sResponseCode = response.response_code;
                sResponseDetails = response.response_description;

        }

    }
    else {
        notify("danger", "Invalid Amount !!");
    }



}

$(document).on('click', '#btnExit', function (parameters) {
    var origin = window.location.origin;
    window.location.href = origin + "/home";
});
$(document).on('click', '#btnGo', function (parameters) {
    var origin = window.location.origin;
    window.location.href = origin + "/home";
});
function clearPaymentField() {
    $(".btnPaymentGetway").attr("card_number", "");
    $(".btnPaymentGetway").attr("expire", "");
    $(".btnPaymentGetway").attr("cvv", "");
    $(".btnPaymentGetway").attr("routing_number", "");
    $(".btnPaymentGetway").attr("account_number", "");
    $(".btnPaymentGetway").attr("account_number2", "");
    $(".btnPaymentGetway").attr("allowed_methods", "visa, mast, disc, amex, dine, jcb, echeck");
    $(".btnPaymentGetway").attr("billing_name", "");
    $(".btnPaymentGetway").attr("billing_street_line1", "");
    $(".btnPaymentGetway").attr("billing_locality", "");
    $(".btnPaymentGetway").attr("billing_region", "");
    $(".btnPaymentGetway").attr("billing_postal_code", "");
}
function LoadBillingInformation() {
   
    var URL = currentPagePath + "GetPaymentHistoryData";
    var Obj = {}
   

    $.ajax({
        type: "POST",
        url: URL,
        data: Obj,
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        error:
            function (XMLHttpRequest, textStatus, errorThrown) {
                alert("Error");
            },
        success:
            function (data) {

                var result = $.parseJSON(decodeURIComponentSafe(data.d));
                if (result != null) {
                    objBilling = result;
                    BindBillingInformation(result);
                }
            }

    });

};
function BindBillingInformation(result) {
    if (result == null || result == "") {

    }
    else {

        //$(".btnPaymentGetway").attr("billing_name", result.AccountName);
        $(".btnPaymentGetway").attr("billing_street_line1", result.Address);
        $(".btnPaymentGetway").attr("billing_locality", result.City);
        $(".btnPaymentGetway").attr("billing_region", result.State);
        $(".btnPaymentGetway").attr("billing_postal_code", result.Zip);

        if (result.IsCheckingAccount == true) {
            $(".btnPaymentGetway").attr("allowed_methods", "echeck");
            $(".btnPaymentGetway").attr("routing_number", result.RoutingNo);
            $(".btnPaymentGetway").attr("account_number", result.AccountNo);
        }
        else {
            $(".btnPaymentGetway").attr("allowed_methods", "visa, mast, disc, amex, dine, jcb");
            $(".btnPaymentGetway").attr("card_number", result.CardNumber);
            $(".btnPaymentGetway").attr("cvv", result.CVS);
            //$(".btnPaymentGetway").attr("expire", result.Month + "/" + result.Year);
        }

        $("#PlanCharge").text(result.BasicAmount);
        $("#storageCharge").text(result.StorageAmount);
        $("#subTotalCharge").text(result.SubTotalCharge);
        $("#Discount").text(result.Discount);
        $("#TotalAmountCharge").text(result.GrossAmount);
        $("#percentRatio").text(result.DiscountPercentage);
        $("#groupcode").val(result.Promocode);
        $("#TotalAmountChargeRe").val(result.GrossAmount);
       
    }

}
function GetSavedObjFinal(creditType) {
   
    var obj = objBilling;

    if (creditType == 'Credit') {
        obj.AccountType = 'Credit';
        obj.IsCheckingAccount = false;
        obj.RoutingNo = '';
        obj.AccountNo = '';
        obj.CheckNo = '';
        obj.GrossAmount = sApplicationFee;
        obj.NetAmount = sApplicationFee;
        obj.LastFourDigitCard = sLast4;
        obj.CardNumber = sLast4;
        obj.Month = sExpMonth;
        obj.Year = sExpYear;
        obj.TransactionCode = strace_number;
        obj.AuthorizationCode = sResponseCode;
        obj.TransactionDescription = sResponseDetails;

       
    }
    else {
        obj.AccountType = 'Check';
        obj.IsCheckingAccount = true;
        obj.AccountNo = sLast4;
        obj.CheckNo = '';
        obj.GrossAmount = sApplicationFee;
        obj.NetAmount = sApplicationFee;
        obj.LastFourDigitCard = sLast4;
        obj.CardNumber = '';
        obj.Month = '';
        obj.Year = '';
        obj.TransactionCode = strace_number;
        obj.AuthorizationCode = sResponseCode;
        obj.TransactionDescription = sResponseDetails;
    }

    return obj;
}
function SaveTransaction(creditType) {
   
    var obj = GetSavedObjFinal(creditType);
    var pagePath = currentPagePath + "Save";
    $.ajax({
        type: "POST",
        url: pagePath,
        data: JSON.stringify({ "obj": obj }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        error:
            function (XMLHttpRequest, textStatus, errorThrown) {
                //alert("Error");
            },
        success:
            function (result) {

                var obj = $.parseJSON(decodeURIComponentSafe(result.d));
                if (obj == true) {
                    //notify('success', "Thank you. Your Payment was successful");

                } else {
                    //notify('danger', "Your Payment failed !!");
                }

            }

    });

}

