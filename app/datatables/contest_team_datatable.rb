class ContestTeamDatatable < Datatable
  delegate :edit_admin_contest_team_path, :reset_password_admin_contest_team_path, to: :@view

  def data
    raw_records.map do |contest_team|
      [
        contest_team.name,
        contest_team.contacts,
        contest_team.phone,
        contest_team.university,
        contest_team.province,
        contest_team.email,
        contest_team.sales_quantity,
        contest_team.password_updated ? '是' : '否',
        "#{link_to('编辑', edit_admin_contest_team_path(contest_team), class: 'btn btn-default')}
        #{link_to('重置密码', reset_password_admin_contest_team_path(contest_team), class: 'btn btn-default')}"
      ]
    end
  end

  def unpaged_records
    records = ContestTeam.all
    for i in 0..params[:iColumns].to_i do
      filter = params["sSearch_#{i}"]
      column = sortable_columns[i]
      if filter.present?
        if column.end_with?('sales_quantity')
          range = filter.split('-yadcf_delim-')
          records = records.where("#{column} >= :search", search: range[0]) if range[0].present?
          records = records.where("#{column} < :search", search: range[1]) if range[1].present?
        elsif column.end_with?('password_updated')
          records = records.where("#{column} = ?", filter)
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
    @sortable_columns ||= ['name', 'contacts', 'phone', 'university', 'province', 'email', 'sales_quantity', 'password_updated']
  end
end
