class RefundRecordsController < ContestTeamDashboardController
  before_action :require_login_and_reset_password

  def create
    @refund_record = RefundRecord.new(create_params)
    @order = Order.where(order_number: @refund_record.order_number).includes(:refund_records).take
    if @order.nil?
      @refund_record.errors.add(:order_number, '订单号不存在')
    else
      if @order.refund_records.any? { |r| r.status == RefundRecord::PENDING }
        @refund_record.errors.add(:order_number, '该订单已有正在处理的退货记录')
      end
      if @order.status == Order::REFUNDED
        @refund_record.errors.add(:order_number, '该订单已完成退货')
      end
      if @order.contest_team_id != @contest_team.id
        @refund_record.errors.add(:order_number, '该订单并非由本小组推荐购买')
      end
      if @order.receiver != @refund_record.receiver
        @refund_record.errors.add(:receiver, '订单收件人不匹配')
      end
      @refund_record.order_id = @order.id
      @refund_record.status = RefundRecord::PENDING
    end

    if @refund_record.errors.empty? && @refund_record.save
      redirect_to action: :index
    else
      render 'new', status: :bad_request, layout: false
    end
  end

  def edit
    @refund_record = RefundRecord.find(params[:id])
    render layout: false
  end

  def update
    @refund_record = RefundRecord.find(params[:id])
    if @refund_record.update(update_params)
      redirect_to action: :index
    else
      render 'edit', status: :bad_request, layout: false
    end
  end

  def new
    @refund_record = RefundRecord.new
    render layout: false
  end

  def index
    @refund_records = RefundRecord.all.joins(:order, :express).includes(:order, :express).where(orders: {contest_team_id: @contest_team.id})
    @total_orders_count = Order.where(contest_team_id: @contest_team.id, status: [Order::PAID, Order::DELIVERED, Order::COMPLETE]).count(:all)
    @returned_orders_count = Order.where(contest_team_id: @contest_team.id, status: Order::REFUNDED).count(:all)
    if @total_orders_count == 0 && @returned_orders_count == 0 then
      @return_ratio = 0
    else
      @return_ratio = @returned_orders_count.to_f / (@returned_orders_count + @total_orders_count) * 100
    end
  end

  private


  def create_params
    params.require(:refund_record).permit(:order_number, :receiver, :express_id, :tracking_number)
  end

  def update_params
    params.require(:refund_record).permit(:express_id, :tracking_number)
  end
end
