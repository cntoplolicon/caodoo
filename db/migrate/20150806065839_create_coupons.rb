class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.float :money
      t.date :begin_date
      t.date :end_date
      t.integer :state
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
