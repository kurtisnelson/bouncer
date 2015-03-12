class AddPhoneAttributesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :phone_verification_code, :string
    add_column :users, :phone_verified, :boolean
  end
end
