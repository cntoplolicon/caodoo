class Admin::RefundRecordsController < Admin::AdminController
  before_action :find_refund_record, only: [:edit, :update]

  include OrdersHelper

  def index
    respond_to do |format|
      format.html
      format.json { render json: ::RefundRecordDatatable.new(view_context) }
      format.csv { render text: ::RefundRecordDatatable.new(view_context).as_json }
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
          @refund_record.attributes = refund_record_params
        else
          @refund_record.errors.add(:status, "订单状态为#{order_status_text(@order.status)}")
        end
      end
    else
      @refund_record.attributes = refund_record_params
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

  def refund_record_params
    params.require(:refund_record).permit(:status, :remark)
  end
end
