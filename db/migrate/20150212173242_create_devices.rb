class CreateDevices < ActiveRecord::Migration
  def change
    enable_extension 'uuid-ossp'
    create_table :devices, id: :uuid do |t|
      t.string :name
      t.string :serial
      t.uuid :user_id
      t.timestamps
    end
  end
end
