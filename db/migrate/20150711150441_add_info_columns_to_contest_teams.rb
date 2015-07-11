class AddInfoColumnsToContestTeams < ActiveRecord::Migration
  def change
    add_column :contest_teams, :province, :string
    add_column :contest_teams, :contacts, :string
  end
end
