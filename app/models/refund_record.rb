class RefundRecord < ActiveRecord::Base
  belongs_to :order
  belongs_to :express

  attr_accessor :order_number
  attr_accessor :receiver

  validates_presence_of :express_id
  validates_presence_of :order_id
  validates_presence_of :tracking_number
  validates_presence_of :status
  validates :quantity, numericality: {greater_than: 0}

  PENDING = 0
  COMPLETE = 1
  CANCELLED = 10
end
