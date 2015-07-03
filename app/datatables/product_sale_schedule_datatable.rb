class ProductSaleScheduleDatatable < Datatable
  delegate :edit_admin_product_product_sale_schedule_path, to: :@view

  def initialize(product, view)
    super(view)
    @product = product
  end

  def data
    raw_records.map do |schedule|
      [
        schedule.sale_start.strftime('%Y/%m/%d %H:%M:%S'),
        schedule.sale_end.strftime('%Y/%m/%d %H:%M:%S'),
        schedule.trailer_start.strftime('%Y/%m/%d %H:%M:%S'),
        schedule.trailer_end.strftime('%Y/%m/%d %H:%M:%S'),
        link_to('编辑', edit_admin_product_product_sale_schedule_path(@product, schedule), class: 'btn btn-default')
      ]
    end
  end

  def fetch_records
    records = @product.product_sale_schedules.all
    records = records.order("#{sort_column} #{sort_direction}")
    records = records.page(page).per(per_page)
  end

  def sortable_columns
    @sortable_columns ||= ['sale_start', 'sale_end', 'trailer_start', 'trailer_end']
  end
end
