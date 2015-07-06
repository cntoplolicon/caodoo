class AddPhoneAndEmailToContestTeams < ActiveRecord::Migration
  def change
    add_column :contest_teams, :phone, :string
    add_column :contest_teams, :email, :string
  end
end
