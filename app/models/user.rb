class User
  include MongoMapper::Document
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :confirmable,
    :omniauthable, omniauth_providers: [:facebook]

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
  key :reset_password_token, String
  key :reset_password_sent_at, Time

  key :name, String
  key :phone, String
  key :image, String
  key :super_admin, Boolean
  key :facebook_uid, String

  def self.from_facebook(data)
    user = where(facebook_uid: data['id']).first
    if user == nil
      user = User.new
    end
    user.password = Devise.friendly_token[0,20] if user.password.blank?
    user.facebook_uid = data['id']
    user.email = data['email']
    user.name = data['name']
    user.confirm!
    user.save
    user
  end

  def self.from_omniauth(auth)
    user = where(email: auth.info.email).first
    if user == nil
      user = User.new
    end
    user.email = auth.info.email
    user.password = Devise.friendly_token[0,20] if user.password.blank?
    user.facebook_uid = auth.uid
    user.name = auth.info.name
    user.image = auth.info.image
    user.confirm!
    user.save
    user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
end
