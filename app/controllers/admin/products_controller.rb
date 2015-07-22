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
    @product.build_product_view
    @product.quantity = 0
  end

  def create
    @product = Product.new(product_params)
    @product.quantity = params[:product][:quantity_delta].to_i
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
    Product.transaction do
      @product = Product.find(params[:id])
      if @product.update(product_params)
        Product.where(id: params[:id]).update_all(['quantity = quantity + ?', params[:product][:quantity_delta]])
        redirect_to action: :index
      else
        render 'edit'
      end
    end
  end

  private

  def find_product
    @product = Product.find(params[:id])
  end

  def product_params
    params[:product][:contest_level] = nil if params[:product][:contest_level].blank?
    params[:product][:reduced_price] = nil if params[:product][:reduced_price].blank?
    params.require(:product).permit(:name, :brand_id, :price, :reduced_price, :original_price, :original_price_link, :priority, :contest_level, :quantity_delta,
                                    product_view_attributes: [:id, :home_page_description, :trailer_description, :detail_page_description,
                                                              :sale_image_type, :sale_image_url, :trailer_image_url])
  end
end
