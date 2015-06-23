class CreateProductViews < ActiveRecord::Migration
  def change
    create_table :product_views do |t|
      t.references :product, index: true, foreign_key: true
      t.string :home_page_description
      t.text :detail_page_description
      t.integer :sale_image_type
      t.text :sale_image_url
      t.text :trailer_image_url
      t.string :trailer_description

      t.timestamps null: false
    end
  end
end
