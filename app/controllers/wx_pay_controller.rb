require 'ipaddr'
require 'rqrcode'

class WxPayController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def pay
    @order = Order.lock.find(params[:order_id])
    expire = @order.created_at + Settings.payment.expired.to_i.minutes
    diff = ((expire - Time.now) / 1.minutes).round
    redirect_to user_order_payment_timeout_path(@order.user_id, @order) and return if diff <= 0

    head :forbidden if @order.user_id != session[:login_user_id]
    if @order.payment_record.wx_code_url.present?
      @code_url = @order.payment_record.wx_code_url
    else
      payment_expire_at = @order.created_at + Settings.payment.expired.to_i.minutes
      payment_created_at = Time.now
      wx_payment_expire_at = [payment_created_at + 5.minutes, payment_expire_at].max
      remote_ip = IPAddr.new(request.remote_ip)
      remote_ip = remote_ip.ipv6? ? '127.0.0.1' : remote_ip.to_s
      r = WxPay::Service.invoke_unifiedorder({
        body: @order.product_name,
        out_trade_no: @order.order_number,
        #total_fee: (@order.total_price * 100).round,
        total_fee: 2,
        spbill_create_ip: remote_ip,
        time_start: payment_created_at.localtime.strftime('%Y%m%d%H%M%S'),
        time_expire: wx_payment_expire_at.localtime.strftime('%Y%m%d%H%M%S'),
        trade_type: 'NATIVE',
        notify_url: 'http://www.caodoo.com:3000/wx_pay/notify',
      })
      render status: :internal_server_error, json: {error: r} and return unless r.success?
      @order.payment_record.wx_code_url = r['code_url']
      head :unprocessable_entity and return unless @order.save
      @code_url = r['code_url']
    end
    @qr = RQRCode::QRCode.new(@code_url, size: 5, level: :h)
  end

  def notify
    r = Hash.from_xml(request.body.read)['xml'].symbolize_keys
    if WxPay::Sign.verify?(r)
      order = Order.lock.find_by_order_number(r[:out_trade_no])
      if order.status == Order::TO_PAY
        order.status = Order::PAID
        order.payment_record.payment_type = PaymentRecord::WECHAT
        order.payment_record.status = PaymentRecord::PAID
        order.payment_record.amount = r[:total_fee].to_f / 100
        order.payment_record.payment_time = Time.now
        head :unprocessable_entity and return unless order.save
      end
      render :xml => {return_code: 'SUCCESS', return_msg: 'OK'}.to_xml(root: 'xml', dasherize: false)
    else
      render :xml => {return_code: 'FAIL', return_msg: "签名失败"}.to_xml(root: 'xml', dasherize: false)
    end
  end
end