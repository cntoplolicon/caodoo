class AddNameToProductGroups < ActiveRecord::Migration
  def change
    add_column :product_groups, :name, :string
  end
end
