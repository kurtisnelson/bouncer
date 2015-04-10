class CreateActivations < ActiveRecord::Migration
  def change
    create_table :activations, id: :uuid do |t|
      t.uuid :device_id
      t.uuid :unit_id
      t.timestamps
    end
  end
end
