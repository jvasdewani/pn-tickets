$(function() {
  $('div[data-observe="branch_select"] p input[type="radio"]').on('click', function() {
    $(this).parent('p').prev('h6').children('input[type="radio"]').attr('checked', 'checked');
  });

  $('select#issue_client_id').on('change', function() {
    $(this).parent('div.field').removeClass('bordered');
    client_id = $(this).val();
    $.getScript('/clients/'+client_id+'/list.js');
  });

  $('div.task_list input[type="checkbox"]').on('click', function() {
    var t = $('div.task_list input[type="checkbox"]').length;
    var c = $('div.task_list input[type="checkbox"]:checked').length;
    var cb = $('input[type="radio"][disabled="disabled"]');
    if (t == c) {
      cb.removeAttr('disabled');
      cb.next('label').removeClass('disabled');
    } else {
      cb.attr('disabled', 'disabled');
      cb.next('label').addClass('disabled');
    }
  });

  $('input#search_start_date').datepicker({
    dateFormat: 'dd/mm/yy'
  });

  $('input#search_end_date').datepicker({
    dateFormat: 'dd/mm/yy'
  });

  $('form#new_issue').ajaxStart(function() {
    $('span#loader').show();
    $('input[name="commit"]').attr('disabled','disabled');
  });

  $('form#new_issue').ajaxStop(function() {
    $('span#loader').hide();
    $('input[name="commit"]').removeAttr('disabled');
  });

  $('#ticket_redirect').on('change', function() {
    department = $('#ticket_redirect').val();
    if (department == 'all') {
      window.location = '/issues';
    } else {
      window.location = '/issues/department/'+department;
    }
  });

  $('#quote_redirect').on('change', function() {
    department = $('#quote_redirect').val();
    if (department == 'all') {
      window.location = '/quotes';
    } else {
      window.location = '/quotes/client/'+department;
    }
  });
});
