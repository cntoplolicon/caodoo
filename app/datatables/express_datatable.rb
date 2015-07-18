class ExpressDatatable < Datatable
  delegate :edit_admin_express_path, :admin_express_path, to: :@view

  def data
    raw_records.map do |express|
      [
        express.name,
        express.code,
        "#{link_to('编辑', edit_admin_express_path(express), class: 'btn btn-default')}
        #{link_to('删除', admin_express_path(express), method: :delete, data: {confirm: '请确认是否删除此快递公司!!'}, class: 'btn btn-default')}"
      ]
    end
  end

  def raw_records
    @records ||= fetch_records
  end

  def fetch_records
    records = Express.all
    records = records.order("#{sort_column} #{sort_direction}")
    records = records.page(page).per(per_page)
    if params[:sSearch].present?
      records = records.where("expresses.name like :search or expresses.code like :search", search: "%#{params[:sSearch]}%")
    end
    records
  end

  def sortable_columns
    @sortable_columns ||= ['expresses.name', 'expresses.code']
  end
end
