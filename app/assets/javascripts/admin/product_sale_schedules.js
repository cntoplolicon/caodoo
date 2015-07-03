// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


$(document).ready(function() {
  $('#schedules-table').dataTable({
    processing: true,
    serverSide: true,
    ajaxSource: $('#schedules-table').data('source'),
    pagingType: 'full_numbers',
    columnDefs: [
      {targets: -1, sortable: false}
    ]
  });

 $('div.input-group.date').datetimepicker({
   format: 'YYYY-MM-DD HH:mm:ss'
  });
});
