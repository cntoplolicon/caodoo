class OrdersController < ApplicationController
  layout 'account_setting'

  before_action :find_user

  def index
    if params[:status].present?
      @orders = @user.orders.where(status: params[:status]).order(created_at: :desc)
    else
      @orders = @user.orders.order(created_at: :desc)
    end
  end

  def show
    @order = @user.orders.find(params[:id])
  end

  private

  def find_user
    user_id = params[:user_id].to_i
    head :forbidden if user_id != session[:login_user_id]
    @user = User.find(user_id)
  end
end
