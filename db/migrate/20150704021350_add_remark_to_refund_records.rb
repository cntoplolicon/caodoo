class AddRemarkToRefundRecords < ActiveRecord::Migration
  def change
    add_column :refund_records, :remark, :string
  end
end
