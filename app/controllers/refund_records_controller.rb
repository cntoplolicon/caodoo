class RefundRecordsController < ContestTeamDashboardController
  before_action :require_login_and_reset_password

  include RefundRecords

  def create
    Order.transaction do
      create_new_refund_record
      if @refund_record.errors.empty? && @refund_record.save
        redirect_to action: :index
      else
        render 'new', status: :bad_request, layout: false
      end
    end
  end

  def edit
    @refund_record = RefundRecord.find(params[:id])
    render layout: false
  end

  def update
    Order.transaction do
      update_refund_record
      if @refund_record.errors.empty? && @refund_record.save
        redirect_to action: :index
      else
        render 'edit', status: :bad_request, layout: false
      end
    end
  end

  def new
    @refund_record = RefundRecord.new
    render layout: false
  end

  def index
    @refund_records = RefundRecord.all.order(created_at: :desc).joins(:order, :express).includes(:order, :express).where(orders: {contest_team_id: @contest_team.id})
    @total_orders_count = Order.where(contest_team_id: @contest_team.id, status: [Order::PAID, Order::DELIVERED, Order::COMPLETE]).sum(:quantity)
    @returned_orders_count = RefundRecord.joins(:order).where(status: RefundRecord::COMPLETE, orders: {contest_team_id: @contest_team.id}).sum(:quantity)
    @total_orders_count -= @returned_orders_count
    if @total_orders_count == 0 && @returned_orders_count == 0 then
      @return_ratio = 0
    else
      @return_ratio = @returned_orders_count.to_f / (@returned_orders_count + @total_orders_count) * 100
    end
    # @team_level=@contest_team.level;
    @team_level=3;
  end

  private

  def update_params
    params.require(:refund_record).permit(:express_id, :tracking_number, :quantity)
  end

  def create_params
    params.require(:refund_record).permit(:order_number, :quantity, :remark, :express_id, :tracking_number, :receiver)
  end
end
