// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

(function (window, $) {
  $(document).ready(function() {
    $('.on-sale-products').masonry({
      itemSelector: '.on-sale-product'
    });

    $('.trailer-panel').hide();
    $('.upcoming-product').hover(function() {
      $(this).find('.brand-image').hide();
      $(this).find('.trailer-panel').show();
    }, function() {
      $(this).find('.brand-image').show();
      $(this).find('.trailer-panel').hide();
    });

    var countDown =  function() {
      $('.product-sale-remain-time').each(function() {
        var time = $(this).data('time');
        time = Math.max(time - 1, 0);
        $(this).data('time', time);
        $(this).text(time);
      });
    };
    window.setInterval(countDown, 1000);
    countDown();

    $('#product-detail-carousel').carousel({
      interval: false,
      wrap: false,
      keyboard: false
    });

    $('.product-detail-thumbnail').click(function() {
      $('#product-detail-carousel').carousel($(this).index());
    });
  });
})(this, jQuery);
