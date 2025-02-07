class ProductsController < ApplicationController
  def index
    @wx_jsapi = WxApi.jsapi_sign(request.original_url) if mobile_device?

    schedule_table = ProductSaleSchedule.arel_table
    now = Time.zone.now
    @on_sale_products = Product
      .joins(:product_sale_schedules, product_view: [:product_detail_images, :product_carousel_images])
      .includes(:product_sale_schedules, :product_group, product_view: [:product_detail_images, :product_carousel_images])
      .where(schedule_table[:sale_start].lt(now))
      .where(schedule_table[:sale_end].gt(now))
      .where(contest_level: nil)
      .where('products.id = product_groups.primary_product_id or products.product_group_id is null')
      .order(priority: :desc)
    @upcoming_products = Product
      .joins(:product_sale_schedules, product_view: [:product_detail_images, :product_carousel_images])
      .includes(:product_sale_schedules, product_view: [:product_detail_images, :product_carousel_images])
      .where(schedule_table[:trailer_start].lt(now))
      .where(schedule_table[:trailer_end].gt(now))
      .where(contest_level: nil)
      .order(priority: :desc)
  end

  def show
    @wx_jsapi = WxApi.jsapi_sign(request.original_url) if mobile_device?

    @product = Product.where(id: params[:id])
      .joins(:product_sale_schedules, product_view: [:product_detail_images, :product_carousel_images])
      .includes(:product_sale_schedules, product_view: [:product_detail_images, :product_carousel_images])
      .take
    if @product.product_group.present?
      @related_products = Product.where(product_group: @product.product_group)
    end

    return unless @product.contest_product?
    if session[:contest_team_id].present?
      @contest_team = ContestTeam.find(session[:contest_team_id])
    else
      @contest_team = ContestTeam.find_by_identifier(Settings.contest.default_team_identifier)
    end
  end
end
