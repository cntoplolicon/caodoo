class OrdersController < ApplicationController
  before_action :find_user, except: [:new]
  before_action :find_user_and_order, only: [:payment, :payment_succeed, :status]
  before_action :find_user_or_login, only: [:new]

  def new
    @order = @user.orders.build
    load_order_addresses

    quantity = params[:quantity].to_i
    quantity = [quantity, 1].max
    quantity = [quantity, Settings.sale.max_quantity].min
    @order.quantity = quantity

    @product = Product.find(params[:product_id])
    @order.product_id = @product.id
    if @product.contest_product?
      if session[:contest_team_id].present?
        @contest_team = ContestTeam.find(session[:contest_team_id])
      else
        @contest_team = ContestTeam.find_by_identifier(Settings.contest.default_team_identifier)
      end
    end
  end

  def create
    @order = Order.new(order_params)
    @product = Product.where(id: @order.product_id).joins(:product_sale_schedules, :product_view => :product_carousel_images)
      .includes(:product_sale_schedules, :product_view => :product_carousel_images)
      .take
    @address = @user.addresses.find(@order.address_id) if @order.address_id.present?
    unless @address.present?
      @order.errors.add(:address_id, '请选择收货地址')
      render 'new' and return
    end

    @onsale = @product.product_sale_schedules.any? do |s|
      s.sale_start < Time.now && s.sale_end > Time.now
    end
    redirect_to action: :sold_out, controller: :standalone and return unless @onsale

    @order.build_payment_record(status: PaymentRecord::TO_PAY)
    head :forbidden and return if @order.user_id != @user.id
    @order.order_number = "#{'%07d' % @order.user_id}#{(Time.now.to_f * 1000).to_i}"
    @order.product_name = @product.name
    @order.product_image_url = @product.product_view.product_carousel_images[0].url
    @order.unit_price = @product.price
    @order.total_price = @order.quantity * @product.price
    @order.status = Order::TO_PAY
    @order.receiver = @address.receiver
    @order.phone = @address.phone
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
    if @product.contest_product?
      if session[:contest_team_id].present?
        @contest_team = ContestTeam.find(session[:contest_team_id])
      else
        @contest_team = ContestTeam.find_by_identifier(Settings.contest.default_team_identifier)
      end
      head :bad_request and return if  @product.contest_level > @contest_team.level
      @order.contest_team_id = @contest_team.id
    end

    Order.transaction do
      updated_record = Product.where(id: @order.product_id).where('quantity >= ?', @order.quantity).
        update_all(['quantity = quantity - ?', @order.quantity])
      if updated_record == 0
        if @product.quantity <= 0
          render 'standalone/sold_out' and return if @product.quantity <= 0
        else
          @order.errors.add(:quantity, "库存仅剩下#{@product.quantity}件")
          render 'new' and return
        end
      end
      if @order.save
        redirect_to user_order_payment_url(@user, @order) and return
      else
        raise ActiveRecord::Rollback
      end
    end
    render 'new'
  end

  def update
    Order.transaction do
      @order = @user.orders.lock.find(params[:id])
      status = params[:order][:status].to_i
      if status == Order::CANCELLED
        if @order.status == Order::TO_PAY
          @order.status = Order::CANCELLED
          @order.payment_record.status = PaymentRecord::CANCELLED
          @order.save
        elsif @order.status == Order::PAID
          @order.status = Order::CANCELLING
          @order.save
        end
      elsif status == Order::COMPLETE
        if @order.status == Order::DELIVERED
          @order.status = Order::COMPLETE
          @order.receive_time = Time.now
          @order.save
        end
      end
      redirect_to user_order_path(@user, @order)
    end
  end

  def index
    if params[:status].present?
      @orders = @user.orders.where(status: params[:status]).order(created_at: :desc)
    else
      @orders = @user.orders.order(created_at: :desc)
    end
    @order_count = @user.orders.count
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
    Order.transaction do
      @order = @user.orders.lock.find(order_id)
      if @order.status == Order::TO_PAY && Time.now > @order.created_at + Settings.payment.expired.to_i.minutes
        @order.status = Order::TIMEOUT
        @order.payment_record.status = PaymentRecord::TIMEOUT
        @order.save
        Product.where(id: @order.product_id).update_all(["quantity = quantity + ?", @order.quantity])
      end
    end
  end

  def load_order_addresses
    @addresses = @user.addresses.where(deleted: false).order(updated_at: :desc)
    default_address = @addresses.find(&:default)
    if params[:address]
      @order.address_id = params[:address].to_i
    elsif default_address.present?
      @order.address_id = default_address.id
    elsif @addresses.any?
      @order.address_id = @addresses[0].id
    end
  end

  def order_params
    params.require(:order).permit(:address_id, :product_id, :quantity, :user_id)
  end
end
