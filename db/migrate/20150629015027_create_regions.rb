class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions do |t|
      t.integer :code
      t.string :name
      t.string :parent

      t.timestamps null: false
    end
    add_index :regions, :code
  end
end
