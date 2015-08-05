// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//
$(document).ready(function() {
  $('#brands-table').dataTable({
    processing: true,
    serverSide: true,
    ajaxSource: $('#brands-table').data('source'),
    pagingType: 'full_numbers',
    columnDefs: [
      {targets: -1, sortable: false}
    ]
  });

  $('input.brand-logo-input').fileinput({
    showUpload: false
  });
});
