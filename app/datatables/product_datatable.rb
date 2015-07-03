class ProductDatatable < Datatable
  delegate :admin_product_path, to: :@view
  
  def data
    raw_records.map do |product|
      [
        product.name,
        product.brand.name,
        product.price,
        product.original_price,
        product.contest_level,
        link_to('查看', admin_product_path(product))
      ]
    end
  end

  def raw_records
    @records ||= fetch_records
  end

  def fetch_records
    records = Product.joins(:brand).includes(:brand)
    records = records.order("#{sort_column} #{sort_direction}")
    records = records.page(page).per(per_page)
    if params[:sSearch].present?
      records = products.where("products.name like :search or brands.name like :search", search: "%#{params[:sSearch]}%")
    end
    records
  end

  def sortable_columns
    @sortable_columns ||= ['products.name', 'brands.name', 'products.price', 'products.original_price', 'products.contest_level']
  end
end
