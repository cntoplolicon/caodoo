namespace :wx do
  task refresh_tokens: :environment do
    WxApi.refresh_access_token
    WxApi.refresh_jsapi_ticket
  end
end
