class AddDisabledToRegions < ActiveRecord::Migration
  def change
    add_column :regions, :disabled, :boolean, default: false
  end
end
