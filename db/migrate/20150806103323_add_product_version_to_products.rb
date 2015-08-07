class AddProductVersionToProducts < ActiveRecord::Migration
  def change
    add_column :products, :product_version, :string
  end
end
