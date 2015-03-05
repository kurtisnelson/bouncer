class FixPasswordReset < ActiveRecord::Migration
  def change
    remove_column :users, :reset_password_sent_at
    add_column :users, :reset_password_sent_at, :timestamp
  end
end
