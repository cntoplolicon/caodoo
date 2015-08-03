class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  before_action :check_for_mobile

  protect_from_forgery with: :exception

  def send_sms_message(mobile, msg)
    uri = URI "http://222.73.117.158/msg/HttpBatchSendSM"
    params = {account: Settings.sms.username, pswd: Settings.sms.password, mobile: mobile, msg: msg}
    uri.query = URI.encode_www_form(params)
    Net::HTTP.get(uri)
  end

  def generate_security_code
    (1..6).map { rand(10) }.join
  end

  def check_for_mobile
    session[:mobile_override] = params[:mobile] if params[:mobile]
    prepare_for_mobile if mobile_device?
  end

  def prepare_for_mobile
    prepend_view_path Rails.root + 'app' + 'views_mobile'
  end

  def mobile_device?
    if session[:mobile_override]
      session[:mobile_override] == "1"
    else
      (request.user_agent =~ /Mobile|webOS/) && (request.user_agent !~ /iPad/)
    end
  end

  def wechat_browser?
    request.user_agent =~ /MicroMessenger/
  end

  helper_method :mobile_device?, :wechat_browser?
end
