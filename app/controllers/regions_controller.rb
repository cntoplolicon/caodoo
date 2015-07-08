class RegionsController < ApplicationController
  before_action :require_login

  def get_cities_in_province
    @cities = Region.where(parent: params[:province_code], disabled: false)
    render layout: false
  end

  def get_districts_in_city
    @districts = Region.where(parent: params[:city_code], disabled: false)
    render layout: false
  end

  private

  def require_login
    head :forbidden unless session[:login_user_id].present?
  end
end
