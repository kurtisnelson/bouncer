require 'roar/coercion'
module DevicesRepresenter
  include Roar::JSON::JSONAPI
  include Roar::Coercion
  type :devices
  link(:self) { device_url(represented) }

  property :id
  property :name
  property :serial

  property :user_id, as: :user
  property :device_token_id, as: :token

  property :created_at, type: DateTime

  compound do
    property :device_token, as: :tokens, extend: DeviceTokenRepresenter
    property :user, as: :users
  end
end
