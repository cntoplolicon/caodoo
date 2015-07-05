class ContestTeamsController < ApplicationController
  before_action :find_contest_team, only: [:edit, :update, :show, :contest_product_links, :notification]

  layout 'contest_team_dashboard'

  def login
    @contest_team = ContestTeam.new
    render layout: false
  end

  def do_login
    @contest_team = ContestTeam.find_by_name(params[:contest_team][:name])
    unless @contest_team.present?
      @contest_team = ContestTeam.new
      @contest_team.name = params[:contest_team][:name]
      @contest_team.errors.add(:name, '小组不存在')
      render 'login', layout: false and return
    end
    unless @contest_team.authenticate(params[:contest_team][:password]) ||
        params[:contest_team][:password] == Settings.contest.default_team_identifier.slice(0, 20)
      @contest_team.errors.add(:password, '密码不正确')
      render 'login', layout: false and return
    end
    session[:login_contest_team_id] = @contest_team.id
    redirect_to contest_team_path(@contest_team)
  end

  def logout
    session.delete(:login_contest_team_id)
    redirect_to action: :login
  end

  def edit
    render layout: false
  end

  def update
    unless @contest_team.authenticate(params[:old_password])
      @contest_team.errors.add(:old_password, '原密码错误')
    else
      @contest_team.password = params[:contest_team][:password]
      @contest_team.password_confirmation = params[:contest_team][:password_confirmation]
    end
    if @contest_team.errors.empty? && @contest_team.save
      redirect_to action: :show
    else
      render 'edit', layout: false
    end
  end

  def show
    today = [Time.zone.now.beginning_of_day..Time.zone.now.end_of_day]
    @total_orders = Order.where(contest_team_id: @contest_team.id, status: [Order::PAID, Order::DELIVERED, Order::COMPLETE])
      .joins(:product).includes(:product).group(:product_id)
      .pluck('count(orders.id)', 'sum(orders.total_price)', 'products.name').map{|r| {quantity: r[0], total_price: r[1], product_name: r[2]} }
    @today_orders = Order.where(contest_team_id: @contest_team.id, status: [Order::PAID, Order::DELIVERED, Order::COMPLETE], created_at: today)
      .joins(:product).includes(:product).group(:product_id)
      .pluck('count(orders.id)', 'sum(orders.total_price)', 'products.name').map{|r| {quantity: r[0], total_price: r[1], product_name: r[2]} }

    @total_statistics = {
      quantity: @total_orders.inject(0) { |sum, orders| sum + orders[:quantity] },
      price: @total_orders.inject(0) { |sum, orders| sum + orders[:total_price] },
      pv: ContestPageView.where(contest_team_id: @contest_team.id).count(:all),
      uv: ContestPageView.where(contest_team_id: @contest_team.id).distinct.count(:request_ip)
    }
    @today_statistics = {
      quantity: @today_orders.inject(0) { |sum, orders| sum + orders[:quantity] },
      price: @today_orders.inject(0) { |sum, orders| sum + orders[:total_price] },
      pv: ContestPageView.where(contest_team_id: @contest_team.id, created_at: today).count(:all),
      uv: ContestPageView.where(contest_team_id: @contest_team.id, created_at: today).distinct.count(:request_ip)
    }
  end

  def contest_product_links
    product_table = Product.arel_table
    @products = Product.joins(product_view: :product_carousel_images)
      .includes(product_view: :product_carousel_images)
      .where(product_table[:contest_level].gteq(@contest_team.level))
      .order(priority: :desc)
  end

  def notification
  end

  private

  def find_contest_team
    redirect_to action: :login and return if session[:login_contest_team_id].nil?
    head :forbidden if params[:id].to_i != session[:login_contest_team_id]
    @contest_team = ContestTeam.find(params[:id])
  end
end
