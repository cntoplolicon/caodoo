class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  def send_sms_message(mobile, msg)
    uri = URI "http://222.73.117.158/msg/HttpBatchSendSM"
    params = {account: Settings.sms.username, pswd: Settings.sms.password, mobile: mobile, msg: msg}
    uri.query = URI.encode_www_form(params)
    Net::HTTP.get(uri)
  end

  def generate_security_code
    (1..6).map {rand(10)}.join
  end
end
