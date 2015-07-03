class ContestTeamDatatable < Datatable
  delegate :edit_admin_contest_team_path, to: :@view

  def data
    raw_records.map do |contest_team|
      [
        contest_team.name,
        contest_team.identifier,
        link_to('重置密码', edit_admin_contest_team_path(contest_team), class: 'btn btn-default')
      ]
    end
  end

  def fetch_records
    records = ContestTeam.all
    records = records.order("#{sort_column} #{sort_direction}")
    records = records.page(page).per(per_page)
    if params[:sSearch].present?
      records = records.where("name like :search or identifier like :search", search: "%#{params[:sSearch]}%")
    end
    records
  end

  def sortable_columns
    @sortable_columns ||= ['name', 'identifier']
  end
end
