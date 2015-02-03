module DeviceTokenRepresenter
  include Roar::JSON

  property :id
  property :resource_owner_id
  property :refresh_token
  property :expires_in_seconds
  property :token, as: :access_token
end
