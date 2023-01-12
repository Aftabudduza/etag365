//var currentPagePath = window.location.pathname + "/";
var currentPagePath = "/Pages/Admin/ContactExportImport.aspx" + "/";

var currentUserExportLimit = "";
$(document).ready(function () {
    debugger;
    getExportedUserLimit();   
    getExportedList();

    $("#upload").bind("click", function () {
        
        var regex = /^([a-zA-Z0-9\s_\\.\-:])+(.csv|.txt)$/;//regex for Checking valid files csv of txt 
        if (regex.test($("#fileMaintenanceImageUpload").val().toLowerCase())) {
            if (typeof (FileReader) != "undefined") {
                var reader = new FileReader();
                reader.onload = function (e) {
                    var rows = e.target.result.split("\r\n");
                    if (rows.length > 0) {
                        var first_Row_Cells = splitCSVtoCells(rows[0], ","); //Taking Headings
                        var jsonArray = new Array();
                        for (var i = 1; i < rows.length; i++) {
                            var cells = splitCSVtoCells(rows[i], ",");
                            var obj = {};
                            for (var j = 0; j < cells.length; j++) {
                                obj["" + first_Row_Cells[j] + ""] = cells[j];
                            }
                            jsonArray.push(obj);
                        }
                        var sa = jsonArray.pop();
                        var URL = currentPagePath + "ImportContact";
                        var dd = JSON.stringify({ 'Obj': jsonArray });

                        $.ajax({
                            contentType: 'application/json; charset=utf-8',
                            dataType: 'json',
                            type: 'POST',
                            url: URL,
                            data: dd,
                            success: function (res) {
                                let result = $.parseJSON(decodeURIComponent(res.d));
                                if (result == "BillingNotDone") {
                                   // window.location.href = "http://www.google.com/";
                                    //var origin = window.location.origin + '/Pages/Admin/Billing.aspx';
                                    var origin = window.location.origin + '/billing';
                                    window.location.href = origin;
                                }
                                else if (result == "User is Not Found") {
                                    notify("danger", result);
                                }
                                else if (result == "User is Not Active") {
                                    notify("danger", result);
                                }
                                else if (result == "No Subscription Package") {
                                    notify("danger", result);
                                }
                                else if (result == "Monthly Limit Exceeded") {
                                    notify("danger", result);
                                }
                                else if (result == "Storage Limit Exceeded") {
                                    notify("danger", result);
                                }
                                else if (result == "") {
                                    notify("danger", "Failed to import");
                                }
                                else {
                                    notify("success", result);
                                    //if (result.contain("Number of inserted contact")) {
                                    //    $("#NumberOfContactUploaded").text(result);
                                    //}
                                    $("#NumberOfContactUploaded").text(result);
                                }
                            },
                            failure: function (response) {
                                // $('#result').html(response);
                                notify("danger", "Failed to import");
                            }
                        });

                    }
                }
                reader.readAsText($("#fileMaintenanceImageUpload")[0].files[0]);
            }
            else {
                alert("This browser does not support HTML5.");
            }
        } else {
            alert("Select a valid CSV File.");
        }
    });
    function splitCSVtoCells(row, separator) {
        return row.split(separator);
    }
  
    
});
function getExportedList() {
    var URL = currentPagePath + "getExportList";
    var Obj = {

    };
    let GetData = makeAjaxCallReturnPromiss(URL, Obj);
   
    Promise.all([GetData]).then(function () {
        GetData.then((data) => {
            let result = $.parseJSON(decodeURIComponent(data.d));
            if (result != null) {
                BindAllContactInfo(result);
            }
            else {
                //ShowDealerInfo();
            }
        });
    });
}
function getExportedUserLimit() {
    var URL = currentPagePath + "ExportLimit";
    var Obj = {

    };
    let GetData = makeAjaxCallReturnPromiss(URL, Obj);
    Promise.all([GetData]).then(function () {
        GetData.then((data) => {
            let result = $.parseJSON(decodeURIComponent(data.d));
            if (result != null) {
                currentUserExportLimit = result;

                if (currentUserExportLimit == 'User is Not Found') {
                    notify('danger', currentUserExportLimit);
                }
                else if (currentUserExportLimit == 'User is Not Active') {
                    notify('danger', currentUserExportLimit);
                }
                else if (currentUserExportLimit == 'BillingNotDone') {
                    var origin = window.location.origin + '/billing';
                    window.location.href = origin;
                }
                else if (currentUserExportLimit == 'No Subscription Package') {
                    notify('danger', currentUserExportLimit);
                }  
            }
            else {
                //ShowDealerInfo();
            }
        });
    });

}
function BindAllContactInfo(result) {
    var content = "";
    if (result.length >0) {        
        $.each(result, function (i, obj) {

            var FirstName = (obj.FirstName != null && obj.FirstName !== undefined) ? obj.FirstName : "";
            var MiddleName = (obj.MiddleName != null && obj.MiddleName !== undefined) ? obj.MiddleName : "";
            var LastName = (obj.LastName != null && obj.LastName !== undefined) ? obj.LastName : "";
            var Email = (obj.Email != null && obj.Email !== undefined) ? obj.Email : "";
            var Address = (obj.Address != null && obj.Address !== undefined) ? obj.Address : "";
            var Address1 = (obj.Address1 != null && obj.Address1 !== undefined) ? obj.Address1 : "";
            var Region = (obj.Region != null && obj.Region !== undefined) ? obj.Region : "";
            var Country = (obj.Country != null && obj.Country !== undefined) ? obj.Country : "";
            var State = (obj.State != null && obj.State !== undefined) ? obj.State : "";
            var City = (obj.City != null && obj.City !== undefined) ? obj.City : "";
            var Zip = (obj.Zip != null && obj.Zip !== undefined) ? obj.Zip : "";
            var Phone = (obj.Phone != null && obj.Phone !== undefined) ? obj.Phone : "";
            var WorkPhone = (obj.WorkPhone != null && obj.WorkPhone !== undefined) ? obj.WorkPhone : "";
            var WorkPhoneExt = (obj.WorkPhoneExt != null && obj.WorkPhoneExt !== undefined) ? obj.WorkPhoneExt : "";
            var Fax = (obj.Fax != null && obj.Fax !== undefined) ? obj.Fax : "";
            var IsActive = (obj.IsActive != null && obj.IsActive !== undefined) ? obj.IsActive : "";
            var RefPhone = (obj.RefPhone != null && obj.RefPhone !== undefined) ? obj.RefPhone : "";
            var Title = (obj.Title != null && obj.Title !== undefined) ? obj.Title : "";

            var Category = (obj.Category != null && obj.Category !== undefined) ? obj.Category : "";
            var TypeOfContact = (obj.TypeOfContact != null && obj.TypeOfContact !== undefined) ? obj.TypeOfContact : "";

            var CompanyName = (obj.CompanyName != null && obj.CompanyName !== undefined) ? obj.CompanyName : "";

            var IsEmailFlow = (obj.IsEmailFlow != null && obj.IsEmailFlow !== undefined) ? obj.IsEmailFlow : "";

            var Website = (obj.Website != null && obj.Website !== undefined) ? obj.Website : "";

            content +="<tr>"
            content += "<td><input type='checkbox' class='chk' data-id=" + obj.Id + " ></td>";
            //content += "<td><img src='' alt='Logo'></td>";
            content += "<td>" + LastName + "</td>";
            content += "<td>" + FirstName + "</td>";
            content += "<td>" + CompanyName + "</td>";
            content += "<td>" + Phone + "</td>";
            content += "<td data-FirstName='" + FirstName + "' data-LastName='" + LastName + "' data-MiddleName='" + MiddleName + "' data-Address='" + Address + "' data-Address1='" + Address1 + "' data-Region='" + Region + "' data-Country='" + Country + "' data-State='" + State + "' data-City='" + City + "' data-Zip='" + Zip + "' data-Phone='" + Phone + "' data-WorkPhone='" + WorkPhone + "' data-WorkPhoneExt='" + WorkPhoneExt + "' data-Fax='" + Fax + "' data-IsActive='" + IsActive + "'" + " data-RefPhone='" + RefPhone + "' data-Title='" + Title + "' data-CompanyName='" + CompanyName + "' data-Category='" + Category + "' data-TypeOfContact='" + TypeOfContact + "' data-IsEmailFlow='" + IsEmailFlow + "' data-Website='" + Website + "'>" + Email + "</td>";


            //content +="<td>"+ obj.FirstName + ' ' + obj.LastName +"</td>";
            //content += "<td>" + obj.CompanyName + "</td>";
            //content += "<td>" + obj.Phone + "</td>";
            //content += "<td data-FirstName='" + obj.FirstName + "' data-LastName='" + obj.LastName + "' data-MiddleName='" + obj.MiddleName + "'"
            //+ "data-Address='" + obj.Address + "' data-Address1='" + obj.Address1 + "'" +
            //" data-Region='" + obj.Region + "' data-Country='" + obj.Country + "'" +
            //" data-State='" + obj.State + "' data-City='" + obj.City + "'" +
            //" data-Zip='" + obj.Zip + "' data-Phone='" + obj.Phone + "'" +
            //" data-WorkPhone='" + obj.WorkPhone + "' data-WorkPhoneExt='" + obj.WorkPhoneExt + "'" +
            //" data-Fax='" + obj.Fax + "' data-IsActive='" + obj.IsActive + "'" +
            //" data-RefPhone='" + obj.RefPhone + "' data-Title='" + obj.Title + "' data-CompanyName='" + obj.CompanyName + "' data-Category='" + obj.Category + "' data-TypeOfContact='" + obj.TypeOfContact + "'>" + obj.Email + "</td>";
           
            content += "</tr>"
        });
        $("#tblExport tbody").empty();
        $("#tblExport tbody").append(content);
        //tblExport
    }
}
$(document).on('click', '.chk', function () {   
    var id = $(this).attr('data-id');
    var balance = 0;
    var checkCount = $("#tblExport tbody input[type=checkbox]:checked").length;
    if (currentUserExportLimit =='') {

    }
    else if (currentUserExportLimit == 'User is Not Found') {
        $(this).prop('checked', false);
        notify('danger', currentUserExportLimit);
    }
    else if (currentUserExportLimit == 'User is Not Active') {
        $(this).prop('checked', false);
        notify('danger', currentUserExportLimit);
    }
    else if (currentUserExportLimit == 'BillingNotDone') {
        $(this).prop('checked', false);
        // redirect to Billing Page
        // var origin = window.location.origin + '/Pages/Admin/Billing.aspx';
        var origin = window.location.origin + '/billing';
        window.location.href = origin;
    }
    else if (currentUserExportLimit == 'No Subscription Package') {
        $(this).prop('checked', false);
        notify('danger', currentUserExportLimit);
    }  
    else if (currentUserExportLimit == "Yearly Limit Exceeded") {
        $(this).prop('checked', false);
        notify("danger", currentUserExportLimit)
    }
    else {
        if (currentUserExportLimit == 'unlimited') {
            $(this).prop('checked',true);
        } else {
            balance = parseInt(currentUserExportLimit);
            if (checkCount > balance) {
                $("#tblExport tbody input:checkbox:not(:checked)").attr("disabled", true);
                //$(this).prop('checked',false);
            } else {
                $("#tblExport tbody input:checkbox").attr("disabled", false);
            }

        }
        
    }
    
    
});
$(document).on('click', '#chkAll', function () {
    var balance = 0;
    var cehckCount = $("#tblExport tbody input[type=checkbox]:checked").length;
    if (currentUserExportLimit == '') {

    } 
    else if (currentUserExportLimit == 'User is Not Found') {
        $(this).prop('checked', false);
        notify('danger', currentUserExportLimit);
    }
    else if (currentUserExportLimit == 'User is Not Active') {
        $(this).prop('checked', false);
        notify('danger', currentUserExportLimit);
    }
    else if (currentUserExportLimit == 'BillingNotDone') {
        $(this).prop('checked', false);
        // redirect to Billing Page
        // var origin = window.location.origin + '/Pages/Admin/Billing.aspx';
        var origin = window.location.origin + '/billing';
        window.location.href = origin;
    }
    else if (currentUserExportLimit == 'No Subscription Package') {
        $(this).prop('checked', false);
        notify('danger', currentUserExportLimit);
    }  
    else if (currentUserExportLimit == "Yearly Limit Exceeded") {
        $(this).prop('checked', false);
        notify("danger", currentUserExportLimit)
    }
    else {
        if (currentUserExportLimit == 'unlimited') {
            if ($(this).is(':checked')) {
                $("#tblExport tbody input[type=checkbox]").prop("checked", true);
                //$("#tblExport tbody input:checkbox:not(:checked)").attr("disabled", true);
            } else {
                //$("#tblExport tbody input:checkbox:not(:checked)").attr("disabled", true);
                $("#tblExport tbody input[type=checkbox]").prop('checked', false);
            }
        } else {
            balance = parseInt(currentUserExportLimit);
            if ($(this).is(':checked')) {
                $("#tblExport tbody input[type=checkbox]:lt(" + balance + ")").prop("checked", true);
                $("#tblExport tbody input:checkbox:not(:checked)").attr("disabled", true);
            } else {
                //$("#tblExport tbody input:checkbox:not(:checked)").attr("disabled", true);
                $("#tblExport tbody input[type=checkbox]").prop('checked', false);
            }

        }

        //balance = parseInt(currentUserExportLimit);
    }
  
});
$(document).on('click', '#Download', function () {
    var checkCount = $("#tblExport tbody input[type=checkbox]:checked").length;
    if (checkCount > 0) {
        var exportType = $('input[type=radio][name=export]:checked').val();
        if (exportType == 'CSV') {
            ExportAsCSV();
        } else {
            ExportAsXML();
        }
    } else {
        notify('danger', 'Please select contact from Grid');
    }
});
function ExportAsCSV() {
    var headers = {
        FirstName: 'FirstName', // remove commas to avoid errors
        MiddleName: "MiddleName",
        LastName: "LastName",
        Email: "Email",
        Address: "Address",
        Address1: "Address1",
        Region: "Region",
        Country: "Country",
        State: "State",
        City: "City",
        Zip: "Zip",
        Phone: "Phone",
        WorkPhone: "WorkPhone",
        WorkPhoneExt: "WorkPhoneExt",
        Fax: "Fax",
        IsActive: "IsActive",
        RefPhone: "RefPhone",
        Title: "Title",
        CompanyName: "CompanyName",
        Category: "Category",
        TypeOfContact: "TypeOfContact",
        IsEmailFlow: "IsEmailFlow", 
        Website: "Website"
    };
    itemsNotFormatted = [];
    $("#tblExport tbody input[type=checkbox]:checked").each(function () {
        var tr = $(this).closest('tr');
        var FirstName =$($(tr).find('td:eq(5)')).attr('data-FirstName') == 'null'?"": $($(tr).find('td:eq(5)')).attr('data-FirstName');
        var MiddleName = $($(tr).find('td:eq(5)')).attr('data-MiddleName') == 'null' ? "" : $($(tr).find('td:eq(5)')).attr('data-MiddleName');
        var LastName = $($(tr).find('td:eq(5)')).attr('data-LastName') == 'null' ? "" : $($(tr).find('td:eq(5)')).attr('data-LastName');
        var Email = $($(tr).find('td:eq(5)')).text() == 'null' ? "" : $($(tr).find('td:eq(5)')).text();
        var Address = $($(tr).find('td:eq(5)')).attr('data-Address') == 'null' ? "" : $($(tr).find('td:eq(5)')).attr('data-Address');
        var Address1 = $($(tr).find('td:eq(5)')).attr('data-Address1') == 'null' ? "" : $($(tr).find('td:eq(5)')).attr('data-Address1');
        var Region = $($(tr).find('td:eq(5)')).attr('data-Region') == 'null' ? "" : $($(tr).find('td:eq(5)')).attr('data-Region');
        var Country = $($(tr).find('td:eq(5)')).attr('data-Country') == 'null' ? "" : $($(tr).find('td:eq(5)')).attr('data-Country');
        var State = $($(tr).find('td:eq(5)')).attr('data-State') == 'null' ? "" : $($(tr).find('td:eq(5)')).attr('data-State');
        var City = $($(tr).find('td:eq(5)')).attr('data-City') == 'null' ? "" : $($(tr).find('td:eq(5)')).attr('data-City');
        var Zip = $($(tr).find('td:eq(5)')).attr('data-Zip') == 'null' ? "" : $($(tr).find('td:eq(5)')).attr('data-Zip');
        var Phone = $($(tr).find('td:eq(4)')).text() == 'null'?"": $($(tr).find('td:eq(4)')).text();
        var WorkPhone = $($(tr).find('td:eq(5)')).attr('data-WorkPhone') == 'null' ? "" : $($(tr).find('td:eq(5)')).attr('data-WorkPhone');
        var WorkPhoneExt = $($(tr).find('td:eq(5)')).attr('data-WorkPhoneExt') == 'null' ? "" : $($(tr).find('td:eq(5)')).attr('data-WorkPhoneExt');
        var Fax = $($(tr).find('td:eq(5)')).attr('data-Fax') == 'null' ? "" : $($(tr).find('td:eq(5)')).attr('data-Fax');
        var IsActive = $($(tr).find('td:eq(5)')).attr('data-IsActive') == 'null' ? "" : $($(tr).find('td:eq(5)')).attr('data-IsActive');
        var RefPhone = $($(tr).find('td:eq(5)')).attr('data-RefPhone') == 'null' ? "" : $($(tr).find('td:eq(5)')).attr('data-RefPhone');
        var Title = $($(tr).find('td:eq(5)')).attr('data-FirstName') == 'null' ? "" : $($(tr).find('td:eq(5)')).attr('data-FirstName');

        var Category = $($(tr).find('td:eq(5)')).attr('data-Category') == 'null' ? "" : $($(tr).find('td:eq(5)')).attr('data-Category');
        var TypeOfContact = $($(tr).find('td:eq(5)')).attr('data-TypeOfContact') == 'null' ? "" : $($(tr).find('td:eq(5)')).attr('data-TypeOfContact');

        var CompanyName = $($(tr).find('td:eq(3)')).text() == 'null' ? "" : $($(tr).find('td:eq(3)')).text();

        var IsEmailFlow = $($(tr).find('td:eq(5)')).attr('data-IsEmailFlow') == 'null' ? "" : $($(tr).find('td:eq(5)')).attr('data-IsEmailFlow');
        var Website = $($(tr).find('td:eq(5)')).attr('data-Website') == 'null' ? "" : $($(tr).find('td:eq(5)')).attr('data-Website');

        var obj = {
            FirstName: FirstName,
            MiddleName: MiddleName,
            LastName: LastName,
            Email: Email,
            Address: Address,
            Address1: Address1,
            Region: Region,
            Country: Country,
            State: State,
            City: City,
            Zip: Zip,
            Phone: Phone,
            WorkPhone: WorkPhone,
            WorkPhoneExt: WorkPhoneExt,
            Fax: Fax,
            IsActive: IsActive,
            RefPhone: RefPhone,
            Title: Title,
            CompanyName: CompanyName,
            Category: Category,
            TypeOfContact: TypeOfContact,
            IsEmailFlow: IsEmailFlow,
            Website: Website
        }
        itemsNotFormatted.push(obj);
    });   

    var itemsFormatted = [];

    // format the data
    itemsNotFormatted.forEach((item) => {
        itemsFormatted.push({
            //model: item.model.replace(/,/g, ''), // remove commas to avoid errors,
            //chargers: item.chargers,
            //cases: item.cases,
            //earphones: item.earphones

            FirstName: item.FirstName.replace(/,/g, ' '),
            MiddleName: item.MiddleName.replace(/,/g, ' '),
            LastName: item.LastName.replace(/,/g, ' '),
            Email: item.Email.replace(/,/g, ' '),
            Address: item.Address.replace(/,/g, ' '),
            Address1: item.Address1.replace(/,/g, ' '),
            Region: item.Region.replace(/,/g, ' '),
            Country: item.Country.replace(/,/g, ' '),
            State: item.State.replace(/,/g, ' '),
            City: item.City.replace(/,/g, ' '),
            Zip: item.Zip.replace(/,/g, ''),
            Phone: item.Phone.replace(/,/g, ''),
            WorkPhone: item.WorkPhone.replace(/,/g, ''),
            WorkPhoneExt: item.WorkPhoneExt.replace(/,/g, ''),
            Fax: item.Fax.replace(/,/g, ''),
            IsActive: item.IsActive.replace(/,/g, ''),
            RefPhone: item.RefPhone.replace(/,/g, ''),
            Title: item.Title.replace(/,/g, ' '),
            CompanyName: item.CompanyName.replace(/,/g, ' '),
            Category: item.Category.replace(/,/g, ' '),
            TypeOfContact: item.TypeOfContact.replace(/,/g, ' '),
            IsEmailFlow: item.IsEmailFlow.replace(/,/g, ' '), 
            Website: item.Website.replace(/,/g, ' ')
        });
    });

    var m = new Date();
    var dateString =
        m.getUTCFullYear() + 
        ("0" + (m.getUTCMonth() + 1)).slice(-2) +
        ("0" + m.getUTCDate()).slice(-2) + 
        ("0" + m.getUTCHours()).slice(-2) + 
        ("0" + m.getUTCMinutes()).slice(-2) + 
        ("0" + m.getUTCSeconds()).slice(-2);

    var fileTitle = 'eTag365_Contact_' + dateString; // or 'my-unique-title'
    var checkCount = $("#tblExport tbody input[type=checkbox]:checked").length;
    $("#NumberOfContactExport").text(checkCount);
    exportCSVFile(headers, itemsFormatted, fileTitle); // call the exportCSVFile() function to process the JSON and trigger the download

};
function convertToCSV(objArray) {
    var array = typeof objArray != 'object' ? JSON.parse(objArray) : objArray;
    var str = '';

    for (var i = 0; i < array.length; i++) {
        var line = '';
        for (var index in array[i]) {
            if (line != '') line += ','

            line += array[i][index];
        }

        str += line + '\r\n';
    }

    return str;
}
function exportCSVFile(headers, items, fileTitle) {
    if (headers) {
        items.unshift(headers);
    }

    // Convert Object to JSON
    var jsonObject = JSON.stringify(items);

    var csv = convertToCSV(jsonObject);

    var exportedFilename = fileTitle + '.csv' || 'export.csv';

    var blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
    if (navigator.msSaveBlob) { // IE 10+
        navigator.msSaveBlob(blob, exportedFilename);
    } else {
        var link = document.createElement("a");
        if (link.download !== undefined) { // feature detection
            // Browsers that support HTML5 download attribute
            var url = URL.createObjectURL(blob);
            link.setAttribute("href", url);
            link.setAttribute("download", exportedFilename);
            link.style.visibility = 'hidden';
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        }
    }



    var checkCount = $("#tblExport tbody input[type=checkbox]:checked").length;
    $("#NumberOfContactExport").val(checkCount);
    var MyURL = currentPagePath + "UpdateUserProfileForCSVExport";
    var Obj = {
        count: checkCount
    }
    

    let GetData = makeAjaxCallReturnPromiss(MyURL, Obj);
    GetData.then((data) => {
        let result = $.parseJSON(decodeURIComponent(data.d));
        if (result != null) {
            if (result == true) {

                //$("#xmlDownload")[0].click();
            }
        }
        else {
            //ShowDealerInfo();
        }
    });
}
function ExportAsXML() {
    var URL = currentPagePath + "SaveXMLFile";
    var Obj = [];
    $("#tblExport tbody input[type=checkbox]:checked").each(function () {
        var tr = $(this).closest('tr');
        var id = $($($(tr).find('td:eq(0)')).find('input')).attr('data-id');
        var ob = {
            id: id
        };
        Obj.push(ob);
    });

    let GetData = makeAjaxCallReturnPromiss(URL, Obj);
    GetData.then((data) => {
        let result = $.parseJSON(decodeURIComponent(data.d));
        if (result != null) {
            if (result == true) {
                var checkCount = $("#tblExport tbody input[type=checkbox]:checked").length;
                $("#NumberOfContactExport").text(checkCount);

                //var pathname = window.location.pathname; // Returns path only (/path/example.html)
                //var url      = window.location.href;     // Returns full URL (https://example.com/path/example.html)
                var origin = window.location.origin;   // Returns base URL (https://example.com)
                var href = origin + '/xml/ContactInfo.xml';
                $("#xmlDownload").attr('href', '');
                $("#xmlDownload").attr('href', href);
                $("#xmlDownload")[0].click();
            }
        }
        else {
            //ShowDealerInfo();
        }
    });
    // loadDoc();
};

$(document).on('click', '#btnExit', function (parameters) {
    var origin = window.location.origin; 
    window.location.href = origin + "/home";
});

