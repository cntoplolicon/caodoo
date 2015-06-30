class AddAddressIdToOrder < ActiveRecord::Migration
  def change
    add_reference :orders, :address, index: true, foreign_key: true
  end
end
