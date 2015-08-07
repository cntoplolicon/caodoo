class AddOrderIdToCoupons < ActiveRecord::Migration
  def change
    add_reference :coupons, :order, index: true, foreign_key: true
  end
end
