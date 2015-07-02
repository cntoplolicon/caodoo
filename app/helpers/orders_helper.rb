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
    when Order::REFUNDED
      '已退款'
    when Order::CANCELLING
      '正在取消'
    when Order::CANCELLED
      '交易取消'
    when Order::TIMEOUT
      '交易超时'
    end
  end
end
