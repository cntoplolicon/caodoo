// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


$(document).ready(function() {
  $('#contest-teams-table').dataTable({
    processing: true,
    serverSide: true,
    ajaxSource: $('#contest-teams-table').data('source'),
    pagingType: 'full_numbers',
    columnDefs: [
      {targets: -1, sortable: false}
    ]
  });
});
