class Device
  include MongoMapper::Document
  before_create :generate_token

  belongs_to :user
  key :name, String
  key :serial, String, unique: true, required: true
  key :token, String
  timestamps!

  private

  def generate_token
    self.token = SecureRandom.hex 128
  end
end
