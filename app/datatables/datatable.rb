class Datatable
  delegate :params, :link_to, to: :@view

  def initialize(view)
    @view = view
  end

  def raw_records
    @brands ||= fetch_records
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: raw_records.total_count,
      iTotalDisplayRecords: raw_records.total_count,
      aaData: data
    }
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

  def search_columns
    sortable_columns[params[:iSortCol_0].to_i]
  end

  def sort_column
    sortable_columns[params[:iSortCol_0].to_i]
  end
end
