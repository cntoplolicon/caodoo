class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.references :user, index: true, foreign_key: true
      t.string :receiver
      t.string :phone
      t.string :province_code
      t.string :city_code
      t.string :district_code
      t.text :detailed_address
      t.boolean :default, default: false
      t.boolean :deleted, default: false

      t.timestamps null: false
    end
  end
end
