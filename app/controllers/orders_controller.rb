class OrdersController < ApplicationController
  before_action :find_user, except: [:new]
  before_action :find_user_or_login, only: [:new]

  def new
    @addresses = @user.addresses.order(created_at: :desc)
    @order = @user.orders.build
    default_address = @addresses.find(&:default)
    if default_address.present?
      @order.address_id = default_address.id
    elsif @addresses.any?
      @order.address_id = @addresses[0].id
    end

    quantity = params[:quantity].to_i
    quantity = [quantity, 1].max
    quantity = [quantity, Settings.sale.max_quantity].min
    @order.quantity = quantity

    @product = Product.find(params[:product_id])
    @order.product_id = @product.id
  end

  def index
    if params[:status].present?
      @orders = @user.orders.where(status: params[:status]).order(created_at: :desc)
    else
      @orders = @user.orders.order(created_at: :desc)
    end
    render layout: 'account_setting'
  end

  def show
    @order = @user.orders.find(params[:id])
    render layout: 'account_setting'
  end

  private

  def find_user
    redirect_to login_users_url and return unless session[:login_user_id].present?
    user_id = params[:user_id].to_i
    head :forbidden and return if user_id != session[:login_user_id]
    @user = User.find(user_id)
  end

  def find_user_or_login
    if params[:user_id].to_i == 0
      session[:return_to] = request.original_url.sub('users/0', 'users/%{user_id}')
      redirect_to login_users_url
    else
      find_user
    end
  end
end
