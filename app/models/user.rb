class User
  include MongoMapper::Document
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :confirmable

  key :email, String
  key :encrypted_password, String
  key :current_sign_in_at, Time
  key :last_sign_in_at, Time
  key :current_sign_in_ip, String
  key :last_sign_in_ip, String
  key :sign_in_count, Integer
  key :remember_created_at, Time
  key :confirmed_at, Time
  key :confirmation_sent_at, Time
  key :confirmation_token, String
  key :unconfirmed_email, String
end
