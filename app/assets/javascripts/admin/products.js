// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function() {
  $('#products-table').dataTable({
    processing: true,
    serverSide: true,
    ajaxSource: $('#products-table').data('source'),
    pagingType: 'full_numbers',
    columnDefs: [
      {targets: -1, sortable: false}
    ]
  });
});
