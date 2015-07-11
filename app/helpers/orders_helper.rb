module OrdersHelper
  def order_status_text(status)
    case status
    when Order::TO_PAY
      '待付款'
    when Order::PAID
      '已付款'
    when Order::DELIVERED
      '已发货'
    when Order::COMPLETE
      '交易完成'
    when Order::CANCELLING
      '正在取消'
    when Order::CANCELLED
      '交易取消'
    when Order::TIMEOUT
      '交易超时'
    end
  end

  def payment_record_status_text(status)
    case status
    when PaymentRecord::TO_PAY
      '待付款'
    when PaymentRecord::PAID
      '已付款'
    when PaymentRecord::REFUNDED
      '已退款'
    when PaymentRecord::CANCELLED
      '交易取消'
    when PaymentRecord::TIMEOUT
      '交易超时'
    end
  end

  def payment_type_text(payment_type)
    case payment_type
    when nil
      '未支付'
    when PaymentRecord::ALIPAY
      '支付宝'
    when PaymentRecord::WECHAT
      '微信支付'
    end
  end
end
