class AddIndexToOrderNumbers < ActiveRecord::Migration
  def change
    change_column :orders, :order_number, :string, limit: 32
    add_index :orders, :order_number, unique: true
  end
end
