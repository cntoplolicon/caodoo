class Admin::ExpressesController < Admin::AdminController
  before_action :find_express, only: [:edit, :update]

  def index
    respond_to do |format|
      format.html
      format.json {render json: ::ExpressDatatable.new(view_context)}
    end
  end

  def new
    @express = Express.new
  end

  def create
    @express = Express.new(express_params)
    if @express.save
      redirect_to action:index
    else
      render 'edit'
    end
  end

  def edit
  end

  def update
    if @express.update(express_params)
      redirect_to action: :index
    else
      render 'edit'
    end
  end

  private

  def find_express
    @express = Express.find(params[:id])
  end

  def express_params
    params.require(:express).permit(:name, :code)
  end

end
