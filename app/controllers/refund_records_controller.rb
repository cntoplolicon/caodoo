class RefundRecordsController < ApplicationController
  before_action :require_login

  layout 'contest_team_dashboard'

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
      render 'new'
    end
  end

  def edit
    @refund_record = RefundRecord.find(params[:id])
  end

  def update
    @refund_record = RefundRecord.find(params[:id])
    if @refund_record.update(update_params)
      redirect_to action: :index
    else
      render 'edit'
    end
  end

  def new
    @refund_record = RefundRecord.new
  end

  def index
    @refund_records = RefundRecord.all.joins(:order, :express).includes(:order, :express).where(orders: {contest_team_id: @contest_team.id})
  end

  private

  def require_login
    redirect_to login_contest_teams_path and return if session[:login_contest_team_id].nil?
    head :forbidden if params[:contest_team_id].to_i != session[:login_contest_team_id]
    @contest_team = ContestTeam.find(session[:login_contest_team_id])
  end

  def create_params
    params.require(:refund_record).permit(:order_number, :receiver, :express_id, :tracking_number)
  end

  def update_params
    params.require(:refund_record).permit(:express_id, :tracking_number)
  end
end
