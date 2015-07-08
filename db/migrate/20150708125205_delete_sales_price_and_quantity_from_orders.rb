class DeleteSalesPriceAndQuantityFromOrders < ActiveRecord::Migration
  def change
    remove_column :contest_teams, :sales_price
    remove_column :contest_teams, :sales_or_return_quantity
  end
end
