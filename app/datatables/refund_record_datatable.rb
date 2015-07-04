class RefundRecordDatatable < Datatable
  delegate :image_tag, :edit_admin_refund_record_path, :refund_record_status_text, to: :@view
  
  def data
    raw_records.map do |refund_record|
      [
        refund_record.order.order_number,
        refund_record.order.product.name,
        refund_record.order.receiver,
        refund_record.order.phone,
        refund_record.order.try(:contest_team).try(:name),
        refund_record.express.name,
        refund_record.tracking_number,
        refund_record_status_text(refund_record.status),
        refund_record.created_at.strftime('%Y/%m/%d %H:%M:%S'),
        refund_record.remark,
        link_to('编辑', edit_admin_refund_record_path(refund_record), class: 'btn btn-default')
      ]
    end
  end

  def fetch_records
    records = RefundRecord.all
      .joins(:express, order: [:product, :contest_team])
      .includes(:express, order: [:product, :contest_team])
    for i in 0..params[:iColumns].to_i do
      filter = params["sSearch_#{i}"]
      if filter.present?
        if filter.include?('-yadcf_delim-')
          range = filter.split('-yadcf_delim-')
          records = records.where("#{sortable_columns[i]} >= :search", search: Time.parse(range[0])) if range[0]
          records = records.where("#{sortable_columns[i]} < :search", search: Time.parse(range[1])) if range[1]
        elsif sortable_columns[i].end_with?('status')
          records = records.where("#{sortable_columns[i]} = #{filter}")
        else
          records = records.where("#{sortable_columns[i]} like '%#{filter}%'")
        end
      end
    end
    records = records.order("#{sort_column} #{sort_direction}")
    records = records.page(page).per(per_page)
    records
  end

  def sortable_columns
    @sortable_columns ||= ['orders.order_number', 'products.name', 'orders.receiver', 'orders.phone',
                           'contest_teams.name', 'expresses.name', 'refund_records.tracking_number',
                           'refund_records.status', 'refund_records.created_at', 'refund_records.remark']
  end
end
