// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function() {
  var paymentTimeCountDown = function() {
    if (time > 0) {
      time = Math.max(time - 1, 0);
      var remainTimeString = orderRemainTime(time);
      $('#payment-remain-time-hidden-field').val(time);
      $('.payment-remain-time').text(remainTimeString);
    } else if (time === 0) {
      time--;
      window.location.reload();
    }
  };
  $('.order-submission').click(function() {
    $(this).prop('disabled', true);
    $(this).closest('form').submit();
  });
  function orderRemainTime(time) {
    if (typeof(time) !== 'number') {
      return '00分00秒';
    }
    var _minute = 60;
    var minutes = Math.floor(time / _minute);
    var seconds = Math.floor(time % _minute);
    if (minutes < 10) {
      minutes = '0' + minutes;
    }
    if (seconds < 10) {
      seconds = '0' + seconds;
    }
    return minutes + '分' + seconds + '秒';
  };
  if ($('.payment-deadline').length > 0) {
    var time = $('#payment-remain-time-hidden-field').val();
    paymentTimeCountDown();
    window.setInterval(paymentTimeCountDown, 1000);
  };
  $('.return_application_action').click(function() {
    $('#return_application_box').show();
  });
  $('.close_return_application_box_button').click(function() {
    $('#return_application_box').hide();
  });
  $('.cancel_order_action').click(function() {
    $('#cancel_order_box').data('orderId', $(this).data('orderId'));
    $('#cancel_order_box').show();
  });
  $('.cancel_cancel_order_button').click(function() {
    $('#cancel_order_box').hide();
  });
  $('.confirm_cancel_order_button').click(function() {
    var orderId = $('#cancel_order_box').data('orderId');
    $('.cancel_order_' + orderId + '_form').submit();
  });
  $('.receive_order_action').click(function() {
    $('#receive_order_box').data('orderId', $(this).data('orderId'));
    $('#receive_order_box').show();
  });
  $('.cancel_receive_order_button').click(function() {
    $('#receive_order_box').hide();
  });
  $('.confirm_receive_order_button').click(function() {
    var orderId = $('#receive_order_box').data('orderId');
    $('.receive_order_' + orderId + '_form').submit();
  });
  $('.payment-button').click(function() {
    if ($('.alipay-radio').prop('checked')) {
      $('#alipay_confirm_box').show();
      $('.alipay_submission_form').submit();
    } else if ($('.wechat-radio').prop('checked')) {
      var ajax_option = {
        type: 'POST',
        url: $('#wx_jsapi_pay_url').val(),
        dataType: 'json',
        data: {
          openid: $('#wx_openid').val(),
          order_id: $('#wx_pay_order_id').val(),
          authenticity_token: $('meta[name=csrf-token]').attr('content')
        },
        success: function(data) {
          if (data.redirect) {
            window.location.replace(data.url);
          } else {
            var payment_option = $.extend({}, data, {success: function() {
              window.location.replace($('#payment_succeed_url').val());
            }});
            wx.chooseWXPay(payment_option);
          }
        }
      }
      $.ajax(ajax_option);
    }
  });
  $('#alipay_confirm_box .alipay_fail_button').click(function() {
    $('#alipay_confirm_box').hide();
    $('#payment_failure_box').show();
  });
  $('#payment_failure_box .close_button').click(function() {
    $('#payment_failure_box').hide();
  });
  $('.order-express-info-link').click(function(event) {
    event.preventDefault();
    $(this).parent().hide();
    var detailPanel = $('.order-express-information-detail');
    detailPanel.show();
    detailPanel.load($(this).prop('href'));
  });
  if ($('#order_status_url').length > 0) {
    window.setInterval(function() {
      $.ajax({
        url: $('#order_status_url').val(),
        type: 'GET',
        dataType: 'json',
        success: function(res) {
          if (res.status === 1) {
            window.location.href = $('#payment_succeed_url').val();
          }
        }
      });
    }, 7000);
  }
  $("#new_order").submit(function(){
    if($("#order_remark").val().length>255){
      $("#order-remark-error").text("补充说明太长啦,请简述!");
      return false;
    }
  })
});
