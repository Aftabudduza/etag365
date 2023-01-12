//var currentPagePath = window.location.pathname + "/";
var currentPagePath = "/Pages/Settings/UserPricing.aspx" + "/";
$(document).ready(function () {
    LoadUserPricing()
});

function LoadUserPricing() {
   
    var URL = currentPagePath + "GetData";
    var obj = {};
    let GetData = makeAjaxCallReturnPromiss(URL, obj);
    GetData.then((data) => {
        let result = $.parseJSON(decodeURIComponent(data.d));
        if (result.length > 0) {
            BindUserPricing(result);
        }
        
    });

  
}
function BindUserPricing(result) {
    
    var content = "";
    content += "<tr>"
    content += "<td>*User Plans</td>"
    content += "<td>Basic</td>"
    content += "<td>Silver</td>"
    content += "<td>Gold</td>"
    content += "</tr>"

    content += "<tr>"
    content += "<td>Monthly Costs ($)</td>"
    content += "<td>" + result[0].MonthlyCosts+"</td>"
    content += "<td>"+ result[1].MonthlyCosts+"</td>"
    content += "<td>" + result[2].MonthlyCosts +"</td>"
    content += "</tr>"

    content += "<tr>"
    content += "<td>Billed</td>"
    content += "<td>" + result[0].Billed + "</td>"
    content += "<td>" + result[1].Billed + "</td>"
    content += "<td>" + result[2].Billed + "</td>"
    content += "</tr>"

    content += "<tr>"
    content += "<td>New Contacts imports monthly</td>"
    content += "<td>" + result[0].ContactsImportsMonthly + "</td>"
    content += "<td>" + result[1].ContactsImportsMonthly + "</td>"
    content += "<td>" + result[2].ContactsImportsMonthly + "</td>"
    content += "</tr>"

    content += "<tr>"
    content += "<td>No Contact exports yearly</td>"
    content += "<td>" + result[0].ContactExportsYearly + "</td>"
    content += "<td>" + result[1].ContactExportsYearly + "</td>"
    content += "<td>" + result[2].ContactExportsYearly + "</td>"
    content += "</tr>"

    content += "<tr>"
    content += "<td>Number of stored contacts:</td>"
    content += "<td>" + result[0].StoredContacts + "</td>"
    content += "<td>" + result[1].StoredContacts + "</td>"
    content += "<td>" + result[2].StoredContacts + "</td>"
    content += "</tr>"

    content += "<tr>"
    content += "<td>Over 500 contacts -for + 500 more per-monthly ($)</td>"
    content += "<td>" + result[0].Contacts_500 + "</td>"
    content += "<td>" + result[1].Contacts_500 + "</td>"
    content += "<td>" + result[2].Contacts_500 + "</td>"
    content += "</tr>"


    content += "<tr>"
    content += "<td>Over 10, 000 contacts + 10, 000 per month ($)</td>"
    content += "<td>" + result[0].Contacts_10000+ "</td>"
    content += "<td>" + result[1].Contacts_10000+ "</td>"
    content += "<td>" + result[2].Contacts_10000+ "</td>"
    content += "</tr>"

    content += "<tr>"
    content += "<td>Recurring referral commissions</td>"
    content += "<td>" + result[0].ReferralCommissions + "</td>"
    content += "<td>" + result[1].ReferralCommissions + "</td>"
    content += "<td>" + result[2].ReferralCommissions + "</td>"
    content += "</tr>"

    content += "<tr>"
    content += "<td>1 - Free eTag365 NFC Chip</td>"
    content += "<td>" + result[0].eTag365NFCChip + "</td>"
    content += "<td>" + result[1].eTag365NFCChip + "</td>"
    content += "<td>" + result[2].eTag365NFCChip + "</td>"
    content += "</tr>"

    $('#tblUserPricing').empty();
    $('#tblUserPricing').append(content);
}