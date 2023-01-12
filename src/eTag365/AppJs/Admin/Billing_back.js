//var cardType = "";
//var base = "~";
//var DataUrl = "/Pages/Settings/CommonData.aspx";
//var currentPagePath = "/Pages/Admin/Billing.aspx" + "/";

//var pathname = "/Pages/Admin/Billing.aspx"; ///window.location.pathname; // Returns path only
//var url = "/Pages/Admin/Billing.aspx"; ///window.location.href;     // Returns full URL
//var origin = window.location.origin;   // Returns base URL
//var submitt = false;
//var isCheckoutSuccessful = false;
//var sResponseCode = "";
//var sResponseDetails = "";
//var sApplicationFee = "";
//var sLast4 = "";
//var sExpMonth = "";
//var sExpYear = "";
//var bShow = true;
//var strace_number = "";

//$(document).ready(function () {  

//    $("#IsStorageDisplay").hide();
//    InitialLoad();
//    LoadDropdownlist();
//    LoadAllPaymentInformation();
//    LoadBillingInformation();

//    bShow = $("#hdnShow").val();
//    if (bShow === "undefined" || bShow === "") {
//        $("#btnSubmit").css({ 'display': 'block' });
//    }
//    else {
//        if (bShow === "false") {
//            $("#btnSubmit").css({ 'display': 'none' });
//        }
//        else {
//            $("#btnSubmit").css({ 'display': 'block' });
//        }
//    }
//    $(".btnPaymentGetway").attr("allowed_methods", "visa, mast, disc, amex, dine, jcb, echeck");


//    var masking = {

//        // User defined Values
//        //maskedInputs : document.getElementsByClassName('masked'), // add with IE 8's death
//        maskedInputs: document.querySelectorAll('.masked'), // kill with IE 8's death
//        maskedNumber: 'XdDmMyY9',
//        maskedLetter: '_',

//        init: function () {
//            masking.setUpMasks(masking.maskedInputs);
//            masking.maskedInputs = document.querySelectorAll('.masked'); // Repopulating. Needed b/c static node list was created above.
//            masking.activateMasking(masking.maskedInputs);
//        },

//        setUpMasks: function (inputs) {
//            var i, l = inputs.length;

//            for (i = 0; i < l; i++) {
//                masking.createShell(inputs[i]);
//            }
//        },

//        // replaces each masked input with a shall containing the input and it's mask.
//        createShell: function (input) {
//            var text = '',
//                placeholder = input.getAttribute('placeholder');

//            input.setAttribute('maxlength', placeholder.length);
//            input.setAttribute('data-placeholder', placeholder);
//            input.removeAttribute('placeholder');

//            text = '<span class="shell">' +
//                '<span aria-hidden="true" id="' + input.id +
//                'Mask"><i></i>' + placeholder + '</span>' +
//                input.outerHTML +
//                '</span>';

//            //input.outerHTML = text;
//        },

//        setValueOfMask: function (e) {
//            var value = e.target.value,
//                placeholder = e.target.getAttribute('data-placeholder');

//            return "<i>" + value + "</i>" + placeholder.substr(value.length);
//        },

//        // add event listeners
//        activateMasking: function (inputs) {
//            var i, l;

//            for (i = 0, l = inputs.length; i < l; i++) {
//                if (masking.maskedInputs[i].addEventListener) { // remove "if" after death of IE 8
//                    masking.maskedInputs[i].addEventListener('keyup', function (e) {
//                        masking.handleValueChange(e);
//                    }, false);
//                } else if (masking.maskedInputs[i].attachEvent) { // For IE 8
//                    masking.maskedInputs[i].attachEvent("onkeyup", function (e) {
//                        e.target = e.srcElement;
//                        masking.handleValueChange(e);
//                    });
//                }
//            }
//        },

//        handleValueChange: function (e) {
//            var id = e.target.getAttribute('id');

//            switch (e.keyCode) { // allows navigating thru input
//                case 20: // caplocks
//                case 17: // control
//                case 18: // option
//                case 16: // shift
//                case 37: // arrow keys
//                case 38:
//                case 39:
//                case 40:
//                case 9: // tab (let blur handle tab)
//                    return;
//            }

//            document.getElementById(id).value = masking.handleCurrentValue(e);
//            document.getElementById(id + 'Mask').innerHTML = masking.setValueOfMask(e);

//        },

//        handleCurrentValue: function (e) {
//            var isCharsetPresent = e.target.getAttribute('data-charset'),
//                placeholder = isCharsetPresent || e.target.getAttribute('data-placeholder'),
//                value = e.target.value, l = placeholder.length, newValue = '',
//                i, j, isInt, isLetter, strippedValue;

//            // strip special characters
//            strippedValue = isCharsetPresent ? value.replace(/\W/g, "") : value.replace(/\D/g, "");

//            for (i = 0, j = 0; i < l; i++) {
//                var x =
//                    isInt = !isNaN(parseInt(strippedValue[j]));
//                isLetter = strippedValue[j] ? strippedValue[j].match(/[A-Z]/i) : false;
//                matchesNumber = masking.maskedNumber.indexOf(placeholder[i]) >= 0;
//                matchesLetter = masking.maskedLetter.indexOf(placeholder[i]) >= 0;

//                if ((matchesNumber && isInt) || (isCharsetPresent && matchesLetter && isLetter)) {

//                    newValue += strippedValue[j++];

//                } else if ((!isCharsetPresent && !isInt && matchesNumber) || (isCharsetPresent && ((matchesLetter && !isLetter) || (matchesNumber && !isInt)))) {
//                    // masking.errorOnKeyEntry(); // write your own error handling function
//                    return newValue;

//                } else {
//                    newValue += placeholder[i];
//                }
//                // break if no characters left and the pattern is non-special character
//                if (strippedValue[j] == undefined) {
//                    break;
//                }
//            }
//            if (e.target.getAttribute('data-valid-example')) {
//                return masking.validateProgress(e, newValue);
//            }
//            return newValue;
//        },

//        validateProgress: function (e, value) {
//            var validExample = e.target.getAttribute('data-valid-example'),
//                pattern = new RegExp(e.target.getAttribute('pattern')),
//                placeholder = e.target.getAttribute('data-placeholder'),
//                l = value.length, testValue = '';

//            //convert to months
//            if (l == 1 && placeholder.toUpperCase().substr(0, 2) == 'MM') {
//                if (value > 1 && value < 10) {
//                    value = '0' + value;
//                }
//                return value;
//            }
//            // test the value, removing the last character, until what you have is a submatch
//            for (i = l; i >= 0; i--) {
//                testValue = value + validExample.substr(value.length);
//                if (pattern.test(testValue)) {
//                    return value;
//                } else {
//                    value = value.substr(0, value.length - 1);
//                }
//            }

//            return value;
//        },

//        errorOnKeyEntry: function () {
//            // Write your own error handling
//        }
//    }

//    masking.init();
  
//});

//function InitialLoad() {

//    //.................. load State ...............//
//    var URL = "/Pages/Settings/CommonData.aspx/" + "GetState";
//    var obj = {};
//    let State = makeAjaxCallReturnPromiss(URL, obj);
//    State.then((data) => {

//        console.log("State Data Loaded");
//        let StateData = setCombo($.parseJSON(decodeURIComponent(data.d)), '-1');

//        $('#ddlstateapp option').empty();
//        $("#ddlstateapp").append(StateData);
//        $("#ddlstateapp").select2();
//        $("#ddlstateapp").val("-1").trigger('change');
//    }).catch((err) => {
//        console.log(err);
//    });

//}

//function LoadDropdownlist() {

//    var Plan = $("input[name=plan]:checked").val();
//    if (Plan == 'Basic') {
//        var content = '<select id="ddlPeriod" class="ddl"><option value="Y">1 Year $11.88</option></select>';

//        $('#divddl').empty();
//        $("#divddl").append(content);
//        $("#ddlPeriod").select2();
//        $("#ddlPeriod").val("Y").trigger('change');
//    }
//    else if (Plan == 'Silver') {
//        //var content = '<option value="M">1 Month $4.99</option>';
//        //content += '<option value="Y">1 Year $54.00</option>';

//        var content = '<select id="ddlPeriod" class="ddl"><option value="M">1 Month $4.99</option><option value="Y">1 Year $54.00</option></select>';

//        $('#divddl').empty();
//        $("#divddl").append(content);
//        $("#ddlPeriod").select2();
//        $("#ddlPeriod").val("Y").trigger('change');

//    }
//    else if (Plan == 'Gold') {
//        //var content = '<option value="M">1 Month $9.99</option>';
//        //content += '<option value="Y">1 Year $110.00</option>';

//        var content = '<select id="ddlPeriod" class="ddl"><option value="M">1 Month $9.99</option><option value="Y">1 Year $110.00</option></select>';

//        $('#divddl').empty();
//        $("#divddl").append(content);
//        $("#ddlPeriod").select2();
//        $("#ddlPeriod").val("Y").trigger('change');

//    }
//    else {
//        var content = '<select id="ddlPeriod" class="ddl"><option value="Y">1 Year $11.88</option></select>';

//        $('#divddl').empty();
//        $("#divddl").append(content);
//        $("#ddlPeriod").select2();
//        $("#ddlPeriod").val("Y").trigger('change');


//    }

//}

//function showconfirm() {
//    var r = confirm("Are You Sure To Delete?");
//    if (r) {
//        return true;
//    }
//    else {
//        return false;
//    }
//}

//// Combo SetUp
//function setCombo(data, selectedvalue) {
//    var content = '<option value="-1">Select.......</option>';
//    if (data == undefined || data.length == 0 || data == null) {
//        return content;
//    }
//    else {
//        if (selectedvalue == undefined || selectedvalue == null) {
//            $.each(data, function (i, obj) {
//                content += '<option data_Id="' + obj.Id + '" value="' + obj.Id2 + '">' + obj.Data + '</option>';
//            });
//        }

//        else {
//            $.each(data, function (i, obj) {
//                if (obj.Id2 == selectedvalue) {
//                    content += '<option data_Id="' + obj.Id + '" value="' + obj.Id2 + '" selected>' + obj.Data + '</option>';
//                } else {
//                    content += '<option data_Id="' + obj.Id + '" value="' + obj.Id2 + '">' + obj.Data + '</option>';
//                }
//            });
//        }

//    }

//    return content;
//}

//function setComboWithIntValue(data, selectedvalue) {
//    var content = '<option value="-1">Select.......</option>';
//    if (data == undefined || data.length == 0 || data == null) {
//        return content;
//    }
//    else {
//        if (selectedvalue == undefined || selectedvalue == null) {
//            $.each(data, function (i, obj) {
//                content += '<option data_Id="' + obj.Id2 + '" value="' + obj.Id + '">' + obj.Data + '</option>';
//            });
//        }

//        else {
//            $.each(data, function (i, obj) {
//                if (obj.Id == selectedvalue) {
//                    content += '<option data_Id="' + obj.Id2 + '" value="' + obj.Id + '" selected>' + obj.Data + '</option>';
//                } else {
//                    content += '<option data_Id="' + obj.Id2 + '" value="' + obj.Id + '">' + obj.Data + '</option>';
//                }
//            });
//        }

//    }

//    return content;
//}

//function decodeURIComponentSafe(s) {
//    if (!s) {
//        return s;
//    }
//    return decodeURIComponent(s.replace(/%(?![0-9][0-9a-fA-F]+)/g, '%25'));
//}

//function oncallback(e) {
   
//    var creditType = $('input[name=card]:checked').val();
//    var validate = true;
//    var IsPayable = false;

//    if (creditType == 'Credit') {
//        validate = ValidateCredit();
//    }
//    else if (creditType == 'Check') {
//        validate = ValidateCheck();
//    }
//    else {
//        if (creditType === "undefined" || creditType === "") {
//            validate = false;
//        }
//    }

//    var nTotal = $("#TotalAmountChargeRe").val();

//    if (nTotal === "undefined" || nTotal === "") {
//        IsPayable = false;
//    }
//    else {
//        if (parseFloat(nTotal) > 0) {
//            IsPayable = true;
//        }
//    }

//    if (validate == true && (creditType == 'Credit' || creditType == 'Check') && IsPayable == true) {

//        var response = JSON.parse(e.data);
//        switch (response.event) {

//            case 'begin':

//                //call to forte checkout is successful
//                break;

//            case 'success':

//                //transaction successful

//                isCheckoutSuccessful = true;
//                sResponseCode = response.authorization_code;
//                sResponseDetails = response.response_description;
//                sApplicationFee = response.total_amount;
//                sLast4 = response.last_4;
//                strace_number = response.trace_number;

//                if (response.method_used == "echeck") {
//                    sExpMonth = "";
//                    sExpYear = "";
//                }
//                else {
//                    sExpMonth = response.expire_month;
//                    sExpYear = response.expire_year;
//                }

//                alert('transaction successful. TranxId - ' + response.trace_number);

//                SaveTransaction(creditType);

//                break;

//            case 'failure':

//                //handle failed transaction

//                alert('sorry, transaction failed. TranxId -  ' + response.trace_number);

//                isCheckoutSuccessful = false;
//                sResponseCode = response.response_code;
//                sResponseDetails = response.response_description;

//        }

//    }
//    else {
//        notify("danger", "Please fill out all mandatory fields !!");
//    }



//}

//$(document).on('keyup', '#rerountingnumapp1Txt', function (parameters) {
//    if ($("#routingnumapp1Txt").val() === $(this).val()) {
//        $("#rerountingnumapp1Txt").css({ "border": "1px solid Green" });
//    } else {
//        $("#rerountingnumapp1Txt").css({ "border": "1px solid red" });
//    }

//    var compName = $(this).val();
//    $(".btnPaymentGetway").attr("routing_number", compName);
//});

//$(document).on('keyup', '#recheckacctnumapp1Txt', function (parameters) {
//    if ($("#checkacctnumapp1Txt").val() === $(this).val()) {
//        $("#recheckacctnumapp1Txt").css({ "border": "1px solid Green" });
//    } else {
//        $("#recheckacctnumapp1Txt").css({ "border": "1px solid red" });
//    }

//    var compName = $(this).val();
//    $(".btnPaymentGetway").attr("account_number", compName);
//    $(".btnPaymentGetway").attr("account_number2", compName);
//});

//$(document).on('click', '#btnExit', function (parameters) {
//    var origin = window.location.origin;
//    window.location.href = origin + "/home";
//});

//$(document).on("keyup", "#creditcardapp1Txt", function (parameters) {

//    var compName = $(this).val();
//    if (compName.length >= 15) {
//        $(".btnPaymentGetway").attr("card_number", compName);
//    }

//});

//$(document).on("keyup", "#txtExpire", function (parameters) {

//    var compName = $(this).val();
//    $(".btnPaymentGetway").attr("expire", compName);
//});
//$(document).on("keyup", "#cvsNumber", function (parameters) {

//    var compName = $(this).val();
//    $(".btnPaymentGetway").attr("cvv", compName);
//});
//$(document).on("keyup", "#nameAccountapp1Txt", function (parameters) {

//    var compName = $(this).val();
//    $(".btnPaymentGetway").attr("billing_name", compName);
//});
//$(document).on("keyup", "#addressapp1Txt1", function (parameters) {

//    var compName = $(this).val();
//    $(".btnPaymentGetway").attr("billing_street_line1", compName);
//});
//$(document).on("keyup", "#cityapp1Txt", function (parameters) {

//    var compName = $(this).val();
//    $(".btnPaymentGetway").attr("billing_locality", compName);
//});
//$(document).on("change", "#ddlstateapp", function (parameters) {

//    var compName = $("#ddlstateapp").val();
//    $(".btnPaymentGetway").attr("billing_region", compName);
//});
//$(document).on("keyup", "#zipcodeapp1Txt", function (parameters) {

//    var compName = $(this).val();
//    $(".btnPaymentGetway").attr("billing_postal_code", compName);
//});
//$(document).on("keyup", "#routingnumapp1Txt", function (parameters) {

//    var compName = $(this).val();
//    $(".btnPaymentGetway").attr("routing_number", compName);
//});
//$(document).on("keyup", "#checkacctnumapp1Txt", function (parameters) {

//    var compName = $(this).val();
//    $(".btnPaymentGetway").attr("account_number", compName);
//    $(".btnPaymentGetway").attr("account_number2", compName);
//});
//$(document).on('click', '#chkStorage', function () {

//    if ($("#chkStorage").is(':checked')) {
//        $("#IsStorageDisplay").show();
//    } else {
//        $("#IsStorageDisplay").hide();
//    }

//    var period = $("#ddlPeriod").val();


//    var nMonthFees = parseFloat($("#TotalMonthlyCharge").text()).toFixed(2);
//    var nYearFees = parseFloat(nMonthFees * 12).toFixed(2);

//    var nStorageCharge = 0;


//    if ($("#chkStorage").is(':checked')) {

//        if (period != '' && period != 'undefined') {
//            if (period == "Y") {
//                if (nYearFees > 0) {
//                    nStorageCharge = nYearFees;
//                }
//            }
//            else {
//                if (nMonthFees > 0) {
//                    nStorageCharge = nMonthFees;
//                }
//            }

//            if (nStorageCharge > 0) {
//                $("#storageCharge").text(parseFloat(nStorageCharge).toFixed(2).toString());
//            }
//            else {
//                $("#storageCharge").text("0.00");
//            }
//        }
//        else {
//            $("#storageCharge").text("0.00");
//        }
//    }
//    else {
//        $("#storageCharge").text("0.00");
//    }

//    var nPlanCharge = 0;
//    var nDiscount = 0;
//    var nDiscountRate = parseFloat($("#percentRatio").text()).toFixed(2);
//    var nSubTotal = 0;
//    var nTotal = 0;


//    var Plan = $("input[name=plan]:checked").val();

//    if (Plan == 'Basic') {
//        if (period != '' && period != 'undefined') {
//            if (period == "Y") {
//                nPlanCharge = 11.88;
//            }
//            else {
//                nPlanCharge = 11.88;
//            }
//        }
//        else {
//            nPlanCharge = 11.88;
//        }

//    }
//    else if (Plan == 'Silver') {
//        if (period != '' && period != 'undefined') {
//            if (period == "Y") {
//                nPlanCharge = 54.00;
//            }
//            else {
//                nPlanCharge = 4.99;
//            }
//        }
//        else {
//            nPlanCharge = 4.99;
//        }

//    }
//    else if (Plan == 'Gold') {
//        if (period != '' && period != 'undefined') {
//            if (period == "Y") {
//                nPlanCharge = 110.00;
//            }
//            else {
//                nPlanCharge = 9.99;
//            }
//        }
//        else {
//            nPlanCharge = 9.99;
//        }
//    }
//    else {

//        if (period != '' && period != 'undefined') {
//            if (period == "Y") {
//                nPlanCharge = 11.88;
//            }
//            else {
//                nPlanCharge = 11.88;
//            }
//        }
//        else {
//            nPlanCharge = 11.88;
//        }
//    }

//    nSubTotal = parseFloat(nPlanCharge) + parseFloat(nStorageCharge);
//    nSubTotal = parseFloat(nSubTotal).toFixed(2);

//    if (nSubTotal > 0 && nDiscountRate > 0) {
//        nDiscount = nSubTotal * nDiscountRate / 100;
//        nDiscount = parseFloat(nDiscount).toFixed(2);

//        nTotal = nSubTotal - nDiscount;
//        nTotal = parseFloat(nTotal).toFixed(2);
//    }

//    $("#PlanCharge").text(parseFloat(nPlanCharge).toFixed(2).toString());

//    if (nSubTotal > 0) {
//        $("#subTotalCharge").text(parseFloat(nSubTotal).toFixed(2).toString());
//    }
//    else {
//        $("#subTotalCharge").text(parseFloat(nPlanCharge).toFixed(2).toString());
//    }

//    if (nDiscount > 0) {
//        $("#Discount").text(parseFloat(nDiscount).toFixed(2).toString());
//    }
//    else {
//        $("#Discount").text("0.00");
//    }

//    if (nTotal > 0) {
//        $("#TotalAmountCharge").text(parseFloat(nTotal).toFixed(2).toString());
//        $("#TotalAmountChargeRe").val(parseFloat(nTotal).toFixed(2).toString());
//    }
//    else {
//        if (nSubTotal > 0) {
//            $("#TotalAmountCharge").text(parseFloat(nSubTotal).toFixed(2).toString());
//            $("#TotalAmountChargeRe").val(parseFloat(nSubTotal).toFixed(2).toString());
//        }
//        else {
//            $("#TotalAmountCharge").text(parseFloat(nPlanCharge).toFixed(2).toString());
//            $("#TotalAmountChargeRe").val(parseFloat(nPlanCharge).toFixed(2).toString());
//        }
//    }

//    var TotalAmountChargeRe = $("#TotalAmountChargeRe").val();
//   // $("#btnSubmit").attr("total_amount", TotalAmountChargeRe);
    
   

//});
//function clearAllPaymentField() {
//    $(".btnPaymentGetway").attr("billing_company_name", "");
//    $(".btnPaymentGetway").attr("card_number", "");
//    $(".btnPaymentGetway").attr("expire", "");
//    $(".btnPaymentGetway").attr("cvv", "");
//    $(".btnPaymentGetway").attr("billing_name", "");
//    $(".btnPaymentGetway").attr("billing_street_line1", "");
//    $(".btnPaymentGetway").attr("billing_locality", "");
//    $(".btnPaymentGetway").attr("billing_region", "");
//    $(".btnPaymentGetway").attr("billing_postal_code", "");
//    $(".btnPaymentGetway").attr("routing_number", "");
//    $(".btnPaymentGetway").attr("account_number", "");
//    $(".btnPaymentGetway").attr("account_number2", "");
//    $(".btnPaymentGetway").attr("allowed_methods", "visa, mast, disc, amex, dine, jcb, echeck");
//}
//$(document).on('keyup', '#ContactMultiplier', function (parameters) {
//    var nTotal = $("#ContactMultiplier").val();

//    if (nTotal === "undefined" || nTotal === "") {
//        $("#ContactMultiplier").css({ 'border': '1px solid red' });
//    }
//    else {
//        var nCount = parseInt($("#ContactMultiplier").val());
//        if (nCount >= 0) {
//            $("#ContactMultiplier2").text(nCount.toString());

//            var nContact = $("#NoOfContact2").text();
//            var nTotalContact = nContact * nCount;

//            $("#TotalContact").text(nTotalContact.toString());

//            var nContactLimit = parseInt($("#NoOfContact").text()) + parseInt(nTotalContact);

//            $("#hdStorageLimit").val(nContactLimit.toString());

//            var nRate = parseFloat($("#PerMonthCharge").text()).toFixed(2);
//            var nMonthFees = parseFloat(nCount * nRate).toFixed(2);
//            var nYearFees = parseFloat(nCount * nRate * 12).toFixed(2);

//            if (nMonthFees > 0) {
//                $("#TotalMonthlyCharge").text(parseFloat(nMonthFees).toFixed(2).toString());
//            }
//            else {
//                $("#TotalMonthlyCharge").text("0.00");
//            }

//            var nStorageCharge = 0;


//            if ($("#chkStorage").is(':checked')) {
//                var period = $("#ddlPeriod").val();

//                if (period != '' && period != 'undefined') {
//                    if (period == "Y") {
//                        if (nYearFees > 0) {
//                            nStorageCharge = parseFloat(nYearFees).toFixed(2);
//                        }
//                    }
//                    else {
//                        if (nMonthFees > 0) {
//                            nStorageCharge = parseFloat(nMonthFees).toFixed(2);
//                        }
//                    }

//                    if (nStorageCharge > 0) {
//                        $("#storageCharge").text(nStorageCharge.toString());
//                    }
//                    else {
//                        $("#storageCharge").text("0.00");
//                    }
//                }
//                else {
//                    $("#storageCharge").text("0.00");
//                }
//            }
//            else {
//                $("#storageCharge").text("0.00");
//            }

//            var nPlanCharge = parseFloat($("#PlanCharge").text()).toFixed(2);
//            var nDiscount = 0;
//            var nDiscountRate = parseFloat($("#percentRatio").text()).toFixed(2);
//            var nSubTotal = 0;
//            var nTotal = 0;

//            nSubTotal = parseFloat(nPlanCharge) + parseFloat(nStorageCharge);
//            nSubTotal = parseFloat(nSubTotal).toFixed(2);
//            if (nSubTotal > 0 && nDiscountRate > 0) {
//                nDiscount = parseFloat(nSubTotal) * parseFloat(nDiscountRate) / 100;
//                nDiscount = parseFloat(nDiscount).toFixed(2);

//                nTotal = parseFloat(nSubTotal) - parseFloat(nDiscount);
//                nTotal = parseFloat(nTotal).toFixed(2);
//            }

//            $("#PlanCharge").text(parseFloat(nPlanCharge).toFixed(2).toString());

//            if (nSubTotal > 0) {
//                $("#subTotalCharge").text(parseFloat(nSubTotal).toFixed(2).toString());
//            }
//            else {
//                $("#subTotalCharge").text(parseFloat(nPlanCharge).toFixed(2).toString());
//            }

//            if (nDiscount > 0) {
//                $("#Discount").text(parseFloat(nDiscount).toFixed(2).toString());
//            }
//            else {
//                $("#Discount").text("0.00");
//            }

//            if (nTotal > 0) {
//                $("#TotalAmountCharge").text(parseFloat(nTotal).toFixed(2).toString());
//                $("#TotalAmountChargeRe").val(parseFloat(nTotal).toFixed(2).toString());
//                //var twoPlacedFloat = parseFloat(nTotal).toFixed(2)
//                //$(".btnPaymentGetway").attr("total_amount", twoPlacedFloat);
//            }
//            else {
//                if (nSubTotal > 0) {
//                    $("#TotalAmountCharge").text(parseFloat(nSubTotal).toFixed(2).toString());
//                    $("#TotalAmountChargeRe").val(parseFloat(nSubTotal).toFixed(2).toString());
//                    //var twoPlacedFloat = parseFloat(nSubTotal).toFixed(2)
//                    //$(".btnPaymentGetway").attr("total_amount", twoPlacedFloat);
//                }
//                else {
//                    $("#TotalAmountCharge").text(parseFloat(nPlanCharge).toFixed(2).toString());
//                    $("#TotalAmountChargeRe").val(parseFloat(nPlanCharge).toFixed(2).toString());
//                    //var twoPlacedFloat = parseFloat(nPlanCharge).toFixed(2)
//                    //$(".btnPaymentGetway").attr("total_amount", twoPlacedFloat);
//                }
//            }

//        }
//    }

//    var TotalAmountChargeRe = $("#TotalAmountChargeRe").val();
//   // $("#btnSubmit").attr("total_amount", TotalAmountChargeRe);
   
//});
//$(document).on('change', '#ddlPeriod', function (parameters) {

//    if ($(this).val() != '' && $(this).val() != 'undefined') {
//        var period = $("#ddlPeriod").val();


//        var nMonthFees = parseFloat($("#TotalMonthlyCharge").text()).toFixed(2);
//        var nYearFees = parseFloat(nMonthFees * 12).toFixed(2);

//        var nStorageCharge = 0;


//        if ($("#chkStorage").is(':checked')) {

//            if (period != '' && period != 'undefined') {
//                if (period == "Y") {
//                    if (nYearFees > 0) {
//                        nStorageCharge = nYearFees;
//                    }
//                }
//                else {
//                    if (nMonthFees > 0) {
//                        nStorageCharge = nMonthFees;
//                    }
//                }

//                if (nStorageCharge > 0) {
//                    $("#storageCharge").text(parseFloat(nStorageCharge).toFixed(2).toString());
//                }
//                else {
//                    $("#storageCharge").text("0.00");
//                }
//            }
//            else {
//                $("#storageCharge").text("0.00");
//            }
//        }
//        else {
//            $("#storageCharge").text("0.00");
//        }

//        var nPlanCharge = 0;
//        var nDiscount = 0;
//        var nDiscountRate = parseFloat($("#percentRatio").text()).toFixed(2);
//        var nSubTotal = 0;
//        var nTotal = 0;


//        var Plan = $("input[name=plan]:checked").val();

//        if (Plan == 'Basic') {
//            if (period != '' && period != 'undefined') {
//                if (period == "Y") {
//                    nPlanCharge = 11.88;
//                }
//                else {
//                    nPlanCharge = 11.88;
//                }
//            }
//            else {
//                nPlanCharge = 11.88;
//            }

//        }
//        else if (Plan == 'Silver') {
//            if (period != '' && period != 'undefined') {
//                if (period == "Y") {
//                    nPlanCharge = 54.00;
//                }
//                else {
//                    nPlanCharge = 4.99;
//                }
//            }
//            else {
//                nPlanCharge = 4.99;
//            }

//        }
//        else if (Plan == 'Gold') {
//            if (period != '' && period != 'undefined') {
//                if (period == "Y") {
//                    nPlanCharge = 110.00;
//                }
//                else {
//                    nPlanCharge = 9.99;
//                }
//            }
//            else {
//                nPlanCharge = 9.99;
//            }
//        }
//        else {

//            if (period != '' && period != 'undefined') {
//                if (period == "Y") {
//                    nPlanCharge = 11.88;
//                }
//                else {
//                    nPlanCharge = 11.88;
//                }
//            }
//            else {
//                nPlanCharge = 11.88;
//            }
//        }

//        nSubTotal = parseFloat(nPlanCharge) + parseFloat(nStorageCharge);
//        nSubTotal = parseFloat(nSubTotal).toFixed(2);
//        if (nSubTotal > 0 && nDiscountRate > 0) {
//            nDiscount = parseFloat(nSubTotal) * parseFloat(nDiscountRate) / 100;
//            nDiscount = parseFloat(nDiscount).toFixed(2);

//            nTotal = parseFloat(nSubTotal) - parseFloat(nDiscount);
//            nTotal = parseFloat(nTotal).toFixed(2);
//        }

//        $("#PlanCharge").text(parseFloat(nPlanCharge).toFixed(2).toString());

//        if (nSubTotal > 0) {
//            $("#subTotalCharge").text(parseFloat(nSubTotal).toFixed(2).toString());
//        }
//        else {
//            $("#subTotalCharge").text(parseFloat(nPlanCharge).toFixed(2).toString());
//        }

//        if (nDiscount > 0) {
//            $("#Discount").text(parseFloat(nDiscount).toFixed(2).toString());
//        }
//        else {
//            $("#Discount").text("0.00");
//        }

//        if (nTotal > 0) {
//            $("#TotalAmountCharge").text(parseFloat(nTotal).toFixed(2).toString());
//            $("#TotalAmountChargeRe").val(parseFloat(nTotal).toFixed(2).toString());
//            //var twoPlacedFloat = parseFloat(nTotal).toFixed(2)
//            //$(".btnPaymentGetway").attr("total_amount", twoPlacedFloat);
//        }
//        else {
//            if (nSubTotal > 0) {
//                $("#TotalAmountCharge").text(parseFloat(nSubTotal).toFixed(2).toString());
//                $("#TotalAmountChargeRe").val(parseFloat(nSubTotal).toFixed(2).toString());
//                //var twoPlacedFloat = parseFloat(nSubTotal).toFixed(2)
//                //$(".btnPaymentGetway").attr("total_amount", twoPlacedFloat);
//            }
//            else {
//                $("#TotalAmountCharge").text(parseFloat(nPlanCharge).toFixed(2).toString());
//                $("#TotalAmountChargeRe").val(parseFloat(nPlanCharge).toFixed(2).toString());
//                //var twoPlacedFloat = parseFloat(nPlanCharge).toFixed(2)
//                //$(".btnPaymentGetway").attr("total_amount", twoPlacedFloat);
//            }
//        }

//    }

//    var TotalAmountChargeRe = $("#TotalAmountChargeRe").val();
//   // $("#btnSubmit").attr("total_amount", TotalAmountChargeRe);
   
//});
//$(document).on("keyup", "#groupcode", function (parameters) {

//    var code = $(this).val();
//    var Plan = $("input[name=plan]:checked").val();

//    var URL = currentPagePath + "RewardByGroupCode";

//    if (code != null || code != "") {

//        $.ajax({
//            type: "POST",
//            url: URL,
//            data: "{ 'code':'" + code + "' , 'Plan':'" + Plan + "'}",
//            contentType: "application/json; charset=utf-8",
//            dataType: "json",
//            error:
//                function (XMLHttpRequest, textStatus, errorThrown) {
//                    $("#Discount").text("0.00");
//                    $("#percentRatio").text("");
//                },
//            success:
//                function (result) {
//                    var rate = $.parseJSON(decodeURIComponent(result.d));
//                    if (rate == '' || rate == "") {
//                        $("#Discount").text("0.00");
//                        $("#percentRatio").text("");
//                    } else {

//                        if (rate != null) {
//                            var nDiscountRate = parseFloat(rate).toFixed(2);
//                            $("#percentRatio").text(nDiscountRate.toString());

//                            var nSubTotal = parseFloat($("#subTotalCharge").text()).toFixed(2);

//                            var nDiscount = 0;
//                            var nTotal = 0;

//                            if (nSubTotal > 0 && nDiscountRate > 0) {
//                                nDiscount = parseFloat(nSubTotal) * parseFloat(nDiscountRate) / 100;
//                                nDiscount = parseFloat(nDiscount).toFixed(2);

//                                nTotal = parseFloat(nSubTotal) - parseFloat(nDiscount);
//                                nTotal = parseFloat(nTotal).toFixed(2);
//                            }


//                            if (nDiscount > 0) {
//                                $("#Discount").text(parseFloat(nDiscount).toFixed(2).toString());
//                            }
//                            else {
//                                $("#Discount").text("0.00");
//                            }

//                            if (nTotal > 0) {
//                                $("#TotalAmountCharge").text(parseFloat(nTotal).toFixed(2).toString());
//                                $("#TotalAmountChargeRe").val(parseFloat(nTotal).toFixed(2).toString());
//                                //var twoPlacedFloat = parseFloat(nTotal).toFixed(2)
//                                //$(".btnPaymentGetway").attr("total_amount", twoPlacedFloat);
//                            }
//                            else {
//                                if (nSubTotal > 0) {
//                                    $("#TotalAmountCharge").text(parseFloat(nSubTotal).toFixed(2).toString());
//                                    $("#TotalAmountChargeRe").val(parseFloat(nSubTotal).toFixed(2).toString());
//                                    //var twoPlacedFloat = parseFloat(nSubTotal).toFixed(2)
//                                    //$(".btnPaymentGetway").attr("total_amount", twoPlacedFloat);
//                                }

//                            }

//                        }
//                    }
//                }

//        });


//    }

//    var TotalAmountChargeRe = $("#TotalAmountChargeRe").val();
//   // $("#btnSubmit").attr("total_amount", TotalAmountChargeRe);
   
//});
//function clearPaymentField() {
//    $(".btnPaymentGetway").attr("card_number", "");
//    $(".btnPaymentGetway").attr("expire", "");
//    $(".btnPaymentGetway").attr("cvv", "");
//    $(".btnPaymentGetway").attr("routing_number", "");
//    $(".btnPaymentGetway").attr("account_number", "");
//    $(".btnPaymentGetway").attr("account_number2", "");
//    $(".btnPaymentGetway").attr("allowed_methods", "visa, mast, disc, amex, dine, jcb, echeck");

//    $("#routingnumapp1Txt").val("");
//    $("#rerountingnumapp1Txt").val("");
//    $("#checkacctnumapp1Txt").val("");
//    $("#recheckacctnumapp1Txt").val("");

//    $("#creditcardapp1Txt").val("");
//    $("#cvsNumber").val("");
//    $("#txtExpire").val("");
//    $("#hdPaymentId").val("0");
//    $("#btnAdd").val("Add");

//    $("#nameAccountapp1Txt").attr('data-PaymentInformationID', '');

//}
//$(document).on('click', '.btnDelete', function () {
   
//    var PaymentInformationID = $(this).attr('data-PaymentInformationID');
//    var URL = currentPagePath + "DeletePaymentInformationById";

//    if (PaymentInformationID != null || PaymentInformationID != "") {
//        var obj = {
//            "id": PaymentInformationID
//        };

//        if (showconfirm()) {
//            $.ajax({
//                type: "POST",
//                url: URL,
//                data: "{ 'id':'" + PaymentInformationID + "'}",
//                contentType: "application/json; charset=utf-8",
//                dataType: "json",
//                error:
//                    function (XMLHttpRequest, textStatus, errorThrown) {

//                    },
//                success:
//                    function (data) {
//                        var result = $.parseJSON(decodeURIComponentSafe(data.d));
//                        if (result == '' || result == "") {
//                            notify('danger', 'delete failed !!');
//                        }
//                        else {
//                            if (result != null) {
//                                if (result == true) {
//                                    LoadAllPaymentInformation();

//                                    notify('success', "Account deleted successfully");
//                                }
//                                else {
//                                    notify('danger', 'delete failed !!');
//                                }
//                            }
//                            else {
//                                notify('danger', 'delete failed !!');
//                            }
//                        }
//                    }

//            });

//            //let GetData = makeAjaxCallReturnPromiss(URL, obj);
//            //GetData.then((data) => {
//            //    let result = $.parseJSON(decodeURIComponent(data.d));
//            //    if (result != null) {
//            //        if (result == 'true') {
//            //            LoadAllPaymentInformation();
//            //        }
//            //        else {
//            //            notify('danger', 'delete failed !!');
//            //        }

//            //    }
//            //    else {
//            //        notify('danger', 'delete failed !!');
//            //    }
//            //});
//        }
//    }

//});
//$(document).on('click', '#btnClear', function () {
//    clearPaymentField();
//});
//$(document).on('click', "input[type=radio][name=card]", function (parameters) {

//    if ($(this).attr('id') == 'Checking') {

//        $("#tblCheck").css({ 'display': 'block' });
//        $("#tblCredit").css({ 'display': 'none' });
//        $("#tblCredit tbody").css({ 'width': '100% !important' });

//        if (bShow === "false") {
//            $("#btnSubmit").css({ 'display': 'none' });
//        }
//        else {
//            $("#btnSubmit").css({ 'display': 'block' });
//        }
//    }
//    else {
//        $("#tblCredit").css({ 'display': 'block' });
//        $("#tblCredit tbody").css({ 'width': '100% !important' });
//        $("#tblCheck").css({ 'display': 'none' });
//        if (bShow === "false") {
//            $("#btnSubmit").css({ 'display': 'none' });
//        }
//        else {
//            $("#btnSubmit").css({ 'display': 'block' });
//        }

//    }
//    var card = $("input[name=card]:checked").val();
//    var res = "";
//    if (card == 'Check') {
//        res = "echeck";
//        cardType = "Check";
//        clearAllPaymentField();
//    }
//    else {
//        res = "visa, mast, disc, amex, dine, jcb";
//        cardType = "Card";
//        clearAllPaymentField();
//    }


//    $(".btnPaymentGetway").attr("allowed_methods", res);

//});
//$(document).on('click', "input[type=radio][name=plan]", function (parameters) {
   
//    LoadDropdownlist();
//    $("#chkStorage").prop("checked", false);
//    $("#ContactMultiplier").val("1");
//    $("#ContactMultiplier2").val("1");
//    var Plan = $("input[name=plan]:checked").val();
//    if (Plan == 'Basic') {

//        $("#chkStorageDisplay").show();
//        $("#IsStorageDisplay").hide();

//        $("#NoOfContact").text("500");
//        $("#NoOfContact2").text("500");
//        $("#TotalContact").text("500");

//        $("#PerMonthCharge").text("1.00");
//        $("#TotalMonthlyCharge").text("1.00");

//        $("#PlanCharge").text("11.88");
//        $("#storageCharge").text("0.00");
//        $("#subTotalCharge").text("11.88");
//        $("#Discount").text("0.00");
//        $("#TotalAmountCharge").text("11.88");
//        $("#TotalAmountChargeRe").val("11.88");
//        $("#percentRatio").text("");
//        $("#groupcode").val("");

//        $("#hdMTDImportLimit").val("10");
//        $("#hdYTDExportLimit").val("250");
//        $("#hdStorageLimit").val("500");

//        //  $(".btnPaymentGetway").attr("total_amount", "11.88");
//    }
//    else if (Plan == 'Silver') {

//        $("#chkStorageDisplay").show();
//        $("#IsStorageDisplay").hide();

//        $("#NoOfContact").text("10000");
//        $("#NoOfContact2").text("10000");
//        $("#TotalContact").text("10000");

//        $("#PerMonthCharge").text("3.99");
//        $("#TotalMonthlyCharge").text("3.99");
//        $("#PlanCharge").text("54.00");
//        $("#storageCharge").text("0.00");
//        $("#subTotalCharge").text("54.00");
//        $("#Discount").text("0.00");
//        $("#TotalAmountCharge").text("54.00");
//        $("#TotalAmountChargeRe").val("54.00");
//        $("#percentRatio").text("");
//        $("#groupcode").val("");

//        $("#hdMTDImportLimit").val("50");
//        $("#hdYTDExportLimit").val("500");
//        $("#hdStorageLimit").val("10000");

//        //  $(".btnPaymentGetway").attr("total_amount", "54.00");
//    }
//    else if (Plan == 'Gold') {

//        $("#chkStorageDisplay").hide();
//        $("#IsStorageDisplay").hide();

//        $("#NoOfContact").text("");
//        $("#NoOfContact2").text("");
//        $("#TotalContact").text("");

//        $("#PerMonthCharge").text("0.00");
//        $("#TotalMonthlyCharge").text("0.00");
//        $("#PlanCharge").text("110.00");
//        $("#storageCharge").text("0.00");
//        $("#subTotalCharge").text("110.00");
//        $("#Discount").text("0.00");
//        $("#TotalAmountCharge").text("110.00");
//        $("#TotalAmountChargeRe").val("110.00");
//        $("#percentRatio").text("");
//        $("#groupcode").val("");

//        $("#hdMTDImportLimit").val("unlimited");
//        $("#hdYTDExportLimit").val("unlimited");
//        $("#hdStorageLimit").val("unlimited");

//        //  $(".btnPaymentGetway").attr("total_amount", "110.00");
//    }
//    else {

//        $("#chkStorageDisplay").show();
//        $("#IsStorageDisplay").hide();

//        $("#NoOfContact").text("500");
//        $("#NoOfContact2").text("500");
//        $("#TotalContact").text("500");

//        $("#PerMonthCharge").text("1.00");
//        $("#TotalMonthlyCharge").text("1.00");
//        $("#PlanCharge").text("11.88");
//        $("#storageCharge").text("0.00");
//        $("#subTotalCharge").text("11.88");
//        $("#Discount").text("0.00");
//        $("#TotalAmountCharge").text("11.88");
//        $("#TotalAmountChargeRe").val("11.88");
//        $("#percentRatio").text("");

//        $("#groupcode").val("");
//        $("#hdMTDImportLimit").val("10");
//        $("#hdYTDExportLimit").val("250");
//        $("#hdStorageLimit").val("500");
//        // $(".btnPaymentGetway").attr("total_amount", "11.88");
//    }
//    var TotalAmountChargeRe = $("#TotalAmountCharge").text();
//   // $("#btnSubmit").attr("total_amount", TotalAmountChargeRe);
//    //$(".btnPaymentGetway").attr("total_amount", TotalAmountChargeRe);
//    //var URL = currentPagePath + "GetTotalAmount";

//    //if (TotalAmountChargeRe != null || TotalAmountChargeRe != "") {
       

//    //    $.ajax({
//    //        type: "POST",
//    //        url: URL,
//    //        data: "{ 'id':'" + TotalAmountChargeRe + "'}",
//    //        contentType: "application/json; charset=utf-8",
//    //        dataType: "json",
//    //        error:
//    //            function (XMLHttpRequest, textStatus, errorThrown) {
                    
//    //            },
//    //        success:
//    //            function (result) {
//    //                var rate = $.parseJSON(decodeURIComponent(result.d));
//    //                if (rate == '' || rate == "") {
                       
//    //                } else {
//    //                    if (rate != null) {
//    //                        alert(rate);
//    //                    }
//    //                }
//    //            }

//    //    });
//    //}

//});
//function LoadAllPaymentInformation() {

//    var URL = currentPagePath + "GetPaymentInformationData";
//    var Obj = {}
//    let GetData = makeAjaxCallReturnPromiss(URL, Obj);
//    GetData.then((data) => {

//        let result = $.parseJSON(decodeURIComponentSafe(data.d));
//        if (result != null) {
//            BindPaymentInformationData(result);
//        }

//    }).catch((err) => {
//        console.log(err);
//    });

//};
//function BindPaymentInformationData(result) {

//    var content = " ";
//    if (result.length > 0) {
//        $.each(result, function (i, obj) {


//            content += '<tr>'
//            content += '<td>' + obj.AccountName + '</td>'
//            content += '<td>' + obj.LastFourDigitCard + '</td>'
//            content += '<td>' + obj.AccountNo + '</td>'
//            content += '<td>' + obj.RoutingNo + '</td>'
//            content += '<td> <button class="btnUpdate btn" style="background-color:#3B5998;color:white" data-PaymentInformationID=' + obj.Id + ' type = "button"> Edit </button> <button class="btnDelete btn" style = "background-color:red;color:white" data-PaymentInformationID=' + obj.Id + ' type = "button"> Delete </button></td>'

//            content += '</tr>';
//        })


//        $('#tblAccount tbody').empty();
//        $('#tblAccount tbody').append(content);

//        $('#tblAccount').DataTable();
//    }

//}
//$(document).on('click', '#btnAdd', function () {
   
//    var creditType = $('input[name=card]:checked').val();
//    var validate = true;

//    if (creditType == 'Credit') {
//        validate = ValidateCredit();
//    }
//    else if (creditType == 'Check') {
//        validate = ValidateCheck();
//    }
//    else {
//        if (creditType === "undefined" || creditType === "") {
//            validate = false;
//        }
//    }

//    if (validate == true) {
//        var URL = currentPagePath + "SavePaymentInformation";
//        var Obj = getMyData(creditType);
//        if (Obj != null) {
//            $.ajax({
//                type: "POST",
//                url: URL,
//                data: JSON.stringify({ "Obj": Obj }),
//                contentType: "application/json; charset=utf-8",
//                dataType: "json",
//                error:
//                    function (XMLHttpRequest, textStatus, errorThrown) {

//                    },
//                success:
//                    function (data) {
//                        var result = $.parseJSON(decodeURIComponentSafe(data.d));
//                        if (result == '' || result == "") {
//                            notify('danger', "Account Data Add Failed !!");
//                        }
//                        else {
//                            if (result != null) {
//                                if (result == true) {
//                                    LoadAllPaymentInformation();

//                                    var saveOrUpdate = $("#btnAdd").val();
//                                    if (saveOrUpdate == 'Update') {
//                                        notify('success', "Account Updated successfully");
//                                    } else {
//                                        notify('success', "Account Added successfully");
//                                    }

//                                    $("#btnAdd").val("Add");
//                                }
//                                else {
//                                    notify('danger', "Account Data Add Failed !!");
//                                }
//                            }
//                            else {
//                                notify('danger', "Account Data Add Failed !!");
//                            }
//                        }
//                    }

//            });

//            //let GetData = makeAjaxCallReturnPromiss(URL, Obj);
//            //GetData.then((data) => {

//            //    let result = $.parseJSON(decodeURIComponent(data.d));
//            //    if (result == true) {
//            //        LoadAllPaymentInformation();

//            //        var saveOrUpdate = $("#btnAdd").val();
//            //        if (saveOrUpdate == 'Update') {
//            //            notify('success', "Account Updated successfully");
//            //        } else {
//            //            notify('success', "Account Added successfully");
//            //        }

//            //        $("#btnAdd").val("Add");
//            //    }
//            //    else {
//            //        notify('danger', "Account Data Add Failed !!");
//            //    }
//            //});
//        }
//        else {
//            notify('danger', "No Account Data!!");
//        }
//    }
//    else {
//        notify("danger", "Please fill out all mandatory fields !!");
//    }

//});

//function getMyData(creditType) {
//    var nId = 0;
//    //var nPaymentInformationId = $("#nameAccountapp1Txt").attr('data-PaymentInformationID');
//    var nPaymentInformationId = $("#hdPaymentId").val();
//    if (nPaymentInformationId != null || nPaymentInformationId != "") {
//        nId = parseInt(nPaymentInformationId);
//    }

//    var obj = {};

//    if (creditType == 'Credit') {
//        var sExpire = $("#txtExpire").val();
//        var sMonth = sExpire.split('/')[0];
//        var sYear = sExpire.split('/')[1];

//        var sLast = $("#creditcardapp1Txt").val();
//        if (sLast.length > 3) {
//            sLast = sLast.substr(-4, 4);
//        }

//        obj = {
//            "Id": parseInt(nId),
//            "AccountName": $("#nameAccountapp1Txt").val().trim(),
//            "Address": $("#addressapp1Txt1").val(),
//            "Address1": '',
//            "City": $("#cityapp1Txt").val(),
//            "State": $("#ddlstateapp").val(),
//            "Zip": $("#zipcodeapp1Txt").val(),
//            "CardNumber": $("#creditcardapp1Txt").val(),
//            "CVS": $("#cvsNumber").val(),
//            "Month": sMonth,
//            "Year": sYear,
//            "LastFourDigitCard": sLast,
//            "IsCheckingAccount": false,
//            "RoutingNo": '',
//            "AccountNo": '',
//            "CheckNo": '',
//            "IsRecurring": $("#chkRecurring").is(':checked') == true ? true : false,
//            "IsAgree": $("#chkAgree").is(':checked') == true ? true : false
//        }
//    }
//    else if (creditType == 'Check') {
//        var sLast = $("#checkacctnumapp1Txt").val();
//        if (sLast.length > 3) {
//            sLast = sLast.substr(-4, 4);
//        }
//        obj = {
//            "Id": parseInt(nId),
//            "AccountName": $("#nameAccountapp1Txt").val().trim(),
//            "Address": $("#addressapp1Txt1").val(),
//            "Address1": '',
//            "City": $("#cityapp1Txt").val(),
//            "State": $("#ddlstateapp").val(),
//            "Zip": $("#zipcodeapp1Txt").val(),
//            "CardNumber": '',
//            "CVS": '',
//            "Month": '',
//            "Year": '',
//            "LastFourDigitCard": sLast,
//            "IsCheckingAccount": true,
//            "RoutingNo": $("#routingnumapp1Txt").val(),
//            "AccountNo": $("#checkacctnumapp1Txt").val(),
//            "CheckNo": '',
//            "IsRecurring": $("#chkRecurring").is(':checked') == true ? true : false,
//            "IsAgree": $("#chkAgree").is(':checked') == true ? true : false
//        }
//    }


//    return obj;
//}

//$(document).on('click', '.btnUpdate', function () {

//    var PaymentInformationID = $(this).attr('data-PaymentInformationID');
//    var URL = currentPagePath + "GetPaymentInformationById";

//    if (PaymentInformationID != null || PaymentInformationID != "") {
//        $.ajax({
//            type: "POST",
//            url: URL,
//            data: "{ 'id':'" + PaymentInformationID + "'}",
//            contentType: "application/json; charset=utf-8",
//            dataType: "json",
//            error:
//                function (XMLHttpRequest, textStatus, errorThrown) {

//                },
//            success:
//                function (data) {
//                    var result = $.parseJSON(decodeURIComponent(data.d));
//                    if (result == '' || result == "") {

//                    }
//                    else {
//                        if (result != null) {
//                            BindPaymentInformation(result);
//                        }
//                    }
//                }

//        });
//    }

//});

//function BindPaymentInformation(result) {

//    $("#nameAccountapp1Txt").val(result.AccountName);
//    $("#nameAccountapp1Txt").attr('data-PaymentInformationID', result.Id);
//    $("#addressapp1Txt1").val(result.Address);
//    $("#cityapp1Txt").val(result.City);
//    $("#ddlstateapp").val(result.State).trigger('change');
//    $("#zipcodeapp1Txt").val(result.Zip);

//    if (result.IsCheckingAccount == true) {
//        $("input[name=card][value='Check']").prop("checked", true);
//        $("#routingnumapp1Txt").val(result.RoutingNo);
//        $("#checkacctnumapp1Txt").val(result.AccountNo);
//        $("#rerountingnumapp1Txt").val(result.RoutingNo);
//        $("#recheckacctnumapp1Txt").val(result.AccountNo);

//        $("#tblCheck").css({ 'display': 'block' });
//        $("#tblCredit").css({ 'display': 'none' });

//        $(".btnPaymentGetway").attr("allowed_methods", "echeck");
//    }
//    else {
//        $("input[name=card][value='Credit']").prop("checked", true);
//        $("#creditcardapp1Txt").val(result.CardNumber);
//        $("#cvsNumber").val(result.CVS);
//        var sExp = result.Month.toString() + "/" + result.Year.toString();
//        $("#txtExpire").val(sExp);
//        $("#tblCheck").css({ 'display': 'none' });
//        $("#tblCredit").css({ 'display': 'block' });
//        $(".btnPaymentGetway").attr("allowed_methods", "visa, mast, disc, amex, dine, jcb");
//    }


//    $("#btnAdd").val("Update");
//    $("#hdPaymentId").val(result.Id);

//    //if (result.IsRecurring == true) {
//    //    $("#chkRecurring").prop("checked", true);
//    //}

//    //else {
//    //    $("#chkRecurring").prop("checked", false);
//    //}

//    //if (result.IsAgree == true) {
//    //    $("#chkAgree").prop("checked", true);
//    //}

//    //else {
//    //    $("#chkAgree").prop("checked", false);
//    //}
//}

//function LoadBillingInformation() {

//    var URL = currentPagePath + "GetBillingInformationData";
//    var Obj = {}
//    let GetData = makeAjaxCallReturnPromiss(URL, Obj);
//    GetData.then((data) => {

//        let result = $.parseJSON(decodeURIComponentSafe(data.d));
//        if (result != null) {
//            BindBillingInformation(result);
//        }

//    }).catch((err) => {
//        console.log(err);
//    });

//};

//function BindBillingInformation(result) {
//    if (result == null || result == "") {

//    }
//    else {
//        $("#hdId").val(result.Id);

//        var Plan = result.GroupPlan;
//        $("input[name=plan][value='" + Plan + "']").prop("checked", true);

//        if (result.IsBillingCycleMonthly == true) {
//            $("#ddlPeriod").val("M").trigger('change');
//        }
//        else {
//            $("#ddlPeriod").val("Y").trigger('change');
//        }

//        if (result.IsReceivedCommissions == true) {
//            $("#chkReceive").prop("checked", true);
//        }
//        else {
//            $("#chkReceive").prop("checked", false);
//        }

//        if (result.IsRecurring == true) {
//            $("#chkRecurring").prop("checked", true);
//        }
//        else {
//            $("#chkRecurring").prop("checked", false);
//        }

//        if (result.IsAgree == true) {
//            $("#chkAgree").prop("checked", true);
//        }
//        else {
//            $("#chkAgree").prop("checked", false);
//        }

//        $("#NoOfContact").text(result.NoOfContact);
//        $("#NoOfContact2").text(result.NoOfContact);
//        $("#ContactMultiplier").val(result.ContactMultiplier);
//        $("#TotalContact").text(result.TotalContact);

//        $("#PerMonthCharge").text(result.PerUnitCharge);
//        $("#ContactMultiplier2").text(result.ContactMultiplier);
//        $("#TotalMonthlyCharge").text(result.MonthlyCharge);

//        $("#PlanCharge").text(result.BasicAmount);
//        $("#storageCharge").text(result.StorageAmount);
//        $("#subTotalCharge").text(result.SubTotalCharge);
//        $("#Discount").text(result.Discount);
//        $("#TotalAmountCharge").text(result.GrossAmount);
//        $("#TotalAmountChargeRe").val(result.GrossAmount);
//        $("#percentRatio").text(result.DiscountPercentage);
//        $("#groupcode").val(result.Promocode);

//        if (result.IsStorageSubscription == true) {
//            $("#chkStorage").prop("checked", true);
//            $("#IsStorageDisplay").show();
//        }
//        else {
//            $("#chkStorage").prop("checked", false);
//            $("#IsStorageDisplay").hide();
//        }

//        //var twoPlacedFloat = parseFloat(result.GrossAmount).toFixed(2)
//        //$(".btnPaymentGetway").attr("total_amount", twoPlacedFloat);
//      //  $("#TotalAmountChargeRe").attr('data_AppFee', result.GrossAmount);
//    }

//}

//function ValidateCredit(parameters) {
//    var isresult = true;
//    var accName = $("#nameAccountapp1Txt").val().trim();
//    var address = $("#addressapp1Txt1").val().trim();
//    var city = $("#cityapp1Txt").val().trim();
//    var state = $("#ddlstateapp").val().trim();
//    var zip = $("#zipcodeapp1Txt").val().trim();
//    var card = $("#creditcardapp1Txt").val().trim();
//    var cvs = $("#cvsNumber").val().trim();
//    var exp = $("#txtExpire").val().trim();

//    //var nTotal = $("#TotalApp").val();

//    //if (nTotal === "undefined" || nTotal === "") {
//    //    $("#TotalApp").css({ 'border': '1px solid red' });
//    //    isresult = false;
//    //}
//    //else {
//    //    $("#TotalApp").css({ 'border': '1px solid #d2d6de' });
//    //}

//    if (accName === "undefined" || accName === "") {
//        $("#nameAccountapp1Txt").css({ 'border': '1px solid red' });
//        isresult = false;
//    }
//    else {
//        $("#nameAccountapp1Txt").css({ 'border': '1px solid #d2d6de' });
//    }

//    if (address === "undefined" || address === "") {
//        $("#addressapp1Txt1").css({ 'border': '1px solid red' });
//        isresult = false;
//    }
//    else {
//        $("#addressapp1Txt1").css({ 'border': '1px solid #d2d6de' });
//    }

//    if (city === "undefined" || city === "") {
//        $("#cityapp1Txt").css({ 'border': '1px solid red' });
//        isresult = false;
//    }
//    else {
//        $("#cityapp1Txt").css({ 'border': '1px solid #d2d6de' });
//    }

//    if (state === "undefined" || state === "-1") {
//        $("#s2id_ddlstateapp").css({ 'border': '1px solid red' });
//        isresult = false;
//    }
//    else {
//        $("#s2id_ddlstateapp").css({ 'border': '1px solid #d2d6de' });
//    }


//    if (zip === "undefined" || zip === "") {
//        $("#zipcodeapp1Txt").css({ 'border': '1px solid red' });
//        isresult = false;
//    }
//    else {
//        $("#zipcodeapp1Txt").css({ 'border': '1px solid #d2d6de' });
//    }
//    if (card === "undefined" || card === "") {
//        $("#creditcardapp1Txt").css({ 'border': '1px solid red' });
//        isresult = false;
//    }
//    else {
//        $("#creditcardapp1Txt").css({ 'border': '1px solid #d2d6de' });
//    }
//    if (cvs === "undefined" || cvs === "") {
//        $("#cvsNumber").css({ 'border': '1px solid red' });
//        isresult = false;
//    }
//    else {
//        $("#cvsNumber").css({ 'border': '1px solid #d2d6de' });
//    }
//    if (exp === "undefined" || exp === "") {
//        $("#txtExpire").css({ 'border': '1px solid red' });
//        isresult = false;
//    }
//    else {
//        $("#txtExpire").css({ 'border': '1px solid #d2d6de' });
//    }


//    if ($("#chkAgree").is(':checked')) {

//    }
//    else {
//        isresult = false;
//        $("#chkAgree").css({ 'border': '1px solid #d2d6de' });
//    }

//    if (isresult)
//        isresult = true;
//    else {
//        isresult = false;
//    }
//    return isresult;
//}

//function ValidateCheck(parameters) {
//    var isresult = true;
//    var RoutingNumber = $("#routingnumapp1Txt").val().trim();
//    var RoutingNumberRe = $("#rerountingnumapp1Txt").val().trim();
//    var AccNo = $("#checkacctnumapp1Txt").val().trim();
//    var AccNoRech = $("#recheckacctnumapp1Txt").val().trim();
//    var accName = $("#nameAccountapp1Txt").val().trim();
//    //var nTotal = $("#TotalApp").val();

//    var address = $("#addressapp1Txt1").val().trim();
//    var city = $("#cityapp1Txt").val().trim();
//    var state = $("#ddlstateapp").val().trim();
//    var zip = $("#zipcodeapp1Txt").val().trim();

//    //if (nTotal === "undefined" || nTotal === "") {
//    //    $("#TotalApp").css({ 'border': '1px solid red' });
//    //    isresult = false;
//    //}
//    //else {
//    //    $("#TotalApp").css({ 'border': '1px solid #d2d6de' });
//    //}

//    if (accName === "undefined" || accName === "") {
//        $("#nameAccountapp1Txt").css({ 'border': '1px solid red' });
//        isresult = false;
//    }
//    else {
//        $("#nameAccountapp1Txt").css({ 'border': '1px solid #d2d6de' });
//    }

//    if (address === "undefined" || address === "") {
//        $("#addressapp1Txt1").css({ 'border': '1px solid red' });
//        isresult = false;
//    }
//    else {
//        $("#addressapp1Txt1").css({ 'border': '1px solid #d2d6de' });
//    }

//    if (city === "undefined" || city === "") {
//        $("#cityapp1Txt").css({ 'border': '1px solid red' });
//        isresult = false;
//    }
//    else {
//        $("#cityapp1Txt").css({ 'border': '1px solid #d2d6de' });
//    }

//    if (state === "undefined" || state === "-1") {
//        $("#s2id_ddlstateapp").css({ 'border': '1px solid red' });
//        isresult = false;
//    }
//    else {
//        $("#s2id_ddlstateapp").css({ 'border': '1px solid #d2d6de' });
//    }


//    if (zip === "undefined" || zip === "") {
//        $("#zipcodeapp1Txt").css({ 'border': '1px solid red' });
//        isresult = false;
//    }
//    else {
//        $("#zipcodeapp1Txt").css({ 'border': '1px solid #d2d6de' });
//    }

//    if (RoutingNumber === "undefined" || RoutingNumber === "") {
//        $("#routingnumapp1Txt").css({ 'border': '1px solid red' });
//        isresult = false;
//    }
//    else {
//        $("#routingnumapp1Txt").css({ 'border': '1px solid #d2d6de' });
//    }

//    if (RoutingNumber != RoutingNumberRe) {
//        $("#rerountingnumapp1Txt").css({ 'border': '1px solid red' });
//        isresult = false;
//    }
//    else {
//        $("#rerountingnumapp1Txt").css({ 'border': '1px solid #d2d6de' });
//    }

//    if (AccNo === "undefined" || AccNo === "") {
//        $("#checkacctnumapp1Txt").css({ 'border': '1px solid red' });
//        isresult = false;
//    }
//    else {
//        $("#checkacctnumapp1Txt").css({ 'border': '1px solid #d2d6de' });
//    }

//    if (AccNo != AccNoRech) {
//        $("#recheckacctnumapp1Txt").css({ 'border': '1px solid red' });
//        isresult = false;
//    }
//    else {
//        $("#recheckacctnumapp1Txt").css({ 'border': '1px solid #d2d6de' });
//    }

//    if ($("#chkAgree").is(':checked')) {

//    }
//    else {
//        isresult = false;
//        $("#chkAgree").css({ 'border': '1px solid #d2d6de' });
//    }

//    // });
//    if (isresult)
//        isresult = true;
//    else {
//        isresult = false;
//    }
//    return isresult;
//}

//function GetSavedObj(creditType) {
   
//    var obj = {};
//    if (creditType == 'Credit') {
//        obj = {
//            "FromUser": $("#hdPhone").val(),
//            "ToUser": 'eTag365',
//            "FromUserType": $("#hdUserType").val(),
//            "ToUserType": '1',
//            "AccountName": $("#nameAccountapp1Txt").val().trim(),
//            "Address": $("#addressapp1Txt1").val(),
//            "Address1": '',
//            "City": $("#cityapp1Txt").val(),
//            "State": $("#ddlstateapp").val(),
//            "Zip": $("#zipcodeapp1Txt").val(),
//            "CVS": $("#cvsNumber").val(),
//            "IsCheckingAccount": false,
//            "RoutingNo": '',
//            "AccountNo": '',
//            "CheckNo": '',
//            "IsRecurring": $("#chkRecurring").is(':checked') == true ? true : false,
//            "IsAgree": $("#chkAgree").is(':checked') == true ? true : false,
//            "AccountType": $('input[name=card]:checked').val(),
//            "SubscriptionType": $("input[name=plan]:checked").val(),
//            "IsStorageSubscription": $("#chkStorage").is(':checked') == true ? true : false,
//            "IsReceivedCommissions": $("#chkReceive").is(':checked') == true ? true : false,
//            "YTD_Contact_Export_Limit": $("#hdYTDExportLimit").val(),
//            "MTD_Contact_Import_Limit": $("#hdMTDImportLimit").val(),
//            "Contact_Storage_Limit": $("#hdStorageLimit").val(),
//            "IsBillingCycleMonthly": $("#ddlPeriod").val() == 'M' ? true : false,
//            "BasicAmount": $("#PlanCharge").text(),
//            "StorageAmount": $("#storageCharge").text(),
//            "SubTotalCharge": $("#subTotalCharge").text(),
//            "Promocode": $("#groupcode").val(),
//            "DiscountPercentage": $("#percentRatio").text(),
//            "Discount": $("#Discount").text(),
//            "CheckingAccountProcessingFee": '0',
//            "GrossAmount": $("#TotalAmountCharge").text(),
//            "NetAmount": $("#TotalAmountCharge").text(),
//            "NoOfContact": $("#NoOfContact").text(),
//            "ContactMultiplier": $("#ContactMultiplier").val(),
//            "TotalContact": $("#TotalContact").text(),
//            "PerUnitCharge": $("#PerMonthCharge").text(),
//            "MonthlyCharge": $("#TotalMonthlyCharge").text(),
//            "LastFourDigitCard": sLast4,
//            "CardNumber": sLast4,
//            "Month": sExpMonth,
//            "Year": sExpYear,
//            "TransactionCode": strace_number,
//            "AuthorizationCode": sResponseCode,
//            "TransactionDescription": sResponseDetails
//        }
//    }
//    else {
//        obj = {
//            "FromUser": $("#hdPhone").val(),
//            "ToUser": 'eTag365',
//            "FromUserType": $("#hdUserType").val(),
//            "ToUserType": '1',
//            "AccountName": $("#nameAccountapp1Txt").val().trim(),
//            "Address": $("#addressapp1Txt1").val(),
//            "Address1": '',
//            "City": $("#cityapp1Txt").val(),
//            "State": $("#ddlstateapp").val(),
//            "Zip": $("#zipcodeapp1Txt").val(),
//            "CardNumber": '',
//            "CVS": '',
//            "Month": sExpMonth,
//            "Year": sExpYear,
//            "IsCheckingAccount": true,
//            "RoutingNo": $("#routingnumapp1Txt").val(),
//            "AccountNo": sLast4,
//            "CheckNo": '',
//            "IsRecurring": $("#chkRecurring").is(':checked') == true ? true : false,
//            "IsAgree": $("#chkAgree").is(':checked') == true ? true : false,
//            "AccountType": $('input[name=card]:checked').val(),
//            "SubscriptionType": $("input[name=plan]:checked").val(),
//            "IsStorageSubscription": $("#chkStorage").is(':checked') == true ? true : false,
//            "IsReceivedCommissions": $("#chkReceive").is(':checked') == true ? true : false,
//            "YTD_Contact_Export_Limit": $("#hdYTDExportLimit").val(),
//            "MTD_Contact_Import_Limit": $("#hdMTDImportLimit").val(),
//            "Contact_Storage_Limit": $("#hdStorageLimit").val(),
//            "IsBillingCycleMonthly": $("#ddlPeriod").val() == 'M' ? true : false,
//            "BasicAmount": $("#PlanCharge").text(),
//            "StorageAmount": $("#storageCharge").text(),
//            "SubTotalCharge": $("#subTotalCharge").text(),
//            "Promocode": $("#groupcode").val(),
//            "DiscountPercentage": $("#percentRatio").text(),
//            "Discount": $("#Discount").text(),
//            "CheckingAccountProcessingFee": '0',
//            "GrossAmount": $("#TotalAmountCharge").text(),
//            "NetAmount": $("#TotalAmountCharge").text(),
//            "NoOfContact": $("#NoOfContact").text(),
//            "ContactMultiplier": $("#ContactMultiplier").val(),
//            "TotalContact": $("#TotalContact").text(),
//            "PerUnitCharge": $("#PerMonthCharge").text(),
//            "MonthlyCharge": $("#TotalMonthlyCharge").text(),
//            "LastFourDigitCard": sLast4,
//            "TransactionCode": strace_number,
//            "AuthorizationCode": sResponseCode,
//            "TransactionDescription": sResponseDetails
//        }
//    }

//    return obj;
//}

//function SaveTransaction(creditType) {
   
//    var obj = GetSavedObj(creditType);
//    var pagePath = currentPagePath + "Save";
//    $.ajax({
//        type: "POST",
//        url: pagePath,
//        data: JSON.stringify({ "obj": obj }),
//        contentType: "application/json; charset=utf-8",
//        dataType: "json",
//        error:
//            function (XMLHttpRequest, textStatus, errorThrown) {
//                alert("Error");
//            },
//        success:
//            function (result) {

//                var obj = $.parseJSON(decodeURIComponentSafe(result.d));
//                if (obj == true) {
//                    notify('success', "Thank you. Your Payment was successful");

//                } else {
//                    notify('danger', "Your Payment failed !!");
//                }

//            }

//    });

//}
