class AddUniqueIndexToContestTeamsPhone < ActiveRecord::Migration
  def change
    change_column :contest_teams, :phone, :string, limit: 48
    add_index :contest_teams, :phone, unique: true
  end
end
