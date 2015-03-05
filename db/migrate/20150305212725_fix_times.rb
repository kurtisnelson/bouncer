class FixTimes < ActiveRecord::Migration
  def change
    remove_column :users, :current_sign_in_at
    add_column :users, :current_sign_in_at, :timestamp
    remove_column :users, :last_sign_in_at
    add_column :users, :last_sign_in_at, :timestamp
    remove_column :users, :remember_created_at
    add_column :users, :remember_created_at, :timestamp
    remove_column :users, :confirmed_at
    add_column :users, :confirmed_at, :timestamp
    remove_column :users, :confirmation_sent_at
    add_column :users, :confirmation_sent_at, :timestamp
  end
end
