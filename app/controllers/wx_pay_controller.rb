require 'ipaddr'

class WxPayController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:notify]

  def pay
    Order.transaction do
      @order = Order.lock.find(params[:order_id])
      redirect_to user_order_payment_timeout_path(@order.user_id, @order) and return if @order.payment_expired?

      head :forbidden if @order.user_id != session[:login_user_id]
      if @order.payment_record.wx_code_url.present?
        @code_url = @order.payment_record.wx_code_url
      else
        options = unify_order_params(@order, 'NATIVE')
        r = WxPay::Service.invoke_unifiedorder(options)
        raise r unless r.success?
        @order.payment_record.wx_code_url = r['code_url']
        @order.save(validate: false)
        @code_url = r['code_url']
      end
    end
  end

  def pay_by_jsapi
    Order.transaction do
      @order = Order.lock.find(params[:order_id])
      render json: {redirect: true, url: user_order_payment_timeout_path(@order.user_id, @order)} and return if @order.payment_expired?

      head :forbidden if @order.user_id != session[:login_user_id]
      if @order.payment_record.prepay_id.present?
        @prepay_id = @order.payment_record.prepay_id
      else
        options = unify_order_params(@order, 'JSAPI')
        r = WxPay::Service.invoke_unifiedorder(options)
        raise r unless r.success?
        @order.payment_record.prepay_id = r['prepay_id']
        @order.save(validate: false)
        @prepay_id = r['prepay_id']
      end

      sign_options = {
        appId: Settings.wx_api.app_id,
        timeStamp: Time.zone.now.to_i.to_s,
        nonceStr: SecureRandom.hex,
        package: "prepay_id=#{@prepay_id}",
        signType: 'MD5'
      }
      payment_option = {
        timestamp: sign_options[:timeStamp],
        nonceStr: sign_options[:nonceStr],
        package: sign_options[:package],
        signType: sign_options[:signType],
        paySign: WxPay::Sign.generate(sign_options)
      }
      render json: payment_option
    end
  end

  def notify
    r = Hash.from_xml(request.body.read)['xml'].symbolize_keys
    if WxPay::Sign.verify?(r)
      Order.transaction do
        order = Order.lock.find_by_order_number(r[:out_trade_no])
        if order.status == Order::TO_PAY
          order.status = Order::PAID
          order.payment_record.payment_type = PaymentRecord::WECHAT
          order.payment_record.status = PaymentRecord::PAID
          order.payment_record.amount = r[:total_fee].to_f / 100
          order.payment_record.payment_time = Time.zone.now
          ContestTeam.where(id: order.contest_team_id).update_all(['sales_quantity = sales_quantity + ?', order.quantity]) if order.contest_team_id.present?
          head :unprocessable_entity and return unless order.save
        end
      end
      render :xml => {return_code: 'SUCCESS', return_msg: 'OK'}.to_xml(root: 'xml', dasherize: false)
    else
      render :xml => {return_code: 'FAIL', return_msg: "签名失败"}.to_xml(root: 'xml', dasherize: false)
    end
  end

  private
  
  def unify_order_params(order, trade_type)
    payment_expire_at = order.created_at + Settings.payment.expired.to_i.minutes
    payment_created_at = Time.zone.now
    wx_payment_expire_at = [payment_created_at + 5.minutes, payment_expire_at].max
    remote_ip = IPAddr.new(request.remote_ip)
    remote_ip = remote_ip.ipv6? ? '127.0.0.1' : remote_ip.to_s
    options = {
      body: order.product_name,
      out_trade_no: order.order_number,
      spbill_create_ip: remote_ip,
      time_start: payment_created_at.localtime.strftime('%Y%m%d%H%M%S'),
      time_expire: wx_payment_expire_at.localtime.strftime('%Y%m%d%H%M%S'),
      notify_url: "#{root_url}/wx_pay/notify",
      trade_type: trade_type,
      nonce_str: SecureRandom.hex,
    }
    options[:openid] = params[:openid] if trade_type == 'JSAPI'
    if Rails.env.development? then
      options[:total_fee] = order.quantity
    else
      options[:total_fee] = (order.total_price * 100).round
    end
    options
  end
end
