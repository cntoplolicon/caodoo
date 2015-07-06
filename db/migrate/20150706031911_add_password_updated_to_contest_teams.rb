class AddPasswordUpdatedToContestTeams < ActiveRecord::Migration
  def change
    add_column :contest_teams, :password_updated, :boolean, default: false
  end
end
