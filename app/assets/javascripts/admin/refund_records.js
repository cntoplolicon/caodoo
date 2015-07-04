// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function() {
  var filter_options = filter_columns(7);
  filter_options.push({
    column_number: 7,
    data: [{
      value: 0,
      label: '正在处理'
    }, {
      value: 1,
      label: '已退款'
    }, {
      value: 10,
      label: '已作废'
    }],
  });
  filter_options.push({
    column_number: 8,
    filter_type: 'range_date',
    date_format: 'yyyy-mm-dd'
  });
  var dataTable = $('#refund_records-table').dataTable({
    processing: true,
    serverSide: true,
    ajaxSource: $('#refund_records-table').data('source'),
    pagingType: 'full_numbers',
    columnDefs: [
      {targets: -1, sortable: false}
    ]
  }).yadcf(filter_options);
  $('.yadcf-filter-reset-button').hide();
  $('.yadcf-filter').addClass('form-control');
  $('.yadcf-filter-range-date').addClass('form-control');

  $('.refund_record_csv_link').click(function(event) {
    event.preventDefault();
    var data = dataTable.oApi._fnAjaxParameters(dataTable.dataTable().fnSettings());
    var link = $(this).prop('href') + '?' + $.param(data);
    window.location.href = link;
  });
});

