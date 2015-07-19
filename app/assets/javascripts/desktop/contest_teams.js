// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function() {
  var adapt_height = Math.max($(window).height(), $('.team_client_detail_container').height() + 64);
  $('.team_client_block_container_menu').css('height', adapt_height - 24);
  $(".game-header-setting").click(function() {
    $("#game_header_management_menu").toggle();
  });
  if ($('.team_client_block_container').length > 0) {
    $(window).on("debouncedresize", function() {
      var resize_height = Math.max($(window).height(), $('.team_client_detail_container').height() + 64);
      $('.team_client_block_container_menu').css('height', resize_height - 24);
    });
  }
});

$(document).ready(function() {
  $('.team_share_link_product .bdsharebuttonbox').each(function() {
    var productPanel = $(this).closest('.team_share_link_product');
    var productName = productPanel.find('.team_share_link_detail_name').text();
    var productUrl = productPanel.find('.team_share_link_detail_url a').text();
    $(this).csns({
      title: productName,
      url: productUrl
    });
    productPanel.find('.team_share_link_product_qrcode_img').qrcode({
      size: 140,
      color: "#3a3",
      text: productUrl
    });
  });

  $(".team_performance_tab a").click(function() {
    $(".team_performance_tab a").removeAttr("class");
    $(this).attr("class", "current_tab");
    if ($(this).attr("id") === "team_performance_data_total") {
      $("#team_performance_top_results_total").show();
      $("#team_performance_top_results_today").hide();
    } else {
      $("#team_performance_top_results_total").hide();
      $("#team_performance_top_results_today").show();
    }
  });
  $(".team_performance_bottom_tab a").click(function() {
    $(".team_performance_bottom_tab a").removeAttr("class");
    $(this).attr("class", "current_tab");
    if ($(this).attr("id") === "team_performance_amounts_total") {
      $("#team_performance_bottom_table_total").show();
      $("#team_performance_bottom_table_today").hide();
    } else {
      $("#team_performance_bottom_table_total").hide();
      $("#team_performance_bottom_table_today").show();
    }
  });

  //login team  validate

  $("#new_contest_team").submit(function() {
    var b = true;
    if (!$("#contest_team_phone").val().match(validate_regex.username)) {
      $("#contest_team_phone_error").text(validate_message.username.invalid);
      b = false;
    } else {
      $("#contest_team_phone_error").text("");
    }

    if (!$("#contest_team_password").val().match(validate_regex.password)) {
      $("#contest_team_password_error").text(validate_message.password.invalid);
      b = false;
    } else {
      $("#contest_team_password_error").text("");
    }
    return b;
  });

  //update team pwd validate
  $("#team-client-reset-pwd").submit(function() {
    var b = true;
    if (!$("#old_password").val().match(validate_regex.password)) {
      $("#old_password_error").text(validate_message.password.invalid);
      b = false;
    } else {
      $("#old_password_error").text("");
    }

    if (!$("#contest_team_password").val().match(validate_regex.password)) {
      $("#contest_team_password_error").text(validate_message.password.invalid);
      b = false;
    } else {
      $("#contest_team_password_error").text("");
    }

    if (!$("#contest_team_password_confirmation").val().match(validate_regex.password)) {
      $("#contest_team_password_confirmation_error").text(validate_message.password.invalid);
      b = false;
    } else {
      $("#contest_team_password_confirmation_error").text("");
    }

    // compare
    if (!($("#contest_team_password").val() == $("#contest_team_password_confirmation").val())) {
      $("#contest_team_password_confirmation_error").text(validate_message.password.password_confirmation.confirmation);
      b = false;
    } else {
      $("#contest_team_password_confirmation_error").text("");
    }
    return b;
  });
});
