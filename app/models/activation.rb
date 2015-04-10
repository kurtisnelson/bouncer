class Activation < ActiveRecord::Base
  belongs_to :unit
  belongs_to :user
  has_many :tokens, foreign_key: :resource_owner_id, class: Doorkeeper::ActivationToken
  validates :unit_id, :device_id, :user_id, presence: true
  validates_uniqueness_of :unit_id
  validates_uniqueness_of :device_id

  def token
    self.tokens.first
  end

  def token_id
    return unless token
    token.id
  end

  def issue_token
    Doorkeeper::ActivationToken.find_or_create_for(nil, self.id, "device", 1.day, true)
  end
end
