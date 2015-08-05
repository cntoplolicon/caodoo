class Admin::BrandsController < Admin::AdminController
  before_action :find_brand, only: [:edit, :update]

  def index
    respond_to do |format|
      format.html
      format.json { render json: ::BrandDatatable.new(view_context) }
    end
  end

  def new
    @brand = Brand.new
  end

  def create
    @brand = Brand.new(brand_params)
    if @brand.save
      update_logo(params[:brand][:logo]) if params[:brand][:logo]
      redirect_to action: :index
    else
      render 'edit'
    end
  end

  def edit
  end

  def update
    if @brand.update(brand_params)
      update_logo(params[:brand][:logo]) if params[:brand][:logo]
      redirect_to action: :index
    else
      render 'edit'
    end
  end

  private

  def find_brand
    @brand = Brand.find(params[:id])
  end

  def brand_params
    params.require(:brand).permit(:name)
  end

  def upload_image(s3, image)
    content = image.read
    filename = "images/brands/#{@brand.id}/#{Digest::MD5.hexdigest(content)}#{File.extname(image.original_filename)}"
    s3.buckets[Settings.aws.s3.bucket].objects[filename].write(content)
    "/#{filename}"
  end

  def update_logo(image)
    s3 = AWS::S3.new
    @brand.logo_url = upload_image(s3, image)
    @brand.save(validate: false)
  end
end
