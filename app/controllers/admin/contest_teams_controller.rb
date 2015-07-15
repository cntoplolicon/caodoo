class Admin::ContestTeamsController < Admin::AdminController
  before_action :find_contest_team, only: [:edit, :update, :reset_password, :do_reset_password]

  def index
    respond_to do |format|
      format.html
      format.json { render json: ::ContestTeamDatatable.new(view_context) }
    end
  end

  def edit
  end

  def update
    if @contest_team.update(update_params)
      redirect_to action: :index
    else
      render 'edit'
    end
  end

  def reset_password
  end

  def do_reset_password
    @contest_team.password = update_password_params[:password]
    @contest_team.password_updated = false
    @contest_team.updating_password = true
    if @contest_team.save
      redirect_to action: :index
    else
      render 'reset_password'
    end
  end

  private

  def find_contest_team
    @contest_team = ContestTeam.find(params[:id])
  end

  def update_password_params
    params.require(:contest_team).permit(:password)
  end

  def update_params
    params.require(:contest_team).permit(:name, :contacts, :phone, :email, :university, :province)
  end
end
