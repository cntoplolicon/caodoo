module ExpressTracker
  def self.track_express(exp_code, exp_no)
    uri = URI('http://route.showapi.com/64-19')
    query_params = {showapi_appid: Settings.show_api.app_id, showapi_sign: Settings.show_api.sign,
                    showapi_timestamp: Time.zone.now.strftime('%Y%m%d%H%M%S'), com: exp_code, nu: exp_no}
    uri.query = URI.encode_www_form(query_params)
    res = Net::HTTP.get_response(uri)
    JSON.parse(res.body).deep_symbolize_keys
  end
end
