module WxApi
  class << self
    def refresh_access_token
      uri = URI('https://api.weixin.qq.com/cgi-bin/token')
      query_params = {grant_type: 'client_credential', appid: Settings.wx_api.app_id, secret: Settings.wx_api.app_secret}
      res = get_json_response(uri, query_params)
      token = res[:access_token]
      expires_in = res[:expires_in].to_i.seconds
      unless token.nil?
        Rails.cache.write(:wx_api_access_token, token, expires_in: expires_in)
      end
      token
    end

    def access_token
      token = Rails.cache.read(:wx_api_access_token)
      return token unless token.nil?
      refresh_access_token
    end

    def refresh_jsapi_ticket
      uri = URI('https://api.weixin.qq.com/cgi-bin/ticket/getticket?')
      query_params = {access_token: access_token, type: 'jsapi'}
      res = get_json_response(uri, query_params)
      if [40001, 40014, 42001].include?(res[:errcode])
        query_params = {access_token: refresh_access_token, type: 'jsapi'}
        res = get_json_response(uri, query_params)
      end
      ticket = res[:ticket]
      expires_in = res[:expires_in].to_i.seconds
      unless ticket.nil?
        Rails.cache.write(:wx_jsapi_ticket, ticket, expires_in: expires_in)
      end
      ticket
    end

    def jsapi_ticket
      ticket = Rails.cache.read(:wx_jsapi_ticket)
      return ticket unless ticket.nil?
      refresh_jsapi_ticket
    end

    def jsapi_sign(url)
      nonce_str = SecureRandom.hex
      timestamp = Time.zone.now.to_i
      sign_str = "jsapi_ticket=#{jsapi_ticket}&noncestr=#{nonce_str}&timestamp=#{timestamp}&url=#{url}"
      signature = Digest::SHA1.hexdigest(sign_str)
      return {
        signature: signature,
        nonce_str: nonce_str,
        timestamp: timestamp
      }
    end

    private

    def get_json_response(uri, query_params)
      uri.query = URI.encode_www_form(query_params)
      JSON.parse(Net::HTTP.get(uri)).deep_symbolize_keys
    end
  end
end
