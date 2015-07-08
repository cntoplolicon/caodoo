// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function() {
  $('.refund_record_new_action, .refund_record_edit_action').click(function(event) {
    event.preventDefault();
    $('#team_return_goods_popup').load($(this).attr('href'), function() {
      $('#team_return_goods_popup').show();
    });
  });
  $('#team_return_goods_popup').on('click', '.return_good_reset', function() {
      $('#team_return_goods_popup').hide();
  });
  $('#team_return_goods_popup').on('click', '.return_good_submit', function(event) {
    event.preventDefault();


    if(validate_address()){

      var form = $(this).closest('form');
      $.ajax({
        url: form.attr('action'),
        data: form.serializeArray(),
        type: 'POST',
        statusCode: {
          400: function(xhr) {
            $('#team_return_goods_popup').html(xhr.responseText);
          },
          302: function() {
            window.location.reload();
          },
          200: function() {
            window.location.reload();
          }
        }
      });

    }

  });
});
$(document).ready(function(){
  $(".refund_record_remark_action").click(function(){
    $(".refund_record_remark_message").text($(this).data('message'));
    $("#refund_record_remark_box").show();
  });
  $(".close_refund_record_remark_button").click(function(){
    $("#refund_record_remark_box").hide();
  });


});


function validate_address(){

  var b=true;

  if($("#refund_record_order_number").val()==""){


    $("#refund_record_order_number_error").text("订单号不能为空");

    b=false;

  }else{

    $("#refund_record_order_number_error").text("");

  }

  if($("#refund_record_receiver").val()==""){


    $("#refund_record_receiver_error").text("收件人姓名不能为空");

    b=false;

  }else{

    $("#refund_record_receiver_error").text("");

  }


  if($("#refund_record_express_id").val()==""){

    $("#refund_record_express_error").text("快递公司不能为空");

    b=false;

  }else{

    $("#refund_record_express_error").text("");

  }

  if($("#refund_record_tracking_number").val()==""){

    $("#refund_record_tracking_number_error").text("运单号不能为空");

    b=false;

  }else{

    $("#refund_record_tracking_number_error").text("");

  }

  return b;


}