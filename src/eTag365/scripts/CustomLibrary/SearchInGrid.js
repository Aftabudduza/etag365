function searchInGrid(searchControlId, gridId) {
    $("#" + searchControlId).keyup(function () {
        var filter = new RegExp($(this).val(), 'i');
        $("#" + gridId + " tbody tr").filter(function () {
            $(this).each(function () {
                var found = false;
                $(this).children().each(function () {
                    var content = $(this).html();
                    if (content.match(filter)) {
                        found = true;
                    }
                });
                if (!found) {
                    $(this).hide();
                } else {
                    $(this).show();
                }
            });
        });
    });
}