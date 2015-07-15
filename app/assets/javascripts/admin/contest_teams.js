// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


$(document).ready(function() {
  var filter_options = filter_columns(8);
  filter_options[6].filter_type = 'range_number';
  filter_options[7].filter_type = 'select';
  filter_options[7].data = [{value: 1, label: '是'}, {value: 0, label: '否'}]
  if ($('#contest-teams-table').length > 0) {
    var dataTable = $('#contest-teams-table').dataTable({
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
    $('.yadcf-filter-range-number').addClass('form-control');

    $('.contest-team-csv-link').click(function(event) {
      event.preventDefault();
      var data = dataTable.oApi._fnAjaxParameters(dataTable.fnSettings());
      var link = $(this).prop('href') + '?' + $.param(data);
      window.location.href = link;
    });
  }
});
