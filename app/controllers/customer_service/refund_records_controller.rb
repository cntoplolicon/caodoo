class CustomerService::RefundRecordsController < CustomerService::CustomerServiceController

  before_action :find_refund_record, only: [:edit, :update]

  include OrdersHelper
  include RefundRecords

  def index
    respond_to do |format|
      format.html
      format.json { render json: ::CustomerServiceRefundRecordDatatable.new(view_context) }
    end
  end

  def new
    @refund_record = RefundRecord.new
  end

  def create
    Order.transaction do
      create_new_refund_record
      if @refund_record.errors.empty? && @refund_record.save
        redirect_to action: :index
      else
        render 'new'
      end
    end
  end

  def edit
  end

  def update
    Order.transaction do
      update_refund_record
      if @refund_record.errors.empty? && @refund_record.save
        redirect_to action: :index
      else
        render 'edit'
      end
    end
  end

  private

  def find_refund_record
    @refund_record = RefundRecord.find(params[:id])
  end

  def update_params
    params.require(:refund_record).permit(:status, :remark, :quantity)
  end

  def create_params
    params.require(:refund_record).permit(:order_number, :quantity, :remark, :express_id, :tracking_number)
  end
end
