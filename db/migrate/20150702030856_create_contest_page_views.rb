class CreateContestPageViews < ActiveRecord::Migration
  def change
    create_table :contest_page_views do |t|
      t.integer :contest_team_id
      t.string :request_ip

      t.timestamps null: false
    end
  end
end
