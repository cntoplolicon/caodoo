class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.references :brand, index: true, foreign_key: true
      t.decimal :price, precision: 10, scale: 2
      t.decimal :original_price, precision: 10, scale: 2

      t.timestamps null: false
    end
  end
end
