class ProductGroup < ActiveRecord::Base
  belongs_to :primary_product, class_name: 'Product'
end
