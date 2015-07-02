class AddSalesColumnsToContestTeams < ActiveRecord::Migration
  def change
    add_column :contest_teams, :sales_quantity, :integer, default: 0
    add_column :contest_teams, :sales_price, :integer, default: 0
    add_column :contest_teams, :sales_or_return_quantity, :integer, default: 0
  end
end
