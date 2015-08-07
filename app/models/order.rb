class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :product
  belongs_to :contest_team
  belongs_to :express

  validates :quantity, inclusion: {in: 1..10}
  validates_presence_of :address_id
  validates_presence_of :product_id
  validates_presence_of :user_id
  validates :remark, length: {maximum: 255}

  has_one :payment_record, autosave: true, validate: true
  has_many :refund_records
  has_one :coupon

  TO_PAY = 0
  PAID = 1
  DELIVERED = 2
  COMPLETE = 3
  CANCELLING = 9
  CANCELLED = 10
  TIMEOUT = 11

  def payment_expired?
    status == TO_PAY && created_at + Settings.payment.expired.to_i.minutes <= Time.zone.now
  end

  def product_name_with_version
    if product_version?
      "#{product_name} #{product_version}"
    else
      product_name
    end
  end

  def amount_to_pay
    coupon.nil? ? total_price : (total_price - coupon.money)
  end
end
