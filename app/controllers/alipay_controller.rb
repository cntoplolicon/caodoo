class AlipayController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:async_notify]
  before_action :verify_notify_id, :only => [:sync_notify, :async_notify]

  def pay
    Order.transaction do
      @order = Order.lock.find(params[:order_id])
      head :forbidden if @order.user_id != session[:login_user_id]

      expire = @order.created_at + Settings.payment.expired.to_i.minutes
      diff = ((expire - Time.now) / 1.minutes).round
      redirect_to user_order_payment_timeout_path(@user, @order) and return if diff <= 0

      payment_submitted = @order.payment_record.alipay_expire.present?
      unless payment_submitted
        @order.payment_record.alipay_expire = "#{diff}m"
        head :unprocessable_entity and return unless @order.save
      end

      uri = URI(Alipay::Service.create_direct_pay_by_user_url(
        out_trade_no: @order.order_number,
        subject: @order.product_name,
        price: '0.02',
        quantity: @order.quantity,
        return_url: "http://#{request.host_with_port}/alipay/return",
        #return_url: "http://www.caodoo.com:3000/alipay/return",
        #notify_url: "http://www.caodoo.com:3000/alipay/notify",
        it_b_pay: @order.payment_record.alipay_expire
      ))

      unless payment_submitted
        Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
          request = Net::HTTP::Get.new uri
          http.request(request)
        end
      end

      redirect_to(uri.to_s)
    end
  end

  def payment_succeed
    @order = Order.find(params[:order_id])
    head :forbidden if @order.user_id != session[:login_user_id]
  end

  def sync_notify
    Order.transaction do
      !update_order_status and return
      redirect_to user_order_payment_succeed_path(@order.user_id, @order)
    end
  end

  def async_notify
    Order.transaction do
      !update_order_status and return
      render text: 'success'
    end
  end

  private

  def verify_notify_id
    head :bad_request unless params[:out_trade_no] and params[:notify_id]
    uri = URI("https://mapi.alipay.com/gateway.do?service=notify_verify&partner=#{Alipay.pid}&notify_id=#{params[:notify_id]}")
    http = Net::HTTP.start(uri.host, uri.port, use_ssl: true)
    req = Net::HTTP::Get.new(uri)
    resp = http.request(req)
    head :forbidden unless resp.body == 'true'
  end

  def update_order_status
    @order = Order.lock.find_by_order_number(params[:out_trade_no])
    trade_status = params[:trade_status]
    if @order.status == Order::TO_PAY && (trade_status == 'TRADE_FINISHED' || trade_status == 'TRADE_SUCCESS')
      @order.status = Order::PAID
      @order.payment_record.payment_type = PaymentRecord::ALIPAY
      @order.payment_record.status = PaymentRecord::PAID
      if params[:total_fee].present?
        @order.payment_record.amount = params[:total_fee].to_f
      elsif params[:price].present? && params[:quantity].present?
        @order.payment_record.amount = params[:quantity].to_i * params[:price].to_f
      else
        @order.payment_record.amount = @order.total_price
      end
      @order.payment_record.payment_time = Time.now
    end
    head :unprocessable_entity and return false unless @order.save
    true
  end
end
