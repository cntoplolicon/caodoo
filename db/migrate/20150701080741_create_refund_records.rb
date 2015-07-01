class CreateRefundRecords < ActiveRecord::Migration
  def change
    create_table :refund_records do |t|
      t.references :order, index: true, foreign_key: true
      t.references :express, index: true, foreign_key: true
      t.string :tracking_number
      t.integer :status

      t.timestamps null: false
    end
  end
end
