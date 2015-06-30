// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

(function (window, $) {
  $(document).ready(function() {
    $('.on-sale-products').masonry({
      itemSelector: '.on-sale-product'
    });

    var countDown =  function() {
      $('.product-sale-remain-time').each(function() {
        var time = $(this).data('time');
        time = Math.max(time - 1, 0);
        var remainTimeString = showRemainTime(time);
        $(this).data('time', time);
        $(this).text(remainTimeString);
      });
    };

    if ($('.product-sale-remain-time').length > 0) {
      countDown();
      window.setInterval(countDown, 1000);
    };

    var productDetailCountDown = function() {
        var time = $('.hidden').val();
        time = Math.max(time - 1, 0);
        var remainTimeString = showRemainTime(time);
        $('.hidden').val(time);
        $('.show-remain-time').text(remainTimeString);
    };

    if ($('.product-detail-countdown').length > 0) {
      productDetailCountDown();
      window.setInterval(productDetailCountDown, 1000);
    };

    $('.product-detail-thumbnail').click(function() {
      $('.carousel-image').attr('src', $(this).attr('src'));
    });

  });
})(this, jQuery);
