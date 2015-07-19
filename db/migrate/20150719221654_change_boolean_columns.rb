class ChangeBooleanColumns < ActiveRecord::Migration
  def change
    change_column_null :addresses, :default, false, false
    change_column_null :addresses, :deleted, false, false
    change_column_null :contest_teams, :password_updated, false, false
    change_column_null :expresses, :deleted, false, false
    change_column_null :orders, :delivery_exported, false, false
    change_column_null :regions, :disabled, false, false
  end
end
