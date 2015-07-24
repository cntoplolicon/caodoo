module WxApi
  class << self
    def access_token
      token = Rails.cache.read(:wx_api_access_token)
      return token unless token.nil?

      uri = URI('https://api.weixin.qq.com/cgi-bin/token')
      query_params = {grant_type: 'client_credential', appid: Settings.wx_api.app_id, secret: Settings.wx_api.app_secret}
      uri.query = URI.encode_www_form(query_params)
      res = JSON.parse(Net::HTTP.get(uri)).deep_symbolize_keys
      token = res[:access_token]
      expires_in = res[:expires_in].to_i.seconds
      unless token.nil?
        Rails.cache.write(:wx_api_access_token, token, expires_in: expires_in)
      end
      token
    end
  end
end
