class Admin::ProductHomepageImagesController < Admin::AdminController
  before_action :find_product

  def create
    s3 = AWS::S3.new

    if params[:sale_image]
      url = upload_image(s3, params[:sale_image])
      @product.product_view.sale_image_url = url
    end
    if params[:trailer_image]
      url = upload_image(s3, params[:trailer_image])
      @product.product_view.trailer_image_url = url
    end
    @product.product_view.save(validate: false)

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

  def upload_image(s3, image)
    content = image.read
    filename = "images/products/#{@product.id}/#{Digest::MD5.hexdigest(content)}#{File.extname(image.original_filename)}"
    s3.buckets[Rails.configuration.x.aws_s3_bucket].objects[filename].write(content)
    "/#{filename}"
  end
end
