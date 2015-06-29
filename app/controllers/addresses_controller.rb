class AddressesController < ApplicationController
  before_action :find_user, except: [:new]

  def index
    @addresses = @user.addresses.where(deleted: false).order(created_at: :desc)
    render layout: 'account_setting'
  end

  def new
    @address = Address.new
  end

  def edit
    @address = @user.addresses.find(params[:id])
  end

  def update
    Address.transaction do
      @address = @user.addresses.find(params[:id])
      @address.attributes = address_params
      if @address.save
        if @address.default
          @user.addresses.where(deleted: false).where.not(id: @address.id).update_all(default: false)
        end
        redirect_to action: :index 
      else
        render 'edit'
      end
    end
  end

  private

  def find_user
    user_id = params[:user_id].to_i
    head :forbidden if user_id != session[:login_user_id]
    @user = User.find(user_id)
  end

  def address_params
    params.require(:address).permit(:user_id, :receiver, :phone, :province_code, :city_code, :district_code, :detailed_address, :default, :deleted)
  end
end
