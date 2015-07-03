class Admin::ProductSaleSchedulesController < Admin::AdminController
  before_action :find_product

  def index
    respond_to do |format|
      format.html
      format.json { render json: ::ProductSaleScheduleDatatable.new(@product, view_context) }
    end
  end

  def new
    @product_sale_schedule = @product.product_sale_schedules.build
  end

  def create
    @product_sale_schedule = @product.product_sale_schedules.new(schedule_params)
    if @product_sale_schedule.save
      redirect_to action: :index
    else
      render 'edit'
    end
  end

  def edit
    @product_sale_schedule = @product.product_sale_schedules.find(params[:id])
  end

  def update
    @product_sale_schedule = @product.product_sale_schedules.find(params[:id])
    if @product_sale_schedule.update(schedule_params)
      redirect_to action: :index
    else
      render 'edit'
    end
  end

  private

  def find_product
    @product = Product.find(params[:product_id])
  end

  def schedule_params
    params.require(:product_sale_schedule).permit(:sale_start, :sale_end, :trailer_start, :trailer_end)
  end
end
