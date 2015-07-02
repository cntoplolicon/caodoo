class AddIntColumnsToProducts < ActiveRecord::Migration
  def change
    add_column :products, :priority, :integer, default: 0
    add_column :products, :quantity, :integer, default: 0
    add_column :products, :contest_level, :integer
  end
end
