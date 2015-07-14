// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


$(document).ready(function() {
  var filter_options = filter_columns(3);
  filter_options[2].filter_type = 'range_number';
  $('#contest-teams-table').dataTable({
    processing: true,
    serverSide: true,
    sDom: 'lrtip',
    ajaxSource: $('#contest-teams-table').data('source'),
    pagingType: 'full_numbers',
    columnDefs: [{
      targets: -1,
      sortable: false
    }]
  }).yadcf(filter_options);

  $('.yadcf-filter-reset-button').hide();
  $('.yadcf-filter').addClass('form-control');
});
