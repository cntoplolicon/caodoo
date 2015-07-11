class AddQuantityToRefundRecords < ActiveRecord::Migration
  def change
    add_column :refund_records, :quantity, :integer
  end
end
