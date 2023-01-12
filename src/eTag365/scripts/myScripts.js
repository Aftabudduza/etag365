
$(document).ready(function () {
    //Add button click event
    $('#add').click(function () {
        //validation and add order items
        var isAllValid = true;


        if (!($('#DocumentTypeId').val().trim() != '')) {
            isAllValid = false;
            $('#DocumentTypeId').siblings('span.error').css('visibility', 'visible');
        }
        else {
            $('#DocumentTypeId').siblings('span.error').css('visibility', 'hidden');
        }


        if (!($('#DocumentName').val().trim() != '')) {
            isAllValid = false;
            $('#DocumentName').siblings('span.error').css('visibility', 'visible');
        }
        else {
            $('#DocumentName').siblings('span.error').css('visibility', 'hidden');
        }


        if (isAllValid) {
            var $newRow = $('#mainrow').clone().removeAttr('id');
            $('.DocumentTypeId', $newRow).val($('#DocumentTypeId').val());


            //Replace add button with remove button
            $('#add', $newRow).addClass('remove').val('Remove').removeClass('btn-success').addClass('btn-danger');

            //remove id attribute from new clone row
            $('#DocumentTypeId,#DocumentName,#File,#add', $newRow).removeAttr('id');
            $('span.error', $newRow).remove();
            //append clone row
            $('#ScanDocAddItems').append($newRow);

            //clear select data
            $('#DocumentTypeId').val('0');
            $('#DocumentName,#File').val('');
            $('#ScanDocAdderror').empty();
        }

    })

    //remove button click event
    $('#ScanDocAddItems').on('click', '.remove', function () {
        $(this).parents('tr').remove();
    });

    $('#submit').click(function () {
        var isAllValid = true;


        //validate order items
        $('#ScanDocAdderror').text('');
        var list = [];
        var errorItemCount = 0;

        $('#ScanDocAddItems tbody tr').each(function (Save, ele) {
            if (

                //$('select.EmployeeId', this).val() == "0" ||
               $('select.DocumentTypeId', this).val() == "0" ||
                $('.DocumentName', this).val() == ""
                //$('.Image', this).val() == "" 
               ) {
                errorItemCount++;

                $(this).addClass('error');
            } else {
                var formdata = false;

                if (window.FormData) formdata = new FormData();
                if (formdata === false) {
                    alert("Your browser does not support form data");
                    return false;
                }
                
                //var image = ($('.File', this).val());
                var file = $("#File").get(0).files;
                
                alert(file);
                
                var orderItem = {
                    EmployeeId: $("#EmployeeId").val(),
                    DocumentTypeId: ($('.DocumentTypeId', this).val()),
                    DocumentName: ($('.DocumentName', this).val()),
                    //Image: ($('.Image', this).val())
                };
                list.push(orderItem);
                

                $(this).val('Please wait...');
                $.ajax({
                    type: 'POST',
                    url: '/ScanDocument/Save',
                    dataType: 'Json',
                    data: JSON.stringify(orderItem, { File: file }),
                    contentType: false,
                    processData: false,
                    cache: false,
                    contentType: 'application/json',
                    success: function (data) {
                        if (data.status) {
                            alert('Successfully saved');
                            //here we will clear the form

                            $('#ScanDocAddItems').empty();
                        }
                        else {
                            alert('Error');
                        }
                        $('#submit').val('Save');
                    },
                    error: function (error) {
                        console.log(error);
                        $('#submit').val('Save');
                    }

                });

            }
        })


    });
});
//LoadEmployeeInfo($('#EmployeeId'));
