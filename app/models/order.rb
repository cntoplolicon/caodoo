class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :product
  belongs_to :contest_team
  belongs_to :express

  validates :quantity, :inclusion => {:in => 1..10}
  validates_presence_of :address_id
  validates_presence_of :product_id
  validates_presence_of :user_id

  has_one :payment_record, autosave: true, validate: true
  has_many :refund_records

  TO_PAY = 0
  PAID = 1
  DELIVERED = 2
  COMPLETE = 3
  CANCELLING = 9
  CANCELLED = 10
  TIMEOUT = 11
end
