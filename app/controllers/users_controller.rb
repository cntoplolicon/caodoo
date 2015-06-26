class UsersController < ApplicationController
  layout 'user_op'

  def login
    @user = User.new
  end

  def do_login
  end

  def forget_password
    @user = User.new
  end

  def verify_forget_password_security_code
  end

  def do_forget_password
  end

  def reset_password
    @user = User.new
  end

  def do_reset_password
  end

  def logout
    session.delete(:login_user_id)
    redirect_to :login
  end

  def create
  end

  def new
    @user = User.new
  end

  private 

  def user_params
    params.permit(:username, :password)
  end

  def send_security_code_over_sms(username)
    security_code = generate_security_code
    params = {security_code: security_code}
    session[:security_code] = security_code
    session[:security_code_expire] = Time.now + Settings.security_code.expired
    session[:security_code_user] = username
    message = Settings.security_code.sms_template % params
    session[:user_to_verify] = username
    if Settings.security_code.disabled
      render json: {message: message}
    else
      send_sms_message(username, message)
      head :ok
    end
  end

  def verify_security_code
    username = params[:username]
    render status: :forbidden, json: {error: 'SecurityCodeIncorrect'} and return false unless session[:security_code]
    render status: :forbidden, json: {error: 'SecurityCodeIncorrect'} and return false if params[:securityCode] != session[:security_code]
    time_compared = Time.now <=> session[:security_code_expire]
    render status: :forbidden, json: {error: 'SecurityCodeExpired'} and return false if time_compared == 1
    render status: :forbidden, json: {error: 'UsernameMismatch'} and return false if params[:username] != username
    params.delete(:verifyCode)
    session[:user_verified] = username
    return true
  end

  def clear_verify_information
    session.delete(:security_code_expire)
    session.delete(:security_code)
    session.delete(:user_to_verify)
    session.delete(:user_verified)
  end
end
