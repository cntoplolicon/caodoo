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
      redirect_to action: :index
    else
      render 'edit'
    end
  end

  def edit
  end

  def update
    if @brand.update(brand_params)
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
    params.require(:brand).permit(:name, :logo_url)
  end
end
