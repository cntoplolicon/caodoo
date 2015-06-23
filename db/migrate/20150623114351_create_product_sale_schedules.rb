class CreateProductSaleSchedules < ActiveRecord::Migration
  def change
    create_table :product_sale_schedules do |t|
      t.references :product, index: true, foreign_key: true
      t.datetime :sale_start
      t.datetime :sale_end
      t.datetime :trailer_start
      t.datetime :trailer_end

      t.timestamps null: false
    end
  end
end
