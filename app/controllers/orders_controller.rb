class OrdersController < ApplicationController
  before_action :find_user, except: [:new]
  before_action :find_user_and_order, only: [:payment, :payment_succeed, :status]
  before_action :find_user_or_login, only: [:new]

  def new
    @addresses = @user.addresses.where(deleted: false).order(created_at: :desc)
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

  def create
    @order = Order.new(order_params)
    @order.build_payment_record(status: PaymentRecord::TO_PAY)
    head :forbidden and return if @order.user_id != @user.id

    @product = Product.where(id: @order.product_id).lock.joins(:product_sale_schedules, :product_view => :product_carousel_images)
      .includes(:product_sale_schedules, :product_view => :product_carousel_images)
      .take
    @onsale = @product.product_sale_schedules.any? do |s|
      s.sale_start < Time.now && s.sale_end > Time.now
    end 
    render action: :sold_out, controller: :standalone unless @onsale
    
    if @order.invalid?
      render 'new' and return
    end

    @address = @user.addresses.find(@order.address_id)

    @order.order_number = '%010d' % @order.user_id + Time.now.to_i.to_s
    @order.product_name = @product.name
    @order.product_image_url = @product.product_view.product_carousel_images[0].url
    @order.unit_price = @product.price
    @order.total_price = @order.quantity * @product.price
    @order.receiver = @address.receiver
    @order.phone = @address.phone
    @order.status = Order::TO_PAY
    if @address.province.present?
      @order.province_code = @address.province.code
      @order.province_name = @address.province.name
    end
    if @address.city.present?
      @order.city_code = @address.city.code
      @order.city_name = @address.city.name
    end
    if @address.district.present?
      @order.district_code = @address.district.code
      @order.district_name = @address.district.name
    end
    @order.detailed_address = @address.detailed_address

    if @order.save
      redirect_to user_order_payment_url(@user, @order)
    else
      render 'new'
    end
  end

  def update
    @order = @user.orders.lock.find(params[:id])
    if params[:order][:status].to_i == Order::CANCELLED && @order.status == Order::TO_PAY
      @order.status = Order::CANCELLED
      @order.payment_record.status = PaymentRecord::CANCELLED
      @order.save
    end
    redirect_to action: :index
  end

  def index
    if params[:status].present?
      @orders = @user.orders.where(status: params[:status]).order(created_at: :desc)
    else
      @orders = @user.orders.order(created_at: :desc)
    end
    @orders.each do |order|
      if time_out?(order)
        try_cancel_timeout_order(order.id)
      end
    end
    render layout: 'account_setting'
  end

  def show
    @order = @user.orders.find(params[:id])
    if time_out?(@order)
      try_cancel_timeout_order(@order.id)
    end
    render layout: 'account_setting'
  end

  def payment
    if time_out?(@order)
      redirect_to user_order_payment_timeout_path(@user, @order)
    end
  end

  def payment_timeout
    try_cancel_timeout_order(params[:order_id])
  end

  def payment_succeed
  end

  def status
    render json: {status: @order.status}
  end

  private

  def find_user
    redirect_to login_users_url and return unless session[:login_user_id].present?
    user_id = params[:user_id].to_i
    head :forbidden and return if user_id != session[:login_user_id]
    @user = User.find(user_id)
  end

  def find_user_and_order
    find_user
    @order = @user.orders.find(params[:order_id])
  end

  def find_user_or_login
    if params[:user_id].to_i == 0
      session[:return_to] = request.original_url.sub('users/0', 'users/%{user_id}')
      redirect_to login_users_url
    else
      find_user
    end
  end

  def time_out?(order)
    Time.now > order.created_at + Settings.payment.expired.to_i.minutes
  end

  def try_cancel_timeout_order(order_id)
    @order = @user.orders.lock.find(order_id)
    if @order.status == Order::TO_PAY && Time.now > @order.created_at + Settings.payment.expired.to_i.minutes
      @order.status = Order::TIMEOUT
      @order.payment_record.status = PaymentRecord::TIMEOUT
      @order.save
    end
  end

  def order_params
    params.require(:order).permit(:address_id, :product_id, :quantity, :user_id)
  end
end
