class AddDeliveryExportedToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :delivery_exported, :boolean, default: false
  end
end
