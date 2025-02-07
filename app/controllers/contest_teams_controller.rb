class ContestTeamsController < ContestTeamDashboardController
  before_action :require_login_and_reset_password, only: [:edit, :show, :contest_product_links, :notification]
  before_action :require_login, only: [:update]

  def login
    @contest_team = ContestTeam.new
    render layout: false
  end

  def do_login
    @contest_team = ContestTeam.find_by_phone(params[:contest_team][:phone])
    unless @contest_team.present?
      @contest_team = ContestTeam.new
      @contest_team.phone = params[:contest_team][:phone]
      @contest_team.errors.add(:phone, '小组不存在')
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
      @contest_team.password_updated = true
      @contest_team.updating_password = true
    end
    if @contest_team.errors.empty? && @contest_team.save
      redirect_to action: :show
    else
      render 'edit', layout: false
    end
  end

  def show
    today = [Time.zone.now.beginning_of_day..Time.zone.now.end_of_day]
    @team_refund_records = RefundRecord.joins(:order).includes(:order).where(orders: {contest_team_id: @contest_team.id}, status: RefundRecord::COMPLETE)
                             .group(:product_id).pluck('sum(refund_records.quantity)', 'sum(orders.unit_price * refund_records.quantity)', 'orders.product_id')
                             .map { |r| {quantity: r[0], total_price: r[1].to_f, product_id: r[2]} }
    @total_orders = Order.where(contest_team_id: @contest_team.id, status: [Order::PAID, Order::DELIVERED, Order::COMPLETE])
                      .joins(:product).includes(:product).group(:product_id)
                      .pluck('sum(orders.quantity)', 'sum(orders.total_price)', 'products.name', 'orders.product_id').map { |r| {quantity: r[0], total_price: r[1].to_f, product_name: r[2], product_id: r[3]} }
    @today_orders = Order.where(contest_team_id: @contest_team.id, status: [Order::PAID, Order::DELIVERED, Order::COMPLETE], created_at: today)
                      .joins(:product).includes(:product).group(:product_id)
                      .pluck('sum(orders.quantity)', 'sum(orders.total_price)', 'products.name').map { |r| {quantity: r[0], total_price: r[1], product_name: r[2]} }
    @team_refund_records.each do |refund|
      @total_orders.select { |order| order[:product_id] == refund[:product_id] }.first[:quantity] -= refund[:quantity]
      @total_orders.select { |order| order[:product_id] == refund[:product_id] }.first[:total_price] -= refund[:total_price]
    end
    @total_statistics = {
      quantity: @total_orders.inject(0) { |sum, orders| sum + orders[:quantity] },
      price: @total_orders.inject(0) { |sum, orders| sum + orders[:total_price] },
      pv: ContestPageView.where(contest_team_id: @contest_team.id).count(:all),
    }
    @today_statistics = {
      quantity: @today_orders.inject(0) { |sum, orders| sum + orders[:quantity] },
      price: @today_orders.inject(0) { |sum, orders| sum + orders[:total_price] },
      pv: ContestPageView.where(contest_team_id: @contest_team.id, created_at: today).count(:all),
    }
  end

  def contest_product_links
    product_table = Product.arel_table
    @products = Product.joins(product_view: :product_carousel_images)
                  .includes(product_view: :product_carousel_images)
                  .where(product_table[:contest_level].lteq(@contest_team.level))
                  .order(priority: :desc)
    @links = @products.map do |product|
      {
        title: product.name,
        url: contest_team_contest_product_url(@contest_team.identifier, product),
        image_url: product.product_view.sale_image_url
      }
    end
    @links.unshift({title: '大赛活动页', url: contest_team_contest_products_url(@contest_team.identifier)})
  end

  def notification
  end
end
