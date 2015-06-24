class CreateProductDetailImages < ActiveRecord::Migration
  def change
    create_table :product_detail_images do |t|
      t.references :product_view, index: true, foreign_key: true
      t.integer :position
      t.text :url

      t.timestamps null: false
    end
  end
end
