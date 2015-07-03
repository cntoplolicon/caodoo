class ProductView < ActiveRecord::Base
  belongs_to :product
  has_many :product_carousel_images
  has_many :product_detail_images

  validates_presence_of :home_page_description
  validates_presence_of :trailer_description
  validates_presence_of :trailer_image_url
  validates_presence_of :detail_page_description
  validates_presence_of :sale_image_url
  validates_presence_of :sale_image_type
end
