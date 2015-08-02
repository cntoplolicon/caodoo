// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

(function(window, $) {
  $(document).ready(function() {
    var productsAutoLayout = $('.on-sale-products').masonry({
      itemSelector: '.on-sale-product'
    });
    $('.on-sale-products img.lazy').lazyload({
      effect: 'fadeIn',
      threshold : 200
    });

    $('.on-sale-products .product-original-price').click(function(event) {
      var link = $(this).data('original-price-link');
      if (link) {
        event.preventDefault();
        window.open(link);
      }
    });

    var countDown = function() {
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
      var time = $('#remain-time-hidden-field').val();
      time = Math.max(time - 1, 0);
      var remainTimeString = showRemainTime(time);
      $('#remain-time-hidden-field').val(time);
      $('.show-remain-time').text(remainTimeString);
    };

    if ($('.product-detail-countdown').length > 0) {
      productDetailCountDown();
      window.setInterval(productDetailCountDown, 1000);
    };

    var update_quantity_and_price = function() {
      if ($("#unit-price-field").length > 0) {
        var quantity = parseInt($('.quantity-input').val());
        var unit_price = parseFloat($('#unit-price-field').val());
        $('.total-price-display').text((quantity * unit_price).toFixed(2));
      }
    }
    update_quantity_and_price();
    $('.quantity-controller-decrease').click(function() {
      $('.quantity-input').val(Math.max(parseInt($('.quantity-input').val()) - 1, 1));
      update_quantity_and_price();
    });
    $('.quantity-controller-increase').click(function() {
      $('.quantity-input').val(Math.min(parseInt($('.quantity-input').val()) + 1, $('#quantity-limit-field').val()));
      update_quantity_and_price();
    });
    $('.quantity-input').change(function() {
      var quantity = parseInt($('.quantity-input').val());
      if (isNaN(quantity)) {
        quantity = 1;
      }
      quantity = Math.max(quantity, 1);
      quantity = Math.min(quantity, $('#quantity-limit-field').val());
      $('.quantity-input').val(quantity);
      update_quantity_and_price();
    });

    var mySwiper = new Swiper('.swiper-container', {
      loop: true,
      grabCursor: true,
      paginationClickable: true
    })
    $('.product-detail-thumbnail').click(function() {
      mySwiper.swipeTo($(this).index());
    });
    $('.arrow-left').on('click', function(e) {
      e.preventDefault()
      mySwiper.swipePrev()
    })
    $('.arrow-right').on('click', function(e) {
      e.preventDefault()
      mySwiper.swipeNext()
    })

    $('.product-detail .purchase-button').click(function(event) {
      event.preventDefault();
      var link = $(this).closest('a');
      window.location.href = link.attr('href') + '&quantity=' + $('.quantity-input').val();
    });

    $('.product-detail-share').csns({
      title: '我们参加了大学生营销策划赛，向你推荐' + $('.product-name').text() + ', 来看看吧~',
      desc: '我们参加了大学生营销策划赛，向你推荐' + $('.product-name').text() + ', 来看看吧~',
      pic: $('.swiper-slide-visible .product-detail-image').prop('src')
    });
  });
})(this, jQuery);
