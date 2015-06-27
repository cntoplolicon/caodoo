class StandaloneController < ApplicationController
  def about_us
  end

  def custom_service
    render layout: 'account_setting'
  end
end
