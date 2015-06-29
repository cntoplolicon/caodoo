class CreatePaymentRecords < ActiveRecord::Migration
  def change
    create_table :payment_records do |t|
      t.references :order, index: true, foreign_key: true
      t.integer :payment_type
      t.decimal :amount, precision: 10, scale: 2
      t.datetime :payment_time
      t.integer :status
      t.string :alipay_expire
      t.text :wx_code_url

      t.timestamps null: false
    end
  end
end
