class AddContestTeamToOrders < ActiveRecord::Migration
  def change
    add_reference :orders, :contest_team, index: true, foreign_key: true
  end
end
