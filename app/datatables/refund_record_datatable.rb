class RefundRecordDatatable < Datatable
  delegate :edit_admin_refund_record_path, :express_info_admin_refund_record_path, :refund_record_status_text, to: :@view
  
  def data
    raw_records.map do |refund_record|
      [
        refund_record.order.order_number,
        refund_record.order.product.name,
        refund_record.quantity,
        refund_record.order.receiver,
        refund_record.order.phone,
        refund_record.order.try(:contest_team).try(:name),
        refund_record.express.name,
        refund_record.tracking_number,
        refund_record_status_text(refund_record.status),
        refund_record.created_at.strftime('%Y/%m/%d %H:%M:%S'),
        refund_record.updated_at.strftime('%Y/%m/%d %H:%M:%S'),
        refund_record.remark,
        avail_ops(refund_record)
      ]
    end
  end

  def unpaged_records
    records = RefundRecord.all
      .joins(:express, order: [:product])
      .includes(:express, order: [:product, :contest_team])
      .references(:express, order: [:product, :contest_team])
    for i in 0..params[:iColumns].to_i do
      filter = params["sSearch_#{i}"]
      column = sortable_columns[i]
      if filter.present?
        if column.end_with?('quantity')
          range = filter.split('-yadcf_delim-')
          records = records.where("#{column} >= :search", search: range[0]) if range[0].present?
          records = records.where("#{column} < :search", search: range[1]) if range[1].present?
        elsif column.end_with?('created_at') || column.end_with?('updated_at')
          range = filter.split('-yadcf_delim-')
          records = records.where("#{sortable_columns[i]} >= :search", search: Time.parse(range[0])) if range[0].present?
          records = records.where("#{sortable_columns[i]} < :search", search: Time.parse(range[1])) if range[1].present?
        elsif sortable_columns[i].end_with?('status')
          records = records.where("#{sortable_columns[i]} = #{filter}")
        else
          records = records.where("#{sortable_columns[i]} like '%#{filter}%'")
        end
      end
    end
    records
  end

  def fetch_records
    records = unpaged_records.order("#{sort_column} #{sort_direction}")
    records = records.page(page).per(per_page)
    records
  end

  def sortable_columns
    @sortable_columns ||= ['orders.order_number', 'products.name', 'refund_records.quantity', 'orders.receiver', 'orders.phone',
                           'contest_teams.name', 'expresses.name', 'refund_records.tracking_number',
                           'refund_records.status', 'refund_records.created_at', 'refund_records.updated_at', 'refund_records.remark']
  end

  private

  def avail_ops(refund_record)
    ret = "#{link_to('编辑', edit_admin_refund_record_path(refund_record), class: 'btn btn-default')}"
    if refund_record.express.present? && refund_record.tracking_number.present?
      ret += "#{link_to('查看物流', express_info_admin_refund_record_path(refund_record), class: 'btn btn-default')}"
    end
    ret
  end
end
