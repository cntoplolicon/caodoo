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

  def edit
    @contest_team = ContestTeam.find(params[:id])
  end

  def update
    @contest_team = ContestTeam.find(params[:id])
    unless @contest_team.authenticate(params[:old_password])
      @contest_team.errors.add(:old_password, '原密码错误')
    else
      @contest_team.password = params[:contest_team][:password]
      @contest_team.password_confirmation = params[:contest_team][:password_confirmation]
    end
    if @contest_team.errors.empty? && @contest_team.save
      redirect_to action: :show
    else
      render 'edit'
    end
  end

  def show
    @total_statistics = {
    }
  end
end
