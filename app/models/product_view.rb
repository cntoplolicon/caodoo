class ProductView < ActiveRecord::Base
  belongs_to :product
  has_many :product_carousel_images
  has_many :product_detail_images
end
