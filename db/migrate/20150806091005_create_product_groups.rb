class CreateProductGroups < ActiveRecord::Migration
  def change
    create_table :product_groups do |t|
      t.references :primary_product, index: true

      t.timestamps null: false
    end

    add_foreign_key :product_groups, :products, column: :primary_product_id
  end
end
