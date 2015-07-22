class ProductDatatable < Datatable
  delegate :edit_admin_product_path, :admin_product_product_carousel_images_path, 
    :admin_product_product_detail_images_path, :admin_product_product_sale_schedules_path, to: :@view
  
  def data
    raw_records.map do |product|
      [
        product.name,
        product.brand.name,
        product.reduced_price,
        product.price,
        product.original_price,
        product.quantity,
        product.contest_level,
        "#{link_to('编辑', edit_admin_product_path(product), class: 'btn btn-default')} 
        #{link_to('查看缩略图', admin_product_product_carousel_images_path(product), class: 'btn btn-default')}
        #{link_to('查看详细图', admin_product_product_detail_images_path(product), class: 'btn btn-default')}
        #{link_to('查看排期', admin_product_product_sale_schedules_path(product), class: 'btn btn-default')}
        "
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
      records = records.where("products.name like :search or brands.name like :search", search: "%#{params[:sSearch]}%")
    end
    records
  end

  def sortable_columns
    @sortable_columns ||= ['products.name', 'brands.name', 'products.reduced_price', 'products.price', 'products.original_price', 'products.contest_level']
  end
end
