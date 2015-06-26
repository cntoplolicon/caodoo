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
    @user = User.new(user_params)
    security_code = params[:user][:security_code]
    @user.security_code = security_code
    unless verify_security_code(security_code)
      render 'new' and return
    end
    unless @user.save
      render 'new'
    else
      clear_verify_information
      session[:login_user_id] = @user.id
    end
  end

  def new
    @user = User.new
    @user.terms_of_service = true
  end

  def terms_of_service
  end

  def get_security_code_for_new_user
    username = params[:username]
    @user = User.find_by_username(username)
    if @user.present?
      render status: :bad_request, json: {error: '用户名已存在'}
    elsif
      @user = User.new(username: username)
      if @user.invalid?(:username)
        render status: :bad_request, json: {error: @user.errors[:username].first}
      else
        send_security_code_over_sms(username)
      end
    end
  end

  def get_security_code_for_password
    username = params[:username]
    user = User.find_by_username(username)
    render status: :not_found, json: {error: 'AccountNotFound'} and return unless user.present?
    send_security_code_over_sms(username)
  end

  def user_params
    params.require(:user).permit(:username, :password, :terms_of_service)
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

  def verify_security_code(security_code)
    @user.errors.add(:security_code, '验证码不能为空') and return false unless security_code.present?
    @user.errors.add(:security_code, '验证码错误') and return false unless session[:security_code]
    @user.errors.add(:security_code, '验证码错误') and return false if security_code != session[:security_code]
    time_compared = Time.now <=> session[:security_code_expire]
    @user.errors.add(:security_code, '验证码已过期') and return false if time_compared == 1
    @user.errors.add(:security_code, '用户名不匹配') and return false if session[:user_to_verify] != @user.username
    session[:user_verified] = @user.username
    return true
  end

  def clear_verify_information
    session.delete(:security_code_expire)
    session.delete(:security_code)
    session.delete(:user_to_verify)
    session.delete(:user_verified)
  end
end
