module ExpressTracker
  class << self
    attr_accessor :showapi_appid
    attr_accessor :showapi_sign
  end

  def self.track_express(exp_code, exp_no)
    uri = URI('http://route.showapi.com/64-19')
    query_params = {showapi_appid: @showapi_appid, showapi_sign: @showapi_sign, showapi_timestamp: Time.zone.now.strftime('%Y%m%d%H%M%S'), com: exp_code, nu: exp_no}
    uri.query = URI.encode_www_form(query_params)
    res = Net::HTTP.get_response(uri)
    JSON.parse(res.body)
  end
end
