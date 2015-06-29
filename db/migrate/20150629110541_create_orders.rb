class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :order_number
      t.references :user, index: true, foreign_key: true
      t.references :product, index: true, foreign_key: true
      t.string :product_name
      t.text :product_image_url
      t.decimal :unit_price, precision: 10, scale: 2
      t.integer :quantity
      t.decimal :total_price, precision: 10, scale: 2
      t.string :recevier
      t.string :phone
      t.string :detailed_address
      t.string :province_code
      t.string :province_name
      t.string :city_code
      t.string :city_name
      t.string :district_code
      t.string :district_name
      t.integer :status
      t.datetime :receive_time

      t.timestamps null: false
    end
  end
end
