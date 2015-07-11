require 'csv'

class Admin::RefundRecordsController < Admin::AdminController
  before_action :find_refund_record, only: [:edit, :update]

  include OrdersHelper
  include RefundRecords

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
        render 'edit', status: :bad_request, layout: false
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
