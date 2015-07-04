class Admin::OrdersController < Admin::AdminController
  def index
    respond_to do |format|
      format.html
      format.json { render json: ::OrderDatatable.new(view_context) }
      format.csv { render text: to_csv(::OrderDatatable.new(view_context).unpaged_records) }
    end
  end

  def to_csv(records)
    CSV.generate do  |csv|
      csv << ['订单号', '商品名称']
      records.each do |r|
        csv << [r.order_number, r.product.name]
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
      if [Order::DELIVERED, Order::COMPLETE].include?(@order.status) && status == Order::REFUNDED
        @order.update(status: Order::REFUNDED)
        @order.payment_record.update(status: PaymentRecord::REFUNDED)
        @order.refund_records.find_by_status(RefundRecord::PENDING).update(status: RefundRecord::REFUNDED)
      elsif [Order::TO_PAY].include?(@order.status) && status == Order::PAID
        @order.update(status: Order::TO_PAY)
        @order.payment_record.update(status: PaymentRecord::PAID)
      elsif [Order::CANCELLING].include?(@order.status) && status == Order.CANCELLED
        @order.update(status: Order::CANCELLED)
        @order.payment_record.update(status: PaymentRecord::REFUNDED)
      elsif [Order::DELIVERED].include?(@order.status) && status == Order.COMPLETE
        @order.update(status: Order::COMPLETE, receive_time: Time.now)
      else
        @order.errors.add(:status, '订单状态不正确，不能进行该操作')
      end
    end
    render 'show'
  end

  def upload_delivery
  end

  def import_delivery
    @results = CSV.parse(params[:file].read).map {|line| {order_number: line[0], express: line[1], tracking_number: line[2]} }
    @results.each do |r|
      Order.transaction do
        @order = Order.lock.find_by_order_number(r[:order_number])
        @express = Express.find_by_name(r[:express])
        if @order.nil?
          r[:message] = '订单不存在'
        elsif @express.nil?
          r[:message] = '快递公司不存在'
        elsif r[:tracking_number].blank?
          r[:message] = '快递单号不能为空'
        elsif [Order::TO_PAY, Order::CANCELLED, Order::CANCELLED, Order::TIMEOUT].include?(@order.status)
          r[:message] = '订单状态不正确'
        else
          @order.tracking_number = r[:tracking_number]
          @order.express_id = @express.id
          if @order.status == Order::PAID
            @order.status = Order::DELIVERED
          end
          @order.save
          r[:message] = '更新成功'
        end
        r[:order_status] = @order && @order.status
      end
    end
    render 'upload_delivery'
  end
end
