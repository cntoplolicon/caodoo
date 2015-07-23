module ExpressTracker
  def self.track_express(exp_code, exp_no)
    uri = URI('http://www.aikuaidi.cn/rest/')
    query_params = {key: Settings.express_tracker.key, order: exp_no, id: exp_code, ord: 'desc'}
    uri.query = URI.encode_www_form(query_params)
    res = Net::HTTP.get_response(uri)
    json_res = JSON.parse(res.body).deep_symbolize_keys
    json_res[:data].present? ? json_res[:data] : []
  end
end
