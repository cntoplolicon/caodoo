// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//
$(document).ready(function() {
  $('#product-groups-table').dataTable({
    processing: true,
    serverSide: true,
    ajaxSource: $('#product-groups-table').data('source'),
    pagingType: 'full_numbers',
    columnDefs: [
      {targets: -1, sortable: false}
    ]
  });

  $('.product-group-form select').select2();
});
