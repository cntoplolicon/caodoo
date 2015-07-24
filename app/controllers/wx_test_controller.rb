class WxTestController < ApplicationController
  def index
    render text: WxApi.access_token
  end
end
