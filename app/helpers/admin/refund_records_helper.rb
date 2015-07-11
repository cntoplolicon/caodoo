module Admin::RefundRecordsHelper
  def refund_record_status_text(status)
    case status
    when RefundRecord::PENDING
      '正在处理'
    when RefundRecord::COMPLETE
      '退货成功'
    when RefundRecord::CANCELLED
      '作废'
    end
  end
end
