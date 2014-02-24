window.CKEDITOR_BASEPATH = '/assets/';

$(function() {
  $('div.supplier_select select').on('change', function() {
    if ($(this).val() == 'add-supplier') {
      if (new_supplier = prompt('Enter the name of the new supplier')) {
        $.ajax({
          type: 'POST',
          url: '/suppliers.js',
          data: { supplier: { name: new_supplier }, el_id: $(this).attr('id') }
        });
      }
    }
  });

  $('#numbers').dataTable({
        "bPaginate": false,
        "bLengthChange": false,
        "bFilter": false,
        "bSort": true,
        "bInfo": false,
        "bAutoWidth": false
    });
});
