class Admin::ProductCarouselImagesController < Admin::AdminController
  before_action :find_product

  def create
    @product.product_view.product_carousel_images.destroy_all
    s3 = AWS::S3.new
    params[:images].each_with_index do |image, index|
      content = image.read
      filename = "images/products/#{@product.id}/#{Digest::MD5.hexdigest(content)}#{File.extname(image.original_filename)}"
      s3.buckets[Settings.aws.s3.bucket].objects[filename].write(content)
      @product.product_view.product_carousel_images.create(position: index, url: "/#{filename}")
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
