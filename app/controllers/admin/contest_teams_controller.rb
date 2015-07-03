class Admin::ContestTeamsController < Admin::AdminController
  before_action :find_contest_team, only: [:edit, :update]

  def index
    respond_to do |format|
      format.html
      format.json { render json: ::ContestTeamDatatable.new(view_context) }
    end
  end

  def edit
  end

  def update
    if @contest_team.update(contest_team_params)
      redirect_to action: :index
    else
      render 'edit'
    end
  end

  private

  def find_contest_team
    @contest_team = ContestTeam.find(params[:id])
  end

  def contest_team_params
    params.require(:contest_team).permit(:password)
  end
end
