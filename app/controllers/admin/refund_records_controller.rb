require 'csv'

class Admin::RefundRecordsController < Admin::AdminController
  before_action :find_refund_record, only: [:edit, :update]

  include OrdersHelper

  def to_csv(records)
    CSV.generate do  |csv|
      csv << ['订单号', '商品名称']
      records.each do |r|
        csv << [r.order.order_number, r.order.product.name]
      end
    end
  end

  def index
    respond_to do |format|
      format.html
      format.json { render json: ::RefundRecordDatatable.new(view_context) }
      format.csv { render text: to_csv(::RefundRecordDatatable.new(view_context).unpaged_records) }
    end
  end

  def new
    @refund_record = RefundRecord.new
  end

  def create
    @refund_record = RefundRecord.new(create_params)
    @order = Order.where(order_number: @refund_record.order_number).includes(:refund_records).take
    @order = Order.fidn_by_order_number(@refund_record.order_number)
    if @order.nil?
      @refund_record.errors.add(:order_id, '订单号不存在')
    else
      if @order.refund_records.any? { |r| r.status == RefundRecord::PENDING }
        @refund_record.errors.add(:order_number, '该订单已有正在处理的退货记录')
      end
      if @order.status == Order::REFUNDED
        @refund_record.errors.add(:order_number, '该订单已完成退货')
      end
      if @order.contest_team.present?
        @refund_record.errors.add(:order_number, '订单为比赛产品，应由比赛团队管理')
      end
      @refund_record.order_id = @order.id
    end

    if @orders.errors.empty? && @refund_record.save
      redirect_to action: :index
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    status = params[:refund_record][:status].to_i
    if status == RefundRecord::REFUNDED
      Order.transaction do
        @order = Order.lock.find(@refund_record.order_id)
        if [Order::DELIVERED, Order::COMPLETE, Order::REFUNDED].include?(@order.status)
          @order.status = Order::REFUNDED
          @order.payment_record.status = PaymentRecord::REFUNDED
          @refund_record.attributes = refund_record_params
        else
          @refund_record.errors.add(:status, "订单状态为#{order_status_text(@order.status)}")
        end
      end
    else
      @refund_record.attributes = update_params
    end
    if @refund_record.errors.empty? && @refund_record.save
      redirect_to action: :index
    else
      render 'edit'
    end
  end

  private

  def find_refund_record
    @refund_record = RefundRecord.find(params[:id])
  end

  def update_params
    params.require(:refund_record).permit(:status, :remark)
  end

  def create_params
    params.require(:refund_record).permit(:status, :remark, :express_id, :tracking_number)
  end
end
