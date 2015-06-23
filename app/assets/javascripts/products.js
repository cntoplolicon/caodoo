// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

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
});

