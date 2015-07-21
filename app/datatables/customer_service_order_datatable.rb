class CustomerServiceOrderDatatable < Datatable
  delegate :customer_service_order_path, :order_status_text, to: :@view

  def data
    raw_records.map do |order|
      [
        link_to(order.order_number, customer_service_order_path(order)),
        order.product_name,
        order.unit_price,
        order.quantity,
        order.total_price,
        order.receiver,
        order.phone,
        order.province_name,
        order.city_name,
        order.district_name,
        order.detailed_address,
        order_status_text(order.status),
        order.try(:contest_team).try(:name),
        order.try(:contest_team).try(:phone),
        order.created_at.strftime('%Y/%m/%d %H:%M:%S'),
        order.updated_at.strftime('%Y/%m/%d %H:%M:%S')
      ]
    end
  end

  def unpaged_records
    records = Order.all.includes(:contest_team).references(:contest_team)
    for i in 0..params[:iColumns].to_i do
      filter = params["sSearch_#{i}"]
      column = sortable_columns[i]
      if filter.present?
        if column.end_with?('unit_price') || column.end_with?('quantity') || column.end_with?('total_price')
          range = filter.split('-yadcf_delim-')
          records = records.where("#{column} >= :search", search: range[0]) if range[0].present?
          records = records.where("#{column} < :search", search: range[1]) if range[1].present?
        elsif column.end_with?('created_at') || column.end_with?('updated_at')
          range = filter.split('-yadcf_delim-')
          records = records.where("#{column} >= :search", search: Time.parse(range[0])) if range[0].present?
          records = records.where("#{column} < :search", search: Time.parse(range[1])) if range[1].present?
        elsif column.end_with?('status')
          records = records.where("#{column} = #{filter}")
        else
          records = records.where("#{column} like '%#{filter}%'")
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
    @sortable_columns ||= ['orders.order_number', 'orders.product_name', 'orders.unit_price', 'orders.quantity', 'orders.total_price',
                           'orders.receiver', 'orders.phone', 'orders.province_name', 'orders.city_name', 'orders.district_name',
                           'orders.detailed_address', 'orders.status', 'contest_teams.name', 'contest_teams.phone',
                           'orders.created_at', 'orders.updated_at']
  end
end
