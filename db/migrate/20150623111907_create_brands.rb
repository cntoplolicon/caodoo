class CreateBrands < ActiveRecord::Migration
  def change
    create_table :brands do |t|
      t.string :name
      t.text :logo_url

      t.timestamps null: false
    end
  end
end
