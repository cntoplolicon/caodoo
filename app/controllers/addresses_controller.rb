class AddressesController < ApplicationController
  before_action :find_user

  def index
    @addresses = @user.addresses.order(updated_at: :desc)
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
        @user.addresses.where.not(id: @address.id).update_all(default: false, updated_at: Time.zone.now) if @address.default
        render status: :ok, json: {address_id: @address.id}
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
        @user.addresses.where.not(id: @address.id).update_all(default: false, updated_at: Time.zone.now) if @address.default
        redirect_to action: :index
      else
        load_regions_for_address
        render 'edit', layout: false, status: :bad_request
      end
    end
  end

  private

  def find_user
    redirect_to login_users_url and return unless session[:login_user_id].present?
    user_id = params[:user_id].to_i
    head :forbidden and return if user_id != session[:login_user_id]
    @user = User.find(user_id)
  end

  def address_params
    if params[:address].has_key?(:province_code)
      params[:address][:city_code] = nil unless params[:address][:city_code].present?
      params[:address][:district_code] = nil unless params[:address][:district_code].present?
    end
    params.require(:address).permit(:user_id, :receiver, :phone, :province_code, :city_code, :district_code, :detailed_address, :default, :deleted)
  end

  def load_regions_for_address
    @provinces = Region.where(parent: nil, disabled: false)
    @cities = @address.province.nil? ? [] : Region.where(parent: @address.province.code, disabled: false)
    @districts = @address.province.nil? || @address.city.nil? ? [] : Region.where(parent: @address.city.code, disabled: false)
  end
end
