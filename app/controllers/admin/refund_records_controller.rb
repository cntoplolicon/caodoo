require 'csv'

class Admin::RefundRecordsController < Admin::AdminController
  before_action :find_refund_record, only: [:edit, :update]

  include OrdersHelper
  include RefundRecords

  def to_csv(records)
    CSV.generate do  |csv|
      csv << ['订单号', '商品名称', '商品数量', '收货人姓名', '收货人电话', '省', '市', '区', '详细地址', '发货物流公司', '发货运单号', '团队名', '退货物流公司', '退货物流运单号', '创建时间', '修改时间', '退货单状态', '退货单备注']
      records.each do |r|
        csv << [r.order.order_number, r.order.product.name, r.order.quantity, r.order.receiver, r.order.phone, r.order.province_name, r.order.city_name, r.order.district_name, r.order.detailed_address, r.order.try(:express).try(:name), r.order.tracking_number, r.order.try(:contest_team).try(:name), r.express.name, r.tracking_number, r.created_at.strftime('%Y/%m/%d %H:%M:%S'), r.updated_at.strftime('%Y/%m/%d %H:%M:%S'), view_context.refund_record_status_text(r.status), r.remark]
      end
    end
  end

  def index
    respond_to do |format|
      format.html
      format.json { render json: ::RefundRecordDatatable.new(view_context) }
      format.csv do
        records = RefundRecordDatatable.new(view_context).unpaged_records
        bom = "\xEF\xBB\xBF".encode("UTF-8")
        send_data bom + to_csv(records).encode("UTF-8"), filename: "#{Time.zone.now.strftime('%Y/%m/%d %H:%M:%S')}.csv", type: 'text/csv'
      end
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
