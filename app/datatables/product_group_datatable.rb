class ProductGroupDatatable < Datatable
  delegate :edit_admin_product_group_path, to: :@view

  def data
    raw_records.map do |group|
      [
        group.name,
        link_to('编辑', edit_admin_product_group_path(group), class: 'btn btn-default')
      ]
    end
  end

  def fetch_records
    records = ProductGroup.all
    records = records.order("#{sort_column} #{sort_direction}")
    records = records.page(page).per(per_page)
    if params[:sSearch].present?
      records = records.where("product_groups.name like :search", search: "%#{params[:sSearch]}%")
    end
    records
  end

  def sortable_columns
    @sortable_columns ||= ['product_groups.name']
  end
end
