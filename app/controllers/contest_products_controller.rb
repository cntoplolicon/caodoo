class ContestProductsController < ApplicationController
  def index
    @wx_jsapi = WxApi.jsapi_sign(request.original_url) if mobile_device?

    identify_contest_team
    record_team_id_and_page_view
    product_table = Product.arel_table
    @products = Product
      .joins(:product_sale_schedules, :product_view => [:product_detail_images, :product_carousel_images])
      .includes(:product_sale_schedules, :product_view => [:product_detail_images, :product_carousel_images])
      .where(product_table[:contest_level].lteq(@contest_team.level))
      .order(priority: :desc)
  end

  def show
    @wx_jsapi = WxApi.jsapi_sign(request.original_url) if mobile_device?

    @product = Product
      .where(id: params[:id])
      .joins(:product_sale_schedules, :product_view => [:product_detail_images, :product_carousel_images])
      .includes(:product_sale_schedules, :product_view => [:product_detail_images, :product_carousel_images])
      .take
    identify_contest_team
    if @product.contest_level.nil? || @product.contest_level > @contest_team.level
      redirect_to action: :index and return
    end
    record_team_id_and_page_view
    render 'products/show'
  end

  private

  def record_team_id_and_page_view
    if @contest_team.present?
      session[:contest_team_id] = @contest_team.id
      ContestPageView.create({contest_team_id: @contest_team.id, request_ip: request.remote_ip}) unless request_from_bot?
    end
  end

  def identify_contest_team
    if params[:contest_team_id].present?
      @contest_team = ContestTeam.find_by_identifier(params[:contest_team_id])
    elsif session[:contest_team_id].present?
      @contest_team = ContestTeam.find(session[:contest_team_id])
    else
      @contest_team = ContestTeam.find_by_identifier(Settings.contest.default_team_identifier)
    end
  end

  def request_from_bot?
    agent = request.env["HTTP_USER_AGENT"]
    matches = nil
    matches = agent.match(/(baidu|facebook|postrank|voyager|twitterbot|googlebot|slurp|butterfly|pycurl|tweetmemebot|metauri|evrinid|reddit|digg)/mi) if agent
    return agent.nil? || matches
  end
end
