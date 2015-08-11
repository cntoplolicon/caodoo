namespace :orders do
  task clean_timeout_orders: :environment do
    order_table = Order.arel_table
    Order.transaction do
      timeout_orders = Order.lock.where(status: Order::TO_PAY).where(order_table[:created_at].lt(Time.now - Settings.payment.expired.minutes)).joins(:payment_record).includes(:payment_record)
      timeout_orders.each do |order|
        order.update(status: Order::TIMEOUT)
        order.payment_record.update(status: PaymentRecord::TIMEOUT)
        unless order.coupon.nil?
          Coupon.create(money: order.coupon.money, begin_date: order.coupon.begin_date,
                        end_date: order.coupon.end_date, state: 0, user_id: order.user_id)
        end
        Product.where(id: order.product_id).update_all(['quantity = quantity + ?, updated_at = ?', 1, Time.zone.now])
      end
    end
  end
end
