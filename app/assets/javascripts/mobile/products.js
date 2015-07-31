// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

(function(window, $) {
  $(document).ready(function() {
    var productsAutoLayout = $('.on-sale-products').masonry({
      itemSelector: '.on-sale-product',
      transitionDuration: 0
    });
    productsAutoLayout.imagesLoaded().progress(function() {
      productsAutoLayout.masonry('layout');
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

    if ($('.on-sale-time-left').length > 0) {
      productDetailCountDown();
      window.setInterval(productDetailCountDown, 1000);
    };

    $(".othmenu").click(function() {
      $(".menu_list").toggle();
    });

    $(".dropdown_action").click(function() {
      $(".children_list").toggle();
    });

    var update_quantity_and_price = function() {
      if ($("#unit-price-field").length > 0) {
        var quantity = parseInt($('.quantity-number').val());
        var unit_price = parseFloat($('#unit-price-field').val());
        $('.quantity-display').text(quantity);
        $('.total-price-display').text((quantity * unit_price).toFixed(2));
      }
    }
    update_quantity_and_price();
    $('.quantity-controller-decrease').click(function() {
      $('.quantity-number').val(Math.max(parseInt($('.quantity-number').val()) - 1, 1));
      update_quantity_and_price();
    });
    $('.quantity-controller-increase').click(function() {
      $('.quantity-number').val(Math.min(parseInt($('.quantity-number').val()) + 1, $('#quantity-limit-field').val()));
      update_quantity_and_price();
    });
    $('.quantity-number').change(function() {
      var quantity = parseInt($('.quantity-number').val());
      if (isNaN(quantity)) {
        quantity = 1;
      }
      quantity = Math.max(quantity, 1);
      quantity = Math.min(quantity, $('#quantity-limit-field').val());
      $('.quantity-number').val(quantity);
      update_quantity_and_price();
    });

    $('.product-detail .purchase-button').click(function(event) {
      event.preventDefault();
      var link = $(this).closest('a');
      window.location.href = link.attr('href') + '&quantity=' + $('.quantity-number').val();
    });

    var mySwiper = new Swiper('.swiper-container', {
      loop: true,
      grabCursor: true,
      paginationClickable: true
    })
    $('.arrow-left').on('click', function(e) {
      e.preventDefault()
      mySwiper.swipePrev()
    })
    $('.arrow-right').on('click', function(e) {
      e.preventDefault()
      mySwiper.swipeNext()
    })

    $('.product-detail-share').csns({
      title: '我们参加了大学生营销策划赛，向你推荐' + $('.product-name').text() + ', 来看看吧~',
      desc: '我们参加了大学生营销策划赛，向你推荐' + $('.product-name').text() + ', 来看看吧~',
      pic: $('.swiper-slide-visible .product-detail-image').prop('src'),
      wechat_client_sharing: true
    });

    function isElementInViewport (el) {
      if (el.length === 0) {
        return ;
      }
      el = el[0];
      var rect = el.getBoundingClientRect();
      return rect.top + rect.height > 0;
    }

    var showBottomButton = function() {
      if (isElementInViewport($('.product-detail .purchase-button'))) {
        $('.mobile-purchase-bottom').hide()
      } else {
        $('.mobile-purchase-bottom').show();
      }
    }

    $(window).on('DOMContentLoaded load scroll', showBottomButton);
  });
})(this, jQuery);
