class ProductsController < ApplicationController
  def index
    schedule_table = ProductSaleSchedule.arel_table
    now = Time.now
    @on_sale_products = Product.joins(:product_sale_schedules, :product_view)
      .includes(:product_sale_schedules, :product_view)
      .where(schedule_table[:sale_start].lt(now))
      .where(schedule_table[:sale_end].gt(now))
      .where(contest_level: nil)
      .order(priority: :desc)
    @upcoming_products = Product.joins(:product_sale_schedules, :product_view, :brand)
      .includes(:product_sale_schedules, :product_view, :brand)
      .where(schedule_table[:trailer_start].lt(now))
      .where(schedule_table[:trailer_end].gt(now))
      .where(contest_level: nil)
      .order(priority: :desc)
  end

  def show
    @product = Product
      .where(id: params[:id])
      .joins(:product_sale_schedules, :product_view => [:product_detail_images, :product_carousel_images])
      .includes(:product_sale_schedules, :product_view => [:product_detail_images, :product_carousel_images])
      .take
  end
end
