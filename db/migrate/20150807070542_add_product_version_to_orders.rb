class AddProductVersionToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :product_version, :string
  end
end
