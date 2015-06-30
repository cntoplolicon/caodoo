class StandaloneController < ApplicationController

  def payment_timeout
  end

  def sold_out
  end

  def about_us
  end

  def custom_service
    render layout: 'account_setting'
  end
end
