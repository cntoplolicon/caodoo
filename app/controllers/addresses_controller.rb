class AddressesController < ApplicationController
  before_action :find_user

  def index
    @addresses = @user.addresses
    render layout: 'account_setting'
  end

  private

  def find_user
    user_id = params[:user_id].to_i
    head :forbidden if user_id != session[:login_user_id]
    @user = User.find(user_id)
  end
end
