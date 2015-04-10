module Doorkeeper
  class ActivationToken < AccessToken
    belongs_to :activation, foreign_key: :resource_owner_id
  end
end
