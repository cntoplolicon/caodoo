class Admin::ProductGroupsController < Admin::AdminController
  before_action :find_product_group, only: [:edit, :update]
  before_action :get_product_ids, only: [:create, :update]

  def index
    respond_to do |format|
      format.html
      format.json { render json: ::ProductGroupDatatable.new(view_context) }
    end
  end

  def new
    @product_group = ProductGroup.new
  end

  def create
    ProductGroup.transaction do
      @product_group = ProductGroup.new(product_group_params)
      render 'new' and return unless primary_product_valid?
      if @product_group.save
        @product_group.product_ids = @product_ids
        redirect_to action: :index
      else
        render 'new'
      end
    end
  end

  def edit
  end

  def update
    ProductGroup.transaction do
      @product_group.attributes = product_group_params
      render 'edit' and return unless primary_product_valid?
      if @product_group.save
        @product_group.product_ids = @product_ids
        redirect_to action: :index
      else
        render 'edit'
      end
    end
  end

  private

  def find_product_group
    @product_group = ProductGroup.find(params[:id])
  end

  def get_product_ids
    if params[:product_ids].nil?
      @product_ids = []
    else
      @product_ids = params[:product_ids].map { |id| id.to_i }
    end
  end

  def product_group_params
    params[:product_group][:primary_product_id] = nil if params[:product_group][:primary_product_id] == ''
    params.require(:product_group).permit(:name, :primary_product_id)
  end

  def primary_product_valid?
    if @product_group.primary_product_id.present? &&
        !@product_ids.include?(@product_group.primary_product_id)
      @product_group.errors.add(:primary_product_id, '首要产品不在所包含产品中')
      return false
    end
    true
  end
end
