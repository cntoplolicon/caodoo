class Admin::ProductsController < Admin::AdminController
  before_action :find_product, only: [:edit]

  def index
    respond_to do |format|
      format.html
      format.json { render json: ::ProductDatatable.new(view_context) }
    end
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to action: :index
    else
      render 'edit'
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.lock.find(params[:id])
    if @product.update(product_params)
      redirect_to action: :index
    else
      render 'edit'
    end
  end

  private

  def find_product
    @product = Product.find(params[:id])
  end

  def product_params
    params[:product][:contest_level] = nil if params[:product][:contest_level].blank?
    params.require(:product).permit(:name, :brand_id, :price, :original_price, :priority, :contest_level,
                                    product_view_attributes: [:id, :home_page_description, :trailer_description, :detail_page_description,
                                                              :sale_image_type, :sale_image_url, :trailer_image_url])
  end
end
