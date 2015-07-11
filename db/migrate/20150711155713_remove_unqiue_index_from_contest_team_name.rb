class RemoveUnqiueIndexFromContestTeamName < ActiveRecord::Migration
  def change
    remove_index :contest_teams, column: :name
  end
end
