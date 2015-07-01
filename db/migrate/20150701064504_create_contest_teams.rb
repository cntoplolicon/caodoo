class CreateContestTeams < ActiveRecord::Migration
  def change
    create_table :contest_teams do |t|
      t.string :identifier, limit: 48
      t.string :name, limit: 48
      t.string :password_digest
      t.string :university, limit: 48
      t.string :area, limit: 48

      t.timestamps null: false
    end
    add_index :contest_teams, :identifier, unique: true
    add_index :contest_teams, :name, unique: true
    add_index :contest_teams, :university
    add_index :contest_teams, :area
  end
end
