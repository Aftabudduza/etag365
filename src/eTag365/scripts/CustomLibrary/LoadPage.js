function disLoadedPageInDiv(url, divId) {
    $('#pleaseWait').modal('show');
    $.ajax({
        type: "GET",
        url: url,
        contentType: "application/json; charset=utf-8",
        datatype: "json",
        success: function (data) {
            $('#pleaseWait').modal('hide');
            $('#' + divId).html(data);

        },
        error: function () {
            $('#pleaseWait').modal('hide');
            alert("Dynamic content load failed.");
        }
    });
}