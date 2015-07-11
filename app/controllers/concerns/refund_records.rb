module RefundRecords
  def create_new_refund_record
    @refund_record = RefundRecord.new(create_params)
    @order = Order.lock.where(order_number: @refund_record.order_number).includes(:refund_records).take
    if @order.nil?
      @refund_record.errors.add(:order_number, '订单号不存在')
    else
      if @order.status != Order::COMPLETE
        @refund_record.errors.add(:order_number, '订单未完成交易')
      end
      if @contest_team.present? && @order.contest_team_id != @contest_team.id
        @refund_record.errors.add(:order_number, '该订单并非由本小组推荐购买')
      else
        if @refund_record.receiver.present? && @order.receiver != @refund_record.receiver
          @refund_record.errors.add(:receiver, '订单收件人不匹配')
        end
        refund_count = @order.refund_records.where(status: [RefundRecord::PENDING, RefundRecord::COMPLETE]).sum(:quantity)
        if refund_count + @refund_record.quantity > @order.quantity
          @refund_record.errors.add(:quantity, '退货数量总和超过购买数量')
        end
      end
      @refund_record.order_id = @order.id
      @refund_record.status = RefundRecord::PENDING
    end
  end

  def update_refund_record
    @refund_record = RefundRecord.find(params[:id])
    @order = Order.lock.where(id: @refund_record.order_id).includes(:refund_records).take
    old_quantity = @refund_record.quantity
    @refund_record.attributes = update_params
    if old_quantity < @refund_record.quantity && [RefundRecord::COMPLETE, RefundRecord::PENDING].include?(@refund_record.status)
      refund_count = @order.refund_records.where(status: [RefundRecord::PENDING, RefundRecord::COMPLETE]).where.not(id: @refund_record.id).sum(:quantity)
      if refund_count + @refund_record.quantity > @order.quantity
        @refund_record.errors.add(:quantity, '退货数量总和超过购买数量')
      end
    end
  end
end
