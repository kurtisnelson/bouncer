class Device < ActiveRecord::Base
  belongs_to :user
  has_many :device_tokens, foreign_key: :resource_owner_id, class: Doorkeeper::DeviceToken
  validates_uniqueness_of :serial

  def device_token
    self.device_tokens.first
  end

  def device_token_id
    return unless device_token
    device_token.id
  end

  def issue_token
    Doorkeeper::DeviceToken.find_or_create_for(nil, self.id, "device", 1.day, true)
  end
end
