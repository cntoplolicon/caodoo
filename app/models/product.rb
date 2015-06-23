class Product < ActiveRecord::Base
  belongs_to :brand
  has_many :product_sale_schedules
  has_one :product_view
end
