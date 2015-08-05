class BrandDatatable < Datatable
  delegate :image_tag, :asset_url, :edit_admin_brand_path, to: :@view
  
  def data
    raw_records.map do |brand|
      [
        brand.name,
        image_tag(asset_url(brand.logo_url, host: Settings.cdn.hosts[rand(Settings.cdn.hosts.length)])),
        link_to('编辑', edit_admin_brand_path(brand), class: 'btn btn-default')
      ]
    end
  end

  def fetch_records
    records = Brand.all
    records = records.order("#{sort_column} #{sort_direction}")
    records = records.page(page).per(per_page)
    if params[:sSearch].present?
      records = records.where("brands.name like :search", search: "%#{params[:sSearch]}%")
    end
    records
  end

  def sortable_columns
    @sortable_columns ||= ['brands.name', 'brands.logo_url']
  end
end
