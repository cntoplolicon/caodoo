module OrdersHelper
  def order_status_text(status)
    case status
    when 0
      '待付款'
    when 1
      '已付款'
    when 2
      '已发货'
    when 3
      '交易完成'
    end
  end
end
