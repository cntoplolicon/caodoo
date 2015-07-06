namespace :orders do
  task clean_timeout_orders: :environment do
    order_table = Order.arel_table
    Order.transaction do
      timeout_orders = Order.lock.where(status: Order::TO_PAY).where(order_table[:created_at].lt(Time.now - Settings.payment.expired.minutes))
        .joins(:payment_record).includes(:payment_record)
      timeout_orders.each do |order|
        order.update(status: Order::TIMEOUT)
        order.update(status: PaymentRecord::TIMEOUT)
        Product.where(id: order.product_id).update_all(['quantity = quantity + ?', order.quantity])
      end
    end
  end
end
