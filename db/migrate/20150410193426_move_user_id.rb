class MoveUserId < ActiveRecord::Migration
  def change
    remove_column :units, :user_id, :uuid
    add_column :activations, :user_id, :uuid
  end
end
