class RenameDevices < ActiveRecord::Migration
  def change
    rename_table :devices, :units
  end
end
