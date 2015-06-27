class UsersController < ApplicationController
  layout 'user_op'

  def login
    @user = User.new
  end

  def do_login
    @user = User.find_by_username(params[:user][:username])
    unless @user.present?
      @user = User.new
      @user.errors.add(:username, '用户名不存在')
      render 'login' and return
    end
    unless @user.authenticate(params[:user][:password])
      @user.errors.add(:password, '密码不正确')
      render 'login' and return
    end
    session[:login_user_id] = @user.id
    session[:login_user_name] = @user.username
    redirect_to(session[:return_to] || '/')
  end

  def logout
    session.delete(:login_user_id)
    session.delete(:login_user_name)
    redirect_to :login
  end

  def forget_password
    @user = User.new
  end

  def reset_password
    @user = User.find_by_username(params[:user][:username])
    unless @user.present?
      @user = User.new
      @user.errors.add(:username, '用户名不存在')
      render 'forget_password' and return
    end
    security_code = params[:user][:security_code]
    @user.security_code = security_code
    render 'forget_password' and return unless verify_security_code(security_code)
  end

  def new
    @user = User.new
    @user.terms_of_service = true
  end

  def create
    @user = User.new(user_params)
    security_code = params[:user][:security_code]
    @user.security_code = security_code
    user_valid = @user.valid?
    security_code_verified = verify_security_code(security_code)
    render 'new' and return unless security_code_verified && user_valid
    unless @user.save
      render 'new'
    else
      clear_verify_information
      session[:login_user_id] = @user.id
      session[:login_user_name] = @user.username
      redirect_to(session[:return_to] || '/')
    end
  end

  def terms_of_service
  end

  def reset_password_done
  end

  def update
    user_id = params[:id].to_i
    if params[:user].has_key?(:username)
      # code goes here
    elsif params[:user].has_key?(:oldPassword)
      # code goes here
    elsif params[:user].has_key?(:password)
      @user = User.find(user_id)
      head :forbidden and return unless @user.username == session[:user_verified]
      @user.password = params[:user][:password]
      if params[:user][:password] != params[:user][:password_confirmation]
        @user.errors.add(:password_confirmation, '两次输入的密码不一致')
        render 'reset_password' and return
      end
      render 'reset_password' and return unless @user.save
      clear_verify_information
      redirect_to action: :reset_password_done
    else
      head :bad_request
    end
  end

  def get_security_code_for_new_user
    username = params[:username]
    @user = User.find_by_username(username)
    render status: :bad_request, json: {error: '用户名已存在'} and return if @user.present?
    @user = User.new(username: username)
    if @user.invalid? && @user.errors[:username].any?
      render status: :bad_request, json: {error: @user.errors[:username].first} and return
    end
    send_security_code_over_sms(username)
  end

  def get_security_code_for_password
    username = params[:username]
    @user = User.new(username: username)
    if @user.invalid? && @user.errors[:username].any?
      render status: :bad_request, json: {error: @user.errors[:username].first} and return
    end
    @user = User.find_by_username(username)
    render status: :bad_request, json: {error: '用户名不存在'} and return unless @user.present?
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
