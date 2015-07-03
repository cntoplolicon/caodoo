class Product < ActiveRecord::Base
  belongs_to :brand
  has_many :product_sale_schedules
  has_one :product_view, autosave: true, validate: true
  accepts_nested_attributes_for :product_view

  validates_presence_of :name
  validates_presence_of :brand_id
  validates_presence_of :price
  validates_presence_of :original_price
  validates_presence_of :priority
  validates_presence_of :priority
  def contest_product?
    !self.contest_level.nil?
  end
end
