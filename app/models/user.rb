class User < ActiveRecord::Base
  include Confirmable
  after_create :async_details
  devise :database_authenticatable, :registerable,
    :rememberable, :trackable,
    :omniauthable, omniauth_providers: [:facebook]
  validates :phone, numericality: { only_integer: true, allow_blank: true }
  validates_uniqueness_of :phone, allow_blank: true
  validates_uniqueness_of :email, allow_blank: true
  validates_with EmailPhoneValidator
  has_many :devices

  def to_s
    return self.email if self.email
    self.phone
  end

  def phone= number
     return super(number) unless number
     write_attribute(:phone, number.delete("^0-9"))
  end

  # devise expects this
  def assign_attributes(new_attributes, options={})
    self.attributes=(new_attributes)
  end

  def self.from_facebook(data, token)
    user = where(facebook_uid: data['id']).first
    user = where(email: data['email']).first if user.nil? && data['email']
    user = User.new if user.nil?

    user.password = Devise.friendly_token[0,20] if user.password.blank?
    user.email = data['email'] unless data['email'].nil?
    user.email_verified_at = Time.now
    user.name = data['name'] unless data['name'].nil?
    user.facebook_uid = data['id']
    user.facebook_token = token
    user.save
    user
  end

  def self.from_omniauth(auth)
    user = where(email: auth.info.email).first
    if user == nil
      user = User.new
    end
    user.password = Devise.friendly_token[0,20] if user.password.blank?
    unless user.email
      user.email = auth.info.email
      user.email_verified_at = Time.now
    end
    user.facebook_uid = auth.uid unless user.facebook_uid
    user.name = auth.info.name unless user.name
    user.image = auth.info.image unless user.image
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

  def async_details
    SyncUserWorker.perform_in(10.seconds, self.id)
  end

  def sync_details
    get_facebook_picture
    get_details
    get_gravatar
    Analytics.identify(
      user_id: self.id,
      traits: {
        name: self.name,
        email: self.email,
        phone: self.phone,
        created_at: DateTime.now
      })
  end

  def get_details
    return unless self.facebook_token
    facebook = URI.parse('https://graph.facebook.com/me?access_token=' + self.facebook_token)
    response = Net::HTTP.get_response(facebook)
    if response.code == "200"
      user_data = JSON.parse(response.body)
      User.from_facebook(user_data, self.facebook_token)
    end
  end

  def get_facebook_picture
    return unless self.facebook_token
    facebook = URI.parse('https://graph.facebook.com/me/picture?redirect=false&width=100&height=100&access_token=' + self.facebook_token)
    response = Net::HTTP.get_response(facebook)
    if response.code == "200"
      user_data = JSON.parse(response.body)
      self.image = user_data['data']['url']
      self.save
    end
  end

  def get_gravatar
    return unless self.email
    return unless self.image == nil
    email_address = self.email.downcase
    hash = Digest::MD5.hexdigest(email_address)
    image_src = "https://secure.gravatar.com/avatar/#{hash}?d=mm&s=100"
    self.image = image_src
    self.save
  end
end
