class WxTestController < ApplicationController
  def access_token
    render text: WxApi.access_token
  end

  def jsapi_ticket
    render text: WxApi.jsapi_ticket
  end
end
