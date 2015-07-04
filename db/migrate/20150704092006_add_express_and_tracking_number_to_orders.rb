class AddExpressAndTrackingNumberToOrders < ActiveRecord::Migration
  def change
    add_reference :orders, :express, index: true, foreign_key: true
    add_column :orders, :tracking_number, :string
  end
end
