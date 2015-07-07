class ContestTeamDashboardController < ApplicationController

  layout 'contest_team_dashboard'

  protected 

  def require_login_and_reset_password
    !require_login and return
    unless @contest_team.password_updated
      unless params[:action] == 'edit' && params[:controller] == 'contest_teams'
        redirect_to edit_contest_team_path(@contest_team)
      end
    end
  end

  def require_login
    team_id = (params[:controller] == 'contest_teams' ? params[:id] : params[:contest_team_id]).to_i
    redirect_to login_contest_teams_path and return false if session[:login_contest_team_id].nil?
    head :forbidden and return false if team_id != session[:login_contest_team_id]
    @contest_team = ContestTeam.find(team_id)
    true
  end
end
