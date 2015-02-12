class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, id: :uuid do |t|
      t.string :name
      t.string :email
      t.string :encrypted_password
      t.time :current_sign_in_at
      t.time :last_sign_in_at
      t.string :current_sign_in_ip
      t.string :last_sign_in_ip
      t.integer :sign_in_count
      t.time :remember_created_at
      t.time :confirmed_at
      t.time :confirmation_sent_at
      t.string :confirmation_token
      t.string :unconfirmed_email
      t.string :reset_password_token
      t.time :reset_password_sent_at

      t.string :phone
      t.string :image
      t.boolean :super_admin
      t.string :facebook_uid
      t.string :facebook_token
      t.timestamps
    end
  end
end
