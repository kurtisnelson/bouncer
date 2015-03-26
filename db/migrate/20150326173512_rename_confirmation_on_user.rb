class RenameConfirmationOnUser < ActiveRecord::Migration
  def change
    rename_column :users, :confirmed_at, :email_verified_at
    rename_column :users, :confirmation_sent_at, :phone_confirmation_sent_at
    rename_column :users, :confirmation_token, :email_confirmation_token
    add_column :users, :phone_verified_at, :datetime
    add_column :users, :email_confirmation_sent_at, :datetime
    remove_column :users, :phone_verified, :boolean
  end
end
