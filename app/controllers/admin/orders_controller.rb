require 'csv'

class Admin::OrdersController < Admin::AdminController
  def index
    respond_to do |format|
      format.html
      format.json { render json: ::OrderDatatable.new(view_context) }
      format.csv do
        bom = "\xEF\xBB\xBF".encode("UTF-8")
        update_exported = params[:update_delivery_exported]
        Order.transaction do
          records = OrderDatatable.new(view_context).unpaged_records
          records = records.where(delivery_exported: false) if update_exported
          send_data bom + to_csv(records).encode("UTF-8"), filename: "#{Time.zone.now.strftime('%Y/%m/%d %H:%M:%S')}.csv", type: 'text/csv'
          Order.where(id: records.ids).update_all(delivery_exported: true) if update_exported
        end
      end
    end
  end

  def to_csv(records)
    CSV.generate do |csv|
      csv << ['订单号', '商品名称', '商品数量', '收件人姓名', '收件人联系方式', '省', '市', '区', '详细地址', '订单状态', '下单时间', '修改时间']
      records.each do |r|
        csv << [r.order_number, r.product_name, r.quantity, r.receiver, r.phone, r.province_name, r.city_name, r.district_name, r.detailed_address, view_context.order_status_text(r.status), r.created_at.strftime('%Y/%m/%d %H:%M:%S'), r.updated_at.strftime('%Y/%m/%d %H:%M:%S')]
      end
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  def update
    Order.transaction do
      @order = Order.lock.find(params[:id])
      status = params[:status].to_i
      if [Order::CANCELLING].include?(@order.status) && status == Order::CANCELLED
        @order.update(status: Order::CANCELLED)
        @order.payment_record.update(status: PaymentRecord::REFUNDED)
        Product.where(id: @order.product_id).update_all(['quantity = quantity + ?', @order.quantity])
      elsif [Order::DELIVERED].include?(@order.status) && status == Order::COMPLETE
        @order.update(status: Order::COMPLETE, receive_time: Time.zone.now)
      else
        @order.errors.add(:status, '订单状态不正确，不能进行该操作')
      end
    end
    render 'show'
  end

  def upload_delivery
  end

  def import_delivery
    content = params[:file].read.force_encoding("utf-8").delete("\xEF\xBB\xBF".encode("UTF-8"))
    @results = CSV.parse(content).map do |line|
      {order_number: line[0], express: line[1].blank? ? nil : line[1], tracking_number: line[2].blank? ? nil : line[2]}
    end
    @results.each do |r|
      Order.transaction do
        @order = Order.lock.find_by_order_number(r[:order_number])
        expresses = Express.where('lower(name) like ?', "%#{r[:express]}%") if r[:express].present?
        if expresses.present?
          if expresses.count > 1
            r[:message] = '匹配到多个快递公司'
          else
            express = expresses.first
          end
        end
        if @order.nil?
          r[:message] = '订单不存在'
        elsif express.nil? && r[:express].present?
          r[:message] = '快递公司不存在'
        elsif r[:tracking_number].blank? && r[:express].present?
          r[:message] = '快递单号不能为空'
        elsif ![Order::PAID, Order::DELIVERED].include?(@order.status)
          r[:message] = '订单状态不正确'
        else
          @order.tracking_number = r[:tracking_number]
          @order.express_id = express.id if express.present?
          if @order.status == Order::PAID
            @order.status = Order::DELIVERED
          end
          if @order.save
            r[:message] = '更新成功'
          else
            r[:message] = @order.errors.full_messages.first
          end
        end
        r[:order_status] = @order && @order.status
      end
    end
    render 'upload_delivery'
  end

  def upload_payment
  end

  def import_payment
    content = params[:file].read.force_encoding("utf-8").delete("\xEF\xBB\xBF".encode("UTF-8"))
    @results = CSV.parse(content).map {|line| {order_number: line[0], payment_type: line[1].to_i, amount: line[2].to_f,
                                                          payment_time: line[3].blank? ? nil : Time.parse(line[3])} }
    @results.each do |r|
      Order.transaction do
        @order = Order.lock.find_by_order_number(r[:order_number])
        if ![PaymentRecord::ALIPAY, PaymentRecord::WECHAT].include?(r[:payment_type])
          r[:message] = '支付方式不正确'
        elsif @order.nil?
          r[:message] = '订单不存在'
        elsif @order.status != Order::TO_PAY
          r[:message] = '订单状态不正确'
        else
          @order.status = Order::PAID
          @order.payment_record.status = PaymentRecord::PAID
          @order.payment_record.amount = r[:amount]
          @order.payment_record.payment_type = r[:payment_type]
          @order.payment_record.payment_time = r[:payment_time] || Time.zone.now
          ContestTeam.where(id: @order.contest_team_id).update_all(['sales_quantity = sales_quantity + ?', @order.quantity]) if @order.contest_team_id.present?
          if @order.save
            r[:message] = '更新成功'
          else
            raise ActiveRecord::Rollback
            r[:message] = @order.errors.full_messages.first
          end
        end
        r[:order_status] = @order && @order.status
      end
    end
    render 'upload_payment'
  end
end
