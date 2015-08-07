class CouponsController < ApplicationController
  before_action :find_user

  def index
    @coupons = @user.coupons.where('coupons.order_id' => nil).order(end_date: 'desc')
  end

  private
  def find_user
    redirect_to login_users_url and return unless session[:login_user_id].present?
    user_id = params[:user_id].to_i
    head :forbidden and return if user_id != session[:login_user_id]
    @user = User.find(user_id)
  end
end
