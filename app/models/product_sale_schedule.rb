class ProductSaleSchedule < ActiveRecord::Base
  belongs_to :product
  
  validates_presence_of :sale_start
  validates_presence_of :sale_end
  validates_presence_of :trailer_start
  validates_presence_of :trailer_end
end
