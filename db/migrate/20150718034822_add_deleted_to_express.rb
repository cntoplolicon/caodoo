class AddDeletedToExpress < ActiveRecord::Migration
  def change
    add_column :expresses, :deleted, :boolean, default: false
  end
end
