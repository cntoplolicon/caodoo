class CreateExpresses < ActiveRecord::Migration
  def change
    create_table :expresses do |t|
      t.string :code, limit: 32
      t.string :name

      t.timestamps null: false
    end
  end
end
