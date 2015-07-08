class Admin::RegionsController < Admin::AdminController
  before_action :find_region, only: [:edit, :update]

  def index
    @regions = Region.where(parent: nil).includes(sub_regions: [sub_regions: [:sub_regions]])
  end

  def edit
  end

  def update
    if @region.update(region_params)
      redirect_to action: :index
    else
      render 'edit'
    end
  end

  private

  def find_region
    @region = Region.find(params[:id])
  end

  def region_params
    params.require(:region).permit(:disabled)
  end
end
