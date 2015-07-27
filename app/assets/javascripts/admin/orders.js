// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//
$(document).ready(function() {
  var filter_options = filter_columns(11);
  filter_options[8].data = filter_options[9].data = {};
  filter_options[2].filter_type = filter_options[3].filter_type = filter_options[4].filter_type = 'range_number';
  var datepickerDefaults = {
    showTodayButton: true,
    showClear: true,
  };
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
      }]
    }, {
      column_number: 12,
      filter_delay: 1000,
      filter_type: 'text',
      data: {}
    }, {
      column_number: 13,
      filter_delay: 1000,
      filter_type: 'text',
      data: {}
    },{
      column_number: 14,
      filter_delay: 1000,
      filter_type: 'text',
      data: {}
    },
    {
      column_number: 15,
      filter_delay: 1000,
      filter_type: 'range_date',
      datepicker_type: 'bootstrap-datetimepicker',
      date_format: 'YYYY-MM-DD HH:mm:ss',
      filter_plugin_options: datepickerDefaults
    }, {
      column_number: 16,
      filter_delay: 1000,
      filter_type: 'range_date',
      datepicker_type: 'bootstrap-datetimepicker',
      date_format: 'YYYY-MM-DD HH:mm:ss',
      filter_plugin_options: datepickerDefaults
    }
  );

  if ($('#orders-table').length > 0) {
    var dataTable = $('#orders-table').dataTable({
      processing: true,
      serverSide: true,
      sDom: 'lrtip',
      ajaxSource: $('#orders-table').data('source'),
      pagingType: 'full_numbers',
      order: [[14, "desc"]]
    }).yadcf(filter_options);

    $('.yadcf-filter-reset-button').hide();
    $('.yadcf-filter').addClass('form-control');
    $('.yadcf-filter-range-date').addClass('form-control');
    $('.yadcf-filter-range-number').addClass('form-control');

    $('.order-csv-link').click(function(event) {
      event.preventDefault();
      exportOrderCsv.call(this);
    });

    $('.order-delivered-csv-link').click(function(event) {
      event.preventDefault();
      if (confirm('发货CSV无法重复导出，确认导出？')) {
        exportOrderCsv.call(this);
      }
    });

    function exportOrderCsv() {
      event.preventDefault();
      var data = dataTable.oApi._fnAjaxParameters(dataTable.fnSettings());
      var originalLink = $(this).prop('href');
      var delimiter = originalLink.indexOf('?') === -1 ? '?' : '&';
      var link = originalLink + delimiter + $.param(data);
      window.location.href = link;
    }
  }
});
