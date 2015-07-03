class Admin::ProductCarouselImagesController < Admin::AdminController
  before_action :find_product

  def create
    Product.transaction do
      @product = Product.lock.find(@product.id)
      @product.product_view.product_carousel_images.destroy_all
      urls = params[:images].squish.split(' ')
      urls.each_with_index do |url, index|
        @product.product_view.product_carousel_images.create(position: index, url: url)
      end
    end
    redirect_to action: :show
  end

  def show
  end

  def edit
  end

  private

  def find_product
    @product = Product.find(params[:product_id])
  end
end
