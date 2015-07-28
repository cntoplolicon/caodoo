class AddWxPrepayIdToPaymentRecords < ActiveRecord::Migration
  def change
    add_column :payment_records, :prepay_id, :string
  end
end
