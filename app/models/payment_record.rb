class PaymentRecord < ActiveRecord::Base
  belongs_to :order

  ALIPAY = 0
  WECHAT = 1

  TO_PAY = 0
  PAID = 1
  REFUNDED = 2
  CANCELLED = 10
  TIMEOUT = 11
end
