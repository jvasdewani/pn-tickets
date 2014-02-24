$(function() {
  $('input[name="issue[contact_id]"]').on('click', function() {
    $(this).parent('p').parent('div').children('h6').children('input[type="radio"]').attr('checked', 'checked');
  });

  $('input.date_picker').datepicker({
    dateFormat: 'dd/mm/yy'
  });
});
