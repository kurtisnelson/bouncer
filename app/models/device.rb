class Device
  include MongoMapper::Document
  after_create :issue_token

  belongs_to :user
  many :device_tokens, foreign_key: :resource_owner_id, class: Doorkeeper::DeviceToken
  key :name, String
  key :serial, String, unique: true, required: true

  timestamps!

  def device_token
    self.device_tokens.first
  end

  private

  def issue_token
    Doorkeeper::DeviceToken.find_or_create_for(nil, self.id, "machine", 1.day, true)
  end
end
