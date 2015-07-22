class AddReducedPriceAndOriginalPriceLinkToProducts < ActiveRecord::Migration
  def change
    add_column :products, :reduced_price, :decimal, precision: 10, scale: 2
    add_column :products, :original_price_link, :string
  end
end
