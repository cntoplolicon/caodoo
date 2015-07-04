// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//
$(document).ready(function() {
  filter_options = filter_columns(11);
  filter_options[8].data = filter_options[9].data = {};
  filter_options[2].filter_type = filter_options[3].filter_type = filter_options[4].filter_type = 'range_number';
  filter_options.push(
    {
      column_number: 11,
      data: [{
        value: 0,
        label: '待支付'
      }, {
        value: 1,
        label: '已付款'
      }, {
        value: 2,
        label: '已发货'
      }, {
        value: 3,
        label: '交易完成'
      }, {
        value: 4,
        label: '已退款'
      }, {
        value: 9,
        label: '正在取消'
      }, {
        value: 10,
        label: '交易取消'
      }, {
        value: 11,
        label: '交易超时'
      }
      ]
    }, {
      column_number: 12,
      filter_delay: 1000,
      filter_type: 'range_date',
      date_format: 'yyyy-mm-dd'
    }
  );

  if ($('#orders-table').length > 0) {
    var dataTable = $('#orders-table').dataTable({
      processing: true,
      serverSide: true,
      sDom: 'lrtip',
      ajaxSource: $('#orders-table').data('source'),
      pagingType: 'full_numbers'
    }).yadcf(filter_options);

    $('.yadcf-filter-reset-button').hide();
    $('.yadcf-filter').addClass('form-control');
    $('.yadcf-filter-range-date').addClass('form-control');
    $('.yadcf-filter-range-number').addClass('form-control');

    $('.order-csv-link').click(function(event) {
      event.preventDefault();
      var data = dataTable.oApi._fnAjaxParameters(dataTable.fnSettings());
      var link = $(this).prop('href') + '?' + $.param(data);
      window.location.href = link;
    });
  }
});
