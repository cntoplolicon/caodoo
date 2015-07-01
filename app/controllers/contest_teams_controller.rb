class ContestTeamsController < ApplicationController
  def login
    @contest_team = ContestTeam.new
  end

  def do_login
    @contest_team = ContestTeam.find_by_name(params[:contest_team][:name])
    unless @contest_team.present?
      @contest_team = ContestTeam.new
      @contest_team.name = params[:contest_team][:name]
      @contest_team.errors.add(:name, '小组不存在')
      render 'login' and return
    end
    unless @contest_team.authenticate(params[:contest_team][:password])
      @contest_team.errors.add(:password, '密码不正确')
      render 'login' and return
    end
    session[:login_contest_team_id] = @contest_team.id
    redirect_to contest_team_path(@contest_team)
  end

  def update
  end

  def show
  end
end
