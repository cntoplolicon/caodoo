class AddressesController < ApplicationController
  before_action :find_user

  def index
    @addresses = @user.addresses.where(deleted: false).order(created_at: :desc)
    render layout: 'account_setting'
  end

  def new
    @address = @user.addresses.build
    load_regions_for_address
    render layout: false
  end

  def create
    @address = @user.addresses.build(address_params)
    Address.transaction do
      if @address.save
        @user.addresses.where(deleted: false).where.not(id: @address.id).update_all(default: false)
        redirect_to action: :index
      else
        load_regions_for_address
        render 'new', layout: false, status: :bad_request
      end
    end
  end

  def edit
    @address = @user.addresses.find(params[:id])
    load_regions_for_address
    render layout: false
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
        load_regions_for_address
        render 'edit', layout: false, status: :bad_request
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
    params[:address][:city_code] = '' unless params[:address][:city_code].present?
    params[:address][:district_code] = '' unless params[:address][:district_code].present?
    params.require(:address).permit(:user_id, :receiver, :phone, :province_code, :city_code, :district_code, :detailed_address, :default, :deleted)
  end

  def load_regions_for_address
    @provinces = Region.where(parent: nil)
    @cities = @address.province.nil? ? [] : Region.where(parent: @address.province.code)
    @districts = @address.province.nil? || @address.city.nil? ? [] : Region.where(parent: @address.city.code)
  end
end