module Doorkeeper
  class DeviceToken < AccessToken
    belongs_to :device, foreign_key: :resource_owner_id

  end
end
