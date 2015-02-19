class ServiceToken < ActiveRecord::Base
  before_create :generate_token
  belongs_to :user

  def generate_token
    self.token = SecureRandom.hex + SecureRandom.hex
  end
end
